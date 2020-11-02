
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	80010113          	addi	sp,sp,-2048 # 8000a800 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	0000a617          	auipc	a2,0xa
    8000004e:	fb660613          	addi	a2,a2,-74 # 8000a000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	d3478793          	addi	a5,a5,-716 # 80005d90 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd67a3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e7678793          	addi	a5,a5,-394 # 80000f1c <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(struct file *f, int user_dst, uint64 dst, int n)
{
    800000ec:	7159                	addi	sp,sp,-112
    800000ee:	f486                	sd	ra,104(sp)
    800000f0:	f0a2                	sd	s0,96(sp)
    800000f2:	eca6                	sd	s1,88(sp)
    800000f4:	e8ca                	sd	s2,80(sp)
    800000f6:	e4ce                	sd	s3,72(sp)
    800000f8:	e0d2                	sd	s4,64(sp)
    800000fa:	fc56                	sd	s5,56(sp)
    800000fc:	f85a                	sd	s6,48(sp)
    800000fe:	f45e                	sd	s7,40(sp)
    80000100:	f062                	sd	s8,32(sp)
    80000102:	ec66                	sd	s9,24(sp)
    80000104:	e86a                	sd	s10,16(sp)
    80000106:	1880                	addi	s0,sp,112
    80000108:	8aae                	mv	s5,a1
    8000010a:	8a32                	mv	s4,a2
    8000010c:	89b6                	mv	s3,a3
  uint target;
  int c;
  char cbuf;

  target = n;
    8000010e:	00068b1b          	sext.w	s6,a3
  acquire(&cons.lock);
    80000112:	00012517          	auipc	a0,0x12
    80000116:	6ee50513          	addi	a0,a0,1774 # 80012800 <cons>
    8000011a:	00001097          	auipc	ra,0x1
    8000011e:	986080e7          	jalr	-1658(ra) # 80000aa0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000122:	00012497          	auipc	s1,0x12
    80000126:	6de48493          	addi	s1,s1,1758 # 80012800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000012a:	00012917          	auipc	s2,0x12
    8000012e:	77690913          	addi	s2,s2,1910 # 800128a0 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80000132:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000134:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000136:	4ca9                	li	s9,10
  while(n > 0){
    80000138:	07305863          	blez	s3,800001a8 <consoleread+0xbc>
    while(cons.r == cons.w){
    8000013c:	0a04a783          	lw	a5,160(s1)
    80000140:	0a44a703          	lw	a4,164(s1)
    80000144:	02f71463          	bne	a4,a5,8000016c <consoleread+0x80>
      if(myproc()->killed){
    80000148:	00002097          	auipc	ra,0x2
    8000014c:	910080e7          	jalr	-1776(ra) # 80001a58 <myproc>
    80000150:	5d1c                	lw	a5,56(a0)
    80000152:	e7b5                	bnez	a5,800001be <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80000154:	85a6                	mv	a1,s1
    80000156:	854a                	mv	a0,s2
    80000158:	00002097          	auipc	ra,0x2
    8000015c:	0c0080e7          	jalr	192(ra) # 80002218 <sleep>
    while(cons.r == cons.w){
    80000160:	0a04a783          	lw	a5,160(s1)
    80000164:	0a44a703          	lw	a4,164(s1)
    80000168:	fef700e3          	beq	a4,a5,80000148 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000016c:	0017871b          	addiw	a4,a5,1
    80000170:	0ae4a023          	sw	a4,160(s1)
    80000174:	07f7f713          	andi	a4,a5,127
    80000178:	9726                	add	a4,a4,s1
    8000017a:	02074703          	lbu	a4,32(a4)
    8000017e:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000182:	077d0563          	beq	s10,s7,800001ec <consoleread+0x100>
    cbuf = c;
    80000186:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000018a:	4685                	li	a3,1
    8000018c:	f9f40613          	addi	a2,s0,-97
    80000190:	85d2                	mv	a1,s4
    80000192:	8556                	mv	a0,s5
    80000194:	00002097          	auipc	ra,0x2
    80000198:	2de080e7          	jalr	734(ra) # 80002472 <either_copyout>
    8000019c:	01850663          	beq	a0,s8,800001a8 <consoleread+0xbc>
    dst++;
    800001a0:	0a05                	addi	s4,s4,1
    --n;
    800001a2:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800001a4:	f99d1ae3          	bne	s10,s9,80000138 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001a8:	00012517          	auipc	a0,0x12
    800001ac:	65850513          	addi	a0,a0,1624 # 80012800 <cons>
    800001b0:	00001097          	auipc	ra,0x1
    800001b4:	9c0080e7          	jalr	-1600(ra) # 80000b70 <release>

  return target - n;
    800001b8:	413b053b          	subw	a0,s6,s3
    800001bc:	a811                	j	800001d0 <consoleread+0xe4>
        release(&cons.lock);
    800001be:	00012517          	auipc	a0,0x12
    800001c2:	64250513          	addi	a0,a0,1602 # 80012800 <cons>
    800001c6:	00001097          	auipc	ra,0x1
    800001ca:	9aa080e7          	jalr	-1622(ra) # 80000b70 <release>
        return -1;
    800001ce:	557d                	li	a0,-1
}
    800001d0:	70a6                	ld	ra,104(sp)
    800001d2:	7406                	ld	s0,96(sp)
    800001d4:	64e6                	ld	s1,88(sp)
    800001d6:	6946                	ld	s2,80(sp)
    800001d8:	69a6                	ld	s3,72(sp)
    800001da:	6a06                	ld	s4,64(sp)
    800001dc:	7ae2                	ld	s5,56(sp)
    800001de:	7b42                	ld	s6,48(sp)
    800001e0:	7ba2                	ld	s7,40(sp)
    800001e2:	7c02                	ld	s8,32(sp)
    800001e4:	6ce2                	ld	s9,24(sp)
    800001e6:	6d42                	ld	s10,16(sp)
    800001e8:	6165                	addi	sp,sp,112
    800001ea:	8082                	ret
      if(n < target){
    800001ec:	0009871b          	sext.w	a4,s3
    800001f0:	fb677ce3          	bgeu	a4,s6,800001a8 <consoleread+0xbc>
        cons.r--;
    800001f4:	00012717          	auipc	a4,0x12
    800001f8:	6af72623          	sw	a5,1708(a4) # 800128a0 <cons+0xa0>
    800001fc:	b775                	j	800001a8 <consoleread+0xbc>

00000000800001fe <consputc>:
  if(panicked){
    800001fe:	00028797          	auipc	a5,0x28
    80000202:	e227a783          	lw	a5,-478(a5) # 80028020 <panicked>
    80000206:	c391                	beqz	a5,8000020a <consputc+0xc>
    for(;;)
    80000208:	a001                	j	80000208 <consputc+0xa>
{
    8000020a:	1141                	addi	sp,sp,-16
    8000020c:	e406                	sd	ra,8(sp)
    8000020e:	e022                	sd	s0,0(sp)
    80000210:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000212:	10000793          	li	a5,256
    80000216:	00f50a63          	beq	a0,a5,8000022a <consputc+0x2c>
    uartputc(c);
    8000021a:	00000097          	auipc	ra,0x0
    8000021e:	5dc080e7          	jalr	1500(ra) # 800007f6 <uartputc>
}
    80000222:	60a2                	ld	ra,8(sp)
    80000224:	6402                	ld	s0,0(sp)
    80000226:	0141                	addi	sp,sp,16
    80000228:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    8000022a:	4521                	li	a0,8
    8000022c:	00000097          	auipc	ra,0x0
    80000230:	5ca080e7          	jalr	1482(ra) # 800007f6 <uartputc>
    80000234:	02000513          	li	a0,32
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	5be080e7          	jalr	1470(ra) # 800007f6 <uartputc>
    80000240:	4521                	li	a0,8
    80000242:	00000097          	auipc	ra,0x0
    80000246:	5b4080e7          	jalr	1460(ra) # 800007f6 <uartputc>
    8000024a:	bfe1                	j	80000222 <consputc+0x24>

000000008000024c <consolewrite>:
{
    8000024c:	715d                	addi	sp,sp,-80
    8000024e:	e486                	sd	ra,72(sp)
    80000250:	e0a2                	sd	s0,64(sp)
    80000252:	fc26                	sd	s1,56(sp)
    80000254:	f84a                	sd	s2,48(sp)
    80000256:	f44e                	sd	s3,40(sp)
    80000258:	f052                	sd	s4,32(sp)
    8000025a:	ec56                	sd	s5,24(sp)
    8000025c:	0880                	addi	s0,sp,80
    8000025e:	89ae                	mv	s3,a1
    80000260:	84b2                	mv	s1,a2
    80000262:	8ab6                	mv	s5,a3
  acquire(&cons.lock);
    80000264:	00012517          	auipc	a0,0x12
    80000268:	59c50513          	addi	a0,a0,1436 # 80012800 <cons>
    8000026c:	00001097          	auipc	ra,0x1
    80000270:	834080e7          	jalr	-1996(ra) # 80000aa0 <acquire>
  for(i = 0; i < n; i++){
    80000274:	03505e63          	blez	s5,800002b0 <consolewrite+0x64>
    80000278:	00148913          	addi	s2,s1,1
    8000027c:	fffa879b          	addiw	a5,s5,-1
    80000280:	1782                	slli	a5,a5,0x20
    80000282:	9381                	srli	a5,a5,0x20
    80000284:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000286:	5a7d                	li	s4,-1
    80000288:	4685                	li	a3,1
    8000028a:	8626                	mv	a2,s1
    8000028c:	85ce                	mv	a1,s3
    8000028e:	fbf40513          	addi	a0,s0,-65
    80000292:	00002097          	auipc	ra,0x2
    80000296:	236080e7          	jalr	566(ra) # 800024c8 <either_copyin>
    8000029a:	01450b63          	beq	a0,s4,800002b0 <consolewrite+0x64>
    consputc(c);
    8000029e:	fbf44503          	lbu	a0,-65(s0)
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	f5c080e7          	jalr	-164(ra) # 800001fe <consputc>
  for(i = 0; i < n; i++){
    800002aa:	0485                	addi	s1,s1,1
    800002ac:	fd249ee3          	bne	s1,s2,80000288 <consolewrite+0x3c>
  release(&cons.lock);
    800002b0:	00012517          	auipc	a0,0x12
    800002b4:	55050513          	addi	a0,a0,1360 # 80012800 <cons>
    800002b8:	00001097          	auipc	ra,0x1
    800002bc:	8b8080e7          	jalr	-1864(ra) # 80000b70 <release>
}
    800002c0:	8556                	mv	a0,s5
    800002c2:	60a6                	ld	ra,72(sp)
    800002c4:	6406                	ld	s0,64(sp)
    800002c6:	74e2                	ld	s1,56(sp)
    800002c8:	7942                	ld	s2,48(sp)
    800002ca:	79a2                	ld	s3,40(sp)
    800002cc:	7a02                	ld	s4,32(sp)
    800002ce:	6ae2                	ld	s5,24(sp)
    800002d0:	6161                	addi	sp,sp,80
    800002d2:	8082                	ret

00000000800002d4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d4:	1101                	addi	sp,sp,-32
    800002d6:	ec06                	sd	ra,24(sp)
    800002d8:	e822                	sd	s0,16(sp)
    800002da:	e426                	sd	s1,8(sp)
    800002dc:	e04a                	sd	s2,0(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00012517          	auipc	a0,0x12
    800002e6:	51e50513          	addi	a0,a0,1310 # 80012800 <cons>
    800002ea:	00000097          	auipc	ra,0x0
    800002ee:	7b6080e7          	jalr	1974(ra) # 80000aa0 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48663          	beq	s1,a5,800003a0 <consoleintr+0xcc>
    800002f8:	0297ca63          	blt	a5,s1,8000032c <consoleintr+0x58>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48763          	beq	s1,a5,800003ec <consoleintr+0x118>
    80000302:	47c1                	li	a5,16
    80000304:	10f49a63          	bne	s1,a5,80000418 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	216080e7          	jalr	534(ra) # 8000251e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00012517          	auipc	a0,0x12
    80000314:	4f050513          	addi	a0,a0,1264 # 80012800 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	858080e7          	jalr	-1960(ra) # 80000b70 <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6902                	ld	s2,0(sp)
    80000328:	6105                	addi	sp,sp,32
    8000032a:	8082                	ret
  switch(c){
    8000032c:	07f00793          	li	a5,127
    80000330:	0af48e63          	beq	s1,a5,800003ec <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000334:	00012717          	auipc	a4,0x12
    80000338:	4cc70713          	addi	a4,a4,1228 # 80012800 <cons>
    8000033c:	0a872783          	lw	a5,168(a4)
    80000340:	0a072703          	lw	a4,160(a4)
    80000344:	9f99                	subw	a5,a5,a4
    80000346:	07f00713          	li	a4,127
    8000034a:	fcf763e3          	bltu	a4,a5,80000310 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000034e:	47b5                	li	a5,13
    80000350:	0cf48763          	beq	s1,a5,8000041e <consoleintr+0x14a>
      consputc(c);
    80000354:	8526                	mv	a0,s1
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	ea8080e7          	jalr	-344(ra) # 800001fe <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000035e:	00012797          	auipc	a5,0x12
    80000362:	4a278793          	addi	a5,a5,1186 # 80012800 <cons>
    80000366:	0a87a703          	lw	a4,168(a5)
    8000036a:	0017069b          	addiw	a3,a4,1
    8000036e:	0006861b          	sext.w	a2,a3
    80000372:	0ad7a423          	sw	a3,168(a5)
    80000376:	07f77713          	andi	a4,a4,127
    8000037a:	97ba                	add	a5,a5,a4
    8000037c:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000380:	47a9                	li	a5,10
    80000382:	0cf48563          	beq	s1,a5,8000044c <consoleintr+0x178>
    80000386:	4791                	li	a5,4
    80000388:	0cf48263          	beq	s1,a5,8000044c <consoleintr+0x178>
    8000038c:	00012797          	auipc	a5,0x12
    80000390:	5147a783          	lw	a5,1300(a5) # 800128a0 <cons+0xa0>
    80000394:	0807879b          	addiw	a5,a5,128
    80000398:	f6f61ce3          	bne	a2,a5,80000310 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000039c:	863e                	mv	a2,a5
    8000039e:	a07d                	j	8000044c <consoleintr+0x178>
    while(cons.e != cons.w &&
    800003a0:	00012717          	auipc	a4,0x12
    800003a4:	46070713          	addi	a4,a4,1120 # 80012800 <cons>
    800003a8:	0a872783          	lw	a5,168(a4)
    800003ac:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b0:	00012497          	auipc	s1,0x12
    800003b4:	45048493          	addi	s1,s1,1104 # 80012800 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	f4f70be3          	beq	a4,a5,80000310 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	02074703          	lbu	a4,32(a4)
    800003ca:	f52703e3          	beq	a4,s2,80000310 <consoleintr+0x3c>
      cons.e--;
    800003ce:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	e28080e7          	jalr	-472(ra) # 800001fe <consputc>
    while(cons.e != cons.w &&
    800003de:	0a84a783          	lw	a5,168(s1)
    800003e2:	0a44a703          	lw	a4,164(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xea>
    800003ea:	b71d                	j	80000310 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003ec:	00012717          	auipc	a4,0x12
    800003f0:	41470713          	addi	a4,a4,1044 # 80012800 <cons>
    800003f4:	0a872783          	lw	a5,168(a4)
    800003f8:	0a472703          	lw	a4,164(a4)
    800003fc:	f0f70ae3          	beq	a4,a5,80000310 <consoleintr+0x3c>
      cons.e--;
    80000400:	37fd                	addiw	a5,a5,-1
    80000402:	00012717          	auipc	a4,0x12
    80000406:	4af72323          	sw	a5,1190(a4) # 800128a8 <cons+0xa8>
      consputc(BACKSPACE);
    8000040a:	10000513          	li	a0,256
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	df0080e7          	jalr	-528(ra) # 800001fe <consputc>
    80000416:	bded                	j	80000310 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000418:	ee048ce3          	beqz	s1,80000310 <consoleintr+0x3c>
    8000041c:	bf21                	j	80000334 <consoleintr+0x60>
      consputc(c);
    8000041e:	4529                	li	a0,10
    80000420:	00000097          	auipc	ra,0x0
    80000424:	dde080e7          	jalr	-546(ra) # 800001fe <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000428:	00012797          	auipc	a5,0x12
    8000042c:	3d878793          	addi	a5,a5,984 # 80012800 <cons>
    80000430:	0a87a703          	lw	a4,168(a5)
    80000434:	0017069b          	addiw	a3,a4,1
    80000438:	0006861b          	sext.w	a2,a3
    8000043c:	0ad7a423          	sw	a3,168(a5)
    80000440:	07f77713          	andi	a4,a4,127
    80000444:	97ba                	add	a5,a5,a4
    80000446:	4729                	li	a4,10
    80000448:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    8000044c:	00012797          	auipc	a5,0x12
    80000450:	44c7ac23          	sw	a2,1112(a5) # 800128a4 <cons+0xa4>
        wakeup(&cons.r);
    80000454:	00012517          	auipc	a0,0x12
    80000458:	44c50513          	addi	a0,a0,1100 # 800128a0 <cons+0xa0>
    8000045c:	00002097          	auipc	ra,0x2
    80000460:	f3c080e7          	jalr	-196(ra) # 80002398 <wakeup>
    80000464:	b575                	j	80000310 <consoleintr+0x3c>

0000000080000466 <consoleinit>:

void
consoleinit(void)
{
    80000466:	1141                	addi	sp,sp,-16
    80000468:	e406                	sd	ra,8(sp)
    8000046a:	e022                	sd	s0,0(sp)
    8000046c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000046e:	00008597          	auipc	a1,0x8
    80000472:	caa58593          	addi	a1,a1,-854 # 80008118 <userret+0x88>
    80000476:	00012517          	auipc	a0,0x12
    8000047a:	38a50513          	addi	a0,a0,906 # 80012800 <cons>
    8000047e:	00000097          	auipc	ra,0x0
    80000482:	54e080e7          	jalr	1358(ra) # 800009cc <initlock>

  uartinit();
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	33a080e7          	jalr	826(ra) # 800007c0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000048e:	00020797          	auipc	a5,0x20
    80000492:	bd278793          	addi	a5,a5,-1070 # 80020060 <devsw>
    80000496:	00000717          	auipc	a4,0x0
    8000049a:	c5670713          	addi	a4,a4,-938 # 800000ec <consoleread>
    8000049e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	dac70713          	addi	a4,a4,-596 # 8000024c <consolewrite>
    800004a8:	ef98                	sd	a4,24(a5)
}
    800004aa:	60a2                	ld	ra,8(sp)
    800004ac:	6402                	ld	s0,0(sp)
    800004ae:	0141                	addi	sp,sp,16
    800004b0:	8082                	ret

00000000800004b2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004b2:	7179                	addi	sp,sp,-48
    800004b4:	f406                	sd	ra,40(sp)
    800004b6:	f022                	sd	s0,32(sp)
    800004b8:	ec26                	sd	s1,24(sp)
    800004ba:	e84a                	sd	s2,16(sp)
    800004bc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004be:	c219                	beqz	a2,800004c4 <printint+0x12>
    800004c0:	08054663          	bltz	a0,8000054c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004c4:	2501                	sext.w	a0,a0
    800004c6:	4881                	li	a7,0
    800004c8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004cc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004ce:	2581                	sext.w	a1,a1
    800004d0:	00009617          	auipc	a2,0x9
    800004d4:	84060613          	addi	a2,a2,-1984 # 80008d10 <digits>
    800004d8:	883a                	mv	a6,a4
    800004da:	2705                	addiw	a4,a4,1
    800004dc:	02b577bb          	remuw	a5,a0,a1
    800004e0:	1782                	slli	a5,a5,0x20
    800004e2:	9381                	srli	a5,a5,0x20
    800004e4:	97b2                	add	a5,a5,a2
    800004e6:	0007c783          	lbu	a5,0(a5)
    800004ea:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004ee:	0005079b          	sext.w	a5,a0
    800004f2:	02b5553b          	divuw	a0,a0,a1
    800004f6:	0685                	addi	a3,a3,1
    800004f8:	feb7f0e3          	bgeu	a5,a1,800004d8 <printint+0x26>

  if(sign)
    800004fc:	00088b63          	beqz	a7,80000512 <printint+0x60>
    buf[i++] = '-';
    80000500:	fe040793          	addi	a5,s0,-32
    80000504:	973e                	add	a4,a4,a5
    80000506:	02d00793          	li	a5,45
    8000050a:	fef70823          	sb	a5,-16(a4)
    8000050e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000512:	02e05763          	blez	a4,80000540 <printint+0x8e>
    80000516:	fd040793          	addi	a5,s0,-48
    8000051a:	00e784b3          	add	s1,a5,a4
    8000051e:	fff78913          	addi	s2,a5,-1
    80000522:	993a                	add	s2,s2,a4
    80000524:	377d                	addiw	a4,a4,-1
    80000526:	1702                	slli	a4,a4,0x20
    80000528:	9301                	srli	a4,a4,0x20
    8000052a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000052e:	fff4c503          	lbu	a0,-1(s1)
    80000532:	00000097          	auipc	ra,0x0
    80000536:	ccc080e7          	jalr	-820(ra) # 800001fe <consputc>
  while(--i >= 0)
    8000053a:	14fd                	addi	s1,s1,-1
    8000053c:	ff2499e3          	bne	s1,s2,8000052e <printint+0x7c>
}
    80000540:	70a2                	ld	ra,40(sp)
    80000542:	7402                	ld	s0,32(sp)
    80000544:	64e2                	ld	s1,24(sp)
    80000546:	6942                	ld	s2,16(sp)
    80000548:	6145                	addi	sp,sp,48
    8000054a:	8082                	ret
    x = -xx;
    8000054c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000550:	4885                	li	a7,1
    x = -xx;
    80000552:	bf9d                	j	800004c8 <printint+0x16>

0000000080000554 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000554:	1101                	addi	sp,sp,-32
    80000556:	ec06                	sd	ra,24(sp)
    80000558:	e822                	sd	s0,16(sp)
    8000055a:	e426                	sd	s1,8(sp)
    8000055c:	1000                	addi	s0,sp,32
    8000055e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000560:	00012797          	auipc	a5,0x12
    80000564:	3607a823          	sw	zero,880(a5) # 800128d0 <pr+0x20>
  printf("PANIC: ");
    80000568:	00008517          	auipc	a0,0x8
    8000056c:	bb850513          	addi	a0,a0,-1096 # 80008120 <userret+0x90>
    80000570:	00000097          	auipc	ra,0x0
    80000574:	03e080e7          	jalr	62(ra) # 800005ae <printf>
  printf(s);
    80000578:	8526                	mv	a0,s1
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	034080e7          	jalr	52(ra) # 800005ae <printf>
  printf("\n");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	d0e50513          	addi	a0,a0,-754 # 80008290 <userret+0x200>
    8000058a:	00000097          	auipc	ra,0x0
    8000058e:	024080e7          	jalr	36(ra) # 800005ae <printf>
  printf("HINT: restart xv6 using 'make qemu-gdb', type 'b panic' (to set breakpoint in panic) in the gdb window, followed by 'c' (continue), and when the kernel hits the breakpoint, type 'bt' to get a backtrace\n");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	b9650513          	addi	a0,a0,-1130 # 80008128 <userret+0x98>
    8000059a:	00000097          	auipc	ra,0x0
    8000059e:	014080e7          	jalr	20(ra) # 800005ae <printf>
  panicked = 1; // freeze other CPUs
    800005a2:	4785                	li	a5,1
    800005a4:	00028717          	auipc	a4,0x28
    800005a8:	a6f72e23          	sw	a5,-1412(a4) # 80028020 <panicked>
  for(;;)
    800005ac:	a001                	j	800005ac <panic+0x58>

00000000800005ae <printf>:
{
    800005ae:	7131                	addi	sp,sp,-192
    800005b0:	fc86                	sd	ra,120(sp)
    800005b2:	f8a2                	sd	s0,112(sp)
    800005b4:	f4a6                	sd	s1,104(sp)
    800005b6:	f0ca                	sd	s2,96(sp)
    800005b8:	ecce                	sd	s3,88(sp)
    800005ba:	e8d2                	sd	s4,80(sp)
    800005bc:	e4d6                	sd	s5,72(sp)
    800005be:	e0da                	sd	s6,64(sp)
    800005c0:	fc5e                	sd	s7,56(sp)
    800005c2:	f862                	sd	s8,48(sp)
    800005c4:	f466                	sd	s9,40(sp)
    800005c6:	f06a                	sd	s10,32(sp)
    800005c8:	ec6e                	sd	s11,24(sp)
    800005ca:	0100                	addi	s0,sp,128
    800005cc:	8a2a                	mv	s4,a0
    800005ce:	e40c                	sd	a1,8(s0)
    800005d0:	e810                	sd	a2,16(s0)
    800005d2:	ec14                	sd	a3,24(s0)
    800005d4:	f018                	sd	a4,32(s0)
    800005d6:	f41c                	sd	a5,40(s0)
    800005d8:	03043823          	sd	a6,48(s0)
    800005dc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005e0:	00012d97          	auipc	s11,0x12
    800005e4:	2f0dad83          	lw	s11,752(s11) # 800128d0 <pr+0x20>
  if(locking)
    800005e8:	020d9b63          	bnez	s11,8000061e <printf+0x70>
  if (fmt == 0)
    800005ec:	040a0263          	beqz	s4,80000630 <printf+0x82>
  va_start(ap, fmt);
    800005f0:	00840793          	addi	a5,s0,8
    800005f4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005f8:	000a4503          	lbu	a0,0(s4)
    800005fc:	14050f63          	beqz	a0,8000075a <printf+0x1ac>
    80000600:	4981                	li	s3,0
    if(c != '%'){
    80000602:	02500a93          	li	s5,37
    switch(c){
    80000606:	07000b93          	li	s7,112
  consputc('x');
    8000060a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060c:	00008b17          	auipc	s6,0x8
    80000610:	704b0b13          	addi	s6,s6,1796 # 80008d10 <digits>
    switch(c){
    80000614:	07300c93          	li	s9,115
    80000618:	06400c13          	li	s8,100
    8000061c:	a82d                	j	80000656 <printf+0xa8>
    acquire(&pr.lock);
    8000061e:	00012517          	auipc	a0,0x12
    80000622:	29250513          	addi	a0,a0,658 # 800128b0 <pr>
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	47a080e7          	jalr	1146(ra) # 80000aa0 <acquire>
    8000062e:	bf7d                	j	800005ec <printf+0x3e>
    panic("null fmt");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	bd050513          	addi	a0,a0,-1072 # 80008200 <userret+0x170>
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	f1c080e7          	jalr	-228(ra) # 80000554 <panic>
      consputc(c);
    80000640:	00000097          	auipc	ra,0x0
    80000644:	bbe080e7          	jalr	-1090(ra) # 800001fe <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000648:	2985                	addiw	s3,s3,1
    8000064a:	013a07b3          	add	a5,s4,s3
    8000064e:	0007c503          	lbu	a0,0(a5)
    80000652:	10050463          	beqz	a0,8000075a <printf+0x1ac>
    if(c != '%'){
    80000656:	ff5515e3          	bne	a0,s5,80000640 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000065a:	2985                	addiw	s3,s3,1
    8000065c:	013a07b3          	add	a5,s4,s3
    80000660:	0007c783          	lbu	a5,0(a5)
    80000664:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000668:	cbed                	beqz	a5,8000075a <printf+0x1ac>
    switch(c){
    8000066a:	05778a63          	beq	a5,s7,800006be <printf+0x110>
    8000066e:	02fbf663          	bgeu	s7,a5,8000069a <printf+0xec>
    80000672:	09978863          	beq	a5,s9,80000702 <printf+0x154>
    80000676:	07800713          	li	a4,120
    8000067a:	0ce79563          	bne	a5,a4,80000744 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	85ea                	mv	a1,s10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e22080e7          	jalr	-478(ra) # 800004b2 <printint>
      break;
    80000698:	bf45                	j	80000648 <printf+0x9a>
    switch(c){
    8000069a:	09578f63          	beq	a5,s5,80000738 <printf+0x18a>
    8000069e:	0b879363          	bne	a5,s8,80000744 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4605                	li	a2,1
    800006b0:	45a9                	li	a1,10
    800006b2:	4388                	lw	a0,0(a5)
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	dfe080e7          	jalr	-514(ra) # 800004b2 <printint>
      break;
    800006bc:	b771                	j	80000648 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006ce:	03000513          	li	a0,48
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	b2c080e7          	jalr	-1236(ra) # 800001fe <consputc>
  consputc('x');
    800006da:	07800513          	li	a0,120
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b20080e7          	jalr	-1248(ra) # 800001fe <consputc>
    800006e6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e8:	03c95793          	srli	a5,s2,0x3c
    800006ec:	97da                	add	a5,a5,s6
    800006ee:	0007c503          	lbu	a0,0(a5)
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b0c080e7          	jalr	-1268(ra) # 800001fe <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006fa:	0912                	slli	s2,s2,0x4
    800006fc:	34fd                	addiw	s1,s1,-1
    800006fe:	f4ed                	bnez	s1,800006e8 <printf+0x13a>
    80000700:	b7a1                	j	80000648 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80000702:	f8843783          	ld	a5,-120(s0)
    80000706:	00878713          	addi	a4,a5,8
    8000070a:	f8e43423          	sd	a4,-120(s0)
    8000070e:	6384                	ld	s1,0(a5)
    80000710:	cc89                	beqz	s1,8000072a <printf+0x17c>
      for(; *s; s++)
    80000712:	0004c503          	lbu	a0,0(s1)
    80000716:	d90d                	beqz	a0,80000648 <printf+0x9a>
        consputc(*s);
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	ae6080e7          	jalr	-1306(ra) # 800001fe <consputc>
      for(; *s; s++)
    80000720:	0485                	addi	s1,s1,1
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	f96d                	bnez	a0,80000718 <printf+0x16a>
    80000728:	b705                	j	80000648 <printf+0x9a>
        s = "(null)";
    8000072a:	00008497          	auipc	s1,0x8
    8000072e:	ace48493          	addi	s1,s1,-1330 # 800081f8 <userret+0x168>
      for(; *s; s++)
    80000732:	02800513          	li	a0,40
    80000736:	b7cd                	j	80000718 <printf+0x16a>
      consputc('%');
    80000738:	8556                	mv	a0,s5
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	ac4080e7          	jalr	-1340(ra) # 800001fe <consputc>
      break;
    80000742:	b719                	j	80000648 <printf+0x9a>
      consputc('%');
    80000744:	8556                	mv	a0,s5
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	ab8080e7          	jalr	-1352(ra) # 800001fe <consputc>
      consputc(c);
    8000074e:	8526                	mv	a0,s1
    80000750:	00000097          	auipc	ra,0x0
    80000754:	aae080e7          	jalr	-1362(ra) # 800001fe <consputc>
      break;
    80000758:	bdc5                	j	80000648 <printf+0x9a>
  if(locking)
    8000075a:	020d9163          	bnez	s11,8000077c <printf+0x1ce>
}
    8000075e:	70e6                	ld	ra,120(sp)
    80000760:	7446                	ld	s0,112(sp)
    80000762:	74a6                	ld	s1,104(sp)
    80000764:	7906                	ld	s2,96(sp)
    80000766:	69e6                	ld	s3,88(sp)
    80000768:	6a46                	ld	s4,80(sp)
    8000076a:	6aa6                	ld	s5,72(sp)
    8000076c:	6b06                	ld	s6,64(sp)
    8000076e:	7be2                	ld	s7,56(sp)
    80000770:	7c42                	ld	s8,48(sp)
    80000772:	7ca2                	ld	s9,40(sp)
    80000774:	7d02                	ld	s10,32(sp)
    80000776:	6de2                	ld	s11,24(sp)
    80000778:	6129                	addi	sp,sp,192
    8000077a:	8082                	ret
    release(&pr.lock);
    8000077c:	00012517          	auipc	a0,0x12
    80000780:	13450513          	addi	a0,a0,308 # 800128b0 <pr>
    80000784:	00000097          	auipc	ra,0x0
    80000788:	3ec080e7          	jalr	1004(ra) # 80000b70 <release>
}
    8000078c:	bfc9                	j	8000075e <printf+0x1b0>

000000008000078e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000078e:	1101                	addi	sp,sp,-32
    80000790:	ec06                	sd	ra,24(sp)
    80000792:	e822                	sd	s0,16(sp)
    80000794:	e426                	sd	s1,8(sp)
    80000796:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000798:	00012497          	auipc	s1,0x12
    8000079c:	11848493          	addi	s1,s1,280 # 800128b0 <pr>
    800007a0:	00008597          	auipc	a1,0x8
    800007a4:	a7058593          	addi	a1,a1,-1424 # 80008210 <userret+0x180>
    800007a8:	8526                	mv	a0,s1
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	222080e7          	jalr	546(ra) # 800009cc <initlock>
  pr.locking = 1;
    800007b2:	4785                	li	a5,1
    800007b4:	d09c                	sw	a5,32(s1)
}
    800007b6:	60e2                	ld	ra,24(sp)
    800007b8:	6442                	ld	s0,16(sp)
    800007ba:	64a2                	ld	s1,8(sp)
    800007bc:	6105                	addi	sp,sp,32
    800007be:	8082                	ret

00000000800007c0 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007c0:	1141                	addi	sp,sp,-16
    800007c2:	e422                	sd	s0,8(sp)
    800007c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007c6:	100007b7          	lui	a5,0x10000
    800007ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007ce:	f8000713          	li	a4,-128
    800007d2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007d6:	470d                	li	a4,3
    800007d8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007e0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007e4:	471d                	li	a4,7
    800007e6:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007ea:	4705                	li	a4,1
    800007ec:	00e780a3          	sb	a4,1(a5)
}
    800007f0:	6422                	ld	s0,8(sp)
    800007f2:	0141                	addi	sp,sp,16
    800007f4:	8082                	ret

00000000800007f6 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007f6:	1141                	addi	sp,sp,-16
    800007f8:	e422                	sd	s0,8(sp)
    800007fa:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007fc:	10000737          	lui	a4,0x10000
    80000800:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000804:	0207f793          	andi	a5,a5,32
    80000808:	dfe5                	beqz	a5,80000800 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    8000080a:	0ff57513          	andi	a0,a0,255
    8000080e:	100007b7          	lui	a5,0x10000
    80000812:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000816:	6422                	ld	s0,8(sp)
    80000818:	0141                	addi	sp,sp,16
    8000081a:	8082                	ret

000000008000081c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000081c:	1141                	addi	sp,sp,-16
    8000081e:	e422                	sd	s0,8(sp)
    80000820:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000082a:	8b85                	andi	a5,a5,1
    8000082c:	cb91                	beqz	a5,80000840 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000082e:	100007b7          	lui	a5,0x10000
    80000832:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000836:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000083a:	6422                	ld	s0,8(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret
    return -1;
    80000840:	557d                	li	a0,-1
    80000842:	bfe5                	j	8000083a <uartgetc+0x1e>

0000000080000844 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000844:	1101                	addi	sp,sp,-32
    80000846:	ec06                	sd	ra,24(sp)
    80000848:	e822                	sd	s0,16(sp)
    8000084a:	e426                	sd	s1,8(sp)
    8000084c:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000084e:	54fd                	li	s1,-1
    80000850:	a029                	j	8000085a <uartintr+0x16>
      break;
    consoleintr(c);
    80000852:	00000097          	auipc	ra,0x0
    80000856:	a82080e7          	jalr	-1406(ra) # 800002d4 <consoleintr>
    int c = uartgetc();
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	fc2080e7          	jalr	-62(ra) # 8000081c <uartgetc>
    if(c == -1)
    80000862:	fe9518e3          	bne	a0,s1,80000852 <uartintr+0xe>
  }
}
    80000866:	60e2                	ld	ra,24(sp)
    80000868:	6442                	ld	s0,16(sp)
    8000086a:	64a2                	ld	s1,8(sp)
    8000086c:	6105                	addi	sp,sp,32
    8000086e:	8082                	ret

0000000080000870 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	e04a                	sd	s2,0(sp)
    8000087a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000087c:	03451793          	slli	a5,a0,0x34
    80000880:	ebb9                	bnez	a5,800008d6 <kfree+0x66>
    80000882:	84aa                	mv	s1,a0
    80000884:	00027797          	auipc	a5,0x27
    80000888:	7d878793          	addi	a5,a5,2008 # 8002805c <end>
    8000088c:	04f56563          	bltu	a0,a5,800008d6 <kfree+0x66>
    80000890:	47c5                	li	a5,17
    80000892:	07ee                	slli	a5,a5,0x1b
    80000894:	04f57163          	bgeu	a0,a5,800008d6 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000898:	6605                	lui	a2,0x1
    8000089a:	4585                	li	a1,1
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	4d2080e7          	jalr	1234(ra) # 80000d6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800008a4:	00012917          	auipc	s2,0x12
    800008a8:	03490913          	addi	s2,s2,52 # 800128d8 <kmem>
    800008ac:	854a                	mv	a0,s2
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	1f2080e7          	jalr	498(ra) # 80000aa0 <acquire>
  r->next = kmem.freelist;
    800008b6:	02093783          	ld	a5,32(s2)
    800008ba:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008bc:	02993023          	sd	s1,32(s2)
  release(&kmem.lock);
    800008c0:	854a                	mv	a0,s2
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	2ae080e7          	jalr	686(ra) # 80000b70 <release>
}
    800008ca:	60e2                	ld	ra,24(sp)
    800008cc:	6442                	ld	s0,16(sp)
    800008ce:	64a2                	ld	s1,8(sp)
    800008d0:	6902                	ld	s2,0(sp)
    800008d2:	6105                	addi	sp,sp,32
    800008d4:	8082                	ret
    panic("kfree");
    800008d6:	00008517          	auipc	a0,0x8
    800008da:	94250513          	addi	a0,a0,-1726 # 80008218 <userret+0x188>
    800008de:	00000097          	auipc	ra,0x0
    800008e2:	c76080e7          	jalr	-906(ra) # 80000554 <panic>

00000000800008e6 <freerange>:
{
    800008e6:	7179                	addi	sp,sp,-48
    800008e8:	f406                	sd	ra,40(sp)
    800008ea:	f022                	sd	s0,32(sp)
    800008ec:	ec26                	sd	s1,24(sp)
    800008ee:	e84a                	sd	s2,16(sp)
    800008f0:	e44e                	sd	s3,8(sp)
    800008f2:	e052                	sd	s4,0(sp)
    800008f4:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008f6:	6785                	lui	a5,0x1
    800008f8:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800008fc:	94aa                	add	s1,s1,a0
    800008fe:	757d                	lui	a0,0xfffff
    80000900:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000902:	94be                	add	s1,s1,a5
    80000904:	0095ee63          	bltu	a1,s1,80000920 <freerange+0x3a>
    80000908:	892e                	mv	s2,a1
    kfree(p);
    8000090a:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000090c:	6985                	lui	s3,0x1
    kfree(p);
    8000090e:	01448533          	add	a0,s1,s4
    80000912:	00000097          	auipc	ra,0x0
    80000916:	f5e080e7          	jalr	-162(ra) # 80000870 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000091a:	94ce                	add	s1,s1,s3
    8000091c:	fe9979e3          	bgeu	s2,s1,8000090e <freerange+0x28>
}
    80000920:	70a2                	ld	ra,40(sp)
    80000922:	7402                	ld	s0,32(sp)
    80000924:	64e2                	ld	s1,24(sp)
    80000926:	6942                	ld	s2,16(sp)
    80000928:	69a2                	ld	s3,8(sp)
    8000092a:	6a02                	ld	s4,0(sp)
    8000092c:	6145                	addi	sp,sp,48
    8000092e:	8082                	ret

0000000080000930 <kinit>:
{
    80000930:	1141                	addi	sp,sp,-16
    80000932:	e406                	sd	ra,8(sp)
    80000934:	e022                	sd	s0,0(sp)
    80000936:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000938:	00008597          	auipc	a1,0x8
    8000093c:	8e858593          	addi	a1,a1,-1816 # 80008220 <userret+0x190>
    80000940:	00012517          	auipc	a0,0x12
    80000944:	f9850513          	addi	a0,a0,-104 # 800128d8 <kmem>
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	084080e7          	jalr	132(ra) # 800009cc <initlock>
  freerange(end, (void*)PHYSTOP);
    80000950:	45c5                	li	a1,17
    80000952:	05ee                	slli	a1,a1,0x1b
    80000954:	00027517          	auipc	a0,0x27
    80000958:	70850513          	addi	a0,a0,1800 # 8002805c <end>
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f8a080e7          	jalr	-118(ra) # 800008e6 <freerange>
}
    80000964:	60a2                	ld	ra,8(sp)
    80000966:	6402                	ld	s0,0(sp)
    80000968:	0141                	addi	sp,sp,16
    8000096a:	8082                	ret

000000008000096c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000096c:	1101                	addi	sp,sp,-32
    8000096e:	ec06                	sd	ra,24(sp)
    80000970:	e822                	sd	s0,16(sp)
    80000972:	e426                	sd	s1,8(sp)
    80000974:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000976:	00012497          	auipc	s1,0x12
    8000097a:	f6248493          	addi	s1,s1,-158 # 800128d8 <kmem>
    8000097e:	8526                	mv	a0,s1
    80000980:	00000097          	auipc	ra,0x0
    80000984:	120080e7          	jalr	288(ra) # 80000aa0 <acquire>
  r = kmem.freelist;
    80000988:	7084                	ld	s1,32(s1)
  if(r)
    8000098a:	c885                	beqz	s1,800009ba <kalloc+0x4e>
    kmem.freelist = r->next;
    8000098c:	609c                	ld	a5,0(s1)
    8000098e:	00012517          	auipc	a0,0x12
    80000992:	f4a50513          	addi	a0,a0,-182 # 800128d8 <kmem>
    80000996:	f11c                	sd	a5,32(a0)
  release(&kmem.lock);
    80000998:	00000097          	auipc	ra,0x0
    8000099c:	1d8080e7          	jalr	472(ra) # 80000b70 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800009a0:	6605                	lui	a2,0x1
    800009a2:	4595                	li	a1,5
    800009a4:	8526                	mv	a0,s1
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	3c8080e7          	jalr	968(ra) # 80000d6e <memset>
  return (void*)r;
}
    800009ae:	8526                	mv	a0,s1
    800009b0:	60e2                	ld	ra,24(sp)
    800009b2:	6442                	ld	s0,16(sp)
    800009b4:	64a2                	ld	s1,8(sp)
    800009b6:	6105                	addi	sp,sp,32
    800009b8:	8082                	ret
  release(&kmem.lock);
    800009ba:	00012517          	auipc	a0,0x12
    800009be:	f1e50513          	addi	a0,a0,-226 # 800128d8 <kmem>
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	1ae080e7          	jalr	430(ra) # 80000b70 <release>
  if(r)
    800009ca:	b7d5                	j	800009ae <kalloc+0x42>

00000000800009cc <initlock>:

// assumes locks are not freed
void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
    800009cc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009ce:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009d2:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800009d6:	00052e23          	sw	zero,28(a0)
  lk->n = 0;
    800009da:	00052c23          	sw	zero,24(a0)
  if(nlock >= NLOCK)
    800009de:	00027797          	auipc	a5,0x27
    800009e2:	6467a783          	lw	a5,1606(a5) # 80028024 <nlock>
    800009e6:	3e700713          	li	a4,999
    800009ea:	02f74063          	blt	a4,a5,80000a0a <initlock+0x3e>
    panic("initlock");
  locks[nlock] = lk;
    800009ee:	00379693          	slli	a3,a5,0x3
    800009f2:	00012717          	auipc	a4,0x12
    800009f6:	f0e70713          	addi	a4,a4,-242 # 80012900 <locks>
    800009fa:	9736                	add	a4,a4,a3
    800009fc:	e308                	sd	a0,0(a4)
  nlock++;
    800009fe:	2785                	addiw	a5,a5,1
    80000a00:	00027717          	auipc	a4,0x27
    80000a04:	62f72223          	sw	a5,1572(a4) # 80028024 <nlock>
    80000a08:	8082                	ret
{
    80000a0a:	1141                	addi	sp,sp,-16
    80000a0c:	e406                	sd	ra,8(sp)
    80000a0e:	e022                	sd	s0,0(sp)
    80000a10:	0800                	addi	s0,sp,16
    panic("initlock");
    80000a12:	00008517          	auipc	a0,0x8
    80000a16:	81650513          	addi	a0,a0,-2026 # 80008228 <userret+0x198>
    80000a1a:	00000097          	auipc	ra,0x0
    80000a1e:	b3a080e7          	jalr	-1222(ra) # 80000554 <panic>

0000000080000a22 <holding>:
// Must be called with interrupts off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000a22:	411c                	lw	a5,0(a0)
    80000a24:	e399                	bnez	a5,80000a2a <holding+0x8>
    80000a26:	4501                	li	a0,0
  return r;
}
    80000a28:	8082                	ret
{
    80000a2a:	1101                	addi	sp,sp,-32
    80000a2c:	ec06                	sd	ra,24(sp)
    80000a2e:	e822                	sd	s0,16(sp)
    80000a30:	e426                	sd	s1,8(sp)
    80000a32:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000a34:	6904                	ld	s1,16(a0)
    80000a36:	00001097          	auipc	ra,0x1
    80000a3a:	006080e7          	jalr	6(ra) # 80001a3c <mycpu>
    80000a3e:	40a48533          	sub	a0,s1,a0
    80000a42:	00153513          	seqz	a0,a0
}
    80000a46:	60e2                	ld	ra,24(sp)
    80000a48:	6442                	ld	s0,16(sp)
    80000a4a:	64a2                	ld	s1,8(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret

0000000080000a50 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000a50:	1101                	addi	sp,sp,-32
    80000a52:	ec06                	sd	ra,24(sp)
    80000a54:	e822                	sd	s0,16(sp)
    80000a56:	e426                	sd	s1,8(sp)
    80000a58:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a5a:	100024f3          	csrr	s1,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a5e:	8889                	andi	s1,s1,2
  int old = intr_get();
  if(old)
    80000a60:	c491                	beqz	s1,80000a6c <push_off+0x1c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000a66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a68:	10079073          	csrw	sstatus,a5
    intr_off();
  if(mycpu()->noff == 0)
    80000a6c:	00001097          	auipc	ra,0x1
    80000a70:	fd0080e7          	jalr	-48(ra) # 80001a3c <mycpu>
    80000a74:	5d3c                	lw	a5,120(a0)
    80000a76:	cf89                	beqz	a5,80000a90 <push_off+0x40>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000a78:	00001097          	auipc	ra,0x1
    80000a7c:	fc4080e7          	jalr	-60(ra) # 80001a3c <mycpu>
    80000a80:	5d3c                	lw	a5,120(a0)
    80000a82:	2785                	addiw	a5,a5,1
    80000a84:	dd3c                	sw	a5,120(a0)
}
    80000a86:	60e2                	ld	ra,24(sp)
    80000a88:	6442                	ld	s0,16(sp)
    80000a8a:	64a2                	ld	s1,8(sp)
    80000a8c:	6105                	addi	sp,sp,32
    80000a8e:	8082                	ret
    mycpu()->intena = old;
    80000a90:	00001097          	auipc	ra,0x1
    80000a94:	fac080e7          	jalr	-84(ra) # 80001a3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a98:	009034b3          	snez	s1,s1
    80000a9c:	dd64                	sw	s1,124(a0)
    80000a9e:	bfe9                	j	80000a78 <push_off+0x28>

0000000080000aa0 <acquire>:
{
    80000aa0:	1101                	addi	sp,sp,-32
    80000aa2:	ec06                	sd	ra,24(sp)
    80000aa4:	e822                	sd	s0,16(sp)
    80000aa6:	e426                	sd	s1,8(sp)
    80000aa8:	1000                	addi	s0,sp,32
    80000aaa:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	fa4080e7          	jalr	-92(ra) # 80000a50 <push_off>
  if(holding(lk))
    80000ab4:	8526                	mv	a0,s1
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	f6c080e7          	jalr	-148(ra) # 80000a22 <holding>
    80000abe:	e911                	bnez	a0,80000ad2 <acquire+0x32>
  __sync_fetch_and_add(&(lk->n), 1);
    80000ac0:	4785                	li	a5,1
    80000ac2:	01848713          	addi	a4,s1,24
    80000ac6:	0f50000f          	fence	iorw,ow
    80000aca:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000ace:	4705                	li	a4,1
    80000ad0:	a839                	j	80000aee <acquire+0x4e>
    panic("acquire");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	76650513          	addi	a0,a0,1894 # 80008238 <userret+0x1a8>
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	a7a080e7          	jalr	-1414(ra) # 80000554 <panic>
     __sync_fetch_and_add(&lk->nts, 1);
    80000ae2:	01c48793          	addi	a5,s1,28
    80000ae6:	0f50000f          	fence	iorw,ow
    80000aea:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000aee:	87ba                	mv	a5,a4
    80000af0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000af4:	2781                	sext.w	a5,a5
    80000af6:	f7f5                	bnez	a5,80000ae2 <acquire+0x42>
  __sync_synchronize();
    80000af8:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000afc:	00001097          	auipc	ra,0x1
    80000b00:	f40080e7          	jalr	-192(ra) # 80001a3c <mycpu>
    80000b04:	e888                	sd	a0,16(s1)
}
    80000b06:	60e2                	ld	ra,24(sp)
    80000b08:	6442                	ld	s0,16(sp)
    80000b0a:	64a2                	ld	s1,8(sp)
    80000b0c:	6105                	addi	sp,sp,32
    80000b0e:	8082                	ret

0000000080000b10 <pop_off>:

void
pop_off(void)
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b18:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000b1c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000b1e:	eb8d                	bnez	a5,80000b50 <pop_off+0x40>
    panic("pop_off - interruptible");
  struct cpu *c = mycpu();
    80000b20:	00001097          	auipc	ra,0x1
    80000b24:	f1c080e7          	jalr	-228(ra) # 80001a3c <mycpu>
  if(c->noff < 1)
    80000b28:	5d3c                	lw	a5,120(a0)
    80000b2a:	02f05b63          	blez	a5,80000b60 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000b2e:	37fd                	addiw	a5,a5,-1
    80000b30:	0007871b          	sext.w	a4,a5
    80000b34:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000b36:	eb09                	bnez	a4,80000b48 <pop_off+0x38>
    80000b38:	5d7c                	lw	a5,124(a0)
    80000b3a:	c799                	beqz	a5,80000b48 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000b40:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b44:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000b48:	60a2                	ld	ra,8(sp)
    80000b4a:	6402                	ld	s0,0(sp)
    80000b4c:	0141                	addi	sp,sp,16
    80000b4e:	8082                	ret
    panic("pop_off - interruptible");
    80000b50:	00007517          	auipc	a0,0x7
    80000b54:	6f050513          	addi	a0,a0,1776 # 80008240 <userret+0x1b0>
    80000b58:	00000097          	auipc	ra,0x0
    80000b5c:	9fc080e7          	jalr	-1540(ra) # 80000554 <panic>
    panic("pop_off");
    80000b60:	00007517          	auipc	a0,0x7
    80000b64:	6f850513          	addi	a0,a0,1784 # 80008258 <userret+0x1c8>
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9ec080e7          	jalr	-1556(ra) # 80000554 <panic>

0000000080000b70 <release>:
{
    80000b70:	1101                	addi	sp,sp,-32
    80000b72:	ec06                	sd	ra,24(sp)
    80000b74:	e822                	sd	s0,16(sp)
    80000b76:	e426                	sd	s1,8(sp)
    80000b78:	1000                	addi	s0,sp,32
    80000b7a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b7c:	00000097          	auipc	ra,0x0
    80000b80:	ea6080e7          	jalr	-346(ra) # 80000a22 <holding>
    80000b84:	c115                	beqz	a0,80000ba8 <release+0x38>
  lk->cpu = 0;
    80000b86:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b8a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b8e:	0f50000f          	fence	iorw,ow
    80000b92:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	f7a080e7          	jalr	-134(ra) # 80000b10 <pop_off>
}
    80000b9e:	60e2                	ld	ra,24(sp)
    80000ba0:	6442                	ld	s0,16(sp)
    80000ba2:	64a2                	ld	s1,8(sp)
    80000ba4:	6105                	addi	sp,sp,32
    80000ba6:	8082                	ret
    panic("release");
    80000ba8:	00007517          	auipc	a0,0x7
    80000bac:	6b850513          	addi	a0,a0,1720 # 80008260 <userret+0x1d0>
    80000bb0:	00000097          	auipc	ra,0x0
    80000bb4:	9a4080e7          	jalr	-1628(ra) # 80000554 <panic>

0000000080000bb8 <print_lock>:

void
print_lock(struct spinlock *lk)
{
  if(lk->n > 0) 
    80000bb8:	4d14                	lw	a3,24(a0)
    80000bba:	e291                	bnez	a3,80000bbe <print_lock+0x6>
    80000bbc:	8082                	ret
{
    80000bbe:	1141                	addi	sp,sp,-16
    80000bc0:	e406                	sd	ra,8(sp)
    80000bc2:	e022                	sd	s0,0(sp)
    80000bc4:	0800                	addi	s0,sp,16
    printf("lock: %s: #test-and-set %d #acquire() %d\n", lk->name, lk->nts, lk->n);
    80000bc6:	4d50                	lw	a2,28(a0)
    80000bc8:	650c                	ld	a1,8(a0)
    80000bca:	00007517          	auipc	a0,0x7
    80000bce:	69e50513          	addi	a0,a0,1694 # 80008268 <userret+0x1d8>
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	9dc080e7          	jalr	-1572(ra) # 800005ae <printf>
}
    80000bda:	60a2                	ld	ra,8(sp)
    80000bdc:	6402                	ld	s0,0(sp)
    80000bde:	0141                	addi	sp,sp,16
    80000be0:	8082                	ret

0000000080000be2 <sys_ntas>:

uint64
sys_ntas(void)
{
    80000be2:	711d                	addi	sp,sp,-96
    80000be4:	ec86                	sd	ra,88(sp)
    80000be6:	e8a2                	sd	s0,80(sp)
    80000be8:	e4a6                	sd	s1,72(sp)
    80000bea:	e0ca                	sd	s2,64(sp)
    80000bec:	fc4e                	sd	s3,56(sp)
    80000bee:	f852                	sd	s4,48(sp)
    80000bf0:	f456                	sd	s5,40(sp)
    80000bf2:	f05a                	sd	s6,32(sp)
    80000bf4:	ec5e                	sd	s7,24(sp)
    80000bf6:	e862                	sd	s8,16(sp)
    80000bf8:	1080                	addi	s0,sp,96
  int zero = 0;
    80000bfa:	fa042623          	sw	zero,-84(s0)
  int tot = 0;
  
  if (argint(0, &zero) < 0) {
    80000bfe:	fac40593          	addi	a1,s0,-84
    80000c02:	4501                	li	a0,0
    80000c04:	00002097          	auipc	ra,0x2
    80000c08:	f6a080e7          	jalr	-150(ra) # 80002b6e <argint>
    80000c0c:	14054d63          	bltz	a0,80000d66 <sys_ntas+0x184>
    return -1;
  }
  if(zero == 0) {
    80000c10:	fac42783          	lw	a5,-84(s0)
    80000c14:	e78d                	bnez	a5,80000c3e <sys_ntas+0x5c>
    80000c16:	00012797          	auipc	a5,0x12
    80000c1a:	cea78793          	addi	a5,a5,-790 # 80012900 <locks>
    80000c1e:	00014697          	auipc	a3,0x14
    80000c22:	c2268693          	addi	a3,a3,-990 # 80014840 <pid_lock>
    for(int i = 0; i < NLOCK; i++) {
      if(locks[i] == 0)
    80000c26:	6398                	ld	a4,0(a5)
    80000c28:	14070163          	beqz	a4,80000d6a <sys_ntas+0x188>
        break;
      locks[i]->nts = 0;
    80000c2c:	00072e23          	sw	zero,28(a4)
      locks[i]->n = 0;
    80000c30:	00072c23          	sw	zero,24(a4)
    for(int i = 0; i < NLOCK; i++) {
    80000c34:	07a1                	addi	a5,a5,8
    80000c36:	fed798e3          	bne	a5,a3,80000c26 <sys_ntas+0x44>
    }
    return 0;
    80000c3a:	4501                	li	a0,0
    80000c3c:	aa09                	j	80000d4e <sys_ntas+0x16c>
  }

  printf("=== lock kmem/bcache stats\n");
    80000c3e:	00007517          	auipc	a0,0x7
    80000c42:	65a50513          	addi	a0,a0,1626 # 80008298 <userret+0x208>
    80000c46:	00000097          	auipc	ra,0x0
    80000c4a:	968080e7          	jalr	-1688(ra) # 800005ae <printf>
  for(int i = 0; i < NLOCK; i++) {
    80000c4e:	00012b17          	auipc	s6,0x12
    80000c52:	cb2b0b13          	addi	s6,s6,-846 # 80012900 <locks>
    80000c56:	00014b97          	auipc	s7,0x14
    80000c5a:	beab8b93          	addi	s7,s7,-1046 # 80014840 <pid_lock>
  printf("=== lock kmem/bcache stats\n");
    80000c5e:	84da                	mv	s1,s6
  int tot = 0;
    80000c60:	4981                	li	s3,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000c62:	00007a17          	auipc	s4,0x7
    80000c66:	656a0a13          	addi	s4,s4,1622 # 800082b8 <userret+0x228>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000c6a:	00007c17          	auipc	s8,0x7
    80000c6e:	5b6c0c13          	addi	s8,s8,1462 # 80008220 <userret+0x190>
    80000c72:	a829                	j	80000c8c <sys_ntas+0xaa>
      tot += locks[i]->nts;
    80000c74:	00093503          	ld	a0,0(s2)
    80000c78:	4d5c                	lw	a5,28(a0)
    80000c7a:	013789bb          	addw	s3,a5,s3
      print_lock(locks[i]);
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	f3a080e7          	jalr	-198(ra) # 80000bb8 <print_lock>
  for(int i = 0; i < NLOCK; i++) {
    80000c86:	04a1                	addi	s1,s1,8
    80000c88:	05748763          	beq	s1,s7,80000cd6 <sys_ntas+0xf4>
    if(locks[i] == 0)
    80000c8c:	8926                	mv	s2,s1
    80000c8e:	609c                	ld	a5,0(s1)
    80000c90:	c3b9                	beqz	a5,80000cd6 <sys_ntas+0xf4>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000c92:	0087ba83          	ld	s5,8(a5)
    80000c96:	8552                	mv	a0,s4
    80000c98:	00000097          	auipc	ra,0x0
    80000c9c:	25a080e7          	jalr	602(ra) # 80000ef2 <strlen>
    80000ca0:	0005061b          	sext.w	a2,a0
    80000ca4:	85d2                	mv	a1,s4
    80000ca6:	8556                	mv	a0,s5
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	19e080e7          	jalr	414(ra) # 80000e46 <strncmp>
    80000cb0:	d171                	beqz	a0,80000c74 <sys_ntas+0x92>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000cb2:	609c                	ld	a5,0(s1)
    80000cb4:	0087ba83          	ld	s5,8(a5)
    80000cb8:	8562                	mv	a0,s8
    80000cba:	00000097          	auipc	ra,0x0
    80000cbe:	238080e7          	jalr	568(ra) # 80000ef2 <strlen>
    80000cc2:	0005061b          	sext.w	a2,a0
    80000cc6:	85e2                	mv	a1,s8
    80000cc8:	8556                	mv	a0,s5
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	17c080e7          	jalr	380(ra) # 80000e46 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000cd2:	f955                	bnez	a0,80000c86 <sys_ntas+0xa4>
    80000cd4:	b745                	j	80000c74 <sys_ntas+0x92>
    }
  }

  printf("=== top 5 contended locks:\n");
    80000cd6:	00007517          	auipc	a0,0x7
    80000cda:	5ea50513          	addi	a0,a0,1514 # 800082c0 <userret+0x230>
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	8d0080e7          	jalr	-1840(ra) # 800005ae <printf>
    80000ce6:	4a15                	li	s4,5
  int last = 100000000;
    80000ce8:	05f5e537          	lui	a0,0x5f5e
    80000cec:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t= 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80000cf0:	4a81                	li	s5,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000cf2:	00012497          	auipc	s1,0x12
    80000cf6:	c0e48493          	addi	s1,s1,-1010 # 80012900 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80000cfa:	3e800913          	li	s2,1000
    80000cfe:	a091                	j	80000d42 <sys_ntas+0x160>
    80000d00:	2705                	addiw	a4,a4,1
    80000d02:	06a1                	addi	a3,a3,8
    80000d04:	03270063          	beq	a4,s2,80000d24 <sys_ntas+0x142>
      if(locks[i] == 0)
    80000d08:	629c                	ld	a5,0(a3)
    80000d0a:	cf89                	beqz	a5,80000d24 <sys_ntas+0x142>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d0c:	4fd0                	lw	a2,28(a5)
    80000d0e:	00359793          	slli	a5,a1,0x3
    80000d12:	97a6                	add	a5,a5,s1
    80000d14:	639c                	ld	a5,0(a5)
    80000d16:	4fdc                	lw	a5,28(a5)
    80000d18:	fec7f4e3          	bgeu	a5,a2,80000d00 <sys_ntas+0x11e>
    80000d1c:	fea672e3          	bgeu	a2,a0,80000d00 <sys_ntas+0x11e>
    80000d20:	85ba                	mv	a1,a4
    80000d22:	bff9                	j	80000d00 <sys_ntas+0x11e>
        top = i;
      }
    }
    print_lock(locks[top]);
    80000d24:	058e                	slli	a1,a1,0x3
    80000d26:	00b48bb3          	add	s7,s1,a1
    80000d2a:	000bb503          	ld	a0,0(s7)
    80000d2e:	00000097          	auipc	ra,0x0
    80000d32:	e8a080e7          	jalr	-374(ra) # 80000bb8 <print_lock>
    last = locks[top]->nts;
    80000d36:	000bb783          	ld	a5,0(s7)
    80000d3a:	4fc8                	lw	a0,28(a5)
  for(int t= 0; t < 5; t++) {
    80000d3c:	3a7d                	addiw	s4,s4,-1
    80000d3e:	000a0763          	beqz	s4,80000d4c <sys_ntas+0x16a>
  int tot = 0;
    80000d42:	86da                	mv	a3,s6
    for(int i = 0; i < NLOCK; i++) {
    80000d44:	8756                	mv	a4,s5
    int top = 0;
    80000d46:	85d6                	mv	a1,s5
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d48:	2501                	sext.w	a0,a0
    80000d4a:	bf7d                	j	80000d08 <sys_ntas+0x126>
  }
  return tot;
    80000d4c:	854e                	mv	a0,s3
}
    80000d4e:	60e6                	ld	ra,88(sp)
    80000d50:	6446                	ld	s0,80(sp)
    80000d52:	64a6                	ld	s1,72(sp)
    80000d54:	6906                	ld	s2,64(sp)
    80000d56:	79e2                	ld	s3,56(sp)
    80000d58:	7a42                	ld	s4,48(sp)
    80000d5a:	7aa2                	ld	s5,40(sp)
    80000d5c:	7b02                	ld	s6,32(sp)
    80000d5e:	6be2                	ld	s7,24(sp)
    80000d60:	6c42                	ld	s8,16(sp)
    80000d62:	6125                	addi	sp,sp,96
    80000d64:	8082                	ret
    return -1;
    80000d66:	557d                	li	a0,-1
    80000d68:	b7dd                	j	80000d4e <sys_ntas+0x16c>
    return 0;
    80000d6a:	4501                	li	a0,0
    80000d6c:	b7cd                	j	80000d4e <sys_ntas+0x16c>

0000000080000d6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d6e:	1141                	addi	sp,sp,-16
    80000d70:	e422                	sd	s0,8(sp)
    80000d72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d74:	ca19                	beqz	a2,80000d8a <memset+0x1c>
    80000d76:	87aa                	mv	a5,a0
    80000d78:	1602                	slli	a2,a2,0x20
    80000d7a:	9201                	srli	a2,a2,0x20
    80000d7c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d80:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d84:	0785                	addi	a5,a5,1
    80000d86:	fee79de3          	bne	a5,a4,80000d80 <memset+0x12>
  }
  return dst;
}
    80000d8a:	6422                	ld	s0,8(sp)
    80000d8c:	0141                	addi	sp,sp,16
    80000d8e:	8082                	ret

0000000080000d90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e422                	sd	s0,8(sp)
    80000d94:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d96:	ca05                	beqz	a2,80000dc6 <memcmp+0x36>
    80000d98:	fff6069b          	addiw	a3,a2,-1
    80000d9c:	1682                	slli	a3,a3,0x20
    80000d9e:	9281                	srli	a3,a3,0x20
    80000da0:	0685                	addi	a3,a3,1
    80000da2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000da4:	00054783          	lbu	a5,0(a0)
    80000da8:	0005c703          	lbu	a4,0(a1)
    80000dac:	00e79863          	bne	a5,a4,80000dbc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000db0:	0505                	addi	a0,a0,1
    80000db2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000db4:	fed518e3          	bne	a0,a3,80000da4 <memcmp+0x14>
  }

  return 0;
    80000db8:	4501                	li	a0,0
    80000dba:	a019                	j	80000dc0 <memcmp+0x30>
      return *s1 - *s2;
    80000dbc:	40e7853b          	subw	a0,a5,a4
}
    80000dc0:	6422                	ld	s0,8(sp)
    80000dc2:	0141                	addi	sp,sp,16
    80000dc4:	8082                	ret
  return 0;
    80000dc6:	4501                	li	a0,0
    80000dc8:	bfe5                	j	80000dc0 <memcmp+0x30>

0000000080000dca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000dd0:	02a5e563          	bltu	a1,a0,80000dfa <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dd4:	fff6069b          	addiw	a3,a2,-1
    80000dd8:	ce11                	beqz	a2,80000df4 <memmove+0x2a>
    80000dda:	1682                	slli	a3,a3,0x20
    80000ddc:	9281                	srli	a3,a3,0x20
    80000dde:	0685                	addi	a3,a3,1
    80000de0:	96ae                	add	a3,a3,a1
    80000de2:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	0785                	addi	a5,a5,1
    80000de8:	fff5c703          	lbu	a4,-1(a1)
    80000dec:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000df0:	fed59ae3          	bne	a1,a3,80000de4 <memmove+0x1a>

  return dst;
}
    80000df4:	6422                	ld	s0,8(sp)
    80000df6:	0141                	addi	sp,sp,16
    80000df8:	8082                	ret
  if(s < d && s + n > d){
    80000dfa:	02061713          	slli	a4,a2,0x20
    80000dfe:	9301                	srli	a4,a4,0x20
    80000e00:	00e587b3          	add	a5,a1,a4
    80000e04:	fcf578e3          	bgeu	a0,a5,80000dd4 <memmove+0xa>
    d += n;
    80000e08:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000e0a:	fff6069b          	addiw	a3,a2,-1
    80000e0e:	d27d                	beqz	a2,80000df4 <memmove+0x2a>
    80000e10:	02069613          	slli	a2,a3,0x20
    80000e14:	9201                	srli	a2,a2,0x20
    80000e16:	fff64613          	not	a2,a2
    80000e1a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000e1c:	17fd                	addi	a5,a5,-1
    80000e1e:	177d                	addi	a4,a4,-1
    80000e20:	0007c683          	lbu	a3,0(a5)
    80000e24:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000e28:	fef61ae3          	bne	a2,a5,80000e1c <memmove+0x52>
    80000e2c:	b7e1                	j	80000df4 <memmove+0x2a>

0000000080000e2e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e2e:	1141                	addi	sp,sp,-16
    80000e30:	e406                	sd	ra,8(sp)
    80000e32:	e022                	sd	s0,0(sp)
    80000e34:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e36:	00000097          	auipc	ra,0x0
    80000e3a:	f94080e7          	jalr	-108(ra) # 80000dca <memmove>
}
    80000e3e:	60a2                	ld	ra,8(sp)
    80000e40:	6402                	ld	s0,0(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e4c:	ce11                	beqz	a2,80000e68 <strncmp+0x22>
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	cf89                	beqz	a5,80000e6c <strncmp+0x26>
    80000e54:	0005c703          	lbu	a4,0(a1)
    80000e58:	00f71a63          	bne	a4,a5,80000e6c <strncmp+0x26>
    n--, p++, q++;
    80000e5c:	367d                	addiw	a2,a2,-1
    80000e5e:	0505                	addi	a0,a0,1
    80000e60:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e62:	f675                	bnez	a2,80000e4e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e64:	4501                	li	a0,0
    80000e66:	a809                	j	80000e78 <strncmp+0x32>
    80000e68:	4501                	li	a0,0
    80000e6a:	a039                	j	80000e78 <strncmp+0x32>
  if(n == 0)
    80000e6c:	ca09                	beqz	a2,80000e7e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e6e:	00054503          	lbu	a0,0(a0)
    80000e72:	0005c783          	lbu	a5,0(a1)
    80000e76:	9d1d                	subw	a0,a0,a5
}
    80000e78:	6422                	ld	s0,8(sp)
    80000e7a:	0141                	addi	sp,sp,16
    80000e7c:	8082                	ret
    return 0;
    80000e7e:	4501                	li	a0,0
    80000e80:	bfe5                	j	80000e78 <strncmp+0x32>

0000000080000e82 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e422                	sd	s0,8(sp)
    80000e86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e88:	872a                	mv	a4,a0
    80000e8a:	8832                	mv	a6,a2
    80000e8c:	367d                	addiw	a2,a2,-1
    80000e8e:	01005963          	blez	a6,80000ea0 <strncpy+0x1e>
    80000e92:	0705                	addi	a4,a4,1
    80000e94:	0005c783          	lbu	a5,0(a1)
    80000e98:	fef70fa3          	sb	a5,-1(a4)
    80000e9c:	0585                	addi	a1,a1,1
    80000e9e:	f7f5                	bnez	a5,80000e8a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ea0:	86ba                	mv	a3,a4
    80000ea2:	00c05c63          	blez	a2,80000eba <strncpy+0x38>
    *s++ = 0;
    80000ea6:	0685                	addi	a3,a3,1
    80000ea8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000eac:	fff6c793          	not	a5,a3
    80000eb0:	9fb9                	addw	a5,a5,a4
    80000eb2:	010787bb          	addw	a5,a5,a6
    80000eb6:	fef048e3          	bgtz	a5,80000ea6 <strncpy+0x24>
  return os;
}
    80000eba:	6422                	ld	s0,8(sp)
    80000ebc:	0141                	addi	sp,sp,16
    80000ebe:	8082                	ret

0000000080000ec0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e422                	sd	s0,8(sp)
    80000ec4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000ec6:	02c05363          	blez	a2,80000eec <safestrcpy+0x2c>
    80000eca:	fff6069b          	addiw	a3,a2,-1
    80000ece:	1682                	slli	a3,a3,0x20
    80000ed0:	9281                	srli	a3,a3,0x20
    80000ed2:	96ae                	add	a3,a3,a1
    80000ed4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ed6:	00d58963          	beq	a1,a3,80000ee8 <safestrcpy+0x28>
    80000eda:	0585                	addi	a1,a1,1
    80000edc:	0785                	addi	a5,a5,1
    80000ede:	fff5c703          	lbu	a4,-1(a1)
    80000ee2:	fee78fa3          	sb	a4,-1(a5)
    80000ee6:	fb65                	bnez	a4,80000ed6 <safestrcpy+0x16>
    ;
  *s = 0;
    80000ee8:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eec:	6422                	ld	s0,8(sp)
    80000eee:	0141                	addi	sp,sp,16
    80000ef0:	8082                	ret

0000000080000ef2 <strlen>:

int
strlen(const char *s)
{
    80000ef2:	1141                	addi	sp,sp,-16
    80000ef4:	e422                	sd	s0,8(sp)
    80000ef6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ef8:	00054783          	lbu	a5,0(a0)
    80000efc:	cf91                	beqz	a5,80000f18 <strlen+0x26>
    80000efe:	0505                	addi	a0,a0,1
    80000f00:	87aa                	mv	a5,a0
    80000f02:	4685                	li	a3,1
    80000f04:	9e89                	subw	a3,a3,a0
    80000f06:	00f6853b          	addw	a0,a3,a5
    80000f0a:	0785                	addi	a5,a5,1
    80000f0c:	fff7c703          	lbu	a4,-1(a5)
    80000f10:	fb7d                	bnez	a4,80000f06 <strlen+0x14>
    ;
  return n;
}
    80000f12:	6422                	ld	s0,8(sp)
    80000f14:	0141                	addi	sp,sp,16
    80000f16:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f18:	4501                	li	a0,0
    80000f1a:	bfe5                	j	80000f12 <strlen+0x20>

0000000080000f1c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f1c:	1141                	addi	sp,sp,-16
    80000f1e:	e406                	sd	ra,8(sp)
    80000f20:	e022                	sd	s0,0(sp)
    80000f22:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f24:	00001097          	auipc	ra,0x1
    80000f28:	b08080e7          	jalr	-1272(ra) # 80001a2c <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f2c:	00027717          	auipc	a4,0x27
    80000f30:	0fc70713          	addi	a4,a4,252 # 80028028 <started>
  if(cpuid() == 0){
    80000f34:	c139                	beqz	a0,80000f7a <main+0x5e>
    while(started == 0)
    80000f36:	431c                	lw	a5,0(a4)
    80000f38:	2781                	sext.w	a5,a5
    80000f3a:	dff5                	beqz	a5,80000f36 <main+0x1a>
      ;
    __sync_synchronize();
    80000f3c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f40:	00001097          	auipc	ra,0x1
    80000f44:	aec080e7          	jalr	-1300(ra) # 80001a2c <cpuid>
    80000f48:	85aa                	mv	a1,a0
    80000f4a:	00007517          	auipc	a0,0x7
    80000f4e:	3ae50513          	addi	a0,a0,942 # 800082f8 <userret+0x268>
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	65c080e7          	jalr	1628(ra) # 800005ae <printf>
    kvminithart();    // turn on paging
    80000f5a:	00000097          	auipc	ra,0x0
    80000f5e:	1ea080e7          	jalr	490(ra) # 80001144 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f62:	00001097          	auipc	ra,0x1
    80000f66:	798080e7          	jalr	1944(ra) # 800026fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	e66080e7          	jalr	-410(ra) # 80005dd0 <plicinithart>
  }

  scheduler();        
    80000f72:	00001097          	auipc	ra,0x1
    80000f76:	fc4080e7          	jalr	-60(ra) # 80001f36 <scheduler>
    consoleinit();
    80000f7a:	fffff097          	auipc	ra,0xfffff
    80000f7e:	4ec080e7          	jalr	1260(ra) # 80000466 <consoleinit>
    printfinit();
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	80c080e7          	jalr	-2036(ra) # 8000078e <printfinit>
    printf("\n");
    80000f8a:	00007517          	auipc	a0,0x7
    80000f8e:	30650513          	addi	a0,a0,774 # 80008290 <userret+0x200>
    80000f92:	fffff097          	auipc	ra,0xfffff
    80000f96:	61c080e7          	jalr	1564(ra) # 800005ae <printf>
    printf("xv6 kernel is booting\n");
    80000f9a:	00007517          	auipc	a0,0x7
    80000f9e:	34650513          	addi	a0,a0,838 # 800082e0 <userret+0x250>
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	60c080e7          	jalr	1548(ra) # 800005ae <printf>
    printf("\n");
    80000faa:	00007517          	auipc	a0,0x7
    80000fae:	2e650513          	addi	a0,a0,742 # 80008290 <userret+0x200>
    80000fb2:	fffff097          	auipc	ra,0xfffff
    80000fb6:	5fc080e7          	jalr	1532(ra) # 800005ae <printf>
    kinit();         // physical page allocator
    80000fba:	00000097          	auipc	ra,0x0
    80000fbe:	976080e7          	jalr	-1674(ra) # 80000930 <kinit>
    kvminit();       // create kernel page table
    80000fc2:	00000097          	auipc	ra,0x0
    80000fc6:	30c080e7          	jalr	780(ra) # 800012ce <kvminit>
    kvminithart();   // turn on paging
    80000fca:	00000097          	auipc	ra,0x0
    80000fce:	17a080e7          	jalr	378(ra) # 80001144 <kvminithart>
    procinit();      // process table
    80000fd2:	00001097          	auipc	ra,0x1
    80000fd6:	98a080e7          	jalr	-1654(ra) # 8000195c <procinit>
    trapinit();      // trap vectors
    80000fda:	00001097          	auipc	ra,0x1
    80000fde:	6f8080e7          	jalr	1784(ra) # 800026d2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fe2:	00001097          	auipc	ra,0x1
    80000fe6:	718080e7          	jalr	1816(ra) # 800026fa <trapinithart>
    plicinit();      // set up interrupt controller
    80000fea:	00005097          	auipc	ra,0x5
    80000fee:	dd0080e7          	jalr	-560(ra) # 80005dba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ff2:	00005097          	auipc	ra,0x5
    80000ff6:	dde080e7          	jalr	-546(ra) # 80005dd0 <plicinithart>
    binit();         // buffer cache
    80000ffa:	00002097          	auipc	ra,0x2
    80000ffe:	e54080e7          	jalr	-428(ra) # 80002e4e <binit>
    iinit();         // inode cache
    80001002:	00002097          	auipc	ra,0x2
    80001006:	4ea080e7          	jalr	1258(ra) # 800034ec <iinit>
    fileinit();      // file table
    8000100a:	00003097          	auipc	ra,0x3
    8000100e:	576080e7          	jalr	1398(ra) # 80004580 <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80001012:	4501                	li	a0,0
    80001014:	00005097          	auipc	ra,0x5
    80001018:	ede080e7          	jalr	-290(ra) # 80005ef2 <virtio_disk_init>
    userinit();      // first user process
    8000101c:	00001097          	auipc	ra,0x1
    80001020:	cb0080e7          	jalr	-848(ra) # 80001ccc <userinit>
    __sync_synchronize();
    80001024:	0ff0000f          	fence
    started = 1;
    80001028:	4785                	li	a5,1
    8000102a:	00027717          	auipc	a4,0x27
    8000102e:	fef72f23          	sw	a5,-2(a4) # 80028028 <started>
    80001032:	b781                	j	80000f72 <main+0x56>

0000000080001034 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001034:	7139                	addi	sp,sp,-64
    80001036:	fc06                	sd	ra,56(sp)
    80001038:	f822                	sd	s0,48(sp)
    8000103a:	f426                	sd	s1,40(sp)
    8000103c:	f04a                	sd	s2,32(sp)
    8000103e:	ec4e                	sd	s3,24(sp)
    80001040:	e852                	sd	s4,16(sp)
    80001042:	e456                	sd	s5,8(sp)
    80001044:	e05a                	sd	s6,0(sp)
    80001046:	0080                	addi	s0,sp,64
    80001048:	84aa                	mv	s1,a0
    8000104a:	89ae                	mv	s3,a1
    8000104c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000104e:	57fd                	li	a5,-1
    80001050:	83e9                	srli	a5,a5,0x1a
    80001052:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001054:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001056:	04b7f263          	bgeu	a5,a1,8000109a <walk+0x66>
    panic("walk");
    8000105a:	00007517          	auipc	a0,0x7
    8000105e:	2b650513          	addi	a0,a0,694 # 80008310 <userret+0x280>
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	4f2080e7          	jalr	1266(ra) # 80000554 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000106a:	060a8663          	beqz	s5,800010d6 <walk+0xa2>
    8000106e:	00000097          	auipc	ra,0x0
    80001072:	8fe080e7          	jalr	-1794(ra) # 8000096c <kalloc>
    80001076:	84aa                	mv	s1,a0
    80001078:	c529                	beqz	a0,800010c2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000107a:	6605                	lui	a2,0x1
    8000107c:	4581                	li	a1,0
    8000107e:	00000097          	auipc	ra,0x0
    80001082:	cf0080e7          	jalr	-784(ra) # 80000d6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001086:	00c4d793          	srli	a5,s1,0xc
    8000108a:	07aa                	slli	a5,a5,0xa
    8000108c:	0017e793          	ori	a5,a5,1
    80001090:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001094:	3a5d                	addiw	s4,s4,-9
    80001096:	036a0063          	beq	s4,s6,800010b6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000109a:	0149d933          	srl	s2,s3,s4
    8000109e:	1ff97913          	andi	s2,s2,511
    800010a2:	090e                	slli	s2,s2,0x3
    800010a4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010a6:	00093483          	ld	s1,0(s2)
    800010aa:	0014f793          	andi	a5,s1,1
    800010ae:	dfd5                	beqz	a5,8000106a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010b0:	80a9                	srli	s1,s1,0xa
    800010b2:	04b2                	slli	s1,s1,0xc
    800010b4:	b7c5                	j	80001094 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010b6:	00c9d513          	srli	a0,s3,0xc
    800010ba:	1ff57513          	andi	a0,a0,511
    800010be:	050e                	slli	a0,a0,0x3
    800010c0:	9526                	add	a0,a0,s1
}
    800010c2:	70e2                	ld	ra,56(sp)
    800010c4:	7442                	ld	s0,48(sp)
    800010c6:	74a2                	ld	s1,40(sp)
    800010c8:	7902                	ld	s2,32(sp)
    800010ca:	69e2                	ld	s3,24(sp)
    800010cc:	6a42                	ld	s4,16(sp)
    800010ce:	6aa2                	ld	s5,8(sp)
    800010d0:	6b02                	ld	s6,0(sp)
    800010d2:	6121                	addi	sp,sp,64
    800010d4:	8082                	ret
        return 0;
    800010d6:	4501                	li	a0,0
    800010d8:	b7ed                	j	800010c2 <walk+0x8e>

00000000800010da <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    800010da:	7179                	addi	sp,sp,-48
    800010dc:	f406                	sd	ra,40(sp)
    800010de:	f022                	sd	s0,32(sp)
    800010e0:	ec26                	sd	s1,24(sp)
    800010e2:	e84a                	sd	s2,16(sp)
    800010e4:	e44e                	sd	s3,8(sp)
    800010e6:	e052                	sd	s4,0(sp)
    800010e8:	1800                	addi	s0,sp,48
    800010ea:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800010ec:	84aa                	mv	s1,a0
    800010ee:	6905                	lui	s2,0x1
    800010f0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800010f2:	4985                	li	s3,1
    800010f4:	a821                	j	8000110c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800010f6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800010f8:	0532                	slli	a0,a0,0xc
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	fe0080e7          	jalr	-32(ra) # 800010da <freewalk>
      pagetable[i] = 0;
    80001102:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001106:	04a1                	addi	s1,s1,8
    80001108:	03248163          	beq	s1,s2,8000112a <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000110c:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000110e:	00f57793          	andi	a5,a0,15
    80001112:	ff3782e3          	beq	a5,s3,800010f6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001116:	8905                	andi	a0,a0,1
    80001118:	d57d                	beqz	a0,80001106 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000111a:	00007517          	auipc	a0,0x7
    8000111e:	1fe50513          	addi	a0,a0,510 # 80008318 <userret+0x288>
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	432080e7          	jalr	1074(ra) # 80000554 <panic>
    }
  }
  kfree((void*)pagetable);
    8000112a:	8552                	mv	a0,s4
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	744080e7          	jalr	1860(ra) # 80000870 <kfree>
}
    80001134:	70a2                	ld	ra,40(sp)
    80001136:	7402                	ld	s0,32(sp)
    80001138:	64e2                	ld	s1,24(sp)
    8000113a:	6942                	ld	s2,16(sp)
    8000113c:	69a2                	ld	s3,8(sp)
    8000113e:	6a02                	ld	s4,0(sp)
    80001140:	6145                	addi	sp,sp,48
    80001142:	8082                	ret

0000000080001144 <kvminithart>:
{
    80001144:	1141                	addi	sp,sp,-16
    80001146:	e422                	sd	s0,8(sp)
    80001148:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000114a:	00027797          	auipc	a5,0x27
    8000114e:	ee67b783          	ld	a5,-282(a5) # 80028030 <kernel_pagetable>
    80001152:	83b1                	srli	a5,a5,0xc
    80001154:	577d                	li	a4,-1
    80001156:	177e                	slli	a4,a4,0x3f
    80001158:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000115a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000115e:	12000073          	sfence.vma
}
    80001162:	6422                	ld	s0,8(sp)
    80001164:	0141                	addi	sp,sp,16
    80001166:	8082                	ret

0000000080001168 <walkaddr>:
  if(va >= MAXVA)
    80001168:	57fd                	li	a5,-1
    8000116a:	83e9                	srli	a5,a5,0x1a
    8000116c:	00b7f463          	bgeu	a5,a1,80001174 <walkaddr+0xc>
    return 0;
    80001170:	4501                	li	a0,0
}
    80001172:	8082                	ret
{
    80001174:	1141                	addi	sp,sp,-16
    80001176:	e406                	sd	ra,8(sp)
    80001178:	e022                	sd	s0,0(sp)
    8000117a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000117c:	4601                	li	a2,0
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	eb6080e7          	jalr	-330(ra) # 80001034 <walk>
  if(pte == 0)
    80001186:	c105                	beqz	a0,800011a6 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001188:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000118a:	0117f693          	andi	a3,a5,17
    8000118e:	4745                	li	a4,17
    return 0;
    80001190:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001192:	00e68663          	beq	a3,a4,8000119e <walkaddr+0x36>
}
    80001196:	60a2                	ld	ra,8(sp)
    80001198:	6402                	ld	s0,0(sp)
    8000119a:	0141                	addi	sp,sp,16
    8000119c:	8082                	ret
  pa = PTE2PA(*pte);
    8000119e:	00a7d513          	srli	a0,a5,0xa
    800011a2:	0532                	slli	a0,a0,0xc
  return pa;
    800011a4:	bfcd                	j	80001196 <walkaddr+0x2e>
    return 0;
    800011a6:	4501                	li	a0,0
    800011a8:	b7fd                	j	80001196 <walkaddr+0x2e>

00000000800011aa <kvmpa>:
{
    800011aa:	1101                	addi	sp,sp,-32
    800011ac:	ec06                	sd	ra,24(sp)
    800011ae:	e822                	sd	s0,16(sp)
    800011b0:	e426                	sd	s1,8(sp)
    800011b2:	1000                	addi	s0,sp,32
    800011b4:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800011b6:	1552                	slli	a0,a0,0x34
    800011b8:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    800011bc:	4601                	li	a2,0
    800011be:	00027517          	auipc	a0,0x27
    800011c2:	e7253503          	ld	a0,-398(a0) # 80028030 <kernel_pagetable>
    800011c6:	00000097          	auipc	ra,0x0
    800011ca:	e6e080e7          	jalr	-402(ra) # 80001034 <walk>
  if(pte == 0)
    800011ce:	cd09                	beqz	a0,800011e8 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    800011d0:	6108                	ld	a0,0(a0)
    800011d2:	00157793          	andi	a5,a0,1
    800011d6:	c38d                	beqz	a5,800011f8 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    800011d8:	8129                	srli	a0,a0,0xa
    800011da:	0532                	slli	a0,a0,0xc
}
    800011dc:	9526                	add	a0,a0,s1
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret
    panic("kvmpa");
    800011e8:	00007517          	auipc	a0,0x7
    800011ec:	14050513          	addi	a0,a0,320 # 80008328 <userret+0x298>
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	364080e7          	jalr	868(ra) # 80000554 <panic>
    panic("kvmpa");
    800011f8:	00007517          	auipc	a0,0x7
    800011fc:	13050513          	addi	a0,a0,304 # 80008328 <userret+0x298>
    80001200:	fffff097          	auipc	ra,0xfffff
    80001204:	354080e7          	jalr	852(ra) # 80000554 <panic>

0000000080001208 <mappages>:
{
    80001208:	715d                	addi	sp,sp,-80
    8000120a:	e486                	sd	ra,72(sp)
    8000120c:	e0a2                	sd	s0,64(sp)
    8000120e:	fc26                	sd	s1,56(sp)
    80001210:	f84a                	sd	s2,48(sp)
    80001212:	f44e                	sd	s3,40(sp)
    80001214:	f052                	sd	s4,32(sp)
    80001216:	ec56                	sd	s5,24(sp)
    80001218:	e85a                	sd	s6,16(sp)
    8000121a:	e45e                	sd	s7,8(sp)
    8000121c:	0880                	addi	s0,sp,80
    8000121e:	8aaa                	mv	s5,a0
    80001220:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001222:	777d                	lui	a4,0xfffff
    80001224:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001228:	167d                	addi	a2,a2,-1
    8000122a:	00b609b3          	add	s3,a2,a1
    8000122e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001232:	893e                	mv	s2,a5
    80001234:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001238:	6b85                	lui	s7,0x1
    8000123a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000123e:	4605                	li	a2,1
    80001240:	85ca                	mv	a1,s2
    80001242:	8556                	mv	a0,s5
    80001244:	00000097          	auipc	ra,0x0
    80001248:	df0080e7          	jalr	-528(ra) # 80001034 <walk>
    8000124c:	c51d                	beqz	a0,8000127a <mappages+0x72>
    if(*pte & PTE_V)
    8000124e:	611c                	ld	a5,0(a0)
    80001250:	8b85                	andi	a5,a5,1
    80001252:	ef81                	bnez	a5,8000126a <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001254:	80b1                	srli	s1,s1,0xc
    80001256:	04aa                	slli	s1,s1,0xa
    80001258:	0164e4b3          	or	s1,s1,s6
    8000125c:	0014e493          	ori	s1,s1,1
    80001260:	e104                	sd	s1,0(a0)
    if(a == last)
    80001262:	03390863          	beq	s2,s3,80001292 <mappages+0x8a>
    a += PGSIZE;
    80001266:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001268:	bfc9                	j	8000123a <mappages+0x32>
      panic("remap");
    8000126a:	00007517          	auipc	a0,0x7
    8000126e:	0c650513          	addi	a0,a0,198 # 80008330 <userret+0x2a0>
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	2e2080e7          	jalr	738(ra) # 80000554 <panic>
      return -1;
    8000127a:	557d                	li	a0,-1
}
    8000127c:	60a6                	ld	ra,72(sp)
    8000127e:	6406                	ld	s0,64(sp)
    80001280:	74e2                	ld	s1,56(sp)
    80001282:	7942                	ld	s2,48(sp)
    80001284:	79a2                	ld	s3,40(sp)
    80001286:	7a02                	ld	s4,32(sp)
    80001288:	6ae2                	ld	s5,24(sp)
    8000128a:	6b42                	ld	s6,16(sp)
    8000128c:	6ba2                	ld	s7,8(sp)
    8000128e:	6161                	addi	sp,sp,80
    80001290:	8082                	ret
  return 0;
    80001292:	4501                	li	a0,0
    80001294:	b7e5                	j	8000127c <mappages+0x74>

0000000080001296 <kvmmap>:
{
    80001296:	1141                	addi	sp,sp,-16
    80001298:	e406                	sd	ra,8(sp)
    8000129a:	e022                	sd	s0,0(sp)
    8000129c:	0800                	addi	s0,sp,16
    8000129e:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800012a0:	86ae                	mv	a3,a1
    800012a2:	85aa                	mv	a1,a0
    800012a4:	00027517          	auipc	a0,0x27
    800012a8:	d8c53503          	ld	a0,-628(a0) # 80028030 <kernel_pagetable>
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	f5c080e7          	jalr	-164(ra) # 80001208 <mappages>
    800012b4:	e509                	bnez	a0,800012be <kvmmap+0x28>
}
    800012b6:	60a2                	ld	ra,8(sp)
    800012b8:	6402                	ld	s0,0(sp)
    800012ba:	0141                	addi	sp,sp,16
    800012bc:	8082                	ret
    panic("kvmmap");
    800012be:	00007517          	auipc	a0,0x7
    800012c2:	07a50513          	addi	a0,a0,122 # 80008338 <userret+0x2a8>
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	28e080e7          	jalr	654(ra) # 80000554 <panic>

00000000800012ce <kvminit>:
{
    800012ce:	1101                	addi	sp,sp,-32
    800012d0:	ec06                	sd	ra,24(sp)
    800012d2:	e822                	sd	s0,16(sp)
    800012d4:	e426                	sd	s1,8(sp)
    800012d6:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	694080e7          	jalr	1684(ra) # 8000096c <kalloc>
    800012e0:	00027797          	auipc	a5,0x27
    800012e4:	d4a7b823          	sd	a0,-688(a5) # 80028030 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800012e8:	6605                	lui	a2,0x1
    800012ea:	4581                	li	a1,0
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	a82080e7          	jalr	-1406(ra) # 80000d6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012f4:	4699                	li	a3,6
    800012f6:	6605                	lui	a2,0x1
    800012f8:	100005b7          	lui	a1,0x10000
    800012fc:	10000537          	lui	a0,0x10000
    80001300:	00000097          	auipc	ra,0x0
    80001304:	f96080e7          	jalr	-106(ra) # 80001296 <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    80001308:	4699                	li	a3,6
    8000130a:	6605                	lui	a2,0x1
    8000130c:	100015b7          	lui	a1,0x10001
    80001310:	10001537          	lui	a0,0x10001
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f82080e7          	jalr	-126(ra) # 80001296 <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    8000131c:	4699                	li	a3,6
    8000131e:	6605                	lui	a2,0x1
    80001320:	100025b7          	lui	a1,0x10002
    80001324:	10002537          	lui	a0,0x10002
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	f6e080e7          	jalr	-146(ra) # 80001296 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001330:	4699                	li	a3,6
    80001332:	6641                	lui	a2,0x10
    80001334:	020005b7          	lui	a1,0x2000
    80001338:	02000537          	lui	a0,0x2000
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f5a080e7          	jalr	-166(ra) # 80001296 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001344:	4699                	li	a3,6
    80001346:	00400637          	lui	a2,0x400
    8000134a:	0c0005b7          	lui	a1,0xc000
    8000134e:	0c000537          	lui	a0,0xc000
    80001352:	00000097          	auipc	ra,0x0
    80001356:	f44080e7          	jalr	-188(ra) # 80001296 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000135a:	00008497          	auipc	s1,0x8
    8000135e:	ca648493          	addi	s1,s1,-858 # 80009000 <initcode>
    80001362:	46a9                	li	a3,10
    80001364:	80008617          	auipc	a2,0x80008
    80001368:	c9c60613          	addi	a2,a2,-868 # 9000 <_entry-0x7fff7000>
    8000136c:	4585                	li	a1,1
    8000136e:	05fe                	slli	a1,a1,0x1f
    80001370:	852e                	mv	a0,a1
    80001372:	00000097          	auipc	ra,0x0
    80001376:	f24080e7          	jalr	-220(ra) # 80001296 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000137a:	4699                	li	a3,6
    8000137c:	4645                	li	a2,17
    8000137e:	066e                	slli	a2,a2,0x1b
    80001380:	8e05                	sub	a2,a2,s1
    80001382:	85a6                	mv	a1,s1
    80001384:	8526                	mv	a0,s1
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	f10080e7          	jalr	-240(ra) # 80001296 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000138e:	46a9                	li	a3,10
    80001390:	6605                	lui	a2,0x1
    80001392:	00007597          	auipc	a1,0x7
    80001396:	c6e58593          	addi	a1,a1,-914 # 80008000 <trampoline>
    8000139a:	04000537          	lui	a0,0x4000
    8000139e:	157d                	addi	a0,a0,-1
    800013a0:	0532                	slli	a0,a0,0xc
    800013a2:	00000097          	auipc	ra,0x0
    800013a6:	ef4080e7          	jalr	-268(ra) # 80001296 <kvmmap>
}
    800013aa:	60e2                	ld	ra,24(sp)
    800013ac:	6442                	ld	s0,16(sp)
    800013ae:	64a2                	ld	s1,8(sp)
    800013b0:	6105                	addi	sp,sp,32
    800013b2:	8082                	ret

00000000800013b4 <uvmunmap>:
{
    800013b4:	715d                	addi	sp,sp,-80
    800013b6:	e486                	sd	ra,72(sp)
    800013b8:	e0a2                	sd	s0,64(sp)
    800013ba:	fc26                	sd	s1,56(sp)
    800013bc:	f84a                	sd	s2,48(sp)
    800013be:	f44e                	sd	s3,40(sp)
    800013c0:	f052                	sd	s4,32(sp)
    800013c2:	ec56                	sd	s5,24(sp)
    800013c4:	e85a                	sd	s6,16(sp)
    800013c6:	e45e                	sd	s7,8(sp)
    800013c8:	0880                	addi	s0,sp,80
    800013ca:	8a2a                	mv	s4,a0
    800013cc:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800013ce:	77fd                	lui	a5,0xfffff
    800013d0:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800013d4:	167d                	addi	a2,a2,-1
    800013d6:	00b609b3          	add	s3,a2,a1
    800013da:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800013de:	4b05                	li	s6,1
    a += PGSIZE;
    800013e0:	6b85                	lui	s7,0x1
    800013e2:	a0b9                	j	80001430 <uvmunmap+0x7c>
      panic("uvmunmap: walk");
    800013e4:	00007517          	auipc	a0,0x7
    800013e8:	f5c50513          	addi	a0,a0,-164 # 80008340 <userret+0x2b0>
    800013ec:	fffff097          	auipc	ra,0xfffff
    800013f0:	168080e7          	jalr	360(ra) # 80000554 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800013f4:	85ca                	mv	a1,s2
    800013f6:	00007517          	auipc	a0,0x7
    800013fa:	f5a50513          	addi	a0,a0,-166 # 80008350 <userret+0x2c0>
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	1b0080e7          	jalr	432(ra) # 800005ae <printf>
      panic("uvmunmap: not mapped");
    80001406:	00007517          	auipc	a0,0x7
    8000140a:	f5a50513          	addi	a0,a0,-166 # 80008360 <userret+0x2d0>
    8000140e:	fffff097          	auipc	ra,0xfffff
    80001412:	146080e7          	jalr	326(ra) # 80000554 <panic>
      panic("uvmunmap: not a leaf");
    80001416:	00007517          	auipc	a0,0x7
    8000141a:	f6250513          	addi	a0,a0,-158 # 80008378 <userret+0x2e8>
    8000141e:	fffff097          	auipc	ra,0xfffff
    80001422:	136080e7          	jalr	310(ra) # 80000554 <panic>
    *pte = 0;
    80001426:	0004b023          	sd	zero,0(s1)
    if(a == last)
    8000142a:	03390e63          	beq	s2,s3,80001466 <uvmunmap+0xb2>
    a += PGSIZE;
    8000142e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001430:	4601                	li	a2,0
    80001432:	85ca                	mv	a1,s2
    80001434:	8552                	mv	a0,s4
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	bfe080e7          	jalr	-1026(ra) # 80001034 <walk>
    8000143e:	84aa                	mv	s1,a0
    80001440:	d155                	beqz	a0,800013e4 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    80001442:	6110                	ld	a2,0(a0)
    80001444:	00167793          	andi	a5,a2,1
    80001448:	d7d5                	beqz	a5,800013f4 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000144a:	3ff67793          	andi	a5,a2,1023
    8000144e:	fd6784e3          	beq	a5,s6,80001416 <uvmunmap+0x62>
    if(do_free){
    80001452:	fc0a8ae3          	beqz	s5,80001426 <uvmunmap+0x72>
      pa = PTE2PA(*pte);
    80001456:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80001458:	00c61513          	slli	a0,a2,0xc
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	414080e7          	jalr	1044(ra) # 80000870 <kfree>
    80001464:	b7c9                	j	80001426 <uvmunmap+0x72>
}
    80001466:	60a6                	ld	ra,72(sp)
    80001468:	6406                	ld	s0,64(sp)
    8000146a:	74e2                	ld	s1,56(sp)
    8000146c:	7942                	ld	s2,48(sp)
    8000146e:	79a2                	ld	s3,40(sp)
    80001470:	7a02                	ld	s4,32(sp)
    80001472:	6ae2                	ld	s5,24(sp)
    80001474:	6b42                	ld	s6,16(sp)
    80001476:	6ba2                	ld	s7,8(sp)
    80001478:	6161                	addi	sp,sp,80
    8000147a:	8082                	ret

000000008000147c <uvmcreate>:
{
    8000147c:	1101                	addi	sp,sp,-32
    8000147e:	ec06                	sd	ra,24(sp)
    80001480:	e822                	sd	s0,16(sp)
    80001482:	e426                	sd	s1,8(sp)
    80001484:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	4e6080e7          	jalr	1254(ra) # 8000096c <kalloc>
  if(pagetable == 0)
    8000148e:	cd11                	beqz	a0,800014aa <uvmcreate+0x2e>
    80001490:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    80001492:	6605                	lui	a2,0x1
    80001494:	4581                	li	a1,0
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	8d8080e7          	jalr	-1832(ra) # 80000d6e <memset>
}
    8000149e:	8526                	mv	a0,s1
    800014a0:	60e2                	ld	ra,24(sp)
    800014a2:	6442                	ld	s0,16(sp)
    800014a4:	64a2                	ld	s1,8(sp)
    800014a6:	6105                	addi	sp,sp,32
    800014a8:	8082                	ret
    panic("uvmcreate: out of memory");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	ee650513          	addi	a0,a0,-282 # 80008390 <userret+0x300>
    800014b2:	fffff097          	auipc	ra,0xfffff
    800014b6:	0a2080e7          	jalr	162(ra) # 80000554 <panic>

00000000800014ba <uvminit>:
{
    800014ba:	7179                	addi	sp,sp,-48
    800014bc:	f406                	sd	ra,40(sp)
    800014be:	f022                	sd	s0,32(sp)
    800014c0:	ec26                	sd	s1,24(sp)
    800014c2:	e84a                	sd	s2,16(sp)
    800014c4:	e44e                	sd	s3,8(sp)
    800014c6:	e052                	sd	s4,0(sp)
    800014c8:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800014ca:	6785                	lui	a5,0x1
    800014cc:	04f67863          	bgeu	a2,a5,8000151c <uvminit+0x62>
    800014d0:	8a2a                	mv	s4,a0
    800014d2:	89ae                	mv	s3,a1
    800014d4:	84b2                	mv	s1,a2
  mem = kalloc();
    800014d6:	fffff097          	auipc	ra,0xfffff
    800014da:	496080e7          	jalr	1174(ra) # 8000096c <kalloc>
    800014de:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014e0:	6605                	lui	a2,0x1
    800014e2:	4581                	li	a1,0
    800014e4:	00000097          	auipc	ra,0x0
    800014e8:	88a080e7          	jalr	-1910(ra) # 80000d6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014ec:	4779                	li	a4,30
    800014ee:	86ca                	mv	a3,s2
    800014f0:	6605                	lui	a2,0x1
    800014f2:	4581                	li	a1,0
    800014f4:	8552                	mv	a0,s4
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	d12080e7          	jalr	-750(ra) # 80001208 <mappages>
  memmove(mem, src, sz);
    800014fe:	8626                	mv	a2,s1
    80001500:	85ce                	mv	a1,s3
    80001502:	854a                	mv	a0,s2
    80001504:	00000097          	auipc	ra,0x0
    80001508:	8c6080e7          	jalr	-1850(ra) # 80000dca <memmove>
}
    8000150c:	70a2                	ld	ra,40(sp)
    8000150e:	7402                	ld	s0,32(sp)
    80001510:	64e2                	ld	s1,24(sp)
    80001512:	6942                	ld	s2,16(sp)
    80001514:	69a2                	ld	s3,8(sp)
    80001516:	6a02                	ld	s4,0(sp)
    80001518:	6145                	addi	sp,sp,48
    8000151a:	8082                	ret
    panic("inituvm: more than a page");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	e9450513          	addi	a0,a0,-364 # 800083b0 <userret+0x320>
    80001524:	fffff097          	auipc	ra,0xfffff
    80001528:	030080e7          	jalr	48(ra) # 80000554 <panic>

000000008000152c <uvmdealloc>:
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
    return oldsz;
    80001536:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001538:	00b67d63          	bgeu	a2,a1,80001552 <uvmdealloc+0x26>
    8000153c:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    8000153e:	6785                	lui	a5,0x1
    80001540:	17fd                	addi	a5,a5,-1
    80001542:	00f60733          	add	a4,a2,a5
    80001546:	76fd                	lui	a3,0xfffff
    80001548:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    8000154a:	97ae                	add	a5,a5,a1
    8000154c:	8ff5                	and	a5,a5,a3
    8000154e:	00f76863          	bltu	a4,a5,8000155e <uvmdealloc+0x32>
}
    80001552:	8526                	mv	a0,s1
    80001554:	60e2                	ld	ra,24(sp)
    80001556:	6442                	ld	s0,16(sp)
    80001558:	64a2                	ld	s1,8(sp)
    8000155a:	6105                	addi	sp,sp,32
    8000155c:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    8000155e:	4685                	li	a3,1
    80001560:	40e58633          	sub	a2,a1,a4
    80001564:	85ba                	mv	a1,a4
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	e4e080e7          	jalr	-434(ra) # 800013b4 <uvmunmap>
    8000156e:	b7d5                	j	80001552 <uvmdealloc+0x26>

0000000080001570 <uvmalloc>:
  if(newsz < oldsz)
    80001570:	0ab66163          	bltu	a2,a1,80001612 <uvmalloc+0xa2>
{
    80001574:	7139                	addi	sp,sp,-64
    80001576:	fc06                	sd	ra,56(sp)
    80001578:	f822                	sd	s0,48(sp)
    8000157a:	f426                	sd	s1,40(sp)
    8000157c:	f04a                	sd	s2,32(sp)
    8000157e:	ec4e                	sd	s3,24(sp)
    80001580:	e852                	sd	s4,16(sp)
    80001582:	e456                	sd	s5,8(sp)
    80001584:	0080                	addi	s0,sp,64
    80001586:	8aaa                	mv	s5,a0
    80001588:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000158a:	6985                	lui	s3,0x1
    8000158c:	19fd                	addi	s3,s3,-1
    8000158e:	95ce                	add	a1,a1,s3
    80001590:	79fd                	lui	s3,0xfffff
    80001592:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    80001596:	08c9f063          	bgeu	s3,a2,80001616 <uvmalloc+0xa6>
  a = oldsz;
    8000159a:	894e                	mv	s2,s3
    mem = kalloc();
    8000159c:	fffff097          	auipc	ra,0xfffff
    800015a0:	3d0080e7          	jalr	976(ra) # 8000096c <kalloc>
    800015a4:	84aa                	mv	s1,a0
    if(mem == 0){
    800015a6:	c51d                	beqz	a0,800015d4 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800015a8:	6605                	lui	a2,0x1
    800015aa:	4581                	li	a1,0
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	7c2080e7          	jalr	1986(ra) # 80000d6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800015b4:	4779                	li	a4,30
    800015b6:	86a6                	mv	a3,s1
    800015b8:	6605                	lui	a2,0x1
    800015ba:	85ca                	mv	a1,s2
    800015bc:	8556                	mv	a0,s5
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	c4a080e7          	jalr	-950(ra) # 80001208 <mappages>
    800015c6:	e905                	bnez	a0,800015f6 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800015c8:	6785                	lui	a5,0x1
    800015ca:	993e                	add	s2,s2,a5
    800015cc:	fd4968e3          	bltu	s2,s4,8000159c <uvmalloc+0x2c>
  return newsz;
    800015d0:	8552                	mv	a0,s4
    800015d2:	a809                	j	800015e4 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800015d4:	864e                	mv	a2,s3
    800015d6:	85ca                	mv	a1,s2
    800015d8:	8556                	mv	a0,s5
    800015da:	00000097          	auipc	ra,0x0
    800015de:	f52080e7          	jalr	-174(ra) # 8000152c <uvmdealloc>
      return 0;
    800015e2:	4501                	li	a0,0
}
    800015e4:	70e2                	ld	ra,56(sp)
    800015e6:	7442                	ld	s0,48(sp)
    800015e8:	74a2                	ld	s1,40(sp)
    800015ea:	7902                	ld	s2,32(sp)
    800015ec:	69e2                	ld	s3,24(sp)
    800015ee:	6a42                	ld	s4,16(sp)
    800015f0:	6aa2                	ld	s5,8(sp)
    800015f2:	6121                	addi	sp,sp,64
    800015f4:	8082                	ret
      kfree(mem);
    800015f6:	8526                	mv	a0,s1
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	278080e7          	jalr	632(ra) # 80000870 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001600:	864e                	mv	a2,s3
    80001602:	85ca                	mv	a1,s2
    80001604:	8556                	mv	a0,s5
    80001606:	00000097          	auipc	ra,0x0
    8000160a:	f26080e7          	jalr	-218(ra) # 8000152c <uvmdealloc>
      return 0;
    8000160e:	4501                	li	a0,0
    80001610:	bfd1                	j	800015e4 <uvmalloc+0x74>
    return oldsz;
    80001612:	852e                	mv	a0,a1
}
    80001614:	8082                	ret
  return newsz;
    80001616:	8532                	mv	a0,a2
    80001618:	b7f1                	j	800015e4 <uvmalloc+0x74>

000000008000161a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000161a:	1101                	addi	sp,sp,-32
    8000161c:	ec06                	sd	ra,24(sp)
    8000161e:	e822                	sd	s0,16(sp)
    80001620:	e426                	sd	s1,8(sp)
    80001622:	1000                	addi	s0,sp,32
    80001624:	84aa                	mv	s1,a0
    80001626:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001628:	4685                	li	a3,1
    8000162a:	4581                	li	a1,0
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	d88080e7          	jalr	-632(ra) # 800013b4 <uvmunmap>
  freewalk(pagetable);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	aa4080e7          	jalr	-1372(ra) # 800010da <freewalk>
}
    8000163e:	60e2                	ld	ra,24(sp)
    80001640:	6442                	ld	s0,16(sp)
    80001642:	64a2                	ld	s1,8(sp)
    80001644:	6105                	addi	sp,sp,32
    80001646:	8082                	ret

0000000080001648 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001648:	c671                	beqz	a2,80001714 <uvmcopy+0xcc>
{
    8000164a:	715d                	addi	sp,sp,-80
    8000164c:	e486                	sd	ra,72(sp)
    8000164e:	e0a2                	sd	s0,64(sp)
    80001650:	fc26                	sd	s1,56(sp)
    80001652:	f84a                	sd	s2,48(sp)
    80001654:	f44e                	sd	s3,40(sp)
    80001656:	f052                	sd	s4,32(sp)
    80001658:	ec56                	sd	s5,24(sp)
    8000165a:	e85a                	sd	s6,16(sp)
    8000165c:	e45e                	sd	s7,8(sp)
    8000165e:	0880                	addi	s0,sp,80
    80001660:	8b2a                	mv	s6,a0
    80001662:	8aae                	mv	s5,a1
    80001664:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001666:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001668:	4601                	li	a2,0
    8000166a:	85ce                	mv	a1,s3
    8000166c:	855a                	mv	a0,s6
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	9c6080e7          	jalr	-1594(ra) # 80001034 <walk>
    80001676:	c531                	beqz	a0,800016c2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001678:	6118                	ld	a4,0(a0)
    8000167a:	00177793          	andi	a5,a4,1
    8000167e:	cbb1                	beqz	a5,800016d2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001680:	00a75593          	srli	a1,a4,0xa
    80001684:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001688:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000168c:	fffff097          	auipc	ra,0xfffff
    80001690:	2e0080e7          	jalr	736(ra) # 8000096c <kalloc>
    80001694:	892a                	mv	s2,a0
    80001696:	c939                	beqz	a0,800016ec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001698:	6605                	lui	a2,0x1
    8000169a:	85de                	mv	a1,s7
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	72e080e7          	jalr	1838(ra) # 80000dca <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800016a4:	8726                	mv	a4,s1
    800016a6:	86ca                	mv	a3,s2
    800016a8:	6605                	lui	a2,0x1
    800016aa:	85ce                	mv	a1,s3
    800016ac:	8556                	mv	a0,s5
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	b5a080e7          	jalr	-1190(ra) # 80001208 <mappages>
    800016b6:	e515                	bnez	a0,800016e2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800016b8:	6785                	lui	a5,0x1
    800016ba:	99be                	add	s3,s3,a5
    800016bc:	fb49e6e3          	bltu	s3,s4,80001668 <uvmcopy+0x20>
    800016c0:	a83d                	j	800016fe <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	d0e50513          	addi	a0,a0,-754 # 800083d0 <userret+0x340>
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	e8a080e7          	jalr	-374(ra) # 80000554 <panic>
      panic("uvmcopy: page not present");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	d1e50513          	addi	a0,a0,-738 # 800083f0 <userret+0x360>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e7a080e7          	jalr	-390(ra) # 80000554 <panic>
      kfree(mem);
    800016e2:	854a                	mv	a0,s2
    800016e4:	fffff097          	auipc	ra,0xfffff
    800016e8:	18c080e7          	jalr	396(ra) # 80000870 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800016ec:	4685                	li	a3,1
    800016ee:	864e                	mv	a2,s3
    800016f0:	4581                	li	a1,0
    800016f2:	8556                	mv	a0,s5
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	cc0080e7          	jalr	-832(ra) # 800013b4 <uvmunmap>
  return -1;
    800016fc:	557d                	li	a0,-1
}
    800016fe:	60a6                	ld	ra,72(sp)
    80001700:	6406                	ld	s0,64(sp)
    80001702:	74e2                	ld	s1,56(sp)
    80001704:	7942                	ld	s2,48(sp)
    80001706:	79a2                	ld	s3,40(sp)
    80001708:	7a02                	ld	s4,32(sp)
    8000170a:	6ae2                	ld	s5,24(sp)
    8000170c:	6b42                	ld	s6,16(sp)
    8000170e:	6ba2                	ld	s7,8(sp)
    80001710:	6161                	addi	sp,sp,80
    80001712:	8082                	ret
  return 0;
    80001714:	4501                	li	a0,0
}
    80001716:	8082                	ret

0000000080001718 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001718:	1141                	addi	sp,sp,-16
    8000171a:	e406                	sd	ra,8(sp)
    8000171c:	e022                	sd	s0,0(sp)
    8000171e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001720:	4601                	li	a2,0
    80001722:	00000097          	auipc	ra,0x0
    80001726:	912080e7          	jalr	-1774(ra) # 80001034 <walk>
  if(pte == 0)
    8000172a:	c901                	beqz	a0,8000173a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000172c:	611c                	ld	a5,0(a0)
    8000172e:	9bbd                	andi	a5,a5,-17
    80001730:	e11c                	sd	a5,0(a0)
}
    80001732:	60a2                	ld	ra,8(sp)
    80001734:	6402                	ld	s0,0(sp)
    80001736:	0141                	addi	sp,sp,16
    80001738:	8082                	ret
    panic("uvmclear");
    8000173a:	00007517          	auipc	a0,0x7
    8000173e:	cd650513          	addi	a0,a0,-810 # 80008410 <userret+0x380>
    80001742:	fffff097          	auipc	ra,0xfffff
    80001746:	e12080e7          	jalr	-494(ra) # 80000554 <panic>

000000008000174a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000174a:	c6bd                	beqz	a3,800017b8 <copyout+0x6e>
{
    8000174c:	715d                	addi	sp,sp,-80
    8000174e:	e486                	sd	ra,72(sp)
    80001750:	e0a2                	sd	s0,64(sp)
    80001752:	fc26                	sd	s1,56(sp)
    80001754:	f84a                	sd	s2,48(sp)
    80001756:	f44e                	sd	s3,40(sp)
    80001758:	f052                	sd	s4,32(sp)
    8000175a:	ec56                	sd	s5,24(sp)
    8000175c:	e85a                	sd	s6,16(sp)
    8000175e:	e45e                	sd	s7,8(sp)
    80001760:	e062                	sd	s8,0(sp)
    80001762:	0880                	addi	s0,sp,80
    80001764:	8b2a                	mv	s6,a0
    80001766:	8c2e                	mv	s8,a1
    80001768:	8a32                	mv	s4,a2
    8000176a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000176c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000176e:	6a85                	lui	s5,0x1
    80001770:	a015                	j	80001794 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001772:	9562                	add	a0,a0,s8
    80001774:	0004861b          	sext.w	a2,s1
    80001778:	85d2                	mv	a1,s4
    8000177a:	41250533          	sub	a0,a0,s2
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	64c080e7          	jalr	1612(ra) # 80000dca <memmove>

    len -= n;
    80001786:	409989b3          	sub	s3,s3,s1
    src += n;
    8000178a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000178c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001790:	02098263          	beqz	s3,800017b4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001794:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001798:	85ca                	mv	a1,s2
    8000179a:	855a                	mv	a0,s6
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	9cc080e7          	jalr	-1588(ra) # 80001168 <walkaddr>
    if(pa0 == 0)
    800017a4:	cd01                	beqz	a0,800017bc <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800017a6:	418904b3          	sub	s1,s2,s8
    800017aa:	94d6                	add	s1,s1,s5
    if(n > len)
    800017ac:	fc99f3e3          	bgeu	s3,s1,80001772 <copyout+0x28>
    800017b0:	84ce                	mv	s1,s3
    800017b2:	b7c1                	j	80001772 <copyout+0x28>
  }
  return 0;
    800017b4:	4501                	li	a0,0
    800017b6:	a021                	j	800017be <copyout+0x74>
    800017b8:	4501                	li	a0,0
}
    800017ba:	8082                	ret
      return -1;
    800017bc:	557d                	li	a0,-1
}
    800017be:	60a6                	ld	ra,72(sp)
    800017c0:	6406                	ld	s0,64(sp)
    800017c2:	74e2                	ld	s1,56(sp)
    800017c4:	7942                	ld	s2,48(sp)
    800017c6:	79a2                	ld	s3,40(sp)
    800017c8:	7a02                	ld	s4,32(sp)
    800017ca:	6ae2                	ld	s5,24(sp)
    800017cc:	6b42                	ld	s6,16(sp)
    800017ce:	6ba2                	ld	s7,8(sp)
    800017d0:	6c02                	ld	s8,0(sp)
    800017d2:	6161                	addi	sp,sp,80
    800017d4:	8082                	ret

00000000800017d6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017d6:	caa5                	beqz	a3,80001846 <copyin+0x70>
{
    800017d8:	715d                	addi	sp,sp,-80
    800017da:	e486                	sd	ra,72(sp)
    800017dc:	e0a2                	sd	s0,64(sp)
    800017de:	fc26                	sd	s1,56(sp)
    800017e0:	f84a                	sd	s2,48(sp)
    800017e2:	f44e                	sd	s3,40(sp)
    800017e4:	f052                	sd	s4,32(sp)
    800017e6:	ec56                	sd	s5,24(sp)
    800017e8:	e85a                	sd	s6,16(sp)
    800017ea:	e45e                	sd	s7,8(sp)
    800017ec:	e062                	sd	s8,0(sp)
    800017ee:	0880                	addi	s0,sp,80
    800017f0:	8b2a                	mv	s6,a0
    800017f2:	8a2e                	mv	s4,a1
    800017f4:	8c32                	mv	s8,a2
    800017f6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017f8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017fa:	6a85                	lui	s5,0x1
    800017fc:	a01d                	j	80001822 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017fe:	018505b3          	add	a1,a0,s8
    80001802:	0004861b          	sext.w	a2,s1
    80001806:	412585b3          	sub	a1,a1,s2
    8000180a:	8552                	mv	a0,s4
    8000180c:	fffff097          	auipc	ra,0xfffff
    80001810:	5be080e7          	jalr	1470(ra) # 80000dca <memmove>

    len -= n;
    80001814:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001818:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000181a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000181e:	02098263          	beqz	s3,80001842 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001822:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001826:	85ca                	mv	a1,s2
    80001828:	855a                	mv	a0,s6
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	93e080e7          	jalr	-1730(ra) # 80001168 <walkaddr>
    if(pa0 == 0)
    80001832:	cd01                	beqz	a0,8000184a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001834:	418904b3          	sub	s1,s2,s8
    80001838:	94d6                	add	s1,s1,s5
    if(n > len)
    8000183a:	fc99f2e3          	bgeu	s3,s1,800017fe <copyin+0x28>
    8000183e:	84ce                	mv	s1,s3
    80001840:	bf7d                	j	800017fe <copyin+0x28>
  }
  return 0;
    80001842:	4501                	li	a0,0
    80001844:	a021                	j	8000184c <copyin+0x76>
    80001846:	4501                	li	a0,0
}
    80001848:	8082                	ret
      return -1;
    8000184a:	557d                	li	a0,-1
}
    8000184c:	60a6                	ld	ra,72(sp)
    8000184e:	6406                	ld	s0,64(sp)
    80001850:	74e2                	ld	s1,56(sp)
    80001852:	7942                	ld	s2,48(sp)
    80001854:	79a2                	ld	s3,40(sp)
    80001856:	7a02                	ld	s4,32(sp)
    80001858:	6ae2                	ld	s5,24(sp)
    8000185a:	6b42                	ld	s6,16(sp)
    8000185c:	6ba2                	ld	s7,8(sp)
    8000185e:	6c02                	ld	s8,0(sp)
    80001860:	6161                	addi	sp,sp,80
    80001862:	8082                	ret

0000000080001864 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001864:	c6c5                	beqz	a3,8000190c <copyinstr+0xa8>
{
    80001866:	715d                	addi	sp,sp,-80
    80001868:	e486                	sd	ra,72(sp)
    8000186a:	e0a2                	sd	s0,64(sp)
    8000186c:	fc26                	sd	s1,56(sp)
    8000186e:	f84a                	sd	s2,48(sp)
    80001870:	f44e                	sd	s3,40(sp)
    80001872:	f052                	sd	s4,32(sp)
    80001874:	ec56                	sd	s5,24(sp)
    80001876:	e85a                	sd	s6,16(sp)
    80001878:	e45e                	sd	s7,8(sp)
    8000187a:	0880                	addi	s0,sp,80
    8000187c:	8a2a                	mv	s4,a0
    8000187e:	8b2e                	mv	s6,a1
    80001880:	8bb2                	mv	s7,a2
    80001882:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001884:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001886:	6985                	lui	s3,0x1
    80001888:	a035                	j	800018b4 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000188a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000188e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001890:	0017b793          	seqz	a5,a5
    80001894:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001898:	60a6                	ld	ra,72(sp)
    8000189a:	6406                	ld	s0,64(sp)
    8000189c:	74e2                	ld	s1,56(sp)
    8000189e:	7942                	ld	s2,48(sp)
    800018a0:	79a2                	ld	s3,40(sp)
    800018a2:	7a02                	ld	s4,32(sp)
    800018a4:	6ae2                	ld	s5,24(sp)
    800018a6:	6b42                	ld	s6,16(sp)
    800018a8:	6ba2                	ld	s7,8(sp)
    800018aa:	6161                	addi	sp,sp,80
    800018ac:	8082                	ret
    srcva = va0 + PGSIZE;
    800018ae:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800018b2:	c8a9                	beqz	s1,80001904 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800018b4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800018b8:	85ca                	mv	a1,s2
    800018ba:	8552                	mv	a0,s4
    800018bc:	00000097          	auipc	ra,0x0
    800018c0:	8ac080e7          	jalr	-1876(ra) # 80001168 <walkaddr>
    if(pa0 == 0)
    800018c4:	c131                	beqz	a0,80001908 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800018c6:	41790833          	sub	a6,s2,s7
    800018ca:	984e                	add	a6,a6,s3
    if(n > max)
    800018cc:	0104f363          	bgeu	s1,a6,800018d2 <copyinstr+0x6e>
    800018d0:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800018d2:	955e                	add	a0,a0,s7
    800018d4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800018d8:	fc080be3          	beqz	a6,800018ae <copyinstr+0x4a>
    800018dc:	985a                	add	a6,a6,s6
    800018de:	87da                	mv	a5,s6
      if(*p == '\0'){
    800018e0:	41650633          	sub	a2,a0,s6
    800018e4:	14fd                	addi	s1,s1,-1
    800018e6:	9b26                	add	s6,s6,s1
    800018e8:	00f60733          	add	a4,a2,a5
    800018ec:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd6fa4>
    800018f0:	df49                	beqz	a4,8000188a <copyinstr+0x26>
        *dst = *p;
    800018f2:	00e78023          	sb	a4,0(a5)
      --max;
    800018f6:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018fa:	0785                	addi	a5,a5,1
    while(n > 0){
    800018fc:	ff0796e3          	bne	a5,a6,800018e8 <copyinstr+0x84>
      dst++;
    80001900:	8b42                	mv	s6,a6
    80001902:	b775                	j	800018ae <copyinstr+0x4a>
    80001904:	4781                	li	a5,0
    80001906:	b769                	j	80001890 <copyinstr+0x2c>
      return -1;
    80001908:	557d                	li	a0,-1
    8000190a:	b779                	j	80001898 <copyinstr+0x34>
  int got_null = 0;
    8000190c:	4781                	li	a5,0
  if(got_null){
    8000190e:	0017b793          	seqz	a5,a5
    80001912:	40f00533          	neg	a0,a5
}
    80001916:	8082                	ret

0000000080001918 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001918:	1101                	addi	sp,sp,-32
    8000191a:	ec06                	sd	ra,24(sp)
    8000191c:	e822                	sd	s0,16(sp)
    8000191e:	e426                	sd	s1,8(sp)
    80001920:	1000                	addi	s0,sp,32
    80001922:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	0fe080e7          	jalr	254(ra) # 80000a22 <holding>
    8000192c:	c909                	beqz	a0,8000193e <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000192e:	789c                	ld	a5,48(s1)
    80001930:	00978f63          	beq	a5,s1,8000194e <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001934:	60e2                	ld	ra,24(sp)
    80001936:	6442                	ld	s0,16(sp)
    80001938:	64a2                	ld	s1,8(sp)
    8000193a:	6105                	addi	sp,sp,32
    8000193c:	8082                	ret
    panic("wakeup1");
    8000193e:	00007517          	auipc	a0,0x7
    80001942:	ae250513          	addi	a0,a0,-1310 # 80008420 <userret+0x390>
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	c0e080e7          	jalr	-1010(ra) # 80000554 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000194e:	5098                	lw	a4,32(s1)
    80001950:	4785                	li	a5,1
    80001952:	fef711e3          	bne	a4,a5,80001934 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001956:	4789                	li	a5,2
    80001958:	d09c                	sw	a5,32(s1)
}
    8000195a:	bfe9                	j	80001934 <wakeup1+0x1c>

000000008000195c <procinit>:
{
    8000195c:	715d                	addi	sp,sp,-80
    8000195e:	e486                	sd	ra,72(sp)
    80001960:	e0a2                	sd	s0,64(sp)
    80001962:	fc26                	sd	s1,56(sp)
    80001964:	f84a                	sd	s2,48(sp)
    80001966:	f44e                	sd	s3,40(sp)
    80001968:	f052                	sd	s4,32(sp)
    8000196a:	ec56                	sd	s5,24(sp)
    8000196c:	e85a                	sd	s6,16(sp)
    8000196e:	e45e                	sd	s7,8(sp)
    80001970:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001972:	00007597          	auipc	a1,0x7
    80001976:	ab658593          	addi	a1,a1,-1354 # 80008428 <userret+0x398>
    8000197a:	00013517          	auipc	a0,0x13
    8000197e:	ec650513          	addi	a0,a0,-314 # 80014840 <pid_lock>
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	04a080e7          	jalr	74(ra) # 800009cc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000198a:	00013917          	auipc	s2,0x13
    8000198e:	2d690913          	addi	s2,s2,726 # 80014c60 <proc>
      initlock(&p->lock, "proc");
    80001992:	00007a17          	auipc	s4,0x7
    80001996:	a9ea0a13          	addi	s4,s4,-1378 # 80008430 <userret+0x3a0>
      uint64 va = KSTACK((int) (p - proc));
    8000199a:	8bca                	mv	s7,s2
    8000199c:	00007b17          	auipc	s6,0x7
    800019a0:	584b0b13          	addi	s6,s6,1412 # 80008f20 <syscalls+0xb8>
    800019a4:	040009b7          	lui	s3,0x4000
    800019a8:	19fd                	addi	s3,s3,-1
    800019aa:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ac:	00014a97          	auipc	s5,0x14
    800019b0:	114a8a93          	addi	s5,s5,276 # 80015ac0 <tickslock>
      initlock(&p->lock, "proc");
    800019b4:	85d2                	mv	a1,s4
    800019b6:	854a                	mv	a0,s2
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	014080e7          	jalr	20(ra) # 800009cc <initlock>
      char *pa = kalloc();
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	fac080e7          	jalr	-84(ra) # 8000096c <kalloc>
    800019c8:	85aa                	mv	a1,a0
      if(pa == 0)
    800019ca:	c929                	beqz	a0,80001a1c <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019cc:	417904b3          	sub	s1,s2,s7
    800019d0:	8491                	srai	s1,s1,0x4
    800019d2:	000b3783          	ld	a5,0(s6)
    800019d6:	02f484b3          	mul	s1,s1,a5
    800019da:	2485                	addiw	s1,s1,1
    800019dc:	00d4949b          	slliw	s1,s1,0xd
    800019e0:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019e4:	4699                	li	a3,6
    800019e6:	6605                	lui	a2,0x1
    800019e8:	8526                	mv	a0,s1
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	8ac080e7          	jalr	-1876(ra) # 80001296 <kvmmap>
      p->kstack = va;
    800019f2:	04993423          	sd	s1,72(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f6:	17090913          	addi	s2,s2,368
    800019fa:	fb591de3          	bne	s2,s5,800019b4 <procinit+0x58>
  kvminithart();
    800019fe:	fffff097          	auipc	ra,0xfffff
    80001a02:	746080e7          	jalr	1862(ra) # 80001144 <kvminithart>
}
    80001a06:	60a6                	ld	ra,72(sp)
    80001a08:	6406                	ld	s0,64(sp)
    80001a0a:	74e2                	ld	s1,56(sp)
    80001a0c:	7942                	ld	s2,48(sp)
    80001a0e:	79a2                	ld	s3,40(sp)
    80001a10:	7a02                	ld	s4,32(sp)
    80001a12:	6ae2                	ld	s5,24(sp)
    80001a14:	6b42                	ld	s6,16(sp)
    80001a16:	6ba2                	ld	s7,8(sp)
    80001a18:	6161                	addi	sp,sp,80
    80001a1a:	8082                	ret
        panic("kalloc");
    80001a1c:	00007517          	auipc	a0,0x7
    80001a20:	a1c50513          	addi	a0,a0,-1508 # 80008438 <userret+0x3a8>
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	b30080e7          	jalr	-1232(ra) # 80000554 <panic>

0000000080001a2c <cpuid>:
{
    80001a2c:	1141                	addi	sp,sp,-16
    80001a2e:	e422                	sd	s0,8(sp)
    80001a30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a32:	8512                	mv	a0,tp
}
    80001a34:	2501                	sext.w	a0,a0
    80001a36:	6422                	ld	s0,8(sp)
    80001a38:	0141                	addi	sp,sp,16
    80001a3a:	8082                	ret

0000000080001a3c <mycpu>:
mycpu(void) {
    80001a3c:	1141                	addi	sp,sp,-16
    80001a3e:	e422                	sd	s0,8(sp)
    80001a40:	0800                	addi	s0,sp,16
    80001a42:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a44:	2781                	sext.w	a5,a5
    80001a46:	079e                	slli	a5,a5,0x7
}
    80001a48:	00013517          	auipc	a0,0x13
    80001a4c:	e1850513          	addi	a0,a0,-488 # 80014860 <cpus>
    80001a50:	953e                	add	a0,a0,a5
    80001a52:	6422                	ld	s0,8(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret

0000000080001a58 <myproc>:
myproc(void) {
    80001a58:	1101                	addi	sp,sp,-32
    80001a5a:	ec06                	sd	ra,24(sp)
    80001a5c:	e822                	sd	s0,16(sp)
    80001a5e:	e426                	sd	s1,8(sp)
    80001a60:	1000                	addi	s0,sp,32
  push_off();
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	fee080e7          	jalr	-18(ra) # 80000a50 <push_off>
    80001a6a:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a6c:	2781                	sext.w	a5,a5
    80001a6e:	079e                	slli	a5,a5,0x7
    80001a70:	00013717          	auipc	a4,0x13
    80001a74:	dd070713          	addi	a4,a4,-560 # 80014840 <pid_lock>
    80001a78:	97ba                	add	a5,a5,a4
    80001a7a:	7384                	ld	s1,32(a5)
  pop_off();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	094080e7          	jalr	148(ra) # 80000b10 <pop_off>
}
    80001a84:	8526                	mv	a0,s1
    80001a86:	60e2                	ld	ra,24(sp)
    80001a88:	6442                	ld	s0,16(sp)
    80001a8a:	64a2                	ld	s1,8(sp)
    80001a8c:	6105                	addi	sp,sp,32
    80001a8e:	8082                	ret

0000000080001a90 <forkret>:
{
    80001a90:	1141                	addi	sp,sp,-16
    80001a92:	e406                	sd	ra,8(sp)
    80001a94:	e022                	sd	s0,0(sp)
    80001a96:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	fc0080e7          	jalr	-64(ra) # 80001a58 <myproc>
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	0d0080e7          	jalr	208(ra) # 80000b70 <release>
  if (first) {
    80001aa8:	00007797          	auipc	a5,0x7
    80001aac:	58c7a783          	lw	a5,1420(a5) # 80009034 <first.1>
    80001ab0:	eb89                	bnez	a5,80001ac2 <forkret+0x32>
  usertrapret();
    80001ab2:	00001097          	auipc	ra,0x1
    80001ab6:	c60080e7          	jalr	-928(ra) # 80002712 <usertrapret>
}
    80001aba:	60a2                	ld	ra,8(sp)
    80001abc:	6402                	ld	s0,0(sp)
    80001abe:	0141                	addi	sp,sp,16
    80001ac0:	8082                	ret
    first = 0;
    80001ac2:	00007797          	auipc	a5,0x7
    80001ac6:	5607a923          	sw	zero,1394(a5) # 80009034 <first.1>
    fsinit(minor(ROOTDEV));
    80001aca:	4501                	li	a0,0
    80001acc:	00002097          	auipc	ra,0x2
    80001ad0:	9a0080e7          	jalr	-1632(ra) # 8000346c <fsinit>
    80001ad4:	bff9                	j	80001ab2 <forkret+0x22>

0000000080001ad6 <allocpid>:
allocpid() {
    80001ad6:	1101                	addi	sp,sp,-32
    80001ad8:	ec06                	sd	ra,24(sp)
    80001ada:	e822                	sd	s0,16(sp)
    80001adc:	e426                	sd	s1,8(sp)
    80001ade:	e04a                	sd	s2,0(sp)
    80001ae0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ae2:	00013917          	auipc	s2,0x13
    80001ae6:	d5e90913          	addi	s2,s2,-674 # 80014840 <pid_lock>
    80001aea:	854a                	mv	a0,s2
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	fb4080e7          	jalr	-76(ra) # 80000aa0 <acquire>
  pid = nextpid;
    80001af4:	00007797          	auipc	a5,0x7
    80001af8:	54478793          	addi	a5,a5,1348 # 80009038 <nextpid>
    80001afc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001afe:	0014871b          	addiw	a4,s1,1
    80001b02:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b04:	854a                	mv	a0,s2
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	06a080e7          	jalr	106(ra) # 80000b70 <release>
}
    80001b0e:	8526                	mv	a0,s1
    80001b10:	60e2                	ld	ra,24(sp)
    80001b12:	6442                	ld	s0,16(sp)
    80001b14:	64a2                	ld	s1,8(sp)
    80001b16:	6902                	ld	s2,0(sp)
    80001b18:	6105                	addi	sp,sp,32
    80001b1a:	8082                	ret

0000000080001b1c <proc_pagetable>:
{
    80001b1c:	1101                	addi	sp,sp,-32
    80001b1e:	ec06                	sd	ra,24(sp)
    80001b20:	e822                	sd	s0,16(sp)
    80001b22:	e426                	sd	s1,8(sp)
    80001b24:	e04a                	sd	s2,0(sp)
    80001b26:	1000                	addi	s0,sp,32
    80001b28:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b2a:	00000097          	auipc	ra,0x0
    80001b2e:	952080e7          	jalr	-1710(ra) # 8000147c <uvmcreate>
    80001b32:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b34:	4729                	li	a4,10
    80001b36:	00006697          	auipc	a3,0x6
    80001b3a:	4ca68693          	addi	a3,a3,1226 # 80008000 <trampoline>
    80001b3e:	6605                	lui	a2,0x1
    80001b40:	040005b7          	lui	a1,0x4000
    80001b44:	15fd                	addi	a1,a1,-1
    80001b46:	05b2                	slli	a1,a1,0xc
    80001b48:	fffff097          	auipc	ra,0xfffff
    80001b4c:	6c0080e7          	jalr	1728(ra) # 80001208 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b50:	4719                	li	a4,6
    80001b52:	06093683          	ld	a3,96(s2)
    80001b56:	6605                	lui	a2,0x1
    80001b58:	020005b7          	lui	a1,0x2000
    80001b5c:	15fd                	addi	a1,a1,-1
    80001b5e:	05b6                	slli	a1,a1,0xd
    80001b60:	8526                	mv	a0,s1
    80001b62:	fffff097          	auipc	ra,0xfffff
    80001b66:	6a6080e7          	jalr	1702(ra) # 80001208 <mappages>
}
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	60e2                	ld	ra,24(sp)
    80001b6e:	6442                	ld	s0,16(sp)
    80001b70:	64a2                	ld	s1,8(sp)
    80001b72:	6902                	ld	s2,0(sp)
    80001b74:	6105                	addi	sp,sp,32
    80001b76:	8082                	ret

0000000080001b78 <allocproc>:
{
    80001b78:	1101                	addi	sp,sp,-32
    80001b7a:	ec06                	sd	ra,24(sp)
    80001b7c:	e822                	sd	s0,16(sp)
    80001b7e:	e426                	sd	s1,8(sp)
    80001b80:	e04a                	sd	s2,0(sp)
    80001b82:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b84:	00013497          	auipc	s1,0x13
    80001b88:	0dc48493          	addi	s1,s1,220 # 80014c60 <proc>
    80001b8c:	00014917          	auipc	s2,0x14
    80001b90:	f3490913          	addi	s2,s2,-204 # 80015ac0 <tickslock>
    acquire(&p->lock);
    80001b94:	8526                	mv	a0,s1
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	f0a080e7          	jalr	-246(ra) # 80000aa0 <acquire>
    if(p->state == UNUSED) {
    80001b9e:	509c                	lw	a5,32(s1)
    80001ba0:	c395                	beqz	a5,80001bc4 <allocproc+0x4c>
      release(&p->lock);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	fffff097          	auipc	ra,0xfffff
    80001ba8:	fcc080e7          	jalr	-52(ra) # 80000b70 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bac:	17048493          	addi	s1,s1,368
    80001bb0:	ff2492e3          	bne	s1,s2,80001b94 <allocproc+0x1c>
  return 0;
    80001bb4:	4481                	li	s1,0
}
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	60e2                	ld	ra,24(sp)
    80001bba:	6442                	ld	s0,16(sp)
    80001bbc:	64a2                	ld	s1,8(sp)
    80001bbe:	6902                	ld	s2,0(sp)
    80001bc0:	6105                	addi	sp,sp,32
    80001bc2:	8082                	ret
  p->pid = allocpid();
    80001bc4:	00000097          	auipc	ra,0x0
    80001bc8:	f12080e7          	jalr	-238(ra) # 80001ad6 <allocpid>
    80001bcc:	c0a8                	sw	a0,64(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	d9e080e7          	jalr	-610(ra) # 8000096c <kalloc>
    80001bd6:	892a                	mv	s2,a0
    80001bd8:	f0a8                	sd	a0,96(s1)
    80001bda:	c915                	beqz	a0,80001c0e <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	00000097          	auipc	ra,0x0
    80001be2:	f3e080e7          	jalr	-194(ra) # 80001b1c <proc_pagetable>
    80001be6:	eca8                	sd	a0,88(s1)
  memset(&p->context, 0, sizeof p->context);
    80001be8:	07000613          	li	a2,112
    80001bec:	4581                	li	a1,0
    80001bee:	06848513          	addi	a0,s1,104
    80001bf2:	fffff097          	auipc	ra,0xfffff
    80001bf6:	17c080e7          	jalr	380(ra) # 80000d6e <memset>
  p->context.ra = (uint64)forkret;
    80001bfa:	00000797          	auipc	a5,0x0
    80001bfe:	e9678793          	addi	a5,a5,-362 # 80001a90 <forkret>
    80001c02:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c04:	64bc                	ld	a5,72(s1)
    80001c06:	6705                	lui	a4,0x1
    80001c08:	97ba                	add	a5,a5,a4
    80001c0a:	f8bc                	sd	a5,112(s1)
  return p;
    80001c0c:	b76d                	j	80001bb6 <allocproc+0x3e>
    release(&p->lock);
    80001c0e:	8526                	mv	a0,s1
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	f60080e7          	jalr	-160(ra) # 80000b70 <release>
    return 0;
    80001c18:	84ca                	mv	s1,s2
    80001c1a:	bf71                	j	80001bb6 <allocproc+0x3e>

0000000080001c1c <proc_freepagetable>:
{
    80001c1c:	1101                	addi	sp,sp,-32
    80001c1e:	ec06                	sd	ra,24(sp)
    80001c20:	e822                	sd	s0,16(sp)
    80001c22:	e426                	sd	s1,8(sp)
    80001c24:	e04a                	sd	s2,0(sp)
    80001c26:	1000                	addi	s0,sp,32
    80001c28:	84aa                	mv	s1,a0
    80001c2a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001c2c:	4681                	li	a3,0
    80001c2e:	6605                	lui	a2,0x1
    80001c30:	040005b7          	lui	a1,0x4000
    80001c34:	15fd                	addi	a1,a1,-1
    80001c36:	05b2                	slli	a1,a1,0xc
    80001c38:	fffff097          	auipc	ra,0xfffff
    80001c3c:	77c080e7          	jalr	1916(ra) # 800013b4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001c40:	4681                	li	a3,0
    80001c42:	6605                	lui	a2,0x1
    80001c44:	020005b7          	lui	a1,0x2000
    80001c48:	15fd                	addi	a1,a1,-1
    80001c4a:	05b6                	slli	a1,a1,0xd
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	766080e7          	jalr	1894(ra) # 800013b4 <uvmunmap>
  if(sz > 0)
    80001c56:	00091863          	bnez	s2,80001c66 <proc_freepagetable+0x4a>
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	64a2                	ld	s1,8(sp)
    80001c60:	6902                	ld	s2,0(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret
    uvmfree(pagetable, sz);
    80001c66:	85ca                	mv	a1,s2
    80001c68:	8526                	mv	a0,s1
    80001c6a:	00000097          	auipc	ra,0x0
    80001c6e:	9b0080e7          	jalr	-1616(ra) # 8000161a <uvmfree>
}
    80001c72:	b7e5                	j	80001c5a <proc_freepagetable+0x3e>

0000000080001c74 <freeproc>:
{
    80001c74:	1101                	addi	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	1000                	addi	s0,sp,32
    80001c7e:	84aa                	mv	s1,a0
  if(p->tf)
    80001c80:	7128                	ld	a0,96(a0)
    80001c82:	c509                	beqz	a0,80001c8c <freeproc+0x18>
    kfree((void*)p->tf);
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	bec080e7          	jalr	-1044(ra) # 80000870 <kfree>
  p->tf = 0;
    80001c8c:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001c90:	6ca8                	ld	a0,88(s1)
    80001c92:	c511                	beqz	a0,80001c9e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c94:	68ac                	ld	a1,80(s1)
    80001c96:	00000097          	auipc	ra,0x0
    80001c9a:	f86080e7          	jalr	-122(ra) # 80001c1c <proc_freepagetable>
  p->pagetable = 0;
    80001c9e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001ca2:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001ca6:	0404a023          	sw	zero,64(s1)
  p->parent = 0;
    80001caa:	0204b423          	sd	zero,40(s1)
  p->name[0] = 0;
    80001cae:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001cb2:	0204b823          	sd	zero,48(s1)
  p->killed = 0;
    80001cb6:	0204ac23          	sw	zero,56(s1)
  p->xstate = 0;
    80001cba:	0204ae23          	sw	zero,60(s1)
  p->state = UNUSED;
    80001cbe:	0204a023          	sw	zero,32(s1)
}
    80001cc2:	60e2                	ld	ra,24(sp)
    80001cc4:	6442                	ld	s0,16(sp)
    80001cc6:	64a2                	ld	s1,8(sp)
    80001cc8:	6105                	addi	sp,sp,32
    80001cca:	8082                	ret

0000000080001ccc <userinit>:
{
    80001ccc:	1101                	addi	sp,sp,-32
    80001cce:	ec06                	sd	ra,24(sp)
    80001cd0:	e822                	sd	s0,16(sp)
    80001cd2:	e426                	sd	s1,8(sp)
    80001cd4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	ea2080e7          	jalr	-350(ra) # 80001b78 <allocproc>
    80001cde:	84aa                	mv	s1,a0
  initproc = p;
    80001ce0:	00026797          	auipc	a5,0x26
    80001ce4:	34a7bc23          	sd	a0,856(a5) # 80028038 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ce8:	03300613          	li	a2,51
    80001cec:	00007597          	auipc	a1,0x7
    80001cf0:	31458593          	addi	a1,a1,788 # 80009000 <initcode>
    80001cf4:	6d28                	ld	a0,88(a0)
    80001cf6:	fffff097          	auipc	ra,0xfffff
    80001cfa:	7c4080e7          	jalr	1988(ra) # 800014ba <uvminit>
  p->sz = PGSIZE;
    80001cfe:	6785                	lui	a5,0x1
    80001d00:	e8bc                	sd	a5,80(s1)
  p->tf->epc = 0;      // user program counter
    80001d02:	70b8                	ld	a4,96(s1)
    80001d04:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001d08:	70b8                	ld	a4,96(s1)
    80001d0a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d0c:	4641                	li	a2,16
    80001d0e:	00006597          	auipc	a1,0x6
    80001d12:	73258593          	addi	a1,a1,1842 # 80008440 <userret+0x3b0>
    80001d16:	16048513          	addi	a0,s1,352
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	1a6080e7          	jalr	422(ra) # 80000ec0 <safestrcpy>
  p->cwd = namei("/");
    80001d22:	00006517          	auipc	a0,0x6
    80001d26:	72e50513          	addi	a0,a0,1838 # 80008450 <userret+0x3c0>
    80001d2a:	00002097          	auipc	ra,0x2
    80001d2e:	144080e7          	jalr	324(ra) # 80003e6e <namei>
    80001d32:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001d36:	4789                	li	a5,2
    80001d38:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	fffff097          	auipc	ra,0xfffff
    80001d40:	e34080e7          	jalr	-460(ra) # 80000b70 <release>
}
    80001d44:	60e2                	ld	ra,24(sp)
    80001d46:	6442                	ld	s0,16(sp)
    80001d48:	64a2                	ld	s1,8(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret

0000000080001d4e <growproc>:
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	e04a                	sd	s2,0(sp)
    80001d58:	1000                	addi	s0,sp,32
    80001d5a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	cfc080e7          	jalr	-772(ra) # 80001a58 <myproc>
    80001d64:	892a                	mv	s2,a0
  sz = p->sz;
    80001d66:	692c                	ld	a1,80(a0)
    80001d68:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d6c:	00904f63          	bgtz	s1,80001d8a <growproc+0x3c>
  } else if(n < 0){
    80001d70:	0204cc63          	bltz	s1,80001da8 <growproc+0x5a>
  p->sz = sz;
    80001d74:	1602                	slli	a2,a2,0x20
    80001d76:	9201                	srli	a2,a2,0x20
    80001d78:	04c93823          	sd	a2,80(s2)
  return 0;
    80001d7c:	4501                	li	a0,0
}
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	64a2                	ld	s1,8(sp)
    80001d84:	6902                	ld	s2,0(sp)
    80001d86:	6105                	addi	sp,sp,32
    80001d88:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d8a:	9e25                	addw	a2,a2,s1
    80001d8c:	1602                	slli	a2,a2,0x20
    80001d8e:	9201                	srli	a2,a2,0x20
    80001d90:	1582                	slli	a1,a1,0x20
    80001d92:	9181                	srli	a1,a1,0x20
    80001d94:	6d28                	ld	a0,88(a0)
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	7da080e7          	jalr	2010(ra) # 80001570 <uvmalloc>
    80001d9e:	0005061b          	sext.w	a2,a0
    80001da2:	fa69                	bnez	a2,80001d74 <growproc+0x26>
      return -1;
    80001da4:	557d                	li	a0,-1
    80001da6:	bfe1                	j	80001d7e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001da8:	9e25                	addw	a2,a2,s1
    80001daa:	1602                	slli	a2,a2,0x20
    80001dac:	9201                	srli	a2,a2,0x20
    80001dae:	1582                	slli	a1,a1,0x20
    80001db0:	9181                	srli	a1,a1,0x20
    80001db2:	6d28                	ld	a0,88(a0)
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	778080e7          	jalr	1912(ra) # 8000152c <uvmdealloc>
    80001dbc:	0005061b          	sext.w	a2,a0
    80001dc0:	bf55                	j	80001d74 <growproc+0x26>

0000000080001dc2 <fork>:
{
    80001dc2:	7139                	addi	sp,sp,-64
    80001dc4:	fc06                	sd	ra,56(sp)
    80001dc6:	f822                	sd	s0,48(sp)
    80001dc8:	f426                	sd	s1,40(sp)
    80001dca:	f04a                	sd	s2,32(sp)
    80001dcc:	ec4e                	sd	s3,24(sp)
    80001dce:	e852                	sd	s4,16(sp)
    80001dd0:	e456                	sd	s5,8(sp)
    80001dd2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	c84080e7          	jalr	-892(ra) # 80001a58 <myproc>
    80001ddc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	d9a080e7          	jalr	-614(ra) # 80001b78 <allocproc>
    80001de6:	c17d                	beqz	a0,80001ecc <fork+0x10a>
    80001de8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dea:	050ab603          	ld	a2,80(s5)
    80001dee:	6d2c                	ld	a1,88(a0)
    80001df0:	058ab503          	ld	a0,88(s5)
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	854080e7          	jalr	-1964(ra) # 80001648 <uvmcopy>
    80001dfc:	04054a63          	bltz	a0,80001e50 <fork+0x8e>
  np->sz = p->sz;
    80001e00:	050ab783          	ld	a5,80(s5)
    80001e04:	04fa3823          	sd	a5,80(s4)
  np->parent = p;
    80001e08:	035a3423          	sd	s5,40(s4)
  *(np->tf) = *(p->tf);
    80001e0c:	060ab683          	ld	a3,96(s5)
    80001e10:	87b6                	mv	a5,a3
    80001e12:	060a3703          	ld	a4,96(s4)
    80001e16:	12068693          	addi	a3,a3,288
    80001e1a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e1e:	6788                	ld	a0,8(a5)
    80001e20:	6b8c                	ld	a1,16(a5)
    80001e22:	6f90                	ld	a2,24(a5)
    80001e24:	01073023          	sd	a6,0(a4)
    80001e28:	e708                	sd	a0,8(a4)
    80001e2a:	eb0c                	sd	a1,16(a4)
    80001e2c:	ef10                	sd	a2,24(a4)
    80001e2e:	02078793          	addi	a5,a5,32
    80001e32:	02070713          	addi	a4,a4,32
    80001e36:	fed792e3          	bne	a5,a3,80001e1a <fork+0x58>
  np->tf->a0 = 0;
    80001e3a:	060a3783          	ld	a5,96(s4)
    80001e3e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e42:	0d8a8493          	addi	s1,s5,216
    80001e46:	0d8a0913          	addi	s2,s4,216
    80001e4a:	158a8993          	addi	s3,s5,344
    80001e4e:	a00d                	j	80001e70 <fork+0xae>
    freeproc(np);
    80001e50:	8552                	mv	a0,s4
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	e22080e7          	jalr	-478(ra) # 80001c74 <freeproc>
    release(&np->lock);
    80001e5a:	8552                	mv	a0,s4
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	d14080e7          	jalr	-748(ra) # 80000b70 <release>
    return -1;
    80001e64:	54fd                	li	s1,-1
    80001e66:	a889                	j	80001eb8 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001e68:	04a1                	addi	s1,s1,8
    80001e6a:	0921                	addi	s2,s2,8
    80001e6c:	01348b63          	beq	s1,s3,80001e82 <fork+0xc0>
    if(p->ofile[i])
    80001e70:	6088                	ld	a0,0(s1)
    80001e72:	d97d                	beqz	a0,80001e68 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e74:	00002097          	auipc	ra,0x2
    80001e78:	79e080e7          	jalr	1950(ra) # 80004612 <filedup>
    80001e7c:	00a93023          	sd	a0,0(s2)
    80001e80:	b7e5                	j	80001e68 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e82:	158ab503          	ld	a0,344(s5)
    80001e86:	00002097          	auipc	ra,0x2
    80001e8a:	820080e7          	jalr	-2016(ra) # 800036a6 <idup>
    80001e8e:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e92:	4641                	li	a2,16
    80001e94:	160a8593          	addi	a1,s5,352
    80001e98:	160a0513          	addi	a0,s4,352
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	024080e7          	jalr	36(ra) # 80000ec0 <safestrcpy>
  pid = np->pid;
    80001ea4:	040a2483          	lw	s1,64(s4)
  np->state = RUNNABLE;
    80001ea8:	4789                	li	a5,2
    80001eaa:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001eae:	8552                	mv	a0,s4
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	cc0080e7          	jalr	-832(ra) # 80000b70 <release>
}
    80001eb8:	8526                	mv	a0,s1
    80001eba:	70e2                	ld	ra,56(sp)
    80001ebc:	7442                	ld	s0,48(sp)
    80001ebe:	74a2                	ld	s1,40(sp)
    80001ec0:	7902                	ld	s2,32(sp)
    80001ec2:	69e2                	ld	s3,24(sp)
    80001ec4:	6a42                	ld	s4,16(sp)
    80001ec6:	6aa2                	ld	s5,8(sp)
    80001ec8:	6121                	addi	sp,sp,64
    80001eca:	8082                	ret
    return -1;
    80001ecc:	54fd                	li	s1,-1
    80001ece:	b7ed                	j	80001eb8 <fork+0xf6>

0000000080001ed0 <reparent>:
{
    80001ed0:	7179                	addi	sp,sp,-48
    80001ed2:	f406                	sd	ra,40(sp)
    80001ed4:	f022                	sd	s0,32(sp)
    80001ed6:	ec26                	sd	s1,24(sp)
    80001ed8:	e84a                	sd	s2,16(sp)
    80001eda:	e44e                	sd	s3,8(sp)
    80001edc:	e052                	sd	s4,0(sp)
    80001ede:	1800                	addi	s0,sp,48
    80001ee0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ee2:	00013497          	auipc	s1,0x13
    80001ee6:	d7e48493          	addi	s1,s1,-642 # 80014c60 <proc>
      pp->parent = initproc;
    80001eea:	00026a17          	auipc	s4,0x26
    80001eee:	14ea0a13          	addi	s4,s4,334 # 80028038 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ef2:	00014997          	auipc	s3,0x14
    80001ef6:	bce98993          	addi	s3,s3,-1074 # 80015ac0 <tickslock>
    80001efa:	a029                	j	80001f04 <reparent+0x34>
    80001efc:	17048493          	addi	s1,s1,368
    80001f00:	03348363          	beq	s1,s3,80001f26 <reparent+0x56>
    if(pp->parent == p){
    80001f04:	749c                	ld	a5,40(s1)
    80001f06:	ff279be3          	bne	a5,s2,80001efc <reparent+0x2c>
      acquire(&pp->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	b94080e7          	jalr	-1132(ra) # 80000aa0 <acquire>
      pp->parent = initproc;
    80001f14:	000a3783          	ld	a5,0(s4)
    80001f18:	f49c                	sd	a5,40(s1)
      release(&pp->lock);
    80001f1a:	8526                	mv	a0,s1
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	c54080e7          	jalr	-940(ra) # 80000b70 <release>
    80001f24:	bfe1                	j	80001efc <reparent+0x2c>
}
    80001f26:	70a2                	ld	ra,40(sp)
    80001f28:	7402                	ld	s0,32(sp)
    80001f2a:	64e2                	ld	s1,24(sp)
    80001f2c:	6942                	ld	s2,16(sp)
    80001f2e:	69a2                	ld	s3,8(sp)
    80001f30:	6a02                	ld	s4,0(sp)
    80001f32:	6145                	addi	sp,sp,48
    80001f34:	8082                	ret

0000000080001f36 <scheduler>:
{
    80001f36:	715d                	addi	sp,sp,-80
    80001f38:	e486                	sd	ra,72(sp)
    80001f3a:	e0a2                	sd	s0,64(sp)
    80001f3c:	fc26                	sd	s1,56(sp)
    80001f3e:	f84a                	sd	s2,48(sp)
    80001f40:	f44e                	sd	s3,40(sp)
    80001f42:	f052                	sd	s4,32(sp)
    80001f44:	ec56                	sd	s5,24(sp)
    80001f46:	e85a                	sd	s6,16(sp)
    80001f48:	e45e                	sd	s7,8(sp)
    80001f4a:	e062                	sd	s8,0(sp)
    80001f4c:	0880                	addi	s0,sp,80
    80001f4e:	8792                	mv	a5,tp
  int id = r_tp();
    80001f50:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f52:	00779b13          	slli	s6,a5,0x7
    80001f56:	00013717          	auipc	a4,0x13
    80001f5a:	8ea70713          	addi	a4,a4,-1814 # 80014840 <pid_lock>
    80001f5e:	975a                	add	a4,a4,s6
    80001f60:	02073023          	sd	zero,32(a4)
        swtch(&c->scheduler, &p->context);
    80001f64:	00013717          	auipc	a4,0x13
    80001f68:	90470713          	addi	a4,a4,-1788 # 80014868 <cpus+0x8>
    80001f6c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f6e:	4b8d                	li	s7,3
        c->proc = p;
    80001f70:	079e                	slli	a5,a5,0x7
    80001f72:	00013917          	auipc	s2,0x13
    80001f76:	8ce90913          	addi	s2,s2,-1842 # 80014840 <pid_lock>
    80001f7a:	993e                	add	s2,s2,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f7c:	00014a17          	auipc	s4,0x14
    80001f80:	b44a0a13          	addi	s4,s4,-1212 # 80015ac0 <tickslock>
    80001f84:	a0b9                	j	80001fd2 <scheduler+0x9c>
      c->intena = 0;
    80001f86:	08092e23          	sw	zero,156(s2)
      release(&p->lock);
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	be4080e7          	jalr	-1052(ra) # 80000b70 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f94:	17048493          	addi	s1,s1,368
    80001f98:	03448963          	beq	s1,s4,80001fca <scheduler+0x94>
      acquire(&p->lock);
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	b02080e7          	jalr	-1278(ra) # 80000aa0 <acquire>
      if(p->state == RUNNABLE) {
    80001fa6:	509c                	lw	a5,32(s1)
    80001fa8:	fd379fe3          	bne	a5,s3,80001f86 <scheduler+0x50>
        p->state = RUNNING;
    80001fac:	0374a023          	sw	s7,32(s1)
        c->proc = p;
    80001fb0:	02993023          	sd	s1,32(s2)
        swtch(&c->scheduler, &p->context);
    80001fb4:	06848593          	addi	a1,s1,104
    80001fb8:	855a                	mv	a0,s6
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	614080e7          	jalr	1556(ra) # 800025ce <swtch>
        c->proc = 0;
    80001fc2:	02093023          	sd	zero,32(s2)
        found = 1;
    80001fc6:	8ae2                	mv	s5,s8
    80001fc8:	bf7d                	j	80001f86 <scheduler+0x50>
    if(found == 0){
    80001fca:	000a9463          	bnez	s5,80001fd2 <scheduler+0x9c>
      asm volatile("wfi");
    80001fce:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fd6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fda:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001fe2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe4:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001fe8:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fea:	00013497          	auipc	s1,0x13
    80001fee:	c7648493          	addi	s1,s1,-906 # 80014c60 <proc>
      if(p->state == RUNNABLE) {
    80001ff2:	4989                	li	s3,2
        found = 1;
    80001ff4:	4c05                	li	s8,1
    80001ff6:	b75d                	j	80001f9c <scheduler+0x66>

0000000080001ff8 <sched>:
{
    80001ff8:	7179                	addi	sp,sp,-48
    80001ffa:	f406                	sd	ra,40(sp)
    80001ffc:	f022                	sd	s0,32(sp)
    80001ffe:	ec26                	sd	s1,24(sp)
    80002000:	e84a                	sd	s2,16(sp)
    80002002:	e44e                	sd	s3,8(sp)
    80002004:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002006:	00000097          	auipc	ra,0x0
    8000200a:	a52080e7          	jalr	-1454(ra) # 80001a58 <myproc>
    8000200e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	a12080e7          	jalr	-1518(ra) # 80000a22 <holding>
    80002018:	c93d                	beqz	a0,8000208e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000201a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000201c:	2781                	sext.w	a5,a5
    8000201e:	079e                	slli	a5,a5,0x7
    80002020:	00013717          	auipc	a4,0x13
    80002024:	82070713          	addi	a4,a4,-2016 # 80014840 <pid_lock>
    80002028:	97ba                	add	a5,a5,a4
    8000202a:	0987a703          	lw	a4,152(a5)
    8000202e:	4785                	li	a5,1
    80002030:	06f71763          	bne	a4,a5,8000209e <sched+0xa6>
  if(p->state == RUNNING)
    80002034:	5098                	lw	a4,32(s1)
    80002036:	478d                	li	a5,3
    80002038:	06f70b63          	beq	a4,a5,800020ae <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000203c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002040:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002042:	efb5                	bnez	a5,800020be <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002044:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002046:	00012917          	auipc	s2,0x12
    8000204a:	7fa90913          	addi	s2,s2,2042 # 80014840 <pid_lock>
    8000204e:	2781                	sext.w	a5,a5
    80002050:	079e                	slli	a5,a5,0x7
    80002052:	97ca                	add	a5,a5,s2
    80002054:	09c7a983          	lw	s3,156(a5)
    80002058:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    8000205a:	2781                	sext.w	a5,a5
    8000205c:	079e                	slli	a5,a5,0x7
    8000205e:	00013597          	auipc	a1,0x13
    80002062:	80a58593          	addi	a1,a1,-2038 # 80014868 <cpus+0x8>
    80002066:	95be                	add	a1,a1,a5
    80002068:	06848513          	addi	a0,s1,104
    8000206c:	00000097          	auipc	ra,0x0
    80002070:	562080e7          	jalr	1378(ra) # 800025ce <swtch>
    80002074:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002076:	2781                	sext.w	a5,a5
    80002078:	079e                	slli	a5,a5,0x7
    8000207a:	97ca                	add	a5,a5,s2
    8000207c:	0937ae23          	sw	s3,156(a5)
}
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret
    panic("sched p->lock");
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	3ca50513          	addi	a0,a0,970 # 80008458 <userret+0x3c8>
    80002096:	ffffe097          	auipc	ra,0xffffe
    8000209a:	4be080e7          	jalr	1214(ra) # 80000554 <panic>
    panic("sched locks");
    8000209e:	00006517          	auipc	a0,0x6
    800020a2:	3ca50513          	addi	a0,a0,970 # 80008468 <userret+0x3d8>
    800020a6:	ffffe097          	auipc	ra,0xffffe
    800020aa:	4ae080e7          	jalr	1198(ra) # 80000554 <panic>
    panic("sched running");
    800020ae:	00006517          	auipc	a0,0x6
    800020b2:	3ca50513          	addi	a0,a0,970 # 80008478 <userret+0x3e8>
    800020b6:	ffffe097          	auipc	ra,0xffffe
    800020ba:	49e080e7          	jalr	1182(ra) # 80000554 <panic>
    panic("sched interruptible");
    800020be:	00006517          	auipc	a0,0x6
    800020c2:	3ca50513          	addi	a0,a0,970 # 80008488 <userret+0x3f8>
    800020c6:	ffffe097          	auipc	ra,0xffffe
    800020ca:	48e080e7          	jalr	1166(ra) # 80000554 <panic>

00000000800020ce <exit>:
{
    800020ce:	7179                	addi	sp,sp,-48
    800020d0:	f406                	sd	ra,40(sp)
    800020d2:	f022                	sd	s0,32(sp)
    800020d4:	ec26                	sd	s1,24(sp)
    800020d6:	e84a                	sd	s2,16(sp)
    800020d8:	e44e                	sd	s3,8(sp)
    800020da:	e052                	sd	s4,0(sp)
    800020dc:	1800                	addi	s0,sp,48
    800020de:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	978080e7          	jalr	-1672(ra) # 80001a58 <myproc>
    800020e8:	89aa                	mv	s3,a0
  if(p == initproc)
    800020ea:	00026797          	auipc	a5,0x26
    800020ee:	f4e7b783          	ld	a5,-178(a5) # 80028038 <initproc>
    800020f2:	0d850493          	addi	s1,a0,216
    800020f6:	15850913          	addi	s2,a0,344
    800020fa:	02a79363          	bne	a5,a0,80002120 <exit+0x52>
    panic("init exiting");
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	3a250513          	addi	a0,a0,930 # 800084a0 <userret+0x410>
    80002106:	ffffe097          	auipc	ra,0xffffe
    8000210a:	44e080e7          	jalr	1102(ra) # 80000554 <panic>
      fileclose(f);
    8000210e:	00002097          	auipc	ra,0x2
    80002112:	556080e7          	jalr	1366(ra) # 80004664 <fileclose>
      p->ofile[fd] = 0;
    80002116:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000211a:	04a1                	addi	s1,s1,8
    8000211c:	01248563          	beq	s1,s2,80002126 <exit+0x58>
    if(p->ofile[fd]){
    80002120:	6088                	ld	a0,0(s1)
    80002122:	f575                	bnez	a0,8000210e <exit+0x40>
    80002124:	bfdd                	j	8000211a <exit+0x4c>
  begin_op(ROOTDEV);
    80002126:	4501                	li	a0,0
    80002128:	00002097          	auipc	ra,0x2
    8000212c:	fa2080e7          	jalr	-94(ra) # 800040ca <begin_op>
  iput(p->cwd);
    80002130:	1589b503          	ld	a0,344(s3)
    80002134:	00001097          	auipc	ra,0x1
    80002138:	6be080e7          	jalr	1726(ra) # 800037f2 <iput>
  end_op(ROOTDEV);
    8000213c:	4501                	li	a0,0
    8000213e:	00002097          	auipc	ra,0x2
    80002142:	036080e7          	jalr	54(ra) # 80004174 <end_op>
  p->cwd = 0;
    80002146:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    8000214a:	00026497          	auipc	s1,0x26
    8000214e:	eee48493          	addi	s1,s1,-274 # 80028038 <initproc>
    80002152:	6088                	ld	a0,0(s1)
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	94c080e7          	jalr	-1716(ra) # 80000aa0 <acquire>
  wakeup1(initproc);
    8000215c:	6088                	ld	a0,0(s1)
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	7ba080e7          	jalr	1978(ra) # 80001918 <wakeup1>
  release(&initproc->lock);
    80002166:	6088                	ld	a0,0(s1)
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	a08080e7          	jalr	-1528(ra) # 80000b70 <release>
  acquire(&p->lock);
    80002170:	854e                	mv	a0,s3
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	92e080e7          	jalr	-1746(ra) # 80000aa0 <acquire>
  struct proc *original_parent = p->parent;
    8000217a:	0289b483          	ld	s1,40(s3)
  release(&p->lock);
    8000217e:	854e                	mv	a0,s3
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	9f0080e7          	jalr	-1552(ra) # 80000b70 <release>
  acquire(&original_parent->lock);
    80002188:	8526                	mv	a0,s1
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	916080e7          	jalr	-1770(ra) # 80000aa0 <acquire>
  acquire(&p->lock);
    80002192:	854e                	mv	a0,s3
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	90c080e7          	jalr	-1780(ra) # 80000aa0 <acquire>
  reparent(p);
    8000219c:	854e                	mv	a0,s3
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	d32080e7          	jalr	-718(ra) # 80001ed0 <reparent>
  wakeup1(original_parent);
    800021a6:	8526                	mv	a0,s1
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	770080e7          	jalr	1904(ra) # 80001918 <wakeup1>
  p->xstate = status;
    800021b0:	0349ae23          	sw	s4,60(s3)
  p->state = ZOMBIE;
    800021b4:	4791                	li	a5,4
    800021b6:	02f9a023          	sw	a5,32(s3)
  release(&original_parent->lock);
    800021ba:	8526                	mv	a0,s1
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	9b4080e7          	jalr	-1612(ra) # 80000b70 <release>
  sched();
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	e34080e7          	jalr	-460(ra) # 80001ff8 <sched>
  panic("zombie exit");
    800021cc:	00006517          	auipc	a0,0x6
    800021d0:	2e450513          	addi	a0,a0,740 # 800084b0 <userret+0x420>
    800021d4:	ffffe097          	auipc	ra,0xffffe
    800021d8:	380080e7          	jalr	896(ra) # 80000554 <panic>

00000000800021dc <yield>:
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	e426                	sd	s1,8(sp)
    800021e4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021e6:	00000097          	auipc	ra,0x0
    800021ea:	872080e7          	jalr	-1934(ra) # 80001a58 <myproc>
    800021ee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	8b0080e7          	jalr	-1872(ra) # 80000aa0 <acquire>
  p->state = RUNNABLE;
    800021f8:	4789                	li	a5,2
    800021fa:	d09c                	sw	a5,32(s1)
  sched();
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	dfc080e7          	jalr	-516(ra) # 80001ff8 <sched>
  release(&p->lock);
    80002204:	8526                	mv	a0,s1
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	96a080e7          	jalr	-1686(ra) # 80000b70 <release>
}
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret

0000000080002218 <sleep>:
{
    80002218:	7179                	addi	sp,sp,-48
    8000221a:	f406                	sd	ra,40(sp)
    8000221c:	f022                	sd	s0,32(sp)
    8000221e:	ec26                	sd	s1,24(sp)
    80002220:	e84a                	sd	s2,16(sp)
    80002222:	e44e                	sd	s3,8(sp)
    80002224:	1800                	addi	s0,sp,48
    80002226:	89aa                	mv	s3,a0
    80002228:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	82e080e7          	jalr	-2002(ra) # 80001a58 <myproc>
    80002232:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002234:	05250663          	beq	a0,s2,80002280 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	868080e7          	jalr	-1944(ra) # 80000aa0 <acquire>
    release(lk);
    80002240:	854a                	mv	a0,s2
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	92e080e7          	jalr	-1746(ra) # 80000b70 <release>
  p->chan = chan;
    8000224a:	0334b823          	sd	s3,48(s1)
  p->state = SLEEPING;
    8000224e:	4785                	li	a5,1
    80002250:	d09c                	sw	a5,32(s1)
  sched();
    80002252:	00000097          	auipc	ra,0x0
    80002256:	da6080e7          	jalr	-602(ra) # 80001ff8 <sched>
  p->chan = 0;
    8000225a:	0204b823          	sd	zero,48(s1)
    release(&p->lock);
    8000225e:	8526                	mv	a0,s1
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	910080e7          	jalr	-1776(ra) # 80000b70 <release>
    acquire(lk);
    80002268:	854a                	mv	a0,s2
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	836080e7          	jalr	-1994(ra) # 80000aa0 <acquire>
}
    80002272:	70a2                	ld	ra,40(sp)
    80002274:	7402                	ld	s0,32(sp)
    80002276:	64e2                	ld	s1,24(sp)
    80002278:	6942                	ld	s2,16(sp)
    8000227a:	69a2                	ld	s3,8(sp)
    8000227c:	6145                	addi	sp,sp,48
    8000227e:	8082                	ret
  p->chan = chan;
    80002280:	03353823          	sd	s3,48(a0)
  p->state = SLEEPING;
    80002284:	4785                	li	a5,1
    80002286:	d11c                	sw	a5,32(a0)
  sched();
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	d70080e7          	jalr	-656(ra) # 80001ff8 <sched>
  p->chan = 0;
    80002290:	0204b823          	sd	zero,48(s1)
  if(lk != &p->lock){
    80002294:	bff9                	j	80002272 <sleep+0x5a>

0000000080002296 <wait>:
{
    80002296:	715d                	addi	sp,sp,-80
    80002298:	e486                	sd	ra,72(sp)
    8000229a:	e0a2                	sd	s0,64(sp)
    8000229c:	fc26                	sd	s1,56(sp)
    8000229e:	f84a                	sd	s2,48(sp)
    800022a0:	f44e                	sd	s3,40(sp)
    800022a2:	f052                	sd	s4,32(sp)
    800022a4:	ec56                	sd	s5,24(sp)
    800022a6:	e85a                	sd	s6,16(sp)
    800022a8:	e45e                	sd	s7,8(sp)
    800022aa:	0880                	addi	s0,sp,80
    800022ac:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	7aa080e7          	jalr	1962(ra) # 80001a58 <myproc>
    800022b6:	892a                	mv	s2,a0
  acquire(&p->lock);
    800022b8:	ffffe097          	auipc	ra,0xffffe
    800022bc:	7e8080e7          	jalr	2024(ra) # 80000aa0 <acquire>
    havekids = 0;
    800022c0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800022c2:	4a11                	li	s4,4
        havekids = 1;
    800022c4:	4b05                	li	s6,1
    for(np = proc; np < &proc[NPROC]; np++){
    800022c6:	00013997          	auipc	s3,0x13
    800022ca:	7fa98993          	addi	s3,s3,2042 # 80015ac0 <tickslock>
    havekids = 0;
    800022ce:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800022d0:	00013497          	auipc	s1,0x13
    800022d4:	99048493          	addi	s1,s1,-1648 # 80014c60 <proc>
    800022d8:	a08d                	j	8000233a <wait+0xa4>
          pid = np->pid;
    800022da:	0404a983          	lw	s3,64(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022de:	000a8e63          	beqz	s5,800022fa <wait+0x64>
    800022e2:	4691                	li	a3,4
    800022e4:	03c48613          	addi	a2,s1,60
    800022e8:	85d6                	mv	a1,s5
    800022ea:	05893503          	ld	a0,88(s2)
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	45c080e7          	jalr	1116(ra) # 8000174a <copyout>
    800022f6:	02054263          	bltz	a0,8000231a <wait+0x84>
          freeproc(np);
    800022fa:	8526                	mv	a0,s1
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	978080e7          	jalr	-1672(ra) # 80001c74 <freeproc>
          release(&np->lock);
    80002304:	8526                	mv	a0,s1
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	86a080e7          	jalr	-1942(ra) # 80000b70 <release>
          release(&p->lock);
    8000230e:	854a                	mv	a0,s2
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	860080e7          	jalr	-1952(ra) # 80000b70 <release>
          return pid;
    80002318:	a8a9                	j	80002372 <wait+0xdc>
            release(&np->lock);
    8000231a:	8526                	mv	a0,s1
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	854080e7          	jalr	-1964(ra) # 80000b70 <release>
            release(&p->lock);
    80002324:	854a                	mv	a0,s2
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	84a080e7          	jalr	-1974(ra) # 80000b70 <release>
            return -1;
    8000232e:	59fd                	li	s3,-1
    80002330:	a089                	j	80002372 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    80002332:	17048493          	addi	s1,s1,368
    80002336:	03348463          	beq	s1,s3,8000235e <wait+0xc8>
      if(np->parent == p){
    8000233a:	749c                	ld	a5,40(s1)
    8000233c:	ff279be3          	bne	a5,s2,80002332 <wait+0x9c>
        acquire(&np->lock);
    80002340:	8526                	mv	a0,s1
    80002342:	ffffe097          	auipc	ra,0xffffe
    80002346:	75e080e7          	jalr	1886(ra) # 80000aa0 <acquire>
        if(np->state == ZOMBIE){
    8000234a:	509c                	lw	a5,32(s1)
    8000234c:	f94787e3          	beq	a5,s4,800022da <wait+0x44>
        release(&np->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	81e080e7          	jalr	-2018(ra) # 80000b70 <release>
        havekids = 1;
    8000235a:	875a                	mv	a4,s6
    8000235c:	bfd9                	j	80002332 <wait+0x9c>
    if(!havekids || p->killed){
    8000235e:	c701                	beqz	a4,80002366 <wait+0xd0>
    80002360:	03892783          	lw	a5,56(s2)
    80002364:	c39d                	beqz	a5,8000238a <wait+0xf4>
      release(&p->lock);
    80002366:	854a                	mv	a0,s2
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	808080e7          	jalr	-2040(ra) # 80000b70 <release>
      return -1;
    80002370:	59fd                	li	s3,-1
}
    80002372:	854e                	mv	a0,s3
    80002374:	60a6                	ld	ra,72(sp)
    80002376:	6406                	ld	s0,64(sp)
    80002378:	74e2                	ld	s1,56(sp)
    8000237a:	7942                	ld	s2,48(sp)
    8000237c:	79a2                	ld	s3,40(sp)
    8000237e:	7a02                	ld	s4,32(sp)
    80002380:	6ae2                	ld	s5,24(sp)
    80002382:	6b42                	ld	s6,16(sp)
    80002384:	6ba2                	ld	s7,8(sp)
    80002386:	6161                	addi	sp,sp,80
    80002388:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000238a:	85ca                	mv	a1,s2
    8000238c:	854a                	mv	a0,s2
    8000238e:	00000097          	auipc	ra,0x0
    80002392:	e8a080e7          	jalr	-374(ra) # 80002218 <sleep>
    havekids = 0;
    80002396:	bf25                	j	800022ce <wait+0x38>

0000000080002398 <wakeup>:
{
    80002398:	7139                	addi	sp,sp,-64
    8000239a:	fc06                	sd	ra,56(sp)
    8000239c:	f822                	sd	s0,48(sp)
    8000239e:	f426                	sd	s1,40(sp)
    800023a0:	f04a                	sd	s2,32(sp)
    800023a2:	ec4e                	sd	s3,24(sp)
    800023a4:	e852                	sd	s4,16(sp)
    800023a6:	e456                	sd	s5,8(sp)
    800023a8:	0080                	addi	s0,sp,64
    800023aa:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023ac:	00013497          	auipc	s1,0x13
    800023b0:	8b448493          	addi	s1,s1,-1868 # 80014c60 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800023b4:	4985                	li	s3,1
      p->state = RUNNABLE;
    800023b6:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800023b8:	00013917          	auipc	s2,0x13
    800023bc:	70890913          	addi	s2,s2,1800 # 80015ac0 <tickslock>
    800023c0:	a811                	j	800023d4 <wakeup+0x3c>
    release(&p->lock);
    800023c2:	8526                	mv	a0,s1
    800023c4:	ffffe097          	auipc	ra,0xffffe
    800023c8:	7ac080e7          	jalr	1964(ra) # 80000b70 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800023cc:	17048493          	addi	s1,s1,368
    800023d0:	03248063          	beq	s1,s2,800023f0 <wakeup+0x58>
    acquire(&p->lock);
    800023d4:	8526                	mv	a0,s1
    800023d6:	ffffe097          	auipc	ra,0xffffe
    800023da:	6ca080e7          	jalr	1738(ra) # 80000aa0 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023de:	509c                	lw	a5,32(s1)
    800023e0:	ff3791e3          	bne	a5,s3,800023c2 <wakeup+0x2a>
    800023e4:	789c                	ld	a5,48(s1)
    800023e6:	fd479ee3          	bne	a5,s4,800023c2 <wakeup+0x2a>
      p->state = RUNNABLE;
    800023ea:	0354a023          	sw	s5,32(s1)
    800023ee:	bfd1                	j	800023c2 <wakeup+0x2a>
}
    800023f0:	70e2                	ld	ra,56(sp)
    800023f2:	7442                	ld	s0,48(sp)
    800023f4:	74a2                	ld	s1,40(sp)
    800023f6:	7902                	ld	s2,32(sp)
    800023f8:	69e2                	ld	s3,24(sp)
    800023fa:	6a42                	ld	s4,16(sp)
    800023fc:	6aa2                	ld	s5,8(sp)
    800023fe:	6121                	addi	sp,sp,64
    80002400:	8082                	ret

0000000080002402 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002402:	7179                	addi	sp,sp,-48
    80002404:	f406                	sd	ra,40(sp)
    80002406:	f022                	sd	s0,32(sp)
    80002408:	ec26                	sd	s1,24(sp)
    8000240a:	e84a                	sd	s2,16(sp)
    8000240c:	e44e                	sd	s3,8(sp)
    8000240e:	1800                	addi	s0,sp,48
    80002410:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002412:	00013497          	auipc	s1,0x13
    80002416:	84e48493          	addi	s1,s1,-1970 # 80014c60 <proc>
    8000241a:	00013997          	auipc	s3,0x13
    8000241e:	6a698993          	addi	s3,s3,1702 # 80015ac0 <tickslock>
    acquire(&p->lock);
    80002422:	8526                	mv	a0,s1
    80002424:	ffffe097          	auipc	ra,0xffffe
    80002428:	67c080e7          	jalr	1660(ra) # 80000aa0 <acquire>
    if(p->pid == pid){
    8000242c:	40bc                	lw	a5,64(s1)
    8000242e:	03278363          	beq	a5,s2,80002454 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002432:	8526                	mv	a0,s1
    80002434:	ffffe097          	auipc	ra,0xffffe
    80002438:	73c080e7          	jalr	1852(ra) # 80000b70 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000243c:	17048493          	addi	s1,s1,368
    80002440:	ff3491e3          	bne	s1,s3,80002422 <kill+0x20>
  }
  return -1;
    80002444:	557d                	li	a0,-1
}
    80002446:	70a2                	ld	ra,40(sp)
    80002448:	7402                	ld	s0,32(sp)
    8000244a:	64e2                	ld	s1,24(sp)
    8000244c:	6942                	ld	s2,16(sp)
    8000244e:	69a2                	ld	s3,8(sp)
    80002450:	6145                	addi	sp,sp,48
    80002452:	8082                	ret
      p->killed = 1;
    80002454:	4785                	li	a5,1
    80002456:	dc9c                	sw	a5,56(s1)
      if(p->state == SLEEPING){
    80002458:	5098                	lw	a4,32(s1)
    8000245a:	00f70963          	beq	a4,a5,8000246c <kill+0x6a>
      release(&p->lock);
    8000245e:	8526                	mv	a0,s1
    80002460:	ffffe097          	auipc	ra,0xffffe
    80002464:	710080e7          	jalr	1808(ra) # 80000b70 <release>
      return 0;
    80002468:	4501                	li	a0,0
    8000246a:	bff1                	j	80002446 <kill+0x44>
        p->state = RUNNABLE;
    8000246c:	4789                	li	a5,2
    8000246e:	d09c                	sw	a5,32(s1)
    80002470:	b7fd                	j	8000245e <kill+0x5c>

0000000080002472 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002472:	7179                	addi	sp,sp,-48
    80002474:	f406                	sd	ra,40(sp)
    80002476:	f022                	sd	s0,32(sp)
    80002478:	ec26                	sd	s1,24(sp)
    8000247a:	e84a                	sd	s2,16(sp)
    8000247c:	e44e                	sd	s3,8(sp)
    8000247e:	e052                	sd	s4,0(sp)
    80002480:	1800                	addi	s0,sp,48
    80002482:	84aa                	mv	s1,a0
    80002484:	892e                	mv	s2,a1
    80002486:	89b2                	mv	s3,a2
    80002488:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	5ce080e7          	jalr	1486(ra) # 80001a58 <myproc>
  if(user_dst){
    80002492:	c08d                	beqz	s1,800024b4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002494:	86d2                	mv	a3,s4
    80002496:	864e                	mv	a2,s3
    80002498:	85ca                	mv	a1,s2
    8000249a:	6d28                	ld	a0,88(a0)
    8000249c:	fffff097          	auipc	ra,0xfffff
    800024a0:	2ae080e7          	jalr	686(ra) # 8000174a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024a4:	70a2                	ld	ra,40(sp)
    800024a6:	7402                	ld	s0,32(sp)
    800024a8:	64e2                	ld	s1,24(sp)
    800024aa:	6942                	ld	s2,16(sp)
    800024ac:	69a2                	ld	s3,8(sp)
    800024ae:	6a02                	ld	s4,0(sp)
    800024b0:	6145                	addi	sp,sp,48
    800024b2:	8082                	ret
    memmove((char *)dst, src, len);
    800024b4:	000a061b          	sext.w	a2,s4
    800024b8:	85ce                	mv	a1,s3
    800024ba:	854a                	mv	a0,s2
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	90e080e7          	jalr	-1778(ra) # 80000dca <memmove>
    return 0;
    800024c4:	8526                	mv	a0,s1
    800024c6:	bff9                	j	800024a4 <either_copyout+0x32>

00000000800024c8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024c8:	7179                	addi	sp,sp,-48
    800024ca:	f406                	sd	ra,40(sp)
    800024cc:	f022                	sd	s0,32(sp)
    800024ce:	ec26                	sd	s1,24(sp)
    800024d0:	e84a                	sd	s2,16(sp)
    800024d2:	e44e                	sd	s3,8(sp)
    800024d4:	e052                	sd	s4,0(sp)
    800024d6:	1800                	addi	s0,sp,48
    800024d8:	892a                	mv	s2,a0
    800024da:	84ae                	mv	s1,a1
    800024dc:	89b2                	mv	s3,a2
    800024de:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024e0:	fffff097          	auipc	ra,0xfffff
    800024e4:	578080e7          	jalr	1400(ra) # 80001a58 <myproc>
  if(user_src){
    800024e8:	c08d                	beqz	s1,8000250a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024ea:	86d2                	mv	a3,s4
    800024ec:	864e                	mv	a2,s3
    800024ee:	85ca                	mv	a1,s2
    800024f0:	6d28                	ld	a0,88(a0)
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	2e4080e7          	jalr	740(ra) # 800017d6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024fa:	70a2                	ld	ra,40(sp)
    800024fc:	7402                	ld	s0,32(sp)
    800024fe:	64e2                	ld	s1,24(sp)
    80002500:	6942                	ld	s2,16(sp)
    80002502:	69a2                	ld	s3,8(sp)
    80002504:	6a02                	ld	s4,0(sp)
    80002506:	6145                	addi	sp,sp,48
    80002508:	8082                	ret
    memmove(dst, (char*)src, len);
    8000250a:	000a061b          	sext.w	a2,s4
    8000250e:	85ce                	mv	a1,s3
    80002510:	854a                	mv	a0,s2
    80002512:	fffff097          	auipc	ra,0xfffff
    80002516:	8b8080e7          	jalr	-1864(ra) # 80000dca <memmove>
    return 0;
    8000251a:	8526                	mv	a0,s1
    8000251c:	bff9                	j	800024fa <either_copyin+0x32>

000000008000251e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000251e:	715d                	addi	sp,sp,-80
    80002520:	e486                	sd	ra,72(sp)
    80002522:	e0a2                	sd	s0,64(sp)
    80002524:	fc26                	sd	s1,56(sp)
    80002526:	f84a                	sd	s2,48(sp)
    80002528:	f44e                	sd	s3,40(sp)
    8000252a:	f052                	sd	s4,32(sp)
    8000252c:	ec56                	sd	s5,24(sp)
    8000252e:	e85a                	sd	s6,16(sp)
    80002530:	e45e                	sd	s7,8(sp)
    80002532:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002534:	00006517          	auipc	a0,0x6
    80002538:	d5c50513          	addi	a0,a0,-676 # 80008290 <userret+0x200>
    8000253c:	ffffe097          	auipc	ra,0xffffe
    80002540:	072080e7          	jalr	114(ra) # 800005ae <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002544:	00013497          	auipc	s1,0x13
    80002548:	87c48493          	addi	s1,s1,-1924 # 80014dc0 <proc+0x160>
    8000254c:	00013917          	auipc	s2,0x13
    80002550:	6d490913          	addi	s2,s2,1748 # 80015c20 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002554:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002556:	00006997          	auipc	s3,0x6
    8000255a:	f6a98993          	addi	s3,s3,-150 # 800084c0 <userret+0x430>
    printf("%d %s %s", p->pid, state, p->name);
    8000255e:	00006a97          	auipc	s5,0x6
    80002562:	f6aa8a93          	addi	s5,s5,-150 # 800084c8 <userret+0x438>
    printf("\n");
    80002566:	00006a17          	auipc	s4,0x6
    8000256a:	d2aa0a13          	addi	s4,s4,-726 # 80008290 <userret+0x200>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000256e:	00006b97          	auipc	s7,0x6
    80002572:	7bab8b93          	addi	s7,s7,1978 # 80008d28 <states.0>
    80002576:	a00d                	j	80002598 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002578:	ee06a583          	lw	a1,-288(a3)
    8000257c:	8556                	mv	a0,s5
    8000257e:	ffffe097          	auipc	ra,0xffffe
    80002582:	030080e7          	jalr	48(ra) # 800005ae <printf>
    printf("\n");
    80002586:	8552                	mv	a0,s4
    80002588:	ffffe097          	auipc	ra,0xffffe
    8000258c:	026080e7          	jalr	38(ra) # 800005ae <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002590:	17048493          	addi	s1,s1,368
    80002594:	03248263          	beq	s1,s2,800025b8 <procdump+0x9a>
    if(p->state == UNUSED)
    80002598:	86a6                	mv	a3,s1
    8000259a:	ec04a783          	lw	a5,-320(s1)
    8000259e:	dbed                	beqz	a5,80002590 <procdump+0x72>
      state = "???";
    800025a0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a2:	fcfb6be3          	bltu	s6,a5,80002578 <procdump+0x5a>
    800025a6:	02079713          	slli	a4,a5,0x20
    800025aa:	01d75793          	srli	a5,a4,0x1d
    800025ae:	97de                	add	a5,a5,s7
    800025b0:	6390                	ld	a2,0(a5)
    800025b2:	f279                	bnez	a2,80002578 <procdump+0x5a>
      state = "???";
    800025b4:	864e                	mv	a2,s3
    800025b6:	b7c9                	j	80002578 <procdump+0x5a>
  }
}
    800025b8:	60a6                	ld	ra,72(sp)
    800025ba:	6406                	ld	s0,64(sp)
    800025bc:	74e2                	ld	s1,56(sp)
    800025be:	7942                	ld	s2,48(sp)
    800025c0:	79a2                	ld	s3,40(sp)
    800025c2:	7a02                	ld	s4,32(sp)
    800025c4:	6ae2                	ld	s5,24(sp)
    800025c6:	6b42                	ld	s6,16(sp)
    800025c8:	6ba2                	ld	s7,8(sp)
    800025ca:	6161                	addi	sp,sp,80
    800025cc:	8082                	ret

00000000800025ce <swtch>:
    800025ce:	00153023          	sd	ra,0(a0)
    800025d2:	00253423          	sd	sp,8(a0)
    800025d6:	e900                	sd	s0,16(a0)
    800025d8:	ed04                	sd	s1,24(a0)
    800025da:	03253023          	sd	s2,32(a0)
    800025de:	03353423          	sd	s3,40(a0)
    800025e2:	03453823          	sd	s4,48(a0)
    800025e6:	03553c23          	sd	s5,56(a0)
    800025ea:	05653023          	sd	s6,64(a0)
    800025ee:	05753423          	sd	s7,72(a0)
    800025f2:	05853823          	sd	s8,80(a0)
    800025f6:	05953c23          	sd	s9,88(a0)
    800025fa:	07a53023          	sd	s10,96(a0)
    800025fe:	07b53423          	sd	s11,104(a0)
    80002602:	0005b083          	ld	ra,0(a1)
    80002606:	0085b103          	ld	sp,8(a1)
    8000260a:	6980                	ld	s0,16(a1)
    8000260c:	6d84                	ld	s1,24(a1)
    8000260e:	0205b903          	ld	s2,32(a1)
    80002612:	0285b983          	ld	s3,40(a1)
    80002616:	0305ba03          	ld	s4,48(a1)
    8000261a:	0385ba83          	ld	s5,56(a1)
    8000261e:	0405bb03          	ld	s6,64(a1)
    80002622:	0485bb83          	ld	s7,72(a1)
    80002626:	0505bc03          	ld	s8,80(a1)
    8000262a:	0585bc83          	ld	s9,88(a1)
    8000262e:	0605bd03          	ld	s10,96(a1)
    80002632:	0685bd83          	ld	s11,104(a1)
    80002636:	8082                	ret

0000000080002638 <scause_desc>:
  }
}

static const char *
scause_desc(uint64 stval)
{
    80002638:	1141                	addi	sp,sp,-16
    8000263a:	e422                	sd	s0,8(sp)
    8000263c:	0800                	addi	s0,sp,16
    8000263e:	87aa                	mv	a5,a0
    [13] "load page fault",
    [14] "<reserved for future standard use>",
    [15] "store/AMO page fault",
  };
  uint64 interrupt = stval & 0x8000000000000000L;
  uint64 code = stval & ~0x8000000000000000L;
    80002640:	00151713          	slli	a4,a0,0x1
    80002644:	8305                	srli	a4,a4,0x1
  if (interrupt) {
    80002646:	04054c63          	bltz	a0,8000269e <scause_desc+0x66>
      return intr_desc[code];
    } else {
      return "<reserved for platform use>";
    }
  } else {
    if (code < NELEM(nointr_desc)) {
    8000264a:	5685                	li	a3,-31
    8000264c:	8285                	srli	a3,a3,0x1
    8000264e:	8ee9                	and	a3,a3,a0
    80002650:	caad                	beqz	a3,800026c2 <scause_desc+0x8a>
      return nointr_desc[code];
    } else if (code <= 23) {
    80002652:	46dd                	li	a3,23
      return "<reserved for future standard use>";
    80002654:	00006517          	auipc	a0,0x6
    80002658:	eac50513          	addi	a0,a0,-340 # 80008500 <userret+0x470>
    } else if (code <= 23) {
    8000265c:	06e6f063          	bgeu	a3,a4,800026bc <scause_desc+0x84>
    } else if (code <= 31) {
    80002660:	fc100693          	li	a3,-63
    80002664:	8285                	srli	a3,a3,0x1
    80002666:	8efd                	and	a3,a3,a5
      return "<reserved for custom use>";
    80002668:	00006517          	auipc	a0,0x6
    8000266c:	ec050513          	addi	a0,a0,-320 # 80008528 <userret+0x498>
    } else if (code <= 31) {
    80002670:	c6b1                	beqz	a3,800026bc <scause_desc+0x84>
    } else if (code <= 47) {
    80002672:	02f00693          	li	a3,47
      return "<reserved for future standard use>";
    80002676:	00006517          	auipc	a0,0x6
    8000267a:	e8a50513          	addi	a0,a0,-374 # 80008500 <userret+0x470>
    } else if (code <= 47) {
    8000267e:	02e6ff63          	bgeu	a3,a4,800026bc <scause_desc+0x84>
    } else if (code <= 63) {
    80002682:	f8100513          	li	a0,-127
    80002686:	8105                	srli	a0,a0,0x1
    80002688:	8fe9                	and	a5,a5,a0
      return "<reserved for custom use>";
    8000268a:	00006517          	auipc	a0,0x6
    8000268e:	e9e50513          	addi	a0,a0,-354 # 80008528 <userret+0x498>
    } else if (code <= 63) {
    80002692:	c78d                	beqz	a5,800026bc <scause_desc+0x84>
    } else {
      return "<reserved for future standard use>";
    80002694:	00006517          	auipc	a0,0x6
    80002698:	e6c50513          	addi	a0,a0,-404 # 80008500 <userret+0x470>
    8000269c:	a005                	j	800026bc <scause_desc+0x84>
    if (code < NELEM(intr_desc)) {
    8000269e:	5505                	li	a0,-31
    800026a0:	8105                	srli	a0,a0,0x1
    800026a2:	8fe9                	and	a5,a5,a0
      return "<reserved for platform use>";
    800026a4:	00006517          	auipc	a0,0x6
    800026a8:	ea450513          	addi	a0,a0,-348 # 80008548 <userret+0x4b8>
    if (code < NELEM(intr_desc)) {
    800026ac:	eb81                	bnez	a5,800026bc <scause_desc+0x84>
      return intr_desc[code];
    800026ae:	070e                	slli	a4,a4,0x3
    800026b0:	00006797          	auipc	a5,0x6
    800026b4:	6a078793          	addi	a5,a5,1696 # 80008d50 <intr_desc.1>
    800026b8:	973e                	add	a4,a4,a5
    800026ba:	6308                	ld	a0,0(a4)
    }
  }
}
    800026bc:	6422                	ld	s0,8(sp)
    800026be:	0141                	addi	sp,sp,16
    800026c0:	8082                	ret
      return nointr_desc[code];
    800026c2:	070e                	slli	a4,a4,0x3
    800026c4:	00006797          	auipc	a5,0x6
    800026c8:	68c78793          	addi	a5,a5,1676 # 80008d50 <intr_desc.1>
    800026cc:	973e                	add	a4,a4,a5
    800026ce:	6348                	ld	a0,128(a4)
    800026d0:	b7f5                	j	800026bc <scause_desc+0x84>

00000000800026d2 <trapinit>:
{
    800026d2:	1141                	addi	sp,sp,-16
    800026d4:	e406                	sd	ra,8(sp)
    800026d6:	e022                	sd	s0,0(sp)
    800026d8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026da:	00006597          	auipc	a1,0x6
    800026de:	e8e58593          	addi	a1,a1,-370 # 80008568 <userret+0x4d8>
    800026e2:	00013517          	auipc	a0,0x13
    800026e6:	3de50513          	addi	a0,a0,990 # 80015ac0 <tickslock>
    800026ea:	ffffe097          	auipc	ra,0xffffe
    800026ee:	2e2080e7          	jalr	738(ra) # 800009cc <initlock>
}
    800026f2:	60a2                	ld	ra,8(sp)
    800026f4:	6402                	ld	s0,0(sp)
    800026f6:	0141                	addi	sp,sp,16
    800026f8:	8082                	ret

00000000800026fa <trapinithart>:
{
    800026fa:	1141                	addi	sp,sp,-16
    800026fc:	e422                	sd	s0,8(sp)
    800026fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002700:	00003797          	auipc	a5,0x3
    80002704:	60078793          	addi	a5,a5,1536 # 80005d00 <kernelvec>
    80002708:	10579073          	csrw	stvec,a5
}
    8000270c:	6422                	ld	s0,8(sp)
    8000270e:	0141                	addi	sp,sp,16
    80002710:	8082                	ret

0000000080002712 <usertrapret>:
{
    80002712:	1141                	addi	sp,sp,-16
    80002714:	e406                	sd	ra,8(sp)
    80002716:	e022                	sd	s0,0(sp)
    80002718:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000271a:	fffff097          	auipc	ra,0xfffff
    8000271e:	33e080e7          	jalr	830(ra) # 80001a58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002722:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002726:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002728:	10079073          	csrw	sstatus,a5
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000272c:	00006617          	auipc	a2,0x6
    80002730:	8d460613          	addi	a2,a2,-1836 # 80008000 <trampoline>
    80002734:	00006697          	auipc	a3,0x6
    80002738:	8cc68693          	addi	a3,a3,-1844 # 80008000 <trampoline>
    8000273c:	8e91                	sub	a3,a3,a2
    8000273e:	040007b7          	lui	a5,0x4000
    80002742:	17fd                	addi	a5,a5,-1
    80002744:	07b2                	slli	a5,a5,0xc
    80002746:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002748:	10569073          	csrw	stvec,a3
  p->tf->kernel_satp = r_satp();         // kernel page table
    8000274c:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000274e:	180026f3          	csrr	a3,satp
    80002752:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002754:	7138                	ld	a4,96(a0)
    80002756:	6534                	ld	a3,72(a0)
    80002758:	6585                	lui	a1,0x1
    8000275a:	96ae                	add	a3,a3,a1
    8000275c:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    8000275e:	7138                	ld	a4,96(a0)
    80002760:	00000697          	auipc	a3,0x0
    80002764:	12c68693          	addi	a3,a3,300 # 8000288c <usertrap>
    80002768:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    8000276a:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000276c:	8692                	mv	a3,tp
    8000276e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002770:	100026f3          	csrr	a3,sstatus
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002774:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002778:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000277c:	10069073          	csrw	sstatus,a3
  w_sepc(p->tf->epc);
    80002780:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002782:	6f18                	ld	a4,24(a4)
    80002784:	14171073          	csrw	sepc,a4
  uint64 satp = MAKE_SATP(p->pagetable);
    80002788:	6d2c                	ld	a1,88(a0)
    8000278a:	81b1                	srli	a1,a1,0xc
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000278c:	00006717          	auipc	a4,0x6
    80002790:	90470713          	addi	a4,a4,-1788 # 80008090 <userret>
    80002794:	8f11                	sub	a4,a4,a2
    80002796:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002798:	577d                	li	a4,-1
    8000279a:	177e                	slli	a4,a4,0x3f
    8000279c:	8dd9                	or	a1,a1,a4
    8000279e:	02000537          	lui	a0,0x2000
    800027a2:	157d                	addi	a0,a0,-1
    800027a4:	0536                	slli	a0,a0,0xd
    800027a6:	9782                	jalr	a5
}
    800027a8:	60a2                	ld	ra,8(sp)
    800027aa:	6402                	ld	s0,0(sp)
    800027ac:	0141                	addi	sp,sp,16
    800027ae:	8082                	ret

00000000800027b0 <clockintr>:
{
    800027b0:	1101                	addi	sp,sp,-32
    800027b2:	ec06                	sd	ra,24(sp)
    800027b4:	e822                	sd	s0,16(sp)
    800027b6:	e426                	sd	s1,8(sp)
    800027b8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027ba:	00013497          	auipc	s1,0x13
    800027be:	30648493          	addi	s1,s1,774 # 80015ac0 <tickslock>
    800027c2:	8526                	mv	a0,s1
    800027c4:	ffffe097          	auipc	ra,0xffffe
    800027c8:	2dc080e7          	jalr	732(ra) # 80000aa0 <acquire>
  ticks++;
    800027cc:	00026517          	auipc	a0,0x26
    800027d0:	87450513          	addi	a0,a0,-1932 # 80028040 <ticks>
    800027d4:	411c                	lw	a5,0(a0)
    800027d6:	2785                	addiw	a5,a5,1
    800027d8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027da:	00000097          	auipc	ra,0x0
    800027de:	bbe080e7          	jalr	-1090(ra) # 80002398 <wakeup>
  release(&tickslock);
    800027e2:	8526                	mv	a0,s1
    800027e4:	ffffe097          	auipc	ra,0xffffe
    800027e8:	38c080e7          	jalr	908(ra) # 80000b70 <release>
}
    800027ec:	60e2                	ld	ra,24(sp)
    800027ee:	6442                	ld	s0,16(sp)
    800027f0:	64a2                	ld	s1,8(sp)
    800027f2:	6105                	addi	sp,sp,32
    800027f4:	8082                	ret

00000000800027f6 <devintr>:
{
    800027f6:	1101                	addi	sp,sp,-32
    800027f8:	ec06                	sd	ra,24(sp)
    800027fa:	e822                	sd	s0,16(sp)
    800027fc:	e426                	sd	s1,8(sp)
    800027fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002800:	14202773          	csrr	a4,scause
  if((scause & 0x8000000000000000L) &&
    80002804:	00074d63          	bltz	a4,8000281e <devintr+0x28>
  } else if(scause == 0x8000000000000001L){
    80002808:	57fd                	li	a5,-1
    8000280a:	17fe                	slli	a5,a5,0x3f
    8000280c:	0785                	addi	a5,a5,1
    return 0;
    8000280e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002810:	04f70d63          	beq	a4,a5,8000286a <devintr+0x74>
}
    80002814:	60e2                	ld	ra,24(sp)
    80002816:	6442                	ld	s0,16(sp)
    80002818:	64a2                	ld	s1,8(sp)
    8000281a:	6105                	addi	sp,sp,32
    8000281c:	8082                	ret
     (scause & 0xff) == 9){
    8000281e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002822:	46a5                	li	a3,9
    80002824:	fed792e3          	bne	a5,a3,80002808 <devintr+0x12>
    int irq = plic_claim();
    80002828:	00003097          	auipc	ra,0x3
    8000282c:	5e0080e7          	jalr	1504(ra) # 80005e08 <plic_claim>
    80002830:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002832:	47a9                	li	a5,10
    80002834:	00f50a63          	beq	a0,a5,80002848 <devintr+0x52>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    80002838:	fff5079b          	addiw	a5,a0,-1
    8000283c:	4705                	li	a4,1
    8000283e:	00f77a63          	bgeu	a4,a5,80002852 <devintr+0x5c>
    return 1;
    80002842:	4505                	li	a0,1
    if(irq)
    80002844:	d8e1                	beqz	s1,80002814 <devintr+0x1e>
    80002846:	a819                	j	8000285c <devintr+0x66>
      uartintr();
    80002848:	ffffe097          	auipc	ra,0xffffe
    8000284c:	ffc080e7          	jalr	-4(ra) # 80000844 <uartintr>
    80002850:	a031                	j	8000285c <devintr+0x66>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    80002852:	853e                	mv	a0,a5
    80002854:	00004097          	auipc	ra,0x4
    80002858:	b82080e7          	jalr	-1150(ra) # 800063d6 <virtio_disk_intr>
      plic_complete(irq);
    8000285c:	8526                	mv	a0,s1
    8000285e:	00003097          	auipc	ra,0x3
    80002862:	5ce080e7          	jalr	1486(ra) # 80005e2c <plic_complete>
    return 1;
    80002866:	4505                	li	a0,1
    80002868:	b775                	j	80002814 <devintr+0x1e>
    if(cpuid() == 0){
    8000286a:	fffff097          	auipc	ra,0xfffff
    8000286e:	1c2080e7          	jalr	450(ra) # 80001a2c <cpuid>
    80002872:	c901                	beqz	a0,80002882 <devintr+0x8c>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002874:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002878:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000287a:	14479073          	csrw	sip,a5
    return 2;
    8000287e:	4509                	li	a0,2
    80002880:	bf51                	j	80002814 <devintr+0x1e>
      clockintr();
    80002882:	00000097          	auipc	ra,0x0
    80002886:	f2e080e7          	jalr	-210(ra) # 800027b0 <clockintr>
    8000288a:	b7ed                	j	80002874 <devintr+0x7e>

000000008000288c <usertrap>:
{
    8000288c:	7179                	addi	sp,sp,-48
    8000288e:	f406                	sd	ra,40(sp)
    80002890:	f022                	sd	s0,32(sp)
    80002892:	ec26                	sd	s1,24(sp)
    80002894:	e84a                	sd	s2,16(sp)
    80002896:	e44e                	sd	s3,8(sp)
    80002898:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000289a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000289e:	1007f793          	andi	a5,a5,256
    800028a2:	e3b5                	bnez	a5,80002906 <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a4:	00003797          	auipc	a5,0x3
    800028a8:	45c78793          	addi	a5,a5,1116 # 80005d00 <kernelvec>
    800028ac:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028b0:	fffff097          	auipc	ra,0xfffff
    800028b4:	1a8080e7          	jalr	424(ra) # 80001a58 <myproc>
    800028b8:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    800028ba:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028bc:	14102773          	csrr	a4,sepc
    800028c0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028c2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028c6:	47a1                	li	a5,8
    800028c8:	04f71d63          	bne	a4,a5,80002922 <usertrap+0x96>
    if(p->killed)
    800028cc:	5d1c                	lw	a5,56(a0)
    800028ce:	e7a1                	bnez	a5,80002916 <usertrap+0x8a>
    p->tf->epc += 4;
    800028d0:	70b8                	ld	a4,96(s1)
    800028d2:	6f1c                	ld	a5,24(a4)
    800028d4:	0791                	addi	a5,a5,4
    800028d6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028e0:	10079073          	csrw	sstatus,a5
    syscall();
    800028e4:	00000097          	auipc	ra,0x0
    800028e8:	2fe080e7          	jalr	766(ra) # 80002be2 <syscall>
  if(p->killed)
    800028ec:	5c9c                	lw	a5,56(s1)
    800028ee:	e3cd                	bnez	a5,80002990 <usertrap+0x104>
  usertrapret();
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	e22080e7          	jalr	-478(ra) # 80002712 <usertrapret>
}
    800028f8:	70a2                	ld	ra,40(sp)
    800028fa:	7402                	ld	s0,32(sp)
    800028fc:	64e2                	ld	s1,24(sp)
    800028fe:	6942                	ld	s2,16(sp)
    80002900:	69a2                	ld	s3,8(sp)
    80002902:	6145                	addi	sp,sp,48
    80002904:	8082                	ret
    panic("usertrap: not from user mode");
    80002906:	00006517          	auipc	a0,0x6
    8000290a:	c6a50513          	addi	a0,a0,-918 # 80008570 <userret+0x4e0>
    8000290e:	ffffe097          	auipc	ra,0xffffe
    80002912:	c46080e7          	jalr	-954(ra) # 80000554 <panic>
      exit(-1);
    80002916:	557d                	li	a0,-1
    80002918:	fffff097          	auipc	ra,0xfffff
    8000291c:	7b6080e7          	jalr	1974(ra) # 800020ce <exit>
    80002920:	bf45                	j	800028d0 <usertrap+0x44>
  } else if((which_dev = devintr()) != 0){
    80002922:	00000097          	auipc	ra,0x0
    80002926:	ed4080e7          	jalr	-300(ra) # 800027f6 <devintr>
    8000292a:	892a                	mv	s2,a0
    8000292c:	c501                	beqz	a0,80002934 <usertrap+0xa8>
  if(p->killed)
    8000292e:	5c9c                	lw	a5,56(s1)
    80002930:	cba1                	beqz	a5,80002980 <usertrap+0xf4>
    80002932:	a091                	j	80002976 <usertrap+0xea>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002934:	142029f3          	csrr	s3,scause
    80002938:	14202573          	csrr	a0,scause
    printf("usertrap(): unexpected scause %p (%s) pid=%d\n", r_scause(), scause_desc(r_scause()), p->pid);
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	cfc080e7          	jalr	-772(ra) # 80002638 <scause_desc>
    80002944:	862a                	mv	a2,a0
    80002946:	40b4                	lw	a3,64(s1)
    80002948:	85ce                	mv	a1,s3
    8000294a:	00006517          	auipc	a0,0x6
    8000294e:	c4650513          	addi	a0,a0,-954 # 80008590 <userret+0x500>
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	c5c080e7          	jalr	-932(ra) # 800005ae <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000295a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000295e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002962:	00006517          	auipc	a0,0x6
    80002966:	c5e50513          	addi	a0,a0,-930 # 800085c0 <userret+0x530>
    8000296a:	ffffe097          	auipc	ra,0xffffe
    8000296e:	c44080e7          	jalr	-956(ra) # 800005ae <printf>
    p->killed = 1;
    80002972:	4785                	li	a5,1
    80002974:	dc9c                	sw	a5,56(s1)
    exit(-1);
    80002976:	557d                	li	a0,-1
    80002978:	fffff097          	auipc	ra,0xfffff
    8000297c:	756080e7          	jalr	1878(ra) # 800020ce <exit>
  if(which_dev == 2)
    80002980:	4789                	li	a5,2
    80002982:	f6f917e3          	bne	s2,a5,800028f0 <usertrap+0x64>
    yield();
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	856080e7          	jalr	-1962(ra) # 800021dc <yield>
    8000298e:	b78d                	j	800028f0 <usertrap+0x64>
  int which_dev = 0;
    80002990:	4901                	li	s2,0
    80002992:	b7d5                	j	80002976 <usertrap+0xea>

0000000080002994 <kerneltrap>:
{
    80002994:	7179                	addi	sp,sp,-48
    80002996:	f406                	sd	ra,40(sp)
    80002998:	f022                	sd	s0,32(sp)
    8000299a:	ec26                	sd	s1,24(sp)
    8000299c:	e84a                	sd	s2,16(sp)
    8000299e:	e44e                	sd	s3,8(sp)
    800029a0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029a2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029a6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029aa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029ae:	1004f793          	andi	a5,s1,256
    800029b2:	cb85                	beqz	a5,800029e2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029b4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029b8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029ba:	ef85                	bnez	a5,800029f2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029bc:	00000097          	auipc	ra,0x0
    800029c0:	e3a080e7          	jalr	-454(ra) # 800027f6 <devintr>
    800029c4:	cd1d                	beqz	a0,80002a02 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029c6:	4789                	li	a5,2
    800029c8:	08f50063          	beq	a0,a5,80002a48 <kerneltrap+0xb4>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029cc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029d0:	10049073          	csrw	sstatus,s1
}
    800029d4:	70a2                	ld	ra,40(sp)
    800029d6:	7402                	ld	s0,32(sp)
    800029d8:	64e2                	ld	s1,24(sp)
    800029da:	6942                	ld	s2,16(sp)
    800029dc:	69a2                	ld	s3,8(sp)
    800029de:	6145                	addi	sp,sp,48
    800029e0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029e2:	00006517          	auipc	a0,0x6
    800029e6:	bfe50513          	addi	a0,a0,-1026 # 800085e0 <userret+0x550>
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	b6a080e7          	jalr	-1174(ra) # 80000554 <panic>
    panic("kerneltrap: interrupts enabled");
    800029f2:	00006517          	auipc	a0,0x6
    800029f6:	c1650513          	addi	a0,a0,-1002 # 80008608 <userret+0x578>
    800029fa:	ffffe097          	auipc	ra,0xffffe
    800029fe:	b5a080e7          	jalr	-1190(ra) # 80000554 <panic>
    printf("scause %p (%s)\n", scause, scause_desc(scause));
    80002a02:	854e                	mv	a0,s3
    80002a04:	00000097          	auipc	ra,0x0
    80002a08:	c34080e7          	jalr	-972(ra) # 80002638 <scause_desc>
    80002a0c:	862a                	mv	a2,a0
    80002a0e:	85ce                	mv	a1,s3
    80002a10:	00006517          	auipc	a0,0x6
    80002a14:	c1850513          	addi	a0,a0,-1000 # 80008628 <userret+0x598>
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	b96080e7          	jalr	-1130(ra) # 800005ae <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a24:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	c1050513          	addi	a0,a0,-1008 # 80008638 <userret+0x5a8>
    80002a30:	ffffe097          	auipc	ra,0xffffe
    80002a34:	b7e080e7          	jalr	-1154(ra) # 800005ae <printf>
    panic("kerneltrap");
    80002a38:	00006517          	auipc	a0,0x6
    80002a3c:	c1850513          	addi	a0,a0,-1000 # 80008650 <userret+0x5c0>
    80002a40:	ffffe097          	auipc	ra,0xffffe
    80002a44:	b14080e7          	jalr	-1260(ra) # 80000554 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a48:	fffff097          	auipc	ra,0xfffff
    80002a4c:	010080e7          	jalr	16(ra) # 80001a58 <myproc>
    80002a50:	dd35                	beqz	a0,800029cc <kerneltrap+0x38>
    80002a52:	fffff097          	auipc	ra,0xfffff
    80002a56:	006080e7          	jalr	6(ra) # 80001a58 <myproc>
    80002a5a:	5118                	lw	a4,32(a0)
    80002a5c:	478d                	li	a5,3
    80002a5e:	f6f717e3          	bne	a4,a5,800029cc <kerneltrap+0x38>
    yield();
    80002a62:	fffff097          	auipc	ra,0xfffff
    80002a66:	77a080e7          	jalr	1914(ra) # 800021dc <yield>
    80002a6a:	b78d                	j	800029cc <kerneltrap+0x38>

0000000080002a6c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	1000                	addi	s0,sp,32
    80002a76:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a78:	fffff097          	auipc	ra,0xfffff
    80002a7c:	fe0080e7          	jalr	-32(ra) # 80001a58 <myproc>
  switch (n) {
    80002a80:	4795                	li	a5,5
    80002a82:	0497e163          	bltu	a5,s1,80002ac4 <argraw+0x58>
    80002a86:	048a                	slli	s1,s1,0x2
    80002a88:	00006717          	auipc	a4,0x6
    80002a8c:	3c870713          	addi	a4,a4,968 # 80008e50 <nointr_desc.0+0x80>
    80002a90:	94ba                	add	s1,s1,a4
    80002a92:	409c                	lw	a5,0(s1)
    80002a94:	97ba                	add	a5,a5,a4
    80002a96:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002a98:	713c                	ld	a5,96(a0)
    80002a9a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002a9c:	60e2                	ld	ra,24(sp)
    80002a9e:	6442                	ld	s0,16(sp)
    80002aa0:	64a2                	ld	s1,8(sp)
    80002aa2:	6105                	addi	sp,sp,32
    80002aa4:	8082                	ret
    return p->tf->a1;
    80002aa6:	713c                	ld	a5,96(a0)
    80002aa8:	7fa8                	ld	a0,120(a5)
    80002aaa:	bfcd                	j	80002a9c <argraw+0x30>
    return p->tf->a2;
    80002aac:	713c                	ld	a5,96(a0)
    80002aae:	63c8                	ld	a0,128(a5)
    80002ab0:	b7f5                	j	80002a9c <argraw+0x30>
    return p->tf->a3;
    80002ab2:	713c                	ld	a5,96(a0)
    80002ab4:	67c8                	ld	a0,136(a5)
    80002ab6:	b7dd                	j	80002a9c <argraw+0x30>
    return p->tf->a4;
    80002ab8:	713c                	ld	a5,96(a0)
    80002aba:	6bc8                	ld	a0,144(a5)
    80002abc:	b7c5                	j	80002a9c <argraw+0x30>
    return p->tf->a5;
    80002abe:	713c                	ld	a5,96(a0)
    80002ac0:	6fc8                	ld	a0,152(a5)
    80002ac2:	bfe9                	j	80002a9c <argraw+0x30>
  panic("argraw");
    80002ac4:	00006517          	auipc	a0,0x6
    80002ac8:	d9450513          	addi	a0,a0,-620 # 80008858 <userret+0x7c8>
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	a88080e7          	jalr	-1400(ra) # 80000554 <panic>

0000000080002ad4 <fetchaddr>:
{
    80002ad4:	1101                	addi	sp,sp,-32
    80002ad6:	ec06                	sd	ra,24(sp)
    80002ad8:	e822                	sd	s0,16(sp)
    80002ada:	e426                	sd	s1,8(sp)
    80002adc:	e04a                	sd	s2,0(sp)
    80002ade:	1000                	addi	s0,sp,32
    80002ae0:	84aa                	mv	s1,a0
    80002ae2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ae4:	fffff097          	auipc	ra,0xfffff
    80002ae8:	f74080e7          	jalr	-140(ra) # 80001a58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002aec:	693c                	ld	a5,80(a0)
    80002aee:	02f4f863          	bgeu	s1,a5,80002b1e <fetchaddr+0x4a>
    80002af2:	00848713          	addi	a4,s1,8
    80002af6:	02e7e663          	bltu	a5,a4,80002b22 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002afa:	46a1                	li	a3,8
    80002afc:	8626                	mv	a2,s1
    80002afe:	85ca                	mv	a1,s2
    80002b00:	6d28                	ld	a0,88(a0)
    80002b02:	fffff097          	auipc	ra,0xfffff
    80002b06:	cd4080e7          	jalr	-812(ra) # 800017d6 <copyin>
    80002b0a:	00a03533          	snez	a0,a0
    80002b0e:	40a00533          	neg	a0,a0
}
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	64a2                	ld	s1,8(sp)
    80002b18:	6902                	ld	s2,0(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret
    return -1;
    80002b1e:	557d                	li	a0,-1
    80002b20:	bfcd                	j	80002b12 <fetchaddr+0x3e>
    80002b22:	557d                	li	a0,-1
    80002b24:	b7fd                	j	80002b12 <fetchaddr+0x3e>

0000000080002b26 <fetchstr>:
{
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	ec26                	sd	s1,24(sp)
    80002b2e:	e84a                	sd	s2,16(sp)
    80002b30:	e44e                	sd	s3,8(sp)
    80002b32:	1800                	addi	s0,sp,48
    80002b34:	892a                	mv	s2,a0
    80002b36:	84ae                	mv	s1,a1
    80002b38:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b3a:	fffff097          	auipc	ra,0xfffff
    80002b3e:	f1e080e7          	jalr	-226(ra) # 80001a58 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b42:	86ce                	mv	a3,s3
    80002b44:	864a                	mv	a2,s2
    80002b46:	85a6                	mv	a1,s1
    80002b48:	6d28                	ld	a0,88(a0)
    80002b4a:	fffff097          	auipc	ra,0xfffff
    80002b4e:	d1a080e7          	jalr	-742(ra) # 80001864 <copyinstr>
  if(err < 0)
    80002b52:	00054763          	bltz	a0,80002b60 <fetchstr+0x3a>
  return strlen(buf);
    80002b56:	8526                	mv	a0,s1
    80002b58:	ffffe097          	auipc	ra,0xffffe
    80002b5c:	39a080e7          	jalr	922(ra) # 80000ef2 <strlen>
}
    80002b60:	70a2                	ld	ra,40(sp)
    80002b62:	7402                	ld	s0,32(sp)
    80002b64:	64e2                	ld	s1,24(sp)
    80002b66:	6942                	ld	s2,16(sp)
    80002b68:	69a2                	ld	s3,8(sp)
    80002b6a:	6145                	addi	sp,sp,48
    80002b6c:	8082                	ret

0000000080002b6e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b6e:	1101                	addi	sp,sp,-32
    80002b70:	ec06                	sd	ra,24(sp)
    80002b72:	e822                	sd	s0,16(sp)
    80002b74:	e426                	sd	s1,8(sp)
    80002b76:	1000                	addi	s0,sp,32
    80002b78:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b7a:	00000097          	auipc	ra,0x0
    80002b7e:	ef2080e7          	jalr	-270(ra) # 80002a6c <argraw>
    80002b82:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b84:	4501                	li	a0,0
    80002b86:	60e2                	ld	ra,24(sp)
    80002b88:	6442                	ld	s0,16(sp)
    80002b8a:	64a2                	ld	s1,8(sp)
    80002b8c:	6105                	addi	sp,sp,32
    80002b8e:	8082                	ret

0000000080002b90 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	e426                	sd	s1,8(sp)
    80002b98:	1000                	addi	s0,sp,32
    80002b9a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	ed0080e7          	jalr	-304(ra) # 80002a6c <argraw>
    80002ba4:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ba6:	4501                	li	a0,0
    80002ba8:	60e2                	ld	ra,24(sp)
    80002baa:	6442                	ld	s0,16(sp)
    80002bac:	64a2                	ld	s1,8(sp)
    80002bae:	6105                	addi	sp,sp,32
    80002bb0:	8082                	ret

0000000080002bb2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bb2:	1101                	addi	sp,sp,-32
    80002bb4:	ec06                	sd	ra,24(sp)
    80002bb6:	e822                	sd	s0,16(sp)
    80002bb8:	e426                	sd	s1,8(sp)
    80002bba:	e04a                	sd	s2,0(sp)
    80002bbc:	1000                	addi	s0,sp,32
    80002bbe:	84ae                	mv	s1,a1
    80002bc0:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	eaa080e7          	jalr	-342(ra) # 80002a6c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002bca:	864a                	mv	a2,s2
    80002bcc:	85a6                	mv	a1,s1
    80002bce:	00000097          	auipc	ra,0x0
    80002bd2:	f58080e7          	jalr	-168(ra) # 80002b26 <fetchstr>
}
    80002bd6:	60e2                	ld	ra,24(sp)
    80002bd8:	6442                	ld	s0,16(sp)
    80002bda:	64a2                	ld	s1,8(sp)
    80002bdc:	6902                	ld	s2,0(sp)
    80002bde:	6105                	addi	sp,sp,32
    80002be0:	8082                	ret

0000000080002be2 <syscall>:
[SYS_ntas]    sys_ntas,
};

void
syscall(void)
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	e04a                	sd	s2,0(sp)
    80002bec:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bee:	fffff097          	auipc	ra,0xfffff
    80002bf2:	e6a080e7          	jalr	-406(ra) # 80001a58 <myproc>
    80002bf6:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002bf8:	06053903          	ld	s2,96(a0)
    80002bfc:	0a893783          	ld	a5,168(s2)
    80002c00:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c04:	37fd                	addiw	a5,a5,-1
    80002c06:	4755                	li	a4,21
    80002c08:	00f76f63          	bltu	a4,a5,80002c26 <syscall+0x44>
    80002c0c:	00369713          	slli	a4,a3,0x3
    80002c10:	00006797          	auipc	a5,0x6
    80002c14:	25878793          	addi	a5,a5,600 # 80008e68 <syscalls>
    80002c18:	97ba                	add	a5,a5,a4
    80002c1a:	639c                	ld	a5,0(a5)
    80002c1c:	c789                	beqz	a5,80002c26 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002c1e:	9782                	jalr	a5
    80002c20:	06a93823          	sd	a0,112(s2)
    80002c24:	a839                	j	80002c42 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c26:	16048613          	addi	a2,s1,352
    80002c2a:	40ac                	lw	a1,64(s1)
    80002c2c:	00006517          	auipc	a0,0x6
    80002c30:	c3450513          	addi	a0,a0,-972 # 80008860 <userret+0x7d0>
    80002c34:	ffffe097          	auipc	ra,0xffffe
    80002c38:	97a080e7          	jalr	-1670(ra) # 800005ae <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002c3c:	70bc                	ld	a5,96(s1)
    80002c3e:	577d                	li	a4,-1
    80002c40:	fbb8                	sd	a4,112(a5)
  }
}
    80002c42:	60e2                	ld	ra,24(sp)
    80002c44:	6442                	ld	s0,16(sp)
    80002c46:	64a2                	ld	s1,8(sp)
    80002c48:	6902                	ld	s2,0(sp)
    80002c4a:	6105                	addi	sp,sp,32
    80002c4c:	8082                	ret

0000000080002c4e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c4e:	1101                	addi	sp,sp,-32
    80002c50:	ec06                	sd	ra,24(sp)
    80002c52:	e822                	sd	s0,16(sp)
    80002c54:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c56:	fec40593          	addi	a1,s0,-20
    80002c5a:	4501                	li	a0,0
    80002c5c:	00000097          	auipc	ra,0x0
    80002c60:	f12080e7          	jalr	-238(ra) # 80002b6e <argint>
    return -1;
    80002c64:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c66:	00054963          	bltz	a0,80002c78 <sys_exit+0x2a>
  exit(n);
    80002c6a:	fec42503          	lw	a0,-20(s0)
    80002c6e:	fffff097          	auipc	ra,0xfffff
    80002c72:	460080e7          	jalr	1120(ra) # 800020ce <exit>
  return 0;  // not reached
    80002c76:	4781                	li	a5,0
}
    80002c78:	853e                	mv	a0,a5
    80002c7a:	60e2                	ld	ra,24(sp)
    80002c7c:	6442                	ld	s0,16(sp)
    80002c7e:	6105                	addi	sp,sp,32
    80002c80:	8082                	ret

0000000080002c82 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c82:	1141                	addi	sp,sp,-16
    80002c84:	e406                	sd	ra,8(sp)
    80002c86:	e022                	sd	s0,0(sp)
    80002c88:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	dce080e7          	jalr	-562(ra) # 80001a58 <myproc>
}
    80002c92:	4128                	lw	a0,64(a0)
    80002c94:	60a2                	ld	ra,8(sp)
    80002c96:	6402                	ld	s0,0(sp)
    80002c98:	0141                	addi	sp,sp,16
    80002c9a:	8082                	ret

0000000080002c9c <sys_fork>:

uint64
sys_fork(void)
{
    80002c9c:	1141                	addi	sp,sp,-16
    80002c9e:	e406                	sd	ra,8(sp)
    80002ca0:	e022                	sd	s0,0(sp)
    80002ca2:	0800                	addi	s0,sp,16
  return fork();
    80002ca4:	fffff097          	auipc	ra,0xfffff
    80002ca8:	11e080e7          	jalr	286(ra) # 80001dc2 <fork>
}
    80002cac:	60a2                	ld	ra,8(sp)
    80002cae:	6402                	ld	s0,0(sp)
    80002cb0:	0141                	addi	sp,sp,16
    80002cb2:	8082                	ret

0000000080002cb4 <sys_wait>:

uint64
sys_wait(void)
{
    80002cb4:	1101                	addi	sp,sp,-32
    80002cb6:	ec06                	sd	ra,24(sp)
    80002cb8:	e822                	sd	s0,16(sp)
    80002cba:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002cbc:	fe840593          	addi	a1,s0,-24
    80002cc0:	4501                	li	a0,0
    80002cc2:	00000097          	auipc	ra,0x0
    80002cc6:	ece080e7          	jalr	-306(ra) # 80002b90 <argaddr>
    80002cca:	87aa                	mv	a5,a0
    return -1;
    80002ccc:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002cce:	0007c863          	bltz	a5,80002cde <sys_wait+0x2a>
  return wait(p);
    80002cd2:	fe843503          	ld	a0,-24(s0)
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	5c0080e7          	jalr	1472(ra) # 80002296 <wait>
}
    80002cde:	60e2                	ld	ra,24(sp)
    80002ce0:	6442                	ld	s0,16(sp)
    80002ce2:	6105                	addi	sp,sp,32
    80002ce4:	8082                	ret

0000000080002ce6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ce6:	7179                	addi	sp,sp,-48
    80002ce8:	f406                	sd	ra,40(sp)
    80002cea:	f022                	sd	s0,32(sp)
    80002cec:	ec26                	sd	s1,24(sp)
    80002cee:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002cf0:	fdc40593          	addi	a1,s0,-36
    80002cf4:	4501                	li	a0,0
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	e78080e7          	jalr	-392(ra) # 80002b6e <argint>
    return -1;
    80002cfe:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002d00:	00054f63          	bltz	a0,80002d1e <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	d54080e7          	jalr	-684(ra) # 80001a58 <myproc>
    80002d0c:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002d0e:	fdc42503          	lw	a0,-36(s0)
    80002d12:	fffff097          	auipc	ra,0xfffff
    80002d16:	03c080e7          	jalr	60(ra) # 80001d4e <growproc>
    80002d1a:	00054863          	bltz	a0,80002d2a <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002d1e:	8526                	mv	a0,s1
    80002d20:	70a2                	ld	ra,40(sp)
    80002d22:	7402                	ld	s0,32(sp)
    80002d24:	64e2                	ld	s1,24(sp)
    80002d26:	6145                	addi	sp,sp,48
    80002d28:	8082                	ret
    return -1;
    80002d2a:	54fd                	li	s1,-1
    80002d2c:	bfcd                	j	80002d1e <sys_sbrk+0x38>

0000000080002d2e <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d2e:	7139                	addi	sp,sp,-64
    80002d30:	fc06                	sd	ra,56(sp)
    80002d32:	f822                	sd	s0,48(sp)
    80002d34:	f426                	sd	s1,40(sp)
    80002d36:	f04a                	sd	s2,32(sp)
    80002d38:	ec4e                	sd	s3,24(sp)
    80002d3a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d3c:	fcc40593          	addi	a1,s0,-52
    80002d40:	4501                	li	a0,0
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	e2c080e7          	jalr	-468(ra) # 80002b6e <argint>
    return -1;
    80002d4a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d4c:	06054563          	bltz	a0,80002db6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002d50:	00013517          	auipc	a0,0x13
    80002d54:	d7050513          	addi	a0,a0,-656 # 80015ac0 <tickslock>
    80002d58:	ffffe097          	auipc	ra,0xffffe
    80002d5c:	d48080e7          	jalr	-696(ra) # 80000aa0 <acquire>
  ticks0 = ticks;
    80002d60:	00025917          	auipc	s2,0x25
    80002d64:	2e092903          	lw	s2,736(s2) # 80028040 <ticks>
  while(ticks - ticks0 < n){
    80002d68:	fcc42783          	lw	a5,-52(s0)
    80002d6c:	cf85                	beqz	a5,80002da4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d6e:	00013997          	auipc	s3,0x13
    80002d72:	d5298993          	addi	s3,s3,-686 # 80015ac0 <tickslock>
    80002d76:	00025497          	auipc	s1,0x25
    80002d7a:	2ca48493          	addi	s1,s1,714 # 80028040 <ticks>
    if(myproc()->killed){
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	cda080e7          	jalr	-806(ra) # 80001a58 <myproc>
    80002d86:	5d1c                	lw	a5,56(a0)
    80002d88:	ef9d                	bnez	a5,80002dc6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002d8a:	85ce                	mv	a1,s3
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	48a080e7          	jalr	1162(ra) # 80002218 <sleep>
  while(ticks - ticks0 < n){
    80002d96:	409c                	lw	a5,0(s1)
    80002d98:	412787bb          	subw	a5,a5,s2
    80002d9c:	fcc42703          	lw	a4,-52(s0)
    80002da0:	fce7efe3          	bltu	a5,a4,80002d7e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002da4:	00013517          	auipc	a0,0x13
    80002da8:	d1c50513          	addi	a0,a0,-740 # 80015ac0 <tickslock>
    80002dac:	ffffe097          	auipc	ra,0xffffe
    80002db0:	dc4080e7          	jalr	-572(ra) # 80000b70 <release>
  return 0;
    80002db4:	4781                	li	a5,0
}
    80002db6:	853e                	mv	a0,a5
    80002db8:	70e2                	ld	ra,56(sp)
    80002dba:	7442                	ld	s0,48(sp)
    80002dbc:	74a2                	ld	s1,40(sp)
    80002dbe:	7902                	ld	s2,32(sp)
    80002dc0:	69e2                	ld	s3,24(sp)
    80002dc2:	6121                	addi	sp,sp,64
    80002dc4:	8082                	ret
      release(&tickslock);
    80002dc6:	00013517          	auipc	a0,0x13
    80002dca:	cfa50513          	addi	a0,a0,-774 # 80015ac0 <tickslock>
    80002dce:	ffffe097          	auipc	ra,0xffffe
    80002dd2:	da2080e7          	jalr	-606(ra) # 80000b70 <release>
      return -1;
    80002dd6:	57fd                	li	a5,-1
    80002dd8:	bff9                	j	80002db6 <sys_sleep+0x88>

0000000080002dda <sys_kill>:

uint64
sys_kill(void)
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002de2:	fec40593          	addi	a1,s0,-20
    80002de6:	4501                	li	a0,0
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	d86080e7          	jalr	-634(ra) # 80002b6e <argint>
    80002df0:	87aa                	mv	a5,a0
    return -1;
    80002df2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002df4:	0007c863          	bltz	a5,80002e04 <sys_kill+0x2a>
  return kill(pid);
    80002df8:	fec42503          	lw	a0,-20(s0)
    80002dfc:	fffff097          	auipc	ra,0xfffff
    80002e00:	606080e7          	jalr	1542(ra) # 80002402 <kill>
}
    80002e04:	60e2                	ld	ra,24(sp)
    80002e06:	6442                	ld	s0,16(sp)
    80002e08:	6105                	addi	sp,sp,32
    80002e0a:	8082                	ret

0000000080002e0c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e0c:	1101                	addi	sp,sp,-32
    80002e0e:	ec06                	sd	ra,24(sp)
    80002e10:	e822                	sd	s0,16(sp)
    80002e12:	e426                	sd	s1,8(sp)
    80002e14:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e16:	00013517          	auipc	a0,0x13
    80002e1a:	caa50513          	addi	a0,a0,-854 # 80015ac0 <tickslock>
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	c82080e7          	jalr	-894(ra) # 80000aa0 <acquire>
  xticks = ticks;
    80002e26:	00025497          	auipc	s1,0x25
    80002e2a:	21a4a483          	lw	s1,538(s1) # 80028040 <ticks>
  release(&tickslock);
    80002e2e:	00013517          	auipc	a0,0x13
    80002e32:	c9250513          	addi	a0,a0,-878 # 80015ac0 <tickslock>
    80002e36:	ffffe097          	auipc	ra,0xffffe
    80002e3a:	d3a080e7          	jalr	-710(ra) # 80000b70 <release>
  return xticks;
}
    80002e3e:	02049513          	slli	a0,s1,0x20
    80002e42:	9101                	srli	a0,a0,0x20
    80002e44:	60e2                	ld	ra,24(sp)
    80002e46:	6442                	ld	s0,16(sp)
    80002e48:	64a2                	ld	s1,8(sp)
    80002e4a:	6105                	addi	sp,sp,32
    80002e4c:	8082                	ret

0000000080002e4e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e4e:	7179                	addi	sp,sp,-48
    80002e50:	f406                	sd	ra,40(sp)
    80002e52:	f022                	sd	s0,32(sp)
    80002e54:	ec26                	sd	s1,24(sp)
    80002e56:	e84a                	sd	s2,16(sp)
    80002e58:	e44e                	sd	s3,8(sp)
    80002e5a:	e052                	sd	s4,0(sp)
    80002e5c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e5e:	00005597          	auipc	a1,0x5
    80002e62:	45a58593          	addi	a1,a1,1114 # 800082b8 <userret+0x228>
    80002e66:	00013517          	auipc	a0,0x13
    80002e6a:	c7a50513          	addi	a0,a0,-902 # 80015ae0 <bcache>
    80002e6e:	ffffe097          	auipc	ra,0xffffe
    80002e72:	b5e080e7          	jalr	-1186(ra) # 800009cc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e76:	0001b797          	auipc	a5,0x1b
    80002e7a:	c6a78793          	addi	a5,a5,-918 # 8001dae0 <bcache+0x8000>
    80002e7e:	0001b717          	auipc	a4,0x1b
    80002e82:	fc270713          	addi	a4,a4,-62 # 8001de40 <bcache+0x8360>
    80002e86:	3ae7b823          	sd	a4,944(a5)
  bcache.head.next = &bcache.head;
    80002e8a:	3ae7bc23          	sd	a4,952(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e8e:	00013497          	auipc	s1,0x13
    80002e92:	c7248493          	addi	s1,s1,-910 # 80015b00 <bcache+0x20>
    b->next = bcache.head.next;
    80002e96:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e98:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e9a:	00006a17          	auipc	s4,0x6
    80002e9e:	9e6a0a13          	addi	s4,s4,-1562 # 80008880 <userret+0x7f0>
    b->next = bcache.head.next;
    80002ea2:	3b893783          	ld	a5,952(s2)
    80002ea6:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head;
    80002ea8:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    80002eac:	85d2                	mv	a1,s4
    80002eae:	01048513          	addi	a0,s1,16
    80002eb2:	00001097          	auipc	ra,0x1
    80002eb6:	5a4080e7          	jalr	1444(ra) # 80004456 <initsleeplock>
    bcache.head.next->prev = b;
    80002eba:	3b893783          	ld	a5,952(s2)
    80002ebe:	eba4                	sd	s1,80(a5)
    bcache.head.next = b;
    80002ec0:	3a993c23          	sd	s1,952(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ec4:	46048493          	addi	s1,s1,1120
    80002ec8:	fd349de3          	bne	s1,s3,80002ea2 <binit+0x54>
  }
}
    80002ecc:	70a2                	ld	ra,40(sp)
    80002ece:	7402                	ld	s0,32(sp)
    80002ed0:	64e2                	ld	s1,24(sp)
    80002ed2:	6942                	ld	s2,16(sp)
    80002ed4:	69a2                	ld	s3,8(sp)
    80002ed6:	6a02                	ld	s4,0(sp)
    80002ed8:	6145                	addi	sp,sp,48
    80002eda:	8082                	ret

0000000080002edc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002edc:	7179                	addi	sp,sp,-48
    80002ede:	f406                	sd	ra,40(sp)
    80002ee0:	f022                	sd	s0,32(sp)
    80002ee2:	ec26                	sd	s1,24(sp)
    80002ee4:	e84a                	sd	s2,16(sp)
    80002ee6:	e44e                	sd	s3,8(sp)
    80002ee8:	1800                	addi	s0,sp,48
    80002eea:	892a                	mv	s2,a0
    80002eec:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002eee:	00013517          	auipc	a0,0x13
    80002ef2:	bf250513          	addi	a0,a0,-1038 # 80015ae0 <bcache>
    80002ef6:	ffffe097          	auipc	ra,0xffffe
    80002efa:	baa080e7          	jalr	-1110(ra) # 80000aa0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002efe:	0001b497          	auipc	s1,0x1b
    80002f02:	f9a4b483          	ld	s1,-102(s1) # 8001de98 <bcache+0x83b8>
    80002f06:	0001b797          	auipc	a5,0x1b
    80002f0a:	f3a78793          	addi	a5,a5,-198 # 8001de40 <bcache+0x8360>
    80002f0e:	02f48f63          	beq	s1,a5,80002f4c <bread+0x70>
    80002f12:	873e                	mv	a4,a5
    80002f14:	a021                	j	80002f1c <bread+0x40>
    80002f16:	6ca4                	ld	s1,88(s1)
    80002f18:	02e48a63          	beq	s1,a4,80002f4c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f1c:	449c                	lw	a5,8(s1)
    80002f1e:	ff279ce3          	bne	a5,s2,80002f16 <bread+0x3a>
    80002f22:	44dc                	lw	a5,12(s1)
    80002f24:	ff3799e3          	bne	a5,s3,80002f16 <bread+0x3a>
      b->refcnt++;
    80002f28:	44bc                	lw	a5,72(s1)
    80002f2a:	2785                	addiw	a5,a5,1
    80002f2c:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002f2e:	00013517          	auipc	a0,0x13
    80002f32:	bb250513          	addi	a0,a0,-1102 # 80015ae0 <bcache>
    80002f36:	ffffe097          	auipc	ra,0xffffe
    80002f3a:	c3a080e7          	jalr	-966(ra) # 80000b70 <release>
      acquiresleep(&b->lock);
    80002f3e:	01048513          	addi	a0,s1,16
    80002f42:	00001097          	auipc	ra,0x1
    80002f46:	54e080e7          	jalr	1358(ra) # 80004490 <acquiresleep>
      return b;
    80002f4a:	a8b9                	j	80002fa8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f4c:	0001b497          	auipc	s1,0x1b
    80002f50:	f444b483          	ld	s1,-188(s1) # 8001de90 <bcache+0x83b0>
    80002f54:	0001b797          	auipc	a5,0x1b
    80002f58:	eec78793          	addi	a5,a5,-276 # 8001de40 <bcache+0x8360>
    80002f5c:	00f48863          	beq	s1,a5,80002f6c <bread+0x90>
    80002f60:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f62:	44bc                	lw	a5,72(s1)
    80002f64:	cf81                	beqz	a5,80002f7c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f66:	68a4                	ld	s1,80(s1)
    80002f68:	fee49de3          	bne	s1,a4,80002f62 <bread+0x86>
  panic("bget: no buffers");
    80002f6c:	00006517          	auipc	a0,0x6
    80002f70:	91c50513          	addi	a0,a0,-1764 # 80008888 <userret+0x7f8>
    80002f74:	ffffd097          	auipc	ra,0xffffd
    80002f78:	5e0080e7          	jalr	1504(ra) # 80000554 <panic>
      b->dev = dev;
    80002f7c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f80:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f84:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f88:	4785                	li	a5,1
    80002f8a:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002f8c:	00013517          	auipc	a0,0x13
    80002f90:	b5450513          	addi	a0,a0,-1196 # 80015ae0 <bcache>
    80002f94:	ffffe097          	auipc	ra,0xffffe
    80002f98:	bdc080e7          	jalr	-1060(ra) # 80000b70 <release>
      acquiresleep(&b->lock);
    80002f9c:	01048513          	addi	a0,s1,16
    80002fa0:	00001097          	auipc	ra,0x1
    80002fa4:	4f0080e7          	jalr	1264(ra) # 80004490 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002fa8:	409c                	lw	a5,0(s1)
    80002faa:	cb89                	beqz	a5,80002fbc <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fac:	8526                	mv	a0,s1
    80002fae:	70a2                	ld	ra,40(sp)
    80002fb0:	7402                	ld	s0,32(sp)
    80002fb2:	64e2                	ld	s1,24(sp)
    80002fb4:	6942                	ld	s2,16(sp)
    80002fb6:	69a2                	ld	s3,8(sp)
    80002fb8:	6145                	addi	sp,sp,48
    80002fba:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    80002fbc:	4601                	li	a2,0
    80002fbe:	85a6                	mv	a1,s1
    80002fc0:	4488                	lw	a0,8(s1)
    80002fc2:	00003097          	auipc	ra,0x3
    80002fc6:	118080e7          	jalr	280(ra) # 800060da <virtio_disk_rw>
    b->valid = 1;
    80002fca:	4785                	li	a5,1
    80002fcc:	c09c                	sw	a5,0(s1)
  return b;
    80002fce:	bff9                	j	80002fac <bread+0xd0>

0000000080002fd0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fd0:	1101                	addi	sp,sp,-32
    80002fd2:	ec06                	sd	ra,24(sp)
    80002fd4:	e822                	sd	s0,16(sp)
    80002fd6:	e426                	sd	s1,8(sp)
    80002fd8:	1000                	addi	s0,sp,32
    80002fda:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fdc:	0541                	addi	a0,a0,16
    80002fde:	00001097          	auipc	ra,0x1
    80002fe2:	54c080e7          	jalr	1356(ra) # 8000452a <holdingsleep>
    80002fe6:	cd09                	beqz	a0,80003000 <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    80002fe8:	4605                	li	a2,1
    80002fea:	85a6                	mv	a1,s1
    80002fec:	4488                	lw	a0,8(s1)
    80002fee:	00003097          	auipc	ra,0x3
    80002ff2:	0ec080e7          	jalr	236(ra) # 800060da <virtio_disk_rw>
}
    80002ff6:	60e2                	ld	ra,24(sp)
    80002ff8:	6442                	ld	s0,16(sp)
    80002ffa:	64a2                	ld	s1,8(sp)
    80002ffc:	6105                	addi	sp,sp,32
    80002ffe:	8082                	ret
    panic("bwrite");
    80003000:	00006517          	auipc	a0,0x6
    80003004:	8a050513          	addi	a0,a0,-1888 # 800088a0 <userret+0x810>
    80003008:	ffffd097          	auipc	ra,0xffffd
    8000300c:	54c080e7          	jalr	1356(ra) # 80000554 <panic>

0000000080003010 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80003010:	1101                	addi	sp,sp,-32
    80003012:	ec06                	sd	ra,24(sp)
    80003014:	e822                	sd	s0,16(sp)
    80003016:	e426                	sd	s1,8(sp)
    80003018:	e04a                	sd	s2,0(sp)
    8000301a:	1000                	addi	s0,sp,32
    8000301c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000301e:	01050913          	addi	s2,a0,16
    80003022:	854a                	mv	a0,s2
    80003024:	00001097          	auipc	ra,0x1
    80003028:	506080e7          	jalr	1286(ra) # 8000452a <holdingsleep>
    8000302c:	c92d                	beqz	a0,8000309e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000302e:	854a                	mv	a0,s2
    80003030:	00001097          	auipc	ra,0x1
    80003034:	4b6080e7          	jalr	1206(ra) # 800044e6 <releasesleep>

  acquire(&bcache.lock);
    80003038:	00013517          	auipc	a0,0x13
    8000303c:	aa850513          	addi	a0,a0,-1368 # 80015ae0 <bcache>
    80003040:	ffffe097          	auipc	ra,0xffffe
    80003044:	a60080e7          	jalr	-1440(ra) # 80000aa0 <acquire>
  b->refcnt--;
    80003048:	44bc                	lw	a5,72(s1)
    8000304a:	37fd                	addiw	a5,a5,-1
    8000304c:	0007871b          	sext.w	a4,a5
    80003050:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    80003052:	eb05                	bnez	a4,80003082 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003054:	6cbc                	ld	a5,88(s1)
    80003056:	68b8                	ld	a4,80(s1)
    80003058:	ebb8                	sd	a4,80(a5)
    b->prev->next = b->next;
    8000305a:	68bc                	ld	a5,80(s1)
    8000305c:	6cb8                	ld	a4,88(s1)
    8000305e:	efb8                	sd	a4,88(a5)
    b->next = bcache.head.next;
    80003060:	0001b797          	auipc	a5,0x1b
    80003064:	a8078793          	addi	a5,a5,-1408 # 8001dae0 <bcache+0x8000>
    80003068:	3b87b703          	ld	a4,952(a5)
    8000306c:	ecb8                	sd	a4,88(s1)
    b->prev = &bcache.head;
    8000306e:	0001b717          	auipc	a4,0x1b
    80003072:	dd270713          	addi	a4,a4,-558 # 8001de40 <bcache+0x8360>
    80003076:	e8b8                	sd	a4,80(s1)
    bcache.head.next->prev = b;
    80003078:	3b87b703          	ld	a4,952(a5)
    8000307c:	eb24                	sd	s1,80(a4)
    bcache.head.next = b;
    8000307e:	3a97bc23          	sd	s1,952(a5)
  }
  
  release(&bcache.lock);
    80003082:	00013517          	auipc	a0,0x13
    80003086:	a5e50513          	addi	a0,a0,-1442 # 80015ae0 <bcache>
    8000308a:	ffffe097          	auipc	ra,0xffffe
    8000308e:	ae6080e7          	jalr	-1306(ra) # 80000b70 <release>
}
    80003092:	60e2                	ld	ra,24(sp)
    80003094:	6442                	ld	s0,16(sp)
    80003096:	64a2                	ld	s1,8(sp)
    80003098:	6902                	ld	s2,0(sp)
    8000309a:	6105                	addi	sp,sp,32
    8000309c:	8082                	ret
    panic("brelse");
    8000309e:	00006517          	auipc	a0,0x6
    800030a2:	80a50513          	addi	a0,a0,-2038 # 800088a8 <userret+0x818>
    800030a6:	ffffd097          	auipc	ra,0xffffd
    800030aa:	4ae080e7          	jalr	1198(ra) # 80000554 <panic>

00000000800030ae <bpin>:

void
bpin(struct buf *b) {
    800030ae:	1101                	addi	sp,sp,-32
    800030b0:	ec06                	sd	ra,24(sp)
    800030b2:	e822                	sd	s0,16(sp)
    800030b4:	e426                	sd	s1,8(sp)
    800030b6:	1000                	addi	s0,sp,32
    800030b8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030ba:	00013517          	auipc	a0,0x13
    800030be:	a2650513          	addi	a0,a0,-1498 # 80015ae0 <bcache>
    800030c2:	ffffe097          	auipc	ra,0xffffe
    800030c6:	9de080e7          	jalr	-1570(ra) # 80000aa0 <acquire>
  b->refcnt++;
    800030ca:	44bc                	lw	a5,72(s1)
    800030cc:	2785                	addiw	a5,a5,1
    800030ce:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    800030d0:	00013517          	auipc	a0,0x13
    800030d4:	a1050513          	addi	a0,a0,-1520 # 80015ae0 <bcache>
    800030d8:	ffffe097          	auipc	ra,0xffffe
    800030dc:	a98080e7          	jalr	-1384(ra) # 80000b70 <release>
}
    800030e0:	60e2                	ld	ra,24(sp)
    800030e2:	6442                	ld	s0,16(sp)
    800030e4:	64a2                	ld	s1,8(sp)
    800030e6:	6105                	addi	sp,sp,32
    800030e8:	8082                	ret

00000000800030ea <bunpin>:

void
bunpin(struct buf *b) {
    800030ea:	1101                	addi	sp,sp,-32
    800030ec:	ec06                	sd	ra,24(sp)
    800030ee:	e822                	sd	s0,16(sp)
    800030f0:	e426                	sd	s1,8(sp)
    800030f2:	1000                	addi	s0,sp,32
    800030f4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030f6:	00013517          	auipc	a0,0x13
    800030fa:	9ea50513          	addi	a0,a0,-1558 # 80015ae0 <bcache>
    800030fe:	ffffe097          	auipc	ra,0xffffe
    80003102:	9a2080e7          	jalr	-1630(ra) # 80000aa0 <acquire>
  b->refcnt--;
    80003106:	44bc                	lw	a5,72(s1)
    80003108:	37fd                	addiw	a5,a5,-1
    8000310a:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    8000310c:	00013517          	auipc	a0,0x13
    80003110:	9d450513          	addi	a0,a0,-1580 # 80015ae0 <bcache>
    80003114:	ffffe097          	auipc	ra,0xffffe
    80003118:	a5c080e7          	jalr	-1444(ra) # 80000b70 <release>
}
    8000311c:	60e2                	ld	ra,24(sp)
    8000311e:	6442                	ld	s0,16(sp)
    80003120:	64a2                	ld	s1,8(sp)
    80003122:	6105                	addi	sp,sp,32
    80003124:	8082                	ret

0000000080003126 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003126:	1101                	addi	sp,sp,-32
    80003128:	ec06                	sd	ra,24(sp)
    8000312a:	e822                	sd	s0,16(sp)
    8000312c:	e426                	sd	s1,8(sp)
    8000312e:	e04a                	sd	s2,0(sp)
    80003130:	1000                	addi	s0,sp,32
    80003132:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003134:	00d5d59b          	srliw	a1,a1,0xd
    80003138:	0001b797          	auipc	a5,0x1b
    8000313c:	1847a783          	lw	a5,388(a5) # 8001e2bc <sb+0x1c>
    80003140:	9dbd                	addw	a1,a1,a5
    80003142:	00000097          	auipc	ra,0x0
    80003146:	d9a080e7          	jalr	-614(ra) # 80002edc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000314a:	0074f713          	andi	a4,s1,7
    8000314e:	4785                	li	a5,1
    80003150:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003154:	14ce                	slli	s1,s1,0x33
    80003156:	90d9                	srli	s1,s1,0x36
    80003158:	00950733          	add	a4,a0,s1
    8000315c:	06074703          	lbu	a4,96(a4)
    80003160:	00e7f6b3          	and	a3,a5,a4
    80003164:	c69d                	beqz	a3,80003192 <bfree+0x6c>
    80003166:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003168:	94aa                	add	s1,s1,a0
    8000316a:	fff7c793          	not	a5,a5
    8000316e:	8ff9                	and	a5,a5,a4
    80003170:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80003174:	00001097          	auipc	ra,0x1
    80003178:	1a2080e7          	jalr	418(ra) # 80004316 <log_write>
  brelse(bp);
    8000317c:	854a                	mv	a0,s2
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	e92080e7          	jalr	-366(ra) # 80003010 <brelse>
}
    80003186:	60e2                	ld	ra,24(sp)
    80003188:	6442                	ld	s0,16(sp)
    8000318a:	64a2                	ld	s1,8(sp)
    8000318c:	6902                	ld	s2,0(sp)
    8000318e:	6105                	addi	sp,sp,32
    80003190:	8082                	ret
    panic("freeing free block");
    80003192:	00005517          	auipc	a0,0x5
    80003196:	71e50513          	addi	a0,a0,1822 # 800088b0 <userret+0x820>
    8000319a:	ffffd097          	auipc	ra,0xffffd
    8000319e:	3ba080e7          	jalr	954(ra) # 80000554 <panic>

00000000800031a2 <balloc>:
{
    800031a2:	711d                	addi	sp,sp,-96
    800031a4:	ec86                	sd	ra,88(sp)
    800031a6:	e8a2                	sd	s0,80(sp)
    800031a8:	e4a6                	sd	s1,72(sp)
    800031aa:	e0ca                	sd	s2,64(sp)
    800031ac:	fc4e                	sd	s3,56(sp)
    800031ae:	f852                	sd	s4,48(sp)
    800031b0:	f456                	sd	s5,40(sp)
    800031b2:	f05a                	sd	s6,32(sp)
    800031b4:	ec5e                	sd	s7,24(sp)
    800031b6:	e862                	sd	s8,16(sp)
    800031b8:	e466                	sd	s9,8(sp)
    800031ba:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800031bc:	0001b797          	auipc	a5,0x1b
    800031c0:	0e87a783          	lw	a5,232(a5) # 8001e2a4 <sb+0x4>
    800031c4:	cbd1                	beqz	a5,80003258 <balloc+0xb6>
    800031c6:	8baa                	mv	s7,a0
    800031c8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031ca:	0001bb17          	auipc	s6,0x1b
    800031ce:	0d6b0b13          	addi	s6,s6,214 # 8001e2a0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031d4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031d8:	6c89                	lui	s9,0x2
    800031da:	a831                	j	800031f6 <balloc+0x54>
    brelse(bp);
    800031dc:	854a                	mv	a0,s2
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	e32080e7          	jalr	-462(ra) # 80003010 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031e6:	015c87bb          	addw	a5,s9,s5
    800031ea:	00078a9b          	sext.w	s5,a5
    800031ee:	004b2703          	lw	a4,4(s6)
    800031f2:	06eaf363          	bgeu	s5,a4,80003258 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800031f6:	41fad79b          	sraiw	a5,s5,0x1f
    800031fa:	0137d79b          	srliw	a5,a5,0x13
    800031fe:	015787bb          	addw	a5,a5,s5
    80003202:	40d7d79b          	sraiw	a5,a5,0xd
    80003206:	01cb2583          	lw	a1,28(s6)
    8000320a:	9dbd                	addw	a1,a1,a5
    8000320c:	855e                	mv	a0,s7
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	cce080e7          	jalr	-818(ra) # 80002edc <bread>
    80003216:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003218:	004b2503          	lw	a0,4(s6)
    8000321c:	000a849b          	sext.w	s1,s5
    80003220:	8662                	mv	a2,s8
    80003222:	faa4fde3          	bgeu	s1,a0,800031dc <balloc+0x3a>
      m = 1 << (bi % 8);
    80003226:	41f6579b          	sraiw	a5,a2,0x1f
    8000322a:	01d7d69b          	srliw	a3,a5,0x1d
    8000322e:	00c6873b          	addw	a4,a3,a2
    80003232:	00777793          	andi	a5,a4,7
    80003236:	9f95                	subw	a5,a5,a3
    80003238:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000323c:	4037571b          	sraiw	a4,a4,0x3
    80003240:	00e906b3          	add	a3,s2,a4
    80003244:	0606c683          	lbu	a3,96(a3)
    80003248:	00d7f5b3          	and	a1,a5,a3
    8000324c:	cd91                	beqz	a1,80003268 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000324e:	2605                	addiw	a2,a2,1
    80003250:	2485                	addiw	s1,s1,1
    80003252:	fd4618e3          	bne	a2,s4,80003222 <balloc+0x80>
    80003256:	b759                	j	800031dc <balloc+0x3a>
  panic("balloc: out of blocks");
    80003258:	00005517          	auipc	a0,0x5
    8000325c:	67050513          	addi	a0,a0,1648 # 800088c8 <userret+0x838>
    80003260:	ffffd097          	auipc	ra,0xffffd
    80003264:	2f4080e7          	jalr	756(ra) # 80000554 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003268:	974a                	add	a4,a4,s2
    8000326a:	8fd5                	or	a5,a5,a3
    8000326c:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80003270:	854a                	mv	a0,s2
    80003272:	00001097          	auipc	ra,0x1
    80003276:	0a4080e7          	jalr	164(ra) # 80004316 <log_write>
        brelse(bp);
    8000327a:	854a                	mv	a0,s2
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	d94080e7          	jalr	-620(ra) # 80003010 <brelse>
  bp = bread(dev, bno);
    80003284:	85a6                	mv	a1,s1
    80003286:	855e                	mv	a0,s7
    80003288:	00000097          	auipc	ra,0x0
    8000328c:	c54080e7          	jalr	-940(ra) # 80002edc <bread>
    80003290:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003292:	40000613          	li	a2,1024
    80003296:	4581                	li	a1,0
    80003298:	06050513          	addi	a0,a0,96
    8000329c:	ffffe097          	auipc	ra,0xffffe
    800032a0:	ad2080e7          	jalr	-1326(ra) # 80000d6e <memset>
  log_write(bp);
    800032a4:	854a                	mv	a0,s2
    800032a6:	00001097          	auipc	ra,0x1
    800032aa:	070080e7          	jalr	112(ra) # 80004316 <log_write>
  brelse(bp);
    800032ae:	854a                	mv	a0,s2
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	d60080e7          	jalr	-672(ra) # 80003010 <brelse>
}
    800032b8:	8526                	mv	a0,s1
    800032ba:	60e6                	ld	ra,88(sp)
    800032bc:	6446                	ld	s0,80(sp)
    800032be:	64a6                	ld	s1,72(sp)
    800032c0:	6906                	ld	s2,64(sp)
    800032c2:	79e2                	ld	s3,56(sp)
    800032c4:	7a42                	ld	s4,48(sp)
    800032c6:	7aa2                	ld	s5,40(sp)
    800032c8:	7b02                	ld	s6,32(sp)
    800032ca:	6be2                	ld	s7,24(sp)
    800032cc:	6c42                	ld	s8,16(sp)
    800032ce:	6ca2                	ld	s9,8(sp)
    800032d0:	6125                	addi	sp,sp,96
    800032d2:	8082                	ret

00000000800032d4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800032d4:	7179                	addi	sp,sp,-48
    800032d6:	f406                	sd	ra,40(sp)
    800032d8:	f022                	sd	s0,32(sp)
    800032da:	ec26                	sd	s1,24(sp)
    800032dc:	e84a                	sd	s2,16(sp)
    800032de:	e44e                	sd	s3,8(sp)
    800032e0:	e052                	sd	s4,0(sp)
    800032e2:	1800                	addi	s0,sp,48
    800032e4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800032e6:	47ad                	li	a5,11
    800032e8:	04b7fe63          	bgeu	a5,a1,80003344 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800032ec:	ff45849b          	addiw	s1,a1,-12
    800032f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800032f4:	0ff00793          	li	a5,255
    800032f8:	0ae7e463          	bltu	a5,a4,800033a0 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800032fc:	08852583          	lw	a1,136(a0)
    80003300:	c5b5                	beqz	a1,8000336c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003302:	00092503          	lw	a0,0(s2)
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	bd6080e7          	jalr	-1066(ra) # 80002edc <bread>
    8000330e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003310:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80003314:	02049713          	slli	a4,s1,0x20
    80003318:	01e75593          	srli	a1,a4,0x1e
    8000331c:	00b784b3          	add	s1,a5,a1
    80003320:	0004a983          	lw	s3,0(s1)
    80003324:	04098e63          	beqz	s3,80003380 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003328:	8552                	mv	a0,s4
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	ce6080e7          	jalr	-794(ra) # 80003010 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003332:	854e                	mv	a0,s3
    80003334:	70a2                	ld	ra,40(sp)
    80003336:	7402                	ld	s0,32(sp)
    80003338:	64e2                	ld	s1,24(sp)
    8000333a:	6942                	ld	s2,16(sp)
    8000333c:	69a2                	ld	s3,8(sp)
    8000333e:	6a02                	ld	s4,0(sp)
    80003340:	6145                	addi	sp,sp,48
    80003342:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003344:	02059793          	slli	a5,a1,0x20
    80003348:	01e7d593          	srli	a1,a5,0x1e
    8000334c:	00b504b3          	add	s1,a0,a1
    80003350:	0584a983          	lw	s3,88(s1)
    80003354:	fc099fe3          	bnez	s3,80003332 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003358:	4108                	lw	a0,0(a0)
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	e48080e7          	jalr	-440(ra) # 800031a2 <balloc>
    80003362:	0005099b          	sext.w	s3,a0
    80003366:	0534ac23          	sw	s3,88(s1)
    8000336a:	b7e1                	j	80003332 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000336c:	4108                	lw	a0,0(a0)
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	e34080e7          	jalr	-460(ra) # 800031a2 <balloc>
    80003376:	0005059b          	sext.w	a1,a0
    8000337a:	08b92423          	sw	a1,136(s2)
    8000337e:	b751                	j	80003302 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003380:	00092503          	lw	a0,0(s2)
    80003384:	00000097          	auipc	ra,0x0
    80003388:	e1e080e7          	jalr	-482(ra) # 800031a2 <balloc>
    8000338c:	0005099b          	sext.w	s3,a0
    80003390:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003394:	8552                	mv	a0,s4
    80003396:	00001097          	auipc	ra,0x1
    8000339a:	f80080e7          	jalr	-128(ra) # 80004316 <log_write>
    8000339e:	b769                	j	80003328 <bmap+0x54>
  panic("bmap: out of range");
    800033a0:	00005517          	auipc	a0,0x5
    800033a4:	54050513          	addi	a0,a0,1344 # 800088e0 <userret+0x850>
    800033a8:	ffffd097          	auipc	ra,0xffffd
    800033ac:	1ac080e7          	jalr	428(ra) # 80000554 <panic>

00000000800033b0 <iget>:
{
    800033b0:	7179                	addi	sp,sp,-48
    800033b2:	f406                	sd	ra,40(sp)
    800033b4:	f022                	sd	s0,32(sp)
    800033b6:	ec26                	sd	s1,24(sp)
    800033b8:	e84a                	sd	s2,16(sp)
    800033ba:	e44e                	sd	s3,8(sp)
    800033bc:	e052                	sd	s4,0(sp)
    800033be:	1800                	addi	s0,sp,48
    800033c0:	89aa                	mv	s3,a0
    800033c2:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800033c4:	0001b517          	auipc	a0,0x1b
    800033c8:	efc50513          	addi	a0,a0,-260 # 8001e2c0 <icache>
    800033cc:	ffffd097          	auipc	ra,0xffffd
    800033d0:	6d4080e7          	jalr	1748(ra) # 80000aa0 <acquire>
  empty = 0;
    800033d4:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033d6:	0001b497          	auipc	s1,0x1b
    800033da:	f0a48493          	addi	s1,s1,-246 # 8001e2e0 <icache+0x20>
    800033de:	0001d697          	auipc	a3,0x1d
    800033e2:	b2268693          	addi	a3,a3,-1246 # 8001ff00 <log>
    800033e6:	a039                	j	800033f4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033e8:	02090b63          	beqz	s2,8000341e <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033ec:	09048493          	addi	s1,s1,144
    800033f0:	02d48a63          	beq	s1,a3,80003424 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033f4:	449c                	lw	a5,8(s1)
    800033f6:	fef059e3          	blez	a5,800033e8 <iget+0x38>
    800033fa:	4098                	lw	a4,0(s1)
    800033fc:	ff3716e3          	bne	a4,s3,800033e8 <iget+0x38>
    80003400:	40d8                	lw	a4,4(s1)
    80003402:	ff4713e3          	bne	a4,s4,800033e8 <iget+0x38>
      ip->ref++;
    80003406:	2785                	addiw	a5,a5,1
    80003408:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000340a:	0001b517          	auipc	a0,0x1b
    8000340e:	eb650513          	addi	a0,a0,-330 # 8001e2c0 <icache>
    80003412:	ffffd097          	auipc	ra,0xffffd
    80003416:	75e080e7          	jalr	1886(ra) # 80000b70 <release>
      return ip;
    8000341a:	8926                	mv	s2,s1
    8000341c:	a03d                	j	8000344a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000341e:	f7f9                	bnez	a5,800033ec <iget+0x3c>
    80003420:	8926                	mv	s2,s1
    80003422:	b7e9                	j	800033ec <iget+0x3c>
  if(empty == 0)
    80003424:	02090c63          	beqz	s2,8000345c <iget+0xac>
  ip->dev = dev;
    80003428:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000342c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003430:	4785                	li	a5,1
    80003432:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003436:	04092423          	sw	zero,72(s2)
  release(&icache.lock);
    8000343a:	0001b517          	auipc	a0,0x1b
    8000343e:	e8650513          	addi	a0,a0,-378 # 8001e2c0 <icache>
    80003442:	ffffd097          	auipc	ra,0xffffd
    80003446:	72e080e7          	jalr	1838(ra) # 80000b70 <release>
}
    8000344a:	854a                	mv	a0,s2
    8000344c:	70a2                	ld	ra,40(sp)
    8000344e:	7402                	ld	s0,32(sp)
    80003450:	64e2                	ld	s1,24(sp)
    80003452:	6942                	ld	s2,16(sp)
    80003454:	69a2                	ld	s3,8(sp)
    80003456:	6a02                	ld	s4,0(sp)
    80003458:	6145                	addi	sp,sp,48
    8000345a:	8082                	ret
    panic("iget: no inodes");
    8000345c:	00005517          	auipc	a0,0x5
    80003460:	49c50513          	addi	a0,a0,1180 # 800088f8 <userret+0x868>
    80003464:	ffffd097          	auipc	ra,0xffffd
    80003468:	0f0080e7          	jalr	240(ra) # 80000554 <panic>

000000008000346c <fsinit>:
fsinit(int dev) {
    8000346c:	7179                	addi	sp,sp,-48
    8000346e:	f406                	sd	ra,40(sp)
    80003470:	f022                	sd	s0,32(sp)
    80003472:	ec26                	sd	s1,24(sp)
    80003474:	e84a                	sd	s2,16(sp)
    80003476:	e44e                	sd	s3,8(sp)
    80003478:	1800                	addi	s0,sp,48
    8000347a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000347c:	4585                	li	a1,1
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	a5e080e7          	jalr	-1442(ra) # 80002edc <bread>
    80003486:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003488:	0001b997          	auipc	s3,0x1b
    8000348c:	e1898993          	addi	s3,s3,-488 # 8001e2a0 <sb>
    80003490:	02000613          	li	a2,32
    80003494:	06050593          	addi	a1,a0,96
    80003498:	854e                	mv	a0,s3
    8000349a:	ffffe097          	auipc	ra,0xffffe
    8000349e:	930080e7          	jalr	-1744(ra) # 80000dca <memmove>
  brelse(bp);
    800034a2:	8526                	mv	a0,s1
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	b6c080e7          	jalr	-1172(ra) # 80003010 <brelse>
  if(sb.magic != FSMAGIC)
    800034ac:	0009a703          	lw	a4,0(s3)
    800034b0:	102037b7          	lui	a5,0x10203
    800034b4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034b8:	02f71263          	bne	a4,a5,800034dc <fsinit+0x70>
  initlog(dev, &sb);
    800034bc:	0001b597          	auipc	a1,0x1b
    800034c0:	de458593          	addi	a1,a1,-540 # 8001e2a0 <sb>
    800034c4:	854a                	mv	a0,s2
    800034c6:	00001097          	auipc	ra,0x1
    800034ca:	b38080e7          	jalr	-1224(ra) # 80003ffe <initlog>
}
    800034ce:	70a2                	ld	ra,40(sp)
    800034d0:	7402                	ld	s0,32(sp)
    800034d2:	64e2                	ld	s1,24(sp)
    800034d4:	6942                	ld	s2,16(sp)
    800034d6:	69a2                	ld	s3,8(sp)
    800034d8:	6145                	addi	sp,sp,48
    800034da:	8082                	ret
    panic("invalid file system");
    800034dc:	00005517          	auipc	a0,0x5
    800034e0:	42c50513          	addi	a0,a0,1068 # 80008908 <userret+0x878>
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	070080e7          	jalr	112(ra) # 80000554 <panic>

00000000800034ec <iinit>:
{
    800034ec:	7179                	addi	sp,sp,-48
    800034ee:	f406                	sd	ra,40(sp)
    800034f0:	f022                	sd	s0,32(sp)
    800034f2:	ec26                	sd	s1,24(sp)
    800034f4:	e84a                	sd	s2,16(sp)
    800034f6:	e44e                	sd	s3,8(sp)
    800034f8:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800034fa:	00005597          	auipc	a1,0x5
    800034fe:	42658593          	addi	a1,a1,1062 # 80008920 <userret+0x890>
    80003502:	0001b517          	auipc	a0,0x1b
    80003506:	dbe50513          	addi	a0,a0,-578 # 8001e2c0 <icache>
    8000350a:	ffffd097          	auipc	ra,0xffffd
    8000350e:	4c2080e7          	jalr	1218(ra) # 800009cc <initlock>
  for(i = 0; i < NINODE; i++) {
    80003512:	0001b497          	auipc	s1,0x1b
    80003516:	dde48493          	addi	s1,s1,-546 # 8001e2f0 <icache+0x30>
    8000351a:	0001d997          	auipc	s3,0x1d
    8000351e:	9f698993          	addi	s3,s3,-1546 # 8001ff10 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003522:	00005917          	auipc	s2,0x5
    80003526:	40690913          	addi	s2,s2,1030 # 80008928 <userret+0x898>
    8000352a:	85ca                	mv	a1,s2
    8000352c:	8526                	mv	a0,s1
    8000352e:	00001097          	auipc	ra,0x1
    80003532:	f28080e7          	jalr	-216(ra) # 80004456 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003536:	09048493          	addi	s1,s1,144
    8000353a:	ff3498e3          	bne	s1,s3,8000352a <iinit+0x3e>
}
    8000353e:	70a2                	ld	ra,40(sp)
    80003540:	7402                	ld	s0,32(sp)
    80003542:	64e2                	ld	s1,24(sp)
    80003544:	6942                	ld	s2,16(sp)
    80003546:	69a2                	ld	s3,8(sp)
    80003548:	6145                	addi	sp,sp,48
    8000354a:	8082                	ret

000000008000354c <ialloc>:
{
    8000354c:	715d                	addi	sp,sp,-80
    8000354e:	e486                	sd	ra,72(sp)
    80003550:	e0a2                	sd	s0,64(sp)
    80003552:	fc26                	sd	s1,56(sp)
    80003554:	f84a                	sd	s2,48(sp)
    80003556:	f44e                	sd	s3,40(sp)
    80003558:	f052                	sd	s4,32(sp)
    8000355a:	ec56                	sd	s5,24(sp)
    8000355c:	e85a                	sd	s6,16(sp)
    8000355e:	e45e                	sd	s7,8(sp)
    80003560:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003562:	0001b717          	auipc	a4,0x1b
    80003566:	d4a72703          	lw	a4,-694(a4) # 8001e2ac <sb+0xc>
    8000356a:	4785                	li	a5,1
    8000356c:	04e7fa63          	bgeu	a5,a4,800035c0 <ialloc+0x74>
    80003570:	8aaa                	mv	s5,a0
    80003572:	8bae                	mv	s7,a1
    80003574:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003576:	0001ba17          	auipc	s4,0x1b
    8000357a:	d2aa0a13          	addi	s4,s4,-726 # 8001e2a0 <sb>
    8000357e:	00048b1b          	sext.w	s6,s1
    80003582:	0044d793          	srli	a5,s1,0x4
    80003586:	018a2583          	lw	a1,24(s4)
    8000358a:	9dbd                	addw	a1,a1,a5
    8000358c:	8556                	mv	a0,s5
    8000358e:	00000097          	auipc	ra,0x0
    80003592:	94e080e7          	jalr	-1714(ra) # 80002edc <bread>
    80003596:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003598:	06050993          	addi	s3,a0,96
    8000359c:	00f4f793          	andi	a5,s1,15
    800035a0:	079a                	slli	a5,a5,0x6
    800035a2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035a4:	00099783          	lh	a5,0(s3)
    800035a8:	c785                	beqz	a5,800035d0 <ialloc+0x84>
    brelse(bp);
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	a66080e7          	jalr	-1434(ra) # 80003010 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035b2:	0485                	addi	s1,s1,1
    800035b4:	00ca2703          	lw	a4,12(s4)
    800035b8:	0004879b          	sext.w	a5,s1
    800035bc:	fce7e1e3          	bltu	a5,a4,8000357e <ialloc+0x32>
  panic("ialloc: no inodes");
    800035c0:	00005517          	auipc	a0,0x5
    800035c4:	37050513          	addi	a0,a0,880 # 80008930 <userret+0x8a0>
    800035c8:	ffffd097          	auipc	ra,0xffffd
    800035cc:	f8c080e7          	jalr	-116(ra) # 80000554 <panic>
      memset(dip, 0, sizeof(*dip));
    800035d0:	04000613          	li	a2,64
    800035d4:	4581                	li	a1,0
    800035d6:	854e                	mv	a0,s3
    800035d8:	ffffd097          	auipc	ra,0xffffd
    800035dc:	796080e7          	jalr	1942(ra) # 80000d6e <memset>
      dip->type = type;
    800035e0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800035e4:	854a                	mv	a0,s2
    800035e6:	00001097          	auipc	ra,0x1
    800035ea:	d30080e7          	jalr	-720(ra) # 80004316 <log_write>
      brelse(bp);
    800035ee:	854a                	mv	a0,s2
    800035f0:	00000097          	auipc	ra,0x0
    800035f4:	a20080e7          	jalr	-1504(ra) # 80003010 <brelse>
      return iget(dev, inum);
    800035f8:	85da                	mv	a1,s6
    800035fa:	8556                	mv	a0,s5
    800035fc:	00000097          	auipc	ra,0x0
    80003600:	db4080e7          	jalr	-588(ra) # 800033b0 <iget>
}
    80003604:	60a6                	ld	ra,72(sp)
    80003606:	6406                	ld	s0,64(sp)
    80003608:	74e2                	ld	s1,56(sp)
    8000360a:	7942                	ld	s2,48(sp)
    8000360c:	79a2                	ld	s3,40(sp)
    8000360e:	7a02                	ld	s4,32(sp)
    80003610:	6ae2                	ld	s5,24(sp)
    80003612:	6b42                	ld	s6,16(sp)
    80003614:	6ba2                	ld	s7,8(sp)
    80003616:	6161                	addi	sp,sp,80
    80003618:	8082                	ret

000000008000361a <iupdate>:
{
    8000361a:	1101                	addi	sp,sp,-32
    8000361c:	ec06                	sd	ra,24(sp)
    8000361e:	e822                	sd	s0,16(sp)
    80003620:	e426                	sd	s1,8(sp)
    80003622:	e04a                	sd	s2,0(sp)
    80003624:	1000                	addi	s0,sp,32
    80003626:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003628:	415c                	lw	a5,4(a0)
    8000362a:	0047d79b          	srliw	a5,a5,0x4
    8000362e:	0001b597          	auipc	a1,0x1b
    80003632:	c8a5a583          	lw	a1,-886(a1) # 8001e2b8 <sb+0x18>
    80003636:	9dbd                	addw	a1,a1,a5
    80003638:	4108                	lw	a0,0(a0)
    8000363a:	00000097          	auipc	ra,0x0
    8000363e:	8a2080e7          	jalr	-1886(ra) # 80002edc <bread>
    80003642:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003644:	06050793          	addi	a5,a0,96
    80003648:	40c8                	lw	a0,4(s1)
    8000364a:	893d                	andi	a0,a0,15
    8000364c:	051a                	slli	a0,a0,0x6
    8000364e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003650:	04c49703          	lh	a4,76(s1)
    80003654:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003658:	04e49703          	lh	a4,78(s1)
    8000365c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003660:	05049703          	lh	a4,80(s1)
    80003664:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003668:	05249703          	lh	a4,82(s1)
    8000366c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003670:	48f8                	lw	a4,84(s1)
    80003672:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003674:	03400613          	li	a2,52
    80003678:	05848593          	addi	a1,s1,88
    8000367c:	0531                	addi	a0,a0,12
    8000367e:	ffffd097          	auipc	ra,0xffffd
    80003682:	74c080e7          	jalr	1868(ra) # 80000dca <memmove>
  log_write(bp);
    80003686:	854a                	mv	a0,s2
    80003688:	00001097          	auipc	ra,0x1
    8000368c:	c8e080e7          	jalr	-882(ra) # 80004316 <log_write>
  brelse(bp);
    80003690:	854a                	mv	a0,s2
    80003692:	00000097          	auipc	ra,0x0
    80003696:	97e080e7          	jalr	-1666(ra) # 80003010 <brelse>
}
    8000369a:	60e2                	ld	ra,24(sp)
    8000369c:	6442                	ld	s0,16(sp)
    8000369e:	64a2                	ld	s1,8(sp)
    800036a0:	6902                	ld	s2,0(sp)
    800036a2:	6105                	addi	sp,sp,32
    800036a4:	8082                	ret

00000000800036a6 <idup>:
{
    800036a6:	1101                	addi	sp,sp,-32
    800036a8:	ec06                	sd	ra,24(sp)
    800036aa:	e822                	sd	s0,16(sp)
    800036ac:	e426                	sd	s1,8(sp)
    800036ae:	1000                	addi	s0,sp,32
    800036b0:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800036b2:	0001b517          	auipc	a0,0x1b
    800036b6:	c0e50513          	addi	a0,a0,-1010 # 8001e2c0 <icache>
    800036ba:	ffffd097          	auipc	ra,0xffffd
    800036be:	3e6080e7          	jalr	998(ra) # 80000aa0 <acquire>
  ip->ref++;
    800036c2:	449c                	lw	a5,8(s1)
    800036c4:	2785                	addiw	a5,a5,1
    800036c6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800036c8:	0001b517          	auipc	a0,0x1b
    800036cc:	bf850513          	addi	a0,a0,-1032 # 8001e2c0 <icache>
    800036d0:	ffffd097          	auipc	ra,0xffffd
    800036d4:	4a0080e7          	jalr	1184(ra) # 80000b70 <release>
}
    800036d8:	8526                	mv	a0,s1
    800036da:	60e2                	ld	ra,24(sp)
    800036dc:	6442                	ld	s0,16(sp)
    800036de:	64a2                	ld	s1,8(sp)
    800036e0:	6105                	addi	sp,sp,32
    800036e2:	8082                	ret

00000000800036e4 <ilock>:
{
    800036e4:	1101                	addi	sp,sp,-32
    800036e6:	ec06                	sd	ra,24(sp)
    800036e8:	e822                	sd	s0,16(sp)
    800036ea:	e426                	sd	s1,8(sp)
    800036ec:	e04a                	sd	s2,0(sp)
    800036ee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036f0:	c115                	beqz	a0,80003714 <ilock+0x30>
    800036f2:	84aa                	mv	s1,a0
    800036f4:	451c                	lw	a5,8(a0)
    800036f6:	00f05f63          	blez	a5,80003714 <ilock+0x30>
  acquiresleep(&ip->lock);
    800036fa:	0541                	addi	a0,a0,16
    800036fc:	00001097          	auipc	ra,0x1
    80003700:	d94080e7          	jalr	-620(ra) # 80004490 <acquiresleep>
  if(ip->valid == 0){
    80003704:	44bc                	lw	a5,72(s1)
    80003706:	cf99                	beqz	a5,80003724 <ilock+0x40>
}
    80003708:	60e2                	ld	ra,24(sp)
    8000370a:	6442                	ld	s0,16(sp)
    8000370c:	64a2                	ld	s1,8(sp)
    8000370e:	6902                	ld	s2,0(sp)
    80003710:	6105                	addi	sp,sp,32
    80003712:	8082                	ret
    panic("ilock");
    80003714:	00005517          	auipc	a0,0x5
    80003718:	23450513          	addi	a0,a0,564 # 80008948 <userret+0x8b8>
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	e38080e7          	jalr	-456(ra) # 80000554 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003724:	40dc                	lw	a5,4(s1)
    80003726:	0047d79b          	srliw	a5,a5,0x4
    8000372a:	0001b597          	auipc	a1,0x1b
    8000372e:	b8e5a583          	lw	a1,-1138(a1) # 8001e2b8 <sb+0x18>
    80003732:	9dbd                	addw	a1,a1,a5
    80003734:	4088                	lw	a0,0(s1)
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	7a6080e7          	jalr	1958(ra) # 80002edc <bread>
    8000373e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003740:	06050593          	addi	a1,a0,96
    80003744:	40dc                	lw	a5,4(s1)
    80003746:	8bbd                	andi	a5,a5,15
    80003748:	079a                	slli	a5,a5,0x6
    8000374a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000374c:	00059783          	lh	a5,0(a1)
    80003750:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80003754:	00259783          	lh	a5,2(a1)
    80003758:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    8000375c:	00459783          	lh	a5,4(a1)
    80003760:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80003764:	00659783          	lh	a5,6(a1)
    80003768:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    8000376c:	459c                	lw	a5,8(a1)
    8000376e:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003770:	03400613          	li	a2,52
    80003774:	05b1                	addi	a1,a1,12
    80003776:	05848513          	addi	a0,s1,88
    8000377a:	ffffd097          	auipc	ra,0xffffd
    8000377e:	650080e7          	jalr	1616(ra) # 80000dca <memmove>
    brelse(bp);
    80003782:	854a                	mv	a0,s2
    80003784:	00000097          	auipc	ra,0x0
    80003788:	88c080e7          	jalr	-1908(ra) # 80003010 <brelse>
    ip->valid = 1;
    8000378c:	4785                	li	a5,1
    8000378e:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80003790:	04c49783          	lh	a5,76(s1)
    80003794:	fbb5                	bnez	a5,80003708 <ilock+0x24>
      panic("ilock: no type");
    80003796:	00005517          	auipc	a0,0x5
    8000379a:	1ba50513          	addi	a0,a0,442 # 80008950 <userret+0x8c0>
    8000379e:	ffffd097          	auipc	ra,0xffffd
    800037a2:	db6080e7          	jalr	-586(ra) # 80000554 <panic>

00000000800037a6 <iunlock>:
{
    800037a6:	1101                	addi	sp,sp,-32
    800037a8:	ec06                	sd	ra,24(sp)
    800037aa:	e822                	sd	s0,16(sp)
    800037ac:	e426                	sd	s1,8(sp)
    800037ae:	e04a                	sd	s2,0(sp)
    800037b0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037b2:	c905                	beqz	a0,800037e2 <iunlock+0x3c>
    800037b4:	84aa                	mv	s1,a0
    800037b6:	01050913          	addi	s2,a0,16
    800037ba:	854a                	mv	a0,s2
    800037bc:	00001097          	auipc	ra,0x1
    800037c0:	d6e080e7          	jalr	-658(ra) # 8000452a <holdingsleep>
    800037c4:	cd19                	beqz	a0,800037e2 <iunlock+0x3c>
    800037c6:	449c                	lw	a5,8(s1)
    800037c8:	00f05d63          	blez	a5,800037e2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037cc:	854a                	mv	a0,s2
    800037ce:	00001097          	auipc	ra,0x1
    800037d2:	d18080e7          	jalr	-744(ra) # 800044e6 <releasesleep>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6902                	ld	s2,0(sp)
    800037de:	6105                	addi	sp,sp,32
    800037e0:	8082                	ret
    panic("iunlock");
    800037e2:	00005517          	auipc	a0,0x5
    800037e6:	17e50513          	addi	a0,a0,382 # 80008960 <userret+0x8d0>
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	d6a080e7          	jalr	-662(ra) # 80000554 <panic>

00000000800037f2 <iput>:
{
    800037f2:	7139                	addi	sp,sp,-64
    800037f4:	fc06                	sd	ra,56(sp)
    800037f6:	f822                	sd	s0,48(sp)
    800037f8:	f426                	sd	s1,40(sp)
    800037fa:	f04a                	sd	s2,32(sp)
    800037fc:	ec4e                	sd	s3,24(sp)
    800037fe:	e852                	sd	s4,16(sp)
    80003800:	e456                	sd	s5,8(sp)
    80003802:	0080                	addi	s0,sp,64
    80003804:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003806:	0001b517          	auipc	a0,0x1b
    8000380a:	aba50513          	addi	a0,a0,-1350 # 8001e2c0 <icache>
    8000380e:	ffffd097          	auipc	ra,0xffffd
    80003812:	292080e7          	jalr	658(ra) # 80000aa0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003816:	4498                	lw	a4,8(s1)
    80003818:	4785                	li	a5,1
    8000381a:	02f70663          	beq	a4,a5,80003846 <iput+0x54>
  ip->ref--;
    8000381e:	449c                	lw	a5,8(s1)
    80003820:	37fd                	addiw	a5,a5,-1
    80003822:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003824:	0001b517          	auipc	a0,0x1b
    80003828:	a9c50513          	addi	a0,a0,-1380 # 8001e2c0 <icache>
    8000382c:	ffffd097          	auipc	ra,0xffffd
    80003830:	344080e7          	jalr	836(ra) # 80000b70 <release>
}
    80003834:	70e2                	ld	ra,56(sp)
    80003836:	7442                	ld	s0,48(sp)
    80003838:	74a2                	ld	s1,40(sp)
    8000383a:	7902                	ld	s2,32(sp)
    8000383c:	69e2                	ld	s3,24(sp)
    8000383e:	6a42                	ld	s4,16(sp)
    80003840:	6aa2                	ld	s5,8(sp)
    80003842:	6121                	addi	sp,sp,64
    80003844:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003846:	44bc                	lw	a5,72(s1)
    80003848:	dbf9                	beqz	a5,8000381e <iput+0x2c>
    8000384a:	05249783          	lh	a5,82(s1)
    8000384e:	fbe1                	bnez	a5,8000381e <iput+0x2c>
    acquiresleep(&ip->lock);
    80003850:	01048a13          	addi	s4,s1,16
    80003854:	8552                	mv	a0,s4
    80003856:	00001097          	auipc	ra,0x1
    8000385a:	c3a080e7          	jalr	-966(ra) # 80004490 <acquiresleep>
    release(&icache.lock);
    8000385e:	0001b517          	auipc	a0,0x1b
    80003862:	a6250513          	addi	a0,a0,-1438 # 8001e2c0 <icache>
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	30a080e7          	jalr	778(ra) # 80000b70 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000386e:	05848913          	addi	s2,s1,88
    80003872:	08848993          	addi	s3,s1,136
    80003876:	a021                	j	8000387e <iput+0x8c>
    80003878:	0911                	addi	s2,s2,4
    8000387a:	01390d63          	beq	s2,s3,80003894 <iput+0xa2>
    if(ip->addrs[i]){
    8000387e:	00092583          	lw	a1,0(s2)
    80003882:	d9fd                	beqz	a1,80003878 <iput+0x86>
      bfree(ip->dev, ip->addrs[i]);
    80003884:	4088                	lw	a0,0(s1)
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	8a0080e7          	jalr	-1888(ra) # 80003126 <bfree>
      ip->addrs[i] = 0;
    8000388e:	00092023          	sw	zero,0(s2)
    80003892:	b7dd                	j	80003878 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003894:	0884a583          	lw	a1,136(s1)
    80003898:	ed9d                	bnez	a1,800038d6 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000389a:	0404aa23          	sw	zero,84(s1)
  iupdate(ip);
    8000389e:	8526                	mv	a0,s1
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	d7a080e7          	jalr	-646(ra) # 8000361a <iupdate>
    ip->type = 0;
    800038a8:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    800038ac:	8526                	mv	a0,s1
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	d6c080e7          	jalr	-660(ra) # 8000361a <iupdate>
    ip->valid = 0;
    800038b6:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    800038ba:	8552                	mv	a0,s4
    800038bc:	00001097          	auipc	ra,0x1
    800038c0:	c2a080e7          	jalr	-982(ra) # 800044e6 <releasesleep>
    acquire(&icache.lock);
    800038c4:	0001b517          	auipc	a0,0x1b
    800038c8:	9fc50513          	addi	a0,a0,-1540 # 8001e2c0 <icache>
    800038cc:	ffffd097          	auipc	ra,0xffffd
    800038d0:	1d4080e7          	jalr	468(ra) # 80000aa0 <acquire>
    800038d4:	b7a9                	j	8000381e <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038d6:	4088                	lw	a0,0(s1)
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	604080e7          	jalr	1540(ra) # 80002edc <bread>
    800038e0:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    800038e2:	06050913          	addi	s2,a0,96
    800038e6:	46050993          	addi	s3,a0,1120
    800038ea:	a021                	j	800038f2 <iput+0x100>
    800038ec:	0911                	addi	s2,s2,4
    800038ee:	01390b63          	beq	s2,s3,80003904 <iput+0x112>
      if(a[j])
    800038f2:	00092583          	lw	a1,0(s2)
    800038f6:	d9fd                	beqz	a1,800038ec <iput+0xfa>
        bfree(ip->dev, a[j]);
    800038f8:	4088                	lw	a0,0(s1)
    800038fa:	00000097          	auipc	ra,0x0
    800038fe:	82c080e7          	jalr	-2004(ra) # 80003126 <bfree>
    80003902:	b7ed                	j	800038ec <iput+0xfa>
    brelse(bp);
    80003904:	8556                	mv	a0,s5
    80003906:	fffff097          	auipc	ra,0xfffff
    8000390a:	70a080e7          	jalr	1802(ra) # 80003010 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000390e:	0884a583          	lw	a1,136(s1)
    80003912:	4088                	lw	a0,0(s1)
    80003914:	00000097          	auipc	ra,0x0
    80003918:	812080e7          	jalr	-2030(ra) # 80003126 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000391c:	0804a423          	sw	zero,136(s1)
    80003920:	bfad                	j	8000389a <iput+0xa8>

0000000080003922 <iunlockput>:
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	1000                	addi	s0,sp,32
    8000392c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	e78080e7          	jalr	-392(ra) # 800037a6 <iunlock>
  iput(ip);
    80003936:	8526                	mv	a0,s1
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	eba080e7          	jalr	-326(ra) # 800037f2 <iput>
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	64a2                	ld	s1,8(sp)
    80003946:	6105                	addi	sp,sp,32
    80003948:	8082                	ret

000000008000394a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000394a:	1141                	addi	sp,sp,-16
    8000394c:	e422                	sd	s0,8(sp)
    8000394e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003950:	411c                	lw	a5,0(a0)
    80003952:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003954:	415c                	lw	a5,4(a0)
    80003956:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003958:	04c51783          	lh	a5,76(a0)
    8000395c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003960:	05251783          	lh	a5,82(a0)
    80003964:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003968:	05456783          	lwu	a5,84(a0)
    8000396c:	e99c                	sd	a5,16(a1)
}
    8000396e:	6422                	ld	s0,8(sp)
    80003970:	0141                	addi	sp,sp,16
    80003972:	8082                	ret

0000000080003974 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003974:	497c                	lw	a5,84(a0)
    80003976:	0ed7e563          	bltu	a5,a3,80003a60 <readi+0xec>
{
    8000397a:	7159                	addi	sp,sp,-112
    8000397c:	f486                	sd	ra,104(sp)
    8000397e:	f0a2                	sd	s0,96(sp)
    80003980:	eca6                	sd	s1,88(sp)
    80003982:	e8ca                	sd	s2,80(sp)
    80003984:	e4ce                	sd	s3,72(sp)
    80003986:	e0d2                	sd	s4,64(sp)
    80003988:	fc56                	sd	s5,56(sp)
    8000398a:	f85a                	sd	s6,48(sp)
    8000398c:	f45e                	sd	s7,40(sp)
    8000398e:	f062                	sd	s8,32(sp)
    80003990:	ec66                	sd	s9,24(sp)
    80003992:	e86a                	sd	s10,16(sp)
    80003994:	e46e                	sd	s11,8(sp)
    80003996:	1880                	addi	s0,sp,112
    80003998:	8baa                	mv	s7,a0
    8000399a:	8c2e                	mv	s8,a1
    8000399c:	8ab2                	mv	s5,a2
    8000399e:	8936                	mv	s2,a3
    800039a0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039a2:	9f35                	addw	a4,a4,a3
    800039a4:	0cd76063          	bltu	a4,a3,80003a64 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    800039a8:	00e7f463          	bgeu	a5,a4,800039b0 <readi+0x3c>
    n = ip->size - off;
    800039ac:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039b0:	080b0763          	beqz	s6,80003a3e <readi+0xca>
    800039b4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039b6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039ba:	5cfd                	li	s9,-1
    800039bc:	a82d                	j	800039f6 <readi+0x82>
    800039be:	02099d93          	slli	s11,s3,0x20
    800039c2:	020ddd93          	srli	s11,s11,0x20
    800039c6:	06048793          	addi	a5,s1,96
    800039ca:	86ee                	mv	a3,s11
    800039cc:	963e                	add	a2,a2,a5
    800039ce:	85d6                	mv	a1,s5
    800039d0:	8562                	mv	a0,s8
    800039d2:	fffff097          	auipc	ra,0xfffff
    800039d6:	aa0080e7          	jalr	-1376(ra) # 80002472 <either_copyout>
    800039da:	05950d63          	beq	a0,s9,80003a34 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    800039de:	8526                	mv	a0,s1
    800039e0:	fffff097          	auipc	ra,0xfffff
    800039e4:	630080e7          	jalr	1584(ra) # 80003010 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039e8:	01498a3b          	addw	s4,s3,s4
    800039ec:	0129893b          	addw	s2,s3,s2
    800039f0:	9aee                	add	s5,s5,s11
    800039f2:	056a7663          	bgeu	s4,s6,80003a3e <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800039f6:	000ba483          	lw	s1,0(s7)
    800039fa:	00a9559b          	srliw	a1,s2,0xa
    800039fe:	855e                	mv	a0,s7
    80003a00:	00000097          	auipc	ra,0x0
    80003a04:	8d4080e7          	jalr	-1836(ra) # 800032d4 <bmap>
    80003a08:	0005059b          	sext.w	a1,a0
    80003a0c:	8526                	mv	a0,s1
    80003a0e:	fffff097          	auipc	ra,0xfffff
    80003a12:	4ce080e7          	jalr	1230(ra) # 80002edc <bread>
    80003a16:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a18:	3ff97613          	andi	a2,s2,1023
    80003a1c:	40cd07bb          	subw	a5,s10,a2
    80003a20:	414b073b          	subw	a4,s6,s4
    80003a24:	89be                	mv	s3,a5
    80003a26:	2781                	sext.w	a5,a5
    80003a28:	0007069b          	sext.w	a3,a4
    80003a2c:	f8f6f9e3          	bgeu	a3,a5,800039be <readi+0x4a>
    80003a30:	89ba                	mv	s3,a4
    80003a32:	b771                	j	800039be <readi+0x4a>
      brelse(bp);
    80003a34:	8526                	mv	a0,s1
    80003a36:	fffff097          	auipc	ra,0xfffff
    80003a3a:	5da080e7          	jalr	1498(ra) # 80003010 <brelse>
  }
  return n;
    80003a3e:	000b051b          	sext.w	a0,s6
}
    80003a42:	70a6                	ld	ra,104(sp)
    80003a44:	7406                	ld	s0,96(sp)
    80003a46:	64e6                	ld	s1,88(sp)
    80003a48:	6946                	ld	s2,80(sp)
    80003a4a:	69a6                	ld	s3,72(sp)
    80003a4c:	6a06                	ld	s4,64(sp)
    80003a4e:	7ae2                	ld	s5,56(sp)
    80003a50:	7b42                	ld	s6,48(sp)
    80003a52:	7ba2                	ld	s7,40(sp)
    80003a54:	7c02                	ld	s8,32(sp)
    80003a56:	6ce2                	ld	s9,24(sp)
    80003a58:	6d42                	ld	s10,16(sp)
    80003a5a:	6da2                	ld	s11,8(sp)
    80003a5c:	6165                	addi	sp,sp,112
    80003a5e:	8082                	ret
    return -1;
    80003a60:	557d                	li	a0,-1
}
    80003a62:	8082                	ret
    return -1;
    80003a64:	557d                	li	a0,-1
    80003a66:	bff1                	j	80003a42 <readi+0xce>

0000000080003a68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a68:	497c                	lw	a5,84(a0)
    80003a6a:	10d7e663          	bltu	a5,a3,80003b76 <writei+0x10e>
{
    80003a6e:	7159                	addi	sp,sp,-112
    80003a70:	f486                	sd	ra,104(sp)
    80003a72:	f0a2                	sd	s0,96(sp)
    80003a74:	eca6                	sd	s1,88(sp)
    80003a76:	e8ca                	sd	s2,80(sp)
    80003a78:	e4ce                	sd	s3,72(sp)
    80003a7a:	e0d2                	sd	s4,64(sp)
    80003a7c:	fc56                	sd	s5,56(sp)
    80003a7e:	f85a                	sd	s6,48(sp)
    80003a80:	f45e                	sd	s7,40(sp)
    80003a82:	f062                	sd	s8,32(sp)
    80003a84:	ec66                	sd	s9,24(sp)
    80003a86:	e86a                	sd	s10,16(sp)
    80003a88:	e46e                	sd	s11,8(sp)
    80003a8a:	1880                	addi	s0,sp,112
    80003a8c:	8baa                	mv	s7,a0
    80003a8e:	8c2e                	mv	s8,a1
    80003a90:	8ab2                	mv	s5,a2
    80003a92:	8936                	mv	s2,a3
    80003a94:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a96:	00e687bb          	addw	a5,a3,a4
    80003a9a:	0ed7e063          	bltu	a5,a3,80003b7a <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003a9e:	00043737          	lui	a4,0x43
    80003aa2:	0cf76e63          	bltu	a4,a5,80003b7e <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003aa6:	0a0b0763          	beqz	s6,80003b54 <writei+0xec>
    80003aaa:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aac:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003ab0:	5cfd                	li	s9,-1
    80003ab2:	a091                	j	80003af6 <writei+0x8e>
    80003ab4:	02099d93          	slli	s11,s3,0x20
    80003ab8:	020ddd93          	srli	s11,s11,0x20
    80003abc:	06048793          	addi	a5,s1,96
    80003ac0:	86ee                	mv	a3,s11
    80003ac2:	8656                	mv	a2,s5
    80003ac4:	85e2                	mv	a1,s8
    80003ac6:	953e                	add	a0,a0,a5
    80003ac8:	fffff097          	auipc	ra,0xfffff
    80003acc:	a00080e7          	jalr	-1536(ra) # 800024c8 <either_copyin>
    80003ad0:	07950263          	beq	a0,s9,80003b34 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ad4:	8526                	mv	a0,s1
    80003ad6:	00001097          	auipc	ra,0x1
    80003ada:	840080e7          	jalr	-1984(ra) # 80004316 <log_write>
    brelse(bp);
    80003ade:	8526                	mv	a0,s1
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	530080e7          	jalr	1328(ra) # 80003010 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ae8:	01498a3b          	addw	s4,s3,s4
    80003aec:	0129893b          	addw	s2,s3,s2
    80003af0:	9aee                	add	s5,s5,s11
    80003af2:	056a7663          	bgeu	s4,s6,80003b3e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003af6:	000ba483          	lw	s1,0(s7)
    80003afa:	00a9559b          	srliw	a1,s2,0xa
    80003afe:	855e                	mv	a0,s7
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	7d4080e7          	jalr	2004(ra) # 800032d4 <bmap>
    80003b08:	0005059b          	sext.w	a1,a0
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	fffff097          	auipc	ra,0xfffff
    80003b12:	3ce080e7          	jalr	974(ra) # 80002edc <bread>
    80003b16:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b18:	3ff97513          	andi	a0,s2,1023
    80003b1c:	40ad07bb          	subw	a5,s10,a0
    80003b20:	414b073b          	subw	a4,s6,s4
    80003b24:	89be                	mv	s3,a5
    80003b26:	2781                	sext.w	a5,a5
    80003b28:	0007069b          	sext.w	a3,a4
    80003b2c:	f8f6f4e3          	bgeu	a3,a5,80003ab4 <writei+0x4c>
    80003b30:	89ba                	mv	s3,a4
    80003b32:	b749                	j	80003ab4 <writei+0x4c>
      brelse(bp);
    80003b34:	8526                	mv	a0,s1
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	4da080e7          	jalr	1242(ra) # 80003010 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003b3e:	054ba783          	lw	a5,84(s7)
    80003b42:	0127f463          	bgeu	a5,s2,80003b4a <writei+0xe2>
      ip->size = off;
    80003b46:	052baa23          	sw	s2,84(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003b4a:	855e                	mv	a0,s7
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	ace080e7          	jalr	-1330(ra) # 8000361a <iupdate>
  }

  return n;
    80003b54:	000b051b          	sext.w	a0,s6
}
    80003b58:	70a6                	ld	ra,104(sp)
    80003b5a:	7406                	ld	s0,96(sp)
    80003b5c:	64e6                	ld	s1,88(sp)
    80003b5e:	6946                	ld	s2,80(sp)
    80003b60:	69a6                	ld	s3,72(sp)
    80003b62:	6a06                	ld	s4,64(sp)
    80003b64:	7ae2                	ld	s5,56(sp)
    80003b66:	7b42                	ld	s6,48(sp)
    80003b68:	7ba2                	ld	s7,40(sp)
    80003b6a:	7c02                	ld	s8,32(sp)
    80003b6c:	6ce2                	ld	s9,24(sp)
    80003b6e:	6d42                	ld	s10,16(sp)
    80003b70:	6da2                	ld	s11,8(sp)
    80003b72:	6165                	addi	sp,sp,112
    80003b74:	8082                	ret
    return -1;
    80003b76:	557d                	li	a0,-1
}
    80003b78:	8082                	ret
    return -1;
    80003b7a:	557d                	li	a0,-1
    80003b7c:	bff1                	j	80003b58 <writei+0xf0>
    return -1;
    80003b7e:	557d                	li	a0,-1
    80003b80:	bfe1                	j	80003b58 <writei+0xf0>

0000000080003b82 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003b82:	1141                	addi	sp,sp,-16
    80003b84:	e406                	sd	ra,8(sp)
    80003b86:	e022                	sd	s0,0(sp)
    80003b88:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003b8a:	4639                	li	a2,14
    80003b8c:	ffffd097          	auipc	ra,0xffffd
    80003b90:	2ba080e7          	jalr	698(ra) # 80000e46 <strncmp>
}
    80003b94:	60a2                	ld	ra,8(sp)
    80003b96:	6402                	ld	s0,0(sp)
    80003b98:	0141                	addi	sp,sp,16
    80003b9a:	8082                	ret

0000000080003b9c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003b9c:	7139                	addi	sp,sp,-64
    80003b9e:	fc06                	sd	ra,56(sp)
    80003ba0:	f822                	sd	s0,48(sp)
    80003ba2:	f426                	sd	s1,40(sp)
    80003ba4:	f04a                	sd	s2,32(sp)
    80003ba6:	ec4e                	sd	s3,24(sp)
    80003ba8:	e852                	sd	s4,16(sp)
    80003baa:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003bac:	04c51703          	lh	a4,76(a0)
    80003bb0:	4785                	li	a5,1
    80003bb2:	00f71a63          	bne	a4,a5,80003bc6 <dirlookup+0x2a>
    80003bb6:	892a                	mv	s2,a0
    80003bb8:	89ae                	mv	s3,a1
    80003bba:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bbc:	497c                	lw	a5,84(a0)
    80003bbe:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003bc0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bc2:	e79d                	bnez	a5,80003bf0 <dirlookup+0x54>
    80003bc4:	a8a5                	j	80003c3c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003bc6:	00005517          	auipc	a0,0x5
    80003bca:	da250513          	addi	a0,a0,-606 # 80008968 <userret+0x8d8>
    80003bce:	ffffd097          	auipc	ra,0xffffd
    80003bd2:	986080e7          	jalr	-1658(ra) # 80000554 <panic>
      panic("dirlookup read");
    80003bd6:	00005517          	auipc	a0,0x5
    80003bda:	daa50513          	addi	a0,a0,-598 # 80008980 <userret+0x8f0>
    80003bde:	ffffd097          	auipc	ra,0xffffd
    80003be2:	976080e7          	jalr	-1674(ra) # 80000554 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003be6:	24c1                	addiw	s1,s1,16
    80003be8:	05492783          	lw	a5,84(s2)
    80003bec:	04f4f763          	bgeu	s1,a5,80003c3a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bf0:	4741                	li	a4,16
    80003bf2:	86a6                	mv	a3,s1
    80003bf4:	fc040613          	addi	a2,s0,-64
    80003bf8:	4581                	li	a1,0
    80003bfa:	854a                	mv	a0,s2
    80003bfc:	00000097          	auipc	ra,0x0
    80003c00:	d78080e7          	jalr	-648(ra) # 80003974 <readi>
    80003c04:	47c1                	li	a5,16
    80003c06:	fcf518e3          	bne	a0,a5,80003bd6 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c0a:	fc045783          	lhu	a5,-64(s0)
    80003c0e:	dfe1                	beqz	a5,80003be6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c10:	fc240593          	addi	a1,s0,-62
    80003c14:	854e                	mv	a0,s3
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	f6c080e7          	jalr	-148(ra) # 80003b82 <namecmp>
    80003c1e:	f561                	bnez	a0,80003be6 <dirlookup+0x4a>
      if(poff)
    80003c20:	000a0463          	beqz	s4,80003c28 <dirlookup+0x8c>
        *poff = off;
    80003c24:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c28:	fc045583          	lhu	a1,-64(s0)
    80003c2c:	00092503          	lw	a0,0(s2)
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	780080e7          	jalr	1920(ra) # 800033b0 <iget>
    80003c38:	a011                	j	80003c3c <dirlookup+0xa0>
  return 0;
    80003c3a:	4501                	li	a0,0
}
    80003c3c:	70e2                	ld	ra,56(sp)
    80003c3e:	7442                	ld	s0,48(sp)
    80003c40:	74a2                	ld	s1,40(sp)
    80003c42:	7902                	ld	s2,32(sp)
    80003c44:	69e2                	ld	s3,24(sp)
    80003c46:	6a42                	ld	s4,16(sp)
    80003c48:	6121                	addi	sp,sp,64
    80003c4a:	8082                	ret

0000000080003c4c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c4c:	711d                	addi	sp,sp,-96
    80003c4e:	ec86                	sd	ra,88(sp)
    80003c50:	e8a2                	sd	s0,80(sp)
    80003c52:	e4a6                	sd	s1,72(sp)
    80003c54:	e0ca                	sd	s2,64(sp)
    80003c56:	fc4e                	sd	s3,56(sp)
    80003c58:	f852                	sd	s4,48(sp)
    80003c5a:	f456                	sd	s5,40(sp)
    80003c5c:	f05a                	sd	s6,32(sp)
    80003c5e:	ec5e                	sd	s7,24(sp)
    80003c60:	e862                	sd	s8,16(sp)
    80003c62:	e466                	sd	s9,8(sp)
    80003c64:	1080                	addi	s0,sp,96
    80003c66:	84aa                	mv	s1,a0
    80003c68:	8aae                	mv	s5,a1
    80003c6a:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003c6c:	00054703          	lbu	a4,0(a0)
    80003c70:	02f00793          	li	a5,47
    80003c74:	02f70363          	beq	a4,a5,80003c9a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c78:	ffffe097          	auipc	ra,0xffffe
    80003c7c:	de0080e7          	jalr	-544(ra) # 80001a58 <myproc>
    80003c80:	15853503          	ld	a0,344(a0)
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	a22080e7          	jalr	-1502(ra) # 800036a6 <idup>
    80003c8c:	89aa                	mv	s3,a0
  while(*path == '/')
    80003c8e:	02f00913          	li	s2,47
  len = path - s;
    80003c92:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003c94:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003c96:	4b85                	li	s7,1
    80003c98:	a865                	j	80003d50 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003c9a:	4585                	li	a1,1
    80003c9c:	4501                	li	a0,0
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	712080e7          	jalr	1810(ra) # 800033b0 <iget>
    80003ca6:	89aa                	mv	s3,a0
    80003ca8:	b7dd                	j	80003c8e <namex+0x42>
      iunlockput(ip);
    80003caa:	854e                	mv	a0,s3
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	c76080e7          	jalr	-906(ra) # 80003922 <iunlockput>
      return 0;
    80003cb4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003cb6:	854e                	mv	a0,s3
    80003cb8:	60e6                	ld	ra,88(sp)
    80003cba:	6446                	ld	s0,80(sp)
    80003cbc:	64a6                	ld	s1,72(sp)
    80003cbe:	6906                	ld	s2,64(sp)
    80003cc0:	79e2                	ld	s3,56(sp)
    80003cc2:	7a42                	ld	s4,48(sp)
    80003cc4:	7aa2                	ld	s5,40(sp)
    80003cc6:	7b02                	ld	s6,32(sp)
    80003cc8:	6be2                	ld	s7,24(sp)
    80003cca:	6c42                	ld	s8,16(sp)
    80003ccc:	6ca2                	ld	s9,8(sp)
    80003cce:	6125                	addi	sp,sp,96
    80003cd0:	8082                	ret
      iunlock(ip);
    80003cd2:	854e                	mv	a0,s3
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	ad2080e7          	jalr	-1326(ra) # 800037a6 <iunlock>
      return ip;
    80003cdc:	bfe9                	j	80003cb6 <namex+0x6a>
      iunlockput(ip);
    80003cde:	854e                	mv	a0,s3
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	c42080e7          	jalr	-958(ra) # 80003922 <iunlockput>
      return 0;
    80003ce8:	89e6                	mv	s3,s9
    80003cea:	b7f1                	j	80003cb6 <namex+0x6a>
  len = path - s;
    80003cec:	40b48633          	sub	a2,s1,a1
    80003cf0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003cf4:	099c5463          	bge	s8,s9,80003d7c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003cf8:	4639                	li	a2,14
    80003cfa:	8552                	mv	a0,s4
    80003cfc:	ffffd097          	auipc	ra,0xffffd
    80003d00:	0ce080e7          	jalr	206(ra) # 80000dca <memmove>
  while(*path == '/')
    80003d04:	0004c783          	lbu	a5,0(s1)
    80003d08:	01279763          	bne	a5,s2,80003d16 <namex+0xca>
    path++;
    80003d0c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d0e:	0004c783          	lbu	a5,0(s1)
    80003d12:	ff278de3          	beq	a5,s2,80003d0c <namex+0xc0>
    ilock(ip);
    80003d16:	854e                	mv	a0,s3
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	9cc080e7          	jalr	-1588(ra) # 800036e4 <ilock>
    if(ip->type != T_DIR){
    80003d20:	04c99783          	lh	a5,76(s3)
    80003d24:	f97793e3          	bne	a5,s7,80003caa <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d28:	000a8563          	beqz	s5,80003d32 <namex+0xe6>
    80003d2c:	0004c783          	lbu	a5,0(s1)
    80003d30:	d3cd                	beqz	a5,80003cd2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d32:	865a                	mv	a2,s6
    80003d34:	85d2                	mv	a1,s4
    80003d36:	854e                	mv	a0,s3
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	e64080e7          	jalr	-412(ra) # 80003b9c <dirlookup>
    80003d40:	8caa                	mv	s9,a0
    80003d42:	dd51                	beqz	a0,80003cde <namex+0x92>
    iunlockput(ip);
    80003d44:	854e                	mv	a0,s3
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	bdc080e7          	jalr	-1060(ra) # 80003922 <iunlockput>
    ip = next;
    80003d4e:	89e6                	mv	s3,s9
  while(*path == '/')
    80003d50:	0004c783          	lbu	a5,0(s1)
    80003d54:	05279763          	bne	a5,s2,80003da2 <namex+0x156>
    path++;
    80003d58:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d5a:	0004c783          	lbu	a5,0(s1)
    80003d5e:	ff278de3          	beq	a5,s2,80003d58 <namex+0x10c>
  if(*path == 0)
    80003d62:	c79d                	beqz	a5,80003d90 <namex+0x144>
    path++;
    80003d64:	85a6                	mv	a1,s1
  len = path - s;
    80003d66:	8cda                	mv	s9,s6
    80003d68:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003d6a:	01278963          	beq	a5,s2,80003d7c <namex+0x130>
    80003d6e:	dfbd                	beqz	a5,80003cec <namex+0xa0>
    path++;
    80003d70:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003d72:	0004c783          	lbu	a5,0(s1)
    80003d76:	ff279ce3          	bne	a5,s2,80003d6e <namex+0x122>
    80003d7a:	bf8d                	j	80003cec <namex+0xa0>
    memmove(name, s, len);
    80003d7c:	2601                	sext.w	a2,a2
    80003d7e:	8552                	mv	a0,s4
    80003d80:	ffffd097          	auipc	ra,0xffffd
    80003d84:	04a080e7          	jalr	74(ra) # 80000dca <memmove>
    name[len] = 0;
    80003d88:	9cd2                	add	s9,s9,s4
    80003d8a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003d8e:	bf9d                	j	80003d04 <namex+0xb8>
  if(nameiparent){
    80003d90:	f20a83e3          	beqz	s5,80003cb6 <namex+0x6a>
    iput(ip);
    80003d94:	854e                	mv	a0,s3
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	a5c080e7          	jalr	-1444(ra) # 800037f2 <iput>
    return 0;
    80003d9e:	4981                	li	s3,0
    80003da0:	bf19                	j	80003cb6 <namex+0x6a>
  if(*path == 0)
    80003da2:	d7fd                	beqz	a5,80003d90 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003da4:	0004c783          	lbu	a5,0(s1)
    80003da8:	85a6                	mv	a1,s1
    80003daa:	b7d1                	j	80003d6e <namex+0x122>

0000000080003dac <dirlink>:
{
    80003dac:	7139                	addi	sp,sp,-64
    80003dae:	fc06                	sd	ra,56(sp)
    80003db0:	f822                	sd	s0,48(sp)
    80003db2:	f426                	sd	s1,40(sp)
    80003db4:	f04a                	sd	s2,32(sp)
    80003db6:	ec4e                	sd	s3,24(sp)
    80003db8:	e852                	sd	s4,16(sp)
    80003dba:	0080                	addi	s0,sp,64
    80003dbc:	892a                	mv	s2,a0
    80003dbe:	8a2e                	mv	s4,a1
    80003dc0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003dc2:	4601                	li	a2,0
    80003dc4:	00000097          	auipc	ra,0x0
    80003dc8:	dd8080e7          	jalr	-552(ra) # 80003b9c <dirlookup>
    80003dcc:	e93d                	bnez	a0,80003e42 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dce:	05492483          	lw	s1,84(s2)
    80003dd2:	c49d                	beqz	s1,80003e00 <dirlink+0x54>
    80003dd4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dd6:	4741                	li	a4,16
    80003dd8:	86a6                	mv	a3,s1
    80003dda:	fc040613          	addi	a2,s0,-64
    80003dde:	4581                	li	a1,0
    80003de0:	854a                	mv	a0,s2
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	b92080e7          	jalr	-1134(ra) # 80003974 <readi>
    80003dea:	47c1                	li	a5,16
    80003dec:	06f51163          	bne	a0,a5,80003e4e <dirlink+0xa2>
    if(de.inum == 0)
    80003df0:	fc045783          	lhu	a5,-64(s0)
    80003df4:	c791                	beqz	a5,80003e00 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003df6:	24c1                	addiw	s1,s1,16
    80003df8:	05492783          	lw	a5,84(s2)
    80003dfc:	fcf4ede3          	bltu	s1,a5,80003dd6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e00:	4639                	li	a2,14
    80003e02:	85d2                	mv	a1,s4
    80003e04:	fc240513          	addi	a0,s0,-62
    80003e08:	ffffd097          	auipc	ra,0xffffd
    80003e0c:	07a080e7          	jalr	122(ra) # 80000e82 <strncpy>
  de.inum = inum;
    80003e10:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e14:	4741                	li	a4,16
    80003e16:	86a6                	mv	a3,s1
    80003e18:	fc040613          	addi	a2,s0,-64
    80003e1c:	4581                	li	a1,0
    80003e1e:	854a                	mv	a0,s2
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	c48080e7          	jalr	-952(ra) # 80003a68 <writei>
    80003e28:	872a                	mv	a4,a0
    80003e2a:	47c1                	li	a5,16
  return 0;
    80003e2c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e2e:	02f71863          	bne	a4,a5,80003e5e <dirlink+0xb2>
}
    80003e32:	70e2                	ld	ra,56(sp)
    80003e34:	7442                	ld	s0,48(sp)
    80003e36:	74a2                	ld	s1,40(sp)
    80003e38:	7902                	ld	s2,32(sp)
    80003e3a:	69e2                	ld	s3,24(sp)
    80003e3c:	6a42                	ld	s4,16(sp)
    80003e3e:	6121                	addi	sp,sp,64
    80003e40:	8082                	ret
    iput(ip);
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	9b0080e7          	jalr	-1616(ra) # 800037f2 <iput>
    return -1;
    80003e4a:	557d                	li	a0,-1
    80003e4c:	b7dd                	j	80003e32 <dirlink+0x86>
      panic("dirlink read");
    80003e4e:	00005517          	auipc	a0,0x5
    80003e52:	b4250513          	addi	a0,a0,-1214 # 80008990 <userret+0x900>
    80003e56:	ffffc097          	auipc	ra,0xffffc
    80003e5a:	6fe080e7          	jalr	1790(ra) # 80000554 <panic>
    panic("dirlink");
    80003e5e:	00005517          	auipc	a0,0x5
    80003e62:	c5250513          	addi	a0,a0,-942 # 80008ab0 <userret+0xa20>
    80003e66:	ffffc097          	auipc	ra,0xffffc
    80003e6a:	6ee080e7          	jalr	1774(ra) # 80000554 <panic>

0000000080003e6e <namei>:

struct inode*
namei(char *path)
{
    80003e6e:	1101                	addi	sp,sp,-32
    80003e70:	ec06                	sd	ra,24(sp)
    80003e72:	e822                	sd	s0,16(sp)
    80003e74:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003e76:	fe040613          	addi	a2,s0,-32
    80003e7a:	4581                	li	a1,0
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	dd0080e7          	jalr	-560(ra) # 80003c4c <namex>
}
    80003e84:	60e2                	ld	ra,24(sp)
    80003e86:	6442                	ld	s0,16(sp)
    80003e88:	6105                	addi	sp,sp,32
    80003e8a:	8082                	ret

0000000080003e8c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003e8c:	1141                	addi	sp,sp,-16
    80003e8e:	e406                	sd	ra,8(sp)
    80003e90:	e022                	sd	s0,0(sp)
    80003e92:	0800                	addi	s0,sp,16
    80003e94:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003e96:	4585                	li	a1,1
    80003e98:	00000097          	auipc	ra,0x0
    80003e9c:	db4080e7          	jalr	-588(ra) # 80003c4c <namex>
}
    80003ea0:	60a2                	ld	ra,8(sp)
    80003ea2:	6402                	ld	s0,0(sp)
    80003ea4:	0141                	addi	sp,sp,16
    80003ea6:	8082                	ret

0000000080003ea8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80003ea8:	7179                	addi	sp,sp,-48
    80003eaa:	f406                	sd	ra,40(sp)
    80003eac:	f022                	sd	s0,32(sp)
    80003eae:	ec26                	sd	s1,24(sp)
    80003eb0:	e84a                	sd	s2,16(sp)
    80003eb2:	e44e                	sd	s3,8(sp)
    80003eb4:	1800                	addi	s0,sp,48
    80003eb6:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80003eb8:	0b000993          	li	s3,176
    80003ebc:	033507b3          	mul	a5,a0,s3
    80003ec0:	0001c997          	auipc	s3,0x1c
    80003ec4:	04098993          	addi	s3,s3,64 # 8001ff00 <log>
    80003ec8:	99be                	add	s3,s3,a5
    80003eca:	0209a583          	lw	a1,32(s3)
    80003ece:	fffff097          	auipc	ra,0xfffff
    80003ed2:	00e080e7          	jalr	14(ra) # 80002edc <bread>
    80003ed6:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80003ed8:	0349a783          	lw	a5,52(s3)
    80003edc:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003ede:	0349a783          	lw	a5,52(s3)
    80003ee2:	02f05763          	blez	a5,80003f10 <write_head+0x68>
    80003ee6:	0b000793          	li	a5,176
    80003eea:	02f487b3          	mul	a5,s1,a5
    80003eee:	0001c717          	auipc	a4,0x1c
    80003ef2:	04a70713          	addi	a4,a4,74 # 8001ff38 <log+0x38>
    80003ef6:	97ba                	add	a5,a5,a4
    80003ef8:	06450693          	addi	a3,a0,100
    80003efc:	4701                	li	a4,0
    80003efe:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    80003f00:	4390                	lw	a2,0(a5)
    80003f02:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003f04:	2705                	addiw	a4,a4,1
    80003f06:	0791                	addi	a5,a5,4
    80003f08:	0691                	addi	a3,a3,4
    80003f0a:	59d0                	lw	a2,52(a1)
    80003f0c:	fec74ae3          	blt	a4,a2,80003f00 <write_head+0x58>
  }
  bwrite(buf);
    80003f10:	854a                	mv	a0,s2
    80003f12:	fffff097          	auipc	ra,0xfffff
    80003f16:	0be080e7          	jalr	190(ra) # 80002fd0 <bwrite>
  brelse(buf);
    80003f1a:	854a                	mv	a0,s2
    80003f1c:	fffff097          	auipc	ra,0xfffff
    80003f20:	0f4080e7          	jalr	244(ra) # 80003010 <brelse>
}
    80003f24:	70a2                	ld	ra,40(sp)
    80003f26:	7402                	ld	s0,32(sp)
    80003f28:	64e2                	ld	s1,24(sp)
    80003f2a:	6942                	ld	s2,16(sp)
    80003f2c:	69a2                	ld	s3,8(sp)
    80003f2e:	6145                	addi	sp,sp,48
    80003f30:	8082                	ret

0000000080003f32 <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003f32:	0b000793          	li	a5,176
    80003f36:	02f50733          	mul	a4,a0,a5
    80003f3a:	0001c797          	auipc	a5,0x1c
    80003f3e:	fc678793          	addi	a5,a5,-58 # 8001ff00 <log>
    80003f42:	97ba                	add	a5,a5,a4
    80003f44:	5bdc                	lw	a5,52(a5)
    80003f46:	0af05b63          	blez	a5,80003ffc <install_trans+0xca>
{
    80003f4a:	7139                	addi	sp,sp,-64
    80003f4c:	fc06                	sd	ra,56(sp)
    80003f4e:	f822                	sd	s0,48(sp)
    80003f50:	f426                	sd	s1,40(sp)
    80003f52:	f04a                	sd	s2,32(sp)
    80003f54:	ec4e                	sd	s3,24(sp)
    80003f56:	e852                	sd	s4,16(sp)
    80003f58:	e456                	sd	s5,8(sp)
    80003f5a:	e05a                	sd	s6,0(sp)
    80003f5c:	0080                	addi	s0,sp,64
    80003f5e:	0001c797          	auipc	a5,0x1c
    80003f62:	fda78793          	addi	a5,a5,-38 # 8001ff38 <log+0x38>
    80003f66:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003f6a:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80003f6c:	00050b1b          	sext.w	s6,a0
    80003f70:	0001ca97          	auipc	s5,0x1c
    80003f74:	f90a8a93          	addi	s5,s5,-112 # 8001ff00 <log>
    80003f78:	9aba                	add	s5,s5,a4
    80003f7a:	020aa583          	lw	a1,32(s5)
    80003f7e:	013585bb          	addw	a1,a1,s3
    80003f82:	2585                	addiw	a1,a1,1
    80003f84:	855a                	mv	a0,s6
    80003f86:	fffff097          	auipc	ra,0xfffff
    80003f8a:	f56080e7          	jalr	-170(ra) # 80002edc <bread>
    80003f8e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80003f90:	000a2583          	lw	a1,0(s4)
    80003f94:	855a                	mv	a0,s6
    80003f96:	fffff097          	auipc	ra,0xfffff
    80003f9a:	f46080e7          	jalr	-186(ra) # 80002edc <bread>
    80003f9e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fa0:	40000613          	li	a2,1024
    80003fa4:	06090593          	addi	a1,s2,96
    80003fa8:	06050513          	addi	a0,a0,96
    80003fac:	ffffd097          	auipc	ra,0xffffd
    80003fb0:	e1e080e7          	jalr	-482(ra) # 80000dca <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	fffff097          	auipc	ra,0xfffff
    80003fba:	01a080e7          	jalr	26(ra) # 80002fd0 <bwrite>
    bunpin(dbuf);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	fffff097          	auipc	ra,0xfffff
    80003fc4:	12a080e7          	jalr	298(ra) # 800030ea <bunpin>
    brelse(lbuf);
    80003fc8:	854a                	mv	a0,s2
    80003fca:	fffff097          	auipc	ra,0xfffff
    80003fce:	046080e7          	jalr	70(ra) # 80003010 <brelse>
    brelse(dbuf);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	fffff097          	auipc	ra,0xfffff
    80003fd8:	03c080e7          	jalr	60(ra) # 80003010 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003fdc:	2985                	addiw	s3,s3,1
    80003fde:	0a11                	addi	s4,s4,4
    80003fe0:	034aa783          	lw	a5,52(s5)
    80003fe4:	f8f9cbe3          	blt	s3,a5,80003f7a <install_trans+0x48>
}
    80003fe8:	70e2                	ld	ra,56(sp)
    80003fea:	7442                	ld	s0,48(sp)
    80003fec:	74a2                	ld	s1,40(sp)
    80003fee:	7902                	ld	s2,32(sp)
    80003ff0:	69e2                	ld	s3,24(sp)
    80003ff2:	6a42                	ld	s4,16(sp)
    80003ff4:	6aa2                	ld	s5,8(sp)
    80003ff6:	6b02                	ld	s6,0(sp)
    80003ff8:	6121                	addi	sp,sp,64
    80003ffa:	8082                	ret
    80003ffc:	8082                	ret

0000000080003ffe <initlog>:
{
    80003ffe:	7179                	addi	sp,sp,-48
    80004000:	f406                	sd	ra,40(sp)
    80004002:	f022                	sd	s0,32(sp)
    80004004:	ec26                	sd	s1,24(sp)
    80004006:	e84a                	sd	s2,16(sp)
    80004008:	e44e                	sd	s3,8(sp)
    8000400a:	e052                	sd	s4,0(sp)
    8000400c:	1800                	addi	s0,sp,48
    8000400e:	892a                	mv	s2,a0
    80004010:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    80004012:	0b000713          	li	a4,176
    80004016:	02e504b3          	mul	s1,a0,a4
    8000401a:	0001c997          	auipc	s3,0x1c
    8000401e:	ee698993          	addi	s3,s3,-282 # 8001ff00 <log>
    80004022:	99a6                	add	s3,s3,s1
    80004024:	00005597          	auipc	a1,0x5
    80004028:	97c58593          	addi	a1,a1,-1668 # 800089a0 <userret+0x910>
    8000402c:	854e                	mv	a0,s3
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	99e080e7          	jalr	-1634(ra) # 800009cc <initlock>
  log[dev].start = sb->logstart;
    80004036:	014a2583          	lw	a1,20(s4)
    8000403a:	02b9a023          	sw	a1,32(s3)
  log[dev].size = sb->nlog;
    8000403e:	010a2783          	lw	a5,16(s4)
    80004042:	02f9a223          	sw	a5,36(s3)
  log[dev].dev = dev;
    80004046:	0329a823          	sw	s2,48(s3)
  struct buf *buf = bread(dev, log[dev].start);
    8000404a:	854a                	mv	a0,s2
    8000404c:	fffff097          	auipc	ra,0xfffff
    80004050:	e90080e7          	jalr	-368(ra) # 80002edc <bread>
  log[dev].lh.n = lh->n;
    80004054:	5134                	lw	a3,96(a0)
    80004056:	02d9aa23          	sw	a3,52(s3)
  for (i = 0; i < log[dev].lh.n; i++) {
    8000405a:	02d05763          	blez	a3,80004088 <initlog+0x8a>
    8000405e:	06450793          	addi	a5,a0,100
    80004062:	0001c717          	auipc	a4,0x1c
    80004066:	ed670713          	addi	a4,a4,-298 # 8001ff38 <log+0x38>
    8000406a:	9726                	add	a4,a4,s1
    8000406c:	36fd                	addiw	a3,a3,-1
    8000406e:	02069613          	slli	a2,a3,0x20
    80004072:	01e65693          	srli	a3,a2,0x1e
    80004076:	06850613          	addi	a2,a0,104
    8000407a:	96b2                	add	a3,a3,a2
    log[dev].lh.block[i] = lh->block[i];
    8000407c:	4390                	lw	a2,0(a5)
    8000407e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    80004080:	0791                	addi	a5,a5,4
    80004082:	0711                	addi	a4,a4,4
    80004084:	fed79ce3          	bne	a5,a3,8000407c <initlog+0x7e>
  brelse(buf);
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	f88080e7          	jalr	-120(ra) # 80003010 <brelse>

static void
recover_from_log(int dev)
{
  read_head(dev);
  install_trans(dev); // if committed, copy from log to disk
    80004090:	854a                	mv	a0,s2
    80004092:	00000097          	auipc	ra,0x0
    80004096:	ea0080e7          	jalr	-352(ra) # 80003f32 <install_trans>
  log[dev].lh.n = 0;
    8000409a:	0b000793          	li	a5,176
    8000409e:	02f90733          	mul	a4,s2,a5
    800040a2:	0001c797          	auipc	a5,0x1c
    800040a6:	e5e78793          	addi	a5,a5,-418 # 8001ff00 <log>
    800040aa:	97ba                	add	a5,a5,a4
    800040ac:	0207aa23          	sw	zero,52(a5)
  write_head(dev); // clear the log
    800040b0:	854a                	mv	a0,s2
    800040b2:	00000097          	auipc	ra,0x0
    800040b6:	df6080e7          	jalr	-522(ra) # 80003ea8 <write_head>
}
    800040ba:	70a2                	ld	ra,40(sp)
    800040bc:	7402                	ld	s0,32(sp)
    800040be:	64e2                	ld	s1,24(sp)
    800040c0:	6942                	ld	s2,16(sp)
    800040c2:	69a2                	ld	s3,8(sp)
    800040c4:	6a02                	ld	s4,0(sp)
    800040c6:	6145                	addi	sp,sp,48
    800040c8:	8082                	ret

00000000800040ca <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(int dev)
{
    800040ca:	7139                	addi	sp,sp,-64
    800040cc:	fc06                	sd	ra,56(sp)
    800040ce:	f822                	sd	s0,48(sp)
    800040d0:	f426                	sd	s1,40(sp)
    800040d2:	f04a                	sd	s2,32(sp)
    800040d4:	ec4e                	sd	s3,24(sp)
    800040d6:	e852                	sd	s4,16(sp)
    800040d8:	e456                	sd	s5,8(sp)
    800040da:	0080                	addi	s0,sp,64
    800040dc:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    800040de:	0b000913          	li	s2,176
    800040e2:	032507b3          	mul	a5,a0,s2
    800040e6:	0001c917          	auipc	s2,0x1c
    800040ea:	e1a90913          	addi	s2,s2,-486 # 8001ff00 <log>
    800040ee:	993e                	add	s2,s2,a5
    800040f0:	854a                	mv	a0,s2
    800040f2:	ffffd097          	auipc	ra,0xffffd
    800040f6:	9ae080e7          	jalr	-1618(ra) # 80000aa0 <acquire>
  while(1){
    if(log[dev].committing){
    800040fa:	0001c997          	auipc	s3,0x1c
    800040fe:	e0698993          	addi	s3,s3,-506 # 8001ff00 <log>
    80004102:	84ca                	mv	s1,s2
      sleep(&log, &log[dev].lock);
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004104:	4a79                	li	s4,30
    80004106:	a039                	j	80004114 <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    80004108:	85ca                	mv	a1,s2
    8000410a:	854e                	mv	a0,s3
    8000410c:	ffffe097          	auipc	ra,0xffffe
    80004110:	10c080e7          	jalr	268(ra) # 80002218 <sleep>
    if(log[dev].committing){
    80004114:	54dc                	lw	a5,44(s1)
    80004116:	fbed                	bnez	a5,80004108 <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004118:	549c                	lw	a5,40(s1)
    8000411a:	0017871b          	addiw	a4,a5,1
    8000411e:	0007069b          	sext.w	a3,a4
    80004122:	0027179b          	slliw	a5,a4,0x2
    80004126:	9fb9                	addw	a5,a5,a4
    80004128:	0017979b          	slliw	a5,a5,0x1
    8000412c:	58d8                	lw	a4,52(s1)
    8000412e:	9fb9                	addw	a5,a5,a4
    80004130:	00fa5963          	bge	s4,a5,80004142 <begin_op+0x78>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log[dev].lock);
    80004134:	85ca                	mv	a1,s2
    80004136:	854e                	mv	a0,s3
    80004138:	ffffe097          	auipc	ra,0xffffe
    8000413c:	0e0080e7          	jalr	224(ra) # 80002218 <sleep>
    80004140:	bfd1                	j	80004114 <begin_op+0x4a>
    } else {
      log[dev].outstanding += 1;
    80004142:	0b000513          	li	a0,176
    80004146:	02aa8ab3          	mul	s5,s5,a0
    8000414a:	0001c797          	auipc	a5,0x1c
    8000414e:	db678793          	addi	a5,a5,-586 # 8001ff00 <log>
    80004152:	9abe                	add	s5,s5,a5
    80004154:	02daa423          	sw	a3,40(s5)
      release(&log[dev].lock);
    80004158:	854a                	mv	a0,s2
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	a16080e7          	jalr	-1514(ra) # 80000b70 <release>
      break;
    }
  }
}
    80004162:	70e2                	ld	ra,56(sp)
    80004164:	7442                	ld	s0,48(sp)
    80004166:	74a2                	ld	s1,40(sp)
    80004168:	7902                	ld	s2,32(sp)
    8000416a:	69e2                	ld	s3,24(sp)
    8000416c:	6a42                	ld	s4,16(sp)
    8000416e:	6aa2                	ld	s5,8(sp)
    80004170:	6121                	addi	sp,sp,64
    80004172:	8082                	ret

0000000080004174 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(int dev)
{
    80004174:	715d                	addi	sp,sp,-80
    80004176:	e486                	sd	ra,72(sp)
    80004178:	e0a2                	sd	s0,64(sp)
    8000417a:	fc26                	sd	s1,56(sp)
    8000417c:	f84a                	sd	s2,48(sp)
    8000417e:	f44e                	sd	s3,40(sp)
    80004180:	f052                	sd	s4,32(sp)
    80004182:	ec56                	sd	s5,24(sp)
    80004184:	e85a                	sd	s6,16(sp)
    80004186:	e45e                	sd	s7,8(sp)
    80004188:	e062                	sd	s8,0(sp)
    8000418a:	0880                	addi	s0,sp,80
    8000418c:	89aa                	mv	s3,a0
  int do_commit = 0;

  acquire(&log[dev].lock);
    8000418e:	0b000913          	li	s2,176
    80004192:	03250933          	mul	s2,a0,s2
    80004196:	0001c497          	auipc	s1,0x1c
    8000419a:	d6a48493          	addi	s1,s1,-662 # 8001ff00 <log>
    8000419e:	94ca                	add	s1,s1,s2
    800041a0:	8526                	mv	a0,s1
    800041a2:	ffffd097          	auipc	ra,0xffffd
    800041a6:	8fe080e7          	jalr	-1794(ra) # 80000aa0 <acquire>
  log[dev].outstanding -= 1;
    800041aa:	549c                	lw	a5,40(s1)
    800041ac:	37fd                	addiw	a5,a5,-1
    800041ae:	00078a9b          	sext.w	s5,a5
    800041b2:	d49c                	sw	a5,40(s1)
  if(log[dev].committing)
    800041b4:	54dc                	lw	a5,44(s1)
    800041b6:	e3b5                	bnez	a5,8000421a <end_op+0xa6>
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    800041b8:	060a9963          	bnez	s5,8000422a <end_op+0xb6>
    do_commit = 1;
    log[dev].committing = 1;
    800041bc:	0b000a13          	li	s4,176
    800041c0:	034987b3          	mul	a5,s3,s4
    800041c4:	0001ca17          	auipc	s4,0x1c
    800041c8:	d3ca0a13          	addi	s4,s4,-708 # 8001ff00 <log>
    800041cc:	9a3e                	add	s4,s4,a5
    800041ce:	4785                	li	a5,1
    800041d0:	02fa2623          	sw	a5,44(s4)
    // begin_op() may be waiting for log space,
    // and decrementing log[dev].outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log[dev].lock);
    800041d4:	8526                	mv	a0,s1
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	99a080e7          	jalr	-1638(ra) # 80000b70 <release>
}

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    800041de:	034a2783          	lw	a5,52(s4)
    800041e2:	06f04d63          	bgtz	a5,8000425c <end_op+0xe8>
    acquire(&log[dev].lock);
    800041e6:	8526                	mv	a0,s1
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	8b8080e7          	jalr	-1864(ra) # 80000aa0 <acquire>
    log[dev].committing = 0;
    800041f0:	0001c517          	auipc	a0,0x1c
    800041f4:	d1050513          	addi	a0,a0,-752 # 8001ff00 <log>
    800041f8:	0b000793          	li	a5,176
    800041fc:	02f989b3          	mul	s3,s3,a5
    80004200:	99aa                	add	s3,s3,a0
    80004202:	0209a623          	sw	zero,44(s3)
    wakeup(&log);
    80004206:	ffffe097          	auipc	ra,0xffffe
    8000420a:	192080e7          	jalr	402(ra) # 80002398 <wakeup>
    release(&log[dev].lock);
    8000420e:	8526                	mv	a0,s1
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	960080e7          	jalr	-1696(ra) # 80000b70 <release>
}
    80004218:	a035                	j	80004244 <end_op+0xd0>
    panic("log[dev].committing");
    8000421a:	00004517          	auipc	a0,0x4
    8000421e:	78e50513          	addi	a0,a0,1934 # 800089a8 <userret+0x918>
    80004222:	ffffc097          	auipc	ra,0xffffc
    80004226:	332080e7          	jalr	818(ra) # 80000554 <panic>
    wakeup(&log);
    8000422a:	0001c517          	auipc	a0,0x1c
    8000422e:	cd650513          	addi	a0,a0,-810 # 8001ff00 <log>
    80004232:	ffffe097          	auipc	ra,0xffffe
    80004236:	166080e7          	jalr	358(ra) # 80002398 <wakeup>
  release(&log[dev].lock);
    8000423a:	8526                	mv	a0,s1
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	934080e7          	jalr	-1740(ra) # 80000b70 <release>
}
    80004244:	60a6                	ld	ra,72(sp)
    80004246:	6406                	ld	s0,64(sp)
    80004248:	74e2                	ld	s1,56(sp)
    8000424a:	7942                	ld	s2,48(sp)
    8000424c:	79a2                	ld	s3,40(sp)
    8000424e:	7a02                	ld	s4,32(sp)
    80004250:	6ae2                	ld	s5,24(sp)
    80004252:	6b42                	ld	s6,16(sp)
    80004254:	6ba2                	ld	s7,8(sp)
    80004256:	6c02                	ld	s8,0(sp)
    80004258:	6161                	addi	sp,sp,80
    8000425a:	8082                	ret
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    8000425c:	0001c797          	auipc	a5,0x1c
    80004260:	cdc78793          	addi	a5,a5,-804 # 8001ff38 <log+0x38>
    80004264:	993e                	add	s2,s2,a5
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80004266:	00098c1b          	sext.w	s8,s3
    8000426a:	0b000b93          	li	s7,176
    8000426e:	037987b3          	mul	a5,s3,s7
    80004272:	0001cb97          	auipc	s7,0x1c
    80004276:	c8eb8b93          	addi	s7,s7,-882 # 8001ff00 <log>
    8000427a:	9bbe                	add	s7,s7,a5
    8000427c:	020ba583          	lw	a1,32(s7)
    80004280:	015585bb          	addw	a1,a1,s5
    80004284:	2585                	addiw	a1,a1,1
    80004286:	8562                	mv	a0,s8
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	c54080e7          	jalr	-940(ra) # 80002edc <bread>
    80004290:	8a2a                	mv	s4,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    80004292:	00092583          	lw	a1,0(s2)
    80004296:	8562                	mv	a0,s8
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	c44080e7          	jalr	-956(ra) # 80002edc <bread>
    800042a0:	8b2a                	mv	s6,a0
    memmove(to->data, from->data, BSIZE);
    800042a2:	40000613          	li	a2,1024
    800042a6:	06050593          	addi	a1,a0,96
    800042aa:	060a0513          	addi	a0,s4,96
    800042ae:	ffffd097          	auipc	ra,0xffffd
    800042b2:	b1c080e7          	jalr	-1252(ra) # 80000dca <memmove>
    bwrite(to);  // write the log
    800042b6:	8552                	mv	a0,s4
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	d18080e7          	jalr	-744(ra) # 80002fd0 <bwrite>
    brelse(from);
    800042c0:	855a                	mv	a0,s6
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	d4e080e7          	jalr	-690(ra) # 80003010 <brelse>
    brelse(to);
    800042ca:	8552                	mv	a0,s4
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	d44080e7          	jalr	-700(ra) # 80003010 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    800042d4:	2a85                	addiw	s5,s5,1
    800042d6:	0911                	addi	s2,s2,4
    800042d8:	034ba783          	lw	a5,52(s7)
    800042dc:	fafac0e3          	blt	s5,a5,8000427c <end_op+0x108>
    write_log(dev);     // Write modified blocks from cache to log
    write_head(dev);    // Write header to disk -- the real commit
    800042e0:	854e                	mv	a0,s3
    800042e2:	00000097          	auipc	ra,0x0
    800042e6:	bc6080e7          	jalr	-1082(ra) # 80003ea8 <write_head>
    install_trans(dev); // Now install writes to home locations
    800042ea:	854e                	mv	a0,s3
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	c46080e7          	jalr	-954(ra) # 80003f32 <install_trans>
    log[dev].lh.n = 0;
    800042f4:	0b000793          	li	a5,176
    800042f8:	02f98733          	mul	a4,s3,a5
    800042fc:	0001c797          	auipc	a5,0x1c
    80004300:	c0478793          	addi	a5,a5,-1020 # 8001ff00 <log>
    80004304:	97ba                	add	a5,a5,a4
    80004306:	0207aa23          	sw	zero,52(a5)
    write_head(dev);    // Erase the transaction from the log
    8000430a:	854e                	mv	a0,s3
    8000430c:	00000097          	auipc	ra,0x0
    80004310:	b9c080e7          	jalr	-1124(ra) # 80003ea8 <write_head>
    80004314:	bdc9                	j	800041e6 <end_op+0x72>

0000000080004316 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004316:	7179                	addi	sp,sp,-48
    80004318:	f406                	sd	ra,40(sp)
    8000431a:	f022                	sd	s0,32(sp)
    8000431c:	ec26                	sd	s1,24(sp)
    8000431e:	e84a                	sd	s2,16(sp)
    80004320:	e44e                	sd	s3,8(sp)
    80004322:	e052                	sd	s4,0(sp)
    80004324:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    80004326:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    8000432a:	0b000793          	li	a5,176
    8000432e:	02f90733          	mul	a4,s2,a5
    80004332:	0001c797          	auipc	a5,0x1c
    80004336:	bce78793          	addi	a5,a5,-1074 # 8001ff00 <log>
    8000433a:	97ba                	add	a5,a5,a4
    8000433c:	5bd4                	lw	a3,52(a5)
    8000433e:	47f5                	li	a5,29
    80004340:	0ad7cc63          	blt	a5,a3,800043f8 <log_write+0xe2>
    80004344:	89aa                	mv	s3,a0
    80004346:	0001c797          	auipc	a5,0x1c
    8000434a:	bba78793          	addi	a5,a5,-1094 # 8001ff00 <log>
    8000434e:	97ba                	add	a5,a5,a4
    80004350:	53dc                	lw	a5,36(a5)
    80004352:	37fd                	addiw	a5,a5,-1
    80004354:	0af6d263          	bge	a3,a5,800043f8 <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    80004358:	0b000793          	li	a5,176
    8000435c:	02f90733          	mul	a4,s2,a5
    80004360:	0001c797          	auipc	a5,0x1c
    80004364:	ba078793          	addi	a5,a5,-1120 # 8001ff00 <log>
    80004368:	97ba                	add	a5,a5,a4
    8000436a:	579c                	lw	a5,40(a5)
    8000436c:	08f05e63          	blez	a5,80004408 <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    80004370:	0b000793          	li	a5,176
    80004374:	02f904b3          	mul	s1,s2,a5
    80004378:	0001ca17          	auipc	s4,0x1c
    8000437c:	b88a0a13          	addi	s4,s4,-1144 # 8001ff00 <log>
    80004380:	9a26                	add	s4,s4,s1
    80004382:	8552                	mv	a0,s4
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	71c080e7          	jalr	1820(ra) # 80000aa0 <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    8000438c:	034a2603          	lw	a2,52(s4)
    80004390:	08c05463          	blez	a2,80004418 <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    80004394:	00c9a583          	lw	a1,12(s3)
    80004398:	0001c797          	auipc	a5,0x1c
    8000439c:	ba078793          	addi	a5,a5,-1120 # 8001ff38 <log+0x38>
    800043a0:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    800043a2:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    800043a4:	4394                	lw	a3,0(a5)
    800043a6:	06b68a63          	beq	a3,a1,8000441a <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    800043aa:	2705                	addiw	a4,a4,1
    800043ac:	0791                	addi	a5,a5,4
    800043ae:	fec71be3          	bne	a4,a2,800043a4 <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    800043b2:	02c00793          	li	a5,44
    800043b6:	02f907b3          	mul	a5,s2,a5
    800043ba:	97b2                	add	a5,a5,a2
    800043bc:	07b1                	addi	a5,a5,12
    800043be:	078a                	slli	a5,a5,0x2
    800043c0:	0001c717          	auipc	a4,0x1c
    800043c4:	b4070713          	addi	a4,a4,-1216 # 8001ff00 <log>
    800043c8:	97ba                	add	a5,a5,a4
    800043ca:	00c9a703          	lw	a4,12(s3)
    800043ce:	c798                	sw	a4,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    800043d0:	854e                	mv	a0,s3
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	cdc080e7          	jalr	-804(ra) # 800030ae <bpin>
    log[dev].lh.n++;
    800043da:	0b000793          	li	a5,176
    800043de:	02f90933          	mul	s2,s2,a5
    800043e2:	0001c797          	auipc	a5,0x1c
    800043e6:	b1e78793          	addi	a5,a5,-1250 # 8001ff00 <log>
    800043ea:	993e                	add	s2,s2,a5
    800043ec:	03492783          	lw	a5,52(s2)
    800043f0:	2785                	addiw	a5,a5,1
    800043f2:	02f92a23          	sw	a5,52(s2)
    800043f6:	a099                	j	8000443c <log_write+0x126>
    panic("too big a transaction");
    800043f8:	00004517          	auipc	a0,0x4
    800043fc:	5c850513          	addi	a0,a0,1480 # 800089c0 <userret+0x930>
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	154080e7          	jalr	340(ra) # 80000554 <panic>
    panic("log_write outside of trans");
    80004408:	00004517          	auipc	a0,0x4
    8000440c:	5d050513          	addi	a0,a0,1488 # 800089d8 <userret+0x948>
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	144080e7          	jalr	324(ra) # 80000554 <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004418:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    8000441a:	02c00793          	li	a5,44
    8000441e:	02f907b3          	mul	a5,s2,a5
    80004422:	97ba                	add	a5,a5,a4
    80004424:	07b1                	addi	a5,a5,12
    80004426:	078a                	slli	a5,a5,0x2
    80004428:	0001c697          	auipc	a3,0x1c
    8000442c:	ad868693          	addi	a3,a3,-1320 # 8001ff00 <log>
    80004430:	97b6                	add	a5,a5,a3
    80004432:	00c9a683          	lw	a3,12(s3)
    80004436:	c794                	sw	a3,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    80004438:	f8e60ce3          	beq	a2,a4,800043d0 <log_write+0xba>
  }
  release(&log[dev].lock);
    8000443c:	8552                	mv	a0,s4
    8000443e:	ffffc097          	auipc	ra,0xffffc
    80004442:	732080e7          	jalr	1842(ra) # 80000b70 <release>
}
    80004446:	70a2                	ld	ra,40(sp)
    80004448:	7402                	ld	s0,32(sp)
    8000444a:	64e2                	ld	s1,24(sp)
    8000444c:	6942                	ld	s2,16(sp)
    8000444e:	69a2                	ld	s3,8(sp)
    80004450:	6a02                	ld	s4,0(sp)
    80004452:	6145                	addi	sp,sp,48
    80004454:	8082                	ret

0000000080004456 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004456:	1101                	addi	sp,sp,-32
    80004458:	ec06                	sd	ra,24(sp)
    8000445a:	e822                	sd	s0,16(sp)
    8000445c:	e426                	sd	s1,8(sp)
    8000445e:	e04a                	sd	s2,0(sp)
    80004460:	1000                	addi	s0,sp,32
    80004462:	84aa                	mv	s1,a0
    80004464:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004466:	00004597          	auipc	a1,0x4
    8000446a:	59258593          	addi	a1,a1,1426 # 800089f8 <userret+0x968>
    8000446e:	0521                	addi	a0,a0,8
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	55c080e7          	jalr	1372(ra) # 800009cc <initlock>
  lk->name = name;
    80004478:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    8000447c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004480:	0204a823          	sw	zero,48(s1)
}
    80004484:	60e2                	ld	ra,24(sp)
    80004486:	6442                	ld	s0,16(sp)
    80004488:	64a2                	ld	s1,8(sp)
    8000448a:	6902                	ld	s2,0(sp)
    8000448c:	6105                	addi	sp,sp,32
    8000448e:	8082                	ret

0000000080004490 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	e04a                	sd	s2,0(sp)
    8000449a:	1000                	addi	s0,sp,32
    8000449c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000449e:	00850913          	addi	s2,a0,8
    800044a2:	854a                	mv	a0,s2
    800044a4:	ffffc097          	auipc	ra,0xffffc
    800044a8:	5fc080e7          	jalr	1532(ra) # 80000aa0 <acquire>
  while (lk->locked) {
    800044ac:	409c                	lw	a5,0(s1)
    800044ae:	cb89                	beqz	a5,800044c0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044b0:	85ca                	mv	a1,s2
    800044b2:	8526                	mv	a0,s1
    800044b4:	ffffe097          	auipc	ra,0xffffe
    800044b8:	d64080e7          	jalr	-668(ra) # 80002218 <sleep>
  while (lk->locked) {
    800044bc:	409c                	lw	a5,0(s1)
    800044be:	fbed                	bnez	a5,800044b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044c0:	4785                	li	a5,1
    800044c2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	594080e7          	jalr	1428(ra) # 80001a58 <myproc>
    800044cc:	413c                	lw	a5,64(a0)
    800044ce:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    800044d0:	854a                	mv	a0,s2
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	69e080e7          	jalr	1694(ra) # 80000b70 <release>
}
    800044da:	60e2                	ld	ra,24(sp)
    800044dc:	6442                	ld	s0,16(sp)
    800044de:	64a2                	ld	s1,8(sp)
    800044e0:	6902                	ld	s2,0(sp)
    800044e2:	6105                	addi	sp,sp,32
    800044e4:	8082                	ret

00000000800044e6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800044e6:	1101                	addi	sp,sp,-32
    800044e8:	ec06                	sd	ra,24(sp)
    800044ea:	e822                	sd	s0,16(sp)
    800044ec:	e426                	sd	s1,8(sp)
    800044ee:	e04a                	sd	s2,0(sp)
    800044f0:	1000                	addi	s0,sp,32
    800044f2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044f4:	00850913          	addi	s2,a0,8
    800044f8:	854a                	mv	a0,s2
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	5a6080e7          	jalr	1446(ra) # 80000aa0 <acquire>
  lk->locked = 0;
    80004502:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004506:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    8000450a:	8526                	mv	a0,s1
    8000450c:	ffffe097          	auipc	ra,0xffffe
    80004510:	e8c080e7          	jalr	-372(ra) # 80002398 <wakeup>
  release(&lk->lk);
    80004514:	854a                	mv	a0,s2
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	65a080e7          	jalr	1626(ra) # 80000b70 <release>
}
    8000451e:	60e2                	ld	ra,24(sp)
    80004520:	6442                	ld	s0,16(sp)
    80004522:	64a2                	ld	s1,8(sp)
    80004524:	6902                	ld	s2,0(sp)
    80004526:	6105                	addi	sp,sp,32
    80004528:	8082                	ret

000000008000452a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000452a:	7179                	addi	sp,sp,-48
    8000452c:	f406                	sd	ra,40(sp)
    8000452e:	f022                	sd	s0,32(sp)
    80004530:	ec26                	sd	s1,24(sp)
    80004532:	e84a                	sd	s2,16(sp)
    80004534:	e44e                	sd	s3,8(sp)
    80004536:	1800                	addi	s0,sp,48
    80004538:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000453a:	00850913          	addi	s2,a0,8
    8000453e:	854a                	mv	a0,s2
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	560080e7          	jalr	1376(ra) # 80000aa0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004548:	409c                	lw	a5,0(s1)
    8000454a:	ef99                	bnez	a5,80004568 <holdingsleep+0x3e>
    8000454c:	4481                	li	s1,0
  release(&lk->lk);
    8000454e:	854a                	mv	a0,s2
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	620080e7          	jalr	1568(ra) # 80000b70 <release>
  return r;
}
    80004558:	8526                	mv	a0,s1
    8000455a:	70a2                	ld	ra,40(sp)
    8000455c:	7402                	ld	s0,32(sp)
    8000455e:	64e2                	ld	s1,24(sp)
    80004560:	6942                	ld	s2,16(sp)
    80004562:	69a2                	ld	s3,8(sp)
    80004564:	6145                	addi	sp,sp,48
    80004566:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004568:	0304a983          	lw	s3,48(s1)
    8000456c:	ffffd097          	auipc	ra,0xffffd
    80004570:	4ec080e7          	jalr	1260(ra) # 80001a58 <myproc>
    80004574:	4124                	lw	s1,64(a0)
    80004576:	413484b3          	sub	s1,s1,s3
    8000457a:	0014b493          	seqz	s1,s1
    8000457e:	bfc1                	j	8000454e <holdingsleep+0x24>

0000000080004580 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004580:	1141                	addi	sp,sp,-16
    80004582:	e406                	sd	ra,8(sp)
    80004584:	e022                	sd	s0,0(sp)
    80004586:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004588:	00004597          	auipc	a1,0x4
    8000458c:	48058593          	addi	a1,a1,1152 # 80008a08 <userret+0x978>
    80004590:	0001c517          	auipc	a0,0x1c
    80004594:	b7050513          	addi	a0,a0,-1168 # 80020100 <ftable>
    80004598:	ffffc097          	auipc	ra,0xffffc
    8000459c:	434080e7          	jalr	1076(ra) # 800009cc <initlock>
}
    800045a0:	60a2                	ld	ra,8(sp)
    800045a2:	6402                	ld	s0,0(sp)
    800045a4:	0141                	addi	sp,sp,16
    800045a6:	8082                	ret

00000000800045a8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045a8:	1101                	addi	sp,sp,-32
    800045aa:	ec06                	sd	ra,24(sp)
    800045ac:	e822                	sd	s0,16(sp)
    800045ae:	e426                	sd	s1,8(sp)
    800045b0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045b2:	0001c517          	auipc	a0,0x1c
    800045b6:	b4e50513          	addi	a0,a0,-1202 # 80020100 <ftable>
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	4e6080e7          	jalr	1254(ra) # 80000aa0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045c2:	0001c497          	auipc	s1,0x1c
    800045c6:	b5e48493          	addi	s1,s1,-1186 # 80020120 <ftable+0x20>
    800045ca:	0001d717          	auipc	a4,0x1d
    800045ce:	af670713          	addi	a4,a4,-1290 # 800210c0 <ftable+0xfc0>
    if(f->ref == 0){
    800045d2:	40dc                	lw	a5,4(s1)
    800045d4:	cf99                	beqz	a5,800045f2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045d6:	02848493          	addi	s1,s1,40
    800045da:	fee49ce3          	bne	s1,a4,800045d2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045de:	0001c517          	auipc	a0,0x1c
    800045e2:	b2250513          	addi	a0,a0,-1246 # 80020100 <ftable>
    800045e6:	ffffc097          	auipc	ra,0xffffc
    800045ea:	58a080e7          	jalr	1418(ra) # 80000b70 <release>
  return 0;
    800045ee:	4481                	li	s1,0
    800045f0:	a819                	j	80004606 <filealloc+0x5e>
      f->ref = 1;
    800045f2:	4785                	li	a5,1
    800045f4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800045f6:	0001c517          	auipc	a0,0x1c
    800045fa:	b0a50513          	addi	a0,a0,-1270 # 80020100 <ftable>
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	572080e7          	jalr	1394(ra) # 80000b70 <release>
}
    80004606:	8526                	mv	a0,s1
    80004608:	60e2                	ld	ra,24(sp)
    8000460a:	6442                	ld	s0,16(sp)
    8000460c:	64a2                	ld	s1,8(sp)
    8000460e:	6105                	addi	sp,sp,32
    80004610:	8082                	ret

0000000080004612 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004612:	1101                	addi	sp,sp,-32
    80004614:	ec06                	sd	ra,24(sp)
    80004616:	e822                	sd	s0,16(sp)
    80004618:	e426                	sd	s1,8(sp)
    8000461a:	1000                	addi	s0,sp,32
    8000461c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000461e:	0001c517          	auipc	a0,0x1c
    80004622:	ae250513          	addi	a0,a0,-1310 # 80020100 <ftable>
    80004626:	ffffc097          	auipc	ra,0xffffc
    8000462a:	47a080e7          	jalr	1146(ra) # 80000aa0 <acquire>
  if(f->ref < 1)
    8000462e:	40dc                	lw	a5,4(s1)
    80004630:	02f05263          	blez	a5,80004654 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004634:	2785                	addiw	a5,a5,1
    80004636:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004638:	0001c517          	auipc	a0,0x1c
    8000463c:	ac850513          	addi	a0,a0,-1336 # 80020100 <ftable>
    80004640:	ffffc097          	auipc	ra,0xffffc
    80004644:	530080e7          	jalr	1328(ra) # 80000b70 <release>
  return f;
}
    80004648:	8526                	mv	a0,s1
    8000464a:	60e2                	ld	ra,24(sp)
    8000464c:	6442                	ld	s0,16(sp)
    8000464e:	64a2                	ld	s1,8(sp)
    80004650:	6105                	addi	sp,sp,32
    80004652:	8082                	ret
    panic("filedup");
    80004654:	00004517          	auipc	a0,0x4
    80004658:	3bc50513          	addi	a0,a0,956 # 80008a10 <userret+0x980>
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	ef8080e7          	jalr	-264(ra) # 80000554 <panic>

0000000080004664 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004664:	7139                	addi	sp,sp,-64
    80004666:	fc06                	sd	ra,56(sp)
    80004668:	f822                	sd	s0,48(sp)
    8000466a:	f426                	sd	s1,40(sp)
    8000466c:	f04a                	sd	s2,32(sp)
    8000466e:	ec4e                	sd	s3,24(sp)
    80004670:	e852                	sd	s4,16(sp)
    80004672:	e456                	sd	s5,8(sp)
    80004674:	0080                	addi	s0,sp,64
    80004676:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004678:	0001c517          	auipc	a0,0x1c
    8000467c:	a8850513          	addi	a0,a0,-1400 # 80020100 <ftable>
    80004680:	ffffc097          	auipc	ra,0xffffc
    80004684:	420080e7          	jalr	1056(ra) # 80000aa0 <acquire>
  if(f->ref < 1)
    80004688:	40dc                	lw	a5,4(s1)
    8000468a:	06f05563          	blez	a5,800046f4 <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    8000468e:	37fd                	addiw	a5,a5,-1
    80004690:	0007871b          	sext.w	a4,a5
    80004694:	c0dc                	sw	a5,4(s1)
    80004696:	06e04763          	bgtz	a4,80004704 <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000469a:	0004a903          	lw	s2,0(s1)
    8000469e:	0094ca83          	lbu	s5,9(s1)
    800046a2:	0104ba03          	ld	s4,16(s1)
    800046a6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046aa:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046ae:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046b2:	0001c517          	auipc	a0,0x1c
    800046b6:	a4e50513          	addi	a0,a0,-1458 # 80020100 <ftable>
    800046ba:	ffffc097          	auipc	ra,0xffffc
    800046be:	4b6080e7          	jalr	1206(ra) # 80000b70 <release>

  if(ff.type == FD_PIPE){
    800046c2:	4785                	li	a5,1
    800046c4:	06f90163          	beq	s2,a5,80004726 <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046c8:	3979                	addiw	s2,s2,-2
    800046ca:	4785                	li	a5,1
    800046cc:	0527e463          	bltu	a5,s2,80004714 <fileclose+0xb0>
    begin_op(ff.ip->dev);
    800046d0:	0009a503          	lw	a0,0(s3)
    800046d4:	00000097          	auipc	ra,0x0
    800046d8:	9f6080e7          	jalr	-1546(ra) # 800040ca <begin_op>
    iput(ff.ip);
    800046dc:	854e                	mv	a0,s3
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	114080e7          	jalr	276(ra) # 800037f2 <iput>
    end_op(ff.ip->dev);
    800046e6:	0009a503          	lw	a0,0(s3)
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	a8a080e7          	jalr	-1398(ra) # 80004174 <end_op>
    800046f2:	a00d                	j	80004714 <fileclose+0xb0>
    panic("fileclose");
    800046f4:	00004517          	auipc	a0,0x4
    800046f8:	32450513          	addi	a0,a0,804 # 80008a18 <userret+0x988>
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	e58080e7          	jalr	-424(ra) # 80000554 <panic>
    release(&ftable.lock);
    80004704:	0001c517          	auipc	a0,0x1c
    80004708:	9fc50513          	addi	a0,a0,-1540 # 80020100 <ftable>
    8000470c:	ffffc097          	auipc	ra,0xffffc
    80004710:	464080e7          	jalr	1124(ra) # 80000b70 <release>
  }
}
    80004714:	70e2                	ld	ra,56(sp)
    80004716:	7442                	ld	s0,48(sp)
    80004718:	74a2                	ld	s1,40(sp)
    8000471a:	7902                	ld	s2,32(sp)
    8000471c:	69e2                	ld	s3,24(sp)
    8000471e:	6a42                	ld	s4,16(sp)
    80004720:	6aa2                	ld	s5,8(sp)
    80004722:	6121                	addi	sp,sp,64
    80004724:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004726:	85d6                	mv	a1,s5
    80004728:	8552                	mv	a0,s4
    8000472a:	00000097          	auipc	ra,0x0
    8000472e:	376080e7          	jalr	886(ra) # 80004aa0 <pipeclose>
    80004732:	b7cd                	j	80004714 <fileclose+0xb0>

0000000080004734 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004734:	715d                	addi	sp,sp,-80
    80004736:	e486                	sd	ra,72(sp)
    80004738:	e0a2                	sd	s0,64(sp)
    8000473a:	fc26                	sd	s1,56(sp)
    8000473c:	f84a                	sd	s2,48(sp)
    8000473e:	f44e                	sd	s3,40(sp)
    80004740:	0880                	addi	s0,sp,80
    80004742:	84aa                	mv	s1,a0
    80004744:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004746:	ffffd097          	auipc	ra,0xffffd
    8000474a:	312080e7          	jalr	786(ra) # 80001a58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000474e:	409c                	lw	a5,0(s1)
    80004750:	37f9                	addiw	a5,a5,-2
    80004752:	4705                	li	a4,1
    80004754:	04f76763          	bltu	a4,a5,800047a2 <filestat+0x6e>
    80004758:	892a                	mv	s2,a0
    ilock(f->ip);
    8000475a:	6c88                	ld	a0,24(s1)
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	f88080e7          	jalr	-120(ra) # 800036e4 <ilock>
    stati(f->ip, &st);
    80004764:	fb840593          	addi	a1,s0,-72
    80004768:	6c88                	ld	a0,24(s1)
    8000476a:	fffff097          	auipc	ra,0xfffff
    8000476e:	1e0080e7          	jalr	480(ra) # 8000394a <stati>
    iunlock(f->ip);
    80004772:	6c88                	ld	a0,24(s1)
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	032080e7          	jalr	50(ra) # 800037a6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000477c:	46e1                	li	a3,24
    8000477e:	fb840613          	addi	a2,s0,-72
    80004782:	85ce                	mv	a1,s3
    80004784:	05893503          	ld	a0,88(s2)
    80004788:	ffffd097          	auipc	ra,0xffffd
    8000478c:	fc2080e7          	jalr	-62(ra) # 8000174a <copyout>
    80004790:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004794:	60a6                	ld	ra,72(sp)
    80004796:	6406                	ld	s0,64(sp)
    80004798:	74e2                	ld	s1,56(sp)
    8000479a:	7942                	ld	s2,48(sp)
    8000479c:	79a2                	ld	s3,40(sp)
    8000479e:	6161                	addi	sp,sp,80
    800047a0:	8082                	ret
  return -1;
    800047a2:	557d                	li	a0,-1
    800047a4:	bfc5                	j	80004794 <filestat+0x60>

00000000800047a6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047a6:	7179                	addi	sp,sp,-48
    800047a8:	f406                	sd	ra,40(sp)
    800047aa:	f022                	sd	s0,32(sp)
    800047ac:	ec26                	sd	s1,24(sp)
    800047ae:	e84a                	sd	s2,16(sp)
    800047b0:	e44e                	sd	s3,8(sp)
    800047b2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047b4:	00854783          	lbu	a5,8(a0)
    800047b8:	c7c5                	beqz	a5,80004860 <fileread+0xba>
    800047ba:	84aa                	mv	s1,a0
    800047bc:	89ae                	mv	s3,a1
    800047be:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047c0:	411c                	lw	a5,0(a0)
    800047c2:	4705                	li	a4,1
    800047c4:	04e78963          	beq	a5,a4,80004816 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047c8:	470d                	li	a4,3
    800047ca:	04e78d63          	beq	a5,a4,80004824 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    800047ce:	4709                	li	a4,2
    800047d0:	08e79063          	bne	a5,a4,80004850 <fileread+0xaa>
    ilock(f->ip);
    800047d4:	6d08                	ld	a0,24(a0)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	f0e080e7          	jalr	-242(ra) # 800036e4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047de:	874a                	mv	a4,s2
    800047e0:	5094                	lw	a3,32(s1)
    800047e2:	864e                	mv	a2,s3
    800047e4:	4585                	li	a1,1
    800047e6:	6c88                	ld	a0,24(s1)
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	18c080e7          	jalr	396(ra) # 80003974 <readi>
    800047f0:	892a                	mv	s2,a0
    800047f2:	00a05563          	blez	a0,800047fc <fileread+0x56>
      f->off += r;
    800047f6:	509c                	lw	a5,32(s1)
    800047f8:	9fa9                	addw	a5,a5,a0
    800047fa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047fc:	6c88                	ld	a0,24(s1)
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	fa8080e7          	jalr	-88(ra) # 800037a6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004806:	854a                	mv	a0,s2
    80004808:	70a2                	ld	ra,40(sp)
    8000480a:	7402                	ld	s0,32(sp)
    8000480c:	64e2                	ld	s1,24(sp)
    8000480e:	6942                	ld	s2,16(sp)
    80004810:	69a2                	ld	s3,8(sp)
    80004812:	6145                	addi	sp,sp,48
    80004814:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004816:	6908                	ld	a0,16(a0)
    80004818:	00000097          	auipc	ra,0x0
    8000481c:	406080e7          	jalr	1030(ra) # 80004c1e <piperead>
    80004820:	892a                	mv	s2,a0
    80004822:	b7d5                	j	80004806 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004824:	02451783          	lh	a5,36(a0)
    80004828:	03079693          	slli	a3,a5,0x30
    8000482c:	92c1                	srli	a3,a3,0x30
    8000482e:	4725                	li	a4,9
    80004830:	02d76a63          	bltu	a4,a3,80004864 <fileread+0xbe>
    80004834:	0792                	slli	a5,a5,0x4
    80004836:	0001c717          	auipc	a4,0x1c
    8000483a:	82a70713          	addi	a4,a4,-2006 # 80020060 <devsw>
    8000483e:	97ba                	add	a5,a5,a4
    80004840:	639c                	ld	a5,0(a5)
    80004842:	c39d                	beqz	a5,80004868 <fileread+0xc2>
    r = devsw[f->major].read(f, 1, addr, n);
    80004844:	86b2                	mv	a3,a2
    80004846:	862e                	mv	a2,a1
    80004848:	4585                	li	a1,1
    8000484a:	9782                	jalr	a5
    8000484c:	892a                	mv	s2,a0
    8000484e:	bf65                	j	80004806 <fileread+0x60>
    panic("fileread");
    80004850:	00004517          	auipc	a0,0x4
    80004854:	1d850513          	addi	a0,a0,472 # 80008a28 <userret+0x998>
    80004858:	ffffc097          	auipc	ra,0xffffc
    8000485c:	cfc080e7          	jalr	-772(ra) # 80000554 <panic>
    return -1;
    80004860:	597d                	li	s2,-1
    80004862:	b755                	j	80004806 <fileread+0x60>
      return -1;
    80004864:	597d                	li	s2,-1
    80004866:	b745                	j	80004806 <fileread+0x60>
    80004868:	597d                	li	s2,-1
    8000486a:	bf71                	j	80004806 <fileread+0x60>

000000008000486c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000486c:	00954783          	lbu	a5,9(a0)
    80004870:	14078663          	beqz	a5,800049bc <filewrite+0x150>
{
    80004874:	715d                	addi	sp,sp,-80
    80004876:	e486                	sd	ra,72(sp)
    80004878:	e0a2                	sd	s0,64(sp)
    8000487a:	fc26                	sd	s1,56(sp)
    8000487c:	f84a                	sd	s2,48(sp)
    8000487e:	f44e                	sd	s3,40(sp)
    80004880:	f052                	sd	s4,32(sp)
    80004882:	ec56                	sd	s5,24(sp)
    80004884:	e85a                	sd	s6,16(sp)
    80004886:	e45e                	sd	s7,8(sp)
    80004888:	e062                	sd	s8,0(sp)
    8000488a:	0880                	addi	s0,sp,80
    8000488c:	84aa                	mv	s1,a0
    8000488e:	8aae                	mv	s5,a1
    80004890:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004892:	411c                	lw	a5,0(a0)
    80004894:	4705                	li	a4,1
    80004896:	02e78263          	beq	a5,a4,800048ba <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000489a:	470d                	li	a4,3
    8000489c:	02e78563          	beq	a5,a4,800048c6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    800048a0:	4709                	li	a4,2
    800048a2:	10e79563          	bne	a5,a4,800049ac <filewrite+0x140>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048a6:	0ec05f63          	blez	a2,800049a4 <filewrite+0x138>
    int i = 0;
    800048aa:	4981                	li	s3,0
    800048ac:	6b05                	lui	s6,0x1
    800048ae:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800048b2:	6b85                	lui	s7,0x1
    800048b4:	c00b8b9b          	addiw	s7,s7,-1024
    800048b8:	a851                	j	8000494c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800048ba:	6908                	ld	a0,16(a0)
    800048bc:	00000097          	auipc	ra,0x0
    800048c0:	254080e7          	jalr	596(ra) # 80004b10 <pipewrite>
    800048c4:	a865                	j	8000497c <filewrite+0x110>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048c6:	02451783          	lh	a5,36(a0)
    800048ca:	03079693          	slli	a3,a5,0x30
    800048ce:	92c1                	srli	a3,a3,0x30
    800048d0:	4725                	li	a4,9
    800048d2:	0ed76763          	bltu	a4,a3,800049c0 <filewrite+0x154>
    800048d6:	0792                	slli	a5,a5,0x4
    800048d8:	0001b717          	auipc	a4,0x1b
    800048dc:	78870713          	addi	a4,a4,1928 # 80020060 <devsw>
    800048e0:	97ba                	add	a5,a5,a4
    800048e2:	679c                	ld	a5,8(a5)
    800048e4:	c3e5                	beqz	a5,800049c4 <filewrite+0x158>
    ret = devsw[f->major].write(f, 1, addr, n);
    800048e6:	86b2                	mv	a3,a2
    800048e8:	862e                	mv	a2,a1
    800048ea:	4585                	li	a1,1
    800048ec:	9782                	jalr	a5
    800048ee:	a079                	j	8000497c <filewrite+0x110>
    800048f0:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    800048f4:	6c9c                	ld	a5,24(s1)
    800048f6:	4388                	lw	a0,0(a5)
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	7d2080e7          	jalr	2002(ra) # 800040ca <begin_op>
      ilock(f->ip);
    80004900:	6c88                	ld	a0,24(s1)
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	de2080e7          	jalr	-542(ra) # 800036e4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000490a:	8762                	mv	a4,s8
    8000490c:	5094                	lw	a3,32(s1)
    8000490e:	01598633          	add	a2,s3,s5
    80004912:	4585                	li	a1,1
    80004914:	6c88                	ld	a0,24(s1)
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	152080e7          	jalr	338(ra) # 80003a68 <writei>
    8000491e:	892a                	mv	s2,a0
    80004920:	02a05e63          	blez	a0,8000495c <filewrite+0xf0>
        f->off += r;
    80004924:	509c                	lw	a5,32(s1)
    80004926:	9fa9                	addw	a5,a5,a0
    80004928:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    8000492a:	6c88                	ld	a0,24(s1)
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	e7a080e7          	jalr	-390(ra) # 800037a6 <iunlock>
      end_op(f->ip->dev);
    80004934:	6c9c                	ld	a5,24(s1)
    80004936:	4388                	lw	a0,0(a5)
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	83c080e7          	jalr	-1988(ra) # 80004174 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004940:	052c1a63          	bne	s8,s2,80004994 <filewrite+0x128>
        panic("short filewrite");
      i += r;
    80004944:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80004948:	0349d763          	bge	s3,s4,80004976 <filewrite+0x10a>
      int n1 = n - i;
    8000494c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004950:	893e                	mv	s2,a5
    80004952:	2781                	sext.w	a5,a5
    80004954:	f8fb5ee3          	bge	s6,a5,800048f0 <filewrite+0x84>
    80004958:	895e                	mv	s2,s7
    8000495a:	bf59                	j	800048f0 <filewrite+0x84>
      iunlock(f->ip);
    8000495c:	6c88                	ld	a0,24(s1)
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	e48080e7          	jalr	-440(ra) # 800037a6 <iunlock>
      end_op(f->ip->dev);
    80004966:	6c9c                	ld	a5,24(s1)
    80004968:	4388                	lw	a0,0(a5)
    8000496a:	00000097          	auipc	ra,0x0
    8000496e:	80a080e7          	jalr	-2038(ra) # 80004174 <end_op>
      if(r < 0)
    80004972:	fc0957e3          	bgez	s2,80004940 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004976:	8552                	mv	a0,s4
    80004978:	033a1863          	bne	s4,s3,800049a8 <filewrite+0x13c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000497c:	60a6                	ld	ra,72(sp)
    8000497e:	6406                	ld	s0,64(sp)
    80004980:	74e2                	ld	s1,56(sp)
    80004982:	7942                	ld	s2,48(sp)
    80004984:	79a2                	ld	s3,40(sp)
    80004986:	7a02                	ld	s4,32(sp)
    80004988:	6ae2                	ld	s5,24(sp)
    8000498a:	6b42                	ld	s6,16(sp)
    8000498c:	6ba2                	ld	s7,8(sp)
    8000498e:	6c02                	ld	s8,0(sp)
    80004990:	6161                	addi	sp,sp,80
    80004992:	8082                	ret
        panic("short filewrite");
    80004994:	00004517          	auipc	a0,0x4
    80004998:	0a450513          	addi	a0,a0,164 # 80008a38 <userret+0x9a8>
    8000499c:	ffffc097          	auipc	ra,0xffffc
    800049a0:	bb8080e7          	jalr	-1096(ra) # 80000554 <panic>
    int i = 0;
    800049a4:	4981                	li	s3,0
    800049a6:	bfc1                	j	80004976 <filewrite+0x10a>
    ret = (i == n ? n : -1);
    800049a8:	557d                	li	a0,-1
    800049aa:	bfc9                	j	8000497c <filewrite+0x110>
    panic("filewrite");
    800049ac:	00004517          	auipc	a0,0x4
    800049b0:	09c50513          	addi	a0,a0,156 # 80008a48 <userret+0x9b8>
    800049b4:	ffffc097          	auipc	ra,0xffffc
    800049b8:	ba0080e7          	jalr	-1120(ra) # 80000554 <panic>
    return -1;
    800049bc:	557d                	li	a0,-1
}
    800049be:	8082                	ret
      return -1;
    800049c0:	557d                	li	a0,-1
    800049c2:	bf6d                	j	8000497c <filewrite+0x110>
    800049c4:	557d                	li	a0,-1
    800049c6:	bf5d                	j	8000497c <filewrite+0x110>

00000000800049c8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049c8:	7179                	addi	sp,sp,-48
    800049ca:	f406                	sd	ra,40(sp)
    800049cc:	f022                	sd	s0,32(sp)
    800049ce:	ec26                	sd	s1,24(sp)
    800049d0:	e84a                	sd	s2,16(sp)
    800049d2:	e44e                	sd	s3,8(sp)
    800049d4:	e052                	sd	s4,0(sp)
    800049d6:	1800                	addi	s0,sp,48
    800049d8:	84aa                	mv	s1,a0
    800049da:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049dc:	0005b023          	sd	zero,0(a1)
    800049e0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049e4:	00000097          	auipc	ra,0x0
    800049e8:	bc4080e7          	jalr	-1084(ra) # 800045a8 <filealloc>
    800049ec:	e088                	sd	a0,0(s1)
    800049ee:	c549                	beqz	a0,80004a78 <pipealloc+0xb0>
    800049f0:	00000097          	auipc	ra,0x0
    800049f4:	bb8080e7          	jalr	-1096(ra) # 800045a8 <filealloc>
    800049f8:	00aa3023          	sd	a0,0(s4)
    800049fc:	c925                	beqz	a0,80004a6c <pipealloc+0xa4>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	f6e080e7          	jalr	-146(ra) # 8000096c <kalloc>
    80004a06:	892a                	mv	s2,a0
    80004a08:	cd39                	beqz	a0,80004a66 <pipealloc+0x9e>
    goto bad;
  pi->readopen = 1;
    80004a0a:	4985                	li	s3,1
    80004a0c:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004a10:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004a14:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004a18:	22052023          	sw	zero,544(a0)
  memset(&pi->lock, 0, sizeof(pi->lock));
    80004a1c:	02000613          	li	a2,32
    80004a20:	4581                	li	a1,0
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	34c080e7          	jalr	844(ra) # 80000d6e <memset>
  (*f0)->type = FD_PIPE;
    80004a2a:	609c                	ld	a5,0(s1)
    80004a2c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a30:	609c                	ld	a5,0(s1)
    80004a32:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a36:	609c                	ld	a5,0(s1)
    80004a38:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a3c:	609c                	ld	a5,0(s1)
    80004a3e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a42:	000a3783          	ld	a5,0(s4)
    80004a46:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a4a:	000a3783          	ld	a5,0(s4)
    80004a4e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a52:	000a3783          	ld	a5,0(s4)
    80004a56:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a5a:	000a3783          	ld	a5,0(s4)
    80004a5e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a62:	4501                	li	a0,0
    80004a64:	a025                	j	80004a8c <pipealloc+0xc4>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a66:	6088                	ld	a0,0(s1)
    80004a68:	e501                	bnez	a0,80004a70 <pipealloc+0xa8>
    80004a6a:	a039                	j	80004a78 <pipealloc+0xb0>
    80004a6c:	6088                	ld	a0,0(s1)
    80004a6e:	c51d                	beqz	a0,80004a9c <pipealloc+0xd4>
    fileclose(*f0);
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	bf4080e7          	jalr	-1036(ra) # 80004664 <fileclose>
  if(*f1)
    80004a78:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a7c:	557d                	li	a0,-1
  if(*f1)
    80004a7e:	c799                	beqz	a5,80004a8c <pipealloc+0xc4>
    fileclose(*f1);
    80004a80:	853e                	mv	a0,a5
    80004a82:	00000097          	auipc	ra,0x0
    80004a86:	be2080e7          	jalr	-1054(ra) # 80004664 <fileclose>
  return -1;
    80004a8a:	557d                	li	a0,-1
}
    80004a8c:	70a2                	ld	ra,40(sp)
    80004a8e:	7402                	ld	s0,32(sp)
    80004a90:	64e2                	ld	s1,24(sp)
    80004a92:	6942                	ld	s2,16(sp)
    80004a94:	69a2                	ld	s3,8(sp)
    80004a96:	6a02                	ld	s4,0(sp)
    80004a98:	6145                	addi	sp,sp,48
    80004a9a:	8082                	ret
  return -1;
    80004a9c:	557d                	li	a0,-1
    80004a9e:	b7fd                	j	80004a8c <pipealloc+0xc4>

0000000080004aa0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004aa0:	1101                	addi	sp,sp,-32
    80004aa2:	ec06                	sd	ra,24(sp)
    80004aa4:	e822                	sd	s0,16(sp)
    80004aa6:	e426                	sd	s1,8(sp)
    80004aa8:	e04a                	sd	s2,0(sp)
    80004aaa:	1000                	addi	s0,sp,32
    80004aac:	84aa                	mv	s1,a0
    80004aae:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ab0:	ffffc097          	auipc	ra,0xffffc
    80004ab4:	ff0080e7          	jalr	-16(ra) # 80000aa0 <acquire>
  if(writable){
    80004ab8:	02090d63          	beqz	s2,80004af2 <pipeclose+0x52>
    pi->writeopen = 0;
    80004abc:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004ac0:	22048513          	addi	a0,s1,544
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	8d4080e7          	jalr	-1836(ra) # 80002398 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004acc:	2284b783          	ld	a5,552(s1)
    80004ad0:	eb95                	bnez	a5,80004b04 <pipeclose+0x64>
    release(&pi->lock);
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	ffffc097          	auipc	ra,0xffffc
    80004ad8:	09c080e7          	jalr	156(ra) # 80000b70 <release>
    kfree((char*)pi);
    80004adc:	8526                	mv	a0,s1
    80004ade:	ffffc097          	auipc	ra,0xffffc
    80004ae2:	d92080e7          	jalr	-622(ra) # 80000870 <kfree>
  } else
    release(&pi->lock);
}
    80004ae6:	60e2                	ld	ra,24(sp)
    80004ae8:	6442                	ld	s0,16(sp)
    80004aea:	64a2                	ld	s1,8(sp)
    80004aec:	6902                	ld	s2,0(sp)
    80004aee:	6105                	addi	sp,sp,32
    80004af0:	8082                	ret
    pi->readopen = 0;
    80004af2:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004af6:	22448513          	addi	a0,s1,548
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	89e080e7          	jalr	-1890(ra) # 80002398 <wakeup>
    80004b02:	b7e9                	j	80004acc <pipeclose+0x2c>
    release(&pi->lock);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffc097          	auipc	ra,0xffffc
    80004b0a:	06a080e7          	jalr	106(ra) # 80000b70 <release>
}
    80004b0e:	bfe1                	j	80004ae6 <pipeclose+0x46>

0000000080004b10 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b10:	711d                	addi	sp,sp,-96
    80004b12:	ec86                	sd	ra,88(sp)
    80004b14:	e8a2                	sd	s0,80(sp)
    80004b16:	e4a6                	sd	s1,72(sp)
    80004b18:	e0ca                	sd	s2,64(sp)
    80004b1a:	fc4e                	sd	s3,56(sp)
    80004b1c:	f852                	sd	s4,48(sp)
    80004b1e:	f456                	sd	s5,40(sp)
    80004b20:	f05a                	sd	s6,32(sp)
    80004b22:	ec5e                	sd	s7,24(sp)
    80004b24:	e862                	sd	s8,16(sp)
    80004b26:	1080                	addi	s0,sp,96
    80004b28:	84aa                	mv	s1,a0
    80004b2a:	8aae                	mv	s5,a1
    80004b2c:	8a32                	mv	s4,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	f2a080e7          	jalr	-214(ra) # 80001a58 <myproc>
    80004b36:	8baa                	mv	s7,a0

  acquire(&pi->lock);
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffc097          	auipc	ra,0xffffc
    80004b3e:	f66080e7          	jalr	-154(ra) # 80000aa0 <acquire>
  for(i = 0; i < n; i++){
    80004b42:	09405f63          	blez	s4,80004be0 <pipewrite+0xd0>
    80004b46:	fffa0b1b          	addiw	s6,s4,-1
    80004b4a:	1b02                	slli	s6,s6,0x20
    80004b4c:	020b5b13          	srli	s6,s6,0x20
    80004b50:	001a8793          	addi	a5,s5,1
    80004b54:	9b3e                	add	s6,s6,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004b56:	22048993          	addi	s3,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004b5a:	22448913          	addi	s2,s1,548
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b5e:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004b60:	2204a783          	lw	a5,544(s1)
    80004b64:	2244a703          	lw	a4,548(s1)
    80004b68:	2007879b          	addiw	a5,a5,512
    80004b6c:	02f71e63          	bne	a4,a5,80004ba8 <pipewrite+0x98>
      if(pi->readopen == 0 || myproc()->killed){
    80004b70:	2284a783          	lw	a5,552(s1)
    80004b74:	c3d9                	beqz	a5,80004bfa <pipewrite+0xea>
    80004b76:	ffffd097          	auipc	ra,0xffffd
    80004b7a:	ee2080e7          	jalr	-286(ra) # 80001a58 <myproc>
    80004b7e:	5d1c                	lw	a5,56(a0)
    80004b80:	efad                	bnez	a5,80004bfa <pipewrite+0xea>
      wakeup(&pi->nread);
    80004b82:	854e                	mv	a0,s3
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	814080e7          	jalr	-2028(ra) # 80002398 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b8c:	85a6                	mv	a1,s1
    80004b8e:	854a                	mv	a0,s2
    80004b90:	ffffd097          	auipc	ra,0xffffd
    80004b94:	688080e7          	jalr	1672(ra) # 80002218 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004b98:	2204a783          	lw	a5,544(s1)
    80004b9c:	2244a703          	lw	a4,548(s1)
    80004ba0:	2007879b          	addiw	a5,a5,512
    80004ba4:	fcf706e3          	beq	a4,a5,80004b70 <pipewrite+0x60>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ba8:	4685                	li	a3,1
    80004baa:	8656                	mv	a2,s5
    80004bac:	faf40593          	addi	a1,s0,-81
    80004bb0:	058bb503          	ld	a0,88(s7) # 1058 <_entry-0x7fffefa8>
    80004bb4:	ffffd097          	auipc	ra,0xffffd
    80004bb8:	c22080e7          	jalr	-990(ra) # 800017d6 <copyin>
    80004bbc:	03850263          	beq	a0,s8,80004be0 <pipewrite+0xd0>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004bc0:	2244a783          	lw	a5,548(s1)
    80004bc4:	0017871b          	addiw	a4,a5,1
    80004bc8:	22e4a223          	sw	a4,548(s1)
    80004bcc:	1ff7f793          	andi	a5,a5,511
    80004bd0:	97a6                	add	a5,a5,s1
    80004bd2:	faf44703          	lbu	a4,-81(s0)
    80004bd6:	02e78023          	sb	a4,32(a5)
  for(i = 0; i < n; i++){
    80004bda:	0a85                	addi	s5,s5,1
    80004bdc:	f96a92e3          	bne	s5,s6,80004b60 <pipewrite+0x50>
  }
  wakeup(&pi->nread);
    80004be0:	22048513          	addi	a0,s1,544
    80004be4:	ffffd097          	auipc	ra,0xffffd
    80004be8:	7b4080e7          	jalr	1972(ra) # 80002398 <wakeup>
  release(&pi->lock);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffc097          	auipc	ra,0xffffc
    80004bf2:	f82080e7          	jalr	-126(ra) # 80000b70 <release>
  return n;
    80004bf6:	8552                	mv	a0,s4
    80004bf8:	a039                	j	80004c06 <pipewrite+0xf6>
        release(&pi->lock);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffc097          	auipc	ra,0xffffc
    80004c00:	f74080e7          	jalr	-140(ra) # 80000b70 <release>
        return -1;
    80004c04:	557d                	li	a0,-1
}
    80004c06:	60e6                	ld	ra,88(sp)
    80004c08:	6446                	ld	s0,80(sp)
    80004c0a:	64a6                	ld	s1,72(sp)
    80004c0c:	6906                	ld	s2,64(sp)
    80004c0e:	79e2                	ld	s3,56(sp)
    80004c10:	7a42                	ld	s4,48(sp)
    80004c12:	7aa2                	ld	s5,40(sp)
    80004c14:	7b02                	ld	s6,32(sp)
    80004c16:	6be2                	ld	s7,24(sp)
    80004c18:	6c42                	ld	s8,16(sp)
    80004c1a:	6125                	addi	sp,sp,96
    80004c1c:	8082                	ret

0000000080004c1e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c1e:	715d                	addi	sp,sp,-80
    80004c20:	e486                	sd	ra,72(sp)
    80004c22:	e0a2                	sd	s0,64(sp)
    80004c24:	fc26                	sd	s1,56(sp)
    80004c26:	f84a                	sd	s2,48(sp)
    80004c28:	f44e                	sd	s3,40(sp)
    80004c2a:	f052                	sd	s4,32(sp)
    80004c2c:	ec56                	sd	s5,24(sp)
    80004c2e:	e85a                	sd	s6,16(sp)
    80004c30:	0880                	addi	s0,sp,80
    80004c32:	84aa                	mv	s1,a0
    80004c34:	892e                	mv	s2,a1
    80004c36:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004c38:	ffffd097          	auipc	ra,0xffffd
    80004c3c:	e20080e7          	jalr	-480(ra) # 80001a58 <myproc>
    80004c40:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004c42:	8526                	mv	a0,s1
    80004c44:	ffffc097          	auipc	ra,0xffffc
    80004c48:	e5c080e7          	jalr	-420(ra) # 80000aa0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c4c:	2204a703          	lw	a4,544(s1)
    80004c50:	2244a783          	lw	a5,548(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c54:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c58:	02f71763          	bne	a4,a5,80004c86 <piperead+0x68>
    80004c5c:	22c4a783          	lw	a5,556(s1)
    80004c60:	c39d                	beqz	a5,80004c86 <piperead+0x68>
    if(myproc()->killed){
    80004c62:	ffffd097          	auipc	ra,0xffffd
    80004c66:	df6080e7          	jalr	-522(ra) # 80001a58 <myproc>
    80004c6a:	5d1c                	lw	a5,56(a0)
    80004c6c:	ebc1                	bnez	a5,80004cfc <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c6e:	85a6                	mv	a1,s1
    80004c70:	854e                	mv	a0,s3
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	5a6080e7          	jalr	1446(ra) # 80002218 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c7a:	2204a703          	lw	a4,544(s1)
    80004c7e:	2244a783          	lw	a5,548(s1)
    80004c82:	fcf70de3          	beq	a4,a5,80004c5c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c86:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c88:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c8a:	05405363          	blez	s4,80004cd0 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004c8e:	2204a783          	lw	a5,544(s1)
    80004c92:	2244a703          	lw	a4,548(s1)
    80004c96:	02f70d63          	beq	a4,a5,80004cd0 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c9a:	0017871b          	addiw	a4,a5,1
    80004c9e:	22e4a023          	sw	a4,544(s1)
    80004ca2:	1ff7f793          	andi	a5,a5,511
    80004ca6:	97a6                	add	a5,a5,s1
    80004ca8:	0207c783          	lbu	a5,32(a5)
    80004cac:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004cb0:	4685                	li	a3,1
    80004cb2:	fbf40613          	addi	a2,s0,-65
    80004cb6:	85ca                	mv	a1,s2
    80004cb8:	058ab503          	ld	a0,88(s5)
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	a8e080e7          	jalr	-1394(ra) # 8000174a <copyout>
    80004cc4:	01650663          	beq	a0,s6,80004cd0 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cc8:	2985                	addiw	s3,s3,1
    80004cca:	0905                	addi	s2,s2,1
    80004ccc:	fd3a11e3          	bne	s4,s3,80004c8e <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004cd0:	22448513          	addi	a0,s1,548
    80004cd4:	ffffd097          	auipc	ra,0xffffd
    80004cd8:	6c4080e7          	jalr	1732(ra) # 80002398 <wakeup>
  release(&pi->lock);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffc097          	auipc	ra,0xffffc
    80004ce2:	e92080e7          	jalr	-366(ra) # 80000b70 <release>
  return i;
}
    80004ce6:	854e                	mv	a0,s3
    80004ce8:	60a6                	ld	ra,72(sp)
    80004cea:	6406                	ld	s0,64(sp)
    80004cec:	74e2                	ld	s1,56(sp)
    80004cee:	7942                	ld	s2,48(sp)
    80004cf0:	79a2                	ld	s3,40(sp)
    80004cf2:	7a02                	ld	s4,32(sp)
    80004cf4:	6ae2                	ld	s5,24(sp)
    80004cf6:	6b42                	ld	s6,16(sp)
    80004cf8:	6161                	addi	sp,sp,80
    80004cfa:	8082                	ret
      release(&pi->lock);
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	ffffc097          	auipc	ra,0xffffc
    80004d02:	e72080e7          	jalr	-398(ra) # 80000b70 <release>
      return -1;
    80004d06:	59fd                	li	s3,-1
    80004d08:	bff9                	j	80004ce6 <piperead+0xc8>

0000000080004d0a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004d0a:	de010113          	addi	sp,sp,-544
    80004d0e:	20113c23          	sd	ra,536(sp)
    80004d12:	20813823          	sd	s0,528(sp)
    80004d16:	20913423          	sd	s1,520(sp)
    80004d1a:	21213023          	sd	s2,512(sp)
    80004d1e:	ffce                	sd	s3,504(sp)
    80004d20:	fbd2                	sd	s4,496(sp)
    80004d22:	f7d6                	sd	s5,488(sp)
    80004d24:	f3da                	sd	s6,480(sp)
    80004d26:	efde                	sd	s7,472(sp)
    80004d28:	ebe2                	sd	s8,464(sp)
    80004d2a:	e7e6                	sd	s9,456(sp)
    80004d2c:	e3ea                	sd	s10,448(sp)
    80004d2e:	ff6e                	sd	s11,440(sp)
    80004d30:	1400                	addi	s0,sp,544
    80004d32:	892a                	mv	s2,a0
    80004d34:	dea43423          	sd	a0,-536(s0)
    80004d38:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	d1c080e7          	jalr	-740(ra) # 80001a58 <myproc>
    80004d44:	84aa                	mv	s1,a0

  begin_op(ROOTDEV);
    80004d46:	4501                	li	a0,0
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	382080e7          	jalr	898(ra) # 800040ca <begin_op>

  if((ip = namei(path)) == 0){
    80004d50:	854a                	mv	a0,s2
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	11c080e7          	jalr	284(ra) # 80003e6e <namei>
    80004d5a:	cd25                	beqz	a0,80004dd2 <exec+0xc8>
    80004d5c:	8aaa                	mv	s5,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	986080e7          	jalr	-1658(ra) # 800036e4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d66:	04000713          	li	a4,64
    80004d6a:	4681                	li	a3,0
    80004d6c:	e4840613          	addi	a2,s0,-440
    80004d70:	4581                	li	a1,0
    80004d72:	8556                	mv	a0,s5
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	c00080e7          	jalr	-1024(ra) # 80003974 <readi>
    80004d7c:	04000793          	li	a5,64
    80004d80:	00f51a63          	bne	a0,a5,80004d94 <exec+0x8a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004d84:	e4842703          	lw	a4,-440(s0)
    80004d88:	464c47b7          	lui	a5,0x464c4
    80004d8c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d90:	04f70863          	beq	a4,a5,80004de0 <exec+0xd6>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d94:	8556                	mv	a0,s5
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	b8c080e7          	jalr	-1140(ra) # 80003922 <iunlockput>
    end_op(ROOTDEV);
    80004d9e:	4501                	li	a0,0
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	3d4080e7          	jalr	980(ra) # 80004174 <end_op>
  }
  return -1;
    80004da8:	557d                	li	a0,-1
}
    80004daa:	21813083          	ld	ra,536(sp)
    80004dae:	21013403          	ld	s0,528(sp)
    80004db2:	20813483          	ld	s1,520(sp)
    80004db6:	20013903          	ld	s2,512(sp)
    80004dba:	79fe                	ld	s3,504(sp)
    80004dbc:	7a5e                	ld	s4,496(sp)
    80004dbe:	7abe                	ld	s5,488(sp)
    80004dc0:	7b1e                	ld	s6,480(sp)
    80004dc2:	6bfe                	ld	s7,472(sp)
    80004dc4:	6c5e                	ld	s8,464(sp)
    80004dc6:	6cbe                	ld	s9,456(sp)
    80004dc8:	6d1e                	ld	s10,448(sp)
    80004dca:	7dfa                	ld	s11,440(sp)
    80004dcc:	22010113          	addi	sp,sp,544
    80004dd0:	8082                	ret
    end_op(ROOTDEV);
    80004dd2:	4501                	li	a0,0
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	3a0080e7          	jalr	928(ra) # 80004174 <end_op>
    return -1;
    80004ddc:	557d                	li	a0,-1
    80004dde:	b7f1                	j	80004daa <exec+0xa0>
  if((pagetable = proc_pagetable(p)) == 0)
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffd097          	auipc	ra,0xffffd
    80004de6:	d3a080e7          	jalr	-710(ra) # 80001b1c <proc_pagetable>
    80004dea:	8b2a                	mv	s6,a0
    80004dec:	d545                	beqz	a0,80004d94 <exec+0x8a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dee:	e6842783          	lw	a5,-408(s0)
    80004df2:	e8045703          	lhu	a4,-384(s0)
    80004df6:	10070263          	beqz	a4,80004efa <exec+0x1f0>
  sz = 0;
    80004dfa:	de043c23          	sd	zero,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dfe:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004e02:	6a05                	lui	s4,0x1
    80004e04:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004e08:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004e0c:	6d85                	lui	s11,0x1
    80004e0e:	7d7d                	lui	s10,0xfffff
    80004e10:	a88d                	j	80004e82 <exec+0x178>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004e12:	00004517          	auipc	a0,0x4
    80004e16:	c4650513          	addi	a0,a0,-954 # 80008a58 <userret+0x9c8>
    80004e1a:	ffffb097          	auipc	ra,0xffffb
    80004e1e:	73a080e7          	jalr	1850(ra) # 80000554 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e22:	874a                	mv	a4,s2
    80004e24:	009c86bb          	addw	a3,s9,s1
    80004e28:	4581                	li	a1,0
    80004e2a:	8556                	mv	a0,s5
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	b48080e7          	jalr	-1208(ra) # 80003974 <readi>
    80004e34:	2501                	sext.w	a0,a0
    80004e36:	10a91863          	bne	s2,a0,80004f46 <exec+0x23c>
  for(i = 0; i < sz; i += PGSIZE){
    80004e3a:	009d84bb          	addw	s1,s11,s1
    80004e3e:	013d09bb          	addw	s3,s10,s3
    80004e42:	0374f263          	bgeu	s1,s7,80004e66 <exec+0x15c>
    pa = walkaddr(pagetable, va + i);
    80004e46:	02049593          	slli	a1,s1,0x20
    80004e4a:	9181                	srli	a1,a1,0x20
    80004e4c:	95e2                	add	a1,a1,s8
    80004e4e:	855a                	mv	a0,s6
    80004e50:	ffffc097          	auipc	ra,0xffffc
    80004e54:	318080e7          	jalr	792(ra) # 80001168 <walkaddr>
    80004e58:	862a                	mv	a2,a0
    if(pa == 0)
    80004e5a:	dd45                	beqz	a0,80004e12 <exec+0x108>
      n = PGSIZE;
    80004e5c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004e5e:	fd49f2e3          	bgeu	s3,s4,80004e22 <exec+0x118>
      n = sz - i;
    80004e62:	894e                	mv	s2,s3
    80004e64:	bf7d                	j	80004e22 <exec+0x118>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e66:	e0843783          	ld	a5,-504(s0)
    80004e6a:	0017869b          	addiw	a3,a5,1
    80004e6e:	e0d43423          	sd	a3,-504(s0)
    80004e72:	e0043783          	ld	a5,-512(s0)
    80004e76:	0387879b          	addiw	a5,a5,56
    80004e7a:	e8045703          	lhu	a4,-384(s0)
    80004e7e:	08e6d063          	bge	a3,a4,80004efe <exec+0x1f4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e82:	2781                	sext.w	a5,a5
    80004e84:	e0f43023          	sd	a5,-512(s0)
    80004e88:	03800713          	li	a4,56
    80004e8c:	86be                	mv	a3,a5
    80004e8e:	e1040613          	addi	a2,s0,-496
    80004e92:	4581                	li	a1,0
    80004e94:	8556                	mv	a0,s5
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	ade080e7          	jalr	-1314(ra) # 80003974 <readi>
    80004e9e:	03800793          	li	a5,56
    80004ea2:	0af51263          	bne	a0,a5,80004f46 <exec+0x23c>
    if(ph.type != ELF_PROG_LOAD)
    80004ea6:	e1042783          	lw	a5,-496(s0)
    80004eaa:	4705                	li	a4,1
    80004eac:	fae79de3          	bne	a5,a4,80004e66 <exec+0x15c>
    if(ph.memsz < ph.filesz)
    80004eb0:	e3843603          	ld	a2,-456(s0)
    80004eb4:	e3043783          	ld	a5,-464(s0)
    80004eb8:	08f66763          	bltu	a2,a5,80004f46 <exec+0x23c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ebc:	e2043783          	ld	a5,-480(s0)
    80004ec0:	963e                	add	a2,a2,a5
    80004ec2:	08f66263          	bltu	a2,a5,80004f46 <exec+0x23c>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004ec6:	df843583          	ld	a1,-520(s0)
    80004eca:	855a                	mv	a0,s6
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	6a4080e7          	jalr	1700(ra) # 80001570 <uvmalloc>
    80004ed4:	dea43c23          	sd	a0,-520(s0)
    80004ed8:	c53d                	beqz	a0,80004f46 <exec+0x23c>
    if(ph.vaddr % PGSIZE != 0)
    80004eda:	e2043c03          	ld	s8,-480(s0)
    80004ede:	de043783          	ld	a5,-544(s0)
    80004ee2:	00fc77b3          	and	a5,s8,a5
    80004ee6:	e3a5                	bnez	a5,80004f46 <exec+0x23c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ee8:	e1842c83          	lw	s9,-488(s0)
    80004eec:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ef0:	f60b8be3          	beqz	s7,80004e66 <exec+0x15c>
    80004ef4:	89de                	mv	s3,s7
    80004ef6:	4481                	li	s1,0
    80004ef8:	b7b9                	j	80004e46 <exec+0x13c>
  sz = 0;
    80004efa:	de043c23          	sd	zero,-520(s0)
  iunlockput(ip);
    80004efe:	8556                	mv	a0,s5
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	a22080e7          	jalr	-1502(ra) # 80003922 <iunlockput>
  end_op(ROOTDEV);
    80004f08:	4501                	li	a0,0
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	26a080e7          	jalr	618(ra) # 80004174 <end_op>
  p = myproc();
    80004f12:	ffffd097          	auipc	ra,0xffffd
    80004f16:	b46080e7          	jalr	-1210(ra) # 80001a58 <myproc>
    80004f1a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004f1c:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004f20:	6585                	lui	a1,0x1
    80004f22:	15fd                	addi	a1,a1,-1
    80004f24:	df843783          	ld	a5,-520(s0)
    80004f28:	95be                	add	a1,a1,a5
    80004f2a:	77fd                	lui	a5,0xfffff
    80004f2c:	8dfd                	and	a1,a1,a5
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f2e:	6609                	lui	a2,0x2
    80004f30:	962e                	add	a2,a2,a1
    80004f32:	855a                	mv	a0,s6
    80004f34:	ffffc097          	auipc	ra,0xffffc
    80004f38:	63c080e7          	jalr	1596(ra) # 80001570 <uvmalloc>
    80004f3c:	892a                	mv	s2,a0
    80004f3e:	dea43c23          	sd	a0,-520(s0)
  ip = 0;
    80004f42:	4a81                	li	s5,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f44:	ed01                	bnez	a0,80004f5c <exec+0x252>
    proc_freepagetable(pagetable, sz);
    80004f46:	df843583          	ld	a1,-520(s0)
    80004f4a:	855a                	mv	a0,s6
    80004f4c:	ffffd097          	auipc	ra,0xffffd
    80004f50:	cd0080e7          	jalr	-816(ra) # 80001c1c <proc_freepagetable>
  if(ip){
    80004f54:	e40a90e3          	bnez	s5,80004d94 <exec+0x8a>
  return -1;
    80004f58:	557d                	li	a0,-1
    80004f5a:	bd81                	j	80004daa <exec+0xa0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f5c:	75f9                	lui	a1,0xffffe
    80004f5e:	95aa                	add	a1,a1,a0
    80004f60:	855a                	mv	a0,s6
    80004f62:	ffffc097          	auipc	ra,0xffffc
    80004f66:	7b6080e7          	jalr	1974(ra) # 80001718 <uvmclear>
  stackbase = sp - PGSIZE;
    80004f6a:	7c7d                	lui	s8,0xfffff
    80004f6c:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80004f6e:	df043783          	ld	a5,-528(s0)
    80004f72:	6388                	ld	a0,0(a5)
    80004f74:	c52d                	beqz	a0,80004fde <exec+0x2d4>
    80004f76:	e8840993          	addi	s3,s0,-376
    80004f7a:	f8840a93          	addi	s5,s0,-120
    80004f7e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	f72080e7          	jalr	-142(ra) # 80000ef2 <strlen>
    80004f88:	0015079b          	addiw	a5,a0,1
    80004f8c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f90:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004f94:	0f896b63          	bltu	s2,s8,8000508a <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f98:	df043d03          	ld	s10,-528(s0)
    80004f9c:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd6fa4>
    80004fa0:	8552                	mv	a0,s4
    80004fa2:	ffffc097          	auipc	ra,0xffffc
    80004fa6:	f50080e7          	jalr	-176(ra) # 80000ef2 <strlen>
    80004faa:	0015069b          	addiw	a3,a0,1
    80004fae:	8652                	mv	a2,s4
    80004fb0:	85ca                	mv	a1,s2
    80004fb2:	855a                	mv	a0,s6
    80004fb4:	ffffc097          	auipc	ra,0xffffc
    80004fb8:	796080e7          	jalr	1942(ra) # 8000174a <copyout>
    80004fbc:	0c054963          	bltz	a0,8000508e <exec+0x384>
    ustack[argc] = sp;
    80004fc0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004fc4:	0485                	addi	s1,s1,1
    80004fc6:	008d0793          	addi	a5,s10,8
    80004fca:	def43823          	sd	a5,-528(s0)
    80004fce:	008d3503          	ld	a0,8(s10)
    80004fd2:	c909                	beqz	a0,80004fe4 <exec+0x2da>
    if(argc >= MAXARG)
    80004fd4:	09a1                	addi	s3,s3,8
    80004fd6:	fb3a95e3          	bne	s5,s3,80004f80 <exec+0x276>
  ip = 0;
    80004fda:	4a81                	li	s5,0
    80004fdc:	b7ad                	j	80004f46 <exec+0x23c>
  sp = sz;
    80004fde:	df843903          	ld	s2,-520(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004fe2:	4481                	li	s1,0
  ustack[argc] = 0;
    80004fe4:	00349793          	slli	a5,s1,0x3
    80004fe8:	f9040713          	addi	a4,s0,-112
    80004fec:	97ba                	add	a5,a5,a4
    80004fee:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd6e9c>
  sp -= (argc+1) * sizeof(uint64);
    80004ff2:	00148693          	addi	a3,s1,1
    80004ff6:	068e                	slli	a3,a3,0x3
    80004ff8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ffc:	ff097913          	andi	s2,s2,-16
  ip = 0;
    80005000:	4a81                	li	s5,0
  if(sp < stackbase)
    80005002:	f58962e3          	bltu	s2,s8,80004f46 <exec+0x23c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005006:	e8840613          	addi	a2,s0,-376
    8000500a:	85ca                	mv	a1,s2
    8000500c:	855a                	mv	a0,s6
    8000500e:	ffffc097          	auipc	ra,0xffffc
    80005012:	73c080e7          	jalr	1852(ra) # 8000174a <copyout>
    80005016:	06054e63          	bltz	a0,80005092 <exec+0x388>
  p->tf->a1 = sp;
    8000501a:	060bb783          	ld	a5,96(s7)
    8000501e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005022:	de843783          	ld	a5,-536(s0)
    80005026:	0007c703          	lbu	a4,0(a5)
    8000502a:	cf11                	beqz	a4,80005046 <exec+0x33c>
    8000502c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000502e:	02f00693          	li	a3,47
    80005032:	a039                	j	80005040 <exec+0x336>
      last = s+1;
    80005034:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005038:	0785                	addi	a5,a5,1
    8000503a:	fff7c703          	lbu	a4,-1(a5)
    8000503e:	c701                	beqz	a4,80005046 <exec+0x33c>
    if(*s == '/')
    80005040:	fed71ce3          	bne	a4,a3,80005038 <exec+0x32e>
    80005044:	bfc5                	j	80005034 <exec+0x32a>
  safestrcpy(p->name, last, sizeof(p->name));
    80005046:	4641                	li	a2,16
    80005048:	de843583          	ld	a1,-536(s0)
    8000504c:	160b8513          	addi	a0,s7,352
    80005050:	ffffc097          	auipc	ra,0xffffc
    80005054:	e70080e7          	jalr	-400(ra) # 80000ec0 <safestrcpy>
  oldpagetable = p->pagetable;
    80005058:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    8000505c:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    80005060:	df843783          	ld	a5,-520(s0)
    80005064:	04fbb823          	sd	a5,80(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80005068:	060bb783          	ld	a5,96(s7)
    8000506c:	e6043703          	ld	a4,-416(s0)
    80005070:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80005072:	060bb783          	ld	a5,96(s7)
    80005076:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000507a:	85e6                	mv	a1,s9
    8000507c:	ffffd097          	auipc	ra,0xffffd
    80005080:	ba0080e7          	jalr	-1120(ra) # 80001c1c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005084:	0004851b          	sext.w	a0,s1
    80005088:	b30d                	j	80004daa <exec+0xa0>
  ip = 0;
    8000508a:	4a81                	li	s5,0
    8000508c:	bd6d                	j	80004f46 <exec+0x23c>
    8000508e:	4a81                	li	s5,0
    80005090:	bd5d                	j	80004f46 <exec+0x23c>
    80005092:	4a81                	li	s5,0
    80005094:	bd4d                	j	80004f46 <exec+0x23c>

0000000080005096 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005096:	7179                	addi	sp,sp,-48
    80005098:	f406                	sd	ra,40(sp)
    8000509a:	f022                	sd	s0,32(sp)
    8000509c:	ec26                	sd	s1,24(sp)
    8000509e:	e84a                	sd	s2,16(sp)
    800050a0:	1800                	addi	s0,sp,48
    800050a2:	892e                	mv	s2,a1
    800050a4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800050a6:	fdc40593          	addi	a1,s0,-36
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	ac4080e7          	jalr	-1340(ra) # 80002b6e <argint>
    800050b2:	04054063          	bltz	a0,800050f2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050b6:	fdc42703          	lw	a4,-36(s0)
    800050ba:	47bd                	li	a5,15
    800050bc:	02e7ed63          	bltu	a5,a4,800050f6 <argfd+0x60>
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	998080e7          	jalr	-1640(ra) # 80001a58 <myproc>
    800050c8:	fdc42703          	lw	a4,-36(s0)
    800050cc:	01a70793          	addi	a5,a4,26
    800050d0:	078e                	slli	a5,a5,0x3
    800050d2:	953e                	add	a0,a0,a5
    800050d4:	651c                	ld	a5,8(a0)
    800050d6:	c395                	beqz	a5,800050fa <argfd+0x64>
    return -1;
  if(pfd)
    800050d8:	00090463          	beqz	s2,800050e0 <argfd+0x4a>
    *pfd = fd;
    800050dc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050e0:	4501                	li	a0,0
  if(pf)
    800050e2:	c091                	beqz	s1,800050e6 <argfd+0x50>
    *pf = f;
    800050e4:	e09c                	sd	a5,0(s1)
}
    800050e6:	70a2                	ld	ra,40(sp)
    800050e8:	7402                	ld	s0,32(sp)
    800050ea:	64e2                	ld	s1,24(sp)
    800050ec:	6942                	ld	s2,16(sp)
    800050ee:	6145                	addi	sp,sp,48
    800050f0:	8082                	ret
    return -1;
    800050f2:	557d                	li	a0,-1
    800050f4:	bfcd                	j	800050e6 <argfd+0x50>
    return -1;
    800050f6:	557d                	li	a0,-1
    800050f8:	b7fd                	j	800050e6 <argfd+0x50>
    800050fa:	557d                	li	a0,-1
    800050fc:	b7ed                	j	800050e6 <argfd+0x50>

00000000800050fe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050fe:	1101                	addi	sp,sp,-32
    80005100:	ec06                	sd	ra,24(sp)
    80005102:	e822                	sd	s0,16(sp)
    80005104:	e426                	sd	s1,8(sp)
    80005106:	1000                	addi	s0,sp,32
    80005108:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000510a:	ffffd097          	auipc	ra,0xffffd
    8000510e:	94e080e7          	jalr	-1714(ra) # 80001a58 <myproc>
    80005112:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005114:	0d850793          	addi	a5,a0,216
    80005118:	4501                	li	a0,0
    8000511a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000511c:	6398                	ld	a4,0(a5)
    8000511e:	cb19                	beqz	a4,80005134 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005120:	2505                	addiw	a0,a0,1
    80005122:	07a1                	addi	a5,a5,8
    80005124:	fed51ce3          	bne	a0,a3,8000511c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005128:	557d                	li	a0,-1
}
    8000512a:	60e2                	ld	ra,24(sp)
    8000512c:	6442                	ld	s0,16(sp)
    8000512e:	64a2                	ld	s1,8(sp)
    80005130:	6105                	addi	sp,sp,32
    80005132:	8082                	ret
      p->ofile[fd] = f;
    80005134:	01a50793          	addi	a5,a0,26
    80005138:	078e                	slli	a5,a5,0x3
    8000513a:	963e                	add	a2,a2,a5
    8000513c:	e604                	sd	s1,8(a2)
      return fd;
    8000513e:	b7f5                	j	8000512a <fdalloc+0x2c>

0000000080005140 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005140:	715d                	addi	sp,sp,-80
    80005142:	e486                	sd	ra,72(sp)
    80005144:	e0a2                	sd	s0,64(sp)
    80005146:	fc26                	sd	s1,56(sp)
    80005148:	f84a                	sd	s2,48(sp)
    8000514a:	f44e                	sd	s3,40(sp)
    8000514c:	f052                	sd	s4,32(sp)
    8000514e:	ec56                	sd	s5,24(sp)
    80005150:	0880                	addi	s0,sp,80
    80005152:	89ae                	mv	s3,a1
    80005154:	8ab2                	mv	s5,a2
    80005156:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005158:	fb040593          	addi	a1,s0,-80
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	d30080e7          	jalr	-720(ra) # 80003e8c <nameiparent>
    80005164:	892a                	mv	s2,a0
    80005166:	12050e63          	beqz	a0,800052a2 <create+0x162>
    return 0;

  ilock(dp);
    8000516a:	ffffe097          	auipc	ra,0xffffe
    8000516e:	57a080e7          	jalr	1402(ra) # 800036e4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005172:	4601                	li	a2,0
    80005174:	fb040593          	addi	a1,s0,-80
    80005178:	854a                	mv	a0,s2
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	a22080e7          	jalr	-1502(ra) # 80003b9c <dirlookup>
    80005182:	84aa                	mv	s1,a0
    80005184:	c921                	beqz	a0,800051d4 <create+0x94>
    iunlockput(dp);
    80005186:	854a                	mv	a0,s2
    80005188:	ffffe097          	auipc	ra,0xffffe
    8000518c:	79a080e7          	jalr	1946(ra) # 80003922 <iunlockput>
    ilock(ip);
    80005190:	8526                	mv	a0,s1
    80005192:	ffffe097          	auipc	ra,0xffffe
    80005196:	552080e7          	jalr	1362(ra) # 800036e4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000519a:	2981                	sext.w	s3,s3
    8000519c:	4789                	li	a5,2
    8000519e:	02f99463          	bne	s3,a5,800051c6 <create+0x86>
    800051a2:	04c4d783          	lhu	a5,76(s1)
    800051a6:	37f9                	addiw	a5,a5,-2
    800051a8:	17c2                	slli	a5,a5,0x30
    800051aa:	93c1                	srli	a5,a5,0x30
    800051ac:	4705                	li	a4,1
    800051ae:	00f76c63          	bltu	a4,a5,800051c6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800051b2:	8526                	mv	a0,s1
    800051b4:	60a6                	ld	ra,72(sp)
    800051b6:	6406                	ld	s0,64(sp)
    800051b8:	74e2                	ld	s1,56(sp)
    800051ba:	7942                	ld	s2,48(sp)
    800051bc:	79a2                	ld	s3,40(sp)
    800051be:	7a02                	ld	s4,32(sp)
    800051c0:	6ae2                	ld	s5,24(sp)
    800051c2:	6161                	addi	sp,sp,80
    800051c4:	8082                	ret
    iunlockput(ip);
    800051c6:	8526                	mv	a0,s1
    800051c8:	ffffe097          	auipc	ra,0xffffe
    800051cc:	75a080e7          	jalr	1882(ra) # 80003922 <iunlockput>
    return 0;
    800051d0:	4481                	li	s1,0
    800051d2:	b7c5                	j	800051b2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800051d4:	85ce                	mv	a1,s3
    800051d6:	00092503          	lw	a0,0(s2)
    800051da:	ffffe097          	auipc	ra,0xffffe
    800051de:	372080e7          	jalr	882(ra) # 8000354c <ialloc>
    800051e2:	84aa                	mv	s1,a0
    800051e4:	c521                	beqz	a0,8000522c <create+0xec>
  ilock(ip);
    800051e6:	ffffe097          	auipc	ra,0xffffe
    800051ea:	4fe080e7          	jalr	1278(ra) # 800036e4 <ilock>
  ip->major = major;
    800051ee:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    800051f2:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800051f6:	4a05                	li	s4,1
    800051f8:	05449923          	sh	s4,82(s1)
  iupdate(ip);
    800051fc:	8526                	mv	a0,s1
    800051fe:	ffffe097          	auipc	ra,0xffffe
    80005202:	41c080e7          	jalr	1052(ra) # 8000361a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005206:	2981                	sext.w	s3,s3
    80005208:	03498a63          	beq	s3,s4,8000523c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000520c:	40d0                	lw	a2,4(s1)
    8000520e:	fb040593          	addi	a1,s0,-80
    80005212:	854a                	mv	a0,s2
    80005214:	fffff097          	auipc	ra,0xfffff
    80005218:	b98080e7          	jalr	-1128(ra) # 80003dac <dirlink>
    8000521c:	06054b63          	bltz	a0,80005292 <create+0x152>
  iunlockput(dp);
    80005220:	854a                	mv	a0,s2
    80005222:	ffffe097          	auipc	ra,0xffffe
    80005226:	700080e7          	jalr	1792(ra) # 80003922 <iunlockput>
  return ip;
    8000522a:	b761                	j	800051b2 <create+0x72>
    panic("create: ialloc");
    8000522c:	00004517          	auipc	a0,0x4
    80005230:	84c50513          	addi	a0,a0,-1972 # 80008a78 <userret+0x9e8>
    80005234:	ffffb097          	auipc	ra,0xffffb
    80005238:	320080e7          	jalr	800(ra) # 80000554 <panic>
    dp->nlink++;  // for ".."
    8000523c:	05295783          	lhu	a5,82(s2)
    80005240:	2785                	addiw	a5,a5,1
    80005242:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    80005246:	854a                	mv	a0,s2
    80005248:	ffffe097          	auipc	ra,0xffffe
    8000524c:	3d2080e7          	jalr	978(ra) # 8000361a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005250:	40d0                	lw	a2,4(s1)
    80005252:	00004597          	auipc	a1,0x4
    80005256:	83658593          	addi	a1,a1,-1994 # 80008a88 <userret+0x9f8>
    8000525a:	8526                	mv	a0,s1
    8000525c:	fffff097          	auipc	ra,0xfffff
    80005260:	b50080e7          	jalr	-1200(ra) # 80003dac <dirlink>
    80005264:	00054f63          	bltz	a0,80005282 <create+0x142>
    80005268:	00492603          	lw	a2,4(s2)
    8000526c:	00004597          	auipc	a1,0x4
    80005270:	82458593          	addi	a1,a1,-2012 # 80008a90 <userret+0xa00>
    80005274:	8526                	mv	a0,s1
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	b36080e7          	jalr	-1226(ra) # 80003dac <dirlink>
    8000527e:	f80557e3          	bgez	a0,8000520c <create+0xcc>
      panic("create dots");
    80005282:	00004517          	auipc	a0,0x4
    80005286:	81650513          	addi	a0,a0,-2026 # 80008a98 <userret+0xa08>
    8000528a:	ffffb097          	auipc	ra,0xffffb
    8000528e:	2ca080e7          	jalr	714(ra) # 80000554 <panic>
    panic("create: dirlink");
    80005292:	00004517          	auipc	a0,0x4
    80005296:	81650513          	addi	a0,a0,-2026 # 80008aa8 <userret+0xa18>
    8000529a:	ffffb097          	auipc	ra,0xffffb
    8000529e:	2ba080e7          	jalr	698(ra) # 80000554 <panic>
    return 0;
    800052a2:	84aa                	mv	s1,a0
    800052a4:	b739                	j	800051b2 <create+0x72>

00000000800052a6 <sys_dup>:
{
    800052a6:	7179                	addi	sp,sp,-48
    800052a8:	f406                	sd	ra,40(sp)
    800052aa:	f022                	sd	s0,32(sp)
    800052ac:	ec26                	sd	s1,24(sp)
    800052ae:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052b0:	fd840613          	addi	a2,s0,-40
    800052b4:	4581                	li	a1,0
    800052b6:	4501                	li	a0,0
    800052b8:	00000097          	auipc	ra,0x0
    800052bc:	dde080e7          	jalr	-546(ra) # 80005096 <argfd>
    return -1;
    800052c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052c2:	02054363          	bltz	a0,800052e8 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800052c6:	fd843503          	ld	a0,-40(s0)
    800052ca:	00000097          	auipc	ra,0x0
    800052ce:	e34080e7          	jalr	-460(ra) # 800050fe <fdalloc>
    800052d2:	84aa                	mv	s1,a0
    return -1;
    800052d4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052d6:	00054963          	bltz	a0,800052e8 <sys_dup+0x42>
  filedup(f);
    800052da:	fd843503          	ld	a0,-40(s0)
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	334080e7          	jalr	820(ra) # 80004612 <filedup>
  return fd;
    800052e6:	87a6                	mv	a5,s1
}
    800052e8:	853e                	mv	a0,a5
    800052ea:	70a2                	ld	ra,40(sp)
    800052ec:	7402                	ld	s0,32(sp)
    800052ee:	64e2                	ld	s1,24(sp)
    800052f0:	6145                	addi	sp,sp,48
    800052f2:	8082                	ret

00000000800052f4 <sys_read>:
{
    800052f4:	7179                	addi	sp,sp,-48
    800052f6:	f406                	sd	ra,40(sp)
    800052f8:	f022                	sd	s0,32(sp)
    800052fa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052fc:	fe840613          	addi	a2,s0,-24
    80005300:	4581                	li	a1,0
    80005302:	4501                	li	a0,0
    80005304:	00000097          	auipc	ra,0x0
    80005308:	d92080e7          	jalr	-622(ra) # 80005096 <argfd>
    return -1;
    8000530c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000530e:	04054163          	bltz	a0,80005350 <sys_read+0x5c>
    80005312:	fe440593          	addi	a1,s0,-28
    80005316:	4509                	li	a0,2
    80005318:	ffffe097          	auipc	ra,0xffffe
    8000531c:	856080e7          	jalr	-1962(ra) # 80002b6e <argint>
    return -1;
    80005320:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005322:	02054763          	bltz	a0,80005350 <sys_read+0x5c>
    80005326:	fd840593          	addi	a1,s0,-40
    8000532a:	4505                	li	a0,1
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	864080e7          	jalr	-1948(ra) # 80002b90 <argaddr>
    return -1;
    80005334:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005336:	00054d63          	bltz	a0,80005350 <sys_read+0x5c>
  return fileread(f, p, n);
    8000533a:	fe442603          	lw	a2,-28(s0)
    8000533e:	fd843583          	ld	a1,-40(s0)
    80005342:	fe843503          	ld	a0,-24(s0)
    80005346:	fffff097          	auipc	ra,0xfffff
    8000534a:	460080e7          	jalr	1120(ra) # 800047a6 <fileread>
    8000534e:	87aa                	mv	a5,a0
}
    80005350:	853e                	mv	a0,a5
    80005352:	70a2                	ld	ra,40(sp)
    80005354:	7402                	ld	s0,32(sp)
    80005356:	6145                	addi	sp,sp,48
    80005358:	8082                	ret

000000008000535a <sys_write>:
{
    8000535a:	7179                	addi	sp,sp,-48
    8000535c:	f406                	sd	ra,40(sp)
    8000535e:	f022                	sd	s0,32(sp)
    80005360:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005362:	fe840613          	addi	a2,s0,-24
    80005366:	4581                	li	a1,0
    80005368:	4501                	li	a0,0
    8000536a:	00000097          	auipc	ra,0x0
    8000536e:	d2c080e7          	jalr	-724(ra) # 80005096 <argfd>
    return -1;
    80005372:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005374:	04054163          	bltz	a0,800053b6 <sys_write+0x5c>
    80005378:	fe440593          	addi	a1,s0,-28
    8000537c:	4509                	li	a0,2
    8000537e:	ffffd097          	auipc	ra,0xffffd
    80005382:	7f0080e7          	jalr	2032(ra) # 80002b6e <argint>
    return -1;
    80005386:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005388:	02054763          	bltz	a0,800053b6 <sys_write+0x5c>
    8000538c:	fd840593          	addi	a1,s0,-40
    80005390:	4505                	li	a0,1
    80005392:	ffffd097          	auipc	ra,0xffffd
    80005396:	7fe080e7          	jalr	2046(ra) # 80002b90 <argaddr>
    return -1;
    8000539a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000539c:	00054d63          	bltz	a0,800053b6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800053a0:	fe442603          	lw	a2,-28(s0)
    800053a4:	fd843583          	ld	a1,-40(s0)
    800053a8:	fe843503          	ld	a0,-24(s0)
    800053ac:	fffff097          	auipc	ra,0xfffff
    800053b0:	4c0080e7          	jalr	1216(ra) # 8000486c <filewrite>
    800053b4:	87aa                	mv	a5,a0
}
    800053b6:	853e                	mv	a0,a5
    800053b8:	70a2                	ld	ra,40(sp)
    800053ba:	7402                	ld	s0,32(sp)
    800053bc:	6145                	addi	sp,sp,48
    800053be:	8082                	ret

00000000800053c0 <sys_close>:
{
    800053c0:	1101                	addi	sp,sp,-32
    800053c2:	ec06                	sd	ra,24(sp)
    800053c4:	e822                	sd	s0,16(sp)
    800053c6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053c8:	fe040613          	addi	a2,s0,-32
    800053cc:	fec40593          	addi	a1,s0,-20
    800053d0:	4501                	li	a0,0
    800053d2:	00000097          	auipc	ra,0x0
    800053d6:	cc4080e7          	jalr	-828(ra) # 80005096 <argfd>
    return -1;
    800053da:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053dc:	02054463          	bltz	a0,80005404 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053e0:	ffffc097          	auipc	ra,0xffffc
    800053e4:	678080e7          	jalr	1656(ra) # 80001a58 <myproc>
    800053e8:	fec42783          	lw	a5,-20(s0)
    800053ec:	07e9                	addi	a5,a5,26
    800053ee:	078e                	slli	a5,a5,0x3
    800053f0:	97aa                	add	a5,a5,a0
    800053f2:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800053f6:	fe043503          	ld	a0,-32(s0)
    800053fa:	fffff097          	auipc	ra,0xfffff
    800053fe:	26a080e7          	jalr	618(ra) # 80004664 <fileclose>
  return 0;
    80005402:	4781                	li	a5,0
}
    80005404:	853e                	mv	a0,a5
    80005406:	60e2                	ld	ra,24(sp)
    80005408:	6442                	ld	s0,16(sp)
    8000540a:	6105                	addi	sp,sp,32
    8000540c:	8082                	ret

000000008000540e <sys_fstat>:
{
    8000540e:	1101                	addi	sp,sp,-32
    80005410:	ec06                	sd	ra,24(sp)
    80005412:	e822                	sd	s0,16(sp)
    80005414:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005416:	fe840613          	addi	a2,s0,-24
    8000541a:	4581                	li	a1,0
    8000541c:	4501                	li	a0,0
    8000541e:	00000097          	auipc	ra,0x0
    80005422:	c78080e7          	jalr	-904(ra) # 80005096 <argfd>
    return -1;
    80005426:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005428:	02054563          	bltz	a0,80005452 <sys_fstat+0x44>
    8000542c:	fe040593          	addi	a1,s0,-32
    80005430:	4505                	li	a0,1
    80005432:	ffffd097          	auipc	ra,0xffffd
    80005436:	75e080e7          	jalr	1886(ra) # 80002b90 <argaddr>
    return -1;
    8000543a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000543c:	00054b63          	bltz	a0,80005452 <sys_fstat+0x44>
  return filestat(f, st);
    80005440:	fe043583          	ld	a1,-32(s0)
    80005444:	fe843503          	ld	a0,-24(s0)
    80005448:	fffff097          	auipc	ra,0xfffff
    8000544c:	2ec080e7          	jalr	748(ra) # 80004734 <filestat>
    80005450:	87aa                	mv	a5,a0
}
    80005452:	853e                	mv	a0,a5
    80005454:	60e2                	ld	ra,24(sp)
    80005456:	6442                	ld	s0,16(sp)
    80005458:	6105                	addi	sp,sp,32
    8000545a:	8082                	ret

000000008000545c <sys_link>:
{
    8000545c:	7169                	addi	sp,sp,-304
    8000545e:	f606                	sd	ra,296(sp)
    80005460:	f222                	sd	s0,288(sp)
    80005462:	ee26                	sd	s1,280(sp)
    80005464:	ea4a                	sd	s2,272(sp)
    80005466:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005468:	08000613          	li	a2,128
    8000546c:	ed040593          	addi	a1,s0,-304
    80005470:	4501                	li	a0,0
    80005472:	ffffd097          	auipc	ra,0xffffd
    80005476:	740080e7          	jalr	1856(ra) # 80002bb2 <argstr>
    return -1;
    8000547a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000547c:	12054363          	bltz	a0,800055a2 <sys_link+0x146>
    80005480:	08000613          	li	a2,128
    80005484:	f5040593          	addi	a1,s0,-176
    80005488:	4505                	li	a0,1
    8000548a:	ffffd097          	auipc	ra,0xffffd
    8000548e:	728080e7          	jalr	1832(ra) # 80002bb2 <argstr>
    return -1;
    80005492:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005494:	10054763          	bltz	a0,800055a2 <sys_link+0x146>
  begin_op(ROOTDEV);
    80005498:	4501                	li	a0,0
    8000549a:	fffff097          	auipc	ra,0xfffff
    8000549e:	c30080e7          	jalr	-976(ra) # 800040ca <begin_op>
  if((ip = namei(old)) == 0){
    800054a2:	ed040513          	addi	a0,s0,-304
    800054a6:	fffff097          	auipc	ra,0xfffff
    800054aa:	9c8080e7          	jalr	-1592(ra) # 80003e6e <namei>
    800054ae:	84aa                	mv	s1,a0
    800054b0:	c559                	beqz	a0,8000553e <sys_link+0xe2>
  ilock(ip);
    800054b2:	ffffe097          	auipc	ra,0xffffe
    800054b6:	232080e7          	jalr	562(ra) # 800036e4 <ilock>
  if(ip->type == T_DIR){
    800054ba:	04c49703          	lh	a4,76(s1)
    800054be:	4785                	li	a5,1
    800054c0:	08f70663          	beq	a4,a5,8000554c <sys_link+0xf0>
  ip->nlink++;
    800054c4:	0524d783          	lhu	a5,82(s1)
    800054c8:	2785                	addiw	a5,a5,1
    800054ca:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    800054ce:	8526                	mv	a0,s1
    800054d0:	ffffe097          	auipc	ra,0xffffe
    800054d4:	14a080e7          	jalr	330(ra) # 8000361a <iupdate>
  iunlock(ip);
    800054d8:	8526                	mv	a0,s1
    800054da:	ffffe097          	auipc	ra,0xffffe
    800054de:	2cc080e7          	jalr	716(ra) # 800037a6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054e2:	fd040593          	addi	a1,s0,-48
    800054e6:	f5040513          	addi	a0,s0,-176
    800054ea:	fffff097          	auipc	ra,0xfffff
    800054ee:	9a2080e7          	jalr	-1630(ra) # 80003e8c <nameiparent>
    800054f2:	892a                	mv	s2,a0
    800054f4:	cd2d                	beqz	a0,8000556e <sys_link+0x112>
  ilock(dp);
    800054f6:	ffffe097          	auipc	ra,0xffffe
    800054fa:	1ee080e7          	jalr	494(ra) # 800036e4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054fe:	00092703          	lw	a4,0(s2)
    80005502:	409c                	lw	a5,0(s1)
    80005504:	06f71063          	bne	a4,a5,80005564 <sys_link+0x108>
    80005508:	40d0                	lw	a2,4(s1)
    8000550a:	fd040593          	addi	a1,s0,-48
    8000550e:	854a                	mv	a0,s2
    80005510:	fffff097          	auipc	ra,0xfffff
    80005514:	89c080e7          	jalr	-1892(ra) # 80003dac <dirlink>
    80005518:	04054663          	bltz	a0,80005564 <sys_link+0x108>
  iunlockput(dp);
    8000551c:	854a                	mv	a0,s2
    8000551e:	ffffe097          	auipc	ra,0xffffe
    80005522:	404080e7          	jalr	1028(ra) # 80003922 <iunlockput>
  iput(ip);
    80005526:	8526                	mv	a0,s1
    80005528:	ffffe097          	auipc	ra,0xffffe
    8000552c:	2ca080e7          	jalr	714(ra) # 800037f2 <iput>
  end_op(ROOTDEV);
    80005530:	4501                	li	a0,0
    80005532:	fffff097          	auipc	ra,0xfffff
    80005536:	c42080e7          	jalr	-958(ra) # 80004174 <end_op>
  return 0;
    8000553a:	4781                	li	a5,0
    8000553c:	a09d                	j	800055a2 <sys_link+0x146>
    end_op(ROOTDEV);
    8000553e:	4501                	li	a0,0
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	c34080e7          	jalr	-972(ra) # 80004174 <end_op>
    return -1;
    80005548:	57fd                	li	a5,-1
    8000554a:	a8a1                	j	800055a2 <sys_link+0x146>
    iunlockput(ip);
    8000554c:	8526                	mv	a0,s1
    8000554e:	ffffe097          	auipc	ra,0xffffe
    80005552:	3d4080e7          	jalr	980(ra) # 80003922 <iunlockput>
    end_op(ROOTDEV);
    80005556:	4501                	li	a0,0
    80005558:	fffff097          	auipc	ra,0xfffff
    8000555c:	c1c080e7          	jalr	-996(ra) # 80004174 <end_op>
    return -1;
    80005560:	57fd                	li	a5,-1
    80005562:	a081                	j	800055a2 <sys_link+0x146>
    iunlockput(dp);
    80005564:	854a                	mv	a0,s2
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	3bc080e7          	jalr	956(ra) # 80003922 <iunlockput>
  ilock(ip);
    8000556e:	8526                	mv	a0,s1
    80005570:	ffffe097          	auipc	ra,0xffffe
    80005574:	174080e7          	jalr	372(ra) # 800036e4 <ilock>
  ip->nlink--;
    80005578:	0524d783          	lhu	a5,82(s1)
    8000557c:	37fd                	addiw	a5,a5,-1
    8000557e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80005582:	8526                	mv	a0,s1
    80005584:	ffffe097          	auipc	ra,0xffffe
    80005588:	096080e7          	jalr	150(ra) # 8000361a <iupdate>
  iunlockput(ip);
    8000558c:	8526                	mv	a0,s1
    8000558e:	ffffe097          	auipc	ra,0xffffe
    80005592:	394080e7          	jalr	916(ra) # 80003922 <iunlockput>
  end_op(ROOTDEV);
    80005596:	4501                	li	a0,0
    80005598:	fffff097          	auipc	ra,0xfffff
    8000559c:	bdc080e7          	jalr	-1060(ra) # 80004174 <end_op>
  return -1;
    800055a0:	57fd                	li	a5,-1
}
    800055a2:	853e                	mv	a0,a5
    800055a4:	70b2                	ld	ra,296(sp)
    800055a6:	7412                	ld	s0,288(sp)
    800055a8:	64f2                	ld	s1,280(sp)
    800055aa:	6952                	ld	s2,272(sp)
    800055ac:	6155                	addi	sp,sp,304
    800055ae:	8082                	ret

00000000800055b0 <sys_unlink>:
{
    800055b0:	7151                	addi	sp,sp,-240
    800055b2:	f586                	sd	ra,232(sp)
    800055b4:	f1a2                	sd	s0,224(sp)
    800055b6:	eda6                	sd	s1,216(sp)
    800055b8:	e9ca                	sd	s2,208(sp)
    800055ba:	e5ce                	sd	s3,200(sp)
    800055bc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055be:	08000613          	li	a2,128
    800055c2:	f3040593          	addi	a1,s0,-208
    800055c6:	4501                	li	a0,0
    800055c8:	ffffd097          	auipc	ra,0xffffd
    800055cc:	5ea080e7          	jalr	1514(ra) # 80002bb2 <argstr>
    800055d0:	18054463          	bltz	a0,80005758 <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    800055d4:	4501                	li	a0,0
    800055d6:	fffff097          	auipc	ra,0xfffff
    800055da:	af4080e7          	jalr	-1292(ra) # 800040ca <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055de:	fb040593          	addi	a1,s0,-80
    800055e2:	f3040513          	addi	a0,s0,-208
    800055e6:	fffff097          	auipc	ra,0xfffff
    800055ea:	8a6080e7          	jalr	-1882(ra) # 80003e8c <nameiparent>
    800055ee:	84aa                	mv	s1,a0
    800055f0:	cd61                	beqz	a0,800056c8 <sys_unlink+0x118>
  ilock(dp);
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	0f2080e7          	jalr	242(ra) # 800036e4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055fa:	00003597          	auipc	a1,0x3
    800055fe:	48e58593          	addi	a1,a1,1166 # 80008a88 <userret+0x9f8>
    80005602:	fb040513          	addi	a0,s0,-80
    80005606:	ffffe097          	auipc	ra,0xffffe
    8000560a:	57c080e7          	jalr	1404(ra) # 80003b82 <namecmp>
    8000560e:	14050c63          	beqz	a0,80005766 <sys_unlink+0x1b6>
    80005612:	00003597          	auipc	a1,0x3
    80005616:	47e58593          	addi	a1,a1,1150 # 80008a90 <userret+0xa00>
    8000561a:	fb040513          	addi	a0,s0,-80
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	564080e7          	jalr	1380(ra) # 80003b82 <namecmp>
    80005626:	14050063          	beqz	a0,80005766 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000562a:	f2c40613          	addi	a2,s0,-212
    8000562e:	fb040593          	addi	a1,s0,-80
    80005632:	8526                	mv	a0,s1
    80005634:	ffffe097          	auipc	ra,0xffffe
    80005638:	568080e7          	jalr	1384(ra) # 80003b9c <dirlookup>
    8000563c:	892a                	mv	s2,a0
    8000563e:	12050463          	beqz	a0,80005766 <sys_unlink+0x1b6>
  ilock(ip);
    80005642:	ffffe097          	auipc	ra,0xffffe
    80005646:	0a2080e7          	jalr	162(ra) # 800036e4 <ilock>
  if(ip->nlink < 1)
    8000564a:	05291783          	lh	a5,82(s2)
    8000564e:	08f05463          	blez	a5,800056d6 <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005652:	04c91703          	lh	a4,76(s2)
    80005656:	4785                	li	a5,1
    80005658:	08f70763          	beq	a4,a5,800056e6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    8000565c:	4641                	li	a2,16
    8000565e:	4581                	li	a1,0
    80005660:	fc040513          	addi	a0,s0,-64
    80005664:	ffffb097          	auipc	ra,0xffffb
    80005668:	70a080e7          	jalr	1802(ra) # 80000d6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000566c:	4741                	li	a4,16
    8000566e:	f2c42683          	lw	a3,-212(s0)
    80005672:	fc040613          	addi	a2,s0,-64
    80005676:	4581                	li	a1,0
    80005678:	8526                	mv	a0,s1
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	3ee080e7          	jalr	1006(ra) # 80003a68 <writei>
    80005682:	47c1                	li	a5,16
    80005684:	0af51763          	bne	a0,a5,80005732 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005688:	04c91703          	lh	a4,76(s2)
    8000568c:	4785                	li	a5,1
    8000568e:	0af70a63          	beq	a4,a5,80005742 <sys_unlink+0x192>
  iunlockput(dp);
    80005692:	8526                	mv	a0,s1
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	28e080e7          	jalr	654(ra) # 80003922 <iunlockput>
  ip->nlink--;
    8000569c:	05295783          	lhu	a5,82(s2)
    800056a0:	37fd                	addiw	a5,a5,-1
    800056a2:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    800056a6:	854a                	mv	a0,s2
    800056a8:	ffffe097          	auipc	ra,0xffffe
    800056ac:	f72080e7          	jalr	-142(ra) # 8000361a <iupdate>
  iunlockput(ip);
    800056b0:	854a                	mv	a0,s2
    800056b2:	ffffe097          	auipc	ra,0xffffe
    800056b6:	270080e7          	jalr	624(ra) # 80003922 <iunlockput>
  end_op(ROOTDEV);
    800056ba:	4501                	li	a0,0
    800056bc:	fffff097          	auipc	ra,0xfffff
    800056c0:	ab8080e7          	jalr	-1352(ra) # 80004174 <end_op>
  return 0;
    800056c4:	4501                	li	a0,0
    800056c6:	a85d                	j	8000577c <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    800056c8:	4501                	li	a0,0
    800056ca:	fffff097          	auipc	ra,0xfffff
    800056ce:	aaa080e7          	jalr	-1366(ra) # 80004174 <end_op>
    return -1;
    800056d2:	557d                	li	a0,-1
    800056d4:	a065                	j	8000577c <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    800056d6:	00003517          	auipc	a0,0x3
    800056da:	3e250513          	addi	a0,a0,994 # 80008ab8 <userret+0xa28>
    800056de:	ffffb097          	auipc	ra,0xffffb
    800056e2:	e76080e7          	jalr	-394(ra) # 80000554 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056e6:	05492703          	lw	a4,84(s2)
    800056ea:	02000793          	li	a5,32
    800056ee:	f6e7f7e3          	bgeu	a5,a4,8000565c <sys_unlink+0xac>
    800056f2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056f6:	4741                	li	a4,16
    800056f8:	86ce                	mv	a3,s3
    800056fa:	f1840613          	addi	a2,s0,-232
    800056fe:	4581                	li	a1,0
    80005700:	854a                	mv	a0,s2
    80005702:	ffffe097          	auipc	ra,0xffffe
    80005706:	272080e7          	jalr	626(ra) # 80003974 <readi>
    8000570a:	47c1                	li	a5,16
    8000570c:	00f51b63          	bne	a0,a5,80005722 <sys_unlink+0x172>
    if(de.inum != 0)
    80005710:	f1845783          	lhu	a5,-232(s0)
    80005714:	e7a1                	bnez	a5,8000575c <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005716:	29c1                	addiw	s3,s3,16
    80005718:	05492783          	lw	a5,84(s2)
    8000571c:	fcf9ede3          	bltu	s3,a5,800056f6 <sys_unlink+0x146>
    80005720:	bf35                	j	8000565c <sys_unlink+0xac>
      panic("isdirempty: readi");
    80005722:	00003517          	auipc	a0,0x3
    80005726:	3ae50513          	addi	a0,a0,942 # 80008ad0 <userret+0xa40>
    8000572a:	ffffb097          	auipc	ra,0xffffb
    8000572e:	e2a080e7          	jalr	-470(ra) # 80000554 <panic>
    panic("unlink: writei");
    80005732:	00003517          	auipc	a0,0x3
    80005736:	3b650513          	addi	a0,a0,950 # 80008ae8 <userret+0xa58>
    8000573a:	ffffb097          	auipc	ra,0xffffb
    8000573e:	e1a080e7          	jalr	-486(ra) # 80000554 <panic>
    dp->nlink--;
    80005742:	0524d783          	lhu	a5,82(s1)
    80005746:	37fd                	addiw	a5,a5,-1
    80005748:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    8000574c:	8526                	mv	a0,s1
    8000574e:	ffffe097          	auipc	ra,0xffffe
    80005752:	ecc080e7          	jalr	-308(ra) # 8000361a <iupdate>
    80005756:	bf35                	j	80005692 <sys_unlink+0xe2>
    return -1;
    80005758:	557d                	li	a0,-1
    8000575a:	a00d                	j	8000577c <sys_unlink+0x1cc>
    iunlockput(ip);
    8000575c:	854a                	mv	a0,s2
    8000575e:	ffffe097          	auipc	ra,0xffffe
    80005762:	1c4080e7          	jalr	452(ra) # 80003922 <iunlockput>
  iunlockput(dp);
    80005766:	8526                	mv	a0,s1
    80005768:	ffffe097          	auipc	ra,0xffffe
    8000576c:	1ba080e7          	jalr	442(ra) # 80003922 <iunlockput>
  end_op(ROOTDEV);
    80005770:	4501                	li	a0,0
    80005772:	fffff097          	auipc	ra,0xfffff
    80005776:	a02080e7          	jalr	-1534(ra) # 80004174 <end_op>
  return -1;
    8000577a:	557d                	li	a0,-1
}
    8000577c:	70ae                	ld	ra,232(sp)
    8000577e:	740e                	ld	s0,224(sp)
    80005780:	64ee                	ld	s1,216(sp)
    80005782:	694e                	ld	s2,208(sp)
    80005784:	69ae                	ld	s3,200(sp)
    80005786:	616d                	addi	sp,sp,240
    80005788:	8082                	ret

000000008000578a <sys_open>:

uint64
sys_open(void)
{
    8000578a:	7131                	addi	sp,sp,-192
    8000578c:	fd06                	sd	ra,184(sp)
    8000578e:	f922                	sd	s0,176(sp)
    80005790:	f526                	sd	s1,168(sp)
    80005792:	f14a                	sd	s2,160(sp)
    80005794:	ed4e                	sd	s3,152(sp)
    80005796:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005798:	08000613          	li	a2,128
    8000579c:	f5040593          	addi	a1,s0,-176
    800057a0:	4501                	li	a0,0
    800057a2:	ffffd097          	auipc	ra,0xffffd
    800057a6:	410080e7          	jalr	1040(ra) # 80002bb2 <argstr>
    return -1;
    800057aa:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800057ac:	0a054963          	bltz	a0,8000585e <sys_open+0xd4>
    800057b0:	f4c40593          	addi	a1,s0,-180
    800057b4:	4505                	li	a0,1
    800057b6:	ffffd097          	auipc	ra,0xffffd
    800057ba:	3b8080e7          	jalr	952(ra) # 80002b6e <argint>
    800057be:	0a054063          	bltz	a0,8000585e <sys_open+0xd4>

  begin_op(ROOTDEV);
    800057c2:	4501                	li	a0,0
    800057c4:	fffff097          	auipc	ra,0xfffff
    800057c8:	906080e7          	jalr	-1786(ra) # 800040ca <begin_op>

  if(omode & O_CREATE){
    800057cc:	f4c42783          	lw	a5,-180(s0)
    800057d0:	2007f793          	andi	a5,a5,512
    800057d4:	c3dd                	beqz	a5,8000587a <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    800057d6:	4681                	li	a3,0
    800057d8:	4601                	li	a2,0
    800057da:	4589                	li	a1,2
    800057dc:	f5040513          	addi	a0,s0,-176
    800057e0:	00000097          	auipc	ra,0x0
    800057e4:	960080e7          	jalr	-1696(ra) # 80005140 <create>
    800057e8:	892a                	mv	s2,a0
    if(ip == 0){
    800057ea:	c151                	beqz	a0,8000586e <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057ec:	04c91703          	lh	a4,76(s2)
    800057f0:	478d                	li	a5,3
    800057f2:	00f71763          	bne	a4,a5,80005800 <sys_open+0x76>
    800057f6:	04e95703          	lhu	a4,78(s2)
    800057fa:	47a5                	li	a5,9
    800057fc:	0ce7e663          	bltu	a5,a4,800058c8 <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005800:	fffff097          	auipc	ra,0xfffff
    80005804:	da8080e7          	jalr	-600(ra) # 800045a8 <filealloc>
    80005808:	89aa                	mv	s3,a0
    8000580a:	c97d                	beqz	a0,80005900 <sys_open+0x176>
    8000580c:	00000097          	auipc	ra,0x0
    80005810:	8f2080e7          	jalr	-1806(ra) # 800050fe <fdalloc>
    80005814:	84aa                	mv	s1,a0
    80005816:	0e054063          	bltz	a0,800058f6 <sys_open+0x16c>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000581a:	04c91703          	lh	a4,76(s2)
    8000581e:	478d                	li	a5,3
    80005820:	0cf70063          	beq	a4,a5,800058e0 <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
    f->minor = ip->minor;
  } else {
    f->type = FD_INODE;
    80005824:	4789                	li	a5,2
    80005826:	00f9a023          	sw	a5,0(s3)
  }
  f->ip = ip;
    8000582a:	0129bc23          	sd	s2,24(s3)
  f->off = 0;
    8000582e:	0209a023          	sw	zero,32(s3)
  f->readable = !(omode & O_WRONLY);
    80005832:	f4c42783          	lw	a5,-180(s0)
    80005836:	0017c713          	xori	a4,a5,1
    8000583a:	8b05                	andi	a4,a4,1
    8000583c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005840:	8b8d                	andi	a5,a5,3
    80005842:	00f037b3          	snez	a5,a5
    80005846:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    8000584a:	854a                	mv	a0,s2
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	f5a080e7          	jalr	-166(ra) # 800037a6 <iunlock>
  end_op(ROOTDEV);
    80005854:	4501                	li	a0,0
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	91e080e7          	jalr	-1762(ra) # 80004174 <end_op>

  return fd;
}
    8000585e:	8526                	mv	a0,s1
    80005860:	70ea                	ld	ra,184(sp)
    80005862:	744a                	ld	s0,176(sp)
    80005864:	74aa                	ld	s1,168(sp)
    80005866:	790a                	ld	s2,160(sp)
    80005868:	69ea                	ld	s3,152(sp)
    8000586a:	6129                	addi	sp,sp,192
    8000586c:	8082                	ret
      end_op(ROOTDEV);
    8000586e:	4501                	li	a0,0
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	904080e7          	jalr	-1788(ra) # 80004174 <end_op>
      return -1;
    80005878:	b7dd                	j	8000585e <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    8000587a:	f5040513          	addi	a0,s0,-176
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	5f0080e7          	jalr	1520(ra) # 80003e6e <namei>
    80005886:	892a                	mv	s2,a0
    80005888:	c90d                	beqz	a0,800058ba <sys_open+0x130>
    ilock(ip);
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	e5a080e7          	jalr	-422(ra) # 800036e4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005892:	04c91703          	lh	a4,76(s2)
    80005896:	4785                	li	a5,1
    80005898:	f4f71ae3          	bne	a4,a5,800057ec <sys_open+0x62>
    8000589c:	f4c42783          	lw	a5,-180(s0)
    800058a0:	d3a5                	beqz	a5,80005800 <sys_open+0x76>
      iunlockput(ip);
    800058a2:	854a                	mv	a0,s2
    800058a4:	ffffe097          	auipc	ra,0xffffe
    800058a8:	07e080e7          	jalr	126(ra) # 80003922 <iunlockput>
      end_op(ROOTDEV);
    800058ac:	4501                	li	a0,0
    800058ae:	fffff097          	auipc	ra,0xfffff
    800058b2:	8c6080e7          	jalr	-1850(ra) # 80004174 <end_op>
      return -1;
    800058b6:	54fd                	li	s1,-1
    800058b8:	b75d                	j	8000585e <sys_open+0xd4>
      end_op(ROOTDEV);
    800058ba:	4501                	li	a0,0
    800058bc:	fffff097          	auipc	ra,0xfffff
    800058c0:	8b8080e7          	jalr	-1864(ra) # 80004174 <end_op>
      return -1;
    800058c4:	54fd                	li	s1,-1
    800058c6:	bf61                	j	8000585e <sys_open+0xd4>
    iunlockput(ip);
    800058c8:	854a                	mv	a0,s2
    800058ca:	ffffe097          	auipc	ra,0xffffe
    800058ce:	058080e7          	jalr	88(ra) # 80003922 <iunlockput>
    end_op(ROOTDEV);
    800058d2:	4501                	li	a0,0
    800058d4:	fffff097          	auipc	ra,0xfffff
    800058d8:	8a0080e7          	jalr	-1888(ra) # 80004174 <end_op>
    return -1;
    800058dc:	54fd                	li	s1,-1
    800058de:	b741                	j	8000585e <sys_open+0xd4>
    f->type = FD_DEVICE;
    800058e0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800058e4:	04e91783          	lh	a5,78(s2)
    800058e8:	02f99223          	sh	a5,36(s3)
    f->minor = ip->minor;
    800058ec:	05091783          	lh	a5,80(s2)
    800058f0:	02f99323          	sh	a5,38(s3)
    800058f4:	bf1d                	j	8000582a <sys_open+0xa0>
      fileclose(f);
    800058f6:	854e                	mv	a0,s3
    800058f8:	fffff097          	auipc	ra,0xfffff
    800058fc:	d6c080e7          	jalr	-660(ra) # 80004664 <fileclose>
    iunlockput(ip);
    80005900:	854a                	mv	a0,s2
    80005902:	ffffe097          	auipc	ra,0xffffe
    80005906:	020080e7          	jalr	32(ra) # 80003922 <iunlockput>
    end_op(ROOTDEV);
    8000590a:	4501                	li	a0,0
    8000590c:	fffff097          	auipc	ra,0xfffff
    80005910:	868080e7          	jalr	-1944(ra) # 80004174 <end_op>
    return -1;
    80005914:	54fd                	li	s1,-1
    80005916:	b7a1                	j	8000585e <sys_open+0xd4>

0000000080005918 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005918:	7175                	addi	sp,sp,-144
    8000591a:	e506                	sd	ra,136(sp)
    8000591c:	e122                	sd	s0,128(sp)
    8000591e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    80005920:	4501                	li	a0,0
    80005922:	ffffe097          	auipc	ra,0xffffe
    80005926:	7a8080e7          	jalr	1960(ra) # 800040ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000592a:	08000613          	li	a2,128
    8000592e:	f7040593          	addi	a1,s0,-144
    80005932:	4501                	li	a0,0
    80005934:	ffffd097          	auipc	ra,0xffffd
    80005938:	27e080e7          	jalr	638(ra) # 80002bb2 <argstr>
    8000593c:	02054a63          	bltz	a0,80005970 <sys_mkdir+0x58>
    80005940:	4681                	li	a3,0
    80005942:	4601                	li	a2,0
    80005944:	4585                	li	a1,1
    80005946:	f7040513          	addi	a0,s0,-144
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	7f6080e7          	jalr	2038(ra) # 80005140 <create>
    80005952:	cd19                	beqz	a0,80005970 <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005954:	ffffe097          	auipc	ra,0xffffe
    80005958:	fce080e7          	jalr	-50(ra) # 80003922 <iunlockput>
  end_op(ROOTDEV);
    8000595c:	4501                	li	a0,0
    8000595e:	fffff097          	auipc	ra,0xfffff
    80005962:	816080e7          	jalr	-2026(ra) # 80004174 <end_op>
  return 0;
    80005966:	4501                	li	a0,0
}
    80005968:	60aa                	ld	ra,136(sp)
    8000596a:	640a                	ld	s0,128(sp)
    8000596c:	6149                	addi	sp,sp,144
    8000596e:	8082                	ret
    end_op(ROOTDEV);
    80005970:	4501                	li	a0,0
    80005972:	fffff097          	auipc	ra,0xfffff
    80005976:	802080e7          	jalr	-2046(ra) # 80004174 <end_op>
    return -1;
    8000597a:	557d                	li	a0,-1
    8000597c:	b7f5                	j	80005968 <sys_mkdir+0x50>

000000008000597e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000597e:	7135                	addi	sp,sp,-160
    80005980:	ed06                	sd	ra,152(sp)
    80005982:	e922                	sd	s0,144(sp)
    80005984:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    80005986:	4501                	li	a0,0
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	742080e7          	jalr	1858(ra) # 800040ca <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005990:	08000613          	li	a2,128
    80005994:	f7040593          	addi	a1,s0,-144
    80005998:	4501                	li	a0,0
    8000599a:	ffffd097          	auipc	ra,0xffffd
    8000599e:	218080e7          	jalr	536(ra) # 80002bb2 <argstr>
    800059a2:	04054b63          	bltz	a0,800059f8 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    800059a6:	f6c40593          	addi	a1,s0,-148
    800059aa:	4505                	li	a0,1
    800059ac:	ffffd097          	auipc	ra,0xffffd
    800059b0:	1c2080e7          	jalr	450(ra) # 80002b6e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800059b4:	04054263          	bltz	a0,800059f8 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    800059b8:	f6840593          	addi	a1,s0,-152
    800059bc:	4509                	li	a0,2
    800059be:	ffffd097          	auipc	ra,0xffffd
    800059c2:	1b0080e7          	jalr	432(ra) # 80002b6e <argint>
     argint(1, &major) < 0 ||
    800059c6:	02054963          	bltz	a0,800059f8 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059ca:	f6841683          	lh	a3,-152(s0)
    800059ce:	f6c41603          	lh	a2,-148(s0)
    800059d2:	458d                	li	a1,3
    800059d4:	f7040513          	addi	a0,s0,-144
    800059d8:	fffff097          	auipc	ra,0xfffff
    800059dc:	768080e7          	jalr	1896(ra) # 80005140 <create>
     argint(2, &minor) < 0 ||
    800059e0:	cd01                	beqz	a0,800059f8 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    800059e2:	ffffe097          	auipc	ra,0xffffe
    800059e6:	f40080e7          	jalr	-192(ra) # 80003922 <iunlockput>
  end_op(ROOTDEV);
    800059ea:	4501                	li	a0,0
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	788080e7          	jalr	1928(ra) # 80004174 <end_op>
  return 0;
    800059f4:	4501                	li	a0,0
    800059f6:	a039                	j	80005a04 <sys_mknod+0x86>
    end_op(ROOTDEV);
    800059f8:	4501                	li	a0,0
    800059fa:	ffffe097          	auipc	ra,0xffffe
    800059fe:	77a080e7          	jalr	1914(ra) # 80004174 <end_op>
    return -1;
    80005a02:	557d                	li	a0,-1
}
    80005a04:	60ea                	ld	ra,152(sp)
    80005a06:	644a                	ld	s0,144(sp)
    80005a08:	610d                	addi	sp,sp,160
    80005a0a:	8082                	ret

0000000080005a0c <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a0c:	7135                	addi	sp,sp,-160
    80005a0e:	ed06                	sd	ra,152(sp)
    80005a10:	e922                	sd	s0,144(sp)
    80005a12:	e526                	sd	s1,136(sp)
    80005a14:	e14a                	sd	s2,128(sp)
    80005a16:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a18:	ffffc097          	auipc	ra,0xffffc
    80005a1c:	040080e7          	jalr	64(ra) # 80001a58 <myproc>
    80005a20:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    80005a22:	4501                	li	a0,0
    80005a24:	ffffe097          	auipc	ra,0xffffe
    80005a28:	6a6080e7          	jalr	1702(ra) # 800040ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a2c:	08000613          	li	a2,128
    80005a30:	f6040593          	addi	a1,s0,-160
    80005a34:	4501                	li	a0,0
    80005a36:	ffffd097          	auipc	ra,0xffffd
    80005a3a:	17c080e7          	jalr	380(ra) # 80002bb2 <argstr>
    80005a3e:	04054c63          	bltz	a0,80005a96 <sys_chdir+0x8a>
    80005a42:	f6040513          	addi	a0,s0,-160
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	428080e7          	jalr	1064(ra) # 80003e6e <namei>
    80005a4e:	84aa                	mv	s1,a0
    80005a50:	c139                	beqz	a0,80005a96 <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80005a52:	ffffe097          	auipc	ra,0xffffe
    80005a56:	c92080e7          	jalr	-878(ra) # 800036e4 <ilock>
  if(ip->type != T_DIR){
    80005a5a:	04c49703          	lh	a4,76(s1)
    80005a5e:	4785                	li	a5,1
    80005a60:	04f71263          	bne	a4,a5,80005aa4 <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    80005a64:	8526                	mv	a0,s1
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	d40080e7          	jalr	-704(ra) # 800037a6 <iunlock>
  iput(p->cwd);
    80005a6e:	15893503          	ld	a0,344(s2)
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	d80080e7          	jalr	-640(ra) # 800037f2 <iput>
  end_op(ROOTDEV);
    80005a7a:	4501                	li	a0,0
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	6f8080e7          	jalr	1784(ra) # 80004174 <end_op>
  p->cwd = ip;
    80005a84:	14993c23          	sd	s1,344(s2)
  return 0;
    80005a88:	4501                	li	a0,0
}
    80005a8a:	60ea                	ld	ra,152(sp)
    80005a8c:	644a                	ld	s0,144(sp)
    80005a8e:	64aa                	ld	s1,136(sp)
    80005a90:	690a                	ld	s2,128(sp)
    80005a92:	610d                	addi	sp,sp,160
    80005a94:	8082                	ret
    end_op(ROOTDEV);
    80005a96:	4501                	li	a0,0
    80005a98:	ffffe097          	auipc	ra,0xffffe
    80005a9c:	6dc080e7          	jalr	1756(ra) # 80004174 <end_op>
    return -1;
    80005aa0:	557d                	li	a0,-1
    80005aa2:	b7e5                	j	80005a8a <sys_chdir+0x7e>
    iunlockput(ip);
    80005aa4:	8526                	mv	a0,s1
    80005aa6:	ffffe097          	auipc	ra,0xffffe
    80005aaa:	e7c080e7          	jalr	-388(ra) # 80003922 <iunlockput>
    end_op(ROOTDEV);
    80005aae:	4501                	li	a0,0
    80005ab0:	ffffe097          	auipc	ra,0xffffe
    80005ab4:	6c4080e7          	jalr	1732(ra) # 80004174 <end_op>
    return -1;
    80005ab8:	557d                	li	a0,-1
    80005aba:	bfc1                	j	80005a8a <sys_chdir+0x7e>

0000000080005abc <sys_exec>:

uint64
sys_exec(void)
{
    80005abc:	7145                	addi	sp,sp,-464
    80005abe:	e786                	sd	ra,456(sp)
    80005ac0:	e3a2                	sd	s0,448(sp)
    80005ac2:	ff26                	sd	s1,440(sp)
    80005ac4:	fb4a                	sd	s2,432(sp)
    80005ac6:	f74e                	sd	s3,424(sp)
    80005ac8:	f352                	sd	s4,416(sp)
    80005aca:	ef56                	sd	s5,408(sp)
    80005acc:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005ace:	08000613          	li	a2,128
    80005ad2:	f4040593          	addi	a1,s0,-192
    80005ad6:	4501                	li	a0,0
    80005ad8:	ffffd097          	auipc	ra,0xffffd
    80005adc:	0da080e7          	jalr	218(ra) # 80002bb2 <argstr>
    80005ae0:	0e054663          	bltz	a0,80005bcc <sys_exec+0x110>
    80005ae4:	e3840593          	addi	a1,s0,-456
    80005ae8:	4505                	li	a0,1
    80005aea:	ffffd097          	auipc	ra,0xffffd
    80005aee:	0a6080e7          	jalr	166(ra) # 80002b90 <argaddr>
    80005af2:	0e054763          	bltz	a0,80005be0 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005af6:	10000613          	li	a2,256
    80005afa:	4581                	li	a1,0
    80005afc:	e4040513          	addi	a0,s0,-448
    80005b00:	ffffb097          	auipc	ra,0xffffb
    80005b04:	26e080e7          	jalr	622(ra) # 80000d6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b08:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005b0c:	89ca                	mv	s3,s2
    80005b0e:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005b10:	02000a13          	li	s4,32
    80005b14:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b18:	00349793          	slli	a5,s1,0x3
    80005b1c:	e3040593          	addi	a1,s0,-464
    80005b20:	e3843503          	ld	a0,-456(s0)
    80005b24:	953e                	add	a0,a0,a5
    80005b26:	ffffd097          	auipc	ra,0xffffd
    80005b2a:	fae080e7          	jalr	-82(ra) # 80002ad4 <fetchaddr>
    80005b2e:	02054a63          	bltz	a0,80005b62 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005b32:	e3043783          	ld	a5,-464(s0)
    80005b36:	c7a1                	beqz	a5,80005b7e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b38:	ffffb097          	auipc	ra,0xffffb
    80005b3c:	e34080e7          	jalr	-460(ra) # 8000096c <kalloc>
    80005b40:	85aa                	mv	a1,a0
    80005b42:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b46:	c92d                	beqz	a0,80005bb8 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005b48:	6605                	lui	a2,0x1
    80005b4a:	e3043503          	ld	a0,-464(s0)
    80005b4e:	ffffd097          	auipc	ra,0xffffd
    80005b52:	fd8080e7          	jalr	-40(ra) # 80002b26 <fetchstr>
    80005b56:	00054663          	bltz	a0,80005b62 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005b5a:	0485                	addi	s1,s1,1
    80005b5c:	09a1                	addi	s3,s3,8
    80005b5e:	fb449be3          	bne	s1,s4,80005b14 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b62:	10090493          	addi	s1,s2,256
    80005b66:	00093503          	ld	a0,0(s2)
    80005b6a:	cd39                	beqz	a0,80005bc8 <sys_exec+0x10c>
    kfree(argv[i]);
    80005b6c:	ffffb097          	auipc	ra,0xffffb
    80005b70:	d04080e7          	jalr	-764(ra) # 80000870 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b74:	0921                	addi	s2,s2,8
    80005b76:	fe9918e3          	bne	s2,s1,80005b66 <sys_exec+0xaa>
  return -1;
    80005b7a:	557d                	li	a0,-1
    80005b7c:	a889                	j	80005bce <sys_exec+0x112>
      argv[i] = 0;
    80005b7e:	0a8e                	slli	s5,s5,0x3
    80005b80:	fc040793          	addi	a5,s0,-64
    80005b84:	9abe                	add	s5,s5,a5
    80005b86:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005b8a:	e4040593          	addi	a1,s0,-448
    80005b8e:	f4040513          	addi	a0,s0,-192
    80005b92:	fffff097          	auipc	ra,0xfffff
    80005b96:	178080e7          	jalr	376(ra) # 80004d0a <exec>
    80005b9a:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b9c:	10090993          	addi	s3,s2,256
    80005ba0:	00093503          	ld	a0,0(s2)
    80005ba4:	c901                	beqz	a0,80005bb4 <sys_exec+0xf8>
    kfree(argv[i]);
    80005ba6:	ffffb097          	auipc	ra,0xffffb
    80005baa:	cca080e7          	jalr	-822(ra) # 80000870 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bae:	0921                	addi	s2,s2,8
    80005bb0:	ff3918e3          	bne	s2,s3,80005ba0 <sys_exec+0xe4>
  return ret;
    80005bb4:	8526                	mv	a0,s1
    80005bb6:	a821                	j	80005bce <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005bb8:	00003517          	auipc	a0,0x3
    80005bbc:	f4050513          	addi	a0,a0,-192 # 80008af8 <userret+0xa68>
    80005bc0:	ffffb097          	auipc	ra,0xffffb
    80005bc4:	994080e7          	jalr	-1644(ra) # 80000554 <panic>
  return -1;
    80005bc8:	557d                	li	a0,-1
    80005bca:	a011                	j	80005bce <sys_exec+0x112>
    return -1;
    80005bcc:	557d                	li	a0,-1
}
    80005bce:	60be                	ld	ra,456(sp)
    80005bd0:	641e                	ld	s0,448(sp)
    80005bd2:	74fa                	ld	s1,440(sp)
    80005bd4:	795a                	ld	s2,432(sp)
    80005bd6:	79ba                	ld	s3,424(sp)
    80005bd8:	7a1a                	ld	s4,416(sp)
    80005bda:	6afa                	ld	s5,408(sp)
    80005bdc:	6179                	addi	sp,sp,464
    80005bde:	8082                	ret
    return -1;
    80005be0:	557d                	li	a0,-1
    80005be2:	b7f5                	j	80005bce <sys_exec+0x112>

0000000080005be4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005be4:	7139                	addi	sp,sp,-64
    80005be6:	fc06                	sd	ra,56(sp)
    80005be8:	f822                	sd	s0,48(sp)
    80005bea:	f426                	sd	s1,40(sp)
    80005bec:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005bee:	ffffc097          	auipc	ra,0xffffc
    80005bf2:	e6a080e7          	jalr	-406(ra) # 80001a58 <myproc>
    80005bf6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005bf8:	fd840593          	addi	a1,s0,-40
    80005bfc:	4501                	li	a0,0
    80005bfe:	ffffd097          	auipc	ra,0xffffd
    80005c02:	f92080e7          	jalr	-110(ra) # 80002b90 <argaddr>
    return -1;
    80005c06:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005c08:	0e054063          	bltz	a0,80005ce8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005c0c:	fc840593          	addi	a1,s0,-56
    80005c10:	fd040513          	addi	a0,s0,-48
    80005c14:	fffff097          	auipc	ra,0xfffff
    80005c18:	db4080e7          	jalr	-588(ra) # 800049c8 <pipealloc>
    return -1;
    80005c1c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c1e:	0c054563          	bltz	a0,80005ce8 <sys_pipe+0x104>
  fd0 = -1;
    80005c22:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c26:	fd043503          	ld	a0,-48(s0)
    80005c2a:	fffff097          	auipc	ra,0xfffff
    80005c2e:	4d4080e7          	jalr	1236(ra) # 800050fe <fdalloc>
    80005c32:	fca42223          	sw	a0,-60(s0)
    80005c36:	08054c63          	bltz	a0,80005cce <sys_pipe+0xea>
    80005c3a:	fc843503          	ld	a0,-56(s0)
    80005c3e:	fffff097          	auipc	ra,0xfffff
    80005c42:	4c0080e7          	jalr	1216(ra) # 800050fe <fdalloc>
    80005c46:	fca42023          	sw	a0,-64(s0)
    80005c4a:	06054863          	bltz	a0,80005cba <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c4e:	4691                	li	a3,4
    80005c50:	fc440613          	addi	a2,s0,-60
    80005c54:	fd843583          	ld	a1,-40(s0)
    80005c58:	6ca8                	ld	a0,88(s1)
    80005c5a:	ffffc097          	auipc	ra,0xffffc
    80005c5e:	af0080e7          	jalr	-1296(ra) # 8000174a <copyout>
    80005c62:	02054063          	bltz	a0,80005c82 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c66:	4691                	li	a3,4
    80005c68:	fc040613          	addi	a2,s0,-64
    80005c6c:	fd843583          	ld	a1,-40(s0)
    80005c70:	0591                	addi	a1,a1,4
    80005c72:	6ca8                	ld	a0,88(s1)
    80005c74:	ffffc097          	auipc	ra,0xffffc
    80005c78:	ad6080e7          	jalr	-1322(ra) # 8000174a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c7c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c7e:	06055563          	bgez	a0,80005ce8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005c82:	fc442783          	lw	a5,-60(s0)
    80005c86:	07e9                	addi	a5,a5,26
    80005c88:	078e                	slli	a5,a5,0x3
    80005c8a:	97a6                	add	a5,a5,s1
    80005c8c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005c90:	fc042503          	lw	a0,-64(s0)
    80005c94:	0569                	addi	a0,a0,26
    80005c96:	050e                	slli	a0,a0,0x3
    80005c98:	9526                	add	a0,a0,s1
    80005c9a:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005c9e:	fd043503          	ld	a0,-48(s0)
    80005ca2:	fffff097          	auipc	ra,0xfffff
    80005ca6:	9c2080e7          	jalr	-1598(ra) # 80004664 <fileclose>
    fileclose(wf);
    80005caa:	fc843503          	ld	a0,-56(s0)
    80005cae:	fffff097          	auipc	ra,0xfffff
    80005cb2:	9b6080e7          	jalr	-1610(ra) # 80004664 <fileclose>
    return -1;
    80005cb6:	57fd                	li	a5,-1
    80005cb8:	a805                	j	80005ce8 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005cba:	fc442783          	lw	a5,-60(s0)
    80005cbe:	0007c863          	bltz	a5,80005cce <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005cc2:	01a78513          	addi	a0,a5,26
    80005cc6:	050e                	slli	a0,a0,0x3
    80005cc8:	9526                	add	a0,a0,s1
    80005cca:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005cce:	fd043503          	ld	a0,-48(s0)
    80005cd2:	fffff097          	auipc	ra,0xfffff
    80005cd6:	992080e7          	jalr	-1646(ra) # 80004664 <fileclose>
    fileclose(wf);
    80005cda:	fc843503          	ld	a0,-56(s0)
    80005cde:	fffff097          	auipc	ra,0xfffff
    80005ce2:	986080e7          	jalr	-1658(ra) # 80004664 <fileclose>
    return -1;
    80005ce6:	57fd                	li	a5,-1
}
    80005ce8:	853e                	mv	a0,a5
    80005cea:	70e2                	ld	ra,56(sp)
    80005cec:	7442                	ld	s0,48(sp)
    80005cee:	74a2                	ld	s1,40(sp)
    80005cf0:	6121                	addi	sp,sp,64
    80005cf2:	8082                	ret
	...

0000000080005d00 <kernelvec>:
    80005d00:	7111                	addi	sp,sp,-256
    80005d02:	e006                	sd	ra,0(sp)
    80005d04:	e40a                	sd	sp,8(sp)
    80005d06:	e80e                	sd	gp,16(sp)
    80005d08:	ec12                	sd	tp,24(sp)
    80005d0a:	f016                	sd	t0,32(sp)
    80005d0c:	f41a                	sd	t1,40(sp)
    80005d0e:	f81e                	sd	t2,48(sp)
    80005d10:	fc22                	sd	s0,56(sp)
    80005d12:	e0a6                	sd	s1,64(sp)
    80005d14:	e4aa                	sd	a0,72(sp)
    80005d16:	e8ae                	sd	a1,80(sp)
    80005d18:	ecb2                	sd	a2,88(sp)
    80005d1a:	f0b6                	sd	a3,96(sp)
    80005d1c:	f4ba                	sd	a4,104(sp)
    80005d1e:	f8be                	sd	a5,112(sp)
    80005d20:	fcc2                	sd	a6,120(sp)
    80005d22:	e146                	sd	a7,128(sp)
    80005d24:	e54a                	sd	s2,136(sp)
    80005d26:	e94e                	sd	s3,144(sp)
    80005d28:	ed52                	sd	s4,152(sp)
    80005d2a:	f156                	sd	s5,160(sp)
    80005d2c:	f55a                	sd	s6,168(sp)
    80005d2e:	f95e                	sd	s7,176(sp)
    80005d30:	fd62                	sd	s8,184(sp)
    80005d32:	e1e6                	sd	s9,192(sp)
    80005d34:	e5ea                	sd	s10,200(sp)
    80005d36:	e9ee                	sd	s11,208(sp)
    80005d38:	edf2                	sd	t3,216(sp)
    80005d3a:	f1f6                	sd	t4,224(sp)
    80005d3c:	f5fa                	sd	t5,232(sp)
    80005d3e:	f9fe                	sd	t6,240(sp)
    80005d40:	c55fc0ef          	jal	ra,80002994 <kerneltrap>
    80005d44:	6082                	ld	ra,0(sp)
    80005d46:	6122                	ld	sp,8(sp)
    80005d48:	61c2                	ld	gp,16(sp)
    80005d4a:	7282                	ld	t0,32(sp)
    80005d4c:	7322                	ld	t1,40(sp)
    80005d4e:	73c2                	ld	t2,48(sp)
    80005d50:	7462                	ld	s0,56(sp)
    80005d52:	6486                	ld	s1,64(sp)
    80005d54:	6526                	ld	a0,72(sp)
    80005d56:	65c6                	ld	a1,80(sp)
    80005d58:	6666                	ld	a2,88(sp)
    80005d5a:	7686                	ld	a3,96(sp)
    80005d5c:	7726                	ld	a4,104(sp)
    80005d5e:	77c6                	ld	a5,112(sp)
    80005d60:	7866                	ld	a6,120(sp)
    80005d62:	688a                	ld	a7,128(sp)
    80005d64:	692a                	ld	s2,136(sp)
    80005d66:	69ca                	ld	s3,144(sp)
    80005d68:	6a6a                	ld	s4,152(sp)
    80005d6a:	7a8a                	ld	s5,160(sp)
    80005d6c:	7b2a                	ld	s6,168(sp)
    80005d6e:	7bca                	ld	s7,176(sp)
    80005d70:	7c6a                	ld	s8,184(sp)
    80005d72:	6c8e                	ld	s9,192(sp)
    80005d74:	6d2e                	ld	s10,200(sp)
    80005d76:	6dce                	ld	s11,208(sp)
    80005d78:	6e6e                	ld	t3,216(sp)
    80005d7a:	7e8e                	ld	t4,224(sp)
    80005d7c:	7f2e                	ld	t5,232(sp)
    80005d7e:	7fce                	ld	t6,240(sp)
    80005d80:	6111                	addi	sp,sp,256
    80005d82:	10200073          	sret
    80005d86:	00000013          	nop
    80005d8a:	00000013          	nop
    80005d8e:	0001                	nop

0000000080005d90 <timervec>:
    80005d90:	34051573          	csrrw	a0,mscratch,a0
    80005d94:	e10c                	sd	a1,0(a0)
    80005d96:	e510                	sd	a2,8(a0)
    80005d98:	e914                	sd	a3,16(a0)
    80005d9a:	710c                	ld	a1,32(a0)
    80005d9c:	7510                	ld	a2,40(a0)
    80005d9e:	6194                	ld	a3,0(a1)
    80005da0:	96b2                	add	a3,a3,a2
    80005da2:	e194                	sd	a3,0(a1)
    80005da4:	4589                	li	a1,2
    80005da6:	14459073          	csrw	sip,a1
    80005daa:	6914                	ld	a3,16(a0)
    80005dac:	6510                	ld	a2,8(a0)
    80005dae:	610c                	ld	a1,0(a0)
    80005db0:	34051573          	csrrw	a0,mscratch,a0
    80005db4:	30200073          	mret
	...

0000000080005dba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dba:	1141                	addi	sp,sp,-16
    80005dbc:	e422                	sd	s0,8(sp)
    80005dbe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005dc0:	0c0007b7          	lui	a5,0xc000
    80005dc4:	4705                	li	a4,1
    80005dc6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005dc8:	c3d8                	sw	a4,4(a5)
}
    80005dca:	6422                	ld	s0,8(sp)
    80005dcc:	0141                	addi	sp,sp,16
    80005dce:	8082                	ret

0000000080005dd0 <plicinithart>:

void
plicinithart(void)
{
    80005dd0:	1141                	addi	sp,sp,-16
    80005dd2:	e406                	sd	ra,8(sp)
    80005dd4:	e022                	sd	s0,0(sp)
    80005dd6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005dd8:	ffffc097          	auipc	ra,0xffffc
    80005ddc:	c54080e7          	jalr	-940(ra) # 80001a2c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005de0:	0085171b          	slliw	a4,a0,0x8
    80005de4:	0c0027b7          	lui	a5,0xc002
    80005de8:	97ba                	add	a5,a5,a4
    80005dea:	40200713          	li	a4,1026
    80005dee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005df2:	00d5151b          	slliw	a0,a0,0xd
    80005df6:	0c2017b7          	lui	a5,0xc201
    80005dfa:	953e                	add	a0,a0,a5
    80005dfc:	00052023          	sw	zero,0(a0)
}
    80005e00:	60a2                	ld	ra,8(sp)
    80005e02:	6402                	ld	s0,0(sp)
    80005e04:	0141                	addi	sp,sp,16
    80005e06:	8082                	ret

0000000080005e08 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e08:	1141                	addi	sp,sp,-16
    80005e0a:	e406                	sd	ra,8(sp)
    80005e0c:	e022                	sd	s0,0(sp)
    80005e0e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e10:	ffffc097          	auipc	ra,0xffffc
    80005e14:	c1c080e7          	jalr	-996(ra) # 80001a2c <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e18:	00d5179b          	slliw	a5,a0,0xd
    80005e1c:	0c201537          	lui	a0,0xc201
    80005e20:	953e                	add	a0,a0,a5
  return irq;
}
    80005e22:	4148                	lw	a0,4(a0)
    80005e24:	60a2                	ld	ra,8(sp)
    80005e26:	6402                	ld	s0,0(sp)
    80005e28:	0141                	addi	sp,sp,16
    80005e2a:	8082                	ret

0000000080005e2c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e2c:	1101                	addi	sp,sp,-32
    80005e2e:	ec06                	sd	ra,24(sp)
    80005e30:	e822                	sd	s0,16(sp)
    80005e32:	e426                	sd	s1,8(sp)
    80005e34:	1000                	addi	s0,sp,32
    80005e36:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e38:	ffffc097          	auipc	ra,0xffffc
    80005e3c:	bf4080e7          	jalr	-1036(ra) # 80001a2c <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e40:	00d5151b          	slliw	a0,a0,0xd
    80005e44:	0c2017b7          	lui	a5,0xc201
    80005e48:	97aa                	add	a5,a5,a0
    80005e4a:	c3c4                	sw	s1,4(a5)
}
    80005e4c:	60e2                	ld	ra,24(sp)
    80005e4e:	6442                	ld	s0,16(sp)
    80005e50:	64a2                	ld	s1,8(sp)
    80005e52:	6105                	addi	sp,sp,32
    80005e54:	8082                	ret

0000000080005e56 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005e56:	1141                	addi	sp,sp,-16
    80005e58:	e406                	sd	ra,8(sp)
    80005e5a:	e022                	sd	s0,0(sp)
    80005e5c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e5e:	479d                	li	a5,7
    80005e60:	06b7c963          	blt	a5,a1,80005ed2 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005e64:	00151793          	slli	a5,a0,0x1
    80005e68:	97aa                	add	a5,a5,a0
    80005e6a:	00c79713          	slli	a4,a5,0xc
    80005e6e:	0001c797          	auipc	a5,0x1c
    80005e72:	19278793          	addi	a5,a5,402 # 80022000 <disk>
    80005e76:	97ba                	add	a5,a5,a4
    80005e78:	97ae                	add	a5,a5,a1
    80005e7a:	6709                	lui	a4,0x2
    80005e7c:	97ba                	add	a5,a5,a4
    80005e7e:	0187c783          	lbu	a5,24(a5)
    80005e82:	e3a5                	bnez	a5,80005ee2 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80005e84:	0001c817          	auipc	a6,0x1c
    80005e88:	17c80813          	addi	a6,a6,380 # 80022000 <disk>
    80005e8c:	00151693          	slli	a3,a0,0x1
    80005e90:	00a68733          	add	a4,a3,a0
    80005e94:	0732                	slli	a4,a4,0xc
    80005e96:	00e807b3          	add	a5,a6,a4
    80005e9a:	6709                	lui	a4,0x2
    80005e9c:	00f70633          	add	a2,a4,a5
    80005ea0:	6210                	ld	a2,0(a2)
    80005ea2:	00459893          	slli	a7,a1,0x4
    80005ea6:	9646                	add	a2,a2,a7
    80005ea8:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    80005eac:	97ae                	add	a5,a5,a1
    80005eae:	97ba                	add	a5,a5,a4
    80005eb0:	4605                	li	a2,1
    80005eb2:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80005eb6:	96aa                	add	a3,a3,a0
    80005eb8:	06b2                	slli	a3,a3,0xc
    80005eba:	0761                	addi	a4,a4,24
    80005ebc:	96ba                	add	a3,a3,a4
    80005ebe:	00d80533          	add	a0,a6,a3
    80005ec2:	ffffc097          	auipc	ra,0xffffc
    80005ec6:	4d6080e7          	jalr	1238(ra) # 80002398 <wakeup>
}
    80005eca:	60a2                	ld	ra,8(sp)
    80005ecc:	6402                	ld	s0,0(sp)
    80005ece:	0141                	addi	sp,sp,16
    80005ed0:	8082                	ret
    panic("virtio_disk_intr 1");
    80005ed2:	00003517          	auipc	a0,0x3
    80005ed6:	c3650513          	addi	a0,a0,-970 # 80008b08 <userret+0xa78>
    80005eda:	ffffa097          	auipc	ra,0xffffa
    80005ede:	67a080e7          	jalr	1658(ra) # 80000554 <panic>
    panic("virtio_disk_intr 2");
    80005ee2:	00003517          	auipc	a0,0x3
    80005ee6:	c3e50513          	addi	a0,a0,-962 # 80008b20 <userret+0xa90>
    80005eea:	ffffa097          	auipc	ra,0xffffa
    80005eee:	66a080e7          	jalr	1642(ra) # 80000554 <panic>

0000000080005ef2 <virtio_disk_init>:
  __sync_synchronize();
    80005ef2:	0ff0000f          	fence
  if(disk[n].init)
    80005ef6:	00151793          	slli	a5,a0,0x1
    80005efa:	97aa                	add	a5,a5,a0
    80005efc:	07b2                	slli	a5,a5,0xc
    80005efe:	0001c717          	auipc	a4,0x1c
    80005f02:	10270713          	addi	a4,a4,258 # 80022000 <disk>
    80005f06:	973e                	add	a4,a4,a5
    80005f08:	6789                	lui	a5,0x2
    80005f0a:	97ba                	add	a5,a5,a4
    80005f0c:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80005f10:	c391                	beqz	a5,80005f14 <virtio_disk_init+0x22>
    80005f12:	8082                	ret
{
    80005f14:	7139                	addi	sp,sp,-64
    80005f16:	fc06                	sd	ra,56(sp)
    80005f18:	f822                	sd	s0,48(sp)
    80005f1a:	f426                	sd	s1,40(sp)
    80005f1c:	f04a                	sd	s2,32(sp)
    80005f1e:	ec4e                	sd	s3,24(sp)
    80005f20:	e852                	sd	s4,16(sp)
    80005f22:	e456                	sd	s5,8(sp)
    80005f24:	0080                	addi	s0,sp,64
    80005f26:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    80005f28:	85aa                	mv	a1,a0
    80005f2a:	00003517          	auipc	a0,0x3
    80005f2e:	c0e50513          	addi	a0,a0,-1010 # 80008b38 <userret+0xaa8>
    80005f32:	ffffa097          	auipc	ra,0xffffa
    80005f36:	67c080e7          	jalr	1660(ra) # 800005ae <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    80005f3a:	00149993          	slli	s3,s1,0x1
    80005f3e:	99a6                	add	s3,s3,s1
    80005f40:	09b2                	slli	s3,s3,0xc
    80005f42:	6789                	lui	a5,0x2
    80005f44:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    80005f48:	97ce                	add	a5,a5,s3
    80005f4a:	00003597          	auipc	a1,0x3
    80005f4e:	c0658593          	addi	a1,a1,-1018 # 80008b50 <userret+0xac0>
    80005f52:	0001c517          	auipc	a0,0x1c
    80005f56:	0ae50513          	addi	a0,a0,174 # 80022000 <disk>
    80005f5a:	953e                	add	a0,a0,a5
    80005f5c:	ffffb097          	auipc	ra,0xffffb
    80005f60:	a70080e7          	jalr	-1424(ra) # 800009cc <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f64:	0014891b          	addiw	s2,s1,1
    80005f68:	00c9191b          	slliw	s2,s2,0xc
    80005f6c:	100007b7          	lui	a5,0x10000
    80005f70:	97ca                	add	a5,a5,s2
    80005f72:	4398                	lw	a4,0(a5)
    80005f74:	2701                	sext.w	a4,a4
    80005f76:	747277b7          	lui	a5,0x74727
    80005f7a:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f7e:	12f71663          	bne	a4,a5,800060aa <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005f82:	100007b7          	lui	a5,0x10000
    80005f86:	0791                	addi	a5,a5,4
    80005f88:	97ca                	add	a5,a5,s2
    80005f8a:	439c                	lw	a5,0(a5)
    80005f8c:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f8e:	4705                	li	a4,1
    80005f90:	10e79d63          	bne	a5,a4,800060aa <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f94:	100007b7          	lui	a5,0x10000
    80005f98:	07a1                	addi	a5,a5,8
    80005f9a:	97ca                	add	a5,a5,s2
    80005f9c:	439c                	lw	a5,0(a5)
    80005f9e:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005fa0:	4709                	li	a4,2
    80005fa2:	10e79463          	bne	a5,a4,800060aa <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005fa6:	100007b7          	lui	a5,0x10000
    80005faa:	07b1                	addi	a5,a5,12
    80005fac:	97ca                	add	a5,a5,s2
    80005fae:	4398                	lw	a4,0(a5)
    80005fb0:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005fb2:	554d47b7          	lui	a5,0x554d4
    80005fb6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005fba:	0ef71863          	bne	a4,a5,800060aa <virtio_disk_init+0x1b8>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005fbe:	100007b7          	lui	a5,0x10000
    80005fc2:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80005fc6:	96ca                	add	a3,a3,s2
    80005fc8:	4705                	li	a4,1
    80005fca:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005fcc:	470d                	li	a4,3
    80005fce:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80005fd0:	01078713          	addi	a4,a5,16
    80005fd4:	974a                	add	a4,a4,s2
    80005fd6:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005fd8:	02078613          	addi	a2,a5,32
    80005fdc:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005fde:	c7ffe737          	lui	a4,0xc7ffe
    80005fe2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd6703>
    80005fe6:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005fe8:	2701                	sext.w	a4,a4
    80005fea:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005fec:	472d                	li	a4,11
    80005fee:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ff0:	473d                	li	a4,15
    80005ff2:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005ff4:	02878713          	addi	a4,a5,40
    80005ff8:	974a                	add	a4,a4,s2
    80005ffa:	6685                	lui	a3,0x1
    80005ffc:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005ffe:	03078713          	addi	a4,a5,48
    80006002:	974a                	add	a4,a4,s2
    80006004:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006008:	03478793          	addi	a5,a5,52
    8000600c:	97ca                	add	a5,a5,s2
    8000600e:	439c                	lw	a5,0(a5)
    80006010:	2781                	sext.w	a5,a5
  if(max == 0)
    80006012:	c7c5                	beqz	a5,800060ba <virtio_disk_init+0x1c8>
  if(max < NUM)
    80006014:	471d                	li	a4,7
    80006016:	0af77a63          	bgeu	a4,a5,800060ca <virtio_disk_init+0x1d8>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000601a:	10000ab7          	lui	s5,0x10000
    8000601e:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    80006022:	97ca                	add	a5,a5,s2
    80006024:	4721                	li	a4,8
    80006026:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    80006028:	0001ca17          	auipc	s4,0x1c
    8000602c:	fd8a0a13          	addi	s4,s4,-40 # 80022000 <disk>
    80006030:	99d2                	add	s3,s3,s4
    80006032:	6609                	lui	a2,0x2
    80006034:	4581                	li	a1,0
    80006036:	854e                	mv	a0,s3
    80006038:	ffffb097          	auipc	ra,0xffffb
    8000603c:	d36080e7          	jalr	-714(ra) # 80000d6e <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    80006040:	040a8a93          	addi	s5,s5,64
    80006044:	9956                	add	s2,s2,s5
    80006046:	00c9d793          	srli	a5,s3,0xc
    8000604a:	2781                	sext.w	a5,a5
    8000604c:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    80006050:	00149693          	slli	a3,s1,0x1
    80006054:	009687b3          	add	a5,a3,s1
    80006058:	07b2                	slli	a5,a5,0xc
    8000605a:	97d2                	add	a5,a5,s4
    8000605c:	6609                	lui	a2,0x2
    8000605e:	97b2                	add	a5,a5,a2
    80006060:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80006064:	08098713          	addi	a4,s3,128
    80006068:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    8000606a:	6705                	lui	a4,0x1
    8000606c:	99ba                	add	s3,s3,a4
    8000606e:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80006072:	4705                	li	a4,1
    80006074:	00e78c23          	sb	a4,24(a5)
    80006078:	00e78ca3          	sb	a4,25(a5)
    8000607c:	00e78d23          	sb	a4,26(a5)
    80006080:	00e78da3          	sb	a4,27(a5)
    80006084:	00e78e23          	sb	a4,28(a5)
    80006088:	00e78ea3          	sb	a4,29(a5)
    8000608c:	00e78f23          	sb	a4,30(a5)
    80006090:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80006094:	0ae7a423          	sw	a4,168(a5)
}
    80006098:	70e2                	ld	ra,56(sp)
    8000609a:	7442                	ld	s0,48(sp)
    8000609c:	74a2                	ld	s1,40(sp)
    8000609e:	7902                	ld	s2,32(sp)
    800060a0:	69e2                	ld	s3,24(sp)
    800060a2:	6a42                	ld	s4,16(sp)
    800060a4:	6aa2                	ld	s5,8(sp)
    800060a6:	6121                	addi	sp,sp,64
    800060a8:	8082                	ret
    panic("could not find virtio disk");
    800060aa:	00003517          	auipc	a0,0x3
    800060ae:	ab650513          	addi	a0,a0,-1354 # 80008b60 <userret+0xad0>
    800060b2:	ffffa097          	auipc	ra,0xffffa
    800060b6:	4a2080e7          	jalr	1186(ra) # 80000554 <panic>
    panic("virtio disk has no queue 0");
    800060ba:	00003517          	auipc	a0,0x3
    800060be:	ac650513          	addi	a0,a0,-1338 # 80008b80 <userret+0xaf0>
    800060c2:	ffffa097          	auipc	ra,0xffffa
    800060c6:	492080e7          	jalr	1170(ra) # 80000554 <panic>
    panic("virtio disk max queue too short");
    800060ca:	00003517          	auipc	a0,0x3
    800060ce:	ad650513          	addi	a0,a0,-1322 # 80008ba0 <userret+0xb10>
    800060d2:	ffffa097          	auipc	ra,0xffffa
    800060d6:	482080e7          	jalr	1154(ra) # 80000554 <panic>

00000000800060da <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    800060da:	7135                	addi	sp,sp,-160
    800060dc:	ed06                	sd	ra,152(sp)
    800060de:	e922                	sd	s0,144(sp)
    800060e0:	e526                	sd	s1,136(sp)
    800060e2:	e14a                	sd	s2,128(sp)
    800060e4:	fcce                	sd	s3,120(sp)
    800060e6:	f8d2                	sd	s4,112(sp)
    800060e8:	f4d6                	sd	s5,104(sp)
    800060ea:	f0da                	sd	s6,96(sp)
    800060ec:	ecde                	sd	s7,88(sp)
    800060ee:	e8e2                	sd	s8,80(sp)
    800060f0:	e4e6                	sd	s9,72(sp)
    800060f2:	e0ea                	sd	s10,64(sp)
    800060f4:	fc6e                	sd	s11,56(sp)
    800060f6:	1100                	addi	s0,sp,160
    800060f8:	8aaa                	mv	s5,a0
    800060fa:	8c2e                	mv	s8,a1
    800060fc:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    800060fe:	45dc                	lw	a5,12(a1)
    80006100:	0017979b          	slliw	a5,a5,0x1
    80006104:	1782                	slli	a5,a5,0x20
    80006106:	9381                	srli	a5,a5,0x20
    80006108:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    8000610c:	00151493          	slli	s1,a0,0x1
    80006110:	94aa                	add	s1,s1,a0
    80006112:	04b2                	slli	s1,s1,0xc
    80006114:	6909                	lui	s2,0x2
    80006116:	0b090c93          	addi	s9,s2,176 # 20b0 <_entry-0x7fffdf50>
    8000611a:	9ca6                	add	s9,s9,s1
    8000611c:	0001c997          	auipc	s3,0x1c
    80006120:	ee498993          	addi	s3,s3,-284 # 80022000 <disk>
    80006124:	9cce                	add	s9,s9,s3
    80006126:	8566                	mv	a0,s9
    80006128:	ffffb097          	auipc	ra,0xffffb
    8000612c:	978080e7          	jalr	-1672(ra) # 80000aa0 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80006130:	0961                	addi	s2,s2,24
    80006132:	94ca                	add	s1,s1,s2
    80006134:	99a6                	add	s3,s3,s1
  for(int i = 0; i < 3; i++){
    80006136:	4a01                	li	s4,0
  for(int i = 0; i < NUM; i++){
    80006138:	44a1                	li	s1,8
      disk[n].free[i] = 0;
    8000613a:	001a9793          	slli	a5,s5,0x1
    8000613e:	97d6                	add	a5,a5,s5
    80006140:	07b2                	slli	a5,a5,0xc
    80006142:	0001cb97          	auipc	s7,0x1c
    80006146:	ebeb8b93          	addi	s7,s7,-322 # 80022000 <disk>
    8000614a:	9bbe                	add	s7,s7,a5
    8000614c:	a8a9                	j	800061a6 <virtio_disk_rw+0xcc>
    8000614e:	00fb8733          	add	a4,s7,a5
    80006152:	9742                	add	a4,a4,a6
    80006154:	00070c23          	sb	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    idx[i] = alloc_desc(n);
    80006158:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000615a:	0207c263          	bltz	a5,8000617e <virtio_disk_rw+0xa4>
  for(int i = 0; i < 3; i++){
    8000615e:	2905                	addiw	s2,s2,1
    80006160:	0611                	addi	a2,a2,4
    80006162:	1ca90463          	beq	s2,a0,8000632a <virtio_disk_rw+0x250>
    idx[i] = alloc_desc(n);
    80006166:	85b2                	mv	a1,a2
    80006168:	874e                	mv	a4,s3
  for(int i = 0; i < NUM; i++){
    8000616a:	87d2                	mv	a5,s4
    if(disk[n].free[i]){
    8000616c:	00074683          	lbu	a3,0(a4)
    80006170:	fef9                	bnez	a3,8000614e <virtio_disk_rw+0x74>
  for(int i = 0; i < NUM; i++){
    80006172:	2785                	addiw	a5,a5,1
    80006174:	0705                	addi	a4,a4,1
    80006176:	fe979be3          	bne	a5,s1,8000616c <virtio_disk_rw+0x92>
    idx[i] = alloc_desc(n);
    8000617a:	57fd                	li	a5,-1
    8000617c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000617e:	01205e63          	blez	s2,8000619a <virtio_disk_rw+0xc0>
    80006182:	8d52                	mv	s10,s4
        free_desc(n, idx[j]);
    80006184:	000b2583          	lw	a1,0(s6)
    80006188:	8556                	mv	a0,s5
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	ccc080e7          	jalr	-820(ra) # 80005e56 <free_desc>
      for(int j = 0; j < i; j++)
    80006192:	2d05                	addiw	s10,s10,1
    80006194:	0b11                	addi	s6,s6,4
    80006196:	ffa917e3          	bne	s2,s10,80006184 <virtio_disk_rw+0xaa>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    8000619a:	85e6                	mv	a1,s9
    8000619c:	854e                	mv	a0,s3
    8000619e:	ffffc097          	auipc	ra,0xffffc
    800061a2:	07a080e7          	jalr	122(ra) # 80002218 <sleep>
  for(int i = 0; i < 3; i++){
    800061a6:	f8040b13          	addi	s6,s0,-128
{
    800061aa:	865a                	mv	a2,s6
  for(int i = 0; i < 3; i++){
    800061ac:	8952                	mv	s2,s4
      disk[n].free[i] = 0;
    800061ae:	6809                	lui	a6,0x2
  for(int i = 0; i < 3; i++){
    800061b0:	450d                	li	a0,3
    800061b2:	bf55                	j	80006166 <virtio_disk_rw+0x8c>
  disk[n].desc[idx[0]].next = idx[1];

  disk[n].desc[idx[1]].addr = (uint64) b->data;
  disk[n].desc[idx[1]].len = BSIZE;
  if(write)
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    800061b4:	001a9793          	slli	a5,s5,0x1
    800061b8:	97d6                	add	a5,a5,s5
    800061ba:	07b2                	slli	a5,a5,0xc
    800061bc:	0001c717          	auipc	a4,0x1c
    800061c0:	e4470713          	addi	a4,a4,-444 # 80022000 <disk>
    800061c4:	973e                	add	a4,a4,a5
    800061c6:	6789                	lui	a5,0x2
    800061c8:	97ba                	add	a5,a5,a4
    800061ca:	639c                	ld	a5,0(a5)
    800061cc:	97b6                	add	a5,a5,a3
    800061ce:	00079623          	sh	zero,12(a5) # 200c <_entry-0x7fffdff4>
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800061d2:	0001c517          	auipc	a0,0x1c
    800061d6:	e2e50513          	addi	a0,a0,-466 # 80022000 <disk>
    800061da:	001a9793          	slli	a5,s5,0x1
    800061de:	01578733          	add	a4,a5,s5
    800061e2:	0732                	slli	a4,a4,0xc
    800061e4:	972a                	add	a4,a4,a0
    800061e6:	6609                	lui	a2,0x2
    800061e8:	9732                	add	a4,a4,a2
    800061ea:	6310                	ld	a2,0(a4)
    800061ec:	9636                	add	a2,a2,a3
    800061ee:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    800061f2:	0015e593          	ori	a1,a1,1
    800061f6:	00b61623          	sh	a1,12(a2)
  disk[n].desc[idx[1]].next = idx[2];
    800061fa:	f8842603          	lw	a2,-120(s0)
    800061fe:	630c                	ld	a1,0(a4)
    80006200:	96ae                	add	a3,a3,a1
    80006202:	00c69723          	sh	a2,14(a3) # 100e <_entry-0x7fffeff2>

  disk[n].info[idx[0]].status = 0;
    80006206:	97d6                	add	a5,a5,s5
    80006208:	07a2                	slli	a5,a5,0x8
    8000620a:	97a6                	add	a5,a5,s1
    8000620c:	20078793          	addi	a5,a5,512
    80006210:	0792                	slli	a5,a5,0x4
    80006212:	97aa                	add	a5,a5,a0
    80006214:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    80006218:	00461693          	slli	a3,a2,0x4
    8000621c:	00073803          	ld	a6,0(a4)
    80006220:	9836                	add	a6,a6,a3
    80006222:	20348613          	addi	a2,s1,515
    80006226:	001a9593          	slli	a1,s5,0x1
    8000622a:	95d6                	add	a1,a1,s5
    8000622c:	05a2                	slli	a1,a1,0x8
    8000622e:	962e                	add	a2,a2,a1
    80006230:	0612                	slli	a2,a2,0x4
    80006232:	962a                	add	a2,a2,a0
    80006234:	00c83023          	sd	a2,0(a6) # 2000 <_entry-0x7fffe000>
  disk[n].desc[idx[2]].len = 1;
    80006238:	630c                	ld	a1,0(a4)
    8000623a:	95b6                	add	a1,a1,a3
    8000623c:	4605                	li	a2,1
    8000623e:	c590                	sw	a2,8(a1)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006240:	630c                	ld	a1,0(a4)
    80006242:	95b6                	add	a1,a1,a3
    80006244:	4509                	li	a0,2
    80006246:	00a59623          	sh	a0,12(a1)
  disk[n].desc[idx[2]].next = 0;
    8000624a:	630c                	ld	a1,0(a4)
    8000624c:	96ae                	add	a3,a3,a1
    8000624e:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006252:	00cc2223          	sw	a2,4(s8) # fffffffffffff004 <end+0xffffffff7ffd6fa8>
  disk[n].info[idx[0]].b = b;
    80006256:	0387b423          	sd	s8,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    8000625a:	6714                	ld	a3,8(a4)
    8000625c:	0026d783          	lhu	a5,2(a3)
    80006260:	8b9d                	andi	a5,a5,7
    80006262:	0789                	addi	a5,a5,2
    80006264:	0786                	slli	a5,a5,0x1
    80006266:	97b6                	add	a5,a5,a3
    80006268:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000626c:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    80006270:	6718                	ld	a4,8(a4)
    80006272:	00275783          	lhu	a5,2(a4)
    80006276:	2785                	addiw	a5,a5,1
    80006278:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000627c:	001a879b          	addiw	a5,s5,1
    80006280:	00c7979b          	slliw	a5,a5,0xc
    80006284:	10000737          	lui	a4,0x10000
    80006288:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    8000628c:	97ba                	add	a5,a5,a4
    8000628e:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006292:	004c2783          	lw	a5,4(s8)
    80006296:	00c79d63          	bne	a5,a2,800062b0 <virtio_disk_rw+0x1d6>
    8000629a:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    8000629c:	85e6                	mv	a1,s9
    8000629e:	8562                	mv	a0,s8
    800062a0:	ffffc097          	auipc	ra,0xffffc
    800062a4:	f78080e7          	jalr	-136(ra) # 80002218 <sleep>
  while(b->disk == 1) {
    800062a8:	004c2783          	lw	a5,4(s8)
    800062ac:	fe9788e3          	beq	a5,s1,8000629c <virtio_disk_rw+0x1c2>
  }

  disk[n].info[idx[0]].b = 0;
    800062b0:	f8042483          	lw	s1,-128(s0)
    800062b4:	001a9793          	slli	a5,s5,0x1
    800062b8:	97d6                	add	a5,a5,s5
    800062ba:	07a2                	slli	a5,a5,0x8
    800062bc:	97a6                	add	a5,a5,s1
    800062be:	20078793          	addi	a5,a5,512
    800062c2:	0792                	slli	a5,a5,0x4
    800062c4:	0001c717          	auipc	a4,0x1c
    800062c8:	d3c70713          	addi	a4,a4,-708 # 80022000 <disk>
    800062cc:	97ba                	add	a5,a5,a4
    800062ce:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    800062d2:	001a9793          	slli	a5,s5,0x1
    800062d6:	97d6                	add	a5,a5,s5
    800062d8:	07b2                	slli	a5,a5,0xc
    800062da:	97ba                	add	a5,a5,a4
    800062dc:	6909                	lui	s2,0x2
    800062de:	993e                	add	s2,s2,a5
    800062e0:	a019                	j	800062e6 <virtio_disk_rw+0x20c>
      i = disk[n].desc[i].next;
    800062e2:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    800062e6:	85a6                	mv	a1,s1
    800062e8:	8556                	mv	a0,s5
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	b6c080e7          	jalr	-1172(ra) # 80005e56 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    800062f2:	0492                	slli	s1,s1,0x4
    800062f4:	00093783          	ld	a5,0(s2) # 2000 <_entry-0x7fffe000>
    800062f8:	94be                	add	s1,s1,a5
    800062fa:	00c4d783          	lhu	a5,12(s1)
    800062fe:	8b85                	andi	a5,a5,1
    80006300:	f3ed                	bnez	a5,800062e2 <virtio_disk_rw+0x208>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    80006302:	8566                	mv	a0,s9
    80006304:	ffffb097          	auipc	ra,0xffffb
    80006308:	86c080e7          	jalr	-1940(ra) # 80000b70 <release>
}
    8000630c:	60ea                	ld	ra,152(sp)
    8000630e:	644a                	ld	s0,144(sp)
    80006310:	64aa                	ld	s1,136(sp)
    80006312:	690a                	ld	s2,128(sp)
    80006314:	79e6                	ld	s3,120(sp)
    80006316:	7a46                	ld	s4,112(sp)
    80006318:	7aa6                	ld	s5,104(sp)
    8000631a:	7b06                	ld	s6,96(sp)
    8000631c:	6be6                	ld	s7,88(sp)
    8000631e:	6c46                	ld	s8,80(sp)
    80006320:	6ca6                	ld	s9,72(sp)
    80006322:	6d06                	ld	s10,64(sp)
    80006324:	7de2                	ld	s11,56(sp)
    80006326:	610d                	addi	sp,sp,160
    80006328:	8082                	ret
  if(write)
    8000632a:	01b037b3          	snez	a5,s11
    8000632e:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    80006332:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006336:	f6843783          	ld	a5,-152(s0)
    8000633a:	f6f43c23          	sd	a5,-136(s0)
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    8000633e:	f8042483          	lw	s1,-128(s0)
    80006342:	00449993          	slli	s3,s1,0x4
    80006346:	001a9793          	slli	a5,s5,0x1
    8000634a:	97d6                	add	a5,a5,s5
    8000634c:	07b2                	slli	a5,a5,0xc
    8000634e:	0001c917          	auipc	s2,0x1c
    80006352:	cb290913          	addi	s2,s2,-846 # 80022000 <disk>
    80006356:	97ca                	add	a5,a5,s2
    80006358:	6909                	lui	s2,0x2
    8000635a:	993e                	add	s2,s2,a5
    8000635c:	00093a03          	ld	s4,0(s2) # 2000 <_entry-0x7fffe000>
    80006360:	9a4e                	add	s4,s4,s3
    80006362:	f7040513          	addi	a0,s0,-144
    80006366:	ffffb097          	auipc	ra,0xffffb
    8000636a:	e44080e7          	jalr	-444(ra) # 800011aa <kvmpa>
    8000636e:	00aa3023          	sd	a0,0(s4)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    80006372:	00093783          	ld	a5,0(s2)
    80006376:	97ce                	add	a5,a5,s3
    80006378:	4741                	li	a4,16
    8000637a:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000637c:	00093783          	ld	a5,0(s2)
    80006380:	97ce                	add	a5,a5,s3
    80006382:	4705                	li	a4,1
    80006384:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    80006388:	f8442683          	lw	a3,-124(s0)
    8000638c:	00093783          	ld	a5,0(s2)
    80006390:	99be                	add	s3,s3,a5
    80006392:	00d99723          	sh	a3,14(s3)
  disk[n].desc[idx[1]].addr = (uint64) b->data;
    80006396:	0692                	slli	a3,a3,0x4
    80006398:	00093783          	ld	a5,0(s2)
    8000639c:	97b6                	add	a5,a5,a3
    8000639e:	060c0713          	addi	a4,s8,96
    800063a2:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    800063a4:	00093783          	ld	a5,0(s2)
    800063a8:	97b6                	add	a5,a5,a3
    800063aa:	40000713          	li	a4,1024
    800063ae:	c798                	sw	a4,8(a5)
  if(write)
    800063b0:	e00d92e3          	bnez	s11,800061b4 <virtio_disk_rw+0xda>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800063b4:	001a9793          	slli	a5,s5,0x1
    800063b8:	97d6                	add	a5,a5,s5
    800063ba:	07b2                	slli	a5,a5,0xc
    800063bc:	0001c717          	auipc	a4,0x1c
    800063c0:	c4470713          	addi	a4,a4,-956 # 80022000 <disk>
    800063c4:	973e                	add	a4,a4,a5
    800063c6:	6789                	lui	a5,0x2
    800063c8:	97ba                	add	a5,a5,a4
    800063ca:	639c                	ld	a5,0(a5)
    800063cc:	97b6                	add	a5,a5,a3
    800063ce:	4709                	li	a4,2
    800063d0:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    800063d4:	bbfd                	j	800061d2 <virtio_disk_rw+0xf8>

00000000800063d6 <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    800063d6:	7139                	addi	sp,sp,-64
    800063d8:	fc06                	sd	ra,56(sp)
    800063da:	f822                	sd	s0,48(sp)
    800063dc:	f426                	sd	s1,40(sp)
    800063de:	f04a                	sd	s2,32(sp)
    800063e0:	ec4e                	sd	s3,24(sp)
    800063e2:	e852                	sd	s4,16(sp)
    800063e4:	e456                	sd	s5,8(sp)
    800063e6:	0080                	addi	s0,sp,64
    800063e8:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    800063ea:	00151913          	slli	s2,a0,0x1
    800063ee:	00a90a33          	add	s4,s2,a0
    800063f2:	0a32                	slli	s4,s4,0xc
    800063f4:	6989                	lui	s3,0x2
    800063f6:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    800063fa:	9a3e                	add	s4,s4,a5
    800063fc:	0001ca97          	auipc	s5,0x1c
    80006400:	c04a8a93          	addi	s5,s5,-1020 # 80022000 <disk>
    80006404:	9a56                	add	s4,s4,s5
    80006406:	8552                	mv	a0,s4
    80006408:	ffffa097          	auipc	ra,0xffffa
    8000640c:	698080e7          	jalr	1688(ra) # 80000aa0 <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    80006410:	9926                	add	s2,s2,s1
    80006412:	0932                	slli	s2,s2,0xc
    80006414:	9956                	add	s2,s2,s5
    80006416:	99ca                	add	s3,s3,s2
    80006418:	0209d783          	lhu	a5,32(s3)
    8000641c:	0109b703          	ld	a4,16(s3)
    80006420:	00275683          	lhu	a3,2(a4)
    80006424:	8ebd                	xor	a3,a3,a5
    80006426:	8a9d                	andi	a3,a3,7
    80006428:	c2a5                	beqz	a3,80006488 <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    8000642a:	8956                	mv	s2,s5
    8000642c:	00149693          	slli	a3,s1,0x1
    80006430:	96a6                	add	a3,a3,s1
    80006432:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006436:	06b2                	slli	a3,a3,0xc
    80006438:	96d6                	add	a3,a3,s5
    8000643a:	6489                	lui	s1,0x2
    8000643c:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    8000643e:	078e                	slli	a5,a5,0x3
    80006440:	97ba                	add	a5,a5,a4
    80006442:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    80006444:	00f98733          	add	a4,s3,a5
    80006448:	20070713          	addi	a4,a4,512
    8000644c:	0712                	slli	a4,a4,0x4
    8000644e:	974a                	add	a4,a4,s2
    80006450:	03074703          	lbu	a4,48(a4)
    80006454:	eb21                	bnez	a4,800064a4 <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    80006456:	97ce                	add	a5,a5,s3
    80006458:	20078793          	addi	a5,a5,512
    8000645c:	0792                	slli	a5,a5,0x4
    8000645e:	97ca                	add	a5,a5,s2
    80006460:	7798                	ld	a4,40(a5)
    80006462:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    80006466:	7788                	ld	a0,40(a5)
    80006468:	ffffc097          	auipc	ra,0xffffc
    8000646c:	f30080e7          	jalr	-208(ra) # 80002398 <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006470:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    80006474:	2785                	addiw	a5,a5,1
    80006476:	8b9d                	andi	a5,a5,7
    80006478:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    8000647c:	6898                	ld	a4,16(s1)
    8000647e:	00275683          	lhu	a3,2(a4)
    80006482:	8a9d                	andi	a3,a3,7
    80006484:	faf69de3          	bne	a3,a5,8000643e <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    80006488:	8552                	mv	a0,s4
    8000648a:	ffffa097          	auipc	ra,0xffffa
    8000648e:	6e6080e7          	jalr	1766(ra) # 80000b70 <release>
}
    80006492:	70e2                	ld	ra,56(sp)
    80006494:	7442                	ld	s0,48(sp)
    80006496:	74a2                	ld	s1,40(sp)
    80006498:	7902                	ld	s2,32(sp)
    8000649a:	69e2                	ld	s3,24(sp)
    8000649c:	6a42                	ld	s4,16(sp)
    8000649e:	6aa2                	ld	s5,8(sp)
    800064a0:	6121                	addi	sp,sp,64
    800064a2:	8082                	ret
      panic("virtio_disk_intr status");
    800064a4:	00002517          	auipc	a0,0x2
    800064a8:	71c50513          	addi	a0,a0,1820 # 80008bc0 <userret+0xb30>
    800064ac:	ffffa097          	auipc	ra,0xffffa
    800064b0:	0a8080e7          	jalr	168(ra) # 80000554 <panic>

00000000800064b4 <bit_isset>:
static Sz_info *bd_sizes; 
static void *bd_base;   // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    800064b4:	1141                	addi	sp,sp,-16
    800064b6:	e422                	sd	s0,8(sp)
    800064b8:	0800                	addi	s0,sp,16
  char b = array[index/8];
  char m = (1 << (index % 8));
    800064ba:	41f5d79b          	sraiw	a5,a1,0x1f
    800064be:	01d7d79b          	srliw	a5,a5,0x1d
    800064c2:	9dbd                	addw	a1,a1,a5
    800064c4:	0075f713          	andi	a4,a1,7
    800064c8:	9f1d                	subw	a4,a4,a5
    800064ca:	4785                	li	a5,1
    800064cc:	00e797bb          	sllw	a5,a5,a4
    800064d0:	0ff7f793          	andi	a5,a5,255
  char b = array[index/8];
    800064d4:	4035d59b          	sraiw	a1,a1,0x3
    800064d8:	95aa                	add	a1,a1,a0
  return (b & m) == m;
    800064da:	0005c503          	lbu	a0,0(a1)
    800064de:	8d7d                	and	a0,a0,a5
    800064e0:	8d1d                	sub	a0,a0,a5
}
    800064e2:	00153513          	seqz	a0,a0
    800064e6:	6422                	ld	s0,8(sp)
    800064e8:	0141                	addi	sp,sp,16
    800064ea:	8082                	ret

00000000800064ec <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    800064ec:	1141                	addi	sp,sp,-16
    800064ee:	e422                	sd	s0,8(sp)
    800064f0:	0800                	addi	s0,sp,16
  char b = array[index/8];
    800064f2:	41f5d79b          	sraiw	a5,a1,0x1f
    800064f6:	01d7d79b          	srliw	a5,a5,0x1d
    800064fa:	9dbd                	addw	a1,a1,a5
    800064fc:	4035d71b          	sraiw	a4,a1,0x3
    80006500:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    80006502:	899d                	andi	a1,a1,7
    80006504:	9d9d                	subw	a1,a1,a5
    80006506:	4785                	li	a5,1
    80006508:	00b795bb          	sllw	a1,a5,a1
  array[index/8] = (b | m);
    8000650c:	00054783          	lbu	a5,0(a0)
    80006510:	8ddd                	or	a1,a1,a5
    80006512:	00b50023          	sb	a1,0(a0)
}
    80006516:	6422                	ld	s0,8(sp)
    80006518:	0141                	addi	sp,sp,16
    8000651a:	8082                	ret

000000008000651c <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    8000651c:	1141                	addi	sp,sp,-16
    8000651e:	e422                	sd	s0,8(sp)
    80006520:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006522:	41f5d79b          	sraiw	a5,a1,0x1f
    80006526:	01d7d79b          	srliw	a5,a5,0x1d
    8000652a:	9dbd                	addw	a1,a1,a5
    8000652c:	4035d71b          	sraiw	a4,a1,0x3
    80006530:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    80006532:	899d                	andi	a1,a1,7
    80006534:	9d9d                	subw	a1,a1,a5
    80006536:	4785                	li	a5,1
    80006538:	00b795bb          	sllw	a1,a5,a1
  array[index/8] = (b & ~m);
    8000653c:	fff5c593          	not	a1,a1
    80006540:	00054783          	lbu	a5,0(a0)
    80006544:	8dfd                	and	a1,a1,a5
    80006546:	00b50023          	sb	a1,0(a0)
}
    8000654a:	6422                	ld	s0,8(sp)
    8000654c:	0141                	addi	sp,sp,16
    8000654e:	8082                	ret

0000000080006550 <bd_print_vector>:

// Print a bit vector as a list of ranges of 1 bits
void
bd_print_vector(char *vector, int len) {
    80006550:	715d                	addi	sp,sp,-80
    80006552:	e486                	sd	ra,72(sp)
    80006554:	e0a2                	sd	s0,64(sp)
    80006556:	fc26                	sd	s1,56(sp)
    80006558:	f84a                	sd	s2,48(sp)
    8000655a:	f44e                	sd	s3,40(sp)
    8000655c:	f052                	sd	s4,32(sp)
    8000655e:	ec56                	sd	s5,24(sp)
    80006560:	e85a                	sd	s6,16(sp)
    80006562:	e45e                	sd	s7,8(sp)
    80006564:	0880                	addi	s0,sp,80
    80006566:	8a2e                	mv	s4,a1
  int last, lb;
  
  last = 1;
  lb = 0;
  for (int b = 0; b < len; b++) {
    80006568:	08b05b63          	blez	a1,800065fe <bd_print_vector+0xae>
    8000656c:	89aa                	mv	s3,a0
    8000656e:	4481                	li	s1,0
  lb = 0;
    80006570:	4a81                	li	s5,0
  last = 1;
    80006572:	4905                	li	s2,1
    if (last == bit_isset(vector, b))
      continue;
    if(last == 1)
    80006574:	4b05                	li	s6,1
      printf(" [%d, %d)", lb, b);
    80006576:	00002b97          	auipc	s7,0x2
    8000657a:	662b8b93          	addi	s7,s7,1634 # 80008bd8 <userret+0xb48>
    8000657e:	a821                	j	80006596 <bd_print_vector+0x46>
    lb = b;
    last = bit_isset(vector, b);
    80006580:	85a6                	mv	a1,s1
    80006582:	854e                	mv	a0,s3
    80006584:	00000097          	auipc	ra,0x0
    80006588:	f30080e7          	jalr	-208(ra) # 800064b4 <bit_isset>
    8000658c:	892a                	mv	s2,a0
    8000658e:	8aa6                	mv	s5,s1
  for (int b = 0; b < len; b++) {
    80006590:	2485                	addiw	s1,s1,1
    80006592:	029a0463          	beq	s4,s1,800065ba <bd_print_vector+0x6a>
    if (last == bit_isset(vector, b))
    80006596:	85a6                	mv	a1,s1
    80006598:	854e                	mv	a0,s3
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	f1a080e7          	jalr	-230(ra) # 800064b4 <bit_isset>
    800065a2:	ff2507e3          	beq	a0,s2,80006590 <bd_print_vector+0x40>
    if(last == 1)
    800065a6:	fd691de3          	bne	s2,s6,80006580 <bd_print_vector+0x30>
      printf(" [%d, %d)", lb, b);
    800065aa:	8626                	mv	a2,s1
    800065ac:	85d6                	mv	a1,s5
    800065ae:	855e                	mv	a0,s7
    800065b0:	ffffa097          	auipc	ra,0xffffa
    800065b4:	ffe080e7          	jalr	-2(ra) # 800005ae <printf>
    800065b8:	b7e1                	j	80006580 <bd_print_vector+0x30>
  }
  if(lb == 0 || last == 1) {
    800065ba:	000a8563          	beqz	s5,800065c4 <bd_print_vector+0x74>
    800065be:	4785                	li	a5,1
    800065c0:	00f91c63          	bne	s2,a5,800065d8 <bd_print_vector+0x88>
    printf(" [%d, %d)", lb, len);
    800065c4:	8652                	mv	a2,s4
    800065c6:	85d6                	mv	a1,s5
    800065c8:	00002517          	auipc	a0,0x2
    800065cc:	61050513          	addi	a0,a0,1552 # 80008bd8 <userret+0xb48>
    800065d0:	ffffa097          	auipc	ra,0xffffa
    800065d4:	fde080e7          	jalr	-34(ra) # 800005ae <printf>
  }
  printf("\n");
    800065d8:	00002517          	auipc	a0,0x2
    800065dc:	cb850513          	addi	a0,a0,-840 # 80008290 <userret+0x200>
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	fce080e7          	jalr	-50(ra) # 800005ae <printf>
}
    800065e8:	60a6                	ld	ra,72(sp)
    800065ea:	6406                	ld	s0,64(sp)
    800065ec:	74e2                	ld	s1,56(sp)
    800065ee:	7942                	ld	s2,48(sp)
    800065f0:	79a2                	ld	s3,40(sp)
    800065f2:	7a02                	ld	s4,32(sp)
    800065f4:	6ae2                	ld	s5,24(sp)
    800065f6:	6b42                	ld	s6,16(sp)
    800065f8:	6ba2                	ld	s7,8(sp)
    800065fa:	6161                	addi	sp,sp,80
    800065fc:	8082                	ret
  lb = 0;
    800065fe:	4a81                	li	s5,0
    80006600:	b7d1                	j	800065c4 <bd_print_vector+0x74>

0000000080006602 <bd_print>:

// Print buddy's data structures
void
bd_print() {
  for (int k = 0; k < nsizes; k++) {
    80006602:	00022697          	auipc	a3,0x22
    80006606:	a566a683          	lw	a3,-1450(a3) # 80028058 <nsizes>
    8000660a:	10d05063          	blez	a3,8000670a <bd_print+0x108>
bd_print() {
    8000660e:	711d                	addi	sp,sp,-96
    80006610:	ec86                	sd	ra,88(sp)
    80006612:	e8a2                	sd	s0,80(sp)
    80006614:	e4a6                	sd	s1,72(sp)
    80006616:	e0ca                	sd	s2,64(sp)
    80006618:	fc4e                	sd	s3,56(sp)
    8000661a:	f852                	sd	s4,48(sp)
    8000661c:	f456                	sd	s5,40(sp)
    8000661e:	f05a                	sd	s6,32(sp)
    80006620:	ec5e                	sd	s7,24(sp)
    80006622:	e862                	sd	s8,16(sp)
    80006624:	e466                	sd	s9,8(sp)
    80006626:	e06a                	sd	s10,0(sp)
    80006628:	1080                	addi	s0,sp,96
  for (int k = 0; k < nsizes; k++) {
    8000662a:	4481                	li	s1,0
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    8000662c:	4a85                	li	s5,1
    8000662e:	4c41                	li	s8,16
    80006630:	00002b97          	auipc	s7,0x2
    80006634:	5b8b8b93          	addi	s7,s7,1464 # 80008be8 <userret+0xb58>
    lst_print(&bd_sizes[k].free);
    80006638:	00022a17          	auipc	s4,0x22
    8000663c:	a18a0a13          	addi	s4,s4,-1512 # 80028050 <bd_sizes>
    printf("  alloc:");
    80006640:	00002b17          	auipc	s6,0x2
    80006644:	5d0b0b13          	addi	s6,s6,1488 # 80008c10 <userret+0xb80>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    80006648:	00022997          	auipc	s3,0x22
    8000664c:	a1098993          	addi	s3,s3,-1520 # 80028058 <nsizes>
    if(k > 0) {
      printf("  split:");
    80006650:	00002c97          	auipc	s9,0x2
    80006654:	5d0c8c93          	addi	s9,s9,1488 # 80008c20 <userret+0xb90>
    80006658:	a801                	j	80006668 <bd_print+0x66>
  for (int k = 0; k < nsizes; k++) {
    8000665a:	0009a683          	lw	a3,0(s3)
    8000665e:	0485                	addi	s1,s1,1
    80006660:	0004879b          	sext.w	a5,s1
    80006664:	08d7d563          	bge	a5,a3,800066ee <bd_print+0xec>
    80006668:	0004891b          	sext.w	s2,s1
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    8000666c:	36fd                	addiw	a3,a3,-1
    8000666e:	9e85                	subw	a3,a3,s1
    80006670:	00da96bb          	sllw	a3,s5,a3
    80006674:	009c1633          	sll	a2,s8,s1
    80006678:	85ca                	mv	a1,s2
    8000667a:	855e                	mv	a0,s7
    8000667c:	ffffa097          	auipc	ra,0xffffa
    80006680:	f32080e7          	jalr	-206(ra) # 800005ae <printf>
    lst_print(&bd_sizes[k].free);
    80006684:	00549d13          	slli	s10,s1,0x5
    80006688:	000a3503          	ld	a0,0(s4)
    8000668c:	956a                	add	a0,a0,s10
    8000668e:	00001097          	auipc	ra,0x1
    80006692:	a56080e7          	jalr	-1450(ra) # 800070e4 <lst_print>
    printf("  alloc:");
    80006696:	855a                	mv	a0,s6
    80006698:	ffffa097          	auipc	ra,0xffffa
    8000669c:	f16080e7          	jalr	-234(ra) # 800005ae <printf>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    800066a0:	0009a583          	lw	a1,0(s3)
    800066a4:	35fd                	addiw	a1,a1,-1
    800066a6:	412585bb          	subw	a1,a1,s2
    800066aa:	000a3783          	ld	a5,0(s4)
    800066ae:	97ea                	add	a5,a5,s10
    800066b0:	00ba95bb          	sllw	a1,s5,a1
    800066b4:	6b88                	ld	a0,16(a5)
    800066b6:	00000097          	auipc	ra,0x0
    800066ba:	e9a080e7          	jalr	-358(ra) # 80006550 <bd_print_vector>
    if(k > 0) {
    800066be:	f9205ee3          	blez	s2,8000665a <bd_print+0x58>
      printf("  split:");
    800066c2:	8566                	mv	a0,s9
    800066c4:	ffffa097          	auipc	ra,0xffffa
    800066c8:	eea080e7          	jalr	-278(ra) # 800005ae <printf>
      bd_print_vector(bd_sizes[k].split, NBLK(k));
    800066cc:	0009a583          	lw	a1,0(s3)
    800066d0:	35fd                	addiw	a1,a1,-1
    800066d2:	412585bb          	subw	a1,a1,s2
    800066d6:	000a3783          	ld	a5,0(s4)
    800066da:	9d3e                	add	s10,s10,a5
    800066dc:	00ba95bb          	sllw	a1,s5,a1
    800066e0:	018d3503          	ld	a0,24(s10)
    800066e4:	00000097          	auipc	ra,0x0
    800066e8:	e6c080e7          	jalr	-404(ra) # 80006550 <bd_print_vector>
    800066ec:	b7bd                	j	8000665a <bd_print+0x58>
    }
  }
}
    800066ee:	60e6                	ld	ra,88(sp)
    800066f0:	6446                	ld	s0,80(sp)
    800066f2:	64a6                	ld	s1,72(sp)
    800066f4:	6906                	ld	s2,64(sp)
    800066f6:	79e2                	ld	s3,56(sp)
    800066f8:	7a42                	ld	s4,48(sp)
    800066fa:	7aa2                	ld	s5,40(sp)
    800066fc:	7b02                	ld	s6,32(sp)
    800066fe:	6be2                	ld	s7,24(sp)
    80006700:	6c42                	ld	s8,16(sp)
    80006702:	6ca2                	ld	s9,8(sp)
    80006704:	6d02                	ld	s10,0(sp)
    80006706:	6125                	addi	sp,sp,96
    80006708:	8082                	ret
    8000670a:	8082                	ret

000000008000670c <firstk>:

// What is the first k such that 2^k >= n?
int
firstk(uint64 n) {
    8000670c:	1141                	addi	sp,sp,-16
    8000670e:	e422                	sd	s0,8(sp)
    80006710:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    80006712:	47c1                	li	a5,16
    80006714:	00a7fb63          	bgeu	a5,a0,8000672a <firstk+0x1e>
    80006718:	872a                	mv	a4,a0
  int k = 0;
    8000671a:	4501                	li	a0,0
    k++;
    8000671c:	2505                	addiw	a0,a0,1
    size *= 2;
    8000671e:	0786                	slli	a5,a5,0x1
  while (size < n) {
    80006720:	fee7eee3          	bltu	a5,a4,8000671c <firstk+0x10>
  }
  return k;
}
    80006724:	6422                	ld	s0,8(sp)
    80006726:	0141                	addi	sp,sp,16
    80006728:	8082                	ret
  int k = 0;
    8000672a:	4501                	li	a0,0
    8000672c:	bfe5                	j	80006724 <firstk+0x18>

000000008000672e <blk_index>:

// Compute the block index for address p at size k
int
blk_index(int k, char *p) {
    8000672e:	1141                	addi	sp,sp,-16
    80006730:	e422                	sd	s0,8(sp)
    80006732:	0800                	addi	s0,sp,16
  int n = p - (char *) bd_base;
  return n / BLK_SIZE(k);
    80006734:	00022797          	auipc	a5,0x22
    80006738:	9147b783          	ld	a5,-1772(a5) # 80028048 <bd_base>
    8000673c:	9d9d                	subw	a1,a1,a5
    8000673e:	47c1                	li	a5,16
    80006740:	00a797b3          	sll	a5,a5,a0
    80006744:	02f5c5b3          	div	a1,a1,a5
}
    80006748:	0005851b          	sext.w	a0,a1
    8000674c:	6422                	ld	s0,8(sp)
    8000674e:	0141                	addi	sp,sp,16
    80006750:	8082                	ret

0000000080006752 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    80006752:	1141                	addi	sp,sp,-16
    80006754:	e422                	sd	s0,8(sp)
    80006756:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    80006758:	47c1                	li	a5,16
    8000675a:	00a797b3          	sll	a5,a5,a0
  return (char *) bd_base + n;
    8000675e:	02b787bb          	mulw	a5,a5,a1
}
    80006762:	00022517          	auipc	a0,0x22
    80006766:	8e653503          	ld	a0,-1818(a0) # 80028048 <bd_base>
    8000676a:	953e                	add	a0,a0,a5
    8000676c:	6422                	ld	s0,8(sp)
    8000676e:	0141                	addi	sp,sp,16
    80006770:	8082                	ret

0000000080006772 <bd_malloc>:

// allocate nbytes, but malloc won't return anything smaller than LEAF_SIZE
void *
bd_malloc(uint64 nbytes)
{
    80006772:	7159                	addi	sp,sp,-112
    80006774:	f486                	sd	ra,104(sp)
    80006776:	f0a2                	sd	s0,96(sp)
    80006778:	eca6                	sd	s1,88(sp)
    8000677a:	e8ca                	sd	s2,80(sp)
    8000677c:	e4ce                	sd	s3,72(sp)
    8000677e:	e0d2                	sd	s4,64(sp)
    80006780:	fc56                	sd	s5,56(sp)
    80006782:	f85a                	sd	s6,48(sp)
    80006784:	f45e                	sd	s7,40(sp)
    80006786:	f062                	sd	s8,32(sp)
    80006788:	ec66                	sd	s9,24(sp)
    8000678a:	e86a                	sd	s10,16(sp)
    8000678c:	e46e                	sd	s11,8(sp)
    8000678e:	1880                	addi	s0,sp,112
    80006790:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    80006792:	00022517          	auipc	a0,0x22
    80006796:	86e50513          	addi	a0,a0,-1938 # 80028000 <lock>
    8000679a:	ffffa097          	auipc	ra,0xffffa
    8000679e:	306080e7          	jalr	774(ra) # 80000aa0 <acquire>

  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    800067a2:	8526                	mv	a0,s1
    800067a4:	00000097          	auipc	ra,0x0
    800067a8:	f68080e7          	jalr	-152(ra) # 8000670c <firstk>
  for (k = fk; k < nsizes; k++) {
    800067ac:	00022797          	auipc	a5,0x22
    800067b0:	8ac7a783          	lw	a5,-1876(a5) # 80028058 <nsizes>
    800067b4:	02f55d63          	bge	a0,a5,800067ee <bd_malloc+0x7c>
    800067b8:	8c2a                	mv	s8,a0
    800067ba:	00551913          	slli	s2,a0,0x5
    800067be:	84aa                	mv	s1,a0
    if(!lst_empty(&bd_sizes[k].free))
    800067c0:	00022997          	auipc	s3,0x22
    800067c4:	89098993          	addi	s3,s3,-1904 # 80028050 <bd_sizes>
  for (k = fk; k < nsizes; k++) {
    800067c8:	00022a17          	auipc	s4,0x22
    800067cc:	890a0a13          	addi	s4,s4,-1904 # 80028058 <nsizes>
    if(!lst_empty(&bd_sizes[k].free))
    800067d0:	0009b503          	ld	a0,0(s3)
    800067d4:	954a                	add	a0,a0,s2
    800067d6:	00001097          	auipc	ra,0x1
    800067da:	894080e7          	jalr	-1900(ra) # 8000706a <lst_empty>
    800067de:	c115                	beqz	a0,80006802 <bd_malloc+0x90>
  for (k = fk; k < nsizes; k++) {
    800067e0:	2485                	addiw	s1,s1,1
    800067e2:	02090913          	addi	s2,s2,32
    800067e6:	000a2783          	lw	a5,0(s4)
    800067ea:	fef4c3e3          	blt	s1,a5,800067d0 <bd_malloc+0x5e>
      break;
  }
  if(k >= nsizes) { // No free blocks?
    release(&lock);
    800067ee:	00022517          	auipc	a0,0x22
    800067f2:	81250513          	addi	a0,a0,-2030 # 80028000 <lock>
    800067f6:	ffffa097          	auipc	ra,0xffffa
    800067fa:	37a080e7          	jalr	890(ra) # 80000b70 <release>
    return 0;
    800067fe:	4b01                	li	s6,0
    80006800:	a0e1                	j	800068c8 <bd_malloc+0x156>
  if(k >= nsizes) { // No free blocks?
    80006802:	00022797          	auipc	a5,0x22
    80006806:	8567a783          	lw	a5,-1962(a5) # 80028058 <nsizes>
    8000680a:	fef4d2e3          	bge	s1,a5,800067ee <bd_malloc+0x7c>
  }

  // Found a block; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    8000680e:	00549993          	slli	s3,s1,0x5
    80006812:	00022917          	auipc	s2,0x22
    80006816:	83e90913          	addi	s2,s2,-1986 # 80028050 <bd_sizes>
    8000681a:	00093503          	ld	a0,0(s2)
    8000681e:	954e                	add	a0,a0,s3
    80006820:	00001097          	auipc	ra,0x1
    80006824:	876080e7          	jalr	-1930(ra) # 80007096 <lst_pop>
    80006828:	8b2a                	mv	s6,a0
  return n / BLK_SIZE(k);
    8000682a:	00022597          	auipc	a1,0x22
    8000682e:	81e5b583          	ld	a1,-2018(a1) # 80028048 <bd_base>
    80006832:	40b505bb          	subw	a1,a0,a1
    80006836:	47c1                	li	a5,16
    80006838:	009797b3          	sll	a5,a5,s1
    8000683c:	02f5c5b3          	div	a1,a1,a5
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    80006840:	00093783          	ld	a5,0(s2)
    80006844:	97ce                	add	a5,a5,s3
    80006846:	2581                	sext.w	a1,a1
    80006848:	6b88                	ld	a0,16(a5)
    8000684a:	00000097          	auipc	ra,0x0
    8000684e:	ca2080e7          	jalr	-862(ra) # 800064ec <bit_set>
  for(; k > fk; k--) {
    80006852:	069c5363          	bge	s8,s1,800068b8 <bd_malloc+0x146>
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80006856:	4bc1                	li	s7,16
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006858:	8dca                	mv	s11,s2
  int n = p - (char *) bd_base;
    8000685a:	00021d17          	auipc	s10,0x21
    8000685e:	7eed0d13          	addi	s10,s10,2030 # 80028048 <bd_base>
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80006862:	85a6                	mv	a1,s1
    80006864:	34fd                	addiw	s1,s1,-1
    80006866:	009b9ab3          	sll	s5,s7,s1
    8000686a:	015b0cb3          	add	s9,s6,s5
    bit_set(bd_sizes[k].split, blk_index(k, p));
    8000686e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
  int n = p - (char *) bd_base;
    80006872:	000d3903          	ld	s2,0(s10)
  return n / BLK_SIZE(k);
    80006876:	412b093b          	subw	s2,s6,s2
    8000687a:	00bb95b3          	sll	a1,s7,a1
    8000687e:	02b945b3          	div	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006882:	013a07b3          	add	a5,s4,s3
    80006886:	2581                	sext.w	a1,a1
    80006888:	6f88                	ld	a0,24(a5)
    8000688a:	00000097          	auipc	ra,0x0
    8000688e:	c62080e7          	jalr	-926(ra) # 800064ec <bit_set>
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    80006892:	1981                	addi	s3,s3,-32
    80006894:	9a4e                	add	s4,s4,s3
  return n / BLK_SIZE(k);
    80006896:	035945b3          	div	a1,s2,s5
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    8000689a:	2581                	sext.w	a1,a1
    8000689c:	010a3503          	ld	a0,16(s4)
    800068a0:	00000097          	auipc	ra,0x0
    800068a4:	c4c080e7          	jalr	-948(ra) # 800064ec <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    800068a8:	85e6                	mv	a1,s9
    800068aa:	8552                	mv	a0,s4
    800068ac:	00001097          	auipc	ra,0x1
    800068b0:	820080e7          	jalr	-2016(ra) # 800070cc <lst_push>
  for(; k > fk; k--) {
    800068b4:	fb8497e3          	bne	s1,s8,80006862 <bd_malloc+0xf0>
  }
  release(&lock);
    800068b8:	00021517          	auipc	a0,0x21
    800068bc:	74850513          	addi	a0,a0,1864 # 80028000 <lock>
    800068c0:	ffffa097          	auipc	ra,0xffffa
    800068c4:	2b0080e7          	jalr	688(ra) # 80000b70 <release>

  return p;
}
    800068c8:	855a                	mv	a0,s6
    800068ca:	70a6                	ld	ra,104(sp)
    800068cc:	7406                	ld	s0,96(sp)
    800068ce:	64e6                	ld	s1,88(sp)
    800068d0:	6946                	ld	s2,80(sp)
    800068d2:	69a6                	ld	s3,72(sp)
    800068d4:	6a06                	ld	s4,64(sp)
    800068d6:	7ae2                	ld	s5,56(sp)
    800068d8:	7b42                	ld	s6,48(sp)
    800068da:	7ba2                	ld	s7,40(sp)
    800068dc:	7c02                	ld	s8,32(sp)
    800068de:	6ce2                	ld	s9,24(sp)
    800068e0:	6d42                	ld	s10,16(sp)
    800068e2:	6da2                	ld	s11,8(sp)
    800068e4:	6165                	addi	sp,sp,112
    800068e6:	8082                	ret

00000000800068e8 <size>:

// Find the size of the block that p points to.
int
size(char *p) {
    800068e8:	7139                	addi	sp,sp,-64
    800068ea:	fc06                	sd	ra,56(sp)
    800068ec:	f822                	sd	s0,48(sp)
    800068ee:	f426                	sd	s1,40(sp)
    800068f0:	f04a                	sd	s2,32(sp)
    800068f2:	ec4e                	sd	s3,24(sp)
    800068f4:	e852                	sd	s4,16(sp)
    800068f6:	e456                	sd	s5,8(sp)
    800068f8:	e05a                	sd	s6,0(sp)
    800068fa:	0080                	addi	s0,sp,64
  for (int k = 0; k < nsizes; k++) {
    800068fc:	00021a97          	auipc	s5,0x21
    80006900:	75caaa83          	lw	s5,1884(s5) # 80028058 <nsizes>
  return n / BLK_SIZE(k);
    80006904:	00021a17          	auipc	s4,0x21
    80006908:	744a3a03          	ld	s4,1860(s4) # 80028048 <bd_base>
    8000690c:	41450a3b          	subw	s4,a0,s4
    80006910:	00021497          	auipc	s1,0x21
    80006914:	7404b483          	ld	s1,1856(s1) # 80028050 <bd_sizes>
    80006918:	03848493          	addi	s1,s1,56
  for (int k = 0; k < nsizes; k++) {
    8000691c:	4901                	li	s2,0
  return n / BLK_SIZE(k);
    8000691e:	4b41                	li	s6,16
  for (int k = 0; k < nsizes; k++) {
    80006920:	03595363          	bge	s2,s5,80006946 <size+0x5e>
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006924:	0019099b          	addiw	s3,s2,1
  return n / BLK_SIZE(k);
    80006928:	013b15b3          	sll	a1,s6,s3
    8000692c:	02ba45b3          	div	a1,s4,a1
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006930:	2581                	sext.w	a1,a1
    80006932:	6088                	ld	a0,0(s1)
    80006934:	00000097          	auipc	ra,0x0
    80006938:	b80080e7          	jalr	-1152(ra) # 800064b4 <bit_isset>
    8000693c:	02048493          	addi	s1,s1,32
    80006940:	e501                	bnez	a0,80006948 <size+0x60>
  for (int k = 0; k < nsizes; k++) {
    80006942:	894e                	mv	s2,s3
    80006944:	bff1                	j	80006920 <size+0x38>
      return k;
    }
  }
  return 0;
    80006946:	4901                	li	s2,0
}
    80006948:	854a                	mv	a0,s2
    8000694a:	70e2                	ld	ra,56(sp)
    8000694c:	7442                	ld	s0,48(sp)
    8000694e:	74a2                	ld	s1,40(sp)
    80006950:	7902                	ld	s2,32(sp)
    80006952:	69e2                	ld	s3,24(sp)
    80006954:	6a42                	ld	s4,16(sp)
    80006956:	6aa2                	ld	s5,8(sp)
    80006958:	6b02                	ld	s6,0(sp)
    8000695a:	6121                	addi	sp,sp,64
    8000695c:	8082                	ret

000000008000695e <bd_free>:

// Free memory pointed to by p, which was earlier allocated using
// bd_malloc.
void
bd_free(void *p) {
    8000695e:	7159                	addi	sp,sp,-112
    80006960:	f486                	sd	ra,104(sp)
    80006962:	f0a2                	sd	s0,96(sp)
    80006964:	eca6                	sd	s1,88(sp)
    80006966:	e8ca                	sd	s2,80(sp)
    80006968:	e4ce                	sd	s3,72(sp)
    8000696a:	e0d2                	sd	s4,64(sp)
    8000696c:	fc56                	sd	s5,56(sp)
    8000696e:	f85a                	sd	s6,48(sp)
    80006970:	f45e                	sd	s7,40(sp)
    80006972:	f062                	sd	s8,32(sp)
    80006974:	ec66                	sd	s9,24(sp)
    80006976:	e86a                	sd	s10,16(sp)
    80006978:	e46e                	sd	s11,8(sp)
    8000697a:	1880                	addi	s0,sp,112
    8000697c:	8aaa                	mv	s5,a0
  void *q;
  int k;

  acquire(&lock);
    8000697e:	00021517          	auipc	a0,0x21
    80006982:	68250513          	addi	a0,a0,1666 # 80028000 <lock>
    80006986:	ffffa097          	auipc	ra,0xffffa
    8000698a:	11a080e7          	jalr	282(ra) # 80000aa0 <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    8000698e:	8556                	mv	a0,s5
    80006990:	00000097          	auipc	ra,0x0
    80006994:	f58080e7          	jalr	-168(ra) # 800068e8 <size>
    80006998:	84aa                	mv	s1,a0
    8000699a:	00021797          	auipc	a5,0x21
    8000699e:	6be7a783          	lw	a5,1726(a5) # 80028058 <nsizes>
    800069a2:	37fd                	addiw	a5,a5,-1
    800069a4:	0cf55063          	bge	a0,a5,80006a64 <bd_free+0x106>
    800069a8:	00150a13          	addi	s4,a0,1
    800069ac:	0a16                	slli	s4,s4,0x5
  int n = p - (char *) bd_base;
    800069ae:	00021c17          	auipc	s8,0x21
    800069b2:	69ac0c13          	addi	s8,s8,1690 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    800069b6:	4bc1                	li	s7,16
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    800069b8:	00021b17          	auipc	s6,0x21
    800069bc:	698b0b13          	addi	s6,s6,1688 # 80028050 <bd_sizes>
  for (k = size(p); k < MAXSIZE; k++) {
    800069c0:	00021c97          	auipc	s9,0x21
    800069c4:	698c8c93          	addi	s9,s9,1688 # 80028058 <nsizes>
    800069c8:	a82d                	j	80006a02 <bd_free+0xa4>
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    800069ca:	fff58d9b          	addiw	s11,a1,-1
    800069ce:	a881                	j	80006a1e <bd_free+0xc0>
    if(buddy % 2 == 0) {
      p = q;
    }
    // at size k+1, mark that the merged buddy pair isn't split
    // anymore
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800069d0:	2485                	addiw	s1,s1,1
  int n = p - (char *) bd_base;
    800069d2:	000c3583          	ld	a1,0(s8)
  return n / BLK_SIZE(k);
    800069d6:	40ba85bb          	subw	a1,s5,a1
    800069da:	009b97b3          	sll	a5,s7,s1
    800069de:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800069e2:	000b3783          	ld	a5,0(s6)
    800069e6:	97d2                	add	a5,a5,s4
    800069e8:	2581                	sext.w	a1,a1
    800069ea:	6f88                	ld	a0,24(a5)
    800069ec:	00000097          	auipc	ra,0x0
    800069f0:	b30080e7          	jalr	-1232(ra) # 8000651c <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    800069f4:	020a0a13          	addi	s4,s4,32
    800069f8:	000ca783          	lw	a5,0(s9)
    800069fc:	37fd                	addiw	a5,a5,-1
    800069fe:	06f4d363          	bge	s1,a5,80006a64 <bd_free+0x106>
  int n = p - (char *) bd_base;
    80006a02:	000c3903          	ld	s2,0(s8)
  return n / BLK_SIZE(k);
    80006a06:	009b99b3          	sll	s3,s7,s1
    80006a0a:	412a87bb          	subw	a5,s5,s2
    80006a0e:	0337c7b3          	div	a5,a5,s3
    80006a12:	0007859b          	sext.w	a1,a5
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006a16:	8b85                	andi	a5,a5,1
    80006a18:	fbcd                	bnez	a5,800069ca <bd_free+0x6c>
    80006a1a:	00158d9b          	addiw	s11,a1,1
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    80006a1e:	fe0a0d13          	addi	s10,s4,-32
    80006a22:	000b3783          	ld	a5,0(s6)
    80006a26:	9d3e                	add	s10,s10,a5
    80006a28:	010d3503          	ld	a0,16(s10)
    80006a2c:	00000097          	auipc	ra,0x0
    80006a30:	af0080e7          	jalr	-1296(ra) # 8000651c <bit_clear>
    if (bit_isset(bd_sizes[k].alloc, buddy)) {  // is buddy allocated?
    80006a34:	85ee                	mv	a1,s11
    80006a36:	010d3503          	ld	a0,16(s10)
    80006a3a:	00000097          	auipc	ra,0x0
    80006a3e:	a7a080e7          	jalr	-1414(ra) # 800064b4 <bit_isset>
    80006a42:	e10d                	bnez	a0,80006a64 <bd_free+0x106>
  int n = bi * BLK_SIZE(k);
    80006a44:	000d8d1b          	sext.w	s10,s11
  return (char *) bd_base + n;
    80006a48:	03b989bb          	mulw	s3,s3,s11
    80006a4c:	994e                	add	s2,s2,s3
    lst_remove(q);    // remove buddy from free list
    80006a4e:	854a                	mv	a0,s2
    80006a50:	00000097          	auipc	ra,0x0
    80006a54:	630080e7          	jalr	1584(ra) # 80007080 <lst_remove>
    if(buddy % 2 == 0) {
    80006a58:	001d7d13          	andi	s10,s10,1
    80006a5c:	f60d1ae3          	bnez	s10,800069d0 <bd_free+0x72>
      p = q;
    80006a60:	8aca                	mv	s5,s2
    80006a62:	b7bd                	j	800069d0 <bd_free+0x72>
  }
  lst_push(&bd_sizes[k].free, p);
    80006a64:	0496                	slli	s1,s1,0x5
    80006a66:	85d6                	mv	a1,s5
    80006a68:	00021517          	auipc	a0,0x21
    80006a6c:	5e853503          	ld	a0,1512(a0) # 80028050 <bd_sizes>
    80006a70:	9526                	add	a0,a0,s1
    80006a72:	00000097          	auipc	ra,0x0
    80006a76:	65a080e7          	jalr	1626(ra) # 800070cc <lst_push>
  release(&lock);
    80006a7a:	00021517          	auipc	a0,0x21
    80006a7e:	58650513          	addi	a0,a0,1414 # 80028000 <lock>
    80006a82:	ffffa097          	auipc	ra,0xffffa
    80006a86:	0ee080e7          	jalr	238(ra) # 80000b70 <release>
}
    80006a8a:	70a6                	ld	ra,104(sp)
    80006a8c:	7406                	ld	s0,96(sp)
    80006a8e:	64e6                	ld	s1,88(sp)
    80006a90:	6946                	ld	s2,80(sp)
    80006a92:	69a6                	ld	s3,72(sp)
    80006a94:	6a06                	ld	s4,64(sp)
    80006a96:	7ae2                	ld	s5,56(sp)
    80006a98:	7b42                	ld	s6,48(sp)
    80006a9a:	7ba2                	ld	s7,40(sp)
    80006a9c:	7c02                	ld	s8,32(sp)
    80006a9e:	6ce2                	ld	s9,24(sp)
    80006aa0:	6d42                	ld	s10,16(sp)
    80006aa2:	6da2                	ld	s11,8(sp)
    80006aa4:	6165                	addi	sp,sp,112
    80006aa6:	8082                	ret

0000000080006aa8 <blk_index_next>:

// Compute the first block at size k that doesn't contain p
int
blk_index_next(int k, char *p) {
    80006aa8:	1141                	addi	sp,sp,-16
    80006aaa:	e422                	sd	s0,8(sp)
    80006aac:	0800                	addi	s0,sp,16
  int n = (p - (char *) bd_base) / BLK_SIZE(k);
    80006aae:	00021797          	auipc	a5,0x21
    80006ab2:	59a7b783          	ld	a5,1434(a5) # 80028048 <bd_base>
    80006ab6:	8d9d                	sub	a1,a1,a5
    80006ab8:	47c1                	li	a5,16
    80006aba:	00a797b3          	sll	a5,a5,a0
    80006abe:	02f5c533          	div	a0,a1,a5
    80006ac2:	2501                	sext.w	a0,a0
  if((p - (char*) bd_base) % BLK_SIZE(k) != 0)
    80006ac4:	02f5e5b3          	rem	a1,a1,a5
    80006ac8:	c191                	beqz	a1,80006acc <blk_index_next+0x24>
      n++;
    80006aca:	2505                	addiw	a0,a0,1
  return n ;
}
    80006acc:	6422                	ld	s0,8(sp)
    80006ace:	0141                	addi	sp,sp,16
    80006ad0:	8082                	ret

0000000080006ad2 <log2>:

int
log2(uint64 n) {
    80006ad2:	1141                	addi	sp,sp,-16
    80006ad4:	e422                	sd	s0,8(sp)
    80006ad6:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80006ad8:	4705                	li	a4,1
    80006ada:	00a77b63          	bgeu	a4,a0,80006af0 <log2+0x1e>
    80006ade:	87aa                	mv	a5,a0
  int k = 0;
    80006ae0:	4501                	li	a0,0
    k++;
    80006ae2:	2505                	addiw	a0,a0,1
    n = n >> 1;
    80006ae4:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    80006ae6:	fef76ee3          	bltu	a4,a5,80006ae2 <log2+0x10>
  }
  return k;
}
    80006aea:	6422                	ld	s0,8(sp)
    80006aec:	0141                	addi	sp,sp,16
    80006aee:	8082                	ret
  int k = 0;
    80006af0:	4501                	li	a0,0
    80006af2:	bfe5                	j	80006aea <log2+0x18>

0000000080006af4 <bd_mark>:

// Mark memory from [start, stop), starting at size 0, as allocated. 
void
bd_mark(void *start, void *stop)
{
    80006af4:	711d                	addi	sp,sp,-96
    80006af6:	ec86                	sd	ra,88(sp)
    80006af8:	e8a2                	sd	s0,80(sp)
    80006afa:	e4a6                	sd	s1,72(sp)
    80006afc:	e0ca                	sd	s2,64(sp)
    80006afe:	fc4e                	sd	s3,56(sp)
    80006b00:	f852                	sd	s4,48(sp)
    80006b02:	f456                	sd	s5,40(sp)
    80006b04:	f05a                	sd	s6,32(sp)
    80006b06:	ec5e                	sd	s7,24(sp)
    80006b08:	e862                	sd	s8,16(sp)
    80006b0a:	e466                	sd	s9,8(sp)
    80006b0c:	e06a                	sd	s10,0(sp)
    80006b0e:	1080                	addi	s0,sp,96
  int bi, bj;

  if (((uint64) start % LEAF_SIZE != 0) || ((uint64) stop % LEAF_SIZE != 0))
    80006b10:	00b56933          	or	s2,a0,a1
    80006b14:	00f97913          	andi	s2,s2,15
    80006b18:	04091263          	bnez	s2,80006b5c <bd_mark+0x68>
    80006b1c:	8b2a                	mv	s6,a0
    80006b1e:	8bae                	mv	s7,a1
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    80006b20:	00021c17          	auipc	s8,0x21
    80006b24:	538c2c03          	lw	s8,1336(s8) # 80028058 <nsizes>
    80006b28:	4981                	li	s3,0
  int n = p - (char *) bd_base;
    80006b2a:	00021d17          	auipc	s10,0x21
    80006b2e:	51ed0d13          	addi	s10,s10,1310 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006b32:	4cc1                	li	s9,16
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for(; bi < bj; bi++) {
      if(k > 0) {
        // if a block is allocated at size k, mark it as split too.
        bit_set(bd_sizes[k].split, bi);
    80006b34:	00021a97          	auipc	s5,0x21
    80006b38:	51ca8a93          	addi	s5,s5,1308 # 80028050 <bd_sizes>
  for (int k = 0; k < nsizes; k++) {
    80006b3c:	07804563          	bgtz	s8,80006ba6 <bd_mark+0xb2>
      }
      bit_set(bd_sizes[k].alloc, bi);
    }
  }
}
    80006b40:	60e6                	ld	ra,88(sp)
    80006b42:	6446                	ld	s0,80(sp)
    80006b44:	64a6                	ld	s1,72(sp)
    80006b46:	6906                	ld	s2,64(sp)
    80006b48:	79e2                	ld	s3,56(sp)
    80006b4a:	7a42                	ld	s4,48(sp)
    80006b4c:	7aa2                	ld	s5,40(sp)
    80006b4e:	7b02                	ld	s6,32(sp)
    80006b50:	6be2                	ld	s7,24(sp)
    80006b52:	6c42                	ld	s8,16(sp)
    80006b54:	6ca2                	ld	s9,8(sp)
    80006b56:	6d02                	ld	s10,0(sp)
    80006b58:	6125                	addi	sp,sp,96
    80006b5a:	8082                	ret
    panic("bd_mark");
    80006b5c:	00002517          	auipc	a0,0x2
    80006b60:	0d450513          	addi	a0,a0,212 # 80008c30 <userret+0xba0>
    80006b64:	ffffa097          	auipc	ra,0xffffa
    80006b68:	9f0080e7          	jalr	-1552(ra) # 80000554 <panic>
      bit_set(bd_sizes[k].alloc, bi);
    80006b6c:	000ab783          	ld	a5,0(s5)
    80006b70:	97ca                	add	a5,a5,s2
    80006b72:	85a6                	mv	a1,s1
    80006b74:	6b88                	ld	a0,16(a5)
    80006b76:	00000097          	auipc	ra,0x0
    80006b7a:	976080e7          	jalr	-1674(ra) # 800064ec <bit_set>
    for(; bi < bj; bi++) {
    80006b7e:	2485                	addiw	s1,s1,1
    80006b80:	009a0e63          	beq	s4,s1,80006b9c <bd_mark+0xa8>
      if(k > 0) {
    80006b84:	ff3054e3          	blez	s3,80006b6c <bd_mark+0x78>
        bit_set(bd_sizes[k].split, bi);
    80006b88:	000ab783          	ld	a5,0(s5)
    80006b8c:	97ca                	add	a5,a5,s2
    80006b8e:	85a6                	mv	a1,s1
    80006b90:	6f88                	ld	a0,24(a5)
    80006b92:	00000097          	auipc	ra,0x0
    80006b96:	95a080e7          	jalr	-1702(ra) # 800064ec <bit_set>
    80006b9a:	bfc9                	j	80006b6c <bd_mark+0x78>
  for (int k = 0; k < nsizes; k++) {
    80006b9c:	2985                	addiw	s3,s3,1
    80006b9e:	02090913          	addi	s2,s2,32
    80006ba2:	f9898fe3          	beq	s3,s8,80006b40 <bd_mark+0x4c>
  int n = p - (char *) bd_base;
    80006ba6:	000d3483          	ld	s1,0(s10)
  return n / BLK_SIZE(k);
    80006baa:	409b04bb          	subw	s1,s6,s1
    80006bae:	013c97b3          	sll	a5,s9,s3
    80006bb2:	02f4c4b3          	div	s1,s1,a5
    80006bb6:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80006bb8:	85de                	mv	a1,s7
    80006bba:	854e                	mv	a0,s3
    80006bbc:	00000097          	auipc	ra,0x0
    80006bc0:	eec080e7          	jalr	-276(ra) # 80006aa8 <blk_index_next>
    80006bc4:	8a2a                	mv	s4,a0
    for(; bi < bj; bi++) {
    80006bc6:	faa4cfe3          	blt	s1,a0,80006b84 <bd_mark+0x90>
    80006bca:	bfc9                	j	80006b9c <bd_mark+0xa8>

0000000080006bcc <bd_initfree_pair>:

// If a block is marked as allocated and the buddy is free, put the
// buddy on the free list at size k.
int
bd_initfree_pair(int k, int bi) {
    80006bcc:	7139                	addi	sp,sp,-64
    80006bce:	fc06                	sd	ra,56(sp)
    80006bd0:	f822                	sd	s0,48(sp)
    80006bd2:	f426                	sd	s1,40(sp)
    80006bd4:	f04a                	sd	s2,32(sp)
    80006bd6:	ec4e                	sd	s3,24(sp)
    80006bd8:	e852                	sd	s4,16(sp)
    80006bda:	e456                	sd	s5,8(sp)
    80006bdc:	e05a                	sd	s6,0(sp)
    80006bde:	0080                	addi	s0,sp,64
    80006be0:	89aa                	mv	s3,a0
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006be2:	00058a9b          	sext.w	s5,a1
    80006be6:	0015f793          	andi	a5,a1,1
    80006bea:	ebad                	bnez	a5,80006c5c <bd_initfree_pair+0x90>
    80006bec:	00158a1b          	addiw	s4,a1,1
  int free = 0;
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006bf0:	00599493          	slli	s1,s3,0x5
    80006bf4:	00021797          	auipc	a5,0x21
    80006bf8:	45c7b783          	ld	a5,1116(a5) # 80028050 <bd_sizes>
    80006bfc:	94be                	add	s1,s1,a5
    80006bfe:	0104bb03          	ld	s6,16(s1)
    80006c02:	855a                	mv	a0,s6
    80006c04:	00000097          	auipc	ra,0x0
    80006c08:	8b0080e7          	jalr	-1872(ra) # 800064b4 <bit_isset>
    80006c0c:	892a                	mv	s2,a0
    80006c0e:	85d2                	mv	a1,s4
    80006c10:	855a                	mv	a0,s6
    80006c12:	00000097          	auipc	ra,0x0
    80006c16:	8a2080e7          	jalr	-1886(ra) # 800064b4 <bit_isset>
  int free = 0;
    80006c1a:	4b01                	li	s6,0
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006c1c:	02a90563          	beq	s2,a0,80006c46 <bd_initfree_pair+0x7a>
    // one of the pair is free
    free = BLK_SIZE(k);
    80006c20:	45c1                	li	a1,16
    80006c22:	013599b3          	sll	s3,a1,s3
    80006c26:	00098b1b          	sext.w	s6,s3
    if(bit_isset(bd_sizes[k].alloc, bi))
    80006c2a:	02090c63          	beqz	s2,80006c62 <bd_initfree_pair+0x96>
  return (char *) bd_base + n;
    80006c2e:	034989bb          	mulw	s3,s3,s4
      lst_push(&bd_sizes[k].free, addr(k, buddy));   // put buddy on free list
    80006c32:	00021597          	auipc	a1,0x21
    80006c36:	4165b583          	ld	a1,1046(a1) # 80028048 <bd_base>
    80006c3a:	95ce                	add	a1,a1,s3
    80006c3c:	8526                	mv	a0,s1
    80006c3e:	00000097          	auipc	ra,0x0
    80006c42:	48e080e7          	jalr	1166(ra) # 800070cc <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
  }
  return free;
}
    80006c46:	855a                	mv	a0,s6
    80006c48:	70e2                	ld	ra,56(sp)
    80006c4a:	7442                	ld	s0,48(sp)
    80006c4c:	74a2                	ld	s1,40(sp)
    80006c4e:	7902                	ld	s2,32(sp)
    80006c50:	69e2                	ld	s3,24(sp)
    80006c52:	6a42                	ld	s4,16(sp)
    80006c54:	6aa2                	ld	s5,8(sp)
    80006c56:	6b02                	ld	s6,0(sp)
    80006c58:	6121                	addi	sp,sp,64
    80006c5a:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006c5c:	fff58a1b          	addiw	s4,a1,-1
    80006c60:	bf41                	j	80006bf0 <bd_initfree_pair+0x24>
  return (char *) bd_base + n;
    80006c62:	035989bb          	mulw	s3,s3,s5
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
    80006c66:	00021597          	auipc	a1,0x21
    80006c6a:	3e25b583          	ld	a1,994(a1) # 80028048 <bd_base>
    80006c6e:	95ce                	add	a1,a1,s3
    80006c70:	8526                	mv	a0,s1
    80006c72:	00000097          	auipc	ra,0x0
    80006c76:	45a080e7          	jalr	1114(ra) # 800070cc <lst_push>
    80006c7a:	b7f1                	j	80006c46 <bd_initfree_pair+0x7a>

0000000080006c7c <bd_initfree>:
  
// Initialize the free lists for each size k.  For each size k, there
// are only two pairs that may have a buddy that should be on free list:
// bd_left and bd_right.
int
bd_initfree(void *bd_left, void *bd_right) {
    80006c7c:	711d                	addi	sp,sp,-96
    80006c7e:	ec86                	sd	ra,88(sp)
    80006c80:	e8a2                	sd	s0,80(sp)
    80006c82:	e4a6                	sd	s1,72(sp)
    80006c84:	e0ca                	sd	s2,64(sp)
    80006c86:	fc4e                	sd	s3,56(sp)
    80006c88:	f852                	sd	s4,48(sp)
    80006c8a:	f456                	sd	s5,40(sp)
    80006c8c:	f05a                	sd	s6,32(sp)
    80006c8e:	ec5e                	sd	s7,24(sp)
    80006c90:	e862                	sd	s8,16(sp)
    80006c92:	e466                	sd	s9,8(sp)
    80006c94:	e06a                	sd	s10,0(sp)
    80006c96:	1080                	addi	s0,sp,96
  int free = 0;

  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006c98:	00021717          	auipc	a4,0x21
    80006c9c:	3c072703          	lw	a4,960(a4) # 80028058 <nsizes>
    80006ca0:	4785                	li	a5,1
    80006ca2:	06e7db63          	bge	a5,a4,80006d18 <bd_initfree+0x9c>
    80006ca6:	8aaa                	mv	s5,a0
    80006ca8:	8b2e                	mv	s6,a1
    80006caa:	4901                	li	s2,0
  int free = 0;
    80006cac:	4a01                	li	s4,0
  int n = p - (char *) bd_base;
    80006cae:	00021c97          	auipc	s9,0x21
    80006cb2:	39ac8c93          	addi	s9,s9,922 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006cb6:	4c41                	li	s8,16
  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006cb8:	00021b97          	auipc	s7,0x21
    80006cbc:	3a0b8b93          	addi	s7,s7,928 # 80028058 <nsizes>
    80006cc0:	a039                	j	80006cce <bd_initfree+0x52>
    80006cc2:	2905                	addiw	s2,s2,1
    80006cc4:	000ba783          	lw	a5,0(s7)
    80006cc8:	37fd                	addiw	a5,a5,-1
    80006cca:	04f95863          	bge	s2,a5,80006d1a <bd_initfree+0x9e>
    int left = blk_index_next(k, bd_left);
    80006cce:	85d6                	mv	a1,s5
    80006cd0:	854a                	mv	a0,s2
    80006cd2:	00000097          	auipc	ra,0x0
    80006cd6:	dd6080e7          	jalr	-554(ra) # 80006aa8 <blk_index_next>
    80006cda:	89aa                	mv	s3,a0
  int n = p - (char *) bd_base;
    80006cdc:	000cb483          	ld	s1,0(s9)
  return n / BLK_SIZE(k);
    80006ce0:	409b04bb          	subw	s1,s6,s1
    80006ce4:	012c17b3          	sll	a5,s8,s2
    80006ce8:	02f4c4b3          	div	s1,s1,a5
    80006cec:	2481                	sext.w	s1,s1
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left);
    80006cee:	85aa                	mv	a1,a0
    80006cf0:	854a                	mv	a0,s2
    80006cf2:	00000097          	auipc	ra,0x0
    80006cf6:	eda080e7          	jalr	-294(ra) # 80006bcc <bd_initfree_pair>
    80006cfa:	01450d3b          	addw	s10,a0,s4
    80006cfe:	000d0a1b          	sext.w	s4,s10
    if(right <= left)
    80006d02:	fc99d0e3          	bge	s3,s1,80006cc2 <bd_initfree+0x46>
      continue;
    free += bd_initfree_pair(k, right);
    80006d06:	85a6                	mv	a1,s1
    80006d08:	854a                	mv	a0,s2
    80006d0a:	00000097          	auipc	ra,0x0
    80006d0e:	ec2080e7          	jalr	-318(ra) # 80006bcc <bd_initfree_pair>
    80006d12:	00ad0a3b          	addw	s4,s10,a0
    80006d16:	b775                	j	80006cc2 <bd_initfree+0x46>
  int free = 0;
    80006d18:	4a01                	li	s4,0
  }
  return free;
}
    80006d1a:	8552                	mv	a0,s4
    80006d1c:	60e6                	ld	ra,88(sp)
    80006d1e:	6446                	ld	s0,80(sp)
    80006d20:	64a6                	ld	s1,72(sp)
    80006d22:	6906                	ld	s2,64(sp)
    80006d24:	79e2                	ld	s3,56(sp)
    80006d26:	7a42                	ld	s4,48(sp)
    80006d28:	7aa2                	ld	s5,40(sp)
    80006d2a:	7b02                	ld	s6,32(sp)
    80006d2c:	6be2                	ld	s7,24(sp)
    80006d2e:	6c42                	ld	s8,16(sp)
    80006d30:	6ca2                	ld	s9,8(sp)
    80006d32:	6d02                	ld	s10,0(sp)
    80006d34:	6125                	addi	sp,sp,96
    80006d36:	8082                	ret

0000000080006d38 <bd_mark_data_structures>:

// Mark the range [bd_base,p) as allocated
int
bd_mark_data_structures(char *p) {
    80006d38:	7179                	addi	sp,sp,-48
    80006d3a:	f406                	sd	ra,40(sp)
    80006d3c:	f022                	sd	s0,32(sp)
    80006d3e:	ec26                	sd	s1,24(sp)
    80006d40:	e84a                	sd	s2,16(sp)
    80006d42:	e44e                	sd	s3,8(sp)
    80006d44:	1800                	addi	s0,sp,48
    80006d46:	892a                	mv	s2,a0
  int meta = p - (char*)bd_base;
    80006d48:	00021997          	auipc	s3,0x21
    80006d4c:	30098993          	addi	s3,s3,768 # 80028048 <bd_base>
    80006d50:	0009b483          	ld	s1,0(s3)
    80006d54:	409504bb          	subw	s1,a0,s1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta, BLK_SIZE(MAXSIZE));
    80006d58:	00021797          	auipc	a5,0x21
    80006d5c:	3007a783          	lw	a5,768(a5) # 80028058 <nsizes>
    80006d60:	37fd                	addiw	a5,a5,-1
    80006d62:	4641                	li	a2,16
    80006d64:	00f61633          	sll	a2,a2,a5
    80006d68:	85a6                	mv	a1,s1
    80006d6a:	00002517          	auipc	a0,0x2
    80006d6e:	ece50513          	addi	a0,a0,-306 # 80008c38 <userret+0xba8>
    80006d72:	ffffa097          	auipc	ra,0xffffa
    80006d76:	83c080e7          	jalr	-1988(ra) # 800005ae <printf>
  bd_mark(bd_base, p);
    80006d7a:	85ca                	mv	a1,s2
    80006d7c:	0009b503          	ld	a0,0(s3)
    80006d80:	00000097          	auipc	ra,0x0
    80006d84:	d74080e7          	jalr	-652(ra) # 80006af4 <bd_mark>
  return meta;
}
    80006d88:	8526                	mv	a0,s1
    80006d8a:	70a2                	ld	ra,40(sp)
    80006d8c:	7402                	ld	s0,32(sp)
    80006d8e:	64e2                	ld	s1,24(sp)
    80006d90:	6942                	ld	s2,16(sp)
    80006d92:	69a2                	ld	s3,8(sp)
    80006d94:	6145                	addi	sp,sp,48
    80006d96:	8082                	ret

0000000080006d98 <bd_mark_unavailable>:

// Mark the range [end, HEAPSIZE) as allocated
int
bd_mark_unavailable(void *end, void *left) {
    80006d98:	1101                	addi	sp,sp,-32
    80006d9a:	ec06                	sd	ra,24(sp)
    80006d9c:	e822                	sd	s0,16(sp)
    80006d9e:	e426                	sd	s1,8(sp)
    80006da0:	1000                	addi	s0,sp,32
  int unavailable = BLK_SIZE(MAXSIZE)-(end-bd_base);
    80006da2:	00021497          	auipc	s1,0x21
    80006da6:	2b64a483          	lw	s1,694(s1) # 80028058 <nsizes>
    80006daa:	fff4879b          	addiw	a5,s1,-1
    80006dae:	44c1                	li	s1,16
    80006db0:	00f494b3          	sll	s1,s1,a5
    80006db4:	00021797          	auipc	a5,0x21
    80006db8:	2947b783          	ld	a5,660(a5) # 80028048 <bd_base>
    80006dbc:	8d1d                	sub	a0,a0,a5
    80006dbe:	40a4853b          	subw	a0,s1,a0
    80006dc2:	0005049b          	sext.w	s1,a0
  if(unavailable > 0)
    80006dc6:	00905a63          	blez	s1,80006dda <bd_mark_unavailable+0x42>
    unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    80006dca:	357d                	addiw	a0,a0,-1
    80006dcc:	41f5549b          	sraiw	s1,a0,0x1f
    80006dd0:	01c4d49b          	srliw	s1,s1,0x1c
    80006dd4:	9ca9                	addw	s1,s1,a0
    80006dd6:	98c1                	andi	s1,s1,-16
    80006dd8:	24c1                	addiw	s1,s1,16
  printf("bd: 0x%x bytes unavailable\n", unavailable);
    80006dda:	85a6                	mv	a1,s1
    80006ddc:	00002517          	auipc	a0,0x2
    80006de0:	e9450513          	addi	a0,a0,-364 # 80008c70 <userret+0xbe0>
    80006de4:	ffff9097          	auipc	ra,0xffff9
    80006de8:	7ca080e7          	jalr	1994(ra) # 800005ae <printf>

  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80006dec:	00021717          	auipc	a4,0x21
    80006df0:	25c73703          	ld	a4,604(a4) # 80028048 <bd_base>
    80006df4:	00021597          	auipc	a1,0x21
    80006df8:	2645a583          	lw	a1,612(a1) # 80028058 <nsizes>
    80006dfc:	fff5879b          	addiw	a5,a1,-1
    80006e00:	45c1                	li	a1,16
    80006e02:	00f595b3          	sll	a1,a1,a5
    80006e06:	40958533          	sub	a0,a1,s1
  bd_mark(bd_end, bd_base+BLK_SIZE(MAXSIZE));
    80006e0a:	95ba                	add	a1,a1,a4
    80006e0c:	953a                	add	a0,a0,a4
    80006e0e:	00000097          	auipc	ra,0x0
    80006e12:	ce6080e7          	jalr	-794(ra) # 80006af4 <bd_mark>
  return unavailable;
}
    80006e16:	8526                	mv	a0,s1
    80006e18:	60e2                	ld	ra,24(sp)
    80006e1a:	6442                	ld	s0,16(sp)
    80006e1c:	64a2                	ld	s1,8(sp)
    80006e1e:	6105                	addi	sp,sp,32
    80006e20:	8082                	ret

0000000080006e22 <bd_init>:

// Initialize the buddy allocator: it manages memory from [base, end).
void
bd_init(void *base, void *end) {
    80006e22:	715d                	addi	sp,sp,-80
    80006e24:	e486                	sd	ra,72(sp)
    80006e26:	e0a2                	sd	s0,64(sp)
    80006e28:	fc26                	sd	s1,56(sp)
    80006e2a:	f84a                	sd	s2,48(sp)
    80006e2c:	f44e                	sd	s3,40(sp)
    80006e2e:	f052                	sd	s4,32(sp)
    80006e30:	ec56                	sd	s5,24(sp)
    80006e32:	e85a                	sd	s6,16(sp)
    80006e34:	e45e                	sd	s7,8(sp)
    80006e36:	e062                	sd	s8,0(sp)
    80006e38:	0880                	addi	s0,sp,80
    80006e3a:	8c2e                	mv	s8,a1
  char *p = (char *) ROUNDUP((uint64)base, LEAF_SIZE);
    80006e3c:	fff50493          	addi	s1,a0,-1
    80006e40:	98c1                	andi	s1,s1,-16
    80006e42:	04c1                	addi	s1,s1,16
  int sz;

  initlock(&lock, "buddy");
    80006e44:	00002597          	auipc	a1,0x2
    80006e48:	e4c58593          	addi	a1,a1,-436 # 80008c90 <userret+0xc00>
    80006e4c:	00021517          	auipc	a0,0x21
    80006e50:	1b450513          	addi	a0,a0,436 # 80028000 <lock>
    80006e54:	ffffa097          	auipc	ra,0xffffa
    80006e58:	b78080e7          	jalr	-1160(ra) # 800009cc <initlock>
  bd_base = (void *) p;
    80006e5c:	00021797          	auipc	a5,0x21
    80006e60:	1e97b623          	sd	s1,492(a5) # 80028048 <bd_base>

  // compute the number of sizes we need to manage [base, end)
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80006e64:	409c0933          	sub	s2,s8,s1
    80006e68:	43f95513          	srai	a0,s2,0x3f
    80006e6c:	893d                	andi	a0,a0,15
    80006e6e:	954a                	add	a0,a0,s2
    80006e70:	8511                	srai	a0,a0,0x4
    80006e72:	00000097          	auipc	ra,0x0
    80006e76:	c60080e7          	jalr	-928(ra) # 80006ad2 <log2>
  if((char*)end-p > BLK_SIZE(MAXSIZE)) {
    80006e7a:	47c1                	li	a5,16
    80006e7c:	00a797b3          	sll	a5,a5,a0
    80006e80:	1b27c663          	blt	a5,s2,8000702c <bd_init+0x20a>
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80006e84:	2505                	addiw	a0,a0,1
    80006e86:	00021797          	auipc	a5,0x21
    80006e8a:	1ca7a923          	sw	a0,466(a5) # 80028058 <nsizes>
    nsizes++;  // round up to the next power of 2
  }

  printf("bd: memory sz is %d bytes; allocate an size array of length %d\n",
    80006e8e:	00021997          	auipc	s3,0x21
    80006e92:	1ca98993          	addi	s3,s3,458 # 80028058 <nsizes>
    80006e96:	0009a603          	lw	a2,0(s3)
    80006e9a:	85ca                	mv	a1,s2
    80006e9c:	00002517          	auipc	a0,0x2
    80006ea0:	dfc50513          	addi	a0,a0,-516 # 80008c98 <userret+0xc08>
    80006ea4:	ffff9097          	auipc	ra,0xffff9
    80006ea8:	70a080e7          	jalr	1802(ra) # 800005ae <printf>
         (char*) end - p, nsizes);

  // allocate bd_sizes array
  bd_sizes = (Sz_info *) p;
    80006eac:	00021797          	auipc	a5,0x21
    80006eb0:	1a97b223          	sd	s1,420(a5) # 80028050 <bd_sizes>
  p += sizeof(Sz_info) * nsizes;
    80006eb4:	0009a603          	lw	a2,0(s3)
    80006eb8:	00561913          	slli	s2,a2,0x5
    80006ebc:	9926                	add	s2,s2,s1
  memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);
    80006ebe:	0056161b          	slliw	a2,a2,0x5
    80006ec2:	4581                	li	a1,0
    80006ec4:	8526                	mv	a0,s1
    80006ec6:	ffffa097          	auipc	ra,0xffffa
    80006eca:	ea8080e7          	jalr	-344(ra) # 80000d6e <memset>

  // initialize free list and allocate the alloc array for each size k
  for (int k = 0; k < nsizes; k++) {
    80006ece:	0009a783          	lw	a5,0(s3)
    80006ed2:	06f05a63          	blez	a5,80006f46 <bd_init+0x124>
    80006ed6:	4981                	li	s3,0
    lst_init(&bd_sizes[k].free);
    80006ed8:	00021a97          	auipc	s5,0x21
    80006edc:	178a8a93          	addi	s5,s5,376 # 80028050 <bd_sizes>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    80006ee0:	00021a17          	auipc	s4,0x21
    80006ee4:	178a0a13          	addi	s4,s4,376 # 80028058 <nsizes>
    80006ee8:	4b05                	li	s6,1
    lst_init(&bd_sizes[k].free);
    80006eea:	00599b93          	slli	s7,s3,0x5
    80006eee:	000ab503          	ld	a0,0(s5)
    80006ef2:	955e                	add	a0,a0,s7
    80006ef4:	00000097          	auipc	ra,0x0
    80006ef8:	166080e7          	jalr	358(ra) # 8000705a <lst_init>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    80006efc:	000a2483          	lw	s1,0(s4)
    80006f00:	34fd                	addiw	s1,s1,-1
    80006f02:	413484bb          	subw	s1,s1,s3
    80006f06:	009b14bb          	sllw	s1,s6,s1
    80006f0a:	fff4879b          	addiw	a5,s1,-1
    80006f0e:	41f7d49b          	sraiw	s1,a5,0x1f
    80006f12:	01d4d49b          	srliw	s1,s1,0x1d
    80006f16:	9cbd                	addw	s1,s1,a5
    80006f18:	98e1                	andi	s1,s1,-8
    80006f1a:	24a1                	addiw	s1,s1,8
    bd_sizes[k].alloc = p;
    80006f1c:	000ab783          	ld	a5,0(s5)
    80006f20:	9bbe                	add	s7,s7,a5
    80006f22:	012bb823          	sd	s2,16(s7)
    memset(bd_sizes[k].alloc, 0, sz);
    80006f26:	848d                	srai	s1,s1,0x3
    80006f28:	8626                	mv	a2,s1
    80006f2a:	4581                	li	a1,0
    80006f2c:	854a                	mv	a0,s2
    80006f2e:	ffffa097          	auipc	ra,0xffffa
    80006f32:	e40080e7          	jalr	-448(ra) # 80000d6e <memset>
    p += sz;
    80006f36:	9926                	add	s2,s2,s1
  for (int k = 0; k < nsizes; k++) {
    80006f38:	0985                	addi	s3,s3,1
    80006f3a:	000a2703          	lw	a4,0(s4)
    80006f3e:	0009879b          	sext.w	a5,s3
    80006f42:	fae7c4e3          	blt	a5,a4,80006eea <bd_init+0xc8>
  }

  // allocate the split array for each size k, except for k = 0, since
  // we will not split blocks of size k = 0, the smallest size.
  for (int k = 1; k < nsizes; k++) {
    80006f46:	00021797          	auipc	a5,0x21
    80006f4a:	1127a783          	lw	a5,274(a5) # 80028058 <nsizes>
    80006f4e:	4705                	li	a4,1
    80006f50:	06f75163          	bge	a4,a5,80006fb2 <bd_init+0x190>
    80006f54:	02000a13          	li	s4,32
    80006f58:	4985                	li	s3,1
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    80006f5a:	4b85                	li	s7,1
    bd_sizes[k].split = p;
    80006f5c:	00021b17          	auipc	s6,0x21
    80006f60:	0f4b0b13          	addi	s6,s6,244 # 80028050 <bd_sizes>
  for (int k = 1; k < nsizes; k++) {
    80006f64:	00021a97          	auipc	s5,0x21
    80006f68:	0f4a8a93          	addi	s5,s5,244 # 80028058 <nsizes>
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    80006f6c:	37fd                	addiw	a5,a5,-1
    80006f6e:	413787bb          	subw	a5,a5,s3
    80006f72:	00fb94bb          	sllw	s1,s7,a5
    80006f76:	fff4879b          	addiw	a5,s1,-1
    80006f7a:	41f7d49b          	sraiw	s1,a5,0x1f
    80006f7e:	01d4d49b          	srliw	s1,s1,0x1d
    80006f82:	9cbd                	addw	s1,s1,a5
    80006f84:	98e1                	andi	s1,s1,-8
    80006f86:	24a1                	addiw	s1,s1,8
    bd_sizes[k].split = p;
    80006f88:	000b3783          	ld	a5,0(s6)
    80006f8c:	97d2                	add	a5,a5,s4
    80006f8e:	0127bc23          	sd	s2,24(a5)
    memset(bd_sizes[k].split, 0, sz);
    80006f92:	848d                	srai	s1,s1,0x3
    80006f94:	8626                	mv	a2,s1
    80006f96:	4581                	li	a1,0
    80006f98:	854a                	mv	a0,s2
    80006f9a:	ffffa097          	auipc	ra,0xffffa
    80006f9e:	dd4080e7          	jalr	-556(ra) # 80000d6e <memset>
    p += sz;
    80006fa2:	9926                	add	s2,s2,s1
  for (int k = 1; k < nsizes; k++) {
    80006fa4:	2985                	addiw	s3,s3,1
    80006fa6:	000aa783          	lw	a5,0(s5)
    80006faa:	020a0a13          	addi	s4,s4,32
    80006fae:	faf9cfe3          	blt	s3,a5,80006f6c <bd_init+0x14a>
  }
  p = (char *) ROUNDUP((uint64) p, LEAF_SIZE);
    80006fb2:	197d                	addi	s2,s2,-1
    80006fb4:	ff097913          	andi	s2,s2,-16
    80006fb8:	0941                	addi	s2,s2,16

  // done allocating; mark the memory range [base, p) as allocated, so
  // that buddy will not hand out that memory.
  int meta = bd_mark_data_structures(p);
    80006fba:	854a                	mv	a0,s2
    80006fbc:	00000097          	auipc	ra,0x0
    80006fc0:	d7c080e7          	jalr	-644(ra) # 80006d38 <bd_mark_data_structures>
    80006fc4:	8a2a                	mv	s4,a0
  
  // mark the unavailable memory range [end, HEAP_SIZE) as allocated,
  // so that buddy will not hand out that memory.
  int unavailable = bd_mark_unavailable(end, p);
    80006fc6:	85ca                	mv	a1,s2
    80006fc8:	8562                	mv	a0,s8
    80006fca:	00000097          	auipc	ra,0x0
    80006fce:	dce080e7          	jalr	-562(ra) # 80006d98 <bd_mark_unavailable>
    80006fd2:	89aa                	mv	s3,a0
  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80006fd4:	00021a97          	auipc	s5,0x21
    80006fd8:	084a8a93          	addi	s5,s5,132 # 80028058 <nsizes>
    80006fdc:	000aa783          	lw	a5,0(s5)
    80006fe0:	37fd                	addiw	a5,a5,-1
    80006fe2:	44c1                	li	s1,16
    80006fe4:	00f497b3          	sll	a5,s1,a5
    80006fe8:	8f89                	sub	a5,a5,a0
  
  // initialize free lists for each size k
  int free = bd_initfree(p, bd_end);
    80006fea:	00021597          	auipc	a1,0x21
    80006fee:	05e5b583          	ld	a1,94(a1) # 80028048 <bd_base>
    80006ff2:	95be                	add	a1,a1,a5
    80006ff4:	854a                	mv	a0,s2
    80006ff6:	00000097          	auipc	ra,0x0
    80006ffa:	c86080e7          	jalr	-890(ra) # 80006c7c <bd_initfree>

  // check if the amount that is free is what we expect
  if(free != BLK_SIZE(MAXSIZE)-meta-unavailable) {
    80006ffe:	000aa603          	lw	a2,0(s5)
    80007002:	367d                	addiw	a2,a2,-1
    80007004:	00c49633          	sll	a2,s1,a2
    80007008:	41460633          	sub	a2,a2,s4
    8000700c:	41360633          	sub	a2,a2,s3
    80007010:	02c51463          	bne	a0,a2,80007038 <bd_init+0x216>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    panic("bd_init: free mem");
  }
}
    80007014:	60a6                	ld	ra,72(sp)
    80007016:	6406                	ld	s0,64(sp)
    80007018:	74e2                	ld	s1,56(sp)
    8000701a:	7942                	ld	s2,48(sp)
    8000701c:	79a2                	ld	s3,40(sp)
    8000701e:	7a02                	ld	s4,32(sp)
    80007020:	6ae2                	ld	s5,24(sp)
    80007022:	6b42                	ld	s6,16(sp)
    80007024:	6ba2                	ld	s7,8(sp)
    80007026:	6c02                	ld	s8,0(sp)
    80007028:	6161                	addi	sp,sp,80
    8000702a:	8082                	ret
    nsizes++;  // round up to the next power of 2
    8000702c:	2509                	addiw	a0,a0,2
    8000702e:	00021797          	auipc	a5,0x21
    80007032:	02a7a523          	sw	a0,42(a5) # 80028058 <nsizes>
    80007036:	bda1                	j	80006e8e <bd_init+0x6c>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    80007038:	85aa                	mv	a1,a0
    8000703a:	00002517          	auipc	a0,0x2
    8000703e:	c9e50513          	addi	a0,a0,-866 # 80008cd8 <userret+0xc48>
    80007042:	ffff9097          	auipc	ra,0xffff9
    80007046:	56c080e7          	jalr	1388(ra) # 800005ae <printf>
    panic("bd_init: free mem");
    8000704a:	00002517          	auipc	a0,0x2
    8000704e:	c9e50513          	addi	a0,a0,-866 # 80008ce8 <userret+0xc58>
    80007052:	ffff9097          	auipc	ra,0xffff9
    80007056:	502080e7          	jalr	1282(ra) # 80000554 <panic>

000000008000705a <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    8000705a:	1141                	addi	sp,sp,-16
    8000705c:	e422                	sd	s0,8(sp)
    8000705e:	0800                	addi	s0,sp,16
  lst->next = lst;
    80007060:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    80007062:	e508                	sd	a0,8(a0)
}
    80007064:	6422                	ld	s0,8(sp)
    80007066:	0141                	addi	sp,sp,16
    80007068:	8082                	ret

000000008000706a <lst_empty>:

int
lst_empty(struct list *lst) {
    8000706a:	1141                	addi	sp,sp,-16
    8000706c:	e422                	sd	s0,8(sp)
    8000706e:	0800                	addi	s0,sp,16
  return lst->next == lst;
    80007070:	611c                	ld	a5,0(a0)
    80007072:	40a78533          	sub	a0,a5,a0
}
    80007076:	00153513          	seqz	a0,a0
    8000707a:	6422                	ld	s0,8(sp)
    8000707c:	0141                	addi	sp,sp,16
    8000707e:	8082                	ret

0000000080007080 <lst_remove>:

void
lst_remove(struct list *e) {
    80007080:	1141                	addi	sp,sp,-16
    80007082:	e422                	sd	s0,8(sp)
    80007084:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    80007086:	6518                	ld	a4,8(a0)
    80007088:	611c                	ld	a5,0(a0)
    8000708a:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    8000708c:	6518                	ld	a4,8(a0)
    8000708e:	e798                	sd	a4,8(a5)
}
    80007090:	6422                	ld	s0,8(sp)
    80007092:	0141                	addi	sp,sp,16
    80007094:	8082                	ret

0000000080007096 <lst_pop>:

void*
lst_pop(struct list *lst) {
    80007096:	1101                	addi	sp,sp,-32
    80007098:	ec06                	sd	ra,24(sp)
    8000709a:	e822                	sd	s0,16(sp)
    8000709c:	e426                	sd	s1,8(sp)
    8000709e:	1000                	addi	s0,sp,32
  if(lst->next == lst)
    800070a0:	6104                	ld	s1,0(a0)
    800070a2:	00a48d63          	beq	s1,a0,800070bc <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
  lst_remove(p);
    800070a6:	8526                	mv	a0,s1
    800070a8:	00000097          	auipc	ra,0x0
    800070ac:	fd8080e7          	jalr	-40(ra) # 80007080 <lst_remove>
  return (void *)p;
}
    800070b0:	8526                	mv	a0,s1
    800070b2:	60e2                	ld	ra,24(sp)
    800070b4:	6442                	ld	s0,16(sp)
    800070b6:	64a2                	ld	s1,8(sp)
    800070b8:	6105                	addi	sp,sp,32
    800070ba:	8082                	ret
    panic("lst_pop");
    800070bc:	00002517          	auipc	a0,0x2
    800070c0:	c4450513          	addi	a0,a0,-956 # 80008d00 <userret+0xc70>
    800070c4:	ffff9097          	auipc	ra,0xffff9
    800070c8:	490080e7          	jalr	1168(ra) # 80000554 <panic>

00000000800070cc <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    800070cc:	1141                	addi	sp,sp,-16
    800070ce:	e422                	sd	s0,8(sp)
    800070d0:	0800                	addi	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    800070d2:	611c                	ld	a5,0(a0)
    800070d4:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    800070d6:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    800070d8:	611c                	ld	a5,0(a0)
    800070da:	e78c                	sd	a1,8(a5)
  lst->next = e;
    800070dc:	e10c                	sd	a1,0(a0)
}
    800070de:	6422                	ld	s0,8(sp)
    800070e0:	0141                	addi	sp,sp,16
    800070e2:	8082                	ret

00000000800070e4 <lst_print>:

void
lst_print(struct list *lst)
{
    800070e4:	7179                	addi	sp,sp,-48
    800070e6:	f406                	sd	ra,40(sp)
    800070e8:	f022                	sd	s0,32(sp)
    800070ea:	ec26                	sd	s1,24(sp)
    800070ec:	e84a                	sd	s2,16(sp)
    800070ee:	e44e                	sd	s3,8(sp)
    800070f0:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    800070f2:	6104                	ld	s1,0(a0)
    800070f4:	02950063          	beq	a0,s1,80007114 <lst_print+0x30>
    800070f8:	892a                	mv	s2,a0
    printf(" %p", p);
    800070fa:	00002997          	auipc	s3,0x2
    800070fe:	c0e98993          	addi	s3,s3,-1010 # 80008d08 <userret+0xc78>
    80007102:	85a6                	mv	a1,s1
    80007104:	854e                	mv	a0,s3
    80007106:	ffff9097          	auipc	ra,0xffff9
    8000710a:	4a8080e7          	jalr	1192(ra) # 800005ae <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    8000710e:	6084                	ld	s1,0(s1)
    80007110:	fe9919e3          	bne	s2,s1,80007102 <lst_print+0x1e>
  }
  printf("\n");
    80007114:	00001517          	auipc	a0,0x1
    80007118:	17c50513          	addi	a0,a0,380 # 80008290 <userret+0x200>
    8000711c:	ffff9097          	auipc	ra,0xffff9
    80007120:	492080e7          	jalr	1170(ra) # 800005ae <printf>
}
    80007124:	70a2                	ld	ra,40(sp)
    80007126:	7402                	ld	s0,32(sp)
    80007128:	64e2                	ld	s1,24(sp)
    8000712a:	6942                	ld	s2,16(sp)
    8000712c:	69a2                	ld	s3,8(sp)
    8000712e:	6145                	addi	sp,sp,48
    80007130:	8082                	ret
	...

0000000080008000 <trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
