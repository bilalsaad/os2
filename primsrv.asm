
_primsrv:     file format elf32-i386


Disassembly of section .text:

00000000 <isprime>:
#include "user.h"
#define BUFFER_SIZE 32
#define NOT_BUSY 0 
#define db printf(1, "%d \n", __LINE__);

int isprime(int a) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
  int i = 2;
   6:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%ebp)
  while(i * i <=  a) {
   d:	eb 18                	jmp    27 <isprime+0x27>
    if((a % i) == 0)
   f:	8b 45 08             	mov    0x8(%ebp),%eax
  12:	99                   	cltd   
  13:	f7 7d fc             	idivl  -0x4(%ebp)
  16:	89 d0                	mov    %edx,%eax
  18:	85 c0                	test   %eax,%eax
  1a:	75 07                	jne    23 <isprime+0x23>
      return 0;
  1c:	b8 00 00 00 00       	mov    $0x0,%eax
  21:	eb 15                	jmp    38 <isprime+0x38>
    ++i;
  23:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
#define NOT_BUSY 0 
#define db printf(1, "%d \n", __LINE__);

int isprime(int a) {
  int i = 2;
  while(i * i <=  a) {
  27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
  2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  31:	7e dc                	jle    f <isprime+0xf>
    if((a % i) == 0)
      return 0;
    ++i;
  }
  return 1;
  33:	b8 01 00 00 00       	mov    $0x1,%eax
}
  38:	c9                   	leave  
  39:	c3                   	ret    

0000003a <handler>:
void handler(int pid, int value) {
  3a:	55                   	push   %ebp
  3b:	89 e5                	mov    %esp,%ebp
  3d:	83 ec 18             	sub    $0x18,%esp
  if(value == 0) {
  40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  44:	75 35                	jne    7b <handler+0x41>
    printf(1, "worker %d, exit \n", getpid());
  46:	e8 cd 06 00 00       	call   718 <getpid>
  4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  4f:	c7 44 24 04 04 0c 00 	movl   $0xc04,0x4(%esp)
  56:	00 
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 d5 07 00 00       	call   838 <printf>
    sigsend(pid, 0);
  63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  6a:	00 
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	89 04 24             	mov    %eax,(%esp)
  71:	e8 ca 06 00 00       	call   740 <sigsend>
    exit();
  76:	e8 1d 06 00 00       	call   698 <exit>
  }
  while (!isprime(value++));
  7b:	90                   	nop
  7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  7f:	8d 50 01             	lea    0x1(%eax),%edx
  82:	89 55 0c             	mov    %edx,0xc(%ebp)
  85:	89 04 24             	mov    %eax,(%esp)
  88:	e8 73 ff ff ff       	call   0 <isprime>
  8d:	85 c0                	test   %eax,%eax
  8f:	74 eb                	je     7c <handler+0x42>
  sigsend(pid, value - 1);
  91:	8b 45 0c             	mov    0xc(%ebp),%eax
  94:	83 e8 01             	sub    $0x1,%eax
  97:	89 44 24 04          	mov    %eax,0x4(%esp)
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	89 04 24             	mov    %eax,(%esp)
  a1:	e8 9a 06 00 00       	call   740 <sigsend>
}
  a6:	c9                   	leave  
  a7:	c3                   	ret    

000000a8 <primsrv>:
int * workers;
int * busy_workers;
int NUM_WORKERS;


void primsrv(int pid, int value) {
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	83 ec 38             	sub    $0x38,%esp
  int i = NUM_WORKERS;
  ae:	a1 cc 0f 00 00       	mov    0xfcc,%eax
  b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (value == 0 ) { 
  b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  ba:	75 4d                	jne    109 <primsrv+0x61>
    while(i --> 0)
  bc:	eb 25                	jmp    e3 <primsrv+0x3b>
     sigsend(workers[i-1], 0); 
  be:	a1 c8 0f 00 00       	mov    0xfc8,%eax
  c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c6:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
  cc:	c1 e2 02             	shl    $0x2,%edx
  cf:	01 d0                	add    %edx,%eax
  d1:	8b 00                	mov    (%eax),%eax
  d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  da:	00 
  db:	89 04 24             	mov    %eax,(%esp)
  de:	e8 5d 06 00 00       	call   740 <sigsend>


void primsrv(int pid, int value) {
  int i = NUM_WORKERS;
  if (value == 0 ) { 
    while(i --> 0)
  e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  ec:	85 c0                	test   %eax,%eax
  ee:	7f ce                	jg     be <primsrv+0x16>
     sigsend(workers[i-1], 0); 
    printf(1, "primsrv exit \n");
  f0:	c7 44 24 04 16 0c 00 	movl   $0xc16,0x4(%esp)
  f7:	00 
  f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ff:	e8 34 07 00 00       	call   838 <printf>
    exit();
 104:	e8 8f 05 00 00       	call   698 <exit>
  }
  while (i --> 0)
 109:	eb 1c                	jmp    127 <primsrv+0x7f>
    if(workers[i-1] == pid) { 
 10b:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 110:	8b 55 f4             	mov    -0xc(%ebp),%edx
 113:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 119:	c1 e2 02             	shl    $0x2,%edx
 11c:	01 d0                	add    %edx,%eax
 11e:	8b 00                	mov    (%eax),%eax
 120:	3b 45 08             	cmp    0x8(%ebp),%eax
 123:	75 02                	jne    127 <primsrv+0x7f>
      break;
 125:	eb 0d                	jmp    134 <primsrv+0x8c>
    while(i --> 0)
     sigsend(workers[i-1], 0); 
    printf(1, "primsrv exit \n");
    exit();
  }
  while (i --> 0)
 127:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12a:	8d 50 ff             	lea    -0x1(%eax),%edx
 12d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 130:	85 c0                	test   %eax,%eax
 132:	7f d7                	jg     10b <primsrv+0x63>
    if(workers[i-1] == pid) { 
      break;
    }
  printf(1, "worker %d returned %d for %d \n", pid, value, busy_workers[i-1]);
 134:	a1 d0 0f 00 00       	mov    0xfd0,%eax
 139:	8b 55 f4             	mov    -0xc(%ebp),%edx
 13c:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 142:	c1 e2 02             	shl    $0x2,%edx
 145:	01 d0                	add    %edx,%eax
 147:	8b 00                	mov    (%eax),%eax
 149:	89 44 24 10          	mov    %eax,0x10(%esp)
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	89 44 24 0c          	mov    %eax,0xc(%esp)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	89 44 24 08          	mov    %eax,0x8(%esp)
 15b:	c7 44 24 04 28 0c 00 	movl   $0xc28,0x4(%esp)
 162:	00 
 163:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16a:	e8 c9 06 00 00       	call   838 <printf>

  busy_workers[i-1] = NOT_BUSY;
 16f:	a1 d0 0f 00 00       	mov    0xfd0,%eax
 174:	8b 55 f4             	mov    -0xc(%ebp),%edx
 177:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 17d:	c1 e2 02             	shl    $0x2,%edx
 180:	01 d0                	add    %edx,%eax
 182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <main>:

void find_worker(int *, int*, int);
void null_terminate(char*);

int main(int argc, char** argv){
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 e4 f0             	and    $0xfffffff0,%esp
 190:	83 ec 40             	sub    $0x40,%esp
  int n, pid; 
  n = atoi((argc > 1) ? *(argv+1) : "1");  
 193:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 197:	7e 08                	jle    1a1 <main+0x17>
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	8b 40 04             	mov    0x4(%eax),%eax
 19f:	eb 05                	jmp    1a6 <main+0x1c>
 1a1:	b8 47 0c 00 00       	mov    $0xc47,%eax
 1a6:	89 04 24             	mov    %eax,(%esp)
 1a9:	e8 58 04 00 00       	call   606 <atoi>
 1ae:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  char buffer[BUFFER_SIZE];

  NUM_WORKERS = n;
 1b2:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1b6:	a3 cc 0f 00 00       	mov    %eax,0xfcc
  workers = malloc(sizeof(workers) * n); // pid table of workers;
 1bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1bf:	c1 e0 02             	shl    $0x2,%eax
 1c2:	89 04 24             	mov    %eax,(%esp)
 1c5:	e8 5a 09 00 00       	call   b24 <malloc>
 1ca:	a3 c8 0f 00 00       	mov    %eax,0xfc8
  busy_workers = malloc(sizeof(busy_workers) * n);
 1cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1d3:	c1 e0 02             	shl    $0x2,%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 46 09 00 00       	call   b24 <malloc>
 1de:	a3 d0 0f 00 00       	mov    %eax,0xfd0

  while(n --> 0){
 1e3:	eb 57                	jmp    23c <main+0xb2>
    pid = fork();
 1e5:	e8 a6 04 00 00       	call   690 <fork>
 1ea:	89 44 24 38          	mov    %eax,0x38(%esp)

    if(pid == 0) { // child code
 1ee:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
 1f3:	75 13                	jne    208 <main+0x7e>
      sigset(handler);
 1f5:	c7 04 24 3a 00 00 00 	movl   $0x3a,(%esp)
 1fc:	e8 37 05 00 00       	call   738 <sigset>
      while(1) {
        sigpause();
 201:	e8 4a 05 00 00       	call   750 <sigpause>
      }
 206:	eb f9                	jmp    201 <main+0x77>
    }
    else {
      workers[n-1] = pid;
 208:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 20d:	8b 54 24 3c          	mov    0x3c(%esp),%edx
 211:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 217:	c1 e2 02             	shl    $0x2,%edx
 21a:	01 c2                	add    %eax,%edx
 21c:	8b 44 24 38          	mov    0x38(%esp),%eax
 220:	89 02                	mov    %eax,(%edx)
      busy_workers[n-1] = NOT_BUSY;
 222:	a1 d0 0f 00 00       	mov    0xfd0,%eax
 227:	8b 54 24 3c          	mov    0x3c(%esp),%edx
 22b:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 231:	c1 e2 02             	shl    $0x2,%edx
 234:	01 d0                	add    %edx,%eax
 236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  NUM_WORKERS = n;
  workers = malloc(sizeof(workers) * n); // pid table of workers;
  busy_workers = malloc(sizeof(busy_workers) * n);

  while(n --> 0){
 23c:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 240:	8d 50 ff             	lea    -0x1(%eax),%edx
 243:	89 54 24 3c          	mov    %edx,0x3c(%esp)
 247:	85 c0                	test   %eax,%eax
 249:	7f 9a                	jg     1e5 <main+0x5b>
    else {
      workers[n-1] = pid;
      busy_workers[n-1] = NOT_BUSY;
    }
  }
  sigset(primsrv);
 24b:	c7 04 24 a8 00 00 00 	movl   $0xa8,(%esp)
 252:	e8 e1 04 00 00       	call   738 <sigset>
  printf(1, "worker pids: \n");
 257:	c7 44 24 04 49 0c 00 	movl   $0xc49,0x4(%esp)
 25e:	00 
 25f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 266:	e8 cd 05 00 00       	call   838 <printf>
  n = NUM_WORKERS; 
 26b:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 270:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  while (n --> 0)
 274:	eb 2e                	jmp    2a4 <main+0x11a>
    printf(1, "%d \n", workers[n-1]);
 276:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 27b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
 27f:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 285:	c1 e2 02             	shl    $0x2,%edx
 288:	01 d0                	add    %edx,%eax
 28a:	8b 00                	mov    (%eax),%eax
 28c:	89 44 24 08          	mov    %eax,0x8(%esp)
 290:	c7 44 24 04 58 0c 00 	movl   $0xc58,0x4(%esp)
 297:	00 
 298:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 29f:	e8 94 05 00 00       	call   838 <printf>
    }
  }
  sigset(primsrv);
  printf(1, "worker pids: \n");
  n = NUM_WORKERS; 
  while (n --> 0)
 2a4:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 2a8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ab:	89 54 24 3c          	mov    %edx,0x3c(%esp)
 2af:	85 c0                	test   %eax,%eax
 2b1:	7f c3                	jg     276 <main+0xec>
    printf(1, "%d \n", workers[n-1]);

  while(1) {
    printf(1, "please enter a number: ");
 2b3:	c7 44 24 04 5d 0c 00 	movl   $0xc5d,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 71 05 00 00       	call   838 <printf>
    gets(buffer, BUFFER_SIZE);
 2c7:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
 2ce:	00 
 2cf:	8d 44 24 18          	lea    0x18(%esp),%eax
 2d3:	89 04 24             	mov    %eax,(%esp)
 2d6:	e8 67 02 00 00       	call   542 <gets>
    null_terminate(buffer);
 2db:	8d 44 24 18          	lea    0x18(%esp),%eax
 2df:	89 04 24             	mov    %eax,(%esp)
 2e2:	e8 67 00 00 00       	call   34e <null_terminate>
    if(*buffer != 0) {
 2e7:	0f b6 44 24 18       	movzbl 0x18(%esp),%eax
 2ec:	84 c0                	test   %al,%al
 2ee:	74 36                	je     326 <main+0x19c>
      n = atoi(buffer);
 2f0:	8d 44 24 18          	lea    0x18(%esp),%eax
 2f4:	89 04 24             	mov    %eax,(%esp)
 2f7:	e8 0a 03 00 00       	call   606 <atoi>
 2fc:	89 44 24 3c          	mov    %eax,0x3c(%esp)
      *buffer = 0;
 300:	c6 44 24 18 00       	movb   $0x0,0x18(%esp)
      find_worker(workers, busy_workers, n);
 305:	8b 15 d0 0f 00 00    	mov    0xfd0,%edx
 30b:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 310:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
 314:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 318:	89 54 24 04          	mov    %edx,0x4(%esp)
 31c:	89 04 24             	mov    %eax,(%esp)
 31f:	e8 57 00 00 00       	call   37b <find_worker>
    }
  }
 324:	eb 8d                	jmp    2b3 <main+0x129>
 326:	eb 8b                	jmp    2b3 <main+0x129>

00000328 <isdigit>:

}

int isdigit(char d){
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	88 45 fc             	mov    %al,-0x4(%ebp)
  return !(d < '0' || d > '9');
 334:	80 7d fc 2f          	cmpb   $0x2f,-0x4(%ebp)
 338:	7e 0d                	jle    347 <isdigit+0x1f>
 33a:	80 7d fc 39          	cmpb   $0x39,-0x4(%ebp)
 33e:	7f 07                	jg     347 <isdigit+0x1f>
 340:	b8 01 00 00 00       	mov    $0x1,%eax
 345:	eb 05                	jmp    34c <isdigit+0x24>
 347:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <null_terminate>:
// assumes buff ends with \n
void null_terminate(char * buff) {
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 04             	sub    $0x4,%esp
  while(isdigit(*buff++));
 354:	90                   	nop
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	8d 50 01             	lea    0x1(%eax),%edx
 35b:	89 55 08             	mov    %edx,0x8(%ebp)
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	0f be c0             	movsbl %al,%eax
 364:	89 04 24             	mov    %eax,(%esp)
 367:	e8 bc ff ff ff       	call   328 <isdigit>
 36c:	85 c0                	test   %eax,%eax
 36e:	75 e5                	jne    355 <null_terminate+0x7>
  *(buff-1) = 0;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	83 e8 01             	sub    $0x1,%eax
 376:	c6 00 00             	movb   $0x0,(%eax)
}
 379:	c9                   	leave  
 37a:	c3                   	ret    

0000037b <find_worker>:

void find_worker(int* workers, int* busy_workers, int value) {
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 28             	sub    $0x28,%esp
 int n = NUM_WORKERS - 1;
 381:	a1 cc 0f 00 00       	mov    0xfcc,%eax
 386:	83 e8 01             	sub    $0x1,%eax
 389:	89 45 f4             	mov    %eax,-0xc(%ebp)
 while(n --> -1)
 38c:	eb 7b                	jmp    409 <find_worker+0x8e>
   if(busy_workers[n] == NOT_BUSY) {
 38e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 398:	8b 45 0c             	mov    0xc(%ebp),%eax
 39b:	01 d0                	add    %edx,%eax
 39d:	8b 00                	mov    (%eax),%eax
 39f:	85 c0                	test   %eax,%eax
 3a1:	75 66                	jne    409 <find_worker+0x8e>
     busy_workers[n] = value;
 3a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	01 c2                	add    %eax,%edx
 3b2:	8b 45 10             	mov    0x10(%ebp),%eax
 3b5:	89 02                	mov    %eax,(%edx)
     printf(1, "SENDING %d to %d \n", value, workers[n]);
 3b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	01 d0                	add    %edx,%eax
 3c6:	8b 00                	mov    (%eax),%eax
 3c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3cc:	8b 45 10             	mov    0x10(%ebp),%eax
 3cf:	89 44 24 08          	mov    %eax,0x8(%esp)
 3d3:	c7 44 24 04 75 0c 00 	movl   $0xc75,0x4(%esp)
 3da:	00 
 3db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3e2:	e8 51 04 00 00       	call   838 <printf>
     sigsend(workers[n], value);
 3e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	8b 00                	mov    (%eax),%eax
 3f8:	8b 55 10             	mov    0x10(%ebp),%edx
 3fb:	89 54 24 04          	mov    %edx,0x4(%esp)
 3ff:	89 04 24             	mov    %eax,(%esp)
 402:	e8 39 03 00 00       	call   740 <sigsend>
     return;
 407:	eb 25                	jmp    42e <find_worker+0xb3>
  *(buff-1) = 0;
}

void find_worker(int* workers, int* busy_workers, int value) {
 int n = NUM_WORKERS - 1;
 while(n --> -1)
 409:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40c:	8d 50 ff             	lea    -0x1(%eax),%edx
 40f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 412:	85 c0                	test   %eax,%eax
 414:	0f 89 74 ff ff ff    	jns    38e <find_worker+0x13>
     busy_workers[n] = value;
     printf(1, "SENDING %d to %d \n", value, workers[n]);
     sigsend(workers[n], value);
     return;
   }
 printf(1, "no idle workers.\n"); 
 41a:	c7 44 24 04 88 0c 00 	movl   $0xc88,0x4(%esp)
 421:	00 
 422:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 429:	e8 0a 04 00 00       	call   838 <printf>
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 435:	8b 4d 08             	mov    0x8(%ebp),%ecx
 438:	8b 55 10             	mov    0x10(%ebp),%edx
 43b:	8b 45 0c             	mov    0xc(%ebp),%eax
 43e:	89 cb                	mov    %ecx,%ebx
 440:	89 df                	mov    %ebx,%edi
 442:	89 d1                	mov    %edx,%ecx
 444:	fc                   	cld    
 445:	f3 aa                	rep stos %al,%es:(%edi)
 447:	89 ca                	mov    %ecx,%edx
 449:	89 fb                	mov    %edi,%ebx
 44b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 44e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 451:	5b                   	pop    %ebx
 452:	5f                   	pop    %edi
 453:	5d                   	pop    %ebp
 454:	c3                   	ret    

00000455 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 455:	55                   	push   %ebp
 456:	89 e5                	mov    %esp,%ebp
 458:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 45b:	8b 45 08             	mov    0x8(%ebp),%eax
 45e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 461:	90                   	nop
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	8d 50 01             	lea    0x1(%eax),%edx
 468:	89 55 08             	mov    %edx,0x8(%ebp)
 46b:	8b 55 0c             	mov    0xc(%ebp),%edx
 46e:	8d 4a 01             	lea    0x1(%edx),%ecx
 471:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 474:	0f b6 12             	movzbl (%edx),%edx
 477:	88 10                	mov    %dl,(%eax)
 479:	0f b6 00             	movzbl (%eax),%eax
 47c:	84 c0                	test   %al,%al
 47e:	75 e2                	jne    462 <strcpy+0xd>
    ;
  return os;
 480:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 483:	c9                   	leave  
 484:	c3                   	ret    

00000485 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 488:	eb 08                	jmp    492 <strcmp+0xd>
    p++, q++;
 48a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 48e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	0f b6 00             	movzbl (%eax),%eax
 498:	84 c0                	test   %al,%al
 49a:	74 10                	je     4ac <strcmp+0x27>
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	0f b6 10             	movzbl (%eax),%edx
 4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	38 c2                	cmp    %al,%dl
 4aa:	74 de                	je     48a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f b6 d0             	movzbl %al,%edx
 4b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b8:	0f b6 00             	movzbl (%eax),%eax
 4bb:	0f b6 c0             	movzbl %al,%eax
 4be:	29 c2                	sub    %eax,%edx
 4c0:	89 d0                	mov    %edx,%eax
}
 4c2:	5d                   	pop    %ebp
 4c3:	c3                   	ret    

000004c4 <strlen>:

uint
strlen(char *s)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4d1:	eb 04                	jmp    4d7 <strlen+0x13>
 4d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	0f b6 00             	movzbl (%eax),%eax
 4e2:	84 c0                	test   %al,%al
 4e4:	75 ed                	jne    4d3 <strlen+0xf>
    ;
  return n;
 4e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4e9:	c9                   	leave  
 4ea:	c3                   	ret    

000004eb <memset>:

void*
memset(void *dst, int c, uint n)
{
 4eb:	55                   	push   %ebp
 4ec:	89 e5                	mov    %esp,%ebp
 4ee:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 4f1:	8b 45 10             	mov    0x10(%ebp),%eax
 4f4:	89 44 24 08          	mov    %eax,0x8(%esp)
 4f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 26 ff ff ff       	call   430 <stosb>
  return dst;
 50a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 50d:	c9                   	leave  
 50e:	c3                   	ret    

0000050f <strchr>:

char*
strchr(const char *s, char c)
{
 50f:	55                   	push   %ebp
 510:	89 e5                	mov    %esp,%ebp
 512:	83 ec 04             	sub    $0x4,%esp
 515:	8b 45 0c             	mov    0xc(%ebp),%eax
 518:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 51b:	eb 14                	jmp    531 <strchr+0x22>
    if(*s == c)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	3a 45 fc             	cmp    -0x4(%ebp),%al
 526:	75 05                	jne    52d <strchr+0x1e>
      return (char*)s;
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	eb 13                	jmp    540 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 52d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	0f b6 00             	movzbl (%eax),%eax
 537:	84 c0                	test   %al,%al
 539:	75 e2                	jne    51d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 53b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 540:	c9                   	leave  
 541:	c3                   	ret    

00000542 <gets>:

char*
gets(char *buf, int max)
{
 542:	55                   	push   %ebp
 543:	89 e5                	mov    %esp,%ebp
 545:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 548:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 54f:	eb 4c                	jmp    59d <gets+0x5b>
    cc = read(0, &c, 1);
 551:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 558:	00 
 559:	8d 45 ef             	lea    -0x11(%ebp),%eax
 55c:	89 44 24 04          	mov    %eax,0x4(%esp)
 560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 567:	e8 44 01 00 00       	call   6b0 <read>
 56c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 56f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 573:	7f 02                	jg     577 <gets+0x35>
      break;
 575:	eb 31                	jmp    5a8 <gets+0x66>
    buf[i++] = c;
 577:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57a:	8d 50 01             	lea    0x1(%eax),%edx
 57d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 580:	89 c2                	mov    %eax,%edx
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	01 c2                	add    %eax,%edx
 587:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 58b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 58d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 591:	3c 0a                	cmp    $0xa,%al
 593:	74 13                	je     5a8 <gets+0x66>
 595:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 599:	3c 0d                	cmp    $0xd,%al
 59b:	74 0b                	je     5a8 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 59d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a0:	83 c0 01             	add    $0x1,%eax
 5a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5a6:	7c a9                	jl     551 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	01 d0                	add    %edx,%eax
 5b0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b6:	c9                   	leave  
 5b7:	c3                   	ret    

000005b8 <stat>:

int
stat(char *n, struct stat *st)
{
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5c5:	00 
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	89 04 24             	mov    %eax,(%esp)
 5cc:	e8 07 01 00 00       	call   6d8 <open>
 5d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d8:	79 07                	jns    5e1 <stat+0x29>
    return -1;
 5da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5df:	eb 23                	jmp    604 <stat+0x4c>
  r = fstat(fd, st);
 5e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5eb:	89 04 24             	mov    %eax,(%esp)
 5ee:	e8 fd 00 00 00       	call   6f0 <fstat>
 5f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 bf 00 00 00       	call   6c0 <close>
  return r;
 601:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 604:	c9                   	leave  
 605:	c3                   	ret    

00000606 <atoi>:

int
atoi(const char *s)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
 609:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 60c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 613:	eb 25                	jmp    63a <atoi+0x34>
    n = n*10 + *s++ - '0';
 615:	8b 55 fc             	mov    -0x4(%ebp),%edx
 618:	89 d0                	mov    %edx,%eax
 61a:	c1 e0 02             	shl    $0x2,%eax
 61d:	01 d0                	add    %edx,%eax
 61f:	01 c0                	add    %eax,%eax
 621:	89 c1                	mov    %eax,%ecx
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	8d 50 01             	lea    0x1(%eax),%edx
 629:	89 55 08             	mov    %edx,0x8(%ebp)
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	01 c8                	add    %ecx,%eax
 634:	83 e8 30             	sub    $0x30,%eax
 637:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	3c 2f                	cmp    $0x2f,%al
 642:	7e 0a                	jle    64e <atoi+0x48>
 644:	8b 45 08             	mov    0x8(%ebp),%eax
 647:	0f b6 00             	movzbl (%eax),%eax
 64a:	3c 39                	cmp    $0x39,%al
 64c:	7e c7                	jle    615 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 651:	c9                   	leave  
 652:	c3                   	ret    

00000653 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 653:	55                   	push   %ebp
 654:	89 e5                	mov    %esp,%ebp
 656:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 659:	8b 45 08             	mov    0x8(%ebp),%eax
 65c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 65f:	8b 45 0c             	mov    0xc(%ebp),%eax
 662:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 665:	eb 17                	jmp    67e <memmove+0x2b>
    *dst++ = *src++;
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8d 50 01             	lea    0x1(%eax),%edx
 66d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 670:	8b 55 f8             	mov    -0x8(%ebp),%edx
 673:	8d 4a 01             	lea    0x1(%edx),%ecx
 676:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 679:	0f b6 12             	movzbl (%edx),%edx
 67c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 67e:	8b 45 10             	mov    0x10(%ebp),%eax
 681:	8d 50 ff             	lea    -0x1(%eax),%edx
 684:	89 55 10             	mov    %edx,0x10(%ebp)
 687:	85 c0                	test   %eax,%eax
 689:	7f dc                	jg     667 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 68e:	c9                   	leave  
 68f:	c3                   	ret    

00000690 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 690:	b8 01 00 00 00       	mov    $0x1,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <exit>:
SYSCALL(exit)
 698:	b8 02 00 00 00       	mov    $0x2,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <wait>:
SYSCALL(wait)
 6a0:	b8 03 00 00 00       	mov    $0x3,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <pipe>:
SYSCALL(pipe)
 6a8:	b8 04 00 00 00       	mov    $0x4,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <read>:
SYSCALL(read)
 6b0:	b8 05 00 00 00       	mov    $0x5,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <write>:
SYSCALL(write)
 6b8:	b8 10 00 00 00       	mov    $0x10,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <close>:
SYSCALL(close)
 6c0:	b8 15 00 00 00       	mov    $0x15,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <kill>:
SYSCALL(kill)
 6c8:	b8 06 00 00 00       	mov    $0x6,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <exec>:
SYSCALL(exec)
 6d0:	b8 07 00 00 00       	mov    $0x7,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <open>:
SYSCALL(open)
 6d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <mknod>:
SYSCALL(mknod)
 6e0:	b8 11 00 00 00       	mov    $0x11,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <unlink>:
SYSCALL(unlink)
 6e8:	b8 12 00 00 00       	mov    $0x12,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <fstat>:
SYSCALL(fstat)
 6f0:	b8 08 00 00 00       	mov    $0x8,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <link>:
SYSCALL(link)
 6f8:	b8 13 00 00 00       	mov    $0x13,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <mkdir>:
SYSCALL(mkdir)
 700:	b8 14 00 00 00       	mov    $0x14,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <chdir>:
SYSCALL(chdir)
 708:	b8 09 00 00 00       	mov    $0x9,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <dup>:
SYSCALL(dup)
 710:	b8 0a 00 00 00       	mov    $0xa,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <getpid>:
SYSCALL(getpid)
 718:	b8 0b 00 00 00       	mov    $0xb,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <sbrk>:
SYSCALL(sbrk)
 720:	b8 0c 00 00 00       	mov    $0xc,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <sleep>:
SYSCALL(sleep)
 728:	b8 0d 00 00 00       	mov    $0xd,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <uptime>:
SYSCALL(uptime)
 730:	b8 0e 00 00 00       	mov    $0xe,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <sigset>:
SYSCALL(sigset)
 738:	b8 16 00 00 00       	mov    $0x16,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <sigsend>:
SYSCALL(sigsend)
 740:	b8 17 00 00 00       	mov    $0x17,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <sigret>:
SYSCALL(sigret)
 748:	b8 18 00 00 00       	mov    $0x18,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <sigpause>:
SYSCALL(sigpause)
 750:	b8 19 00 00 00       	mov    $0x19,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 18             	sub    $0x18,%esp
 75e:	8b 45 0c             	mov    0xc(%ebp),%eax
 761:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 764:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 76b:	00 
 76c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 76f:	89 44 24 04          	mov    %eax,0x4(%esp)
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 3a ff ff ff       	call   6b8 <write>
}
 77e:	c9                   	leave  
 77f:	c3                   	ret    

00000780 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	56                   	push   %esi
 784:	53                   	push   %ebx
 785:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 788:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 78f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 793:	74 17                	je     7ac <printint+0x2c>
 795:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 799:	79 11                	jns    7ac <printint+0x2c>
    neg = 1;
 79b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a5:	f7 d8                	neg    %eax
 7a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7aa:	eb 06                	jmp    7b2 <printint+0x32>
  } else {
    x = xx;
 7ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 7af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7bc:	8d 41 01             	lea    0x1(%ecx),%eax
 7bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c8:	ba 00 00 00 00       	mov    $0x0,%edx
 7cd:	f7 f3                	div    %ebx
 7cf:	89 d0                	mov    %edx,%eax
 7d1:	0f b6 80 a8 0f 00 00 	movzbl 0xfa8(%eax),%eax
 7d8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7dc:	8b 75 10             	mov    0x10(%ebp),%esi
 7df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e2:	ba 00 00 00 00       	mov    $0x0,%edx
 7e7:	f7 f6                	div    %esi
 7e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7f0:	75 c7                	jne    7b9 <printint+0x39>
  if(neg)
 7f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f6:	74 10                	je     808 <printint+0x88>
    buf[i++] = '-';
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8d 50 01             	lea    0x1(%eax),%edx
 7fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 801:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 806:	eb 1f                	jmp    827 <printint+0xa7>
 808:	eb 1d                	jmp    827 <printint+0xa7>
    putc(fd, buf[i]);
 80a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	01 d0                	add    %edx,%eax
 812:	0f b6 00             	movzbl (%eax),%eax
 815:	0f be c0             	movsbl %al,%eax
 818:	89 44 24 04          	mov    %eax,0x4(%esp)
 81c:	8b 45 08             	mov    0x8(%ebp),%eax
 81f:	89 04 24             	mov    %eax,(%esp)
 822:	e8 31 ff ff ff       	call   758 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 827:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 82b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82f:	79 d9                	jns    80a <printint+0x8a>
    putc(fd, buf[i]);
}
 831:	83 c4 30             	add    $0x30,%esp
 834:	5b                   	pop    %ebx
 835:	5e                   	pop    %esi
 836:	5d                   	pop    %ebp
 837:	c3                   	ret    

00000838 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 838:	55                   	push   %ebp
 839:	89 e5                	mov    %esp,%ebp
 83b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 83e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 845:	8d 45 0c             	lea    0xc(%ebp),%eax
 848:	83 c0 04             	add    $0x4,%eax
 84b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 84e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 855:	e9 7c 01 00 00       	jmp    9d6 <printf+0x19e>
    c = fmt[i] & 0xff;
 85a:	8b 55 0c             	mov    0xc(%ebp),%edx
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	01 d0                	add    %edx,%eax
 862:	0f b6 00             	movzbl (%eax),%eax
 865:	0f be c0             	movsbl %al,%eax
 868:	25 ff 00 00 00       	and    $0xff,%eax
 86d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 870:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 874:	75 2c                	jne    8a2 <printf+0x6a>
      if(c == '%'){
 876:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 87a:	75 0c                	jne    888 <printf+0x50>
        state = '%';
 87c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 883:	e9 4a 01 00 00       	jmp    9d2 <printf+0x19a>
      } else {
        putc(fd, c);
 888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88b:	0f be c0             	movsbl %al,%eax
 88e:	89 44 24 04          	mov    %eax,0x4(%esp)
 892:	8b 45 08             	mov    0x8(%ebp),%eax
 895:	89 04 24             	mov    %eax,(%esp)
 898:	e8 bb fe ff ff       	call   758 <putc>
 89d:	e9 30 01 00 00       	jmp    9d2 <printf+0x19a>
      }
    } else if(state == '%'){
 8a2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8a6:	0f 85 26 01 00 00    	jne    9d2 <printf+0x19a>
      if(c == 'd'){
 8ac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8b0:	75 2d                	jne    8df <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b5:	8b 00                	mov    (%eax),%eax
 8b7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8be:	00 
 8bf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8c6:	00 
 8c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8cb:	8b 45 08             	mov    0x8(%ebp),%eax
 8ce:	89 04 24             	mov    %eax,(%esp)
 8d1:	e8 aa fe ff ff       	call   780 <printint>
        ap++;
 8d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8da:	e9 ec 00 00 00       	jmp    9cb <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 8df:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8e3:	74 06                	je     8eb <printf+0xb3>
 8e5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8e9:	75 2d                	jne    918 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 8eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8f7:	00 
 8f8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8ff:	00 
 900:	89 44 24 04          	mov    %eax,0x4(%esp)
 904:	8b 45 08             	mov    0x8(%ebp),%eax
 907:	89 04 24             	mov    %eax,(%esp)
 90a:	e8 71 fe ff ff       	call   780 <printint>
        ap++;
 90f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 913:	e9 b3 00 00 00       	jmp    9cb <printf+0x193>
      } else if(c == 's'){
 918:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 91c:	75 45                	jne    963 <printf+0x12b>
        s = (char*)*ap;
 91e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 921:	8b 00                	mov    (%eax),%eax
 923:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 926:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 92a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92e:	75 09                	jne    939 <printf+0x101>
          s = "(null)";
 930:	c7 45 f4 9a 0c 00 00 	movl   $0xc9a,-0xc(%ebp)
        while(*s != 0){
 937:	eb 1e                	jmp    957 <printf+0x11f>
 939:	eb 1c                	jmp    957 <printf+0x11f>
          putc(fd, *s);
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	0f b6 00             	movzbl (%eax),%eax
 941:	0f be c0             	movsbl %al,%eax
 944:	89 44 24 04          	mov    %eax,0x4(%esp)
 948:	8b 45 08             	mov    0x8(%ebp),%eax
 94b:	89 04 24             	mov    %eax,(%esp)
 94e:	e8 05 fe ff ff       	call   758 <putc>
          s++;
 953:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	0f b6 00             	movzbl (%eax),%eax
 95d:	84 c0                	test   %al,%al
 95f:	75 da                	jne    93b <printf+0x103>
 961:	eb 68                	jmp    9cb <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 963:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 967:	75 1d                	jne    986 <printf+0x14e>
        putc(fd, *ap);
 969:	8b 45 e8             	mov    -0x18(%ebp),%eax
 96c:	8b 00                	mov    (%eax),%eax
 96e:	0f be c0             	movsbl %al,%eax
 971:	89 44 24 04          	mov    %eax,0x4(%esp)
 975:	8b 45 08             	mov    0x8(%ebp),%eax
 978:	89 04 24             	mov    %eax,(%esp)
 97b:	e8 d8 fd ff ff       	call   758 <putc>
        ap++;
 980:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 984:	eb 45                	jmp    9cb <printf+0x193>
      } else if(c == '%'){
 986:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 98a:	75 17                	jne    9a3 <printf+0x16b>
        putc(fd, c);
 98c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 98f:	0f be c0             	movsbl %al,%eax
 992:	89 44 24 04          	mov    %eax,0x4(%esp)
 996:	8b 45 08             	mov    0x8(%ebp),%eax
 999:	89 04 24             	mov    %eax,(%esp)
 99c:	e8 b7 fd ff ff       	call   758 <putc>
 9a1:	eb 28                	jmp    9cb <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9a3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9aa:	00 
 9ab:	8b 45 08             	mov    0x8(%ebp),%eax
 9ae:	89 04 24             	mov    %eax,(%esp)
 9b1:	e8 a2 fd ff ff       	call   758 <putc>
        putc(fd, c);
 9b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9b9:	0f be c0             	movsbl %al,%eax
 9bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c0:	8b 45 08             	mov    0x8(%ebp),%eax
 9c3:	89 04 24             	mov    %eax,(%esp)
 9c6:	e8 8d fd ff ff       	call   758 <putc>
      }
      state = 0;
 9cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9d2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 9d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9dc:	01 d0                	add    %edx,%eax
 9de:	0f b6 00             	movzbl (%eax),%eax
 9e1:	84 c0                	test   %al,%al
 9e3:	0f 85 71 fe ff ff    	jne    85a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9e9:	c9                   	leave  
 9ea:	c3                   	ret    

000009eb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9eb:	55                   	push   %ebp
 9ec:	89 e5                	mov    %esp,%ebp
 9ee:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f1:	8b 45 08             	mov    0x8(%ebp),%eax
 9f4:	83 e8 08             	sub    $0x8,%eax
 9f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fa:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 9ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a02:	eb 24                	jmp    a28 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a0c:	77 12                	ja     a20 <free+0x35>
 a0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a11:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a14:	77 24                	ja     a3a <free+0x4f>
 a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a19:	8b 00                	mov    (%eax),%eax
 a1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a1e:	77 1a                	ja     a3a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a23:	8b 00                	mov    (%eax),%eax
 a25:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a28:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a2e:	76 d4                	jbe    a04 <free+0x19>
 a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a33:	8b 00                	mov    (%eax),%eax
 a35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a38:	76 ca                	jbe    a04 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3d:	8b 40 04             	mov    0x4(%eax),%eax
 a40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4a:	01 c2                	add    %eax,%edx
 a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4f:	8b 00                	mov    (%eax),%eax
 a51:	39 c2                	cmp    %eax,%edx
 a53:	75 24                	jne    a79 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a55:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a58:	8b 50 04             	mov    0x4(%eax),%edx
 a5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5e:	8b 00                	mov    (%eax),%eax
 a60:	8b 40 04             	mov    0x4(%eax),%eax
 a63:	01 c2                	add    %eax,%edx
 a65:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a68:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6e:	8b 00                	mov    (%eax),%eax
 a70:	8b 10                	mov    (%eax),%edx
 a72:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a75:	89 10                	mov    %edx,(%eax)
 a77:	eb 0a                	jmp    a83 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7c:	8b 10                	mov    (%eax),%edx
 a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a81:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a86:	8b 40 04             	mov    0x4(%eax),%eax
 a89:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a93:	01 d0                	add    %edx,%eax
 a95:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a98:	75 20                	jne    aba <free+0xcf>
    p->s.size += bp->s.size;
 a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9d:	8b 50 04             	mov    0x4(%eax),%edx
 aa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa3:	8b 40 04             	mov    0x4(%eax),%eax
 aa6:	01 c2                	add    %eax,%edx
 aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aab:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 aae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab1:	8b 10                	mov    (%eax),%edx
 ab3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab6:	89 10                	mov    %edx,(%eax)
 ab8:	eb 08                	jmp    ac2 <free+0xd7>
  } else
    p->s.ptr = bp;
 aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ac0:	89 10                	mov    %edx,(%eax)
  freep = p;
 ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac5:	a3 c4 0f 00 00       	mov    %eax,0xfc4
}
 aca:	c9                   	leave  
 acb:	c3                   	ret    

00000acc <morecore>:

static Header*
morecore(uint nu)
{
 acc:	55                   	push   %ebp
 acd:	89 e5                	mov    %esp,%ebp
 acf:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ad2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ad9:	77 07                	ja     ae2 <morecore+0x16>
    nu = 4096;
 adb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ae2:	8b 45 08             	mov    0x8(%ebp),%eax
 ae5:	c1 e0 03             	shl    $0x3,%eax
 ae8:	89 04 24             	mov    %eax,(%esp)
 aeb:	e8 30 fc ff ff       	call   720 <sbrk>
 af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 af3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 af7:	75 07                	jne    b00 <morecore+0x34>
    return 0;
 af9:	b8 00 00 00 00       	mov    $0x0,%eax
 afe:	eb 22                	jmp    b22 <morecore+0x56>
  hp = (Header*)p;
 b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b09:	8b 55 08             	mov    0x8(%ebp),%edx
 b0c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b12:	83 c0 08             	add    $0x8,%eax
 b15:	89 04 24             	mov    %eax,(%esp)
 b18:	e8 ce fe ff ff       	call   9eb <free>
  return freep;
 b1d:	a1 c4 0f 00 00       	mov    0xfc4,%eax
}
 b22:	c9                   	leave  
 b23:	c3                   	ret    

00000b24 <malloc>:

void*
malloc(uint nbytes)
{
 b24:	55                   	push   %ebp
 b25:	89 e5                	mov    %esp,%ebp
 b27:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b2a:	8b 45 08             	mov    0x8(%ebp),%eax
 b2d:	83 c0 07             	add    $0x7,%eax
 b30:	c1 e8 03             	shr    $0x3,%eax
 b33:	83 c0 01             	add    $0x1,%eax
 b36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b39:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b45:	75 23                	jne    b6a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b47:	c7 45 f0 bc 0f 00 00 	movl   $0xfbc,-0x10(%ebp)
 b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b51:	a3 c4 0f 00 00       	mov    %eax,0xfc4
 b56:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 b5b:	a3 bc 0f 00 00       	mov    %eax,0xfbc
    base.s.size = 0;
 b60:	c7 05 c0 0f 00 00 00 	movl   $0x0,0xfc0
 b67:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6d:	8b 00                	mov    (%eax),%eax
 b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b75:	8b 40 04             	mov    0x4(%eax),%eax
 b78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b7b:	72 4d                	jb     bca <malloc+0xa6>
      if(p->s.size == nunits)
 b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b80:	8b 40 04             	mov    0x4(%eax),%eax
 b83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b86:	75 0c                	jne    b94 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8b:	8b 10                	mov    (%eax),%edx
 b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b90:	89 10                	mov    %edx,(%eax)
 b92:	eb 26                	jmp    bba <malloc+0x96>
      else {
        p->s.size -= nunits;
 b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b97:	8b 40 04             	mov    0x4(%eax),%eax
 b9a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b9d:	89 c2                	mov    %eax,%edx
 b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba8:	8b 40 04             	mov    0x4(%eax),%eax
 bab:	c1 e0 03             	shl    $0x3,%eax
 bae:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bb7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bbd:	a3 c4 0f 00 00       	mov    %eax,0xfc4
      return (void*)(p + 1);
 bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc5:	83 c0 08             	add    $0x8,%eax
 bc8:	eb 38                	jmp    c02 <malloc+0xde>
    }
    if(p == freep)
 bca:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 bcf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bd2:	75 1b                	jne    bef <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bd7:	89 04 24             	mov    %eax,(%esp)
 bda:	e8 ed fe ff ff       	call   acc <morecore>
 bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 be6:	75 07                	jne    bef <malloc+0xcb>
        return 0;
 be8:	b8 00 00 00 00       	mov    $0x0,%eax
 bed:	eb 13                	jmp    c02 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf8:	8b 00                	mov    (%eax),%eax
 bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bfd:	e9 70 ff ff ff       	jmp    b72 <malloc+0x4e>
}
 c02:	c9                   	leave  
 c03:	c3                   	ret    
