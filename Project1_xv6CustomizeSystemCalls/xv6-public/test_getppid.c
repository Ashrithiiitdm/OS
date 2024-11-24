#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int parent_pid = getpid(); // Get the parent process ID
    printf(1,"Parent:My id is %d\n",parent_pid);
    int pid = fork();          // Fork a child process

    if (pid < 0) {
        printf(1,"Fork failed\n");
        exit();
    }

    if (pid == 0) {
        // Child process
        int ppid = getppid(getpid());
        printf(1,"Child: My parent PID is %d, expected %d\n", ppid, parent_pid);
        if (ppid != parent_pid) {
            printf(1,"Test failed: Parent PID mismatch\n");
            exit();
        } else {
            printf(1,"Test passed\n");
            exit();
        }
    } else {
        // Parent process
        wait(); // Wait for the child to finish
    }

    exit();
}
