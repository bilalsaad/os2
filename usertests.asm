
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 40 64 00 00       	mov    0x6440,%eax
       b:	c7 44 24 04 6e 45 00 	movl   $0x456e,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 71 41 00 00       	call   418c <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 79 45 00 00 	movl   $0x4579,(%esp)
      22:	e8 2d 40 00 00       	call   4054 <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 40 64 00 00       	mov    0x6440,%eax
      30:	c7 44 24 04 81 45 00 	movl   $0x4581,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 4c 41 00 00       	call   418c <printf>
    exit();
      40:	e8 a7 3f 00 00       	call   3fec <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 79 45 00 00 	movl   $0x4579,(%esp)
      4c:	e8 0b 40 00 00       	call   405c <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 40 64 00 00       	mov    0x6440,%eax
      5a:	c7 44 24 04 8f 45 00 	movl   $0x458f,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 22 41 00 00       	call   418c <printf>
    exit();
      6a:	e8 7d 3f 00 00       	call   3fec <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 a5 45 00 00 	movl   $0x45a5,(%esp)
      76:	e8 c1 3f 00 00       	call   403c <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 40 64 00 00       	mov    0x6440,%eax
      84:	c7 44 24 04 b0 45 00 	movl   $0x45b0,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f8 40 00 00       	call   418c <printf>
    exit();
      94:	e8 53 3f 00 00       	call   3fec <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 ca 45 00 00 	movl   $0x45ca,(%esp)
      a0:	e8 b7 3f 00 00       	call   405c <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 40 64 00 00       	mov    0x6440,%eax
      ae:	c7 44 24 04 cc 45 00 	movl   $0x45cc,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 ce 40 00 00       	call   418c <printf>
    exit();
      be:	e8 29 3f 00 00       	call   3fec <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 40 64 00 00       	mov    0x6440,%eax
      c8:	c7 44 24 04 dc 45 00 	movl   $0x45dc,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 b4 40 00 00       	call   418c <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 40 64 00 00       	mov    0x6440,%eax
      e5:	c7 44 24 04 ea 45 00 	movl   $0x45ea,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 97 40 00 00       	call   418c <printf>

  pid = fork();
      f5:	e8 ea 3e 00 00       	call   3fe4 <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 40 64 00 00       	mov    0x6440,%eax
     108:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 74 40 00 00       	call   418c <printf>
    exit();
     118:	e8 cf 3e 00 00       	call   3fec <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 79 45 00 00 	movl   $0x4579,(%esp)
     12e:	e8 21 3f 00 00       	call   4054 <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 40 64 00 00       	mov    0x6440,%eax
     13c:	c7 44 24 04 81 45 00 	movl   $0x4581,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 40 40 00 00       	call   418c <printf>
      exit();
     14c:	e8 9b 3e 00 00       	call   3fec <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 79 45 00 00 	movl   $0x4579,(%esp)
     158:	e8 ff 3e 00 00       	call   405c <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 40 64 00 00       	mov    0x6440,%eax
     166:	c7 44 24 04 06 46 00 	movl   $0x4606,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 16 40 00 00       	call   418c <printf>
      exit();
     176:	e8 71 3e 00 00       	call   3fec <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 a5 45 00 00 	movl   $0x45a5,(%esp)
     182:	e8 b5 3e 00 00       	call   403c <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 40 64 00 00       	mov    0x6440,%eax
     190:	c7 44 24 04 b0 45 00 	movl   $0x45b0,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 ec 3f 00 00       	call   418c <printf>
      exit();
     1a0:	e8 47 3e 00 00       	call   3fec <exit>
    }
    exit();
     1a5:	e8 42 3e 00 00       	call   3fec <exit>
  }
  wait();
     1aa:	e8 45 3e 00 00       	call   3ff4 <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 40 64 00 00       	mov    0x6440,%eax
     1b4:	c7 44 24 04 1a 46 00 	movl   $0x461a,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 c8 3f 00 00       	call   418c <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 40 64 00 00       	mov    0x6440,%eax
     1d1:	c7 44 24 04 2c 46 00 	movl   $0x462c,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 ab 3f 00 00       	call   418c <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 3b 46 00 00 	movl   $0x463b,(%esp)
     1e8:	e8 67 3e 00 00       	call   4054 <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 40 64 00 00       	mov    0x6440,%eax
     1f6:	c7 44 24 04 41 46 00 	movl   $0x4641,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 86 3f 00 00       	call   418c <printf>
    exit();
     206:	e8 e1 3d 00 00       	call   3fec <exit>
  }
  pid = fork();
     20b:	e8 d4 3d 00 00       	call   3fe4 <fork>
     210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 40 64 00 00       	mov    0x6440,%eax
     21e:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 5e 3f 00 00       	call   418c <printf>
    exit();
     22e:	e8 b9 3d 00 00       	call   3fec <exit>
  }
  if(pid == 0){
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 3b 46 00 00 	movl   $0x463b,(%esp)
     248:	e8 df 3d 00 00       	call   402c <open>
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 40 64 00 00       	mov    0x6440,%eax
     25b:	c7 44 24 04 58 46 00 	movl   $0x4658,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 21 3f 00 00       	call   418c <printf>
      exit();
     26b:	e8 7c 3d 00 00       	call   3fec <exit>
    }
    exit();
     270:	e8 77 3d 00 00       	call   3fec <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 fb 3d 00 00       	call   407c <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 3b 46 00 00 	movl   $0x463b,(%esp)
     288:	e8 af 3d 00 00       	call   403c <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 40 64 00 00       	mov    0x6440,%eax
     296:	c7 44 24 04 7c 46 00 	movl   $0x467c,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 e6 3e 00 00       	call   418c <printf>
    exit();
     2a6:	e8 41 3d 00 00       	call   3fec <exit>
  }
  wait();
     2ab:	e8 44 3d 00 00       	call   3ff4 <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 40 64 00 00       	mov    0x6440,%eax
     2b5:	c7 44 24 04 8b 46 00 	movl   $0x468b,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 c7 3e 00 00       	call   418c <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 40 64 00 00       	mov    0x6440,%eax
     2d2:	c7 44 24 04 9d 46 00 	movl   $0x469d,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 aa 3e 00 00       	call   418c <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 58 45 00 00 	movl   $0x4558,(%esp)
     2f1:	e8 36 3d 00 00       	call   402c <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 40 64 00 00       	mov    0x6440,%eax
     304:	c7 44 24 04 a8 46 00 	movl   $0x46a8,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 78 3e 00 00       	call   418c <printf>
    exit();
     314:	e8 d3 3c 00 00       	call   3fec <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 f0 3c 00 00       	call   4014 <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 bb 46 00 00 	movl   $0x46bb,(%esp)
     333:	e8 f4 3c 00 00       	call   402c <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 40 64 00 00       	mov    0x6440,%eax
     346:	c7 44 24 04 c8 46 00 	movl   $0x46c8,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 36 3e 00 00       	call   418c <printf>
    exit();
     356:	e8 91 3c 00 00       	call   3fec <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 40 64 00 00       	mov    0x6440,%eax
     360:	c7 44 24 04 e6 46 00 	movl   $0x46e6,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 1c 3e 00 00       	call   418c <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 40 64 00 00       	mov    0x6440,%eax
     37d:	c7 44 24 04 f4 46 00 	movl   $0x46f4,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 ff 3d 00 00       	call   418c <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 05 47 00 00 	movl   $0x4705,(%esp)
     39c:	e8 8b 3c 00 00       	call   402c <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 40 64 00 00       	mov    0x6440,%eax
     3af:	c7 44 24 04 0b 47 00 	movl   $0x470b,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 cd 3d 00 00       	call   418c <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 a0 00 00 00       	jmp    46b <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 40 64 00 00       	mov    0x6440,%eax
     3d0:	c7 44 24 04 26 47 00 	movl   $0x4726,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 ac 3d 00 00       	call   418c <printf>
    exit();
     3e0:	e8 07 3c 00 00       	call   3fec <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 42 47 00 	movl   $0x4742,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 0c 3c 00 00       	call   400c <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 40 64 00 00       	mov    0x6440,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 50 47 00 	movl   $0x4750,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 6b 3d 00 00       	call   418c <printf>
      exit();
     421:	e8 c6 3b 00 00       	call   3fec <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 74 47 00 	movl   $0x4774,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 cb 3b 00 00       	call   400c <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 40 64 00 00       	mov    0x6440,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 80 47 00 	movl   $0x4780,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 2a 3d 00 00       	call   418c <printf>
      exit();
     462:	e8 85 3b 00 00       	call   3fec <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     46b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46f:	0f 8e 70 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     475:	a1 40 64 00 00       	mov    0x6440,%eax
     47a:	c7 44 24 04 a4 47 00 	movl   $0x47a4,0x4(%esp)
     481:	00 
     482:	89 04 24             	mov    %eax,(%esp)
     485:	e8 02 3d 00 00       	call   418c <printf>
  close(fd);
     48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 7f 3b 00 00       	call   4014 <close>
  fd = open("small", O_RDONLY);
     495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49c:	00 
     49d:	c7 04 24 05 47 00 00 	movl   $0x4705,(%esp)
     4a4:	e8 83 3b 00 00       	call   402c <open>
     4a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4b0:	78 3e                	js     4f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     4b2:	a1 40 64 00 00       	mov    0x6440,%eax
     4b7:	c7 44 24 04 af 47 00 	movl   $0x47af,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 c5 3c 00 00       	call   418c <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4ce:	00 
     4cf:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
     4d6:	00 
     4d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4da:	89 04 24             	mov    %eax,(%esp)
     4dd:	e8 22 3b 00 00       	call   4004 <read>
     4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4ec:	75 4e                	jne    53c <writetest+0x1ca>
     4ee:	eb 1a                	jmp    50a <writetest+0x198>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4f0:	a1 40 64 00 00       	mov    0x6440,%eax
     4f5:	c7 44 24 04 c8 47 00 	movl   $0x47c8,0x4(%esp)
     4fc:	00 
     4fd:	89 04 24             	mov    %eax,(%esp)
     500:	e8 87 3c 00 00       	call   418c <printf>
    exit();
     505:	e8 e2 3a 00 00       	call   3fec <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     50a:	a1 40 64 00 00       	mov    0x6440,%eax
     50f:	c7 44 24 04 e3 47 00 	movl   $0x47e3,0x4(%esp)
     516:	00 
     517:	89 04 24             	mov    %eax,(%esp)
     51a:	e8 6d 3c 00 00       	call   418c <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     522:	89 04 24             	mov    %eax,(%esp)
     525:	e8 ea 3a 00 00       	call   4014 <close>

  if(unlink("small") < 0){
     52a:	c7 04 24 05 47 00 00 	movl   $0x4705,(%esp)
     531:	e8 06 3b 00 00       	call   403c <unlink>
     536:	85 c0                	test   %eax,%eax
     538:	79 36                	jns    570 <writetest+0x1fe>
     53a:	eb 1a                	jmp    556 <writetest+0x1e4>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53c:	a1 40 64 00 00       	mov    0x6440,%eax
     541:	c7 44 24 04 f6 47 00 	movl   $0x47f6,0x4(%esp)
     548:	00 
     549:	89 04 24             	mov    %eax,(%esp)
     54c:	e8 3b 3c 00 00       	call   418c <printf>
    exit();
     551:	e8 96 3a 00 00       	call   3fec <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     556:	a1 40 64 00 00       	mov    0x6440,%eax
     55b:	c7 44 24 04 03 48 00 	movl   $0x4803,0x4(%esp)
     562:	00 
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 21 3c 00 00       	call   418c <printf>
    exit();
     56b:	e8 7c 3a 00 00       	call   3fec <exit>
  }
  printf(stdout, "small file test ok\n");
     570:	a1 40 64 00 00       	mov    0x6440,%eax
     575:	c7 44 24 04 18 48 00 	movl   $0x4818,0x4(%esp)
     57c:	00 
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 07 3c 00 00       	call   418c <printf>
}
     585:	c9                   	leave  
     586:	c3                   	ret    

00000587 <writetest1>:

void
writetest1(void)
{
     587:	55                   	push   %ebp
     588:	89 e5                	mov    %esp,%ebp
     58a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58d:	a1 40 64 00 00       	mov    0x6440,%eax
     592:	c7 44 24 04 2c 48 00 	movl   $0x482c,0x4(%esp)
     599:	00 
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 ea 3b 00 00       	call   418c <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 3c 48 00 00 	movl   $0x483c,(%esp)
     5b1:	e8 76 3a 00 00       	call   402c <open>
     5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5bd:	79 1a                	jns    5d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5bf:	a1 40 64 00 00       	mov    0x6440,%eax
     5c4:	c7 44 24 04 40 48 00 	movl   $0x4840,0x4(%esp)
     5cb:	00 
     5cc:	89 04 24             	mov    %eax,(%esp)
     5cf:	e8 b8 3b 00 00       	call   418c <printf>
    exit();
     5d4:	e8 13 3a 00 00       	call   3fec <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5e0:	eb 51                	jmp    633 <writetest1+0xac>
    ((int*)buf)[0] = i;
     5e2:	b8 20 8c 00 00       	mov    $0x8c20,%eax
     5e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f3:	00 
     5f4:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
     5fb:	00 
     5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 05 3a 00 00       	call   400c <write>
     607:	3d 00 02 00 00       	cmp    $0x200,%eax
     60c:	74 21                	je     62f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60e:	a1 40 64 00 00       	mov    0x6440,%eax
     613:	8b 55 f4             	mov    -0xc(%ebp),%edx
     616:	89 54 24 08          	mov    %edx,0x8(%esp)
     61a:	c7 44 24 04 5a 48 00 	movl   $0x485a,0x4(%esp)
     621:	00 
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 62 3b 00 00       	call   418c <printf>
      exit();
     62a:	e8 bd 39 00 00       	call   3fec <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     63b:	76 a5                	jbe    5e2 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 cc 39 00 00       	call   4014 <close>

  fd = open("big", O_RDONLY);
     648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64f:	00 
     650:	c7 04 24 3c 48 00 00 	movl   $0x483c,(%esp)
     657:	e8 d0 39 00 00       	call   402c <open>
     65c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     663:	79 1a                	jns    67f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     665:	a1 40 64 00 00       	mov    0x6440,%eax
     66a:	c7 44 24 04 78 48 00 	movl   $0x4878,0x4(%esp)
     671:	00 
     672:	89 04 24             	mov    %eax,(%esp)
     675:	e8 12 3b 00 00       	call   418c <printf>
    exit();
     67a:	e8 6d 39 00 00       	call   3fec <exit>
  }

  n = 0;
     67f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68d:	00 
     68e:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
     695:	00 
     696:	8b 45 ec             	mov    -0x14(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 63 39 00 00       	call   4004 <read>
     6a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a8:	75 4c                	jne    6f6 <writetest1+0x16f>
      if(n == MAXFILE - 1){
     6aa:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6b1:	75 21                	jne    6d4 <writetest1+0x14d>
        printf(stdout, "read only %d blocks from big", n);
     6b3:	a1 40 64 00 00       	mov    0x6440,%eax
     6b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     6bb:	89 54 24 08          	mov    %edx,0x8(%esp)
     6bf:	c7 44 24 04 91 48 00 	movl   $0x4891,0x4(%esp)
     6c6:	00 
     6c7:	89 04 24             	mov    %eax,(%esp)
     6ca:	e8 bd 3a 00 00       	call   418c <printf>
        exit();
     6cf:	e8 18 39 00 00       	call   3fec <exit>
      }
      break;
     6d4:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     6d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 34 39 00 00       	call   4014 <close>
  if(unlink("big") < 0){
     6e0:	c7 04 24 3c 48 00 00 	movl   $0x483c,(%esp)
     6e7:	e8 50 39 00 00       	call   403c <unlink>
     6ec:	85 c0                	test   %eax,%eax
     6ee:	0f 89 87 00 00 00    	jns    77b <writetest1+0x1f4>
     6f4:	eb 6b                	jmp    761 <writetest1+0x1da>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     6f6:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     6fd:	74 21                	je     720 <writetest1+0x199>
      printf(stdout, "read failed %d\n", i);
     6ff:	a1 40 64 00 00       	mov    0x6440,%eax
     704:	8b 55 f4             	mov    -0xc(%ebp),%edx
     707:	89 54 24 08          	mov    %edx,0x8(%esp)
     70b:	c7 44 24 04 ae 48 00 	movl   $0x48ae,0x4(%esp)
     712:	00 
     713:	89 04 24             	mov    %eax,(%esp)
     716:	e8 71 3a 00 00       	call   418c <printf>
      exit();
     71b:	e8 cc 38 00 00       	call   3fec <exit>
    }
    if(((int*)buf)[0] != n){
     720:	b8 20 8c 00 00       	mov    $0x8c20,%eax
     725:	8b 00                	mov    (%eax),%eax
     727:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     72a:	74 2c                	je     758 <writetest1+0x1d1>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     72c:	b8 20 8c 00 00       	mov    $0x8c20,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     731:	8b 10                	mov    (%eax),%edx
     733:	a1 40 64 00 00       	mov    0x6440,%eax
     738:	89 54 24 0c          	mov    %edx,0xc(%esp)
     73c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     73f:	89 54 24 08          	mov    %edx,0x8(%esp)
     743:	c7 44 24 04 c0 48 00 	movl   $0x48c0,0x4(%esp)
     74a:	00 
     74b:	89 04 24             	mov    %eax,(%esp)
     74e:	e8 39 3a 00 00       	call   418c <printf>
             n, ((int*)buf)[0]);
      exit();
     753:	e8 94 38 00 00       	call   3fec <exit>
    }
    n++;
     758:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     75c:	e9 25 ff ff ff       	jmp    686 <writetest1+0xff>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     761:	a1 40 64 00 00       	mov    0x6440,%eax
     766:	c7 44 24 04 e0 48 00 	movl   $0x48e0,0x4(%esp)
     76d:	00 
     76e:	89 04 24             	mov    %eax,(%esp)
     771:	e8 16 3a 00 00       	call   418c <printf>
    exit();
     776:	e8 71 38 00 00       	call   3fec <exit>
  }
  printf(stdout, "big files ok\n");
     77b:	a1 40 64 00 00       	mov    0x6440,%eax
     780:	c7 44 24 04 f3 48 00 	movl   $0x48f3,0x4(%esp)
     787:	00 
     788:	89 04 24             	mov    %eax,(%esp)
     78b:	e8 fc 39 00 00       	call   418c <printf>
}
     790:	c9                   	leave  
     791:	c3                   	ret    

00000792 <createtest>:

void
createtest(void)
{
     792:	55                   	push   %ebp
     793:	89 e5                	mov    %esp,%ebp
     795:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     798:	a1 40 64 00 00       	mov    0x6440,%eax
     79d:	c7 44 24 04 04 49 00 	movl   $0x4904,0x4(%esp)
     7a4:	00 
     7a5:	89 04 24             	mov    %eax,(%esp)
     7a8:	e8 df 39 00 00       	call   418c <printf>

  name[0] = 'a';
     7ad:	c6 05 20 ac 00 00 61 	movb   $0x61,0xac20
  name[2] = '\0';
     7b4:	c6 05 22 ac 00 00 00 	movb   $0x0,0xac22
  for(i = 0; i < 52; i++){
     7bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7c2:	eb 31                	jmp    7f5 <createtest+0x63>
    name[1] = '0' + i;
     7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c7:	83 c0 30             	add    $0x30,%eax
     7ca:	a2 21 ac 00 00       	mov    %al,0xac21
    fd = open(name, O_CREATE|O_RDWR);
     7cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d6:	00 
     7d7:	c7 04 24 20 ac 00 00 	movl   $0xac20,(%esp)
     7de:	e8 49 38 00 00       	call   402c <open>
     7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e9:	89 04 24             	mov    %eax,(%esp)
     7ec:	e8 23 38 00 00       	call   4014 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7f5:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     7f9:	7e c9                	jle    7c4 <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7fb:	c6 05 20 ac 00 00 61 	movb   $0x61,0xac20
  name[2] = '\0';
     802:	c6 05 22 ac 00 00 00 	movb   $0x0,0xac22
  for(i = 0; i < 52; i++){
     809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     810:	eb 1b                	jmp    82d <createtest+0x9b>
    name[1] = '0' + i;
     812:	8b 45 f4             	mov    -0xc(%ebp),%eax
     815:	83 c0 30             	add    $0x30,%eax
     818:	a2 21 ac 00 00       	mov    %al,0xac21
    unlink(name);
     81d:	c7 04 24 20 ac 00 00 	movl   $0xac20,(%esp)
     824:	e8 13 38 00 00       	call   403c <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     829:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     82d:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     831:	7e df                	jle    812 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     833:	a1 40 64 00 00       	mov    0x6440,%eax
     838:	c7 44 24 04 2c 49 00 	movl   $0x492c,0x4(%esp)
     83f:	00 
     840:	89 04 24             	mov    %eax,(%esp)
     843:	e8 44 39 00 00       	call   418c <printf>
}
     848:	c9                   	leave  
     849:	c3                   	ret    

0000084a <dirtest>:

void dirtest(void)
{
     84a:	55                   	push   %ebp
     84b:	89 e5                	mov    %esp,%ebp
     84d:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     850:	a1 40 64 00 00       	mov    0x6440,%eax
     855:	c7 44 24 04 52 49 00 	movl   $0x4952,0x4(%esp)
     85c:	00 
     85d:	89 04 24             	mov    %eax,(%esp)
     860:	e8 27 39 00 00       	call   418c <printf>

  if(mkdir("dir0") < 0){
     865:	c7 04 24 5e 49 00 00 	movl   $0x495e,(%esp)
     86c:	e8 e3 37 00 00       	call   4054 <mkdir>
     871:	85 c0                	test   %eax,%eax
     873:	79 1a                	jns    88f <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     875:	a1 40 64 00 00       	mov    0x6440,%eax
     87a:	c7 44 24 04 81 45 00 	movl   $0x4581,0x4(%esp)
     881:	00 
     882:	89 04 24             	mov    %eax,(%esp)
     885:	e8 02 39 00 00       	call   418c <printf>
    exit();
     88a:	e8 5d 37 00 00       	call   3fec <exit>
  }

  if(chdir("dir0") < 0){
     88f:	c7 04 24 5e 49 00 00 	movl   $0x495e,(%esp)
     896:	e8 c1 37 00 00       	call   405c <chdir>
     89b:	85 c0                	test   %eax,%eax
     89d:	79 1a                	jns    8b9 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     89f:	a1 40 64 00 00       	mov    0x6440,%eax
     8a4:	c7 44 24 04 63 49 00 	movl   $0x4963,0x4(%esp)
     8ab:	00 
     8ac:	89 04 24             	mov    %eax,(%esp)
     8af:	e8 d8 38 00 00       	call   418c <printf>
    exit();
     8b4:	e8 33 37 00 00       	call   3fec <exit>
  }

  if(chdir("..") < 0){
     8b9:	c7 04 24 76 49 00 00 	movl   $0x4976,(%esp)
     8c0:	e8 97 37 00 00       	call   405c <chdir>
     8c5:	85 c0                	test   %eax,%eax
     8c7:	79 1a                	jns    8e3 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c9:	a1 40 64 00 00       	mov    0x6440,%eax
     8ce:	c7 44 24 04 79 49 00 	movl   $0x4979,0x4(%esp)
     8d5:	00 
     8d6:	89 04 24             	mov    %eax,(%esp)
     8d9:	e8 ae 38 00 00       	call   418c <printf>
    exit();
     8de:	e8 09 37 00 00       	call   3fec <exit>
  }

  if(unlink("dir0") < 0){
     8e3:	c7 04 24 5e 49 00 00 	movl   $0x495e,(%esp)
     8ea:	e8 4d 37 00 00       	call   403c <unlink>
     8ef:	85 c0                	test   %eax,%eax
     8f1:	79 1a                	jns    90d <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8f3:	a1 40 64 00 00       	mov    0x6440,%eax
     8f8:	c7 44 24 04 8a 49 00 	movl   $0x498a,0x4(%esp)
     8ff:	00 
     900:	89 04 24             	mov    %eax,(%esp)
     903:	e8 84 38 00 00       	call   418c <printf>
    exit();
     908:	e8 df 36 00 00       	call   3fec <exit>
  }
  printf(stdout, "mkdir test ok\n");
     90d:	a1 40 64 00 00       	mov    0x6440,%eax
     912:	c7 44 24 04 9e 49 00 	movl   $0x499e,0x4(%esp)
     919:	00 
     91a:	89 04 24             	mov    %eax,(%esp)
     91d:	e8 6a 38 00 00       	call   418c <printf>
}
     922:	c9                   	leave  
     923:	c3                   	ret    

00000924 <exectest>:

void
exectest(void)
{
     924:	55                   	push   %ebp
     925:	89 e5                	mov    %esp,%ebp
     927:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     92a:	a1 40 64 00 00       	mov    0x6440,%eax
     92f:	c7 44 24 04 ad 49 00 	movl   $0x49ad,0x4(%esp)
     936:	00 
     937:	89 04 24             	mov    %eax,(%esp)
     93a:	e8 4d 38 00 00       	call   418c <printf>
  if(exec("echo", echoargv) < 0){
     93f:	c7 44 24 04 2c 64 00 	movl   $0x642c,0x4(%esp)
     946:	00 
     947:	c7 04 24 58 45 00 00 	movl   $0x4558,(%esp)
     94e:	e8 d1 36 00 00       	call   4024 <exec>
     953:	85 c0                	test   %eax,%eax
     955:	79 1a                	jns    971 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     957:	a1 40 64 00 00       	mov    0x6440,%eax
     95c:	c7 44 24 04 b8 49 00 	movl   $0x49b8,0x4(%esp)
     963:	00 
     964:	89 04 24             	mov    %eax,(%esp)
     967:	e8 20 38 00 00       	call   418c <printf>
    exit();
     96c:	e8 7b 36 00 00       	call   3fec <exit>
  }
}
     971:	c9                   	leave  
     972:	c3                   	ret    

00000973 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     973:	55                   	push   %ebp
     974:	89 e5                	mov    %esp,%ebp
     976:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     979:	8d 45 d8             	lea    -0x28(%ebp),%eax
     97c:	89 04 24             	mov    %eax,(%esp)
     97f:	e8 78 36 00 00       	call   3ffc <pipe>
     984:	85 c0                	test   %eax,%eax
     986:	74 19                	je     9a1 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     988:	c7 44 24 04 ca 49 00 	movl   $0x49ca,0x4(%esp)
     98f:	00 
     990:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     997:	e8 f0 37 00 00       	call   418c <printf>
    exit();
     99c:	e8 4b 36 00 00       	call   3fec <exit>
  }
  pid = fork();
     9a1:	e8 3e 36 00 00       	call   3fe4 <fork>
     9a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9b4:	0f 85 88 00 00 00    	jne    a42 <pipe1+0xcf>
    close(fds[0]);
     9ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9bd:	89 04 24             	mov    %eax,(%esp)
     9c0:	e8 4f 36 00 00       	call   4014 <close>
    for(n = 0; n < 5; n++){
     9c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9cc:	eb 69                	jmp    a37 <pipe1+0xc4>
      for(i = 0; i < 1033; i++)
     9ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9d5:	eb 18                	jmp    9ef <pipe1+0x7c>
        buf[i] = seq++;
     9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9da:	8d 50 01             	lea    0x1(%eax),%edx
     9dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9e3:	81 c2 20 8c 00 00    	add    $0x8c20,%edx
     9e9:	88 02                	mov    %al,(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9eb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9ef:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     9f6:	7e df                	jle    9d7 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9fb:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     a02:	00 
     a03:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
     a0a:	00 
     a0b:	89 04 24             	mov    %eax,(%esp)
     a0e:	e8 f9 35 00 00       	call   400c <write>
     a13:	3d 09 04 00 00       	cmp    $0x409,%eax
     a18:	74 19                	je     a33 <pipe1+0xc0>
        printf(1, "pipe1 oops 1\n");
     a1a:	c7 44 24 04 d9 49 00 	movl   $0x49d9,0x4(%esp)
     a21:	00 
     a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a29:	e8 5e 37 00 00       	call   418c <printf>
        exit();
     a2e:	e8 b9 35 00 00       	call   3fec <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a37:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a3b:	7e 91                	jle    9ce <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a3d:	e8 aa 35 00 00       	call   3fec <exit>
  } else if(pid > 0){
     a42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a46:	0f 8e f9 00 00 00    	jle    b45 <pipe1+0x1d2>
    close(fds[1]);
     a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a4f:	89 04 24             	mov    %eax,(%esp)
     a52:	e8 bd 35 00 00       	call   4014 <close>
    total = 0;
     a57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     a5e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a65:	eb 68                	jmp    acf <pipe1+0x15c>
      for(i = 0; i < n; i++){
     a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a6e:	eb 3d                	jmp    aad <pipe1+0x13a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a73:	05 20 8c 00 00       	add    $0x8c20,%eax
     a78:	0f b6 00             	movzbl (%eax),%eax
     a7b:	0f be c8             	movsbl %al,%ecx
     a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a81:	8d 50 01             	lea    0x1(%eax),%edx
     a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a87:	31 c8                	xor    %ecx,%eax
     a89:	0f b6 c0             	movzbl %al,%eax
     a8c:	85 c0                	test   %eax,%eax
     a8e:	74 19                	je     aa9 <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
     a90:	c7 44 24 04 e7 49 00 	movl   $0x49e7,0x4(%esp)
     a97:	00 
     a98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9f:	e8 e8 36 00 00       	call   418c <printf>
     aa4:	e9 b5 00 00 00       	jmp    b5e <pipe1+0x1eb>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aa9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ab3:	7c bb                	jl     a70 <pipe1+0xfd>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab8:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     abb:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ac1:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac6:	76 07                	jbe    acf <pipe1+0x15c>
        cc = sizeof(buf);
     ac8:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
     ad5:	89 54 24 08          	mov    %edx,0x8(%esp)
     ad9:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
     ae0:	00 
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 1b 35 00 00       	call   4004 <read>
     ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     af0:	0f 8f 71 ff ff ff    	jg     a67 <pipe1+0xf4>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     af6:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     afd:	74 20                	je     b1f <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
     aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b02:	89 44 24 08          	mov    %eax,0x8(%esp)
     b06:	c7 44 24 04 f5 49 00 	movl   $0x49f5,0x4(%esp)
     b0d:	00 
     b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b15:	e8 72 36 00 00       	call   418c <printf>
      exit();
     b1a:	e8 cd 34 00 00       	call   3fec <exit>
    }
    close(fds[0]);
     b1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b22:	89 04 24             	mov    %eax,(%esp)
     b25:	e8 ea 34 00 00       	call   4014 <close>
    wait();
     b2a:	e8 c5 34 00 00       	call   3ff4 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b2f:	c7 44 24 04 1b 4a 00 	movl   $0x4a1b,0x4(%esp)
     b36:	00 
     b37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b3e:	e8 49 36 00 00       	call   418c <printf>
     b43:	eb 19                	jmp    b5e <pipe1+0x1eb>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b45:	c7 44 24 04 0c 4a 00 	movl   $0x4a0c,0x4(%esp)
     b4c:	00 
     b4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b54:	e8 33 36 00 00       	call   418c <printf>
    exit();
     b59:	e8 8e 34 00 00       	call   3fec <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b5e:	c9                   	leave  
     b5f:	c3                   	ret    

00000b60 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b66:	c7 44 24 04 25 4a 00 	movl   $0x4a25,0x4(%esp)
     b6d:	00 
     b6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b75:	e8 12 36 00 00       	call   418c <printf>
  pid1 = fork();
     b7a:	e8 65 34 00 00       	call   3fe4 <fork>
     b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b86:	75 02                	jne    b8a <preempt+0x2a>
    for(;;)
      ;
     b88:	eb fe                	jmp    b88 <preempt+0x28>

  pid2 = fork();
     b8a:	e8 55 34 00 00       	call   3fe4 <fork>
     b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b96:	75 02                	jne    b9a <preempt+0x3a>
    for(;;)
      ;
     b98:	eb fe                	jmp    b98 <preempt+0x38>

  pipe(pfds);
     b9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b9d:	89 04 24             	mov    %eax,(%esp)
     ba0:	e8 57 34 00 00       	call   3ffc <pipe>
  pid3 = fork();
     ba5:	e8 3a 34 00 00       	call   3fe4 <fork>
     baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bb1:	75 4c                	jne    bff <preempt+0x9f>
    close(pfds[0]);
     bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bb6:	89 04 24             	mov    %eax,(%esp)
     bb9:	e8 56 34 00 00       	call   4014 <close>
    if(write(pfds[1], "x", 1) != 1)
     bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bc8:	00 
     bc9:	c7 44 24 04 2f 4a 00 	movl   $0x4a2f,0x4(%esp)
     bd0:	00 
     bd1:	89 04 24             	mov    %eax,(%esp)
     bd4:	e8 33 34 00 00       	call   400c <write>
     bd9:	83 f8 01             	cmp    $0x1,%eax
     bdc:	74 14                	je     bf2 <preempt+0x92>
      printf(1, "preempt write error");
     bde:	c7 44 24 04 31 4a 00 	movl   $0x4a31,0x4(%esp)
     be5:	00 
     be6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bed:	e8 9a 35 00 00       	call   418c <printf>
    close(pfds[1]);
     bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf5:	89 04 24             	mov    %eax,(%esp)
     bf8:	e8 17 34 00 00       	call   4014 <close>
    for(;;)
      ;
     bfd:	eb fe                	jmp    bfd <preempt+0x9d>
  }

  close(pfds[1]);
     bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c02:	89 04 24             	mov    %eax,(%esp)
     c05:	e8 0a 34 00 00       	call   4014 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c0d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c14:	00 
     c15:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
     c1c:	00 
     c1d:	89 04 24             	mov    %eax,(%esp)
     c20:	e8 df 33 00 00       	call   4004 <read>
     c25:	83 f8 01             	cmp    $0x1,%eax
     c28:	74 16                	je     c40 <preempt+0xe0>
    printf(1, "preempt read error");
     c2a:	c7 44 24 04 45 4a 00 	movl   $0x4a45,0x4(%esp)
     c31:	00 
     c32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c39:	e8 4e 35 00 00       	call   418c <printf>
     c3e:	eb 77                	jmp    cb7 <preempt+0x157>
    return;
  }
  close(pfds[0]);
     c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c43:	89 04 24             	mov    %eax,(%esp)
     c46:	e8 c9 33 00 00       	call   4014 <close>
  printf(1, "kill... ");
     c4b:	c7 44 24 04 58 4a 00 	movl   $0x4a58,0x4(%esp)
     c52:	00 
     c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c5a:	e8 2d 35 00 00       	call   418c <printf>
  kill(pid1);
     c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c62:	89 04 24             	mov    %eax,(%esp)
     c65:	e8 b2 33 00 00       	call   401c <kill>
  kill(pid2);
     c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6d:	89 04 24             	mov    %eax,(%esp)
     c70:	e8 a7 33 00 00       	call   401c <kill>
  kill(pid3);
     c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c78:	89 04 24             	mov    %eax,(%esp)
     c7b:	e8 9c 33 00 00       	call   401c <kill>
  printf(1, "wait... ");
     c80:	c7 44 24 04 61 4a 00 	movl   $0x4a61,0x4(%esp)
     c87:	00 
     c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8f:	e8 f8 34 00 00       	call   418c <printf>
  wait();
     c94:	e8 5b 33 00 00       	call   3ff4 <wait>
  wait();
     c99:	e8 56 33 00 00       	call   3ff4 <wait>
  wait();
     c9e:	e8 51 33 00 00       	call   3ff4 <wait>
  printf(1, "preempt ok\n");
     ca3:	c7 44 24 04 6a 4a 00 	movl   $0x4a6a,0x4(%esp)
     caa:	00 
     cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb2:	e8 d5 34 00 00       	call   418c <printf>
}
     cb7:	c9                   	leave  
     cb8:	c3                   	ret    

00000cb9 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cb9:	55                   	push   %ebp
     cba:	89 e5                	mov    %esp,%ebp
     cbc:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cc6:	eb 53                	jmp    d1b <exitwait+0x62>
    pid = fork();
     cc8:	e8 17 33 00 00       	call   3fe4 <fork>
     ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cd4:	79 16                	jns    cec <exitwait+0x33>
      printf(1, "fork failed\n");
     cd6:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
     cdd:	00 
     cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce5:	e8 a2 34 00 00       	call   418c <printf>
      return;
     cea:	eb 49                	jmp    d35 <exitwait+0x7c>
    }
    if(pid){
     cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cf0:	74 20                	je     d12 <exitwait+0x59>
      if(wait() != pid){
     cf2:	e8 fd 32 00 00       	call   3ff4 <wait>
     cf7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     cfa:	74 1b                	je     d17 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cfc:	c7 44 24 04 76 4a 00 	movl   $0x4a76,0x4(%esp)
     d03:	00 
     d04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d0b:	e8 7c 34 00 00       	call   418c <printf>
        return;
     d10:	eb 23                	jmp    d35 <exitwait+0x7c>
      }
    } else {
      exit();
     d12:	e8 d5 32 00 00       	call   3fec <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d1b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d1f:	7e a7                	jle    cc8 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d21:	c7 44 24 04 86 4a 00 	movl   $0x4a86,0x4(%esp)
     d28:	00 
     d29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d30:	e8 57 34 00 00       	call   418c <printf>
}
     d35:	c9                   	leave  
     d36:	c3                   	ret    

00000d37 <mem>:

void
mem(void)
{
     d37:	55                   	push   %ebp
     d38:	89 e5                	mov    %esp,%ebp
     d3a:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d3d:	c7 44 24 04 93 4a 00 	movl   $0x4a93,0x4(%esp)
     d44:	00 
     d45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d4c:	e8 3b 34 00 00       	call   418c <printf>
  ppid = getpid();
     d51:	e8 16 33 00 00       	call   406c <getpid>
     d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d59:	e8 86 32 00 00       	call   3fe4 <fork>
     d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d65:	0f 85 aa 00 00 00    	jne    e15 <mem+0xde>
    m1 = 0;
     d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     d72:	eb 0e                	jmp    d82 <mem+0x4b>
      *(char**)m2 = m1;
     d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d7a:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     d82:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     d89:	e8 ea 36 00 00       	call   4478 <malloc>
     d8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d95:	75 dd                	jne    d74 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d97:	eb 19                	jmp    db2 <mem+0x7b>
      m2 = *(char**)m1;
     d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9c:	8b 00                	mov    (%eax),%eax
     d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da4:	89 04 24             	mov    %eax,(%esp)
     da7:	e8 93 35 00 00       	call   433f <free>
      m1 = m2;
     dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
     daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     db6:	75 e1                	jne    d99 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     db8:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     dbf:	e8 b4 36 00 00       	call   4478 <malloc>
     dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dcb:	75 24                	jne    df1 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dcd:	c7 44 24 04 9d 4a 00 	movl   $0x4a9d,0x4(%esp)
     dd4:	00 
     dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ddc:	e8 ab 33 00 00       	call   418c <printf>
      kill(ppid);
     de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     de4:	89 04 24             	mov    %eax,(%esp)
     de7:	e8 30 32 00 00       	call   401c <kill>
      exit();
     dec:	e8 fb 31 00 00       	call   3fec <exit>
    }
    free(m1);
     df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df4:	89 04 24             	mov    %eax,(%esp)
     df7:	e8 43 35 00 00       	call   433f <free>
    printf(1, "mem ok\n");
     dfc:	c7 44 24 04 b7 4a 00 	movl   $0x4ab7,0x4(%esp)
     e03:	00 
     e04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e0b:	e8 7c 33 00 00       	call   418c <printf>
    exit();
     e10:	e8 d7 31 00 00       	call   3fec <exit>
  } else {
    wait();
     e15:	e8 da 31 00 00       	call   3ff4 <wait>
  }
}
     e1a:	c9                   	leave  
     e1b:	c3                   	ret    

00000e1c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e1c:	55                   	push   %ebp
     e1d:	89 e5                	mov    %esp,%ebp
     e1f:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e22:	c7 44 24 04 bf 4a 00 	movl   $0x4abf,0x4(%esp)
     e29:	00 
     e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e31:	e8 56 33 00 00       	call   418c <printf>

  unlink("sharedfd");
     e36:	c7 04 24 ce 4a 00 00 	movl   $0x4ace,(%esp)
     e3d:	e8 fa 31 00 00       	call   403c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e42:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e49:	00 
     e4a:	c7 04 24 ce 4a 00 00 	movl   $0x4ace,(%esp)
     e51:	e8 d6 31 00 00       	call   402c <open>
     e56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     e59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e5d:	79 19                	jns    e78 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e5f:	c7 44 24 04 d8 4a 00 	movl   $0x4ad8,0x4(%esp)
     e66:	00 
     e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e6e:	e8 19 33 00 00       	call   418c <printf>
    return;
     e73:	e9 a0 01 00 00       	jmp    1018 <sharedfd+0x1fc>
  }
  pid = fork();
     e78:	e8 67 31 00 00       	call   3fe4 <fork>
     e7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e84:	75 07                	jne    e8d <sharedfd+0x71>
     e86:	b8 63 00 00 00       	mov    $0x63,%eax
     e8b:	eb 05                	jmp    e92 <sharedfd+0x76>
     e8d:	b8 70 00 00 00       	mov    $0x70,%eax
     e92:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e99:	00 
     e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ea1:	89 04 24             	mov    %eax,(%esp)
     ea4:	e8 96 2f 00 00       	call   3e3f <memset>
  for(i = 0; i < 1000; i++){
     ea9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb0:	eb 39                	jmp    eeb <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eb2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eb9:	00 
     eba:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ec4:	89 04 24             	mov    %eax,(%esp)
     ec7:	e8 40 31 00 00       	call   400c <write>
     ecc:	83 f8 0a             	cmp    $0xa,%eax
     ecf:	74 16                	je     ee7 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ed1:	c7 44 24 04 04 4b 00 	movl   $0x4b04,0x4(%esp)
     ed8:	00 
     ed9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ee0:	e8 a7 32 00 00       	call   418c <printf>
      break;
     ee5:	eb 0d                	jmp    ef4 <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     ee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eeb:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     ef2:	7e be                	jle    eb2 <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ef8:	75 05                	jne    eff <sharedfd+0xe3>
    exit();
     efa:	e8 ed 30 00 00       	call   3fec <exit>
  else
    wait();
     eff:	e8 f0 30 00 00       	call   3ff4 <wait>
  close(fd);
     f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f07:	89 04 24             	mov    %eax,(%esp)
     f0a:	e8 05 31 00 00       	call   4014 <close>
  fd = open("sharedfd", 0);
     f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f16:	00 
     f17:	c7 04 24 ce 4a 00 00 	movl   $0x4ace,(%esp)
     f1e:	e8 09 31 00 00       	call   402c <open>
     f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f2a:	79 19                	jns    f45 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f2c:	c7 44 24 04 24 4b 00 	movl   $0x4b24,0x4(%esp)
     f33:	00 
     f34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f3b:	e8 4c 32 00 00       	call   418c <printf>
    return;
     f40:	e9 d3 00 00 00       	jmp    1018 <sharedfd+0x1fc>
  }
  nc = np = 0;
     f45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f52:	eb 3b                	jmp    f8f <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
     f54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f5b:	eb 2a                	jmp    f87 <sharedfd+0x16b>
      if(buf[i] == 'c')
     f5d:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f63:	01 d0                	add    %edx,%eax
     f65:	0f b6 00             	movzbl (%eax),%eax
     f68:	3c 63                	cmp    $0x63,%al
     f6a:	75 04                	jne    f70 <sharedfd+0x154>
        nc++;
     f6c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     f70:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f76:	01 d0                	add    %edx,%eax
     f78:	0f b6 00             	movzbl (%eax),%eax
     f7b:	3c 70                	cmp    $0x70,%al
     f7d:	75 04                	jne    f83 <sharedfd+0x167>
        np++;
     f7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f8a:	83 f8 09             	cmp    $0x9,%eax
     f8d:	76 ce                	jbe    f5d <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f8f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f96:	00 
     f97:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa1:	89 04 24             	mov    %eax,(%esp)
     fa4:	e8 5b 30 00 00       	call   4004 <read>
     fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
     fac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fb0:	7f a2                	jg     f54 <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb5:	89 04 24             	mov    %eax,(%esp)
     fb8:	e8 57 30 00 00       	call   4014 <close>
  unlink("sharedfd");
     fbd:	c7 04 24 ce 4a 00 00 	movl   $0x4ace,(%esp)
     fc4:	e8 73 30 00 00       	call   403c <unlink>
  if(nc == 10000 && np == 10000){
     fc9:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fd0:	75 1f                	jne    ff1 <sharedfd+0x1d5>
     fd2:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     fd9:	75 16                	jne    ff1 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
     fdb:	c7 44 24 04 4f 4b 00 	movl   $0x4b4f,0x4(%esp)
     fe2:	00 
     fe3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fea:	e8 9d 31 00 00       	call   418c <printf>
     fef:	eb 27                	jmp    1018 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
     fff:	c7 44 24 04 5c 4b 00 	movl   $0x4b5c,0x4(%esp)
    1006:	00 
    1007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    100e:	e8 79 31 00 00       	call   418c <printf>
    exit();
    1013:	e8 d4 2f 00 00       	call   3fec <exit>
  }
}
    1018:	c9                   	leave  
    1019:	c3                   	ret    

0000101a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    101a:	55                   	push   %ebp
    101b:	89 e5                	mov    %esp,%ebp
    101d:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1020:	c7 45 c8 71 4b 00 00 	movl   $0x4b71,-0x38(%ebp)
    1027:	c7 45 cc 74 4b 00 00 	movl   $0x4b74,-0x34(%ebp)
    102e:	c7 45 d0 77 4b 00 00 	movl   $0x4b77,-0x30(%ebp)
    1035:	c7 45 d4 7a 4b 00 00 	movl   $0x4b7a,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    103c:	c7 44 24 04 7d 4b 00 	movl   $0x4b7d,0x4(%esp)
    1043:	00 
    1044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104b:	e8 3c 31 00 00       	call   418c <printf>

  for(pi = 0; pi < 4; pi++){
    1050:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1057:	e9 fc 00 00 00       	jmp    1158 <fourfiles+0x13e>
    fname = names[pi];
    105c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    105f:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1063:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    1066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1069:	89 04 24             	mov    %eax,(%esp)
    106c:	e8 cb 2f 00 00       	call   403c <unlink>

    pid = fork();
    1071:	e8 6e 2f 00 00       	call   3fe4 <fork>
    1076:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    1079:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    107d:	79 19                	jns    1098 <fourfiles+0x7e>
      printf(1, "fork failed\n");
    107f:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
    1086:	00 
    1087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108e:	e8 f9 30 00 00       	call   418c <printf>
      exit();
    1093:	e8 54 2f 00 00       	call   3fec <exit>
    }

    if(pid == 0){
    1098:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    109c:	0f 85 b2 00 00 00    	jne    1154 <fourfiles+0x13a>
      fd = open(fname, O_CREATE | O_RDWR);
    10a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10a9:	00 
    10aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ad:	89 04 24             	mov    %eax,(%esp)
    10b0:	e8 77 2f 00 00       	call   402c <open>
    10b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10bc:	79 19                	jns    10d7 <fourfiles+0xbd>
        printf(1, "create failed\n");
    10be:	c7 44 24 04 8d 4b 00 	movl   $0x4b8d,0x4(%esp)
    10c5:	00 
    10c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10cd:	e8 ba 30 00 00       	call   418c <printf>
        exit();
    10d2:	e8 15 2f 00 00       	call   3fec <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10da:	83 c0 30             	add    $0x30,%eax
    10dd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10e4:	00 
    10e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e9:	c7 04 24 20 8c 00 00 	movl   $0x8c20,(%esp)
    10f0:	e8 4a 2d 00 00       	call   3e3f <memset>
      for(i = 0; i < 12; i++){
    10f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10fc:	eb 4b                	jmp    1149 <fourfiles+0x12f>
        if((n = write(fd, buf, 500)) != 500){
    10fe:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1105:	00 
    1106:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    110d:	00 
    110e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1111:	89 04 24             	mov    %eax,(%esp)
    1114:	e8 f3 2e 00 00       	call   400c <write>
    1119:	89 45 d8             	mov    %eax,-0x28(%ebp)
    111c:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    1123:	74 20                	je     1145 <fourfiles+0x12b>
          printf(1, "write failed %d\n", n);
    1125:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1128:	89 44 24 08          	mov    %eax,0x8(%esp)
    112c:	c7 44 24 04 9c 4b 00 	movl   $0x4b9c,0x4(%esp)
    1133:	00 
    1134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113b:	e8 4c 30 00 00       	call   418c <printf>
          exit();
    1140:	e8 a7 2e 00 00       	call   3fec <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    1145:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1149:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    114d:	7e af                	jle    10fe <fourfiles+0xe4>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    114f:	e8 98 2e 00 00       	call   3fec <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    1154:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1158:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    115c:	0f 8e fa fe ff ff    	jle    105c <fourfiles+0x42>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1162:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1169:	eb 09                	jmp    1174 <fourfiles+0x15a>
    wait();
    116b:	e8 84 2e 00 00       	call   3ff4 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1170:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1174:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1178:	7e f1                	jle    116b <fourfiles+0x151>
    wait();
  }

  for(i = 0; i < 2; i++){
    117a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1181:	e9 dc 00 00 00       	jmp    1262 <fourfiles+0x248>
    fname = names[i];
    1186:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1189:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    118d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    1190:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1197:	00 
    1198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    119b:	89 04 24             	mov    %eax,(%esp)
    119e:	e8 89 2e 00 00       	call   402c <open>
    11a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11ad:	eb 4c                	jmp    11fb <fourfiles+0x1e1>
      for(j = 0; j < n; j++){
    11af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11b6:	eb 35                	jmp    11ed <fourfiles+0x1d3>
        if(buf[j] != '0'+i){
    11b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11bb:	05 20 8c 00 00       	add    $0x8c20,%eax
    11c0:	0f b6 00             	movzbl (%eax),%eax
    11c3:	0f be c0             	movsbl %al,%eax
    11c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c9:	83 c2 30             	add    $0x30,%edx
    11cc:	39 d0                	cmp    %edx,%eax
    11ce:	74 19                	je     11e9 <fourfiles+0x1cf>
          printf(1, "wrong char\n");
    11d0:	c7 44 24 04 ad 4b 00 	movl   $0x4bad,0x4(%esp)
    11d7:	00 
    11d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11df:	e8 a8 2f 00 00       	call   418c <printf>
          exit();
    11e4:	e8 03 2e 00 00       	call   3fec <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11e9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    11f3:	7c c3                	jl     11b8 <fourfiles+0x19e>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11f8:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11fb:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1202:	00 
    1203:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    120a:	00 
    120b:	8b 45 dc             	mov    -0x24(%ebp),%eax
    120e:	89 04 24             	mov    %eax,(%esp)
    1211:	e8 ee 2d 00 00       	call   4004 <read>
    1216:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1219:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    121d:	7f 90                	jg     11af <fourfiles+0x195>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    121f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 ea 2d 00 00       	call   4014 <close>
    if(total != 12*500){
    122a:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1231:	74 20                	je     1253 <fourfiles+0x239>
      printf(1, "wrong length %d\n", total);
    1233:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1236:	89 44 24 08          	mov    %eax,0x8(%esp)
    123a:	c7 44 24 04 b9 4b 00 	movl   $0x4bb9,0x4(%esp)
    1241:	00 
    1242:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1249:	e8 3e 2f 00 00       	call   418c <printf>
      exit();
    124e:	e8 99 2d 00 00       	call   3fec <exit>
    }
    unlink(fname);
    1253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1256:	89 04 24             	mov    %eax,(%esp)
    1259:	e8 de 2d 00 00       	call   403c <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    125e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1262:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1266:	0f 8e 1a ff ff ff    	jle    1186 <fourfiles+0x16c>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    126c:	c7 44 24 04 ca 4b 00 	movl   $0x4bca,0x4(%esp)
    1273:	00 
    1274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    127b:	e8 0c 2f 00 00       	call   418c <printf>
}
    1280:	c9                   	leave  
    1281:	c3                   	ret    

00001282 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1282:	55                   	push   %ebp
    1283:	89 e5                	mov    %esp,%ebp
    1285:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1288:	c7 44 24 04 d8 4b 00 	movl   $0x4bd8,0x4(%esp)
    128f:	00 
    1290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1297:	e8 f0 2e 00 00       	call   418c <printf>

  for(pi = 0; pi < 4; pi++){
    129c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12a3:	e9 f4 00 00 00       	jmp    139c <createdelete+0x11a>
    pid = fork();
    12a8:	e8 37 2d 00 00       	call   3fe4 <fork>
    12ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12b4:	79 19                	jns    12cf <createdelete+0x4d>
      printf(1, "fork failed\n");
    12b6:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
    12bd:	00 
    12be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c5:	e8 c2 2e 00 00       	call   418c <printf>
      exit();
    12ca:	e8 1d 2d 00 00       	call   3fec <exit>
    }

    if(pid == 0){
    12cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12d3:	0f 85 bf 00 00 00    	jne    1398 <createdelete+0x116>
      name[0] = 'p' + pi;
    12d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12dc:	83 c0 70             	add    $0x70,%eax
    12df:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12e2:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12ed:	e9 97 00 00 00       	jmp    1389 <createdelete+0x107>
        name[1] = '0' + i;
    12f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f5:	83 c0 30             	add    $0x30,%eax
    12f8:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12fb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1302:	00 
    1303:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1306:	89 04 24             	mov    %eax,(%esp)
    1309:	e8 1e 2d 00 00       	call   402c <open>
    130e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    1311:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1315:	79 19                	jns    1330 <createdelete+0xae>
          printf(1, "create failed\n");
    1317:	c7 44 24 04 8d 4b 00 	movl   $0x4b8d,0x4(%esp)
    131e:	00 
    131f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1326:	e8 61 2e 00 00       	call   418c <printf>
          exit();
    132b:	e8 bc 2c 00 00       	call   3fec <exit>
        }
        close(fd);
    1330:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1333:	89 04 24             	mov    %eax,(%esp)
    1336:	e8 d9 2c 00 00       	call   4014 <close>
        if(i > 0 && (i % 2 ) == 0){
    133b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    133f:	7e 44                	jle    1385 <createdelete+0x103>
    1341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1344:	83 e0 01             	and    $0x1,%eax
    1347:	85 c0                	test   %eax,%eax
    1349:	75 3a                	jne    1385 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134e:	89 c2                	mov    %eax,%edx
    1350:	c1 ea 1f             	shr    $0x1f,%edx
    1353:	01 d0                	add    %edx,%eax
    1355:	d1 f8                	sar    %eax
    1357:	83 c0 30             	add    $0x30,%eax
    135a:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    135d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1360:	89 04 24             	mov    %eax,(%esp)
    1363:	e8 d4 2c 00 00       	call   403c <unlink>
    1368:	85 c0                	test   %eax,%eax
    136a:	79 19                	jns    1385 <createdelete+0x103>
            printf(1, "unlink failed\n");
    136c:	c7 44 24 04 7c 46 00 	movl   $0x467c,0x4(%esp)
    1373:	00 
    1374:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    137b:	e8 0c 2e 00 00       	call   418c <printf>
            exit();
    1380:	e8 67 2c 00 00       	call   3fec <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    1385:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1389:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    138d:	0f 8e 5f ff ff ff    	jle    12f2 <createdelete+0x70>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    1393:	e8 54 2c 00 00       	call   3fec <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    1398:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    139c:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13a0:	0f 8e 02 ff ff ff    	jle    12a8 <createdelete+0x26>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13ad:	eb 09                	jmp    13b8 <createdelete+0x136>
    wait();
    13af:	e8 40 2c 00 00       	call   3ff4 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13b8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13bc:	7e f1                	jle    13af <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13be:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13c2:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13c6:	88 45 c9             	mov    %al,-0x37(%ebp)
    13c9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13cd:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13d7:	e9 bb 00 00 00       	jmp    1497 <createdelete+0x215>
    for(pi = 0; pi < 4; pi++){
    13dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13e3:	e9 a1 00 00 00       	jmp    1489 <createdelete+0x207>
      name[0] = 'p' + pi;
    13e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13eb:	83 c0 70             	add    $0x70,%eax
    13ee:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f4:	83 c0 30             	add    $0x30,%eax
    13f7:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1401:	00 
    1402:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1405:	89 04 24             	mov    %eax,(%esp)
    1408:	e8 1f 2c 00 00       	call   402c <open>
    140d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1414:	74 06                	je     141c <createdelete+0x19a>
    1416:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    141a:	7e 26                	jle    1442 <createdelete+0x1c0>
    141c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1420:	79 20                	jns    1442 <createdelete+0x1c0>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1422:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1425:	89 44 24 08          	mov    %eax,0x8(%esp)
    1429:	c7 44 24 04 ec 4b 00 	movl   $0x4bec,0x4(%esp)
    1430:	00 
    1431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1438:	e8 4f 2d 00 00       	call   418c <printf>
        exit();
    143d:	e8 aa 2b 00 00       	call   3fec <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1446:	7e 2c                	jle    1474 <createdelete+0x1f2>
    1448:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    144c:	7f 26                	jg     1474 <createdelete+0x1f2>
    144e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1452:	78 20                	js     1474 <createdelete+0x1f2>
        printf(1, "oops createdelete %s did exist\n", name);
    1454:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1457:	89 44 24 08          	mov    %eax,0x8(%esp)
    145b:	c7 44 24 04 10 4c 00 	movl   $0x4c10,0x4(%esp)
    1462:	00 
    1463:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    146a:	e8 1d 2d 00 00       	call   418c <printf>
        exit();
    146f:	e8 78 2b 00 00       	call   3fec <exit>
      }
      if(fd >= 0)
    1474:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1478:	78 0b                	js     1485 <createdelete+0x203>
        close(fd);
    147a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    147d:	89 04 24             	mov    %eax,(%esp)
    1480:	e8 8f 2b 00 00       	call   4014 <close>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    1485:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1489:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    148d:	0f 8e 55 ff ff ff    	jle    13e8 <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    1493:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1497:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    149b:	0f 8e 3b ff ff ff    	jle    13dc <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14a8:	eb 34                	jmp    14de <createdelete+0x25c>
    for(pi = 0; pi < 4; pi++){
    14aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14b1:	eb 21                	jmp    14d4 <createdelete+0x252>
      name[0] = 'p' + i;
    14b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b6:	83 c0 70             	add    $0x70,%eax
    14b9:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bf:	83 c0 30             	add    $0x30,%eax
    14c2:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14c8:	89 04 24             	mov    %eax,(%esp)
    14cb:	e8 6c 2b 00 00       	call   403c <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14d4:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14d8:	7e d9                	jle    14b3 <createdelete+0x231>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14de:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14e2:	7e c6                	jle    14aa <createdelete+0x228>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14e4:	c7 44 24 04 30 4c 00 	movl   $0x4c30,0x4(%esp)
    14eb:	00 
    14ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f3:	e8 94 2c 00 00       	call   418c <printf>
}
    14f8:	c9                   	leave  
    14f9:	c3                   	ret    

000014fa <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14fa:	55                   	push   %ebp
    14fb:	89 e5                	mov    %esp,%ebp
    14fd:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1500:	c7 44 24 04 41 4c 00 	movl   $0x4c41,0x4(%esp)
    1507:	00 
    1508:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    150f:	e8 78 2c 00 00       	call   418c <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1514:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    151b:	00 
    151c:	c7 04 24 52 4c 00 00 	movl   $0x4c52,(%esp)
    1523:	e8 04 2b 00 00       	call   402c <open>
    1528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    152b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152f:	79 19                	jns    154a <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    1531:	c7 44 24 04 5d 4c 00 	movl   $0x4c5d,0x4(%esp)
    1538:	00 
    1539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1540:	e8 47 2c 00 00       	call   418c <printf>
    exit();
    1545:	e8 a2 2a 00 00       	call   3fec <exit>
  }
  write(fd, "hello", 5);
    154a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1551:	00 
    1552:	c7 44 24 04 77 4c 00 	movl   $0x4c77,0x4(%esp)
    1559:	00 
    155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155d:	89 04 24             	mov    %eax,(%esp)
    1560:	e8 a7 2a 00 00       	call   400c <write>
  close(fd);
    1565:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1568:	89 04 24             	mov    %eax,(%esp)
    156b:	e8 a4 2a 00 00       	call   4014 <close>

  fd = open("unlinkread", O_RDWR);
    1570:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1577:	00 
    1578:	c7 04 24 52 4c 00 00 	movl   $0x4c52,(%esp)
    157f:	e8 a8 2a 00 00       	call   402c <open>
    1584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    158b:	79 19                	jns    15a6 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    158d:	c7 44 24 04 7d 4c 00 	movl   $0x4c7d,0x4(%esp)
    1594:	00 
    1595:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    159c:	e8 eb 2b 00 00       	call   418c <printf>
    exit();
    15a1:	e8 46 2a 00 00       	call   3fec <exit>
  }
  if(unlink("unlinkread") != 0){
    15a6:	c7 04 24 52 4c 00 00 	movl   $0x4c52,(%esp)
    15ad:	e8 8a 2a 00 00       	call   403c <unlink>
    15b2:	85 c0                	test   %eax,%eax
    15b4:	74 19                	je     15cf <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    15b6:	c7 44 24 04 95 4c 00 	movl   $0x4c95,0x4(%esp)
    15bd:	00 
    15be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c5:	e8 c2 2b 00 00       	call   418c <printf>
    exit();
    15ca:	e8 1d 2a 00 00       	call   3fec <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15d6:	00 
    15d7:	c7 04 24 52 4c 00 00 	movl   $0x4c52,(%esp)
    15de:	e8 49 2a 00 00       	call   402c <open>
    15e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15e6:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    15ed:	00 
    15ee:	c7 44 24 04 af 4c 00 	movl   $0x4caf,0x4(%esp)
    15f5:	00 
    15f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f9:	89 04 24             	mov    %eax,(%esp)
    15fc:	e8 0b 2a 00 00       	call   400c <write>
  close(fd1);
    1601:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1604:	89 04 24             	mov    %eax,(%esp)
    1607:	e8 08 2a 00 00       	call   4014 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    160c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1613:	00 
    1614:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    161b:	00 
    161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161f:	89 04 24             	mov    %eax,(%esp)
    1622:	e8 dd 29 00 00       	call   4004 <read>
    1627:	83 f8 05             	cmp    $0x5,%eax
    162a:	74 19                	je     1645 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    162c:	c7 44 24 04 b3 4c 00 	movl   $0x4cb3,0x4(%esp)
    1633:	00 
    1634:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    163b:	e8 4c 2b 00 00       	call   418c <printf>
    exit();
    1640:	e8 a7 29 00 00       	call   3fec <exit>
  }
  if(buf[0] != 'h'){
    1645:	0f b6 05 20 8c 00 00 	movzbl 0x8c20,%eax
    164c:	3c 68                	cmp    $0x68,%al
    164e:	74 19                	je     1669 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    1650:	c7 44 24 04 ca 4c 00 	movl   $0x4cca,0x4(%esp)
    1657:	00 
    1658:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    165f:	e8 28 2b 00 00       	call   418c <printf>
    exit();
    1664:	e8 83 29 00 00       	call   3fec <exit>
  }
  if(write(fd, buf, 10) != 10){
    1669:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1670:	00 
    1671:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    1678:	00 
    1679:	8b 45 f4             	mov    -0xc(%ebp),%eax
    167c:	89 04 24             	mov    %eax,(%esp)
    167f:	e8 88 29 00 00       	call   400c <write>
    1684:	83 f8 0a             	cmp    $0xa,%eax
    1687:	74 19                	je     16a2 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    1689:	c7 44 24 04 e1 4c 00 	movl   $0x4ce1,0x4(%esp)
    1690:	00 
    1691:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1698:	e8 ef 2a 00 00       	call   418c <printf>
    exit();
    169d:	e8 4a 29 00 00       	call   3fec <exit>
  }
  close(fd);
    16a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a5:	89 04 24             	mov    %eax,(%esp)
    16a8:	e8 67 29 00 00       	call   4014 <close>
  unlink("unlinkread");
    16ad:	c7 04 24 52 4c 00 00 	movl   $0x4c52,(%esp)
    16b4:	e8 83 29 00 00       	call   403c <unlink>
  printf(1, "unlinkread ok\n");
    16b9:	c7 44 24 04 fa 4c 00 	movl   $0x4cfa,0x4(%esp)
    16c0:	00 
    16c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c8:	e8 bf 2a 00 00       	call   418c <printf>
}
    16cd:	c9                   	leave  
    16ce:	c3                   	ret    

000016cf <linktest>:

void
linktest(void)
{
    16cf:	55                   	push   %ebp
    16d0:	89 e5                	mov    %esp,%ebp
    16d2:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    16d5:	c7 44 24 04 09 4d 00 	movl   $0x4d09,0x4(%esp)
    16dc:	00 
    16dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16e4:	e8 a3 2a 00 00       	call   418c <printf>

  unlink("lf1");
    16e9:	c7 04 24 13 4d 00 00 	movl   $0x4d13,(%esp)
    16f0:	e8 47 29 00 00       	call   403c <unlink>
  unlink("lf2");
    16f5:	c7 04 24 17 4d 00 00 	movl   $0x4d17,(%esp)
    16fc:	e8 3b 29 00 00       	call   403c <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1701:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1708:	00 
    1709:	c7 04 24 13 4d 00 00 	movl   $0x4d13,(%esp)
    1710:	e8 17 29 00 00       	call   402c <open>
    1715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    171c:	79 19                	jns    1737 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    171e:	c7 44 24 04 1b 4d 00 	movl   $0x4d1b,0x4(%esp)
    1725:	00 
    1726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    172d:	e8 5a 2a 00 00       	call   418c <printf>
    exit();
    1732:	e8 b5 28 00 00       	call   3fec <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1737:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    173e:	00 
    173f:	c7 44 24 04 77 4c 00 	movl   $0x4c77,0x4(%esp)
    1746:	00 
    1747:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174a:	89 04 24             	mov    %eax,(%esp)
    174d:	e8 ba 28 00 00       	call   400c <write>
    1752:	83 f8 05             	cmp    $0x5,%eax
    1755:	74 19                	je     1770 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    1757:	c7 44 24 04 2e 4d 00 	movl   $0x4d2e,0x4(%esp)
    175e:	00 
    175f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1766:	e8 21 2a 00 00       	call   418c <printf>
    exit();
    176b:	e8 7c 28 00 00       	call   3fec <exit>
  }
  close(fd);
    1770:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1773:	89 04 24             	mov    %eax,(%esp)
    1776:	e8 99 28 00 00       	call   4014 <close>

  if(link("lf1", "lf2") < 0){
    177b:	c7 44 24 04 17 4d 00 	movl   $0x4d17,0x4(%esp)
    1782:	00 
    1783:	c7 04 24 13 4d 00 00 	movl   $0x4d13,(%esp)
    178a:	e8 bd 28 00 00       	call   404c <link>
    178f:	85 c0                	test   %eax,%eax
    1791:	79 19                	jns    17ac <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    1793:	c7 44 24 04 40 4d 00 	movl   $0x4d40,0x4(%esp)
    179a:	00 
    179b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17a2:	e8 e5 29 00 00       	call   418c <printf>
    exit();
    17a7:	e8 40 28 00 00       	call   3fec <exit>
  }
  unlink("lf1");
    17ac:	c7 04 24 13 4d 00 00 	movl   $0x4d13,(%esp)
    17b3:	e8 84 28 00 00       	call   403c <unlink>

  if(open("lf1", 0) >= 0){
    17b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17bf:	00 
    17c0:	c7 04 24 13 4d 00 00 	movl   $0x4d13,(%esp)
    17c7:	e8 60 28 00 00       	call   402c <open>
    17cc:	85 c0                	test   %eax,%eax
    17ce:	78 19                	js     17e9 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    17d0:	c7 44 24 04 58 4d 00 	movl   $0x4d58,0x4(%esp)
    17d7:	00 
    17d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17df:	e8 a8 29 00 00       	call   418c <printf>
    exit();
    17e4:	e8 03 28 00 00       	call   3fec <exit>
  }

  fd = open("lf2", 0);
    17e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17f0:	00 
    17f1:	c7 04 24 17 4d 00 00 	movl   $0x4d17,(%esp)
    17f8:	e8 2f 28 00 00       	call   402c <open>
    17fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1804:	79 19                	jns    181f <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1806:	c7 44 24 04 7d 4d 00 	movl   $0x4d7d,0x4(%esp)
    180d:	00 
    180e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1815:	e8 72 29 00 00       	call   418c <printf>
    exit();
    181a:	e8 cd 27 00 00       	call   3fec <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    181f:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1826:	00 
    1827:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    182e:	00 
    182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1832:	89 04 24             	mov    %eax,(%esp)
    1835:	e8 ca 27 00 00       	call   4004 <read>
    183a:	83 f8 05             	cmp    $0x5,%eax
    183d:	74 19                	je     1858 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    183f:	c7 44 24 04 8e 4d 00 	movl   $0x4d8e,0x4(%esp)
    1846:	00 
    1847:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184e:	e8 39 29 00 00       	call   418c <printf>
    exit();
    1853:	e8 94 27 00 00       	call   3fec <exit>
  }
  close(fd);
    1858:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185b:	89 04 24             	mov    %eax,(%esp)
    185e:	e8 b1 27 00 00       	call   4014 <close>

  if(link("lf2", "lf2") >= 0){
    1863:	c7 44 24 04 17 4d 00 	movl   $0x4d17,0x4(%esp)
    186a:	00 
    186b:	c7 04 24 17 4d 00 00 	movl   $0x4d17,(%esp)
    1872:	e8 d5 27 00 00       	call   404c <link>
    1877:	85 c0                	test   %eax,%eax
    1879:	78 19                	js     1894 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    187b:	c7 44 24 04 9f 4d 00 	movl   $0x4d9f,0x4(%esp)
    1882:	00 
    1883:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    188a:	e8 fd 28 00 00       	call   418c <printf>
    exit();
    188f:	e8 58 27 00 00       	call   3fec <exit>
  }

  unlink("lf2");
    1894:	c7 04 24 17 4d 00 00 	movl   $0x4d17,(%esp)
    189b:	e8 9c 27 00 00       	call   403c <unlink>
  if(link("lf2", "lf1") >= 0){
    18a0:	c7 44 24 04 13 4d 00 	movl   $0x4d13,0x4(%esp)
    18a7:	00 
    18a8:	c7 04 24 17 4d 00 00 	movl   $0x4d17,(%esp)
    18af:	e8 98 27 00 00       	call   404c <link>
    18b4:	85 c0                	test   %eax,%eax
    18b6:	78 19                	js     18d1 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    18b8:	c7 44 24 04 c0 4d 00 	movl   $0x4dc0,0x4(%esp)
    18bf:	00 
    18c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c7:	e8 c0 28 00 00       	call   418c <printf>
    exit();
    18cc:	e8 1b 27 00 00       	call   3fec <exit>
  }

  if(link(".", "lf1") >= 0){
    18d1:	c7 44 24 04 13 4d 00 	movl   $0x4d13,0x4(%esp)
    18d8:	00 
    18d9:	c7 04 24 e3 4d 00 00 	movl   $0x4de3,(%esp)
    18e0:	e8 67 27 00 00       	call   404c <link>
    18e5:	85 c0                	test   %eax,%eax
    18e7:	78 19                	js     1902 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    18e9:	c7 44 24 04 e5 4d 00 	movl   $0x4de5,0x4(%esp)
    18f0:	00 
    18f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18f8:	e8 8f 28 00 00       	call   418c <printf>
    exit();
    18fd:	e8 ea 26 00 00       	call   3fec <exit>
  }

  printf(1, "linktest ok\n");
    1902:	c7 44 24 04 01 4e 00 	movl   $0x4e01,0x4(%esp)
    1909:	00 
    190a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1911:	e8 76 28 00 00       	call   418c <printf>
}
    1916:	c9                   	leave  
    1917:	c3                   	ret    

00001918 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1918:	55                   	push   %ebp
    1919:	89 e5                	mov    %esp,%ebp
    191b:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    191e:	c7 44 24 04 0e 4e 00 	movl   $0x4e0e,0x4(%esp)
    1925:	00 
    1926:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    192d:	e8 5a 28 00 00       	call   418c <printf>
  file[0] = 'C';
    1932:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1936:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    193a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1941:	e9 f7 00 00 00       	jmp    1a3d <concreate+0x125>
    file[1] = '0' + i;
    1946:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1949:	83 c0 30             	add    $0x30,%eax
    194c:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    194f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1952:	89 04 24             	mov    %eax,(%esp)
    1955:	e8 e2 26 00 00       	call   403c <unlink>
    pid = fork();
    195a:	e8 85 26 00 00       	call   3fe4 <fork>
    195f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1962:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1966:	74 3a                	je     19a2 <concreate+0x8a>
    1968:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    196b:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1970:	89 c8                	mov    %ecx,%eax
    1972:	f7 ea                	imul   %edx
    1974:	89 c8                	mov    %ecx,%eax
    1976:	c1 f8 1f             	sar    $0x1f,%eax
    1979:	29 c2                	sub    %eax,%edx
    197b:	89 d0                	mov    %edx,%eax
    197d:	01 c0                	add    %eax,%eax
    197f:	01 d0                	add    %edx,%eax
    1981:	29 c1                	sub    %eax,%ecx
    1983:	89 ca                	mov    %ecx,%edx
    1985:	83 fa 01             	cmp    $0x1,%edx
    1988:	75 18                	jne    19a2 <concreate+0x8a>
      link("C0", file);
    198a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1991:	c7 04 24 1e 4e 00 00 	movl   $0x4e1e,(%esp)
    1998:	e8 af 26 00 00       	call   404c <link>
    199d:	e9 87 00 00 00       	jmp    1a29 <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    19a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a6:	75 3a                	jne    19e2 <concreate+0xca>
    19a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19ab:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19b0:	89 c8                	mov    %ecx,%eax
    19b2:	f7 ea                	imul   %edx
    19b4:	d1 fa                	sar    %edx
    19b6:	89 c8                	mov    %ecx,%eax
    19b8:	c1 f8 1f             	sar    $0x1f,%eax
    19bb:	29 c2                	sub    %eax,%edx
    19bd:	89 d0                	mov    %edx,%eax
    19bf:	c1 e0 02             	shl    $0x2,%eax
    19c2:	01 d0                	add    %edx,%eax
    19c4:	29 c1                	sub    %eax,%ecx
    19c6:	89 ca                	mov    %ecx,%edx
    19c8:	83 fa 01             	cmp    $0x1,%edx
    19cb:	75 15                	jne    19e2 <concreate+0xca>
      link("C0", file);
    19cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    19d4:	c7 04 24 1e 4e 00 00 	movl   $0x4e1e,(%esp)
    19db:	e8 6c 26 00 00       	call   404c <link>
    19e0:	eb 47                	jmp    1a29 <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    19e9:	00 
    19ea:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19ed:	89 04 24             	mov    %eax,(%esp)
    19f0:	e8 37 26 00 00       	call   402c <open>
    19f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fc:	79 20                	jns    1a1e <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19fe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a01:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a05:	c7 44 24 04 21 4e 00 	movl   $0x4e21,0x4(%esp)
    1a0c:	00 
    1a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a14:	e8 73 27 00 00       	call   418c <printf>
        exit();
    1a19:	e8 ce 25 00 00       	call   3fec <exit>
      }
      close(fd);
    1a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a21:	89 04 24             	mov    %eax,(%esp)
    1a24:	e8 eb 25 00 00       	call   4014 <close>
    }
    if(pid == 0){
    1a29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a2d:	75 05                	jne    1a34 <concreate+0x11c>
      exit();
    1a2f:	e8 b8 25 00 00       	call   3fec <exit>
    }
    else{
      wait();
    1a34:	e8 bb 25 00 00       	call   3ff4 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a3d:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a41:	0f 8e ff fe ff ff    	jle    1946 <concreate+0x2e>
    }
    else{
      wait();
    }
  }
  printf(1, "finitio \n"); 
    1a47:	c7 44 24 04 3d 4e 00 	movl   $0x4e3d,0x4(%esp)
    1a4e:	00 
    1a4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a56:	e8 31 27 00 00       	call   418c <printf>
  memset(fa, 0, sizeof(fa));
    1a5b:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a62:	00 
    1a63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a6a:	00 
    1a6b:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a6e:	89 04 24             	mov    %eax,(%esp)
    1a71:	e8 c9 23 00 00       	call   3e3f <memset>
  fd = open(".", 0);
    1a76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a7d:	00 
    1a7e:	c7 04 24 e3 4d 00 00 	movl   $0x4de3,(%esp)
    1a85:	e8 a2 25 00 00       	call   402c <open>
    1a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a94:	e9 a1 00 00 00       	jmp    1b3a <concreate+0x222>
    if(de.inum == 0)
    1a99:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a9d:	66 85 c0             	test   %ax,%ax
    1aa0:	75 05                	jne    1aa7 <concreate+0x18f>
      continue;
    1aa2:	e9 93 00 00 00       	jmp    1b3a <concreate+0x222>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1aa7:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1aab:	3c 43                	cmp    $0x43,%al
    1aad:	0f 85 87 00 00 00    	jne    1b3a <concreate+0x222>
    1ab3:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1ab7:	84 c0                	test   %al,%al
    1ab9:	75 7f                	jne    1b3a <concreate+0x222>
      i = de.name[1] - '0';
    1abb:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1abf:	0f be c0             	movsbl %al,%eax
    1ac2:	83 e8 30             	sub    $0x30,%eax
    1ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1acc:	78 08                	js     1ad6 <concreate+0x1be>
    1ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad1:	83 f8 27             	cmp    $0x27,%eax
    1ad4:	76 23                	jbe    1af9 <concreate+0x1e1>
        printf(1, "concreate weird file %s\n", de.name);
    1ad6:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ad9:	83 c0 02             	add    $0x2,%eax
    1adc:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ae0:	c7 44 24 04 47 4e 00 	movl   $0x4e47,0x4(%esp)
    1ae7:	00 
    1ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aef:	e8 98 26 00 00       	call   418c <printf>
        exit();
    1af4:	e8 f3 24 00 00       	call   3fec <exit>
      }
      if(fa[i]){
    1af9:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aff:	01 d0                	add    %edx,%eax
    1b01:	0f b6 00             	movzbl (%eax),%eax
    1b04:	84 c0                	test   %al,%al
    1b06:	74 23                	je     1b2b <concreate+0x213>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b08:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b0b:	83 c0 02             	add    $0x2,%eax
    1b0e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b12:	c7 44 24 04 60 4e 00 	movl   $0x4e60,0x4(%esp)
    1b19:	00 
    1b1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b21:	e8 66 26 00 00       	call   418c <printf>
        exit();
    1b26:	e8 c1 24 00 00       	call   3fec <exit>
      }
      fa[i] = 1;
    1b2b:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b31:	01 d0                	add    %edx,%eax
    1b33:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b36:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
  printf(1, "finitio \n"); 
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b3a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1b41:	00 
    1b42:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b45:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b4c:	89 04 24             	mov    %eax,(%esp)
    1b4f:	e8 b0 24 00 00       	call   4004 <read>
    1b54:	85 c0                	test   %eax,%eax
    1b56:	0f 8f 3d ff ff ff    	jg     1a99 <concreate+0x181>
      }
      fa[i] = 1;
      n++;
    }
  }
  db;
    1b5c:	c7 44 24 08 38 03 00 	movl   $0x338,0x8(%esp)
    1b63:	00 
    1b64:	c7 44 24 04 7d 4e 00 	movl   $0x4e7d,0x4(%esp)
    1b6b:	00 
    1b6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b73:	e8 14 26 00 00       	call   418c <printf>
  close(fd);
    1b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b7b:	89 04 24             	mov    %eax,(%esp)
    1b7e:	e8 91 24 00 00       	call   4014 <close>
  db;
    1b83:	c7 44 24 08 3a 03 00 	movl   $0x33a,0x8(%esp)
    1b8a:	00 
    1b8b:	c7 44 24 04 7d 4e 00 	movl   $0x4e7d,0x4(%esp)
    1b92:	00 
    1b93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b9a:	e8 ed 25 00 00       	call   418c <printf>
  if(n != 40){
    1b9f:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1ba3:	74 19                	je     1bbe <concreate+0x2a6>
    printf(1, "concreate not enough files in directory listing\n");
    1ba5:	c7 44 24 04 88 4e 00 	movl   $0x4e88,0x4(%esp)
    1bac:	00 
    1bad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bb4:	e8 d3 25 00 00       	call   418c <printf>
    exit();
    1bb9:	e8 2e 24 00 00       	call   3fec <exit>
  }

  for(i = 0; i < 40; i++){
    1bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bc5:	e9 2d 01 00 00       	jmp    1cf7 <concreate+0x3df>
    file[1] = '0' + i;
    1bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bcd:	83 c0 30             	add    $0x30,%eax
    1bd0:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1bd3:	e8 0c 24 00 00       	call   3fe4 <fork>
    1bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1bdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bdf:	79 19                	jns    1bfa <concreate+0x2e2>
      printf(1, "fork failed\n");
    1be1:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
    1be8:	00 
    1be9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bf0:	e8 97 25 00 00       	call   418c <printf>
      exit();
    1bf5:	e8 f2 23 00 00       	call   3fec <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bfa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bfd:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1c02:	89 c8                	mov    %ecx,%eax
    1c04:	f7 ea                	imul   %edx
    1c06:	89 c8                	mov    %ecx,%eax
    1c08:	c1 f8 1f             	sar    $0x1f,%eax
    1c0b:	29 c2                	sub    %eax,%edx
    1c0d:	89 d0                	mov    %edx,%eax
    1c0f:	01 c0                	add    %eax,%eax
    1c11:	01 d0                	add    %edx,%eax
    1c13:	29 c1                	sub    %eax,%ecx
    1c15:	89 ca                	mov    %ecx,%edx
    1c17:	85 d2                	test   %edx,%edx
    1c19:	75 06                	jne    1c21 <concreate+0x309>
    1c1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c1f:	74 28                	je     1c49 <concreate+0x331>
       ((i % 3) == 1 && pid != 0)){
    1c21:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1c24:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1c29:	89 c8                	mov    %ecx,%eax
    1c2b:	f7 ea                	imul   %edx
    1c2d:	89 c8                	mov    %ecx,%eax
    1c2f:	c1 f8 1f             	sar    $0x1f,%eax
    1c32:	29 c2                	sub    %eax,%edx
    1c34:	89 d0                	mov    %edx,%eax
    1c36:	01 c0                	add    %eax,%eax
    1c38:	01 d0                	add    %edx,%eax
    1c3a:	29 c1                	sub    %eax,%ecx
    1c3c:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1c3e:	83 fa 01             	cmp    $0x1,%edx
    1c41:	75 74                	jne    1cb7 <concreate+0x39f>
       ((i % 3) == 1 && pid != 0)){
    1c43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c47:	74 6e                	je     1cb7 <concreate+0x39f>
      close(open(file, 0));
    1c49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c50:	00 
    1c51:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c54:	89 04 24             	mov    %eax,(%esp)
    1c57:	e8 d0 23 00 00       	call   402c <open>
    1c5c:	89 04 24             	mov    %eax,(%esp)
    1c5f:	e8 b0 23 00 00       	call   4014 <close>
      close(open(file, 0));
    1c64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c6b:	00 
    1c6c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c6f:	89 04 24             	mov    %eax,(%esp)
    1c72:	e8 b5 23 00 00       	call   402c <open>
    1c77:	89 04 24             	mov    %eax,(%esp)
    1c7a:	e8 95 23 00 00       	call   4014 <close>
      close(open(file, 0));
    1c7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c86:	00 
    1c87:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c8a:	89 04 24             	mov    %eax,(%esp)
    1c8d:	e8 9a 23 00 00       	call   402c <open>
    1c92:	89 04 24             	mov    %eax,(%esp)
    1c95:	e8 7a 23 00 00       	call   4014 <close>
      close(open(file, 0));
    1c9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1ca1:	00 
    1ca2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1ca5:	89 04 24             	mov    %eax,(%esp)
    1ca8:	e8 7f 23 00 00       	call   402c <open>
    1cad:	89 04 24             	mov    %eax,(%esp)
    1cb0:	e8 5f 23 00 00       	call   4014 <close>
    1cb5:	eb 2c                	jmp    1ce3 <concreate+0x3cb>
    } else {
      unlink(file);
    1cb7:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cba:	89 04 24             	mov    %eax,(%esp)
    1cbd:	e8 7a 23 00 00       	call   403c <unlink>
      unlink(file);
    1cc2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cc5:	89 04 24             	mov    %eax,(%esp)
    1cc8:	e8 6f 23 00 00       	call   403c <unlink>
      unlink(file);
    1ccd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cd0:	89 04 24             	mov    %eax,(%esp)
    1cd3:	e8 64 23 00 00       	call   403c <unlink>
      unlink(file);
    1cd8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1cdb:	89 04 24             	mov    %eax,(%esp)
    1cde:	e8 59 23 00 00       	call   403c <unlink>
    }
    if(pid == 0)
    1ce3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ce7:	75 05                	jne    1cee <concreate+0x3d6>
      exit();
    1ce9:	e8 fe 22 00 00       	call   3fec <exit>
    else
      wait();
    1cee:	e8 01 23 00 00       	call   3ff4 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1cf3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cf7:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1cfb:	0f 8e c9 fe ff ff    	jle    1bca <concreate+0x2b2>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1d01:	c7 44 24 04 b9 4e 00 	movl   $0x4eb9,0x4(%esp)
    1d08:	00 
    1d09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d10:	e8 77 24 00 00       	call   418c <printf>
}
    1d15:	c9                   	leave  
    1d16:	c3                   	ret    

00001d17 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1d17:	55                   	push   %ebp
    1d18:	89 e5                	mov    %esp,%ebp
    1d1a:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1d1d:	c7 44 24 04 c7 4e 00 	movl   $0x4ec7,0x4(%esp)
    1d24:	00 
    1d25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d2c:	e8 5b 24 00 00       	call   418c <printf>

  unlink("x");
    1d31:	c7 04 24 2f 4a 00 00 	movl   $0x4a2f,(%esp)
    1d38:	e8 ff 22 00 00       	call   403c <unlink>
  pid = fork();
    1d3d:	e8 a2 22 00 00       	call   3fe4 <fork>
    1d42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d49:	79 19                	jns    1d64 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d4b:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
    1d52:	00 
    1d53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d5a:	e8 2d 24 00 00       	call   418c <printf>
    exit();
    1d5f:	e8 88 22 00 00       	call   3fec <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d68:	74 07                	je     1d71 <linkunlink+0x5a>
    1d6a:	b8 01 00 00 00       	mov    $0x1,%eax
    1d6f:	eb 05                	jmp    1d76 <linkunlink+0x5f>
    1d71:	b8 61 00 00 00       	mov    $0x61,%eax
    1d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d80:	e9 8e 00 00 00       	jmp    1e13 <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d88:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d8e:	05 39 30 00 00       	add    $0x3039,%eax
    1d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d96:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d99:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d9e:	89 c8                	mov    %ecx,%eax
    1da0:	f7 e2                	mul    %edx
    1da2:	d1 ea                	shr    %edx
    1da4:	89 d0                	mov    %edx,%eax
    1da6:	01 c0                	add    %eax,%eax
    1da8:	01 d0                	add    %edx,%eax
    1daa:	29 c1                	sub    %eax,%ecx
    1dac:	89 ca                	mov    %ecx,%edx
    1dae:	85 d2                	test   %edx,%edx
    1db0:	75 1e                	jne    1dd0 <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1db2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1db9:	00 
    1dba:	c7 04 24 2f 4a 00 00 	movl   $0x4a2f,(%esp)
    1dc1:	e8 66 22 00 00       	call   402c <open>
    1dc6:	89 04 24             	mov    %eax,(%esp)
    1dc9:	e8 46 22 00 00       	call   4014 <close>
    1dce:	eb 3f                	jmp    1e0f <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1dd0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1dd3:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1dd8:	89 c8                	mov    %ecx,%eax
    1dda:	f7 e2                	mul    %edx
    1ddc:	d1 ea                	shr    %edx
    1dde:	89 d0                	mov    %edx,%eax
    1de0:	01 c0                	add    %eax,%eax
    1de2:	01 d0                	add    %edx,%eax
    1de4:	29 c1                	sub    %eax,%ecx
    1de6:	89 ca                	mov    %ecx,%edx
    1de8:	83 fa 01             	cmp    $0x1,%edx
    1deb:	75 16                	jne    1e03 <linkunlink+0xec>
      link("cat", "x");
    1ded:	c7 44 24 04 2f 4a 00 	movl   $0x4a2f,0x4(%esp)
    1df4:	00 
    1df5:	c7 04 24 d8 4e 00 00 	movl   $0x4ed8,(%esp)
    1dfc:	e8 4b 22 00 00       	call   404c <link>
    1e01:	eb 0c                	jmp    1e0f <linkunlink+0xf8>
    } else {
      unlink("x");
    1e03:	c7 04 24 2f 4a 00 00 	movl   $0x4a2f,(%esp)
    1e0a:	e8 2d 22 00 00       	call   403c <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1e0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1e13:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1e17:	0f 8e 68 ff ff ff    	jle    1d85 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1e1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1e21:	74 07                	je     1e2a <linkunlink+0x113>
    wait();
    1e23:	e8 cc 21 00 00       	call   3ff4 <wait>
    1e28:	eb 05                	jmp    1e2f <linkunlink+0x118>
  else 
    exit();
    1e2a:	e8 bd 21 00 00       	call   3fec <exit>

  printf(1, "linkunlink ok\n");
    1e2f:	c7 44 24 04 dc 4e 00 	movl   $0x4edc,0x4(%esp)
    1e36:	00 
    1e37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e3e:	e8 49 23 00 00       	call   418c <printf>
}
    1e43:	c9                   	leave  
    1e44:	c3                   	ret    

00001e45 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e45:	55                   	push   %ebp
    1e46:	89 e5                	mov    %esp,%ebp
    1e48:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e4b:	c7 44 24 04 eb 4e 00 	movl   $0x4eeb,0x4(%esp)
    1e52:	00 
    1e53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e5a:	e8 2d 23 00 00       	call   418c <printf>
  unlink("bd");
    1e5f:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    1e66:	e8 d1 21 00 00       	call   403c <unlink>

  fd = open("bd", O_CREATE);
    1e6b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e72:	00 
    1e73:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    1e7a:	e8 ad 21 00 00       	call   402c <open>
    1e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e86:	79 19                	jns    1ea1 <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1e88:	c7 44 24 04 fb 4e 00 	movl   $0x4efb,0x4(%esp)
    1e8f:	00 
    1e90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e97:	e8 f0 22 00 00       	call   418c <printf>
    exit();
    1e9c:	e8 4b 21 00 00       	call   3fec <exit>
  }
  close(fd);
    1ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ea4:	89 04 24             	mov    %eax,(%esp)
    1ea7:	e8 68 21 00 00       	call   4014 <close>

  for(i = 0; i < 500; i++){
    1eac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1eb3:	eb 64                	jmp    1f19 <bigdir+0xd4>
    name[0] = 'x';
    1eb5:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ebc:	8d 50 3f             	lea    0x3f(%eax),%edx
    1ebf:	85 c0                	test   %eax,%eax
    1ec1:	0f 48 c2             	cmovs  %edx,%eax
    1ec4:	c1 f8 06             	sar    $0x6,%eax
    1ec7:	83 c0 30             	add    $0x30,%eax
    1eca:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ed0:	99                   	cltd   
    1ed1:	c1 ea 1a             	shr    $0x1a,%edx
    1ed4:	01 d0                	add    %edx,%eax
    1ed6:	83 e0 3f             	and    $0x3f,%eax
    1ed9:	29 d0                	sub    %edx,%eax
    1edb:	83 c0 30             	add    $0x30,%eax
    1ede:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1ee1:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1ee5:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
    1eec:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    1ef3:	e8 54 21 00 00       	call   404c <link>
    1ef8:	85 c0                	test   %eax,%eax
    1efa:	74 19                	je     1f15 <bigdir+0xd0>
      printf(1, "bigdir link failed\n");
    1efc:	c7 44 24 04 11 4f 00 	movl   $0x4f11,0x4(%esp)
    1f03:	00 
    1f04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f0b:	e8 7c 22 00 00       	call   418c <printf>
      exit();
    1f10:	e8 d7 20 00 00       	call   3fec <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1f15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f19:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f20:	7e 93                	jle    1eb5 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1f22:	c7 04 24 f8 4e 00 00 	movl   $0x4ef8,(%esp)
    1f29:	e8 0e 21 00 00       	call   403c <unlink>
  for(i = 0; i < 500; i++){
    1f2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f35:	eb 5c                	jmp    1f93 <bigdir+0x14e>
    name[0] = 'x';
    1f37:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f3e:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f41:	85 c0                	test   %eax,%eax
    1f43:	0f 48 c2             	cmovs  %edx,%eax
    1f46:	c1 f8 06             	sar    $0x6,%eax
    1f49:	83 c0 30             	add    $0x30,%eax
    1f4c:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f52:	99                   	cltd   
    1f53:	c1 ea 1a             	shr    $0x1a,%edx
    1f56:	01 d0                	add    %edx,%eax
    1f58:	83 e0 3f             	and    $0x3f,%eax
    1f5b:	29 d0                	sub    %edx,%eax
    1f5d:	83 c0 30             	add    $0x30,%eax
    1f60:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f63:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f67:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f6a:	89 04 24             	mov    %eax,(%esp)
    1f6d:	e8 ca 20 00 00       	call   403c <unlink>
    1f72:	85 c0                	test   %eax,%eax
    1f74:	74 19                	je     1f8f <bigdir+0x14a>
      printf(1, "bigdir unlink failed");
    1f76:	c7 44 24 04 25 4f 00 	movl   $0x4f25,0x4(%esp)
    1f7d:	00 
    1f7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f85:	e8 02 22 00 00       	call   418c <printf>
      exit();
    1f8a:	e8 5d 20 00 00       	call   3fec <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f93:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f9a:	7e 9b                	jle    1f37 <bigdir+0xf2>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f9c:	c7 44 24 04 3a 4f 00 	movl   $0x4f3a,0x4(%esp)
    1fa3:	00 
    1fa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fab:	e8 dc 21 00 00       	call   418c <printf>
}
    1fb0:	c9                   	leave  
    1fb1:	c3                   	ret    

00001fb2 <subdir>:

void
subdir(void)
{
    1fb2:	55                   	push   %ebp
    1fb3:	89 e5                	mov    %esp,%ebp
    1fb5:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1fb8:	c7 44 24 04 45 4f 00 	movl   $0x4f45,0x4(%esp)
    1fbf:	00 
    1fc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fc7:	e8 c0 21 00 00       	call   418c <printf>

  unlink("ff");
    1fcc:	c7 04 24 52 4f 00 00 	movl   $0x4f52,(%esp)
    1fd3:	e8 64 20 00 00       	call   403c <unlink>
  if(mkdir("dd") != 0){
    1fd8:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    1fdf:	e8 70 20 00 00       	call   4054 <mkdir>
    1fe4:	85 c0                	test   %eax,%eax
    1fe6:	74 19                	je     2001 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1fe8:	c7 44 24 04 58 4f 00 	movl   $0x4f58,0x4(%esp)
    1fef:	00 
    1ff0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ff7:	e8 90 21 00 00       	call   418c <printf>
    exit();
    1ffc:	e8 eb 1f 00 00       	call   3fec <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2001:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2008:	00 
    2009:	c7 04 24 70 4f 00 00 	movl   $0x4f70,(%esp)
    2010:	e8 17 20 00 00       	call   402c <open>
    2015:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    201c:	79 19                	jns    2037 <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    201e:	c7 44 24 04 76 4f 00 	movl   $0x4f76,0x4(%esp)
    2025:	00 
    2026:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    202d:	e8 5a 21 00 00       	call   418c <printf>
    exit();
    2032:	e8 b5 1f 00 00       	call   3fec <exit>
  }
  write(fd, "ff", 2);
    2037:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    203e:	00 
    203f:	c7 44 24 04 52 4f 00 	movl   $0x4f52,0x4(%esp)
    2046:	00 
    2047:	8b 45 f4             	mov    -0xc(%ebp),%eax
    204a:	89 04 24             	mov    %eax,(%esp)
    204d:	e8 ba 1f 00 00       	call   400c <write>
  close(fd);
    2052:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2055:	89 04 24             	mov    %eax,(%esp)
    2058:	e8 b7 1f 00 00       	call   4014 <close>
  
  if(unlink("dd") >= 0){
    205d:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    2064:	e8 d3 1f 00 00       	call   403c <unlink>
    2069:	85 c0                	test   %eax,%eax
    206b:	78 19                	js     2086 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    206d:	c7 44 24 04 8c 4f 00 	movl   $0x4f8c,0x4(%esp)
    2074:	00 
    2075:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    207c:	e8 0b 21 00 00       	call   418c <printf>
    exit();
    2081:	e8 66 1f 00 00       	call   3fec <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2086:	c7 04 24 b2 4f 00 00 	movl   $0x4fb2,(%esp)
    208d:	e8 c2 1f 00 00       	call   4054 <mkdir>
    2092:	85 c0                	test   %eax,%eax
    2094:	74 19                	je     20af <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    2096:	c7 44 24 04 b9 4f 00 	movl   $0x4fb9,0x4(%esp)
    209d:	00 
    209e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20a5:	e8 e2 20 00 00       	call   418c <printf>
    exit();
    20aa:	e8 3d 1f 00 00       	call   3fec <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    20af:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20b6:	00 
    20b7:	c7 04 24 d4 4f 00 00 	movl   $0x4fd4,(%esp)
    20be:	e8 69 1f 00 00       	call   402c <open>
    20c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20ca:	79 19                	jns    20e5 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    20cc:	c7 44 24 04 dd 4f 00 	movl   $0x4fdd,0x4(%esp)
    20d3:	00 
    20d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20db:	e8 ac 20 00 00       	call   418c <printf>
    exit();
    20e0:	e8 07 1f 00 00       	call   3fec <exit>
  }
  write(fd, "FF", 2);
    20e5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    20ec:	00 
    20ed:	c7 44 24 04 f5 4f 00 	movl   $0x4ff5,0x4(%esp)
    20f4:	00 
    20f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20f8:	89 04 24             	mov    %eax,(%esp)
    20fb:	e8 0c 1f 00 00       	call   400c <write>
  close(fd);
    2100:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2103:	89 04 24             	mov    %eax,(%esp)
    2106:	e8 09 1f 00 00       	call   4014 <close>

  fd = open("dd/dd/../ff", 0);
    210b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2112:	00 
    2113:	c7 04 24 f8 4f 00 00 	movl   $0x4ff8,(%esp)
    211a:	e8 0d 1f 00 00       	call   402c <open>
    211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2126:	79 19                	jns    2141 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    2128:	c7 44 24 04 04 50 00 	movl   $0x5004,0x4(%esp)
    212f:	00 
    2130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2137:	e8 50 20 00 00       	call   418c <printf>
    exit();
    213c:	e8 ab 1e 00 00       	call   3fec <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2141:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2148:	00 
    2149:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    2150:	00 
    2151:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2154:	89 04 24             	mov    %eax,(%esp)
    2157:	e8 a8 1e 00 00       	call   4004 <read>
    215c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    215f:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2163:	75 0b                	jne    2170 <subdir+0x1be>
    2165:	0f b6 05 20 8c 00 00 	movzbl 0x8c20,%eax
    216c:	3c 66                	cmp    $0x66,%al
    216e:	74 19                	je     2189 <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    2170:	c7 44 24 04 1d 50 00 	movl   $0x501d,0x4(%esp)
    2177:	00 
    2178:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    217f:	e8 08 20 00 00       	call   418c <printf>
    exit();
    2184:	e8 63 1e 00 00       	call   3fec <exit>
  }
  close(fd);
    2189:	8b 45 f4             	mov    -0xc(%ebp),%eax
    218c:	89 04 24             	mov    %eax,(%esp)
    218f:	e8 80 1e 00 00       	call   4014 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2194:	c7 44 24 04 38 50 00 	movl   $0x5038,0x4(%esp)
    219b:	00 
    219c:	c7 04 24 d4 4f 00 00 	movl   $0x4fd4,(%esp)
    21a3:	e8 a4 1e 00 00       	call   404c <link>
    21a8:	85 c0                	test   %eax,%eax
    21aa:	74 19                	je     21c5 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    21ac:	c7 44 24 04 44 50 00 	movl   $0x5044,0x4(%esp)
    21b3:	00 
    21b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21bb:	e8 cc 1f 00 00       	call   418c <printf>
    exit();
    21c0:	e8 27 1e 00 00       	call   3fec <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    21c5:	c7 04 24 d4 4f 00 00 	movl   $0x4fd4,(%esp)
    21cc:	e8 6b 1e 00 00       	call   403c <unlink>
    21d1:	85 c0                	test   %eax,%eax
    21d3:	74 19                	je     21ee <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    21d5:	c7 44 24 04 65 50 00 	movl   $0x5065,0x4(%esp)
    21dc:	00 
    21dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21e4:	e8 a3 1f 00 00       	call   418c <printf>
    exit();
    21e9:	e8 fe 1d 00 00       	call   3fec <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21f5:	00 
    21f6:	c7 04 24 d4 4f 00 00 	movl   $0x4fd4,(%esp)
    21fd:	e8 2a 1e 00 00       	call   402c <open>
    2202:	85 c0                	test   %eax,%eax
    2204:	78 19                	js     221f <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2206:	c7 44 24 04 80 50 00 	movl   $0x5080,0x4(%esp)
    220d:	00 
    220e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2215:	e8 72 1f 00 00       	call   418c <printf>
    exit();
    221a:	e8 cd 1d 00 00       	call   3fec <exit>
  }

  if(chdir("dd") != 0){
    221f:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    2226:	e8 31 1e 00 00       	call   405c <chdir>
    222b:	85 c0                	test   %eax,%eax
    222d:	74 19                	je     2248 <subdir+0x296>
    printf(1, "chdir dd failed\n");
    222f:	c7 44 24 04 a4 50 00 	movl   $0x50a4,0x4(%esp)
    2236:	00 
    2237:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    223e:	e8 49 1f 00 00       	call   418c <printf>
    exit();
    2243:	e8 a4 1d 00 00       	call   3fec <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2248:	c7 04 24 b5 50 00 00 	movl   $0x50b5,(%esp)
    224f:	e8 08 1e 00 00       	call   405c <chdir>
    2254:	85 c0                	test   %eax,%eax
    2256:	74 19                	je     2271 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    2258:	c7 44 24 04 c1 50 00 	movl   $0x50c1,0x4(%esp)
    225f:	00 
    2260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2267:	e8 20 1f 00 00       	call   418c <printf>
    exit();
    226c:	e8 7b 1d 00 00       	call   3fec <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2271:	c7 04 24 db 50 00 00 	movl   $0x50db,(%esp)
    2278:	e8 df 1d 00 00       	call   405c <chdir>
    227d:	85 c0                	test   %eax,%eax
    227f:	74 19                	je     229a <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    2281:	c7 44 24 04 c1 50 00 	movl   $0x50c1,0x4(%esp)
    2288:	00 
    2289:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2290:	e8 f7 1e 00 00       	call   418c <printf>
    exit();
    2295:	e8 52 1d 00 00       	call   3fec <exit>
  }
  if(chdir("./..") != 0){
    229a:	c7 04 24 ea 50 00 00 	movl   $0x50ea,(%esp)
    22a1:	e8 b6 1d 00 00       	call   405c <chdir>
    22a6:	85 c0                	test   %eax,%eax
    22a8:	74 19                	je     22c3 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    22aa:	c7 44 24 04 ef 50 00 	movl   $0x50ef,0x4(%esp)
    22b1:	00 
    22b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22b9:	e8 ce 1e 00 00       	call   418c <printf>
    exit();
    22be:	e8 29 1d 00 00       	call   3fec <exit>
  }

  fd = open("dd/dd/ffff", 0);
    22c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    22ca:	00 
    22cb:	c7 04 24 38 50 00 00 	movl   $0x5038,(%esp)
    22d2:	e8 55 1d 00 00       	call   402c <open>
    22d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22de:	79 19                	jns    22f9 <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    22e0:	c7 44 24 04 02 51 00 	movl   $0x5102,0x4(%esp)
    22e7:	00 
    22e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22ef:	e8 98 1e 00 00       	call   418c <printf>
    exit();
    22f4:	e8 f3 1c 00 00       	call   3fec <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22f9:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2300:	00 
    2301:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    2308:	00 
    2309:	8b 45 f4             	mov    -0xc(%ebp),%eax
    230c:	89 04 24             	mov    %eax,(%esp)
    230f:	e8 f0 1c 00 00       	call   4004 <read>
    2314:	83 f8 02             	cmp    $0x2,%eax
    2317:	74 19                	je     2332 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    2319:	c7 44 24 04 1a 51 00 	movl   $0x511a,0x4(%esp)
    2320:	00 
    2321:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2328:	e8 5f 1e 00 00       	call   418c <printf>
    exit();
    232d:	e8 ba 1c 00 00       	call   3fec <exit>
  }
  close(fd);
    2332:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2335:	89 04 24             	mov    %eax,(%esp)
    2338:	e8 d7 1c 00 00       	call   4014 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    233d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2344:	00 
    2345:	c7 04 24 d4 4f 00 00 	movl   $0x4fd4,(%esp)
    234c:	e8 db 1c 00 00       	call   402c <open>
    2351:	85 c0                	test   %eax,%eax
    2353:	78 19                	js     236e <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2355:	c7 44 24 04 38 51 00 	movl   $0x5138,0x4(%esp)
    235c:	00 
    235d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2364:	e8 23 1e 00 00       	call   418c <printf>
    exit();
    2369:	e8 7e 1c 00 00       	call   3fec <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    236e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2375:	00 
    2376:	c7 04 24 5d 51 00 00 	movl   $0x515d,(%esp)
    237d:	e8 aa 1c 00 00       	call   402c <open>
    2382:	85 c0                	test   %eax,%eax
    2384:	78 19                	js     239f <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    2386:	c7 44 24 04 66 51 00 	movl   $0x5166,0x4(%esp)
    238d:	00 
    238e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2395:	e8 f2 1d 00 00       	call   418c <printf>
    exit();
    239a:	e8 4d 1c 00 00       	call   3fec <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    239f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    23a6:	00 
    23a7:	c7 04 24 82 51 00 00 	movl   $0x5182,(%esp)
    23ae:	e8 79 1c 00 00       	call   402c <open>
    23b3:	85 c0                	test   %eax,%eax
    23b5:	78 19                	js     23d0 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    23b7:	c7 44 24 04 8b 51 00 	movl   $0x518b,0x4(%esp)
    23be:	00 
    23bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23c6:	e8 c1 1d 00 00       	call   418c <printf>
    exit();
    23cb:	e8 1c 1c 00 00       	call   3fec <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    23d0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    23d7:	00 
    23d8:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    23df:	e8 48 1c 00 00       	call   402c <open>
    23e4:	85 c0                	test   %eax,%eax
    23e6:	78 19                	js     2401 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    23e8:	c7 44 24 04 a7 51 00 	movl   $0x51a7,0x4(%esp)
    23ef:	00 
    23f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23f7:	e8 90 1d 00 00       	call   418c <printf>
    exit();
    23fc:	e8 eb 1b 00 00       	call   3fec <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    2401:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2408:	00 
    2409:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    2410:	e8 17 1c 00 00       	call   402c <open>
    2415:	85 c0                	test   %eax,%eax
    2417:	78 19                	js     2432 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    2419:	c7 44 24 04 bd 51 00 	movl   $0x51bd,0x4(%esp)
    2420:	00 
    2421:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2428:	e8 5f 1d 00 00       	call   418c <printf>
    exit();
    242d:	e8 ba 1b 00 00       	call   3fec <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2432:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2439:	00 
    243a:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    2441:	e8 e6 1b 00 00       	call   402c <open>
    2446:	85 c0                	test   %eax,%eax
    2448:	78 19                	js     2463 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    244a:	c7 44 24 04 d6 51 00 	movl   $0x51d6,0x4(%esp)
    2451:	00 
    2452:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2459:	e8 2e 1d 00 00       	call   418c <printf>
    exit();
    245e:	e8 89 1b 00 00       	call   3fec <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2463:	c7 44 24 04 f1 51 00 	movl   $0x51f1,0x4(%esp)
    246a:	00 
    246b:	c7 04 24 5d 51 00 00 	movl   $0x515d,(%esp)
    2472:	e8 d5 1b 00 00       	call   404c <link>
    2477:	85 c0                	test   %eax,%eax
    2479:	75 19                	jne    2494 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    247b:	c7 44 24 04 fc 51 00 	movl   $0x51fc,0x4(%esp)
    2482:	00 
    2483:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    248a:	e8 fd 1c 00 00       	call   418c <printf>
    exit();
    248f:	e8 58 1b 00 00       	call   3fec <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2494:	c7 44 24 04 f1 51 00 	movl   $0x51f1,0x4(%esp)
    249b:	00 
    249c:	c7 04 24 82 51 00 00 	movl   $0x5182,(%esp)
    24a3:	e8 a4 1b 00 00       	call   404c <link>
    24a8:	85 c0                	test   %eax,%eax
    24aa:	75 19                	jne    24c5 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    24ac:	c7 44 24 04 20 52 00 	movl   $0x5220,0x4(%esp)
    24b3:	00 
    24b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24bb:	e8 cc 1c 00 00       	call   418c <printf>
    exit();
    24c0:	e8 27 1b 00 00       	call   3fec <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    24c5:	c7 44 24 04 38 50 00 	movl   $0x5038,0x4(%esp)
    24cc:	00 
    24cd:	c7 04 24 70 4f 00 00 	movl   $0x4f70,(%esp)
    24d4:	e8 73 1b 00 00       	call   404c <link>
    24d9:	85 c0                	test   %eax,%eax
    24db:	75 19                	jne    24f6 <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    24dd:	c7 44 24 04 44 52 00 	movl   $0x5244,0x4(%esp)
    24e4:	00 
    24e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24ec:	e8 9b 1c 00 00       	call   418c <printf>
    exit();
    24f1:	e8 f6 1a 00 00       	call   3fec <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24f6:	c7 04 24 5d 51 00 00 	movl   $0x515d,(%esp)
    24fd:	e8 52 1b 00 00       	call   4054 <mkdir>
    2502:	85 c0                	test   %eax,%eax
    2504:	75 19                	jne    251f <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2506:	c7 44 24 04 66 52 00 	movl   $0x5266,0x4(%esp)
    250d:	00 
    250e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2515:	e8 72 1c 00 00       	call   418c <printf>
    exit();
    251a:	e8 cd 1a 00 00       	call   3fec <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    251f:	c7 04 24 82 51 00 00 	movl   $0x5182,(%esp)
    2526:	e8 29 1b 00 00       	call   4054 <mkdir>
    252b:	85 c0                	test   %eax,%eax
    252d:	75 19                	jne    2548 <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    252f:	c7 44 24 04 81 52 00 	movl   $0x5281,0x4(%esp)
    2536:	00 
    2537:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    253e:	e8 49 1c 00 00       	call   418c <printf>
    exit();
    2543:	e8 a4 1a 00 00       	call   3fec <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2548:	c7 04 24 38 50 00 00 	movl   $0x5038,(%esp)
    254f:	e8 00 1b 00 00       	call   4054 <mkdir>
    2554:	85 c0                	test   %eax,%eax
    2556:	75 19                	jne    2571 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2558:	c7 44 24 04 9c 52 00 	movl   $0x529c,0x4(%esp)
    255f:	00 
    2560:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2567:	e8 20 1c 00 00       	call   418c <printf>
    exit();
    256c:	e8 7b 1a 00 00       	call   3fec <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2571:	c7 04 24 82 51 00 00 	movl   $0x5182,(%esp)
    2578:	e8 bf 1a 00 00       	call   403c <unlink>
    257d:	85 c0                	test   %eax,%eax
    257f:	75 19                	jne    259a <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2581:	c7 44 24 04 b9 52 00 	movl   $0x52b9,0x4(%esp)
    2588:	00 
    2589:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2590:	e8 f7 1b 00 00       	call   418c <printf>
    exit();
    2595:	e8 52 1a 00 00       	call   3fec <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    259a:	c7 04 24 5d 51 00 00 	movl   $0x515d,(%esp)
    25a1:	e8 96 1a 00 00       	call   403c <unlink>
    25a6:	85 c0                	test   %eax,%eax
    25a8:	75 19                	jne    25c3 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    25aa:	c7 44 24 04 d5 52 00 	movl   $0x52d5,0x4(%esp)
    25b1:	00 
    25b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25b9:	e8 ce 1b 00 00       	call   418c <printf>
    exit();
    25be:	e8 29 1a 00 00       	call   3fec <exit>
  }
  if(chdir("dd/ff") == 0){
    25c3:	c7 04 24 70 4f 00 00 	movl   $0x4f70,(%esp)
    25ca:	e8 8d 1a 00 00       	call   405c <chdir>
    25cf:	85 c0                	test   %eax,%eax
    25d1:	75 19                	jne    25ec <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    25d3:	c7 44 24 04 f1 52 00 	movl   $0x52f1,0x4(%esp)
    25da:	00 
    25db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e2:	e8 a5 1b 00 00       	call   418c <printf>
    exit();
    25e7:	e8 00 1a 00 00       	call   3fec <exit>
  }
  if(chdir("dd/xx") == 0){
    25ec:	c7 04 24 09 53 00 00 	movl   $0x5309,(%esp)
    25f3:	e8 64 1a 00 00       	call   405c <chdir>
    25f8:	85 c0                	test   %eax,%eax
    25fa:	75 19                	jne    2615 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    25fc:	c7 44 24 04 0f 53 00 	movl   $0x530f,0x4(%esp)
    2603:	00 
    2604:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    260b:	e8 7c 1b 00 00       	call   418c <printf>
    exit();
    2610:	e8 d7 19 00 00       	call   3fec <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2615:	c7 04 24 38 50 00 00 	movl   $0x5038,(%esp)
    261c:	e8 1b 1a 00 00       	call   403c <unlink>
    2621:	85 c0                	test   %eax,%eax
    2623:	74 19                	je     263e <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    2625:	c7 44 24 04 65 50 00 	movl   $0x5065,0x4(%esp)
    262c:	00 
    262d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2634:	e8 53 1b 00 00       	call   418c <printf>
    exit();
    2639:	e8 ae 19 00 00       	call   3fec <exit>
  }
  if(unlink("dd/ff") != 0){
    263e:	c7 04 24 70 4f 00 00 	movl   $0x4f70,(%esp)
    2645:	e8 f2 19 00 00       	call   403c <unlink>
    264a:	85 c0                	test   %eax,%eax
    264c:	74 19                	je     2667 <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    264e:	c7 44 24 04 27 53 00 	movl   $0x5327,0x4(%esp)
    2655:	00 
    2656:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    265d:	e8 2a 1b 00 00       	call   418c <printf>
    exit();
    2662:	e8 85 19 00 00       	call   3fec <exit>
  }
  if(unlink("dd") == 0){
    2667:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    266e:	e8 c9 19 00 00       	call   403c <unlink>
    2673:	85 c0                	test   %eax,%eax
    2675:	75 19                	jne    2690 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    2677:	c7 44 24 04 3c 53 00 	movl   $0x533c,0x4(%esp)
    267e:	00 
    267f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2686:	e8 01 1b 00 00       	call   418c <printf>
    exit();
    268b:	e8 5c 19 00 00       	call   3fec <exit>
  }
  if(unlink("dd/dd") < 0){
    2690:	c7 04 24 5c 53 00 00 	movl   $0x535c,(%esp)
    2697:	e8 a0 19 00 00       	call   403c <unlink>
    269c:	85 c0                	test   %eax,%eax
    269e:	79 19                	jns    26b9 <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    26a0:	c7 44 24 04 62 53 00 	movl   $0x5362,0x4(%esp)
    26a7:	00 
    26a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26af:	e8 d8 1a 00 00       	call   418c <printf>
    exit();
    26b4:	e8 33 19 00 00       	call   3fec <exit>
  }
  if(unlink("dd") < 0){
    26b9:	c7 04 24 55 4f 00 00 	movl   $0x4f55,(%esp)
    26c0:	e8 77 19 00 00       	call   403c <unlink>
    26c5:	85 c0                	test   %eax,%eax
    26c7:	79 19                	jns    26e2 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    26c9:	c7 44 24 04 77 53 00 	movl   $0x5377,0x4(%esp)
    26d0:	00 
    26d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26d8:	e8 af 1a 00 00       	call   418c <printf>
    exit();
    26dd:	e8 0a 19 00 00       	call   3fec <exit>
  }

  printf(1, "subdir ok\n");
    26e2:	c7 44 24 04 89 53 00 	movl   $0x5389,0x4(%esp)
    26e9:	00 
    26ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26f1:	e8 96 1a 00 00       	call   418c <printf>
}
    26f6:	c9                   	leave  
    26f7:	c3                   	ret    

000026f8 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26f8:	55                   	push   %ebp
    26f9:	89 e5                	mov    %esp,%ebp
    26fb:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26fe:	c7 44 24 04 94 53 00 	movl   $0x5394,0x4(%esp)
    2705:	00 
    2706:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    270d:	e8 7a 1a 00 00       	call   418c <printf>

  unlink("bigwrite");
    2712:	c7 04 24 a3 53 00 00 	movl   $0x53a3,(%esp)
    2719:	e8 1e 19 00 00       	call   403c <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    271e:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    2725:	e9 b3 00 00 00       	jmp    27dd <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    272a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2731:	00 
    2732:	c7 04 24 a3 53 00 00 	movl   $0x53a3,(%esp)
    2739:	e8 ee 18 00 00       	call   402c <open>
    273e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2741:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2745:	79 19                	jns    2760 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    2747:	c7 44 24 04 ac 53 00 	movl   $0x53ac,0x4(%esp)
    274e:	00 
    274f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2756:	e8 31 1a 00 00       	call   418c <printf>
      exit();
    275b:	e8 8c 18 00 00       	call   3fec <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2760:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2767:	eb 50                	jmp    27b9 <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    2769:	8b 45 f4             	mov    -0xc(%ebp),%eax
    276c:	89 44 24 08          	mov    %eax,0x8(%esp)
    2770:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    2777:	00 
    2778:	8b 45 ec             	mov    -0x14(%ebp),%eax
    277b:	89 04 24             	mov    %eax,(%esp)
    277e:	e8 89 18 00 00       	call   400c <write>
    2783:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2786:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2789:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    278c:	74 27                	je     27b5 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    278e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2791:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2795:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2798:	89 44 24 08          	mov    %eax,0x8(%esp)
    279c:	c7 44 24 04 c4 53 00 	movl   $0x53c4,0x4(%esp)
    27a3:	00 
    27a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ab:	e8 dc 19 00 00       	call   418c <printf>
        exit();
    27b0:	e8 37 18 00 00       	call   3fec <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    27b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    27b9:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    27bd:	7e aa                	jle    2769 <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    27bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    27c2:	89 04 24             	mov    %eax,(%esp)
    27c5:	e8 4a 18 00 00       	call   4014 <close>
    unlink("bigwrite");
    27ca:	c7 04 24 a3 53 00 00 	movl   $0x53a3,(%esp)
    27d1:	e8 66 18 00 00       	call   403c <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    27d6:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    27dd:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27e4:	0f 8e 40 ff ff ff    	jle    272a <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    27ea:	c7 44 24 04 d6 53 00 	movl   $0x53d6,0x4(%esp)
    27f1:	00 
    27f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27f9:	e8 8e 19 00 00       	call   418c <printf>
}
    27fe:	c9                   	leave  
    27ff:	c3                   	ret    

00002800 <bigfile>:

void
bigfile(void)
{
    2800:	55                   	push   %ebp
    2801:	89 e5                	mov    %esp,%ebp
    2803:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2806:	c7 44 24 04 e3 53 00 	movl   $0x53e3,0x4(%esp)
    280d:	00 
    280e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2815:	e8 72 19 00 00       	call   418c <printf>

  unlink("bigfile");
    281a:	c7 04 24 f1 53 00 00 	movl   $0x53f1,(%esp)
    2821:	e8 16 18 00 00       	call   403c <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2826:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    282d:	00 
    282e:	c7 04 24 f1 53 00 00 	movl   $0x53f1,(%esp)
    2835:	e8 f2 17 00 00       	call   402c <open>
    283a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    283d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2841:	79 19                	jns    285c <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    2843:	c7 44 24 04 f9 53 00 	movl   $0x53f9,0x4(%esp)
    284a:	00 
    284b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2852:	e8 35 19 00 00       	call   418c <printf>
    exit();
    2857:	e8 90 17 00 00       	call   3fec <exit>
  }
  for(i = 0; i < 20; i++){
    285c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2863:	eb 5a                	jmp    28bf <bigfile+0xbf>
    memset(buf, i, 600);
    2865:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    286c:	00 
    286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2870:	89 44 24 04          	mov    %eax,0x4(%esp)
    2874:	c7 04 24 20 8c 00 00 	movl   $0x8c20,(%esp)
    287b:	e8 bf 15 00 00       	call   3e3f <memset>
    if(write(fd, buf, 600) != 600){
    2880:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2887:	00 
    2888:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    288f:	00 
    2890:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2893:	89 04 24             	mov    %eax,(%esp)
    2896:	e8 71 17 00 00       	call   400c <write>
    289b:	3d 58 02 00 00       	cmp    $0x258,%eax
    28a0:	74 19                	je     28bb <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    28a2:	c7 44 24 04 0f 54 00 	movl   $0x540f,0x4(%esp)
    28a9:	00 
    28aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28b1:	e8 d6 18 00 00       	call   418c <printf>
      exit();
    28b6:	e8 31 17 00 00       	call   3fec <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    28bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    28bf:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    28c3:	7e a0                	jle    2865 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    28c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    28c8:	89 04 24             	mov    %eax,(%esp)
    28cb:	e8 44 17 00 00       	call   4014 <close>

  fd = open("bigfile", 0);
    28d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    28d7:	00 
    28d8:	c7 04 24 f1 53 00 00 	movl   $0x53f1,(%esp)
    28df:	e8 48 17 00 00       	call   402c <open>
    28e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28eb:	79 19                	jns    2906 <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    28ed:	c7 44 24 04 25 54 00 	movl   $0x5425,0x4(%esp)
    28f4:	00 
    28f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28fc:	e8 8b 18 00 00       	call   418c <printf>
    exit();
    2901:	e8 e6 16 00 00       	call   3fec <exit>
  }
  total = 0;
    2906:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    290d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2914:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    291b:	00 
    291c:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    2923:	00 
    2924:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2927:	89 04 24             	mov    %eax,(%esp)
    292a:	e8 d5 16 00 00       	call   4004 <read>
    292f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    2932:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2936:	79 19                	jns    2951 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    2938:	c7 44 24 04 3a 54 00 	movl   $0x543a,0x4(%esp)
    293f:	00 
    2940:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2947:	e8 40 18 00 00       	call   418c <printf>
      exit();
    294c:	e8 9b 16 00 00       	call   3fec <exit>
    }
    if(cc == 0)
    2951:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2955:	75 1b                	jne    2972 <bigfile+0x172>
      break;
    2957:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2958:	8b 45 ec             	mov    -0x14(%ebp),%eax
    295b:	89 04 24             	mov    %eax,(%esp)
    295e:	e8 b1 16 00 00       	call   4014 <close>
  if(total != 20*600){
    2963:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    296a:	0f 84 99 00 00 00    	je     2a09 <bigfile+0x209>
    2970:	eb 7e                	jmp    29f0 <bigfile+0x1f0>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    2972:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2979:	74 19                	je     2994 <bigfile+0x194>
      printf(1, "short read bigfile\n");
    297b:	c7 44 24 04 4f 54 00 	movl   $0x544f,0x4(%esp)
    2982:	00 
    2983:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    298a:	e8 fd 17 00 00       	call   418c <printf>
      exit();
    298f:	e8 58 16 00 00       	call   3fec <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2994:	0f b6 05 20 8c 00 00 	movzbl 0x8c20,%eax
    299b:	0f be d0             	movsbl %al,%edx
    299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29a1:	89 c1                	mov    %eax,%ecx
    29a3:	c1 e9 1f             	shr    $0x1f,%ecx
    29a6:	01 c8                	add    %ecx,%eax
    29a8:	d1 f8                	sar    %eax
    29aa:	39 c2                	cmp    %eax,%edx
    29ac:	75 1a                	jne    29c8 <bigfile+0x1c8>
    29ae:	0f b6 05 4b 8d 00 00 	movzbl 0x8d4b,%eax
    29b5:	0f be d0             	movsbl %al,%edx
    29b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29bb:	89 c1                	mov    %eax,%ecx
    29bd:	c1 e9 1f             	shr    $0x1f,%ecx
    29c0:	01 c8                	add    %ecx,%eax
    29c2:	d1 f8                	sar    %eax
    29c4:	39 c2                	cmp    %eax,%edx
    29c6:	74 19                	je     29e1 <bigfile+0x1e1>
      printf(1, "read bigfile wrong data\n");
    29c8:	c7 44 24 04 63 54 00 	movl   $0x5463,0x4(%esp)
    29cf:	00 
    29d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29d7:	e8 b0 17 00 00       	call   418c <printf>
      exit();
    29dc:	e8 0b 16 00 00       	call   3fec <exit>
    }
    total += cc;
    29e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    29e4:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    29e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    29eb:	e9 24 ff ff ff       	jmp    2914 <bigfile+0x114>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    29f0:	c7 44 24 04 7c 54 00 	movl   $0x547c,0x4(%esp)
    29f7:	00 
    29f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ff:	e8 88 17 00 00       	call   418c <printf>
    exit();
    2a04:	e8 e3 15 00 00       	call   3fec <exit>
  }
  unlink("bigfile");
    2a09:	c7 04 24 f1 53 00 00 	movl   $0x53f1,(%esp)
    2a10:	e8 27 16 00 00       	call   403c <unlink>

  printf(1, "bigfile test ok\n");
    2a15:	c7 44 24 04 96 54 00 	movl   $0x5496,0x4(%esp)
    2a1c:	00 
    2a1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a24:	e8 63 17 00 00       	call   418c <printf>
}
    2a29:	c9                   	leave  
    2a2a:	c3                   	ret    

00002a2b <fourteen>:

void
fourteen(void)
{
    2a2b:	55                   	push   %ebp
    2a2c:	89 e5                	mov    %esp,%ebp
    2a2e:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2a31:	c7 44 24 04 a7 54 00 	movl   $0x54a7,0x4(%esp)
    2a38:	00 
    2a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a40:	e8 47 17 00 00       	call   418c <printf>

  if(mkdir("12345678901234") != 0){
    2a45:	c7 04 24 b6 54 00 00 	movl   $0x54b6,(%esp)
    2a4c:	e8 03 16 00 00       	call   4054 <mkdir>
    2a51:	85 c0                	test   %eax,%eax
    2a53:	74 19                	je     2a6e <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a55:	c7 44 24 04 c5 54 00 	movl   $0x54c5,0x4(%esp)
    2a5c:	00 
    2a5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a64:	e8 23 17 00 00       	call   418c <printf>
    exit();
    2a69:	e8 7e 15 00 00       	call   3fec <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a6e:	c7 04 24 e4 54 00 00 	movl   $0x54e4,(%esp)
    2a75:	e8 da 15 00 00       	call   4054 <mkdir>
    2a7a:	85 c0                	test   %eax,%eax
    2a7c:	74 19                	je     2a97 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a7e:	c7 44 24 04 04 55 00 	movl   $0x5504,0x4(%esp)
    2a85:	00 
    2a86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a8d:	e8 fa 16 00 00       	call   418c <printf>
    exit();
    2a92:	e8 55 15 00 00       	call   3fec <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a97:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a9e:	00 
    2a9f:	c7 04 24 34 55 00 00 	movl   $0x5534,(%esp)
    2aa6:	e8 81 15 00 00       	call   402c <open>
    2aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ab2:	79 19                	jns    2acd <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2ab4:	c7 44 24 04 64 55 00 	movl   $0x5564,0x4(%esp)
    2abb:	00 
    2abc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ac3:	e8 c4 16 00 00       	call   418c <printf>
    exit();
    2ac8:	e8 1f 15 00 00       	call   3fec <exit>
  }
  close(fd);
    2acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ad0:	89 04 24             	mov    %eax,(%esp)
    2ad3:	e8 3c 15 00 00       	call   4014 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2ad8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2adf:	00 
    2ae0:	c7 04 24 a4 55 00 00 	movl   $0x55a4,(%esp)
    2ae7:	e8 40 15 00 00       	call   402c <open>
    2aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2af3:	79 19                	jns    2b0e <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2af5:	c7 44 24 04 d4 55 00 	movl   $0x55d4,0x4(%esp)
    2afc:	00 
    2afd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b04:	e8 83 16 00 00       	call   418c <printf>
    exit();
    2b09:	e8 de 14 00 00       	call   3fec <exit>
  }
  close(fd);
    2b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b11:	89 04 24             	mov    %eax,(%esp)
    2b14:	e8 fb 14 00 00       	call   4014 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2b19:	c7 04 24 0e 56 00 00 	movl   $0x560e,(%esp)
    2b20:	e8 2f 15 00 00       	call   4054 <mkdir>
    2b25:	85 c0                	test   %eax,%eax
    2b27:	75 19                	jne    2b42 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2b29:	c7 44 24 04 2c 56 00 	movl   $0x562c,0x4(%esp)
    2b30:	00 
    2b31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b38:	e8 4f 16 00 00       	call   418c <printf>
    exit();
    2b3d:	e8 aa 14 00 00       	call   3fec <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2b42:	c7 04 24 5c 56 00 00 	movl   $0x565c,(%esp)
    2b49:	e8 06 15 00 00       	call   4054 <mkdir>
    2b4e:	85 c0                	test   %eax,%eax
    2b50:	75 19                	jne    2b6b <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b52:	c7 44 24 04 7c 56 00 	movl   $0x567c,0x4(%esp)
    2b59:	00 
    2b5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b61:	e8 26 16 00 00       	call   418c <printf>
    exit();
    2b66:	e8 81 14 00 00       	call   3fec <exit>
  }

  printf(1, "fourteen ok\n");
    2b6b:	c7 44 24 04 ad 56 00 	movl   $0x56ad,0x4(%esp)
    2b72:	00 
    2b73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b7a:	e8 0d 16 00 00       	call   418c <printf>
}
    2b7f:	c9                   	leave  
    2b80:	c3                   	ret    

00002b81 <rmdot>:

void
rmdot(void)
{
    2b81:	55                   	push   %ebp
    2b82:	89 e5                	mov    %esp,%ebp
    2b84:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2b87:	c7 44 24 04 ba 56 00 	movl   $0x56ba,0x4(%esp)
    2b8e:	00 
    2b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b96:	e8 f1 15 00 00       	call   418c <printf>
  if(mkdir("dots") != 0){
    2b9b:	c7 04 24 c6 56 00 00 	movl   $0x56c6,(%esp)
    2ba2:	e8 ad 14 00 00       	call   4054 <mkdir>
    2ba7:	85 c0                	test   %eax,%eax
    2ba9:	74 19                	je     2bc4 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2bab:	c7 44 24 04 cb 56 00 	movl   $0x56cb,0x4(%esp)
    2bb2:	00 
    2bb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bba:	e8 cd 15 00 00       	call   418c <printf>
    exit();
    2bbf:	e8 28 14 00 00       	call   3fec <exit>
  }
  if(chdir("dots") != 0){
    2bc4:	c7 04 24 c6 56 00 00 	movl   $0x56c6,(%esp)
    2bcb:	e8 8c 14 00 00       	call   405c <chdir>
    2bd0:	85 c0                	test   %eax,%eax
    2bd2:	74 19                	je     2bed <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2bd4:	c7 44 24 04 de 56 00 	movl   $0x56de,0x4(%esp)
    2bdb:	00 
    2bdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2be3:	e8 a4 15 00 00       	call   418c <printf>
    exit();
    2be8:	e8 ff 13 00 00       	call   3fec <exit>
  }
  if(unlink(".") == 0){
    2bed:	c7 04 24 e3 4d 00 00 	movl   $0x4de3,(%esp)
    2bf4:	e8 43 14 00 00       	call   403c <unlink>
    2bf9:	85 c0                	test   %eax,%eax
    2bfb:	75 19                	jne    2c16 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2bfd:	c7 44 24 04 f1 56 00 	movl   $0x56f1,0x4(%esp)
    2c04:	00 
    2c05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c0c:	e8 7b 15 00 00       	call   418c <printf>
    exit();
    2c11:	e8 d6 13 00 00       	call   3fec <exit>
  }
  if(unlink("..") == 0){
    2c16:	c7 04 24 76 49 00 00 	movl   $0x4976,(%esp)
    2c1d:	e8 1a 14 00 00       	call   403c <unlink>
    2c22:	85 c0                	test   %eax,%eax
    2c24:	75 19                	jne    2c3f <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2c26:	c7 44 24 04 ff 56 00 	movl   $0x56ff,0x4(%esp)
    2c2d:	00 
    2c2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c35:	e8 52 15 00 00       	call   418c <printf>
    exit();
    2c3a:	e8 ad 13 00 00       	call   3fec <exit>
  }
  if(chdir("/") != 0){
    2c3f:	c7 04 24 ca 45 00 00 	movl   $0x45ca,(%esp)
    2c46:	e8 11 14 00 00       	call   405c <chdir>
    2c4b:	85 c0                	test   %eax,%eax
    2c4d:	74 19                	je     2c68 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2c4f:	c7 44 24 04 cc 45 00 	movl   $0x45cc,0x4(%esp)
    2c56:	00 
    2c57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c5e:	e8 29 15 00 00       	call   418c <printf>
    exit();
    2c63:	e8 84 13 00 00       	call   3fec <exit>
  }
  if(unlink("dots/.") == 0){
    2c68:	c7 04 24 0e 57 00 00 	movl   $0x570e,(%esp)
    2c6f:	e8 c8 13 00 00       	call   403c <unlink>
    2c74:	85 c0                	test   %eax,%eax
    2c76:	75 19                	jne    2c91 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2c78:	c7 44 24 04 15 57 00 	movl   $0x5715,0x4(%esp)
    2c7f:	00 
    2c80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c87:	e8 00 15 00 00       	call   418c <printf>
    exit();
    2c8c:	e8 5b 13 00 00       	call   3fec <exit>
  }
  if(unlink("dots/..") == 0){
    2c91:	c7 04 24 2c 57 00 00 	movl   $0x572c,(%esp)
    2c98:	e8 9f 13 00 00       	call   403c <unlink>
    2c9d:	85 c0                	test   %eax,%eax
    2c9f:	75 19                	jne    2cba <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2ca1:	c7 44 24 04 34 57 00 	movl   $0x5734,0x4(%esp)
    2ca8:	00 
    2ca9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cb0:	e8 d7 14 00 00       	call   418c <printf>
    exit();
    2cb5:	e8 32 13 00 00       	call   3fec <exit>
  }
  if(unlink("dots") != 0){
    2cba:	c7 04 24 c6 56 00 00 	movl   $0x56c6,(%esp)
    2cc1:	e8 76 13 00 00       	call   403c <unlink>
    2cc6:	85 c0                	test   %eax,%eax
    2cc8:	74 19                	je     2ce3 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2cca:	c7 44 24 04 4c 57 00 	movl   $0x574c,0x4(%esp)
    2cd1:	00 
    2cd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cd9:	e8 ae 14 00 00       	call   418c <printf>
    exit();
    2cde:	e8 09 13 00 00       	call   3fec <exit>
  }
  printf(1, "rmdot ok\n");
    2ce3:	c7 44 24 04 61 57 00 	movl   $0x5761,0x4(%esp)
    2cea:	00 
    2ceb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cf2:	e8 95 14 00 00       	call   418c <printf>
}
    2cf7:	c9                   	leave  
    2cf8:	c3                   	ret    

00002cf9 <dirfile>:

void
dirfile(void)
{
    2cf9:	55                   	push   %ebp
    2cfa:	89 e5                	mov    %esp,%ebp
    2cfc:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cff:	c7 44 24 04 6b 57 00 	movl   $0x576b,0x4(%esp)
    2d06:	00 
    2d07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d0e:	e8 79 14 00 00       	call   418c <printf>

  fd = open("dirfile", O_CREATE);
    2d13:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d1a:	00 
    2d1b:	c7 04 24 78 57 00 00 	movl   $0x5778,(%esp)
    2d22:	e8 05 13 00 00       	call   402c <open>
    2d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2d2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d2e:	79 19                	jns    2d49 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2d30:	c7 44 24 04 80 57 00 	movl   $0x5780,0x4(%esp)
    2d37:	00 
    2d38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d3f:	e8 48 14 00 00       	call   418c <printf>
    exit();
    2d44:	e8 a3 12 00 00       	call   3fec <exit>
  }
  close(fd);
    2d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d4c:	89 04 24             	mov    %eax,(%esp)
    2d4f:	e8 c0 12 00 00       	call   4014 <close>
  if(chdir("dirfile") == 0){
    2d54:	c7 04 24 78 57 00 00 	movl   $0x5778,(%esp)
    2d5b:	e8 fc 12 00 00       	call   405c <chdir>
    2d60:	85 c0                	test   %eax,%eax
    2d62:	75 19                	jne    2d7d <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2d64:	c7 44 24 04 97 57 00 	movl   $0x5797,0x4(%esp)
    2d6b:	00 
    2d6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d73:	e8 14 14 00 00       	call   418c <printf>
    exit();
    2d78:	e8 6f 12 00 00       	call   3fec <exit>
  }
  fd = open("dirfile/xx", 0);
    2d7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d84:	00 
    2d85:	c7 04 24 b1 57 00 00 	movl   $0x57b1,(%esp)
    2d8c:	e8 9b 12 00 00       	call   402c <open>
    2d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d98:	78 19                	js     2db3 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2d9a:	c7 44 24 04 bc 57 00 	movl   $0x57bc,0x4(%esp)
    2da1:	00 
    2da2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2da9:	e8 de 13 00 00       	call   418c <printf>
    exit();
    2dae:	e8 39 12 00 00       	call   3fec <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2db3:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2dba:	00 
    2dbb:	c7 04 24 b1 57 00 00 	movl   $0x57b1,(%esp)
    2dc2:	e8 65 12 00 00       	call   402c <open>
    2dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2dce:	78 19                	js     2de9 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2dd0:	c7 44 24 04 bc 57 00 	movl   $0x57bc,0x4(%esp)
    2dd7:	00 
    2dd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ddf:	e8 a8 13 00 00       	call   418c <printf>
    exit();
    2de4:	e8 03 12 00 00       	call   3fec <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2de9:	c7 04 24 b1 57 00 00 	movl   $0x57b1,(%esp)
    2df0:	e8 5f 12 00 00       	call   4054 <mkdir>
    2df5:	85 c0                	test   %eax,%eax
    2df7:	75 19                	jne    2e12 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2df9:	c7 44 24 04 da 57 00 	movl   $0x57da,0x4(%esp)
    2e00:	00 
    2e01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e08:	e8 7f 13 00 00       	call   418c <printf>
    exit();
    2e0d:	e8 da 11 00 00       	call   3fec <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2e12:	c7 04 24 b1 57 00 00 	movl   $0x57b1,(%esp)
    2e19:	e8 1e 12 00 00       	call   403c <unlink>
    2e1e:	85 c0                	test   %eax,%eax
    2e20:	75 19                	jne    2e3b <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2e22:	c7 44 24 04 f7 57 00 	movl   $0x57f7,0x4(%esp)
    2e29:	00 
    2e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e31:	e8 56 13 00 00       	call   418c <printf>
    exit();
    2e36:	e8 b1 11 00 00       	call   3fec <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2e3b:	c7 44 24 04 b1 57 00 	movl   $0x57b1,0x4(%esp)
    2e42:	00 
    2e43:	c7 04 24 15 58 00 00 	movl   $0x5815,(%esp)
    2e4a:	e8 fd 11 00 00       	call   404c <link>
    2e4f:	85 c0                	test   %eax,%eax
    2e51:	75 19                	jne    2e6c <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e53:	c7 44 24 04 1c 58 00 	movl   $0x581c,0x4(%esp)
    2e5a:	00 
    2e5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e62:	e8 25 13 00 00       	call   418c <printf>
    exit();
    2e67:	e8 80 11 00 00       	call   3fec <exit>
  }
  if(unlink("dirfile") != 0){
    2e6c:	c7 04 24 78 57 00 00 	movl   $0x5778,(%esp)
    2e73:	e8 c4 11 00 00       	call   403c <unlink>
    2e78:	85 c0                	test   %eax,%eax
    2e7a:	74 19                	je     2e95 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2e7c:	c7 44 24 04 3b 58 00 	movl   $0x583b,0x4(%esp)
    2e83:	00 
    2e84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e8b:	e8 fc 12 00 00       	call   418c <printf>
    exit();
    2e90:	e8 57 11 00 00       	call   3fec <exit>
  }

  fd = open(".", O_RDWR);
    2e95:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2e9c:	00 
    2e9d:	c7 04 24 e3 4d 00 00 	movl   $0x4de3,(%esp)
    2ea4:	e8 83 11 00 00       	call   402c <open>
    2ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2eb0:	78 19                	js     2ecb <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2eb2:	c7 44 24 04 54 58 00 	movl   $0x5854,0x4(%esp)
    2eb9:	00 
    2eba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ec1:	e8 c6 12 00 00       	call   418c <printf>
    exit();
    2ec6:	e8 21 11 00 00       	call   3fec <exit>
  }
  fd = open(".", 0);
    2ecb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2ed2:	00 
    2ed3:	c7 04 24 e3 4d 00 00 	movl   $0x4de3,(%esp)
    2eda:	e8 4d 11 00 00       	call   402c <open>
    2edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2ee2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2ee9:	00 
    2eea:	c7 44 24 04 2f 4a 00 	movl   $0x4a2f,0x4(%esp)
    2ef1:	00 
    2ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ef5:	89 04 24             	mov    %eax,(%esp)
    2ef8:	e8 0f 11 00 00       	call   400c <write>
    2efd:	85 c0                	test   %eax,%eax
    2eff:	7e 19                	jle    2f1a <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2f01:	c7 44 24 04 73 58 00 	movl   $0x5873,0x4(%esp)
    2f08:	00 
    2f09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f10:	e8 77 12 00 00       	call   418c <printf>
    exit();
    2f15:	e8 d2 10 00 00       	call   3fec <exit>
  }
  close(fd);
    2f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f1d:	89 04 24             	mov    %eax,(%esp)
    2f20:	e8 ef 10 00 00       	call   4014 <close>

  printf(1, "dir vs file OK\n");
    2f25:	c7 44 24 04 87 58 00 	movl   $0x5887,0x4(%esp)
    2f2c:	00 
    2f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f34:	e8 53 12 00 00       	call   418c <printf>
}
    2f39:	c9                   	leave  
    2f3a:	c3                   	ret    

00002f3b <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f3b:	55                   	push   %ebp
    2f3c:	89 e5                	mov    %esp,%ebp
    2f3e:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2f41:	c7 44 24 04 97 58 00 	movl   $0x5897,0x4(%esp)
    2f48:	00 
    2f49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f50:	e8 37 12 00 00       	call   418c <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f5c:	e9 d2 00 00 00       	jmp    3033 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2f61:	c7 04 24 a8 58 00 00 	movl   $0x58a8,(%esp)
    2f68:	e8 e7 10 00 00       	call   4054 <mkdir>
    2f6d:	85 c0                	test   %eax,%eax
    2f6f:	74 19                	je     2f8a <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f71:	c7 44 24 04 ae 58 00 	movl   $0x58ae,0x4(%esp)
    2f78:	00 
    2f79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f80:	e8 07 12 00 00       	call   418c <printf>
      exit();
    2f85:	e8 62 10 00 00       	call   3fec <exit>
    }
    if(chdir("irefd") != 0){
    2f8a:	c7 04 24 a8 58 00 00 	movl   $0x58a8,(%esp)
    2f91:	e8 c6 10 00 00       	call   405c <chdir>
    2f96:	85 c0                	test   %eax,%eax
    2f98:	74 19                	je     2fb3 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2f9a:	c7 44 24 04 c2 58 00 	movl   $0x58c2,0x4(%esp)
    2fa1:	00 
    2fa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fa9:	e8 de 11 00 00       	call   418c <printf>
      exit();
    2fae:	e8 39 10 00 00       	call   3fec <exit>
    }

    mkdir("");
    2fb3:	c7 04 24 d6 58 00 00 	movl   $0x58d6,(%esp)
    2fba:	e8 95 10 00 00       	call   4054 <mkdir>
    link("README", "");
    2fbf:	c7 44 24 04 d6 58 00 	movl   $0x58d6,0x4(%esp)
    2fc6:	00 
    2fc7:	c7 04 24 15 58 00 00 	movl   $0x5815,(%esp)
    2fce:	e8 79 10 00 00       	call   404c <link>
    fd = open("", O_CREATE);
    2fd3:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2fda:	00 
    2fdb:	c7 04 24 d6 58 00 00 	movl   $0x58d6,(%esp)
    2fe2:	e8 45 10 00 00       	call   402c <open>
    2fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fee:	78 0b                	js     2ffb <iref+0xc0>
      close(fd);
    2ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2ff3:	89 04 24             	mov    %eax,(%esp)
    2ff6:	e8 19 10 00 00       	call   4014 <close>
    fd = open("xx", O_CREATE);
    2ffb:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3002:	00 
    3003:	c7 04 24 d7 58 00 00 	movl   $0x58d7,(%esp)
    300a:	e8 1d 10 00 00       	call   402c <open>
    300f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3016:	78 0b                	js     3023 <iref+0xe8>
      close(fd);
    3018:	8b 45 f0             	mov    -0x10(%ebp),%eax
    301b:	89 04 24             	mov    %eax,(%esp)
    301e:	e8 f1 0f 00 00       	call   4014 <close>
    unlink("xx");
    3023:	c7 04 24 d7 58 00 00 	movl   $0x58d7,(%esp)
    302a:	e8 0d 10 00 00       	call   403c <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    302f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3033:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3037:	0f 8e 24 ff ff ff    	jle    2f61 <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    303d:	c7 04 24 ca 45 00 00 	movl   $0x45ca,(%esp)
    3044:	e8 13 10 00 00       	call   405c <chdir>
  printf(1, "empty file name OK\n");
    3049:	c7 44 24 04 da 58 00 	movl   $0x58da,0x4(%esp)
    3050:	00 
    3051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3058:	e8 2f 11 00 00       	call   418c <printf>
}
    305d:	c9                   	leave  
    305e:	c3                   	ret    

0000305f <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    305f:	55                   	push   %ebp
    3060:	89 e5                	mov    %esp,%ebp
    3062:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3065:	c7 44 24 04 ee 58 00 	movl   $0x58ee,0x4(%esp)
    306c:	00 
    306d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3074:	e8 13 11 00 00       	call   418c <printf>

  for(n=0; n<1000; n++){
    3079:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3080:	eb 1f                	jmp    30a1 <forktest+0x42>
    pid = fork();
    3082:	e8 5d 0f 00 00       	call   3fe4 <fork>
    3087:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    308a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    308e:	79 02                	jns    3092 <forktest+0x33>
      break;
    3090:	eb 18                	jmp    30aa <forktest+0x4b>
    if(pid == 0)
    3092:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3096:	75 05                	jne    309d <forktest+0x3e>
      exit();
    3098:	e8 4f 0f 00 00       	call   3fec <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    309d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    30a1:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    30a8:	7e d8                	jle    3082 <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    30aa:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    30b1:	75 19                	jne    30cc <forktest+0x6d>
    printf(1, "fork claimed to work 1000 times!\n");
    30b3:	c7 44 24 04 fc 58 00 	movl   $0x58fc,0x4(%esp)
    30ba:	00 
    30bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30c2:	e8 c5 10 00 00       	call   418c <printf>
    exit();
    30c7:	e8 20 0f 00 00       	call   3fec <exit>
  }
  
  for(; n > 0; n--){
    30cc:	eb 26                	jmp    30f4 <forktest+0x95>
    if(wait() < 0){
    30ce:	e8 21 0f 00 00       	call   3ff4 <wait>
    30d3:	85 c0                	test   %eax,%eax
    30d5:	79 19                	jns    30f0 <forktest+0x91>
      printf(1, "wait stopped early\n");
    30d7:	c7 44 24 04 1e 59 00 	movl   $0x591e,0x4(%esp)
    30de:	00 
    30df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30e6:	e8 a1 10 00 00       	call   418c <printf>
      exit();
    30eb:	e8 fc 0e 00 00       	call   3fec <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    30f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30f8:	7f d4                	jg     30ce <forktest+0x6f>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30fa:	e8 f5 0e 00 00       	call   3ff4 <wait>
    30ff:	83 f8 ff             	cmp    $0xffffffff,%eax
    3102:	74 19                	je     311d <forktest+0xbe>
    printf(1, "wait got too many\n");
    3104:	c7 44 24 04 32 59 00 	movl   $0x5932,0x4(%esp)
    310b:	00 
    310c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3113:	e8 74 10 00 00       	call   418c <printf>
    exit();
    3118:	e8 cf 0e 00 00       	call   3fec <exit>
  }
  
  printf(1, "fork test OK\n");
    311d:	c7 44 24 04 45 59 00 	movl   $0x5945,0x4(%esp)
    3124:	00 
    3125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    312c:	e8 5b 10 00 00       	call   418c <printf>
}
    3131:	c9                   	leave  
    3132:	c3                   	ret    

00003133 <sbrktest>:

void
sbrktest(void)
{
    3133:	55                   	push   %ebp
    3134:	89 e5                	mov    %esp,%ebp
    3136:	53                   	push   %ebx
    3137:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    313d:	a1 40 64 00 00       	mov    0x6440,%eax
    3142:	c7 44 24 04 53 59 00 	movl   $0x5953,0x4(%esp)
    3149:	00 
    314a:	89 04 24             	mov    %eax,(%esp)
    314d:	e8 3a 10 00 00       	call   418c <printf>
  oldbrk = sbrk(0);
    3152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3159:	e8 16 0f 00 00       	call   4074 <sbrk>
    315e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3161:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3168:	e8 07 0f 00 00       	call   4074 <sbrk>
    316d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    3170:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3177:	eb 59                	jmp    31d2 <sbrktest+0x9f>
    b = sbrk(1);
    3179:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3180:	e8 ef 0e 00 00       	call   4074 <sbrk>
    3185:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3188:	8b 45 e8             	mov    -0x18(%ebp),%eax
    318b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    318e:	74 2f                	je     31bf <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3190:	a1 40 64 00 00       	mov    0x6440,%eax
    3195:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3198:	89 54 24 10          	mov    %edx,0x10(%esp)
    319c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    319f:	89 54 24 0c          	mov    %edx,0xc(%esp)
    31a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
    31a6:	89 54 24 08          	mov    %edx,0x8(%esp)
    31aa:	c7 44 24 04 5e 59 00 	movl   $0x595e,0x4(%esp)
    31b1:	00 
    31b2:	89 04 24             	mov    %eax,(%esp)
    31b5:	e8 d2 0f 00 00       	call   418c <printf>
      exit();
    31ba:	e8 2d 0e 00 00       	call   3fec <exit>
    }
    *b = 1;
    31bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31c2:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    31c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31c8:	83 c0 01             	add    $0x1,%eax
    31cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    31ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    31d2:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    31d9:	7e 9e                	jle    3179 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    31db:	e8 04 0e 00 00       	call   3fe4 <fork>
    31e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    31e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31e7:	79 1a                	jns    3203 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    31e9:	a1 40 64 00 00       	mov    0x6440,%eax
    31ee:	c7 44 24 04 79 59 00 	movl   $0x5979,0x4(%esp)
    31f5:	00 
    31f6:	89 04 24             	mov    %eax,(%esp)
    31f9:	e8 8e 0f 00 00       	call   418c <printf>
    exit();
    31fe:	e8 e9 0d 00 00       	call   3fec <exit>
  }
  c = sbrk(1);
    3203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    320a:	e8 65 0e 00 00       	call   4074 <sbrk>
    320f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    3212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3219:	e8 56 0e 00 00       	call   4074 <sbrk>
    321e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    3221:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3224:	83 c0 01             	add    $0x1,%eax
    3227:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    322a:	74 1a                	je     3246 <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    322c:	a1 40 64 00 00       	mov    0x6440,%eax
    3231:	c7 44 24 04 90 59 00 	movl   $0x5990,0x4(%esp)
    3238:	00 
    3239:	89 04 24             	mov    %eax,(%esp)
    323c:	e8 4b 0f 00 00       	call   418c <printf>
    exit();
    3241:	e8 a6 0d 00 00       	call   3fec <exit>
  }
  if(pid == 0)
    3246:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    324a:	75 05                	jne    3251 <sbrktest+0x11e>
    exit();
    324c:	e8 9b 0d 00 00       	call   3fec <exit>
  wait();
    3251:	e8 9e 0d 00 00       	call   3ff4 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3256:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    325d:	e8 12 0e 00 00       	call   4074 <sbrk>
    3262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3265:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3268:	ba 00 00 40 06       	mov    $0x6400000,%edx
    326d:	29 c2                	sub    %eax,%edx
    326f:	89 d0                	mov    %edx,%eax
    3271:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3274:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3277:	89 04 24             	mov    %eax,(%esp)
    327a:	e8 f5 0d 00 00       	call   4074 <sbrk>
    327f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    3282:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3285:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3288:	74 1a                	je     32a4 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    328a:	a1 40 64 00 00       	mov    0x6440,%eax
    328f:	c7 44 24 04 ac 59 00 	movl   $0x59ac,0x4(%esp)
    3296:	00 
    3297:	89 04 24             	mov    %eax,(%esp)
    329a:	e8 ed 0e 00 00       	call   418c <printf>
    exit();
    329f:	e8 48 0d 00 00       	call   3fec <exit>
  }
  lastaddr = (char*) (BIG-1);
    32a4:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    32ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    32ae:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    32b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32b8:	e8 b7 0d 00 00       	call   4074 <sbrk>
    32bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    32c0:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    32c7:	e8 a8 0d 00 00       	call   4074 <sbrk>
    32cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    32cf:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32d3:	75 1a                	jne    32ef <sbrktest+0x1bc>
    printf(stdout, "sbrk could not deallocate\n");
    32d5:	a1 40 64 00 00       	mov    0x6440,%eax
    32da:	c7 44 24 04 ea 59 00 	movl   $0x59ea,0x4(%esp)
    32e1:	00 
    32e2:	89 04 24             	mov    %eax,(%esp)
    32e5:	e8 a2 0e 00 00       	call   418c <printf>
    exit();
    32ea:	e8 fd 0c 00 00       	call   3fec <exit>
  }
  c = sbrk(0);
    32ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32f6:	e8 79 0d 00 00       	call   4074 <sbrk>
    32fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3301:	2d 00 10 00 00       	sub    $0x1000,%eax
    3306:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3309:	74 28                	je     3333 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    330b:	a1 40 64 00 00       	mov    0x6440,%eax
    3310:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3313:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3317:	8b 55 f4             	mov    -0xc(%ebp),%edx
    331a:	89 54 24 08          	mov    %edx,0x8(%esp)
    331e:	c7 44 24 04 08 5a 00 	movl   $0x5a08,0x4(%esp)
    3325:	00 
    3326:	89 04 24             	mov    %eax,(%esp)
    3329:	e8 5e 0e 00 00       	call   418c <printf>
    exit();
    332e:	e8 b9 0c 00 00       	call   3fec <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3333:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    333a:	e8 35 0d 00 00       	call   4074 <sbrk>
    333f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3342:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3349:	e8 26 0d 00 00       	call   4074 <sbrk>
    334e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3351:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3354:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3357:	75 19                	jne    3372 <sbrktest+0x23f>
    3359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3360:	e8 0f 0d 00 00       	call   4074 <sbrk>
    3365:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3368:	81 c2 00 10 00 00    	add    $0x1000,%edx
    336e:	39 d0                	cmp    %edx,%eax
    3370:	74 28                	je     339a <sbrktest+0x267>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3372:	a1 40 64 00 00       	mov    0x6440,%eax
    3377:	8b 55 e0             	mov    -0x20(%ebp),%edx
    337a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    337e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3381:	89 54 24 08          	mov    %edx,0x8(%esp)
    3385:	c7 44 24 04 40 5a 00 	movl   $0x5a40,0x4(%esp)
    338c:	00 
    338d:	89 04 24             	mov    %eax,(%esp)
    3390:	e8 f7 0d 00 00       	call   418c <printf>
    exit();
    3395:	e8 52 0c 00 00       	call   3fec <exit>
  }
  if(*lastaddr == 99){
    339a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    339d:	0f b6 00             	movzbl (%eax),%eax
    33a0:	3c 63                	cmp    $0x63,%al
    33a2:	75 1a                	jne    33be <sbrktest+0x28b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    33a4:	a1 40 64 00 00       	mov    0x6440,%eax
    33a9:	c7 44 24 04 68 5a 00 	movl   $0x5a68,0x4(%esp)
    33b0:	00 
    33b1:	89 04 24             	mov    %eax,(%esp)
    33b4:	e8 d3 0d 00 00       	call   418c <printf>
    exit();
    33b9:	e8 2e 0c 00 00       	call   3fec <exit>
  }

  a = sbrk(0);
    33be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33c5:	e8 aa 0c 00 00       	call   4074 <sbrk>
    33ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    33cd:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    33d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33d7:	e8 98 0c 00 00       	call   4074 <sbrk>
    33dc:	29 c3                	sub    %eax,%ebx
    33de:	89 d8                	mov    %ebx,%eax
    33e0:	89 04 24             	mov    %eax,(%esp)
    33e3:	e8 8c 0c 00 00       	call   4074 <sbrk>
    33e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    33eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33f1:	74 28                	je     341b <sbrktest+0x2e8>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33f3:	a1 40 64 00 00       	mov    0x6440,%eax
    33f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
    33fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3402:	89 54 24 08          	mov    %edx,0x8(%esp)
    3406:	c7 44 24 04 98 5a 00 	movl   $0x5a98,0x4(%esp)
    340d:	00 
    340e:	89 04 24             	mov    %eax,(%esp)
    3411:	e8 76 0d 00 00       	call   418c <printf>
    exit();
    3416:	e8 d1 0b 00 00       	call   3fec <exit>
  }
 db; 
    341b:	c7 44 24 08 dc 05 00 	movl   $0x5dc,0x8(%esp)
    3422:	00 
    3423:	c7 44 24 04 7d 4e 00 	movl   $0x4e7d,0x4(%esp)
    342a:	00 
    342b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3432:	e8 55 0d 00 00       	call   418c <printf>
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3437:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    343e:	eb 7b                	jmp    34bb <sbrktest+0x388>
    ppid = getpid();
    3440:	e8 27 0c 00 00       	call   406c <getpid>
    3445:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    3448:	e8 97 0b 00 00       	call   3fe4 <fork>
    344d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    3450:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3454:	79 1a                	jns    3470 <sbrktest+0x33d>
      printf(stdout, "fork failed\n");
    3456:	a1 40 64 00 00       	mov    0x6440,%eax
    345b:	c7 44 24 04 f9 45 00 	movl   $0x45f9,0x4(%esp)
    3462:	00 
    3463:	89 04 24             	mov    %eax,(%esp)
    3466:	e8 21 0d 00 00       	call   418c <printf>
      exit();
    346b:	e8 7c 0b 00 00       	call   3fec <exit>
    }
    if(pid == 0){
    3470:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3474:	75 39                	jne    34af <sbrktest+0x37c>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3476:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3479:	0f b6 00             	movzbl (%eax),%eax
    347c:	0f be d0             	movsbl %al,%edx
    347f:	a1 40 64 00 00       	mov    0x6440,%eax
    3484:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3488:	8b 55 f4             	mov    -0xc(%ebp),%edx
    348b:	89 54 24 08          	mov    %edx,0x8(%esp)
    348f:	c7 44 24 04 b9 5a 00 	movl   $0x5ab9,0x4(%esp)
    3496:	00 
    3497:	89 04 24             	mov    %eax,(%esp)
    349a:	e8 ed 0c 00 00       	call   418c <printf>
      kill(ppid);
    349f:	8b 45 d0             	mov    -0x30(%ebp),%eax
    34a2:	89 04 24             	mov    %eax,(%esp)
    34a5:	e8 72 0b 00 00       	call   401c <kill>
      exit();
    34aa:	e8 3d 0b 00 00       	call   3fec <exit>
    }
    wait();
    34af:	e8 40 0b 00 00       	call   3ff4 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
 db; 
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34b4:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    34bb:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    34c2:	0f 86 78 ff ff ff    	jbe    3440 <sbrktest+0x30d>
      kill(ppid);
      exit();
    }
    wait();
  }
db;
    34c8:	c7 44 24 08 ec 05 00 	movl   $0x5ec,0x8(%esp)
    34cf:	00 
    34d0:	c7 44 24 04 7d 4e 00 	movl   $0x4e7d,0x4(%esp)
    34d7:	00 
    34d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34df:	e8 a8 0c 00 00       	call   418c <printf>
  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    34e4:	8d 45 c8             	lea    -0x38(%ebp),%eax
    34e7:	89 04 24             	mov    %eax,(%esp)
    34ea:	e8 0d 0b 00 00       	call   3ffc <pipe>
    34ef:	85 c0                	test   %eax,%eax
    34f1:	74 19                	je     350c <sbrktest+0x3d9>
    printf(1, "pipe() failed\n");
    34f3:	c7 44 24 04 ca 49 00 	movl   $0x49ca,0x4(%esp)
    34fa:	00 
    34fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3502:	e8 85 0c 00 00       	call   418c <printf>
    exit();
    3507:	e8 e0 0a 00 00       	call   3fec <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    350c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3513:	e9 87 00 00 00       	jmp    359f <sbrktest+0x46c>
    if((pids[i] = fork()) == 0){
    3518:	e8 c7 0a 00 00       	call   3fe4 <fork>
    351d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3520:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    3524:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3527:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    352b:	85 c0                	test   %eax,%eax
    352d:	75 46                	jne    3575 <sbrktest+0x442>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    352f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3536:	e8 39 0b 00 00       	call   4074 <sbrk>
    353b:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3540:	29 c2                	sub    %eax,%edx
    3542:	89 d0                	mov    %edx,%eax
    3544:	89 04 24             	mov    %eax,(%esp)
    3547:	e8 28 0b 00 00       	call   4074 <sbrk>
      write(fds[1], "x", 1);
    354c:	8b 45 cc             	mov    -0x34(%ebp),%eax
    354f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3556:	00 
    3557:	c7 44 24 04 2f 4a 00 	movl   $0x4a2f,0x4(%esp)
    355e:	00 
    355f:	89 04 24             	mov    %eax,(%esp)
    3562:	e8 a5 0a 00 00       	call   400c <write>
      // sit around until killed
      for(;;) sleep(1000);
    3567:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    356e:	e8 09 0b 00 00       	call   407c <sleep>
    3573:	eb f2                	jmp    3567 <sbrktest+0x434>
    }
    if(pids[i] != -1)
    3575:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3578:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    357c:	83 f8 ff             	cmp    $0xffffffff,%eax
    357f:	74 1a                	je     359b <sbrktest+0x468>
      read(fds[0], &scratch, 1);
    3581:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3584:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    358b:	00 
    358c:	8d 55 9f             	lea    -0x61(%ebp),%edx
    358f:	89 54 24 04          	mov    %edx,0x4(%esp)
    3593:	89 04 24             	mov    %eax,(%esp)
    3596:	e8 69 0a 00 00       	call   4004 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    359b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    359f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35a2:	83 f8 09             	cmp    $0x9,%eax
    35a5:	0f 86 6d ff ff ff    	jbe    3518 <sbrktest+0x3e5>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    35ab:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    35b2:	e8 bd 0a 00 00       	call   4074 <sbrk>
    35b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  printf(1, "i --> %d \n", sizeof(pids)/sizeof(pids[0]));
    35ba:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    35c1:	00 
    35c2:	c7 44 24 04 d2 5a 00 	movl   $0x5ad2,0x4(%esp)
    35c9:	00 
    35ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35d1:	e8 b6 0b 00 00       	call   418c <printf>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    35d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    35dd:	eb 77                	jmp    3656 <sbrktest+0x523>
    if(pids[i] == -1)
    35df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35e2:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    35e6:	83 f8 ff             	cmp    $0xffffffff,%eax
    35e9:	75 02                	jne    35ed <sbrktest+0x4ba>
      continue;
    35eb:	eb 65                	jmp    3652 <sbrktest+0x51f>
    printf(1,"iter %d \n", i);
    35ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35f0:	89 44 24 08          	mov    %eax,0x8(%esp)
    35f4:	c7 44 24 04 dd 5a 00 	movl   $0x5add,0x4(%esp)
    35fb:	00 
    35fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3603:	e8 84 0b 00 00       	call   418c <printf>
    kill(pids[i]);
    3608:	8b 45 f0             	mov    -0x10(%ebp),%eax
    360b:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    360f:	89 04 24             	mov    %eax,(%esp)
    3612:	e8 05 0a 00 00       	call   401c <kill>
    printf(1,"iter %d \n", i);
    3617:	8b 45 f0             	mov    -0x10(%ebp),%eax
    361a:	89 44 24 08          	mov    %eax,0x8(%esp)
    361e:	c7 44 24 04 dd 5a 00 	movl   $0x5add,0x4(%esp)
    3625:	00 
    3626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    362d:	e8 5a 0b 00 00       	call   418c <printf>
    wait();
    3632:	e8 bd 09 00 00       	call   3ff4 <wait>
    printf(1,"iter %d \n", i);
    3637:	8b 45 f0             	mov    -0x10(%ebp),%eax
    363a:	89 44 24 08          	mov    %eax,0x8(%esp)
    363e:	c7 44 24 04 dd 5a 00 	movl   $0x5add,0x4(%esp)
    3645:	00 
    3646:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    364d:	e8 3a 0b 00 00       	call   418c <printf>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  printf(1, "i --> %d \n", sizeof(pids)/sizeof(pids[0]));
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3652:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3656:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3659:	83 f8 09             	cmp    $0x9,%eax
    365c:	76 81                	jbe    35df <sbrktest+0x4ac>
    kill(pids[i]);
    printf(1,"iter %d \n", i);
    wait();
    printf(1,"iter %d \n", i);
  }
  db;
    365e:	c7 44 24 08 0b 06 00 	movl   $0x60b,0x8(%esp)
    3665:	00 
    3666:	c7 44 24 04 7d 4e 00 	movl   $0x4e7d,0x4(%esp)
    366d:	00 
    366e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3675:	e8 12 0b 00 00       	call   418c <printf>
  if(c == (char*)0xffffffff){
    367a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    367e:	75 1a                	jne    369a <sbrktest+0x567>
    printf(stdout, "failed sbrk leaked memory\n");
    3680:	a1 40 64 00 00       	mov    0x6440,%eax
    3685:	c7 44 24 04 e7 5a 00 	movl   $0x5ae7,0x4(%esp)
    368c:	00 
    368d:	89 04 24             	mov    %eax,(%esp)
    3690:	e8 f7 0a 00 00       	call   418c <printf>
    exit();
    3695:	e8 52 09 00 00       	call   3fec <exit>
  }

  if(sbrk(0) > oldbrk)
    369a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36a1:	e8 ce 09 00 00       	call   4074 <sbrk>
    36a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    36a9:	76 1b                	jbe    36c6 <sbrktest+0x593>
    sbrk(-(sbrk(0) - oldbrk));
    36ab:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    36ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36b5:	e8 ba 09 00 00       	call   4074 <sbrk>
    36ba:	29 c3                	sub    %eax,%ebx
    36bc:	89 d8                	mov    %ebx,%eax
    36be:	89 04 24             	mov    %eax,(%esp)
    36c1:	e8 ae 09 00 00       	call   4074 <sbrk>

  printf(stdout, "sbrk test OK\n");
    36c6:	a1 40 64 00 00       	mov    0x6440,%eax
    36cb:	c7 44 24 04 02 5b 00 	movl   $0x5b02,0x4(%esp)
    36d2:	00 
    36d3:	89 04 24             	mov    %eax,(%esp)
    36d6:	e8 b1 0a 00 00       	call   418c <printf>
}
    36db:	81 c4 84 00 00 00    	add    $0x84,%esp
    36e1:	5b                   	pop    %ebx
    36e2:	5d                   	pop    %ebp
    36e3:	c3                   	ret    

000036e4 <validateint>:

void
validateint(int *p)
{
    36e4:	55                   	push   %ebp
    36e5:	89 e5                	mov    %esp,%ebp
    36e7:	53                   	push   %ebx
    36e8:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    36eb:	b8 0d 00 00 00       	mov    $0xd,%eax
    36f0:	8b 55 08             	mov    0x8(%ebp),%edx
    36f3:	89 d1                	mov    %edx,%ecx
    36f5:	89 e3                	mov    %esp,%ebx
    36f7:	89 cc                	mov    %ecx,%esp
    36f9:	cd 40                	int    $0x40
    36fb:	89 dc                	mov    %ebx,%esp
    36fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3700:	83 c4 10             	add    $0x10,%esp
    3703:	5b                   	pop    %ebx
    3704:	5d                   	pop    %ebp
    3705:	c3                   	ret    

00003706 <validatetest>:

void
validatetest(void)
{
    3706:	55                   	push   %ebp
    3707:	89 e5                	mov    %esp,%ebp
    3709:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    370c:	a1 40 64 00 00       	mov    0x6440,%eax
    3711:	c7 44 24 04 10 5b 00 	movl   $0x5b10,0x4(%esp)
    3718:	00 
    3719:	89 04 24             	mov    %eax,(%esp)
    371c:	e8 6b 0a 00 00       	call   418c <printf>
  hi = 1100*1024;
    3721:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3728:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    372f:	e9 9b 00 00 00       	jmp    37cf <validatetest+0xc9>
    if((pid = fork()) == 0){
    3734:	e8 ab 08 00 00       	call   3fe4 <fork>
    3739:	89 45 ec             	mov    %eax,-0x14(%ebp)
    373c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3740:	75 2c                	jne    376e <validatetest+0x68>
      // try to crash the kernel by passing in a badly placed integer
      db;
    3742:	c7 44 24 08 30 06 00 	movl   $0x630,0x8(%esp)
    3749:	00 
    374a:	c7 44 24 04 7d 4e 00 	movl   $0x4e7d,0x4(%esp)
    3751:	00 
    3752:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3759:	e8 2e 0a 00 00       	call   418c <printf>
      validateint((int*)p);
    375e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3761:	89 04 24             	mov    %eax,(%esp)
    3764:	e8 7b ff ff ff       	call   36e4 <validateint>
      exit();
    3769:	e8 7e 08 00 00       	call   3fec <exit>
    }
    sleep(0);
    376e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3775:	e8 02 09 00 00       	call   407c <sleep>
    sleep(0);
    377a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3781:	e8 f6 08 00 00       	call   407c <sleep>
    kill(pid);
    3786:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3789:	89 04 24             	mov    %eax,(%esp)
    378c:	e8 8b 08 00 00       	call   401c <kill>
    wait();
    3791:	e8 5e 08 00 00       	call   3ff4 <wait>
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3796:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3799:	89 44 24 04          	mov    %eax,0x4(%esp)
    379d:	c7 04 24 1f 5b 00 00 	movl   $0x5b1f,(%esp)
    37a4:	e8 a3 08 00 00       	call   404c <link>
    37a9:	83 f8 ff             	cmp    $0xffffffff,%eax
    37ac:	74 1a                	je     37c8 <validatetest+0xc2>
      printf(stdout, "link should not succeed\n");
    37ae:	a1 40 64 00 00       	mov    0x6440,%eax
    37b3:	c7 44 24 04 2a 5b 00 	movl   $0x5b2a,0x4(%esp)
    37ba:	00 
    37bb:	89 04 24             	mov    %eax,(%esp)
    37be:	e8 c9 09 00 00       	call   418c <printf>
      exit();
    37c3:	e8 24 08 00 00       	call   3fec <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    37c8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    37cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    37d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    37d5:	0f 83 59 ff ff ff    	jae    3734 <validatetest+0x2e>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    37db:	a1 40 64 00 00       	mov    0x6440,%eax
    37e0:	c7 44 24 04 43 5b 00 	movl   $0x5b43,0x4(%esp)
    37e7:	00 
    37e8:	89 04 24             	mov    %eax,(%esp)
    37eb:	e8 9c 09 00 00       	call   418c <printf>
}
    37f0:	c9                   	leave  
    37f1:	c3                   	ret    

000037f2 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    37f2:	55                   	push   %ebp
    37f3:	89 e5                	mov    %esp,%ebp
    37f5:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    37f8:	a1 40 64 00 00       	mov    0x6440,%eax
    37fd:	c7 44 24 04 50 5b 00 	movl   $0x5b50,0x4(%esp)
    3804:	00 
    3805:	89 04 24             	mov    %eax,(%esp)
    3808:	e8 7f 09 00 00       	call   418c <printf>
  for(i = 0; i < sizeof(uninit); i++){
    380d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3814:	eb 2d                	jmp    3843 <bsstest+0x51>
    if(uninit[i] != '\0'){
    3816:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3819:	05 00 65 00 00       	add    $0x6500,%eax
    381e:	0f b6 00             	movzbl (%eax),%eax
    3821:	84 c0                	test   %al,%al
    3823:	74 1a                	je     383f <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    3825:	a1 40 64 00 00       	mov    0x6440,%eax
    382a:	c7 44 24 04 5a 5b 00 	movl   $0x5b5a,0x4(%esp)
    3831:	00 
    3832:	89 04 24             	mov    %eax,(%esp)
    3835:	e8 52 09 00 00       	call   418c <printf>
      exit();
    383a:	e8 ad 07 00 00       	call   3fec <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    383f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3843:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3846:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    384b:	76 c9                	jbe    3816 <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    384d:	a1 40 64 00 00       	mov    0x6440,%eax
    3852:	c7 44 24 04 6b 5b 00 	movl   $0x5b6b,0x4(%esp)
    3859:	00 
    385a:	89 04 24             	mov    %eax,(%esp)
    385d:	e8 2a 09 00 00       	call   418c <printf>
}
    3862:	c9                   	leave  
    3863:	c3                   	ret    

00003864 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3864:	55                   	push   %ebp
    3865:	89 e5                	mov    %esp,%ebp
    3867:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    386a:	c7 04 24 78 5b 00 00 	movl   $0x5b78,(%esp)
    3871:	e8 c6 07 00 00       	call   403c <unlink>
  pid = fork();
    3876:	e8 69 07 00 00       	call   3fe4 <fork>
    387b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    387e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3882:	0f 85 90 00 00 00    	jne    3918 <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    388f:	eb 12                	jmp    38a3 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3894:	c7 04 85 60 64 00 00 	movl   $0x5b84,0x6460(,%eax,4)
    389b:	84 5b 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    389f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    38a3:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    38a7:	7e e8                	jle    3891 <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    38a9:	c7 05 dc 64 00 00 00 	movl   $0x0,0x64dc
    38b0:	00 00 00 
    printf(stdout, "bigarg test\n");
    38b3:	a1 40 64 00 00       	mov    0x6440,%eax
    38b8:	c7 44 24 04 61 5c 00 	movl   $0x5c61,0x4(%esp)
    38bf:	00 
    38c0:	89 04 24             	mov    %eax,(%esp)
    38c3:	e8 c4 08 00 00       	call   418c <printf>
    exec("echo", args);
    38c8:	c7 44 24 04 60 64 00 	movl   $0x6460,0x4(%esp)
    38cf:	00 
    38d0:	c7 04 24 58 45 00 00 	movl   $0x4558,(%esp)
    38d7:	e8 48 07 00 00       	call   4024 <exec>
    printf(stdout, "bigarg test ok\n");
    38dc:	a1 40 64 00 00       	mov    0x6440,%eax
    38e1:	c7 44 24 04 6e 5c 00 	movl   $0x5c6e,0x4(%esp)
    38e8:	00 
    38e9:	89 04 24             	mov    %eax,(%esp)
    38ec:	e8 9b 08 00 00       	call   418c <printf>
    fd = open("bigarg-ok", O_CREATE);
    38f1:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    38f8:	00 
    38f9:	c7 04 24 78 5b 00 00 	movl   $0x5b78,(%esp)
    3900:	e8 27 07 00 00       	call   402c <open>
    3905:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3908:	8b 45 ec             	mov    -0x14(%ebp),%eax
    390b:	89 04 24             	mov    %eax,(%esp)
    390e:	e8 01 07 00 00       	call   4014 <close>
    exit();
    3913:	e8 d4 06 00 00       	call   3fec <exit>
  } else if(pid < 0){
    3918:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    391c:	79 1a                	jns    3938 <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    391e:	a1 40 64 00 00       	mov    0x6440,%eax
    3923:	c7 44 24 04 7e 5c 00 	movl   $0x5c7e,0x4(%esp)
    392a:	00 
    392b:	89 04 24             	mov    %eax,(%esp)
    392e:	e8 59 08 00 00       	call   418c <printf>
    exit();
    3933:	e8 b4 06 00 00       	call   3fec <exit>
  }
  wait();
    3938:	e8 b7 06 00 00       	call   3ff4 <wait>
  fd = open("bigarg-ok", 0);
    393d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3944:	00 
    3945:	c7 04 24 78 5b 00 00 	movl   $0x5b78,(%esp)
    394c:	e8 db 06 00 00       	call   402c <open>
    3951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3954:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3958:	79 1a                	jns    3974 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    395a:	a1 40 64 00 00       	mov    0x6440,%eax
    395f:	c7 44 24 04 97 5c 00 	movl   $0x5c97,0x4(%esp)
    3966:	00 
    3967:	89 04 24             	mov    %eax,(%esp)
    396a:	e8 1d 08 00 00       	call   418c <printf>
    exit();
    396f:	e8 78 06 00 00       	call   3fec <exit>
  }
  close(fd);
    3974:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3977:	89 04 24             	mov    %eax,(%esp)
    397a:	e8 95 06 00 00       	call   4014 <close>
  unlink("bigarg-ok");
    397f:	c7 04 24 78 5b 00 00 	movl   $0x5b78,(%esp)
    3986:	e8 b1 06 00 00       	call   403c <unlink>
}
    398b:	c9                   	leave  
    398c:	c3                   	ret    

0000398d <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    398d:	55                   	push   %ebp
    398e:	89 e5                	mov    %esp,%ebp
    3990:	53                   	push   %ebx
    3991:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    3994:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    399b:	c7 44 24 04 ac 5c 00 	movl   $0x5cac,0x4(%esp)
    39a2:	00 
    39a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39aa:	e8 dd 07 00 00       	call   418c <printf>

  for(nfiles = 0; ; nfiles++){
    39af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    39b6:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    39ba:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    39bd:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    39c2:	89 c8                	mov    %ecx,%eax
    39c4:	f7 ea                	imul   %edx
    39c6:	c1 fa 06             	sar    $0x6,%edx
    39c9:	89 c8                	mov    %ecx,%eax
    39cb:	c1 f8 1f             	sar    $0x1f,%eax
    39ce:	29 c2                	sub    %eax,%edx
    39d0:	89 d0                	mov    %edx,%eax
    39d2:	83 c0 30             	add    $0x30,%eax
    39d5:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    39d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    39db:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    39e0:	89 d8                	mov    %ebx,%eax
    39e2:	f7 ea                	imul   %edx
    39e4:	c1 fa 06             	sar    $0x6,%edx
    39e7:	89 d8                	mov    %ebx,%eax
    39e9:	c1 f8 1f             	sar    $0x1f,%eax
    39ec:	89 d1                	mov    %edx,%ecx
    39ee:	29 c1                	sub    %eax,%ecx
    39f0:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    39f6:	29 c3                	sub    %eax,%ebx
    39f8:	89 d9                	mov    %ebx,%ecx
    39fa:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    39ff:	89 c8                	mov    %ecx,%eax
    3a01:	f7 ea                	imul   %edx
    3a03:	c1 fa 05             	sar    $0x5,%edx
    3a06:	89 c8                	mov    %ecx,%eax
    3a08:	c1 f8 1f             	sar    $0x1f,%eax
    3a0b:	29 c2                	sub    %eax,%edx
    3a0d:	89 d0                	mov    %edx,%eax
    3a0f:	83 c0 30             	add    $0x30,%eax
    3a12:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a15:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a18:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a1d:	89 d8                	mov    %ebx,%eax
    3a1f:	f7 ea                	imul   %edx
    3a21:	c1 fa 05             	sar    $0x5,%edx
    3a24:	89 d8                	mov    %ebx,%eax
    3a26:	c1 f8 1f             	sar    $0x1f,%eax
    3a29:	89 d1                	mov    %edx,%ecx
    3a2b:	29 c1                	sub    %eax,%ecx
    3a2d:	6b c1 64             	imul   $0x64,%ecx,%eax
    3a30:	29 c3                	sub    %eax,%ebx
    3a32:	89 d9                	mov    %ebx,%ecx
    3a34:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3a39:	89 c8                	mov    %ecx,%eax
    3a3b:	f7 ea                	imul   %edx
    3a3d:	c1 fa 02             	sar    $0x2,%edx
    3a40:	89 c8                	mov    %ecx,%eax
    3a42:	c1 f8 1f             	sar    $0x1f,%eax
    3a45:	29 c2                	sub    %eax,%edx
    3a47:	89 d0                	mov    %edx,%eax
    3a49:	83 c0 30             	add    $0x30,%eax
    3a4c:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3a4f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a52:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3a57:	89 c8                	mov    %ecx,%eax
    3a59:	f7 ea                	imul   %edx
    3a5b:	c1 fa 02             	sar    $0x2,%edx
    3a5e:	89 c8                	mov    %ecx,%eax
    3a60:	c1 f8 1f             	sar    $0x1f,%eax
    3a63:	29 c2                	sub    %eax,%edx
    3a65:	89 d0                	mov    %edx,%eax
    3a67:	c1 e0 02             	shl    $0x2,%eax
    3a6a:	01 d0                	add    %edx,%eax
    3a6c:	01 c0                	add    %eax,%eax
    3a6e:	29 c1                	sub    %eax,%ecx
    3a70:	89 ca                	mov    %ecx,%edx
    3a72:	89 d0                	mov    %edx,%eax
    3a74:	83 c0 30             	add    $0x30,%eax
    3a77:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3a7a:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3a7e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3a81:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a85:	c7 44 24 04 b9 5c 00 	movl   $0x5cb9,0x4(%esp)
    3a8c:	00 
    3a8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a94:	e8 f3 06 00 00       	call   418c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3a99:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3aa0:	00 
    3aa1:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3aa4:	89 04 24             	mov    %eax,(%esp)
    3aa7:	e8 80 05 00 00       	call   402c <open>
    3aac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3aaf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3ab3:	79 1d                	jns    3ad2 <fsfull+0x145>
      printf(1, "open %s failed\n", name);
    3ab5:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
    3abc:	c7 44 24 04 c5 5c 00 	movl   $0x5cc5,0x4(%esp)
    3ac3:	00 
    3ac4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3acb:	e8 bc 06 00 00       	call   418c <printf>
      break;
    3ad0:	eb 74                	jmp    3b46 <fsfull+0x1b9>
    }
    int total = 0;
    3ad2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3ad9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    3ae0:	00 
    3ae1:	c7 44 24 04 20 8c 00 	movl   $0x8c20,0x4(%esp)
    3ae8:	00 
    3ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3aec:	89 04 24             	mov    %eax,(%esp)
    3aef:	e8 18 05 00 00       	call   400c <write>
    3af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3af7:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3afe:	7f 2f                	jg     3b2f <fsfull+0x1a2>
        break;
    3b00:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3b04:	89 44 24 08          	mov    %eax,0x8(%esp)
    3b08:	c7 44 24 04 d5 5c 00 	movl   $0x5cd5,0x4(%esp)
    3b0f:	00 
    3b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b17:	e8 70 06 00 00       	call   418c <printf>
    close(fd);
    3b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3b1f:	89 04 24             	mov    %eax,(%esp)
    3b22:	e8 ed 04 00 00       	call   4014 <close>
    if(total == 0)
    3b27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3b2b:	75 10                	jne    3b3d <fsfull+0x1b0>
    3b2d:	eb 0c                	jmp    3b3b <fsfull+0x1ae>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    3b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3b32:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3b35:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3b39:	eb 9e                	jmp    3ad9 <fsfull+0x14c>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3b3b:	eb 09                	jmp    3b46 <fsfull+0x1b9>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3b3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3b41:	e9 70 fe ff ff       	jmp    39b6 <fsfull+0x29>

  while(nfiles >= 0){
    3b46:	e9 d7 00 00 00       	jmp    3c22 <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    3b4b:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3b4f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3b52:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3b57:	89 c8                	mov    %ecx,%eax
    3b59:	f7 ea                	imul   %edx
    3b5b:	c1 fa 06             	sar    $0x6,%edx
    3b5e:	89 c8                	mov    %ecx,%eax
    3b60:	c1 f8 1f             	sar    $0x1f,%eax
    3b63:	29 c2                	sub    %eax,%edx
    3b65:	89 d0                	mov    %edx,%eax
    3b67:	83 c0 30             	add    $0x30,%eax
    3b6a:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3b6d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3b70:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3b75:	89 d8                	mov    %ebx,%eax
    3b77:	f7 ea                	imul   %edx
    3b79:	c1 fa 06             	sar    $0x6,%edx
    3b7c:	89 d8                	mov    %ebx,%eax
    3b7e:	c1 f8 1f             	sar    $0x1f,%eax
    3b81:	89 d1                	mov    %edx,%ecx
    3b83:	29 c1                	sub    %eax,%ecx
    3b85:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3b8b:	29 c3                	sub    %eax,%ebx
    3b8d:	89 d9                	mov    %ebx,%ecx
    3b8f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3b94:	89 c8                	mov    %ecx,%eax
    3b96:	f7 ea                	imul   %edx
    3b98:	c1 fa 05             	sar    $0x5,%edx
    3b9b:	89 c8                	mov    %ecx,%eax
    3b9d:	c1 f8 1f             	sar    $0x1f,%eax
    3ba0:	29 c2                	sub    %eax,%edx
    3ba2:	89 d0                	mov    %edx,%eax
    3ba4:	83 c0 30             	add    $0x30,%eax
    3ba7:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3baa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3bad:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3bb2:	89 d8                	mov    %ebx,%eax
    3bb4:	f7 ea                	imul   %edx
    3bb6:	c1 fa 05             	sar    $0x5,%edx
    3bb9:	89 d8                	mov    %ebx,%eax
    3bbb:	c1 f8 1f             	sar    $0x1f,%eax
    3bbe:	89 d1                	mov    %edx,%ecx
    3bc0:	29 c1                	sub    %eax,%ecx
    3bc2:	6b c1 64             	imul   $0x64,%ecx,%eax
    3bc5:	29 c3                	sub    %eax,%ebx
    3bc7:	89 d9                	mov    %ebx,%ecx
    3bc9:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3bce:	89 c8                	mov    %ecx,%eax
    3bd0:	f7 ea                	imul   %edx
    3bd2:	c1 fa 02             	sar    $0x2,%edx
    3bd5:	89 c8                	mov    %ecx,%eax
    3bd7:	c1 f8 1f             	sar    $0x1f,%eax
    3bda:	29 c2                	sub    %eax,%edx
    3bdc:	89 d0                	mov    %edx,%eax
    3bde:	83 c0 30             	add    $0x30,%eax
    3be1:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3be4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3be7:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3bec:	89 c8                	mov    %ecx,%eax
    3bee:	f7 ea                	imul   %edx
    3bf0:	c1 fa 02             	sar    $0x2,%edx
    3bf3:	89 c8                	mov    %ecx,%eax
    3bf5:	c1 f8 1f             	sar    $0x1f,%eax
    3bf8:	29 c2                	sub    %eax,%edx
    3bfa:	89 d0                	mov    %edx,%eax
    3bfc:	c1 e0 02             	shl    $0x2,%eax
    3bff:	01 d0                	add    %edx,%eax
    3c01:	01 c0                	add    %eax,%eax
    3c03:	29 c1                	sub    %eax,%ecx
    3c05:	89 ca                	mov    %ecx,%edx
    3c07:	89 d0                	mov    %edx,%eax
    3c09:	83 c0 30             	add    $0x30,%eax
    3c0c:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3c0f:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3c13:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3c16:	89 04 24             	mov    %eax,(%esp)
    3c19:	e8 1e 04 00 00       	call   403c <unlink>
    nfiles--;
    3c1e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3c26:	0f 89 1f ff ff ff    	jns    3b4b <fsfull+0x1be>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3c2c:	c7 44 24 04 e5 5c 00 	movl   $0x5ce5,0x4(%esp)
    3c33:	00 
    3c34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c3b:	e8 4c 05 00 00       	call   418c <printf>
}
    3c40:	83 c4 74             	add    $0x74,%esp
    3c43:	5b                   	pop    %ebx
    3c44:	5d                   	pop    %ebp
    3c45:	c3                   	ret    

00003c46 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3c46:	55                   	push   %ebp
    3c47:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3c49:	a1 44 64 00 00       	mov    0x6444,%eax
    3c4e:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3c54:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3c59:	a3 44 64 00 00       	mov    %eax,0x6444
  return randstate;
    3c5e:	a1 44 64 00 00       	mov    0x6444,%eax
}
    3c63:	5d                   	pop    %ebp
    3c64:	c3                   	ret    

00003c65 <main>:

int
main(int argc, char *argv[])
{
    3c65:	55                   	push   %ebp
    3c66:	89 e5                	mov    %esp,%ebp
    3c68:	83 e4 f0             	and    $0xfffffff0,%esp
    3c6b:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3c6e:	c7 44 24 04 fb 5c 00 	movl   $0x5cfb,0x4(%esp)
    3c75:	00 
    3c76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c7d:	e8 0a 05 00 00       	call   418c <printf>

  if(open("usertests.ran", 0) >= 0){
    3c82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3c89:	00 
    3c8a:	c7 04 24 0f 5d 00 00 	movl   $0x5d0f,(%esp)
    3c91:	e8 96 03 00 00       	call   402c <open>
    3c96:	85 c0                	test   %eax,%eax
    3c98:	78 19                	js     3cb3 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3c9a:	c7 44 24 04 20 5d 00 	movl   $0x5d20,0x4(%esp)
    3ca1:	00 
    3ca2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ca9:	e8 de 04 00 00       	call   418c <printf>
    exit();
    3cae:	e8 39 03 00 00       	call   3fec <exit>
  }
  if(argc > 1) {
    3cb3:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    3cb7:	7e 0a                	jle    3cc3 <main+0x5e>
    sbrktest();
    3cb9:	e8 75 f4 ff ff       	call   3133 <sbrktest>
    exit();
    3cbe:	e8 29 03 00 00       	call   3fec <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3cc3:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3cca:	00 
    3ccb:	c7 04 24 0f 5d 00 00 	movl   $0x5d0f,(%esp)
    3cd2:	e8 55 03 00 00       	call   402c <open>
    3cd7:	89 04 24             	mov    %eax,(%esp)
    3cda:	e8 35 03 00 00       	call   4014 <close>

  createdelete();
    3cdf:	e8 9e d5 ff ff       	call   1282 <createdelete>
  linkunlink();
    3ce4:	e8 2e e0 ff ff       	call   1d17 <linkunlink>
  concreate();
    3ce9:	e8 2a dc ff ff       	call   1918 <concreate>
  fourfiles();
    3cee:	e8 27 d3 ff ff       	call   101a <fourfiles>
  sharedfd();
    3cf3:	e8 24 d1 ff ff       	call   e1c <sharedfd>

  bigargtest();
    3cf8:	e8 67 fb ff ff       	call   3864 <bigargtest>
  bigwrite();
    3cfd:	e8 f6 e9 ff ff       	call   26f8 <bigwrite>
  bigargtest();
    3d02:	e8 5d fb ff ff       	call   3864 <bigargtest>
  bsstest();
    3d07:	e8 e6 fa ff ff       	call   37f2 <bsstest>
//  sbrktest();
  validatetest();
    3d0c:	e8 f5 f9 ff ff       	call   3706 <validatetest>

  opentest();
    3d11:	e8 b1 c5 ff ff       	call   2c7 <opentest>
  writetest();
    3d16:	e8 57 c6 ff ff       	call   372 <writetest>
  writetest1();
    3d1b:	e8 67 c8 ff ff       	call   587 <writetest1>
  createtest();
    3d20:	e8 6d ca ff ff       	call   792 <createtest>

  openiputtest();
    3d25:	e8 9c c4 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3d2a:	e8 ab c3 ff ff       	call   da <exitiputtest>
  iputtest();
    3d2f:	e8 cc c2 ff ff       	call   0 <iputtest>

  mem();
    3d34:	e8 fe cf ff ff       	call   d37 <mem>
  pipe1();
    3d39:	e8 35 cc ff ff       	call   973 <pipe1>
  preempt();
    3d3e:	e8 1d ce ff ff       	call   b60 <preempt>
  exitwait();
    3d43:	e8 71 cf ff ff       	call   cb9 <exitwait>

  rmdot();
    3d48:	e8 34 ee ff ff       	call   2b81 <rmdot>
  fourteen();
    3d4d:	e8 d9 ec ff ff       	call   2a2b <fourteen>
  bigfile();
    3d52:	e8 a9 ea ff ff       	call   2800 <bigfile>
  subdir();
    3d57:	e8 56 e2 ff ff       	call   1fb2 <subdir>
  linktest();
    3d5c:	e8 6e d9 ff ff       	call   16cf <linktest>
  unlinkread();
    3d61:	e8 94 d7 ff ff       	call   14fa <unlinkread>
  dirfile();
    3d66:	e8 8e ef ff ff       	call   2cf9 <dirfile>
  iref();
    3d6b:	e8 cb f1 ff ff       	call   2f3b <iref>
  forktest();
    3d70:	e8 ea f2 ff ff       	call   305f <forktest>
  bigdir(); // slow
    3d75:	e8 cb e0 ff ff       	call   1e45 <bigdir>
  exectest();
    3d7a:	e8 a5 cb ff ff       	call   924 <exectest>

  exit();
    3d7f:	e8 68 02 00 00       	call   3fec <exit>

00003d84 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3d84:	55                   	push   %ebp
    3d85:	89 e5                	mov    %esp,%ebp
    3d87:	57                   	push   %edi
    3d88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3d89:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3d8c:	8b 55 10             	mov    0x10(%ebp),%edx
    3d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d92:	89 cb                	mov    %ecx,%ebx
    3d94:	89 df                	mov    %ebx,%edi
    3d96:	89 d1                	mov    %edx,%ecx
    3d98:	fc                   	cld    
    3d99:	f3 aa                	rep stos %al,%es:(%edi)
    3d9b:	89 ca                	mov    %ecx,%edx
    3d9d:	89 fb                	mov    %edi,%ebx
    3d9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3da2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3da5:	5b                   	pop    %ebx
    3da6:	5f                   	pop    %edi
    3da7:	5d                   	pop    %ebp
    3da8:	c3                   	ret    

00003da9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3da9:	55                   	push   %ebp
    3daa:	89 e5                	mov    %esp,%ebp
    3dac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3daf:	8b 45 08             	mov    0x8(%ebp),%eax
    3db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3db5:	90                   	nop
    3db6:	8b 45 08             	mov    0x8(%ebp),%eax
    3db9:	8d 50 01             	lea    0x1(%eax),%edx
    3dbc:	89 55 08             	mov    %edx,0x8(%ebp)
    3dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
    3dc2:	8d 4a 01             	lea    0x1(%edx),%ecx
    3dc5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3dc8:	0f b6 12             	movzbl (%edx),%edx
    3dcb:	88 10                	mov    %dl,(%eax)
    3dcd:	0f b6 00             	movzbl (%eax),%eax
    3dd0:	84 c0                	test   %al,%al
    3dd2:	75 e2                	jne    3db6 <strcpy+0xd>
    ;
  return os;
    3dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3dd7:	c9                   	leave  
    3dd8:	c3                   	ret    

00003dd9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3dd9:	55                   	push   %ebp
    3dda:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3ddc:	eb 08                	jmp    3de6 <strcmp+0xd>
    p++, q++;
    3dde:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3de2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3de6:	8b 45 08             	mov    0x8(%ebp),%eax
    3de9:	0f b6 00             	movzbl (%eax),%eax
    3dec:	84 c0                	test   %al,%al
    3dee:	74 10                	je     3e00 <strcmp+0x27>
    3df0:	8b 45 08             	mov    0x8(%ebp),%eax
    3df3:	0f b6 10             	movzbl (%eax),%edx
    3df6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3df9:	0f b6 00             	movzbl (%eax),%eax
    3dfc:	38 c2                	cmp    %al,%dl
    3dfe:	74 de                	je     3dde <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3e00:	8b 45 08             	mov    0x8(%ebp),%eax
    3e03:	0f b6 00             	movzbl (%eax),%eax
    3e06:	0f b6 d0             	movzbl %al,%edx
    3e09:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e0c:	0f b6 00             	movzbl (%eax),%eax
    3e0f:	0f b6 c0             	movzbl %al,%eax
    3e12:	29 c2                	sub    %eax,%edx
    3e14:	89 d0                	mov    %edx,%eax
}
    3e16:	5d                   	pop    %ebp
    3e17:	c3                   	ret    

00003e18 <strlen>:

uint
strlen(char *s)
{
    3e18:	55                   	push   %ebp
    3e19:	89 e5                	mov    %esp,%ebp
    3e1b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3e25:	eb 04                	jmp    3e2b <strlen+0x13>
    3e27:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3e2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e2e:	8b 45 08             	mov    0x8(%ebp),%eax
    3e31:	01 d0                	add    %edx,%eax
    3e33:	0f b6 00             	movzbl (%eax),%eax
    3e36:	84 c0                	test   %al,%al
    3e38:	75 ed                	jne    3e27 <strlen+0xf>
    ;
  return n;
    3e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e3d:	c9                   	leave  
    3e3e:	c3                   	ret    

00003e3f <memset>:

void*
memset(void *dst, int c, uint n)
{
    3e3f:	55                   	push   %ebp
    3e40:	89 e5                	mov    %esp,%ebp
    3e42:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3e45:	8b 45 10             	mov    0x10(%ebp),%eax
    3e48:	89 44 24 08          	mov    %eax,0x8(%esp)
    3e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e53:	8b 45 08             	mov    0x8(%ebp),%eax
    3e56:	89 04 24             	mov    %eax,(%esp)
    3e59:	e8 26 ff ff ff       	call   3d84 <stosb>
  return dst;
    3e5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e61:	c9                   	leave  
    3e62:	c3                   	ret    

00003e63 <strchr>:

char*
strchr(const char *s, char c)
{
    3e63:	55                   	push   %ebp
    3e64:	89 e5                	mov    %esp,%ebp
    3e66:	83 ec 04             	sub    $0x4,%esp
    3e69:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e6c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3e6f:	eb 14                	jmp    3e85 <strchr+0x22>
    if(*s == c)
    3e71:	8b 45 08             	mov    0x8(%ebp),%eax
    3e74:	0f b6 00             	movzbl (%eax),%eax
    3e77:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3e7a:	75 05                	jne    3e81 <strchr+0x1e>
      return (char*)s;
    3e7c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7f:	eb 13                	jmp    3e94 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3e81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e85:	8b 45 08             	mov    0x8(%ebp),%eax
    3e88:	0f b6 00             	movzbl (%eax),%eax
    3e8b:	84 c0                	test   %al,%al
    3e8d:	75 e2                	jne    3e71 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3e94:	c9                   	leave  
    3e95:	c3                   	ret    

00003e96 <gets>:

char*
gets(char *buf, int max)
{
    3e96:	55                   	push   %ebp
    3e97:	89 e5                	mov    %esp,%ebp
    3e99:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3e9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3ea3:	eb 4c                	jmp    3ef1 <gets+0x5b>
    cc = read(0, &c, 1);
    3ea5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3eac:	00 
    3ead:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
    3eb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3ebb:	e8 44 01 00 00       	call   4004 <read>
    3ec0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3ec3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ec7:	7f 02                	jg     3ecb <gets+0x35>
      break;
    3ec9:	eb 31                	jmp    3efc <gets+0x66>
    buf[i++] = c;
    3ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ece:	8d 50 01             	lea    0x1(%eax),%edx
    3ed1:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3ed4:	89 c2                	mov    %eax,%edx
    3ed6:	8b 45 08             	mov    0x8(%ebp),%eax
    3ed9:	01 c2                	add    %eax,%edx
    3edb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3edf:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3ee1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3ee5:	3c 0a                	cmp    $0xa,%al
    3ee7:	74 13                	je     3efc <gets+0x66>
    3ee9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3eed:	3c 0d                	cmp    $0xd,%al
    3eef:	74 0b                	je     3efc <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ef4:	83 c0 01             	add    $0x1,%eax
    3ef7:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3efa:	7c a9                	jl     3ea5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3eff:	8b 45 08             	mov    0x8(%ebp),%eax
    3f02:	01 d0                	add    %edx,%eax
    3f04:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3f07:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3f0a:	c9                   	leave  
    3f0b:	c3                   	ret    

00003f0c <stat>:

int
stat(char *n, struct stat *st)
{
    3f0c:	55                   	push   %ebp
    3f0d:	89 e5                	mov    %esp,%ebp
    3f0f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3f12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3f19:	00 
    3f1a:	8b 45 08             	mov    0x8(%ebp),%eax
    3f1d:	89 04 24             	mov    %eax,(%esp)
    3f20:	e8 07 01 00 00       	call   402c <open>
    3f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3f2c:	79 07                	jns    3f35 <stat+0x29>
    return -1;
    3f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3f33:	eb 23                	jmp    3f58 <stat+0x4c>
  r = fstat(fd, st);
    3f35:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f38:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f3f:	89 04 24             	mov    %eax,(%esp)
    3f42:	e8 fd 00 00 00       	call   4044 <fstat>
    3f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f4d:	89 04 24             	mov    %eax,(%esp)
    3f50:	e8 bf 00 00 00       	call   4014 <close>
  return r;
    3f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3f58:	c9                   	leave  
    3f59:	c3                   	ret    

00003f5a <atoi>:

int
atoi(const char *s)
{
    3f5a:	55                   	push   %ebp
    3f5b:	89 e5                	mov    %esp,%ebp
    3f5d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3f60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3f67:	eb 25                	jmp    3f8e <atoi+0x34>
    n = n*10 + *s++ - '0';
    3f69:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3f6c:	89 d0                	mov    %edx,%eax
    3f6e:	c1 e0 02             	shl    $0x2,%eax
    3f71:	01 d0                	add    %edx,%eax
    3f73:	01 c0                	add    %eax,%eax
    3f75:	89 c1                	mov    %eax,%ecx
    3f77:	8b 45 08             	mov    0x8(%ebp),%eax
    3f7a:	8d 50 01             	lea    0x1(%eax),%edx
    3f7d:	89 55 08             	mov    %edx,0x8(%ebp)
    3f80:	0f b6 00             	movzbl (%eax),%eax
    3f83:	0f be c0             	movsbl %al,%eax
    3f86:	01 c8                	add    %ecx,%eax
    3f88:	83 e8 30             	sub    $0x30,%eax
    3f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3f8e:	8b 45 08             	mov    0x8(%ebp),%eax
    3f91:	0f b6 00             	movzbl (%eax),%eax
    3f94:	3c 2f                	cmp    $0x2f,%al
    3f96:	7e 0a                	jle    3fa2 <atoi+0x48>
    3f98:	8b 45 08             	mov    0x8(%ebp),%eax
    3f9b:	0f b6 00             	movzbl (%eax),%eax
    3f9e:	3c 39                	cmp    $0x39,%al
    3fa0:	7e c7                	jle    3f69 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3fa5:	c9                   	leave  
    3fa6:	c3                   	ret    

00003fa7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3fa7:	55                   	push   %ebp
    3fa8:	89 e5                	mov    %esp,%ebp
    3faa:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3fad:	8b 45 08             	mov    0x8(%ebp),%eax
    3fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fb6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3fb9:	eb 17                	jmp    3fd2 <memmove+0x2b>
    *dst++ = *src++;
    3fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fbe:	8d 50 01             	lea    0x1(%eax),%edx
    3fc1:	89 55 fc             	mov    %edx,-0x4(%ebp)
    3fc4:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3fc7:	8d 4a 01             	lea    0x1(%edx),%ecx
    3fca:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    3fcd:	0f b6 12             	movzbl (%edx),%edx
    3fd0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3fd2:	8b 45 10             	mov    0x10(%ebp),%eax
    3fd5:	8d 50 ff             	lea    -0x1(%eax),%edx
    3fd8:	89 55 10             	mov    %edx,0x10(%ebp)
    3fdb:	85 c0                	test   %eax,%eax
    3fdd:	7f dc                	jg     3fbb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3fdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3fe2:	c9                   	leave  
    3fe3:	c3                   	ret    

00003fe4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3fe4:	b8 01 00 00 00       	mov    $0x1,%eax
    3fe9:	cd 40                	int    $0x40
    3feb:	c3                   	ret    

00003fec <exit>:
SYSCALL(exit)
    3fec:	b8 02 00 00 00       	mov    $0x2,%eax
    3ff1:	cd 40                	int    $0x40
    3ff3:	c3                   	ret    

00003ff4 <wait>:
SYSCALL(wait)
    3ff4:	b8 03 00 00 00       	mov    $0x3,%eax
    3ff9:	cd 40                	int    $0x40
    3ffb:	c3                   	ret    

00003ffc <pipe>:
SYSCALL(pipe)
    3ffc:	b8 04 00 00 00       	mov    $0x4,%eax
    4001:	cd 40                	int    $0x40
    4003:	c3                   	ret    

00004004 <read>:
SYSCALL(read)
    4004:	b8 05 00 00 00       	mov    $0x5,%eax
    4009:	cd 40                	int    $0x40
    400b:	c3                   	ret    

0000400c <write>:
SYSCALL(write)
    400c:	b8 10 00 00 00       	mov    $0x10,%eax
    4011:	cd 40                	int    $0x40
    4013:	c3                   	ret    

00004014 <close>:
SYSCALL(close)
    4014:	b8 15 00 00 00       	mov    $0x15,%eax
    4019:	cd 40                	int    $0x40
    401b:	c3                   	ret    

0000401c <kill>:
SYSCALL(kill)
    401c:	b8 06 00 00 00       	mov    $0x6,%eax
    4021:	cd 40                	int    $0x40
    4023:	c3                   	ret    

00004024 <exec>:
SYSCALL(exec)
    4024:	b8 07 00 00 00       	mov    $0x7,%eax
    4029:	cd 40                	int    $0x40
    402b:	c3                   	ret    

0000402c <open>:
SYSCALL(open)
    402c:	b8 0f 00 00 00       	mov    $0xf,%eax
    4031:	cd 40                	int    $0x40
    4033:	c3                   	ret    

00004034 <mknod>:
SYSCALL(mknod)
    4034:	b8 11 00 00 00       	mov    $0x11,%eax
    4039:	cd 40                	int    $0x40
    403b:	c3                   	ret    

0000403c <unlink>:
SYSCALL(unlink)
    403c:	b8 12 00 00 00       	mov    $0x12,%eax
    4041:	cd 40                	int    $0x40
    4043:	c3                   	ret    

00004044 <fstat>:
SYSCALL(fstat)
    4044:	b8 08 00 00 00       	mov    $0x8,%eax
    4049:	cd 40                	int    $0x40
    404b:	c3                   	ret    

0000404c <link>:
SYSCALL(link)
    404c:	b8 13 00 00 00       	mov    $0x13,%eax
    4051:	cd 40                	int    $0x40
    4053:	c3                   	ret    

00004054 <mkdir>:
SYSCALL(mkdir)
    4054:	b8 14 00 00 00       	mov    $0x14,%eax
    4059:	cd 40                	int    $0x40
    405b:	c3                   	ret    

0000405c <chdir>:
SYSCALL(chdir)
    405c:	b8 09 00 00 00       	mov    $0x9,%eax
    4061:	cd 40                	int    $0x40
    4063:	c3                   	ret    

00004064 <dup>:
SYSCALL(dup)
    4064:	b8 0a 00 00 00       	mov    $0xa,%eax
    4069:	cd 40                	int    $0x40
    406b:	c3                   	ret    

0000406c <getpid>:
SYSCALL(getpid)
    406c:	b8 0b 00 00 00       	mov    $0xb,%eax
    4071:	cd 40                	int    $0x40
    4073:	c3                   	ret    

00004074 <sbrk>:
SYSCALL(sbrk)
    4074:	b8 0c 00 00 00       	mov    $0xc,%eax
    4079:	cd 40                	int    $0x40
    407b:	c3                   	ret    

0000407c <sleep>:
SYSCALL(sleep)
    407c:	b8 0d 00 00 00       	mov    $0xd,%eax
    4081:	cd 40                	int    $0x40
    4083:	c3                   	ret    

00004084 <uptime>:
SYSCALL(uptime)
    4084:	b8 0e 00 00 00       	mov    $0xe,%eax
    4089:	cd 40                	int    $0x40
    408b:	c3                   	ret    

0000408c <sigset>:
SYSCALL(sigset)
    408c:	b8 16 00 00 00       	mov    $0x16,%eax
    4091:	cd 40                	int    $0x40
    4093:	c3                   	ret    

00004094 <sigsend>:
SYSCALL(sigsend)
    4094:	b8 17 00 00 00       	mov    $0x17,%eax
    4099:	cd 40                	int    $0x40
    409b:	c3                   	ret    

0000409c <sigret>:
SYSCALL(sigret)
    409c:	b8 18 00 00 00       	mov    $0x18,%eax
    40a1:	cd 40                	int    $0x40
    40a3:	c3                   	ret    

000040a4 <sigpause>:
SYSCALL(sigpause)
    40a4:	b8 19 00 00 00       	mov    $0x19,%eax
    40a9:	cd 40                	int    $0x40
    40ab:	c3                   	ret    

000040ac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    40ac:	55                   	push   %ebp
    40ad:	89 e5                	mov    %esp,%ebp
    40af:	83 ec 18             	sub    $0x18,%esp
    40b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    40b5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    40b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    40bf:	00 
    40c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    40c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    40c7:	8b 45 08             	mov    0x8(%ebp),%eax
    40ca:	89 04 24             	mov    %eax,(%esp)
    40cd:	e8 3a ff ff ff       	call   400c <write>
}
    40d2:	c9                   	leave  
    40d3:	c3                   	ret    

000040d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    40d4:	55                   	push   %ebp
    40d5:	89 e5                	mov    %esp,%ebp
    40d7:	56                   	push   %esi
    40d8:	53                   	push   %ebx
    40d9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    40dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    40e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    40e7:	74 17                	je     4100 <printint+0x2c>
    40e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    40ed:	79 11                	jns    4100 <printint+0x2c>
    neg = 1;
    40ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    40f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    40f9:	f7 d8                	neg    %eax
    40fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    40fe:	eb 06                	jmp    4106 <printint+0x32>
  } else {
    x = xx;
    4100:	8b 45 0c             	mov    0xc(%ebp),%eax
    4103:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    4106:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    410d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4110:	8d 41 01             	lea    0x1(%ecx),%eax
    4113:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4116:	8b 5d 10             	mov    0x10(%ebp),%ebx
    4119:	8b 45 ec             	mov    -0x14(%ebp),%eax
    411c:	ba 00 00 00 00       	mov    $0x0,%edx
    4121:	f7 f3                	div    %ebx
    4123:	89 d0                	mov    %edx,%eax
    4125:	0f b6 80 48 64 00 00 	movzbl 0x6448(%eax),%eax
    412c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    4130:	8b 75 10             	mov    0x10(%ebp),%esi
    4133:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4136:	ba 00 00 00 00       	mov    $0x0,%edx
    413b:	f7 f6                	div    %esi
    413d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4140:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4144:	75 c7                	jne    410d <printint+0x39>
  if(neg)
    4146:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    414a:	74 10                	je     415c <printint+0x88>
    buf[i++] = '-';
    414c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    414f:	8d 50 01             	lea    0x1(%eax),%edx
    4152:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4155:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    415a:	eb 1f                	jmp    417b <printint+0xa7>
    415c:	eb 1d                	jmp    417b <printint+0xa7>
    putc(fd, buf[i]);
    415e:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4161:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4164:	01 d0                	add    %edx,%eax
    4166:	0f b6 00             	movzbl (%eax),%eax
    4169:	0f be c0             	movsbl %al,%eax
    416c:	89 44 24 04          	mov    %eax,0x4(%esp)
    4170:	8b 45 08             	mov    0x8(%ebp),%eax
    4173:	89 04 24             	mov    %eax,(%esp)
    4176:	e8 31 ff ff ff       	call   40ac <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    417b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    417f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4183:	79 d9                	jns    415e <printint+0x8a>
    putc(fd, buf[i]);
}
    4185:	83 c4 30             	add    $0x30,%esp
    4188:	5b                   	pop    %ebx
    4189:	5e                   	pop    %esi
    418a:	5d                   	pop    %ebp
    418b:	c3                   	ret    

0000418c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    418c:	55                   	push   %ebp
    418d:	89 e5                	mov    %esp,%ebp
    418f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4192:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4199:	8d 45 0c             	lea    0xc(%ebp),%eax
    419c:	83 c0 04             	add    $0x4,%eax
    419f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    41a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    41a9:	e9 7c 01 00 00       	jmp    432a <printf+0x19e>
    c = fmt[i] & 0xff;
    41ae:	8b 55 0c             	mov    0xc(%ebp),%edx
    41b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41b4:	01 d0                	add    %edx,%eax
    41b6:	0f b6 00             	movzbl (%eax),%eax
    41b9:	0f be c0             	movsbl %al,%eax
    41bc:	25 ff 00 00 00       	and    $0xff,%eax
    41c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    41c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    41c8:	75 2c                	jne    41f6 <printf+0x6a>
      if(c == '%'){
    41ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41ce:	75 0c                	jne    41dc <printf+0x50>
        state = '%';
    41d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    41d7:	e9 4a 01 00 00       	jmp    4326 <printf+0x19a>
      } else {
        putc(fd, c);
    41dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41df:	0f be c0             	movsbl %al,%eax
    41e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    41e6:	8b 45 08             	mov    0x8(%ebp),%eax
    41e9:	89 04 24             	mov    %eax,(%esp)
    41ec:	e8 bb fe ff ff       	call   40ac <putc>
    41f1:	e9 30 01 00 00       	jmp    4326 <printf+0x19a>
      }
    } else if(state == '%'){
    41f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    41fa:	0f 85 26 01 00 00    	jne    4326 <printf+0x19a>
      if(c == 'd'){
    4200:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    4204:	75 2d                	jne    4233 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    4206:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4209:	8b 00                	mov    (%eax),%eax
    420b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    4212:	00 
    4213:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    421a:	00 
    421b:	89 44 24 04          	mov    %eax,0x4(%esp)
    421f:	8b 45 08             	mov    0x8(%ebp),%eax
    4222:	89 04 24             	mov    %eax,(%esp)
    4225:	e8 aa fe ff ff       	call   40d4 <printint>
        ap++;
    422a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    422e:	e9 ec 00 00 00       	jmp    431f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    4233:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4237:	74 06                	je     423f <printf+0xb3>
    4239:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    423d:	75 2d                	jne    426c <printf+0xe0>
        printint(fd, *ap, 16, 0);
    423f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4242:	8b 00                	mov    (%eax),%eax
    4244:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    424b:	00 
    424c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    4253:	00 
    4254:	89 44 24 04          	mov    %eax,0x4(%esp)
    4258:	8b 45 08             	mov    0x8(%ebp),%eax
    425b:	89 04 24             	mov    %eax,(%esp)
    425e:	e8 71 fe ff ff       	call   40d4 <printint>
        ap++;
    4263:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4267:	e9 b3 00 00 00       	jmp    431f <printf+0x193>
      } else if(c == 's'){
    426c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    4270:	75 45                	jne    42b7 <printf+0x12b>
        s = (char*)*ap;
    4272:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4275:	8b 00                	mov    (%eax),%eax
    4277:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    427a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    427e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4282:	75 09                	jne    428d <printf+0x101>
          s = "(null)";
    4284:	c7 45 f4 4a 5d 00 00 	movl   $0x5d4a,-0xc(%ebp)
        while(*s != 0){
    428b:	eb 1e                	jmp    42ab <printf+0x11f>
    428d:	eb 1c                	jmp    42ab <printf+0x11f>
          putc(fd, *s);
    428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4292:	0f b6 00             	movzbl (%eax),%eax
    4295:	0f be c0             	movsbl %al,%eax
    4298:	89 44 24 04          	mov    %eax,0x4(%esp)
    429c:	8b 45 08             	mov    0x8(%ebp),%eax
    429f:	89 04 24             	mov    %eax,(%esp)
    42a2:	e8 05 fe ff ff       	call   40ac <putc>
          s++;
    42a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    42ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42ae:	0f b6 00             	movzbl (%eax),%eax
    42b1:	84 c0                	test   %al,%al
    42b3:	75 da                	jne    428f <printf+0x103>
    42b5:	eb 68                	jmp    431f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    42b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    42bb:	75 1d                	jne    42da <printf+0x14e>
        putc(fd, *ap);
    42bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    42c0:	8b 00                	mov    (%eax),%eax
    42c2:	0f be c0             	movsbl %al,%eax
    42c5:	89 44 24 04          	mov    %eax,0x4(%esp)
    42c9:	8b 45 08             	mov    0x8(%ebp),%eax
    42cc:	89 04 24             	mov    %eax,(%esp)
    42cf:	e8 d8 fd ff ff       	call   40ac <putc>
        ap++;
    42d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    42d8:	eb 45                	jmp    431f <printf+0x193>
      } else if(c == '%'){
    42da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    42de:	75 17                	jne    42f7 <printf+0x16b>
        putc(fd, c);
    42e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42e3:	0f be c0             	movsbl %al,%eax
    42e6:	89 44 24 04          	mov    %eax,0x4(%esp)
    42ea:	8b 45 08             	mov    0x8(%ebp),%eax
    42ed:	89 04 24             	mov    %eax,(%esp)
    42f0:	e8 b7 fd ff ff       	call   40ac <putc>
    42f5:	eb 28                	jmp    431f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    42f7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    42fe:	00 
    42ff:	8b 45 08             	mov    0x8(%ebp),%eax
    4302:	89 04 24             	mov    %eax,(%esp)
    4305:	e8 a2 fd ff ff       	call   40ac <putc>
        putc(fd, c);
    430a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    430d:	0f be c0             	movsbl %al,%eax
    4310:	89 44 24 04          	mov    %eax,0x4(%esp)
    4314:	8b 45 08             	mov    0x8(%ebp),%eax
    4317:	89 04 24             	mov    %eax,(%esp)
    431a:	e8 8d fd ff ff       	call   40ac <putc>
      }
      state = 0;
    431f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4326:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    432a:	8b 55 0c             	mov    0xc(%ebp),%edx
    432d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4330:	01 d0                	add    %edx,%eax
    4332:	0f b6 00             	movzbl (%eax),%eax
    4335:	84 c0                	test   %al,%al
    4337:	0f 85 71 fe ff ff    	jne    41ae <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    433d:	c9                   	leave  
    433e:	c3                   	ret    

0000433f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    433f:	55                   	push   %ebp
    4340:	89 e5                	mov    %esp,%ebp
    4342:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4345:	8b 45 08             	mov    0x8(%ebp),%eax
    4348:	83 e8 08             	sub    $0x8,%eax
    434b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    434e:	a1 e8 64 00 00       	mov    0x64e8,%eax
    4353:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4356:	eb 24                	jmp    437c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4358:	8b 45 fc             	mov    -0x4(%ebp),%eax
    435b:	8b 00                	mov    (%eax),%eax
    435d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4360:	77 12                	ja     4374 <free+0x35>
    4362:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4365:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4368:	77 24                	ja     438e <free+0x4f>
    436a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    436d:	8b 00                	mov    (%eax),%eax
    436f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4372:	77 1a                	ja     438e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4374:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4377:	8b 00                	mov    (%eax),%eax
    4379:	89 45 fc             	mov    %eax,-0x4(%ebp)
    437c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    437f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4382:	76 d4                	jbe    4358 <free+0x19>
    4384:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4387:	8b 00                	mov    (%eax),%eax
    4389:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    438c:	76 ca                	jbe    4358 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    438e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4391:	8b 40 04             	mov    0x4(%eax),%eax
    4394:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    439b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    439e:	01 c2                	add    %eax,%edx
    43a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43a3:	8b 00                	mov    (%eax),%eax
    43a5:	39 c2                	cmp    %eax,%edx
    43a7:	75 24                	jne    43cd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    43a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43ac:	8b 50 04             	mov    0x4(%eax),%edx
    43af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43b2:	8b 00                	mov    (%eax),%eax
    43b4:	8b 40 04             	mov    0x4(%eax),%eax
    43b7:	01 c2                	add    %eax,%edx
    43b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43bc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    43bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43c2:	8b 00                	mov    (%eax),%eax
    43c4:	8b 10                	mov    (%eax),%edx
    43c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43c9:	89 10                	mov    %edx,(%eax)
    43cb:	eb 0a                	jmp    43d7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    43cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43d0:	8b 10                	mov    (%eax),%edx
    43d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43d5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    43d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43da:	8b 40 04             	mov    0x4(%eax),%eax
    43dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    43e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43e7:	01 d0                	add    %edx,%eax
    43e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    43ec:	75 20                	jne    440e <free+0xcf>
    p->s.size += bp->s.size;
    43ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43f1:	8b 50 04             	mov    0x4(%eax),%edx
    43f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43f7:	8b 40 04             	mov    0x4(%eax),%eax
    43fa:	01 c2                	add    %eax,%edx
    43fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4402:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4405:	8b 10                	mov    (%eax),%edx
    4407:	8b 45 fc             	mov    -0x4(%ebp),%eax
    440a:	89 10                	mov    %edx,(%eax)
    440c:	eb 08                	jmp    4416 <free+0xd7>
  } else
    p->s.ptr = bp;
    440e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4411:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4414:	89 10                	mov    %edx,(%eax)
  freep = p;
    4416:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4419:	a3 e8 64 00 00       	mov    %eax,0x64e8
}
    441e:	c9                   	leave  
    441f:	c3                   	ret    

00004420 <morecore>:

static Header*
morecore(uint nu)
{
    4420:	55                   	push   %ebp
    4421:	89 e5                	mov    %esp,%ebp
    4423:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4426:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    442d:	77 07                	ja     4436 <morecore+0x16>
    nu = 4096;
    442f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4436:	8b 45 08             	mov    0x8(%ebp),%eax
    4439:	c1 e0 03             	shl    $0x3,%eax
    443c:	89 04 24             	mov    %eax,(%esp)
    443f:	e8 30 fc ff ff       	call   4074 <sbrk>
    4444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4447:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    444b:	75 07                	jne    4454 <morecore+0x34>
    return 0;
    444d:	b8 00 00 00 00       	mov    $0x0,%eax
    4452:	eb 22                	jmp    4476 <morecore+0x56>
  hp = (Header*)p;
    4454:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4457:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    445a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    445d:	8b 55 08             	mov    0x8(%ebp),%edx
    4460:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4463:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4466:	83 c0 08             	add    $0x8,%eax
    4469:	89 04 24             	mov    %eax,(%esp)
    446c:	e8 ce fe ff ff       	call   433f <free>
  return freep;
    4471:	a1 e8 64 00 00       	mov    0x64e8,%eax
}
    4476:	c9                   	leave  
    4477:	c3                   	ret    

00004478 <malloc>:

void*
malloc(uint nbytes)
{
    4478:	55                   	push   %ebp
    4479:	89 e5                	mov    %esp,%ebp
    447b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    447e:	8b 45 08             	mov    0x8(%ebp),%eax
    4481:	83 c0 07             	add    $0x7,%eax
    4484:	c1 e8 03             	shr    $0x3,%eax
    4487:	83 c0 01             	add    $0x1,%eax
    448a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    448d:	a1 e8 64 00 00       	mov    0x64e8,%eax
    4492:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4495:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4499:	75 23                	jne    44be <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    449b:	c7 45 f0 e0 64 00 00 	movl   $0x64e0,-0x10(%ebp)
    44a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44a5:	a3 e8 64 00 00       	mov    %eax,0x64e8
    44aa:	a1 e8 64 00 00       	mov    0x64e8,%eax
    44af:	a3 e0 64 00 00       	mov    %eax,0x64e0
    base.s.size = 0;
    44b4:	c7 05 e4 64 00 00 00 	movl   $0x0,0x64e4
    44bb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    44be:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44c1:	8b 00                	mov    (%eax),%eax
    44c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    44c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44c9:	8b 40 04             	mov    0x4(%eax),%eax
    44cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    44cf:	72 4d                	jb     451e <malloc+0xa6>
      if(p->s.size == nunits)
    44d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44d4:	8b 40 04             	mov    0x4(%eax),%eax
    44d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    44da:	75 0c                	jne    44e8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    44dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44df:	8b 10                	mov    (%eax),%edx
    44e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44e4:	89 10                	mov    %edx,(%eax)
    44e6:	eb 26                	jmp    450e <malloc+0x96>
      else {
        p->s.size -= nunits;
    44e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44eb:	8b 40 04             	mov    0x4(%eax),%eax
    44ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
    44f1:	89 c2                	mov    %eax,%edx
    44f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44f6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    44f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44fc:	8b 40 04             	mov    0x4(%eax),%eax
    44ff:	c1 e0 03             	shl    $0x3,%eax
    4502:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4505:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4508:	8b 55 ec             	mov    -0x14(%ebp),%edx
    450b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    450e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4511:	a3 e8 64 00 00       	mov    %eax,0x64e8
      return (void*)(p + 1);
    4516:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4519:	83 c0 08             	add    $0x8,%eax
    451c:	eb 38                	jmp    4556 <malloc+0xde>
    }
    if(p == freep)
    451e:	a1 e8 64 00 00       	mov    0x64e8,%eax
    4523:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4526:	75 1b                	jne    4543 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    4528:	8b 45 ec             	mov    -0x14(%ebp),%eax
    452b:	89 04 24             	mov    %eax,(%esp)
    452e:	e8 ed fe ff ff       	call   4420 <morecore>
    4533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    453a:	75 07                	jne    4543 <malloc+0xcb>
        return 0;
    453c:	b8 00 00 00 00       	mov    $0x0,%eax
    4541:	eb 13                	jmp    4556 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4543:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4546:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4549:	8b 45 f4             	mov    -0xc(%ebp),%eax
    454c:	8b 00                	mov    (%eax),%eax
    454e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4551:	e9 70 ff ff ff       	jmp    44c6 <malloc+0x4e>
}
    4556:	c9                   	leave  
    4557:	c3                   	ret    
