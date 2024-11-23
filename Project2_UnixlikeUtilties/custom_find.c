// Check in all directories whether find is there or not
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <time.h>

void custom_find(const char *dir_path, const char *name, const char *ext, long size, int days) {
    DIR *dir = opendir(dir_path);
    if (!dir) {
        perror("opendir");
        return;
    }

    struct dirent *entry;
    struct stat file_stat;

    while ((entry = readdir(dir)) != NULL) {
        char full_path[1024];
        snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, entry->d_name);

        // Skip "." and ".."
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        if (stat(full_path, &file_stat) == -1) {
            perror("stat");
            continue;
        }

        // If it's a directory, recurse into it
        if (S_ISDIR(file_stat.st_mode)) {
            custom_find(full_path, name, ext, size, days);
        } else {
            // Apply filters
            int matches = 1;

            // Filter by name
            if (name && strstr(entry->d_name, name) == NULL)
                matches = 0;

            // Filter by extension
            if (ext) {
                const char *dot = strrchr(entry->d_name, '.');
                if (!dot || strcmp(dot, ext) != 0)
                    matches = 0;
            }

            // Filter by size
            if (size > 0 && file_stat.st_size < size)
                matches = 0;

            // Filter by modification time
            if (days > 0) {
                time_t now = time(NULL);
                double diff = difftime(now, file_stat.st_mtime) / (60 * 60 * 24);
                if (diff > days)
                    matches = 0;
            }

            if (matches) {
                printf("%s (Size: %ld bytes, Modified: %s)", full_path, file_stat.st_size, ctime(&file_stat.st_mtime));
            }
        }
    }

    closedir(dir);
}

int main(int argc, char *argv[]) {
    const char *name = NULL;
    const char *ext = NULL;
    long size = 0;
    int days = 0;

    // Parse command-line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-n") == 0 && i + 1 < argc)
            name = argv[++i];
        else if (strcmp(argv[i], "-e") == 0 && i + 1 < argc)
            ext = argv[++i];
        else if (strcmp(argv[i], "-s") == 0 && i + 1 < argc)
            size = atol(argv[++i]);
        else if (strcmp(argv[i], "-d") == 0 && i + 1 < argc)
            days = atoi(argv[++i]);
    }

    // Start searching from the current directory
    custom_find(".", name, ext, size, days);
    return 0;
}
