
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
	//父进程管道
	int parent_pipe[2];
	pipe(parent_pipe);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	46e080e7          	jalr	1134(ra) # 47a <pipe>
	//子进程管道
	int child_pipe[2];
	pipe(child_pipe);
  14:	fe040513          	addi	a0,s0,-32
  18:	00000097          	auipc	ra,0x0
  1c:	462080e7          	jalr	1122(ra) # 47a <pipe>
	//字符序列
	char buffer[] = "ping";
  20:	676e77b7          	lui	a5,0x676e7
  24:	97078793          	addi	a5,a5,-1680 # 676e6970 <__global_pointer$+0x676e5697>
  28:	fcf42c23          	sw	a5,-40(s0)
  2c:	fc040e23          	sb	zero,-36(s0)
	//序列长度
	int length = sizeof(buffer);
	//进入子进程
	if (fork() == 0) {
  30:	00000097          	auipc	ra,0x0
  34:	432080e7          	jalr	1074(ra) # 462 <fork>
  38:	e565                	bnez	a0,120 <main+0x120>
		//关掉父进程管道的写
		close(parent_pipe[1]);
  3a:	fec42503          	lw	a0,-20(s0)
  3e:	00000097          	auipc	ra,0x0
  42:	454080e7          	jalr	1108(ra) # 492 <close>
		//关掉子进程管道的读
		close(child_pipe[0]);
  46:	fe042503          	lw	a0,-32(s0)
  4a:	00000097          	auipc	ra,0x0
  4e:	448080e7          	jalr	1096(ra) # 492 <close>
		//子进程读
		//读失败
		if (read(parent_pipe[0], buffer, length) != length) {
  52:	4615                	li	a2,5
  54:	fd840593          	addi	a1,s0,-40
  58:	fe842503          	lw	a0,-24(s0)
  5c:	00000097          	auipc	ra,0x0
  60:	426080e7          	jalr	1062(ra) # 482 <read>
  64:	4795                	li	a5,5
  66:	00f50f63          	beq	a0,a5,84 <main+0x84>
			printf("error:child---read--->parent error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	92650513          	addi	a0,a0,-1754 # 990 <malloc+0xe8>
  72:	00000097          	auipc	ra,0x0
  76:	778080e7          	jalr	1912(ra) # 7ea <printf>
			exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	3ee080e7          	jalr	1006(ra) # 46a <exit>
		}
		//读成功
		printf("child %d read:%s\n", getpid(), buffer);
  84:	00000097          	auipc	ra,0x0
  88:	466080e7          	jalr	1126(ra) # 4ea <getpid>
  8c:	85aa                	mv	a1,a0
  8e:	fd840613          	addi	a2,s0,-40
  92:	00001517          	auipc	a0,0x1
  96:	92650513          	addi	a0,a0,-1754 # 9b8 <malloc+0x110>
  9a:	00000097          	auipc	ra,0x0
  9e:	750080e7          	jalr	1872(ra) # 7ea <printf>
		//"i"改成"o"
		buffer[1] = buffer[1] + 6;
  a2:	fd944783          	lbu	a5,-39(s0)
  a6:	2799                	addiw	a5,a5,6
  a8:	fcf40ca3          	sb	a5,-39(s0)
		length = sizeof(buffer);
		//子进程写
		if (write(child_pipe[1], buffer, length) != length){
  ac:	4615                	li	a2,5
  ae:	fd840593          	addi	a1,s0,-40
  b2:	fe442503          	lw	a0,-28(s0)
  b6:	00000097          	auipc	ra,0x0
  ba:	3d4080e7          	jalr	980(ra) # 48a <write>
  be:	4795                	li	a5,5
  c0:	00f50f63          	beq	a0,a5,de <main+0xde>
			printf("error:child---write--->parent error\n");
  c4:	00001517          	auipc	a0,0x1
  c8:	90c50513          	addi	a0,a0,-1780 # 9d0 <malloc+0x128>
  cc:	00000097          	auipc	ra,0x0
  d0:	71e080e7          	jalr	1822(ra) # 7ea <printf>
			exit(1);
  d4:	4505                	li	a0,1
  d6:	00000097          	auipc	ra,0x0
  da:	394080e7          	jalr	916(ra) # 46a <exit>
		}
		//写成功
		printf("child %d write:%s\n", getpid(), buffer);
  de:	00000097          	auipc	ra,0x0
  e2:	40c080e7          	jalr	1036(ra) # 4ea <getpid>
  e6:	85aa                	mv	a1,a0
  e8:	fd840613          	addi	a2,s0,-40
  ec:	00001517          	auipc	a0,0x1
  f0:	90c50513          	addi	a0,a0,-1780 # 9f8 <malloc+0x150>
  f4:	00000097          	auipc	ra,0x0
  f8:	6f6080e7          	jalr	1782(ra) # 7ea <printf>
		printf("%d: received ping\n", getpid());
  fc:	00000097          	auipc	ra,0x0
 100:	3ee080e7          	jalr	1006(ra) # 4ea <getpid>
 104:	85aa                	mv	a1,a0
 106:	00001517          	auipc	a0,0x1
 10a:	90a50513          	addi	a0,a0,-1782 # a10 <malloc+0x168>
 10e:	00000097          	auipc	ra,0x0
 112:	6dc080e7          	jalr	1756(ra) # 7ea <printf>
		exit(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	352080e7          	jalr	850(ra) # 46a <exit>
	}
	//进入父进程
	close(parent_pipe[0]);
 120:	fe842503          	lw	a0,-24(s0)
 124:	00000097          	auipc	ra,0x0
 128:	36e080e7          	jalr	878(ra) # 492 <close>
	close(child_pipe[1]);
 12c:	fe442503          	lw	a0,-28(s0)
 130:	00000097          	auipc	ra,0x0
 134:	362080e7          	jalr	866(ra) # 492 <close>
	if (write(parent_pipe[1], buffer, length) != length) {
 138:	4615                	li	a2,5
 13a:	fd840593          	addi	a1,s0,-40
 13e:	fec42503          	lw	a0,-20(s0)
 142:	00000097          	auipc	ra,0x0
 146:	348080e7          	jalr	840(ra) # 48a <write>
 14a:	4795                	li	a5,5
 14c:	00f50f63          	beq	a0,a5,16a <main+0x16a>
		printf("error:parent---write--->child error\n");
 150:	00001517          	auipc	a0,0x1
 154:	8d850513          	addi	a0,a0,-1832 # a28 <malloc+0x180>
 158:	00000097          	auipc	ra,0x0
 15c:	692080e7          	jalr	1682(ra) # 7ea <printf>
		exit(1);
 160:	4505                	li	a0,1
 162:	00000097          	auipc	ra,0x0
 166:	308080e7          	jalr	776(ra) # 46a <exit>
	}
	printf("parent %d write:%s\n", getpid(), buffer);
 16a:	00000097          	auipc	ra,0x0
 16e:	380080e7          	jalr	896(ra) # 4ea <getpid>
 172:	85aa                	mv	a1,a0
 174:	fd840613          	addi	a2,s0,-40
 178:	00001517          	auipc	a0,0x1
 17c:	8d850513          	addi	a0,a0,-1832 # a50 <malloc+0x1a8>
 180:	00000097          	auipc	ra,0x0
 184:	66a080e7          	jalr	1642(ra) # 7ea <printf>
	if (read(child_pipe[0], buffer, length) != length) {
 188:	4615                	li	a2,5
 18a:	fd840593          	addi	a1,s0,-40
 18e:	fe042503          	lw	a0,-32(s0)
 192:	00000097          	auipc	ra,0x0
 196:	2f0080e7          	jalr	752(ra) # 482 <read>
 19a:	4795                	li	a5,5
 19c:	00f50f63          	beq	a0,a5,1ba <main+0x1ba>
		printf("error:parent---read--->child error\n");
 1a0:	00001517          	auipc	a0,0x1
 1a4:	8c850513          	addi	a0,a0,-1848 # a68 <malloc+0x1c0>
 1a8:	00000097          	auipc	ra,0x0
 1ac:	642080e7          	jalr	1602(ra) # 7ea <printf>
		exit(1);
 1b0:	4505                	li	a0,1
 1b2:	00000097          	auipc	ra,0x0
 1b6:	2b8080e7          	jalr	696(ra) # 46a <exit>
	}
	printf("parent %d read:%s\n", getpid(), buffer);
 1ba:	00000097          	auipc	ra,0x0
 1be:	330080e7          	jalr	816(ra) # 4ea <getpid>
 1c2:	85aa                	mv	a1,a0
 1c4:	fd840613          	addi	a2,s0,-40
 1c8:	00001517          	auipc	a0,0x1
 1cc:	8c850513          	addi	a0,a0,-1848 # a90 <malloc+0x1e8>
 1d0:	00000097          	auipc	ra,0x0
 1d4:	61a080e7          	jalr	1562(ra) # 7ea <printf>
	printf("%d: received pong\n", getpid());
 1d8:	00000097          	auipc	ra,0x0
 1dc:	312080e7          	jalr	786(ra) # 4ea <getpid>
 1e0:	85aa                	mv	a1,a0
 1e2:	00001517          	auipc	a0,0x1
 1e6:	8c650513          	addi	a0,a0,-1850 # aa8 <malloc+0x200>
 1ea:	00000097          	auipc	ra,0x0
 1ee:	600080e7          	jalr	1536(ra) # 7ea <printf>
	exit(0);
 1f2:	4501                	li	a0,0
 1f4:	00000097          	auipc	ra,0x0
 1f8:	276080e7          	jalr	630(ra) # 46a <exit>

00000000000001fc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 202:	87aa                	mv	a5,a0
 204:	0585                	addi	a1,a1,1
 206:	0785                	addi	a5,a5,1
 208:	fff5c703          	lbu	a4,-1(a1)
 20c:	fee78fa3          	sb	a4,-1(a5)
 210:	fb75                	bnez	a4,204 <strcpy+0x8>
    ;
  return os;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cb91                	beqz	a5,236 <strcmp+0x1e>
 224:	0005c703          	lbu	a4,0(a1)
 228:	00f71763          	bne	a4,a5,236 <strcmp+0x1e>
    p++, q++;
 22c:	0505                	addi	a0,a0,1
 22e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 230:	00054783          	lbu	a5,0(a0)
 234:	fbe5                	bnez	a5,224 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 236:	0005c503          	lbu	a0,0(a1)
}
 23a:	40a7853b          	subw	a0,a5,a0
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <strlen>:

uint
strlen(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	cf91                	beqz	a5,26a <strlen+0x26>
 250:	0505                	addi	a0,a0,1
 252:	87aa                	mv	a5,a0
 254:	4685                	li	a3,1
 256:	9e89                	subw	a3,a3,a0
 258:	00f6853b          	addw	a0,a3,a5
 25c:	0785                	addi	a5,a5,1
 25e:	fff7c703          	lbu	a4,-1(a5)
 262:	fb7d                	bnez	a4,258 <strlen+0x14>
    ;
  return n;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  for(n = 0; s[n]; n++)
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <strlen+0x20>

000000000000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 274:	ca19                	beqz	a2,28a <memset+0x1c>
 276:	87aa                	mv	a5,a0
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 280:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 284:	0785                	addi	a5,a5,1
 286:	fee79de3          	bne	a5,a4,280 <memset+0x12>
  }
  return dst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  for(; *s; s++)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cb99                	beqz	a5,2b0 <strchr+0x20>
    if(*s == c)
 29c:	00f58763          	beq	a1,a5,2aa <strchr+0x1a>
  for(; *s; s++)
 2a0:	0505                	addi	a0,a0,1
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbfd                	bnez	a5,29c <strchr+0xc>
      return (char*)s;
  return 0;
 2a8:	4501                	li	a0,0
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <strchr+0x1a>

00000000000002b4 <gets>:

char*
gets(char *buf, int max)
{
 2b4:	711d                	addi	sp,sp,-96
 2b6:	ec86                	sd	ra,88(sp)
 2b8:	e8a2                	sd	s0,80(sp)
 2ba:	e4a6                	sd	s1,72(sp)
 2bc:	e0ca                	sd	s2,64(sp)
 2be:	fc4e                	sd	s3,56(sp)
 2c0:	f852                	sd	s4,48(sp)
 2c2:	f456                	sd	s5,40(sp)
 2c4:	f05a                	sd	s6,32(sp)
 2c6:	ec5e                	sd	s7,24(sp)
 2c8:	1080                	addi	s0,sp,96
 2ca:	8baa                	mv	s7,a0
 2cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	892a                	mv	s2,a0
 2d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d2:	4aa9                	li	s5,10
 2d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d6:	89a6                	mv	s3,s1
 2d8:	2485                	addiw	s1,s1,1
 2da:	0344d863          	bge	s1,s4,30a <gets+0x56>
    cc = read(0, &c, 1);
 2de:	4605                	li	a2,1
 2e0:	faf40593          	addi	a1,s0,-81
 2e4:	4501                	li	a0,0
 2e6:	00000097          	auipc	ra,0x0
 2ea:	19c080e7          	jalr	412(ra) # 482 <read>
    if(cc < 1)
 2ee:	00a05e63          	blez	a0,30a <gets+0x56>
    buf[i++] = c;
 2f2:	faf44783          	lbu	a5,-81(s0)
 2f6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fa:	01578763          	beq	a5,s5,308 <gets+0x54>
 2fe:	0905                	addi	s2,s2,1
 300:	fd679be3          	bne	a5,s6,2d6 <gets+0x22>
  for(i=0; i+1 < max; ){
 304:	89a6                	mv	s3,s1
 306:	a011                	j	30a <gets+0x56>
 308:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 30a:	99de                	add	s3,s3,s7
 30c:	00098023          	sb	zero,0(s3)
  return buf;
}
 310:	855e                	mv	a0,s7
 312:	60e6                	ld	ra,88(sp)
 314:	6446                	ld	s0,80(sp)
 316:	64a6                	ld	s1,72(sp)
 318:	6906                	ld	s2,64(sp)
 31a:	79e2                	ld	s3,56(sp)
 31c:	7a42                	ld	s4,48(sp)
 31e:	7aa2                	ld	s5,40(sp)
 320:	7b02                	ld	s6,32(sp)
 322:	6be2                	ld	s7,24(sp)
 324:	6125                	addi	sp,sp,96
 326:	8082                	ret

0000000000000328 <stat>:

int
stat(const char *n, struct stat *st)
{
 328:	1101                	addi	sp,sp,-32
 32a:	ec06                	sd	ra,24(sp)
 32c:	e822                	sd	s0,16(sp)
 32e:	e426                	sd	s1,8(sp)
 330:	e04a                	sd	s2,0(sp)
 332:	1000                	addi	s0,sp,32
 334:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 336:	4581                	li	a1,0
 338:	00000097          	auipc	ra,0x0
 33c:	172080e7          	jalr	370(ra) # 4aa <open>
  if(fd < 0)
 340:	02054563          	bltz	a0,36a <stat+0x42>
 344:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 346:	85ca                	mv	a1,s2
 348:	00000097          	auipc	ra,0x0
 34c:	17a080e7          	jalr	378(ra) # 4c2 <fstat>
 350:	892a                	mv	s2,a0
  close(fd);
 352:	8526                	mv	a0,s1
 354:	00000097          	auipc	ra,0x0
 358:	13e080e7          	jalr	318(ra) # 492 <close>
  return r;
}
 35c:	854a                	mv	a0,s2
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	64a2                	ld	s1,8(sp)
 364:	6902                	ld	s2,0(sp)
 366:	6105                	addi	sp,sp,32
 368:	8082                	ret
    return -1;
 36a:	597d                	li	s2,-1
 36c:	bfc5                	j	35c <stat+0x34>

000000000000036e <atoi>:

int
atoi(const char *s)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 374:	00054603          	lbu	a2,0(a0)
 378:	fd06079b          	addiw	a5,a2,-48
 37c:	0ff7f793          	andi	a5,a5,255
 380:	4725                	li	a4,9
 382:	02f76963          	bltu	a4,a5,3b4 <atoi+0x46>
 386:	86aa                	mv	a3,a0
  n = 0;
 388:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 38a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 38c:	0685                	addi	a3,a3,1
 38e:	0025179b          	slliw	a5,a0,0x2
 392:	9fa9                	addw	a5,a5,a0
 394:	0017979b          	slliw	a5,a5,0x1
 398:	9fb1                	addw	a5,a5,a2
 39a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39e:	0006c603          	lbu	a2,0(a3)
 3a2:	fd06071b          	addiw	a4,a2,-48
 3a6:	0ff77713          	andi	a4,a4,255
 3aa:	fee5f1e3          	bgeu	a1,a4,38c <atoi+0x1e>
  return n;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  n = 0;
 3b4:	4501                	li	a0,0
 3b6:	bfe5                	j	3ae <atoi+0x40>

00000000000003b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3be:	02b57463          	bgeu	a0,a1,3e6 <memmove+0x2e>
    while(n-- > 0)
 3c2:	00c05f63          	blez	a2,3e0 <memmove+0x28>
 3c6:	1602                	slli	a2,a2,0x20
 3c8:	9201                	srli	a2,a2,0x20
 3ca:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ce:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d0:	0585                	addi	a1,a1,1
 3d2:	0705                	addi	a4,a4,1
 3d4:	fff5c683          	lbu	a3,-1(a1)
 3d8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3dc:	fee79ae3          	bne	a5,a4,3d0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e0:	6422                	ld	s0,8(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret
    dst += n;
 3e6:	00c50733          	add	a4,a0,a2
    src += n;
 3ea:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ec:	fec05ae3          	blez	a2,3e0 <memmove+0x28>
 3f0:	fff6079b          	addiw	a5,a2,-1
 3f4:	1782                	slli	a5,a5,0x20
 3f6:	9381                	srli	a5,a5,0x20
 3f8:	fff7c793          	not	a5,a5
 3fc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fe:	15fd                	addi	a1,a1,-1
 400:	177d                	addi	a4,a4,-1
 402:	0005c683          	lbu	a3,0(a1)
 406:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40a:	fee79ae3          	bne	a5,a4,3fe <memmove+0x46>
 40e:	bfc9                	j	3e0 <memmove+0x28>

0000000000000410 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 416:	ca05                	beqz	a2,446 <memcmp+0x36>
 418:	fff6069b          	addiw	a3,a2,-1
 41c:	1682                	slli	a3,a3,0x20
 41e:	9281                	srli	a3,a3,0x20
 420:	0685                	addi	a3,a3,1
 422:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 424:	00054783          	lbu	a5,0(a0)
 428:	0005c703          	lbu	a4,0(a1)
 42c:	00e79863          	bne	a5,a4,43c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 430:	0505                	addi	a0,a0,1
    p2++;
 432:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 434:	fed518e3          	bne	a0,a3,424 <memcmp+0x14>
  }
  return 0;
 438:	4501                	li	a0,0
 43a:	a019                	j	440 <memcmp+0x30>
      return *p1 - *p2;
 43c:	40e7853b          	subw	a0,a5,a4
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  return 0;
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <memcmp+0x30>

000000000000044a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e406                	sd	ra,8(sp)
 44e:	e022                	sd	s0,0(sp)
 450:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 452:	00000097          	auipc	ra,0x0
 456:	f66080e7          	jalr	-154(ra) # 3b8 <memmove>
}
 45a:	60a2                	ld	ra,8(sp)
 45c:	6402                	ld	s0,0(sp)
 45e:	0141                	addi	sp,sp,16
 460:	8082                	ret

0000000000000462 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 462:	4885                	li	a7,1
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <exit>:
.global exit
exit:
 li a7, SYS_exit
 46a:	4889                	li	a7,2
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <wait>:
.global wait
wait:
 li a7, SYS_wait
 472:	488d                	li	a7,3
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47a:	4891                	li	a7,4
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <read>:
.global read
read:
 li a7, SYS_read
 482:	4895                	li	a7,5
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <write>:
.global write
write:
 li a7, SYS_write
 48a:	48c1                	li	a7,16
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <close>:
.global close
close:
 li a7, SYS_close
 492:	48d5                	li	a7,21
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <kill>:
.global kill
kill:
 li a7, SYS_kill
 49a:	4899                	li	a7,6
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a2:	489d                	li	a7,7
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <open>:
.global open
open:
 li a7, SYS_open
 4aa:	48bd                	li	a7,15
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b2:	48c5                	li	a7,17
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ba:	48c9                	li	a7,18
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c2:	48a1                	li	a7,8
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <link>:
.global link
link:
 li a7, SYS_link
 4ca:	48cd                	li	a7,19
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d2:	48d1                	li	a7,20
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4da:	48a5                	li	a7,9
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e2:	48a9                	li	a7,10
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ea:	48ad                	li	a7,11
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f2:	48b1                	li	a7,12
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fa:	48b5                	li	a7,13
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 502:	48b9                	li	a7,14
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 50a:	48d9                	li	a7,22
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 512:	1101                	addi	sp,sp,-32
 514:	ec06                	sd	ra,24(sp)
 516:	e822                	sd	s0,16(sp)
 518:	1000                	addi	s0,sp,32
 51a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 51e:	4605                	li	a2,1
 520:	fef40593          	addi	a1,s0,-17
 524:	00000097          	auipc	ra,0x0
 528:	f66080e7          	jalr	-154(ra) # 48a <write>
}
 52c:	60e2                	ld	ra,24(sp)
 52e:	6442                	ld	s0,16(sp)
 530:	6105                	addi	sp,sp,32
 532:	8082                	ret

0000000000000534 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 534:	7139                	addi	sp,sp,-64
 536:	fc06                	sd	ra,56(sp)
 538:	f822                	sd	s0,48(sp)
 53a:	f426                	sd	s1,40(sp)
 53c:	f04a                	sd	s2,32(sp)
 53e:	ec4e                	sd	s3,24(sp)
 540:	0080                	addi	s0,sp,64
 542:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 544:	c299                	beqz	a3,54a <printint+0x16>
 546:	0805c863          	bltz	a1,5d6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 54a:	2581                	sext.w	a1,a1
  neg = 0;
 54c:	4881                	li	a7,0
 54e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 552:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 554:	2601                	sext.w	a2,a2
 556:	00000517          	auipc	a0,0x0
 55a:	57250513          	addi	a0,a0,1394 # ac8 <digits>
 55e:	883a                	mv	a6,a4
 560:	2705                	addiw	a4,a4,1
 562:	02c5f7bb          	remuw	a5,a1,a2
 566:	1782                	slli	a5,a5,0x20
 568:	9381                	srli	a5,a5,0x20
 56a:	97aa                	add	a5,a5,a0
 56c:	0007c783          	lbu	a5,0(a5)
 570:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 574:	0005879b          	sext.w	a5,a1
 578:	02c5d5bb          	divuw	a1,a1,a2
 57c:	0685                	addi	a3,a3,1
 57e:	fec7f0e3          	bgeu	a5,a2,55e <printint+0x2a>
  if(neg)
 582:	00088b63          	beqz	a7,598 <printint+0x64>
    buf[i++] = '-';
 586:	fd040793          	addi	a5,s0,-48
 58a:	973e                	add	a4,a4,a5
 58c:	02d00793          	li	a5,45
 590:	fef70823          	sb	a5,-16(a4)
 594:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 598:	02e05863          	blez	a4,5c8 <printint+0x94>
 59c:	fc040793          	addi	a5,s0,-64
 5a0:	00e78933          	add	s2,a5,a4
 5a4:	fff78993          	addi	s3,a5,-1
 5a8:	99ba                	add	s3,s3,a4
 5aa:	377d                	addiw	a4,a4,-1
 5ac:	1702                	slli	a4,a4,0x20
 5ae:	9301                	srli	a4,a4,0x20
 5b0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b4:	fff94583          	lbu	a1,-1(s2)
 5b8:	8526                	mv	a0,s1
 5ba:	00000097          	auipc	ra,0x0
 5be:	f58080e7          	jalr	-168(ra) # 512 <putc>
  while(--i >= 0)
 5c2:	197d                	addi	s2,s2,-1
 5c4:	ff3918e3          	bne	s2,s3,5b4 <printint+0x80>
}
 5c8:	70e2                	ld	ra,56(sp)
 5ca:	7442                	ld	s0,48(sp)
 5cc:	74a2                	ld	s1,40(sp)
 5ce:	7902                	ld	s2,32(sp)
 5d0:	69e2                	ld	s3,24(sp)
 5d2:	6121                	addi	sp,sp,64
 5d4:	8082                	ret
    x = -xx;
 5d6:	40b005bb          	negw	a1,a1
    neg = 1;
 5da:	4885                	li	a7,1
    x = -xx;
 5dc:	bf8d                	j	54e <printint+0x1a>

00000000000005de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5de:	7119                	addi	sp,sp,-128
 5e0:	fc86                	sd	ra,120(sp)
 5e2:	f8a2                	sd	s0,112(sp)
 5e4:	f4a6                	sd	s1,104(sp)
 5e6:	f0ca                	sd	s2,96(sp)
 5e8:	ecce                	sd	s3,88(sp)
 5ea:	e8d2                	sd	s4,80(sp)
 5ec:	e4d6                	sd	s5,72(sp)
 5ee:	e0da                	sd	s6,64(sp)
 5f0:	fc5e                	sd	s7,56(sp)
 5f2:	f862                	sd	s8,48(sp)
 5f4:	f466                	sd	s9,40(sp)
 5f6:	f06a                	sd	s10,32(sp)
 5f8:	ec6e                	sd	s11,24(sp)
 5fa:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5fc:	0005c903          	lbu	s2,0(a1)
 600:	18090f63          	beqz	s2,79e <vprintf+0x1c0>
 604:	8aaa                	mv	s5,a0
 606:	8b32                	mv	s6,a2
 608:	00158493          	addi	s1,a1,1
  state = 0;
 60c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 60e:	02500a13          	li	s4,37
      if(c == 'd'){
 612:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 616:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 61a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 61e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 622:	00000b97          	auipc	s7,0x0
 626:	4a6b8b93          	addi	s7,s7,1190 # ac8 <digits>
 62a:	a839                	j	648 <vprintf+0x6a>
        putc(fd, c);
 62c:	85ca                	mv	a1,s2
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	ee2080e7          	jalr	-286(ra) # 512 <putc>
 638:	a019                	j	63e <vprintf+0x60>
    } else if(state == '%'){
 63a:	01498f63          	beq	s3,s4,658 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 63e:	0485                	addi	s1,s1,1
 640:	fff4c903          	lbu	s2,-1(s1)
 644:	14090d63          	beqz	s2,79e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 648:	0009079b          	sext.w	a5,s2
    if(state == 0){
 64c:	fe0997e3          	bnez	s3,63a <vprintf+0x5c>
      if(c == '%'){
 650:	fd479ee3          	bne	a5,s4,62c <vprintf+0x4e>
        state = '%';
 654:	89be                	mv	s3,a5
 656:	b7e5                	j	63e <vprintf+0x60>
      if(c == 'd'){
 658:	05878063          	beq	a5,s8,698 <vprintf+0xba>
      } else if(c == 'l') {
 65c:	05978c63          	beq	a5,s9,6b4 <vprintf+0xd6>
      } else if(c == 'x') {
 660:	07a78863          	beq	a5,s10,6d0 <vprintf+0xf2>
      } else if(c == 'p') {
 664:	09b78463          	beq	a5,s11,6ec <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 668:	07300713          	li	a4,115
 66c:	0ce78663          	beq	a5,a4,738 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 670:	06300713          	li	a4,99
 674:	0ee78e63          	beq	a5,a4,770 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 678:	11478863          	beq	a5,s4,788 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67c:	85d2                	mv	a1,s4
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e92080e7          	jalr	-366(ra) # 512 <putc>
        putc(fd, c);
 688:	85ca                	mv	a1,s2
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	e86080e7          	jalr	-378(ra) # 512 <putc>
      }
      state = 0;
 694:	4981                	li	s3,0
 696:	b765                	j	63e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 698:	008b0913          	addi	s2,s6,8
 69c:	4685                	li	a3,1
 69e:	4629                	li	a2,10
 6a0:	000b2583          	lw	a1,0(s6)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	e8e080e7          	jalr	-370(ra) # 534 <printint>
 6ae:	8b4a                	mv	s6,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b771                	j	63e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b0913          	addi	s2,s6,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000b2583          	lw	a1,0(s6)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e72080e7          	jalr	-398(ra) # 534 <printint>
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bf85                	j	63e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	4681                	li	a3,0
 6d6:	4641                	li	a2,16
 6d8:	000b2583          	lw	a1,0(s6)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e56080e7          	jalr	-426(ra) # 534 <printint>
 6e6:	8b4a                	mv	s6,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bf91                	j	63e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ec:	008b0793          	addi	a5,s6,8
 6f0:	f8f43423          	sd	a5,-120(s0)
 6f4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e14080e7          	jalr	-492(ra) # 512 <putc>
  putc(fd, 'x');
 706:	85ea                	mv	a1,s10
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e08080e7          	jalr	-504(ra) # 512 <putc>
 712:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	03c9d793          	srli	a5,s3,0x3c
 718:	97de                	add	a5,a5,s7
 71a:	0007c583          	lbu	a1,0(a5)
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	df2080e7          	jalr	-526(ra) # 512 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	0992                	slli	s3,s3,0x4
 72a:	397d                	addiw	s2,s2,-1
 72c:	fe0914e3          	bnez	s2,714 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 730:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 734:	4981                	li	s3,0
 736:	b721                	j	63e <vprintf+0x60>
        s = va_arg(ap, char*);
 738:	008b0993          	addi	s3,s6,8
 73c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 740:	02090163          	beqz	s2,762 <vprintf+0x184>
        while(*s != 0){
 744:	00094583          	lbu	a1,0(s2)
 748:	c9a1                	beqz	a1,798 <vprintf+0x1ba>
          putc(fd, *s);
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	dc6080e7          	jalr	-570(ra) # 512 <putc>
          s++;
 754:	0905                	addi	s2,s2,1
        while(*s != 0){
 756:	00094583          	lbu	a1,0(s2)
 75a:	f9e5                	bnez	a1,74a <vprintf+0x16c>
        s = va_arg(ap, char*);
 75c:	8b4e                	mv	s6,s3
      state = 0;
 75e:	4981                	li	s3,0
 760:	bdf9                	j	63e <vprintf+0x60>
          s = "(null)";
 762:	00000917          	auipc	s2,0x0
 766:	35e90913          	addi	s2,s2,862 # ac0 <malloc+0x218>
        while(*s != 0){
 76a:	02800593          	li	a1,40
 76e:	bff1                	j	74a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 770:	008b0913          	addi	s2,s6,8
 774:	000b4583          	lbu	a1,0(s6)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	d98080e7          	jalr	-616(ra) # 512 <putc>
 782:	8b4a                	mv	s6,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bd65                	j	63e <vprintf+0x60>
        putc(fd, c);
 788:	85d2                	mv	a1,s4
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	d86080e7          	jalr	-634(ra) # 512 <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	b565                	j	63e <vprintf+0x60>
        s = va_arg(ap, char*);
 798:	8b4e                	mv	s6,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b54d                	j	63e <vprintf+0x60>
    }
  }
}
 79e:	70e6                	ld	ra,120(sp)
 7a0:	7446                	ld	s0,112(sp)
 7a2:	74a6                	ld	s1,104(sp)
 7a4:	7906                	ld	s2,96(sp)
 7a6:	69e6                	ld	s3,88(sp)
 7a8:	6a46                	ld	s4,80(sp)
 7aa:	6aa6                	ld	s5,72(sp)
 7ac:	6b06                	ld	s6,64(sp)
 7ae:	7be2                	ld	s7,56(sp)
 7b0:	7c42                	ld	s8,48(sp)
 7b2:	7ca2                	ld	s9,40(sp)
 7b4:	7d02                	ld	s10,32(sp)
 7b6:	6de2                	ld	s11,24(sp)
 7b8:	6109                	addi	sp,sp,128
 7ba:	8082                	ret

00000000000007bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7bc:	715d                	addi	sp,sp,-80
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	e010                	sd	a2,0(s0)
 7c6:	e414                	sd	a3,8(s0)
 7c8:	e818                	sd	a4,16(s0)
 7ca:	ec1c                	sd	a5,24(s0)
 7cc:	03043023          	sd	a6,32(s0)
 7d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d8:	8622                	mv	a2,s0
 7da:	00000097          	auipc	ra,0x0
 7de:	e04080e7          	jalr	-508(ra) # 5de <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6161                	addi	sp,sp,80
 7e8:	8082                	ret

00000000000007ea <printf>:

void
printf(const char *fmt, ...)
{
 7ea:	711d                	addi	sp,sp,-96
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	e40c                	sd	a1,8(s0)
 7f4:	e810                	sd	a2,16(s0)
 7f6:	ec14                	sd	a3,24(s0)
 7f8:	f018                	sd	a4,32(s0)
 7fa:	f41c                	sd	a5,40(s0)
 7fc:	03043823          	sd	a6,48(s0)
 800:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 804:	00840613          	addi	a2,s0,8
 808:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80c:	85aa                	mv	a1,a0
 80e:	4505                	li	a0,1
 810:	00000097          	auipc	ra,0x0
 814:	dce080e7          	jalr	-562(ra) # 5de <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6125                	addi	sp,sp,96
 81e:	8082                	ret

0000000000000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	1141                	addi	sp,sp,-16
 822:	e422                	sd	s0,8(sp)
 824:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 826:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	00000797          	auipc	a5,0x0
 82e:	2b67b783          	ld	a5,694(a5) # ae0 <freep>
 832:	a805                	j	862 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 834:	4618                	lw	a4,8(a2)
 836:	9db9                	addw	a1,a1,a4
 838:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	6398                	ld	a4,0(a5)
 83e:	6318                	ld	a4,0(a4)
 840:	fee53823          	sd	a4,-16(a0)
 844:	a091                	j	888 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 846:	ff852703          	lw	a4,-8(a0)
 84a:	9e39                	addw	a2,a2,a4
 84c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 84e:	ff053703          	ld	a4,-16(a0)
 852:	e398                	sd	a4,0(a5)
 854:	a099                	j	89a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6398                	ld	a4,0(a5)
 858:	00e7e463          	bltu	a5,a4,860 <free+0x40>
 85c:	00e6ea63          	bltu	a3,a4,870 <free+0x50>
{
 860:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fed7fae3          	bgeu	a5,a3,856 <free+0x36>
 866:	6398                	ld	a4,0(a5)
 868:	00e6e463          	bltu	a3,a4,870 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	fee7eae3          	bltu	a5,a4,860 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 870:	ff852583          	lw	a1,-8(a0)
 874:	6390                	ld	a2,0(a5)
 876:	02059813          	slli	a6,a1,0x20
 87a:	01c85713          	srli	a4,a6,0x1c
 87e:	9736                	add	a4,a4,a3
 880:	fae60ae3          	beq	a2,a4,834 <free+0x14>
    bp->s.ptr = p->s.ptr;
 884:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 888:	4790                	lw	a2,8(a5)
 88a:	02061593          	slli	a1,a2,0x20
 88e:	01c5d713          	srli	a4,a1,0x1c
 892:	973e                	add	a4,a4,a5
 894:	fae689e3          	beq	a3,a4,846 <free+0x26>
  } else
    p->s.ptr = bp;
 898:	e394                	sd	a3,0(a5)
  freep = p;
 89a:	00000717          	auipc	a4,0x0
 89e:	24f73323          	sd	a5,582(a4) # ae0 <freep>
}
 8a2:	6422                	ld	s0,8(sp)
 8a4:	0141                	addi	sp,sp,16
 8a6:	8082                	ret

00000000000008a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a8:	7139                	addi	sp,sp,-64
 8aa:	fc06                	sd	ra,56(sp)
 8ac:	f822                	sd	s0,48(sp)
 8ae:	f426                	sd	s1,40(sp)
 8b0:	f04a                	sd	s2,32(sp)
 8b2:	ec4e                	sd	s3,24(sp)
 8b4:	e852                	sd	s4,16(sp)
 8b6:	e456                	sd	s5,8(sp)
 8b8:	e05a                	sd	s6,0(sp)
 8ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8bc:	02051493          	slli	s1,a0,0x20
 8c0:	9081                	srli	s1,s1,0x20
 8c2:	04bd                	addi	s1,s1,15
 8c4:	8091                	srli	s1,s1,0x4
 8c6:	0014899b          	addiw	s3,s1,1
 8ca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8cc:	00000517          	auipc	a0,0x0
 8d0:	21453503          	ld	a0,532(a0) # ae0 <freep>
 8d4:	c515                	beqz	a0,900 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d8:	4798                	lw	a4,8(a5)
 8da:	02977f63          	bgeu	a4,s1,918 <malloc+0x70>
 8de:	8a4e                	mv	s4,s3
 8e0:	0009871b          	sext.w	a4,s3
 8e4:	6685                	lui	a3,0x1
 8e6:	00d77363          	bgeu	a4,a3,8ec <malloc+0x44>
 8ea:	6a05                	lui	s4,0x1
 8ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f4:	00000917          	auipc	s2,0x0
 8f8:	1ec90913          	addi	s2,s2,492 # ae0 <freep>
  if(p == (char*)-1)
 8fc:	5afd                	li	s5,-1
 8fe:	a895                	j	972 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 900:	00000797          	auipc	a5,0x0
 904:	1e878793          	addi	a5,a5,488 # ae8 <base>
 908:	00000717          	auipc	a4,0x0
 90c:	1cf73c23          	sd	a5,472(a4) # ae0 <freep>
 910:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 912:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 916:	b7e1                	j	8de <malloc+0x36>
      if(p->s.size == nunits)
 918:	02e48c63          	beq	s1,a4,950 <malloc+0xa8>
        p->s.size -= nunits;
 91c:	4137073b          	subw	a4,a4,s3
 920:	c798                	sw	a4,8(a5)
        p += p->s.size;
 922:	02071693          	slli	a3,a4,0x20
 926:	01c6d713          	srli	a4,a3,0x1c
 92a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 930:	00000717          	auipc	a4,0x0
 934:	1aa73823          	sd	a0,432(a4) # ae0 <freep>
      return (void*)(p + 1);
 938:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 93c:	70e2                	ld	ra,56(sp)
 93e:	7442                	ld	s0,48(sp)
 940:	74a2                	ld	s1,40(sp)
 942:	7902                	ld	s2,32(sp)
 944:	69e2                	ld	s3,24(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	6121                	addi	sp,sp,64
 94e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 950:	6398                	ld	a4,0(a5)
 952:	e118                	sd	a4,0(a0)
 954:	bff1                	j	930 <malloc+0x88>
  hp->s.size = nu;
 956:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95a:	0541                	addi	a0,a0,16
 95c:	00000097          	auipc	ra,0x0
 960:	ec4080e7          	jalr	-316(ra) # 820 <free>
  return freep;
 964:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 968:	d971                	beqz	a0,93c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96c:	4798                	lw	a4,8(a5)
 96e:	fa9775e3          	bgeu	a4,s1,918 <malloc+0x70>
    if(p == freep)
 972:	00093703          	ld	a4,0(s2)
 976:	853e                	mv	a0,a5
 978:	fef719e3          	bne	a4,a5,96a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 97c:	8552                	mv	a0,s4
 97e:	00000097          	auipc	ra,0x0
 982:	b74080e7          	jalr	-1164(ra) # 4f2 <sbrk>
  if(p == (char*)-1)
 986:	fd5518e3          	bne	a0,s5,956 <malloc+0xae>
        return 0;
 98a:	4501                	li	a0,0
 98c:	bf45                	j	93c <malloc+0x94>
