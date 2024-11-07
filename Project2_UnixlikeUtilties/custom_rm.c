#include<stdio.h>
#include<dirent.h>
#include<string.h>
#include<stdlib.h>
#include<stdbool.h>
#include<sys/stat.h>


void remove_directory(const char *path){
    
    DIR *ptr = opendir(path);
    if(ptr == NULL){
        printf("rm: Error opening directory\n");
        return;
    }

    struct dirent *dir;
    struct stat entry_stat;
    char entry_path[4096];

    while((dir = readdir(ptr)) != NULL){

        if(!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, "..")){
            continue;
        }

        snprintf(entry_path, sizeof(entry_path), "%s/%s", path, dir->d_name);

        if(stat(entry_path, &entry_stat) == -1){
            printf("rm: Error getting file status\n");
            continue;
        }

        if(S_ISDIR(entry_stat.st_mode)){
            remove_directory(entry_path);
        } 
        else if(unlink(entry_path) == -1){
            printf("rm: Error deleting file\n");
        }
    }

    closedir(ptr);

    if(rmdir(path) == -1){
        printf("rm: Error deleting directory\n");
    }
}

int main(int argc, char *argv[]){

    char *path;

    if(argc > 1){
        path = argv[1];
    }
    else{
        path = ".";
    }

    remove_directory(path);

    return 0;
}