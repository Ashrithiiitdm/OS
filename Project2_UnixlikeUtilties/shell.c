#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <termios.h>
#include <fcntl.h>
#include <dirent.h>

#define HISTORY_FILE "history.txt"
#define MAX_HISTORY 100
#define MAX_COMMAND_LENGTH 256

char history[MAX_HISTORY][MAX_COMMAND_LENGTH];
int history_count = 0;

void load_history() {
    FILE *file = fopen(HISTORY_FILE, "r");
    if (!file) return;

    char line[MAX_COMMAND_LENGTH];
    while (fgets(line, sizeof(line), file)) {
        line[strcspn(line, "\n")] = 0; // Remove newline
        strcpy(history[history_count++], line);
    }
    fclose(file);
}

void save_history(const char *command) {
    if (history_count < MAX_HISTORY) {
        strcpy(history[history_count++], command);
    }

    FILE *file = fopen(HISTORY_FILE, "a");
    if (file) {
        fprintf(file, "%s\n", command);
        fclose(file);
    }
}

void show_history() {
    for (int i = 0; i < history_count; ++i) {
        printf("%d: %s\n", i + 1, history[i]);
    }
}

int getch() {
    struct termios oldt, newt;
    int ch;
    tcgetattr(STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    ch = getchar();
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    return ch;
}

void auto_complete(char *buffer, int *pos) {
    char prefix[MAX_COMMAND_LENGTH] = {0};
    int start = *pos - 1;

    // Find the start of the last word
    while (start >= 0 && buffer[start] != ' ') {
        start--;
    }
    start++; // Move to the first character of the last word

    // Copy the last word into prefix
    strncpy(prefix, buffer + start, *pos - start);
    prefix[*pos - start] = '\0';
    // printf("%s\n",prefix);

    DIR *dir = opendir("."); // Open the current directory
    if (!dir) {
        perror("opendir failed");
        return;
    }

    struct dirent *entry;
    char matches[100][MAX_COMMAND_LENGTH]; // Array to store matching entries
    int match_count = 0;

    // Search for matching files or directories
    while ((entry = readdir(dir)) != NULL) {
        if (strncmp(entry->d_name, prefix, strlen(prefix)) == 0) {
            strncpy(matches[match_count++], entry->d_name, MAX_COMMAND_LENGTH);
        }
    }
    closedir(dir);

    if (match_count == 0) {
        printf("\nNo matches found.\n");
        printf("\033[1;32mmyShell? \033[0m%s", buffer);
    } else if (match_count == 1) {
        // If only one match, auto-complete it
        char rem[MAX_COMMAND_LENGTH];
        int rem_length = strlen(matches[0])-strlen(prefix);
        strncpy(rem, matches[0]+strlen(prefix),rem_length);
        strcat(buffer, rem);
        *pos = strlen(buffer);
        printf("%s", rem);
    } else {
        // Show all matches if multiple
        printf("\n");
        for (int i = 0; i < match_count; i++) {
            printf("%s  ", matches[i]);
        }
        printf("\n\033[1;32mmyShell? \033[0m%s", buffer);
    }
    fflush(stdout);
}


void read_command_with_history(char *command) {
    int index = history_count; // Start index for navigating history
    int pos = 0; // Position in the buffer
    char buffer[MAX_COMMAND_LENGTH] = {0}; // Command buffer
    char c;

    printf("\033[1;32mmyShell? \033[0m");
    fflush(stdout);

    while ((c = getch()) != '\n') { // Loop until Enter is pressed
        if (c == 27) { // Arrow keys (escape sequence starts with 27)
            getch();  // Skip '['
            char arrow = getch();
            if (arrow == 'A') { // Up arrow
                if (index > 0) index--;
                strcpy(buffer, history[index]);
                pos = strlen(buffer);
                printf("\33[2K\r\033[1;32mmyShell? \033[0m%s", buffer);
                fflush(stdout);
            } else if (arrow == 'B') { // Down arrow
                if (index < history_count) index++;
                strcpy(buffer, index < history_count ? history[index] : "");
                pos = strlen(buffer);
                printf("\33[2K\r\033[1;32mmyShell? \033[0m%s", buffer);
                fflush(stdout);
            }
        } else if (c == '\t') { // TAB key for auto-completion
            auto_complete(buffer, &pos);
        } else if (c == 127) { // Backspace
            if (pos > 0) {
                buffer[--pos] = '\0';
                printf("\33[2K\r\033[1;32mmyShell? \033[0m%s", buffer);
                fflush(stdout);
            }
        } else {
            buffer[pos++] = c;
            buffer[pos] = '\0';
            printf("%c", c);
            fflush(stdout);
        }
    }
    buffer[pos] = '\0';
    strcpy(command, buffer); // Copy the final command to the command variable
    // printf("%s\n",command);
    printf("\n");
}



void execute_command(char *command) {
    clock_t start, end;
    double time;

    start = clock();
    int status = system(command);
    end = clock();

    time = ((double)(end - start) / CLOCKS_PER_SEC) * 1000;
    printf("\n\033[1;35mCPU time: \033[0m %.4fms\n", time);

    if (status == -1) {
        perror("Error in system call");
    }
}


int main() {
    char command[MAX_COMMAND_LENGTH];

    load_history();


    while (1) {
        read_command_with_history(command);

        if (strlen(command) == 0) continue; // Ignore empty input

        if (strcmp(command, "exit") == 0) {
            printf("\033[1;36m:) Bye Bye !...\n\033[0m"); 
            break;
        }
        if (strcmp(command, "history") == 0) {
            show_history();
            continue;
        }

        save_history(command);
        execute_command(command);
    }

    return 0;
}
