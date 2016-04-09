#include "types.h"
#include "stat.h" 
#include "user.h"

void handler(int pid, int value) {
  printf(1, "I got a signal");
}
int main(int argc, char** argv) {
  int pid;

  pid = fork();

  if(pid == 0){ // child code
    sigset(handler);
    while(1) {
      sigpause();
    }
  }
  else {
    printf(1,"--------- [%d] ---------- \n\n ==== \n", sigsend(pid, 10)); 
  }
  exit();
}
