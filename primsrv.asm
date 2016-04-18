
_primsrv:     file format elf32-i386


Disassembly of section .text:

00000000 <isprime>:
#define BUFFER_SIZE 32
#define NOT_BUSY 0 
#define db printf(1, "%d \n", __LINE__);
#define stdin 0

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
#define db printf(1, "%d \n", __LINE__);
#define stdin 0

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
  44:	75 22                	jne    68 <handler+0x2e>
    printf(1, "worker %d, exit \n", getpid());
  46:	e8 fb 06 00 00       	call   746 <getpid>
  4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  4f:	c7 44 24 04 34 0c 00 	movl   $0xc34,0x4(%esp)
  56:	00 
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 03 08 00 00       	call   866 <printf>
    exit();
  63:	e8 5e 06 00 00       	call   6c6 <exit>
  }
  while (!isprime(++value));
  68:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  6f:	89 04 24             	mov    %eax,(%esp)
  72:	e8 89 ff ff ff       	call   0 <isprime>
  77:	85 c0                	test   %eax,%eax
  79:	74 ed                	je     68 <handler+0x2e>
  sleep(100);
  7b:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  82:	e8 cf 06 00 00       	call   756 <sleep>
  sigsend(pid, value);
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  8e:	8b 45 08             	mov    0x8(%ebp),%eax
  91:	89 04 24             	mov    %eax,(%esp)
  94:	e8 d5 06 00 00       	call   76e <sigsend>
}
  99:	c9                   	leave  
  9a:	c3                   	ret    

0000009b <primsrv>:
int * workers;
int * busy_workers;
int NUM_WORKERS;


void primsrv(int pid, int value) {
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	83 ec 38             	sub    $0x38,%esp
  int i = NUM_WORKERS;
  a1:	a1 08 10 00 00       	mov    0x1008,%eax
  a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (value == 0) { 
  a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  ad:	75 57                	jne    106 <primsrv+0x6b>
    while(i --> 0)
  af:	eb 25                	jmp    d6 <primsrv+0x3b>
     sigsend(workers[i-1], 0); 
  b1:	a1 04 10 00 00       	mov    0x1004,%eax
  b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  b9:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
  bf:	c1 e2 02             	shl    $0x2,%edx
  c2:	01 d0                	add    %edx,%eax
  c4:	8b 00                	mov    (%eax),%eax
  c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  cd:	00 
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 98 06 00 00       	call   76e <sigsend>


void primsrv(int pid, int value) {
  int i = NUM_WORKERS;
  if (value == 0) { 
    while(i --> 0)
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  df:	85 c0                	test   %eax,%eax
  e1:	7f ce                	jg     b1 <primsrv+0x16>
     sigsend(workers[i-1], 0); 
    while(wait() > 0);
  e3:	90                   	nop
  e4:	e8 e5 05 00 00       	call   6ce <wait>
  e9:	85 c0                	test   %eax,%eax
  eb:	7f f7                	jg     e4 <primsrv+0x49>

    printf(1, "primsrv exit \n");
  ed:	c7 44 24 04 46 0c 00 	movl   $0xc46,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 65 07 00 00       	call   866 <printf>
    exit();
 101:	e8 c0 05 00 00       	call   6c6 <exit>
  }
  while (i --> 0)
 106:	eb 1c                	jmp    124 <primsrv+0x89>
    if(workers[i-1] == pid) { 
 108:	a1 04 10 00 00       	mov    0x1004,%eax
 10d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 110:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 116:	c1 e2 02             	shl    $0x2,%edx
 119:	01 d0                	add    %edx,%eax
 11b:	8b 00                	mov    (%eax),%eax
 11d:	3b 45 08             	cmp    0x8(%ebp),%eax
 120:	75 02                	jne    124 <primsrv+0x89>
      break;
 122:	eb 0d                	jmp    131 <primsrv+0x96>
    while(wait() > 0);

    printf(1, "primsrv exit \n");
    exit();
  }
  while (i --> 0)
 124:	8b 45 f4             	mov    -0xc(%ebp),%eax
 127:	8d 50 ff             	lea    -0x1(%eax),%edx
 12a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 12d:	85 c0                	test   %eax,%eax
 12f:	7f d7                	jg     108 <primsrv+0x6d>
    if(workers[i-1] == pid) { 
      break;
    }
  printf(1, "worker %d returned %d for %d \n", pid, value, busy_workers[i-1]);
 131:	a1 0c 10 00 00       	mov    0x100c,%eax
 136:	8b 55 f4             	mov    -0xc(%ebp),%edx
 139:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 13f:	c1 e2 02             	shl    $0x2,%edx
 142:	01 d0                	add    %edx,%eax
 144:	8b 00                	mov    (%eax),%eax
 146:	89 44 24 10          	mov    %eax,0x10(%esp)
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 44 24 0c          	mov    %eax,0xc(%esp)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	89 44 24 08          	mov    %eax,0x8(%esp)
 158:	c7 44 24 04 58 0c 00 	movl   $0xc58,0x4(%esp)
 15f:	00 
 160:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 167:	e8 fa 06 00 00       	call   866 <printf>

  busy_workers[i-1] = NOT_BUSY;
 16c:	a1 0c 10 00 00       	mov    0x100c,%eax
 171:	8b 55 f4             	mov    -0xc(%ebp),%edx
 174:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 17a:	c1 e2 02             	shl    $0x2,%edx
 17d:	01 d0                	add    %edx,%eax
 17f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 185:	c9                   	leave  
 186:	c3                   	ret    

00000187 <main>:

void find_worker(int *, int*, int);
void null_terminate(char*);

int main(int argc, char** argv){
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	83 e4 f0             	and    $0xfffffff0,%esp
 18d:	83 ec 40             	sub    $0x40,%esp
  int n, pid; 
  n = atoi((argc > 1) ? *(argv+1) : "1");  
 190:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 194:	7e 08                	jle    19e <main+0x17>
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	8b 40 04             	mov    0x4(%eax),%eax
 19c:	eb 05                	jmp    1a3 <main+0x1c>
 19e:	b8 77 0c 00 00       	mov    $0xc77,%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 89 04 00 00       	call   634 <atoi>
 1ab:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  char buffer[BUFFER_SIZE];

  NUM_WORKERS = n;
 1af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1b3:	a3 08 10 00 00       	mov    %eax,0x1008
  workers = malloc(sizeof(workers) * n); // pid table of workers;
 1b8:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1bc:	c1 e0 02             	shl    $0x2,%eax
 1bf:	89 04 24             	mov    %eax,(%esp)
 1c2:	e8 8b 09 00 00       	call   b52 <malloc>
 1c7:	a3 04 10 00 00       	mov    %eax,0x1004
  busy_workers = malloc(sizeof(busy_workers) * n);
 1cc:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1d0:	c1 e0 02             	shl    $0x2,%eax
 1d3:	89 04 24             	mov    %eax,(%esp)
 1d6:	e8 77 09 00 00       	call   b52 <malloc>
 1db:	a3 0c 10 00 00       	mov    %eax,0x100c

  while(n --> 0){
 1e0:	eb 57                	jmp    239 <main+0xb2>
    pid = fork();
 1e2:	e8 d7 04 00 00       	call   6be <fork>
 1e7:	89 44 24 38          	mov    %eax,0x38(%esp)

    if(pid == 0) { // child code
 1eb:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
 1f0:	75 13                	jne    205 <main+0x7e>
      sigset(handler);
 1f2:	c7 04 24 3a 00 00 00 	movl   $0x3a,(%esp)
 1f9:	e8 68 05 00 00       	call   766 <sigset>
      while(1) {
        sigpause();
 1fe:	e8 7b 05 00 00       	call   77e <sigpause>
      }
 203:	eb f9                	jmp    1fe <main+0x77>
    }
    else {
      workers[n-1] = pid;
 205:	a1 04 10 00 00       	mov    0x1004,%eax
 20a:	8b 54 24 3c          	mov    0x3c(%esp),%edx
 20e:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 214:	c1 e2 02             	shl    $0x2,%edx
 217:	01 c2                	add    %eax,%edx
 219:	8b 44 24 38          	mov    0x38(%esp),%eax
 21d:	89 02                	mov    %eax,(%edx)
      busy_workers[n-1] = NOT_BUSY;
 21f:	a1 0c 10 00 00       	mov    0x100c,%eax
 224:	8b 54 24 3c          	mov    0x3c(%esp),%edx
 228:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 22e:	c1 e2 02             	shl    $0x2,%edx
 231:	01 d0                	add    %edx,%eax
 233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  NUM_WORKERS = n;
  workers = malloc(sizeof(workers) * n); // pid table of workers;
  busy_workers = malloc(sizeof(busy_workers) * n);

  while(n --> 0){
 239:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 23d:	8d 50 ff             	lea    -0x1(%eax),%edx
 240:	89 54 24 3c          	mov    %edx,0x3c(%esp)
 244:	85 c0                	test   %eax,%eax
 246:	7f 9a                	jg     1e2 <main+0x5b>
    else {
      workers[n-1] = pid;
      busy_workers[n-1] = NOT_BUSY;
    }
  }
  sigset(primsrv);
 248:	c7 04 24 9b 00 00 00 	movl   $0x9b,(%esp)
 24f:	e8 12 05 00 00       	call   766 <sigset>
  printf(1, "worker pids: \n");
 254:	c7 44 24 04 79 0c 00 	movl   $0xc79,0x4(%esp)
 25b:	00 
 25c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 263:	e8 fe 05 00 00       	call   866 <printf>
  n = NUM_WORKERS; 
 268:	a1 08 10 00 00       	mov    0x1008,%eax
 26d:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  while (n --> 0)
 271:	eb 2e                	jmp    2a1 <main+0x11a>
    printf(1, "%d \n", workers[n-1]);
 273:	a1 04 10 00 00       	mov    0x1004,%eax
 278:	8b 54 24 3c          	mov    0x3c(%esp),%edx
 27c:	81 c2 ff ff ff 3f    	add    $0x3fffffff,%edx
 282:	c1 e2 02             	shl    $0x2,%edx
 285:	01 d0                	add    %edx,%eax
 287:	8b 00                	mov    (%eax),%eax
 289:	89 44 24 08          	mov    %eax,0x8(%esp)
 28d:	c7 44 24 04 88 0c 00 	movl   $0xc88,0x4(%esp)
 294:	00 
 295:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 29c:	e8 c5 05 00 00       	call   866 <printf>
    }
  }
  sigset(primsrv);
  printf(1, "worker pids: \n");
  n = NUM_WORKERS; 
  while (n --> 0)
 2a1:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 54 24 3c          	mov    %edx,0x3c(%esp)
 2ac:	85 c0                	test   %eax,%eax
 2ae:	7f c3                	jg     273 <main+0xec>
    printf(1, "%d \n", workers[n-1]);

  while(1) {
    printf(1, "please enter a number: ");
 2b0:	c7 44 24 04 8d 0c 00 	movl   $0xc8d,0x4(%esp)
 2b7:	00 
 2b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2bf:	e8 a2 05 00 00       	call   866 <printf>
    gets(buffer, BUFFER_SIZE);
 2c4:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
 2cb:	00 
 2cc:	8d 44 24 18          	lea    0x18(%esp),%eax
 2d0:	89 04 24             	mov    %eax,(%esp)
 2d3:	e8 98 02 00 00       	call   570 <gets>
    null_terminate(buffer);
 2d8:	8d 44 24 18          	lea    0x18(%esp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 67 00 00 00       	call   34b <null_terminate>
    if(*buffer != 0) {
 2e4:	0f b6 44 24 18       	movzbl 0x18(%esp),%eax
 2e9:	84 c0                	test   %al,%al
 2eb:	74 36                	je     323 <main+0x19c>
      n = atoi(buffer);
 2ed:	8d 44 24 18          	lea    0x18(%esp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 3b 03 00 00       	call   634 <atoi>
 2f9:	89 44 24 3c          	mov    %eax,0x3c(%esp)
      *buffer = 0;
 2fd:	c6 44 24 18 00       	movb   $0x0,0x18(%esp)
      find_worker(workers, busy_workers, n);
 302:	8b 15 0c 10 00 00    	mov    0x100c,%edx
 308:	a1 04 10 00 00       	mov    0x1004,%eax
 30d:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
 311:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 315:	89 54 24 04          	mov    %edx,0x4(%esp)
 319:	89 04 24             	mov    %eax,(%esp)
 31c:	e8 57 00 00 00       	call   378 <find_worker>
    }
  }
 321:	eb 8d                	jmp    2b0 <main+0x129>
 323:	eb 8b                	jmp    2b0 <main+0x129>

00000325 <isdigit>:

}

int isdigit(char d){
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	83 ec 04             	sub    $0x4,%esp
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	88 45 fc             	mov    %al,-0x4(%ebp)
  return !(d < '0' || d > '9');
 331:	80 7d fc 2f          	cmpb   $0x2f,-0x4(%ebp)
 335:	7e 0d                	jle    344 <isdigit+0x1f>
 337:	80 7d fc 39          	cmpb   $0x39,-0x4(%ebp)
 33b:	7f 07                	jg     344 <isdigit+0x1f>
 33d:	b8 01 00 00 00       	mov    $0x1,%eax
 342:	eb 05                	jmp    349 <isdigit+0x24>
 344:	b8 00 00 00 00       	mov    $0x0,%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <null_terminate>:
// assumes buff ends with \n
void null_terminate(char * buff) {
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	83 ec 04             	sub    $0x4,%esp
  while(isdigit(*buff++));
 351:	90                   	nop
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	8d 50 01             	lea    0x1(%eax),%edx
 358:	89 55 08             	mov    %edx,0x8(%ebp)
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	0f be c0             	movsbl %al,%eax
 361:	89 04 24             	mov    %eax,(%esp)
 364:	e8 bc ff ff ff       	call   325 <isdigit>
 369:	85 c0                	test   %eax,%eax
 36b:	75 e5                	jne    352 <null_terminate+0x7>
  *(buff-1) = 0;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	83 e8 01             	sub    $0x1,%eax
 373:	c6 00 00             	movb   $0x0,(%eax)
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <find_worker>:

void find_worker(int* workers, int* busy_workers, int value) {
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	83 ec 28             	sub    $0x28,%esp
 int n = NUM_WORKERS - 1;
 37e:	a1 08 10 00 00       	mov    0x1008,%eax
 383:	83 e8 01             	sub    $0x1,%eax
 386:	89 45 f4             	mov    %eax,-0xc(%ebp)
 if(0 == value){
 389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 38d:	75 2b                	jne    3ba <find_worker+0x42>
   printf(1,"sending 0, \n");
 38f:	c7 44 24 04 a5 0c 00 	movl   $0xca5,0x4(%esp)
 396:	00 
 397:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 39e:	e8 c3 04 00 00       	call   866 <printf>
   sigsend(getpid(), 0);
 3a3:	e8 9e 03 00 00       	call   746 <getpid>
 3a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3af:	00 
 3b0:	89 04 24             	mov    %eax,(%esp)
 3b3:	e8 b6 03 00 00       	call   76e <sigsend>
 } 
 while(n --> -1)
 3b8:	eb 7d                	jmp    437 <find_worker+0xbf>
 3ba:	eb 7b                	jmp    437 <find_worker+0xbf>
   if(busy_workers[n] == NOT_BUSY) {
 3bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	01 d0                	add    %edx,%eax
 3cb:	8b 00                	mov    (%eax),%eax
 3cd:	85 c0                	test   %eax,%eax
 3cf:	75 66                	jne    437 <find_worker+0xbf>
     busy_workers[n] = value;
 3d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	01 c2                	add    %eax,%edx
 3e0:	8b 45 10             	mov    0x10(%ebp),%eax
 3e3:	89 02                	mov    %eax,(%edx)
     printf(1, "SENDING %d to %d \n", value, workers[n]);
 3e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	01 d0                	add    %edx,%eax
 3f4:	8b 00                	mov    (%eax),%eax
 3f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	89 44 24 08          	mov    %eax,0x8(%esp)
 401:	c7 44 24 04 b2 0c 00 	movl   $0xcb2,0x4(%esp)
 408:	00 
 409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 410:	e8 51 04 00 00       	call   866 <printf>
     sigsend(workers[n], value);
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	01 d0                	add    %edx,%eax
 424:	8b 00                	mov    (%eax),%eax
 426:	8b 55 10             	mov    0x10(%ebp),%edx
 429:	89 54 24 04          	mov    %edx,0x4(%esp)
 42d:	89 04 24             	mov    %eax,(%esp)
 430:	e8 39 03 00 00       	call   76e <sigsend>
     return;
 435:	eb 25                	jmp    45c <find_worker+0xe4>
 int n = NUM_WORKERS - 1;
 if(0 == value){
   printf(1,"sending 0, \n");
   sigsend(getpid(), 0);
 } 
 while(n --> -1)
 437:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43a:	8d 50 ff             	lea    -0x1(%eax),%edx
 43d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 440:	85 c0                	test   %eax,%eax
 442:	0f 89 74 ff ff ff    	jns    3bc <find_worker+0x44>
     busy_workers[n] = value;
     printf(1, "SENDING %d to %d \n", value, workers[n]);
     sigsend(workers[n], value);
     return;
   }
 printf(1, "no idle workers.\n"); 
 448:	c7 44 24 04 c5 0c 00 	movl   $0xcc5,0x4(%esp)
 44f:	00 
 450:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 457:	e8 0a 04 00 00       	call   866 <printf>
}
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	57                   	push   %edi
 462:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 463:	8b 4d 08             	mov    0x8(%ebp),%ecx
 466:	8b 55 10             	mov    0x10(%ebp),%edx
 469:	8b 45 0c             	mov    0xc(%ebp),%eax
 46c:	89 cb                	mov    %ecx,%ebx
 46e:	89 df                	mov    %ebx,%edi
 470:	89 d1                	mov    %edx,%ecx
 472:	fc                   	cld    
 473:	f3 aa                	rep stos %al,%es:(%edi)
 475:	89 ca                	mov    %ecx,%edx
 477:	89 fb                	mov    %edi,%ebx
 479:	89 5d 08             	mov    %ebx,0x8(%ebp)
 47c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 47f:	5b                   	pop    %ebx
 480:	5f                   	pop    %edi
 481:	5d                   	pop    %ebp
 482:	c3                   	ret    

00000483 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 483:	55                   	push   %ebp
 484:	89 e5                	mov    %esp,%ebp
 486:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 48f:	90                   	nop
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	8d 50 01             	lea    0x1(%eax),%edx
 496:	89 55 08             	mov    %edx,0x8(%ebp)
 499:	8b 55 0c             	mov    0xc(%ebp),%edx
 49c:	8d 4a 01             	lea    0x1(%edx),%ecx
 49f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4a2:	0f b6 12             	movzbl (%edx),%edx
 4a5:	88 10                	mov    %dl,(%eax)
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	84 c0                	test   %al,%al
 4ac:	75 e2                	jne    490 <strcpy+0xd>
    ;
  return os;
 4ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4b6:	eb 08                	jmp    4c0 <strcmp+0xd>
    p++, q++;
 4b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	0f b6 00             	movzbl (%eax),%eax
 4c6:	84 c0                	test   %al,%al
 4c8:	74 10                	je     4da <strcmp+0x27>
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	0f b6 10             	movzbl (%eax),%edx
 4d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d3:	0f b6 00             	movzbl (%eax),%eax
 4d6:	38 c2                	cmp    %al,%dl
 4d8:	74 de                	je     4b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	0f b6 00             	movzbl (%eax),%eax
 4e0:	0f b6 d0             	movzbl %al,%edx
 4e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e6:	0f b6 00             	movzbl (%eax),%eax
 4e9:	0f b6 c0             	movzbl %al,%eax
 4ec:	29 c2                	sub    %eax,%edx
 4ee:	89 d0                	mov    %edx,%eax
}
 4f0:	5d                   	pop    %ebp
 4f1:	c3                   	ret    

000004f2 <strlen>:

uint
strlen(char *s)
{
 4f2:	55                   	push   %ebp
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4ff:	eb 04                	jmp    505 <strlen+0x13>
 501:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 505:	8b 55 fc             	mov    -0x4(%ebp),%edx
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	01 d0                	add    %edx,%eax
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	84 c0                	test   %al,%al
 512:	75 ed                	jne    501 <strlen+0xf>
    ;
  return n;
 514:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 517:	c9                   	leave  
 518:	c3                   	ret    

00000519 <memset>:

void*
memset(void *dst, int c, uint n)
{
 519:	55                   	push   %ebp
 51a:	89 e5                	mov    %esp,%ebp
 51c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 51f:	8b 45 10             	mov    0x10(%ebp),%eax
 522:	89 44 24 08          	mov    %eax,0x8(%esp)
 526:	8b 45 0c             	mov    0xc(%ebp),%eax
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 26 ff ff ff       	call   45e <stosb>
  return dst;
 538:	8b 45 08             	mov    0x8(%ebp),%eax
}
 53b:	c9                   	leave  
 53c:	c3                   	ret    

0000053d <strchr>:

char*
strchr(const char *s, char c)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 04             	sub    $0x4,%esp
 543:	8b 45 0c             	mov    0xc(%ebp),%eax
 546:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 549:	eb 14                	jmp    55f <strchr+0x22>
    if(*s == c)
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	3a 45 fc             	cmp    -0x4(%ebp),%al
 554:	75 05                	jne    55b <strchr+0x1e>
      return (char*)s;
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	eb 13                	jmp    56e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 55b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	84 c0                	test   %al,%al
 567:	75 e2                	jne    54b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 569:	b8 00 00 00 00       	mov    $0x0,%eax
}
 56e:	c9                   	leave  
 56f:	c3                   	ret    

00000570 <gets>:

char*
gets(char *buf, int max)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 57d:	eb 4c                	jmp    5cb <gets+0x5b>
    cc = read(0, &c, 1);
 57f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 586:	00 
 587:	8d 45 ef             	lea    -0x11(%ebp),%eax
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 595:	e8 44 01 00 00       	call   6de <read>
 59a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 59d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a1:	7f 02                	jg     5a5 <gets+0x35>
      break;
 5a3:	eb 31                	jmp    5d6 <gets+0x66>
    buf[i++] = c;
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	8d 50 01             	lea    0x1(%eax),%edx
 5ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ae:	89 c2                	mov    %eax,%edx
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	01 c2                	add    %eax,%edx
 5b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5b9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 5bb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5bf:	3c 0a                	cmp    $0xa,%al
 5c1:	74 13                	je     5d6 <gets+0x66>
 5c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c7:	3c 0d                	cmp    $0xd,%al
 5c9:	74 0b                	je     5d6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ce:	83 c0 01             	add    $0x1,%eax
 5d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5d4:	7c a9                	jl     57f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	01 d0                	add    %edx,%eax
 5de:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5e4:	c9                   	leave  
 5e5:	c3                   	ret    

000005e6 <stat>:

int
stat(char *n, struct stat *st)
{
 5e6:	55                   	push   %ebp
 5e7:	89 e5                	mov    %esp,%ebp
 5e9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5f3:	00 
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	89 04 24             	mov    %eax,(%esp)
 5fa:	e8 07 01 00 00       	call   706 <open>
 5ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 606:	79 07                	jns    60f <stat+0x29>
    return -1;
 608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 60d:	eb 23                	jmp    632 <stat+0x4c>
  r = fstat(fd, st);
 60f:	8b 45 0c             	mov    0xc(%ebp),%eax
 612:	89 44 24 04          	mov    %eax,0x4(%esp)
 616:	8b 45 f4             	mov    -0xc(%ebp),%eax
 619:	89 04 24             	mov    %eax,(%esp)
 61c:	e8 fd 00 00 00       	call   71e <fstat>
 621:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	89 04 24             	mov    %eax,(%esp)
 62a:	e8 bf 00 00 00       	call   6ee <close>
  return r;
 62f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 632:	c9                   	leave  
 633:	c3                   	ret    

00000634 <atoi>:

int
atoi(const char *s)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 63a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 641:	eb 25                	jmp    668 <atoi+0x34>
    n = n*10 + *s++ - '0';
 643:	8b 55 fc             	mov    -0x4(%ebp),%edx
 646:	89 d0                	mov    %edx,%eax
 648:	c1 e0 02             	shl    $0x2,%eax
 64b:	01 d0                	add    %edx,%eax
 64d:	01 c0                	add    %eax,%eax
 64f:	89 c1                	mov    %eax,%ecx
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	8d 50 01             	lea    0x1(%eax),%edx
 657:	89 55 08             	mov    %edx,0x8(%ebp)
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	0f be c0             	movsbl %al,%eax
 660:	01 c8                	add    %ecx,%eax
 662:	83 e8 30             	sub    $0x30,%eax
 665:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	0f b6 00             	movzbl (%eax),%eax
 66e:	3c 2f                	cmp    $0x2f,%al
 670:	7e 0a                	jle    67c <atoi+0x48>
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	0f b6 00             	movzbl (%eax),%eax
 678:	3c 39                	cmp    $0x39,%al
 67a:	7e c7                	jle    643 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 67f:	c9                   	leave  
 680:	c3                   	ret    

00000681 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 681:	55                   	push   %ebp
 682:	89 e5                	mov    %esp,%ebp
 684:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 687:	8b 45 08             	mov    0x8(%ebp),%eax
 68a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 68d:	8b 45 0c             	mov    0xc(%ebp),%eax
 690:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 693:	eb 17                	jmp    6ac <memmove+0x2b>
    *dst++ = *src++;
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8d 50 01             	lea    0x1(%eax),%edx
 69b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 69e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a1:	8d 4a 01             	lea    0x1(%edx),%ecx
 6a4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6a7:	0f b6 12             	movzbl (%edx),%edx
 6aa:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6ac:	8b 45 10             	mov    0x10(%ebp),%eax
 6af:	8d 50 ff             	lea    -0x1(%eax),%edx
 6b2:	89 55 10             	mov    %edx,0x10(%ebp)
 6b5:	85 c0                	test   %eax,%eax
 6b7:	7f dc                	jg     695 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6be:	b8 01 00 00 00       	mov    $0x1,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <exit>:
SYSCALL(exit)
 6c6:	b8 02 00 00 00       	mov    $0x2,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <wait>:
SYSCALL(wait)
 6ce:	b8 03 00 00 00       	mov    $0x3,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <pipe>:
SYSCALL(pipe)
 6d6:	b8 04 00 00 00       	mov    $0x4,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <read>:
SYSCALL(read)
 6de:	b8 05 00 00 00       	mov    $0x5,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <write>:
SYSCALL(write)
 6e6:	b8 10 00 00 00       	mov    $0x10,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <close>:
SYSCALL(close)
 6ee:	b8 15 00 00 00       	mov    $0x15,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <kill>:
SYSCALL(kill)
 6f6:	b8 06 00 00 00       	mov    $0x6,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <exec>:
SYSCALL(exec)
 6fe:	b8 07 00 00 00       	mov    $0x7,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <open>:
SYSCALL(open)
 706:	b8 0f 00 00 00       	mov    $0xf,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <mknod>:
SYSCALL(mknod)
 70e:	b8 11 00 00 00       	mov    $0x11,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <unlink>:
SYSCALL(unlink)
 716:	b8 12 00 00 00       	mov    $0x12,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <fstat>:
SYSCALL(fstat)
 71e:	b8 08 00 00 00       	mov    $0x8,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <link>:
SYSCALL(link)
 726:	b8 13 00 00 00       	mov    $0x13,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <mkdir>:
SYSCALL(mkdir)
 72e:	b8 14 00 00 00       	mov    $0x14,%eax
 733:	cd 40                	int    $0x40
 735:	c3                   	ret    

00000736 <chdir>:
SYSCALL(chdir)
 736:	b8 09 00 00 00       	mov    $0x9,%eax
 73b:	cd 40                	int    $0x40
 73d:	c3                   	ret    

0000073e <dup>:
SYSCALL(dup)
 73e:	b8 0a 00 00 00       	mov    $0xa,%eax
 743:	cd 40                	int    $0x40
 745:	c3                   	ret    

00000746 <getpid>:
SYSCALL(getpid)
 746:	b8 0b 00 00 00       	mov    $0xb,%eax
 74b:	cd 40                	int    $0x40
 74d:	c3                   	ret    

0000074e <sbrk>:
SYSCALL(sbrk)
 74e:	b8 0c 00 00 00       	mov    $0xc,%eax
 753:	cd 40                	int    $0x40
 755:	c3                   	ret    

00000756 <sleep>:
SYSCALL(sleep)
 756:	b8 0d 00 00 00       	mov    $0xd,%eax
 75b:	cd 40                	int    $0x40
 75d:	c3                   	ret    

0000075e <uptime>:
SYSCALL(uptime)
 75e:	b8 0e 00 00 00       	mov    $0xe,%eax
 763:	cd 40                	int    $0x40
 765:	c3                   	ret    

00000766 <sigset>:
SYSCALL(sigset)
 766:	b8 16 00 00 00       	mov    $0x16,%eax
 76b:	cd 40                	int    $0x40
 76d:	c3                   	ret    

0000076e <sigsend>:
SYSCALL(sigsend)
 76e:	b8 17 00 00 00       	mov    $0x17,%eax
 773:	cd 40                	int    $0x40
 775:	c3                   	ret    

00000776 <sigret>:
SYSCALL(sigret)
 776:	b8 18 00 00 00       	mov    $0x18,%eax
 77b:	cd 40                	int    $0x40
 77d:	c3                   	ret    

0000077e <sigpause>:
SYSCALL(sigpause)
 77e:	b8 19 00 00 00       	mov    $0x19,%eax
 783:	cd 40                	int    $0x40
 785:	c3                   	ret    

00000786 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 786:	55                   	push   %ebp
 787:	89 e5                	mov    %esp,%ebp
 789:	83 ec 18             	sub    $0x18,%esp
 78c:	8b 45 0c             	mov    0xc(%ebp),%eax
 78f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 792:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 799:	00 
 79a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 79d:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	89 04 24             	mov    %eax,(%esp)
 7a7:	e8 3a ff ff ff       	call   6e6 <write>
}
 7ac:	c9                   	leave  
 7ad:	c3                   	ret    

000007ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7ae:	55                   	push   %ebp
 7af:	89 e5                	mov    %esp,%ebp
 7b1:	56                   	push   %esi
 7b2:	53                   	push   %ebx
 7b3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7c1:	74 17                	je     7da <printint+0x2c>
 7c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7c7:	79 11                	jns    7da <printint+0x2c>
    neg = 1;
 7c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d3:	f7 d8                	neg    %eax
 7d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7d8:	eb 06                	jmp    7e0 <printint+0x32>
  } else {
    x = xx;
 7da:	8b 45 0c             	mov    0xc(%ebp),%eax
 7dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7ea:	8d 41 01             	lea    0x1(%ecx),%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f6:	ba 00 00 00 00       	mov    $0x0,%edx
 7fb:	f7 f3                	div    %ebx
 7fd:	89 d0                	mov    %edx,%eax
 7ff:	0f b6 80 e4 0f 00 00 	movzbl 0xfe4(%eax),%eax
 806:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 80a:	8b 75 10             	mov    0x10(%ebp),%esi
 80d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 810:	ba 00 00 00 00       	mov    $0x0,%edx
 815:	f7 f6                	div    %esi
 817:	89 45 ec             	mov    %eax,-0x14(%ebp)
 81a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 81e:	75 c7                	jne    7e7 <printint+0x39>
  if(neg)
 820:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 824:	74 10                	je     836 <printint+0x88>
    buf[i++] = '-';
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8d 50 01             	lea    0x1(%eax),%edx
 82c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 82f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 834:	eb 1f                	jmp    855 <printint+0xa7>
 836:	eb 1d                	jmp    855 <printint+0xa7>
    putc(fd, buf[i]);
 838:	8d 55 dc             	lea    -0x24(%ebp),%edx
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	01 d0                	add    %edx,%eax
 840:	0f b6 00             	movzbl (%eax),%eax
 843:	0f be c0             	movsbl %al,%eax
 846:	89 44 24 04          	mov    %eax,0x4(%esp)
 84a:	8b 45 08             	mov    0x8(%ebp),%eax
 84d:	89 04 24             	mov    %eax,(%esp)
 850:	e8 31 ff ff ff       	call   786 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 855:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85d:	79 d9                	jns    838 <printint+0x8a>
    putc(fd, buf[i]);
}
 85f:	83 c4 30             	add    $0x30,%esp
 862:	5b                   	pop    %ebx
 863:	5e                   	pop    %esi
 864:	5d                   	pop    %ebp
 865:	c3                   	ret    

00000866 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 866:	55                   	push   %ebp
 867:	89 e5                	mov    %esp,%ebp
 869:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 86c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 873:	8d 45 0c             	lea    0xc(%ebp),%eax
 876:	83 c0 04             	add    $0x4,%eax
 879:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 87c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 883:	e9 7c 01 00 00       	jmp    a04 <printf+0x19e>
    c = fmt[i] & 0xff;
 888:	8b 55 0c             	mov    0xc(%ebp),%edx
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	01 d0                	add    %edx,%eax
 890:	0f b6 00             	movzbl (%eax),%eax
 893:	0f be c0             	movsbl %al,%eax
 896:	25 ff 00 00 00       	and    $0xff,%eax
 89b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 89e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8a2:	75 2c                	jne    8d0 <printf+0x6a>
      if(c == '%'){
 8a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8a8:	75 0c                	jne    8b6 <printf+0x50>
        state = '%';
 8aa:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8b1:	e9 4a 01 00 00       	jmp    a00 <printf+0x19a>
      } else {
        putc(fd, c);
 8b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b9:	0f be c0             	movsbl %al,%eax
 8bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c0:	8b 45 08             	mov    0x8(%ebp),%eax
 8c3:	89 04 24             	mov    %eax,(%esp)
 8c6:	e8 bb fe ff ff       	call   786 <putc>
 8cb:	e9 30 01 00 00       	jmp    a00 <printf+0x19a>
      }
    } else if(state == '%'){
 8d0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8d4:	0f 85 26 01 00 00    	jne    a00 <printf+0x19a>
      if(c == 'd'){
 8da:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8de:	75 2d                	jne    90d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8ec:	00 
 8ed:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8f4:	00 
 8f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 aa fe ff ff       	call   7ae <printint>
        ap++;
 904:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 908:	e9 ec 00 00 00       	jmp    9f9 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 90d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 911:	74 06                	je     919 <printf+0xb3>
 913:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 917:	75 2d                	jne    946 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 919:	8b 45 e8             	mov    -0x18(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 925:	00 
 926:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 92d:	00 
 92e:	89 44 24 04          	mov    %eax,0x4(%esp)
 932:	8b 45 08             	mov    0x8(%ebp),%eax
 935:	89 04 24             	mov    %eax,(%esp)
 938:	e8 71 fe ff ff       	call   7ae <printint>
        ap++;
 93d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 941:	e9 b3 00 00 00       	jmp    9f9 <printf+0x193>
      } else if(c == 's'){
 946:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 94a:	75 45                	jne    991 <printf+0x12b>
        s = (char*)*ap;
 94c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 954:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95c:	75 09                	jne    967 <printf+0x101>
          s = "(null)";
 95e:	c7 45 f4 d7 0c 00 00 	movl   $0xcd7,-0xc(%ebp)
        while(*s != 0){
 965:	eb 1e                	jmp    985 <printf+0x11f>
 967:	eb 1c                	jmp    985 <printf+0x11f>
          putc(fd, *s);
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	0f b6 00             	movzbl (%eax),%eax
 96f:	0f be c0             	movsbl %al,%eax
 972:	89 44 24 04          	mov    %eax,0x4(%esp)
 976:	8b 45 08             	mov    0x8(%ebp),%eax
 979:	89 04 24             	mov    %eax,(%esp)
 97c:	e8 05 fe ff ff       	call   786 <putc>
          s++;
 981:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 985:	8b 45 f4             	mov    -0xc(%ebp),%eax
 988:	0f b6 00             	movzbl (%eax),%eax
 98b:	84 c0                	test   %al,%al
 98d:	75 da                	jne    969 <printf+0x103>
 98f:	eb 68                	jmp    9f9 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 991:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 995:	75 1d                	jne    9b4 <printf+0x14e>
        putc(fd, *ap);
 997:	8b 45 e8             	mov    -0x18(%ebp),%eax
 99a:	8b 00                	mov    (%eax),%eax
 99c:	0f be c0             	movsbl %al,%eax
 99f:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	89 04 24             	mov    %eax,(%esp)
 9a9:	e8 d8 fd ff ff       	call   786 <putc>
        ap++;
 9ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9b2:	eb 45                	jmp    9f9 <printf+0x193>
      } else if(c == '%'){
 9b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9b8:	75 17                	jne    9d1 <printf+0x16b>
        putc(fd, c);
 9ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9bd:	0f be c0             	movsbl %al,%eax
 9c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c4:	8b 45 08             	mov    0x8(%ebp),%eax
 9c7:	89 04 24             	mov    %eax,(%esp)
 9ca:	e8 b7 fd ff ff       	call   786 <putc>
 9cf:	eb 28                	jmp    9f9 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9d1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9d8:	00 
 9d9:	8b 45 08             	mov    0x8(%ebp),%eax
 9dc:	89 04 24             	mov    %eax,(%esp)
 9df:	e8 a2 fd ff ff       	call   786 <putc>
        putc(fd, c);
 9e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9e7:	0f be c0             	movsbl %al,%eax
 9ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ee:	8b 45 08             	mov    0x8(%ebp),%eax
 9f1:	89 04 24             	mov    %eax,(%esp)
 9f4:	e8 8d fd ff ff       	call   786 <putc>
      }
      state = 0;
 9f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a00:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a04:	8b 55 0c             	mov    0xc(%ebp),%edx
 a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0a:	01 d0                	add    %edx,%eax
 a0c:	0f b6 00             	movzbl (%eax),%eax
 a0f:	84 c0                	test   %al,%al
 a11:	0f 85 71 fe ff ff    	jne    888 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a17:	c9                   	leave  
 a18:	c3                   	ret    

00000a19 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a19:	55                   	push   %ebp
 a1a:	89 e5                	mov    %esp,%ebp
 a1c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a1f:	8b 45 08             	mov    0x8(%ebp),%eax
 a22:	83 e8 08             	sub    $0x8,%eax
 a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a28:	a1 00 10 00 00       	mov    0x1000,%eax
 a2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a30:	eb 24                	jmp    a56 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a35:	8b 00                	mov    (%eax),%eax
 a37:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a3a:	77 12                	ja     a4e <free+0x35>
 a3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a42:	77 24                	ja     a68 <free+0x4f>
 a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a47:	8b 00                	mov    (%eax),%eax
 a49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a4c:	77 1a                	ja     a68 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a51:	8b 00                	mov    (%eax),%eax
 a53:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a5c:	76 d4                	jbe    a32 <free+0x19>
 a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a61:	8b 00                	mov    (%eax),%eax
 a63:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a66:	76 ca                	jbe    a32 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a68:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6b:	8b 40 04             	mov    0x4(%eax),%eax
 a6e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a78:	01 c2                	add    %eax,%edx
 a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7d:	8b 00                	mov    (%eax),%eax
 a7f:	39 c2                	cmp    %eax,%edx
 a81:	75 24                	jne    aa7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a86:	8b 50 04             	mov    0x4(%eax),%edx
 a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8c:	8b 00                	mov    (%eax),%eax
 a8e:	8b 40 04             	mov    0x4(%eax),%eax
 a91:	01 c2                	add    %eax,%edx
 a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a96:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9c:	8b 00                	mov    (%eax),%eax
 a9e:	8b 10                	mov    (%eax),%edx
 aa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa3:	89 10                	mov    %edx,(%eax)
 aa5:	eb 0a                	jmp    ab1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aaa:	8b 10                	mov    (%eax),%edx
 aac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab4:	8b 40 04             	mov    0x4(%eax),%eax
 ab7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 abe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac1:	01 d0                	add    %edx,%eax
 ac3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ac6:	75 20                	jne    ae8 <free+0xcf>
    p->s.size += bp->s.size;
 ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acb:	8b 50 04             	mov    0x4(%eax),%edx
 ace:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad1:	8b 40 04             	mov    0x4(%eax),%eax
 ad4:	01 c2                	add    %eax,%edx
 ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 adc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 adf:	8b 10                	mov    (%eax),%edx
 ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae4:	89 10                	mov    %edx,(%eax)
 ae6:	eb 08                	jmp    af0 <free+0xd7>
  } else
    p->s.ptr = bp;
 ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aeb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 aee:	89 10                	mov    %edx,(%eax)
  freep = p;
 af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af3:	a3 00 10 00 00       	mov    %eax,0x1000
}
 af8:	c9                   	leave  
 af9:	c3                   	ret    

00000afa <morecore>:

static Header*
morecore(uint nu)
{
 afa:	55                   	push   %ebp
 afb:	89 e5                	mov    %esp,%ebp
 afd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b00:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b07:	77 07                	ja     b10 <morecore+0x16>
    nu = 4096;
 b09:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b10:	8b 45 08             	mov    0x8(%ebp),%eax
 b13:	c1 e0 03             	shl    $0x3,%eax
 b16:	89 04 24             	mov    %eax,(%esp)
 b19:	e8 30 fc ff ff       	call   74e <sbrk>
 b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b21:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b25:	75 07                	jne    b2e <morecore+0x34>
    return 0;
 b27:	b8 00 00 00 00       	mov    $0x0,%eax
 b2c:	eb 22                	jmp    b50 <morecore+0x56>
  hp = (Header*)p;
 b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b37:	8b 55 08             	mov    0x8(%ebp),%edx
 b3a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b40:	83 c0 08             	add    $0x8,%eax
 b43:	89 04 24             	mov    %eax,(%esp)
 b46:	e8 ce fe ff ff       	call   a19 <free>
  return freep;
 b4b:	a1 00 10 00 00       	mov    0x1000,%eax
}
 b50:	c9                   	leave  
 b51:	c3                   	ret    

00000b52 <malloc>:

void*
malloc(uint nbytes)
{
 b52:	55                   	push   %ebp
 b53:	89 e5                	mov    %esp,%ebp
 b55:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b58:	8b 45 08             	mov    0x8(%ebp),%eax
 b5b:	83 c0 07             	add    $0x7,%eax
 b5e:	c1 e8 03             	shr    $0x3,%eax
 b61:	83 c0 01             	add    $0x1,%eax
 b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b67:	a1 00 10 00 00       	mov    0x1000,%eax
 b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b73:	75 23                	jne    b98 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b75:	c7 45 f0 f8 0f 00 00 	movl   $0xff8,-0x10(%ebp)
 b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7f:	a3 00 10 00 00       	mov    %eax,0x1000
 b84:	a1 00 10 00 00       	mov    0x1000,%eax
 b89:	a3 f8 0f 00 00       	mov    %eax,0xff8
    base.s.size = 0;
 b8e:	c7 05 fc 0f 00 00 00 	movl   $0x0,0xffc
 b95:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9b:	8b 00                	mov    (%eax),%eax
 b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba3:	8b 40 04             	mov    0x4(%eax),%eax
 ba6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ba9:	72 4d                	jb     bf8 <malloc+0xa6>
      if(p->s.size == nunits)
 bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bae:	8b 40 04             	mov    0x4(%eax),%eax
 bb1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bb4:	75 0c                	jne    bc2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb9:	8b 10                	mov    (%eax),%edx
 bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bbe:	89 10                	mov    %edx,(%eax)
 bc0:	eb 26                	jmp    be8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc5:	8b 40 04             	mov    0x4(%eax),%eax
 bc8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bcb:	89 c2                	mov    %eax,%edx
 bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd6:	8b 40 04             	mov    0x4(%eax),%eax
 bd9:	c1 e0 03             	shl    $0x3,%eax
 bdc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 be5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 beb:	a3 00 10 00 00       	mov    %eax,0x1000
      return (void*)(p + 1);
 bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf3:	83 c0 08             	add    $0x8,%eax
 bf6:	eb 38                	jmp    c30 <malloc+0xde>
    }
    if(p == freep)
 bf8:	a1 00 10 00 00       	mov    0x1000,%eax
 bfd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c00:	75 1b                	jne    c1d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c05:	89 04 24             	mov    %eax,(%esp)
 c08:	e8 ed fe ff ff       	call   afa <morecore>
 c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c14:	75 07                	jne    c1d <malloc+0xcb>
        return 0;
 c16:	b8 00 00 00 00       	mov    $0x0,%eax
 c1b:	eb 13                	jmp    c30 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c26:	8b 00                	mov    (%eax),%eax
 c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c2b:	e9 70 ff ff ff       	jmp    ba0 <malloc+0x4e>
}
 c30:	c9                   	leave  
 c31:	c3                   	ret    
