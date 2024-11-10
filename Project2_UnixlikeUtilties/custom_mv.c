#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<dirent.h>
#include<sys/stat.h>
#include<unistd.h>
#define N 4096

// Function to delete files
void delete_file(const char *path){
    if(remove(path) == -1){
        printf("custom_mv: cannot remove '%s': No such file or directory\n", path);
        return;
    }

    //printf("Removed file: '%s'\n", path);
}

// Function to remove directories recursively
void remove_directory(const char *path){
    DIR *dir = opendir(path);
    if(dir == NULL){
        printf("custom_mv: cannot remove '%s': No such file or directory\n", path);
        return;
    }

    struct dirent *entry;
    struct stat entry_stat;
    char full_path[N];

    // Iterate over the directory entries
    while((entry = readdir(dir)) != NULL){

        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        // Constructing the full path of the entry
        snprintf(full_path, sizeof(full_path), "%s/%s", path, entry->d_name);

        // Get the entry's stats.
        if (stat(full_path, &entry_stat) == -1) {
            printf("Error getting stat of '%s'\n", full_path);
            continue;
        }

        // If it is a directory call the function recursively.
        if(S_ISDIR(entry_stat.st_mode)){
            remove_directory(full_path);
        } 

        //Else delete the file using delete_file function
        else if(S_ISREG(entry_stat.st_mode)){
            // Delete regular files
            delete_file(full_path);
        }
    }

    // Close the directory stream
    closedir(dir);

    // Remove the directory itself after its contents are deleted
    if(rmdir(path) == -1){
        printf("custom_mv: cannot remove '%s': No such file or directory\n", path);
        return;
    }

    //printf("Removed directory: '%s'\n", path);
}

// Function to copy files.
void copy_file(const char *src, const char *dest){

    FILE *source, *destination;
    char buffer[N];
    size_t bytes;

    source = fopen(src, "r");
    if(source == NULL){
        printf("custom_mv: Error opening source file\n");
        return;
    }

    destination = fopen(dest, "w");
    if(destination == NULL){

        printf("custom_mv: Error opening destination file\n");
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
        printf("custom_mv: Error opening source directory\n");
        return;
    }

    // Check if the destination exists, if not create it
    struct stat st;
    if(stat(dest, &st) == -1){
        if(mkdir(dest, 0755) == -1){

            printf("custom_mv: Error creating destination directory\n");
            closedir(dir);
            return;
        }
    } 
    else if (!S_ISDIR(st.st_mode)){

        printf("custom_mv: Destination is not a directory\n");
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
            printf("custom_mv: Error getting file status\n");
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

        printf("Usage: custom_mv <source> <destination>\n");
        return 1;
    }

    struct stat src_stat, dest_stat;
    if(stat(argv[1], &src_stat) == -1){

        printf("custom_mv: Cannot stat source");
        return 1;
    }

    // Check if source is a directory
    if(S_ISDIR(src_stat.st_mode)){

        // If source is a directory, copy the entire directory
        if(stat(argv[2], &dest_stat) == -1){

            // If destination does not exist, create one
            if(mkdir(argv[2], 0755) == -1){
                printf("custom_mv: Cannot create destination directory\n");
                return 1;
            }
        } 

        else if(!S_ISDIR(dest_stat.st_mode)){

            // If destination exists but is not a directory
            printf("custom_mv: Destination is not a directory\n");
            return 1;
        }

        // Copy the directory recursively
        copy_directory(argv[1], argv[2]);

        //Remove the source directory after copying
        remove_directory(argv[1]);
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

        // Remove the source file after copying
        delete_file(argv[1]);
    } 

    else{
        // Source is neither a regular file nor a directory
        printf("custom_mv: Source is neither a file nor a directory\n");
        return 1;
    }

    return 0;
}
