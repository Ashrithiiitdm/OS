#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Log levels
#define INFO    "INFO"
#define WARNING "WARNING"
#define ERROR   "ERROR"

// Log file name
#define LOG_FILE "activity_log.txt"

// Function to get current timestamp
void get_timestamp(char *timestamp, size_t size) {
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    strftime(timestamp, size, "%Y-%m-%d %H:%M:%S", tm_info);
}

// Function to write a log entry to the log file
void write_log(const char *level, const char *message) {
    FILE *log_file = fopen(LOG_FILE, "a");
    if (log_file == NULL) {
        perror("Error opening log file");
        return;
    }

    char timestamp[20];
    get_timestamp(timestamp, sizeof(timestamp));

    fprintf(log_file, "[%s] [%s] %s\n", timestamp, level, message);
    fclose(log_file);
}

// Function to log an info message
void log_info(const char *message) {
    write_log(INFO, message);
}

// Function to log a warning message
void log_warning(const char *message) {
    write_log(WARNING, message);
}

// Function to log an error message
void log_error(const char *message) {
    write_log(ERROR, message);
}

// Function to simulate an action and log it
void perform_action(const char *action) {
    if (action == NULL) {
        log_error("Invalid action performed.");
        return;
    }

    log_info(action);
}

int main() {
    char action[256];
    
    // Start logging
    log_info("Activity Logger started.");

    while (1) {
        printf("Enter an action (or type 'exit' to quit): ");
        fgets(action, sizeof(action), stdin);
        action[strcspn(action, "\n")] = '\0';  // Remove newline character

        if (strcmp(action, "exit") == 0) {
            log_info("Activity Logger stopped.");
            break;
        }

        perform_action(action);
    }

    return 0;
}
