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
    pid1 = getpid();
    printf(1, "Child: Going to sleep for a while...\n");
    sleep(100);

    printf(1, "Child: Waking up and calling unwait\n");
    // Wake up any waiting processes
    unwait_pid();    
    exit();
  } 
  else{        
    // Parent process
    printf(1, "Parent: Waiting for child with pid %d\n", pid);
    if(pid1 != -1)
    wait_pid(pid1); // Wait for specific process
    
    printf(1, "Parent: Child has called unwait\n");
    // Wait for child to exit
    wait();       
  }
  
  exit();
}
