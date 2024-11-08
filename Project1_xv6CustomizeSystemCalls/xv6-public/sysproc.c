#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

int total_calls = -1;

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_cps(void){
	return cps();
}

int sys_calls(void){
  if(total_calls == -1){
    return total_calls;
  }
  else{
    return total_calls + 1;
  }
}

extern struct{
  //Lock for synchronization acess to ptable.
  struct spinlock lock;

  //Array of process structures.
  struct proc proc[NPROC];
}ptable;

int get_process_type(void){
  int pid;
  struct proc *p;

  //Gets the argument from system call stack  and stores it in pid.
  if(argint(0, &pid) < 0){
    return -1;
  }
  
  //Acquire a lock to the process table
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //Find the pid
    if(p->pid == pid){
      //int type;
      if(p->parent == 0){
        release(&ptable.lock);
        return 3;
      }

      else if(p->state == ZOMBIE){
        release(&ptable.lock);
        return 1;
      }

      else if(p->parent->state == ZOMBIE){
        release(&ptable.lock);
        return 0;
      }

      else{
        release(&ptable.lock);
        return 2;
      }
      //Release the lock before returning the state.
  
    }
  }
  release(&ptable.lock);
  return -1;
}