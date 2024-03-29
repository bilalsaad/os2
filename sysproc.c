#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

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
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
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
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// SIGNAL SYSTEM CALLS
int 
sys_sigset(void)
{
  sig_handler handler;

  if(argptr(0, (char**) &handler, sizeof(handler)) < 0)
    return 0; // Error I suppose.
  return (int) (sigset(handler));
}

int
sys_sigsend(void)
{ 
  int dest_pid, value;
  if(argint(0, &dest_pid) < 0 ||
      argint(1, &value) < 0 )
    return 0; // Error I suppose.

  return sigsend(dest_pid, value);
}

int 
sys_sigret(void)
{
  sigret();
  return 0;
}

int 
sys_sigpause(void)
{
  return sigpause();
}

// SLLAC METSYS LANGIS

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
