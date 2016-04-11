#include "types.h"
#include "stat.h" 
#include "user.h"

void handler(int pid, int value) {
  printf(1, "I got a signal pid[%d], value[%d] \n", pid, value);
}
int main(int argc, char** argv) {
  int pid;
  int i = 10;
  int parent_pid = getpid();
  sigset(handler);
  pid = fork();
  

  if(pid == 0){ // child code
    while(i --> 0) {
      sigpause();
      printf(1, "hallliluja \n");
      sigsend(parent_pid, 1);
    }
  }
  else {
    while(i-->0){
      sleep(10);
      sigsend(pid, i);
      sigpause();
    }
  }

  exit();
}
