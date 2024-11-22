#include "types.h"
#include "stat.h"
#include "user.h"

int main()
{
  int pid = fork();
  
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }
  int pid1 = -1;
  if(pid == 0){  
    // Child process

    printf(1, "Child process...\n");
    
    int cpid = getpid();    
    pid1 = getppid(cpid);

    wait_pid(pid1);
    
    printf(1, "Child: Going to sleep for a while...\n");
    
    unwait_pid(pid1);

    sleep(1000);

    printf(1, "Child: Waking up and calling unwait\n");
    // Wake up any waiting processes
    
    exit();
  } 
  else{        
    // Parent process
    sleep(1000);
    printf(1, "Parent: Waiting for child with pid %d\n", pid);
    
    printf(1, "Parent: Child has called unwait\n");
    // Wait for child to exit
    wait();       
  }
  
  exit();
}
