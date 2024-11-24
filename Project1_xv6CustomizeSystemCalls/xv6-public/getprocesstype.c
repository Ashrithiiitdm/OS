#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {
    int zombie_pid, orphan_pid;

    // Create a zombie process
    zombie_pid = fork();
    if (zombie_pid == 0) {
        // Child process immediately exits
        printf(1, "Child (Zombie PID: %d) exiting\n", getpid());
        exit();
    } else if (zombie_pid > 0) {
        // Parent does NOT call wait() to retrieve the child's status
        sleep(50); // Allow time for the child to become a zombie
    }

    // Check if the child process is a zombie
    int type = get_process_type(zombie_pid);
    if (type == 1) {
        printf(1, "Process %d is a zombie\n", zombie_pid);
    } else {
        printf(1, "Process %d is NOT a zombie (Type: %d)\n", zombie_pid, type);
    }

    // Create an orphan process
    orphan_pid = fork();
    if (orphan_pid == 0) {
        // Child process will outlive its parent
        printf(1, "Child (Orphan PID: %d) created\n", getpid());
        sleep(100); // Simulate some work
        // Check if the child has become an orphan
        type = get_process_type(getpid());
        if (type == 0) {
            printf(1, "Child (PID: %d) is now an orphan\n", getpid());
        }
        exit();
    } else if (orphan_pid > 0) {
        // Parent process exits before the child
        printf(1, "Parent process (PID: %d) exiting, making child an orphan\n", getpid());
        exit();
    }

    return 0;
}
