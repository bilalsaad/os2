#include "mmu.h"
#define SYS_sigret 24
#define T_SYSCALL 64


  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  pushl %es
  pushl %fs
  pushl %gs
  pushal
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
  movw %ax, %ds
  movw %ax, %es
  movw $(SEG_KCPU<<3), %ax
  movw %ax, %fs
  movw %ax, %gs

  # Call trap(tf), where tf=%esp
  pushl %esp
  call trap
  addl $4, %esp

  # Return falls through to trapret...
.globl trapret
trapret:
  # Maybe we can call a cool function here that checks the stuff?
  pushal # so we dont mess with the contents of the registers, bro. 
  call handle_signals
  popal
  popal
  popl %gs
  popl %fs
  popl %es
  popl %ds
  addl $0x8, %esp  # trapno and errcode
  iret

.globl sigret_label_start
sigret_label_start:
  movl $SYS_sigret, %eax;
  int $T_SYSCALL;
  ret;
.globl sigret_label_end
sigret_label_end:
