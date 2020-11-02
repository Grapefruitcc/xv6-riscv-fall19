
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  20:	8a2a                	mv	s4,a0
  22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  24:	20200593          	li	a1,514
  28:	00000097          	auipc	ra,0x0
  2c:	75a080e7          	jalr	1882(ra) # 782 <open>
  if(fd < 0){
  30:	04054a63          	bltz	a0,84 <createfile+0x84>
  34:	892a                	mv	s2,a0
    printf("test0 create %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  36:	4481                	li	s1,0
  38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  3c:	40000613          	li	a2,1024
  40:	bd040593          	addi	a1,s0,-1072
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	71c080e7          	jalr	1820(ra) # 762 <write>
  4e:	40000793          	li	a5,1024
  52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
  56:	2485                	addiw	s1,s1,1
  58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
  5c:	854a                	mv	a0,s2
  5e:	00000097          	auipc	ra,0x0
  62:	70c080e7          	jalr	1804(ra) # 76a <close>
}
  66:	42813083          	ld	ra,1064(sp)
  6a:	42013403          	ld	s0,1056(sp)
  6e:	41813483          	ld	s1,1048(sp)
  72:	41013903          	ld	s2,1040(sp)
  76:	40813983          	ld	s3,1032(sp)
  7a:	40013a03          	ld	s4,1024(sp)
  7e:	43010113          	addi	sp,sp,1072
  82:	8082                	ret
    printf("test0 create %s failed\n", file);
  84:	85d2                	mv	a1,s4
  86:	00001517          	auipc	a0,0x1
  8a:	be250513          	addi	a0,a0,-1054 # c68 <malloc+0xe8>
  8e:	00001097          	auipc	ra,0x1
  92:	a34080e7          	jalr	-1484(ra) # ac2 <printf>
    exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	6aa080e7          	jalr	1706(ra) # 742 <exit>
      printf("write %s failed\n", file);
  a0:	85d2                	mv	a1,s4
  a2:	00001517          	auipc	a0,0x1
  a6:	bde50513          	addi	a0,a0,-1058 # c80 <malloc+0x100>
  aa:	00001097          	auipc	ra,0x1
  ae:	a18080e7          	jalr	-1512(ra) # ac2 <printf>
      exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	68e080e7          	jalr	1678(ra) # 742 <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
  bc:	bc010113          	addi	sp,sp,-1088
  c0:	42113c23          	sd	ra,1080(sp)
  c4:	42813823          	sd	s0,1072(sp)
  c8:	42913423          	sd	s1,1064(sp)
  cc:	43213023          	sd	s2,1056(sp)
  d0:	41313c23          	sd	s3,1048(sp)
  d4:	41413823          	sd	s4,1040(sp)
  d8:	41513423          	sd	s5,1032(sp)
  dc:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
  e0:	40000793          	li	a5,1024
  e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
  e8:	8aaa                	mv	s5,a0
  ea:	8a2e                	mv	s4,a1
  ec:	84b2                	mv	s1,a2
    printf("test0: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
  ee:	4581                	li	a1,0
  f0:	00000097          	auipc	ra,0x0
  f4:	692080e7          	jalr	1682(ra) # 782 <open>
  f8:	89aa                	mv	s3,a0
  fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("test0 open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
  fe:	4901                	li	s2,0
 100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
 104:	8626                	mv	a2,s1
 106:	bc040593          	addi	a1,s0,-1088
 10a:	854e                	mv	a0,s3
 10c:	00000097          	auipc	ra,0x0
 110:	64e080e7          	jalr	1614(ra) # 75a <read>
 114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
 118:	0124893b          	addw	s2,s1,s2
 11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
 120:	854e                	mv	a0,s3
 122:	00000097          	auipc	ra,0x0
 126:	648080e7          	jalr	1608(ra) # 76a <close>
}
 12a:	43813083          	ld	ra,1080(sp)
 12e:	43013403          	ld	s0,1072(sp)
 132:	42813483          	ld	s1,1064(sp)
 136:	42013903          	ld	s2,1056(sp)
 13a:	41813983          	ld	s3,1048(sp)
 13e:	41013a03          	ld	s4,1040(sp)
 142:	40813a83          	ld	s5,1032(sp)
 146:	44010113          	addi	sp,sp,1088
 14a:	8082                	ret
    printf("test0: inc too large\n");
 14c:	00001517          	auipc	a0,0x1
 150:	b4c50513          	addi	a0,a0,-1204 # c98 <malloc+0x118>
 154:	00001097          	auipc	ra,0x1
 158:	96e080e7          	jalr	-1682(ra) # ac2 <printf>
    exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	5e4080e7          	jalr	1508(ra) # 742 <exit>
    printf("test0 open %s failed\n", file);
 166:	85d6                	mv	a1,s5
 168:	00001517          	auipc	a0,0x1
 16c:	b4850513          	addi	a0,a0,-1208 # cb0 <malloc+0x130>
 170:	00001097          	auipc	ra,0x1
 174:	952080e7          	jalr	-1710(ra) # ac2 <printf>
    exit(-1);
 178:	557d                	li	a0,-1
 17a:	00000097          	auipc	ra,0x0
 17e:	5c8080e7          	jalr	1480(ra) # 742 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
 182:	86d2                	mv	a3,s4
 184:	864a                	mv	a2,s2
 186:	85d6                	mv	a1,s5
 188:	00001517          	auipc	a0,0x1
 18c:	b4050513          	addi	a0,a0,-1216 # cc8 <malloc+0x148>
 190:	00001097          	auipc	ra,0x1
 194:	932080e7          	jalr	-1742(ra) # ac2 <printf>
      exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	5a8080e7          	jalr	1448(ra) # 742 <exit>

00000000000001a2 <test0>:

void
test0()
{
 1a2:	7139                	addi	sp,sp,-64
 1a4:	fc06                	sd	ra,56(sp)
 1a6:	f822                	sd	s0,48(sp)
 1a8:	f426                	sd	s1,40(sp)
 1aa:	f04a                	sd	s2,32(sp)
 1ac:	ec4e                	sd	s3,24(sp)
 1ae:	0080                	addi	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 3 };
  int n;

  dir[0] = '0';
 1b0:	03000793          	li	a5,48
 1b4:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
 1b8:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
 1bc:	04600793          	li	a5,70
 1c0:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
 1c4:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
 1c8:	00001517          	auipc	a0,0x1
 1cc:	b2850513          	addi	a0,a0,-1240 # cf0 <malloc+0x170>
 1d0:	00001097          	auipc	ra,0x1
 1d4:	8f2080e7          	jalr	-1806(ra) # ac2 <printf>
 1d8:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
 1dc:	00001997          	auipc	s3,0x1
 1e0:	b3498993          	addi	s3,s3,-1228 # d10 <malloc+0x190>
  for(int i = 0; i < NCHILD; i++){
 1e4:	03300913          	li	s2,51
    dir[0] = '0' + i;
 1e8:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
 1ec:	fc040513          	addi	a0,s0,-64
 1f0:	00000097          	auipc	ra,0x0
 1f4:	5ba080e7          	jalr	1466(ra) # 7aa <mkdir>
    if (chdir(dir) < 0) {
 1f8:	fc040513          	addi	a0,s0,-64
 1fc:	00000097          	auipc	ra,0x0
 200:	5b6080e7          	jalr	1462(ra) # 7b2 <chdir>
 204:	0c054163          	bltz	a0,2c6 <test0+0x124>
    unlink(file);
 208:	fc840513          	addi	a0,s0,-56
 20c:	00000097          	auipc	ra,0x0
 210:	586080e7          	jalr	1414(ra) # 792 <unlink>
    createfile(file, N);
 214:	45a9                	li	a1,10
 216:	fc840513          	addi	a0,s0,-56
 21a:	00000097          	auipc	ra,0x0
 21e:	de6080e7          	jalr	-538(ra) # 0 <createfile>
    if (chdir("..") < 0) {
 222:	854e                	mv	a0,s3
 224:	00000097          	auipc	ra,0x0
 228:	58e080e7          	jalr	1422(ra) # 7b2 <chdir>
 22c:	0a054a63          	bltz	a0,2e0 <test0+0x13e>
  for(int i = 0; i < NCHILD; i++){
 230:	2485                	addiw	s1,s1,1
 232:	0ff4f493          	andi	s1,s1,255
 236:	fb2499e3          	bne	s1,s2,1e8 <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  ntas(0);
 23a:	4501                	li	a0,0
 23c:	00000097          	auipc	ra,0x0
 240:	5a6080e7          	jalr	1446(ra) # 7e2 <ntas>
 244:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 248:	03300913          	li	s2,51
    dir[0] = '0' + i;
 24c:	fc940023          	sb	s1,-64(s0)
    int pid = fork();
 250:	00000097          	auipc	ra,0x0
 254:	4ea080e7          	jalr	1258(ra) # 73a <fork>
    if(pid < 0){
 258:	0a054163          	bltz	a0,2fa <test0+0x158>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 25c:	cd45                	beqz	a0,314 <test0+0x172>
  for(int i = 0; i < NCHILD; i++){
 25e:	2485                	addiw	s1,s1,1
 260:	0ff4f493          	andi	s1,s1,255
 264:	ff2494e3          	bne	s1,s2,24c <test0+0xaa>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 268:	4501                	li	a0,0
 26a:	00000097          	auipc	ra,0x0
 26e:	4e0080e7          	jalr	1248(ra) # 74a <wait>
 272:	4501                	li	a0,0
 274:	00000097          	auipc	ra,0x0
 278:	4d6080e7          	jalr	1238(ra) # 74a <wait>
 27c:	4501                	li	a0,0
 27e:	00000097          	auipc	ra,0x0
 282:	4cc080e7          	jalr	1228(ra) # 74a <wait>
  }
  printf("test0 results:\n");
 286:	00001517          	auipc	a0,0x1
 28a:	aa250513          	addi	a0,a0,-1374 # d28 <malloc+0x1a8>
 28e:	00001097          	auipc	ra,0x1
 292:	834080e7          	jalr	-1996(ra) # ac2 <printf>
  n = ntas(1);
 296:	4505                	li	a0,1
 298:	00000097          	auipc	ra,0x0
 29c:	54a080e7          	jalr	1354(ra) # 7e2 <ntas>
  if (n < 500)
 2a0:	1f300793          	li	a5,499
 2a4:	0aa7cc63          	blt	a5,a0,35c <test0+0x1ba>
    printf("test0: OK\n");
 2a8:	00001517          	auipc	a0,0x1
 2ac:	a9050513          	addi	a0,a0,-1392 # d38 <malloc+0x1b8>
 2b0:	00001097          	auipc	ra,0x1
 2b4:	812080e7          	jalr	-2030(ra) # ac2 <printf>
  else
    printf("test0: FAIL\n");
}
 2b8:	70e2                	ld	ra,56(sp)
 2ba:	7442                	ld	s0,48(sp)
 2bc:	74a2                	ld	s1,40(sp)
 2be:	7902                	ld	s2,32(sp)
 2c0:	69e2                	ld	s3,24(sp)
 2c2:	6121                	addi	sp,sp,64
 2c4:	8082                	ret
      printf("chdir failed\n");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	a3a50513          	addi	a0,a0,-1478 # d00 <malloc+0x180>
 2ce:	00000097          	auipc	ra,0x0
 2d2:	7f4080e7          	jalr	2036(ra) # ac2 <printf>
      exit(1);
 2d6:	4505                	li	a0,1
 2d8:	00000097          	auipc	ra,0x0
 2dc:	46a080e7          	jalr	1130(ra) # 742 <exit>
      printf("chdir failed\n");
 2e0:	00001517          	auipc	a0,0x1
 2e4:	a2050513          	addi	a0,a0,-1504 # d00 <malloc+0x180>
 2e8:	00000097          	auipc	ra,0x0
 2ec:	7da080e7          	jalr	2010(ra) # ac2 <printf>
      exit(1);
 2f0:	4505                	li	a0,1
 2f2:	00000097          	auipc	ra,0x0
 2f6:	450080e7          	jalr	1104(ra) # 742 <exit>
      printf("fork failed");
 2fa:	00001517          	auipc	a0,0x1
 2fe:	a1e50513          	addi	a0,a0,-1506 # d18 <malloc+0x198>
 302:	00000097          	auipc	ra,0x0
 306:	7c0080e7          	jalr	1984(ra) # ac2 <printf>
      exit(-1);
 30a:	557d                	li	a0,-1
 30c:	00000097          	auipc	ra,0x0
 310:	436080e7          	jalr	1078(ra) # 742 <exit>
      if (chdir(dir) < 0) {
 314:	fc040513          	addi	a0,s0,-64
 318:	00000097          	auipc	ra,0x0
 31c:	49a080e7          	jalr	1178(ra) # 7b2 <chdir>
 320:	02054163          	bltz	a0,342 <test0+0x1a0>
      readfile(file, N*BSIZE, 1);
 324:	4605                	li	a2,1
 326:	658d                	lui	a1,0x3
 328:	80058593          	addi	a1,a1,-2048 # 2800 <__global_pointer$+0x126f>
 32c:	fc840513          	addi	a0,s0,-56
 330:	00000097          	auipc	ra,0x0
 334:	d8c080e7          	jalr	-628(ra) # bc <readfile>
      exit(0);
 338:	4501                	li	a0,0
 33a:	00000097          	auipc	ra,0x0
 33e:	408080e7          	jalr	1032(ra) # 742 <exit>
        printf("chdir failed\n");
 342:	00001517          	auipc	a0,0x1
 346:	9be50513          	addi	a0,a0,-1602 # d00 <malloc+0x180>
 34a:	00000097          	auipc	ra,0x0
 34e:	778080e7          	jalr	1912(ra) # ac2 <printf>
        exit(1);
 352:	4505                	li	a0,1
 354:	00000097          	auipc	ra,0x0
 358:	3ee080e7          	jalr	1006(ra) # 742 <exit>
    printf("test0: FAIL\n");
 35c:	00001517          	auipc	a0,0x1
 360:	9ec50513          	addi	a0,a0,-1556 # d48 <malloc+0x1c8>
 364:	00000097          	auipc	ra,0x0
 368:	75e080e7          	jalr	1886(ra) # ac2 <printf>
}
 36c:	b7b1                	j	2b8 <test0+0x116>

000000000000036e <test1>:

void test1()
{
 36e:	7179                	addi	sp,sp,-48
 370:	f406                	sd	ra,40(sp)
 372:	f022                	sd	s0,32(sp)
 374:	ec26                	sd	s1,24(sp)
 376:	e84a                	sd	s2,16(sp)
 378:	1800                	addi	s0,sp,48
  char file[3];
  enum { N = 100, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
 37a:	00001517          	auipc	a0,0x1
 37e:	9de50513          	addi	a0,a0,-1570 # d58 <malloc+0x1d8>
 382:	00000097          	auipc	ra,0x0
 386:	740080e7          	jalr	1856(ra) # ac2 <printf>
  file[0] = 'B';
 38a:	04200793          	li	a5,66
 38e:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 392:	fc040d23          	sb	zero,-38(s0)
 396:	4485                	li	s1,1
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
    unlink(file);
    if (i == 0) {
 398:	4905                	li	s2,1
 39a:	a811                	j	3ae <test1+0x40>
      createfile(file, BIG);
 39c:	06400593          	li	a1,100
 3a0:	fd840513          	addi	a0,s0,-40
 3a4:	00000097          	auipc	ra,0x0
 3a8:	c5c080e7          	jalr	-932(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 3ac:	2485                	addiw	s1,s1,1
    file[1] = '0' + i;
 3ae:	02f4879b          	addiw	a5,s1,47
 3b2:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
 3b6:	fd840513          	addi	a0,s0,-40
 3ba:	00000097          	auipc	ra,0x0
 3be:	3d8080e7          	jalr	984(ra) # 792 <unlink>
    if (i == 0) {
 3c2:	fd248de3          	beq	s1,s2,39c <test1+0x2e>
    } else {
      createfile(file, 1);
 3c6:	85ca                	mv	a1,s2
 3c8:	fd840513          	addi	a0,s0,-40
 3cc:	00000097          	auipc	ra,0x0
 3d0:	c34080e7          	jalr	-972(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 3d4:	0004879b          	sext.w	a5,s1
 3d8:	fcf95ae3          	bge	s2,a5,3ac <test1+0x3e>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 3dc:	03000793          	li	a5,48
 3e0:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 3e4:	00000097          	auipc	ra,0x0
 3e8:	356080e7          	jalr	854(ra) # 73a <fork>
    if(pid < 0){
 3ec:	04054663          	bltz	a0,438 <test1+0xca>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 3f0:	c12d                	beqz	a0,452 <test1+0xe4>
    file[1] = '0' + i;
 3f2:	03100793          	li	a5,49
 3f6:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 3fa:	00000097          	auipc	ra,0x0
 3fe:	340080e7          	jalr	832(ra) # 73a <fork>
    if(pid < 0){
 402:	02054b63          	bltz	a0,438 <test1+0xca>
    if(pid == 0){
 406:	cd35                	beqz	a0,482 <test1+0x114>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 408:	4501                	li	a0,0
 40a:	00000097          	auipc	ra,0x0
 40e:	340080e7          	jalr	832(ra) # 74a <wait>
 412:	4501                	li	a0,0
 414:	00000097          	auipc	ra,0x0
 418:	336080e7          	jalr	822(ra) # 74a <wait>
  }
  printf("test1 OK\n");
 41c:	00001517          	auipc	a0,0x1
 420:	94c50513          	addi	a0,a0,-1716 # d68 <malloc+0x1e8>
 424:	00000097          	auipc	ra,0x0
 428:	69e080e7          	jalr	1694(ra) # ac2 <printf>
}
 42c:	70a2                	ld	ra,40(sp)
 42e:	7402                	ld	s0,32(sp)
 430:	64e2                	ld	s1,24(sp)
 432:	6942                	ld	s2,16(sp)
 434:	6145                	addi	sp,sp,48
 436:	8082                	ret
      printf("fork failed");
 438:	00001517          	auipc	a0,0x1
 43c:	8e050513          	addi	a0,a0,-1824 # d18 <malloc+0x198>
 440:	00000097          	auipc	ra,0x0
 444:	682080e7          	jalr	1666(ra) # ac2 <printf>
      exit(-1);
 448:	557d                	li	a0,-1
 44a:	00000097          	auipc	ra,0x0
 44e:	2f8080e7          	jalr	760(ra) # 742 <exit>
    if(pid == 0){
 452:	06400493          	li	s1,100
          readfile(file, BIG*BSIZE, BSIZE);
 456:	40000613          	li	a2,1024
 45a:	65e5                	lui	a1,0x19
 45c:	fd840513          	addi	a0,s0,-40
 460:	00000097          	auipc	ra,0x0
 464:	c5c080e7          	jalr	-932(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 468:	34fd                	addiw	s1,s1,-1
 46a:	f4f5                	bnez	s1,456 <test1+0xe8>
        unlink(file);
 46c:	fd840513          	addi	a0,s0,-40
 470:	00000097          	auipc	ra,0x0
 474:	322080e7          	jalr	802(ra) # 792 <unlink>
        exit(0);
 478:	4501                	li	a0,0
 47a:	00000097          	auipc	ra,0x0
 47e:	2c8080e7          	jalr	712(ra) # 742 <exit>
 482:	06400493          	li	s1,100
          readfile(file, 1, BSIZE);
 486:	40000613          	li	a2,1024
 48a:	4585                	li	a1,1
 48c:	fd840513          	addi	a0,s0,-40
 490:	00000097          	auipc	ra,0x0
 494:	c2c080e7          	jalr	-980(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 498:	34fd                	addiw	s1,s1,-1
 49a:	f4f5                	bnez	s1,486 <test1+0x118>
        unlink(file);
 49c:	fd840513          	addi	a0,s0,-40
 4a0:	00000097          	auipc	ra,0x0
 4a4:	2f2080e7          	jalr	754(ra) # 792 <unlink>
      exit(0);
 4a8:	4501                	li	a0,0
 4aa:	00000097          	auipc	ra,0x0
 4ae:	298080e7          	jalr	664(ra) # 742 <exit>

00000000000004b2 <main>:
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	addi	s0,sp,16
  test0();
 4ba:	00000097          	auipc	ra,0x0
 4be:	ce8080e7          	jalr	-792(ra) # 1a2 <test0>
  test1();
 4c2:	00000097          	auipc	ra,0x0
 4c6:	eac080e7          	jalr	-340(ra) # 36e <test1>
  exit(0);
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	276080e7          	jalr	630(ra) # 742 <exit>

00000000000004d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e422                	sd	s0,8(sp)
 4d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4da:	87aa                	mv	a5,a0
 4dc:	0585                	addi	a1,a1,1
 4de:	0785                	addi	a5,a5,1
 4e0:	fff5c703          	lbu	a4,-1(a1) # 18fff <__global_pointer$+0x17a6e>
 4e4:	fee78fa3          	sb	a4,-1(a5)
 4e8:	fb75                	bnez	a4,4dc <strcpy+0x8>
    ;
  return os;
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	cb91                	beqz	a5,50e <strcmp+0x1e>
 4fc:	0005c703          	lbu	a4,0(a1)
 500:	00f71763          	bne	a4,a5,50e <strcmp+0x1e>
    p++, q++;
 504:	0505                	addi	a0,a0,1
 506:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 508:	00054783          	lbu	a5,0(a0)
 50c:	fbe5                	bnez	a5,4fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 50e:	0005c503          	lbu	a0,0(a1)
}
 512:	40a7853b          	subw	a0,a5,a0
 516:	6422                	ld	s0,8(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret

000000000000051c <strlen>:

uint
strlen(const char *s)
{
 51c:	1141                	addi	sp,sp,-16
 51e:	e422                	sd	s0,8(sp)
 520:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 522:	00054783          	lbu	a5,0(a0)
 526:	cf91                	beqz	a5,542 <strlen+0x26>
 528:	0505                	addi	a0,a0,1
 52a:	87aa                	mv	a5,a0
 52c:	4685                	li	a3,1
 52e:	9e89                	subw	a3,a3,a0
 530:	00f6853b          	addw	a0,a3,a5
 534:	0785                	addi	a5,a5,1
 536:	fff7c703          	lbu	a4,-1(a5)
 53a:	fb7d                	bnez	a4,530 <strlen+0x14>
    ;
  return n;
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
  for(n = 0; s[n]; n++)
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <strlen+0x20>

0000000000000546 <memset>:

void*
memset(void *dst, int c, uint n)
{
 546:	1141                	addi	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 54c:	ca19                	beqz	a2,562 <memset+0x1c>
 54e:	87aa                	mv	a5,a0
 550:	1602                	slli	a2,a2,0x20
 552:	9201                	srli	a2,a2,0x20
 554:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 558:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 55c:	0785                	addi	a5,a5,1
 55e:	fee79de3          	bne	a5,a4,558 <memset+0x12>
  }
  return dst;
}
 562:	6422                	ld	s0,8(sp)
 564:	0141                	addi	sp,sp,16
 566:	8082                	ret

0000000000000568 <strchr>:

char*
strchr(const char *s, char c)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 56e:	00054783          	lbu	a5,0(a0)
 572:	cb99                	beqz	a5,588 <strchr+0x20>
    if(*s == c)
 574:	00f58763          	beq	a1,a5,582 <strchr+0x1a>
  for(; *s; s++)
 578:	0505                	addi	a0,a0,1
 57a:	00054783          	lbu	a5,0(a0)
 57e:	fbfd                	bnez	a5,574 <strchr+0xc>
      return (char*)s;
  return 0;
 580:	4501                	li	a0,0
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <strchr+0x1a>

000000000000058c <gets>:

char*
gets(char *buf, int max)
{
 58c:	711d                	addi	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e4a6                	sd	s1,72(sp)
 594:	e0ca                	sd	s2,64(sp)
 596:	fc4e                	sd	s3,56(sp)
 598:	f852                	sd	s4,48(sp)
 59a:	f456                	sd	s5,40(sp)
 59c:	f05a                	sd	s6,32(sp)
 59e:	ec5e                	sd	s7,24(sp)
 5a0:	1080                	addi	s0,sp,96
 5a2:	8baa                	mv	s7,a0
 5a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5a6:	892a                	mv	s2,a0
 5a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5aa:	4aa9                	li	s5,10
 5ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5ae:	89a6                	mv	s3,s1
 5b0:	2485                	addiw	s1,s1,1
 5b2:	0344d863          	bge	s1,s4,5e2 <gets+0x56>
    cc = read(0, &c, 1);
 5b6:	4605                	li	a2,1
 5b8:	faf40593          	addi	a1,s0,-81
 5bc:	4501                	li	a0,0
 5be:	00000097          	auipc	ra,0x0
 5c2:	19c080e7          	jalr	412(ra) # 75a <read>
    if(cc < 1)
 5c6:	00a05e63          	blez	a0,5e2 <gets+0x56>
    buf[i++] = c;
 5ca:	faf44783          	lbu	a5,-81(s0)
 5ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5d2:	01578763          	beq	a5,s5,5e0 <gets+0x54>
 5d6:	0905                	addi	s2,s2,1
 5d8:	fd679be3          	bne	a5,s6,5ae <gets+0x22>
  for(i=0; i+1 < max; ){
 5dc:	89a6                	mv	s3,s1
 5de:	a011                	j	5e2 <gets+0x56>
 5e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5e2:	99de                	add	s3,s3,s7
 5e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 5e8:	855e                	mv	a0,s7
 5ea:	60e6                	ld	ra,88(sp)
 5ec:	6446                	ld	s0,80(sp)
 5ee:	64a6                	ld	s1,72(sp)
 5f0:	6906                	ld	s2,64(sp)
 5f2:	79e2                	ld	s3,56(sp)
 5f4:	7a42                	ld	s4,48(sp)
 5f6:	7aa2                	ld	s5,40(sp)
 5f8:	7b02                	ld	s6,32(sp)
 5fa:	6be2                	ld	s7,24(sp)
 5fc:	6125                	addi	sp,sp,96
 5fe:	8082                	ret

0000000000000600 <stat>:

int
stat(const char *n, struct stat *st)
{
 600:	1101                	addi	sp,sp,-32
 602:	ec06                	sd	ra,24(sp)
 604:	e822                	sd	s0,16(sp)
 606:	e426                	sd	s1,8(sp)
 608:	e04a                	sd	s2,0(sp)
 60a:	1000                	addi	s0,sp,32
 60c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 60e:	4581                	li	a1,0
 610:	00000097          	auipc	ra,0x0
 614:	172080e7          	jalr	370(ra) # 782 <open>
  if(fd < 0)
 618:	02054563          	bltz	a0,642 <stat+0x42>
 61c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 61e:	85ca                	mv	a1,s2
 620:	00000097          	auipc	ra,0x0
 624:	17a080e7          	jalr	378(ra) # 79a <fstat>
 628:	892a                	mv	s2,a0
  close(fd);
 62a:	8526                	mv	a0,s1
 62c:	00000097          	auipc	ra,0x0
 630:	13e080e7          	jalr	318(ra) # 76a <close>
  return r;
}
 634:	854a                	mv	a0,s2
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	64a2                	ld	s1,8(sp)
 63c:	6902                	ld	s2,0(sp)
 63e:	6105                	addi	sp,sp,32
 640:	8082                	ret
    return -1;
 642:	597d                	li	s2,-1
 644:	bfc5                	j	634 <stat+0x34>

0000000000000646 <atoi>:

int
atoi(const char *s)
{
 646:	1141                	addi	sp,sp,-16
 648:	e422                	sd	s0,8(sp)
 64a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 64c:	00054603          	lbu	a2,0(a0)
 650:	fd06079b          	addiw	a5,a2,-48
 654:	0ff7f793          	andi	a5,a5,255
 658:	4725                	li	a4,9
 65a:	02f76963          	bltu	a4,a5,68c <atoi+0x46>
 65e:	86aa                	mv	a3,a0
  n = 0;
 660:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 662:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 664:	0685                	addi	a3,a3,1
 666:	0025179b          	slliw	a5,a0,0x2
 66a:	9fa9                	addw	a5,a5,a0
 66c:	0017979b          	slliw	a5,a5,0x1
 670:	9fb1                	addw	a5,a5,a2
 672:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 676:	0006c603          	lbu	a2,0(a3)
 67a:	fd06071b          	addiw	a4,a2,-48
 67e:	0ff77713          	andi	a4,a4,255
 682:	fee5f1e3          	bgeu	a1,a4,664 <atoi+0x1e>
  return n;
}
 686:	6422                	ld	s0,8(sp)
 688:	0141                	addi	sp,sp,16
 68a:	8082                	ret
  n = 0;
 68c:	4501                	li	a0,0
 68e:	bfe5                	j	686 <atoi+0x40>

0000000000000690 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 690:	1141                	addi	sp,sp,-16
 692:	e422                	sd	s0,8(sp)
 694:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 696:	02b57463          	bgeu	a0,a1,6be <memmove+0x2e>
    while(n-- > 0)
 69a:	00c05f63          	blez	a2,6b8 <memmove+0x28>
 69e:	1602                	slli	a2,a2,0x20
 6a0:	9201                	srli	a2,a2,0x20
 6a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 6a8:	0585                	addi	a1,a1,1
 6aa:	0705                	addi	a4,a4,1
 6ac:	fff5c683          	lbu	a3,-1(a1)
 6b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6b4:	fee79ae3          	bne	a5,a4,6a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6b8:	6422                	ld	s0,8(sp)
 6ba:	0141                	addi	sp,sp,16
 6bc:	8082                	ret
    dst += n;
 6be:	00c50733          	add	a4,a0,a2
    src += n;
 6c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6c4:	fec05ae3          	blez	a2,6b8 <memmove+0x28>
 6c8:	fff6079b          	addiw	a5,a2,-1
 6cc:	1782                	slli	a5,a5,0x20
 6ce:	9381                	srli	a5,a5,0x20
 6d0:	fff7c793          	not	a5,a5
 6d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6d6:	15fd                	addi	a1,a1,-1
 6d8:	177d                	addi	a4,a4,-1
 6da:	0005c683          	lbu	a3,0(a1)
 6de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6e2:	fee79ae3          	bne	a5,a4,6d6 <memmove+0x46>
 6e6:	bfc9                	j	6b8 <memmove+0x28>

00000000000006e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6e8:	1141                	addi	sp,sp,-16
 6ea:	e422                	sd	s0,8(sp)
 6ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6ee:	ca05                	beqz	a2,71e <memcmp+0x36>
 6f0:	fff6069b          	addiw	a3,a2,-1
 6f4:	1682                	slli	a3,a3,0x20
 6f6:	9281                	srli	a3,a3,0x20
 6f8:	0685                	addi	a3,a3,1
 6fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6fc:	00054783          	lbu	a5,0(a0)
 700:	0005c703          	lbu	a4,0(a1)
 704:	00e79863          	bne	a5,a4,714 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 708:	0505                	addi	a0,a0,1
    p2++;
 70a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 70c:	fed518e3          	bne	a0,a3,6fc <memcmp+0x14>
  }
  return 0;
 710:	4501                	li	a0,0
 712:	a019                	j	718 <memcmp+0x30>
      return *p1 - *p2;
 714:	40e7853b          	subw	a0,a5,a4
}
 718:	6422                	ld	s0,8(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret
  return 0;
 71e:	4501                	li	a0,0
 720:	bfe5                	j	718 <memcmp+0x30>

0000000000000722 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 722:	1141                	addi	sp,sp,-16
 724:	e406                	sd	ra,8(sp)
 726:	e022                	sd	s0,0(sp)
 728:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 72a:	00000097          	auipc	ra,0x0
 72e:	f66080e7          	jalr	-154(ra) # 690 <memmove>
}
 732:	60a2                	ld	ra,8(sp)
 734:	6402                	ld	s0,0(sp)
 736:	0141                	addi	sp,sp,16
 738:	8082                	ret

000000000000073a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 73a:	4885                	li	a7,1
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <exit>:
.global exit
exit:
 li a7, SYS_exit
 742:	4889                	li	a7,2
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <wait>:
.global wait
wait:
 li a7, SYS_wait
 74a:	488d                	li	a7,3
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 752:	4891                	li	a7,4
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <read>:
.global read
read:
 li a7, SYS_read
 75a:	4895                	li	a7,5
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <write>:
.global write
write:
 li a7, SYS_write
 762:	48c1                	li	a7,16
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <close>:
.global close
close:
 li a7, SYS_close
 76a:	48d5                	li	a7,21
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <kill>:
.global kill
kill:
 li a7, SYS_kill
 772:	4899                	li	a7,6
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <exec>:
.global exec
exec:
 li a7, SYS_exec
 77a:	489d                	li	a7,7
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <open>:
.global open
open:
 li a7, SYS_open
 782:	48bd                	li	a7,15
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 78a:	48c5                	li	a7,17
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 792:	48c9                	li	a7,18
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 79a:	48a1                	li	a7,8
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <link>:
.global link
link:
 li a7, SYS_link
 7a2:	48cd                	li	a7,19
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7aa:	48d1                	li	a7,20
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7b2:	48a5                	li	a7,9
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 7ba:	48a9                	li	a7,10
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7c2:	48ad                	li	a7,11
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7ca:	48b1                	li	a7,12
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7d2:	48b5                	li	a7,13
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7da:	48b9                	li	a7,14
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 7e2:	48d9                	li	a7,22
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7ea:	1101                	addi	sp,sp,-32
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7f6:	4605                	li	a2,1
 7f8:	fef40593          	addi	a1,s0,-17
 7fc:	00000097          	auipc	ra,0x0
 800:	f66080e7          	jalr	-154(ra) # 762 <write>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6105                	addi	sp,sp,32
 80a:	8082                	ret

000000000000080c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	0080                	addi	s0,sp,64
 81a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 81c:	c299                	beqz	a3,822 <printint+0x16>
 81e:	0805c863          	bltz	a1,8ae <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 822:	2581                	sext.w	a1,a1
  neg = 0;
 824:	4881                	li	a7,0
 826:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 82a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 82c:	2601                	sext.w	a2,a2
 82e:	00000517          	auipc	a0,0x0
 832:	55250513          	addi	a0,a0,1362 # d80 <digits>
 836:	883a                	mv	a6,a4
 838:	2705                	addiw	a4,a4,1
 83a:	02c5f7bb          	remuw	a5,a1,a2
 83e:	1782                	slli	a5,a5,0x20
 840:	9381                	srli	a5,a5,0x20
 842:	97aa                	add	a5,a5,a0
 844:	0007c783          	lbu	a5,0(a5)
 848:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 84c:	0005879b          	sext.w	a5,a1
 850:	02c5d5bb          	divuw	a1,a1,a2
 854:	0685                	addi	a3,a3,1
 856:	fec7f0e3          	bgeu	a5,a2,836 <printint+0x2a>
  if(neg)
 85a:	00088b63          	beqz	a7,870 <printint+0x64>
    buf[i++] = '-';
 85e:	fd040793          	addi	a5,s0,-48
 862:	973e                	add	a4,a4,a5
 864:	02d00793          	li	a5,45
 868:	fef70823          	sb	a5,-16(a4)
 86c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 870:	02e05863          	blez	a4,8a0 <printint+0x94>
 874:	fc040793          	addi	a5,s0,-64
 878:	00e78933          	add	s2,a5,a4
 87c:	fff78993          	addi	s3,a5,-1
 880:	99ba                	add	s3,s3,a4
 882:	377d                	addiw	a4,a4,-1
 884:	1702                	slli	a4,a4,0x20
 886:	9301                	srli	a4,a4,0x20
 888:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 88c:	fff94583          	lbu	a1,-1(s2)
 890:	8526                	mv	a0,s1
 892:	00000097          	auipc	ra,0x0
 896:	f58080e7          	jalr	-168(ra) # 7ea <putc>
  while(--i >= 0)
 89a:	197d                	addi	s2,s2,-1
 89c:	ff3918e3          	bne	s2,s3,88c <printint+0x80>
}
 8a0:	70e2                	ld	ra,56(sp)
 8a2:	7442                	ld	s0,48(sp)
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	7902                	ld	s2,32(sp)
 8a8:	69e2                	ld	s3,24(sp)
 8aa:	6121                	addi	sp,sp,64
 8ac:	8082                	ret
    x = -xx;
 8ae:	40b005bb          	negw	a1,a1
    neg = 1;
 8b2:	4885                	li	a7,1
    x = -xx;
 8b4:	bf8d                	j	826 <printint+0x1a>

00000000000008b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8b6:	7119                	addi	sp,sp,-128
 8b8:	fc86                	sd	ra,120(sp)
 8ba:	f8a2                	sd	s0,112(sp)
 8bc:	f4a6                	sd	s1,104(sp)
 8be:	f0ca                	sd	s2,96(sp)
 8c0:	ecce                	sd	s3,88(sp)
 8c2:	e8d2                	sd	s4,80(sp)
 8c4:	e4d6                	sd	s5,72(sp)
 8c6:	e0da                	sd	s6,64(sp)
 8c8:	fc5e                	sd	s7,56(sp)
 8ca:	f862                	sd	s8,48(sp)
 8cc:	f466                	sd	s9,40(sp)
 8ce:	f06a                	sd	s10,32(sp)
 8d0:	ec6e                	sd	s11,24(sp)
 8d2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8d4:	0005c903          	lbu	s2,0(a1)
 8d8:	18090f63          	beqz	s2,a76 <vprintf+0x1c0>
 8dc:	8aaa                	mv	s5,a0
 8de:	8b32                	mv	s6,a2
 8e0:	00158493          	addi	s1,a1,1
  state = 0;
 8e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8e6:	02500a13          	li	s4,37
      if(c == 'd'){
 8ea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8ee:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 8f2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 8f6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fa:	00000b97          	auipc	s7,0x0
 8fe:	486b8b93          	addi	s7,s7,1158 # d80 <digits>
 902:	a839                	j	920 <vprintf+0x6a>
        putc(fd, c);
 904:	85ca                	mv	a1,s2
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	ee2080e7          	jalr	-286(ra) # 7ea <putc>
 910:	a019                	j	916 <vprintf+0x60>
    } else if(state == '%'){
 912:	01498f63          	beq	s3,s4,930 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 916:	0485                	addi	s1,s1,1
 918:	fff4c903          	lbu	s2,-1(s1)
 91c:	14090d63          	beqz	s2,a76 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 920:	0009079b          	sext.w	a5,s2
    if(state == 0){
 924:	fe0997e3          	bnez	s3,912 <vprintf+0x5c>
      if(c == '%'){
 928:	fd479ee3          	bne	a5,s4,904 <vprintf+0x4e>
        state = '%';
 92c:	89be                	mv	s3,a5
 92e:	b7e5                	j	916 <vprintf+0x60>
      if(c == 'd'){
 930:	05878063          	beq	a5,s8,970 <vprintf+0xba>
      } else if(c == 'l') {
 934:	05978c63          	beq	a5,s9,98c <vprintf+0xd6>
      } else if(c == 'x') {
 938:	07a78863          	beq	a5,s10,9a8 <vprintf+0xf2>
      } else if(c == 'p') {
 93c:	09b78463          	beq	a5,s11,9c4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 940:	07300713          	li	a4,115
 944:	0ce78663          	beq	a5,a4,a10 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 948:	06300713          	li	a4,99
 94c:	0ee78e63          	beq	a5,a4,a48 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 950:	11478863          	beq	a5,s4,a60 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 954:	85d2                	mv	a1,s4
 956:	8556                	mv	a0,s5
 958:	00000097          	auipc	ra,0x0
 95c:	e92080e7          	jalr	-366(ra) # 7ea <putc>
        putc(fd, c);
 960:	85ca                	mv	a1,s2
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	e86080e7          	jalr	-378(ra) # 7ea <putc>
      }
      state = 0;
 96c:	4981                	li	s3,0
 96e:	b765                	j	916 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 970:	008b0913          	addi	s2,s6,8
 974:	4685                	li	a3,1
 976:	4629                	li	a2,10
 978:	000b2583          	lw	a1,0(s6)
 97c:	8556                	mv	a0,s5
 97e:	00000097          	auipc	ra,0x0
 982:	e8e080e7          	jalr	-370(ra) # 80c <printint>
 986:	8b4a                	mv	s6,s2
      state = 0;
 988:	4981                	li	s3,0
 98a:	b771                	j	916 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 98c:	008b0913          	addi	s2,s6,8
 990:	4681                	li	a3,0
 992:	4629                	li	a2,10
 994:	000b2583          	lw	a1,0(s6)
 998:	8556                	mv	a0,s5
 99a:	00000097          	auipc	ra,0x0
 99e:	e72080e7          	jalr	-398(ra) # 80c <printint>
 9a2:	8b4a                	mv	s6,s2
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	bf85                	j	916 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 9a8:	008b0913          	addi	s2,s6,8
 9ac:	4681                	li	a3,0
 9ae:	4641                	li	a2,16
 9b0:	000b2583          	lw	a1,0(s6)
 9b4:	8556                	mv	a0,s5
 9b6:	00000097          	auipc	ra,0x0
 9ba:	e56080e7          	jalr	-426(ra) # 80c <printint>
 9be:	8b4a                	mv	s6,s2
      state = 0;
 9c0:	4981                	li	s3,0
 9c2:	bf91                	j	916 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 9c4:	008b0793          	addi	a5,s6,8
 9c8:	f8f43423          	sd	a5,-120(s0)
 9cc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 9d0:	03000593          	li	a1,48
 9d4:	8556                	mv	a0,s5
 9d6:	00000097          	auipc	ra,0x0
 9da:	e14080e7          	jalr	-492(ra) # 7ea <putc>
  putc(fd, 'x');
 9de:	85ea                	mv	a1,s10
 9e0:	8556                	mv	a0,s5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	e08080e7          	jalr	-504(ra) # 7ea <putc>
 9ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9ec:	03c9d793          	srli	a5,s3,0x3c
 9f0:	97de                	add	a5,a5,s7
 9f2:	0007c583          	lbu	a1,0(a5)
 9f6:	8556                	mv	a0,s5
 9f8:	00000097          	auipc	ra,0x0
 9fc:	df2080e7          	jalr	-526(ra) # 7ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a00:	0992                	slli	s3,s3,0x4
 a02:	397d                	addiw	s2,s2,-1
 a04:	fe0914e3          	bnez	s2,9ec <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 a08:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a0c:	4981                	li	s3,0
 a0e:	b721                	j	916 <vprintf+0x60>
        s = va_arg(ap, char*);
 a10:	008b0993          	addi	s3,s6,8
 a14:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 a18:	02090163          	beqz	s2,a3a <vprintf+0x184>
        while(*s != 0){
 a1c:	00094583          	lbu	a1,0(s2)
 a20:	c9a1                	beqz	a1,a70 <vprintf+0x1ba>
          putc(fd, *s);
 a22:	8556                	mv	a0,s5
 a24:	00000097          	auipc	ra,0x0
 a28:	dc6080e7          	jalr	-570(ra) # 7ea <putc>
          s++;
 a2c:	0905                	addi	s2,s2,1
        while(*s != 0){
 a2e:	00094583          	lbu	a1,0(s2)
 a32:	f9e5                	bnez	a1,a22 <vprintf+0x16c>
        s = va_arg(ap, char*);
 a34:	8b4e                	mv	s6,s3
      state = 0;
 a36:	4981                	li	s3,0
 a38:	bdf9                	j	916 <vprintf+0x60>
          s = "(null)";
 a3a:	00000917          	auipc	s2,0x0
 a3e:	33e90913          	addi	s2,s2,830 # d78 <malloc+0x1f8>
        while(*s != 0){
 a42:	02800593          	li	a1,40
 a46:	bff1                	j	a22 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a48:	008b0913          	addi	s2,s6,8
 a4c:	000b4583          	lbu	a1,0(s6)
 a50:	8556                	mv	a0,s5
 a52:	00000097          	auipc	ra,0x0
 a56:	d98080e7          	jalr	-616(ra) # 7ea <putc>
 a5a:	8b4a                	mv	s6,s2
      state = 0;
 a5c:	4981                	li	s3,0
 a5e:	bd65                	j	916 <vprintf+0x60>
        putc(fd, c);
 a60:	85d2                	mv	a1,s4
 a62:	8556                	mv	a0,s5
 a64:	00000097          	auipc	ra,0x0
 a68:	d86080e7          	jalr	-634(ra) # 7ea <putc>
      state = 0;
 a6c:	4981                	li	s3,0
 a6e:	b565                	j	916 <vprintf+0x60>
        s = va_arg(ap, char*);
 a70:	8b4e                	mv	s6,s3
      state = 0;
 a72:	4981                	li	s3,0
 a74:	b54d                	j	916 <vprintf+0x60>
    }
  }
}
 a76:	70e6                	ld	ra,120(sp)
 a78:	7446                	ld	s0,112(sp)
 a7a:	74a6                	ld	s1,104(sp)
 a7c:	7906                	ld	s2,96(sp)
 a7e:	69e6                	ld	s3,88(sp)
 a80:	6a46                	ld	s4,80(sp)
 a82:	6aa6                	ld	s5,72(sp)
 a84:	6b06                	ld	s6,64(sp)
 a86:	7be2                	ld	s7,56(sp)
 a88:	7c42                	ld	s8,48(sp)
 a8a:	7ca2                	ld	s9,40(sp)
 a8c:	7d02                	ld	s10,32(sp)
 a8e:	6de2                	ld	s11,24(sp)
 a90:	6109                	addi	sp,sp,128
 a92:	8082                	ret

0000000000000a94 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a94:	715d                	addi	sp,sp,-80
 a96:	ec06                	sd	ra,24(sp)
 a98:	e822                	sd	s0,16(sp)
 a9a:	1000                	addi	s0,sp,32
 a9c:	e010                	sd	a2,0(s0)
 a9e:	e414                	sd	a3,8(s0)
 aa0:	e818                	sd	a4,16(s0)
 aa2:	ec1c                	sd	a5,24(s0)
 aa4:	03043023          	sd	a6,32(s0)
 aa8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 aac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ab0:	8622                	mv	a2,s0
 ab2:	00000097          	auipc	ra,0x0
 ab6:	e04080e7          	jalr	-508(ra) # 8b6 <vprintf>
}
 aba:	60e2                	ld	ra,24(sp)
 abc:	6442                	ld	s0,16(sp)
 abe:	6161                	addi	sp,sp,80
 ac0:	8082                	ret

0000000000000ac2 <printf>:

void
printf(const char *fmt, ...)
{
 ac2:	711d                	addi	sp,sp,-96
 ac4:	ec06                	sd	ra,24(sp)
 ac6:	e822                	sd	s0,16(sp)
 ac8:	1000                	addi	s0,sp,32
 aca:	e40c                	sd	a1,8(s0)
 acc:	e810                	sd	a2,16(s0)
 ace:	ec14                	sd	a3,24(s0)
 ad0:	f018                	sd	a4,32(s0)
 ad2:	f41c                	sd	a5,40(s0)
 ad4:	03043823          	sd	a6,48(s0)
 ad8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 adc:	00840613          	addi	a2,s0,8
 ae0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ae4:	85aa                	mv	a1,a0
 ae6:	4505                	li	a0,1
 ae8:	00000097          	auipc	ra,0x0
 aec:	dce080e7          	jalr	-562(ra) # 8b6 <vprintf>
}
 af0:	60e2                	ld	ra,24(sp)
 af2:	6442                	ld	s0,16(sp)
 af4:	6125                	addi	sp,sp,96
 af6:	8082                	ret

0000000000000af8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 af8:	1141                	addi	sp,sp,-16
 afa:	e422                	sd	s0,8(sp)
 afc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 afe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b02:	00000797          	auipc	a5,0x0
 b06:	2967b783          	ld	a5,662(a5) # d98 <freep>
 b0a:	a805                	j	b3a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b0c:	4618                	lw	a4,8(a2)
 b0e:	9db9                	addw	a1,a1,a4
 b10:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b14:	6398                	ld	a4,0(a5)
 b16:	6318                	ld	a4,0(a4)
 b18:	fee53823          	sd	a4,-16(a0)
 b1c:	a091                	j	b60 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b1e:	ff852703          	lw	a4,-8(a0)
 b22:	9e39                	addw	a2,a2,a4
 b24:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 b26:	ff053703          	ld	a4,-16(a0)
 b2a:	e398                	sd	a4,0(a5)
 b2c:	a099                	j	b72 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b2e:	6398                	ld	a4,0(a5)
 b30:	00e7e463          	bltu	a5,a4,b38 <free+0x40>
 b34:	00e6ea63          	bltu	a3,a4,b48 <free+0x50>
{
 b38:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b3a:	fed7fae3          	bgeu	a5,a3,b2e <free+0x36>
 b3e:	6398                	ld	a4,0(a5)
 b40:	00e6e463          	bltu	a3,a4,b48 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b44:	fee7eae3          	bltu	a5,a4,b38 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b48:	ff852583          	lw	a1,-8(a0)
 b4c:	6390                	ld	a2,0(a5)
 b4e:	02059813          	slli	a6,a1,0x20
 b52:	01c85713          	srli	a4,a6,0x1c
 b56:	9736                	add	a4,a4,a3
 b58:	fae60ae3          	beq	a2,a4,b0c <free+0x14>
    bp->s.ptr = p->s.ptr;
 b5c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b60:	4790                	lw	a2,8(a5)
 b62:	02061593          	slli	a1,a2,0x20
 b66:	01c5d713          	srli	a4,a1,0x1c
 b6a:	973e                	add	a4,a4,a5
 b6c:	fae689e3          	beq	a3,a4,b1e <free+0x26>
  } else
    p->s.ptr = bp;
 b70:	e394                	sd	a3,0(a5)
  freep = p;
 b72:	00000717          	auipc	a4,0x0
 b76:	22f73323          	sd	a5,550(a4) # d98 <freep>
}
 b7a:	6422                	ld	s0,8(sp)
 b7c:	0141                	addi	sp,sp,16
 b7e:	8082                	ret

0000000000000b80 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b80:	7139                	addi	sp,sp,-64
 b82:	fc06                	sd	ra,56(sp)
 b84:	f822                	sd	s0,48(sp)
 b86:	f426                	sd	s1,40(sp)
 b88:	f04a                	sd	s2,32(sp)
 b8a:	ec4e                	sd	s3,24(sp)
 b8c:	e852                	sd	s4,16(sp)
 b8e:	e456                	sd	s5,8(sp)
 b90:	e05a                	sd	s6,0(sp)
 b92:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b94:	02051493          	slli	s1,a0,0x20
 b98:	9081                	srli	s1,s1,0x20
 b9a:	04bd                	addi	s1,s1,15
 b9c:	8091                	srli	s1,s1,0x4
 b9e:	0014899b          	addiw	s3,s1,1
 ba2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ba4:	00000517          	auipc	a0,0x0
 ba8:	1f453503          	ld	a0,500(a0) # d98 <freep>
 bac:	c515                	beqz	a0,bd8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb0:	4798                	lw	a4,8(a5)
 bb2:	02977f63          	bgeu	a4,s1,bf0 <malloc+0x70>
 bb6:	8a4e                	mv	s4,s3
 bb8:	0009871b          	sext.w	a4,s3
 bbc:	6685                	lui	a3,0x1
 bbe:	00d77363          	bgeu	a4,a3,bc4 <malloc+0x44>
 bc2:	6a05                	lui	s4,0x1
 bc4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bc8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bcc:	00000917          	auipc	s2,0x0
 bd0:	1cc90913          	addi	s2,s2,460 # d98 <freep>
  if(p == (char*)-1)
 bd4:	5afd                	li	s5,-1
 bd6:	a895                	j	c4a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 bd8:	00000797          	auipc	a5,0x0
 bdc:	1c878793          	addi	a5,a5,456 # da0 <base>
 be0:	00000717          	auipc	a4,0x0
 be4:	1af73c23          	sd	a5,440(a4) # d98 <freep>
 be8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bee:	b7e1                	j	bb6 <malloc+0x36>
      if(p->s.size == nunits)
 bf0:	02e48c63          	beq	s1,a4,c28 <malloc+0xa8>
        p->s.size -= nunits;
 bf4:	4137073b          	subw	a4,a4,s3
 bf8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bfa:	02071693          	slli	a3,a4,0x20
 bfe:	01c6d713          	srli	a4,a3,0x1c
 c02:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c04:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c08:	00000717          	auipc	a4,0x0
 c0c:	18a73823          	sd	a0,400(a4) # d98 <freep>
      return (void*)(p + 1);
 c10:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c14:	70e2                	ld	ra,56(sp)
 c16:	7442                	ld	s0,48(sp)
 c18:	74a2                	ld	s1,40(sp)
 c1a:	7902                	ld	s2,32(sp)
 c1c:	69e2                	ld	s3,24(sp)
 c1e:	6a42                	ld	s4,16(sp)
 c20:	6aa2                	ld	s5,8(sp)
 c22:	6b02                	ld	s6,0(sp)
 c24:	6121                	addi	sp,sp,64
 c26:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 c28:	6398                	ld	a4,0(a5)
 c2a:	e118                	sd	a4,0(a0)
 c2c:	bff1                	j	c08 <malloc+0x88>
  hp->s.size = nu;
 c2e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c32:	0541                	addi	a0,a0,16
 c34:	00000097          	auipc	ra,0x0
 c38:	ec4080e7          	jalr	-316(ra) # af8 <free>
  return freep;
 c3c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c40:	d971                	beqz	a0,c14 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c44:	4798                	lw	a4,8(a5)
 c46:	fa9775e3          	bgeu	a4,s1,bf0 <malloc+0x70>
    if(p == freep)
 c4a:	00093703          	ld	a4,0(s2)
 c4e:	853e                	mv	a0,a5
 c50:	fef719e3          	bne	a4,a5,c42 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c54:	8552                	mv	a0,s4
 c56:	00000097          	auipc	ra,0x0
 c5a:	b74080e7          	jalr	-1164(ra) # 7ca <sbrk>
  if(p == (char*)-1)
 c5e:	fd5518e3          	bne	a0,s5,c2e <malloc+0xae>
        return 0;
 c62:	4501                	li	a0,0
 c64:	bf45                	j	c14 <malloc+0x94>
