#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#define db cprintf("IN LINE %d \n", __LINE__);
#define dbs(x) cprintf("%s %d \n",x , __LINE__);




#define check_cas2(p, S1, S2) \
  if(!cas(p, S1, S2)){ \
    cprintf("EXPECTED %s got %s : line %d \n", sts[S1], \
        sts[proc->state], __LINE__); \
    panic("CAS INVADILITY"); \
  } 
#define check_cas(S1, S2) check_cas2(&proc->state, S1, S2);

#define sched_check if(proc != 0 && proc->state == RUNNING) \
                               db;

static char *sts[] = {
  [UNUSED]          "unused",
  [EMBRYO]          "embryo",
  [SLEEPING]        "sleep ",
  [RUNNABLE]        "runble",
  [RUNNING]         "run   ",
  [ZOMBIE]          "zombie",
  [NEG_ZOMBIE]      "neg_zombie",
  [NEG_RUNNABLE]    "neg_runnable",
  [NEG_SLEEPING]    "neg sleeping",
  [NEG_UNUSED]      "neg_unused"
  };
struct {
//  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;
char * foo(int);
int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  //panic("called pinit wtf \n");
 // initlock(&ptable.lock, "ptable");
}


int
allocpid(void) 
{
  int pid;
  do {
    pid = nextpid;
  } while(!cas(&nextpid, pid, pid + 1));
  return pid+1;
}
//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  int expected;
  struct cstackframe* cstack_iter;
  
  do {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if(UNUSED == p->state) { // found an unused fellow.
        expected = UNUSED;
        break;
      }
    if(NPROC + ptable.proc == p) {
      return 0;
    }
  } while(!cas(&p->state, expected, EMBRYO));
  p->pid = allocpid();


  // SIGNALZ -- gettiing the cstack up and ready.
  p->in_handler = OUT_HANDLER;
  p->sig_handler = DEFAULT_HANDLER; 
  p->cstack.head = EMPTY_STACK;
  cstack_iter = p->cstack.frames;
  while(cstack_iter != p->cstack.frames + CSTACK_SIZE)
    (cstack_iter++)->used = CSTACKFRAME_UNUSED;

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  check_cas2(&p->state, EMBRYO, RUNNABLE);
  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  // CHANGE FOR SIGNAL --------------------------
  np->sig_handler = proc->sig_handler; // fork copies the parents sig handler

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
 // acquire(&ptable.lock);
  pushcli();
  check_cas2(&np->state, EMBRYO, RUNNABLE);
  //np->state = RUNNABLE;
  popcli();
 // release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;
  
  pushcli();
  //acquire(&ptable.lock);

  check_cas(RUNNING, NEG_ZOMBIE);
  //proc->state = ZOMBIE;

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE || p->state == NEG_ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  
  sched_check;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  //acquire(&ptable.lock);
  pushcli();
  for(;;){
    proc->chan = (int)proc;
    check_cas(RUNNING, NEG_SLEEPING);
    //proc->state = NEG_SLEEPING;    
    
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;

      if(p->state == ZOMBIE || p->state == NEG_ZOMBIE){
        // Found one.
        pid = p->pid;
        p->state = (p->state == NEG_ZOMBIE) ? NEG_UNUSED : UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        proc->chan = 0;
        //proc->state = RUNNING;
        check_cas(NEG_SLEEPING, RUNNING);
        //release(&ptable.lock);
        popcli();
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      proc->chan = 0;
      check_cas(NEG_SLEEPING, RUNNING);
      //proc->state = RUNNING;      
      //release(&ptable.lock);
      popcli();
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sched_check;
    sched();
  }
}

void 
freeproc(struct proc *p)
{
  if (!p || (p->state != ZOMBIE && p->state != UNUSED))
    panic("freeproc not zombie");
  kfree(p->kstack);
  p->kstack = 0;
  freevm(p->pgdir);
  p->killed = 0;
  p->chan = 0;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    //acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(!cas(&p->state, RUNNABLE, NEG_RUNNABLE))
        continue;

      // Should we handler signals here?
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      check_cas2(&p->state, NEG_RUNNABLE, RUNNING);
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      cas(&p->state, NEG_SLEEPING, SLEEPING);
      cas(&p->state, NEG_RUNNABLE, RUNNABLE);

      cas(&p->state, NEG_ZOMBIE, ZOMBIE);
      cas(&p->state, NEG_UNUSED, UNUSED);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
      if (p->state == ZOMBIE || p->state == UNUSED)
        freeproc(p);
    }
    //release(&ptable.lock);
    popcli();

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

//  if(!holding(&ptable.lock))
//    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  pushcli();
  //acquire(&ptable.lock);  //DOC: yieldlock
  //proc->state = RUNNABLE;
  check_cas(RUNNING, NEG_RUNNABLE);

  sched_check;
  sched();
  popcli();
  //release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  //release(&ptable.lock);
  popcli();

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Go to sleep.
  if(proc->name[2] == 'e' && proc->pid > 4  && proc->pid < 55) 
    cprintf("process w/ pid: %d going to sleep on %p \n", proc->pid,
        (uint) chan);
  pushcli();
  proc->chan = (int)chan;
  check_cas(RUNNING, NEG_SLEEPING);
  //proc->state = NEG_SLEEPING;

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
//  if(lk != &ptable.lock){  //DOC: sleeplock0
//    acquire(&ptable.lock);  //DOC: sleeplock1
//    release(lk);
//  }

  release(lk);

  sched_check;
  sched();
  
  popcli();
  acquire(lk);
  // Reacquire original lock.
//  if(lk != &ptable.lock){  //DOC: sleeplock2
//    release(&ptable.lock);
//    acquire(lk);
//  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state != SLEEPING && p->chan == (int)chan) {
      while(p->state != SLEEPING);
    }
    if(p->chan == (int)chan && cas(&p->state, SLEEPING, NEG_RUNNABLE)){
      //check_cas2(&p->state, SLEEPING, RUNNABLE);
      //p->state = RUNNABLE;
        // Tidy up.
      check_cas2(&p->chan, (int) chan, 0);
      check_cas2(&p->state, NEG_RUNNABLE, RUNNABLE);
    }
  }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  //acquire(&ptable.lock);
  pushcli();
  wakeup1(chan);
  popcli();
  //release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  //acquire(&ptable.lock);
  pushcli();
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      while(p->state == NEG_SLEEPING);
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      //release(&ptable.lock);
      popcli();
      return 0;
    }
  }
  //release(&ptable.lock);
  popcli();
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
static char *states[] = {
  [UNUSED]          "unused",
  [EMBRYO]          "embryo",
  [SLEEPING]        "sleep ",
  [RUNNABLE]        "runble",
  [RUNNING]         "run   ",
  [ZOMBIE]          "zombie",
  [NEG_ZOMBIE]      "neg_zombie",
  [NEG_RUNNABLE]    "neg_runnable",
  [NEG_SLEEPING]    "neg sleeping",
  [NEG_UNUSED]      "neg_unused"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("[%d %s %s] \n  ", p->pid, state, p->name);
    if(0 && p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
  }
}

// SIGNALS ----
// CONCURRENT STACK FUNCTIONS

// Returns a vacant cstackframe from a given cstack - returns 0 if none are
// vacant;
struct cstackframe* get_stack_frame(struct cstack*);

int push(struct cstack *cstack, int sender_pid, int recepient_pid, int value) {
  struct cstackframe* new_frame;

  // get an empty frame from the cstack -- if none are free return 0;
  new_frame = get_stack_frame(cstack);
  if(new_frame == EMPTY_STACK)
    return 0;
  
  // Fill in the new frame.
  new_frame->sender_pid = sender_pid;
  new_frame->recepient_pid = recepient_pid;
  new_frame->value = value;
  
  // A CAS loop for adding the new frame to the head of the stack.
  // We make sure our new_frames next is the old head and that the head does 
  // change. 
  do {
    new_frame->next = cstack->head;
  } while(!cas((int *)&cstack->head, (int) new_frame->next, (int) new_frame));
  return 1; // SUCCESS
}

struct cstackframe *pop(struct cstack *cstack) {
  struct cstackframe* old;
  do {
    old = cstack->head;
    if(old == EMPTY_STACK){ // Empty stack.
      return EMPTY_STACK;
    }
  } while(!cas((int *) &cstack->head, (int) old, (int) (cstack->head->next)));
  return old; 
}



struct cstackframe* get_stack_frame(struct cstack* cstack) {
  struct cstackframe* iter = cstack->frames;
  do{
    while(iter < cstack->frames + CSTACK_SIZE)
      if(CSTACKFRAME_UNUSED == iter->used) { // found one!
        break;
      }
    // out of while.
      if( CSTACK_SIZE + cstack->frames == iter) // none found
        return EMPTY_STACK;
  }while(!cas(&iter->used, CSTACKFRAME_UNUSED, CSTACKFRAME_USED));

  // we caught an unused stack frame!
  return iter;
}

// SIGNAL SYSTEM CALLS HELPER FUNCTIONS.
// ******************************************** 

// sigset. Not sure what to return here.. Maybe int? or IDK
sig_handler sigset(sig_handler handler) {
  // could there be a data race here? I don't think so. 
  sig_handler old = proc->sig_handler; 
  proc->sig_handler = handler;
  return old; 
}

// Not sure if I need to synchronize anything here. 
int sigsend(int dest_pid, int value) {
  struct proc* p = ptable.proc;
  int res = -1;
  while(p < ptable.proc + NPROC) {
    if(p->pid == dest_pid){  // Found it.

     res = push(&p->cstack, proc->pid /* sender */, dest_pid, value);
     wakeup(&p->cstack);
    }
    ++p;
  }
  // If no such process was found. Well we can always return -1;
  return res;
}

int sigpause() { 
  //acquire(&ptable.lock);
  pushcli();
  for(;;) {
    //proc->state = NEG_SLEEPING;
    check_cas(RUNNING, NEG_SLEEPING);
    proc->paused = 1;
    proc->chan = (int) &proc->cstack;

    if(proc->cstack.head != EMPTY_STACK) {
      check_cas(NEG_SLEEPING, RUNNING);
      proc->paused = 0;
      proc->chan = 0;
      //release(&ptable.lock);
      popcli();
      return 1;
    }
    sched_check;
    sched();
  }

  return 0;
}

// Here we must restore the previous cpu state after the sig handler..
void sigret() {
  // restore the backed up cpu_state.
  proc->tf->edi = proc->cpu_state.edi;
  proc->tf->esi = proc->cpu_state.esi;
  proc->tf->ebp = proc->cpu_state.ebp;
  proc->tf->ebx = proc->cpu_state.ebx;
  proc->tf->edx = proc->cpu_state.edx;
  proc->tf->ecx = proc->cpu_state.ecx;
  proc->tf->eax = proc->cpu_state.eax;
  proc->tf->eip = proc->cpu_state.eip;
  proc->tf->esp = proc->cpu_state.esp;
  proc->in_handler = OUT_HANDLER;
}

void backup_proc_tf(struct proc*);
void edit_tf_for_sighandler(struct proc*, int, int);


// should do something with pending signals!!! 
// The plan is to now - if proc = zero ret 0-- need to ask if this is possible
// else if the stack is empty or if that the sig handler is the default one.
// Just pop the stack and return 0.
// else <backup the user tf> and return the cstack frame to the assembly fellah
int handle_signals() {
  struct cstackframe* curr = 0;
  
  if(proc != 0) {
    curr = (proc->in_handler == IN_HANDLER) ? EMPTY_STACK : pop(&proc->cstack);
    if(curr == EMPTY_STACK || proc->sig_handler == DEFAULT_HANDLER) {
      return 0;
    }
    // else return curr - and do stuff in assembly?
    // backup part of tf?
    backup_proc_tf(proc); 
    edit_tf_for_sighandler(proc, curr->value, curr->sender_pid);
    // finished using the frame. free it.
    curr->used = CSTACKFRAME_UNUSED;
    return 1;
  }
  return 0; // proc is 0 - not sure what to do here is this a data race?
}

void backup_proc_tf(struct proc* p) {
  proc->in_handler = IN_HANDLER;
  p->cpu_state.edi = p->tf->edi;
  p->cpu_state.esi = p->tf->esi;
  p->cpu_state.ebp = p->tf->ebp;
  p->cpu_state.ebx = p->tf->ebx;
  p->cpu_state.edx = p->tf->edx;
  p->cpu_state.ecx = p->tf->ecx;
  p->cpu_state.eax = p->tf->eax;
  p->cpu_state.eip = p->tf->eip;
  p->cpu_state.esp = p->tf->esp;
}

extern void sigret_label_start(void);
extern void sigret_label_end(void);


// This function gets the user-stack ready for invoking the signal handler.
// we need for the ret address for the injected code to be the old eip.
// we inject both the sigret code on the stack, its address on the stack as 
// the return address of the handler and the handler args.
void edit_tf_for_sighandler(struct proc* p, int value_arg, int pid_arg) {
  uint injected_code_size;
  uint injected_code_address;
  uint old_eip = proc->tf->eip;
  // we need edit the eip to be the address of the sighandler. 
  p->tf->eip = (uint) p->sig_handler;

  // do I need to make room for the return address here? probably
  // We need to make room for the injected sigret code. fml. 
  injected_code_size = (&sigret_label_end - &sigret_label_start); 

  proc->tf->esp -= 4; // room for the old eip.
  memmove((void *) proc->tf->esp,
          (const void *) &old_eip,
          4);
  
  // Update the user-esp, make room for sigret code.
  p->tf->esp -= injected_code_size;
  injected_code_address = p->tf->esp;
  
  // Move the code onto the stack. 
  memmove((void *) injected_code_address,
          (const void *) &sigret_label_start, 
          injected_code_size);
  
  p->tf->esp -= 4; // make room for second arg fml
  memmove((void *) p->tf->esp,
      (const void *) &value_arg,
      4);

  p->tf->esp -= 4; // make room for first arg fml
  memmove((void *) p->tf->esp,
      (const void *) &pid_arg,
      4);
  p->tf->esp -= 4; // make room for the return address
  memmove((void *) p->tf->esp,
      (const void *) &injected_code_address,
      4);
}

