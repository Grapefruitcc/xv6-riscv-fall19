
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <iputtest>:
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  printf("iput test\n");
       8:	00004517          	auipc	a0,0x4
       c:	6a050513          	addi	a0,a0,1696 # 46a8 <malloc+0x10c>
      10:	00004097          	auipc	ra,0x4
      14:	4ce080e7          	jalr	1230(ra) # 44de <printf>

  if(mkdir("iputdir") < 0){
      18:	00004517          	auipc	a0,0x4
      1c:	6a050513          	addi	a0,a0,1696 # 46b8 <malloc+0x11c>
      20:	00004097          	auipc	ra,0x4
      24:	18e080e7          	jalr	398(ra) # 41ae <mkdir>
      28:	04054c63          	bltz	a0,80 <iputtest+0x80>
    printf("mkdir failed\n");
    exit(-1);
  }
  if(chdir("iputdir") < 0){
      2c:	00004517          	auipc	a0,0x4
      30:	68c50513          	addi	a0,a0,1676 # 46b8 <malloc+0x11c>
      34:	00004097          	auipc	ra,0x4
      38:	182080e7          	jalr	386(ra) # 41b6 <chdir>
      3c:	04054f63          	bltz	a0,9a <iputtest+0x9a>
    printf("chdir iputdir failed\n");
    exit(-1);
  }
  if(unlink("../iputdir") < 0){
      40:	00004517          	auipc	a0,0x4
      44:	6a850513          	addi	a0,a0,1704 # 46e8 <malloc+0x14c>
      48:	00004097          	auipc	ra,0x4
      4c:	14e080e7          	jalr	334(ra) # 4196 <unlink>
      50:	06054263          	bltz	a0,b4 <iputtest+0xb4>
    printf("unlink ../iputdir failed\n");
    exit(-1);
  }
  if(chdir("/") < 0){
      54:	00004517          	auipc	a0,0x4
      58:	6c450513          	addi	a0,a0,1732 # 4718 <malloc+0x17c>
      5c:	00004097          	auipc	ra,0x4
      60:	15a080e7          	jalr	346(ra) # 41b6 <chdir>
      64:	06054563          	bltz	a0,ce <iputtest+0xce>
    printf("chdir / failed\n");
    exit(-1);
  }
  printf("iput test ok\n");
      68:	00004517          	auipc	a0,0x4
      6c:	6c850513          	addi	a0,a0,1736 # 4730 <malloc+0x194>
      70:	00004097          	auipc	ra,0x4
      74:	46e080e7          	jalr	1134(ra) # 44de <printf>
}
      78:	60a2                	ld	ra,8(sp)
      7a:	6402                	ld	s0,0(sp)
      7c:	0141                	addi	sp,sp,16
      7e:	8082                	ret
    printf("mkdir failed\n");
      80:	00004517          	auipc	a0,0x4
      84:	64050513          	addi	a0,a0,1600 # 46c0 <malloc+0x124>
      88:	00004097          	auipc	ra,0x4
      8c:	456080e7          	jalr	1110(ra) # 44de <printf>
    exit(-1);
      90:	557d                	li	a0,-1
      92:	00004097          	auipc	ra,0x4
      96:	0b4080e7          	jalr	180(ra) # 4146 <exit>
    printf("chdir iputdir failed\n");
      9a:	00004517          	auipc	a0,0x4
      9e:	63650513          	addi	a0,a0,1590 # 46d0 <malloc+0x134>
      a2:	00004097          	auipc	ra,0x4
      a6:	43c080e7          	jalr	1084(ra) # 44de <printf>
    exit(-1);
      aa:	557d                	li	a0,-1
      ac:	00004097          	auipc	ra,0x4
      b0:	09a080e7          	jalr	154(ra) # 4146 <exit>
    printf("unlink ../iputdir failed\n");
      b4:	00004517          	auipc	a0,0x4
      b8:	64450513          	addi	a0,a0,1604 # 46f8 <malloc+0x15c>
      bc:	00004097          	auipc	ra,0x4
      c0:	422080e7          	jalr	1058(ra) # 44de <printf>
    exit(-1);
      c4:	557d                	li	a0,-1
      c6:	00004097          	auipc	ra,0x4
      ca:	080080e7          	jalr	128(ra) # 4146 <exit>
    printf("chdir / failed\n");
      ce:	00004517          	auipc	a0,0x4
      d2:	65250513          	addi	a0,a0,1618 # 4720 <malloc+0x184>
      d6:	00004097          	auipc	ra,0x4
      da:	408080e7          	jalr	1032(ra) # 44de <printf>
    exit(-1);
      de:	557d                	li	a0,-1
      e0:	00004097          	auipc	ra,0x4
      e4:	066080e7          	jalr	102(ra) # 4146 <exit>

00000000000000e8 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      e8:	1141                	addi	sp,sp,-16
      ea:	e406                	sd	ra,8(sp)
      ec:	e022                	sd	s0,0(sp)
      ee:	0800                	addi	s0,sp,16
  int pid;

  printf("exitiput test\n");
      f0:	00004517          	auipc	a0,0x4
      f4:	65050513          	addi	a0,a0,1616 # 4740 <malloc+0x1a4>
      f8:	00004097          	auipc	ra,0x4
      fc:	3e6080e7          	jalr	998(ra) # 44de <printf>

  pid = fork();
     100:	00004097          	auipc	ra,0x4
     104:	03e080e7          	jalr	62(ra) # 413e <fork>
  if(pid < 0){
     108:	04054663          	bltz	a0,154 <exitiputtest+0x6c>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid == 0){
     10c:	e945                	bnez	a0,1bc <exitiputtest+0xd4>
    if(mkdir("iputdir") < 0){
     10e:	00004517          	auipc	a0,0x4
     112:	5aa50513          	addi	a0,a0,1450 # 46b8 <malloc+0x11c>
     116:	00004097          	auipc	ra,0x4
     11a:	098080e7          	jalr	152(ra) # 41ae <mkdir>
     11e:	04054863          	bltz	a0,16e <exitiputtest+0x86>
      printf("mkdir failed\n");
      exit(-1);
    }
    if(chdir("iputdir") < 0){
     122:	00004517          	auipc	a0,0x4
     126:	59650513          	addi	a0,a0,1430 # 46b8 <malloc+0x11c>
     12a:	00004097          	auipc	ra,0x4
     12e:	08c080e7          	jalr	140(ra) # 41b6 <chdir>
     132:	04054b63          	bltz	a0,188 <exitiputtest+0xa0>
      printf("child chdir failed\n");
      exit(-1);
    }
    if(unlink("../iputdir") < 0){
     136:	00004517          	auipc	a0,0x4
     13a:	5b250513          	addi	a0,a0,1458 # 46e8 <malloc+0x14c>
     13e:	00004097          	auipc	ra,0x4
     142:	058080e7          	jalr	88(ra) # 4196 <unlink>
     146:	04054e63          	bltz	a0,1a2 <exitiputtest+0xba>
      printf("unlink ../iputdir failed\n");
      exit(-1);
    }
    exit(0);
     14a:	4501                	li	a0,0
     14c:	00004097          	auipc	ra,0x4
     150:	ffa080e7          	jalr	-6(ra) # 4146 <exit>
    printf("fork failed\n");
     154:	00004517          	auipc	a0,0x4
     158:	5fc50513          	addi	a0,a0,1532 # 4750 <malloc+0x1b4>
     15c:	00004097          	auipc	ra,0x4
     160:	382080e7          	jalr	898(ra) # 44de <printf>
    exit(-1);
     164:	557d                	li	a0,-1
     166:	00004097          	auipc	ra,0x4
     16a:	fe0080e7          	jalr	-32(ra) # 4146 <exit>
      printf("mkdir failed\n");
     16e:	00004517          	auipc	a0,0x4
     172:	55250513          	addi	a0,a0,1362 # 46c0 <malloc+0x124>
     176:	00004097          	auipc	ra,0x4
     17a:	368080e7          	jalr	872(ra) # 44de <printf>
      exit(-1);
     17e:	557d                	li	a0,-1
     180:	00004097          	auipc	ra,0x4
     184:	fc6080e7          	jalr	-58(ra) # 4146 <exit>
      printf("child chdir failed\n");
     188:	00004517          	auipc	a0,0x4
     18c:	5d850513          	addi	a0,a0,1496 # 4760 <malloc+0x1c4>
     190:	00004097          	auipc	ra,0x4
     194:	34e080e7          	jalr	846(ra) # 44de <printf>
      exit(-1);
     198:	557d                	li	a0,-1
     19a:	00004097          	auipc	ra,0x4
     19e:	fac080e7          	jalr	-84(ra) # 4146 <exit>
      printf("unlink ../iputdir failed\n");
     1a2:	00004517          	auipc	a0,0x4
     1a6:	55650513          	addi	a0,a0,1366 # 46f8 <malloc+0x15c>
     1aa:	00004097          	auipc	ra,0x4
     1ae:	334080e7          	jalr	820(ra) # 44de <printf>
      exit(-1);
     1b2:	557d                	li	a0,-1
     1b4:	00004097          	auipc	ra,0x4
     1b8:	f92080e7          	jalr	-110(ra) # 4146 <exit>
  }
  wait(0);
     1bc:	4501                	li	a0,0
     1be:	00004097          	auipc	ra,0x4
     1c2:	f90080e7          	jalr	-112(ra) # 414e <wait>
  printf("exitiput test ok\n");
     1c6:	00004517          	auipc	a0,0x4
     1ca:	5b250513          	addi	a0,a0,1458 # 4778 <malloc+0x1dc>
     1ce:	00004097          	auipc	ra,0x4
     1d2:	310080e7          	jalr	784(ra) # 44de <printf>
}
     1d6:	60a2                	ld	ra,8(sp)
     1d8:	6402                	ld	s0,0(sp)
     1da:	0141                	addi	sp,sp,16
     1dc:	8082                	ret

00000000000001de <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1de:	1141                	addi	sp,sp,-16
     1e0:	e406                	sd	ra,8(sp)
     1e2:	e022                	sd	s0,0(sp)
     1e4:	0800                	addi	s0,sp,16
  int pid;

  printf("openiput test\n");
     1e6:	00004517          	auipc	a0,0x4
     1ea:	5aa50513          	addi	a0,a0,1450 # 4790 <malloc+0x1f4>
     1ee:	00004097          	auipc	ra,0x4
     1f2:	2f0080e7          	jalr	752(ra) # 44de <printf>
  if(mkdir("oidir") < 0){
     1f6:	00004517          	auipc	a0,0x4
     1fa:	5aa50513          	addi	a0,a0,1450 # 47a0 <malloc+0x204>
     1fe:	00004097          	auipc	ra,0x4
     202:	fb0080e7          	jalr	-80(ra) # 41ae <mkdir>
     206:	04054163          	bltz	a0,248 <openiputtest+0x6a>
    printf("mkdir oidir failed\n");
    exit(-1);
  }
  pid = fork();
     20a:	00004097          	auipc	ra,0x4
     20e:	f34080e7          	jalr	-204(ra) # 413e <fork>
  if(pid < 0){
     212:	04054863          	bltz	a0,262 <openiputtest+0x84>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid == 0){
     216:	e925                	bnez	a0,286 <openiputtest+0xa8>
    int fd = open("oidir", O_RDWR);
     218:	4589                	li	a1,2
     21a:	00004517          	auipc	a0,0x4
     21e:	58650513          	addi	a0,a0,1414 # 47a0 <malloc+0x204>
     222:	00004097          	auipc	ra,0x4
     226:	f64080e7          	jalr	-156(ra) # 4186 <open>
    if(fd >= 0){
     22a:	04054963          	bltz	a0,27c <openiputtest+0x9e>
      printf("open directory for write succeeded\n");
     22e:	00004517          	auipc	a0,0x4
     232:	59250513          	addi	a0,a0,1426 # 47c0 <malloc+0x224>
     236:	00004097          	auipc	ra,0x4
     23a:	2a8080e7          	jalr	680(ra) # 44de <printf>
      exit(-1);
     23e:	557d                	li	a0,-1
     240:	00004097          	auipc	ra,0x4
     244:	f06080e7          	jalr	-250(ra) # 4146 <exit>
    printf("mkdir oidir failed\n");
     248:	00004517          	auipc	a0,0x4
     24c:	56050513          	addi	a0,a0,1376 # 47a8 <malloc+0x20c>
     250:	00004097          	auipc	ra,0x4
     254:	28e080e7          	jalr	654(ra) # 44de <printf>
    exit(-1);
     258:	557d                	li	a0,-1
     25a:	00004097          	auipc	ra,0x4
     25e:	eec080e7          	jalr	-276(ra) # 4146 <exit>
    printf("fork failed\n");
     262:	00004517          	auipc	a0,0x4
     266:	4ee50513          	addi	a0,a0,1262 # 4750 <malloc+0x1b4>
     26a:	00004097          	auipc	ra,0x4
     26e:	274080e7          	jalr	628(ra) # 44de <printf>
    exit(-1);
     272:	557d                	li	a0,-1
     274:	00004097          	auipc	ra,0x4
     278:	ed2080e7          	jalr	-302(ra) # 4146 <exit>
    }
    exit(0);
     27c:	4501                	li	a0,0
     27e:	00004097          	auipc	ra,0x4
     282:	ec8080e7          	jalr	-312(ra) # 4146 <exit>
  }
  sleep(1);
     286:	4505                	li	a0,1
     288:	00004097          	auipc	ra,0x4
     28c:	f4e080e7          	jalr	-178(ra) # 41d6 <sleep>
  if(unlink("oidir") != 0){
     290:	00004517          	auipc	a0,0x4
     294:	51050513          	addi	a0,a0,1296 # 47a0 <malloc+0x204>
     298:	00004097          	auipc	ra,0x4
     29c:	efe080e7          	jalr	-258(ra) # 4196 <unlink>
     2a0:	e115                	bnez	a0,2c4 <openiputtest+0xe6>
    printf("unlink failed\n");
    exit(-1);
  }
  wait(0);
     2a2:	4501                	li	a0,0
     2a4:	00004097          	auipc	ra,0x4
     2a8:	eaa080e7          	jalr	-342(ra) # 414e <wait>
  printf("openiput test ok\n");
     2ac:	00004517          	auipc	a0,0x4
     2b0:	54c50513          	addi	a0,a0,1356 # 47f8 <malloc+0x25c>
     2b4:	00004097          	auipc	ra,0x4
     2b8:	22a080e7          	jalr	554(ra) # 44de <printf>
}
     2bc:	60a2                	ld	ra,8(sp)
     2be:	6402                	ld	s0,0(sp)
     2c0:	0141                	addi	sp,sp,16
     2c2:	8082                	ret
    printf("unlink failed\n");
     2c4:	00004517          	auipc	a0,0x4
     2c8:	52450513          	addi	a0,a0,1316 # 47e8 <malloc+0x24c>
     2cc:	00004097          	auipc	ra,0x4
     2d0:	212080e7          	jalr	530(ra) # 44de <printf>
    exit(-1);
     2d4:	557d                	li	a0,-1
     2d6:	00004097          	auipc	ra,0x4
     2da:	e70080e7          	jalr	-400(ra) # 4146 <exit>

00000000000002de <opentest>:

// simple file system tests

void
opentest(void)
{
     2de:	1141                	addi	sp,sp,-16
     2e0:	e406                	sd	ra,8(sp)
     2e2:	e022                	sd	s0,0(sp)
     2e4:	0800                	addi	s0,sp,16
  int fd;

  printf("open test\n");
     2e6:	00004517          	auipc	a0,0x4
     2ea:	52a50513          	addi	a0,a0,1322 # 4810 <malloc+0x274>
     2ee:	00004097          	auipc	ra,0x4
     2f2:	1f0080e7          	jalr	496(ra) # 44de <printf>
  fd = open("echo", 0);
     2f6:	4581                	li	a1,0
     2f8:	00004517          	auipc	a0,0x4
     2fc:	52850513          	addi	a0,a0,1320 # 4820 <malloc+0x284>
     300:	00004097          	auipc	ra,0x4
     304:	e86080e7          	jalr	-378(ra) # 4186 <open>
  if(fd < 0){
     308:	02054d63          	bltz	a0,342 <opentest+0x64>
    printf("open echo failed!\n");
    exit(-1);
  }
  close(fd);
     30c:	00004097          	auipc	ra,0x4
     310:	e62080e7          	jalr	-414(ra) # 416e <close>
  fd = open("doesnotexist", 0);
     314:	4581                	li	a1,0
     316:	00004517          	auipc	a0,0x4
     31a:	52a50513          	addi	a0,a0,1322 # 4840 <malloc+0x2a4>
     31e:	00004097          	auipc	ra,0x4
     322:	e68080e7          	jalr	-408(ra) # 4186 <open>
  if(fd >= 0){
     326:	02055b63          	bgez	a0,35c <opentest+0x7e>
    printf("open doesnotexist succeeded!\n");
    exit(-1);
  }
  printf("open test ok\n");
     32a:	00004517          	auipc	a0,0x4
     32e:	54650513          	addi	a0,a0,1350 # 4870 <malloc+0x2d4>
     332:	00004097          	auipc	ra,0x4
     336:	1ac080e7          	jalr	428(ra) # 44de <printf>
}
     33a:	60a2                	ld	ra,8(sp)
     33c:	6402                	ld	s0,0(sp)
     33e:	0141                	addi	sp,sp,16
     340:	8082                	ret
    printf("open echo failed!\n");
     342:	00004517          	auipc	a0,0x4
     346:	4e650513          	addi	a0,a0,1254 # 4828 <malloc+0x28c>
     34a:	00004097          	auipc	ra,0x4
     34e:	194080e7          	jalr	404(ra) # 44de <printf>
    exit(-1);
     352:	557d                	li	a0,-1
     354:	00004097          	auipc	ra,0x4
     358:	df2080e7          	jalr	-526(ra) # 4146 <exit>
    printf("open doesnotexist succeeded!\n");
     35c:	00004517          	auipc	a0,0x4
     360:	4f450513          	addi	a0,a0,1268 # 4850 <malloc+0x2b4>
     364:	00004097          	auipc	ra,0x4
     368:	17a080e7          	jalr	378(ra) # 44de <printf>
    exit(-1);
     36c:	557d                	li	a0,-1
     36e:	00004097          	auipc	ra,0x4
     372:	dd8080e7          	jalr	-552(ra) # 4146 <exit>

0000000000000376 <writetest>:

void
writetest(void)
{
     376:	7139                	addi	sp,sp,-64
     378:	fc06                	sd	ra,56(sp)
     37a:	f822                	sd	s0,48(sp)
     37c:	f426                	sd	s1,40(sp)
     37e:	f04a                	sd	s2,32(sp)
     380:	ec4e                	sd	s3,24(sp)
     382:	e852                	sd	s4,16(sp)
     384:	e456                	sd	s5,8(sp)
     386:	0080                	addi	s0,sp,64
  int fd;
  int i;
  enum { N=100, SZ=10 };
  
  printf("small file test\n");
     388:	00004517          	auipc	a0,0x4
     38c:	4f850513          	addi	a0,a0,1272 # 4880 <malloc+0x2e4>
     390:	00004097          	auipc	ra,0x4
     394:	14e080e7          	jalr	334(ra) # 44de <printf>
  fd = open("small", O_CREATE|O_RDWR);
     398:	20200593          	li	a1,514
     39c:	00004517          	auipc	a0,0x4
     3a0:	4fc50513          	addi	a0,a0,1276 # 4898 <malloc+0x2fc>
     3a4:	00004097          	auipc	ra,0x4
     3a8:	de2080e7          	jalr	-542(ra) # 4186 <open>
  if(fd >= 0){
     3ac:	10054563          	bltz	a0,4b6 <writetest+0x140>
     3b0:	892a                	mv	s2,a0
    printf("creat small succeeded; ok\n");
     3b2:	00004517          	auipc	a0,0x4
     3b6:	4ee50513          	addi	a0,a0,1262 # 48a0 <malloc+0x304>
     3ba:	00004097          	auipc	ra,0x4
     3be:	124080e7          	jalr	292(ra) # 44de <printf>
  } else {
    printf("error: creat small failed!\n");
    exit(-1);
  }
  for(i = 0; i < N; i++){
     3c2:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3c4:	00004997          	auipc	s3,0x4
     3c8:	51c98993          	addi	s3,s3,1308 # 48e0 <malloc+0x344>
      printf("error: write aa %d new file failed\n", i);
      exit(-1);
    }
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3cc:	00004a97          	auipc	s5,0x4
     3d0:	54ca8a93          	addi	s5,s5,1356 # 4918 <malloc+0x37c>
  for(i = 0; i < N; i++){
     3d4:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     3d8:	4629                	li	a2,10
     3da:	85ce                	mv	a1,s3
     3dc:	854a                	mv	a0,s2
     3de:	00004097          	auipc	ra,0x4
     3e2:	d88080e7          	jalr	-632(ra) # 4166 <write>
     3e6:	47a9                	li	a5,10
     3e8:	0ef51463          	bne	a0,a5,4d0 <writetest+0x15a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     3ec:	4629                	li	a2,10
     3ee:	85d6                	mv	a1,s5
     3f0:	854a                	mv	a0,s2
     3f2:	00004097          	auipc	ra,0x4
     3f6:	d74080e7          	jalr	-652(ra) # 4166 <write>
     3fa:	47a9                	li	a5,10
     3fc:	0ef51863          	bne	a0,a5,4ec <writetest+0x176>
  for(i = 0; i < N; i++){
     400:	2485                	addiw	s1,s1,1
     402:	fd449be3          	bne	s1,s4,3d8 <writetest+0x62>
      printf("error: write bb %d new file failed\n", i);
      exit(-1);
    }
  }
  printf("writes ok\n");
     406:	00004517          	auipc	a0,0x4
     40a:	54a50513          	addi	a0,a0,1354 # 4950 <malloc+0x3b4>
     40e:	00004097          	auipc	ra,0x4
     412:	0d0080e7          	jalr	208(ra) # 44de <printf>
  close(fd);
     416:	854a                	mv	a0,s2
     418:	00004097          	auipc	ra,0x4
     41c:	d56080e7          	jalr	-682(ra) # 416e <close>
  fd = open("small", O_RDONLY);
     420:	4581                	li	a1,0
     422:	00004517          	auipc	a0,0x4
     426:	47650513          	addi	a0,a0,1142 # 4898 <malloc+0x2fc>
     42a:	00004097          	auipc	ra,0x4
     42e:	d5c080e7          	jalr	-676(ra) # 4186 <open>
     432:	84aa                	mv	s1,a0
  if(fd >= 0){
     434:	0c054a63          	bltz	a0,508 <writetest+0x192>
    printf("open small succeeded ok\n");
     438:	00004517          	auipc	a0,0x4
     43c:	52850513          	addi	a0,a0,1320 # 4960 <malloc+0x3c4>
     440:	00004097          	auipc	ra,0x4
     444:	09e080e7          	jalr	158(ra) # 44de <printf>
  } else {
    printf("error: open small failed!\n");
    exit(-1);
  }
  i = read(fd, buf, N*SZ*2);
     448:	7d000613          	li	a2,2000
     44c:	00009597          	auipc	a1,0x9
     450:	83c58593          	addi	a1,a1,-1988 # 8c88 <buf>
     454:	8526                	mv	a0,s1
     456:	00004097          	auipc	ra,0x4
     45a:	d08080e7          	jalr	-760(ra) # 415e <read>
  if(i == N*SZ*2){
     45e:	7d000793          	li	a5,2000
     462:	0cf51063          	bne	a0,a5,522 <writetest+0x1ac>
    printf("read succeeded ok\n");
     466:	00004517          	auipc	a0,0x4
     46a:	53a50513          	addi	a0,a0,1338 # 49a0 <malloc+0x404>
     46e:	00004097          	auipc	ra,0x4
     472:	070080e7          	jalr	112(ra) # 44de <printf>
  } else {
    printf("read failed\n");
    exit(-1);
  }
  close(fd);
     476:	8526                	mv	a0,s1
     478:	00004097          	auipc	ra,0x4
     47c:	cf6080e7          	jalr	-778(ra) # 416e <close>

  if(unlink("small") < 0){
     480:	00004517          	auipc	a0,0x4
     484:	41850513          	addi	a0,a0,1048 # 4898 <malloc+0x2fc>
     488:	00004097          	auipc	ra,0x4
     48c:	d0e080e7          	jalr	-754(ra) # 4196 <unlink>
     490:	0a054663          	bltz	a0,53c <writetest+0x1c6>
    printf("unlink small failed\n");
    exit(-1);
  }
  printf("small file test ok\n");
     494:	00004517          	auipc	a0,0x4
     498:	54c50513          	addi	a0,a0,1356 # 49e0 <malloc+0x444>
     49c:	00004097          	auipc	ra,0x4
     4a0:	042080e7          	jalr	66(ra) # 44de <printf>
}
     4a4:	70e2                	ld	ra,56(sp)
     4a6:	7442                	ld	s0,48(sp)
     4a8:	74a2                	ld	s1,40(sp)
     4aa:	7902                	ld	s2,32(sp)
     4ac:	69e2                	ld	s3,24(sp)
     4ae:	6a42                	ld	s4,16(sp)
     4b0:	6aa2                	ld	s5,8(sp)
     4b2:	6121                	addi	sp,sp,64
     4b4:	8082                	ret
    printf("error: creat small failed!\n");
     4b6:	00004517          	auipc	a0,0x4
     4ba:	40a50513          	addi	a0,a0,1034 # 48c0 <malloc+0x324>
     4be:	00004097          	auipc	ra,0x4
     4c2:	020080e7          	jalr	32(ra) # 44de <printf>
    exit(-1);
     4c6:	557d                	li	a0,-1
     4c8:	00004097          	auipc	ra,0x4
     4cc:	c7e080e7          	jalr	-898(ra) # 4146 <exit>
      printf("error: write aa %d new file failed\n", i);
     4d0:	85a6                	mv	a1,s1
     4d2:	00004517          	auipc	a0,0x4
     4d6:	41e50513          	addi	a0,a0,1054 # 48f0 <malloc+0x354>
     4da:	00004097          	auipc	ra,0x4
     4de:	004080e7          	jalr	4(ra) # 44de <printf>
      exit(-1);
     4e2:	557d                	li	a0,-1
     4e4:	00004097          	auipc	ra,0x4
     4e8:	c62080e7          	jalr	-926(ra) # 4146 <exit>
      printf("error: write bb %d new file failed\n", i);
     4ec:	85a6                	mv	a1,s1
     4ee:	00004517          	auipc	a0,0x4
     4f2:	43a50513          	addi	a0,a0,1082 # 4928 <malloc+0x38c>
     4f6:	00004097          	auipc	ra,0x4
     4fa:	fe8080e7          	jalr	-24(ra) # 44de <printf>
      exit(-1);
     4fe:	557d                	li	a0,-1
     500:	00004097          	auipc	ra,0x4
     504:	c46080e7          	jalr	-954(ra) # 4146 <exit>
    printf("error: open small failed!\n");
     508:	00004517          	auipc	a0,0x4
     50c:	47850513          	addi	a0,a0,1144 # 4980 <malloc+0x3e4>
     510:	00004097          	auipc	ra,0x4
     514:	fce080e7          	jalr	-50(ra) # 44de <printf>
    exit(-1);
     518:	557d                	li	a0,-1
     51a:	00004097          	auipc	ra,0x4
     51e:	c2c080e7          	jalr	-980(ra) # 4146 <exit>
    printf("read failed\n");
     522:	00004517          	auipc	a0,0x4
     526:	49650513          	addi	a0,a0,1174 # 49b8 <malloc+0x41c>
     52a:	00004097          	auipc	ra,0x4
     52e:	fb4080e7          	jalr	-76(ra) # 44de <printf>
    exit(-1);
     532:	557d                	li	a0,-1
     534:	00004097          	auipc	ra,0x4
     538:	c12080e7          	jalr	-1006(ra) # 4146 <exit>
    printf("unlink small failed\n");
     53c:	00004517          	auipc	a0,0x4
     540:	48c50513          	addi	a0,a0,1164 # 49c8 <malloc+0x42c>
     544:	00004097          	auipc	ra,0x4
     548:	f9a080e7          	jalr	-102(ra) # 44de <printf>
    exit(-1);
     54c:	557d                	li	a0,-1
     54e:	00004097          	auipc	ra,0x4
     552:	bf8080e7          	jalr	-1032(ra) # 4146 <exit>

0000000000000556 <writetest1>:

void
writetest1(void)
{
     556:	7179                	addi	sp,sp,-48
     558:	f406                	sd	ra,40(sp)
     55a:	f022                	sd	s0,32(sp)
     55c:	ec26                	sd	s1,24(sp)
     55e:	e84a                	sd	s2,16(sp)
     560:	e44e                	sd	s3,8(sp)
     562:	e052                	sd	s4,0(sp)
     564:	1800                	addi	s0,sp,48
  int i, fd, n;

  printf("big files test\n");
     566:	00004517          	auipc	a0,0x4
     56a:	49250513          	addi	a0,a0,1170 # 49f8 <malloc+0x45c>
     56e:	00004097          	auipc	ra,0x4
     572:	f70080e7          	jalr	-144(ra) # 44de <printf>

  fd = open("big", O_CREATE|O_RDWR);
     576:	20200593          	li	a1,514
     57a:	00004517          	auipc	a0,0x4
     57e:	48e50513          	addi	a0,a0,1166 # 4a08 <malloc+0x46c>
     582:	00004097          	auipc	ra,0x4
     586:	c04080e7          	jalr	-1020(ra) # 4186 <open>
     58a:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: creat big failed!\n");
    exit(-1);
  }

  for(i = 0; i < MAXFILE; i++){
     58c:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     58e:	00008917          	auipc	s2,0x8
     592:	6fa90913          	addi	s2,s2,1786 # 8c88 <buf>
  for(i = 0; i < MAXFILE; i++){
     596:	10c00a13          	li	s4,268
  if(fd < 0){
     59a:	06054c63          	bltz	a0,612 <writetest1+0xbc>
    ((int*)buf)[0] = i;
     59e:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     5a2:	40000613          	li	a2,1024
     5a6:	85ca                	mv	a1,s2
     5a8:	854e                	mv	a0,s3
     5aa:	00004097          	auipc	ra,0x4
     5ae:	bbc080e7          	jalr	-1092(ra) # 4166 <write>
     5b2:	40000793          	li	a5,1024
     5b6:	06f51b63          	bne	a0,a5,62c <writetest1+0xd6>
  for(i = 0; i < MAXFILE; i++){
     5ba:	2485                	addiw	s1,s1,1
     5bc:	ff4491e3          	bne	s1,s4,59e <writetest1+0x48>
      printf("error: write big file failed\n", i);
      exit(-1);
    }
  }

  close(fd);
     5c0:	854e                	mv	a0,s3
     5c2:	00004097          	auipc	ra,0x4
     5c6:	bac080e7          	jalr	-1108(ra) # 416e <close>

  fd = open("big", O_RDONLY);
     5ca:	4581                	li	a1,0
     5cc:	00004517          	auipc	a0,0x4
     5d0:	43c50513          	addi	a0,a0,1084 # 4a08 <malloc+0x46c>
     5d4:	00004097          	auipc	ra,0x4
     5d8:	bb2080e7          	jalr	-1102(ra) # 4186 <open>
     5dc:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("error: open big failed!\n");
    exit(-1);
  }

  n = 0;
     5de:	4481                	li	s1,0
  for(;;){
    i = read(fd, buf, BSIZE);
     5e0:	00008917          	auipc	s2,0x8
     5e4:	6a890913          	addi	s2,s2,1704 # 8c88 <buf>
  if(fd < 0){
     5e8:	06054063          	bltz	a0,648 <writetest1+0xf2>
    i = read(fd, buf, BSIZE);
     5ec:	40000613          	li	a2,1024
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00004097          	auipc	ra,0x4
     5f8:	b6a080e7          	jalr	-1174(ra) # 415e <read>
    if(i == 0){
     5fc:	c13d                	beqz	a0,662 <writetest1+0x10c>
      if(n == MAXFILE - 1){
        printf("read only %d blocks from big", n);
        exit(-1);
      }
      break;
    } else if(i != BSIZE){
     5fe:	40000793          	li	a5,1024
     602:	0cf51263          	bne	a0,a5,6c6 <writetest1+0x170>
      printf("read failed %d\n", i);
      exit(-1);
    }
    if(((int*)buf)[0] != n){
     606:	00092603          	lw	a2,0(s2)
     60a:	0c961c63          	bne	a2,s1,6e2 <writetest1+0x18c>
      printf("read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit(-1);
    }
    n++;
     60e:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     610:	bff1                	j	5ec <writetest1+0x96>
    printf("error: creat big failed!\n");
     612:	00004517          	auipc	a0,0x4
     616:	3fe50513          	addi	a0,a0,1022 # 4a10 <malloc+0x474>
     61a:	00004097          	auipc	ra,0x4
     61e:	ec4080e7          	jalr	-316(ra) # 44de <printf>
    exit(-1);
     622:	557d                	li	a0,-1
     624:	00004097          	auipc	ra,0x4
     628:	b22080e7          	jalr	-1246(ra) # 4146 <exit>
      printf("error: write big file failed\n", i);
     62c:	85a6                	mv	a1,s1
     62e:	00004517          	auipc	a0,0x4
     632:	40250513          	addi	a0,a0,1026 # 4a30 <malloc+0x494>
     636:	00004097          	auipc	ra,0x4
     63a:	ea8080e7          	jalr	-344(ra) # 44de <printf>
      exit(-1);
     63e:	557d                	li	a0,-1
     640:	00004097          	auipc	ra,0x4
     644:	b06080e7          	jalr	-1274(ra) # 4146 <exit>
    printf("error: open big failed!\n");
     648:	00004517          	auipc	a0,0x4
     64c:	40850513          	addi	a0,a0,1032 # 4a50 <malloc+0x4b4>
     650:	00004097          	auipc	ra,0x4
     654:	e8e080e7          	jalr	-370(ra) # 44de <printf>
    exit(-1);
     658:	557d                	li	a0,-1
     65a:	00004097          	auipc	ra,0x4
     65e:	aec080e7          	jalr	-1300(ra) # 4146 <exit>
      if(n == MAXFILE - 1){
     662:	10b00793          	li	a5,267
     666:	04f48163          	beq	s1,a5,6a8 <writetest1+0x152>
  }
  close(fd);
     66a:	854e                	mv	a0,s3
     66c:	00004097          	auipc	ra,0x4
     670:	b02080e7          	jalr	-1278(ra) # 416e <close>
  if(unlink("big") < 0){
     674:	00004517          	auipc	a0,0x4
     678:	39450513          	addi	a0,a0,916 # 4a08 <malloc+0x46c>
     67c:	00004097          	auipc	ra,0x4
     680:	b1a080e7          	jalr	-1254(ra) # 4196 <unlink>
     684:	06054d63          	bltz	a0,6fe <writetest1+0x1a8>
    printf("unlink big failed\n");
    exit(-1);
  }
  printf("big files ok\n");
     688:	00004517          	auipc	a0,0x4
     68c:	45050513          	addi	a0,a0,1104 # 4ad8 <malloc+0x53c>
     690:	00004097          	auipc	ra,0x4
     694:	e4e080e7          	jalr	-434(ra) # 44de <printf>
}
     698:	70a2                	ld	ra,40(sp)
     69a:	7402                	ld	s0,32(sp)
     69c:	64e2                	ld	s1,24(sp)
     69e:	6942                	ld	s2,16(sp)
     6a0:	69a2                	ld	s3,8(sp)
     6a2:	6a02                	ld	s4,0(sp)
     6a4:	6145                	addi	sp,sp,48
     6a6:	8082                	ret
        printf("read only %d blocks from big", n);
     6a8:	10b00593          	li	a1,267
     6ac:	00004517          	auipc	a0,0x4
     6b0:	3c450513          	addi	a0,a0,964 # 4a70 <malloc+0x4d4>
     6b4:	00004097          	auipc	ra,0x4
     6b8:	e2a080e7          	jalr	-470(ra) # 44de <printf>
        exit(-1);
     6bc:	557d                	li	a0,-1
     6be:	00004097          	auipc	ra,0x4
     6c2:	a88080e7          	jalr	-1400(ra) # 4146 <exit>
      printf("read failed %d\n", i);
     6c6:	85aa                	mv	a1,a0
     6c8:	00004517          	auipc	a0,0x4
     6cc:	3c850513          	addi	a0,a0,968 # 4a90 <malloc+0x4f4>
     6d0:	00004097          	auipc	ra,0x4
     6d4:	e0e080e7          	jalr	-498(ra) # 44de <printf>
      exit(-1);
     6d8:	557d                	li	a0,-1
     6da:	00004097          	auipc	ra,0x4
     6de:	a6c080e7          	jalr	-1428(ra) # 4146 <exit>
      printf("read content of block %d is %d\n",
     6e2:	85a6                	mv	a1,s1
     6e4:	00004517          	auipc	a0,0x4
     6e8:	3bc50513          	addi	a0,a0,956 # 4aa0 <malloc+0x504>
     6ec:	00004097          	auipc	ra,0x4
     6f0:	df2080e7          	jalr	-526(ra) # 44de <printf>
      exit(-1);
     6f4:	557d                	li	a0,-1
     6f6:	00004097          	auipc	ra,0x4
     6fa:	a50080e7          	jalr	-1456(ra) # 4146 <exit>
    printf("unlink big failed\n");
     6fe:	00004517          	auipc	a0,0x4
     702:	3c250513          	addi	a0,a0,962 # 4ac0 <malloc+0x524>
     706:	00004097          	auipc	ra,0x4
     70a:	dd8080e7          	jalr	-552(ra) # 44de <printf>
    exit(-1);
     70e:	557d                	li	a0,-1
     710:	00004097          	auipc	ra,0x4
     714:	a36080e7          	jalr	-1482(ra) # 4146 <exit>

0000000000000718 <createtest>:

void
createtest(void)
{
     718:	7179                	addi	sp,sp,-48
     71a:	f406                	sd	ra,40(sp)
     71c:	f022                	sd	s0,32(sp)
     71e:	ec26                	sd	s1,24(sp)
     720:	e84a                	sd	s2,16(sp)
     722:	e44e                	sd	s3,8(sp)
     724:	1800                	addi	s0,sp,48
  int i, fd;
  enum { N=52 };
  
  printf("many creates, followed by unlink test\n");
     726:	00004517          	auipc	a0,0x4
     72a:	3c250513          	addi	a0,a0,962 # 4ae8 <malloc+0x54c>
     72e:	00004097          	auipc	ra,0x4
     732:	db0080e7          	jalr	-592(ra) # 44de <printf>

  name[0] = 'a';
     736:	00006797          	auipc	a5,0x6
     73a:	d3278793          	addi	a5,a5,-718 # 6468 <name>
     73e:	06100713          	li	a4,97
     742:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     746:	00078123          	sb	zero,2(a5)
     74a:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     74e:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     750:	06400993          	li	s3,100
    name[1] = '0' + i;
     754:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     758:	20200593          	li	a1,514
     75c:	854a                	mv	a0,s2
     75e:	00004097          	auipc	ra,0x4
     762:	a28080e7          	jalr	-1496(ra) # 4186 <open>
    close(fd);
     766:	00004097          	auipc	ra,0x4
     76a:	a08080e7          	jalr	-1528(ra) # 416e <close>
  for(i = 0; i < N; i++){
     76e:	2485                	addiw	s1,s1,1
     770:	0ff4f493          	andi	s1,s1,255
     774:	ff3490e3          	bne	s1,s3,754 <createtest+0x3c>
  }
  name[0] = 'a';
     778:	00006797          	auipc	a5,0x6
     77c:	cf078793          	addi	a5,a5,-784 # 6468 <name>
     780:	06100713          	li	a4,97
     784:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     788:	00078123          	sb	zero,2(a5)
     78c:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     790:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     792:	06400993          	li	s3,100
    name[1] = '0' + i;
     796:	009900a3          	sb	s1,1(s2)
    unlink(name);
     79a:	854a                	mv	a0,s2
     79c:	00004097          	auipc	ra,0x4
     7a0:	9fa080e7          	jalr	-1542(ra) # 4196 <unlink>
  for(i = 0; i < N; i++){
     7a4:	2485                	addiw	s1,s1,1
     7a6:	0ff4f493          	andi	s1,s1,255
     7aa:	ff3496e3          	bne	s1,s3,796 <createtest+0x7e>
  }
  printf("many creates, followed by unlink; ok\n");
     7ae:	00004517          	auipc	a0,0x4
     7b2:	36250513          	addi	a0,a0,866 # 4b10 <malloc+0x574>
     7b6:	00004097          	auipc	ra,0x4
     7ba:	d28080e7          	jalr	-728(ra) # 44de <printf>
}
     7be:	70a2                	ld	ra,40(sp)
     7c0:	7402                	ld	s0,32(sp)
     7c2:	64e2                	ld	s1,24(sp)
     7c4:	6942                	ld	s2,16(sp)
     7c6:	69a2                	ld	s3,8(sp)
     7c8:	6145                	addi	sp,sp,48
     7ca:	8082                	ret

00000000000007cc <dirtest>:

void dirtest(void)
{
     7cc:	1141                	addi	sp,sp,-16
     7ce:	e406                	sd	ra,8(sp)
     7d0:	e022                	sd	s0,0(sp)
     7d2:	0800                	addi	s0,sp,16
  printf("mkdir test\n");
     7d4:	00004517          	auipc	a0,0x4
     7d8:	36450513          	addi	a0,a0,868 # 4b38 <malloc+0x59c>
     7dc:	00004097          	auipc	ra,0x4
     7e0:	d02080e7          	jalr	-766(ra) # 44de <printf>

  if(mkdir("dir0") < 0){
     7e4:	00004517          	auipc	a0,0x4
     7e8:	36450513          	addi	a0,a0,868 # 4b48 <malloc+0x5ac>
     7ec:	00004097          	auipc	ra,0x4
     7f0:	9c2080e7          	jalr	-1598(ra) # 41ae <mkdir>
     7f4:	04054c63          	bltz	a0,84c <dirtest+0x80>
    printf("mkdir failed\n");
    exit(-1);
  }

  if(chdir("dir0") < 0){
     7f8:	00004517          	auipc	a0,0x4
     7fc:	35050513          	addi	a0,a0,848 # 4b48 <malloc+0x5ac>
     800:	00004097          	auipc	ra,0x4
     804:	9b6080e7          	jalr	-1610(ra) # 41b6 <chdir>
     808:	04054f63          	bltz	a0,866 <dirtest+0x9a>
    printf("chdir dir0 failed\n");
    exit(-1);
  }

  if(chdir("..") < 0){
     80c:	00004517          	auipc	a0,0x4
     810:	35c50513          	addi	a0,a0,860 # 4b68 <malloc+0x5cc>
     814:	00004097          	auipc	ra,0x4
     818:	9a2080e7          	jalr	-1630(ra) # 41b6 <chdir>
     81c:	06054263          	bltz	a0,880 <dirtest+0xb4>
    printf("chdir .. failed\n");
    exit(-1);
  }

  if(unlink("dir0") < 0){
     820:	00004517          	auipc	a0,0x4
     824:	32850513          	addi	a0,a0,808 # 4b48 <malloc+0x5ac>
     828:	00004097          	auipc	ra,0x4
     82c:	96e080e7          	jalr	-1682(ra) # 4196 <unlink>
     830:	06054563          	bltz	a0,89a <dirtest+0xce>
    printf("unlink dir0 failed\n");
    exit(-1);
  }
  printf("mkdir test ok\n");
     834:	00004517          	auipc	a0,0x4
     838:	36c50513          	addi	a0,a0,876 # 4ba0 <malloc+0x604>
     83c:	00004097          	auipc	ra,0x4
     840:	ca2080e7          	jalr	-862(ra) # 44de <printf>
}
     844:	60a2                	ld	ra,8(sp)
     846:	6402                	ld	s0,0(sp)
     848:	0141                	addi	sp,sp,16
     84a:	8082                	ret
    printf("mkdir failed\n");
     84c:	00004517          	auipc	a0,0x4
     850:	e7450513          	addi	a0,a0,-396 # 46c0 <malloc+0x124>
     854:	00004097          	auipc	ra,0x4
     858:	c8a080e7          	jalr	-886(ra) # 44de <printf>
    exit(-1);
     85c:	557d                	li	a0,-1
     85e:	00004097          	auipc	ra,0x4
     862:	8e8080e7          	jalr	-1816(ra) # 4146 <exit>
    printf("chdir dir0 failed\n");
     866:	00004517          	auipc	a0,0x4
     86a:	2ea50513          	addi	a0,a0,746 # 4b50 <malloc+0x5b4>
     86e:	00004097          	auipc	ra,0x4
     872:	c70080e7          	jalr	-912(ra) # 44de <printf>
    exit(-1);
     876:	557d                	li	a0,-1
     878:	00004097          	auipc	ra,0x4
     87c:	8ce080e7          	jalr	-1842(ra) # 4146 <exit>
    printf("chdir .. failed\n");
     880:	00004517          	auipc	a0,0x4
     884:	2f050513          	addi	a0,a0,752 # 4b70 <malloc+0x5d4>
     888:	00004097          	auipc	ra,0x4
     88c:	c56080e7          	jalr	-938(ra) # 44de <printf>
    exit(-1);
     890:	557d                	li	a0,-1
     892:	00004097          	auipc	ra,0x4
     896:	8b4080e7          	jalr	-1868(ra) # 4146 <exit>
    printf("unlink dir0 failed\n");
     89a:	00004517          	auipc	a0,0x4
     89e:	2ee50513          	addi	a0,a0,750 # 4b88 <malloc+0x5ec>
     8a2:	00004097          	auipc	ra,0x4
     8a6:	c3c080e7          	jalr	-964(ra) # 44de <printf>
    exit(-1);
     8aa:	557d                	li	a0,-1
     8ac:	00004097          	auipc	ra,0x4
     8b0:	89a080e7          	jalr	-1894(ra) # 4146 <exit>

00000000000008b4 <exectest>:

void
exectest(void)
{
     8b4:	1141                	addi	sp,sp,-16
     8b6:	e406                	sd	ra,8(sp)
     8b8:	e022                	sd	s0,0(sp)
     8ba:	0800                	addi	s0,sp,16
  printf("exec test\n");
     8bc:	00004517          	auipc	a0,0x4
     8c0:	2f450513          	addi	a0,a0,756 # 4bb0 <malloc+0x614>
     8c4:	00004097          	auipc	ra,0x4
     8c8:	c1a080e7          	jalr	-998(ra) # 44de <printf>
  if(exec("echo", echoargv) < 0){
     8cc:	00006597          	auipc	a1,0x6
     8d0:	b6c58593          	addi	a1,a1,-1172 # 6438 <echoargv>
     8d4:	00004517          	auipc	a0,0x4
     8d8:	f4c50513          	addi	a0,a0,-180 # 4820 <malloc+0x284>
     8dc:	00004097          	auipc	ra,0x4
     8e0:	8a2080e7          	jalr	-1886(ra) # 417e <exec>
     8e4:	00054663          	bltz	a0,8f0 <exectest+0x3c>
    printf("exec echo failed\n");
    exit(-1);
  }
}
     8e8:	60a2                	ld	ra,8(sp)
     8ea:	6402                	ld	s0,0(sp)
     8ec:	0141                	addi	sp,sp,16
     8ee:	8082                	ret
    printf("exec echo failed\n");
     8f0:	00004517          	auipc	a0,0x4
     8f4:	2d050513          	addi	a0,a0,720 # 4bc0 <malloc+0x624>
     8f8:	00004097          	auipc	ra,0x4
     8fc:	be6080e7          	jalr	-1050(ra) # 44de <printf>
    exit(-1);
     900:	557d                	li	a0,-1
     902:	00004097          	auipc	ra,0x4
     906:	844080e7          	jalr	-1980(ra) # 4146 <exit>

000000000000090a <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     90a:	715d                	addi	sp,sp,-80
     90c:	e486                	sd	ra,72(sp)
     90e:	e0a2                	sd	s0,64(sp)
     910:	fc26                	sd	s1,56(sp)
     912:	f84a                	sd	s2,48(sp)
     914:	f44e                	sd	s3,40(sp)
     916:	f052                	sd	s4,32(sp)
     918:	ec56                	sd	s5,24(sp)
     91a:	e85a                	sd	s6,16(sp)
     91c:	0880                	addi	s0,sp,80
  int fds[2], pid;
  int seq, i, n, cc, total;
  enum { N=5, SZ=1033 };
  
  if(pipe(fds) != 0){
     91e:	fb840513          	addi	a0,s0,-72
     922:	00004097          	auipc	ra,0x4
     926:	834080e7          	jalr	-1996(ra) # 4156 <pipe>
     92a:	ed25                	bnez	a0,9a2 <pipe1+0x98>
     92c:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(-1);
  }
  pid = fork();
     92e:	00004097          	auipc	ra,0x4
     932:	810080e7          	jalr	-2032(ra) # 413e <fork>
     936:	89aa                	mv	s3,a0
  seq = 0;
  if(pid == 0){
     938:	c151                	beqz	a0,9bc <pipe1+0xb2>
        printf("pipe1 oops 1\n");
        exit(-1);
      }
    }
    exit(0);
  } else if(pid > 0){
     93a:	16a05c63          	blez	a0,ab2 <pipe1+0x1a8>
    close(fds[1]);
     93e:	fbc42503          	lw	a0,-68(s0)
     942:	00004097          	auipc	ra,0x4
     946:	82c080e7          	jalr	-2004(ra) # 416e <close>
    total = 0;
     94a:	89a6                	mv	s3,s1
    cc = 1;
     94c:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
     94e:	00008a17          	auipc	s4,0x8
     952:	33aa0a13          	addi	s4,s4,826 # 8c88 <buf>
          return;
        }
      }
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
     956:	6a8d                	lui	s5,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     958:	864a                	mv	a2,s2
     95a:	85d2                	mv	a1,s4
     95c:	fb842503          	lw	a0,-72(s0)
     960:	00003097          	auipc	ra,0x3
     964:	7fe080e7          	jalr	2046(ra) # 415e <read>
     968:	0ea05e63          	blez	a0,a64 <pipe1+0x15a>
      for(i = 0; i < n; i++){
     96c:	00008717          	auipc	a4,0x8
     970:	31c70713          	addi	a4,a4,796 # 8c88 <buf>
     974:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     978:	00074683          	lbu	a3,0(a4)
     97c:	0ff4f793          	andi	a5,s1,255
     980:	2485                	addiw	s1,s1,1
     982:	0af69f63          	bne	a3,a5,a40 <pipe1+0x136>
      for(i = 0; i < n; i++){
     986:	0705                	addi	a4,a4,1
     988:	fec498e3          	bne	s1,a2,978 <pipe1+0x6e>
      total += n;
     98c:	00a989bb          	addw	s3,s3,a0
      cc = cc * 2;
     990:	0019179b          	slliw	a5,s2,0x1
     994:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
     998:	012af363          	bgeu	s5,s2,99e <pipe1+0x94>
        cc = sizeof(buf);
     99c:	8956                	mv	s2,s5
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     99e:	84b2                	mv	s1,a2
     9a0:	bf65                	j	958 <pipe1+0x4e>
    printf("pipe() failed\n");
     9a2:	00004517          	auipc	a0,0x4
     9a6:	23650513          	addi	a0,a0,566 # 4bd8 <malloc+0x63c>
     9aa:	00004097          	auipc	ra,0x4
     9ae:	b34080e7          	jalr	-1228(ra) # 44de <printf>
    exit(-1);
     9b2:	557d                	li	a0,-1
     9b4:	00003097          	auipc	ra,0x3
     9b8:	792080e7          	jalr	1938(ra) # 4146 <exit>
    close(fds[0]);
     9bc:	fb842503          	lw	a0,-72(s0)
     9c0:	00003097          	auipc	ra,0x3
     9c4:	7ae080e7          	jalr	1966(ra) # 416e <close>
    for(n = 0; n < N; n++){
     9c8:	00008a97          	auipc	s5,0x8
     9cc:	2c0a8a93          	addi	s5,s5,704 # 8c88 <buf>
     9d0:	415004bb          	negw	s1,s5
     9d4:	0ff4f493          	andi	s1,s1,255
     9d8:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
     9dc:	8b56                	mv	s6,s5
    for(n = 0; n < N; n++){
     9de:	6a05                	lui	s4,0x1
     9e0:	42da0a13          	addi	s4,s4,1069 # 142d <fourfiles+0x10d>
{
     9e4:	87d6                	mv	a5,s5
        buf[i] = seq++;
     9e6:	0097873b          	addw	a4,a5,s1
     9ea:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
     9ee:	0785                	addi	a5,a5,1
     9f0:	fef91be3          	bne	s2,a5,9e6 <pipe1+0xdc>
        buf[i] = seq++;
     9f4:	4099899b          	addiw	s3,s3,1033
      if(write(fds[1], buf, SZ) != SZ){
     9f8:	40900613          	li	a2,1033
     9fc:	85da                	mv	a1,s6
     9fe:	fbc42503          	lw	a0,-68(s0)
     a02:	00003097          	auipc	ra,0x3
     a06:	764080e7          	jalr	1892(ra) # 4166 <write>
     a0a:	40900793          	li	a5,1033
     a0e:	00f51c63          	bne	a0,a5,a26 <pipe1+0x11c>
    for(n = 0; n < N; n++){
     a12:	24a5                	addiw	s1,s1,9
     a14:	0ff4f493          	andi	s1,s1,255
     a18:	fd4996e3          	bne	s3,s4,9e4 <pipe1+0xda>
    exit(0);
     a1c:	4501                	li	a0,0
     a1e:	00003097          	auipc	ra,0x3
     a22:	728080e7          	jalr	1832(ra) # 4146 <exit>
        printf("pipe1 oops 1\n");
     a26:	00004517          	auipc	a0,0x4
     a2a:	1c250513          	addi	a0,a0,450 # 4be8 <malloc+0x64c>
     a2e:	00004097          	auipc	ra,0x4
     a32:	ab0080e7          	jalr	-1360(ra) # 44de <printf>
        exit(-1);
     a36:	557d                	li	a0,-1
     a38:	00003097          	auipc	ra,0x3
     a3c:	70e080e7          	jalr	1806(ra) # 4146 <exit>
          printf("pipe1 oops 2\n");
     a40:	00004517          	auipc	a0,0x4
     a44:	1b850513          	addi	a0,a0,440 # 4bf8 <malloc+0x65c>
     a48:	00004097          	auipc	ra,0x4
     a4c:	a96080e7          	jalr	-1386(ra) # 44de <printf>
  } else {
    printf("fork() failed\n");
    exit(-1);
  }
  printf("pipe1 ok\n");
}
     a50:	60a6                	ld	ra,72(sp)
     a52:	6406                	ld	s0,64(sp)
     a54:	74e2                	ld	s1,56(sp)
     a56:	7942                	ld	s2,48(sp)
     a58:	79a2                	ld	s3,40(sp)
     a5a:	7a02                	ld	s4,32(sp)
     a5c:	6ae2                	ld	s5,24(sp)
     a5e:	6b42                	ld	s6,16(sp)
     a60:	6161                	addi	sp,sp,80
     a62:	8082                	ret
    if(total != N * SZ){
     a64:	6785                	lui	a5,0x1
     a66:	42d78793          	addi	a5,a5,1069 # 142d <fourfiles+0x10d>
     a6a:	02f99663          	bne	s3,a5,a96 <pipe1+0x18c>
    close(fds[0]);
     a6e:	fb842503          	lw	a0,-72(s0)
     a72:	00003097          	auipc	ra,0x3
     a76:	6fc080e7          	jalr	1788(ra) # 416e <close>
    wait(0);
     a7a:	4501                	li	a0,0
     a7c:	00003097          	auipc	ra,0x3
     a80:	6d2080e7          	jalr	1746(ra) # 414e <wait>
  printf("pipe1 ok\n");
     a84:	00004517          	auipc	a0,0x4
     a88:	19c50513          	addi	a0,a0,412 # 4c20 <malloc+0x684>
     a8c:	00004097          	auipc	ra,0x4
     a90:	a52080e7          	jalr	-1454(ra) # 44de <printf>
     a94:	bf75                	j	a50 <pipe1+0x146>
      printf("pipe1 oops 3 total %d\n", total);
     a96:	85ce                	mv	a1,s3
     a98:	00004517          	auipc	a0,0x4
     a9c:	17050513          	addi	a0,a0,368 # 4c08 <malloc+0x66c>
     aa0:	00004097          	auipc	ra,0x4
     aa4:	a3e080e7          	jalr	-1474(ra) # 44de <printf>
      exit(-1);
     aa8:	557d                	li	a0,-1
     aaa:	00003097          	auipc	ra,0x3
     aae:	69c080e7          	jalr	1692(ra) # 4146 <exit>
    printf("fork() failed\n");
     ab2:	00004517          	auipc	a0,0x4
     ab6:	17e50513          	addi	a0,a0,382 # 4c30 <malloc+0x694>
     aba:	00004097          	auipc	ra,0x4
     abe:	a24080e7          	jalr	-1500(ra) # 44de <printf>
    exit(-1);
     ac2:	557d                	li	a0,-1
     ac4:	00003097          	auipc	ra,0x3
     ac8:	682080e7          	jalr	1666(ra) # 4146 <exit>

0000000000000acc <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     acc:	7139                	addi	sp,sp,-64
     ace:	fc06                	sd	ra,56(sp)
     ad0:	f822                	sd	s0,48(sp)
     ad2:	f426                	sd	s1,40(sp)
     ad4:	f04a                	sd	s2,32(sp)
     ad6:	ec4e                	sd	s3,24(sp)
     ad8:	0080                	addi	s0,sp,64
  int pid1, pid2, pid3;
  int pfds[2];

  printf("preempt: ");
     ada:	00004517          	auipc	a0,0x4
     ade:	16650513          	addi	a0,a0,358 # 4c40 <malloc+0x6a4>
     ae2:	00004097          	auipc	ra,0x4
     ae6:	9fc080e7          	jalr	-1540(ra) # 44de <printf>
  pid1 = fork();
     aea:	00003097          	auipc	ra,0x3
     aee:	654080e7          	jalr	1620(ra) # 413e <fork>
  if(pid1 < 0) {
     af2:	00054563          	bltz	a0,afc <preempt+0x30>
     af6:	84aa                	mv	s1,a0
    printf("fork failed");
    exit(-1);
  }
  if(pid1 == 0)
     af8:	ed19                	bnez	a0,b16 <preempt+0x4a>
    for(;;)
     afa:	a001                	j	afa <preempt+0x2e>
    printf("fork failed");
     afc:	00004517          	auipc	a0,0x4
     b00:	15450513          	addi	a0,a0,340 # 4c50 <malloc+0x6b4>
     b04:	00004097          	auipc	ra,0x4
     b08:	9da080e7          	jalr	-1574(ra) # 44de <printf>
    exit(-1);
     b0c:	557d                	li	a0,-1
     b0e:	00003097          	auipc	ra,0x3
     b12:	638080e7          	jalr	1592(ra) # 4146 <exit>
      ;

  pid2 = fork();
     b16:	00003097          	auipc	ra,0x3
     b1a:	628080e7          	jalr	1576(ra) # 413e <fork>
     b1e:	892a                	mv	s2,a0
  if(pid2 < 0) {
     b20:	00054463          	bltz	a0,b28 <preempt+0x5c>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid2 == 0)
     b24:	ed19                	bnez	a0,b42 <preempt+0x76>
    for(;;)
     b26:	a001                	j	b26 <preempt+0x5a>
    printf("fork failed\n");
     b28:	00004517          	auipc	a0,0x4
     b2c:	c2850513          	addi	a0,a0,-984 # 4750 <malloc+0x1b4>
     b30:	00004097          	auipc	ra,0x4
     b34:	9ae080e7          	jalr	-1618(ra) # 44de <printf>
    exit(-1);
     b38:	557d                	li	a0,-1
     b3a:	00003097          	auipc	ra,0x3
     b3e:	60c080e7          	jalr	1548(ra) # 4146 <exit>
      ;

  pipe(pfds);
     b42:	fc840513          	addi	a0,s0,-56
     b46:	00003097          	auipc	ra,0x3
     b4a:	610080e7          	jalr	1552(ra) # 4156 <pipe>
  pid3 = fork();
     b4e:	00003097          	auipc	ra,0x3
     b52:	5f0080e7          	jalr	1520(ra) # 413e <fork>
     b56:	89aa                	mv	s3,a0
  if(pid3 < 0) {
     b58:	02054e63          	bltz	a0,b94 <preempt+0xc8>
     printf("fork failed\n");
     exit(-1);
  }
  if(pid3 == 0){
     b5c:	e135                	bnez	a0,bc0 <preempt+0xf4>
    close(pfds[0]);
     b5e:	fc842503          	lw	a0,-56(s0)
     b62:	00003097          	auipc	ra,0x3
     b66:	60c080e7          	jalr	1548(ra) # 416e <close>
    if(write(pfds[1], "x", 1) != 1)
     b6a:	4605                	li	a2,1
     b6c:	00004597          	auipc	a1,0x4
     b70:	0f458593          	addi	a1,a1,244 # 4c60 <malloc+0x6c4>
     b74:	fcc42503          	lw	a0,-52(s0)
     b78:	00003097          	auipc	ra,0x3
     b7c:	5ee080e7          	jalr	1518(ra) # 4166 <write>
     b80:	4785                	li	a5,1
     b82:	02f51663          	bne	a0,a5,bae <preempt+0xe2>
      printf("preempt write error");
    close(pfds[1]);
     b86:	fcc42503          	lw	a0,-52(s0)
     b8a:	00003097          	auipc	ra,0x3
     b8e:	5e4080e7          	jalr	1508(ra) # 416e <close>
    for(;;)
     b92:	a001                	j	b92 <preempt+0xc6>
     printf("fork failed\n");
     b94:	00004517          	auipc	a0,0x4
     b98:	bbc50513          	addi	a0,a0,-1092 # 4750 <malloc+0x1b4>
     b9c:	00004097          	auipc	ra,0x4
     ba0:	942080e7          	jalr	-1726(ra) # 44de <printf>
     exit(-1);
     ba4:	557d                	li	a0,-1
     ba6:	00003097          	auipc	ra,0x3
     baa:	5a0080e7          	jalr	1440(ra) # 4146 <exit>
      printf("preempt write error");
     bae:	00004517          	auipc	a0,0x4
     bb2:	0ba50513          	addi	a0,a0,186 # 4c68 <malloc+0x6cc>
     bb6:	00004097          	auipc	ra,0x4
     bba:	928080e7          	jalr	-1752(ra) # 44de <printf>
     bbe:	b7e1                	j	b86 <preempt+0xba>
      ;
  }

  close(pfds[1]);
     bc0:	fcc42503          	lw	a0,-52(s0)
     bc4:	00003097          	auipc	ra,0x3
     bc8:	5aa080e7          	jalr	1450(ra) # 416e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     bcc:	660d                	lui	a2,0x3
     bce:	00008597          	auipc	a1,0x8
     bd2:	0ba58593          	addi	a1,a1,186 # 8c88 <buf>
     bd6:	fc842503          	lw	a0,-56(s0)
     bda:	00003097          	auipc	ra,0x3
     bde:	584080e7          	jalr	1412(ra) # 415e <read>
     be2:	4785                	li	a5,1
     be4:	02f50163          	beq	a0,a5,c06 <preempt+0x13a>
    printf("preempt read error");
     be8:	00004517          	auipc	a0,0x4
     bec:	09850513          	addi	a0,a0,152 # 4c80 <malloc+0x6e4>
     bf0:	00004097          	auipc	ra,0x4
     bf4:	8ee080e7          	jalr	-1810(ra) # 44de <printf>
  printf("wait... ");
  wait(0);
  wait(0);
  wait(0);
  printf("preempt ok\n");
}
     bf8:	70e2                	ld	ra,56(sp)
     bfa:	7442                	ld	s0,48(sp)
     bfc:	74a2                	ld	s1,40(sp)
     bfe:	7902                	ld	s2,32(sp)
     c00:	69e2                	ld	s3,24(sp)
     c02:	6121                	addi	sp,sp,64
     c04:	8082                	ret
  close(pfds[0]);
     c06:	fc842503          	lw	a0,-56(s0)
     c0a:	00003097          	auipc	ra,0x3
     c0e:	564080e7          	jalr	1380(ra) # 416e <close>
  printf("kill... ");
     c12:	00004517          	auipc	a0,0x4
     c16:	08650513          	addi	a0,a0,134 # 4c98 <malloc+0x6fc>
     c1a:	00004097          	auipc	ra,0x4
     c1e:	8c4080e7          	jalr	-1852(ra) # 44de <printf>
  kill(pid1);
     c22:	8526                	mv	a0,s1
     c24:	00003097          	auipc	ra,0x3
     c28:	552080e7          	jalr	1362(ra) # 4176 <kill>
  kill(pid2);
     c2c:	854a                	mv	a0,s2
     c2e:	00003097          	auipc	ra,0x3
     c32:	548080e7          	jalr	1352(ra) # 4176 <kill>
  kill(pid3);
     c36:	854e                	mv	a0,s3
     c38:	00003097          	auipc	ra,0x3
     c3c:	53e080e7          	jalr	1342(ra) # 4176 <kill>
  printf("wait... ");
     c40:	00004517          	auipc	a0,0x4
     c44:	06850513          	addi	a0,a0,104 # 4ca8 <malloc+0x70c>
     c48:	00004097          	auipc	ra,0x4
     c4c:	896080e7          	jalr	-1898(ra) # 44de <printf>
  wait(0);
     c50:	4501                	li	a0,0
     c52:	00003097          	auipc	ra,0x3
     c56:	4fc080e7          	jalr	1276(ra) # 414e <wait>
  wait(0);
     c5a:	4501                	li	a0,0
     c5c:	00003097          	auipc	ra,0x3
     c60:	4f2080e7          	jalr	1266(ra) # 414e <wait>
  wait(0);
     c64:	4501                	li	a0,0
     c66:	00003097          	auipc	ra,0x3
     c6a:	4e8080e7          	jalr	1256(ra) # 414e <wait>
  printf("preempt ok\n");
     c6e:	00004517          	auipc	a0,0x4
     c72:	04a50513          	addi	a0,a0,74 # 4cb8 <malloc+0x71c>
     c76:	00004097          	auipc	ra,0x4
     c7a:	868080e7          	jalr	-1944(ra) # 44de <printf>
     c7e:	bfad                	j	bf8 <preempt+0x12c>

0000000000000c80 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     c80:	7139                	addi	sp,sp,-64
     c82:	fc06                	sd	ra,56(sp)
     c84:	f822                	sd	s0,48(sp)
     c86:	f426                	sd	s1,40(sp)
     c88:	f04a                	sd	s2,32(sp)
     c8a:	ec4e                	sd	s3,24(sp)
     c8c:	0080                	addi	s0,sp,64
  int i, pid;

  printf("exitwait test\n");
     c8e:	00004517          	auipc	a0,0x4
     c92:	03a50513          	addi	a0,a0,58 # 4cc8 <malloc+0x72c>
     c96:	00004097          	auipc	ra,0x4
     c9a:	848080e7          	jalr	-1976(ra) # 44de <printf>

  for(i = 0; i < 100; i++){
     c9e:	4901                	li	s2,0
     ca0:	06400993          	li	s3,100
    pid = fork();
     ca4:	00003097          	auipc	ra,0x3
     ca8:	49a080e7          	jalr	1178(ra) # 413e <fork>
     cac:	84aa                	mv	s1,a0
    if(pid < 0){
     cae:	04054163          	bltz	a0,cf0 <exitwait+0x70>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid){
     cb2:	c551                	beqz	a0,d3e <exitwait+0xbe>
      int xstate;
      if(wait(&xstate) != pid){
     cb4:	fcc40513          	addi	a0,s0,-52
     cb8:	00003097          	auipc	ra,0x3
     cbc:	496080e7          	jalr	1174(ra) # 414e <wait>
     cc0:	04951563          	bne	a0,s1,d0a <exitwait+0x8a>
        printf("wait wrong pid\n");
        exit(-1);
      }
      if(i != xstate) {
     cc4:	fcc42783          	lw	a5,-52(s0)
     cc8:	05279e63          	bne	a5,s2,d24 <exitwait+0xa4>
  for(i = 0; i < 100; i++){
     ccc:	2905                	addiw	s2,s2,1
     cce:	fd391be3          	bne	s2,s3,ca4 <exitwait+0x24>
      }
    } else {
      exit(i);
    }
  }
  printf("exitwait ok\n");
     cd2:	00004517          	auipc	a0,0x4
     cd6:	02e50513          	addi	a0,a0,46 # 4d00 <malloc+0x764>
     cda:	00004097          	auipc	ra,0x4
     cde:	804080e7          	jalr	-2044(ra) # 44de <printf>
}
     ce2:	70e2                	ld	ra,56(sp)
     ce4:	7442                	ld	s0,48(sp)
     ce6:	74a2                	ld	s1,40(sp)
     ce8:	7902                	ld	s2,32(sp)
     cea:	69e2                	ld	s3,24(sp)
     cec:	6121                	addi	sp,sp,64
     cee:	8082                	ret
      printf("fork failed\n");
     cf0:	00004517          	auipc	a0,0x4
     cf4:	a6050513          	addi	a0,a0,-1440 # 4750 <malloc+0x1b4>
     cf8:	00003097          	auipc	ra,0x3
     cfc:	7e6080e7          	jalr	2022(ra) # 44de <printf>
      exit(-1);
     d00:	557d                	li	a0,-1
     d02:	00003097          	auipc	ra,0x3
     d06:	444080e7          	jalr	1092(ra) # 4146 <exit>
        printf("wait wrong pid\n");
     d0a:	00004517          	auipc	a0,0x4
     d0e:	fce50513          	addi	a0,a0,-50 # 4cd8 <malloc+0x73c>
     d12:	00003097          	auipc	ra,0x3
     d16:	7cc080e7          	jalr	1996(ra) # 44de <printf>
        exit(-1);
     d1a:	557d                	li	a0,-1
     d1c:	00003097          	auipc	ra,0x3
     d20:	42a080e7          	jalr	1066(ra) # 4146 <exit>
        printf("wait wrong exit status\n");
     d24:	00004517          	auipc	a0,0x4
     d28:	fc450513          	addi	a0,a0,-60 # 4ce8 <malloc+0x74c>
     d2c:	00003097          	auipc	ra,0x3
     d30:	7b2080e7          	jalr	1970(ra) # 44de <printf>
        exit(-1);
     d34:	557d                	li	a0,-1
     d36:	00003097          	auipc	ra,0x3
     d3a:	410080e7          	jalr	1040(ra) # 4146 <exit>
      exit(i);
     d3e:	854a                	mv	a0,s2
     d40:	00003097          	auipc	ra,0x3
     d44:	406080e7          	jalr	1030(ra) # 4146 <exit>

0000000000000d48 <reparent>:
// try to find races in the reparenting
// code that handles a parent exiting
// when it still has live children.
void
reparent(void)
{
     d48:	7179                	addi	sp,sp,-48
     d4a:	f406                	sd	ra,40(sp)
     d4c:	f022                	sd	s0,32(sp)
     d4e:	ec26                	sd	s1,24(sp)
     d50:	e84a                	sd	s2,16(sp)
     d52:	e44e                	sd	s3,8(sp)
     d54:	1800                	addi	s0,sp,48
  int master_pid = getpid();
     d56:	00003097          	auipc	ra,0x3
     d5a:	470080e7          	jalr	1136(ra) # 41c6 <getpid>
     d5e:	89aa                	mv	s3,a0
  
  printf("reparent test\n");
     d60:	00004517          	auipc	a0,0x4
     d64:	fb050513          	addi	a0,a0,-80 # 4d10 <malloc+0x774>
     d68:	00003097          	auipc	ra,0x3
     d6c:	776080e7          	jalr	1910(ra) # 44de <printf>
     d70:	0c800913          	li	s2,200

  for(int i = 0; i < 200; i++){
    int pid = fork();
     d74:	00003097          	auipc	ra,0x3
     d78:	3ca080e7          	jalr	970(ra) # 413e <fork>
     d7c:	84aa                	mv	s1,a0
    if(pid < 0){
     d7e:	02054c63          	bltz	a0,db6 <reparent+0x6e>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid){
     d82:	c525                	beqz	a0,dea <reparent+0xa2>
      if(wait(0) != pid){
     d84:	4501                	li	a0,0
     d86:	00003097          	auipc	ra,0x3
     d8a:	3c8080e7          	jalr	968(ra) # 414e <wait>
     d8e:	04951163          	bne	a0,s1,dd0 <reparent+0x88>
  for(int i = 0; i < 200; i++){
     d92:	397d                	addiw	s2,s2,-1
     d94:	fe0910e3          	bnez	s2,d74 <reparent+0x2c>
      } else {
        exit(0);
      }
    }
  }
  printf("reparent ok\n");
     d98:	00004517          	auipc	a0,0x4
     d9c:	f8850513          	addi	a0,a0,-120 # 4d20 <malloc+0x784>
     da0:	00003097          	auipc	ra,0x3
     da4:	73e080e7          	jalr	1854(ra) # 44de <printf>
}
     da8:	70a2                	ld	ra,40(sp)
     daa:	7402                	ld	s0,32(sp)
     dac:	64e2                	ld	s1,24(sp)
     dae:	6942                	ld	s2,16(sp)
     db0:	69a2                	ld	s3,8(sp)
     db2:	6145                	addi	sp,sp,48
     db4:	8082                	ret
      printf("fork failed\n");
     db6:	00004517          	auipc	a0,0x4
     dba:	99a50513          	addi	a0,a0,-1638 # 4750 <malloc+0x1b4>
     dbe:	00003097          	auipc	ra,0x3
     dc2:	720080e7          	jalr	1824(ra) # 44de <printf>
      exit(-1);
     dc6:	557d                	li	a0,-1
     dc8:	00003097          	auipc	ra,0x3
     dcc:	37e080e7          	jalr	894(ra) # 4146 <exit>
        printf("wait wrong pid\n");
     dd0:	00004517          	auipc	a0,0x4
     dd4:	f0850513          	addi	a0,a0,-248 # 4cd8 <malloc+0x73c>
     dd8:	00003097          	auipc	ra,0x3
     ddc:	706080e7          	jalr	1798(ra) # 44de <printf>
        exit(-1);
     de0:	557d                	li	a0,-1
     de2:	00003097          	auipc	ra,0x3
     de6:	364080e7          	jalr	868(ra) # 4146 <exit>
      int pid2 = fork();
     dea:	00003097          	auipc	ra,0x3
     dee:	354080e7          	jalr	852(ra) # 413e <fork>
      if(pid2 < 0){
     df2:	00054763          	bltz	a0,e00 <reparent+0xb8>
      if(pid2 == 0){
     df6:	e51d                	bnez	a0,e24 <reparent+0xdc>
        exit(0);
     df8:	00003097          	auipc	ra,0x3
     dfc:	34e080e7          	jalr	846(ra) # 4146 <exit>
        printf("fork failed\n");
     e00:	00004517          	auipc	a0,0x4
     e04:	95050513          	addi	a0,a0,-1712 # 4750 <malloc+0x1b4>
     e08:	00003097          	auipc	ra,0x3
     e0c:	6d6080e7          	jalr	1750(ra) # 44de <printf>
        kill(master_pid);
     e10:	854e                	mv	a0,s3
     e12:	00003097          	auipc	ra,0x3
     e16:	364080e7          	jalr	868(ra) # 4176 <kill>
        exit(-1);
     e1a:	557d                	li	a0,-1
     e1c:	00003097          	auipc	ra,0x3
     e20:	32a080e7          	jalr	810(ra) # 4146 <exit>
        exit(0);
     e24:	4501                	li	a0,0
     e26:	00003097          	auipc	ra,0x3
     e2a:	320080e7          	jalr	800(ra) # 4146 <exit>

0000000000000e2e <twochildren>:

// what if two children exit() at the same time?
void
twochildren(void)
{
     e2e:	1101                	addi	sp,sp,-32
     e30:	ec06                	sd	ra,24(sp)
     e32:	e822                	sd	s0,16(sp)
     e34:	e426                	sd	s1,8(sp)
     e36:	1000                	addi	s0,sp,32
  printf("twochildren test\n");
     e38:	00004517          	auipc	a0,0x4
     e3c:	ef850513          	addi	a0,a0,-264 # 4d30 <malloc+0x794>
     e40:	00003097          	auipc	ra,0x3
     e44:	69e080e7          	jalr	1694(ra) # 44de <printf>
     e48:	3e800493          	li	s1,1000

  for(int i = 0; i < 1000; i++){
    int pid1 = fork();
     e4c:	00003097          	auipc	ra,0x3
     e50:	2f2080e7          	jalr	754(ra) # 413e <fork>
    if(pid1 < 0){
     e54:	04054363          	bltz	a0,e9a <twochildren+0x6c>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid1 == 0){
     e58:	cd31                	beqz	a0,eb4 <twochildren+0x86>
      exit(0);
    } else {
      int pid2 = fork();
     e5a:	00003097          	auipc	ra,0x3
     e5e:	2e4080e7          	jalr	740(ra) # 413e <fork>
      if(pid2 < 0){
     e62:	04054d63          	bltz	a0,ebc <twochildren+0x8e>
        printf("fork failed\n");
        exit(-1);
      }
      if(pid2 == 0){
     e66:	c925                	beqz	a0,ed6 <twochildren+0xa8>
        exit(0);
      } else {
        wait(0);
     e68:	4501                	li	a0,0
     e6a:	00003097          	auipc	ra,0x3
     e6e:	2e4080e7          	jalr	740(ra) # 414e <wait>
        wait(0);
     e72:	4501                	li	a0,0
     e74:	00003097          	auipc	ra,0x3
     e78:	2da080e7          	jalr	730(ra) # 414e <wait>
  for(int i = 0; i < 1000; i++){
     e7c:	34fd                	addiw	s1,s1,-1
     e7e:	f4f9                	bnez	s1,e4c <twochildren+0x1e>
      }
    }
  }
  printf("twochildren ok\n");
     e80:	00004517          	auipc	a0,0x4
     e84:	ec850513          	addi	a0,a0,-312 # 4d48 <malloc+0x7ac>
     e88:	00003097          	auipc	ra,0x3
     e8c:	656080e7          	jalr	1622(ra) # 44de <printf>
}
     e90:	60e2                	ld	ra,24(sp)
     e92:	6442                	ld	s0,16(sp)
     e94:	64a2                	ld	s1,8(sp)
     e96:	6105                	addi	sp,sp,32
     e98:	8082                	ret
      printf("fork failed\n");
     e9a:	00004517          	auipc	a0,0x4
     e9e:	8b650513          	addi	a0,a0,-1866 # 4750 <malloc+0x1b4>
     ea2:	00003097          	auipc	ra,0x3
     ea6:	63c080e7          	jalr	1596(ra) # 44de <printf>
      exit(-1);
     eaa:	557d                	li	a0,-1
     eac:	00003097          	auipc	ra,0x3
     eb0:	29a080e7          	jalr	666(ra) # 4146 <exit>
      exit(0);
     eb4:	00003097          	auipc	ra,0x3
     eb8:	292080e7          	jalr	658(ra) # 4146 <exit>
        printf("fork failed\n");
     ebc:	00004517          	auipc	a0,0x4
     ec0:	89450513          	addi	a0,a0,-1900 # 4750 <malloc+0x1b4>
     ec4:	00003097          	auipc	ra,0x3
     ec8:	61a080e7          	jalr	1562(ra) # 44de <printf>
        exit(-1);
     ecc:	557d                	li	a0,-1
     ece:	00003097          	auipc	ra,0x3
     ed2:	278080e7          	jalr	632(ra) # 4146 <exit>
        exit(0);
     ed6:	00003097          	auipc	ra,0x3
     eda:	270080e7          	jalr	624(ra) # 4146 <exit>

0000000000000ede <forkfork>:

// concurrent forks to try to expose locking bugs.
void
forkfork(void)
{
     ede:	1101                	addi	sp,sp,-32
     ee0:	ec06                	sd	ra,24(sp)
     ee2:	e822                	sd	s0,16(sp)
     ee4:	e426                	sd	s1,8(sp)
     ee6:	e04a                	sd	s2,0(sp)
     ee8:	1000                	addi	s0,sp,32
  int ppid = getpid();
     eea:	00003097          	auipc	ra,0x3
     eee:	2dc080e7          	jalr	732(ra) # 41c6 <getpid>
     ef2:	892a                	mv	s2,a0
  enum { N=2 };
  
  printf("forkfork test\n");
     ef4:	00004517          	auipc	a0,0x4
     ef8:	e6450513          	addi	a0,a0,-412 # 4d58 <malloc+0x7bc>
     efc:	00003097          	auipc	ra,0x3
     f00:	5e2080e7          	jalr	1506(ra) # 44de <printf>

  for(int i = 0; i < N; i++){
    int pid = fork();
     f04:	00003097          	auipc	ra,0x3
     f08:	23a080e7          	jalr	570(ra) # 413e <fork>
    if(pid < 0){
     f0c:	04054263          	bltz	a0,f50 <forkfork+0x72>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
     f10:	cd29                	beqz	a0,f6a <forkfork+0x8c>
    int pid = fork();
     f12:	00003097          	auipc	ra,0x3
     f16:	22c080e7          	jalr	556(ra) # 413e <fork>
    if(pid < 0){
     f1a:	02054b63          	bltz	a0,f50 <forkfork+0x72>
    if(pid == 0){
     f1e:	c531                	beqz	a0,f6a <forkfork+0x8c>
      exit(0);
    }
  }

  for(int i = 0; i < N; i++){
    wait(0);
     f20:	4501                	li	a0,0
     f22:	00003097          	auipc	ra,0x3
     f26:	22c080e7          	jalr	556(ra) # 414e <wait>
     f2a:	4501                	li	a0,0
     f2c:	00003097          	auipc	ra,0x3
     f30:	222080e7          	jalr	546(ra) # 414e <wait>
  }

  printf("forkfork ok\n");
     f34:	00004517          	auipc	a0,0x4
     f38:	e3450513          	addi	a0,a0,-460 # 4d68 <malloc+0x7cc>
     f3c:	00003097          	auipc	ra,0x3
     f40:	5a2080e7          	jalr	1442(ra) # 44de <printf>
}
     f44:	60e2                	ld	ra,24(sp)
     f46:	6442                	ld	s0,16(sp)
     f48:	64a2                	ld	s1,8(sp)
     f4a:	6902                	ld	s2,0(sp)
     f4c:	6105                	addi	sp,sp,32
     f4e:	8082                	ret
      printf("fork failed");
     f50:	00004517          	auipc	a0,0x4
     f54:	d0050513          	addi	a0,a0,-768 # 4c50 <malloc+0x6b4>
     f58:	00003097          	auipc	ra,0x3
     f5c:	586080e7          	jalr	1414(ra) # 44de <printf>
      exit(-1);
     f60:	557d                	li	a0,-1
     f62:	00003097          	auipc	ra,0x3
     f66:	1e4080e7          	jalr	484(ra) # 4146 <exit>
{
     f6a:	0c800493          	li	s1,200
        int pid1 = fork();
     f6e:	00003097          	auipc	ra,0x3
     f72:	1d0080e7          	jalr	464(ra) # 413e <fork>
        if(pid1 < 0){
     f76:	00054f63          	bltz	a0,f94 <forkfork+0xb6>
        if(pid1 == 0){
     f7a:	cd1d                	beqz	a0,fb8 <forkfork+0xda>
        wait(0);
     f7c:	4501                	li	a0,0
     f7e:	00003097          	auipc	ra,0x3
     f82:	1d0080e7          	jalr	464(ra) # 414e <wait>
      for(int j = 0; j < 200; j++){
     f86:	34fd                	addiw	s1,s1,-1
     f88:	f0fd                	bnez	s1,f6e <forkfork+0x90>
      exit(0);
     f8a:	4501                	li	a0,0
     f8c:	00003097          	auipc	ra,0x3
     f90:	1ba080e7          	jalr	442(ra) # 4146 <exit>
          printf("fork failed\n");
     f94:	00003517          	auipc	a0,0x3
     f98:	7bc50513          	addi	a0,a0,1980 # 4750 <malloc+0x1b4>
     f9c:	00003097          	auipc	ra,0x3
     fa0:	542080e7          	jalr	1346(ra) # 44de <printf>
          kill(ppid);
     fa4:	854a                	mv	a0,s2
     fa6:	00003097          	auipc	ra,0x3
     faa:	1d0080e7          	jalr	464(ra) # 4176 <kill>
          exit(-1);
     fae:	557d                	li	a0,-1
     fb0:	00003097          	auipc	ra,0x3
     fb4:	196080e7          	jalr	406(ra) # 4146 <exit>
          exit(0);
     fb8:	00003097          	auipc	ra,0x3
     fbc:	18e080e7          	jalr	398(ra) # 4146 <exit>

0000000000000fc0 <forkforkfork>:

void
forkforkfork(void)
{
     fc0:	1101                	addi	sp,sp,-32
     fc2:	ec06                	sd	ra,24(sp)
     fc4:	e822                	sd	s0,16(sp)
     fc6:	e426                	sd	s1,8(sp)
     fc8:	1000                	addi	s0,sp,32
  printf("forkforkfork test\n");
     fca:	00004517          	auipc	a0,0x4
     fce:	dae50513          	addi	a0,a0,-594 # 4d78 <malloc+0x7dc>
     fd2:	00003097          	auipc	ra,0x3
     fd6:	50c080e7          	jalr	1292(ra) # 44de <printf>

  unlink("stopforking");
     fda:	00004517          	auipc	a0,0x4
     fde:	db650513          	addi	a0,a0,-586 # 4d90 <malloc+0x7f4>
     fe2:	00003097          	auipc	ra,0x3
     fe6:	1b4080e7          	jalr	436(ra) # 4196 <unlink>

  int pid = fork();
     fea:	00003097          	auipc	ra,0x3
     fee:	154080e7          	jalr	340(ra) # 413e <fork>
  if(pid < 0){
     ff2:	04054d63          	bltz	a0,104c <forkforkfork+0x8c>
    printf("fork failed");
    exit(-1);
  }
  if(pid == 0){
     ff6:	c925                	beqz	a0,1066 <forkforkfork+0xa6>
    }

    exit(0);
  }

  sleep(20); // two seconds
     ff8:	4551                	li	a0,20
     ffa:	00003097          	auipc	ra,0x3
     ffe:	1dc080e7          	jalr	476(ra) # 41d6 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    1002:	20200593          	li	a1,514
    1006:	00004517          	auipc	a0,0x4
    100a:	d8a50513          	addi	a0,a0,-630 # 4d90 <malloc+0x7f4>
    100e:	00003097          	auipc	ra,0x3
    1012:	178080e7          	jalr	376(ra) # 4186 <open>
    1016:	00003097          	auipc	ra,0x3
    101a:	158080e7          	jalr	344(ra) # 416e <close>
  wait(0);
    101e:	4501                	li	a0,0
    1020:	00003097          	auipc	ra,0x3
    1024:	12e080e7          	jalr	302(ra) # 414e <wait>
  sleep(10); // one second
    1028:	4529                	li	a0,10
    102a:	00003097          	auipc	ra,0x3
    102e:	1ac080e7          	jalr	428(ra) # 41d6 <sleep>

  printf("forkforkfork ok\n");
    1032:	00004517          	auipc	a0,0x4
    1036:	d6e50513          	addi	a0,a0,-658 # 4da0 <malloc+0x804>
    103a:	00003097          	auipc	ra,0x3
    103e:	4a4080e7          	jalr	1188(ra) # 44de <printf>
}
    1042:	60e2                	ld	ra,24(sp)
    1044:	6442                	ld	s0,16(sp)
    1046:	64a2                	ld	s1,8(sp)
    1048:	6105                	addi	sp,sp,32
    104a:	8082                	ret
    printf("fork failed");
    104c:	00004517          	auipc	a0,0x4
    1050:	c0450513          	addi	a0,a0,-1020 # 4c50 <malloc+0x6b4>
    1054:	00003097          	auipc	ra,0x3
    1058:	48a080e7          	jalr	1162(ra) # 44de <printf>
    exit(-1);
    105c:	557d                	li	a0,-1
    105e:	00003097          	auipc	ra,0x3
    1062:	0e8080e7          	jalr	232(ra) # 4146 <exit>
      int fd = open("stopforking", 0);
    1066:	00004497          	auipc	s1,0x4
    106a:	d2a48493          	addi	s1,s1,-726 # 4d90 <malloc+0x7f4>
    106e:	4581                	li	a1,0
    1070:	8526                	mv	a0,s1
    1072:	00003097          	auipc	ra,0x3
    1076:	114080e7          	jalr	276(ra) # 4186 <open>
      if(fd >= 0){
    107a:	02055463          	bgez	a0,10a2 <forkforkfork+0xe2>
      if(fork() < 0){
    107e:	00003097          	auipc	ra,0x3
    1082:	0c0080e7          	jalr	192(ra) # 413e <fork>
    1086:	fe0554e3          	bgez	a0,106e <forkforkfork+0xae>
        close(open("stopforking", O_CREATE|O_RDWR));
    108a:	20200593          	li	a1,514
    108e:	8526                	mv	a0,s1
    1090:	00003097          	auipc	ra,0x3
    1094:	0f6080e7          	jalr	246(ra) # 4186 <open>
    1098:	00003097          	auipc	ra,0x3
    109c:	0d6080e7          	jalr	214(ra) # 416e <close>
    10a0:	b7f9                	j	106e <forkforkfork+0xae>
        exit(0);
    10a2:	4501                	li	a0,0
    10a4:	00003097          	auipc	ra,0x3
    10a8:	0a2080e7          	jalr	162(ra) # 4146 <exit>

00000000000010ac <mem>:

void
mem(void)
{
    10ac:	7179                	addi	sp,sp,-48
    10ae:	f406                	sd	ra,40(sp)
    10b0:	f022                	sd	s0,32(sp)
    10b2:	ec26                	sd	s1,24(sp)
    10b4:	e84a                	sd	s2,16(sp)
    10b6:	e44e                	sd	s3,8(sp)
    10b8:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid, ppid;

  printf("mem test\n");
    10ba:	00004517          	auipc	a0,0x4
    10be:	cfe50513          	addi	a0,a0,-770 # 4db8 <malloc+0x81c>
    10c2:	00003097          	auipc	ra,0x3
    10c6:	41c080e7          	jalr	1052(ra) # 44de <printf>
  ppid = getpid();
    10ca:	00003097          	auipc	ra,0x3
    10ce:	0fc080e7          	jalr	252(ra) # 41c6 <getpid>
    10d2:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    10d4:	00003097          	auipc	ra,0x3
    10d8:	06a080e7          	jalr	106(ra) # 413e <fork>
    m1 = 0;
    10dc:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    10de:	6909                	lui	s2,0x2
    10e0:	71190913          	addi	s2,s2,1809 # 2711 <subdir+0x5a9>
  if((pid = fork()) == 0){
    10e4:	cd19                	beqz	a0,1102 <mem+0x56>
    }
    free(m1);
    printf("mem ok\n");
    exit(0);
  } else {
    wait(0);
    10e6:	4501                	li	a0,0
    10e8:	00003097          	auipc	ra,0x3
    10ec:	066080e7          	jalr	102(ra) # 414e <wait>
  }
}
    10f0:	70a2                	ld	ra,40(sp)
    10f2:	7402                	ld	s0,32(sp)
    10f4:	64e2                	ld	s1,24(sp)
    10f6:	6942                	ld	s2,16(sp)
    10f8:	69a2                	ld	s3,8(sp)
    10fa:	6145                	addi	sp,sp,48
    10fc:	8082                	ret
      *(char**)m2 = m1;
    10fe:	e104                	sd	s1,0(a0)
      m1 = m2;
    1100:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    1102:	854a                	mv	a0,s2
    1104:	00003097          	auipc	ra,0x3
    1108:	498080e7          	jalr	1176(ra) # 459c <malloc>
    110c:	f96d                	bnez	a0,10fe <mem+0x52>
    while(m1){
    110e:	c881                	beqz	s1,111e <mem+0x72>
      m2 = *(char**)m1;
    1110:	8526                	mv	a0,s1
    1112:	6084                	ld	s1,0(s1)
      free(m1);
    1114:	00003097          	auipc	ra,0x3
    1118:	400080e7          	jalr	1024(ra) # 4514 <free>
    while(m1){
    111c:	f8f5                	bnez	s1,1110 <mem+0x64>
    m1 = malloc(1024*20);
    111e:	6515                	lui	a0,0x5
    1120:	00003097          	auipc	ra,0x3
    1124:	47c080e7          	jalr	1148(ra) # 459c <malloc>
    if(m1 == 0){
    1128:	c115                	beqz	a0,114c <mem+0xa0>
    free(m1);
    112a:	00003097          	auipc	ra,0x3
    112e:	3ea080e7          	jalr	1002(ra) # 4514 <free>
    printf("mem ok\n");
    1132:	00004517          	auipc	a0,0x4
    1136:	cb650513          	addi	a0,a0,-842 # 4de8 <malloc+0x84c>
    113a:	00003097          	auipc	ra,0x3
    113e:	3a4080e7          	jalr	932(ra) # 44de <printf>
    exit(0);
    1142:	4501                	li	a0,0
    1144:	00003097          	auipc	ra,0x3
    1148:	002080e7          	jalr	2(ra) # 4146 <exit>
      printf("couldn't allocate mem?!!\n");
    114c:	00004517          	auipc	a0,0x4
    1150:	c7c50513          	addi	a0,a0,-900 # 4dc8 <malloc+0x82c>
    1154:	00003097          	auipc	ra,0x3
    1158:	38a080e7          	jalr	906(ra) # 44de <printf>
      kill(ppid);
    115c:	854e                	mv	a0,s3
    115e:	00003097          	auipc	ra,0x3
    1162:	018080e7          	jalr	24(ra) # 4176 <kill>
      exit(-1);
    1166:	557d                	li	a0,-1
    1168:	00003097          	auipc	ra,0x3
    116c:	fde080e7          	jalr	-34(ra) # 4146 <exit>

0000000000001170 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    1170:	715d                	addi	sp,sp,-80
    1172:	e486                	sd	ra,72(sp)
    1174:	e0a2                	sd	s0,64(sp)
    1176:	fc26                	sd	s1,56(sp)
    1178:	f84a                	sd	s2,48(sp)
    117a:	f44e                	sd	s3,40(sp)
    117c:	f052                	sd	s4,32(sp)
    117e:	ec56                	sd	s5,24(sp)
    1180:	e85a                	sd	s6,16(sp)
    1182:	0880                	addi	s0,sp,80
  int fd, pid, i, n, nc, np;
  enum { N = 1000, SZ=10};
  char buf[SZ];

  printf("sharedfd test\n");
    1184:	00004517          	auipc	a0,0x4
    1188:	c6c50513          	addi	a0,a0,-916 # 4df0 <malloc+0x854>
    118c:	00003097          	auipc	ra,0x3
    1190:	352080e7          	jalr	850(ra) # 44de <printf>

  unlink("sharedfd");
    1194:	00004517          	auipc	a0,0x4
    1198:	c6c50513          	addi	a0,a0,-916 # 4e00 <malloc+0x864>
    119c:	00003097          	auipc	ra,0x3
    11a0:	ffa080e7          	jalr	-6(ra) # 4196 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    11a4:	20200593          	li	a1,514
    11a8:	00004517          	auipc	a0,0x4
    11ac:	c5850513          	addi	a0,a0,-936 # 4e00 <malloc+0x864>
    11b0:	00003097          	auipc	ra,0x3
    11b4:	fd6080e7          	jalr	-42(ra) # 4186 <open>
  if(fd < 0){
    11b8:	04054463          	bltz	a0,1200 <sharedfd+0x90>
    11bc:	892a                	mv	s2,a0
    printf("fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    11be:	00003097          	auipc	ra,0x3
    11c2:	f80080e7          	jalr	-128(ra) # 413e <fork>
    11c6:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    11c8:	06300593          	li	a1,99
    11cc:	c119                	beqz	a0,11d2 <sharedfd+0x62>
    11ce:	07000593          	li	a1,112
    11d2:	4629                	li	a2,10
    11d4:	fb040513          	addi	a0,s0,-80
    11d8:	00003097          	auipc	ra,0x3
    11dc:	df2080e7          	jalr	-526(ra) # 3fca <memset>
    11e0:	3e800493          	li	s1,1000
  for(i = 0; i < N; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    11e4:	4629                	li	a2,10
    11e6:	fb040593          	addi	a1,s0,-80
    11ea:	854a                	mv	a0,s2
    11ec:	00003097          	auipc	ra,0x3
    11f0:	f7a080e7          	jalr	-134(ra) # 4166 <write>
    11f4:	47a9                	li	a5,10
    11f6:	00f51e63          	bne	a0,a5,1212 <sharedfd+0xa2>
  for(i = 0; i < N; i++){
    11fa:	34fd                	addiw	s1,s1,-1
    11fc:	f4e5                	bnez	s1,11e4 <sharedfd+0x74>
    11fe:	a015                	j	1222 <sharedfd+0xb2>
    printf("fstests: cannot open sharedfd for writing");
    1200:	00004517          	auipc	a0,0x4
    1204:	c1050513          	addi	a0,a0,-1008 # 4e10 <malloc+0x874>
    1208:	00003097          	auipc	ra,0x3
    120c:	2d6080e7          	jalr	726(ra) # 44de <printf>
    return;
    1210:	a8f9                	j	12ee <sharedfd+0x17e>
      printf("fstests: write sharedfd failed\n");
    1212:	00004517          	auipc	a0,0x4
    1216:	c2e50513          	addi	a0,a0,-978 # 4e40 <malloc+0x8a4>
    121a:	00003097          	auipc	ra,0x3
    121e:	2c4080e7          	jalr	708(ra) # 44de <printf>
      break;
    }
  }
  if(pid == 0)
    1222:	04098d63          	beqz	s3,127c <sharedfd+0x10c>
    exit(0);
  else
    wait(0);
    1226:	4501                	li	a0,0
    1228:	00003097          	auipc	ra,0x3
    122c:	f26080e7          	jalr	-218(ra) # 414e <wait>
  close(fd);
    1230:	854a                	mv	a0,s2
    1232:	00003097          	auipc	ra,0x3
    1236:	f3c080e7          	jalr	-196(ra) # 416e <close>
  fd = open("sharedfd", 0);
    123a:	4581                	li	a1,0
    123c:	00004517          	auipc	a0,0x4
    1240:	bc450513          	addi	a0,a0,-1084 # 4e00 <malloc+0x864>
    1244:	00003097          	auipc	ra,0x3
    1248:	f42080e7          	jalr	-190(ra) # 4186 <open>
    124c:	8b2a                	mv	s6,a0
  if(fd < 0){
    printf("fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
    124e:	4a01                	li	s4,0
    1250:	4981                	li	s3,0
  if(fd < 0){
    1252:	02054a63          	bltz	a0,1286 <sharedfd+0x116>
    1256:	fba40913          	addi	s2,s0,-70
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
    125a:	06300493          	li	s1,99
        nc++;
      if(buf[i] == 'p')
    125e:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1262:	4629                	li	a2,10
    1264:	fb040593          	addi	a1,s0,-80
    1268:	855a                	mv	a0,s6
    126a:	00003097          	auipc	ra,0x3
    126e:	ef4080e7          	jalr	-268(ra) # 415e <read>
    1272:	02a05f63          	blez	a0,12b0 <sharedfd+0x140>
    1276:	fb040793          	addi	a5,s0,-80
    127a:	a01d                	j	12a0 <sharedfd+0x130>
    exit(0);
    127c:	4501                	li	a0,0
    127e:	00003097          	auipc	ra,0x3
    1282:	ec8080e7          	jalr	-312(ra) # 4146 <exit>
    printf("fstests: cannot open sharedfd for reading\n");
    1286:	00004517          	auipc	a0,0x4
    128a:	bda50513          	addi	a0,a0,-1062 # 4e60 <malloc+0x8c4>
    128e:	00003097          	auipc	ra,0x3
    1292:	250080e7          	jalr	592(ra) # 44de <printf>
    return;
    1296:	a8a1                	j	12ee <sharedfd+0x17e>
        nc++;
    1298:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    129a:	0785                	addi	a5,a5,1
    129c:	fd2783e3          	beq	a5,s2,1262 <sharedfd+0xf2>
      if(buf[i] == 'c')
    12a0:	0007c703          	lbu	a4,0(a5)
    12a4:	fe970ae3          	beq	a4,s1,1298 <sharedfd+0x128>
      if(buf[i] == 'p')
    12a8:	ff5719e3          	bne	a4,s5,129a <sharedfd+0x12a>
        np++;
    12ac:	2a05                	addiw	s4,s4,1
    12ae:	b7f5                	j	129a <sharedfd+0x12a>
    }
  }
  close(fd);
    12b0:	855a                	mv	a0,s6
    12b2:	00003097          	auipc	ra,0x3
    12b6:	ebc080e7          	jalr	-324(ra) # 416e <close>
  unlink("sharedfd");
    12ba:	00004517          	auipc	a0,0x4
    12be:	b4650513          	addi	a0,a0,-1210 # 4e00 <malloc+0x864>
    12c2:	00003097          	auipc	ra,0x3
    12c6:	ed4080e7          	jalr	-300(ra) # 4196 <unlink>
  if(nc == N*SZ && np == N*SZ){
    12ca:	6789                	lui	a5,0x2
    12cc:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x5a8>
    12d0:	02f99963          	bne	s3,a5,1302 <sharedfd+0x192>
    12d4:	6789                	lui	a5,0x2
    12d6:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x5a8>
    12da:	02fa1463          	bne	s4,a5,1302 <sharedfd+0x192>
    printf("sharedfd ok\n");
    12de:	00004517          	auipc	a0,0x4
    12e2:	bb250513          	addi	a0,a0,-1102 # 4e90 <malloc+0x8f4>
    12e6:	00003097          	auipc	ra,0x3
    12ea:	1f8080e7          	jalr	504(ra) # 44de <printf>
  } else {
    printf("sharedfd oops %d %d\n", nc, np);
    exit(-1);
  }
}
    12ee:	60a6                	ld	ra,72(sp)
    12f0:	6406                	ld	s0,64(sp)
    12f2:	74e2                	ld	s1,56(sp)
    12f4:	7942                	ld	s2,48(sp)
    12f6:	79a2                	ld	s3,40(sp)
    12f8:	7a02                	ld	s4,32(sp)
    12fa:	6ae2                	ld	s5,24(sp)
    12fc:	6b42                	ld	s6,16(sp)
    12fe:	6161                	addi	sp,sp,80
    1300:	8082                	ret
    printf("sharedfd oops %d %d\n", nc, np);
    1302:	8652                	mv	a2,s4
    1304:	85ce                	mv	a1,s3
    1306:	00004517          	auipc	a0,0x4
    130a:	b9a50513          	addi	a0,a0,-1126 # 4ea0 <malloc+0x904>
    130e:	00003097          	auipc	ra,0x3
    1312:	1d0080e7          	jalr	464(ra) # 44de <printf>
    exit(-1);
    1316:	557d                	li	a0,-1
    1318:	00003097          	auipc	ra,0x3
    131c:	e2e080e7          	jalr	-466(ra) # 4146 <exit>

0000000000001320 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1320:	7119                	addi	sp,sp,-128
    1322:	fc86                	sd	ra,120(sp)
    1324:	f8a2                	sd	s0,112(sp)
    1326:	f4a6                	sd	s1,104(sp)
    1328:	f0ca                	sd	s2,96(sp)
    132a:	ecce                	sd	s3,88(sp)
    132c:	e8d2                	sd	s4,80(sp)
    132e:	e4d6                	sd	s5,72(sp)
    1330:	e0da                	sd	s6,64(sp)
    1332:	fc5e                	sd	s7,56(sp)
    1334:	f862                	sd	s8,48(sp)
    1336:	f466                	sd	s9,40(sp)
    1338:	f06a                	sd	s10,32(sp)
    133a:	0100                	addi	s0,sp,128
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    133c:	00003797          	auipc	a5,0x3
    1340:	34c78793          	addi	a5,a5,844 # 4688 <malloc+0xec>
    1344:	f8f43023          	sd	a5,-128(s0)
    1348:	00003797          	auipc	a5,0x3
    134c:	34878793          	addi	a5,a5,840 # 4690 <malloc+0xf4>
    1350:	f8f43423          	sd	a5,-120(s0)
    1354:	00003797          	auipc	a5,0x3
    1358:	34478793          	addi	a5,a5,836 # 4698 <malloc+0xfc>
    135c:	f8f43823          	sd	a5,-112(s0)
    1360:	00003797          	auipc	a5,0x3
    1364:	34078793          	addi	a5,a5,832 # 46a0 <malloc+0x104>
    1368:	f8f43c23          	sd	a5,-104(s0)
  char *fname;
  enum { N=12, NCHILD=4, SZ=500 };
  
  printf("fourfiles test\n");
    136c:	00004517          	auipc	a0,0x4
    1370:	b4c50513          	addi	a0,a0,-1204 # 4eb8 <malloc+0x91c>
    1374:	00003097          	auipc	ra,0x3
    1378:	16a080e7          	jalr	362(ra) # 44de <printf>

  for(pi = 0; pi < NCHILD; pi++){
    137c:	f8040b93          	addi	s7,s0,-128
  printf("fourfiles test\n");
    1380:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    1382:	4481                	li	s1,0
    1384:	4a11                	li	s4,4
    fname = names[pi];
    1386:	00093983          	ld	s3,0(s2)
    unlink(fname);
    138a:	854e                	mv	a0,s3
    138c:	00003097          	auipc	ra,0x3
    1390:	e0a080e7          	jalr	-502(ra) # 4196 <unlink>

    pid = fork();
    1394:	00003097          	auipc	ra,0x3
    1398:	daa080e7          	jalr	-598(ra) # 413e <fork>
    if(pid < 0){
    139c:	04054b63          	bltz	a0,13f2 <fourfiles+0xd2>
      printf("fork failed\n");
      exit(-1);
    }

    if(pid == 0){
    13a0:	c535                	beqz	a0,140c <fourfiles+0xec>
  for(pi = 0; pi < NCHILD; pi++){
    13a2:	2485                	addiw	s1,s1,1
    13a4:	0921                	addi	s2,s2,8
    13a6:	ff4490e3          	bne	s1,s4,1386 <fourfiles+0x66>
      exit(0);
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait(0);
    13aa:	4501                	li	a0,0
    13ac:	00003097          	auipc	ra,0x3
    13b0:	da2080e7          	jalr	-606(ra) # 414e <wait>
    13b4:	4501                	li	a0,0
    13b6:	00003097          	auipc	ra,0x3
    13ba:	d98080e7          	jalr	-616(ra) # 414e <wait>
    13be:	4501                	li	a0,0
    13c0:	00003097          	auipc	ra,0x3
    13c4:	d8e080e7          	jalr	-626(ra) # 414e <wait>
    13c8:	4501                	li	a0,0
    13ca:	00003097          	auipc	ra,0x3
    13ce:	d84080e7          	jalr	-636(ra) # 414e <wait>
    13d2:	03000b13          	li	s6,48

  for(i = 0; i < NCHILD; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    13d6:	00008a17          	auipc	s4,0x8
    13da:	8b2a0a13          	addi	s4,s4,-1870 # 8c88 <buf>
    13de:	00008a97          	auipc	s5,0x8
    13e2:	8aba8a93          	addi	s5,s5,-1877 # 8c89 <buf+0x1>
        }
      }
      total += n;
    }
    close(fd);
    if(total != N*SZ){
    13e6:	6c85                	lui	s9,0x1
    13e8:	770c8c93          	addi	s9,s9,1904 # 1770 <createdelete+0x1fe>
  for(i = 0; i < NCHILD; i++){
    13ec:	03400d13          	li	s10,52
    13f0:	a205                	j	1510 <fourfiles+0x1f0>
      printf("fork failed\n");
    13f2:	00003517          	auipc	a0,0x3
    13f6:	35e50513          	addi	a0,a0,862 # 4750 <malloc+0x1b4>
    13fa:	00003097          	auipc	ra,0x3
    13fe:	0e4080e7          	jalr	228(ra) # 44de <printf>
      exit(-1);
    1402:	557d                	li	a0,-1
    1404:	00003097          	auipc	ra,0x3
    1408:	d42080e7          	jalr	-702(ra) # 4146 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    140c:	20200593          	li	a1,514
    1410:	854e                	mv	a0,s3
    1412:	00003097          	auipc	ra,0x3
    1416:	d74080e7          	jalr	-652(ra) # 4186 <open>
    141a:	892a                	mv	s2,a0
      if(fd < 0){
    141c:	04054763          	bltz	a0,146a <fourfiles+0x14a>
      memset(buf, '0'+pi, SZ);
    1420:	1f400613          	li	a2,500
    1424:	0304859b          	addiw	a1,s1,48
    1428:	00008517          	auipc	a0,0x8
    142c:	86050513          	addi	a0,a0,-1952 # 8c88 <buf>
    1430:	00003097          	auipc	ra,0x3
    1434:	b9a080e7          	jalr	-1126(ra) # 3fca <memset>
    1438:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    143a:	00008997          	auipc	s3,0x8
    143e:	84e98993          	addi	s3,s3,-1970 # 8c88 <buf>
    1442:	1f400613          	li	a2,500
    1446:	85ce                	mv	a1,s3
    1448:	854a                	mv	a0,s2
    144a:	00003097          	auipc	ra,0x3
    144e:	d1c080e7          	jalr	-740(ra) # 4166 <write>
    1452:	85aa                	mv	a1,a0
    1454:	1f400793          	li	a5,500
    1458:	02f51663          	bne	a0,a5,1484 <fourfiles+0x164>
      for(i = 0; i < N; i++){
    145c:	34fd                	addiw	s1,s1,-1
    145e:	f0f5                	bnez	s1,1442 <fourfiles+0x122>
      exit(0);
    1460:	4501                	li	a0,0
    1462:	00003097          	auipc	ra,0x3
    1466:	ce4080e7          	jalr	-796(ra) # 4146 <exit>
        printf("create failed\n");
    146a:	00004517          	auipc	a0,0x4
    146e:	a5e50513          	addi	a0,a0,-1442 # 4ec8 <malloc+0x92c>
    1472:	00003097          	auipc	ra,0x3
    1476:	06c080e7          	jalr	108(ra) # 44de <printf>
        exit(-1);
    147a:	557d                	li	a0,-1
    147c:	00003097          	auipc	ra,0x3
    1480:	cca080e7          	jalr	-822(ra) # 4146 <exit>
          printf("write failed %d\n", n);
    1484:	00004517          	auipc	a0,0x4
    1488:	a5450513          	addi	a0,a0,-1452 # 4ed8 <malloc+0x93c>
    148c:	00003097          	auipc	ra,0x3
    1490:	052080e7          	jalr	82(ra) # 44de <printf>
          exit(-1);
    1494:	557d                	li	a0,-1
    1496:	00003097          	auipc	ra,0x3
    149a:	cb0080e7          	jalr	-848(ra) # 4146 <exit>
          printf("wrong char\n");
    149e:	00004517          	auipc	a0,0x4
    14a2:	a5250513          	addi	a0,a0,-1454 # 4ef0 <malloc+0x954>
    14a6:	00003097          	auipc	ra,0x3
    14aa:	038080e7          	jalr	56(ra) # 44de <printf>
          exit(-1);
    14ae:	557d                	li	a0,-1
    14b0:	00003097          	auipc	ra,0x3
    14b4:	c96080e7          	jalr	-874(ra) # 4146 <exit>
      total += n;
    14b8:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    14bc:	660d                	lui	a2,0x3
    14be:	85d2                	mv	a1,s4
    14c0:	854e                	mv	a0,s3
    14c2:	00003097          	auipc	ra,0x3
    14c6:	c9c080e7          	jalr	-868(ra) # 415e <read>
    14ca:	02a05363          	blez	a0,14f0 <fourfiles+0x1d0>
    14ce:	00007797          	auipc	a5,0x7
    14d2:	7ba78793          	addi	a5,a5,1978 # 8c88 <buf>
    14d6:	fff5069b          	addiw	a3,a0,-1
    14da:	1682                	slli	a3,a3,0x20
    14dc:	9281                	srli	a3,a3,0x20
    14de:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    14e0:	0007c703          	lbu	a4,0(a5)
    14e4:	fa971de3          	bne	a4,s1,149e <fourfiles+0x17e>
      for(j = 0; j < n; j++){
    14e8:	0785                	addi	a5,a5,1
    14ea:	fed79be3          	bne	a5,a3,14e0 <fourfiles+0x1c0>
    14ee:	b7e9                	j	14b8 <fourfiles+0x198>
    close(fd);
    14f0:	854e                	mv	a0,s3
    14f2:	00003097          	auipc	ra,0x3
    14f6:	c7c080e7          	jalr	-900(ra) # 416e <close>
    if(total != N*SZ){
    14fa:	03991863          	bne	s2,s9,152a <fourfiles+0x20a>
      printf("wrong length %d\n", total);
      exit(-1);
    }
    unlink(fname);
    14fe:	8562                	mv	a0,s8
    1500:	00003097          	auipc	ra,0x3
    1504:	c96080e7          	jalr	-874(ra) # 4196 <unlink>
  for(i = 0; i < NCHILD; i++){
    1508:	0ba1                	addi	s7,s7,8
    150a:	2b05                	addiw	s6,s6,1
    150c:	03ab0d63          	beq	s6,s10,1546 <fourfiles+0x226>
    fname = names[i];
    1510:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1514:	4581                	li	a1,0
    1516:	8562                	mv	a0,s8
    1518:	00003097          	auipc	ra,0x3
    151c:	c6e080e7          	jalr	-914(ra) # 4186 <open>
    1520:	89aa                	mv	s3,a0
    total = 0;
    1522:	4901                	li	s2,0
        if(buf[j] != '0'+i){
    1524:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1528:	bf51                	j	14bc <fourfiles+0x19c>
      printf("wrong length %d\n", total);
    152a:	85ca                	mv	a1,s2
    152c:	00004517          	auipc	a0,0x4
    1530:	9d450513          	addi	a0,a0,-1580 # 4f00 <malloc+0x964>
    1534:	00003097          	auipc	ra,0x3
    1538:	faa080e7          	jalr	-86(ra) # 44de <printf>
      exit(-1);
    153c:	557d                	li	a0,-1
    153e:	00003097          	auipc	ra,0x3
    1542:	c08080e7          	jalr	-1016(ra) # 4146 <exit>
  }

  printf("fourfiles ok\n");
    1546:	00004517          	auipc	a0,0x4
    154a:	9d250513          	addi	a0,a0,-1582 # 4f18 <malloc+0x97c>
    154e:	00003097          	auipc	ra,0x3
    1552:	f90080e7          	jalr	-112(ra) # 44de <printf>
}
    1556:	70e6                	ld	ra,120(sp)
    1558:	7446                	ld	s0,112(sp)
    155a:	74a6                	ld	s1,104(sp)
    155c:	7906                	ld	s2,96(sp)
    155e:	69e6                	ld	s3,88(sp)
    1560:	6a46                	ld	s4,80(sp)
    1562:	6aa6                	ld	s5,72(sp)
    1564:	6b06                	ld	s6,64(sp)
    1566:	7be2                	ld	s7,56(sp)
    1568:	7c42                	ld	s8,48(sp)
    156a:	7ca2                	ld	s9,40(sp)
    156c:	7d02                	ld	s10,32(sp)
    156e:	6109                	addi	sp,sp,128
    1570:	8082                	ret

0000000000001572 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1572:	7159                	addi	sp,sp,-112
    1574:	f486                	sd	ra,104(sp)
    1576:	f0a2                	sd	s0,96(sp)
    1578:	eca6                	sd	s1,88(sp)
    157a:	e8ca                	sd	s2,80(sp)
    157c:	e4ce                	sd	s3,72(sp)
    157e:	e0d2                	sd	s4,64(sp)
    1580:	fc56                	sd	s5,56(sp)
    1582:	f85a                	sd	s6,48(sp)
    1584:	f45e                	sd	s7,40(sp)
    1586:	f062                	sd	s8,32(sp)
    1588:	1880                	addi	s0,sp,112
  enum { N = 20, NCHILD=4 };
  int pid, i, fd, pi;
  char name[32];

  printf("createdelete test\n");
    158a:	00004517          	auipc	a0,0x4
    158e:	99e50513          	addi	a0,a0,-1634 # 4f28 <malloc+0x98c>
    1592:	00003097          	auipc	ra,0x3
    1596:	f4c080e7          	jalr	-180(ra) # 44de <printf>

  for(pi = 0; pi < NCHILD; pi++){
    159a:	4901                	li	s2,0
    159c:	4991                	li	s3,4
    pid = fork();
    159e:	00003097          	auipc	ra,0x3
    15a2:	ba0080e7          	jalr	-1120(ra) # 413e <fork>
    15a6:	84aa                	mv	s1,a0
    if(pid < 0){
    15a8:	04054763          	bltz	a0,15f6 <createdelete+0x84>
      printf("fork failed\n");
      exit(-1);
    }

    if(pid == 0){
    15ac:	c135                	beqz	a0,1610 <createdelete+0x9e>
  for(pi = 0; pi < NCHILD; pi++){
    15ae:	2905                	addiw	s2,s2,1
    15b0:	ff3917e3          	bne	s2,s3,159e <createdelete+0x2c>
      exit(0);
    }
  }

  for(pi = 0; pi < NCHILD; pi++){
    wait(0);
    15b4:	4501                	li	a0,0
    15b6:	00003097          	auipc	ra,0x3
    15ba:	b98080e7          	jalr	-1128(ra) # 414e <wait>
    15be:	4501                	li	a0,0
    15c0:	00003097          	auipc	ra,0x3
    15c4:	b8e080e7          	jalr	-1138(ra) # 414e <wait>
    15c8:	4501                	li	a0,0
    15ca:	00003097          	auipc	ra,0x3
    15ce:	b84080e7          	jalr	-1148(ra) # 414e <wait>
    15d2:	4501                	li	a0,0
    15d4:	00003097          	auipc	ra,0x3
    15d8:	b7a080e7          	jalr	-1158(ra) # 414e <wait>
  }

  name[0] = name[1] = name[2] = 0;
    15dc:	f8040923          	sb	zero,-110(s0)
    15e0:	03000993          	li	s3,48
    15e4:	5a7d                	li	s4,-1
  for(i = 0; i < N; i++){
    15e6:	4901                	li	s2,0
  for(pi = 0; pi < NCHILD; pi++){
    15e8:	07000c13          	li	s8,112
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf("oops createdelete %s didn't exist\n", name);
        exit(-1);
      } else if((i >= 1 && i < N/2) && fd >= 0){
    15ec:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    15ee:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    15f0:	07400a93          	li	s5,116
    15f4:	aa89                	j	1746 <createdelete+0x1d4>
      printf("fork failed\n");
    15f6:	00003517          	auipc	a0,0x3
    15fa:	15a50513          	addi	a0,a0,346 # 4750 <malloc+0x1b4>
    15fe:	00003097          	auipc	ra,0x3
    1602:	ee0080e7          	jalr	-288(ra) # 44de <printf>
      exit(-1);
    1606:	557d                	li	a0,-1
    1608:	00003097          	auipc	ra,0x3
    160c:	b3e080e7          	jalr	-1218(ra) # 4146 <exit>
      name[0] = 'p' + pi;
    1610:	0709091b          	addiw	s2,s2,112
    1614:	f9240823          	sb	s2,-112(s0)
      name[2] = '\0';
    1618:	f8040923          	sb	zero,-110(s0)
      for(i = 0; i < N; i++){
    161c:	4951                	li	s2,20
    161e:	a00d                	j	1640 <createdelete+0xce>
          printf("create failed\n");
    1620:	00004517          	auipc	a0,0x4
    1624:	8a850513          	addi	a0,a0,-1880 # 4ec8 <malloc+0x92c>
    1628:	00003097          	auipc	ra,0x3
    162c:	eb6080e7          	jalr	-330(ra) # 44de <printf>
          exit(-1);
    1630:	557d                	li	a0,-1
    1632:	00003097          	auipc	ra,0x3
    1636:	b14080e7          	jalr	-1260(ra) # 4146 <exit>
      for(i = 0; i < N; i++){
    163a:	2485                	addiw	s1,s1,1
    163c:	07248763          	beq	s1,s2,16aa <createdelete+0x138>
        name[1] = '0' + i;
    1640:	0304879b          	addiw	a5,s1,48
    1644:	f8f408a3          	sb	a5,-111(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1648:	20200593          	li	a1,514
    164c:	f9040513          	addi	a0,s0,-112
    1650:	00003097          	auipc	ra,0x3
    1654:	b36080e7          	jalr	-1226(ra) # 4186 <open>
        if(fd < 0){
    1658:	fc0544e3          	bltz	a0,1620 <createdelete+0xae>
        close(fd);
    165c:	00003097          	auipc	ra,0x3
    1660:	b12080e7          	jalr	-1262(ra) # 416e <close>
        if(i > 0 && (i % 2 ) == 0){
    1664:	fc905be3          	blez	s1,163a <createdelete+0xc8>
    1668:	0014f793          	andi	a5,s1,1
    166c:	f7f9                	bnez	a5,163a <createdelete+0xc8>
          name[1] = '0' + (i / 2);
    166e:	01f4d79b          	srliw	a5,s1,0x1f
    1672:	9fa5                	addw	a5,a5,s1
    1674:	4017d79b          	sraiw	a5,a5,0x1
    1678:	0307879b          	addiw	a5,a5,48
    167c:	f8f408a3          	sb	a5,-111(s0)
          if(unlink(name) < 0){
    1680:	f9040513          	addi	a0,s0,-112
    1684:	00003097          	auipc	ra,0x3
    1688:	b12080e7          	jalr	-1262(ra) # 4196 <unlink>
    168c:	fa0557e3          	bgez	a0,163a <createdelete+0xc8>
            printf("unlink failed\n");
    1690:	00003517          	auipc	a0,0x3
    1694:	15850513          	addi	a0,a0,344 # 47e8 <malloc+0x24c>
    1698:	00003097          	auipc	ra,0x3
    169c:	e46080e7          	jalr	-442(ra) # 44de <printf>
            exit(-1);
    16a0:	557d                	li	a0,-1
    16a2:	00003097          	auipc	ra,0x3
    16a6:	aa4080e7          	jalr	-1372(ra) # 4146 <exit>
      exit(0);
    16aa:	4501                	li	a0,0
    16ac:	00003097          	auipc	ra,0x3
    16b0:	a9a080e7          	jalr	-1382(ra) # 4146 <exit>
        printf("oops createdelete %s didn't exist\n", name);
    16b4:	f9040593          	addi	a1,s0,-112
    16b8:	00004517          	auipc	a0,0x4
    16bc:	88850513          	addi	a0,a0,-1912 # 4f40 <malloc+0x9a4>
    16c0:	00003097          	auipc	ra,0x3
    16c4:	e1e080e7          	jalr	-482(ra) # 44de <printf>
        exit(-1);
    16c8:	557d                	li	a0,-1
    16ca:	00003097          	auipc	ra,0x3
    16ce:	a7c080e7          	jalr	-1412(ra) # 4146 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    16d2:	054b7163          	bgeu	s6,s4,1714 <createdelete+0x1a2>
        printf("oops createdelete %s did exist\n", name);
        exit(-1);
      }
      if(fd >= 0)
    16d6:	02055a63          	bgez	a0,170a <createdelete+0x198>
    for(pi = 0; pi < NCHILD; pi++){
    16da:	2485                	addiw	s1,s1,1
    16dc:	0ff4f493          	andi	s1,s1,255
    16e0:	05548b63          	beq	s1,s5,1736 <createdelete+0x1c4>
      name[0] = 'p' + pi;
    16e4:	f8940823          	sb	s1,-112(s0)
      name[1] = '0' + i;
    16e8:	f93408a3          	sb	s3,-111(s0)
      fd = open(name, 0);
    16ec:	4581                	li	a1,0
    16ee:	f9040513          	addi	a0,s0,-112
    16f2:	00003097          	auipc	ra,0x3
    16f6:	a94080e7          	jalr	-1388(ra) # 4186 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    16fa:	00090463          	beqz	s2,1702 <createdelete+0x190>
    16fe:	fd2bdae3          	bge	s7,s2,16d2 <createdelete+0x160>
    1702:	fa0549e3          	bltz	a0,16b4 <createdelete+0x142>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1706:	014b7963          	bgeu	s6,s4,1718 <createdelete+0x1a6>
        close(fd);
    170a:	00003097          	auipc	ra,0x3
    170e:	a64080e7          	jalr	-1436(ra) # 416e <close>
    1712:	b7e1                	j	16da <createdelete+0x168>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1714:	fc0543e3          	bltz	a0,16da <createdelete+0x168>
        printf("oops createdelete %s did exist\n", name);
    1718:	f9040593          	addi	a1,s0,-112
    171c:	00004517          	auipc	a0,0x4
    1720:	84c50513          	addi	a0,a0,-1972 # 4f68 <malloc+0x9cc>
    1724:	00003097          	auipc	ra,0x3
    1728:	dba080e7          	jalr	-582(ra) # 44de <printf>
        exit(-1);
    172c:	557d                	li	a0,-1
    172e:	00003097          	auipc	ra,0x3
    1732:	a18080e7          	jalr	-1512(ra) # 4146 <exit>
  for(i = 0; i < N; i++){
    1736:	2905                	addiw	s2,s2,1
    1738:	2a05                	addiw	s4,s4,1
    173a:	2985                	addiw	s3,s3,1
    173c:	0ff9f993          	andi	s3,s3,255
    1740:	47d1                	li	a5,20
    1742:	02f90a63          	beq	s2,a5,1776 <createdelete+0x204>
  for(pi = 0; pi < NCHILD; pi++){
    1746:	84e2                	mv	s1,s8
    1748:	bf71                	j	16e4 <createdelete+0x172>
    }
  }

  for(i = 0; i < N; i++){
    174a:	2905                	addiw	s2,s2,1
    174c:	0ff97913          	andi	s2,s2,255
    1750:	2985                	addiw	s3,s3,1
    1752:	0ff9f993          	andi	s3,s3,255
    1756:	03490863          	beq	s2,s4,1786 <createdelete+0x214>
  for(i = 0; i < N; i++){
    175a:	84d6                	mv	s1,s5
    for(pi = 0; pi < NCHILD; pi++){
      name[0] = 'p' + i;
    175c:	f9240823          	sb	s2,-112(s0)
      name[1] = '0' + i;
    1760:	f93408a3          	sb	s3,-111(s0)
      unlink(name);
    1764:	f9040513          	addi	a0,s0,-112
    1768:	00003097          	auipc	ra,0x3
    176c:	a2e080e7          	jalr	-1490(ra) # 4196 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1770:	34fd                	addiw	s1,s1,-1
    1772:	f4ed                	bnez	s1,175c <createdelete+0x1ea>
    1774:	bfd9                	j	174a <createdelete+0x1d8>
    1776:	03000993          	li	s3,48
    177a:	07000913          	li	s2,112
  for(i = 0; i < N; i++){
    177e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1780:	08400a13          	li	s4,132
    1784:	bfd9                	j	175a <createdelete+0x1e8>
    }
  }

  printf("createdelete ok\n");
    1786:	00004517          	auipc	a0,0x4
    178a:	80250513          	addi	a0,a0,-2046 # 4f88 <malloc+0x9ec>
    178e:	00003097          	auipc	ra,0x3
    1792:	d50080e7          	jalr	-688(ra) # 44de <printf>
}
    1796:	70a6                	ld	ra,104(sp)
    1798:	7406                	ld	s0,96(sp)
    179a:	64e6                	ld	s1,88(sp)
    179c:	6946                	ld	s2,80(sp)
    179e:	69a6                	ld	s3,72(sp)
    17a0:	6a06                	ld	s4,64(sp)
    17a2:	7ae2                	ld	s5,56(sp)
    17a4:	7b42                	ld	s6,48(sp)
    17a6:	7ba2                	ld	s7,40(sp)
    17a8:	7c02                	ld	s8,32(sp)
    17aa:	6165                	addi	sp,sp,112
    17ac:	8082                	ret

00000000000017ae <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    17ae:	1101                	addi	sp,sp,-32
    17b0:	ec06                	sd	ra,24(sp)
    17b2:	e822                	sd	s0,16(sp)
    17b4:	e426                	sd	s1,8(sp)
    17b6:	e04a                	sd	s2,0(sp)
    17b8:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd, fd1;

  printf("unlinkread test\n");
    17ba:	00003517          	auipc	a0,0x3
    17be:	7e650513          	addi	a0,a0,2022 # 4fa0 <malloc+0xa04>
    17c2:	00003097          	auipc	ra,0x3
    17c6:	d1c080e7          	jalr	-740(ra) # 44de <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    17ca:	20200593          	li	a1,514
    17ce:	00003517          	auipc	a0,0x3
    17d2:	7ea50513          	addi	a0,a0,2026 # 4fb8 <malloc+0xa1c>
    17d6:	00003097          	auipc	ra,0x3
    17da:	9b0080e7          	jalr	-1616(ra) # 4186 <open>
  if(fd < 0){
    17de:	0e054c63          	bltz	a0,18d6 <unlinkread+0x128>
    17e2:	84aa                	mv	s1,a0
    printf("create unlinkread failed\n");
    exit(-1);
  }
  write(fd, "hello", SZ);
    17e4:	4615                	li	a2,5
    17e6:	00004597          	auipc	a1,0x4
    17ea:	80258593          	addi	a1,a1,-2046 # 4fe8 <malloc+0xa4c>
    17ee:	00003097          	auipc	ra,0x3
    17f2:	978080e7          	jalr	-1672(ra) # 4166 <write>
  close(fd);
    17f6:	8526                	mv	a0,s1
    17f8:	00003097          	auipc	ra,0x3
    17fc:	976080e7          	jalr	-1674(ra) # 416e <close>

  fd = open("unlinkread", O_RDWR);
    1800:	4589                	li	a1,2
    1802:	00003517          	auipc	a0,0x3
    1806:	7b650513          	addi	a0,a0,1974 # 4fb8 <malloc+0xa1c>
    180a:	00003097          	auipc	ra,0x3
    180e:	97c080e7          	jalr	-1668(ra) # 4186 <open>
    1812:	84aa                	mv	s1,a0
  if(fd < 0){
    1814:	0c054e63          	bltz	a0,18f0 <unlinkread+0x142>
    printf("open unlinkread failed\n");
    exit(-1);
  }
  if(unlink("unlinkread") != 0){
    1818:	00003517          	auipc	a0,0x3
    181c:	7a050513          	addi	a0,a0,1952 # 4fb8 <malloc+0xa1c>
    1820:	00003097          	auipc	ra,0x3
    1824:	976080e7          	jalr	-1674(ra) # 4196 <unlink>
    1828:	e16d                	bnez	a0,190a <unlinkread+0x15c>
    printf("unlink unlinkread failed\n");
    exit(-1);
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    182a:	20200593          	li	a1,514
    182e:	00003517          	auipc	a0,0x3
    1832:	78a50513          	addi	a0,a0,1930 # 4fb8 <malloc+0xa1c>
    1836:	00003097          	auipc	ra,0x3
    183a:	950080e7          	jalr	-1712(ra) # 4186 <open>
    183e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1840:	460d                	li	a2,3
    1842:	00003597          	auipc	a1,0x3
    1846:	7e658593          	addi	a1,a1,2022 # 5028 <malloc+0xa8c>
    184a:	00003097          	auipc	ra,0x3
    184e:	91c080e7          	jalr	-1764(ra) # 4166 <write>
  close(fd1);
    1852:	854a                	mv	a0,s2
    1854:	00003097          	auipc	ra,0x3
    1858:	91a080e7          	jalr	-1766(ra) # 416e <close>

  if(read(fd, buf, sizeof(buf)) != SZ){
    185c:	660d                	lui	a2,0x3
    185e:	00007597          	auipc	a1,0x7
    1862:	42a58593          	addi	a1,a1,1066 # 8c88 <buf>
    1866:	8526                	mv	a0,s1
    1868:	00003097          	auipc	ra,0x3
    186c:	8f6080e7          	jalr	-1802(ra) # 415e <read>
    1870:	4795                	li	a5,5
    1872:	0af51963          	bne	a0,a5,1924 <unlinkread+0x176>
    printf("unlinkread read failed");
    exit(-1);
  }
  if(buf[0] != 'h'){
    1876:	00007717          	auipc	a4,0x7
    187a:	41274703          	lbu	a4,1042(a4) # 8c88 <buf>
    187e:	06800793          	li	a5,104
    1882:	0af71e63          	bne	a4,a5,193e <unlinkread+0x190>
    printf("unlinkread wrong data\n");
    exit(-1);
  }
  if(write(fd, buf, 10) != 10){
    1886:	4629                	li	a2,10
    1888:	00007597          	auipc	a1,0x7
    188c:	40058593          	addi	a1,a1,1024 # 8c88 <buf>
    1890:	8526                	mv	a0,s1
    1892:	00003097          	auipc	ra,0x3
    1896:	8d4080e7          	jalr	-1836(ra) # 4166 <write>
    189a:	47a9                	li	a5,10
    189c:	0af51e63          	bne	a0,a5,1958 <unlinkread+0x1aa>
    printf("unlinkread write failed\n");
    exit(-1);
  }
  close(fd);
    18a0:	8526                	mv	a0,s1
    18a2:	00003097          	auipc	ra,0x3
    18a6:	8cc080e7          	jalr	-1844(ra) # 416e <close>
  unlink("unlinkread");
    18aa:	00003517          	auipc	a0,0x3
    18ae:	70e50513          	addi	a0,a0,1806 # 4fb8 <malloc+0xa1c>
    18b2:	00003097          	auipc	ra,0x3
    18b6:	8e4080e7          	jalr	-1820(ra) # 4196 <unlink>
  printf("unlinkread ok\n");
    18ba:	00003517          	auipc	a0,0x3
    18be:	7c650513          	addi	a0,a0,1990 # 5080 <malloc+0xae4>
    18c2:	00003097          	auipc	ra,0x3
    18c6:	c1c080e7          	jalr	-996(ra) # 44de <printf>
}
    18ca:	60e2                	ld	ra,24(sp)
    18cc:	6442                	ld	s0,16(sp)
    18ce:	64a2                	ld	s1,8(sp)
    18d0:	6902                	ld	s2,0(sp)
    18d2:	6105                	addi	sp,sp,32
    18d4:	8082                	ret
    printf("create unlinkread failed\n");
    18d6:	00003517          	auipc	a0,0x3
    18da:	6f250513          	addi	a0,a0,1778 # 4fc8 <malloc+0xa2c>
    18de:	00003097          	auipc	ra,0x3
    18e2:	c00080e7          	jalr	-1024(ra) # 44de <printf>
    exit(-1);
    18e6:	557d                	li	a0,-1
    18e8:	00003097          	auipc	ra,0x3
    18ec:	85e080e7          	jalr	-1954(ra) # 4146 <exit>
    printf("open unlinkread failed\n");
    18f0:	00003517          	auipc	a0,0x3
    18f4:	70050513          	addi	a0,a0,1792 # 4ff0 <malloc+0xa54>
    18f8:	00003097          	auipc	ra,0x3
    18fc:	be6080e7          	jalr	-1050(ra) # 44de <printf>
    exit(-1);
    1900:	557d                	li	a0,-1
    1902:	00003097          	auipc	ra,0x3
    1906:	844080e7          	jalr	-1980(ra) # 4146 <exit>
    printf("unlink unlinkread failed\n");
    190a:	00003517          	auipc	a0,0x3
    190e:	6fe50513          	addi	a0,a0,1790 # 5008 <malloc+0xa6c>
    1912:	00003097          	auipc	ra,0x3
    1916:	bcc080e7          	jalr	-1076(ra) # 44de <printf>
    exit(-1);
    191a:	557d                	li	a0,-1
    191c:	00003097          	auipc	ra,0x3
    1920:	82a080e7          	jalr	-2006(ra) # 4146 <exit>
    printf("unlinkread read failed");
    1924:	00003517          	auipc	a0,0x3
    1928:	70c50513          	addi	a0,a0,1804 # 5030 <malloc+0xa94>
    192c:	00003097          	auipc	ra,0x3
    1930:	bb2080e7          	jalr	-1102(ra) # 44de <printf>
    exit(-1);
    1934:	557d                	li	a0,-1
    1936:	00003097          	auipc	ra,0x3
    193a:	810080e7          	jalr	-2032(ra) # 4146 <exit>
    printf("unlinkread wrong data\n");
    193e:	00003517          	auipc	a0,0x3
    1942:	70a50513          	addi	a0,a0,1802 # 5048 <malloc+0xaac>
    1946:	00003097          	auipc	ra,0x3
    194a:	b98080e7          	jalr	-1128(ra) # 44de <printf>
    exit(-1);
    194e:	557d                	li	a0,-1
    1950:	00002097          	auipc	ra,0x2
    1954:	7f6080e7          	jalr	2038(ra) # 4146 <exit>
    printf("unlinkread write failed\n");
    1958:	00003517          	auipc	a0,0x3
    195c:	70850513          	addi	a0,a0,1800 # 5060 <malloc+0xac4>
    1960:	00003097          	auipc	ra,0x3
    1964:	b7e080e7          	jalr	-1154(ra) # 44de <printf>
    exit(-1);
    1968:	557d                	li	a0,-1
    196a:	00002097          	auipc	ra,0x2
    196e:	7dc080e7          	jalr	2012(ra) # 4146 <exit>

0000000000001972 <linktest>:

void
linktest(void)
{
    1972:	1101                	addi	sp,sp,-32
    1974:	ec06                	sd	ra,24(sp)
    1976:	e822                	sd	s0,16(sp)
    1978:	e426                	sd	s1,8(sp)
    197a:	1000                	addi	s0,sp,32
  enum { SZ = 5 };
  int fd;

  printf("linktest\n");
    197c:	00003517          	auipc	a0,0x3
    1980:	71450513          	addi	a0,a0,1812 # 5090 <malloc+0xaf4>
    1984:	00003097          	auipc	ra,0x3
    1988:	b5a080e7          	jalr	-1190(ra) # 44de <printf>

  unlink("lf1");
    198c:	00003517          	auipc	a0,0x3
    1990:	71450513          	addi	a0,a0,1812 # 50a0 <malloc+0xb04>
    1994:	00003097          	auipc	ra,0x3
    1998:	802080e7          	jalr	-2046(ra) # 4196 <unlink>
  unlink("lf2");
    199c:	00003517          	auipc	a0,0x3
    19a0:	70c50513          	addi	a0,a0,1804 # 50a8 <malloc+0xb0c>
    19a4:	00002097          	auipc	ra,0x2
    19a8:	7f2080e7          	jalr	2034(ra) # 4196 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    19ac:	20200593          	li	a1,514
    19b0:	00003517          	auipc	a0,0x3
    19b4:	6f050513          	addi	a0,a0,1776 # 50a0 <malloc+0xb04>
    19b8:	00002097          	auipc	ra,0x2
    19bc:	7ce080e7          	jalr	1998(ra) # 4186 <open>
  if(fd < 0){
    19c0:	10054e63          	bltz	a0,1adc <linktest+0x16a>
    19c4:	84aa                	mv	s1,a0
    printf("create lf1 failed\n");
    exit(-1);
  }
  if(write(fd, "hello", SZ) != SZ){
    19c6:	4615                	li	a2,5
    19c8:	00003597          	auipc	a1,0x3
    19cc:	62058593          	addi	a1,a1,1568 # 4fe8 <malloc+0xa4c>
    19d0:	00002097          	auipc	ra,0x2
    19d4:	796080e7          	jalr	1942(ra) # 4166 <write>
    19d8:	4795                	li	a5,5
    19da:	10f51e63          	bne	a0,a5,1af6 <linktest+0x184>
    printf("write lf1 failed\n");
    exit(-1);
  }
  close(fd);
    19de:	8526                	mv	a0,s1
    19e0:	00002097          	auipc	ra,0x2
    19e4:	78e080e7          	jalr	1934(ra) # 416e <close>

  if(link("lf1", "lf2") < 0){
    19e8:	00003597          	auipc	a1,0x3
    19ec:	6c058593          	addi	a1,a1,1728 # 50a8 <malloc+0xb0c>
    19f0:	00003517          	auipc	a0,0x3
    19f4:	6b050513          	addi	a0,a0,1712 # 50a0 <malloc+0xb04>
    19f8:	00002097          	auipc	ra,0x2
    19fc:	7ae080e7          	jalr	1966(ra) # 41a6 <link>
    1a00:	10054863          	bltz	a0,1b10 <linktest+0x19e>
    printf("link lf1 lf2 failed\n");
    exit(-1);
  }
  unlink("lf1");
    1a04:	00003517          	auipc	a0,0x3
    1a08:	69c50513          	addi	a0,a0,1692 # 50a0 <malloc+0xb04>
    1a0c:	00002097          	auipc	ra,0x2
    1a10:	78a080e7          	jalr	1930(ra) # 4196 <unlink>

  if(open("lf1", 0) >= 0){
    1a14:	4581                	li	a1,0
    1a16:	00003517          	auipc	a0,0x3
    1a1a:	68a50513          	addi	a0,a0,1674 # 50a0 <malloc+0xb04>
    1a1e:	00002097          	auipc	ra,0x2
    1a22:	768080e7          	jalr	1896(ra) # 4186 <open>
    1a26:	10055263          	bgez	a0,1b2a <linktest+0x1b8>
    printf("unlinked lf1 but it is still there!\n");
    exit(-1);
  }

  fd = open("lf2", 0);
    1a2a:	4581                	li	a1,0
    1a2c:	00003517          	auipc	a0,0x3
    1a30:	67c50513          	addi	a0,a0,1660 # 50a8 <malloc+0xb0c>
    1a34:	00002097          	auipc	ra,0x2
    1a38:	752080e7          	jalr	1874(ra) # 4186 <open>
    1a3c:	84aa                	mv	s1,a0
  if(fd < 0){
    1a3e:	10054363          	bltz	a0,1b44 <linktest+0x1d2>
    printf("open lf2 failed\n");
    exit(-1);
  }
  if(read(fd, buf, sizeof(buf)) != SZ){
    1a42:	660d                	lui	a2,0x3
    1a44:	00007597          	auipc	a1,0x7
    1a48:	24458593          	addi	a1,a1,580 # 8c88 <buf>
    1a4c:	00002097          	auipc	ra,0x2
    1a50:	712080e7          	jalr	1810(ra) # 415e <read>
    1a54:	4795                	li	a5,5
    1a56:	10f51463          	bne	a0,a5,1b5e <linktest+0x1ec>
    printf("read lf2 failed\n");
    exit(-1);
  }
  close(fd);
    1a5a:	8526                	mv	a0,s1
    1a5c:	00002097          	auipc	ra,0x2
    1a60:	712080e7          	jalr	1810(ra) # 416e <close>

  if(link("lf2", "lf2") >= 0){
    1a64:	00003597          	auipc	a1,0x3
    1a68:	64458593          	addi	a1,a1,1604 # 50a8 <malloc+0xb0c>
    1a6c:	852e                	mv	a0,a1
    1a6e:	00002097          	auipc	ra,0x2
    1a72:	738080e7          	jalr	1848(ra) # 41a6 <link>
    1a76:	10055163          	bgez	a0,1b78 <linktest+0x206>
    printf("link lf2 lf2 succeeded! oops\n");
    exit(-1);
  }

  unlink("lf2");
    1a7a:	00003517          	auipc	a0,0x3
    1a7e:	62e50513          	addi	a0,a0,1582 # 50a8 <malloc+0xb0c>
    1a82:	00002097          	auipc	ra,0x2
    1a86:	714080e7          	jalr	1812(ra) # 4196 <unlink>
  if(link("lf2", "lf1") >= 0){
    1a8a:	00003597          	auipc	a1,0x3
    1a8e:	61658593          	addi	a1,a1,1558 # 50a0 <malloc+0xb04>
    1a92:	00003517          	auipc	a0,0x3
    1a96:	61650513          	addi	a0,a0,1558 # 50a8 <malloc+0xb0c>
    1a9a:	00002097          	auipc	ra,0x2
    1a9e:	70c080e7          	jalr	1804(ra) # 41a6 <link>
    1aa2:	0e055863          	bgez	a0,1b92 <linktest+0x220>
    printf("link non-existant succeeded! oops\n");
    exit(-1);
  }

  if(link(".", "lf1") >= 0){
    1aa6:	00003597          	auipc	a1,0x3
    1aaa:	5fa58593          	addi	a1,a1,1530 # 50a0 <malloc+0xb04>
    1aae:	00003517          	auipc	a0,0x3
    1ab2:	6ea50513          	addi	a0,a0,1770 # 5198 <malloc+0xbfc>
    1ab6:	00002097          	auipc	ra,0x2
    1aba:	6f0080e7          	jalr	1776(ra) # 41a6 <link>
    1abe:	0e055763          	bgez	a0,1bac <linktest+0x23a>
    printf("link . lf1 succeeded! oops\n");
    exit(-1);
  }

  printf("linktest ok\n");
    1ac2:	00003517          	auipc	a0,0x3
    1ac6:	6fe50513          	addi	a0,a0,1790 # 51c0 <malloc+0xc24>
    1aca:	00003097          	auipc	ra,0x3
    1ace:	a14080e7          	jalr	-1516(ra) # 44de <printf>
}
    1ad2:	60e2                	ld	ra,24(sp)
    1ad4:	6442                	ld	s0,16(sp)
    1ad6:	64a2                	ld	s1,8(sp)
    1ad8:	6105                	addi	sp,sp,32
    1ada:	8082                	ret
    printf("create lf1 failed\n");
    1adc:	00003517          	auipc	a0,0x3
    1ae0:	5d450513          	addi	a0,a0,1492 # 50b0 <malloc+0xb14>
    1ae4:	00003097          	auipc	ra,0x3
    1ae8:	9fa080e7          	jalr	-1542(ra) # 44de <printf>
    exit(-1);
    1aec:	557d                	li	a0,-1
    1aee:	00002097          	auipc	ra,0x2
    1af2:	658080e7          	jalr	1624(ra) # 4146 <exit>
    printf("write lf1 failed\n");
    1af6:	00003517          	auipc	a0,0x3
    1afa:	5d250513          	addi	a0,a0,1490 # 50c8 <malloc+0xb2c>
    1afe:	00003097          	auipc	ra,0x3
    1b02:	9e0080e7          	jalr	-1568(ra) # 44de <printf>
    exit(-1);
    1b06:	557d                	li	a0,-1
    1b08:	00002097          	auipc	ra,0x2
    1b0c:	63e080e7          	jalr	1598(ra) # 4146 <exit>
    printf("link lf1 lf2 failed\n");
    1b10:	00003517          	auipc	a0,0x3
    1b14:	5d050513          	addi	a0,a0,1488 # 50e0 <malloc+0xb44>
    1b18:	00003097          	auipc	ra,0x3
    1b1c:	9c6080e7          	jalr	-1594(ra) # 44de <printf>
    exit(-1);
    1b20:	557d                	li	a0,-1
    1b22:	00002097          	auipc	ra,0x2
    1b26:	624080e7          	jalr	1572(ra) # 4146 <exit>
    printf("unlinked lf1 but it is still there!\n");
    1b2a:	00003517          	auipc	a0,0x3
    1b2e:	5ce50513          	addi	a0,a0,1486 # 50f8 <malloc+0xb5c>
    1b32:	00003097          	auipc	ra,0x3
    1b36:	9ac080e7          	jalr	-1620(ra) # 44de <printf>
    exit(-1);
    1b3a:	557d                	li	a0,-1
    1b3c:	00002097          	auipc	ra,0x2
    1b40:	60a080e7          	jalr	1546(ra) # 4146 <exit>
    printf("open lf2 failed\n");
    1b44:	00003517          	auipc	a0,0x3
    1b48:	5dc50513          	addi	a0,a0,1500 # 5120 <malloc+0xb84>
    1b4c:	00003097          	auipc	ra,0x3
    1b50:	992080e7          	jalr	-1646(ra) # 44de <printf>
    exit(-1);
    1b54:	557d                	li	a0,-1
    1b56:	00002097          	auipc	ra,0x2
    1b5a:	5f0080e7          	jalr	1520(ra) # 4146 <exit>
    printf("read lf2 failed\n");
    1b5e:	00003517          	auipc	a0,0x3
    1b62:	5da50513          	addi	a0,a0,1498 # 5138 <malloc+0xb9c>
    1b66:	00003097          	auipc	ra,0x3
    1b6a:	978080e7          	jalr	-1672(ra) # 44de <printf>
    exit(-1);
    1b6e:	557d                	li	a0,-1
    1b70:	00002097          	auipc	ra,0x2
    1b74:	5d6080e7          	jalr	1494(ra) # 4146 <exit>
    printf("link lf2 lf2 succeeded! oops\n");
    1b78:	00003517          	auipc	a0,0x3
    1b7c:	5d850513          	addi	a0,a0,1496 # 5150 <malloc+0xbb4>
    1b80:	00003097          	auipc	ra,0x3
    1b84:	95e080e7          	jalr	-1698(ra) # 44de <printf>
    exit(-1);
    1b88:	557d                	li	a0,-1
    1b8a:	00002097          	auipc	ra,0x2
    1b8e:	5bc080e7          	jalr	1468(ra) # 4146 <exit>
    printf("link non-existant succeeded! oops\n");
    1b92:	00003517          	auipc	a0,0x3
    1b96:	5de50513          	addi	a0,a0,1502 # 5170 <malloc+0xbd4>
    1b9a:	00003097          	auipc	ra,0x3
    1b9e:	944080e7          	jalr	-1724(ra) # 44de <printf>
    exit(-1);
    1ba2:	557d                	li	a0,-1
    1ba4:	00002097          	auipc	ra,0x2
    1ba8:	5a2080e7          	jalr	1442(ra) # 4146 <exit>
    printf("link . lf1 succeeded! oops\n");
    1bac:	00003517          	auipc	a0,0x3
    1bb0:	5f450513          	addi	a0,a0,1524 # 51a0 <malloc+0xc04>
    1bb4:	00003097          	auipc	ra,0x3
    1bb8:	92a080e7          	jalr	-1750(ra) # 44de <printf>
    exit(-1);
    1bbc:	557d                	li	a0,-1
    1bbe:	00002097          	auipc	ra,0x2
    1bc2:	588080e7          	jalr	1416(ra) # 4146 <exit>

0000000000001bc6 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1bc6:	7119                	addi	sp,sp,-128
    1bc8:	fc86                	sd	ra,120(sp)
    1bca:	f8a2                	sd	s0,112(sp)
    1bcc:	f4a6                	sd	s1,104(sp)
    1bce:	f0ca                	sd	s2,96(sp)
    1bd0:	ecce                	sd	s3,88(sp)
    1bd2:	e8d2                	sd	s4,80(sp)
    1bd4:	e4d6                	sd	s5,72(sp)
    1bd6:	0100                	addi	s0,sp,128
  struct {
    ushort inum;
    char name[DIRSIZ];
  } de;

  printf("concreate test\n");
    1bd8:	00003517          	auipc	a0,0x3
    1bdc:	5f850513          	addi	a0,a0,1528 # 51d0 <malloc+0xc34>
    1be0:	00003097          	auipc	ra,0x3
    1be4:	8fe080e7          	jalr	-1794(ra) # 44de <printf>
  file[0] = 'C';
    1be8:	04300793          	li	a5,67
    1bec:	faf40c23          	sb	a5,-72(s0)
  file[2] = '\0';
    1bf0:	fa040d23          	sb	zero,-70(s0)
  for(i = 0; i < N; i++){
    1bf4:	4481                	li	s1,0
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    1bf6:	4a0d                	li	s4,3
    1bf8:	4985                	li	s3,1
      link("C0", file);
    1bfa:	00003a97          	auipc	s5,0x3
    1bfe:	5e6a8a93          	addi	s5,s5,1510 # 51e0 <malloc+0xc44>
  for(i = 0; i < N; i++){
    1c02:	02800913          	li	s2,40
    1c06:	ac49                	j	1e98 <concreate+0x2d2>
      link("C0", file);
    1c08:	fb840593          	addi	a1,s0,-72
    1c0c:	8556                	mv	a0,s5
    1c0e:	00002097          	auipc	ra,0x2
    1c12:	598080e7          	jalr	1432(ra) # 41a6 <link>
        printf("concreate create %s failed\n", file);
        exit(-1);
      }
      close(fd);
    }
    if(pid == 0)
    1c16:	ac8d                	j	1e88 <concreate+0x2c2>
    } else if(pid == 0 && (i % 5) == 1){
    1c18:	4795                	li	a5,5
    1c1a:	02f4e4bb          	remw	s1,s1,a5
    1c1e:	4785                	li	a5,1
    1c20:	02f48b63          	beq	s1,a5,1c56 <concreate+0x90>
      fd = open(file, O_CREATE | O_RDWR);
    1c24:	20200593          	li	a1,514
    1c28:	fb840513          	addi	a0,s0,-72
    1c2c:	00002097          	auipc	ra,0x2
    1c30:	55a080e7          	jalr	1370(ra) # 4186 <open>
      if(fd < 0){
    1c34:	24055163          	bgez	a0,1e76 <concreate+0x2b0>
        printf("concreate create %s failed\n", file);
    1c38:	fb840593          	addi	a1,s0,-72
    1c3c:	00003517          	auipc	a0,0x3
    1c40:	5ac50513          	addi	a0,a0,1452 # 51e8 <malloc+0xc4c>
    1c44:	00003097          	auipc	ra,0x3
    1c48:	89a080e7          	jalr	-1894(ra) # 44de <printf>
        exit(-1);
    1c4c:	557d                	li	a0,-1
    1c4e:	00002097          	auipc	ra,0x2
    1c52:	4f8080e7          	jalr	1272(ra) # 4146 <exit>
      link("C0", file);
    1c56:	fb840593          	addi	a1,s0,-72
    1c5a:	00003517          	auipc	a0,0x3
    1c5e:	58650513          	addi	a0,a0,1414 # 51e0 <malloc+0xc44>
    1c62:	00002097          	auipc	ra,0x2
    1c66:	544080e7          	jalr	1348(ra) # 41a6 <link>
      exit(0);
    1c6a:	4501                	li	a0,0
    1c6c:	00002097          	auipc	ra,0x2
    1c70:	4da080e7          	jalr	1242(ra) # 4146 <exit>
    else
      wait(0);
  }

  memset(fa, 0, sizeof(fa));
    1c74:	02800613          	li	a2,40
    1c78:	4581                	li	a1,0
    1c7a:	f9040513          	addi	a0,s0,-112
    1c7e:	00002097          	auipc	ra,0x2
    1c82:	34c080e7          	jalr	844(ra) # 3fca <memset>
  fd = open(".", 0);
    1c86:	4581                	li	a1,0
    1c88:	00003517          	auipc	a0,0x3
    1c8c:	51050513          	addi	a0,a0,1296 # 5198 <malloc+0xbfc>
    1c90:	00002097          	auipc	ra,0x2
    1c94:	4f6080e7          	jalr	1270(ra) # 4186 <open>
    1c98:	84aa                	mv	s1,a0
  n = 0;
    1c9a:	4981                	li	s3,0
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1c9c:	04300913          	li	s2,67
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
    1ca0:	02700a13          	li	s4,39
      }
      if(fa[i]){
        printf("concreate duplicate file %s\n", de.name);
        exit(-1);
      }
      fa[i] = 1;
    1ca4:	4a85                	li	s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    1ca6:	4641                	li	a2,16
    1ca8:	f8040593          	addi	a1,s0,-128
    1cac:	8526                	mv	a0,s1
    1cae:	00002097          	auipc	ra,0x2
    1cb2:	4b0080e7          	jalr	1200(ra) # 415e <read>
    1cb6:	06a05f63          	blez	a0,1d34 <concreate+0x16e>
    if(de.inum == 0)
    1cba:	f8045783          	lhu	a5,-128(s0)
    1cbe:	d7e5                	beqz	a5,1ca6 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1cc0:	f8244783          	lbu	a5,-126(s0)
    1cc4:	ff2791e3          	bne	a5,s2,1ca6 <concreate+0xe0>
    1cc8:	f8444783          	lbu	a5,-124(s0)
    1ccc:	ffe9                	bnez	a5,1ca6 <concreate+0xe0>
      i = de.name[1] - '0';
    1cce:	f8344783          	lbu	a5,-125(s0)
    1cd2:	fd07879b          	addiw	a5,a5,-48
    1cd6:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    1cda:	00ea6f63          	bltu	s4,a4,1cf8 <concreate+0x132>
      if(fa[i]){
    1cde:	fc040793          	addi	a5,s0,-64
    1ce2:	97ba                	add	a5,a5,a4
    1ce4:	fd07c783          	lbu	a5,-48(a5)
    1ce8:	e79d                	bnez	a5,1d16 <concreate+0x150>
      fa[i] = 1;
    1cea:	fc040793          	addi	a5,s0,-64
    1cee:	973e                	add	a4,a4,a5
    1cf0:	fd570823          	sb	s5,-48(a4)
      n++;
    1cf4:	2985                	addiw	s3,s3,1
    1cf6:	bf45                	j	1ca6 <concreate+0xe0>
        printf("concreate weird file %s\n", de.name);
    1cf8:	f8240593          	addi	a1,s0,-126
    1cfc:	00003517          	auipc	a0,0x3
    1d00:	50c50513          	addi	a0,a0,1292 # 5208 <malloc+0xc6c>
    1d04:	00002097          	auipc	ra,0x2
    1d08:	7da080e7          	jalr	2010(ra) # 44de <printf>
        exit(-1);
    1d0c:	557d                	li	a0,-1
    1d0e:	00002097          	auipc	ra,0x2
    1d12:	438080e7          	jalr	1080(ra) # 4146 <exit>
        printf("concreate duplicate file %s\n", de.name);
    1d16:	f8240593          	addi	a1,s0,-126
    1d1a:	00003517          	auipc	a0,0x3
    1d1e:	50e50513          	addi	a0,a0,1294 # 5228 <malloc+0xc8c>
    1d22:	00002097          	auipc	ra,0x2
    1d26:	7bc080e7          	jalr	1980(ra) # 44de <printf>
        exit(-1);
    1d2a:	557d                	li	a0,-1
    1d2c:	00002097          	auipc	ra,0x2
    1d30:	41a080e7          	jalr	1050(ra) # 4146 <exit>
    }
  }
  close(fd);
    1d34:	8526                	mv	a0,s1
    1d36:	00002097          	auipc	ra,0x2
    1d3a:	438080e7          	jalr	1080(ra) # 416e <close>

  if(n != N){
    1d3e:	02800793          	li	a5,40
    printf("concreate not enough files in directory listing\n");
    exit(-1);
  }

  for(i = 0; i < N; i++){
    1d42:	4901                	li	s2,0
  if(n != N){
    1d44:	00f99763          	bne	s3,a5,1d52 <concreate+0x18c>
    pid = fork();
    if(pid < 0){
      printf("fork failed\n");
      exit(-1);
    }
    if(((i % 3) == 0 && pid == 0) ||
    1d48:	4a0d                	li	s4,3
    1d4a:	4a85                	li	s5,1
  for(i = 0; i < N; i++){
    1d4c:	02800993          	li	s3,40
    1d50:	a045                	j	1df0 <concreate+0x22a>
    printf("concreate not enough files in directory listing\n");
    1d52:	00003517          	auipc	a0,0x3
    1d56:	4f650513          	addi	a0,a0,1270 # 5248 <malloc+0xcac>
    1d5a:	00002097          	auipc	ra,0x2
    1d5e:	784080e7          	jalr	1924(ra) # 44de <printf>
    exit(-1);
    1d62:	557d                	li	a0,-1
    1d64:	00002097          	auipc	ra,0x2
    1d68:	3e2080e7          	jalr	994(ra) # 4146 <exit>
      printf("fork failed\n");
    1d6c:	00003517          	auipc	a0,0x3
    1d70:	9e450513          	addi	a0,a0,-1564 # 4750 <malloc+0x1b4>
    1d74:	00002097          	auipc	ra,0x2
    1d78:	76a080e7          	jalr	1898(ra) # 44de <printf>
      exit(-1);
    1d7c:	557d                	li	a0,-1
    1d7e:	00002097          	auipc	ra,0x2
    1d82:	3c8080e7          	jalr	968(ra) # 4146 <exit>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1d86:	4581                	li	a1,0
    1d88:	fb840513          	addi	a0,s0,-72
    1d8c:	00002097          	auipc	ra,0x2
    1d90:	3fa080e7          	jalr	1018(ra) # 4186 <open>
    1d94:	00002097          	auipc	ra,0x2
    1d98:	3da080e7          	jalr	986(ra) # 416e <close>
      close(open(file, 0));
    1d9c:	4581                	li	a1,0
    1d9e:	fb840513          	addi	a0,s0,-72
    1da2:	00002097          	auipc	ra,0x2
    1da6:	3e4080e7          	jalr	996(ra) # 4186 <open>
    1daa:	00002097          	auipc	ra,0x2
    1dae:	3c4080e7          	jalr	964(ra) # 416e <close>
      close(open(file, 0));
    1db2:	4581                	li	a1,0
    1db4:	fb840513          	addi	a0,s0,-72
    1db8:	00002097          	auipc	ra,0x2
    1dbc:	3ce080e7          	jalr	974(ra) # 4186 <open>
    1dc0:	00002097          	auipc	ra,0x2
    1dc4:	3ae080e7          	jalr	942(ra) # 416e <close>
      close(open(file, 0));
    1dc8:	4581                	li	a1,0
    1dca:	fb840513          	addi	a0,s0,-72
    1dce:	00002097          	auipc	ra,0x2
    1dd2:	3b8080e7          	jalr	952(ra) # 4186 <open>
    1dd6:	00002097          	auipc	ra,0x2
    1dda:	398080e7          	jalr	920(ra) # 416e <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1dde:	c4b5                	beqz	s1,1e4a <concreate+0x284>
      exit(0);
    else
      wait(0);
    1de0:	4501                	li	a0,0
    1de2:	00002097          	auipc	ra,0x2
    1de6:	36c080e7          	jalr	876(ra) # 414e <wait>
  for(i = 0; i < N; i++){
    1dea:	2905                	addiw	s2,s2,1
    1dec:	07390463          	beq	s2,s3,1e54 <concreate+0x28e>
    file[1] = '0' + i;
    1df0:	0309079b          	addiw	a5,s2,48
    1df4:	faf40ca3          	sb	a5,-71(s0)
    pid = fork();
    1df8:	00002097          	auipc	ra,0x2
    1dfc:	346080e7          	jalr	838(ra) # 413e <fork>
    1e00:	84aa                	mv	s1,a0
    if(pid < 0){
    1e02:	f60545e3          	bltz	a0,1d6c <concreate+0x1a6>
    if(((i % 3) == 0 && pid == 0) ||
    1e06:	0349673b          	remw	a4,s2,s4
    1e0a:	00a767b3          	or	a5,a4,a0
    1e0e:	2781                	sext.w	a5,a5
    1e10:	dbbd                	beqz	a5,1d86 <concreate+0x1c0>
    1e12:	01571363          	bne	a4,s5,1e18 <concreate+0x252>
       ((i % 3) == 1 && pid != 0)){
    1e16:	f925                	bnez	a0,1d86 <concreate+0x1c0>
      unlink(file);
    1e18:	fb840513          	addi	a0,s0,-72
    1e1c:	00002097          	auipc	ra,0x2
    1e20:	37a080e7          	jalr	890(ra) # 4196 <unlink>
      unlink(file);
    1e24:	fb840513          	addi	a0,s0,-72
    1e28:	00002097          	auipc	ra,0x2
    1e2c:	36e080e7          	jalr	878(ra) # 4196 <unlink>
      unlink(file);
    1e30:	fb840513          	addi	a0,s0,-72
    1e34:	00002097          	auipc	ra,0x2
    1e38:	362080e7          	jalr	866(ra) # 4196 <unlink>
      unlink(file);
    1e3c:	fb840513          	addi	a0,s0,-72
    1e40:	00002097          	auipc	ra,0x2
    1e44:	356080e7          	jalr	854(ra) # 4196 <unlink>
    1e48:	bf59                	j	1dde <concreate+0x218>
      exit(0);
    1e4a:	4501                	li	a0,0
    1e4c:	00002097          	auipc	ra,0x2
    1e50:	2fa080e7          	jalr	762(ra) # 4146 <exit>
  }

  printf("concreate ok\n");
    1e54:	00003517          	auipc	a0,0x3
    1e58:	42c50513          	addi	a0,a0,1068 # 5280 <malloc+0xce4>
    1e5c:	00002097          	auipc	ra,0x2
    1e60:	682080e7          	jalr	1666(ra) # 44de <printf>
}
    1e64:	70e6                	ld	ra,120(sp)
    1e66:	7446                	ld	s0,112(sp)
    1e68:	74a6                	ld	s1,104(sp)
    1e6a:	7906                	ld	s2,96(sp)
    1e6c:	69e6                	ld	s3,88(sp)
    1e6e:	6a46                	ld	s4,80(sp)
    1e70:	6aa6                	ld	s5,72(sp)
    1e72:	6109                	addi	sp,sp,128
    1e74:	8082                	ret
      close(fd);
    1e76:	00002097          	auipc	ra,0x2
    1e7a:	2f8080e7          	jalr	760(ra) # 416e <close>
    if(pid == 0)
    1e7e:	b3f5                	j	1c6a <concreate+0xa4>
      close(fd);
    1e80:	00002097          	auipc	ra,0x2
    1e84:	2ee080e7          	jalr	750(ra) # 416e <close>
      wait(0);
    1e88:	4501                	li	a0,0
    1e8a:	00002097          	auipc	ra,0x2
    1e8e:	2c4080e7          	jalr	708(ra) # 414e <wait>
  for(i = 0; i < N; i++){
    1e92:	2485                	addiw	s1,s1,1
    1e94:	df2480e3          	beq	s1,s2,1c74 <concreate+0xae>
    file[1] = '0' + i;
    1e98:	0304879b          	addiw	a5,s1,48
    1e9c:	faf40ca3          	sb	a5,-71(s0)
    unlink(file);
    1ea0:	fb840513          	addi	a0,s0,-72
    1ea4:	00002097          	auipc	ra,0x2
    1ea8:	2f2080e7          	jalr	754(ra) # 4196 <unlink>
    pid = fork();
    1eac:	00002097          	auipc	ra,0x2
    1eb0:	292080e7          	jalr	658(ra) # 413e <fork>
    if(pid && (i % 3) == 1){
    1eb4:	d60502e3          	beqz	a0,1c18 <concreate+0x52>
    1eb8:	0344e7bb          	remw	a5,s1,s4
    1ebc:	d53786e3          	beq	a5,s3,1c08 <concreate+0x42>
      fd = open(file, O_CREATE | O_RDWR);
    1ec0:	20200593          	li	a1,514
    1ec4:	fb840513          	addi	a0,s0,-72
    1ec8:	00002097          	auipc	ra,0x2
    1ecc:	2be080e7          	jalr	702(ra) # 4186 <open>
      if(fd < 0){
    1ed0:	fa0558e3          	bgez	a0,1e80 <concreate+0x2ba>
    1ed4:	b395                	j	1c38 <concreate+0x72>

0000000000001ed6 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1ed6:	711d                	addi	sp,sp,-96
    1ed8:	ec86                	sd	ra,88(sp)
    1eda:	e8a2                	sd	s0,80(sp)
    1edc:	e4a6                	sd	s1,72(sp)
    1ede:	e0ca                	sd	s2,64(sp)
    1ee0:	fc4e                	sd	s3,56(sp)
    1ee2:	f852                	sd	s4,48(sp)
    1ee4:	f456                	sd	s5,40(sp)
    1ee6:	f05a                	sd	s6,32(sp)
    1ee8:	ec5e                	sd	s7,24(sp)
    1eea:	e862                	sd	s8,16(sp)
    1eec:	e466                	sd	s9,8(sp)
    1eee:	1080                	addi	s0,sp,96
  int pid, i;

  printf("linkunlink test\n");
    1ef0:	00003517          	auipc	a0,0x3
    1ef4:	3a050513          	addi	a0,a0,928 # 5290 <malloc+0xcf4>
    1ef8:	00002097          	auipc	ra,0x2
    1efc:	5e6080e7          	jalr	1510(ra) # 44de <printf>

  unlink("x");
    1f00:	00003517          	auipc	a0,0x3
    1f04:	d6050513          	addi	a0,a0,-672 # 4c60 <malloc+0x6c4>
    1f08:	00002097          	auipc	ra,0x2
    1f0c:	28e080e7          	jalr	654(ra) # 4196 <unlink>
  pid = fork();
    1f10:	00002097          	auipc	ra,0x2
    1f14:	22e080e7          	jalr	558(ra) # 413e <fork>
  if(pid < 0){
    1f18:	02054b63          	bltz	a0,1f4e <linkunlink+0x78>
    1f1c:	8c2a                	mv	s8,a0
    printf("fork failed\n");
    exit(-1);
  }

  unsigned int x = (pid ? 1 : 97);
    1f1e:	4c85                	li	s9,1
    1f20:	e119                	bnez	a0,1f26 <linkunlink+0x50>
    1f22:	06100c93          	li	s9,97
    1f26:	06400493          	li	s1,100
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    1f2a:	41c659b7          	lui	s3,0x41c65
    1f2e:	e6d9899b          	addiw	s3,s3,-403
    1f32:	690d                	lui	s2,0x3
    1f34:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1f38:	4a0d                	li	s4,3
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
    1f3a:	4b05                	li	s6,1
      link("cat", "x");
    } else {
      unlink("x");
    1f3c:	00003a97          	auipc	s5,0x3
    1f40:	d24a8a93          	addi	s5,s5,-732 # 4c60 <malloc+0x6c4>
      link("cat", "x");
    1f44:	00003b97          	auipc	s7,0x3
    1f48:	364b8b93          	addi	s7,s7,868 # 52a8 <malloc+0xd0c>
    1f4c:	a81d                	j	1f82 <linkunlink+0xac>
    printf("fork failed\n");
    1f4e:	00003517          	auipc	a0,0x3
    1f52:	80250513          	addi	a0,a0,-2046 # 4750 <malloc+0x1b4>
    1f56:	00002097          	auipc	ra,0x2
    1f5a:	588080e7          	jalr	1416(ra) # 44de <printf>
    exit(-1);
    1f5e:	557d                	li	a0,-1
    1f60:	00002097          	auipc	ra,0x2
    1f64:	1e6080e7          	jalr	486(ra) # 4146 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1f68:	20200593          	li	a1,514
    1f6c:	8556                	mv	a0,s5
    1f6e:	00002097          	auipc	ra,0x2
    1f72:	218080e7          	jalr	536(ra) # 4186 <open>
    1f76:	00002097          	auipc	ra,0x2
    1f7a:	1f8080e7          	jalr	504(ra) # 416e <close>
  for(i = 0; i < 100; i++){
    1f7e:	34fd                	addiw	s1,s1,-1
    1f80:	c88d                	beqz	s1,1fb2 <linkunlink+0xdc>
    x = x * 1103515245 + 12345;
    1f82:	033c87bb          	mulw	a5,s9,s3
    1f86:	012787bb          	addw	a5,a5,s2
    1f8a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1f8e:	0347f7bb          	remuw	a5,a5,s4
    1f92:	dbf9                	beqz	a5,1f68 <linkunlink+0x92>
    } else if((x % 3) == 1){
    1f94:	01678863          	beq	a5,s6,1fa4 <linkunlink+0xce>
      unlink("x");
    1f98:	8556                	mv	a0,s5
    1f9a:	00002097          	auipc	ra,0x2
    1f9e:	1fc080e7          	jalr	508(ra) # 4196 <unlink>
    1fa2:	bff1                	j	1f7e <linkunlink+0xa8>
      link("cat", "x");
    1fa4:	85d6                	mv	a1,s5
    1fa6:	855e                	mv	a0,s7
    1fa8:	00002097          	auipc	ra,0x2
    1fac:	1fe080e7          	jalr	510(ra) # 41a6 <link>
    1fb0:	b7f9                	j	1f7e <linkunlink+0xa8>
    }
  }

  if(pid)
    1fb2:	020c0c63          	beqz	s8,1fea <linkunlink+0x114>
    wait(0);
    1fb6:	4501                	li	a0,0
    1fb8:	00002097          	auipc	ra,0x2
    1fbc:	196080e7          	jalr	406(ra) # 414e <wait>
  else
    exit(0);

  printf("linkunlink ok\n");
    1fc0:	00003517          	auipc	a0,0x3
    1fc4:	2f050513          	addi	a0,a0,752 # 52b0 <malloc+0xd14>
    1fc8:	00002097          	auipc	ra,0x2
    1fcc:	516080e7          	jalr	1302(ra) # 44de <printf>
}
    1fd0:	60e6                	ld	ra,88(sp)
    1fd2:	6446                	ld	s0,80(sp)
    1fd4:	64a6                	ld	s1,72(sp)
    1fd6:	6906                	ld	s2,64(sp)
    1fd8:	79e2                	ld	s3,56(sp)
    1fda:	7a42                	ld	s4,48(sp)
    1fdc:	7aa2                	ld	s5,40(sp)
    1fde:	7b02                	ld	s6,32(sp)
    1fe0:	6be2                	ld	s7,24(sp)
    1fe2:	6c42                	ld	s8,16(sp)
    1fe4:	6ca2                	ld	s9,8(sp)
    1fe6:	6125                	addi	sp,sp,96
    1fe8:	8082                	ret
    exit(0);
    1fea:	4501                	li	a0,0
    1fec:	00002097          	auipc	ra,0x2
    1ff0:	15a080e7          	jalr	346(ra) # 4146 <exit>

0000000000001ff4 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1ff4:	715d                	addi	sp,sp,-80
    1ff6:	e486                	sd	ra,72(sp)
    1ff8:	e0a2                	sd	s0,64(sp)
    1ffa:	fc26                	sd	s1,56(sp)
    1ffc:	f84a                	sd	s2,48(sp)
    1ffe:	f44e                	sd	s3,40(sp)
    2000:	f052                	sd	s4,32(sp)
    2002:	ec56                	sd	s5,24(sp)
    2004:	0880                	addi	s0,sp,80
  enum { N = 500 };
  int i, fd;
  char name[10];

  printf("bigdir test\n");
    2006:	00003517          	auipc	a0,0x3
    200a:	2ba50513          	addi	a0,a0,698 # 52c0 <malloc+0xd24>
    200e:	00002097          	auipc	ra,0x2
    2012:	4d0080e7          	jalr	1232(ra) # 44de <printf>
  unlink("bd");
    2016:	00003517          	auipc	a0,0x3
    201a:	2ba50513          	addi	a0,a0,698 # 52d0 <malloc+0xd34>
    201e:	00002097          	auipc	ra,0x2
    2022:	178080e7          	jalr	376(ra) # 4196 <unlink>

  fd = open("bd", O_CREATE);
    2026:	20000593          	li	a1,512
    202a:	00003517          	auipc	a0,0x3
    202e:	2a650513          	addi	a0,a0,678 # 52d0 <malloc+0xd34>
    2032:	00002097          	auipc	ra,0x2
    2036:	154080e7          	jalr	340(ra) # 4186 <open>
  if(fd < 0){
    203a:	0e054063          	bltz	a0,211a <bigdir+0x126>
    printf("bigdir create failed\n");
    exit(-1);
  }
  close(fd);
    203e:	00002097          	auipc	ra,0x2
    2042:	130080e7          	jalr	304(ra) # 416e <close>

  for(i = 0; i < N; i++){
    2046:	4901                	li	s2,0
    name[0] = 'x';
    2048:	07800a13          	li	s4,120
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    204c:	00003997          	auipc	s3,0x3
    2050:	28498993          	addi	s3,s3,644 # 52d0 <malloc+0xd34>
  for(i = 0; i < N; i++){
    2054:	1f400a93          	li	s5,500
    name[0] = 'x';
    2058:	fb440823          	sb	s4,-80(s0)
    name[1] = '0' + (i / 64);
    205c:	41f9579b          	sraiw	a5,s2,0x1f
    2060:	01a7d71b          	srliw	a4,a5,0x1a
    2064:	012707bb          	addw	a5,a4,s2
    2068:	4067d69b          	sraiw	a3,a5,0x6
    206c:	0306869b          	addiw	a3,a3,48
    2070:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    2074:	03f7f793          	andi	a5,a5,63
    2078:	9f99                	subw	a5,a5,a4
    207a:	0307879b          	addiw	a5,a5,48
    207e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    2082:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    2086:	fb040593          	addi	a1,s0,-80
    208a:	854e                	mv	a0,s3
    208c:	00002097          	auipc	ra,0x2
    2090:	11a080e7          	jalr	282(ra) # 41a6 <link>
    2094:	84aa                	mv	s1,a0
    2096:	ed59                	bnez	a0,2134 <bigdir+0x140>
  for(i = 0; i < N; i++){
    2098:	2905                	addiw	s2,s2,1
    209a:	fb591fe3          	bne	s2,s5,2058 <bigdir+0x64>
      printf("bigdir link failed\n");
      exit(-1);
    }
  }

  unlink("bd");
    209e:	00003517          	auipc	a0,0x3
    20a2:	23250513          	addi	a0,a0,562 # 52d0 <malloc+0xd34>
    20a6:	00002097          	auipc	ra,0x2
    20aa:	0f0080e7          	jalr	240(ra) # 4196 <unlink>
  for(i = 0; i < N; i++){
    name[0] = 'x';
    20ae:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    20b2:	1f400993          	li	s3,500
    name[0] = 'x';
    20b6:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    20ba:	41f4d79b          	sraiw	a5,s1,0x1f
    20be:	01a7d71b          	srliw	a4,a5,0x1a
    20c2:	009707bb          	addw	a5,a4,s1
    20c6:	4067d69b          	sraiw	a3,a5,0x6
    20ca:	0306869b          	addiw	a3,a3,48
    20ce:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    20d2:	03f7f793          	andi	a5,a5,63
    20d6:	9f99                	subw	a5,a5,a4
    20d8:	0307879b          	addiw	a5,a5,48
    20dc:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    20e0:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    20e4:	fb040513          	addi	a0,s0,-80
    20e8:	00002097          	auipc	ra,0x2
    20ec:	0ae080e7          	jalr	174(ra) # 4196 <unlink>
    20f0:	ed39                	bnez	a0,214e <bigdir+0x15a>
  for(i = 0; i < N; i++){
    20f2:	2485                	addiw	s1,s1,1
    20f4:	fd3491e3          	bne	s1,s3,20b6 <bigdir+0xc2>
      printf("bigdir unlink failed");
      exit(-1);
    }
  }

  printf("bigdir ok\n");
    20f8:	00003517          	auipc	a0,0x3
    20fc:	22850513          	addi	a0,a0,552 # 5320 <malloc+0xd84>
    2100:	00002097          	auipc	ra,0x2
    2104:	3de080e7          	jalr	990(ra) # 44de <printf>
}
    2108:	60a6                	ld	ra,72(sp)
    210a:	6406                	ld	s0,64(sp)
    210c:	74e2                	ld	s1,56(sp)
    210e:	7942                	ld	s2,48(sp)
    2110:	79a2                	ld	s3,40(sp)
    2112:	7a02                	ld	s4,32(sp)
    2114:	6ae2                	ld	s5,24(sp)
    2116:	6161                	addi	sp,sp,80
    2118:	8082                	ret
    printf("bigdir create failed\n");
    211a:	00003517          	auipc	a0,0x3
    211e:	1be50513          	addi	a0,a0,446 # 52d8 <malloc+0xd3c>
    2122:	00002097          	auipc	ra,0x2
    2126:	3bc080e7          	jalr	956(ra) # 44de <printf>
    exit(-1);
    212a:	557d                	li	a0,-1
    212c:	00002097          	auipc	ra,0x2
    2130:	01a080e7          	jalr	26(ra) # 4146 <exit>
      printf("bigdir link failed\n");
    2134:	00003517          	auipc	a0,0x3
    2138:	1bc50513          	addi	a0,a0,444 # 52f0 <malloc+0xd54>
    213c:	00002097          	auipc	ra,0x2
    2140:	3a2080e7          	jalr	930(ra) # 44de <printf>
      exit(-1);
    2144:	557d                	li	a0,-1
    2146:	00002097          	auipc	ra,0x2
    214a:	000080e7          	jalr	ra # 4146 <exit>
      printf("bigdir unlink failed");
    214e:	00003517          	auipc	a0,0x3
    2152:	1ba50513          	addi	a0,a0,442 # 5308 <malloc+0xd6c>
    2156:	00002097          	auipc	ra,0x2
    215a:	388080e7          	jalr	904(ra) # 44de <printf>
      exit(-1);
    215e:	557d                	li	a0,-1
    2160:	00002097          	auipc	ra,0x2
    2164:	fe6080e7          	jalr	-26(ra) # 4146 <exit>

0000000000002168 <subdir>:

void
subdir(void)
{
    2168:	1101                	addi	sp,sp,-32
    216a:	ec06                	sd	ra,24(sp)
    216c:	e822                	sd	s0,16(sp)
    216e:	e426                	sd	s1,8(sp)
    2170:	1000                	addi	s0,sp,32
  int fd, cc;

  printf("subdir test\n");
    2172:	00003517          	auipc	a0,0x3
    2176:	1be50513          	addi	a0,a0,446 # 5330 <malloc+0xd94>
    217a:	00002097          	auipc	ra,0x2
    217e:	364080e7          	jalr	868(ra) # 44de <printf>

  unlink("ff");
    2182:	00003517          	auipc	a0,0x3
    2186:	2d650513          	addi	a0,a0,726 # 5458 <malloc+0xebc>
    218a:	00002097          	auipc	ra,0x2
    218e:	00c080e7          	jalr	12(ra) # 4196 <unlink>
  if(mkdir("dd") != 0){
    2192:	00003517          	auipc	a0,0x3
    2196:	1ae50513          	addi	a0,a0,430 # 5340 <malloc+0xda4>
    219a:	00002097          	auipc	ra,0x2
    219e:	014080e7          	jalr	20(ra) # 41ae <mkdir>
    21a2:	38051d63          	bnez	a0,253c <subdir+0x3d4>
    printf("subdir mkdir dd failed\n");
    exit(-1);
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    21a6:	20200593          	li	a1,514
    21aa:	00003517          	auipc	a0,0x3
    21ae:	1b650513          	addi	a0,a0,438 # 5360 <malloc+0xdc4>
    21b2:	00002097          	auipc	ra,0x2
    21b6:	fd4080e7          	jalr	-44(ra) # 4186 <open>
    21ba:	84aa                	mv	s1,a0
  if(fd < 0){
    21bc:	38054d63          	bltz	a0,2556 <subdir+0x3ee>
    printf("create dd/ff failed\n");
    exit(-1);
  }
  write(fd, "ff", 2);
    21c0:	4609                	li	a2,2
    21c2:	00003597          	auipc	a1,0x3
    21c6:	29658593          	addi	a1,a1,662 # 5458 <malloc+0xebc>
    21ca:	00002097          	auipc	ra,0x2
    21ce:	f9c080e7          	jalr	-100(ra) # 4166 <write>
  close(fd);
    21d2:	8526                	mv	a0,s1
    21d4:	00002097          	auipc	ra,0x2
    21d8:	f9a080e7          	jalr	-102(ra) # 416e <close>

  if(unlink("dd") >= 0){
    21dc:	00003517          	auipc	a0,0x3
    21e0:	16450513          	addi	a0,a0,356 # 5340 <malloc+0xda4>
    21e4:	00002097          	auipc	ra,0x2
    21e8:	fb2080e7          	jalr	-78(ra) # 4196 <unlink>
    21ec:	38055263          	bgez	a0,2570 <subdir+0x408>
    printf("unlink dd (non-empty dir) succeeded!\n");
    exit(-1);
  }

  if(mkdir("/dd/dd") != 0){
    21f0:	00003517          	auipc	a0,0x3
    21f4:	1b850513          	addi	a0,a0,440 # 53a8 <malloc+0xe0c>
    21f8:	00002097          	auipc	ra,0x2
    21fc:	fb6080e7          	jalr	-74(ra) # 41ae <mkdir>
    2200:	38051563          	bnez	a0,258a <subdir+0x422>
    printf("subdir mkdir dd/dd failed\n");
    exit(-1);
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2204:	20200593          	li	a1,514
    2208:	00003517          	auipc	a0,0x3
    220c:	1c850513          	addi	a0,a0,456 # 53d0 <malloc+0xe34>
    2210:	00002097          	auipc	ra,0x2
    2214:	f76080e7          	jalr	-138(ra) # 4186 <open>
    2218:	84aa                	mv	s1,a0
  if(fd < 0){
    221a:	38054563          	bltz	a0,25a4 <subdir+0x43c>
    printf("create dd/dd/ff failed\n");
    exit(-1);
  }
  write(fd, "FF", 2);
    221e:	4609                	li	a2,2
    2220:	00003597          	auipc	a1,0x3
    2224:	1d858593          	addi	a1,a1,472 # 53f8 <malloc+0xe5c>
    2228:	00002097          	auipc	ra,0x2
    222c:	f3e080e7          	jalr	-194(ra) # 4166 <write>
  close(fd);
    2230:	8526                	mv	a0,s1
    2232:	00002097          	auipc	ra,0x2
    2236:	f3c080e7          	jalr	-196(ra) # 416e <close>

  fd = open("dd/dd/../ff", 0);
    223a:	4581                	li	a1,0
    223c:	00003517          	auipc	a0,0x3
    2240:	1c450513          	addi	a0,a0,452 # 5400 <malloc+0xe64>
    2244:	00002097          	auipc	ra,0x2
    2248:	f42080e7          	jalr	-190(ra) # 4186 <open>
    224c:	84aa                	mv	s1,a0
  if(fd < 0){
    224e:	36054863          	bltz	a0,25be <subdir+0x456>
    printf("open dd/dd/../ff failed\n");
    exit(-1);
  }
  cc = read(fd, buf, sizeof(buf));
    2252:	660d                	lui	a2,0x3
    2254:	00007597          	auipc	a1,0x7
    2258:	a3458593          	addi	a1,a1,-1484 # 8c88 <buf>
    225c:	00002097          	auipc	ra,0x2
    2260:	f02080e7          	jalr	-254(ra) # 415e <read>
  if(cc != 2 || buf[0] != 'f'){
    2264:	4789                	li	a5,2
    2266:	36f51963          	bne	a0,a5,25d8 <subdir+0x470>
    226a:	00007717          	auipc	a4,0x7
    226e:	a1e74703          	lbu	a4,-1506(a4) # 8c88 <buf>
    2272:	06600793          	li	a5,102
    2276:	36f71163          	bne	a4,a5,25d8 <subdir+0x470>
    printf("dd/dd/../ff wrong content\n");
    exit(-1);
  }
  close(fd);
    227a:	8526                	mv	a0,s1
    227c:	00002097          	auipc	ra,0x2
    2280:	ef2080e7          	jalr	-270(ra) # 416e <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2284:	00003597          	auipc	a1,0x3
    2288:	1cc58593          	addi	a1,a1,460 # 5450 <malloc+0xeb4>
    228c:	00003517          	auipc	a0,0x3
    2290:	14450513          	addi	a0,a0,324 # 53d0 <malloc+0xe34>
    2294:	00002097          	auipc	ra,0x2
    2298:	f12080e7          	jalr	-238(ra) # 41a6 <link>
    229c:	34051b63          	bnez	a0,25f2 <subdir+0x48a>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    exit(-1);
  }

  if(unlink("dd/dd/ff") != 0){
    22a0:	00003517          	auipc	a0,0x3
    22a4:	13050513          	addi	a0,a0,304 # 53d0 <malloc+0xe34>
    22a8:	00002097          	auipc	ra,0x2
    22ac:	eee080e7          	jalr	-274(ra) # 4196 <unlink>
    22b0:	34051e63          	bnez	a0,260c <subdir+0x4a4>
    printf("unlink dd/dd/ff failed\n");
    exit(-1);
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22b4:	4581                	li	a1,0
    22b6:	00003517          	auipc	a0,0x3
    22ba:	11a50513          	addi	a0,a0,282 # 53d0 <malloc+0xe34>
    22be:	00002097          	auipc	ra,0x2
    22c2:	ec8080e7          	jalr	-312(ra) # 4186 <open>
    22c6:	36055063          	bgez	a0,2626 <subdir+0x4be>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    exit(-1);
  }

  if(chdir("dd") != 0){
    22ca:	00003517          	auipc	a0,0x3
    22ce:	07650513          	addi	a0,a0,118 # 5340 <malloc+0xda4>
    22d2:	00002097          	auipc	ra,0x2
    22d6:	ee4080e7          	jalr	-284(ra) # 41b6 <chdir>
    22da:	36051363          	bnez	a0,2640 <subdir+0x4d8>
    printf("chdir dd failed\n");
    exit(-1);
  }
  if(chdir("dd/../../dd") != 0){
    22de:	00003517          	auipc	a0,0x3
    22e2:	20250513          	addi	a0,a0,514 # 54e0 <malloc+0xf44>
    22e6:	00002097          	auipc	ra,0x2
    22ea:	ed0080e7          	jalr	-304(ra) # 41b6 <chdir>
    22ee:	36051663          	bnez	a0,265a <subdir+0x4f2>
    printf("chdir dd/../../dd failed\n");
    exit(-1);
  }
  if(chdir("dd/../../../dd") != 0){
    22f2:	00003517          	auipc	a0,0x3
    22f6:	21e50513          	addi	a0,a0,542 # 5510 <malloc+0xf74>
    22fa:	00002097          	auipc	ra,0x2
    22fe:	ebc080e7          	jalr	-324(ra) # 41b6 <chdir>
    2302:	36051963          	bnez	a0,2674 <subdir+0x50c>
    printf("chdir dd/../../dd failed\n");
    exit(-1);
  }
  if(chdir("./..") != 0){
    2306:	00003517          	auipc	a0,0x3
    230a:	21a50513          	addi	a0,a0,538 # 5520 <malloc+0xf84>
    230e:	00002097          	auipc	ra,0x2
    2312:	ea8080e7          	jalr	-344(ra) # 41b6 <chdir>
    2316:	36051c63          	bnez	a0,268e <subdir+0x526>
    printf("chdir ./.. failed\n");
    exit(-1);
  }

  fd = open("dd/dd/ffff", 0);
    231a:	4581                	li	a1,0
    231c:	00003517          	auipc	a0,0x3
    2320:	13450513          	addi	a0,a0,308 # 5450 <malloc+0xeb4>
    2324:	00002097          	auipc	ra,0x2
    2328:	e62080e7          	jalr	-414(ra) # 4186 <open>
    232c:	84aa                	mv	s1,a0
  if(fd < 0){
    232e:	36054d63          	bltz	a0,26a8 <subdir+0x540>
    printf("open dd/dd/ffff failed\n");
    exit(-1);
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2332:	660d                	lui	a2,0x3
    2334:	00007597          	auipc	a1,0x7
    2338:	95458593          	addi	a1,a1,-1708 # 8c88 <buf>
    233c:	00002097          	auipc	ra,0x2
    2340:	e22080e7          	jalr	-478(ra) # 415e <read>
    2344:	4789                	li	a5,2
    2346:	36f51e63          	bne	a0,a5,26c2 <subdir+0x55a>
    printf("read dd/dd/ffff wrong len\n");
    exit(-1);
  }
  close(fd);
    234a:	8526                	mv	a0,s1
    234c:	00002097          	auipc	ra,0x2
    2350:	e22080e7          	jalr	-478(ra) # 416e <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2354:	4581                	li	a1,0
    2356:	00003517          	auipc	a0,0x3
    235a:	07a50513          	addi	a0,a0,122 # 53d0 <malloc+0xe34>
    235e:	00002097          	auipc	ra,0x2
    2362:	e28080e7          	jalr	-472(ra) # 4186 <open>
    2366:	36055b63          	bgez	a0,26dc <subdir+0x574>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    exit(-1);
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    236a:	20200593          	li	a1,514
    236e:	00003517          	auipc	a0,0x3
    2372:	23250513          	addi	a0,a0,562 # 55a0 <malloc+0x1004>
    2376:	00002097          	auipc	ra,0x2
    237a:	e10080e7          	jalr	-496(ra) # 4186 <open>
    237e:	36055c63          	bgez	a0,26f6 <subdir+0x58e>
    printf("create dd/ff/ff succeeded!\n");
    exit(-1);
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2382:	20200593          	li	a1,514
    2386:	00003517          	auipc	a0,0x3
    238a:	24a50513          	addi	a0,a0,586 # 55d0 <malloc+0x1034>
    238e:	00002097          	auipc	ra,0x2
    2392:	df8080e7          	jalr	-520(ra) # 4186 <open>
    2396:	36055d63          	bgez	a0,2710 <subdir+0x5a8>
    printf("create dd/xx/ff succeeded!\n");
    exit(-1);
  }
  if(open("dd", O_CREATE) >= 0){
    239a:	20000593          	li	a1,512
    239e:	00003517          	auipc	a0,0x3
    23a2:	fa250513          	addi	a0,a0,-94 # 5340 <malloc+0xda4>
    23a6:	00002097          	auipc	ra,0x2
    23aa:	de0080e7          	jalr	-544(ra) # 4186 <open>
    23ae:	36055e63          	bgez	a0,272a <subdir+0x5c2>
    printf("create dd succeeded!\n");
    exit(-1);
  }
  if(open("dd", O_RDWR) >= 0){
    23b2:	4589                	li	a1,2
    23b4:	00003517          	auipc	a0,0x3
    23b8:	f8c50513          	addi	a0,a0,-116 # 5340 <malloc+0xda4>
    23bc:	00002097          	auipc	ra,0x2
    23c0:	dca080e7          	jalr	-566(ra) # 4186 <open>
    23c4:	38055063          	bgez	a0,2744 <subdir+0x5dc>
    printf("open dd rdwr succeeded!\n");
    exit(-1);
  }
  if(open("dd", O_WRONLY) >= 0){
    23c8:	4585                	li	a1,1
    23ca:	00003517          	auipc	a0,0x3
    23ce:	f7650513          	addi	a0,a0,-138 # 5340 <malloc+0xda4>
    23d2:	00002097          	auipc	ra,0x2
    23d6:	db4080e7          	jalr	-588(ra) # 4186 <open>
    23da:	38055263          	bgez	a0,275e <subdir+0x5f6>
    printf("open dd wronly succeeded!\n");
    exit(-1);
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    23de:	00003597          	auipc	a1,0x3
    23e2:	27a58593          	addi	a1,a1,634 # 5658 <malloc+0x10bc>
    23e6:	00003517          	auipc	a0,0x3
    23ea:	1ba50513          	addi	a0,a0,442 # 55a0 <malloc+0x1004>
    23ee:	00002097          	auipc	ra,0x2
    23f2:	db8080e7          	jalr	-584(ra) # 41a6 <link>
    23f6:	38050163          	beqz	a0,2778 <subdir+0x610>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    exit(-1);
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    23fa:	00003597          	auipc	a1,0x3
    23fe:	25e58593          	addi	a1,a1,606 # 5658 <malloc+0x10bc>
    2402:	00003517          	auipc	a0,0x3
    2406:	1ce50513          	addi	a0,a0,462 # 55d0 <malloc+0x1034>
    240a:	00002097          	auipc	ra,0x2
    240e:	d9c080e7          	jalr	-612(ra) # 41a6 <link>
    2412:	38050063          	beqz	a0,2792 <subdir+0x62a>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    exit(-1);
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2416:	00003597          	auipc	a1,0x3
    241a:	03a58593          	addi	a1,a1,58 # 5450 <malloc+0xeb4>
    241e:	00003517          	auipc	a0,0x3
    2422:	f4250513          	addi	a0,a0,-190 # 5360 <malloc+0xdc4>
    2426:	00002097          	auipc	ra,0x2
    242a:	d80080e7          	jalr	-640(ra) # 41a6 <link>
    242e:	36050f63          	beqz	a0,27ac <subdir+0x644>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    exit(-1);
  }
  if(mkdir("dd/ff/ff") == 0){
    2432:	00003517          	auipc	a0,0x3
    2436:	16e50513          	addi	a0,a0,366 # 55a0 <malloc+0x1004>
    243a:	00002097          	auipc	ra,0x2
    243e:	d74080e7          	jalr	-652(ra) # 41ae <mkdir>
    2442:	38050263          	beqz	a0,27c6 <subdir+0x65e>
    printf("mkdir dd/ff/ff succeeded!\n");
    exit(-1);
  }
  if(mkdir("dd/xx/ff") == 0){
    2446:	00003517          	auipc	a0,0x3
    244a:	18a50513          	addi	a0,a0,394 # 55d0 <malloc+0x1034>
    244e:	00002097          	auipc	ra,0x2
    2452:	d60080e7          	jalr	-672(ra) # 41ae <mkdir>
    2456:	38050563          	beqz	a0,27e0 <subdir+0x678>
    printf("mkdir dd/xx/ff succeeded!\n");
    exit(-1);
  }
  if(mkdir("dd/dd/ffff") == 0){
    245a:	00003517          	auipc	a0,0x3
    245e:	ff650513          	addi	a0,a0,-10 # 5450 <malloc+0xeb4>
    2462:	00002097          	auipc	ra,0x2
    2466:	d4c080e7          	jalr	-692(ra) # 41ae <mkdir>
    246a:	38050863          	beqz	a0,27fa <subdir+0x692>
    printf("mkdir dd/dd/ffff succeeded!\n");
    exit(-1);
  }
  if(unlink("dd/xx/ff") == 0){
    246e:	00003517          	auipc	a0,0x3
    2472:	16250513          	addi	a0,a0,354 # 55d0 <malloc+0x1034>
    2476:	00002097          	auipc	ra,0x2
    247a:	d20080e7          	jalr	-736(ra) # 4196 <unlink>
    247e:	38050b63          	beqz	a0,2814 <subdir+0x6ac>
    printf("unlink dd/xx/ff succeeded!\n");
    exit(-1);
  }
  if(unlink("dd/ff/ff") == 0){
    2482:	00003517          	auipc	a0,0x3
    2486:	11e50513          	addi	a0,a0,286 # 55a0 <malloc+0x1004>
    248a:	00002097          	auipc	ra,0x2
    248e:	d0c080e7          	jalr	-756(ra) # 4196 <unlink>
    2492:	38050e63          	beqz	a0,282e <subdir+0x6c6>
    printf("unlink dd/ff/ff succeeded!\n");
    exit(-1);
  }
  if(chdir("dd/ff") == 0){
    2496:	00003517          	auipc	a0,0x3
    249a:	eca50513          	addi	a0,a0,-310 # 5360 <malloc+0xdc4>
    249e:	00002097          	auipc	ra,0x2
    24a2:	d18080e7          	jalr	-744(ra) # 41b6 <chdir>
    24a6:	3a050163          	beqz	a0,2848 <subdir+0x6e0>
    printf("chdir dd/ff succeeded!\n");
    exit(-1);
  }
  if(chdir("dd/xx") == 0){
    24aa:	00003517          	auipc	a0,0x3
    24ae:	2ee50513          	addi	a0,a0,750 # 5798 <malloc+0x11fc>
    24b2:	00002097          	auipc	ra,0x2
    24b6:	d04080e7          	jalr	-764(ra) # 41b6 <chdir>
    24ba:	3a050463          	beqz	a0,2862 <subdir+0x6fa>
    printf("chdir dd/xx succeeded!\n");
    exit(-1);
  }

  if(unlink("dd/dd/ffff") != 0){
    24be:	00003517          	auipc	a0,0x3
    24c2:	f9250513          	addi	a0,a0,-110 # 5450 <malloc+0xeb4>
    24c6:	00002097          	auipc	ra,0x2
    24ca:	cd0080e7          	jalr	-816(ra) # 4196 <unlink>
    24ce:	3a051763          	bnez	a0,287c <subdir+0x714>
    printf("unlink dd/dd/ff failed\n");
    exit(-1);
  }
  if(unlink("dd/ff") != 0){
    24d2:	00003517          	auipc	a0,0x3
    24d6:	e8e50513          	addi	a0,a0,-370 # 5360 <malloc+0xdc4>
    24da:	00002097          	auipc	ra,0x2
    24de:	cbc080e7          	jalr	-836(ra) # 4196 <unlink>
    24e2:	3a051a63          	bnez	a0,2896 <subdir+0x72e>
    printf("unlink dd/ff failed\n");
    exit(-1);
  }
  if(unlink("dd") == 0){
    24e6:	00003517          	auipc	a0,0x3
    24ea:	e5a50513          	addi	a0,a0,-422 # 5340 <malloc+0xda4>
    24ee:	00002097          	auipc	ra,0x2
    24f2:	ca8080e7          	jalr	-856(ra) # 4196 <unlink>
    24f6:	3a050d63          	beqz	a0,28b0 <subdir+0x748>
    printf("unlink non-empty dd succeeded!\n");
    exit(-1);
  }
  if(unlink("dd/dd") < 0){
    24fa:	00003517          	auipc	a0,0x3
    24fe:	2f650513          	addi	a0,a0,758 # 57f0 <malloc+0x1254>
    2502:	00002097          	auipc	ra,0x2
    2506:	c94080e7          	jalr	-876(ra) # 4196 <unlink>
    250a:	3c054063          	bltz	a0,28ca <subdir+0x762>
    printf("unlink dd/dd failed\n");
    exit(-1);
  }
  if(unlink("dd") < 0){
    250e:	00003517          	auipc	a0,0x3
    2512:	e3250513          	addi	a0,a0,-462 # 5340 <malloc+0xda4>
    2516:	00002097          	auipc	ra,0x2
    251a:	c80080e7          	jalr	-896(ra) # 4196 <unlink>
    251e:	3c054363          	bltz	a0,28e4 <subdir+0x77c>
    printf("unlink dd failed\n");
    exit(-1);
  }

  printf("subdir ok\n");
    2522:	00003517          	auipc	a0,0x3
    2526:	30650513          	addi	a0,a0,774 # 5828 <malloc+0x128c>
    252a:	00002097          	auipc	ra,0x2
    252e:	fb4080e7          	jalr	-76(ra) # 44de <printf>
}
    2532:	60e2                	ld	ra,24(sp)
    2534:	6442                	ld	s0,16(sp)
    2536:	64a2                	ld	s1,8(sp)
    2538:	6105                	addi	sp,sp,32
    253a:	8082                	ret
    printf("subdir mkdir dd failed\n");
    253c:	00003517          	auipc	a0,0x3
    2540:	e0c50513          	addi	a0,a0,-500 # 5348 <malloc+0xdac>
    2544:	00002097          	auipc	ra,0x2
    2548:	f9a080e7          	jalr	-102(ra) # 44de <printf>
    exit(-1);
    254c:	557d                	li	a0,-1
    254e:	00002097          	auipc	ra,0x2
    2552:	bf8080e7          	jalr	-1032(ra) # 4146 <exit>
    printf("create dd/ff failed\n");
    2556:	00003517          	auipc	a0,0x3
    255a:	e1250513          	addi	a0,a0,-494 # 5368 <malloc+0xdcc>
    255e:	00002097          	auipc	ra,0x2
    2562:	f80080e7          	jalr	-128(ra) # 44de <printf>
    exit(-1);
    2566:	557d                	li	a0,-1
    2568:	00002097          	auipc	ra,0x2
    256c:	bde080e7          	jalr	-1058(ra) # 4146 <exit>
    printf("unlink dd (non-empty dir) succeeded!\n");
    2570:	00003517          	auipc	a0,0x3
    2574:	e1050513          	addi	a0,a0,-496 # 5380 <malloc+0xde4>
    2578:	00002097          	auipc	ra,0x2
    257c:	f66080e7          	jalr	-154(ra) # 44de <printf>
    exit(-1);
    2580:	557d                	li	a0,-1
    2582:	00002097          	auipc	ra,0x2
    2586:	bc4080e7          	jalr	-1084(ra) # 4146 <exit>
    printf("subdir mkdir dd/dd failed\n");
    258a:	00003517          	auipc	a0,0x3
    258e:	e2650513          	addi	a0,a0,-474 # 53b0 <malloc+0xe14>
    2592:	00002097          	auipc	ra,0x2
    2596:	f4c080e7          	jalr	-180(ra) # 44de <printf>
    exit(-1);
    259a:	557d                	li	a0,-1
    259c:	00002097          	auipc	ra,0x2
    25a0:	baa080e7          	jalr	-1110(ra) # 4146 <exit>
    printf("create dd/dd/ff failed\n");
    25a4:	00003517          	auipc	a0,0x3
    25a8:	e3c50513          	addi	a0,a0,-452 # 53e0 <malloc+0xe44>
    25ac:	00002097          	auipc	ra,0x2
    25b0:	f32080e7          	jalr	-206(ra) # 44de <printf>
    exit(-1);
    25b4:	557d                	li	a0,-1
    25b6:	00002097          	auipc	ra,0x2
    25ba:	b90080e7          	jalr	-1136(ra) # 4146 <exit>
    printf("open dd/dd/../ff failed\n");
    25be:	00003517          	auipc	a0,0x3
    25c2:	e5250513          	addi	a0,a0,-430 # 5410 <malloc+0xe74>
    25c6:	00002097          	auipc	ra,0x2
    25ca:	f18080e7          	jalr	-232(ra) # 44de <printf>
    exit(-1);
    25ce:	557d                	li	a0,-1
    25d0:	00002097          	auipc	ra,0x2
    25d4:	b76080e7          	jalr	-1162(ra) # 4146 <exit>
    printf("dd/dd/../ff wrong content\n");
    25d8:	00003517          	auipc	a0,0x3
    25dc:	e5850513          	addi	a0,a0,-424 # 5430 <malloc+0xe94>
    25e0:	00002097          	auipc	ra,0x2
    25e4:	efe080e7          	jalr	-258(ra) # 44de <printf>
    exit(-1);
    25e8:	557d                	li	a0,-1
    25ea:	00002097          	auipc	ra,0x2
    25ee:	b5c080e7          	jalr	-1188(ra) # 4146 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
    25f2:	00003517          	auipc	a0,0x3
    25f6:	e6e50513          	addi	a0,a0,-402 # 5460 <malloc+0xec4>
    25fa:	00002097          	auipc	ra,0x2
    25fe:	ee4080e7          	jalr	-284(ra) # 44de <printf>
    exit(-1);
    2602:	557d                	li	a0,-1
    2604:	00002097          	auipc	ra,0x2
    2608:	b42080e7          	jalr	-1214(ra) # 4146 <exit>
    printf("unlink dd/dd/ff failed\n");
    260c:	00003517          	auipc	a0,0x3
    2610:	e7c50513          	addi	a0,a0,-388 # 5488 <malloc+0xeec>
    2614:	00002097          	auipc	ra,0x2
    2618:	eca080e7          	jalr	-310(ra) # 44de <printf>
    exit(-1);
    261c:	557d                	li	a0,-1
    261e:	00002097          	auipc	ra,0x2
    2622:	b28080e7          	jalr	-1240(ra) # 4146 <exit>
    printf("open (unlinked) dd/dd/ff succeeded\n");
    2626:	00003517          	auipc	a0,0x3
    262a:	e7a50513          	addi	a0,a0,-390 # 54a0 <malloc+0xf04>
    262e:	00002097          	auipc	ra,0x2
    2632:	eb0080e7          	jalr	-336(ra) # 44de <printf>
    exit(-1);
    2636:	557d                	li	a0,-1
    2638:	00002097          	auipc	ra,0x2
    263c:	b0e080e7          	jalr	-1266(ra) # 4146 <exit>
    printf("chdir dd failed\n");
    2640:	00003517          	auipc	a0,0x3
    2644:	e8850513          	addi	a0,a0,-376 # 54c8 <malloc+0xf2c>
    2648:	00002097          	auipc	ra,0x2
    264c:	e96080e7          	jalr	-362(ra) # 44de <printf>
    exit(-1);
    2650:	557d                	li	a0,-1
    2652:	00002097          	auipc	ra,0x2
    2656:	af4080e7          	jalr	-1292(ra) # 4146 <exit>
    printf("chdir dd/../../dd failed\n");
    265a:	00003517          	auipc	a0,0x3
    265e:	e9650513          	addi	a0,a0,-362 # 54f0 <malloc+0xf54>
    2662:	00002097          	auipc	ra,0x2
    2666:	e7c080e7          	jalr	-388(ra) # 44de <printf>
    exit(-1);
    266a:	557d                	li	a0,-1
    266c:	00002097          	auipc	ra,0x2
    2670:	ada080e7          	jalr	-1318(ra) # 4146 <exit>
    printf("chdir dd/../../dd failed\n");
    2674:	00003517          	auipc	a0,0x3
    2678:	e7c50513          	addi	a0,a0,-388 # 54f0 <malloc+0xf54>
    267c:	00002097          	auipc	ra,0x2
    2680:	e62080e7          	jalr	-414(ra) # 44de <printf>
    exit(-1);
    2684:	557d                	li	a0,-1
    2686:	00002097          	auipc	ra,0x2
    268a:	ac0080e7          	jalr	-1344(ra) # 4146 <exit>
    printf("chdir ./.. failed\n");
    268e:	00003517          	auipc	a0,0x3
    2692:	e9a50513          	addi	a0,a0,-358 # 5528 <malloc+0xf8c>
    2696:	00002097          	auipc	ra,0x2
    269a:	e48080e7          	jalr	-440(ra) # 44de <printf>
    exit(-1);
    269e:	557d                	li	a0,-1
    26a0:	00002097          	auipc	ra,0x2
    26a4:	aa6080e7          	jalr	-1370(ra) # 4146 <exit>
    printf("open dd/dd/ffff failed\n");
    26a8:	00003517          	auipc	a0,0x3
    26ac:	e9850513          	addi	a0,a0,-360 # 5540 <malloc+0xfa4>
    26b0:	00002097          	auipc	ra,0x2
    26b4:	e2e080e7          	jalr	-466(ra) # 44de <printf>
    exit(-1);
    26b8:	557d                	li	a0,-1
    26ba:	00002097          	auipc	ra,0x2
    26be:	a8c080e7          	jalr	-1396(ra) # 4146 <exit>
    printf("read dd/dd/ffff wrong len\n");
    26c2:	00003517          	auipc	a0,0x3
    26c6:	e9650513          	addi	a0,a0,-362 # 5558 <malloc+0xfbc>
    26ca:	00002097          	auipc	ra,0x2
    26ce:	e14080e7          	jalr	-492(ra) # 44de <printf>
    exit(-1);
    26d2:	557d                	li	a0,-1
    26d4:	00002097          	auipc	ra,0x2
    26d8:	a72080e7          	jalr	-1422(ra) # 4146 <exit>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
    26dc:	00003517          	auipc	a0,0x3
    26e0:	e9c50513          	addi	a0,a0,-356 # 5578 <malloc+0xfdc>
    26e4:	00002097          	auipc	ra,0x2
    26e8:	dfa080e7          	jalr	-518(ra) # 44de <printf>
    exit(-1);
    26ec:	557d                	li	a0,-1
    26ee:	00002097          	auipc	ra,0x2
    26f2:	a58080e7          	jalr	-1448(ra) # 4146 <exit>
    printf("create dd/ff/ff succeeded!\n");
    26f6:	00003517          	auipc	a0,0x3
    26fa:	eba50513          	addi	a0,a0,-326 # 55b0 <malloc+0x1014>
    26fe:	00002097          	auipc	ra,0x2
    2702:	de0080e7          	jalr	-544(ra) # 44de <printf>
    exit(-1);
    2706:	557d                	li	a0,-1
    2708:	00002097          	auipc	ra,0x2
    270c:	a3e080e7          	jalr	-1474(ra) # 4146 <exit>
    printf("create dd/xx/ff succeeded!\n");
    2710:	00003517          	auipc	a0,0x3
    2714:	ed050513          	addi	a0,a0,-304 # 55e0 <malloc+0x1044>
    2718:	00002097          	auipc	ra,0x2
    271c:	dc6080e7          	jalr	-570(ra) # 44de <printf>
    exit(-1);
    2720:	557d                	li	a0,-1
    2722:	00002097          	auipc	ra,0x2
    2726:	a24080e7          	jalr	-1500(ra) # 4146 <exit>
    printf("create dd succeeded!\n");
    272a:	00003517          	auipc	a0,0x3
    272e:	ed650513          	addi	a0,a0,-298 # 5600 <malloc+0x1064>
    2732:	00002097          	auipc	ra,0x2
    2736:	dac080e7          	jalr	-596(ra) # 44de <printf>
    exit(-1);
    273a:	557d                	li	a0,-1
    273c:	00002097          	auipc	ra,0x2
    2740:	a0a080e7          	jalr	-1526(ra) # 4146 <exit>
    printf("open dd rdwr succeeded!\n");
    2744:	00003517          	auipc	a0,0x3
    2748:	ed450513          	addi	a0,a0,-300 # 5618 <malloc+0x107c>
    274c:	00002097          	auipc	ra,0x2
    2750:	d92080e7          	jalr	-622(ra) # 44de <printf>
    exit(-1);
    2754:	557d                	li	a0,-1
    2756:	00002097          	auipc	ra,0x2
    275a:	9f0080e7          	jalr	-1552(ra) # 4146 <exit>
    printf("open dd wronly succeeded!\n");
    275e:	00003517          	auipc	a0,0x3
    2762:	eda50513          	addi	a0,a0,-294 # 5638 <malloc+0x109c>
    2766:	00002097          	auipc	ra,0x2
    276a:	d78080e7          	jalr	-648(ra) # 44de <printf>
    exit(-1);
    276e:	557d                	li	a0,-1
    2770:	00002097          	auipc	ra,0x2
    2774:	9d6080e7          	jalr	-1578(ra) # 4146 <exit>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
    2778:	00003517          	auipc	a0,0x3
    277c:	ef050513          	addi	a0,a0,-272 # 5668 <malloc+0x10cc>
    2780:	00002097          	auipc	ra,0x2
    2784:	d5e080e7          	jalr	-674(ra) # 44de <printf>
    exit(-1);
    2788:	557d                	li	a0,-1
    278a:	00002097          	auipc	ra,0x2
    278e:	9bc080e7          	jalr	-1604(ra) # 4146 <exit>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
    2792:	00003517          	auipc	a0,0x3
    2796:	efe50513          	addi	a0,a0,-258 # 5690 <malloc+0x10f4>
    279a:	00002097          	auipc	ra,0x2
    279e:	d44080e7          	jalr	-700(ra) # 44de <printf>
    exit(-1);
    27a2:	557d                	li	a0,-1
    27a4:	00002097          	auipc	ra,0x2
    27a8:	9a2080e7          	jalr	-1630(ra) # 4146 <exit>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
    27ac:	00003517          	auipc	a0,0x3
    27b0:	f0c50513          	addi	a0,a0,-244 # 56b8 <malloc+0x111c>
    27b4:	00002097          	auipc	ra,0x2
    27b8:	d2a080e7          	jalr	-726(ra) # 44de <printf>
    exit(-1);
    27bc:	557d                	li	a0,-1
    27be:	00002097          	auipc	ra,0x2
    27c2:	988080e7          	jalr	-1656(ra) # 4146 <exit>
    printf("mkdir dd/ff/ff succeeded!\n");
    27c6:	00003517          	auipc	a0,0x3
    27ca:	f1a50513          	addi	a0,a0,-230 # 56e0 <malloc+0x1144>
    27ce:	00002097          	auipc	ra,0x2
    27d2:	d10080e7          	jalr	-752(ra) # 44de <printf>
    exit(-1);
    27d6:	557d                	li	a0,-1
    27d8:	00002097          	auipc	ra,0x2
    27dc:	96e080e7          	jalr	-1682(ra) # 4146 <exit>
    printf("mkdir dd/xx/ff succeeded!\n");
    27e0:	00003517          	auipc	a0,0x3
    27e4:	f2050513          	addi	a0,a0,-224 # 5700 <malloc+0x1164>
    27e8:	00002097          	auipc	ra,0x2
    27ec:	cf6080e7          	jalr	-778(ra) # 44de <printf>
    exit(-1);
    27f0:	557d                	li	a0,-1
    27f2:	00002097          	auipc	ra,0x2
    27f6:	954080e7          	jalr	-1708(ra) # 4146 <exit>
    printf("mkdir dd/dd/ffff succeeded!\n");
    27fa:	00003517          	auipc	a0,0x3
    27fe:	f2650513          	addi	a0,a0,-218 # 5720 <malloc+0x1184>
    2802:	00002097          	auipc	ra,0x2
    2806:	cdc080e7          	jalr	-804(ra) # 44de <printf>
    exit(-1);
    280a:	557d                	li	a0,-1
    280c:	00002097          	auipc	ra,0x2
    2810:	93a080e7          	jalr	-1734(ra) # 4146 <exit>
    printf("unlink dd/xx/ff succeeded!\n");
    2814:	00003517          	auipc	a0,0x3
    2818:	f2c50513          	addi	a0,a0,-212 # 5740 <malloc+0x11a4>
    281c:	00002097          	auipc	ra,0x2
    2820:	cc2080e7          	jalr	-830(ra) # 44de <printf>
    exit(-1);
    2824:	557d                	li	a0,-1
    2826:	00002097          	auipc	ra,0x2
    282a:	920080e7          	jalr	-1760(ra) # 4146 <exit>
    printf("unlink dd/ff/ff succeeded!\n");
    282e:	00003517          	auipc	a0,0x3
    2832:	f3250513          	addi	a0,a0,-206 # 5760 <malloc+0x11c4>
    2836:	00002097          	auipc	ra,0x2
    283a:	ca8080e7          	jalr	-856(ra) # 44de <printf>
    exit(-1);
    283e:	557d                	li	a0,-1
    2840:	00002097          	auipc	ra,0x2
    2844:	906080e7          	jalr	-1786(ra) # 4146 <exit>
    printf("chdir dd/ff succeeded!\n");
    2848:	00003517          	auipc	a0,0x3
    284c:	f3850513          	addi	a0,a0,-200 # 5780 <malloc+0x11e4>
    2850:	00002097          	auipc	ra,0x2
    2854:	c8e080e7          	jalr	-882(ra) # 44de <printf>
    exit(-1);
    2858:	557d                	li	a0,-1
    285a:	00002097          	auipc	ra,0x2
    285e:	8ec080e7          	jalr	-1812(ra) # 4146 <exit>
    printf("chdir dd/xx succeeded!\n");
    2862:	00003517          	auipc	a0,0x3
    2866:	f3e50513          	addi	a0,a0,-194 # 57a0 <malloc+0x1204>
    286a:	00002097          	auipc	ra,0x2
    286e:	c74080e7          	jalr	-908(ra) # 44de <printf>
    exit(-1);
    2872:	557d                	li	a0,-1
    2874:	00002097          	auipc	ra,0x2
    2878:	8d2080e7          	jalr	-1838(ra) # 4146 <exit>
    printf("unlink dd/dd/ff failed\n");
    287c:	00003517          	auipc	a0,0x3
    2880:	c0c50513          	addi	a0,a0,-1012 # 5488 <malloc+0xeec>
    2884:	00002097          	auipc	ra,0x2
    2888:	c5a080e7          	jalr	-934(ra) # 44de <printf>
    exit(-1);
    288c:	557d                	li	a0,-1
    288e:	00002097          	auipc	ra,0x2
    2892:	8b8080e7          	jalr	-1864(ra) # 4146 <exit>
    printf("unlink dd/ff failed\n");
    2896:	00003517          	auipc	a0,0x3
    289a:	f2250513          	addi	a0,a0,-222 # 57b8 <malloc+0x121c>
    289e:	00002097          	auipc	ra,0x2
    28a2:	c40080e7          	jalr	-960(ra) # 44de <printf>
    exit(-1);
    28a6:	557d                	li	a0,-1
    28a8:	00002097          	auipc	ra,0x2
    28ac:	89e080e7          	jalr	-1890(ra) # 4146 <exit>
    printf("unlink non-empty dd succeeded!\n");
    28b0:	00003517          	auipc	a0,0x3
    28b4:	f2050513          	addi	a0,a0,-224 # 57d0 <malloc+0x1234>
    28b8:	00002097          	auipc	ra,0x2
    28bc:	c26080e7          	jalr	-986(ra) # 44de <printf>
    exit(-1);
    28c0:	557d                	li	a0,-1
    28c2:	00002097          	auipc	ra,0x2
    28c6:	884080e7          	jalr	-1916(ra) # 4146 <exit>
    printf("unlink dd/dd failed\n");
    28ca:	00003517          	auipc	a0,0x3
    28ce:	f2e50513          	addi	a0,a0,-210 # 57f8 <malloc+0x125c>
    28d2:	00002097          	auipc	ra,0x2
    28d6:	c0c080e7          	jalr	-1012(ra) # 44de <printf>
    exit(-1);
    28da:	557d                	li	a0,-1
    28dc:	00002097          	auipc	ra,0x2
    28e0:	86a080e7          	jalr	-1942(ra) # 4146 <exit>
    printf("unlink dd failed\n");
    28e4:	00003517          	auipc	a0,0x3
    28e8:	f2c50513          	addi	a0,a0,-212 # 5810 <malloc+0x1274>
    28ec:	00002097          	auipc	ra,0x2
    28f0:	bf2080e7          	jalr	-1038(ra) # 44de <printf>
    exit(-1);
    28f4:	557d                	li	a0,-1
    28f6:	00002097          	auipc	ra,0x2
    28fa:	850080e7          	jalr	-1968(ra) # 4146 <exit>

00000000000028fe <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    28fe:	7139                	addi	sp,sp,-64
    2900:	fc06                	sd	ra,56(sp)
    2902:	f822                	sd	s0,48(sp)
    2904:	f426                	sd	s1,40(sp)
    2906:	f04a                	sd	s2,32(sp)
    2908:	ec4e                	sd	s3,24(sp)
    290a:	e852                	sd	s4,16(sp)
    290c:	e456                	sd	s5,8(sp)
    290e:	e05a                	sd	s6,0(sp)
    2910:	0080                	addi	s0,sp,64
  int fd, sz;

  printf("bigwrite test\n");
    2912:	00003517          	auipc	a0,0x3
    2916:	f2650513          	addi	a0,a0,-218 # 5838 <malloc+0x129c>
    291a:	00002097          	auipc	ra,0x2
    291e:	bc4080e7          	jalr	-1084(ra) # 44de <printf>

  unlink("bigwrite");
    2922:	00003517          	auipc	a0,0x3
    2926:	f2650513          	addi	a0,a0,-218 # 5848 <malloc+0x12ac>
    292a:	00002097          	auipc	ra,0x2
    292e:	86c080e7          	jalr	-1940(ra) # 4196 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    2932:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2936:	00003a97          	auipc	s5,0x3
    293a:	f12a8a93          	addi	s5,s5,-238 # 5848 <malloc+0x12ac>
      printf("cannot create bigwrite\n");
      exit(-1);
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    293e:	00006a17          	auipc	s4,0x6
    2942:	34aa0a13          	addi	s4,s4,842 # 8c88 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    2946:	6b0d                	lui	s6,0x3
    2948:	1c9b0b13          	addi	s6,s6,457 # 31c9 <iref+0xbf>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    294c:	20200593          	li	a1,514
    2950:	8556                	mv	a0,s5
    2952:	00002097          	auipc	ra,0x2
    2956:	834080e7          	jalr	-1996(ra) # 4186 <open>
    295a:	892a                	mv	s2,a0
    if(fd < 0){
    295c:	06054463          	bltz	a0,29c4 <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    2960:	8626                	mv	a2,s1
    2962:	85d2                	mv	a1,s4
    2964:	00002097          	auipc	ra,0x2
    2968:	802080e7          	jalr	-2046(ra) # 4166 <write>
    296c:	89aa                	mv	s3,a0
      if(cc != sz){
    296e:	06a49a63          	bne	s1,a0,29e2 <bigwrite+0xe4>
      int cc = write(fd, buf, sz);
    2972:	8626                	mv	a2,s1
    2974:	85d2                	mv	a1,s4
    2976:	854a                	mv	a0,s2
    2978:	00001097          	auipc	ra,0x1
    297c:	7ee080e7          	jalr	2030(ra) # 4166 <write>
      if(cc != sz){
    2980:	04951f63          	bne	a0,s1,29de <bigwrite+0xe0>
        printf("write(%d) ret %d\n", sz, cc);
        exit(-1);
      }
    }
    close(fd);
    2984:	854a                	mv	a0,s2
    2986:	00001097          	auipc	ra,0x1
    298a:	7e8080e7          	jalr	2024(ra) # 416e <close>
    unlink("bigwrite");
    298e:	8556                	mv	a0,s5
    2990:	00002097          	auipc	ra,0x2
    2994:	806080e7          	jalr	-2042(ra) # 4196 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    2998:	1d74849b          	addiw	s1,s1,471
    299c:	fb6498e3          	bne	s1,s6,294c <bigwrite+0x4e>
  }

  printf("bigwrite ok\n");
    29a0:	00003517          	auipc	a0,0x3
    29a4:	ee850513          	addi	a0,a0,-280 # 5888 <malloc+0x12ec>
    29a8:	00002097          	auipc	ra,0x2
    29ac:	b36080e7          	jalr	-1226(ra) # 44de <printf>
}
    29b0:	70e2                	ld	ra,56(sp)
    29b2:	7442                	ld	s0,48(sp)
    29b4:	74a2                	ld	s1,40(sp)
    29b6:	7902                	ld	s2,32(sp)
    29b8:	69e2                	ld	s3,24(sp)
    29ba:	6a42                	ld	s4,16(sp)
    29bc:	6aa2                	ld	s5,8(sp)
    29be:	6b02                	ld	s6,0(sp)
    29c0:	6121                	addi	sp,sp,64
    29c2:	8082                	ret
      printf("cannot create bigwrite\n");
    29c4:	00003517          	auipc	a0,0x3
    29c8:	e9450513          	addi	a0,a0,-364 # 5858 <malloc+0x12bc>
    29cc:	00002097          	auipc	ra,0x2
    29d0:	b12080e7          	jalr	-1262(ra) # 44de <printf>
      exit(-1);
    29d4:	557d                	li	a0,-1
    29d6:	00001097          	auipc	ra,0x1
    29da:	770080e7          	jalr	1904(ra) # 4146 <exit>
    29de:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
    29e0:	89aa                	mv	s3,a0
        printf("write(%d) ret %d\n", sz, cc);
    29e2:	864e                	mv	a2,s3
    29e4:	85a6                	mv	a1,s1
    29e6:	00003517          	auipc	a0,0x3
    29ea:	e8a50513          	addi	a0,a0,-374 # 5870 <malloc+0x12d4>
    29ee:	00002097          	auipc	ra,0x2
    29f2:	af0080e7          	jalr	-1296(ra) # 44de <printf>
        exit(-1);
    29f6:	557d                	li	a0,-1
    29f8:	00001097          	auipc	ra,0x1
    29fc:	74e080e7          	jalr	1870(ra) # 4146 <exit>

0000000000002a00 <bigfile>:

void
bigfile(void)
{
    2a00:	7179                	addi	sp,sp,-48
    2a02:	f406                	sd	ra,40(sp)
    2a04:	f022                	sd	s0,32(sp)
    2a06:	ec26                	sd	s1,24(sp)
    2a08:	e84a                	sd	s2,16(sp)
    2a0a:	e44e                	sd	s3,8(sp)
    2a0c:	e052                	sd	s4,0(sp)
    2a0e:	1800                	addi	s0,sp,48
  enum { N = 20, SZ=600 };
  int fd, i, total, cc;

  printf("bigfile test\n");
    2a10:	00003517          	auipc	a0,0x3
    2a14:	e8850513          	addi	a0,a0,-376 # 5898 <malloc+0x12fc>
    2a18:	00002097          	auipc	ra,0x2
    2a1c:	ac6080e7          	jalr	-1338(ra) # 44de <printf>

  unlink("bigfile");
    2a20:	00003517          	auipc	a0,0x3
    2a24:	e8850513          	addi	a0,a0,-376 # 58a8 <malloc+0x130c>
    2a28:	00001097          	auipc	ra,0x1
    2a2c:	76e080e7          	jalr	1902(ra) # 4196 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2a30:	20200593          	li	a1,514
    2a34:	00003517          	auipc	a0,0x3
    2a38:	e7450513          	addi	a0,a0,-396 # 58a8 <malloc+0x130c>
    2a3c:	00001097          	auipc	ra,0x1
    2a40:	74a080e7          	jalr	1866(ra) # 4186 <open>
    2a44:	89aa                	mv	s3,a0
  if(fd < 0){
    printf("cannot create bigfile");
    exit(-1);
  }
  for(i = 0; i < N; i++){
    2a46:	4481                	li	s1,0
    memset(buf, i, SZ);
    2a48:	00006917          	auipc	s2,0x6
    2a4c:	24090913          	addi	s2,s2,576 # 8c88 <buf>
  for(i = 0; i < N; i++){
    2a50:	4a51                	li	s4,20
  if(fd < 0){
    2a52:	0a054063          	bltz	a0,2af2 <bigfile+0xf2>
    memset(buf, i, SZ);
    2a56:	25800613          	li	a2,600
    2a5a:	85a6                	mv	a1,s1
    2a5c:	854a                	mv	a0,s2
    2a5e:	00001097          	auipc	ra,0x1
    2a62:	56c080e7          	jalr	1388(ra) # 3fca <memset>
    if(write(fd, buf, SZ) != SZ){
    2a66:	25800613          	li	a2,600
    2a6a:	85ca                	mv	a1,s2
    2a6c:	854e                	mv	a0,s3
    2a6e:	00001097          	auipc	ra,0x1
    2a72:	6f8080e7          	jalr	1784(ra) # 4166 <write>
    2a76:	25800793          	li	a5,600
    2a7a:	08f51963          	bne	a0,a5,2b0c <bigfile+0x10c>
  for(i = 0; i < N; i++){
    2a7e:	2485                	addiw	s1,s1,1
    2a80:	fd449be3          	bne	s1,s4,2a56 <bigfile+0x56>
      printf("write bigfile failed\n");
      exit(-1);
    }
  }
  close(fd);
    2a84:	854e                	mv	a0,s3
    2a86:	00001097          	auipc	ra,0x1
    2a8a:	6e8080e7          	jalr	1768(ra) # 416e <close>

  fd = open("bigfile", 0);
    2a8e:	4581                	li	a1,0
    2a90:	00003517          	auipc	a0,0x3
    2a94:	e1850513          	addi	a0,a0,-488 # 58a8 <malloc+0x130c>
    2a98:	00001097          	auipc	ra,0x1
    2a9c:	6ee080e7          	jalr	1774(ra) # 4186 <open>
    2aa0:	8a2a                	mv	s4,a0
  if(fd < 0){
    printf("cannot open bigfile\n");
    exit(-1);
  }
  total = 0;
    2aa2:	4981                	li	s3,0
  for(i = 0; ; i++){
    2aa4:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    2aa6:	00006917          	auipc	s2,0x6
    2aaa:	1e290913          	addi	s2,s2,482 # 8c88 <buf>
  if(fd < 0){
    2aae:	06054c63          	bltz	a0,2b26 <bigfile+0x126>
    cc = read(fd, buf, SZ/2);
    2ab2:	12c00613          	li	a2,300
    2ab6:	85ca                	mv	a1,s2
    2ab8:	8552                	mv	a0,s4
    2aba:	00001097          	auipc	ra,0x1
    2abe:	6a4080e7          	jalr	1700(ra) # 415e <read>
    if(cc < 0){
    2ac2:	06054f63          	bltz	a0,2b40 <bigfile+0x140>
      printf("read bigfile failed\n");
      exit(-1);
    }
    if(cc == 0)
    2ac6:	c561                	beqz	a0,2b8e <bigfile+0x18e>
      break;
    if(cc != SZ/2){
    2ac8:	12c00793          	li	a5,300
    2acc:	08f51763          	bne	a0,a5,2b5a <bigfile+0x15a>
      printf("short read bigfile\n");
      exit(-1);
    }
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    2ad0:	01f4d79b          	srliw	a5,s1,0x1f
    2ad4:	9fa5                	addw	a5,a5,s1
    2ad6:	4017d79b          	sraiw	a5,a5,0x1
    2ada:	00094703          	lbu	a4,0(s2)
    2ade:	08f71b63          	bne	a4,a5,2b74 <bigfile+0x174>
    2ae2:	12b94703          	lbu	a4,299(s2)
    2ae6:	08f71763          	bne	a4,a5,2b74 <bigfile+0x174>
      printf("read bigfile wrong data\n");
      exit(-1);
    }
    total += cc;
    2aea:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    2aee:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    2af0:	b7c9                	j	2ab2 <bigfile+0xb2>
    printf("cannot create bigfile");
    2af2:	00003517          	auipc	a0,0x3
    2af6:	dbe50513          	addi	a0,a0,-578 # 58b0 <malloc+0x1314>
    2afa:	00002097          	auipc	ra,0x2
    2afe:	9e4080e7          	jalr	-1564(ra) # 44de <printf>
    exit(-1);
    2b02:	557d                	li	a0,-1
    2b04:	00001097          	auipc	ra,0x1
    2b08:	642080e7          	jalr	1602(ra) # 4146 <exit>
      printf("write bigfile failed\n");
    2b0c:	00003517          	auipc	a0,0x3
    2b10:	dbc50513          	addi	a0,a0,-580 # 58c8 <malloc+0x132c>
    2b14:	00002097          	auipc	ra,0x2
    2b18:	9ca080e7          	jalr	-1590(ra) # 44de <printf>
      exit(-1);
    2b1c:	557d                	li	a0,-1
    2b1e:	00001097          	auipc	ra,0x1
    2b22:	628080e7          	jalr	1576(ra) # 4146 <exit>
    printf("cannot open bigfile\n");
    2b26:	00003517          	auipc	a0,0x3
    2b2a:	dba50513          	addi	a0,a0,-582 # 58e0 <malloc+0x1344>
    2b2e:	00002097          	auipc	ra,0x2
    2b32:	9b0080e7          	jalr	-1616(ra) # 44de <printf>
    exit(-1);
    2b36:	557d                	li	a0,-1
    2b38:	00001097          	auipc	ra,0x1
    2b3c:	60e080e7          	jalr	1550(ra) # 4146 <exit>
      printf("read bigfile failed\n");
    2b40:	00003517          	auipc	a0,0x3
    2b44:	db850513          	addi	a0,a0,-584 # 58f8 <malloc+0x135c>
    2b48:	00002097          	auipc	ra,0x2
    2b4c:	996080e7          	jalr	-1642(ra) # 44de <printf>
      exit(-1);
    2b50:	557d                	li	a0,-1
    2b52:	00001097          	auipc	ra,0x1
    2b56:	5f4080e7          	jalr	1524(ra) # 4146 <exit>
      printf("short read bigfile\n");
    2b5a:	00003517          	auipc	a0,0x3
    2b5e:	db650513          	addi	a0,a0,-586 # 5910 <malloc+0x1374>
    2b62:	00002097          	auipc	ra,0x2
    2b66:	97c080e7          	jalr	-1668(ra) # 44de <printf>
      exit(-1);
    2b6a:	557d                	li	a0,-1
    2b6c:	00001097          	auipc	ra,0x1
    2b70:	5da080e7          	jalr	1498(ra) # 4146 <exit>
      printf("read bigfile wrong data\n");
    2b74:	00003517          	auipc	a0,0x3
    2b78:	db450513          	addi	a0,a0,-588 # 5928 <malloc+0x138c>
    2b7c:	00002097          	auipc	ra,0x2
    2b80:	962080e7          	jalr	-1694(ra) # 44de <printf>
      exit(-1);
    2b84:	557d                	li	a0,-1
    2b86:	00001097          	auipc	ra,0x1
    2b8a:	5c0080e7          	jalr	1472(ra) # 4146 <exit>
  }
  close(fd);
    2b8e:	8552                	mv	a0,s4
    2b90:	00001097          	auipc	ra,0x1
    2b94:	5de080e7          	jalr	1502(ra) # 416e <close>
  if(total != N*SZ){
    2b98:	678d                	lui	a5,0x3
    2b9a:	ee078793          	addi	a5,a5,-288 # 2ee0 <dirfile+0x12>
    2b9e:	02f99a63          	bne	s3,a5,2bd2 <bigfile+0x1d2>
    printf("read bigfile wrong total\n");
    exit(-1);
  }
  unlink("bigfile");
    2ba2:	00003517          	auipc	a0,0x3
    2ba6:	d0650513          	addi	a0,a0,-762 # 58a8 <malloc+0x130c>
    2baa:	00001097          	auipc	ra,0x1
    2bae:	5ec080e7          	jalr	1516(ra) # 4196 <unlink>

  printf("bigfile test ok\n");
    2bb2:	00003517          	auipc	a0,0x3
    2bb6:	db650513          	addi	a0,a0,-586 # 5968 <malloc+0x13cc>
    2bba:	00002097          	auipc	ra,0x2
    2bbe:	924080e7          	jalr	-1756(ra) # 44de <printf>
}
    2bc2:	70a2                	ld	ra,40(sp)
    2bc4:	7402                	ld	s0,32(sp)
    2bc6:	64e2                	ld	s1,24(sp)
    2bc8:	6942                	ld	s2,16(sp)
    2bca:	69a2                	ld	s3,8(sp)
    2bcc:	6a02                	ld	s4,0(sp)
    2bce:	6145                	addi	sp,sp,48
    2bd0:	8082                	ret
    printf("read bigfile wrong total\n");
    2bd2:	00003517          	auipc	a0,0x3
    2bd6:	d7650513          	addi	a0,a0,-650 # 5948 <malloc+0x13ac>
    2bda:	00002097          	auipc	ra,0x2
    2bde:	904080e7          	jalr	-1788(ra) # 44de <printf>
    exit(-1);
    2be2:	557d                	li	a0,-1
    2be4:	00001097          	auipc	ra,0x1
    2be8:	562080e7          	jalr	1378(ra) # 4146 <exit>

0000000000002bec <fourteen>:

void
fourteen(void)
{
    2bec:	1141                	addi	sp,sp,-16
    2bee:	e406                	sd	ra,8(sp)
    2bf0:	e022                	sd	s0,0(sp)
    2bf2:	0800                	addi	s0,sp,16
  int fd;

  // DIRSIZ is 14.
  printf("fourteen test\n");
    2bf4:	00003517          	auipc	a0,0x3
    2bf8:	d8c50513          	addi	a0,a0,-628 # 5980 <malloc+0x13e4>
    2bfc:	00002097          	auipc	ra,0x2
    2c00:	8e2080e7          	jalr	-1822(ra) # 44de <printf>

  if(mkdir("12345678901234") != 0){
    2c04:	00003517          	auipc	a0,0x3
    2c08:	f3c50513          	addi	a0,a0,-196 # 5b40 <malloc+0x15a4>
    2c0c:	00001097          	auipc	ra,0x1
    2c10:	5a2080e7          	jalr	1442(ra) # 41ae <mkdir>
    2c14:	e559                	bnez	a0,2ca2 <fourteen+0xb6>
    printf("mkdir 12345678901234 failed\n");
    exit(-1);
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2c16:	00003517          	auipc	a0,0x3
    2c1a:	d9a50513          	addi	a0,a0,-614 # 59b0 <malloc+0x1414>
    2c1e:	00001097          	auipc	ra,0x1
    2c22:	590080e7          	jalr	1424(ra) # 41ae <mkdir>
    2c26:	e959                	bnez	a0,2cbc <fourteen+0xd0>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    exit(-1);
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c28:	20000593          	li	a1,512
    2c2c:	00003517          	auipc	a0,0x3
    2c30:	dd450513          	addi	a0,a0,-556 # 5a00 <malloc+0x1464>
    2c34:	00001097          	auipc	ra,0x1
    2c38:	552080e7          	jalr	1362(ra) # 4186 <open>
  if(fd < 0){
    2c3c:	08054d63          	bltz	a0,2cd6 <fourteen+0xea>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    exit(-1);
  }
  close(fd);
    2c40:	00001097          	auipc	ra,0x1
    2c44:	52e080e7          	jalr	1326(ra) # 416e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c48:	4581                	li	a1,0
    2c4a:	00003517          	auipc	a0,0x3
    2c4e:	e2650513          	addi	a0,a0,-474 # 5a70 <malloc+0x14d4>
    2c52:	00001097          	auipc	ra,0x1
    2c56:	534080e7          	jalr	1332(ra) # 4186 <open>
  if(fd < 0){
    2c5a:	08054b63          	bltz	a0,2cf0 <fourteen+0x104>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    exit(-1);
  }
  close(fd);
    2c5e:	00001097          	auipc	ra,0x1
    2c62:	510080e7          	jalr	1296(ra) # 416e <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2c66:	00003517          	auipc	a0,0x3
    2c6a:	e7a50513          	addi	a0,a0,-390 # 5ae0 <malloc+0x1544>
    2c6e:	00001097          	auipc	ra,0x1
    2c72:	540080e7          	jalr	1344(ra) # 41ae <mkdir>
    2c76:	c951                	beqz	a0,2d0a <fourteen+0x11e>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    exit(-1);
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2c78:	00003517          	auipc	a0,0x3
    2c7c:	eb850513          	addi	a0,a0,-328 # 5b30 <malloc+0x1594>
    2c80:	00001097          	auipc	ra,0x1
    2c84:	52e080e7          	jalr	1326(ra) # 41ae <mkdir>
    2c88:	cd51                	beqz	a0,2d24 <fourteen+0x138>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    exit(-1);
  }

  printf("fourteen ok\n");
    2c8a:	00003517          	auipc	a0,0x3
    2c8e:	efe50513          	addi	a0,a0,-258 # 5b88 <malloc+0x15ec>
    2c92:	00002097          	auipc	ra,0x2
    2c96:	84c080e7          	jalr	-1972(ra) # 44de <printf>
}
    2c9a:	60a2                	ld	ra,8(sp)
    2c9c:	6402                	ld	s0,0(sp)
    2c9e:	0141                	addi	sp,sp,16
    2ca0:	8082                	ret
    printf("mkdir 12345678901234 failed\n");
    2ca2:	00003517          	auipc	a0,0x3
    2ca6:	cee50513          	addi	a0,a0,-786 # 5990 <malloc+0x13f4>
    2caa:	00002097          	auipc	ra,0x2
    2cae:	834080e7          	jalr	-1996(ra) # 44de <printf>
    exit(-1);
    2cb2:	557d                	li	a0,-1
    2cb4:	00001097          	auipc	ra,0x1
    2cb8:	492080e7          	jalr	1170(ra) # 4146 <exit>
    printf("mkdir 12345678901234/123456789012345 failed\n");
    2cbc:	00003517          	auipc	a0,0x3
    2cc0:	d1450513          	addi	a0,a0,-748 # 59d0 <malloc+0x1434>
    2cc4:	00002097          	auipc	ra,0x2
    2cc8:	81a080e7          	jalr	-2022(ra) # 44de <printf>
    exit(-1);
    2ccc:	557d                	li	a0,-1
    2cce:	00001097          	auipc	ra,0x1
    2cd2:	478080e7          	jalr	1144(ra) # 4146 <exit>
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
    2cd6:	00003517          	auipc	a0,0x3
    2cda:	d5a50513          	addi	a0,a0,-678 # 5a30 <malloc+0x1494>
    2cde:	00002097          	auipc	ra,0x2
    2ce2:	800080e7          	jalr	-2048(ra) # 44de <printf>
    exit(-1);
    2ce6:	557d                	li	a0,-1
    2ce8:	00001097          	auipc	ra,0x1
    2cec:	45e080e7          	jalr	1118(ra) # 4146 <exit>
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
    2cf0:	00003517          	auipc	a0,0x3
    2cf4:	db050513          	addi	a0,a0,-592 # 5aa0 <malloc+0x1504>
    2cf8:	00001097          	auipc	ra,0x1
    2cfc:	7e6080e7          	jalr	2022(ra) # 44de <printf>
    exit(-1);
    2d00:	557d                	li	a0,-1
    2d02:	00001097          	auipc	ra,0x1
    2d06:	444080e7          	jalr	1092(ra) # 4146 <exit>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
    2d0a:	00003517          	auipc	a0,0x3
    2d0e:	df650513          	addi	a0,a0,-522 # 5b00 <malloc+0x1564>
    2d12:	00001097          	auipc	ra,0x1
    2d16:	7cc080e7          	jalr	1996(ra) # 44de <printf>
    exit(-1);
    2d1a:	557d                	li	a0,-1
    2d1c:	00001097          	auipc	ra,0x1
    2d20:	42a080e7          	jalr	1066(ra) # 4146 <exit>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
    2d24:	00003517          	auipc	a0,0x3
    2d28:	e2c50513          	addi	a0,a0,-468 # 5b50 <malloc+0x15b4>
    2d2c:	00001097          	auipc	ra,0x1
    2d30:	7b2080e7          	jalr	1970(ra) # 44de <printf>
    exit(-1);
    2d34:	557d                	li	a0,-1
    2d36:	00001097          	auipc	ra,0x1
    2d3a:	410080e7          	jalr	1040(ra) # 4146 <exit>

0000000000002d3e <rmdot>:

void
rmdot(void)
{
    2d3e:	1141                	addi	sp,sp,-16
    2d40:	e406                	sd	ra,8(sp)
    2d42:	e022                	sd	s0,0(sp)
    2d44:	0800                	addi	s0,sp,16
  printf("rmdot test\n");
    2d46:	00003517          	auipc	a0,0x3
    2d4a:	e5250513          	addi	a0,a0,-430 # 5b98 <malloc+0x15fc>
    2d4e:	00001097          	auipc	ra,0x1
    2d52:	790080e7          	jalr	1936(ra) # 44de <printf>
  if(mkdir("dots") != 0){
    2d56:	00003517          	auipc	a0,0x3
    2d5a:	e5250513          	addi	a0,a0,-430 # 5ba8 <malloc+0x160c>
    2d5e:	00001097          	auipc	ra,0x1
    2d62:	450080e7          	jalr	1104(ra) # 41ae <mkdir>
    2d66:	ed41                	bnez	a0,2dfe <rmdot+0xc0>
    printf("mkdir dots failed\n");
    exit(-1);
  }
  if(chdir("dots") != 0){
    2d68:	00003517          	auipc	a0,0x3
    2d6c:	e4050513          	addi	a0,a0,-448 # 5ba8 <malloc+0x160c>
    2d70:	00001097          	auipc	ra,0x1
    2d74:	446080e7          	jalr	1094(ra) # 41b6 <chdir>
    2d78:	e145                	bnez	a0,2e18 <rmdot+0xda>
    printf("chdir dots failed\n");
    exit(-1);
  }
  if(unlink(".") == 0){
    2d7a:	00002517          	auipc	a0,0x2
    2d7e:	41e50513          	addi	a0,a0,1054 # 5198 <malloc+0xbfc>
    2d82:	00001097          	auipc	ra,0x1
    2d86:	414080e7          	jalr	1044(ra) # 4196 <unlink>
    2d8a:	c545                	beqz	a0,2e32 <rmdot+0xf4>
    printf("rm . worked!\n");
    exit(-1);
  }
  if(unlink("..") == 0){
    2d8c:	00002517          	auipc	a0,0x2
    2d90:	ddc50513          	addi	a0,a0,-548 # 4b68 <malloc+0x5cc>
    2d94:	00001097          	auipc	ra,0x1
    2d98:	402080e7          	jalr	1026(ra) # 4196 <unlink>
    2d9c:	c945                	beqz	a0,2e4c <rmdot+0x10e>
    printf("rm .. worked!\n");
    exit(-1);
  }
  if(chdir("/") != 0){
    2d9e:	00002517          	auipc	a0,0x2
    2da2:	97a50513          	addi	a0,a0,-1670 # 4718 <malloc+0x17c>
    2da6:	00001097          	auipc	ra,0x1
    2daa:	410080e7          	jalr	1040(ra) # 41b6 <chdir>
    2dae:	ed45                	bnez	a0,2e66 <rmdot+0x128>
    printf("chdir / failed\n");
    exit(-1);
  }
  if(unlink("dots/.") == 0){
    2db0:	00003517          	auipc	a0,0x3
    2db4:	e5050513          	addi	a0,a0,-432 # 5c00 <malloc+0x1664>
    2db8:	00001097          	auipc	ra,0x1
    2dbc:	3de080e7          	jalr	990(ra) # 4196 <unlink>
    2dc0:	c161                	beqz	a0,2e80 <rmdot+0x142>
    printf("unlink dots/. worked!\n");
    exit(-1);
  }
  if(unlink("dots/..") == 0){
    2dc2:	00003517          	auipc	a0,0x3
    2dc6:	e5e50513          	addi	a0,a0,-418 # 5c20 <malloc+0x1684>
    2dca:	00001097          	auipc	ra,0x1
    2dce:	3cc080e7          	jalr	972(ra) # 4196 <unlink>
    2dd2:	c561                	beqz	a0,2e9a <rmdot+0x15c>
    printf("unlink dots/.. worked!\n");
    exit(-1);
  }
  if(unlink("dots") != 0){
    2dd4:	00003517          	auipc	a0,0x3
    2dd8:	dd450513          	addi	a0,a0,-556 # 5ba8 <malloc+0x160c>
    2ddc:	00001097          	auipc	ra,0x1
    2de0:	3ba080e7          	jalr	954(ra) # 4196 <unlink>
    2de4:	e961                	bnez	a0,2eb4 <rmdot+0x176>
    printf("unlink dots failed!\n");
    exit(-1);
  }
  printf("rmdot ok\n");
    2de6:	00003517          	auipc	a0,0x3
    2dea:	e7250513          	addi	a0,a0,-398 # 5c58 <malloc+0x16bc>
    2dee:	00001097          	auipc	ra,0x1
    2df2:	6f0080e7          	jalr	1776(ra) # 44de <printf>
}
    2df6:	60a2                	ld	ra,8(sp)
    2df8:	6402                	ld	s0,0(sp)
    2dfa:	0141                	addi	sp,sp,16
    2dfc:	8082                	ret
    printf("mkdir dots failed\n");
    2dfe:	00003517          	auipc	a0,0x3
    2e02:	db250513          	addi	a0,a0,-590 # 5bb0 <malloc+0x1614>
    2e06:	00001097          	auipc	ra,0x1
    2e0a:	6d8080e7          	jalr	1752(ra) # 44de <printf>
    exit(-1);
    2e0e:	557d                	li	a0,-1
    2e10:	00001097          	auipc	ra,0x1
    2e14:	336080e7          	jalr	822(ra) # 4146 <exit>
    printf("chdir dots failed\n");
    2e18:	00003517          	auipc	a0,0x3
    2e1c:	db050513          	addi	a0,a0,-592 # 5bc8 <malloc+0x162c>
    2e20:	00001097          	auipc	ra,0x1
    2e24:	6be080e7          	jalr	1726(ra) # 44de <printf>
    exit(-1);
    2e28:	557d                	li	a0,-1
    2e2a:	00001097          	auipc	ra,0x1
    2e2e:	31c080e7          	jalr	796(ra) # 4146 <exit>
    printf("rm . worked!\n");
    2e32:	00003517          	auipc	a0,0x3
    2e36:	dae50513          	addi	a0,a0,-594 # 5be0 <malloc+0x1644>
    2e3a:	00001097          	auipc	ra,0x1
    2e3e:	6a4080e7          	jalr	1700(ra) # 44de <printf>
    exit(-1);
    2e42:	557d                	li	a0,-1
    2e44:	00001097          	auipc	ra,0x1
    2e48:	302080e7          	jalr	770(ra) # 4146 <exit>
    printf("rm .. worked!\n");
    2e4c:	00003517          	auipc	a0,0x3
    2e50:	da450513          	addi	a0,a0,-604 # 5bf0 <malloc+0x1654>
    2e54:	00001097          	auipc	ra,0x1
    2e58:	68a080e7          	jalr	1674(ra) # 44de <printf>
    exit(-1);
    2e5c:	557d                	li	a0,-1
    2e5e:	00001097          	auipc	ra,0x1
    2e62:	2e8080e7          	jalr	744(ra) # 4146 <exit>
    printf("chdir / failed\n");
    2e66:	00002517          	auipc	a0,0x2
    2e6a:	8ba50513          	addi	a0,a0,-1862 # 4720 <malloc+0x184>
    2e6e:	00001097          	auipc	ra,0x1
    2e72:	670080e7          	jalr	1648(ra) # 44de <printf>
    exit(-1);
    2e76:	557d                	li	a0,-1
    2e78:	00001097          	auipc	ra,0x1
    2e7c:	2ce080e7          	jalr	718(ra) # 4146 <exit>
    printf("unlink dots/. worked!\n");
    2e80:	00003517          	auipc	a0,0x3
    2e84:	d8850513          	addi	a0,a0,-632 # 5c08 <malloc+0x166c>
    2e88:	00001097          	auipc	ra,0x1
    2e8c:	656080e7          	jalr	1622(ra) # 44de <printf>
    exit(-1);
    2e90:	557d                	li	a0,-1
    2e92:	00001097          	auipc	ra,0x1
    2e96:	2b4080e7          	jalr	692(ra) # 4146 <exit>
    printf("unlink dots/.. worked!\n");
    2e9a:	00003517          	auipc	a0,0x3
    2e9e:	d8e50513          	addi	a0,a0,-626 # 5c28 <malloc+0x168c>
    2ea2:	00001097          	auipc	ra,0x1
    2ea6:	63c080e7          	jalr	1596(ra) # 44de <printf>
    exit(-1);
    2eaa:	557d                	li	a0,-1
    2eac:	00001097          	auipc	ra,0x1
    2eb0:	29a080e7          	jalr	666(ra) # 4146 <exit>
    printf("unlink dots failed!\n");
    2eb4:	00003517          	auipc	a0,0x3
    2eb8:	d8c50513          	addi	a0,a0,-628 # 5c40 <malloc+0x16a4>
    2ebc:	00001097          	auipc	ra,0x1
    2ec0:	622080e7          	jalr	1570(ra) # 44de <printf>
    exit(-1);
    2ec4:	557d                	li	a0,-1
    2ec6:	00001097          	auipc	ra,0x1
    2eca:	280080e7          	jalr	640(ra) # 4146 <exit>

0000000000002ece <dirfile>:

void
dirfile(void)
{
    2ece:	1101                	addi	sp,sp,-32
    2ed0:	ec06                	sd	ra,24(sp)
    2ed2:	e822                	sd	s0,16(sp)
    2ed4:	e426                	sd	s1,8(sp)
    2ed6:	1000                	addi	s0,sp,32
  int fd;

  printf("dir vs file\n");
    2ed8:	00003517          	auipc	a0,0x3
    2edc:	d9050513          	addi	a0,a0,-624 # 5c68 <malloc+0x16cc>
    2ee0:	00001097          	auipc	ra,0x1
    2ee4:	5fe080e7          	jalr	1534(ra) # 44de <printf>

  fd = open("dirfile", O_CREATE);
    2ee8:	20000593          	li	a1,512
    2eec:	00003517          	auipc	a0,0x3
    2ef0:	d8c50513          	addi	a0,a0,-628 # 5c78 <malloc+0x16dc>
    2ef4:	00001097          	auipc	ra,0x1
    2ef8:	292080e7          	jalr	658(ra) # 4186 <open>
  if(fd < 0){
    2efc:	10054563          	bltz	a0,3006 <dirfile+0x138>
    printf("create dirfile failed\n");
    exit(-1);
  }
  close(fd);
    2f00:	00001097          	auipc	ra,0x1
    2f04:	26e080e7          	jalr	622(ra) # 416e <close>
  if(chdir("dirfile") == 0){
    2f08:	00003517          	auipc	a0,0x3
    2f0c:	d7050513          	addi	a0,a0,-656 # 5c78 <malloc+0x16dc>
    2f10:	00001097          	auipc	ra,0x1
    2f14:	2a6080e7          	jalr	678(ra) # 41b6 <chdir>
    2f18:	10050463          	beqz	a0,3020 <dirfile+0x152>
    printf("chdir dirfile succeeded!\n");
    exit(-1);
  }
  fd = open("dirfile/xx", 0);
    2f1c:	4581                	li	a1,0
    2f1e:	00003517          	auipc	a0,0x3
    2f22:	d9a50513          	addi	a0,a0,-614 # 5cb8 <malloc+0x171c>
    2f26:	00001097          	auipc	ra,0x1
    2f2a:	260080e7          	jalr	608(ra) # 4186 <open>
  if(fd >= 0){
    2f2e:	10055663          	bgez	a0,303a <dirfile+0x16c>
    printf("create dirfile/xx succeeded!\n");
    exit(-1);
  }
  fd = open("dirfile/xx", O_CREATE);
    2f32:	20000593          	li	a1,512
    2f36:	00003517          	auipc	a0,0x3
    2f3a:	d8250513          	addi	a0,a0,-638 # 5cb8 <malloc+0x171c>
    2f3e:	00001097          	auipc	ra,0x1
    2f42:	248080e7          	jalr	584(ra) # 4186 <open>
  if(fd >= 0){
    2f46:	10055763          	bgez	a0,3054 <dirfile+0x186>
    printf("create dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(mkdir("dirfile/xx") == 0){
    2f4a:	00003517          	auipc	a0,0x3
    2f4e:	d6e50513          	addi	a0,a0,-658 # 5cb8 <malloc+0x171c>
    2f52:	00001097          	auipc	ra,0x1
    2f56:	25c080e7          	jalr	604(ra) # 41ae <mkdir>
    2f5a:	10050a63          	beqz	a0,306e <dirfile+0x1a0>
    printf("mkdir dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(unlink("dirfile/xx") == 0){
    2f5e:	00003517          	auipc	a0,0x3
    2f62:	d5a50513          	addi	a0,a0,-678 # 5cb8 <malloc+0x171c>
    2f66:	00001097          	auipc	ra,0x1
    2f6a:	230080e7          	jalr	560(ra) # 4196 <unlink>
    2f6e:	10050d63          	beqz	a0,3088 <dirfile+0x1ba>
    printf("unlink dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(link("README", "dirfile/xx") == 0){
    2f72:	00003597          	auipc	a1,0x3
    2f76:	d4658593          	addi	a1,a1,-698 # 5cb8 <malloc+0x171c>
    2f7a:	00003517          	auipc	a0,0x3
    2f7e:	dae50513          	addi	a0,a0,-594 # 5d28 <malloc+0x178c>
    2f82:	00001097          	auipc	ra,0x1
    2f86:	224080e7          	jalr	548(ra) # 41a6 <link>
    2f8a:	10050c63          	beqz	a0,30a2 <dirfile+0x1d4>
    printf("link to dirfile/xx succeeded!\n");
    exit(-1);
  }
  if(unlink("dirfile") != 0){
    2f8e:	00003517          	auipc	a0,0x3
    2f92:	cea50513          	addi	a0,a0,-790 # 5c78 <malloc+0x16dc>
    2f96:	00001097          	auipc	ra,0x1
    2f9a:	200080e7          	jalr	512(ra) # 4196 <unlink>
    2f9e:	10051f63          	bnez	a0,30bc <dirfile+0x1ee>
    printf("unlink dirfile failed!\n");
    exit(-1);
  }

  fd = open(".", O_RDWR);
    2fa2:	4589                	li	a1,2
    2fa4:	00002517          	auipc	a0,0x2
    2fa8:	1f450513          	addi	a0,a0,500 # 5198 <malloc+0xbfc>
    2fac:	00001097          	auipc	ra,0x1
    2fb0:	1da080e7          	jalr	474(ra) # 4186 <open>
  if(fd >= 0){
    2fb4:	12055163          	bgez	a0,30d6 <dirfile+0x208>
    printf("open . for writing succeeded!\n");
    exit(-1);
  }
  fd = open(".", 0);
    2fb8:	4581                	li	a1,0
    2fba:	00002517          	auipc	a0,0x2
    2fbe:	1de50513          	addi	a0,a0,478 # 5198 <malloc+0xbfc>
    2fc2:	00001097          	auipc	ra,0x1
    2fc6:	1c4080e7          	jalr	452(ra) # 4186 <open>
    2fca:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    2fcc:	4605                	li	a2,1
    2fce:	00002597          	auipc	a1,0x2
    2fd2:	c9258593          	addi	a1,a1,-878 # 4c60 <malloc+0x6c4>
    2fd6:	00001097          	auipc	ra,0x1
    2fda:	190080e7          	jalr	400(ra) # 4166 <write>
    2fde:	10a04963          	bgtz	a0,30f0 <dirfile+0x222>
    printf("write . succeeded!\n");
    exit(-1);
  }
  close(fd);
    2fe2:	8526                	mv	a0,s1
    2fe4:	00001097          	auipc	ra,0x1
    2fe8:	18a080e7          	jalr	394(ra) # 416e <close>

  printf("dir vs file OK\n");
    2fec:	00003517          	auipc	a0,0x3
    2ff0:	db450513          	addi	a0,a0,-588 # 5da0 <malloc+0x1804>
    2ff4:	00001097          	auipc	ra,0x1
    2ff8:	4ea080e7          	jalr	1258(ra) # 44de <printf>
}
    2ffc:	60e2                	ld	ra,24(sp)
    2ffe:	6442                	ld	s0,16(sp)
    3000:	64a2                	ld	s1,8(sp)
    3002:	6105                	addi	sp,sp,32
    3004:	8082                	ret
    printf("create dirfile failed\n");
    3006:	00003517          	auipc	a0,0x3
    300a:	c7a50513          	addi	a0,a0,-902 # 5c80 <malloc+0x16e4>
    300e:	00001097          	auipc	ra,0x1
    3012:	4d0080e7          	jalr	1232(ra) # 44de <printf>
    exit(-1);
    3016:	557d                	li	a0,-1
    3018:	00001097          	auipc	ra,0x1
    301c:	12e080e7          	jalr	302(ra) # 4146 <exit>
    printf("chdir dirfile succeeded!\n");
    3020:	00003517          	auipc	a0,0x3
    3024:	c7850513          	addi	a0,a0,-904 # 5c98 <malloc+0x16fc>
    3028:	00001097          	auipc	ra,0x1
    302c:	4b6080e7          	jalr	1206(ra) # 44de <printf>
    exit(-1);
    3030:	557d                	li	a0,-1
    3032:	00001097          	auipc	ra,0x1
    3036:	114080e7          	jalr	276(ra) # 4146 <exit>
    printf("create dirfile/xx succeeded!\n");
    303a:	00003517          	auipc	a0,0x3
    303e:	c8e50513          	addi	a0,a0,-882 # 5cc8 <malloc+0x172c>
    3042:	00001097          	auipc	ra,0x1
    3046:	49c080e7          	jalr	1180(ra) # 44de <printf>
    exit(-1);
    304a:	557d                	li	a0,-1
    304c:	00001097          	auipc	ra,0x1
    3050:	0fa080e7          	jalr	250(ra) # 4146 <exit>
    printf("create dirfile/xx succeeded!\n");
    3054:	00003517          	auipc	a0,0x3
    3058:	c7450513          	addi	a0,a0,-908 # 5cc8 <malloc+0x172c>
    305c:	00001097          	auipc	ra,0x1
    3060:	482080e7          	jalr	1154(ra) # 44de <printf>
    exit(-1);
    3064:	557d                	li	a0,-1
    3066:	00001097          	auipc	ra,0x1
    306a:	0e0080e7          	jalr	224(ra) # 4146 <exit>
    printf("mkdir dirfile/xx succeeded!\n");
    306e:	00003517          	auipc	a0,0x3
    3072:	c7a50513          	addi	a0,a0,-902 # 5ce8 <malloc+0x174c>
    3076:	00001097          	auipc	ra,0x1
    307a:	468080e7          	jalr	1128(ra) # 44de <printf>
    exit(-1);
    307e:	557d                	li	a0,-1
    3080:	00001097          	auipc	ra,0x1
    3084:	0c6080e7          	jalr	198(ra) # 4146 <exit>
    printf("unlink dirfile/xx succeeded!\n");
    3088:	00003517          	auipc	a0,0x3
    308c:	c8050513          	addi	a0,a0,-896 # 5d08 <malloc+0x176c>
    3090:	00001097          	auipc	ra,0x1
    3094:	44e080e7          	jalr	1102(ra) # 44de <printf>
    exit(-1);
    3098:	557d                	li	a0,-1
    309a:	00001097          	auipc	ra,0x1
    309e:	0ac080e7          	jalr	172(ra) # 4146 <exit>
    printf("link to dirfile/xx succeeded!\n");
    30a2:	00003517          	auipc	a0,0x3
    30a6:	c8e50513          	addi	a0,a0,-882 # 5d30 <malloc+0x1794>
    30aa:	00001097          	auipc	ra,0x1
    30ae:	434080e7          	jalr	1076(ra) # 44de <printf>
    exit(-1);
    30b2:	557d                	li	a0,-1
    30b4:	00001097          	auipc	ra,0x1
    30b8:	092080e7          	jalr	146(ra) # 4146 <exit>
    printf("unlink dirfile failed!\n");
    30bc:	00003517          	auipc	a0,0x3
    30c0:	c9450513          	addi	a0,a0,-876 # 5d50 <malloc+0x17b4>
    30c4:	00001097          	auipc	ra,0x1
    30c8:	41a080e7          	jalr	1050(ra) # 44de <printf>
    exit(-1);
    30cc:	557d                	li	a0,-1
    30ce:	00001097          	auipc	ra,0x1
    30d2:	078080e7          	jalr	120(ra) # 4146 <exit>
    printf("open . for writing succeeded!\n");
    30d6:	00003517          	auipc	a0,0x3
    30da:	c9250513          	addi	a0,a0,-878 # 5d68 <malloc+0x17cc>
    30de:	00001097          	auipc	ra,0x1
    30e2:	400080e7          	jalr	1024(ra) # 44de <printf>
    exit(-1);
    30e6:	557d                	li	a0,-1
    30e8:	00001097          	auipc	ra,0x1
    30ec:	05e080e7          	jalr	94(ra) # 4146 <exit>
    printf("write . succeeded!\n");
    30f0:	00003517          	auipc	a0,0x3
    30f4:	c9850513          	addi	a0,a0,-872 # 5d88 <malloc+0x17ec>
    30f8:	00001097          	auipc	ra,0x1
    30fc:	3e6080e7          	jalr	998(ra) # 44de <printf>
    exit(-1);
    3100:	557d                	li	a0,-1
    3102:	00001097          	auipc	ra,0x1
    3106:	044080e7          	jalr	68(ra) # 4146 <exit>

000000000000310a <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    310a:	7139                	addi	sp,sp,-64
    310c:	fc06                	sd	ra,56(sp)
    310e:	f822                	sd	s0,48(sp)
    3110:	f426                	sd	s1,40(sp)
    3112:	f04a                	sd	s2,32(sp)
    3114:	ec4e                	sd	s3,24(sp)
    3116:	e852                	sd	s4,16(sp)
    3118:	e456                	sd	s5,8(sp)
    311a:	0080                	addi	s0,sp,64
  int i, fd;

  printf("empty file name\n");
    311c:	00003517          	auipc	a0,0x3
    3120:	c9450513          	addi	a0,a0,-876 # 5db0 <malloc+0x1814>
    3124:	00001097          	auipc	ra,0x1
    3128:	3ba080e7          	jalr	954(ra) # 44de <printf>
    312c:	03300913          	li	s2,51

  for(i = 0; i < NINODE + 1; i++){
    if(mkdir("irefd") != 0){
    3130:	00003a17          	auipc	s4,0x3
    3134:	c98a0a13          	addi	s4,s4,-872 # 5dc8 <malloc+0x182c>
    if(chdir("irefd") != 0){
      printf("chdir irefd failed\n");
      exit(-1);
    }

    mkdir("");
    3138:	00003497          	auipc	s1,0x3
    313c:	a4848493          	addi	s1,s1,-1464 # 5b80 <malloc+0x15e4>
    link("README", "");
    3140:	00003a97          	auipc	s5,0x3
    3144:	be8a8a93          	addi	s5,s5,-1048 # 5d28 <malloc+0x178c>
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    3148:	00003997          	auipc	s3,0x3
    314c:	b7898993          	addi	s3,s3,-1160 # 5cc0 <malloc+0x1724>
    3150:	a881                	j	31a0 <iref+0x96>
      printf("mkdir irefd failed\n");
    3152:	00003517          	auipc	a0,0x3
    3156:	c7e50513          	addi	a0,a0,-898 # 5dd0 <malloc+0x1834>
    315a:	00001097          	auipc	ra,0x1
    315e:	384080e7          	jalr	900(ra) # 44de <printf>
      exit(-1);
    3162:	557d                	li	a0,-1
    3164:	00001097          	auipc	ra,0x1
    3168:	fe2080e7          	jalr	-30(ra) # 4146 <exit>
      printf("chdir irefd failed\n");
    316c:	00003517          	auipc	a0,0x3
    3170:	c7c50513          	addi	a0,a0,-900 # 5de8 <malloc+0x184c>
    3174:	00001097          	auipc	ra,0x1
    3178:	36a080e7          	jalr	874(ra) # 44de <printf>
      exit(-1);
    317c:	557d                	li	a0,-1
    317e:	00001097          	auipc	ra,0x1
    3182:	fc8080e7          	jalr	-56(ra) # 4146 <exit>
      close(fd);
    3186:	00001097          	auipc	ra,0x1
    318a:	fe8080e7          	jalr	-24(ra) # 416e <close>
    318e:	a889                	j	31e0 <iref+0xd6>
    if(fd >= 0)
      close(fd);
    unlink("xx");
    3190:	854e                	mv	a0,s3
    3192:	00001097          	auipc	ra,0x1
    3196:	004080e7          	jalr	4(ra) # 4196 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    319a:	397d                	addiw	s2,s2,-1
    319c:	06090063          	beqz	s2,31fc <iref+0xf2>
    if(mkdir("irefd") != 0){
    31a0:	8552                	mv	a0,s4
    31a2:	00001097          	auipc	ra,0x1
    31a6:	00c080e7          	jalr	12(ra) # 41ae <mkdir>
    31aa:	f545                	bnez	a0,3152 <iref+0x48>
    if(chdir("irefd") != 0){
    31ac:	8552                	mv	a0,s4
    31ae:	00001097          	auipc	ra,0x1
    31b2:	008080e7          	jalr	8(ra) # 41b6 <chdir>
    31b6:	f95d                	bnez	a0,316c <iref+0x62>
    mkdir("");
    31b8:	8526                	mv	a0,s1
    31ba:	00001097          	auipc	ra,0x1
    31be:	ff4080e7          	jalr	-12(ra) # 41ae <mkdir>
    link("README", "");
    31c2:	85a6                	mv	a1,s1
    31c4:	8556                	mv	a0,s5
    31c6:	00001097          	auipc	ra,0x1
    31ca:	fe0080e7          	jalr	-32(ra) # 41a6 <link>
    fd = open("", O_CREATE);
    31ce:	20000593          	li	a1,512
    31d2:	8526                	mv	a0,s1
    31d4:	00001097          	auipc	ra,0x1
    31d8:	fb2080e7          	jalr	-78(ra) # 4186 <open>
    if(fd >= 0)
    31dc:	fa0555e3          	bgez	a0,3186 <iref+0x7c>
    fd = open("xx", O_CREATE);
    31e0:	20000593          	li	a1,512
    31e4:	854e                	mv	a0,s3
    31e6:	00001097          	auipc	ra,0x1
    31ea:	fa0080e7          	jalr	-96(ra) # 4186 <open>
    if(fd >= 0)
    31ee:	fa0541e3          	bltz	a0,3190 <iref+0x86>
      close(fd);
    31f2:	00001097          	auipc	ra,0x1
    31f6:	f7c080e7          	jalr	-132(ra) # 416e <close>
    31fa:	bf59                	j	3190 <iref+0x86>
  }

  chdir("/");
    31fc:	00001517          	auipc	a0,0x1
    3200:	51c50513          	addi	a0,a0,1308 # 4718 <malloc+0x17c>
    3204:	00001097          	auipc	ra,0x1
    3208:	fb2080e7          	jalr	-78(ra) # 41b6 <chdir>
  printf("empty file name OK\n");
    320c:	00003517          	auipc	a0,0x3
    3210:	bf450513          	addi	a0,a0,-1036 # 5e00 <malloc+0x1864>
    3214:	00001097          	auipc	ra,0x1
    3218:	2ca080e7          	jalr	714(ra) # 44de <printf>
}
    321c:	70e2                	ld	ra,56(sp)
    321e:	7442                	ld	s0,48(sp)
    3220:	74a2                	ld	s1,40(sp)
    3222:	7902                	ld	s2,32(sp)
    3224:	69e2                	ld	s3,24(sp)
    3226:	6a42                	ld	s4,16(sp)
    3228:	6aa2                	ld	s5,8(sp)
    322a:	6121                	addi	sp,sp,64
    322c:	8082                	ret

000000000000322e <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    322e:	1101                	addi	sp,sp,-32
    3230:	ec06                	sd	ra,24(sp)
    3232:	e822                	sd	s0,16(sp)
    3234:	e426                	sd	s1,8(sp)
    3236:	e04a                	sd	s2,0(sp)
    3238:	1000                	addi	s0,sp,32
  enum{ N = 1000 };
  int n, pid;

  printf("fork test\n");
    323a:	00002517          	auipc	a0,0x2
    323e:	b4650513          	addi	a0,a0,-1210 # 4d80 <malloc+0x7e4>
    3242:	00001097          	auipc	ra,0x1
    3246:	29c080e7          	jalr	668(ra) # 44de <printf>

  for(n=0; n<N; n++){
    324a:	4481                	li	s1,0
    324c:	3e800913          	li	s2,1000
    pid = fork();
    3250:	00001097          	auipc	ra,0x1
    3254:	eee080e7          	jalr	-274(ra) # 413e <fork>
    if(pid < 0)
    3258:	02054763          	bltz	a0,3286 <forktest+0x58>
      break;
    if(pid == 0)
    325c:	c10d                	beqz	a0,327e <forktest+0x50>
  for(n=0; n<N; n++){
    325e:	2485                	addiw	s1,s1,1
    3260:	ff2498e3          	bne	s1,s2,3250 <forktest+0x22>
    printf("no fork at all!\n");
    exit(-1);
  }

  if(n == N){
    printf("fork claimed to work 1000 times!\n");
    3264:	00003517          	auipc	a0,0x3
    3268:	bcc50513          	addi	a0,a0,-1076 # 5e30 <malloc+0x1894>
    326c:	00001097          	auipc	ra,0x1
    3270:	272080e7          	jalr	626(ra) # 44de <printf>
    exit(-1);
    3274:	557d                	li	a0,-1
    3276:	00001097          	auipc	ra,0x1
    327a:	ed0080e7          	jalr	-304(ra) # 4146 <exit>
      exit(0);
    327e:	00001097          	auipc	ra,0x1
    3282:	ec8080e7          	jalr	-312(ra) # 4146 <exit>
  if (n == 0) {
    3286:	c4b1                	beqz	s1,32d2 <forktest+0xa4>
  if(n == N){
    3288:	3e800793          	li	a5,1000
    328c:	fcf48ce3          	beq	s1,a5,3264 <forktest+0x36>
  }

  for(; n > 0; n--){
    3290:	00905b63          	blez	s1,32a6 <forktest+0x78>
    if(wait(0) < 0){
    3294:	4501                	li	a0,0
    3296:	00001097          	auipc	ra,0x1
    329a:	eb8080e7          	jalr	-328(ra) # 414e <wait>
    329e:	04054763          	bltz	a0,32ec <forktest+0xbe>
  for(; n > 0; n--){
    32a2:	34fd                	addiw	s1,s1,-1
    32a4:	f8e5                	bnez	s1,3294 <forktest+0x66>
      printf("wait stopped early\n");
      exit(-1);
    }
  }

  if(wait(0) != -1){
    32a6:	4501                	li	a0,0
    32a8:	00001097          	auipc	ra,0x1
    32ac:	ea6080e7          	jalr	-346(ra) # 414e <wait>
    32b0:	57fd                	li	a5,-1
    32b2:	04f51a63          	bne	a0,a5,3306 <forktest+0xd8>
    printf("wait got too many\n");
    exit(-1);
  }

  printf("fork test OK\n");
    32b6:	00003517          	auipc	a0,0x3
    32ba:	bd250513          	addi	a0,a0,-1070 # 5e88 <malloc+0x18ec>
    32be:	00001097          	auipc	ra,0x1
    32c2:	220080e7          	jalr	544(ra) # 44de <printf>
}
    32c6:	60e2                	ld	ra,24(sp)
    32c8:	6442                	ld	s0,16(sp)
    32ca:	64a2                	ld	s1,8(sp)
    32cc:	6902                	ld	s2,0(sp)
    32ce:	6105                	addi	sp,sp,32
    32d0:	8082                	ret
    printf("no fork at all!\n");
    32d2:	00003517          	auipc	a0,0x3
    32d6:	b4650513          	addi	a0,a0,-1210 # 5e18 <malloc+0x187c>
    32da:	00001097          	auipc	ra,0x1
    32de:	204080e7          	jalr	516(ra) # 44de <printf>
    exit(-1);
    32e2:	557d                	li	a0,-1
    32e4:	00001097          	auipc	ra,0x1
    32e8:	e62080e7          	jalr	-414(ra) # 4146 <exit>
      printf("wait stopped early\n");
    32ec:	00003517          	auipc	a0,0x3
    32f0:	b6c50513          	addi	a0,a0,-1172 # 5e58 <malloc+0x18bc>
    32f4:	00001097          	auipc	ra,0x1
    32f8:	1ea080e7          	jalr	490(ra) # 44de <printf>
      exit(-1);
    32fc:	557d                	li	a0,-1
    32fe:	00001097          	auipc	ra,0x1
    3302:	e48080e7          	jalr	-440(ra) # 4146 <exit>
    printf("wait got too many\n");
    3306:	00003517          	auipc	a0,0x3
    330a:	b6a50513          	addi	a0,a0,-1174 # 5e70 <malloc+0x18d4>
    330e:	00001097          	auipc	ra,0x1
    3312:	1d0080e7          	jalr	464(ra) # 44de <printf>
    exit(-1);
    3316:	557d                	li	a0,-1
    3318:	00001097          	auipc	ra,0x1
    331c:	e2e080e7          	jalr	-466(ra) # 4146 <exit>

0000000000003320 <sbrktest>:

void
sbrktest(void)
{
    3320:	7119                	addi	sp,sp,-128
    3322:	fc86                	sd	ra,120(sp)
    3324:	f8a2                	sd	s0,112(sp)
    3326:	f4a6                	sd	s1,104(sp)
    3328:	f0ca                	sd	s2,96(sp)
    332a:	ecce                	sd	s3,88(sp)
    332c:	e8d2                	sd	s4,80(sp)
    332e:	e4d6                	sd	s5,72(sp)
    3330:	0100                	addi	s0,sp,128
  char *c, *oldbrk, scratch, *a, *b, *lastaddr, *p;
  uint64 amt;
  int fd;
  int n;

  printf("sbrk test\n");
    3332:	00003517          	auipc	a0,0x3
    3336:	b6650513          	addi	a0,a0,-1178 # 5e98 <malloc+0x18fc>
    333a:	00001097          	auipc	ra,0x1
    333e:	1a4080e7          	jalr	420(ra) # 44de <printf>
  oldbrk = sbrk(0);
    3342:	4501                	li	a0,0
    3344:	00001097          	auipc	ra,0x1
    3348:	e8a080e7          	jalr	-374(ra) # 41ce <sbrk>
    334c:	89aa                	mv	s3,a0

  // does sbrk() return the expected failure value?
  a = sbrk(TOOMUCH);
    334e:	40000537          	lui	a0,0x40000
    3352:	00001097          	auipc	ra,0x1
    3356:	e7c080e7          	jalr	-388(ra) # 41ce <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    335a:	57fd                	li	a5,-1
    335c:	00f51d63          	bne	a0,a5,3376 <sbrktest+0x56>
    printf("sbrk(<toomuch>) returned %p\n", a);
    exit(-1);
  }

  // can one sbrk() less than a page?
  a = sbrk(0);
    3360:	4501                	li	a0,0
    3362:	00001097          	auipc	ra,0x1
    3366:	e6c080e7          	jalr	-404(ra) # 41ce <sbrk>
    336a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    336c:	4901                	li	s2,0
    336e:	6a05                	lui	s4,0x1
    3370:	388a0a13          	addi	s4,s4,904 # 1388 <fourfiles+0x68>
    3374:	a005                	j	3394 <sbrktest+0x74>
    printf("sbrk(<toomuch>) returned %p\n", a);
    3376:	85aa                	mv	a1,a0
    3378:	00003517          	auipc	a0,0x3
    337c:	b3050513          	addi	a0,a0,-1232 # 5ea8 <malloc+0x190c>
    3380:	00001097          	auipc	ra,0x1
    3384:	15e080e7          	jalr	350(ra) # 44de <printf>
    exit(-1);
    3388:	557d                	li	a0,-1
    338a:	00001097          	auipc	ra,0x1
    338e:	dbc080e7          	jalr	-580(ra) # 4146 <exit>
    if(b != a){
      printf("sbrk test failed %d %x %x\n", i, a, b);
      exit(-1);
    }
    *b = 1;
    a = b + 1;
    3392:	84be                	mv	s1,a5
    b = sbrk(1);
    3394:	4505                	li	a0,1
    3396:	00001097          	auipc	ra,0x1
    339a:	e38080e7          	jalr	-456(ra) # 41ce <sbrk>
    if(b != a){
    339e:	16951163          	bne	a0,s1,3500 <sbrktest+0x1e0>
    *b = 1;
    33a2:	4785                	li	a5,1
    33a4:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    33a8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    33ac:	2905                	addiw	s2,s2,1
    33ae:	ff4912e3          	bne	s2,s4,3392 <sbrktest+0x72>
  }
  pid = fork();
    33b2:	00001097          	auipc	ra,0x1
    33b6:	d8c080e7          	jalr	-628(ra) # 413e <fork>
    33ba:	892a                	mv	s2,a0
  if(pid < 0){
    33bc:	16054263          	bltz	a0,3520 <sbrktest+0x200>
    printf("sbrk test fork failed\n");
    exit(-1);
  }
  c = sbrk(1);
    33c0:	4505                	li	a0,1
    33c2:	00001097          	auipc	ra,0x1
    33c6:	e0c080e7          	jalr	-500(ra) # 41ce <sbrk>
  c = sbrk(1);
    33ca:	4505                	li	a0,1
    33cc:	00001097          	auipc	ra,0x1
    33d0:	e02080e7          	jalr	-510(ra) # 41ce <sbrk>
  if(c != a + 1){
    33d4:	0489                	addi	s1,s1,2
    33d6:	16a49263          	bne	s1,a0,353a <sbrktest+0x21a>
    printf("sbrk test failed post-fork\n");
    exit(-1);
  }
  if(pid == 0)
    33da:	16090d63          	beqz	s2,3554 <sbrktest+0x234>
    exit(0);
  wait(0);
    33de:	4501                	li	a0,0
    33e0:	00001097          	auipc	ra,0x1
    33e4:	d6e080e7          	jalr	-658(ra) # 414e <wait>

  // can one grow address space to something big?
  a = sbrk(0);
    33e8:	4501                	li	a0,0
    33ea:	00001097          	auipc	ra,0x1
    33ee:	de4080e7          	jalr	-540(ra) # 41ce <sbrk>
    33f2:	84aa                	mv	s1,a0
  amt = BIG - (uint64)a;
  p = sbrk(amt);
    33f4:	06400537          	lui	a0,0x6400
    33f8:	9d05                	subw	a0,a0,s1
    33fa:	00001097          	auipc	ra,0x1
    33fe:	dd4080e7          	jalr	-556(ra) # 41ce <sbrk>
  if (p != a) {
    3402:	14a49e63          	bne	s1,a0,355e <sbrktest+0x23e>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    exit(-1);
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3406:	064007b7          	lui	a5,0x6400
    340a:	06300713          	li	a4,99
    340e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f4367>

  // can one de-allocate?
  a = sbrk(0);
    3412:	4501                	li	a0,0
    3414:	00001097          	auipc	ra,0x1
    3418:	dba080e7          	jalr	-582(ra) # 41ce <sbrk>
    341c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    341e:	757d                	lui	a0,0xfffff
    3420:	00001097          	auipc	ra,0x1
    3424:	dae080e7          	jalr	-594(ra) # 41ce <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3428:	57fd                	li	a5,-1
    342a:	14f50763          	beq	a0,a5,3578 <sbrktest+0x258>
    printf("sbrk could not deallocate\n");
    exit(-1);
  }
  c = sbrk(0);
    342e:	4501                	li	a0,0
    3430:	00001097          	auipc	ra,0x1
    3434:	d9e080e7          	jalr	-610(ra) # 41ce <sbrk>
  if(c != a - PGSIZE){
    3438:	77fd                	lui	a5,0xfffff
    343a:	97a6                	add	a5,a5,s1
    343c:	14f51b63          	bne	a0,a5,3592 <sbrktest+0x272>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit(-1);
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3440:	4501                	li	a0,0
    3442:	00001097          	auipc	ra,0x1
    3446:	d8c080e7          	jalr	-628(ra) # 41ce <sbrk>
    344a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    344c:	6505                	lui	a0,0x1
    344e:	00001097          	auipc	ra,0x1
    3452:	d80080e7          	jalr	-640(ra) # 41ce <sbrk>
    3456:	892a                	mv	s2,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    3458:	14a49c63          	bne	s1,a0,35b0 <sbrktest+0x290>
    345c:	4501                	li	a0,0
    345e:	00001097          	auipc	ra,0x1
    3462:	d70080e7          	jalr	-656(ra) # 41ce <sbrk>
    3466:	6785                	lui	a5,0x1
    3468:	97a6                	add	a5,a5,s1
    346a:	14f51363          	bne	a0,a5,35b0 <sbrktest+0x290>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    exit(-1);
  }
  if(*lastaddr == 99){
    346e:	064007b7          	lui	a5,0x6400
    3472:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f4367>
    3476:	06300793          	li	a5,99
    347a:	14f70a63          	beq	a4,a5,35ce <sbrktest+0x2ae>
    // should be zero
    printf("sbrk de-allocation didn't really deallocate\n");
    exit(-1);
  }

  a = sbrk(0);
    347e:	4501                	li	a0,0
    3480:	00001097          	auipc	ra,0x1
    3484:	d4e080e7          	jalr	-690(ra) # 41ce <sbrk>
    3488:	892a                	mv	s2,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    348a:	4501                	li	a0,0
    348c:	00001097          	auipc	ra,0x1
    3490:	d42080e7          	jalr	-702(ra) # 41ce <sbrk>
    3494:	40a9853b          	subw	a0,s3,a0
    3498:	00001097          	auipc	ra,0x1
    349c:	d36080e7          	jalr	-714(ra) # 41ce <sbrk>
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    exit(-1);
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34a0:	4485                	li	s1,1
    34a2:	04fe                	slli	s1,s1,0x1f
  if(c != a){
    34a4:	14a91263          	bne	s2,a0,35e8 <sbrktest+0x2c8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34a8:	6ab1                	lui	s5,0xc
    34aa:	350a8a93          	addi	s5,s5,848 # c350 <__BSS_END__+0x6b8>
    34ae:	1003da37          	lui	s4,0x1003d
    34b2:	0a0e                	slli	s4,s4,0x3
    34b4:	480a0a13          	addi	s4,s4,1152 # 1003d480 <__BSS_END__+0x100317e8>
    ppid = getpid();
    34b8:	00001097          	auipc	ra,0x1
    34bc:	d0e080e7          	jalr	-754(ra) # 41c6 <getpid>
    34c0:	892a                	mv	s2,a0
    pid = fork();
    34c2:	00001097          	auipc	ra,0x1
    34c6:	c7c080e7          	jalr	-900(ra) # 413e <fork>
    if(pid < 0){
    34ca:	12054e63          	bltz	a0,3606 <sbrktest+0x2e6>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
    34ce:	14050963          	beqz	a0,3620 <sbrktest+0x300>
      printf("oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit(-1);
    }
    wait(0);
    34d2:	4501                	li	a0,0
    34d4:	00001097          	auipc	ra,0x1
    34d8:	c7a080e7          	jalr	-902(ra) # 414e <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    34dc:	94d6                	add	s1,s1,s5
    34de:	fd449de3          	bne	s1,s4,34b8 <sbrktest+0x198>
  }
    
  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    34e2:	fb840513          	addi	a0,s0,-72
    34e6:	00001097          	auipc	ra,0x1
    34ea:	c70080e7          	jalr	-912(ra) # 4156 <pipe>
    34ee:	14051e63          	bnez	a0,364a <sbrktest+0x32a>
    34f2:	f9040493          	addi	s1,s0,-112
    34f6:	fb840a13          	addi	s4,s0,-72
    34fa:	8926                	mv	s2,s1
      sbrk(BIG - (uint64)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
    34fc:	5afd                	li	s5,-1
    34fe:	a265                	j	36a6 <sbrktest+0x386>
      printf("sbrk test failed %d %x %x\n", i, a, b);
    3500:	86aa                	mv	a3,a0
    3502:	8626                	mv	a2,s1
    3504:	85ca                	mv	a1,s2
    3506:	00003517          	auipc	a0,0x3
    350a:	9c250513          	addi	a0,a0,-1598 # 5ec8 <malloc+0x192c>
    350e:	00001097          	auipc	ra,0x1
    3512:	fd0080e7          	jalr	-48(ra) # 44de <printf>
      exit(-1);
    3516:	557d                	li	a0,-1
    3518:	00001097          	auipc	ra,0x1
    351c:	c2e080e7          	jalr	-978(ra) # 4146 <exit>
    printf("sbrk test fork failed\n");
    3520:	00003517          	auipc	a0,0x3
    3524:	9c850513          	addi	a0,a0,-1592 # 5ee8 <malloc+0x194c>
    3528:	00001097          	auipc	ra,0x1
    352c:	fb6080e7          	jalr	-74(ra) # 44de <printf>
    exit(-1);
    3530:	557d                	li	a0,-1
    3532:	00001097          	auipc	ra,0x1
    3536:	c14080e7          	jalr	-1004(ra) # 4146 <exit>
    printf("sbrk test failed post-fork\n");
    353a:	00003517          	auipc	a0,0x3
    353e:	9c650513          	addi	a0,a0,-1594 # 5f00 <malloc+0x1964>
    3542:	00001097          	auipc	ra,0x1
    3546:	f9c080e7          	jalr	-100(ra) # 44de <printf>
    exit(-1);
    354a:	557d                	li	a0,-1
    354c:	00001097          	auipc	ra,0x1
    3550:	bfa080e7          	jalr	-1030(ra) # 4146 <exit>
    exit(0);
    3554:	4501                	li	a0,0
    3556:	00001097          	auipc	ra,0x1
    355a:	bf0080e7          	jalr	-1040(ra) # 4146 <exit>
    printf("sbrk test failed to grow big address space; enough phys mem?\n");
    355e:	00003517          	auipc	a0,0x3
    3562:	9c250513          	addi	a0,a0,-1598 # 5f20 <malloc+0x1984>
    3566:	00001097          	auipc	ra,0x1
    356a:	f78080e7          	jalr	-136(ra) # 44de <printf>
    exit(-1);
    356e:	557d                	li	a0,-1
    3570:	00001097          	auipc	ra,0x1
    3574:	bd6080e7          	jalr	-1066(ra) # 4146 <exit>
    printf("sbrk could not deallocate\n");
    3578:	00003517          	auipc	a0,0x3
    357c:	9e850513          	addi	a0,a0,-1560 # 5f60 <malloc+0x19c4>
    3580:	00001097          	auipc	ra,0x1
    3584:	f5e080e7          	jalr	-162(ra) # 44de <printf>
    exit(-1);
    3588:	557d                	li	a0,-1
    358a:	00001097          	auipc	ra,0x1
    358e:	bbc080e7          	jalr	-1092(ra) # 4146 <exit>
    printf("sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3592:	862a                	mv	a2,a0
    3594:	85a6                	mv	a1,s1
    3596:	00003517          	auipc	a0,0x3
    359a:	9ea50513          	addi	a0,a0,-1558 # 5f80 <malloc+0x19e4>
    359e:	00001097          	auipc	ra,0x1
    35a2:	f40080e7          	jalr	-192(ra) # 44de <printf>
    exit(-1);
    35a6:	557d                	li	a0,-1
    35a8:	00001097          	auipc	ra,0x1
    35ac:	b9e080e7          	jalr	-1122(ra) # 4146 <exit>
    printf("sbrk re-allocation failed, a %x c %x\n", a, c);
    35b0:	864a                	mv	a2,s2
    35b2:	85a6                	mv	a1,s1
    35b4:	00003517          	auipc	a0,0x3
    35b8:	a0450513          	addi	a0,a0,-1532 # 5fb8 <malloc+0x1a1c>
    35bc:	00001097          	auipc	ra,0x1
    35c0:	f22080e7          	jalr	-222(ra) # 44de <printf>
    exit(-1);
    35c4:	557d                	li	a0,-1
    35c6:	00001097          	auipc	ra,0x1
    35ca:	b80080e7          	jalr	-1152(ra) # 4146 <exit>
    printf("sbrk de-allocation didn't really deallocate\n");
    35ce:	00003517          	auipc	a0,0x3
    35d2:	a1250513          	addi	a0,a0,-1518 # 5fe0 <malloc+0x1a44>
    35d6:	00001097          	auipc	ra,0x1
    35da:	f08080e7          	jalr	-248(ra) # 44de <printf>
    exit(-1);
    35de:	557d                	li	a0,-1
    35e0:	00001097          	auipc	ra,0x1
    35e4:	b66080e7          	jalr	-1178(ra) # 4146 <exit>
    printf("sbrk downsize failed, a %x c %x\n", a, c);
    35e8:	862a                	mv	a2,a0
    35ea:	85ca                	mv	a1,s2
    35ec:	00003517          	auipc	a0,0x3
    35f0:	a2450513          	addi	a0,a0,-1500 # 6010 <malloc+0x1a74>
    35f4:	00001097          	auipc	ra,0x1
    35f8:	eea080e7          	jalr	-278(ra) # 44de <printf>
    exit(-1);
    35fc:	557d                	li	a0,-1
    35fe:	00001097          	auipc	ra,0x1
    3602:	b48080e7          	jalr	-1208(ra) # 4146 <exit>
      printf("fork failed\n");
    3606:	00001517          	auipc	a0,0x1
    360a:	14a50513          	addi	a0,a0,330 # 4750 <malloc+0x1b4>
    360e:	00001097          	auipc	ra,0x1
    3612:	ed0080e7          	jalr	-304(ra) # 44de <printf>
      exit(-1);
    3616:	557d                	li	a0,-1
    3618:	00001097          	auipc	ra,0x1
    361c:	b2e080e7          	jalr	-1234(ra) # 4146 <exit>
      printf("oops could read %x = %x\n", a, *a);
    3620:	0004c603          	lbu	a2,0(s1)
    3624:	85a6                	mv	a1,s1
    3626:	00003517          	auipc	a0,0x3
    362a:	a1250513          	addi	a0,a0,-1518 # 6038 <malloc+0x1a9c>
    362e:	00001097          	auipc	ra,0x1
    3632:	eb0080e7          	jalr	-336(ra) # 44de <printf>
      kill(ppid);
    3636:	854a                	mv	a0,s2
    3638:	00001097          	auipc	ra,0x1
    363c:	b3e080e7          	jalr	-1218(ra) # 4176 <kill>
      exit(-1);
    3640:	557d                	li	a0,-1
    3642:	00001097          	auipc	ra,0x1
    3646:	b04080e7          	jalr	-1276(ra) # 4146 <exit>
    printf("pipe() failed\n");
    364a:	00001517          	auipc	a0,0x1
    364e:	58e50513          	addi	a0,a0,1422 # 4bd8 <malloc+0x63c>
    3652:	00001097          	auipc	ra,0x1
    3656:	e8c080e7          	jalr	-372(ra) # 44de <printf>
    exit(-1);
    365a:	557d                	li	a0,-1
    365c:	00001097          	auipc	ra,0x1
    3660:	aea080e7          	jalr	-1302(ra) # 4146 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3664:	00001097          	auipc	ra,0x1
    3668:	b6a080e7          	jalr	-1174(ra) # 41ce <sbrk>
    366c:	064007b7          	lui	a5,0x6400
    3670:	40a7853b          	subw	a0,a5,a0
    3674:	00001097          	auipc	ra,0x1
    3678:	b5a080e7          	jalr	-1190(ra) # 41ce <sbrk>
      write(fds[1], "x", 1);
    367c:	4605                	li	a2,1
    367e:	00001597          	auipc	a1,0x1
    3682:	5e258593          	addi	a1,a1,1506 # 4c60 <malloc+0x6c4>
    3686:	fbc42503          	lw	a0,-68(s0)
    368a:	00001097          	auipc	ra,0x1
    368e:	adc080e7          	jalr	-1316(ra) # 4166 <write>
      for(;;) sleep(1000);
    3692:	3e800513          	li	a0,1000
    3696:	00001097          	auipc	ra,0x1
    369a:	b40080e7          	jalr	-1216(ra) # 41d6 <sleep>
    369e:	bfd5                	j	3692 <sbrktest+0x372>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    36a0:	0911                	addi	s2,s2,4
    36a2:	03490563          	beq	s2,s4,36cc <sbrktest+0x3ac>
    if((pids[i] = fork()) == 0){
    36a6:	00001097          	auipc	ra,0x1
    36aa:	a98080e7          	jalr	-1384(ra) # 413e <fork>
    36ae:	00a92023          	sw	a0,0(s2)
    36b2:	d94d                	beqz	a0,3664 <sbrktest+0x344>
    if(pids[i] != -1)
    36b4:	ff5506e3          	beq	a0,s5,36a0 <sbrktest+0x380>
      read(fds[0], &scratch, 1);
    36b8:	4605                	li	a2,1
    36ba:	f8f40593          	addi	a1,s0,-113
    36be:	fb842503          	lw	a0,-72(s0)
    36c2:	00001097          	auipc	ra,0x1
    36c6:	a9c080e7          	jalr	-1380(ra) # 415e <read>
    36ca:	bfd9                	j	36a0 <sbrktest+0x380>
  }

  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(PGSIZE);
    36cc:	6505                	lui	a0,0x1
    36ce:	00001097          	auipc	ra,0x1
    36d2:	b00080e7          	jalr	-1280(ra) # 41ce <sbrk>
    36d6:	8aaa                	mv	s5,a0
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    36d8:	597d                	li	s2,-1
    36da:	a021                	j	36e2 <sbrktest+0x3c2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    36dc:	0491                	addi	s1,s1,4
    36de:	01448f63          	beq	s1,s4,36fc <sbrktest+0x3dc>
    if(pids[i] == -1)
    36e2:	4088                	lw	a0,0(s1)
    36e4:	ff250ce3          	beq	a0,s2,36dc <sbrktest+0x3bc>
      continue;
    kill(pids[i]);
    36e8:	00001097          	auipc	ra,0x1
    36ec:	a8e080e7          	jalr	-1394(ra) # 4176 <kill>
    wait(0);
    36f0:	4501                	li	a0,0
    36f2:	00001097          	auipc	ra,0x1
    36f6:	a5c080e7          	jalr	-1444(ra) # 414e <wait>
    36fa:	b7cd                	j	36dc <sbrktest+0x3bc>
  }
  if(c == (char*)0xffffffffffffffffL){
    36fc:	57fd                	li	a5,-1
    36fe:	0afa8f63          	beq	s5,a5,37bc <sbrktest+0x49c>
    printf("failed sbrk leaked memory\n");
    exit(-1);
  }

  // test running fork with the above allocated page 
  ppid = getpid();
    3702:	00001097          	auipc	ra,0x1
    3706:	ac4080e7          	jalr	-1340(ra) # 41c6 <getpid>
    370a:	892a                	mv	s2,a0
  pid = fork();
    370c:	00001097          	auipc	ra,0x1
    3710:	a32080e7          	jalr	-1486(ra) # 413e <fork>
    3714:	84aa                	mv	s1,a0
  if(pid < 0){
    3716:	0c054063          	bltz	a0,37d6 <sbrktest+0x4b6>
    printf("fork failed\n");
    exit(-1);
  }

  // test out of memory during sbrk
  if(pid == 0){
    371a:	c979                	beqz	a0,37f0 <sbrktest+0x4d0>
    }
    printf("allocate a lot of memory succeeded %d\n", n);
    kill(ppid);
    exit(-1);
  }
  wait(0);
    371c:	4501                	li	a0,0
    371e:	00001097          	auipc	ra,0x1
    3722:	a30080e7          	jalr	-1488(ra) # 414e <wait>

  // test reads from allocated memory
  a = sbrk(PGSIZE);
    3726:	6505                	lui	a0,0x1
    3728:	00001097          	auipc	ra,0x1
    372c:	aa6080e7          	jalr	-1370(ra) # 41ce <sbrk>
    3730:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    3732:	20100593          	li	a1,513
    3736:	00003517          	auipc	a0,0x3
    373a:	96a50513          	addi	a0,a0,-1686 # 60a0 <malloc+0x1b04>
    373e:	00001097          	auipc	ra,0x1
    3742:	a48080e7          	jalr	-1464(ra) # 4186 <open>
    3746:	84aa                	mv	s1,a0
  unlink("sbrk");
    3748:	00003517          	auipc	a0,0x3
    374c:	95850513          	addi	a0,a0,-1704 # 60a0 <malloc+0x1b04>
    3750:	00001097          	auipc	ra,0x1
    3754:	a46080e7          	jalr	-1466(ra) # 4196 <unlink>
  if(fd < 0)  {
    3758:	0e04c663          	bltz	s1,3844 <sbrktest+0x524>
    printf("open sbrk failed\n");
    exit(-1);
  }
  if ((n = write(fd, a, 10)) < 0) {
    375c:	4629                	li	a2,10
    375e:	85ca                	mv	a1,s2
    3760:	8526                	mv	a0,s1
    3762:	00001097          	auipc	ra,0x1
    3766:	a04080e7          	jalr	-1532(ra) # 4166 <write>
    376a:	0e054a63          	bltz	a0,385e <sbrktest+0x53e>
    printf("write sbrk failed\n");
    exit(-1);
  }
  close(fd);
    376e:	8526                	mv	a0,s1
    3770:	00001097          	auipc	ra,0x1
    3774:	9fe080e7          	jalr	-1538(ra) # 416e <close>

  // test writes to allocated memory
  a = sbrk(PGSIZE);
    3778:	6505                	lui	a0,0x1
    377a:	00001097          	auipc	ra,0x1
    377e:	a54080e7          	jalr	-1452(ra) # 41ce <sbrk>
  if(pipe((int *) a) != 0){
    3782:	00001097          	auipc	ra,0x1
    3786:	9d4080e7          	jalr	-1580(ra) # 4156 <pipe>
    378a:	e57d                	bnez	a0,3878 <sbrktest+0x558>
    printf("pipe() failed\n");
    exit(-1);
  } 

  if(sbrk(0) > oldbrk)
    378c:	4501                	li	a0,0
    378e:	00001097          	auipc	ra,0x1
    3792:	a40080e7          	jalr	-1472(ra) # 41ce <sbrk>
    3796:	0ea9ee63          	bltu	s3,a0,3892 <sbrktest+0x572>
    sbrk(-(sbrk(0) - oldbrk));

  printf("sbrk test OK\n");
    379a:	00003517          	auipc	a0,0x3
    379e:	93e50513          	addi	a0,a0,-1730 # 60d8 <malloc+0x1b3c>
    37a2:	00001097          	auipc	ra,0x1
    37a6:	d3c080e7          	jalr	-708(ra) # 44de <printf>
}
    37aa:	70e6                	ld	ra,120(sp)
    37ac:	7446                	ld	s0,112(sp)
    37ae:	74a6                	ld	s1,104(sp)
    37b0:	7906                	ld	s2,96(sp)
    37b2:	69e6                	ld	s3,88(sp)
    37b4:	6a46                	ld	s4,80(sp)
    37b6:	6aa6                	ld	s5,72(sp)
    37b8:	6109                	addi	sp,sp,128
    37ba:	8082                	ret
    printf("failed sbrk leaked memory\n");
    37bc:	00003517          	auipc	a0,0x3
    37c0:	89c50513          	addi	a0,a0,-1892 # 6058 <malloc+0x1abc>
    37c4:	00001097          	auipc	ra,0x1
    37c8:	d1a080e7          	jalr	-742(ra) # 44de <printf>
    exit(-1);
    37cc:	557d                	li	a0,-1
    37ce:	00001097          	auipc	ra,0x1
    37d2:	978080e7          	jalr	-1672(ra) # 4146 <exit>
    printf("fork failed\n");
    37d6:	00001517          	auipc	a0,0x1
    37da:	f7a50513          	addi	a0,a0,-134 # 4750 <malloc+0x1b4>
    37de:	00001097          	auipc	ra,0x1
    37e2:	d00080e7          	jalr	-768(ra) # 44de <printf>
    exit(-1);
    37e6:	557d                	li	a0,-1
    37e8:	00001097          	auipc	ra,0x1
    37ec:	95e080e7          	jalr	-1698(ra) # 4146 <exit>
    a = sbrk(0);
    37f0:	4501                	li	a0,0
    37f2:	00001097          	auipc	ra,0x1
    37f6:	9dc080e7          	jalr	-1572(ra) # 41ce <sbrk>
    37fa:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    37fc:	3e800537          	lui	a0,0x3e800
    3800:	00001097          	auipc	ra,0x1
    3804:	9ce080e7          	jalr	-1586(ra) # 41ce <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3808:	87ce                	mv	a5,s3
    380a:	3e800737          	lui	a4,0x3e800
    380e:	99ba                	add	s3,s3,a4
    3810:	6705                	lui	a4,0x1
      n += *(a+i);
    3812:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f4368>
    3816:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3818:	97ba                	add	a5,a5,a4
    381a:	ff379ce3          	bne	a5,s3,3812 <sbrktest+0x4f2>
    printf("allocate a lot of memory succeeded %d\n", n);
    381e:	85a6                	mv	a1,s1
    3820:	00003517          	auipc	a0,0x3
    3824:	85850513          	addi	a0,a0,-1960 # 6078 <malloc+0x1adc>
    3828:	00001097          	auipc	ra,0x1
    382c:	cb6080e7          	jalr	-842(ra) # 44de <printf>
    kill(ppid);
    3830:	854a                	mv	a0,s2
    3832:	00001097          	auipc	ra,0x1
    3836:	944080e7          	jalr	-1724(ra) # 4176 <kill>
    exit(-1);
    383a:	557d                	li	a0,-1
    383c:	00001097          	auipc	ra,0x1
    3840:	90a080e7          	jalr	-1782(ra) # 4146 <exit>
    printf("open sbrk failed\n");
    3844:	00003517          	auipc	a0,0x3
    3848:	86450513          	addi	a0,a0,-1948 # 60a8 <malloc+0x1b0c>
    384c:	00001097          	auipc	ra,0x1
    3850:	c92080e7          	jalr	-878(ra) # 44de <printf>
    exit(-1);
    3854:	557d                	li	a0,-1
    3856:	00001097          	auipc	ra,0x1
    385a:	8f0080e7          	jalr	-1808(ra) # 4146 <exit>
    printf("write sbrk failed\n");
    385e:	00003517          	auipc	a0,0x3
    3862:	86250513          	addi	a0,a0,-1950 # 60c0 <malloc+0x1b24>
    3866:	00001097          	auipc	ra,0x1
    386a:	c78080e7          	jalr	-904(ra) # 44de <printf>
    exit(-1);
    386e:	557d                	li	a0,-1
    3870:	00001097          	auipc	ra,0x1
    3874:	8d6080e7          	jalr	-1834(ra) # 4146 <exit>
    printf("pipe() failed\n");
    3878:	00001517          	auipc	a0,0x1
    387c:	36050513          	addi	a0,a0,864 # 4bd8 <malloc+0x63c>
    3880:	00001097          	auipc	ra,0x1
    3884:	c5e080e7          	jalr	-930(ra) # 44de <printf>
    exit(-1);
    3888:	557d                	li	a0,-1
    388a:	00001097          	auipc	ra,0x1
    388e:	8bc080e7          	jalr	-1860(ra) # 4146 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    3892:	4501                	li	a0,0
    3894:	00001097          	auipc	ra,0x1
    3898:	93a080e7          	jalr	-1734(ra) # 41ce <sbrk>
    389c:	40a9853b          	subw	a0,s3,a0
    38a0:	00001097          	auipc	ra,0x1
    38a4:	92e080e7          	jalr	-1746(ra) # 41ce <sbrk>
    38a8:	bdcd                	j	379a <sbrktest+0x47a>

00000000000038aa <validatetest>:

void
validatetest(void)
{
    38aa:	7139                	addi	sp,sp,-64
    38ac:	fc06                	sd	ra,56(sp)
    38ae:	f822                	sd	s0,48(sp)
    38b0:	f426                	sd	s1,40(sp)
    38b2:	f04a                	sd	s2,32(sp)
    38b4:	ec4e                	sd	s3,24(sp)
    38b6:	e852                	sd	s4,16(sp)
    38b8:	e456                	sd	s5,8(sp)
    38ba:	0080                	addi	s0,sp,64
  int hi;
  uint64 p;

  printf("validate test\n");
    38bc:	00003517          	auipc	a0,0x3
    38c0:	82c50513          	addi	a0,a0,-2004 # 60e8 <malloc+0x1b4c>
    38c4:	00001097          	auipc	ra,0x1
    38c8:	c1a080e7          	jalr	-998(ra) # 44de <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += PGSIZE){
    38cc:	4481                	li	s1,0
    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    38ce:	00003997          	auipc	s3,0x3
    38d2:	82a98993          	addi	s3,s3,-2006 # 60f8 <malloc+0x1b5c>
    38d6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    38d8:	6a85                	lui	s5,0x1
    38da:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    38de:	85a6                	mv	a1,s1
    38e0:	854e                	mv	a0,s3
    38e2:	00001097          	auipc	ra,0x1
    38e6:	8c4080e7          	jalr	-1852(ra) # 41a6 <link>
    38ea:	03251663          	bne	a0,s2,3916 <validatetest+0x6c>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    38ee:	94d6                	add	s1,s1,s5
    38f0:	ff4497e3          	bne	s1,s4,38de <validatetest+0x34>
      printf("link should not succeed\n");
      exit(-1);
    }
  }

  printf("validate ok\n");
    38f4:	00003517          	auipc	a0,0x3
    38f8:	83450513          	addi	a0,a0,-1996 # 6128 <malloc+0x1b8c>
    38fc:	00001097          	auipc	ra,0x1
    3900:	be2080e7          	jalr	-1054(ra) # 44de <printf>
}
    3904:	70e2                	ld	ra,56(sp)
    3906:	7442                	ld	s0,48(sp)
    3908:	74a2                	ld	s1,40(sp)
    390a:	7902                	ld	s2,32(sp)
    390c:	69e2                	ld	s3,24(sp)
    390e:	6a42                	ld	s4,16(sp)
    3910:	6aa2                	ld	s5,8(sp)
    3912:	6121                	addi	sp,sp,64
    3914:	8082                	ret
      printf("link should not succeed\n");
    3916:	00002517          	auipc	a0,0x2
    391a:	7f250513          	addi	a0,a0,2034 # 6108 <malloc+0x1b6c>
    391e:	00001097          	auipc	ra,0x1
    3922:	bc0080e7          	jalr	-1088(ra) # 44de <printf>
      exit(-1);
    3926:	557d                	li	a0,-1
    3928:	00001097          	auipc	ra,0x1
    392c:	81e080e7          	jalr	-2018(ra) # 4146 <exit>

0000000000003930 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3930:	1141                	addi	sp,sp,-16
    3932:	e406                	sd	ra,8(sp)
    3934:	e022                	sd	s0,0(sp)
    3936:	0800                	addi	s0,sp,16
  int i;

  printf("bss test\n");
    3938:	00003517          	auipc	a0,0x3
    393c:	80050513          	addi	a0,a0,-2048 # 6138 <malloc+0x1b9c>
    3940:	00001097          	auipc	ra,0x1
    3944:	b9e080e7          	jalr	-1122(ra) # 44de <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3948:	00003797          	auipc	a5,0x3
    394c:	c3078793          	addi	a5,a5,-976 # 6578 <uninit>
    3950:	00005697          	auipc	a3,0x5
    3954:	33868693          	addi	a3,a3,824 # 8c88 <buf>
    if(uninit[i] != '\0'){
    3958:	0007c703          	lbu	a4,0(a5)
    395c:	e305                	bnez	a4,397c <bsstest+0x4c>
  for(i = 0; i < sizeof(uninit); i++){
    395e:	0785                	addi	a5,a5,1
    3960:	fed79ce3          	bne	a5,a3,3958 <bsstest+0x28>
      printf("bss test failed\n");
      exit(-1);
    }
  }
  printf("bss test ok\n");
    3964:	00002517          	auipc	a0,0x2
    3968:	7fc50513          	addi	a0,a0,2044 # 6160 <malloc+0x1bc4>
    396c:	00001097          	auipc	ra,0x1
    3970:	b72080e7          	jalr	-1166(ra) # 44de <printf>
}
    3974:	60a2                	ld	ra,8(sp)
    3976:	6402                	ld	s0,0(sp)
    3978:	0141                	addi	sp,sp,16
    397a:	8082                	ret
      printf("bss test failed\n");
    397c:	00002517          	auipc	a0,0x2
    3980:	7cc50513          	addi	a0,a0,1996 # 6148 <malloc+0x1bac>
    3984:	00001097          	auipc	ra,0x1
    3988:	b5a080e7          	jalr	-1190(ra) # 44de <printf>
      exit(-1);
    398c:	557d                	li	a0,-1
    398e:	00000097          	auipc	ra,0x0
    3992:	7b8080e7          	jalr	1976(ra) # 4146 <exit>

0000000000003996 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3996:	1101                	addi	sp,sp,-32
    3998:	ec06                	sd	ra,24(sp)
    399a:	e822                	sd	s0,16(sp)
    399c:	e426                	sd	s1,8(sp)
    399e:	1000                	addi	s0,sp,32
  int pid, fd;

  unlink("bigarg-ok");
    39a0:	00002517          	auipc	a0,0x2
    39a4:	7d050513          	addi	a0,a0,2000 # 6170 <malloc+0x1bd4>
    39a8:	00000097          	auipc	ra,0x0
    39ac:	7ee080e7          	jalr	2030(ra) # 4196 <unlink>
  pid = fork();
    39b0:	00000097          	auipc	ra,0x0
    39b4:	78e080e7          	jalr	1934(ra) # 413e <fork>
  if(pid == 0){
    39b8:	c521                	beqz	a0,3a00 <bigargtest+0x6a>
    exec("echo", args);
    printf("bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    39ba:	0c054563          	bltz	a0,3a84 <bigargtest+0xee>
    printf("bigargtest: fork failed\n");
    exit(-1);
  }
  wait(0);
    39be:	4501                	li	a0,0
    39c0:	00000097          	auipc	ra,0x0
    39c4:	78e080e7          	jalr	1934(ra) # 414e <wait>
  fd = open("bigarg-ok", 0);
    39c8:	4581                	li	a1,0
    39ca:	00002517          	auipc	a0,0x2
    39ce:	7a650513          	addi	a0,a0,1958 # 6170 <malloc+0x1bd4>
    39d2:	00000097          	auipc	ra,0x0
    39d6:	7b4080e7          	jalr	1972(ra) # 4186 <open>
  if(fd < 0){
    39da:	0c054263          	bltz	a0,3a9e <bigargtest+0x108>
    printf("bigarg test failed!\n");
    exit(-1);
  }
  close(fd);
    39de:	00000097          	auipc	ra,0x0
    39e2:	790080e7          	jalr	1936(ra) # 416e <close>
  unlink("bigarg-ok");
    39e6:	00002517          	auipc	a0,0x2
    39ea:	78a50513          	addi	a0,a0,1930 # 6170 <malloc+0x1bd4>
    39ee:	00000097          	auipc	ra,0x0
    39f2:	7a8080e7          	jalr	1960(ra) # 4196 <unlink>
}
    39f6:	60e2                	ld	ra,24(sp)
    39f8:	6442                	ld	s0,16(sp)
    39fa:	64a2                	ld	s1,8(sp)
    39fc:	6105                	addi	sp,sp,32
    39fe:	8082                	ret
    3a00:	00003797          	auipc	a5,0x3
    3a04:	a7878793          	addi	a5,a5,-1416 # 6478 <args.0>
    3a08:	00003697          	auipc	a3,0x3
    3a0c:	b6868693          	addi	a3,a3,-1176 # 6570 <args.0+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3a10:	00002717          	auipc	a4,0x2
    3a14:	77070713          	addi	a4,a4,1904 # 6180 <malloc+0x1be4>
    3a18:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    3a1a:	07a1                	addi	a5,a5,8
    3a1c:	fed79ee3          	bne	a5,a3,3a18 <bigargtest+0x82>
    args[MAXARG-1] = 0;
    3a20:	00003497          	auipc	s1,0x3
    3a24:	a5848493          	addi	s1,s1,-1448 # 6478 <args.0>
    3a28:	0e04bc23          	sd	zero,248(s1)
    printf("bigarg test\n");
    3a2c:	00003517          	auipc	a0,0x3
    3a30:	83450513          	addi	a0,a0,-1996 # 6260 <malloc+0x1cc4>
    3a34:	00001097          	auipc	ra,0x1
    3a38:	aaa080e7          	jalr	-1366(ra) # 44de <printf>
    exec("echo", args);
    3a3c:	85a6                	mv	a1,s1
    3a3e:	00001517          	auipc	a0,0x1
    3a42:	de250513          	addi	a0,a0,-542 # 4820 <malloc+0x284>
    3a46:	00000097          	auipc	ra,0x0
    3a4a:	738080e7          	jalr	1848(ra) # 417e <exec>
    printf("bigarg test ok\n");
    3a4e:	00003517          	auipc	a0,0x3
    3a52:	82250513          	addi	a0,a0,-2014 # 6270 <malloc+0x1cd4>
    3a56:	00001097          	auipc	ra,0x1
    3a5a:	a88080e7          	jalr	-1400(ra) # 44de <printf>
    fd = open("bigarg-ok", O_CREATE);
    3a5e:	20000593          	li	a1,512
    3a62:	00002517          	auipc	a0,0x2
    3a66:	70e50513          	addi	a0,a0,1806 # 6170 <malloc+0x1bd4>
    3a6a:	00000097          	auipc	ra,0x0
    3a6e:	71c080e7          	jalr	1820(ra) # 4186 <open>
    close(fd);
    3a72:	00000097          	auipc	ra,0x0
    3a76:	6fc080e7          	jalr	1788(ra) # 416e <close>
    exit(0);
    3a7a:	4501                	li	a0,0
    3a7c:	00000097          	auipc	ra,0x0
    3a80:	6ca080e7          	jalr	1738(ra) # 4146 <exit>
    printf("bigargtest: fork failed\n");
    3a84:	00002517          	auipc	a0,0x2
    3a88:	7fc50513          	addi	a0,a0,2044 # 6280 <malloc+0x1ce4>
    3a8c:	00001097          	auipc	ra,0x1
    3a90:	a52080e7          	jalr	-1454(ra) # 44de <printf>
    exit(-1);
    3a94:	557d                	li	a0,-1
    3a96:	00000097          	auipc	ra,0x0
    3a9a:	6b0080e7          	jalr	1712(ra) # 4146 <exit>
    printf("bigarg test failed!\n");
    3a9e:	00003517          	auipc	a0,0x3
    3aa2:	80250513          	addi	a0,a0,-2046 # 62a0 <malloc+0x1d04>
    3aa6:	00001097          	auipc	ra,0x1
    3aaa:	a38080e7          	jalr	-1480(ra) # 44de <printf>
    exit(-1);
    3aae:	557d                	li	a0,-1
    3ab0:	00000097          	auipc	ra,0x0
    3ab4:	696080e7          	jalr	1686(ra) # 4146 <exit>

0000000000003ab8 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3ab8:	7171                	addi	sp,sp,-176
    3aba:	f506                	sd	ra,168(sp)
    3abc:	f122                	sd	s0,160(sp)
    3abe:	ed26                	sd	s1,152(sp)
    3ac0:	e94a                	sd	s2,144(sp)
    3ac2:	e54e                	sd	s3,136(sp)
    3ac4:	e152                	sd	s4,128(sp)
    3ac6:	fcd6                	sd	s5,120(sp)
    3ac8:	f8da                	sd	s6,112(sp)
    3aca:	f4de                	sd	s7,104(sp)
    3acc:	f0e2                	sd	s8,96(sp)
    3ace:	ece6                	sd	s9,88(sp)
    3ad0:	e8ea                	sd	s10,80(sp)
    3ad2:	e4ee                	sd	s11,72(sp)
    3ad4:	1900                	addi	s0,sp,176
  int nfiles;
  int fsblocks = 0;

  printf("fsfull test\n");
    3ad6:	00002517          	auipc	a0,0x2
    3ada:	7e250513          	addi	a0,a0,2018 # 62b8 <malloc+0x1d1c>
    3ade:	00001097          	auipc	ra,0x1
    3ae2:	a00080e7          	jalr	-1536(ra) # 44de <printf>

  for(nfiles = 0; ; nfiles++){
    3ae6:	4481                	li	s1,0
    char name[64];
    name[0] = 'f';
    3ae8:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    3aec:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3af0:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    3af4:	4b29                	li	s6,10
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf("writing %s\n", name);
    3af6:	00002c97          	auipc	s9,0x2
    3afa:	7d2c8c93          	addi	s9,s9,2002 # 62c8 <malloc+0x1d2c>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf("open %s failed\n", name);
      break;
    }
    int total = 0;
    3afe:	4d81                	li	s11,0
    while(1){
      int cc = write(fd, buf, BSIZE);
    3b00:	00005a17          	auipc	s4,0x5
    3b04:	188a0a13          	addi	s4,s4,392 # 8c88 <buf>
    name[0] = 'f';
    3b08:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3b0c:	0384c7bb          	divw	a5,s1,s8
    3b10:	0307879b          	addiw	a5,a5,48
    3b14:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3b18:	0384e7bb          	remw	a5,s1,s8
    3b1c:	0377c7bb          	divw	a5,a5,s7
    3b20:	0307879b          	addiw	a5,a5,48
    3b24:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3b28:	0374e7bb          	remw	a5,s1,s7
    3b2c:	0367c7bb          	divw	a5,a5,s6
    3b30:	0307879b          	addiw	a5,a5,48
    3b34:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3b38:	0364e7bb          	remw	a5,s1,s6
    3b3c:	0307879b          	addiw	a5,a5,48
    3b40:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3b44:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    3b48:	f5040593          	addi	a1,s0,-176
    3b4c:	8566                	mv	a0,s9
    3b4e:	00001097          	auipc	ra,0x1
    3b52:	990080e7          	jalr	-1648(ra) # 44de <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3b56:	20200593          	li	a1,514
    3b5a:	f5040513          	addi	a0,s0,-176
    3b5e:	00000097          	auipc	ra,0x0
    3b62:	628080e7          	jalr	1576(ra) # 4186 <open>
    3b66:	892a                	mv	s2,a0
    if(fd < 0){
    3b68:	0a055663          	bgez	a0,3c14 <fsfull+0x15c>
      printf("open %s failed\n", name);
    3b6c:	f5040593          	addi	a1,s0,-176
    3b70:	00002517          	auipc	a0,0x2
    3b74:	76850513          	addi	a0,a0,1896 # 62d8 <malloc+0x1d3c>
    3b78:	00001097          	auipc	ra,0x1
    3b7c:	966080e7          	jalr	-1690(ra) # 44de <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b80:	0604c363          	bltz	s1,3be6 <fsfull+0x12e>
    char name[64];
    name[0] = 'f';
    3b84:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    3b88:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3b8c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3b90:	4929                	li	s2,10
  while(nfiles >= 0){
    3b92:	5afd                	li	s5,-1
    name[0] = 'f';
    3b94:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3b98:	0344c7bb          	divw	a5,s1,s4
    3b9c:	0307879b          	addiw	a5,a5,48
    3ba0:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3ba4:	0344e7bb          	remw	a5,s1,s4
    3ba8:	0337c7bb          	divw	a5,a5,s3
    3bac:	0307879b          	addiw	a5,a5,48
    3bb0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3bb4:	0334e7bb          	remw	a5,s1,s3
    3bb8:	0327c7bb          	divw	a5,a5,s2
    3bbc:	0307879b          	addiw	a5,a5,48
    3bc0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3bc4:	0324e7bb          	remw	a5,s1,s2
    3bc8:	0307879b          	addiw	a5,a5,48
    3bcc:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3bd0:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    3bd4:	f5040513          	addi	a0,s0,-176
    3bd8:	00000097          	auipc	ra,0x0
    3bdc:	5be080e7          	jalr	1470(ra) # 4196 <unlink>
    nfiles--;
    3be0:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    3be2:	fb5499e3          	bne	s1,s5,3b94 <fsfull+0xdc>
  }

  printf("fsfull test finished\n");
    3be6:	00002517          	auipc	a0,0x2
    3bea:	71250513          	addi	a0,a0,1810 # 62f8 <malloc+0x1d5c>
    3bee:	00001097          	auipc	ra,0x1
    3bf2:	8f0080e7          	jalr	-1808(ra) # 44de <printf>
}
    3bf6:	70aa                	ld	ra,168(sp)
    3bf8:	740a                	ld	s0,160(sp)
    3bfa:	64ea                	ld	s1,152(sp)
    3bfc:	694a                	ld	s2,144(sp)
    3bfe:	69aa                	ld	s3,136(sp)
    3c00:	6a0a                	ld	s4,128(sp)
    3c02:	7ae6                	ld	s5,120(sp)
    3c04:	7b46                	ld	s6,112(sp)
    3c06:	7ba6                	ld	s7,104(sp)
    3c08:	7c06                	ld	s8,96(sp)
    3c0a:	6ce6                	ld	s9,88(sp)
    3c0c:	6d46                	ld	s10,80(sp)
    3c0e:	6da6                	ld	s11,72(sp)
    3c10:	614d                	addi	sp,sp,176
    3c12:	8082                	ret
    int total = 0;
    3c14:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3c16:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3c1a:	40000613          	li	a2,1024
    3c1e:	85d2                	mv	a1,s4
    3c20:	854a                	mv	a0,s2
    3c22:	00000097          	auipc	ra,0x0
    3c26:	544080e7          	jalr	1348(ra) # 4166 <write>
      if(cc < BSIZE)
    3c2a:	00aad563          	bge	s5,a0,3c34 <fsfull+0x17c>
      total += cc;
    3c2e:	00a989bb          	addw	s3,s3,a0
    while(1){
    3c32:	b7e5                	j	3c1a <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    3c34:	85ce                	mv	a1,s3
    3c36:	00002517          	auipc	a0,0x2
    3c3a:	6b250513          	addi	a0,a0,1714 # 62e8 <malloc+0x1d4c>
    3c3e:	00001097          	auipc	ra,0x1
    3c42:	8a0080e7          	jalr	-1888(ra) # 44de <printf>
    close(fd);
    3c46:	854a                	mv	a0,s2
    3c48:	00000097          	auipc	ra,0x0
    3c4c:	526080e7          	jalr	1318(ra) # 416e <close>
    if(total == 0)
    3c50:	f20988e3          	beqz	s3,3b80 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3c54:	2485                	addiw	s1,s1,1
    3c56:	bd4d                	j	3b08 <fsfull+0x50>

0000000000003c58 <argptest>:

void argptest()
{
    3c58:	1101                	addi	sp,sp,-32
    3c5a:	ec06                	sd	ra,24(sp)
    3c5c:	e822                	sd	s0,16(sp)
    3c5e:	e426                	sd	s1,8(sp)
    3c60:	1000                	addi	s0,sp,32
  int fd;
  fd = open("init", O_RDONLY);
    3c62:	4581                	li	a1,0
    3c64:	00002517          	auipc	a0,0x2
    3c68:	6ac50513          	addi	a0,a0,1708 # 6310 <malloc+0x1d74>
    3c6c:	00000097          	auipc	ra,0x0
    3c70:	51a080e7          	jalr	1306(ra) # 4186 <open>
  if (fd < 0) {
    3c74:	04054263          	bltz	a0,3cb8 <argptest+0x60>
    3c78:	84aa                	mv	s1,a0
    fprintf(2, "open failed\n");
    exit(-1);
  }
  read(fd, sbrk(0) - 1, -1);
    3c7a:	4501                	li	a0,0
    3c7c:	00000097          	auipc	ra,0x0
    3c80:	552080e7          	jalr	1362(ra) # 41ce <sbrk>
    3c84:	567d                	li	a2,-1
    3c86:	fff50593          	addi	a1,a0,-1
    3c8a:	8526                	mv	a0,s1
    3c8c:	00000097          	auipc	ra,0x0
    3c90:	4d2080e7          	jalr	1234(ra) # 415e <read>
  close(fd);
    3c94:	8526                	mv	a0,s1
    3c96:	00000097          	auipc	ra,0x0
    3c9a:	4d8080e7          	jalr	1240(ra) # 416e <close>
  printf("arg test passed\n");
    3c9e:	00002517          	auipc	a0,0x2
    3ca2:	68a50513          	addi	a0,a0,1674 # 6328 <malloc+0x1d8c>
    3ca6:	00001097          	auipc	ra,0x1
    3caa:	838080e7          	jalr	-1992(ra) # 44de <printf>
}
    3cae:	60e2                	ld	ra,24(sp)
    3cb0:	6442                	ld	s0,16(sp)
    3cb2:	64a2                	ld	s1,8(sp)
    3cb4:	6105                	addi	sp,sp,32
    3cb6:	8082                	ret
    fprintf(2, "open failed\n");
    3cb8:	00002597          	auipc	a1,0x2
    3cbc:	66058593          	addi	a1,a1,1632 # 6318 <malloc+0x1d7c>
    3cc0:	4509                	li	a0,2
    3cc2:	00000097          	auipc	ra,0x0
    3cc6:	7ee080e7          	jalr	2030(ra) # 44b0 <fprintf>
    exit(-1);
    3cca:	557d                	li	a0,-1
    3ccc:	00000097          	auipc	ra,0x0
    3cd0:	47a080e7          	jalr	1146(ra) # 4146 <exit>

0000000000003cd4 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3cd4:	1141                	addi	sp,sp,-16
    3cd6:	e422                	sd	s0,8(sp)
    3cd8:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3cda:	00002717          	auipc	a4,0x2
    3cde:	78670713          	addi	a4,a4,1926 # 6460 <randstate>
    3ce2:	6308                	ld	a0,0(a4)
    3ce4:	001967b7          	lui	a5,0x196
    3ce8:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18a975>
    3cec:	02f50533          	mul	a0,a0,a5
    3cf0:	3c6ef7b7          	lui	a5,0x3c6ef
    3cf4:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e36c7>
    3cf8:	953e                	add	a0,a0,a5
    3cfa:	e308                	sd	a0,0(a4)
  return randstate;
}
    3cfc:	2501                	sext.w	a0,a0
    3cfe:	6422                	ld	s0,8(sp)
    3d00:	0141                	addi	sp,sp,16
    3d02:	8082                	ret

0000000000003d04 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest()
{
    3d04:	1101                	addi	sp,sp,-32
    3d06:	ec06                	sd	ra,24(sp)
    3d08:	e822                	sd	s0,16(sp)
    3d0a:	e426                	sd	s1,8(sp)
    3d0c:	1000                	addi	s0,sp,32
  int pid;
  int ppid = getpid();
    3d0e:	00000097          	auipc	ra,0x0
    3d12:	4b8080e7          	jalr	1208(ra) # 41c6 <getpid>
    3d16:	84aa                	mv	s1,a0
  
  printf("stack guard test\n");
    3d18:	00002517          	auipc	a0,0x2
    3d1c:	62850513          	addi	a0,a0,1576 # 6340 <malloc+0x1da4>
    3d20:	00000097          	auipc	ra,0x0
    3d24:	7be080e7          	jalr	1982(ra) # 44de <printf>
  pid = fork();
    3d28:	00000097          	auipc	ra,0x0
    3d2c:	416080e7          	jalr	1046(ra) # 413e <fork>
  if(pid == 0) {
    3d30:	c50d                	beqz	a0,3d5a <stacktest+0x56>
    // the *sp should cause a trap.
    printf("stacktest: read below stack %p\n", *sp);
    printf("stacktest: test FAILED\n");
    kill(ppid);
    exit(-1);
  } else if(pid < 0){
    3d32:	06054363          	bltz	a0,3d98 <stacktest+0x94>
    printf("fork failed\n");
    exit(-1);
  }
  wait(0);
    3d36:	4501                	li	a0,0
    3d38:	00000097          	auipc	ra,0x0
    3d3c:	416080e7          	jalr	1046(ra) # 414e <wait>
  printf("stack guard test ok\n");
    3d40:	00002517          	auipc	a0,0x2
    3d44:	65050513          	addi	a0,a0,1616 # 6390 <malloc+0x1df4>
    3d48:	00000097          	auipc	ra,0x0
    3d4c:	796080e7          	jalr	1942(ra) # 44de <printf>
}
    3d50:	60e2                	ld	ra,24(sp)
    3d52:	6442                	ld	s0,16(sp)
    3d54:	64a2                	ld	s1,8(sp)
    3d56:	6105                	addi	sp,sp,32
    3d58:	8082                	ret

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    3d5a:	870a                	mv	a4,sp
    printf("stacktest: read below stack %p\n", *sp);
    3d5c:	77fd                	lui	a5,0xfffff
    3d5e:	97ba                	add	a5,a5,a4
    3d60:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff3368>
    3d64:	00002517          	auipc	a0,0x2
    3d68:	5f450513          	addi	a0,a0,1524 # 6358 <malloc+0x1dbc>
    3d6c:	00000097          	auipc	ra,0x0
    3d70:	772080e7          	jalr	1906(ra) # 44de <printf>
    printf("stacktest: test FAILED\n");
    3d74:	00002517          	auipc	a0,0x2
    3d78:	60450513          	addi	a0,a0,1540 # 6378 <malloc+0x1ddc>
    3d7c:	00000097          	auipc	ra,0x0
    3d80:	762080e7          	jalr	1890(ra) # 44de <printf>
    kill(ppid);
    3d84:	8526                	mv	a0,s1
    3d86:	00000097          	auipc	ra,0x0
    3d8a:	3f0080e7          	jalr	1008(ra) # 4176 <kill>
    exit(-1);
    3d8e:	557d                	li	a0,-1
    3d90:	00000097          	auipc	ra,0x0
    3d94:	3b6080e7          	jalr	950(ra) # 4146 <exit>
    printf("fork failed\n");
    3d98:	00001517          	auipc	a0,0x1
    3d9c:	9b850513          	addi	a0,a0,-1608 # 4750 <malloc+0x1b4>
    3da0:	00000097          	auipc	ra,0x0
    3da4:	73e080e7          	jalr	1854(ra) # 44de <printf>
    exit(-1);
    3da8:	557d                	li	a0,-1
    3daa:	00000097          	auipc	ra,0x0
    3dae:	39c080e7          	jalr	924(ra) # 4146 <exit>

0000000000003db2 <main>:

int
main(int argc, char *argv[])
{
    3db2:	1141                	addi	sp,sp,-16
    3db4:	e406                	sd	ra,8(sp)
    3db6:	e022                	sd	s0,0(sp)
    3db8:	0800                	addi	s0,sp,16
  printf("usertests starting\n");
    3dba:	00002517          	auipc	a0,0x2
    3dbe:	5ee50513          	addi	a0,a0,1518 # 63a8 <malloc+0x1e0c>
    3dc2:	00000097          	auipc	ra,0x0
    3dc6:	71c080e7          	jalr	1820(ra) # 44de <printf>

  if(open("usertests.ran", 0) >= 0){
    3dca:	4581                	li	a1,0
    3dcc:	00002517          	auipc	a0,0x2
    3dd0:	5f450513          	addi	a0,a0,1524 # 63c0 <malloc+0x1e24>
    3dd4:	00000097          	auipc	ra,0x0
    3dd8:	3b2080e7          	jalr	946(ra) # 4186 <open>
    3ddc:	00054f63          	bltz	a0,3dfa <main+0x48>
    printf("already ran user tests -- rebuild fs.img\n");
    3de0:	00002517          	auipc	a0,0x2
    3de4:	5f050513          	addi	a0,a0,1520 # 63d0 <malloc+0x1e34>
    3de8:	00000097          	auipc	ra,0x0
    3dec:	6f6080e7          	jalr	1782(ra) # 44de <printf>
    exit(-1);
    3df0:	557d                	li	a0,-1
    3df2:	00000097          	auipc	ra,0x0
    3df6:	354080e7          	jalr	852(ra) # 4146 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3dfa:	20000593          	li	a1,512
    3dfe:	00002517          	auipc	a0,0x2
    3e02:	5c250513          	addi	a0,a0,1474 # 63c0 <malloc+0x1e24>
    3e06:	00000097          	auipc	ra,0x0
    3e0a:	380080e7          	jalr	896(ra) # 4186 <open>
    3e0e:	00000097          	auipc	ra,0x0
    3e12:	360080e7          	jalr	864(ra) # 416e <close>

  reparent();
    3e16:	ffffd097          	auipc	ra,0xffffd
    3e1a:	f32080e7          	jalr	-206(ra) # d48 <reparent>
  twochildren();
    3e1e:	ffffd097          	auipc	ra,0xffffd
    3e22:	010080e7          	jalr	16(ra) # e2e <twochildren>
  forkfork();
    3e26:	ffffd097          	auipc	ra,0xffffd
    3e2a:	0b8080e7          	jalr	184(ra) # ede <forkfork>
  forkforkfork();
    3e2e:	ffffd097          	auipc	ra,0xffffd
    3e32:	192080e7          	jalr	402(ra) # fc0 <forkforkfork>
  
  argptest();
    3e36:	00000097          	auipc	ra,0x0
    3e3a:	e22080e7          	jalr	-478(ra) # 3c58 <argptest>
  createdelete();
    3e3e:	ffffd097          	auipc	ra,0xffffd
    3e42:	734080e7          	jalr	1844(ra) # 1572 <createdelete>
  linkunlink();
    3e46:	ffffe097          	auipc	ra,0xffffe
    3e4a:	090080e7          	jalr	144(ra) # 1ed6 <linkunlink>
  concreate();
    3e4e:	ffffe097          	auipc	ra,0xffffe
    3e52:	d78080e7          	jalr	-648(ra) # 1bc6 <concreate>
  fourfiles();
    3e56:	ffffd097          	auipc	ra,0xffffd
    3e5a:	4ca080e7          	jalr	1226(ra) # 1320 <fourfiles>
  sharedfd();
    3e5e:	ffffd097          	auipc	ra,0xffffd
    3e62:	312080e7          	jalr	786(ra) # 1170 <sharedfd>

  bigargtest();
    3e66:	00000097          	auipc	ra,0x0
    3e6a:	b30080e7          	jalr	-1232(ra) # 3996 <bigargtest>
  bigwrite();
    3e6e:	fffff097          	auipc	ra,0xfffff
    3e72:	a90080e7          	jalr	-1392(ra) # 28fe <bigwrite>
  bigargtest();
    3e76:	00000097          	auipc	ra,0x0
    3e7a:	b20080e7          	jalr	-1248(ra) # 3996 <bigargtest>
  bsstest();
    3e7e:	00000097          	auipc	ra,0x0
    3e82:	ab2080e7          	jalr	-1358(ra) # 3930 <bsstest>
  sbrktest();
    3e86:	fffff097          	auipc	ra,0xfffff
    3e8a:	49a080e7          	jalr	1178(ra) # 3320 <sbrktest>
  validatetest();
    3e8e:	00000097          	auipc	ra,0x0
    3e92:	a1c080e7          	jalr	-1508(ra) # 38aa <validatetest>
  stacktest();
    3e96:	00000097          	auipc	ra,0x0
    3e9a:	e6e080e7          	jalr	-402(ra) # 3d04 <stacktest>
  
  opentest();
    3e9e:	ffffc097          	auipc	ra,0xffffc
    3ea2:	440080e7          	jalr	1088(ra) # 2de <opentest>
  writetest();
    3ea6:	ffffc097          	auipc	ra,0xffffc
    3eaa:	4d0080e7          	jalr	1232(ra) # 376 <writetest>
  writetest1();
    3eae:	ffffc097          	auipc	ra,0xffffc
    3eb2:	6a8080e7          	jalr	1704(ra) # 556 <writetest1>
  createtest();
    3eb6:	ffffd097          	auipc	ra,0xffffd
    3eba:	862080e7          	jalr	-1950(ra) # 718 <createtest>

  openiputtest();
    3ebe:	ffffc097          	auipc	ra,0xffffc
    3ec2:	320080e7          	jalr	800(ra) # 1de <openiputtest>
  exitiputtest();
    3ec6:	ffffc097          	auipc	ra,0xffffc
    3eca:	222080e7          	jalr	546(ra) # e8 <exitiputtest>
  iputtest();
    3ece:	ffffc097          	auipc	ra,0xffffc
    3ed2:	132080e7          	jalr	306(ra) # 0 <iputtest>

  mem();
    3ed6:	ffffd097          	auipc	ra,0xffffd
    3eda:	1d6080e7          	jalr	470(ra) # 10ac <mem>
  pipe1();
    3ede:	ffffd097          	auipc	ra,0xffffd
    3ee2:	a2c080e7          	jalr	-1492(ra) # 90a <pipe1>
  preempt();
    3ee6:	ffffd097          	auipc	ra,0xffffd
    3eea:	be6080e7          	jalr	-1050(ra) # acc <preempt>
  exitwait();
    3eee:	ffffd097          	auipc	ra,0xffffd
    3ef2:	d92080e7          	jalr	-622(ra) # c80 <exitwait>

  rmdot();
    3ef6:	fffff097          	auipc	ra,0xfffff
    3efa:	e48080e7          	jalr	-440(ra) # 2d3e <rmdot>
  fourteen();
    3efe:	fffff097          	auipc	ra,0xfffff
    3f02:	cee080e7          	jalr	-786(ra) # 2bec <fourteen>
  bigfile();
    3f06:	fffff097          	auipc	ra,0xfffff
    3f0a:	afa080e7          	jalr	-1286(ra) # 2a00 <bigfile>
  subdir();
    3f0e:	ffffe097          	auipc	ra,0xffffe
    3f12:	25a080e7          	jalr	602(ra) # 2168 <subdir>
  linktest();
    3f16:	ffffe097          	auipc	ra,0xffffe
    3f1a:	a5c080e7          	jalr	-1444(ra) # 1972 <linktest>
  unlinkread();
    3f1e:	ffffe097          	auipc	ra,0xffffe
    3f22:	890080e7          	jalr	-1904(ra) # 17ae <unlinkread>
  dirfile();
    3f26:	fffff097          	auipc	ra,0xfffff
    3f2a:	fa8080e7          	jalr	-88(ra) # 2ece <dirfile>
  iref();
    3f2e:	fffff097          	auipc	ra,0xfffff
    3f32:	1dc080e7          	jalr	476(ra) # 310a <iref>
  forktest();
    3f36:	fffff097          	auipc	ra,0xfffff
    3f3a:	2f8080e7          	jalr	760(ra) # 322e <forktest>
  bigdir(); // slow
    3f3e:	ffffe097          	auipc	ra,0xffffe
    3f42:	0b6080e7          	jalr	182(ra) # 1ff4 <bigdir>

  exectest();
    3f46:	ffffd097          	auipc	ra,0xffffd
    3f4a:	96e080e7          	jalr	-1682(ra) # 8b4 <exectest>

  exit(0);
    3f4e:	4501                	li	a0,0
    3f50:	00000097          	auipc	ra,0x0
    3f54:	1f6080e7          	jalr	502(ra) # 4146 <exit>

0000000000003f58 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    3f58:	1141                	addi	sp,sp,-16
    3f5a:	e422                	sd	s0,8(sp)
    3f5c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3f5e:	87aa                	mv	a5,a0
    3f60:	0585                	addi	a1,a1,1
    3f62:	0785                	addi	a5,a5,1
    3f64:	fff5c703          	lbu	a4,-1(a1)
    3f68:	fee78fa3          	sb	a4,-1(a5)
    3f6c:	fb75                	bnez	a4,3f60 <strcpy+0x8>
    ;
  return os;
}
    3f6e:	6422                	ld	s0,8(sp)
    3f70:	0141                	addi	sp,sp,16
    3f72:	8082                	ret

0000000000003f74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3f74:	1141                	addi	sp,sp,-16
    3f76:	e422                	sd	s0,8(sp)
    3f78:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    3f7a:	00054783          	lbu	a5,0(a0)
    3f7e:	cb91                	beqz	a5,3f92 <strcmp+0x1e>
    3f80:	0005c703          	lbu	a4,0(a1)
    3f84:	00f71763          	bne	a4,a5,3f92 <strcmp+0x1e>
    p++, q++;
    3f88:	0505                	addi	a0,a0,1
    3f8a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    3f8c:	00054783          	lbu	a5,0(a0)
    3f90:	fbe5                	bnez	a5,3f80 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    3f92:	0005c503          	lbu	a0,0(a1)
}
    3f96:	40a7853b          	subw	a0,a5,a0
    3f9a:	6422                	ld	s0,8(sp)
    3f9c:	0141                	addi	sp,sp,16
    3f9e:	8082                	ret

0000000000003fa0 <strlen>:

uint
strlen(const char *s)
{
    3fa0:	1141                	addi	sp,sp,-16
    3fa2:	e422                	sd	s0,8(sp)
    3fa4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    3fa6:	00054783          	lbu	a5,0(a0)
    3faa:	cf91                	beqz	a5,3fc6 <strlen+0x26>
    3fac:	0505                	addi	a0,a0,1
    3fae:	87aa                	mv	a5,a0
    3fb0:	4685                	li	a3,1
    3fb2:	9e89                	subw	a3,a3,a0
    3fb4:	00f6853b          	addw	a0,a3,a5
    3fb8:	0785                	addi	a5,a5,1
    3fba:	fff7c703          	lbu	a4,-1(a5)
    3fbe:	fb7d                	bnez	a4,3fb4 <strlen+0x14>
    ;
  return n;
}
    3fc0:	6422                	ld	s0,8(sp)
    3fc2:	0141                	addi	sp,sp,16
    3fc4:	8082                	ret
  for(n = 0; s[n]; n++)
    3fc6:	4501                	li	a0,0
    3fc8:	bfe5                	j	3fc0 <strlen+0x20>

0000000000003fca <memset>:

void*
memset(void *dst, int c, uint n)
{
    3fca:	1141                	addi	sp,sp,-16
    3fcc:	e422                	sd	s0,8(sp)
    3fce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    3fd0:	ca19                	beqz	a2,3fe6 <memset+0x1c>
    3fd2:	87aa                	mv	a5,a0
    3fd4:	1602                	slli	a2,a2,0x20
    3fd6:	9201                	srli	a2,a2,0x20
    3fd8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    3fdc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    3fe0:	0785                	addi	a5,a5,1
    3fe2:	fee79de3          	bne	a5,a4,3fdc <memset+0x12>
  }
  return dst;
}
    3fe6:	6422                	ld	s0,8(sp)
    3fe8:	0141                	addi	sp,sp,16
    3fea:	8082                	ret

0000000000003fec <strchr>:

char*
strchr(const char *s, char c)
{
    3fec:	1141                	addi	sp,sp,-16
    3fee:	e422                	sd	s0,8(sp)
    3ff0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    3ff2:	00054783          	lbu	a5,0(a0)
    3ff6:	cb99                	beqz	a5,400c <strchr+0x20>
    if(*s == c)
    3ff8:	00f58763          	beq	a1,a5,4006 <strchr+0x1a>
  for(; *s; s++)
    3ffc:	0505                	addi	a0,a0,1
    3ffe:	00054783          	lbu	a5,0(a0)
    4002:	fbfd                	bnez	a5,3ff8 <strchr+0xc>
      return (char*)s;
  return 0;
    4004:	4501                	li	a0,0
}
    4006:	6422                	ld	s0,8(sp)
    4008:	0141                	addi	sp,sp,16
    400a:	8082                	ret
  return 0;
    400c:	4501                	li	a0,0
    400e:	bfe5                	j	4006 <strchr+0x1a>

0000000000004010 <gets>:

char*
gets(char *buf, int max)
{
    4010:	711d                	addi	sp,sp,-96
    4012:	ec86                	sd	ra,88(sp)
    4014:	e8a2                	sd	s0,80(sp)
    4016:	e4a6                	sd	s1,72(sp)
    4018:	e0ca                	sd	s2,64(sp)
    401a:	fc4e                	sd	s3,56(sp)
    401c:	f852                	sd	s4,48(sp)
    401e:	f456                	sd	s5,40(sp)
    4020:	f05a                	sd	s6,32(sp)
    4022:	ec5e                	sd	s7,24(sp)
    4024:	1080                	addi	s0,sp,96
    4026:	8baa                	mv	s7,a0
    4028:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    402a:	892a                	mv	s2,a0
    402c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    402e:	4aa9                	li	s5,10
    4030:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4032:	89a6                	mv	s3,s1
    4034:	2485                	addiw	s1,s1,1
    4036:	0344d863          	bge	s1,s4,4066 <gets+0x56>
    cc = read(0, &c, 1);
    403a:	4605                	li	a2,1
    403c:	faf40593          	addi	a1,s0,-81
    4040:	4501                	li	a0,0
    4042:	00000097          	auipc	ra,0x0
    4046:	11c080e7          	jalr	284(ra) # 415e <read>
    if(cc < 1)
    404a:	00a05e63          	blez	a0,4066 <gets+0x56>
    buf[i++] = c;
    404e:	faf44783          	lbu	a5,-81(s0)
    4052:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4056:	01578763          	beq	a5,s5,4064 <gets+0x54>
    405a:	0905                	addi	s2,s2,1
    405c:	fd679be3          	bne	a5,s6,4032 <gets+0x22>
  for(i=0; i+1 < max; ){
    4060:	89a6                	mv	s3,s1
    4062:	a011                	j	4066 <gets+0x56>
    4064:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4066:	99de                	add	s3,s3,s7
    4068:	00098023          	sb	zero,0(s3)
  return buf;
}
    406c:	855e                	mv	a0,s7
    406e:	60e6                	ld	ra,88(sp)
    4070:	6446                	ld	s0,80(sp)
    4072:	64a6                	ld	s1,72(sp)
    4074:	6906                	ld	s2,64(sp)
    4076:	79e2                	ld	s3,56(sp)
    4078:	7a42                	ld	s4,48(sp)
    407a:	7aa2                	ld	s5,40(sp)
    407c:	7b02                	ld	s6,32(sp)
    407e:	6be2                	ld	s7,24(sp)
    4080:	6125                	addi	sp,sp,96
    4082:	8082                	ret

0000000000004084 <stat>:

int
stat(const char *n, struct stat *st)
{
    4084:	1101                	addi	sp,sp,-32
    4086:	ec06                	sd	ra,24(sp)
    4088:	e822                	sd	s0,16(sp)
    408a:	e426                	sd	s1,8(sp)
    408c:	e04a                	sd	s2,0(sp)
    408e:	1000                	addi	s0,sp,32
    4090:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4092:	4581                	li	a1,0
    4094:	00000097          	auipc	ra,0x0
    4098:	0f2080e7          	jalr	242(ra) # 4186 <open>
  if(fd < 0)
    409c:	02054563          	bltz	a0,40c6 <stat+0x42>
    40a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    40a2:	85ca                	mv	a1,s2
    40a4:	00000097          	auipc	ra,0x0
    40a8:	0fa080e7          	jalr	250(ra) # 419e <fstat>
    40ac:	892a                	mv	s2,a0
  close(fd);
    40ae:	8526                	mv	a0,s1
    40b0:	00000097          	auipc	ra,0x0
    40b4:	0be080e7          	jalr	190(ra) # 416e <close>
  return r;
}
    40b8:	854a                	mv	a0,s2
    40ba:	60e2                	ld	ra,24(sp)
    40bc:	6442                	ld	s0,16(sp)
    40be:	64a2                	ld	s1,8(sp)
    40c0:	6902                	ld	s2,0(sp)
    40c2:	6105                	addi	sp,sp,32
    40c4:	8082                	ret
    return -1;
    40c6:	597d                	li	s2,-1
    40c8:	bfc5                	j	40b8 <stat+0x34>

00000000000040ca <atoi>:

int
atoi(const char *s)
{
    40ca:	1141                	addi	sp,sp,-16
    40cc:	e422                	sd	s0,8(sp)
    40ce:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    40d0:	00054603          	lbu	a2,0(a0)
    40d4:	fd06079b          	addiw	a5,a2,-48
    40d8:	0ff7f793          	andi	a5,a5,255
    40dc:	4725                	li	a4,9
    40de:	02f76963          	bltu	a4,a5,4110 <atoi+0x46>
    40e2:	86aa                	mv	a3,a0
  n = 0;
    40e4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    40e6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    40e8:	0685                	addi	a3,a3,1
    40ea:	0025179b          	slliw	a5,a0,0x2
    40ee:	9fa9                	addw	a5,a5,a0
    40f0:	0017979b          	slliw	a5,a5,0x1
    40f4:	9fb1                	addw	a5,a5,a2
    40f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    40fa:	0006c603          	lbu	a2,0(a3)
    40fe:	fd06071b          	addiw	a4,a2,-48
    4102:	0ff77713          	andi	a4,a4,255
    4106:	fee5f1e3          	bgeu	a1,a4,40e8 <atoi+0x1e>
  return n;
}
    410a:	6422                	ld	s0,8(sp)
    410c:	0141                	addi	sp,sp,16
    410e:	8082                	ret
  n = 0;
    4110:	4501                	li	a0,0
    4112:	bfe5                	j	410a <atoi+0x40>

0000000000004114 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4114:	1141                	addi	sp,sp,-16
    4116:	e422                	sd	s0,8(sp)
    4118:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    411a:	00c05f63          	blez	a2,4138 <memmove+0x24>
    411e:	1602                	slli	a2,a2,0x20
    4120:	9201                	srli	a2,a2,0x20
    4122:	00c506b3          	add	a3,a0,a2
  dst = vdst;
    4126:	87aa                	mv	a5,a0
    *dst++ = *src++;
    4128:	0585                	addi	a1,a1,1
    412a:	0785                	addi	a5,a5,1
    412c:	fff5c703          	lbu	a4,-1(a1)
    4130:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
    4134:	fed79ae3          	bne	a5,a3,4128 <memmove+0x14>
  return vdst;
}
    4138:	6422                	ld	s0,8(sp)
    413a:	0141                	addi	sp,sp,16
    413c:	8082                	ret

000000000000413e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    413e:	4885                	li	a7,1
 ecall
    4140:	00000073          	ecall
 ret
    4144:	8082                	ret

0000000000004146 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4146:	4889                	li	a7,2
 ecall
    4148:	00000073          	ecall
 ret
    414c:	8082                	ret

000000000000414e <wait>:
.global wait
wait:
 li a7, SYS_wait
    414e:	488d                	li	a7,3
 ecall
    4150:	00000073          	ecall
 ret
    4154:	8082                	ret

0000000000004156 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4156:	4891                	li	a7,4
 ecall
    4158:	00000073          	ecall
 ret
    415c:	8082                	ret

000000000000415e <read>:
.global read
read:
 li a7, SYS_read
    415e:	4895                	li	a7,5
 ecall
    4160:	00000073          	ecall
 ret
    4164:	8082                	ret

0000000000004166 <write>:
.global write
write:
 li a7, SYS_write
    4166:	48c1                	li	a7,16
 ecall
    4168:	00000073          	ecall
 ret
    416c:	8082                	ret

000000000000416e <close>:
.global close
close:
 li a7, SYS_close
    416e:	48d5                	li	a7,21
 ecall
    4170:	00000073          	ecall
 ret
    4174:	8082                	ret

0000000000004176 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4176:	4899                	li	a7,6
 ecall
    4178:	00000073          	ecall
 ret
    417c:	8082                	ret

000000000000417e <exec>:
.global exec
exec:
 li a7, SYS_exec
    417e:	489d                	li	a7,7
 ecall
    4180:	00000073          	ecall
 ret
    4184:	8082                	ret

0000000000004186 <open>:
.global open
open:
 li a7, SYS_open
    4186:	48bd                	li	a7,15
 ecall
    4188:	00000073          	ecall
 ret
    418c:	8082                	ret

000000000000418e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    418e:	48c5                	li	a7,17
 ecall
    4190:	00000073          	ecall
 ret
    4194:	8082                	ret

0000000000004196 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4196:	48c9                	li	a7,18
 ecall
    4198:	00000073          	ecall
 ret
    419c:	8082                	ret

000000000000419e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    419e:	48a1                	li	a7,8
 ecall
    41a0:	00000073          	ecall
 ret
    41a4:	8082                	ret

00000000000041a6 <link>:
.global link
link:
 li a7, SYS_link
    41a6:	48cd                	li	a7,19
 ecall
    41a8:	00000073          	ecall
 ret
    41ac:	8082                	ret

00000000000041ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    41ae:	48d1                	li	a7,20
 ecall
    41b0:	00000073          	ecall
 ret
    41b4:	8082                	ret

00000000000041b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    41b6:	48a5                	li	a7,9
 ecall
    41b8:	00000073          	ecall
 ret
    41bc:	8082                	ret

00000000000041be <dup>:
.global dup
dup:
 li a7, SYS_dup
    41be:	48a9                	li	a7,10
 ecall
    41c0:	00000073          	ecall
 ret
    41c4:	8082                	ret

00000000000041c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    41c6:	48ad                	li	a7,11
 ecall
    41c8:	00000073          	ecall
 ret
    41cc:	8082                	ret

00000000000041ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    41ce:	48b1                	li	a7,12
 ecall
    41d0:	00000073          	ecall
 ret
    41d4:	8082                	ret

00000000000041d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    41d6:	48b5                	li	a7,13
 ecall
    41d8:	00000073          	ecall
 ret
    41dc:	8082                	ret

00000000000041de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    41de:	48b9                	li	a7,14
 ecall
    41e0:	00000073          	ecall
 ret
    41e4:	8082                	ret

00000000000041e6 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
    41e6:	48d9                	li	a7,22
 ecall
    41e8:	00000073          	ecall
 ret
    41ec:	8082                	ret

00000000000041ee <crash>:
.global crash
crash:
 li a7, SYS_crash
    41ee:	48dd                	li	a7,23
 ecall
    41f0:	00000073          	ecall
 ret
    41f4:	8082                	ret

00000000000041f6 <mount>:
.global mount
mount:
 li a7, SYS_mount
    41f6:	48e1                	li	a7,24
 ecall
    41f8:	00000073          	ecall
 ret
    41fc:	8082                	ret

00000000000041fe <umount>:
.global umount
umount:
 li a7, SYS_umount
    41fe:	48e5                	li	a7,25
 ecall
    4200:	00000073          	ecall
 ret
    4204:	8082                	ret

0000000000004206 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4206:	1101                	addi	sp,sp,-32
    4208:	ec06                	sd	ra,24(sp)
    420a:	e822                	sd	s0,16(sp)
    420c:	1000                	addi	s0,sp,32
    420e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4212:	4605                	li	a2,1
    4214:	fef40593          	addi	a1,s0,-17
    4218:	00000097          	auipc	ra,0x0
    421c:	f4e080e7          	jalr	-178(ra) # 4166 <write>
}
    4220:	60e2                	ld	ra,24(sp)
    4222:	6442                	ld	s0,16(sp)
    4224:	6105                	addi	sp,sp,32
    4226:	8082                	ret

0000000000004228 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4228:	7139                	addi	sp,sp,-64
    422a:	fc06                	sd	ra,56(sp)
    422c:	f822                	sd	s0,48(sp)
    422e:	f426                	sd	s1,40(sp)
    4230:	f04a                	sd	s2,32(sp)
    4232:	ec4e                	sd	s3,24(sp)
    4234:	0080                	addi	s0,sp,64
    4236:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4238:	c299                	beqz	a3,423e <printint+0x16>
    423a:	0805c863          	bltz	a1,42ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    423e:	2581                	sext.w	a1,a1
  neg = 0;
    4240:	4881                	li	a7,0
    4242:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4246:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4248:	2601                	sext.w	a2,a2
    424a:	00002517          	auipc	a0,0x2
    424e:	1d650513          	addi	a0,a0,470 # 6420 <digits>
    4252:	883a                	mv	a6,a4
    4254:	2705                	addiw	a4,a4,1
    4256:	02c5f7bb          	remuw	a5,a1,a2
    425a:	1782                	slli	a5,a5,0x20
    425c:	9381                	srli	a5,a5,0x20
    425e:	97aa                	add	a5,a5,a0
    4260:	0007c783          	lbu	a5,0(a5)
    4264:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4268:	0005879b          	sext.w	a5,a1
    426c:	02c5d5bb          	divuw	a1,a1,a2
    4270:	0685                	addi	a3,a3,1
    4272:	fec7f0e3          	bgeu	a5,a2,4252 <printint+0x2a>
  if(neg)
    4276:	00088b63          	beqz	a7,428c <printint+0x64>
    buf[i++] = '-';
    427a:	fd040793          	addi	a5,s0,-48
    427e:	973e                	add	a4,a4,a5
    4280:	02d00793          	li	a5,45
    4284:	fef70823          	sb	a5,-16(a4)
    4288:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    428c:	02e05863          	blez	a4,42bc <printint+0x94>
    4290:	fc040793          	addi	a5,s0,-64
    4294:	00e78933          	add	s2,a5,a4
    4298:	fff78993          	addi	s3,a5,-1
    429c:	99ba                	add	s3,s3,a4
    429e:	377d                	addiw	a4,a4,-1
    42a0:	1702                	slli	a4,a4,0x20
    42a2:	9301                	srli	a4,a4,0x20
    42a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    42a8:	fff94583          	lbu	a1,-1(s2)
    42ac:	8526                	mv	a0,s1
    42ae:	00000097          	auipc	ra,0x0
    42b2:	f58080e7          	jalr	-168(ra) # 4206 <putc>
  while(--i >= 0)
    42b6:	197d                	addi	s2,s2,-1
    42b8:	ff3918e3          	bne	s2,s3,42a8 <printint+0x80>
}
    42bc:	70e2                	ld	ra,56(sp)
    42be:	7442                	ld	s0,48(sp)
    42c0:	74a2                	ld	s1,40(sp)
    42c2:	7902                	ld	s2,32(sp)
    42c4:	69e2                	ld	s3,24(sp)
    42c6:	6121                	addi	sp,sp,64
    42c8:	8082                	ret
    x = -xx;
    42ca:	40b005bb          	negw	a1,a1
    neg = 1;
    42ce:	4885                	li	a7,1
    x = -xx;
    42d0:	bf8d                	j	4242 <printint+0x1a>

00000000000042d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    42d2:	7119                	addi	sp,sp,-128
    42d4:	fc86                	sd	ra,120(sp)
    42d6:	f8a2                	sd	s0,112(sp)
    42d8:	f4a6                	sd	s1,104(sp)
    42da:	f0ca                	sd	s2,96(sp)
    42dc:	ecce                	sd	s3,88(sp)
    42de:	e8d2                	sd	s4,80(sp)
    42e0:	e4d6                	sd	s5,72(sp)
    42e2:	e0da                	sd	s6,64(sp)
    42e4:	fc5e                	sd	s7,56(sp)
    42e6:	f862                	sd	s8,48(sp)
    42e8:	f466                	sd	s9,40(sp)
    42ea:	f06a                	sd	s10,32(sp)
    42ec:	ec6e                	sd	s11,24(sp)
    42ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    42f0:	0005c903          	lbu	s2,0(a1)
    42f4:	18090f63          	beqz	s2,4492 <vprintf+0x1c0>
    42f8:	8aaa                	mv	s5,a0
    42fa:	8b32                	mv	s6,a2
    42fc:	00158493          	addi	s1,a1,1
  state = 0;
    4300:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    4302:	02500a13          	li	s4,37
      if(c == 'd'){
    4306:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    430a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    430e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    4312:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4316:	00002b97          	auipc	s7,0x2
    431a:	10ab8b93          	addi	s7,s7,266 # 6420 <digits>
    431e:	a839                	j	433c <vprintf+0x6a>
        putc(fd, c);
    4320:	85ca                	mv	a1,s2
    4322:	8556                	mv	a0,s5
    4324:	00000097          	auipc	ra,0x0
    4328:	ee2080e7          	jalr	-286(ra) # 4206 <putc>
    432c:	a019                	j	4332 <vprintf+0x60>
    } else if(state == '%'){
    432e:	01498f63          	beq	s3,s4,434c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4332:	0485                	addi	s1,s1,1
    4334:	fff4c903          	lbu	s2,-1(s1)
    4338:	14090d63          	beqz	s2,4492 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    433c:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4340:	fe0997e3          	bnez	s3,432e <vprintf+0x5c>
      if(c == '%'){
    4344:	fd479ee3          	bne	a5,s4,4320 <vprintf+0x4e>
        state = '%';
    4348:	89be                	mv	s3,a5
    434a:	b7e5                	j	4332 <vprintf+0x60>
      if(c == 'd'){
    434c:	05878063          	beq	a5,s8,438c <vprintf+0xba>
      } else if(c == 'l') {
    4350:	05978c63          	beq	a5,s9,43a8 <vprintf+0xd6>
      } else if(c == 'x') {
    4354:	07a78863          	beq	a5,s10,43c4 <vprintf+0xf2>
      } else if(c == 'p') {
    4358:	09b78463          	beq	a5,s11,43e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    435c:	07300713          	li	a4,115
    4360:	0ce78663          	beq	a5,a4,442c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4364:	06300713          	li	a4,99
    4368:	0ee78e63          	beq	a5,a4,4464 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    436c:	11478863          	beq	a5,s4,447c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4370:	85d2                	mv	a1,s4
    4372:	8556                	mv	a0,s5
    4374:	00000097          	auipc	ra,0x0
    4378:	e92080e7          	jalr	-366(ra) # 4206 <putc>
        putc(fd, c);
    437c:	85ca                	mv	a1,s2
    437e:	8556                	mv	a0,s5
    4380:	00000097          	auipc	ra,0x0
    4384:	e86080e7          	jalr	-378(ra) # 4206 <putc>
      }
      state = 0;
    4388:	4981                	li	s3,0
    438a:	b765                	j	4332 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    438c:	008b0913          	addi	s2,s6,8
    4390:	4685                	li	a3,1
    4392:	4629                	li	a2,10
    4394:	000b2583          	lw	a1,0(s6)
    4398:	8556                	mv	a0,s5
    439a:	00000097          	auipc	ra,0x0
    439e:	e8e080e7          	jalr	-370(ra) # 4228 <printint>
    43a2:	8b4a                	mv	s6,s2
      state = 0;
    43a4:	4981                	li	s3,0
    43a6:	b771                	j	4332 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    43a8:	008b0913          	addi	s2,s6,8
    43ac:	4681                	li	a3,0
    43ae:	4629                	li	a2,10
    43b0:	000b2583          	lw	a1,0(s6)
    43b4:	8556                	mv	a0,s5
    43b6:	00000097          	auipc	ra,0x0
    43ba:	e72080e7          	jalr	-398(ra) # 4228 <printint>
    43be:	8b4a                	mv	s6,s2
      state = 0;
    43c0:	4981                	li	s3,0
    43c2:	bf85                	j	4332 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    43c4:	008b0913          	addi	s2,s6,8
    43c8:	4681                	li	a3,0
    43ca:	4641                	li	a2,16
    43cc:	000b2583          	lw	a1,0(s6)
    43d0:	8556                	mv	a0,s5
    43d2:	00000097          	auipc	ra,0x0
    43d6:	e56080e7          	jalr	-426(ra) # 4228 <printint>
    43da:	8b4a                	mv	s6,s2
      state = 0;
    43dc:	4981                	li	s3,0
    43de:	bf91                	j	4332 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    43e0:	008b0793          	addi	a5,s6,8
    43e4:	f8f43423          	sd	a5,-120(s0)
    43e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    43ec:	03000593          	li	a1,48
    43f0:	8556                	mv	a0,s5
    43f2:	00000097          	auipc	ra,0x0
    43f6:	e14080e7          	jalr	-492(ra) # 4206 <putc>
  putc(fd, 'x');
    43fa:	85ea                	mv	a1,s10
    43fc:	8556                	mv	a0,s5
    43fe:	00000097          	auipc	ra,0x0
    4402:	e08080e7          	jalr	-504(ra) # 4206 <putc>
    4406:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4408:	03c9d793          	srli	a5,s3,0x3c
    440c:	97de                	add	a5,a5,s7
    440e:	0007c583          	lbu	a1,0(a5)
    4412:	8556                	mv	a0,s5
    4414:	00000097          	auipc	ra,0x0
    4418:	df2080e7          	jalr	-526(ra) # 4206 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    441c:	0992                	slli	s3,s3,0x4
    441e:	397d                	addiw	s2,s2,-1
    4420:	fe0914e3          	bnez	s2,4408 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    4424:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    4428:	4981                	li	s3,0
    442a:	b721                	j	4332 <vprintf+0x60>
        s = va_arg(ap, char*);
    442c:	008b0993          	addi	s3,s6,8
    4430:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    4434:	02090163          	beqz	s2,4456 <vprintf+0x184>
        while(*s != 0){
    4438:	00094583          	lbu	a1,0(s2)
    443c:	c9a1                	beqz	a1,448c <vprintf+0x1ba>
          putc(fd, *s);
    443e:	8556                	mv	a0,s5
    4440:	00000097          	auipc	ra,0x0
    4444:	dc6080e7          	jalr	-570(ra) # 4206 <putc>
          s++;
    4448:	0905                	addi	s2,s2,1
        while(*s != 0){
    444a:	00094583          	lbu	a1,0(s2)
    444e:	f9e5                	bnez	a1,443e <vprintf+0x16c>
        s = va_arg(ap, char*);
    4450:	8b4e                	mv	s6,s3
      state = 0;
    4452:	4981                	li	s3,0
    4454:	bdf9                	j	4332 <vprintf+0x60>
          s = "(null)";
    4456:	00002917          	auipc	s2,0x2
    445a:	fc290913          	addi	s2,s2,-62 # 6418 <malloc+0x1e7c>
        while(*s != 0){
    445e:	02800593          	li	a1,40
    4462:	bff1                	j	443e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    4464:	008b0913          	addi	s2,s6,8
    4468:	000b4583          	lbu	a1,0(s6)
    446c:	8556                	mv	a0,s5
    446e:	00000097          	auipc	ra,0x0
    4472:	d98080e7          	jalr	-616(ra) # 4206 <putc>
    4476:	8b4a                	mv	s6,s2
      state = 0;
    4478:	4981                	li	s3,0
    447a:	bd65                	j	4332 <vprintf+0x60>
        putc(fd, c);
    447c:	85d2                	mv	a1,s4
    447e:	8556                	mv	a0,s5
    4480:	00000097          	auipc	ra,0x0
    4484:	d86080e7          	jalr	-634(ra) # 4206 <putc>
      state = 0;
    4488:	4981                	li	s3,0
    448a:	b565                	j	4332 <vprintf+0x60>
        s = va_arg(ap, char*);
    448c:	8b4e                	mv	s6,s3
      state = 0;
    448e:	4981                	li	s3,0
    4490:	b54d                	j	4332 <vprintf+0x60>
    }
  }
}
    4492:	70e6                	ld	ra,120(sp)
    4494:	7446                	ld	s0,112(sp)
    4496:	74a6                	ld	s1,104(sp)
    4498:	7906                	ld	s2,96(sp)
    449a:	69e6                	ld	s3,88(sp)
    449c:	6a46                	ld	s4,80(sp)
    449e:	6aa6                	ld	s5,72(sp)
    44a0:	6b06                	ld	s6,64(sp)
    44a2:	7be2                	ld	s7,56(sp)
    44a4:	7c42                	ld	s8,48(sp)
    44a6:	7ca2                	ld	s9,40(sp)
    44a8:	7d02                	ld	s10,32(sp)
    44aa:	6de2                	ld	s11,24(sp)
    44ac:	6109                	addi	sp,sp,128
    44ae:	8082                	ret

00000000000044b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    44b0:	715d                	addi	sp,sp,-80
    44b2:	ec06                	sd	ra,24(sp)
    44b4:	e822                	sd	s0,16(sp)
    44b6:	1000                	addi	s0,sp,32
    44b8:	e010                	sd	a2,0(s0)
    44ba:	e414                	sd	a3,8(s0)
    44bc:	e818                	sd	a4,16(s0)
    44be:	ec1c                	sd	a5,24(s0)
    44c0:	03043023          	sd	a6,32(s0)
    44c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    44c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    44cc:	8622                	mv	a2,s0
    44ce:	00000097          	auipc	ra,0x0
    44d2:	e04080e7          	jalr	-508(ra) # 42d2 <vprintf>
}
    44d6:	60e2                	ld	ra,24(sp)
    44d8:	6442                	ld	s0,16(sp)
    44da:	6161                	addi	sp,sp,80
    44dc:	8082                	ret

00000000000044de <printf>:

void
printf(const char *fmt, ...)
{
    44de:	711d                	addi	sp,sp,-96
    44e0:	ec06                	sd	ra,24(sp)
    44e2:	e822                	sd	s0,16(sp)
    44e4:	1000                	addi	s0,sp,32
    44e6:	e40c                	sd	a1,8(s0)
    44e8:	e810                	sd	a2,16(s0)
    44ea:	ec14                	sd	a3,24(s0)
    44ec:	f018                	sd	a4,32(s0)
    44ee:	f41c                	sd	a5,40(s0)
    44f0:	03043823          	sd	a6,48(s0)
    44f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    44f8:	00840613          	addi	a2,s0,8
    44fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4500:	85aa                	mv	a1,a0
    4502:	4505                	li	a0,1
    4504:	00000097          	auipc	ra,0x0
    4508:	dce080e7          	jalr	-562(ra) # 42d2 <vprintf>
}
    450c:	60e2                	ld	ra,24(sp)
    450e:	6442                	ld	s0,16(sp)
    4510:	6125                	addi	sp,sp,96
    4512:	8082                	ret

0000000000004514 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4514:	1141                	addi	sp,sp,-16
    4516:	e422                	sd	s0,8(sp)
    4518:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    451a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    451e:	00002797          	auipc	a5,0x2
    4522:	f527b783          	ld	a5,-174(a5) # 6470 <freep>
    4526:	a805                	j	4556 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4528:	4618                	lw	a4,8(a2)
    452a:	9db9                	addw	a1,a1,a4
    452c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4530:	6398                	ld	a4,0(a5)
    4532:	6318                	ld	a4,0(a4)
    4534:	fee53823          	sd	a4,-16(a0)
    4538:	a091                	j	457c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    453a:	ff852703          	lw	a4,-8(a0)
    453e:	9e39                	addw	a2,a2,a4
    4540:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4542:	ff053703          	ld	a4,-16(a0)
    4546:	e398                	sd	a4,0(a5)
    4548:	a099                	j	458e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    454a:	6398                	ld	a4,0(a5)
    454c:	00e7e463          	bltu	a5,a4,4554 <free+0x40>
    4550:	00e6ea63          	bltu	a3,a4,4564 <free+0x50>
{
    4554:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4556:	fed7fae3          	bgeu	a5,a3,454a <free+0x36>
    455a:	6398                	ld	a4,0(a5)
    455c:	00e6e463          	bltu	a3,a4,4564 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4560:	fee7eae3          	bltu	a5,a4,4554 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4564:	ff852583          	lw	a1,-8(a0)
    4568:	6390                	ld	a2,0(a5)
    456a:	02059813          	slli	a6,a1,0x20
    456e:	01c85713          	srli	a4,a6,0x1c
    4572:	9736                	add	a4,a4,a3
    4574:	fae60ae3          	beq	a2,a4,4528 <free+0x14>
    bp->s.ptr = p->s.ptr;
    4578:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    457c:	4790                	lw	a2,8(a5)
    457e:	02061593          	slli	a1,a2,0x20
    4582:	01c5d713          	srli	a4,a1,0x1c
    4586:	973e                	add	a4,a4,a5
    4588:	fae689e3          	beq	a3,a4,453a <free+0x26>
  } else
    p->s.ptr = bp;
    458c:	e394                	sd	a3,0(a5)
  freep = p;
    458e:	00002717          	auipc	a4,0x2
    4592:	eef73123          	sd	a5,-286(a4) # 6470 <freep>
}
    4596:	6422                	ld	s0,8(sp)
    4598:	0141                	addi	sp,sp,16
    459a:	8082                	ret

000000000000459c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    459c:	7139                	addi	sp,sp,-64
    459e:	fc06                	sd	ra,56(sp)
    45a0:	f822                	sd	s0,48(sp)
    45a2:	f426                	sd	s1,40(sp)
    45a4:	f04a                	sd	s2,32(sp)
    45a6:	ec4e                	sd	s3,24(sp)
    45a8:	e852                	sd	s4,16(sp)
    45aa:	e456                	sd	s5,8(sp)
    45ac:	e05a                	sd	s6,0(sp)
    45ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    45b0:	02051493          	slli	s1,a0,0x20
    45b4:	9081                	srli	s1,s1,0x20
    45b6:	04bd                	addi	s1,s1,15
    45b8:	8091                	srli	s1,s1,0x4
    45ba:	0014899b          	addiw	s3,s1,1
    45be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    45c0:	00002517          	auipc	a0,0x2
    45c4:	eb053503          	ld	a0,-336(a0) # 6470 <freep>
    45c8:	c515                	beqz	a0,45f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    45ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    45cc:	4798                	lw	a4,8(a5)
    45ce:	02977f63          	bgeu	a4,s1,460c <malloc+0x70>
    45d2:	8a4e                	mv	s4,s3
    45d4:	0009871b          	sext.w	a4,s3
    45d8:	6685                	lui	a3,0x1
    45da:	00d77363          	bgeu	a4,a3,45e0 <malloc+0x44>
    45de:	6a05                	lui	s4,0x1
    45e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    45e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    45e8:	00002917          	auipc	s2,0x2
    45ec:	e8890913          	addi	s2,s2,-376 # 6470 <freep>
  if(p == (char*)-1)
    45f0:	5afd                	li	s5,-1
    45f2:	a895                	j	4666 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    45f4:	00007797          	auipc	a5,0x7
    45f8:	69478793          	addi	a5,a5,1684 # bc88 <base>
    45fc:	00002717          	auipc	a4,0x2
    4600:	e6f73a23          	sd	a5,-396(a4) # 6470 <freep>
    4604:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4606:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    460a:	b7e1                	j	45d2 <malloc+0x36>
      if(p->s.size == nunits)
    460c:	02e48c63          	beq	s1,a4,4644 <malloc+0xa8>
        p->s.size -= nunits;
    4610:	4137073b          	subw	a4,a4,s3
    4614:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4616:	02071693          	slli	a3,a4,0x20
    461a:	01c6d713          	srli	a4,a3,0x1c
    461e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4620:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4624:	00002717          	auipc	a4,0x2
    4628:	e4a73623          	sd	a0,-436(a4) # 6470 <freep>
      return (void*)(p + 1);
    462c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4630:	70e2                	ld	ra,56(sp)
    4632:	7442                	ld	s0,48(sp)
    4634:	74a2                	ld	s1,40(sp)
    4636:	7902                	ld	s2,32(sp)
    4638:	69e2                	ld	s3,24(sp)
    463a:	6a42                	ld	s4,16(sp)
    463c:	6aa2                	ld	s5,8(sp)
    463e:	6b02                	ld	s6,0(sp)
    4640:	6121                	addi	sp,sp,64
    4642:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4644:	6398                	ld	a4,0(a5)
    4646:	e118                	sd	a4,0(a0)
    4648:	bff1                	j	4624 <malloc+0x88>
  hp->s.size = nu;
    464a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    464e:	0541                	addi	a0,a0,16
    4650:	00000097          	auipc	ra,0x0
    4654:	ec4080e7          	jalr	-316(ra) # 4514 <free>
  return freep;
    4658:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    465c:	d971                	beqz	a0,4630 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    465e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4660:	4798                	lw	a4,8(a5)
    4662:	fa9775e3          	bgeu	a4,s1,460c <malloc+0x70>
    if(p == freep)
    4666:	00093703          	ld	a4,0(s2)
    466a:	853e                	mv	a0,a5
    466c:	fef719e3          	bne	a4,a5,465e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    4670:	8552                	mv	a0,s4
    4672:	00000097          	auipc	ra,0x0
    4676:	b5c080e7          	jalr	-1188(ra) # 41ce <sbrk>
  if(p == (char*)-1)
    467a:	fd5518e3          	bne	a0,s5,464a <malloc+0xae>
        return 0;
    467e:	4501                	li	a0,0
    4680:	bf45                	j	4630 <malloc+0x94>
