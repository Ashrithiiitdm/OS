#include "types.h"
#include "stat.h"
#include "user.h"

void spin(int duration) {
    uint start = uptime();
    while(uptime() - start < duration) { }
}

int main(void) {
    int pid1, pid2, pid3;

    // Test : Priority Scheduling
    printf(1, "\nTest: Testing priority-based scheduling\n");
    
    // Create first child with low priority (higher number)
    if((pid1 = fork()) == 0) {
        int cur_pid1 = getpid();
        set_priority(cur_pid1,12);  // Lower priority
        sleep(20); //buffer for the prirority to be set
        printf(1, "Low priority process (pid %d) starting\n", getpid());
        spin(100);  // Spin for some time
        printf(1, "Low priority process (pid %d) finishing\n", getpid());
        exit();
    }

    // Create second child with medium priority
    if((pid2 = fork()) == 0) {
        int cur_pid2 = getpid();
        set_priority(cur_pid2,15);  // Medium priority
        sleep(20); //buffer for prirotiy to be set
        printf(1, "Medium priority process (pid %d) starting\n", getpid());
        spin(100);  // Spin for some time
        printf(1, "Medium priority process (pid %d) finishing\n", getpid());
        exit();
    }

    // Create third child with high priority
    if((pid3 = fork()) == 0) {
        int cur_pid3 = getpid();
        set_priority(cur_pid3,20);   // Higher priority (lower number)
        sleep(20); //buffer for the priroity to be set
        printf(1, "High priority process (pid %d) starting\n", getpid());
        spin(100);  // Spin for some time
        printf(1, "High priority process (pid %d) finishing\n", getpid());
        exit();
    }

    // Wait for all children to complete
    wait();
    wait();
    wait();

    printf(1, "All tests completed!\n");
    exit();
}