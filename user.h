struct stat;
struct rtcdate;
typedef void (*sig_handler)(int pid, int value);

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(char*, int);
int mknod(char*, short, short);
int unlink(char*);
int fstat(int fd, struct stat*);
int link(char*, char*);
int mkdir(char*);
int chdir(char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
/* ---------------------------- SIGNAL SYSTEM CALLS ------------- */ 
// sets the signal handler to be called when signals are sent 
sig_handler sigset(sig_handler);

// sends a signal with the given value to a proces with pid dest_pid
int sigsend(int dest_pid, int value);

// complete the signal handling context (should not be called explicitly)
void sigret(void);

// suspends the process until a new signal is received
int sigpause(void);


// ulib.c
int stat(char*, struct stat*);
char* strcpy(char*, char*);
void *memmove(void*, void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, char*, ...);
char* gets(char*, int max);
uint strlen(char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
