
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  if(argc != 3){
   a:	478d                	li	a5,3
   c:	02f50063          	beq	a0,a5,2c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
  10:	00000597          	auipc	a1,0x0
  14:	78058593          	addi	a1,a1,1920 # 790 <malloc+0xec>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	59e080e7          	jalr	1438(ra) # 5b8 <fprintf>
    exit(-1);
  22:	557d                	li	a0,-1
  24:	00000097          	auipc	ra,0x0
  28:	22a080e7          	jalr	554(ra) # 24e <exit>
  2c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  2e:	698c                	ld	a1,16(a1)
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	27c080e7          	jalr	636(ra) # 2ae <link>
  3a:	00054763          	bltz	a0,48 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	20e080e7          	jalr	526(ra) # 24e <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	6894                	ld	a3,16(s1)
  4a:	6490                	ld	a2,8(s1)
  4c:	00000597          	auipc	a1,0x0
  50:	75c58593          	addi	a1,a1,1884 # 7a8 <malloc+0x104>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	562080e7          	jalr	1378(ra) # 5b8 <fprintf>
  5e:	b7c5                	j	3e <main+0x3e>

0000000000000060 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	addi	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	4685                	li	a3,1
  ba:	9e89                	subw	a3,a3,a0
  bc:	00f6853b          	addw	a0,a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	fb7d                	bnez	a4,bc <strlen+0x14>
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	slli	a2,a2,0x20
  de:	9201                	srli	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	addi	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	addi	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	addi	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addiw	s1,s1,1
 13e:	0344d863          	bge	s1,s4,16e <gets+0x56>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	addi	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	00000097          	auipc	ra,0x0
 14e:	11c080e7          	jalr	284(ra) # 266 <read>
    if(cc < 1)
 152:	00a05e63          	blez	a0,16e <gets+0x56>
    buf[i++] = c;
 156:	faf44783          	lbu	a5,-81(s0)
 15a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15e:	01578763          	beq	a5,s5,16c <gets+0x54>
 162:	0905                	addi	s2,s2,1
 164:	fd679be3          	bne	a5,s6,13a <gets+0x22>
  for(i=0; i+1 < max; ){
 168:	89a6                	mv	s3,s1
 16a:	a011                	j	16e <gets+0x56>
 16c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16e:	99de                	add	s3,s3,s7
 170:	00098023          	sb	zero,0(s3)
  return buf;
}
 174:	855e                	mv	a0,s7
 176:	60e6                	ld	ra,88(sp)
 178:	6446                	ld	s0,80(sp)
 17a:	64a6                	ld	s1,72(sp)
 17c:	6906                	ld	s2,64(sp)
 17e:	79e2                	ld	s3,56(sp)
 180:	7a42                	ld	s4,48(sp)
 182:	7aa2                	ld	s5,40(sp)
 184:	7b02                	ld	s6,32(sp)
 186:	6be2                	ld	s7,24(sp)
 188:	6125                	addi	sp,sp,96
 18a:	8082                	ret

000000000000018c <stat>:

int
stat(const char *n, struct stat *st)
{
 18c:	1101                	addi	sp,sp,-32
 18e:	ec06                	sd	ra,24(sp)
 190:	e822                	sd	s0,16(sp)
 192:	e426                	sd	s1,8(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	0f2080e7          	jalr	242(ra) # 28e <open>
  if(fd < 0)
 1a4:	02054563          	bltz	a0,1ce <stat+0x42>
 1a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1aa:	85ca                	mv	a1,s2
 1ac:	00000097          	auipc	ra,0x0
 1b0:	0fa080e7          	jalr	250(ra) # 2a6 <fstat>
 1b4:	892a                	mv	s2,a0
  close(fd);
 1b6:	8526                	mv	a0,s1
 1b8:	00000097          	auipc	ra,0x0
 1bc:	0be080e7          	jalr	190(ra) # 276 <close>
  return r;
}
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	64a2                	ld	s1,8(sp)
 1c8:	6902                	ld	s2,0(sp)
 1ca:	6105                	addi	sp,sp,32
 1cc:	8082                	ret
    return -1;
 1ce:	597d                	li	s2,-1
 1d0:	bfc5                	j	1c0 <stat+0x34>

00000000000001d2 <atoi>:

int
atoi(const char *s)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	00054603          	lbu	a2,0(a0)
 1dc:	fd06079b          	addiw	a5,a2,-48
 1e0:	0ff7f793          	andi	a5,a5,255
 1e4:	4725                	li	a4,9
 1e6:	02f76963          	bltu	a4,a5,218 <atoi+0x46>
 1ea:	86aa                	mv	a3,a0
  n = 0;
 1ec:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ee:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f0:	0685                	addi	a3,a3,1
 1f2:	0025179b          	slliw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	slliw	a5,a5,0x1
 1fc:	9fb1                	addw	a5,a5,a2
 1fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 202:	0006c603          	lbu	a2,0(a3)
 206:	fd06071b          	addiw	a4,a2,-48
 20a:	0ff77713          	andi	a4,a4,255
 20e:	fee5f1e3          	bgeu	a1,a4,1f0 <atoi+0x1e>
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <atoi+0x40>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 222:	00c05f63          	blez	a2,240 <memmove+0x24>
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 22e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 230:	0585                	addi	a1,a1,1
 232:	0785                	addi	a5,a5,1
 234:	fff5c703          	lbu	a4,-1(a1)
 238:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 23c:	fed79ae3          	bne	a5,a3,230 <memmove+0x14>
  return vdst;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret

0000000000000246 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 246:	4885                	li	a7,1
 ecall
 248:	00000073          	ecall
 ret
 24c:	8082                	ret

000000000000024e <exit>:
.global exit
exit:
 li a7, SYS_exit
 24e:	4889                	li	a7,2
 ecall
 250:	00000073          	ecall
 ret
 254:	8082                	ret

0000000000000256 <wait>:
.global wait
wait:
 li a7, SYS_wait
 256:	488d                	li	a7,3
 ecall
 258:	00000073          	ecall
 ret
 25c:	8082                	ret

000000000000025e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 25e:	4891                	li	a7,4
 ecall
 260:	00000073          	ecall
 ret
 264:	8082                	ret

0000000000000266 <read>:
.global read
read:
 li a7, SYS_read
 266:	4895                	li	a7,5
 ecall
 268:	00000073          	ecall
 ret
 26c:	8082                	ret

000000000000026e <write>:
.global write
write:
 li a7, SYS_write
 26e:	48c1                	li	a7,16
 ecall
 270:	00000073          	ecall
 ret
 274:	8082                	ret

0000000000000276 <close>:
.global close
close:
 li a7, SYS_close
 276:	48d5                	li	a7,21
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <kill>:
.global kill
kill:
 li a7, SYS_kill
 27e:	4899                	li	a7,6
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <exec>:
.global exec
exec:
 li a7, SYS_exec
 286:	489d                	li	a7,7
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <open>:
.global open
open:
 li a7, SYS_open
 28e:	48bd                	li	a7,15
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 296:	48c5                	li	a7,17
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 29e:	48c9                	li	a7,18
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2a6:	48a1                	li	a7,8
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <link>:
.global link
link:
 li a7, SYS_link
 2ae:	48cd                	li	a7,19
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2b6:	48d1                	li	a7,20
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2be:	48a5                	li	a7,9
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2c6:	48a9                	li	a7,10
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2ce:	48ad                	li	a7,11
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2d6:	48b1                	li	a7,12
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2de:	48b5                	li	a7,13
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2e6:	48b9                	li	a7,14
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 2ee:	48d9                	li	a7,22
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <crash>:
.global crash
crash:
 li a7, SYS_crash
 2f6:	48dd                	li	a7,23
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <mount>:
.global mount
mount:
 li a7, SYS_mount
 2fe:	48e1                	li	a7,24
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <umount>:
.global umount
umount:
 li a7, SYS_umount
 306:	48e5                	li	a7,25
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 30e:	1101                	addi	sp,sp,-32
 310:	ec06                	sd	ra,24(sp)
 312:	e822                	sd	s0,16(sp)
 314:	1000                	addi	s0,sp,32
 316:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 31a:	4605                	li	a2,1
 31c:	fef40593          	addi	a1,s0,-17
 320:	00000097          	auipc	ra,0x0
 324:	f4e080e7          	jalr	-178(ra) # 26e <write>
}
 328:	60e2                	ld	ra,24(sp)
 32a:	6442                	ld	s0,16(sp)
 32c:	6105                	addi	sp,sp,32
 32e:	8082                	ret

0000000000000330 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 330:	7139                	addi	sp,sp,-64
 332:	fc06                	sd	ra,56(sp)
 334:	f822                	sd	s0,48(sp)
 336:	f426                	sd	s1,40(sp)
 338:	f04a                	sd	s2,32(sp)
 33a:	ec4e                	sd	s3,24(sp)
 33c:	0080                	addi	s0,sp,64
 33e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 340:	c299                	beqz	a3,346 <printint+0x16>
 342:	0805c863          	bltz	a1,3d2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 346:	2581                	sext.w	a1,a1
  neg = 0;
 348:	4881                	li	a7,0
 34a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 34e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 350:	2601                	sext.w	a2,a2
 352:	00000517          	auipc	a0,0x0
 356:	47650513          	addi	a0,a0,1142 # 7c8 <digits>
 35a:	883a                	mv	a6,a4
 35c:	2705                	addiw	a4,a4,1
 35e:	02c5f7bb          	remuw	a5,a1,a2
 362:	1782                	slli	a5,a5,0x20
 364:	9381                	srli	a5,a5,0x20
 366:	97aa                	add	a5,a5,a0
 368:	0007c783          	lbu	a5,0(a5)
 36c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 370:	0005879b          	sext.w	a5,a1
 374:	02c5d5bb          	divuw	a1,a1,a2
 378:	0685                	addi	a3,a3,1
 37a:	fec7f0e3          	bgeu	a5,a2,35a <printint+0x2a>
  if(neg)
 37e:	00088b63          	beqz	a7,394 <printint+0x64>
    buf[i++] = '-';
 382:	fd040793          	addi	a5,s0,-48
 386:	973e                	add	a4,a4,a5
 388:	02d00793          	li	a5,45
 38c:	fef70823          	sb	a5,-16(a4)
 390:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 394:	02e05863          	blez	a4,3c4 <printint+0x94>
 398:	fc040793          	addi	a5,s0,-64
 39c:	00e78933          	add	s2,a5,a4
 3a0:	fff78993          	addi	s3,a5,-1
 3a4:	99ba                	add	s3,s3,a4
 3a6:	377d                	addiw	a4,a4,-1
 3a8:	1702                	slli	a4,a4,0x20
 3aa:	9301                	srli	a4,a4,0x20
 3ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3b0:	fff94583          	lbu	a1,-1(s2)
 3b4:	8526                	mv	a0,s1
 3b6:	00000097          	auipc	ra,0x0
 3ba:	f58080e7          	jalr	-168(ra) # 30e <putc>
  while(--i >= 0)
 3be:	197d                	addi	s2,s2,-1
 3c0:	ff3918e3          	bne	s2,s3,3b0 <printint+0x80>
}
 3c4:	70e2                	ld	ra,56(sp)
 3c6:	7442                	ld	s0,48(sp)
 3c8:	74a2                	ld	s1,40(sp)
 3ca:	7902                	ld	s2,32(sp)
 3cc:	69e2                	ld	s3,24(sp)
 3ce:	6121                	addi	sp,sp,64
 3d0:	8082                	ret
    x = -xx;
 3d2:	40b005bb          	negw	a1,a1
    neg = 1;
 3d6:	4885                	li	a7,1
    x = -xx;
 3d8:	bf8d                	j	34a <printint+0x1a>

00000000000003da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3da:	7119                	addi	sp,sp,-128
 3dc:	fc86                	sd	ra,120(sp)
 3de:	f8a2                	sd	s0,112(sp)
 3e0:	f4a6                	sd	s1,104(sp)
 3e2:	f0ca                	sd	s2,96(sp)
 3e4:	ecce                	sd	s3,88(sp)
 3e6:	e8d2                	sd	s4,80(sp)
 3e8:	e4d6                	sd	s5,72(sp)
 3ea:	e0da                	sd	s6,64(sp)
 3ec:	fc5e                	sd	s7,56(sp)
 3ee:	f862                	sd	s8,48(sp)
 3f0:	f466                	sd	s9,40(sp)
 3f2:	f06a                	sd	s10,32(sp)
 3f4:	ec6e                	sd	s11,24(sp)
 3f6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3f8:	0005c903          	lbu	s2,0(a1)
 3fc:	18090f63          	beqz	s2,59a <vprintf+0x1c0>
 400:	8aaa                	mv	s5,a0
 402:	8b32                	mv	s6,a2
 404:	00158493          	addi	s1,a1,1
  state = 0;
 408:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 40a:	02500a13          	li	s4,37
      if(c == 'd'){
 40e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 412:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 416:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 41a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 41e:	00000b97          	auipc	s7,0x0
 422:	3aab8b93          	addi	s7,s7,938 # 7c8 <digits>
 426:	a839                	j	444 <vprintf+0x6a>
        putc(fd, c);
 428:	85ca                	mv	a1,s2
 42a:	8556                	mv	a0,s5
 42c:	00000097          	auipc	ra,0x0
 430:	ee2080e7          	jalr	-286(ra) # 30e <putc>
 434:	a019                	j	43a <vprintf+0x60>
    } else if(state == '%'){
 436:	01498f63          	beq	s3,s4,454 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 43a:	0485                	addi	s1,s1,1
 43c:	fff4c903          	lbu	s2,-1(s1)
 440:	14090d63          	beqz	s2,59a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 444:	0009079b          	sext.w	a5,s2
    if(state == 0){
 448:	fe0997e3          	bnez	s3,436 <vprintf+0x5c>
      if(c == '%'){
 44c:	fd479ee3          	bne	a5,s4,428 <vprintf+0x4e>
        state = '%';
 450:	89be                	mv	s3,a5
 452:	b7e5                	j	43a <vprintf+0x60>
      if(c == 'd'){
 454:	05878063          	beq	a5,s8,494 <vprintf+0xba>
      } else if(c == 'l') {
 458:	05978c63          	beq	a5,s9,4b0 <vprintf+0xd6>
      } else if(c == 'x') {
 45c:	07a78863          	beq	a5,s10,4cc <vprintf+0xf2>
      } else if(c == 'p') {
 460:	09b78463          	beq	a5,s11,4e8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 464:	07300713          	li	a4,115
 468:	0ce78663          	beq	a5,a4,534 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 46c:	06300713          	li	a4,99
 470:	0ee78e63          	beq	a5,a4,56c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 474:	11478863          	beq	a5,s4,584 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 478:	85d2                	mv	a1,s4
 47a:	8556                	mv	a0,s5
 47c:	00000097          	auipc	ra,0x0
 480:	e92080e7          	jalr	-366(ra) # 30e <putc>
        putc(fd, c);
 484:	85ca                	mv	a1,s2
 486:	8556                	mv	a0,s5
 488:	00000097          	auipc	ra,0x0
 48c:	e86080e7          	jalr	-378(ra) # 30e <putc>
      }
      state = 0;
 490:	4981                	li	s3,0
 492:	b765                	j	43a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 494:	008b0913          	addi	s2,s6,8
 498:	4685                	li	a3,1
 49a:	4629                	li	a2,10
 49c:	000b2583          	lw	a1,0(s6)
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	e8e080e7          	jalr	-370(ra) # 330 <printint>
 4aa:	8b4a                	mv	s6,s2
      state = 0;
 4ac:	4981                	li	s3,0
 4ae:	b771                	j	43a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b0:	008b0913          	addi	s2,s6,8
 4b4:	4681                	li	a3,0
 4b6:	4629                	li	a2,10
 4b8:	000b2583          	lw	a1,0(s6)
 4bc:	8556                	mv	a0,s5
 4be:	00000097          	auipc	ra,0x0
 4c2:	e72080e7          	jalr	-398(ra) # 330 <printint>
 4c6:	8b4a                	mv	s6,s2
      state = 0;
 4c8:	4981                	li	s3,0
 4ca:	bf85                	j	43a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4cc:	008b0913          	addi	s2,s6,8
 4d0:	4681                	li	a3,0
 4d2:	4641                	li	a2,16
 4d4:	000b2583          	lw	a1,0(s6)
 4d8:	8556                	mv	a0,s5
 4da:	00000097          	auipc	ra,0x0
 4de:	e56080e7          	jalr	-426(ra) # 330 <printint>
 4e2:	8b4a                	mv	s6,s2
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	bf91                	j	43a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4e8:	008b0793          	addi	a5,s6,8
 4ec:	f8f43423          	sd	a5,-120(s0)
 4f0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4f4:	03000593          	li	a1,48
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	e14080e7          	jalr	-492(ra) # 30e <putc>
  putc(fd, 'x');
 502:	85ea                	mv	a1,s10
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	e08080e7          	jalr	-504(ra) # 30e <putc>
 50e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 510:	03c9d793          	srli	a5,s3,0x3c
 514:	97de                	add	a5,a5,s7
 516:	0007c583          	lbu	a1,0(a5)
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	df2080e7          	jalr	-526(ra) # 30e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 524:	0992                	slli	s3,s3,0x4
 526:	397d                	addiw	s2,s2,-1
 528:	fe0914e3          	bnez	s2,510 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 52c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 530:	4981                	li	s3,0
 532:	b721                	j	43a <vprintf+0x60>
        s = va_arg(ap, char*);
 534:	008b0993          	addi	s3,s6,8
 538:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 53c:	02090163          	beqz	s2,55e <vprintf+0x184>
        while(*s != 0){
 540:	00094583          	lbu	a1,0(s2)
 544:	c9a1                	beqz	a1,594 <vprintf+0x1ba>
          putc(fd, *s);
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	dc6080e7          	jalr	-570(ra) # 30e <putc>
          s++;
 550:	0905                	addi	s2,s2,1
        while(*s != 0){
 552:	00094583          	lbu	a1,0(s2)
 556:	f9e5                	bnez	a1,546 <vprintf+0x16c>
        s = va_arg(ap, char*);
 558:	8b4e                	mv	s6,s3
      state = 0;
 55a:	4981                	li	s3,0
 55c:	bdf9                	j	43a <vprintf+0x60>
          s = "(null)";
 55e:	00000917          	auipc	s2,0x0
 562:	26290913          	addi	s2,s2,610 # 7c0 <malloc+0x11c>
        while(*s != 0){
 566:	02800593          	li	a1,40
 56a:	bff1                	j	546 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 56c:	008b0913          	addi	s2,s6,8
 570:	000b4583          	lbu	a1,0(s6)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	d98080e7          	jalr	-616(ra) # 30e <putc>
 57e:	8b4a                	mv	s6,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	bd65                	j	43a <vprintf+0x60>
        putc(fd, c);
 584:	85d2                	mv	a1,s4
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	d86080e7          	jalr	-634(ra) # 30e <putc>
      state = 0;
 590:	4981                	li	s3,0
 592:	b565                	j	43a <vprintf+0x60>
        s = va_arg(ap, char*);
 594:	8b4e                	mv	s6,s3
      state = 0;
 596:	4981                	li	s3,0
 598:	b54d                	j	43a <vprintf+0x60>
    }
  }
}
 59a:	70e6                	ld	ra,120(sp)
 59c:	7446                	ld	s0,112(sp)
 59e:	74a6                	ld	s1,104(sp)
 5a0:	7906                	ld	s2,96(sp)
 5a2:	69e6                	ld	s3,88(sp)
 5a4:	6a46                	ld	s4,80(sp)
 5a6:	6aa6                	ld	s5,72(sp)
 5a8:	6b06                	ld	s6,64(sp)
 5aa:	7be2                	ld	s7,56(sp)
 5ac:	7c42                	ld	s8,48(sp)
 5ae:	7ca2                	ld	s9,40(sp)
 5b0:	7d02                	ld	s10,32(sp)
 5b2:	6de2                	ld	s11,24(sp)
 5b4:	6109                	addi	sp,sp,128
 5b6:	8082                	ret

00000000000005b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5b8:	715d                	addi	sp,sp,-80
 5ba:	ec06                	sd	ra,24(sp)
 5bc:	e822                	sd	s0,16(sp)
 5be:	1000                	addi	s0,sp,32
 5c0:	e010                	sd	a2,0(s0)
 5c2:	e414                	sd	a3,8(s0)
 5c4:	e818                	sd	a4,16(s0)
 5c6:	ec1c                	sd	a5,24(s0)
 5c8:	03043023          	sd	a6,32(s0)
 5cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5d4:	8622                	mv	a2,s0
 5d6:	00000097          	auipc	ra,0x0
 5da:	e04080e7          	jalr	-508(ra) # 3da <vprintf>
}
 5de:	60e2                	ld	ra,24(sp)
 5e0:	6442                	ld	s0,16(sp)
 5e2:	6161                	addi	sp,sp,80
 5e4:	8082                	ret

00000000000005e6 <printf>:

void
printf(const char *fmt, ...)
{
 5e6:	711d                	addi	sp,sp,-96
 5e8:	ec06                	sd	ra,24(sp)
 5ea:	e822                	sd	s0,16(sp)
 5ec:	1000                	addi	s0,sp,32
 5ee:	e40c                	sd	a1,8(s0)
 5f0:	e810                	sd	a2,16(s0)
 5f2:	ec14                	sd	a3,24(s0)
 5f4:	f018                	sd	a4,32(s0)
 5f6:	f41c                	sd	a5,40(s0)
 5f8:	03043823          	sd	a6,48(s0)
 5fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 600:	00840613          	addi	a2,s0,8
 604:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 608:	85aa                	mv	a1,a0
 60a:	4505                	li	a0,1
 60c:	00000097          	auipc	ra,0x0
 610:	dce080e7          	jalr	-562(ra) # 3da <vprintf>
}
 614:	60e2                	ld	ra,24(sp)
 616:	6442                	ld	s0,16(sp)
 618:	6125                	addi	sp,sp,96
 61a:	8082                	ret

000000000000061c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61c:	1141                	addi	sp,sp,-16
 61e:	e422                	sd	s0,8(sp)
 620:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 622:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 626:	00000797          	auipc	a5,0x0
 62a:	1ba7b783          	ld	a5,442(a5) # 7e0 <freep>
 62e:	a805                	j	65e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 630:	4618                	lw	a4,8(a2)
 632:	9db9                	addw	a1,a1,a4
 634:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 638:	6398                	ld	a4,0(a5)
 63a:	6318                	ld	a4,0(a4)
 63c:	fee53823          	sd	a4,-16(a0)
 640:	a091                	j	684 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 642:	ff852703          	lw	a4,-8(a0)
 646:	9e39                	addw	a2,a2,a4
 648:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 64a:	ff053703          	ld	a4,-16(a0)
 64e:	e398                	sd	a4,0(a5)
 650:	a099                	j	696 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 652:	6398                	ld	a4,0(a5)
 654:	00e7e463          	bltu	a5,a4,65c <free+0x40>
 658:	00e6ea63          	bltu	a3,a4,66c <free+0x50>
{
 65c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65e:	fed7fae3          	bgeu	a5,a3,652 <free+0x36>
 662:	6398                	ld	a4,0(a5)
 664:	00e6e463          	bltu	a3,a4,66c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 668:	fee7eae3          	bltu	a5,a4,65c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 66c:	ff852583          	lw	a1,-8(a0)
 670:	6390                	ld	a2,0(a5)
 672:	02059813          	slli	a6,a1,0x20
 676:	01c85713          	srli	a4,a6,0x1c
 67a:	9736                	add	a4,a4,a3
 67c:	fae60ae3          	beq	a2,a4,630 <free+0x14>
    bp->s.ptr = p->s.ptr;
 680:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 684:	4790                	lw	a2,8(a5)
 686:	02061593          	slli	a1,a2,0x20
 68a:	01c5d713          	srli	a4,a1,0x1c
 68e:	973e                	add	a4,a4,a5
 690:	fae689e3          	beq	a3,a4,642 <free+0x26>
  } else
    p->s.ptr = bp;
 694:	e394                	sd	a3,0(a5)
  freep = p;
 696:	00000717          	auipc	a4,0x0
 69a:	14f73523          	sd	a5,330(a4) # 7e0 <freep>
}
 69e:	6422                	ld	s0,8(sp)
 6a0:	0141                	addi	sp,sp,16
 6a2:	8082                	ret

00000000000006a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a4:	7139                	addi	sp,sp,-64
 6a6:	fc06                	sd	ra,56(sp)
 6a8:	f822                	sd	s0,48(sp)
 6aa:	f426                	sd	s1,40(sp)
 6ac:	f04a                	sd	s2,32(sp)
 6ae:	ec4e                	sd	s3,24(sp)
 6b0:	e852                	sd	s4,16(sp)
 6b2:	e456                	sd	s5,8(sp)
 6b4:	e05a                	sd	s6,0(sp)
 6b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b8:	02051493          	slli	s1,a0,0x20
 6bc:	9081                	srli	s1,s1,0x20
 6be:	04bd                	addi	s1,s1,15
 6c0:	8091                	srli	s1,s1,0x4
 6c2:	0014899b          	addiw	s3,s1,1
 6c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6c8:	00000517          	auipc	a0,0x0
 6cc:	11853503          	ld	a0,280(a0) # 7e0 <freep>
 6d0:	c515                	beqz	a0,6fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6d4:	4798                	lw	a4,8(a5)
 6d6:	02977f63          	bgeu	a4,s1,714 <malloc+0x70>
 6da:	8a4e                	mv	s4,s3
 6dc:	0009871b          	sext.w	a4,s3
 6e0:	6685                	lui	a3,0x1
 6e2:	00d77363          	bgeu	a4,a3,6e8 <malloc+0x44>
 6e6:	6a05                	lui	s4,0x1
 6e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6f0:	00000917          	auipc	s2,0x0
 6f4:	0f090913          	addi	s2,s2,240 # 7e0 <freep>
  if(p == (char*)-1)
 6f8:	5afd                	li	s5,-1
 6fa:	a895                	j	76e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 6fc:	00000797          	auipc	a5,0x0
 700:	0ec78793          	addi	a5,a5,236 # 7e8 <base>
 704:	00000717          	auipc	a4,0x0
 708:	0cf73e23          	sd	a5,220(a4) # 7e0 <freep>
 70c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 70e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 712:	b7e1                	j	6da <malloc+0x36>
      if(p->s.size == nunits)
 714:	02e48c63          	beq	s1,a4,74c <malloc+0xa8>
        p->s.size -= nunits;
 718:	4137073b          	subw	a4,a4,s3
 71c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 71e:	02071693          	slli	a3,a4,0x20
 722:	01c6d713          	srli	a4,a3,0x1c
 726:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 728:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 72c:	00000717          	auipc	a4,0x0
 730:	0aa73a23          	sd	a0,180(a4) # 7e0 <freep>
      return (void*)(p + 1);
 734:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 738:	70e2                	ld	ra,56(sp)
 73a:	7442                	ld	s0,48(sp)
 73c:	74a2                	ld	s1,40(sp)
 73e:	7902                	ld	s2,32(sp)
 740:	69e2                	ld	s3,24(sp)
 742:	6a42                	ld	s4,16(sp)
 744:	6aa2                	ld	s5,8(sp)
 746:	6b02                	ld	s6,0(sp)
 748:	6121                	addi	sp,sp,64
 74a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 74c:	6398                	ld	a4,0(a5)
 74e:	e118                	sd	a4,0(a0)
 750:	bff1                	j	72c <malloc+0x88>
  hp->s.size = nu;
 752:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 756:	0541                	addi	a0,a0,16
 758:	00000097          	auipc	ra,0x0
 75c:	ec4080e7          	jalr	-316(ra) # 61c <free>
  return freep;
 760:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 764:	d971                	beqz	a0,738 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 766:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 768:	4798                	lw	a4,8(a5)
 76a:	fa9775e3          	bgeu	a4,s1,714 <malloc+0x70>
    if(p == freep)
 76e:	00093703          	ld	a4,0(s2)
 772:	853e                	mv	a0,a5
 774:	fef719e3          	bne	a4,a5,766 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 778:	8552                	mv	a0,s4
 77a:	00000097          	auipc	ra,0x0
 77e:	b5c080e7          	jalr	-1188(ra) # 2d6 <sbrk>
  if(p == (char*)-1)
 782:	fd5518e3          	bne	a0,s5,752 <malloc+0xae>
        return 0;
 786:	4501                	li	a0,0
 788:	bf45                	j	738 <malloc+0x94>
