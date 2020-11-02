
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void
test0() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  enum { NCHILD = 50, NFD = 10};
  int i, j;
  int fd;

  printf("filetest: start\n");
  12:	00001517          	auipc	a0,0x1
  16:	9de50513          	addi	a0,a0,-1570 # 9f0 <malloc+0xec>
  1a:	00001097          	auipc	ra,0x1
  1e:	82c080e7          	jalr	-2004(ra) # 846 <printf>
  22:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	498080e7          	jalr	1176(ra) # 4be <fork>
    if(pid < 0){
  2e:	00054f63          	bltz	a0,4c <test0+0x4c>
      printf("fork failed");
      exit(1);
    }
    if(pid == 0){
  32:	c915                	beqz	a0,66 <test0+0x66>
  for (i = 0; i < NCHILD; i++) {
  34:	34fd                	addiw	s1,s1,-1
  36:	f8e5                	bnez	s1,26 <test0+0x26>
  38:	03200493          	li	s1,50
      sleep(10);
      exit(0);  // no errors; exit with 0.
    }
  }

  int all_ok = 1;
  3c:	4905                	li	s2,1
  for(int i = 0; i < NCHILD; i++){
    int xstatus;
    wait(&xstatus);
    if(xstatus != 0) {
      if(all_ok == 1)
  3e:	4985                	li	s3,1
        printf("filetest: FAILED\n");
  40:	00001a97          	auipc	s5,0x1
  44:	9e0a8a93          	addi	s5,s5,-1568 # a20 <malloc+0x11c>
      all_ok = 0;
  48:	4a01                	li	s4,0
  4a:	a8b1                	j	a6 <test0+0xa6>
      printf("fork failed");
  4c:	00001517          	auipc	a0,0x1
  50:	9bc50513          	addi	a0,a0,-1604 # a08 <malloc+0x104>
  54:	00000097          	auipc	ra,0x0
  58:	7f2080e7          	jalr	2034(ra) # 846 <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	468080e7          	jalr	1128(ra) # 4c6 <exit>
  66:	44a9                	li	s1,10
        if ((fd = open("README", O_RDONLY)) < 0) {
  68:	00001917          	auipc	s2,0x1
  6c:	9b090913          	addi	s2,s2,-1616 # a18 <malloc+0x114>
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	492080e7          	jalr	1170(ra) # 506 <open>
  7c:	00054e63          	bltz	a0,98 <test0+0x98>
      for(j = 0; j < NFD; j++) {
  80:	34fd                	addiw	s1,s1,-1
  82:	f4fd                	bnez	s1,70 <test0+0x70>
      sleep(10);
  84:	4529                	li	a0,10
  86:	00000097          	auipc	ra,0x0
  8a:	4d0080e7          	jalr	1232(ra) # 556 <sleep>
      exit(0);  // no errors; exit with 0.
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	436080e7          	jalr	1078(ra) # 4c6 <exit>
          exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	42c080e7          	jalr	1068(ra) # 4c6 <exit>
  for(int i = 0; i < NCHILD; i++){
  a2:	34fd                	addiw	s1,s1,-1
  a4:	c09d                	beqz	s1,ca <test0+0xca>
    wait(&xstatus);
  a6:	fbc40513          	addi	a0,s0,-68
  aa:	00000097          	auipc	ra,0x0
  ae:	424080e7          	jalr	1060(ra) # 4ce <wait>
    if(xstatus != 0) {
  b2:	fbc42783          	lw	a5,-68(s0)
  b6:	d7f5                	beqz	a5,a2 <test0+0xa2>
      if(all_ok == 1)
  b8:	ff3915e3          	bne	s2,s3,a2 <test0+0xa2>
        printf("filetest: FAILED\n");
  bc:	8556                	mv	a0,s5
  be:	00000097          	auipc	ra,0x0
  c2:	788080e7          	jalr	1928(ra) # 846 <printf>
      all_ok = 0;
  c6:	8952                	mv	s2,s4
  c8:	bfe9                	j	a2 <test0+0xa2>
    }
  }

  if(all_ok)
  ca:	00091b63          	bnez	s2,e0 <test0+0xe0>
    printf("filetest: OK\n");
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6ae2                	ld	s5,24(sp)
  dc:	6161                	addi	sp,sp,80
  de:	8082                	ret
    printf("filetest: OK\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	95850513          	addi	a0,a0,-1704 # a38 <malloc+0x134>
  e8:	00000097          	auipc	ra,0x0
  ec:	75e080e7          	jalr	1886(ra) # 846 <printf>
}
  f0:	bff9                	j	ce <test0+0xce>

00000000000000f2 <test1>:

// Allocate all free memory and count how it is
void test1()
{
  f2:	7139                	addi	sp,sp,-64
  f4:	fc06                	sd	ra,56(sp)
  f6:	f822                	sd	s0,48(sp)
  f8:	f426                	sd	s1,40(sp)
  fa:	f04a                	sd	s2,32(sp)
  fc:	ec4e                	sd	s3,24(sp)
  fe:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];
  
  printf("memtest: start\n");  
 100:	00001517          	auipc	a0,0x1
 104:	94850513          	addi	a0,a0,-1720 # a48 <malloc+0x144>
 108:	00000097          	auipc	ra,0x0
 10c:	73e080e7          	jalr	1854(ra) # 846 <printf>
  if(pipe(fds) != 0){
 110:	fc040513          	addi	a0,s0,-64
 114:	00000097          	auipc	ra,0x0
 118:	3c2080e7          	jalr	962(ra) # 4d6 <pipe>
 11c:	e525                	bnez	a0,184 <test1+0x92>
 11e:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }
  int pid = fork();
 120:	00000097          	auipc	ra,0x0
 124:	39e080e7          	jalr	926(ra) # 4be <fork>
  if(pid < 0){
 128:	06054b63          	bltz	a0,19e <test1+0xac>
    printf("fork failed");
    exit(1);
  }
  if(pid == 0){
 12c:	e959                	bnez	a0,1c2 <test1+0xd0>
      close(fds[0]);
 12e:	fc042503          	lw	a0,-64(s0)
 132:	00000097          	auipc	ra,0x0
 136:	3bc080e7          	jalr	956(ra) # 4ee <close>
      while(1) {
        a = sbrk(PGSIZE);
        if (a == (char*)0xffffffffffffffffL)
 13a:	597d                	li	s2,-1
          exit(0);
        *(int *)(a+4) = 1;
 13c:	4485                	li	s1,1
        if (write(fds[1], "x", 1) != 1) {
 13e:	00001997          	auipc	s3,0x1
 142:	92a98993          	addi	s3,s3,-1750 # a68 <malloc+0x164>
        a = sbrk(PGSIZE);
 146:	6505                	lui	a0,0x1
 148:	00000097          	auipc	ra,0x0
 14c:	406080e7          	jalr	1030(ra) # 54e <sbrk>
        if (a == (char*)0xffffffffffffffffL)
 150:	07250463          	beq	a0,s2,1b8 <test1+0xc6>
        *(int *)(a+4) = 1;
 154:	c144                	sw	s1,4(a0)
        if (write(fds[1], "x", 1) != 1) {
 156:	8626                	mv	a2,s1
 158:	85ce                	mv	a1,s3
 15a:	fc442503          	lw	a0,-60(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	388080e7          	jalr	904(ra) # 4e6 <write>
 166:	fe9500e3          	beq	a0,s1,146 <test1+0x54>
          printf("write failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	90650513          	addi	a0,a0,-1786 # a70 <malloc+0x16c>
 172:	00000097          	auipc	ra,0x0
 176:	6d4080e7          	jalr	1748(ra) # 846 <printf>
          exit(1);
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	34a080e7          	jalr	842(ra) # 4c6 <exit>
    printf("pipe() failed\n");
 184:	00001517          	auipc	a0,0x1
 188:	8d450513          	addi	a0,a0,-1836 # a58 <malloc+0x154>
 18c:	00000097          	auipc	ra,0x0
 190:	6ba080e7          	jalr	1722(ra) # 846 <printf>
    exit(1);
 194:	4505                	li	a0,1
 196:	00000097          	auipc	ra,0x0
 19a:	330080e7          	jalr	816(ra) # 4c6 <exit>
    printf("fork failed");
 19e:	00001517          	auipc	a0,0x1
 1a2:	86a50513          	addi	a0,a0,-1942 # a08 <malloc+0x104>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	6a0080e7          	jalr	1696(ra) # 846 <printf>
    exit(1);
 1ae:	4505                	li	a0,1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	316080e7          	jalr	790(ra) # 4c6 <exit>
          exit(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	30c080e7          	jalr	780(ra) # 4c6 <exit>
        }
      }
      exit(0);
  }
  close(fds[1]);
 1c2:	fc442503          	lw	a0,-60(s0)
 1c6:	00000097          	auipc	ra,0x0
 1ca:	328080e7          	jalr	808(ra) # 4ee <close>
  while(1) {
      if (read(fds[0], buf, 1) != 1) {
 1ce:	4605                	li	a2,1
 1d0:	fc840593          	addi	a1,s0,-56
 1d4:	fc042503          	lw	a0,-64(s0)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	306080e7          	jalr	774(ra) # 4de <read>
 1e0:	4785                	li	a5,1
 1e2:	00f51463          	bne	a0,a5,1ea <test1+0xf8>
        break;
      } else {
        tot += 1;
 1e6:	2485                	addiw	s1,s1,1
      if (read(fds[0], buf, 1) != 1) {
 1e8:	b7dd                	j	1ce <test1+0xdc>
      }
  }
  //int n = (PHYSTOP-KERNBASE)/PGSIZE;
  //printf("allocated %d out of %d pages\n", tot, n);
  if(tot < 31950) {
 1ea:	67a1                	lui	a5,0x8
 1ec:	ccd78793          	addi	a5,a5,-819 # 7ccd <__global_pointer$+0x69d4>
 1f0:	0297ca63          	blt	a5,s1,224 <test1+0x132>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 1f4:	85a6                	mv	a1,s1
 1f6:	00001517          	auipc	a0,0x1
 1fa:	88a50513          	addi	a0,a0,-1910 # a80 <malloc+0x17c>
 1fe:	00000097          	auipc	ra,0x0
 202:	648080e7          	jalr	1608(ra) # 846 <printf>
    printf("memtest: FAILED\n");  
 206:	00001517          	auipc	a0,0x1
 20a:	8b250513          	addi	a0,a0,-1870 # ab8 <malloc+0x1b4>
 20e:	00000097          	auipc	ra,0x0
 212:	638080e7          	jalr	1592(ra) # 846 <printf>
  } else {
    printf("memtest: OK\n");  
  }
}
 216:	70e2                	ld	ra,56(sp)
 218:	7442                	ld	s0,48(sp)
 21a:	74a2                	ld	s1,40(sp)
 21c:	7902                	ld	s2,32(sp)
 21e:	69e2                	ld	s3,24(sp)
 220:	6121                	addi	sp,sp,64
 222:	8082                	ret
    printf("memtest: OK\n");  
 224:	00001517          	auipc	a0,0x1
 228:	8ac50513          	addi	a0,a0,-1876 # ad0 <malloc+0x1cc>
 22c:	00000097          	auipc	ra,0x0
 230:	61a080e7          	jalr	1562(ra) # 846 <printf>
}
 234:	b7cd                	j	216 <test1+0x124>

0000000000000236 <main>:

int
main(int argc, char *argv[])
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  test0();
 23e:	00000097          	auipc	ra,0x0
 242:	dc2080e7          	jalr	-574(ra) # 0 <test0>
  test1();
 246:	00000097          	auipc	ra,0x0
 24a:	eac080e7          	jalr	-340(ra) # f2 <test1>
  exit(0);
 24e:	4501                	li	a0,0
 250:	00000097          	auipc	ra,0x0
 254:	276080e7          	jalr	630(ra) # 4c6 <exit>

0000000000000258 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25e:	87aa                	mv	a5,a0
 260:	0585                	addi	a1,a1,1
 262:	0785                	addi	a5,a5,1
 264:	fff5c703          	lbu	a4,-1(a1)
 268:	fee78fa3          	sb	a4,-1(a5)
 26c:	fb75                	bnez	a4,260 <strcpy+0x8>
    ;
  return os;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cb91                	beqz	a5,292 <strcmp+0x1e>
 280:	0005c703          	lbu	a4,0(a1)
 284:	00f71763          	bne	a4,a5,292 <strcmp+0x1e>
    p++, q++;
 288:	0505                	addi	a0,a0,1
 28a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	fbe5                	bnez	a5,280 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 292:	0005c503          	lbu	a0,0(a1)
}
 296:	40a7853b          	subw	a0,a5,a0
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e422                	sd	s0,8(sp)
 2a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	cf91                	beqz	a5,2c6 <strlen+0x26>
 2ac:	0505                	addi	a0,a0,1
 2ae:	87aa                	mv	a5,a0
 2b0:	4685                	li	a3,1
 2b2:	9e89                	subw	a3,a3,a0
 2b4:	00f6853b          	addw	a0,a3,a5
 2b8:	0785                	addi	a5,a5,1
 2ba:	fff7c703          	lbu	a4,-1(a5)
 2be:	fb7d                	bnez	a4,2b4 <strlen+0x14>
    ;
  return n;
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  for(n = 0; s[n]; n++)
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <strlen+0x20>

00000000000002ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d0:	ca19                	beqz	a2,2e6 <memset+0x1c>
 2d2:	87aa                	mv	a5,a0
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e0:	0785                	addi	a5,a5,1
 2e2:	fee79de3          	bne	a5,a4,2dc <memset+0x12>
  }
  return dst;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strchr>:

char*
strchr(const char *s, char c)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	cb99                	beqz	a5,30c <strchr+0x20>
    if(*s == c)
 2f8:	00f58763          	beq	a1,a5,306 <strchr+0x1a>
  for(; *s; s++)
 2fc:	0505                	addi	a0,a0,1
 2fe:	00054783          	lbu	a5,0(a0)
 302:	fbfd                	bnez	a5,2f8 <strchr+0xc>
      return (char*)s;
  return 0;
 304:	4501                	li	a0,0
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  return 0;
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <strchr+0x1a>

0000000000000310 <gets>:

char*
gets(char *buf, int max)
{
 310:	711d                	addi	sp,sp,-96
 312:	ec86                	sd	ra,88(sp)
 314:	e8a2                	sd	s0,80(sp)
 316:	e4a6                	sd	s1,72(sp)
 318:	e0ca                	sd	s2,64(sp)
 31a:	fc4e                	sd	s3,56(sp)
 31c:	f852                	sd	s4,48(sp)
 31e:	f456                	sd	s5,40(sp)
 320:	f05a                	sd	s6,32(sp)
 322:	ec5e                	sd	s7,24(sp)
 324:	1080                	addi	s0,sp,96
 326:	8baa                	mv	s7,a0
 328:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32a:	892a                	mv	s2,a0
 32c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 32e:	4aa9                	li	s5,10
 330:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 332:	89a6                	mv	s3,s1
 334:	2485                	addiw	s1,s1,1
 336:	0344d863          	bge	s1,s4,366 <gets+0x56>
    cc = read(0, &c, 1);
 33a:	4605                	li	a2,1
 33c:	faf40593          	addi	a1,s0,-81
 340:	4501                	li	a0,0
 342:	00000097          	auipc	ra,0x0
 346:	19c080e7          	jalr	412(ra) # 4de <read>
    if(cc < 1)
 34a:	00a05e63          	blez	a0,366 <gets+0x56>
    buf[i++] = c;
 34e:	faf44783          	lbu	a5,-81(s0)
 352:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 356:	01578763          	beq	a5,s5,364 <gets+0x54>
 35a:	0905                	addi	s2,s2,1
 35c:	fd679be3          	bne	a5,s6,332 <gets+0x22>
  for(i=0; i+1 < max; ){
 360:	89a6                	mv	s3,s1
 362:	a011                	j	366 <gets+0x56>
 364:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 366:	99de                	add	s3,s3,s7
 368:	00098023          	sb	zero,0(s3)
  return buf;
}
 36c:	855e                	mv	a0,s7
 36e:	60e6                	ld	ra,88(sp)
 370:	6446                	ld	s0,80(sp)
 372:	64a6                	ld	s1,72(sp)
 374:	6906                	ld	s2,64(sp)
 376:	79e2                	ld	s3,56(sp)
 378:	7a42                	ld	s4,48(sp)
 37a:	7aa2                	ld	s5,40(sp)
 37c:	7b02                	ld	s6,32(sp)
 37e:	6be2                	ld	s7,24(sp)
 380:	6125                	addi	sp,sp,96
 382:	8082                	ret

0000000000000384 <stat>:

int
stat(const char *n, struct stat *st)
{
 384:	1101                	addi	sp,sp,-32
 386:	ec06                	sd	ra,24(sp)
 388:	e822                	sd	s0,16(sp)
 38a:	e426                	sd	s1,8(sp)
 38c:	e04a                	sd	s2,0(sp)
 38e:	1000                	addi	s0,sp,32
 390:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 392:	4581                	li	a1,0
 394:	00000097          	auipc	ra,0x0
 398:	172080e7          	jalr	370(ra) # 506 <open>
  if(fd < 0)
 39c:	02054563          	bltz	a0,3c6 <stat+0x42>
 3a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a2:	85ca                	mv	a1,s2
 3a4:	00000097          	auipc	ra,0x0
 3a8:	17a080e7          	jalr	378(ra) # 51e <fstat>
 3ac:	892a                	mv	s2,a0
  close(fd);
 3ae:	8526                	mv	a0,s1
 3b0:	00000097          	auipc	ra,0x0
 3b4:	13e080e7          	jalr	318(ra) # 4ee <close>
  return r;
}
 3b8:	854a                	mv	a0,s2
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	64a2                	ld	s1,8(sp)
 3c0:	6902                	ld	s2,0(sp)
 3c2:	6105                	addi	sp,sp,32
 3c4:	8082                	ret
    return -1;
 3c6:	597d                	li	s2,-1
 3c8:	bfc5                	j	3b8 <stat+0x34>

00000000000003ca <atoi>:

int
atoi(const char *s)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e422                	sd	s0,8(sp)
 3ce:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d0:	00054603          	lbu	a2,0(a0)
 3d4:	fd06079b          	addiw	a5,a2,-48
 3d8:	0ff7f793          	andi	a5,a5,255
 3dc:	4725                	li	a4,9
 3de:	02f76963          	bltu	a4,a5,410 <atoi+0x46>
 3e2:	86aa                	mv	a3,a0
  n = 0;
 3e4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3e6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3e8:	0685                	addi	a3,a3,1
 3ea:	0025179b          	slliw	a5,a0,0x2
 3ee:	9fa9                	addw	a5,a5,a0
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	9fb1                	addw	a5,a5,a2
 3f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fa:	0006c603          	lbu	a2,0(a3)
 3fe:	fd06071b          	addiw	a4,a2,-48
 402:	0ff77713          	andi	a4,a4,255
 406:	fee5f1e3          	bgeu	a1,a4,3e8 <atoi+0x1e>
  return n;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
  n = 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <atoi+0x40>

0000000000000414 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41a:	02b57463          	bgeu	a0,a1,442 <memmove+0x2e>
    while(n-- > 0)
 41e:	00c05f63          	blez	a2,43c <memmove+0x28>
 422:	1602                	slli	a2,a2,0x20
 424:	9201                	srli	a2,a2,0x20
 426:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42a:	872a                	mv	a4,a0
      *dst++ = *src++;
 42c:	0585                	addi	a1,a1,1
 42e:	0705                	addi	a4,a4,1
 430:	fff5c683          	lbu	a3,-1(a1)
 434:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 438:	fee79ae3          	bne	a5,a4,42c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
    dst += n;
 442:	00c50733          	add	a4,a0,a2
    src += n;
 446:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 448:	fec05ae3          	blez	a2,43c <memmove+0x28>
 44c:	fff6079b          	addiw	a5,a2,-1
 450:	1782                	slli	a5,a5,0x20
 452:	9381                	srli	a5,a5,0x20
 454:	fff7c793          	not	a5,a5
 458:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45a:	15fd                	addi	a1,a1,-1
 45c:	177d                	addi	a4,a4,-1
 45e:	0005c683          	lbu	a3,0(a1)
 462:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x46>
 46a:	bfc9                	j	43c <memmove+0x28>

000000000000046c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 472:	ca05                	beqz	a2,4a2 <memcmp+0x36>
 474:	fff6069b          	addiw	a3,a2,-1
 478:	1682                	slli	a3,a3,0x20
 47a:	9281                	srli	a3,a3,0x20
 47c:	0685                	addi	a3,a3,1
 47e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 480:	00054783          	lbu	a5,0(a0)
 484:	0005c703          	lbu	a4,0(a1)
 488:	00e79863          	bne	a5,a4,498 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48c:	0505                	addi	a0,a0,1
    p2++;
 48e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 490:	fed518e3          	bne	a0,a3,480 <memcmp+0x14>
  }
  return 0;
 494:	4501                	li	a0,0
 496:	a019                	j	49c <memcmp+0x30>
      return *p1 - *p2;
 498:	40e7853b          	subw	a0,a5,a4
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <memcmp+0x30>

00000000000004a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f66080e7          	jalr	-154(ra) # 414 <memmove>
}
 4b6:	60a2                	ld	ra,8(sp)
 4b8:	6402                	ld	s0,0(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret

00000000000004be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4be:	4885                	li	a7,1
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c6:	4889                	li	a7,2
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ce:	488d                	li	a7,3
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d6:	4891                	li	a7,4
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <read>:
.global read
read:
 li a7, SYS_read
 4de:	4895                	li	a7,5
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <write>:
.global write
write:
 li a7, SYS_write
 4e6:	48c1                	li	a7,16
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <close>:
.global close
close:
 li a7, SYS_close
 4ee:	48d5                	li	a7,21
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f6:	4899                	li	a7,6
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 4fe:	489d                	li	a7,7
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <open>:
.global open
open:
 li a7, SYS_open
 506:	48bd                	li	a7,15
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 50e:	48c5                	li	a7,17
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 516:	48c9                	li	a7,18
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 51e:	48a1                	li	a7,8
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <link>:
.global link
link:
 li a7, SYS_link
 526:	48cd                	li	a7,19
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 52e:	48d1                	li	a7,20
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 536:	48a5                	li	a7,9
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <dup>:
.global dup
dup:
 li a7, SYS_dup
 53e:	48a9                	li	a7,10
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 546:	48ad                	li	a7,11
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 54e:	48b1                	li	a7,12
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 556:	48b5                	li	a7,13
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 55e:	48b9                	li	a7,14
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 566:	48d9                	li	a7,22
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56e:	1101                	addi	sp,sp,-32
 570:	ec06                	sd	ra,24(sp)
 572:	e822                	sd	s0,16(sp)
 574:	1000                	addi	s0,sp,32
 576:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57a:	4605                	li	a2,1
 57c:	fef40593          	addi	a1,s0,-17
 580:	00000097          	auipc	ra,0x0
 584:	f66080e7          	jalr	-154(ra) # 4e6 <write>
}
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	6105                	addi	sp,sp,32
 58e:	8082                	ret

0000000000000590 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	7139                	addi	sp,sp,-64
 592:	fc06                	sd	ra,56(sp)
 594:	f822                	sd	s0,48(sp)
 596:	f426                	sd	s1,40(sp)
 598:	f04a                	sd	s2,32(sp)
 59a:	ec4e                	sd	s3,24(sp)
 59c:	0080                	addi	s0,sp,64
 59e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a0:	c299                	beqz	a3,5a6 <printint+0x16>
 5a2:	0805c863          	bltz	a1,632 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a6:	2581                	sext.w	a1,a1
  neg = 0;
 5a8:	4881                	li	a7,0
 5aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b0:	2601                	sext.w	a2,a2
 5b2:	00000517          	auipc	a0,0x0
 5b6:	53650513          	addi	a0,a0,1334 # ae8 <digits>
 5ba:	883a                	mv	a6,a4
 5bc:	2705                	addiw	a4,a4,1
 5be:	02c5f7bb          	remuw	a5,a1,a2
 5c2:	1782                	slli	a5,a5,0x20
 5c4:	9381                	srli	a5,a5,0x20
 5c6:	97aa                	add	a5,a5,a0
 5c8:	0007c783          	lbu	a5,0(a5)
 5cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d0:	0005879b          	sext.w	a5,a1
 5d4:	02c5d5bb          	divuw	a1,a1,a2
 5d8:	0685                	addi	a3,a3,1
 5da:	fec7f0e3          	bgeu	a5,a2,5ba <printint+0x2a>
  if(neg)
 5de:	00088b63          	beqz	a7,5f4 <printint+0x64>
    buf[i++] = '-';
 5e2:	fd040793          	addi	a5,s0,-48
 5e6:	973e                	add	a4,a4,a5
 5e8:	02d00793          	li	a5,45
 5ec:	fef70823          	sb	a5,-16(a4)
 5f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f4:	02e05863          	blez	a4,624 <printint+0x94>
 5f8:	fc040793          	addi	a5,s0,-64
 5fc:	00e78933          	add	s2,a5,a4
 600:	fff78993          	addi	s3,a5,-1
 604:	99ba                	add	s3,s3,a4
 606:	377d                	addiw	a4,a4,-1
 608:	1702                	slli	a4,a4,0x20
 60a:	9301                	srli	a4,a4,0x20
 60c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 610:	fff94583          	lbu	a1,-1(s2)
 614:	8526                	mv	a0,s1
 616:	00000097          	auipc	ra,0x0
 61a:	f58080e7          	jalr	-168(ra) # 56e <putc>
  while(--i >= 0)
 61e:	197d                	addi	s2,s2,-1
 620:	ff3918e3          	bne	s2,s3,610 <printint+0x80>
}
 624:	70e2                	ld	ra,56(sp)
 626:	7442                	ld	s0,48(sp)
 628:	74a2                	ld	s1,40(sp)
 62a:	7902                	ld	s2,32(sp)
 62c:	69e2                	ld	s3,24(sp)
 62e:	6121                	addi	sp,sp,64
 630:	8082                	ret
    x = -xx;
 632:	40b005bb          	negw	a1,a1
    neg = 1;
 636:	4885                	li	a7,1
    x = -xx;
 638:	bf8d                	j	5aa <printint+0x1a>

000000000000063a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 63a:	7119                	addi	sp,sp,-128
 63c:	fc86                	sd	ra,120(sp)
 63e:	f8a2                	sd	s0,112(sp)
 640:	f4a6                	sd	s1,104(sp)
 642:	f0ca                	sd	s2,96(sp)
 644:	ecce                	sd	s3,88(sp)
 646:	e8d2                	sd	s4,80(sp)
 648:	e4d6                	sd	s5,72(sp)
 64a:	e0da                	sd	s6,64(sp)
 64c:	fc5e                	sd	s7,56(sp)
 64e:	f862                	sd	s8,48(sp)
 650:	f466                	sd	s9,40(sp)
 652:	f06a                	sd	s10,32(sp)
 654:	ec6e                	sd	s11,24(sp)
 656:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 658:	0005c903          	lbu	s2,0(a1)
 65c:	18090f63          	beqz	s2,7fa <vprintf+0x1c0>
 660:	8aaa                	mv	s5,a0
 662:	8b32                	mv	s6,a2
 664:	00158493          	addi	s1,a1,1
  state = 0;
 668:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 66a:	02500a13          	li	s4,37
      if(c == 'd'){
 66e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 672:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 676:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 67a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	46ab8b93          	addi	s7,s7,1130 # ae8 <digits>
 686:	a839                	j	6a4 <vprintf+0x6a>
        putc(fd, c);
 688:	85ca                	mv	a1,s2
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	ee2080e7          	jalr	-286(ra) # 56e <putc>
 694:	a019                	j	69a <vprintf+0x60>
    } else if(state == '%'){
 696:	01498f63          	beq	s3,s4,6b4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 69a:	0485                	addi	s1,s1,1
 69c:	fff4c903          	lbu	s2,-1(s1)
 6a0:	14090d63          	beqz	s2,7fa <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a8:	fe0997e3          	bnez	s3,696 <vprintf+0x5c>
      if(c == '%'){
 6ac:	fd479ee3          	bne	a5,s4,688 <vprintf+0x4e>
        state = '%';
 6b0:	89be                	mv	s3,a5
 6b2:	b7e5                	j	69a <vprintf+0x60>
      if(c == 'd'){
 6b4:	05878063          	beq	a5,s8,6f4 <vprintf+0xba>
      } else if(c == 'l') {
 6b8:	05978c63          	beq	a5,s9,710 <vprintf+0xd6>
      } else if(c == 'x') {
 6bc:	07a78863          	beq	a5,s10,72c <vprintf+0xf2>
      } else if(c == 'p') {
 6c0:	09b78463          	beq	a5,s11,748 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6c4:	07300713          	li	a4,115
 6c8:	0ce78663          	beq	a5,a4,794 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cc:	06300713          	li	a4,99
 6d0:	0ee78e63          	beq	a5,a4,7cc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6d4:	11478863          	beq	a5,s4,7e4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d8:	85d2                	mv	a1,s4
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e92080e7          	jalr	-366(ra) # 56e <putc>
        putc(fd, c);
 6e4:	85ca                	mv	a1,s2
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e86080e7          	jalr	-378(ra) # 56e <putc>
      }
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b765                	j	69a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6f4:	008b0913          	addi	s2,s6,8
 6f8:	4685                	li	a3,1
 6fa:	4629                	li	a2,10
 6fc:	000b2583          	lw	a1,0(s6)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e8e080e7          	jalr	-370(ra) # 590 <printint>
 70a:	8b4a                	mv	s6,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b771                	j	69a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 710:	008b0913          	addi	s2,s6,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000b2583          	lw	a1,0(s6)
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e72080e7          	jalr	-398(ra) # 590 <printint>
 726:	8b4a                	mv	s6,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	bf85                	j	69a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 72c:	008b0913          	addi	s2,s6,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000b2583          	lw	a1,0(s6)
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	e56080e7          	jalr	-426(ra) # 590 <printint>
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bf91                	j	69a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 748:	008b0793          	addi	a5,s6,8
 74c:	f8f43423          	sd	a5,-120(s0)
 750:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 754:	03000593          	li	a1,48
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	e14080e7          	jalr	-492(ra) # 56e <putc>
  putc(fd, 'x');
 762:	85ea                	mv	a1,s10
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e08080e7          	jalr	-504(ra) # 56e <putc>
 76e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 770:	03c9d793          	srli	a5,s3,0x3c
 774:	97de                	add	a5,a5,s7
 776:	0007c583          	lbu	a1,0(a5)
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	df2080e7          	jalr	-526(ra) # 56e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 784:	0992                	slli	s3,s3,0x4
 786:	397d                	addiw	s2,s2,-1
 788:	fe0914e3          	bnez	s2,770 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 78c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 790:	4981                	li	s3,0
 792:	b721                	j	69a <vprintf+0x60>
        s = va_arg(ap, char*);
 794:	008b0993          	addi	s3,s6,8
 798:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 79c:	02090163          	beqz	s2,7be <vprintf+0x184>
        while(*s != 0){
 7a0:	00094583          	lbu	a1,0(s2)
 7a4:	c9a1                	beqz	a1,7f4 <vprintf+0x1ba>
          putc(fd, *s);
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	dc6080e7          	jalr	-570(ra) # 56e <putc>
          s++;
 7b0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7b2:	00094583          	lbu	a1,0(s2)
 7b6:	f9e5                	bnez	a1,7a6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7b8:	8b4e                	mv	s6,s3
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bdf9                	j	69a <vprintf+0x60>
          s = "(null)";
 7be:	00000917          	auipc	s2,0x0
 7c2:	32290913          	addi	s2,s2,802 # ae0 <malloc+0x1dc>
        while(*s != 0){
 7c6:	02800593          	li	a1,40
 7ca:	bff1                	j	7a6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7cc:	008b0913          	addi	s2,s6,8
 7d0:	000b4583          	lbu	a1,0(s6)
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d98080e7          	jalr	-616(ra) # 56e <putc>
 7de:	8b4a                	mv	s6,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	bd65                	j	69a <vprintf+0x60>
        putc(fd, c);
 7e4:	85d2                	mv	a1,s4
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	d86080e7          	jalr	-634(ra) # 56e <putc>
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	b565                	j	69a <vprintf+0x60>
        s = va_arg(ap, char*);
 7f4:	8b4e                	mv	s6,s3
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b54d                	j	69a <vprintf+0x60>
    }
  }
}
 7fa:	70e6                	ld	ra,120(sp)
 7fc:	7446                	ld	s0,112(sp)
 7fe:	74a6                	ld	s1,104(sp)
 800:	7906                	ld	s2,96(sp)
 802:	69e6                	ld	s3,88(sp)
 804:	6a46                	ld	s4,80(sp)
 806:	6aa6                	ld	s5,72(sp)
 808:	6b06                	ld	s6,64(sp)
 80a:	7be2                	ld	s7,56(sp)
 80c:	7c42                	ld	s8,48(sp)
 80e:	7ca2                	ld	s9,40(sp)
 810:	7d02                	ld	s10,32(sp)
 812:	6de2                	ld	s11,24(sp)
 814:	6109                	addi	sp,sp,128
 816:	8082                	ret

0000000000000818 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 818:	715d                	addi	sp,sp,-80
 81a:	ec06                	sd	ra,24(sp)
 81c:	e822                	sd	s0,16(sp)
 81e:	1000                	addi	s0,sp,32
 820:	e010                	sd	a2,0(s0)
 822:	e414                	sd	a3,8(s0)
 824:	e818                	sd	a4,16(s0)
 826:	ec1c                	sd	a5,24(s0)
 828:	03043023          	sd	a6,32(s0)
 82c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 830:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 834:	8622                	mv	a2,s0
 836:	00000097          	auipc	ra,0x0
 83a:	e04080e7          	jalr	-508(ra) # 63a <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <printf>:

void
printf(const char *fmt, ...)
{
 846:	711d                	addi	sp,sp,-96
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e40c                	sd	a1,8(s0)
 850:	e810                	sd	a2,16(s0)
 852:	ec14                	sd	a3,24(s0)
 854:	f018                	sd	a4,32(s0)
 856:	f41c                	sd	a5,40(s0)
 858:	03043823          	sd	a6,48(s0)
 85c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	00840613          	addi	a2,s0,8
 864:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 868:	85aa                	mv	a1,a0
 86a:	4505                	li	a0,1
 86c:	00000097          	auipc	ra,0x0
 870:	dce080e7          	jalr	-562(ra) # 63a <vprintf>
}
 874:	60e2                	ld	ra,24(sp)
 876:	6442                	ld	s0,16(sp)
 878:	6125                	addi	sp,sp,96
 87a:	8082                	ret

000000000000087c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87c:	1141                	addi	sp,sp,-16
 87e:	e422                	sd	s0,8(sp)
 880:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 882:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	00000797          	auipc	a5,0x0
 88a:	27a7b783          	ld	a5,634(a5) # b00 <freep>
 88e:	a805                	j	8be <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 890:	4618                	lw	a4,8(a2)
 892:	9db9                	addw	a1,a1,a4
 894:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	6318                	ld	a4,0(a4)
 89c:	fee53823          	sd	a4,-16(a0)
 8a0:	a091                	j	8e4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9e39                	addw	a2,a2,a4
 8a8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053703          	ld	a4,-16(a0)
 8ae:	e398                	sd	a4,0(a5)
 8b0:	a099                	j	8f6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	6398                	ld	a4,0(a5)
 8b4:	00e7e463          	bltu	a5,a4,8bc <free+0x40>
 8b8:	00e6ea63          	bltu	a3,a4,8cc <free+0x50>
{
 8bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8be:	fed7fae3          	bgeu	a5,a3,8b2 <free+0x36>
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e6e463          	bltu	a3,a4,8cc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	fee7eae3          	bltu	a5,a4,8bc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8cc:	ff852583          	lw	a1,-8(a0)
 8d0:	6390                	ld	a2,0(a5)
 8d2:	02059813          	slli	a6,a1,0x20
 8d6:	01c85713          	srli	a4,a6,0x1c
 8da:	9736                	add	a4,a4,a3
 8dc:	fae60ae3          	beq	a2,a4,890 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8e4:	4790                	lw	a2,8(a5)
 8e6:	02061593          	slli	a1,a2,0x20
 8ea:	01c5d713          	srli	a4,a1,0x1c
 8ee:	973e                	add	a4,a4,a5
 8f0:	fae689e3          	beq	a3,a4,8a2 <free+0x26>
  } else
    p->s.ptr = bp;
 8f4:	e394                	sd	a3,0(a5)
  freep = p;
 8f6:	00000717          	auipc	a4,0x0
 8fa:	20f73523          	sd	a5,522(a4) # b00 <freep>
}
 8fe:	6422                	ld	s0,8(sp)
 900:	0141                	addi	sp,sp,16
 902:	8082                	ret

0000000000000904 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 904:	7139                	addi	sp,sp,-64
 906:	fc06                	sd	ra,56(sp)
 908:	f822                	sd	s0,48(sp)
 90a:	f426                	sd	s1,40(sp)
 90c:	f04a                	sd	s2,32(sp)
 90e:	ec4e                	sd	s3,24(sp)
 910:	e852                	sd	s4,16(sp)
 912:	e456                	sd	s5,8(sp)
 914:	e05a                	sd	s6,0(sp)
 916:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 918:	02051493          	slli	s1,a0,0x20
 91c:	9081                	srli	s1,s1,0x20
 91e:	04bd                	addi	s1,s1,15
 920:	8091                	srli	s1,s1,0x4
 922:	0014899b          	addiw	s3,s1,1
 926:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 928:	00000517          	auipc	a0,0x0
 92c:	1d853503          	ld	a0,472(a0) # b00 <freep>
 930:	c515                	beqz	a0,95c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 934:	4798                	lw	a4,8(a5)
 936:	02977f63          	bgeu	a4,s1,974 <malloc+0x70>
 93a:	8a4e                	mv	s4,s3
 93c:	0009871b          	sext.w	a4,s3
 940:	6685                	lui	a3,0x1
 942:	00d77363          	bgeu	a4,a3,948 <malloc+0x44>
 946:	6a05                	lui	s4,0x1
 948:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 950:	00000917          	auipc	s2,0x0
 954:	1b090913          	addi	s2,s2,432 # b00 <freep>
  if(p == (char*)-1)
 958:	5afd                	li	s5,-1
 95a:	a895                	j	9ce <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 95c:	00000797          	auipc	a5,0x0
 960:	1ac78793          	addi	a5,a5,428 # b08 <base>
 964:	00000717          	auipc	a4,0x0
 968:	18f73e23          	sd	a5,412(a4) # b00 <freep>
 96c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 972:	b7e1                	j	93a <malloc+0x36>
      if(p->s.size == nunits)
 974:	02e48c63          	beq	s1,a4,9ac <malloc+0xa8>
        p->s.size -= nunits;
 978:	4137073b          	subw	a4,a4,s3
 97c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97e:	02071693          	slli	a3,a4,0x20
 982:	01c6d713          	srli	a4,a3,0x1c
 986:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 988:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98c:	00000717          	auipc	a4,0x0
 990:	16a73a23          	sd	a0,372(a4) # b00 <freep>
      return (void*)(p + 1);
 994:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 998:	70e2                	ld	ra,56(sp)
 99a:	7442                	ld	s0,48(sp)
 99c:	74a2                	ld	s1,40(sp)
 99e:	7902                	ld	s2,32(sp)
 9a0:	69e2                	ld	s3,24(sp)
 9a2:	6a42                	ld	s4,16(sp)
 9a4:	6aa2                	ld	s5,8(sp)
 9a6:	6b02                	ld	s6,0(sp)
 9a8:	6121                	addi	sp,sp,64
 9aa:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ac:	6398                	ld	a4,0(a5)
 9ae:	e118                	sd	a4,0(a0)
 9b0:	bff1                	j	98c <malloc+0x88>
  hp->s.size = nu;
 9b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b6:	0541                	addi	a0,a0,16
 9b8:	00000097          	auipc	ra,0x0
 9bc:	ec4080e7          	jalr	-316(ra) # 87c <free>
  return freep;
 9c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c4:	d971                	beqz	a0,998 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c8:	4798                	lw	a4,8(a5)
 9ca:	fa9775e3          	bgeu	a4,s1,974 <malloc+0x70>
    if(p == freep)
 9ce:	00093703          	ld	a4,0(s2)
 9d2:	853e                	mv	a0,a5
 9d4:	fef719e3          	bne	a4,a5,9c6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9d8:	8552                	mv	a0,s4
 9da:	00000097          	auipc	ra,0x0
 9de:	b74080e7          	jalr	-1164(ra) # 54e <sbrk>
  if(p == (char*)-1)
 9e2:	fd5518e3          	bne	a0,s5,9b2 <malloc+0xae>
        return 0;
 9e6:	4501                	li	a0,0
 9e8:	bf45                	j	998 <malloc+0x94>
