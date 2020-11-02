
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
  2c:	7b050513          	addi	a0,a0,1968 # 7d8 <malloc+0xea>
  30:	00000097          	auipc	ra,0x0
  34:	600080e7          	jalr	1536(ra) # 630 <printf>
  exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	276080e7          	jalr	630(ra) # 2b0 <exit>

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
 130:	19c080e7          	jalr	412(ra) # 2c8 <read>
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
 182:	172080e7          	jalr	370(ra) # 2f0 <open>
  if(fd < 0)
 186:	02054563          	bltz	a0,1b0 <stat+0x42>
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	00000097          	auipc	ra,0x0
 192:	17a080e7          	jalr	378(ra) # 308 <fstat>
 196:	892a                	mv	s2,a0
  close(fd);
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	13e080e7          	jalr	318(ra) # 2d8 <close>
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
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while(n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 350:	48d9                	li	a7,22
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 358:	1101                	addi	sp,sp,-32
 35a:	ec06                	sd	ra,24(sp)
 35c:	e822                	sd	s0,16(sp)
 35e:	1000                	addi	s0,sp,32
 360:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 364:	4605                	li	a2,1
 366:	fef40593          	addi	a1,s0,-17
 36a:	00000097          	auipc	ra,0x0
 36e:	f66080e7          	jalr	-154(ra) # 2d0 <write>
}
 372:	60e2                	ld	ra,24(sp)
 374:	6442                	ld	s0,16(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret

000000000000037a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37a:	7139                	addi	sp,sp,-64
 37c:	fc06                	sd	ra,56(sp)
 37e:	f822                	sd	s0,48(sp)
 380:	f426                	sd	s1,40(sp)
 382:	f04a                	sd	s2,32(sp)
 384:	ec4e                	sd	s3,24(sp)
 386:	0080                	addi	s0,sp,64
 388:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38a:	c299                	beqz	a3,390 <printint+0x16>
 38c:	0805c863          	bltz	a1,41c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 390:	2581                	sext.w	a1,a1
  neg = 0;
 392:	4881                	li	a7,0
 394:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 398:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39a:	2601                	sext.w	a2,a2
 39c:	00000517          	auipc	a0,0x0
 3a0:	44c50513          	addi	a0,a0,1100 # 7e8 <digits>
 3a4:	883a                	mv	a6,a4
 3a6:	2705                	addiw	a4,a4,1
 3a8:	02c5f7bb          	remuw	a5,a1,a2
 3ac:	1782                	slli	a5,a5,0x20
 3ae:	9381                	srli	a5,a5,0x20
 3b0:	97aa                	add	a5,a5,a0
 3b2:	0007c783          	lbu	a5,0(a5)
 3b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ba:	0005879b          	sext.w	a5,a1
 3be:	02c5d5bb          	divuw	a1,a1,a2
 3c2:	0685                	addi	a3,a3,1
 3c4:	fec7f0e3          	bgeu	a5,a2,3a4 <printint+0x2a>
  if(neg)
 3c8:	00088b63          	beqz	a7,3de <printint+0x64>
    buf[i++] = '-';
 3cc:	fd040793          	addi	a5,s0,-48
 3d0:	973e                	add	a4,a4,a5
 3d2:	02d00793          	li	a5,45
 3d6:	fef70823          	sb	a5,-16(a4)
 3da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3de:	02e05863          	blez	a4,40e <printint+0x94>
 3e2:	fc040793          	addi	a5,s0,-64
 3e6:	00e78933          	add	s2,a5,a4
 3ea:	fff78993          	addi	s3,a5,-1
 3ee:	99ba                	add	s3,s3,a4
 3f0:	377d                	addiw	a4,a4,-1
 3f2:	1702                	slli	a4,a4,0x20
 3f4:	9301                	srli	a4,a4,0x20
 3f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3fa:	fff94583          	lbu	a1,-1(s2)
 3fe:	8526                	mv	a0,s1
 400:	00000097          	auipc	ra,0x0
 404:	f58080e7          	jalr	-168(ra) # 358 <putc>
  while(--i >= 0)
 408:	197d                	addi	s2,s2,-1
 40a:	ff3918e3          	bne	s2,s3,3fa <printint+0x80>
}
 40e:	70e2                	ld	ra,56(sp)
 410:	7442                	ld	s0,48(sp)
 412:	74a2                	ld	s1,40(sp)
 414:	7902                	ld	s2,32(sp)
 416:	69e2                	ld	s3,24(sp)
 418:	6121                	addi	sp,sp,64
 41a:	8082                	ret
    x = -xx;
 41c:	40b005bb          	negw	a1,a1
    neg = 1;
 420:	4885                	li	a7,1
    x = -xx;
 422:	bf8d                	j	394 <printint+0x1a>

0000000000000424 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 424:	7119                	addi	sp,sp,-128
 426:	fc86                	sd	ra,120(sp)
 428:	f8a2                	sd	s0,112(sp)
 42a:	f4a6                	sd	s1,104(sp)
 42c:	f0ca                	sd	s2,96(sp)
 42e:	ecce                	sd	s3,88(sp)
 430:	e8d2                	sd	s4,80(sp)
 432:	e4d6                	sd	s5,72(sp)
 434:	e0da                	sd	s6,64(sp)
 436:	fc5e                	sd	s7,56(sp)
 438:	f862                	sd	s8,48(sp)
 43a:	f466                	sd	s9,40(sp)
 43c:	f06a                	sd	s10,32(sp)
 43e:	ec6e                	sd	s11,24(sp)
 440:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 442:	0005c903          	lbu	s2,0(a1)
 446:	18090f63          	beqz	s2,5e4 <vprintf+0x1c0>
 44a:	8aaa                	mv	s5,a0
 44c:	8b32                	mv	s6,a2
 44e:	00158493          	addi	s1,a1,1
  state = 0;
 452:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 454:	02500a13          	li	s4,37
      if(c == 'd'){
 458:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 45c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 460:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 464:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 468:	00000b97          	auipc	s7,0x0
 46c:	380b8b93          	addi	s7,s7,896 # 7e8 <digits>
 470:	a839                	j	48e <vprintf+0x6a>
        putc(fd, c);
 472:	85ca                	mv	a1,s2
 474:	8556                	mv	a0,s5
 476:	00000097          	auipc	ra,0x0
 47a:	ee2080e7          	jalr	-286(ra) # 358 <putc>
 47e:	a019                	j	484 <vprintf+0x60>
    } else if(state == '%'){
 480:	01498f63          	beq	s3,s4,49e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 484:	0485                	addi	s1,s1,1
 486:	fff4c903          	lbu	s2,-1(s1)
 48a:	14090d63          	beqz	s2,5e4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 48e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 492:	fe0997e3          	bnez	s3,480 <vprintf+0x5c>
      if(c == '%'){
 496:	fd479ee3          	bne	a5,s4,472 <vprintf+0x4e>
        state = '%';
 49a:	89be                	mv	s3,a5
 49c:	b7e5                	j	484 <vprintf+0x60>
      if(c == 'd'){
 49e:	05878063          	beq	a5,s8,4de <vprintf+0xba>
      } else if(c == 'l') {
 4a2:	05978c63          	beq	a5,s9,4fa <vprintf+0xd6>
      } else if(c == 'x') {
 4a6:	07a78863          	beq	a5,s10,516 <vprintf+0xf2>
      } else if(c == 'p') {
 4aa:	09b78463          	beq	a5,s11,532 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4ae:	07300713          	li	a4,115
 4b2:	0ce78663          	beq	a5,a4,57e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b6:	06300713          	li	a4,99
 4ba:	0ee78e63          	beq	a5,a4,5b6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4be:	11478863          	beq	a5,s4,5ce <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4c2:	85d2                	mv	a1,s4
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	e92080e7          	jalr	-366(ra) # 358 <putc>
        putc(fd, c);
 4ce:	85ca                	mv	a1,s2
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	e86080e7          	jalr	-378(ra) # 358 <putc>
      }
      state = 0;
 4da:	4981                	li	s3,0
 4dc:	b765                	j	484 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4de:	008b0913          	addi	s2,s6,8
 4e2:	4685                	li	a3,1
 4e4:	4629                	li	a2,10
 4e6:	000b2583          	lw	a1,0(s6)
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	e8e080e7          	jalr	-370(ra) # 37a <printint>
 4f4:	8b4a                	mv	s6,s2
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	b771                	j	484 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4fa:	008b0913          	addi	s2,s6,8
 4fe:	4681                	li	a3,0
 500:	4629                	li	a2,10
 502:	000b2583          	lw	a1,0(s6)
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	e72080e7          	jalr	-398(ra) # 37a <printint>
 510:	8b4a                	mv	s6,s2
      state = 0;
 512:	4981                	li	s3,0
 514:	bf85                	j	484 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 516:	008b0913          	addi	s2,s6,8
 51a:	4681                	li	a3,0
 51c:	4641                	li	a2,16
 51e:	000b2583          	lw	a1,0(s6)
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	e56080e7          	jalr	-426(ra) # 37a <printint>
 52c:	8b4a                	mv	s6,s2
      state = 0;
 52e:	4981                	li	s3,0
 530:	bf91                	j	484 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 532:	008b0793          	addi	a5,s6,8
 536:	f8f43423          	sd	a5,-120(s0)
 53a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 53e:	03000593          	li	a1,48
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e14080e7          	jalr	-492(ra) # 358 <putc>
  putc(fd, 'x');
 54c:	85ea                	mv	a1,s10
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e08080e7          	jalr	-504(ra) # 358 <putc>
 558:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55a:	03c9d793          	srli	a5,s3,0x3c
 55e:	97de                	add	a5,a5,s7
 560:	0007c583          	lbu	a1,0(a5)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	df2080e7          	jalr	-526(ra) # 358 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56e:	0992                	slli	s3,s3,0x4
 570:	397d                	addiw	s2,s2,-1
 572:	fe0914e3          	bnez	s2,55a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 576:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b721                	j	484 <vprintf+0x60>
        s = va_arg(ap, char*);
 57e:	008b0993          	addi	s3,s6,8
 582:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 586:	02090163          	beqz	s2,5a8 <vprintf+0x184>
        while(*s != 0){
 58a:	00094583          	lbu	a1,0(s2)
 58e:	c9a1                	beqz	a1,5de <vprintf+0x1ba>
          putc(fd, *s);
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	dc6080e7          	jalr	-570(ra) # 358 <putc>
          s++;
 59a:	0905                	addi	s2,s2,1
        while(*s != 0){
 59c:	00094583          	lbu	a1,0(s2)
 5a0:	f9e5                	bnez	a1,590 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5a2:	8b4e                	mv	s6,s3
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bdf9                	j	484 <vprintf+0x60>
          s = "(null)";
 5a8:	00000917          	auipc	s2,0x0
 5ac:	23890913          	addi	s2,s2,568 # 7e0 <malloc+0xf2>
        while(*s != 0){
 5b0:	02800593          	li	a1,40
 5b4:	bff1                	j	590 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5b6:	008b0913          	addi	s2,s6,8
 5ba:	000b4583          	lbu	a1,0(s6)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	d98080e7          	jalr	-616(ra) # 358 <putc>
 5c8:	8b4a                	mv	s6,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bd65                	j	484 <vprintf+0x60>
        putc(fd, c);
 5ce:	85d2                	mv	a1,s4
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	d86080e7          	jalr	-634(ra) # 358 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b565                	j	484 <vprintf+0x60>
        s = va_arg(ap, char*);
 5de:	8b4e                	mv	s6,s3
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b54d                	j	484 <vprintf+0x60>
    }
  }
}
 5e4:	70e6                	ld	ra,120(sp)
 5e6:	7446                	ld	s0,112(sp)
 5e8:	74a6                	ld	s1,104(sp)
 5ea:	7906                	ld	s2,96(sp)
 5ec:	69e6                	ld	s3,88(sp)
 5ee:	6a46                	ld	s4,80(sp)
 5f0:	6aa6                	ld	s5,72(sp)
 5f2:	6b06                	ld	s6,64(sp)
 5f4:	7be2                	ld	s7,56(sp)
 5f6:	7c42                	ld	s8,48(sp)
 5f8:	7ca2                	ld	s9,40(sp)
 5fa:	7d02                	ld	s10,32(sp)
 5fc:	6de2                	ld	s11,24(sp)
 5fe:	6109                	addi	sp,sp,128
 600:	8082                	ret

0000000000000602 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 602:	715d                	addi	sp,sp,-80
 604:	ec06                	sd	ra,24(sp)
 606:	e822                	sd	s0,16(sp)
 608:	1000                	addi	s0,sp,32
 60a:	e010                	sd	a2,0(s0)
 60c:	e414                	sd	a3,8(s0)
 60e:	e818                	sd	a4,16(s0)
 610:	ec1c                	sd	a5,24(s0)
 612:	03043023          	sd	a6,32(s0)
 616:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 61a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 61e:	8622                	mv	a2,s0
 620:	00000097          	auipc	ra,0x0
 624:	e04080e7          	jalr	-508(ra) # 424 <vprintf>
}
 628:	60e2                	ld	ra,24(sp)
 62a:	6442                	ld	s0,16(sp)
 62c:	6161                	addi	sp,sp,80
 62e:	8082                	ret

0000000000000630 <printf>:

void
printf(const char *fmt, ...)
{
 630:	711d                	addi	sp,sp,-96
 632:	ec06                	sd	ra,24(sp)
 634:	e822                	sd	s0,16(sp)
 636:	1000                	addi	s0,sp,32
 638:	e40c                	sd	a1,8(s0)
 63a:	e810                	sd	a2,16(s0)
 63c:	ec14                	sd	a3,24(s0)
 63e:	f018                	sd	a4,32(s0)
 640:	f41c                	sd	a5,40(s0)
 642:	03043823          	sd	a6,48(s0)
 646:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 64a:	00840613          	addi	a2,s0,8
 64e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 652:	85aa                	mv	a1,a0
 654:	4505                	li	a0,1
 656:	00000097          	auipc	ra,0x0
 65a:	dce080e7          	jalr	-562(ra) # 424 <vprintf>
}
 65e:	60e2                	ld	ra,24(sp)
 660:	6442                	ld	s0,16(sp)
 662:	6125                	addi	sp,sp,96
 664:	8082                	ret

0000000000000666 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	1141                	addi	sp,sp,-16
 668:	e422                	sd	s0,8(sp)
 66a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 670:	00000797          	auipc	a5,0x0
 674:	1907b783          	ld	a5,400(a5) # 800 <freep>
 678:	a805                	j	6a8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 67a:	4618                	lw	a4,8(a2)
 67c:	9db9                	addw	a1,a1,a4
 67e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 682:	6398                	ld	a4,0(a5)
 684:	6318                	ld	a4,0(a4)
 686:	fee53823          	sd	a4,-16(a0)
 68a:	a091                	j	6ce <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 68c:	ff852703          	lw	a4,-8(a0)
 690:	9e39                	addw	a2,a2,a4
 692:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 694:	ff053703          	ld	a4,-16(a0)
 698:	e398                	sd	a4,0(a5)
 69a:	a099                	j	6e0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	6398                	ld	a4,0(a5)
 69e:	00e7e463          	bltu	a5,a4,6a6 <free+0x40>
 6a2:	00e6ea63          	bltu	a3,a4,6b6 <free+0x50>
{
 6a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a8:	fed7fae3          	bgeu	a5,a3,69c <free+0x36>
 6ac:	6398                	ld	a4,0(a5)
 6ae:	00e6e463          	bltu	a3,a4,6b6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	fee7eae3          	bltu	a5,a4,6a6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6b6:	ff852583          	lw	a1,-8(a0)
 6ba:	6390                	ld	a2,0(a5)
 6bc:	02059813          	slli	a6,a1,0x20
 6c0:	01c85713          	srli	a4,a6,0x1c
 6c4:	9736                	add	a4,a4,a3
 6c6:	fae60ae3          	beq	a2,a4,67a <free+0x14>
    bp->s.ptr = p->s.ptr;
 6ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ce:	4790                	lw	a2,8(a5)
 6d0:	02061593          	slli	a1,a2,0x20
 6d4:	01c5d713          	srli	a4,a1,0x1c
 6d8:	973e                	add	a4,a4,a5
 6da:	fae689e3          	beq	a3,a4,68c <free+0x26>
  } else
    p->s.ptr = bp;
 6de:	e394                	sd	a3,0(a5)
  freep = p;
 6e0:	00000717          	auipc	a4,0x0
 6e4:	12f73023          	sd	a5,288(a4) # 800 <freep>
}
 6e8:	6422                	ld	s0,8(sp)
 6ea:	0141                	addi	sp,sp,16
 6ec:	8082                	ret

00000000000006ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ee:	7139                	addi	sp,sp,-64
 6f0:	fc06                	sd	ra,56(sp)
 6f2:	f822                	sd	s0,48(sp)
 6f4:	f426                	sd	s1,40(sp)
 6f6:	f04a                	sd	s2,32(sp)
 6f8:	ec4e                	sd	s3,24(sp)
 6fa:	e852                	sd	s4,16(sp)
 6fc:	e456                	sd	s5,8(sp)
 6fe:	e05a                	sd	s6,0(sp)
 700:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	02051493          	slli	s1,a0,0x20
 706:	9081                	srli	s1,s1,0x20
 708:	04bd                	addi	s1,s1,15
 70a:	8091                	srli	s1,s1,0x4
 70c:	0014899b          	addiw	s3,s1,1
 710:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 712:	00000517          	auipc	a0,0x0
 716:	0ee53503          	ld	a0,238(a0) # 800 <freep>
 71a:	c515                	beqz	a0,746 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 71e:	4798                	lw	a4,8(a5)
 720:	02977f63          	bgeu	a4,s1,75e <malloc+0x70>
 724:	8a4e                	mv	s4,s3
 726:	0009871b          	sext.w	a4,s3
 72a:	6685                	lui	a3,0x1
 72c:	00d77363          	bgeu	a4,a3,732 <malloc+0x44>
 730:	6a05                	lui	s4,0x1
 732:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 736:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73a:	00000917          	auipc	s2,0x0
 73e:	0c690913          	addi	s2,s2,198 # 800 <freep>
  if(p == (char*)-1)
 742:	5afd                	li	s5,-1
 744:	a895                	j	7b8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 746:	00000797          	auipc	a5,0x0
 74a:	0c278793          	addi	a5,a5,194 # 808 <base>
 74e:	00000717          	auipc	a4,0x0
 752:	0af73923          	sd	a5,178(a4) # 800 <freep>
 756:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 758:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 75c:	b7e1                	j	724 <malloc+0x36>
      if(p->s.size == nunits)
 75e:	02e48c63          	beq	s1,a4,796 <malloc+0xa8>
        p->s.size -= nunits;
 762:	4137073b          	subw	a4,a4,s3
 766:	c798                	sw	a4,8(a5)
        p += p->s.size;
 768:	02071693          	slli	a3,a4,0x20
 76c:	01c6d713          	srli	a4,a3,0x1c
 770:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 772:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 776:	00000717          	auipc	a4,0x0
 77a:	08a73523          	sd	a0,138(a4) # 800 <freep>
      return (void*)(p + 1);
 77e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 782:	70e2                	ld	ra,56(sp)
 784:	7442                	ld	s0,48(sp)
 786:	74a2                	ld	s1,40(sp)
 788:	7902                	ld	s2,32(sp)
 78a:	69e2                	ld	s3,24(sp)
 78c:	6a42                	ld	s4,16(sp)
 78e:	6aa2                	ld	s5,8(sp)
 790:	6b02                	ld	s6,0(sp)
 792:	6121                	addi	sp,sp,64
 794:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 796:	6398                	ld	a4,0(a5)
 798:	e118                	sd	a4,0(a0)
 79a:	bff1                	j	776 <malloc+0x88>
  hp->s.size = nu;
 79c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a0:	0541                	addi	a0,a0,16
 7a2:	00000097          	auipc	ra,0x0
 7a6:	ec4080e7          	jalr	-316(ra) # 666 <free>
  return freep;
 7aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ae:	d971                	beqz	a0,782 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b2:	4798                	lw	a4,8(a5)
 7b4:	fa9775e3          	bgeu	a4,s1,75e <malloc+0x70>
    if(p == freep)
 7b8:	00093703          	ld	a4,0(s2)
 7bc:	853e                	mv	a0,a5
 7be:	fef719e3          	bne	a4,a5,7b0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7c2:	8552                	mv	a0,s4
 7c4:	00000097          	auipc	ra,0x0
 7c8:	b74080e7          	jalr	-1164(ra) # 338 <sbrk>
  if(p == (char*)-1)
 7cc:	fd5518e3          	bne	a0,s5,79c <malloc+0xae>
        return 0;
 7d0:	4501                	li	a0,0
 7d2:	bf45                	j	782 <malloc+0x94>
