
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <handler>:
#include "types.h"
#include "stat.h" 
#include "user.h"
#define db printf(1,"LINE %d \n", __LINE__);
void concreate(void);
void handler(int pid, int value) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(1, "I got a signal pid[%d], value[%d] \n", pid, value);
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 44 24 0c          	mov    %eax,0xc(%esp)
   d:	8b 45 08             	mov    0x8(%ebp),%eax
  10:	89 44 24 08          	mov    %eax,0x8(%esp)
  14:	c7 44 24 04 04 0c 00 	movl   $0xc04,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 10 08 00 00       	call   838 <printf>
}
  28:	c9                   	leave  
  29:	c3                   	ret    

0000002a <main>:
int main(int argc, char** argv) {
  2a:	55                   	push   %ebp
  2b:	89 e5                	mov    %esp,%ebp
  2d:	83 e4 f0             	and    $0xfffffff0,%esp
  30:	83 ec 20             	sub    $0x20,%esp
  int i = 40;
  33:	c7 44 24 1c 28 00 00 	movl   $0x28,0x1c(%esp)
  3a:	00 
  sigset(handler);
  3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  42:	e8 f1 06 00 00       	call   738 <sigset>
  int pid;

  if(argc == 1) {
  47:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  4b:	75 07                	jne    54 <main+0x2a>
     concreate();
  4d:	e8 f9 00 00 00       	call   14b <concreate>
  }
    

  while(i --> 0) {
  52:	eb 38                	jmp    8c <main+0x62>
  54:	eb 36                	jmp    8c <main+0x62>
    pid = fork();
  56:	e8 35 06 00 00       	call   690 <fork>
  5b:	89 44 24 18          	mov    %eax,0x18(%esp)

    if(pid == 0)
  5f:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  64:	75 05                	jne    6b <main+0x41>
      exit();
  66:	e8 2d 06 00 00       	call   698 <exit>
 
    wait();
  6b:	e8 30 06 00 00       	call   6a0 <wait>
    printf(1, "%d \n", pid);
  70:	8b 44 24 18          	mov    0x18(%esp),%eax
  74:	89 44 24 08          	mov    %eax,0x8(%esp)
  78:	c7 44 24 04 28 0c 00 	movl   $0xc28,0x4(%esp)
  7f:	00 
  80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  87:	e8 ac 07 00 00       	call   838 <printf>
  if(argc == 1) {
     concreate();
  }
    

  while(i --> 0) {
  8c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  90:	8d 50 ff             	lea    -0x1(%eax),%edx
  93:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  97:	85 c0                	test   %eax,%eax
  99:	7f bb                	jg     56 <main+0x2c>
 
    wait();
    printf(1, "%d \n", pid);
  }

  printf(1, "finished part 1 \n");
  9b:	c7 44 24 04 2d 0c 00 	movl   $0xc2d,0x4(%esp)
  a2:	00 
  a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  aa:	e8 89 07 00 00       	call   838 <printf>

  i = 60;
  af:	c7 44 24 1c 3c 00 00 	movl   $0x3c,0x1c(%esp)
  b6:	00 

  while(i --> 0){
  b7:	eb 30                	jmp    e9 <main+0xbf>
    pid = fork();
  b9:	e8 d2 05 00 00       	call   690 <fork>
  be:	89 44 24 18          	mov    %eax,0x18(%esp)
    if(pid  == 0)
  c2:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  c7:	75 05                	jne    ce <main+0xa4>
      exit();
  c9:	e8 ca 05 00 00       	call   698 <exit>
    else if (pid < 0)
  ce:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  d3:	79 14                	jns    e9 <main+0xbf>
      printf(1, "fork failed \n");
  d5:	c7 44 24 04 3f 0c 00 	movl   $0xc3f,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 4f 07 00 00       	call   838 <printf>

  printf(1, "finished part 1 \n");

  i = 60;

  while(i --> 0){
  e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  f0:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  f4:	85 c0                	test   %eax,%eax
  f6:	7f c1                	jg     b9 <main+0x8f>
      exit();
    else if (pid < 0)
      printf(1, "fork failed \n");

  }
  while((pid = wait()) > 0) {
  f8:	eb 28                	jmp    122 <main+0xf8>
    printf(1,"Killed %d \n", pid);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 44 24 08          	mov    %eax,0x8(%esp)
 102:	c7 44 24 04 4d 0c 00 	movl   $0xc4d,0x4(%esp)
 109:	00 
 10a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 111:	e8 22 07 00 00       	call   838 <printf>
    sleep(10);
 116:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 11d:	e8 06 06 00 00       	call   728 <sleep>
      exit();
    else if (pid < 0)
      printf(1, "fork failed \n");

  }
  while((pid = wait()) > 0) {
 122:	e8 79 05 00 00       	call   6a0 <wait>
 127:	89 44 24 18          	mov    %eax,0x18(%esp)
 12b:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 130:	7f c8                	jg     fa <main+0xd0>
    printf(1,"Killed %d \n", pid);
    sleep(10);
  }
  exit();
 132:	e8 61 05 00 00       	call   698 <exit>

00000137 <foo>:
}


void foo(void) {
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 18             	sub    $0x18,%esp
  sleep(2);
 13d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 144:	e8 df 05 00 00       	call   728 <sleep>
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <concreate>:
// test concurrent create/link/unlink of the same file
void
concreate(void)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 68             	sub    $0x68,%esp
  int i,j, pid, n, fd;
  char * file = "lambdax";
 151:	c7 45 e8 59 0c 00 00 	movl   $0xc59,-0x18(%ebp)
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
 158:	c7 44 24 04 61 0c 00 	movl   $0xc61,0x4(%esp)
 15f:	00 
 160:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 167:	e8 cc 06 00 00       	call   838 <printf>
  for(i = 0; i < 40; i++){
 16c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 173:	e9 d0 00 00 00       	jmp    248 <concreate+0xfd>
    foo();
 178:	e8 ba ff ff ff       	call   137 <foo>
    pid = fork();
 17d:	e8 0e 05 00 00       	call   690 <fork>
 182:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid && (i % 3) == 1){
 185:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 189:	74 29                	je     1b4 <concreate+0x69>
 18b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 18e:	ba 56 55 55 55       	mov    $0x55555556,%edx
 193:	89 c8                	mov    %ecx,%eax
 195:	f7 ea                	imul   %edx
 197:	89 c8                	mov    %ecx,%eax
 199:	c1 f8 1f             	sar    $0x1f,%eax
 19c:	29 c2                	sub    %eax,%edx
 19e:	89 d0                	mov    %edx,%eax
 1a0:	01 c0                	add    %eax,%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	29 c1                	sub    %eax,%ecx
 1a6:	89 ca                	mov    %ecx,%edx
 1a8:	83 fa 01             	cmp    $0x1,%edx
 1ab:	75 07                	jne    1b4 <concreate+0x69>
      foo();
 1ad:	e8 85 ff ff ff       	call   137 <foo>
 1b2:	eb 65                	jmp    219 <concreate+0xce>
    } else if(pid == 0 && (i % 5) == 1){
 1b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 1b8:	75 2c                	jne    1e6 <concreate+0x9b>
 1ba:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 1bd:	ba 67 66 66 66       	mov    $0x66666667,%edx
 1c2:	89 c8                	mov    %ecx,%eax
 1c4:	f7 ea                	imul   %edx
 1c6:	d1 fa                	sar    %edx
 1c8:	89 c8                	mov    %ecx,%eax
 1ca:	c1 f8 1f             	sar    $0x1f,%eax
 1cd:	29 c2                	sub    %eax,%edx
 1cf:	89 d0                	mov    %edx,%eax
 1d1:	c1 e0 02             	shl    $0x2,%eax
 1d4:	01 d0                	add    %edx,%eax
 1d6:	29 c1                	sub    %eax,%ecx
 1d8:	89 ca                	mov    %ecx,%edx
 1da:	83 fa 01             	cmp    $0x1,%edx
 1dd:	75 07                	jne    1e6 <concreate+0x9b>
      foo();
 1df:	e8 53 ff ff ff       	call   137 <foo>
 1e4:	eb 33                	jmp    219 <concreate+0xce>
    } else {
      fd = getpid();
 1e6:	e8 2d 05 00 00       	call   718 <getpid>
 1eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(fd < 0){
 1ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 1f2:	79 20                	jns    214 <concreate+0xc9>
        printf(1, "concreate create %s failed\n", file);
 1f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1f7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1fb:	c7 44 24 04 71 0c 00 	movl   $0xc71,0x4(%esp)
 202:	00 
 203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 20a:	e8 29 06 00 00       	call   838 <printf>
        exit();
 20f:	e8 84 04 00 00       	call   698 <exit>
      }
      getpid();
 214:	e8 ff 04 00 00       	call   718 <getpid>
    }
    if(pid == 0)
 219:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 21d:	75 05                	jne    224 <concreate+0xd9>
      exit();
 21f:	e8 74 04 00 00       	call   698 <exit>
    else
      wait();
 224:	e8 77 04 00 00       	call   6a0 <wait>
  printf(1,"iter : %d \n", i) ;
 229:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22c:	89 44 24 08          	mov    %eax,0x8(%esp)
 230:	c7 44 24 04 8d 0c 00 	movl   $0xc8d,0x4(%esp)
 237:	00 
 238:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 23f:	e8 f4 05 00 00       	call   838 <printf>
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
  for(i = 0; i < 40; i++){
 244:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 248:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
 24c:	0f 8e 26 ff ff ff    	jle    178 <concreate+0x2d>
      exit();
    else
      wait();
  printf(1,"iter : %d \n", i) ;
  }
  printf(1, "finitio \n"); 
 252:	c7 44 24 04 99 0c 00 	movl   $0xc99,0x4(%esp)
 259:	00 
 25a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 261:	e8 d2 05 00 00       	call   838 <printf>
  memset(fa, 0, sizeof(fa));
 266:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
 26d:	00 
 26e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 275:	00 
 276:	8d 45 b8             	lea    -0x48(%ebp),%eax
 279:	89 04 24             	mov    %eax,(%esp)
 27c:	e8 6a 02 00 00       	call   4eb <memset>
  n = 0;
 281:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  j = 100;
 288:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)
  db;
 28f:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
 296:	00 
 297:	c7 44 24 04 a3 0c 00 	movl   $0xca3,0x4(%esp)
 29e:	00 
 29f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2a6:	e8 8d 05 00 00       	call   838 <printf>
  while(j-->0){
 2ab:	e9 94 00 00 00       	jmp    344 <concreate+0x1f9>
    if(de.inum == 0) {
 2b0:	0f b7 45 a8          	movzwl -0x58(%ebp),%eax
 2b4:	66 85 c0             	test   %ax,%ax
 2b7:	75 1d                	jne    2d6 <concreate+0x18b>
      printf(1, "iter2 i %d \n", j);
 2b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2bc:	89 44 24 08          	mov    %eax,0x8(%esp)
 2c0:	c7 44 24 04 ad 0c 00 	movl   $0xcad,0x4(%esp)
 2c7:	00 
 2c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2cf:	e8 64 05 00 00       	call   838 <printf>
      continue;
 2d4:	eb 6e                	jmp    344 <concreate+0x1f9>
    }
    if(de.name[0] == 'C' && de.name[2] == '\0'){
 2d6:	0f b6 45 aa          	movzbl -0x56(%ebp),%eax
 2da:	3c 43                	cmp    $0x43,%al
 2dc:	75 4b                	jne    329 <concreate+0x1de>
 2de:	0f b6 45 ac          	movzbl -0x54(%ebp),%eax
 2e2:	84 c0                	test   %al,%al
 2e4:	75 43                	jne    329 <concreate+0x1de>
      i = de.name[1] - '0';
 2e6:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
 2ea:	0f be c0             	movsbl %al,%eax
 2ed:	83 e8 30             	sub    $0x30,%eax
 2f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
 2f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f7:	78 08                	js     301 <concreate+0x1b6>
 2f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fc:	83 f8 27             	cmp    $0x27,%eax
 2ff:	76 05                	jbe    306 <concreate+0x1bb>
        foo();
 301:	e8 31 fe ff ff       	call   137 <foo>
      }
      if(fa[i]){
 306:	8d 55 b8             	lea    -0x48(%ebp),%edx
 309:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30c:	01 d0                	add    %edx,%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 05                	je     31a <concreate+0x1cf>
        foo();
 315:	e8 1d fe ff ff       	call   137 <foo>
      }
      fa[i] = 1;
 31a:	8d 55 b8             	lea    -0x48(%ebp),%edx
 31d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 320:	01 d0                	add    %edx,%eax
 322:	c6 00 01             	movb   $0x1,(%eax)
      n++;
 325:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    }
    printf(1, "iter2 i %d \n", j);
 329:	8b 45 f0             	mov    -0x10(%ebp),%eax
 32c:	89 44 24 08          	mov    %eax,0x8(%esp)
 330:	c7 44 24 04 ad 0c 00 	movl   $0xcad,0x4(%esp)
 337:	00 
 338:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 33f:	e8 f4 04 00 00       	call   838 <printf>
  printf(1, "finitio \n"); 
  memset(fa, 0, sizeof(fa));
  n = 0;
  j = 100;
  db;
  while(j-->0){
 344:	8b 45 f0             	mov    -0x10(%ebp),%eax
 347:	8d 50 ff             	lea    -0x1(%eax),%edx
 34a:	89 55 f0             	mov    %edx,-0x10(%ebp)
 34d:	85 c0                	test   %eax,%eax
 34f:	0f 8f 5b ff ff ff    	jg     2b0 <concreate+0x165>
      n++;
    }
    printf(1, "iter2 i %d \n", j);
  }

  if(n != 40){
 355:	83 7d ec 28          	cmpl   $0x28,-0x14(%ebp)
 359:	74 05                	je     360 <concreate+0x215>
    foo();
 35b:	e8 d7 fd ff ff       	call   137 <foo>
  }

  for(i = 0; i < 40; i++){
 360:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 367:	e9 a4 00 00 00       	jmp    410 <concreate+0x2c5>
    file[1] = '0' + i;
 36c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 36f:	8d 50 01             	lea    0x1(%eax),%edx
 372:	8b 45 f4             	mov    -0xc(%ebp),%eax
 375:	83 c0 30             	add    $0x30,%eax
 378:	88 02                	mov    %al,(%edx)
    pid = fork();
 37a:	e8 11 03 00 00       	call   690 <fork>
 37f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
 382:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 386:	79 19                	jns    3a1 <concreate+0x256>
      printf(1, "fork failed\n");
 388:	c7 44 24 04 ba 0c 00 	movl   $0xcba,0x4(%esp)
 38f:	00 
 390:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 397:	e8 9c 04 00 00       	call   838 <printf>
      exit();
 39c:	e8 f7 02 00 00       	call   698 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
 3a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3a4:	ba 56 55 55 55       	mov    $0x55555556,%edx
 3a9:	89 c8                	mov    %ecx,%eax
 3ab:	f7 ea                	imul   %edx
 3ad:	89 c8                	mov    %ecx,%eax
 3af:	c1 f8 1f             	sar    $0x1f,%eax
 3b2:	29 c2                	sub    %eax,%edx
 3b4:	89 d0                	mov    %edx,%eax
 3b6:	01 c0                	add    %eax,%eax
 3b8:	01 d0                	add    %edx,%eax
 3ba:	29 c1                	sub    %eax,%ecx
 3bc:	89 ca                	mov    %ecx,%edx
 3be:	85 d2                	test   %edx,%edx
 3c0:	75 06                	jne    3c8 <concreate+0x27d>
 3c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 3c6:	74 28                	je     3f0 <concreate+0x2a5>
       ((i % 3) == 1 && pid != 0)){
 3c8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3cb:	ba 56 55 55 55       	mov    $0x55555556,%edx
 3d0:	89 c8                	mov    %ecx,%eax
 3d2:	f7 ea                	imul   %edx
 3d4:	89 c8                	mov    %ecx,%eax
 3d6:	c1 f8 1f             	sar    $0x1f,%eax
 3d9:	29 c2                	sub    %eax,%edx
 3db:	89 d0                	mov    %edx,%eax
 3dd:	01 c0                	add    %eax,%eax
 3df:	01 d0                	add    %edx,%eax
 3e1:	29 c1                	sub    %eax,%ecx
 3e3:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
 3e5:	83 fa 01             	cmp    $0x1,%edx
 3e8:	75 0d                	jne    3f7 <concreate+0x2ac>
       ((i % 3) == 1 && pid != 0)){
 3ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 3ee:	74 07                	je     3f7 <concreate+0x2ac>
      foo();
 3f0:	e8 42 fd ff ff       	call   137 <foo>
 3f5:	eb 05                	jmp    3fc <concreate+0x2b1>
    } else {
      foo();
 3f7:	e8 3b fd ff ff       	call   137 <foo>
    }
    if(pid == 0)
 3fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 400:	75 05                	jne    407 <concreate+0x2bc>
      exit();
 402:	e8 91 02 00 00       	call   698 <exit>
    else
      wait();
 407:	e8 94 02 00 00       	call   6a0 <wait>

  if(n != 40){
    foo();
  }

  for(i = 0; i < 40; i++){
 40c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 410:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
 414:	0f 8e 52 ff ff ff    	jle    36c <concreate+0x221>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
 41a:	c7 44 24 04 c7 0c 00 	movl   $0xcc7,0x4(%esp)
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
 7d1:	0f b6 80 80 0f 00 00 	movzbl 0xf80(%eax),%eax
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
 930:	c7 45 f4 d5 0c 00 00 	movl   $0xcd5,-0xc(%ebp)
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
 9fa:	a1 9c 0f 00 00       	mov    0xf9c,%eax
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
 ac5:	a3 9c 0f 00 00       	mov    %eax,0xf9c
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
 b1d:	a1 9c 0f 00 00       	mov    0xf9c,%eax
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
 b39:	a1 9c 0f 00 00       	mov    0xf9c,%eax
 b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b45:	75 23                	jne    b6a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b47:	c7 45 f0 94 0f 00 00 	movl   $0xf94,-0x10(%ebp)
 b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b51:	a3 9c 0f 00 00       	mov    %eax,0xf9c
 b56:	a1 9c 0f 00 00       	mov    0xf9c,%eax
 b5b:	a3 94 0f 00 00       	mov    %eax,0xf94
    base.s.size = 0;
 b60:	c7 05 98 0f 00 00 00 	movl   $0x0,0xf98
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
 bbd:	a3 9c 0f 00 00       	mov    %eax,0xf9c
      return (void*)(p + 1);
 bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc5:	83 c0 08             	add    $0x8,%eax
 bc8:	eb 38                	jmp    c02 <malloc+0xde>
    }
    if(p == freep)
 bca:	a1 9c 0f 00 00       	mov    0xf9c,%eax
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
