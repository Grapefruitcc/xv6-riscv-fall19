
user/_mounttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
  test4();
  exit(0);
}

void test0()
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	0080                	addi	s0,sp,64
  int fd;
  char buf[4];
  struct stat st;
  
  printf("test0 start\n");
       a:	00001517          	auipc	a0,0x1
       e:	1d650513          	addi	a0,a0,470 # 11e0 <malloc+0xec>
      12:	00001097          	auipc	ra,0x1
      16:	024080e7          	jalr	36(ra) # 1036 <printf>

  mknod("disk1", DISK, 1);
      1a:	4605                	li	a2,1
      1c:	4581                	li	a1,0
      1e:	00001517          	auipc	a0,0x1
      22:	1d250513          	addi	a0,a0,466 # 11f0 <malloc+0xfc>
      26:	00001097          	auipc	ra,0x1
      2a:	cc0080e7          	jalr	-832(ra) # ce6 <mknod>
  mkdir("/m");
      2e:	00001517          	auipc	a0,0x1
      32:	1ca50513          	addi	a0,a0,458 # 11f8 <malloc+0x104>
      36:	00001097          	auipc	ra,0x1
      3a:	cd0080e7          	jalr	-816(ra) # d06 <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
      3e:	00001597          	auipc	a1,0x1
      42:	1ba58593          	addi	a1,a1,442 # 11f8 <malloc+0x104>
      46:	00001517          	auipc	a0,0x1
      4a:	1ba50513          	addi	a0,a0,442 # 1200 <malloc+0x10c>
      4e:	00001097          	auipc	ra,0x1
      52:	d00080e7          	jalr	-768(ra) # d4e <mount>
      56:	1a054663          	bltz	a0,202 <test0+0x202>
    printf("mount failed\n");
    exit(-1);
  }    

  if (stat("/m", &st) < 0) {
      5a:	fc040593          	addi	a1,s0,-64
      5e:	00001517          	auipc	a0,0x1
      62:	19a50513          	addi	a0,a0,410 # 11f8 <malloc+0x104>
      66:	00001097          	auipc	ra,0x1
      6a:	b76080e7          	jalr	-1162(ra) # bdc <stat>
      6e:	1a054763          	bltz	a0,21c <test0+0x21c>
    printf("stat /m failed\n");
    exit(-1);
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
      72:	f00017b7          	lui	a5,0xf0001
      76:	fc043703          	ld	a4,-64(s0)
      7a:	0792                	slli	a5,a5,0x4
      7c:	17fd                	addi	a5,a5,-1
      7e:	8f7d                	and	a4,a4,a5
      80:	4785                	li	a5,1
      82:	1782                	slli	a5,a5,0x20
      84:	0785                	addi	a5,a5,1
      86:	1af71863          	bne	a4,a5,236 <test0+0x236>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit(-1);
  }
  
  if ((fd = open("/m/README", O_RDONLY)) < 0) {
      8a:	4581                	li	a1,0
      8c:	00001517          	auipc	a0,0x1
      90:	1bc50513          	addi	a0,a0,444 # 1248 <malloc+0x154>
      94:	00001097          	auipc	ra,0x1
      98:	c4a080e7          	jalr	-950(ra) # cde <open>
      9c:	84aa                	mv	s1,a0
      9e:	1a054d63          	bltz	a0,258 <test0+0x258>
    printf("open read failed\n");
    exit(-1);
  }
  if (read(fd, buf, sizeof(buf)-1) != sizeof(buf)-1) {
      a2:	460d                	li	a2,3
      a4:	fd840593          	addi	a1,s0,-40
      a8:	00001097          	auipc	ra,0x1
      ac:	c0e080e7          	jalr	-1010(ra) # cb6 <read>
      b0:	478d                	li	a5,3
      b2:	1cf51063          	bne	a0,a5,272 <test0+0x272>
    printf("read failed\n");
    exit(-1);
  }
  if (strcmp("xv6", buf) != 0) {
      b6:	fd840593          	addi	a1,s0,-40
      ba:	00001517          	auipc	a0,0x1
      be:	1c650513          	addi	a0,a0,454 # 1280 <malloc+0x18c>
      c2:	00001097          	auipc	ra,0x1
      c6:	a0a080e7          	jalr	-1526(ra) # acc <strcmp>
      ca:	1c051163          	bnez	a0,28c <test0+0x28c>
    printf("read failed\n", buf);
  }
  close(fd);
      ce:	8526                	mv	a0,s1
      d0:	00001097          	auipc	ra,0x1
      d4:	bf6080e7          	jalr	-1034(ra) # cc6 <close>
  
  if ((fd = open("/m/a", O_CREATE|O_WRONLY)) < 0) {
      d8:	20100593          	li	a1,513
      dc:	00001517          	auipc	a0,0x1
      e0:	1ac50513          	addi	a0,a0,428 # 1288 <malloc+0x194>
      e4:	00001097          	auipc	ra,0x1
      e8:	bfa080e7          	jalr	-1030(ra) # cde <open>
      ec:	84aa                	mv	s1,a0
      ee:	1a054a63          	bltz	a0,2a2 <test0+0x2a2>
    printf("open write failed\n");
    exit(-1);
  }
  
  if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
      f2:	4611                	li	a2,4
      f4:	fd840593          	addi	a1,s0,-40
      f8:	00001097          	auipc	ra,0x1
      fc:	bc6080e7          	jalr	-1082(ra) # cbe <write>
     100:	4791                	li	a5,4
     102:	1af51d63          	bne	a0,a5,2bc <test0+0x2bc>
    printf("write failed\n");
    exit(-1);
  }

  close(fd);
     106:	8526                	mv	a0,s1
     108:	00001097          	auipc	ra,0x1
     10c:	bbe080e7          	jalr	-1090(ra) # cc6 <close>

  if (stat("/m/a", &st) < 0) {
     110:	fc040593          	addi	a1,s0,-64
     114:	00001517          	auipc	a0,0x1
     118:	17450513          	addi	a0,a0,372 # 1288 <malloc+0x194>
     11c:	00001097          	auipc	ra,0x1
     120:	ac0080e7          	jalr	-1344(ra) # bdc <stat>
     124:	1a054963          	bltz	a0,2d6 <test0+0x2d6>
    printf("stat /m/a failed\n");
    exit(-1);
  }

  if (minor(st.dev) != 1) {
     128:	fc045583          	lhu	a1,-64(s0)
     12c:	4785                	li	a5,1
     12e:	1cf59163          	bne	a1,a5,2f0 <test0+0x2f0>
    printf("stat wrong minor %d\n", minor(st.dev));
    exit(-1);
  }


  if (link("m/a", "/a") == 0) {
     132:	00001597          	auipc	a1,0x1
     136:	1b658593          	addi	a1,a1,438 # 12e8 <malloc+0x1f4>
     13a:	00001517          	auipc	a0,0x1
     13e:	1b650513          	addi	a0,a0,438 # 12f0 <malloc+0x1fc>
     142:	00001097          	auipc	ra,0x1
     146:	bbc080e7          	jalr	-1092(ra) # cfe <link>
     14a:	1c050063          	beqz	a0,30a <test0+0x30a>
    printf("link m/a a succeeded\n");
    exit(-1);
  }

  if (unlink("m/a") < 0) {
     14e:	00001517          	auipc	a0,0x1
     152:	1a250513          	addi	a0,a0,418 # 12f0 <malloc+0x1fc>
     156:	00001097          	auipc	ra,0x1
     15a:	b98080e7          	jalr	-1128(ra) # cee <unlink>
     15e:	1c054363          	bltz	a0,324 <test0+0x324>
    printf("unlink m/a failed\n");
    exit(-1);
  }

  if (chdir("/m") < 0) {
     162:	00001517          	auipc	a0,0x1
     166:	09650513          	addi	a0,a0,150 # 11f8 <malloc+0x104>
     16a:	00001097          	auipc	ra,0x1
     16e:	ba4080e7          	jalr	-1116(ra) # d0e <chdir>
     172:	1c054663          	bltz	a0,33e <test0+0x33e>
    printf("chdir /m failed\n");
    exit(-1);
  }

  if (stat(".", &st) < 0) {
     176:	fc040593          	addi	a1,s0,-64
     17a:	00001517          	auipc	a0,0x1
     17e:	1c650513          	addi	a0,a0,454 # 1340 <malloc+0x24c>
     182:	00001097          	auipc	ra,0x1
     186:	a5a080e7          	jalr	-1446(ra) # bdc <stat>
     18a:	1c054763          	bltz	a0,358 <test0+0x358>
    printf("stat . failed\n");
    exit(-1);
  }

  if (st.ino != 1 || minor(st.dev) != 1) {
     18e:	f00017b7          	lui	a5,0xf0001
     192:	fc043703          	ld	a4,-64(s0)
     196:	0792                	slli	a5,a5,0x4
     198:	17fd                	addi	a5,a5,-1
     19a:	8f7d                	and	a4,a4,a5
     19c:	4785                	li	a5,1
     19e:	1782                	slli	a5,a5,0x20
     1a0:	0785                	addi	a5,a5,1
     1a2:	1cf71863          	bne	a4,a5,372 <test0+0x372>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit(-1);
  }

  if (chdir("..") < 0) {
     1a6:	00001517          	auipc	a0,0x1
     1aa:	1b250513          	addi	a0,a0,434 # 1358 <malloc+0x264>
     1ae:	00001097          	auipc	ra,0x1
     1b2:	b60080e7          	jalr	-1184(ra) # d0e <chdir>
     1b6:	1c054f63          	bltz	a0,394 <test0+0x394>
    printf("chdir .. failed\n");
    exit(-1);
  }

  if (stat(".", &st) < 0) {
     1ba:	fc040593          	addi	a1,s0,-64
     1be:	00001517          	auipc	a0,0x1
     1c2:	18250513          	addi	a0,a0,386 # 1340 <malloc+0x24c>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	a16080e7          	jalr	-1514(ra) # bdc <stat>
     1ce:	1e054063          	bltz	a0,3ae <test0+0x3ae>
    printf("stat . failed\n");
    exit(-1);
  }

  if (st.ino == 1 && minor(st.dev) == 0) {
     1d2:	f00017b7          	lui	a5,0xf0001
     1d6:	fc043703          	ld	a4,-64(s0)
     1da:	0792                	slli	a5,a5,0x4
     1dc:	17fd                	addi	a5,a5,-1
     1de:	8ff9                	and	a5,a5,a4
     1e0:	4705                	li	a4,1
     1e2:	1702                	slli	a4,a4,0x20
     1e4:	1ee78263          	beq	a5,a4,3c8 <test0+0x3c8>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
    exit(-1);
  }

  printf("test0 done\n");
     1e8:	00001517          	auipc	a0,0x1
     1ec:	19050513          	addi	a0,a0,400 # 1378 <malloc+0x284>
     1f0:	00001097          	auipc	ra,0x1
     1f4:	e46080e7          	jalr	-442(ra) # 1036 <printf>
}
     1f8:	70e2                	ld	ra,56(sp)
     1fa:	7442                	ld	s0,48(sp)
     1fc:	74a2                	ld	s1,40(sp)
     1fe:	6121                	addi	sp,sp,64
     200:	8082                	ret
    printf("mount failed\n");
     202:	00001517          	auipc	a0,0x1
     206:	00650513          	addi	a0,a0,6 # 1208 <malloc+0x114>
     20a:	00001097          	auipc	ra,0x1
     20e:	e2c080e7          	jalr	-468(ra) # 1036 <printf>
    exit(-1);
     212:	557d                	li	a0,-1
     214:	00001097          	auipc	ra,0x1
     218:	a8a080e7          	jalr	-1398(ra) # c9e <exit>
    printf("stat /m failed\n");
     21c:	00001517          	auipc	a0,0x1
     220:	ffc50513          	addi	a0,a0,-4 # 1218 <malloc+0x124>
     224:	00001097          	auipc	ra,0x1
     228:	e12080e7          	jalr	-494(ra) # 1036 <printf>
    exit(-1);
     22c:	557d                	li	a0,-1
     22e:	00001097          	auipc	ra,0x1
     232:	a70080e7          	jalr	-1424(ra) # c9e <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     236:	fc045603          	lhu	a2,-64(s0)
     23a:	fc442583          	lw	a1,-60(s0)
     23e:	00001517          	auipc	a0,0x1
     242:	fea50513          	addi	a0,a0,-22 # 1228 <malloc+0x134>
     246:	00001097          	auipc	ra,0x1
     24a:	df0080e7          	jalr	-528(ra) # 1036 <printf>
    exit(-1);
     24e:	557d                	li	a0,-1
     250:	00001097          	auipc	ra,0x1
     254:	a4e080e7          	jalr	-1458(ra) # c9e <exit>
    printf("open read failed\n");
     258:	00001517          	auipc	a0,0x1
     25c:	00050513          	mv	a0,a0
     260:	00001097          	auipc	ra,0x1
     264:	dd6080e7          	jalr	-554(ra) # 1036 <printf>
    exit(-1);
     268:	557d                	li	a0,-1
     26a:	00001097          	auipc	ra,0x1
     26e:	a34080e7          	jalr	-1484(ra) # c9e <exit>
    printf("read failed\n");
     272:	00001517          	auipc	a0,0x1
     276:	ffe50513          	addi	a0,a0,-2 # 1270 <malloc+0x17c>
     27a:	00001097          	auipc	ra,0x1
     27e:	dbc080e7          	jalr	-580(ra) # 1036 <printf>
    exit(-1);
     282:	557d                	li	a0,-1
     284:	00001097          	auipc	ra,0x1
     288:	a1a080e7          	jalr	-1510(ra) # c9e <exit>
    printf("read failed\n", buf);
     28c:	fd840593          	addi	a1,s0,-40
     290:	00001517          	auipc	a0,0x1
     294:	fe050513          	addi	a0,a0,-32 # 1270 <malloc+0x17c>
     298:	00001097          	auipc	ra,0x1
     29c:	d9e080e7          	jalr	-610(ra) # 1036 <printf>
     2a0:	b53d                	j	ce <test0+0xce>
    printf("open write failed\n");
     2a2:	00001517          	auipc	a0,0x1
     2a6:	fee50513          	addi	a0,a0,-18 # 1290 <malloc+0x19c>
     2aa:	00001097          	auipc	ra,0x1
     2ae:	d8c080e7          	jalr	-628(ra) # 1036 <printf>
    exit(-1);
     2b2:	557d                	li	a0,-1
     2b4:	00001097          	auipc	ra,0x1
     2b8:	9ea080e7          	jalr	-1558(ra) # c9e <exit>
    printf("write failed\n");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	fec50513          	addi	a0,a0,-20 # 12a8 <malloc+0x1b4>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	d72080e7          	jalr	-654(ra) # 1036 <printf>
    exit(-1);
     2cc:	557d                	li	a0,-1
     2ce:	00001097          	auipc	ra,0x1
     2d2:	9d0080e7          	jalr	-1584(ra) # c9e <exit>
    printf("stat /m/a failed\n");
     2d6:	00001517          	auipc	a0,0x1
     2da:	fe250513          	addi	a0,a0,-30 # 12b8 <malloc+0x1c4>
     2de:	00001097          	auipc	ra,0x1
     2e2:	d58080e7          	jalr	-680(ra) # 1036 <printf>
    exit(-1);
     2e6:	557d                	li	a0,-1
     2e8:	00001097          	auipc	ra,0x1
     2ec:	9b6080e7          	jalr	-1610(ra) # c9e <exit>
    printf("stat wrong minor %d\n", minor(st.dev));
     2f0:	00001517          	auipc	a0,0x1
     2f4:	fe050513          	addi	a0,a0,-32 # 12d0 <malloc+0x1dc>
     2f8:	00001097          	auipc	ra,0x1
     2fc:	d3e080e7          	jalr	-706(ra) # 1036 <printf>
    exit(-1);
     300:	557d                	li	a0,-1
     302:	00001097          	auipc	ra,0x1
     306:	99c080e7          	jalr	-1636(ra) # c9e <exit>
    printf("link m/a a succeeded\n");
     30a:	00001517          	auipc	a0,0x1
     30e:	fee50513          	addi	a0,a0,-18 # 12f8 <malloc+0x204>
     312:	00001097          	auipc	ra,0x1
     316:	d24080e7          	jalr	-732(ra) # 1036 <printf>
    exit(-1);
     31a:	557d                	li	a0,-1
     31c:	00001097          	auipc	ra,0x1
     320:	982080e7          	jalr	-1662(ra) # c9e <exit>
    printf("unlink m/a failed\n");
     324:	00001517          	auipc	a0,0x1
     328:	fec50513          	addi	a0,a0,-20 # 1310 <malloc+0x21c>
     32c:	00001097          	auipc	ra,0x1
     330:	d0a080e7          	jalr	-758(ra) # 1036 <printf>
    exit(-1);
     334:	557d                	li	a0,-1
     336:	00001097          	auipc	ra,0x1
     33a:	968080e7          	jalr	-1688(ra) # c9e <exit>
    printf("chdir /m failed\n");
     33e:	00001517          	auipc	a0,0x1
     342:	fea50513          	addi	a0,a0,-22 # 1328 <malloc+0x234>
     346:	00001097          	auipc	ra,0x1
     34a:	cf0080e7          	jalr	-784(ra) # 1036 <printf>
    exit(-1);
     34e:	557d                	li	a0,-1
     350:	00001097          	auipc	ra,0x1
     354:	94e080e7          	jalr	-1714(ra) # c9e <exit>
    printf("stat . failed\n");
     358:	00001517          	auipc	a0,0x1
     35c:	ff050513          	addi	a0,a0,-16 # 1348 <malloc+0x254>
     360:	00001097          	auipc	ra,0x1
     364:	cd6080e7          	jalr	-810(ra) # 1036 <printf>
    exit(-1);
     368:	557d                	li	a0,-1
     36a:	00001097          	auipc	ra,0x1
     36e:	934080e7          	jalr	-1740(ra) # c9e <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     372:	fc045603          	lhu	a2,-64(s0)
     376:	fc442583          	lw	a1,-60(s0)
     37a:	00001517          	auipc	a0,0x1
     37e:	eae50513          	addi	a0,a0,-338 # 1228 <malloc+0x134>
     382:	00001097          	auipc	ra,0x1
     386:	cb4080e7          	jalr	-844(ra) # 1036 <printf>
    exit(-1);
     38a:	557d                	li	a0,-1
     38c:	00001097          	auipc	ra,0x1
     390:	912080e7          	jalr	-1774(ra) # c9e <exit>
    printf("chdir .. failed\n");
     394:	00001517          	auipc	a0,0x1
     398:	fcc50513          	addi	a0,a0,-52 # 1360 <malloc+0x26c>
     39c:	00001097          	auipc	ra,0x1
     3a0:	c9a080e7          	jalr	-870(ra) # 1036 <printf>
    exit(-1);
     3a4:	557d                	li	a0,-1
     3a6:	00001097          	auipc	ra,0x1
     3aa:	8f8080e7          	jalr	-1800(ra) # c9e <exit>
    printf("stat . failed\n");
     3ae:	00001517          	auipc	a0,0x1
     3b2:	f9a50513          	addi	a0,a0,-102 # 1348 <malloc+0x254>
     3b6:	00001097          	auipc	ra,0x1
     3ba:	c80080e7          	jalr	-896(ra) # 1036 <printf>
    exit(-1);
     3be:	557d                	li	a0,-1
     3c0:	00001097          	auipc	ra,0x1
     3c4:	8de080e7          	jalr	-1826(ra) # c9e <exit>
    printf("stat wrong inum/minor %d %d\n", st.ino, minor(st.dev));
     3c8:	fc045603          	lhu	a2,-64(s0)
     3cc:	fc442583          	lw	a1,-60(s0)
     3d0:	00001517          	auipc	a0,0x1
     3d4:	e5850513          	addi	a0,a0,-424 # 1228 <malloc+0x134>
     3d8:	00001097          	auipc	ra,0x1
     3dc:	c5e080e7          	jalr	-930(ra) # 1036 <printf>
    exit(-1);
     3e0:	557d                	li	a0,-1
     3e2:	00001097          	auipc	ra,0x1
     3e6:	8bc080e7          	jalr	-1860(ra) # c9e <exit>

00000000000003ea <test1>:

// depends on test0
void test1() {
     3ea:	715d                	addi	sp,sp,-80
     3ec:	e486                	sd	ra,72(sp)
     3ee:	e0a2                	sd	s0,64(sp)
     3f0:	fc26                	sd	s1,56(sp)
     3f2:	f84a                	sd	s2,48(sp)
     3f4:	f44e                	sd	s3,40(sp)
     3f6:	0880                	addi	s0,sp,80
  struct stat st;
  int fd;
  int i;
  
  printf("test1 start\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	f9050513          	addi	a0,a0,-112 # 1388 <malloc+0x294>
     400:	00001097          	auipc	ra,0x1
     404:	c36080e7          	jalr	-970(ra) # 1036 <printf>

  if (mount("/disk1", "/m") == 0) {
     408:	00001597          	auipc	a1,0x1
     40c:	df058593          	addi	a1,a1,-528 # 11f8 <malloc+0x104>
     410:	00001517          	auipc	a0,0x1
     414:	df050513          	addi	a0,a0,-528 # 1200 <malloc+0x10c>
     418:	00001097          	auipc	ra,0x1
     41c:	936080e7          	jalr	-1738(ra) # d4e <mount>
     420:	10050d63          	beqz	a0,53a <test1+0x150>
    printf("mount should fail\n");
    exit(-1);
  }    

  if (umount("/m") < 0) {
     424:	00001517          	auipc	a0,0x1
     428:	dd450513          	addi	a0,a0,-556 # 11f8 <malloc+0x104>
     42c:	00001097          	auipc	ra,0x1
     430:	92a080e7          	jalr	-1750(ra) # d56 <umount>
     434:	12054063          	bltz	a0,554 <test1+0x16a>
    printf("umount /m failed\n");
    exit(-1);
  }    

  if (umount("/m") == 0) {
     438:	00001517          	auipc	a0,0x1
     43c:	dc050513          	addi	a0,a0,-576 # 11f8 <malloc+0x104>
     440:	00001097          	auipc	ra,0x1
     444:	916080e7          	jalr	-1770(ra) # d56 <umount>
     448:	12050363          	beqz	a0,56e <test1+0x184>
    printf("umount /m succeeded\n");
    exit(-1);
  }    

  if (umount("/") == 0) {
     44c:	00001517          	auipc	a0,0x1
     450:	f9450513          	addi	a0,a0,-108 # 13e0 <malloc+0x2ec>
     454:	00001097          	auipc	ra,0x1
     458:	902080e7          	jalr	-1790(ra) # d56 <umount>
     45c:	12050663          	beqz	a0,588 <test1+0x19e>
    printf("umount / succeeded\n");
    exit(-1);
  }    

  if (stat("/m", &st) < 0) {
     460:	fb840593          	addi	a1,s0,-72
     464:	00001517          	auipc	a0,0x1
     468:	d9450513          	addi	a0,a0,-620 # 11f8 <malloc+0x104>
     46c:	00000097          	auipc	ra,0x0
     470:	770080e7          	jalr	1904(ra) # bdc <stat>
     474:	12054763          	bltz	a0,5a2 <test1+0x1b8>
    printf("stat /m failed\n");
    exit(-1);
  }

  if (minor(st.dev) != 0) {
     478:	fb845603          	lhu	a2,-72(s0)
     47c:	06400493          	li	s1,100
    exit(-1);
  }

  // many mounts and umounts
  for (i = 0; i < 100; i++) {
    if (mount("/disk1", "/m") < 0) {
     480:	00001917          	auipc	s2,0x1
     484:	d7890913          	addi	s2,s2,-648 # 11f8 <malloc+0x104>
     488:	00001997          	auipc	s3,0x1
     48c:	d7898993          	addi	s3,s3,-648 # 1200 <malloc+0x10c>
  if (minor(st.dev) != 0) {
     490:	12061663          	bnez	a2,5bc <test1+0x1d2>
    if (mount("/disk1", "/m") < 0) {
     494:	85ca                	mv	a1,s2
     496:	854e                	mv	a0,s3
     498:	00001097          	auipc	ra,0x1
     49c:	8b6080e7          	jalr	-1866(ra) # d4e <mount>
     4a0:	12054d63          	bltz	a0,5da <test1+0x1f0>
      printf("mount /m should succeed\n");
      exit(-1);
    }    

    if (umount("/m") < 0) {
     4a4:	854a                	mv	a0,s2
     4a6:	00001097          	auipc	ra,0x1
     4aa:	8b0080e7          	jalr	-1872(ra) # d56 <umount>
     4ae:	14054363          	bltz	a0,5f4 <test1+0x20a>
  for (i = 0; i < 100; i++) {
     4b2:	34fd                	addiw	s1,s1,-1
     4b4:	f0e5                	bnez	s1,494 <test1+0xaa>
      printf("umount /m failed\n");
      exit(-1);
    }
  }

  if (mount("/disk1", "/m") < 0) {
     4b6:	00001597          	auipc	a1,0x1
     4ba:	d4258593          	addi	a1,a1,-702 # 11f8 <malloc+0x104>
     4be:	00001517          	auipc	a0,0x1
     4c2:	d4250513          	addi	a0,a0,-702 # 1200 <malloc+0x10c>
     4c6:	00001097          	auipc	ra,0x1
     4ca:	888080e7          	jalr	-1912(ra) # d4e <mount>
     4ce:	14054063          	bltz	a0,60e <test1+0x224>
    printf("mount /m should succeed\n");
    exit(-1);
  }    

  if ((fd = open("/m/README", O_RDONLY)) < 0) {
     4d2:	4581                	li	a1,0
     4d4:	00001517          	auipc	a0,0x1
     4d8:	d7450513          	addi	a0,a0,-652 # 1248 <malloc+0x154>
     4dc:	00001097          	auipc	ra,0x1
     4e0:	802080e7          	jalr	-2046(ra) # cde <open>
     4e4:	84aa                	mv	s1,a0
     4e6:	14054163          	bltz	a0,628 <test1+0x23e>
    printf("open read failed\n");
    exit(-1);
  }

  if (umount("/m") == 0) {
     4ea:	00001517          	auipc	a0,0x1
     4ee:	d0e50513          	addi	a0,a0,-754 # 11f8 <malloc+0x104>
     4f2:	00001097          	auipc	ra,0x1
     4f6:	864080e7          	jalr	-1948(ra) # d56 <umount>
     4fa:	14050463          	beqz	a0,642 <test1+0x258>
    printf("umount /m succeeded\n");
    exit(-1);
  }

  close(fd);
     4fe:	8526                	mv	a0,s1
     500:	00000097          	auipc	ra,0x0
     504:	7c6080e7          	jalr	1990(ra) # cc6 <close>
  
  if (umount("/m") < 0) {
     508:	00001517          	auipc	a0,0x1
     50c:	cf050513          	addi	a0,a0,-784 # 11f8 <malloc+0x104>
     510:	00001097          	auipc	ra,0x1
     514:	846080e7          	jalr	-1978(ra) # d56 <umount>
     518:	14054263          	bltz	a0,65c <test1+0x272>
    printf("final umount failed\n");
    exit(-1);
  }

  printf("test1 done\n");
     51c:	00001517          	auipc	a0,0x1
     520:	f3c50513          	addi	a0,a0,-196 # 1458 <malloc+0x364>
     524:	00001097          	auipc	ra,0x1
     528:	b12080e7          	jalr	-1262(ra) # 1036 <printf>
}
     52c:	60a6                	ld	ra,72(sp)
     52e:	6406                	ld	s0,64(sp)
     530:	74e2                	ld	s1,56(sp)
     532:	7942                	ld	s2,48(sp)
     534:	79a2                	ld	s3,40(sp)
     536:	6161                	addi	sp,sp,80
     538:	8082                	ret
    printf("mount should fail\n");
     53a:	00001517          	auipc	a0,0x1
     53e:	e5e50513          	addi	a0,a0,-418 # 1398 <malloc+0x2a4>
     542:	00001097          	auipc	ra,0x1
     546:	af4080e7          	jalr	-1292(ra) # 1036 <printf>
    exit(-1);
     54a:	557d                	li	a0,-1
     54c:	00000097          	auipc	ra,0x0
     550:	752080e7          	jalr	1874(ra) # c9e <exit>
    printf("umount /m failed\n");
     554:	00001517          	auipc	a0,0x1
     558:	e5c50513          	addi	a0,a0,-420 # 13b0 <malloc+0x2bc>
     55c:	00001097          	auipc	ra,0x1
     560:	ada080e7          	jalr	-1318(ra) # 1036 <printf>
    exit(-1);
     564:	557d                	li	a0,-1
     566:	00000097          	auipc	ra,0x0
     56a:	738080e7          	jalr	1848(ra) # c9e <exit>
    printf("umount /m succeeded\n");
     56e:	00001517          	auipc	a0,0x1
     572:	e5a50513          	addi	a0,a0,-422 # 13c8 <malloc+0x2d4>
     576:	00001097          	auipc	ra,0x1
     57a:	ac0080e7          	jalr	-1344(ra) # 1036 <printf>
    exit(-1);
     57e:	557d                	li	a0,-1
     580:	00000097          	auipc	ra,0x0
     584:	71e080e7          	jalr	1822(ra) # c9e <exit>
    printf("umount / succeeded\n");
     588:	00001517          	auipc	a0,0x1
     58c:	e6050513          	addi	a0,a0,-416 # 13e8 <malloc+0x2f4>
     590:	00001097          	auipc	ra,0x1
     594:	aa6080e7          	jalr	-1370(ra) # 1036 <printf>
    exit(-1);
     598:	557d                	li	a0,-1
     59a:	00000097          	auipc	ra,0x0
     59e:	704080e7          	jalr	1796(ra) # c9e <exit>
    printf("stat /m failed\n");
     5a2:	00001517          	auipc	a0,0x1
     5a6:	c7650513          	addi	a0,a0,-906 # 1218 <malloc+0x124>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	a8c080e7          	jalr	-1396(ra) # 1036 <printf>
    exit(-1);
     5b2:	557d                	li	a0,-1
     5b4:	00000097          	auipc	ra,0x0
     5b8:	6ea080e7          	jalr	1770(ra) # c9e <exit>
    printf("stat wrong inum/dev %d %d\n", st.ino, minor(st.dev));
     5bc:	fbc42583          	lw	a1,-68(s0)
     5c0:	00001517          	auipc	a0,0x1
     5c4:	e4050513          	addi	a0,a0,-448 # 1400 <malloc+0x30c>
     5c8:	00001097          	auipc	ra,0x1
     5cc:	a6e080e7          	jalr	-1426(ra) # 1036 <printf>
    exit(-1);
     5d0:	557d                	li	a0,-1
     5d2:	00000097          	auipc	ra,0x0
     5d6:	6cc080e7          	jalr	1740(ra) # c9e <exit>
      printf("mount /m should succeed\n");
     5da:	00001517          	auipc	a0,0x1
     5de:	e4650513          	addi	a0,a0,-442 # 1420 <malloc+0x32c>
     5e2:	00001097          	auipc	ra,0x1
     5e6:	a54080e7          	jalr	-1452(ra) # 1036 <printf>
      exit(-1);
     5ea:	557d                	li	a0,-1
     5ec:	00000097          	auipc	ra,0x0
     5f0:	6b2080e7          	jalr	1714(ra) # c9e <exit>
      printf("umount /m failed\n");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	dbc50513          	addi	a0,a0,-580 # 13b0 <malloc+0x2bc>
     5fc:	00001097          	auipc	ra,0x1
     600:	a3a080e7          	jalr	-1478(ra) # 1036 <printf>
      exit(-1);
     604:	557d                	li	a0,-1
     606:	00000097          	auipc	ra,0x0
     60a:	698080e7          	jalr	1688(ra) # c9e <exit>
    printf("mount /m should succeed\n");
     60e:	00001517          	auipc	a0,0x1
     612:	e1250513          	addi	a0,a0,-494 # 1420 <malloc+0x32c>
     616:	00001097          	auipc	ra,0x1
     61a:	a20080e7          	jalr	-1504(ra) # 1036 <printf>
    exit(-1);
     61e:	557d                	li	a0,-1
     620:	00000097          	auipc	ra,0x0
     624:	67e080e7          	jalr	1662(ra) # c9e <exit>
    printf("open read failed\n");
     628:	00001517          	auipc	a0,0x1
     62c:	c3050513          	addi	a0,a0,-976 # 1258 <malloc+0x164>
     630:	00001097          	auipc	ra,0x1
     634:	a06080e7          	jalr	-1530(ra) # 1036 <printf>
    exit(-1);
     638:	557d                	li	a0,-1
     63a:	00000097          	auipc	ra,0x0
     63e:	664080e7          	jalr	1636(ra) # c9e <exit>
    printf("umount /m succeeded\n");
     642:	00001517          	auipc	a0,0x1
     646:	d8650513          	addi	a0,a0,-634 # 13c8 <malloc+0x2d4>
     64a:	00001097          	auipc	ra,0x1
     64e:	9ec080e7          	jalr	-1556(ra) # 1036 <printf>
    exit(-1);
     652:	557d                	li	a0,-1
     654:	00000097          	auipc	ra,0x0
     658:	64a080e7          	jalr	1610(ra) # c9e <exit>
    printf("final umount failed\n");
     65c:	00001517          	auipc	a0,0x1
     660:	de450513          	addi	a0,a0,-540 # 1440 <malloc+0x34c>
     664:	00001097          	auipc	ra,0x1
     668:	9d2080e7          	jalr	-1582(ra) # 1036 <printf>
    exit(-1);
     66c:	557d                	li	a0,-1
     66e:	00000097          	auipc	ra,0x0
     672:	630080e7          	jalr	1584(ra) # c9e <exit>

0000000000000676 <test2>:
#define NOP 100

// try to trigger races/deadlocks in namex; it is helpful to add
// sleepticks(1) in if(ip->type != T_DIR) branch in namei, so that you
// will observe some more reliably.
void test2() {
     676:	711d                	addi	sp,sp,-96
     678:	ec86                	sd	ra,88(sp)
     67a:	e8a2                	sd	s0,80(sp)
     67c:	e4a6                	sd	s1,72(sp)
     67e:	e0ca                	sd	s2,64(sp)
     680:	fc4e                	sd	s3,56(sp)
     682:	f852                	sd	s4,48(sp)
     684:	f456                	sd	s5,40(sp)
     686:	1080                	addi	s0,sp,96
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test2\n");
     688:	00001517          	auipc	a0,0x1
     68c:	de050513          	addi	a0,a0,-544 # 1468 <malloc+0x374>
     690:	00001097          	auipc	ra,0x1
     694:	9a6080e7          	jalr	-1626(ra) # 1036 <printf>

  mkdir("/m");
     698:	00001517          	auipc	a0,0x1
     69c:	b6050513          	addi	a0,a0,-1184 # 11f8 <malloc+0x104>
     6a0:	00000097          	auipc	ra,0x0
     6a4:	666080e7          	jalr	1638(ra) # d06 <mkdir>
  
  if (mount("/disk1", "/m") < 0) {
     6a8:	00001597          	auipc	a1,0x1
     6ac:	b5058593          	addi	a1,a1,-1200 # 11f8 <malloc+0x104>
     6b0:	00001517          	auipc	a0,0x1
     6b4:	b5050513          	addi	a0,a0,-1200 # 1200 <malloc+0x10c>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	696080e7          	jalr	1686(ra) # d4e <mount>
     6c0:	0c054563          	bltz	a0,78a <test2+0x114>
     6c4:	fb040a13          	addi	s4,s0,-80
     6c8:	fc040a93          	addi	s5,s0,-64
     6cc:	84d2                	mv	s1,s4
      printf("mount failed\n");
      exit(-1);
  }    

  for (i = 0; i < NPID; i++) {
    if ((pid[i] = fork()) < 0) {
     6ce:	00000097          	auipc	ra,0x0
     6d2:	5c8080e7          	jalr	1480(ra) # c96 <fork>
     6d6:	c088                	sw	a0,0(s1)
     6d8:	0c054663          	bltz	a0,7a4 <test2+0x12e>
      printf("fork failed\n");
      exit(-1);
    }
    if (pid[i] == 0) {
     6dc:	c16d                	beqz	a0,7be <test2+0x148>
  for (i = 0; i < NPID; i++) {
     6de:	0491                	addi	s1,s1,4
     6e0:	ff5497e3          	bne	s1,s5,6ce <test2+0x58>
     6e4:	06400913          	li	s2,100
        }
      }
    }
  }
  for (i = 0; i < NOP; i++) {
    if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     6e8:	00001997          	auipc	s3,0x1
     6ec:	da098993          	addi	s3,s3,-608 # 1488 <malloc+0x394>
     6f0:	20100593          	li	a1,513
     6f4:	854e                	mv	a0,s3
     6f6:	00000097          	auipc	ra,0x0
     6fa:	5e8080e7          	jalr	1512(ra) # cde <open>
     6fe:	84aa                	mv	s1,a0
     700:	0e054063          	bltz	a0,7e0 <test2+0x16a>
      printf("open write failed");
      exit(-1);
    }
    if (unlink("/m/b") < 0) {
     704:	854e                	mv	a0,s3
     706:	00000097          	auipc	ra,0x0
     70a:	5e8080e7          	jalr	1512(ra) # cee <unlink>
     70e:	0e054663          	bltz	a0,7fa <test2+0x184>
      printf("unlink failed\n");
      exit(-1);
    }
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     712:	4605                	li	a2,1
     714:	fa840593          	addi	a1,s0,-88
     718:	8526                	mv	a0,s1
     71a:	00000097          	auipc	ra,0x0
     71e:	5a4080e7          	jalr	1444(ra) # cbe <write>
     722:	4785                	li	a5,1
     724:	0ef51863          	bne	a0,a5,814 <test2+0x19e>
      printf("write failed\n");
      exit(-1);
    }
    close(fd);
     728:	8526                	mv	a0,s1
     72a:	00000097          	auipc	ra,0x0
     72e:	59c080e7          	jalr	1436(ra) # cc6 <close>
  for (i = 0; i < NOP; i++) {
     732:	397d                	addiw	s2,s2,-1
     734:	fa091ee3          	bnez	s2,6f0 <test2+0x7a>
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     738:	000a2503          	lw	a0,0(s4)
     73c:	00000097          	auipc	ra,0x0
     740:	592080e7          	jalr	1426(ra) # cce <kill>
    wait(0);
     744:	4501                	li	a0,0
     746:	00000097          	auipc	ra,0x0
     74a:	560080e7          	jalr	1376(ra) # ca6 <wait>
  for (i = 0; i < NPID; i++) {
     74e:	0a11                	addi	s4,s4,4
     750:	ff5a14e3          	bne	s4,s5,738 <test2+0xc2>
  }
  if (umount("/m") < 0) {
     754:	00001517          	auipc	a0,0x1
     758:	aa450513          	addi	a0,a0,-1372 # 11f8 <malloc+0x104>
     75c:	00000097          	auipc	ra,0x0
     760:	5fa080e7          	jalr	1530(ra) # d56 <umount>
     764:	0c054563          	bltz	a0,82e <test2+0x1b8>
    printf("umount failed\n");
    exit(-1);
  }    

  printf("test2 ok\n");
     768:	00001517          	auipc	a0,0x1
     76c:	d6050513          	addi	a0,a0,-672 # 14c8 <malloc+0x3d4>
     770:	00001097          	auipc	ra,0x1
     774:	8c6080e7          	jalr	-1850(ra) # 1036 <printf>
}
     778:	60e6                	ld	ra,88(sp)
     77a:	6446                	ld	s0,80(sp)
     77c:	64a6                	ld	s1,72(sp)
     77e:	6906                	ld	s2,64(sp)
     780:	79e2                	ld	s3,56(sp)
     782:	7a42                	ld	s4,48(sp)
     784:	7aa2                	ld	s5,40(sp)
     786:	6125                	addi	sp,sp,96
     788:	8082                	ret
      printf("mount failed\n");
     78a:	00001517          	auipc	a0,0x1
     78e:	a7e50513          	addi	a0,a0,-1410 # 1208 <malloc+0x114>
     792:	00001097          	auipc	ra,0x1
     796:	8a4080e7          	jalr	-1884(ra) # 1036 <printf>
      exit(-1);
     79a:	557d                	li	a0,-1
     79c:	00000097          	auipc	ra,0x0
     7a0:	502080e7          	jalr	1282(ra) # c9e <exit>
      printf("fork failed\n");
     7a4:	00001517          	auipc	a0,0x1
     7a8:	ccc50513          	addi	a0,a0,-820 # 1470 <malloc+0x37c>
     7ac:	00001097          	auipc	ra,0x1
     7b0:	88a080e7          	jalr	-1910(ra) # 1036 <printf>
      exit(-1);
     7b4:	557d                	li	a0,-1
     7b6:	00000097          	auipc	ra,0x0
     7ba:	4e8080e7          	jalr	1256(ra) # c9e <exit>
        if ((fd = open("/m/b/c", O_RDONLY)) >= 0) {
     7be:	00001497          	auipc	s1,0x1
     7c2:	cc248493          	addi	s1,s1,-830 # 1480 <malloc+0x38c>
     7c6:	4581                	li	a1,0
     7c8:	8526                	mv	a0,s1
     7ca:	00000097          	auipc	ra,0x0
     7ce:	514080e7          	jalr	1300(ra) # cde <open>
     7d2:	fe054ae3          	bltz	a0,7c6 <test2+0x150>
          close(fd);
     7d6:	00000097          	auipc	ra,0x0
     7da:	4f0080e7          	jalr	1264(ra) # cc6 <close>
     7de:	b7e5                	j	7c6 <test2+0x150>
      printf("open write failed");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	cb050513          	addi	a0,a0,-848 # 1490 <malloc+0x39c>
     7e8:	00001097          	auipc	ra,0x1
     7ec:	84e080e7          	jalr	-1970(ra) # 1036 <printf>
      exit(-1);
     7f0:	557d                	li	a0,-1
     7f2:	00000097          	auipc	ra,0x0
     7f6:	4ac080e7          	jalr	1196(ra) # c9e <exit>
      printf("unlink failed\n");
     7fa:	00001517          	auipc	a0,0x1
     7fe:	cae50513          	addi	a0,a0,-850 # 14a8 <malloc+0x3b4>
     802:	00001097          	auipc	ra,0x1
     806:	834080e7          	jalr	-1996(ra) # 1036 <printf>
      exit(-1);
     80a:	557d                	li	a0,-1
     80c:	00000097          	auipc	ra,0x0
     810:	492080e7          	jalr	1170(ra) # c9e <exit>
      printf("write failed\n");
     814:	00001517          	auipc	a0,0x1
     818:	a9450513          	addi	a0,a0,-1388 # 12a8 <malloc+0x1b4>
     81c:	00001097          	auipc	ra,0x1
     820:	81a080e7          	jalr	-2022(ra) # 1036 <printf>
      exit(-1);
     824:	557d                	li	a0,-1
     826:	00000097          	auipc	ra,0x0
     82a:	478080e7          	jalr	1144(ra) # c9e <exit>
    printf("umount failed\n");
     82e:	00001517          	auipc	a0,0x1
     832:	c8a50513          	addi	a0,a0,-886 # 14b8 <malloc+0x3c4>
     836:	00001097          	auipc	ra,0x1
     83a:	800080e7          	jalr	-2048(ra) # 1036 <printf>
    exit(-1);
     83e:	557d                	li	a0,-1
     840:	00000097          	auipc	ra,0x0
     844:	45e080e7          	jalr	1118(ra) # c9e <exit>

0000000000000848 <test3>:


// Mount/unmount concurrently with creating files on the mounted fs
void test3() {
     848:	7159                	addi	sp,sp,-112
     84a:	f486                	sd	ra,104(sp)
     84c:	f0a2                	sd	s0,96(sp)
     84e:	eca6                	sd	s1,88(sp)
     850:	e8ca                	sd	s2,80(sp)
     852:	e4ce                	sd	s3,72(sp)
     854:	e0d2                	sd	s4,64(sp)
     856:	fc56                	sd	s5,56(sp)
     858:	f85a                	sd	s6,48(sp)
     85a:	f45e                	sd	s7,40(sp)
     85c:	1880                	addi	s0,sp,112
  int pid[NPID];
  int fd;
  int i;
  char buf[1];

  printf("test3\n");
     85e:	00001517          	auipc	a0,0x1
     862:	c7a50513          	addi	a0,a0,-902 # 14d8 <malloc+0x3e4>
     866:	00000097          	auipc	ra,0x0
     86a:	7d0080e7          	jalr	2000(ra) # 1036 <printf>

  mkdir("/m");
     86e:	00001517          	auipc	a0,0x1
     872:	98a50513          	addi	a0,a0,-1654 # 11f8 <malloc+0x104>
     876:	00000097          	auipc	ra,0x0
     87a:	490080e7          	jalr	1168(ra) # d06 <mkdir>
  for (i = 0; i < NPID; i++) {
     87e:	fa040b13          	addi	s6,s0,-96
     882:	fb040b93          	addi	s7,s0,-80
  mkdir("/m");
     886:	84da                	mv	s1,s6
    if ((pid[i] = fork()) < 0) {
     888:	00000097          	auipc	ra,0x0
     88c:	40e080e7          	jalr	1038(ra) # c96 <fork>
     890:	c088                	sw	a0,0(s1)
     892:	02054663          	bltz	a0,8be <test3+0x76>
      printf("fork failed\n");
      exit(-1);
    }
    if (pid[i] == 0) {
     896:	c129                	beqz	a0,8d8 <test3+0x90>
  for (i = 0; i < NPID; i++) {
     898:	0491                	addi	s1,s1,4
     89a:	ff7497e3          	bne	s1,s7,888 <test3+0x40>
        close(fd);
        sleep(1);
      }
    }
  }
  for (i = 0; i < NOP; i++) {
     89e:	4481                	li	s1,0
    if (mount("/disk1", "/m") < 0) {
     8a0:	00001917          	auipc	s2,0x1
     8a4:	95890913          	addi	s2,s2,-1704 # 11f8 <malloc+0x104>
     8a8:	00001a97          	auipc	s5,0x1
     8ac:	958a8a93          	addi	s5,s5,-1704 # 1200 <malloc+0x10c>
      printf("mount failed\n");
      exit(-1);
    }    
    while (umount("/m") < 0) {
      printf("umount failed; try again %d\n", i);
     8b0:	00001997          	auipc	s3,0x1
     8b4:	c3098993          	addi	s3,s3,-976 # 14e0 <malloc+0x3ec>
  for (i = 0; i < NOP; i++) {
     8b8:	06400a13          	li	s4,100
     8bc:	a0c9                	j	97e <test3+0x136>
      printf("fork failed\n");
     8be:	00001517          	auipc	a0,0x1
     8c2:	bb250513          	addi	a0,a0,-1102 # 1470 <malloc+0x37c>
     8c6:	00000097          	auipc	ra,0x0
     8ca:	770080e7          	jalr	1904(ra) # 1036 <printf>
      exit(-1);
     8ce:	557d                	li	a0,-1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	3ce080e7          	jalr	974(ra) # c9e <exit>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     8d8:	00001917          	auipc	s2,0x1
     8dc:	bb090913          	addi	s2,s2,-1104 # 1488 <malloc+0x394>
     8e0:	20100593          	li	a1,513
     8e4:	854a                	mv	a0,s2
     8e6:	00000097          	auipc	ra,0x0
     8ea:	3f8080e7          	jalr	1016(ra) # cde <open>
     8ee:	84aa                	mv	s1,a0
     8f0:	02054d63          	bltz	a0,92a <test3+0xe2>
        unlink("/m/b");
     8f4:	854a                	mv	a0,s2
     8f6:	00000097          	auipc	ra,0x0
     8fa:	3f8080e7          	jalr	1016(ra) # cee <unlink>
        if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
     8fe:	4605                	li	a2,1
     900:	f9840593          	addi	a1,s0,-104
     904:	8526                	mv	a0,s1
     906:	00000097          	auipc	ra,0x0
     90a:	3b8080e7          	jalr	952(ra) # cbe <write>
     90e:	4785                	li	a5,1
     910:	02f51a63          	bne	a0,a5,944 <test3+0xfc>
        close(fd);
     914:	8526                	mv	a0,s1
     916:	00000097          	auipc	ra,0x0
     91a:	3b0080e7          	jalr	944(ra) # cc6 <close>
        sleep(1);
     91e:	4505                	li	a0,1
     920:	00000097          	auipc	ra,0x0
     924:	40e080e7          	jalr	1038(ra) # d2e <sleep>
        if ((fd = open("/m/b", O_CREATE|O_WRONLY)) < 0) {
     928:	bf65                	j	8e0 <test3+0x98>
          printf("open write failed");
     92a:	00001517          	auipc	a0,0x1
     92e:	b6650513          	addi	a0,a0,-1178 # 1490 <malloc+0x39c>
     932:	00000097          	auipc	ra,0x0
     936:	704080e7          	jalr	1796(ra) # 1036 <printf>
          exit(-1);
     93a:	557d                	li	a0,-1
     93c:	00000097          	auipc	ra,0x0
     940:	362080e7          	jalr	866(ra) # c9e <exit>
          printf("write failed\n");
     944:	00001517          	auipc	a0,0x1
     948:	96450513          	addi	a0,a0,-1692 # 12a8 <malloc+0x1b4>
     94c:	00000097          	auipc	ra,0x0
     950:	6ea080e7          	jalr	1770(ra) # 1036 <printf>
          exit(-1);
     954:	557d                	li	a0,-1
     956:	00000097          	auipc	ra,0x0
     95a:	348080e7          	jalr	840(ra) # c9e <exit>
      printf("umount failed; try again %d\n", i);
     95e:	85a6                	mv	a1,s1
     960:	854e                	mv	a0,s3
     962:	00000097          	auipc	ra,0x0
     966:	6d4080e7          	jalr	1748(ra) # 1036 <printf>
    while (umount("/m") < 0) {
     96a:	854a                	mv	a0,s2
     96c:	00000097          	auipc	ra,0x0
     970:	3ea080e7          	jalr	1002(ra) # d56 <umount>
     974:	fe0545e3          	bltz	a0,95e <test3+0x116>
  for (i = 0; i < NOP; i++) {
     978:	2485                	addiw	s1,s1,1
     97a:	03448763          	beq	s1,s4,9a8 <test3+0x160>
    if (mount("/disk1", "/m") < 0) {
     97e:	85ca                	mv	a1,s2
     980:	8556                	mv	a0,s5
     982:	00000097          	auipc	ra,0x0
     986:	3cc080e7          	jalr	972(ra) # d4e <mount>
     98a:	fe0550e3          	bgez	a0,96a <test3+0x122>
      printf("mount failed\n");
     98e:	00001517          	auipc	a0,0x1
     992:	87a50513          	addi	a0,a0,-1926 # 1208 <malloc+0x114>
     996:	00000097          	auipc	ra,0x0
     99a:	6a0080e7          	jalr	1696(ra) # 1036 <printf>
      exit(-1);
     99e:	557d                	li	a0,-1
     9a0:	00000097          	auipc	ra,0x0
     9a4:	2fe080e7          	jalr	766(ra) # c9e <exit>
    }    
  }
  for (i = 0; i < NPID; i++) {
    kill(pid[i]);
     9a8:	000b2503          	lw	a0,0(s6)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	322080e7          	jalr	802(ra) # cce <kill>
    wait(0);
     9b4:	4501                	li	a0,0
     9b6:	00000097          	auipc	ra,0x0
     9ba:	2f0080e7          	jalr	752(ra) # ca6 <wait>
  for (i = 0; i < NPID; i++) {
     9be:	0b11                	addi	s6,s6,4
     9c0:	ff7b14e3          	bne	s6,s7,9a8 <test3+0x160>
  }
  printf("test3 ok\n");
     9c4:	00001517          	auipc	a0,0x1
     9c8:	b3c50513          	addi	a0,a0,-1220 # 1500 <malloc+0x40c>
     9cc:	00000097          	auipc	ra,0x0
     9d0:	66a080e7          	jalr	1642(ra) # 1036 <printf>
}
     9d4:	70a6                	ld	ra,104(sp)
     9d6:	7406                	ld	s0,96(sp)
     9d8:	64e6                	ld	s1,88(sp)
     9da:	6946                	ld	s2,80(sp)
     9dc:	69a6                	ld	s3,72(sp)
     9de:	6a06                	ld	s4,64(sp)
     9e0:	7ae2                	ld	s5,56(sp)
     9e2:	7b42                	ld	s6,48(sp)
     9e4:	7ba2                	ld	s7,40(sp)
     9e6:	6165                	addi	sp,sp,112
     9e8:	8082                	ret

00000000000009ea <test4>:

void
test4()
{
     9ea:	1141                	addi	sp,sp,-16
     9ec:	e406                	sd	ra,8(sp)
     9ee:	e022                	sd	s0,0(sp)
     9f0:	0800                	addi	s0,sp,16
  printf("test4\n");
     9f2:	00001517          	auipc	a0,0x1
     9f6:	b1e50513          	addi	a0,a0,-1250 # 1510 <malloc+0x41c>
     9fa:	00000097          	auipc	ra,0x0
     9fe:	63c080e7          	jalr	1596(ra) # 1036 <printf>

  mknod("disk1", DISK, 1);
     a02:	4605                	li	a2,1
     a04:	4581                	li	a1,0
     a06:	00000517          	auipc	a0,0x0
     a0a:	7ea50513          	addi	a0,a0,2026 # 11f0 <malloc+0xfc>
     a0e:	00000097          	auipc	ra,0x0
     a12:	2d8080e7          	jalr	728(ra) # ce6 <mknod>
  mkdir("/m");
     a16:	00000517          	auipc	a0,0x0
     a1a:	7e250513          	addi	a0,a0,2018 # 11f8 <malloc+0x104>
     a1e:	00000097          	auipc	ra,0x0
     a22:	2e8080e7          	jalr	744(ra) # d06 <mkdir>
  if (mount("/disk1", "/m") < 0) {
     a26:	00000597          	auipc	a1,0x0
     a2a:	7d258593          	addi	a1,a1,2002 # 11f8 <malloc+0x104>
     a2e:	00000517          	auipc	a0,0x0
     a32:	7d250513          	addi	a0,a0,2002 # 1200 <malloc+0x10c>
     a36:	00000097          	auipc	ra,0x0
     a3a:	318080e7          	jalr	792(ra) # d4e <mount>
     a3e:	00054f63          	bltz	a0,a5c <test4+0x72>
      printf("mount failed\n");
      exit(-1);
  }
  crash("/m/crashf", 1);
     a42:	4585                	li	a1,1
     a44:	00001517          	auipc	a0,0x1
     a48:	ad450513          	addi	a0,a0,-1324 # 1518 <malloc+0x424>
     a4c:	00000097          	auipc	ra,0x0
     a50:	2fa080e7          	jalr	762(ra) # d46 <crash>
}
     a54:	60a2                	ld	ra,8(sp)
     a56:	6402                	ld	s0,0(sp)
     a58:	0141                	addi	sp,sp,16
     a5a:	8082                	ret
      printf("mount failed\n");
     a5c:	00000517          	auipc	a0,0x0
     a60:	7ac50513          	addi	a0,a0,1964 # 1208 <malloc+0x114>
     a64:	00000097          	auipc	ra,0x0
     a68:	5d2080e7          	jalr	1490(ra) # 1036 <printf>
      exit(-1);
     a6c:	557d                	li	a0,-1
     a6e:	00000097          	auipc	ra,0x0
     a72:	230080e7          	jalr	560(ra) # c9e <exit>

0000000000000a76 <main>:
{
     a76:	1141                	addi	sp,sp,-16
     a78:	e406                	sd	ra,8(sp)
     a7a:	e022                	sd	s0,0(sp)
     a7c:	0800                	addi	s0,sp,16
  test0();
     a7e:	fffff097          	auipc	ra,0xfffff
     a82:	582080e7          	jalr	1410(ra) # 0 <test0>
  test1();
     a86:	00000097          	auipc	ra,0x0
     a8a:	964080e7          	jalr	-1692(ra) # 3ea <test1>
  test2();
     a8e:	00000097          	auipc	ra,0x0
     a92:	be8080e7          	jalr	-1048(ra) # 676 <test2>
  test3();
     a96:	00000097          	auipc	ra,0x0
     a9a:	db2080e7          	jalr	-590(ra) # 848 <test3>
  test4();
     a9e:	00000097          	auipc	ra,0x0
     aa2:	f4c080e7          	jalr	-180(ra) # 9ea <test4>
  exit(0);
     aa6:	4501                	li	a0,0
     aa8:	00000097          	auipc	ra,0x0
     aac:	1f6080e7          	jalr	502(ra) # c9e <exit>

0000000000000ab0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     ab0:	1141                	addi	sp,sp,-16
     ab2:	e422                	sd	s0,8(sp)
     ab4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ab6:	87aa                	mv	a5,a0
     ab8:	0585                	addi	a1,a1,1
     aba:	0785                	addi	a5,a5,1
     abc:	fff5c703          	lbu	a4,-1(a1)
     ac0:	fee78fa3          	sb	a4,-1(a5) # fffffffff0000fff <__global_pointer$+0xffffffffeffff2be>
     ac4:	fb75                	bnez	a4,ab8 <strcpy+0x8>
    ;
  return os;
}
     ac6:	6422                	ld	s0,8(sp)
     ac8:	0141                	addi	sp,sp,16
     aca:	8082                	ret

0000000000000acc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     acc:	1141                	addi	sp,sp,-16
     ace:	e422                	sd	s0,8(sp)
     ad0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     ad2:	00054783          	lbu	a5,0(a0)
     ad6:	cb91                	beqz	a5,aea <strcmp+0x1e>
     ad8:	0005c703          	lbu	a4,0(a1)
     adc:	00f71763          	bne	a4,a5,aea <strcmp+0x1e>
    p++, q++;
     ae0:	0505                	addi	a0,a0,1
     ae2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     ae4:	00054783          	lbu	a5,0(a0)
     ae8:	fbe5                	bnez	a5,ad8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     aea:	0005c503          	lbu	a0,0(a1)
}
     aee:	40a7853b          	subw	a0,a5,a0
     af2:	6422                	ld	s0,8(sp)
     af4:	0141                	addi	sp,sp,16
     af6:	8082                	ret

0000000000000af8 <strlen>:

uint
strlen(const char *s)
{
     af8:	1141                	addi	sp,sp,-16
     afa:	e422                	sd	s0,8(sp)
     afc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     afe:	00054783          	lbu	a5,0(a0)
     b02:	cf91                	beqz	a5,b1e <strlen+0x26>
     b04:	0505                	addi	a0,a0,1
     b06:	87aa                	mv	a5,a0
     b08:	4685                	li	a3,1
     b0a:	9e89                	subw	a3,a3,a0
     b0c:	00f6853b          	addw	a0,a3,a5
     b10:	0785                	addi	a5,a5,1
     b12:	fff7c703          	lbu	a4,-1(a5)
     b16:	fb7d                	bnez	a4,b0c <strlen+0x14>
    ;
  return n;
}
     b18:	6422                	ld	s0,8(sp)
     b1a:	0141                	addi	sp,sp,16
     b1c:	8082                	ret
  for(n = 0; s[n]; n++)
     b1e:	4501                	li	a0,0
     b20:	bfe5                	j	b18 <strlen+0x20>

0000000000000b22 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b22:	1141                	addi	sp,sp,-16
     b24:	e422                	sd	s0,8(sp)
     b26:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b28:	ca19                	beqz	a2,b3e <memset+0x1c>
     b2a:	87aa                	mv	a5,a0
     b2c:	1602                	slli	a2,a2,0x20
     b2e:	9201                	srli	a2,a2,0x20
     b30:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     b34:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     b38:	0785                	addi	a5,a5,1
     b3a:	fee79de3          	bne	a5,a4,b34 <memset+0x12>
  }
  return dst;
}
     b3e:	6422                	ld	s0,8(sp)
     b40:	0141                	addi	sp,sp,16
     b42:	8082                	ret

0000000000000b44 <strchr>:

char*
strchr(const char *s, char c)
{
     b44:	1141                	addi	sp,sp,-16
     b46:	e422                	sd	s0,8(sp)
     b48:	0800                	addi	s0,sp,16
  for(; *s; s++)
     b4a:	00054783          	lbu	a5,0(a0)
     b4e:	cb99                	beqz	a5,b64 <strchr+0x20>
    if(*s == c)
     b50:	00f58763          	beq	a1,a5,b5e <strchr+0x1a>
  for(; *s; s++)
     b54:	0505                	addi	a0,a0,1
     b56:	00054783          	lbu	a5,0(a0)
     b5a:	fbfd                	bnez	a5,b50 <strchr+0xc>
      return (char*)s;
  return 0;
     b5c:	4501                	li	a0,0
}
     b5e:	6422                	ld	s0,8(sp)
     b60:	0141                	addi	sp,sp,16
     b62:	8082                	ret
  return 0;
     b64:	4501                	li	a0,0
     b66:	bfe5                	j	b5e <strchr+0x1a>

0000000000000b68 <gets>:

char*
gets(char *buf, int max)
{
     b68:	711d                	addi	sp,sp,-96
     b6a:	ec86                	sd	ra,88(sp)
     b6c:	e8a2                	sd	s0,80(sp)
     b6e:	e4a6                	sd	s1,72(sp)
     b70:	e0ca                	sd	s2,64(sp)
     b72:	fc4e                	sd	s3,56(sp)
     b74:	f852                	sd	s4,48(sp)
     b76:	f456                	sd	s5,40(sp)
     b78:	f05a                	sd	s6,32(sp)
     b7a:	ec5e                	sd	s7,24(sp)
     b7c:	1080                	addi	s0,sp,96
     b7e:	8baa                	mv	s7,a0
     b80:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b82:	892a                	mv	s2,a0
     b84:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     b86:	4aa9                	li	s5,10
     b88:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     b8a:	89a6                	mv	s3,s1
     b8c:	2485                	addiw	s1,s1,1
     b8e:	0344d863          	bge	s1,s4,bbe <gets+0x56>
    cc = read(0, &c, 1);
     b92:	4605                	li	a2,1
     b94:	faf40593          	addi	a1,s0,-81
     b98:	4501                	li	a0,0
     b9a:	00000097          	auipc	ra,0x0
     b9e:	11c080e7          	jalr	284(ra) # cb6 <read>
    if(cc < 1)
     ba2:	00a05e63          	blez	a0,bbe <gets+0x56>
    buf[i++] = c;
     ba6:	faf44783          	lbu	a5,-81(s0)
     baa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     bae:	01578763          	beq	a5,s5,bbc <gets+0x54>
     bb2:	0905                	addi	s2,s2,1
     bb4:	fd679be3          	bne	a5,s6,b8a <gets+0x22>
  for(i=0; i+1 < max; ){
     bb8:	89a6                	mv	s3,s1
     bba:	a011                	j	bbe <gets+0x56>
     bbc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     bbe:	99de                	add	s3,s3,s7
     bc0:	00098023          	sb	zero,0(s3)
  return buf;
}
     bc4:	855e                	mv	a0,s7
     bc6:	60e6                	ld	ra,88(sp)
     bc8:	6446                	ld	s0,80(sp)
     bca:	64a6                	ld	s1,72(sp)
     bcc:	6906                	ld	s2,64(sp)
     bce:	79e2                	ld	s3,56(sp)
     bd0:	7a42                	ld	s4,48(sp)
     bd2:	7aa2                	ld	s5,40(sp)
     bd4:	7b02                	ld	s6,32(sp)
     bd6:	6be2                	ld	s7,24(sp)
     bd8:	6125                	addi	sp,sp,96
     bda:	8082                	ret

0000000000000bdc <stat>:

int
stat(const char *n, struct stat *st)
{
     bdc:	1101                	addi	sp,sp,-32
     bde:	ec06                	sd	ra,24(sp)
     be0:	e822                	sd	s0,16(sp)
     be2:	e426                	sd	s1,8(sp)
     be4:	e04a                	sd	s2,0(sp)
     be6:	1000                	addi	s0,sp,32
     be8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     bea:	4581                	li	a1,0
     bec:	00000097          	auipc	ra,0x0
     bf0:	0f2080e7          	jalr	242(ra) # cde <open>
  if(fd < 0)
     bf4:	02054563          	bltz	a0,c1e <stat+0x42>
     bf8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     bfa:	85ca                	mv	a1,s2
     bfc:	00000097          	auipc	ra,0x0
     c00:	0fa080e7          	jalr	250(ra) # cf6 <fstat>
     c04:	892a                	mv	s2,a0
  close(fd);
     c06:	8526                	mv	a0,s1
     c08:	00000097          	auipc	ra,0x0
     c0c:	0be080e7          	jalr	190(ra) # cc6 <close>
  return r;
}
     c10:	854a                	mv	a0,s2
     c12:	60e2                	ld	ra,24(sp)
     c14:	6442                	ld	s0,16(sp)
     c16:	64a2                	ld	s1,8(sp)
     c18:	6902                	ld	s2,0(sp)
     c1a:	6105                	addi	sp,sp,32
     c1c:	8082                	ret
    return -1;
     c1e:	597d                	li	s2,-1
     c20:	bfc5                	j	c10 <stat+0x34>

0000000000000c22 <atoi>:

int
atoi(const char *s)
{
     c22:	1141                	addi	sp,sp,-16
     c24:	e422                	sd	s0,8(sp)
     c26:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c28:	00054603          	lbu	a2,0(a0)
     c2c:	fd06079b          	addiw	a5,a2,-48
     c30:	0ff7f793          	andi	a5,a5,255
     c34:	4725                	li	a4,9
     c36:	02f76963          	bltu	a4,a5,c68 <atoi+0x46>
     c3a:	86aa                	mv	a3,a0
  n = 0;
     c3c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     c3e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     c40:	0685                	addi	a3,a3,1
     c42:	0025179b          	slliw	a5,a0,0x2
     c46:	9fa9                	addw	a5,a5,a0
     c48:	0017979b          	slliw	a5,a5,0x1
     c4c:	9fb1                	addw	a5,a5,a2
     c4e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c52:	0006c603          	lbu	a2,0(a3)
     c56:	fd06071b          	addiw	a4,a2,-48
     c5a:	0ff77713          	andi	a4,a4,255
     c5e:	fee5f1e3          	bgeu	a1,a4,c40 <atoi+0x1e>
  return n;
}
     c62:	6422                	ld	s0,8(sp)
     c64:	0141                	addi	sp,sp,16
     c66:	8082                	ret
  n = 0;
     c68:	4501                	li	a0,0
     c6a:	bfe5                	j	c62 <atoi+0x40>

0000000000000c6c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c6c:	1141                	addi	sp,sp,-16
     c6e:	e422                	sd	s0,8(sp)
     c70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     c72:	00c05f63          	blez	a2,c90 <memmove+0x24>
     c76:	1602                	slli	a2,a2,0x20
     c78:	9201                	srli	a2,a2,0x20
     c7a:	00c506b3          	add	a3,a0,a2
  dst = vdst;
     c7e:	87aa                	mv	a5,a0
    *dst++ = *src++;
     c80:	0585                	addi	a1,a1,1
     c82:	0785                	addi	a5,a5,1
     c84:	fff5c703          	lbu	a4,-1(a1)
     c88:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
     c8c:	fed79ae3          	bne	a5,a3,c80 <memmove+0x14>
  return vdst;
}
     c90:	6422                	ld	s0,8(sp)
     c92:	0141                	addi	sp,sp,16
     c94:	8082                	ret

0000000000000c96 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c96:	4885                	li	a7,1
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <exit>:
.global exit
exit:
 li a7, SYS_exit
     c9e:	4889                	li	a7,2
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ca6:	488d                	li	a7,3
 ecall
     ca8:	00000073          	ecall
 ret
     cac:	8082                	ret

0000000000000cae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     cae:	4891                	li	a7,4
 ecall
     cb0:	00000073          	ecall
 ret
     cb4:	8082                	ret

0000000000000cb6 <read>:
.global read
read:
 li a7, SYS_read
     cb6:	4895                	li	a7,5
 ecall
     cb8:	00000073          	ecall
 ret
     cbc:	8082                	ret

0000000000000cbe <write>:
.global write
write:
 li a7, SYS_write
     cbe:	48c1                	li	a7,16
 ecall
     cc0:	00000073          	ecall
 ret
     cc4:	8082                	ret

0000000000000cc6 <close>:
.global close
close:
 li a7, SYS_close
     cc6:	48d5                	li	a7,21
 ecall
     cc8:	00000073          	ecall
 ret
     ccc:	8082                	ret

0000000000000cce <kill>:
.global kill
kill:
 li a7, SYS_kill
     cce:	4899                	li	a7,6
 ecall
     cd0:	00000073          	ecall
 ret
     cd4:	8082                	ret

0000000000000cd6 <exec>:
.global exec
exec:
 li a7, SYS_exec
     cd6:	489d                	li	a7,7
 ecall
     cd8:	00000073          	ecall
 ret
     cdc:	8082                	ret

0000000000000cde <open>:
.global open
open:
 li a7, SYS_open
     cde:	48bd                	li	a7,15
 ecall
     ce0:	00000073          	ecall
 ret
     ce4:	8082                	ret

0000000000000ce6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ce6:	48c5                	li	a7,17
 ecall
     ce8:	00000073          	ecall
 ret
     cec:	8082                	ret

0000000000000cee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cee:	48c9                	li	a7,18
 ecall
     cf0:	00000073          	ecall
 ret
     cf4:	8082                	ret

0000000000000cf6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cf6:	48a1                	li	a7,8
 ecall
     cf8:	00000073          	ecall
 ret
     cfc:	8082                	ret

0000000000000cfe <link>:
.global link
link:
 li a7, SYS_link
     cfe:	48cd                	li	a7,19
 ecall
     d00:	00000073          	ecall
 ret
     d04:	8082                	ret

0000000000000d06 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d06:	48d1                	li	a7,20
 ecall
     d08:	00000073          	ecall
 ret
     d0c:	8082                	ret

0000000000000d0e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d0e:	48a5                	li	a7,9
 ecall
     d10:	00000073          	ecall
 ret
     d14:	8082                	ret

0000000000000d16 <dup>:
.global dup
dup:
 li a7, SYS_dup
     d16:	48a9                	li	a7,10
 ecall
     d18:	00000073          	ecall
 ret
     d1c:	8082                	ret

0000000000000d1e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d1e:	48ad                	li	a7,11
 ecall
     d20:	00000073          	ecall
 ret
     d24:	8082                	ret

0000000000000d26 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     d26:	48b1                	li	a7,12
 ecall
     d28:	00000073          	ecall
 ret
     d2c:	8082                	ret

0000000000000d2e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     d2e:	48b5                	li	a7,13
 ecall
     d30:	00000073          	ecall
 ret
     d34:	8082                	ret

0000000000000d36 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d36:	48b9                	li	a7,14
 ecall
     d38:	00000073          	ecall
 ret
     d3c:	8082                	ret

0000000000000d3e <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
     d3e:	48d9                	li	a7,22
 ecall
     d40:	00000073          	ecall
 ret
     d44:	8082                	ret

0000000000000d46 <crash>:
.global crash
crash:
 li a7, SYS_crash
     d46:	48dd                	li	a7,23
 ecall
     d48:	00000073          	ecall
 ret
     d4c:	8082                	ret

0000000000000d4e <mount>:
.global mount
mount:
 li a7, SYS_mount
     d4e:	48e1                	li	a7,24
 ecall
     d50:	00000073          	ecall
 ret
     d54:	8082                	ret

0000000000000d56 <umount>:
.global umount
umount:
 li a7, SYS_umount
     d56:	48e5                	li	a7,25
 ecall
     d58:	00000073          	ecall
 ret
     d5c:	8082                	ret

0000000000000d5e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d5e:	1101                	addi	sp,sp,-32
     d60:	ec06                	sd	ra,24(sp)
     d62:	e822                	sd	s0,16(sp)
     d64:	1000                	addi	s0,sp,32
     d66:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d6a:	4605                	li	a2,1
     d6c:	fef40593          	addi	a1,s0,-17
     d70:	00000097          	auipc	ra,0x0
     d74:	f4e080e7          	jalr	-178(ra) # cbe <write>
}
     d78:	60e2                	ld	ra,24(sp)
     d7a:	6442                	ld	s0,16(sp)
     d7c:	6105                	addi	sp,sp,32
     d7e:	8082                	ret

0000000000000d80 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d80:	7139                	addi	sp,sp,-64
     d82:	fc06                	sd	ra,56(sp)
     d84:	f822                	sd	s0,48(sp)
     d86:	f426                	sd	s1,40(sp)
     d88:	f04a                	sd	s2,32(sp)
     d8a:	ec4e                	sd	s3,24(sp)
     d8c:	0080                	addi	s0,sp,64
     d8e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d90:	c299                	beqz	a3,d96 <printint+0x16>
     d92:	0805c863          	bltz	a1,e22 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d96:	2581                	sext.w	a1,a1
  neg = 0;
     d98:	4881                	li	a7,0
     d9a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     d9e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     da0:	2601                	sext.w	a2,a2
     da2:	00000517          	auipc	a0,0x0
     da6:	78e50513          	addi	a0,a0,1934 # 1530 <digits>
     daa:	883a                	mv	a6,a4
     dac:	2705                	addiw	a4,a4,1
     dae:	02c5f7bb          	remuw	a5,a1,a2
     db2:	1782                	slli	a5,a5,0x20
     db4:	9381                	srli	a5,a5,0x20
     db6:	97aa                	add	a5,a5,a0
     db8:	0007c783          	lbu	a5,0(a5)
     dbc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     dc0:	0005879b          	sext.w	a5,a1
     dc4:	02c5d5bb          	divuw	a1,a1,a2
     dc8:	0685                	addi	a3,a3,1
     dca:	fec7f0e3          	bgeu	a5,a2,daa <printint+0x2a>
  if(neg)
     dce:	00088b63          	beqz	a7,de4 <printint+0x64>
    buf[i++] = '-';
     dd2:	fd040793          	addi	a5,s0,-48
     dd6:	973e                	add	a4,a4,a5
     dd8:	02d00793          	li	a5,45
     ddc:	fef70823          	sb	a5,-16(a4)
     de0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     de4:	02e05863          	blez	a4,e14 <printint+0x94>
     de8:	fc040793          	addi	a5,s0,-64
     dec:	00e78933          	add	s2,a5,a4
     df0:	fff78993          	addi	s3,a5,-1
     df4:	99ba                	add	s3,s3,a4
     df6:	377d                	addiw	a4,a4,-1
     df8:	1702                	slli	a4,a4,0x20
     dfa:	9301                	srli	a4,a4,0x20
     dfc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e00:	fff94583          	lbu	a1,-1(s2)
     e04:	8526                	mv	a0,s1
     e06:	00000097          	auipc	ra,0x0
     e0a:	f58080e7          	jalr	-168(ra) # d5e <putc>
  while(--i >= 0)
     e0e:	197d                	addi	s2,s2,-1
     e10:	ff3918e3          	bne	s2,s3,e00 <printint+0x80>
}
     e14:	70e2                	ld	ra,56(sp)
     e16:	7442                	ld	s0,48(sp)
     e18:	74a2                	ld	s1,40(sp)
     e1a:	7902                	ld	s2,32(sp)
     e1c:	69e2                	ld	s3,24(sp)
     e1e:	6121                	addi	sp,sp,64
     e20:	8082                	ret
    x = -xx;
     e22:	40b005bb          	negw	a1,a1
    neg = 1;
     e26:	4885                	li	a7,1
    x = -xx;
     e28:	bf8d                	j	d9a <printint+0x1a>

0000000000000e2a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     e2a:	7119                	addi	sp,sp,-128
     e2c:	fc86                	sd	ra,120(sp)
     e2e:	f8a2                	sd	s0,112(sp)
     e30:	f4a6                	sd	s1,104(sp)
     e32:	f0ca                	sd	s2,96(sp)
     e34:	ecce                	sd	s3,88(sp)
     e36:	e8d2                	sd	s4,80(sp)
     e38:	e4d6                	sd	s5,72(sp)
     e3a:	e0da                	sd	s6,64(sp)
     e3c:	fc5e                	sd	s7,56(sp)
     e3e:	f862                	sd	s8,48(sp)
     e40:	f466                	sd	s9,40(sp)
     e42:	f06a                	sd	s10,32(sp)
     e44:	ec6e                	sd	s11,24(sp)
     e46:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     e48:	0005c903          	lbu	s2,0(a1)
     e4c:	18090f63          	beqz	s2,fea <vprintf+0x1c0>
     e50:	8aaa                	mv	s5,a0
     e52:	8b32                	mv	s6,a2
     e54:	00158493          	addi	s1,a1,1
  state = 0;
     e58:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     e5a:	02500a13          	li	s4,37
      if(c == 'd'){
     e5e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     e62:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     e66:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     e6a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e6e:	00000b97          	auipc	s7,0x0
     e72:	6c2b8b93          	addi	s7,s7,1730 # 1530 <digits>
     e76:	a839                	j	e94 <vprintf+0x6a>
        putc(fd, c);
     e78:	85ca                	mv	a1,s2
     e7a:	8556                	mv	a0,s5
     e7c:	00000097          	auipc	ra,0x0
     e80:	ee2080e7          	jalr	-286(ra) # d5e <putc>
     e84:	a019                	j	e8a <vprintf+0x60>
    } else if(state == '%'){
     e86:	01498f63          	beq	s3,s4,ea4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     e8a:	0485                	addi	s1,s1,1
     e8c:	fff4c903          	lbu	s2,-1(s1)
     e90:	14090d63          	beqz	s2,fea <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     e94:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e98:	fe0997e3          	bnez	s3,e86 <vprintf+0x5c>
      if(c == '%'){
     e9c:	fd479ee3          	bne	a5,s4,e78 <vprintf+0x4e>
        state = '%';
     ea0:	89be                	mv	s3,a5
     ea2:	b7e5                	j	e8a <vprintf+0x60>
      if(c == 'd'){
     ea4:	05878063          	beq	a5,s8,ee4 <vprintf+0xba>
      } else if(c == 'l') {
     ea8:	05978c63          	beq	a5,s9,f00 <vprintf+0xd6>
      } else if(c == 'x') {
     eac:	07a78863          	beq	a5,s10,f1c <vprintf+0xf2>
      } else if(c == 'p') {
     eb0:	09b78463          	beq	a5,s11,f38 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     eb4:	07300713          	li	a4,115
     eb8:	0ce78663          	beq	a5,a4,f84 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     ebc:	06300713          	li	a4,99
     ec0:	0ee78e63          	beq	a5,a4,fbc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     ec4:	11478863          	beq	a5,s4,fd4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     ec8:	85d2                	mv	a1,s4
     eca:	8556                	mv	a0,s5
     ecc:	00000097          	auipc	ra,0x0
     ed0:	e92080e7          	jalr	-366(ra) # d5e <putc>
        putc(fd, c);
     ed4:	85ca                	mv	a1,s2
     ed6:	8556                	mv	a0,s5
     ed8:	00000097          	auipc	ra,0x0
     edc:	e86080e7          	jalr	-378(ra) # d5e <putc>
      }
      state = 0;
     ee0:	4981                	li	s3,0
     ee2:	b765                	j	e8a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     ee4:	008b0913          	addi	s2,s6,8
     ee8:	4685                	li	a3,1
     eea:	4629                	li	a2,10
     eec:	000b2583          	lw	a1,0(s6)
     ef0:	8556                	mv	a0,s5
     ef2:	00000097          	auipc	ra,0x0
     ef6:	e8e080e7          	jalr	-370(ra) # d80 <printint>
     efa:	8b4a                	mv	s6,s2
      state = 0;
     efc:	4981                	li	s3,0
     efe:	b771                	j	e8a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f00:	008b0913          	addi	s2,s6,8
     f04:	4681                	li	a3,0
     f06:	4629                	li	a2,10
     f08:	000b2583          	lw	a1,0(s6)
     f0c:	8556                	mv	a0,s5
     f0e:	00000097          	auipc	ra,0x0
     f12:	e72080e7          	jalr	-398(ra) # d80 <printint>
     f16:	8b4a                	mv	s6,s2
      state = 0;
     f18:	4981                	li	s3,0
     f1a:	bf85                	j	e8a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     f1c:	008b0913          	addi	s2,s6,8
     f20:	4681                	li	a3,0
     f22:	4641                	li	a2,16
     f24:	000b2583          	lw	a1,0(s6)
     f28:	8556                	mv	a0,s5
     f2a:	00000097          	auipc	ra,0x0
     f2e:	e56080e7          	jalr	-426(ra) # d80 <printint>
     f32:	8b4a                	mv	s6,s2
      state = 0;
     f34:	4981                	li	s3,0
     f36:	bf91                	j	e8a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     f38:	008b0793          	addi	a5,s6,8
     f3c:	f8f43423          	sd	a5,-120(s0)
     f40:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     f44:	03000593          	li	a1,48
     f48:	8556                	mv	a0,s5
     f4a:	00000097          	auipc	ra,0x0
     f4e:	e14080e7          	jalr	-492(ra) # d5e <putc>
  putc(fd, 'x');
     f52:	85ea                	mv	a1,s10
     f54:	8556                	mv	a0,s5
     f56:	00000097          	auipc	ra,0x0
     f5a:	e08080e7          	jalr	-504(ra) # d5e <putc>
     f5e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f60:	03c9d793          	srli	a5,s3,0x3c
     f64:	97de                	add	a5,a5,s7
     f66:	0007c583          	lbu	a1,0(a5)
     f6a:	8556                	mv	a0,s5
     f6c:	00000097          	auipc	ra,0x0
     f70:	df2080e7          	jalr	-526(ra) # d5e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f74:	0992                	slli	s3,s3,0x4
     f76:	397d                	addiw	s2,s2,-1
     f78:	fe0914e3          	bnez	s2,f60 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     f7c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     f80:	4981                	li	s3,0
     f82:	b721                	j	e8a <vprintf+0x60>
        s = va_arg(ap, char*);
     f84:	008b0993          	addi	s3,s6,8
     f88:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     f8c:	02090163          	beqz	s2,fae <vprintf+0x184>
        while(*s != 0){
     f90:	00094583          	lbu	a1,0(s2)
     f94:	c9a1                	beqz	a1,fe4 <vprintf+0x1ba>
          putc(fd, *s);
     f96:	8556                	mv	a0,s5
     f98:	00000097          	auipc	ra,0x0
     f9c:	dc6080e7          	jalr	-570(ra) # d5e <putc>
          s++;
     fa0:	0905                	addi	s2,s2,1
        while(*s != 0){
     fa2:	00094583          	lbu	a1,0(s2)
     fa6:	f9e5                	bnez	a1,f96 <vprintf+0x16c>
        s = va_arg(ap, char*);
     fa8:	8b4e                	mv	s6,s3
      state = 0;
     faa:	4981                	li	s3,0
     fac:	bdf9                	j	e8a <vprintf+0x60>
          s = "(null)";
     fae:	00000917          	auipc	s2,0x0
     fb2:	57a90913          	addi	s2,s2,1402 # 1528 <malloc+0x434>
        while(*s != 0){
     fb6:	02800593          	li	a1,40
     fba:	bff1                	j	f96 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     fbc:	008b0913          	addi	s2,s6,8
     fc0:	000b4583          	lbu	a1,0(s6)
     fc4:	8556                	mv	a0,s5
     fc6:	00000097          	auipc	ra,0x0
     fca:	d98080e7          	jalr	-616(ra) # d5e <putc>
     fce:	8b4a                	mv	s6,s2
      state = 0;
     fd0:	4981                	li	s3,0
     fd2:	bd65                	j	e8a <vprintf+0x60>
        putc(fd, c);
     fd4:	85d2                	mv	a1,s4
     fd6:	8556                	mv	a0,s5
     fd8:	00000097          	auipc	ra,0x0
     fdc:	d86080e7          	jalr	-634(ra) # d5e <putc>
      state = 0;
     fe0:	4981                	li	s3,0
     fe2:	b565                	j	e8a <vprintf+0x60>
        s = va_arg(ap, char*);
     fe4:	8b4e                	mv	s6,s3
      state = 0;
     fe6:	4981                	li	s3,0
     fe8:	b54d                	j	e8a <vprintf+0x60>
    }
  }
}
     fea:	70e6                	ld	ra,120(sp)
     fec:	7446                	ld	s0,112(sp)
     fee:	74a6                	ld	s1,104(sp)
     ff0:	7906                	ld	s2,96(sp)
     ff2:	69e6                	ld	s3,88(sp)
     ff4:	6a46                	ld	s4,80(sp)
     ff6:	6aa6                	ld	s5,72(sp)
     ff8:	6b06                	ld	s6,64(sp)
     ffa:	7be2                	ld	s7,56(sp)
     ffc:	7c42                	ld	s8,48(sp)
     ffe:	7ca2                	ld	s9,40(sp)
    1000:	7d02                	ld	s10,32(sp)
    1002:	6de2                	ld	s11,24(sp)
    1004:	6109                	addi	sp,sp,128
    1006:	8082                	ret

0000000000001008 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1008:	715d                	addi	sp,sp,-80
    100a:	ec06                	sd	ra,24(sp)
    100c:	e822                	sd	s0,16(sp)
    100e:	1000                	addi	s0,sp,32
    1010:	e010                	sd	a2,0(s0)
    1012:	e414                	sd	a3,8(s0)
    1014:	e818                	sd	a4,16(s0)
    1016:	ec1c                	sd	a5,24(s0)
    1018:	03043023          	sd	a6,32(s0)
    101c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1020:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1024:	8622                	mv	a2,s0
    1026:	00000097          	auipc	ra,0x0
    102a:	e04080e7          	jalr	-508(ra) # e2a <vprintf>
}
    102e:	60e2                	ld	ra,24(sp)
    1030:	6442                	ld	s0,16(sp)
    1032:	6161                	addi	sp,sp,80
    1034:	8082                	ret

0000000000001036 <printf>:

void
printf(const char *fmt, ...)
{
    1036:	711d                	addi	sp,sp,-96
    1038:	ec06                	sd	ra,24(sp)
    103a:	e822                	sd	s0,16(sp)
    103c:	1000                	addi	s0,sp,32
    103e:	e40c                	sd	a1,8(s0)
    1040:	e810                	sd	a2,16(s0)
    1042:	ec14                	sd	a3,24(s0)
    1044:	f018                	sd	a4,32(s0)
    1046:	f41c                	sd	a5,40(s0)
    1048:	03043823          	sd	a6,48(s0)
    104c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1050:	00840613          	addi	a2,s0,8
    1054:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1058:	85aa                	mv	a1,a0
    105a:	4505                	li	a0,1
    105c:	00000097          	auipc	ra,0x0
    1060:	dce080e7          	jalr	-562(ra) # e2a <vprintf>
}
    1064:	60e2                	ld	ra,24(sp)
    1066:	6442                	ld	s0,16(sp)
    1068:	6125                	addi	sp,sp,96
    106a:	8082                	ret

000000000000106c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    106c:	1141                	addi	sp,sp,-16
    106e:	e422                	sd	s0,8(sp)
    1070:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1072:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1076:	00000797          	auipc	a5,0x0
    107a:	4d27b783          	ld	a5,1234(a5) # 1548 <freep>
    107e:	a805                	j	10ae <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1080:	4618                	lw	a4,8(a2)
    1082:	9db9                	addw	a1,a1,a4
    1084:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1088:	6398                	ld	a4,0(a5)
    108a:	6318                	ld	a4,0(a4)
    108c:	fee53823          	sd	a4,-16(a0)
    1090:	a091                	j	10d4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1092:	ff852703          	lw	a4,-8(a0)
    1096:	9e39                	addw	a2,a2,a4
    1098:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    109a:	ff053703          	ld	a4,-16(a0)
    109e:	e398                	sd	a4,0(a5)
    10a0:	a099                	j	10e6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10a2:	6398                	ld	a4,0(a5)
    10a4:	00e7e463          	bltu	a5,a4,10ac <free+0x40>
    10a8:	00e6ea63          	bltu	a3,a4,10bc <free+0x50>
{
    10ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ae:	fed7fae3          	bgeu	a5,a3,10a2 <free+0x36>
    10b2:	6398                	ld	a4,0(a5)
    10b4:	00e6e463          	bltu	a3,a4,10bc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10b8:	fee7eae3          	bltu	a5,a4,10ac <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    10bc:	ff852583          	lw	a1,-8(a0)
    10c0:	6390                	ld	a2,0(a5)
    10c2:	02059813          	slli	a6,a1,0x20
    10c6:	01c85713          	srli	a4,a6,0x1c
    10ca:	9736                	add	a4,a4,a3
    10cc:	fae60ae3          	beq	a2,a4,1080 <free+0x14>
    bp->s.ptr = p->s.ptr;
    10d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    10d4:	4790                	lw	a2,8(a5)
    10d6:	02061593          	slli	a1,a2,0x20
    10da:	01c5d713          	srli	a4,a1,0x1c
    10de:	973e                	add	a4,a4,a5
    10e0:	fae689e3          	beq	a3,a4,1092 <free+0x26>
  } else
    p->s.ptr = bp;
    10e4:	e394                	sd	a3,0(a5)
  freep = p;
    10e6:	00000717          	auipc	a4,0x0
    10ea:	46f73123          	sd	a5,1122(a4) # 1548 <freep>
}
    10ee:	6422                	ld	s0,8(sp)
    10f0:	0141                	addi	sp,sp,16
    10f2:	8082                	ret

00000000000010f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10f4:	7139                	addi	sp,sp,-64
    10f6:	fc06                	sd	ra,56(sp)
    10f8:	f822                	sd	s0,48(sp)
    10fa:	f426                	sd	s1,40(sp)
    10fc:	f04a                	sd	s2,32(sp)
    10fe:	ec4e                	sd	s3,24(sp)
    1100:	e852                	sd	s4,16(sp)
    1102:	e456                	sd	s5,8(sp)
    1104:	e05a                	sd	s6,0(sp)
    1106:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1108:	02051493          	slli	s1,a0,0x20
    110c:	9081                	srli	s1,s1,0x20
    110e:	04bd                	addi	s1,s1,15
    1110:	8091                	srli	s1,s1,0x4
    1112:	0014899b          	addiw	s3,s1,1
    1116:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1118:	00000517          	auipc	a0,0x0
    111c:	43053503          	ld	a0,1072(a0) # 1548 <freep>
    1120:	c515                	beqz	a0,114c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1122:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1124:	4798                	lw	a4,8(a5)
    1126:	02977f63          	bgeu	a4,s1,1164 <malloc+0x70>
    112a:	8a4e                	mv	s4,s3
    112c:	0009871b          	sext.w	a4,s3
    1130:	6685                	lui	a3,0x1
    1132:	00d77363          	bgeu	a4,a3,1138 <malloc+0x44>
    1136:	6a05                	lui	s4,0x1
    1138:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    113c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1140:	00000917          	auipc	s2,0x0
    1144:	40890913          	addi	s2,s2,1032 # 1548 <freep>
  if(p == (char*)-1)
    1148:	5afd                	li	s5,-1
    114a:	a895                	j	11be <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    114c:	00000797          	auipc	a5,0x0
    1150:	40478793          	addi	a5,a5,1028 # 1550 <base>
    1154:	00000717          	auipc	a4,0x0
    1158:	3ef73a23          	sd	a5,1012(a4) # 1548 <freep>
    115c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    115e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1162:	b7e1                	j	112a <malloc+0x36>
      if(p->s.size == nunits)
    1164:	02e48c63          	beq	s1,a4,119c <malloc+0xa8>
        p->s.size -= nunits;
    1168:	4137073b          	subw	a4,a4,s3
    116c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    116e:	02071693          	slli	a3,a4,0x20
    1172:	01c6d713          	srli	a4,a3,0x1c
    1176:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1178:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    117c:	00000717          	auipc	a4,0x0
    1180:	3ca73623          	sd	a0,972(a4) # 1548 <freep>
      return (void*)(p + 1);
    1184:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1188:	70e2                	ld	ra,56(sp)
    118a:	7442                	ld	s0,48(sp)
    118c:	74a2                	ld	s1,40(sp)
    118e:	7902                	ld	s2,32(sp)
    1190:	69e2                	ld	s3,24(sp)
    1192:	6a42                	ld	s4,16(sp)
    1194:	6aa2                	ld	s5,8(sp)
    1196:	6b02                	ld	s6,0(sp)
    1198:	6121                	addi	sp,sp,64
    119a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    119c:	6398                	ld	a4,0(a5)
    119e:	e118                	sd	a4,0(a0)
    11a0:	bff1                	j	117c <malloc+0x88>
  hp->s.size = nu;
    11a2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11a6:	0541                	addi	a0,a0,16
    11a8:	00000097          	auipc	ra,0x0
    11ac:	ec4080e7          	jalr	-316(ra) # 106c <free>
  return freep;
    11b0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11b4:	d971                	beqz	a0,1188 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11b8:	4798                	lw	a4,8(a5)
    11ba:	fa9775e3          	bgeu	a4,s1,1164 <malloc+0x70>
    if(p == freep)
    11be:	00093703          	ld	a4,0(s2)
    11c2:	853e                	mv	a0,a5
    11c4:	fef719e3          	bne	a4,a5,11b6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    11c8:	8552                	mv	a0,s4
    11ca:	00000097          	auipc	ra,0x0
    11ce:	b5c080e7          	jalr	-1188(ra) # d26 <sbrk>
  if(p == (char*)-1)
    11d2:	fd5518e3          	bne	a0,s5,11a2 <malloc+0xae>
        return 0;
    11d6:	4501                	li	a0,0
    11d8:	bf45                	j	1188 <malloc+0x94>
