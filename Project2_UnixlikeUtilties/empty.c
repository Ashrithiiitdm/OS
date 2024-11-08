#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/stat.h>
#include <unistd.h>

void empty_directory(const char *path) {
    DIR *ptr = opendir(path);
    if (ptr == NULL) {
        printf("empty: Error opening directory\n");
        return;
    }

    struct dirent *dir;
    struct stat entry_stat;
    char entry_path[4096];

    while ((dir = readdir(ptr)) != NULL) {
        if (!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, "..")) {
            continue;
        }

        snprintf(entry_path, sizeof(entry_path), "%s/%s", path, dir->d_name);

        if (stat(entry_path, &entry_stat) == -1) {
            printf("empty: Error getting file status\n");
            continue;
        }

        if (S_ISDIR(entry_stat.st_mode)) {
            // Recursively empty the subdirectory
            empty_directory(entry_path);

            // Once empty, keep the directory itself
        } else if (S_ISREG(entry_stat.st_mode)) {
            // If it’s a file, "empty" it by truncating it to 0 bytes
            FILE *file = fopen(entry_path, "w");
            if (file == NULL) {
                printf("empty: Error emptying file %s\n", entry_path);
            } else {
                fclose(file);  // Successfully truncated the file
            }
        } else {
            // For other types of files, we can just unlink (if desired)
            if (unlink(entry_path) == -1) {
                printf("empty: Error deleting non-regular file %s\n", entry_path);
            }
        }
    }

    closedir(ptr);
}

void empty_path(const char *path) {
    struct stat path_stat;

    if (stat(path, &path_stat) == -1) {
        printf("empty: Error getting path status\n");
        return;
    }

    if (S_ISDIR(path_stat.st_mode)) {
        // If it's a directory, empty its contents
        empty_directory(path);
    } else if (S_ISREG(path_stat.st_mode)) {
        // If it's a file, truncate it to 0 bytes
        FILE *file = fopen(path, "w");
        if (file == NULL) {
            printf("empty: Error emptying file %s\n", path);
        } else {
            fclose(file);  // Successfully truncated the file
        }
    } else {
        printf("empty: Unsupported file type\n");
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <path>\n", argv[0]);
        return 1;
    }

    // Call empty_path on the provided path
    empty_path(argv[1]);

    return 0;
}
