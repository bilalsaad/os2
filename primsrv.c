#include "types.h"
#include "stat.h" 
#include "user.h"
#define BUFFER_SIZE 32
#define NOT_BUSY 0 
#define db printf(1, "%d \n", __LINE__);
#define stdin 0

int isprime(int a) {
  int i = 2;
  while(i * i <=  a) {
    if((a % i) == 0)
      return 0;
    ++i;
  }
  return 1;
}
void handler(int pid, int value) {
  if(value == 0) {
    printf(1, "worker %d, exit \n", getpid());
    exit();
  }
  while (!isprime(++value));
  sleep(100);
  sigsend(pid, value);
}

int * workers;
int * busy_workers;
int NUM_WORKERS;


void primsrv(int pid, int value) {
  int i = NUM_WORKERS;
  if (value == 0) { 
    while(i --> 0)
     sigsend(workers[i-1], 0); 
    while(wait() > 0);

    printf(1, "primsrv exit \n");
    exit();
  }
  while (i --> 0)
    if(workers[i-1] == pid) { 
      break;
    }
  printf(1, "worker %d returned %d for %d \n", pid, value, busy_workers[i-1]);

  busy_workers[i-1] = NOT_BUSY;
}

void find_worker(int *, int*, int);
void null_terminate(char*);

int main(int argc, char** argv){
  int n, pid; 
  n = atoi((argc > 1) ? *(argv+1) : "1");  
  char buffer[BUFFER_SIZE];

  NUM_WORKERS = n;
  workers = malloc(sizeof(workers) * n); // pid table of workers;
  busy_workers = malloc(sizeof(busy_workers) * n);

  while(n --> 0){
    pid = fork();

    if(pid == 0) { // child code
      sigset(handler);
      while(1) {
        sigpause();
      }
    }
    else {
      workers[n-1] = pid;
      busy_workers[n-1] = NOT_BUSY;
    }
  }
  sigset(primsrv);
  printf(1, "worker pids: \n");
  n = NUM_WORKERS; 
  while (n --> 0)
    printf(1, "%d \n", workers[n-1]);

  while(1) {
    printf(1, "please enter a number: ");
    gets(buffer, BUFFER_SIZE);
    null_terminate(buffer);
    if(*buffer != 0) {
      n = atoi(buffer);
      *buffer = 0;
      find_worker(workers, busy_workers, n);
    }
  }

}

int isdigit(char d){
  return !(d < '0' || d > '9');
}
// assumes buff ends with \n
void null_terminate(char * buff) {
  while(isdigit(*buff++));
  *(buff-1) = 0;
}

void find_worker(int* workers, int* busy_workers, int value) {
 int n = NUM_WORKERS - 1;
 if(0 == value){
   printf(1,"sending 0, \n");
   sigsend(getpid(), 0);
 } 
 while(n --> -1)
   if(busy_workers[n] == NOT_BUSY) {
     busy_workers[n] = value;
     printf(1, "SENDING %d to %d \n", value, workers[n]);
     sigsend(workers[n], value);
     return;
   }
 printf(1, "no idle workers.\n"); 
}
