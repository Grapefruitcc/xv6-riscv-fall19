
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  char buf[BSIZE];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  20:	20100593          	li	a1,513
  24:	00001517          	auipc	a0,0x1
  28:	8f450513          	addi	a0,a0,-1804 # 918 <malloc+0xe6>
  2c:	00000097          	auipc	ra,0x0
  30:	408080e7          	jalr	1032(ra) # 434 <open>
  if(fd < 0){
  34:	04054463          	bltz	a0,7c <main+0x7c>
  38:	892a                	mv	s2,a0
  3a:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  3c:	06400993          	li	s3,100
      printf(".");
  40:	00001a17          	auipc	s4,0x1
  44:	918a0a13          	addi	s4,s4,-1768 # 958 <malloc+0x126>
    *(int*)buf = blocks;
  48:	bc942823          	sw	s1,-1072(s0)
    int cc = write(fd, buf, sizeof(buf));
  4c:	40000613          	li	a2,1024
  50:	bd040593          	addi	a1,s0,-1072
  54:	854a                	mv	a0,s2
  56:	00000097          	auipc	ra,0x0
  5a:	3be080e7          	jalr	958(ra) # 414 <write>
    if(cc <= 0)
  5e:	02a05c63          	blez	a0,96 <main+0x96>
    blocks++;
  62:	0014879b          	addiw	a5,s1,1
  66:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  6a:	0337e7bb          	remw	a5,a5,s3
  6e:	ffe9                	bnez	a5,48 <main+0x48>
      printf(".");
  70:	8552                	mv	a0,s4
  72:	00000097          	auipc	ra,0x0
  76:	702080e7          	jalr	1794(ra) # 774 <printf>
  7a:	b7f9                	j	48 <main+0x48>
    printf("bigfile: cannot open big.file for writing\n");
  7c:	00001517          	auipc	a0,0x1
  80:	8ac50513          	addi	a0,a0,-1876 # 928 <malloc+0xf6>
  84:	00000097          	auipc	ra,0x0
  88:	6f0080e7          	jalr	1776(ra) # 774 <printf>
    exit(-1);
  8c:	557d                	li	a0,-1
  8e:	00000097          	auipc	ra,0x0
  92:	366080e7          	jalr	870(ra) # 3f4 <exit>
  }

  printf("\nwrote %d blocks\n", blocks);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8c850513          	addi	a0,a0,-1848 # 960 <malloc+0x12e>
  a0:	00000097          	auipc	ra,0x0
  a4:	6d4080e7          	jalr	1748(ra) # 774 <printf>
  if(blocks != 65803) {
  a8:	67c1                	lui	a5,0x10
  aa:	10b78793          	addi	a5,a5,267 # 1010b <__global_pointer$+0xeeba>
  ae:	00f48f63          	beq	s1,a5,cc <main+0xcc>
    printf("bigfile: file is too small\n");
  b2:	00001517          	auipc	a0,0x1
  b6:	8c650513          	addi	a0,a0,-1850 # 978 <malloc+0x146>
  ba:	00000097          	auipc	ra,0x0
  be:	6ba080e7          	jalr	1722(ra) # 774 <printf>
    exit(-1);
  c2:	557d                	li	a0,-1
  c4:	00000097          	auipc	ra,0x0
  c8:	330080e7          	jalr	816(ra) # 3f4 <exit>
  }
  
  close(fd);
  cc:	854a                	mv	a0,s2
  ce:	00000097          	auipc	ra,0x0
  d2:	34e080e7          	jalr	846(ra) # 41c <close>
  fd = open("big.file", O_RDONLY);
  d6:	4581                	li	a1,0
  d8:	00001517          	auipc	a0,0x1
  dc:	84050513          	addi	a0,a0,-1984 # 918 <malloc+0xe6>
  e0:	00000097          	auipc	ra,0x0
  e4:	354080e7          	jalr	852(ra) # 434 <open>
  e8:	892a                	mv	s2,a0
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for(i = 0; i < blocks; i++){
  ea:	4481                	li	s1,0
  if(fd < 0){
  ec:	04054463          	bltz	a0,134 <main+0x134>
  for(i = 0; i < blocks; i++){
  f0:	69c1                	lui	s3,0x10
  f2:	10b98993          	addi	s3,s3,267 # 1010b <__global_pointer$+0xeeba>
    int cc = read(fd, buf, sizeof(buf));
  f6:	40000613          	li	a2,1024
  fa:	bd040593          	addi	a1,s0,-1072
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	30c080e7          	jalr	780(ra) # 40c <read>
    if(cc <= 0){
 108:	04a05363          	blez	a0,14e <main+0x14e>
      printf("bigfile: read error at block %d\n", i);
      exit(-1);
    }
    if(*(int*)buf != i){
 10c:	bd042583          	lw	a1,-1072(s0)
 110:	04959d63          	bne	a1,s1,16a <main+0x16a>
  for(i = 0; i < blocks; i++){
 114:	2485                	addiw	s1,s1,1
 116:	ff3490e3          	bne	s1,s3,f6 <main+0xf6>
             *(int*)buf, i);
      exit(-1);
    }
  }

  printf("bigfile done; ok\n"); 
 11a:	00001517          	auipc	a0,0x1
 11e:	90650513          	addi	a0,a0,-1786 # a20 <malloc+0x1ee>
 122:	00000097          	auipc	ra,0x0
 126:	652080e7          	jalr	1618(ra) # 774 <printf>

  exit(0);
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	2c8080e7          	jalr	712(ra) # 3f4 <exit>
    printf("bigfile: cannot re-open big.file for reading\n");
 134:	00001517          	auipc	a0,0x1
 138:	86450513          	addi	a0,a0,-1948 # 998 <malloc+0x166>
 13c:	00000097          	auipc	ra,0x0
 140:	638080e7          	jalr	1592(ra) # 774 <printf>
    exit(-1);
 144:	557d                	li	a0,-1
 146:	00000097          	auipc	ra,0x0
 14a:	2ae080e7          	jalr	686(ra) # 3f4 <exit>
      printf("bigfile: read error at block %d\n", i);
 14e:	85a6                	mv	a1,s1
 150:	00001517          	auipc	a0,0x1
 154:	87850513          	addi	a0,a0,-1928 # 9c8 <malloc+0x196>
 158:	00000097          	auipc	ra,0x0
 15c:	61c080e7          	jalr	1564(ra) # 774 <printf>
      exit(-1);
 160:	557d                	li	a0,-1
 162:	00000097          	auipc	ra,0x0
 166:	292080e7          	jalr	658(ra) # 3f4 <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 16a:	8626                	mv	a2,s1
 16c:	00001517          	auipc	a0,0x1
 170:	88450513          	addi	a0,a0,-1916 # 9f0 <malloc+0x1be>
 174:	00000097          	auipc	ra,0x0
 178:	600080e7          	jalr	1536(ra) # 774 <printf>
      exit(-1);
 17c:	557d                	li	a0,-1
 17e:	00000097          	auipc	ra,0x0
 182:	276080e7          	jalr	630(ra) # 3f4 <exit>

0000000000000186 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18c:	87aa                	mv	a5,a0
 18e:	0585                	addi	a1,a1,1
 190:	0785                	addi	a5,a5,1
 192:	fff5c703          	lbu	a4,-1(a1)
 196:	fee78fa3          	sb	a4,-1(a5)
 19a:	fb75                	bnez	a4,18e <strcpy+0x8>
    ;
  return os;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	cb91                	beqz	a5,1c0 <strcmp+0x1e>
 1ae:	0005c703          	lbu	a4,0(a1)
 1b2:	00f71763          	bne	a4,a5,1c0 <strcmp+0x1e>
    p++, q++;
 1b6:	0505                	addi	a0,a0,1
 1b8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbe5                	bnez	a5,1ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c0:	0005c503          	lbu	a0,0(a1)
}
 1c4:	40a7853b          	subw	a0,a5,a0
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <strlen>:

uint
strlen(const char *s)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cf91                	beqz	a5,1f4 <strlen+0x26>
 1da:	0505                	addi	a0,a0,1
 1dc:	87aa                	mv	a5,a0
 1de:	4685                	li	a3,1
 1e0:	9e89                	subw	a3,a3,a0
 1e2:	00f6853b          	addw	a0,a3,a5
 1e6:	0785                	addi	a5,a5,1
 1e8:	fff7c703          	lbu	a4,-1(a5)
 1ec:	fb7d                	bnez	a4,1e2 <strlen+0x14>
    ;
  return n;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  for(n = 0; s[n]; n++)
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <strlen+0x20>

00000000000001f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1fe:	ca19                	beqz	a2,214 <memset+0x1c>
 200:	87aa                	mv	a5,a0
 202:	1602                	slli	a2,a2,0x20
 204:	9201                	srli	a2,a2,0x20
 206:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 20a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 20e:	0785                	addi	a5,a5,1
 210:	fee79de3          	bne	a5,a4,20a <memset+0x12>
  }
  return dst;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret

000000000000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 220:	00054783          	lbu	a5,0(a0)
 224:	cb99                	beqz	a5,23a <strchr+0x20>
    if(*s == c)
 226:	00f58763          	beq	a1,a5,234 <strchr+0x1a>
  for(; *s; s++)
 22a:	0505                	addi	a0,a0,1
 22c:	00054783          	lbu	a5,0(a0)
 230:	fbfd                	bnez	a5,226 <strchr+0xc>
      return (char*)s;
  return 0;
 232:	4501                	li	a0,0
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret
  return 0;
 23a:	4501                	li	a0,0
 23c:	bfe5                	j	234 <strchr+0x1a>

000000000000023e <gets>:

char*
gets(char *buf, int max)
{
 23e:	711d                	addi	sp,sp,-96
 240:	ec86                	sd	ra,88(sp)
 242:	e8a2                	sd	s0,80(sp)
 244:	e4a6                	sd	s1,72(sp)
 246:	e0ca                	sd	s2,64(sp)
 248:	fc4e                	sd	s3,56(sp)
 24a:	f852                	sd	s4,48(sp)
 24c:	f456                	sd	s5,40(sp)
 24e:	f05a                	sd	s6,32(sp)
 250:	ec5e                	sd	s7,24(sp)
 252:	1080                	addi	s0,sp,96
 254:	8baa                	mv	s7,a0
 256:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 258:	892a                	mv	s2,a0
 25a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 25c:	4aa9                	li	s5,10
 25e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 260:	89a6                	mv	s3,s1
 262:	2485                	addiw	s1,s1,1
 264:	0344d863          	bge	s1,s4,294 <gets+0x56>
    cc = read(0, &c, 1);
 268:	4605                	li	a2,1
 26a:	faf40593          	addi	a1,s0,-81
 26e:	4501                	li	a0,0
 270:	00000097          	auipc	ra,0x0
 274:	19c080e7          	jalr	412(ra) # 40c <read>
    if(cc < 1)
 278:	00a05e63          	blez	a0,294 <gets+0x56>
    buf[i++] = c;
 27c:	faf44783          	lbu	a5,-81(s0)
 280:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 284:	01578763          	beq	a5,s5,292 <gets+0x54>
 288:	0905                	addi	s2,s2,1
 28a:	fd679be3          	bne	a5,s6,260 <gets+0x22>
  for(i=0; i+1 < max; ){
 28e:	89a6                	mv	s3,s1
 290:	a011                	j	294 <gets+0x56>
 292:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 294:	99de                	add	s3,s3,s7
 296:	00098023          	sb	zero,0(s3)
  return buf;
}
 29a:	855e                	mv	a0,s7
 29c:	60e6                	ld	ra,88(sp)
 29e:	6446                	ld	s0,80(sp)
 2a0:	64a6                	ld	s1,72(sp)
 2a2:	6906                	ld	s2,64(sp)
 2a4:	79e2                	ld	s3,56(sp)
 2a6:	7a42                	ld	s4,48(sp)
 2a8:	7aa2                	ld	s5,40(sp)
 2aa:	7b02                	ld	s6,32(sp)
 2ac:	6be2                	ld	s7,24(sp)
 2ae:	6125                	addi	sp,sp,96
 2b0:	8082                	ret

00000000000002b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b2:	1101                	addi	sp,sp,-32
 2b4:	ec06                	sd	ra,24(sp)
 2b6:	e822                	sd	s0,16(sp)
 2b8:	e426                	sd	s1,8(sp)
 2ba:	e04a                	sd	s2,0(sp)
 2bc:	1000                	addi	s0,sp,32
 2be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c0:	4581                	li	a1,0
 2c2:	00000097          	auipc	ra,0x0
 2c6:	172080e7          	jalr	370(ra) # 434 <open>
  if(fd < 0)
 2ca:	02054563          	bltz	a0,2f4 <stat+0x42>
 2ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d0:	85ca                	mv	a1,s2
 2d2:	00000097          	auipc	ra,0x0
 2d6:	17a080e7          	jalr	378(ra) # 44c <fstat>
 2da:	892a                	mv	s2,a0
  close(fd);
 2dc:	8526                	mv	a0,s1
 2de:	00000097          	auipc	ra,0x0
 2e2:	13e080e7          	jalr	318(ra) # 41c <close>
  return r;
}
 2e6:	854a                	mv	a0,s2
 2e8:	60e2                	ld	ra,24(sp)
 2ea:	6442                	ld	s0,16(sp)
 2ec:	64a2                	ld	s1,8(sp)
 2ee:	6902                	ld	s2,0(sp)
 2f0:	6105                	addi	sp,sp,32
 2f2:	8082                	ret
    return -1;
 2f4:	597d                	li	s2,-1
 2f6:	bfc5                	j	2e6 <stat+0x34>

00000000000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fe:	00054603          	lbu	a2,0(a0)
 302:	fd06079b          	addiw	a5,a2,-48
 306:	0ff7f793          	andi	a5,a5,255
 30a:	4725                	li	a4,9
 30c:	02f76963          	bltu	a4,a5,33e <atoi+0x46>
 310:	86aa                	mv	a3,a0
  n = 0;
 312:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 314:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 316:	0685                	addi	a3,a3,1
 318:	0025179b          	slliw	a5,a0,0x2
 31c:	9fa9                	addw	a5,a5,a0
 31e:	0017979b          	slliw	a5,a5,0x1
 322:	9fb1                	addw	a5,a5,a2
 324:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 328:	0006c603          	lbu	a2,0(a3)
 32c:	fd06071b          	addiw	a4,a2,-48
 330:	0ff77713          	andi	a4,a4,255
 334:	fee5f1e3          	bgeu	a1,a4,316 <atoi+0x1e>
  return n;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  n = 0;
 33e:	4501                	li	a0,0
 340:	bfe5                	j	338 <atoi+0x40>

0000000000000342 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 348:	02b57463          	bgeu	a0,a1,370 <memmove+0x2e>
    while(n-- > 0)
 34c:	00c05f63          	blez	a2,36a <memmove+0x28>
 350:	1602                	slli	a2,a2,0x20
 352:	9201                	srli	a2,a2,0x20
 354:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 358:	872a                	mv	a4,a0
      *dst++ = *src++;
 35a:	0585                	addi	a1,a1,1
 35c:	0705                	addi	a4,a4,1
 35e:	fff5c683          	lbu	a3,-1(a1)
 362:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 366:	fee79ae3          	bne	a5,a4,35a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
    dst += n;
 370:	00c50733          	add	a4,a0,a2
    src += n;
 374:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 376:	fec05ae3          	blez	a2,36a <memmove+0x28>
 37a:	fff6079b          	addiw	a5,a2,-1
 37e:	1782                	slli	a5,a5,0x20
 380:	9381                	srli	a5,a5,0x20
 382:	fff7c793          	not	a5,a5
 386:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 388:	15fd                	addi	a1,a1,-1
 38a:	177d                	addi	a4,a4,-1
 38c:	0005c683          	lbu	a3,0(a1)
 390:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 394:	fee79ae3          	bne	a5,a4,388 <memmove+0x46>
 398:	bfc9                	j	36a <memmove+0x28>

000000000000039a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a0:	ca05                	beqz	a2,3d0 <memcmp+0x36>
 3a2:	fff6069b          	addiw	a3,a2,-1
 3a6:	1682                	slli	a3,a3,0x20
 3a8:	9281                	srli	a3,a3,0x20
 3aa:	0685                	addi	a3,a3,1
 3ac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ae:	00054783          	lbu	a5,0(a0)
 3b2:	0005c703          	lbu	a4,0(a1)
 3b6:	00e79863          	bne	a5,a4,3c6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ba:	0505                	addi	a0,a0,1
    p2++;
 3bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3be:	fed518e3          	bne	a0,a3,3ae <memcmp+0x14>
  }
  return 0;
 3c2:	4501                	li	a0,0
 3c4:	a019                	j	3ca <memcmp+0x30>
      return *p1 - *p2;
 3c6:	40e7853b          	subw	a0,a5,a4
}
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	addi	sp,sp,16
 3ce:	8082                	ret
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	bfe5                	j	3ca <memcmp+0x30>

00000000000003d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3dc:	00000097          	auipc	ra,0x0
 3e0:	f66080e7          	jalr	-154(ra) # 342 <memmove>
}
 3e4:	60a2                	ld	ra,8(sp)
 3e6:	6402                	ld	s0,0(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ec:	4885                	li	a7,1
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f4:	4889                	li	a7,2
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fc:	488d                	li	a7,3
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 404:	4891                	li	a7,4
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <read>:
.global read
read:
 li a7, SYS_read
 40c:	4895                	li	a7,5
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <write>:
.global write
write:
 li a7, SYS_write
 414:	48c1                	li	a7,16
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <close>:
.global close
close:
 li a7, SYS_close
 41c:	48d5                	li	a7,21
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <kill>:
.global kill
kill:
 li a7, SYS_kill
 424:	4899                	li	a7,6
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exec>:
.global exec
exec:
 li a7, SYS_exec
 42c:	489d                	li	a7,7
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <open>:
.global open
open:
 li a7, SYS_open
 434:	48bd                	li	a7,15
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43c:	48c5                	li	a7,17
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 444:	48c9                	li	a7,18
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44c:	48a1                	li	a7,8
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <link>:
.global link
link:
 li a7, SYS_link
 454:	48cd                	li	a7,19
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45c:	48d1                	li	a7,20
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 464:	48a5                	li	a7,9
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <dup>:
.global dup
dup:
 li a7, SYS_dup
 46c:	48a9                	li	a7,10
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 474:	48ad                	li	a7,11
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47c:	48b1                	li	a7,12
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 484:	48b5                	li	a7,13
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48c:	48b9                	li	a7,14
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 494:	48d9                	li	a7,22
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49c:	1101                	addi	sp,sp,-32
 49e:	ec06                	sd	ra,24(sp)
 4a0:	e822                	sd	s0,16(sp)
 4a2:	1000                	addi	s0,sp,32
 4a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a8:	4605                	li	a2,1
 4aa:	fef40593          	addi	a1,s0,-17
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f66080e7          	jalr	-154(ra) # 414 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4be:	7139                	addi	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f426                	sd	s1,40(sp)
 4c6:	f04a                	sd	s2,32(sp)
 4c8:	ec4e                	sd	s3,24(sp)
 4ca:	0080                	addi	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ce:	c299                	beqz	a3,4d4 <printint+0x16>
 4d0:	0805c863          	bltz	a1,560 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	56050513          	addi	a0,a0,1376 # a40 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addiw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x2a>
  if(neg)
 50c:	00088b63          	beqz	a7,522 <printint+0x64>
    buf[i++] = '-';
 510:	fd040793          	addi	a5,s0,-48
 514:	973e                	add	a4,a4,a5
 516:	02d00793          	li	a5,45
 51a:	fef70823          	sb	a5,-16(a4)
 51e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 522:	02e05863          	blez	a4,552 <printint+0x94>
 526:	fc040793          	addi	a5,s0,-64
 52a:	00e78933          	add	s2,a5,a4
 52e:	fff78993          	addi	s3,a5,-1
 532:	99ba                	add	s3,s3,a4
 534:	377d                	addiw	a4,a4,-1
 536:	1702                	slli	a4,a4,0x20
 538:	9301                	srli	a4,a4,0x20
 53a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53e:	fff94583          	lbu	a1,-1(s2)
 542:	8526                	mv	a0,s1
 544:	00000097          	auipc	ra,0x0
 548:	f58080e7          	jalr	-168(ra) # 49c <putc>
  while(--i >= 0)
 54c:	197d                	addi	s2,s2,-1
 54e:	ff3918e3          	bne	s2,s3,53e <printint+0x80>
}
 552:	70e2                	ld	ra,56(sp)
 554:	7442                	ld	s0,48(sp)
 556:	74a2                	ld	s1,40(sp)
 558:	7902                	ld	s2,32(sp)
 55a:	69e2                	ld	s3,24(sp)
 55c:	6121                	addi	sp,sp,64
 55e:	8082                	ret
    x = -xx;
 560:	40b005bb          	negw	a1,a1
    neg = 1;
 564:	4885                	li	a7,1
    x = -xx;
 566:	bf8d                	j	4d8 <printint+0x1a>

0000000000000568 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 568:	7119                	addi	sp,sp,-128
 56a:	fc86                	sd	ra,120(sp)
 56c:	f8a2                	sd	s0,112(sp)
 56e:	f4a6                	sd	s1,104(sp)
 570:	f0ca                	sd	s2,96(sp)
 572:	ecce                	sd	s3,88(sp)
 574:	e8d2                	sd	s4,80(sp)
 576:	e4d6                	sd	s5,72(sp)
 578:	e0da                	sd	s6,64(sp)
 57a:	fc5e                	sd	s7,56(sp)
 57c:	f862                	sd	s8,48(sp)
 57e:	f466                	sd	s9,40(sp)
 580:	f06a                	sd	s10,32(sp)
 582:	ec6e                	sd	s11,24(sp)
 584:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 586:	0005c903          	lbu	s2,0(a1)
 58a:	18090f63          	beqz	s2,728 <vprintf+0x1c0>
 58e:	8aaa                	mv	s5,a0
 590:	8b32                	mv	s6,a2
 592:	00158493          	addi	s1,a1,1
  state = 0;
 596:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 598:	02500a13          	li	s4,37
      if(c == 'd'){
 59c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5a0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5a4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5a8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ac:	00000b97          	auipc	s7,0x0
 5b0:	494b8b93          	addi	s7,s7,1172 # a40 <digits>
 5b4:	a839                	j	5d2 <vprintf+0x6a>
        putc(fd, c);
 5b6:	85ca                	mv	a1,s2
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	ee2080e7          	jalr	-286(ra) # 49c <putc>
 5c2:	a019                	j	5c8 <vprintf+0x60>
    } else if(state == '%'){
 5c4:	01498f63          	beq	s3,s4,5e2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c8:	0485                	addi	s1,s1,1
 5ca:	fff4c903          	lbu	s2,-1(s1)
 5ce:	14090d63          	beqz	s2,728 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d6:	fe0997e3          	bnez	s3,5c4 <vprintf+0x5c>
      if(c == '%'){
 5da:	fd479ee3          	bne	a5,s4,5b6 <vprintf+0x4e>
        state = '%';
 5de:	89be                	mv	s3,a5
 5e0:	b7e5                	j	5c8 <vprintf+0x60>
      if(c == 'd'){
 5e2:	05878063          	beq	a5,s8,622 <vprintf+0xba>
      } else if(c == 'l') {
 5e6:	05978c63          	beq	a5,s9,63e <vprintf+0xd6>
      } else if(c == 'x') {
 5ea:	07a78863          	beq	a5,s10,65a <vprintf+0xf2>
      } else if(c == 'p') {
 5ee:	09b78463          	beq	a5,s11,676 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5f2:	07300713          	li	a4,115
 5f6:	0ce78663          	beq	a5,a4,6c2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fa:	06300713          	li	a4,99
 5fe:	0ee78e63          	beq	a5,a4,6fa <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 602:	11478863          	beq	a5,s4,712 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 606:	85d2                	mv	a1,s4
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e92080e7          	jalr	-366(ra) # 49c <putc>
        putc(fd, c);
 612:	85ca                	mv	a1,s2
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	e86080e7          	jalr	-378(ra) # 49c <putc>
      }
      state = 0;
 61e:	4981                	li	s3,0
 620:	b765                	j	5c8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 622:	008b0913          	addi	s2,s6,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000b2583          	lw	a1,0(s6)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e8e080e7          	jalr	-370(ra) # 4be <printint>
 638:	8b4a                	mv	s6,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b771                	j	5c8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b0913          	addi	s2,s6,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000b2583          	lw	a1,0(s6)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e72080e7          	jalr	-398(ra) # 4be <printint>
 654:	8b4a                	mv	s6,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	bf85                	j	5c8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 65a:	008b0913          	addi	s2,s6,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000b2583          	lw	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e56080e7          	jalr	-426(ra) # 4be <printint>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bf91                	j	5c8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 676:	008b0793          	addi	a5,s6,8
 67a:	f8f43423          	sd	a5,-120(s0)
 67e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 682:	03000593          	li	a1,48
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e14080e7          	jalr	-492(ra) # 49c <putc>
  putc(fd, 'x');
 690:	85ea                	mv	a1,s10
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e08080e7          	jalr	-504(ra) # 49c <putc>
 69c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	df2080e7          	jalr	-526(ra) # 49c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b2:	0992                	slli	s3,s3,0x4
 6b4:	397d                	addiw	s2,s2,-1
 6b6:	fe0914e3          	bnez	s2,69e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6ba:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b721                	j	5c8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c2:	008b0993          	addi	s3,s6,8
 6c6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6ca:	02090163          	beqz	s2,6ec <vprintf+0x184>
        while(*s != 0){
 6ce:	00094583          	lbu	a1,0(s2)
 6d2:	c9a1                	beqz	a1,722 <vprintf+0x1ba>
          putc(fd, *s);
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	dc6080e7          	jalr	-570(ra) # 49c <putc>
          s++;
 6de:	0905                	addi	s2,s2,1
        while(*s != 0){
 6e0:	00094583          	lbu	a1,0(s2)
 6e4:	f9e5                	bnez	a1,6d4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6e6:	8b4e                	mv	s6,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bdf9                	j	5c8 <vprintf+0x60>
          s = "(null)";
 6ec:	00000917          	auipc	s2,0x0
 6f0:	34c90913          	addi	s2,s2,844 # a38 <malloc+0x206>
        while(*s != 0){
 6f4:	02800593          	li	a1,40
 6f8:	bff1                	j	6d4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6fa:	008b0913          	addi	s2,s6,8
 6fe:	000b4583          	lbu	a1,0(s6)
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	d98080e7          	jalr	-616(ra) # 49c <putc>
 70c:	8b4a                	mv	s6,s2
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd65                	j	5c8 <vprintf+0x60>
        putc(fd, c);
 712:	85d2                	mv	a1,s4
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	d86080e7          	jalr	-634(ra) # 49c <putc>
      state = 0;
 71e:	4981                	li	s3,0
 720:	b565                	j	5c8 <vprintf+0x60>
        s = va_arg(ap, char*);
 722:	8b4e                	mv	s6,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	b54d                	j	5c8 <vprintf+0x60>
    }
  }
}
 728:	70e6                	ld	ra,120(sp)
 72a:	7446                	ld	s0,112(sp)
 72c:	74a6                	ld	s1,104(sp)
 72e:	7906                	ld	s2,96(sp)
 730:	69e6                	ld	s3,88(sp)
 732:	6a46                	ld	s4,80(sp)
 734:	6aa6                	ld	s5,72(sp)
 736:	6b06                	ld	s6,64(sp)
 738:	7be2                	ld	s7,56(sp)
 73a:	7c42                	ld	s8,48(sp)
 73c:	7ca2                	ld	s9,40(sp)
 73e:	7d02                	ld	s10,32(sp)
 740:	6de2                	ld	s11,24(sp)
 742:	6109                	addi	sp,sp,128
 744:	8082                	ret

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 762:	8622                	mv	a2,s0
 764:	00000097          	auipc	ra,0x0
 768:	e04080e7          	jalr	-508(ra) # 568 <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6161                	addi	sp,sp,80
 772:	8082                	ret

0000000000000774 <printf>:

void
printf(const char *fmt, ...)
{
 774:	711d                	addi	sp,sp,-96
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e40c                	sd	a1,8(s0)
 77e:	e810                	sd	a2,16(s0)
 780:	ec14                	sd	a3,24(s0)
 782:	f018                	sd	a4,32(s0)
 784:	f41c                	sd	a5,40(s0)
 786:	03043823          	sd	a6,48(s0)
 78a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	00840613          	addi	a2,s0,8
 792:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 796:	85aa                	mv	a1,a0
 798:	4505                	li	a0,1
 79a:	00000097          	auipc	ra,0x0
 79e:	dce080e7          	jalr	-562(ra) # 568 <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e422                	sd	s0,8(sp)
 7ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	00000797          	auipc	a5,0x0
 7b8:	2a47b783          	ld	a5,676(a5) # a58 <freep>
 7bc:	a805                	j	7ec <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7be:	4618                	lw	a4,8(a2)
 7c0:	9db9                	addw	a1,a1,a4
 7c2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	6318                	ld	a4,0(a4)
 7ca:	fee53823          	sd	a4,-16(a0)
 7ce:	a091                	j	812 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d0:	ff852703          	lw	a4,-8(a0)
 7d4:	9e39                	addw	a2,a2,a4
 7d6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7d8:	ff053703          	ld	a4,-16(a0)
 7dc:	e398                	sd	a4,0(a5)
 7de:	a099                	j	824 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e7e463          	bltu	a5,a4,7ea <free+0x40>
 7e6:	00e6ea63          	bltu	a3,a4,7fa <free+0x50>
{
 7ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	fed7fae3          	bgeu	a5,a3,7e0 <free+0x36>
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e6e463          	bltu	a3,a4,7fa <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	fee7eae3          	bltu	a5,a4,7ea <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7fa:	ff852583          	lw	a1,-8(a0)
 7fe:	6390                	ld	a2,0(a5)
 800:	02059813          	slli	a6,a1,0x20
 804:	01c85713          	srli	a4,a6,0x1c
 808:	9736                	add	a4,a4,a3
 80a:	fae60ae3          	beq	a2,a4,7be <free+0x14>
    bp->s.ptr = p->s.ptr;
 80e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 812:	4790                	lw	a2,8(a5)
 814:	02061593          	slli	a1,a2,0x20
 818:	01c5d713          	srli	a4,a1,0x1c
 81c:	973e                	add	a4,a4,a5
 81e:	fae689e3          	beq	a3,a4,7d0 <free+0x26>
  } else
    p->s.ptr = bp;
 822:	e394                	sd	a3,0(a5)
  freep = p;
 824:	00000717          	auipc	a4,0x0
 828:	22f73a23          	sd	a5,564(a4) # a58 <freep>
}
 82c:	6422                	ld	s0,8(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret

0000000000000832 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 832:	7139                	addi	sp,sp,-64
 834:	fc06                	sd	ra,56(sp)
 836:	f822                	sd	s0,48(sp)
 838:	f426                	sd	s1,40(sp)
 83a:	f04a                	sd	s2,32(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	e852                	sd	s4,16(sp)
 840:	e456                	sd	s5,8(sp)
 842:	e05a                	sd	s6,0(sp)
 844:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 846:	02051493          	slli	s1,a0,0x20
 84a:	9081                	srli	s1,s1,0x20
 84c:	04bd                	addi	s1,s1,15
 84e:	8091                	srli	s1,s1,0x4
 850:	0014899b          	addiw	s3,s1,1
 854:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 856:	00000517          	auipc	a0,0x0
 85a:	20253503          	ld	a0,514(a0) # a58 <freep>
 85e:	c515                	beqz	a0,88a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	02977f63          	bgeu	a4,s1,8a2 <malloc+0x70>
 868:	8a4e                	mv	s4,s3
 86a:	0009871b          	sext.w	a4,s3
 86e:	6685                	lui	a3,0x1
 870:	00d77363          	bgeu	a4,a3,876 <malloc+0x44>
 874:	6a05                	lui	s4,0x1
 876:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87e:	00000917          	auipc	s2,0x0
 882:	1da90913          	addi	s2,s2,474 # a58 <freep>
  if(p == (char*)-1)
 886:	5afd                	li	s5,-1
 888:	a895                	j	8fc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 88a:	00000797          	auipc	a5,0x0
 88e:	1d678793          	addi	a5,a5,470 # a60 <base>
 892:	00000717          	auipc	a4,0x0
 896:	1cf73323          	sd	a5,454(a4) # a58 <freep>
 89a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a0:	b7e1                	j	868 <malloc+0x36>
      if(p->s.size == nunits)
 8a2:	02e48c63          	beq	s1,a4,8da <malloc+0xa8>
        p->s.size -= nunits;
 8a6:	4137073b          	subw	a4,a4,s3
 8aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ac:	02071693          	slli	a3,a4,0x20
 8b0:	01c6d713          	srli	a4,a3,0x1c
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00000717          	auipc	a4,0x0
 8be:	18a73f23          	sd	a0,414(a4) # a58 <freep>
      return (void*)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	7902                	ld	s2,32(sp)
 8ce:	69e2                	ld	s3,24(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	6121                	addi	sp,sp,64
 8d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	e118                	sd	a4,0(a0)
 8de:	bff1                	j	8ba <malloc+0x88>
  hp->s.size = nu;
 8e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e4:	0541                	addi	a0,a0,16
 8e6:	00000097          	auipc	ra,0x0
 8ea:	ec4080e7          	jalr	-316(ra) # 7aa <free>
  return freep;
 8ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f2:	d971                	beqz	a0,8c6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f6:	4798                	lw	a4,8(a5)
 8f8:	fa9775e3          	bgeu	a4,s1,8a2 <malloc+0x70>
    if(p == freep)
 8fc:	00093703          	ld	a4,0(s2)
 900:	853e                	mv	a0,a5
 902:	fef719e3          	bne	a4,a5,8f4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	00000097          	auipc	ra,0x0
 90c:	b74080e7          	jalr	-1164(ra) # 47c <sbrk>
  if(p == (char*)-1)
 910:	fd5518e3          	bne	a0,s5,8e0 <malloc+0xae>
        return 0;
 914:	4501                	li	a0,0
 916:	bf45                	j	8c6 <malloc+0x94>
