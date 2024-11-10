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
        printf("custom_rm: cannot remove '%s': No such file or directory\n", path);
        return;
    }

    printf("Removed file: '%s'\n", path);
}

// Function to remove directories recursively
void remove_directory(const char *path){
    DIR *dir = opendir(path);
    if(dir == NULL){
        printf("custom_rm: cannot remove '%s': No such file or directory\n", path);
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
        printf("custom_rm: cannot remove '%s': No such file or directory\n", path);
        return;
    }

    printf("Removed directory: '%s'\n", path);
}

// Main function to handle the delete operation
int main(int argc, char *argv[]){

    if(argc < 2){
        printf("Usage: custom_rm <file_or_directory>\n");
        return 1;
    }

    struct stat entry_stat;

    // Check the file or directory status
    if(stat(argv[1], &entry_stat) == -1){
        printf("custom_rm: cannot remove '%s': No such file or directory\n", argv[1]);
        return 1;
    }

    // If the entry is a directory, recursively remove it
    if(S_ISDIR(entry_stat.st_mode)){
        remove_directory(argv[1]);
    } 

    // If the entry is a regular file, remove it
    else if(S_ISREG(entry_stat.st_mode)){
        delete_file(argv[1]);
    }

    else{
        // If the entry is neither a regular file nor a directory
        printf("custom_rm: cannot remove '%s': Not a file or directory\n", argv[1]);
        return 1;
    }

    return 0;
}
