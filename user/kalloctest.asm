
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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test0\n");  
  10:	00001517          	auipc	a0,0x1
  14:	9e850513          	addi	a0,a0,-1560 # 9f8 <malloc+0xec>
  18:	00001097          	auipc	ra,0x1
  1c:	836080e7          	jalr	-1994(ra) # 84e <printf>
  int n = ntas();
  20:	00000097          	auipc	ra,0x0
  24:	536080e7          	jalr	1334(ra) # 556 <ntas>
  28:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  2a:	00000097          	auipc	ra,0x0
  2e:	484080e7          	jalr	1156(ra) # 4ae <fork>
    if(pid < 0){
  32:	04054a63          	bltz	a0,86 <test0+0x86>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  36:	c52d                	beqz	a0,a0 <test0+0xa0>
    int pid = fork();
  38:	00000097          	auipc	ra,0x0
  3c:	476080e7          	jalr	1142(ra) # 4ae <fork>
    if(pid < 0){
  40:	04054363          	bltz	a0,86 <test0+0x86>
    if(pid == 0){
  44:	cd31                	beqz	a0,a0 <test0+0xa0>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	476080e7          	jalr	1142(ra) # 4be <wait>
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	46c080e7          	jalr	1132(ra) # 4be <wait>
  }
  int t = ntas();
  5a:	00000097          	auipc	ra,0x0
  5e:	4fc080e7          	jalr	1276(ra) # 556 <ntas>
  printf("test0 done: #test-and-sets = %d\n", t - n);
  62:	409505bb          	subw	a1,a0,s1
  66:	00001517          	auipc	a0,0x1
  6a:	9c250513          	addi	a0,a0,-1598 # a28 <malloc+0x11c>
  6e:	00000097          	auipc	ra,0x0
  72:	7e0080e7          	jalr	2016(ra) # 84e <printf>
}
  76:	70a2                	ld	ra,40(sp)
  78:	7402                	ld	s0,32(sp)
  7a:	64e2                	ld	s1,24(sp)
  7c:	6942                	ld	s2,16(sp)
  7e:	69a2                	ld	s3,8(sp)
  80:	6a02                	ld	s4,0(sp)
  82:	6145                	addi	sp,sp,48
  84:	8082                	ret
      printf("fork failed");
  86:	00001517          	auipc	a0,0x1
  8a:	98250513          	addi	a0,a0,-1662 # a08 <malloc+0xfc>
  8e:	00000097          	auipc	ra,0x0
  92:	7c0080e7          	jalr	1984(ra) # 84e <printf>
      exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	41e080e7          	jalr	1054(ra) # 4b6 <exit>
{
  a0:	6961                	lui	s2,0x18
  a2:	6a090913          	addi	s2,s2,1696 # 186a0 <__global_pointer$+0x17387>
        if(a == (char*)0xffffffffffffffffL){
  a6:	59fd                	li	s3,-1
        *(int *)(a+4) = 1;
  a8:	4a05                	li	s4,1
        a = sbrk(4096);
  aa:	6505                	lui	a0,0x1
  ac:	00000097          	auipc	ra,0x0
  b0:	492080e7          	jalr	1170(ra) # 53e <sbrk>
  b4:	84aa                	mv	s1,a0
        if(a == (char*)0xffffffffffffffffL){
  b6:	03350063          	beq	a0,s3,d6 <test0+0xd6>
        *(int *)(a+4) = 1;
  ba:	01452223          	sw	s4,4(a0) # 1004 <__BSS_END__+0x4cc>
        a1 = sbrk(-4096);
  be:	757d                	lui	a0,0xfffff
  c0:	00000097          	auipc	ra,0x0
  c4:	47e080e7          	jalr	1150(ra) # 53e <sbrk>
        if (a1 != a + 4096) {
  c8:	6785                	lui	a5,0x1
  ca:	94be                	add	s1,s1,a5
  cc:	00951a63          	bne	a0,s1,e0 <test0+0xe0>
      for(i = 0; i < N; i++) {
  d0:	397d                	addiw	s2,s2,-1
  d2:	fc091ce3          	bnez	s2,aa <test0+0xaa>
      exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	3de080e7          	jalr	990(ra) # 4b6 <exit>
          printf("wrong sbrk\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	93850513          	addi	a0,a0,-1736 # a18 <malloc+0x10c>
  e8:	00000097          	auipc	ra,0x0
  ec:	766080e7          	jalr	1894(ra) # 84e <printf>
          exit(-1);
  f0:	557d                	li	a0,-1
  f2:	00000097          	auipc	ra,0x0
  f6:	3c4080e7          	jalr	964(ra) # 4b6 <exit>

00000000000000fa <test1>:

// Run system out of memory and count tot memory allocated
void test1()
{
  fa:	715d                	addi	sp,sp,-80
  fc:	e486                	sd	ra,72(sp)
  fe:	e0a2                	sd	s0,64(sp)
 100:	fc26                	sd	s1,56(sp)
 102:	f84a                	sd	s2,48(sp)
 104:	f44e                	sd	s3,40(sp)
 106:	f052                	sd	s4,32(sp)
 108:	0880                	addi	s0,sp,80
  void *a;
  int pipes[NCHILD];
  int tot = 0;
  char buf[1];
  
  printf("start test1\n");  
 10a:	00001517          	auipc	a0,0x1
 10e:	94650513          	addi	a0,a0,-1722 # a50 <malloc+0x144>
 112:	00000097          	auipc	ra,0x0
 116:	73c080e7          	jalr	1852(ra) # 84e <printf>
  for(int i = 0; i < NCHILD; i++){
 11a:	fc840913          	addi	s2,s0,-56
    int fds[2];
    if(pipe(fds) != 0){
 11e:	fb840513          	addi	a0,s0,-72
 122:	00000097          	auipc	ra,0x0
 126:	3a4080e7          	jalr	932(ra) # 4c6 <pipe>
 12a:	84aa                	mv	s1,a0
 12c:	e905                	bnez	a0,15c <test1+0x62>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 12e:	00000097          	auipc	ra,0x0
 132:	380080e7          	jalr	896(ra) # 4ae <fork>
    if(pid < 0){
 136:	04054063          	bltz	a0,176 <test1+0x7c>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 13a:	c939                	beqz	a0,190 <test1+0x96>
          exit(-1);
        }
      }
      exit(-1);
    } else {
      close(fds[1]);
 13c:	fbc42503          	lw	a0,-68(s0)
 140:	00000097          	auipc	ra,0x0
 144:	39e080e7          	jalr	926(ra) # 4de <close>
      pipes[i] = fds[0];
 148:	fb842783          	lw	a5,-72(s0)
 14c:	00f92023          	sw	a5,0(s2)
  for(int i = 0; i < NCHILD; i++){
 150:	0911                	addi	s2,s2,4
 152:	fd040793          	addi	a5,s0,-48
 156:	fd2794e3          	bne	a5,s2,11e <test1+0x24>
 15a:	a875                	j	216 <test1+0x11c>
      printf("pipe() failed\n");
 15c:	00001517          	auipc	a0,0x1
 160:	90450513          	addi	a0,a0,-1788 # a60 <malloc+0x154>
 164:	00000097          	auipc	ra,0x0
 168:	6ea080e7          	jalr	1770(ra) # 84e <printf>
      exit(-1);
 16c:	557d                	li	a0,-1
 16e:	00000097          	auipc	ra,0x0
 172:	348080e7          	jalr	840(ra) # 4b6 <exit>
      printf("fork failed");
 176:	00001517          	auipc	a0,0x1
 17a:	89250513          	addi	a0,a0,-1902 # a08 <malloc+0xfc>
 17e:	00000097          	auipc	ra,0x0
 182:	6d0080e7          	jalr	1744(ra) # 84e <printf>
      exit(-1);
 186:	557d                	li	a0,-1
 188:	00000097          	auipc	ra,0x0
 18c:	32e080e7          	jalr	814(ra) # 4b6 <exit>
      close(fds[0]);
 190:	fb842503          	lw	a0,-72(s0)
 194:	00000097          	auipc	ra,0x0
 198:	34a080e7          	jalr	842(ra) # 4de <close>
 19c:	64e1                	lui	s1,0x18
 19e:	6a048493          	addi	s1,s1,1696 # 186a0 <__global_pointer$+0x17387>
        if(a == (char*)0xffffffffffffffffL){
 1a2:	5a7d                	li	s4,-1
        *(int *)(a+4) = 1;
 1a4:	4905                	li	s2,1
        if (write(fds[1], "x", 1) != 1) {
 1a6:	00001997          	auipc	s3,0x1
 1aa:	8ca98993          	addi	s3,s3,-1846 # a70 <malloc+0x164>
        a = sbrk(PGSIZE);
 1ae:	6505                	lui	a0,0x1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	38e080e7          	jalr	910(ra) # 53e <sbrk>
        if(a == (char*)0xffffffffffffffffL){
 1b8:	03450063          	beq	a0,s4,1d8 <test1+0xde>
        *(int *)(a+4) = 1;
 1bc:	01252223          	sw	s2,4(a0) # 1004 <__BSS_END__+0x4cc>
        if (write(fds[1], "x", 1) != 1) {
 1c0:	864a                	mv	a2,s2
 1c2:	85ce                	mv	a1,s3
 1c4:	fbc42503          	lw	a0,-68(s0)
 1c8:	00000097          	auipc	ra,0x0
 1cc:	30e080e7          	jalr	782(ra) # 4d6 <write>
 1d0:	01251963          	bne	a0,s2,1e2 <test1+0xe8>
      for(i = 0; i < N; i++) {
 1d4:	34fd                	addiw	s1,s1,-1
 1d6:	fce1                	bnez	s1,1ae <test1+0xb4>
      exit(-1);
 1d8:	557d                	li	a0,-1
 1da:	00000097          	auipc	ra,0x0
 1de:	2dc080e7          	jalr	732(ra) # 4b6 <exit>
          printf("write failed");
 1e2:	00001517          	auipc	a0,0x1
 1e6:	89650513          	addi	a0,a0,-1898 # a78 <malloc+0x16c>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	664080e7          	jalr	1636(ra) # 84e <printf>
          exit(-1);
 1f2:	557d                	li	a0,-1
 1f4:	00000097          	auipc	ra,0x0
 1f8:	2c2080e7          	jalr	706(ra) # 4b6 <exit>
  int stop = 0;
  while (!stop) {
    stop = 1;
    for(int i = 0; i < NCHILD; i++){
      if (read(pipes[i], buf, 1) == 1) {
        tot += 1;
 1fc:	2485                	addiw	s1,s1,1
      if (read(pipes[i], buf, 1) == 1) {
 1fe:	4605                	li	a2,1
 200:	fc040593          	addi	a1,s0,-64
 204:	fcc42503          	lw	a0,-52(s0)
 208:	00000097          	auipc	ra,0x0
 20c:	2c6080e7          	jalr	710(ra) # 4ce <read>
 210:	4785                	li	a5,1
 212:	02f50a63          	beq	a0,a5,246 <test1+0x14c>
 216:	4605                	li	a2,1
 218:	fc040593          	addi	a1,s0,-64
 21c:	fc842503          	lw	a0,-56(s0)
 220:	00000097          	auipc	ra,0x0
 224:	2ae080e7          	jalr	686(ra) # 4ce <read>
 228:	4785                	li	a5,1
 22a:	fcf509e3          	beq	a0,a5,1fc <test1+0x102>
 22e:	4605                	li	a2,1
 230:	fc040593          	addi	a1,s0,-64
 234:	fcc42503          	lw	a0,-52(s0)
 238:	00000097          	auipc	ra,0x0
 23c:	296080e7          	jalr	662(ra) # 4ce <read>
 240:	4785                	li	a5,1
 242:	02f51163          	bne	a0,a5,264 <test1+0x16a>
        tot += 1;
 246:	2485                	addiw	s1,s1,1
  while (!stop) {
 248:	b7f9                	j	216 <test1+0x11c>
    }
  }
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
  if(n - tot > 1000) {
    printf("test1 failed: cannot allocate enough memory\n");
 24a:	00001517          	auipc	a0,0x1
 24e:	83e50513          	addi	a0,a0,-1986 # a88 <malloc+0x17c>
 252:	00000097          	auipc	ra,0x0
 256:	5fc080e7          	jalr	1532(ra) # 84e <printf>
    exit(-1);
 25a:	557d                	li	a0,-1
 25c:	00000097          	auipc	ra,0x0
 260:	25a080e7          	jalr	602(ra) # 4b6 <exit>
  printf("total allocated number of pages: %d (out of %d)\n", tot, n);
 264:	6621                	lui	a2,0x8
 266:	85a6                	mv	a1,s1
 268:	00001517          	auipc	a0,0x1
 26c:	86050513          	addi	a0,a0,-1952 # ac8 <malloc+0x1bc>
 270:	00000097          	auipc	ra,0x0
 274:	5de080e7          	jalr	1502(ra) # 84e <printf>
  if(n - tot > 1000) {
 278:	67a1                	lui	a5,0x8
 27a:	409784bb          	subw	s1,a5,s1
 27e:	3e800793          	li	a5,1000
 282:	fc97c4e3          	blt	a5,s1,24a <test1+0x150>
  }
  printf("test1 done\n");
 286:	00001517          	auipc	a0,0x1
 28a:	83250513          	addi	a0,a0,-1998 # ab8 <malloc+0x1ac>
 28e:	00000097          	auipc	ra,0x0
 292:	5c0080e7          	jalr	1472(ra) # 84e <printf>
}
 296:	60a6                	ld	ra,72(sp)
 298:	6406                	ld	s0,64(sp)
 29a:	74e2                	ld	s1,56(sp)
 29c:	7942                	ld	s2,48(sp)
 29e:	79a2                	ld	s3,40(sp)
 2a0:	7a02                	ld	s4,32(sp)
 2a2:	6161                	addi	sp,sp,80
 2a4:	8082                	ret

00000000000002a6 <main>:
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  test0();
 2ae:	00000097          	auipc	ra,0x0
 2b2:	d52080e7          	jalr	-686(ra) # 0 <test0>
  test1();
 2b6:	00000097          	auipc	ra,0x0
 2ba:	e44080e7          	jalr	-444(ra) # fa <test1>
  exit(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	1f6080e7          	jalr	502(ra) # 4b6 <exit>

00000000000002c8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ce:	87aa                	mv	a5,a0
 2d0:	0585                	addi	a1,a1,1
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff5c703          	lbu	a4,-1(a1)
 2d8:	fee78fa3          	sb	a4,-1(a5) # 7fff <__global_pointer$+0x6ce6>
 2dc:	fb75                	bnez	a4,2d0 <strcpy+0x8>
    ;
  return os;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	cb91                	beqz	a5,302 <strcmp+0x1e>
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00f71763          	bne	a4,a5,302 <strcmp+0x1e>
    p++, q++;
 2f8:	0505                	addi	a0,a0,1
 2fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbe5                	bnez	a5,2f0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 302:	0005c503          	lbu	a0,0(a1)
}
 306:	40a7853b          	subw	a0,a5,a0
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strlen>:

uint
strlen(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf91                	beqz	a5,336 <strlen+0x26>
 31c:	0505                	addi	a0,a0,1
 31e:	87aa                	mv	a5,a0
 320:	4685                	li	a3,1
 322:	9e89                	subw	a3,a3,a0
 324:	00f6853b          	addw	a0,a3,a5
 328:	0785                	addi	a5,a5,1
 32a:	fff7c703          	lbu	a4,-1(a5)
 32e:	fb7d                	bnez	a4,324 <strlen+0x14>
    ;
  return n;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
  for(n = 0; s[n]; n++)
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <strlen+0x20>

000000000000033a <memset>:

void*
memset(void *dst, int c, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 340:	ca19                	beqz	a2,356 <memset+0x1c>
 342:	87aa                	mv	a5,a0
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 34c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 350:	0785                	addi	a5,a5,1
 352:	fee79de3          	bne	a5,a4,34c <memset+0x12>
  }
  return dst;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <strchr>:

char*
strchr(const char *s, char c)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  for(; *s; s++)
 362:	00054783          	lbu	a5,0(a0)
 366:	cb99                	beqz	a5,37c <strchr+0x20>
    if(*s == c)
 368:	00f58763          	beq	a1,a5,376 <strchr+0x1a>
  for(; *s; s++)
 36c:	0505                	addi	a0,a0,1
 36e:	00054783          	lbu	a5,0(a0)
 372:	fbfd                	bnez	a5,368 <strchr+0xc>
      return (char*)s;
  return 0;
 374:	4501                	li	a0,0
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  return 0;
 37c:	4501                	li	a0,0
 37e:	bfe5                	j	376 <strchr+0x1a>

0000000000000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	711d                	addi	sp,sp,-96
 382:	ec86                	sd	ra,88(sp)
 384:	e8a2                	sd	s0,80(sp)
 386:	e4a6                	sd	s1,72(sp)
 388:	e0ca                	sd	s2,64(sp)
 38a:	fc4e                	sd	s3,56(sp)
 38c:	f852                	sd	s4,48(sp)
 38e:	f456                	sd	s5,40(sp)
 390:	f05a                	sd	s6,32(sp)
 392:	ec5e                	sd	s7,24(sp)
 394:	1080                	addi	s0,sp,96
 396:	8baa                	mv	s7,a0
 398:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39a:	892a                	mv	s2,a0
 39c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39e:	4aa9                	li	s5,10
 3a0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3a2:	89a6                	mv	s3,s1
 3a4:	2485                	addiw	s1,s1,1
 3a6:	0344d863          	bge	s1,s4,3d6 <gets+0x56>
    cc = read(0, &c, 1);
 3aa:	4605                	li	a2,1
 3ac:	faf40593          	addi	a1,s0,-81
 3b0:	4501                	li	a0,0
 3b2:	00000097          	auipc	ra,0x0
 3b6:	11c080e7          	jalr	284(ra) # 4ce <read>
    if(cc < 1)
 3ba:	00a05e63          	blez	a0,3d6 <gets+0x56>
    buf[i++] = c;
 3be:	faf44783          	lbu	a5,-81(s0)
 3c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c6:	01578763          	beq	a5,s5,3d4 <gets+0x54>
 3ca:	0905                	addi	s2,s2,1
 3cc:	fd679be3          	bne	a5,s6,3a2 <gets+0x22>
  for(i=0; i+1 < max; ){
 3d0:	89a6                	mv	s3,s1
 3d2:	a011                	j	3d6 <gets+0x56>
 3d4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d6:	99de                	add	s3,s3,s7
 3d8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3dc:	855e                	mv	a0,s7
 3de:	60e6                	ld	ra,88(sp)
 3e0:	6446                	ld	s0,80(sp)
 3e2:	64a6                	ld	s1,72(sp)
 3e4:	6906                	ld	s2,64(sp)
 3e6:	79e2                	ld	s3,56(sp)
 3e8:	7a42                	ld	s4,48(sp)
 3ea:	7aa2                	ld	s5,40(sp)
 3ec:	7b02                	ld	s6,32(sp)
 3ee:	6be2                	ld	s7,24(sp)
 3f0:	6125                	addi	sp,sp,96
 3f2:	8082                	ret

00000000000003f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f4:	1101                	addi	sp,sp,-32
 3f6:	ec06                	sd	ra,24(sp)
 3f8:	e822                	sd	s0,16(sp)
 3fa:	e426                	sd	s1,8(sp)
 3fc:	e04a                	sd	s2,0(sp)
 3fe:	1000                	addi	s0,sp,32
 400:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 402:	4581                	li	a1,0
 404:	00000097          	auipc	ra,0x0
 408:	0f2080e7          	jalr	242(ra) # 4f6 <open>
  if(fd < 0)
 40c:	02054563          	bltz	a0,436 <stat+0x42>
 410:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 412:	85ca                	mv	a1,s2
 414:	00000097          	auipc	ra,0x0
 418:	0fa080e7          	jalr	250(ra) # 50e <fstat>
 41c:	892a                	mv	s2,a0
  close(fd);
 41e:	8526                	mv	a0,s1
 420:	00000097          	auipc	ra,0x0
 424:	0be080e7          	jalr	190(ra) # 4de <close>
  return r;
}
 428:	854a                	mv	a0,s2
 42a:	60e2                	ld	ra,24(sp)
 42c:	6442                	ld	s0,16(sp)
 42e:	64a2                	ld	s1,8(sp)
 430:	6902                	ld	s2,0(sp)
 432:	6105                	addi	sp,sp,32
 434:	8082                	ret
    return -1;
 436:	597d                	li	s2,-1
 438:	bfc5                	j	428 <stat+0x34>

000000000000043a <atoi>:

int
atoi(const char *s)
{
 43a:	1141                	addi	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 440:	00054603          	lbu	a2,0(a0)
 444:	fd06079b          	addiw	a5,a2,-48
 448:	0ff7f793          	andi	a5,a5,255
 44c:	4725                	li	a4,9
 44e:	02f76963          	bltu	a4,a5,480 <atoi+0x46>
 452:	86aa                	mv	a3,a0
  n = 0;
 454:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 456:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 458:	0685                	addi	a3,a3,1
 45a:	0025179b          	slliw	a5,a0,0x2
 45e:	9fa9                	addw	a5,a5,a0
 460:	0017979b          	slliw	a5,a5,0x1
 464:	9fb1                	addw	a5,a5,a2
 466:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 46a:	0006c603          	lbu	a2,0(a3)
 46e:	fd06071b          	addiw	a4,a2,-48
 472:	0ff77713          	andi	a4,a4,255
 476:	fee5f1e3          	bgeu	a1,a4,458 <atoi+0x1e>
  return n;
}
 47a:	6422                	ld	s0,8(sp)
 47c:	0141                	addi	sp,sp,16
 47e:	8082                	ret
  n = 0;
 480:	4501                	li	a0,0
 482:	bfe5                	j	47a <atoi+0x40>

0000000000000484 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48a:	00c05f63          	blez	a2,4a8 <memmove+0x24>
 48e:	1602                	slli	a2,a2,0x20
 490:	9201                	srli	a2,a2,0x20
 492:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 496:	87aa                	mv	a5,a0
    *dst++ = *src++;
 498:	0585                	addi	a1,a1,1
 49a:	0785                	addi	a5,a5,1
 49c:	fff5c703          	lbu	a4,-1(a1)
 4a0:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 4a4:	fed79ae3          	bne	a5,a3,498 <memmove+0x14>
  return vdst;
}
 4a8:	6422                	ld	s0,8(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret

00000000000004ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ae:	4885                	li	a7,1
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b6:	4889                	li	a7,2
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <wait>:
.global wait
wait:
 li a7, SYS_wait
 4be:	488d                	li	a7,3
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c6:	4891                	li	a7,4
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <read>:
.global read
read:
 li a7, SYS_read
 4ce:	4895                	li	a7,5
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <write>:
.global write
write:
 li a7, SYS_write
 4d6:	48c1                	li	a7,16
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <close>:
.global close
close:
 li a7, SYS_close
 4de:	48d5                	li	a7,21
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e6:	4899                	li	a7,6
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ee:	489d                	li	a7,7
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <open>:
.global open
open:
 li a7, SYS_open
 4f6:	48bd                	li	a7,15
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fe:	48c5                	li	a7,17
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 506:	48c9                	li	a7,18
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50e:	48a1                	li	a7,8
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <link>:
.global link
link:
 li a7, SYS_link
 516:	48cd                	li	a7,19
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51e:	48d1                	li	a7,20
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 526:	48a5                	li	a7,9
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <dup>:
.global dup
dup:
 li a7, SYS_dup
 52e:	48a9                	li	a7,10
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 536:	48ad                	li	a7,11
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53e:	48b1                	li	a7,12
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 546:	48b5                	li	a7,13
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54e:	48b9                	li	a7,14
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 556:	48d9                	li	a7,22
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <crash>:
.global crash
crash:
 li a7, SYS_crash
 55e:	48dd                	li	a7,23
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mount>:
.global mount
mount:
 li a7, SYS_mount
 566:	48e1                	li	a7,24
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <umount>:
.global umount
umount:
 li a7, SYS_umount
 56e:	48e5                	li	a7,25
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 576:	1101                	addi	sp,sp,-32
 578:	ec06                	sd	ra,24(sp)
 57a:	e822                	sd	s0,16(sp)
 57c:	1000                	addi	s0,sp,32
 57e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 582:	4605                	li	a2,1
 584:	fef40593          	addi	a1,s0,-17
 588:	00000097          	auipc	ra,0x0
 58c:	f4e080e7          	jalr	-178(ra) # 4d6 <write>
}
 590:	60e2                	ld	ra,24(sp)
 592:	6442                	ld	s0,16(sp)
 594:	6105                	addi	sp,sp,32
 596:	8082                	ret

0000000000000598 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 598:	7139                	addi	sp,sp,-64
 59a:	fc06                	sd	ra,56(sp)
 59c:	f822                	sd	s0,48(sp)
 59e:	f426                	sd	s1,40(sp)
 5a0:	f04a                	sd	s2,32(sp)
 5a2:	ec4e                	sd	s3,24(sp)
 5a4:	0080                	addi	s0,sp,64
 5a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a8:	c299                	beqz	a3,5ae <printint+0x16>
 5aa:	0805c863          	bltz	a1,63a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ae:	2581                	sext.w	a1,a1
  neg = 0;
 5b0:	4881                	li	a7,0
 5b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b8:	2601                	sext.w	a2,a2
 5ba:	00000517          	auipc	a0,0x0
 5be:	54e50513          	addi	a0,a0,1358 # b08 <digits>
 5c2:	883a                	mv	a6,a4
 5c4:	2705                	addiw	a4,a4,1
 5c6:	02c5f7bb          	remuw	a5,a1,a2
 5ca:	1782                	slli	a5,a5,0x20
 5cc:	9381                	srli	a5,a5,0x20
 5ce:	97aa                	add	a5,a5,a0
 5d0:	0007c783          	lbu	a5,0(a5)
 5d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d8:	0005879b          	sext.w	a5,a1
 5dc:	02c5d5bb          	divuw	a1,a1,a2
 5e0:	0685                	addi	a3,a3,1
 5e2:	fec7f0e3          	bgeu	a5,a2,5c2 <printint+0x2a>
  if(neg)
 5e6:	00088b63          	beqz	a7,5fc <printint+0x64>
    buf[i++] = '-';
 5ea:	fd040793          	addi	a5,s0,-48
 5ee:	973e                	add	a4,a4,a5
 5f0:	02d00793          	li	a5,45
 5f4:	fef70823          	sb	a5,-16(a4)
 5f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5fc:	02e05863          	blez	a4,62c <printint+0x94>
 600:	fc040793          	addi	a5,s0,-64
 604:	00e78933          	add	s2,a5,a4
 608:	fff78993          	addi	s3,a5,-1
 60c:	99ba                	add	s3,s3,a4
 60e:	377d                	addiw	a4,a4,-1
 610:	1702                	slli	a4,a4,0x20
 612:	9301                	srli	a4,a4,0x20
 614:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 618:	fff94583          	lbu	a1,-1(s2)
 61c:	8526                	mv	a0,s1
 61e:	00000097          	auipc	ra,0x0
 622:	f58080e7          	jalr	-168(ra) # 576 <putc>
  while(--i >= 0)
 626:	197d                	addi	s2,s2,-1
 628:	ff3918e3          	bne	s2,s3,618 <printint+0x80>
}
 62c:	70e2                	ld	ra,56(sp)
 62e:	7442                	ld	s0,48(sp)
 630:	74a2                	ld	s1,40(sp)
 632:	7902                	ld	s2,32(sp)
 634:	69e2                	ld	s3,24(sp)
 636:	6121                	addi	sp,sp,64
 638:	8082                	ret
    x = -xx;
 63a:	40b005bb          	negw	a1,a1
    neg = 1;
 63e:	4885                	li	a7,1
    x = -xx;
 640:	bf8d                	j	5b2 <printint+0x1a>

0000000000000642 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 642:	7119                	addi	sp,sp,-128
 644:	fc86                	sd	ra,120(sp)
 646:	f8a2                	sd	s0,112(sp)
 648:	f4a6                	sd	s1,104(sp)
 64a:	f0ca                	sd	s2,96(sp)
 64c:	ecce                	sd	s3,88(sp)
 64e:	e8d2                	sd	s4,80(sp)
 650:	e4d6                	sd	s5,72(sp)
 652:	e0da                	sd	s6,64(sp)
 654:	fc5e                	sd	s7,56(sp)
 656:	f862                	sd	s8,48(sp)
 658:	f466                	sd	s9,40(sp)
 65a:	f06a                	sd	s10,32(sp)
 65c:	ec6e                	sd	s11,24(sp)
 65e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 660:	0005c903          	lbu	s2,0(a1)
 664:	18090f63          	beqz	s2,802 <vprintf+0x1c0>
 668:	8aaa                	mv	s5,a0
 66a:	8b32                	mv	s6,a2
 66c:	00158493          	addi	s1,a1,1
  state = 0;
 670:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 672:	02500a13          	li	s4,37
      if(c == 'd'){
 676:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 67a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 67e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 682:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	00000b97          	auipc	s7,0x0
 68a:	482b8b93          	addi	s7,s7,1154 # b08 <digits>
 68e:	a839                	j	6ac <vprintf+0x6a>
        putc(fd, c);
 690:	85ca                	mv	a1,s2
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	ee2080e7          	jalr	-286(ra) # 576 <putc>
 69c:	a019                	j	6a2 <vprintf+0x60>
    } else if(state == '%'){
 69e:	01498f63          	beq	s3,s4,6bc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a2:	0485                	addi	s1,s1,1
 6a4:	fff4c903          	lbu	s2,-1(s1)
 6a8:	14090d63          	beqz	s2,802 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6ac:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6b0:	fe0997e3          	bnez	s3,69e <vprintf+0x5c>
      if(c == '%'){
 6b4:	fd479ee3          	bne	a5,s4,690 <vprintf+0x4e>
        state = '%';
 6b8:	89be                	mv	s3,a5
 6ba:	b7e5                	j	6a2 <vprintf+0x60>
      if(c == 'd'){
 6bc:	05878063          	beq	a5,s8,6fc <vprintf+0xba>
      } else if(c == 'l') {
 6c0:	05978c63          	beq	a5,s9,718 <vprintf+0xd6>
      } else if(c == 'x') {
 6c4:	07a78863          	beq	a5,s10,734 <vprintf+0xf2>
      } else if(c == 'p') {
 6c8:	09b78463          	beq	a5,s11,750 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6cc:	07300713          	li	a4,115
 6d0:	0ce78663          	beq	a5,a4,79c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d4:	06300713          	li	a4,99
 6d8:	0ee78e63          	beq	a5,a4,7d4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6dc:	11478863          	beq	a5,s4,7ec <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e0:	85d2                	mv	a1,s4
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	e92080e7          	jalr	-366(ra) # 576 <putc>
        putc(fd, c);
 6ec:	85ca                	mv	a1,s2
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e86080e7          	jalr	-378(ra) # 576 <putc>
      }
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b765                	j	6a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6fc:	008b0913          	addi	s2,s6,8
 700:	4685                	li	a3,1
 702:	4629                	li	a2,10
 704:	000b2583          	lw	a1,0(s6)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e8e080e7          	jalr	-370(ra) # 598 <printint>
 712:	8b4a                	mv	s6,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	b771                	j	6a2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	008b0913          	addi	s2,s6,8
 71c:	4681                	li	a3,0
 71e:	4629                	li	a2,10
 720:	000b2583          	lw	a1,0(s6)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e72080e7          	jalr	-398(ra) # 598 <printint>
 72e:	8b4a                	mv	s6,s2
      state = 0;
 730:	4981                	li	s3,0
 732:	bf85                	j	6a2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 734:	008b0913          	addi	s2,s6,8
 738:	4681                	li	a3,0
 73a:	4641                	li	a2,16
 73c:	000b2583          	lw	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e56080e7          	jalr	-426(ra) # 598 <printint>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bf91                	j	6a2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 750:	008b0793          	addi	a5,s6,8
 754:	f8f43423          	sd	a5,-120(s0)
 758:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 75c:	03000593          	li	a1,48
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	e14080e7          	jalr	-492(ra) # 576 <putc>
  putc(fd, 'x');
 76a:	85ea                	mv	a1,s10
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	e08080e7          	jalr	-504(ra) # 576 <putc>
 776:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 778:	03c9d793          	srli	a5,s3,0x3c
 77c:	97de                	add	a5,a5,s7
 77e:	0007c583          	lbu	a1,0(a5)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	df2080e7          	jalr	-526(ra) # 576 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78c:	0992                	slli	s3,s3,0x4
 78e:	397d                	addiw	s2,s2,-1
 790:	fe0914e3          	bnez	s2,778 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 794:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 798:	4981                	li	s3,0
 79a:	b721                	j	6a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 79c:	008b0993          	addi	s3,s6,8
 7a0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7a4:	02090163          	beqz	s2,7c6 <vprintf+0x184>
        while(*s != 0){
 7a8:	00094583          	lbu	a1,0(s2)
 7ac:	c9a1                	beqz	a1,7fc <vprintf+0x1ba>
          putc(fd, *s);
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	dc6080e7          	jalr	-570(ra) # 576 <putc>
          s++;
 7b8:	0905                	addi	s2,s2,1
        while(*s != 0){
 7ba:	00094583          	lbu	a1,0(s2)
 7be:	f9e5                	bnez	a1,7ae <vprintf+0x16c>
        s = va_arg(ap, char*);
 7c0:	8b4e                	mv	s6,s3
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bdf9                	j	6a2 <vprintf+0x60>
          s = "(null)";
 7c6:	00000917          	auipc	s2,0x0
 7ca:	33a90913          	addi	s2,s2,826 # b00 <malloc+0x1f4>
        while(*s != 0){
 7ce:	02800593          	li	a1,40
 7d2:	bff1                	j	7ae <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7d4:	008b0913          	addi	s2,s6,8
 7d8:	000b4583          	lbu	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	d98080e7          	jalr	-616(ra) # 576 <putc>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bd65                	j	6a2 <vprintf+0x60>
        putc(fd, c);
 7ec:	85d2                	mv	a1,s4
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	d86080e7          	jalr	-634(ra) # 576 <putc>
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b565                	j	6a2 <vprintf+0x60>
        s = va_arg(ap, char*);
 7fc:	8b4e                	mv	s6,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b54d                	j	6a2 <vprintf+0x60>
    }
  }
}
 802:	70e6                	ld	ra,120(sp)
 804:	7446                	ld	s0,112(sp)
 806:	74a6                	ld	s1,104(sp)
 808:	7906                	ld	s2,96(sp)
 80a:	69e6                	ld	s3,88(sp)
 80c:	6a46                	ld	s4,80(sp)
 80e:	6aa6                	ld	s5,72(sp)
 810:	6b06                	ld	s6,64(sp)
 812:	7be2                	ld	s7,56(sp)
 814:	7c42                	ld	s8,48(sp)
 816:	7ca2                	ld	s9,40(sp)
 818:	7d02                	ld	s10,32(sp)
 81a:	6de2                	ld	s11,24(sp)
 81c:	6109                	addi	sp,sp,128
 81e:	8082                	ret

0000000000000820 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 820:	715d                	addi	sp,sp,-80
 822:	ec06                	sd	ra,24(sp)
 824:	e822                	sd	s0,16(sp)
 826:	1000                	addi	s0,sp,32
 828:	e010                	sd	a2,0(s0)
 82a:	e414                	sd	a3,8(s0)
 82c:	e818                	sd	a4,16(s0)
 82e:	ec1c                	sd	a5,24(s0)
 830:	03043023          	sd	a6,32(s0)
 834:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 838:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83c:	8622                	mv	a2,s0
 83e:	00000097          	auipc	ra,0x0
 842:	e04080e7          	jalr	-508(ra) # 642 <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6161                	addi	sp,sp,80
 84c:	8082                	ret

000000000000084e <printf>:

void
printf(const char *fmt, ...)
{
 84e:	711d                	addi	sp,sp,-96
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	addi	s0,sp,32
 856:	e40c                	sd	a1,8(s0)
 858:	e810                	sd	a2,16(s0)
 85a:	ec14                	sd	a3,24(s0)
 85c:	f018                	sd	a4,32(s0)
 85e:	f41c                	sd	a5,40(s0)
 860:	03043823          	sd	a6,48(s0)
 864:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 868:	00840613          	addi	a2,s0,8
 86c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 870:	85aa                	mv	a1,a0
 872:	4505                	li	a0,1
 874:	00000097          	auipc	ra,0x0
 878:	dce080e7          	jalr	-562(ra) # 642 <vprintf>
}
 87c:	60e2                	ld	ra,24(sp)
 87e:	6442                	ld	s0,16(sp)
 880:	6125                	addi	sp,sp,96
 882:	8082                	ret

0000000000000884 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 884:	1141                	addi	sp,sp,-16
 886:	e422                	sd	s0,8(sp)
 888:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 88a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	00000797          	auipc	a5,0x0
 892:	2927b783          	ld	a5,658(a5) # b20 <freep>
 896:	a805                	j	8c6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 898:	4618                	lw	a4,8(a2)
 89a:	9db9                	addw	a1,a1,a4
 89c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a0:	6398                	ld	a4,0(a5)
 8a2:	6318                	ld	a4,0(a4)
 8a4:	fee53823          	sd	a4,-16(a0)
 8a8:	a091                	j	8ec <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8aa:	ff852703          	lw	a4,-8(a0)
 8ae:	9e39                	addw	a2,a2,a4
 8b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8b2:	ff053703          	ld	a4,-16(a0)
 8b6:	e398                	sd	a4,0(a5)
 8b8:	a099                	j	8fe <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e7e463          	bltu	a5,a4,8c4 <free+0x40>
 8c0:	00e6ea63          	bltu	a3,a4,8d4 <free+0x50>
{
 8c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	fed7fae3          	bgeu	a5,a3,8ba <free+0x36>
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e6e463          	bltu	a3,a4,8d4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	fee7eae3          	bltu	a5,a4,8c4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8d4:	ff852583          	lw	a1,-8(a0)
 8d8:	6390                	ld	a2,0(a5)
 8da:	02059813          	slli	a6,a1,0x20
 8de:	01c85713          	srli	a4,a6,0x1c
 8e2:	9736                	add	a4,a4,a3
 8e4:	fae60ae3          	beq	a2,a4,898 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ec:	4790                	lw	a2,8(a5)
 8ee:	02061593          	slli	a1,a2,0x20
 8f2:	01c5d713          	srli	a4,a1,0x1c
 8f6:	973e                	add	a4,a4,a5
 8f8:	fae689e3          	beq	a3,a4,8aa <free+0x26>
  } else
    p->s.ptr = bp;
 8fc:	e394                	sd	a3,0(a5)
  freep = p;
 8fe:	00000717          	auipc	a4,0x0
 902:	22f73123          	sd	a5,546(a4) # b20 <freep>
}
 906:	6422                	ld	s0,8(sp)
 908:	0141                	addi	sp,sp,16
 90a:	8082                	ret

000000000000090c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 90c:	7139                	addi	sp,sp,-64
 90e:	fc06                	sd	ra,56(sp)
 910:	f822                	sd	s0,48(sp)
 912:	f426                	sd	s1,40(sp)
 914:	f04a                	sd	s2,32(sp)
 916:	ec4e                	sd	s3,24(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
 91e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 920:	02051493          	slli	s1,a0,0x20
 924:	9081                	srli	s1,s1,0x20
 926:	04bd                	addi	s1,s1,15
 928:	8091                	srli	s1,s1,0x4
 92a:	0014899b          	addiw	s3,s1,1
 92e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 930:	00000517          	auipc	a0,0x0
 934:	1f053503          	ld	a0,496(a0) # b20 <freep>
 938:	c515                	beqz	a0,964 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	02977f63          	bgeu	a4,s1,97c <malloc+0x70>
 942:	8a4e                	mv	s4,s3
 944:	0009871b          	sext.w	a4,s3
 948:	6685                	lui	a3,0x1
 94a:	00d77363          	bgeu	a4,a3,950 <malloc+0x44>
 94e:	6a05                	lui	s4,0x1
 950:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 954:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 958:	00000917          	auipc	s2,0x0
 95c:	1c890913          	addi	s2,s2,456 # b20 <freep>
  if(p == (char*)-1)
 960:	5afd                	li	s5,-1
 962:	a895                	j	9d6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 964:	00000797          	auipc	a5,0x0
 968:	1c478793          	addi	a5,a5,452 # b28 <base>
 96c:	00000717          	auipc	a4,0x0
 970:	1af73a23          	sd	a5,436(a4) # b20 <freep>
 974:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 976:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 97a:	b7e1                	j	942 <malloc+0x36>
      if(p->s.size == nunits)
 97c:	02e48c63          	beq	s1,a4,9b4 <malloc+0xa8>
        p->s.size -= nunits;
 980:	4137073b          	subw	a4,a4,s3
 984:	c798                	sw	a4,8(a5)
        p += p->s.size;
 986:	02071693          	slli	a3,a4,0x20
 98a:	01c6d713          	srli	a4,a3,0x1c
 98e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 990:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 994:	00000717          	auipc	a4,0x0
 998:	18a73623          	sd	a0,396(a4) # b20 <freep>
      return (void*)(p + 1);
 99c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a0:	70e2                	ld	ra,56(sp)
 9a2:	7442                	ld	s0,48(sp)
 9a4:	74a2                	ld	s1,40(sp)
 9a6:	7902                	ld	s2,32(sp)
 9a8:	69e2                	ld	s3,24(sp)
 9aa:	6a42                	ld	s4,16(sp)
 9ac:	6aa2                	ld	s5,8(sp)
 9ae:	6b02                	ld	s6,0(sp)
 9b0:	6121                	addi	sp,sp,64
 9b2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9b4:	6398                	ld	a4,0(a5)
 9b6:	e118                	sd	a4,0(a0)
 9b8:	bff1                	j	994 <malloc+0x88>
  hp->s.size = nu;
 9ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9be:	0541                	addi	a0,a0,16
 9c0:	00000097          	auipc	ra,0x0
 9c4:	ec4080e7          	jalr	-316(ra) # 884 <free>
  return freep;
 9c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9cc:	d971                	beqz	a0,9a0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d0:	4798                	lw	a4,8(a5)
 9d2:	fa9775e3          	bgeu	a4,s1,97c <malloc+0x70>
    if(p == freep)
 9d6:	00093703          	ld	a4,0(s2)
 9da:	853e                	mv	a0,a5
 9dc:	fef719e3          	bne	a4,a5,9ce <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9e0:	8552                	mv	a0,s4
 9e2:	00000097          	auipc	ra,0x0
 9e6:	b5c080e7          	jalr	-1188(ra) # 53e <sbrk>
  if(p == (char*)-1)
 9ea:	fd5518e3          	bne	a0,s5,9ba <malloc+0xae>
        return 0;
 9ee:	4501                	li	a0,0
 9f0:	bf45                	j	9a0 <malloc+0x94>
