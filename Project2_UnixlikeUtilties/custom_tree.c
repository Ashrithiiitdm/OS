// Prints all directories and files in it in tree structure or if we specify a directory name it prints files in that directory
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

// Function to print the directory structure
void custom_tree(const char *dir_path, int level, int include_files) {
    DIR *dir = opendir(dir_path);
    if (!dir) {
        perror("opendir");
        return;
    }

    struct dirent *entry;

    while ((entry = readdir(dir)) != NULL) {
        // Skip "." and ".."
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        // Print the current entry with indentation
        for (int i = 0; i < level; i++) {
            printf("│   "); // Indentation for tree structure
        }

        printf("├── %s\n", entry->d_name);

        char full_path[1024];
        snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, entry->d_name);

        // Check if it's a directory
        struct stat entry_stat;
        if (stat(full_path, &entry_stat) == 0 && S_ISDIR(entry_stat.st_mode)) {
            // Recursively call custom_tree for subdirectories
            custom_tree(full_path, level + 1, include_files);
        } else if (!include_files) {
            // Skip files if only directories are to be listed
            continue;
        }
    }

    closedir(dir);
}

int main(int argc, char *argv[]) {
    const char *start_folder = ".";
    int include_files = 1;

    // Parse command-line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-d") == 0) {
            include_files = 0; // Only show directories
        } else {
            start_folder = argv[i]; // Use given folder path
        }
    }

    printf("%s\n", start_folder); // Print root directory
    custom_tree(start_folder, 0, include_files);

    return 0;
}
