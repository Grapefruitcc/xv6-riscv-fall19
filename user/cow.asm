
user/_cow:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	c1250513          	addi	a0,a0,-1006 # c20 <malloc+0xe6>
  16:	00001097          	auipc	ra,0x1
  1a:	a66080e7          	jalr	-1434(ra) # a7c <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x55507e4>
  26:	00000097          	auipc	ra,0x0
  2a:	746080e7          	jalr	1862(ra) # 76c <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	726080e7          	jalr	1830(ra) # 764 <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	68e080e7          	jalr	1678(ra) # 6dc <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	68e080e7          	jalr	1678(ra) # 6ec <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5d3c>
  6e:	00000097          	auipc	ra,0x0
  72:	6fe080e7          	jalr	1790(ra) # 76c <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	bf450513          	addi	a0,a0,-1036 # c70 <malloc+0x136>
  84:	00001097          	auipc	ra,0x1
  88:	9f8080e7          	jalr	-1544(ra) # a7c <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x55507e4>
  a2:	00001517          	auipc	a0,0x1
  a6:	b8e50513          	addi	a0,a0,-1138 # c30 <malloc+0xf6>
  aa:	00001097          	auipc	ra,0x1
  ae:	9d2080e7          	jalr	-1582(ra) # a7c <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	630080e7          	jalr	1584(ra) # 6e4 <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	b8c50513          	addi	a0,a0,-1140 # c48 <malloc+0x10e>
  c4:	00001097          	auipc	ra,0x1
  c8:	9b8080e7          	jalr	-1608(ra) # a7c <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	616080e7          	jalr	1558(ra) # 6e4 <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	60e080e7          	jalr	1550(ra) # 6e4 <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x55507e4>
  e6:	00001517          	auipc	a0,0x1
  ea:	b7250513          	addi	a0,a0,-1166 # c58 <malloc+0x11e>
  ee:	00001097          	auipc	ra,0x1
  f2:	98e080e7          	jalr	-1650(ra) # a7c <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	5ec080e7          	jalr	1516(ra) # 6e4 <exit>

0000000000000100 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	b6850513          	addi	a0,a0,-1176 # c78 <malloc+0x13e>
 118:	00001097          	auipc	ra,0x1
 11c:	964080e7          	jalr	-1692(ra) # a7c <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	648080e7          	jalr	1608(ra) # 76c <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	5a8080e7          	jalr	1448(ra) # 6dc <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	618080e7          	jalr	1560(ra) # 764 <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x5551290>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	58c080e7          	jalr	1420(ra) # 6ec <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	60a080e7          	jalr	1546(ra) # 774 <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	5ec080e7          	jalr	1516(ra) # 764 <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	5de080e7          	jalr	1502(ra) # 76c <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	ad450513          	addi	a0,a0,-1324 # c70 <malloc+0x136>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	8d8080e7          	jalr	-1832(ra) # a7c <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	a7050513          	addi	a0,a0,-1424 # c30 <malloc+0xf6>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	8b4080e7          	jalr	-1868(ra) # a7c <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	512080e7          	jalr	1298(ra) # 6e4 <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	aa650513          	addi	a0,a0,-1370 # c80 <malloc+0x146>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	89a080e7          	jalr	-1894(ra) # a7c <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	4f8080e7          	jalr	1272(ra) # 6e4 <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	4e8080e7          	jalr	1256(ra) # 6dc <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	558080e7          	jalr	1368(ra) # 764 <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff2999e3          	bne	s3,s2,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	540080e7          	jalr	1344(ra) # 764 <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	fe9997e3          	bne	s3,s1,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	4ac080e7          	jalr	1196(ra) # 6e4 <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	a5050513          	addi	a0,a0,-1456 # c90 <malloc+0x156>
 248:	00001097          	auipc	ra,0x1
 24c:	834080e7          	jalr	-1996(ra) # a7c <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	492080e7          	jalr	1170(ra) # 6e4 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x9af>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	472080e7          	jalr	1138(ra) # 6e4 <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a2650513          	addi	a0,a0,-1498 # ca0 <malloc+0x166>
 282:	00000097          	auipc	ra,0x0
 286:	7fa080e7          	jalr	2042(ra) # a7c <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	458080e7          	jalr	1112(ra) # 6e4 <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	a0c50513          	addi	a0,a0,-1524 # ca0 <malloc+0x166>
 29c:	00000097          	auipc	ra,0x0
 2a0:	7e0080e7          	jalr	2016(ra) # a7c <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	43e080e7          	jalr	1086(ra) # 6e4 <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	9a650513          	addi	a0,a0,-1626 # c58 <malloc+0x11e>
 2ba:	00000097          	auipc	ra,0x0
 2be:	7c2080e7          	jalr	1986(ra) # a7c <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	420080e7          	jalr	1056(ra) # 6e4 <exit>

00000000000002cc <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2cc:	7139                	addi	sp,sp,-64
 2ce:	fc06                	sd	ra,56(sp)
 2d0:	f822                	sd	s0,48(sp)
 2d2:	f426                	sd	s1,40(sp)
 2d4:	f04a                	sd	s2,32(sp)
 2d6:	ec4e                	sd	s3,24(sp)
 2d8:	0080                	addi	s0,sp,64
  int parent = getpid();
 2da:	00000097          	auipc	ra,0x0
 2de:	48a080e7          	jalr	1162(ra) # 764 <getpid>
 2e2:	89aa                	mv	s3,a0
  
  printf("file: ");
 2e4:	00001517          	auipc	a0,0x1
 2e8:	9cc50513          	addi	a0,a0,-1588 # cb0 <malloc+0x176>
 2ec:	00000097          	auipc	ra,0x0
 2f0:	790080e7          	jalr	1936(ra) # a7c <printf>
  
  buf[0] = 99;
 2f4:	06300793          	li	a5,99
 2f8:	00002717          	auipc	a4,0x2
 2fc:	a6f70423          	sb	a5,-1432(a4) # 1d60 <buf>

  for(int i = 0; i < 4; i++){
 300:	fc042623          	sw	zero,-52(s0)
    if(pipe(fds) != 0){
 304:	00001497          	auipc	s1,0x1
 308:	a4c48493          	addi	s1,s1,-1460 # d50 <fds>
  for(int i = 0; i < 4; i++){
 30c:	490d                	li	s2,3
    if(pipe(fds) != 0){
 30e:	8526                	mv	a0,s1
 310:	00000097          	auipc	ra,0x0
 314:	3e4080e7          	jalr	996(ra) # 6f4 <pipe>
 318:	e559                	bnez	a0,3a6 <filetest+0xda>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 31a:	00000097          	auipc	ra,0x0
 31e:	3c2080e7          	jalr	962(ra) # 6dc <fork>
    if(pid < 0){
 322:	08054f63          	bltz	a0,3c0 <filetest+0xf4>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 326:	c955                	beqz	a0,3da <filetest+0x10e>
        kill(parent);
        exit(-1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 328:	4611                	li	a2,4
 32a:	fcc40593          	addi	a1,s0,-52
 32e:	40c8                	lw	a0,4(s1)
 330:	00000097          	auipc	ra,0x0
 334:	3d4080e7          	jalr	980(ra) # 704 <write>
 338:	4791                	li	a5,4
 33a:	12f51b63          	bne	a0,a5,470 <filetest+0x1a4>
  for(int i = 0; i < 4; i++){
 33e:	fcc42783          	lw	a5,-52(s0)
 342:	2785                	addiw	a5,a5,1
 344:	0007871b          	sext.w	a4,a5
 348:	fcf42623          	sw	a5,-52(s0)
 34c:	fce951e3          	bge	s2,a4,30e <filetest+0x42>
      exit(-1);
    }
  }

  for(int i = 0; i < 4; i++)
    wait(0);
 350:	4501                	li	a0,0
 352:	00000097          	auipc	ra,0x0
 356:	39a080e7          	jalr	922(ra) # 6ec <wait>
 35a:	4501                	li	a0,0
 35c:	00000097          	auipc	ra,0x0
 360:	390080e7          	jalr	912(ra) # 6ec <wait>
 364:	4501                	li	a0,0
 366:	00000097          	auipc	ra,0x0
 36a:	386080e7          	jalr	902(ra) # 6ec <wait>
 36e:	4501                	li	a0,0
 370:	00000097          	auipc	ra,0x0
 374:	37c080e7          	jalr	892(ra) # 6ec <wait>

  if(buf[0] != 99){
 378:	00002717          	auipc	a4,0x2
 37c:	9e874703          	lbu	a4,-1560(a4) # 1d60 <buf>
 380:	06300793          	li	a5,99
 384:	10f71363          	bne	a4,a5,48a <filetest+0x1be>
    printf("child overwrote parent\n");
    exit(-1);
  }

  printf("ok\n");
 388:	00001517          	auipc	a0,0x1
 38c:	8e850513          	addi	a0,a0,-1816 # c70 <malloc+0x136>
 390:	00000097          	auipc	ra,0x0
 394:	6ec080e7          	jalr	1772(ra) # a7c <printf>
}
 398:	70e2                	ld	ra,56(sp)
 39a:	7442                	ld	s0,48(sp)
 39c:	74a2                	ld	s1,40(sp)
 39e:	7902                	ld	s2,32(sp)
 3a0:	69e2                	ld	s3,24(sp)
 3a2:	6121                	addi	sp,sp,64
 3a4:	8082                	ret
      printf("pipe() failed\n");
 3a6:	00001517          	auipc	a0,0x1
 3aa:	91250513          	addi	a0,a0,-1774 # cb8 <malloc+0x17e>
 3ae:	00000097          	auipc	ra,0x0
 3b2:	6ce080e7          	jalr	1742(ra) # a7c <printf>
      exit(-1);
 3b6:	557d                	li	a0,-1
 3b8:	00000097          	auipc	ra,0x0
 3bc:	32c080e7          	jalr	812(ra) # 6e4 <exit>
      printf("fork failed\n");
 3c0:	00001517          	auipc	a0,0x1
 3c4:	8c050513          	addi	a0,a0,-1856 # c80 <malloc+0x146>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	6b4080e7          	jalr	1716(ra) # a7c <printf>
      exit(-1);
 3d0:	557d                	li	a0,-1
 3d2:	00000097          	auipc	ra,0x0
 3d6:	312080e7          	jalr	786(ra) # 6e4 <exit>
      sleep(1);
 3da:	4505                	li	a0,1
 3dc:	00000097          	auipc	ra,0x0
 3e0:	398080e7          	jalr	920(ra) # 774 <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3e4:	4611                	li	a2,4
 3e6:	00002597          	auipc	a1,0x2
 3ea:	97a58593          	addi	a1,a1,-1670 # 1d60 <buf>
 3ee:	00001517          	auipc	a0,0x1
 3f2:	96252503          	lw	a0,-1694(a0) # d50 <fds>
 3f6:	00000097          	auipc	ra,0x0
 3fa:	306080e7          	jalr	774(ra) # 6fc <read>
 3fe:	4791                	li	a5,4
 400:	04f51163          	bne	a0,a5,442 <filetest+0x176>
      sleep(1);
 404:	4505                	li	a0,1
 406:	00000097          	auipc	ra,0x0
 40a:	36e080e7          	jalr	878(ra) # 774 <sleep>
      if(j != i){
 40e:	fcc42703          	lw	a4,-52(s0)
 412:	00002797          	auipc	a5,0x2
 416:	94e7a783          	lw	a5,-1714(a5) # 1d60 <buf>
 41a:	04f70663          	beq	a4,a5,466 <filetest+0x19a>
        printf("read the wrong value\n");
 41e:	00001517          	auipc	a0,0x1
 422:	8ba50513          	addi	a0,a0,-1862 # cd8 <malloc+0x19e>
 426:	00000097          	auipc	ra,0x0
 42a:	656080e7          	jalr	1622(ra) # a7c <printf>
        kill(parent);
 42e:	854e                	mv	a0,s3
 430:	00000097          	auipc	ra,0x0
 434:	2e4080e7          	jalr	740(ra) # 714 <kill>
        exit(-1);
 438:	557d                	li	a0,-1
 43a:	00000097          	auipc	ra,0x0
 43e:	2aa080e7          	jalr	682(ra) # 6e4 <exit>
        printf("read failed\n");
 442:	00001517          	auipc	a0,0x1
 446:	88650513          	addi	a0,a0,-1914 # cc8 <malloc+0x18e>
 44a:	00000097          	auipc	ra,0x0
 44e:	632080e7          	jalr	1586(ra) # a7c <printf>
        kill(parent);
 452:	854e                	mv	a0,s3
 454:	00000097          	auipc	ra,0x0
 458:	2c0080e7          	jalr	704(ra) # 714 <kill>
        exit(-1);
 45c:	557d                	li	a0,-1
 45e:	00000097          	auipc	ra,0x0
 462:	286080e7          	jalr	646(ra) # 6e4 <exit>
      exit(0);
 466:	4501                	li	a0,0
 468:	00000097          	auipc	ra,0x0
 46c:	27c080e7          	jalr	636(ra) # 6e4 <exit>
      printf("write failed\n");
 470:	00001517          	auipc	a0,0x1
 474:	88050513          	addi	a0,a0,-1920 # cf0 <malloc+0x1b6>
 478:	00000097          	auipc	ra,0x0
 47c:	604080e7          	jalr	1540(ra) # a7c <printf>
      exit(-1);
 480:	557d                	li	a0,-1
 482:	00000097          	auipc	ra,0x0
 486:	262080e7          	jalr	610(ra) # 6e4 <exit>
    printf("child overwrote parent\n");
 48a:	00001517          	auipc	a0,0x1
 48e:	87650513          	addi	a0,a0,-1930 # d00 <malloc+0x1c6>
 492:	00000097          	auipc	ra,0x0
 496:	5ea080e7          	jalr	1514(ra) # a7c <printf>
    exit(-1);
 49a:	557d                	li	a0,-1
 49c:	00000097          	auipc	ra,0x0
 4a0:	248080e7          	jalr	584(ra) # 6e4 <exit>

00000000000004a4 <main>:

int
main(int argc, char *argv[])
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	e022                	sd	s0,0(sp)
 4aa:	0800                	addi	s0,sp,16
  simpletest();
 4ac:	00000097          	auipc	ra,0x0
 4b0:	b54080e7          	jalr	-1196(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 4b4:	00000097          	auipc	ra,0x0
 4b8:	b4c080e7          	jalr	-1204(ra) # 0 <simpletest>

  threetest();
 4bc:	00000097          	auipc	ra,0x0
 4c0:	c44080e7          	jalr	-956(ra) # 100 <threetest>
  threetest();
 4c4:	00000097          	auipc	ra,0x0
 4c8:	c3c080e7          	jalr	-964(ra) # 100 <threetest>
  threetest();
 4cc:	00000097          	auipc	ra,0x0
 4d0:	c34080e7          	jalr	-972(ra) # 100 <threetest>

  filetest();
 4d4:	00000097          	auipc	ra,0x0
 4d8:	df8080e7          	jalr	-520(ra) # 2cc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4dc:	00001517          	auipc	a0,0x1
 4e0:	83c50513          	addi	a0,a0,-1988 # d18 <malloc+0x1de>
 4e4:	00000097          	auipc	ra,0x0
 4e8:	598080e7          	jalr	1432(ra) # a7c <printf>

  exit(0);
 4ec:	4501                	li	a0,0
 4ee:	00000097          	auipc	ra,0x0
 4f2:	1f6080e7          	jalr	502(ra) # 6e4 <exit>

00000000000004f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e422                	sd	s0,8(sp)
 4fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4fc:	87aa                	mv	a5,a0
 4fe:	0585                	addi	a1,a1,1
 500:	0785                	addi	a5,a5,1
 502:	fff5c703          	lbu	a4,-1(a1)
 506:	fee78fa3          	sb	a4,-1(a5)
 50a:	fb75                	bnez	a4,4fe <strcpy+0x8>
    ;
  return os;
}
 50c:	6422                	ld	s0,8(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret

0000000000000512 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 512:	1141                	addi	sp,sp,-16
 514:	e422                	sd	s0,8(sp)
 516:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 518:	00054783          	lbu	a5,0(a0)
 51c:	cb91                	beqz	a5,530 <strcmp+0x1e>
 51e:	0005c703          	lbu	a4,0(a1)
 522:	00f71763          	bne	a4,a5,530 <strcmp+0x1e>
    p++, q++;
 526:	0505                	addi	a0,a0,1
 528:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 52a:	00054783          	lbu	a5,0(a0)
 52e:	fbe5                	bnez	a5,51e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 530:	0005c503          	lbu	a0,0(a1)
}
 534:	40a7853b          	subw	a0,a5,a0
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret

000000000000053e <strlen>:

uint
strlen(const char *s)
{
 53e:	1141                	addi	sp,sp,-16
 540:	e422                	sd	s0,8(sp)
 542:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 544:	00054783          	lbu	a5,0(a0)
 548:	cf91                	beqz	a5,564 <strlen+0x26>
 54a:	0505                	addi	a0,a0,1
 54c:	87aa                	mv	a5,a0
 54e:	4685                	li	a3,1
 550:	9e89                	subw	a3,a3,a0
 552:	00f6853b          	addw	a0,a3,a5
 556:	0785                	addi	a5,a5,1
 558:	fff7c703          	lbu	a4,-1(a5)
 55c:	fb7d                	bnez	a4,552 <strlen+0x14>
    ;
  return n;
}
 55e:	6422                	ld	s0,8(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret
  for(n = 0; s[n]; n++)
 564:	4501                	li	a0,0
 566:	bfe5                	j	55e <strlen+0x20>

0000000000000568 <memset>:

void*
memset(void *dst, int c, uint n)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 56e:	ca19                	beqz	a2,584 <memset+0x1c>
 570:	87aa                	mv	a5,a0
 572:	1602                	slli	a2,a2,0x20
 574:	9201                	srli	a2,a2,0x20
 576:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 57a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 57e:	0785                	addi	a5,a5,1
 580:	fee79de3          	bne	a5,a4,57a <memset+0x12>
  }
  return dst;
}
 584:	6422                	ld	s0,8(sp)
 586:	0141                	addi	sp,sp,16
 588:	8082                	ret

000000000000058a <strchr>:

char*
strchr(const char *s, char c)
{
 58a:	1141                	addi	sp,sp,-16
 58c:	e422                	sd	s0,8(sp)
 58e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 590:	00054783          	lbu	a5,0(a0)
 594:	cb99                	beqz	a5,5aa <strchr+0x20>
    if(*s == c)
 596:	00f58763          	beq	a1,a5,5a4 <strchr+0x1a>
  for(; *s; s++)
 59a:	0505                	addi	a0,a0,1
 59c:	00054783          	lbu	a5,0(a0)
 5a0:	fbfd                	bnez	a5,596 <strchr+0xc>
      return (char*)s;
  return 0;
 5a2:	4501                	li	a0,0
}
 5a4:	6422                	ld	s0,8(sp)
 5a6:	0141                	addi	sp,sp,16
 5a8:	8082                	ret
  return 0;
 5aa:	4501                	li	a0,0
 5ac:	bfe5                	j	5a4 <strchr+0x1a>

00000000000005ae <gets>:

char*
gets(char *buf, int max)
{
 5ae:	711d                	addi	sp,sp,-96
 5b0:	ec86                	sd	ra,88(sp)
 5b2:	e8a2                	sd	s0,80(sp)
 5b4:	e4a6                	sd	s1,72(sp)
 5b6:	e0ca                	sd	s2,64(sp)
 5b8:	fc4e                	sd	s3,56(sp)
 5ba:	f852                	sd	s4,48(sp)
 5bc:	f456                	sd	s5,40(sp)
 5be:	f05a                	sd	s6,32(sp)
 5c0:	ec5e                	sd	s7,24(sp)
 5c2:	1080                	addi	s0,sp,96
 5c4:	8baa                	mv	s7,a0
 5c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c8:	892a                	mv	s2,a0
 5ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5cc:	4aa9                	li	s5,10
 5ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5d0:	89a6                	mv	s3,s1
 5d2:	2485                	addiw	s1,s1,1
 5d4:	0344d863          	bge	s1,s4,604 <gets+0x56>
    cc = read(0, &c, 1);
 5d8:	4605                	li	a2,1
 5da:	faf40593          	addi	a1,s0,-81
 5de:	4501                	li	a0,0
 5e0:	00000097          	auipc	ra,0x0
 5e4:	11c080e7          	jalr	284(ra) # 6fc <read>
    if(cc < 1)
 5e8:	00a05e63          	blez	a0,604 <gets+0x56>
    buf[i++] = c;
 5ec:	faf44783          	lbu	a5,-81(s0)
 5f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5f4:	01578763          	beq	a5,s5,602 <gets+0x54>
 5f8:	0905                	addi	s2,s2,1
 5fa:	fd679be3          	bne	a5,s6,5d0 <gets+0x22>
  for(i=0; i+1 < max; ){
 5fe:	89a6                	mv	s3,s1
 600:	a011                	j	604 <gets+0x56>
 602:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 604:	99de                	add	s3,s3,s7
 606:	00098023          	sb	zero,0(s3) # 199a000 <__BSS_END__+0x1995290>
  return buf;
}
 60a:	855e                	mv	a0,s7
 60c:	60e6                	ld	ra,88(sp)
 60e:	6446                	ld	s0,80(sp)
 610:	64a6                	ld	s1,72(sp)
 612:	6906                	ld	s2,64(sp)
 614:	79e2                	ld	s3,56(sp)
 616:	7a42                	ld	s4,48(sp)
 618:	7aa2                	ld	s5,40(sp)
 61a:	7b02                	ld	s6,32(sp)
 61c:	6be2                	ld	s7,24(sp)
 61e:	6125                	addi	sp,sp,96
 620:	8082                	ret

0000000000000622 <stat>:

int
stat(const char *n, struct stat *st)
{
 622:	1101                	addi	sp,sp,-32
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	e426                	sd	s1,8(sp)
 62a:	e04a                	sd	s2,0(sp)
 62c:	1000                	addi	s0,sp,32
 62e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 630:	4581                	li	a1,0
 632:	00000097          	auipc	ra,0x0
 636:	0f2080e7          	jalr	242(ra) # 724 <open>
  if(fd < 0)
 63a:	02054563          	bltz	a0,664 <stat+0x42>
 63e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 640:	85ca                	mv	a1,s2
 642:	00000097          	auipc	ra,0x0
 646:	0fa080e7          	jalr	250(ra) # 73c <fstat>
 64a:	892a                	mv	s2,a0
  close(fd);
 64c:	8526                	mv	a0,s1
 64e:	00000097          	auipc	ra,0x0
 652:	0be080e7          	jalr	190(ra) # 70c <close>
  return r;
}
 656:	854a                	mv	a0,s2
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	64a2                	ld	s1,8(sp)
 65e:	6902                	ld	s2,0(sp)
 660:	6105                	addi	sp,sp,32
 662:	8082                	ret
    return -1;
 664:	597d                	li	s2,-1
 666:	bfc5                	j	656 <stat+0x34>

0000000000000668 <atoi>:

int
atoi(const char *s)
{
 668:	1141                	addi	sp,sp,-16
 66a:	e422                	sd	s0,8(sp)
 66c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 66e:	00054603          	lbu	a2,0(a0)
 672:	fd06079b          	addiw	a5,a2,-48
 676:	0ff7f793          	andi	a5,a5,255
 67a:	4725                	li	a4,9
 67c:	02f76963          	bltu	a4,a5,6ae <atoi+0x46>
 680:	86aa                	mv	a3,a0
  n = 0;
 682:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 684:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 686:	0685                	addi	a3,a3,1
 688:	0025179b          	slliw	a5,a0,0x2
 68c:	9fa9                	addw	a5,a5,a0
 68e:	0017979b          	slliw	a5,a5,0x1
 692:	9fb1                	addw	a5,a5,a2
 694:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 698:	0006c603          	lbu	a2,0(a3) # 1000 <junk3+0x2a0>
 69c:	fd06071b          	addiw	a4,a2,-48
 6a0:	0ff77713          	andi	a4,a4,255
 6a4:	fee5f1e3          	bgeu	a1,a4,686 <atoi+0x1e>
  return n;
}
 6a8:	6422                	ld	s0,8(sp)
 6aa:	0141                	addi	sp,sp,16
 6ac:	8082                	ret
  n = 0;
 6ae:	4501                	li	a0,0
 6b0:	bfe5                	j	6a8 <atoi+0x40>

00000000000006b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6b2:	1141                	addi	sp,sp,-16
 6b4:	e422                	sd	s0,8(sp)
 6b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6b8:	00c05f63          	blez	a2,6d6 <memmove+0x24>
 6bc:	1602                	slli	a2,a2,0x20
 6be:	9201                	srli	a2,a2,0x20
 6c0:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 6c4:	87aa                	mv	a5,a0
    *dst++ = *src++;
 6c6:	0585                	addi	a1,a1,1
 6c8:	0785                	addi	a5,a5,1
 6ca:	fff5c703          	lbu	a4,-1(a1)
 6ce:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 6d2:	fed79ae3          	bne	a5,a3,6c6 <memmove+0x14>
  return vdst;
}
 6d6:	6422                	ld	s0,8(sp)
 6d8:	0141                	addi	sp,sp,16
 6da:	8082                	ret

00000000000006dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6dc:	4885                	li	a7,1
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6e4:	4889                	li	a7,2
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 6ec:	488d                	li	a7,3
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6f4:	4891                	li	a7,4
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <read>:
.global read
read:
 li a7, SYS_read
 6fc:	4895                	li	a7,5
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <write>:
.global write
write:
 li a7, SYS_write
 704:	48c1                	li	a7,16
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <close>:
.global close
close:
 li a7, SYS_close
 70c:	48d5                	li	a7,21
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <kill>:
.global kill
kill:
 li a7, SYS_kill
 714:	4899                	li	a7,6
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <exec>:
.global exec
exec:
 li a7, SYS_exec
 71c:	489d                	li	a7,7
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <open>:
.global open
open:
 li a7, SYS_open
 724:	48bd                	li	a7,15
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 72c:	48c5                	li	a7,17
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 734:	48c9                	li	a7,18
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 73c:	48a1                	li	a7,8
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <link>:
.global link
link:
 li a7, SYS_link
 744:	48cd                	li	a7,19
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 74c:	48d1                	li	a7,20
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 754:	48a5                	li	a7,9
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <dup>:
.global dup
dup:
 li a7, SYS_dup
 75c:	48a9                	li	a7,10
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 764:	48ad                	li	a7,11
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 76c:	48b1                	li	a7,12
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 774:	48b5                	li	a7,13
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 77c:	48b9                	li	a7,14
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 784:	48d9                	li	a7,22
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <crash>:
.global crash
crash:
 li a7, SYS_crash
 78c:	48dd                	li	a7,23
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <mount>:
.global mount
mount:
 li a7, SYS_mount
 794:	48e1                	li	a7,24
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <umount>:
.global umount
umount:
 li a7, SYS_umount
 79c:	48e5                	li	a7,25
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7a4:	1101                	addi	sp,sp,-32
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7b0:	4605                	li	a2,1
 7b2:	fef40593          	addi	a1,s0,-17
 7b6:	00000097          	auipc	ra,0x0
 7ba:	f4e080e7          	jalr	-178(ra) # 704 <write>
}
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6105                	addi	sp,sp,32
 7c4:	8082                	ret

00000000000007c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7c6:	7139                	addi	sp,sp,-64
 7c8:	fc06                	sd	ra,56(sp)
 7ca:	f822                	sd	s0,48(sp)
 7cc:	f426                	sd	s1,40(sp)
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	0080                	addi	s0,sp,64
 7d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7d6:	c299                	beqz	a3,7dc <printint+0x16>
 7d8:	0805c863          	bltz	a1,868 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7dc:	2581                	sext.w	a1,a1
  neg = 0;
 7de:	4881                	li	a7,0
 7e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7e6:	2601                	sext.w	a2,a2
 7e8:	00000517          	auipc	a0,0x0
 7ec:	55050513          	addi	a0,a0,1360 # d38 <digits>
 7f0:	883a                	mv	a6,a4
 7f2:	2705                	addiw	a4,a4,1
 7f4:	02c5f7bb          	remuw	a5,a1,a2
 7f8:	1782                	slli	a5,a5,0x20
 7fa:	9381                	srli	a5,a5,0x20
 7fc:	97aa                	add	a5,a5,a0
 7fe:	0007c783          	lbu	a5,0(a5)
 802:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 806:	0005879b          	sext.w	a5,a1
 80a:	02c5d5bb          	divuw	a1,a1,a2
 80e:	0685                	addi	a3,a3,1
 810:	fec7f0e3          	bgeu	a5,a2,7f0 <printint+0x2a>
  if(neg)
 814:	00088b63          	beqz	a7,82a <printint+0x64>
    buf[i++] = '-';
 818:	fd040793          	addi	a5,s0,-48
 81c:	973e                	add	a4,a4,a5
 81e:	02d00793          	li	a5,45
 822:	fef70823          	sb	a5,-16(a4)
 826:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 82a:	02e05863          	blez	a4,85a <printint+0x94>
 82e:	fc040793          	addi	a5,s0,-64
 832:	00e78933          	add	s2,a5,a4
 836:	fff78993          	addi	s3,a5,-1
 83a:	99ba                	add	s3,s3,a4
 83c:	377d                	addiw	a4,a4,-1
 83e:	1702                	slli	a4,a4,0x20
 840:	9301                	srli	a4,a4,0x20
 842:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 846:	fff94583          	lbu	a1,-1(s2)
 84a:	8526                	mv	a0,s1
 84c:	00000097          	auipc	ra,0x0
 850:	f58080e7          	jalr	-168(ra) # 7a4 <putc>
  while(--i >= 0)
 854:	197d                	addi	s2,s2,-1
 856:	ff3918e3          	bne	s2,s3,846 <printint+0x80>
}
 85a:	70e2                	ld	ra,56(sp)
 85c:	7442                	ld	s0,48(sp)
 85e:	74a2                	ld	s1,40(sp)
 860:	7902                	ld	s2,32(sp)
 862:	69e2                	ld	s3,24(sp)
 864:	6121                	addi	sp,sp,64
 866:	8082                	ret
    x = -xx;
 868:	40b005bb          	negw	a1,a1
    neg = 1;
 86c:	4885                	li	a7,1
    x = -xx;
 86e:	bf8d                	j	7e0 <printint+0x1a>

0000000000000870 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 870:	7119                	addi	sp,sp,-128
 872:	fc86                	sd	ra,120(sp)
 874:	f8a2                	sd	s0,112(sp)
 876:	f4a6                	sd	s1,104(sp)
 878:	f0ca                	sd	s2,96(sp)
 87a:	ecce                	sd	s3,88(sp)
 87c:	e8d2                	sd	s4,80(sp)
 87e:	e4d6                	sd	s5,72(sp)
 880:	e0da                	sd	s6,64(sp)
 882:	fc5e                	sd	s7,56(sp)
 884:	f862                	sd	s8,48(sp)
 886:	f466                	sd	s9,40(sp)
 888:	f06a                	sd	s10,32(sp)
 88a:	ec6e                	sd	s11,24(sp)
 88c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 88e:	0005c903          	lbu	s2,0(a1)
 892:	18090f63          	beqz	s2,a30 <vprintf+0x1c0>
 896:	8aaa                	mv	s5,a0
 898:	8b32                	mv	s6,a2
 89a:	00158493          	addi	s1,a1,1
  state = 0;
 89e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8a0:	02500a13          	li	s4,37
      if(c == 'd'){
 8a4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8a8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 8ac:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 8b0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b4:	00000b97          	auipc	s7,0x0
 8b8:	484b8b93          	addi	s7,s7,1156 # d38 <digits>
 8bc:	a839                	j	8da <vprintf+0x6a>
        putc(fd, c);
 8be:	85ca                	mv	a1,s2
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	ee2080e7          	jalr	-286(ra) # 7a4 <putc>
 8ca:	a019                	j	8d0 <vprintf+0x60>
    } else if(state == '%'){
 8cc:	01498f63          	beq	s3,s4,8ea <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8d0:	0485                	addi	s1,s1,1
 8d2:	fff4c903          	lbu	s2,-1(s1)
 8d6:	14090d63          	beqz	s2,a30 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8da:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8de:	fe0997e3          	bnez	s3,8cc <vprintf+0x5c>
      if(c == '%'){
 8e2:	fd479ee3          	bne	a5,s4,8be <vprintf+0x4e>
        state = '%';
 8e6:	89be                	mv	s3,a5
 8e8:	b7e5                	j	8d0 <vprintf+0x60>
      if(c == 'd'){
 8ea:	05878063          	beq	a5,s8,92a <vprintf+0xba>
      } else if(c == 'l') {
 8ee:	05978c63          	beq	a5,s9,946 <vprintf+0xd6>
      } else if(c == 'x') {
 8f2:	07a78863          	beq	a5,s10,962 <vprintf+0xf2>
      } else if(c == 'p') {
 8f6:	09b78463          	beq	a5,s11,97e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8fa:	07300713          	li	a4,115
 8fe:	0ce78663          	beq	a5,a4,9ca <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 902:	06300713          	li	a4,99
 906:	0ee78e63          	beq	a5,a4,a02 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 90a:	11478863          	beq	a5,s4,a1a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 90e:	85d2                	mv	a1,s4
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	e92080e7          	jalr	-366(ra) # 7a4 <putc>
        putc(fd, c);
 91a:	85ca                	mv	a1,s2
 91c:	8556                	mv	a0,s5
 91e:	00000097          	auipc	ra,0x0
 922:	e86080e7          	jalr	-378(ra) # 7a4 <putc>
      }
      state = 0;
 926:	4981                	li	s3,0
 928:	b765                	j	8d0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 92a:	008b0913          	addi	s2,s6,8
 92e:	4685                	li	a3,1
 930:	4629                	li	a2,10
 932:	000b2583          	lw	a1,0(s6)
 936:	8556                	mv	a0,s5
 938:	00000097          	auipc	ra,0x0
 93c:	e8e080e7          	jalr	-370(ra) # 7c6 <printint>
 940:	8b4a                	mv	s6,s2
      state = 0;
 942:	4981                	li	s3,0
 944:	b771                	j	8d0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 946:	008b0913          	addi	s2,s6,8
 94a:	4681                	li	a3,0
 94c:	4629                	li	a2,10
 94e:	000b2583          	lw	a1,0(s6)
 952:	8556                	mv	a0,s5
 954:	00000097          	auipc	ra,0x0
 958:	e72080e7          	jalr	-398(ra) # 7c6 <printint>
 95c:	8b4a                	mv	s6,s2
      state = 0;
 95e:	4981                	li	s3,0
 960:	bf85                	j	8d0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 962:	008b0913          	addi	s2,s6,8
 966:	4681                	li	a3,0
 968:	4641                	li	a2,16
 96a:	000b2583          	lw	a1,0(s6)
 96e:	8556                	mv	a0,s5
 970:	00000097          	auipc	ra,0x0
 974:	e56080e7          	jalr	-426(ra) # 7c6 <printint>
 978:	8b4a                	mv	s6,s2
      state = 0;
 97a:	4981                	li	s3,0
 97c:	bf91                	j	8d0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 97e:	008b0793          	addi	a5,s6,8
 982:	f8f43423          	sd	a5,-120(s0)
 986:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 98a:	03000593          	li	a1,48
 98e:	8556                	mv	a0,s5
 990:	00000097          	auipc	ra,0x0
 994:	e14080e7          	jalr	-492(ra) # 7a4 <putc>
  putc(fd, 'x');
 998:	85ea                	mv	a1,s10
 99a:	8556                	mv	a0,s5
 99c:	00000097          	auipc	ra,0x0
 9a0:	e08080e7          	jalr	-504(ra) # 7a4 <putc>
 9a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9a6:	03c9d793          	srli	a5,s3,0x3c
 9aa:	97de                	add	a5,a5,s7
 9ac:	0007c583          	lbu	a1,0(a5)
 9b0:	8556                	mv	a0,s5
 9b2:	00000097          	auipc	ra,0x0
 9b6:	df2080e7          	jalr	-526(ra) # 7a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9ba:	0992                	slli	s3,s3,0x4
 9bc:	397d                	addiw	s2,s2,-1
 9be:	fe0914e3          	bnez	s2,9a6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9c2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	b721                	j	8d0 <vprintf+0x60>
        s = va_arg(ap, char*);
 9ca:	008b0993          	addi	s3,s6,8
 9ce:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9d2:	02090163          	beqz	s2,9f4 <vprintf+0x184>
        while(*s != 0){
 9d6:	00094583          	lbu	a1,0(s2)
 9da:	c9a1                	beqz	a1,a2a <vprintf+0x1ba>
          putc(fd, *s);
 9dc:	8556                	mv	a0,s5
 9de:	00000097          	auipc	ra,0x0
 9e2:	dc6080e7          	jalr	-570(ra) # 7a4 <putc>
          s++;
 9e6:	0905                	addi	s2,s2,1
        while(*s != 0){
 9e8:	00094583          	lbu	a1,0(s2)
 9ec:	f9e5                	bnez	a1,9dc <vprintf+0x16c>
        s = va_arg(ap, char*);
 9ee:	8b4e                	mv	s6,s3
      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	bdf9                	j	8d0 <vprintf+0x60>
          s = "(null)";
 9f4:	00000917          	auipc	s2,0x0
 9f8:	33c90913          	addi	s2,s2,828 # d30 <malloc+0x1f6>
        while(*s != 0){
 9fc:	02800593          	li	a1,40
 a00:	bff1                	j	9dc <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 a02:	008b0913          	addi	s2,s6,8
 a06:	000b4583          	lbu	a1,0(s6)
 a0a:	8556                	mv	a0,s5
 a0c:	00000097          	auipc	ra,0x0
 a10:	d98080e7          	jalr	-616(ra) # 7a4 <putc>
 a14:	8b4a                	mv	s6,s2
      state = 0;
 a16:	4981                	li	s3,0
 a18:	bd65                	j	8d0 <vprintf+0x60>
        putc(fd, c);
 a1a:	85d2                	mv	a1,s4
 a1c:	8556                	mv	a0,s5
 a1e:	00000097          	auipc	ra,0x0
 a22:	d86080e7          	jalr	-634(ra) # 7a4 <putc>
      state = 0;
 a26:	4981                	li	s3,0
 a28:	b565                	j	8d0 <vprintf+0x60>
        s = va_arg(ap, char*);
 a2a:	8b4e                	mv	s6,s3
      state = 0;
 a2c:	4981                	li	s3,0
 a2e:	b54d                	j	8d0 <vprintf+0x60>
    }
  }
}
 a30:	70e6                	ld	ra,120(sp)
 a32:	7446                	ld	s0,112(sp)
 a34:	74a6                	ld	s1,104(sp)
 a36:	7906                	ld	s2,96(sp)
 a38:	69e6                	ld	s3,88(sp)
 a3a:	6a46                	ld	s4,80(sp)
 a3c:	6aa6                	ld	s5,72(sp)
 a3e:	6b06                	ld	s6,64(sp)
 a40:	7be2                	ld	s7,56(sp)
 a42:	7c42                	ld	s8,48(sp)
 a44:	7ca2                	ld	s9,40(sp)
 a46:	7d02                	ld	s10,32(sp)
 a48:	6de2                	ld	s11,24(sp)
 a4a:	6109                	addi	sp,sp,128
 a4c:	8082                	ret

0000000000000a4e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a4e:	715d                	addi	sp,sp,-80
 a50:	ec06                	sd	ra,24(sp)
 a52:	e822                	sd	s0,16(sp)
 a54:	1000                	addi	s0,sp,32
 a56:	e010                	sd	a2,0(s0)
 a58:	e414                	sd	a3,8(s0)
 a5a:	e818                	sd	a4,16(s0)
 a5c:	ec1c                	sd	a5,24(s0)
 a5e:	03043023          	sd	a6,32(s0)
 a62:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a66:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a6a:	8622                	mv	a2,s0
 a6c:	00000097          	auipc	ra,0x0
 a70:	e04080e7          	jalr	-508(ra) # 870 <vprintf>
}
 a74:	60e2                	ld	ra,24(sp)
 a76:	6442                	ld	s0,16(sp)
 a78:	6161                	addi	sp,sp,80
 a7a:	8082                	ret

0000000000000a7c <printf>:

void
printf(const char *fmt, ...)
{
 a7c:	711d                	addi	sp,sp,-96
 a7e:	ec06                	sd	ra,24(sp)
 a80:	e822                	sd	s0,16(sp)
 a82:	1000                	addi	s0,sp,32
 a84:	e40c                	sd	a1,8(s0)
 a86:	e810                	sd	a2,16(s0)
 a88:	ec14                	sd	a3,24(s0)
 a8a:	f018                	sd	a4,32(s0)
 a8c:	f41c                	sd	a5,40(s0)
 a8e:	03043823          	sd	a6,48(s0)
 a92:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a96:	00840613          	addi	a2,s0,8
 a9a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a9e:	85aa                	mv	a1,a0
 aa0:	4505                	li	a0,1
 aa2:	00000097          	auipc	ra,0x0
 aa6:	dce080e7          	jalr	-562(ra) # 870 <vprintf>
}
 aaa:	60e2                	ld	ra,24(sp)
 aac:	6442                	ld	s0,16(sp)
 aae:	6125                	addi	sp,sp,96
 ab0:	8082                	ret

0000000000000ab2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab2:	1141                	addi	sp,sp,-16
 ab4:	e422                	sd	s0,8(sp)
 ab6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ab8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abc:	00000797          	auipc	a5,0x0
 ac0:	29c7b783          	ld	a5,668(a5) # d58 <freep>
 ac4:	a805                	j	af4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ac6:	4618                	lw	a4,8(a2)
 ac8:	9db9                	addw	a1,a1,a4
 aca:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ace:	6398                	ld	a4,0(a5)
 ad0:	6318                	ld	a4,0(a4)
 ad2:	fee53823          	sd	a4,-16(a0)
 ad6:	a091                	j	b1a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ad8:	ff852703          	lw	a4,-8(a0)
 adc:	9e39                	addw	a2,a2,a4
 ade:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ae0:	ff053703          	ld	a4,-16(a0)
 ae4:	e398                	sd	a4,0(a5)
 ae6:	a099                	j	b2c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae8:	6398                	ld	a4,0(a5)
 aea:	00e7e463          	bltu	a5,a4,af2 <free+0x40>
 aee:	00e6ea63          	bltu	a3,a4,b02 <free+0x50>
{
 af2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af4:	fed7fae3          	bgeu	a5,a3,ae8 <free+0x36>
 af8:	6398                	ld	a4,0(a5)
 afa:	00e6e463          	bltu	a3,a4,b02 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afe:	fee7eae3          	bltu	a5,a4,af2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 b02:	ff852583          	lw	a1,-8(a0)
 b06:	6390                	ld	a2,0(a5)
 b08:	02059813          	slli	a6,a1,0x20
 b0c:	01c85713          	srli	a4,a6,0x1c
 b10:	9736                	add	a4,a4,a3
 b12:	fae60ae3          	beq	a2,a4,ac6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 b16:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b1a:	4790                	lw	a2,8(a5)
 b1c:	02061593          	slli	a1,a2,0x20
 b20:	01c5d713          	srli	a4,a1,0x1c
 b24:	973e                	add	a4,a4,a5
 b26:	fae689e3          	beq	a3,a4,ad8 <free+0x26>
  } else
    p->s.ptr = bp;
 b2a:	e394                	sd	a3,0(a5)
  freep = p;
 b2c:	00000717          	auipc	a4,0x0
 b30:	22f73623          	sd	a5,556(a4) # d58 <freep>
}
 b34:	6422                	ld	s0,8(sp)
 b36:	0141                	addi	sp,sp,16
 b38:	8082                	ret

0000000000000b3a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b3a:	7139                	addi	sp,sp,-64
 b3c:	fc06                	sd	ra,56(sp)
 b3e:	f822                	sd	s0,48(sp)
 b40:	f426                	sd	s1,40(sp)
 b42:	f04a                	sd	s2,32(sp)
 b44:	ec4e                	sd	s3,24(sp)
 b46:	e852                	sd	s4,16(sp)
 b48:	e456                	sd	s5,8(sp)
 b4a:	e05a                	sd	s6,0(sp)
 b4c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b4e:	02051493          	slli	s1,a0,0x20
 b52:	9081                	srli	s1,s1,0x20
 b54:	04bd                	addi	s1,s1,15
 b56:	8091                	srli	s1,s1,0x4
 b58:	0014899b          	addiw	s3,s1,1
 b5c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b5e:	00000517          	auipc	a0,0x0
 b62:	1fa53503          	ld	a0,506(a0) # d58 <freep>
 b66:	c515                	beqz	a0,b92 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b68:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b6a:	4798                	lw	a4,8(a5)
 b6c:	02977f63          	bgeu	a4,s1,baa <malloc+0x70>
 b70:	8a4e                	mv	s4,s3
 b72:	0009871b          	sext.w	a4,s3
 b76:	6685                	lui	a3,0x1
 b78:	00d77363          	bgeu	a4,a3,b7e <malloc+0x44>
 b7c:	6a05                	lui	s4,0x1
 b7e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b82:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b86:	00000917          	auipc	s2,0x0
 b8a:	1d290913          	addi	s2,s2,466 # d58 <freep>
  if(p == (char*)-1)
 b8e:	5afd                	li	s5,-1
 b90:	a895                	j	c04 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b92:	00004797          	auipc	a5,0x4
 b96:	1ce78793          	addi	a5,a5,462 # 4d60 <base>
 b9a:	00000717          	auipc	a4,0x0
 b9e:	1af73f23          	sd	a5,446(a4) # d58 <freep>
 ba2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ba4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ba8:	b7e1                	j	b70 <malloc+0x36>
      if(p->s.size == nunits)
 baa:	02e48c63          	beq	s1,a4,be2 <malloc+0xa8>
        p->s.size -= nunits;
 bae:	4137073b          	subw	a4,a4,s3
 bb2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bb4:	02071693          	slli	a3,a4,0x20
 bb8:	01c6d713          	srli	a4,a3,0x1c
 bbc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bbe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bc2:	00000717          	auipc	a4,0x0
 bc6:	18a73b23          	sd	a0,406(a4) # d58 <freep>
      return (void*)(p + 1);
 bca:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bce:	70e2                	ld	ra,56(sp)
 bd0:	7442                	ld	s0,48(sp)
 bd2:	74a2                	ld	s1,40(sp)
 bd4:	7902                	ld	s2,32(sp)
 bd6:	69e2                	ld	s3,24(sp)
 bd8:	6a42                	ld	s4,16(sp)
 bda:	6aa2                	ld	s5,8(sp)
 bdc:	6b02                	ld	s6,0(sp)
 bde:	6121                	addi	sp,sp,64
 be0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 be2:	6398                	ld	a4,0(a5)
 be4:	e118                	sd	a4,0(a0)
 be6:	bff1                	j	bc2 <malloc+0x88>
  hp->s.size = nu;
 be8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bec:	0541                	addi	a0,a0,16
 bee:	00000097          	auipc	ra,0x0
 bf2:	ec4080e7          	jalr	-316(ra) # ab2 <free>
  return freep;
 bf6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bfa:	d971                	beqz	a0,bce <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bfc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bfe:	4798                	lw	a4,8(a5)
 c00:	fa9775e3          	bgeu	a4,s1,baa <malloc+0x70>
    if(p == freep)
 c04:	00093703          	ld	a4,0(s2)
 c08:	853e                	mv	a0,a5
 c0a:	fef719e3          	bne	a4,a5,bfc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 c0e:	8552                	mv	a0,s4
 c10:	00000097          	auipc	ra,0x0
 c14:	b5c080e7          	jalr	-1188(ra) # 76c <sbrk>
  if(p == (char*)-1)
 c18:	fd5518e3          	bne	a0,s5,be8 <malloc+0xae>
        return 0;
 c1c:	4501                	li	a0,0
 c1e:	bf45                	j	bce <malloc+0x94>
