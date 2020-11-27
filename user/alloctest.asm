
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void
test0() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
  enum { NCHILD = 50, NFD = 10};
  int i, j;
  int fd;

  printf("filetest: start\n");
   c:	00001517          	auipc	a0,0x1
  10:	96450513          	addi	a0,a0,-1692 # 970 <malloc+0xea>
  14:	00000097          	auipc	ra,0x0
  18:	7b4080e7          	jalr	1972(ra) # 7c8 <printf>
  1c:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(-1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  20:	00000097          	auipc	ra,0x0
  24:	408080e7          	jalr	1032(ra) # 428 <fork>
    if(pid < 0){
  28:	04054263          	bltz	a0,6c <test0+0x6c>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  2c:	cd29                	beqz	a0,86 <test0+0x86>
  for (i = 0; i < NCHILD; i++) {
  2e:	34fd                	addiw	s1,s1,-1
  30:	f8e5                	bnez	s1,20 <test0+0x20>
  32:	03200493          	li	s1,50
  }

  int xstatus;
  for(int i = 0; i < NCHILD; i++){
    wait(&xstatus);
    if(xstatus == -1) {
  36:	597d                	li	s2,-1
    wait(&xstatus);
  38:	fdc40513          	addi	a0,s0,-36
  3c:	00000097          	auipc	ra,0x0
  40:	3fc080e7          	jalr	1020(ra) # 438 <wait>
    if(xstatus == -1) {
  44:	fdc42783          	lw	a5,-36(s0)
  48:	07278d63          	beq	a5,s2,c2 <test0+0xc2>
  for(int i = 0; i < NCHILD; i++){
  4c:	34fd                	addiw	s1,s1,-1
  4e:	f4ed                	bnez	s1,38 <test0+0x38>
       printf("filetest: FAILED\n");
       exit(-1);
    }
  }

   printf("filetest: OK\n");
  50:	00001517          	auipc	a0,0x1
  54:	96850513          	addi	a0,a0,-1688 # 9b8 <malloc+0x132>
  58:	00000097          	auipc	ra,0x0
  5c:	770080e7          	jalr	1904(ra) # 7c8 <printf>
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	6145                	addi	sp,sp,48
  6a:	8082                	ret
      printf("fork failed");
  6c:	00001517          	auipc	a0,0x1
  70:	91c50513          	addi	a0,a0,-1764 # 988 <malloc+0x102>
  74:	00000097          	auipc	ra,0x0
  78:	754080e7          	jalr	1876(ra) # 7c8 <printf>
      exit(-1);
  7c:	557d                	li	a0,-1
  7e:	00000097          	auipc	ra,0x0
  82:	3b2080e7          	jalr	946(ra) # 430 <exit>
  86:	44a9                	li	s1,10
        if ((fd = open("README", O_RDONLY)) < 0) {
  88:	00001917          	auipc	s2,0x1
  8c:	91090913          	addi	s2,s2,-1776 # 998 <malloc+0x112>
  90:	4581                	li	a1,0
  92:	854a                	mv	a0,s2
  94:	00000097          	auipc	ra,0x0
  98:	3dc080e7          	jalr	988(ra) # 470 <open>
  9c:	00054e63          	bltz	a0,b8 <test0+0xb8>
      for(j = 0; j < NFD; j++) {
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f4fd                	bnez	s1,90 <test0+0x90>
      sleep(10);
  a4:	4529                	li	a0,10
  a6:	00000097          	auipc	ra,0x0
  aa:	41a080e7          	jalr	1050(ra) # 4c0 <sleep>
      exit(0);  // no errors; exit with 0.
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	380080e7          	jalr	896(ra) # 430 <exit>
          exit(-1);
  b8:	557d                	li	a0,-1
  ba:	00000097          	auipc	ra,0x0
  be:	376080e7          	jalr	886(ra) # 430 <exit>
       printf("filetest: FAILED\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	8de50513          	addi	a0,a0,-1826 # 9a0 <malloc+0x11a>
  ca:	00000097          	auipc	ra,0x0
  ce:	6fe080e7          	jalr	1790(ra) # 7c8 <printf>
       exit(-1);
  d2:	557d                	li	a0,-1
  d4:	00000097          	auipc	ra,0x0
  d8:	35c080e7          	jalr	860(ra) # 430 <exit>

00000000000000dc <test1>:

// Allocate all free memory and count how it is
void test1()
{
  dc:	7139                	addi	sp,sp,-64
  de:	fc06                	sd	ra,56(sp)
  e0:	f822                	sd	s0,48(sp)
  e2:	f426                	sd	s1,40(sp)
  e4:	f04a                	sd	s2,32(sp)
  e6:	ec4e                	sd	s3,24(sp)
  e8:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];
  
  printf("memtest: start\n");  
  ea:	00001517          	auipc	a0,0x1
  ee:	8de50513          	addi	a0,a0,-1826 # 9c8 <malloc+0x142>
  f2:	00000097          	auipc	ra,0x0
  f6:	6d6080e7          	jalr	1750(ra) # 7c8 <printf>
  if(pipe(fds) != 0){
  fa:	fc040513          	addi	a0,s0,-64
  fe:	00000097          	auipc	ra,0x0
 102:	342080e7          	jalr	834(ra) # 440 <pipe>
 106:	e525                	bnez	a0,16e <test1+0x92>
 108:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(-1);
  }
  int pid = fork();
 10a:	00000097          	auipc	ra,0x0
 10e:	31e080e7          	jalr	798(ra) # 428 <fork>
  if(pid < 0){
 112:	06054b63          	bltz	a0,188 <test1+0xac>
    printf("fork failed");
    exit(-1);
  }
  if(pid == 0){
 116:	e959                	bnez	a0,1ac <test1+0xd0>
      close(fds[0]);
 118:	fc042503          	lw	a0,-64(s0)
 11c:	00000097          	auipc	ra,0x0
 120:	33c080e7          	jalr	828(ra) # 458 <close>
      while(1) {
        a = sbrk(PGSIZE);
        if (a == (char*)0xffffffffffffffffL)
 124:	597d                	li	s2,-1
          exit(0);
        *(int *)(a+4) = 1;
 126:	4485                	li	s1,1
        if (write(fds[1], "x", 1) != 1) {
 128:	00001997          	auipc	s3,0x1
 12c:	8c098993          	addi	s3,s3,-1856 # 9e8 <malloc+0x162>
        a = sbrk(PGSIZE);
 130:	6505                	lui	a0,0x1
 132:	00000097          	auipc	ra,0x0
 136:	386080e7          	jalr	902(ra) # 4b8 <sbrk>
        if (a == (char*)0xffffffffffffffffL)
 13a:	07250463          	beq	a0,s2,1a2 <test1+0xc6>
        *(int *)(a+4) = 1;
 13e:	c144                	sw	s1,4(a0)
        if (write(fds[1], "x", 1) != 1) {
 140:	8626                	mv	a2,s1
 142:	85ce                	mv	a1,s3
 144:	fc442503          	lw	a0,-60(s0)
 148:	00000097          	auipc	ra,0x0
 14c:	308080e7          	jalr	776(ra) # 450 <write>
 150:	fe9500e3          	beq	a0,s1,130 <test1+0x54>
          printf("write failed");
 154:	00001517          	auipc	a0,0x1
 158:	89c50513          	addi	a0,a0,-1892 # 9f0 <malloc+0x16a>
 15c:	00000097          	auipc	ra,0x0
 160:	66c080e7          	jalr	1644(ra) # 7c8 <printf>
          exit(-1);
 164:	557d                	li	a0,-1
 166:	00000097          	auipc	ra,0x0
 16a:	2ca080e7          	jalr	714(ra) # 430 <exit>
    printf("pipe() failed\n");
 16e:	00001517          	auipc	a0,0x1
 172:	86a50513          	addi	a0,a0,-1942 # 9d8 <malloc+0x152>
 176:	00000097          	auipc	ra,0x0
 17a:	652080e7          	jalr	1618(ra) # 7c8 <printf>
    exit(-1);
 17e:	557d                	li	a0,-1
 180:	00000097          	auipc	ra,0x0
 184:	2b0080e7          	jalr	688(ra) # 430 <exit>
    printf("fork failed");
 188:	00001517          	auipc	a0,0x1
 18c:	80050513          	addi	a0,a0,-2048 # 988 <malloc+0x102>
 190:	00000097          	auipc	ra,0x0
 194:	638080e7          	jalr	1592(ra) # 7c8 <printf>
    exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	296080e7          	jalr	662(ra) # 430 <exit>
          exit(0);
 1a2:	4501                	li	a0,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	28c080e7          	jalr	652(ra) # 430 <exit>
        }
      }
      exit(0);
  }
  close(fds[1]);
 1ac:	fc442503          	lw	a0,-60(s0)
 1b0:	00000097          	auipc	ra,0x0
 1b4:	2a8080e7          	jalr	680(ra) # 458 <close>
  while(1) {
      if (read(fds[0], buf, 1) != 1) {
 1b8:	4605                	li	a2,1
 1ba:	fc840593          	addi	a1,s0,-56
 1be:	fc042503          	lw	a0,-64(s0)
 1c2:	00000097          	auipc	ra,0x0
 1c6:	286080e7          	jalr	646(ra) # 448 <read>
 1ca:	4785                	li	a5,1
 1cc:	00f51463          	bne	a0,a5,1d4 <test1+0xf8>
        break;
      } else {
        tot += 1;
 1d0:	2485                	addiw	s1,s1,1
      if (read(fds[0], buf, 1) != 1) {
 1d2:	b7dd                	j	1b8 <test1+0xdc>
      }
  }
  //int n = (PHYSTOP-KERNBASE)/PGSIZE;
  //printf("allocated %d out of %d pages\n", tot, n);
  if(tot < 31950) {
 1d4:	67a1                	lui	a5,0x8
 1d6:	ccd78793          	addi	a5,a5,-819 # 7ccd <__global_pointer$+0x6a54>
 1da:	0297ca63          	blt	a5,s1,20e <test1+0x132>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 1de:	85a6                	mv	a1,s1
 1e0:	00001517          	auipc	a0,0x1
 1e4:	82050513          	addi	a0,a0,-2016 # a00 <malloc+0x17a>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	5e0080e7          	jalr	1504(ra) # 7c8 <printf>
    printf("memtest: FAILED\n");  
 1f0:	00001517          	auipc	a0,0x1
 1f4:	84850513          	addi	a0,a0,-1976 # a38 <malloc+0x1b2>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	5d0080e7          	jalr	1488(ra) # 7c8 <printf>
  } else {
    printf("memtest: OK\n");  
  }
}
 200:	70e2                	ld	ra,56(sp)
 202:	7442                	ld	s0,48(sp)
 204:	74a2                	ld	s1,40(sp)
 206:	7902                	ld	s2,32(sp)
 208:	69e2                	ld	s3,24(sp)
 20a:	6121                	addi	sp,sp,64
 20c:	8082                	ret
    printf("memtest: OK\n");  
 20e:	00001517          	auipc	a0,0x1
 212:	84250513          	addi	a0,a0,-1982 # a50 <malloc+0x1ca>
 216:	00000097          	auipc	ra,0x0
 21a:	5b2080e7          	jalr	1458(ra) # 7c8 <printf>
}
 21e:	b7cd                	j	200 <test1+0x124>

0000000000000220 <main>:

int
main(int argc, char *argv[])
{
 220:	1141                	addi	sp,sp,-16
 222:	e406                	sd	ra,8(sp)
 224:	e022                	sd	s0,0(sp)
 226:	0800                	addi	s0,sp,16
  test0();
 228:	00000097          	auipc	ra,0x0
 22c:	dd8080e7          	jalr	-552(ra) # 0 <test0>
  test1();
 230:	00000097          	auipc	ra,0x0
 234:	eac080e7          	jalr	-340(ra) # dc <test1>
  exit(0);
 238:	4501                	li	a0,0
 23a:	00000097          	auipc	ra,0x0
 23e:	1f6080e7          	jalr	502(ra) # 430 <exit>

0000000000000242 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 248:	87aa                	mv	a5,a0
 24a:	0585                	addi	a1,a1,1
 24c:	0785                	addi	a5,a5,1
 24e:	fff5c703          	lbu	a4,-1(a1)
 252:	fee78fa3          	sb	a4,-1(a5)
 256:	fb75                	bnez	a4,24a <strcpy+0x8>
    ;
  return os;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb91                	beqz	a5,27c <strcmp+0x1e>
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00f71763          	bne	a4,a5,27c <strcmp+0x1e>
    p++, q++;
 272:	0505                	addi	a0,a0,1
 274:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 276:	00054783          	lbu	a5,0(a0)
 27a:	fbe5                	bnez	a5,26a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 27c:	0005c503          	lbu	a0,0(a1)
}
 280:	40a7853b          	subw	a0,a5,a0
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strlen>:

uint
strlen(const char *s)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e422                	sd	s0,8(sp)
 28e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cf91                	beqz	a5,2b0 <strlen+0x26>
 296:	0505                	addi	a0,a0,1
 298:	87aa                	mv	a5,a0
 29a:	4685                	li	a3,1
 29c:	9e89                	subw	a3,a3,a0
 29e:	00f6853b          	addw	a0,a3,a5
 2a2:	0785                	addi	a5,a5,1
 2a4:	fff7c703          	lbu	a4,-1(a5)
 2a8:	fb7d                	bnez	a4,29e <strlen+0x14>
    ;
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  for(n = 0; s[n]; n++)
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strlen+0x20>

00000000000002b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ba:	ca19                	beqz	a2,2d0 <memset+0x1c>
 2bc:	87aa                	mv	a5,a0
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ca:	0785                	addi	a5,a5,1
 2cc:	fee79de3          	bne	a5,a4,2c6 <memset+0x12>
  }
  return dst;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <strchr>:

char*
strchr(const char *s, char c)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	cb99                	beqz	a5,2f6 <strchr+0x20>
    if(*s == c)
 2e2:	00f58763          	beq	a1,a5,2f0 <strchr+0x1a>
  for(; *s; s++)
 2e6:	0505                	addi	a0,a0,1
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	fbfd                	bnez	a5,2e2 <strchr+0xc>
      return (char*)s;
  return 0;
 2ee:	4501                	li	a0,0
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <strchr+0x1a>

00000000000002fa <gets>:

char*
gets(char *buf, int max)
{
 2fa:	711d                	addi	sp,sp,-96
 2fc:	ec86                	sd	ra,88(sp)
 2fe:	e8a2                	sd	s0,80(sp)
 300:	e4a6                	sd	s1,72(sp)
 302:	e0ca                	sd	s2,64(sp)
 304:	fc4e                	sd	s3,56(sp)
 306:	f852                	sd	s4,48(sp)
 308:	f456                	sd	s5,40(sp)
 30a:	f05a                	sd	s6,32(sp)
 30c:	ec5e                	sd	s7,24(sp)
 30e:	1080                	addi	s0,sp,96
 310:	8baa                	mv	s7,a0
 312:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 314:	892a                	mv	s2,a0
 316:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 318:	4aa9                	li	s5,10
 31a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 31c:	89a6                	mv	s3,s1
 31e:	2485                	addiw	s1,s1,1
 320:	0344d863          	bge	s1,s4,350 <gets+0x56>
    cc = read(0, &c, 1);
 324:	4605                	li	a2,1
 326:	faf40593          	addi	a1,s0,-81
 32a:	4501                	li	a0,0
 32c:	00000097          	auipc	ra,0x0
 330:	11c080e7          	jalr	284(ra) # 448 <read>
    if(cc < 1)
 334:	00a05e63          	blez	a0,350 <gets+0x56>
    buf[i++] = c;
 338:	faf44783          	lbu	a5,-81(s0)
 33c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 340:	01578763          	beq	a5,s5,34e <gets+0x54>
 344:	0905                	addi	s2,s2,1
 346:	fd679be3          	bne	a5,s6,31c <gets+0x22>
  for(i=0; i+1 < max; ){
 34a:	89a6                	mv	s3,s1
 34c:	a011                	j	350 <gets+0x56>
 34e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 350:	99de                	add	s3,s3,s7
 352:	00098023          	sb	zero,0(s3)
  return buf;
}
 356:	855e                	mv	a0,s7
 358:	60e6                	ld	ra,88(sp)
 35a:	6446                	ld	s0,80(sp)
 35c:	64a6                	ld	s1,72(sp)
 35e:	6906                	ld	s2,64(sp)
 360:	79e2                	ld	s3,56(sp)
 362:	7a42                	ld	s4,48(sp)
 364:	7aa2                	ld	s5,40(sp)
 366:	7b02                	ld	s6,32(sp)
 368:	6be2                	ld	s7,24(sp)
 36a:	6125                	addi	sp,sp,96
 36c:	8082                	ret

000000000000036e <stat>:

int
stat(const char *n, struct stat *st)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	e426                	sd	s1,8(sp)
 376:	e04a                	sd	s2,0(sp)
 378:	1000                	addi	s0,sp,32
 37a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37c:	4581                	li	a1,0
 37e:	00000097          	auipc	ra,0x0
 382:	0f2080e7          	jalr	242(ra) # 470 <open>
  if(fd < 0)
 386:	02054563          	bltz	a0,3b0 <stat+0x42>
 38a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 38c:	85ca                	mv	a1,s2
 38e:	00000097          	auipc	ra,0x0
 392:	0fa080e7          	jalr	250(ra) # 488 <fstat>
 396:	892a                	mv	s2,a0
  close(fd);
 398:	8526                	mv	a0,s1
 39a:	00000097          	auipc	ra,0x0
 39e:	0be080e7          	jalr	190(ra) # 458 <close>
  return r;
}
 3a2:	854a                	mv	a0,s2
 3a4:	60e2                	ld	ra,24(sp)
 3a6:	6442                	ld	s0,16(sp)
 3a8:	64a2                	ld	s1,8(sp)
 3aa:	6902                	ld	s2,0(sp)
 3ac:	6105                	addi	sp,sp,32
 3ae:	8082                	ret
    return -1;
 3b0:	597d                	li	s2,-1
 3b2:	bfc5                	j	3a2 <stat+0x34>

00000000000003b4 <atoi>:

int
atoi(const char *s)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ba:	00054603          	lbu	a2,0(a0)
 3be:	fd06079b          	addiw	a5,a2,-48
 3c2:	0ff7f793          	andi	a5,a5,255
 3c6:	4725                	li	a4,9
 3c8:	02f76963          	bltu	a4,a5,3fa <atoi+0x46>
 3cc:	86aa                	mv	a3,a0
  n = 0;
 3ce:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3d0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3d2:	0685                	addi	a3,a3,1
 3d4:	0025179b          	slliw	a5,a0,0x2
 3d8:	9fa9                	addw	a5,a5,a0
 3da:	0017979b          	slliw	a5,a5,0x1
 3de:	9fb1                	addw	a5,a5,a2
 3e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e4:	0006c603          	lbu	a2,0(a3)
 3e8:	fd06071b          	addiw	a4,a2,-48
 3ec:	0ff77713          	andi	a4,a4,255
 3f0:	fee5f1e3          	bgeu	a1,a4,3d2 <atoi+0x1e>
  return n;
}
 3f4:	6422                	ld	s0,8(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret
  n = 0;
 3fa:	4501                	li	a0,0
 3fc:	bfe5                	j	3f4 <atoi+0x40>

00000000000003fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 404:	00c05f63          	blez	a2,422 <memmove+0x24>
 408:	1602                	slli	a2,a2,0x20
 40a:	9201                	srli	a2,a2,0x20
 40c:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 410:	87aa                	mv	a5,a0
    *dst++ = *src++;
 412:	0585                	addi	a1,a1,1
 414:	0785                	addi	a5,a5,1
 416:	fff5c703          	lbu	a4,-1(a1)
 41a:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 41e:	fed79ae3          	bne	a5,a3,412 <memmove+0x14>
  return vdst;
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret

0000000000000428 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 428:	4885                	li	a7,1
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <exit>:
.global exit
exit:
 li a7, SYS_exit
 430:	4889                	li	a7,2
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <wait>:
.global wait
wait:
 li a7, SYS_wait
 438:	488d                	li	a7,3
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 440:	4891                	li	a7,4
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <read>:
.global read
read:
 li a7, SYS_read
 448:	4895                	li	a7,5
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <write>:
.global write
write:
 li a7, SYS_write
 450:	48c1                	li	a7,16
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <close>:
.global close
close:
 li a7, SYS_close
 458:	48d5                	li	a7,21
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <kill>:
.global kill
kill:
 li a7, SYS_kill
 460:	4899                	li	a7,6
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <exec>:
.global exec
exec:
 li a7, SYS_exec
 468:	489d                	li	a7,7
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <open>:
.global open
open:
 li a7, SYS_open
 470:	48bd                	li	a7,15
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 478:	48c5                	li	a7,17
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 480:	48c9                	li	a7,18
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 488:	48a1                	li	a7,8
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <link>:
.global link
link:
 li a7, SYS_link
 490:	48cd                	li	a7,19
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 498:	48d1                	li	a7,20
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a0:	48a5                	li	a7,9
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a8:	48a9                	li	a7,10
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b0:	48ad                	li	a7,11
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b8:	48b1                	li	a7,12
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c0:	48b5                	li	a7,13
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c8:	48b9                	li	a7,14
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4d0:	48d9                	li	a7,22
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <crash>:
.global crash
crash:
 li a7, SYS_crash
 4d8:	48dd                	li	a7,23
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <mount>:
.global mount
mount:
 li a7, SYS_mount
 4e0:	48e1                	li	a7,24
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <umount>:
.global umount
umount:
 li a7, SYS_umount
 4e8:	48e5                	li	a7,25
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f0:	1101                	addi	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	1000                	addi	s0,sp,32
 4f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fc:	4605                	li	a2,1
 4fe:	fef40593          	addi	a1,s0,-17
 502:	00000097          	auipc	ra,0x0
 506:	f4e080e7          	jalr	-178(ra) # 450 <write>
}
 50a:	60e2                	ld	ra,24(sp)
 50c:	6442                	ld	s0,16(sp)
 50e:	6105                	addi	sp,sp,32
 510:	8082                	ret

0000000000000512 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 512:	7139                	addi	sp,sp,-64
 514:	fc06                	sd	ra,56(sp)
 516:	f822                	sd	s0,48(sp)
 518:	f426                	sd	s1,40(sp)
 51a:	f04a                	sd	s2,32(sp)
 51c:	ec4e                	sd	s3,24(sp)
 51e:	0080                	addi	s0,sp,64
 520:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 522:	c299                	beqz	a3,528 <printint+0x16>
 524:	0805c863          	bltz	a1,5b4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 528:	2581                	sext.w	a1,a1
  neg = 0;
 52a:	4881                	li	a7,0
 52c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 530:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 532:	2601                	sext.w	a2,a2
 534:	00000517          	auipc	a0,0x0
 538:	53450513          	addi	a0,a0,1332 # a68 <digits>
 53c:	883a                	mv	a6,a4
 53e:	2705                	addiw	a4,a4,1
 540:	02c5f7bb          	remuw	a5,a1,a2
 544:	1782                	slli	a5,a5,0x20
 546:	9381                	srli	a5,a5,0x20
 548:	97aa                	add	a5,a5,a0
 54a:	0007c783          	lbu	a5,0(a5)
 54e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 552:	0005879b          	sext.w	a5,a1
 556:	02c5d5bb          	divuw	a1,a1,a2
 55a:	0685                	addi	a3,a3,1
 55c:	fec7f0e3          	bgeu	a5,a2,53c <printint+0x2a>
  if(neg)
 560:	00088b63          	beqz	a7,576 <printint+0x64>
    buf[i++] = '-';
 564:	fd040793          	addi	a5,s0,-48
 568:	973e                	add	a4,a4,a5
 56a:	02d00793          	li	a5,45
 56e:	fef70823          	sb	a5,-16(a4)
 572:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 576:	02e05863          	blez	a4,5a6 <printint+0x94>
 57a:	fc040793          	addi	a5,s0,-64
 57e:	00e78933          	add	s2,a5,a4
 582:	fff78993          	addi	s3,a5,-1
 586:	99ba                	add	s3,s3,a4
 588:	377d                	addiw	a4,a4,-1
 58a:	1702                	slli	a4,a4,0x20
 58c:	9301                	srli	a4,a4,0x20
 58e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 592:	fff94583          	lbu	a1,-1(s2)
 596:	8526                	mv	a0,s1
 598:	00000097          	auipc	ra,0x0
 59c:	f58080e7          	jalr	-168(ra) # 4f0 <putc>
  while(--i >= 0)
 5a0:	197d                	addi	s2,s2,-1
 5a2:	ff3918e3          	bne	s2,s3,592 <printint+0x80>
}
 5a6:	70e2                	ld	ra,56(sp)
 5a8:	7442                	ld	s0,48(sp)
 5aa:	74a2                	ld	s1,40(sp)
 5ac:	7902                	ld	s2,32(sp)
 5ae:	69e2                	ld	s3,24(sp)
 5b0:	6121                	addi	sp,sp,64
 5b2:	8082                	ret
    x = -xx;
 5b4:	40b005bb          	negw	a1,a1
    neg = 1;
 5b8:	4885                	li	a7,1
    x = -xx;
 5ba:	bf8d                	j	52c <printint+0x1a>

00000000000005bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5bc:	7119                	addi	sp,sp,-128
 5be:	fc86                	sd	ra,120(sp)
 5c0:	f8a2                	sd	s0,112(sp)
 5c2:	f4a6                	sd	s1,104(sp)
 5c4:	f0ca                	sd	s2,96(sp)
 5c6:	ecce                	sd	s3,88(sp)
 5c8:	e8d2                	sd	s4,80(sp)
 5ca:	e4d6                	sd	s5,72(sp)
 5cc:	e0da                	sd	s6,64(sp)
 5ce:	fc5e                	sd	s7,56(sp)
 5d0:	f862                	sd	s8,48(sp)
 5d2:	f466                	sd	s9,40(sp)
 5d4:	f06a                	sd	s10,32(sp)
 5d6:	ec6e                	sd	s11,24(sp)
 5d8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5da:	0005c903          	lbu	s2,0(a1)
 5de:	18090f63          	beqz	s2,77c <vprintf+0x1c0>
 5e2:	8aaa                	mv	s5,a0
 5e4:	8b32                	mv	s6,a2
 5e6:	00158493          	addi	s1,a1,1
  state = 0;
 5ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ec:	02500a13          	li	s4,37
      if(c == 'd'){
 5f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5f4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5f8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5fc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 600:	00000b97          	auipc	s7,0x0
 604:	468b8b93          	addi	s7,s7,1128 # a68 <digits>
 608:	a839                	j	626 <vprintf+0x6a>
        putc(fd, c);
 60a:	85ca                	mv	a1,s2
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	ee2080e7          	jalr	-286(ra) # 4f0 <putc>
 616:	a019                	j	61c <vprintf+0x60>
    } else if(state == '%'){
 618:	01498f63          	beq	s3,s4,636 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 61c:	0485                	addi	s1,s1,1
 61e:	fff4c903          	lbu	s2,-1(s1)
 622:	14090d63          	beqz	s2,77c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 626:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62a:	fe0997e3          	bnez	s3,618 <vprintf+0x5c>
      if(c == '%'){
 62e:	fd479ee3          	bne	a5,s4,60a <vprintf+0x4e>
        state = '%';
 632:	89be                	mv	s3,a5
 634:	b7e5                	j	61c <vprintf+0x60>
      if(c == 'd'){
 636:	05878063          	beq	a5,s8,676 <vprintf+0xba>
      } else if(c == 'l') {
 63a:	05978c63          	beq	a5,s9,692 <vprintf+0xd6>
      } else if(c == 'x') {
 63e:	07a78863          	beq	a5,s10,6ae <vprintf+0xf2>
      } else if(c == 'p') {
 642:	09b78463          	beq	a5,s11,6ca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 646:	07300713          	li	a4,115
 64a:	0ce78663          	beq	a5,a4,716 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64e:	06300713          	li	a4,99
 652:	0ee78e63          	beq	a5,a4,74e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 656:	11478863          	beq	a5,s4,766 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65a:	85d2                	mv	a1,s4
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e92080e7          	jalr	-366(ra) # 4f0 <putc>
        putc(fd, c);
 666:	85ca                	mv	a1,s2
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e86080e7          	jalr	-378(ra) # 4f0 <putc>
      }
      state = 0;
 672:	4981                	li	s3,0
 674:	b765                	j	61c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 676:	008b0913          	addi	s2,s6,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000b2583          	lw	a1,0(s6)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e8e080e7          	jalr	-370(ra) # 512 <printint>
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	b771                	j	61c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	008b0913          	addi	s2,s6,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000b2583          	lw	a1,0(s6)
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	e72080e7          	jalr	-398(ra) # 512 <printint>
 6a8:	8b4a                	mv	s6,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bf85                	j	61c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6ae:	008b0913          	addi	s2,s6,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000b2583          	lw	a1,0(s6)
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e56080e7          	jalr	-426(ra) # 512 <printint>
 6c4:	8b4a                	mv	s6,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bf91                	j	61c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ca:	008b0793          	addi	a5,s6,8
 6ce:	f8f43423          	sd	a5,-120(s0)
 6d2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6d6:	03000593          	li	a1,48
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e14080e7          	jalr	-492(ra) # 4f0 <putc>
  putc(fd, 'x');
 6e4:	85ea                	mv	a1,s10
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e08080e7          	jalr	-504(ra) # 4f0 <putc>
 6f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	03c9d793          	srli	a5,s3,0x3c
 6f6:	97de                	add	a5,a5,s7
 6f8:	0007c583          	lbu	a1,0(a5)
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	df2080e7          	jalr	-526(ra) # 4f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 706:	0992                	slli	s3,s3,0x4
 708:	397d                	addiw	s2,s2,-1
 70a:	fe0914e3          	bnez	s2,6f2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 70e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 712:	4981                	li	s3,0
 714:	b721                	j	61c <vprintf+0x60>
        s = va_arg(ap, char*);
 716:	008b0993          	addi	s3,s6,8
 71a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 71e:	02090163          	beqz	s2,740 <vprintf+0x184>
        while(*s != 0){
 722:	00094583          	lbu	a1,0(s2)
 726:	c9a1                	beqz	a1,776 <vprintf+0x1ba>
          putc(fd, *s);
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	dc6080e7          	jalr	-570(ra) # 4f0 <putc>
          s++;
 732:	0905                	addi	s2,s2,1
        while(*s != 0){
 734:	00094583          	lbu	a1,0(s2)
 738:	f9e5                	bnez	a1,728 <vprintf+0x16c>
        s = va_arg(ap, char*);
 73a:	8b4e                	mv	s6,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bdf9                	j	61c <vprintf+0x60>
          s = "(null)";
 740:	00000917          	auipc	s2,0x0
 744:	32090913          	addi	s2,s2,800 # a60 <malloc+0x1da>
        while(*s != 0){
 748:	02800593          	li	a1,40
 74c:	bff1                	j	728 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 74e:	008b0913          	addi	s2,s6,8
 752:	000b4583          	lbu	a1,0(s6)
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	d98080e7          	jalr	-616(ra) # 4f0 <putc>
 760:	8b4a                	mv	s6,s2
      state = 0;
 762:	4981                	li	s3,0
 764:	bd65                	j	61c <vprintf+0x60>
        putc(fd, c);
 766:	85d2                	mv	a1,s4
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	d86080e7          	jalr	-634(ra) # 4f0 <putc>
      state = 0;
 772:	4981                	li	s3,0
 774:	b565                	j	61c <vprintf+0x60>
        s = va_arg(ap, char*);
 776:	8b4e                	mv	s6,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	b54d                	j	61c <vprintf+0x60>
    }
  }
}
 77c:	70e6                	ld	ra,120(sp)
 77e:	7446                	ld	s0,112(sp)
 780:	74a6                	ld	s1,104(sp)
 782:	7906                	ld	s2,96(sp)
 784:	69e6                	ld	s3,88(sp)
 786:	6a46                	ld	s4,80(sp)
 788:	6aa6                	ld	s5,72(sp)
 78a:	6b06                	ld	s6,64(sp)
 78c:	7be2                	ld	s7,56(sp)
 78e:	7c42                	ld	s8,48(sp)
 790:	7ca2                	ld	s9,40(sp)
 792:	7d02                	ld	s10,32(sp)
 794:	6de2                	ld	s11,24(sp)
 796:	6109                	addi	sp,sp,128
 798:	8082                	ret

000000000000079a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79a:	715d                	addi	sp,sp,-80
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e010                	sd	a2,0(s0)
 7a4:	e414                	sd	a3,8(s0)
 7a6:	e818                	sd	a4,16(s0)
 7a8:	ec1c                	sd	a5,24(s0)
 7aa:	03043023          	sd	a6,32(s0)
 7ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b6:	8622                	mv	a2,s0
 7b8:	00000097          	auipc	ra,0x0
 7bc:	e04080e7          	jalr	-508(ra) # 5bc <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6161                	addi	sp,sp,80
 7c6:	8082                	ret

00000000000007c8 <printf>:

void
printf(const char *fmt, ...)
{
 7c8:	711d                	addi	sp,sp,-96
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	e40c                	sd	a1,8(s0)
 7d2:	e810                	sd	a2,16(s0)
 7d4:	ec14                	sd	a3,24(s0)
 7d6:	f018                	sd	a4,32(s0)
 7d8:	f41c                	sd	a5,40(s0)
 7da:	03043823          	sd	a6,48(s0)
 7de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	00840613          	addi	a2,s0,8
 7e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ea:	85aa                	mv	a1,a0
 7ec:	4505                	li	a0,1
 7ee:	00000097          	auipc	ra,0x0
 7f2:	dce080e7          	jalr	-562(ra) # 5bc <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6125                	addi	sp,sp,96
 7fc:	8082                	ret

00000000000007fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fe:	1141                	addi	sp,sp,-16
 800:	e422                	sd	s0,8(sp)
 802:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 804:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	00000797          	auipc	a5,0x0
 80c:	2787b783          	ld	a5,632(a5) # a80 <freep>
 810:	a805                	j	840 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 812:	4618                	lw	a4,8(a2)
 814:	9db9                	addw	a1,a1,a4
 816:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	6318                	ld	a4,0(a4)
 81e:	fee53823          	sd	a4,-16(a0)
 822:	a091                	j	866 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 824:	ff852703          	lw	a4,-8(a0)
 828:	9e39                	addw	a2,a2,a4
 82a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 82c:	ff053703          	ld	a4,-16(a0)
 830:	e398                	sd	a4,0(a5)
 832:	a099                	j	878 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	6398                	ld	a4,0(a5)
 836:	00e7e463          	bltu	a5,a4,83e <free+0x40>
 83a:	00e6ea63          	bltu	a3,a4,84e <free+0x50>
{
 83e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	fed7fae3          	bgeu	a5,a3,834 <free+0x36>
 844:	6398                	ld	a4,0(a5)
 846:	00e6e463          	bltu	a3,a4,84e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	fee7eae3          	bltu	a5,a4,83e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 84e:	ff852583          	lw	a1,-8(a0)
 852:	6390                	ld	a2,0(a5)
 854:	02059813          	slli	a6,a1,0x20
 858:	01c85713          	srli	a4,a6,0x1c
 85c:	9736                	add	a4,a4,a3
 85e:	fae60ae3          	beq	a2,a4,812 <free+0x14>
    bp->s.ptr = p->s.ptr;
 862:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 866:	4790                	lw	a2,8(a5)
 868:	02061593          	slli	a1,a2,0x20
 86c:	01c5d713          	srli	a4,a1,0x1c
 870:	973e                	add	a4,a4,a5
 872:	fae689e3          	beq	a3,a4,824 <free+0x26>
  } else
    p->s.ptr = bp;
 876:	e394                	sd	a3,0(a5)
  freep = p;
 878:	00000717          	auipc	a4,0x0
 87c:	20f73423          	sd	a5,520(a4) # a80 <freep>
}
 880:	6422                	ld	s0,8(sp)
 882:	0141                	addi	sp,sp,16
 884:	8082                	ret

0000000000000886 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 886:	7139                	addi	sp,sp,-64
 888:	fc06                	sd	ra,56(sp)
 88a:	f822                	sd	s0,48(sp)
 88c:	f426                	sd	s1,40(sp)
 88e:	f04a                	sd	s2,32(sp)
 890:	ec4e                	sd	s3,24(sp)
 892:	e852                	sd	s4,16(sp)
 894:	e456                	sd	s5,8(sp)
 896:	e05a                	sd	s6,0(sp)
 898:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89a:	02051493          	slli	s1,a0,0x20
 89e:	9081                	srli	s1,s1,0x20
 8a0:	04bd                	addi	s1,s1,15
 8a2:	8091                	srli	s1,s1,0x4
 8a4:	0014899b          	addiw	s3,s1,1
 8a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8aa:	00000517          	auipc	a0,0x0
 8ae:	1d653503          	ld	a0,470(a0) # a80 <freep>
 8b2:	c515                	beqz	a0,8de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b6:	4798                	lw	a4,8(a5)
 8b8:	02977f63          	bgeu	a4,s1,8f6 <malloc+0x70>
 8bc:	8a4e                	mv	s4,s3
 8be:	0009871b          	sext.w	a4,s3
 8c2:	6685                	lui	a3,0x1
 8c4:	00d77363          	bgeu	a4,a3,8ca <malloc+0x44>
 8c8:	6a05                	lui	s4,0x1
 8ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d2:	00000917          	auipc	s2,0x0
 8d6:	1ae90913          	addi	s2,s2,430 # a80 <freep>
  if(p == (char*)-1)
 8da:	5afd                	li	s5,-1
 8dc:	a895                	j	950 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8de:	00000797          	auipc	a5,0x0
 8e2:	1aa78793          	addi	a5,a5,426 # a88 <base>
 8e6:	00000717          	auipc	a4,0x0
 8ea:	18f73d23          	sd	a5,410(a4) # a80 <freep>
 8ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f4:	b7e1                	j	8bc <malloc+0x36>
      if(p->s.size == nunits)
 8f6:	02e48c63          	beq	s1,a4,92e <malloc+0xa8>
        p->s.size -= nunits;
 8fa:	4137073b          	subw	a4,a4,s3
 8fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 900:	02071693          	slli	a3,a4,0x20
 904:	01c6d713          	srli	a4,a3,0x1c
 908:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90e:	00000717          	auipc	a4,0x0
 912:	16a73923          	sd	a0,370(a4) # a80 <freep>
      return (void*)(p + 1);
 916:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 91a:	70e2                	ld	ra,56(sp)
 91c:	7442                	ld	s0,48(sp)
 91e:	74a2                	ld	s1,40(sp)
 920:	7902                	ld	s2,32(sp)
 922:	69e2                	ld	s3,24(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	6121                	addi	sp,sp,64
 92c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 92e:	6398                	ld	a4,0(a5)
 930:	e118                	sd	a4,0(a0)
 932:	bff1                	j	90e <malloc+0x88>
  hp->s.size = nu;
 934:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 938:	0541                	addi	a0,a0,16
 93a:	00000097          	auipc	ra,0x0
 93e:	ec4080e7          	jalr	-316(ra) # 7fe <free>
  return freep;
 942:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 946:	d971                	beqz	a0,91a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	fa9775e3          	bgeu	a4,s1,8f6 <malloc+0x70>
    if(p == freep)
 950:	00093703          	ld	a4,0(s2)
 954:	853e                	mv	a0,a5
 956:	fef719e3          	bne	a4,a5,948 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 95a:	8552                	mv	a0,s4
 95c:	00000097          	auipc	ra,0x0
 960:	b5c080e7          	jalr	-1188(ra) # 4b8 <sbrk>
  if(p == (char*)-1)
 964:	fd5518e3          	bne	a0,s5,934 <malloc+0xae>
        return 0;
 968:	4501                	li	a0,0
 96a:	bf45                	j	91a <malloc+0x94>
