#include "types.h"
#include "stat.h" 
#include "user.h"
#define db printf(1,"LINE %d \n", __LINE__);
void concreate(void);
void handler(int pid, int value) {
  printf(1, "I got a signal pid[%d], value[%d] \n", pid, value);
}
int main(int argc, char** argv) {
  int i = 40;
  sigset(handler);
  int pid;

  if(argc == 1) {
     concreate();
  }
    

  while(i --> 0) {
    pid = fork();

    if(pid == 0)
      exit();
 
    wait();
    printf(1, "%d \n", pid);
  }

  printf(1, "finished part 1 \n");

  i = 60;

  while(i --> 0){
    pid = fork();
    if(pid  == 0)
      exit();
    else if (pid < 0)
      printf(1, "fork failed \n");

  }
  while((pid = wait()) > 0) {
    printf(1,"Killed %d \n", pid);
    sleep(10);
  }
  exit();
}


void foo(void) {
  sleep(2);
}
// test concurrent create/link/unlink of the same file
void
concreate(void)
{
  int i,j, pid, n, fd;
  char * file = "lambdax";
  char fa[40];
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
  for(i = 0; i < 40; i++){
    foo();
    pid = fork();
    if(pid && (i % 3) == 1){
      foo();
    } else if(pid == 0 && (i % 5) == 1){
      foo();
    } else {
      fd = getpid();
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      getpid();
    }
    if(pid == 0)
      exit();
    else
      wait();
  printf(1,"iter : %d \n", i) ;
  }
  printf(1, "finitio \n"); 
  memset(fa, 0, sizeof(fa));
  n = 0;
  j = 100;
  db;
  while(j-->0){
    if(de.inum == 0) {
      printf(1, "iter2 i %d \n", j);
      continue;
    }
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        foo();
      }
      if(fa[i]){
        foo();
      }
      fa[i] = 1;
      n++;
    }
    printf(1, "iter2 i %d \n", j);
  }

  if(n != 40){
    foo();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      foo();
    } else {
      foo();
    }
    if(pid == 0)
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
}
  /*
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
     } */
