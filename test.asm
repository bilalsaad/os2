
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <handler>:
#include "types.h"
#include "stat.h" 
#include "user.h"

void handler(int pid, int value) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(1, "I got a signal pid[%d], value[%d] \n", pid, value);
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 44 24 0c          	mov    %eax,0xc(%esp)
   d:	8b 45 08             	mov    0x8(%ebp),%eax
  10:	89 44 24 08          	mov    %eax,0x8(%esp)
  14:	c7 44 24 04 b0 08 00 	movl   $0x8b0,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 bb 04 00 00       	call   4e3 <printf>
}
  28:	c9                   	leave  
  29:	c3                   	ret    

0000002a <main>:
int main(int argc, char** argv) {
  2a:	55                   	push   %ebp
  2b:	89 e5                	mov    %esp,%ebp
  2d:	83 e4 f0             	and    $0xfffffff0,%esp
  30:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int i = 10;
  33:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
  3a:	00 
  int parent_pid = getpid();
  3b:	e8 83 03 00 00       	call   3c3 <getpid>
  40:	89 44 24 18          	mov    %eax,0x18(%esp)
  sigset(handler);
  44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  4b:	e8 93 03 00 00       	call   3e3 <sigset>
  pid = fork();
  50:	e8 e6 02 00 00       	call   33b <fork>
  55:	89 44 24 14          	mov    %eax,0x14(%esp)
  

  if(pid == 0){ // child code
  59:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  5e:	75 40                	jne    a0 <main+0x76>
    while(i --> 0) {
  60:	eb 2d                	jmp    8f <main+0x65>
      sigpause();
  62:	e8 94 03 00 00       	call   3fb <sigpause>
      printf(1, "hallliluja \n");
  67:	c7 44 24 04 d4 08 00 	movl   $0x8d4,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  76:	e8 68 04 00 00       	call   4e3 <printf>
      sigsend(parent_pid, 1);
  7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  82:	00 
  83:	8b 44 24 18          	mov    0x18(%esp),%eax
  87:	89 04 24             	mov    %eax,(%esp)
  8a:	e8 5c 03 00 00       	call   3eb <sigsend>
  sigset(handler);
  pid = fork();
  

  if(pid == 0){ // child code
    while(i --> 0) {
  8f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  93:	8d 50 ff             	lea    -0x1(%eax),%edx
  96:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  9a:	85 c0                	test   %eax,%eax
  9c:	7f c4                	jg     62 <main+0x38>
  9e:	eb 36                	jmp    d6 <main+0xac>
      printf(1, "hallliluja \n");
      sigsend(parent_pid, 1);
    }
  }
  else {
    while(i-->0){
  a0:	eb 25                	jmp    c7 <main+0x9d>
      sleep(10);
  a2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  a9:	e8 25 03 00 00       	call   3d3 <sleep>
      sigsend(pid, i);
  ae:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  b6:	8b 44 24 14          	mov    0x14(%esp),%eax
  ba:	89 04 24             	mov    %eax,(%esp)
  bd:	e8 29 03 00 00       	call   3eb <sigsend>
      sigpause();
  c2:	e8 34 03 00 00       	call   3fb <sigpause>
      printf(1, "hallliluja \n");
      sigsend(parent_pid, 1);
    }
  }
  else {
    while(i-->0){
  c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  ce:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  d2:	85 c0                	test   %eax,%eax
  d4:	7f cc                	jg     a2 <main+0x78>
      sigsend(pid, i);
      sigpause();
    }
  }

  exit();
  d6:	e8 68 02 00 00       	call   343 <exit>

000000db <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e3:	8b 55 10             	mov    0x10(%ebp),%edx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	89 cb                	mov    %ecx,%ebx
  eb:	89 df                	mov    %ebx,%edi
  ed:	89 d1                	mov    %edx,%ecx
  ef:	fc                   	cld    
  f0:	f3 aa                	rep stos %al,%es:(%edi)
  f2:	89 ca                	mov    %ecx,%edx
  f4:	89 fb                	mov    %edi,%ebx
  f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  fc:	5b                   	pop    %ebx
  fd:	5f                   	pop    %edi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 10c:	90                   	nop
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	8d 50 01             	lea    0x1(%eax),%edx
 113:	89 55 08             	mov    %edx,0x8(%ebp)
 116:	8b 55 0c             	mov    0xc(%ebp),%edx
 119:	8d 4a 01             	lea    0x1(%edx),%ecx
 11c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 11f:	0f b6 12             	movzbl (%edx),%edx
 122:	88 10                	mov    %dl,(%eax)
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 e2                	jne    10d <strcpy+0xd>
    ;
  return os;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 133:	eb 08                	jmp    13d <strcmp+0xd>
    p++, q++;
 135:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 139:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	74 10                	je     157 <strcmp+0x27>
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	38 c2                	cmp    %al,%dl
 155:	74 de                	je     135 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	0f b6 d0             	movzbl %al,%edx
 160:	8b 45 0c             	mov    0xc(%ebp),%eax
 163:	0f b6 00             	movzbl (%eax),%eax
 166:	0f b6 c0             	movzbl %al,%eax
 169:	29 c2                	sub    %eax,%edx
 16b:	89 d0                	mov    %edx,%eax
}
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    

0000016f <strlen>:

uint
strlen(char *s)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 17c:	eb 04                	jmp    182 <strlen+0x13>
 17e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 182:	8b 55 fc             	mov    -0x4(%ebp),%edx
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 ed                	jne    17e <strlen+0xf>
    ;
  return n;
 191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <memset>:

void*
memset(void *dst, int c, uint n)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 19c:	8b 45 10             	mov    0x10(%ebp),%eax
 19f:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	89 04 24             	mov    %eax,(%esp)
 1b0:	e8 26 ff ff ff       	call   db <stosb>
  return dst;
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	83 ec 04             	sub    $0x4,%esp
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c6:	eb 14                	jmp    1dc <strchr+0x22>
    if(*s == c)
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d1:	75 05                	jne    1d8 <strchr+0x1e>
      return (char*)s;
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	eb 13                	jmp    1eb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	0f b6 00             	movzbl (%eax),%eax
 1e2:	84 c0                	test   %al,%al
 1e4:	75 e2                	jne    1c8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <gets>:

char*
gets(char *buf, int max)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fa:	eb 4c                	jmp    248 <gets+0x5b>
    cc = read(0, &c, 1);
 1fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 203:	00 
 204:	8d 45 ef             	lea    -0x11(%ebp),%eax
 207:	89 44 24 04          	mov    %eax,0x4(%esp)
 20b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 212:	e8 44 01 00 00       	call   35b <read>
 217:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 21e:	7f 02                	jg     222 <gets+0x35>
      break;
 220:	eb 31                	jmp    253 <gets+0x66>
    buf[i++] = c;
 222:	8b 45 f4             	mov    -0xc(%ebp),%eax
 225:	8d 50 01             	lea    0x1(%eax),%edx
 228:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22b:	89 c2                	mov    %eax,%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	01 c2                	add    %eax,%edx
 232:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 236:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 238:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23c:	3c 0a                	cmp    $0xa,%al
 23e:	74 13                	je     253 <gets+0x66>
 240:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 244:	3c 0d                	cmp    $0xd,%al
 246:	74 0b                	je     253 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24b:	83 c0 01             	add    $0x1,%eax
 24e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 251:	7c a9                	jl     1fc <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 253:	8b 55 f4             	mov    -0xc(%ebp),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	01 d0                	add    %edx,%eax
 25b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 261:	c9                   	leave  
 262:	c3                   	ret    

00000263 <stat>:

int
stat(char *n, struct stat *st)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 269:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 270:	00 
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	89 04 24             	mov    %eax,(%esp)
 277:	e8 07 01 00 00       	call   383 <open>
 27c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 27f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 283:	79 07                	jns    28c <stat+0x29>
    return -1;
 285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28a:	eb 23                	jmp    2af <stat+0x4c>
  r = fstat(fd, st);
 28c:	8b 45 0c             	mov    0xc(%ebp),%eax
 28f:	89 44 24 04          	mov    %eax,0x4(%esp)
 293:	8b 45 f4             	mov    -0xc(%ebp),%eax
 296:	89 04 24             	mov    %eax,(%esp)
 299:	e8 fd 00 00 00       	call   39b <fstat>
 29e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a4:	89 04 24             	mov    %eax,(%esp)
 2a7:	e8 bf 00 00 00       	call   36b <close>
  return r;
 2ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2af:	c9                   	leave  
 2b0:	c3                   	ret    

000002b1 <atoi>:

int
atoi(const char *s)
{
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2be:	eb 25                	jmp    2e5 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c3:	89 d0                	mov    %edx,%eax
 2c5:	c1 e0 02             	shl    $0x2,%eax
 2c8:	01 d0                	add    %edx,%eax
 2ca:	01 c0                	add    %eax,%eax
 2cc:	89 c1                	mov    %eax,%ecx
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	8d 50 01             	lea    0x1(%eax),%edx
 2d4:	89 55 08             	mov    %edx,0x8(%ebp)
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	0f be c0             	movsbl %al,%eax
 2dd:	01 c8                	add    %ecx,%eax
 2df:	83 e8 30             	sub    $0x30,%eax
 2e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	3c 2f                	cmp    $0x2f,%al
 2ed:	7e 0a                	jle    2f9 <atoi+0x48>
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	0f b6 00             	movzbl (%eax),%eax
 2f5:	3c 39                	cmp    $0x39,%al
 2f7:	7e c7                	jle    2c0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    

000002fe <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
 301:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 310:	eb 17                	jmp    329 <memmove+0x2b>
    *dst++ = *src++;
 312:	8b 45 fc             	mov    -0x4(%ebp),%eax
 315:	8d 50 01             	lea    0x1(%eax),%edx
 318:	89 55 fc             	mov    %edx,-0x4(%ebp)
 31b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31e:	8d 4a 01             	lea    0x1(%edx),%ecx
 321:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 324:	0f b6 12             	movzbl (%edx),%edx
 327:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 329:	8b 45 10             	mov    0x10(%ebp),%eax
 32c:	8d 50 ff             	lea    -0x1(%eax),%edx
 32f:	89 55 10             	mov    %edx,0x10(%ebp)
 332:	85 c0                	test   %eax,%eax
 334:	7f dc                	jg     312 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33b:	b8 01 00 00 00       	mov    $0x1,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <exit>:
SYSCALL(exit)
 343:	b8 02 00 00 00       	mov    $0x2,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <wait>:
SYSCALL(wait)
 34b:	b8 03 00 00 00       	mov    $0x3,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <pipe>:
SYSCALL(pipe)
 353:	b8 04 00 00 00       	mov    $0x4,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <read>:
SYSCALL(read)
 35b:	b8 05 00 00 00       	mov    $0x5,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <write>:
SYSCALL(write)
 363:	b8 10 00 00 00       	mov    $0x10,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <close>:
SYSCALL(close)
 36b:	b8 15 00 00 00       	mov    $0x15,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <kill>:
SYSCALL(kill)
 373:	b8 06 00 00 00       	mov    $0x6,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <exec>:
SYSCALL(exec)
 37b:	b8 07 00 00 00       	mov    $0x7,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <open>:
SYSCALL(open)
 383:	b8 0f 00 00 00       	mov    $0xf,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mknod>:
SYSCALL(mknod)
 38b:	b8 11 00 00 00       	mov    $0x11,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <unlink>:
SYSCALL(unlink)
 393:	b8 12 00 00 00       	mov    $0x12,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <fstat>:
SYSCALL(fstat)
 39b:	b8 08 00 00 00       	mov    $0x8,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <link>:
SYSCALL(link)
 3a3:	b8 13 00 00 00       	mov    $0x13,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mkdir>:
SYSCALL(mkdir)
 3ab:	b8 14 00 00 00       	mov    $0x14,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <chdir>:
SYSCALL(chdir)
 3b3:	b8 09 00 00 00       	mov    $0x9,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <dup>:
SYSCALL(dup)
 3bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <getpid>:
SYSCALL(getpid)
 3c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <sbrk>:
SYSCALL(sbrk)
 3cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <sleep>:
SYSCALL(sleep)
 3d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <uptime>:
SYSCALL(uptime)
 3db:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <sigset>:
SYSCALL(sigset)
 3e3:	b8 16 00 00 00       	mov    $0x16,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sigsend>:
SYSCALL(sigsend)
 3eb:	b8 17 00 00 00       	mov    $0x17,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sigret>:
SYSCALL(sigret)
 3f3:	b8 18 00 00 00       	mov    $0x18,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <sigpause>:
SYSCALL(sigpause)
 3fb:	b8 19 00 00 00       	mov    $0x19,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	83 ec 18             	sub    $0x18,%esp
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 416:	00 
 417:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41a:	89 44 24 04          	mov    %eax,0x4(%esp)
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	89 04 24             	mov    %eax,(%esp)
 424:	e8 3a ff ff ff       	call   363 <write>
}
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	56                   	push   %esi
 42f:	53                   	push   %ebx
 430:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 433:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43e:	74 17                	je     457 <printint+0x2c>
 440:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 444:	79 11                	jns    457 <printint+0x2c>
    neg = 1;
 446:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	f7 d8                	neg    %eax
 452:	89 45 ec             	mov    %eax,-0x14(%ebp)
 455:	eb 06                	jmp    45d <printint+0x32>
  } else {
    x = xx;
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 45d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 464:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 467:	8d 41 01             	lea    0x1(%ecx),%eax
 46a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 470:	8b 45 ec             	mov    -0x14(%ebp),%eax
 473:	ba 00 00 00 00       	mov    $0x0,%edx
 478:	f7 f3                	div    %ebx
 47a:	89 d0                	mov    %edx,%eax
 47c:	0f b6 80 4c 0b 00 00 	movzbl 0xb4c(%eax),%eax
 483:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 487:	8b 75 10             	mov    0x10(%ebp),%esi
 48a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f6                	div    %esi
 494:	89 45 ec             	mov    %eax,-0x14(%ebp)
 497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49b:	75 c7                	jne    464 <printint+0x39>
  if(neg)
 49d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a1:	74 10                	je     4b3 <printint+0x88>
    buf[i++] = '-';
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	8d 50 01             	lea    0x1(%eax),%edx
 4a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b1:	eb 1f                	jmp    4d2 <printint+0xa7>
 4b3:	eb 1d                	jmp    4d2 <printint+0xa7>
    putc(fd, buf[i]);
 4b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	01 d0                	add    %edx,%eax
 4bd:	0f b6 00             	movzbl (%eax),%eax
 4c0:	0f be c0             	movsbl %al,%eax
 4c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	89 04 24             	mov    %eax,(%esp)
 4cd:	e8 31 ff ff ff       	call   403 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4da:	79 d9                	jns    4b5 <printint+0x8a>
    putc(fd, buf[i]);
}
 4dc:	83 c4 30             	add    $0x30,%esp
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5d                   	pop    %ebp
 4e2:	c3                   	ret    

000004e3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e3:	55                   	push   %ebp
 4e4:	89 e5                	mov    %esp,%ebp
 4e6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f0:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f3:	83 c0 04             	add    $0x4,%eax
 4f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 500:	e9 7c 01 00 00       	jmp    681 <printf+0x19e>
    c = fmt[i] & 0xff;
 505:	8b 55 0c             	mov    0xc(%ebp),%edx
 508:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50b:	01 d0                	add    %edx,%eax
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	25 ff 00 00 00       	and    $0xff,%eax
 518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51f:	75 2c                	jne    54d <printf+0x6a>
      if(c == '%'){
 521:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 525:	75 0c                	jne    533 <printf+0x50>
        state = '%';
 527:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52e:	e9 4a 01 00 00       	jmp    67d <printf+0x19a>
      } else {
        putc(fd, c);
 533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	89 44 24 04          	mov    %eax,0x4(%esp)
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	89 04 24             	mov    %eax,(%esp)
 543:	e8 bb fe ff ff       	call   403 <putc>
 548:	e9 30 01 00 00       	jmp    67d <printf+0x19a>
      }
    } else if(state == '%'){
 54d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 551:	0f 85 26 01 00 00    	jne    67d <printf+0x19a>
      if(c == 'd'){
 557:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55b:	75 2d                	jne    58a <printf+0xa7>
        printint(fd, *ap, 10, 1);
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 569:	00 
 56a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 571:	00 
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 aa fe ff ff       	call   42b <printint>
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 585:	e9 ec 00 00 00       	jmp    676 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 58a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58e:	74 06                	je     596 <printf+0xb3>
 590:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 594:	75 2d                	jne    5c3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 596:	8b 45 e8             	mov    -0x18(%ebp),%eax
 599:	8b 00                	mov    (%eax),%eax
 59b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5a2:	00 
 5a3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5aa:	00 
 5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 71 fe ff ff       	call   42b <printint>
        ap++;
 5ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5be:	e9 b3 00 00 00       	jmp    676 <printf+0x193>
      } else if(c == 's'){
 5c3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c7:	75 45                	jne    60e <printf+0x12b>
        s = (char*)*ap;
 5c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d9:	75 09                	jne    5e4 <printf+0x101>
          s = "(null)";
 5db:	c7 45 f4 e1 08 00 00 	movl   $0x8e1,-0xc(%ebp)
        while(*s != 0){
 5e2:	eb 1e                	jmp    602 <printf+0x11f>
 5e4:	eb 1c                	jmp    602 <printf+0x11f>
          putc(fd, *s);
 5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e9:	0f b6 00             	movzbl (%eax),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 05 fe ff ff       	call   403 <putc>
          s++;
 5fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	84 c0                	test   %al,%al
 60a:	75 da                	jne    5e6 <printf+0x103>
 60c:	eb 68                	jmp    676 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 612:	75 1d                	jne    631 <printf+0x14e>
        putc(fd, *ap);
 614:	8b 45 e8             	mov    -0x18(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	89 44 24 04          	mov    %eax,0x4(%esp)
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	89 04 24             	mov    %eax,(%esp)
 626:	e8 d8 fd ff ff       	call   403 <putc>
        ap++;
 62b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62f:	eb 45                	jmp    676 <printf+0x193>
      } else if(c == '%'){
 631:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 635:	75 17                	jne    64e <printf+0x16b>
        putc(fd, c);
 637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63a:	0f be c0             	movsbl %al,%eax
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 b7 fd ff ff       	call   403 <putc>
 64c:	eb 28                	jmp    676 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 655:	00 
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 a2 fd ff ff       	call   403 <putc>
        putc(fd, c);
 661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 664:	0f be c0             	movsbl %al,%eax
 667:	89 44 24 04          	mov    %eax,0x4(%esp)
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 8d fd ff ff       	call   403 <putc>
      }
      state = 0;
 676:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 67d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 681:	8b 55 0c             	mov    0xc(%ebp),%edx
 684:	8b 45 f0             	mov    -0x10(%ebp),%eax
 687:	01 d0                	add    %edx,%eax
 689:	0f b6 00             	movzbl (%eax),%eax
 68c:	84 c0                	test   %al,%al
 68e:	0f 85 71 fe ff ff    	jne    505 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 694:	c9                   	leave  
 695:	c3                   	ret    

00000696 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 696:	55                   	push   %ebp
 697:	89 e5                	mov    %esp,%ebp
 699:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69c:	8b 45 08             	mov    0x8(%ebp),%eax
 69f:	83 e8 08             	sub    $0x8,%eax
 6a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	a1 68 0b 00 00       	mov    0xb68,%eax
 6aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ad:	eb 24                	jmp    6d3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b7:	77 12                	ja     6cb <free+0x35>
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bf:	77 24                	ja     6e5 <free+0x4f>
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c9:	77 1a                	ja     6e5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	76 d4                	jbe    6af <free+0x19>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e3:	76 ca                	jbe    6af <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	8b 40 04             	mov    0x4(%eax),%eax
 6eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	01 c2                	add    %eax,%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	39 c2                	cmp    %eax,%edx
 6fe:	75 24                	jne    724 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 50 04             	mov    0x4(%eax),%edx
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	8b 40 04             	mov    0x4(%eax),%eax
 70e:	01 c2                	add    %eax,%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 00                	mov    (%eax),%eax
 71b:	8b 10                	mov    (%eax),%edx
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	89 10                	mov    %edx,(%eax)
 722:	eb 0a                	jmp    72e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 10                	mov    (%eax),%edx
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 743:	75 20                	jne    765 <free+0xcf>
    p->s.size += bp->s.size;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 50 04             	mov    0x4(%eax),%edx
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	01 c2                	add    %eax,%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	8b 10                	mov    (%eax),%edx
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	89 10                	mov    %edx,(%eax)
 763:	eb 08                	jmp    76d <free+0xd7>
  } else
    p->s.ptr = bp;
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 55 f8             	mov    -0x8(%ebp),%edx
 76b:	89 10                	mov    %edx,(%eax)
  freep = p;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 775:	c9                   	leave  
 776:	c3                   	ret    

00000777 <morecore>:

static Header*
morecore(uint nu)
{
 777:	55                   	push   %ebp
 778:	89 e5                	mov    %esp,%ebp
 77a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 784:	77 07                	ja     78d <morecore+0x16>
    nu = 4096;
 786:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	c1 e0 03             	shl    $0x3,%eax
 793:	89 04 24             	mov    %eax,(%esp)
 796:	e8 30 fc ff ff       	call   3cb <sbrk>
 79b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 79e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a2:	75 07                	jne    7ab <morecore+0x34>
    return 0;
 7a4:	b8 00 00 00 00       	mov    $0x0,%eax
 7a9:	eb 22                	jmp    7cd <morecore+0x56>
  hp = (Header*)p;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	8b 55 08             	mov    0x8(%ebp),%edx
 7b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	83 c0 08             	add    $0x8,%eax
 7c0:	89 04 24             	mov    %eax,(%esp)
 7c3:	e8 ce fe ff ff       	call   696 <free>
  return freep;
 7c8:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7cd:	c9                   	leave  
 7ce:	c3                   	ret    

000007cf <malloc>:

void*
malloc(uint nbytes)
{
 7cf:	55                   	push   %ebp
 7d0:	89 e5                	mov    %esp,%ebp
 7d2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	83 c0 07             	add    $0x7,%eax
 7db:	c1 e8 03             	shr    $0x3,%eax
 7de:	83 c0 01             	add    $0x1,%eax
 7e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e4:	a1 68 0b 00 00       	mov    0xb68,%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f0:	75 23                	jne    815 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f2:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	a3 68 0b 00 00       	mov    %eax,0xb68
 801:	a1 68 0b 00 00       	mov    0xb68,%eax
 806:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 80b:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 812:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 826:	72 4d                	jb     875 <malloc+0xa6>
      if(p->s.size == nunits)
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 831:	75 0c                	jne    83f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	89 10                	mov    %edx,(%eax)
 83d:	eb 26                	jmp    865 <malloc+0x96>
      else {
        p->s.size -= nunits;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 40 04             	mov    0x4(%eax),%eax
 845:	2b 45 ec             	sub    -0x14(%ebp),%eax
 848:	89 c2                	mov    %eax,%edx
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	c1 e0 03             	shl    $0x3,%eax
 859:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 862:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	83 c0 08             	add    $0x8,%eax
 873:	eb 38                	jmp    8ad <malloc+0xde>
    }
    if(p == freep)
 875:	a1 68 0b 00 00       	mov    0xb68,%eax
 87a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 87d:	75 1b                	jne    89a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 87f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 882:	89 04 24             	mov    %eax,(%esp)
 885:	e8 ed fe ff ff       	call   777 <morecore>
 88a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 891:	75 07                	jne    89a <malloc+0xcb>
        return 0;
 893:	b8 00 00 00 00       	mov    $0x0,%eax
 898:	eb 13                	jmp    8ad <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a8:	e9 70 ff ff ff       	jmp    81d <malloc+0x4e>
}
 8ad:	c9                   	leave  
 8ae:	c3                   	ret    
