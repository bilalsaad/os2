#include "types.h"
#include "stat.h" 
#include "user.h"

void handler(int pid, int value) {
  printf(1,"value i got is %d \n", value);
}

int main(int argc, char** argv){
  int n, pid;
  n = atoi( (argc > 1) ? *(argv+1) : "1");  
  if(sigset(handler) < 0)
    printf(1, "sigset failed fiuuu \n");
  while(n --> 0){
    pid = fork(); 

    if(pid == 0) { // child code
      while(1){
        sigpause(); 
      }
    } 
    else { // parent code 
      printf(1, "child with pid %d made \n", pid);
    }
  }

  sigsend(pid, 1);
  exit();
}
