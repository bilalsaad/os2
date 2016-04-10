#include "types.h"
#include "stat.h" 
#include "user.h"

void handler(int pid, int value) {
  printf(1, "I got a signal pid[%d], value[%d] \n", pid, value);
}
int main(int argc, char** argv) {
  int pid;

  sigset(handler);
  pid = fork();

  if(pid == 0){ // child code
    while(1) {
      sleep(8);
      printf(1, "lalalalalalalala\n");
    }
  }
  else {
    sleep(1);
    printf(1,"[%d] [%d] \n", sigsend(pid, 10), pid); 
  }
  exit();
}
