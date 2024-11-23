// Finds if a file is presnt in a given folder
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

// Modified function for non-recursive search in a given folder
void custom_find(const char *dir_path, const char *file_name) {
    DIR *dir = opendir(dir_path);
    if (!dir) {
        perror("opendir");
        return;
    }

    struct dirent *entry;

    int found = 0; // To track if the file is found
    while ((entry = readdir(dir)) != NULL) {
        // Skip "." and ".."
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        // Check if the current entry matches the given file name
        if (strcmp(entry->d_name, file_name) == 0) {
            char full_path[1024];
            snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, entry->d_name);
            printf("File found: %s\n", full_path);
            found = 1;
            break;
        }
    }

    if (!found) {
        printf("File '%s' not found in directory '%s'.\n", file_name, dir_path);
    }

    closedir(dir);
}

int main(int argc, char *argv[]) {
    const char *folder = NULL;
    const char *file_name = NULL;

    // Parse command-line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-f") == 0 && i + 1 < argc)
            folder = argv[++i];
        else if (strcmp(argv[i], "-n") == 0 && i + 1 < argc)
            file_name = argv[++i];
    }

    // Validate input
    if (!folder || !file_name) {
        printf("Usage: %s -f <folder> -n <file_name>\n", argv[0]);
        return 1;
    }

    // Search for the file in the given folder
    custom_find(folder, file_name);

    return 0;
}
