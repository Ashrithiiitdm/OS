// Identifying Junk Files:

// The is_junk_file() function checks if a file's name contains the .tmp, .log, or .bak extensions using strstr().
// If any of these substrings are found, the file is considered a junk file.
// Calculating File Sizes:

// The get_file_size() function uses the stat() system call to retrieve the size of a file in bytes.
// This size is displayed alongside the file name.
// Deleting Files:

// The delete_file() function uses remove() to delete the specified file.
// If the file is successfully deleted, a success message is shown; otherwise, an error message is displayed.
// User Menu:

// A simple text-based menu allows the user to:
// Scan a directory for junk files and display their sizes.
// Delete a specific file by providing its full path.
// Exit the program.
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>

// Function to check if a file is a junk file based on its extension
int is_junk_file(const char *filename) {
    // Check for .tmp, .log, .bak extensions
    if (strstr(filename, ".tmp") || strstr(filename, ".log") || strstr(filename, ".bak")) {
        return 1;  // It's a junk file
    }
    return 0;  // Not a junk file
}

// Function to get the size of a file using stat
void get_file_size(const char *filepath) {
    struct stat st;
    if (stat(filepath, &st) == 0) {
        printf("File: %s, Size: %lld bytes\n", filepath, (long long)st.st_size);
    } else {
        perror("Error retrieving file size");
    }
}

// Function to delete a file
void delete_file(const char *filepath) {
    if (remove(filepath) == 0) {
        printf("File deleted successfully: %s\n", filepath);
    } else {
        perror("Error deleting file");
    }
}

// Function to scan a directory and list junk files
void scan_directory(const char *path) {
    struct dirent *entry;
    DIR *dp = opendir(path);

    if (dp == NULL) {
        perror("opendir");
        return;
    }

    long total_size = 0;
    while ((entry = readdir(dp))) {
        // Only check regular files
        if (entry->d_type == DT_REG) {
            // Check if the file is a junk file
            if (is_junk_file(entry->d_name)) {
                printf("Junk File: %s\n", entry->d_name);
                char filepath[512];
                snprintf(filepath, sizeof(filepath), "%s/%s", path, entry->d_name);
                get_file_size(filepath);  // Get the size of the junk file
                struct stat st;
                if (stat(filepath, &st) == 0) {
                    total_size += st.st_size;  // Add file size to total
                }
            }
        }
    }

    printf("\nTotal size of junk files: %ld bytes\n", total_size);
    closedir(dp);
}

// Function to display the user menu
void display_menu() {
    printf("\nMenu:\n");
    printf("1. Scan Directory for Junk Files\n");
    printf("2. Delete Specific File\n");
    printf("3. Exit\n");
    printf("Enter your choice: ");
}

int main() {
    char directory[256];
    char filepath[512];
    int choice;

    printf("Enter the directory to clean: ");
    scanf("%255s", directory);

    while (1) {
        display_menu();
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                printf("Scanning directory: %s\n", directory);
                scan_directory(directory);
                break;
            case 2:
                printf("Enter the full path of the file to delete: ");
                scanf("%511s", filepath);
                delete_file(filepath);
                break;
            case 3:
                printf("Exiting program...\n");
                exit(0);
            default:
                printf("Invalid choice. Please try again.\n");
        }
    }

    return 0;
}
