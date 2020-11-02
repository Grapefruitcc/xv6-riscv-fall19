
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes_check>:


//�ݹ麯���������
//@input:�������������
//@number:���еĳ���
void primes_check(int *input, int number) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	0080                	addi	s0,sp,64
  10:	89aa                	mv	s3,a0
	//�ݹ��յ㣺ֻʣһ��number
	if (number == 1) {
  12:	4785                	li	a5,1
  14:	04f58263          	beq	a1,a5,58 <primes_check+0x58>
  18:	84ae                	mv	s1,a1
	}
	//�����ܵ�
	int p[2];
	int i = 0;
	int j = 0;
	pipe(p);
  1a:	fc840513          	addi	a0,s0,-56
  1e:	00000097          	auipc	ra,0x0
  22:	39e080e7          	jalr	926(ra) # 3bc <pipe>
	//���е�һλ��һ��������
	int prime = *input;
  26:	0009a903          	lw	s2,0(s3)
	//��ܵ��в��϶���temp
	int temp;
	int buffer[1];
	printf("prime %d\n", prime);
  2a:	85ca                	mv	a1,s2
  2c:	00001517          	auipc	a0,0x1
  30:	8a450513          	addi	a0,a0,-1884 # 8d0 <malloc+0xe6>
  34:	00000097          	auipc	ra,0x0
  38:	6f8080e7          	jalr	1784(ra) # 72c <printf>
	//�����ӽ���
	if (fork() == 0) {
  3c:	00000097          	auipc	ra,0x0
  40:	368080e7          	jalr	872(ra) # 3a4 <fork>
  44:	c505                	beqz	a0,6c <primes_check+0x6c>
			}
		}
		exit(0);
	}
	//�رչܵ�д
	close(p[1]);
  46:	fcc42503          	lw	a0,-52(s0)
  4a:	00000097          	auipc	ra,0x0
  4e:	38a080e7          	jalr	906(ra) # 3d4 <close>
	//�����ܵ��������������һ�ι���
	while (read(p[0], buffer, sizeof(int)) != 0) {
  52:	84ce                	mv	s1,s3
	int j = 0;
  54:	4901                	li	s2,0
	while (read(p[0], buffer, sizeof(int)) != 0) {
  56:	a0b5                	j	c2 <primes_check+0xc2>
		printf("prime %d\n", *input);
  58:	410c                	lw	a1,0(a0)
  5a:	00001517          	auipc	a0,0x1
  5e:	87650513          	addi	a0,a0,-1930 # 8d0 <malloc+0xe6>
  62:	00000097          	auipc	ra,0x0
  66:	6ca080e7          	jalr	1738(ra) # 72c <printf>
		return;
  6a:	a079                	j	f8 <primes_check+0xf8>
		for (i = 0; i < number; i++) {
  6c:	02905f63          	blez	s1,aa <primes_check+0xaa>
  70:	8a4e                	mv	s4,s3
  72:	34fd                	addiw	s1,s1,-1
  74:	02049793          	slli	a5,s1,0x20
  78:	01e7d493          	srli	s1,a5,0x1e
  7c:	0991                	addi	s3,s3,4
  7e:	94ce                	add	s1,s1,s3
  80:	a021                	j	88 <primes_check+0x88>
  82:	0a11                	addi	s4,s4,4
  84:	029a0363          	beq	s4,s1,aa <primes_check+0xaa>
			temp = *(input + i);
  88:	000a2783          	lw	a5,0(s4)
  8c:	fcf42223          	sw	a5,-60(s0)
			if (temp % prime != 0) {
  90:	0327e7bb          	remw	a5,a5,s2
  94:	d7fd                	beqz	a5,82 <primes_check+0x82>
				write(p[1], &temp, sizeof(int));
  96:	4611                	li	a2,4
  98:	fc440593          	addi	a1,s0,-60
  9c:	fcc42503          	lw	a0,-52(s0)
  a0:	00000097          	auipc	ra,0x0
  a4:	32c080e7          	jalr	812(ra) # 3cc <write>
  a8:	bfe9                	j	82 <primes_check+0x82>
		exit(0);
  aa:	4501                	li	a0,0
  ac:	00000097          	auipc	ra,0x0
  b0:	300080e7          	jalr	768(ra) # 3ac <exit>
		temp = *buffer;
  b4:	fc042783          	lw	a5,-64(s0)
  b8:	fcf42223          	sw	a5,-60(s0)
		*(input + j) = temp;
  bc:	c09c                	sw	a5,0(s1)
		j++;
  be:	2905                	addiw	s2,s2,1
  c0:	0491                	addi	s1,s1,4
	while (read(p[0], buffer, sizeof(int)) != 0) {
  c2:	4611                	li	a2,4
  c4:	fc040593          	addi	a1,s0,-64
  c8:	fc842503          	lw	a0,-56(s0)
  cc:	00000097          	auipc	ra,0x0
  d0:	2f8080e7          	jalr	760(ra) # 3c4 <read>
  d4:	f165                	bnez	a0,b4 <primes_check+0xb4>
	}
	close(p[0]);
  d6:	fc842503          	lw	a0,-56(s0)
  da:	00000097          	auipc	ra,0x0
  de:	2fa080e7          	jalr	762(ra) # 3d4 <close>
	wait(0);
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	2d0080e7          	jalr	720(ra) # 3b4 <wait>
	primes_check(input, j);
  ec:	85ca                	mv	a1,s2
  ee:	854e                	mv	a0,s3
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <primes_check>
}
  f8:	70e2                	ld	ra,56(sp)
  fa:	7442                	ld	s0,48(sp)
  fc:	74a2                	ld	s1,40(sp)
  fe:	7902                	ld	s2,32(sp)
 100:	69e2                	ld	s3,24(sp)
 102:	6a42                	ld	s4,16(sp)
 104:	6121                	addi	sp,sp,64
 106:	8082                	ret

0000000000000108 <main>:

int main() {
 108:	7135                	addi	sp,sp,-160
 10a:	ed06                	sd	ra,152(sp)
 10c:	e922                	sd	s0,144(sp)
 10e:	1100                	addi	s0,sp,160
	int input[34];
	int i = 0;
	for (i = 0; i < 34; i++) {
 110:	f6840793          	addi	a5,s0,-152
 114:	ff040693          	addi	a3,s0,-16
int main() {
 118:	4709                	li	a4,2
		input[i] = i + 2;
 11a:	c398                	sw	a4,0(a5)
	for (i = 0; i < 34; i++) {
 11c:	2705                	addiw	a4,a4,1
 11e:	0791                	addi	a5,a5,4
 120:	fed79de3          	bne	a5,a3,11a <main+0x12>
	}
	primes_check(input, i);
 124:	02200593          	li	a1,34
 128:	f6840513          	addi	a0,s0,-152
 12c:	00000097          	auipc	ra,0x0
 130:	ed4080e7          	jalr	-300(ra) # 0 <primes_check>
	exit(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	276080e7          	jalr	630(ra) # 3ac <exit>

000000000000013e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 144:	87aa                	mv	a5,a0
 146:	0585                	addi	a1,a1,1
 148:	0785                	addi	a5,a5,1
 14a:	fff5c703          	lbu	a4,-1(a1)
 14e:	fee78fa3          	sb	a4,-1(a5)
 152:	fb75                	bnez	a4,146 <strcpy+0x8>
    ;
  return os;
}
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 160:	00054783          	lbu	a5,0(a0)
 164:	cb91                	beqz	a5,178 <strcmp+0x1e>
 166:	0005c703          	lbu	a4,0(a1)
 16a:	00f71763          	bne	a4,a5,178 <strcmp+0x1e>
    p++, q++;
 16e:	0505                	addi	a0,a0,1
 170:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 172:	00054783          	lbu	a5,0(a0)
 176:	fbe5                	bnez	a5,166 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 178:	0005c503          	lbu	a0,0(a1)
}
 17c:	40a7853b          	subw	a0,a5,a0
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strlen>:

uint
strlen(const char *s)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18c:	00054783          	lbu	a5,0(a0)
 190:	cf91                	beqz	a5,1ac <strlen+0x26>
 192:	0505                	addi	a0,a0,1
 194:	87aa                	mv	a5,a0
 196:	4685                	li	a3,1
 198:	9e89                	subw	a3,a3,a0
 19a:	00f6853b          	addw	a0,a3,a5
 19e:	0785                	addi	a5,a5,1
 1a0:	fff7c703          	lbu	a4,-1(a5)
 1a4:	fb7d                	bnez	a4,19a <strlen+0x14>
    ;
  return n;
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  for(n = 0; s[n]; n++)
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strlen+0x20>

00000000000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b6:	ca19                	beqz	a2,1cc <memset+0x1c>
 1b8:	87aa                	mv	a5,a0
 1ba:	1602                	slli	a2,a2,0x20
 1bc:	9201                	srli	a2,a2,0x20
 1be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c6:	0785                	addi	a5,a5,1
 1c8:	fee79de3          	bne	a5,a4,1c2 <memset+0x12>
  }
  return dst;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strchr>:

char*
strchr(const char *s, char c)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cb99                	beqz	a5,1f2 <strchr+0x20>
    if(*s == c)
 1de:	00f58763          	beq	a1,a5,1ec <strchr+0x1a>
  for(; *s; s++)
 1e2:	0505                	addi	a0,a0,1
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbfd                	bnez	a5,1de <strchr+0xc>
      return (char*)s;
  return 0;
 1ea:	4501                	li	a0,0
}
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  return 0;
 1f2:	4501                	li	a0,0
 1f4:	bfe5                	j	1ec <strchr+0x1a>

00000000000001f6 <gets>:

char*
gets(char *buf, int max)
{
 1f6:	711d                	addi	sp,sp,-96
 1f8:	ec86                	sd	ra,88(sp)
 1fa:	e8a2                	sd	s0,80(sp)
 1fc:	e4a6                	sd	s1,72(sp)
 1fe:	e0ca                	sd	s2,64(sp)
 200:	fc4e                	sd	s3,56(sp)
 202:	f852                	sd	s4,48(sp)
 204:	f456                	sd	s5,40(sp)
 206:	f05a                	sd	s6,32(sp)
 208:	ec5e                	sd	s7,24(sp)
 20a:	1080                	addi	s0,sp,96
 20c:	8baa                	mv	s7,a0
 20e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	892a                	mv	s2,a0
 212:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 214:	4aa9                	li	s5,10
 216:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 218:	89a6                	mv	s3,s1
 21a:	2485                	addiw	s1,s1,1
 21c:	0344d863          	bge	s1,s4,24c <gets+0x56>
    cc = read(0, &c, 1);
 220:	4605                	li	a2,1
 222:	faf40593          	addi	a1,s0,-81
 226:	4501                	li	a0,0
 228:	00000097          	auipc	ra,0x0
 22c:	19c080e7          	jalr	412(ra) # 3c4 <read>
    if(cc < 1)
 230:	00a05e63          	blez	a0,24c <gets+0x56>
    buf[i++] = c;
 234:	faf44783          	lbu	a5,-81(s0)
 238:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23c:	01578763          	beq	a5,s5,24a <gets+0x54>
 240:	0905                	addi	s2,s2,1
 242:	fd679be3          	bne	a5,s6,218 <gets+0x22>
  for(i=0; i+1 < max; ){
 246:	89a6                	mv	s3,s1
 248:	a011                	j	24c <gets+0x56>
 24a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24c:	99de                	add	s3,s3,s7
 24e:	00098023          	sb	zero,0(s3)
  return buf;
}
 252:	855e                	mv	a0,s7
 254:	60e6                	ld	ra,88(sp)
 256:	6446                	ld	s0,80(sp)
 258:	64a6                	ld	s1,72(sp)
 25a:	6906                	ld	s2,64(sp)
 25c:	79e2                	ld	s3,56(sp)
 25e:	7a42                	ld	s4,48(sp)
 260:	7aa2                	ld	s5,40(sp)
 262:	7b02                	ld	s6,32(sp)
 264:	6be2                	ld	s7,24(sp)
 266:	6125                	addi	sp,sp,96
 268:	8082                	ret

000000000000026a <stat>:

int
stat(const char *n, struct stat *st)
{
 26a:	1101                	addi	sp,sp,-32
 26c:	ec06                	sd	ra,24(sp)
 26e:	e822                	sd	s0,16(sp)
 270:	e426                	sd	s1,8(sp)
 272:	e04a                	sd	s2,0(sp)
 274:	1000                	addi	s0,sp,32
 276:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 278:	4581                	li	a1,0
 27a:	00000097          	auipc	ra,0x0
 27e:	172080e7          	jalr	370(ra) # 3ec <open>
  if(fd < 0)
 282:	02054563          	bltz	a0,2ac <stat+0x42>
 286:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 288:	85ca                	mv	a1,s2
 28a:	00000097          	auipc	ra,0x0
 28e:	17a080e7          	jalr	378(ra) # 404 <fstat>
 292:	892a                	mv	s2,a0
  close(fd);
 294:	8526                	mv	a0,s1
 296:	00000097          	auipc	ra,0x0
 29a:	13e080e7          	jalr	318(ra) # 3d4 <close>
  return r;
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	64a2                	ld	s1,8(sp)
 2a6:	6902                	ld	s2,0(sp)
 2a8:	6105                	addi	sp,sp,32
 2aa:	8082                	ret
    return -1;
 2ac:	597d                	li	s2,-1
 2ae:	bfc5                	j	29e <stat+0x34>

00000000000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b6:	00054603          	lbu	a2,0(a0)
 2ba:	fd06079b          	addiw	a5,a2,-48
 2be:	0ff7f793          	andi	a5,a5,255
 2c2:	4725                	li	a4,9
 2c4:	02f76963          	bltu	a4,a5,2f6 <atoi+0x46>
 2c8:	86aa                	mv	a3,a0
  n = 0;
 2ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ce:	0685                	addi	a3,a3,1
 2d0:	0025179b          	slliw	a5,a0,0x2
 2d4:	9fa9                	addw	a5,a5,a0
 2d6:	0017979b          	slliw	a5,a5,0x1
 2da:	9fb1                	addw	a5,a5,a2
 2dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e0:	0006c603          	lbu	a2,0(a3)
 2e4:	fd06071b          	addiw	a4,a2,-48
 2e8:	0ff77713          	andi	a4,a4,255
 2ec:	fee5f1e3          	bgeu	a1,a4,2ce <atoi+0x1e>
  return n;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  n = 0;
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <atoi+0x40>

00000000000002fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 300:	02b57463          	bgeu	a0,a1,328 <memmove+0x2e>
    while(n-- > 0)
 304:	00c05f63          	blez	a2,322 <memmove+0x28>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 310:	872a                	mv	a4,a0
      *dst++ = *src++;
 312:	0585                	addi	a1,a1,1
 314:	0705                	addi	a4,a4,1
 316:	fff5c683          	lbu	a3,-1(a1)
 31a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
    dst += n;
 328:	00c50733          	add	a4,a0,a2
    src += n;
 32c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32e:	fec05ae3          	blez	a2,322 <memmove+0x28>
 332:	fff6079b          	addiw	a5,a2,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	fff7c793          	not	a5,a5
 33e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 340:	15fd                	addi	a1,a1,-1
 342:	177d                	addi	a4,a4,-1
 344:	0005c683          	lbu	a3,0(a1)
 348:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34c:	fee79ae3          	bne	a5,a4,340 <memmove+0x46>
 350:	bfc9                	j	322 <memmove+0x28>

0000000000000352 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 358:	ca05                	beqz	a2,388 <memcmp+0x36>
 35a:	fff6069b          	addiw	a3,a2,-1
 35e:	1682                	slli	a3,a3,0x20
 360:	9281                	srli	a3,a3,0x20
 362:	0685                	addi	a3,a3,1
 364:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 366:	00054783          	lbu	a5,0(a0)
 36a:	0005c703          	lbu	a4,0(a1)
 36e:	00e79863          	bne	a5,a4,37e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 372:	0505                	addi	a0,a0,1
    p2++;
 374:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 376:	fed518e3          	bne	a0,a3,366 <memcmp+0x14>
  }
  return 0;
 37a:	4501                	li	a0,0
 37c:	a019                	j	382 <memcmp+0x30>
      return *p1 - *p2;
 37e:	40e7853b          	subw	a0,a5,a4
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  return 0;
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <memcmp+0x30>

000000000000038c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e406                	sd	ra,8(sp)
 390:	e022                	sd	s0,0(sp)
 392:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 394:	00000097          	auipc	ra,0x0
 398:	f66080e7          	jalr	-154(ra) # 2fa <memmove>
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a4:	4885                	li	a7,1
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ac:	4889                	li	a7,2
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b4:	488d                	li	a7,3
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3bc:	4891                	li	a7,4
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <read>:
.global read
read:
 li a7, SYS_read
 3c4:	4895                	li	a7,5
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <write>:
.global write
write:
 li a7, SYS_write
 3cc:	48c1                	li	a7,16
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <close>:
.global close
close:
 li a7, SYS_close
 3d4:	48d5                	li	a7,21
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3dc:	4899                	li	a7,6
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e4:	489d                	li	a7,7
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	48bd                	li	a7,15
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f4:	48c5                	li	a7,17
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fc:	48c9                	li	a7,18
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 404:	48a1                	li	a7,8
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <link>:
.global link
link:
 li a7, SYS_link
 40c:	48cd                	li	a7,19
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 414:	48d1                	li	a7,20
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41c:	48a5                	li	a7,9
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <dup>:
.global dup
dup:
 li a7, SYS_dup
 424:	48a9                	li	a7,10
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42c:	48ad                	li	a7,11
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 434:	48b1                	li	a7,12
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43c:	48b5                	li	a7,13
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 444:	48b9                	li	a7,14
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 44c:	48d9                	li	a7,22
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	00000097          	auipc	ra,0x0
 46a:	f66080e7          	jalr	-154(ra) # 3cc <write>
}
 46e:	60e2                	ld	ra,24(sp)
 470:	6442                	ld	s0,16(sp)
 472:	6105                	addi	sp,sp,32
 474:	8082                	ret

0000000000000476 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 476:	7139                	addi	sp,sp,-64
 478:	fc06                	sd	ra,56(sp)
 47a:	f822                	sd	s0,48(sp)
 47c:	f426                	sd	s1,40(sp)
 47e:	f04a                	sd	s2,32(sp)
 480:	ec4e                	sd	s3,24(sp)
 482:	0080                	addi	s0,sp,64
 484:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 486:	c299                	beqz	a3,48c <printint+0x16>
 488:	0805c863          	bltz	a1,518 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48c:	2581                	sext.w	a1,a1
  neg = 0;
 48e:	4881                	li	a7,0
 490:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 494:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 496:	2601                	sext.w	a2,a2
 498:	00000517          	auipc	a0,0x0
 49c:	45050513          	addi	a0,a0,1104 # 8e8 <digits>
 4a0:	883a                	mv	a6,a4
 4a2:	2705                	addiw	a4,a4,1
 4a4:	02c5f7bb          	remuw	a5,a1,a2
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	97aa                	add	a5,a5,a0
 4ae:	0007c783          	lbu	a5,0(a5)
 4b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b6:	0005879b          	sext.w	a5,a1
 4ba:	02c5d5bb          	divuw	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fec7f0e3          	bgeu	a5,a2,4a0 <printint+0x2a>
  if(neg)
 4c4:	00088b63          	beqz	a7,4da <printint+0x64>
    buf[i++] = '-';
 4c8:	fd040793          	addi	a5,s0,-48
 4cc:	973e                	add	a4,a4,a5
 4ce:	02d00793          	li	a5,45
 4d2:	fef70823          	sb	a5,-16(a4)
 4d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4da:	02e05863          	blez	a4,50a <printint+0x94>
 4de:	fc040793          	addi	a5,s0,-64
 4e2:	00e78933          	add	s2,a5,a4
 4e6:	fff78993          	addi	s3,a5,-1
 4ea:	99ba                	add	s3,s3,a4
 4ec:	377d                	addiw	a4,a4,-1
 4ee:	1702                	slli	a4,a4,0x20
 4f0:	9301                	srli	a4,a4,0x20
 4f2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f6:	fff94583          	lbu	a1,-1(s2)
 4fa:	8526                	mv	a0,s1
 4fc:	00000097          	auipc	ra,0x0
 500:	f58080e7          	jalr	-168(ra) # 454 <putc>
  while(--i >= 0)
 504:	197d                	addi	s2,s2,-1
 506:	ff3918e3          	bne	s2,s3,4f6 <printint+0x80>
}
 50a:	70e2                	ld	ra,56(sp)
 50c:	7442                	ld	s0,48(sp)
 50e:	74a2                	ld	s1,40(sp)
 510:	7902                	ld	s2,32(sp)
 512:	69e2                	ld	s3,24(sp)
 514:	6121                	addi	sp,sp,64
 516:	8082                	ret
    x = -xx;
 518:	40b005bb          	negw	a1,a1
    neg = 1;
 51c:	4885                	li	a7,1
    x = -xx;
 51e:	bf8d                	j	490 <printint+0x1a>

0000000000000520 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 520:	7119                	addi	sp,sp,-128
 522:	fc86                	sd	ra,120(sp)
 524:	f8a2                	sd	s0,112(sp)
 526:	f4a6                	sd	s1,104(sp)
 528:	f0ca                	sd	s2,96(sp)
 52a:	ecce                	sd	s3,88(sp)
 52c:	e8d2                	sd	s4,80(sp)
 52e:	e4d6                	sd	s5,72(sp)
 530:	e0da                	sd	s6,64(sp)
 532:	fc5e                	sd	s7,56(sp)
 534:	f862                	sd	s8,48(sp)
 536:	f466                	sd	s9,40(sp)
 538:	f06a                	sd	s10,32(sp)
 53a:	ec6e                	sd	s11,24(sp)
 53c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53e:	0005c903          	lbu	s2,0(a1)
 542:	18090f63          	beqz	s2,6e0 <vprintf+0x1c0>
 546:	8aaa                	mv	s5,a0
 548:	8b32                	mv	s6,a2
 54a:	00158493          	addi	s1,a1,1
  state = 0;
 54e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 550:	02500a13          	li	s4,37
      if(c == 'd'){
 554:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 558:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 55c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 560:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 564:	00000b97          	auipc	s7,0x0
 568:	384b8b93          	addi	s7,s7,900 # 8e8 <digits>
 56c:	a839                	j	58a <vprintf+0x6a>
        putc(fd, c);
 56e:	85ca                	mv	a1,s2
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	ee2080e7          	jalr	-286(ra) # 454 <putc>
 57a:	a019                	j	580 <vprintf+0x60>
    } else if(state == '%'){
 57c:	01498f63          	beq	s3,s4,59a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 580:	0485                	addi	s1,s1,1
 582:	fff4c903          	lbu	s2,-1(s1)
 586:	14090d63          	beqz	s2,6e0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 58a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 58e:	fe0997e3          	bnez	s3,57c <vprintf+0x5c>
      if(c == '%'){
 592:	fd479ee3          	bne	a5,s4,56e <vprintf+0x4e>
        state = '%';
 596:	89be                	mv	s3,a5
 598:	b7e5                	j	580 <vprintf+0x60>
      if(c == 'd'){
 59a:	05878063          	beq	a5,s8,5da <vprintf+0xba>
      } else if(c == 'l') {
 59e:	05978c63          	beq	a5,s9,5f6 <vprintf+0xd6>
      } else if(c == 'x') {
 5a2:	07a78863          	beq	a5,s10,612 <vprintf+0xf2>
      } else if(c == 'p') {
 5a6:	09b78463          	beq	a5,s11,62e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5aa:	07300713          	li	a4,115
 5ae:	0ce78663          	beq	a5,a4,67a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b2:	06300713          	li	a4,99
 5b6:	0ee78e63          	beq	a5,a4,6b2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ba:	11478863          	beq	a5,s4,6ca <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5be:	85d2                	mv	a1,s4
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e92080e7          	jalr	-366(ra) # 454 <putc>
        putc(fd, c);
 5ca:	85ca                	mv	a1,s2
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e86080e7          	jalr	-378(ra) # 454 <putc>
      }
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b765                	j	580 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5da:	008b0913          	addi	s2,s6,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000b2583          	lw	a1,0(s6)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e8e080e7          	jalr	-370(ra) # 476 <printint>
 5f0:	8b4a                	mv	s6,s2
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b771                	j	580 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b0913          	addi	s2,s6,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000b2583          	lw	a1,0(s6)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e72080e7          	jalr	-398(ra) # 476 <printint>
 60c:	8b4a                	mv	s6,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	bf85                	j	580 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 612:	008b0913          	addi	s2,s6,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000b2583          	lw	a1,0(s6)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e56080e7          	jalr	-426(ra) # 476 <printint>
 628:	8b4a                	mv	s6,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bf91                	j	580 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 62e:	008b0793          	addi	a5,s6,8
 632:	f8f43423          	sd	a5,-120(s0)
 636:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 63a:	03000593          	li	a1,48
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e14080e7          	jalr	-492(ra) # 454 <putc>
  putc(fd, 'x');
 648:	85ea                	mv	a1,s10
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e08080e7          	jalr	-504(ra) # 454 <putc>
 654:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 656:	03c9d793          	srli	a5,s3,0x3c
 65a:	97de                	add	a5,a5,s7
 65c:	0007c583          	lbu	a1,0(a5)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	df2080e7          	jalr	-526(ra) # 454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 66a:	0992                	slli	s3,s3,0x4
 66c:	397d                	addiw	s2,s2,-1
 66e:	fe0914e3          	bnez	s2,656 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 672:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 676:	4981                	li	s3,0
 678:	b721                	j	580 <vprintf+0x60>
        s = va_arg(ap, char*);
 67a:	008b0993          	addi	s3,s6,8
 67e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 682:	02090163          	beqz	s2,6a4 <vprintf+0x184>
        while(*s != 0){
 686:	00094583          	lbu	a1,0(s2)
 68a:	c9a1                	beqz	a1,6da <vprintf+0x1ba>
          putc(fd, *s);
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	dc6080e7          	jalr	-570(ra) # 454 <putc>
          s++;
 696:	0905                	addi	s2,s2,1
        while(*s != 0){
 698:	00094583          	lbu	a1,0(s2)
 69c:	f9e5                	bnez	a1,68c <vprintf+0x16c>
        s = va_arg(ap, char*);
 69e:	8b4e                	mv	s6,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bdf9                	j	580 <vprintf+0x60>
          s = "(null)";
 6a4:	00000917          	auipc	s2,0x0
 6a8:	23c90913          	addi	s2,s2,572 # 8e0 <malloc+0xf6>
        while(*s != 0){
 6ac:	02800593          	li	a1,40
 6b0:	bff1                	j	68c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6b2:	008b0913          	addi	s2,s6,8
 6b6:	000b4583          	lbu	a1,0(s6)
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d98080e7          	jalr	-616(ra) # 454 <putc>
 6c4:	8b4a                	mv	s6,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd65                	j	580 <vprintf+0x60>
        putc(fd, c);
 6ca:	85d2                	mv	a1,s4
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	d86080e7          	jalr	-634(ra) # 454 <putc>
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b565                	j	580 <vprintf+0x60>
        s = va_arg(ap, char*);
 6da:	8b4e                	mv	s6,s3
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b54d                	j	580 <vprintf+0x60>
    }
  }
}
 6e0:	70e6                	ld	ra,120(sp)
 6e2:	7446                	ld	s0,112(sp)
 6e4:	74a6                	ld	s1,104(sp)
 6e6:	7906                	ld	s2,96(sp)
 6e8:	69e6                	ld	s3,88(sp)
 6ea:	6a46                	ld	s4,80(sp)
 6ec:	6aa6                	ld	s5,72(sp)
 6ee:	6b06                	ld	s6,64(sp)
 6f0:	7be2                	ld	s7,56(sp)
 6f2:	7c42                	ld	s8,48(sp)
 6f4:	7ca2                	ld	s9,40(sp)
 6f6:	7d02                	ld	s10,32(sp)
 6f8:	6de2                	ld	s11,24(sp)
 6fa:	6109                	addi	sp,sp,128
 6fc:	8082                	ret

00000000000006fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fe:	715d                	addi	sp,sp,-80
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	e010                	sd	a2,0(s0)
 708:	e414                	sd	a3,8(s0)
 70a:	e818                	sd	a4,16(s0)
 70c:	ec1c                	sd	a5,24(s0)
 70e:	03043023          	sd	a6,32(s0)
 712:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 716:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71a:	8622                	mv	a2,s0
 71c:	00000097          	auipc	ra,0x0
 720:	e04080e7          	jalr	-508(ra) # 520 <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6161                	addi	sp,sp,80
 72a:	8082                	ret

000000000000072c <printf>:

void
printf(const char *fmt, ...)
{
 72c:	711d                	addi	sp,sp,-96
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e40c                	sd	a1,8(s0)
 736:	e810                	sd	a2,16(s0)
 738:	ec14                	sd	a3,24(s0)
 73a:	f018                	sd	a4,32(s0)
 73c:	f41c                	sd	a5,40(s0)
 73e:	03043823          	sd	a6,48(s0)
 742:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	00840613          	addi	a2,s0,8
 74a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74e:	85aa                	mv	a1,a0
 750:	4505                	li	a0,1
 752:	00000097          	auipc	ra,0x0
 756:	dce080e7          	jalr	-562(ra) # 520 <vprintf>
}
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	6125                	addi	sp,sp,96
 760:	8082                	ret

0000000000000762 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 762:	1141                	addi	sp,sp,-16
 764:	e422                	sd	s0,8(sp)
 766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	00000797          	auipc	a5,0x0
 770:	1947b783          	ld	a5,404(a5) # 900 <freep>
 774:	a805                	j	7a4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 776:	4618                	lw	a4,8(a2)
 778:	9db9                	addw	a1,a1,a4
 77a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	6398                	ld	a4,0(a5)
 780:	6318                	ld	a4,0(a4)
 782:	fee53823          	sd	a4,-16(a0)
 786:	a091                	j	7ca <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 788:	ff852703          	lw	a4,-8(a0)
 78c:	9e39                	addw	a2,a2,a4
 78e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 790:	ff053703          	ld	a4,-16(a0)
 794:	e398                	sd	a4,0(a5)
 796:	a099                	j	7dc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	6398                	ld	a4,0(a5)
 79a:	00e7e463          	bltu	a5,a4,7a2 <free+0x40>
 79e:	00e6ea63          	bltu	a3,a4,7b2 <free+0x50>
{
 7a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	fed7fae3          	bgeu	a5,a3,798 <free+0x36>
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e6e463          	bltu	a3,a4,7b2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ae:	fee7eae3          	bltu	a5,a4,7a2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7b2:	ff852583          	lw	a1,-8(a0)
 7b6:	6390                	ld	a2,0(a5)
 7b8:	02059813          	slli	a6,a1,0x20
 7bc:	01c85713          	srli	a4,a6,0x1c
 7c0:	9736                	add	a4,a4,a3
 7c2:	fae60ae3          	beq	a2,a4,776 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7c6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ca:	4790                	lw	a2,8(a5)
 7cc:	02061593          	slli	a1,a2,0x20
 7d0:	01c5d713          	srli	a4,a1,0x1c
 7d4:	973e                	add	a4,a4,a5
 7d6:	fae689e3          	beq	a3,a4,788 <free+0x26>
  } else
    p->s.ptr = bp;
 7da:	e394                	sd	a3,0(a5)
  freep = p;
 7dc:	00000717          	auipc	a4,0x0
 7e0:	12f73223          	sd	a5,292(a4) # 900 <freep>
}
 7e4:	6422                	ld	s0,8(sp)
 7e6:	0141                	addi	sp,sp,16
 7e8:	8082                	ret

00000000000007ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ea:	7139                	addi	sp,sp,-64
 7ec:	fc06                	sd	ra,56(sp)
 7ee:	f822                	sd	s0,48(sp)
 7f0:	f426                	sd	s1,40(sp)
 7f2:	f04a                	sd	s2,32(sp)
 7f4:	ec4e                	sd	s3,24(sp)
 7f6:	e852                	sd	s4,16(sp)
 7f8:	e456                	sd	s5,8(sp)
 7fa:	e05a                	sd	s6,0(sp)
 7fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fe:	02051493          	slli	s1,a0,0x20
 802:	9081                	srli	s1,s1,0x20
 804:	04bd                	addi	s1,s1,15
 806:	8091                	srli	s1,s1,0x4
 808:	0014899b          	addiw	s3,s1,1
 80c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80e:	00000517          	auipc	a0,0x0
 812:	0f253503          	ld	a0,242(a0) # 900 <freep>
 816:	c515                	beqz	a0,842 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	02977f63          	bgeu	a4,s1,85a <malloc+0x70>
 820:	8a4e                	mv	s4,s3
 822:	0009871b          	sext.w	a4,s3
 826:	6685                	lui	a3,0x1
 828:	00d77363          	bgeu	a4,a3,82e <malloc+0x44>
 82c:	6a05                	lui	s4,0x1
 82e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 832:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 836:	00000917          	auipc	s2,0x0
 83a:	0ca90913          	addi	s2,s2,202 # 900 <freep>
  if(p == (char*)-1)
 83e:	5afd                	li	s5,-1
 840:	a895                	j	8b4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 842:	00000797          	auipc	a5,0x0
 846:	0c678793          	addi	a5,a5,198 # 908 <base>
 84a:	00000717          	auipc	a4,0x0
 84e:	0af73b23          	sd	a5,182(a4) # 900 <freep>
 852:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 854:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 858:	b7e1                	j	820 <malloc+0x36>
      if(p->s.size == nunits)
 85a:	02e48c63          	beq	s1,a4,892 <malloc+0xa8>
        p->s.size -= nunits;
 85e:	4137073b          	subw	a4,a4,s3
 862:	c798                	sw	a4,8(a5)
        p += p->s.size;
 864:	02071693          	slli	a3,a4,0x20
 868:	01c6d713          	srli	a4,a3,0x1c
 86c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 872:	00000717          	auipc	a4,0x0
 876:	08a73723          	sd	a0,142(a4) # 900 <freep>
      return (void*)(p + 1);
 87a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	74a2                	ld	s1,40(sp)
 884:	7902                	ld	s2,32(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	e118                	sd	a4,0(a0)
 896:	bff1                	j	872 <malloc+0x88>
  hp->s.size = nu;
 898:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89c:	0541                	addi	a0,a0,16
 89e:	00000097          	auipc	ra,0x0
 8a2:	ec4080e7          	jalr	-316(ra) # 762 <free>
  return freep;
 8a6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8aa:	d971                	beqz	a0,87e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	fa9775e3          	bgeu	a4,s1,85a <malloc+0x70>
    if(p == freep)
 8b4:	00093703          	ld	a4,0(s2)
 8b8:	853e                	mv	a0,a5
 8ba:	fef719e3          	bne	a4,a5,8ac <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8be:	8552                	mv	a0,s4
 8c0:	00000097          	auipc	ra,0x0
 8c4:	b74080e7          	jalr	-1164(ra) # 434 <sbrk>
  if(p == (char*)-1)
 8c8:	fd5518e3          	bne	a0,s5,898 <malloc+0xae>
        return 0;
 8cc:	4501                	li	a0,0
 8ce:	bf45                	j	87e <malloc+0x94>
