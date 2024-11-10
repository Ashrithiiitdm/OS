#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int parent_pid = getpid();
    int parent_priority = get_priority(parent_pid);
    
    printf(1, "Parent Process: PID = %d, Priority = %d\n", parent_pid, parent_priority);
    
    // Create a child process
    int pid = fork();
    
    if (pid < 0) {
        // fork failed
        printf(1, "Fork failed!\n");
        exit();
    } else if (pid == 0) {
        // This is the child process
        int child_pid = getpid();
        int child_priority = parent_priority + 1; // Higher priority than parent

        // Set higher priority for the child process
        set_priority(child_pid, child_priority);
        printf(1, "Child Process: PID = %d, Priority = %d\n", child_pid, child_priority);

        // Now decrease the priority of the child to allow the parent to run
        set_priority(child_pid, parent_priority - 1);

        // After parent completes, child continues
        int final_child_priority = get_priority(child_pid);
        printf(1, "Child Process Resumed: PID = %d, Priority = %d\n", child_pid, final_child_priority);

        printf(1, "Last execution after decreaseing the priority\n");

        // End child process
        exit();
    } else {
        // This is the parent process, waiting for the child to finish
        sleep(1);
        
        // After child resumes, parent process will not execute further code
        int final_parent_priority = get_priority(parent_pid);
        printf(1, "Parent Process Ends: PID = %d, Priority = %d\n", parent_pid, final_parent_priority);
    }
    
    exit();
}
