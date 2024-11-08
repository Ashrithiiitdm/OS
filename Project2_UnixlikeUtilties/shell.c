#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void execute_command(char *command);

int main() {
    char command[256];

    while (1) {
        printf("ashrith> ");
        if (!fgets(command, sizeof(command), stdin)) break; // Exit on EOF

        command[strcspn(command, "\n")] = 0; // Remove newline character

        if (strcmp(command, "exit") == 0) break; // Exit command

        execute_command(command);
    }

    return 0;
}

void execute_command(char *command) {
   // Here you can parse the command and call the appropriate utility functions.
   int status = system(command);

    if(status==-1){
        perror("Error in the system");
    }//else{
    //     printf("Command executed successfully\n");
    // }

   // This is a placeholder implementation.
//    printf("Executing: %s\n", command);
   // Add logic to call corresponding utility functions based on command input.
}