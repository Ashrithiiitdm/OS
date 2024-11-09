#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
    int pid;
    int mem;

    if(argc != 2) {
        printf(2, "Usage: memusage pid\n");
        exit();
    }

    //Get the PID from the command line argument
    pid = atoi(argv[1]);
    

    if(pid < 0) {
        printf(2, "Invalid PID\n");
        exit();
    }

    //Get the memory info using mem_usage system call
    mem = mem_usage(pid);

    if(mem < 0){
        printf(2, "Process %d not found or unable to access memory info\n", pid);
    } 

    else{
        printf(1, "Memory usage of process %d: %d bytes\n", pid, mem);
    }
    
    exit();
}