#include "types.h"
#include "stat.h" 
#include "user.h"

void handler(int pid, int value) {
  printf(1, "I got a signal");
}
int main(int argc, char** argv) {
  int pid;

  sigset(handler);
  pid = fork();

  if(pid == 0){ // child code
    while(1) {
      sleep(3);
      printf(1, "in ibrahim teez \n");
      sigpause();
      printf(1, "out of ibrahim teez \n");
    }
  }
  else {
    sleep(4);
    printf(1,"--------- [%d] --[%d]-------- \n\n ==== \n", sigsend(pid, 10),
        pid); 
  }
  exit();
}
