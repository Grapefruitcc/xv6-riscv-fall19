
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_schedule>:
  current_thread->state = RUNNING;
}

static void 
thread_schedule(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
   8:	00001797          	auipc	a5,0x1
   c:	9c07bc23          	sd	zero,-1576(a5) # 9e0 <next_thread>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == RUNNABLE && t != current_thread) {
  10:	00001817          	auipc	a6,0x1
  14:	9d883803          	ld	a6,-1576(a6) # 9e8 <current_thread>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  18:	00001797          	auipc	a5,0x1
  1c:	9e078793          	addi	a5,a5,-1568 # 9f8 <all_thread>
    if (t->state == RUNNABLE && t != current_thread) {
  20:	6709                	lui	a4,0x2
  22:	00870593          	addi	a1,a4,8 # 2008 <__global_pointer$+0xe2f>
  26:	4609                	li	a2,2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  28:	0741                	addi	a4,a4,16
  2a:	00009517          	auipc	a0,0x9
  2e:	a0e50513          	addi	a0,a0,-1522 # 8a38 <base>
  32:	a021                	j	3a <thread_schedule+0x3a>
  34:	97ba                	add	a5,a5,a4
  36:	08a78163          	beq	a5,a0,b8 <thread_schedule+0xb8>
    if (t->state == RUNNABLE && t != current_thread) {
  3a:	00b786b3          	add	a3,a5,a1
  3e:	4294                	lw	a3,0(a3)
  40:	fec69ae3          	bne	a3,a2,34 <thread_schedule+0x34>
  44:	fef808e3          	beq	a6,a5,34 <thread_schedule+0x34>
       next_thread = t;
  48:	00001717          	auipc	a4,0x1
  4c:	98f73c23          	sd	a5,-1640(a4) # 9e0 <next_thread>
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  50:	00009717          	auipc	a4,0x9
  54:	9e870713          	addi	a4,a4,-1560 # 8a38 <base>
  58:	00e7ef63          	bltu	a5,a4,76 <thread_schedule+0x76>
  5c:	6789                	lui	a5,0x2
  5e:	97c2                	add	a5,a5,a6
  60:	4798                	lw	a4,8(a5)
  62:	4789                	li	a5,2
  64:	06f70163          	beq	a4,a5,c6 <thread_schedule+0xc6>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  }

  if (next_thread == 0) {
  68:	00001797          	auipc	a5,0x1
  6c:	9787b783          	ld	a5,-1672(a5) # 9e0 <next_thread>
  70:	c79d                	beqz	a5,9e <thread_schedule+0x9e>
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  72:	04f80a63          	beq	a6,a5,c6 <thread_schedule+0xc6>
    next_thread->state = RUNNING;
  76:	6709                	lui	a4,0x2
  78:	97ba                	add	a5,a5,a4
  7a:	4705                	li	a4,1
  7c:	c798                	sw	a4,8(a5)
     uthread_switch((uint64) &current_thread, (uint64) &next_thread);
  7e:	00001597          	auipc	a1,0x1
  82:	96258593          	addi	a1,a1,-1694 # 9e0 <next_thread>
  86:	00001517          	auipc	a0,0x1
  8a:	96250513          	addi	a0,a0,-1694 # 9e8 <current_thread>
  8e:	00000097          	auipc	ra,0x0
  92:	19e080e7          	jalr	414(ra) # 22c <strcpy>
  } else
    next_thread = 0;
}
  96:	60a2                	ld	ra,8(sp)
  98:	6402                	ld	s0,0(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
    printf("thread_schedule: no runnable threads\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	8ba50513          	addi	a0,a0,-1862 # 958 <malloc+0xe8>
  a6:	00000097          	auipc	ra,0x0
  aa:	70c080e7          	jalr	1804(ra) # 7b2 <printf>
    exit(-1);
  ae:	557d                	li	a0,-1
  b0:	00000097          	auipc	ra,0x0
  b4:	36a080e7          	jalr	874(ra) # 41a <exit>
  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  b8:	6789                	lui	a5,0x2
  ba:	983e                	add	a6,a6,a5
  bc:	00882703          	lw	a4,8(a6)
  c0:	4789                	li	a5,2
  c2:	fcf71ee3          	bne	a4,a5,9e <thread_schedule+0x9e>
    next_thread = 0;
  c6:	00001797          	auipc	a5,0x1
  ca:	9007bd23          	sd	zero,-1766(a5) # 9e0 <next_thread>
}
  ce:	b7e1                	j	96 <thread_schedule+0x96>

00000000000000d0 <thread_init>:
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  current_thread = &all_thread[0];
  d6:	00001797          	auipc	a5,0x1
  da:	92278793          	addi	a5,a5,-1758 # 9f8 <all_thread>
  de:	00001717          	auipc	a4,0x1
  e2:	90f73523          	sd	a5,-1782(a4) # 9e8 <current_thread>
  current_thread->state = RUNNING;
  e6:	4785                	li	a5,1
  e8:	00003717          	auipc	a4,0x3
  ec:	90f72c23          	sw	a5,-1768(a4) # 2a00 <__global_pointer$+0x1827>
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <thread_create>:

void 
thread_create(void (*func)())
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  fc:	00001797          	auipc	a5,0x1
 100:	8fc78793          	addi	a5,a5,-1796 # 9f8 <all_thread>
    if (t->state == FREE) break;
 104:	6709                	lui	a4,0x2
 106:	00870613          	addi	a2,a4,8 # 2008 <__global_pointer$+0xe2f>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 10a:	0741                	addi	a4,a4,16
 10c:	00009597          	auipc	a1,0x9
 110:	92c58593          	addi	a1,a1,-1748 # 8a38 <base>
    if (t->state == FREE) break;
 114:	00c786b3          	add	a3,a5,a2
 118:	4294                	lw	a3,0(a3)
 11a:	c681                	beqz	a3,122 <thread_create+0x2c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 11c:	97ba                	add	a5,a5,a4
 11e:	feb79be3          	bne	a5,a1,114 <thread_create+0x1e>
  }
  t->sp = (uint64) (t->stack + STACK_SIZE);// set sp to the top of the stack
 122:	6689                	lui	a3,0x2
 124:	00868713          	addi	a4,a3,8 # 2008 <__global_pointer$+0xe2f>
 128:	973e                	add	a4,a4,a5
  t->sp -= 104;                            // space for registers that uthread_switch expects
 12a:	f9870613          	addi	a2,a4,-104
 12e:	e390                	sd	a2,0(a5)
  * (uint64 *) (t->sp) = (uint64)func;     // push return address on stack
 130:	f8a73c23          	sd	a0,-104(a4)
  t->state = RUNNABLE;
 134:	97b6                	add	a5,a5,a3
 136:	4709                	li	a4,2
 138:	c798                	sw	a4,8(a5)
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <thread_yield>:

void 
thread_yield(void)
{
 140:	1141                	addi	sp,sp,-16
 142:	e406                	sd	ra,8(sp)
 144:	e022                	sd	s0,0(sp)
 146:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 148:	00001797          	auipc	a5,0x1
 14c:	8a07b783          	ld	a5,-1888(a5) # 9e8 <current_thread>
 150:	6709                	lui	a4,0x2
 152:	97ba                	add	a5,a5,a4
 154:	4709                	li	a4,2
 156:	c798                	sw	a4,8(a5)
  thread_schedule();
 158:	00000097          	auipc	ra,0x0
 15c:	ea8080e7          	jalr	-344(ra) # 0 <thread_schedule>
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <mythread>:

static void 
mythread(void)
{
 168:	7179                	addi	sp,sp,-48
 16a:	f406                	sd	ra,40(sp)
 16c:	f022                	sd	s0,32(sp)
 16e:	ec26                	sd	s1,24(sp)
 170:	e84a                	sd	s2,16(sp)
 172:	e44e                	sd	s3,8(sp)
 174:	1800                	addi	s0,sp,48
  int i;
  printf("my thread running\n");
 176:	00001517          	auipc	a0,0x1
 17a:	80a50513          	addi	a0,a0,-2038 # 980 <malloc+0x110>
 17e:	00000097          	auipc	ra,0x0
 182:	634080e7          	jalr	1588(ra) # 7b2 <printf>
 186:	06400493          	li	s1,100
  for (i = 0; i < 100; i++) {
    printf("my thread %p\n", (uint64) current_thread);
 18a:	00001997          	auipc	s3,0x1
 18e:	85e98993          	addi	s3,s3,-1954 # 9e8 <current_thread>
 192:	00001917          	auipc	s2,0x1
 196:	80690913          	addi	s2,s2,-2042 # 998 <malloc+0x128>
 19a:	0009b583          	ld	a1,0(s3)
 19e:	854a                	mv	a0,s2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	612080e7          	jalr	1554(ra) # 7b2 <printf>
    thread_yield();
 1a8:	00000097          	auipc	ra,0x0
 1ac:	f98080e7          	jalr	-104(ra) # 140 <thread_yield>
  for (i = 0; i < 100; i++) {
 1b0:	34fd                	addiw	s1,s1,-1
 1b2:	f4e5                	bnez	s1,19a <mythread+0x32>
  }
  printf("my thread: exit\n");
 1b4:	00000517          	auipc	a0,0x0
 1b8:	7f450513          	addi	a0,a0,2036 # 9a8 <malloc+0x138>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	5f6080e7          	jalr	1526(ra) # 7b2 <printf>
  current_thread->state = FREE;
 1c4:	00001797          	auipc	a5,0x1
 1c8:	8247b783          	ld	a5,-2012(a5) # 9e8 <current_thread>
 1cc:	6709                	lui	a4,0x2
 1ce:	97ba                	add	a5,a5,a4
 1d0:	0007a423          	sw	zero,8(a5)
  thread_schedule();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e2c080e7          	jalr	-468(ra) # 0 <thread_schedule>
}
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6145                	addi	sp,sp,48
 1e8:	8082                	ret

00000000000001ea <main>:


int 
main(int argc, char *argv[]) 
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  thread_init();
 1f2:	00000097          	auipc	ra,0x0
 1f6:	ede080e7          	jalr	-290(ra) # d0 <thread_init>
  thread_create(mythread);
 1fa:	00000517          	auipc	a0,0x0
 1fe:	f6e50513          	addi	a0,a0,-146 # 168 <mythread>
 202:	00000097          	auipc	ra,0x0
 206:	ef4080e7          	jalr	-268(ra) # f6 <thread_create>
  thread_create(mythread);
 20a:	00000517          	auipc	a0,0x0
 20e:	f5e50513          	addi	a0,a0,-162 # 168 <mythread>
 212:	00000097          	auipc	ra,0x0
 216:	ee4080e7          	jalr	-284(ra) # f6 <thread_create>
  thread_schedule();
 21a:	00000097          	auipc	ra,0x0
 21e:	de6080e7          	jalr	-538(ra) # 0 <thread_schedule>
  exit(0);
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	1f6080e7          	jalr	502(ra) # 41a <exit>

000000000000022c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 232:	87aa                	mv	a5,a0
 234:	0585                	addi	a1,a1,1
 236:	0785                	addi	a5,a5,1
 238:	fff5c703          	lbu	a4,-1(a1)
 23c:	fee78fa3          	sb	a4,-1(a5)
 240:	fb75                	bnez	a4,234 <strcpy+0x8>
    ;
  return os;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret

0000000000000248 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 24e:	00054783          	lbu	a5,0(a0)
 252:	cb91                	beqz	a5,266 <strcmp+0x1e>
 254:	0005c703          	lbu	a4,0(a1)
 258:	00f71763          	bne	a4,a5,266 <strcmp+0x1e>
    p++, q++;
 25c:	0505                	addi	a0,a0,1
 25e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 260:	00054783          	lbu	a5,0(a0)
 264:	fbe5                	bnez	a5,254 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 266:	0005c503          	lbu	a0,0(a1)
}
 26a:	40a7853b          	subw	a0,a5,a0
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret

0000000000000274 <strlen>:

uint
strlen(const char *s)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cf91                	beqz	a5,29a <strlen+0x26>
 280:	0505                	addi	a0,a0,1
 282:	87aa                	mv	a5,a0
 284:	4685                	li	a3,1
 286:	9e89                	subw	a3,a3,a0
 288:	00f6853b          	addw	a0,a3,a5
 28c:	0785                	addi	a5,a5,1
 28e:	fff7c703          	lbu	a4,-1(a5)
 292:	fb7d                	bnez	a4,288 <strlen+0x14>
    ;
  return n;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  for(n = 0; s[n]; n++)
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <strlen+0x20>

000000000000029e <memset>:

void*
memset(void *dst, int c, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2a4:	ca19                	beqz	a2,2ba <memset+0x1c>
 2a6:	87aa                	mv	a5,a0
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2b4:	0785                	addi	a5,a5,1
 2b6:	fee79de3          	bne	a5,a4,2b0 <memset+0x12>
  }
  return dst;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	cb99                	beqz	a5,2e0 <strchr+0x20>
    if(*s == c)
 2cc:	00f58763          	beq	a1,a5,2da <strchr+0x1a>
  for(; *s; s++)
 2d0:	0505                	addi	a0,a0,1
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	fbfd                	bnez	a5,2cc <strchr+0xc>
      return (char*)s;
  return 0;
 2d8:	4501                	li	a0,0
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <strchr+0x1a>

00000000000002e4 <gets>:

char*
gets(char *buf, int max)
{
 2e4:	711d                	addi	sp,sp,-96
 2e6:	ec86                	sd	ra,88(sp)
 2e8:	e8a2                	sd	s0,80(sp)
 2ea:	e4a6                	sd	s1,72(sp)
 2ec:	e0ca                	sd	s2,64(sp)
 2ee:	fc4e                	sd	s3,56(sp)
 2f0:	f852                	sd	s4,48(sp)
 2f2:	f456                	sd	s5,40(sp)
 2f4:	f05a                	sd	s6,32(sp)
 2f6:	ec5e                	sd	s7,24(sp)
 2f8:	1080                	addi	s0,sp,96
 2fa:	8baa                	mv	s7,a0
 2fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fe:	892a                	mv	s2,a0
 300:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 302:	4aa9                	li	s5,10
 304:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 306:	89a6                	mv	s3,s1
 308:	2485                	addiw	s1,s1,1
 30a:	0344d863          	bge	s1,s4,33a <gets+0x56>
    cc = read(0, &c, 1);
 30e:	4605                	li	a2,1
 310:	faf40593          	addi	a1,s0,-81
 314:	4501                	li	a0,0
 316:	00000097          	auipc	ra,0x0
 31a:	11c080e7          	jalr	284(ra) # 432 <read>
    if(cc < 1)
 31e:	00a05e63          	blez	a0,33a <gets+0x56>
    buf[i++] = c;
 322:	faf44783          	lbu	a5,-81(s0)
 326:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 32a:	01578763          	beq	a5,s5,338 <gets+0x54>
 32e:	0905                	addi	s2,s2,1
 330:	fd679be3          	bne	a5,s6,306 <gets+0x22>
  for(i=0; i+1 < max; ){
 334:	89a6                	mv	s3,s1
 336:	a011                	j	33a <gets+0x56>
 338:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 33a:	99de                	add	s3,s3,s7
 33c:	00098023          	sb	zero,0(s3)
  return buf;
}
 340:	855e                	mv	a0,s7
 342:	60e6                	ld	ra,88(sp)
 344:	6446                	ld	s0,80(sp)
 346:	64a6                	ld	s1,72(sp)
 348:	6906                	ld	s2,64(sp)
 34a:	79e2                	ld	s3,56(sp)
 34c:	7a42                	ld	s4,48(sp)
 34e:	7aa2                	ld	s5,40(sp)
 350:	7b02                	ld	s6,32(sp)
 352:	6be2                	ld	s7,24(sp)
 354:	6125                	addi	sp,sp,96
 356:	8082                	ret

0000000000000358 <stat>:

int
stat(const char *n, struct stat *st)
{
 358:	1101                	addi	sp,sp,-32
 35a:	ec06                	sd	ra,24(sp)
 35c:	e822                	sd	s0,16(sp)
 35e:	e426                	sd	s1,8(sp)
 360:	e04a                	sd	s2,0(sp)
 362:	1000                	addi	s0,sp,32
 364:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 366:	4581                	li	a1,0
 368:	00000097          	auipc	ra,0x0
 36c:	0f2080e7          	jalr	242(ra) # 45a <open>
  if(fd < 0)
 370:	02054563          	bltz	a0,39a <stat+0x42>
 374:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 376:	85ca                	mv	a1,s2
 378:	00000097          	auipc	ra,0x0
 37c:	0fa080e7          	jalr	250(ra) # 472 <fstat>
 380:	892a                	mv	s2,a0
  close(fd);
 382:	8526                	mv	a0,s1
 384:	00000097          	auipc	ra,0x0
 388:	0be080e7          	jalr	190(ra) # 442 <close>
  return r;
}
 38c:	854a                	mv	a0,s2
 38e:	60e2                	ld	ra,24(sp)
 390:	6442                	ld	s0,16(sp)
 392:	64a2                	ld	s1,8(sp)
 394:	6902                	ld	s2,0(sp)
 396:	6105                	addi	sp,sp,32
 398:	8082                	ret
    return -1;
 39a:	597d                	li	s2,-1
 39c:	bfc5                	j	38c <stat+0x34>

000000000000039e <atoi>:

int
atoi(const char *s)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e422                	sd	s0,8(sp)
 3a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a4:	00054603          	lbu	a2,0(a0)
 3a8:	fd06079b          	addiw	a5,a2,-48
 3ac:	0ff7f793          	andi	a5,a5,255
 3b0:	4725                	li	a4,9
 3b2:	02f76963          	bltu	a4,a5,3e4 <atoi+0x46>
 3b6:	86aa                	mv	a3,a0
  n = 0;
 3b8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3ba:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3bc:	0685                	addi	a3,a3,1
 3be:	0025179b          	slliw	a5,a0,0x2
 3c2:	9fa9                	addw	a5,a5,a0
 3c4:	0017979b          	slliw	a5,a5,0x1
 3c8:	9fb1                	addw	a5,a5,a2
 3ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ce:	0006c603          	lbu	a2,0(a3)
 3d2:	fd06071b          	addiw	a4,a2,-48
 3d6:	0ff77713          	andi	a4,a4,255
 3da:	fee5f1e3          	bgeu	a1,a4,3bc <atoi+0x1e>
  return n;
}
 3de:	6422                	ld	s0,8(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret
  n = 0;
 3e4:	4501                	li	a0,0
 3e6:	bfe5                	j	3de <atoi+0x40>

00000000000003e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ee:	00c05f63          	blez	a2,40c <memmove+0x24>
 3f2:	1602                	slli	a2,a2,0x20
 3f4:	9201                	srli	a2,a2,0x20
 3f6:	00c506b3          	add	a3,a0,a2
  dst = vdst;
 3fa:	87aa                	mv	a5,a0
    *dst++ = *src++;
 3fc:	0585                	addi	a1,a1,1
 3fe:	0785                	addi	a5,a5,1
 400:	fff5c703          	lbu	a4,-1(a1)
 404:	fee78fa3          	sb	a4,-1(a5)
  while(n-- > 0)
 408:	fed79ae3          	bne	a5,a3,3fc <memmove+0x14>
  return vdst;
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret

0000000000000412 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 412:	4885                	li	a7,1
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <exit>:
.global exit
exit:
 li a7, SYS_exit
 41a:	4889                	li	a7,2
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <wait>:
.global wait
wait:
 li a7, SYS_wait
 422:	488d                	li	a7,3
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 42a:	4891                	li	a7,4
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <read>:
.global read
read:
 li a7, SYS_read
 432:	4895                	li	a7,5
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <write>:
.global write
write:
 li a7, SYS_write
 43a:	48c1                	li	a7,16
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <close>:
.global close
close:
 li a7, SYS_close
 442:	48d5                	li	a7,21
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <kill>:
.global kill
kill:
 li a7, SYS_kill
 44a:	4899                	li	a7,6
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <exec>:
.global exec
exec:
 li a7, SYS_exec
 452:	489d                	li	a7,7
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <open>:
.global open
open:
 li a7, SYS_open
 45a:	48bd                	li	a7,15
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 462:	48c5                	li	a7,17
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 46a:	48c9                	li	a7,18
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 472:	48a1                	li	a7,8
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <link>:
.global link
link:
 li a7, SYS_link
 47a:	48cd                	li	a7,19
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 482:	48d1                	li	a7,20
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 48a:	48a5                	li	a7,9
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <dup>:
.global dup
dup:
 li a7, SYS_dup
 492:	48a9                	li	a7,10
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 49a:	48ad                	li	a7,11
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a2:	48b1                	li	a7,12
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4aa:	48b5                	li	a7,13
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b2:	48b9                	li	a7,14
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4ba:	48d9                	li	a7,22
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <crash>:
.global crash
crash:
 li a7, SYS_crash
 4c2:	48dd                	li	a7,23
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <mount>:
.global mount
mount:
 li a7, SYS_mount
 4ca:	48e1                	li	a7,24
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <umount>:
.global umount
umount:
 li a7, SYS_umount
 4d2:	48e5                	li	a7,25
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4da:	1101                	addi	sp,sp,-32
 4dc:	ec06                	sd	ra,24(sp)
 4de:	e822                	sd	s0,16(sp)
 4e0:	1000                	addi	s0,sp,32
 4e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e6:	4605                	li	a2,1
 4e8:	fef40593          	addi	a1,s0,-17
 4ec:	00000097          	auipc	ra,0x0
 4f0:	f4e080e7          	jalr	-178(ra) # 43a <write>
}
 4f4:	60e2                	ld	ra,24(sp)
 4f6:	6442                	ld	s0,16(sp)
 4f8:	6105                	addi	sp,sp,32
 4fa:	8082                	ret

00000000000004fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fc:	7139                	addi	sp,sp,-64
 4fe:	fc06                	sd	ra,56(sp)
 500:	f822                	sd	s0,48(sp)
 502:	f426                	sd	s1,40(sp)
 504:	f04a                	sd	s2,32(sp)
 506:	ec4e                	sd	s3,24(sp)
 508:	0080                	addi	s0,sp,64
 50a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50c:	c299                	beqz	a3,512 <printint+0x16>
 50e:	0805c863          	bltz	a1,59e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 512:	2581                	sext.w	a1,a1
  neg = 0;
 514:	4881                	li	a7,0
 516:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 51a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 51c:	2601                	sext.w	a2,a2
 51e:	00000517          	auipc	a0,0x0
 522:	4aa50513          	addi	a0,a0,1194 # 9c8 <digits>
 526:	883a                	mv	a6,a4
 528:	2705                	addiw	a4,a4,1
 52a:	02c5f7bb          	remuw	a5,a1,a2
 52e:	1782                	slli	a5,a5,0x20
 530:	9381                	srli	a5,a5,0x20
 532:	97aa                	add	a5,a5,a0
 534:	0007c783          	lbu	a5,0(a5)
 538:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 53c:	0005879b          	sext.w	a5,a1
 540:	02c5d5bb          	divuw	a1,a1,a2
 544:	0685                	addi	a3,a3,1
 546:	fec7f0e3          	bgeu	a5,a2,526 <printint+0x2a>
  if(neg)
 54a:	00088b63          	beqz	a7,560 <printint+0x64>
    buf[i++] = '-';
 54e:	fd040793          	addi	a5,s0,-48
 552:	973e                	add	a4,a4,a5
 554:	02d00793          	li	a5,45
 558:	fef70823          	sb	a5,-16(a4) # 1ff0 <__global_pointer$+0xe17>
 55c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 560:	02e05863          	blez	a4,590 <printint+0x94>
 564:	fc040793          	addi	a5,s0,-64
 568:	00e78933          	add	s2,a5,a4
 56c:	fff78993          	addi	s3,a5,-1
 570:	99ba                	add	s3,s3,a4
 572:	377d                	addiw	a4,a4,-1
 574:	1702                	slli	a4,a4,0x20
 576:	9301                	srli	a4,a4,0x20
 578:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57c:	fff94583          	lbu	a1,-1(s2)
 580:	8526                	mv	a0,s1
 582:	00000097          	auipc	ra,0x0
 586:	f58080e7          	jalr	-168(ra) # 4da <putc>
  while(--i >= 0)
 58a:	197d                	addi	s2,s2,-1
 58c:	ff3918e3          	bne	s2,s3,57c <printint+0x80>
}
 590:	70e2                	ld	ra,56(sp)
 592:	7442                	ld	s0,48(sp)
 594:	74a2                	ld	s1,40(sp)
 596:	7902                	ld	s2,32(sp)
 598:	69e2                	ld	s3,24(sp)
 59a:	6121                	addi	sp,sp,64
 59c:	8082                	ret
    x = -xx;
 59e:	40b005bb          	negw	a1,a1
    neg = 1;
 5a2:	4885                	li	a7,1
    x = -xx;
 5a4:	bf8d                	j	516 <printint+0x1a>

00000000000005a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a6:	7119                	addi	sp,sp,-128
 5a8:	fc86                	sd	ra,120(sp)
 5aa:	f8a2                	sd	s0,112(sp)
 5ac:	f4a6                	sd	s1,104(sp)
 5ae:	f0ca                	sd	s2,96(sp)
 5b0:	ecce                	sd	s3,88(sp)
 5b2:	e8d2                	sd	s4,80(sp)
 5b4:	e4d6                	sd	s5,72(sp)
 5b6:	e0da                	sd	s6,64(sp)
 5b8:	fc5e                	sd	s7,56(sp)
 5ba:	f862                	sd	s8,48(sp)
 5bc:	f466                	sd	s9,40(sp)
 5be:	f06a                	sd	s10,32(sp)
 5c0:	ec6e                	sd	s11,24(sp)
 5c2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c4:	0005c903          	lbu	s2,0(a1)
 5c8:	18090f63          	beqz	s2,766 <vprintf+0x1c0>
 5cc:	8aaa                	mv	s5,a0
 5ce:	8b32                	mv	s6,a2
 5d0:	00158493          	addi	s1,a1,1
  state = 0;
 5d4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d6:	02500a13          	li	s4,37
      if(c == 'd'){
 5da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5de:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5e2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5e6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ea:	00000b97          	auipc	s7,0x0
 5ee:	3deb8b93          	addi	s7,s7,990 # 9c8 <digits>
 5f2:	a839                	j	610 <vprintf+0x6a>
        putc(fd, c);
 5f4:	85ca                	mv	a1,s2
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	ee2080e7          	jalr	-286(ra) # 4da <putc>
 600:	a019                	j	606 <vprintf+0x60>
    } else if(state == '%'){
 602:	01498f63          	beq	s3,s4,620 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 606:	0485                	addi	s1,s1,1
 608:	fff4c903          	lbu	s2,-1(s1)
 60c:	14090d63          	beqz	s2,766 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 610:	0009079b          	sext.w	a5,s2
    if(state == 0){
 614:	fe0997e3          	bnez	s3,602 <vprintf+0x5c>
      if(c == '%'){
 618:	fd479ee3          	bne	a5,s4,5f4 <vprintf+0x4e>
        state = '%';
 61c:	89be                	mv	s3,a5
 61e:	b7e5                	j	606 <vprintf+0x60>
      if(c == 'd'){
 620:	05878063          	beq	a5,s8,660 <vprintf+0xba>
      } else if(c == 'l') {
 624:	05978c63          	beq	a5,s9,67c <vprintf+0xd6>
      } else if(c == 'x') {
 628:	07a78863          	beq	a5,s10,698 <vprintf+0xf2>
      } else if(c == 'p') {
 62c:	09b78463          	beq	a5,s11,6b4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 630:	07300713          	li	a4,115
 634:	0ce78663          	beq	a5,a4,700 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 638:	06300713          	li	a4,99
 63c:	0ee78e63          	beq	a5,a4,738 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 640:	11478863          	beq	a5,s4,750 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 644:	85d2                	mv	a1,s4
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	e92080e7          	jalr	-366(ra) # 4da <putc>
        putc(fd, c);
 650:	85ca                	mv	a1,s2
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e86080e7          	jalr	-378(ra) # 4da <putc>
      }
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b765                	j	606 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 660:	008b0913          	addi	s2,s6,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000b2583          	lw	a1,0(s6)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e8e080e7          	jalr	-370(ra) # 4fc <printint>
 676:	8b4a                	mv	s6,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b771                	j	606 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b0913          	addi	s2,s6,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000b2583          	lw	a1,0(s6)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e72080e7          	jalr	-398(ra) # 4fc <printint>
 692:	8b4a                	mv	s6,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	bf85                	j	606 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 698:	008b0913          	addi	s2,s6,8
 69c:	4681                	li	a3,0
 69e:	4641                	li	a2,16
 6a0:	000b2583          	lw	a1,0(s6)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	e56080e7          	jalr	-426(ra) # 4fc <printint>
 6ae:	8b4a                	mv	s6,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bf91                	j	606 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6b4:	008b0793          	addi	a5,s6,8
 6b8:	f8f43423          	sd	a5,-120(s0)
 6bc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6c0:	03000593          	li	a1,48
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e14080e7          	jalr	-492(ra) # 4da <putc>
  putc(fd, 'x');
 6ce:	85ea                	mv	a1,s10
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e08080e7          	jalr	-504(ra) # 4da <putc>
 6da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6dc:	03c9d793          	srli	a5,s3,0x3c
 6e0:	97de                	add	a5,a5,s7
 6e2:	0007c583          	lbu	a1,0(a5)
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	df2080e7          	jalr	-526(ra) # 4da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f0:	0992                	slli	s3,s3,0x4
 6f2:	397d                	addiw	s2,s2,-1
 6f4:	fe0914e3          	bnez	s2,6dc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b721                	j	606 <vprintf+0x60>
        s = va_arg(ap, char*);
 700:	008b0993          	addi	s3,s6,8
 704:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 708:	02090163          	beqz	s2,72a <vprintf+0x184>
        while(*s != 0){
 70c:	00094583          	lbu	a1,0(s2)
 710:	c9a1                	beqz	a1,760 <vprintf+0x1ba>
          putc(fd, *s);
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	dc6080e7          	jalr	-570(ra) # 4da <putc>
          s++;
 71c:	0905                	addi	s2,s2,1
        while(*s != 0){
 71e:	00094583          	lbu	a1,0(s2)
 722:	f9e5                	bnez	a1,712 <vprintf+0x16c>
        s = va_arg(ap, char*);
 724:	8b4e                	mv	s6,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	bdf9                	j	606 <vprintf+0x60>
          s = "(null)";
 72a:	00000917          	auipc	s2,0x0
 72e:	29690913          	addi	s2,s2,662 # 9c0 <malloc+0x150>
        while(*s != 0){
 732:	02800593          	li	a1,40
 736:	bff1                	j	712 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 738:	008b0913          	addi	s2,s6,8
 73c:	000b4583          	lbu	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	d98080e7          	jalr	-616(ra) # 4da <putc>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bd65                	j	606 <vprintf+0x60>
        putc(fd, c);
 750:	85d2                	mv	a1,s4
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	d86080e7          	jalr	-634(ra) # 4da <putc>
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b565                	j	606 <vprintf+0x60>
        s = va_arg(ap, char*);
 760:	8b4e                	mv	s6,s3
      state = 0;
 762:	4981                	li	s3,0
 764:	b54d                	j	606 <vprintf+0x60>
    }
  }
}
 766:	70e6                	ld	ra,120(sp)
 768:	7446                	ld	s0,112(sp)
 76a:	74a6                	ld	s1,104(sp)
 76c:	7906                	ld	s2,96(sp)
 76e:	69e6                	ld	s3,88(sp)
 770:	6a46                	ld	s4,80(sp)
 772:	6aa6                	ld	s5,72(sp)
 774:	6b06                	ld	s6,64(sp)
 776:	7be2                	ld	s7,56(sp)
 778:	7c42                	ld	s8,48(sp)
 77a:	7ca2                	ld	s9,40(sp)
 77c:	7d02                	ld	s10,32(sp)
 77e:	6de2                	ld	s11,24(sp)
 780:	6109                	addi	sp,sp,128
 782:	8082                	ret

0000000000000784 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 784:	715d                	addi	sp,sp,-80
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e010                	sd	a2,0(s0)
 78e:	e414                	sd	a3,8(s0)
 790:	e818                	sd	a4,16(s0)
 792:	ec1c                	sd	a5,24(s0)
 794:	03043023          	sd	a6,32(s0)
 798:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a0:	8622                	mv	a2,s0
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e04080e7          	jalr	-508(ra) # 5a6 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6161                	addi	sp,sp,80
 7b0:	8082                	ret

00000000000007b2 <printf>:

void
printf(const char *fmt, ...)
{
 7b2:	711d                	addi	sp,sp,-96
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e40c                	sd	a1,8(s0)
 7bc:	e810                	sd	a2,16(s0)
 7be:	ec14                	sd	a3,24(s0)
 7c0:	f018                	sd	a4,32(s0)
 7c2:	f41c                	sd	a5,40(s0)
 7c4:	03043823          	sd	a6,48(s0)
 7c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	00840613          	addi	a2,s0,8
 7d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d4:	85aa                	mv	a1,a0
 7d6:	4505                	li	a0,1
 7d8:	00000097          	auipc	ra,0x0
 7dc:	dce080e7          	jalr	-562(ra) # 5a6 <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6125                	addi	sp,sp,96
 7e6:	8082                	ret

00000000000007e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e8:	1141                	addi	sp,sp,-16
 7ea:	e422                	sd	s0,8(sp)
 7ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ee:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f2:	00000797          	auipc	a5,0x0
 7f6:	1fe7b783          	ld	a5,510(a5) # 9f0 <freep>
 7fa:	a805                	j	82a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fc:	4618                	lw	a4,8(a2)
 7fe:	9db9                	addw	a1,a1,a4
 800:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	6318                	ld	a4,0(a4)
 808:	fee53823          	sd	a4,-16(a0)
 80c:	a091                	j	850 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80e:	ff852703          	lw	a4,-8(a0)
 812:	9e39                	addw	a2,a2,a4
 814:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 816:	ff053703          	ld	a4,-16(a0)
 81a:	e398                	sd	a4,0(a5)
 81c:	a099                	j	862 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	6398                	ld	a4,0(a5)
 820:	00e7e463          	bltu	a5,a4,828 <free+0x40>
 824:	00e6ea63          	bltu	a3,a4,838 <free+0x50>
{
 828:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	fed7fae3          	bgeu	a5,a3,81e <free+0x36>
 82e:	6398                	ld	a4,0(a5)
 830:	00e6e463          	bltu	a3,a4,838 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	fee7eae3          	bltu	a5,a4,828 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 838:	ff852583          	lw	a1,-8(a0)
 83c:	6390                	ld	a2,0(a5)
 83e:	02059813          	slli	a6,a1,0x20
 842:	01c85713          	srli	a4,a6,0x1c
 846:	9736                	add	a4,a4,a3
 848:	fae60ae3          	beq	a2,a4,7fc <free+0x14>
    bp->s.ptr = p->s.ptr;
 84c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 850:	4790                	lw	a2,8(a5)
 852:	02061593          	slli	a1,a2,0x20
 856:	01c5d713          	srli	a4,a1,0x1c
 85a:	973e                	add	a4,a4,a5
 85c:	fae689e3          	beq	a3,a4,80e <free+0x26>
  } else
    p->s.ptr = bp;
 860:	e394                	sd	a3,0(a5)
  freep = p;
 862:	00000717          	auipc	a4,0x0
 866:	18f73723          	sd	a5,398(a4) # 9f0 <freep>
}
 86a:	6422                	ld	s0,8(sp)
 86c:	0141                	addi	sp,sp,16
 86e:	8082                	ret

0000000000000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	7139                	addi	sp,sp,-64
 872:	fc06                	sd	ra,56(sp)
 874:	f822                	sd	s0,48(sp)
 876:	f426                	sd	s1,40(sp)
 878:	f04a                	sd	s2,32(sp)
 87a:	ec4e                	sd	s3,24(sp)
 87c:	e852                	sd	s4,16(sp)
 87e:	e456                	sd	s5,8(sp)
 880:	e05a                	sd	s6,0(sp)
 882:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 884:	02051493          	slli	s1,a0,0x20
 888:	9081                	srli	s1,s1,0x20
 88a:	04bd                	addi	s1,s1,15
 88c:	8091                	srli	s1,s1,0x4
 88e:	0014899b          	addiw	s3,s1,1
 892:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 894:	00000517          	auipc	a0,0x0
 898:	15c53503          	ld	a0,348(a0) # 9f0 <freep>
 89c:	c515                	beqz	a0,8c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	02977f63          	bgeu	a4,s1,8e0 <malloc+0x70>
 8a6:	8a4e                	mv	s4,s3
 8a8:	0009871b          	sext.w	a4,s3
 8ac:	6685                	lui	a3,0x1
 8ae:	00d77363          	bgeu	a4,a3,8b4 <malloc+0x44>
 8b2:	6a05                	lui	s4,0x1
 8b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8bc:	00000917          	auipc	s2,0x0
 8c0:	13490913          	addi	s2,s2,308 # 9f0 <freep>
  if(p == (char*)-1)
 8c4:	5afd                	li	s5,-1
 8c6:	a895                	j	93a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8c8:	00008797          	auipc	a5,0x8
 8cc:	17078793          	addi	a5,a5,368 # 8a38 <base>
 8d0:	00000717          	auipc	a4,0x0
 8d4:	12f73023          	sd	a5,288(a4) # 9f0 <freep>
 8d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8de:	b7e1                	j	8a6 <malloc+0x36>
      if(p->s.size == nunits)
 8e0:	02e48c63          	beq	s1,a4,918 <malloc+0xa8>
        p->s.size -= nunits;
 8e4:	4137073b          	subw	a4,a4,s3
 8e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ea:	02071693          	slli	a3,a4,0x20
 8ee:	01c6d713          	srli	a4,a3,0x1c
 8f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f8:	00000717          	auipc	a4,0x0
 8fc:	0ea73c23          	sd	a0,248(a4) # 9f0 <freep>
      return (void*)(p + 1);
 900:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 904:	70e2                	ld	ra,56(sp)
 906:	7442                	ld	s0,48(sp)
 908:	74a2                	ld	s1,40(sp)
 90a:	7902                	ld	s2,32(sp)
 90c:	69e2                	ld	s3,24(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
 914:	6121                	addi	sp,sp,64
 916:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	e118                	sd	a4,0(a0)
 91c:	bff1                	j	8f8 <malloc+0x88>
  hp->s.size = nu;
 91e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 922:	0541                	addi	a0,a0,16
 924:	00000097          	auipc	ra,0x0
 928:	ec4080e7          	jalr	-316(ra) # 7e8 <free>
  return freep;
 92c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 930:	d971                	beqz	a0,904 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 934:	4798                	lw	a4,8(a5)
 936:	fa9775e3          	bgeu	a4,s1,8e0 <malloc+0x70>
    if(p == freep)
 93a:	00093703          	ld	a4,0(s2)
 93e:	853e                	mv	a0,a5
 940:	fef719e3          	bne	a4,a5,932 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 944:	8552                	mv	a0,s4
 946:	00000097          	auipc	ra,0x0
 94a:	b5c080e7          	jalr	-1188(ra) # 4a2 <sbrk>
  if(p == (char*)-1)
 94e:	fd5518e3          	bne	a0,s5,91e <malloc+0xae>
        return 0;
 952:	4501                	li	a0,0
 954:	bf45                	j	904 <malloc+0x94>
