#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#define N 4096

// Function to copy files.
void copy_file(const char *src, const char *dest){

    FILE *source, *destination;
    char buffer[N];
    size_t bytes;

    source = fopen(src, "r");
    if(source == NULL){
        printf("cp: Error opening source file\n");
        return;
    }

    destination = fopen(dest, "w");
    if(destination == NULL){

        printf("cp: Error opening destination file\n");
        fclose(source);
        return;
    }

    while((bytes = fread(buffer, 1, N, source)) > 0){
        fwrite(buffer, 1, bytes, destination);
    }

    fclose(source);
    fclose(destination);
}

// Function to copy directories recursively
void copy_directory(const char *src, const char *dest){

    DIR *dir = opendir(src);
    if(dir == NULL){
        printf("cp: Error opening source directory\n");
        return;
    }

    // Check if the destination exists, if not create it
    struct stat st;
    if(stat(dest, &st) == -1){
        if(mkdir(dest, 0755) == -1){

            printf("cp: Error creating destination directory\n");
            closedir(dir);
            return;
        }
    } 
    else if (!S_ISDIR(st.st_mode)){

        printf("cp: Destination is not a directory\n");
        closedir(dir);
        return;
    }

    struct dirent *entry;
    struct stat entry_stat;
    char src_path[N], dest_path[N];

    while((entry = readdir(dir)) != NULL){

        // Skip the "." and ".." entries
        if(strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0){
            continue;
        }

        // Create source and destination paths
        snprintf(src_path, sizeof(src_path), "%s/%s", src, entry->d_name);
        snprintf(dest_path, sizeof(dest_path), "%s/%s", dest, entry->d_name);

        // Get the file status
        if(stat(src_path, &entry_stat) == -1){
            printf("cp: Error getting file status\n");
            continue;
        }

        if(S_ISDIR(entry_stat.st_mode)){
            // Recursively copy directories
            copy_directory(src_path, dest_path);
        } 
        else if(S_ISREG(entry_stat.st_mode)){
            // Copy regular files
            copy_file(src_path, dest_path);
        }
    }

    closedir(dir);
}

int main(int argc, char *argv[]){

    if(argc < 3){

        printf("Usage: cp <source> <destination>\n");
        return 1;
    }

    struct stat src_stat, dest_stat;
    if(stat(argv[1], &src_stat) == -1){

        printf("cp: Cannot stat source");
        return 1;
    }

    // Check if source is a directory
    if(S_ISDIR(src_stat.st_mode)){

        // If source is a directory, copy the entire directory
        if(stat(argv[2], &dest_stat) == -1){

            // If destination does not exist, create one
            if(mkdir(argv[2], 0755) == -1){
                printf("cp: Cannot create destination directory\n");
                return 1;
            }
        } 

        else if(!S_ISDIR(dest_stat.st_mode)){

            // If destination exists but is not a directory
            printf("cp: Destination is not a directory\n");
            return 1;
        }

        // Copy the directory recursively
        copy_directory(argv[1], argv[2]);
    } 

    else if(S_ISREG(src_stat.st_mode)){

        // Source is a regular file
        if(stat(argv[2], &dest_stat) != -1){

            // If the destination already exists, check whether to over-write it or not.
            if(S_ISDIR(dest_stat.st_mode)){

                // If destination is a directory, copy the file into the directory
                char *filename = strrchr(argv[1], '/');
                
                if(filename){

                    filename++; // Skip the '/' character
                }

                else{

                    filename = argv[1];
                }

                char dest_path[N];
                snprintf(dest_path, sizeof(dest_path), "%s/%s", argv[2], filename);
                copy_file(argv[1], dest_path);
            } 

            else{
                // If destination is a file, overwrite it
                copy_file(argv[1], argv[2]);
            }
        } 

        else{
            // Destination does not exist, copy the file
            copy_file(argv[1], argv[2]);
        }
    } 

    else{
        // Source is neither a regular file nor a directory
        printf("cp: Source is neither a file nor a directory\n");
        return 1;
    }

    return 0;
}
