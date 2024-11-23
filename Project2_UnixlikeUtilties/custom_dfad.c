// Duplicate finder and deleter
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <openssl/md5.h> // For MD5 hashing

#define MAX_FILES 1000
#define HASH_SIZE 33 // 32 characters for MD5 hash + 1 for '\0'

// Struct to store file information
typedef struct {
    char path[1024];
    char hash[HASH_SIZE];
    long size;
} FileInfo;

// Function to calculate the MD5 hash of a file
int calculate_md5(const char *file_path, char *hash) {
    FILE *file = fopen(file_path, "rb");
    if (!file) {
        perror("fopen");
        return -1;
    }

    MD5_CTX md5_context;
    MD5_Init(&md5_context);

    unsigned char buffer[1024];
    size_t bytes;
    while ((bytes = fread(buffer, 1, sizeof(buffer), file)) > 0) {
        MD5_Update(&md5_context, buffer, bytes);
    }
    fclose(file);

    unsigned char md5_result[MD5_DIGEST_LENGTH];
    MD5_Final(md5_result, &md5_context);

    for (int i = 0; i < MD5_DIGEST_LENGTH; i++) {
        sprintf(&hash[i * 2], "%02x", md5_result[i]);
    }
    hash[32] = '\0'; // Null-terminate the hash

    return 0;
}

// Function to recursively scan a directory for files
int scan_directory(const char *dir_path, FileInfo *files, int *file_count) {
    DIR *dir = opendir(dir_path);
    if (!dir) {
        perror("opendir");
        return -1;
    }

    struct dirent *entry;
    struct stat file_stat;

    while ((entry = readdir(dir)) != NULL) {
        // Skip "." and ".."
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        char full_path[1024];
        snprintf(full_path, sizeof(full_path), "%s/%s", dir_path, entry->d_name);

        if (stat(full_path, &file_stat) == -1) {
            perror("stat");
            continue;
        }

        // If it's a directory, recurse into it
        if (S_ISDIR(file_stat.st_mode)) {
            scan_directory(full_path, files, file_count);
        } else {
            // Store file information
            FileInfo file_info;
            strncpy(file_info.path, full_path, sizeof(file_info.path) - 1);
            file_info.size = file_stat.st_size;

            if (calculate_md5(full_path, file_info.hash) == 0) {
                files[*file_count] = file_info;
                (*file_count)++;
                if (*file_count >= MAX_FILES) {
                    fprintf(stderr, "Too many files! Increase MAX_FILES.\n");
                    closedir(dir);
                    return -1;
                }
            }
        }
    }

    closedir(dir);
    return 0;
}

// Function to find and optionally delete duplicates
void find_and_remove_duplicates(FileInfo *files, int file_count, int remove_duplicates) {
    for (int i = 0; i < file_count; i++) {
        if (files[i].path[0] == '\0') continue; // File already removed

        for (int j = i + 1; j < file_count; j++) {
            if (files[j].path[0] == '\0') continue;

            // Compare hashes to check for duplicates
            if (strcmp(files[i].hash, files[j].hash) == 0) {
                printf("Duplicate found:\n");
                printf("  Original: %s\n", files[i].path);
                printf("  Duplicate: %s\n", files[j].path);

                if (remove_duplicates) {
                    // Remove the duplicate file
                    if (remove(files[j].path) == 0) {
                        printf("Removed: %s\n", files[j].path);
                        files[j].path[0] = '\0'; // Mark as removed
                    } else {
                        perror("remove");
                    }
                }
            }
        }
    }
}

int main(int argc, char *argv[]) {
    const char *start_folder = ".";
    int remove_duplicates = 0;

    // Parse command-line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-r") == 0) {
            remove_duplicates = 1; // Enable removal of duplicates
        } else {
            start_folder = argv[i]; // Use given folder path
        }
    }

    FileInfo files[MAX_FILES];
    int file_count = 0;

    // Scan the directory for files
    if (scan_directory(start_folder, files, &file_count) == 0) {
        printf("Scanned %d files.\n", file_count);

        // Find and optionally remove duplicates
        find_and_remove_duplicates(files, file_count, remove_duplicates);
    }

    return 0;
}
