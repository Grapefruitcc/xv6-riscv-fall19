
user/_nsh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
#define MAXWORD 30
#define MAXLINE 100


int getcmd(char *buf, int nbuf) //获取指令
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
	fprintf(2, "@ ");
  10:	00001597          	auipc	a1,0x1
  14:	b5858593          	addi	a1,a1,-1192 # b68 <malloc+0xec>
  18:	4509                	li	a0,2
  1a:	00001097          	auipc	ra,0x1
  1e:	976080e7          	jalr	-1674(ra) # 990 <fprintf>
	memset(buf, 0, nbuf);
  22:	864a                	mv	a2,s2
  24:	4581                	li	a1,0
  26:	8526                	mv	a0,s1
  28:	00000097          	auipc	ra,0x0
  2c:	482080e7          	jalr	1154(ra) # 4aa <memset>
	gets(buf, nbuf);
  30:	85ca                	mv	a1,s2
  32:	8526                	mv	a0,s1
  34:	00000097          	auipc	ra,0x0
  38:	4bc080e7          	jalr	1212(ra) # 4f0 <gets>
	if (buf[0] == 0) // EOF
  3c:	0004c503          	lbu	a0,0(s1)
  40:	00153513          	seqz	a0,a0
		return -1;
	return 0;
}
  44:	40a00533          	neg	a0,a0
  48:	60e2                	ld	ra,24(sp)
  4a:	6442                	ld	s0,16(sp)
  4c:	64a2                	ld	s1,8(sp)
  4e:	6902                	ld	s2,0(sp)
  50:	6105                	addi	sp,sp,32
  52:	8082                	ret

0000000000000054 <parsecmd>:


char whitespace[] = " \t\r\n\v";
char args[MAXARGS][MAXWORD];

void parsecmd(char *cmd, char *argv[], int *argc) {
  54:	7119                	addi	sp,sp,-128
  56:	fc86                	sd	ra,120(sp)
  58:	f8a2                	sd	s0,112(sp)
  5a:	f4a6                	sd	s1,104(sp)
  5c:	f0ca                	sd	s2,96(sp)
  5e:	ecce                	sd	s3,88(sp)
  60:	e8d2                	sd	s4,80(sp)
  62:	e4d6                	sd	s5,72(sp)
  64:	e0da                	sd	s6,64(sp)
  66:	fc5e                	sd	s7,56(sp)
  68:	f862                	sd	s8,48(sp)
  6a:	f466                	sd	s9,40(sp)
  6c:	f06a                	sd	s10,32(sp)
  6e:	ec6e                	sd	s11,24(sp)
  70:	0100                	addi	s0,sp,128
  72:	8baa                	mv	s7,a0
  74:	8dae                	mv	s11,a1
  76:	f8c43423          	sd	a2,-120(s0)
	for (int i = 0; i < MAXARGS; i++) {
  7a:	00001797          	auipc	a5,0x1
  7e:	b4e78793          	addi	a5,a5,-1202 # bc8 <args>
  82:	8c2e                	mv	s8,a1
  84:	00001697          	auipc	a3,0x1
  88:	c7068693          	addi	a3,a3,-912 # cf4 <args+0x12c>
void parsecmd(char *cmd, char *argv[], int *argc) {
  8c:	872e                	mv	a4,a1
		argv[i] = &args[i][0];
  8e:	e31c                	sd	a5,0(a4)
	for (int i = 0; i < MAXARGS; i++) {
  90:	07f9                	addi	a5,a5,30
  92:	0721                	addi	a4,a4,8
  94:	fed79de3          	bne	a5,a3,8e <parsecmd+0x3a>
	}
	int i = 0; int j = 0; 
	for (i = 0; cmd[i] != '\n' && cmd[i] != '\0'; i++) {
  98:	000bc783          	lbu	a5,0(s7)
  9c:	4729                	li	a4,10
	int i = 0; int j = 0; 
  9e:	4c81                	li	s9,0
	for (i = 0; cmd[i] != '\n' && cmd[i] != '\0'; i++) {
  a0:	4981                	li	s3,0
		//跳过空格找到word
		while (strchr(whitespace, cmd[i])) {
  a2:	00001a17          	auipc	s4,0x1
  a6:	b16a0a13          	addi	s4,s4,-1258 # bb8 <whitespace>
	for (i = 0; cmd[i] != '\n' && cmd[i] != '\0'; i++) {
  aa:	4d29                	li	s10,10
  ac:	06e78463          	beq	a5,a4,114 <parsecmd+0xc0>
  b0:	c3b5                	beqz	a5,114 <parsecmd+0xc0>
  b2:	013b87b3          	add	a5,s7,s3
  b6:	893e                	mv	s2,a5
  b8:	40f989bb          	subw	s3,s3,a5
  bc:	012984bb          	addw	s1,s3,s2
  c0:	00048a9b          	sext.w	s5,s1
		while (strchr(whitespace, cmd[i])) {
  c4:	8b4a                	mv	s6,s2
  c6:	00094583          	lbu	a1,0(s2)
  ca:	8552                	mv	a0,s4
  cc:	00000097          	auipc	ra,0x0
  d0:	400080e7          	jalr	1024(ra) # 4cc <strchr>
  d4:	0905                	addi	s2,s2,1
  d6:	f17d                	bnez	a0,bc <parsecmd+0x68>
			i++;
		}
		//把word存入argv
		argv[j++] = cmd + i;
  d8:	2c85                	addiw	s9,s9,1
  da:	016c3023          	sd	s6,0(s8)
		//跳过word找到下一个空格
		while (strchr(whitespace, cmd[i]) == 0) {
  de:	015b84b3          	add	s1,s7,s5
  e2:	8926                	mv	s2,s1
  e4:	409a8abb          	subw	s5,s5,s1
  e8:	012a89bb          	addw	s3,s5,s2
  ec:	84ca                	mv	s1,s2
  ee:	00094583          	lbu	a1,0(s2)
  f2:	8552                	mv	a0,s4
  f4:	00000097          	auipc	ra,0x0
  f8:	3d8080e7          	jalr	984(ra) # 4cc <strchr>
  fc:	0905                	addi	s2,s2,1
  fe:	d56d                	beqz	a0,e8 <parsecmd+0x94>
			i++;
		}
		cmd[i] = '\0';
 100:	00048023          	sb	zero,0(s1)
	for (i = 0; cmd[i] != '\n' && cmd[i] != '\0'; i++) {
 104:	2985                	addiw	s3,s3,1
 106:	013b87b3          	add	a5,s7,s3
 10a:	0007c783          	lbu	a5,0(a5)
 10e:	0c21                	addi	s8,s8,8
 110:	fba790e3          	bne	a5,s10,b0 <parsecmd+0x5c>
	}
	argv[j] = 0;
 114:	003c9793          	slli	a5,s9,0x3
 118:	9dbe                	add	s11,s11,a5
 11a:	000db023          	sd	zero,0(s11)
	*argc = j;
 11e:	f8843783          	ld	a5,-120(s0)
 122:	0197a023          	sw	s9,0(a5)
}
 126:	70e6                	ld	ra,120(sp)
 128:	7446                	ld	s0,112(sp)
 12a:	74a6                	ld	s1,104(sp)
 12c:	7906                	ld	s2,96(sp)
 12e:	69e6                	ld	s3,88(sp)
 130:	6a46                	ld	s4,80(sp)
 132:	6aa6                	ld	s5,72(sp)
 134:	6b06                	ld	s6,64(sp)
 136:	7be2                	ld	s7,56(sp)
 138:	7c42                	ld	s8,48(sp)
 13a:	7ca2                	ld	s9,40(sp)
 13c:	7d02                	ld	s10,32(sp)
 13e:	6de2                	ld	s11,24(sp)
 140:	6109                	addi	sp,sp,128
 142:	8082                	ret

0000000000000144 <parsepipe>:
		}
	}
	exec(argv[0], argv);
}
//parsepipe参考user/sh.c runcmd中的case PIPE
void parsepipe(char *argv[], int argc) {
 144:	715d                	addi	sp,sp,-80
 146:	e486                	sd	ra,72(sp)
 148:	e0a2                	sd	s0,64(sp)
 14a:	fc26                	sd	s1,56(sp)
 14c:	f84a                	sd	s2,48(sp)
 14e:	f44e                	sd	s3,40(sp)
 150:	f052                	sd	s4,32(sp)
 152:	ec56                	sd	s5,24(sp)
 154:	e85a                	sd	s6,16(sp)
 156:	0880                	addi	s0,sp,80
 158:	8b2a                	mv	s6,a0
 15a:	89ae                	mv	s3,a1
	int i = 0;
	int p[2];
	pipe(p);
 15c:	fb840513          	addi	a0,s0,-72
 160:	00000097          	auipc	ra,0x0
 164:	4d6080e7          	jalr	1238(ra) # 636 <pipe>
	for (i = 0; i < argc; i++) {
 168:	0b305363          	blez	s3,20e <parsepipe+0xca>
 16c:	84da                	mv	s1,s6
 16e:	4901                	li	s2,0
		if (!strcmp(argv[i], "|")) {
 170:	00001a17          	auipc	s4,0x1
 174:	a00a0a13          	addi	s4,s4,-1536 # b70 <malloc+0xf4>
 178:	85d2                	mv	a1,s4
 17a:	6088                	ld	a0,0(s1)
 17c:	00000097          	auipc	ra,0x0
 180:	2d8080e7          	jalr	728(ra) # 454 <strcmp>
 184:	c511                	beqz	a0,190 <parsepipe+0x4c>
	for (i = 0; i < argc; i++) {
 186:	2905                	addiw	s2,s2,1
 188:	04a1                	addi	s1,s1,8
 18a:	ff2997e3          	bne	s3,s2,178 <parsepipe+0x34>
 18e:	a019                	j	194 <parsepipe+0x50>
			argv[i] = 0;
 190:	0004b023          	sd	zero,0(s1)
			break;
		}
	}
	if (fork() == 0) {
 194:	00000097          	auipc	ra,0x0
 198:	48a080e7          	jalr	1162(ra) # 61e <fork>
 19c:	e93d                	bnez	a0,212 <parsepipe+0xce>
		close(1);
 19e:	4505                	li	a0,1
 1a0:	00000097          	auipc	ra,0x0
 1a4:	4ae080e7          	jalr	1198(ra) # 64e <close>
		dup(p[1]);
 1a8:	fbc42503          	lw	a0,-68(s0)
 1ac:	00000097          	auipc	ra,0x0
 1b0:	4f2080e7          	jalr	1266(ra) # 69e <dup>
		close(p[0]);
 1b4:	fb842503          	lw	a0,-72(s0)
 1b8:	00000097          	auipc	ra,0x0
 1bc:	496080e7          	jalr	1174(ra) # 64e <close>
		close(p[1]);
 1c0:	fbc42503          	lw	a0,-68(s0)
 1c4:	00000097          	auipc	ra,0x0
 1c8:	48a080e7          	jalr	1162(ra) # 64e <close>
		runcmd(argv, i);
 1cc:	85ca                	mv	a1,s2
 1ce:	855a                	mv	a0,s6
 1d0:	00000097          	auipc	ra,0x0
 1d4:	088080e7          	jalr	136(ra) # 258 <runcmd>
		dup(p[0]);
		close(p[0]);
		close(p[1]);
		runcmd(argv + i + 1, argc - i - 1);
	}
	close(p[0]);
 1d8:	fb842503          	lw	a0,-72(s0)
 1dc:	00000097          	auipc	ra,0x0
 1e0:	472080e7          	jalr	1138(ra) # 64e <close>
	close(p[1]);
 1e4:	fbc42503          	lw	a0,-68(s0)
 1e8:	00000097          	auipc	ra,0x0
 1ec:	466080e7          	jalr	1126(ra) # 64e <close>
	wait(0);
 1f0:	4501                	li	a0,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	43c080e7          	jalr	1084(ra) # 62e <wait>
}
 1fa:	60a6                	ld	ra,72(sp)
 1fc:	6406                	ld	s0,64(sp)
 1fe:	74e2                	ld	s1,56(sp)
 200:	7942                	ld	s2,48(sp)
 202:	79a2                	ld	s3,40(sp)
 204:	7a02                	ld	s4,32(sp)
 206:	6ae2                	ld	s5,24(sp)
 208:	6b42                	ld	s6,16(sp)
 20a:	6161                	addi	sp,sp,80
 20c:	8082                	ret
	for (i = 0; i < argc; i++) {
 20e:	4901                	li	s2,0
 210:	b751                	j	194 <parsepipe+0x50>
		close(0);
 212:	4501                	li	a0,0
 214:	00000097          	auipc	ra,0x0
 218:	43a080e7          	jalr	1082(ra) # 64e <close>
		dup(p[0]);
 21c:	fb842503          	lw	a0,-72(s0)
 220:	00000097          	auipc	ra,0x0
 224:	47e080e7          	jalr	1150(ra) # 69e <dup>
		close(p[0]);
 228:	fb842503          	lw	a0,-72(s0)
 22c:	00000097          	auipc	ra,0x0
 230:	422080e7          	jalr	1058(ra) # 64e <close>
		close(p[1]);
 234:	fbc42503          	lw	a0,-68(s0)
 238:	00000097          	auipc	ra,0x0
 23c:	416080e7          	jalr	1046(ra) # 64e <close>
		runcmd(argv + i + 1, argc - i - 1);
 240:	412985bb          	subw	a1,s3,s2
 244:	0905                	addi	s2,s2,1
 246:	090e                	slli	s2,s2,0x3
 248:	35fd                	addiw	a1,a1,-1
 24a:	012b0533          	add	a0,s6,s2
 24e:	00000097          	auipc	ra,0x0
 252:	00a080e7          	jalr	10(ra) # 258 <runcmd>
 256:	b749                	j	1d8 <parsepipe+0x94>

0000000000000258 <runcmd>:
void runcmd(char *argv[], int argc) {
 258:	7139                	addi	sp,sp,-64
 25a:	fc06                	sd	ra,56(sp)
 25c:	f822                	sd	s0,48(sp)
 25e:	f426                	sd	s1,40(sp)
 260:	f04a                	sd	s2,32(sp)
 262:	ec4e                	sd	s3,24(sp)
 264:	e852                	sd	s4,16(sp)
 266:	e456                	sd	s5,8(sp)
 268:	e05a                	sd	s6,0(sp)
 26a:	0080                	addi	s0,sp,64
 26c:	8a2a                	mv	s4,a0
	for (i = 1; i < argc; i++) {
 26e:	4785                	li	a5,1
 270:	0ab7df63          	bge	a5,a1,32e <runcmd+0xd6>
 274:	8b2e                	mv	s6,a1
 276:	00850493          	addi	s1,a0,8
 27a:	ffe5899b          	addiw	s3,a1,-2
 27e:	02099793          	slli	a5,s3,0x20
 282:	01d7d993          	srli	s3,a5,0x1d
 286:	01050793          	addi	a5,a0,16
 28a:	99be                	add	s3,s3,a5
 28c:	8926                	mv	s2,s1
		if (!strcmp(argv[i], "|")) {
 28e:	00001a97          	auipc	s5,0x1
 292:	8e2a8a93          	addi	s5,s5,-1822 # b70 <malloc+0xf4>
 296:	a021                	j	29e <runcmd+0x46>
	for (i = 1; i < argc; i++) {
 298:	0921                	addi	s2,s2,8
 29a:	03390163          	beq	s2,s3,2bc <runcmd+0x64>
		if (!strcmp(argv[i], "|")) {
 29e:	85d6                	mv	a1,s5
 2a0:	00093503          	ld	a0,0(s2)
 2a4:	00000097          	auipc	ra,0x0
 2a8:	1b0080e7          	jalr	432(ra) # 454 <strcmp>
 2ac:	f575                	bnez	a0,298 <runcmd+0x40>
			parsepipe(argv, argc);
 2ae:	85da                	mv	a1,s6
 2b0:	8552                	mv	a0,s4
 2b2:	00000097          	auipc	ra,0x0
 2b6:	e92080e7          	jalr	-366(ra) # 144 <parsepipe>
 2ba:	bff9                	j	298 <runcmd+0x40>
		if (!strcmp(argv[i], ">")) {
 2bc:	00001b17          	auipc	s6,0x1
 2c0:	8bcb0b13          	addi	s6,s6,-1860 # b78 <malloc+0xfc>
		if (!strcmp(argv[i], "<")) {
 2c4:	00001a97          	auipc	s5,0x1
 2c8:	8bca8a93          	addi	s5,s5,-1860 # b80 <malloc+0x104>
 2cc:	a01d                	j	2f2 <runcmd+0x9a>
			close(1);
 2ce:	4505                	li	a0,1
 2d0:	00000097          	auipc	ra,0x0
 2d4:	37e080e7          	jalr	894(ra) # 64e <close>
			open(argv[i + 1], O_CREATE | O_WRONLY);
 2d8:	20100593          	li	a1,513
 2dc:	6488                	ld	a0,8(s1)
 2de:	00000097          	auipc	ra,0x0
 2e2:	388080e7          	jalr	904(ra) # 666 <open>
			argv[i] = 0;
 2e6:	0004b023          	sd	zero,0(s1)
 2ea:	a821                	j	302 <runcmd+0xaa>
	for (i = 1; i < argc; i++) {
 2ec:	04a1                	addi	s1,s1,8
 2ee:	05348063          	beq	s1,s3,32e <runcmd+0xd6>
		if (!strcmp(argv[i], ">")) {
 2f2:	8926                	mv	s2,s1
 2f4:	85da                	mv	a1,s6
 2f6:	6088                	ld	a0,0(s1)
 2f8:	00000097          	auipc	ra,0x0
 2fc:	15c080e7          	jalr	348(ra) # 454 <strcmp>
 300:	d579                	beqz	a0,2ce <runcmd+0x76>
		if (!strcmp(argv[i], "<")) {
 302:	85d6                	mv	a1,s5
 304:	00093503          	ld	a0,0(s2)
 308:	00000097          	auipc	ra,0x0
 30c:	14c080e7          	jalr	332(ra) # 454 <strcmp>
 310:	fd71                	bnez	a0,2ec <runcmd+0x94>
			close(0);
 312:	00000097          	auipc	ra,0x0
 316:	33c080e7          	jalr	828(ra) # 64e <close>
			open(argv[i + 1], O_RDONLY);
 31a:	4581                	li	a1,0
 31c:	00893503          	ld	a0,8(s2)
 320:	00000097          	auipc	ra,0x0
 324:	346080e7          	jalr	838(ra) # 666 <open>
			argv[i] = 0;
 328:	00093023          	sd	zero,0(s2)
 32c:	b7c1                	j	2ec <runcmd+0x94>
	exec(argv[0], argv);
 32e:	85d2                	mv	a1,s4
 330:	000a3503          	ld	a0,0(s4)
 334:	00000097          	auipc	ra,0x0
 338:	32a080e7          	jalr	810(ra) # 65e <exec>
}
 33c:	70e2                	ld	ra,56(sp)
 33e:	7442                	ld	s0,48(sp)
 340:	74a2                	ld	s1,40(sp)
 342:	7902                	ld	s2,32(sp)
 344:	69e2                	ld	s3,24(sp)
 346:	6a42                	ld	s4,16(sp)
 348:	6aa2                	ld	s5,8(sp)
 34a:	6b02                	ld	s6,0(sp)
 34c:	6121                	addi	sp,sp,64
 34e:	8082                	ret

0000000000000350 <main>:

//main函数来自user/sh.c
int main(void){ 
 350:	7135                	addi	sp,sp,-160
 352:	ed06                	sd	ra,152(sp)
 354:	e922                	sd	s0,144(sp)
 356:	e526                	sd	s1,136(sp)
 358:	e14a                	sd	s2,128(sp)
 35a:	fcce                	sd	s3,120(sp)
 35c:	f8d2                	sd	s4,112(sp)
 35e:	f4d6                	sd	s5,104(sp)
 360:	f0da                	sd	s6,96(sp)
 362:	1100                	addi	s0,sp,160
	static char buf[MAXLINE];

	// Read and run input commands.
	while (getcmd(buf, sizeof(buf)) >= 0) {
 364:	00001917          	auipc	s2,0x1
 368:	99490913          	addi	s2,s2,-1644 # cf8 <buf.0>
		if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
 36c:	00001497          	auipc	s1,0x1
 370:	85c48493          	addi	s1,s1,-1956 # bc8 <args>
 374:	06300993          	li	s3,99
			}
			continue;
		}
		if (fork() == 0) {
			char *argv[MAXARGS];
			int argc = -1;
 378:	5a7d                	li	s4,-1
		if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
 37a:	02000a93          	li	s5,32
			if (chdir(buf + 3) < 0) {
 37e:	00001b17          	auipc	s6,0x1
 382:	97db0b13          	addi	s6,s6,-1667 # cfb <buf.0+0x3>
	while (getcmd(buf, sizeof(buf)) >= 0) {
 386:	a819                	j	39c <main+0x4c>
		if (fork() == 0) {
 388:	00000097          	auipc	ra,0x0
 38c:	296080e7          	jalr	662(ra) # 61e <fork>
 390:	c93d                	beqz	a0,406 <main+0xb6>
			parsecmd(buf, argv, &argc);
			runcmd(argv, argc);
		}	
		wait(0);
 392:	4501                	li	a0,0
 394:	00000097          	auipc	ra,0x0
 398:	29a080e7          	jalr	666(ra) # 62e <wait>
	while (getcmd(buf, sizeof(buf)) >= 0) {
 39c:	06400593          	li	a1,100
 3a0:	854a                	mv	a0,s2
 3a2:	00000097          	auipc	ra,0x0
 3a6:	c5e080e7          	jalr	-930(ra) # 0 <getcmd>
 3aa:	08054263          	bltz	a0,42e <main+0xde>
		if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
 3ae:	1304c783          	lbu	a5,304(s1)
 3b2:	fd379be3          	bne	a5,s3,388 <main+0x38>
 3b6:	1314c703          	lbu	a4,305(s1)
 3ba:	06400793          	li	a5,100
 3be:	fcf715e3          	bne	a4,a5,388 <main+0x38>
 3c2:	1324c783          	lbu	a5,306(s1)
 3c6:	fd5791e3          	bne	a5,s5,388 <main+0x38>
			buf[strlen(buf) - 1] = 0;  // chop \n
 3ca:	854a                	mv	a0,s2
 3cc:	00000097          	auipc	ra,0x0
 3d0:	0b4080e7          	jalr	180(ra) # 480 <strlen>
 3d4:	fff5079b          	addiw	a5,a0,-1
 3d8:	1782                	slli	a5,a5,0x20
 3da:	9381                	srli	a5,a5,0x20
 3dc:	97a6                	add	a5,a5,s1
 3de:	12078823          	sb	zero,304(a5)
			if (chdir(buf + 3) < 0) {
 3e2:	855a                	mv	a0,s6
 3e4:	00000097          	auipc	ra,0x0
 3e8:	2b2080e7          	jalr	690(ra) # 696 <chdir>
 3ec:	fa0558e3          	bgez	a0,39c <main+0x4c>
				fprintf(2, "cannot cd %s\n", buf + 3);
 3f0:	865a                	mv	a2,s6
 3f2:	00000597          	auipc	a1,0x0
 3f6:	79658593          	addi	a1,a1,1942 # b88 <malloc+0x10c>
 3fa:	4509                	li	a0,2
 3fc:	00000097          	auipc	ra,0x0
 400:	594080e7          	jalr	1428(ra) # 990 <fprintf>
 404:	bf61                	j	39c <main+0x4c>
			int argc = -1;
 406:	f7442623          	sw	s4,-148(s0)
			parsecmd(buf, argv, &argc);
 40a:	f6c40613          	addi	a2,s0,-148
 40e:	f7040593          	addi	a1,s0,-144
 412:	854a                	mv	a0,s2
 414:	00000097          	auipc	ra,0x0
 418:	c40080e7          	jalr	-960(ra) # 54 <parsecmd>
			runcmd(argv, argc);
 41c:	f6c42583          	lw	a1,-148(s0)
 420:	f7040513          	addi	a0,s0,-144
 424:	00000097          	auipc	ra,0x0
 428:	e34080e7          	jalr	-460(ra) # 258 <runcmd>
 42c:	b79d                	j	392 <main+0x42>
	}
	exit(0);
 42e:	4501                	li	a0,0
 430:	00000097          	auipc	ra,0x0
 434:	1f6080e7          	jalr	502(ra) # 626 <exit>

0000000000000438 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 43e:	87aa                	mv	a5,a0
 440:	0585                	addi	a1,a1,1
 442:	0785                	addi	a5,a5,1
 444:	fff5c703          	lbu	a4,-1(a1)
 448:	fee78fa3          	sb	a4,-1(a5)
 44c:	fb75                	bnez	a4,440 <strcpy+0x8>
    ;
  return os;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret

0000000000000454 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 454:	1141                	addi	sp,sp,-16
 456:	e422                	sd	s0,8(sp)
 458:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 45a:	00054783          	lbu	a5,0(a0)
 45e:	cb91                	beqz	a5,472 <strcmp+0x1e>
 460:	0005c703          	lbu	a4,0(a1)
 464:	00f71763          	bne	a4,a5,472 <strcmp+0x1e>
    p++, q++;
 468:	0505                	addi	a0,a0,1
 46a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 46c:	00054783          	lbu	a5,0(a0)
 470:	fbe5                	bnez	a5,460 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 472:	0005c503          	lbu	a0,0(a1)
}
 476:	40a7853b          	subw	a0,a5,a0
 47a:	6422                	ld	s0,8(sp)
 47c:	0141                	addi	sp,sp,16
 47e:	8082                	ret

0000000000000480 <strlen>:

uint
strlen(const char *s)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 486:	00054783          	lbu	a5,0(a0)
 48a:	cf91                	beqz	a5,4a6 <strlen+0x26>
 48c:	0505                	addi	a0,a0,1
 48e:	87aa                	mv	a5,a0
 490:	4685                	li	a3,1
 492:	9e89                	subw	a3,a3,a0
 494:	00f6853b          	addw	a0,a3,a5
 498:	0785                	addi	a5,a5,1
 49a:	fff7c703          	lbu	a4,-1(a5)
 49e:	fb7d                	bnez	a4,494 <strlen+0x14>
    ;
  return n;
}
 4a0:	6422                	ld	s0,8(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret
  for(n = 0; s[n]; n++)
 4a6:	4501                	li	a0,0
 4a8:	bfe5                	j	4a0 <strlen+0x20>

00000000000004aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4b0:	ca19                	beqz	a2,4c6 <memset+0x1c>
 4b2:	87aa                	mv	a5,a0
 4b4:	1602                	slli	a2,a2,0x20
 4b6:	9201                	srli	a2,a2,0x20
 4b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4c0:	0785                	addi	a5,a5,1
 4c2:	fee79de3          	bne	a5,a4,4bc <memset+0x12>
  }
  return dst;
}
 4c6:	6422                	ld	s0,8(sp)
 4c8:	0141                	addi	sp,sp,16
 4ca:	8082                	ret

00000000000004cc <strchr>:

char*
strchr(const char *s, char c)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e422                	sd	s0,8(sp)
 4d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4d2:	00054783          	lbu	a5,0(a0)
 4d6:	cb99                	beqz	a5,4ec <strchr+0x20>
    if(*s == c)
 4d8:	00f58763          	beq	a1,a5,4e6 <strchr+0x1a>
  for(; *s; s++)
 4dc:	0505                	addi	a0,a0,1
 4de:	00054783          	lbu	a5,0(a0)
 4e2:	fbfd                	bnez	a5,4d8 <strchr+0xc>
      return (char*)s;
  return 0;
 4e4:	4501                	li	a0,0
}
 4e6:	6422                	ld	s0,8(sp)
 4e8:	0141                	addi	sp,sp,16
 4ea:	8082                	ret
  return 0;
 4ec:	4501                	li	a0,0
 4ee:	bfe5                	j	4e6 <strchr+0x1a>

00000000000004f0 <gets>:

char*
gets(char *buf, int max)
{
 4f0:	711d                	addi	sp,sp,-96
 4f2:	ec86                	sd	ra,88(sp)
 4f4:	e8a2                	sd	s0,80(sp)
 4f6:	e4a6                	sd	s1,72(sp)
 4f8:	e0ca                	sd	s2,64(sp)
 4fa:	fc4e                	sd	s3,56(sp)
 4fc:	f852                	sd	s4,48(sp)
 4fe:	f456                	sd	s5,40(sp)
 500:	f05a                	sd	s6,32(sp)
 502:	ec5e                	sd	s7,24(sp)
 504:	1080                	addi	s0,sp,96
 506:	8baa                	mv	s7,a0
 508:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 50a:	892a                	mv	s2,a0
 50c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 50e:	4aa9                	li	s5,10
 510:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 512:	89a6                	mv	s3,s1
 514:	2485                	addiw	s1,s1,1
 516:	0344d863          	bge	s1,s4,546 <gets+0x56>
    cc = read(0, &c, 1);
 51a:	4605                	li	a2,1
 51c:	faf40593          	addi	a1,s0,-81
 520:	4501                	li	a0,0
 522:	00000097          	auipc	ra,0x0
 526:	11c080e7          	jalr	284(ra) # 63e <read>
    if(cc < 1)
 52a:	00a05e63          	blez	a0,546 <gets+0x56>
    buf[i++] = c;
 52e:	faf44783          	lbu	a5,-81(s0)
 532:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 536:	01578763          	beq	a5,s5,544 <gets+0x54>
 53a:	0905                	addi	s2,s2,1
 53c:	fd679be3          	bne	a5,s6,512 <gets+0x22>
  for(i=0; i+1 < max; ){
 540:	89a6                	mv	s3,s1
 542:	a011                	j	546 <gets+0x56>
 544:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 546:	99de                	add	s3,s3,s7
 548:	00098023          	sb	zero,0(s3)
  return buf;
}
 54c:	855e                	mv	a0,s7
 54e:	60e6                	ld	ra,88(sp)
 550:	6446                	ld	s0,80(sp)
 552:	64a6                	ld	s1,72(sp)
 554:	6906                	ld	s2,64(sp)
 556:	79e2                	ld	s3,56(sp)
 558:	7a42                	ld	s4,48(sp)
 55a:	7aa2                	ld	s5,40(sp)
 55c:	7b02                	ld	s6,32(sp)
 55e:	6be2                	ld	s7,24(sp)
 560:	6125                	addi	sp,sp,96
 562:	8082                	ret

0000000000000564 <stat>:

int
stat(const char *n, struct stat *st)
{
 564:	1101                	addi	sp,sp,-32
 566:	ec06                	sd	ra,24(sp)
 568:	e822                	sd	s0,16(sp)
 56a:	e426                	sd	s1,8(sp)
 56c:	e04a                	sd	s2,0(sp)
 56e:	1000                	addi	s0,sp,32
 570:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 572:	4581                	li	a1,0
 574:	00000097          	auipc	ra,0x0
 578:	0f2080e7          	jalr	242(ra) # 666 <open>
  if(fd < 0)
 57c:	02054563          	bltz	a0,5a6 <stat+0x42>
 580:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 582:	85ca                	mv	a1,s2
 584:	00000097          	auipc	ra,0x0
 588:	0fa080e7          	jalr	250(ra) # 67e <fstat>
 58c:	892a                	mv	s2,a0
  close(fd);
 58e:	8526                	mv	a0,s1
 590:	00000097          	auipc	ra,0x0
 594:	0be080e7          	jalr	190(ra) # 64e <close>
  return r;
}
 598:	854a                	mv	a0,s2
 59a:	60e2                	ld	ra,24(sp)
 59c:	6442                	ld	s0,16(sp)
 59e:	64a2                	ld	s1,8(sp)
 5a0:	6902                	ld	s2,0(sp)
 5a2:	6105                	addi	sp,sp,32
 5a4:	8082                	ret
    return -1;
 5a6:	597d                	li	s2,-1
 5a8:	bfc5                	j	598 <stat+0x34>

00000000000005aa <atoi>:

int
atoi(const char *s)
{
 5aa:	1141                	addi	sp,sp,-16
 5ac:	e422                	sd	s0,8(sp)
 5ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5b0:	00054603          	lbu	a2,0(a0)
 5b4:	fd06079b          	addiw	a5,a2,-48
 5b8:	0ff7f793          	andi	a5,a5,255
 5bc:	4725                	li	a4,9
 5be:	02f76963          	bltu	a4,a5,5f0 <atoi+0x46>
 5c2:	86aa                	mv	a3,a0
  n = 0;
 5c4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 5c6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 5c8:	0685                	addi	a3,a3,1
 5ca:	0025179b          	slliw	a5,a0,0x2
 5ce:	9fa9                	addw	a5,a5,a0
 5d0:	0017979b          	slliw	a5,a5,0x1
 5d4:	9fb1                	addw	a5,a5,a2
 5d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5da:	0006c603          	lbu	a2,0(a3)
 5de:	fd06071b          	addiw	a4,a2,-48
 5e2:	0ff77713          	andi	a4,a4,255
 5e6:	fee5f1e3          	bgeu	a1,a4,5c8 <atoi+0x1e>
  return n;
}
 5ea:	6422                	ld	s0,8(sp)
 5ec:	0141                	addi	sp,sp,16
 5ee:	8082                	ret
  n = 0;
 5f0:	4501                	li	a0,0
 5f2:	bfe5                	j	5ea <atoi+0x40>

00000000000005f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5f4:	1141                	addi	sp,sp,-16
 5f6:	e422                	sd	s0,8(sp)
 5f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5fa:	00c05f63          	blez	a2,618 <memmove+0x24>
 5fe:	1602                	slli	a2,a2,0x20
 600:	9201                	srli	a2,a2,0x20
 602:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 606:	87aa                	mv	a5,a0
    *dst++ = *src++;
 608:	0585                	addi	a1,a1,1
 60a:	0785                	addi	a5,a5,1
 60c:	fff5c703          	lbu	a4,-1(a1)
 610:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 614:	fed79ae3          	bne	a5,a3,608 <memmove+0x14>
  return vdst;
}
 618:	6422                	ld	s0,8(sp)
 61a:	0141                	addi	sp,sp,16
 61c:	8082                	ret

000000000000061e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 61e:	4885                	li	a7,1
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <exit>:
.global exit
exit:
 li a7, SYS_exit
 626:	4889                	li	a7,2
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <wait>:
.global wait
wait:
 li a7, SYS_wait
 62e:	488d                	li	a7,3
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 636:	4891                	li	a7,4
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <read>:
.global read
read:
 li a7, SYS_read
 63e:	4895                	li	a7,5
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <write>:
.global write
write:
 li a7, SYS_write
 646:	48c1                	li	a7,16
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <close>:
.global close
close:
 li a7, SYS_close
 64e:	48d5                	li	a7,21
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <kill>:
.global kill
kill:
 li a7, SYS_kill
 656:	4899                	li	a7,6
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <exec>:
.global exec
exec:
 li a7, SYS_exec
 65e:	489d                	li	a7,7
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <open>:
.global open
open:
 li a7, SYS_open
 666:	48bd                	li	a7,15
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 66e:	48c5                	li	a7,17
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 676:	48c9                	li	a7,18
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 67e:	48a1                	li	a7,8
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <link>:
.global link
link:
 li a7, SYS_link
 686:	48cd                	li	a7,19
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 68e:	48d1                	li	a7,20
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 696:	48a5                	li	a7,9
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <dup>:
.global dup
dup:
 li a7, SYS_dup
 69e:	48a9                	li	a7,10
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6a6:	48ad                	li	a7,11
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6ae:	48b1                	li	a7,12
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6b6:	48b5                	li	a7,13
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6be:	48b9                	li	a7,14
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 6c6:	48d9                	li	a7,22
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <crash>:
.global crash
crash:
 li a7, SYS_crash
 6ce:	48dd                	li	a7,23
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <mount>:
.global mount
mount:
 li a7, SYS_mount
 6d6:	48e1                	li	a7,24
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <umount>:
.global umount
umount:
 li a7, SYS_umount
 6de:	48e5                	li	a7,25
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e6:	1101                	addi	sp,sp,-32
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6f2:	4605                	li	a2,1
 6f4:	fef40593          	addi	a1,s0,-17
 6f8:	00000097          	auipc	ra,0x0
 6fc:	f4e080e7          	jalr	-178(ra) # 646 <write>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6105                	addi	sp,sp,32
 706:	8082                	ret

0000000000000708 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 708:	7139                	addi	sp,sp,-64
 70a:	fc06                	sd	ra,56(sp)
 70c:	f822                	sd	s0,48(sp)
 70e:	f426                	sd	s1,40(sp)
 710:	f04a                	sd	s2,32(sp)
 712:	ec4e                	sd	s3,24(sp)
 714:	0080                	addi	s0,sp,64
 716:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 718:	c299                	beqz	a3,71e <printint+0x16>
 71a:	0805c863          	bltz	a1,7aa <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 71e:	2581                	sext.w	a1,a1
  neg = 0;
 720:	4881                	li	a7,0
 722:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 726:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 728:	2601                	sext.w	a2,a2
 72a:	00000517          	auipc	a0,0x0
 72e:	47650513          	addi	a0,a0,1142 # ba0 <digits>
 732:	883a                	mv	a6,a4
 734:	2705                	addiw	a4,a4,1
 736:	02c5f7bb          	remuw	a5,a1,a2
 73a:	1782                	slli	a5,a5,0x20
 73c:	9381                	srli	a5,a5,0x20
 73e:	97aa                	add	a5,a5,a0
 740:	0007c783          	lbu	a5,0(a5)
 744:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 748:	0005879b          	sext.w	a5,a1
 74c:	02c5d5bb          	divuw	a1,a1,a2
 750:	0685                	addi	a3,a3,1
 752:	fec7f0e3          	bgeu	a5,a2,732 <printint+0x2a>
  if(neg)
 756:	00088b63          	beqz	a7,76c <printint+0x64>
    buf[i++] = '-';
 75a:	fd040793          	addi	a5,s0,-48
 75e:	973e                	add	a4,a4,a5
 760:	02d00793          	li	a5,45
 764:	fef70823          	sb	a5,-16(a4)
 768:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 76c:	02e05863          	blez	a4,79c <printint+0x94>
 770:	fc040793          	addi	a5,s0,-64
 774:	00e78933          	add	s2,a5,a4
 778:	fff78993          	addi	s3,a5,-1
 77c:	99ba                	add	s3,s3,a4
 77e:	377d                	addiw	a4,a4,-1
 780:	1702                	slli	a4,a4,0x20
 782:	9301                	srli	a4,a4,0x20
 784:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 788:	fff94583          	lbu	a1,-1(s2)
 78c:	8526                	mv	a0,s1
 78e:	00000097          	auipc	ra,0x0
 792:	f58080e7          	jalr	-168(ra) # 6e6 <putc>
  while(--i >= 0)
 796:	197d                	addi	s2,s2,-1
 798:	ff3918e3          	bne	s2,s3,788 <printint+0x80>
}
 79c:	70e2                	ld	ra,56(sp)
 79e:	7442                	ld	s0,48(sp)
 7a0:	74a2                	ld	s1,40(sp)
 7a2:	7902                	ld	s2,32(sp)
 7a4:	69e2                	ld	s3,24(sp)
 7a6:	6121                	addi	sp,sp,64
 7a8:	8082                	ret
    x = -xx;
 7aa:	40b005bb          	negw	a1,a1
    neg = 1;
 7ae:	4885                	li	a7,1
    x = -xx;
 7b0:	bf8d                	j	722 <printint+0x1a>

00000000000007b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b2:	7119                	addi	sp,sp,-128
 7b4:	fc86                	sd	ra,120(sp)
 7b6:	f8a2                	sd	s0,112(sp)
 7b8:	f4a6                	sd	s1,104(sp)
 7ba:	f0ca                	sd	s2,96(sp)
 7bc:	ecce                	sd	s3,88(sp)
 7be:	e8d2                	sd	s4,80(sp)
 7c0:	e4d6                	sd	s5,72(sp)
 7c2:	e0da                	sd	s6,64(sp)
 7c4:	fc5e                	sd	s7,56(sp)
 7c6:	f862                	sd	s8,48(sp)
 7c8:	f466                	sd	s9,40(sp)
 7ca:	f06a                	sd	s10,32(sp)
 7cc:	ec6e                	sd	s11,24(sp)
 7ce:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d0:	0005c903          	lbu	s2,0(a1)
 7d4:	18090f63          	beqz	s2,972 <vprintf+0x1c0>
 7d8:	8aaa                	mv	s5,a0
 7da:	8b32                	mv	s6,a2
 7dc:	00158493          	addi	s1,a1,1
  state = 0;
 7e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e2:	02500a13          	li	s4,37
      if(c == 'd'){
 7e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7ea:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7ee:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7f2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f6:	00000b97          	auipc	s7,0x0
 7fa:	3aab8b93          	addi	s7,s7,938 # ba0 <digits>
 7fe:	a839                	j	81c <vprintf+0x6a>
        putc(fd, c);
 800:	85ca                	mv	a1,s2
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	ee2080e7          	jalr	-286(ra) # 6e6 <putc>
 80c:	a019                	j	812 <vprintf+0x60>
    } else if(state == '%'){
 80e:	01498f63          	beq	s3,s4,82c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 812:	0485                	addi	s1,s1,1
 814:	fff4c903          	lbu	s2,-1(s1)
 818:	14090d63          	beqz	s2,972 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 81c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 820:	fe0997e3          	bnez	s3,80e <vprintf+0x5c>
      if(c == '%'){
 824:	fd479ee3          	bne	a5,s4,800 <vprintf+0x4e>
        state = '%';
 828:	89be                	mv	s3,a5
 82a:	b7e5                	j	812 <vprintf+0x60>
      if(c == 'd'){
 82c:	05878063          	beq	a5,s8,86c <vprintf+0xba>
      } else if(c == 'l') {
 830:	05978c63          	beq	a5,s9,888 <vprintf+0xd6>
      } else if(c == 'x') {
 834:	07a78863          	beq	a5,s10,8a4 <vprintf+0xf2>
      } else if(c == 'p') {
 838:	09b78463          	beq	a5,s11,8c0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 83c:	07300713          	li	a4,115
 840:	0ce78663          	beq	a5,a4,90c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 844:	06300713          	li	a4,99
 848:	0ee78e63          	beq	a5,a4,944 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 84c:	11478863          	beq	a5,s4,95c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 850:	85d2                	mv	a1,s4
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	e92080e7          	jalr	-366(ra) # 6e6 <putc>
        putc(fd, c);
 85c:	85ca                	mv	a1,s2
 85e:	8556                	mv	a0,s5
 860:	00000097          	auipc	ra,0x0
 864:	e86080e7          	jalr	-378(ra) # 6e6 <putc>
      }
      state = 0;
 868:	4981                	li	s3,0
 86a:	b765                	j	812 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 86c:	008b0913          	addi	s2,s6,8
 870:	4685                	li	a3,1
 872:	4629                	li	a2,10
 874:	000b2583          	lw	a1,0(s6)
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	e8e080e7          	jalr	-370(ra) # 708 <printint>
 882:	8b4a                	mv	s6,s2
      state = 0;
 884:	4981                	li	s3,0
 886:	b771                	j	812 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 888:	008b0913          	addi	s2,s6,8
 88c:	4681                	li	a3,0
 88e:	4629                	li	a2,10
 890:	000b2583          	lw	a1,0(s6)
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	e72080e7          	jalr	-398(ra) # 708 <printint>
 89e:	8b4a                	mv	s6,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bf85                	j	812 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8a4:	008b0913          	addi	s2,s6,8
 8a8:	4681                	li	a3,0
 8aa:	4641                	li	a2,16
 8ac:	000b2583          	lw	a1,0(s6)
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	e56080e7          	jalr	-426(ra) # 708 <printint>
 8ba:	8b4a                	mv	s6,s2
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	bf91                	j	812 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8c0:	008b0793          	addi	a5,s6,8
 8c4:	f8f43423          	sd	a5,-120(s0)
 8c8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8cc:	03000593          	li	a1,48
 8d0:	8556                	mv	a0,s5
 8d2:	00000097          	auipc	ra,0x0
 8d6:	e14080e7          	jalr	-492(ra) # 6e6 <putc>
  putc(fd, 'x');
 8da:	85ea                	mv	a1,s10
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	e08080e7          	jalr	-504(ra) # 6e6 <putc>
 8e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e8:	03c9d793          	srli	a5,s3,0x3c
 8ec:	97de                	add	a5,a5,s7
 8ee:	0007c583          	lbu	a1,0(a5)
 8f2:	8556                	mv	a0,s5
 8f4:	00000097          	auipc	ra,0x0
 8f8:	df2080e7          	jalr	-526(ra) # 6e6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8fc:	0992                	slli	s3,s3,0x4
 8fe:	397d                	addiw	s2,s2,-1
 900:	fe0914e3          	bnez	s2,8e8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 904:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 908:	4981                	li	s3,0
 90a:	b721                	j	812 <vprintf+0x60>
        s = va_arg(ap, char*);
 90c:	008b0993          	addi	s3,s6,8
 910:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 914:	02090163          	beqz	s2,936 <vprintf+0x184>
        while(*s != 0){
 918:	00094583          	lbu	a1,0(s2)
 91c:	c9a1                	beqz	a1,96c <vprintf+0x1ba>
          putc(fd, *s);
 91e:	8556                	mv	a0,s5
 920:	00000097          	auipc	ra,0x0
 924:	dc6080e7          	jalr	-570(ra) # 6e6 <putc>
          s++;
 928:	0905                	addi	s2,s2,1
        while(*s != 0){
 92a:	00094583          	lbu	a1,0(s2)
 92e:	f9e5                	bnez	a1,91e <vprintf+0x16c>
        s = va_arg(ap, char*);
 930:	8b4e                	mv	s6,s3
      state = 0;
 932:	4981                	li	s3,0
 934:	bdf9                	j	812 <vprintf+0x60>
          s = "(null)";
 936:	00000917          	auipc	s2,0x0
 93a:	26290913          	addi	s2,s2,610 # b98 <malloc+0x11c>
        while(*s != 0){
 93e:	02800593          	li	a1,40
 942:	bff1                	j	91e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 944:	008b0913          	addi	s2,s6,8
 948:	000b4583          	lbu	a1,0(s6)
 94c:	8556                	mv	a0,s5
 94e:	00000097          	auipc	ra,0x0
 952:	d98080e7          	jalr	-616(ra) # 6e6 <putc>
 956:	8b4a                	mv	s6,s2
      state = 0;
 958:	4981                	li	s3,0
 95a:	bd65                	j	812 <vprintf+0x60>
        putc(fd, c);
 95c:	85d2                	mv	a1,s4
 95e:	8556                	mv	a0,s5
 960:	00000097          	auipc	ra,0x0
 964:	d86080e7          	jalr	-634(ra) # 6e6 <putc>
      state = 0;
 968:	4981                	li	s3,0
 96a:	b565                	j	812 <vprintf+0x60>
        s = va_arg(ap, char*);
 96c:	8b4e                	mv	s6,s3
      state = 0;
 96e:	4981                	li	s3,0
 970:	b54d                	j	812 <vprintf+0x60>
    }
  }
}
 972:	70e6                	ld	ra,120(sp)
 974:	7446                	ld	s0,112(sp)
 976:	74a6                	ld	s1,104(sp)
 978:	7906                	ld	s2,96(sp)
 97a:	69e6                	ld	s3,88(sp)
 97c:	6a46                	ld	s4,80(sp)
 97e:	6aa6                	ld	s5,72(sp)
 980:	6b06                	ld	s6,64(sp)
 982:	7be2                	ld	s7,56(sp)
 984:	7c42                	ld	s8,48(sp)
 986:	7ca2                	ld	s9,40(sp)
 988:	7d02                	ld	s10,32(sp)
 98a:	6de2                	ld	s11,24(sp)
 98c:	6109                	addi	sp,sp,128
 98e:	8082                	ret

0000000000000990 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 990:	715d                	addi	sp,sp,-80
 992:	ec06                	sd	ra,24(sp)
 994:	e822                	sd	s0,16(sp)
 996:	1000                	addi	s0,sp,32
 998:	e010                	sd	a2,0(s0)
 99a:	e414                	sd	a3,8(s0)
 99c:	e818                	sd	a4,16(s0)
 99e:	ec1c                	sd	a5,24(s0)
 9a0:	03043023          	sd	a6,32(s0)
 9a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ac:	8622                	mv	a2,s0
 9ae:	00000097          	auipc	ra,0x0
 9b2:	e04080e7          	jalr	-508(ra) # 7b2 <vprintf>
}
 9b6:	60e2                	ld	ra,24(sp)
 9b8:	6442                	ld	s0,16(sp)
 9ba:	6161                	addi	sp,sp,80
 9bc:	8082                	ret

00000000000009be <printf>:

void
printf(const char *fmt, ...)
{
 9be:	711d                	addi	sp,sp,-96
 9c0:	ec06                	sd	ra,24(sp)
 9c2:	e822                	sd	s0,16(sp)
 9c4:	1000                	addi	s0,sp,32
 9c6:	e40c                	sd	a1,8(s0)
 9c8:	e810                	sd	a2,16(s0)
 9ca:	ec14                	sd	a3,24(s0)
 9cc:	f018                	sd	a4,32(s0)
 9ce:	f41c                	sd	a5,40(s0)
 9d0:	03043823          	sd	a6,48(s0)
 9d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d8:	00840613          	addi	a2,s0,8
 9dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e0:	85aa                	mv	a1,a0
 9e2:	4505                	li	a0,1
 9e4:	00000097          	auipc	ra,0x0
 9e8:	dce080e7          	jalr	-562(ra) # 7b2 <vprintf>
}
 9ec:	60e2                	ld	ra,24(sp)
 9ee:	6442                	ld	s0,16(sp)
 9f0:	6125                	addi	sp,sp,96
 9f2:	8082                	ret

00000000000009f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f4:	1141                	addi	sp,sp,-16
 9f6:	e422                	sd	s0,8(sp)
 9f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fe:	00000797          	auipc	a5,0x0
 a02:	1c27b783          	ld	a5,450(a5) # bc0 <freep>
 a06:	a805                	j	a36 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a08:	4618                	lw	a4,8(a2)
 a0a:	9db9                	addw	a1,a1,a4
 a0c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a10:	6398                	ld	a4,0(a5)
 a12:	6318                	ld	a4,0(a4)
 a14:	fee53823          	sd	a4,-16(a0)
 a18:	a091                	j	a5c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a1a:	ff852703          	lw	a4,-8(a0)
 a1e:	9e39                	addw	a2,a2,a4
 a20:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a22:	ff053703          	ld	a4,-16(a0)
 a26:	e398                	sd	a4,0(a5)
 a28:	a099                	j	a6e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	6398                	ld	a4,0(a5)
 a2c:	00e7e463          	bltu	a5,a4,a34 <free+0x40>
 a30:	00e6ea63          	bltu	a3,a4,a44 <free+0x50>
{
 a34:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a36:	fed7fae3          	bgeu	a5,a3,a2a <free+0x36>
 a3a:	6398                	ld	a4,0(a5)
 a3c:	00e6e463          	bltu	a3,a4,a44 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a40:	fee7eae3          	bltu	a5,a4,a34 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a44:	ff852583          	lw	a1,-8(a0)
 a48:	6390                	ld	a2,0(a5)
 a4a:	02059813          	slli	a6,a1,0x20
 a4e:	01c85713          	srli	a4,a6,0x1c
 a52:	9736                	add	a4,a4,a3
 a54:	fae60ae3          	beq	a2,a4,a08 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a58:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a5c:	4790                	lw	a2,8(a5)
 a5e:	02061593          	slli	a1,a2,0x20
 a62:	01c5d713          	srli	a4,a1,0x1c
 a66:	973e                	add	a4,a4,a5
 a68:	fae689e3          	beq	a3,a4,a1a <free+0x26>
  } else
    p->s.ptr = bp;
 a6c:	e394                	sd	a3,0(a5)
  freep = p;
 a6e:	00000717          	auipc	a4,0x0
 a72:	14f73923          	sd	a5,338(a4) # bc0 <freep>
}
 a76:	6422                	ld	s0,8(sp)
 a78:	0141                	addi	sp,sp,16
 a7a:	8082                	ret

0000000000000a7c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a7c:	7139                	addi	sp,sp,-64
 a7e:	fc06                	sd	ra,56(sp)
 a80:	f822                	sd	s0,48(sp)
 a82:	f426                	sd	s1,40(sp)
 a84:	f04a                	sd	s2,32(sp)
 a86:	ec4e                	sd	s3,24(sp)
 a88:	e852                	sd	s4,16(sp)
 a8a:	e456                	sd	s5,8(sp)
 a8c:	e05a                	sd	s6,0(sp)
 a8e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a90:	02051493          	slli	s1,a0,0x20
 a94:	9081                	srli	s1,s1,0x20
 a96:	04bd                	addi	s1,s1,15
 a98:	8091                	srli	s1,s1,0x4
 a9a:	0014899b          	addiw	s3,s1,1
 a9e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 aa0:	00000517          	auipc	a0,0x0
 aa4:	12053503          	ld	a0,288(a0) # bc0 <freep>
 aa8:	c515                	beqz	a0,ad4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aaa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aac:	4798                	lw	a4,8(a5)
 aae:	02977f63          	bgeu	a4,s1,aec <malloc+0x70>
 ab2:	8a4e                	mv	s4,s3
 ab4:	0009871b          	sext.w	a4,s3
 ab8:	6685                	lui	a3,0x1
 aba:	00d77363          	bgeu	a4,a3,ac0 <malloc+0x44>
 abe:	6a05                	lui	s4,0x1
 ac0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac8:	00000917          	auipc	s2,0x0
 acc:	0f890913          	addi	s2,s2,248 # bc0 <freep>
  if(p == (char*)-1)
 ad0:	5afd                	li	s5,-1
 ad2:	a895                	j	b46 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 ad4:	00000797          	auipc	a5,0x0
 ad8:	28c78793          	addi	a5,a5,652 # d60 <base>
 adc:	00000717          	auipc	a4,0x0
 ae0:	0ef73223          	sd	a5,228(a4) # bc0 <freep>
 ae4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ae6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aea:	b7e1                	j	ab2 <malloc+0x36>
      if(p->s.size == nunits)
 aec:	02e48c63          	beq	s1,a4,b24 <malloc+0xa8>
        p->s.size -= nunits;
 af0:	4137073b          	subw	a4,a4,s3
 af4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af6:	02071693          	slli	a3,a4,0x20
 afa:	01c6d713          	srli	a4,a3,0x1c
 afe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b00:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b04:	00000717          	auipc	a4,0x0
 b08:	0aa73e23          	sd	a0,188(a4) # bc0 <freep>
      return (void*)(p + 1);
 b0c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b10:	70e2                	ld	ra,56(sp)
 b12:	7442                	ld	s0,48(sp)
 b14:	74a2                	ld	s1,40(sp)
 b16:	7902                	ld	s2,32(sp)
 b18:	69e2                	ld	s3,24(sp)
 b1a:	6a42                	ld	s4,16(sp)
 b1c:	6aa2                	ld	s5,8(sp)
 b1e:	6b02                	ld	s6,0(sp)
 b20:	6121                	addi	sp,sp,64
 b22:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b24:	6398                	ld	a4,0(a5)
 b26:	e118                	sd	a4,0(a0)
 b28:	bff1                	j	b04 <malloc+0x88>
  hp->s.size = nu;
 b2a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b2e:	0541                	addi	a0,a0,16
 b30:	00000097          	auipc	ra,0x0
 b34:	ec4080e7          	jalr	-316(ra) # 9f4 <free>
  return freep;
 b38:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b3c:	d971                	beqz	a0,b10 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b40:	4798                	lw	a4,8(a5)
 b42:	fa9775e3          	bgeu	a4,s1,aec <malloc+0x70>
    if(p == freep)
 b46:	00093703          	ld	a4,0(s2)
 b4a:	853e                	mv	a0,a5
 b4c:	fef719e3          	bne	a4,a5,b3e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b50:	8552                	mv	a0,s4
 b52:	00000097          	auipc	ra,0x0
 b56:	b5c080e7          	jalr	-1188(ra) # 6ae <sbrk>
  if(p == (char*)-1)
 b5a:	fd5518e3          	bne	a0,s5,b2a <malloc+0xae>
        return 0;
 b5e:	4501                	li	a0,0
 b60:	bf45                	j	b10 <malloc+0x94>
