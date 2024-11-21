#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

#define WALKTALK_MAX_DIALOGUE 1024
#define WALKTALK_END_CHAR '\0'  // Special character to end dialogue
#define MAX_WALKTALKS 32        // Maximum number of simultaneous walktalks

struct walktalk {
    struct spinlock lock;
    char dialogue[WALKTALK_MAX_DIALOGUE];  // Dialogue buffer
    int dialogue_len;                      // Current dialogue length
    int is_talker_turn;                    // Current turn status
    int is_active;                         // Is walkie talkie active
    int refs;                              // Reference count
};

// Global walkie talkie array
struct {
    struct spinlock lock;
    struct walktalk walktalks[MAX_WALKTALKS];
} walktalk_table;

// Function prototypes
int walktalk_alloc(void);
void walktalk_close(int);

// Initialize walkie talkie system
void walktalk_init(void) {
    initlock(&walktalk_table.lock, "walktalk_table");
    for (int i = 0; i < MAX_WALKTALKS; i++) {
        struct walktalk *wt = &walktalk_table.walktalks[i];
        initlock(&wt->lock, "walktalk");
        wt->is_active = 0;
        wt->refs = 0;
    }
}

// Allocate a new walkie talkie
int walktalk_alloc(void) {
    acquire(&walktalk_table.lock);
    
    for (int i = 0; i < MAX_WALKTALKS; i++) {
        struct walktalk *wt = &walktalk_table.walktalks[i];
        
        if (!wt->is_active) {
            wt->is_active = 1;
            wt->dialogue_len = 0;
            wt->is_talker_turn = 1;  // First turn is for the first user
            wt->refs = 2;  // Two endpoints
            
            release(&walktalk_table.lock);
            return i;
        }
    }
    
    release(&walktalk_table.lock);
    return -1;
}

// System call to create a walkie talkie
int sys_walktalk_create(void) {
    return walktalk_alloc();
}

// System call to write to walkie talkie
int sys_walktalk_write(int walkid, char *buf, int len) {
    if (walkid < 0 || walkid >= MAX_WALKTALKS)
        return -1;
    
    struct walktalk *wt = &walktalk_table.walktalks[walkid];
    
    acquire(&wt->lock);
    
    // Check if active and if it's talker's turn
    if (!wt->is_active || !wt->is_talker_turn) {
        release(&wt->lock);
        return -1;
    }
    
    // Check buffer space
    if (wt->dialogue_len + len > WALKTALK_MAX_DIALOGUE) {
        release(&wt->lock);
        return -1;
    }
    
    // Copy dialogue
    memmove(wt->dialogue + wt->dialogue_len, buf, len);
    wt->dialogue_len += len;
    
    // Check for end of dialogue
    if (len > 0 && buf[len-1] == WALKTALK_END_CHAR) {
        // Switch turns
        wt->is_talker_turn = 0;
        wakeup(wt);
    }
    
    release(&wt->lock);
    return len;
}

// System call to read from walkie talkie
int sys_walktalk_read(int walkid, char *buf, int len) {
    if (walkid < 0 || walkid >= MAX_WALKTALKS)
        return -1;
    
    struct walktalk *wt = &walktalk_table.walktalks[walkid];
    
    acquire(&wt->lock);
    
    // Wait until it's not talker's turn
    while (wt->is_active && wt->is_talker_turn) {
        sleep(wt, &wt->lock);
    }
    
    // Check if still active
    if (!wt->is_active) {
        release(&wt->lock);
        return 0;
    }
    
    // Copy dialogue
    int copy_len = min(len, wt->dialogue_len);
    if (copy_len > 0) {
        memmove(buf, wt->dialogue, copy_len);
    }
    
    // Reset for next turn
    wt->dialogue_len = 0;
    wt->is_talker_turn = 1;
    
    release(&wt->lock);
    return copy_len;
}

// System call to close walkie talkie
int sys_walktalk_close(int walkid) {
    if (walkid < 0 || walkid >= MAX_WALKTALKS)
        return -1;
    
    struct walktalk *wt = &walktalk_table.walktalks[walkid];
    
    acquire(&wt->lock);
    
    // Decrement reference count
    wt->refs--;
    
    // If no more references, free the walkie talkie
    if (wt->refs <= 0) {
        wt->is_active = 0;
        wakeup(wt);
    }
    
    release(&wt->lock);
    return 0;
}