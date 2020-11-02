
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
       0:	00007797          	auipc	a5,0x7
       4:	b2078793          	addi	a5,a5,-1248 # 6b20 <uninit>
       8:	00009697          	auipc	a3,0x9
       c:	22868693          	addi	a3,a3,552 # 9230 <buf>
    if(uninit[i] != '\0'){
      10:	0007c703          	lbu	a4,0(a5)
      14:	e709                	bnez	a4,1e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      16:	0785                	addi	a5,a5,1
      18:	fed79ce3          	bne	a5,a3,10 <bsstest+0x10>
      1c:	8082                	ret
{
      1e:	1141                	addi	sp,sp,-16
      20:	e406                	sd	ra,8(sp)
      22:	e022                	sd	s0,0(sp)
      24:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      26:	85aa                	mv	a1,a0
      28:	00005517          	auipc	a0,0x5
      2c:	ba850513          	addi	a0,a0,-1112 # 4bd0 <malloc+0x370>
      30:	00004097          	auipc	ra,0x4
      34:	772080e7          	jalr	1906(ra) # 47a2 <printf>
      exit(1);
      38:	4505                	li	a0,1
      3a:	00004097          	auipc	ra,0x4
      3e:	3e8080e7          	jalr	1000(ra) # 4422 <exit>

0000000000000042 <iputtest>:
{
      42:	1101                	addi	sp,sp,-32
      44:	ec06                	sd	ra,24(sp)
      46:	e822                	sd	s0,16(sp)
      48:	e426                	sd	s1,8(sp)
      4a:	1000                	addi	s0,sp,32
      4c:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
      4e:	00005517          	auipc	a0,0x5
      52:	b9a50513          	addi	a0,a0,-1126 # 4be8 <malloc+0x388>
      56:	00004097          	auipc	ra,0x4
      5a:	434080e7          	jalr	1076(ra) # 448a <mkdir>
      5e:	04054563          	bltz	a0,a8 <iputtest+0x66>
  if(chdir("iputdir") < 0){
      62:	00005517          	auipc	a0,0x5
      66:	b8650513          	addi	a0,a0,-1146 # 4be8 <malloc+0x388>
      6a:	00004097          	auipc	ra,0x4
      6e:	428080e7          	jalr	1064(ra) # 4492 <chdir>
      72:	04054963          	bltz	a0,c4 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
      76:	00005517          	auipc	a0,0x5
      7a:	bb250513          	addi	a0,a0,-1102 # 4c28 <malloc+0x3c8>
      7e:	00004097          	auipc	ra,0x4
      82:	3f4080e7          	jalr	1012(ra) # 4472 <unlink>
      86:	04054d63          	bltz	a0,e0 <iputtest+0x9e>
  if(chdir("/") < 0){
      8a:	00005517          	auipc	a0,0x5
      8e:	bce50513          	addi	a0,a0,-1074 # 4c58 <malloc+0x3f8>
      92:	00004097          	auipc	ra,0x4
      96:	400080e7          	jalr	1024(ra) # 4492 <chdir>
      9a:	06054163          	bltz	a0,fc <iputtest+0xba>
}
      9e:	60e2                	ld	ra,24(sp)
      a0:	6442                	ld	s0,16(sp)
      a2:	64a2                	ld	s1,8(sp)
      a4:	6105                	addi	sp,sp,32
      a6:	8082                	ret
    printf("%s: mkdir failed\n", s);
      a8:	85a6                	mv	a1,s1
      aa:	00005517          	auipc	a0,0x5
      ae:	b4650513          	addi	a0,a0,-1210 # 4bf0 <malloc+0x390>
      b2:	00004097          	auipc	ra,0x4
      b6:	6f0080e7          	jalr	1776(ra) # 47a2 <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	00004097          	auipc	ra,0x4
      c0:	366080e7          	jalr	870(ra) # 4422 <exit>
    printf("%s: chdir iputdir failed\n", s);
      c4:	85a6                	mv	a1,s1
      c6:	00005517          	auipc	a0,0x5
      ca:	b4250513          	addi	a0,a0,-1214 # 4c08 <malloc+0x3a8>
      ce:	00004097          	auipc	ra,0x4
      d2:	6d4080e7          	jalr	1748(ra) # 47a2 <printf>
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00004097          	auipc	ra,0x4
      dc:	34a080e7          	jalr	842(ra) # 4422 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
      e0:	85a6                	mv	a1,s1
      e2:	00005517          	auipc	a0,0x5
      e6:	b5650513          	addi	a0,a0,-1194 # 4c38 <malloc+0x3d8>
      ea:	00004097          	auipc	ra,0x4
      ee:	6b8080e7          	jalr	1720(ra) # 47a2 <printf>
    exit(1);
      f2:	4505                	li	a0,1
      f4:	00004097          	auipc	ra,0x4
      f8:	32e080e7          	jalr	814(ra) # 4422 <exit>
    printf("%s: chdir / failed\n", s);
      fc:	85a6                	mv	a1,s1
      fe:	00005517          	auipc	a0,0x5
     102:	b6250513          	addi	a0,a0,-1182 # 4c60 <malloc+0x400>
     106:	00004097          	auipc	ra,0x4
     10a:	69c080e7          	jalr	1692(ra) # 47a2 <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00004097          	auipc	ra,0x4
     114:	312080e7          	jalr	786(ra) # 4422 <exit>

0000000000000118 <rmdot>:
{
     118:	1101                	addi	sp,sp,-32
     11a:	ec06                	sd	ra,24(sp)
     11c:	e822                	sd	s0,16(sp)
     11e:	e426                	sd	s1,8(sp)
     120:	1000                	addi	s0,sp,32
     122:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
     124:	00005517          	auipc	a0,0x5
     128:	b5450513          	addi	a0,a0,-1196 # 4c78 <malloc+0x418>
     12c:	00004097          	auipc	ra,0x4
     130:	35e080e7          	jalr	862(ra) # 448a <mkdir>
     134:	e549                	bnez	a0,1be <rmdot+0xa6>
  if(chdir("dots") != 0){
     136:	00005517          	auipc	a0,0x5
     13a:	b4250513          	addi	a0,a0,-1214 # 4c78 <malloc+0x418>
     13e:	00004097          	auipc	ra,0x4
     142:	354080e7          	jalr	852(ra) # 4492 <chdir>
     146:	e951                	bnez	a0,1da <rmdot+0xc2>
  if(unlink(".") == 0){
     148:	00005517          	auipc	a0,0x5
     14c:	b6850513          	addi	a0,a0,-1176 # 4cb0 <malloc+0x450>
     150:	00004097          	auipc	ra,0x4
     154:	322080e7          	jalr	802(ra) # 4472 <unlink>
     158:	cd59                	beqz	a0,1f6 <rmdot+0xde>
  if(unlink("..") == 0){
     15a:	00005517          	auipc	a0,0x5
     15e:	b7650513          	addi	a0,a0,-1162 # 4cd0 <malloc+0x470>
     162:	00004097          	auipc	ra,0x4
     166:	310080e7          	jalr	784(ra) # 4472 <unlink>
     16a:	c545                	beqz	a0,212 <rmdot+0xfa>
  if(chdir("/") != 0){
     16c:	00005517          	auipc	a0,0x5
     170:	aec50513          	addi	a0,a0,-1300 # 4c58 <malloc+0x3f8>
     174:	00004097          	auipc	ra,0x4
     178:	31e080e7          	jalr	798(ra) # 4492 <chdir>
     17c:	e94d                	bnez	a0,22e <rmdot+0x116>
  if(unlink("dots/.") == 0){
     17e:	00005517          	auipc	a0,0x5
     182:	b7250513          	addi	a0,a0,-1166 # 4cf0 <malloc+0x490>
     186:	00004097          	auipc	ra,0x4
     18a:	2ec080e7          	jalr	748(ra) # 4472 <unlink>
     18e:	cd55                	beqz	a0,24a <rmdot+0x132>
  if(unlink("dots/..") == 0){
     190:	00005517          	auipc	a0,0x5
     194:	b8850513          	addi	a0,a0,-1144 # 4d18 <malloc+0x4b8>
     198:	00004097          	auipc	ra,0x4
     19c:	2da080e7          	jalr	730(ra) # 4472 <unlink>
     1a0:	c179                	beqz	a0,266 <rmdot+0x14e>
  if(unlink("dots") != 0){
     1a2:	00005517          	auipc	a0,0x5
     1a6:	ad650513          	addi	a0,a0,-1322 # 4c78 <malloc+0x418>
     1aa:	00004097          	auipc	ra,0x4
     1ae:	2c8080e7          	jalr	712(ra) # 4472 <unlink>
     1b2:	e961                	bnez	a0,282 <rmdot+0x16a>
}
     1b4:	60e2                	ld	ra,24(sp)
     1b6:	6442                	ld	s0,16(sp)
     1b8:	64a2                	ld	s1,8(sp)
     1ba:	6105                	addi	sp,sp,32
     1bc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
     1be:	85a6                	mv	a1,s1
     1c0:	00005517          	auipc	a0,0x5
     1c4:	ac050513          	addi	a0,a0,-1344 # 4c80 <malloc+0x420>
     1c8:	00004097          	auipc	ra,0x4
     1cc:	5da080e7          	jalr	1498(ra) # 47a2 <printf>
    exit(1);
     1d0:	4505                	li	a0,1
     1d2:	00004097          	auipc	ra,0x4
     1d6:	250080e7          	jalr	592(ra) # 4422 <exit>
    printf("%s: chdir dots failed\n", s);
     1da:	85a6                	mv	a1,s1
     1dc:	00005517          	auipc	a0,0x5
     1e0:	abc50513          	addi	a0,a0,-1348 # 4c98 <malloc+0x438>
     1e4:	00004097          	auipc	ra,0x4
     1e8:	5be080e7          	jalr	1470(ra) # 47a2 <printf>
    exit(1);
     1ec:	4505                	li	a0,1
     1ee:	00004097          	auipc	ra,0x4
     1f2:	234080e7          	jalr	564(ra) # 4422 <exit>
    printf("%s: rm . worked!\n", s);
     1f6:	85a6                	mv	a1,s1
     1f8:	00005517          	auipc	a0,0x5
     1fc:	ac050513          	addi	a0,a0,-1344 # 4cb8 <malloc+0x458>
     200:	00004097          	auipc	ra,0x4
     204:	5a2080e7          	jalr	1442(ra) # 47a2 <printf>
    exit(1);
     208:	4505                	li	a0,1
     20a:	00004097          	auipc	ra,0x4
     20e:	218080e7          	jalr	536(ra) # 4422 <exit>
    printf("%s: rm .. worked!\n", s);
     212:	85a6                	mv	a1,s1
     214:	00005517          	auipc	a0,0x5
     218:	ac450513          	addi	a0,a0,-1340 # 4cd8 <malloc+0x478>
     21c:	00004097          	auipc	ra,0x4
     220:	586080e7          	jalr	1414(ra) # 47a2 <printf>
    exit(1);
     224:	4505                	li	a0,1
     226:	00004097          	auipc	ra,0x4
     22a:	1fc080e7          	jalr	508(ra) # 4422 <exit>
    printf("%s: chdir / failed\n", s);
     22e:	85a6                	mv	a1,s1
     230:	00005517          	auipc	a0,0x5
     234:	a3050513          	addi	a0,a0,-1488 # 4c60 <malloc+0x400>
     238:	00004097          	auipc	ra,0x4
     23c:	56a080e7          	jalr	1386(ra) # 47a2 <printf>
    exit(1);
     240:	4505                	li	a0,1
     242:	00004097          	auipc	ra,0x4
     246:	1e0080e7          	jalr	480(ra) # 4422 <exit>
    printf("%s: unlink dots/. worked!\n", s);
     24a:	85a6                	mv	a1,s1
     24c:	00005517          	auipc	a0,0x5
     250:	aac50513          	addi	a0,a0,-1364 # 4cf8 <malloc+0x498>
     254:	00004097          	auipc	ra,0x4
     258:	54e080e7          	jalr	1358(ra) # 47a2 <printf>
    exit(1);
     25c:	4505                	li	a0,1
     25e:	00004097          	auipc	ra,0x4
     262:	1c4080e7          	jalr	452(ra) # 4422 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
     266:	85a6                	mv	a1,s1
     268:	00005517          	auipc	a0,0x5
     26c:	ab850513          	addi	a0,a0,-1352 # 4d20 <malloc+0x4c0>
     270:	00004097          	auipc	ra,0x4
     274:	532080e7          	jalr	1330(ra) # 47a2 <printf>
    exit(1);
     278:	4505                	li	a0,1
     27a:	00004097          	auipc	ra,0x4
     27e:	1a8080e7          	jalr	424(ra) # 4422 <exit>
    printf("%s: unlink dots failed!\n", s);
     282:	85a6                	mv	a1,s1
     284:	00005517          	auipc	a0,0x5
     288:	abc50513          	addi	a0,a0,-1348 # 4d40 <malloc+0x4e0>
     28c:	00004097          	auipc	ra,0x4
     290:	516080e7          	jalr	1302(ra) # 47a2 <printf>
    exit(1);
     294:	4505                	li	a0,1
     296:	00004097          	auipc	ra,0x4
     29a:	18c080e7          	jalr	396(ra) # 4422 <exit>

000000000000029e <exitiputtest>:
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	1800                	addi	s0,sp,48
     2a8:	84aa                	mv	s1,a0
  pid = fork();
     2aa:	00004097          	auipc	ra,0x4
     2ae:	170080e7          	jalr	368(ra) # 441a <fork>
  if(pid < 0){
     2b2:	04054663          	bltz	a0,2fe <exitiputtest+0x60>
  if(pid == 0){
     2b6:	ed45                	bnez	a0,36e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     2b8:	00005517          	auipc	a0,0x5
     2bc:	93050513          	addi	a0,a0,-1744 # 4be8 <malloc+0x388>
     2c0:	00004097          	auipc	ra,0x4
     2c4:	1ca080e7          	jalr	458(ra) # 448a <mkdir>
     2c8:	04054963          	bltz	a0,31a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
     2cc:	00005517          	auipc	a0,0x5
     2d0:	91c50513          	addi	a0,a0,-1764 # 4be8 <malloc+0x388>
     2d4:	00004097          	auipc	ra,0x4
     2d8:	1be080e7          	jalr	446(ra) # 4492 <chdir>
     2dc:	04054d63          	bltz	a0,336 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
     2e0:	00005517          	auipc	a0,0x5
     2e4:	94850513          	addi	a0,a0,-1720 # 4c28 <malloc+0x3c8>
     2e8:	00004097          	auipc	ra,0x4
     2ec:	18a080e7          	jalr	394(ra) # 4472 <unlink>
     2f0:	06054163          	bltz	a0,352 <exitiputtest+0xb4>
    exit(0);
     2f4:	4501                	li	a0,0
     2f6:	00004097          	auipc	ra,0x4
     2fa:	12c080e7          	jalr	300(ra) # 4422 <exit>
    printf("%s: fork failed\n", s);
     2fe:	85a6                	mv	a1,s1
     300:	00005517          	auipc	a0,0x5
     304:	a6050513          	addi	a0,a0,-1440 # 4d60 <malloc+0x500>
     308:	00004097          	auipc	ra,0x4
     30c:	49a080e7          	jalr	1178(ra) # 47a2 <printf>
    exit(1);
     310:	4505                	li	a0,1
     312:	00004097          	auipc	ra,0x4
     316:	110080e7          	jalr	272(ra) # 4422 <exit>
      printf("%s: mkdir failed\n", s);
     31a:	85a6                	mv	a1,s1
     31c:	00005517          	auipc	a0,0x5
     320:	8d450513          	addi	a0,a0,-1836 # 4bf0 <malloc+0x390>
     324:	00004097          	auipc	ra,0x4
     328:	47e080e7          	jalr	1150(ra) # 47a2 <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00004097          	auipc	ra,0x4
     332:	0f4080e7          	jalr	244(ra) # 4422 <exit>
      printf("%s: child chdir failed\n", s);
     336:	85a6                	mv	a1,s1
     338:	00005517          	auipc	a0,0x5
     33c:	a4050513          	addi	a0,a0,-1472 # 4d78 <malloc+0x518>
     340:	00004097          	auipc	ra,0x4
     344:	462080e7          	jalr	1122(ra) # 47a2 <printf>
      exit(1);
     348:	4505                	li	a0,1
     34a:	00004097          	auipc	ra,0x4
     34e:	0d8080e7          	jalr	216(ra) # 4422 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
     352:	85a6                	mv	a1,s1
     354:	00005517          	auipc	a0,0x5
     358:	8e450513          	addi	a0,a0,-1820 # 4c38 <malloc+0x3d8>
     35c:	00004097          	auipc	ra,0x4
     360:	446080e7          	jalr	1094(ra) # 47a2 <printf>
      exit(1);
     364:	4505                	li	a0,1
     366:	00004097          	auipc	ra,0x4
     36a:	0bc080e7          	jalr	188(ra) # 4422 <exit>
  wait(&xstatus);
     36e:	fdc40513          	addi	a0,s0,-36
     372:	00004097          	auipc	ra,0x4
     376:	0b8080e7          	jalr	184(ra) # 442a <wait>
  exit(xstatus);
     37a:	fdc42503          	lw	a0,-36(s0)
     37e:	00004097          	auipc	ra,0x4
     382:	0a4080e7          	jalr	164(ra) # 4422 <exit>

0000000000000386 <exitwait>:
{
     386:	7139                	addi	sp,sp,-64
     388:	fc06                	sd	ra,56(sp)
     38a:	f822                	sd	s0,48(sp)
     38c:	f426                	sd	s1,40(sp)
     38e:	f04a                	sd	s2,32(sp)
     390:	ec4e                	sd	s3,24(sp)
     392:	e852                	sd	s4,16(sp)
     394:	0080                	addi	s0,sp,64
     396:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     398:	4901                	li	s2,0
     39a:	06400993          	li	s3,100
    pid = fork();
     39e:	00004097          	auipc	ra,0x4
     3a2:	07c080e7          	jalr	124(ra) # 441a <fork>
     3a6:	84aa                	mv	s1,a0
    if(pid < 0){
     3a8:	02054a63          	bltz	a0,3dc <exitwait+0x56>
    if(pid){
     3ac:	c151                	beqz	a0,430 <exitwait+0xaa>
      if(wait(&xstate) != pid){
     3ae:	fcc40513          	addi	a0,s0,-52
     3b2:	00004097          	auipc	ra,0x4
     3b6:	078080e7          	jalr	120(ra) # 442a <wait>
     3ba:	02951f63          	bne	a0,s1,3f8 <exitwait+0x72>
      if(i != xstate) {
     3be:	fcc42783          	lw	a5,-52(s0)
     3c2:	05279963          	bne	a5,s2,414 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     3c6:	2905                	addiw	s2,s2,1
     3c8:	fd391be3          	bne	s2,s3,39e <exitwait+0x18>
}
     3cc:	70e2                	ld	ra,56(sp)
     3ce:	7442                	ld	s0,48(sp)
     3d0:	74a2                	ld	s1,40(sp)
     3d2:	7902                	ld	s2,32(sp)
     3d4:	69e2                	ld	s3,24(sp)
     3d6:	6a42                	ld	s4,16(sp)
     3d8:	6121                	addi	sp,sp,64
     3da:	8082                	ret
      printf("%s: fork failed\n", s);
     3dc:	85d2                	mv	a1,s4
     3de:	00005517          	auipc	a0,0x5
     3e2:	98250513          	addi	a0,a0,-1662 # 4d60 <malloc+0x500>
     3e6:	00004097          	auipc	ra,0x4
     3ea:	3bc080e7          	jalr	956(ra) # 47a2 <printf>
      exit(1);
     3ee:	4505                	li	a0,1
     3f0:	00004097          	auipc	ra,0x4
     3f4:	032080e7          	jalr	50(ra) # 4422 <exit>
        printf("%s: wait wrong pid\n", s);
     3f8:	85d2                	mv	a1,s4
     3fa:	00005517          	auipc	a0,0x5
     3fe:	99650513          	addi	a0,a0,-1642 # 4d90 <malloc+0x530>
     402:	00004097          	auipc	ra,0x4
     406:	3a0080e7          	jalr	928(ra) # 47a2 <printf>
        exit(1);
     40a:	4505                	li	a0,1
     40c:	00004097          	auipc	ra,0x4
     410:	016080e7          	jalr	22(ra) # 4422 <exit>
        printf("%s: wait wrong exit status\n", s);
     414:	85d2                	mv	a1,s4
     416:	00005517          	auipc	a0,0x5
     41a:	99250513          	addi	a0,a0,-1646 # 4da8 <malloc+0x548>
     41e:	00004097          	auipc	ra,0x4
     422:	384080e7          	jalr	900(ra) # 47a2 <printf>
        exit(1);
     426:	4505                	li	a0,1
     428:	00004097          	auipc	ra,0x4
     42c:	ffa080e7          	jalr	-6(ra) # 4422 <exit>
      exit(i);
     430:	854a                	mv	a0,s2
     432:	00004097          	auipc	ra,0x4
     436:	ff0080e7          	jalr	-16(ra) # 4422 <exit>

000000000000043a <twochildren>:
{
     43a:	1101                	addi	sp,sp,-32
     43c:	ec06                	sd	ra,24(sp)
     43e:	e822                	sd	s0,16(sp)
     440:	e426                	sd	s1,8(sp)
     442:	e04a                	sd	s2,0(sp)
     444:	1000                	addi	s0,sp,32
     446:	892a                	mv	s2,a0
     448:	3e800493          	li	s1,1000
    int pid1 = fork();
     44c:	00004097          	auipc	ra,0x4
     450:	fce080e7          	jalr	-50(ra) # 441a <fork>
    if(pid1 < 0){
     454:	02054c63          	bltz	a0,48c <twochildren+0x52>
    if(pid1 == 0){
     458:	c921                	beqz	a0,4a8 <twochildren+0x6e>
      int pid2 = fork();
     45a:	00004097          	auipc	ra,0x4
     45e:	fc0080e7          	jalr	-64(ra) # 441a <fork>
      if(pid2 < 0){
     462:	04054763          	bltz	a0,4b0 <twochildren+0x76>
      if(pid2 == 0){
     466:	c13d                	beqz	a0,4cc <twochildren+0x92>
        wait(0);
     468:	4501                	li	a0,0
     46a:	00004097          	auipc	ra,0x4
     46e:	fc0080e7          	jalr	-64(ra) # 442a <wait>
        wait(0);
     472:	4501                	li	a0,0
     474:	00004097          	auipc	ra,0x4
     478:	fb6080e7          	jalr	-74(ra) # 442a <wait>
  for(int i = 0; i < 1000; i++){
     47c:	34fd                	addiw	s1,s1,-1
     47e:	f4f9                	bnez	s1,44c <twochildren+0x12>
}
     480:	60e2                	ld	ra,24(sp)
     482:	6442                	ld	s0,16(sp)
     484:	64a2                	ld	s1,8(sp)
     486:	6902                	ld	s2,0(sp)
     488:	6105                	addi	sp,sp,32
     48a:	8082                	ret
      printf("%s: fork failed\n", s);
     48c:	85ca                	mv	a1,s2
     48e:	00005517          	auipc	a0,0x5
     492:	8d250513          	addi	a0,a0,-1838 # 4d60 <malloc+0x500>
     496:	00004097          	auipc	ra,0x4
     49a:	30c080e7          	jalr	780(ra) # 47a2 <printf>
      exit(1);
     49e:	4505                	li	a0,1
     4a0:	00004097          	auipc	ra,0x4
     4a4:	f82080e7          	jalr	-126(ra) # 4422 <exit>
      exit(0);
     4a8:	00004097          	auipc	ra,0x4
     4ac:	f7a080e7          	jalr	-134(ra) # 4422 <exit>
        printf("%s: fork failed\n", s);
     4b0:	85ca                	mv	a1,s2
     4b2:	00005517          	auipc	a0,0x5
     4b6:	8ae50513          	addi	a0,a0,-1874 # 4d60 <malloc+0x500>
     4ba:	00004097          	auipc	ra,0x4
     4be:	2e8080e7          	jalr	744(ra) # 47a2 <printf>
        exit(1);
     4c2:	4505                	li	a0,1
     4c4:	00004097          	auipc	ra,0x4
     4c8:	f5e080e7          	jalr	-162(ra) # 4422 <exit>
        exit(0);
     4cc:	00004097          	auipc	ra,0x4
     4d0:	f56080e7          	jalr	-170(ra) # 4422 <exit>

00000000000004d4 <forkfork>:
{
     4d4:	7179                	addi	sp,sp,-48
     4d6:	f406                	sd	ra,40(sp)
     4d8:	f022                	sd	s0,32(sp)
     4da:	ec26                	sd	s1,24(sp)
     4dc:	1800                	addi	s0,sp,48
     4de:	84aa                	mv	s1,a0
    int pid = fork();
     4e0:	00004097          	auipc	ra,0x4
     4e4:	f3a080e7          	jalr	-198(ra) # 441a <fork>
    if(pid < 0){
     4e8:	04054163          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4ec:	cd29                	beqz	a0,546 <forkfork+0x72>
    int pid = fork();
     4ee:	00004097          	auipc	ra,0x4
     4f2:	f2c080e7          	jalr	-212(ra) # 441a <fork>
    if(pid < 0){
     4f6:	02054a63          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4fa:	c531                	beqz	a0,546 <forkfork+0x72>
    wait(&xstatus);
     4fc:	fdc40513          	addi	a0,s0,-36
     500:	00004097          	auipc	ra,0x4
     504:	f2a080e7          	jalr	-214(ra) # 442a <wait>
    if(xstatus != 0) {
     508:	fdc42783          	lw	a5,-36(s0)
     50c:	ebbd                	bnez	a5,582 <forkfork+0xae>
    wait(&xstatus);
     50e:	fdc40513          	addi	a0,s0,-36
     512:	00004097          	auipc	ra,0x4
     516:	f18080e7          	jalr	-232(ra) # 442a <wait>
    if(xstatus != 0) {
     51a:	fdc42783          	lw	a5,-36(s0)
     51e:	e3b5                	bnez	a5,582 <forkfork+0xae>
}
     520:	70a2                	ld	ra,40(sp)
     522:	7402                	ld	s0,32(sp)
     524:	64e2                	ld	s1,24(sp)
     526:	6145                	addi	sp,sp,48
     528:	8082                	ret
      printf("%s: fork failed", s);
     52a:	85a6                	mv	a1,s1
     52c:	00005517          	auipc	a0,0x5
     530:	89c50513          	addi	a0,a0,-1892 # 4dc8 <malloc+0x568>
     534:	00004097          	auipc	ra,0x4
     538:	26e080e7          	jalr	622(ra) # 47a2 <printf>
      exit(1);
     53c:	4505                	li	a0,1
     53e:	00004097          	auipc	ra,0x4
     542:	ee4080e7          	jalr	-284(ra) # 4422 <exit>
{
     546:	0c800493          	li	s1,200
        int pid1 = fork();
     54a:	00004097          	auipc	ra,0x4
     54e:	ed0080e7          	jalr	-304(ra) # 441a <fork>
        if(pid1 < 0){
     552:	00054f63          	bltz	a0,570 <forkfork+0x9c>
        if(pid1 == 0){
     556:	c115                	beqz	a0,57a <forkfork+0xa6>
        wait(0);
     558:	4501                	li	a0,0
     55a:	00004097          	auipc	ra,0x4
     55e:	ed0080e7          	jalr	-304(ra) # 442a <wait>
      for(int j = 0; j < 200; j++){
     562:	34fd                	addiw	s1,s1,-1
     564:	f0fd                	bnez	s1,54a <forkfork+0x76>
      exit(0);
     566:	4501                	li	a0,0
     568:	00004097          	auipc	ra,0x4
     56c:	eba080e7          	jalr	-326(ra) # 4422 <exit>
          exit(1);
     570:	4505                	li	a0,1
     572:	00004097          	auipc	ra,0x4
     576:	eb0080e7          	jalr	-336(ra) # 4422 <exit>
          exit(0);
     57a:	00004097          	auipc	ra,0x4
     57e:	ea8080e7          	jalr	-344(ra) # 4422 <exit>
      printf("%s: fork in child failed", s);
     582:	85a6                	mv	a1,s1
     584:	00005517          	auipc	a0,0x5
     588:	85450513          	addi	a0,a0,-1964 # 4dd8 <malloc+0x578>
     58c:	00004097          	auipc	ra,0x4
     590:	216080e7          	jalr	534(ra) # 47a2 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	00004097          	auipc	ra,0x4
     59a:	e8c080e7          	jalr	-372(ra) # 4422 <exit>

000000000000059e <reparent2>:
{
     59e:	1101                	addi	sp,sp,-32
     5a0:	ec06                	sd	ra,24(sp)
     5a2:	e822                	sd	s0,16(sp)
     5a4:	e426                	sd	s1,8(sp)
     5a6:	1000                	addi	s0,sp,32
     5a8:	32000493          	li	s1,800
    int pid1 = fork();
     5ac:	00004097          	auipc	ra,0x4
     5b0:	e6e080e7          	jalr	-402(ra) # 441a <fork>
    if(pid1 < 0){
     5b4:	00054f63          	bltz	a0,5d2 <reparent2+0x34>
    if(pid1 == 0){
     5b8:	c915                	beqz	a0,5ec <reparent2+0x4e>
    wait(0);
     5ba:	4501                	li	a0,0
     5bc:	00004097          	auipc	ra,0x4
     5c0:	e6e080e7          	jalr	-402(ra) # 442a <wait>
  for(int i = 0; i < 800; i++){
     5c4:	34fd                	addiw	s1,s1,-1
     5c6:	f0fd                	bnez	s1,5ac <reparent2+0xe>
  exit(0);
     5c8:	4501                	li	a0,0
     5ca:	00004097          	auipc	ra,0x4
     5ce:	e58080e7          	jalr	-424(ra) # 4422 <exit>
      printf("fork failed\n");
     5d2:	00005517          	auipc	a0,0x5
     5d6:	08e50513          	addi	a0,a0,142 # 5660 <malloc+0xe00>
     5da:	00004097          	auipc	ra,0x4
     5de:	1c8080e7          	jalr	456(ra) # 47a2 <printf>
      exit(1);
     5e2:	4505                	li	a0,1
     5e4:	00004097          	auipc	ra,0x4
     5e8:	e3e080e7          	jalr	-450(ra) # 4422 <exit>
      fork();
     5ec:	00004097          	auipc	ra,0x4
     5f0:	e2e080e7          	jalr	-466(ra) # 441a <fork>
      fork();
     5f4:	00004097          	auipc	ra,0x4
     5f8:	e26080e7          	jalr	-474(ra) # 441a <fork>
      exit(0);
     5fc:	4501                	li	a0,0
     5fe:	00004097          	auipc	ra,0x4
     602:	e24080e7          	jalr	-476(ra) # 4422 <exit>

0000000000000606 <forktest>:
{
     606:	7179                	addi	sp,sp,-48
     608:	f406                	sd	ra,40(sp)
     60a:	f022                	sd	s0,32(sp)
     60c:	ec26                	sd	s1,24(sp)
     60e:	e84a                	sd	s2,16(sp)
     610:	e44e                	sd	s3,8(sp)
     612:	1800                	addi	s0,sp,48
     614:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     616:	4481                	li	s1,0
     618:	3e800913          	li	s2,1000
    pid = fork();
     61c:	00004097          	auipc	ra,0x4
     620:	dfe080e7          	jalr	-514(ra) # 441a <fork>
    if(pid < 0)
     624:	02054863          	bltz	a0,654 <forktest+0x4e>
    if(pid == 0)
     628:	c115                	beqz	a0,64c <forktest+0x46>
  for(n=0; n<N; n++){
     62a:	2485                	addiw	s1,s1,1
     62c:	ff2498e3          	bne	s1,s2,61c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     630:	85ce                	mv	a1,s3
     632:	00004517          	auipc	a0,0x4
     636:	7de50513          	addi	a0,a0,2014 # 4e10 <malloc+0x5b0>
     63a:	00004097          	auipc	ra,0x4
     63e:	168080e7          	jalr	360(ra) # 47a2 <printf>
    exit(1);
     642:	4505                	li	a0,1
     644:	00004097          	auipc	ra,0x4
     648:	dde080e7          	jalr	-546(ra) # 4422 <exit>
      exit(0);
     64c:	00004097          	auipc	ra,0x4
     650:	dd6080e7          	jalr	-554(ra) # 4422 <exit>
  if (n == 0) {
     654:	cc9d                	beqz	s1,692 <forktest+0x8c>
  if(n == N){
     656:	3e800793          	li	a5,1000
     65a:	fcf48be3          	beq	s1,a5,630 <forktest+0x2a>
  for(; n > 0; n--){
     65e:	00905b63          	blez	s1,674 <forktest+0x6e>
    if(wait(0) < 0){
     662:	4501                	li	a0,0
     664:	00004097          	auipc	ra,0x4
     668:	dc6080e7          	jalr	-570(ra) # 442a <wait>
     66c:	04054163          	bltz	a0,6ae <forktest+0xa8>
  for(; n > 0; n--){
     670:	34fd                	addiw	s1,s1,-1
     672:	f8e5                	bnez	s1,662 <forktest+0x5c>
  if(wait(0) != -1){
     674:	4501                	li	a0,0
     676:	00004097          	auipc	ra,0x4
     67a:	db4080e7          	jalr	-588(ra) # 442a <wait>
     67e:	57fd                	li	a5,-1
     680:	04f51563          	bne	a0,a5,6ca <forktest+0xc4>
}
     684:	70a2                	ld	ra,40(sp)
     686:	7402                	ld	s0,32(sp)
     688:	64e2                	ld	s1,24(sp)
     68a:	6942                	ld	s2,16(sp)
     68c:	69a2                	ld	s3,8(sp)
     68e:	6145                	addi	sp,sp,48
     690:	8082                	ret
    printf("%s: no fork at all!\n", s);
     692:	85ce                	mv	a1,s3
     694:	00004517          	auipc	a0,0x4
     698:	76450513          	addi	a0,a0,1892 # 4df8 <malloc+0x598>
     69c:	00004097          	auipc	ra,0x4
     6a0:	106080e7          	jalr	262(ra) # 47a2 <printf>
    exit(1);
     6a4:	4505                	li	a0,1
     6a6:	00004097          	auipc	ra,0x4
     6aa:	d7c080e7          	jalr	-644(ra) # 4422 <exit>
      printf("%s: wait stopped early\n", s);
     6ae:	85ce                	mv	a1,s3
     6b0:	00004517          	auipc	a0,0x4
     6b4:	78850513          	addi	a0,a0,1928 # 4e38 <malloc+0x5d8>
     6b8:	00004097          	auipc	ra,0x4
     6bc:	0ea080e7          	jalr	234(ra) # 47a2 <printf>
      exit(1);
     6c0:	4505                	li	a0,1
     6c2:	00004097          	auipc	ra,0x4
     6c6:	d60080e7          	jalr	-672(ra) # 4422 <exit>
    printf("%s: wait got too many\n", s);
     6ca:	85ce                	mv	a1,s3
     6cc:	00004517          	auipc	a0,0x4
     6d0:	78450513          	addi	a0,a0,1924 # 4e50 <malloc+0x5f0>
     6d4:	00004097          	auipc	ra,0x4
     6d8:	0ce080e7          	jalr	206(ra) # 47a2 <printf>
    exit(1);
     6dc:	4505                	li	a0,1
     6de:	00004097          	auipc	ra,0x4
     6e2:	d44080e7          	jalr	-700(ra) # 4422 <exit>

00000000000006e6 <kernmem>:
{
     6e6:	715d                	addi	sp,sp,-80
     6e8:	e486                	sd	ra,72(sp)
     6ea:	e0a2                	sd	s0,64(sp)
     6ec:	fc26                	sd	s1,56(sp)
     6ee:	f84a                	sd	s2,48(sp)
     6f0:	f44e                	sd	s3,40(sp)
     6f2:	f052                	sd	s4,32(sp)
     6f4:	ec56                	sd	s5,24(sp)
     6f6:	0880                	addi	s0,sp,80
     6f8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     6fa:	4485                	li	s1,1
     6fc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
     6fe:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     700:	69b1                	lui	s3,0xc
     702:	35098993          	addi	s3,s3,848 # c350 <__BSS_END__+0x110>
     706:	1003d937          	lui	s2,0x1003d
     70a:	090e                	slli	s2,s2,0x3
     70c:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x10031240>
    pid = fork();
     710:	00004097          	auipc	ra,0x4
     714:	d0a080e7          	jalr	-758(ra) # 441a <fork>
    if(pid < 0){
     718:	02054963          	bltz	a0,74a <kernmem+0x64>
    if(pid == 0){
     71c:	c529                	beqz	a0,766 <kernmem+0x80>
    wait(&xstatus);
     71e:	fbc40513          	addi	a0,s0,-68
     722:	00004097          	auipc	ra,0x4
     726:	d08080e7          	jalr	-760(ra) # 442a <wait>
    if(xstatus != -1)  // did kernel kill child?
     72a:	fbc42783          	lw	a5,-68(s0)
     72e:	05579c63          	bne	a5,s5,786 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     732:	94ce                	add	s1,s1,s3
     734:	fd249ee3          	bne	s1,s2,710 <kernmem+0x2a>
}
     738:	60a6                	ld	ra,72(sp)
     73a:	6406                	ld	s0,64(sp)
     73c:	74e2                	ld	s1,56(sp)
     73e:	7942                	ld	s2,48(sp)
     740:	79a2                	ld	s3,40(sp)
     742:	7a02                	ld	s4,32(sp)
     744:	6ae2                	ld	s5,24(sp)
     746:	6161                	addi	sp,sp,80
     748:	8082                	ret
      printf("%s: fork failed\n", s);
     74a:	85d2                	mv	a1,s4
     74c:	00004517          	auipc	a0,0x4
     750:	61450513          	addi	a0,a0,1556 # 4d60 <malloc+0x500>
     754:	00004097          	auipc	ra,0x4
     758:	04e080e7          	jalr	78(ra) # 47a2 <printf>
      exit(1);
     75c:	4505                	li	a0,1
     75e:	00004097          	auipc	ra,0x4
     762:	cc4080e7          	jalr	-828(ra) # 4422 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
     766:	0004c603          	lbu	a2,0(s1)
     76a:	85a6                	mv	a1,s1
     76c:	00004517          	auipc	a0,0x4
     770:	6fc50513          	addi	a0,a0,1788 # 4e68 <malloc+0x608>
     774:	00004097          	auipc	ra,0x4
     778:	02e080e7          	jalr	46(ra) # 47a2 <printf>
      exit(1);
     77c:	4505                	li	a0,1
     77e:	00004097          	auipc	ra,0x4
     782:	ca4080e7          	jalr	-860(ra) # 4422 <exit>
      exit(1);
     786:	4505                	li	a0,1
     788:	00004097          	auipc	ra,0x4
     78c:	c9a080e7          	jalr	-870(ra) # 4422 <exit>

0000000000000790 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
     790:	7179                	addi	sp,sp,-48
     792:	f406                	sd	ra,40(sp)
     794:	f022                	sd	s0,32(sp)
     796:	ec26                	sd	s1,24(sp)
     798:	1800                	addi	s0,sp,48
     79a:	84aa                	mv	s1,a0
  int pid;
  int xstatus;
  
  pid = fork();
     79c:	00004097          	auipc	ra,0x4
     7a0:	c7e080e7          	jalr	-898(ra) # 441a <fork>
  if(pid == 0) {
     7a4:	c115                	beqz	a0,7c8 <stacktest+0x38>
    char *sp = (char *) r_sp();
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", *sp);
    exit(1);
  } else if(pid < 0){
     7a6:	04054363          	bltz	a0,7ec <stacktest+0x5c>
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
     7aa:	fdc40513          	addi	a0,s0,-36
     7ae:	00004097          	auipc	ra,0x4
     7b2:	c7c080e7          	jalr	-900(ra) # 442a <wait>
  if(xstatus == -1)  // kernel killed child?
     7b6:	fdc42503          	lw	a0,-36(s0)
     7ba:	57fd                	li	a5,-1
     7bc:	04f50663          	beq	a0,a5,808 <stacktest+0x78>
    exit(0);
  else
    exit(xstatus);
     7c0:	00004097          	auipc	ra,0x4
     7c4:	c62080e7          	jalr	-926(ra) # 4422 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
     7c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
     7ca:	77fd                	lui	a5,0xfffff
     7cc:	97ba                	add	a5,a5,a4
     7ce:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff2dc0>
     7d2:	00004517          	auipc	a0,0x4
     7d6:	6b650513          	addi	a0,a0,1718 # 4e88 <malloc+0x628>
     7da:	00004097          	auipc	ra,0x4
     7de:	fc8080e7          	jalr	-56(ra) # 47a2 <printf>
    exit(1);
     7e2:	4505                	li	a0,1
     7e4:	00004097          	auipc	ra,0x4
     7e8:	c3e080e7          	jalr	-962(ra) # 4422 <exit>
    printf("%s: fork failed\n", s);
     7ec:	85a6                	mv	a1,s1
     7ee:	00004517          	auipc	a0,0x4
     7f2:	57250513          	addi	a0,a0,1394 # 4d60 <malloc+0x500>
     7f6:	00004097          	auipc	ra,0x4
     7fa:	fac080e7          	jalr	-84(ra) # 47a2 <printf>
    exit(1);
     7fe:	4505                	li	a0,1
     800:	00004097          	auipc	ra,0x4
     804:	c22080e7          	jalr	-990(ra) # 4422 <exit>
    exit(0);
     808:	4501                	li	a0,0
     80a:	00004097          	auipc	ra,0x4
     80e:	c18080e7          	jalr	-1000(ra) # 4422 <exit>

0000000000000812 <openiputtest>:
{
     812:	7179                	addi	sp,sp,-48
     814:	f406                	sd	ra,40(sp)
     816:	f022                	sd	s0,32(sp)
     818:	ec26                	sd	s1,24(sp)
     81a:	1800                	addi	s0,sp,48
     81c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
     81e:	00004517          	auipc	a0,0x4
     822:	69250513          	addi	a0,a0,1682 # 4eb0 <malloc+0x650>
     826:	00004097          	auipc	ra,0x4
     82a:	c64080e7          	jalr	-924(ra) # 448a <mkdir>
     82e:	04054263          	bltz	a0,872 <openiputtest+0x60>
  pid = fork();
     832:	00004097          	auipc	ra,0x4
     836:	be8080e7          	jalr	-1048(ra) # 441a <fork>
  if(pid < 0){
     83a:	04054a63          	bltz	a0,88e <openiputtest+0x7c>
  if(pid == 0){
     83e:	e93d                	bnez	a0,8b4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
     840:	4589                	li	a1,2
     842:	00004517          	auipc	a0,0x4
     846:	66e50513          	addi	a0,a0,1646 # 4eb0 <malloc+0x650>
     84a:	00004097          	auipc	ra,0x4
     84e:	c18080e7          	jalr	-1000(ra) # 4462 <open>
    if(fd >= 0){
     852:	04054c63          	bltz	a0,8aa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
     856:	85a6                	mv	a1,s1
     858:	00004517          	auipc	a0,0x4
     85c:	67850513          	addi	a0,a0,1656 # 4ed0 <malloc+0x670>
     860:	00004097          	auipc	ra,0x4
     864:	f42080e7          	jalr	-190(ra) # 47a2 <printf>
      exit(1);
     868:	4505                	li	a0,1
     86a:	00004097          	auipc	ra,0x4
     86e:	bb8080e7          	jalr	-1096(ra) # 4422 <exit>
    printf("%s: mkdir oidir failed\n", s);
     872:	85a6                	mv	a1,s1
     874:	00004517          	auipc	a0,0x4
     878:	64450513          	addi	a0,a0,1604 # 4eb8 <malloc+0x658>
     87c:	00004097          	auipc	ra,0x4
     880:	f26080e7          	jalr	-218(ra) # 47a2 <printf>
    exit(1);
     884:	4505                	li	a0,1
     886:	00004097          	auipc	ra,0x4
     88a:	b9c080e7          	jalr	-1124(ra) # 4422 <exit>
    printf("%s: fork failed\n", s);
     88e:	85a6                	mv	a1,s1
     890:	00004517          	auipc	a0,0x4
     894:	4d050513          	addi	a0,a0,1232 # 4d60 <malloc+0x500>
     898:	00004097          	auipc	ra,0x4
     89c:	f0a080e7          	jalr	-246(ra) # 47a2 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00004097          	auipc	ra,0x4
     8a6:	b80080e7          	jalr	-1152(ra) # 4422 <exit>
    exit(0);
     8aa:	4501                	li	a0,0
     8ac:	00004097          	auipc	ra,0x4
     8b0:	b76080e7          	jalr	-1162(ra) # 4422 <exit>
  sleep(1);
     8b4:	4505                	li	a0,1
     8b6:	00004097          	auipc	ra,0x4
     8ba:	bfc080e7          	jalr	-1028(ra) # 44b2 <sleep>
  if(unlink("oidir") != 0){
     8be:	00004517          	auipc	a0,0x4
     8c2:	5f250513          	addi	a0,a0,1522 # 4eb0 <malloc+0x650>
     8c6:	00004097          	auipc	ra,0x4
     8ca:	bac080e7          	jalr	-1108(ra) # 4472 <unlink>
     8ce:	cd19                	beqz	a0,8ec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
     8d0:	85a6                	mv	a1,s1
     8d2:	00004517          	auipc	a0,0x4
     8d6:	62650513          	addi	a0,a0,1574 # 4ef8 <malloc+0x698>
     8da:	00004097          	auipc	ra,0x4
     8de:	ec8080e7          	jalr	-312(ra) # 47a2 <printf>
    exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00004097          	auipc	ra,0x4
     8e8:	b3e080e7          	jalr	-1218(ra) # 4422 <exit>
  wait(&xstatus);
     8ec:	fdc40513          	addi	a0,s0,-36
     8f0:	00004097          	auipc	ra,0x4
     8f4:	b3a080e7          	jalr	-1222(ra) # 442a <wait>
  exit(xstatus);
     8f8:	fdc42503          	lw	a0,-36(s0)
     8fc:	00004097          	auipc	ra,0x4
     900:	b26080e7          	jalr	-1242(ra) # 4422 <exit>

0000000000000904 <opentest>:
{
     904:	1101                	addi	sp,sp,-32
     906:	ec06                	sd	ra,24(sp)
     908:	e822                	sd	s0,16(sp)
     90a:	e426                	sd	s1,8(sp)
     90c:	1000                	addi	s0,sp,32
     90e:	84aa                	mv	s1,a0
  fd = open("echo", 0);
     910:	4581                	li	a1,0
     912:	00004517          	auipc	a0,0x4
     916:	5fe50513          	addi	a0,a0,1534 # 4f10 <malloc+0x6b0>
     91a:	00004097          	auipc	ra,0x4
     91e:	b48080e7          	jalr	-1208(ra) # 4462 <open>
  if(fd < 0){
     922:	02054663          	bltz	a0,94e <opentest+0x4a>
  close(fd);
     926:	00004097          	auipc	ra,0x4
     92a:	b24080e7          	jalr	-1244(ra) # 444a <close>
  fd = open("doesnotexist", 0);
     92e:	4581                	li	a1,0
     930:	00004517          	auipc	a0,0x4
     934:	60050513          	addi	a0,a0,1536 # 4f30 <malloc+0x6d0>
     938:	00004097          	auipc	ra,0x4
     93c:	b2a080e7          	jalr	-1238(ra) # 4462 <open>
  if(fd >= 0){
     940:	02055563          	bgez	a0,96a <opentest+0x66>
}
     944:	60e2                	ld	ra,24(sp)
     946:	6442                	ld	s0,16(sp)
     948:	64a2                	ld	s1,8(sp)
     94a:	6105                	addi	sp,sp,32
     94c:	8082                	ret
    printf("%s: open echo failed!\n", s);
     94e:	85a6                	mv	a1,s1
     950:	00004517          	auipc	a0,0x4
     954:	5c850513          	addi	a0,a0,1480 # 4f18 <malloc+0x6b8>
     958:	00004097          	auipc	ra,0x4
     95c:	e4a080e7          	jalr	-438(ra) # 47a2 <printf>
    exit(1);
     960:	4505                	li	a0,1
     962:	00004097          	auipc	ra,0x4
     966:	ac0080e7          	jalr	-1344(ra) # 4422 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     96a:	85a6                	mv	a1,s1
     96c:	00004517          	auipc	a0,0x4
     970:	5d450513          	addi	a0,a0,1492 # 4f40 <malloc+0x6e0>
     974:	00004097          	auipc	ra,0x4
     978:	e2e080e7          	jalr	-466(ra) # 47a2 <printf>
    exit(1);
     97c:	4505                	li	a0,1
     97e:	00004097          	auipc	ra,0x4
     982:	aa4080e7          	jalr	-1372(ra) # 4422 <exit>

0000000000000986 <createtest>:
{
     986:	7179                	addi	sp,sp,-48
     988:	f406                	sd	ra,40(sp)
     98a:	f022                	sd	s0,32(sp)
     98c:	ec26                	sd	s1,24(sp)
     98e:	e84a                	sd	s2,16(sp)
     990:	e44e                	sd	s3,8(sp)
     992:	1800                	addi	s0,sp,48
  name[0] = 'a';
     994:	00006797          	auipc	a5,0x6
     998:	07c78793          	addi	a5,a5,124 # 6a10 <name>
     99c:	06100713          	li	a4,97
     9a0:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9a4:	00078123          	sb	zero,2(a5)
     9a8:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ac:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9ae:	06400993          	li	s3,100
    name[1] = '0' + i;
     9b2:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     9b6:	20200593          	li	a1,514
     9ba:	854a                	mv	a0,s2
     9bc:	00004097          	auipc	ra,0x4
     9c0:	aa6080e7          	jalr	-1370(ra) # 4462 <open>
    close(fd);
     9c4:	00004097          	auipc	ra,0x4
     9c8:	a86080e7          	jalr	-1402(ra) # 444a <close>
  for(i = 0; i < N; i++){
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0ff4f493          	andi	s1,s1,255
     9d2:	ff3490e3          	bne	s1,s3,9b2 <createtest+0x2c>
  name[0] = 'a';
     9d6:	00006797          	auipc	a5,0x6
     9da:	03a78793          	addi	a5,a5,58 # 6a10 <name>
     9de:	06100713          	li	a4,97
     9e2:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9e6:	00078123          	sb	zero,2(a5)
     9ea:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ee:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9f0:	06400993          	li	s3,100
    name[1] = '0' + i;
     9f4:	009900a3          	sb	s1,1(s2)
    unlink(name);
     9f8:	854a                	mv	a0,s2
     9fa:	00004097          	auipc	ra,0x4
     9fe:	a78080e7          	jalr	-1416(ra) # 4472 <unlink>
  for(i = 0; i < N; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	0ff4f493          	andi	s1,s1,255
     a08:	ff3496e3          	bne	s1,s3,9f4 <createtest+0x6e>
}
     a0c:	70a2                	ld	ra,40(sp)
     a0e:	7402                	ld	s0,32(sp)
     a10:	64e2                	ld	s1,24(sp)
     a12:	6942                	ld	s2,16(sp)
     a14:	69a2                	ld	s3,8(sp)
     a16:	6145                	addi	sp,sp,48
     a18:	8082                	ret

0000000000000a1a <forkforkfork>:
{
     a1a:	1101                	addi	sp,sp,-32
     a1c:	ec06                	sd	ra,24(sp)
     a1e:	e822                	sd	s0,16(sp)
     a20:	e426                	sd	s1,8(sp)
     a22:	1000                	addi	s0,sp,32
     a24:	84aa                	mv	s1,a0
  unlink("stopforking");
     a26:	00004517          	auipc	a0,0x4
     a2a:	54250513          	addi	a0,a0,1346 # 4f68 <malloc+0x708>
     a2e:	00004097          	auipc	ra,0x4
     a32:	a44080e7          	jalr	-1468(ra) # 4472 <unlink>
  int pid = fork();
     a36:	00004097          	auipc	ra,0x4
     a3a:	9e4080e7          	jalr	-1564(ra) # 441a <fork>
  if(pid < 0){
     a3e:	04054563          	bltz	a0,a88 <forkforkfork+0x6e>
  if(pid == 0){
     a42:	c12d                	beqz	a0,aa4 <forkforkfork+0x8a>
  sleep(20); // two seconds
     a44:	4551                	li	a0,20
     a46:	00004097          	auipc	ra,0x4
     a4a:	a6c080e7          	jalr	-1428(ra) # 44b2 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     a4e:	20200593          	li	a1,514
     a52:	00004517          	auipc	a0,0x4
     a56:	51650513          	addi	a0,a0,1302 # 4f68 <malloc+0x708>
     a5a:	00004097          	auipc	ra,0x4
     a5e:	a08080e7          	jalr	-1528(ra) # 4462 <open>
     a62:	00004097          	auipc	ra,0x4
     a66:	9e8080e7          	jalr	-1560(ra) # 444a <close>
  wait(0);
     a6a:	4501                	li	a0,0
     a6c:	00004097          	auipc	ra,0x4
     a70:	9be080e7          	jalr	-1602(ra) # 442a <wait>
  sleep(10); // one second
     a74:	4529                	li	a0,10
     a76:	00004097          	auipc	ra,0x4
     a7a:	a3c080e7          	jalr	-1476(ra) # 44b2 <sleep>
}
     a7e:	60e2                	ld	ra,24(sp)
     a80:	6442                	ld	s0,16(sp)
     a82:	64a2                	ld	s1,8(sp)
     a84:	6105                	addi	sp,sp,32
     a86:	8082                	ret
    printf("%s: fork failed", s);
     a88:	85a6                	mv	a1,s1
     a8a:	00004517          	auipc	a0,0x4
     a8e:	33e50513          	addi	a0,a0,830 # 4dc8 <malloc+0x568>
     a92:	00004097          	auipc	ra,0x4
     a96:	d10080e7          	jalr	-752(ra) # 47a2 <printf>
    exit(1);
     a9a:	4505                	li	a0,1
     a9c:	00004097          	auipc	ra,0x4
     aa0:	986080e7          	jalr	-1658(ra) # 4422 <exit>
      int fd = open("stopforking", 0);
     aa4:	00004497          	auipc	s1,0x4
     aa8:	4c448493          	addi	s1,s1,1220 # 4f68 <malloc+0x708>
     aac:	4581                	li	a1,0
     aae:	8526                	mv	a0,s1
     ab0:	00004097          	auipc	ra,0x4
     ab4:	9b2080e7          	jalr	-1614(ra) # 4462 <open>
      if(fd >= 0){
     ab8:	02055463          	bgez	a0,ae0 <forkforkfork+0xc6>
      if(fork() < 0){
     abc:	00004097          	auipc	ra,0x4
     ac0:	95e080e7          	jalr	-1698(ra) # 441a <fork>
     ac4:	fe0554e3          	bgez	a0,aac <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
     ac8:	20200593          	li	a1,514
     acc:	8526                	mv	a0,s1
     ace:	00004097          	auipc	ra,0x4
     ad2:	994080e7          	jalr	-1644(ra) # 4462 <open>
     ad6:	00004097          	auipc	ra,0x4
     ada:	974080e7          	jalr	-1676(ra) # 444a <close>
     ade:	b7f9                	j	aac <forkforkfork+0x92>
        exit(0);
     ae0:	4501                	li	a0,0
     ae2:	00004097          	auipc	ra,0x4
     ae6:	940080e7          	jalr	-1728(ra) # 4422 <exit>

0000000000000aea <createdelete>:
{
     aea:	7175                	addi	sp,sp,-144
     aec:	e506                	sd	ra,136(sp)
     aee:	e122                	sd	s0,128(sp)
     af0:	fca6                	sd	s1,120(sp)
     af2:	f8ca                	sd	s2,112(sp)
     af4:	f4ce                	sd	s3,104(sp)
     af6:	f0d2                	sd	s4,96(sp)
     af8:	ecd6                	sd	s5,88(sp)
     afa:	e8da                	sd	s6,80(sp)
     afc:	e4de                	sd	s7,72(sp)
     afe:	e0e2                	sd	s8,64(sp)
     b00:	fc66                	sd	s9,56(sp)
     b02:	0900                	addi	s0,sp,144
     b04:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
     b06:	4901                	li	s2,0
     b08:	4991                	li	s3,4
    pid = fork();
     b0a:	00004097          	auipc	ra,0x4
     b0e:	910080e7          	jalr	-1776(ra) # 441a <fork>
     b12:	84aa                	mv	s1,a0
    if(pid < 0){
     b14:	02054f63          	bltz	a0,b52 <createdelete+0x68>
    if(pid == 0){
     b18:	c939                	beqz	a0,b6e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
     b1a:	2905                	addiw	s2,s2,1
     b1c:	ff3917e3          	bne	s2,s3,b0a <createdelete+0x20>
     b20:	4491                	li	s1,4
    wait(&xstatus);
     b22:	f7c40513          	addi	a0,s0,-132
     b26:	00004097          	auipc	ra,0x4
     b2a:	904080e7          	jalr	-1788(ra) # 442a <wait>
    if(xstatus != 0)
     b2e:	f7c42903          	lw	s2,-132(s0)
     b32:	0e091263          	bnez	s2,c16 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
     b36:	34fd                	addiw	s1,s1,-1
     b38:	f4ed                	bnez	s1,b22 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
     b3a:	f8040123          	sb	zero,-126(s0)
     b3e:	03000993          	li	s3,48
     b42:	5a7d                	li	s4,-1
     b44:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
     b48:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
     b4a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
     b4c:	07400a93          	li	s5,116
     b50:	a29d                	j	cb6 <createdelete+0x1cc>
      printf("fork failed\n", s);
     b52:	85e6                	mv	a1,s9
     b54:	00005517          	auipc	a0,0x5
     b58:	b0c50513          	addi	a0,a0,-1268 # 5660 <malloc+0xe00>
     b5c:	00004097          	auipc	ra,0x4
     b60:	c46080e7          	jalr	-954(ra) # 47a2 <printf>
      exit(1);
     b64:	4505                	li	a0,1
     b66:	00004097          	auipc	ra,0x4
     b6a:	8bc080e7          	jalr	-1860(ra) # 4422 <exit>
      name[0] = 'p' + pi;
     b6e:	0709091b          	addiw	s2,s2,112
     b72:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
     b76:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
     b7a:	4951                	li	s2,20
     b7c:	a015                	j	ba0 <createdelete+0xb6>
          printf("%s: create failed\n", s);
     b7e:	85e6                	mv	a1,s9
     b80:	00004517          	auipc	a0,0x4
     b84:	3f850513          	addi	a0,a0,1016 # 4f78 <malloc+0x718>
     b88:	00004097          	auipc	ra,0x4
     b8c:	c1a080e7          	jalr	-998(ra) # 47a2 <printf>
          exit(1);
     b90:	4505                	li	a0,1
     b92:	00004097          	auipc	ra,0x4
     b96:	890080e7          	jalr	-1904(ra) # 4422 <exit>
      for(i = 0; i < N; i++){
     b9a:	2485                	addiw	s1,s1,1
     b9c:	07248863          	beq	s1,s2,c0c <createdelete+0x122>
        name[1] = '0' + i;
     ba0:	0304879b          	addiw	a5,s1,48
     ba4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
     ba8:	20200593          	li	a1,514
     bac:	f8040513          	addi	a0,s0,-128
     bb0:	00004097          	auipc	ra,0x4
     bb4:	8b2080e7          	jalr	-1870(ra) # 4462 <open>
        if(fd < 0){
     bb8:	fc0543e3          	bltz	a0,b7e <createdelete+0x94>
        close(fd);
     bbc:	00004097          	auipc	ra,0x4
     bc0:	88e080e7          	jalr	-1906(ra) # 444a <close>
        if(i > 0 && (i % 2 ) == 0){
     bc4:	fc905be3          	blez	s1,b9a <createdelete+0xb0>
     bc8:	0014f793          	andi	a5,s1,1
     bcc:	f7f9                	bnez	a5,b9a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
     bce:	01f4d79b          	srliw	a5,s1,0x1f
     bd2:	9fa5                	addw	a5,a5,s1
     bd4:	4017d79b          	sraiw	a5,a5,0x1
     bd8:	0307879b          	addiw	a5,a5,48
     bdc:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
     be0:	f8040513          	addi	a0,s0,-128
     be4:	00004097          	auipc	ra,0x4
     be8:	88e080e7          	jalr	-1906(ra) # 4472 <unlink>
     bec:	fa0557e3          	bgez	a0,b9a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
     bf0:	85e6                	mv	a1,s9
     bf2:	00004517          	auipc	a0,0x4
     bf6:	30650513          	addi	a0,a0,774 # 4ef8 <malloc+0x698>
     bfa:	00004097          	auipc	ra,0x4
     bfe:	ba8080e7          	jalr	-1112(ra) # 47a2 <printf>
            exit(1);
     c02:	4505                	li	a0,1
     c04:	00004097          	auipc	ra,0x4
     c08:	81e080e7          	jalr	-2018(ra) # 4422 <exit>
      exit(0);
     c0c:	4501                	li	a0,0
     c0e:	00004097          	auipc	ra,0x4
     c12:	814080e7          	jalr	-2028(ra) # 4422 <exit>
      exit(1);
     c16:	4505                	li	a0,1
     c18:	00004097          	auipc	ra,0x4
     c1c:	80a080e7          	jalr	-2038(ra) # 4422 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
     c20:	f8040613          	addi	a2,s0,-128
     c24:	85e6                	mv	a1,s9
     c26:	00004517          	auipc	a0,0x4
     c2a:	36a50513          	addi	a0,a0,874 # 4f90 <malloc+0x730>
     c2e:	00004097          	auipc	ra,0x4
     c32:	b74080e7          	jalr	-1164(ra) # 47a2 <printf>
        exit(1);
     c36:	4505                	li	a0,1
     c38:	00003097          	auipc	ra,0x3
     c3c:	7ea080e7          	jalr	2026(ra) # 4422 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c40:	054b7163          	bgeu	s6,s4,c82 <createdelete+0x198>
      if(fd >= 0)
     c44:	02055a63          	bgez	a0,c78 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
     c48:	2485                	addiw	s1,s1,1
     c4a:	0ff4f493          	andi	s1,s1,255
     c4e:	05548c63          	beq	s1,s5,ca6 <createdelete+0x1bc>
      name[0] = 'p' + pi;
     c52:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
     c56:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
     c5a:	4581                	li	a1,0
     c5c:	f8040513          	addi	a0,s0,-128
     c60:	00004097          	auipc	ra,0x4
     c64:	802080e7          	jalr	-2046(ra) # 4462 <open>
      if((i == 0 || i >= N/2) && fd < 0){
     c68:	00090463          	beqz	s2,c70 <createdelete+0x186>
     c6c:	fd2bdae3          	bge	s7,s2,c40 <createdelete+0x156>
     c70:	fa0548e3          	bltz	a0,c20 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c74:	014b7963          	bgeu	s6,s4,c86 <createdelete+0x19c>
        close(fd);
     c78:	00003097          	auipc	ra,0x3
     c7c:	7d2080e7          	jalr	2002(ra) # 444a <close>
     c80:	b7e1                	j	c48 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c82:	fc0543e3          	bltz	a0,c48 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
     c86:	f8040613          	addi	a2,s0,-128
     c8a:	85e6                	mv	a1,s9
     c8c:	00004517          	auipc	a0,0x4
     c90:	32c50513          	addi	a0,a0,812 # 4fb8 <malloc+0x758>
     c94:	00004097          	auipc	ra,0x4
     c98:	b0e080e7          	jalr	-1266(ra) # 47a2 <printf>
        exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00003097          	auipc	ra,0x3
     ca2:	784080e7          	jalr	1924(ra) # 4422 <exit>
  for(i = 0; i < N; i++){
     ca6:	2905                	addiw	s2,s2,1
     ca8:	2a05                	addiw	s4,s4,1
     caa:	2985                	addiw	s3,s3,1
     cac:	0ff9f993          	andi	s3,s3,255
     cb0:	47d1                	li	a5,20
     cb2:	02f90a63          	beq	s2,a5,ce6 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
     cb6:	84e2                	mv	s1,s8
     cb8:	bf69                	j	c52 <createdelete+0x168>
  for(i = 0; i < N; i++){
     cba:	2905                	addiw	s2,s2,1
     cbc:	0ff97913          	andi	s2,s2,255
     cc0:	2985                	addiw	s3,s3,1
     cc2:	0ff9f993          	andi	s3,s3,255
     cc6:	03490863          	beq	s2,s4,cf6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
     cca:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
     ccc:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
     cd0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
     cd4:	f8040513          	addi	a0,s0,-128
     cd8:	00003097          	auipc	ra,0x3
     cdc:	79a080e7          	jalr	1946(ra) # 4472 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
     ce0:	34fd                	addiw	s1,s1,-1
     ce2:	f4ed                	bnez	s1,ccc <createdelete+0x1e2>
     ce4:	bfd9                	j	cba <createdelete+0x1d0>
     ce6:	03000993          	li	s3,48
     cea:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
     cee:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
     cf0:	08400a13          	li	s4,132
     cf4:	bfd9                	j	cca <createdelete+0x1e0>
}
     cf6:	60aa                	ld	ra,136(sp)
     cf8:	640a                	ld	s0,128(sp)
     cfa:	74e6                	ld	s1,120(sp)
     cfc:	7946                	ld	s2,112(sp)
     cfe:	79a6                	ld	s3,104(sp)
     d00:	7a06                	ld	s4,96(sp)
     d02:	6ae6                	ld	s5,88(sp)
     d04:	6b46                	ld	s6,80(sp)
     d06:	6ba6                	ld	s7,72(sp)
     d08:	6c06                	ld	s8,64(sp)
     d0a:	7ce2                	ld	s9,56(sp)
     d0c:	6149                	addi	sp,sp,144
     d0e:	8082                	ret

0000000000000d10 <fourteen>:
{
     d10:	1101                	addi	sp,sp,-32
     d12:	ec06                	sd	ra,24(sp)
     d14:	e822                	sd	s0,16(sp)
     d16:	e426                	sd	s1,8(sp)
     d18:	1000                	addi	s0,sp,32
     d1a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
     d1c:	00004517          	auipc	a0,0x4
     d20:	49450513          	addi	a0,a0,1172 # 51b0 <malloc+0x950>
     d24:	00003097          	auipc	ra,0x3
     d28:	766080e7          	jalr	1894(ra) # 448a <mkdir>
     d2c:	e141                	bnez	a0,dac <fourteen+0x9c>
  if(mkdir("12345678901234/123456789012345") != 0){
     d2e:	00004517          	auipc	a0,0x4
     d32:	2da50513          	addi	a0,a0,730 # 5008 <malloc+0x7a8>
     d36:	00003097          	auipc	ra,0x3
     d3a:	754080e7          	jalr	1876(ra) # 448a <mkdir>
     d3e:	e549                	bnez	a0,dc8 <fourteen+0xb8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     d40:	20000593          	li	a1,512
     d44:	00004517          	auipc	a0,0x4
     d48:	31c50513          	addi	a0,a0,796 # 5060 <malloc+0x800>
     d4c:	00003097          	auipc	ra,0x3
     d50:	716080e7          	jalr	1814(ra) # 4462 <open>
  if(fd < 0){
     d54:	08054863          	bltz	a0,de4 <fourteen+0xd4>
  close(fd);
     d58:	00003097          	auipc	ra,0x3
     d5c:	6f2080e7          	jalr	1778(ra) # 444a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     d60:	4581                	li	a1,0
     d62:	00004517          	auipc	a0,0x4
     d66:	37650513          	addi	a0,a0,886 # 50d8 <malloc+0x878>
     d6a:	00003097          	auipc	ra,0x3
     d6e:	6f8080e7          	jalr	1784(ra) # 4462 <open>
  if(fd < 0){
     d72:	08054763          	bltz	a0,e00 <fourteen+0xf0>
  close(fd);
     d76:	00003097          	auipc	ra,0x3
     d7a:	6d4080e7          	jalr	1748(ra) # 444a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
     d7e:	00004517          	auipc	a0,0x4
     d82:	3ca50513          	addi	a0,a0,970 # 5148 <malloc+0x8e8>
     d86:	00003097          	auipc	ra,0x3
     d8a:	704080e7          	jalr	1796(ra) # 448a <mkdir>
     d8e:	c559                	beqz	a0,e1c <fourteen+0x10c>
  if(mkdir("123456789012345/12345678901234") == 0){
     d90:	00004517          	auipc	a0,0x4
     d94:	41050513          	addi	a0,a0,1040 # 51a0 <malloc+0x940>
     d98:	00003097          	auipc	ra,0x3
     d9c:	6f2080e7          	jalr	1778(ra) # 448a <mkdir>
     da0:	cd41                	beqz	a0,e38 <fourteen+0x128>
}
     da2:	60e2                	ld	ra,24(sp)
     da4:	6442                	ld	s0,16(sp)
     da6:	64a2                	ld	s1,8(sp)
     da8:	6105                	addi	sp,sp,32
     daa:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
     dac:	85a6                	mv	a1,s1
     dae:	00004517          	auipc	a0,0x4
     db2:	23250513          	addi	a0,a0,562 # 4fe0 <malloc+0x780>
     db6:	00004097          	auipc	ra,0x4
     dba:	9ec080e7          	jalr	-1556(ra) # 47a2 <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	00003097          	auipc	ra,0x3
     dc4:	662080e7          	jalr	1634(ra) # 4422 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
     dc8:	85a6                	mv	a1,s1
     dca:	00004517          	auipc	a0,0x4
     dce:	25e50513          	addi	a0,a0,606 # 5028 <malloc+0x7c8>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	9d0080e7          	jalr	-1584(ra) # 47a2 <printf>
    exit(1);
     dda:	4505                	li	a0,1
     ddc:	00003097          	auipc	ra,0x3
     de0:	646080e7          	jalr	1606(ra) # 4422 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
     de4:	85a6                	mv	a1,s1
     de6:	00004517          	auipc	a0,0x4
     dea:	2aa50513          	addi	a0,a0,682 # 5090 <malloc+0x830>
     dee:	00004097          	auipc	ra,0x4
     df2:	9b4080e7          	jalr	-1612(ra) # 47a2 <printf>
    exit(1);
     df6:	4505                	li	a0,1
     df8:	00003097          	auipc	ra,0x3
     dfc:	62a080e7          	jalr	1578(ra) # 4422 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
     e00:	85a6                	mv	a1,s1
     e02:	00004517          	auipc	a0,0x4
     e06:	30650513          	addi	a0,a0,774 # 5108 <malloc+0x8a8>
     e0a:	00004097          	auipc	ra,0x4
     e0e:	998080e7          	jalr	-1640(ra) # 47a2 <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	00003097          	auipc	ra,0x3
     e18:	60e080e7          	jalr	1550(ra) # 4422 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
     e1c:	85a6                	mv	a1,s1
     e1e:	00004517          	auipc	a0,0x4
     e22:	34a50513          	addi	a0,a0,842 # 5168 <malloc+0x908>
     e26:	00004097          	auipc	ra,0x4
     e2a:	97c080e7          	jalr	-1668(ra) # 47a2 <printf>
    exit(1);
     e2e:	4505                	li	a0,1
     e30:	00003097          	auipc	ra,0x3
     e34:	5f2080e7          	jalr	1522(ra) # 4422 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
     e38:	85a6                	mv	a1,s1
     e3a:	00004517          	auipc	a0,0x4
     e3e:	38650513          	addi	a0,a0,902 # 51c0 <malloc+0x960>
     e42:	00004097          	auipc	ra,0x4
     e46:	960080e7          	jalr	-1696(ra) # 47a2 <printf>
    exit(1);
     e4a:	4505                	li	a0,1
     e4c:	00003097          	auipc	ra,0x3
     e50:	5d6080e7          	jalr	1494(ra) # 4422 <exit>

0000000000000e54 <bigwrite>:
{
     e54:	715d                	addi	sp,sp,-80
     e56:	e486                	sd	ra,72(sp)
     e58:	e0a2                	sd	s0,64(sp)
     e5a:	fc26                	sd	s1,56(sp)
     e5c:	f84a                	sd	s2,48(sp)
     e5e:	f44e                	sd	s3,40(sp)
     e60:	f052                	sd	s4,32(sp)
     e62:	ec56                	sd	s5,24(sp)
     e64:	e85a                	sd	s6,16(sp)
     e66:	e45e                	sd	s7,8(sp)
     e68:	0880                	addi	s0,sp,80
     e6a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     e6c:	00004517          	auipc	a0,0x4
     e70:	c1450513          	addi	a0,a0,-1004 # 4a80 <malloc+0x220>
     e74:	00003097          	auipc	ra,0x3
     e78:	5fe080e7          	jalr	1534(ra) # 4472 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e7c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e80:	00004a97          	auipc	s5,0x4
     e84:	c00a8a93          	addi	s5,s5,-1024 # 4a80 <malloc+0x220>
      int cc = write(fd, buf, sz);
     e88:	00008a17          	auipc	s4,0x8
     e8c:	3a8a0a13          	addi	s4,s4,936 # 9230 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e90:	6b0d                	lui	s6,0x3
     e92:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirfile+0x27>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e96:	20200593          	li	a1,514
     e9a:	8556                	mv	a0,s5
     e9c:	00003097          	auipc	ra,0x3
     ea0:	5c6080e7          	jalr	1478(ra) # 4462 <open>
     ea4:	892a                	mv	s2,a0
    if(fd < 0){
     ea6:	04054d63          	bltz	a0,f00 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     eaa:	8626                	mv	a2,s1
     eac:	85d2                	mv	a1,s4
     eae:	00003097          	auipc	ra,0x3
     eb2:	594080e7          	jalr	1428(ra) # 4442 <write>
     eb6:	89aa                	mv	s3,a0
      if(cc != sz){
     eb8:	06a49463          	bne	s1,a0,f20 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     ebc:	8626                	mv	a2,s1
     ebe:	85d2                	mv	a1,s4
     ec0:	854a                	mv	a0,s2
     ec2:	00003097          	auipc	ra,0x3
     ec6:	580080e7          	jalr	1408(ra) # 4442 <write>
      if(cc != sz){
     eca:	04951963          	bne	a0,s1,f1c <bigwrite+0xc8>
    close(fd);
     ece:	854a                	mv	a0,s2
     ed0:	00003097          	auipc	ra,0x3
     ed4:	57a080e7          	jalr	1402(ra) # 444a <close>
    unlink("bigwrite");
     ed8:	8556                	mv	a0,s5
     eda:	00003097          	auipc	ra,0x3
     ede:	598080e7          	jalr	1432(ra) # 4472 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     ee2:	1d74849b          	addiw	s1,s1,471
     ee6:	fb6498e3          	bne	s1,s6,e96 <bigwrite+0x42>
}
     eea:	60a6                	ld	ra,72(sp)
     eec:	6406                	ld	s0,64(sp)
     eee:	74e2                	ld	s1,56(sp)
     ef0:	7942                	ld	s2,48(sp)
     ef2:	79a2                	ld	s3,40(sp)
     ef4:	7a02                	ld	s4,32(sp)
     ef6:	6ae2                	ld	s5,24(sp)
     ef8:	6b42                	ld	s6,16(sp)
     efa:	6ba2                	ld	s7,8(sp)
     efc:	6161                	addi	sp,sp,80
     efe:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     f00:	85de                	mv	a1,s7
     f02:	00004517          	auipc	a0,0x4
     f06:	2f650513          	addi	a0,a0,758 # 51f8 <malloc+0x998>
     f0a:	00004097          	auipc	ra,0x4
     f0e:	898080e7          	jalr	-1896(ra) # 47a2 <printf>
      exit(1);
     f12:	4505                	li	a0,1
     f14:	00003097          	auipc	ra,0x3
     f18:	50e080e7          	jalr	1294(ra) # 4422 <exit>
     f1c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     f1e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     f20:	86ce                	mv	a3,s3
     f22:	8626                	mv	a2,s1
     f24:	85de                	mv	a1,s7
     f26:	00004517          	auipc	a0,0x4
     f2a:	2f250513          	addi	a0,a0,754 # 5218 <malloc+0x9b8>
     f2e:	00004097          	auipc	ra,0x4
     f32:	874080e7          	jalr	-1932(ra) # 47a2 <printf>
        exit(1);
     f36:	4505                	li	a0,1
     f38:	00003097          	auipc	ra,0x3
     f3c:	4ea080e7          	jalr	1258(ra) # 4422 <exit>

0000000000000f40 <writetest>:
{
     f40:	7139                	addi	sp,sp,-64
     f42:	fc06                	sd	ra,56(sp)
     f44:	f822                	sd	s0,48(sp)
     f46:	f426                	sd	s1,40(sp)
     f48:	f04a                	sd	s2,32(sp)
     f4a:	ec4e                	sd	s3,24(sp)
     f4c:	e852                	sd	s4,16(sp)
     f4e:	e456                	sd	s5,8(sp)
     f50:	e05a                	sd	s6,0(sp)
     f52:	0080                	addi	s0,sp,64
     f54:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     f56:	20200593          	li	a1,514
     f5a:	00004517          	auipc	a0,0x4
     f5e:	2d650513          	addi	a0,a0,726 # 5230 <malloc+0x9d0>
     f62:	00003097          	auipc	ra,0x3
     f66:	500080e7          	jalr	1280(ra) # 4462 <open>
  if(fd < 0){
     f6a:	0a054d63          	bltz	a0,1024 <writetest+0xe4>
     f6e:	892a                	mv	s2,a0
     f70:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f72:	00004997          	auipc	s3,0x4
     f76:	2e698993          	addi	s3,s3,742 # 5258 <malloc+0x9f8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f7a:	00004a97          	auipc	s5,0x4
     f7e:	316a8a93          	addi	s5,s5,790 # 5290 <malloc+0xa30>
  for(i = 0; i < N; i++){
     f82:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f86:	4629                	li	a2,10
     f88:	85ce                	mv	a1,s3
     f8a:	854a                	mv	a0,s2
     f8c:	00003097          	auipc	ra,0x3
     f90:	4b6080e7          	jalr	1206(ra) # 4442 <write>
     f94:	47a9                	li	a5,10
     f96:	0af51563          	bne	a0,a5,1040 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f9a:	4629                	li	a2,10
     f9c:	85d6                	mv	a1,s5
     f9e:	854a                	mv	a0,s2
     fa0:	00003097          	auipc	ra,0x3
     fa4:	4a2080e7          	jalr	1186(ra) # 4442 <write>
     fa8:	47a9                	li	a5,10
     faa:	0af51963          	bne	a0,a5,105c <writetest+0x11c>
  for(i = 0; i < N; i++){
     fae:	2485                	addiw	s1,s1,1
     fb0:	fd449be3          	bne	s1,s4,f86 <writetest+0x46>
  close(fd);
     fb4:	854a                	mv	a0,s2
     fb6:	00003097          	auipc	ra,0x3
     fba:	494080e7          	jalr	1172(ra) # 444a <close>
  fd = open("small", O_RDONLY);
     fbe:	4581                	li	a1,0
     fc0:	00004517          	auipc	a0,0x4
     fc4:	27050513          	addi	a0,a0,624 # 5230 <malloc+0x9d0>
     fc8:	00003097          	auipc	ra,0x3
     fcc:	49a080e7          	jalr	1178(ra) # 4462 <open>
     fd0:	84aa                	mv	s1,a0
  if(fd < 0){
     fd2:	0a054363          	bltz	a0,1078 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     fd6:	7d000613          	li	a2,2000
     fda:	00008597          	auipc	a1,0x8
     fde:	25658593          	addi	a1,a1,598 # 9230 <buf>
     fe2:	00003097          	auipc	ra,0x3
     fe6:	458080e7          	jalr	1112(ra) # 443a <read>
  if(i != N*SZ*2){
     fea:	7d000793          	li	a5,2000
     fee:	0af51363          	bne	a0,a5,1094 <writetest+0x154>
  close(fd);
     ff2:	8526                	mv	a0,s1
     ff4:	00003097          	auipc	ra,0x3
     ff8:	456080e7          	jalr	1110(ra) # 444a <close>
  if(unlink("small") < 0){
     ffc:	00004517          	auipc	a0,0x4
    1000:	23450513          	addi	a0,a0,564 # 5230 <malloc+0x9d0>
    1004:	00003097          	auipc	ra,0x3
    1008:	46e080e7          	jalr	1134(ra) # 4472 <unlink>
    100c:	0a054263          	bltz	a0,10b0 <writetest+0x170>
}
    1010:	70e2                	ld	ra,56(sp)
    1012:	7442                	ld	s0,48(sp)
    1014:	74a2                	ld	s1,40(sp)
    1016:	7902                	ld	s2,32(sp)
    1018:	69e2                	ld	s3,24(sp)
    101a:	6a42                	ld	s4,16(sp)
    101c:	6aa2                	ld	s5,8(sp)
    101e:	6b02                	ld	s6,0(sp)
    1020:	6121                	addi	sp,sp,64
    1022:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    1024:	85da                	mv	a1,s6
    1026:	00004517          	auipc	a0,0x4
    102a:	21250513          	addi	a0,a0,530 # 5238 <malloc+0x9d8>
    102e:	00003097          	auipc	ra,0x3
    1032:	774080e7          	jalr	1908(ra) # 47a2 <printf>
    exit(1);
    1036:	4505                	li	a0,1
    1038:	00003097          	auipc	ra,0x3
    103c:	3ea080e7          	jalr	1002(ra) # 4422 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
    1040:	85a6                	mv	a1,s1
    1042:	00004517          	auipc	a0,0x4
    1046:	22650513          	addi	a0,a0,550 # 5268 <malloc+0xa08>
    104a:	00003097          	auipc	ra,0x3
    104e:	758080e7          	jalr	1880(ra) # 47a2 <printf>
      exit(1);
    1052:	4505                	li	a0,1
    1054:	00003097          	auipc	ra,0x3
    1058:	3ce080e7          	jalr	974(ra) # 4422 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
    105c:	85a6                	mv	a1,s1
    105e:	00004517          	auipc	a0,0x4
    1062:	24250513          	addi	a0,a0,578 # 52a0 <malloc+0xa40>
    1066:	00003097          	auipc	ra,0x3
    106a:	73c080e7          	jalr	1852(ra) # 47a2 <printf>
      exit(1);
    106e:	4505                	li	a0,1
    1070:	00003097          	auipc	ra,0x3
    1074:	3b2080e7          	jalr	946(ra) # 4422 <exit>
    printf("%s: error: open small failed!\n", s);
    1078:	85da                	mv	a1,s6
    107a:	00004517          	auipc	a0,0x4
    107e:	24e50513          	addi	a0,a0,590 # 52c8 <malloc+0xa68>
    1082:	00003097          	auipc	ra,0x3
    1086:	720080e7          	jalr	1824(ra) # 47a2 <printf>
    exit(1);
    108a:	4505                	li	a0,1
    108c:	00003097          	auipc	ra,0x3
    1090:	396080e7          	jalr	918(ra) # 4422 <exit>
    printf("%s: read failed\n", s);
    1094:	85da                	mv	a1,s6
    1096:	00004517          	auipc	a0,0x4
    109a:	25250513          	addi	a0,a0,594 # 52e8 <malloc+0xa88>
    109e:	00003097          	auipc	ra,0x3
    10a2:	704080e7          	jalr	1796(ra) # 47a2 <printf>
    exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00003097          	auipc	ra,0x3
    10ac:	37a080e7          	jalr	890(ra) # 4422 <exit>
    printf("%s: unlink small failed\n", s);
    10b0:	85da                	mv	a1,s6
    10b2:	00004517          	auipc	a0,0x4
    10b6:	24e50513          	addi	a0,a0,590 # 5300 <malloc+0xaa0>
    10ba:	00003097          	auipc	ra,0x3
    10be:	6e8080e7          	jalr	1768(ra) # 47a2 <printf>
    exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00003097          	auipc	ra,0x3
    10c8:	35e080e7          	jalr	862(ra) # 4422 <exit>

00000000000010cc <writebig>:
{
    10cc:	7139                	addi	sp,sp,-64
    10ce:	fc06                	sd	ra,56(sp)
    10d0:	f822                	sd	s0,48(sp)
    10d2:	f426                	sd	s1,40(sp)
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	ec4e                	sd	s3,24(sp)
    10d8:	e852                	sd	s4,16(sp)
    10da:	e456                	sd	s5,8(sp)
    10dc:	0080                	addi	s0,sp,64
    10de:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    10e0:	20200593          	li	a1,514
    10e4:	00004517          	auipc	a0,0x4
    10e8:	23c50513          	addi	a0,a0,572 # 5320 <malloc+0xac0>
    10ec:	00003097          	auipc	ra,0x3
    10f0:	376080e7          	jalr	886(ra) # 4462 <open>
    10f4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    10f6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    10f8:	00008917          	auipc	s2,0x8
    10fc:	13890913          	addi	s2,s2,312 # 9230 <buf>
  for(i = 0; i < MAXFILE; i++){
    1100:	10c00a13          	li	s4,268
  if(fd < 0){
    1104:	06054c63          	bltz	a0,117c <writebig+0xb0>
    ((int*)buf)[0] = i;
    1108:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    110c:	40000613          	li	a2,1024
    1110:	85ca                	mv	a1,s2
    1112:	854e                	mv	a0,s3
    1114:	00003097          	auipc	ra,0x3
    1118:	32e080e7          	jalr	814(ra) # 4442 <write>
    111c:	40000793          	li	a5,1024
    1120:	06f51c63          	bne	a0,a5,1198 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    1124:	2485                	addiw	s1,s1,1
    1126:	ff4491e3          	bne	s1,s4,1108 <writebig+0x3c>
  close(fd);
    112a:	854e                	mv	a0,s3
    112c:	00003097          	auipc	ra,0x3
    1130:	31e080e7          	jalr	798(ra) # 444a <close>
  fd = open("big", O_RDONLY);
    1134:	4581                	li	a1,0
    1136:	00004517          	auipc	a0,0x4
    113a:	1ea50513          	addi	a0,a0,490 # 5320 <malloc+0xac0>
    113e:	00003097          	auipc	ra,0x3
    1142:	324080e7          	jalr	804(ra) # 4462 <open>
    1146:	89aa                	mv	s3,a0
  n = 0;
    1148:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    114a:	00008917          	auipc	s2,0x8
    114e:	0e690913          	addi	s2,s2,230 # 9230 <buf>
  if(fd < 0){
    1152:	06054163          	bltz	a0,11b4 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
    1156:	40000613          	li	a2,1024
    115a:	85ca                	mv	a1,s2
    115c:	854e                	mv	a0,s3
    115e:	00003097          	auipc	ra,0x3
    1162:	2dc080e7          	jalr	732(ra) # 443a <read>
    if(i == 0){
    1166:	c52d                	beqz	a0,11d0 <writebig+0x104>
    } else if(i != BSIZE){
    1168:	40000793          	li	a5,1024
    116c:	0af51d63          	bne	a0,a5,1226 <writebig+0x15a>
    if(((int*)buf)[0] != n){
    1170:	00092603          	lw	a2,0(s2)
    1174:	0c961763          	bne	a2,s1,1242 <writebig+0x176>
    n++;
    1178:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    117a:	bff1                	j	1156 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    117c:	85d6                	mv	a1,s5
    117e:	00004517          	auipc	a0,0x4
    1182:	1aa50513          	addi	a0,a0,426 # 5328 <malloc+0xac8>
    1186:	00003097          	auipc	ra,0x3
    118a:	61c080e7          	jalr	1564(ra) # 47a2 <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	00003097          	auipc	ra,0x3
    1194:	292080e7          	jalr	658(ra) # 4422 <exit>
      printf("%s: error: write big file failed\n", i);
    1198:	85a6                	mv	a1,s1
    119a:	00004517          	auipc	a0,0x4
    119e:	1ae50513          	addi	a0,a0,430 # 5348 <malloc+0xae8>
    11a2:	00003097          	auipc	ra,0x3
    11a6:	600080e7          	jalr	1536(ra) # 47a2 <printf>
      exit(1);
    11aa:	4505                	li	a0,1
    11ac:	00003097          	auipc	ra,0x3
    11b0:	276080e7          	jalr	630(ra) # 4422 <exit>
    printf("%s: error: open big failed!\n", s);
    11b4:	85d6                	mv	a1,s5
    11b6:	00004517          	auipc	a0,0x4
    11ba:	1ba50513          	addi	a0,a0,442 # 5370 <malloc+0xb10>
    11be:	00003097          	auipc	ra,0x3
    11c2:	5e4080e7          	jalr	1508(ra) # 47a2 <printf>
    exit(1);
    11c6:	4505                	li	a0,1
    11c8:	00003097          	auipc	ra,0x3
    11cc:	25a080e7          	jalr	602(ra) # 4422 <exit>
      if(n == MAXFILE - 1){
    11d0:	10b00793          	li	a5,267
    11d4:	02f48a63          	beq	s1,a5,1208 <writebig+0x13c>
  close(fd);
    11d8:	854e                	mv	a0,s3
    11da:	00003097          	auipc	ra,0x3
    11de:	270080e7          	jalr	624(ra) # 444a <close>
  if(unlink("big") < 0){
    11e2:	00004517          	auipc	a0,0x4
    11e6:	13e50513          	addi	a0,a0,318 # 5320 <malloc+0xac0>
    11ea:	00003097          	auipc	ra,0x3
    11ee:	288080e7          	jalr	648(ra) # 4472 <unlink>
    11f2:	06054663          	bltz	a0,125e <writebig+0x192>
}
    11f6:	70e2                	ld	ra,56(sp)
    11f8:	7442                	ld	s0,48(sp)
    11fa:	74a2                	ld	s1,40(sp)
    11fc:	7902                	ld	s2,32(sp)
    11fe:	69e2                	ld	s3,24(sp)
    1200:	6a42                	ld	s4,16(sp)
    1202:	6aa2                	ld	s5,8(sp)
    1204:	6121                	addi	sp,sp,64
    1206:	8082                	ret
        printf("%s: read only %d blocks from big", n);
    1208:	10b00593          	li	a1,267
    120c:	00004517          	auipc	a0,0x4
    1210:	18450513          	addi	a0,a0,388 # 5390 <malloc+0xb30>
    1214:	00003097          	auipc	ra,0x3
    1218:	58e080e7          	jalr	1422(ra) # 47a2 <printf>
        exit(1);
    121c:	4505                	li	a0,1
    121e:	00003097          	auipc	ra,0x3
    1222:	204080e7          	jalr	516(ra) # 4422 <exit>
      printf("%s: read failed %d\n", i);
    1226:	85aa                	mv	a1,a0
    1228:	00004517          	auipc	a0,0x4
    122c:	19050513          	addi	a0,a0,400 # 53b8 <malloc+0xb58>
    1230:	00003097          	auipc	ra,0x3
    1234:	572080e7          	jalr	1394(ra) # 47a2 <printf>
      exit(1);
    1238:	4505                	li	a0,1
    123a:	00003097          	auipc	ra,0x3
    123e:	1e8080e7          	jalr	488(ra) # 4422 <exit>
      printf("%s: read content of block %d is %d\n",
    1242:	85a6                	mv	a1,s1
    1244:	00004517          	auipc	a0,0x4
    1248:	18c50513          	addi	a0,a0,396 # 53d0 <malloc+0xb70>
    124c:	00003097          	auipc	ra,0x3
    1250:	556080e7          	jalr	1366(ra) # 47a2 <printf>
      exit(1);
    1254:	4505                	li	a0,1
    1256:	00003097          	auipc	ra,0x3
    125a:	1cc080e7          	jalr	460(ra) # 4422 <exit>
    printf("%s: unlink big failed\n", s);
    125e:	85d6                	mv	a1,s5
    1260:	00004517          	auipc	a0,0x4
    1264:	19850513          	addi	a0,a0,408 # 53f8 <malloc+0xb98>
    1268:	00003097          	auipc	ra,0x3
    126c:	53a080e7          	jalr	1338(ra) # 47a2 <printf>
    exit(1);
    1270:	4505                	li	a0,1
    1272:	00003097          	auipc	ra,0x3
    1276:	1b0080e7          	jalr	432(ra) # 4422 <exit>

000000000000127a <unlinkread>:
{
    127a:	7179                	addi	sp,sp,-48
    127c:	f406                	sd	ra,40(sp)
    127e:	f022                	sd	s0,32(sp)
    1280:	ec26                	sd	s1,24(sp)
    1282:	e84a                	sd	s2,16(sp)
    1284:	e44e                	sd	s3,8(sp)
    1286:	1800                	addi	s0,sp,48
    1288:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    128a:	20200593          	li	a1,514
    128e:	00003517          	auipc	a0,0x3
    1292:	78a50513          	addi	a0,a0,1930 # 4a18 <malloc+0x1b8>
    1296:	00003097          	auipc	ra,0x3
    129a:	1cc080e7          	jalr	460(ra) # 4462 <open>
  if(fd < 0){
    129e:	0e054563          	bltz	a0,1388 <unlinkread+0x10e>
    12a2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    12a4:	4615                	li	a2,5
    12a6:	00004597          	auipc	a1,0x4
    12aa:	18a58593          	addi	a1,a1,394 # 5430 <malloc+0xbd0>
    12ae:	00003097          	auipc	ra,0x3
    12b2:	194080e7          	jalr	404(ra) # 4442 <write>
  close(fd);
    12b6:	8526                	mv	a0,s1
    12b8:	00003097          	auipc	ra,0x3
    12bc:	192080e7          	jalr	402(ra) # 444a <close>
  fd = open("unlinkread", O_RDWR);
    12c0:	4589                	li	a1,2
    12c2:	00003517          	auipc	a0,0x3
    12c6:	75650513          	addi	a0,a0,1878 # 4a18 <malloc+0x1b8>
    12ca:	00003097          	auipc	ra,0x3
    12ce:	198080e7          	jalr	408(ra) # 4462 <open>
    12d2:	84aa                	mv	s1,a0
  if(fd < 0){
    12d4:	0c054863          	bltz	a0,13a4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    12d8:	00003517          	auipc	a0,0x3
    12dc:	74050513          	addi	a0,a0,1856 # 4a18 <malloc+0x1b8>
    12e0:	00003097          	auipc	ra,0x3
    12e4:	192080e7          	jalr	402(ra) # 4472 <unlink>
    12e8:	ed61                	bnez	a0,13c0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12ea:	20200593          	li	a1,514
    12ee:	00003517          	auipc	a0,0x3
    12f2:	72a50513          	addi	a0,a0,1834 # 4a18 <malloc+0x1b8>
    12f6:	00003097          	auipc	ra,0x3
    12fa:	16c080e7          	jalr	364(ra) # 4462 <open>
    12fe:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1300:	460d                	li	a2,3
    1302:	00004597          	auipc	a1,0x4
    1306:	17658593          	addi	a1,a1,374 # 5478 <malloc+0xc18>
    130a:	00003097          	auipc	ra,0x3
    130e:	138080e7          	jalr	312(ra) # 4442 <write>
  close(fd1);
    1312:	854a                	mv	a0,s2
    1314:	00003097          	auipc	ra,0x3
    1318:	136080e7          	jalr	310(ra) # 444a <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    131c:	660d                	lui	a2,0x3
    131e:	00008597          	auipc	a1,0x8
    1322:	f1258593          	addi	a1,a1,-238 # 9230 <buf>
    1326:	8526                	mv	a0,s1
    1328:	00003097          	auipc	ra,0x3
    132c:	112080e7          	jalr	274(ra) # 443a <read>
    1330:	4795                	li	a5,5
    1332:	0af51563          	bne	a0,a5,13dc <unlinkread+0x162>
  if(buf[0] != 'h'){
    1336:	00008717          	auipc	a4,0x8
    133a:	efa74703          	lbu	a4,-262(a4) # 9230 <buf>
    133e:	06800793          	li	a5,104
    1342:	0af71b63          	bne	a4,a5,13f8 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    1346:	4629                	li	a2,10
    1348:	00008597          	auipc	a1,0x8
    134c:	ee858593          	addi	a1,a1,-280 # 9230 <buf>
    1350:	8526                	mv	a0,s1
    1352:	00003097          	auipc	ra,0x3
    1356:	0f0080e7          	jalr	240(ra) # 4442 <write>
    135a:	47a9                	li	a5,10
    135c:	0af51c63          	bne	a0,a5,1414 <unlinkread+0x19a>
  close(fd);
    1360:	8526                	mv	a0,s1
    1362:	00003097          	auipc	ra,0x3
    1366:	0e8080e7          	jalr	232(ra) # 444a <close>
  unlink("unlinkread");
    136a:	00003517          	auipc	a0,0x3
    136e:	6ae50513          	addi	a0,a0,1710 # 4a18 <malloc+0x1b8>
    1372:	00003097          	auipc	ra,0x3
    1376:	100080e7          	jalr	256(ra) # 4472 <unlink>
}
    137a:	70a2                	ld	ra,40(sp)
    137c:	7402                	ld	s0,32(sp)
    137e:	64e2                	ld	s1,24(sp)
    1380:	6942                	ld	s2,16(sp)
    1382:	69a2                	ld	s3,8(sp)
    1384:	6145                	addi	sp,sp,48
    1386:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    1388:	85ce                	mv	a1,s3
    138a:	00004517          	auipc	a0,0x4
    138e:	08650513          	addi	a0,a0,134 # 5410 <malloc+0xbb0>
    1392:	00003097          	auipc	ra,0x3
    1396:	410080e7          	jalr	1040(ra) # 47a2 <printf>
    exit(1);
    139a:	4505                	li	a0,1
    139c:	00003097          	auipc	ra,0x3
    13a0:	086080e7          	jalr	134(ra) # 4422 <exit>
    printf("%s: open unlinkread failed\n", s);
    13a4:	85ce                	mv	a1,s3
    13a6:	00004517          	auipc	a0,0x4
    13aa:	09250513          	addi	a0,a0,146 # 5438 <malloc+0xbd8>
    13ae:	00003097          	auipc	ra,0x3
    13b2:	3f4080e7          	jalr	1012(ra) # 47a2 <printf>
    exit(1);
    13b6:	4505                	li	a0,1
    13b8:	00003097          	auipc	ra,0x3
    13bc:	06a080e7          	jalr	106(ra) # 4422 <exit>
    printf("%s: unlink unlinkread failed\n", s);
    13c0:	85ce                	mv	a1,s3
    13c2:	00004517          	auipc	a0,0x4
    13c6:	09650513          	addi	a0,a0,150 # 5458 <malloc+0xbf8>
    13ca:	00003097          	auipc	ra,0x3
    13ce:	3d8080e7          	jalr	984(ra) # 47a2 <printf>
    exit(1);
    13d2:	4505                	li	a0,1
    13d4:	00003097          	auipc	ra,0x3
    13d8:	04e080e7          	jalr	78(ra) # 4422 <exit>
    printf("%s: unlinkread read failed", s);
    13dc:	85ce                	mv	a1,s3
    13de:	00004517          	auipc	a0,0x4
    13e2:	0a250513          	addi	a0,a0,162 # 5480 <malloc+0xc20>
    13e6:	00003097          	auipc	ra,0x3
    13ea:	3bc080e7          	jalr	956(ra) # 47a2 <printf>
    exit(1);
    13ee:	4505                	li	a0,1
    13f0:	00003097          	auipc	ra,0x3
    13f4:	032080e7          	jalr	50(ra) # 4422 <exit>
    printf("%s: unlinkread wrong data\n", s);
    13f8:	85ce                	mv	a1,s3
    13fa:	00004517          	auipc	a0,0x4
    13fe:	0a650513          	addi	a0,a0,166 # 54a0 <malloc+0xc40>
    1402:	00003097          	auipc	ra,0x3
    1406:	3a0080e7          	jalr	928(ra) # 47a2 <printf>
    exit(1);
    140a:	4505                	li	a0,1
    140c:	00003097          	auipc	ra,0x3
    1410:	016080e7          	jalr	22(ra) # 4422 <exit>
    printf("%s: unlinkread write failed\n", s);
    1414:	85ce                	mv	a1,s3
    1416:	00004517          	auipc	a0,0x4
    141a:	0aa50513          	addi	a0,a0,170 # 54c0 <malloc+0xc60>
    141e:	00003097          	auipc	ra,0x3
    1422:	384080e7          	jalr	900(ra) # 47a2 <printf>
    exit(1);
    1426:	4505                	li	a0,1
    1428:	00003097          	auipc	ra,0x3
    142c:	ffa080e7          	jalr	-6(ra) # 4422 <exit>

0000000000001430 <exectest>:
{
    1430:	715d                	addi	sp,sp,-80
    1432:	e486                	sd	ra,72(sp)
    1434:	e0a2                	sd	s0,64(sp)
    1436:	fc26                	sd	s1,56(sp)
    1438:	f84a                	sd	s2,48(sp)
    143a:	0880                	addi	s0,sp,80
    143c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    143e:	00004797          	auipc	a5,0x4
    1442:	ad278793          	addi	a5,a5,-1326 # 4f10 <malloc+0x6b0>
    1446:	fcf43023          	sd	a5,-64(s0)
    144a:	00004797          	auipc	a5,0x4
    144e:	09678793          	addi	a5,a5,150 # 54e0 <malloc+0xc80>
    1452:	fcf43423          	sd	a5,-56(s0)
    1456:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    145a:	00004517          	auipc	a0,0x4
    145e:	08e50513          	addi	a0,a0,142 # 54e8 <malloc+0xc88>
    1462:	00003097          	auipc	ra,0x3
    1466:	010080e7          	jalr	16(ra) # 4472 <unlink>
  pid = fork();
    146a:	00003097          	auipc	ra,0x3
    146e:	fb0080e7          	jalr	-80(ra) # 441a <fork>
  if(pid < 0) {
    1472:	04054663          	bltz	a0,14be <exectest+0x8e>
    1476:	84aa                	mv	s1,a0
  if(pid == 0) {
    1478:	e959                	bnez	a0,150e <exectest+0xde>
    close(1);
    147a:	4505                	li	a0,1
    147c:	00003097          	auipc	ra,0x3
    1480:	fce080e7          	jalr	-50(ra) # 444a <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1484:	20100593          	li	a1,513
    1488:	00004517          	auipc	a0,0x4
    148c:	06050513          	addi	a0,a0,96 # 54e8 <malloc+0xc88>
    1490:	00003097          	auipc	ra,0x3
    1494:	fd2080e7          	jalr	-46(ra) # 4462 <open>
    if(fd < 0) {
    1498:	04054163          	bltz	a0,14da <exectest+0xaa>
    if(fd != 1) {
    149c:	4785                	li	a5,1
    149e:	04f50c63          	beq	a0,a5,14f6 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    14a2:	85ca                	mv	a1,s2
    14a4:	00004517          	auipc	a0,0x4
    14a8:	04c50513          	addi	a0,a0,76 # 54f0 <malloc+0xc90>
    14ac:	00003097          	auipc	ra,0x3
    14b0:	2f6080e7          	jalr	758(ra) # 47a2 <printf>
      exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00003097          	auipc	ra,0x3
    14ba:	f6c080e7          	jalr	-148(ra) # 4422 <exit>
     printf("%s: fork failed\n", s);
    14be:	85ca                	mv	a1,s2
    14c0:	00004517          	auipc	a0,0x4
    14c4:	8a050513          	addi	a0,a0,-1888 # 4d60 <malloc+0x500>
    14c8:	00003097          	auipc	ra,0x3
    14cc:	2da080e7          	jalr	730(ra) # 47a2 <printf>
     exit(1);
    14d0:	4505                	li	a0,1
    14d2:	00003097          	auipc	ra,0x3
    14d6:	f50080e7          	jalr	-176(ra) # 4422 <exit>
      printf("%s: create failed\n", s);
    14da:	85ca                	mv	a1,s2
    14dc:	00004517          	auipc	a0,0x4
    14e0:	a9c50513          	addi	a0,a0,-1380 # 4f78 <malloc+0x718>
    14e4:	00003097          	auipc	ra,0x3
    14e8:	2be080e7          	jalr	702(ra) # 47a2 <printf>
      exit(1);
    14ec:	4505                	li	a0,1
    14ee:	00003097          	auipc	ra,0x3
    14f2:	f34080e7          	jalr	-204(ra) # 4422 <exit>
    if(exec("echo", echoargv) < 0){
    14f6:	fc040593          	addi	a1,s0,-64
    14fa:	00004517          	auipc	a0,0x4
    14fe:	a1650513          	addi	a0,a0,-1514 # 4f10 <malloc+0x6b0>
    1502:	00003097          	auipc	ra,0x3
    1506:	f58080e7          	jalr	-168(ra) # 445a <exec>
    150a:	02054163          	bltz	a0,152c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    150e:	fdc40513          	addi	a0,s0,-36
    1512:	00003097          	auipc	ra,0x3
    1516:	f18080e7          	jalr	-232(ra) # 442a <wait>
    151a:	02951763          	bne	a0,s1,1548 <exectest+0x118>
  if(xstatus != 0)
    151e:	fdc42503          	lw	a0,-36(s0)
    1522:	cd0d                	beqz	a0,155c <exectest+0x12c>
    exit(xstatus);
    1524:	00003097          	auipc	ra,0x3
    1528:	efe080e7          	jalr	-258(ra) # 4422 <exit>
      printf("%s: exec echo failed\n", s);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	fd250513          	addi	a0,a0,-46 # 5500 <malloc+0xca0>
    1536:	00003097          	auipc	ra,0x3
    153a:	26c080e7          	jalr	620(ra) # 47a2 <printf>
      exit(1);
    153e:	4505                	li	a0,1
    1540:	00003097          	auipc	ra,0x3
    1544:	ee2080e7          	jalr	-286(ra) # 4422 <exit>
    printf("%s: wait failed!\n", s);
    1548:	85ca                	mv	a1,s2
    154a:	00004517          	auipc	a0,0x4
    154e:	fce50513          	addi	a0,a0,-50 # 5518 <malloc+0xcb8>
    1552:	00003097          	auipc	ra,0x3
    1556:	250080e7          	jalr	592(ra) # 47a2 <printf>
    155a:	b7d1                	j	151e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    155c:	4581                	li	a1,0
    155e:	00004517          	auipc	a0,0x4
    1562:	f8a50513          	addi	a0,a0,-118 # 54e8 <malloc+0xc88>
    1566:	00003097          	auipc	ra,0x3
    156a:	efc080e7          	jalr	-260(ra) # 4462 <open>
  if(fd < 0) {
    156e:	02054a63          	bltz	a0,15a2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1572:	4609                	li	a2,2
    1574:	fb840593          	addi	a1,s0,-72
    1578:	00003097          	auipc	ra,0x3
    157c:	ec2080e7          	jalr	-318(ra) # 443a <read>
    1580:	4789                	li	a5,2
    1582:	02f50e63          	beq	a0,a5,15be <exectest+0x18e>
    printf("%s: read failed\n", s);
    1586:	85ca                	mv	a1,s2
    1588:	00004517          	auipc	a0,0x4
    158c:	d6050513          	addi	a0,a0,-672 # 52e8 <malloc+0xa88>
    1590:	00003097          	auipc	ra,0x3
    1594:	212080e7          	jalr	530(ra) # 47a2 <printf>
    exit(1);
    1598:	4505                	li	a0,1
    159a:	00003097          	auipc	ra,0x3
    159e:	e88080e7          	jalr	-376(ra) # 4422 <exit>
    printf("%s: open failed\n", s);
    15a2:	85ca                	mv	a1,s2
    15a4:	00004517          	auipc	a0,0x4
    15a8:	f8c50513          	addi	a0,a0,-116 # 5530 <malloc+0xcd0>
    15ac:	00003097          	auipc	ra,0x3
    15b0:	1f6080e7          	jalr	502(ra) # 47a2 <printf>
    exit(1);
    15b4:	4505                	li	a0,1
    15b6:	00003097          	auipc	ra,0x3
    15ba:	e6c080e7          	jalr	-404(ra) # 4422 <exit>
  unlink("echo-ok");
    15be:	00004517          	auipc	a0,0x4
    15c2:	f2a50513          	addi	a0,a0,-214 # 54e8 <malloc+0xc88>
    15c6:	00003097          	auipc	ra,0x3
    15ca:	eac080e7          	jalr	-340(ra) # 4472 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    15ce:	fb844703          	lbu	a4,-72(s0)
    15d2:	04f00793          	li	a5,79
    15d6:	00f71863          	bne	a4,a5,15e6 <exectest+0x1b6>
    15da:	fb944703          	lbu	a4,-71(s0)
    15de:	04b00793          	li	a5,75
    15e2:	02f70063          	beq	a4,a5,1602 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    15e6:	85ca                	mv	a1,s2
    15e8:	00004517          	auipc	a0,0x4
    15ec:	f6050513          	addi	a0,a0,-160 # 5548 <malloc+0xce8>
    15f0:	00003097          	auipc	ra,0x3
    15f4:	1b2080e7          	jalr	434(ra) # 47a2 <printf>
    exit(1);
    15f8:	4505                	li	a0,1
    15fa:	00003097          	auipc	ra,0x3
    15fe:	e28080e7          	jalr	-472(ra) # 4422 <exit>
    exit(0);
    1602:	4501                	li	a0,0
    1604:	00003097          	auipc	ra,0x3
    1608:	e1e080e7          	jalr	-482(ra) # 4422 <exit>

000000000000160c <bigargtest>:
{
    160c:	7179                	addi	sp,sp,-48
    160e:	f406                	sd	ra,40(sp)
    1610:	f022                	sd	s0,32(sp)
    1612:	ec26                	sd	s1,24(sp)
    1614:	1800                	addi	s0,sp,48
    1616:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    1618:	00004517          	auipc	a0,0x4
    161c:	f4850513          	addi	a0,a0,-184 # 5560 <malloc+0xd00>
    1620:	00003097          	auipc	ra,0x3
    1624:	e52080e7          	jalr	-430(ra) # 4472 <unlink>
  pid = fork();
    1628:	00003097          	auipc	ra,0x3
    162c:	df2080e7          	jalr	-526(ra) # 441a <fork>
  if(pid == 0){
    1630:	c121                	beqz	a0,1670 <bigargtest+0x64>
  } else if(pid < 0){
    1632:	0a054063          	bltz	a0,16d2 <bigargtest+0xc6>
  wait(&xstatus);
    1636:	fdc40513          	addi	a0,s0,-36
    163a:	00003097          	auipc	ra,0x3
    163e:	df0080e7          	jalr	-528(ra) # 442a <wait>
  if(xstatus != 0)
    1642:	fdc42503          	lw	a0,-36(s0)
    1646:	e545                	bnez	a0,16ee <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    1648:	4581                	li	a1,0
    164a:	00004517          	auipc	a0,0x4
    164e:	f1650513          	addi	a0,a0,-234 # 5560 <malloc+0xd00>
    1652:	00003097          	auipc	ra,0x3
    1656:	e10080e7          	jalr	-496(ra) # 4462 <open>
  if(fd < 0){
    165a:	08054e63          	bltz	a0,16f6 <bigargtest+0xea>
  close(fd);
    165e:	00003097          	auipc	ra,0x3
    1662:	dec080e7          	jalr	-532(ra) # 444a <close>
}
    1666:	70a2                	ld	ra,40(sp)
    1668:	7402                	ld	s0,32(sp)
    166a:	64e2                	ld	s1,24(sp)
    166c:	6145                	addi	sp,sp,48
    166e:	8082                	ret
    1670:	00005797          	auipc	a5,0x5
    1674:	3b078793          	addi	a5,a5,944 # 6a20 <args.0>
    1678:	00005697          	auipc	a3,0x5
    167c:	4a068693          	addi	a3,a3,1184 # 6b18 <args.0+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1680:	00004717          	auipc	a4,0x4
    1684:	ef070713          	addi	a4,a4,-272 # 5570 <malloc+0xd10>
    1688:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    168a:	07a1                	addi	a5,a5,8
    168c:	fed79ee3          	bne	a5,a3,1688 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    1690:	00005597          	auipc	a1,0x5
    1694:	39058593          	addi	a1,a1,912 # 6a20 <args.0>
    1698:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    169c:	00004517          	auipc	a0,0x4
    16a0:	87450513          	addi	a0,a0,-1932 # 4f10 <malloc+0x6b0>
    16a4:	00003097          	auipc	ra,0x3
    16a8:	db6080e7          	jalr	-586(ra) # 445a <exec>
    fd = open("bigarg-ok", O_CREATE);
    16ac:	20000593          	li	a1,512
    16b0:	00004517          	auipc	a0,0x4
    16b4:	eb050513          	addi	a0,a0,-336 # 5560 <malloc+0xd00>
    16b8:	00003097          	auipc	ra,0x3
    16bc:	daa080e7          	jalr	-598(ra) # 4462 <open>
    close(fd);
    16c0:	00003097          	auipc	ra,0x3
    16c4:	d8a080e7          	jalr	-630(ra) # 444a <close>
    exit(0);
    16c8:	4501                	li	a0,0
    16ca:	00003097          	auipc	ra,0x3
    16ce:	d58080e7          	jalr	-680(ra) # 4422 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    16d2:	85a6                	mv	a1,s1
    16d4:	00004517          	auipc	a0,0x4
    16d8:	f7c50513          	addi	a0,a0,-132 # 5650 <malloc+0xdf0>
    16dc:	00003097          	auipc	ra,0x3
    16e0:	0c6080e7          	jalr	198(ra) # 47a2 <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00003097          	auipc	ra,0x3
    16ea:	d3c080e7          	jalr	-708(ra) # 4422 <exit>
    exit(xstatus);
    16ee:	00003097          	auipc	ra,0x3
    16f2:	d34080e7          	jalr	-716(ra) # 4422 <exit>
    printf("%s: bigarg test failed!\n", s);
    16f6:	85a6                	mv	a1,s1
    16f8:	00004517          	auipc	a0,0x4
    16fc:	f7850513          	addi	a0,a0,-136 # 5670 <malloc+0xe10>
    1700:	00003097          	auipc	ra,0x3
    1704:	0a2080e7          	jalr	162(ra) # 47a2 <printf>
    exit(1);
    1708:	4505                	li	a0,1
    170a:	00003097          	auipc	ra,0x3
    170e:	d18080e7          	jalr	-744(ra) # 4422 <exit>

0000000000001712 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1712:	7139                	addi	sp,sp,-64
    1714:	fc06                	sd	ra,56(sp)
    1716:	f822                	sd	s0,48(sp)
    1718:	f426                	sd	s1,40(sp)
    171a:	f04a                	sd	s2,32(sp)
    171c:	ec4e                	sd	s3,24(sp)
    171e:	0080                	addi	s0,sp,64
    1720:	64b1                	lui	s1,0xc
    1722:	35048493          	addi	s1,s1,848 # c350 <__BSS_END__+0x110>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1726:	597d                	li	s2,-1
    1728:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    172c:	00003997          	auipc	s3,0x3
    1730:	7e498993          	addi	s3,s3,2020 # 4f10 <malloc+0x6b0>
    argv[0] = (char*)0xffffffff;
    1734:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1738:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    173c:	fc040593          	addi	a1,s0,-64
    1740:	854e                	mv	a0,s3
    1742:	00003097          	auipc	ra,0x3
    1746:	d18080e7          	jalr	-744(ra) # 445a <exec>
  for(int i = 0; i < 50000; i++){
    174a:	34fd                	addiw	s1,s1,-1
    174c:	f4e5                	bnez	s1,1734 <badarg+0x22>
  }
  
  exit(0);
    174e:	4501                	li	a0,0
    1750:	00003097          	auipc	ra,0x3
    1754:	cd2080e7          	jalr	-814(ra) # 4422 <exit>

0000000000001758 <pipe1>:
{
    1758:	711d                	addi	sp,sp,-96
    175a:	ec86                	sd	ra,88(sp)
    175c:	e8a2                	sd	s0,80(sp)
    175e:	e4a6                	sd	s1,72(sp)
    1760:	e0ca                	sd	s2,64(sp)
    1762:	fc4e                	sd	s3,56(sp)
    1764:	f852                	sd	s4,48(sp)
    1766:	f456                	sd	s5,40(sp)
    1768:	f05a                	sd	s6,32(sp)
    176a:	ec5e                	sd	s7,24(sp)
    176c:	1080                	addi	s0,sp,96
    176e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1770:	fa840513          	addi	a0,s0,-88
    1774:	00003097          	auipc	ra,0x3
    1778:	cbe080e7          	jalr	-834(ra) # 4432 <pipe>
    177c:	ed25                	bnez	a0,17f4 <pipe1+0x9c>
    177e:	84aa                	mv	s1,a0
  pid = fork();
    1780:	00003097          	auipc	ra,0x3
    1784:	c9a080e7          	jalr	-870(ra) # 441a <fork>
    1788:	8a2a                	mv	s4,a0
  if(pid == 0){
    178a:	c159                	beqz	a0,1810 <pipe1+0xb8>
  } else if(pid > 0){
    178c:	16a05e63          	blez	a0,1908 <pipe1+0x1b0>
    close(fds[1]);
    1790:	fac42503          	lw	a0,-84(s0)
    1794:	00003097          	auipc	ra,0x3
    1798:	cb6080e7          	jalr	-842(ra) # 444a <close>
    total = 0;
    179c:	8a26                	mv	s4,s1
    cc = 1;
    179e:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    17a0:	00008a97          	auipc	s5,0x8
    17a4:	a90a8a93          	addi	s5,s5,-1392 # 9230 <buf>
      if(cc > sizeof(buf))
    17a8:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17aa:	864e                	mv	a2,s3
    17ac:	85d6                	mv	a1,s5
    17ae:	fa842503          	lw	a0,-88(s0)
    17b2:	00003097          	auipc	ra,0x3
    17b6:	c88080e7          	jalr	-888(ra) # 443a <read>
    17ba:	10a05263          	blez	a0,18be <pipe1+0x166>
      for(i = 0; i < n; i++){
    17be:	00008717          	auipc	a4,0x8
    17c2:	a7270713          	addi	a4,a4,-1422 # 9230 <buf>
    17c6:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ca:	00074683          	lbu	a3,0(a4)
    17ce:	0ff4f793          	andi	a5,s1,255
    17d2:	2485                	addiw	s1,s1,1
    17d4:	0cf69163          	bne	a3,a5,1896 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17d8:	0705                	addi	a4,a4,1
    17da:	fec498e3          	bne	s1,a2,17ca <pipe1+0x72>
      total += n;
    17de:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17e2:	0019979b          	slliw	a5,s3,0x1
    17e6:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ea:	013b7363          	bgeu	s6,s3,17f0 <pipe1+0x98>
        cc = sizeof(buf);
    17ee:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17f0:	84b2                	mv	s1,a2
    17f2:	bf65                	j	17aa <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17f4:	85ca                	mv	a1,s2
    17f6:	00004517          	auipc	a0,0x4
    17fa:	e9a50513          	addi	a0,a0,-358 # 5690 <malloc+0xe30>
    17fe:	00003097          	auipc	ra,0x3
    1802:	fa4080e7          	jalr	-92(ra) # 47a2 <printf>
    exit(1);
    1806:	4505                	li	a0,1
    1808:	00003097          	auipc	ra,0x3
    180c:	c1a080e7          	jalr	-998(ra) # 4422 <exit>
    close(fds[0]);
    1810:	fa842503          	lw	a0,-88(s0)
    1814:	00003097          	auipc	ra,0x3
    1818:	c36080e7          	jalr	-970(ra) # 444a <close>
    for(n = 0; n < N; n++){
    181c:	00008b17          	auipc	s6,0x8
    1820:	a14b0b13          	addi	s6,s6,-1516 # 9230 <buf>
    1824:	416004bb          	negw	s1,s6
    1828:	0ff4f493          	andi	s1,s1,255
    182c:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1830:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1832:	6a85                	lui	s5,0x1
    1834:	42da8a93          	addi	s5,s5,1069 # 142d <unlinkread+0x1b3>
{
    1838:	87da                	mv	a5,s6
        buf[i] = seq++;
    183a:	0097873b          	addw	a4,a5,s1
    183e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1842:	0785                	addi	a5,a5,1
    1844:	fef99be3          	bne	s3,a5,183a <pipe1+0xe2>
        buf[i] = seq++;
    1848:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    184c:	40900613          	li	a2,1033
    1850:	85de                	mv	a1,s7
    1852:	fac42503          	lw	a0,-84(s0)
    1856:	00003097          	auipc	ra,0x3
    185a:	bec080e7          	jalr	-1044(ra) # 4442 <write>
    185e:	40900793          	li	a5,1033
    1862:	00f51c63          	bne	a0,a5,187a <pipe1+0x122>
    for(n = 0; n < N; n++){
    1866:	24a5                	addiw	s1,s1,9
    1868:	0ff4f493          	andi	s1,s1,255
    186c:	fd5a16e3          	bne	s4,s5,1838 <pipe1+0xe0>
    exit(0);
    1870:	4501                	li	a0,0
    1872:	00003097          	auipc	ra,0x3
    1876:	bb0080e7          	jalr	-1104(ra) # 4422 <exit>
        printf("%s: pipe1 oops 1\n", s);
    187a:	85ca                	mv	a1,s2
    187c:	00004517          	auipc	a0,0x4
    1880:	e2c50513          	addi	a0,a0,-468 # 56a8 <malloc+0xe48>
    1884:	00003097          	auipc	ra,0x3
    1888:	f1e080e7          	jalr	-226(ra) # 47a2 <printf>
        exit(1);
    188c:	4505                	li	a0,1
    188e:	00003097          	auipc	ra,0x3
    1892:	b94080e7          	jalr	-1132(ra) # 4422 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00004517          	auipc	a0,0x4
    189c:	e2850513          	addi	a0,a0,-472 # 56c0 <malloc+0xe60>
    18a0:	00003097          	auipc	ra,0x3
    18a4:	f02080e7          	jalr	-254(ra) # 47a2 <printf>
}
    18a8:	60e6                	ld	ra,88(sp)
    18aa:	6446                	ld	s0,80(sp)
    18ac:	64a6                	ld	s1,72(sp)
    18ae:	6906                	ld	s2,64(sp)
    18b0:	79e2                	ld	s3,56(sp)
    18b2:	7a42                	ld	s4,48(sp)
    18b4:	7aa2                	ld	s5,40(sp)
    18b6:	7b02                	ld	s6,32(sp)
    18b8:	6be2                	ld	s7,24(sp)
    18ba:	6125                	addi	sp,sp,96
    18bc:	8082                	ret
    if(total != N * SZ){
    18be:	6785                	lui	a5,0x1
    18c0:	42d78793          	addi	a5,a5,1069 # 142d <unlinkread+0x1b3>
    18c4:	02fa0063          	beq	s4,a5,18e4 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18c8:	85d2                	mv	a1,s4
    18ca:	00004517          	auipc	a0,0x4
    18ce:	e0e50513          	addi	a0,a0,-498 # 56d8 <malloc+0xe78>
    18d2:	00003097          	auipc	ra,0x3
    18d6:	ed0080e7          	jalr	-304(ra) # 47a2 <printf>
      exit(1);
    18da:	4505                	li	a0,1
    18dc:	00003097          	auipc	ra,0x3
    18e0:	b46080e7          	jalr	-1210(ra) # 4422 <exit>
    close(fds[0]);
    18e4:	fa842503          	lw	a0,-88(s0)
    18e8:	00003097          	auipc	ra,0x3
    18ec:	b62080e7          	jalr	-1182(ra) # 444a <close>
    wait(&xstatus);
    18f0:	fa440513          	addi	a0,s0,-92
    18f4:	00003097          	auipc	ra,0x3
    18f8:	b36080e7          	jalr	-1226(ra) # 442a <wait>
    exit(xstatus);
    18fc:	fa442503          	lw	a0,-92(s0)
    1900:	00003097          	auipc	ra,0x3
    1904:	b22080e7          	jalr	-1246(ra) # 4422 <exit>
    printf("%s: fork() failed\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00004517          	auipc	a0,0x4
    190e:	dee50513          	addi	a0,a0,-530 # 56f8 <malloc+0xe98>
    1912:	00003097          	auipc	ra,0x3
    1916:	e90080e7          	jalr	-368(ra) # 47a2 <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00003097          	auipc	ra,0x3
    1920:	b06080e7          	jalr	-1274(ra) # 4422 <exit>

0000000000001924 <pgbug>:
{
    1924:	7179                	addi	sp,sp,-48
    1926:	f406                	sd	ra,40(sp)
    1928:	f022                	sd	s0,32(sp)
    192a:	ec26                	sd	s1,24(sp)
    192c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    192e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1932:	00005497          	auipc	s1,0x5
    1936:	0ce4b483          	ld	s1,206(s1) # 6a00 <__SDATA_BEGIN__>
    193a:	fd840593          	addi	a1,s0,-40
    193e:	8526                	mv	a0,s1
    1940:	00003097          	auipc	ra,0x3
    1944:	b1a080e7          	jalr	-1254(ra) # 445a <exec>
  pipe((int*)0xeaeb0b5b00002f5e);
    1948:	8526                	mv	a0,s1
    194a:	00003097          	auipc	ra,0x3
    194e:	ae8080e7          	jalr	-1304(ra) # 4432 <pipe>
  exit(0);
    1952:	4501                	li	a0,0
    1954:	00003097          	auipc	ra,0x3
    1958:	ace080e7          	jalr	-1330(ra) # 4422 <exit>

000000000000195c <preempt>:
{
    195c:	7139                	addi	sp,sp,-64
    195e:	fc06                	sd	ra,56(sp)
    1960:	f822                	sd	s0,48(sp)
    1962:	f426                	sd	s1,40(sp)
    1964:	f04a                	sd	s2,32(sp)
    1966:	ec4e                	sd	s3,24(sp)
    1968:	e852                	sd	s4,16(sp)
    196a:	0080                	addi	s0,sp,64
    196c:	892a                	mv	s2,a0
  pid1 = fork();
    196e:	00003097          	auipc	ra,0x3
    1972:	aac080e7          	jalr	-1364(ra) # 441a <fork>
  if(pid1 < 0) {
    1976:	00054563          	bltz	a0,1980 <preempt+0x24>
    197a:	84aa                	mv	s1,a0
  if(pid1 == 0)
    197c:	ed19                	bnez	a0,199a <preempt+0x3e>
    for(;;)
    197e:	a001                	j	197e <preempt+0x22>
    printf("%s: fork failed");
    1980:	00003517          	auipc	a0,0x3
    1984:	44850513          	addi	a0,a0,1096 # 4dc8 <malloc+0x568>
    1988:	00003097          	auipc	ra,0x3
    198c:	e1a080e7          	jalr	-486(ra) # 47a2 <printf>
    exit(1);
    1990:	4505                	li	a0,1
    1992:	00003097          	auipc	ra,0x3
    1996:	a90080e7          	jalr	-1392(ra) # 4422 <exit>
  pid2 = fork();
    199a:	00003097          	auipc	ra,0x3
    199e:	a80080e7          	jalr	-1408(ra) # 441a <fork>
    19a2:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    19a4:	00054463          	bltz	a0,19ac <preempt+0x50>
  if(pid2 == 0)
    19a8:	e105                	bnez	a0,19c8 <preempt+0x6c>
    for(;;)
    19aa:	a001                	j	19aa <preempt+0x4e>
    printf("%s: fork failed\n", s);
    19ac:	85ca                	mv	a1,s2
    19ae:	00003517          	auipc	a0,0x3
    19b2:	3b250513          	addi	a0,a0,946 # 4d60 <malloc+0x500>
    19b6:	00003097          	auipc	ra,0x3
    19ba:	dec080e7          	jalr	-532(ra) # 47a2 <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	00003097          	auipc	ra,0x3
    19c4:	a62080e7          	jalr	-1438(ra) # 4422 <exit>
  pipe(pfds);
    19c8:	fc840513          	addi	a0,s0,-56
    19cc:	00003097          	auipc	ra,0x3
    19d0:	a66080e7          	jalr	-1434(ra) # 4432 <pipe>
  pid3 = fork();
    19d4:	00003097          	auipc	ra,0x3
    19d8:	a46080e7          	jalr	-1466(ra) # 441a <fork>
    19dc:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    19de:	02054e63          	bltz	a0,1a1a <preempt+0xbe>
  if(pid3 == 0){
    19e2:	e13d                	bnez	a0,1a48 <preempt+0xec>
    close(pfds[0]);
    19e4:	fc842503          	lw	a0,-56(s0)
    19e8:	00003097          	auipc	ra,0x3
    19ec:	a62080e7          	jalr	-1438(ra) # 444a <close>
    if(write(pfds[1], "x", 1) != 1)
    19f0:	4605                	li	a2,1
    19f2:	00004597          	auipc	a1,0x4
    19f6:	d1e58593          	addi	a1,a1,-738 # 5710 <malloc+0xeb0>
    19fa:	fcc42503          	lw	a0,-52(s0)
    19fe:	00003097          	auipc	ra,0x3
    1a02:	a44080e7          	jalr	-1468(ra) # 4442 <write>
    1a06:	4785                	li	a5,1
    1a08:	02f51763          	bne	a0,a5,1a36 <preempt+0xda>
    close(pfds[1]);
    1a0c:	fcc42503          	lw	a0,-52(s0)
    1a10:	00003097          	auipc	ra,0x3
    1a14:	a3a080e7          	jalr	-1478(ra) # 444a <close>
    for(;;)
    1a18:	a001                	j	1a18 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    1a1a:	85ca                	mv	a1,s2
    1a1c:	00003517          	auipc	a0,0x3
    1a20:	34450513          	addi	a0,a0,836 # 4d60 <malloc+0x500>
    1a24:	00003097          	auipc	ra,0x3
    1a28:	d7e080e7          	jalr	-642(ra) # 47a2 <printf>
     exit(1);
    1a2c:	4505                	li	a0,1
    1a2e:	00003097          	auipc	ra,0x3
    1a32:	9f4080e7          	jalr	-1548(ra) # 4422 <exit>
      printf("%s: preempt write error");
    1a36:	00004517          	auipc	a0,0x4
    1a3a:	ce250513          	addi	a0,a0,-798 # 5718 <malloc+0xeb8>
    1a3e:	00003097          	auipc	ra,0x3
    1a42:	d64080e7          	jalr	-668(ra) # 47a2 <printf>
    1a46:	b7d9                	j	1a0c <preempt+0xb0>
  close(pfds[1]);
    1a48:	fcc42503          	lw	a0,-52(s0)
    1a4c:	00003097          	auipc	ra,0x3
    1a50:	9fe080e7          	jalr	-1538(ra) # 444a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1a54:	660d                	lui	a2,0x3
    1a56:	00007597          	auipc	a1,0x7
    1a5a:	7da58593          	addi	a1,a1,2010 # 9230 <buf>
    1a5e:	fc842503          	lw	a0,-56(s0)
    1a62:	00003097          	auipc	ra,0x3
    1a66:	9d8080e7          	jalr	-1576(ra) # 443a <read>
    1a6a:	4785                	li	a5,1
    1a6c:	02f50263          	beq	a0,a5,1a90 <preempt+0x134>
    printf("%s: preempt read error");
    1a70:	00004517          	auipc	a0,0x4
    1a74:	cc050513          	addi	a0,a0,-832 # 5730 <malloc+0xed0>
    1a78:	00003097          	auipc	ra,0x3
    1a7c:	d2a080e7          	jalr	-726(ra) # 47a2 <printf>
}
    1a80:	70e2                	ld	ra,56(sp)
    1a82:	7442                	ld	s0,48(sp)
    1a84:	74a2                	ld	s1,40(sp)
    1a86:	7902                	ld	s2,32(sp)
    1a88:	69e2                	ld	s3,24(sp)
    1a8a:	6a42                	ld	s4,16(sp)
    1a8c:	6121                	addi	sp,sp,64
    1a8e:	8082                	ret
  close(pfds[0]);
    1a90:	fc842503          	lw	a0,-56(s0)
    1a94:	00003097          	auipc	ra,0x3
    1a98:	9b6080e7          	jalr	-1610(ra) # 444a <close>
  printf("kill... ");
    1a9c:	00004517          	auipc	a0,0x4
    1aa0:	cac50513          	addi	a0,a0,-852 # 5748 <malloc+0xee8>
    1aa4:	00003097          	auipc	ra,0x3
    1aa8:	cfe080e7          	jalr	-770(ra) # 47a2 <printf>
  kill(pid1);
    1aac:	8526                	mv	a0,s1
    1aae:	00003097          	auipc	ra,0x3
    1ab2:	9a4080e7          	jalr	-1628(ra) # 4452 <kill>
  kill(pid2);
    1ab6:	854e                	mv	a0,s3
    1ab8:	00003097          	auipc	ra,0x3
    1abc:	99a080e7          	jalr	-1638(ra) # 4452 <kill>
  kill(pid3);
    1ac0:	8552                	mv	a0,s4
    1ac2:	00003097          	auipc	ra,0x3
    1ac6:	990080e7          	jalr	-1648(ra) # 4452 <kill>
  printf("wait... ");
    1aca:	00004517          	auipc	a0,0x4
    1ace:	c8e50513          	addi	a0,a0,-882 # 5758 <malloc+0xef8>
    1ad2:	00003097          	auipc	ra,0x3
    1ad6:	cd0080e7          	jalr	-816(ra) # 47a2 <printf>
  wait(0);
    1ada:	4501                	li	a0,0
    1adc:	00003097          	auipc	ra,0x3
    1ae0:	94e080e7          	jalr	-1714(ra) # 442a <wait>
  wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00003097          	auipc	ra,0x3
    1aea:	944080e7          	jalr	-1724(ra) # 442a <wait>
  wait(0);
    1aee:	4501                	li	a0,0
    1af0:	00003097          	auipc	ra,0x3
    1af4:	93a080e7          	jalr	-1734(ra) # 442a <wait>
    1af8:	b761                	j	1a80 <preempt+0x124>

0000000000001afa <reparent>:
{
    1afa:	7179                	addi	sp,sp,-48
    1afc:	f406                	sd	ra,40(sp)
    1afe:	f022                	sd	s0,32(sp)
    1b00:	ec26                	sd	s1,24(sp)
    1b02:	e84a                	sd	s2,16(sp)
    1b04:	e44e                	sd	s3,8(sp)
    1b06:	e052                	sd	s4,0(sp)
    1b08:	1800                	addi	s0,sp,48
    1b0a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    1b0c:	00003097          	auipc	ra,0x3
    1b10:	996080e7          	jalr	-1642(ra) # 44a2 <getpid>
    1b14:	8a2a                	mv	s4,a0
    1b16:	0c800913          	li	s2,200
    int pid = fork();
    1b1a:	00003097          	auipc	ra,0x3
    1b1e:	900080e7          	jalr	-1792(ra) # 441a <fork>
    1b22:	84aa                	mv	s1,a0
    if(pid < 0){
    1b24:	02054263          	bltz	a0,1b48 <reparent+0x4e>
    if(pid){
    1b28:	cd21                	beqz	a0,1b80 <reparent+0x86>
      if(wait(0) != pid){
    1b2a:	4501                	li	a0,0
    1b2c:	00003097          	auipc	ra,0x3
    1b30:	8fe080e7          	jalr	-1794(ra) # 442a <wait>
    1b34:	02951863          	bne	a0,s1,1b64 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    1b38:	397d                	addiw	s2,s2,-1
    1b3a:	fe0910e3          	bnez	s2,1b1a <reparent+0x20>
  exit(0);
    1b3e:	4501                	li	a0,0
    1b40:	00003097          	auipc	ra,0x3
    1b44:	8e2080e7          	jalr	-1822(ra) # 4422 <exit>
      printf("%s: fork failed\n", s);
    1b48:	85ce                	mv	a1,s3
    1b4a:	00003517          	auipc	a0,0x3
    1b4e:	21650513          	addi	a0,a0,534 # 4d60 <malloc+0x500>
    1b52:	00003097          	auipc	ra,0x3
    1b56:	c50080e7          	jalr	-944(ra) # 47a2 <printf>
      exit(1);
    1b5a:	4505                	li	a0,1
    1b5c:	00003097          	auipc	ra,0x3
    1b60:	8c6080e7          	jalr	-1850(ra) # 4422 <exit>
        printf("%s: wait wrong pid\n", s);
    1b64:	85ce                	mv	a1,s3
    1b66:	00003517          	auipc	a0,0x3
    1b6a:	22a50513          	addi	a0,a0,554 # 4d90 <malloc+0x530>
    1b6e:	00003097          	auipc	ra,0x3
    1b72:	c34080e7          	jalr	-972(ra) # 47a2 <printf>
        exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	8aa080e7          	jalr	-1878(ra) # 4422 <exit>
      int pid2 = fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	89a080e7          	jalr	-1894(ra) # 441a <fork>
      if(pid2 < 0){
    1b88:	00054763          	bltz	a0,1b96 <reparent+0x9c>
      exit(0);
    1b8c:	4501                	li	a0,0
    1b8e:	00003097          	auipc	ra,0x3
    1b92:	894080e7          	jalr	-1900(ra) # 4422 <exit>
        kill(master_pid);
    1b96:	8552                	mv	a0,s4
    1b98:	00003097          	auipc	ra,0x3
    1b9c:	8ba080e7          	jalr	-1862(ra) # 4452 <kill>
        exit(1);
    1ba0:	4505                	li	a0,1
    1ba2:	00003097          	auipc	ra,0x3
    1ba6:	880080e7          	jalr	-1920(ra) # 4422 <exit>

0000000000001baa <mem>:
{
    1baa:	7139                	addi	sp,sp,-64
    1bac:	fc06                	sd	ra,56(sp)
    1bae:	f822                	sd	s0,48(sp)
    1bb0:	f426                	sd	s1,40(sp)
    1bb2:	f04a                	sd	s2,32(sp)
    1bb4:	ec4e                	sd	s3,24(sp)
    1bb6:	0080                	addi	s0,sp,64
    1bb8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    1bba:	00003097          	auipc	ra,0x3
    1bbe:	860080e7          	jalr	-1952(ra) # 441a <fork>
    m1 = 0;
    1bc2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    1bc4:	6909                	lui	s2,0x2
    1bc6:	71190913          	addi	s2,s2,1809 # 2711 <concreate+0x2ad>
  if((pid = fork()) == 0){
    1bca:	cd19                	beqz	a0,1be8 <mem+0x3e>
    wait(&xstatus);
    1bcc:	fcc40513          	addi	a0,s0,-52
    1bd0:	00003097          	auipc	ra,0x3
    1bd4:	85a080e7          	jalr	-1958(ra) # 442a <wait>
    exit(xstatus);
    1bd8:	fcc42503          	lw	a0,-52(s0)
    1bdc:	00003097          	auipc	ra,0x3
    1be0:	846080e7          	jalr	-1978(ra) # 4422 <exit>
      *(char**)m2 = m1;
    1be4:	e104                	sd	s1,0(a0)
      m1 = m2;
    1be6:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    1be8:	854a                	mv	a0,s2
    1bea:	00003097          	auipc	ra,0x3
    1bee:	c76080e7          	jalr	-906(ra) # 4860 <malloc>
    1bf2:	f96d                	bnez	a0,1be4 <mem+0x3a>
    while(m1){
    1bf4:	c881                	beqz	s1,1c04 <mem+0x5a>
      m2 = *(char**)m1;
    1bf6:	8526                	mv	a0,s1
    1bf8:	6084                	ld	s1,0(s1)
      free(m1);
    1bfa:	00003097          	auipc	ra,0x3
    1bfe:	bde080e7          	jalr	-1058(ra) # 47d8 <free>
    while(m1){
    1c02:	f8f5                	bnez	s1,1bf6 <mem+0x4c>
    m1 = malloc(1024*20);
    1c04:	6515                	lui	a0,0x5
    1c06:	00003097          	auipc	ra,0x3
    1c0a:	c5a080e7          	jalr	-934(ra) # 4860 <malloc>
    if(m1 == 0){
    1c0e:	c911                	beqz	a0,1c22 <mem+0x78>
    free(m1);
    1c10:	00003097          	auipc	ra,0x3
    1c14:	bc8080e7          	jalr	-1080(ra) # 47d8 <free>
    exit(0);
    1c18:	4501                	li	a0,0
    1c1a:	00003097          	auipc	ra,0x3
    1c1e:	808080e7          	jalr	-2040(ra) # 4422 <exit>
      printf("couldn't allocate mem?!!\n", s);
    1c22:	85ce                	mv	a1,s3
    1c24:	00004517          	auipc	a0,0x4
    1c28:	b4450513          	addi	a0,a0,-1212 # 5768 <malloc+0xf08>
    1c2c:	00003097          	auipc	ra,0x3
    1c30:	b76080e7          	jalr	-1162(ra) # 47a2 <printf>
      exit(1);
    1c34:	4505                	li	a0,1
    1c36:	00002097          	auipc	ra,0x2
    1c3a:	7ec080e7          	jalr	2028(ra) # 4422 <exit>

0000000000001c3e <sharedfd>:
{
    1c3e:	7159                	addi	sp,sp,-112
    1c40:	f486                	sd	ra,104(sp)
    1c42:	f0a2                	sd	s0,96(sp)
    1c44:	eca6                	sd	s1,88(sp)
    1c46:	e8ca                	sd	s2,80(sp)
    1c48:	e4ce                	sd	s3,72(sp)
    1c4a:	e0d2                	sd	s4,64(sp)
    1c4c:	fc56                	sd	s5,56(sp)
    1c4e:	f85a                	sd	s6,48(sp)
    1c50:	f45e                	sd	s7,40(sp)
    1c52:	1880                	addi	s0,sp,112
    1c54:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    1c56:	00003517          	auipc	a0,0x3
    1c5a:	dfa50513          	addi	a0,a0,-518 # 4a50 <malloc+0x1f0>
    1c5e:	00003097          	auipc	ra,0x3
    1c62:	814080e7          	jalr	-2028(ra) # 4472 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1c66:	20200593          	li	a1,514
    1c6a:	00003517          	auipc	a0,0x3
    1c6e:	de650513          	addi	a0,a0,-538 # 4a50 <malloc+0x1f0>
    1c72:	00002097          	auipc	ra,0x2
    1c76:	7f0080e7          	jalr	2032(ra) # 4462 <open>
  if(fd < 0){
    1c7a:	04054a63          	bltz	a0,1cce <sharedfd+0x90>
    1c7e:	892a                	mv	s2,a0
  pid = fork();
    1c80:	00002097          	auipc	ra,0x2
    1c84:	79a080e7          	jalr	1946(ra) # 441a <fork>
    1c88:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1c8a:	06300593          	li	a1,99
    1c8e:	c119                	beqz	a0,1c94 <sharedfd+0x56>
    1c90:	07000593          	li	a1,112
    1c94:	4629                	li	a2,10
    1c96:	fa040513          	addi	a0,s0,-96
    1c9a:	00002097          	auipc	ra,0x2
    1c9e:	58c080e7          	jalr	1420(ra) # 4226 <memset>
    1ca2:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1ca6:	4629                	li	a2,10
    1ca8:	fa040593          	addi	a1,s0,-96
    1cac:	854a                	mv	a0,s2
    1cae:	00002097          	auipc	ra,0x2
    1cb2:	794080e7          	jalr	1940(ra) # 4442 <write>
    1cb6:	47a9                	li	a5,10
    1cb8:	02f51963          	bne	a0,a5,1cea <sharedfd+0xac>
  for(i = 0; i < N; i++){
    1cbc:	34fd                	addiw	s1,s1,-1
    1cbe:	f4e5                	bnez	s1,1ca6 <sharedfd+0x68>
  if(pid == 0) {
    1cc0:	04099363          	bnez	s3,1d06 <sharedfd+0xc8>
    exit(0);
    1cc4:	4501                	li	a0,0
    1cc6:	00002097          	auipc	ra,0x2
    1cca:	75c080e7          	jalr	1884(ra) # 4422 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    1cce:	85d2                	mv	a1,s4
    1cd0:	00004517          	auipc	a0,0x4
    1cd4:	ab850513          	addi	a0,a0,-1352 # 5788 <malloc+0xf28>
    1cd8:	00003097          	auipc	ra,0x3
    1cdc:	aca080e7          	jalr	-1334(ra) # 47a2 <printf>
    exit(1);
    1ce0:	4505                	li	a0,1
    1ce2:	00002097          	auipc	ra,0x2
    1ce6:	740080e7          	jalr	1856(ra) # 4422 <exit>
      printf("%s: write sharedfd failed\n", s);
    1cea:	85d2                	mv	a1,s4
    1cec:	00004517          	auipc	a0,0x4
    1cf0:	ac450513          	addi	a0,a0,-1340 # 57b0 <malloc+0xf50>
    1cf4:	00003097          	auipc	ra,0x3
    1cf8:	aae080e7          	jalr	-1362(ra) # 47a2 <printf>
      exit(1);
    1cfc:	4505                	li	a0,1
    1cfe:	00002097          	auipc	ra,0x2
    1d02:	724080e7          	jalr	1828(ra) # 4422 <exit>
    wait(&xstatus);
    1d06:	f9c40513          	addi	a0,s0,-100
    1d0a:	00002097          	auipc	ra,0x2
    1d0e:	720080e7          	jalr	1824(ra) # 442a <wait>
    if(xstatus != 0)
    1d12:	f9c42983          	lw	s3,-100(s0)
    1d16:	00098763          	beqz	s3,1d24 <sharedfd+0xe6>
      exit(xstatus);
    1d1a:	854e                	mv	a0,s3
    1d1c:	00002097          	auipc	ra,0x2
    1d20:	706080e7          	jalr	1798(ra) # 4422 <exit>
  close(fd);
    1d24:	854a                	mv	a0,s2
    1d26:	00002097          	auipc	ra,0x2
    1d2a:	724080e7          	jalr	1828(ra) # 444a <close>
  fd = open("sharedfd", 0);
    1d2e:	4581                	li	a1,0
    1d30:	00003517          	auipc	a0,0x3
    1d34:	d2050513          	addi	a0,a0,-736 # 4a50 <malloc+0x1f0>
    1d38:	00002097          	auipc	ra,0x2
    1d3c:	72a080e7          	jalr	1834(ra) # 4462 <open>
    1d40:	8baa                	mv	s7,a0
  nc = np = 0;
    1d42:	8ace                	mv	s5,s3
  if(fd < 0){
    1d44:	02054563          	bltz	a0,1d6e <sharedfd+0x130>
    1d48:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    1d4c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    1d50:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1d54:	4629                	li	a2,10
    1d56:	fa040593          	addi	a1,s0,-96
    1d5a:	855e                	mv	a0,s7
    1d5c:	00002097          	auipc	ra,0x2
    1d60:	6de080e7          	jalr	1758(ra) # 443a <read>
    1d64:	02a05f63          	blez	a0,1da2 <sharedfd+0x164>
    1d68:	fa040793          	addi	a5,s0,-96
    1d6c:	a01d                	j	1d92 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    1d6e:	85d2                	mv	a1,s4
    1d70:	00004517          	auipc	a0,0x4
    1d74:	a6050513          	addi	a0,a0,-1440 # 57d0 <malloc+0xf70>
    1d78:	00003097          	auipc	ra,0x3
    1d7c:	a2a080e7          	jalr	-1494(ra) # 47a2 <printf>
    exit(1);
    1d80:	4505                	li	a0,1
    1d82:	00002097          	auipc	ra,0x2
    1d86:	6a0080e7          	jalr	1696(ra) # 4422 <exit>
        nc++;
    1d8a:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    1d8c:	0785                	addi	a5,a5,1
    1d8e:	fd2783e3          	beq	a5,s2,1d54 <sharedfd+0x116>
      if(buf[i] == 'c')
    1d92:	0007c703          	lbu	a4,0(a5)
    1d96:	fe970ae3          	beq	a4,s1,1d8a <sharedfd+0x14c>
      if(buf[i] == 'p')
    1d9a:	ff6719e3          	bne	a4,s6,1d8c <sharedfd+0x14e>
        np++;
    1d9e:	2a85                	addiw	s5,s5,1
    1da0:	b7f5                	j	1d8c <sharedfd+0x14e>
  close(fd);
    1da2:	855e                	mv	a0,s7
    1da4:	00002097          	auipc	ra,0x2
    1da8:	6a6080e7          	jalr	1702(ra) # 444a <close>
  unlink("sharedfd");
    1dac:	00003517          	auipc	a0,0x3
    1db0:	ca450513          	addi	a0,a0,-860 # 4a50 <malloc+0x1f0>
    1db4:	00002097          	auipc	ra,0x2
    1db8:	6be080e7          	jalr	1726(ra) # 4472 <unlink>
  if(nc == N*SZ && np == N*SZ){
    1dbc:	6789                	lui	a5,0x2
    1dbe:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2ac>
    1dc2:	00f99763          	bne	s3,a5,1dd0 <sharedfd+0x192>
    1dc6:	6789                	lui	a5,0x2
    1dc8:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2ac>
    1dcc:	02fa8063          	beq	s5,a5,1dec <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    1dd0:	85d2                	mv	a1,s4
    1dd2:	00004517          	auipc	a0,0x4
    1dd6:	a2650513          	addi	a0,a0,-1498 # 57f8 <malloc+0xf98>
    1dda:	00003097          	auipc	ra,0x3
    1dde:	9c8080e7          	jalr	-1592(ra) # 47a2 <printf>
    exit(1);
    1de2:	4505                	li	a0,1
    1de4:	00002097          	auipc	ra,0x2
    1de8:	63e080e7          	jalr	1598(ra) # 4422 <exit>
    exit(0);
    1dec:	4501                	li	a0,0
    1dee:	00002097          	auipc	ra,0x2
    1df2:	634080e7          	jalr	1588(ra) # 4422 <exit>

0000000000001df6 <fourfiles>:
{
    1df6:	7171                	addi	sp,sp,-176
    1df8:	f506                	sd	ra,168(sp)
    1dfa:	f122                	sd	s0,160(sp)
    1dfc:	ed26                	sd	s1,152(sp)
    1dfe:	e94a                	sd	s2,144(sp)
    1e00:	e54e                	sd	s3,136(sp)
    1e02:	e152                	sd	s4,128(sp)
    1e04:	fcd6                	sd	s5,120(sp)
    1e06:	f8da                	sd	s6,112(sp)
    1e08:	f4de                	sd	s7,104(sp)
    1e0a:	f0e2                	sd	s8,96(sp)
    1e0c:	ece6                	sd	s9,88(sp)
    1e0e:	e8ea                	sd	s10,80(sp)
    1e10:	e4ee                	sd	s11,72(sp)
    1e12:	1900                	addi	s0,sp,176
    1e14:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e18:	00003797          	auipc	a5,0x3
    1e1c:	b3078793          	addi	a5,a5,-1232 # 4948 <malloc+0xe8>
    1e20:	f6f43823          	sd	a5,-144(s0)
    1e24:	00003797          	auipc	a5,0x3
    1e28:	b2c78793          	addi	a5,a5,-1236 # 4950 <malloc+0xf0>
    1e2c:	f6f43c23          	sd	a5,-136(s0)
    1e30:	00003797          	auipc	a5,0x3
    1e34:	b2878793          	addi	a5,a5,-1240 # 4958 <malloc+0xf8>
    1e38:	f8f43023          	sd	a5,-128(s0)
    1e3c:	00003797          	auipc	a5,0x3
    1e40:	b2478793          	addi	a5,a5,-1244 # 4960 <malloc+0x100>
    1e44:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    1e48:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e4c:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    1e4e:	4481                	li	s1,0
    1e50:	4a11                	li	s4,4
    fname = names[pi];
    1e52:	00093983          	ld	s3,0(s2)
    unlink(fname);
    1e56:	854e                	mv	a0,s3
    1e58:	00002097          	auipc	ra,0x2
    1e5c:	61a080e7          	jalr	1562(ra) # 4472 <unlink>
    pid = fork();
    1e60:	00002097          	auipc	ra,0x2
    1e64:	5ba080e7          	jalr	1466(ra) # 441a <fork>
    if(pid < 0){
    1e68:	04054463          	bltz	a0,1eb0 <fourfiles+0xba>
    if(pid == 0){
    1e6c:	c12d                	beqz	a0,1ece <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    1e6e:	2485                	addiw	s1,s1,1
    1e70:	0921                	addi	s2,s2,8
    1e72:	ff4490e3          	bne	s1,s4,1e52 <fourfiles+0x5c>
    1e76:	4491                	li	s1,4
    wait(&xstatus);
    1e78:	f6c40513          	addi	a0,s0,-148
    1e7c:	00002097          	auipc	ra,0x2
    1e80:	5ae080e7          	jalr	1454(ra) # 442a <wait>
    if(xstatus != 0)
    1e84:	f6c42b03          	lw	s6,-148(s0)
    1e88:	0c0b1e63          	bnez	s6,1f64 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    1e8c:	34fd                	addiw	s1,s1,-1
    1e8e:	f4ed                	bnez	s1,1e78 <fourfiles+0x82>
    1e90:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1e94:	00007a17          	auipc	s4,0x7
    1e98:	39ca0a13          	addi	s4,s4,924 # 9230 <buf>
    1e9c:	00007a97          	auipc	s5,0x7
    1ea0:	395a8a93          	addi	s5,s5,917 # 9231 <buf+0x1>
    if(total != N*SZ){
    1ea4:	6d85                	lui	s11,0x1
    1ea6:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x18>
  for(i = 0; i < NCHILD; i++){
    1eaa:	03400d13          	li	s10,52
    1eae:	aa1d                	j	1fe4 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    1eb0:	f5843583          	ld	a1,-168(s0)
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	7ac50513          	addi	a0,a0,1964 # 5660 <malloc+0xe00>
    1ebc:	00003097          	auipc	ra,0x3
    1ec0:	8e6080e7          	jalr	-1818(ra) # 47a2 <printf>
      exit(1);
    1ec4:	4505                	li	a0,1
    1ec6:	00002097          	auipc	ra,0x2
    1eca:	55c080e7          	jalr	1372(ra) # 4422 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1ece:	20200593          	li	a1,514
    1ed2:	854e                	mv	a0,s3
    1ed4:	00002097          	auipc	ra,0x2
    1ed8:	58e080e7          	jalr	1422(ra) # 4462 <open>
    1edc:	892a                	mv	s2,a0
      if(fd < 0){
    1ede:	04054763          	bltz	a0,1f2c <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    1ee2:	1f400613          	li	a2,500
    1ee6:	0304859b          	addiw	a1,s1,48
    1eea:	00007517          	auipc	a0,0x7
    1eee:	34650513          	addi	a0,a0,838 # 9230 <buf>
    1ef2:	00002097          	auipc	ra,0x2
    1ef6:	334080e7          	jalr	820(ra) # 4226 <memset>
    1efa:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    1efc:	00007997          	auipc	s3,0x7
    1f00:	33498993          	addi	s3,s3,820 # 9230 <buf>
    1f04:	1f400613          	li	a2,500
    1f08:	85ce                	mv	a1,s3
    1f0a:	854a                	mv	a0,s2
    1f0c:	00002097          	auipc	ra,0x2
    1f10:	536080e7          	jalr	1334(ra) # 4442 <write>
    1f14:	85aa                	mv	a1,a0
    1f16:	1f400793          	li	a5,500
    1f1a:	02f51863          	bne	a0,a5,1f4a <fourfiles+0x154>
      for(i = 0; i < N; i++){
    1f1e:	34fd                	addiw	s1,s1,-1
    1f20:	f0f5                	bnez	s1,1f04 <fourfiles+0x10e>
      exit(0);
    1f22:	4501                	li	a0,0
    1f24:	00002097          	auipc	ra,0x2
    1f28:	4fe080e7          	jalr	1278(ra) # 4422 <exit>
        printf("create failed\n", s);
    1f2c:	f5843583          	ld	a1,-168(s0)
    1f30:	00004517          	auipc	a0,0x4
    1f34:	8e050513          	addi	a0,a0,-1824 # 5810 <malloc+0xfb0>
    1f38:	00003097          	auipc	ra,0x3
    1f3c:	86a080e7          	jalr	-1942(ra) # 47a2 <printf>
        exit(1);
    1f40:	4505                	li	a0,1
    1f42:	00002097          	auipc	ra,0x2
    1f46:	4e0080e7          	jalr	1248(ra) # 4422 <exit>
          printf("write failed %d\n", n);
    1f4a:	00004517          	auipc	a0,0x4
    1f4e:	8d650513          	addi	a0,a0,-1834 # 5820 <malloc+0xfc0>
    1f52:	00003097          	auipc	ra,0x3
    1f56:	850080e7          	jalr	-1968(ra) # 47a2 <printf>
          exit(1);
    1f5a:	4505                	li	a0,1
    1f5c:	00002097          	auipc	ra,0x2
    1f60:	4c6080e7          	jalr	1222(ra) # 4422 <exit>
      exit(xstatus);
    1f64:	855a                	mv	a0,s6
    1f66:	00002097          	auipc	ra,0x2
    1f6a:	4bc080e7          	jalr	1212(ra) # 4422 <exit>
          printf("wrong char\n", s);
    1f6e:	f5843583          	ld	a1,-168(s0)
    1f72:	00004517          	auipc	a0,0x4
    1f76:	8c650513          	addi	a0,a0,-1850 # 5838 <malloc+0xfd8>
    1f7a:	00003097          	auipc	ra,0x3
    1f7e:	828080e7          	jalr	-2008(ra) # 47a2 <printf>
          exit(1);
    1f82:	4505                	li	a0,1
    1f84:	00002097          	auipc	ra,0x2
    1f88:	49e080e7          	jalr	1182(ra) # 4422 <exit>
      total += n;
    1f8c:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f90:	660d                	lui	a2,0x3
    1f92:	85d2                	mv	a1,s4
    1f94:	854e                	mv	a0,s3
    1f96:	00002097          	auipc	ra,0x2
    1f9a:	4a4080e7          	jalr	1188(ra) # 443a <read>
    1f9e:	02a05363          	blez	a0,1fc4 <fourfiles+0x1ce>
    1fa2:	00007797          	auipc	a5,0x7
    1fa6:	28e78793          	addi	a5,a5,654 # 9230 <buf>
    1faa:	fff5069b          	addiw	a3,a0,-1
    1fae:	1682                	slli	a3,a3,0x20
    1fb0:	9281                	srli	a3,a3,0x20
    1fb2:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    1fb4:	0007c703          	lbu	a4,0(a5)
    1fb8:	fa971be3          	bne	a4,s1,1f6e <fourfiles+0x178>
      for(j = 0; j < n; j++){
    1fbc:	0785                	addi	a5,a5,1
    1fbe:	fed79be3          	bne	a5,a3,1fb4 <fourfiles+0x1be>
    1fc2:	b7e9                	j	1f8c <fourfiles+0x196>
    close(fd);
    1fc4:	854e                	mv	a0,s3
    1fc6:	00002097          	auipc	ra,0x2
    1fca:	484080e7          	jalr	1156(ra) # 444a <close>
    if(total != N*SZ){
    1fce:	03b91863          	bne	s2,s11,1ffe <fourfiles+0x208>
    unlink(fname);
    1fd2:	8566                	mv	a0,s9
    1fd4:	00002097          	auipc	ra,0x2
    1fd8:	49e080e7          	jalr	1182(ra) # 4472 <unlink>
  for(i = 0; i < NCHILD; i++){
    1fdc:	0c21                	addi	s8,s8,8
    1fde:	2b85                	addiw	s7,s7,1
    1fe0:	03ab8d63          	beq	s7,s10,201a <fourfiles+0x224>
    fname = names[i];
    1fe4:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    1fe8:	4581                	li	a1,0
    1fea:	8566                	mv	a0,s9
    1fec:	00002097          	auipc	ra,0x2
    1ff0:	476080e7          	jalr	1142(ra) # 4462 <open>
    1ff4:	89aa                	mv	s3,a0
    total = 0;
    1ff6:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    1ff8:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1ffc:	bf51                	j	1f90 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    1ffe:	85ca                	mv	a1,s2
    2000:	00004517          	auipc	a0,0x4
    2004:	84850513          	addi	a0,a0,-1976 # 5848 <malloc+0xfe8>
    2008:	00002097          	auipc	ra,0x2
    200c:	79a080e7          	jalr	1946(ra) # 47a2 <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00002097          	auipc	ra,0x2
    2016:	410080e7          	jalr	1040(ra) # 4422 <exit>
}
    201a:	70aa                	ld	ra,168(sp)
    201c:	740a                	ld	s0,160(sp)
    201e:	64ea                	ld	s1,152(sp)
    2020:	694a                	ld	s2,144(sp)
    2022:	69aa                	ld	s3,136(sp)
    2024:	6a0a                	ld	s4,128(sp)
    2026:	7ae6                	ld	s5,120(sp)
    2028:	7b46                	ld	s6,112(sp)
    202a:	7ba6                	ld	s7,104(sp)
    202c:	7c06                	ld	s8,96(sp)
    202e:	6ce6                	ld	s9,88(sp)
    2030:	6d46                	ld	s10,80(sp)
    2032:	6da6                	ld	s11,72(sp)
    2034:	614d                	addi	sp,sp,176
    2036:	8082                	ret

0000000000002038 <bigfile>:
{
    2038:	7139                	addi	sp,sp,-64
    203a:	fc06                	sd	ra,56(sp)
    203c:	f822                	sd	s0,48(sp)
    203e:	f426                	sd	s1,40(sp)
    2040:	f04a                	sd	s2,32(sp)
    2042:	ec4e                	sd	s3,24(sp)
    2044:	e852                	sd	s4,16(sp)
    2046:	e456                	sd	s5,8(sp)
    2048:	0080                	addi	s0,sp,64
    204a:	8aaa                	mv	s5,a0
  unlink("bigfile.test");
    204c:	00004517          	auipc	a0,0x4
    2050:	81450513          	addi	a0,a0,-2028 # 5860 <malloc+0x1000>
    2054:	00002097          	auipc	ra,0x2
    2058:	41e080e7          	jalr	1054(ra) # 4472 <unlink>
  fd = open("bigfile.test", O_CREATE | O_RDWR);
    205c:	20200593          	li	a1,514
    2060:	00004517          	auipc	a0,0x4
    2064:	80050513          	addi	a0,a0,-2048 # 5860 <malloc+0x1000>
    2068:	00002097          	auipc	ra,0x2
    206c:	3fa080e7          	jalr	1018(ra) # 4462 <open>
    2070:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    2072:	4481                	li	s1,0
    memset(buf, i, SZ);
    2074:	00007917          	auipc	s2,0x7
    2078:	1bc90913          	addi	s2,s2,444 # 9230 <buf>
  for(i = 0; i < N; i++){
    207c:	4a51                	li	s4,20
  if(fd < 0){
    207e:	0a054063          	bltz	a0,211e <bigfile+0xe6>
    memset(buf, i, SZ);
    2082:	25800613          	li	a2,600
    2086:	85a6                	mv	a1,s1
    2088:	854a                	mv	a0,s2
    208a:	00002097          	auipc	ra,0x2
    208e:	19c080e7          	jalr	412(ra) # 4226 <memset>
    if(write(fd, buf, SZ) != SZ){
    2092:	25800613          	li	a2,600
    2096:	85ca                	mv	a1,s2
    2098:	854e                	mv	a0,s3
    209a:	00002097          	auipc	ra,0x2
    209e:	3a8080e7          	jalr	936(ra) # 4442 <write>
    20a2:	25800793          	li	a5,600
    20a6:	08f51a63          	bne	a0,a5,213a <bigfile+0x102>
  for(i = 0; i < N; i++){
    20aa:	2485                	addiw	s1,s1,1
    20ac:	fd449be3          	bne	s1,s4,2082 <bigfile+0x4a>
  close(fd);
    20b0:	854e                	mv	a0,s3
    20b2:	00002097          	auipc	ra,0x2
    20b6:	398080e7          	jalr	920(ra) # 444a <close>
  fd = open("bigfile.test", 0);
    20ba:	4581                	li	a1,0
    20bc:	00003517          	auipc	a0,0x3
    20c0:	7a450513          	addi	a0,a0,1956 # 5860 <malloc+0x1000>
    20c4:	00002097          	auipc	ra,0x2
    20c8:	39e080e7          	jalr	926(ra) # 4462 <open>
    20cc:	8a2a                	mv	s4,a0
  total = 0;
    20ce:	4981                	li	s3,0
  for(i = 0; ; i++){
    20d0:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    20d2:	00007917          	auipc	s2,0x7
    20d6:	15e90913          	addi	s2,s2,350 # 9230 <buf>
  if(fd < 0){
    20da:	06054e63          	bltz	a0,2156 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    20de:	12c00613          	li	a2,300
    20e2:	85ca                	mv	a1,s2
    20e4:	8552                	mv	a0,s4
    20e6:	00002097          	auipc	ra,0x2
    20ea:	354080e7          	jalr	852(ra) # 443a <read>
    if(cc < 0){
    20ee:	08054263          	bltz	a0,2172 <bigfile+0x13a>
    if(cc == 0)
    20f2:	c971                	beqz	a0,21c6 <bigfile+0x18e>
    if(cc != SZ/2){
    20f4:	12c00793          	li	a5,300
    20f8:	08f51b63          	bne	a0,a5,218e <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    20fc:	01f4d79b          	srliw	a5,s1,0x1f
    2100:	9fa5                	addw	a5,a5,s1
    2102:	4017d79b          	sraiw	a5,a5,0x1
    2106:	00094703          	lbu	a4,0(s2)
    210a:	0af71063          	bne	a4,a5,21aa <bigfile+0x172>
    210e:	12b94703          	lbu	a4,299(s2)
    2112:	08f71c63          	bne	a4,a5,21aa <bigfile+0x172>
    total += cc;
    2116:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    211a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    211c:	b7c9                	j	20de <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    211e:	85d6                	mv	a1,s5
    2120:	00003517          	auipc	a0,0x3
    2124:	75050513          	addi	a0,a0,1872 # 5870 <malloc+0x1010>
    2128:	00002097          	auipc	ra,0x2
    212c:	67a080e7          	jalr	1658(ra) # 47a2 <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	00002097          	auipc	ra,0x2
    2136:	2f0080e7          	jalr	752(ra) # 4422 <exit>
      printf("%s: write bigfile failed\n", s);
    213a:	85d6                	mv	a1,s5
    213c:	00003517          	auipc	a0,0x3
    2140:	75450513          	addi	a0,a0,1876 # 5890 <malloc+0x1030>
    2144:	00002097          	auipc	ra,0x2
    2148:	65e080e7          	jalr	1630(ra) # 47a2 <printf>
      exit(1);
    214c:	4505                	li	a0,1
    214e:	00002097          	auipc	ra,0x2
    2152:	2d4080e7          	jalr	724(ra) # 4422 <exit>
    printf("%s: cannot open bigfile\n", s);
    2156:	85d6                	mv	a1,s5
    2158:	00003517          	auipc	a0,0x3
    215c:	75850513          	addi	a0,a0,1880 # 58b0 <malloc+0x1050>
    2160:	00002097          	auipc	ra,0x2
    2164:	642080e7          	jalr	1602(ra) # 47a2 <printf>
    exit(1);
    2168:	4505                	li	a0,1
    216a:	00002097          	auipc	ra,0x2
    216e:	2b8080e7          	jalr	696(ra) # 4422 <exit>
      printf("%s: read bigfile failed\n", s);
    2172:	85d6                	mv	a1,s5
    2174:	00003517          	auipc	a0,0x3
    2178:	75c50513          	addi	a0,a0,1884 # 58d0 <malloc+0x1070>
    217c:	00002097          	auipc	ra,0x2
    2180:	626080e7          	jalr	1574(ra) # 47a2 <printf>
      exit(1);
    2184:	4505                	li	a0,1
    2186:	00002097          	auipc	ra,0x2
    218a:	29c080e7          	jalr	668(ra) # 4422 <exit>
      printf("%s: short read bigfile\n", s);
    218e:	85d6                	mv	a1,s5
    2190:	00003517          	auipc	a0,0x3
    2194:	76050513          	addi	a0,a0,1888 # 58f0 <malloc+0x1090>
    2198:	00002097          	auipc	ra,0x2
    219c:	60a080e7          	jalr	1546(ra) # 47a2 <printf>
      exit(1);
    21a0:	4505                	li	a0,1
    21a2:	00002097          	auipc	ra,0x2
    21a6:	280080e7          	jalr	640(ra) # 4422 <exit>
      printf("%s: read bigfile wrong data\n", s);
    21aa:	85d6                	mv	a1,s5
    21ac:	00003517          	auipc	a0,0x3
    21b0:	75c50513          	addi	a0,a0,1884 # 5908 <malloc+0x10a8>
    21b4:	00002097          	auipc	ra,0x2
    21b8:	5ee080e7          	jalr	1518(ra) # 47a2 <printf>
      exit(1);
    21bc:	4505                	li	a0,1
    21be:	00002097          	auipc	ra,0x2
    21c2:	264080e7          	jalr	612(ra) # 4422 <exit>
  close(fd);
    21c6:	8552                	mv	a0,s4
    21c8:	00002097          	auipc	ra,0x2
    21cc:	282080e7          	jalr	642(ra) # 444a <close>
  if(total != N*SZ){
    21d0:	678d                	lui	a5,0x3
    21d2:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x504>
    21d6:	02f99363          	bne	s3,a5,21fc <bigfile+0x1c4>
  unlink("bigfile.test");
    21da:	00003517          	auipc	a0,0x3
    21de:	68650513          	addi	a0,a0,1670 # 5860 <malloc+0x1000>
    21e2:	00002097          	auipc	ra,0x2
    21e6:	290080e7          	jalr	656(ra) # 4472 <unlink>
}
    21ea:	70e2                	ld	ra,56(sp)
    21ec:	7442                	ld	s0,48(sp)
    21ee:	74a2                	ld	s1,40(sp)
    21f0:	7902                	ld	s2,32(sp)
    21f2:	69e2                	ld	s3,24(sp)
    21f4:	6a42                	ld	s4,16(sp)
    21f6:	6aa2                	ld	s5,8(sp)
    21f8:	6121                	addi	sp,sp,64
    21fa:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    21fc:	85d6                	mv	a1,s5
    21fe:	00003517          	auipc	a0,0x3
    2202:	72a50513          	addi	a0,a0,1834 # 5928 <malloc+0x10c8>
    2206:	00002097          	auipc	ra,0x2
    220a:	59c080e7          	jalr	1436(ra) # 47a2 <printf>
    exit(1);
    220e:	4505                	li	a0,1
    2210:	00002097          	auipc	ra,0x2
    2214:	212080e7          	jalr	530(ra) # 4422 <exit>

0000000000002218 <linktest>:
{
    2218:	1101                	addi	sp,sp,-32
    221a:	ec06                	sd	ra,24(sp)
    221c:	e822                	sd	s0,16(sp)
    221e:	e426                	sd	s1,8(sp)
    2220:	e04a                	sd	s2,0(sp)
    2222:	1000                	addi	s0,sp,32
    2224:	892a                	mv	s2,a0
  unlink("lf1");
    2226:	00003517          	auipc	a0,0x3
    222a:	72250513          	addi	a0,a0,1826 # 5948 <malloc+0x10e8>
    222e:	00002097          	auipc	ra,0x2
    2232:	244080e7          	jalr	580(ra) # 4472 <unlink>
  unlink("lf2");
    2236:	00003517          	auipc	a0,0x3
    223a:	71a50513          	addi	a0,a0,1818 # 5950 <malloc+0x10f0>
    223e:	00002097          	auipc	ra,0x2
    2242:	234080e7          	jalr	564(ra) # 4472 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    2246:	20200593          	li	a1,514
    224a:	00003517          	auipc	a0,0x3
    224e:	6fe50513          	addi	a0,a0,1790 # 5948 <malloc+0x10e8>
    2252:	00002097          	auipc	ra,0x2
    2256:	210080e7          	jalr	528(ra) # 4462 <open>
  if(fd < 0){
    225a:	10054763          	bltz	a0,2368 <linktest+0x150>
    225e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    2260:	4615                	li	a2,5
    2262:	00003597          	auipc	a1,0x3
    2266:	1ce58593          	addi	a1,a1,462 # 5430 <malloc+0xbd0>
    226a:	00002097          	auipc	ra,0x2
    226e:	1d8080e7          	jalr	472(ra) # 4442 <write>
    2272:	4795                	li	a5,5
    2274:	10f51863          	bne	a0,a5,2384 <linktest+0x16c>
  close(fd);
    2278:	8526                	mv	a0,s1
    227a:	00002097          	auipc	ra,0x2
    227e:	1d0080e7          	jalr	464(ra) # 444a <close>
  if(link("lf1", "lf2") < 0){
    2282:	00003597          	auipc	a1,0x3
    2286:	6ce58593          	addi	a1,a1,1742 # 5950 <malloc+0x10f0>
    228a:	00003517          	auipc	a0,0x3
    228e:	6be50513          	addi	a0,a0,1726 # 5948 <malloc+0x10e8>
    2292:	00002097          	auipc	ra,0x2
    2296:	1f0080e7          	jalr	496(ra) # 4482 <link>
    229a:	10054363          	bltz	a0,23a0 <linktest+0x188>
  unlink("lf1");
    229e:	00003517          	auipc	a0,0x3
    22a2:	6aa50513          	addi	a0,a0,1706 # 5948 <malloc+0x10e8>
    22a6:	00002097          	auipc	ra,0x2
    22aa:	1cc080e7          	jalr	460(ra) # 4472 <unlink>
  if(open("lf1", 0) >= 0){
    22ae:	4581                	li	a1,0
    22b0:	00003517          	auipc	a0,0x3
    22b4:	69850513          	addi	a0,a0,1688 # 5948 <malloc+0x10e8>
    22b8:	00002097          	auipc	ra,0x2
    22bc:	1aa080e7          	jalr	426(ra) # 4462 <open>
    22c0:	0e055e63          	bgez	a0,23bc <linktest+0x1a4>
  fd = open("lf2", 0);
    22c4:	4581                	li	a1,0
    22c6:	00003517          	auipc	a0,0x3
    22ca:	68a50513          	addi	a0,a0,1674 # 5950 <malloc+0x10f0>
    22ce:	00002097          	auipc	ra,0x2
    22d2:	194080e7          	jalr	404(ra) # 4462 <open>
    22d6:	84aa                	mv	s1,a0
  if(fd < 0){
    22d8:	10054063          	bltz	a0,23d8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    22dc:	660d                	lui	a2,0x3
    22de:	00007597          	auipc	a1,0x7
    22e2:	f5258593          	addi	a1,a1,-174 # 9230 <buf>
    22e6:	00002097          	auipc	ra,0x2
    22ea:	154080e7          	jalr	340(ra) # 443a <read>
    22ee:	4795                	li	a5,5
    22f0:	10f51263          	bne	a0,a5,23f4 <linktest+0x1dc>
  close(fd);
    22f4:	8526                	mv	a0,s1
    22f6:	00002097          	auipc	ra,0x2
    22fa:	154080e7          	jalr	340(ra) # 444a <close>
  if(link("lf2", "lf2") >= 0){
    22fe:	00003597          	auipc	a1,0x3
    2302:	65258593          	addi	a1,a1,1618 # 5950 <malloc+0x10f0>
    2306:	852e                	mv	a0,a1
    2308:	00002097          	auipc	ra,0x2
    230c:	17a080e7          	jalr	378(ra) # 4482 <link>
    2310:	10055063          	bgez	a0,2410 <linktest+0x1f8>
  unlink("lf2");
    2314:	00003517          	auipc	a0,0x3
    2318:	63c50513          	addi	a0,a0,1596 # 5950 <malloc+0x10f0>
    231c:	00002097          	auipc	ra,0x2
    2320:	156080e7          	jalr	342(ra) # 4472 <unlink>
  if(link("lf2", "lf1") >= 0){
    2324:	00003597          	auipc	a1,0x3
    2328:	62458593          	addi	a1,a1,1572 # 5948 <malloc+0x10e8>
    232c:	00003517          	auipc	a0,0x3
    2330:	62450513          	addi	a0,a0,1572 # 5950 <malloc+0x10f0>
    2334:	00002097          	auipc	ra,0x2
    2338:	14e080e7          	jalr	334(ra) # 4482 <link>
    233c:	0e055863          	bgez	a0,242c <linktest+0x214>
  if(link(".", "lf1") >= 0){
    2340:	00003597          	auipc	a1,0x3
    2344:	60858593          	addi	a1,a1,1544 # 5948 <malloc+0x10e8>
    2348:	00003517          	auipc	a0,0x3
    234c:	96850513          	addi	a0,a0,-1688 # 4cb0 <malloc+0x450>
    2350:	00002097          	auipc	ra,0x2
    2354:	132080e7          	jalr	306(ra) # 4482 <link>
    2358:	0e055863          	bgez	a0,2448 <linktest+0x230>
}
    235c:	60e2                	ld	ra,24(sp)
    235e:	6442                	ld	s0,16(sp)
    2360:	64a2                	ld	s1,8(sp)
    2362:	6902                	ld	s2,0(sp)
    2364:	6105                	addi	sp,sp,32
    2366:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    2368:	85ca                	mv	a1,s2
    236a:	00003517          	auipc	a0,0x3
    236e:	5ee50513          	addi	a0,a0,1518 # 5958 <malloc+0x10f8>
    2372:	00002097          	auipc	ra,0x2
    2376:	430080e7          	jalr	1072(ra) # 47a2 <printf>
    exit(1);
    237a:	4505                	li	a0,1
    237c:	00002097          	auipc	ra,0x2
    2380:	0a6080e7          	jalr	166(ra) # 4422 <exit>
    printf("%s: write lf1 failed\n", s);
    2384:	85ca                	mv	a1,s2
    2386:	00003517          	auipc	a0,0x3
    238a:	5ea50513          	addi	a0,a0,1514 # 5970 <malloc+0x1110>
    238e:	00002097          	auipc	ra,0x2
    2392:	414080e7          	jalr	1044(ra) # 47a2 <printf>
    exit(1);
    2396:	4505                	li	a0,1
    2398:	00002097          	auipc	ra,0x2
    239c:	08a080e7          	jalr	138(ra) # 4422 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    23a0:	85ca                	mv	a1,s2
    23a2:	00003517          	auipc	a0,0x3
    23a6:	5e650513          	addi	a0,a0,1510 # 5988 <malloc+0x1128>
    23aa:	00002097          	auipc	ra,0x2
    23ae:	3f8080e7          	jalr	1016(ra) # 47a2 <printf>
    exit(1);
    23b2:	4505                	li	a0,1
    23b4:	00002097          	auipc	ra,0x2
    23b8:	06e080e7          	jalr	110(ra) # 4422 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    23bc:	85ca                	mv	a1,s2
    23be:	00003517          	auipc	a0,0x3
    23c2:	5ea50513          	addi	a0,a0,1514 # 59a8 <malloc+0x1148>
    23c6:	00002097          	auipc	ra,0x2
    23ca:	3dc080e7          	jalr	988(ra) # 47a2 <printf>
    exit(1);
    23ce:	4505                	li	a0,1
    23d0:	00002097          	auipc	ra,0x2
    23d4:	052080e7          	jalr	82(ra) # 4422 <exit>
    printf("%s: open lf2 failed\n", s);
    23d8:	85ca                	mv	a1,s2
    23da:	00003517          	auipc	a0,0x3
    23de:	5fe50513          	addi	a0,a0,1534 # 59d8 <malloc+0x1178>
    23e2:	00002097          	auipc	ra,0x2
    23e6:	3c0080e7          	jalr	960(ra) # 47a2 <printf>
    exit(1);
    23ea:	4505                	li	a0,1
    23ec:	00002097          	auipc	ra,0x2
    23f0:	036080e7          	jalr	54(ra) # 4422 <exit>
    printf("%s: read lf2 failed\n", s);
    23f4:	85ca                	mv	a1,s2
    23f6:	00003517          	auipc	a0,0x3
    23fa:	5fa50513          	addi	a0,a0,1530 # 59f0 <malloc+0x1190>
    23fe:	00002097          	auipc	ra,0x2
    2402:	3a4080e7          	jalr	932(ra) # 47a2 <printf>
    exit(1);
    2406:	4505                	li	a0,1
    2408:	00002097          	auipc	ra,0x2
    240c:	01a080e7          	jalr	26(ra) # 4422 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    2410:	85ca                	mv	a1,s2
    2412:	00003517          	auipc	a0,0x3
    2416:	5f650513          	addi	a0,a0,1526 # 5a08 <malloc+0x11a8>
    241a:	00002097          	auipc	ra,0x2
    241e:	388080e7          	jalr	904(ra) # 47a2 <printf>
    exit(1);
    2422:	4505                	li	a0,1
    2424:	00002097          	auipc	ra,0x2
    2428:	ffe080e7          	jalr	-2(ra) # 4422 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    242c:	85ca                	mv	a1,s2
    242e:	00003517          	auipc	a0,0x3
    2432:	60250513          	addi	a0,a0,1538 # 5a30 <malloc+0x11d0>
    2436:	00002097          	auipc	ra,0x2
    243a:	36c080e7          	jalr	876(ra) # 47a2 <printf>
    exit(1);
    243e:	4505                	li	a0,1
    2440:	00002097          	auipc	ra,0x2
    2444:	fe2080e7          	jalr	-30(ra) # 4422 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    2448:	85ca                	mv	a1,s2
    244a:	00003517          	auipc	a0,0x3
    244e:	60e50513          	addi	a0,a0,1550 # 5a58 <malloc+0x11f8>
    2452:	00002097          	auipc	ra,0x2
    2456:	350080e7          	jalr	848(ra) # 47a2 <printf>
    exit(1);
    245a:	4505                	li	a0,1
    245c:	00002097          	auipc	ra,0x2
    2460:	fc6080e7          	jalr	-58(ra) # 4422 <exit>

0000000000002464 <concreate>:
{
    2464:	7135                	addi	sp,sp,-160
    2466:	ed06                	sd	ra,152(sp)
    2468:	e922                	sd	s0,144(sp)
    246a:	e526                	sd	s1,136(sp)
    246c:	e14a                	sd	s2,128(sp)
    246e:	fcce                	sd	s3,120(sp)
    2470:	f8d2                	sd	s4,112(sp)
    2472:	f4d6                	sd	s5,104(sp)
    2474:	f0da                	sd	s6,96(sp)
    2476:	ecde                	sd	s7,88(sp)
    2478:	1100                	addi	s0,sp,160
    247a:	89aa                	mv	s3,a0
  file[0] = 'C';
    247c:	04300793          	li	a5,67
    2480:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    2484:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    2488:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    248a:	4b0d                	li	s6,3
    248c:	4a85                	li	s5,1
      link("C0", file);
    248e:	00003b97          	auipc	s7,0x3
    2492:	5eab8b93          	addi	s7,s7,1514 # 5a78 <malloc+0x1218>
  for(i = 0; i < N; i++){
    2496:	02800a13          	li	s4,40
    249a:	a471                	j	2726 <concreate+0x2c2>
      link("C0", file);
    249c:	fa840593          	addi	a1,s0,-88
    24a0:	855e                	mv	a0,s7
    24a2:	00002097          	auipc	ra,0x2
    24a6:	fe0080e7          	jalr	-32(ra) # 4482 <link>
    if(pid == 0) {
    24aa:	a48d                	j	270c <concreate+0x2a8>
    } else if(pid == 0 && (i % 5) == 1){
    24ac:	4795                	li	a5,5
    24ae:	02f9693b          	remw	s2,s2,a5
    24b2:	4785                	li	a5,1
    24b4:	02f90b63          	beq	s2,a5,24ea <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    24b8:	20200593          	li	a1,514
    24bc:	fa840513          	addi	a0,s0,-88
    24c0:	00002097          	auipc	ra,0x2
    24c4:	fa2080e7          	jalr	-94(ra) # 4462 <open>
      if(fd < 0){
    24c8:	22055963          	bgez	a0,26fa <concreate+0x296>
        printf("concreate create %s failed\n", file);
    24cc:	fa840593          	addi	a1,s0,-88
    24d0:	00003517          	auipc	a0,0x3
    24d4:	5b050513          	addi	a0,a0,1456 # 5a80 <malloc+0x1220>
    24d8:	00002097          	auipc	ra,0x2
    24dc:	2ca080e7          	jalr	714(ra) # 47a2 <printf>
        exit(1);
    24e0:	4505                	li	a0,1
    24e2:	00002097          	auipc	ra,0x2
    24e6:	f40080e7          	jalr	-192(ra) # 4422 <exit>
      link("C0", file);
    24ea:	fa840593          	addi	a1,s0,-88
    24ee:	00003517          	auipc	a0,0x3
    24f2:	58a50513          	addi	a0,a0,1418 # 5a78 <malloc+0x1218>
    24f6:	00002097          	auipc	ra,0x2
    24fa:	f8c080e7          	jalr	-116(ra) # 4482 <link>
      exit(0);
    24fe:	4501                	li	a0,0
    2500:	00002097          	auipc	ra,0x2
    2504:	f22080e7          	jalr	-222(ra) # 4422 <exit>
        exit(1);
    2508:	4505                	li	a0,1
    250a:	00002097          	auipc	ra,0x2
    250e:	f18080e7          	jalr	-232(ra) # 4422 <exit>
  memset(fa, 0, sizeof(fa));
    2512:	02800613          	li	a2,40
    2516:	4581                	li	a1,0
    2518:	f8040513          	addi	a0,s0,-128
    251c:	00002097          	auipc	ra,0x2
    2520:	d0a080e7          	jalr	-758(ra) # 4226 <memset>
  fd = open(".", 0);
    2524:	4581                	li	a1,0
    2526:	00002517          	auipc	a0,0x2
    252a:	78a50513          	addi	a0,a0,1930 # 4cb0 <malloc+0x450>
    252e:	00002097          	auipc	ra,0x2
    2532:	f34080e7          	jalr	-204(ra) # 4462 <open>
    2536:	892a                	mv	s2,a0
  n = 0;
    2538:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    253a:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    253e:	02700b13          	li	s6,39
      fa[i] = 1;
    2542:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    2544:	4641                	li	a2,16
    2546:	f7040593          	addi	a1,s0,-144
    254a:	854a                	mv	a0,s2
    254c:	00002097          	auipc	ra,0x2
    2550:	eee080e7          	jalr	-274(ra) # 443a <read>
    2554:	08a05163          	blez	a0,25d6 <concreate+0x172>
    if(de.inum == 0)
    2558:	f7045783          	lhu	a5,-144(s0)
    255c:	d7e5                	beqz	a5,2544 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    255e:	f7244783          	lbu	a5,-142(s0)
    2562:	ff4791e3          	bne	a5,s4,2544 <concreate+0xe0>
    2566:	f7444783          	lbu	a5,-140(s0)
    256a:	ffe9                	bnez	a5,2544 <concreate+0xe0>
      i = de.name[1] - '0';
    256c:	f7344783          	lbu	a5,-141(s0)
    2570:	fd07879b          	addiw	a5,a5,-48
    2574:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    2578:	00eb6f63          	bltu	s6,a4,2596 <concreate+0x132>
      if(fa[i]){
    257c:	fb040793          	addi	a5,s0,-80
    2580:	97ba                	add	a5,a5,a4
    2582:	fd07c783          	lbu	a5,-48(a5)
    2586:	eb85                	bnez	a5,25b6 <concreate+0x152>
      fa[i] = 1;
    2588:	fb040793          	addi	a5,s0,-80
    258c:	973e                	add	a4,a4,a5
    258e:	fd770823          	sb	s7,-48(a4)
      n++;
    2592:	2a85                	addiw	s5,s5,1
    2594:	bf45                	j	2544 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    2596:	f7240613          	addi	a2,s0,-142
    259a:	85ce                	mv	a1,s3
    259c:	00003517          	auipc	a0,0x3
    25a0:	50450513          	addi	a0,a0,1284 # 5aa0 <malloc+0x1240>
    25a4:	00002097          	auipc	ra,0x2
    25a8:	1fe080e7          	jalr	510(ra) # 47a2 <printf>
        exit(1);
    25ac:	4505                	li	a0,1
    25ae:	00002097          	auipc	ra,0x2
    25b2:	e74080e7          	jalr	-396(ra) # 4422 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    25b6:	f7240613          	addi	a2,s0,-142
    25ba:	85ce                	mv	a1,s3
    25bc:	00003517          	auipc	a0,0x3
    25c0:	50450513          	addi	a0,a0,1284 # 5ac0 <malloc+0x1260>
    25c4:	00002097          	auipc	ra,0x2
    25c8:	1de080e7          	jalr	478(ra) # 47a2 <printf>
        exit(1);
    25cc:	4505                	li	a0,1
    25ce:	00002097          	auipc	ra,0x2
    25d2:	e54080e7          	jalr	-428(ra) # 4422 <exit>
  close(fd);
    25d6:	854a                	mv	a0,s2
    25d8:	00002097          	auipc	ra,0x2
    25dc:	e72080e7          	jalr	-398(ra) # 444a <close>
  if(n != N){
    25e0:	02800793          	li	a5,40
    25e4:	00fa9763          	bne	s5,a5,25f2 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    25e8:	4a8d                	li	s5,3
    25ea:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    25ec:	02800a13          	li	s4,40
    25f0:	a05d                	j	2696 <concreate+0x232>
    printf("%s: concreate not enough files in directory listing\n", s);
    25f2:	85ce                	mv	a1,s3
    25f4:	00003517          	auipc	a0,0x3
    25f8:	4f450513          	addi	a0,a0,1268 # 5ae8 <malloc+0x1288>
    25fc:	00002097          	auipc	ra,0x2
    2600:	1a6080e7          	jalr	422(ra) # 47a2 <printf>
    exit(1);
    2604:	4505                	li	a0,1
    2606:	00002097          	auipc	ra,0x2
    260a:	e1c080e7          	jalr	-484(ra) # 4422 <exit>
      printf("%s: fork failed\n", s);
    260e:	85ce                	mv	a1,s3
    2610:	00002517          	auipc	a0,0x2
    2614:	75050513          	addi	a0,a0,1872 # 4d60 <malloc+0x500>
    2618:	00002097          	auipc	ra,0x2
    261c:	18a080e7          	jalr	394(ra) # 47a2 <printf>
      exit(1);
    2620:	4505                	li	a0,1
    2622:	00002097          	auipc	ra,0x2
    2626:	e00080e7          	jalr	-512(ra) # 4422 <exit>
      close(open(file, 0));
    262a:	4581                	li	a1,0
    262c:	fa840513          	addi	a0,s0,-88
    2630:	00002097          	auipc	ra,0x2
    2634:	e32080e7          	jalr	-462(ra) # 4462 <open>
    2638:	00002097          	auipc	ra,0x2
    263c:	e12080e7          	jalr	-494(ra) # 444a <close>
      close(open(file, 0));
    2640:	4581                	li	a1,0
    2642:	fa840513          	addi	a0,s0,-88
    2646:	00002097          	auipc	ra,0x2
    264a:	e1c080e7          	jalr	-484(ra) # 4462 <open>
    264e:	00002097          	auipc	ra,0x2
    2652:	dfc080e7          	jalr	-516(ra) # 444a <close>
      close(open(file, 0));
    2656:	4581                	li	a1,0
    2658:	fa840513          	addi	a0,s0,-88
    265c:	00002097          	auipc	ra,0x2
    2660:	e06080e7          	jalr	-506(ra) # 4462 <open>
    2664:	00002097          	auipc	ra,0x2
    2668:	de6080e7          	jalr	-538(ra) # 444a <close>
      close(open(file, 0));
    266c:	4581                	li	a1,0
    266e:	fa840513          	addi	a0,s0,-88
    2672:	00002097          	auipc	ra,0x2
    2676:	df0080e7          	jalr	-528(ra) # 4462 <open>
    267a:	00002097          	auipc	ra,0x2
    267e:	dd0080e7          	jalr	-560(ra) # 444a <close>
    if(pid == 0)
    2682:	06090763          	beqz	s2,26f0 <concreate+0x28c>
      wait(0);
    2686:	4501                	li	a0,0
    2688:	00002097          	auipc	ra,0x2
    268c:	da2080e7          	jalr	-606(ra) # 442a <wait>
  for(i = 0; i < N; i++){
    2690:	2485                	addiw	s1,s1,1
    2692:	0d448963          	beq	s1,s4,2764 <concreate+0x300>
    file[1] = '0' + i;
    2696:	0304879b          	addiw	a5,s1,48
    269a:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    269e:	00002097          	auipc	ra,0x2
    26a2:	d7c080e7          	jalr	-644(ra) # 441a <fork>
    26a6:	892a                	mv	s2,a0
    if(pid < 0){
    26a8:	f60543e3          	bltz	a0,260e <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    26ac:	0354e73b          	remw	a4,s1,s5
    26b0:	00a767b3          	or	a5,a4,a0
    26b4:	2781                	sext.w	a5,a5
    26b6:	dbb5                	beqz	a5,262a <concreate+0x1c6>
    26b8:	01671363          	bne	a4,s6,26be <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
    26bc:	f53d                	bnez	a0,262a <concreate+0x1c6>
      unlink(file);
    26be:	fa840513          	addi	a0,s0,-88
    26c2:	00002097          	auipc	ra,0x2
    26c6:	db0080e7          	jalr	-592(ra) # 4472 <unlink>
      unlink(file);
    26ca:	fa840513          	addi	a0,s0,-88
    26ce:	00002097          	auipc	ra,0x2
    26d2:	da4080e7          	jalr	-604(ra) # 4472 <unlink>
      unlink(file);
    26d6:	fa840513          	addi	a0,s0,-88
    26da:	00002097          	auipc	ra,0x2
    26de:	d98080e7          	jalr	-616(ra) # 4472 <unlink>
      unlink(file);
    26e2:	fa840513          	addi	a0,s0,-88
    26e6:	00002097          	auipc	ra,0x2
    26ea:	d8c080e7          	jalr	-628(ra) # 4472 <unlink>
    26ee:	bf51                	j	2682 <concreate+0x21e>
      exit(0);
    26f0:	4501                	li	a0,0
    26f2:	00002097          	auipc	ra,0x2
    26f6:	d30080e7          	jalr	-720(ra) # 4422 <exit>
      close(fd);
    26fa:	00002097          	auipc	ra,0x2
    26fe:	d50080e7          	jalr	-688(ra) # 444a <close>
    if(pid == 0) {
    2702:	bbf5                	j	24fe <concreate+0x9a>
      close(fd);
    2704:	00002097          	auipc	ra,0x2
    2708:	d46080e7          	jalr	-698(ra) # 444a <close>
      wait(&xstatus);
    270c:	f6c40513          	addi	a0,s0,-148
    2710:	00002097          	auipc	ra,0x2
    2714:	d1a080e7          	jalr	-742(ra) # 442a <wait>
      if(xstatus != 0)
    2718:	f6c42483          	lw	s1,-148(s0)
    271c:	de0496e3          	bnez	s1,2508 <concreate+0xa4>
  for(i = 0; i < N; i++){
    2720:	2905                	addiw	s2,s2,1
    2722:	df4908e3          	beq	s2,s4,2512 <concreate+0xae>
    file[1] = '0' + i;
    2726:	0309079b          	addiw	a5,s2,48
    272a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    272e:	fa840513          	addi	a0,s0,-88
    2732:	00002097          	auipc	ra,0x2
    2736:	d40080e7          	jalr	-704(ra) # 4472 <unlink>
    pid = fork();
    273a:	00002097          	auipc	ra,0x2
    273e:	ce0080e7          	jalr	-800(ra) # 441a <fork>
    if(pid && (i % 3) == 1){
    2742:	d60505e3          	beqz	a0,24ac <concreate+0x48>
    2746:	036967bb          	remw	a5,s2,s6
    274a:	d55789e3          	beq	a5,s5,249c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    274e:	20200593          	li	a1,514
    2752:	fa840513          	addi	a0,s0,-88
    2756:	00002097          	auipc	ra,0x2
    275a:	d0c080e7          	jalr	-756(ra) # 4462 <open>
      if(fd < 0){
    275e:	fa0553e3          	bgez	a0,2704 <concreate+0x2a0>
    2762:	b3ad                	j	24cc <concreate+0x68>
}
    2764:	60ea                	ld	ra,152(sp)
    2766:	644a                	ld	s0,144(sp)
    2768:	64aa                	ld	s1,136(sp)
    276a:	690a                	ld	s2,128(sp)
    276c:	79e6                	ld	s3,120(sp)
    276e:	7a46                	ld	s4,112(sp)
    2770:	7aa6                	ld	s5,104(sp)
    2772:	7b06                	ld	s6,96(sp)
    2774:	6be6                	ld	s7,88(sp)
    2776:	610d                	addi	sp,sp,160
    2778:	8082                	ret

000000000000277a <linkunlink>:
{
    277a:	711d                	addi	sp,sp,-96
    277c:	ec86                	sd	ra,88(sp)
    277e:	e8a2                	sd	s0,80(sp)
    2780:	e4a6                	sd	s1,72(sp)
    2782:	e0ca                	sd	s2,64(sp)
    2784:	fc4e                	sd	s3,56(sp)
    2786:	f852                	sd	s4,48(sp)
    2788:	f456                	sd	s5,40(sp)
    278a:	f05a                	sd	s6,32(sp)
    278c:	ec5e                	sd	s7,24(sp)
    278e:	e862                	sd	s8,16(sp)
    2790:	e466                	sd	s9,8(sp)
    2792:	1080                	addi	s0,sp,96
    2794:	84aa                	mv	s1,a0
  unlink("x");
    2796:	00003517          	auipc	a0,0x3
    279a:	f7a50513          	addi	a0,a0,-134 # 5710 <malloc+0xeb0>
    279e:	00002097          	auipc	ra,0x2
    27a2:	cd4080e7          	jalr	-812(ra) # 4472 <unlink>
  pid = fork();
    27a6:	00002097          	auipc	ra,0x2
    27aa:	c74080e7          	jalr	-908(ra) # 441a <fork>
  if(pid < 0){
    27ae:	02054b63          	bltz	a0,27e4 <linkunlink+0x6a>
    27b2:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    27b4:	4c85                	li	s9,1
    27b6:	e119                	bnez	a0,27bc <linkunlink+0x42>
    27b8:	06100c93          	li	s9,97
    27bc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    27c0:	41c659b7          	lui	s3,0x41c65
    27c4:	e6d9899b          	addiw	s3,s3,-403
    27c8:	690d                	lui	s2,0x3
    27ca:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    27ce:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    27d0:	4b05                	li	s6,1
      unlink("x");
    27d2:	00003a97          	auipc	s5,0x3
    27d6:	f3ea8a93          	addi	s5,s5,-194 # 5710 <malloc+0xeb0>
      link("cat", "x");
    27da:	00003b97          	auipc	s7,0x3
    27de:	346b8b93          	addi	s7,s7,838 # 5b20 <malloc+0x12c0>
    27e2:	a825                	j	281a <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    27e4:	85a6                	mv	a1,s1
    27e6:	00002517          	auipc	a0,0x2
    27ea:	57a50513          	addi	a0,a0,1402 # 4d60 <malloc+0x500>
    27ee:	00002097          	auipc	ra,0x2
    27f2:	fb4080e7          	jalr	-76(ra) # 47a2 <printf>
    exit(1);
    27f6:	4505                	li	a0,1
    27f8:	00002097          	auipc	ra,0x2
    27fc:	c2a080e7          	jalr	-982(ra) # 4422 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2800:	20200593          	li	a1,514
    2804:	8556                	mv	a0,s5
    2806:	00002097          	auipc	ra,0x2
    280a:	c5c080e7          	jalr	-932(ra) # 4462 <open>
    280e:	00002097          	auipc	ra,0x2
    2812:	c3c080e7          	jalr	-964(ra) # 444a <close>
  for(i = 0; i < 100; i++){
    2816:	34fd                	addiw	s1,s1,-1
    2818:	c88d                	beqz	s1,284a <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    281a:	033c87bb          	mulw	a5,s9,s3
    281e:	012787bb          	addw	a5,a5,s2
    2822:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2826:	0347f7bb          	remuw	a5,a5,s4
    282a:	dbf9                	beqz	a5,2800 <linkunlink+0x86>
    } else if((x % 3) == 1){
    282c:	01678863          	beq	a5,s6,283c <linkunlink+0xc2>
      unlink("x");
    2830:	8556                	mv	a0,s5
    2832:	00002097          	auipc	ra,0x2
    2836:	c40080e7          	jalr	-960(ra) # 4472 <unlink>
    283a:	bff1                	j	2816 <linkunlink+0x9c>
      link("cat", "x");
    283c:	85d6                	mv	a1,s5
    283e:	855e                	mv	a0,s7
    2840:	00002097          	auipc	ra,0x2
    2844:	c42080e7          	jalr	-958(ra) # 4482 <link>
    2848:	b7f9                	j	2816 <linkunlink+0x9c>
  if(pid)
    284a:	020c0463          	beqz	s8,2872 <linkunlink+0xf8>
    wait(0);
    284e:	4501                	li	a0,0
    2850:	00002097          	auipc	ra,0x2
    2854:	bda080e7          	jalr	-1062(ra) # 442a <wait>
}
    2858:	60e6                	ld	ra,88(sp)
    285a:	6446                	ld	s0,80(sp)
    285c:	64a6                	ld	s1,72(sp)
    285e:	6906                	ld	s2,64(sp)
    2860:	79e2                	ld	s3,56(sp)
    2862:	7a42                	ld	s4,48(sp)
    2864:	7aa2                	ld	s5,40(sp)
    2866:	7b02                	ld	s6,32(sp)
    2868:	6be2                	ld	s7,24(sp)
    286a:	6c42                	ld	s8,16(sp)
    286c:	6ca2                	ld	s9,8(sp)
    286e:	6125                	addi	sp,sp,96
    2870:	8082                	ret
    exit(0);
    2872:	4501                	li	a0,0
    2874:	00002097          	auipc	ra,0x2
    2878:	bae080e7          	jalr	-1106(ra) # 4422 <exit>

000000000000287c <bigdir>:
{
    287c:	715d                	addi	sp,sp,-80
    287e:	e486                	sd	ra,72(sp)
    2880:	e0a2                	sd	s0,64(sp)
    2882:	fc26                	sd	s1,56(sp)
    2884:	f84a                	sd	s2,48(sp)
    2886:	f44e                	sd	s3,40(sp)
    2888:	f052                	sd	s4,32(sp)
    288a:	ec56                	sd	s5,24(sp)
    288c:	e85a                	sd	s6,16(sp)
    288e:	0880                	addi	s0,sp,80
    2890:	89aa                	mv	s3,a0
  unlink("bd");
    2892:	00003517          	auipc	a0,0x3
    2896:	29650513          	addi	a0,a0,662 # 5b28 <malloc+0x12c8>
    289a:	00002097          	auipc	ra,0x2
    289e:	bd8080e7          	jalr	-1064(ra) # 4472 <unlink>
  fd = open("bd", O_CREATE);
    28a2:	20000593          	li	a1,512
    28a6:	00003517          	auipc	a0,0x3
    28aa:	28250513          	addi	a0,a0,642 # 5b28 <malloc+0x12c8>
    28ae:	00002097          	auipc	ra,0x2
    28b2:	bb4080e7          	jalr	-1100(ra) # 4462 <open>
  if(fd < 0){
    28b6:	0c054963          	bltz	a0,2988 <bigdir+0x10c>
  close(fd);
    28ba:	00002097          	auipc	ra,0x2
    28be:	b90080e7          	jalr	-1136(ra) # 444a <close>
  for(i = 0; i < N; i++){
    28c2:	4901                	li	s2,0
    name[0] = 'x';
    28c4:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    28c8:	00003a17          	auipc	s4,0x3
    28cc:	260a0a13          	addi	s4,s4,608 # 5b28 <malloc+0x12c8>
  for(i = 0; i < N; i++){
    28d0:	1f400b13          	li	s6,500
    name[0] = 'x';
    28d4:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    28d8:	41f9579b          	sraiw	a5,s2,0x1f
    28dc:	01a7d71b          	srliw	a4,a5,0x1a
    28e0:	012707bb          	addw	a5,a4,s2
    28e4:	4067d69b          	sraiw	a3,a5,0x6
    28e8:	0306869b          	addiw	a3,a3,48
    28ec:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    28f0:	03f7f793          	andi	a5,a5,63
    28f4:	9f99                	subw	a5,a5,a4
    28f6:	0307879b          	addiw	a5,a5,48
    28fa:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    28fe:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    2902:	fb040593          	addi	a1,s0,-80
    2906:	8552                	mv	a0,s4
    2908:	00002097          	auipc	ra,0x2
    290c:	b7a080e7          	jalr	-1158(ra) # 4482 <link>
    2910:	84aa                	mv	s1,a0
    2912:	e949                	bnez	a0,29a4 <bigdir+0x128>
  for(i = 0; i < N; i++){
    2914:	2905                	addiw	s2,s2,1
    2916:	fb691fe3          	bne	s2,s6,28d4 <bigdir+0x58>
  unlink("bd");
    291a:	00003517          	auipc	a0,0x3
    291e:	20e50513          	addi	a0,a0,526 # 5b28 <malloc+0x12c8>
    2922:	00002097          	auipc	ra,0x2
    2926:	b50080e7          	jalr	-1200(ra) # 4472 <unlink>
    name[0] = 'x';
    292a:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    292e:	1f400a13          	li	s4,500
    name[0] = 'x';
    2932:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    2936:	41f4d79b          	sraiw	a5,s1,0x1f
    293a:	01a7d71b          	srliw	a4,a5,0x1a
    293e:	009707bb          	addw	a5,a4,s1
    2942:	4067d69b          	sraiw	a3,a5,0x6
    2946:	0306869b          	addiw	a3,a3,48
    294a:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    294e:	03f7f793          	andi	a5,a5,63
    2952:	9f99                	subw	a5,a5,a4
    2954:	0307879b          	addiw	a5,a5,48
    2958:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    295c:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    2960:	fb040513          	addi	a0,s0,-80
    2964:	00002097          	auipc	ra,0x2
    2968:	b0e080e7          	jalr	-1266(ra) # 4472 <unlink>
    296c:	e931                	bnez	a0,29c0 <bigdir+0x144>
  for(i = 0; i < N; i++){
    296e:	2485                	addiw	s1,s1,1
    2970:	fd4491e3          	bne	s1,s4,2932 <bigdir+0xb6>
}
    2974:	60a6                	ld	ra,72(sp)
    2976:	6406                	ld	s0,64(sp)
    2978:	74e2                	ld	s1,56(sp)
    297a:	7942                	ld	s2,48(sp)
    297c:	79a2                	ld	s3,40(sp)
    297e:	7a02                	ld	s4,32(sp)
    2980:	6ae2                	ld	s5,24(sp)
    2982:	6b42                	ld	s6,16(sp)
    2984:	6161                	addi	sp,sp,80
    2986:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    2988:	85ce                	mv	a1,s3
    298a:	00003517          	auipc	a0,0x3
    298e:	1a650513          	addi	a0,a0,422 # 5b30 <malloc+0x12d0>
    2992:	00002097          	auipc	ra,0x2
    2996:	e10080e7          	jalr	-496(ra) # 47a2 <printf>
    exit(1);
    299a:	4505                	li	a0,1
    299c:	00002097          	auipc	ra,0x2
    29a0:	a86080e7          	jalr	-1402(ra) # 4422 <exit>
      printf("%s: bigdir link failed\n", s);
    29a4:	85ce                	mv	a1,s3
    29a6:	00003517          	auipc	a0,0x3
    29aa:	1aa50513          	addi	a0,a0,426 # 5b50 <malloc+0x12f0>
    29ae:	00002097          	auipc	ra,0x2
    29b2:	df4080e7          	jalr	-524(ra) # 47a2 <printf>
      exit(1);
    29b6:	4505                	li	a0,1
    29b8:	00002097          	auipc	ra,0x2
    29bc:	a6a080e7          	jalr	-1430(ra) # 4422 <exit>
      printf("%s: bigdir unlink failed", s);
    29c0:	85ce                	mv	a1,s3
    29c2:	00003517          	auipc	a0,0x3
    29c6:	1a650513          	addi	a0,a0,422 # 5b68 <malloc+0x1308>
    29ca:	00002097          	auipc	ra,0x2
    29ce:	dd8080e7          	jalr	-552(ra) # 47a2 <printf>
      exit(1);
    29d2:	4505                	li	a0,1
    29d4:	00002097          	auipc	ra,0x2
    29d8:	a4e080e7          	jalr	-1458(ra) # 4422 <exit>

00000000000029dc <subdir>:
{
    29dc:	1101                	addi	sp,sp,-32
    29de:	ec06                	sd	ra,24(sp)
    29e0:	e822                	sd	s0,16(sp)
    29e2:	e426                	sd	s1,8(sp)
    29e4:	e04a                	sd	s2,0(sp)
    29e6:	1000                	addi	s0,sp,32
    29e8:	892a                	mv	s2,a0
  unlink("ff");
    29ea:	00003517          	auipc	a0,0x3
    29ee:	2ce50513          	addi	a0,a0,718 # 5cb8 <malloc+0x1458>
    29f2:	00002097          	auipc	ra,0x2
    29f6:	a80080e7          	jalr	-1408(ra) # 4472 <unlink>
  if(mkdir("dd") != 0){
    29fa:	00003517          	auipc	a0,0x3
    29fe:	18e50513          	addi	a0,a0,398 # 5b88 <malloc+0x1328>
    2a02:	00002097          	auipc	ra,0x2
    2a06:	a88080e7          	jalr	-1400(ra) # 448a <mkdir>
    2a0a:	38051663          	bnez	a0,2d96 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2a0e:	20200593          	li	a1,514
    2a12:	00003517          	auipc	a0,0x3
    2a16:	19650513          	addi	a0,a0,406 # 5ba8 <malloc+0x1348>
    2a1a:	00002097          	auipc	ra,0x2
    2a1e:	a48080e7          	jalr	-1464(ra) # 4462 <open>
    2a22:	84aa                	mv	s1,a0
  if(fd < 0){
    2a24:	38054763          	bltz	a0,2db2 <subdir+0x3d6>
  write(fd, "ff", 2);
    2a28:	4609                	li	a2,2
    2a2a:	00003597          	auipc	a1,0x3
    2a2e:	28e58593          	addi	a1,a1,654 # 5cb8 <malloc+0x1458>
    2a32:	00002097          	auipc	ra,0x2
    2a36:	a10080e7          	jalr	-1520(ra) # 4442 <write>
  close(fd);
    2a3a:	8526                	mv	a0,s1
    2a3c:	00002097          	auipc	ra,0x2
    2a40:	a0e080e7          	jalr	-1522(ra) # 444a <close>
  if(unlink("dd") >= 0){
    2a44:	00003517          	auipc	a0,0x3
    2a48:	14450513          	addi	a0,a0,324 # 5b88 <malloc+0x1328>
    2a4c:	00002097          	auipc	ra,0x2
    2a50:	a26080e7          	jalr	-1498(ra) # 4472 <unlink>
    2a54:	36055d63          	bgez	a0,2dce <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2a58:	00003517          	auipc	a0,0x3
    2a5c:	1a850513          	addi	a0,a0,424 # 5c00 <malloc+0x13a0>
    2a60:	00002097          	auipc	ra,0x2
    2a64:	a2a080e7          	jalr	-1494(ra) # 448a <mkdir>
    2a68:	38051163          	bnez	a0,2dea <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2a6c:	20200593          	li	a1,514
    2a70:	00003517          	auipc	a0,0x3
    2a74:	1b850513          	addi	a0,a0,440 # 5c28 <malloc+0x13c8>
    2a78:	00002097          	auipc	ra,0x2
    2a7c:	9ea080e7          	jalr	-1558(ra) # 4462 <open>
    2a80:	84aa                	mv	s1,a0
  if(fd < 0){
    2a82:	38054263          	bltz	a0,2e06 <subdir+0x42a>
  write(fd, "FF", 2);
    2a86:	4609                	li	a2,2
    2a88:	00003597          	auipc	a1,0x3
    2a8c:	1d058593          	addi	a1,a1,464 # 5c58 <malloc+0x13f8>
    2a90:	00002097          	auipc	ra,0x2
    2a94:	9b2080e7          	jalr	-1614(ra) # 4442 <write>
  close(fd);
    2a98:	8526                	mv	a0,s1
    2a9a:	00002097          	auipc	ra,0x2
    2a9e:	9b0080e7          	jalr	-1616(ra) # 444a <close>
  fd = open("dd/dd/../ff", 0);
    2aa2:	4581                	li	a1,0
    2aa4:	00003517          	auipc	a0,0x3
    2aa8:	1bc50513          	addi	a0,a0,444 # 5c60 <malloc+0x1400>
    2aac:	00002097          	auipc	ra,0x2
    2ab0:	9b6080e7          	jalr	-1610(ra) # 4462 <open>
    2ab4:	84aa                	mv	s1,a0
  if(fd < 0){
    2ab6:	36054663          	bltz	a0,2e22 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2aba:	660d                	lui	a2,0x3
    2abc:	00006597          	auipc	a1,0x6
    2ac0:	77458593          	addi	a1,a1,1908 # 9230 <buf>
    2ac4:	00002097          	auipc	ra,0x2
    2ac8:	976080e7          	jalr	-1674(ra) # 443a <read>
  if(cc != 2 || buf[0] != 'f'){
    2acc:	4789                	li	a5,2
    2ace:	36f51863          	bne	a0,a5,2e3e <subdir+0x462>
    2ad2:	00006717          	auipc	a4,0x6
    2ad6:	75e74703          	lbu	a4,1886(a4) # 9230 <buf>
    2ada:	06600793          	li	a5,102
    2ade:	36f71063          	bne	a4,a5,2e3e <subdir+0x462>
  close(fd);
    2ae2:	8526                	mv	a0,s1
    2ae4:	00002097          	auipc	ra,0x2
    2ae8:	966080e7          	jalr	-1690(ra) # 444a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2aec:	00003597          	auipc	a1,0x3
    2af0:	1c458593          	addi	a1,a1,452 # 5cb0 <malloc+0x1450>
    2af4:	00003517          	auipc	a0,0x3
    2af8:	13450513          	addi	a0,a0,308 # 5c28 <malloc+0x13c8>
    2afc:	00002097          	auipc	ra,0x2
    2b00:	986080e7          	jalr	-1658(ra) # 4482 <link>
    2b04:	34051b63          	bnez	a0,2e5a <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2b08:	00003517          	auipc	a0,0x3
    2b0c:	12050513          	addi	a0,a0,288 # 5c28 <malloc+0x13c8>
    2b10:	00002097          	auipc	ra,0x2
    2b14:	962080e7          	jalr	-1694(ra) # 4472 <unlink>
    2b18:	34051f63          	bnez	a0,2e76 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2b1c:	4581                	li	a1,0
    2b1e:	00003517          	auipc	a0,0x3
    2b22:	10a50513          	addi	a0,a0,266 # 5c28 <malloc+0x13c8>
    2b26:	00002097          	auipc	ra,0x2
    2b2a:	93c080e7          	jalr	-1732(ra) # 4462 <open>
    2b2e:	36055263          	bgez	a0,2e92 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2b32:	00003517          	auipc	a0,0x3
    2b36:	05650513          	addi	a0,a0,86 # 5b88 <malloc+0x1328>
    2b3a:	00002097          	auipc	ra,0x2
    2b3e:	958080e7          	jalr	-1704(ra) # 4492 <chdir>
    2b42:	36051663          	bnez	a0,2eae <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2b46:	00003517          	auipc	a0,0x3
    2b4a:	20250513          	addi	a0,a0,514 # 5d48 <malloc+0x14e8>
    2b4e:	00002097          	auipc	ra,0x2
    2b52:	944080e7          	jalr	-1724(ra) # 4492 <chdir>
    2b56:	36051a63          	bnez	a0,2eca <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2b5a:	00003517          	auipc	a0,0x3
    2b5e:	21e50513          	addi	a0,a0,542 # 5d78 <malloc+0x1518>
    2b62:	00002097          	auipc	ra,0x2
    2b66:	930080e7          	jalr	-1744(ra) # 4492 <chdir>
    2b6a:	36051e63          	bnez	a0,2ee6 <subdir+0x50a>
  if(chdir("./..") != 0){
    2b6e:	00003517          	auipc	a0,0x3
    2b72:	23a50513          	addi	a0,a0,570 # 5da8 <malloc+0x1548>
    2b76:	00002097          	auipc	ra,0x2
    2b7a:	91c080e7          	jalr	-1764(ra) # 4492 <chdir>
    2b7e:	38051263          	bnez	a0,2f02 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2b82:	4581                	li	a1,0
    2b84:	00003517          	auipc	a0,0x3
    2b88:	12c50513          	addi	a0,a0,300 # 5cb0 <malloc+0x1450>
    2b8c:	00002097          	auipc	ra,0x2
    2b90:	8d6080e7          	jalr	-1834(ra) # 4462 <open>
    2b94:	84aa                	mv	s1,a0
  if(fd < 0){
    2b96:	38054463          	bltz	a0,2f1e <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2b9a:	660d                	lui	a2,0x3
    2b9c:	00006597          	auipc	a1,0x6
    2ba0:	69458593          	addi	a1,a1,1684 # 9230 <buf>
    2ba4:	00002097          	auipc	ra,0x2
    2ba8:	896080e7          	jalr	-1898(ra) # 443a <read>
    2bac:	4789                	li	a5,2
    2bae:	38f51663          	bne	a0,a5,2f3a <subdir+0x55e>
  close(fd);
    2bb2:	8526                	mv	a0,s1
    2bb4:	00002097          	auipc	ra,0x2
    2bb8:	896080e7          	jalr	-1898(ra) # 444a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2bbc:	4581                	li	a1,0
    2bbe:	00003517          	auipc	a0,0x3
    2bc2:	06a50513          	addi	a0,a0,106 # 5c28 <malloc+0x13c8>
    2bc6:	00002097          	auipc	ra,0x2
    2bca:	89c080e7          	jalr	-1892(ra) # 4462 <open>
    2bce:	38055463          	bgez	a0,2f56 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2bd2:	20200593          	li	a1,514
    2bd6:	00003517          	auipc	a0,0x3
    2bda:	26250513          	addi	a0,a0,610 # 5e38 <malloc+0x15d8>
    2bde:	00002097          	auipc	ra,0x2
    2be2:	884080e7          	jalr	-1916(ra) # 4462 <open>
    2be6:	38055663          	bgez	a0,2f72 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2bea:	20200593          	li	a1,514
    2bee:	00003517          	auipc	a0,0x3
    2bf2:	27a50513          	addi	a0,a0,634 # 5e68 <malloc+0x1608>
    2bf6:	00002097          	auipc	ra,0x2
    2bfa:	86c080e7          	jalr	-1940(ra) # 4462 <open>
    2bfe:	38055863          	bgez	a0,2f8e <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2c02:	20000593          	li	a1,512
    2c06:	00003517          	auipc	a0,0x3
    2c0a:	f8250513          	addi	a0,a0,-126 # 5b88 <malloc+0x1328>
    2c0e:	00002097          	auipc	ra,0x2
    2c12:	854080e7          	jalr	-1964(ra) # 4462 <open>
    2c16:	38055a63          	bgez	a0,2faa <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2c1a:	4589                	li	a1,2
    2c1c:	00003517          	auipc	a0,0x3
    2c20:	f6c50513          	addi	a0,a0,-148 # 5b88 <malloc+0x1328>
    2c24:	00002097          	auipc	ra,0x2
    2c28:	83e080e7          	jalr	-1986(ra) # 4462 <open>
    2c2c:	38055d63          	bgez	a0,2fc6 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2c30:	4585                	li	a1,1
    2c32:	00003517          	auipc	a0,0x3
    2c36:	f5650513          	addi	a0,a0,-170 # 5b88 <malloc+0x1328>
    2c3a:	00002097          	auipc	ra,0x2
    2c3e:	828080e7          	jalr	-2008(ra) # 4462 <open>
    2c42:	3a055063          	bgez	a0,2fe2 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2c46:	00003597          	auipc	a1,0x3
    2c4a:	2b258593          	addi	a1,a1,690 # 5ef8 <malloc+0x1698>
    2c4e:	00003517          	auipc	a0,0x3
    2c52:	1ea50513          	addi	a0,a0,490 # 5e38 <malloc+0x15d8>
    2c56:	00002097          	auipc	ra,0x2
    2c5a:	82c080e7          	jalr	-2004(ra) # 4482 <link>
    2c5e:	3a050063          	beqz	a0,2ffe <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2c62:	00003597          	auipc	a1,0x3
    2c66:	29658593          	addi	a1,a1,662 # 5ef8 <malloc+0x1698>
    2c6a:	00003517          	auipc	a0,0x3
    2c6e:	1fe50513          	addi	a0,a0,510 # 5e68 <malloc+0x1608>
    2c72:	00002097          	auipc	ra,0x2
    2c76:	810080e7          	jalr	-2032(ra) # 4482 <link>
    2c7a:	3a050063          	beqz	a0,301a <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2c7e:	00003597          	auipc	a1,0x3
    2c82:	03258593          	addi	a1,a1,50 # 5cb0 <malloc+0x1450>
    2c86:	00003517          	auipc	a0,0x3
    2c8a:	f2250513          	addi	a0,a0,-222 # 5ba8 <malloc+0x1348>
    2c8e:	00001097          	auipc	ra,0x1
    2c92:	7f4080e7          	jalr	2036(ra) # 4482 <link>
    2c96:	3a050063          	beqz	a0,3036 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2c9a:	00003517          	auipc	a0,0x3
    2c9e:	19e50513          	addi	a0,a0,414 # 5e38 <malloc+0x15d8>
    2ca2:	00001097          	auipc	ra,0x1
    2ca6:	7e8080e7          	jalr	2024(ra) # 448a <mkdir>
    2caa:	3a050463          	beqz	a0,3052 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2cae:	00003517          	auipc	a0,0x3
    2cb2:	1ba50513          	addi	a0,a0,442 # 5e68 <malloc+0x1608>
    2cb6:	00001097          	auipc	ra,0x1
    2cba:	7d4080e7          	jalr	2004(ra) # 448a <mkdir>
    2cbe:	3a050863          	beqz	a0,306e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2cc2:	00003517          	auipc	a0,0x3
    2cc6:	fee50513          	addi	a0,a0,-18 # 5cb0 <malloc+0x1450>
    2cca:	00001097          	auipc	ra,0x1
    2cce:	7c0080e7          	jalr	1984(ra) # 448a <mkdir>
    2cd2:	3a050c63          	beqz	a0,308a <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2cd6:	00003517          	auipc	a0,0x3
    2cda:	19250513          	addi	a0,a0,402 # 5e68 <malloc+0x1608>
    2cde:	00001097          	auipc	ra,0x1
    2ce2:	794080e7          	jalr	1940(ra) # 4472 <unlink>
    2ce6:	3c050063          	beqz	a0,30a6 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2cea:	00003517          	auipc	a0,0x3
    2cee:	14e50513          	addi	a0,a0,334 # 5e38 <malloc+0x15d8>
    2cf2:	00001097          	auipc	ra,0x1
    2cf6:	780080e7          	jalr	1920(ra) # 4472 <unlink>
    2cfa:	3c050463          	beqz	a0,30c2 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2cfe:	00003517          	auipc	a0,0x3
    2d02:	eaa50513          	addi	a0,a0,-342 # 5ba8 <malloc+0x1348>
    2d06:	00001097          	auipc	ra,0x1
    2d0a:	78c080e7          	jalr	1932(ra) # 4492 <chdir>
    2d0e:	3c050863          	beqz	a0,30de <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2d12:	00003517          	auipc	a0,0x3
    2d16:	33650513          	addi	a0,a0,822 # 6048 <malloc+0x17e8>
    2d1a:	00001097          	auipc	ra,0x1
    2d1e:	778080e7          	jalr	1912(ra) # 4492 <chdir>
    2d22:	3c050c63          	beqz	a0,30fa <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    2d26:	00003517          	auipc	a0,0x3
    2d2a:	f8a50513          	addi	a0,a0,-118 # 5cb0 <malloc+0x1450>
    2d2e:	00001097          	auipc	ra,0x1
    2d32:	744080e7          	jalr	1860(ra) # 4472 <unlink>
    2d36:	3e051063          	bnez	a0,3116 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    2d3a:	00003517          	auipc	a0,0x3
    2d3e:	e6e50513          	addi	a0,a0,-402 # 5ba8 <malloc+0x1348>
    2d42:	00001097          	auipc	ra,0x1
    2d46:	730080e7          	jalr	1840(ra) # 4472 <unlink>
    2d4a:	3e051463          	bnez	a0,3132 <subdir+0x756>
  if(unlink("dd") == 0){
    2d4e:	00003517          	auipc	a0,0x3
    2d52:	e3a50513          	addi	a0,a0,-454 # 5b88 <malloc+0x1328>
    2d56:	00001097          	auipc	ra,0x1
    2d5a:	71c080e7          	jalr	1820(ra) # 4472 <unlink>
    2d5e:	3e050863          	beqz	a0,314e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2d62:	00003517          	auipc	a0,0x3
    2d66:	35650513          	addi	a0,a0,854 # 60b8 <malloc+0x1858>
    2d6a:	00001097          	auipc	ra,0x1
    2d6e:	708080e7          	jalr	1800(ra) # 4472 <unlink>
    2d72:	3e054c63          	bltz	a0,316a <subdir+0x78e>
  if(unlink("dd") < 0){
    2d76:	00003517          	auipc	a0,0x3
    2d7a:	e1250513          	addi	a0,a0,-494 # 5b88 <malloc+0x1328>
    2d7e:	00001097          	auipc	ra,0x1
    2d82:	6f4080e7          	jalr	1780(ra) # 4472 <unlink>
    2d86:	40054063          	bltz	a0,3186 <subdir+0x7aa>
}
    2d8a:	60e2                	ld	ra,24(sp)
    2d8c:	6442                	ld	s0,16(sp)
    2d8e:	64a2                	ld	s1,8(sp)
    2d90:	6902                	ld	s2,0(sp)
    2d92:	6105                	addi	sp,sp,32
    2d94:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2d96:	85ca                	mv	a1,s2
    2d98:	00003517          	auipc	a0,0x3
    2d9c:	df850513          	addi	a0,a0,-520 # 5b90 <malloc+0x1330>
    2da0:	00002097          	auipc	ra,0x2
    2da4:	a02080e7          	jalr	-1534(ra) # 47a2 <printf>
    exit(1);
    2da8:	4505                	li	a0,1
    2daa:	00001097          	auipc	ra,0x1
    2dae:	678080e7          	jalr	1656(ra) # 4422 <exit>
    printf("%s: create dd/ff failed\n", s);
    2db2:	85ca                	mv	a1,s2
    2db4:	00003517          	auipc	a0,0x3
    2db8:	dfc50513          	addi	a0,a0,-516 # 5bb0 <malloc+0x1350>
    2dbc:	00002097          	auipc	ra,0x2
    2dc0:	9e6080e7          	jalr	-1562(ra) # 47a2 <printf>
    exit(1);
    2dc4:	4505                	li	a0,1
    2dc6:	00001097          	auipc	ra,0x1
    2dca:	65c080e7          	jalr	1628(ra) # 4422 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2dce:	85ca                	mv	a1,s2
    2dd0:	00003517          	auipc	a0,0x3
    2dd4:	e0050513          	addi	a0,a0,-512 # 5bd0 <malloc+0x1370>
    2dd8:	00002097          	auipc	ra,0x2
    2ddc:	9ca080e7          	jalr	-1590(ra) # 47a2 <printf>
    exit(1);
    2de0:	4505                	li	a0,1
    2de2:	00001097          	auipc	ra,0x1
    2de6:	640080e7          	jalr	1600(ra) # 4422 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    2dea:	85ca                	mv	a1,s2
    2dec:	00003517          	auipc	a0,0x3
    2df0:	e1c50513          	addi	a0,a0,-484 # 5c08 <malloc+0x13a8>
    2df4:	00002097          	auipc	ra,0x2
    2df8:	9ae080e7          	jalr	-1618(ra) # 47a2 <printf>
    exit(1);
    2dfc:	4505                	li	a0,1
    2dfe:	00001097          	auipc	ra,0x1
    2e02:	624080e7          	jalr	1572(ra) # 4422 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2e06:	85ca                	mv	a1,s2
    2e08:	00003517          	auipc	a0,0x3
    2e0c:	e3050513          	addi	a0,a0,-464 # 5c38 <malloc+0x13d8>
    2e10:	00002097          	auipc	ra,0x2
    2e14:	992080e7          	jalr	-1646(ra) # 47a2 <printf>
    exit(1);
    2e18:	4505                	li	a0,1
    2e1a:	00001097          	auipc	ra,0x1
    2e1e:	608080e7          	jalr	1544(ra) # 4422 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2e22:	85ca                	mv	a1,s2
    2e24:	00003517          	auipc	a0,0x3
    2e28:	e4c50513          	addi	a0,a0,-436 # 5c70 <malloc+0x1410>
    2e2c:	00002097          	auipc	ra,0x2
    2e30:	976080e7          	jalr	-1674(ra) # 47a2 <printf>
    exit(1);
    2e34:	4505                	li	a0,1
    2e36:	00001097          	auipc	ra,0x1
    2e3a:	5ec080e7          	jalr	1516(ra) # 4422 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2e3e:	85ca                	mv	a1,s2
    2e40:	00003517          	auipc	a0,0x3
    2e44:	e5050513          	addi	a0,a0,-432 # 5c90 <malloc+0x1430>
    2e48:	00002097          	auipc	ra,0x2
    2e4c:	95a080e7          	jalr	-1702(ra) # 47a2 <printf>
    exit(1);
    2e50:	4505                	li	a0,1
    2e52:	00001097          	auipc	ra,0x1
    2e56:	5d0080e7          	jalr	1488(ra) # 4422 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    2e5a:	85ca                	mv	a1,s2
    2e5c:	00003517          	auipc	a0,0x3
    2e60:	e6450513          	addi	a0,a0,-412 # 5cc0 <malloc+0x1460>
    2e64:	00002097          	auipc	ra,0x2
    2e68:	93e080e7          	jalr	-1730(ra) # 47a2 <printf>
    exit(1);
    2e6c:	4505                	li	a0,1
    2e6e:	00001097          	auipc	ra,0x1
    2e72:	5b4080e7          	jalr	1460(ra) # 4422 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2e76:	85ca                	mv	a1,s2
    2e78:	00003517          	auipc	a0,0x3
    2e7c:	e7050513          	addi	a0,a0,-400 # 5ce8 <malloc+0x1488>
    2e80:	00002097          	auipc	ra,0x2
    2e84:	922080e7          	jalr	-1758(ra) # 47a2 <printf>
    exit(1);
    2e88:	4505                	li	a0,1
    2e8a:	00001097          	auipc	ra,0x1
    2e8e:	598080e7          	jalr	1432(ra) # 4422 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2e92:	85ca                	mv	a1,s2
    2e94:	00003517          	auipc	a0,0x3
    2e98:	e7450513          	addi	a0,a0,-396 # 5d08 <malloc+0x14a8>
    2e9c:	00002097          	auipc	ra,0x2
    2ea0:	906080e7          	jalr	-1786(ra) # 47a2 <printf>
    exit(1);
    2ea4:	4505                	li	a0,1
    2ea6:	00001097          	auipc	ra,0x1
    2eaa:	57c080e7          	jalr	1404(ra) # 4422 <exit>
    printf("%s: chdir dd failed\n", s);
    2eae:	85ca                	mv	a1,s2
    2eb0:	00003517          	auipc	a0,0x3
    2eb4:	e8050513          	addi	a0,a0,-384 # 5d30 <malloc+0x14d0>
    2eb8:	00002097          	auipc	ra,0x2
    2ebc:	8ea080e7          	jalr	-1814(ra) # 47a2 <printf>
    exit(1);
    2ec0:	4505                	li	a0,1
    2ec2:	00001097          	auipc	ra,0x1
    2ec6:	560080e7          	jalr	1376(ra) # 4422 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2eca:	85ca                	mv	a1,s2
    2ecc:	00003517          	auipc	a0,0x3
    2ed0:	e8c50513          	addi	a0,a0,-372 # 5d58 <malloc+0x14f8>
    2ed4:	00002097          	auipc	ra,0x2
    2ed8:	8ce080e7          	jalr	-1842(ra) # 47a2 <printf>
    exit(1);
    2edc:	4505                	li	a0,1
    2ede:	00001097          	auipc	ra,0x1
    2ee2:	544080e7          	jalr	1348(ra) # 4422 <exit>
    printf("chdir dd/../../dd failed\n", s);
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003517          	auipc	a0,0x3
    2eec:	ea050513          	addi	a0,a0,-352 # 5d88 <malloc+0x1528>
    2ef0:	00002097          	auipc	ra,0x2
    2ef4:	8b2080e7          	jalr	-1870(ra) # 47a2 <printf>
    exit(1);
    2ef8:	4505                	li	a0,1
    2efa:	00001097          	auipc	ra,0x1
    2efe:	528080e7          	jalr	1320(ra) # 4422 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f02:	85ca                	mv	a1,s2
    2f04:	00003517          	auipc	a0,0x3
    2f08:	eac50513          	addi	a0,a0,-340 # 5db0 <malloc+0x1550>
    2f0c:	00002097          	auipc	ra,0x2
    2f10:	896080e7          	jalr	-1898(ra) # 47a2 <printf>
    exit(1);
    2f14:	4505                	li	a0,1
    2f16:	00001097          	auipc	ra,0x1
    2f1a:	50c080e7          	jalr	1292(ra) # 4422 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f1e:	85ca                	mv	a1,s2
    2f20:	00003517          	auipc	a0,0x3
    2f24:	ea850513          	addi	a0,a0,-344 # 5dc8 <malloc+0x1568>
    2f28:	00002097          	auipc	ra,0x2
    2f2c:	87a080e7          	jalr	-1926(ra) # 47a2 <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	00001097          	auipc	ra,0x1
    2f36:	4f0080e7          	jalr	1264(ra) # 4422 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2f3a:	85ca                	mv	a1,s2
    2f3c:	00003517          	auipc	a0,0x3
    2f40:	eac50513          	addi	a0,a0,-340 # 5de8 <malloc+0x1588>
    2f44:	00002097          	auipc	ra,0x2
    2f48:	85e080e7          	jalr	-1954(ra) # 47a2 <printf>
    exit(1);
    2f4c:	4505                	li	a0,1
    2f4e:	00001097          	auipc	ra,0x1
    2f52:	4d4080e7          	jalr	1236(ra) # 4422 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2f56:	85ca                	mv	a1,s2
    2f58:	00003517          	auipc	a0,0x3
    2f5c:	eb050513          	addi	a0,a0,-336 # 5e08 <malloc+0x15a8>
    2f60:	00002097          	auipc	ra,0x2
    2f64:	842080e7          	jalr	-1982(ra) # 47a2 <printf>
    exit(1);
    2f68:	4505                	li	a0,1
    2f6a:	00001097          	auipc	ra,0x1
    2f6e:	4b8080e7          	jalr	1208(ra) # 4422 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00003517          	auipc	a0,0x3
    2f78:	ed450513          	addi	a0,a0,-300 # 5e48 <malloc+0x15e8>
    2f7c:	00002097          	auipc	ra,0x2
    2f80:	826080e7          	jalr	-2010(ra) # 47a2 <printf>
    exit(1);
    2f84:	4505                	li	a0,1
    2f86:	00001097          	auipc	ra,0x1
    2f8a:	49c080e7          	jalr	1180(ra) # 4422 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2f8e:	85ca                	mv	a1,s2
    2f90:	00003517          	auipc	a0,0x3
    2f94:	ee850513          	addi	a0,a0,-280 # 5e78 <malloc+0x1618>
    2f98:	00002097          	auipc	ra,0x2
    2f9c:	80a080e7          	jalr	-2038(ra) # 47a2 <printf>
    exit(1);
    2fa0:	4505                	li	a0,1
    2fa2:	00001097          	auipc	ra,0x1
    2fa6:	480080e7          	jalr	1152(ra) # 4422 <exit>
    printf("%s: create dd succeeded!\n", s);
    2faa:	85ca                	mv	a1,s2
    2fac:	00003517          	auipc	a0,0x3
    2fb0:	eec50513          	addi	a0,a0,-276 # 5e98 <malloc+0x1638>
    2fb4:	00001097          	auipc	ra,0x1
    2fb8:	7ee080e7          	jalr	2030(ra) # 47a2 <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	00001097          	auipc	ra,0x1
    2fc2:	464080e7          	jalr	1124(ra) # 4422 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2fc6:	85ca                	mv	a1,s2
    2fc8:	00003517          	auipc	a0,0x3
    2fcc:	ef050513          	addi	a0,a0,-272 # 5eb8 <malloc+0x1658>
    2fd0:	00001097          	auipc	ra,0x1
    2fd4:	7d2080e7          	jalr	2002(ra) # 47a2 <printf>
    exit(1);
    2fd8:	4505                	li	a0,1
    2fda:	00001097          	auipc	ra,0x1
    2fde:	448080e7          	jalr	1096(ra) # 4422 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2fe2:	85ca                	mv	a1,s2
    2fe4:	00003517          	auipc	a0,0x3
    2fe8:	ef450513          	addi	a0,a0,-268 # 5ed8 <malloc+0x1678>
    2fec:	00001097          	auipc	ra,0x1
    2ff0:	7b6080e7          	jalr	1974(ra) # 47a2 <printf>
    exit(1);
    2ff4:	4505                	li	a0,1
    2ff6:	00001097          	auipc	ra,0x1
    2ffa:	42c080e7          	jalr	1068(ra) # 4422 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00003517          	auipc	a0,0x3
    3004:	f0850513          	addi	a0,a0,-248 # 5f08 <malloc+0x16a8>
    3008:	00001097          	auipc	ra,0x1
    300c:	79a080e7          	jalr	1946(ra) # 47a2 <printf>
    exit(1);
    3010:	4505                	li	a0,1
    3012:	00001097          	auipc	ra,0x1
    3016:	410080e7          	jalr	1040(ra) # 4422 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    301a:	85ca                	mv	a1,s2
    301c:	00003517          	auipc	a0,0x3
    3020:	f1450513          	addi	a0,a0,-236 # 5f30 <malloc+0x16d0>
    3024:	00001097          	auipc	ra,0x1
    3028:	77e080e7          	jalr	1918(ra) # 47a2 <printf>
    exit(1);
    302c:	4505                	li	a0,1
    302e:	00001097          	auipc	ra,0x1
    3032:	3f4080e7          	jalr	1012(ra) # 4422 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3036:	85ca                	mv	a1,s2
    3038:	00003517          	auipc	a0,0x3
    303c:	f2050513          	addi	a0,a0,-224 # 5f58 <malloc+0x16f8>
    3040:	00001097          	auipc	ra,0x1
    3044:	762080e7          	jalr	1890(ra) # 47a2 <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	00001097          	auipc	ra,0x1
    304e:	3d8080e7          	jalr	984(ra) # 4422 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3052:	85ca                	mv	a1,s2
    3054:	00003517          	auipc	a0,0x3
    3058:	f2c50513          	addi	a0,a0,-212 # 5f80 <malloc+0x1720>
    305c:	00001097          	auipc	ra,0x1
    3060:	746080e7          	jalr	1862(ra) # 47a2 <printf>
    exit(1);
    3064:	4505                	li	a0,1
    3066:	00001097          	auipc	ra,0x1
    306a:	3bc080e7          	jalr	956(ra) # 4422 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    306e:	85ca                	mv	a1,s2
    3070:	00003517          	auipc	a0,0x3
    3074:	f3050513          	addi	a0,a0,-208 # 5fa0 <malloc+0x1740>
    3078:	00001097          	auipc	ra,0x1
    307c:	72a080e7          	jalr	1834(ra) # 47a2 <printf>
    exit(1);
    3080:	4505                	li	a0,1
    3082:	00001097          	auipc	ra,0x1
    3086:	3a0080e7          	jalr	928(ra) # 4422 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    308a:	85ca                	mv	a1,s2
    308c:	00003517          	auipc	a0,0x3
    3090:	f3450513          	addi	a0,a0,-204 # 5fc0 <malloc+0x1760>
    3094:	00001097          	auipc	ra,0x1
    3098:	70e080e7          	jalr	1806(ra) # 47a2 <printf>
    exit(1);
    309c:	4505                	li	a0,1
    309e:	00001097          	auipc	ra,0x1
    30a2:	384080e7          	jalr	900(ra) # 4422 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30a6:	85ca                	mv	a1,s2
    30a8:	00003517          	auipc	a0,0x3
    30ac:	f4050513          	addi	a0,a0,-192 # 5fe8 <malloc+0x1788>
    30b0:	00001097          	auipc	ra,0x1
    30b4:	6f2080e7          	jalr	1778(ra) # 47a2 <printf>
    exit(1);
    30b8:	4505                	li	a0,1
    30ba:	00001097          	auipc	ra,0x1
    30be:	368080e7          	jalr	872(ra) # 4422 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30c2:	85ca                	mv	a1,s2
    30c4:	00003517          	auipc	a0,0x3
    30c8:	f4450513          	addi	a0,a0,-188 # 6008 <malloc+0x17a8>
    30cc:	00001097          	auipc	ra,0x1
    30d0:	6d6080e7          	jalr	1750(ra) # 47a2 <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	00001097          	auipc	ra,0x1
    30da:	34c080e7          	jalr	844(ra) # 4422 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30de:	85ca                	mv	a1,s2
    30e0:	00003517          	auipc	a0,0x3
    30e4:	f4850513          	addi	a0,a0,-184 # 6028 <malloc+0x17c8>
    30e8:	00001097          	auipc	ra,0x1
    30ec:	6ba080e7          	jalr	1722(ra) # 47a2 <printf>
    exit(1);
    30f0:	4505                	li	a0,1
    30f2:	00001097          	auipc	ra,0x1
    30f6:	330080e7          	jalr	816(ra) # 4422 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30fa:	85ca                	mv	a1,s2
    30fc:	00003517          	auipc	a0,0x3
    3100:	f5450513          	addi	a0,a0,-172 # 6050 <malloc+0x17f0>
    3104:	00001097          	auipc	ra,0x1
    3108:	69e080e7          	jalr	1694(ra) # 47a2 <printf>
    exit(1);
    310c:	4505                	li	a0,1
    310e:	00001097          	auipc	ra,0x1
    3112:	314080e7          	jalr	788(ra) # 4422 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00003517          	auipc	a0,0x3
    311c:	bd050513          	addi	a0,a0,-1072 # 5ce8 <malloc+0x1488>
    3120:	00001097          	auipc	ra,0x1
    3124:	682080e7          	jalr	1666(ra) # 47a2 <printf>
    exit(1);
    3128:	4505                	li	a0,1
    312a:	00001097          	auipc	ra,0x1
    312e:	2f8080e7          	jalr	760(ra) # 4422 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3132:	85ca                	mv	a1,s2
    3134:	00003517          	auipc	a0,0x3
    3138:	f3c50513          	addi	a0,a0,-196 # 6070 <malloc+0x1810>
    313c:	00001097          	auipc	ra,0x1
    3140:	666080e7          	jalr	1638(ra) # 47a2 <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	00001097          	auipc	ra,0x1
    314a:	2dc080e7          	jalr	732(ra) # 4422 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    314e:	85ca                	mv	a1,s2
    3150:	00003517          	auipc	a0,0x3
    3154:	f4050513          	addi	a0,a0,-192 # 6090 <malloc+0x1830>
    3158:	00001097          	auipc	ra,0x1
    315c:	64a080e7          	jalr	1610(ra) # 47a2 <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	00001097          	auipc	ra,0x1
    3166:	2c0080e7          	jalr	704(ra) # 4422 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    316a:	85ca                	mv	a1,s2
    316c:	00003517          	auipc	a0,0x3
    3170:	f5450513          	addi	a0,a0,-172 # 60c0 <malloc+0x1860>
    3174:	00001097          	auipc	ra,0x1
    3178:	62e080e7          	jalr	1582(ra) # 47a2 <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	00001097          	auipc	ra,0x1
    3182:	2a4080e7          	jalr	676(ra) # 4422 <exit>
    printf("%s: unlink dd failed\n", s);
    3186:	85ca                	mv	a1,s2
    3188:	00003517          	auipc	a0,0x3
    318c:	f5850513          	addi	a0,a0,-168 # 60e0 <malloc+0x1880>
    3190:	00001097          	auipc	ra,0x1
    3194:	612080e7          	jalr	1554(ra) # 47a2 <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	00001097          	auipc	ra,0x1
    319e:	288080e7          	jalr	648(ra) # 4422 <exit>

00000000000031a2 <dirfile>:
{
    31a2:	1101                	addi	sp,sp,-32
    31a4:	ec06                	sd	ra,24(sp)
    31a6:	e822                	sd	s0,16(sp)
    31a8:	e426                	sd	s1,8(sp)
    31aa:	e04a                	sd	s2,0(sp)
    31ac:	1000                	addi	s0,sp,32
    31ae:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    31b0:	20000593          	li	a1,512
    31b4:	00002517          	auipc	a0,0x2
    31b8:	9f450513          	addi	a0,a0,-1548 # 4ba8 <malloc+0x348>
    31bc:	00001097          	auipc	ra,0x1
    31c0:	2a6080e7          	jalr	678(ra) # 4462 <open>
  if(fd < 0){
    31c4:	0e054d63          	bltz	a0,32be <dirfile+0x11c>
  close(fd);
    31c8:	00001097          	auipc	ra,0x1
    31cc:	282080e7          	jalr	642(ra) # 444a <close>
  if(chdir("dirfile") == 0){
    31d0:	00002517          	auipc	a0,0x2
    31d4:	9d850513          	addi	a0,a0,-1576 # 4ba8 <malloc+0x348>
    31d8:	00001097          	auipc	ra,0x1
    31dc:	2ba080e7          	jalr	698(ra) # 4492 <chdir>
    31e0:	cd6d                	beqz	a0,32da <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    31e2:	4581                	li	a1,0
    31e4:	00003517          	auipc	a0,0x3
    31e8:	f5450513          	addi	a0,a0,-172 # 6138 <malloc+0x18d8>
    31ec:	00001097          	auipc	ra,0x1
    31f0:	276080e7          	jalr	630(ra) # 4462 <open>
  if(fd >= 0){
    31f4:	10055163          	bgez	a0,32f6 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    31f8:	20000593          	li	a1,512
    31fc:	00003517          	auipc	a0,0x3
    3200:	f3c50513          	addi	a0,a0,-196 # 6138 <malloc+0x18d8>
    3204:	00001097          	auipc	ra,0x1
    3208:	25e080e7          	jalr	606(ra) # 4462 <open>
  if(fd >= 0){
    320c:	10055363          	bgez	a0,3312 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3210:	00003517          	auipc	a0,0x3
    3214:	f2850513          	addi	a0,a0,-216 # 6138 <malloc+0x18d8>
    3218:	00001097          	auipc	ra,0x1
    321c:	272080e7          	jalr	626(ra) # 448a <mkdir>
    3220:	10050763          	beqz	a0,332e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3224:	00003517          	auipc	a0,0x3
    3228:	f1450513          	addi	a0,a0,-236 # 6138 <malloc+0x18d8>
    322c:	00001097          	auipc	ra,0x1
    3230:	246080e7          	jalr	582(ra) # 4472 <unlink>
    3234:	10050b63          	beqz	a0,334a <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3238:	00003597          	auipc	a1,0x3
    323c:	f0058593          	addi	a1,a1,-256 # 6138 <malloc+0x18d8>
    3240:	00003517          	auipc	a0,0x3
    3244:	f8050513          	addi	a0,a0,-128 # 61c0 <malloc+0x1960>
    3248:	00001097          	auipc	ra,0x1
    324c:	23a080e7          	jalr	570(ra) # 4482 <link>
    3250:	10050b63          	beqz	a0,3366 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3254:	00002517          	auipc	a0,0x2
    3258:	95450513          	addi	a0,a0,-1708 # 4ba8 <malloc+0x348>
    325c:	00001097          	auipc	ra,0x1
    3260:	216080e7          	jalr	534(ra) # 4472 <unlink>
    3264:	10051f63          	bnez	a0,3382 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3268:	4589                	li	a1,2
    326a:	00002517          	auipc	a0,0x2
    326e:	a4650513          	addi	a0,a0,-1466 # 4cb0 <malloc+0x450>
    3272:	00001097          	auipc	ra,0x1
    3276:	1f0080e7          	jalr	496(ra) # 4462 <open>
  if(fd >= 0){
    327a:	12055263          	bgez	a0,339e <dirfile+0x1fc>
  fd = open(".", 0);
    327e:	4581                	li	a1,0
    3280:	00002517          	auipc	a0,0x2
    3284:	a3050513          	addi	a0,a0,-1488 # 4cb0 <malloc+0x450>
    3288:	00001097          	auipc	ra,0x1
    328c:	1da080e7          	jalr	474(ra) # 4462 <open>
    3290:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3292:	4605                	li	a2,1
    3294:	00002597          	auipc	a1,0x2
    3298:	47c58593          	addi	a1,a1,1148 # 5710 <malloc+0xeb0>
    329c:	00001097          	auipc	ra,0x1
    32a0:	1a6080e7          	jalr	422(ra) # 4442 <write>
    32a4:	10a04b63          	bgtz	a0,33ba <dirfile+0x218>
  close(fd);
    32a8:	8526                	mv	a0,s1
    32aa:	00001097          	auipc	ra,0x1
    32ae:	1a0080e7          	jalr	416(ra) # 444a <close>
}
    32b2:	60e2                	ld	ra,24(sp)
    32b4:	6442                	ld	s0,16(sp)
    32b6:	64a2                	ld	s1,8(sp)
    32b8:	6902                	ld	s2,0(sp)
    32ba:	6105                	addi	sp,sp,32
    32bc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    32be:	85ca                	mv	a1,s2
    32c0:	00003517          	auipc	a0,0x3
    32c4:	e3850513          	addi	a0,a0,-456 # 60f8 <malloc+0x1898>
    32c8:	00001097          	auipc	ra,0x1
    32cc:	4da080e7          	jalr	1242(ra) # 47a2 <printf>
    exit(1);
    32d0:	4505                	li	a0,1
    32d2:	00001097          	auipc	ra,0x1
    32d6:	150080e7          	jalr	336(ra) # 4422 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    32da:	85ca                	mv	a1,s2
    32dc:	00003517          	auipc	a0,0x3
    32e0:	e3c50513          	addi	a0,a0,-452 # 6118 <malloc+0x18b8>
    32e4:	00001097          	auipc	ra,0x1
    32e8:	4be080e7          	jalr	1214(ra) # 47a2 <printf>
    exit(1);
    32ec:	4505                	li	a0,1
    32ee:	00001097          	auipc	ra,0x1
    32f2:	134080e7          	jalr	308(ra) # 4422 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    32f6:	85ca                	mv	a1,s2
    32f8:	00003517          	auipc	a0,0x3
    32fc:	e5050513          	addi	a0,a0,-432 # 6148 <malloc+0x18e8>
    3300:	00001097          	auipc	ra,0x1
    3304:	4a2080e7          	jalr	1186(ra) # 47a2 <printf>
    exit(1);
    3308:	4505                	li	a0,1
    330a:	00001097          	auipc	ra,0x1
    330e:	118080e7          	jalr	280(ra) # 4422 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3312:	85ca                	mv	a1,s2
    3314:	00003517          	auipc	a0,0x3
    3318:	e3450513          	addi	a0,a0,-460 # 6148 <malloc+0x18e8>
    331c:	00001097          	auipc	ra,0x1
    3320:	486080e7          	jalr	1158(ra) # 47a2 <printf>
    exit(1);
    3324:	4505                	li	a0,1
    3326:	00001097          	auipc	ra,0x1
    332a:	0fc080e7          	jalr	252(ra) # 4422 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    332e:	85ca                	mv	a1,s2
    3330:	00003517          	auipc	a0,0x3
    3334:	e4050513          	addi	a0,a0,-448 # 6170 <malloc+0x1910>
    3338:	00001097          	auipc	ra,0x1
    333c:	46a080e7          	jalr	1130(ra) # 47a2 <printf>
    exit(1);
    3340:	4505                	li	a0,1
    3342:	00001097          	auipc	ra,0x1
    3346:	0e0080e7          	jalr	224(ra) # 4422 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    334a:	85ca                	mv	a1,s2
    334c:	00003517          	auipc	a0,0x3
    3350:	e4c50513          	addi	a0,a0,-436 # 6198 <malloc+0x1938>
    3354:	00001097          	auipc	ra,0x1
    3358:	44e080e7          	jalr	1102(ra) # 47a2 <printf>
    exit(1);
    335c:	4505                	li	a0,1
    335e:	00001097          	auipc	ra,0x1
    3362:	0c4080e7          	jalr	196(ra) # 4422 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3366:	85ca                	mv	a1,s2
    3368:	00003517          	auipc	a0,0x3
    336c:	e6050513          	addi	a0,a0,-416 # 61c8 <malloc+0x1968>
    3370:	00001097          	auipc	ra,0x1
    3374:	432080e7          	jalr	1074(ra) # 47a2 <printf>
    exit(1);
    3378:	4505                	li	a0,1
    337a:	00001097          	auipc	ra,0x1
    337e:	0a8080e7          	jalr	168(ra) # 4422 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3382:	85ca                	mv	a1,s2
    3384:	00003517          	auipc	a0,0x3
    3388:	e6c50513          	addi	a0,a0,-404 # 61f0 <malloc+0x1990>
    338c:	00001097          	auipc	ra,0x1
    3390:	416080e7          	jalr	1046(ra) # 47a2 <printf>
    exit(1);
    3394:	4505                	li	a0,1
    3396:	00001097          	auipc	ra,0x1
    339a:	08c080e7          	jalr	140(ra) # 4422 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    339e:	85ca                	mv	a1,s2
    33a0:	00003517          	auipc	a0,0x3
    33a4:	e7050513          	addi	a0,a0,-400 # 6210 <malloc+0x19b0>
    33a8:	00001097          	auipc	ra,0x1
    33ac:	3fa080e7          	jalr	1018(ra) # 47a2 <printf>
    exit(1);
    33b0:	4505                	li	a0,1
    33b2:	00001097          	auipc	ra,0x1
    33b6:	070080e7          	jalr	112(ra) # 4422 <exit>
    printf("%s: write . succeeded!\n", s);
    33ba:	85ca                	mv	a1,s2
    33bc:	00003517          	auipc	a0,0x3
    33c0:	e7c50513          	addi	a0,a0,-388 # 6238 <malloc+0x19d8>
    33c4:	00001097          	auipc	ra,0x1
    33c8:	3de080e7          	jalr	990(ra) # 47a2 <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	00001097          	auipc	ra,0x1
    33d2:	054080e7          	jalr	84(ra) # 4422 <exit>

00000000000033d6 <iref>:
{
    33d6:	7139                	addi	sp,sp,-64
    33d8:	fc06                	sd	ra,56(sp)
    33da:	f822                	sd	s0,48(sp)
    33dc:	f426                	sd	s1,40(sp)
    33de:	f04a                	sd	s2,32(sp)
    33e0:	ec4e                	sd	s3,24(sp)
    33e2:	e852                	sd	s4,16(sp)
    33e4:	e456                	sd	s5,8(sp)
    33e6:	e05a                	sd	s6,0(sp)
    33e8:	0080                	addi	s0,sp,64
    33ea:	8b2a                	mv	s6,a0
    33ec:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    33f0:	00003a17          	auipc	s4,0x3
    33f4:	e60a0a13          	addi	s4,s4,-416 # 6250 <malloc+0x19f0>
    mkdir("");
    33f8:	00003497          	auipc	s1,0x3
    33fc:	a3848493          	addi	s1,s1,-1480 # 5e30 <malloc+0x15d0>
    link("README", "");
    3400:	00003a97          	auipc	s5,0x3
    3404:	dc0a8a93          	addi	s5,s5,-576 # 61c0 <malloc+0x1960>
    fd = open("xx", O_CREATE);
    3408:	00003997          	auipc	s3,0x3
    340c:	d3898993          	addi	s3,s3,-712 # 6140 <malloc+0x18e0>
    3410:	a891                	j	3464 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3412:	85da                	mv	a1,s6
    3414:	00003517          	auipc	a0,0x3
    3418:	e4450513          	addi	a0,a0,-444 # 6258 <malloc+0x19f8>
    341c:	00001097          	auipc	ra,0x1
    3420:	386080e7          	jalr	902(ra) # 47a2 <printf>
      exit(1);
    3424:	4505                	li	a0,1
    3426:	00001097          	auipc	ra,0x1
    342a:	ffc080e7          	jalr	-4(ra) # 4422 <exit>
      printf("%s: chdir irefd failed\n", s);
    342e:	85da                	mv	a1,s6
    3430:	00003517          	auipc	a0,0x3
    3434:	e4050513          	addi	a0,a0,-448 # 6270 <malloc+0x1a10>
    3438:	00001097          	auipc	ra,0x1
    343c:	36a080e7          	jalr	874(ra) # 47a2 <printf>
      exit(1);
    3440:	4505                	li	a0,1
    3442:	00001097          	auipc	ra,0x1
    3446:	fe0080e7          	jalr	-32(ra) # 4422 <exit>
      close(fd);
    344a:	00001097          	auipc	ra,0x1
    344e:	000080e7          	jalr	ra # 444a <close>
    3452:	a889                	j	34a4 <iref+0xce>
    unlink("xx");
    3454:	854e                	mv	a0,s3
    3456:	00001097          	auipc	ra,0x1
    345a:	01c080e7          	jalr	28(ra) # 4472 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    345e:	397d                	addiw	s2,s2,-1
    3460:	06090063          	beqz	s2,34c0 <iref+0xea>
    if(mkdir("irefd") != 0){
    3464:	8552                	mv	a0,s4
    3466:	00001097          	auipc	ra,0x1
    346a:	024080e7          	jalr	36(ra) # 448a <mkdir>
    346e:	f155                	bnez	a0,3412 <iref+0x3c>
    if(chdir("irefd") != 0){
    3470:	8552                	mv	a0,s4
    3472:	00001097          	auipc	ra,0x1
    3476:	020080e7          	jalr	32(ra) # 4492 <chdir>
    347a:	f955                	bnez	a0,342e <iref+0x58>
    mkdir("");
    347c:	8526                	mv	a0,s1
    347e:	00001097          	auipc	ra,0x1
    3482:	00c080e7          	jalr	12(ra) # 448a <mkdir>
    link("README", "");
    3486:	85a6                	mv	a1,s1
    3488:	8556                	mv	a0,s5
    348a:	00001097          	auipc	ra,0x1
    348e:	ff8080e7          	jalr	-8(ra) # 4482 <link>
    fd = open("", O_CREATE);
    3492:	20000593          	li	a1,512
    3496:	8526                	mv	a0,s1
    3498:	00001097          	auipc	ra,0x1
    349c:	fca080e7          	jalr	-54(ra) # 4462 <open>
    if(fd >= 0)
    34a0:	fa0555e3          	bgez	a0,344a <iref+0x74>
    fd = open("xx", O_CREATE);
    34a4:	20000593          	li	a1,512
    34a8:	854e                	mv	a0,s3
    34aa:	00001097          	auipc	ra,0x1
    34ae:	fb8080e7          	jalr	-72(ra) # 4462 <open>
    if(fd >= 0)
    34b2:	fa0541e3          	bltz	a0,3454 <iref+0x7e>
      close(fd);
    34b6:	00001097          	auipc	ra,0x1
    34ba:	f94080e7          	jalr	-108(ra) # 444a <close>
    34be:	bf59                	j	3454 <iref+0x7e>
  chdir("/");
    34c0:	00001517          	auipc	a0,0x1
    34c4:	79850513          	addi	a0,a0,1944 # 4c58 <malloc+0x3f8>
    34c8:	00001097          	auipc	ra,0x1
    34cc:	fca080e7          	jalr	-54(ra) # 4492 <chdir>
}
    34d0:	70e2                	ld	ra,56(sp)
    34d2:	7442                	ld	s0,48(sp)
    34d4:	74a2                	ld	s1,40(sp)
    34d6:	7902                	ld	s2,32(sp)
    34d8:	69e2                	ld	s3,24(sp)
    34da:	6a42                	ld	s4,16(sp)
    34dc:	6aa2                	ld	s5,8(sp)
    34de:	6b02                	ld	s6,0(sp)
    34e0:	6121                	addi	sp,sp,64
    34e2:	8082                	ret

00000000000034e4 <validatetest>:
{
    34e4:	7139                	addi	sp,sp,-64
    34e6:	fc06                	sd	ra,56(sp)
    34e8:	f822                	sd	s0,48(sp)
    34ea:	f426                	sd	s1,40(sp)
    34ec:	f04a                	sd	s2,32(sp)
    34ee:	ec4e                	sd	s3,24(sp)
    34f0:	e852                	sd	s4,16(sp)
    34f2:	e456                	sd	s5,8(sp)
    34f4:	e05a                	sd	s6,0(sp)
    34f6:	0080                	addi	s0,sp,64
    34f8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    34fa:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    34fc:	00003997          	auipc	s3,0x3
    3500:	d8c98993          	addi	s3,s3,-628 # 6288 <malloc+0x1a28>
    3504:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3506:	6a85                	lui	s5,0x1
    3508:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    350c:	85a6                	mv	a1,s1
    350e:	854e                	mv	a0,s3
    3510:	00001097          	auipc	ra,0x1
    3514:	f72080e7          	jalr	-142(ra) # 4482 <link>
    3518:	01251f63          	bne	a0,s2,3536 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    351c:	94d6                	add	s1,s1,s5
    351e:	ff4497e3          	bne	s1,s4,350c <validatetest+0x28>
}
    3522:	70e2                	ld	ra,56(sp)
    3524:	7442                	ld	s0,48(sp)
    3526:	74a2                	ld	s1,40(sp)
    3528:	7902                	ld	s2,32(sp)
    352a:	69e2                	ld	s3,24(sp)
    352c:	6a42                	ld	s4,16(sp)
    352e:	6aa2                	ld	s5,8(sp)
    3530:	6b02                	ld	s6,0(sp)
    3532:	6121                	addi	sp,sp,64
    3534:	8082                	ret
      printf("%s: link should not succeed\n", s);
    3536:	85da                	mv	a1,s6
    3538:	00003517          	auipc	a0,0x3
    353c:	d6050513          	addi	a0,a0,-672 # 6298 <malloc+0x1a38>
    3540:	00001097          	auipc	ra,0x1
    3544:	262080e7          	jalr	610(ra) # 47a2 <printf>
      exit(1);
    3548:	4505                	li	a0,1
    354a:	00001097          	auipc	ra,0x1
    354e:	ed8080e7          	jalr	-296(ra) # 4422 <exit>

0000000000003552 <sbrkbasic>:
{
    3552:	7139                	addi	sp,sp,-64
    3554:	fc06                	sd	ra,56(sp)
    3556:	f822                	sd	s0,48(sp)
    3558:	f426                	sd	s1,40(sp)
    355a:	f04a                	sd	s2,32(sp)
    355c:	ec4e                	sd	s3,24(sp)
    355e:	e852                	sd	s4,16(sp)
    3560:	0080                	addi	s0,sp,64
    3562:	8a2a                	mv	s4,a0
  a = sbrk(TOOMUCH);
    3564:	40000537          	lui	a0,0x40000
    3568:	00001097          	auipc	ra,0x1
    356c:	f42080e7          	jalr	-190(ra) # 44aa <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    3570:	57fd                	li	a5,-1
    3572:	02f50063          	beq	a0,a5,3592 <sbrkbasic+0x40>
    3576:	85aa                	mv	a1,a0
    printf("%s: sbrk(<toomuch>) returned %p\n", a);
    3578:	00003517          	auipc	a0,0x3
    357c:	d4050513          	addi	a0,a0,-704 # 62b8 <malloc+0x1a58>
    3580:	00001097          	auipc	ra,0x1
    3584:	222080e7          	jalr	546(ra) # 47a2 <printf>
    exit(1);
    3588:	4505                	li	a0,1
    358a:	00001097          	auipc	ra,0x1
    358e:	e98080e7          	jalr	-360(ra) # 4422 <exit>
  a = sbrk(0);
    3592:	4501                	li	a0,0
    3594:	00001097          	auipc	ra,0x1
    3598:	f16080e7          	jalr	-234(ra) # 44aa <sbrk>
    359c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    359e:	4901                	li	s2,0
    35a0:	6985                	lui	s3,0x1
    35a2:	38898993          	addi	s3,s3,904 # 1388 <unlinkread+0x10e>
    35a6:	a011                	j	35aa <sbrkbasic+0x58>
    a = b + 1;
    35a8:	84be                	mv	s1,a5
    b = sbrk(1);
    35aa:	4505                	li	a0,1
    35ac:	00001097          	auipc	ra,0x1
    35b0:	efe080e7          	jalr	-258(ra) # 44aa <sbrk>
    if(b != a){
    35b4:	04951c63          	bne	a0,s1,360c <sbrkbasic+0xba>
    *b = 1;
    35b8:	4785                	li	a5,1
    35ba:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    35be:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    35c2:	2905                	addiw	s2,s2,1
    35c4:	ff3912e3          	bne	s2,s3,35a8 <sbrkbasic+0x56>
  pid = fork();
    35c8:	00001097          	auipc	ra,0x1
    35cc:	e52080e7          	jalr	-430(ra) # 441a <fork>
    35d0:	892a                	mv	s2,a0
  if(pid < 0){
    35d2:	04054d63          	bltz	a0,362c <sbrkbasic+0xda>
  c = sbrk(1);
    35d6:	4505                	li	a0,1
    35d8:	00001097          	auipc	ra,0x1
    35dc:	ed2080e7          	jalr	-302(ra) # 44aa <sbrk>
  c = sbrk(1);
    35e0:	4505                	li	a0,1
    35e2:	00001097          	auipc	ra,0x1
    35e6:	ec8080e7          	jalr	-312(ra) # 44aa <sbrk>
  if(c != a + 1){
    35ea:	0489                	addi	s1,s1,2
    35ec:	04a48e63          	beq	s1,a0,3648 <sbrkbasic+0xf6>
    printf("%s: sbrk test failed post-fork\n", s);
    35f0:	85d2                	mv	a1,s4
    35f2:	00003517          	auipc	a0,0x3
    35f6:	d2e50513          	addi	a0,a0,-722 # 6320 <malloc+0x1ac0>
    35fa:	00001097          	auipc	ra,0x1
    35fe:	1a8080e7          	jalr	424(ra) # 47a2 <printf>
    exit(1);
    3602:	4505                	li	a0,1
    3604:	00001097          	auipc	ra,0x1
    3608:	e1e080e7          	jalr	-482(ra) # 4422 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    360c:	86aa                	mv	a3,a0
    360e:	8626                	mv	a2,s1
    3610:	85ca                	mv	a1,s2
    3612:	00003517          	auipc	a0,0x3
    3616:	cce50513          	addi	a0,a0,-818 # 62e0 <malloc+0x1a80>
    361a:	00001097          	auipc	ra,0x1
    361e:	188080e7          	jalr	392(ra) # 47a2 <printf>
      exit(1);
    3622:	4505                	li	a0,1
    3624:	00001097          	auipc	ra,0x1
    3628:	dfe080e7          	jalr	-514(ra) # 4422 <exit>
    printf("%s: sbrk test fork failed\n", s);
    362c:	85d2                	mv	a1,s4
    362e:	00003517          	auipc	a0,0x3
    3632:	cd250513          	addi	a0,a0,-814 # 6300 <malloc+0x1aa0>
    3636:	00001097          	auipc	ra,0x1
    363a:	16c080e7          	jalr	364(ra) # 47a2 <printf>
    exit(1);
    363e:	4505                	li	a0,1
    3640:	00001097          	auipc	ra,0x1
    3644:	de2080e7          	jalr	-542(ra) # 4422 <exit>
  if(pid == 0)
    3648:	00091763          	bnez	s2,3656 <sbrkbasic+0x104>
    exit(0);
    364c:	4501                	li	a0,0
    364e:	00001097          	auipc	ra,0x1
    3652:	dd4080e7          	jalr	-556(ra) # 4422 <exit>
  wait(&xstatus);
    3656:	fcc40513          	addi	a0,s0,-52
    365a:	00001097          	auipc	ra,0x1
    365e:	dd0080e7          	jalr	-560(ra) # 442a <wait>
  exit(xstatus);
    3662:	fcc42503          	lw	a0,-52(s0)
    3666:	00001097          	auipc	ra,0x1
    366a:	dbc080e7          	jalr	-580(ra) # 4422 <exit>

000000000000366e <sbrkmuch>:
{
    366e:	7179                	addi	sp,sp,-48
    3670:	f406                	sd	ra,40(sp)
    3672:	f022                	sd	s0,32(sp)
    3674:	ec26                	sd	s1,24(sp)
    3676:	e84a                	sd	s2,16(sp)
    3678:	e44e                	sd	s3,8(sp)
    367a:	e052                	sd	s4,0(sp)
    367c:	1800                	addi	s0,sp,48
    367e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    3680:	4501                	li	a0,0
    3682:	00001097          	auipc	ra,0x1
    3686:	e28080e7          	jalr	-472(ra) # 44aa <sbrk>
    368a:	892a                	mv	s2,a0
  a = sbrk(0);
    368c:	4501                	li	a0,0
    368e:	00001097          	auipc	ra,0x1
    3692:	e1c080e7          	jalr	-484(ra) # 44aa <sbrk>
    3696:	84aa                	mv	s1,a0
  p = sbrk(amt);
    3698:	06400537          	lui	a0,0x6400
    369c:	9d05                	subw	a0,a0,s1
    369e:	00001097          	auipc	ra,0x1
    36a2:	e0c080e7          	jalr	-500(ra) # 44aa <sbrk>
  if (p != a) {
    36a6:	0aa49963          	bne	s1,a0,3758 <sbrkmuch+0xea>
  *lastaddr = 99;
    36aa:	064007b7          	lui	a5,0x6400
    36ae:	06300713          	li	a4,99
    36b2:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3dbf>
  a = sbrk(0);
    36b6:	4501                	li	a0,0
    36b8:	00001097          	auipc	ra,0x1
    36bc:	df2080e7          	jalr	-526(ra) # 44aa <sbrk>
    36c0:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    36c2:	757d                	lui	a0,0xfffff
    36c4:	00001097          	auipc	ra,0x1
    36c8:	de6080e7          	jalr	-538(ra) # 44aa <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    36cc:	57fd                	li	a5,-1
    36ce:	0af50363          	beq	a0,a5,3774 <sbrkmuch+0x106>
  c = sbrk(0);
    36d2:	4501                	li	a0,0
    36d4:	00001097          	auipc	ra,0x1
    36d8:	dd6080e7          	jalr	-554(ra) # 44aa <sbrk>
  if(c != a - PGSIZE){
    36dc:	77fd                	lui	a5,0xfffff
    36de:	97a6                	add	a5,a5,s1
    36e0:	0af51863          	bne	a0,a5,3790 <sbrkmuch+0x122>
  a = sbrk(0);
    36e4:	4501                	li	a0,0
    36e6:	00001097          	auipc	ra,0x1
    36ea:	dc4080e7          	jalr	-572(ra) # 44aa <sbrk>
    36ee:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    36f0:	6505                	lui	a0,0x1
    36f2:	00001097          	auipc	ra,0x1
    36f6:	db8080e7          	jalr	-584(ra) # 44aa <sbrk>
    36fa:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    36fc:	0aa49963          	bne	s1,a0,37ae <sbrkmuch+0x140>
    3700:	4501                	li	a0,0
    3702:	00001097          	auipc	ra,0x1
    3706:	da8080e7          	jalr	-600(ra) # 44aa <sbrk>
    370a:	6785                	lui	a5,0x1
    370c:	97a6                	add	a5,a5,s1
    370e:	0af51063          	bne	a0,a5,37ae <sbrkmuch+0x140>
  if(*lastaddr == 99){
    3712:	064007b7          	lui	a5,0x6400
    3716:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3dbf>
    371a:	06300793          	li	a5,99
    371e:	0af70763          	beq	a4,a5,37cc <sbrkmuch+0x15e>
  a = sbrk(0);
    3722:	4501                	li	a0,0
    3724:	00001097          	auipc	ra,0x1
    3728:	d86080e7          	jalr	-634(ra) # 44aa <sbrk>
    372c:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    372e:	4501                	li	a0,0
    3730:	00001097          	auipc	ra,0x1
    3734:	d7a080e7          	jalr	-646(ra) # 44aa <sbrk>
    3738:	40a9053b          	subw	a0,s2,a0
    373c:	00001097          	auipc	ra,0x1
    3740:	d6e080e7          	jalr	-658(ra) # 44aa <sbrk>
  if(c != a){
    3744:	0aa49263          	bne	s1,a0,37e8 <sbrkmuch+0x17a>
}
    3748:	70a2                	ld	ra,40(sp)
    374a:	7402                	ld	s0,32(sp)
    374c:	64e2                	ld	s1,24(sp)
    374e:	6942                	ld	s2,16(sp)
    3750:	69a2                	ld	s3,8(sp)
    3752:	6a02                	ld	s4,0(sp)
    3754:	6145                	addi	sp,sp,48
    3756:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    3758:	85ce                	mv	a1,s3
    375a:	00003517          	auipc	a0,0x3
    375e:	be650513          	addi	a0,a0,-1050 # 6340 <malloc+0x1ae0>
    3762:	00001097          	auipc	ra,0x1
    3766:	040080e7          	jalr	64(ra) # 47a2 <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	00001097          	auipc	ra,0x1
    3770:	cb6080e7          	jalr	-842(ra) # 4422 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    3774:	85ce                	mv	a1,s3
    3776:	00003517          	auipc	a0,0x3
    377a:	c1250513          	addi	a0,a0,-1006 # 6388 <malloc+0x1b28>
    377e:	00001097          	auipc	ra,0x1
    3782:	024080e7          	jalr	36(ra) # 47a2 <printf>
    exit(1);
    3786:	4505                	li	a0,1
    3788:	00001097          	auipc	ra,0x1
    378c:	c9a080e7          	jalr	-870(ra) # 4422 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3790:	862a                	mv	a2,a0
    3792:	85a6                	mv	a1,s1
    3794:	00003517          	auipc	a0,0x3
    3798:	c1450513          	addi	a0,a0,-1004 # 63a8 <malloc+0x1b48>
    379c:	00001097          	auipc	ra,0x1
    37a0:	006080e7          	jalr	6(ra) # 47a2 <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00001097          	auipc	ra,0x1
    37aa:	c7c080e7          	jalr	-900(ra) # 4422 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    37ae:	8652                	mv	a2,s4
    37b0:	85a6                	mv	a1,s1
    37b2:	00003517          	auipc	a0,0x3
    37b6:	c3650513          	addi	a0,a0,-970 # 63e8 <malloc+0x1b88>
    37ba:	00001097          	auipc	ra,0x1
    37be:	fe8080e7          	jalr	-24(ra) # 47a2 <printf>
    exit(1);
    37c2:	4505                	li	a0,1
    37c4:	00001097          	auipc	ra,0x1
    37c8:	c5e080e7          	jalr	-930(ra) # 4422 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    37cc:	85ce                	mv	a1,s3
    37ce:	00003517          	auipc	a0,0x3
    37d2:	c4a50513          	addi	a0,a0,-950 # 6418 <malloc+0x1bb8>
    37d6:	00001097          	auipc	ra,0x1
    37da:	fcc080e7          	jalr	-52(ra) # 47a2 <printf>
    exit(1);
    37de:	4505                	li	a0,1
    37e0:	00001097          	auipc	ra,0x1
    37e4:	c42080e7          	jalr	-958(ra) # 4422 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    37e8:	862a                	mv	a2,a0
    37ea:	85a6                	mv	a1,s1
    37ec:	00003517          	auipc	a0,0x3
    37f0:	c6450513          	addi	a0,a0,-924 # 6450 <malloc+0x1bf0>
    37f4:	00001097          	auipc	ra,0x1
    37f8:	fae080e7          	jalr	-82(ra) # 47a2 <printf>
    exit(1);
    37fc:	4505                	li	a0,1
    37fe:	00001097          	auipc	ra,0x1
    3802:	c24080e7          	jalr	-988(ra) # 4422 <exit>

0000000000003806 <sbrkfail>:
{
    3806:	7119                	addi	sp,sp,-128
    3808:	fc86                	sd	ra,120(sp)
    380a:	f8a2                	sd	s0,112(sp)
    380c:	f4a6                	sd	s1,104(sp)
    380e:	f0ca                	sd	s2,96(sp)
    3810:	ecce                	sd	s3,88(sp)
    3812:	e8d2                	sd	s4,80(sp)
    3814:	e4d6                	sd	s5,72(sp)
    3816:	0100                	addi	s0,sp,128
    3818:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    381a:	fb040513          	addi	a0,s0,-80
    381e:	00001097          	auipc	ra,0x1
    3822:	c14080e7          	jalr	-1004(ra) # 4432 <pipe>
    3826:	e901                	bnez	a0,3836 <sbrkfail+0x30>
    3828:	f8040493          	addi	s1,s0,-128
    382c:	fa840993          	addi	s3,s0,-88
    3830:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3832:	5a7d                	li	s4,-1
    3834:	a085                	j	3894 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3836:	85d6                	mv	a1,s5
    3838:	00002517          	auipc	a0,0x2
    383c:	e5850513          	addi	a0,a0,-424 # 5690 <malloc+0xe30>
    3840:	00001097          	auipc	ra,0x1
    3844:	f62080e7          	jalr	-158(ra) # 47a2 <printf>
    exit(1);
    3848:	4505                	li	a0,1
    384a:	00001097          	auipc	ra,0x1
    384e:	bd8080e7          	jalr	-1064(ra) # 4422 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3852:	00001097          	auipc	ra,0x1
    3856:	c58080e7          	jalr	-936(ra) # 44aa <sbrk>
    385a:	064007b7          	lui	a5,0x6400
    385e:	40a7853b          	subw	a0,a5,a0
    3862:	00001097          	auipc	ra,0x1
    3866:	c48080e7          	jalr	-952(ra) # 44aa <sbrk>
      write(fds[1], "x", 1);
    386a:	4605                	li	a2,1
    386c:	00002597          	auipc	a1,0x2
    3870:	ea458593          	addi	a1,a1,-348 # 5710 <malloc+0xeb0>
    3874:	fb442503          	lw	a0,-76(s0)
    3878:	00001097          	auipc	ra,0x1
    387c:	bca080e7          	jalr	-1078(ra) # 4442 <write>
      for(;;) sleep(1000);
    3880:	3e800513          	li	a0,1000
    3884:	00001097          	auipc	ra,0x1
    3888:	c2e080e7          	jalr	-978(ra) # 44b2 <sleep>
    388c:	bfd5                	j	3880 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    388e:	0911                	addi	s2,s2,4
    3890:	03390563          	beq	s2,s3,38ba <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3894:	00001097          	auipc	ra,0x1
    3898:	b86080e7          	jalr	-1146(ra) # 441a <fork>
    389c:	00a92023          	sw	a0,0(s2) # 3000 <subdir+0x624>
    38a0:	d94d                	beqz	a0,3852 <sbrkfail+0x4c>
    if(pids[i] != -1)
    38a2:	ff4506e3          	beq	a0,s4,388e <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    38a6:	4605                	li	a2,1
    38a8:	faf40593          	addi	a1,s0,-81
    38ac:	fb042503          	lw	a0,-80(s0)
    38b0:	00001097          	auipc	ra,0x1
    38b4:	b8a080e7          	jalr	-1142(ra) # 443a <read>
    38b8:	bfd9                	j	388e <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    38ba:	6505                	lui	a0,0x1
    38bc:	00001097          	auipc	ra,0x1
    38c0:	bee080e7          	jalr	-1042(ra) # 44aa <sbrk>
    38c4:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    38c6:	597d                	li	s2,-1
    38c8:	a021                	j	38d0 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    38ca:	0491                	addi	s1,s1,4
    38cc:	01348f63          	beq	s1,s3,38ea <sbrkfail+0xe4>
    if(pids[i] == -1)
    38d0:	4088                	lw	a0,0(s1)
    38d2:	ff250ce3          	beq	a0,s2,38ca <sbrkfail+0xc4>
    kill(pids[i]);
    38d6:	00001097          	auipc	ra,0x1
    38da:	b7c080e7          	jalr	-1156(ra) # 4452 <kill>
    wait(0);
    38de:	4501                	li	a0,0
    38e0:	00001097          	auipc	ra,0x1
    38e4:	b4a080e7          	jalr	-1206(ra) # 442a <wait>
    38e8:	b7cd                	j	38ca <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    38ea:	57fd                	li	a5,-1
    38ec:	02fa0e63          	beq	s4,a5,3928 <sbrkfail+0x122>
  pid = fork();
    38f0:	00001097          	auipc	ra,0x1
    38f4:	b2a080e7          	jalr	-1238(ra) # 441a <fork>
    38f8:	84aa                	mv	s1,a0
  if(pid < 0){
    38fa:	04054563          	bltz	a0,3944 <sbrkfail+0x13e>
  if(pid == 0){
    38fe:	c12d                	beqz	a0,3960 <sbrkfail+0x15a>
  wait(&xstatus);
    3900:	fbc40513          	addi	a0,s0,-68
    3904:	00001097          	auipc	ra,0x1
    3908:	b26080e7          	jalr	-1242(ra) # 442a <wait>
  if(xstatus != -1)
    390c:	fbc42703          	lw	a4,-68(s0)
    3910:	57fd                	li	a5,-1
    3912:	08f71c63          	bne	a4,a5,39aa <sbrkfail+0x1a4>
}
    3916:	70e6                	ld	ra,120(sp)
    3918:	7446                	ld	s0,112(sp)
    391a:	74a6                	ld	s1,104(sp)
    391c:	7906                	ld	s2,96(sp)
    391e:	69e6                	ld	s3,88(sp)
    3920:	6a46                	ld	s4,80(sp)
    3922:	6aa6                	ld	s5,72(sp)
    3924:	6109                	addi	sp,sp,128
    3926:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3928:	85d6                	mv	a1,s5
    392a:	00003517          	auipc	a0,0x3
    392e:	b4e50513          	addi	a0,a0,-1202 # 6478 <malloc+0x1c18>
    3932:	00001097          	auipc	ra,0x1
    3936:	e70080e7          	jalr	-400(ra) # 47a2 <printf>
    exit(1);
    393a:	4505                	li	a0,1
    393c:	00001097          	auipc	ra,0x1
    3940:	ae6080e7          	jalr	-1306(ra) # 4422 <exit>
    printf("%s: fork failed\n", s);
    3944:	85d6                	mv	a1,s5
    3946:	00001517          	auipc	a0,0x1
    394a:	41a50513          	addi	a0,a0,1050 # 4d60 <malloc+0x500>
    394e:	00001097          	auipc	ra,0x1
    3952:	e54080e7          	jalr	-428(ra) # 47a2 <printf>
    exit(1);
    3956:	4505                	li	a0,1
    3958:	00001097          	auipc	ra,0x1
    395c:	aca080e7          	jalr	-1334(ra) # 4422 <exit>
    a = sbrk(0);
    3960:	4501                	li	a0,0
    3962:	00001097          	auipc	ra,0x1
    3966:	b48080e7          	jalr	-1208(ra) # 44aa <sbrk>
    396a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    396c:	3e800537          	lui	a0,0x3e800
    3970:	00001097          	auipc	ra,0x1
    3974:	b3a080e7          	jalr	-1222(ra) # 44aa <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3978:	87ca                	mv	a5,s2
    397a:	3e800737          	lui	a4,0x3e800
    397e:	993a                	add	s2,s2,a4
    3980:	6705                	lui	a4,0x1
      n += *(a+i);
    3982:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f3dc0>
    3986:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3988:	97ba                	add	a5,a5,a4
    398a:	ff279ce3          	bne	a5,s2,3982 <sbrkfail+0x17c>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    398e:	85a6                	mv	a1,s1
    3990:	00003517          	auipc	a0,0x3
    3994:	b0850513          	addi	a0,a0,-1272 # 6498 <malloc+0x1c38>
    3998:	00001097          	auipc	ra,0x1
    399c:	e0a080e7          	jalr	-502(ra) # 47a2 <printf>
    exit(1);
    39a0:	4505                	li	a0,1
    39a2:	00001097          	auipc	ra,0x1
    39a6:	a80080e7          	jalr	-1408(ra) # 4422 <exit>
    exit(1);
    39aa:	4505                	li	a0,1
    39ac:	00001097          	auipc	ra,0x1
    39b0:	a76080e7          	jalr	-1418(ra) # 4422 <exit>

00000000000039b4 <sbrkarg>:
{
    39b4:	7179                	addi	sp,sp,-48
    39b6:	f406                	sd	ra,40(sp)
    39b8:	f022                	sd	s0,32(sp)
    39ba:	ec26                	sd	s1,24(sp)
    39bc:	e84a                	sd	s2,16(sp)
    39be:	e44e                	sd	s3,8(sp)
    39c0:	1800                	addi	s0,sp,48
    39c2:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    39c4:	6505                	lui	a0,0x1
    39c6:	00001097          	auipc	ra,0x1
    39ca:	ae4080e7          	jalr	-1308(ra) # 44aa <sbrk>
    39ce:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    39d0:	20100593          	li	a1,513
    39d4:	00003517          	auipc	a0,0x3
    39d8:	af450513          	addi	a0,a0,-1292 # 64c8 <malloc+0x1c68>
    39dc:	00001097          	auipc	ra,0x1
    39e0:	a86080e7          	jalr	-1402(ra) # 4462 <open>
    39e4:	84aa                	mv	s1,a0
  unlink("sbrk");
    39e6:	00003517          	auipc	a0,0x3
    39ea:	ae250513          	addi	a0,a0,-1310 # 64c8 <malloc+0x1c68>
    39ee:	00001097          	auipc	ra,0x1
    39f2:	a84080e7          	jalr	-1404(ra) # 4472 <unlink>
  if(fd < 0)  {
    39f6:	0404c163          	bltz	s1,3a38 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    39fa:	6605                	lui	a2,0x1
    39fc:	85ca                	mv	a1,s2
    39fe:	8526                	mv	a0,s1
    3a00:	00001097          	auipc	ra,0x1
    3a04:	a42080e7          	jalr	-1470(ra) # 4442 <write>
    3a08:	04054663          	bltz	a0,3a54 <sbrkarg+0xa0>
  close(fd);
    3a0c:	8526                	mv	a0,s1
    3a0e:	00001097          	auipc	ra,0x1
    3a12:	a3c080e7          	jalr	-1476(ra) # 444a <close>
  a = sbrk(PGSIZE);
    3a16:	6505                	lui	a0,0x1
    3a18:	00001097          	auipc	ra,0x1
    3a1c:	a92080e7          	jalr	-1390(ra) # 44aa <sbrk>
  if(pipe((int *) a) != 0){
    3a20:	00001097          	auipc	ra,0x1
    3a24:	a12080e7          	jalr	-1518(ra) # 4432 <pipe>
    3a28:	e521                	bnez	a0,3a70 <sbrkarg+0xbc>
}
    3a2a:	70a2                	ld	ra,40(sp)
    3a2c:	7402                	ld	s0,32(sp)
    3a2e:	64e2                	ld	s1,24(sp)
    3a30:	6942                	ld	s2,16(sp)
    3a32:	69a2                	ld	s3,8(sp)
    3a34:	6145                	addi	sp,sp,48
    3a36:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    3a38:	85ce                	mv	a1,s3
    3a3a:	00003517          	auipc	a0,0x3
    3a3e:	a9650513          	addi	a0,a0,-1386 # 64d0 <malloc+0x1c70>
    3a42:	00001097          	auipc	ra,0x1
    3a46:	d60080e7          	jalr	-672(ra) # 47a2 <printf>
    exit(1);
    3a4a:	4505                	li	a0,1
    3a4c:	00001097          	auipc	ra,0x1
    3a50:	9d6080e7          	jalr	-1578(ra) # 4422 <exit>
    printf("%s: write sbrk failed\n", s);
    3a54:	85ce                	mv	a1,s3
    3a56:	00003517          	auipc	a0,0x3
    3a5a:	a9250513          	addi	a0,a0,-1390 # 64e8 <malloc+0x1c88>
    3a5e:	00001097          	auipc	ra,0x1
    3a62:	d44080e7          	jalr	-700(ra) # 47a2 <printf>
    exit(1);
    3a66:	4505                	li	a0,1
    3a68:	00001097          	auipc	ra,0x1
    3a6c:	9ba080e7          	jalr	-1606(ra) # 4422 <exit>
    printf("%s: pipe() failed\n", s);
    3a70:	85ce                	mv	a1,s3
    3a72:	00002517          	auipc	a0,0x2
    3a76:	c1e50513          	addi	a0,a0,-994 # 5690 <malloc+0xe30>
    3a7a:	00001097          	auipc	ra,0x1
    3a7e:	d28080e7          	jalr	-728(ra) # 47a2 <printf>
    exit(1);
    3a82:	4505                	li	a0,1
    3a84:	00001097          	auipc	ra,0x1
    3a88:	99e080e7          	jalr	-1634(ra) # 4422 <exit>

0000000000003a8c <argptest>:
{
    3a8c:	1101                	addi	sp,sp,-32
    3a8e:	ec06                	sd	ra,24(sp)
    3a90:	e822                	sd	s0,16(sp)
    3a92:	e426                	sd	s1,8(sp)
    3a94:	e04a                	sd	s2,0(sp)
    3a96:	1000                	addi	s0,sp,32
    3a98:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3a9a:	4581                	li	a1,0
    3a9c:	00003517          	auipc	a0,0x3
    3aa0:	a6450513          	addi	a0,a0,-1436 # 6500 <malloc+0x1ca0>
    3aa4:	00001097          	auipc	ra,0x1
    3aa8:	9be080e7          	jalr	-1602(ra) # 4462 <open>
  if (fd < 0) {
    3aac:	02054b63          	bltz	a0,3ae2 <argptest+0x56>
    3ab0:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3ab2:	4501                	li	a0,0
    3ab4:	00001097          	auipc	ra,0x1
    3ab8:	9f6080e7          	jalr	-1546(ra) # 44aa <sbrk>
    3abc:	567d                	li	a2,-1
    3abe:	fff50593          	addi	a1,a0,-1
    3ac2:	8526                	mv	a0,s1
    3ac4:	00001097          	auipc	ra,0x1
    3ac8:	976080e7          	jalr	-1674(ra) # 443a <read>
  close(fd);
    3acc:	8526                	mv	a0,s1
    3ace:	00001097          	auipc	ra,0x1
    3ad2:	97c080e7          	jalr	-1668(ra) # 444a <close>
}
    3ad6:	60e2                	ld	ra,24(sp)
    3ad8:	6442                	ld	s0,16(sp)
    3ada:	64a2                	ld	s1,8(sp)
    3adc:	6902                	ld	s2,0(sp)
    3ade:	6105                	addi	sp,sp,32
    3ae0:	8082                	ret
    printf("%s: open failed\n", s);
    3ae2:	85ca                	mv	a1,s2
    3ae4:	00002517          	auipc	a0,0x2
    3ae8:	a4c50513          	addi	a0,a0,-1460 # 5530 <malloc+0xcd0>
    3aec:	00001097          	auipc	ra,0x1
    3af0:	cb6080e7          	jalr	-842(ra) # 47a2 <printf>
    exit(1);
    3af4:	4505                	li	a0,1
    3af6:	00001097          	auipc	ra,0x1
    3afa:	92c080e7          	jalr	-1748(ra) # 4422 <exit>

0000000000003afe <sbrkbugs>:
{
    3afe:	1141                	addi	sp,sp,-16
    3b00:	e406                	sd	ra,8(sp)
    3b02:	e022                	sd	s0,0(sp)
    3b04:	0800                	addi	s0,sp,16
  int pid = fork();
    3b06:	00001097          	auipc	ra,0x1
    3b0a:	914080e7          	jalr	-1772(ra) # 441a <fork>
  if(pid < 0){
    3b0e:	02054263          	bltz	a0,3b32 <sbrkbugs+0x34>
  if(pid == 0){
    3b12:	ed0d                	bnez	a0,3b4c <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    3b14:	00001097          	auipc	ra,0x1
    3b18:	996080e7          	jalr	-1642(ra) # 44aa <sbrk>
    sbrk(-sz);
    3b1c:	40a0053b          	negw	a0,a0
    3b20:	00001097          	auipc	ra,0x1
    3b24:	98a080e7          	jalr	-1654(ra) # 44aa <sbrk>
    exit(0);
    3b28:	4501                	li	a0,0
    3b2a:	00001097          	auipc	ra,0x1
    3b2e:	8f8080e7          	jalr	-1800(ra) # 4422 <exit>
    printf("fork failed\n");
    3b32:	00002517          	auipc	a0,0x2
    3b36:	b2e50513          	addi	a0,a0,-1234 # 5660 <malloc+0xe00>
    3b3a:	00001097          	auipc	ra,0x1
    3b3e:	c68080e7          	jalr	-920(ra) # 47a2 <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00001097          	auipc	ra,0x1
    3b48:	8de080e7          	jalr	-1826(ra) # 4422 <exit>
  wait(0);
    3b4c:	4501                	li	a0,0
    3b4e:	00001097          	auipc	ra,0x1
    3b52:	8dc080e7          	jalr	-1828(ra) # 442a <wait>
  pid = fork();
    3b56:	00001097          	auipc	ra,0x1
    3b5a:	8c4080e7          	jalr	-1852(ra) # 441a <fork>
  if(pid < 0){
    3b5e:	02054563          	bltz	a0,3b88 <sbrkbugs+0x8a>
  if(pid == 0){
    3b62:	e121                	bnez	a0,3ba2 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    3b64:	00001097          	auipc	ra,0x1
    3b68:	946080e7          	jalr	-1722(ra) # 44aa <sbrk>
    sbrk(-(sz - 3500));
    3b6c:	6785                	lui	a5,0x1
    3b6e:	dac7879b          	addiw	a5,a5,-596
    3b72:	40a7853b          	subw	a0,a5,a0
    3b76:	00001097          	auipc	ra,0x1
    3b7a:	934080e7          	jalr	-1740(ra) # 44aa <sbrk>
    exit(0);
    3b7e:	4501                	li	a0,0
    3b80:	00001097          	auipc	ra,0x1
    3b84:	8a2080e7          	jalr	-1886(ra) # 4422 <exit>
    printf("fork failed\n");
    3b88:	00002517          	auipc	a0,0x2
    3b8c:	ad850513          	addi	a0,a0,-1320 # 5660 <malloc+0xe00>
    3b90:	00001097          	auipc	ra,0x1
    3b94:	c12080e7          	jalr	-1006(ra) # 47a2 <printf>
    exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	00001097          	auipc	ra,0x1
    3b9e:	888080e7          	jalr	-1912(ra) # 4422 <exit>
  wait(0);
    3ba2:	4501                	li	a0,0
    3ba4:	00001097          	auipc	ra,0x1
    3ba8:	886080e7          	jalr	-1914(ra) # 442a <wait>
  pid = fork();
    3bac:	00001097          	auipc	ra,0x1
    3bb0:	86e080e7          	jalr	-1938(ra) # 441a <fork>
  if(pid < 0){
    3bb4:	02054a63          	bltz	a0,3be8 <sbrkbugs+0xea>
  if(pid == 0){
    3bb8:	e529                	bnez	a0,3c02 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    3bba:	00001097          	auipc	ra,0x1
    3bbe:	8f0080e7          	jalr	-1808(ra) # 44aa <sbrk>
    3bc2:	67ad                	lui	a5,0xb
    3bc4:	8007879b          	addiw	a5,a5,-2048
    3bc8:	40a7853b          	subw	a0,a5,a0
    3bcc:	00001097          	auipc	ra,0x1
    3bd0:	8de080e7          	jalr	-1826(ra) # 44aa <sbrk>
    sbrk(-10);
    3bd4:	5559                	li	a0,-10
    3bd6:	00001097          	auipc	ra,0x1
    3bda:	8d4080e7          	jalr	-1836(ra) # 44aa <sbrk>
    exit(0);
    3bde:	4501                	li	a0,0
    3be0:	00001097          	auipc	ra,0x1
    3be4:	842080e7          	jalr	-1982(ra) # 4422 <exit>
    printf("fork failed\n");
    3be8:	00002517          	auipc	a0,0x2
    3bec:	a7850513          	addi	a0,a0,-1416 # 5660 <malloc+0xe00>
    3bf0:	00001097          	auipc	ra,0x1
    3bf4:	bb2080e7          	jalr	-1102(ra) # 47a2 <printf>
    exit(1);
    3bf8:	4505                	li	a0,1
    3bfa:	00001097          	auipc	ra,0x1
    3bfe:	828080e7          	jalr	-2008(ra) # 4422 <exit>
  wait(0);
    3c02:	4501                	li	a0,0
    3c04:	00001097          	auipc	ra,0x1
    3c08:	826080e7          	jalr	-2010(ra) # 442a <wait>
  exit(0);
    3c0c:	4501                	li	a0,0
    3c0e:	00001097          	auipc	ra,0x1
    3c12:	814080e7          	jalr	-2028(ra) # 4422 <exit>

0000000000003c16 <dirtest>:
{
    3c16:	1101                	addi	sp,sp,-32
    3c18:	ec06                	sd	ra,24(sp)
    3c1a:	e822                	sd	s0,16(sp)
    3c1c:	e426                	sd	s1,8(sp)
    3c1e:	1000                	addi	s0,sp,32
    3c20:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    3c22:	00003517          	auipc	a0,0x3
    3c26:	8e650513          	addi	a0,a0,-1818 # 6508 <malloc+0x1ca8>
    3c2a:	00001097          	auipc	ra,0x1
    3c2e:	b78080e7          	jalr	-1160(ra) # 47a2 <printf>
  if(mkdir("dir0") < 0){
    3c32:	00003517          	auipc	a0,0x3
    3c36:	8e650513          	addi	a0,a0,-1818 # 6518 <malloc+0x1cb8>
    3c3a:	00001097          	auipc	ra,0x1
    3c3e:	850080e7          	jalr	-1968(ra) # 448a <mkdir>
    3c42:	04054d63          	bltz	a0,3c9c <dirtest+0x86>
  if(chdir("dir0") < 0){
    3c46:	00003517          	auipc	a0,0x3
    3c4a:	8d250513          	addi	a0,a0,-1838 # 6518 <malloc+0x1cb8>
    3c4e:	00001097          	auipc	ra,0x1
    3c52:	844080e7          	jalr	-1980(ra) # 4492 <chdir>
    3c56:	06054163          	bltz	a0,3cb8 <dirtest+0xa2>
  if(chdir("..") < 0){
    3c5a:	00001517          	auipc	a0,0x1
    3c5e:	07650513          	addi	a0,a0,118 # 4cd0 <malloc+0x470>
    3c62:	00001097          	auipc	ra,0x1
    3c66:	830080e7          	jalr	-2000(ra) # 4492 <chdir>
    3c6a:	06054563          	bltz	a0,3cd4 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    3c6e:	00003517          	auipc	a0,0x3
    3c72:	8aa50513          	addi	a0,a0,-1878 # 6518 <malloc+0x1cb8>
    3c76:	00000097          	auipc	ra,0x0
    3c7a:	7fc080e7          	jalr	2044(ra) # 4472 <unlink>
    3c7e:	06054963          	bltz	a0,3cf0 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    3c82:	00003517          	auipc	a0,0x3
    3c86:	8e650513          	addi	a0,a0,-1818 # 6568 <malloc+0x1d08>
    3c8a:	00001097          	auipc	ra,0x1
    3c8e:	b18080e7          	jalr	-1256(ra) # 47a2 <printf>
}
    3c92:	60e2                	ld	ra,24(sp)
    3c94:	6442                	ld	s0,16(sp)
    3c96:	64a2                	ld	s1,8(sp)
    3c98:	6105                	addi	sp,sp,32
    3c9a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3c9c:	85a6                	mv	a1,s1
    3c9e:	00001517          	auipc	a0,0x1
    3ca2:	f5250513          	addi	a0,a0,-174 # 4bf0 <malloc+0x390>
    3ca6:	00001097          	auipc	ra,0x1
    3caa:	afc080e7          	jalr	-1284(ra) # 47a2 <printf>
    exit(1);
    3cae:	4505                	li	a0,1
    3cb0:	00000097          	auipc	ra,0x0
    3cb4:	772080e7          	jalr	1906(ra) # 4422 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3cb8:	85a6                	mv	a1,s1
    3cba:	00003517          	auipc	a0,0x3
    3cbe:	86650513          	addi	a0,a0,-1946 # 6520 <malloc+0x1cc0>
    3cc2:	00001097          	auipc	ra,0x1
    3cc6:	ae0080e7          	jalr	-1312(ra) # 47a2 <printf>
    exit(1);
    3cca:	4505                	li	a0,1
    3ccc:	00000097          	auipc	ra,0x0
    3cd0:	756080e7          	jalr	1878(ra) # 4422 <exit>
    printf("%s: chdir .. failed\n", s);
    3cd4:	85a6                	mv	a1,s1
    3cd6:	00003517          	auipc	a0,0x3
    3cda:	86250513          	addi	a0,a0,-1950 # 6538 <malloc+0x1cd8>
    3cde:	00001097          	auipc	ra,0x1
    3ce2:	ac4080e7          	jalr	-1340(ra) # 47a2 <printf>
    exit(1);
    3ce6:	4505                	li	a0,1
    3ce8:	00000097          	auipc	ra,0x0
    3cec:	73a080e7          	jalr	1850(ra) # 4422 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3cf0:	85a6                	mv	a1,s1
    3cf2:	00003517          	auipc	a0,0x3
    3cf6:	85e50513          	addi	a0,a0,-1954 # 6550 <malloc+0x1cf0>
    3cfa:	00001097          	auipc	ra,0x1
    3cfe:	aa8080e7          	jalr	-1368(ra) # 47a2 <printf>
    exit(1);
    3d02:	4505                	li	a0,1
    3d04:	00000097          	auipc	ra,0x0
    3d08:	71e080e7          	jalr	1822(ra) # 4422 <exit>

0000000000003d0c <fsfull>:
{
    3d0c:	7171                	addi	sp,sp,-176
    3d0e:	f506                	sd	ra,168(sp)
    3d10:	f122                	sd	s0,160(sp)
    3d12:	ed26                	sd	s1,152(sp)
    3d14:	e94a                	sd	s2,144(sp)
    3d16:	e54e                	sd	s3,136(sp)
    3d18:	e152                	sd	s4,128(sp)
    3d1a:	fcd6                	sd	s5,120(sp)
    3d1c:	f8da                	sd	s6,112(sp)
    3d1e:	f4de                	sd	s7,104(sp)
    3d20:	f0e2                	sd	s8,96(sp)
    3d22:	ece6                	sd	s9,88(sp)
    3d24:	e8ea                	sd	s10,80(sp)
    3d26:	e4ee                	sd	s11,72(sp)
    3d28:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    3d2a:	00003517          	auipc	a0,0x3
    3d2e:	85650513          	addi	a0,a0,-1962 # 6580 <malloc+0x1d20>
    3d32:	00001097          	auipc	ra,0x1
    3d36:	a70080e7          	jalr	-1424(ra) # 47a2 <printf>
  for(nfiles = 0; ; nfiles++){
    3d3a:	4481                	li	s1,0
    name[0] = 'f';
    3d3c:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    3d40:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3d44:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    3d48:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    3d4a:	00003c97          	auipc	s9,0x3
    3d4e:	846c8c93          	addi	s9,s9,-1978 # 6590 <malloc+0x1d30>
    int total = 0;
    3d52:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    3d54:	00005a17          	auipc	s4,0x5
    3d58:	4dca0a13          	addi	s4,s4,1244 # 9230 <buf>
    name[0] = 'f';
    3d5c:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3d60:	0384c7bb          	divw	a5,s1,s8
    3d64:	0307879b          	addiw	a5,a5,48
    3d68:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3d6c:	0384e7bb          	remw	a5,s1,s8
    3d70:	0377c7bb          	divw	a5,a5,s7
    3d74:	0307879b          	addiw	a5,a5,48
    3d78:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3d7c:	0374e7bb          	remw	a5,s1,s7
    3d80:	0367c7bb          	divw	a5,a5,s6
    3d84:	0307879b          	addiw	a5,a5,48
    3d88:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3d8c:	0364e7bb          	remw	a5,s1,s6
    3d90:	0307879b          	addiw	a5,a5,48
    3d94:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3d98:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    3d9c:	f5040593          	addi	a1,s0,-176
    3da0:	8566                	mv	a0,s9
    3da2:	00001097          	auipc	ra,0x1
    3da6:	a00080e7          	jalr	-1536(ra) # 47a2 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3daa:	20200593          	li	a1,514
    3dae:	f5040513          	addi	a0,s0,-176
    3db2:	00000097          	auipc	ra,0x0
    3db6:	6b0080e7          	jalr	1712(ra) # 4462 <open>
    3dba:	892a                	mv	s2,a0
    if(fd < 0){
    3dbc:	0a055663          	bgez	a0,3e68 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    3dc0:	f5040593          	addi	a1,s0,-176
    3dc4:	00002517          	auipc	a0,0x2
    3dc8:	7dc50513          	addi	a0,a0,2012 # 65a0 <malloc+0x1d40>
    3dcc:	00001097          	auipc	ra,0x1
    3dd0:	9d6080e7          	jalr	-1578(ra) # 47a2 <printf>
  while(nfiles >= 0){
    3dd4:	0604c363          	bltz	s1,3e3a <fsfull+0x12e>
    name[0] = 'f';
    3dd8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    3ddc:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3de0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3de4:	4929                	li	s2,10
  while(nfiles >= 0){
    3de6:	5afd                	li	s5,-1
    name[0] = 'f';
    3de8:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3dec:	0344c7bb          	divw	a5,s1,s4
    3df0:	0307879b          	addiw	a5,a5,48
    3df4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3df8:	0344e7bb          	remw	a5,s1,s4
    3dfc:	0337c7bb          	divw	a5,a5,s3
    3e00:	0307879b          	addiw	a5,a5,48
    3e04:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3e08:	0334e7bb          	remw	a5,s1,s3
    3e0c:	0327c7bb          	divw	a5,a5,s2
    3e10:	0307879b          	addiw	a5,a5,48
    3e14:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3e18:	0324e7bb          	remw	a5,s1,s2
    3e1c:	0307879b          	addiw	a5,a5,48
    3e20:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3e24:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    3e28:	f5040513          	addi	a0,s0,-176
    3e2c:	00000097          	auipc	ra,0x0
    3e30:	646080e7          	jalr	1606(ra) # 4472 <unlink>
    nfiles--;
    3e34:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    3e36:	fb5499e3          	bne	s1,s5,3de8 <fsfull+0xdc>
  printf("fsfull test finished\n");
    3e3a:	00002517          	auipc	a0,0x2
    3e3e:	79650513          	addi	a0,a0,1942 # 65d0 <malloc+0x1d70>
    3e42:	00001097          	auipc	ra,0x1
    3e46:	960080e7          	jalr	-1696(ra) # 47a2 <printf>
}
    3e4a:	70aa                	ld	ra,168(sp)
    3e4c:	740a                	ld	s0,160(sp)
    3e4e:	64ea                	ld	s1,152(sp)
    3e50:	694a                	ld	s2,144(sp)
    3e52:	69aa                	ld	s3,136(sp)
    3e54:	6a0a                	ld	s4,128(sp)
    3e56:	7ae6                	ld	s5,120(sp)
    3e58:	7b46                	ld	s6,112(sp)
    3e5a:	7ba6                	ld	s7,104(sp)
    3e5c:	7c06                	ld	s8,96(sp)
    3e5e:	6ce6                	ld	s9,88(sp)
    3e60:	6d46                	ld	s10,80(sp)
    3e62:	6da6                	ld	s11,72(sp)
    3e64:	614d                	addi	sp,sp,176
    3e66:	8082                	ret
    int total = 0;
    3e68:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3e6a:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3e6e:	40000613          	li	a2,1024
    3e72:	85d2                	mv	a1,s4
    3e74:	854a                	mv	a0,s2
    3e76:	00000097          	auipc	ra,0x0
    3e7a:	5cc080e7          	jalr	1484(ra) # 4442 <write>
      if(cc < BSIZE)
    3e7e:	00aad563          	bge	s5,a0,3e88 <fsfull+0x17c>
      total += cc;
    3e82:	00a989bb          	addw	s3,s3,a0
    while(1){
    3e86:	b7e5                	j	3e6e <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    3e88:	85ce                	mv	a1,s3
    3e8a:	00002517          	auipc	a0,0x2
    3e8e:	72e50513          	addi	a0,a0,1838 # 65b8 <malloc+0x1d58>
    3e92:	00001097          	auipc	ra,0x1
    3e96:	910080e7          	jalr	-1776(ra) # 47a2 <printf>
    close(fd);
    3e9a:	854a                	mv	a0,s2
    3e9c:	00000097          	auipc	ra,0x0
    3ea0:	5ae080e7          	jalr	1454(ra) # 444a <close>
    if(total == 0)
    3ea4:	f20988e3          	beqz	s3,3dd4 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3ea8:	2485                	addiw	s1,s1,1
    3eaa:	bd4d                	j	3d5c <fsfull+0x50>

0000000000003eac <rand>:
{
    3eac:	1141                	addi	sp,sp,-16
    3eae:	e422                	sd	s0,8(sp)
    3eb0:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3eb2:	00003717          	auipc	a4,0x3
    3eb6:	b5670713          	addi	a4,a4,-1194 # 6a08 <randstate>
    3eba:	6308                	ld	a0,0(a4)
    3ebc:	001967b7          	lui	a5,0x196
    3ec0:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18a3cd>
    3ec4:	02f50533          	mul	a0,a0,a5
    3ec8:	3c6ef7b7          	lui	a5,0x3c6ef
    3ecc:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e311f>
    3ed0:	953e                	add	a0,a0,a5
    3ed2:	e308                	sd	a0,0(a4)
}
    3ed4:	2501                	sext.w	a0,a0
    3ed6:	6422                	ld	s0,8(sp)
    3ed8:	0141                	addi	sp,sp,16
    3eda:	8082                	ret

0000000000003edc <badwrite>:
{
    3edc:	7179                	addi	sp,sp,-48
    3ede:	f406                	sd	ra,40(sp)
    3ee0:	f022                	sd	s0,32(sp)
    3ee2:	ec26                	sd	s1,24(sp)
    3ee4:	e84a                	sd	s2,16(sp)
    3ee6:	e44e                	sd	s3,8(sp)
    3ee8:	e052                	sd	s4,0(sp)
    3eea:	1800                	addi	s0,sp,48
  unlink("junk");
    3eec:	00002517          	auipc	a0,0x2
    3ef0:	6fc50513          	addi	a0,a0,1788 # 65e8 <malloc+0x1d88>
    3ef4:	00000097          	auipc	ra,0x0
    3ef8:	57e080e7          	jalr	1406(ra) # 4472 <unlink>
    3efc:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f00:	00002997          	auipc	s3,0x2
    3f04:	6e898993          	addi	s3,s3,1768 # 65e8 <malloc+0x1d88>
    write(fd, (char*)0xffffffffffL, 1);
    3f08:	5a7d                	li	s4,-1
    3f0a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f0e:	20100593          	li	a1,513
    3f12:	854e                	mv	a0,s3
    3f14:	00000097          	auipc	ra,0x0
    3f18:	54e080e7          	jalr	1358(ra) # 4462 <open>
    3f1c:	84aa                	mv	s1,a0
    if(fd < 0){
    3f1e:	06054b63          	bltz	a0,3f94 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    3f22:	4605                	li	a2,1
    3f24:	85d2                	mv	a1,s4
    3f26:	00000097          	auipc	ra,0x0
    3f2a:	51c080e7          	jalr	1308(ra) # 4442 <write>
    close(fd);
    3f2e:	8526                	mv	a0,s1
    3f30:	00000097          	auipc	ra,0x0
    3f34:	51a080e7          	jalr	1306(ra) # 444a <close>
    unlink("junk");
    3f38:	854e                	mv	a0,s3
    3f3a:	00000097          	auipc	ra,0x0
    3f3e:	538080e7          	jalr	1336(ra) # 4472 <unlink>
  for(int i = 0; i < assumed_free; i++){
    3f42:	397d                	addiw	s2,s2,-1
    3f44:	fc0915e3          	bnez	s2,3f0e <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    3f48:	20100593          	li	a1,513
    3f4c:	00002517          	auipc	a0,0x2
    3f50:	69c50513          	addi	a0,a0,1692 # 65e8 <malloc+0x1d88>
    3f54:	00000097          	auipc	ra,0x0
    3f58:	50e080e7          	jalr	1294(ra) # 4462 <open>
    3f5c:	84aa                	mv	s1,a0
  if(fd < 0){
    3f5e:	04054863          	bltz	a0,3fae <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    3f62:	4605                	li	a2,1
    3f64:	00001597          	auipc	a1,0x1
    3f68:	7ac58593          	addi	a1,a1,1964 # 5710 <malloc+0xeb0>
    3f6c:	00000097          	auipc	ra,0x0
    3f70:	4d6080e7          	jalr	1238(ra) # 4442 <write>
    3f74:	4785                	li	a5,1
    3f76:	04f50963          	beq	a0,a5,3fc8 <badwrite+0xec>
    printf("write failed\n");
    3f7a:	00002517          	auipc	a0,0x2
    3f7e:	68e50513          	addi	a0,a0,1678 # 6608 <malloc+0x1da8>
    3f82:	00001097          	auipc	ra,0x1
    3f86:	820080e7          	jalr	-2016(ra) # 47a2 <printf>
    exit(1);
    3f8a:	4505                	li	a0,1
    3f8c:	00000097          	auipc	ra,0x0
    3f90:	496080e7          	jalr	1174(ra) # 4422 <exit>
      printf("open junk failed\n");
    3f94:	00002517          	auipc	a0,0x2
    3f98:	65c50513          	addi	a0,a0,1628 # 65f0 <malloc+0x1d90>
    3f9c:	00001097          	auipc	ra,0x1
    3fa0:	806080e7          	jalr	-2042(ra) # 47a2 <printf>
      exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00000097          	auipc	ra,0x0
    3faa:	47c080e7          	jalr	1148(ra) # 4422 <exit>
    printf("open junk failed\n");
    3fae:	00002517          	auipc	a0,0x2
    3fb2:	64250513          	addi	a0,a0,1602 # 65f0 <malloc+0x1d90>
    3fb6:	00000097          	auipc	ra,0x0
    3fba:	7ec080e7          	jalr	2028(ra) # 47a2 <printf>
    exit(1);
    3fbe:	4505                	li	a0,1
    3fc0:	00000097          	auipc	ra,0x0
    3fc4:	462080e7          	jalr	1122(ra) # 4422 <exit>
  close(fd);
    3fc8:	8526                	mv	a0,s1
    3fca:	00000097          	auipc	ra,0x0
    3fce:	480080e7          	jalr	1152(ra) # 444a <close>
  unlink("junk");
    3fd2:	00002517          	auipc	a0,0x2
    3fd6:	61650513          	addi	a0,a0,1558 # 65e8 <malloc+0x1d88>
    3fda:	00000097          	auipc	ra,0x0
    3fde:	498080e7          	jalr	1176(ra) # 4472 <unlink>
  exit(0);
    3fe2:	4501                	li	a0,0
    3fe4:	00000097          	auipc	ra,0x0
    3fe8:	43e080e7          	jalr	1086(ra) # 4422 <exit>

0000000000003fec <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    3fec:	7179                	addi	sp,sp,-48
    3fee:	f406                	sd	ra,40(sp)
    3ff0:	f022                	sd	s0,32(sp)
    3ff2:	ec26                	sd	s1,24(sp)
    3ff4:	e84a                	sd	s2,16(sp)
    3ff6:	1800                	addi	s0,sp,48
    3ff8:	892a                	mv	s2,a0
    3ffa:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("test %s: ", s);
    3ffc:	00002517          	auipc	a0,0x2
    4000:	61c50513          	addi	a0,a0,1564 # 6618 <malloc+0x1db8>
    4004:	00000097          	auipc	ra,0x0
    4008:	79e080e7          	jalr	1950(ra) # 47a2 <printf>
  if((pid = fork()) < 0) {
    400c:	00000097          	auipc	ra,0x0
    4010:	40e080e7          	jalr	1038(ra) # 441a <fork>
    4014:	02054f63          	bltz	a0,4052 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4018:	c931                	beqz	a0,406c <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    401a:	fdc40513          	addi	a0,s0,-36
    401e:	00000097          	auipc	ra,0x0
    4022:	40c080e7          	jalr	1036(ra) # 442a <wait>
    if(xstatus != 0) 
    4026:	fdc42783          	lw	a5,-36(s0)
    402a:	cba1                	beqz	a5,407a <run+0x8e>
      printf("FAILED\n", s);
    402c:	85a6                	mv	a1,s1
    402e:	00002517          	auipc	a0,0x2
    4032:	61250513          	addi	a0,a0,1554 # 6640 <malloc+0x1de0>
    4036:	00000097          	auipc	ra,0x0
    403a:	76c080e7          	jalr	1900(ra) # 47a2 <printf>
    else
      printf("OK\n", s);
    return xstatus == 0;
    403e:	fdc42503          	lw	a0,-36(s0)
  }
}
    4042:	00153513          	seqz	a0,a0
    4046:	70a2                	ld	ra,40(sp)
    4048:	7402                	ld	s0,32(sp)
    404a:	64e2                	ld	s1,24(sp)
    404c:	6942                	ld	s2,16(sp)
    404e:	6145                	addi	sp,sp,48
    4050:	8082                	ret
    printf("runtest: fork error\n");
    4052:	00002517          	auipc	a0,0x2
    4056:	5d650513          	addi	a0,a0,1494 # 6628 <malloc+0x1dc8>
    405a:	00000097          	auipc	ra,0x0
    405e:	748080e7          	jalr	1864(ra) # 47a2 <printf>
    exit(1);
    4062:	4505                	li	a0,1
    4064:	00000097          	auipc	ra,0x0
    4068:	3be080e7          	jalr	958(ra) # 4422 <exit>
    f(s);
    406c:	8526                	mv	a0,s1
    406e:	9902                	jalr	s2
    exit(0);
    4070:	4501                	li	a0,0
    4072:	00000097          	auipc	ra,0x0
    4076:	3b0080e7          	jalr	944(ra) # 4422 <exit>
      printf("OK\n", s);
    407a:	85a6                	mv	a1,s1
    407c:	00002517          	auipc	a0,0x2
    4080:	5cc50513          	addi	a0,a0,1484 # 6648 <malloc+0x1de8>
    4084:	00000097          	auipc	ra,0x0
    4088:	71e080e7          	jalr	1822(ra) # 47a2 <printf>
    408c:	bf4d                	j	403e <run+0x52>

000000000000408e <main>:

int
main(int argc, char *argv[])
{
    408e:	ce010113          	addi	sp,sp,-800
    4092:	30113c23          	sd	ra,792(sp)
    4096:	30813823          	sd	s0,784(sp)
    409a:	30913423          	sd	s1,776(sp)
    409e:	31213023          	sd	s2,768(sp)
    40a2:	2f313c23          	sd	s3,760(sp)
    40a6:	2f413823          	sd	s4,752(sp)
    40aa:	1600                	addi	s0,sp,800
  char *n = 0;
  if(argc > 1) {
    40ac:	4785                	li	a5,1
  char *n = 0;
    40ae:	4901                	li	s2,0
  if(argc > 1) {
    40b0:	00a7d463          	bge	a5,a0,40b8 <main+0x2a>
    n = argv[1];
    40b4:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    40b8:	00002797          	auipc	a5,0x2
    40bc:	63878793          	addi	a5,a5,1592 # 66f0 <malloc+0x1e90>
    40c0:	ce040713          	addi	a4,s0,-800
    40c4:	00003817          	auipc	a6,0x3
    40c8:	90c80813          	addi	a6,a6,-1780 # 69d0 <malloc+0x2170>
    40cc:	6388                	ld	a0,0(a5)
    40ce:	678c                	ld	a1,8(a5)
    40d0:	6b90                	ld	a2,16(a5)
    40d2:	6f94                	ld	a3,24(a5)
    40d4:	e308                	sd	a0,0(a4)
    40d6:	e70c                	sd	a1,8(a4)
    40d8:	eb10                	sd	a2,16(a4)
    40da:	ef14                	sd	a3,24(a4)
    40dc:	02078793          	addi	a5,a5,32
    40e0:	02070713          	addi	a4,a4,32
    40e4:	ff0794e3          	bne	a5,a6,40cc <main+0x3e>
    40e8:	6394                	ld	a3,0(a5)
    40ea:	679c                	ld	a5,8(a5)
    40ec:	e314                	sd	a3,0(a4)
    40ee:	e71c                	sd	a5,8(a4)
    {forktest, "forktest"},
    {bigdir, "bigdir"}, // slow
    { 0, 0},
  };
    
  printf("usertests starting\n");
    40f0:	00002517          	auipc	a0,0x2
    40f4:	56050513          	addi	a0,a0,1376 # 6650 <malloc+0x1df0>
    40f8:	00000097          	auipc	ra,0x0
    40fc:	6aa080e7          	jalr	1706(ra) # 47a2 <printf>

  if(open("usertests.ran", 0) >= 0){
    4100:	4581                	li	a1,0
    4102:	00002517          	auipc	a0,0x2
    4106:	56650513          	addi	a0,a0,1382 # 6668 <malloc+0x1e08>
    410a:	00000097          	auipc	ra,0x0
    410e:	358080e7          	jalr	856(ra) # 4462 <open>
    4112:	00054f63          	bltz	a0,4130 <main+0xa2>
    printf("already ran user tests -- rebuild fs.img (rm fs.img; make fs.img)\n");
    4116:	00002517          	auipc	a0,0x2
    411a:	56250513          	addi	a0,a0,1378 # 6678 <malloc+0x1e18>
    411e:	00000097          	auipc	ra,0x0
    4122:	684080e7          	jalr	1668(ra) # 47a2 <printf>
    exit(1);
    4126:	4505                	li	a0,1
    4128:	00000097          	auipc	ra,0x0
    412c:	2fa080e7          	jalr	762(ra) # 4422 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    4130:	20000593          	li	a1,512
    4134:	00002517          	auipc	a0,0x2
    4138:	53450513          	addi	a0,a0,1332 # 6668 <malloc+0x1e08>
    413c:	00000097          	auipc	ra,0x0
    4140:	326080e7          	jalr	806(ra) # 4462 <open>
    4144:	00000097          	auipc	ra,0x0
    4148:	306080e7          	jalr	774(ra) # 444a <close>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    414c:	ce843503          	ld	a0,-792(s0)
    4150:	c529                	beqz	a0,419a <main+0x10c>
    4152:	ce040493          	addi	s1,s0,-800
  int fail = 0;
    4156:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4158:	4a05                	li	s4,1
    415a:	a021                	j	4162 <main+0xd4>
  for (struct test *t = tests; t->s != 0; t++) {
    415c:	04c1                	addi	s1,s1,16
    415e:	6488                	ld	a0,8(s1)
    4160:	c115                	beqz	a0,4184 <main+0xf6>
    if((n == 0) || strcmp(t->s, n) == 0) {
    4162:	00090863          	beqz	s2,4172 <main+0xe4>
    4166:	85ca                	mv	a1,s2
    4168:	00000097          	auipc	ra,0x0
    416c:	068080e7          	jalr	104(ra) # 41d0 <strcmp>
    4170:	f575                	bnez	a0,415c <main+0xce>
      if(!run(t->f, t->s))
    4172:	648c                	ld	a1,8(s1)
    4174:	6088                	ld	a0,0(s1)
    4176:	00000097          	auipc	ra,0x0
    417a:	e76080e7          	jalr	-394(ra) # 3fec <run>
    417e:	fd79                	bnez	a0,415c <main+0xce>
        fail = 1;
    4180:	89d2                	mv	s3,s4
    4182:	bfe9                	j	415c <main+0xce>
    }
  }
  if(!fail)
    4184:	00098b63          	beqz	s3,419a <main+0x10c>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
    4188:	00002517          	auipc	a0,0x2
    418c:	55050513          	addi	a0,a0,1360 # 66d8 <malloc+0x1e78>
    4190:	00000097          	auipc	ra,0x0
    4194:	612080e7          	jalr	1554(ra) # 47a2 <printf>
    4198:	a809                	j	41aa <main+0x11c>
    printf("ALL TESTS PASSED\n");
    419a:	00002517          	auipc	a0,0x2
    419e:	52650513          	addi	a0,a0,1318 # 66c0 <malloc+0x1e60>
    41a2:	00000097          	auipc	ra,0x0
    41a6:	600080e7          	jalr	1536(ra) # 47a2 <printf>
  exit(1);   // not reached.
    41aa:	4505                	li	a0,1
    41ac:	00000097          	auipc	ra,0x0
    41b0:	276080e7          	jalr	630(ra) # 4422 <exit>

00000000000041b4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    41b4:	1141                	addi	sp,sp,-16
    41b6:	e422                	sd	s0,8(sp)
    41b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    41ba:	87aa                	mv	a5,a0
    41bc:	0585                	addi	a1,a1,1
    41be:	0785                	addi	a5,a5,1
    41c0:	fff5c703          	lbu	a4,-1(a1)
    41c4:	fee78fa3          	sb	a4,-1(a5)
    41c8:	fb75                	bnez	a4,41bc <strcpy+0x8>
    ;
  return os;
}
    41ca:	6422                	ld	s0,8(sp)
    41cc:	0141                	addi	sp,sp,16
    41ce:	8082                	ret

00000000000041d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    41d0:	1141                	addi	sp,sp,-16
    41d2:	e422                	sd	s0,8(sp)
    41d4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    41d6:	00054783          	lbu	a5,0(a0)
    41da:	cb91                	beqz	a5,41ee <strcmp+0x1e>
    41dc:	0005c703          	lbu	a4,0(a1)
    41e0:	00f71763          	bne	a4,a5,41ee <strcmp+0x1e>
    p++, q++;
    41e4:	0505                	addi	a0,a0,1
    41e6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    41e8:	00054783          	lbu	a5,0(a0)
    41ec:	fbe5                	bnez	a5,41dc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    41ee:	0005c503          	lbu	a0,0(a1)
}
    41f2:	40a7853b          	subw	a0,a5,a0
    41f6:	6422                	ld	s0,8(sp)
    41f8:	0141                	addi	sp,sp,16
    41fa:	8082                	ret

00000000000041fc <strlen>:

uint
strlen(const char *s)
{
    41fc:	1141                	addi	sp,sp,-16
    41fe:	e422                	sd	s0,8(sp)
    4200:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4202:	00054783          	lbu	a5,0(a0)
    4206:	cf91                	beqz	a5,4222 <strlen+0x26>
    4208:	0505                	addi	a0,a0,1
    420a:	87aa                	mv	a5,a0
    420c:	4685                	li	a3,1
    420e:	9e89                	subw	a3,a3,a0
    4210:	00f6853b          	addw	a0,a3,a5
    4214:	0785                	addi	a5,a5,1
    4216:	fff7c703          	lbu	a4,-1(a5)
    421a:	fb7d                	bnez	a4,4210 <strlen+0x14>
    ;
  return n;
}
    421c:	6422                	ld	s0,8(sp)
    421e:	0141                	addi	sp,sp,16
    4220:	8082                	ret
  for(n = 0; s[n]; n++)
    4222:	4501                	li	a0,0
    4224:	bfe5                	j	421c <strlen+0x20>

0000000000004226 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4226:	1141                	addi	sp,sp,-16
    4228:	e422                	sd	s0,8(sp)
    422a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    422c:	ca19                	beqz	a2,4242 <memset+0x1c>
    422e:	87aa                	mv	a5,a0
    4230:	1602                	slli	a2,a2,0x20
    4232:	9201                	srli	a2,a2,0x20
    4234:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4238:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    423c:	0785                	addi	a5,a5,1
    423e:	fee79de3          	bne	a5,a4,4238 <memset+0x12>
  }
  return dst;
}
    4242:	6422                	ld	s0,8(sp)
    4244:	0141                	addi	sp,sp,16
    4246:	8082                	ret

0000000000004248 <strchr>:

char*
strchr(const char *s, char c)
{
    4248:	1141                	addi	sp,sp,-16
    424a:	e422                	sd	s0,8(sp)
    424c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    424e:	00054783          	lbu	a5,0(a0)
    4252:	cb99                	beqz	a5,4268 <strchr+0x20>
    if(*s == c)
    4254:	00f58763          	beq	a1,a5,4262 <strchr+0x1a>
  for(; *s; s++)
    4258:	0505                	addi	a0,a0,1
    425a:	00054783          	lbu	a5,0(a0)
    425e:	fbfd                	bnez	a5,4254 <strchr+0xc>
      return (char*)s;
  return 0;
    4260:	4501                	li	a0,0
}
    4262:	6422                	ld	s0,8(sp)
    4264:	0141                	addi	sp,sp,16
    4266:	8082                	ret
  return 0;
    4268:	4501                	li	a0,0
    426a:	bfe5                	j	4262 <strchr+0x1a>

000000000000426c <gets>:

char*
gets(char *buf, int max)
{
    426c:	711d                	addi	sp,sp,-96
    426e:	ec86                	sd	ra,88(sp)
    4270:	e8a2                	sd	s0,80(sp)
    4272:	e4a6                	sd	s1,72(sp)
    4274:	e0ca                	sd	s2,64(sp)
    4276:	fc4e                	sd	s3,56(sp)
    4278:	f852                	sd	s4,48(sp)
    427a:	f456                	sd	s5,40(sp)
    427c:	f05a                	sd	s6,32(sp)
    427e:	ec5e                	sd	s7,24(sp)
    4280:	1080                	addi	s0,sp,96
    4282:	8baa                	mv	s7,a0
    4284:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4286:	892a                	mv	s2,a0
    4288:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    428a:	4aa9                	li	s5,10
    428c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    428e:	89a6                	mv	s3,s1
    4290:	2485                	addiw	s1,s1,1
    4292:	0344d863          	bge	s1,s4,42c2 <gets+0x56>
    cc = read(0, &c, 1);
    4296:	4605                	li	a2,1
    4298:	faf40593          	addi	a1,s0,-81
    429c:	4501                	li	a0,0
    429e:	00000097          	auipc	ra,0x0
    42a2:	19c080e7          	jalr	412(ra) # 443a <read>
    if(cc < 1)
    42a6:	00a05e63          	blez	a0,42c2 <gets+0x56>
    buf[i++] = c;
    42aa:	faf44783          	lbu	a5,-81(s0)
    42ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    42b2:	01578763          	beq	a5,s5,42c0 <gets+0x54>
    42b6:	0905                	addi	s2,s2,1
    42b8:	fd679be3          	bne	a5,s6,428e <gets+0x22>
  for(i=0; i+1 < max; ){
    42bc:	89a6                	mv	s3,s1
    42be:	a011                	j	42c2 <gets+0x56>
    42c0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    42c2:	99de                	add	s3,s3,s7
    42c4:	00098023          	sb	zero,0(s3)
  return buf;
}
    42c8:	855e                	mv	a0,s7
    42ca:	60e6                	ld	ra,88(sp)
    42cc:	6446                	ld	s0,80(sp)
    42ce:	64a6                	ld	s1,72(sp)
    42d0:	6906                	ld	s2,64(sp)
    42d2:	79e2                	ld	s3,56(sp)
    42d4:	7a42                	ld	s4,48(sp)
    42d6:	7aa2                	ld	s5,40(sp)
    42d8:	7b02                	ld	s6,32(sp)
    42da:	6be2                	ld	s7,24(sp)
    42dc:	6125                	addi	sp,sp,96
    42de:	8082                	ret

00000000000042e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    42e0:	1101                	addi	sp,sp,-32
    42e2:	ec06                	sd	ra,24(sp)
    42e4:	e822                	sd	s0,16(sp)
    42e6:	e426                	sd	s1,8(sp)
    42e8:	e04a                	sd	s2,0(sp)
    42ea:	1000                	addi	s0,sp,32
    42ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    42ee:	4581                	li	a1,0
    42f0:	00000097          	auipc	ra,0x0
    42f4:	172080e7          	jalr	370(ra) # 4462 <open>
  if(fd < 0)
    42f8:	02054563          	bltz	a0,4322 <stat+0x42>
    42fc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    42fe:	85ca                	mv	a1,s2
    4300:	00000097          	auipc	ra,0x0
    4304:	17a080e7          	jalr	378(ra) # 447a <fstat>
    4308:	892a                	mv	s2,a0
  close(fd);
    430a:	8526                	mv	a0,s1
    430c:	00000097          	auipc	ra,0x0
    4310:	13e080e7          	jalr	318(ra) # 444a <close>
  return r;
}
    4314:	854a                	mv	a0,s2
    4316:	60e2                	ld	ra,24(sp)
    4318:	6442                	ld	s0,16(sp)
    431a:	64a2                	ld	s1,8(sp)
    431c:	6902                	ld	s2,0(sp)
    431e:	6105                	addi	sp,sp,32
    4320:	8082                	ret
    return -1;
    4322:	597d                	li	s2,-1
    4324:	bfc5                	j	4314 <stat+0x34>

0000000000004326 <atoi>:

int
atoi(const char *s)
{
    4326:	1141                	addi	sp,sp,-16
    4328:	e422                	sd	s0,8(sp)
    432a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    432c:	00054603          	lbu	a2,0(a0)
    4330:	fd06079b          	addiw	a5,a2,-48
    4334:	0ff7f793          	andi	a5,a5,255
    4338:	4725                	li	a4,9
    433a:	02f76963          	bltu	a4,a5,436c <atoi+0x46>
    433e:	86aa                	mv	a3,a0
  n = 0;
    4340:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    4342:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    4344:	0685                	addi	a3,a3,1
    4346:	0025179b          	slliw	a5,a0,0x2
    434a:	9fa9                	addw	a5,a5,a0
    434c:	0017979b          	slliw	a5,a5,0x1
    4350:	9fb1                	addw	a5,a5,a2
    4352:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4356:	0006c603          	lbu	a2,0(a3)
    435a:	fd06071b          	addiw	a4,a2,-48
    435e:	0ff77713          	andi	a4,a4,255
    4362:	fee5f1e3          	bgeu	a1,a4,4344 <atoi+0x1e>
  return n;
}
    4366:	6422                	ld	s0,8(sp)
    4368:	0141                	addi	sp,sp,16
    436a:	8082                	ret
  n = 0;
    436c:	4501                	li	a0,0
    436e:	bfe5                	j	4366 <atoi+0x40>

0000000000004370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4370:	1141                	addi	sp,sp,-16
    4372:	e422                	sd	s0,8(sp)
    4374:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4376:	02b57463          	bgeu	a0,a1,439e <memmove+0x2e>
    while(n-- > 0)
    437a:	00c05f63          	blez	a2,4398 <memmove+0x28>
    437e:	1602                	slli	a2,a2,0x20
    4380:	9201                	srli	a2,a2,0x20
    4382:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4386:	872a                	mv	a4,a0
      *dst++ = *src++;
    4388:	0585                	addi	a1,a1,1
    438a:	0705                	addi	a4,a4,1
    438c:	fff5c683          	lbu	a3,-1(a1)
    4390:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4394:	fee79ae3          	bne	a5,a4,4388 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4398:	6422                	ld	s0,8(sp)
    439a:	0141                	addi	sp,sp,16
    439c:	8082                	ret
    dst += n;
    439e:	00c50733          	add	a4,a0,a2
    src += n;
    43a2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    43a4:	fec05ae3          	blez	a2,4398 <memmove+0x28>
    43a8:	fff6079b          	addiw	a5,a2,-1
    43ac:	1782                	slli	a5,a5,0x20
    43ae:	9381                	srli	a5,a5,0x20
    43b0:	fff7c793          	not	a5,a5
    43b4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    43b6:	15fd                	addi	a1,a1,-1
    43b8:	177d                	addi	a4,a4,-1
    43ba:	0005c683          	lbu	a3,0(a1)
    43be:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    43c2:	fee79ae3          	bne	a5,a4,43b6 <memmove+0x46>
    43c6:	bfc9                	j	4398 <memmove+0x28>

00000000000043c8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    43c8:	1141                	addi	sp,sp,-16
    43ca:	e422                	sd	s0,8(sp)
    43cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    43ce:	ca05                	beqz	a2,43fe <memcmp+0x36>
    43d0:	fff6069b          	addiw	a3,a2,-1
    43d4:	1682                	slli	a3,a3,0x20
    43d6:	9281                	srli	a3,a3,0x20
    43d8:	0685                	addi	a3,a3,1
    43da:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    43dc:	00054783          	lbu	a5,0(a0)
    43e0:	0005c703          	lbu	a4,0(a1)
    43e4:	00e79863          	bne	a5,a4,43f4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    43e8:	0505                	addi	a0,a0,1
    p2++;
    43ea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    43ec:	fed518e3          	bne	a0,a3,43dc <memcmp+0x14>
  }
  return 0;
    43f0:	4501                	li	a0,0
    43f2:	a019                	j	43f8 <memcmp+0x30>
      return *p1 - *p2;
    43f4:	40e7853b          	subw	a0,a5,a4
}
    43f8:	6422                	ld	s0,8(sp)
    43fa:	0141                	addi	sp,sp,16
    43fc:	8082                	ret
  return 0;
    43fe:	4501                	li	a0,0
    4400:	bfe5                	j	43f8 <memcmp+0x30>

0000000000004402 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4402:	1141                	addi	sp,sp,-16
    4404:	e406                	sd	ra,8(sp)
    4406:	e022                	sd	s0,0(sp)
    4408:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    440a:	00000097          	auipc	ra,0x0
    440e:	f66080e7          	jalr	-154(ra) # 4370 <memmove>
}
    4412:	60a2                	ld	ra,8(sp)
    4414:	6402                	ld	s0,0(sp)
    4416:	0141                	addi	sp,sp,16
    4418:	8082                	ret

000000000000441a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    441a:	4885                	li	a7,1
 ecall
    441c:	00000073          	ecall
 ret
    4420:	8082                	ret

0000000000004422 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4422:	4889                	li	a7,2
 ecall
    4424:	00000073          	ecall
 ret
    4428:	8082                	ret

000000000000442a <wait>:
.global wait
wait:
 li a7, SYS_wait
    442a:	488d                	li	a7,3
 ecall
    442c:	00000073          	ecall
 ret
    4430:	8082                	ret

0000000000004432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4432:	4891                	li	a7,4
 ecall
    4434:	00000073          	ecall
 ret
    4438:	8082                	ret

000000000000443a <read>:
.global read
read:
 li a7, SYS_read
    443a:	4895                	li	a7,5
 ecall
    443c:	00000073          	ecall
 ret
    4440:	8082                	ret

0000000000004442 <write>:
.global write
write:
 li a7, SYS_write
    4442:	48c1                	li	a7,16
 ecall
    4444:	00000073          	ecall
 ret
    4448:	8082                	ret

000000000000444a <close>:
.global close
close:
 li a7, SYS_close
    444a:	48d5                	li	a7,21
 ecall
    444c:	00000073          	ecall
 ret
    4450:	8082                	ret

0000000000004452 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4452:	4899                	li	a7,6
 ecall
    4454:	00000073          	ecall
 ret
    4458:	8082                	ret

000000000000445a <exec>:
.global exec
exec:
 li a7, SYS_exec
    445a:	489d                	li	a7,7
 ecall
    445c:	00000073          	ecall
 ret
    4460:	8082                	ret

0000000000004462 <open>:
.global open
open:
 li a7, SYS_open
    4462:	48bd                	li	a7,15
 ecall
    4464:	00000073          	ecall
 ret
    4468:	8082                	ret

000000000000446a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    446a:	48c5                	li	a7,17
 ecall
    446c:	00000073          	ecall
 ret
    4470:	8082                	ret

0000000000004472 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4472:	48c9                	li	a7,18
 ecall
    4474:	00000073          	ecall
 ret
    4478:	8082                	ret

000000000000447a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    447a:	48a1                	li	a7,8
 ecall
    447c:	00000073          	ecall
 ret
    4480:	8082                	ret

0000000000004482 <link>:
.global link
link:
 li a7, SYS_link
    4482:	48cd                	li	a7,19
 ecall
    4484:	00000073          	ecall
 ret
    4488:	8082                	ret

000000000000448a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    448a:	48d1                	li	a7,20
 ecall
    448c:	00000073          	ecall
 ret
    4490:	8082                	ret

0000000000004492 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4492:	48a5                	li	a7,9
 ecall
    4494:	00000073          	ecall
 ret
    4498:	8082                	ret

000000000000449a <dup>:
.global dup
dup:
 li a7, SYS_dup
    449a:	48a9                	li	a7,10
 ecall
    449c:	00000073          	ecall
 ret
    44a0:	8082                	ret

00000000000044a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    44a2:	48ad                	li	a7,11
 ecall
    44a4:	00000073          	ecall
 ret
    44a8:	8082                	ret

00000000000044aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    44aa:	48b1                	li	a7,12
 ecall
    44ac:	00000073          	ecall
 ret
    44b0:	8082                	ret

00000000000044b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    44b2:	48b5                	li	a7,13
 ecall
    44b4:	00000073          	ecall
 ret
    44b8:	8082                	ret

00000000000044ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    44ba:	48b9                	li	a7,14
 ecall
    44bc:	00000073          	ecall
 ret
    44c0:	8082                	ret

00000000000044c2 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
    44c2:	48d9                	li	a7,22
 ecall
    44c4:	00000073          	ecall
 ret
    44c8:	8082                	ret

00000000000044ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    44ca:	1101                	addi	sp,sp,-32
    44cc:	ec06                	sd	ra,24(sp)
    44ce:	e822                	sd	s0,16(sp)
    44d0:	1000                	addi	s0,sp,32
    44d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    44d6:	4605                	li	a2,1
    44d8:	fef40593          	addi	a1,s0,-17
    44dc:	00000097          	auipc	ra,0x0
    44e0:	f66080e7          	jalr	-154(ra) # 4442 <write>
}
    44e4:	60e2                	ld	ra,24(sp)
    44e6:	6442                	ld	s0,16(sp)
    44e8:	6105                	addi	sp,sp,32
    44ea:	8082                	ret

00000000000044ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    44ec:	7139                	addi	sp,sp,-64
    44ee:	fc06                	sd	ra,56(sp)
    44f0:	f822                	sd	s0,48(sp)
    44f2:	f426                	sd	s1,40(sp)
    44f4:	f04a                	sd	s2,32(sp)
    44f6:	ec4e                	sd	s3,24(sp)
    44f8:	0080                	addi	s0,sp,64
    44fa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    44fc:	c299                	beqz	a3,4502 <printint+0x16>
    44fe:	0805c863          	bltz	a1,458e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4502:	2581                	sext.w	a1,a1
  neg = 0;
    4504:	4881                	li	a7,0
    4506:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    450a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    450c:	2601                	sext.w	a2,a2
    450e:	00002517          	auipc	a0,0x2
    4512:	4da50513          	addi	a0,a0,1242 # 69e8 <digits>
    4516:	883a                	mv	a6,a4
    4518:	2705                	addiw	a4,a4,1
    451a:	02c5f7bb          	remuw	a5,a1,a2
    451e:	1782                	slli	a5,a5,0x20
    4520:	9381                	srli	a5,a5,0x20
    4522:	97aa                	add	a5,a5,a0
    4524:	0007c783          	lbu	a5,0(a5)
    4528:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    452c:	0005879b          	sext.w	a5,a1
    4530:	02c5d5bb          	divuw	a1,a1,a2
    4534:	0685                	addi	a3,a3,1
    4536:	fec7f0e3          	bgeu	a5,a2,4516 <printint+0x2a>
  if(neg)
    453a:	00088b63          	beqz	a7,4550 <printint+0x64>
    buf[i++] = '-';
    453e:	fd040793          	addi	a5,s0,-48
    4542:	973e                	add	a4,a4,a5
    4544:	02d00793          	li	a5,45
    4548:	fef70823          	sb	a5,-16(a4)
    454c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4550:	02e05863          	blez	a4,4580 <printint+0x94>
    4554:	fc040793          	addi	a5,s0,-64
    4558:	00e78933          	add	s2,a5,a4
    455c:	fff78993          	addi	s3,a5,-1
    4560:	99ba                	add	s3,s3,a4
    4562:	377d                	addiw	a4,a4,-1
    4564:	1702                	slli	a4,a4,0x20
    4566:	9301                	srli	a4,a4,0x20
    4568:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    456c:	fff94583          	lbu	a1,-1(s2)
    4570:	8526                	mv	a0,s1
    4572:	00000097          	auipc	ra,0x0
    4576:	f58080e7          	jalr	-168(ra) # 44ca <putc>
  while(--i >= 0)
    457a:	197d                	addi	s2,s2,-1
    457c:	ff3918e3          	bne	s2,s3,456c <printint+0x80>
}
    4580:	70e2                	ld	ra,56(sp)
    4582:	7442                	ld	s0,48(sp)
    4584:	74a2                	ld	s1,40(sp)
    4586:	7902                	ld	s2,32(sp)
    4588:	69e2                	ld	s3,24(sp)
    458a:	6121                	addi	sp,sp,64
    458c:	8082                	ret
    x = -xx;
    458e:	40b005bb          	negw	a1,a1
    neg = 1;
    4592:	4885                	li	a7,1
    x = -xx;
    4594:	bf8d                	j	4506 <printint+0x1a>

0000000000004596 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4596:	7119                	addi	sp,sp,-128
    4598:	fc86                	sd	ra,120(sp)
    459a:	f8a2                	sd	s0,112(sp)
    459c:	f4a6                	sd	s1,104(sp)
    459e:	f0ca                	sd	s2,96(sp)
    45a0:	ecce                	sd	s3,88(sp)
    45a2:	e8d2                	sd	s4,80(sp)
    45a4:	e4d6                	sd	s5,72(sp)
    45a6:	e0da                	sd	s6,64(sp)
    45a8:	fc5e                	sd	s7,56(sp)
    45aa:	f862                	sd	s8,48(sp)
    45ac:	f466                	sd	s9,40(sp)
    45ae:	f06a                	sd	s10,32(sp)
    45b0:	ec6e                	sd	s11,24(sp)
    45b2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    45b4:	0005c903          	lbu	s2,0(a1)
    45b8:	18090f63          	beqz	s2,4756 <vprintf+0x1c0>
    45bc:	8aaa                	mv	s5,a0
    45be:	8b32                	mv	s6,a2
    45c0:	00158493          	addi	s1,a1,1
  state = 0;
    45c4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    45c6:	02500a13          	li	s4,37
      if(c == 'd'){
    45ca:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    45ce:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    45d2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    45d6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    45da:	00002b97          	auipc	s7,0x2
    45de:	40eb8b93          	addi	s7,s7,1038 # 69e8 <digits>
    45e2:	a839                	j	4600 <vprintf+0x6a>
        putc(fd, c);
    45e4:	85ca                	mv	a1,s2
    45e6:	8556                	mv	a0,s5
    45e8:	00000097          	auipc	ra,0x0
    45ec:	ee2080e7          	jalr	-286(ra) # 44ca <putc>
    45f0:	a019                	j	45f6 <vprintf+0x60>
    } else if(state == '%'){
    45f2:	01498f63          	beq	s3,s4,4610 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    45f6:	0485                	addi	s1,s1,1
    45f8:	fff4c903          	lbu	s2,-1(s1)
    45fc:	14090d63          	beqz	s2,4756 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    4600:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4604:	fe0997e3          	bnez	s3,45f2 <vprintf+0x5c>
      if(c == '%'){
    4608:	fd479ee3          	bne	a5,s4,45e4 <vprintf+0x4e>
        state = '%';
    460c:	89be                	mv	s3,a5
    460e:	b7e5                	j	45f6 <vprintf+0x60>
      if(c == 'd'){
    4610:	05878063          	beq	a5,s8,4650 <vprintf+0xba>
      } else if(c == 'l') {
    4614:	05978c63          	beq	a5,s9,466c <vprintf+0xd6>
      } else if(c == 'x') {
    4618:	07a78863          	beq	a5,s10,4688 <vprintf+0xf2>
      } else if(c == 'p') {
    461c:	09b78463          	beq	a5,s11,46a4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    4620:	07300713          	li	a4,115
    4624:	0ce78663          	beq	a5,a4,46f0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4628:	06300713          	li	a4,99
    462c:	0ee78e63          	beq	a5,a4,4728 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    4630:	11478863          	beq	a5,s4,4740 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4634:	85d2                	mv	a1,s4
    4636:	8556                	mv	a0,s5
    4638:	00000097          	auipc	ra,0x0
    463c:	e92080e7          	jalr	-366(ra) # 44ca <putc>
        putc(fd, c);
    4640:	85ca                	mv	a1,s2
    4642:	8556                	mv	a0,s5
    4644:	00000097          	auipc	ra,0x0
    4648:	e86080e7          	jalr	-378(ra) # 44ca <putc>
      }
      state = 0;
    464c:	4981                	li	s3,0
    464e:	b765                	j	45f6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    4650:	008b0913          	addi	s2,s6,8
    4654:	4685                	li	a3,1
    4656:	4629                	li	a2,10
    4658:	000b2583          	lw	a1,0(s6)
    465c:	8556                	mv	a0,s5
    465e:	00000097          	auipc	ra,0x0
    4662:	e8e080e7          	jalr	-370(ra) # 44ec <printint>
    4666:	8b4a                	mv	s6,s2
      state = 0;
    4668:	4981                	li	s3,0
    466a:	b771                	j	45f6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    466c:	008b0913          	addi	s2,s6,8
    4670:	4681                	li	a3,0
    4672:	4629                	li	a2,10
    4674:	000b2583          	lw	a1,0(s6)
    4678:	8556                	mv	a0,s5
    467a:	00000097          	auipc	ra,0x0
    467e:	e72080e7          	jalr	-398(ra) # 44ec <printint>
    4682:	8b4a                	mv	s6,s2
      state = 0;
    4684:	4981                	li	s3,0
    4686:	bf85                	j	45f6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    4688:	008b0913          	addi	s2,s6,8
    468c:	4681                	li	a3,0
    468e:	4641                	li	a2,16
    4690:	000b2583          	lw	a1,0(s6)
    4694:	8556                	mv	a0,s5
    4696:	00000097          	auipc	ra,0x0
    469a:	e56080e7          	jalr	-426(ra) # 44ec <printint>
    469e:	8b4a                	mv	s6,s2
      state = 0;
    46a0:	4981                	li	s3,0
    46a2:	bf91                	j	45f6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    46a4:	008b0793          	addi	a5,s6,8
    46a8:	f8f43423          	sd	a5,-120(s0)
    46ac:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    46b0:	03000593          	li	a1,48
    46b4:	8556                	mv	a0,s5
    46b6:	00000097          	auipc	ra,0x0
    46ba:	e14080e7          	jalr	-492(ra) # 44ca <putc>
  putc(fd, 'x');
    46be:	85ea                	mv	a1,s10
    46c0:	8556                	mv	a0,s5
    46c2:	00000097          	auipc	ra,0x0
    46c6:	e08080e7          	jalr	-504(ra) # 44ca <putc>
    46ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    46cc:	03c9d793          	srli	a5,s3,0x3c
    46d0:	97de                	add	a5,a5,s7
    46d2:	0007c583          	lbu	a1,0(a5)
    46d6:	8556                	mv	a0,s5
    46d8:	00000097          	auipc	ra,0x0
    46dc:	df2080e7          	jalr	-526(ra) # 44ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    46e0:	0992                	slli	s3,s3,0x4
    46e2:	397d                	addiw	s2,s2,-1
    46e4:	fe0914e3          	bnez	s2,46cc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    46e8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    46ec:	4981                	li	s3,0
    46ee:	b721                	j	45f6 <vprintf+0x60>
        s = va_arg(ap, char*);
    46f0:	008b0993          	addi	s3,s6,8
    46f4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    46f8:	02090163          	beqz	s2,471a <vprintf+0x184>
        while(*s != 0){
    46fc:	00094583          	lbu	a1,0(s2)
    4700:	c9a1                	beqz	a1,4750 <vprintf+0x1ba>
          putc(fd, *s);
    4702:	8556                	mv	a0,s5
    4704:	00000097          	auipc	ra,0x0
    4708:	dc6080e7          	jalr	-570(ra) # 44ca <putc>
          s++;
    470c:	0905                	addi	s2,s2,1
        while(*s != 0){
    470e:	00094583          	lbu	a1,0(s2)
    4712:	f9e5                	bnez	a1,4702 <vprintf+0x16c>
        s = va_arg(ap, char*);
    4714:	8b4e                	mv	s6,s3
      state = 0;
    4716:	4981                	li	s3,0
    4718:	bdf9                	j	45f6 <vprintf+0x60>
          s = "(null)";
    471a:	00002917          	auipc	s2,0x2
    471e:	2c690913          	addi	s2,s2,710 # 69e0 <malloc+0x2180>
        while(*s != 0){
    4722:	02800593          	li	a1,40
    4726:	bff1                	j	4702 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    4728:	008b0913          	addi	s2,s6,8
    472c:	000b4583          	lbu	a1,0(s6)
    4730:	8556                	mv	a0,s5
    4732:	00000097          	auipc	ra,0x0
    4736:	d98080e7          	jalr	-616(ra) # 44ca <putc>
    473a:	8b4a                	mv	s6,s2
      state = 0;
    473c:	4981                	li	s3,0
    473e:	bd65                	j	45f6 <vprintf+0x60>
        putc(fd, c);
    4740:	85d2                	mv	a1,s4
    4742:	8556                	mv	a0,s5
    4744:	00000097          	auipc	ra,0x0
    4748:	d86080e7          	jalr	-634(ra) # 44ca <putc>
      state = 0;
    474c:	4981                	li	s3,0
    474e:	b565                	j	45f6 <vprintf+0x60>
        s = va_arg(ap, char*);
    4750:	8b4e                	mv	s6,s3
      state = 0;
    4752:	4981                	li	s3,0
    4754:	b54d                	j	45f6 <vprintf+0x60>
    }
  }
}
    4756:	70e6                	ld	ra,120(sp)
    4758:	7446                	ld	s0,112(sp)
    475a:	74a6                	ld	s1,104(sp)
    475c:	7906                	ld	s2,96(sp)
    475e:	69e6                	ld	s3,88(sp)
    4760:	6a46                	ld	s4,80(sp)
    4762:	6aa6                	ld	s5,72(sp)
    4764:	6b06                	ld	s6,64(sp)
    4766:	7be2                	ld	s7,56(sp)
    4768:	7c42                	ld	s8,48(sp)
    476a:	7ca2                	ld	s9,40(sp)
    476c:	7d02                	ld	s10,32(sp)
    476e:	6de2                	ld	s11,24(sp)
    4770:	6109                	addi	sp,sp,128
    4772:	8082                	ret

0000000000004774 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4774:	715d                	addi	sp,sp,-80
    4776:	ec06                	sd	ra,24(sp)
    4778:	e822                	sd	s0,16(sp)
    477a:	1000                	addi	s0,sp,32
    477c:	e010                	sd	a2,0(s0)
    477e:	e414                	sd	a3,8(s0)
    4780:	e818                	sd	a4,16(s0)
    4782:	ec1c                	sd	a5,24(s0)
    4784:	03043023          	sd	a6,32(s0)
    4788:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    478c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4790:	8622                	mv	a2,s0
    4792:	00000097          	auipc	ra,0x0
    4796:	e04080e7          	jalr	-508(ra) # 4596 <vprintf>
}
    479a:	60e2                	ld	ra,24(sp)
    479c:	6442                	ld	s0,16(sp)
    479e:	6161                	addi	sp,sp,80
    47a0:	8082                	ret

00000000000047a2 <printf>:

void
printf(const char *fmt, ...)
{
    47a2:	711d                	addi	sp,sp,-96
    47a4:	ec06                	sd	ra,24(sp)
    47a6:	e822                	sd	s0,16(sp)
    47a8:	1000                	addi	s0,sp,32
    47aa:	e40c                	sd	a1,8(s0)
    47ac:	e810                	sd	a2,16(s0)
    47ae:	ec14                	sd	a3,24(s0)
    47b0:	f018                	sd	a4,32(s0)
    47b2:	f41c                	sd	a5,40(s0)
    47b4:	03043823          	sd	a6,48(s0)
    47b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    47bc:	00840613          	addi	a2,s0,8
    47c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    47c4:	85aa                	mv	a1,a0
    47c6:	4505                	li	a0,1
    47c8:	00000097          	auipc	ra,0x0
    47cc:	dce080e7          	jalr	-562(ra) # 4596 <vprintf>
}
    47d0:	60e2                	ld	ra,24(sp)
    47d2:	6442                	ld	s0,16(sp)
    47d4:	6125                	addi	sp,sp,96
    47d6:	8082                	ret

00000000000047d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    47d8:	1141                	addi	sp,sp,-16
    47da:	e422                	sd	s0,8(sp)
    47dc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    47de:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    47e2:	00002797          	auipc	a5,0x2
    47e6:	2367b783          	ld	a5,566(a5) # 6a18 <freep>
    47ea:	a805                	j	481a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    47ec:	4618                	lw	a4,8(a2)
    47ee:	9db9                	addw	a1,a1,a4
    47f0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    47f4:	6398                	ld	a4,0(a5)
    47f6:	6318                	ld	a4,0(a4)
    47f8:	fee53823          	sd	a4,-16(a0)
    47fc:	a091                	j	4840 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    47fe:	ff852703          	lw	a4,-8(a0)
    4802:	9e39                	addw	a2,a2,a4
    4804:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4806:	ff053703          	ld	a4,-16(a0)
    480a:	e398                	sd	a4,0(a5)
    480c:	a099                	j	4852 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    480e:	6398                	ld	a4,0(a5)
    4810:	00e7e463          	bltu	a5,a4,4818 <free+0x40>
    4814:	00e6ea63          	bltu	a3,a4,4828 <free+0x50>
{
    4818:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    481a:	fed7fae3          	bgeu	a5,a3,480e <free+0x36>
    481e:	6398                	ld	a4,0(a5)
    4820:	00e6e463          	bltu	a3,a4,4828 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4824:	fee7eae3          	bltu	a5,a4,4818 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4828:	ff852583          	lw	a1,-8(a0)
    482c:	6390                	ld	a2,0(a5)
    482e:	02059813          	slli	a6,a1,0x20
    4832:	01c85713          	srli	a4,a6,0x1c
    4836:	9736                	add	a4,a4,a3
    4838:	fae60ae3          	beq	a2,a4,47ec <free+0x14>
    bp->s.ptr = p->s.ptr;
    483c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4840:	4790                	lw	a2,8(a5)
    4842:	02061593          	slli	a1,a2,0x20
    4846:	01c5d713          	srli	a4,a1,0x1c
    484a:	973e                	add	a4,a4,a5
    484c:	fae689e3          	beq	a3,a4,47fe <free+0x26>
  } else
    p->s.ptr = bp;
    4850:	e394                	sd	a3,0(a5)
  freep = p;
    4852:	00002717          	auipc	a4,0x2
    4856:	1cf73323          	sd	a5,454(a4) # 6a18 <freep>
}
    485a:	6422                	ld	s0,8(sp)
    485c:	0141                	addi	sp,sp,16
    485e:	8082                	ret

0000000000004860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4860:	7139                	addi	sp,sp,-64
    4862:	fc06                	sd	ra,56(sp)
    4864:	f822                	sd	s0,48(sp)
    4866:	f426                	sd	s1,40(sp)
    4868:	f04a                	sd	s2,32(sp)
    486a:	ec4e                	sd	s3,24(sp)
    486c:	e852                	sd	s4,16(sp)
    486e:	e456                	sd	s5,8(sp)
    4870:	e05a                	sd	s6,0(sp)
    4872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4874:	02051493          	slli	s1,a0,0x20
    4878:	9081                	srli	s1,s1,0x20
    487a:	04bd                	addi	s1,s1,15
    487c:	8091                	srli	s1,s1,0x4
    487e:	0014899b          	addiw	s3,s1,1
    4882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4884:	00002517          	auipc	a0,0x2
    4888:	19453503          	ld	a0,404(a0) # 6a18 <freep>
    488c:	c515                	beqz	a0,48b8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    488e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4890:	4798                	lw	a4,8(a5)
    4892:	02977f63          	bgeu	a4,s1,48d0 <malloc+0x70>
    4896:	8a4e                	mv	s4,s3
    4898:	0009871b          	sext.w	a4,s3
    489c:	6685                	lui	a3,0x1
    489e:	00d77363          	bgeu	a4,a3,48a4 <malloc+0x44>
    48a2:	6a05                	lui	s4,0x1
    48a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    48a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    48ac:	00002917          	auipc	s2,0x2
    48b0:	16c90913          	addi	s2,s2,364 # 6a18 <freep>
  if(p == (char*)-1)
    48b4:	5afd                	li	s5,-1
    48b6:	a895                	j	492a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    48b8:	00008797          	auipc	a5,0x8
    48bc:	97878793          	addi	a5,a5,-1672 # c230 <base>
    48c0:	00002717          	auipc	a4,0x2
    48c4:	14f73c23          	sd	a5,344(a4) # 6a18 <freep>
    48c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    48ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    48ce:	b7e1                	j	4896 <malloc+0x36>
      if(p->s.size == nunits)
    48d0:	02e48c63          	beq	s1,a4,4908 <malloc+0xa8>
        p->s.size -= nunits;
    48d4:	4137073b          	subw	a4,a4,s3
    48d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    48da:	02071693          	slli	a3,a4,0x20
    48de:	01c6d713          	srli	a4,a3,0x1c
    48e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    48e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    48e8:	00002717          	auipc	a4,0x2
    48ec:	12a73823          	sd	a0,304(a4) # 6a18 <freep>
      return (void*)(p + 1);
    48f0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    48f4:	70e2                	ld	ra,56(sp)
    48f6:	7442                	ld	s0,48(sp)
    48f8:	74a2                	ld	s1,40(sp)
    48fa:	7902                	ld	s2,32(sp)
    48fc:	69e2                	ld	s3,24(sp)
    48fe:	6a42                	ld	s4,16(sp)
    4900:	6aa2                	ld	s5,8(sp)
    4902:	6b02                	ld	s6,0(sp)
    4904:	6121                	addi	sp,sp,64
    4906:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4908:	6398                	ld	a4,0(a5)
    490a:	e118                	sd	a4,0(a0)
    490c:	bff1                	j	48e8 <malloc+0x88>
  hp->s.size = nu;
    490e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4912:	0541                	addi	a0,a0,16
    4914:	00000097          	auipc	ra,0x0
    4918:	ec4080e7          	jalr	-316(ra) # 47d8 <free>
  return freep;
    491c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4920:	d971                	beqz	a0,48f4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4922:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4924:	4798                	lw	a4,8(a5)
    4926:	fa9775e3          	bgeu	a4,s1,48d0 <malloc+0x70>
    if(p == freep)
    492a:	00093703          	ld	a4,0(s2)
    492e:	853e                	mv	a0,a5
    4930:	fef719e3          	bne	a4,a5,4922 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    4934:	8552                	mv	a0,s4
    4936:	00000097          	auipc	ra,0x0
    493a:	b74080e7          	jalr	-1164(ra) # 44aa <sbrk>
  if(p == (char*)-1)
    493e:	fd5518e3          	bne	a0,s5,490e <malloc+0xae>
        return 0;
    4942:	4501                	li	a0,0
    4944:	bf45                	j	48f4 <malloc+0x94>
