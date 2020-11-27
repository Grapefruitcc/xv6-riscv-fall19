
user/_call:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <g>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  return x+3;
}
   6:	250d                	addiw	a0,a0,3
   8:	6422                	ld	s0,8(sp)
   a:	0141                	addi	sp,sp,16
   c:	8082                	ret

000000000000000e <f>:

int f(int x) {
   e:	1141                	addi	sp,sp,-16
  10:	e422                	sd	s0,8(sp)
  12:	0800                	addi	s0,sp,16
  return g(x);
}
  14:	250d                	addiw	a0,a0,3
  16:	6422                	ld	s0,8(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <main>:

void main(void) {
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  printf("%d %d\n", f(8)+1, 13);
  24:	4635                	li	a2,13
  26:	45b1                	li	a1,12
  28:	00000517          	auipc	a0,0x0
  2c:	74850513          	addi	a0,a0,1864 # 770 <malloc+0xea>
  30:	00000097          	auipc	ra,0x0
  34:	598080e7          	jalr	1432(ra) # 5c8 <printf>
  exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	1f6080e7          	jalr	502(ra) # 230 <exit>

0000000000000042 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  42:	1141                	addi	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	addi	a1,a1,1
  4c:	0785                	addi	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	addi	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	addi	a0,a0,1
  74:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	addi	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	4685                	li	a3,1
  9c:	9e89                	subw	a3,a3,a0
  9e:	00f6853b          	addw	a0,a3,a5
  a2:	0785                	addi	a5,a5,1
  a4:	fff7c703          	lbu	a4,-1(a5)
  a8:	fb7d                	bnez	a4,9e <strlen+0x14>
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ca19                	beqz	a2,d0 <memset+0x1c>
  bc:	87aa                	mv	a5,a0
  be:	1602                	slli	a2,a2,0x20
  c0:	9201                	srli	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ca:	0785                	addi	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x12>
  }
  return dst;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strchr>:

char*
strchr(const char *s, char c)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cb99                	beqz	a5,f6 <strchr+0x20>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1a>
  for(; *s; s++)
  e6:	0505                	addi	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xc>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfe5                	j	f0 <strchr+0x1a>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	addi	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	1080                	addi	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 118:	4aa9                	li	s5,10
 11a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11c:	89a6                	mv	s3,s1
 11e:	2485                	addiw	s1,s1,1
 120:	0344d863          	bge	s1,s4,150 <gets+0x56>
    cc = read(0, &c, 1);
 124:	4605                	li	a2,1
 126:	faf40593          	addi	a1,s0,-81
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	11c080e7          	jalr	284(ra) # 248 <read>
    if(cc < 1)
 134:	00a05e63          	blez	a0,150 <gets+0x56>
    buf[i++] = c;
 138:	faf44783          	lbu	a5,-81(s0)
 13c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 140:	01578763          	beq	a5,s5,14e <gets+0x54>
 144:	0905                	addi	s2,s2,1
 146:	fd679be3          	bne	a5,s6,11c <gets+0x22>
  for(i=0; i+1 < max; ){
 14a:	89a6                	mv	s3,s1
 14c:	a011                	j	150 <gets+0x56>
 14e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 150:	99de                	add	s3,s3,s7
 152:	00098023          	sb	zero,0(s3)
  return buf;
}
 156:	855e                	mv	a0,s7
 158:	60e6                	ld	ra,88(sp)
 15a:	6446                	ld	s0,80(sp)
 15c:	64a6                	ld	s1,72(sp)
 15e:	6906                	ld	s2,64(sp)
 160:	79e2                	ld	s3,56(sp)
 162:	7a42                	ld	s4,48(sp)
 164:	7aa2                	ld	s5,40(sp)
 166:	7b02                	ld	s6,32(sp)
 168:	6be2                	ld	s7,24(sp)
 16a:	6125                	addi	sp,sp,96
 16c:	8082                	ret

000000000000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	1101                	addi	sp,sp,-32
 170:	ec06                	sd	ra,24(sp)
 172:	e822                	sd	s0,16(sp)
 174:	e426                	sd	s1,8(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	0f2080e7          	jalr	242(ra) # 270 <open>
  if(fd < 0)
 186:	02054563          	bltz	a0,1b0 <stat+0x42>
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	00000097          	auipc	ra,0x0
 192:	0fa080e7          	jalr	250(ra) # 288 <fstat>
 196:	892a                	mv	s2,a0
  close(fd);
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	0be080e7          	jalr	190(ra) # 258 <close>
  return r;
}
 1a2:	854a                	mv	a0,s2
 1a4:	60e2                	ld	ra,24(sp)
 1a6:	6442                	ld	s0,16(sp)
 1a8:	64a2                	ld	s1,8(sp)
 1aa:	6902                	ld	s2,0(sp)
 1ac:	6105                	addi	sp,sp,32
 1ae:	8082                	ret
    return -1;
 1b0:	597d                	li	s2,-1
 1b2:	bfc5                	j	1a2 <stat+0x34>

00000000000001b4 <atoi>:

int
atoi(const char *s)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ba:	00054603          	lbu	a2,0(a0)
 1be:	fd06079b          	addiw	a5,a2,-48
 1c2:	0ff7f793          	andi	a5,a5,255
 1c6:	4725                	li	a4,9
 1c8:	02f76963          	bltu	a4,a5,1fa <atoi+0x46>
 1cc:	86aa                	mv	a3,a0
  n = 0;
 1ce:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1d0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1d2:	0685                	addi	a3,a3,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb1                	addw	a5,a5,a2
 1e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	0006c603          	lbu	a2,0(a3)
 1e8:	fd06071b          	addiw	a4,a2,-48
 1ec:	0ff77713          	andi	a4,a4,255
 1f0:	fee5f1e3          	bgeu	a1,a4,1d2 <atoi+0x1e>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x40>

00000000000001fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 204:	00c05f63          	blez	a2,222 <memmove+0x24>
 208:	1602                	slli	a2,a2,0x20
 20a:	9201                	srli	a2,a2,0x20
 20c:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 210:	87aa                	mv	a5,a0
    *dst++ = *src++;
 212:	0585                	addi	a1,a1,1
 214:	0785                	addi	a5,a5,1
 216:	fff5c703          	lbu	a4,-1(a1)
 21a:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 21e:	fed79ae3          	bne	a5,a3,212 <memmove+0x14>
  return vdst;
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret

0000000000000228 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 228:	4885                	li	a7,1
 ecall
 22a:	00000073          	ecall
 ret
 22e:	8082                	ret

0000000000000230 <exit>:
.global exit
exit:
 li a7, SYS_exit
 230:	4889                	li	a7,2
 ecall
 232:	00000073          	ecall
 ret
 236:	8082                	ret

0000000000000238 <wait>:
.global wait
wait:
 li a7, SYS_wait
 238:	488d                	li	a7,3
 ecall
 23a:	00000073          	ecall
 ret
 23e:	8082                	ret

0000000000000240 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 240:	4891                	li	a7,4
 ecall
 242:	00000073          	ecall
 ret
 246:	8082                	ret

0000000000000248 <read>:
.global read
read:
 li a7, SYS_read
 248:	4895                	li	a7,5
 ecall
 24a:	00000073          	ecall
 ret
 24e:	8082                	ret

0000000000000250 <write>:
.global write
write:
 li a7, SYS_write
 250:	48c1                	li	a7,16
 ecall
 252:	00000073          	ecall
 ret
 256:	8082                	ret

0000000000000258 <close>:
.global close
close:
 li a7, SYS_close
 258:	48d5                	li	a7,21
 ecall
 25a:	00000073          	ecall
 ret
 25e:	8082                	ret

0000000000000260 <kill>:
.global kill
kill:
 li a7, SYS_kill
 260:	4899                	li	a7,6
 ecall
 262:	00000073          	ecall
 ret
 266:	8082                	ret

0000000000000268 <exec>:
.global exec
exec:
 li a7, SYS_exec
 268:	489d                	li	a7,7
 ecall
 26a:	00000073          	ecall
 ret
 26e:	8082                	ret

0000000000000270 <open>:
.global open
open:
 li a7, SYS_open
 270:	48bd                	li	a7,15
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 278:	48c5                	li	a7,17
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 280:	48c9                	li	a7,18
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 288:	48a1                	li	a7,8
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <link>:
.global link
link:
 li a7, SYS_link
 290:	48cd                	li	a7,19
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 298:	48d1                	li	a7,20
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2a0:	48a5                	li	a7,9
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2a8:	48a9                	li	a7,10
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2b0:	48ad                	li	a7,11
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2b8:	48b1                	li	a7,12
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2c0:	48b5                	li	a7,13
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2c8:	48b9                	li	a7,14
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2d0:	48d9                	li	a7,22
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <crash>:
.global crash
crash:
 li a7, SYS_crash
 2d8:	48dd                	li	a7,23
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <mount>:
.global mount
mount:
 li a7, SYS_mount
 2e0:	48e1                	li	a7,24
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <umount>:
.global umount
umount:
 li a7, SYS_umount
 2e8:	48e5                	li	a7,25
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2f0:	1101                	addi	sp,sp,-32
 2f2:	ec06                	sd	ra,24(sp)
 2f4:	e822                	sd	s0,16(sp)
 2f6:	1000                	addi	s0,sp,32
 2f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 2fc:	4605                	li	a2,1
 2fe:	fef40593          	addi	a1,s0,-17
 302:	00000097          	auipc	ra,0x0
 306:	f4e080e7          	jalr	-178(ra) # 250 <write>
}
 30a:	60e2                	ld	ra,24(sp)
 30c:	6442                	ld	s0,16(sp)
 30e:	6105                	addi	sp,sp,32
 310:	8082                	ret

0000000000000312 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 312:	7139                	addi	sp,sp,-64
 314:	fc06                	sd	ra,56(sp)
 316:	f822                	sd	s0,48(sp)
 318:	f426                	sd	s1,40(sp)
 31a:	f04a                	sd	s2,32(sp)
 31c:	ec4e                	sd	s3,24(sp)
 31e:	0080                	addi	s0,sp,64
 320:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 322:	c299                	beqz	a3,328 <printint+0x16>
 324:	0805c863          	bltz	a1,3b4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 328:	2581                	sext.w	a1,a1
  neg = 0;
 32a:	4881                	li	a7,0
 32c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 330:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 332:	2601                	sext.w	a2,a2
 334:	00000517          	auipc	a0,0x0
 338:	44c50513          	addi	a0,a0,1100 # 780 <digits>
 33c:	883a                	mv	a6,a4
 33e:	2705                	addiw	a4,a4,1
 340:	02c5f7bb          	remuw	a5,a1,a2
 344:	1782                	slli	a5,a5,0x20
 346:	9381                	srli	a5,a5,0x20
 348:	97aa                	add	a5,a5,a0
 34a:	0007c783          	lbu	a5,0(a5)
 34e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 352:	0005879b          	sext.w	a5,a1
 356:	02c5d5bb          	divuw	a1,a1,a2
 35a:	0685                	addi	a3,a3,1
 35c:	fec7f0e3          	bgeu	a5,a2,33c <printint+0x2a>
  if(neg)
 360:	00088b63          	beqz	a7,376 <printint+0x64>
    buf[i++] = '-';
 364:	fd040793          	addi	a5,s0,-48
 368:	973e                	add	a4,a4,a5
 36a:	02d00793          	li	a5,45
 36e:	fef70823          	sb	a5,-16(a4)
 372:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 376:	02e05863          	blez	a4,3a6 <printint+0x94>
 37a:	fc040793          	addi	a5,s0,-64
 37e:	00e78933          	add	s2,a5,a4
 382:	fff78993          	addi	s3,a5,-1
 386:	99ba                	add	s3,s3,a4
 388:	377d                	addiw	a4,a4,-1
 38a:	1702                	slli	a4,a4,0x20
 38c:	9301                	srli	a4,a4,0x20
 38e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 392:	fff94583          	lbu	a1,-1(s2)
 396:	8526                	mv	a0,s1
 398:	00000097          	auipc	ra,0x0
 39c:	f58080e7          	jalr	-168(ra) # 2f0 <putc>
  while(--i >= 0)
 3a0:	197d                	addi	s2,s2,-1
 3a2:	ff3918e3          	bne	s2,s3,392 <printint+0x80>
}
 3a6:	70e2                	ld	ra,56(sp)
 3a8:	7442                	ld	s0,48(sp)
 3aa:	74a2                	ld	s1,40(sp)
 3ac:	7902                	ld	s2,32(sp)
 3ae:	69e2                	ld	s3,24(sp)
 3b0:	6121                	addi	sp,sp,64
 3b2:	8082                	ret
    x = -xx;
 3b4:	40b005bb          	negw	a1,a1
    neg = 1;
 3b8:	4885                	li	a7,1
    x = -xx;
 3ba:	bf8d                	j	32c <printint+0x1a>

00000000000003bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3bc:	7119                	addi	sp,sp,-128
 3be:	fc86                	sd	ra,120(sp)
 3c0:	f8a2                	sd	s0,112(sp)
 3c2:	f4a6                	sd	s1,104(sp)
 3c4:	f0ca                	sd	s2,96(sp)
 3c6:	ecce                	sd	s3,88(sp)
 3c8:	e8d2                	sd	s4,80(sp)
 3ca:	e4d6                	sd	s5,72(sp)
 3cc:	e0da                	sd	s6,64(sp)
 3ce:	fc5e                	sd	s7,56(sp)
 3d0:	f862                	sd	s8,48(sp)
 3d2:	f466                	sd	s9,40(sp)
 3d4:	f06a                	sd	s10,32(sp)
 3d6:	ec6e                	sd	s11,24(sp)
 3d8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3da:	0005c903          	lbu	s2,0(a1)
 3de:	18090f63          	beqz	s2,57c <vprintf+0x1c0>
 3e2:	8aaa                	mv	s5,a0
 3e4:	8b32                	mv	s6,a2
 3e6:	00158493          	addi	s1,a1,1
  state = 0;
 3ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3ec:	02500a13          	li	s4,37
      if(c == 'd'){
 3f0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3f4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 3f8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 3fc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 400:	00000b97          	auipc	s7,0x0
 404:	380b8b93          	addi	s7,s7,896 # 780 <digits>
 408:	a839                	j	426 <vprintf+0x6a>
        putc(fd, c);
 40a:	85ca                	mv	a1,s2
 40c:	8556                	mv	a0,s5
 40e:	00000097          	auipc	ra,0x0
 412:	ee2080e7          	jalr	-286(ra) # 2f0 <putc>
 416:	a019                	j	41c <vprintf+0x60>
    } else if(state == '%'){
 418:	01498f63          	beq	s3,s4,436 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 41c:	0485                	addi	s1,s1,1
 41e:	fff4c903          	lbu	s2,-1(s1)
 422:	14090d63          	beqz	s2,57c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 426:	0009079b          	sext.w	a5,s2
    if(state == 0){
 42a:	fe0997e3          	bnez	s3,418 <vprintf+0x5c>
      if(c == '%'){
 42e:	fd479ee3          	bne	a5,s4,40a <vprintf+0x4e>
        state = '%';
 432:	89be                	mv	s3,a5
 434:	b7e5                	j	41c <vprintf+0x60>
      if(c == 'd'){
 436:	05878063          	beq	a5,s8,476 <vprintf+0xba>
      } else if(c == 'l') {
 43a:	05978c63          	beq	a5,s9,492 <vprintf+0xd6>
      } else if(c == 'x') {
 43e:	07a78863          	beq	a5,s10,4ae <vprintf+0xf2>
      } else if(c == 'p') {
 442:	09b78463          	beq	a5,s11,4ca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 446:	07300713          	li	a4,115
 44a:	0ce78663          	beq	a5,a4,516 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 44e:	06300713          	li	a4,99
 452:	0ee78e63          	beq	a5,a4,54e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 456:	11478863          	beq	a5,s4,566 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 45a:	85d2                	mv	a1,s4
 45c:	8556                	mv	a0,s5
 45e:	00000097          	auipc	ra,0x0
 462:	e92080e7          	jalr	-366(ra) # 2f0 <putc>
        putc(fd, c);
 466:	85ca                	mv	a1,s2
 468:	8556                	mv	a0,s5
 46a:	00000097          	auipc	ra,0x0
 46e:	e86080e7          	jalr	-378(ra) # 2f0 <putc>
      }
      state = 0;
 472:	4981                	li	s3,0
 474:	b765                	j	41c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 476:	008b0913          	addi	s2,s6,8
 47a:	4685                	li	a3,1
 47c:	4629                	li	a2,10
 47e:	000b2583          	lw	a1,0(s6)
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	e8e080e7          	jalr	-370(ra) # 312 <printint>
 48c:	8b4a                	mv	s6,s2
      state = 0;
 48e:	4981                	li	s3,0
 490:	b771                	j	41c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 492:	008b0913          	addi	s2,s6,8
 496:	4681                	li	a3,0
 498:	4629                	li	a2,10
 49a:	000b2583          	lw	a1,0(s6)
 49e:	8556                	mv	a0,s5
 4a0:	00000097          	auipc	ra,0x0
 4a4:	e72080e7          	jalr	-398(ra) # 312 <printint>
 4a8:	8b4a                	mv	s6,s2
      state = 0;
 4aa:	4981                	li	s3,0
 4ac:	bf85                	j	41c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4ae:	008b0913          	addi	s2,s6,8
 4b2:	4681                	li	a3,0
 4b4:	4641                	li	a2,16
 4b6:	000b2583          	lw	a1,0(s6)
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	e56080e7          	jalr	-426(ra) # 312 <printint>
 4c4:	8b4a                	mv	s6,s2
      state = 0;
 4c6:	4981                	li	s3,0
 4c8:	bf91                	j	41c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4ca:	008b0793          	addi	a5,s6,8
 4ce:	f8f43423          	sd	a5,-120(s0)
 4d2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4d6:	03000593          	li	a1,48
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	e14080e7          	jalr	-492(ra) # 2f0 <putc>
  putc(fd, 'x');
 4e4:	85ea                	mv	a1,s10
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	e08080e7          	jalr	-504(ra) # 2f0 <putc>
 4f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f2:	03c9d793          	srli	a5,s3,0x3c
 4f6:	97de                	add	a5,a5,s7
 4f8:	0007c583          	lbu	a1,0(a5)
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	df2080e7          	jalr	-526(ra) # 2f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 506:	0992                	slli	s3,s3,0x4
 508:	397d                	addiw	s2,s2,-1
 50a:	fe0914e3          	bnez	s2,4f2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 50e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 512:	4981                	li	s3,0
 514:	b721                	j	41c <vprintf+0x60>
        s = va_arg(ap, char*);
 516:	008b0993          	addi	s3,s6,8
 51a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 51e:	02090163          	beqz	s2,540 <vprintf+0x184>
        while(*s != 0){
 522:	00094583          	lbu	a1,0(s2)
 526:	c9a1                	beqz	a1,576 <vprintf+0x1ba>
          putc(fd, *s);
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	dc6080e7          	jalr	-570(ra) # 2f0 <putc>
          s++;
 532:	0905                	addi	s2,s2,1
        while(*s != 0){
 534:	00094583          	lbu	a1,0(s2)
 538:	f9e5                	bnez	a1,528 <vprintf+0x16c>
        s = va_arg(ap, char*);
 53a:	8b4e                	mv	s6,s3
      state = 0;
 53c:	4981                	li	s3,0
 53e:	bdf9                	j	41c <vprintf+0x60>
          s = "(null)";
 540:	00000917          	auipc	s2,0x0
 544:	23890913          	addi	s2,s2,568 # 778 <malloc+0xf2>
        while(*s != 0){
 548:	02800593          	li	a1,40
 54c:	bff1                	j	528 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 54e:	008b0913          	addi	s2,s6,8
 552:	000b4583          	lbu	a1,0(s6)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	d98080e7          	jalr	-616(ra) # 2f0 <putc>
 560:	8b4a                	mv	s6,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	bd65                	j	41c <vprintf+0x60>
        putc(fd, c);
 566:	85d2                	mv	a1,s4
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	d86080e7          	jalr	-634(ra) # 2f0 <putc>
      state = 0;
 572:	4981                	li	s3,0
 574:	b565                	j	41c <vprintf+0x60>
        s = va_arg(ap, char*);
 576:	8b4e                	mv	s6,s3
      state = 0;
 578:	4981                	li	s3,0
 57a:	b54d                	j	41c <vprintf+0x60>
    }
  }
}
 57c:	70e6                	ld	ra,120(sp)
 57e:	7446                	ld	s0,112(sp)
 580:	74a6                	ld	s1,104(sp)
 582:	7906                	ld	s2,96(sp)
 584:	69e6                	ld	s3,88(sp)
 586:	6a46                	ld	s4,80(sp)
 588:	6aa6                	ld	s5,72(sp)
 58a:	6b06                	ld	s6,64(sp)
 58c:	7be2                	ld	s7,56(sp)
 58e:	7c42                	ld	s8,48(sp)
 590:	7ca2                	ld	s9,40(sp)
 592:	7d02                	ld	s10,32(sp)
 594:	6de2                	ld	s11,24(sp)
 596:	6109                	addi	sp,sp,128
 598:	8082                	ret

000000000000059a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 59a:	715d                	addi	sp,sp,-80
 59c:	ec06                	sd	ra,24(sp)
 59e:	e822                	sd	s0,16(sp)
 5a0:	1000                	addi	s0,sp,32
 5a2:	e010                	sd	a2,0(s0)
 5a4:	e414                	sd	a3,8(s0)
 5a6:	e818                	sd	a4,16(s0)
 5a8:	ec1c                	sd	a5,24(s0)
 5aa:	03043023          	sd	a6,32(s0)
 5ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5b6:	8622                	mv	a2,s0
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e04080e7          	jalr	-508(ra) # 3bc <vprintf>
}
 5c0:	60e2                	ld	ra,24(sp)
 5c2:	6442                	ld	s0,16(sp)
 5c4:	6161                	addi	sp,sp,80
 5c6:	8082                	ret

00000000000005c8 <printf>:

void
printf(const char *fmt, ...)
{
 5c8:	711d                	addi	sp,sp,-96
 5ca:	ec06                	sd	ra,24(sp)
 5cc:	e822                	sd	s0,16(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	e40c                	sd	a1,8(s0)
 5d2:	e810                	sd	a2,16(s0)
 5d4:	ec14                	sd	a3,24(s0)
 5d6:	f018                	sd	a4,32(s0)
 5d8:	f41c                	sd	a5,40(s0)
 5da:	03043823          	sd	a6,48(s0)
 5de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5e2:	00840613          	addi	a2,s0,8
 5e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5ea:	85aa                	mv	a1,a0
 5ec:	4505                	li	a0,1
 5ee:	00000097          	auipc	ra,0x0
 5f2:	dce080e7          	jalr	-562(ra) # 3bc <vprintf>
}
 5f6:	60e2                	ld	ra,24(sp)
 5f8:	6442                	ld	s0,16(sp)
 5fa:	6125                	addi	sp,sp,96
 5fc:	8082                	ret

00000000000005fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fe:	1141                	addi	sp,sp,-16
 600:	e422                	sd	s0,8(sp)
 602:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 604:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 608:	00000797          	auipc	a5,0x0
 60c:	1907b783          	ld	a5,400(a5) # 798 <freep>
 610:	a805                	j	640 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 612:	4618                	lw	a4,8(a2)
 614:	9db9                	addw	a1,a1,a4
 616:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 61a:	6398                	ld	a4,0(a5)
 61c:	6318                	ld	a4,0(a4)
 61e:	fee53823          	sd	a4,-16(a0)
 622:	a091                	j	666 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 624:	ff852703          	lw	a4,-8(a0)
 628:	9e39                	addw	a2,a2,a4
 62a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 62c:	ff053703          	ld	a4,-16(a0)
 630:	e398                	sd	a4,0(a5)
 632:	a099                	j	678 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	6398                	ld	a4,0(a5)
 636:	00e7e463          	bltu	a5,a4,63e <free+0x40>
 63a:	00e6ea63          	bltu	a3,a4,64e <free+0x50>
{
 63e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 640:	fed7fae3          	bgeu	a5,a3,634 <free+0x36>
 644:	6398                	ld	a4,0(a5)
 646:	00e6e463          	bltu	a3,a4,64e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64a:	fee7eae3          	bltu	a5,a4,63e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 64e:	ff852583          	lw	a1,-8(a0)
 652:	6390                	ld	a2,0(a5)
 654:	02059813          	slli	a6,a1,0x20
 658:	01c85713          	srli	a4,a6,0x1c
 65c:	9736                	add	a4,a4,a3
 65e:	fae60ae3          	beq	a2,a4,612 <free+0x14>
    bp->s.ptr = p->s.ptr;
 662:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 666:	4790                	lw	a2,8(a5)
 668:	02061593          	slli	a1,a2,0x20
 66c:	01c5d713          	srli	a4,a1,0x1c
 670:	973e                	add	a4,a4,a5
 672:	fae689e3          	beq	a3,a4,624 <free+0x26>
  } else
    p->s.ptr = bp;
 676:	e394                	sd	a3,0(a5)
  freep = p;
 678:	00000717          	auipc	a4,0x0
 67c:	12f73023          	sd	a5,288(a4) # 798 <freep>
}
 680:	6422                	ld	s0,8(sp)
 682:	0141                	addi	sp,sp,16
 684:	8082                	ret

0000000000000686 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 686:	7139                	addi	sp,sp,-64
 688:	fc06                	sd	ra,56(sp)
 68a:	f822                	sd	s0,48(sp)
 68c:	f426                	sd	s1,40(sp)
 68e:	f04a                	sd	s2,32(sp)
 690:	ec4e                	sd	s3,24(sp)
 692:	e852                	sd	s4,16(sp)
 694:	e456                	sd	s5,8(sp)
 696:	e05a                	sd	s6,0(sp)
 698:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 69a:	02051493          	slli	s1,a0,0x20
 69e:	9081                	srli	s1,s1,0x20
 6a0:	04bd                	addi	s1,s1,15
 6a2:	8091                	srli	s1,s1,0x4
 6a4:	0014899b          	addiw	s3,s1,1
 6a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6aa:	00000517          	auipc	a0,0x0
 6ae:	0ee53503          	ld	a0,238(a0) # 798 <freep>
 6b2:	c515                	beqz	a0,6de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6b6:	4798                	lw	a4,8(a5)
 6b8:	02977f63          	bgeu	a4,s1,6f6 <malloc+0x70>
 6bc:	8a4e                	mv	s4,s3
 6be:	0009871b          	sext.w	a4,s3
 6c2:	6685                	lui	a3,0x1
 6c4:	00d77363          	bgeu	a4,a3,6ca <malloc+0x44>
 6c8:	6a05                	lui	s4,0x1
 6ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d2:	00000917          	auipc	s2,0x0
 6d6:	0c690913          	addi	s2,s2,198 # 798 <freep>
  if(p == (char*)-1)
 6da:	5afd                	li	s5,-1
 6dc:	a895                	j	750 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 6de:	00000797          	auipc	a5,0x0
 6e2:	0c278793          	addi	a5,a5,194 # 7a0 <base>
 6e6:	00000717          	auipc	a4,0x0
 6ea:	0af73923          	sd	a5,178(a4) # 798 <freep>
 6ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6f4:	b7e1                	j	6bc <malloc+0x36>
      if(p->s.size == nunits)
 6f6:	02e48c63          	beq	s1,a4,72e <malloc+0xa8>
        p->s.size -= nunits;
 6fa:	4137073b          	subw	a4,a4,s3
 6fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 700:	02071693          	slli	a3,a4,0x20
 704:	01c6d713          	srli	a4,a3,0x1c
 708:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 70a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 70e:	00000717          	auipc	a4,0x0
 712:	08a73523          	sd	a0,138(a4) # 798 <freep>
      return (void*)(p + 1);
 716:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 71a:	70e2                	ld	ra,56(sp)
 71c:	7442                	ld	s0,48(sp)
 71e:	74a2                	ld	s1,40(sp)
 720:	7902                	ld	s2,32(sp)
 722:	69e2                	ld	s3,24(sp)
 724:	6a42                	ld	s4,16(sp)
 726:	6aa2                	ld	s5,8(sp)
 728:	6b02                	ld	s6,0(sp)
 72a:	6121                	addi	sp,sp,64
 72c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 72e:	6398                	ld	a4,0(a5)
 730:	e118                	sd	a4,0(a0)
 732:	bff1                	j	70e <malloc+0x88>
  hp->s.size = nu;
 734:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 738:	0541                	addi	a0,a0,16
 73a:	00000097          	auipc	ra,0x0
 73e:	ec4080e7          	jalr	-316(ra) # 5fe <free>
  return freep;
 742:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 746:	d971                	beqz	a0,71a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 748:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74a:	4798                	lw	a4,8(a5)
 74c:	fa9775e3          	bgeu	a4,s1,6f6 <malloc+0x70>
    if(p == freep)
 750:	00093703          	ld	a4,0(s2)
 754:	853e                	mv	a0,a5
 756:	fef719e3          	bne	a4,a5,748 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 75a:	8552                	mv	a0,s4
 75c:	00000097          	auipc	ra,0x0
 760:	b5c080e7          	jalr	-1188(ra) # 2b8 <sbrk>
  if(p == (char*)-1)
 764:	fd5518e3          	bne	a0,s5,734 <malloc+0xae>
        return 0;
 768:	4501                	li	a0,0
 76a:	bf45                	j	71a <malloc+0x94>
