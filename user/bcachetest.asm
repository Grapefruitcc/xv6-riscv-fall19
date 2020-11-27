
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	21513423          	sd	s5,520(sp)
  20:	0480                	addi	s0,sp,576
  22:	8a2a                	mv	s4,a0
  24:	89ae                	mv	s3,a1
  int fd;
  char buf[512];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  26:	20200593          	li	a1,514
  2a:	00000097          	auipc	ra,0x0
  2e:	5b0080e7          	jalr	1456(ra) # 5da <open>
  if(fd < 0){
  32:	04054063          	bltz	a0,72 <createfile+0x72>
  36:	892a                	mv	s2,a0
    printf("test0 create %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  38:	4481                	li	s1,0
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      printf("write %s failed\n", file);
  3a:	00001a97          	auipc	s5,0x1
  3e:	ab6a8a93          	addi	s5,s5,-1354 # af0 <malloc+0x100>
  for(i = 0; i < nblock; i++) {
  42:	05304963          	bgtz	s3,94 <createfile+0x94>
    }
  }
  close(fd);
  46:	854a                	mv	a0,s2
  48:	00000097          	auipc	ra,0x0
  4c:	57a080e7          	jalr	1402(ra) # 5c2 <close>
}
  50:	23813083          	ld	ra,568(sp)
  54:	23013403          	ld	s0,560(sp)
  58:	22813483          	ld	s1,552(sp)
  5c:	22013903          	ld	s2,544(sp)
  60:	21813983          	ld	s3,536(sp)
  64:	21013a03          	ld	s4,528(sp)
  68:	20813a83          	ld	s5,520(sp)
  6c:	24010113          	addi	sp,sp,576
  70:	8082                	ret
    printf("test0 create %s failed\n", file);
  72:	85d2                	mv	a1,s4
  74:	00001517          	auipc	a0,0x1
  78:	a6450513          	addi	a0,a0,-1436 # ad8 <malloc+0xe8>
  7c:	00001097          	auipc	ra,0x1
  80:	8b6080e7          	jalr	-1866(ra) # 932 <printf>
    exit(-1);
  84:	557d                	li	a0,-1
  86:	00000097          	auipc	ra,0x0
  8a:	514080e7          	jalr	1300(ra) # 59a <exit>
  for(i = 0; i < nblock; i++) {
  8e:	2485                	addiw	s1,s1,1
  90:	fa998be3          	beq	s3,s1,46 <createfile+0x46>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  94:	20000613          	li	a2,512
  98:	dc040593          	addi	a1,s0,-576
  9c:	854a                	mv	a0,s2
  9e:	00000097          	auipc	ra,0x0
  a2:	51c080e7          	jalr	1308(ra) # 5ba <write>
  a6:	20000793          	li	a5,512
  aa:	fef502e3          	beq	a0,a5,8e <createfile+0x8e>
      printf("write %s failed\n", file);
  ae:	85d2                	mv	a1,s4
  b0:	8556                	mv	a0,s5
  b2:	00001097          	auipc	ra,0x1
  b6:	880080e7          	jalr	-1920(ra) # 932 <printf>
  ba:	bfd1                	j	8e <createfile+0x8e>

00000000000000bc <readfile>:

void
readfile(char *file, int nblock)
{
  bc:	dd010113          	addi	sp,sp,-560
  c0:	22113423          	sd	ra,552(sp)
  c4:	22813023          	sd	s0,544(sp)
  c8:	20913c23          	sd	s1,536(sp)
  cc:	21213823          	sd	s2,528(sp)
  d0:	21313423          	sd	s3,520(sp)
  d4:	21413023          	sd	s4,512(sp)
  d8:	1c00                	addi	s0,sp,560
  da:	8a2a                	mv	s4,a0
  dc:	89ae                	mv	s3,a1
  char buf[512];
  int fd;
  int i;
  
  if ((fd = open(file, O_RDONLY)) < 0) {
  de:	4581                	li	a1,0
  e0:	00000097          	auipc	ra,0x0
  e4:	4fa080e7          	jalr	1274(ra) # 5da <open>
  e8:	04054a63          	bltz	a0,13c <readfile+0x80>
  ec:	892a                	mv	s2,a0
    printf("test0 open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nblock; i++) {
  ee:	4481                	li	s1,0
  f0:	03305263          	blez	s3,114 <readfile+0x58>
    if(read(fd, buf, sizeof(buf)) != sizeof(buf)) {
  f4:	20000613          	li	a2,512
  f8:	dd040593          	addi	a1,s0,-560
  fc:	854a                	mv	a0,s2
  fe:	00000097          	auipc	ra,0x0
 102:	4b4080e7          	jalr	1204(ra) # 5b2 <read>
 106:	20000793          	li	a5,512
 10a:	04f51763          	bne	a0,a5,158 <readfile+0x9c>
  for (i = 0; i < nblock; i++) {
 10e:	2485                	addiw	s1,s1,1
 110:	fe9992e3          	bne	s3,s1,f4 <readfile+0x38>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
      exit(-1);
    }
  }
  close(fd);
 114:	854a                	mv	a0,s2
 116:	00000097          	auipc	ra,0x0
 11a:	4ac080e7          	jalr	1196(ra) # 5c2 <close>
}
 11e:	22813083          	ld	ra,552(sp)
 122:	22013403          	ld	s0,544(sp)
 126:	21813483          	ld	s1,536(sp)
 12a:	21013903          	ld	s2,528(sp)
 12e:	20813983          	ld	s3,520(sp)
 132:	20013a03          	ld	s4,512(sp)
 136:	23010113          	addi	sp,sp,560
 13a:	8082                	ret
    printf("test0 open %s failed\n", file);
 13c:	85d2                	mv	a1,s4
 13e:	00001517          	auipc	a0,0x1
 142:	9ca50513          	addi	a0,a0,-1590 # b08 <malloc+0x118>
 146:	00000097          	auipc	ra,0x0
 14a:	7ec080e7          	jalr	2028(ra) # 932 <printf>
    exit(-1);
 14e:	557d                	li	a0,-1
 150:	00000097          	auipc	ra,0x0
 154:	44a080e7          	jalr	1098(ra) # 59a <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nblock);
 158:	86ce                	mv	a3,s3
 15a:	8626                	mv	a2,s1
 15c:	85d2                	mv	a1,s4
 15e:	00001517          	auipc	a0,0x1
 162:	9c250513          	addi	a0,a0,-1598 # b20 <malloc+0x130>
 166:	00000097          	auipc	ra,0x0
 16a:	7cc080e7          	jalr	1996(ra) # 932 <printf>
      exit(-1);
 16e:	557d                	li	a0,-1
 170:	00000097          	auipc	ra,0x0
 174:	42a080e7          	jalr	1066(ra) # 59a <exit>

0000000000000178 <test0>:

void
test0()
{
 178:	7139                	addi	sp,sp,-64
 17a:	fc06                	sd	ra,56(sp)
 17c:	f822                	sd	s0,48(sp)
 17e:	f426                	sd	s1,40(sp)
 180:	f04a                	sd	s2,32(sp)
 182:	ec4e                	sd	s3,24(sp)
 184:	0080                	addi	s0,sp,64
  char file[3];

  file[0] = 'B';
 186:	04200793          	li	a5,66
 18a:	fcf40423          	sb	a5,-56(s0)
  file[2] = '\0';
 18e:	fc040523          	sb	zero,-54(s0)

  printf("start test0\n");
 192:	00001517          	auipc	a0,0x1
 196:	9b650513          	addi	a0,a0,-1610 # b48 <malloc+0x158>
 19a:	00000097          	auipc	ra,0x0
 19e:	798080e7          	jalr	1944(ra) # 932 <printf>
  int n = ntas();
 1a2:	00000097          	auipc	ra,0x0
 1a6:	498080e7          	jalr	1176(ra) # 63a <ntas>
 1aa:	892a                	mv	s2,a0
 1ac:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 1b0:	03300993          	li	s3,51
    file[1] = '0' + i;
 1b4:	fc9404a3          	sb	s1,-55(s0)
    createfile(file, 1);
 1b8:	4585                	li	a1,1
 1ba:	fc840513          	addi	a0,s0,-56
 1be:	00000097          	auipc	ra,0x0
 1c2:	e42080e7          	jalr	-446(ra) # 0 <createfile>
    int pid = fork();
 1c6:	00000097          	auipc	ra,0x0
 1ca:	3cc080e7          	jalr	972(ra) # 592 <fork>
    if(pid < 0){
 1ce:	04054c63          	bltz	a0,226 <test0+0xae>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 1d2:	c53d                	beqz	a0,240 <test0+0xc8>
  for(int i = 0; i < NCHILD; i++){
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0ff4f493          	andi	s1,s1,255
 1da:	fd349de3          	bne	s1,s3,1b4 <test0+0x3c>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 1de:	4501                	li	a0,0
 1e0:	00000097          	auipc	ra,0x0
 1e4:	3c2080e7          	jalr	962(ra) # 5a2 <wait>
 1e8:	4501                	li	a0,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	3b8080e7          	jalr	952(ra) # 5a2 <wait>
 1f2:	4501                	li	a0,0
 1f4:	00000097          	auipc	ra,0x0
 1f8:	3ae080e7          	jalr	942(ra) # 5a2 <wait>
  }
  printf("test0 done: #test-and-sets: %d\n", ntas() - n);
 1fc:	00000097          	auipc	ra,0x0
 200:	43e080e7          	jalr	1086(ra) # 63a <ntas>
 204:	412505bb          	subw	a1,a0,s2
 208:	00001517          	auipc	a0,0x1
 20c:	96050513          	addi	a0,a0,-1696 # b68 <malloc+0x178>
 210:	00000097          	auipc	ra,0x0
 214:	722080e7          	jalr	1826(ra) # 932 <printf>
}
 218:	70e2                	ld	ra,56(sp)
 21a:	7442                	ld	s0,48(sp)
 21c:	74a2                	ld	s1,40(sp)
 21e:	7902                	ld	s2,32(sp)
 220:	69e2                	ld	s3,24(sp)
 222:	6121                	addi	sp,sp,64
 224:	8082                	ret
      printf("fork failed");
 226:	00001517          	auipc	a0,0x1
 22a:	93250513          	addi	a0,a0,-1742 # b58 <malloc+0x168>
 22e:	00000097          	auipc	ra,0x0
 232:	704080e7          	jalr	1796(ra) # 932 <printf>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	362080e7          	jalr	866(ra) # 59a <exit>
 240:	3e800493          	li	s1,1000
        readfile(file, 1);
 244:	4585                	li	a1,1
 246:	fc840513          	addi	a0,s0,-56
 24a:	00000097          	auipc	ra,0x0
 24e:	e72080e7          	jalr	-398(ra) # bc <readfile>
      for (i = 0; i < N; i++) {
 252:	34fd                	addiw	s1,s1,-1
 254:	f8e5                	bnez	s1,244 <test0+0xcc>
      unlink(file);
 256:	fc840513          	addi	a0,s0,-56
 25a:	00000097          	auipc	ra,0x0
 25e:	390080e7          	jalr	912(ra) # 5ea <unlink>
      exit(-1);
 262:	557d                	li	a0,-1
 264:	00000097          	auipc	ra,0x0
 268:	336080e7          	jalr	822(ra) # 59a <exit>

000000000000026c <test1>:

void test1()
{
 26c:	7179                	addi	sp,sp,-48
 26e:	f406                	sd	ra,40(sp)
 270:	f022                	sd	s0,32(sp)
 272:	ec26                	sd	s1,24(sp)
 274:	1800                	addi	s0,sp,48
  char file[3];
  
  printf("start test1\n");
 276:	00001517          	auipc	a0,0x1
 27a:	91250513          	addi	a0,a0,-1774 # b88 <malloc+0x198>
 27e:	00000097          	auipc	ra,0x0
 282:	6b4080e7          	jalr	1716(ra) # 932 <printf>
  file[0] = 'B';
 286:	04200793          	li	a5,66
 28a:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 28e:	fc040d23          	sb	zero,-38(s0)
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 292:	03000493          	li	s1,48
 296:	fc940ca3          	sb	s1,-39(s0)
    if (i == 0) {
      createfile(file, BIG);
 29a:	06400593          	li	a1,100
 29e:	fd840513          	addi	a0,s0,-40
 2a2:	00000097          	auipc	ra,0x0
 2a6:	d5e080e7          	jalr	-674(ra) # 0 <createfile>
    file[1] = '0' + i;
 2aa:	03100793          	li	a5,49
 2ae:	fcf40ca3          	sb	a5,-39(s0)
    } else {
      createfile(file, 1);
 2b2:	4585                	li	a1,1
 2b4:	fd840513          	addi	a0,s0,-40
 2b8:	00000097          	auipc	ra,0x0
 2bc:	d48080e7          	jalr	-696(ra) # 0 <createfile>
    }
  }
  for(int i = 0; i < 2; i++){
    file[1] = '0' + i;
 2c0:	fc940ca3          	sb	s1,-39(s0)
    int pid = fork();
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2ce080e7          	jalr	718(ra) # 592 <fork>
    if(pid < 0){
 2cc:	04054563          	bltz	a0,316 <test1+0xaa>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2d0:	c125                	beqz	a0,330 <test1+0xc4>
    file[1] = '0' + i;
 2d2:	03100793          	li	a5,49
 2d6:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 2da:	00000097          	auipc	ra,0x0
 2de:	2b8080e7          	jalr	696(ra) # 592 <fork>
    if(pid < 0){
 2e2:	02054a63          	bltz	a0,316 <test1+0xaa>
    if(pid == 0){
 2e6:	cd25                	beqz	a0,35e <test1+0xf2>
      exit(0);
    }
  }

  for(int i = 0; i < 2; i++){
    wait(0);
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	2b8080e7          	jalr	696(ra) # 5a2 <wait>
 2f2:	4501                	li	a0,0
 2f4:	00000097          	auipc	ra,0x0
 2f8:	2ae080e7          	jalr	686(ra) # 5a2 <wait>
  }
  printf("test1 done\n");
 2fc:	00001517          	auipc	a0,0x1
 300:	89c50513          	addi	a0,a0,-1892 # b98 <malloc+0x1a8>
 304:	00000097          	auipc	ra,0x0
 308:	62e080e7          	jalr	1582(ra) # 932 <printf>
}
 30c:	70a2                	ld	ra,40(sp)
 30e:	7402                	ld	s0,32(sp)
 310:	64e2                	ld	s1,24(sp)
 312:	6145                	addi	sp,sp,48
 314:	8082                	ret
      printf("fork failed");
 316:	00001517          	auipc	a0,0x1
 31a:	84250513          	addi	a0,a0,-1982 # b58 <malloc+0x168>
 31e:	00000097          	auipc	ra,0x0
 322:	614080e7          	jalr	1556(ra) # 932 <printf>
      exit(-1);
 326:	557d                	li	a0,-1
 328:	00000097          	auipc	ra,0x0
 32c:	272080e7          	jalr	626(ra) # 59a <exit>
    if(pid == 0){
 330:	3e800493          	li	s1,1000
          readfile(file, BIG);
 334:	06400593          	li	a1,100
 338:	fd840513          	addi	a0,s0,-40
 33c:	00000097          	auipc	ra,0x0
 340:	d80080e7          	jalr	-640(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 344:	34fd                	addiw	s1,s1,-1
 346:	f4fd                	bnez	s1,334 <test1+0xc8>
        unlink(file);
 348:	fd840513          	addi	a0,s0,-40
 34c:	00000097          	auipc	ra,0x0
 350:	29e080e7          	jalr	670(ra) # 5ea <unlink>
        exit(0);
 354:	4501                	li	a0,0
 356:	00000097          	auipc	ra,0x0
 35a:	244080e7          	jalr	580(ra) # 59a <exit>
 35e:	3e800493          	li	s1,1000
          readfile(file, 1);
 362:	4585                	li	a1,1
 364:	fd840513          	addi	a0,s0,-40
 368:	00000097          	auipc	ra,0x0
 36c:	d54080e7          	jalr	-684(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 370:	34fd                	addiw	s1,s1,-1
 372:	f8e5                	bnez	s1,362 <test1+0xf6>
        unlink(file);
 374:	fd840513          	addi	a0,s0,-40
 378:	00000097          	auipc	ra,0x0
 37c:	272080e7          	jalr	626(ra) # 5ea <unlink>
      exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	218080e7          	jalr	536(ra) # 59a <exit>

000000000000038a <main>:
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  test0();
 392:	00000097          	auipc	ra,0x0
 396:	de6080e7          	jalr	-538(ra) # 178 <test0>
  test1();
 39a:	00000097          	auipc	ra,0x0
 39e:	ed2080e7          	jalr	-302(ra) # 26c <test1>
  exit(0);
 3a2:	4501                	li	a0,0
 3a4:	00000097          	auipc	ra,0x0
 3a8:	1f6080e7          	jalr	502(ra) # 59a <exit>

00000000000003ac <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3b2:	87aa                	mv	a5,a0
 3b4:	0585                	addi	a1,a1,1
 3b6:	0785                	addi	a5,a5,1
 3b8:	fff5c703          	lbu	a4,-1(a1)
 3bc:	fee78fa3          	sb	a4,-1(a5)
 3c0:	fb75                	bnez	a4,3b4 <strcpy+0x8>
    ;
  return os;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e422                	sd	s0,8(sp)
 3cc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	cb91                	beqz	a5,3e6 <strcmp+0x1e>
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00f71763          	bne	a4,a5,3e6 <strcmp+0x1e>
    p++, q++;
 3dc:	0505                	addi	a0,a0,1
 3de:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	fbe5                	bnez	a5,3d4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3e6:	0005c503          	lbu	a0,0(a1)
}
 3ea:	40a7853b          	subw	a0,a5,a0
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strlen>:

uint
strlen(const char *s)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cf91                	beqz	a5,41a <strlen+0x26>
 400:	0505                	addi	a0,a0,1
 402:	87aa                	mv	a5,a0
 404:	4685                	li	a3,1
 406:	9e89                	subw	a3,a3,a0
 408:	00f6853b          	addw	a0,a3,a5
 40c:	0785                	addi	a5,a5,1
 40e:	fff7c703          	lbu	a4,-1(a5)
 412:	fb7d                	bnez	a4,408 <strlen+0x14>
    ;
  return n;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  for(n = 0; s[n]; n++)
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <strlen+0x20>

000000000000041e <memset>:

void*
memset(void *dst, int c, uint n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 424:	ca19                	beqz	a2,43a <memset+0x1c>
 426:	87aa                	mv	a5,a0
 428:	1602                	slli	a2,a2,0x20
 42a:	9201                	srli	a2,a2,0x20
 42c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 430:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 434:	0785                	addi	a5,a5,1
 436:	fee79de3          	bne	a5,a4,430 <memset+0x12>
  }
  return dst;
}
 43a:	6422                	ld	s0,8(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret

0000000000000440 <strchr>:

char*
strchr(const char *s, char c)
{
 440:	1141                	addi	sp,sp,-16
 442:	e422                	sd	s0,8(sp)
 444:	0800                	addi	s0,sp,16
  for(; *s; s++)
 446:	00054783          	lbu	a5,0(a0)
 44a:	cb99                	beqz	a5,460 <strchr+0x20>
    if(*s == c)
 44c:	00f58763          	beq	a1,a5,45a <strchr+0x1a>
  for(; *s; s++)
 450:	0505                	addi	a0,a0,1
 452:	00054783          	lbu	a5,0(a0)
 456:	fbfd                	bnez	a5,44c <strchr+0xc>
      return (char*)s;
  return 0;
 458:	4501                	li	a0,0
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
  return 0;
 460:	4501                	li	a0,0
 462:	bfe5                	j	45a <strchr+0x1a>

0000000000000464 <gets>:

char*
gets(char *buf, int max)
{
 464:	711d                	addi	sp,sp,-96
 466:	ec86                	sd	ra,88(sp)
 468:	e8a2                	sd	s0,80(sp)
 46a:	e4a6                	sd	s1,72(sp)
 46c:	e0ca                	sd	s2,64(sp)
 46e:	fc4e                	sd	s3,56(sp)
 470:	f852                	sd	s4,48(sp)
 472:	f456                	sd	s5,40(sp)
 474:	f05a                	sd	s6,32(sp)
 476:	ec5e                	sd	s7,24(sp)
 478:	1080                	addi	s0,sp,96
 47a:	8baa                	mv	s7,a0
 47c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47e:	892a                	mv	s2,a0
 480:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 482:	4aa9                	li	s5,10
 484:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 486:	89a6                	mv	s3,s1
 488:	2485                	addiw	s1,s1,1
 48a:	0344d863          	bge	s1,s4,4ba <gets+0x56>
    cc = read(0, &c, 1);
 48e:	4605                	li	a2,1
 490:	faf40593          	addi	a1,s0,-81
 494:	4501                	li	a0,0
 496:	00000097          	auipc	ra,0x0
 49a:	11c080e7          	jalr	284(ra) # 5b2 <read>
    if(cc < 1)
 49e:	00a05e63          	blez	a0,4ba <gets+0x56>
    buf[i++] = c;
 4a2:	faf44783          	lbu	a5,-81(s0)
 4a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4aa:	01578763          	beq	a5,s5,4b8 <gets+0x54>
 4ae:	0905                	addi	s2,s2,1
 4b0:	fd679be3          	bne	a5,s6,486 <gets+0x22>
  for(i=0; i+1 < max; ){
 4b4:	89a6                	mv	s3,s1
 4b6:	a011                	j	4ba <gets+0x56>
 4b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ba:	99de                	add	s3,s3,s7
 4bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 4c0:	855e                	mv	a0,s7
 4c2:	60e6                	ld	ra,88(sp)
 4c4:	6446                	ld	s0,80(sp)
 4c6:	64a6                	ld	s1,72(sp)
 4c8:	6906                	ld	s2,64(sp)
 4ca:	79e2                	ld	s3,56(sp)
 4cc:	7a42                	ld	s4,48(sp)
 4ce:	7aa2                	ld	s5,40(sp)
 4d0:	7b02                	ld	s6,32(sp)
 4d2:	6be2                	ld	s7,24(sp)
 4d4:	6125                	addi	sp,sp,96
 4d6:	8082                	ret

00000000000004d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d8:	1101                	addi	sp,sp,-32
 4da:	ec06                	sd	ra,24(sp)
 4dc:	e822                	sd	s0,16(sp)
 4de:	e426                	sd	s1,8(sp)
 4e0:	e04a                	sd	s2,0(sp)
 4e2:	1000                	addi	s0,sp,32
 4e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e6:	4581                	li	a1,0
 4e8:	00000097          	auipc	ra,0x0
 4ec:	0f2080e7          	jalr	242(ra) # 5da <open>
  if(fd < 0)
 4f0:	02054563          	bltz	a0,51a <stat+0x42>
 4f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4f6:	85ca                	mv	a1,s2
 4f8:	00000097          	auipc	ra,0x0
 4fc:	0fa080e7          	jalr	250(ra) # 5f2 <fstat>
 500:	892a                	mv	s2,a0
  close(fd);
 502:	8526                	mv	a0,s1
 504:	00000097          	auipc	ra,0x0
 508:	0be080e7          	jalr	190(ra) # 5c2 <close>
  return r;
}
 50c:	854a                	mv	a0,s2
 50e:	60e2                	ld	ra,24(sp)
 510:	6442                	ld	s0,16(sp)
 512:	64a2                	ld	s1,8(sp)
 514:	6902                	ld	s2,0(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret
    return -1;
 51a:	597d                	li	s2,-1
 51c:	bfc5                	j	50c <stat+0x34>

000000000000051e <atoi>:

int
atoi(const char *s)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 524:	00054603          	lbu	a2,0(a0)
 528:	fd06079b          	addiw	a5,a2,-48
 52c:	0ff7f793          	andi	a5,a5,255
 530:	4725                	li	a4,9
 532:	02f76963          	bltu	a4,a5,564 <atoi+0x46>
 536:	86aa                	mv	a3,a0
  n = 0;
 538:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 53a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 53c:	0685                	addi	a3,a3,1
 53e:	0025179b          	slliw	a5,a0,0x2
 542:	9fa9                	addw	a5,a5,a0
 544:	0017979b          	slliw	a5,a5,0x1
 548:	9fb1                	addw	a5,a5,a2
 54a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 54e:	0006c603          	lbu	a2,0(a3)
 552:	fd06071b          	addiw	a4,a2,-48
 556:	0ff77713          	andi	a4,a4,255
 55a:	fee5f1e3          	bgeu	a1,a4,53c <atoi+0x1e>
  return n;
}
 55e:	6422                	ld	s0,8(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret
  n = 0;
 564:	4501                	li	a0,0
 566:	bfe5                	j	55e <atoi+0x40>

0000000000000568 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 56e:	00c05f63          	blez	a2,58c <memmove+0x24>
 572:	1602                	slli	a2,a2,0x20
 574:	9201                	srli	a2,a2,0x20
 576:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 57a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 57c:	0585                	addi	a1,a1,1
 57e:	0785                	addi	a5,a5,1
 580:	fff5c703          	lbu	a4,-1(a1)
 584:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 588:	fed79ae3          	bne	a5,a3,57c <memmove+0x14>
  return vdst;
}
 58c:	6422                	ld	s0,8(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret

0000000000000592 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 592:	4885                	li	a7,1
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <exit>:
.global exit
exit:
 li a7, SYS_exit
 59a:	4889                	li	a7,2
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a2:	488d                	li	a7,3
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5aa:	4891                	li	a7,4
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <read>:
.global read
read:
 li a7, SYS_read
 5b2:	4895                	li	a7,5
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <write>:
.global write
write:
 li a7, SYS_write
 5ba:	48c1                	li	a7,16
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <close>:
.global close
close:
 li a7, SYS_close
 5c2:	48d5                	li	a7,21
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 5ca:	4899                	li	a7,6
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d2:	489d                	li	a7,7
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <open>:
.global open
open:
 li a7, SYS_open
 5da:	48bd                	li	a7,15
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e2:	48c5                	li	a7,17
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ea:	48c9                	li	a7,18
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f2:	48a1                	li	a7,8
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <link>:
.global link
link:
 li a7, SYS_link
 5fa:	48cd                	li	a7,19
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 602:	48d1                	li	a7,20
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60a:	48a5                	li	a7,9
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <dup>:
.global dup
dup:
 li a7, SYS_dup
 612:	48a9                	li	a7,10
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61a:	48ad                	li	a7,11
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 622:	48b1                	li	a7,12
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 62a:	48b5                	li	a7,13
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 632:	48b9                	li	a7,14
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 63a:	48d9                	li	a7,22
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <crash>:
.global crash
crash:
 li a7, SYS_crash
 642:	48dd                	li	a7,23
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <mount>:
.global mount
mount:
 li a7, SYS_mount
 64a:	48e1                	li	a7,24
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <umount>:
.global umount
umount:
 li a7, SYS_umount
 652:	48e5                	li	a7,25
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 65a:	1101                	addi	sp,sp,-32
 65c:	ec06                	sd	ra,24(sp)
 65e:	e822                	sd	s0,16(sp)
 660:	1000                	addi	s0,sp,32
 662:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 666:	4605                	li	a2,1
 668:	fef40593          	addi	a1,s0,-17
 66c:	00000097          	auipc	ra,0x0
 670:	f4e080e7          	jalr	-178(ra) # 5ba <write>
}
 674:	60e2                	ld	ra,24(sp)
 676:	6442                	ld	s0,16(sp)
 678:	6105                	addi	sp,sp,32
 67a:	8082                	ret

000000000000067c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67c:	7139                	addi	sp,sp,-64
 67e:	fc06                	sd	ra,56(sp)
 680:	f822                	sd	s0,48(sp)
 682:	f426                	sd	s1,40(sp)
 684:	f04a                	sd	s2,32(sp)
 686:	ec4e                	sd	s3,24(sp)
 688:	0080                	addi	s0,sp,64
 68a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 68c:	c299                	beqz	a3,692 <printint+0x16>
 68e:	0805c863          	bltz	a1,71e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 692:	2581                	sext.w	a1,a1
  neg = 0;
 694:	4881                	li	a7,0
 696:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 69a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 69c:	2601                	sext.w	a2,a2
 69e:	00000517          	auipc	a0,0x0
 6a2:	51250513          	addi	a0,a0,1298 # bb0 <digits>
 6a6:	883a                	mv	a6,a4
 6a8:	2705                	addiw	a4,a4,1
 6aa:	02c5f7bb          	remuw	a5,a1,a2
 6ae:	1782                	slli	a5,a5,0x20
 6b0:	9381                	srli	a5,a5,0x20
 6b2:	97aa                	add	a5,a5,a0
 6b4:	0007c783          	lbu	a5,0(a5)
 6b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6bc:	0005879b          	sext.w	a5,a1
 6c0:	02c5d5bb          	divuw	a1,a1,a2
 6c4:	0685                	addi	a3,a3,1
 6c6:	fec7f0e3          	bgeu	a5,a2,6a6 <printint+0x2a>
  if(neg)
 6ca:	00088b63          	beqz	a7,6e0 <printint+0x64>
    buf[i++] = '-';
 6ce:	fd040793          	addi	a5,s0,-48
 6d2:	973e                	add	a4,a4,a5
 6d4:	02d00793          	li	a5,45
 6d8:	fef70823          	sb	a5,-16(a4)
 6dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6e0:	02e05863          	blez	a4,710 <printint+0x94>
 6e4:	fc040793          	addi	a5,s0,-64
 6e8:	00e78933          	add	s2,a5,a4
 6ec:	fff78993          	addi	s3,a5,-1
 6f0:	99ba                	add	s3,s3,a4
 6f2:	377d                	addiw	a4,a4,-1
 6f4:	1702                	slli	a4,a4,0x20
 6f6:	9301                	srli	a4,a4,0x20
 6f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6fc:	fff94583          	lbu	a1,-1(s2)
 700:	8526                	mv	a0,s1
 702:	00000097          	auipc	ra,0x0
 706:	f58080e7          	jalr	-168(ra) # 65a <putc>
  while(--i >= 0)
 70a:	197d                	addi	s2,s2,-1
 70c:	ff3918e3          	bne	s2,s3,6fc <printint+0x80>
}
 710:	70e2                	ld	ra,56(sp)
 712:	7442                	ld	s0,48(sp)
 714:	74a2                	ld	s1,40(sp)
 716:	7902                	ld	s2,32(sp)
 718:	69e2                	ld	s3,24(sp)
 71a:	6121                	addi	sp,sp,64
 71c:	8082                	ret
    x = -xx;
 71e:	40b005bb          	negw	a1,a1
    neg = 1;
 722:	4885                	li	a7,1
    x = -xx;
 724:	bf8d                	j	696 <printint+0x1a>

0000000000000726 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 726:	7119                	addi	sp,sp,-128
 728:	fc86                	sd	ra,120(sp)
 72a:	f8a2                	sd	s0,112(sp)
 72c:	f4a6                	sd	s1,104(sp)
 72e:	f0ca                	sd	s2,96(sp)
 730:	ecce                	sd	s3,88(sp)
 732:	e8d2                	sd	s4,80(sp)
 734:	e4d6                	sd	s5,72(sp)
 736:	e0da                	sd	s6,64(sp)
 738:	fc5e                	sd	s7,56(sp)
 73a:	f862                	sd	s8,48(sp)
 73c:	f466                	sd	s9,40(sp)
 73e:	f06a                	sd	s10,32(sp)
 740:	ec6e                	sd	s11,24(sp)
 742:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 744:	0005c903          	lbu	s2,0(a1)
 748:	18090f63          	beqz	s2,8e6 <vprintf+0x1c0>
 74c:	8aaa                	mv	s5,a0
 74e:	8b32                	mv	s6,a2
 750:	00158493          	addi	s1,a1,1
  state = 0;
 754:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 756:	02500a13          	li	s4,37
      if(c == 'd'){
 75a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 75e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 762:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 766:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76a:	00000b97          	auipc	s7,0x0
 76e:	446b8b93          	addi	s7,s7,1094 # bb0 <digits>
 772:	a839                	j	790 <vprintf+0x6a>
        putc(fd, c);
 774:	85ca                	mv	a1,s2
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	ee2080e7          	jalr	-286(ra) # 65a <putc>
 780:	a019                	j	786 <vprintf+0x60>
    } else if(state == '%'){
 782:	01498f63          	beq	s3,s4,7a0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 786:	0485                	addi	s1,s1,1
 788:	fff4c903          	lbu	s2,-1(s1)
 78c:	14090d63          	beqz	s2,8e6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 790:	0009079b          	sext.w	a5,s2
    if(state == 0){
 794:	fe0997e3          	bnez	s3,782 <vprintf+0x5c>
      if(c == '%'){
 798:	fd479ee3          	bne	a5,s4,774 <vprintf+0x4e>
        state = '%';
 79c:	89be                	mv	s3,a5
 79e:	b7e5                	j	786 <vprintf+0x60>
      if(c == 'd'){
 7a0:	05878063          	beq	a5,s8,7e0 <vprintf+0xba>
      } else if(c == 'l') {
 7a4:	05978c63          	beq	a5,s9,7fc <vprintf+0xd6>
      } else if(c == 'x') {
 7a8:	07a78863          	beq	a5,s10,818 <vprintf+0xf2>
      } else if(c == 'p') {
 7ac:	09b78463          	beq	a5,s11,834 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7b0:	07300713          	li	a4,115
 7b4:	0ce78663          	beq	a5,a4,880 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b8:	06300713          	li	a4,99
 7bc:	0ee78e63          	beq	a5,a4,8b8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7c0:	11478863          	beq	a5,s4,8d0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7c4:	85d2                	mv	a1,s4
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	e92080e7          	jalr	-366(ra) # 65a <putc>
        putc(fd, c);
 7d0:	85ca                	mv	a1,s2
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e86080e7          	jalr	-378(ra) # 65a <putc>
      }
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b765                	j	786 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7e0:	008b0913          	addi	s2,s6,8
 7e4:	4685                	li	a3,1
 7e6:	4629                	li	a2,10
 7e8:	000b2583          	lw	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e8e080e7          	jalr	-370(ra) # 67c <printint>
 7f6:	8b4a                	mv	s6,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b771                	j	786 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fc:	008b0913          	addi	s2,s6,8
 800:	4681                	li	a3,0
 802:	4629                	li	a2,10
 804:	000b2583          	lw	a1,0(s6)
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	e72080e7          	jalr	-398(ra) # 67c <printint>
 812:	8b4a                	mv	s6,s2
      state = 0;
 814:	4981                	li	s3,0
 816:	bf85                	j	786 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 818:	008b0913          	addi	s2,s6,8
 81c:	4681                	li	a3,0
 81e:	4641                	li	a2,16
 820:	000b2583          	lw	a1,0(s6)
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e56080e7          	jalr	-426(ra) # 67c <printint>
 82e:	8b4a                	mv	s6,s2
      state = 0;
 830:	4981                	li	s3,0
 832:	bf91                	j	786 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 834:	008b0793          	addi	a5,s6,8
 838:	f8f43423          	sd	a5,-120(s0)
 83c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 840:	03000593          	li	a1,48
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	e14080e7          	jalr	-492(ra) # 65a <putc>
  putc(fd, 'x');
 84e:	85ea                	mv	a1,s10
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e08080e7          	jalr	-504(ra) # 65a <putc>
 85a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 85c:	03c9d793          	srli	a5,s3,0x3c
 860:	97de                	add	a5,a5,s7
 862:	0007c583          	lbu	a1,0(a5)
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	df2080e7          	jalr	-526(ra) # 65a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 870:	0992                	slli	s3,s3,0x4
 872:	397d                	addiw	s2,s2,-1
 874:	fe0914e3          	bnez	s2,85c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 878:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b721                	j	786 <vprintf+0x60>
        s = va_arg(ap, char*);
 880:	008b0993          	addi	s3,s6,8
 884:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 888:	02090163          	beqz	s2,8aa <vprintf+0x184>
        while(*s != 0){
 88c:	00094583          	lbu	a1,0(s2)
 890:	c9a1                	beqz	a1,8e0 <vprintf+0x1ba>
          putc(fd, *s);
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	dc6080e7          	jalr	-570(ra) # 65a <putc>
          s++;
 89c:	0905                	addi	s2,s2,1
        while(*s != 0){
 89e:	00094583          	lbu	a1,0(s2)
 8a2:	f9e5                	bnez	a1,892 <vprintf+0x16c>
        s = va_arg(ap, char*);
 8a4:	8b4e                	mv	s6,s3
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	bdf9                	j	786 <vprintf+0x60>
          s = "(null)";
 8aa:	00000917          	auipc	s2,0x0
 8ae:	2fe90913          	addi	s2,s2,766 # ba8 <malloc+0x1b8>
        while(*s != 0){
 8b2:	02800593          	li	a1,40
 8b6:	bff1                	j	892 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8b8:	008b0913          	addi	s2,s6,8
 8bc:	000b4583          	lbu	a1,0(s6)
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	d98080e7          	jalr	-616(ra) # 65a <putc>
 8ca:	8b4a                	mv	s6,s2
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	bd65                	j	786 <vprintf+0x60>
        putc(fd, c);
 8d0:	85d2                	mv	a1,s4
 8d2:	8556                	mv	a0,s5
 8d4:	00000097          	auipc	ra,0x0
 8d8:	d86080e7          	jalr	-634(ra) # 65a <putc>
      state = 0;
 8dc:	4981                	li	s3,0
 8de:	b565                	j	786 <vprintf+0x60>
        s = va_arg(ap, char*);
 8e0:	8b4e                	mv	s6,s3
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b54d                	j	786 <vprintf+0x60>
    }
  }
}
 8e6:	70e6                	ld	ra,120(sp)
 8e8:	7446                	ld	s0,112(sp)
 8ea:	74a6                	ld	s1,104(sp)
 8ec:	7906                	ld	s2,96(sp)
 8ee:	69e6                	ld	s3,88(sp)
 8f0:	6a46                	ld	s4,80(sp)
 8f2:	6aa6                	ld	s5,72(sp)
 8f4:	6b06                	ld	s6,64(sp)
 8f6:	7be2                	ld	s7,56(sp)
 8f8:	7c42                	ld	s8,48(sp)
 8fa:	7ca2                	ld	s9,40(sp)
 8fc:	7d02                	ld	s10,32(sp)
 8fe:	6de2                	ld	s11,24(sp)
 900:	6109                	addi	sp,sp,128
 902:	8082                	ret

0000000000000904 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 904:	715d                	addi	sp,sp,-80
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	e010                	sd	a2,0(s0)
 90e:	e414                	sd	a3,8(s0)
 910:	e818                	sd	a4,16(s0)
 912:	ec1c                	sd	a5,24(s0)
 914:	03043023          	sd	a6,32(s0)
 918:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 920:	8622                	mv	a2,s0
 922:	00000097          	auipc	ra,0x0
 926:	e04080e7          	jalr	-508(ra) # 726 <vprintf>
}
 92a:	60e2                	ld	ra,24(sp)
 92c:	6442                	ld	s0,16(sp)
 92e:	6161                	addi	sp,sp,80
 930:	8082                	ret

0000000000000932 <printf>:

void
printf(const char *fmt, ...)
{
 932:	711d                	addi	sp,sp,-96
 934:	ec06                	sd	ra,24(sp)
 936:	e822                	sd	s0,16(sp)
 938:	1000                	addi	s0,sp,32
 93a:	e40c                	sd	a1,8(s0)
 93c:	e810                	sd	a2,16(s0)
 93e:	ec14                	sd	a3,24(s0)
 940:	f018                	sd	a4,32(s0)
 942:	f41c                	sd	a5,40(s0)
 944:	03043823          	sd	a6,48(s0)
 948:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94c:	00840613          	addi	a2,s0,8
 950:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 954:	85aa                	mv	a1,a0
 956:	4505                	li	a0,1
 958:	00000097          	auipc	ra,0x0
 95c:	dce080e7          	jalr	-562(ra) # 726 <vprintf>
}
 960:	60e2                	ld	ra,24(sp)
 962:	6442                	ld	s0,16(sp)
 964:	6125                	addi	sp,sp,96
 966:	8082                	ret

0000000000000968 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 968:	1141                	addi	sp,sp,-16
 96a:	e422                	sd	s0,8(sp)
 96c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 96e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 972:	00000797          	auipc	a5,0x0
 976:	2567b783          	ld	a5,598(a5) # bc8 <freep>
 97a:	a805                	j	9aa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97c:	4618                	lw	a4,8(a2)
 97e:	9db9                	addw	a1,a1,a4
 980:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	6318                	ld	a4,0(a4)
 988:	fee53823          	sd	a4,-16(a0)
 98c:	a091                	j	9d0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98e:	ff852703          	lw	a4,-8(a0)
 992:	9e39                	addw	a2,a2,a4
 994:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 996:	ff053703          	ld	a4,-16(a0)
 99a:	e398                	sd	a4,0(a5)
 99c:	a099                	j	9e2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99e:	6398                	ld	a4,0(a5)
 9a0:	00e7e463          	bltu	a5,a4,9a8 <free+0x40>
 9a4:	00e6ea63          	bltu	a3,a4,9b8 <free+0x50>
{
 9a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9aa:	fed7fae3          	bgeu	a5,a3,99e <free+0x36>
 9ae:	6398                	ld	a4,0(a5)
 9b0:	00e6e463          	bltu	a3,a4,9b8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b4:	fee7eae3          	bltu	a5,a4,9a8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9b8:	ff852583          	lw	a1,-8(a0)
 9bc:	6390                	ld	a2,0(a5)
 9be:	02059813          	slli	a6,a1,0x20
 9c2:	01c85713          	srli	a4,a6,0x1c
 9c6:	9736                	add	a4,a4,a3
 9c8:	fae60ae3          	beq	a2,a4,97c <free+0x14>
    bp->s.ptr = p->s.ptr;
 9cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d0:	4790                	lw	a2,8(a5)
 9d2:	02061593          	slli	a1,a2,0x20
 9d6:	01c5d713          	srli	a4,a1,0x1c
 9da:	973e                	add	a4,a4,a5
 9dc:	fae689e3          	beq	a3,a4,98e <free+0x26>
  } else
    p->s.ptr = bp;
 9e0:	e394                	sd	a3,0(a5)
  freep = p;
 9e2:	00000717          	auipc	a4,0x0
 9e6:	1ef73323          	sd	a5,486(a4) # bc8 <freep>
}
 9ea:	6422                	ld	s0,8(sp)
 9ec:	0141                	addi	sp,sp,16
 9ee:	8082                	ret

00000000000009f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f0:	7139                	addi	sp,sp,-64
 9f2:	fc06                	sd	ra,56(sp)
 9f4:	f822                	sd	s0,48(sp)
 9f6:	f426                	sd	s1,40(sp)
 9f8:	f04a                	sd	s2,32(sp)
 9fa:	ec4e                	sd	s3,24(sp)
 9fc:	e852                	sd	s4,16(sp)
 9fe:	e456                	sd	s5,8(sp)
 a00:	e05a                	sd	s6,0(sp)
 a02:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a04:	02051493          	slli	s1,a0,0x20
 a08:	9081                	srli	s1,s1,0x20
 a0a:	04bd                	addi	s1,s1,15
 a0c:	8091                	srli	s1,s1,0x4
 a0e:	0014899b          	addiw	s3,s1,1
 a12:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a14:	00000517          	auipc	a0,0x0
 a18:	1b453503          	ld	a0,436(a0) # bc8 <freep>
 a1c:	c515                	beqz	a0,a48 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a20:	4798                	lw	a4,8(a5)
 a22:	02977f63          	bgeu	a4,s1,a60 <malloc+0x70>
 a26:	8a4e                	mv	s4,s3
 a28:	0009871b          	sext.w	a4,s3
 a2c:	6685                	lui	a3,0x1
 a2e:	00d77363          	bgeu	a4,a3,a34 <malloc+0x44>
 a32:	6a05                	lui	s4,0x1
 a34:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a38:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a3c:	00000917          	auipc	s2,0x0
 a40:	18c90913          	addi	s2,s2,396 # bc8 <freep>
  if(p == (char*)-1)
 a44:	5afd                	li	s5,-1
 a46:	a895                	j	aba <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a48:	00000797          	auipc	a5,0x0
 a4c:	18878793          	addi	a5,a5,392 # bd0 <base>
 a50:	00000717          	auipc	a4,0x0
 a54:	16f73c23          	sd	a5,376(a4) # bc8 <freep>
 a58:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a5e:	b7e1                	j	a26 <malloc+0x36>
      if(p->s.size == nunits)
 a60:	02e48c63          	beq	s1,a4,a98 <malloc+0xa8>
        p->s.size -= nunits;
 a64:	4137073b          	subw	a4,a4,s3
 a68:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a6a:	02071693          	slli	a3,a4,0x20
 a6e:	01c6d713          	srli	a4,a3,0x1c
 a72:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a74:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a78:	00000717          	auipc	a4,0x0
 a7c:	14a73823          	sd	a0,336(a4) # bc8 <freep>
      return (void*)(p + 1);
 a80:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a84:	70e2                	ld	ra,56(sp)
 a86:	7442                	ld	s0,48(sp)
 a88:	74a2                	ld	s1,40(sp)
 a8a:	7902                	ld	s2,32(sp)
 a8c:	69e2                	ld	s3,24(sp)
 a8e:	6a42                	ld	s4,16(sp)
 a90:	6aa2                	ld	s5,8(sp)
 a92:	6b02                	ld	s6,0(sp)
 a94:	6121                	addi	sp,sp,64
 a96:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a98:	6398                	ld	a4,0(a5)
 a9a:	e118                	sd	a4,0(a0)
 a9c:	bff1                	j	a78 <malloc+0x88>
  hp->s.size = nu;
 a9e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aa2:	0541                	addi	a0,a0,16
 aa4:	00000097          	auipc	ra,0x0
 aa8:	ec4080e7          	jalr	-316(ra) # 968 <free>
  return freep;
 aac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ab0:	d971                	beqz	a0,a84 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab4:	4798                	lw	a4,8(a5)
 ab6:	fa9775e3          	bgeu	a4,s1,a60 <malloc+0x70>
    if(p == freep)
 aba:	00093703          	ld	a4,0(s2)
 abe:	853e                	mv	a0,a5
 ac0:	fef719e3          	bne	a4,a5,ab2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 ac4:	8552                	mv	a0,s4
 ac6:	00000097          	auipc	ra,0x0
 aca:	b5c080e7          	jalr	-1188(ra) # 622 <sbrk>
  if(p == (char*)-1)
 ace:	fd5518e3          	bne	a0,s5,a9e <malloc+0xae>
        return 0;
 ad2:	4501                	li	a0,0
 ad4:	bf45                	j	a84 <malloc+0x94>
