
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test1();
  exit(0);
}

void test0()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n = 0;
  printf("start test0\n");  
   e:	00001517          	auipc	a0,0x1
  12:	a6250513          	addi	a0,a0,-1438 # a70 <malloc+0xea>
  16:	00001097          	auipc	ra,0x1
  1a:	8b2080e7          	jalr	-1870(ra) # 8c8 <printf>
  ntas(0);
  1e:	4501                	li	a0,0
  20:	00000097          	auipc	ra,0x0
  24:	5c8080e7          	jalr	1480(ra) # 5e8 <ntas>
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  28:	00000097          	auipc	ra,0x0
  2c:	518080e7          	jalr	1304(ra) # 540 <fork>
    if(pid < 0){
  30:	06054363          	bltz	a0,96 <test0+0x96>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  34:	cd35                	beqz	a0,b0 <test0+0xb0>
    int pid = fork();
  36:	00000097          	auipc	ra,0x0
  3a:	50a080e7          	jalr	1290(ra) # 540 <fork>
    if(pid < 0){
  3e:	04054c63          	bltz	a0,96 <test0+0x96>
    if(pid == 0){
  42:	c53d                	beqz	a0,b0 <test0+0xb0>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  44:	4501                	li	a0,0
  46:	00000097          	auipc	ra,0x0
  4a:	50a080e7          	jalr	1290(ra) # 550 <wait>
  4e:	4501                	li	a0,0
  50:	00000097          	auipc	ra,0x0
  54:	500080e7          	jalr	1280(ra) # 550 <wait>
  }
  printf("test0 results:\n");
  58:	00001517          	auipc	a0,0x1
  5c:	a4850513          	addi	a0,a0,-1464 # aa0 <malloc+0x11a>
  60:	00001097          	auipc	ra,0x1
  64:	868080e7          	jalr	-1944(ra) # 8c8 <printf>
  n = ntas(1);
  68:	4505                	li	a0,1
  6a:	00000097          	auipc	ra,0x0
  6e:	57e080e7          	jalr	1406(ra) # 5e8 <ntas>
  if(n < 10) 
  72:	47a5                	li	a5,9
  74:	08a7c863          	blt	a5,a0,104 <test0+0x104>
    printf("test0 OK\n");
  78:	00001517          	auipc	a0,0x1
  7c:	a3850513          	addi	a0,a0,-1480 # ab0 <malloc+0x12a>
  80:	00001097          	auipc	ra,0x1
  84:	848080e7          	jalr	-1976(ra) # 8c8 <printf>
  else
    printf("test0 FAIL\n");
}
  88:	70a2                	ld	ra,40(sp)
  8a:	7402                	ld	s0,32(sp)
  8c:	64e2                	ld	s1,24(sp)
  8e:	6942                	ld	s2,16(sp)
  90:	69a2                	ld	s3,8(sp)
  92:	6145                	addi	sp,sp,48
  94:	8082                	ret
      printf("fork failed");
  96:	00001517          	auipc	a0,0x1
  9a:	9ea50513          	addi	a0,a0,-1558 # a80 <malloc+0xfa>
  9e:	00001097          	auipc	ra,0x1
  a2:	82a080e7          	jalr	-2006(ra) # 8c8 <printf>
      exit(-1);
  a6:	557d                	li	a0,-1
  a8:	00000097          	auipc	ra,0x0
  ac:	4a0080e7          	jalr	1184(ra) # 548 <exit>
{
  b0:	6961                	lui	s2,0x18
  b2:	6a090913          	addi	s2,s2,1696 # 186a0 <__global_pointer$+0x17307>
        *(int *)(a+4) = 1;
  b6:	4985                	li	s3,1
        a = sbrk(4096);
  b8:	6505                	lui	a0,0x1
  ba:	00000097          	auipc	ra,0x0
  be:	516080e7          	jalr	1302(ra) # 5d0 <sbrk>
  c2:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
  c4:	01352223          	sw	s3,4(a0) # 1004 <__BSS_END__+0x44c>
        a1 = sbrk(-4096);
  c8:	757d                	lui	a0,0xfffff
  ca:	00000097          	auipc	ra,0x0
  ce:	506080e7          	jalr	1286(ra) # 5d0 <sbrk>
        if (a1 != a + 4096) {
  d2:	6785                	lui	a5,0x1
  d4:	94be                	add	s1,s1,a5
  d6:	00951a63          	bne	a0,s1,ea <test0+0xea>
      for(i = 0; i < N; i++) {
  da:	397d                	addiw	s2,s2,-1
  dc:	fc091ee3          	bnez	s2,b8 <test0+0xb8>
      exit(-1);
  e0:	557d                	li	a0,-1
  e2:	00000097          	auipc	ra,0x0
  e6:	466080e7          	jalr	1126(ra) # 548 <exit>
          printf("wrong sbrk\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	9a650513          	addi	a0,a0,-1626 # a90 <malloc+0x10a>
  f2:	00000097          	auipc	ra,0x0
  f6:	7d6080e7          	jalr	2006(ra) # 8c8 <printf>
          exit(-1);
  fa:	557d                	li	a0,-1
  fc:	00000097          	auipc	ra,0x0
 100:	44c080e7          	jalr	1100(ra) # 548 <exit>
    printf("test0 FAIL\n");
 104:	00001517          	auipc	a0,0x1
 108:	9bc50513          	addi	a0,a0,-1604 # ac0 <malloc+0x13a>
 10c:	00000097          	auipc	ra,0x0
 110:	7bc080e7          	jalr	1980(ra) # 8c8 <printf>
}
 114:	bf95                	j	88 <test0+0x88>

0000000000000116 <test1>:

// Run system out of memory and count tot memory allocated
void test1()
{
 116:	715d                	addi	sp,sp,-80
 118:	e486                	sd	ra,72(sp)
 11a:	e0a2                	sd	s0,64(sp)
 11c:	fc26                	sd	s1,56(sp)
 11e:	f84a                	sd	s2,48(sp)
 120:	f44e                	sd	s3,40(sp)
 122:	0880                	addi	s0,sp,80
  void *a;
  int pipes[NCHILD];
  int tot = 0;
  char buf[1];
  
  printf("start test1\n");  
 124:	00001517          	auipc	a0,0x1
 128:	9ac50513          	addi	a0,a0,-1620 # ad0 <malloc+0x14a>
 12c:	00000097          	auipc	ra,0x0
 130:	79c080e7          	jalr	1948(ra) # 8c8 <printf>
  for(int i = 0; i < NCHILD; i++){
 134:	fc840913          	addi	s2,s0,-56
    int fds[2];
    if(pipe(fds) != 0){
 138:	fb840513          	addi	a0,s0,-72
 13c:	00000097          	auipc	ra,0x0
 140:	41c080e7          	jalr	1052(ra) # 558 <pipe>
 144:	84aa                	mv	s1,a0
 146:	e905                	bnez	a0,176 <test1+0x60>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 148:	00000097          	auipc	ra,0x0
 14c:	3f8080e7          	jalr	1016(ra) # 540 <fork>
    if(pid < 0){
 150:	04054063          	bltz	a0,190 <test1+0x7a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 154:	c939                	beqz	a0,1aa <test1+0x94>
          exit(-1);
        }
      }
      exit(0);
    } else {
      close(fds[1]);
 156:	fbc42503          	lw	a0,-68(s0)
 15a:	00000097          	auipc	ra,0x0
 15e:	416080e7          	jalr	1046(ra) # 570 <close>
      pipes[i] = fds[0];
 162:	fb842783          	lw	a5,-72(s0)
 166:	00f92023          	sw	a5,0(s2)
  for(int i = 0; i < NCHILD; i++){
 16a:	0911                	addi	s2,s2,4
 16c:	fd040793          	addi	a5,s0,-48
 170:	fd2794e3          	bne	a5,s2,138 <test1+0x22>
 174:	a85d                	j	22a <test1+0x114>
      printf("pipe() failed\n");
 176:	00001517          	auipc	a0,0x1
 17a:	96a50513          	addi	a0,a0,-1686 # ae0 <malloc+0x15a>
 17e:	00000097          	auipc	ra,0x0
 182:	74a080e7          	jalr	1866(ra) # 8c8 <printf>
      exit(-1);
 186:	557d                	li	a0,-1
 188:	00000097          	auipc	ra,0x0
 18c:	3c0080e7          	jalr	960(ra) # 548 <exit>
      printf("fork failed");
 190:	00001517          	auipc	a0,0x1
 194:	8f050513          	addi	a0,a0,-1808 # a80 <malloc+0xfa>
 198:	00000097          	auipc	ra,0x0
 19c:	730080e7          	jalr	1840(ra) # 8c8 <printf>
      exit(-1);
 1a0:	557d                	li	a0,-1
 1a2:	00000097          	auipc	ra,0x0
 1a6:	3a6080e7          	jalr	934(ra) # 548 <exit>
      close(fds[0]);
 1aa:	fb842503          	lw	a0,-72(s0)
 1ae:	00000097          	auipc	ra,0x0
 1b2:	3c2080e7          	jalr	962(ra) # 570 <close>
 1b6:	64e1                	lui	s1,0x18
 1b8:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x17307>
        *(int *)(a+4) = 1;
 1bc:	4905                	li	s2,1
        if (write(fds[1], "x", 1) != 1) {
 1be:	00001997          	auipc	s3,0x1
 1c2:	93298993          	addi	s3,s3,-1742 # af0 <malloc+0x16a>
        a = sbrk(PGSIZE);
 1c6:	6505                	lui	a0,0x1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	408080e7          	jalr	1032(ra) # 5d0 <sbrk>
        *(int *)(a+4) = 1;
 1d0:	01252223          	sw	s2,4(a0) # 1004 <__BSS_END__+0x44c>
        if (write(fds[1], "x", 1) != 1) {
 1d4:	864a                	mv	a2,s2
 1d6:	85ce                	mv	a1,s3
 1d8:	fbc42503          	lw	a0,-68(s0)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	38c080e7          	jalr	908(ra) # 568 <write>
 1e4:	01251963          	bne	a0,s2,1f6 <test1+0xe0>
      for(i = 0; i < N; i++) {
 1e8:	34fd                	addiw	s1,s1,-1
 1ea:	fcf1                	bnez	s1,1c6 <test1+0xb0>
      exit(0);
 1ec:	4501                	li	a0,0
 1ee:	00000097          	auipc	ra,0x0
 1f2:	35a080e7          	jalr	858(ra) # 548 <exit>
          printf("write failed");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	90250513          	addi	a0,a0,-1790 # af8 <malloc+0x172>
 1fe:	00000097          	auipc	ra,0x0
 202:	6ca080e7          	jalr	1738(ra) # 8c8 <printf>
          exit(-1);
 206:	557d                	li	a0,-1
 208:	00000097          	auipc	ra,0x0
 20c:	340080e7          	jalr	832(ra) # 548 <exit>
  int stop = 0;
  while (!stop) {
    stop = 1;
    for(int i = 0; i < NCHILD; i++){
      if (read(pipes[i], buf, 1) == 1) {
        tot += 1;
 210:	2485                	addiw	s1,s1,1
      if (read(pipes[i], buf, 1) == 1) {
 212:	4605                	li	a2,1
 214:	fc040593          	addi	a1,s0,-64
 218:	fcc42503          	lw	a0,-52(s0)
 21c:	00000097          	auipc	ra,0x0
 220:	344080e7          	jalr	836(ra) # 560 <read>
 224:	4785                	li	a5,1
 226:	02f50a63          	beq	a0,a5,25a <test1+0x144>
 22a:	4605                	li	a2,1
 22c:	fc040593          	addi	a1,s0,-64
 230:	fc842503          	lw	a0,-56(s0)
 234:	00000097          	auipc	ra,0x0
 238:	32c080e7          	jalr	812(ra) # 560 <read>
 23c:	4785                	li	a5,1
 23e:	fcf509e3          	beq	a0,a5,210 <test1+0xfa>
 242:	4605                	li	a2,1
 244:	fc040593          	addi	a1,s0,-64
 248:	fcc42503          	lw	a0,-52(s0)
 24c:	00000097          	auipc	ra,0x0
 250:	314080e7          	jalr	788(ra) # 560 <read>
 254:	4785                	li	a5,1
 256:	02f51163          	bne	a0,a5,278 <test1+0x162>
        tot += 1;
 25a:	2485                	addiw	s1,s1,1
  while (!stop) {
 25c:	b7f9                	j	22a <test1+0x114>
    }
  }
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
  if(n - tot > 1000) {
    printf("test1 FAILED: cannot allocate enough memory");
 25e:	00001517          	auipc	a0,0x1
 262:	8aa50513          	addi	a0,a0,-1878 # b08 <malloc+0x182>
 266:	00000097          	auipc	ra,0x0
 26a:	662080e7          	jalr	1634(ra) # 8c8 <printf>
    exit(-1);
 26e:	557d                	li	a0,-1
 270:	00000097          	auipc	ra,0x0
 274:	2d8080e7          	jalr	728(ra) # 548 <exit>
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
 278:	6621                	lui	a2,0x8
 27a:	85a6                	mv	a1,s1
 27c:	00001517          	auipc	a0,0x1
 280:	8cc50513          	addi	a0,a0,-1844 # b48 <malloc+0x1c2>
 284:	00000097          	auipc	ra,0x0
 288:	644080e7          	jalr	1604(ra) # 8c8 <printf>
  if(n - tot > 1000) {
 28c:	67a1                	lui	a5,0x8
 28e:	409784bb          	subw	s1,a5,s1
 292:	3e800793          	li	a5,1000
 296:	fc97c4e3          	blt	a5,s1,25e <test1+0x148>
  }
  printf("test1 OK\n");  
 29a:	00001517          	auipc	a0,0x1
 29e:	89e50513          	addi	a0,a0,-1890 # b38 <malloc+0x1b2>
 2a2:	00000097          	auipc	ra,0x0
 2a6:	626080e7          	jalr	1574(ra) # 8c8 <printf>
}
 2aa:	60a6                	ld	ra,72(sp)
 2ac:	6406                	ld	s0,64(sp)
 2ae:	74e2                	ld	s1,56(sp)
 2b0:	7942                	ld	s2,48(sp)
 2b2:	79a2                	ld	s3,40(sp)
 2b4:	6161                	addi	sp,sp,80
 2b6:	8082                	ret

00000000000002b8 <main>:
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  test0();
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <test0>
  test1();
 2c8:	00000097          	auipc	ra,0x0
 2cc:	e4e080e7          	jalr	-434(ra) # 116 <test1>
  exit(0);
 2d0:	4501                	li	a0,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	276080e7          	jalr	630(ra) # 548 <exit>

00000000000002da <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e0:	87aa                	mv	a5,a0
 2e2:	0585                	addi	a1,a1,1
 2e4:	0785                	addi	a5,a5,1
 2e6:	fff5c703          	lbu	a4,-1(a1)
 2ea:	fee78fa3          	sb	a4,-1(a5) # 7fff <__global_pointer$+0x6c66>
 2ee:	fb75                	bnez	a4,2e2 <strcpy+0x8>
    ;
  return os;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	cb91                	beqz	a5,314 <strcmp+0x1e>
 302:	0005c703          	lbu	a4,0(a1)
 306:	00f71763          	bne	a4,a5,314 <strcmp+0x1e>
    p++, q++;
 30a:	0505                	addi	a0,a0,1
 30c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 30e:	00054783          	lbu	a5,0(a0)
 312:	fbe5                	bnez	a5,302 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 314:	0005c503          	lbu	a0,0(a1)
}
 318:	40a7853b          	subw	a0,a5,a0
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <strlen>:

uint
strlen(const char *s)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 328:	00054783          	lbu	a5,0(a0)
 32c:	cf91                	beqz	a5,348 <strlen+0x26>
 32e:	0505                	addi	a0,a0,1
 330:	87aa                	mv	a5,a0
 332:	4685                	li	a3,1
 334:	9e89                	subw	a3,a3,a0
 336:	00f6853b          	addw	a0,a3,a5
 33a:	0785                	addi	a5,a5,1
 33c:	fff7c703          	lbu	a4,-1(a5)
 340:	fb7d                	bnez	a4,336 <strlen+0x14>
    ;
  return n;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  for(n = 0; s[n]; n++)
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <strlen+0x20>

000000000000034c <memset>:

void*
memset(void *dst, int c, uint n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 352:	ca19                	beqz	a2,368 <memset+0x1c>
 354:	87aa                	mv	a5,a0
 356:	1602                	slli	a2,a2,0x20
 358:	9201                	srli	a2,a2,0x20
 35a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 35e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 362:	0785                	addi	a5,a5,1
 364:	fee79de3          	bne	a5,a4,35e <memset+0x12>
  }
  return dst;
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret

000000000000036e <strchr>:

char*
strchr(const char *s, char c)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  for(; *s; s++)
 374:	00054783          	lbu	a5,0(a0)
 378:	cb99                	beqz	a5,38e <strchr+0x20>
    if(*s == c)
 37a:	00f58763          	beq	a1,a5,388 <strchr+0x1a>
  for(; *s; s++)
 37e:	0505                	addi	a0,a0,1
 380:	00054783          	lbu	a5,0(a0)
 384:	fbfd                	bnez	a5,37a <strchr+0xc>
      return (char*)s;
  return 0;
 386:	4501                	li	a0,0
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <strchr+0x1a>

0000000000000392 <gets>:

char*
gets(char *buf, int max)
{
 392:	711d                	addi	sp,sp,-96
 394:	ec86                	sd	ra,88(sp)
 396:	e8a2                	sd	s0,80(sp)
 398:	e4a6                	sd	s1,72(sp)
 39a:	e0ca                	sd	s2,64(sp)
 39c:	fc4e                	sd	s3,56(sp)
 39e:	f852                	sd	s4,48(sp)
 3a0:	f456                	sd	s5,40(sp)
 3a2:	f05a                	sd	s6,32(sp)
 3a4:	ec5e                	sd	s7,24(sp)
 3a6:	1080                	addi	s0,sp,96
 3a8:	8baa                	mv	s7,a0
 3aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ac:	892a                	mv	s2,a0
 3ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3b0:	4aa9                	li	s5,10
 3b2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b4:	89a6                	mv	s3,s1
 3b6:	2485                	addiw	s1,s1,1
 3b8:	0344d863          	bge	s1,s4,3e8 <gets+0x56>
    cc = read(0, &c, 1);
 3bc:	4605                	li	a2,1
 3be:	faf40593          	addi	a1,s0,-81
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	19c080e7          	jalr	412(ra) # 560 <read>
    if(cc < 1)
 3cc:	00a05e63          	blez	a0,3e8 <gets+0x56>
    buf[i++] = c;
 3d0:	faf44783          	lbu	a5,-81(s0)
 3d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d8:	01578763          	beq	a5,s5,3e6 <gets+0x54>
 3dc:	0905                	addi	s2,s2,1
 3de:	fd679be3          	bne	a5,s6,3b4 <gets+0x22>
  for(i=0; i+1 < max; ){
 3e2:	89a6                	mv	s3,s1
 3e4:	a011                	j	3e8 <gets+0x56>
 3e6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e8:	99de                	add	s3,s3,s7
 3ea:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ee:	855e                	mv	a0,s7
 3f0:	60e6                	ld	ra,88(sp)
 3f2:	6446                	ld	s0,80(sp)
 3f4:	64a6                	ld	s1,72(sp)
 3f6:	6906                	ld	s2,64(sp)
 3f8:	79e2                	ld	s3,56(sp)
 3fa:	7a42                	ld	s4,48(sp)
 3fc:	7aa2                	ld	s5,40(sp)
 3fe:	7b02                	ld	s6,32(sp)
 400:	6be2                	ld	s7,24(sp)
 402:	6125                	addi	sp,sp,96
 404:	8082                	ret

0000000000000406 <stat>:

int
stat(const char *n, struct stat *st)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	e426                	sd	s1,8(sp)
 40e:	e04a                	sd	s2,0(sp)
 410:	1000                	addi	s0,sp,32
 412:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 414:	4581                	li	a1,0
 416:	00000097          	auipc	ra,0x0
 41a:	172080e7          	jalr	370(ra) # 588 <open>
  if(fd < 0)
 41e:	02054563          	bltz	a0,448 <stat+0x42>
 422:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 424:	85ca                	mv	a1,s2
 426:	00000097          	auipc	ra,0x0
 42a:	17a080e7          	jalr	378(ra) # 5a0 <fstat>
 42e:	892a                	mv	s2,a0
  close(fd);
 430:	8526                	mv	a0,s1
 432:	00000097          	auipc	ra,0x0
 436:	13e080e7          	jalr	318(ra) # 570 <close>
  return r;
}
 43a:	854a                	mv	a0,s2
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	64a2                	ld	s1,8(sp)
 442:	6902                	ld	s2,0(sp)
 444:	6105                	addi	sp,sp,32
 446:	8082                	ret
    return -1;
 448:	597d                	li	s2,-1
 44a:	bfc5                	j	43a <stat+0x34>

000000000000044c <atoi>:

int
atoi(const char *s)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 452:	00054603          	lbu	a2,0(a0)
 456:	fd06079b          	addiw	a5,a2,-48
 45a:	0ff7f793          	andi	a5,a5,255
 45e:	4725                	li	a4,9
 460:	02f76963          	bltu	a4,a5,492 <atoi+0x46>
 464:	86aa                	mv	a3,a0
  n = 0;
 466:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 468:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 46a:	0685                	addi	a3,a3,1
 46c:	0025179b          	slliw	a5,a0,0x2
 470:	9fa9                	addw	a5,a5,a0
 472:	0017979b          	slliw	a5,a5,0x1
 476:	9fb1                	addw	a5,a5,a2
 478:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 47c:	0006c603          	lbu	a2,0(a3)
 480:	fd06071b          	addiw	a4,a2,-48
 484:	0ff77713          	andi	a4,a4,255
 488:	fee5f1e3          	bgeu	a1,a4,46a <atoi+0x1e>
  return n;
}
 48c:	6422                	ld	s0,8(sp)
 48e:	0141                	addi	sp,sp,16
 490:	8082                	ret
  n = 0;
 492:	4501                	li	a0,0
 494:	bfe5                	j	48c <atoi+0x40>

0000000000000496 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 496:	1141                	addi	sp,sp,-16
 498:	e422                	sd	s0,8(sp)
 49a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 49c:	02b57463          	bgeu	a0,a1,4c4 <memmove+0x2e>
    while(n-- > 0)
 4a0:	00c05f63          	blez	a2,4be <memmove+0x28>
 4a4:	1602                	slli	a2,a2,0x20
 4a6:	9201                	srli	a2,a2,0x20
 4a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 4ae:	0585                	addi	a1,a1,1
 4b0:	0705                	addi	a4,a4,1
 4b2:	fff5c683          	lbu	a3,-1(a1)
 4b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ba:	fee79ae3          	bne	a5,a4,4ae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4be:	6422                	ld	s0,8(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret
    dst += n;
 4c4:	00c50733          	add	a4,a0,a2
    src += n;
 4c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ca:	fec05ae3          	blez	a2,4be <memmove+0x28>
 4ce:	fff6079b          	addiw	a5,a2,-1
 4d2:	1782                	slli	a5,a5,0x20
 4d4:	9381                	srli	a5,a5,0x20
 4d6:	fff7c793          	not	a5,a5
 4da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4dc:	15fd                	addi	a1,a1,-1
 4de:	177d                	addi	a4,a4,-1
 4e0:	0005c683          	lbu	a3,0(a1)
 4e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e8:	fee79ae3          	bne	a5,a4,4dc <memmove+0x46>
 4ec:	bfc9                	j	4be <memmove+0x28>

00000000000004ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e422                	sd	s0,8(sp)
 4f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f4:	ca05                	beqz	a2,524 <memcmp+0x36>
 4f6:	fff6069b          	addiw	a3,a2,-1
 4fa:	1682                	slli	a3,a3,0x20
 4fc:	9281                	srli	a3,a3,0x20
 4fe:	0685                	addi	a3,a3,1
 500:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 502:	00054783          	lbu	a5,0(a0)
 506:	0005c703          	lbu	a4,0(a1)
 50a:	00e79863          	bne	a5,a4,51a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 50e:	0505                	addi	a0,a0,1
    p2++;
 510:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 512:	fed518e3          	bne	a0,a3,502 <memcmp+0x14>
  }
  return 0;
 516:	4501                	li	a0,0
 518:	a019                	j	51e <memcmp+0x30>
      return *p1 - *p2;
 51a:	40e7853b          	subw	a0,a5,a4
}
 51e:	6422                	ld	s0,8(sp)
 520:	0141                	addi	sp,sp,16
 522:	8082                	ret
  return 0;
 524:	4501                	li	a0,0
 526:	bfe5                	j	51e <memcmp+0x30>

0000000000000528 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 528:	1141                	addi	sp,sp,-16
 52a:	e406                	sd	ra,8(sp)
 52c:	e022                	sd	s0,0(sp)
 52e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 530:	00000097          	auipc	ra,0x0
 534:	f66080e7          	jalr	-154(ra) # 496 <memmove>
}
 538:	60a2                	ld	ra,8(sp)
 53a:	6402                	ld	s0,0(sp)
 53c:	0141                	addi	sp,sp,16
 53e:	8082                	ret

0000000000000540 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 540:	4885                	li	a7,1
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <exit>:
.global exit
exit:
 li a7, SYS_exit
 548:	4889                	li	a7,2
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <wait>:
.global wait
wait:
 li a7, SYS_wait
 550:	488d                	li	a7,3
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 558:	4891                	li	a7,4
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <read>:
.global read
read:
 li a7, SYS_read
 560:	4895                	li	a7,5
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <write>:
.global write
write:
 li a7, SYS_write
 568:	48c1                	li	a7,16
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <close>:
.global close
close:
 li a7, SYS_close
 570:	48d5                	li	a7,21
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <kill>:
.global kill
kill:
 li a7, SYS_kill
 578:	4899                	li	a7,6
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <exec>:
.global exec
exec:
 li a7, SYS_exec
 580:	489d                	li	a7,7
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <open>:
.global open
open:
 li a7, SYS_open
 588:	48bd                	li	a7,15
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 590:	48c5                	li	a7,17
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 598:	48c9                	li	a7,18
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a0:	48a1                	li	a7,8
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <link>:
.global link
link:
 li a7, SYS_link
 5a8:	48cd                	li	a7,19
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b0:	48d1                	li	a7,20
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b8:	48a5                	li	a7,9
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c0:	48a9                	li	a7,10
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c8:	48ad                	li	a7,11
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5d0:	48b1                	li	a7,12
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d8:	48b5                	li	a7,13
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e0:	48b9                	li	a7,14
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 5e8:	48d9                	li	a7,22
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5f0:	1101                	addi	sp,sp,-32
 5f2:	ec06                	sd	ra,24(sp)
 5f4:	e822                	sd	s0,16(sp)
 5f6:	1000                	addi	s0,sp,32
 5f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5fc:	4605                	li	a2,1
 5fe:	fef40593          	addi	a1,s0,-17
 602:	00000097          	auipc	ra,0x0
 606:	f66080e7          	jalr	-154(ra) # 568 <write>
}
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	6105                	addi	sp,sp,32
 610:	8082                	ret

0000000000000612 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 612:	7139                	addi	sp,sp,-64
 614:	fc06                	sd	ra,56(sp)
 616:	f822                	sd	s0,48(sp)
 618:	f426                	sd	s1,40(sp)
 61a:	f04a                	sd	s2,32(sp)
 61c:	ec4e                	sd	s3,24(sp)
 61e:	0080                	addi	s0,sp,64
 620:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 622:	c299                	beqz	a3,628 <printint+0x16>
 624:	0805c863          	bltz	a1,6b4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 628:	2581                	sext.w	a1,a1
  neg = 0;
 62a:	4881                	li	a7,0
 62c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 630:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 632:	2601                	sext.w	a2,a2
 634:	00000517          	auipc	a0,0x0
 638:	55450513          	addi	a0,a0,1364 # b88 <digits>
 63c:	883a                	mv	a6,a4
 63e:	2705                	addiw	a4,a4,1
 640:	02c5f7bb          	remuw	a5,a1,a2
 644:	1782                	slli	a5,a5,0x20
 646:	9381                	srli	a5,a5,0x20
 648:	97aa                	add	a5,a5,a0
 64a:	0007c783          	lbu	a5,0(a5)
 64e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 652:	0005879b          	sext.w	a5,a1
 656:	02c5d5bb          	divuw	a1,a1,a2
 65a:	0685                	addi	a3,a3,1
 65c:	fec7f0e3          	bgeu	a5,a2,63c <printint+0x2a>
  if(neg)
 660:	00088b63          	beqz	a7,676 <printint+0x64>
    buf[i++] = '-';
 664:	fd040793          	addi	a5,s0,-48
 668:	973e                	add	a4,a4,a5
 66a:	02d00793          	li	a5,45
 66e:	fef70823          	sb	a5,-16(a4)
 672:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 676:	02e05863          	blez	a4,6a6 <printint+0x94>
 67a:	fc040793          	addi	a5,s0,-64
 67e:	00e78933          	add	s2,a5,a4
 682:	fff78993          	addi	s3,a5,-1
 686:	99ba                	add	s3,s3,a4
 688:	377d                	addiw	a4,a4,-1
 68a:	1702                	slli	a4,a4,0x20
 68c:	9301                	srli	a4,a4,0x20
 68e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 692:	fff94583          	lbu	a1,-1(s2)
 696:	8526                	mv	a0,s1
 698:	00000097          	auipc	ra,0x0
 69c:	f58080e7          	jalr	-168(ra) # 5f0 <putc>
  while(--i >= 0)
 6a0:	197d                	addi	s2,s2,-1
 6a2:	ff3918e3          	bne	s2,s3,692 <printint+0x80>
}
 6a6:	70e2                	ld	ra,56(sp)
 6a8:	7442                	ld	s0,48(sp)
 6aa:	74a2                	ld	s1,40(sp)
 6ac:	7902                	ld	s2,32(sp)
 6ae:	69e2                	ld	s3,24(sp)
 6b0:	6121                	addi	sp,sp,64
 6b2:	8082                	ret
    x = -xx;
 6b4:	40b005bb          	negw	a1,a1
    neg = 1;
 6b8:	4885                	li	a7,1
    x = -xx;
 6ba:	bf8d                	j	62c <printint+0x1a>

00000000000006bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6bc:	7119                	addi	sp,sp,-128
 6be:	fc86                	sd	ra,120(sp)
 6c0:	f8a2                	sd	s0,112(sp)
 6c2:	f4a6                	sd	s1,104(sp)
 6c4:	f0ca                	sd	s2,96(sp)
 6c6:	ecce                	sd	s3,88(sp)
 6c8:	e8d2                	sd	s4,80(sp)
 6ca:	e4d6                	sd	s5,72(sp)
 6cc:	e0da                	sd	s6,64(sp)
 6ce:	fc5e                	sd	s7,56(sp)
 6d0:	f862                	sd	s8,48(sp)
 6d2:	f466                	sd	s9,40(sp)
 6d4:	f06a                	sd	s10,32(sp)
 6d6:	ec6e                	sd	s11,24(sp)
 6d8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6da:	0005c903          	lbu	s2,0(a1)
 6de:	18090f63          	beqz	s2,87c <vprintf+0x1c0>
 6e2:	8aaa                	mv	s5,a0
 6e4:	8b32                	mv	s6,a2
 6e6:	00158493          	addi	s1,a1,1
  state = 0;
 6ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ec:	02500a13          	li	s4,37
      if(c == 'd'){
 6f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6f4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6f8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6fc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 700:	00000b97          	auipc	s7,0x0
 704:	488b8b93          	addi	s7,s7,1160 # b88 <digits>
 708:	a839                	j	726 <vprintf+0x6a>
        putc(fd, c);
 70a:	85ca                	mv	a1,s2
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	ee2080e7          	jalr	-286(ra) # 5f0 <putc>
 716:	a019                	j	71c <vprintf+0x60>
    } else if(state == '%'){
 718:	01498f63          	beq	s3,s4,736 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 71c:	0485                	addi	s1,s1,1
 71e:	fff4c903          	lbu	s2,-1(s1)
 722:	14090d63          	beqz	s2,87c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 726:	0009079b          	sext.w	a5,s2
    if(state == 0){
 72a:	fe0997e3          	bnez	s3,718 <vprintf+0x5c>
      if(c == '%'){
 72e:	fd479ee3          	bne	a5,s4,70a <vprintf+0x4e>
        state = '%';
 732:	89be                	mv	s3,a5
 734:	b7e5                	j	71c <vprintf+0x60>
      if(c == 'd'){
 736:	05878063          	beq	a5,s8,776 <vprintf+0xba>
      } else if(c == 'l') {
 73a:	05978c63          	beq	a5,s9,792 <vprintf+0xd6>
      } else if(c == 'x') {
 73e:	07a78863          	beq	a5,s10,7ae <vprintf+0xf2>
      } else if(c == 'p') {
 742:	09b78463          	beq	a5,s11,7ca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 746:	07300713          	li	a4,115
 74a:	0ce78663          	beq	a5,a4,816 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74e:	06300713          	li	a4,99
 752:	0ee78e63          	beq	a5,a4,84e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 756:	11478863          	beq	a5,s4,866 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75a:	85d2                	mv	a1,s4
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e92080e7          	jalr	-366(ra) # 5f0 <putc>
        putc(fd, c);
 766:	85ca                	mv	a1,s2
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e86080e7          	jalr	-378(ra) # 5f0 <putc>
      }
      state = 0;
 772:	4981                	li	s3,0
 774:	b765                	j	71c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 776:	008b0913          	addi	s2,s6,8
 77a:	4685                	li	a3,1
 77c:	4629                	li	a2,10
 77e:	000b2583          	lw	a1,0(s6)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	e8e080e7          	jalr	-370(ra) # 612 <printint>
 78c:	8b4a                	mv	s6,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	b771                	j	71c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b0913          	addi	s2,s6,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000b2583          	lw	a1,0(s6)
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	e72080e7          	jalr	-398(ra) # 612 <printint>
 7a8:	8b4a                	mv	s6,s2
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	bf85                	j	71c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ae:	008b0913          	addi	s2,s6,8
 7b2:	4681                	li	a3,0
 7b4:	4641                	li	a2,16
 7b6:	000b2583          	lw	a1,0(s6)
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	e56080e7          	jalr	-426(ra) # 612 <printint>
 7c4:	8b4a                	mv	s6,s2
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	bf91                	j	71c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7ca:	008b0793          	addi	a5,s6,8
 7ce:	f8f43423          	sd	a5,-120(s0)
 7d2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7d6:	03000593          	li	a1,48
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e14080e7          	jalr	-492(ra) # 5f0 <putc>
  putc(fd, 'x');
 7e4:	85ea                	mv	a1,s10
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e08080e7          	jalr	-504(ra) # 5f0 <putc>
 7f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f2:	03c9d793          	srli	a5,s3,0x3c
 7f6:	97de                	add	a5,a5,s7
 7f8:	0007c583          	lbu	a1,0(a5)
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	df2080e7          	jalr	-526(ra) # 5f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 806:	0992                	slli	s3,s3,0x4
 808:	397d                	addiw	s2,s2,-1
 80a:	fe0914e3          	bnez	s2,7f2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 80e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 812:	4981                	li	s3,0
 814:	b721                	j	71c <vprintf+0x60>
        s = va_arg(ap, char*);
 816:	008b0993          	addi	s3,s6,8
 81a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 81e:	02090163          	beqz	s2,840 <vprintf+0x184>
        while(*s != 0){
 822:	00094583          	lbu	a1,0(s2)
 826:	c9a1                	beqz	a1,876 <vprintf+0x1ba>
          putc(fd, *s);
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	dc6080e7          	jalr	-570(ra) # 5f0 <putc>
          s++;
 832:	0905                	addi	s2,s2,1
        while(*s != 0){
 834:	00094583          	lbu	a1,0(s2)
 838:	f9e5                	bnez	a1,828 <vprintf+0x16c>
        s = va_arg(ap, char*);
 83a:	8b4e                	mv	s6,s3
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bdf9                	j	71c <vprintf+0x60>
          s = "(null)";
 840:	00000917          	auipc	s2,0x0
 844:	34090913          	addi	s2,s2,832 # b80 <malloc+0x1fa>
        while(*s != 0){
 848:	02800593          	li	a1,40
 84c:	bff1                	j	828 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 84e:	008b0913          	addi	s2,s6,8
 852:	000b4583          	lbu	a1,0(s6)
 856:	8556                	mv	a0,s5
 858:	00000097          	auipc	ra,0x0
 85c:	d98080e7          	jalr	-616(ra) # 5f0 <putc>
 860:	8b4a                	mv	s6,s2
      state = 0;
 862:	4981                	li	s3,0
 864:	bd65                	j	71c <vprintf+0x60>
        putc(fd, c);
 866:	85d2                	mv	a1,s4
 868:	8556                	mv	a0,s5
 86a:	00000097          	auipc	ra,0x0
 86e:	d86080e7          	jalr	-634(ra) # 5f0 <putc>
      state = 0;
 872:	4981                	li	s3,0
 874:	b565                	j	71c <vprintf+0x60>
        s = va_arg(ap, char*);
 876:	8b4e                	mv	s6,s3
      state = 0;
 878:	4981                	li	s3,0
 87a:	b54d                	j	71c <vprintf+0x60>
    }
  }
}
 87c:	70e6                	ld	ra,120(sp)
 87e:	7446                	ld	s0,112(sp)
 880:	74a6                	ld	s1,104(sp)
 882:	7906                	ld	s2,96(sp)
 884:	69e6                	ld	s3,88(sp)
 886:	6a46                	ld	s4,80(sp)
 888:	6aa6                	ld	s5,72(sp)
 88a:	6b06                	ld	s6,64(sp)
 88c:	7be2                	ld	s7,56(sp)
 88e:	7c42                	ld	s8,48(sp)
 890:	7ca2                	ld	s9,40(sp)
 892:	7d02                	ld	s10,32(sp)
 894:	6de2                	ld	s11,24(sp)
 896:	6109                	addi	sp,sp,128
 898:	8082                	ret

000000000000089a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89a:	715d                	addi	sp,sp,-80
 89c:	ec06                	sd	ra,24(sp)
 89e:	e822                	sd	s0,16(sp)
 8a0:	1000                	addi	s0,sp,32
 8a2:	e010                	sd	a2,0(s0)
 8a4:	e414                	sd	a3,8(s0)
 8a6:	e818                	sd	a4,16(s0)
 8a8:	ec1c                	sd	a5,24(s0)
 8aa:	03043023          	sd	a6,32(s0)
 8ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b6:	8622                	mv	a2,s0
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e04080e7          	jalr	-508(ra) # 6bc <vprintf>
}
 8c0:	60e2                	ld	ra,24(sp)
 8c2:	6442                	ld	s0,16(sp)
 8c4:	6161                	addi	sp,sp,80
 8c6:	8082                	ret

00000000000008c8 <printf>:

void
printf(const char *fmt, ...)
{
 8c8:	711d                	addi	sp,sp,-96
 8ca:	ec06                	sd	ra,24(sp)
 8cc:	e822                	sd	s0,16(sp)
 8ce:	1000                	addi	s0,sp,32
 8d0:	e40c                	sd	a1,8(s0)
 8d2:	e810                	sd	a2,16(s0)
 8d4:	ec14                	sd	a3,24(s0)
 8d6:	f018                	sd	a4,32(s0)
 8d8:	f41c                	sd	a5,40(s0)
 8da:	03043823          	sd	a6,48(s0)
 8de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e2:	00840613          	addi	a2,s0,8
 8e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ea:	85aa                	mv	a1,a0
 8ec:	4505                	li	a0,1
 8ee:	00000097          	auipc	ra,0x0
 8f2:	dce080e7          	jalr	-562(ra) # 6bc <vprintf>
}
 8f6:	60e2                	ld	ra,24(sp)
 8f8:	6442                	ld	s0,16(sp)
 8fa:	6125                	addi	sp,sp,96
 8fc:	8082                	ret

00000000000008fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fe:	1141                	addi	sp,sp,-16
 900:	e422                	sd	s0,8(sp)
 902:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 904:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 908:	00000797          	auipc	a5,0x0
 90c:	2987b783          	ld	a5,664(a5) # ba0 <freep>
 910:	a805                	j	940 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 912:	4618                	lw	a4,8(a2)
 914:	9db9                	addw	a1,a1,a4
 916:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 91a:	6398                	ld	a4,0(a5)
 91c:	6318                	ld	a4,0(a4)
 91e:	fee53823          	sd	a4,-16(a0)
 922:	a091                	j	966 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 924:	ff852703          	lw	a4,-8(a0)
 928:	9e39                	addw	a2,a2,a4
 92a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 92c:	ff053703          	ld	a4,-16(a0)
 930:	e398                	sd	a4,0(a5)
 932:	a099                	j	978 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	6398                	ld	a4,0(a5)
 936:	00e7e463          	bltu	a5,a4,93e <free+0x40>
 93a:	00e6ea63          	bltu	a3,a4,94e <free+0x50>
{
 93e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 940:	fed7fae3          	bgeu	a5,a3,934 <free+0x36>
 944:	6398                	ld	a4,0(a5)
 946:	00e6e463          	bltu	a3,a4,94e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	fee7eae3          	bltu	a5,a4,93e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 94e:	ff852583          	lw	a1,-8(a0)
 952:	6390                	ld	a2,0(a5)
 954:	02059813          	slli	a6,a1,0x20
 958:	01c85713          	srli	a4,a6,0x1c
 95c:	9736                	add	a4,a4,a3
 95e:	fae60ae3          	beq	a2,a4,912 <free+0x14>
    bp->s.ptr = p->s.ptr;
 962:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 966:	4790                	lw	a2,8(a5)
 968:	02061593          	slli	a1,a2,0x20
 96c:	01c5d713          	srli	a4,a1,0x1c
 970:	973e                	add	a4,a4,a5
 972:	fae689e3          	beq	a3,a4,924 <free+0x26>
  } else
    p->s.ptr = bp;
 976:	e394                	sd	a3,0(a5)
  freep = p;
 978:	00000717          	auipc	a4,0x0
 97c:	22f73423          	sd	a5,552(a4) # ba0 <freep>
}
 980:	6422                	ld	s0,8(sp)
 982:	0141                	addi	sp,sp,16
 984:	8082                	ret

0000000000000986 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 986:	7139                	addi	sp,sp,-64
 988:	fc06                	sd	ra,56(sp)
 98a:	f822                	sd	s0,48(sp)
 98c:	f426                	sd	s1,40(sp)
 98e:	f04a                	sd	s2,32(sp)
 990:	ec4e                	sd	s3,24(sp)
 992:	e852                	sd	s4,16(sp)
 994:	e456                	sd	s5,8(sp)
 996:	e05a                	sd	s6,0(sp)
 998:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99a:	02051493          	slli	s1,a0,0x20
 99e:	9081                	srli	s1,s1,0x20
 9a0:	04bd                	addi	s1,s1,15
 9a2:	8091                	srli	s1,s1,0x4
 9a4:	0014899b          	addiw	s3,s1,1
 9a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9aa:	00000517          	auipc	a0,0x0
 9ae:	1f653503          	ld	a0,502(a0) # ba0 <freep>
 9b2:	c515                	beqz	a0,9de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b6:	4798                	lw	a4,8(a5)
 9b8:	02977f63          	bgeu	a4,s1,9f6 <malloc+0x70>
 9bc:	8a4e                	mv	s4,s3
 9be:	0009871b          	sext.w	a4,s3
 9c2:	6685                	lui	a3,0x1
 9c4:	00d77363          	bgeu	a4,a3,9ca <malloc+0x44>
 9c8:	6a05                	lui	s4,0x1
 9ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d2:	00000917          	auipc	s2,0x0
 9d6:	1ce90913          	addi	s2,s2,462 # ba0 <freep>
  if(p == (char*)-1)
 9da:	5afd                	li	s5,-1
 9dc:	a895                	j	a50 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9de:	00000797          	auipc	a5,0x0
 9e2:	1ca78793          	addi	a5,a5,458 # ba8 <base>
 9e6:	00000717          	auipc	a4,0x0
 9ea:	1af73d23          	sd	a5,442(a4) # ba0 <freep>
 9ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f4:	b7e1                	j	9bc <malloc+0x36>
      if(p->s.size == nunits)
 9f6:	02e48c63          	beq	s1,a4,a2e <malloc+0xa8>
        p->s.size -= nunits;
 9fa:	4137073b          	subw	a4,a4,s3
 9fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a00:	02071693          	slli	a3,a4,0x20
 a04:	01c6d713          	srli	a4,a3,0x1c
 a08:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a0a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a0e:	00000717          	auipc	a4,0x0
 a12:	18a73923          	sd	a0,402(a4) # ba0 <freep>
      return (void*)(p + 1);
 a16:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a1a:	70e2                	ld	ra,56(sp)
 a1c:	7442                	ld	s0,48(sp)
 a1e:	74a2                	ld	s1,40(sp)
 a20:	7902                	ld	s2,32(sp)
 a22:	69e2                	ld	s3,24(sp)
 a24:	6a42                	ld	s4,16(sp)
 a26:	6aa2                	ld	s5,8(sp)
 a28:	6b02                	ld	s6,0(sp)
 a2a:	6121                	addi	sp,sp,64
 a2c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a2e:	6398                	ld	a4,0(a5)
 a30:	e118                	sd	a4,0(a0)
 a32:	bff1                	j	a0e <malloc+0x88>
  hp->s.size = nu;
 a34:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a38:	0541                	addi	a0,a0,16
 a3a:	00000097          	auipc	ra,0x0
 a3e:	ec4080e7          	jalr	-316(ra) # 8fe <free>
  return freep;
 a42:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a46:	d971                	beqz	a0,a1a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a48:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4a:	4798                	lw	a4,8(a5)
 a4c:	fa9775e3          	bgeu	a4,s1,9f6 <malloc+0x70>
    if(p == freep)
 a50:	00093703          	ld	a4,0(s2)
 a54:	853e                	mv	a0,a5
 a56:	fef719e3          	bne	a4,a5,a48 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a5a:	8552                	mv	a0,s4
 a5c:	00000097          	auipc	ra,0x0
 a60:	b74080e7          	jalr	-1164(ra) # 5d0 <sbrk>
  if(p == (char*)-1)
 a64:	fd5518e3          	bne	a0,s5,a34 <malloc+0xae>
        return 0;
 a68:	4501                	li	a0,0
 a6a:	bf45                	j	a1a <malloc+0x94>
