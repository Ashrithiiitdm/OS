#include "types.h"
#include "stat.h"
#include "user.h"

void spin(int duration) {
    uint start = uptime();
    while(uptime() - start < duration) { }
}

int main(void) {
    int pid1, pid2, pid3;
    int orig_priority;

    // Test 1: Get default priority
    int pid = getpid();
    printf(1, "\nTest 1: Checking default priority\n");
    orig_priority = get_priority(pid);
    printf(1, "Default priority: %d\n", orig_priority);
    if(orig_priority != 10)
        printf(1, "TEST 1 FAILED: Default priority should be 10\n");
    else
        printf(1, "TEST 1 PASSED\n");

    // Test 2: Set and Get Priority
    printf(1, "\nTest 2: Testing setpriority and getpriority\n");
    if(set_priority(pid, 5) < 0) {
        printf(1, "TEST 2 FAILED: Could not set priority\n");
        exit();
    }
    if(get_priority(pid) != 5) {
        printf(1, "TEST 2 FAILED: Priority not set correctly\n");
    } else {
        printf(1, "TEST 2 PASSED\n");
    }

    // Test 3: Priority Scheduling
    printf(1, "\nTest 3: Testing priority-based scheduling\n");
    
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