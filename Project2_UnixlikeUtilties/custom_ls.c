#include<stdio.h>
#include<dirent.h>
#include<string.h>
#include<stdlib.h>
#include<stdbool.h>
#include<sys/stat.h>


//Define ANSI color codes
#define RED "\x1b[31m"
#define GREEN "\x1b[32m"
#define BLUE "\x1b[34m"
#define RESET "\x1b[0m"

//Defining the maximum path length
#define PATH_MAX 4096

//Function to check whether a file is executable or not
bool isExec(const char *path){
    struct stat fileStat;
    
    if(stat(path, &fileStat) < 0){
        printf("Error in stat\n");
        return false;
    }

    return (fileStat.st_mode & S_IXUSR);

}

//Checks if it is a directory or not
bool isDir(const char *path){
    struct stat fileStat;
    
    if(stat(path, &fileStat) < 0){
        printf("Error in stat\n");
        return false;
    }

    return S_ISDIR(fileStat.st_mode);
}

//Checks if it the file has no permissions
bool hasNopermissions(const char *path){
    struct stat fileStat;
    
    if(stat(path, &fileStat) < 0){
        printf("Error in stat\n");
        return false;
    }

    return !(fileStat.st_mode & S_IRUSR);

}

//Function to list directories
void list_directories(const char *path){
    struct dirent *dir;
    
    //Pointer to a directory stream
    DIR *ptr = opendir(path);
    
    if(ptr == NULL){
        printf("Unable to open directory\n");
        exit(1);
    }

    while((dir = readdir(ptr)) != NULL){
        if(!strcmp(dir->d_name, ".") || !strcmp(dir->d_name, "..")){
            continue;
        }
        char fpath[PATH_MAX];

        //Getting the full path of the file for color code
        snprintf(fpath, PATH_MAX, "%s/%s", path, dir->d_name);

        if(isDir(fpath)){
            printf(BLUE "%s\n" RESET, dir->d_name);
        }
        else if(isExec(fpath)){
            printf(GREEN "%s\n" RESET, dir->d_name);
        }
        else if(hasNopermissions(fpath)){
            printf(RED "%s\n" RESET, dir->d_name);
        }
        else{
            printf("%s\n", dir->d_name);
        }

        
    }

    closedir(ptr);

}

int main(int argc, char *argv[]){
    const char *path = ".";

    /*The difference between ls and our custom_ls is that 
    custom_ls takes a cmd argument and gives the contents of the path.
    If no argument is given, it gives the contents of the current directory*/
    
    if(argc > 1){
        path = argv[1];
    }
    else{
        path = ".";
    }
    list_directories(path);
    return 0;
}