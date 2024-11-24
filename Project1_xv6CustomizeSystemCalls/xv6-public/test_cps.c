#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
    int pid;

    // Start some background processes
    for (int i = 0; i < 3; i++) { // Create 3 background processes
        pid = fork();
        if (pid < 0) {
            printf(1, "Fork failed\n");
            exit();
        } else if (pid == 0) {
            // Child process
            for (volatile int j = 0; j < 1e8; j++); // Simulate work
            exit(); // End child process
        }
        // Parent continues to create more processes
    }

    // // Wait for all child processes to finish
    // for (int i = 0; i < 3; i++) {
    //     wait();
    // }

    cps();
    exit();
}
