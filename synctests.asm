
_synctests:     file format elf32-i386


Disassembly of section .text:

00000000 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
       6:	8d 45 d8             	lea    -0x28(%ebp),%eax
       9:	89 04 24             	mov    %eax,(%esp)
       c:	e8 48 0f 00 00       	call   f59 <pipe>
      11:	85 c0                	test   %eax,%eax
      13:	74 19                	je     2e <pipe1+0x2e>
    printf(1, "pipe() failed\n");
      15:	c7 44 24 04 ce 14 00 	movl   $0x14ce,0x4(%esp)
      1c:	00 
      1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      24:	e8 c0 10 00 00       	call   10e9 <printf>
    exit();
      29:	e8 1b 0f 00 00       	call   f49 <exit>
  }
  pid = fork();
      2e:	e8 0e 0f 00 00       	call   f41 <fork>
      33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
      36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
      3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
      41:	0f 85 88 00 00 00    	jne    cf <pipe1+0xcf>
    close(fds[0]);
      47:	8b 45 d8             	mov    -0x28(%ebp),%eax
      4a:	89 04 24             	mov    %eax,(%esp)
      4d:	e8 1f 0f 00 00       	call   f71 <close>
    for(n = 0; n < 5; n++){
      52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
      59:	eb 69                	jmp    c4 <pipe1+0xc4>
      for(i = 0; i < 1033; i++)
      5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      62:	eb 18                	jmp    7c <pipe1+0x7c>
        buf[i] = seq++;
      64:	8b 45 f4             	mov    -0xc(%ebp),%eax
      67:	8d 50 01             	lea    0x1(%eax),%edx
      6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
      6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
      70:	81 c2 a0 1c 00 00    	add    $0x1ca0,%edx
      76:	88 02                	mov    %al,(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
      78:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      7c:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
      83:	7e df                	jle    64 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
      85:	8b 45 dc             	mov    -0x24(%ebp),%eax
      88:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
      8f:	00 
      90:	c7 44 24 04 a0 1c 00 	movl   $0x1ca0,0x4(%esp)
      97:	00 
      98:	89 04 24             	mov    %eax,(%esp)
      9b:	e8 c9 0e 00 00       	call   f69 <write>
      a0:	3d 09 04 00 00       	cmp    $0x409,%eax
      a5:	74 19                	je     c0 <pipe1+0xc0>
        printf(1, "pipe1 oops 1\n");
      a7:	c7 44 24 04 dd 14 00 	movl   $0x14dd,0x4(%esp)
      ae:	00 
      af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b6:	e8 2e 10 00 00       	call   10e9 <printf>
        exit();
      bb:	e8 89 0e 00 00       	call   f49 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      c0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
      c4:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
      c8:	7e 91                	jle    5b <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
      ca:	e8 7a 0e 00 00       	call   f49 <exit>
  } else if(pid > 0){
      cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
      d3:	0f 8e f9 00 00 00    	jle    1d2 <pipe1+0x1d2>
    close(fds[1]);
      d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
      dc:	89 04 24             	mov    %eax,(%esp)
      df:	e8 8d 0e 00 00       	call   f71 <close>
    total = 0;
      e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
      eb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
      f2:	eb 68                	jmp    15c <pipe1+0x15c>
      for(i = 0; i < n; i++){
      f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      fb:	eb 3d                	jmp    13a <pipe1+0x13a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
      fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     100:	05 a0 1c 00 00       	add    $0x1ca0,%eax
     105:	0f b6 00             	movzbl (%eax),%eax
     108:	0f be c8             	movsbl %al,%ecx
     10b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     10e:	8d 50 01             	lea    0x1(%eax),%edx
     111:	89 55 f4             	mov    %edx,-0xc(%ebp)
     114:	31 c8                	xor    %ecx,%eax
     116:	0f b6 c0             	movzbl %al,%eax
     119:	85 c0                	test   %eax,%eax
     11b:	74 19                	je     136 <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
     11d:	c7 44 24 04 eb 14 00 	movl   $0x14eb,0x4(%esp)
     124:	00 
     125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     12c:	e8 b8 0f 00 00       	call   10e9 <printf>
     131:	e9 b5 00 00 00       	jmp    1eb <pipe1+0x1eb>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     136:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     13a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     13d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     140:	7c bb                	jl     fd <pipe1+0xfd>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     142:	8b 45 ec             	mov    -0x14(%ebp),%eax
     145:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     148:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     14b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     14e:	3d 00 20 00 00       	cmp    $0x2000,%eax
     153:	76 07                	jbe    15c <pipe1+0x15c>
        cc = sizeof(buf);
     155:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     15c:	8b 45 d8             	mov    -0x28(%ebp),%eax
     15f:	8b 55 e8             	mov    -0x18(%ebp),%edx
     162:	89 54 24 08          	mov    %edx,0x8(%esp)
     166:	c7 44 24 04 a0 1c 00 	movl   $0x1ca0,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 eb 0d 00 00       	call   f61 <read>
     176:	89 45 ec             	mov    %eax,-0x14(%ebp)
     179:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     17d:	0f 8f 71 ff ff ff    	jg     f4 <pipe1+0xf4>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     183:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     18a:	74 20                	je     1ac <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
     18c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     18f:	89 44 24 08          	mov    %eax,0x8(%esp)
     193:	c7 44 24 04 f9 14 00 	movl   $0x14f9,0x4(%esp)
     19a:	00 
     19b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1a2:	e8 42 0f 00 00       	call   10e9 <printf>
      exit();
     1a7:	e8 9d 0d 00 00       	call   f49 <exit>
    }
    close(fds[0]);
     1ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
     1af:	89 04 24             	mov    %eax,(%esp)
     1b2:	e8 ba 0d 00 00       	call   f71 <close>
    wait();
     1b7:	e8 95 0d 00 00       	call   f51 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     1bc:	c7 44 24 04 1f 15 00 	movl   $0x151f,0x4(%esp)
     1c3:	00 
     1c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1cb:	e8 19 0f 00 00       	call   10e9 <printf>
     1d0:	eb 19                	jmp    1eb <pipe1+0x1eb>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     1d2:	c7 44 24 04 10 15 00 	movl   $0x1510,0x4(%esp)
     1d9:	00 
     1da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1e1:	e8 03 0f 00 00       	call   10e9 <printf>
    exit();
     1e6:	e8 5e 0d 00 00       	call   f49 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     1eb:	c9                   	leave  
     1ec:	c3                   	ret    

000001ed <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     1ed:	55                   	push   %ebp
     1ee:	89 e5                	mov    %esp,%ebp
     1f0:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     1f3:	c7 44 24 04 29 15 00 	movl   $0x1529,0x4(%esp)
     1fa:	00 
     1fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     202:	e8 e2 0e 00 00       	call   10e9 <printf>
  pid1 = fork();
     207:	e8 35 0d 00 00       	call   f41 <fork>
     20c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     20f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     213:	75 02                	jne    217 <preempt+0x2a>
    for(;;)
      ;
     215:	eb fe                	jmp    215 <preempt+0x28>

  pid2 = fork();
     217:	e8 25 0d 00 00       	call   f41 <fork>
     21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     21f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     223:	75 02                	jne    227 <preempt+0x3a>
    for(;;)
      ;
     225:	eb fe                	jmp    225 <preempt+0x38>

  pipe(pfds);
     227:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     22a:	89 04 24             	mov    %eax,(%esp)
     22d:	e8 27 0d 00 00       	call   f59 <pipe>
  pid3 = fork();
     232:	e8 0a 0d 00 00       	call   f41 <fork>
     237:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     23a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     23e:	75 4c                	jne    28c <preempt+0x9f>
    close(pfds[0]);
     240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     243:	89 04 24             	mov    %eax,(%esp)
     246:	e8 26 0d 00 00       	call   f71 <close>
    if(write(pfds[1], "x", 1) != 1)
     24b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     24e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     255:	00 
     256:	c7 44 24 04 33 15 00 	movl   $0x1533,0x4(%esp)
     25d:	00 
     25e:	89 04 24             	mov    %eax,(%esp)
     261:	e8 03 0d 00 00       	call   f69 <write>
     266:	83 f8 01             	cmp    $0x1,%eax
     269:	74 14                	je     27f <preempt+0x92>
      printf(1, "preempt write error");
     26b:	c7 44 24 04 35 15 00 	movl   $0x1535,0x4(%esp)
     272:	00 
     273:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27a:	e8 6a 0e 00 00       	call   10e9 <printf>
    close(pfds[1]);
     27f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     282:	89 04 24             	mov    %eax,(%esp)
     285:	e8 e7 0c 00 00       	call   f71 <close>
    for(;;)
      ;
     28a:	eb fe                	jmp    28a <preempt+0x9d>
  }

  close(pfds[1]);
     28c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     28f:	89 04 24             	mov    %eax,(%esp)
     292:	e8 da 0c 00 00       	call   f71 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     29a:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     2a1:	00 
     2a2:	c7 44 24 04 a0 1c 00 	movl   $0x1ca0,0x4(%esp)
     2a9:	00 
     2aa:	89 04 24             	mov    %eax,(%esp)
     2ad:	e8 af 0c 00 00       	call   f61 <read>
     2b2:	83 f8 01             	cmp    $0x1,%eax
     2b5:	74 19                	je     2d0 <preempt+0xe3>
    printf(1, "preempt read error");
     2b7:	c7 44 24 04 49 15 00 	movl   $0x1549,0x4(%esp)
     2be:	00 
     2bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c6:	e8 1e 0e 00 00       	call   10e9 <printf>
     2cb:	e9 9f 00 00 00       	jmp    36f <preempt+0x182>
    return;
  }
  close(pfds[0]);
     2d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2d3:	89 04 24             	mov    %eax,(%esp)
     2d6:	e8 96 0c 00 00       	call   f71 <close>
  printf(1, "kill... ");
     2db:	c7 44 24 04 5c 15 00 	movl   $0x155c,0x4(%esp)
     2e2:	00 
     2e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2ea:	e8 fa 0d 00 00       	call   10e9 <printf>
  kill(pid1);
     2ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f2:	89 04 24             	mov    %eax,(%esp)
     2f5:	e8 7f 0c 00 00       	call   f79 <kill>
  kill(pid2);
     2fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2fd:	89 04 24             	mov    %eax,(%esp)
     300:	e8 74 0c 00 00       	call   f79 <kill>
  kill(pid3);
     305:	8b 45 ec             	mov    -0x14(%ebp),%eax
     308:	89 04 24             	mov    %eax,(%esp)
     30b:	e8 69 0c 00 00       	call   f79 <kill>
  printf(1, "wait1... ");
     310:	c7 44 24 04 65 15 00 	movl   $0x1565,0x4(%esp)
     317:	00 
     318:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     31f:	e8 c5 0d 00 00       	call   10e9 <printf>
  wait();
     324:	e8 28 0c 00 00       	call   f51 <wait>
  printf(1, "wait2... ");
     329:	c7 44 24 04 6f 15 00 	movl   $0x156f,0x4(%esp)
     330:	00 
     331:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     338:	e8 ac 0d 00 00       	call   10e9 <printf>
  wait();
     33d:	e8 0f 0c 00 00       	call   f51 <wait>
  printf(1, "wait3... ");
     342:	c7 44 24 04 79 15 00 	movl   $0x1579,0x4(%esp)
     349:	00 
     34a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     351:	e8 93 0d 00 00       	call   10e9 <printf>
  wait();
     356:	e8 f6 0b 00 00       	call   f51 <wait>
  printf(1, "preempt ok\n");
     35b:	c7 44 24 04 83 15 00 	movl   $0x1583,0x4(%esp)
     362:	00 
     363:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     36a:	e8 7a 0d 00 00       	call   10e9 <printf>
}
     36f:	c9                   	leave  
     370:	c3                   	ret    

00000371 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     371:	55                   	push   %ebp
     372:	89 e5                	mov    %esp,%ebp
     374:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     37e:	eb 53                	jmp    3d3 <exitwait+0x62>
    pid = fork();
     380:	e8 bc 0b 00 00       	call   f41 <fork>
     385:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     388:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     38c:	79 16                	jns    3a4 <exitwait+0x33>
      printf(1, "fork failed\n");
     38e:	c7 44 24 04 8f 15 00 	movl   $0x158f,0x4(%esp)
     395:	00 
     396:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     39d:	e8 47 0d 00 00       	call   10e9 <printf>
      return;
     3a2:	eb 49                	jmp    3ed <exitwait+0x7c>
    }
    if(pid){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	74 20                	je     3ca <exitwait+0x59>
      if(wait() != pid){
     3aa:	e8 a2 0b 00 00       	call   f51 <wait>
     3af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     3b2:	74 1b                	je     3cf <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     3b4:	c7 44 24 04 9c 15 00 	movl   $0x159c,0x4(%esp)
     3bb:	00 
     3bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3c3:	e8 21 0d 00 00       	call   10e9 <printf>
        return;
     3c8:	eb 23                	jmp    3ed <exitwait+0x7c>
      }
    } else {
      exit();
     3ca:	e8 7a 0b 00 00       	call   f49 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     3cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3d3:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     3d7:	7e a7                	jle    380 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     3d9:	c7 44 24 04 ac 15 00 	movl   $0x15ac,0x4(%esp)
     3e0:	00 
     3e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3e8:	e8 fc 0c 00 00       	call   10e9 <printf>
}
     3ed:	c9                   	leave  
     3ee:	c3                   	ret    

000003ef <mem>:

void
mem(void)
{
     3ef:	55                   	push   %ebp
     3f0:	89 e5                	mov    %esp,%ebp
     3f2:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     3f5:	c7 44 24 04 b9 15 00 	movl   $0x15b9,0x4(%esp)
     3fc:	00 
     3fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     404:	e8 e0 0c 00 00       	call   10e9 <printf>
  ppid = getpid();
     409:	e8 bb 0b 00 00       	call   fc9 <getpid>
     40e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     411:	e8 2b 0b 00 00       	call   f41 <fork>
     416:	89 45 ec             	mov    %eax,-0x14(%ebp)
     419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     41d:	0f 85 aa 00 00 00    	jne    4cd <mem+0xde>
    m1 = 0;
     423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     42a:	eb 0e                	jmp    43a <mem+0x4b>
      *(char**)m2 = m1;
     42c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     42f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     432:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     434:	8b 45 e8             	mov    -0x18(%ebp),%eax
     437:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     43a:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     441:	e8 8f 0f 00 00       	call   13d5 <malloc>
     446:	89 45 e8             	mov    %eax,-0x18(%ebp)
     449:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     44d:	75 dd                	jne    42c <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     44f:	eb 19                	jmp    46a <mem+0x7b>
      m2 = *(char**)m1;
     451:	8b 45 f4             	mov    -0xc(%ebp),%eax
     454:	8b 00                	mov    (%eax),%eax
     456:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     459:	8b 45 f4             	mov    -0xc(%ebp),%eax
     45c:	89 04 24             	mov    %eax,(%esp)
     45f:	e8 38 0e 00 00       	call   129c <free>
      m1 = m2;
     464:	8b 45 e8             	mov    -0x18(%ebp),%eax
     467:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     46a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     46e:	75 e1                	jne    451 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     470:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     477:	e8 59 0f 00 00       	call   13d5 <malloc>
     47c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     47f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     483:	75 24                	jne    4a9 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     485:	c7 44 24 04 c3 15 00 	movl   $0x15c3,0x4(%esp)
     48c:	00 
     48d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     494:	e8 50 0c 00 00       	call   10e9 <printf>
      kill(ppid);
     499:	8b 45 f0             	mov    -0x10(%ebp),%eax
     49c:	89 04 24             	mov    %eax,(%esp)
     49f:	e8 d5 0a 00 00       	call   f79 <kill>
      exit();
     4a4:	e8 a0 0a 00 00       	call   f49 <exit>
    }
    free(m1);
     4a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ac:	89 04 24             	mov    %eax,(%esp)
     4af:	e8 e8 0d 00 00       	call   129c <free>
    printf(1, "mem ok\n");
     4b4:	c7 44 24 04 dd 15 00 	movl   $0x15dd,0x4(%esp)
     4bb:	00 
     4bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4c3:	e8 21 0c 00 00       	call   10e9 <printf>
    exit();
     4c8:	e8 7c 0a 00 00       	call   f49 <exit>
  } else {
    wait();
     4cd:	e8 7f 0a 00 00       	call   f51 <wait>
  }
}
     4d2:	c9                   	leave  
     4d3:	c3                   	ret    

000004d4 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
     4d4:	55                   	push   %ebp
     4d5:	89 e5                	mov    %esp,%ebp
     4d7:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
     4da:	c7 44 24 04 e5 15 00 	movl   $0x15e5,0x4(%esp)
     4e1:	00 
     4e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4e9:	e8 fb 0b 00 00       	call   10e9 <printf>

  for(n=0; n<1000; n++){
     4ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4f5:	eb 1f                	jmp    516 <forktest+0x42>
    pid = fork();
     4f7:	e8 45 0a 00 00       	call   f41 <fork>
     4fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
     4ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     503:	79 02                	jns    507 <forktest+0x33>
      break;
     505:	eb 18                	jmp    51f <forktest+0x4b>
    if(pid == 0)
     507:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     50b:	75 05                	jne    512 <forktest+0x3e>
      exit();
     50d:	e8 37 0a 00 00       	call   f49 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
     512:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     516:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     51d:	7e d8                	jle    4f7 <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }

  if(n == 1000){
     51f:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
     526:	75 19                	jne    541 <forktest+0x6d>
    printf(1, "fork claimed to work 1000 times!\n");
     528:	c7 44 24 04 f0 15 00 	movl   $0x15f0,0x4(%esp)
     52f:	00 
     530:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     537:	e8 ad 0b 00 00       	call   10e9 <printf>
    exit();
     53c:	e8 08 0a 00 00       	call   f49 <exit>
  }

  for(; n > 0; n--){
     541:	eb 26                	jmp    569 <forktest+0x95>
    if(wait() < 0){
     543:	e8 09 0a 00 00       	call   f51 <wait>
     548:	85 c0                	test   %eax,%eax
     54a:	79 19                	jns    565 <forktest+0x91>
      printf(1, "wait stopped early\n");
     54c:	c7 44 24 04 12 16 00 	movl   $0x1612,0x4(%esp)
     553:	00 
     554:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     55b:	e8 89 0b 00 00       	call   10e9 <printf>
      exit();
     560:	e8 e4 09 00 00       	call   f49 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
     565:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     56d:	7f d4                	jg     543 <forktest+0x6f>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
     56f:	e8 dd 09 00 00       	call   f51 <wait>
     574:	83 f8 ff             	cmp    $0xffffffff,%eax
     577:	74 19                	je     592 <forktest+0xbe>
    printf(1, "wait got too many\n");
     579:	c7 44 24 04 26 16 00 	movl   $0x1626,0x4(%esp)
     580:	00 
     581:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     588:	e8 5c 0b 00 00       	call   10e9 <printf>
    exit();
     58d:	e8 b7 09 00 00       	call   f49 <exit>
  }

  printf(1, "fork test OK\n");
     592:	c7 44 24 04 39 16 00 	movl   $0x1639,0x4(%esp)
     599:	00 
     59a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5a1:	e8 43 0b 00 00       	call   10e9 <printf>
}
     5a6:	c9                   	leave  
     5a7:	c3                   	ret    

000005a8 <sbrktest>:

void
sbrktest(void)
{
     5a8:	55                   	push   %ebp
     5a9:	89 e5                	mov    %esp,%ebp
     5ab:	53                   	push   %ebx
     5ac:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
     5b2:	a1 50 1c 00 00       	mov    0x1c50,%eax
     5b7:	c7 44 24 04 47 16 00 	movl   $0x1647,0x4(%esp)
     5be:	00 
     5bf:	89 04 24             	mov    %eax,(%esp)
     5c2:	e8 22 0b 00 00       	call   10e9 <printf>
  oldbrk = sbrk(0);
     5c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5ce:	e8 fe 09 00 00       	call   fd1 <sbrk>
     5d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
     5d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5dd:	e8 ef 09 00 00       	call   fd1 <sbrk>
     5e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
     5e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     5ec:	eb 59                	jmp    647 <sbrktest+0x9f>
    b = sbrk(1);
     5ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5f5:	e8 d7 09 00 00       	call   fd1 <sbrk>
     5fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
     5fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     600:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     603:	74 2f                	je     634 <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
     605:	a1 50 1c 00 00       	mov    0x1c50,%eax
     60a:	8b 55 e8             	mov    -0x18(%ebp),%edx
     60d:	89 54 24 10          	mov    %edx,0x10(%esp)
     611:	8b 55 f4             	mov    -0xc(%ebp),%edx
     614:	89 54 24 0c          	mov    %edx,0xc(%esp)
     618:	8b 55 f0             	mov    -0x10(%ebp),%edx
     61b:	89 54 24 08          	mov    %edx,0x8(%esp)
     61f:	c7 44 24 04 52 16 00 	movl   $0x1652,0x4(%esp)
     626:	00 
     627:	89 04 24             	mov    %eax,(%esp)
     62a:	e8 ba 0a 00 00       	call   10e9 <printf>
      exit();
     62f:	e8 15 09 00 00       	call   f49 <exit>
    }
    *b = 1;
     634:	8b 45 e8             	mov    -0x18(%ebp),%eax
     637:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
     63a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     63d:	83 c0 01             	add    $0x1,%eax
     640:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){
     643:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     647:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
     64e:	7e 9e                	jle    5ee <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
     650:	e8 ec 08 00 00       	call   f41 <fork>
     655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
     658:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     65c:	79 1a                	jns    678 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
     65e:	a1 50 1c 00 00       	mov    0x1c50,%eax
     663:	c7 44 24 04 6d 16 00 	movl   $0x166d,0x4(%esp)
     66a:	00 
     66b:	89 04 24             	mov    %eax,(%esp)
     66e:	e8 76 0a 00 00       	call   10e9 <printf>
    exit();
     673:	e8 d1 08 00 00       	call   f49 <exit>
  }
  c = sbrk(1);
     678:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     67f:	e8 4d 09 00 00       	call   fd1 <sbrk>
     684:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
     687:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     68e:	e8 3e 09 00 00       	call   fd1 <sbrk>
     693:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
     696:	8b 45 f4             	mov    -0xc(%ebp),%eax
     699:	83 c0 01             	add    $0x1,%eax
     69c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     69f:	74 1a                	je     6bb <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
     6a1:	a1 50 1c 00 00       	mov    0x1c50,%eax
     6a6:	c7 44 24 04 84 16 00 	movl   $0x1684,0x4(%esp)
     6ad:	00 
     6ae:	89 04 24             	mov    %eax,(%esp)
     6b1:	e8 33 0a 00 00       	call   10e9 <printf>
    exit();
     6b6:	e8 8e 08 00 00       	call   f49 <exit>
  }
  if(pid == 0)
     6bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     6bf:	75 05                	jne    6c6 <sbrktest+0x11e>
    exit();
     6c1:	e8 83 08 00 00       	call   f49 <exit>
  wait();
     6c6:	e8 86 08 00 00       	call   f51 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
     6cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6d2:	e8 fa 08 00 00       	call   fd1 <sbrk>
     6d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
     6da:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6dd:	ba 00 00 40 06       	mov    $0x6400000,%edx
     6e2:	29 c2                	sub    %eax,%edx
     6e4:	89 d0                	mov    %edx,%eax
     6e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
     6e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
     6ec:	89 04 24             	mov    %eax,(%esp)
     6ef:	e8 dd 08 00 00       	call   fd1 <sbrk>
     6f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) {
     6f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     6fd:	74 1a                	je     719 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
     6ff:	a1 50 1c 00 00       	mov    0x1c50,%eax
     704:	c7 44 24 04 a0 16 00 	movl   $0x16a0,0x4(%esp)
     70b:	00 
     70c:	89 04 24             	mov    %eax,(%esp)
     70f:	e8 d5 09 00 00       	call   10e9 <printf>
    exit();
     714:	e8 30 08 00 00       	call   f49 <exit>
  }
  lastaddr = (char*) (BIG-1);
     719:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
     720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     723:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
     726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     72d:	e8 9f 08 00 00       	call   fd1 <sbrk>
     732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
     735:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
     73c:	e8 90 08 00 00       	call   fd1 <sbrk>
     741:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
     744:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
     748:	75 1a                	jne    764 <sbrktest+0x1bc>
    printf(stdout, "sbrk could not deallocate\n");
     74a:	a1 50 1c 00 00       	mov    0x1c50,%eax
     74f:	c7 44 24 04 de 16 00 	movl   $0x16de,0x4(%esp)
     756:	00 
     757:	89 04 24             	mov    %eax,(%esp)
     75a:	e8 8a 09 00 00       	call   10e9 <printf>
    exit();
     75f:	e8 e5 07 00 00       	call   f49 <exit>
  }
  c = sbrk(0);
     764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     76b:	e8 61 08 00 00       	call   fd1 <sbrk>
     770:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
     773:	8b 45 f4             	mov    -0xc(%ebp),%eax
     776:	2d 00 10 00 00       	sub    $0x1000,%eax
     77b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     77e:	74 28                	je     7a8 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
     780:	a1 50 1c 00 00       	mov    0x1c50,%eax
     785:	8b 55 e0             	mov    -0x20(%ebp),%edx
     788:	89 54 24 0c          	mov    %edx,0xc(%esp)
     78c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     78f:	89 54 24 08          	mov    %edx,0x8(%esp)
     793:	c7 44 24 04 fc 16 00 	movl   $0x16fc,0x4(%esp)
     79a:	00 
     79b:	89 04 24             	mov    %eax,(%esp)
     79e:	e8 46 09 00 00       	call   10e9 <printf>
    exit();
     7a3:	e8 a1 07 00 00       	call   f49 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
     7a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     7af:	e8 1d 08 00 00       	call   fd1 <sbrk>
     7b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
     7b7:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     7be:	e8 0e 08 00 00       	call   fd1 <sbrk>
     7c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
     7c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     7cc:	75 19                	jne    7e7 <sbrktest+0x23f>
     7ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     7d5:	e8 f7 07 00 00       	call   fd1 <sbrk>
     7da:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7dd:	81 c2 00 10 00 00    	add    $0x1000,%edx
     7e3:	39 d0                	cmp    %edx,%eax
     7e5:	74 28                	je     80f <sbrktest+0x267>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
     7e7:	a1 50 1c 00 00       	mov    0x1c50,%eax
     7ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
     7ef:	89 54 24 0c          	mov    %edx,0xc(%esp)
     7f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7f6:	89 54 24 08          	mov    %edx,0x8(%esp)
     7fa:	c7 44 24 04 34 17 00 	movl   $0x1734,0x4(%esp)
     801:	00 
     802:	89 04 24             	mov    %eax,(%esp)
     805:	e8 df 08 00 00       	call   10e9 <printf>
    exit();
     80a:	e8 3a 07 00 00       	call   f49 <exit>
  }
  if(*lastaddr == 99){
     80f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     812:	0f b6 00             	movzbl (%eax),%eax
     815:	3c 63                	cmp    $0x63,%al
     817:	75 1a                	jne    833 <sbrktest+0x28b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
     819:	a1 50 1c 00 00       	mov    0x1c50,%eax
     81e:	c7 44 24 04 5c 17 00 	movl   $0x175c,0x4(%esp)
     825:	00 
     826:	89 04 24             	mov    %eax,(%esp)
     829:	e8 bb 08 00 00       	call   10e9 <printf>
    exit();
     82e:	e8 16 07 00 00       	call   f49 <exit>
  }

  a = sbrk(0);
     833:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     83a:	e8 92 07 00 00       	call   fd1 <sbrk>
     83f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
     842:	8b 5d ec             	mov    -0x14(%ebp),%ebx
     845:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     84c:	e8 80 07 00 00       	call   fd1 <sbrk>
     851:	29 c3                	sub    %eax,%ebx
     853:	89 d8                	mov    %ebx,%eax
     855:	89 04 24             	mov    %eax,(%esp)
     858:	e8 74 07 00 00       	call   fd1 <sbrk>
     85d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
     860:	8b 45 e0             	mov    -0x20(%ebp),%eax
     863:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     866:	74 28                	je     890 <sbrktest+0x2e8>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
     868:	a1 50 1c 00 00       	mov    0x1c50,%eax
     86d:	8b 55 e0             	mov    -0x20(%ebp),%edx
     870:	89 54 24 0c          	mov    %edx,0xc(%esp)
     874:	8b 55 f4             	mov    -0xc(%ebp),%edx
     877:	89 54 24 08          	mov    %edx,0x8(%esp)
     87b:	c7 44 24 04 8c 17 00 	movl   $0x178c,0x4(%esp)
     882:	00 
     883:	89 04 24             	mov    %eax,(%esp)
     886:	e8 5e 08 00 00       	call   10e9 <printf>
    exit();
     88b:	e8 b9 06 00 00       	call   f49 <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     890:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
     897:	eb 7b                	jmp    914 <sbrktest+0x36c>
    ppid = getpid();
     899:	e8 2b 07 00 00       	call   fc9 <getpid>
     89e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
     8a1:	e8 9b 06 00 00       	call   f41 <fork>
     8a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
     8a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     8ad:	79 1a                	jns    8c9 <sbrktest+0x321>
      printf(stdout, "fork failed\n");
     8af:	a1 50 1c 00 00       	mov    0x1c50,%eax
     8b4:	c7 44 24 04 8f 15 00 	movl   $0x158f,0x4(%esp)
     8bb:	00 
     8bc:	89 04 24             	mov    %eax,(%esp)
     8bf:	e8 25 08 00 00       	call   10e9 <printf>
      exit();
     8c4:	e8 80 06 00 00       	call   f49 <exit>
    }
    if(pid == 0){
     8c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     8cd:	75 39                	jne    908 <sbrktest+0x360>
      printf(stdout, "oops could read %x = %x\n", a, *a);
     8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d2:	0f b6 00             	movzbl (%eax),%eax
     8d5:	0f be d0             	movsbl %al,%edx
     8d8:	a1 50 1c 00 00       	mov    0x1c50,%eax
     8dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
     8e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8e4:	89 54 24 08          	mov    %edx,0x8(%esp)
     8e8:	c7 44 24 04 ad 17 00 	movl   $0x17ad,0x4(%esp)
     8ef:	00 
     8f0:	89 04 24             	mov    %eax,(%esp)
     8f3:	e8 f1 07 00 00       	call   10e9 <printf>
      kill(ppid);
     8f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 76 06 00 00       	call   f79 <kill>
      exit();
     903:	e8 41 06 00 00       	call   f49 <exit>
    }
    wait();
     908:	e8 44 06 00 00       	call   f51 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     90d:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
     914:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
     91b:	0f 86 78 ff ff ff    	jbe    899 <sbrktest+0x2f1>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
     921:	8d 45 c8             	lea    -0x38(%ebp),%eax
     924:	89 04 24             	mov    %eax,(%esp)
     927:	e8 2d 06 00 00       	call   f59 <pipe>
     92c:	85 c0                	test   %eax,%eax
     92e:	74 19                	je     949 <sbrktest+0x3a1>
    printf(1, "pipe() failed\n");
     930:	c7 44 24 04 ce 14 00 	movl   $0x14ce,0x4(%esp)
     937:	00 
     938:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     93f:	e8 a5 07 00 00       	call   10e9 <printf>
    exit();
     944:	e8 00 06 00 00       	call   f49 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
     949:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     950:	e9 87 00 00 00       	jmp    9dc <sbrktest+0x434>
    if((pids[i] = fork()) == 0){
     955:	e8 e7 05 00 00       	call   f41 <fork>
     95a:	8b 55 f0             	mov    -0x10(%ebp),%edx
     95d:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
     961:	8b 45 f0             	mov    -0x10(%ebp),%eax
     964:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
     968:	85 c0                	test   %eax,%eax
     96a:	75 46                	jne    9b2 <sbrktest+0x40a>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
     96c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     973:	e8 59 06 00 00       	call   fd1 <sbrk>
     978:	ba 00 00 40 06       	mov    $0x6400000,%edx
     97d:	29 c2                	sub    %eax,%edx
     97f:	89 d0                	mov    %edx,%eax
     981:	89 04 24             	mov    %eax,(%esp)
     984:	e8 48 06 00 00       	call   fd1 <sbrk>
      write(fds[1], "x", 1);
     989:	8b 45 cc             	mov    -0x34(%ebp),%eax
     98c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     993:	00 
     994:	c7 44 24 04 33 15 00 	movl   $0x1533,0x4(%esp)
     99b:	00 
     99c:	89 04 24             	mov    %eax,(%esp)
     99f:	e8 c5 05 00 00       	call   f69 <write>
      // sit around until killed
      for(;;) sleep(1000);
     9a4:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     9ab:	e8 29 06 00 00       	call   fd9 <sleep>
     9b0:	eb f2                	jmp    9a4 <sbrktest+0x3fc>
    }
    if(pids[i] != -1)
     9b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b5:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
     9b9:	83 f8 ff             	cmp    $0xffffffff,%eax
     9bc:	74 1a                	je     9d8 <sbrktest+0x430>
      read(fds[0], &scratch, 1);
     9be:	8b 45 c8             	mov    -0x38(%ebp),%eax
     9c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     9c8:	00 
     9c9:	8d 55 9f             	lea    -0x61(%ebp),%edx
     9cc:	89 54 24 04          	mov    %edx,0x4(%esp)
     9d0:	89 04 24             	mov    %eax,(%esp)
     9d3:	e8 89 05 00 00       	call   f61 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
     9d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9df:	83 f8 09             	cmp    $0x9,%eax
     9e2:	0f 86 6d ff ff ff    	jbe    955 <sbrktest+0x3ad>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
     9e8:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     9ef:	e8 dd 05 00 00       	call   fd1 <sbrk>
     9f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
     9f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9fe:	eb 26                	jmp    a26 <sbrktest+0x47e>
    if(pids[i] == -1)
     a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a03:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
     a07:	83 f8 ff             	cmp    $0xffffffff,%eax
     a0a:	75 02                	jne    a0e <sbrktest+0x466>
      continue;
     a0c:	eb 14                	jmp    a22 <sbrktest+0x47a>
    kill(pids[i]);
     a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a11:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
     a15:	89 04 24             	mov    %eax,(%esp)
     a18:	e8 5c 05 00 00       	call   f79 <kill>
    wait();
     a1d:	e8 2f 05 00 00       	call   f51 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
     a22:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a29:	83 f8 09             	cmp    $0x9,%eax
     a2c:	76 d2                	jbe    a00 <sbrktest+0x458>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
     a2e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
     a32:	75 1a                	jne    a4e <sbrktest+0x4a6>
    printf(stdout, "failed sbrk leaked memory\n");
     a34:	a1 50 1c 00 00       	mov    0x1c50,%eax
     a39:	c7 44 24 04 c6 17 00 	movl   $0x17c6,0x4(%esp)
     a40:	00 
     a41:	89 04 24             	mov    %eax,(%esp)
     a44:	e8 a0 06 00 00       	call   10e9 <printf>
    exit();
     a49:	e8 fb 04 00 00       	call   f49 <exit>
  }

  if(sbrk(0) > oldbrk)
     a4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a55:	e8 77 05 00 00       	call   fd1 <sbrk>
     a5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     a5d:	76 1b                	jbe    a7a <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
     a5f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
     a62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a69:	e8 63 05 00 00       	call   fd1 <sbrk>
     a6e:	29 c3                	sub    %eax,%ebx
     a70:	89 d8                	mov    %ebx,%eax
     a72:	89 04 24             	mov    %eax,(%esp)
     a75:	e8 57 05 00 00       	call   fd1 <sbrk>

  printf(stdout, "sbrk test OK\n");
     a7a:	a1 50 1c 00 00       	mov    0x1c50,%eax
     a7f:	c7 44 24 04 e1 17 00 	movl   $0x17e1,0x4(%esp)
     a86:	00 
     a87:	89 04 24             	mov    %eax,(%esp)
     a8a:	e8 5a 06 00 00       	call   10e9 <printf>
}
     a8f:	81 c4 84 00 00 00    	add    $0x84,%esp
     a95:	5b                   	pop    %ebx
     a96:	5d                   	pop    %ebp
     a97:	c3                   	ret    

00000a98 <validateint>:

void
validateint(int *p)
{
     a98:	55                   	push   %ebp
     a99:	89 e5                	mov    %esp,%ebp
     a9b:	53                   	push   %ebx
     a9c:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
     a9f:	b8 0d 00 00 00       	mov    $0xd,%eax
     aa4:	8b 55 08             	mov    0x8(%ebp),%edx
     aa7:	89 d1                	mov    %edx,%ecx
     aa9:	89 e3                	mov    %esp,%ebx
     aab:	89 cc                	mov    %ecx,%esp
     aad:	cd 40                	int    $0x40
     aaf:	89 dc                	mov    %ebx,%esp
     ab1:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
     ab4:	83 c4 10             	add    $0x10,%esp
     ab7:	5b                   	pop    %ebx
     ab8:	5d                   	pop    %ebp
     ab9:	c3                   	ret    

00000aba <validatetest>:

void
validatetest(void)
{
     aba:	55                   	push   %ebp
     abb:	89 e5                	mov    %esp,%ebp
     abd:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
     ac0:	a1 50 1c 00 00       	mov    0x1c50,%eax
     ac5:	c7 44 24 04 ef 17 00 	movl   $0x17ef,0x4(%esp)
     acc:	00 
     acd:	89 04 24             	mov    %eax,(%esp)
     ad0:	e8 14 06 00 00       	call   10e9 <printf>
  hi = 1100*1024;
     ad5:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
     adc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ae3:	eb 7f                	jmp    b64 <validatetest+0xaa>
    if((pid = fork()) == 0){
     ae5:	e8 57 04 00 00       	call   f41 <fork>
     aea:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     af1:	75 10                	jne    b03 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
     af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af6:	89 04 24             	mov    %eax,(%esp)
     af9:	e8 9a ff ff ff       	call   a98 <validateint>
      exit();
     afe:	e8 46 04 00 00       	call   f49 <exit>
    }
    sleep(0);
     b03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b0a:	e8 ca 04 00 00       	call   fd9 <sleep>
    sleep(0);
     b0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b16:	e8 be 04 00 00       	call   fd9 <sleep>
    kill(pid);
     b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b1e:	89 04 24             	mov    %eax,(%esp)
     b21:	e8 53 04 00 00       	call   f79 <kill>
    wait();
     b26:	e8 26 04 00 00       	call   f51 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
     b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
     b32:	c7 04 24 fe 17 00 00 	movl   $0x17fe,(%esp)
     b39:	e8 6b 04 00 00       	call   fa9 <link>
     b3e:	83 f8 ff             	cmp    $0xffffffff,%eax
     b41:	74 1a                	je     b5d <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
     b43:	a1 50 1c 00 00       	mov    0x1c50,%eax
     b48:	c7 44 24 04 09 18 00 	movl   $0x1809,0x4(%esp)
     b4f:	00 
     b50:	89 04 24             	mov    %eax,(%esp)
     b53:	e8 91 05 00 00       	call   10e9 <printf>
      exit();
     b58:	e8 ec 03 00 00       	call   f49 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
     b5d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
     b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b67:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     b6a:	0f 83 75 ff ff ff    	jae    ae5 <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
     b70:	a1 50 1c 00 00       	mov    0x1c50,%eax
     b75:	c7 44 24 04 22 18 00 	movl   $0x1822,0x4(%esp)
     b7c:	00 
     b7d:	89 04 24             	mov    %eax,(%esp)
     b80:	e8 64 05 00 00       	call   10e9 <printf>
}
     b85:	c9                   	leave  
     b86:	c3                   	ret    

00000b87 <rand>:


unsigned long randstate = 1;
unsigned int
rand()
{
     b87:	55                   	push   %ebp
     b88:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
     b8a:	a1 54 1c 00 00       	mov    0x1c54,%eax
     b8f:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
     b95:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
     b9a:	a3 54 1c 00 00       	mov    %eax,0x1c54
  return randstate;
     b9f:	a1 54 1c 00 00       	mov    0x1c54,%eax
}
     ba4:	5d                   	pop    %ebp
     ba5:	c3                   	ret    

00000ba6 <exectest>:

void
exectest(void)
{
     ba6:	55                   	push   %ebp
     ba7:	89 e5                	mov    %esp,%ebp
     ba9:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     bac:	a1 50 1c 00 00       	mov    0x1c50,%eax
     bb1:	c7 44 24 04 2f 18 00 	movl   $0x182f,0x4(%esp)
     bb8:	00 
     bb9:	89 04 24             	mov    %eax,(%esp)
     bbc:	e8 28 05 00 00       	call   10e9 <printf>
  if(exec("echo", echoargv) < 0){
     bc1:	c7 44 24 04 3c 1c 00 	movl   $0x1c3c,0x4(%esp)
     bc8:	00 
     bc9:	c7 04 24 b8 14 00 00 	movl   $0x14b8,(%esp)
     bd0:	e8 ac 03 00 00       	call   f81 <exec>
     bd5:	85 c0                	test   %eax,%eax
     bd7:	79 1a                	jns    bf3 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     bd9:	a1 50 1c 00 00       	mov    0x1c50,%eax
     bde:	c7 44 24 04 3a 18 00 	movl   $0x183a,0x4(%esp)
     be5:	00 
     be6:	89 04 24             	mov    %eax,(%esp)
     be9:	e8 fb 04 00 00       	call   10e9 <printf>
    exit();
     bee:	e8 56 03 00 00       	call   f49 <exit>
  }
}
     bf3:	c9                   	leave  
     bf4:	c3                   	ret    

00000bf5 <main>:


int
main(int argc, char *argv[])
{
     bf5:	55                   	push   %ebp
     bf6:	89 e5                	mov    %esp,%ebp
     bf8:	83 e4 f0             	and    $0xfffffff0,%esp
     bfb:	83 ec 20             	sub    $0x20,%esp
  int  i;
  printf(1, "synctests starting\n");
     bfe:	c7 44 24 04 4c 18 00 	movl   $0x184c,0x4(%esp)
     c05:	00 
     c06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c0d:	e8 d7 04 00 00       	call   10e9 <printf>

//  sbrktest();

  for (i = 0; i < 5 ; i++)
     c12:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     c19:	00 
     c1a:	eb 0a                	jmp    c26 <main+0x31>
    validatetest();
     c1c:	e8 99 fe ff ff       	call   aba <validatetest>
  int  i;
  printf(1, "synctests starting\n");

//  sbrktest();

  for (i = 0; i < 5 ; i++)
     c21:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     c26:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
     c2b:	7e ef                	jle    c1c <main+0x27>
    validatetest();
  printf(1, "validate test ok \n");
     c2d:	c7 44 24 04 60 18 00 	movl   $0x1860,0x4(%esp)
     c34:	00 
     c35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c3c:	e8 a8 04 00 00       	call   10e9 <printf>

  //mem();
  for (i = 0; i < 5 ; i++)
     c41:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     c48:	00 
     c49:	eb 0a                	jmp    c55 <main+0x60>
    pipe1();
     c4b:	e8 b0 f3 ff ff       	call   0 <pipe1>
  for (i = 0; i < 5 ; i++)
    validatetest();
  printf(1, "validate test ok \n");

  //mem();
  for (i = 0; i < 5 ; i++)
     c50:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     c55:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
     c5a:	7e ef                	jle    c4b <main+0x56>
    pipe1();

  printf(1, "preempt - if it's stuck here we have deadlock.\n");
     c5c:	c7 44 24 04 74 18 00 	movl   $0x1874,0x4(%esp)
     c63:	00 
     c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c6b:	e8 79 04 00 00       	call   10e9 <printf>
  for (i = 0; i < 40 ; i++)
     c70:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     c77:	00 
     c78:	eb 0a                	jmp    c84 <main+0x8f>
    preempt();
     c7a:	e8 6e f5 ff ff       	call   1ed <preempt>
  //mem();
  for (i = 0; i < 5 ; i++)
    pipe1();

  printf(1, "preempt - if it's stuck here we have deadlock.\n");
  for (i = 0; i < 40 ; i++)
     c7f:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     c84:	83 7c 24 1c 27       	cmpl   $0x27,0x1c(%esp)
     c89:	7e ef                	jle    c7a <main+0x85>
    preempt();

  for (i = 0; i < 5 ; i++)
     c8b:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     c92:	00 
     c93:	eb 0a                	jmp    c9f <main+0xaa>
    exitwait();
     c95:	e8 d7 f6 ff ff       	call   371 <exitwait>

  printf(1, "preempt - if it's stuck here we have deadlock.\n");
  for (i = 0; i < 40 ; i++)
    preempt();

  for (i = 0; i < 5 ; i++)
     c9a:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     c9f:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
     ca4:	7e ef                	jle    c95 <main+0xa0>
    exitwait();

  for (i = 0; i < 5 ; i++)
     ca6:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     cad:	00 
     cae:	eb 0a                	jmp    cba <main+0xc5>
    forktest();
     cb0:	e8 1f f8 ff ff       	call   4d4 <forktest>
    preempt();

  for (i = 0; i < 5 ; i++)
    exitwait();

  for (i = 0; i < 5 ; i++)
     cb5:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     cba:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
     cbf:	7e ef                	jle    cb0 <main+0xbb>
    forktest();

  for (i = 0; i < 5 ; i++)
     cc1:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     cc8:	00 
     cc9:	eb 0a                	jmp    cd5 <main+0xe0>
    exectest();
     ccb:	e8 d6 fe ff ff       	call   ba6 <exectest>
    exitwait();

  for (i = 0; i < 5 ; i++)
    forktest();

  for (i = 0; i < 5 ; i++)
     cd0:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
     cd5:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
     cda:	7e ef                	jle    ccb <main+0xd6>
    exectest();

  exit();
     cdc:	e8 68 02 00 00       	call   f49 <exit>

00000ce1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ce1:	55                   	push   %ebp
     ce2:	89 e5                	mov    %esp,%ebp
     ce4:	57                   	push   %edi
     ce5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     ce6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ce9:	8b 55 10             	mov    0x10(%ebp),%edx
     cec:	8b 45 0c             	mov    0xc(%ebp),%eax
     cef:	89 cb                	mov    %ecx,%ebx
     cf1:	89 df                	mov    %ebx,%edi
     cf3:	89 d1                	mov    %edx,%ecx
     cf5:	fc                   	cld    
     cf6:	f3 aa                	rep stos %al,%es:(%edi)
     cf8:	89 ca                	mov    %ecx,%edx
     cfa:	89 fb                	mov    %edi,%ebx
     cfc:	89 5d 08             	mov    %ebx,0x8(%ebp)
     cff:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d02:	5b                   	pop    %ebx
     d03:	5f                   	pop    %edi
     d04:	5d                   	pop    %ebp
     d05:	c3                   	ret    

00000d06 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d06:	55                   	push   %ebp
     d07:	89 e5                	mov    %esp,%ebp
     d09:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d0c:	8b 45 08             	mov    0x8(%ebp),%eax
     d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d12:	90                   	nop
     d13:	8b 45 08             	mov    0x8(%ebp),%eax
     d16:	8d 50 01             	lea    0x1(%eax),%edx
     d19:	89 55 08             	mov    %edx,0x8(%ebp)
     d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
     d1f:	8d 4a 01             	lea    0x1(%edx),%ecx
     d22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     d25:	0f b6 12             	movzbl (%edx),%edx
     d28:	88 10                	mov    %dl,(%eax)
     d2a:	0f b6 00             	movzbl (%eax),%eax
     d2d:	84 c0                	test   %al,%al
     d2f:	75 e2                	jne    d13 <strcpy+0xd>
    ;
  return os;
     d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d34:	c9                   	leave  
     d35:	c3                   	ret    

00000d36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d36:	55                   	push   %ebp
     d37:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d39:	eb 08                	jmp    d43 <strcmp+0xd>
    p++, q++;
     d3b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d3f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d43:	8b 45 08             	mov    0x8(%ebp),%eax
     d46:	0f b6 00             	movzbl (%eax),%eax
     d49:	84 c0                	test   %al,%al
     d4b:	74 10                	je     d5d <strcmp+0x27>
     d4d:	8b 45 08             	mov    0x8(%ebp),%eax
     d50:	0f b6 10             	movzbl (%eax),%edx
     d53:	8b 45 0c             	mov    0xc(%ebp),%eax
     d56:	0f b6 00             	movzbl (%eax),%eax
     d59:	38 c2                	cmp    %al,%dl
     d5b:	74 de                	je     d3b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d5d:	8b 45 08             	mov    0x8(%ebp),%eax
     d60:	0f b6 00             	movzbl (%eax),%eax
     d63:	0f b6 d0             	movzbl %al,%edx
     d66:	8b 45 0c             	mov    0xc(%ebp),%eax
     d69:	0f b6 00             	movzbl (%eax),%eax
     d6c:	0f b6 c0             	movzbl %al,%eax
     d6f:	29 c2                	sub    %eax,%edx
     d71:	89 d0                	mov    %edx,%eax
}
     d73:	5d                   	pop    %ebp
     d74:	c3                   	ret    

00000d75 <strlen>:

uint
strlen(char *s)
{
     d75:	55                   	push   %ebp
     d76:	89 e5                	mov    %esp,%ebp
     d78:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d82:	eb 04                	jmp    d88 <strlen+0x13>
     d84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d88:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d8b:	8b 45 08             	mov    0x8(%ebp),%eax
     d8e:	01 d0                	add    %edx,%eax
     d90:	0f b6 00             	movzbl (%eax),%eax
     d93:	84 c0                	test   %al,%al
     d95:	75 ed                	jne    d84 <strlen+0xf>
    ;
  return n;
     d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d9a:	c9                   	leave  
     d9b:	c3                   	ret    

00000d9c <memset>:

void*
memset(void *dst, int c, uint n)
{
     d9c:	55                   	push   %ebp
     d9d:	89 e5                	mov    %esp,%ebp
     d9f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     da2:	8b 45 10             	mov    0x10(%ebp),%eax
     da5:	89 44 24 08          	mov    %eax,0x8(%esp)
     da9:	8b 45 0c             	mov    0xc(%ebp),%eax
     dac:	89 44 24 04          	mov    %eax,0x4(%esp)
     db0:	8b 45 08             	mov    0x8(%ebp),%eax
     db3:	89 04 24             	mov    %eax,(%esp)
     db6:	e8 26 ff ff ff       	call   ce1 <stosb>
  return dst;
     dbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dbe:	c9                   	leave  
     dbf:	c3                   	ret    

00000dc0 <strchr>:

char*
strchr(const char *s, char c)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	83 ec 04             	sub    $0x4,%esp
     dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     dcc:	eb 14                	jmp    de2 <strchr+0x22>
    if(*s == c)
     dce:	8b 45 08             	mov    0x8(%ebp),%eax
     dd1:	0f b6 00             	movzbl (%eax),%eax
     dd4:	3a 45 fc             	cmp    -0x4(%ebp),%al
     dd7:	75 05                	jne    dde <strchr+0x1e>
      return (char*)s;
     dd9:	8b 45 08             	mov    0x8(%ebp),%eax
     ddc:	eb 13                	jmp    df1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     dde:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     de2:	8b 45 08             	mov    0x8(%ebp),%eax
     de5:	0f b6 00             	movzbl (%eax),%eax
     de8:	84 c0                	test   %al,%al
     dea:	75 e2                	jne    dce <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
     df1:	c9                   	leave  
     df2:	c3                   	ret    

00000df3 <gets>:

char*
gets(char *buf, int max)
{
     df3:	55                   	push   %ebp
     df4:	89 e5                	mov    %esp,%ebp
     df6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     df9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e00:	eb 4c                	jmp    e4e <gets+0x5b>
    cc = read(0, &c, 1);
     e02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e09:	00 
     e0a:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
     e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e18:	e8 44 01 00 00       	call   f61 <read>
     e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e24:	7f 02                	jg     e28 <gets+0x35>
      break;
     e26:	eb 31                	jmp    e59 <gets+0x66>
    buf[i++] = c;
     e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e2b:	8d 50 01             	lea    0x1(%eax),%edx
     e2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e31:	89 c2                	mov    %eax,%edx
     e33:	8b 45 08             	mov    0x8(%ebp),%eax
     e36:	01 c2                	add    %eax,%edx
     e38:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e3c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e3e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e42:	3c 0a                	cmp    $0xa,%al
     e44:	74 13                	je     e59 <gets+0x66>
     e46:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e4a:	3c 0d                	cmp    $0xd,%al
     e4c:	74 0b                	je     e59 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e51:	83 c0 01             	add    $0x1,%eax
     e54:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e57:	7c a9                	jl     e02 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e5c:	8b 45 08             	mov    0x8(%ebp),%eax
     e5f:	01 d0                	add    %edx,%eax
     e61:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e67:	c9                   	leave  
     e68:	c3                   	ret    

00000e69 <stat>:

int
stat(char *n, struct stat *st)
{
     e69:	55                   	push   %ebp
     e6a:	89 e5                	mov    %esp,%ebp
     e6c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e76:	00 
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	89 04 24             	mov    %eax,(%esp)
     e7d:	e8 07 01 00 00       	call   f89 <open>
     e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e89:	79 07                	jns    e92 <stat+0x29>
    return -1;
     e8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e90:	eb 23                	jmp    eb5 <stat+0x4c>
  r = fstat(fd, st);
     e92:	8b 45 0c             	mov    0xc(%ebp),%eax
     e95:	89 44 24 04          	mov    %eax,0x4(%esp)
     e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e9c:	89 04 24             	mov    %eax,(%esp)
     e9f:	e8 fd 00 00 00       	call   fa1 <fstat>
     ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eaa:	89 04 24             	mov    %eax,(%esp)
     ead:	e8 bf 00 00 00       	call   f71 <close>
  return r;
     eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     eb5:	c9                   	leave  
     eb6:	c3                   	ret    

00000eb7 <atoi>:

int
atoi(const char *s)
{
     eb7:	55                   	push   %ebp
     eb8:	89 e5                	mov    %esp,%ebp
     eba:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ebd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ec4:	eb 25                	jmp    eeb <atoi+0x34>
    n = n*10 + *s++ - '0';
     ec6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ec9:	89 d0                	mov    %edx,%eax
     ecb:	c1 e0 02             	shl    $0x2,%eax
     ece:	01 d0                	add    %edx,%eax
     ed0:	01 c0                	add    %eax,%eax
     ed2:	89 c1                	mov    %eax,%ecx
     ed4:	8b 45 08             	mov    0x8(%ebp),%eax
     ed7:	8d 50 01             	lea    0x1(%eax),%edx
     eda:	89 55 08             	mov    %edx,0x8(%ebp)
     edd:	0f b6 00             	movzbl (%eax),%eax
     ee0:	0f be c0             	movsbl %al,%eax
     ee3:	01 c8                	add    %ecx,%eax
     ee5:	83 e8 30             	sub    $0x30,%eax
     ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     eeb:	8b 45 08             	mov    0x8(%ebp),%eax
     eee:	0f b6 00             	movzbl (%eax),%eax
     ef1:	3c 2f                	cmp    $0x2f,%al
     ef3:	7e 0a                	jle    eff <atoi+0x48>
     ef5:	8b 45 08             	mov    0x8(%ebp),%eax
     ef8:	0f b6 00             	movzbl (%eax),%eax
     efb:	3c 39                	cmp    $0x39,%al
     efd:	7e c7                	jle    ec6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f02:	c9                   	leave  
     f03:	c3                   	ret    

00000f04 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f04:	55                   	push   %ebp
     f05:	89 e5                	mov    %esp,%ebp
     f07:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f0a:	8b 45 08             	mov    0x8(%ebp),%eax
     f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f10:	8b 45 0c             	mov    0xc(%ebp),%eax
     f13:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f16:	eb 17                	jmp    f2f <memmove+0x2b>
    *dst++ = *src++;
     f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f1b:	8d 50 01             	lea    0x1(%eax),%edx
     f1e:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f21:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f24:	8d 4a 01             	lea    0x1(%edx),%ecx
     f27:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f2a:	0f b6 12             	movzbl (%edx),%edx
     f2d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f2f:	8b 45 10             	mov    0x10(%ebp),%eax
     f32:	8d 50 ff             	lea    -0x1(%eax),%edx
     f35:	89 55 10             	mov    %edx,0x10(%ebp)
     f38:	85 c0                	test   %eax,%eax
     f3a:	7f dc                	jg     f18 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f3f:	c9                   	leave  
     f40:	c3                   	ret    

00000f41 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f41:	b8 01 00 00 00       	mov    $0x1,%eax
     f46:	cd 40                	int    $0x40
     f48:	c3                   	ret    

00000f49 <exit>:
SYSCALL(exit)
     f49:	b8 02 00 00 00       	mov    $0x2,%eax
     f4e:	cd 40                	int    $0x40
     f50:	c3                   	ret    

00000f51 <wait>:
SYSCALL(wait)
     f51:	b8 03 00 00 00       	mov    $0x3,%eax
     f56:	cd 40                	int    $0x40
     f58:	c3                   	ret    

00000f59 <pipe>:
SYSCALL(pipe)
     f59:	b8 04 00 00 00       	mov    $0x4,%eax
     f5e:	cd 40                	int    $0x40
     f60:	c3                   	ret    

00000f61 <read>:
SYSCALL(read)
     f61:	b8 05 00 00 00       	mov    $0x5,%eax
     f66:	cd 40                	int    $0x40
     f68:	c3                   	ret    

00000f69 <write>:
SYSCALL(write)
     f69:	b8 10 00 00 00       	mov    $0x10,%eax
     f6e:	cd 40                	int    $0x40
     f70:	c3                   	ret    

00000f71 <close>:
SYSCALL(close)
     f71:	b8 15 00 00 00       	mov    $0x15,%eax
     f76:	cd 40                	int    $0x40
     f78:	c3                   	ret    

00000f79 <kill>:
SYSCALL(kill)
     f79:	b8 06 00 00 00       	mov    $0x6,%eax
     f7e:	cd 40                	int    $0x40
     f80:	c3                   	ret    

00000f81 <exec>:
SYSCALL(exec)
     f81:	b8 07 00 00 00       	mov    $0x7,%eax
     f86:	cd 40                	int    $0x40
     f88:	c3                   	ret    

00000f89 <open>:
SYSCALL(open)
     f89:	b8 0f 00 00 00       	mov    $0xf,%eax
     f8e:	cd 40                	int    $0x40
     f90:	c3                   	ret    

00000f91 <mknod>:
SYSCALL(mknod)
     f91:	b8 11 00 00 00       	mov    $0x11,%eax
     f96:	cd 40                	int    $0x40
     f98:	c3                   	ret    

00000f99 <unlink>:
SYSCALL(unlink)
     f99:	b8 12 00 00 00       	mov    $0x12,%eax
     f9e:	cd 40                	int    $0x40
     fa0:	c3                   	ret    

00000fa1 <fstat>:
SYSCALL(fstat)
     fa1:	b8 08 00 00 00       	mov    $0x8,%eax
     fa6:	cd 40                	int    $0x40
     fa8:	c3                   	ret    

00000fa9 <link>:
SYSCALL(link)
     fa9:	b8 13 00 00 00       	mov    $0x13,%eax
     fae:	cd 40                	int    $0x40
     fb0:	c3                   	ret    

00000fb1 <mkdir>:
SYSCALL(mkdir)
     fb1:	b8 14 00 00 00       	mov    $0x14,%eax
     fb6:	cd 40                	int    $0x40
     fb8:	c3                   	ret    

00000fb9 <chdir>:
SYSCALL(chdir)
     fb9:	b8 09 00 00 00       	mov    $0x9,%eax
     fbe:	cd 40                	int    $0x40
     fc0:	c3                   	ret    

00000fc1 <dup>:
SYSCALL(dup)
     fc1:	b8 0a 00 00 00       	mov    $0xa,%eax
     fc6:	cd 40                	int    $0x40
     fc8:	c3                   	ret    

00000fc9 <getpid>:
SYSCALL(getpid)
     fc9:	b8 0b 00 00 00       	mov    $0xb,%eax
     fce:	cd 40                	int    $0x40
     fd0:	c3                   	ret    

00000fd1 <sbrk>:
SYSCALL(sbrk)
     fd1:	b8 0c 00 00 00       	mov    $0xc,%eax
     fd6:	cd 40                	int    $0x40
     fd8:	c3                   	ret    

00000fd9 <sleep>:
SYSCALL(sleep)
     fd9:	b8 0d 00 00 00       	mov    $0xd,%eax
     fde:	cd 40                	int    $0x40
     fe0:	c3                   	ret    

00000fe1 <uptime>:
SYSCALL(uptime)
     fe1:	b8 0e 00 00 00       	mov    $0xe,%eax
     fe6:	cd 40                	int    $0x40
     fe8:	c3                   	ret    

00000fe9 <sigset>:
SYSCALL(sigset)
     fe9:	b8 16 00 00 00       	mov    $0x16,%eax
     fee:	cd 40                	int    $0x40
     ff0:	c3                   	ret    

00000ff1 <sigsend>:
SYSCALL(sigsend)
     ff1:	b8 17 00 00 00       	mov    $0x17,%eax
     ff6:	cd 40                	int    $0x40
     ff8:	c3                   	ret    

00000ff9 <sigret>:
SYSCALL(sigret)
     ff9:	b8 18 00 00 00       	mov    $0x18,%eax
     ffe:	cd 40                	int    $0x40
    1000:	c3                   	ret    

00001001 <sigpause>:
SYSCALL(sigpause)
    1001:	b8 19 00 00 00       	mov    $0x19,%eax
    1006:	cd 40                	int    $0x40
    1008:	c3                   	ret    

00001009 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1009:	55                   	push   %ebp
    100a:	89 e5                	mov    %esp,%ebp
    100c:	83 ec 18             	sub    $0x18,%esp
    100f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1012:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1015:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    101c:	00 
    101d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1020:	89 44 24 04          	mov    %eax,0x4(%esp)
    1024:	8b 45 08             	mov    0x8(%ebp),%eax
    1027:	89 04 24             	mov    %eax,(%esp)
    102a:	e8 3a ff ff ff       	call   f69 <write>
}
    102f:	c9                   	leave  
    1030:	c3                   	ret    

00001031 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1031:	55                   	push   %ebp
    1032:	89 e5                	mov    %esp,%ebp
    1034:	56                   	push   %esi
    1035:	53                   	push   %ebx
    1036:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1039:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1040:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1044:	74 17                	je     105d <printint+0x2c>
    1046:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    104a:	79 11                	jns    105d <printint+0x2c>
    neg = 1;
    104c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1053:	8b 45 0c             	mov    0xc(%ebp),%eax
    1056:	f7 d8                	neg    %eax
    1058:	89 45 ec             	mov    %eax,-0x14(%ebp)
    105b:	eb 06                	jmp    1063 <printint+0x32>
  } else {
    x = xx;
    105d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1060:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1063:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    106a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    106d:	8d 41 01             	lea    0x1(%ecx),%eax
    1070:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1073:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1076:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1079:	ba 00 00 00 00       	mov    $0x0,%edx
    107e:	f7 f3                	div    %ebx
    1080:	89 d0                	mov    %edx,%eax
    1082:	0f b6 80 58 1c 00 00 	movzbl 0x1c58(%eax),%eax
    1089:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    108d:	8b 75 10             	mov    0x10(%ebp),%esi
    1090:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1093:	ba 00 00 00 00       	mov    $0x0,%edx
    1098:	f7 f6                	div    %esi
    109a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    109d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10a1:	75 c7                	jne    106a <printint+0x39>
  if(neg)
    10a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10a7:	74 10                	je     10b9 <printint+0x88>
    buf[i++] = '-';
    10a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10ac:	8d 50 01             	lea    0x1(%eax),%edx
    10af:	89 55 f4             	mov    %edx,-0xc(%ebp)
    10b2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    10b7:	eb 1f                	jmp    10d8 <printint+0xa7>
    10b9:	eb 1d                	jmp    10d8 <printint+0xa7>
    putc(fd, buf[i]);
    10bb:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10c1:	01 d0                	add    %edx,%eax
    10c3:	0f b6 00             	movzbl (%eax),%eax
    10c6:	0f be c0             	movsbl %al,%eax
    10c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	89 04 24             	mov    %eax,(%esp)
    10d3:	e8 31 ff ff ff       	call   1009 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    10d8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10e0:	79 d9                	jns    10bb <printint+0x8a>
    putc(fd, buf[i]);
}
    10e2:	83 c4 30             	add    $0x30,%esp
    10e5:	5b                   	pop    %ebx
    10e6:	5e                   	pop    %esi
    10e7:	5d                   	pop    %ebp
    10e8:	c3                   	ret    

000010e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10e9:	55                   	push   %ebp
    10ea:	89 e5                	mov    %esp,%ebp
    10ec:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10f6:	8d 45 0c             	lea    0xc(%ebp),%eax
    10f9:	83 c0 04             	add    $0x4,%eax
    10fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1106:	e9 7c 01 00 00       	jmp    1287 <printf+0x19e>
    c = fmt[i] & 0xff;
    110b:	8b 55 0c             	mov    0xc(%ebp),%edx
    110e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1111:	01 d0                	add    %edx,%eax
    1113:	0f b6 00             	movzbl (%eax),%eax
    1116:	0f be c0             	movsbl %al,%eax
    1119:	25 ff 00 00 00       	and    $0xff,%eax
    111e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1121:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1125:	75 2c                	jne    1153 <printf+0x6a>
      if(c == '%'){
    1127:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    112b:	75 0c                	jne    1139 <printf+0x50>
        state = '%';
    112d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1134:	e9 4a 01 00 00       	jmp    1283 <printf+0x19a>
      } else {
        putc(fd, c);
    1139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    113c:	0f be c0             	movsbl %al,%eax
    113f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1143:	8b 45 08             	mov    0x8(%ebp),%eax
    1146:	89 04 24             	mov    %eax,(%esp)
    1149:	e8 bb fe ff ff       	call   1009 <putc>
    114e:	e9 30 01 00 00       	jmp    1283 <printf+0x19a>
      }
    } else if(state == '%'){
    1153:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1157:	0f 85 26 01 00 00    	jne    1283 <printf+0x19a>
      if(c == 'd'){
    115d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1161:	75 2d                	jne    1190 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1163:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1166:	8b 00                	mov    (%eax),%eax
    1168:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    116f:	00 
    1170:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1177:	00 
    1178:	89 44 24 04          	mov    %eax,0x4(%esp)
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	89 04 24             	mov    %eax,(%esp)
    1182:	e8 aa fe ff ff       	call   1031 <printint>
        ap++;
    1187:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    118b:	e9 ec 00 00 00       	jmp    127c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1190:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1194:	74 06                	je     119c <printf+0xb3>
    1196:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    119a:	75 2d                	jne    11c9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    119c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    119f:	8b 00                	mov    (%eax),%eax
    11a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    11a8:	00 
    11a9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11b0:	00 
    11b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b5:	8b 45 08             	mov    0x8(%ebp),%eax
    11b8:	89 04 24             	mov    %eax,(%esp)
    11bb:	e8 71 fe ff ff       	call   1031 <printint>
        ap++;
    11c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11c4:	e9 b3 00 00 00       	jmp    127c <printf+0x193>
      } else if(c == 's'){
    11c9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    11cd:	75 45                	jne    1214 <printf+0x12b>
        s = (char*)*ap;
    11cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11d2:	8b 00                	mov    (%eax),%eax
    11d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    11d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    11db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11df:	75 09                	jne    11ea <printf+0x101>
          s = "(null)";
    11e1:	c7 45 f4 a4 18 00 00 	movl   $0x18a4,-0xc(%ebp)
        while(*s != 0){
    11e8:	eb 1e                	jmp    1208 <printf+0x11f>
    11ea:	eb 1c                	jmp    1208 <printf+0x11f>
          putc(fd, *s);
    11ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ef:	0f b6 00             	movzbl (%eax),%eax
    11f2:	0f be c0             	movsbl %al,%eax
    11f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f9:	8b 45 08             	mov    0x8(%ebp),%eax
    11fc:	89 04 24             	mov    %eax,(%esp)
    11ff:	e8 05 fe ff ff       	call   1009 <putc>
          s++;
    1204:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1208:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120b:	0f b6 00             	movzbl (%eax),%eax
    120e:	84 c0                	test   %al,%al
    1210:	75 da                	jne    11ec <printf+0x103>
    1212:	eb 68                	jmp    127c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1214:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1218:	75 1d                	jne    1237 <printf+0x14e>
        putc(fd, *ap);
    121a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    121d:	8b 00                	mov    (%eax),%eax
    121f:	0f be c0             	movsbl %al,%eax
    1222:	89 44 24 04          	mov    %eax,0x4(%esp)
    1226:	8b 45 08             	mov    0x8(%ebp),%eax
    1229:	89 04 24             	mov    %eax,(%esp)
    122c:	e8 d8 fd ff ff       	call   1009 <putc>
        ap++;
    1231:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1235:	eb 45                	jmp    127c <printf+0x193>
      } else if(c == '%'){
    1237:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    123b:	75 17                	jne    1254 <printf+0x16b>
        putc(fd, c);
    123d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1240:	0f be c0             	movsbl %al,%eax
    1243:	89 44 24 04          	mov    %eax,0x4(%esp)
    1247:	8b 45 08             	mov    0x8(%ebp),%eax
    124a:	89 04 24             	mov    %eax,(%esp)
    124d:	e8 b7 fd ff ff       	call   1009 <putc>
    1252:	eb 28                	jmp    127c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1254:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    125b:	00 
    125c:	8b 45 08             	mov    0x8(%ebp),%eax
    125f:	89 04 24             	mov    %eax,(%esp)
    1262:	e8 a2 fd ff ff       	call   1009 <putc>
        putc(fd, c);
    1267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    126a:	0f be c0             	movsbl %al,%eax
    126d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1271:	8b 45 08             	mov    0x8(%ebp),%eax
    1274:	89 04 24             	mov    %eax,(%esp)
    1277:	e8 8d fd ff ff       	call   1009 <putc>
      }
      state = 0;
    127c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1283:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1287:	8b 55 0c             	mov    0xc(%ebp),%edx
    128a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    128d:	01 d0                	add    %edx,%eax
    128f:	0f b6 00             	movzbl (%eax),%eax
    1292:	84 c0                	test   %al,%al
    1294:	0f 85 71 fe ff ff    	jne    110b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    129a:	c9                   	leave  
    129b:	c3                   	ret    

0000129c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    129c:	55                   	push   %ebp
    129d:	89 e5                	mov    %esp,%ebp
    129f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12a2:	8b 45 08             	mov    0x8(%ebp),%eax
    12a5:	83 e8 08             	sub    $0x8,%eax
    12a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ab:	a1 88 1c 00 00       	mov    0x1c88,%eax
    12b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12b3:	eb 24                	jmp    12d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b8:	8b 00                	mov    (%eax),%eax
    12ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12bd:	77 12                	ja     12d1 <free+0x35>
    12bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12c5:	77 24                	ja     12eb <free+0x4f>
    12c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ca:	8b 00                	mov    (%eax),%eax
    12cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12cf:	77 1a                	ja     12eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d4:	8b 00                	mov    (%eax),%eax
    12d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12df:	76 d4                	jbe    12b5 <free+0x19>
    12e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e4:	8b 00                	mov    (%eax),%eax
    12e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12e9:	76 ca                	jbe    12b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    12eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ee:	8b 40 04             	mov    0x4(%eax),%eax
    12f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12fb:	01 c2                	add    %eax,%edx
    12fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1300:	8b 00                	mov    (%eax),%eax
    1302:	39 c2                	cmp    %eax,%edx
    1304:	75 24                	jne    132a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1306:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1309:	8b 50 04             	mov    0x4(%eax),%edx
    130c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130f:	8b 00                	mov    (%eax),%eax
    1311:	8b 40 04             	mov    0x4(%eax),%eax
    1314:	01 c2                	add    %eax,%edx
    1316:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1319:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    131c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    131f:	8b 00                	mov    (%eax),%eax
    1321:	8b 10                	mov    (%eax),%edx
    1323:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1326:	89 10                	mov    %edx,(%eax)
    1328:	eb 0a                	jmp    1334 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    132a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    132d:	8b 10                	mov    (%eax),%edx
    132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1332:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1334:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1337:	8b 40 04             	mov    0x4(%eax),%eax
    133a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1341:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1344:	01 d0                	add    %edx,%eax
    1346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1349:	75 20                	jne    136b <free+0xcf>
    p->s.size += bp->s.size;
    134b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134e:	8b 50 04             	mov    0x4(%eax),%edx
    1351:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1354:	8b 40 04             	mov    0x4(%eax),%eax
    1357:	01 c2                	add    %eax,%edx
    1359:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    135f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1362:	8b 10                	mov    (%eax),%edx
    1364:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1367:	89 10                	mov    %edx,(%eax)
    1369:	eb 08                	jmp    1373 <free+0xd7>
  } else
    p->s.ptr = bp;
    136b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1371:	89 10                	mov    %edx,(%eax)
  freep = p;
    1373:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1376:	a3 88 1c 00 00       	mov    %eax,0x1c88
}
    137b:	c9                   	leave  
    137c:	c3                   	ret    

0000137d <morecore>:

static Header*
morecore(uint nu)
{
    137d:	55                   	push   %ebp
    137e:	89 e5                	mov    %esp,%ebp
    1380:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1383:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    138a:	77 07                	ja     1393 <morecore+0x16>
    nu = 4096;
    138c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1393:	8b 45 08             	mov    0x8(%ebp),%eax
    1396:	c1 e0 03             	shl    $0x3,%eax
    1399:	89 04 24             	mov    %eax,(%esp)
    139c:	e8 30 fc ff ff       	call   fd1 <sbrk>
    13a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    13a4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    13a8:	75 07                	jne    13b1 <morecore+0x34>
    return 0;
    13aa:	b8 00 00 00 00       	mov    $0x0,%eax
    13af:	eb 22                	jmp    13d3 <morecore+0x56>
  hp = (Header*)p;
    13b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    13b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ba:	8b 55 08             	mov    0x8(%ebp),%edx
    13bd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13c3:	83 c0 08             	add    $0x8,%eax
    13c6:	89 04 24             	mov    %eax,(%esp)
    13c9:	e8 ce fe ff ff       	call   129c <free>
  return freep;
    13ce:	a1 88 1c 00 00       	mov    0x1c88,%eax
}
    13d3:	c9                   	leave  
    13d4:	c3                   	ret    

000013d5 <malloc>:

void*
malloc(uint nbytes)
{
    13d5:	55                   	push   %ebp
    13d6:	89 e5                	mov    %esp,%ebp
    13d8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13db:	8b 45 08             	mov    0x8(%ebp),%eax
    13de:	83 c0 07             	add    $0x7,%eax
    13e1:	c1 e8 03             	shr    $0x3,%eax
    13e4:	83 c0 01             	add    $0x1,%eax
    13e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    13ea:	a1 88 1c 00 00       	mov    0x1c88,%eax
    13ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13f6:	75 23                	jne    141b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13f8:	c7 45 f0 80 1c 00 00 	movl   $0x1c80,-0x10(%ebp)
    13ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1402:	a3 88 1c 00 00       	mov    %eax,0x1c88
    1407:	a1 88 1c 00 00       	mov    0x1c88,%eax
    140c:	a3 80 1c 00 00       	mov    %eax,0x1c80
    base.s.size = 0;
    1411:	c7 05 84 1c 00 00 00 	movl   $0x0,0x1c84
    1418:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    141b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    141e:	8b 00                	mov    (%eax),%eax
    1420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1423:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1426:	8b 40 04             	mov    0x4(%eax),%eax
    1429:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    142c:	72 4d                	jb     147b <malloc+0xa6>
      if(p->s.size == nunits)
    142e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1431:	8b 40 04             	mov    0x4(%eax),%eax
    1434:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1437:	75 0c                	jne    1445 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1439:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143c:	8b 10                	mov    (%eax),%edx
    143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1441:	89 10                	mov    %edx,(%eax)
    1443:	eb 26                	jmp    146b <malloc+0x96>
      else {
        p->s.size -= nunits;
    1445:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1448:	8b 40 04             	mov    0x4(%eax),%eax
    144b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    144e:	89 c2                	mov    %eax,%edx
    1450:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1453:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1456:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1459:	8b 40 04             	mov    0x4(%eax),%eax
    145c:	c1 e0 03             	shl    $0x3,%eax
    145f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1462:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1465:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1468:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    146b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    146e:	a3 88 1c 00 00       	mov    %eax,0x1c88
      return (void*)(p + 1);
    1473:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1476:	83 c0 08             	add    $0x8,%eax
    1479:	eb 38                	jmp    14b3 <malloc+0xde>
    }
    if(p == freep)
    147b:	a1 88 1c 00 00       	mov    0x1c88,%eax
    1480:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1483:	75 1b                	jne    14a0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1485:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1488:	89 04 24             	mov    %eax,(%esp)
    148b:	e8 ed fe ff ff       	call   137d <morecore>
    1490:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1497:	75 07                	jne    14a0 <malloc+0xcb>
        return 0;
    1499:	b8 00 00 00 00       	mov    $0x0,%eax
    149e:	eb 13                	jmp    14b3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a9:	8b 00                	mov    (%eax),%eax
    14ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14ae:	e9 70 ff ff ff       	jmp    1423 <malloc+0x4e>
}
    14b3:	c9                   	leave  
    14b4:	c3                   	ret    
