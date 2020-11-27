
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	80010113          	addi	sp,sp,-2048 # 80009800 <stack0>
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
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fb660613          	addi	a2,a2,-74 # 80009000 <mscratch0>
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
    80000060:	c3478793          	addi	a5,a5,-972 # 80005c90 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd57bb>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	ca278793          	addi	a5,a5,-862 # 80000d48 <main>
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
  timerinit();
    800000c4:	00000097          	auipc	ra,0x0
    800000c8:	f58080e7          	jalr	-168(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000d0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000d4:	30200073          	mret
}
    800000d8:	60a2                	ld	ra,8(sp)
    800000da:	6402                	ld	s0,0(sp)
    800000dc:	0141                	addi	sp,sp,16
    800000de:	8082                	ret

00000000800000e0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800000e0:	7159                	addi	sp,sp,-112
    800000e2:	f486                	sd	ra,104(sp)
    800000e4:	f0a2                	sd	s0,96(sp)
    800000e6:	eca6                	sd	s1,88(sp)
    800000e8:	e8ca                	sd	s2,80(sp)
    800000ea:	e4ce                	sd	s3,72(sp)
    800000ec:	e0d2                	sd	s4,64(sp)
    800000ee:	fc56                	sd	s5,56(sp)
    800000f0:	f85a                	sd	s6,48(sp)
    800000f2:	f45e                	sd	s7,40(sp)
    800000f4:	f062                	sd	s8,32(sp)
    800000f6:	ec66                	sd	s9,24(sp)
    800000f8:	e86a                	sd	s10,16(sp)
    800000fa:	1880                	addi	s0,sp,112
    800000fc:	8aaa                	mv	s5,a0
    800000fe:	8a2e                	mv	s4,a1
    80000100:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000102:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000106:	00011517          	auipc	a0,0x11
    8000010a:	6fa50513          	addi	a0,a0,1786 # 80011800 <cons>
    8000010e:	00001097          	auipc	ra,0x1
    80000112:	9c8080e7          	jalr	-1592(ra) # 80000ad6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000116:	00011497          	auipc	s1,0x11
    8000011a:	6ea48493          	addi	s1,s1,1770 # 80011800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000011e:	00011917          	auipc	s2,0x11
    80000122:	77a90913          	addi	s2,s2,1914 # 80011898 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80000126:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000128:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000012a:	4ca9                	li	s9,10
  while(n > 0){
    8000012c:	07305863          	blez	s3,8000019c <consoleread+0xbc>
    while(cons.r == cons.w){
    80000130:	0984a783          	lw	a5,152(s1)
    80000134:	09c4a703          	lw	a4,156(s1)
    80000138:	02f71463          	bne	a4,a5,80000160 <consoleread+0x80>
      if(myproc()->killed){
    8000013c:	00001097          	auipc	ra,0x1
    80000140:	6fa080e7          	jalr	1786(ra) # 80001836 <myproc>
    80000144:	591c                	lw	a5,48(a0)
    80000146:	e7b5                	bnez	a5,800001b2 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80000148:	85a6                	mv	a1,s1
    8000014a:	854a                	mv	a0,s2
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	f00080e7          	jalr	-256(ra) # 8000204c <sleep>
    while(cons.r == cons.w){
    80000154:	0984a783          	lw	a5,152(s1)
    80000158:	09c4a703          	lw	a4,156(s1)
    8000015c:	fef700e3          	beq	a4,a5,8000013c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000160:	0017871b          	addiw	a4,a5,1
    80000164:	08e4ac23          	sw	a4,152(s1)
    80000168:	07f7f713          	andi	a4,a5,127
    8000016c:	9726                	add	a4,a4,s1
    8000016e:	01874703          	lbu	a4,24(a4)
    80000172:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000176:	077d0563          	beq	s10,s7,800001e0 <consoleread+0x100>
    cbuf = c;
    8000017a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000017e:	4685                	li	a3,1
    80000180:	f9f40613          	addi	a2,s0,-97
    80000184:	85d2                	mv	a1,s4
    80000186:	8556                	mv	a0,s5
    80000188:	00002097          	auipc	ra,0x2
    8000018c:	11e080e7          	jalr	286(ra) # 800022a6 <either_copyout>
    80000190:	01850663          	beq	a0,s8,8000019c <consoleread+0xbc>
    dst++;
    80000194:	0a05                	addi	s4,s4,1
    --n;
    80000196:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000198:	f99d1ae3          	bne	s10,s9,8000012c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000019c:	00011517          	auipc	a0,0x11
    800001a0:	66450513          	addi	a0,a0,1636 # 80011800 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	99a080e7          	jalr	-1638(ra) # 80000b3e <release>

  return target - n;
    800001ac:	413b053b          	subw	a0,s6,s3
    800001b0:	a811                	j	800001c4 <consoleread+0xe4>
        release(&cons.lock);
    800001b2:	00011517          	auipc	a0,0x11
    800001b6:	64e50513          	addi	a0,a0,1614 # 80011800 <cons>
    800001ba:	00001097          	auipc	ra,0x1
    800001be:	984080e7          	jalr	-1660(ra) # 80000b3e <release>
        return -1;
    800001c2:	557d                	li	a0,-1
}
    800001c4:	70a6                	ld	ra,104(sp)
    800001c6:	7406                	ld	s0,96(sp)
    800001c8:	64e6                	ld	s1,88(sp)
    800001ca:	6946                	ld	s2,80(sp)
    800001cc:	69a6                	ld	s3,72(sp)
    800001ce:	6a06                	ld	s4,64(sp)
    800001d0:	7ae2                	ld	s5,56(sp)
    800001d2:	7b42                	ld	s6,48(sp)
    800001d4:	7ba2                	ld	s7,40(sp)
    800001d6:	7c02                	ld	s8,32(sp)
    800001d8:	6ce2                	ld	s9,24(sp)
    800001da:	6d42                	ld	s10,16(sp)
    800001dc:	6165                	addi	sp,sp,112
    800001de:	8082                	ret
      if(n < target){
    800001e0:	0009871b          	sext.w	a4,s3
    800001e4:	fb677ce3          	bgeu	a4,s6,8000019c <consoleread+0xbc>
        cons.r--;
    800001e8:	00011717          	auipc	a4,0x11
    800001ec:	6af72823          	sw	a5,1712(a4) # 80011898 <cons+0x98>
    800001f0:	b775                	j	8000019c <consoleread+0xbc>

00000000800001f2 <consputc>:
  if(panicked){
    800001f2:	00029797          	auipc	a5,0x29
    800001f6:	e267a783          	lw	a5,-474(a5) # 80029018 <panicked>
    800001fa:	c391                	beqz	a5,800001fe <consputc+0xc>
    for(;;)
    800001fc:	a001                	j	800001fc <consputc+0xa>
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e406                	sd	ra,8(sp)
    80000202:	e022                	sd	s0,0(sp)
    80000204:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000206:	10000793          	li	a5,256
    8000020a:	00f50a63          	beq	a0,a5,8000021e <consputc+0x2c>
    uartputc(c);
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	5cc080e7          	jalr	1484(ra) # 800007da <uartputc>
}
    80000216:	60a2                	ld	ra,8(sp)
    80000218:	6402                	ld	s0,0(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    8000021e:	4521                	li	a0,8
    80000220:	00000097          	auipc	ra,0x0
    80000224:	5ba080e7          	jalr	1466(ra) # 800007da <uartputc>
    80000228:	02000513          	li	a0,32
    8000022c:	00000097          	auipc	ra,0x0
    80000230:	5ae080e7          	jalr	1454(ra) # 800007da <uartputc>
    80000234:	4521                	li	a0,8
    80000236:	00000097          	auipc	ra,0x0
    8000023a:	5a4080e7          	jalr	1444(ra) # 800007da <uartputc>
    8000023e:	bfe1                	j	80000216 <consputc+0x24>

0000000080000240 <consolewrite>:
{
    80000240:	715d                	addi	sp,sp,-80
    80000242:	e486                	sd	ra,72(sp)
    80000244:	e0a2                	sd	s0,64(sp)
    80000246:	fc26                	sd	s1,56(sp)
    80000248:	f84a                	sd	s2,48(sp)
    8000024a:	f44e                	sd	s3,40(sp)
    8000024c:	f052                	sd	s4,32(sp)
    8000024e:	ec56                	sd	s5,24(sp)
    80000250:	0880                	addi	s0,sp,80
    80000252:	89aa                	mv	s3,a0
    80000254:	84ae                	mv	s1,a1
    80000256:	8ab2                	mv	s5,a2
  acquire(&cons.lock);
    80000258:	00011517          	auipc	a0,0x11
    8000025c:	5a850513          	addi	a0,a0,1448 # 80011800 <cons>
    80000260:	00001097          	auipc	ra,0x1
    80000264:	876080e7          	jalr	-1930(ra) # 80000ad6 <acquire>
  for(i = 0; i < n; i++){
    80000268:	03505e63          	blez	s5,800002a4 <consolewrite+0x64>
    8000026c:	00148913          	addi	s2,s1,1
    80000270:	fffa879b          	addiw	a5,s5,-1
    80000274:	1782                	slli	a5,a5,0x20
    80000276:	9381                	srli	a5,a5,0x20
    80000278:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000027a:	5a7d                	li	s4,-1
    8000027c:	4685                	li	a3,1
    8000027e:	8626                	mv	a2,s1
    80000280:	85ce                	mv	a1,s3
    80000282:	fbf40513          	addi	a0,s0,-65
    80000286:	00002097          	auipc	ra,0x2
    8000028a:	076080e7          	jalr	118(ra) # 800022fc <either_copyin>
    8000028e:	01450b63          	beq	a0,s4,800002a4 <consolewrite+0x64>
    consputc(c);
    80000292:	fbf44503          	lbu	a0,-65(s0)
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	f5c080e7          	jalr	-164(ra) # 800001f2 <consputc>
  for(i = 0; i < n; i++){
    8000029e:	0485                	addi	s1,s1,1
    800002a0:	fd249ee3          	bne	s1,s2,8000027c <consolewrite+0x3c>
  release(&cons.lock);
    800002a4:	00011517          	auipc	a0,0x11
    800002a8:	55c50513          	addi	a0,a0,1372 # 80011800 <cons>
    800002ac:	00001097          	auipc	ra,0x1
    800002b0:	892080e7          	jalr	-1902(ra) # 80000b3e <release>
}
    800002b4:	8556                	mv	a0,s5
    800002b6:	60a6                	ld	ra,72(sp)
    800002b8:	6406                	ld	s0,64(sp)
    800002ba:	74e2                	ld	s1,56(sp)
    800002bc:	7942                	ld	s2,48(sp)
    800002be:	79a2                	ld	s3,40(sp)
    800002c0:	7a02                	ld	s4,32(sp)
    800002c2:	6ae2                	ld	s5,24(sp)
    800002c4:	6161                	addi	sp,sp,80
    800002c6:	8082                	ret

00000000800002c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c8:	1101                	addi	sp,sp,-32
    800002ca:	ec06                	sd	ra,24(sp)
    800002cc:	e822                	sd	s0,16(sp)
    800002ce:	e426                	sd	s1,8(sp)
    800002d0:	e04a                	sd	s2,0(sp)
    800002d2:	1000                	addi	s0,sp,32
    800002d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d6:	00011517          	auipc	a0,0x11
    800002da:	52a50513          	addi	a0,a0,1322 # 80011800 <cons>
    800002de:	00000097          	auipc	ra,0x0
    800002e2:	7f8080e7          	jalr	2040(ra) # 80000ad6 <acquire>

  switch(c){
    800002e6:	47d5                	li	a5,21
    800002e8:	0af48663          	beq	s1,a5,80000394 <consoleintr+0xcc>
    800002ec:	0297ca63          	blt	a5,s1,80000320 <consoleintr+0x58>
    800002f0:	47a1                	li	a5,8
    800002f2:	0ef48763          	beq	s1,a5,800003e0 <consoleintr+0x118>
    800002f6:	47c1                	li	a5,16
    800002f8:	10f49a63          	bne	s1,a5,8000040c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fc:	00002097          	auipc	ra,0x2
    80000300:	056080e7          	jalr	86(ra) # 80002352 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000304:	00011517          	auipc	a0,0x11
    80000308:	4fc50513          	addi	a0,a0,1276 # 80011800 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	832080e7          	jalr	-1998(ra) # 80000b3e <release>
}
    80000314:	60e2                	ld	ra,24(sp)
    80000316:	6442                	ld	s0,16(sp)
    80000318:	64a2                	ld	s1,8(sp)
    8000031a:	6902                	ld	s2,0(sp)
    8000031c:	6105                	addi	sp,sp,32
    8000031e:	8082                	ret
  switch(c){
    80000320:	07f00793          	li	a5,127
    80000324:	0af48e63          	beq	s1,a5,800003e0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000328:	00011717          	auipc	a4,0x11
    8000032c:	4d870713          	addi	a4,a4,1240 # 80011800 <cons>
    80000330:	0a072783          	lw	a5,160(a4)
    80000334:	09872703          	lw	a4,152(a4)
    80000338:	9f99                	subw	a5,a5,a4
    8000033a:	07f00713          	li	a4,127
    8000033e:	fcf763e3          	bltu	a4,a5,80000304 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000342:	47b5                	li	a5,13
    80000344:	0cf48763          	beq	s1,a5,80000412 <consoleintr+0x14a>
      consputc(c);
    80000348:	8526                	mv	a0,s1
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	ea8080e7          	jalr	-344(ra) # 800001f2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000352:	00011797          	auipc	a5,0x11
    80000356:	4ae78793          	addi	a5,a5,1198 # 80011800 <cons>
    8000035a:	0a07a703          	lw	a4,160(a5)
    8000035e:	0017069b          	addiw	a3,a4,1
    80000362:	0006861b          	sext.w	a2,a3
    80000366:	0ad7a023          	sw	a3,160(a5)
    8000036a:	07f77713          	andi	a4,a4,127
    8000036e:	97ba                	add	a5,a5,a4
    80000370:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000374:	47a9                	li	a5,10
    80000376:	0cf48563          	beq	s1,a5,80000440 <consoleintr+0x178>
    8000037a:	4791                	li	a5,4
    8000037c:	0cf48263          	beq	s1,a5,80000440 <consoleintr+0x178>
    80000380:	00011797          	auipc	a5,0x11
    80000384:	5187a783          	lw	a5,1304(a5) # 80011898 <cons+0x98>
    80000388:	0807879b          	addiw	a5,a5,128
    8000038c:	f6f61ce3          	bne	a2,a5,80000304 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000390:	863e                	mv	a2,a5
    80000392:	a07d                	j	80000440 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000394:	00011717          	auipc	a4,0x11
    80000398:	46c70713          	addi	a4,a4,1132 # 80011800 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a4:	00011497          	auipc	s1,0x11
    800003a8:	45c48493          	addi	s1,s1,1116 # 80011800 <cons>
    while(cons.e != cons.w &&
    800003ac:	4929                	li	s2,10
    800003ae:	f4f70be3          	beq	a4,a5,80000304 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	07f7f713          	andi	a4,a5,127
    800003b8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ba:	01874703          	lbu	a4,24(a4)
    800003be:	f52703e3          	beq	a4,s2,80000304 <consoleintr+0x3c>
      cons.e--;
    800003c2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	e28080e7          	jalr	-472(ra) # 800001f2 <consputc>
    while(cons.e != cons.w &&
    800003d2:	0a04a783          	lw	a5,160(s1)
    800003d6:	09c4a703          	lw	a4,156(s1)
    800003da:	fcf71ce3          	bne	a4,a5,800003b2 <consoleintr+0xea>
    800003de:	b71d                	j	80000304 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e0:	00011717          	auipc	a4,0x11
    800003e4:	42070713          	addi	a4,a4,1056 # 80011800 <cons>
    800003e8:	0a072783          	lw	a5,160(a4)
    800003ec:	09c72703          	lw	a4,156(a4)
    800003f0:	f0f70ae3          	beq	a4,a5,80000304 <consoleintr+0x3c>
      cons.e--;
    800003f4:	37fd                	addiw	a5,a5,-1
    800003f6:	00011717          	auipc	a4,0x11
    800003fa:	4af72523          	sw	a5,1194(a4) # 800118a0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fe:	10000513          	li	a0,256
    80000402:	00000097          	auipc	ra,0x0
    80000406:	df0080e7          	jalr	-528(ra) # 800001f2 <consputc>
    8000040a:	bded                	j	80000304 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040c:	ee048ce3          	beqz	s1,80000304 <consoleintr+0x3c>
    80000410:	bf21                	j	80000328 <consoleintr+0x60>
      consputc(c);
    80000412:	4529                	li	a0,10
    80000414:	00000097          	auipc	ra,0x0
    80000418:	dde080e7          	jalr	-546(ra) # 800001f2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041c:	00011797          	auipc	a5,0x11
    80000420:	3e478793          	addi	a5,a5,996 # 80011800 <cons>
    80000424:	0a07a703          	lw	a4,160(a5)
    80000428:	0017069b          	addiw	a3,a4,1
    8000042c:	0006861b          	sext.w	a2,a3
    80000430:	0ad7a023          	sw	a3,160(a5)
    80000434:	07f77713          	andi	a4,a4,127
    80000438:	97ba                	add	a5,a5,a4
    8000043a:	4729                	li	a4,10
    8000043c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000440:	00011797          	auipc	a5,0x11
    80000444:	44c7ae23          	sw	a2,1116(a5) # 8001189c <cons+0x9c>
        wakeup(&cons.r);
    80000448:	00011517          	auipc	a0,0x11
    8000044c:	45050513          	addi	a0,a0,1104 # 80011898 <cons+0x98>
    80000450:	00002097          	auipc	ra,0x2
    80000454:	d7c080e7          	jalr	-644(ra) # 800021cc <wakeup>
    80000458:	b575                	j	80000304 <consoleintr+0x3c>

000000008000045a <consoleinit>:

void
consoleinit(void)
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000462:	00007597          	auipc	a1,0x7
    80000466:	cb658593          	addi	a1,a1,-842 # 80007118 <userret+0x88>
    8000046a:	00011517          	auipc	a0,0x11
    8000046e:	39650513          	addi	a0,a0,918 # 80011800 <cons>
    80000472:	00000097          	auipc	ra,0x0
    80000476:	556080e7          	jalr	1366(ra) # 800009c8 <initlock>

  uartinit();
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	32a080e7          	jalr	810(ra) # 800007a4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000482:	00021797          	auipc	a5,0x21
    80000486:	66678793          	addi	a5,a5,1638 # 80021ae8 <devsw>
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c5670713          	addi	a4,a4,-938 # 800000e0 <consoleread>
    80000492:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000494:	00000717          	auipc	a4,0x0
    80000498:	dac70713          	addi	a4,a4,-596 # 80000240 <consolewrite>
    8000049c:	ef98                	sd	a4,24(a5)
}
    8000049e:	60a2                	ld	ra,8(sp)
    800004a0:	6402                	ld	s0,0(sp)
    800004a2:	0141                	addi	sp,sp,16
    800004a4:	8082                	ret

00000000800004a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a6:	7179                	addi	sp,sp,-48
    800004a8:	f406                	sd	ra,40(sp)
    800004aa:	f022                	sd	s0,32(sp)
    800004ac:	ec26                	sd	s1,24(sp)
    800004ae:	e84a                	sd	s2,16(sp)
    800004b0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b2:	c219                	beqz	a2,800004b8 <printint+0x12>
    800004b4:	08054663          	bltz	a0,80000540 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b8:	2501                	sext.w	a0,a0
    800004ba:	4881                	li	a7,0
    800004bc:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c2:	2581                	sext.w	a1,a1
    800004c4:	00007617          	auipc	a2,0x7
    800004c8:	43c60613          	addi	a2,a2,1084 # 80007900 <digits>
    800004cc:	883a                	mv	a6,a4
    800004ce:	2705                	addiw	a4,a4,1
    800004d0:	02b577bb          	remuw	a5,a0,a1
    800004d4:	1782                	slli	a5,a5,0x20
    800004d6:	9381                	srli	a5,a5,0x20
    800004d8:	97b2                	add	a5,a5,a2
    800004da:	0007c783          	lbu	a5,0(a5)
    800004de:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e2:	0005079b          	sext.w	a5,a0
    800004e6:	02b5553b          	divuw	a0,a0,a1
    800004ea:	0685                	addi	a3,a3,1
    800004ec:	feb7f0e3          	bgeu	a5,a1,800004cc <printint+0x26>

  if(sign)
    800004f0:	00088b63          	beqz	a7,80000506 <printint+0x60>
    buf[i++] = '-';
    800004f4:	fe040793          	addi	a5,s0,-32
    800004f8:	973e                	add	a4,a4,a5
    800004fa:	02d00793          	li	a5,45
    800004fe:	fef70823          	sb	a5,-16(a4)
    80000502:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000506:	02e05763          	blez	a4,80000534 <printint+0x8e>
    8000050a:	fd040793          	addi	a5,s0,-48
    8000050e:	00e784b3          	add	s1,a5,a4
    80000512:	fff78913          	addi	s2,a5,-1
    80000516:	993a                	add	s2,s2,a4
    80000518:	377d                	addiw	a4,a4,-1
    8000051a:	1702                	slli	a4,a4,0x20
    8000051c:	9301                	srli	a4,a4,0x20
    8000051e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000522:	fff4c503          	lbu	a0,-1(s1)
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	ccc080e7          	jalr	-820(ra) # 800001f2 <consputc>
  while(--i >= 0)
    8000052e:	14fd                	addi	s1,s1,-1
    80000530:	ff2499e3          	bne	s1,s2,80000522 <printint+0x7c>
}
    80000534:	70a2                	ld	ra,40(sp)
    80000536:	7402                	ld	s0,32(sp)
    80000538:	64e2                	ld	s1,24(sp)
    8000053a:	6942                	ld	s2,16(sp)
    8000053c:	6145                	addi	sp,sp,48
    8000053e:	8082                	ret
    x = -xx;
    80000540:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000544:	4885                	li	a7,1
    x = -xx;
    80000546:	bf9d                	j	800004bc <printint+0x16>

0000000080000548 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000548:	1101                	addi	sp,sp,-32
    8000054a:	ec06                	sd	ra,24(sp)
    8000054c:	e822                	sd	s0,16(sp)
    8000054e:	e426                	sd	s1,8(sp)
    80000550:	1000                	addi	s0,sp,32
    80000552:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	3607a623          	sw	zero,876(a5) # 800118c0 <pr+0x18>
  printf("panic: ");
    8000055c:	00007517          	auipc	a0,0x7
    80000560:	bc450513          	addi	a0,a0,-1084 # 80007120 <userret+0x90>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00007517          	auipc	a0,0x7
    8000057a:	c3a50513          	addi	a0,a0,-966 # 800071b0 <userret+0x120>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	014080e7          	jalr	20(ra) # 80000592 <printf>
  panicked = 1; // freeze other CPUs
    80000586:	4785                	li	a5,1
    80000588:	00029717          	auipc	a4,0x29
    8000058c:	a8f72823          	sw	a5,-1392(a4) # 80029018 <panicked>
  for(;;)
    80000590:	a001                	j	80000590 <panic+0x48>

0000000080000592 <printf>:
{
    80000592:	7131                	addi	sp,sp,-192
    80000594:	fc86                	sd	ra,120(sp)
    80000596:	f8a2                	sd	s0,112(sp)
    80000598:	f4a6                	sd	s1,104(sp)
    8000059a:	f0ca                	sd	s2,96(sp)
    8000059c:	ecce                	sd	s3,88(sp)
    8000059e:	e8d2                	sd	s4,80(sp)
    800005a0:	e4d6                	sd	s5,72(sp)
    800005a2:	e0da                	sd	s6,64(sp)
    800005a4:	fc5e                	sd	s7,56(sp)
    800005a6:	f862                	sd	s8,48(sp)
    800005a8:	f466                	sd	s9,40(sp)
    800005aa:	f06a                	sd	s10,32(sp)
    800005ac:	ec6e                	sd	s11,24(sp)
    800005ae:	0100                	addi	s0,sp,128
    800005b0:	8a2a                	mv	s4,a0
    800005b2:	e40c                	sd	a1,8(s0)
    800005b4:	e810                	sd	a2,16(s0)
    800005b6:	ec14                	sd	a3,24(s0)
    800005b8:	f018                	sd	a4,32(s0)
    800005ba:	f41c                	sd	a5,40(s0)
    800005bc:	03043823          	sd	a6,48(s0)
    800005c0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c4:	00011d97          	auipc	s11,0x11
    800005c8:	2fcdad83          	lw	s11,764(s11) # 800118c0 <pr+0x18>
  if(locking)
    800005cc:	020d9b63          	bnez	s11,80000602 <printf+0x70>
  if (fmt == 0)
    800005d0:	040a0263          	beqz	s4,80000614 <printf+0x82>
  va_start(ap, fmt);
    800005d4:	00840793          	addi	a5,s0,8
    800005d8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005dc:	000a4503          	lbu	a0,0(s4)
    800005e0:	14050f63          	beqz	a0,8000073e <printf+0x1ac>
    800005e4:	4981                	li	s3,0
    if(c != '%'){
    800005e6:	02500a93          	li	s5,37
    switch(c){
    800005ea:	07000b93          	li	s7,112
  consputc('x');
    800005ee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f0:	00007b17          	auipc	s6,0x7
    800005f4:	310b0b13          	addi	s6,s6,784 # 80007900 <digits>
    switch(c){
    800005f8:	07300c93          	li	s9,115
    800005fc:	06400c13          	li	s8,100
    80000600:	a82d                	j	8000063a <printf+0xa8>
    acquire(&pr.lock);
    80000602:	00011517          	auipc	a0,0x11
    80000606:	2a650513          	addi	a0,a0,678 # 800118a8 <pr>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	4cc080e7          	jalr	1228(ra) # 80000ad6 <acquire>
    80000612:	bf7d                	j	800005d0 <printf+0x3e>
    panic("null fmt");
    80000614:	00007517          	auipc	a0,0x7
    80000618:	b1c50513          	addi	a0,a0,-1252 # 80007130 <userret+0xa0>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f2c080e7          	jalr	-212(ra) # 80000548 <panic>
      consputc(c);
    80000624:	00000097          	auipc	ra,0x0
    80000628:	bce080e7          	jalr	-1074(ra) # 800001f2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062c:	2985                	addiw	s3,s3,1
    8000062e:	013a07b3          	add	a5,s4,s3
    80000632:	0007c503          	lbu	a0,0(a5)
    80000636:	10050463          	beqz	a0,8000073e <printf+0x1ac>
    if(c != '%'){
    8000063a:	ff5515e3          	bne	a0,s5,80000624 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063e:	2985                	addiw	s3,s3,1
    80000640:	013a07b3          	add	a5,s4,s3
    80000644:	0007c783          	lbu	a5,0(a5)
    80000648:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000064c:	cbed                	beqz	a5,8000073e <printf+0x1ac>
    switch(c){
    8000064e:	05778a63          	beq	a5,s7,800006a2 <printf+0x110>
    80000652:	02fbf663          	bgeu	s7,a5,8000067e <printf+0xec>
    80000656:	09978863          	beq	a5,s9,800006e6 <printf+0x154>
    8000065a:	07800713          	li	a4,120
    8000065e:	0ce79563          	bne	a5,a4,80000728 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	addi	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4605                	li	a2,1
    80000670:	85ea                	mv	a1,s10
    80000672:	4388                	lw	a0,0(a5)
    80000674:	00000097          	auipc	ra,0x0
    80000678:	e32080e7          	jalr	-462(ra) # 800004a6 <printint>
      break;
    8000067c:	bf45                	j	8000062c <printf+0x9a>
    switch(c){
    8000067e:	09578f63          	beq	a5,s5,8000071c <printf+0x18a>
    80000682:	0b879363          	bne	a5,s8,80000728 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	45a9                	li	a1,10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e0e080e7          	jalr	-498(ra) # 800004a6 <printint>
      break;
    800006a0:	b771                	j	8000062c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006b2:	03000513          	li	a0,48
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	b3c080e7          	jalr	-1220(ra) # 800001f2 <consputc>
  consputc('x');
    800006be:	07800513          	li	a0,120
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	b30080e7          	jalr	-1232(ra) # 800001f2 <consputc>
    800006ca:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006cc:	03c95793          	srli	a5,s2,0x3c
    800006d0:	97da                	add	a5,a5,s6
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	b1c080e7          	jalr	-1252(ra) # 800001f2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006de:	0912                	slli	s2,s2,0x4
    800006e0:	34fd                	addiw	s1,s1,-1
    800006e2:	f4ed                	bnez	s1,800006cc <printf+0x13a>
    800006e4:	b7a1                	j	8000062c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e6:	f8843783          	ld	a5,-120(s0)
    800006ea:	00878713          	addi	a4,a5,8
    800006ee:	f8e43423          	sd	a4,-120(s0)
    800006f2:	6384                	ld	s1,0(a5)
    800006f4:	cc89                	beqz	s1,8000070e <printf+0x17c>
      for(; *s; s++)
    800006f6:	0004c503          	lbu	a0,0(s1)
    800006fa:	d90d                	beqz	a0,8000062c <printf+0x9a>
        consputc(*s);
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	af6080e7          	jalr	-1290(ra) # 800001f2 <consputc>
      for(; *s; s++)
    80000704:	0485                	addi	s1,s1,1
    80000706:	0004c503          	lbu	a0,0(s1)
    8000070a:	f96d                	bnez	a0,800006fc <printf+0x16a>
    8000070c:	b705                	j	8000062c <printf+0x9a>
        s = "(null)";
    8000070e:	00007497          	auipc	s1,0x7
    80000712:	a1a48493          	addi	s1,s1,-1510 # 80007128 <userret+0x98>
      for(; *s; s++)
    80000716:	02800513          	li	a0,40
    8000071a:	b7cd                	j	800006fc <printf+0x16a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	ad4080e7          	jalr	-1324(ra) # 800001f2 <consputc>
      break;
    80000726:	b719                	j	8000062c <printf+0x9a>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ac8080e7          	jalr	-1336(ra) # 800001f2 <consputc>
      consputc(c);
    80000732:	8526                	mv	a0,s1
    80000734:	00000097          	auipc	ra,0x0
    80000738:	abe080e7          	jalr	-1346(ra) # 800001f2 <consputc>
      break;
    8000073c:	bdc5                	j	8000062c <printf+0x9a>
  if(locking)
    8000073e:	020d9163          	bnez	s11,80000760 <printf+0x1ce>
}
    80000742:	70e6                	ld	ra,120(sp)
    80000744:	7446                	ld	s0,112(sp)
    80000746:	74a6                	ld	s1,104(sp)
    80000748:	7906                	ld	s2,96(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7ca2                	ld	s9,40(sp)
    80000758:	7d02                	ld	s10,32(sp)
    8000075a:	6de2                	ld	s11,24(sp)
    8000075c:	6129                	addi	sp,sp,192
    8000075e:	8082                	ret
    release(&pr.lock);
    80000760:	00011517          	auipc	a0,0x11
    80000764:	14850513          	addi	a0,a0,328 # 800118a8 <pr>
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	3d6080e7          	jalr	982(ra) # 80000b3e <release>
}
    80000770:	bfc9                	j	80000742 <printf+0x1b0>

0000000080000772 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000772:	1101                	addi	sp,sp,-32
    80000774:	ec06                	sd	ra,24(sp)
    80000776:	e822                	sd	s0,16(sp)
    80000778:	e426                	sd	s1,8(sp)
    8000077a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077c:	00011497          	auipc	s1,0x11
    80000780:	12c48493          	addi	s1,s1,300 # 800118a8 <pr>
    80000784:	00007597          	auipc	a1,0x7
    80000788:	9bc58593          	addi	a1,a1,-1604 # 80007140 <userret+0xb0>
    8000078c:	8526                	mv	a0,s1
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	23a080e7          	jalr	570(ra) # 800009c8 <initlock>
  pr.locking = 1;
    80000796:	4785                	li	a5,1
    80000798:	cc9c                	sw	a5,24(s1)
}
    8000079a:	60e2                	ld	ra,24(sp)
    8000079c:	6442                	ld	s0,16(sp)
    8000079e:	64a2                	ld	s1,8(sp)
    800007a0:	6105                	addi	sp,sp,32
    800007a2:	8082                	ret

00000000800007a4 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007a4:	1141                	addi	sp,sp,-16
    800007a6:	e422                	sd	s0,8(sp)
    800007a8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007aa:	100007b7          	lui	a5,0x10000
    800007ae:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007b2:	f8000713          	li	a4,-128
    800007b6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ba:	470d                	li	a4,3
    800007bc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007c4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007c8:	471d                	li	a4,7
    800007ca:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007ce:	4705                	li	a4,1
    800007d0:	00e780a3          	sb	a4,1(a5)
}
    800007d4:	6422                	ld	s0,8(sp)
    800007d6:	0141                	addi	sp,sp,16
    800007d8:	8082                	ret

00000000800007da <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007da:	1141                	addi	sp,sp,-16
    800007dc:	e422                	sd	s0,8(sp)
    800007de:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007e0:	10000737          	lui	a4,0x10000
    800007e4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007e8:	0207f793          	andi	a5,a5,32
    800007ec:	dfe5                	beqz	a5,800007e4 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007ee:	0ff57513          	andi	a0,a0,255
    800007f2:	100007b7          	lui	a5,0x10000
    800007f6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    800007fa:	6422                	ld	s0,8(sp)
    800007fc:	0141                	addi	sp,sp,16
    800007fe:	8082                	ret

0000000080000800 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000800:	1141                	addi	sp,sp,-16
    80000802:	e422                	sd	s0,8(sp)
    80000804:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000806:	100007b7          	lui	a5,0x10000
    8000080a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000080e:	8b85                	andi	a5,a5,1
    80000810:	cb91                	beqz	a5,80000824 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000812:	100007b7          	lui	a5,0x10000
    80000816:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000081a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000081e:	6422                	ld	s0,8(sp)
    80000820:	0141                	addi	sp,sp,16
    80000822:	8082                	ret
    return -1;
    80000824:	557d                	li	a0,-1
    80000826:	bfe5                	j	8000081e <uartgetc+0x1e>

0000000080000828 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000828:	1101                	addi	sp,sp,-32
    8000082a:	ec06                	sd	ra,24(sp)
    8000082c:	e822                	sd	s0,16(sp)
    8000082e:	e426                	sd	s1,8(sp)
    80000830:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000832:	54fd                	li	s1,-1
    80000834:	a029                	j	8000083e <uartintr+0x16>
      break;
    consoleintr(c);
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	a92080e7          	jalr	-1390(ra) # 800002c8 <consoleintr>
    int c = uartgetc();
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	fc2080e7          	jalr	-62(ra) # 80000800 <uartgetc>
    if(c == -1)
    80000846:	fe9518e3          	bne	a0,s1,80000836 <uartintr+0xe>
  }
}
    8000084a:	60e2                	ld	ra,24(sp)
    8000084c:	6442                	ld	s0,16(sp)
    8000084e:	64a2                	ld	s1,8(sp)
    80000850:	6105                	addi	sp,sp,32
    80000852:	8082                	ret

0000000080000854 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	e04a                	sd	s2,0(sp)
    8000085e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000860:	03451793          	slli	a5,a0,0x34
    80000864:	ebb9                	bnez	a5,800008ba <kfree+0x66>
    80000866:	84aa                	mv	s1,a0
    80000868:	00028797          	auipc	a5,0x28
    8000086c:	7dc78793          	addi	a5,a5,2012 # 80029044 <end>
    80000870:	04f56563          	bltu	a0,a5,800008ba <kfree+0x66>
    80000874:	47c5                	li	a5,17
    80000876:	07ee                	slli	a5,a5,0x1b
    80000878:	04f57163          	bgeu	a0,a5,800008ba <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4585                	li	a1,1
    80000880:	00000097          	auipc	ra,0x0
    80000884:	31a080e7          	jalr	794(ra) # 80000b9a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000888:	00011917          	auipc	s2,0x11
    8000088c:	04090913          	addi	s2,s2,64 # 800118c8 <kmem>
    80000890:	854a                	mv	a0,s2
    80000892:	00000097          	auipc	ra,0x0
    80000896:	244080e7          	jalr	580(ra) # 80000ad6 <acquire>
  r->next = kmem.freelist;
    8000089a:	01893783          	ld	a5,24(s2)
    8000089e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008a0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008a4:	854a                	mv	a0,s2
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	298080e7          	jalr	664(ra) # 80000b3e <release>
}
    800008ae:	60e2                	ld	ra,24(sp)
    800008b0:	6442                	ld	s0,16(sp)
    800008b2:	64a2                	ld	s1,8(sp)
    800008b4:	6902                	ld	s2,0(sp)
    800008b6:	6105                	addi	sp,sp,32
    800008b8:	8082                	ret
    panic("kfree");
    800008ba:	00007517          	auipc	a0,0x7
    800008be:	88e50513          	addi	a0,a0,-1906 # 80007148 <userret+0xb8>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	c86080e7          	jalr	-890(ra) # 80000548 <panic>

00000000800008ca <freerange>:
{
    800008ca:	7179                	addi	sp,sp,-48
    800008cc:	f406                	sd	ra,40(sp)
    800008ce:	f022                	sd	s0,32(sp)
    800008d0:	ec26                	sd	s1,24(sp)
    800008d2:	e84a                	sd	s2,16(sp)
    800008d4:	e44e                	sd	s3,8(sp)
    800008d6:	e052                	sd	s4,0(sp)
    800008d8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008da:	6785                	lui	a5,0x1
    800008dc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800008e0:	94aa                	add	s1,s1,a0
    800008e2:	757d                	lui	a0,0xfffff
    800008e4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008e6:	94be                	add	s1,s1,a5
    800008e8:	0095ee63          	bltu	a1,s1,80000904 <freerange+0x3a>
    800008ec:	892e                	mv	s2,a1
    kfree(p);
    800008ee:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008f0:	6985                	lui	s3,0x1
    kfree(p);
    800008f2:	01448533          	add	a0,s1,s4
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	f5e080e7          	jalr	-162(ra) # 80000854 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008fe:	94ce                	add	s1,s1,s3
    80000900:	fe9979e3          	bgeu	s2,s1,800008f2 <freerange+0x28>
}
    80000904:	70a2                	ld	ra,40(sp)
    80000906:	7402                	ld	s0,32(sp)
    80000908:	64e2                	ld	s1,24(sp)
    8000090a:	6942                	ld	s2,16(sp)
    8000090c:	69a2                	ld	s3,8(sp)
    8000090e:	6a02                	ld	s4,0(sp)
    80000910:	6145                	addi	sp,sp,48
    80000912:	8082                	ret

0000000080000914 <kinit>:
{
    80000914:	1101                	addi	sp,sp,-32
    80000916:	ec06                	sd	ra,24(sp)
    80000918:	e822                	sd	s0,16(sp)
    8000091a:	e426                	sd	s1,8(sp)
    8000091c:	1000                	addi	s0,sp,32
  initlock(&kmem.lock, "kmem");
    8000091e:	00007597          	auipc	a1,0x7
    80000922:	83258593          	addi	a1,a1,-1998 # 80007150 <userret+0xc0>
    80000926:	00011517          	auipc	a0,0x11
    8000092a:	fa250513          	addi	a0,a0,-94 # 800118c8 <kmem>
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	09a080e7          	jalr	154(ra) # 800009c8 <initlock>
  freerange(end, p);
    80000936:	087ff4b7          	lui	s1,0x87ff
    8000093a:	00449593          	slli	a1,s1,0x4
    8000093e:	00028517          	auipc	a0,0x28
    80000942:	70650513          	addi	a0,a0,1798 # 80029044 <end>
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	f84080e7          	jalr	-124(ra) # 800008ca <freerange>
  bd_init(p, p+MAXHEAP);
    8000094e:	45c5                	li	a1,17
    80000950:	05ee                	slli	a1,a1,0x1b
    80000952:	00449513          	slli	a0,s1,0x4
    80000956:	00006097          	auipc	ra,0x6
    8000095a:	f44080e7          	jalr	-188(ra) # 8000689a <bd_init>
}
    8000095e:	60e2                	ld	ra,24(sp)
    80000960:	6442                	ld	s0,16(sp)
    80000962:	64a2                	ld	s1,8(sp)
    80000964:	6105                	addi	sp,sp,32
    80000966:	8082                	ret

0000000080000968 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000968:	1101                	addi	sp,sp,-32
    8000096a:	ec06                	sd	ra,24(sp)
    8000096c:	e822                	sd	s0,16(sp)
    8000096e:	e426                	sd	s1,8(sp)
    80000970:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000972:	00011497          	auipc	s1,0x11
    80000976:	f5648493          	addi	s1,s1,-170 # 800118c8 <kmem>
    8000097a:	8526                	mv	a0,s1
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	15a080e7          	jalr	346(ra) # 80000ad6 <acquire>
  r = kmem.freelist;
    80000984:	6c84                	ld	s1,24(s1)
  if(r)
    80000986:	c885                	beqz	s1,800009b6 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000988:	609c                	ld	a5,0(s1)
    8000098a:	00011517          	auipc	a0,0x11
    8000098e:	f3e50513          	addi	a0,a0,-194 # 800118c8 <kmem>
    80000992:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	1aa080e7          	jalr	426(ra) # 80000b3e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000099c:	6605                	lui	a2,0x1
    8000099e:	4595                	li	a1,5
    800009a0:	8526                	mv	a0,s1
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	1f8080e7          	jalr	504(ra) # 80000b9a <memset>
  return (void*)r;
}
    800009aa:	8526                	mv	a0,s1
    800009ac:	60e2                	ld	ra,24(sp)
    800009ae:	6442                	ld	s0,16(sp)
    800009b0:	64a2                	ld	s1,8(sp)
    800009b2:	6105                	addi	sp,sp,32
    800009b4:	8082                	ret
  release(&kmem.lock);
    800009b6:	00011517          	auipc	a0,0x11
    800009ba:	f1250513          	addi	a0,a0,-238 # 800118c8 <kmem>
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	180080e7          	jalr	384(ra) # 80000b3e <release>
  if(r)
    800009c6:	b7d5                	j	800009aa <kalloc+0x42>

00000000800009c8 <initlock>:

uint64 ntest_and_set;

void
initlock(struct spinlock *lk, char *name)
{
    800009c8:	1141                	addi	sp,sp,-16
    800009ca:	e422                	sd	s0,8(sp)
    800009cc:	0800                	addi	s0,sp,16
  lk->name = name;
    800009ce:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009d0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009d4:	00053823          	sd	zero,16(a0)
}
    800009d8:	6422                	ld	s0,8(sp)
    800009da:	0141                	addi	sp,sp,16
    800009dc:	8082                	ret

00000000800009de <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009e8:	100024f3          	csrr	s1,sstatus
    800009ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800009f0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800009f2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800009f6:	00001097          	auipc	ra,0x1
    800009fa:	e24080e7          	jalr	-476(ra) # 8000181a <mycpu>
    800009fe:	5d3c                	lw	a5,120(a0)
    80000a00:	cf89                	beqz	a5,80000a1a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000a02:	00001097          	auipc	ra,0x1
    80000a06:	e18080e7          	jalr	-488(ra) # 8000181a <mycpu>
    80000a0a:	5d3c                	lw	a5,120(a0)
    80000a0c:	2785                	addiw	a5,a5,1
    80000a0e:	dd3c                	sw	a5,120(a0)
}
    80000a10:	60e2                	ld	ra,24(sp)
    80000a12:	6442                	ld	s0,16(sp)
    80000a14:	64a2                	ld	s1,8(sp)
    80000a16:	6105                	addi	sp,sp,32
    80000a18:	8082                	ret
    mycpu()->intena = old;
    80000a1a:	00001097          	auipc	ra,0x1
    80000a1e:	e00080e7          	jalr	-512(ra) # 8000181a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a22:	8085                	srli	s1,s1,0x1
    80000a24:	8885                	andi	s1,s1,1
    80000a26:	dd64                	sw	s1,124(a0)
    80000a28:	bfe9                	j	80000a02 <push_off+0x24>

0000000080000a2a <pop_off>:

void
pop_off(void)
{
    80000a2a:	1141                	addi	sp,sp,-16
    80000a2c:	e406                	sd	ra,8(sp)
    80000a2e:	e022                	sd	s0,0(sp)
    80000a30:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a32:	00001097          	auipc	ra,0x1
    80000a36:	de8080e7          	jalr	-536(ra) # 8000181a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a40:	eb9d                	bnez	a5,80000a76 <pop_off+0x4c>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a42:	5d3c                	lw	a5,120(a0)
    80000a44:	37fd                	addiw	a5,a5,-1
    80000a46:	0007871b          	sext.w	a4,a5
    80000a4a:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a4c:	02074d63          	bltz	a4,80000a86 <pop_off+0x5c>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a50:	ef19                	bnez	a4,80000a6e <pop_off+0x44>
    80000a52:	5d7c                	lw	a5,124(a0)
    80000a54:	cf89                	beqz	a5,80000a6e <pop_off+0x44>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a56:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a5a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a5e:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a6a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a6e:	60a2                	ld	ra,8(sp)
    80000a70:	6402                	ld	s0,0(sp)
    80000a72:	0141                	addi	sp,sp,16
    80000a74:	8082                	ret
    panic("pop_off - interruptible");
    80000a76:	00006517          	auipc	a0,0x6
    80000a7a:	6e250513          	addi	a0,a0,1762 # 80007158 <userret+0xc8>
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	aca080e7          	jalr	-1334(ra) # 80000548 <panic>
    panic("pop_off");
    80000a86:	00006517          	auipc	a0,0x6
    80000a8a:	6ea50513          	addi	a0,a0,1770 # 80007170 <userret+0xe0>
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	aba080e7          	jalr	-1350(ra) # 80000548 <panic>

0000000080000a96 <holding>:
{
    80000a96:	1101                	addi	sp,sp,-32
    80000a98:	ec06                	sd	ra,24(sp)
    80000a9a:	e822                	sd	s0,16(sp)
    80000a9c:	e426                	sd	s1,8(sp)
    80000a9e:	1000                	addi	s0,sp,32
    80000aa0:	84aa                	mv	s1,a0
  push_off();
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	f3c080e7          	jalr	-196(ra) # 800009de <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000aaa:	409c                	lw	a5,0(s1)
    80000aac:	ef81                	bnez	a5,80000ac4 <holding+0x2e>
    80000aae:	4481                	li	s1,0
  pop_off();
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	f7a080e7          	jalr	-134(ra) # 80000a2a <pop_off>
}
    80000ab8:	8526                	mv	a0,s1
    80000aba:	60e2                	ld	ra,24(sp)
    80000abc:	6442                	ld	s0,16(sp)
    80000abe:	64a2                	ld	s1,8(sp)
    80000ac0:	6105                	addi	sp,sp,32
    80000ac2:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ac4:	6884                	ld	s1,16(s1)
    80000ac6:	00001097          	auipc	ra,0x1
    80000aca:	d54080e7          	jalr	-684(ra) # 8000181a <mycpu>
    80000ace:	8c89                	sub	s1,s1,a0
    80000ad0:	0014b493          	seqz	s1,s1
    80000ad4:	bff1                	j	80000ab0 <holding+0x1a>

0000000080000ad6 <acquire>:
{
    80000ad6:	1101                	addi	sp,sp,-32
    80000ad8:	ec06                	sd	ra,24(sp)
    80000ada:	e822                	sd	s0,16(sp)
    80000adc:	e426                	sd	s1,8(sp)
    80000ade:	1000                	addi	s0,sp,32
    80000ae0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	efc080e7          	jalr	-260(ra) # 800009de <push_off>
  if(holding(lk))
    80000aea:	8526                	mv	a0,s1
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	faa080e7          	jalr	-86(ra) # 80000a96 <holding>
    80000af4:	e901                	bnez	a0,80000b04 <acquire+0x2e>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000af6:	4685                	li	a3,1
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000af8:	00028717          	auipc	a4,0x28
    80000afc:	52870713          	addi	a4,a4,1320 # 80029020 <ntest_and_set>
    80000b00:	4605                	li	a2,1
    80000b02:	a829                	j	80000b1c <acquire+0x46>
    panic("acquire");
    80000b04:	00006517          	auipc	a0,0x6
    80000b08:	67450513          	addi	a0,a0,1652 # 80007178 <userret+0xe8>
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	a3c080e7          	jalr	-1476(ra) # 80000548 <panic>
     __sync_fetch_and_add(&ntest_and_set, 1);
    80000b14:	0f50000f          	fence	iorw,ow
    80000b18:	04c7302f          	amoadd.d.aq	zero,a2,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000b1c:	87b6                	mv	a5,a3
    80000b1e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b22:	2781                	sext.w	a5,a5
    80000b24:	fbe5                	bnez	a5,80000b14 <acquire+0x3e>
  __sync_synchronize();
    80000b26:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b2a:	00001097          	auipc	ra,0x1
    80000b2e:	cf0080e7          	jalr	-784(ra) # 8000181a <mycpu>
    80000b32:	e888                	sd	a0,16(s1)
}
    80000b34:	60e2                	ld	ra,24(sp)
    80000b36:	6442                	ld	s0,16(sp)
    80000b38:	64a2                	ld	s1,8(sp)
    80000b3a:	6105                	addi	sp,sp,32
    80000b3c:	8082                	ret

0000000080000b3e <release>:
{
    80000b3e:	1101                	addi	sp,sp,-32
    80000b40:	ec06                	sd	ra,24(sp)
    80000b42:	e822                	sd	s0,16(sp)
    80000b44:	e426                	sd	s1,8(sp)
    80000b46:	1000                	addi	s0,sp,32
    80000b48:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	f4c080e7          	jalr	-180(ra) # 80000a96 <holding>
    80000b52:	c115                	beqz	a0,80000b76 <release+0x38>
  lk->cpu = 0;
    80000b54:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b58:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b5c:	0f50000f          	fence	iorw,ow
    80000b60:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	ec6080e7          	jalr	-314(ra) # 80000a2a <pop_off>
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret
    panic("release");
    80000b76:	00006517          	auipc	a0,0x6
    80000b7a:	60a50513          	addi	a0,a0,1546 # 80007180 <userret+0xf0>
    80000b7e:	00000097          	auipc	ra,0x0
    80000b82:	9ca080e7          	jalr	-1590(ra) # 80000548 <panic>

0000000080000b86 <sys_ntas>:

uint64
sys_ntas(void)
{
    80000b86:	1141                	addi	sp,sp,-16
    80000b88:	e422                	sd	s0,8(sp)
    80000b8a:	0800                	addi	s0,sp,16
  return ntest_and_set;
}
    80000b8c:	00028517          	auipc	a0,0x28
    80000b90:	49453503          	ld	a0,1172(a0) # 80029020 <ntest_and_set>
    80000b94:	6422                	ld	s0,8(sp)
    80000b96:	0141                	addi	sp,sp,16
    80000b98:	8082                	ret

0000000080000b9a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000b9a:	1141                	addi	sp,sp,-16
    80000b9c:	e422                	sd	s0,8(sp)
    80000b9e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ba0:	ca19                	beqz	a2,80000bb6 <memset+0x1c>
    80000ba2:	87aa                	mv	a5,a0
    80000ba4:	1602                	slli	a2,a2,0x20
    80000ba6:	9201                	srli	a2,a2,0x20
    80000ba8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000bac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000bb0:	0785                	addi	a5,a5,1
    80000bb2:	fee79de3          	bne	a5,a4,80000bac <memset+0x12>
  }
  return dst;
}
    80000bb6:	6422                	ld	s0,8(sp)
    80000bb8:	0141                	addi	sp,sp,16
    80000bba:	8082                	ret

0000000080000bbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000bbc:	1141                	addi	sp,sp,-16
    80000bbe:	e422                	sd	s0,8(sp)
    80000bc0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000bc2:	ca05                	beqz	a2,80000bf2 <memcmp+0x36>
    80000bc4:	fff6069b          	addiw	a3,a2,-1
    80000bc8:	1682                	slli	a3,a3,0x20
    80000bca:	9281                	srli	a3,a3,0x20
    80000bcc:	0685                	addi	a3,a3,1
    80000bce:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000bd0:	00054783          	lbu	a5,0(a0)
    80000bd4:	0005c703          	lbu	a4,0(a1)
    80000bd8:	00e79863          	bne	a5,a4,80000be8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bdc:	0505                	addi	a0,a0,1
    80000bde:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000be0:	fed518e3          	bne	a0,a3,80000bd0 <memcmp+0x14>
  }

  return 0;
    80000be4:	4501                	li	a0,0
    80000be6:	a019                	j	80000bec <memcmp+0x30>
      return *s1 - *s2;
    80000be8:	40e7853b          	subw	a0,a5,a4
}
    80000bec:	6422                	ld	s0,8(sp)
    80000bee:	0141                	addi	sp,sp,16
    80000bf0:	8082                	ret
  return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	bfe5                	j	80000bec <memcmp+0x30>

0000000080000bf6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000bf6:	1141                	addi	sp,sp,-16
    80000bf8:	e422                	sd	s0,8(sp)
    80000bfa:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000bfc:	02a5e563          	bltu	a1,a0,80000c26 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000c00:	fff6069b          	addiw	a3,a2,-1
    80000c04:	ce11                	beqz	a2,80000c20 <memmove+0x2a>
    80000c06:	1682                	slli	a3,a3,0x20
    80000c08:	9281                	srli	a3,a3,0x20
    80000c0a:	0685                	addi	a3,a3,1
    80000c0c:	96ae                	add	a3,a3,a1
    80000c0e:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000c10:	0585                	addi	a1,a1,1
    80000c12:	0785                	addi	a5,a5,1
    80000c14:	fff5c703          	lbu	a4,-1(a1)
    80000c18:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000c1c:	fed59ae3          	bne	a1,a3,80000c10 <memmove+0x1a>

  return dst;
}
    80000c20:	6422                	ld	s0,8(sp)
    80000c22:	0141                	addi	sp,sp,16
    80000c24:	8082                	ret
  if(s < d && s + n > d){
    80000c26:	02061713          	slli	a4,a2,0x20
    80000c2a:	9301                	srli	a4,a4,0x20
    80000c2c:	00e587b3          	add	a5,a1,a4
    80000c30:	fcf578e3          	bgeu	a0,a5,80000c00 <memmove+0xa>
    d += n;
    80000c34:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c36:	fff6069b          	addiw	a3,a2,-1
    80000c3a:	d27d                	beqz	a2,80000c20 <memmove+0x2a>
    80000c3c:	02069613          	slli	a2,a3,0x20
    80000c40:	9201                	srli	a2,a2,0x20
    80000c42:	fff64613          	not	a2,a2
    80000c46:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c48:	17fd                	addi	a5,a5,-1
    80000c4a:	177d                	addi	a4,a4,-1
    80000c4c:	0007c683          	lbu	a3,0(a5)
    80000c50:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c54:	fef61ae3          	bne	a2,a5,80000c48 <memmove+0x52>
    80000c58:	b7e1                	j	80000c20 <memmove+0x2a>

0000000080000c5a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c5a:	1141                	addi	sp,sp,-16
    80000c5c:	e406                	sd	ra,8(sp)
    80000c5e:	e022                	sd	s0,0(sp)
    80000c60:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c62:	00000097          	auipc	ra,0x0
    80000c66:	f94080e7          	jalr	-108(ra) # 80000bf6 <memmove>
}
    80000c6a:	60a2                	ld	ra,8(sp)
    80000c6c:	6402                	ld	s0,0(sp)
    80000c6e:	0141                	addi	sp,sp,16
    80000c70:	8082                	ret

0000000080000c72 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c72:	1141                	addi	sp,sp,-16
    80000c74:	e422                	sd	s0,8(sp)
    80000c76:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c78:	ce11                	beqz	a2,80000c94 <strncmp+0x22>
    80000c7a:	00054783          	lbu	a5,0(a0)
    80000c7e:	cf89                	beqz	a5,80000c98 <strncmp+0x26>
    80000c80:	0005c703          	lbu	a4,0(a1)
    80000c84:	00f71a63          	bne	a4,a5,80000c98 <strncmp+0x26>
    n--, p++, q++;
    80000c88:	367d                	addiw	a2,a2,-1
    80000c8a:	0505                	addi	a0,a0,1
    80000c8c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000c8e:	f675                	bnez	a2,80000c7a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000c90:	4501                	li	a0,0
    80000c92:	a809                	j	80000ca4 <strncmp+0x32>
    80000c94:	4501                	li	a0,0
    80000c96:	a039                	j	80000ca4 <strncmp+0x32>
  if(n == 0)
    80000c98:	ca09                	beqz	a2,80000caa <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000c9a:	00054503          	lbu	a0,0(a0)
    80000c9e:	0005c783          	lbu	a5,0(a1)
    80000ca2:	9d1d                	subw	a0,a0,a5
}
    80000ca4:	6422                	ld	s0,8(sp)
    80000ca6:	0141                	addi	sp,sp,16
    80000ca8:	8082                	ret
    return 0;
    80000caa:	4501                	li	a0,0
    80000cac:	bfe5                	j	80000ca4 <strncmp+0x32>

0000000080000cae <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000cae:	1141                	addi	sp,sp,-16
    80000cb0:	e422                	sd	s0,8(sp)
    80000cb2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000cb4:	872a                	mv	a4,a0
    80000cb6:	8832                	mv	a6,a2
    80000cb8:	367d                	addiw	a2,a2,-1
    80000cba:	01005963          	blez	a6,80000ccc <strncpy+0x1e>
    80000cbe:	0705                	addi	a4,a4,1
    80000cc0:	0005c783          	lbu	a5,0(a1)
    80000cc4:	fef70fa3          	sb	a5,-1(a4)
    80000cc8:	0585                	addi	a1,a1,1
    80000cca:	f7f5                	bnez	a5,80000cb6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ccc:	86ba                	mv	a3,a4
    80000cce:	00c05c63          	blez	a2,80000ce6 <strncpy+0x38>
    *s++ = 0;
    80000cd2:	0685                	addi	a3,a3,1
    80000cd4:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cd8:	fff6c793          	not	a5,a3
    80000cdc:	9fb9                	addw	a5,a5,a4
    80000cde:	010787bb          	addw	a5,a5,a6
    80000ce2:	fef048e3          	bgtz	a5,80000cd2 <strncpy+0x24>
  return os;
}
    80000ce6:	6422                	ld	s0,8(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret

0000000080000cec <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000cec:	1141                	addi	sp,sp,-16
    80000cee:	e422                	sd	s0,8(sp)
    80000cf0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000cf2:	02c05363          	blez	a2,80000d18 <safestrcpy+0x2c>
    80000cf6:	fff6069b          	addiw	a3,a2,-1
    80000cfa:	1682                	slli	a3,a3,0x20
    80000cfc:	9281                	srli	a3,a3,0x20
    80000cfe:	96ae                	add	a3,a3,a1
    80000d00:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000d02:	00d58963          	beq	a1,a3,80000d14 <safestrcpy+0x28>
    80000d06:	0585                	addi	a1,a1,1
    80000d08:	0785                	addi	a5,a5,1
    80000d0a:	fff5c703          	lbu	a4,-1(a1)
    80000d0e:	fee78fa3          	sb	a4,-1(a5)
    80000d12:	fb65                	bnez	a4,80000d02 <safestrcpy+0x16>
    ;
  *s = 0;
    80000d14:	00078023          	sb	zero,0(a5)
  return os;
}
    80000d18:	6422                	ld	s0,8(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <strlen>:

int
strlen(const char *s)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e422                	sd	s0,8(sp)
    80000d22:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000d24:	00054783          	lbu	a5,0(a0)
    80000d28:	cf91                	beqz	a5,80000d44 <strlen+0x26>
    80000d2a:	0505                	addi	a0,a0,1
    80000d2c:	87aa                	mv	a5,a0
    80000d2e:	4685                	li	a3,1
    80000d30:	9e89                	subw	a3,a3,a0
    80000d32:	00f6853b          	addw	a0,a3,a5
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff7c703          	lbu	a4,-1(a5)
    80000d3c:	fb7d                	bnez	a4,80000d32 <strlen+0x14>
    ;
  return n;
}
    80000d3e:	6422                	ld	s0,8(sp)
    80000d40:	0141                	addi	sp,sp,16
    80000d42:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d44:	4501                	li	a0,0
    80000d46:	bfe5                	j	80000d3e <strlen+0x20>

0000000080000d48 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d48:	1141                	addi	sp,sp,-16
    80000d4a:	e406                	sd	ra,8(sp)
    80000d4c:	e022                	sd	s0,0(sp)
    80000d4e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d50:	00001097          	auipc	ra,0x1
    80000d54:	aba080e7          	jalr	-1350(ra) # 8000180a <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d58:	00028717          	auipc	a4,0x28
    80000d5c:	2d070713          	addi	a4,a4,720 # 80029028 <started>
  if(cpuid() == 0){
    80000d60:	c139                	beqz	a0,80000da6 <main+0x5e>
    while(started == 0)
    80000d62:	431c                	lw	a5,0(a4)
    80000d64:	2781                	sext.w	a5,a5
    80000d66:	dff5                	beqz	a5,80000d62 <main+0x1a>
      ;
    __sync_synchronize();
    80000d68:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d6c:	00001097          	auipc	ra,0x1
    80000d70:	a9e080e7          	jalr	-1378(ra) # 8000180a <cpuid>
    80000d74:	85aa                	mv	a1,a0
    80000d76:	00006517          	auipc	a0,0x6
    80000d7a:	42a50513          	addi	a0,a0,1066 # 800071a0 <userret+0x110>
    80000d7e:	00000097          	auipc	ra,0x0
    80000d82:	814080e7          	jalr	-2028(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	1ea080e7          	jalr	490(ra) # 80000f70 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d8e:	00001097          	auipc	ra,0x1
    80000d92:	706080e7          	jalr	1798(ra) # 80002494 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	f3a080e7          	jalr	-198(ra) # 80005cd0 <plicinithart>
  }

  scheduler();        
    80000d9e:	00001097          	auipc	ra,0x1
    80000da2:	fde080e7          	jalr	-34(ra) # 80001d7c <scheduler>
    consoleinit();
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	6b4080e7          	jalr	1716(ra) # 8000045a <consoleinit>
    printfinit();
    80000dae:	00000097          	auipc	ra,0x0
    80000db2:	9c4080e7          	jalr	-1596(ra) # 80000772 <printfinit>
    printf("\n");
    80000db6:	00006517          	auipc	a0,0x6
    80000dba:	3fa50513          	addi	a0,a0,1018 # 800071b0 <userret+0x120>
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	7d4080e7          	jalr	2004(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000dc6:	00006517          	auipc	a0,0x6
    80000dca:	3c250513          	addi	a0,a0,962 # 80007188 <userret+0xf8>
    80000dce:	fffff097          	auipc	ra,0xfffff
    80000dd2:	7c4080e7          	jalr	1988(ra) # 80000592 <printf>
    printf("\n");
    80000dd6:	00006517          	auipc	a0,0x6
    80000dda:	3da50513          	addi	a0,a0,986 # 800071b0 <userret+0x120>
    80000dde:	fffff097          	auipc	ra,0xfffff
    80000de2:	7b4080e7          	jalr	1972(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000de6:	00000097          	auipc	ra,0x0
    80000dea:	b2e080e7          	jalr	-1234(ra) # 80000914 <kinit>
    kvminit();       // create kernel page table
    80000dee:	00000097          	auipc	ra,0x0
    80000df2:	300080e7          	jalr	768(ra) # 800010ee <kvminit>
    kvminithart();   // turn on paging
    80000df6:	00000097          	auipc	ra,0x0
    80000dfa:	17a080e7          	jalr	378(ra) # 80000f70 <kvminithart>
    procinit();      // process table
    80000dfe:	00001097          	auipc	ra,0x1
    80000e02:	93c080e7          	jalr	-1732(ra) # 8000173a <procinit>
    trapinit();      // trap vectors
    80000e06:	00001097          	auipc	ra,0x1
    80000e0a:	666080e7          	jalr	1638(ra) # 8000246c <trapinit>
    trapinithart();  // install kernel trap vector
    80000e0e:	00001097          	auipc	ra,0x1
    80000e12:	686080e7          	jalr	1670(ra) # 80002494 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	ea4080e7          	jalr	-348(ra) # 80005cba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e1e:	00005097          	auipc	ra,0x5
    80000e22:	eb2080e7          	jalr	-334(ra) # 80005cd0 <plicinithart>
    binit();         // buffer cache
    80000e26:	00002097          	auipc	ra,0x2
    80000e2a:	daa080e7          	jalr	-598(ra) # 80002bd0 <binit>
    iinit();         // inode cache
    80000e2e:	00002097          	auipc	ra,0x2
    80000e32:	440080e7          	jalr	1088(ra) # 8000326e <iinit>
    fileinit();      // file table
    80000e36:	00003097          	auipc	ra,0x3
    80000e3a:	61e080e7          	jalr	1566(ra) # 80004454 <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80000e3e:	4501                	li	a0,0
    80000e40:	00005097          	auipc	ra,0x5
    80000e44:	fc4080e7          	jalr	-60(ra) # 80005e04 <virtio_disk_init>
    userinit();      // first user process
    80000e48:	00001097          	auipc	ra,0x1
    80000e4c:	c62080e7          	jalr	-926(ra) # 80001aaa <userinit>
    __sync_synchronize();
    80000e50:	0ff0000f          	fence
    started = 1;
    80000e54:	4785                	li	a5,1
    80000e56:	00028717          	auipc	a4,0x28
    80000e5a:	1cf72923          	sw	a5,466(a4) # 80029028 <started>
    80000e5e:	b781                	j	80000d9e <main+0x56>

0000000080000e60 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000e60:	7139                	addi	sp,sp,-64
    80000e62:	fc06                	sd	ra,56(sp)
    80000e64:	f822                	sd	s0,48(sp)
    80000e66:	f426                	sd	s1,40(sp)
    80000e68:	f04a                	sd	s2,32(sp)
    80000e6a:	ec4e                	sd	s3,24(sp)
    80000e6c:	e852                	sd	s4,16(sp)
    80000e6e:	e456                	sd	s5,8(sp)
    80000e70:	e05a                	sd	s6,0(sp)
    80000e72:	0080                	addi	s0,sp,64
    80000e74:	84aa                	mv	s1,a0
    80000e76:	89ae                	mv	s3,a1
    80000e78:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000e7a:	57fd                	li	a5,-1
    80000e7c:	83e9                	srli	a5,a5,0x1a
    80000e7e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000e80:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000e82:	04b7f263          	bgeu	a5,a1,80000ec6 <walk+0x66>
    panic("walk");
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	33250513          	addi	a0,a0,818 # 800071b8 <userret+0x128>
    80000e8e:	fffff097          	auipc	ra,0xfffff
    80000e92:	6ba080e7          	jalr	1722(ra) # 80000548 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000e96:	060a8663          	beqz	s5,80000f02 <walk+0xa2>
    80000e9a:	00000097          	auipc	ra,0x0
    80000e9e:	ace080e7          	jalr	-1330(ra) # 80000968 <kalloc>
    80000ea2:	84aa                	mv	s1,a0
    80000ea4:	c529                	beqz	a0,80000eee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ea6:	6605                	lui	a2,0x1
    80000ea8:	4581                	li	a1,0
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	cf0080e7          	jalr	-784(ra) # 80000b9a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000eb2:	00c4d793          	srli	a5,s1,0xc
    80000eb6:	07aa                	slli	a5,a5,0xa
    80000eb8:	0017e793          	ori	a5,a5,1
    80000ebc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000ec0:	3a5d                	addiw	s4,s4,-9
    80000ec2:	036a0063          	beq	s4,s6,80000ee2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000ec6:	0149d933          	srl	s2,s3,s4
    80000eca:	1ff97913          	andi	s2,s2,511
    80000ece:	090e                	slli	s2,s2,0x3
    80000ed0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000ed2:	00093483          	ld	s1,0(s2)
    80000ed6:	0014f793          	andi	a5,s1,1
    80000eda:	dfd5                	beqz	a5,80000e96 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000edc:	80a9                	srli	s1,s1,0xa
    80000ede:	04b2                	slli	s1,s1,0xc
    80000ee0:	b7c5                	j	80000ec0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000ee2:	00c9d513          	srli	a0,s3,0xc
    80000ee6:	1ff57513          	andi	a0,a0,511
    80000eea:	050e                	slli	a0,a0,0x3
    80000eec:	9526                	add	a0,a0,s1
}
    80000eee:	70e2                	ld	ra,56(sp)
    80000ef0:	7442                	ld	s0,48(sp)
    80000ef2:	74a2                	ld	s1,40(sp)
    80000ef4:	7902                	ld	s2,32(sp)
    80000ef6:	69e2                	ld	s3,24(sp)
    80000ef8:	6a42                	ld	s4,16(sp)
    80000efa:	6aa2                	ld	s5,8(sp)
    80000efc:	6b02                	ld	s6,0(sp)
    80000efe:	6121                	addi	sp,sp,64
    80000f00:	8082                	ret
        return 0;
    80000f02:	4501                	li	a0,0
    80000f04:	b7ed                	j	80000eee <walk+0x8e>

0000000080000f06 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000f06:	7179                	addi	sp,sp,-48
    80000f08:	f406                	sd	ra,40(sp)
    80000f0a:	f022                	sd	s0,32(sp)
    80000f0c:	ec26                	sd	s1,24(sp)
    80000f0e:	e84a                	sd	s2,16(sp)
    80000f10:	e44e                	sd	s3,8(sp)
    80000f12:	e052                	sd	s4,0(sp)
    80000f14:	1800                	addi	s0,sp,48
    80000f16:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000f18:	84aa                	mv	s1,a0
    80000f1a:	6905                	lui	s2,0x1
    80000f1c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f1e:	4985                	li	s3,1
    80000f20:	a821                	j	80000f38 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000f22:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000f24:	0532                	slli	a0,a0,0xc
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	fe0080e7          	jalr	-32(ra) # 80000f06 <freewalk>
      pagetable[i] = 0;
    80000f2e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000f32:	04a1                	addi	s1,s1,8
    80000f34:	03248163          	beq	s1,s2,80000f56 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000f38:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f3a:	00f57793          	andi	a5,a0,15
    80000f3e:	ff3782e3          	beq	a5,s3,80000f22 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000f42:	8905                	andi	a0,a0,1
    80000f44:	d57d                	beqz	a0,80000f32 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000f46:	00006517          	auipc	a0,0x6
    80000f4a:	27a50513          	addi	a0,a0,634 # 800071c0 <userret+0x130>
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	5fa080e7          	jalr	1530(ra) # 80000548 <panic>
    }
  }
  kfree((void*)pagetable);
    80000f56:	8552                	mv	a0,s4
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	8fc080e7          	jalr	-1796(ra) # 80000854 <kfree>
}
    80000f60:	70a2                	ld	ra,40(sp)
    80000f62:	7402                	ld	s0,32(sp)
    80000f64:	64e2                	ld	s1,24(sp)
    80000f66:	6942                	ld	s2,16(sp)
    80000f68:	69a2                	ld	s3,8(sp)
    80000f6a:	6a02                	ld	s4,0(sp)
    80000f6c:	6145                	addi	sp,sp,48
    80000f6e:	8082                	ret

0000000080000f70 <kvminithart>:
{
    80000f70:	1141                	addi	sp,sp,-16
    80000f72:	e422                	sd	s0,8(sp)
    80000f74:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f76:	00028797          	auipc	a5,0x28
    80000f7a:	0ba7b783          	ld	a5,186(a5) # 80029030 <kernel_pagetable>
    80000f7e:	83b1                	srli	a5,a5,0xc
    80000f80:	577d                	li	a4,-1
    80000f82:	177e                	slli	a4,a4,0x3f
    80000f84:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f86:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f8a:	12000073          	sfence.vma
}
    80000f8e:	6422                	ld	s0,8(sp)
    80000f90:	0141                	addi	sp,sp,16
    80000f92:	8082                	ret

0000000080000f94 <walkaddr>:
{
    80000f94:	1141                	addi	sp,sp,-16
    80000f96:	e406                	sd	ra,8(sp)
    80000f98:	e022                	sd	s0,0(sp)
    80000f9a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f9c:	4601                	li	a2,0
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	ec2080e7          	jalr	-318(ra) # 80000e60 <walk>
  if(pte == 0)
    80000fa6:	c105                	beqz	a0,80000fc6 <walkaddr+0x32>
  if((*pte & PTE_V) == 0)
    80000fa8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000faa:	0117f693          	andi	a3,a5,17
    80000fae:	4745                	li	a4,17
    return 0;
    80000fb0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fb2:	00e68663          	beq	a3,a4,80000fbe <walkaddr+0x2a>
}
    80000fb6:	60a2                	ld	ra,8(sp)
    80000fb8:	6402                	ld	s0,0(sp)
    80000fba:	0141                	addi	sp,sp,16
    80000fbc:	8082                	ret
  pa = PTE2PA(*pte);
    80000fbe:	83a9                	srli	a5,a5,0xa
    80000fc0:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fc4:	bfcd                	j	80000fb6 <walkaddr+0x22>
    return 0;
    80000fc6:	4501                	li	a0,0
    80000fc8:	b7fd                	j	80000fb6 <walkaddr+0x22>

0000000080000fca <kvmpa>:
{
    80000fca:	1101                	addi	sp,sp,-32
    80000fcc:	ec06                	sd	ra,24(sp)
    80000fce:	e822                	sd	s0,16(sp)
    80000fd0:	e426                	sd	s1,8(sp)
    80000fd2:	1000                	addi	s0,sp,32
    80000fd4:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fd6:	1552                	slli	a0,a0,0x34
    80000fd8:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fdc:	4601                	li	a2,0
    80000fde:	00028517          	auipc	a0,0x28
    80000fe2:	05253503          	ld	a0,82(a0) # 80029030 <kernel_pagetable>
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	e7a080e7          	jalr	-390(ra) # 80000e60 <walk>
  if(pte == 0)
    80000fee:	cd09                	beqz	a0,80001008 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000ff0:	6108                	ld	a0,0(a0)
    80000ff2:	00157793          	andi	a5,a0,1
    80000ff6:	c38d                	beqz	a5,80001018 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000ff8:	8129                	srli	a0,a0,0xa
    80000ffa:	0532                	slli	a0,a0,0xc
}
    80000ffc:	9526                	add	a0,a0,s1
    80000ffe:	60e2                	ld	ra,24(sp)
    80001000:	6442                	ld	s0,16(sp)
    80001002:	64a2                	ld	s1,8(sp)
    80001004:	6105                	addi	sp,sp,32
    80001006:	8082                	ret
    panic("kvmpa");
    80001008:	00006517          	auipc	a0,0x6
    8000100c:	1c850513          	addi	a0,a0,456 # 800071d0 <userret+0x140>
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	538080e7          	jalr	1336(ra) # 80000548 <panic>
    panic("kvmpa");
    80001018:	00006517          	auipc	a0,0x6
    8000101c:	1b850513          	addi	a0,a0,440 # 800071d0 <userret+0x140>
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	528080e7          	jalr	1320(ra) # 80000548 <panic>

0000000080001028 <mappages>:
{
    80001028:	715d                	addi	sp,sp,-80
    8000102a:	e486                	sd	ra,72(sp)
    8000102c:	e0a2                	sd	s0,64(sp)
    8000102e:	fc26                	sd	s1,56(sp)
    80001030:	f84a                	sd	s2,48(sp)
    80001032:	f44e                	sd	s3,40(sp)
    80001034:	f052                	sd	s4,32(sp)
    80001036:	ec56                	sd	s5,24(sp)
    80001038:	e85a                	sd	s6,16(sp)
    8000103a:	e45e                	sd	s7,8(sp)
    8000103c:	0880                	addi	s0,sp,80
    8000103e:	8aaa                	mv	s5,a0
    80001040:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001042:	777d                	lui	a4,0xfffff
    80001044:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001048:	167d                	addi	a2,a2,-1
    8000104a:	00b609b3          	add	s3,a2,a1
    8000104e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001052:	893e                	mv	s2,a5
    80001054:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001058:	6b85                	lui	s7,0x1
    8000105a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000105e:	4605                	li	a2,1
    80001060:	85ca                	mv	a1,s2
    80001062:	8556                	mv	a0,s5
    80001064:	00000097          	auipc	ra,0x0
    80001068:	dfc080e7          	jalr	-516(ra) # 80000e60 <walk>
    8000106c:	c51d                	beqz	a0,8000109a <mappages+0x72>
    if(*pte & PTE_V)
    8000106e:	611c                	ld	a5,0(a0)
    80001070:	8b85                	andi	a5,a5,1
    80001072:	ef81                	bnez	a5,8000108a <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001074:	80b1                	srli	s1,s1,0xc
    80001076:	04aa                	slli	s1,s1,0xa
    80001078:	0164e4b3          	or	s1,s1,s6
    8000107c:	0014e493          	ori	s1,s1,1
    80001080:	e104                	sd	s1,0(a0)
    if(a == last)
    80001082:	03390863          	beq	s2,s3,800010b2 <mappages+0x8a>
    a += PGSIZE;
    80001086:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001088:	bfc9                	j	8000105a <mappages+0x32>
      panic("remap");
    8000108a:	00006517          	auipc	a0,0x6
    8000108e:	14e50513          	addi	a0,a0,334 # 800071d8 <userret+0x148>
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	4b6080e7          	jalr	1206(ra) # 80000548 <panic>
      return -1;
    8000109a:	557d                	li	a0,-1
}
    8000109c:	60a6                	ld	ra,72(sp)
    8000109e:	6406                	ld	s0,64(sp)
    800010a0:	74e2                	ld	s1,56(sp)
    800010a2:	7942                	ld	s2,48(sp)
    800010a4:	79a2                	ld	s3,40(sp)
    800010a6:	7a02                	ld	s4,32(sp)
    800010a8:	6ae2                	ld	s5,24(sp)
    800010aa:	6b42                	ld	s6,16(sp)
    800010ac:	6ba2                	ld	s7,8(sp)
    800010ae:	6161                	addi	sp,sp,80
    800010b0:	8082                	ret
  return 0;
    800010b2:	4501                	li	a0,0
    800010b4:	b7e5                	j	8000109c <mappages+0x74>

00000000800010b6 <kvmmap>:
{
    800010b6:	1141                	addi	sp,sp,-16
    800010b8:	e406                	sd	ra,8(sp)
    800010ba:	e022                	sd	s0,0(sp)
    800010bc:	0800                	addi	s0,sp,16
    800010be:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010c0:	86ae                	mv	a3,a1
    800010c2:	85aa                	mv	a1,a0
    800010c4:	00028517          	auipc	a0,0x28
    800010c8:	f6c53503          	ld	a0,-148(a0) # 80029030 <kernel_pagetable>
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	f5c080e7          	jalr	-164(ra) # 80001028 <mappages>
    800010d4:	e509                	bnez	a0,800010de <kvmmap+0x28>
}
    800010d6:	60a2                	ld	ra,8(sp)
    800010d8:	6402                	ld	s0,0(sp)
    800010da:	0141                	addi	sp,sp,16
    800010dc:	8082                	ret
    panic("kvmmap");
    800010de:	00006517          	auipc	a0,0x6
    800010e2:	10250513          	addi	a0,a0,258 # 800071e0 <userret+0x150>
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	462080e7          	jalr	1122(ra) # 80000548 <panic>

00000000800010ee <kvminit>:
{
    800010ee:	1101                	addi	sp,sp,-32
    800010f0:	ec06                	sd	ra,24(sp)
    800010f2:	e822                	sd	s0,16(sp)
    800010f4:	e426                	sd	s1,8(sp)
    800010f6:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	870080e7          	jalr	-1936(ra) # 80000968 <kalloc>
    80001100:	00028797          	auipc	a5,0x28
    80001104:	f2a7b823          	sd	a0,-208(a5) # 80029030 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001108:	6605                	lui	a2,0x1
    8000110a:	4581                	li	a1,0
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	a8e080e7          	jalr	-1394(ra) # 80000b9a <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001114:	4699                	li	a3,6
    80001116:	6605                	lui	a2,0x1
    80001118:	100005b7          	lui	a1,0x10000
    8000111c:	10000537          	lui	a0,0x10000
    80001120:	00000097          	auipc	ra,0x0
    80001124:	f96080e7          	jalr	-106(ra) # 800010b6 <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    80001128:	4699                	li	a3,6
    8000112a:	6605                	lui	a2,0x1
    8000112c:	100015b7          	lui	a1,0x10001
    80001130:	10001537          	lui	a0,0x10001
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f82080e7          	jalr	-126(ra) # 800010b6 <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    8000113c:	4699                	li	a3,6
    8000113e:	6605                	lui	a2,0x1
    80001140:	100025b7          	lui	a1,0x10002
    80001144:	10002537          	lui	a0,0x10002
    80001148:	00000097          	auipc	ra,0x0
    8000114c:	f6e080e7          	jalr	-146(ra) # 800010b6 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001150:	4699                	li	a3,6
    80001152:	6641                	lui	a2,0x10
    80001154:	020005b7          	lui	a1,0x2000
    80001158:	02000537          	lui	a0,0x2000
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	f5a080e7          	jalr	-166(ra) # 800010b6 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001164:	4699                	li	a3,6
    80001166:	00400637          	lui	a2,0x400
    8000116a:	0c0005b7          	lui	a1,0xc000
    8000116e:	0c000537          	lui	a0,0xc000
    80001172:	00000097          	auipc	ra,0x0
    80001176:	f44080e7          	jalr	-188(ra) # 800010b6 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000117a:	00007497          	auipc	s1,0x7
    8000117e:	e8648493          	addi	s1,s1,-378 # 80008000 <initcode>
    80001182:	46a9                	li	a3,10
    80001184:	80007617          	auipc	a2,0x80007
    80001188:	e7c60613          	addi	a2,a2,-388 # 8000 <_entry-0x7fff8000>
    8000118c:	4585                	li	a1,1
    8000118e:	05fe                	slli	a1,a1,0x1f
    80001190:	852e                	mv	a0,a1
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f24080e7          	jalr	-220(ra) # 800010b6 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119a:	4699                	li	a3,6
    8000119c:	4645                	li	a2,17
    8000119e:	066e                	slli	a2,a2,0x1b
    800011a0:	8e05                	sub	a2,a2,s1
    800011a2:	85a6                	mv	a1,s1
    800011a4:	8526                	mv	a0,s1
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	f10080e7          	jalr	-240(ra) # 800010b6 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ae:	46a9                	li	a3,10
    800011b0:	6605                	lui	a2,0x1
    800011b2:	00006597          	auipc	a1,0x6
    800011b6:	e4e58593          	addi	a1,a1,-434 # 80007000 <trampoline>
    800011ba:	04000537          	lui	a0,0x4000
    800011be:	157d                	addi	a0,a0,-1
    800011c0:	0532                	slli	a0,a0,0xc
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	ef4080e7          	jalr	-268(ra) # 800010b6 <kvmmap>
}
    800011ca:	60e2                	ld	ra,24(sp)
    800011cc:	6442                	ld	s0,16(sp)
    800011ce:	64a2                	ld	s1,8(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <uvmunmap>:
{
    800011d4:	715d                	addi	sp,sp,-80
    800011d6:	e486                	sd	ra,72(sp)
    800011d8:	e0a2                	sd	s0,64(sp)
    800011da:	fc26                	sd	s1,56(sp)
    800011dc:	f84a                	sd	s2,48(sp)
    800011de:	f44e                	sd	s3,40(sp)
    800011e0:	f052                	sd	s4,32(sp)
    800011e2:	ec56                	sd	s5,24(sp)
    800011e4:	e85a                	sd	s6,16(sp)
    800011e6:	e45e                	sd	s7,8(sp)
    800011e8:	0880                	addi	s0,sp,80
    800011ea:	8a2a                	mv	s4,a0
    800011ec:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011ee:	77fd                	lui	a5,0xfffff
    800011f0:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011f4:	167d                	addi	a2,a2,-1
    800011f6:	00b609b3          	add	s3,a2,a1
    800011fa:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011fe:	4b05                	li	s6,1
    a += PGSIZE;
    80001200:	6b85                	lui	s7,0x1
    80001202:	a0b9                	j	80001250 <uvmunmap+0x7c>
      panic("uvmunmap: walk");
    80001204:	00006517          	auipc	a0,0x6
    80001208:	fe450513          	addi	a0,a0,-28 # 800071e8 <userret+0x158>
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	33c080e7          	jalr	828(ra) # 80000548 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    80001214:	85ca                	mv	a1,s2
    80001216:	00006517          	auipc	a0,0x6
    8000121a:	fe250513          	addi	a0,a0,-30 # 800071f8 <userret+0x168>
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	374080e7          	jalr	884(ra) # 80000592 <printf>
      panic("uvmunmap: not mapped");
    80001226:	00006517          	auipc	a0,0x6
    8000122a:	fe250513          	addi	a0,a0,-30 # 80007208 <userret+0x178>
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	31a080e7          	jalr	794(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    80001236:	00006517          	auipc	a0,0x6
    8000123a:	fea50513          	addi	a0,a0,-22 # 80007220 <userret+0x190>
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	30a080e7          	jalr	778(ra) # 80000548 <panic>
    *pte = 0;
    80001246:	0004b023          	sd	zero,0(s1)
    if(a == last)
    8000124a:	03390e63          	beq	s2,s3,80001286 <uvmunmap+0xb2>
    a += PGSIZE;
    8000124e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    80001250:	4601                	li	a2,0
    80001252:	85ca                	mv	a1,s2
    80001254:	8552                	mv	a0,s4
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	c0a080e7          	jalr	-1014(ra) # 80000e60 <walk>
    8000125e:	84aa                	mv	s1,a0
    80001260:	d155                	beqz	a0,80001204 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    80001262:	6110                	ld	a2,0(a0)
    80001264:	00167793          	andi	a5,a2,1
    80001268:	d7d5                	beqz	a5,80001214 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	01f67793          	andi	a5,a2,31
    8000126e:	fd6784e3          	beq	a5,s6,80001236 <uvmunmap+0x62>
    if(do_free){
    80001272:	fc0a8ae3          	beqz	s5,80001246 <uvmunmap+0x72>
      pa = PTE2PA(*pte);
    80001276:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80001278:	00c61513          	slli	a0,a2,0xc
    8000127c:	fffff097          	auipc	ra,0xfffff
    80001280:	5d8080e7          	jalr	1496(ra) # 80000854 <kfree>
    80001284:	b7c9                	j	80001246 <uvmunmap+0x72>
}
    80001286:	60a6                	ld	ra,72(sp)
    80001288:	6406                	ld	s0,64(sp)
    8000128a:	74e2                	ld	s1,56(sp)
    8000128c:	7942                	ld	s2,48(sp)
    8000128e:	79a2                	ld	s3,40(sp)
    80001290:	7a02                	ld	s4,32(sp)
    80001292:	6ae2                	ld	s5,24(sp)
    80001294:	6b42                	ld	s6,16(sp)
    80001296:	6ba2                	ld	s7,8(sp)
    80001298:	6161                	addi	sp,sp,80
    8000129a:	8082                	ret

000000008000129c <uvmcreate>:
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    800012a6:	fffff097          	auipc	ra,0xfffff
    800012aa:	6c2080e7          	jalr	1730(ra) # 80000968 <kalloc>
  if(pagetable == 0)
    800012ae:	cd11                	beqz	a0,800012ca <uvmcreate+0x2e>
    800012b0:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    800012b2:	6605                	lui	a2,0x1
    800012b4:	4581                	li	a1,0
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	8e4080e7          	jalr	-1820(ra) # 80000b9a <memset>
}
    800012be:	8526                	mv	a0,s1
    800012c0:	60e2                	ld	ra,24(sp)
    800012c2:	6442                	ld	s0,16(sp)
    800012c4:	64a2                	ld	s1,8(sp)
    800012c6:	6105                	addi	sp,sp,32
    800012c8:	8082                	ret
    panic("uvmcreate: out of memory");
    800012ca:	00006517          	auipc	a0,0x6
    800012ce:	f6e50513          	addi	a0,a0,-146 # 80007238 <userret+0x1a8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	276080e7          	jalr	630(ra) # 80000548 <panic>

00000000800012da <uvminit>:
{
    800012da:	7179                	addi	sp,sp,-48
    800012dc:	f406                	sd	ra,40(sp)
    800012de:	f022                	sd	s0,32(sp)
    800012e0:	ec26                	sd	s1,24(sp)
    800012e2:	e84a                	sd	s2,16(sp)
    800012e4:	e44e                	sd	s3,8(sp)
    800012e6:	e052                	sd	s4,0(sp)
    800012e8:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012ea:	6785                	lui	a5,0x1
    800012ec:	04f67863          	bgeu	a2,a5,8000133c <uvminit+0x62>
    800012f0:	8a2a                	mv	s4,a0
    800012f2:	89ae                	mv	s3,a1
    800012f4:	84b2                	mv	s1,a2
  mem = kalloc();
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	672080e7          	jalr	1650(ra) # 80000968 <kalloc>
    800012fe:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001300:	6605                	lui	a2,0x1
    80001302:	4581                	li	a1,0
    80001304:	00000097          	auipc	ra,0x0
    80001308:	896080e7          	jalr	-1898(ra) # 80000b9a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000130c:	4779                	li	a4,30
    8000130e:	86ca                	mv	a3,s2
    80001310:	6605                	lui	a2,0x1
    80001312:	4581                	li	a1,0
    80001314:	8552                	mv	a0,s4
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	d12080e7          	jalr	-750(ra) # 80001028 <mappages>
  memmove(mem, src, sz);
    8000131e:	8626                	mv	a2,s1
    80001320:	85ce                	mv	a1,s3
    80001322:	854a                	mv	a0,s2
    80001324:	00000097          	auipc	ra,0x0
    80001328:	8d2080e7          	jalr	-1838(ra) # 80000bf6 <memmove>
}
    8000132c:	70a2                	ld	ra,40(sp)
    8000132e:	7402                	ld	s0,32(sp)
    80001330:	64e2                	ld	s1,24(sp)
    80001332:	6942                	ld	s2,16(sp)
    80001334:	69a2                	ld	s3,8(sp)
    80001336:	6a02                	ld	s4,0(sp)
    80001338:	6145                	addi	sp,sp,48
    8000133a:	8082                	ret
    panic("inituvm: more than a page");
    8000133c:	00006517          	auipc	a0,0x6
    80001340:	f1c50513          	addi	a0,a0,-228 # 80007258 <userret+0x1c8>
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	204080e7          	jalr	516(ra) # 80000548 <panic>

000000008000134c <uvmdealloc>:
{
    8000134c:	87aa                	mv	a5,a0
    8000134e:	852e                	mv	a0,a1
  if(newsz >= oldsz)
    80001350:	00b66363          	bltu	a2,a1,80001356 <uvmdealloc+0xa>
}
    80001354:	8082                	ret
{
    80001356:	1101                	addi	sp,sp,-32
    80001358:	ec06                	sd	ra,24(sp)
    8000135a:	e822                	sd	s0,16(sp)
    8000135c:	e426                	sd	s1,8(sp)
    8000135e:	1000                	addi	s0,sp,32
    80001360:	84b2                	mv	s1,a2
  uvmunmap(pagetable, newsz, oldsz - newsz, 1);
    80001362:	4685                	li	a3,1
    80001364:	40c58633          	sub	a2,a1,a2
    80001368:	85a6                	mv	a1,s1
    8000136a:	853e                	mv	a0,a5
    8000136c:	00000097          	auipc	ra,0x0
    80001370:	e68080e7          	jalr	-408(ra) # 800011d4 <uvmunmap>
  return newsz;
    80001374:	8526                	mv	a0,s1
}
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	64a2                	ld	s1,8(sp)
    8000137c:	6105                	addi	sp,sp,32
    8000137e:	8082                	ret

0000000080001380 <uvmalloc>:
  if(newsz < oldsz)
    80001380:	0ab66163          	bltu	a2,a1,80001422 <uvmalloc+0xa2>
{
    80001384:	7139                	addi	sp,sp,-64
    80001386:	fc06                	sd	ra,56(sp)
    80001388:	f822                	sd	s0,48(sp)
    8000138a:	f426                	sd	s1,40(sp)
    8000138c:	f04a                	sd	s2,32(sp)
    8000138e:	ec4e                	sd	s3,24(sp)
    80001390:	e852                	sd	s4,16(sp)
    80001392:	e456                	sd	s5,8(sp)
    80001394:	0080                	addi	s0,sp,64
    80001396:	8aaa                	mv	s5,a0
    80001398:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000139a:	6985                	lui	s3,0x1
    8000139c:	19fd                	addi	s3,s3,-1
    8000139e:	95ce                	add	a1,a1,s3
    800013a0:	79fd                	lui	s3,0xfffff
    800013a2:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    800013a6:	08c9f063          	bgeu	s3,a2,80001426 <uvmalloc+0xa6>
  a = oldsz;
    800013aa:	894e                	mv	s2,s3
    mem = kalloc();
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	5bc080e7          	jalr	1468(ra) # 80000968 <kalloc>
    800013b4:	84aa                	mv	s1,a0
    if(mem == 0){
    800013b6:	c51d                	beqz	a0,800013e4 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013b8:	6605                	lui	a2,0x1
    800013ba:	4581                	li	a1,0
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	7de080e7          	jalr	2014(ra) # 80000b9a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800013c4:	4779                	li	a4,30
    800013c6:	86a6                	mv	a3,s1
    800013c8:	6605                	lui	a2,0x1
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	c5a080e7          	jalr	-934(ra) # 80001028 <mappages>
    800013d6:	e905                	bnez	a0,80001406 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013d8:	6785                	lui	a5,0x1
    800013da:	993e                	add	s2,s2,a5
    800013dc:	fd4968e3          	bltu	s2,s4,800013ac <uvmalloc+0x2c>
  return newsz;
    800013e0:	8552                	mv	a0,s4
    800013e2:	a809                	j	800013f4 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013e4:	864e                	mv	a2,s3
    800013e6:	85ca                	mv	a1,s2
    800013e8:	8556                	mv	a0,s5
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	f62080e7          	jalr	-158(ra) # 8000134c <uvmdealloc>
      return 0;
    800013f2:	4501                	li	a0,0
}
    800013f4:	70e2                	ld	ra,56(sp)
    800013f6:	7442                	ld	s0,48(sp)
    800013f8:	74a2                	ld	s1,40(sp)
    800013fa:	7902                	ld	s2,32(sp)
    800013fc:	69e2                	ld	s3,24(sp)
    800013fe:	6a42                	ld	s4,16(sp)
    80001400:	6aa2                	ld	s5,8(sp)
    80001402:	6121                	addi	sp,sp,64
    80001404:	8082                	ret
      kfree(mem);
    80001406:	8526                	mv	a0,s1
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	44c080e7          	jalr	1100(ra) # 80000854 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001410:	864e                	mv	a2,s3
    80001412:	85ca                	mv	a1,s2
    80001414:	8556                	mv	a0,s5
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	f36080e7          	jalr	-202(ra) # 8000134c <uvmdealloc>
      return 0;
    8000141e:	4501                	li	a0,0
    80001420:	bfd1                	j	800013f4 <uvmalloc+0x74>
    return oldsz;
    80001422:	852e                	mv	a0,a1
}
    80001424:	8082                	ret
  return newsz;
    80001426:	8532                	mv	a0,a2
    80001428:	b7f1                	j	800013f4 <uvmalloc+0x74>

000000008000142a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000142a:	1101                	addi	sp,sp,-32
    8000142c:	ec06                	sd	ra,24(sp)
    8000142e:	e822                	sd	s0,16(sp)
    80001430:	e426                	sd	s1,8(sp)
    80001432:	1000                	addi	s0,sp,32
    80001434:	84aa                	mv	s1,a0
    80001436:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001438:	4685                	li	a3,1
    8000143a:	4581                	li	a1,0
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	d98080e7          	jalr	-616(ra) # 800011d4 <uvmunmap>
  freewalk(pagetable);
    80001444:	8526                	mv	a0,s1
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	ac0080e7          	jalr	-1344(ra) # 80000f06 <freewalk>
}
    8000144e:	60e2                	ld	ra,24(sp)
    80001450:	6442                	ld	s0,16(sp)
    80001452:	64a2                	ld	s1,8(sp)
    80001454:	6105                	addi	sp,sp,32
    80001456:	8082                	ret

0000000080001458 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001458:	c671                	beqz	a2,80001524 <uvmcopy+0xcc>
{
    8000145a:	715d                	addi	sp,sp,-80
    8000145c:	e486                	sd	ra,72(sp)
    8000145e:	e0a2                	sd	s0,64(sp)
    80001460:	fc26                	sd	s1,56(sp)
    80001462:	f84a                	sd	s2,48(sp)
    80001464:	f44e                	sd	s3,40(sp)
    80001466:	f052                	sd	s4,32(sp)
    80001468:	ec56                	sd	s5,24(sp)
    8000146a:	e85a                	sd	s6,16(sp)
    8000146c:	e45e                	sd	s7,8(sp)
    8000146e:	0880                	addi	s0,sp,80
    80001470:	8b2a                	mv	s6,a0
    80001472:	8aae                	mv	s5,a1
    80001474:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001476:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001478:	4601                	li	a2,0
    8000147a:	85ce                	mv	a1,s3
    8000147c:	855a                	mv	a0,s6
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	9e2080e7          	jalr	-1566(ra) # 80000e60 <walk>
    80001486:	c531                	beqz	a0,800014d2 <uvmcopy+0x7a>
      panic("copyuvm: pte should exist");
    if((*pte & PTE_V) == 0)
    80001488:	6118                	ld	a4,0(a0)
    8000148a:	00177793          	andi	a5,a4,1
    8000148e:	cbb1                	beqz	a5,800014e2 <uvmcopy+0x8a>
      panic("copyuvm: page not present");
    pa = PTE2PA(*pte);
    80001490:	00a75593          	srli	a1,a4,0xa
    80001494:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001498:	01f77493          	andi	s1,a4,31
    if((mem = kalloc()) == 0)
    8000149c:	fffff097          	auipc	ra,0xfffff
    800014a0:	4cc080e7          	jalr	1228(ra) # 80000968 <kalloc>
    800014a4:	892a                	mv	s2,a0
    800014a6:	c939                	beqz	a0,800014fc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014a8:	6605                	lui	a2,0x1
    800014aa:	85de                	mv	a1,s7
    800014ac:	fffff097          	auipc	ra,0xfffff
    800014b0:	74a080e7          	jalr	1866(ra) # 80000bf6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014b4:	8726                	mv	a4,s1
    800014b6:	86ca                	mv	a3,s2
    800014b8:	6605                	lui	a2,0x1
    800014ba:	85ce                	mv	a1,s3
    800014bc:	8556                	mv	a0,s5
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	b6a080e7          	jalr	-1174(ra) # 80001028 <mappages>
    800014c6:	e515                	bnez	a0,800014f2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014c8:	6785                	lui	a5,0x1
    800014ca:	99be                	add	s3,s3,a5
    800014cc:	fb49e6e3          	bltu	s3,s4,80001478 <uvmcopy+0x20>
    800014d0:	a83d                	j	8000150e <uvmcopy+0xb6>
      panic("copyuvm: pte should exist");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	da650513          	addi	a0,a0,-602 # 80007278 <userret+0x1e8>
    800014da:	fffff097          	auipc	ra,0xfffff
    800014de:	06e080e7          	jalr	110(ra) # 80000548 <panic>
      panic("copyuvm: page not present");
    800014e2:	00006517          	auipc	a0,0x6
    800014e6:	db650513          	addi	a0,a0,-586 # 80007298 <userret+0x208>
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	05e080e7          	jalr	94(ra) # 80000548 <panic>
      kfree(mem);
    800014f2:	854a                	mv	a0,s2
    800014f4:	fffff097          	auipc	ra,0xfffff
    800014f8:	360080e7          	jalr	864(ra) # 80000854 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800014fc:	4685                	li	a3,1
    800014fe:	864e                	mv	a2,s3
    80001500:	4581                	li	a1,0
    80001502:	8556                	mv	a0,s5
    80001504:	00000097          	auipc	ra,0x0
    80001508:	cd0080e7          	jalr	-816(ra) # 800011d4 <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	00000097          	auipc	ra,0x0
    80001536:	92e080e7          	jalr	-1746(ra) # 80000e60 <walk>
  if(pte == 0)
    8000153a:	c901                	beqz	a0,8000154a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000153c:	611c                	ld	a5,0(a0)
    8000153e:	9bbd                	andi	a5,a5,-17
    80001540:	e11c                	sd	a5,0(a0)
}
    80001542:	60a2                	ld	ra,8(sp)
    80001544:	6402                	ld	s0,0(sp)
    80001546:	0141                	addi	sp,sp,16
    80001548:	8082                	ret
    panic("uvmclear");
    8000154a:	00006517          	auipc	a0,0x6
    8000154e:	d6e50513          	addi	a0,a0,-658 # 800072b8 <userret+0x228>
    80001552:	fffff097          	auipc	ra,0xfffff
    80001556:	ff6080e7          	jalr	-10(ra) # 80000548 <panic>

000000008000155a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000155a:	cab5                	beqz	a3,800015ce <copyout+0x74>
{
    8000155c:	715d                	addi	sp,sp,-80
    8000155e:	e486                	sd	ra,72(sp)
    80001560:	e0a2                	sd	s0,64(sp)
    80001562:	fc26                	sd	s1,56(sp)
    80001564:	f84a                	sd	s2,48(sp)
    80001566:	f44e                	sd	s3,40(sp)
    80001568:	f052                	sd	s4,32(sp)
    8000156a:	ec56                	sd	s5,24(sp)
    8000156c:	e85a                	sd	s6,16(sp)
    8000156e:	e45e                	sd	s7,8(sp)
    80001570:	e062                	sd	s8,0(sp)
    80001572:	0880                	addi	s0,sp,80
    80001574:	8baa                	mv	s7,a0
    80001576:	8c2e                	mv	s8,a1
    80001578:	8a32                	mv	s4,a2
    8000157a:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(dstva);
    8000157c:	00100b37          	lui	s6,0x100
    80001580:	1b7d                	addi	s6,s6,-1
    80001582:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001584:	6a85                	lui	s5,0x1
    80001586:	a015                	j	800015aa <copyout+0x50>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001588:	9562                	add	a0,a0,s8
    8000158a:	0004861b          	sext.w	a2,s1
    8000158e:	85d2                	mv	a1,s4
    80001590:	41250533          	sub	a0,a0,s2
    80001594:	fffff097          	auipc	ra,0xfffff
    80001598:	662080e7          	jalr	1634(ra) # 80000bf6 <memmove>

    len -= n;
    8000159c:	409989b3          	sub	s3,s3,s1
    src += n;
    800015a0:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800015a2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015a6:	02098263          	beqz	s3,800015ca <copyout+0x70>
    va0 = (uint)PGROUNDDOWN(dstva);
    800015aa:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    800015ae:	85ca                	mv	a1,s2
    800015b0:	855e                	mv	a0,s7
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	9e2080e7          	jalr	-1566(ra) # 80000f94 <walkaddr>
    if(pa0 == 0)
    800015ba:	cd01                	beqz	a0,800015d2 <copyout+0x78>
    n = PGSIZE - (dstva - va0);
    800015bc:	418904b3          	sub	s1,s2,s8
    800015c0:	94d6                	add	s1,s1,s5
    if(n > len)
    800015c2:	fc99f3e3          	bgeu	s3,s1,80001588 <copyout+0x2e>
    800015c6:	84ce                	mv	s1,s3
    800015c8:	b7c1                	j	80001588 <copyout+0x2e>
  }
  return 0;
    800015ca:	4501                	li	a0,0
    800015cc:	a021                	j	800015d4 <copyout+0x7a>
    800015ce:	4501                	li	a0,0
}
    800015d0:	8082                	ret
      return -1;
    800015d2:	557d                	li	a0,-1
}
    800015d4:	60a6                	ld	ra,72(sp)
    800015d6:	6406                	ld	s0,64(sp)
    800015d8:	74e2                	ld	s1,56(sp)
    800015da:	7942                	ld	s2,48(sp)
    800015dc:	79a2                	ld	s3,40(sp)
    800015de:	7a02                	ld	s4,32(sp)
    800015e0:	6ae2                	ld	s5,24(sp)
    800015e2:	6b42                	ld	s6,16(sp)
    800015e4:	6ba2                	ld	s7,8(sp)
    800015e6:	6c02                	ld	s8,0(sp)
    800015e8:	6161                	addi	sp,sp,80
    800015ea:	8082                	ret

00000000800015ec <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015ec:	cabd                	beqz	a3,80001662 <copyin+0x76>
{
    800015ee:	715d                	addi	sp,sp,-80
    800015f0:	e486                	sd	ra,72(sp)
    800015f2:	e0a2                	sd	s0,64(sp)
    800015f4:	fc26                	sd	s1,56(sp)
    800015f6:	f84a                	sd	s2,48(sp)
    800015f8:	f44e                	sd	s3,40(sp)
    800015fa:	f052                	sd	s4,32(sp)
    800015fc:	ec56                	sd	s5,24(sp)
    800015fe:	e85a                	sd	s6,16(sp)
    80001600:	e45e                	sd	s7,8(sp)
    80001602:	e062                	sd	s8,0(sp)
    80001604:	0880                	addi	s0,sp,80
    80001606:	8baa                	mv	s7,a0
    80001608:	8a2e                	mv	s4,a1
    8000160a:	8c32                	mv	s8,a2
    8000160c:	89b6                	mv	s3,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    8000160e:	00100b37          	lui	s6,0x100
    80001612:	1b7d                	addi	s6,s6,-1
    80001614:	0b32                	slli	s6,s6,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001616:	6a85                	lui	s5,0x1
    80001618:	a01d                	j	8000163e <copyin+0x52>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000161a:	018505b3          	add	a1,a0,s8
    8000161e:	0004861b          	sext.w	a2,s1
    80001622:	412585b3          	sub	a1,a1,s2
    80001626:	8552                	mv	a0,s4
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	5ce080e7          	jalr	1486(ra) # 80000bf6 <memmove>

    len -= n;
    80001630:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001634:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001636:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000163a:	02098263          	beqz	s3,8000165e <copyin+0x72>
    va0 = (uint)PGROUNDDOWN(srcva);
    8000163e:	016c7933          	and	s2,s8,s6
    pa0 = walkaddr(pagetable, va0);
    80001642:	85ca                	mv	a1,s2
    80001644:	855e                	mv	a0,s7
    80001646:	00000097          	auipc	ra,0x0
    8000164a:	94e080e7          	jalr	-1714(ra) # 80000f94 <walkaddr>
    if(pa0 == 0)
    8000164e:	cd01                	beqz	a0,80001666 <copyin+0x7a>
    n = PGSIZE - (srcva - va0);
    80001650:	418904b3          	sub	s1,s2,s8
    80001654:	94d6                	add	s1,s1,s5
    if(n > len)
    80001656:	fc99f2e3          	bgeu	s3,s1,8000161a <copyin+0x2e>
    8000165a:	84ce                	mv	s1,s3
    8000165c:	bf7d                	j	8000161a <copyin+0x2e>
  }
  return 0;
    8000165e:	4501                	li	a0,0
    80001660:	a021                	j	80001668 <copyin+0x7c>
    80001662:	4501                	li	a0,0
}
    80001664:	8082                	ret
      return -1;
    80001666:	557d                	li	a0,-1
}
    80001668:	60a6                	ld	ra,72(sp)
    8000166a:	6406                	ld	s0,64(sp)
    8000166c:	74e2                	ld	s1,56(sp)
    8000166e:	7942                	ld	s2,48(sp)
    80001670:	79a2                	ld	s3,40(sp)
    80001672:	7a02                	ld	s4,32(sp)
    80001674:	6ae2                	ld	s5,24(sp)
    80001676:	6b42                	ld	s6,16(sp)
    80001678:	6ba2                	ld	s7,8(sp)
    8000167a:	6c02                	ld	s8,0(sp)
    8000167c:	6161                	addi	sp,sp,80
    8000167e:	8082                	ret

0000000080001680 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001680:	c6dd                	beqz	a3,8000172e <copyinstr+0xae>
{
    80001682:	715d                	addi	sp,sp,-80
    80001684:	e486                	sd	ra,72(sp)
    80001686:	e0a2                	sd	s0,64(sp)
    80001688:	fc26                	sd	s1,56(sp)
    8000168a:	f84a                	sd	s2,48(sp)
    8000168c:	f44e                	sd	s3,40(sp)
    8000168e:	f052                	sd	s4,32(sp)
    80001690:	ec56                	sd	s5,24(sp)
    80001692:	e85a                	sd	s6,16(sp)
    80001694:	e45e                	sd	s7,8(sp)
    80001696:	0880                	addi	s0,sp,80
    80001698:	8aaa                	mv	s5,a0
    8000169a:	8b2e                	mv	s6,a1
    8000169c:	8bb2                	mv	s7,a2
    8000169e:	84b6                	mv	s1,a3
    va0 = (uint)PGROUNDDOWN(srcva);
    800016a0:	00100a37          	lui	s4,0x100
    800016a4:	1a7d                	addi	s4,s4,-1
    800016a6:	0a32                	slli	s4,s4,0xc
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016a8:	6985                	lui	s3,0x1
    800016aa:	a035                	j	800016d6 <copyinstr+0x56>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016ac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016b0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016b2:	0017b793          	seqz	a5,a5
    800016b6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016ba:	60a6                	ld	ra,72(sp)
    800016bc:	6406                	ld	s0,64(sp)
    800016be:	74e2                	ld	s1,56(sp)
    800016c0:	7942                	ld	s2,48(sp)
    800016c2:	79a2                	ld	s3,40(sp)
    800016c4:	7a02                	ld	s4,32(sp)
    800016c6:	6ae2                	ld	s5,24(sp)
    800016c8:	6b42                	ld	s6,16(sp)
    800016ca:	6ba2                	ld	s7,8(sp)
    800016cc:	6161                	addi	sp,sp,80
    800016ce:	8082                	ret
    srcva = va0 + PGSIZE;
    800016d0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800016d4:	c8a9                	beqz	s1,80001726 <copyinstr+0xa6>
    va0 = (uint)PGROUNDDOWN(srcva);
    800016d6:	014bf933          	and	s2,s7,s4
    pa0 = walkaddr(pagetable, va0);
    800016da:	85ca                	mv	a1,s2
    800016dc:	8556                	mv	a0,s5
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	8b6080e7          	jalr	-1866(ra) # 80000f94 <walkaddr>
    if(pa0 == 0)
    800016e6:	c131                	beqz	a0,8000172a <copyinstr+0xaa>
    n = PGSIZE - (srcva - va0);
    800016e8:	41790833          	sub	a6,s2,s7
    800016ec:	984e                	add	a6,a6,s3
    if(n > max)
    800016ee:	0104f363          	bgeu	s1,a6,800016f4 <copyinstr+0x74>
    800016f2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016f4:	955e                	add	a0,a0,s7
    800016f6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016fa:	fc080be3          	beqz	a6,800016d0 <copyinstr+0x50>
    800016fe:	985a                	add	a6,a6,s6
    80001700:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001702:	41650633          	sub	a2,a0,s6
    80001706:	14fd                	addi	s1,s1,-1
    80001708:	9b26                	add	s6,s6,s1
    8000170a:	00f60733          	add	a4,a2,a5
    8000170e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5fbc>
    80001712:	df49                	beqz	a4,800016ac <copyinstr+0x2c>
        *dst = *p;
    80001714:	00e78023          	sb	a4,0(a5)
      --max;
    80001718:	40fb04b3          	sub	s1,s6,a5
      dst++;
    8000171c:	0785                	addi	a5,a5,1
    while(n > 0){
    8000171e:	ff0796e3          	bne	a5,a6,8000170a <copyinstr+0x8a>
      dst++;
    80001722:	8b42                	mv	s6,a6
    80001724:	b775                	j	800016d0 <copyinstr+0x50>
    80001726:	4781                	li	a5,0
    80001728:	b769                	j	800016b2 <copyinstr+0x32>
      return -1;
    8000172a:	557d                	li	a0,-1
    8000172c:	b779                	j	800016ba <copyinstr+0x3a>
  int got_null = 0;
    8000172e:	4781                	li	a5,0
  if(got_null){
    80001730:	0017b793          	seqz	a5,a5
    80001734:	40f00533          	neg	a0,a5
}
    80001738:	8082                	ret

000000008000173a <procinit>:

extern char trampoline[]; // trampoline.S

void
procinit(void)
{
    8000173a:	715d                	addi	sp,sp,-80
    8000173c:	e486                	sd	ra,72(sp)
    8000173e:	e0a2                	sd	s0,64(sp)
    80001740:	fc26                	sd	s1,56(sp)
    80001742:	f84a                	sd	s2,48(sp)
    80001744:	f44e                	sd	s3,40(sp)
    80001746:	f052                	sd	s4,32(sp)
    80001748:	ec56                	sd	s5,24(sp)
    8000174a:	e85a                	sd	s6,16(sp)
    8000174c:	e45e                	sd	s7,8(sp)
    8000174e:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001750:	00006597          	auipc	a1,0x6
    80001754:	b7858593          	addi	a1,a1,-1160 # 800072c8 <userret+0x238>
    80001758:	00010517          	auipc	a0,0x10
    8000175c:	19050513          	addi	a0,a0,400 # 800118e8 <pid_lock>
    80001760:	fffff097          	auipc	ra,0xfffff
    80001764:	268080e7          	jalr	616(ra) # 800009c8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001768:	00010917          	auipc	s2,0x10
    8000176c:	59890913          	addi	s2,s2,1432 # 80011d00 <proc>
      initlock(&p->lock, "proc");
    80001770:	00006b97          	auipc	s7,0x6
    80001774:	b60b8b93          	addi	s7,s7,-1184 # 800072d0 <userret+0x240>
      // Map it high in memory, followed by an invalid
      // guard page.
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc));
    80001778:	8b4a                	mv	s6,s2
    8000177a:	00006a97          	auipc	s5,0x6
    8000177e:	29ea8a93          	addi	s5,s5,670 # 80007a18 <syscalls+0xc0>
    80001782:	040009b7          	lui	s3,0x4000
    80001786:	19fd                	addi	s3,s3,-1
    80001788:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000178a:	00016a17          	auipc	s4,0x16
    8000178e:	f76a0a13          	addi	s4,s4,-138 # 80017700 <tickslock>
      initlock(&p->lock, "proc");
    80001792:	85de                	mv	a1,s7
    80001794:	854a                	mv	a0,s2
    80001796:	fffff097          	auipc	ra,0xfffff
    8000179a:	232080e7          	jalr	562(ra) # 800009c8 <initlock>
      char *pa = kalloc();
    8000179e:	fffff097          	auipc	ra,0xfffff
    800017a2:	1ca080e7          	jalr	458(ra) # 80000968 <kalloc>
    800017a6:	85aa                	mv	a1,a0
      if(pa == 0)
    800017a8:	c929                	beqz	a0,800017fa <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800017aa:	416904b3          	sub	s1,s2,s6
    800017ae:	848d                	srai	s1,s1,0x3
    800017b0:	000ab783          	ld	a5,0(s5)
    800017b4:	02f484b3          	mul	s1,s1,a5
    800017b8:	2485                	addiw	s1,s1,1
    800017ba:	00d4949b          	slliw	s1,s1,0xd
    800017be:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c2:	4699                	li	a3,6
    800017c4:	6605                	lui	a2,0x1
    800017c6:	8526                	mv	a0,s1
    800017c8:	00000097          	auipc	ra,0x0
    800017cc:	8ee080e7          	jalr	-1810(ra) # 800010b6 <kvmmap>
      p->kstack = va;
    800017d0:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d4:	16890913          	addi	s2,s2,360
    800017d8:	fb491de3          	bne	s2,s4,80001792 <procinit+0x58>
  }
  kvminithart();
    800017dc:	fffff097          	auipc	ra,0xfffff
    800017e0:	794080e7          	jalr	1940(ra) # 80000f70 <kvminithart>
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6161                	addi	sp,sp,80
    800017f8:	8082                	ret
        panic("kalloc");
    800017fa:	00006517          	auipc	a0,0x6
    800017fe:	ade50513          	addi	a0,a0,-1314 # 800072d8 <userret+0x248>
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	d46080e7          	jalr	-698(ra) # 80000548 <panic>

000000008000180a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000180a:	1141                	addi	sp,sp,-16
    8000180c:	e422                	sd	s0,8(sp)
    8000180e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001810:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001812:	2501                	sext.w	a0,a0
    80001814:	6422                	ld	s0,8(sp)
    80001816:	0141                	addi	sp,sp,16
    80001818:	8082                	ret

000000008000181a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000181a:	1141                	addi	sp,sp,-16
    8000181c:	e422                	sd	s0,8(sp)
    8000181e:	0800                	addi	s0,sp,16
    80001820:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001822:	2781                	sext.w	a5,a5
    80001824:	079e                	slli	a5,a5,0x7
  return c;
}
    80001826:	00010517          	auipc	a0,0x10
    8000182a:	0da50513          	addi	a0,a0,218 # 80011900 <cpus>
    8000182e:	953e                	add	a0,a0,a5
    80001830:	6422                	ld	s0,8(sp)
    80001832:	0141                	addi	sp,sp,16
    80001834:	8082                	ret

0000000080001836 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001836:	1101                	addi	sp,sp,-32
    80001838:	ec06                	sd	ra,24(sp)
    8000183a:	e822                	sd	s0,16(sp)
    8000183c:	e426                	sd	s1,8(sp)
    8000183e:	1000                	addi	s0,sp,32
  push_off();
    80001840:	fffff097          	auipc	ra,0xfffff
    80001844:	19e080e7          	jalr	414(ra) # 800009de <push_off>
    80001848:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000184a:	2781                	sext.w	a5,a5
    8000184c:	079e                	slli	a5,a5,0x7
    8000184e:	00010717          	auipc	a4,0x10
    80001852:	09a70713          	addi	a4,a4,154 # 800118e8 <pid_lock>
    80001856:	97ba                	add	a5,a5,a4
    80001858:	6f84                	ld	s1,24(a5)
  pop_off();
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	1d0080e7          	jalr	464(ra) # 80000a2a <pop_off>
  return p;
}
    80001862:	8526                	mv	a0,s1
    80001864:	60e2                	ld	ra,24(sp)
    80001866:	6442                	ld	s0,16(sp)
    80001868:	64a2                	ld	s1,8(sp)
    8000186a:	6105                	addi	sp,sp,32
    8000186c:	8082                	ret

000000008000186e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000186e:	1141                	addi	sp,sp,-16
    80001870:	e406                	sd	ra,8(sp)
    80001872:	e022                	sd	s0,0(sp)
    80001874:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001876:	00000097          	auipc	ra,0x0
    8000187a:	fc0080e7          	jalr	-64(ra) # 80001836 <myproc>
    8000187e:	fffff097          	auipc	ra,0xfffff
    80001882:	2c0080e7          	jalr	704(ra) # 80000b3e <release>

  if (first) {
    80001886:	00006797          	auipc	a5,0x6
    8000188a:	7ae7a783          	lw	a5,1966(a5) # 80008034 <first.1>
    8000188e:	eb89                	bnez	a5,800018a0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(minor(ROOTDEV));
  }

  usertrapret();
    80001890:	00001097          	auipc	ra,0x1
    80001894:	c1c080e7          	jalr	-996(ra) # 800024ac <usertrapret>
}
    80001898:	60a2                	ld	ra,8(sp)
    8000189a:	6402                	ld	s0,0(sp)
    8000189c:	0141                	addi	sp,sp,16
    8000189e:	8082                	ret
    first = 0;
    800018a0:	00006797          	auipc	a5,0x6
    800018a4:	7807aa23          	sw	zero,1940(a5) # 80008034 <first.1>
    fsinit(minor(ROOTDEV));
    800018a8:	4501                	li	a0,0
    800018aa:	00002097          	auipc	ra,0x2
    800018ae:	944080e7          	jalr	-1724(ra) # 800031ee <fsinit>
    800018b2:	bff9                	j	80001890 <forkret+0x22>

00000000800018b4 <allocpid>:
allocpid() {
    800018b4:	1101                	addi	sp,sp,-32
    800018b6:	ec06                	sd	ra,24(sp)
    800018b8:	e822                	sd	s0,16(sp)
    800018ba:	e426                	sd	s1,8(sp)
    800018bc:	e04a                	sd	s2,0(sp)
    800018be:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018c0:	00010917          	auipc	s2,0x10
    800018c4:	02890913          	addi	s2,s2,40 # 800118e8 <pid_lock>
    800018c8:	854a                	mv	a0,s2
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	20c080e7          	jalr	524(ra) # 80000ad6 <acquire>
  pid = nextpid;
    800018d2:	00006797          	auipc	a5,0x6
    800018d6:	76678793          	addi	a5,a5,1894 # 80008038 <nextpid>
    800018da:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018dc:	0014871b          	addiw	a4,s1,1
    800018e0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018e2:	854a                	mv	a0,s2
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	25a080e7          	jalr	602(ra) # 80000b3e <release>
}
    800018ec:	8526                	mv	a0,s1
    800018ee:	60e2                	ld	ra,24(sp)
    800018f0:	6442                	ld	s0,16(sp)
    800018f2:	64a2                	ld	s1,8(sp)
    800018f4:	6902                	ld	s2,0(sp)
    800018f6:	6105                	addi	sp,sp,32
    800018f8:	8082                	ret

00000000800018fa <proc_pagetable>:
{
    800018fa:	1101                	addi	sp,sp,-32
    800018fc:	ec06                	sd	ra,24(sp)
    800018fe:	e822                	sd	s0,16(sp)
    80001900:	e426                	sd	s1,8(sp)
    80001902:	e04a                	sd	s2,0(sp)
    80001904:	1000                	addi	s0,sp,32
    80001906:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001908:	00000097          	auipc	ra,0x0
    8000190c:	994080e7          	jalr	-1644(ra) # 8000129c <uvmcreate>
    80001910:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001912:	4729                	li	a4,10
    80001914:	00005697          	auipc	a3,0x5
    80001918:	6ec68693          	addi	a3,a3,1772 # 80007000 <trampoline>
    8000191c:	6605                	lui	a2,0x1
    8000191e:	040005b7          	lui	a1,0x4000
    80001922:	15fd                	addi	a1,a1,-1
    80001924:	05b2                	slli	a1,a1,0xc
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	702080e7          	jalr	1794(ra) # 80001028 <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    8000192e:	4719                	li	a4,6
    80001930:	05893683          	ld	a3,88(s2)
    80001934:	6605                	lui	a2,0x1
    80001936:	020005b7          	lui	a1,0x2000
    8000193a:	15fd                	addi	a1,a1,-1
    8000193c:	05b6                	slli	a1,a1,0xd
    8000193e:	8526                	mv	a0,s1
    80001940:	fffff097          	auipc	ra,0xfffff
    80001944:	6e8080e7          	jalr	1768(ra) # 80001028 <mappages>
}
    80001948:	8526                	mv	a0,s1
    8000194a:	60e2                	ld	ra,24(sp)
    8000194c:	6442                	ld	s0,16(sp)
    8000194e:	64a2                	ld	s1,8(sp)
    80001950:	6902                	ld	s2,0(sp)
    80001952:	6105                	addi	sp,sp,32
    80001954:	8082                	ret

0000000080001956 <allocproc>:
{
    80001956:	1101                	addi	sp,sp,-32
    80001958:	ec06                	sd	ra,24(sp)
    8000195a:	e822                	sd	s0,16(sp)
    8000195c:	e426                	sd	s1,8(sp)
    8000195e:	e04a                	sd	s2,0(sp)
    80001960:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001962:	00010497          	auipc	s1,0x10
    80001966:	39e48493          	addi	s1,s1,926 # 80011d00 <proc>
    8000196a:	00016917          	auipc	s2,0x16
    8000196e:	d9690913          	addi	s2,s2,-618 # 80017700 <tickslock>
    acquire(&p->lock);
    80001972:	8526                	mv	a0,s1
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	162080e7          	jalr	354(ra) # 80000ad6 <acquire>
    if(p->state == UNUSED) {
    8000197c:	4c9c                	lw	a5,24(s1)
    8000197e:	cf81                	beqz	a5,80001996 <allocproc+0x40>
      release(&p->lock);
    80001980:	8526                	mv	a0,s1
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	1bc080e7          	jalr	444(ra) # 80000b3e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000198a:	16848493          	addi	s1,s1,360
    8000198e:	ff2492e3          	bne	s1,s2,80001972 <allocproc+0x1c>
  return 0;
    80001992:	4481                	li	s1,0
    80001994:	a0a9                	j	800019de <allocproc+0x88>
  p->pid = allocpid();
    80001996:	00000097          	auipc	ra,0x0
    8000199a:	f1e080e7          	jalr	-226(ra) # 800018b4 <allocpid>
    8000199e:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	fc8080e7          	jalr	-56(ra) # 80000968 <kalloc>
    800019a8:	892a                	mv	s2,a0
    800019aa:	eca8                	sd	a0,88(s1)
    800019ac:	c121                	beqz	a0,800019ec <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    800019ae:	8526                	mv	a0,s1
    800019b0:	00000097          	auipc	ra,0x0
    800019b4:	f4a080e7          	jalr	-182(ra) # 800018fa <proc_pagetable>
    800019b8:	e8a8                	sd	a0,80(s1)
  memset(&p->context, 0, sizeof p->context);
    800019ba:	07000613          	li	a2,112
    800019be:	4581                	li	a1,0
    800019c0:	06048513          	addi	a0,s1,96
    800019c4:	fffff097          	auipc	ra,0xfffff
    800019c8:	1d6080e7          	jalr	470(ra) # 80000b9a <memset>
  p->context.ra = (uint64)forkret;
    800019cc:	00000797          	auipc	a5,0x0
    800019d0:	ea278793          	addi	a5,a5,-350 # 8000186e <forkret>
    800019d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019d6:	60bc                	ld	a5,64(s1)
    800019d8:	6705                	lui	a4,0x1
    800019da:	97ba                	add	a5,a5,a4
    800019dc:	f4bc                	sd	a5,104(s1)
}
    800019de:	8526                	mv	a0,s1
    800019e0:	60e2                	ld	ra,24(sp)
    800019e2:	6442                	ld	s0,16(sp)
    800019e4:	64a2                	ld	s1,8(sp)
    800019e6:	6902                	ld	s2,0(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret
    release(&p->lock);
    800019ec:	8526                	mv	a0,s1
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	150080e7          	jalr	336(ra) # 80000b3e <release>
    return 0;
    800019f6:	84ca                	mv	s1,s2
    800019f8:	b7dd                	j	800019de <allocproc+0x88>

00000000800019fa <proc_freepagetable>:
{
    800019fa:	1101                	addi	sp,sp,-32
    800019fc:	ec06                	sd	ra,24(sp)
    800019fe:	e822                	sd	s0,16(sp)
    80001a00:	e426                	sd	s1,8(sp)
    80001a02:	e04a                	sd	s2,0(sp)
    80001a04:	1000                	addi	s0,sp,32
    80001a06:	84aa                	mv	s1,a0
    80001a08:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001a0a:	4681                	li	a3,0
    80001a0c:	6605                	lui	a2,0x1
    80001a0e:	040005b7          	lui	a1,0x4000
    80001a12:	15fd                	addi	a1,a1,-1
    80001a14:	05b2                	slli	a1,a1,0xc
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	7be080e7          	jalr	1982(ra) # 800011d4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001a1e:	4681                	li	a3,0
    80001a20:	6605                	lui	a2,0x1
    80001a22:	020005b7          	lui	a1,0x2000
    80001a26:	15fd                	addi	a1,a1,-1
    80001a28:	05b6                	slli	a1,a1,0xd
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	7a8080e7          	jalr	1960(ra) # 800011d4 <uvmunmap>
  if(sz > 0)
    80001a34:	00091863          	bnez	s2,80001a44 <proc_freepagetable+0x4a>
}
    80001a38:	60e2                	ld	ra,24(sp)
    80001a3a:	6442                	ld	s0,16(sp)
    80001a3c:	64a2                	ld	s1,8(sp)
    80001a3e:	6902                	ld	s2,0(sp)
    80001a40:	6105                	addi	sp,sp,32
    80001a42:	8082                	ret
    uvmfree(pagetable, sz);
    80001a44:	85ca                	mv	a1,s2
    80001a46:	8526                	mv	a0,s1
    80001a48:	00000097          	auipc	ra,0x0
    80001a4c:	9e2080e7          	jalr	-1566(ra) # 8000142a <uvmfree>
}
    80001a50:	b7e5                	j	80001a38 <proc_freepagetable+0x3e>

0000000080001a52 <freeproc>:
{
    80001a52:	1101                	addi	sp,sp,-32
    80001a54:	ec06                	sd	ra,24(sp)
    80001a56:	e822                	sd	s0,16(sp)
    80001a58:	e426                	sd	s1,8(sp)
    80001a5a:	1000                	addi	s0,sp,32
    80001a5c:	84aa                	mv	s1,a0
  if(p->tf)
    80001a5e:	6d28                	ld	a0,88(a0)
    80001a60:	c509                	beqz	a0,80001a6a <freeproc+0x18>
    kfree((void*)p->tf);
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	df2080e7          	jalr	-526(ra) # 80000854 <kfree>
  p->tf = 0;
    80001a6a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a6e:	68a8                	ld	a0,80(s1)
    80001a70:	c511                	beqz	a0,80001a7c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001a72:	64ac                	ld	a1,72(s1)
    80001a74:	00000097          	auipc	ra,0x0
    80001a78:	f86080e7          	jalr	-122(ra) # 800019fa <proc_freepagetable>
  p->pagetable = 0;
    80001a7c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a80:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a84:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001a88:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001a8c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a90:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001a94:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001a98:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001a9c:	0004ac23          	sw	zero,24(s1)
}
    80001aa0:	60e2                	ld	ra,24(sp)
    80001aa2:	6442                	ld	s0,16(sp)
    80001aa4:	64a2                	ld	s1,8(sp)
    80001aa6:	6105                	addi	sp,sp,32
    80001aa8:	8082                	ret

0000000080001aaa <userinit>:
{
    80001aaa:	1101                	addi	sp,sp,-32
    80001aac:	ec06                	sd	ra,24(sp)
    80001aae:	e822                	sd	s0,16(sp)
    80001ab0:	e426                	sd	s1,8(sp)
    80001ab2:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ab4:	00000097          	auipc	ra,0x0
    80001ab8:	ea2080e7          	jalr	-350(ra) # 80001956 <allocproc>
    80001abc:	84aa                	mv	s1,a0
  initproc = p;
    80001abe:	00027797          	auipc	a5,0x27
    80001ac2:	56a7bd23          	sd	a0,1402(a5) # 80029038 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ac6:	03300613          	li	a2,51
    80001aca:	00006597          	auipc	a1,0x6
    80001ace:	53658593          	addi	a1,a1,1334 # 80008000 <initcode>
    80001ad2:	6928                	ld	a0,80(a0)
    80001ad4:	00000097          	auipc	ra,0x0
    80001ad8:	806080e7          	jalr	-2042(ra) # 800012da <uvminit>
  p->sz = PGSIZE;
    80001adc:	6785                	lui	a5,0x1
    80001ade:	e4bc                	sd	a5,72(s1)
  p->tf->epc = 0;      // user program counter
    80001ae0:	6cb8                	ld	a4,88(s1)
    80001ae2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001ae6:	6cb8                	ld	a4,88(s1)
    80001ae8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001aea:	4641                	li	a2,16
    80001aec:	00005597          	auipc	a1,0x5
    80001af0:	7f458593          	addi	a1,a1,2036 # 800072e0 <userret+0x250>
    80001af4:	15848513          	addi	a0,s1,344
    80001af8:	fffff097          	auipc	ra,0xfffff
    80001afc:	1f4080e7          	jalr	500(ra) # 80000cec <safestrcpy>
  p->cwd = namei("/");
    80001b00:	00005517          	auipc	a0,0x5
    80001b04:	7f050513          	addi	a0,a0,2032 # 800072f0 <userret+0x260>
    80001b08:	00002097          	auipc	ra,0x2
    80001b0c:	0ea080e7          	jalr	234(ra) # 80003bf2 <namei>
    80001b10:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b14:	4789                	li	a5,2
    80001b16:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b18:	8526                	mv	a0,s1
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	024080e7          	jalr	36(ra) # 80000b3e <release>
}
    80001b22:	60e2                	ld	ra,24(sp)
    80001b24:	6442                	ld	s0,16(sp)
    80001b26:	64a2                	ld	s1,8(sp)
    80001b28:	6105                	addi	sp,sp,32
    80001b2a:	8082                	ret

0000000080001b2c <growproc>:
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	e04a                	sd	s2,0(sp)
    80001b36:	1000                	addi	s0,sp,32
    80001b38:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b3a:	00000097          	auipc	ra,0x0
    80001b3e:	cfc080e7          	jalr	-772(ra) # 80001836 <myproc>
    80001b42:	892a                	mv	s2,a0
  sz = p->sz;
    80001b44:	652c                	ld	a1,72(a0)
    80001b46:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001b4a:	00904f63          	bgtz	s1,80001b68 <growproc+0x3c>
  } else if(n < 0){
    80001b4e:	0204cc63          	bltz	s1,80001b86 <growproc+0x5a>
  p->sz = sz;
    80001b52:	1602                	slli	a2,a2,0x20
    80001b54:	9201                	srli	a2,a2,0x20
    80001b56:	04c93423          	sd	a2,72(s2)
  return 0;
    80001b5a:	4501                	li	a0,0
}
    80001b5c:	60e2                	ld	ra,24(sp)
    80001b5e:	6442                	ld	s0,16(sp)
    80001b60:	64a2                	ld	s1,8(sp)
    80001b62:	6902                	ld	s2,0(sp)
    80001b64:	6105                	addi	sp,sp,32
    80001b66:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001b68:	9e25                	addw	a2,a2,s1
    80001b6a:	1602                	slli	a2,a2,0x20
    80001b6c:	9201                	srli	a2,a2,0x20
    80001b6e:	1582                	slli	a1,a1,0x20
    80001b70:	9181                	srli	a1,a1,0x20
    80001b72:	6928                	ld	a0,80(a0)
    80001b74:	00000097          	auipc	ra,0x0
    80001b78:	80c080e7          	jalr	-2036(ra) # 80001380 <uvmalloc>
    80001b7c:	0005061b          	sext.w	a2,a0
    80001b80:	fa69                	bnez	a2,80001b52 <growproc+0x26>
      return -1;
    80001b82:	557d                	li	a0,-1
    80001b84:	bfe1                	j	80001b5c <growproc+0x30>
    if((sz = uvmdealloc(p->pagetable, sz, sz + n)) == 0) {
    80001b86:	9e25                	addw	a2,a2,s1
    80001b88:	1602                	slli	a2,a2,0x20
    80001b8a:	9201                	srli	a2,a2,0x20
    80001b8c:	1582                	slli	a1,a1,0x20
    80001b8e:	9181                	srli	a1,a1,0x20
    80001b90:	6928                	ld	a0,80(a0)
    80001b92:	fffff097          	auipc	ra,0xfffff
    80001b96:	7ba080e7          	jalr	1978(ra) # 8000134c <uvmdealloc>
    80001b9a:	0005061b          	sext.w	a2,a0
    80001b9e:	fa55                	bnez	a2,80001b52 <growproc+0x26>
      return -1;
    80001ba0:	557d                	li	a0,-1
    80001ba2:	bf6d                	j	80001b5c <growproc+0x30>

0000000080001ba4 <fork>:
{
    80001ba4:	7139                	addi	sp,sp,-64
    80001ba6:	fc06                	sd	ra,56(sp)
    80001ba8:	f822                	sd	s0,48(sp)
    80001baa:	f426                	sd	s1,40(sp)
    80001bac:	f04a                	sd	s2,32(sp)
    80001bae:	ec4e                	sd	s3,24(sp)
    80001bb0:	e852                	sd	s4,16(sp)
    80001bb2:	e456                	sd	s5,8(sp)
    80001bb4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001bb6:	00000097          	auipc	ra,0x0
    80001bba:	c80080e7          	jalr	-896(ra) # 80001836 <myproc>
    80001bbe:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001bc0:	00000097          	auipc	ra,0x0
    80001bc4:	d96080e7          	jalr	-618(ra) # 80001956 <allocproc>
    80001bc8:	c17d                	beqz	a0,80001cae <fork+0x10a>
    80001bca:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bcc:	048ab603          	ld	a2,72(s5)
    80001bd0:	692c                	ld	a1,80(a0)
    80001bd2:	050ab503          	ld	a0,80(s5)
    80001bd6:	00000097          	auipc	ra,0x0
    80001bda:	882080e7          	jalr	-1918(ra) # 80001458 <uvmcopy>
    80001bde:	04054a63          	bltz	a0,80001c32 <fork+0x8e>
  np->sz = p->sz;
    80001be2:	048ab783          	ld	a5,72(s5)
    80001be6:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001bea:	035a3023          	sd	s5,32(s4)
  *(np->tf) = *(p->tf);
    80001bee:	058ab683          	ld	a3,88(s5)
    80001bf2:	87b6                	mv	a5,a3
    80001bf4:	058a3703          	ld	a4,88(s4)
    80001bf8:	12068693          	addi	a3,a3,288
    80001bfc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c00:	6788                	ld	a0,8(a5)
    80001c02:	6b8c                	ld	a1,16(a5)
    80001c04:	6f90                	ld	a2,24(a5)
    80001c06:	01073023          	sd	a6,0(a4)
    80001c0a:	e708                	sd	a0,8(a4)
    80001c0c:	eb0c                	sd	a1,16(a4)
    80001c0e:	ef10                	sd	a2,24(a4)
    80001c10:	02078793          	addi	a5,a5,32
    80001c14:	02070713          	addi	a4,a4,32
    80001c18:	fed792e3          	bne	a5,a3,80001bfc <fork+0x58>
  np->tf->a0 = 0;
    80001c1c:	058a3783          	ld	a5,88(s4)
    80001c20:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c24:	0d0a8493          	addi	s1,s5,208
    80001c28:	0d0a0913          	addi	s2,s4,208
    80001c2c:	150a8993          	addi	s3,s5,336
    80001c30:	a00d                	j	80001c52 <fork+0xae>
    freeproc(np);
    80001c32:	8552                	mv	a0,s4
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	e1e080e7          	jalr	-482(ra) # 80001a52 <freeproc>
    release(&np->lock);
    80001c3c:	8552                	mv	a0,s4
    80001c3e:	fffff097          	auipc	ra,0xfffff
    80001c42:	f00080e7          	jalr	-256(ra) # 80000b3e <release>
    return -1;
    80001c46:	54fd                	li	s1,-1
    80001c48:	a889                	j	80001c9a <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001c4a:	04a1                	addi	s1,s1,8
    80001c4c:	0921                	addi	s2,s2,8
    80001c4e:	01348b63          	beq	s1,s3,80001c64 <fork+0xc0>
    if(p->ofile[i])
    80001c52:	6088                	ld	a0,0(s1)
    80001c54:	d97d                	beqz	a0,80001c4a <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c56:	00003097          	auipc	ra,0x3
    80001c5a:	890080e7          	jalr	-1904(ra) # 800044e6 <filedup>
    80001c5e:	00a93023          	sd	a0,0(s2)
    80001c62:	b7e5                	j	80001c4a <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001c64:	150ab503          	ld	a0,336(s5)
    80001c68:	00001097          	auipc	ra,0x1
    80001c6c:	7c0080e7          	jalr	1984(ra) # 80003428 <idup>
    80001c70:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c74:	4641                	li	a2,16
    80001c76:	158a8593          	addi	a1,s5,344
    80001c7a:	158a0513          	addi	a0,s4,344
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	06e080e7          	jalr	110(ra) # 80000cec <safestrcpy>
  pid = np->pid;
    80001c86:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001c8a:	4789                	li	a5,2
    80001c8c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c90:	8552                	mv	a0,s4
    80001c92:	fffff097          	auipc	ra,0xfffff
    80001c96:	eac080e7          	jalr	-340(ra) # 80000b3e <release>
}
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	70e2                	ld	ra,56(sp)
    80001c9e:	7442                	ld	s0,48(sp)
    80001ca0:	74a2                	ld	s1,40(sp)
    80001ca2:	7902                	ld	s2,32(sp)
    80001ca4:	69e2                	ld	s3,24(sp)
    80001ca6:	6a42                	ld	s4,16(sp)
    80001ca8:	6aa2                	ld	s5,8(sp)
    80001caa:	6121                	addi	sp,sp,64
    80001cac:	8082                	ret
    return -1;
    80001cae:	54fd                	li	s1,-1
    80001cb0:	b7ed                	j	80001c9a <fork+0xf6>

0000000080001cb2 <reparent>:
reparent(struct proc *p, struct proc *parent) {
    80001cb2:	711d                	addi	sp,sp,-96
    80001cb4:	ec86                	sd	ra,88(sp)
    80001cb6:	e8a2                	sd	s0,80(sp)
    80001cb8:	e4a6                	sd	s1,72(sp)
    80001cba:	e0ca                	sd	s2,64(sp)
    80001cbc:	fc4e                	sd	s3,56(sp)
    80001cbe:	f852                	sd	s4,48(sp)
    80001cc0:	f456                	sd	s5,40(sp)
    80001cc2:	f05a                	sd	s6,32(sp)
    80001cc4:	ec5e                	sd	s7,24(sp)
    80001cc6:	e862                	sd	s8,16(sp)
    80001cc8:	e466                	sd	s9,8(sp)
    80001cca:	1080                	addi	s0,sp,96
    80001ccc:	892a                	mv	s2,a0
  int child_of_init = (p->parent == initproc);
    80001cce:	02053b83          	ld	s7,32(a0)
    80001cd2:	00027b17          	auipc	s6,0x27
    80001cd6:	366b3b03          	ld	s6,870(s6) # 80029038 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cda:	00010497          	auipc	s1,0x10
    80001cde:	02648493          	addi	s1,s1,38 # 80011d00 <proc>
      pp->parent = initproc;
    80001ce2:	00027a17          	auipc	s4,0x27
    80001ce6:	356a0a13          	addi	s4,s4,854 # 80029038 <initproc>
      if(pp->state == ZOMBIE) {
    80001cea:	4a91                	li	s5,4
// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
  if(p->chan == p && p->state == SLEEPING) {
    80001cec:	4c05                	li	s8,1
    p->state = RUNNABLE;
    80001cee:	4c89                	li	s9,2
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cf0:	00016997          	auipc	s3,0x16
    80001cf4:	a1098993          	addi	s3,s3,-1520 # 80017700 <tickslock>
    80001cf8:	a805                	j	80001d28 <reparent+0x76>
  if(p->chan == p && p->state == SLEEPING) {
    80001cfa:	751c                	ld	a5,40(a0)
    80001cfc:	00f51d63          	bne	a0,a5,80001d16 <reparent+0x64>
    80001d00:	4d1c                	lw	a5,24(a0)
    80001d02:	01879a63          	bne	a5,s8,80001d16 <reparent+0x64>
    p->state = RUNNABLE;
    80001d06:	01952c23          	sw	s9,24(a0)
        if(!child_of_init)
    80001d0a:	016b8663          	beq	s7,s6,80001d16 <reparent+0x64>
          release(&initproc->lock);
    80001d0e:	fffff097          	auipc	ra,0xfffff
    80001d12:	e30080e7          	jalr	-464(ra) # 80000b3e <release>
      release(&pp->lock);
    80001d16:	8526                	mv	a0,s1
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	e26080e7          	jalr	-474(ra) # 80000b3e <release>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001d20:	16848493          	addi	s1,s1,360
    80001d24:	03348f63          	beq	s1,s3,80001d62 <reparent+0xb0>
    if(pp->parent == p){
    80001d28:	709c                	ld	a5,32(s1)
    80001d2a:	ff279be3          	bne	a5,s2,80001d20 <reparent+0x6e>
      acquire(&pp->lock);
    80001d2e:	8526                	mv	a0,s1
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	da6080e7          	jalr	-602(ra) # 80000ad6 <acquire>
      pp->parent = initproc;
    80001d38:	000a3503          	ld	a0,0(s4)
    80001d3c:	f088                	sd	a0,32(s1)
      if(pp->state == ZOMBIE) {
    80001d3e:	4c9c                	lw	a5,24(s1)
    80001d40:	fd579be3          	bne	a5,s5,80001d16 <reparent+0x64>
        if(!child_of_init)
    80001d44:	fb6b8be3          	beq	s7,s6,80001cfa <reparent+0x48>
          acquire(&initproc->lock);
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	d8e080e7          	jalr	-626(ra) # 80000ad6 <acquire>
        wakeup1(initproc);
    80001d50:	000a3503          	ld	a0,0(s4)
  if(p->chan == p && p->state == SLEEPING) {
    80001d54:	751c                	ld	a5,40(a0)
    80001d56:	faa79ce3          	bne	a5,a0,80001d0e <reparent+0x5c>
    80001d5a:	4d1c                	lw	a5,24(a0)
    80001d5c:	fb8799e3          	bne	a5,s8,80001d0e <reparent+0x5c>
    80001d60:	b75d                	j	80001d06 <reparent+0x54>
}
    80001d62:	60e6                	ld	ra,88(sp)
    80001d64:	6446                	ld	s0,80(sp)
    80001d66:	64a6                	ld	s1,72(sp)
    80001d68:	6906                	ld	s2,64(sp)
    80001d6a:	79e2                	ld	s3,56(sp)
    80001d6c:	7a42                	ld	s4,48(sp)
    80001d6e:	7aa2                	ld	s5,40(sp)
    80001d70:	7b02                	ld	s6,32(sp)
    80001d72:	6be2                	ld	s7,24(sp)
    80001d74:	6c42                	ld	s8,16(sp)
    80001d76:	6ca2                	ld	s9,8(sp)
    80001d78:	6125                	addi	sp,sp,96
    80001d7a:	8082                	ret

0000000080001d7c <scheduler>:
{
    80001d7c:	715d                	addi	sp,sp,-80
    80001d7e:	e486                	sd	ra,72(sp)
    80001d80:	e0a2                	sd	s0,64(sp)
    80001d82:	fc26                	sd	s1,56(sp)
    80001d84:	f84a                	sd	s2,48(sp)
    80001d86:	f44e                	sd	s3,40(sp)
    80001d88:	f052                	sd	s4,32(sp)
    80001d8a:	ec56                	sd	s5,24(sp)
    80001d8c:	e85a                	sd	s6,16(sp)
    80001d8e:	e45e                	sd	s7,8(sp)
    80001d90:	e062                	sd	s8,0(sp)
    80001d92:	0880                	addi	s0,sp,80
    80001d94:	8792                	mv	a5,tp
  int id = r_tp();
    80001d96:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d98:	00779b13          	slli	s6,a5,0x7
    80001d9c:	00010717          	auipc	a4,0x10
    80001da0:	b4c70713          	addi	a4,a4,-1204 # 800118e8 <pid_lock>
    80001da4:	975a                	add	a4,a4,s6
    80001da6:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001daa:	00010717          	auipc	a4,0x10
    80001dae:	b5e70713          	addi	a4,a4,-1186 # 80011908 <cpus+0x8>
    80001db2:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001db4:	4c0d                	li	s8,3
        c->proc = p;
    80001db6:	079e                	slli	a5,a5,0x7
    80001db8:	00010a17          	auipc	s4,0x10
    80001dbc:	b30a0a13          	addi	s4,s4,-1232 # 800118e8 <pid_lock>
    80001dc0:	9a3e                	add	s4,s4,a5
        found = 1;
    80001dc2:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dc4:	00016997          	auipc	s3,0x16
    80001dc8:	93c98993          	addi	s3,s3,-1732 # 80017700 <tickslock>
    80001dcc:	a08d                	j	80001e2e <scheduler+0xb2>
      release(&p->lock);
    80001dce:	8526                	mv	a0,s1
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	d6e080e7          	jalr	-658(ra) # 80000b3e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dd8:	16848493          	addi	s1,s1,360
    80001ddc:	03348963          	beq	s1,s3,80001e0e <scheduler+0x92>
      acquire(&p->lock);
    80001de0:	8526                	mv	a0,s1
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	cf4080e7          	jalr	-780(ra) # 80000ad6 <acquire>
      if(p->state == RUNNABLE) {
    80001dea:	4c9c                	lw	a5,24(s1)
    80001dec:	ff2791e3          	bne	a5,s2,80001dce <scheduler+0x52>
        p->state = RUNNING;
    80001df0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001df4:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80001df8:	06048593          	addi	a1,s1,96
    80001dfc:	855a                	mv	a0,s6
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	604080e7          	jalr	1540(ra) # 80002402 <swtch>
        c->proc = 0;
    80001e06:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001e0a:	8ade                	mv	s5,s7
    80001e0c:	b7c9                	j	80001dce <scheduler+0x52>
    if(found == 0){
    80001e0e:	020a9063          	bnez	s5,80001e2e <scheduler+0xb2>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e12:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e16:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e1a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e22:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e26:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e2a:	10500073          	wfi
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001e2e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001e32:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001e36:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e42:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e46:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e48:	00010497          	auipc	s1,0x10
    80001e4c:	eb848493          	addi	s1,s1,-328 # 80011d00 <proc>
      if(p->state == RUNNABLE) {
    80001e50:	4909                	li	s2,2
    80001e52:	b779                	j	80001de0 <scheduler+0x64>

0000000080001e54 <sched>:
{
    80001e54:	7179                	addi	sp,sp,-48
    80001e56:	f406                	sd	ra,40(sp)
    80001e58:	f022                	sd	s0,32(sp)
    80001e5a:	ec26                	sd	s1,24(sp)
    80001e5c:	e84a                	sd	s2,16(sp)
    80001e5e:	e44e                	sd	s3,8(sp)
    80001e60:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	9d4080e7          	jalr	-1580(ra) # 80001836 <myproc>
    80001e6a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	c2a080e7          	jalr	-982(ra) # 80000a96 <holding>
    80001e74:	c93d                	beqz	a0,80001eea <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e76:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e78:	2781                	sext.w	a5,a5
    80001e7a:	079e                	slli	a5,a5,0x7
    80001e7c:	00010717          	auipc	a4,0x10
    80001e80:	a6c70713          	addi	a4,a4,-1428 # 800118e8 <pid_lock>
    80001e84:	97ba                	add	a5,a5,a4
    80001e86:	0907a703          	lw	a4,144(a5)
    80001e8a:	4785                	li	a5,1
    80001e8c:	06f71763          	bne	a4,a5,80001efa <sched+0xa6>
  if(p->state == RUNNING)
    80001e90:	4c98                	lw	a4,24(s1)
    80001e92:	478d                	li	a5,3
    80001e94:	06f70b63          	beq	a4,a5,80001f0a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e9c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e9e:	efb5                	bnez	a5,80001f1a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ea0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001ea2:	00010917          	auipc	s2,0x10
    80001ea6:	a4690913          	addi	s2,s2,-1466 # 800118e8 <pid_lock>
    80001eaa:	2781                	sext.w	a5,a5
    80001eac:	079e                	slli	a5,a5,0x7
    80001eae:	97ca                	add	a5,a5,s2
    80001eb0:	0947a983          	lw	s3,148(a5)
    80001eb4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80001eb6:	2781                	sext.w	a5,a5
    80001eb8:	079e                	slli	a5,a5,0x7
    80001eba:	00010597          	auipc	a1,0x10
    80001ebe:	a4e58593          	addi	a1,a1,-1458 # 80011908 <cpus+0x8>
    80001ec2:	95be                	add	a1,a1,a5
    80001ec4:	06048513          	addi	a0,s1,96
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	53a080e7          	jalr	1338(ra) # 80002402 <swtch>
    80001ed0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ed2:	2781                	sext.w	a5,a5
    80001ed4:	079e                	slli	a5,a5,0x7
    80001ed6:	97ca                	add	a5,a5,s2
    80001ed8:	0937aa23          	sw	s3,148(a5)
}
    80001edc:	70a2                	ld	ra,40(sp)
    80001ede:	7402                	ld	s0,32(sp)
    80001ee0:	64e2                	ld	s1,24(sp)
    80001ee2:	6942                	ld	s2,16(sp)
    80001ee4:	69a2                	ld	s3,8(sp)
    80001ee6:	6145                	addi	sp,sp,48
    80001ee8:	8082                	ret
    panic("sched p->lock");
    80001eea:	00005517          	auipc	a0,0x5
    80001eee:	40e50513          	addi	a0,a0,1038 # 800072f8 <userret+0x268>
    80001ef2:	ffffe097          	auipc	ra,0xffffe
    80001ef6:	656080e7          	jalr	1622(ra) # 80000548 <panic>
    panic("sched locks");
    80001efa:	00005517          	auipc	a0,0x5
    80001efe:	40e50513          	addi	a0,a0,1038 # 80007308 <userret+0x278>
    80001f02:	ffffe097          	auipc	ra,0xffffe
    80001f06:	646080e7          	jalr	1606(ra) # 80000548 <panic>
    panic("sched running");
    80001f0a:	00005517          	auipc	a0,0x5
    80001f0e:	40e50513          	addi	a0,a0,1038 # 80007318 <userret+0x288>
    80001f12:	ffffe097          	auipc	ra,0xffffe
    80001f16:	636080e7          	jalr	1590(ra) # 80000548 <panic>
    panic("sched interruptible");
    80001f1a:	00005517          	auipc	a0,0x5
    80001f1e:	40e50513          	addi	a0,a0,1038 # 80007328 <userret+0x298>
    80001f22:	ffffe097          	auipc	ra,0xffffe
    80001f26:	626080e7          	jalr	1574(ra) # 80000548 <panic>

0000000080001f2a <exit>:
{
    80001f2a:	7179                	addi	sp,sp,-48
    80001f2c:	f406                	sd	ra,40(sp)
    80001f2e:	f022                	sd	s0,32(sp)
    80001f30:	ec26                	sd	s1,24(sp)
    80001f32:	e84a                	sd	s2,16(sp)
    80001f34:	e44e                	sd	s3,8(sp)
    80001f36:	e052                	sd	s4,0(sp)
    80001f38:	1800                	addi	s0,sp,48
    80001f3a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f3c:	00000097          	auipc	ra,0x0
    80001f40:	8fa080e7          	jalr	-1798(ra) # 80001836 <myproc>
    80001f44:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f46:	00027797          	auipc	a5,0x27
    80001f4a:	0f27b783          	ld	a5,242(a5) # 80029038 <initproc>
    80001f4e:	0d050493          	addi	s1,a0,208
    80001f52:	15050913          	addi	s2,a0,336
    80001f56:	02a79363          	bne	a5,a0,80001f7c <exit+0x52>
    panic("init exiting");
    80001f5a:	00005517          	auipc	a0,0x5
    80001f5e:	3e650513          	addi	a0,a0,998 # 80007340 <userret+0x2b0>
    80001f62:	ffffe097          	auipc	ra,0xffffe
    80001f66:	5e6080e7          	jalr	1510(ra) # 80000548 <panic>
      fileclose(f);
    80001f6a:	00002097          	auipc	ra,0x2
    80001f6e:	5ce080e7          	jalr	1486(ra) # 80004538 <fileclose>
      p->ofile[fd] = 0;
    80001f72:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f76:	04a1                	addi	s1,s1,8
    80001f78:	01248563          	beq	s1,s2,80001f82 <exit+0x58>
    if(p->ofile[fd]){
    80001f7c:	6088                	ld	a0,0(s1)
    80001f7e:	f575                	bnez	a0,80001f6a <exit+0x40>
    80001f80:	bfdd                	j	80001f76 <exit+0x4c>
  begin_op(ROOTDEV);
    80001f82:	4501                	li	a0,0
    80001f84:	00002097          	auipc	ra,0x2
    80001f88:	f8c080e7          	jalr	-116(ra) # 80003f10 <begin_op>
  iput(p->cwd);
    80001f8c:	1509b503          	ld	a0,336(s3)
    80001f90:	00001097          	auipc	ra,0x1
    80001f94:	5e4080e7          	jalr	1508(ra) # 80003574 <iput>
  end_op(ROOTDEV);
    80001f98:	4501                	li	a0,0
    80001f9a:	00002097          	auipc	ra,0x2
    80001f9e:	020080e7          	jalr	32(ra) # 80003fba <end_op>
  p->cwd = 0;
    80001fa2:	1409b823          	sd	zero,336(s3)
  acquire(&p->parent->lock);
    80001fa6:	0209b503          	ld	a0,32(s3)
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	b2c080e7          	jalr	-1236(ra) # 80000ad6 <acquire>
  acquire(&p->lock);
    80001fb2:	854e                	mv	a0,s3
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	b22080e7          	jalr	-1246(ra) # 80000ad6 <acquire>
  reparent(p, p->parent);
    80001fbc:	0209b583          	ld	a1,32(s3)
    80001fc0:	854e                	mv	a0,s3
    80001fc2:	00000097          	auipc	ra,0x0
    80001fc6:	cf0080e7          	jalr	-784(ra) # 80001cb2 <reparent>
  wakeup1(p->parent);
    80001fca:	0209b783          	ld	a5,32(s3)
  if(p->chan == p && p->state == SLEEPING) {
    80001fce:	7798                	ld	a4,40(a5)
    80001fd0:	02e78963          	beq	a5,a4,80002002 <exit+0xd8>
  p->xstate = status;
    80001fd4:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001fd8:	4791                	li	a5,4
    80001fda:	00f9ac23          	sw	a5,24(s3)
  release(&p->parent->lock);
    80001fde:	0209b503          	ld	a0,32(s3)
    80001fe2:	fffff097          	auipc	ra,0xfffff
    80001fe6:	b5c080e7          	jalr	-1188(ra) # 80000b3e <release>
  sched();
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	e6a080e7          	jalr	-406(ra) # 80001e54 <sched>
  panic("zombie exit");
    80001ff2:	00005517          	auipc	a0,0x5
    80001ff6:	35e50513          	addi	a0,a0,862 # 80007350 <userret+0x2c0>
    80001ffa:	ffffe097          	auipc	ra,0xffffe
    80001ffe:	54e080e7          	jalr	1358(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80002002:	4f94                	lw	a3,24(a5)
    80002004:	4705                	li	a4,1
    80002006:	fce697e3          	bne	a3,a4,80001fd4 <exit+0xaa>
    p->state = RUNNABLE;
    8000200a:	4709                	li	a4,2
    8000200c:	cf98                	sw	a4,24(a5)
    8000200e:	b7d9                	j	80001fd4 <exit+0xaa>

0000000080002010 <yield>:
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	81c080e7          	jalr	-2020(ra) # 80001836 <myproc>
    80002022:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	ab2080e7          	jalr	-1358(ra) # 80000ad6 <acquire>
  p->state = RUNNABLE;
    8000202c:	4789                	li	a5,2
    8000202e:	cc9c                	sw	a5,24(s1)
  sched();
    80002030:	00000097          	auipc	ra,0x0
    80002034:	e24080e7          	jalr	-476(ra) # 80001e54 <sched>
  release(&p->lock);
    80002038:	8526                	mv	a0,s1
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	b04080e7          	jalr	-1276(ra) # 80000b3e <release>
}
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	64a2                	ld	s1,8(sp)
    80002048:	6105                	addi	sp,sp,32
    8000204a:	8082                	ret

000000008000204c <sleep>:
{
    8000204c:	7179                	addi	sp,sp,-48
    8000204e:	f406                	sd	ra,40(sp)
    80002050:	f022                	sd	s0,32(sp)
    80002052:	ec26                	sd	s1,24(sp)
    80002054:	e84a                	sd	s2,16(sp)
    80002056:	e44e                	sd	s3,8(sp)
    80002058:	1800                	addi	s0,sp,48
    8000205a:	89aa                	mv	s3,a0
    8000205c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	7d8080e7          	jalr	2008(ra) # 80001836 <myproc>
    80002066:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002068:	05250663          	beq	a0,s2,800020b4 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	a6a080e7          	jalr	-1430(ra) # 80000ad6 <acquire>
    release(lk);
    80002074:	854a                	mv	a0,s2
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	ac8080e7          	jalr	-1336(ra) # 80000b3e <release>
  p->chan = chan;
    8000207e:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002082:	4785                	li	a5,1
    80002084:	cc9c                	sw	a5,24(s1)
  sched();
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	dce080e7          	jalr	-562(ra) # 80001e54 <sched>
  p->chan = 0;
    8000208e:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002092:	8526                	mv	a0,s1
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	aaa080e7          	jalr	-1366(ra) # 80000b3e <release>
    acquire(lk);
    8000209c:	854a                	mv	a0,s2
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	a38080e7          	jalr	-1480(ra) # 80000ad6 <acquire>
}
    800020a6:	70a2                	ld	ra,40(sp)
    800020a8:	7402                	ld	s0,32(sp)
    800020aa:	64e2                	ld	s1,24(sp)
    800020ac:	6942                	ld	s2,16(sp)
    800020ae:	69a2                	ld	s3,8(sp)
    800020b0:	6145                	addi	sp,sp,48
    800020b2:	8082                	ret
  p->chan = chan;
    800020b4:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800020b8:	4785                	li	a5,1
    800020ba:	cd1c                	sw	a5,24(a0)
  sched();
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	d98080e7          	jalr	-616(ra) # 80001e54 <sched>
  p->chan = 0;
    800020c4:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800020c8:	bff9                	j	800020a6 <sleep+0x5a>

00000000800020ca <wait>:
{
    800020ca:	715d                	addi	sp,sp,-80
    800020cc:	e486                	sd	ra,72(sp)
    800020ce:	e0a2                	sd	s0,64(sp)
    800020d0:	fc26                	sd	s1,56(sp)
    800020d2:	f84a                	sd	s2,48(sp)
    800020d4:	f44e                	sd	s3,40(sp)
    800020d6:	f052                	sd	s4,32(sp)
    800020d8:	ec56                	sd	s5,24(sp)
    800020da:	e85a                	sd	s6,16(sp)
    800020dc:	e45e                	sd	s7,8(sp)
    800020de:	0880                	addi	s0,sp,80
    800020e0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	754080e7          	jalr	1876(ra) # 80001836 <myproc>
    800020ea:	892a                	mv	s2,a0
  acquire(&p->lock);
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	9ea080e7          	jalr	-1558(ra) # 80000ad6 <acquire>
    havekids = 0;
    800020f4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800020f6:	4a11                	li	s4,4
        havekids = 1;
    800020f8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800020fa:	00015997          	auipc	s3,0x15
    800020fe:	60698993          	addi	s3,s3,1542 # 80017700 <tickslock>
    havekids = 0;
    80002102:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002104:	00010497          	auipc	s1,0x10
    80002108:	bfc48493          	addi	s1,s1,-1028 # 80011d00 <proc>
    8000210c:	a08d                	j	8000216e <wait+0xa4>
          pid = np->pid;
    8000210e:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002112:	000b0e63          	beqz	s6,8000212e <wait+0x64>
    80002116:	4691                	li	a3,4
    80002118:	03448613          	addi	a2,s1,52
    8000211c:	85da                	mv	a1,s6
    8000211e:	05093503          	ld	a0,80(s2)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	438080e7          	jalr	1080(ra) # 8000155a <copyout>
    8000212a:	02054263          	bltz	a0,8000214e <wait+0x84>
          freeproc(np);
    8000212e:	8526                	mv	a0,s1
    80002130:	00000097          	auipc	ra,0x0
    80002134:	922080e7          	jalr	-1758(ra) # 80001a52 <freeproc>
          release(&np->lock);
    80002138:	8526                	mv	a0,s1
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	a04080e7          	jalr	-1532(ra) # 80000b3e <release>
          release(&p->lock);
    80002142:	854a                	mv	a0,s2
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	9fa080e7          	jalr	-1542(ra) # 80000b3e <release>
          return pid;
    8000214c:	a8a9                	j	800021a6 <wait+0xdc>
            release(&np->lock);
    8000214e:	8526                	mv	a0,s1
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	9ee080e7          	jalr	-1554(ra) # 80000b3e <release>
            release(&p->lock);
    80002158:	854a                	mv	a0,s2
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	9e4080e7          	jalr	-1564(ra) # 80000b3e <release>
            return -1;
    80002162:	59fd                	li	s3,-1
    80002164:	a089                	j	800021a6 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    80002166:	16848493          	addi	s1,s1,360
    8000216a:	03348463          	beq	s1,s3,80002192 <wait+0xc8>
      if(np->parent == p){
    8000216e:	709c                	ld	a5,32(s1)
    80002170:	ff279be3          	bne	a5,s2,80002166 <wait+0x9c>
        acquire(&np->lock);
    80002174:	8526                	mv	a0,s1
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	960080e7          	jalr	-1696(ra) # 80000ad6 <acquire>
        if(np->state == ZOMBIE){
    8000217e:	4c9c                	lw	a5,24(s1)
    80002180:	f94787e3          	beq	a5,s4,8000210e <wait+0x44>
        release(&np->lock);
    80002184:	8526                	mv	a0,s1
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	9b8080e7          	jalr	-1608(ra) # 80000b3e <release>
        havekids = 1;
    8000218e:	8756                	mv	a4,s5
    80002190:	bfd9                	j	80002166 <wait+0x9c>
    if(!havekids || p->killed){
    80002192:	c701                	beqz	a4,8000219a <wait+0xd0>
    80002194:	03092783          	lw	a5,48(s2)
    80002198:	c39d                	beqz	a5,800021be <wait+0xf4>
      release(&p->lock);
    8000219a:	854a                	mv	a0,s2
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	9a2080e7          	jalr	-1630(ra) # 80000b3e <release>
      return -1;
    800021a4:	59fd                	li	s3,-1
}
    800021a6:	854e                	mv	a0,s3
    800021a8:	60a6                	ld	ra,72(sp)
    800021aa:	6406                	ld	s0,64(sp)
    800021ac:	74e2                	ld	s1,56(sp)
    800021ae:	7942                	ld	s2,48(sp)
    800021b0:	79a2                	ld	s3,40(sp)
    800021b2:	7a02                	ld	s4,32(sp)
    800021b4:	6ae2                	ld	s5,24(sp)
    800021b6:	6b42                	ld	s6,16(sp)
    800021b8:	6ba2                	ld	s7,8(sp)
    800021ba:	6161                	addi	sp,sp,80
    800021bc:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800021be:	85ca                	mv	a1,s2
    800021c0:	854a                	mv	a0,s2
    800021c2:	00000097          	auipc	ra,0x0
    800021c6:	e8a080e7          	jalr	-374(ra) # 8000204c <sleep>
    havekids = 0;
    800021ca:	bf25                	j	80002102 <wait+0x38>

00000000800021cc <wakeup>:
{
    800021cc:	7139                	addi	sp,sp,-64
    800021ce:	fc06                	sd	ra,56(sp)
    800021d0:	f822                	sd	s0,48(sp)
    800021d2:	f426                	sd	s1,40(sp)
    800021d4:	f04a                	sd	s2,32(sp)
    800021d6:	ec4e                	sd	s3,24(sp)
    800021d8:	e852                	sd	s4,16(sp)
    800021da:	e456                	sd	s5,8(sp)
    800021dc:	0080                	addi	s0,sp,64
    800021de:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800021e0:	00010497          	auipc	s1,0x10
    800021e4:	b2048493          	addi	s1,s1,-1248 # 80011d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800021e8:	4985                	li	s3,1
      p->state = RUNNABLE;
    800021ea:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800021ec:	00015917          	auipc	s2,0x15
    800021f0:	51490913          	addi	s2,s2,1300 # 80017700 <tickslock>
    800021f4:	a811                	j	80002208 <wakeup+0x3c>
    release(&p->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	946080e7          	jalr	-1722(ra) # 80000b3e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002200:	16848493          	addi	s1,s1,360
    80002204:	03248063          	beq	s1,s2,80002224 <wakeup+0x58>
    acquire(&p->lock);
    80002208:	8526                	mv	a0,s1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	8cc080e7          	jalr	-1844(ra) # 80000ad6 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002212:	4c9c                	lw	a5,24(s1)
    80002214:	ff3791e3          	bne	a5,s3,800021f6 <wakeup+0x2a>
    80002218:	749c                	ld	a5,40(s1)
    8000221a:	fd479ee3          	bne	a5,s4,800021f6 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000221e:	0154ac23          	sw	s5,24(s1)
    80002222:	bfd1                	j	800021f6 <wakeup+0x2a>
}
    80002224:	70e2                	ld	ra,56(sp)
    80002226:	7442                	ld	s0,48(sp)
    80002228:	74a2                	ld	s1,40(sp)
    8000222a:	7902                	ld	s2,32(sp)
    8000222c:	69e2                	ld	s3,24(sp)
    8000222e:	6a42                	ld	s4,16(sp)
    80002230:	6aa2                	ld	s5,8(sp)
    80002232:	6121                	addi	sp,sp,64
    80002234:	8082                	ret

0000000080002236 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002236:	7179                	addi	sp,sp,-48
    80002238:	f406                	sd	ra,40(sp)
    8000223a:	f022                	sd	s0,32(sp)
    8000223c:	ec26                	sd	s1,24(sp)
    8000223e:	e84a                	sd	s2,16(sp)
    80002240:	e44e                	sd	s3,8(sp)
    80002242:	1800                	addi	s0,sp,48
    80002244:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002246:	00010497          	auipc	s1,0x10
    8000224a:	aba48493          	addi	s1,s1,-1350 # 80011d00 <proc>
    8000224e:	00015997          	auipc	s3,0x15
    80002252:	4b298993          	addi	s3,s3,1202 # 80017700 <tickslock>
    acquire(&p->lock);
    80002256:	8526                	mv	a0,s1
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	87e080e7          	jalr	-1922(ra) # 80000ad6 <acquire>
    if(p->pid == pid){
    80002260:	5c9c                	lw	a5,56(s1)
    80002262:	01278d63          	beq	a5,s2,8000227c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002266:	8526                	mv	a0,s1
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	8d6080e7          	jalr	-1834(ra) # 80000b3e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002270:	16848493          	addi	s1,s1,360
    80002274:	ff3491e3          	bne	s1,s3,80002256 <kill+0x20>
  }
  return -1;
    80002278:	557d                	li	a0,-1
    8000227a:	a821                	j	80002292 <kill+0x5c>
      p->killed = 1;
    8000227c:	4785                	li	a5,1
    8000227e:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002280:	4c98                	lw	a4,24(s1)
    80002282:	00f70f63          	beq	a4,a5,800022a0 <kill+0x6a>
      release(&p->lock);
    80002286:	8526                	mv	a0,s1
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	8b6080e7          	jalr	-1866(ra) # 80000b3e <release>
      return 0;
    80002290:	4501                	li	a0,0
}
    80002292:	70a2                	ld	ra,40(sp)
    80002294:	7402                	ld	s0,32(sp)
    80002296:	64e2                	ld	s1,24(sp)
    80002298:	6942                	ld	s2,16(sp)
    8000229a:	69a2                	ld	s3,8(sp)
    8000229c:	6145                	addi	sp,sp,48
    8000229e:	8082                	ret
        p->state = RUNNABLE;
    800022a0:	4789                	li	a5,2
    800022a2:	cc9c                	sw	a5,24(s1)
    800022a4:	b7cd                	j	80002286 <kill+0x50>

00000000800022a6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022a6:	7179                	addi	sp,sp,-48
    800022a8:	f406                	sd	ra,40(sp)
    800022aa:	f022                	sd	s0,32(sp)
    800022ac:	ec26                	sd	s1,24(sp)
    800022ae:	e84a                	sd	s2,16(sp)
    800022b0:	e44e                	sd	s3,8(sp)
    800022b2:	e052                	sd	s4,0(sp)
    800022b4:	1800                	addi	s0,sp,48
    800022b6:	84aa                	mv	s1,a0
    800022b8:	892e                	mv	s2,a1
    800022ba:	89b2                	mv	s3,a2
    800022bc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	578080e7          	jalr	1400(ra) # 80001836 <myproc>
  if(user_dst){
    800022c6:	c08d                	beqz	s1,800022e8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800022c8:	86d2                	mv	a3,s4
    800022ca:	864e                	mv	a2,s3
    800022cc:	85ca                	mv	a1,s2
    800022ce:	6928                	ld	a0,80(a0)
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	28a080e7          	jalr	650(ra) # 8000155a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6942                	ld	s2,16(sp)
    800022e0:	69a2                	ld	s3,8(sp)
    800022e2:	6a02                	ld	s4,0(sp)
    800022e4:	6145                	addi	sp,sp,48
    800022e6:	8082                	ret
    memmove((char *)dst, src, len);
    800022e8:	000a061b          	sext.w	a2,s4
    800022ec:	85ce                	mv	a1,s3
    800022ee:	854a                	mv	a0,s2
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	906080e7          	jalr	-1786(ra) # 80000bf6 <memmove>
    return 0;
    800022f8:	8526                	mv	a0,s1
    800022fa:	bff9                	j	800022d8 <either_copyout+0x32>

00000000800022fc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022fc:	7179                	addi	sp,sp,-48
    800022fe:	f406                	sd	ra,40(sp)
    80002300:	f022                	sd	s0,32(sp)
    80002302:	ec26                	sd	s1,24(sp)
    80002304:	e84a                	sd	s2,16(sp)
    80002306:	e44e                	sd	s3,8(sp)
    80002308:	e052                	sd	s4,0(sp)
    8000230a:	1800                	addi	s0,sp,48
    8000230c:	892a                	mv	s2,a0
    8000230e:	84ae                	mv	s1,a1
    80002310:	89b2                	mv	s3,a2
    80002312:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	522080e7          	jalr	1314(ra) # 80001836 <myproc>
  if(user_src){
    8000231c:	c08d                	beqz	s1,8000233e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000231e:	86d2                	mv	a3,s4
    80002320:	864e                	mv	a2,s3
    80002322:	85ca                	mv	a1,s2
    80002324:	6928                	ld	a0,80(a0)
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	2c6080e7          	jalr	710(ra) # 800015ec <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6942                	ld	s2,16(sp)
    80002336:	69a2                	ld	s3,8(sp)
    80002338:	6a02                	ld	s4,0(sp)
    8000233a:	6145                	addi	sp,sp,48
    8000233c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000233e:	000a061b          	sext.w	a2,s4
    80002342:	85ce                	mv	a1,s3
    80002344:	854a                	mv	a0,s2
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	8b0080e7          	jalr	-1872(ra) # 80000bf6 <memmove>
    return 0;
    8000234e:	8526                	mv	a0,s1
    80002350:	bff9                	j	8000232e <either_copyin+0x32>

0000000080002352 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002352:	715d                	addi	sp,sp,-80
    80002354:	e486                	sd	ra,72(sp)
    80002356:	e0a2                	sd	s0,64(sp)
    80002358:	fc26                	sd	s1,56(sp)
    8000235a:	f84a                	sd	s2,48(sp)
    8000235c:	f44e                	sd	s3,40(sp)
    8000235e:	f052                	sd	s4,32(sp)
    80002360:	ec56                	sd	s5,24(sp)
    80002362:	e85a                	sd	s6,16(sp)
    80002364:	e45e                	sd	s7,8(sp)
    80002366:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002368:	00005517          	auipc	a0,0x5
    8000236c:	e4850513          	addi	a0,a0,-440 # 800071b0 <userret+0x120>
    80002370:	ffffe097          	auipc	ra,0xffffe
    80002374:	222080e7          	jalr	546(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002378:	00010497          	auipc	s1,0x10
    8000237c:	ae048493          	addi	s1,s1,-1312 # 80011e58 <proc+0x158>
    80002380:	00015917          	auipc	s2,0x15
    80002384:	4d890913          	addi	s2,s2,1240 # 80017858 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002388:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000238a:	00005997          	auipc	s3,0x5
    8000238e:	fd698993          	addi	s3,s3,-42 # 80007360 <userret+0x2d0>
    printf("%d %s %s", p->pid, state, p->name);
    80002392:	00005a97          	auipc	s5,0x5
    80002396:	fd6a8a93          	addi	s5,s5,-42 # 80007368 <userret+0x2d8>
    printf("\n");
    8000239a:	00005a17          	auipc	s4,0x5
    8000239e:	e16a0a13          	addi	s4,s4,-490 # 800071b0 <userret+0x120>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023a2:	00005b97          	auipc	s7,0x5
    800023a6:	576b8b93          	addi	s7,s7,1398 # 80007918 <states.0>
    800023aa:	a00d                	j	800023cc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800023ac:	ee06a583          	lw	a1,-288(a3)
    800023b0:	8556                	mv	a0,s5
    800023b2:	ffffe097          	auipc	ra,0xffffe
    800023b6:	1e0080e7          	jalr	480(ra) # 80000592 <printf>
    printf("\n");
    800023ba:	8552                	mv	a0,s4
    800023bc:	ffffe097          	auipc	ra,0xffffe
    800023c0:	1d6080e7          	jalr	470(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800023c4:	16848493          	addi	s1,s1,360
    800023c8:	03248263          	beq	s1,s2,800023ec <procdump+0x9a>
    if(p->state == UNUSED)
    800023cc:	86a6                	mv	a3,s1
    800023ce:	ec04a783          	lw	a5,-320(s1)
    800023d2:	dbed                	beqz	a5,800023c4 <procdump+0x72>
      state = "???";
    800023d4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023d6:	fcfb6be3          	bltu	s6,a5,800023ac <procdump+0x5a>
    800023da:	02079713          	slli	a4,a5,0x20
    800023de:	01d75793          	srli	a5,a4,0x1d
    800023e2:	97de                	add	a5,a5,s7
    800023e4:	6390                	ld	a2,0(a5)
    800023e6:	f279                	bnez	a2,800023ac <procdump+0x5a>
      state = "???";
    800023e8:	864e                	mv	a2,s3
    800023ea:	b7c9                	j	800023ac <procdump+0x5a>
  }
}
    800023ec:	60a6                	ld	ra,72(sp)
    800023ee:	6406                	ld	s0,64(sp)
    800023f0:	74e2                	ld	s1,56(sp)
    800023f2:	7942                	ld	s2,48(sp)
    800023f4:	79a2                	ld	s3,40(sp)
    800023f6:	7a02                	ld	s4,32(sp)
    800023f8:	6ae2                	ld	s5,24(sp)
    800023fa:	6b42                	ld	s6,16(sp)
    800023fc:	6ba2                	ld	s7,8(sp)
    800023fe:	6161                	addi	sp,sp,80
    80002400:	8082                	ret

0000000080002402 <swtch>:
    80002402:	00153023          	sd	ra,0(a0)
    80002406:	00253423          	sd	sp,8(a0)
    8000240a:	e900                	sd	s0,16(a0)
    8000240c:	ed04                	sd	s1,24(a0)
    8000240e:	03253023          	sd	s2,32(a0)
    80002412:	03353423          	sd	s3,40(a0)
    80002416:	03453823          	sd	s4,48(a0)
    8000241a:	03553c23          	sd	s5,56(a0)
    8000241e:	05653023          	sd	s6,64(a0)
    80002422:	05753423          	sd	s7,72(a0)
    80002426:	05853823          	sd	s8,80(a0)
    8000242a:	05953c23          	sd	s9,88(a0)
    8000242e:	07a53023          	sd	s10,96(a0)
    80002432:	07b53423          	sd	s11,104(a0)
    80002436:	0005b083          	ld	ra,0(a1)
    8000243a:	0085b103          	ld	sp,8(a1)
    8000243e:	6980                	ld	s0,16(a1)
    80002440:	6d84                	ld	s1,24(a1)
    80002442:	0205b903          	ld	s2,32(a1)
    80002446:	0285b983          	ld	s3,40(a1)
    8000244a:	0305ba03          	ld	s4,48(a1)
    8000244e:	0385ba83          	ld	s5,56(a1)
    80002452:	0405bb03          	ld	s6,64(a1)
    80002456:	0485bb83          	ld	s7,72(a1)
    8000245a:	0505bc03          	ld	s8,80(a1)
    8000245e:	0585bc83          	ld	s9,88(a1)
    80002462:	0605bd03          	ld	s10,96(a1)
    80002466:	0685bd83          	ld	s11,104(a1)
    8000246a:	8082                	ret

000000008000246c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000246c:	1141                	addi	sp,sp,-16
    8000246e:	e406                	sd	ra,8(sp)
    80002470:	e022                	sd	s0,0(sp)
    80002472:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002474:	00005597          	auipc	a1,0x5
    80002478:	f2c58593          	addi	a1,a1,-212 # 800073a0 <userret+0x310>
    8000247c:	00015517          	auipc	a0,0x15
    80002480:	28450513          	addi	a0,a0,644 # 80017700 <tickslock>
    80002484:	ffffe097          	auipc	ra,0xffffe
    80002488:	544080e7          	jalr	1348(ra) # 800009c8 <initlock>
}
    8000248c:	60a2                	ld	ra,8(sp)
    8000248e:	6402                	ld	s0,0(sp)
    80002490:	0141                	addi	sp,sp,16
    80002492:	8082                	ret

0000000080002494 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002494:	1141                	addi	sp,sp,-16
    80002496:	e422                	sd	s0,8(sp)
    80002498:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249a:	00003797          	auipc	a5,0x3
    8000249e:	76678793          	addi	a5,a5,1894 # 80005c00 <kernelvec>
    800024a2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800024a6:	6422                	ld	s0,8(sp)
    800024a8:	0141                	addi	sp,sp,16
    800024aa:	8082                	ret

00000000800024ac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800024ac:	1141                	addi	sp,sp,-16
    800024ae:	e406                	sd	ra,8(sp)
    800024b0:	e022                	sd	s0,0(sp)
    800024b2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	382080e7          	jalr	898(ra) # 80001836 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024c0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024c2:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send interrupts and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800024c6:	00005617          	auipc	a2,0x5
    800024ca:	b3a60613          	addi	a2,a2,-1222 # 80007000 <trampoline>
    800024ce:	00005697          	auipc	a3,0x5
    800024d2:	b3268693          	addi	a3,a3,-1230 # 80007000 <trampoline>
    800024d6:	8e91                	sub	a3,a3,a2
    800024d8:	040007b7          	lui	a5,0x4000
    800024dc:	17fd                	addi	a5,a5,-1
    800024de:	07b2                	slli	a5,a5,0xc
    800024e0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024e2:	10569073          	csrw	stvec,a3

  // set up values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800024e6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024e8:	180026f3          	csrr	a3,satp
    800024ec:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024ee:	6d38                	ld	a4,88(a0)
    800024f0:	6134                	ld	a3,64(a0)
    800024f2:	6585                	lui	a1,0x1
    800024f4:	96ae                	add	a3,a3,a1
    800024f6:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    800024f8:	6d38                	ld	a4,88(a0)
    800024fa:	00000697          	auipc	a3,0x0
    800024fe:	12868693          	addi	a3,a3,296 # 80002622 <usertrap>
    80002502:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    80002504:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002506:	8692                	mv	a3,tp
    80002508:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000250a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000250e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002512:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002516:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    8000251a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000251c:	6f18                	ld	a4,24(a4)
    8000251e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002522:	692c                	ld	a1,80(a0)
    80002524:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002526:	00005717          	auipc	a4,0x5
    8000252a:	b6a70713          	addi	a4,a4,-1174 # 80007090 <userret>
    8000252e:	8f11                	sub	a4,a4,a2
    80002530:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002532:	577d                	li	a4,-1
    80002534:	177e                	slli	a4,a4,0x3f
    80002536:	8dd9                	or	a1,a1,a4
    80002538:	02000537          	lui	a0,0x2000
    8000253c:	157d                	addi	a0,a0,-1
    8000253e:	0536                	slli	a0,a0,0xd
    80002540:	9782                	jalr	a5
}
    80002542:	60a2                	ld	ra,8(sp)
    80002544:	6402                	ld	s0,0(sp)
    80002546:	0141                	addi	sp,sp,16
    80002548:	8082                	ret

000000008000254a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000254a:	1101                	addi	sp,sp,-32
    8000254c:	ec06                	sd	ra,24(sp)
    8000254e:	e822                	sd	s0,16(sp)
    80002550:	e426                	sd	s1,8(sp)
    80002552:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002554:	00015497          	auipc	s1,0x15
    80002558:	1ac48493          	addi	s1,s1,428 # 80017700 <tickslock>
    8000255c:	8526                	mv	a0,s1
    8000255e:	ffffe097          	auipc	ra,0xffffe
    80002562:	578080e7          	jalr	1400(ra) # 80000ad6 <acquire>
  ticks++;
    80002566:	00027517          	auipc	a0,0x27
    8000256a:	ada50513          	addi	a0,a0,-1318 # 80029040 <ticks>
    8000256e:	411c                	lw	a5,0(a0)
    80002570:	2785                	addiw	a5,a5,1
    80002572:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002574:	00000097          	auipc	ra,0x0
    80002578:	c58080e7          	jalr	-936(ra) # 800021cc <wakeup>
  release(&tickslock);
    8000257c:	8526                	mv	a0,s1
    8000257e:	ffffe097          	auipc	ra,0xffffe
    80002582:	5c0080e7          	jalr	1472(ra) # 80000b3e <release>
}
    80002586:	60e2                	ld	ra,24(sp)
    80002588:	6442                	ld	s0,16(sp)
    8000258a:	64a2                	ld	s1,8(sp)
    8000258c:	6105                	addi	sp,sp,32
    8000258e:	8082                	ret

0000000080002590 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002590:	1101                	addi	sp,sp,-32
    80002592:	ec06                	sd	ra,24(sp)
    80002594:	e822                	sd	s0,16(sp)
    80002596:	e426                	sd	s1,8(sp)
    80002598:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000259a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000259e:	00074d63          	bltz	a4,800025b8 <devintr+0x28>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    800025a2:	57fd                	li	a5,-1
    800025a4:	17fe                	slli	a5,a5,0x3f
    800025a6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800025a8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800025aa:	04f70b63          	beq	a4,a5,80002600 <devintr+0x70>
  }
}
    800025ae:	60e2                	ld	ra,24(sp)
    800025b0:	6442                	ld	s0,16(sp)
    800025b2:	64a2                	ld	s1,8(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret
     (scause & 0xff) == 9){
    800025b8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800025bc:	46a5                	li	a3,9
    800025be:	fed792e3          	bne	a5,a3,800025a2 <devintr+0x12>
    int irq = plic_claim();
    800025c2:	00003097          	auipc	ra,0x3
    800025c6:	758080e7          	jalr	1880(ra) # 80005d1a <plic_claim>
    800025ca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025cc:	47a9                	li	a5,10
    800025ce:	00f50e63          	beq	a0,a5,800025ea <devintr+0x5a>
    } else if(irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ ){
    800025d2:	fff5079b          	addiw	a5,a0,-1
    800025d6:	4705                	li	a4,1
    800025d8:	00f77e63          	bgeu	a4,a5,800025f4 <devintr+0x64>
    plic_complete(irq);
    800025dc:	8526                	mv	a0,s1
    800025de:	00003097          	auipc	ra,0x3
    800025e2:	760080e7          	jalr	1888(ra) # 80005d3e <plic_complete>
    return 1;
    800025e6:	4505                	li	a0,1
    800025e8:	b7d9                	j	800025ae <devintr+0x1e>
      uartintr();
    800025ea:	ffffe097          	auipc	ra,0xffffe
    800025ee:	23e080e7          	jalr	574(ra) # 80000828 <uartintr>
    800025f2:	b7ed                	j	800025dc <devintr+0x4c>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    800025f4:	853e                	mv	a0,a5
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	cf2080e7          	jalr	-782(ra) # 800062e8 <virtio_disk_intr>
    800025fe:	bff9                	j	800025dc <devintr+0x4c>
    if(cpuid() == 0){
    80002600:	fffff097          	auipc	ra,0xfffff
    80002604:	20a080e7          	jalr	522(ra) # 8000180a <cpuid>
    80002608:	c901                	beqz	a0,80002618 <devintr+0x88>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000260a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000260e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002610:	14479073          	csrw	sip,a5
    return 2;
    80002614:	4509                	li	a0,2
    80002616:	bf61                	j	800025ae <devintr+0x1e>
      clockintr();
    80002618:	00000097          	auipc	ra,0x0
    8000261c:	f32080e7          	jalr	-206(ra) # 8000254a <clockintr>
    80002620:	b7ed                	j	8000260a <devintr+0x7a>

0000000080002622 <usertrap>:
{
    80002622:	1101                	addi	sp,sp,-32
    80002624:	ec06                	sd	ra,24(sp)
    80002626:	e822                	sd	s0,16(sp)
    80002628:	e426                	sd	s1,8(sp)
    8000262a:	e04a                	sd	s2,0(sp)
    8000262c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002632:	1007f793          	andi	a5,a5,256
    80002636:	e7bd                	bnez	a5,800026a4 <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002638:	00003797          	auipc	a5,0x3
    8000263c:	5c878793          	addi	a5,a5,1480 # 80005c00 <kernelvec>
    80002640:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002644:	fffff097          	auipc	ra,0xfffff
    80002648:	1f2080e7          	jalr	498(ra) # 80001836 <myproc>
    8000264c:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    8000264e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002650:	14102773          	csrr	a4,sepc
    80002654:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002656:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000265a:	47a1                	li	a5,8
    8000265c:	06f71263          	bne	a4,a5,800026c0 <usertrap+0x9e>
    if(p->killed)
    80002660:	591c                	lw	a5,48(a0)
    80002662:	eba9                	bnez	a5,800026b4 <usertrap+0x92>
    p->tf->epc += 4;
    80002664:	6cb8                	ld	a4,88(s1)
    80002666:	6f1c                	ld	a5,24(a4)
    80002668:	0791                	addi	a5,a5,4
    8000266a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000266c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002670:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80002674:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002678:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000267c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002680:	10079073          	csrw	sstatus,a5
    syscall();
    80002684:	00000097          	auipc	ra,0x0
    80002688:	2e0080e7          	jalr	736(ra) # 80002964 <syscall>
  if(p->killed)
    8000268c:	589c                	lw	a5,48(s1)
    8000268e:	ebc1                	bnez	a5,8000271e <usertrap+0xfc>
  usertrapret();
    80002690:	00000097          	auipc	ra,0x0
    80002694:	e1c080e7          	jalr	-484(ra) # 800024ac <usertrapret>
}
    80002698:	60e2                	ld	ra,24(sp)
    8000269a:	6442                	ld	s0,16(sp)
    8000269c:	64a2                	ld	s1,8(sp)
    8000269e:	6902                	ld	s2,0(sp)
    800026a0:	6105                	addi	sp,sp,32
    800026a2:	8082                	ret
    panic("usertrap: not from user mode");
    800026a4:	00005517          	auipc	a0,0x5
    800026a8:	d0450513          	addi	a0,a0,-764 # 800073a8 <userret+0x318>
    800026ac:	ffffe097          	auipc	ra,0xffffe
    800026b0:	e9c080e7          	jalr	-356(ra) # 80000548 <panic>
      exit(-1);
    800026b4:	557d                	li	a0,-1
    800026b6:	00000097          	auipc	ra,0x0
    800026ba:	874080e7          	jalr	-1932(ra) # 80001f2a <exit>
    800026be:	b75d                	j	80002664 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800026c0:	00000097          	auipc	ra,0x0
    800026c4:	ed0080e7          	jalr	-304(ra) # 80002590 <devintr>
    800026c8:	892a                	mv	s2,a0
    800026ca:	c501                	beqz	a0,800026d2 <usertrap+0xb0>
  if(p->killed)
    800026cc:	589c                	lw	a5,48(s1)
    800026ce:	c3a1                	beqz	a5,8000270e <usertrap+0xec>
    800026d0:	a815                	j	80002704 <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026d2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800026d6:	5c90                	lw	a2,56(s1)
    800026d8:	00005517          	auipc	a0,0x5
    800026dc:	cf050513          	addi	a0,a0,-784 # 800073c8 <userret+0x338>
    800026e0:	ffffe097          	auipc	ra,0xffffe
    800026e4:	eb2080e7          	jalr	-334(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026e8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026ec:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800026f0:	00005517          	auipc	a0,0x5
    800026f4:	d0850513          	addi	a0,a0,-760 # 800073f8 <userret+0x368>
    800026f8:	ffffe097          	auipc	ra,0xffffe
    800026fc:	e9a080e7          	jalr	-358(ra) # 80000592 <printf>
    p->killed = 1;
    80002700:	4785                	li	a5,1
    80002702:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002704:	557d                	li	a0,-1
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	824080e7          	jalr	-2012(ra) # 80001f2a <exit>
  if(which_dev == 2)
    8000270e:	4789                	li	a5,2
    80002710:	f8f910e3          	bne	s2,a5,80002690 <usertrap+0x6e>
    yield();
    80002714:	00000097          	auipc	ra,0x0
    80002718:	8fc080e7          	jalr	-1796(ra) # 80002010 <yield>
    8000271c:	bf95                	j	80002690 <usertrap+0x6e>
  int which_dev = 0;
    8000271e:	4901                	li	s2,0
    80002720:	b7d5                	j	80002704 <usertrap+0xe2>

0000000080002722 <kerneltrap>:
{
    80002722:	7179                	addi	sp,sp,-48
    80002724:	f406                	sd	ra,40(sp)
    80002726:	f022                	sd	s0,32(sp)
    80002728:	ec26                	sd	s1,24(sp)
    8000272a:	e84a                	sd	s2,16(sp)
    8000272c:	e44e                	sd	s3,8(sp)
    8000272e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002730:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002734:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002738:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000273c:	1004f793          	andi	a5,s1,256
    80002740:	cb85                	beqz	a5,80002770 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002742:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002746:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002748:	ef85                	bnez	a5,80002780 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	e46080e7          	jalr	-442(ra) # 80002590 <devintr>
    80002752:	cd1d                	beqz	a0,80002790 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002754:	4789                	li	a5,2
    80002756:	06f50a63          	beq	a0,a5,800027ca <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000275a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000275e:	10049073          	csrw	sstatus,s1
}
    80002762:	70a2                	ld	ra,40(sp)
    80002764:	7402                	ld	s0,32(sp)
    80002766:	64e2                	ld	s1,24(sp)
    80002768:	6942                	ld	s2,16(sp)
    8000276a:	69a2                	ld	s3,8(sp)
    8000276c:	6145                	addi	sp,sp,48
    8000276e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002770:	00005517          	auipc	a0,0x5
    80002774:	ca850513          	addi	a0,a0,-856 # 80007418 <userret+0x388>
    80002778:	ffffe097          	auipc	ra,0xffffe
    8000277c:	dd0080e7          	jalr	-560(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    80002780:	00005517          	auipc	a0,0x5
    80002784:	cc050513          	addi	a0,a0,-832 # 80007440 <userret+0x3b0>
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	dc0080e7          	jalr	-576(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    80002790:	85ce                	mv	a1,s3
    80002792:	00005517          	auipc	a0,0x5
    80002796:	cce50513          	addi	a0,a0,-818 # 80007460 <userret+0x3d0>
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	df8080e7          	jalr	-520(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027a2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027a6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	cc650513          	addi	a0,a0,-826 # 80007470 <userret+0x3e0>
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	de0080e7          	jalr	-544(ra) # 80000592 <printf>
    panic("kerneltrap");
    800027ba:	00005517          	auipc	a0,0x5
    800027be:	cce50513          	addi	a0,a0,-818 # 80007488 <userret+0x3f8>
    800027c2:	ffffe097          	auipc	ra,0xffffe
    800027c6:	d86080e7          	jalr	-634(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800027ca:	fffff097          	auipc	ra,0xfffff
    800027ce:	06c080e7          	jalr	108(ra) # 80001836 <myproc>
    800027d2:	d541                	beqz	a0,8000275a <kerneltrap+0x38>
    800027d4:	fffff097          	auipc	ra,0xfffff
    800027d8:	062080e7          	jalr	98(ra) # 80001836 <myproc>
    800027dc:	4d18                	lw	a4,24(a0)
    800027de:	478d                	li	a5,3
    800027e0:	f6f71de3          	bne	a4,a5,8000275a <kerneltrap+0x38>
    yield();
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	82c080e7          	jalr	-2004(ra) # 80002010 <yield>
    800027ec:	b7bd                	j	8000275a <kerneltrap+0x38>

00000000800027ee <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027fa:	fffff097          	auipc	ra,0xfffff
    800027fe:	03c080e7          	jalr	60(ra) # 80001836 <myproc>
  switch (n) {
    80002802:	4795                	li	a5,5
    80002804:	0497e163          	bltu	a5,s1,80002846 <argraw+0x58>
    80002808:	048a                	slli	s1,s1,0x2
    8000280a:	00005717          	auipc	a4,0x5
    8000280e:	13670713          	addi	a4,a4,310 # 80007940 <states.0+0x28>
    80002812:	94ba                	add	s1,s1,a4
    80002814:	409c                	lw	a5,0(s1)
    80002816:	97ba                	add	a5,a5,a4
    80002818:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    8000281a:	6d3c                	ld	a5,88(a0)
    8000281c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    8000281e:	60e2                	ld	ra,24(sp)
    80002820:	6442                	ld	s0,16(sp)
    80002822:	64a2                	ld	s1,8(sp)
    80002824:	6105                	addi	sp,sp,32
    80002826:	8082                	ret
    return p->tf->a1;
    80002828:	6d3c                	ld	a5,88(a0)
    8000282a:	7fa8                	ld	a0,120(a5)
    8000282c:	bfcd                	j	8000281e <argraw+0x30>
    return p->tf->a2;
    8000282e:	6d3c                	ld	a5,88(a0)
    80002830:	63c8                	ld	a0,128(a5)
    80002832:	b7f5                	j	8000281e <argraw+0x30>
    return p->tf->a3;
    80002834:	6d3c                	ld	a5,88(a0)
    80002836:	67c8                	ld	a0,136(a5)
    80002838:	b7dd                	j	8000281e <argraw+0x30>
    return p->tf->a4;
    8000283a:	6d3c                	ld	a5,88(a0)
    8000283c:	6bc8                	ld	a0,144(a5)
    8000283e:	b7c5                	j	8000281e <argraw+0x30>
    return p->tf->a5;
    80002840:	6d3c                	ld	a5,88(a0)
    80002842:	6fc8                	ld	a0,152(a5)
    80002844:	bfe9                	j	8000281e <argraw+0x30>
  panic("argraw");
    80002846:	00005517          	auipc	a0,0x5
    8000284a:	c5250513          	addi	a0,a0,-942 # 80007498 <userret+0x408>
    8000284e:	ffffe097          	auipc	ra,0xffffe
    80002852:	cfa080e7          	jalr	-774(ra) # 80000548 <panic>

0000000080002856 <fetchaddr>:
{
    80002856:	1101                	addi	sp,sp,-32
    80002858:	ec06                	sd	ra,24(sp)
    8000285a:	e822                	sd	s0,16(sp)
    8000285c:	e426                	sd	s1,8(sp)
    8000285e:	e04a                	sd	s2,0(sp)
    80002860:	1000                	addi	s0,sp,32
    80002862:	84aa                	mv	s1,a0
    80002864:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	fd0080e7          	jalr	-48(ra) # 80001836 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000286e:	653c                	ld	a5,72(a0)
    80002870:	02f4f863          	bgeu	s1,a5,800028a0 <fetchaddr+0x4a>
    80002874:	00848713          	addi	a4,s1,8
    80002878:	02e7e663          	bltu	a5,a4,800028a4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000287c:	46a1                	li	a3,8
    8000287e:	8626                	mv	a2,s1
    80002880:	85ca                	mv	a1,s2
    80002882:	6928                	ld	a0,80(a0)
    80002884:	fffff097          	auipc	ra,0xfffff
    80002888:	d68080e7          	jalr	-664(ra) # 800015ec <copyin>
    8000288c:	00a03533          	snez	a0,a0
    80002890:	40a00533          	neg	a0,a0
}
    80002894:	60e2                	ld	ra,24(sp)
    80002896:	6442                	ld	s0,16(sp)
    80002898:	64a2                	ld	s1,8(sp)
    8000289a:	6902                	ld	s2,0(sp)
    8000289c:	6105                	addi	sp,sp,32
    8000289e:	8082                	ret
    return -1;
    800028a0:	557d                	li	a0,-1
    800028a2:	bfcd                	j	80002894 <fetchaddr+0x3e>
    800028a4:	557d                	li	a0,-1
    800028a6:	b7fd                	j	80002894 <fetchaddr+0x3e>

00000000800028a8 <fetchstr>:
{
    800028a8:	7179                	addi	sp,sp,-48
    800028aa:	f406                	sd	ra,40(sp)
    800028ac:	f022                	sd	s0,32(sp)
    800028ae:	ec26                	sd	s1,24(sp)
    800028b0:	e84a                	sd	s2,16(sp)
    800028b2:	e44e                	sd	s3,8(sp)
    800028b4:	1800                	addi	s0,sp,48
    800028b6:	892a                	mv	s2,a0
    800028b8:	84ae                	mv	s1,a1
    800028ba:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800028bc:	fffff097          	auipc	ra,0xfffff
    800028c0:	f7a080e7          	jalr	-134(ra) # 80001836 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800028c4:	86ce                	mv	a3,s3
    800028c6:	864a                	mv	a2,s2
    800028c8:	85a6                	mv	a1,s1
    800028ca:	6928                	ld	a0,80(a0)
    800028cc:	fffff097          	auipc	ra,0xfffff
    800028d0:	db4080e7          	jalr	-588(ra) # 80001680 <copyinstr>
  if(err < 0)
    800028d4:	00054763          	bltz	a0,800028e2 <fetchstr+0x3a>
  return strlen(buf);
    800028d8:	8526                	mv	a0,s1
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	444080e7          	jalr	1092(ra) # 80000d1e <strlen>
}
    800028e2:	70a2                	ld	ra,40(sp)
    800028e4:	7402                	ld	s0,32(sp)
    800028e6:	64e2                	ld	s1,24(sp)
    800028e8:	6942                	ld	s2,16(sp)
    800028ea:	69a2                	ld	s3,8(sp)
    800028ec:	6145                	addi	sp,sp,48
    800028ee:	8082                	ret

00000000800028f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800028f0:	1101                	addi	sp,sp,-32
    800028f2:	ec06                	sd	ra,24(sp)
    800028f4:	e822                	sd	s0,16(sp)
    800028f6:	e426                	sd	s1,8(sp)
    800028f8:	1000                	addi	s0,sp,32
    800028fa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	ef2080e7          	jalr	-270(ra) # 800027ee <argraw>
    80002904:	c088                	sw	a0,0(s1)
  return 0;
}
    80002906:	4501                	li	a0,0
    80002908:	60e2                	ld	ra,24(sp)
    8000290a:	6442                	ld	s0,16(sp)
    8000290c:	64a2                	ld	s1,8(sp)
    8000290e:	6105                	addi	sp,sp,32
    80002910:	8082                	ret

0000000080002912 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002912:	1101                	addi	sp,sp,-32
    80002914:	ec06                	sd	ra,24(sp)
    80002916:	e822                	sd	s0,16(sp)
    80002918:	e426                	sd	s1,8(sp)
    8000291a:	1000                	addi	s0,sp,32
    8000291c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	ed0080e7          	jalr	-304(ra) # 800027ee <argraw>
    80002926:	e088                	sd	a0,0(s1)
  return 0;
}
    80002928:	4501                	li	a0,0
    8000292a:	60e2                	ld	ra,24(sp)
    8000292c:	6442                	ld	s0,16(sp)
    8000292e:	64a2                	ld	s1,8(sp)
    80002930:	6105                	addi	sp,sp,32
    80002932:	8082                	ret

0000000080002934 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002934:	1101                	addi	sp,sp,-32
    80002936:	ec06                	sd	ra,24(sp)
    80002938:	e822                	sd	s0,16(sp)
    8000293a:	e426                	sd	s1,8(sp)
    8000293c:	e04a                	sd	s2,0(sp)
    8000293e:	1000                	addi	s0,sp,32
    80002940:	84ae                	mv	s1,a1
    80002942:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002944:	00000097          	auipc	ra,0x0
    80002948:	eaa080e7          	jalr	-342(ra) # 800027ee <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000294c:	864a                	mv	a2,s2
    8000294e:	85a6                	mv	a1,s1
    80002950:	00000097          	auipc	ra,0x0
    80002954:	f58080e7          	jalr	-168(ra) # 800028a8 <fetchstr>
}
    80002958:	60e2                	ld	ra,24(sp)
    8000295a:	6442                	ld	s0,16(sp)
    8000295c:	64a2                	ld	s1,8(sp)
    8000295e:	6902                	ld	s2,0(sp)
    80002960:	6105                	addi	sp,sp,32
    80002962:	8082                	ret

0000000080002964 <syscall>:
[SYS_crash]   sys_crash,
};

void
syscall(void)
{
    80002964:	1101                	addi	sp,sp,-32
    80002966:	ec06                	sd	ra,24(sp)
    80002968:	e822                	sd	s0,16(sp)
    8000296a:	e426                	sd	s1,8(sp)
    8000296c:	e04a                	sd	s2,0(sp)
    8000296e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002970:	fffff097          	auipc	ra,0xfffff
    80002974:	ec6080e7          	jalr	-314(ra) # 80001836 <myproc>
    80002978:	84aa                	mv	s1,a0

  num = p->tf->a7;
    8000297a:	05853903          	ld	s2,88(a0)
    8000297e:	0a893783          	ld	a5,168(s2)
    80002982:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002986:	37fd                	addiw	a5,a5,-1
    80002988:	4759                	li	a4,22
    8000298a:	00f76f63          	bltu	a4,a5,800029a8 <syscall+0x44>
    8000298e:	00369713          	slli	a4,a3,0x3
    80002992:	00005797          	auipc	a5,0x5
    80002996:	fc678793          	addi	a5,a5,-58 # 80007958 <syscalls>
    8000299a:	97ba                	add	a5,a5,a4
    8000299c:	639c                	ld	a5,0(a5)
    8000299e:	c789                	beqz	a5,800029a8 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    800029a0:	9782                	jalr	a5
    800029a2:	06a93823          	sd	a0,112(s2)
    800029a6:	a839                	j	800029c4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800029a8:	15848613          	addi	a2,s1,344
    800029ac:	5c8c                	lw	a1,56(s1)
    800029ae:	00005517          	auipc	a0,0x5
    800029b2:	af250513          	addi	a0,a0,-1294 # 800074a0 <userret+0x410>
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	bdc080e7          	jalr	-1060(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    800029be:	6cbc                	ld	a5,88(s1)
    800029c0:	577d                	li	a4,-1
    800029c2:	fbb8                	sd	a4,112(a5)
  }
}
    800029c4:	60e2                	ld	ra,24(sp)
    800029c6:	6442                	ld	s0,16(sp)
    800029c8:	64a2                	ld	s1,8(sp)
    800029ca:	6902                	ld	s2,0(sp)
    800029cc:	6105                	addi	sp,sp,32
    800029ce:	8082                	ret

00000000800029d0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800029d0:	1101                	addi	sp,sp,-32
    800029d2:	ec06                	sd	ra,24(sp)
    800029d4:	e822                	sd	s0,16(sp)
    800029d6:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800029d8:	fec40593          	addi	a1,s0,-20
    800029dc:	4501                	li	a0,0
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	f12080e7          	jalr	-238(ra) # 800028f0 <argint>
    return -1;
    800029e6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800029e8:	00054963          	bltz	a0,800029fa <sys_exit+0x2a>
  exit(n);
    800029ec:	fec42503          	lw	a0,-20(s0)
    800029f0:	fffff097          	auipc	ra,0xfffff
    800029f4:	53a080e7          	jalr	1338(ra) # 80001f2a <exit>
  return 0;  // not reached
    800029f8:	4781                	li	a5,0
}
    800029fa:	853e                	mv	a0,a5
    800029fc:	60e2                	ld	ra,24(sp)
    800029fe:	6442                	ld	s0,16(sp)
    80002a00:	6105                	addi	sp,sp,32
    80002a02:	8082                	ret

0000000080002a04 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a04:	1141                	addi	sp,sp,-16
    80002a06:	e406                	sd	ra,8(sp)
    80002a08:	e022                	sd	s0,0(sp)
    80002a0a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a0c:	fffff097          	auipc	ra,0xfffff
    80002a10:	e2a080e7          	jalr	-470(ra) # 80001836 <myproc>
}
    80002a14:	5d08                	lw	a0,56(a0)
    80002a16:	60a2                	ld	ra,8(sp)
    80002a18:	6402                	ld	s0,0(sp)
    80002a1a:	0141                	addi	sp,sp,16
    80002a1c:	8082                	ret

0000000080002a1e <sys_fork>:

uint64
sys_fork(void)
{
    80002a1e:	1141                	addi	sp,sp,-16
    80002a20:	e406                	sd	ra,8(sp)
    80002a22:	e022                	sd	s0,0(sp)
    80002a24:	0800                	addi	s0,sp,16
  return fork();
    80002a26:	fffff097          	auipc	ra,0xfffff
    80002a2a:	17e080e7          	jalr	382(ra) # 80001ba4 <fork>
}
    80002a2e:	60a2                	ld	ra,8(sp)
    80002a30:	6402                	ld	s0,0(sp)
    80002a32:	0141                	addi	sp,sp,16
    80002a34:	8082                	ret

0000000080002a36 <sys_wait>:

uint64
sys_wait(void)
{
    80002a36:	1101                	addi	sp,sp,-32
    80002a38:	ec06                	sd	ra,24(sp)
    80002a3a:	e822                	sd	s0,16(sp)
    80002a3c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002a3e:	fe840593          	addi	a1,s0,-24
    80002a42:	4501                	li	a0,0
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	ece080e7          	jalr	-306(ra) # 80002912 <argaddr>
    80002a4c:	87aa                	mv	a5,a0
    return -1;
    80002a4e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002a50:	0007c863          	bltz	a5,80002a60 <sys_wait+0x2a>
  return wait(p);
    80002a54:	fe843503          	ld	a0,-24(s0)
    80002a58:	fffff097          	auipc	ra,0xfffff
    80002a5c:	672080e7          	jalr	1650(ra) # 800020ca <wait>
}
    80002a60:	60e2                	ld	ra,24(sp)
    80002a62:	6442                	ld	s0,16(sp)
    80002a64:	6105                	addi	sp,sp,32
    80002a66:	8082                	ret

0000000080002a68 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a68:	7179                	addi	sp,sp,-48
    80002a6a:	f406                	sd	ra,40(sp)
    80002a6c:	f022                	sd	s0,32(sp)
    80002a6e:	ec26                	sd	s1,24(sp)
    80002a70:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002a72:	fdc40593          	addi	a1,s0,-36
    80002a76:	4501                	li	a0,0
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	e78080e7          	jalr	-392(ra) # 800028f0 <argint>
    return -1;
    80002a80:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002a82:	00054f63          	bltz	a0,80002aa0 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002a86:	fffff097          	auipc	ra,0xfffff
    80002a8a:	db0080e7          	jalr	-592(ra) # 80001836 <myproc>
    80002a8e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002a90:	fdc42503          	lw	a0,-36(s0)
    80002a94:	fffff097          	auipc	ra,0xfffff
    80002a98:	098080e7          	jalr	152(ra) # 80001b2c <growproc>
    80002a9c:	00054863          	bltz	a0,80002aac <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002aa0:	8526                	mv	a0,s1
    80002aa2:	70a2                	ld	ra,40(sp)
    80002aa4:	7402                	ld	s0,32(sp)
    80002aa6:	64e2                	ld	s1,24(sp)
    80002aa8:	6145                	addi	sp,sp,48
    80002aaa:	8082                	ret
    return -1;
    80002aac:	54fd                	li	s1,-1
    80002aae:	bfcd                	j	80002aa0 <sys_sbrk+0x38>

0000000080002ab0 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002ab0:	7139                	addi	sp,sp,-64
    80002ab2:	fc06                	sd	ra,56(sp)
    80002ab4:	f822                	sd	s0,48(sp)
    80002ab6:	f426                	sd	s1,40(sp)
    80002ab8:	f04a                	sd	s2,32(sp)
    80002aba:	ec4e                	sd	s3,24(sp)
    80002abc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002abe:	fcc40593          	addi	a1,s0,-52
    80002ac2:	4501                	li	a0,0
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	e2c080e7          	jalr	-468(ra) # 800028f0 <argint>
    return -1;
    80002acc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002ace:	06054563          	bltz	a0,80002b38 <sys_sleep+0x88>
  acquire(&tickslock);
    80002ad2:	00015517          	auipc	a0,0x15
    80002ad6:	c2e50513          	addi	a0,a0,-978 # 80017700 <tickslock>
    80002ada:	ffffe097          	auipc	ra,0xffffe
    80002ade:	ffc080e7          	jalr	-4(ra) # 80000ad6 <acquire>
  ticks0 = ticks;
    80002ae2:	00026917          	auipc	s2,0x26
    80002ae6:	55e92903          	lw	s2,1374(s2) # 80029040 <ticks>
  while(ticks - ticks0 < n){
    80002aea:	fcc42783          	lw	a5,-52(s0)
    80002aee:	cf85                	beqz	a5,80002b26 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002af0:	00015997          	auipc	s3,0x15
    80002af4:	c1098993          	addi	s3,s3,-1008 # 80017700 <tickslock>
    80002af8:	00026497          	auipc	s1,0x26
    80002afc:	54848493          	addi	s1,s1,1352 # 80029040 <ticks>
    if(myproc()->killed){
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	d36080e7          	jalr	-714(ra) # 80001836 <myproc>
    80002b08:	591c                	lw	a5,48(a0)
    80002b0a:	ef9d                	bnez	a5,80002b48 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002b0c:	85ce                	mv	a1,s3
    80002b0e:	8526                	mv	a0,s1
    80002b10:	fffff097          	auipc	ra,0xfffff
    80002b14:	53c080e7          	jalr	1340(ra) # 8000204c <sleep>
  while(ticks - ticks0 < n){
    80002b18:	409c                	lw	a5,0(s1)
    80002b1a:	412787bb          	subw	a5,a5,s2
    80002b1e:	fcc42703          	lw	a4,-52(s0)
    80002b22:	fce7efe3          	bltu	a5,a4,80002b00 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002b26:	00015517          	auipc	a0,0x15
    80002b2a:	bda50513          	addi	a0,a0,-1062 # 80017700 <tickslock>
    80002b2e:	ffffe097          	auipc	ra,0xffffe
    80002b32:	010080e7          	jalr	16(ra) # 80000b3e <release>
  return 0;
    80002b36:	4781                	li	a5,0
}
    80002b38:	853e                	mv	a0,a5
    80002b3a:	70e2                	ld	ra,56(sp)
    80002b3c:	7442                	ld	s0,48(sp)
    80002b3e:	74a2                	ld	s1,40(sp)
    80002b40:	7902                	ld	s2,32(sp)
    80002b42:	69e2                	ld	s3,24(sp)
    80002b44:	6121                	addi	sp,sp,64
    80002b46:	8082                	ret
      release(&tickslock);
    80002b48:	00015517          	auipc	a0,0x15
    80002b4c:	bb850513          	addi	a0,a0,-1096 # 80017700 <tickslock>
    80002b50:	ffffe097          	auipc	ra,0xffffe
    80002b54:	fee080e7          	jalr	-18(ra) # 80000b3e <release>
      return -1;
    80002b58:	57fd                	li	a5,-1
    80002b5a:	bff9                	j	80002b38 <sys_sleep+0x88>

0000000080002b5c <sys_kill>:

uint64
sys_kill(void)
{
    80002b5c:	1101                	addi	sp,sp,-32
    80002b5e:	ec06                	sd	ra,24(sp)
    80002b60:	e822                	sd	s0,16(sp)
    80002b62:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002b64:	fec40593          	addi	a1,s0,-20
    80002b68:	4501                	li	a0,0
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	d86080e7          	jalr	-634(ra) # 800028f0 <argint>
    80002b72:	87aa                	mv	a5,a0
    return -1;
    80002b74:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002b76:	0007c863          	bltz	a5,80002b86 <sys_kill+0x2a>
  return kill(pid);
    80002b7a:	fec42503          	lw	a0,-20(s0)
    80002b7e:	fffff097          	auipc	ra,0xfffff
    80002b82:	6b8080e7          	jalr	1720(ra) # 80002236 <kill>
}
    80002b86:	60e2                	ld	ra,24(sp)
    80002b88:	6442                	ld	s0,16(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b98:	00015517          	auipc	a0,0x15
    80002b9c:	b6850513          	addi	a0,a0,-1176 # 80017700 <tickslock>
    80002ba0:	ffffe097          	auipc	ra,0xffffe
    80002ba4:	f36080e7          	jalr	-202(ra) # 80000ad6 <acquire>
  xticks = ticks;
    80002ba8:	00026497          	auipc	s1,0x26
    80002bac:	4984a483          	lw	s1,1176(s1) # 80029040 <ticks>
  release(&tickslock);
    80002bb0:	00015517          	auipc	a0,0x15
    80002bb4:	b5050513          	addi	a0,a0,-1200 # 80017700 <tickslock>
    80002bb8:	ffffe097          	auipc	ra,0xffffe
    80002bbc:	f86080e7          	jalr	-122(ra) # 80000b3e <release>
  return xticks;
}
    80002bc0:	02049513          	slli	a0,s1,0x20
    80002bc4:	9101                	srli	a0,a0,0x20
    80002bc6:	60e2                	ld	ra,24(sp)
    80002bc8:	6442                	ld	s0,16(sp)
    80002bca:	64a2                	ld	s1,8(sp)
    80002bcc:	6105                	addi	sp,sp,32
    80002bce:	8082                	ret

0000000080002bd0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002bd0:	7179                	addi	sp,sp,-48
    80002bd2:	f406                	sd	ra,40(sp)
    80002bd4:	f022                	sd	s0,32(sp)
    80002bd6:	ec26                	sd	s1,24(sp)
    80002bd8:	e84a                	sd	s2,16(sp)
    80002bda:	e44e                	sd	s3,8(sp)
    80002bdc:	e052                	sd	s4,0(sp)
    80002bde:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002be0:	00005597          	auipc	a1,0x5
    80002be4:	8e058593          	addi	a1,a1,-1824 # 800074c0 <userret+0x430>
    80002be8:	00015517          	auipc	a0,0x15
    80002bec:	b3050513          	addi	a0,a0,-1232 # 80017718 <bcache>
    80002bf0:	ffffe097          	auipc	ra,0xffffe
    80002bf4:	dd8080e7          	jalr	-552(ra) # 800009c8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002bf8:	0001d797          	auipc	a5,0x1d
    80002bfc:	b2078793          	addi	a5,a5,-1248 # 8001f718 <bcache+0x8000>
    80002c00:	0001d717          	auipc	a4,0x1d
    80002c04:	e7070713          	addi	a4,a4,-400 # 8001fa70 <bcache+0x8358>
    80002c08:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002c0c:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c10:	00015497          	auipc	s1,0x15
    80002c14:	b2048493          	addi	s1,s1,-1248 # 80017730 <bcache+0x18>
    b->next = bcache.head.next;
    80002c18:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c1a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c1c:	00005a17          	auipc	s4,0x5
    80002c20:	8aca0a13          	addi	s4,s4,-1876 # 800074c8 <userret+0x438>
    b->next = bcache.head.next;
    80002c24:	3a893783          	ld	a5,936(s2)
    80002c28:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c2a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c2e:	85d2                	mv	a1,s4
    80002c30:	01048513          	addi	a0,s1,16
    80002c34:	00001097          	auipc	ra,0x1
    80002c38:	6f6080e7          	jalr	1782(ra) # 8000432a <initsleeplock>
    bcache.head.next->prev = b;
    80002c3c:	3a893783          	ld	a5,936(s2)
    80002c40:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c42:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c46:	46048493          	addi	s1,s1,1120
    80002c4a:	fd349de3          	bne	s1,s3,80002c24 <binit+0x54>
  }
}
    80002c4e:	70a2                	ld	ra,40(sp)
    80002c50:	7402                	ld	s0,32(sp)
    80002c52:	64e2                	ld	s1,24(sp)
    80002c54:	6942                	ld	s2,16(sp)
    80002c56:	69a2                	ld	s3,8(sp)
    80002c58:	6a02                	ld	s4,0(sp)
    80002c5a:	6145                	addi	sp,sp,48
    80002c5c:	8082                	ret

0000000080002c5e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c5e:	7179                	addi	sp,sp,-48
    80002c60:	f406                	sd	ra,40(sp)
    80002c62:	f022                	sd	s0,32(sp)
    80002c64:	ec26                	sd	s1,24(sp)
    80002c66:	e84a                	sd	s2,16(sp)
    80002c68:	e44e                	sd	s3,8(sp)
    80002c6a:	1800                	addi	s0,sp,48
    80002c6c:	892a                	mv	s2,a0
    80002c6e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c70:	00015517          	auipc	a0,0x15
    80002c74:	aa850513          	addi	a0,a0,-1368 # 80017718 <bcache>
    80002c78:	ffffe097          	auipc	ra,0xffffe
    80002c7c:	e5e080e7          	jalr	-418(ra) # 80000ad6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c80:	0001d497          	auipc	s1,0x1d
    80002c84:	e404b483          	ld	s1,-448(s1) # 8001fac0 <bcache+0x83a8>
    80002c88:	0001d797          	auipc	a5,0x1d
    80002c8c:	de878793          	addi	a5,a5,-536 # 8001fa70 <bcache+0x8358>
    80002c90:	02f48f63          	beq	s1,a5,80002cce <bread+0x70>
    80002c94:	873e                	mv	a4,a5
    80002c96:	a021                	j	80002c9e <bread+0x40>
    80002c98:	68a4                	ld	s1,80(s1)
    80002c9a:	02e48a63          	beq	s1,a4,80002cce <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002c9e:	449c                	lw	a5,8(s1)
    80002ca0:	ff279ce3          	bne	a5,s2,80002c98 <bread+0x3a>
    80002ca4:	44dc                	lw	a5,12(s1)
    80002ca6:	ff3799e3          	bne	a5,s3,80002c98 <bread+0x3a>
      b->refcnt++;
    80002caa:	40bc                	lw	a5,64(s1)
    80002cac:	2785                	addiw	a5,a5,1
    80002cae:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cb0:	00015517          	auipc	a0,0x15
    80002cb4:	a6850513          	addi	a0,a0,-1432 # 80017718 <bcache>
    80002cb8:	ffffe097          	auipc	ra,0xffffe
    80002cbc:	e86080e7          	jalr	-378(ra) # 80000b3e <release>
      acquiresleep(&b->lock);
    80002cc0:	01048513          	addi	a0,s1,16
    80002cc4:	00001097          	auipc	ra,0x1
    80002cc8:	6a0080e7          	jalr	1696(ra) # 80004364 <acquiresleep>
      return b;
    80002ccc:	a8b9                	j	80002d2a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cce:	0001d497          	auipc	s1,0x1d
    80002cd2:	dea4b483          	ld	s1,-534(s1) # 8001fab8 <bcache+0x83a0>
    80002cd6:	0001d797          	auipc	a5,0x1d
    80002cda:	d9a78793          	addi	a5,a5,-614 # 8001fa70 <bcache+0x8358>
    80002cde:	00f48863          	beq	s1,a5,80002cee <bread+0x90>
    80002ce2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ce4:	40bc                	lw	a5,64(s1)
    80002ce6:	cf81                	beqz	a5,80002cfe <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ce8:	64a4                	ld	s1,72(s1)
    80002cea:	fee49de3          	bne	s1,a4,80002ce4 <bread+0x86>
  panic("bget: no buffers");
    80002cee:	00004517          	auipc	a0,0x4
    80002cf2:	7e250513          	addi	a0,a0,2018 # 800074d0 <userret+0x440>
    80002cf6:	ffffe097          	auipc	ra,0xffffe
    80002cfa:	852080e7          	jalr	-1966(ra) # 80000548 <panic>
      b->dev = dev;
    80002cfe:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d02:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d06:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d0a:	4785                	li	a5,1
    80002d0c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d0e:	00015517          	auipc	a0,0x15
    80002d12:	a0a50513          	addi	a0,a0,-1526 # 80017718 <bcache>
    80002d16:	ffffe097          	auipc	ra,0xffffe
    80002d1a:	e28080e7          	jalr	-472(ra) # 80000b3e <release>
      acquiresleep(&b->lock);
    80002d1e:	01048513          	addi	a0,s1,16
    80002d22:	00001097          	auipc	ra,0x1
    80002d26:	642080e7          	jalr	1602(ra) # 80004364 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d2a:	409c                	lw	a5,0(s1)
    80002d2c:	cb89                	beqz	a5,80002d3e <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d2e:	8526                	mv	a0,s1
    80002d30:	70a2                	ld	ra,40(sp)
    80002d32:	7402                	ld	s0,32(sp)
    80002d34:	64e2                	ld	s1,24(sp)
    80002d36:	6942                	ld	s2,16(sp)
    80002d38:	69a2                	ld	s3,8(sp)
    80002d3a:	6145                	addi	sp,sp,48
    80002d3c:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    80002d3e:	4601                	li	a2,0
    80002d40:	85a6                	mv	a1,s1
    80002d42:	4488                	lw	a0,8(s1)
    80002d44:	00003097          	auipc	ra,0x3
    80002d48:	2a8080e7          	jalr	680(ra) # 80005fec <virtio_disk_rw>
    b->valid = 1;
    80002d4c:	4785                	li	a5,1
    80002d4e:	c09c                	sw	a5,0(s1)
  return b;
    80002d50:	bff9                	j	80002d2e <bread+0xd0>

0000000080002d52 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	e426                	sd	s1,8(sp)
    80002d5a:	1000                	addi	s0,sp,32
    80002d5c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d5e:	0541                	addi	a0,a0,16
    80002d60:	00001097          	auipc	ra,0x1
    80002d64:	69e080e7          	jalr	1694(ra) # 800043fe <holdingsleep>
    80002d68:	cd09                	beqz	a0,80002d82 <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    80002d6a:	4605                	li	a2,1
    80002d6c:	85a6                	mv	a1,s1
    80002d6e:	4488                	lw	a0,8(s1)
    80002d70:	00003097          	auipc	ra,0x3
    80002d74:	27c080e7          	jalr	636(ra) # 80005fec <virtio_disk_rw>
}
    80002d78:	60e2                	ld	ra,24(sp)
    80002d7a:	6442                	ld	s0,16(sp)
    80002d7c:	64a2                	ld	s1,8(sp)
    80002d7e:	6105                	addi	sp,sp,32
    80002d80:	8082                	ret
    panic("bwrite");
    80002d82:	00004517          	auipc	a0,0x4
    80002d86:	76650513          	addi	a0,a0,1894 # 800074e8 <userret+0x458>
    80002d8a:	ffffd097          	auipc	ra,0xffffd
    80002d8e:	7be080e7          	jalr	1982(ra) # 80000548 <panic>

0000000080002d92 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002d92:	1101                	addi	sp,sp,-32
    80002d94:	ec06                	sd	ra,24(sp)
    80002d96:	e822                	sd	s0,16(sp)
    80002d98:	e426                	sd	s1,8(sp)
    80002d9a:	e04a                	sd	s2,0(sp)
    80002d9c:	1000                	addi	s0,sp,32
    80002d9e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002da0:	01050913          	addi	s2,a0,16
    80002da4:	854a                	mv	a0,s2
    80002da6:	00001097          	auipc	ra,0x1
    80002daa:	658080e7          	jalr	1624(ra) # 800043fe <holdingsleep>
    80002dae:	c92d                	beqz	a0,80002e20 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002db0:	854a                	mv	a0,s2
    80002db2:	00001097          	auipc	ra,0x1
    80002db6:	608080e7          	jalr	1544(ra) # 800043ba <releasesleep>

  acquire(&bcache.lock);
    80002dba:	00015517          	auipc	a0,0x15
    80002dbe:	95e50513          	addi	a0,a0,-1698 # 80017718 <bcache>
    80002dc2:	ffffe097          	auipc	ra,0xffffe
    80002dc6:	d14080e7          	jalr	-748(ra) # 80000ad6 <acquire>
  b->refcnt--;
    80002dca:	40bc                	lw	a5,64(s1)
    80002dcc:	37fd                	addiw	a5,a5,-1
    80002dce:	0007871b          	sext.w	a4,a5
    80002dd2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002dd4:	eb05                	bnez	a4,80002e04 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002dd6:	68bc                	ld	a5,80(s1)
    80002dd8:	64b8                	ld	a4,72(s1)
    80002dda:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002ddc:	64bc                	ld	a5,72(s1)
    80002dde:	68b8                	ld	a4,80(s1)
    80002de0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002de2:	0001d797          	auipc	a5,0x1d
    80002de6:	93678793          	addi	a5,a5,-1738 # 8001f718 <bcache+0x8000>
    80002dea:	3a87b703          	ld	a4,936(a5)
    80002dee:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002df0:	0001d717          	auipc	a4,0x1d
    80002df4:	c8070713          	addi	a4,a4,-896 # 8001fa70 <bcache+0x8358>
    80002df8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002dfa:	3a87b703          	ld	a4,936(a5)
    80002dfe:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e00:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80002e04:	00015517          	auipc	a0,0x15
    80002e08:	91450513          	addi	a0,a0,-1772 # 80017718 <bcache>
    80002e0c:	ffffe097          	auipc	ra,0xffffe
    80002e10:	d32080e7          	jalr	-718(ra) # 80000b3e <release>
}
    80002e14:	60e2                	ld	ra,24(sp)
    80002e16:	6442                	ld	s0,16(sp)
    80002e18:	64a2                	ld	s1,8(sp)
    80002e1a:	6902                	ld	s2,0(sp)
    80002e1c:	6105                	addi	sp,sp,32
    80002e1e:	8082                	ret
    panic("brelse");
    80002e20:	00004517          	auipc	a0,0x4
    80002e24:	6d050513          	addi	a0,a0,1744 # 800074f0 <userret+0x460>
    80002e28:	ffffd097          	auipc	ra,0xffffd
    80002e2c:	720080e7          	jalr	1824(ra) # 80000548 <panic>

0000000080002e30 <bpin>:

void
bpin(struct buf *b) {
    80002e30:	1101                	addi	sp,sp,-32
    80002e32:	ec06                	sd	ra,24(sp)
    80002e34:	e822                	sd	s0,16(sp)
    80002e36:	e426                	sd	s1,8(sp)
    80002e38:	1000                	addi	s0,sp,32
    80002e3a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e3c:	00015517          	auipc	a0,0x15
    80002e40:	8dc50513          	addi	a0,a0,-1828 # 80017718 <bcache>
    80002e44:	ffffe097          	auipc	ra,0xffffe
    80002e48:	c92080e7          	jalr	-878(ra) # 80000ad6 <acquire>
  b->refcnt++;
    80002e4c:	40bc                	lw	a5,64(s1)
    80002e4e:	2785                	addiw	a5,a5,1
    80002e50:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e52:	00015517          	auipc	a0,0x15
    80002e56:	8c650513          	addi	a0,a0,-1850 # 80017718 <bcache>
    80002e5a:	ffffe097          	auipc	ra,0xffffe
    80002e5e:	ce4080e7          	jalr	-796(ra) # 80000b3e <release>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret

0000000080002e6c <bunpin>:

void
bunpin(struct buf *b) {
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	1000                	addi	s0,sp,32
    80002e76:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e78:	00015517          	auipc	a0,0x15
    80002e7c:	8a050513          	addi	a0,a0,-1888 # 80017718 <bcache>
    80002e80:	ffffe097          	auipc	ra,0xffffe
    80002e84:	c56080e7          	jalr	-938(ra) # 80000ad6 <acquire>
  b->refcnt--;
    80002e88:	40bc                	lw	a5,64(s1)
    80002e8a:	37fd                	addiw	a5,a5,-1
    80002e8c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e8e:	00015517          	auipc	a0,0x15
    80002e92:	88a50513          	addi	a0,a0,-1910 # 80017718 <bcache>
    80002e96:	ffffe097          	auipc	ra,0xffffe
    80002e9a:	ca8080e7          	jalr	-856(ra) # 80000b3e <release>
}
    80002e9e:	60e2                	ld	ra,24(sp)
    80002ea0:	6442                	ld	s0,16(sp)
    80002ea2:	64a2                	ld	s1,8(sp)
    80002ea4:	6105                	addi	sp,sp,32
    80002ea6:	8082                	ret

0000000080002ea8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ea8:	1101                	addi	sp,sp,-32
    80002eaa:	ec06                	sd	ra,24(sp)
    80002eac:	e822                	sd	s0,16(sp)
    80002eae:	e426                	sd	s1,8(sp)
    80002eb0:	e04a                	sd	s2,0(sp)
    80002eb2:	1000                	addi	s0,sp,32
    80002eb4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002eb6:	00d5d59b          	srliw	a1,a1,0xd
    80002eba:	0001d797          	auipc	a5,0x1d
    80002ebe:	0327a783          	lw	a5,50(a5) # 8001feec <sb+0x1c>
    80002ec2:	9dbd                	addw	a1,a1,a5
    80002ec4:	00000097          	auipc	ra,0x0
    80002ec8:	d9a080e7          	jalr	-614(ra) # 80002c5e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002ecc:	0074f713          	andi	a4,s1,7
    80002ed0:	4785                	li	a5,1
    80002ed2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002ed6:	14ce                	slli	s1,s1,0x33
    80002ed8:	90d9                	srli	s1,s1,0x36
    80002eda:	00950733          	add	a4,a0,s1
    80002ede:	06074703          	lbu	a4,96(a4)
    80002ee2:	00e7f6b3          	and	a3,a5,a4
    80002ee6:	c69d                	beqz	a3,80002f14 <bfree+0x6c>
    80002ee8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002eea:	94aa                	add	s1,s1,a0
    80002eec:	fff7c793          	not	a5,a5
    80002ef0:	8ff9                	and	a5,a5,a4
    80002ef2:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002ef6:	00001097          	auipc	ra,0x1
    80002efa:	1d6080e7          	jalr	470(ra) # 800040cc <log_write>
  brelse(bp);
    80002efe:	854a                	mv	a0,s2
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	e92080e7          	jalr	-366(ra) # 80002d92 <brelse>
}
    80002f08:	60e2                	ld	ra,24(sp)
    80002f0a:	6442                	ld	s0,16(sp)
    80002f0c:	64a2                	ld	s1,8(sp)
    80002f0e:	6902                	ld	s2,0(sp)
    80002f10:	6105                	addi	sp,sp,32
    80002f12:	8082                	ret
    panic("freeing free block");
    80002f14:	00004517          	auipc	a0,0x4
    80002f18:	5e450513          	addi	a0,a0,1508 # 800074f8 <userret+0x468>
    80002f1c:	ffffd097          	auipc	ra,0xffffd
    80002f20:	62c080e7          	jalr	1580(ra) # 80000548 <panic>

0000000080002f24 <balloc>:
{
    80002f24:	711d                	addi	sp,sp,-96
    80002f26:	ec86                	sd	ra,88(sp)
    80002f28:	e8a2                	sd	s0,80(sp)
    80002f2a:	e4a6                	sd	s1,72(sp)
    80002f2c:	e0ca                	sd	s2,64(sp)
    80002f2e:	fc4e                	sd	s3,56(sp)
    80002f30:	f852                	sd	s4,48(sp)
    80002f32:	f456                	sd	s5,40(sp)
    80002f34:	f05a                	sd	s6,32(sp)
    80002f36:	ec5e                	sd	s7,24(sp)
    80002f38:	e862                	sd	s8,16(sp)
    80002f3a:	e466                	sd	s9,8(sp)
    80002f3c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f3e:	0001d797          	auipc	a5,0x1d
    80002f42:	f967a783          	lw	a5,-106(a5) # 8001fed4 <sb+0x4>
    80002f46:	cbd1                	beqz	a5,80002fda <balloc+0xb6>
    80002f48:	8baa                	mv	s7,a0
    80002f4a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f4c:	0001db17          	auipc	s6,0x1d
    80002f50:	f84b0b13          	addi	s6,s6,-124 # 8001fed0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f54:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002f56:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f58:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f5a:	6c89                	lui	s9,0x2
    80002f5c:	a831                	j	80002f78 <balloc+0x54>
    brelse(bp);
    80002f5e:	854a                	mv	a0,s2
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	e32080e7          	jalr	-462(ra) # 80002d92 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f68:	015c87bb          	addw	a5,s9,s5
    80002f6c:	00078a9b          	sext.w	s5,a5
    80002f70:	004b2703          	lw	a4,4(s6)
    80002f74:	06eaf363          	bgeu	s5,a4,80002fda <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002f78:	41fad79b          	sraiw	a5,s5,0x1f
    80002f7c:	0137d79b          	srliw	a5,a5,0x13
    80002f80:	015787bb          	addw	a5,a5,s5
    80002f84:	40d7d79b          	sraiw	a5,a5,0xd
    80002f88:	01cb2583          	lw	a1,28(s6)
    80002f8c:	9dbd                	addw	a1,a1,a5
    80002f8e:	855e                	mv	a0,s7
    80002f90:	00000097          	auipc	ra,0x0
    80002f94:	cce080e7          	jalr	-818(ra) # 80002c5e <bread>
    80002f98:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f9a:	004b2503          	lw	a0,4(s6)
    80002f9e:	000a849b          	sext.w	s1,s5
    80002fa2:	8662                	mv	a2,s8
    80002fa4:	faa4fde3          	bgeu	s1,a0,80002f5e <balloc+0x3a>
      m = 1 << (bi % 8);
    80002fa8:	41f6579b          	sraiw	a5,a2,0x1f
    80002fac:	01d7d69b          	srliw	a3,a5,0x1d
    80002fb0:	00c6873b          	addw	a4,a3,a2
    80002fb4:	00777793          	andi	a5,a4,7
    80002fb8:	9f95                	subw	a5,a5,a3
    80002fba:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002fbe:	4037571b          	sraiw	a4,a4,0x3
    80002fc2:	00e906b3          	add	a3,s2,a4
    80002fc6:	0606c683          	lbu	a3,96(a3)
    80002fca:	00d7f5b3          	and	a1,a5,a3
    80002fce:	cd91                	beqz	a1,80002fea <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fd0:	2605                	addiw	a2,a2,1
    80002fd2:	2485                	addiw	s1,s1,1
    80002fd4:	fd4618e3          	bne	a2,s4,80002fa4 <balloc+0x80>
    80002fd8:	b759                	j	80002f5e <balloc+0x3a>
  panic("balloc: out of blocks");
    80002fda:	00004517          	auipc	a0,0x4
    80002fde:	53650513          	addi	a0,a0,1334 # 80007510 <userret+0x480>
    80002fe2:	ffffd097          	auipc	ra,0xffffd
    80002fe6:	566080e7          	jalr	1382(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002fea:	974a                	add	a4,a4,s2
    80002fec:	8fd5                	or	a5,a5,a3
    80002fee:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	00001097          	auipc	ra,0x1
    80002ff8:	0d8080e7          	jalr	216(ra) # 800040cc <log_write>
        brelse(bp);
    80002ffc:	854a                	mv	a0,s2
    80002ffe:	00000097          	auipc	ra,0x0
    80003002:	d94080e7          	jalr	-620(ra) # 80002d92 <brelse>
  bp = bread(dev, bno);
    80003006:	85a6                	mv	a1,s1
    80003008:	855e                	mv	a0,s7
    8000300a:	00000097          	auipc	ra,0x0
    8000300e:	c54080e7          	jalr	-940(ra) # 80002c5e <bread>
    80003012:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003014:	40000613          	li	a2,1024
    80003018:	4581                	li	a1,0
    8000301a:	06050513          	addi	a0,a0,96
    8000301e:	ffffe097          	auipc	ra,0xffffe
    80003022:	b7c080e7          	jalr	-1156(ra) # 80000b9a <memset>
  log_write(bp);
    80003026:	854a                	mv	a0,s2
    80003028:	00001097          	auipc	ra,0x1
    8000302c:	0a4080e7          	jalr	164(ra) # 800040cc <log_write>
  brelse(bp);
    80003030:	854a                	mv	a0,s2
    80003032:	00000097          	auipc	ra,0x0
    80003036:	d60080e7          	jalr	-672(ra) # 80002d92 <brelse>
}
    8000303a:	8526                	mv	a0,s1
    8000303c:	60e6                	ld	ra,88(sp)
    8000303e:	6446                	ld	s0,80(sp)
    80003040:	64a6                	ld	s1,72(sp)
    80003042:	6906                	ld	s2,64(sp)
    80003044:	79e2                	ld	s3,56(sp)
    80003046:	7a42                	ld	s4,48(sp)
    80003048:	7aa2                	ld	s5,40(sp)
    8000304a:	7b02                	ld	s6,32(sp)
    8000304c:	6be2                	ld	s7,24(sp)
    8000304e:	6c42                	ld	s8,16(sp)
    80003050:	6ca2                	ld	s9,8(sp)
    80003052:	6125                	addi	sp,sp,96
    80003054:	8082                	ret

0000000080003056 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003056:	7179                	addi	sp,sp,-48
    80003058:	f406                	sd	ra,40(sp)
    8000305a:	f022                	sd	s0,32(sp)
    8000305c:	ec26                	sd	s1,24(sp)
    8000305e:	e84a                	sd	s2,16(sp)
    80003060:	e44e                	sd	s3,8(sp)
    80003062:	e052                	sd	s4,0(sp)
    80003064:	1800                	addi	s0,sp,48
    80003066:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003068:	47ad                	li	a5,11
    8000306a:	04b7fe63          	bgeu	a5,a1,800030c6 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000306e:	ff45849b          	addiw	s1,a1,-12
    80003072:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003076:	0ff00793          	li	a5,255
    8000307a:	0ae7e463          	bltu	a5,a4,80003122 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000307e:	08052583          	lw	a1,128(a0)
    80003082:	c5b5                	beqz	a1,800030ee <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003084:	00092503          	lw	a0,0(s2)
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	bd6080e7          	jalr	-1066(ra) # 80002c5e <bread>
    80003090:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003092:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80003096:	02049713          	slli	a4,s1,0x20
    8000309a:	01e75593          	srli	a1,a4,0x1e
    8000309e:	00b784b3          	add	s1,a5,a1
    800030a2:	0004a983          	lw	s3,0(s1)
    800030a6:	04098e63          	beqz	s3,80003102 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800030aa:	8552                	mv	a0,s4
    800030ac:	00000097          	auipc	ra,0x0
    800030b0:	ce6080e7          	jalr	-794(ra) # 80002d92 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800030b4:	854e                	mv	a0,s3
    800030b6:	70a2                	ld	ra,40(sp)
    800030b8:	7402                	ld	s0,32(sp)
    800030ba:	64e2                	ld	s1,24(sp)
    800030bc:	6942                	ld	s2,16(sp)
    800030be:	69a2                	ld	s3,8(sp)
    800030c0:	6a02                	ld	s4,0(sp)
    800030c2:	6145                	addi	sp,sp,48
    800030c4:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800030c6:	02059793          	slli	a5,a1,0x20
    800030ca:	01e7d593          	srli	a1,a5,0x1e
    800030ce:	00b504b3          	add	s1,a0,a1
    800030d2:	0504a983          	lw	s3,80(s1)
    800030d6:	fc099fe3          	bnez	s3,800030b4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800030da:	4108                	lw	a0,0(a0)
    800030dc:	00000097          	auipc	ra,0x0
    800030e0:	e48080e7          	jalr	-440(ra) # 80002f24 <balloc>
    800030e4:	0005099b          	sext.w	s3,a0
    800030e8:	0534a823          	sw	s3,80(s1)
    800030ec:	b7e1                	j	800030b4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800030ee:	4108                	lw	a0,0(a0)
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	e34080e7          	jalr	-460(ra) # 80002f24 <balloc>
    800030f8:	0005059b          	sext.w	a1,a0
    800030fc:	08b92023          	sw	a1,128(s2)
    80003100:	b751                	j	80003084 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003102:	00092503          	lw	a0,0(s2)
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	e1e080e7          	jalr	-482(ra) # 80002f24 <balloc>
    8000310e:	0005099b          	sext.w	s3,a0
    80003112:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003116:	8552                	mv	a0,s4
    80003118:	00001097          	auipc	ra,0x1
    8000311c:	fb4080e7          	jalr	-76(ra) # 800040cc <log_write>
    80003120:	b769                	j	800030aa <bmap+0x54>
  panic("bmap: out of range");
    80003122:	00004517          	auipc	a0,0x4
    80003126:	40650513          	addi	a0,a0,1030 # 80007528 <userret+0x498>
    8000312a:	ffffd097          	auipc	ra,0xffffd
    8000312e:	41e080e7          	jalr	1054(ra) # 80000548 <panic>

0000000080003132 <iget>:
{
    80003132:	7179                	addi	sp,sp,-48
    80003134:	f406                	sd	ra,40(sp)
    80003136:	f022                	sd	s0,32(sp)
    80003138:	ec26                	sd	s1,24(sp)
    8000313a:	e84a                	sd	s2,16(sp)
    8000313c:	e44e                	sd	s3,8(sp)
    8000313e:	e052                	sd	s4,0(sp)
    80003140:	1800                	addi	s0,sp,48
    80003142:	89aa                	mv	s3,a0
    80003144:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003146:	0001d517          	auipc	a0,0x1d
    8000314a:	daa50513          	addi	a0,a0,-598 # 8001fef0 <icache>
    8000314e:	ffffe097          	auipc	ra,0xffffe
    80003152:	988080e7          	jalr	-1656(ra) # 80000ad6 <acquire>
  empty = 0;
    80003156:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003158:	0001d497          	auipc	s1,0x1d
    8000315c:	db048493          	addi	s1,s1,-592 # 8001ff08 <icache+0x18>
    80003160:	0001f697          	auipc	a3,0x1f
    80003164:	83868693          	addi	a3,a3,-1992 # 80021998 <log>
    80003168:	a039                	j	80003176 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000316a:	02090b63          	beqz	s2,800031a0 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000316e:	08848493          	addi	s1,s1,136
    80003172:	02d48a63          	beq	s1,a3,800031a6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003176:	449c                	lw	a5,8(s1)
    80003178:	fef059e3          	blez	a5,8000316a <iget+0x38>
    8000317c:	4098                	lw	a4,0(s1)
    8000317e:	ff3716e3          	bne	a4,s3,8000316a <iget+0x38>
    80003182:	40d8                	lw	a4,4(s1)
    80003184:	ff4713e3          	bne	a4,s4,8000316a <iget+0x38>
      ip->ref++;
    80003188:	2785                	addiw	a5,a5,1
    8000318a:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000318c:	0001d517          	auipc	a0,0x1d
    80003190:	d6450513          	addi	a0,a0,-668 # 8001fef0 <icache>
    80003194:	ffffe097          	auipc	ra,0xffffe
    80003198:	9aa080e7          	jalr	-1622(ra) # 80000b3e <release>
      return ip;
    8000319c:	8926                	mv	s2,s1
    8000319e:	a03d                	j	800031cc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800031a0:	f7f9                	bnez	a5,8000316e <iget+0x3c>
    800031a2:	8926                	mv	s2,s1
    800031a4:	b7e9                	j	8000316e <iget+0x3c>
  if(empty == 0)
    800031a6:	02090c63          	beqz	s2,800031de <iget+0xac>
  ip->dev = dev;
    800031aa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800031ae:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800031b2:	4785                	li	a5,1
    800031b4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800031b8:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800031bc:	0001d517          	auipc	a0,0x1d
    800031c0:	d3450513          	addi	a0,a0,-716 # 8001fef0 <icache>
    800031c4:	ffffe097          	auipc	ra,0xffffe
    800031c8:	97a080e7          	jalr	-1670(ra) # 80000b3e <release>
}
    800031cc:	854a                	mv	a0,s2
    800031ce:	70a2                	ld	ra,40(sp)
    800031d0:	7402                	ld	s0,32(sp)
    800031d2:	64e2                	ld	s1,24(sp)
    800031d4:	6942                	ld	s2,16(sp)
    800031d6:	69a2                	ld	s3,8(sp)
    800031d8:	6a02                	ld	s4,0(sp)
    800031da:	6145                	addi	sp,sp,48
    800031dc:	8082                	ret
    panic("iget: no inodes");
    800031de:	00004517          	auipc	a0,0x4
    800031e2:	36250513          	addi	a0,a0,866 # 80007540 <userret+0x4b0>
    800031e6:	ffffd097          	auipc	ra,0xffffd
    800031ea:	362080e7          	jalr	866(ra) # 80000548 <panic>

00000000800031ee <fsinit>:
fsinit(int dev) {
    800031ee:	7179                	addi	sp,sp,-48
    800031f0:	f406                	sd	ra,40(sp)
    800031f2:	f022                	sd	s0,32(sp)
    800031f4:	ec26                	sd	s1,24(sp)
    800031f6:	e84a                	sd	s2,16(sp)
    800031f8:	e44e                	sd	s3,8(sp)
    800031fa:	1800                	addi	s0,sp,48
    800031fc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800031fe:	4585                	li	a1,1
    80003200:	00000097          	auipc	ra,0x0
    80003204:	a5e080e7          	jalr	-1442(ra) # 80002c5e <bread>
    80003208:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000320a:	0001d997          	auipc	s3,0x1d
    8000320e:	cc698993          	addi	s3,s3,-826 # 8001fed0 <sb>
    80003212:	02000613          	li	a2,32
    80003216:	06050593          	addi	a1,a0,96
    8000321a:	854e                	mv	a0,s3
    8000321c:	ffffe097          	auipc	ra,0xffffe
    80003220:	9da080e7          	jalr	-1574(ra) # 80000bf6 <memmove>
  brelse(bp);
    80003224:	8526                	mv	a0,s1
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	b6c080e7          	jalr	-1172(ra) # 80002d92 <brelse>
  if(sb.magic != FSMAGIC)
    8000322e:	0009a703          	lw	a4,0(s3)
    80003232:	102037b7          	lui	a5,0x10203
    80003236:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000323a:	02f71263          	bne	a4,a5,8000325e <fsinit+0x70>
  initlog(dev, &sb);
    8000323e:	0001d597          	auipc	a1,0x1d
    80003242:	c9258593          	addi	a1,a1,-878 # 8001fed0 <sb>
    80003246:	854a                	mv	a0,s2
    80003248:	00001097          	auipc	ra,0x1
    8000324c:	bfc080e7          	jalr	-1028(ra) # 80003e44 <initlog>
}
    80003250:	70a2                	ld	ra,40(sp)
    80003252:	7402                	ld	s0,32(sp)
    80003254:	64e2                	ld	s1,24(sp)
    80003256:	6942                	ld	s2,16(sp)
    80003258:	69a2                	ld	s3,8(sp)
    8000325a:	6145                	addi	sp,sp,48
    8000325c:	8082                	ret
    panic("invalid file system");
    8000325e:	00004517          	auipc	a0,0x4
    80003262:	2f250513          	addi	a0,a0,754 # 80007550 <userret+0x4c0>
    80003266:	ffffd097          	auipc	ra,0xffffd
    8000326a:	2e2080e7          	jalr	738(ra) # 80000548 <panic>

000000008000326e <iinit>:
{
    8000326e:	7179                	addi	sp,sp,-48
    80003270:	f406                	sd	ra,40(sp)
    80003272:	f022                	sd	s0,32(sp)
    80003274:	ec26                	sd	s1,24(sp)
    80003276:	e84a                	sd	s2,16(sp)
    80003278:	e44e                	sd	s3,8(sp)
    8000327a:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000327c:	00004597          	auipc	a1,0x4
    80003280:	2ec58593          	addi	a1,a1,748 # 80007568 <userret+0x4d8>
    80003284:	0001d517          	auipc	a0,0x1d
    80003288:	c6c50513          	addi	a0,a0,-916 # 8001fef0 <icache>
    8000328c:	ffffd097          	auipc	ra,0xffffd
    80003290:	73c080e7          	jalr	1852(ra) # 800009c8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003294:	0001d497          	auipc	s1,0x1d
    80003298:	c8448493          	addi	s1,s1,-892 # 8001ff18 <icache+0x28>
    8000329c:	0001e997          	auipc	s3,0x1e
    800032a0:	70c98993          	addi	s3,s3,1804 # 800219a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800032a4:	00004917          	auipc	s2,0x4
    800032a8:	2cc90913          	addi	s2,s2,716 # 80007570 <userret+0x4e0>
    800032ac:	85ca                	mv	a1,s2
    800032ae:	8526                	mv	a0,s1
    800032b0:	00001097          	auipc	ra,0x1
    800032b4:	07a080e7          	jalr	122(ra) # 8000432a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800032b8:	08848493          	addi	s1,s1,136
    800032bc:	ff3498e3          	bne	s1,s3,800032ac <iinit+0x3e>
}
    800032c0:	70a2                	ld	ra,40(sp)
    800032c2:	7402                	ld	s0,32(sp)
    800032c4:	64e2                	ld	s1,24(sp)
    800032c6:	6942                	ld	s2,16(sp)
    800032c8:	69a2                	ld	s3,8(sp)
    800032ca:	6145                	addi	sp,sp,48
    800032cc:	8082                	ret

00000000800032ce <ialloc>:
{
    800032ce:	715d                	addi	sp,sp,-80
    800032d0:	e486                	sd	ra,72(sp)
    800032d2:	e0a2                	sd	s0,64(sp)
    800032d4:	fc26                	sd	s1,56(sp)
    800032d6:	f84a                	sd	s2,48(sp)
    800032d8:	f44e                	sd	s3,40(sp)
    800032da:	f052                	sd	s4,32(sp)
    800032dc:	ec56                	sd	s5,24(sp)
    800032de:	e85a                	sd	s6,16(sp)
    800032e0:	e45e                	sd	s7,8(sp)
    800032e2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800032e4:	0001d717          	auipc	a4,0x1d
    800032e8:	bf872703          	lw	a4,-1032(a4) # 8001fedc <sb+0xc>
    800032ec:	4785                	li	a5,1
    800032ee:	04e7fa63          	bgeu	a5,a4,80003342 <ialloc+0x74>
    800032f2:	8aaa                	mv	s5,a0
    800032f4:	8bae                	mv	s7,a1
    800032f6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800032f8:	0001da17          	auipc	s4,0x1d
    800032fc:	bd8a0a13          	addi	s4,s4,-1064 # 8001fed0 <sb>
    80003300:	00048b1b          	sext.w	s6,s1
    80003304:	0044d793          	srli	a5,s1,0x4
    80003308:	018a2583          	lw	a1,24(s4)
    8000330c:	9dbd                	addw	a1,a1,a5
    8000330e:	8556                	mv	a0,s5
    80003310:	00000097          	auipc	ra,0x0
    80003314:	94e080e7          	jalr	-1714(ra) # 80002c5e <bread>
    80003318:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000331a:	06050993          	addi	s3,a0,96
    8000331e:	00f4f793          	andi	a5,s1,15
    80003322:	079a                	slli	a5,a5,0x6
    80003324:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003326:	00099783          	lh	a5,0(s3)
    8000332a:	c785                	beqz	a5,80003352 <ialloc+0x84>
    brelse(bp);
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	a66080e7          	jalr	-1434(ra) # 80002d92 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003334:	0485                	addi	s1,s1,1
    80003336:	00ca2703          	lw	a4,12(s4)
    8000333a:	0004879b          	sext.w	a5,s1
    8000333e:	fce7e1e3          	bltu	a5,a4,80003300 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003342:	00004517          	auipc	a0,0x4
    80003346:	23650513          	addi	a0,a0,566 # 80007578 <userret+0x4e8>
    8000334a:	ffffd097          	auipc	ra,0xffffd
    8000334e:	1fe080e7          	jalr	510(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    80003352:	04000613          	li	a2,64
    80003356:	4581                	li	a1,0
    80003358:	854e                	mv	a0,s3
    8000335a:	ffffe097          	auipc	ra,0xffffe
    8000335e:	840080e7          	jalr	-1984(ra) # 80000b9a <memset>
      dip->type = type;
    80003362:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003366:	854a                	mv	a0,s2
    80003368:	00001097          	auipc	ra,0x1
    8000336c:	d64080e7          	jalr	-668(ra) # 800040cc <log_write>
      brelse(bp);
    80003370:	854a                	mv	a0,s2
    80003372:	00000097          	auipc	ra,0x0
    80003376:	a20080e7          	jalr	-1504(ra) # 80002d92 <brelse>
      return iget(dev, inum);
    8000337a:	85da                	mv	a1,s6
    8000337c:	8556                	mv	a0,s5
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	db4080e7          	jalr	-588(ra) # 80003132 <iget>
}
    80003386:	60a6                	ld	ra,72(sp)
    80003388:	6406                	ld	s0,64(sp)
    8000338a:	74e2                	ld	s1,56(sp)
    8000338c:	7942                	ld	s2,48(sp)
    8000338e:	79a2                	ld	s3,40(sp)
    80003390:	7a02                	ld	s4,32(sp)
    80003392:	6ae2                	ld	s5,24(sp)
    80003394:	6b42                	ld	s6,16(sp)
    80003396:	6ba2                	ld	s7,8(sp)
    80003398:	6161                	addi	sp,sp,80
    8000339a:	8082                	ret

000000008000339c <iupdate>:
{
    8000339c:	1101                	addi	sp,sp,-32
    8000339e:	ec06                	sd	ra,24(sp)
    800033a0:	e822                	sd	s0,16(sp)
    800033a2:	e426                	sd	s1,8(sp)
    800033a4:	e04a                	sd	s2,0(sp)
    800033a6:	1000                	addi	s0,sp,32
    800033a8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033aa:	415c                	lw	a5,4(a0)
    800033ac:	0047d79b          	srliw	a5,a5,0x4
    800033b0:	0001d597          	auipc	a1,0x1d
    800033b4:	b385a583          	lw	a1,-1224(a1) # 8001fee8 <sb+0x18>
    800033b8:	9dbd                	addw	a1,a1,a5
    800033ba:	4108                	lw	a0,0(a0)
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	8a2080e7          	jalr	-1886(ra) # 80002c5e <bread>
    800033c4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033c6:	06050793          	addi	a5,a0,96
    800033ca:	40c8                	lw	a0,4(s1)
    800033cc:	893d                	andi	a0,a0,15
    800033ce:	051a                	slli	a0,a0,0x6
    800033d0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800033d2:	04449703          	lh	a4,68(s1)
    800033d6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800033da:	04649703          	lh	a4,70(s1)
    800033de:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800033e2:	04849703          	lh	a4,72(s1)
    800033e6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800033ea:	04a49703          	lh	a4,74(s1)
    800033ee:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800033f2:	44f8                	lw	a4,76(s1)
    800033f4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800033f6:	03400613          	li	a2,52
    800033fa:	05048593          	addi	a1,s1,80
    800033fe:	0531                	addi	a0,a0,12
    80003400:	ffffd097          	auipc	ra,0xffffd
    80003404:	7f6080e7          	jalr	2038(ra) # 80000bf6 <memmove>
  log_write(bp);
    80003408:	854a                	mv	a0,s2
    8000340a:	00001097          	auipc	ra,0x1
    8000340e:	cc2080e7          	jalr	-830(ra) # 800040cc <log_write>
  brelse(bp);
    80003412:	854a                	mv	a0,s2
    80003414:	00000097          	auipc	ra,0x0
    80003418:	97e080e7          	jalr	-1666(ra) # 80002d92 <brelse>
}
    8000341c:	60e2                	ld	ra,24(sp)
    8000341e:	6442                	ld	s0,16(sp)
    80003420:	64a2                	ld	s1,8(sp)
    80003422:	6902                	ld	s2,0(sp)
    80003424:	6105                	addi	sp,sp,32
    80003426:	8082                	ret

0000000080003428 <idup>:
{
    80003428:	1101                	addi	sp,sp,-32
    8000342a:	ec06                	sd	ra,24(sp)
    8000342c:	e822                	sd	s0,16(sp)
    8000342e:	e426                	sd	s1,8(sp)
    80003430:	1000                	addi	s0,sp,32
    80003432:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003434:	0001d517          	auipc	a0,0x1d
    80003438:	abc50513          	addi	a0,a0,-1348 # 8001fef0 <icache>
    8000343c:	ffffd097          	auipc	ra,0xffffd
    80003440:	69a080e7          	jalr	1690(ra) # 80000ad6 <acquire>
  ip->ref++;
    80003444:	449c                	lw	a5,8(s1)
    80003446:	2785                	addiw	a5,a5,1
    80003448:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000344a:	0001d517          	auipc	a0,0x1d
    8000344e:	aa650513          	addi	a0,a0,-1370 # 8001fef0 <icache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	6ec080e7          	jalr	1772(ra) # 80000b3e <release>
}
    8000345a:	8526                	mv	a0,s1
    8000345c:	60e2                	ld	ra,24(sp)
    8000345e:	6442                	ld	s0,16(sp)
    80003460:	64a2                	ld	s1,8(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <ilock>:
{
    80003466:	1101                	addi	sp,sp,-32
    80003468:	ec06                	sd	ra,24(sp)
    8000346a:	e822                	sd	s0,16(sp)
    8000346c:	e426                	sd	s1,8(sp)
    8000346e:	e04a                	sd	s2,0(sp)
    80003470:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003472:	c115                	beqz	a0,80003496 <ilock+0x30>
    80003474:	84aa                	mv	s1,a0
    80003476:	451c                	lw	a5,8(a0)
    80003478:	00f05f63          	blez	a5,80003496 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000347c:	0541                	addi	a0,a0,16
    8000347e:	00001097          	auipc	ra,0x1
    80003482:	ee6080e7          	jalr	-282(ra) # 80004364 <acquiresleep>
  if(ip->valid == 0){
    80003486:	40bc                	lw	a5,64(s1)
    80003488:	cf99                	beqz	a5,800034a6 <ilock+0x40>
}
    8000348a:	60e2                	ld	ra,24(sp)
    8000348c:	6442                	ld	s0,16(sp)
    8000348e:	64a2                	ld	s1,8(sp)
    80003490:	6902                	ld	s2,0(sp)
    80003492:	6105                	addi	sp,sp,32
    80003494:	8082                	ret
    panic("ilock");
    80003496:	00004517          	auipc	a0,0x4
    8000349a:	0fa50513          	addi	a0,a0,250 # 80007590 <userret+0x500>
    8000349e:	ffffd097          	auipc	ra,0xffffd
    800034a2:	0aa080e7          	jalr	170(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034a6:	40dc                	lw	a5,4(s1)
    800034a8:	0047d79b          	srliw	a5,a5,0x4
    800034ac:	0001d597          	auipc	a1,0x1d
    800034b0:	a3c5a583          	lw	a1,-1476(a1) # 8001fee8 <sb+0x18>
    800034b4:	9dbd                	addw	a1,a1,a5
    800034b6:	4088                	lw	a0,0(s1)
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	7a6080e7          	jalr	1958(ra) # 80002c5e <bread>
    800034c0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800034c2:	06050593          	addi	a1,a0,96
    800034c6:	40dc                	lw	a5,4(s1)
    800034c8:	8bbd                	andi	a5,a5,15
    800034ca:	079a                	slli	a5,a5,0x6
    800034cc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800034ce:	00059783          	lh	a5,0(a1)
    800034d2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800034d6:	00259783          	lh	a5,2(a1)
    800034da:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800034de:	00459783          	lh	a5,4(a1)
    800034e2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034e6:	00659783          	lh	a5,6(a1)
    800034ea:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034ee:	459c                	lw	a5,8(a1)
    800034f0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800034f2:	03400613          	li	a2,52
    800034f6:	05b1                	addi	a1,a1,12
    800034f8:	05048513          	addi	a0,s1,80
    800034fc:	ffffd097          	auipc	ra,0xffffd
    80003500:	6fa080e7          	jalr	1786(ra) # 80000bf6 <memmove>
    brelse(bp);
    80003504:	854a                	mv	a0,s2
    80003506:	00000097          	auipc	ra,0x0
    8000350a:	88c080e7          	jalr	-1908(ra) # 80002d92 <brelse>
    ip->valid = 1;
    8000350e:	4785                	li	a5,1
    80003510:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003512:	04449783          	lh	a5,68(s1)
    80003516:	fbb5                	bnez	a5,8000348a <ilock+0x24>
      panic("ilock: no type");
    80003518:	00004517          	auipc	a0,0x4
    8000351c:	08050513          	addi	a0,a0,128 # 80007598 <userret+0x508>
    80003520:	ffffd097          	auipc	ra,0xffffd
    80003524:	028080e7          	jalr	40(ra) # 80000548 <panic>

0000000080003528 <iunlock>:
{
    80003528:	1101                	addi	sp,sp,-32
    8000352a:	ec06                	sd	ra,24(sp)
    8000352c:	e822                	sd	s0,16(sp)
    8000352e:	e426                	sd	s1,8(sp)
    80003530:	e04a                	sd	s2,0(sp)
    80003532:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003534:	c905                	beqz	a0,80003564 <iunlock+0x3c>
    80003536:	84aa                	mv	s1,a0
    80003538:	01050913          	addi	s2,a0,16
    8000353c:	854a                	mv	a0,s2
    8000353e:	00001097          	auipc	ra,0x1
    80003542:	ec0080e7          	jalr	-320(ra) # 800043fe <holdingsleep>
    80003546:	cd19                	beqz	a0,80003564 <iunlock+0x3c>
    80003548:	449c                	lw	a5,8(s1)
    8000354a:	00f05d63          	blez	a5,80003564 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000354e:	854a                	mv	a0,s2
    80003550:	00001097          	auipc	ra,0x1
    80003554:	e6a080e7          	jalr	-406(ra) # 800043ba <releasesleep>
}
    80003558:	60e2                	ld	ra,24(sp)
    8000355a:	6442                	ld	s0,16(sp)
    8000355c:	64a2                	ld	s1,8(sp)
    8000355e:	6902                	ld	s2,0(sp)
    80003560:	6105                	addi	sp,sp,32
    80003562:	8082                	ret
    panic("iunlock");
    80003564:	00004517          	auipc	a0,0x4
    80003568:	04450513          	addi	a0,a0,68 # 800075a8 <userret+0x518>
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	fdc080e7          	jalr	-36(ra) # 80000548 <panic>

0000000080003574 <iput>:
{
    80003574:	7139                	addi	sp,sp,-64
    80003576:	fc06                	sd	ra,56(sp)
    80003578:	f822                	sd	s0,48(sp)
    8000357a:	f426                	sd	s1,40(sp)
    8000357c:	f04a                	sd	s2,32(sp)
    8000357e:	ec4e                	sd	s3,24(sp)
    80003580:	e852                	sd	s4,16(sp)
    80003582:	e456                	sd	s5,8(sp)
    80003584:	0080                	addi	s0,sp,64
    80003586:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003588:	0001d517          	auipc	a0,0x1d
    8000358c:	96850513          	addi	a0,a0,-1688 # 8001fef0 <icache>
    80003590:	ffffd097          	auipc	ra,0xffffd
    80003594:	546080e7          	jalr	1350(ra) # 80000ad6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003598:	4498                	lw	a4,8(s1)
    8000359a:	4785                	li	a5,1
    8000359c:	02f70663          	beq	a4,a5,800035c8 <iput+0x54>
  ip->ref--;
    800035a0:	449c                	lw	a5,8(s1)
    800035a2:	37fd                	addiw	a5,a5,-1
    800035a4:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035a6:	0001d517          	auipc	a0,0x1d
    800035aa:	94a50513          	addi	a0,a0,-1718 # 8001fef0 <icache>
    800035ae:	ffffd097          	auipc	ra,0xffffd
    800035b2:	590080e7          	jalr	1424(ra) # 80000b3e <release>
}
    800035b6:	70e2                	ld	ra,56(sp)
    800035b8:	7442                	ld	s0,48(sp)
    800035ba:	74a2                	ld	s1,40(sp)
    800035bc:	7902                	ld	s2,32(sp)
    800035be:	69e2                	ld	s3,24(sp)
    800035c0:	6a42                	ld	s4,16(sp)
    800035c2:	6aa2                	ld	s5,8(sp)
    800035c4:	6121                	addi	sp,sp,64
    800035c6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800035c8:	40bc                	lw	a5,64(s1)
    800035ca:	dbf9                	beqz	a5,800035a0 <iput+0x2c>
    800035cc:	04a49783          	lh	a5,74(s1)
    800035d0:	fbe1                	bnez	a5,800035a0 <iput+0x2c>
    acquiresleep(&ip->lock);
    800035d2:	01048a13          	addi	s4,s1,16
    800035d6:	8552                	mv	a0,s4
    800035d8:	00001097          	auipc	ra,0x1
    800035dc:	d8c080e7          	jalr	-628(ra) # 80004364 <acquiresleep>
    release(&icache.lock);
    800035e0:	0001d517          	auipc	a0,0x1d
    800035e4:	91050513          	addi	a0,a0,-1776 # 8001fef0 <icache>
    800035e8:	ffffd097          	auipc	ra,0xffffd
    800035ec:	556080e7          	jalr	1366(ra) # 80000b3e <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800035f0:	05048913          	addi	s2,s1,80
    800035f4:	08048993          	addi	s3,s1,128
    800035f8:	a021                	j	80003600 <iput+0x8c>
    800035fa:	0911                	addi	s2,s2,4
    800035fc:	01390d63          	beq	s2,s3,80003616 <iput+0xa2>
    if(ip->addrs[i]){
    80003600:	00092583          	lw	a1,0(s2)
    80003604:	d9fd                	beqz	a1,800035fa <iput+0x86>
      bfree(ip->dev, ip->addrs[i]);
    80003606:	4088                	lw	a0,0(s1)
    80003608:	00000097          	auipc	ra,0x0
    8000360c:	8a0080e7          	jalr	-1888(ra) # 80002ea8 <bfree>
      ip->addrs[i] = 0;
    80003610:	00092023          	sw	zero,0(s2)
    80003614:	b7dd                	j	800035fa <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003616:	0804a583          	lw	a1,128(s1)
    8000361a:	ed9d                	bnez	a1,80003658 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000361c:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    80003620:	8526                	mv	a0,s1
    80003622:	00000097          	auipc	ra,0x0
    80003626:	d7a080e7          	jalr	-646(ra) # 8000339c <iupdate>
    ip->type = 0;
    8000362a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000362e:	8526                	mv	a0,s1
    80003630:	00000097          	auipc	ra,0x0
    80003634:	d6c080e7          	jalr	-660(ra) # 8000339c <iupdate>
    ip->valid = 0;
    80003638:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000363c:	8552                	mv	a0,s4
    8000363e:	00001097          	auipc	ra,0x1
    80003642:	d7c080e7          	jalr	-644(ra) # 800043ba <releasesleep>
    acquire(&icache.lock);
    80003646:	0001d517          	auipc	a0,0x1d
    8000364a:	8aa50513          	addi	a0,a0,-1878 # 8001fef0 <icache>
    8000364e:	ffffd097          	auipc	ra,0xffffd
    80003652:	488080e7          	jalr	1160(ra) # 80000ad6 <acquire>
    80003656:	b7a9                	j	800035a0 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003658:	4088                	lw	a0,0(s1)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	604080e7          	jalr	1540(ra) # 80002c5e <bread>
    80003662:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80003664:	06050913          	addi	s2,a0,96
    80003668:	46050993          	addi	s3,a0,1120
    8000366c:	a021                	j	80003674 <iput+0x100>
    8000366e:	0911                	addi	s2,s2,4
    80003670:	01390b63          	beq	s2,s3,80003686 <iput+0x112>
      if(a[j])
    80003674:	00092583          	lw	a1,0(s2)
    80003678:	d9fd                	beqz	a1,8000366e <iput+0xfa>
        bfree(ip->dev, a[j]);
    8000367a:	4088                	lw	a0,0(s1)
    8000367c:	00000097          	auipc	ra,0x0
    80003680:	82c080e7          	jalr	-2004(ra) # 80002ea8 <bfree>
    80003684:	b7ed                	j	8000366e <iput+0xfa>
    brelse(bp);
    80003686:	8556                	mv	a0,s5
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	70a080e7          	jalr	1802(ra) # 80002d92 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003690:	0804a583          	lw	a1,128(s1)
    80003694:	4088                	lw	a0,0(s1)
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	812080e7          	jalr	-2030(ra) # 80002ea8 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000369e:	0804a023          	sw	zero,128(s1)
    800036a2:	bfad                	j	8000361c <iput+0xa8>

00000000800036a4 <iunlockput>:
{
    800036a4:	1101                	addi	sp,sp,-32
    800036a6:	ec06                	sd	ra,24(sp)
    800036a8:	e822                	sd	s0,16(sp)
    800036aa:	e426                	sd	s1,8(sp)
    800036ac:	1000                	addi	s0,sp,32
    800036ae:	84aa                	mv	s1,a0
  iunlock(ip);
    800036b0:	00000097          	auipc	ra,0x0
    800036b4:	e78080e7          	jalr	-392(ra) # 80003528 <iunlock>
  iput(ip);
    800036b8:	8526                	mv	a0,s1
    800036ba:	00000097          	auipc	ra,0x0
    800036be:	eba080e7          	jalr	-326(ra) # 80003574 <iput>
}
    800036c2:	60e2                	ld	ra,24(sp)
    800036c4:	6442                	ld	s0,16(sp)
    800036c6:	64a2                	ld	s1,8(sp)
    800036c8:	6105                	addi	sp,sp,32
    800036ca:	8082                	ret

00000000800036cc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800036cc:	1141                	addi	sp,sp,-16
    800036ce:	e422                	sd	s0,8(sp)
    800036d0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800036d2:	411c                	lw	a5,0(a0)
    800036d4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800036d6:	415c                	lw	a5,4(a0)
    800036d8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800036da:	04451783          	lh	a5,68(a0)
    800036de:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036e2:	04a51783          	lh	a5,74(a0)
    800036e6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036ea:	04c56783          	lwu	a5,76(a0)
    800036ee:	e99c                	sd	a5,16(a1)
}
    800036f0:	6422                	ld	s0,8(sp)
    800036f2:	0141                	addi	sp,sp,16
    800036f4:	8082                	ret

00000000800036f6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036f6:	457c                	lw	a5,76(a0)
    800036f8:	0ed7e563          	bltu	a5,a3,800037e2 <readi+0xec>
{
    800036fc:	7159                	addi	sp,sp,-112
    800036fe:	f486                	sd	ra,104(sp)
    80003700:	f0a2                	sd	s0,96(sp)
    80003702:	eca6                	sd	s1,88(sp)
    80003704:	e8ca                	sd	s2,80(sp)
    80003706:	e4ce                	sd	s3,72(sp)
    80003708:	e0d2                	sd	s4,64(sp)
    8000370a:	fc56                	sd	s5,56(sp)
    8000370c:	f85a                	sd	s6,48(sp)
    8000370e:	f45e                	sd	s7,40(sp)
    80003710:	f062                	sd	s8,32(sp)
    80003712:	ec66                	sd	s9,24(sp)
    80003714:	e86a                	sd	s10,16(sp)
    80003716:	e46e                	sd	s11,8(sp)
    80003718:	1880                	addi	s0,sp,112
    8000371a:	8baa                	mv	s7,a0
    8000371c:	8c2e                	mv	s8,a1
    8000371e:	8ab2                	mv	s5,a2
    80003720:	8936                	mv	s2,a3
    80003722:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003724:	9f35                	addw	a4,a4,a3
    80003726:	0cd76063          	bltu	a4,a3,800037e6 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    8000372a:	00e7f463          	bgeu	a5,a4,80003732 <readi+0x3c>
    n = ip->size - off;
    8000372e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003732:	080b0763          	beqz	s6,800037c0 <readi+0xca>
    80003736:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003738:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000373c:	5cfd                	li	s9,-1
    8000373e:	a82d                	j	80003778 <readi+0x82>
    80003740:	02099d93          	slli	s11,s3,0x20
    80003744:	020ddd93          	srli	s11,s11,0x20
    80003748:	06048793          	addi	a5,s1,96
    8000374c:	86ee                	mv	a3,s11
    8000374e:	963e                	add	a2,a2,a5
    80003750:	85d6                	mv	a1,s5
    80003752:	8562                	mv	a0,s8
    80003754:	fffff097          	auipc	ra,0xfffff
    80003758:	b52080e7          	jalr	-1198(ra) # 800022a6 <either_copyout>
    8000375c:	05950d63          	beq	a0,s9,800037b6 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003760:	8526                	mv	a0,s1
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	630080e7          	jalr	1584(ra) # 80002d92 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000376a:	01498a3b          	addw	s4,s3,s4
    8000376e:	0129893b          	addw	s2,s3,s2
    80003772:	9aee                	add	s5,s5,s11
    80003774:	056a7663          	bgeu	s4,s6,800037c0 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003778:	000ba483          	lw	s1,0(s7)
    8000377c:	00a9559b          	srliw	a1,s2,0xa
    80003780:	855e                	mv	a0,s7
    80003782:	00000097          	auipc	ra,0x0
    80003786:	8d4080e7          	jalr	-1836(ra) # 80003056 <bmap>
    8000378a:	0005059b          	sext.w	a1,a0
    8000378e:	8526                	mv	a0,s1
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	4ce080e7          	jalr	1230(ra) # 80002c5e <bread>
    80003798:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000379a:	3ff97613          	andi	a2,s2,1023
    8000379e:	40cd07bb          	subw	a5,s10,a2
    800037a2:	414b073b          	subw	a4,s6,s4
    800037a6:	89be                	mv	s3,a5
    800037a8:	2781                	sext.w	a5,a5
    800037aa:	0007069b          	sext.w	a3,a4
    800037ae:	f8f6f9e3          	bgeu	a3,a5,80003740 <readi+0x4a>
    800037b2:	89ba                	mv	s3,a4
    800037b4:	b771                	j	80003740 <readi+0x4a>
      brelse(bp);
    800037b6:	8526                	mv	a0,s1
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	5da080e7          	jalr	1498(ra) # 80002d92 <brelse>
  }
  return n;
    800037c0:	000b051b          	sext.w	a0,s6
}
    800037c4:	70a6                	ld	ra,104(sp)
    800037c6:	7406                	ld	s0,96(sp)
    800037c8:	64e6                	ld	s1,88(sp)
    800037ca:	6946                	ld	s2,80(sp)
    800037cc:	69a6                	ld	s3,72(sp)
    800037ce:	6a06                	ld	s4,64(sp)
    800037d0:	7ae2                	ld	s5,56(sp)
    800037d2:	7b42                	ld	s6,48(sp)
    800037d4:	7ba2                	ld	s7,40(sp)
    800037d6:	7c02                	ld	s8,32(sp)
    800037d8:	6ce2                	ld	s9,24(sp)
    800037da:	6d42                	ld	s10,16(sp)
    800037dc:	6da2                	ld	s11,8(sp)
    800037de:	6165                	addi	sp,sp,112
    800037e0:	8082                	ret
    return -1;
    800037e2:	557d                	li	a0,-1
}
    800037e4:	8082                	ret
    return -1;
    800037e6:	557d                	li	a0,-1
    800037e8:	bff1                	j	800037c4 <readi+0xce>

00000000800037ea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037ea:	457c                	lw	a5,76(a0)
    800037ec:	10d7e763          	bltu	a5,a3,800038fa <writei+0x110>
{
    800037f0:	7159                	addi	sp,sp,-112
    800037f2:	f486                	sd	ra,104(sp)
    800037f4:	f0a2                	sd	s0,96(sp)
    800037f6:	eca6                	sd	s1,88(sp)
    800037f8:	e8ca                	sd	s2,80(sp)
    800037fa:	e4ce                	sd	s3,72(sp)
    800037fc:	e0d2                	sd	s4,64(sp)
    800037fe:	fc56                	sd	s5,56(sp)
    80003800:	f85a                	sd	s6,48(sp)
    80003802:	f45e                	sd	s7,40(sp)
    80003804:	f062                	sd	s8,32(sp)
    80003806:	ec66                	sd	s9,24(sp)
    80003808:	e86a                	sd	s10,16(sp)
    8000380a:	e46e                	sd	s11,8(sp)
    8000380c:	1880                	addi	s0,sp,112
    8000380e:	8baa                	mv	s7,a0
    80003810:	8c2e                	mv	s8,a1
    80003812:	8ab2                	mv	s5,a2
    80003814:	8936                	mv	s2,a3
    80003816:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003818:	00e687bb          	addw	a5,a3,a4
    8000381c:	0ed7e163          	bltu	a5,a3,800038fe <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003820:	00043737          	lui	a4,0x43
    80003824:	0cf76f63          	bltu	a4,a5,80003902 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003828:	0a0b0063          	beqz	s6,800038c8 <writei+0xde>
    8000382c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000382e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003832:	5cfd                	li	s9,-1
    80003834:	a091                	j	80003878 <writei+0x8e>
    80003836:	02099d93          	slli	s11,s3,0x20
    8000383a:	020ddd93          	srli	s11,s11,0x20
    8000383e:	06048793          	addi	a5,s1,96
    80003842:	86ee                	mv	a3,s11
    80003844:	8656                	mv	a2,s5
    80003846:	85e2                	mv	a1,s8
    80003848:	953e                	add	a0,a0,a5
    8000384a:	fffff097          	auipc	ra,0xfffff
    8000384e:	ab2080e7          	jalr	-1358(ra) # 800022fc <either_copyin>
    80003852:	07950263          	beq	a0,s9,800038b6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003856:	8526                	mv	a0,s1
    80003858:	00001097          	auipc	ra,0x1
    8000385c:	874080e7          	jalr	-1932(ra) # 800040cc <log_write>
    brelse(bp);
    80003860:	8526                	mv	a0,s1
    80003862:	fffff097          	auipc	ra,0xfffff
    80003866:	530080e7          	jalr	1328(ra) # 80002d92 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000386a:	01498a3b          	addw	s4,s3,s4
    8000386e:	0129893b          	addw	s2,s3,s2
    80003872:	9aee                	add	s5,s5,s11
    80003874:	056a7663          	bgeu	s4,s6,800038c0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003878:	000ba483          	lw	s1,0(s7)
    8000387c:	00a9559b          	srliw	a1,s2,0xa
    80003880:	855e                	mv	a0,s7
    80003882:	fffff097          	auipc	ra,0xfffff
    80003886:	7d4080e7          	jalr	2004(ra) # 80003056 <bmap>
    8000388a:	0005059b          	sext.w	a1,a0
    8000388e:	8526                	mv	a0,s1
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	3ce080e7          	jalr	974(ra) # 80002c5e <bread>
    80003898:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000389a:	3ff97513          	andi	a0,s2,1023
    8000389e:	40ad07bb          	subw	a5,s10,a0
    800038a2:	414b073b          	subw	a4,s6,s4
    800038a6:	89be                	mv	s3,a5
    800038a8:	2781                	sext.w	a5,a5
    800038aa:	0007069b          	sext.w	a3,a4
    800038ae:	f8f6f4e3          	bgeu	a3,a5,80003836 <writei+0x4c>
    800038b2:	89ba                	mv	s3,a4
    800038b4:	b749                	j	80003836 <writei+0x4c>
      brelse(bp);
    800038b6:	8526                	mv	a0,s1
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	4da080e7          	jalr	1242(ra) # 80002d92 <brelse>
  }

  if(n > 0 && off > ip->size){
    800038c0:	04cba783          	lw	a5,76(s7)
    800038c4:	0327e363          	bltu	a5,s2,800038ea <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
    800038c8:	000b051b          	sext.w	a0,s6
}
    800038cc:	70a6                	ld	ra,104(sp)
    800038ce:	7406                	ld	s0,96(sp)
    800038d0:	64e6                	ld	s1,88(sp)
    800038d2:	6946                	ld	s2,80(sp)
    800038d4:	69a6                	ld	s3,72(sp)
    800038d6:	6a06                	ld	s4,64(sp)
    800038d8:	7ae2                	ld	s5,56(sp)
    800038da:	7b42                	ld	s6,48(sp)
    800038dc:	7ba2                	ld	s7,40(sp)
    800038de:	7c02                	ld	s8,32(sp)
    800038e0:	6ce2                	ld	s9,24(sp)
    800038e2:	6d42                	ld	s10,16(sp)
    800038e4:	6da2                	ld	s11,8(sp)
    800038e6:	6165                	addi	sp,sp,112
    800038e8:	8082                	ret
    ip->size = off;
    800038ea:	052ba623          	sw	s2,76(s7)
    iupdate(ip);
    800038ee:	855e                	mv	a0,s7
    800038f0:	00000097          	auipc	ra,0x0
    800038f4:	aac080e7          	jalr	-1364(ra) # 8000339c <iupdate>
    800038f8:	bfc1                	j	800038c8 <writei+0xde>
    return -1;
    800038fa:	557d                	li	a0,-1
}
    800038fc:	8082                	ret
    return -1;
    800038fe:	557d                	li	a0,-1
    80003900:	b7f1                	j	800038cc <writei+0xe2>
    return -1;
    80003902:	557d                	li	a0,-1
    80003904:	b7e1                	j	800038cc <writei+0xe2>

0000000080003906 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003906:	1141                	addi	sp,sp,-16
    80003908:	e406                	sd	ra,8(sp)
    8000390a:	e022                	sd	s0,0(sp)
    8000390c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000390e:	4639                	li	a2,14
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	362080e7          	jalr	866(ra) # 80000c72 <strncmp>
}
    80003918:	60a2                	ld	ra,8(sp)
    8000391a:	6402                	ld	s0,0(sp)
    8000391c:	0141                	addi	sp,sp,16
    8000391e:	8082                	ret

0000000080003920 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003920:	7139                	addi	sp,sp,-64
    80003922:	fc06                	sd	ra,56(sp)
    80003924:	f822                	sd	s0,48(sp)
    80003926:	f426                	sd	s1,40(sp)
    80003928:	f04a                	sd	s2,32(sp)
    8000392a:	ec4e                	sd	s3,24(sp)
    8000392c:	e852                	sd	s4,16(sp)
    8000392e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003930:	04451703          	lh	a4,68(a0)
    80003934:	4785                	li	a5,1
    80003936:	00f71a63          	bne	a4,a5,8000394a <dirlookup+0x2a>
    8000393a:	892a                	mv	s2,a0
    8000393c:	89ae                	mv	s3,a1
    8000393e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003940:	457c                	lw	a5,76(a0)
    80003942:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003944:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003946:	e79d                	bnez	a5,80003974 <dirlookup+0x54>
    80003948:	a8a5                	j	800039c0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000394a:	00004517          	auipc	a0,0x4
    8000394e:	c6650513          	addi	a0,a0,-922 # 800075b0 <userret+0x520>
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	bf6080e7          	jalr	-1034(ra) # 80000548 <panic>
      panic("dirlookup read");
    8000395a:	00004517          	auipc	a0,0x4
    8000395e:	c6e50513          	addi	a0,a0,-914 # 800075c8 <userret+0x538>
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	be6080e7          	jalr	-1050(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000396a:	24c1                	addiw	s1,s1,16
    8000396c:	04c92783          	lw	a5,76(s2)
    80003970:	04f4f763          	bgeu	s1,a5,800039be <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003974:	4741                	li	a4,16
    80003976:	86a6                	mv	a3,s1
    80003978:	fc040613          	addi	a2,s0,-64
    8000397c:	4581                	li	a1,0
    8000397e:	854a                	mv	a0,s2
    80003980:	00000097          	auipc	ra,0x0
    80003984:	d76080e7          	jalr	-650(ra) # 800036f6 <readi>
    80003988:	47c1                	li	a5,16
    8000398a:	fcf518e3          	bne	a0,a5,8000395a <dirlookup+0x3a>
    if(de.inum == 0)
    8000398e:	fc045783          	lhu	a5,-64(s0)
    80003992:	dfe1                	beqz	a5,8000396a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003994:	fc240593          	addi	a1,s0,-62
    80003998:	854e                	mv	a0,s3
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	f6c080e7          	jalr	-148(ra) # 80003906 <namecmp>
    800039a2:	f561                	bnez	a0,8000396a <dirlookup+0x4a>
      if(poff)
    800039a4:	000a0463          	beqz	s4,800039ac <dirlookup+0x8c>
        *poff = off;
    800039a8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800039ac:	fc045583          	lhu	a1,-64(s0)
    800039b0:	00092503          	lw	a0,0(s2)
    800039b4:	fffff097          	auipc	ra,0xfffff
    800039b8:	77e080e7          	jalr	1918(ra) # 80003132 <iget>
    800039bc:	a011                	j	800039c0 <dirlookup+0xa0>
  return 0;
    800039be:	4501                	li	a0,0
}
    800039c0:	70e2                	ld	ra,56(sp)
    800039c2:	7442                	ld	s0,48(sp)
    800039c4:	74a2                	ld	s1,40(sp)
    800039c6:	7902                	ld	s2,32(sp)
    800039c8:	69e2                	ld	s3,24(sp)
    800039ca:	6a42                	ld	s4,16(sp)
    800039cc:	6121                	addi	sp,sp,64
    800039ce:	8082                	ret

00000000800039d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800039d0:	711d                	addi	sp,sp,-96
    800039d2:	ec86                	sd	ra,88(sp)
    800039d4:	e8a2                	sd	s0,80(sp)
    800039d6:	e4a6                	sd	s1,72(sp)
    800039d8:	e0ca                	sd	s2,64(sp)
    800039da:	fc4e                	sd	s3,56(sp)
    800039dc:	f852                	sd	s4,48(sp)
    800039de:	f456                	sd	s5,40(sp)
    800039e0:	f05a                	sd	s6,32(sp)
    800039e2:	ec5e                	sd	s7,24(sp)
    800039e4:	e862                	sd	s8,16(sp)
    800039e6:	e466                	sd	s9,8(sp)
    800039e8:	1080                	addi	s0,sp,96
    800039ea:	84aa                	mv	s1,a0
    800039ec:	8aae                	mv	s5,a1
    800039ee:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800039f0:	00054703          	lbu	a4,0(a0)
    800039f4:	02f00793          	li	a5,47
    800039f8:	02f70363          	beq	a4,a5,80003a1e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800039fc:	ffffe097          	auipc	ra,0xffffe
    80003a00:	e3a080e7          	jalr	-454(ra) # 80001836 <myproc>
    80003a04:	15053503          	ld	a0,336(a0)
    80003a08:	00000097          	auipc	ra,0x0
    80003a0c:	a20080e7          	jalr	-1504(ra) # 80003428 <idup>
    80003a10:	89aa                	mv	s3,a0
  while(*path == '/')
    80003a12:	02f00913          	li	s2,47
  len = path - s;
    80003a16:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003a18:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003a1a:	4b85                	li	s7,1
    80003a1c:	a865                	j	80003ad4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003a1e:	4585                	li	a1,1
    80003a20:	4501                	li	a0,0
    80003a22:	fffff097          	auipc	ra,0xfffff
    80003a26:	710080e7          	jalr	1808(ra) # 80003132 <iget>
    80003a2a:	89aa                	mv	s3,a0
    80003a2c:	b7dd                	j	80003a12 <namex+0x42>
      iunlockput(ip);
    80003a2e:	854e                	mv	a0,s3
    80003a30:	00000097          	auipc	ra,0x0
    80003a34:	c74080e7          	jalr	-908(ra) # 800036a4 <iunlockput>
      return 0;
    80003a38:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a3a:	854e                	mv	a0,s3
    80003a3c:	60e6                	ld	ra,88(sp)
    80003a3e:	6446                	ld	s0,80(sp)
    80003a40:	64a6                	ld	s1,72(sp)
    80003a42:	6906                	ld	s2,64(sp)
    80003a44:	79e2                	ld	s3,56(sp)
    80003a46:	7a42                	ld	s4,48(sp)
    80003a48:	7aa2                	ld	s5,40(sp)
    80003a4a:	7b02                	ld	s6,32(sp)
    80003a4c:	6be2                	ld	s7,24(sp)
    80003a4e:	6c42                	ld	s8,16(sp)
    80003a50:	6ca2                	ld	s9,8(sp)
    80003a52:	6125                	addi	sp,sp,96
    80003a54:	8082                	ret
      iunlock(ip);
    80003a56:	854e                	mv	a0,s3
    80003a58:	00000097          	auipc	ra,0x0
    80003a5c:	ad0080e7          	jalr	-1328(ra) # 80003528 <iunlock>
      return ip;
    80003a60:	bfe9                	j	80003a3a <namex+0x6a>
      iunlockput(ip);
    80003a62:	854e                	mv	a0,s3
    80003a64:	00000097          	auipc	ra,0x0
    80003a68:	c40080e7          	jalr	-960(ra) # 800036a4 <iunlockput>
      return 0;
    80003a6c:	89e6                	mv	s3,s9
    80003a6e:	b7f1                	j	80003a3a <namex+0x6a>
  len = path - s;
    80003a70:	40b48633          	sub	a2,s1,a1
    80003a74:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003a78:	099c5463          	bge	s8,s9,80003b00 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003a7c:	4639                	li	a2,14
    80003a7e:	8552                	mv	a0,s4
    80003a80:	ffffd097          	auipc	ra,0xffffd
    80003a84:	176080e7          	jalr	374(ra) # 80000bf6 <memmove>
  while(*path == '/')
    80003a88:	0004c783          	lbu	a5,0(s1)
    80003a8c:	01279763          	bne	a5,s2,80003a9a <namex+0xca>
    path++;
    80003a90:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a92:	0004c783          	lbu	a5,0(s1)
    80003a96:	ff278de3          	beq	a5,s2,80003a90 <namex+0xc0>
    ilock(ip);
    80003a9a:	854e                	mv	a0,s3
    80003a9c:	00000097          	auipc	ra,0x0
    80003aa0:	9ca080e7          	jalr	-1590(ra) # 80003466 <ilock>
    if(ip->type != T_DIR){
    80003aa4:	04499783          	lh	a5,68(s3)
    80003aa8:	f97793e3          	bne	a5,s7,80003a2e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003aac:	000a8563          	beqz	s5,80003ab6 <namex+0xe6>
    80003ab0:	0004c783          	lbu	a5,0(s1)
    80003ab4:	d3cd                	beqz	a5,80003a56 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ab6:	865a                	mv	a2,s6
    80003ab8:	85d2                	mv	a1,s4
    80003aba:	854e                	mv	a0,s3
    80003abc:	00000097          	auipc	ra,0x0
    80003ac0:	e64080e7          	jalr	-412(ra) # 80003920 <dirlookup>
    80003ac4:	8caa                	mv	s9,a0
    80003ac6:	dd51                	beqz	a0,80003a62 <namex+0x92>
    iunlockput(ip);
    80003ac8:	854e                	mv	a0,s3
    80003aca:	00000097          	auipc	ra,0x0
    80003ace:	bda080e7          	jalr	-1062(ra) # 800036a4 <iunlockput>
    ip = next;
    80003ad2:	89e6                	mv	s3,s9
  while(*path == '/')
    80003ad4:	0004c783          	lbu	a5,0(s1)
    80003ad8:	05279763          	bne	a5,s2,80003b26 <namex+0x156>
    path++;
    80003adc:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ade:	0004c783          	lbu	a5,0(s1)
    80003ae2:	ff278de3          	beq	a5,s2,80003adc <namex+0x10c>
  if(*path == 0)
    80003ae6:	c79d                	beqz	a5,80003b14 <namex+0x144>
    path++;
    80003ae8:	85a6                	mv	a1,s1
  len = path - s;
    80003aea:	8cda                	mv	s9,s6
    80003aec:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003aee:	01278963          	beq	a5,s2,80003b00 <namex+0x130>
    80003af2:	dfbd                	beqz	a5,80003a70 <namex+0xa0>
    path++;
    80003af4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003af6:	0004c783          	lbu	a5,0(s1)
    80003afa:	ff279ce3          	bne	a5,s2,80003af2 <namex+0x122>
    80003afe:	bf8d                	j	80003a70 <namex+0xa0>
    memmove(name, s, len);
    80003b00:	2601                	sext.w	a2,a2
    80003b02:	8552                	mv	a0,s4
    80003b04:	ffffd097          	auipc	ra,0xffffd
    80003b08:	0f2080e7          	jalr	242(ra) # 80000bf6 <memmove>
    name[len] = 0;
    80003b0c:	9cd2                	add	s9,s9,s4
    80003b0e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003b12:	bf9d                	j	80003a88 <namex+0xb8>
  if(nameiparent){
    80003b14:	f20a83e3          	beqz	s5,80003a3a <namex+0x6a>
    iput(ip);
    80003b18:	854e                	mv	a0,s3
    80003b1a:	00000097          	auipc	ra,0x0
    80003b1e:	a5a080e7          	jalr	-1446(ra) # 80003574 <iput>
    return 0;
    80003b22:	4981                	li	s3,0
    80003b24:	bf19                	j	80003a3a <namex+0x6a>
  if(*path == 0)
    80003b26:	d7fd                	beqz	a5,80003b14 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003b28:	0004c783          	lbu	a5,0(s1)
    80003b2c:	85a6                	mv	a1,s1
    80003b2e:	b7d1                	j	80003af2 <namex+0x122>

0000000080003b30 <dirlink>:
{
    80003b30:	7139                	addi	sp,sp,-64
    80003b32:	fc06                	sd	ra,56(sp)
    80003b34:	f822                	sd	s0,48(sp)
    80003b36:	f426                	sd	s1,40(sp)
    80003b38:	f04a                	sd	s2,32(sp)
    80003b3a:	ec4e                	sd	s3,24(sp)
    80003b3c:	e852                	sd	s4,16(sp)
    80003b3e:	0080                	addi	s0,sp,64
    80003b40:	892a                	mv	s2,a0
    80003b42:	8a2e                	mv	s4,a1
    80003b44:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003b46:	4601                	li	a2,0
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	dd8080e7          	jalr	-552(ra) # 80003920 <dirlookup>
    80003b50:	e93d                	bnez	a0,80003bc6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b52:	04c92483          	lw	s1,76(s2)
    80003b56:	c49d                	beqz	s1,80003b84 <dirlink+0x54>
    80003b58:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b5a:	4741                	li	a4,16
    80003b5c:	86a6                	mv	a3,s1
    80003b5e:	fc040613          	addi	a2,s0,-64
    80003b62:	4581                	li	a1,0
    80003b64:	854a                	mv	a0,s2
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	b90080e7          	jalr	-1136(ra) # 800036f6 <readi>
    80003b6e:	47c1                	li	a5,16
    80003b70:	06f51163          	bne	a0,a5,80003bd2 <dirlink+0xa2>
    if(de.inum == 0)
    80003b74:	fc045783          	lhu	a5,-64(s0)
    80003b78:	c791                	beqz	a5,80003b84 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b7a:	24c1                	addiw	s1,s1,16
    80003b7c:	04c92783          	lw	a5,76(s2)
    80003b80:	fcf4ede3          	bltu	s1,a5,80003b5a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003b84:	4639                	li	a2,14
    80003b86:	85d2                	mv	a1,s4
    80003b88:	fc240513          	addi	a0,s0,-62
    80003b8c:	ffffd097          	auipc	ra,0xffffd
    80003b90:	122080e7          	jalr	290(ra) # 80000cae <strncpy>
  de.inum = inum;
    80003b94:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b98:	4741                	li	a4,16
    80003b9a:	86a6                	mv	a3,s1
    80003b9c:	fc040613          	addi	a2,s0,-64
    80003ba0:	4581                	li	a1,0
    80003ba2:	854a                	mv	a0,s2
    80003ba4:	00000097          	auipc	ra,0x0
    80003ba8:	c46080e7          	jalr	-954(ra) # 800037ea <writei>
    80003bac:	872a                	mv	a4,a0
    80003bae:	47c1                	li	a5,16
  return 0;
    80003bb0:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bb2:	02f71863          	bne	a4,a5,80003be2 <dirlink+0xb2>
}
    80003bb6:	70e2                	ld	ra,56(sp)
    80003bb8:	7442                	ld	s0,48(sp)
    80003bba:	74a2                	ld	s1,40(sp)
    80003bbc:	7902                	ld	s2,32(sp)
    80003bbe:	69e2                	ld	s3,24(sp)
    80003bc0:	6a42                	ld	s4,16(sp)
    80003bc2:	6121                	addi	sp,sp,64
    80003bc4:	8082                	ret
    iput(ip);
    80003bc6:	00000097          	auipc	ra,0x0
    80003bca:	9ae080e7          	jalr	-1618(ra) # 80003574 <iput>
    return -1;
    80003bce:	557d                	li	a0,-1
    80003bd0:	b7dd                	j	80003bb6 <dirlink+0x86>
      panic("dirlink read");
    80003bd2:	00004517          	auipc	a0,0x4
    80003bd6:	a0650513          	addi	a0,a0,-1530 # 800075d8 <userret+0x548>
    80003bda:	ffffd097          	auipc	ra,0xffffd
    80003bde:	96e080e7          	jalr	-1682(ra) # 80000548 <panic>
    panic("dirlink");
    80003be2:	00004517          	auipc	a0,0x4
    80003be6:	ba650513          	addi	a0,a0,-1114 # 80007788 <userret+0x6f8>
    80003bea:	ffffd097          	auipc	ra,0xffffd
    80003bee:	95e080e7          	jalr	-1698(ra) # 80000548 <panic>

0000000080003bf2 <namei>:

struct inode*
namei(char *path)
{
    80003bf2:	1101                	addi	sp,sp,-32
    80003bf4:	ec06                	sd	ra,24(sp)
    80003bf6:	e822                	sd	s0,16(sp)
    80003bf8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003bfa:	fe040613          	addi	a2,s0,-32
    80003bfe:	4581                	li	a1,0
    80003c00:	00000097          	auipc	ra,0x0
    80003c04:	dd0080e7          	jalr	-560(ra) # 800039d0 <namex>
}
    80003c08:	60e2                	ld	ra,24(sp)
    80003c0a:	6442                	ld	s0,16(sp)
    80003c0c:	6105                	addi	sp,sp,32
    80003c0e:	8082                	ret

0000000080003c10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c10:	1141                	addi	sp,sp,-16
    80003c12:	e406                	sd	ra,8(sp)
    80003c14:	e022                	sd	s0,0(sp)
    80003c16:	0800                	addi	s0,sp,16
    80003c18:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003c1a:	4585                	li	a1,1
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	db4080e7          	jalr	-588(ra) # 800039d0 <namex>
}
    80003c24:	60a2                	ld	ra,8(sp)
    80003c26:	6402                	ld	s0,0(sp)
    80003c28:	0141                	addi	sp,sp,16
    80003c2a:	8082                	ret

0000000080003c2c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80003c2c:	7179                	addi	sp,sp,-48
    80003c2e:	f406                	sd	ra,40(sp)
    80003c30:	f022                	sd	s0,32(sp)
    80003c32:	ec26                	sd	s1,24(sp)
    80003c34:	e84a                	sd	s2,16(sp)
    80003c36:	e44e                	sd	s3,8(sp)
    80003c38:	1800                	addi	s0,sp,48
    80003c3a:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80003c3c:	0a800993          	li	s3,168
    80003c40:	033507b3          	mul	a5,a0,s3
    80003c44:	0001e997          	auipc	s3,0x1e
    80003c48:	d5498993          	addi	s3,s3,-684 # 80021998 <log>
    80003c4c:	99be                	add	s3,s3,a5
    80003c4e:	0189a583          	lw	a1,24(s3)
    80003c52:	fffff097          	auipc	ra,0xfffff
    80003c56:	00c080e7          	jalr	12(ra) # 80002c5e <bread>
    80003c5a:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80003c5c:	02c9a783          	lw	a5,44(s3)
    80003c60:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003c62:	02c9a783          	lw	a5,44(s3)
    80003c66:	02f05763          	blez	a5,80003c94 <write_head+0x68>
    80003c6a:	0a800793          	li	a5,168
    80003c6e:	02f487b3          	mul	a5,s1,a5
    80003c72:	0001e717          	auipc	a4,0x1e
    80003c76:	d5670713          	addi	a4,a4,-682 # 800219c8 <log+0x30>
    80003c7a:	97ba                	add	a5,a5,a4
    80003c7c:	06450693          	addi	a3,a0,100
    80003c80:	4701                	li	a4,0
    80003c82:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    80003c84:	4390                	lw	a2,0(a5)
    80003c86:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003c88:	2705                	addiw	a4,a4,1
    80003c8a:	0791                	addi	a5,a5,4
    80003c8c:	0691                	addi	a3,a3,4
    80003c8e:	55d0                	lw	a2,44(a1)
    80003c90:	fec74ae3          	blt	a4,a2,80003c84 <write_head+0x58>
  }
  bwrite(buf);
    80003c94:	854a                	mv	a0,s2
    80003c96:	fffff097          	auipc	ra,0xfffff
    80003c9a:	0bc080e7          	jalr	188(ra) # 80002d52 <bwrite>
  brelse(buf);
    80003c9e:	854a                	mv	a0,s2
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	0f2080e7          	jalr	242(ra) # 80002d92 <brelse>
}
    80003ca8:	70a2                	ld	ra,40(sp)
    80003caa:	7402                	ld	s0,32(sp)
    80003cac:	64e2                	ld	s1,24(sp)
    80003cae:	6942                	ld	s2,16(sp)
    80003cb0:	69a2                	ld	s3,8(sp)
    80003cb2:	6145                	addi	sp,sp,48
    80003cb4:	8082                	ret

0000000080003cb6 <write_log>:
static void
write_log(int dev)
{
  int tail;

  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003cb6:	0a800793          	li	a5,168
    80003cba:	02f50733          	mul	a4,a0,a5
    80003cbe:	0001e797          	auipc	a5,0x1e
    80003cc2:	cda78793          	addi	a5,a5,-806 # 80021998 <log>
    80003cc6:	97ba                	add	a5,a5,a4
    80003cc8:	57dc                	lw	a5,44(a5)
    80003cca:	0af05663          	blez	a5,80003d76 <write_log+0xc0>
{
    80003cce:	7139                	addi	sp,sp,-64
    80003cd0:	fc06                	sd	ra,56(sp)
    80003cd2:	f822                	sd	s0,48(sp)
    80003cd4:	f426                	sd	s1,40(sp)
    80003cd6:	f04a                	sd	s2,32(sp)
    80003cd8:	ec4e                	sd	s3,24(sp)
    80003cda:	e852                	sd	s4,16(sp)
    80003cdc:	e456                	sd	s5,8(sp)
    80003cde:	e05a                	sd	s6,0(sp)
    80003ce0:	0080                	addi	s0,sp,64
    80003ce2:	0001e797          	auipc	a5,0x1e
    80003ce6:	ce678793          	addi	a5,a5,-794 # 800219c8 <log+0x30>
    80003cea:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003cee:	4981                	li	s3,0
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80003cf0:	00050b1b          	sext.w	s6,a0
    80003cf4:	0001ea97          	auipc	s5,0x1e
    80003cf8:	ca4a8a93          	addi	s5,s5,-860 # 80021998 <log>
    80003cfc:	9aba                	add	s5,s5,a4
    80003cfe:	018aa583          	lw	a1,24(s5)
    80003d02:	013585bb          	addw	a1,a1,s3
    80003d06:	2585                	addiw	a1,a1,1
    80003d08:	855a                	mv	a0,s6
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	f54080e7          	jalr	-172(ra) # 80002c5e <bread>
    80003d12:	84aa                	mv	s1,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    80003d14:	000a2583          	lw	a1,0(s4)
    80003d18:	855a                	mv	a0,s6
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	f44080e7          	jalr	-188(ra) # 80002c5e <bread>
    80003d22:	892a                	mv	s2,a0
    memmove(to->data, from->data, BSIZE);
    80003d24:	40000613          	li	a2,1024
    80003d28:	06050593          	addi	a1,a0,96
    80003d2c:	06048513          	addi	a0,s1,96
    80003d30:	ffffd097          	auipc	ra,0xffffd
    80003d34:	ec6080e7          	jalr	-314(ra) # 80000bf6 <memmove>
    bwrite(to);  // write the log
    80003d38:	8526                	mv	a0,s1
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	018080e7          	jalr	24(ra) # 80002d52 <bwrite>
    brelse(from);
    80003d42:	854a                	mv	a0,s2
    80003d44:	fffff097          	auipc	ra,0xfffff
    80003d48:	04e080e7          	jalr	78(ra) # 80002d92 <brelse>
    brelse(to);
    80003d4c:	8526                	mv	a0,s1
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	044080e7          	jalr	68(ra) # 80002d92 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d56:	2985                	addiw	s3,s3,1
    80003d58:	0a11                	addi	s4,s4,4
    80003d5a:	02caa783          	lw	a5,44(s5)
    80003d5e:	faf9c0e3          	blt	s3,a5,80003cfe <write_log+0x48>
  }
}
    80003d62:	70e2                	ld	ra,56(sp)
    80003d64:	7442                	ld	s0,48(sp)
    80003d66:	74a2                	ld	s1,40(sp)
    80003d68:	7902                	ld	s2,32(sp)
    80003d6a:	69e2                	ld	s3,24(sp)
    80003d6c:	6a42                	ld	s4,16(sp)
    80003d6e:	6aa2                	ld	s5,8(sp)
    80003d70:	6b02                	ld	s6,0(sp)
    80003d72:	6121                	addi	sp,sp,64
    80003d74:	8082                	ret
    80003d76:	8082                	ret

0000000080003d78 <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003d78:	0a800793          	li	a5,168
    80003d7c:	02f50733          	mul	a4,a0,a5
    80003d80:	0001e797          	auipc	a5,0x1e
    80003d84:	c1878793          	addi	a5,a5,-1000 # 80021998 <log>
    80003d88:	97ba                	add	a5,a5,a4
    80003d8a:	57dc                	lw	a5,44(a5)
    80003d8c:	0af05b63          	blez	a5,80003e42 <install_trans+0xca>
{
    80003d90:	7139                	addi	sp,sp,-64
    80003d92:	fc06                	sd	ra,56(sp)
    80003d94:	f822                	sd	s0,48(sp)
    80003d96:	f426                	sd	s1,40(sp)
    80003d98:	f04a                	sd	s2,32(sp)
    80003d9a:	ec4e                	sd	s3,24(sp)
    80003d9c:	e852                	sd	s4,16(sp)
    80003d9e:	e456                	sd	s5,8(sp)
    80003da0:	e05a                	sd	s6,0(sp)
    80003da2:	0080                	addi	s0,sp,64
    80003da4:	0001e797          	auipc	a5,0x1e
    80003da8:	c2478793          	addi	a5,a5,-988 # 800219c8 <log+0x30>
    80003dac:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003db0:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    80003db2:	00050b1b          	sext.w	s6,a0
    80003db6:	0001ea97          	auipc	s5,0x1e
    80003dba:	be2a8a93          	addi	s5,s5,-1054 # 80021998 <log>
    80003dbe:	9aba                	add	s5,s5,a4
    80003dc0:	018aa583          	lw	a1,24(s5)
    80003dc4:	013585bb          	addw	a1,a1,s3
    80003dc8:	2585                	addiw	a1,a1,1
    80003dca:	855a                	mv	a0,s6
    80003dcc:	fffff097          	auipc	ra,0xfffff
    80003dd0:	e92080e7          	jalr	-366(ra) # 80002c5e <bread>
    80003dd4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80003dd6:	000a2583          	lw	a1,0(s4)
    80003dda:	855a                	mv	a0,s6
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	e82080e7          	jalr	-382(ra) # 80002c5e <bread>
    80003de4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003de6:	40000613          	li	a2,1024
    80003dea:	06090593          	addi	a1,s2,96
    80003dee:	06050513          	addi	a0,a0,96
    80003df2:	ffffd097          	auipc	ra,0xffffd
    80003df6:	e04080e7          	jalr	-508(ra) # 80000bf6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003dfa:	8526                	mv	a0,s1
    80003dfc:	fffff097          	auipc	ra,0xfffff
    80003e00:	f56080e7          	jalr	-170(ra) # 80002d52 <bwrite>
    bunpin(dbuf);
    80003e04:	8526                	mv	a0,s1
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	066080e7          	jalr	102(ra) # 80002e6c <bunpin>
    brelse(lbuf);
    80003e0e:	854a                	mv	a0,s2
    80003e10:	fffff097          	auipc	ra,0xfffff
    80003e14:	f82080e7          	jalr	-126(ra) # 80002d92 <brelse>
    brelse(dbuf);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	fffff097          	auipc	ra,0xfffff
    80003e1e:	f78080e7          	jalr	-136(ra) # 80002d92 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80003e22:	2985                	addiw	s3,s3,1
    80003e24:	0a11                	addi	s4,s4,4
    80003e26:	02caa783          	lw	a5,44(s5)
    80003e2a:	f8f9cbe3          	blt	s3,a5,80003dc0 <install_trans+0x48>
}
    80003e2e:	70e2                	ld	ra,56(sp)
    80003e30:	7442                	ld	s0,48(sp)
    80003e32:	74a2                	ld	s1,40(sp)
    80003e34:	7902                	ld	s2,32(sp)
    80003e36:	69e2                	ld	s3,24(sp)
    80003e38:	6a42                	ld	s4,16(sp)
    80003e3a:	6aa2                	ld	s5,8(sp)
    80003e3c:	6b02                	ld	s6,0(sp)
    80003e3e:	6121                	addi	sp,sp,64
    80003e40:	8082                	ret
    80003e42:	8082                	ret

0000000080003e44 <initlog>:
{
    80003e44:	7179                	addi	sp,sp,-48
    80003e46:	f406                	sd	ra,40(sp)
    80003e48:	f022                	sd	s0,32(sp)
    80003e4a:	ec26                	sd	s1,24(sp)
    80003e4c:	e84a                	sd	s2,16(sp)
    80003e4e:	e44e                	sd	s3,8(sp)
    80003e50:	e052                	sd	s4,0(sp)
    80003e52:	1800                	addi	s0,sp,48
    80003e54:	892a                	mv	s2,a0
    80003e56:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    80003e58:	0a800713          	li	a4,168
    80003e5c:	02e504b3          	mul	s1,a0,a4
    80003e60:	0001e997          	auipc	s3,0x1e
    80003e64:	b3898993          	addi	s3,s3,-1224 # 80021998 <log>
    80003e68:	99a6                	add	s3,s3,s1
    80003e6a:	00003597          	auipc	a1,0x3
    80003e6e:	77e58593          	addi	a1,a1,1918 # 800075e8 <userret+0x558>
    80003e72:	854e                	mv	a0,s3
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	b54080e7          	jalr	-1196(ra) # 800009c8 <initlock>
  log[dev].start = sb->logstart;
    80003e7c:	014a2583          	lw	a1,20(s4)
    80003e80:	00b9ac23          	sw	a1,24(s3)
  log[dev].size = sb->nlog;
    80003e84:	010a2783          	lw	a5,16(s4)
    80003e88:	00f9ae23          	sw	a5,28(s3)
  log[dev].dev = dev;
    80003e8c:	0329a423          	sw	s2,40(s3)
  struct buf *buf = bread(dev, log[dev].start);
    80003e90:	854a                	mv	a0,s2
    80003e92:	fffff097          	auipc	ra,0xfffff
    80003e96:	dcc080e7          	jalr	-564(ra) # 80002c5e <bread>
  log[dev].lh.n = lh->n;
    80003e9a:	5134                	lw	a3,96(a0)
    80003e9c:	02d9a623          	sw	a3,44(s3)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003ea0:	02d05763          	blez	a3,80003ece <initlog+0x8a>
    80003ea4:	06450793          	addi	a5,a0,100
    80003ea8:	0001e717          	auipc	a4,0x1e
    80003eac:	b2070713          	addi	a4,a4,-1248 # 800219c8 <log+0x30>
    80003eb0:	9726                	add	a4,a4,s1
    80003eb2:	36fd                	addiw	a3,a3,-1
    80003eb4:	02069613          	slli	a2,a3,0x20
    80003eb8:	01e65693          	srli	a3,a2,0x1e
    80003ebc:	06850613          	addi	a2,a0,104
    80003ec0:	96b2                	add	a3,a3,a2
    log[dev].lh.block[i] = lh->block[i];
    80003ec2:	4390                	lw	a2,0(a5)
    80003ec4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    80003ec6:	0791                	addi	a5,a5,4
    80003ec8:	0711                	addi	a4,a4,4
    80003eca:	fed79ce3          	bne	a5,a3,80003ec2 <initlog+0x7e>
  brelse(buf);
    80003ece:	fffff097          	auipc	ra,0xfffff
    80003ed2:	ec4080e7          	jalr	-316(ra) # 80002d92 <brelse>
  install_trans(dev); // if committed, copy from log to disk
    80003ed6:	854a                	mv	a0,s2
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	ea0080e7          	jalr	-352(ra) # 80003d78 <install_trans>
  log[dev].lh.n = 0;
    80003ee0:	0a800793          	li	a5,168
    80003ee4:	02f90733          	mul	a4,s2,a5
    80003ee8:	0001e797          	auipc	a5,0x1e
    80003eec:	ab078793          	addi	a5,a5,-1360 # 80021998 <log>
    80003ef0:	97ba                	add	a5,a5,a4
    80003ef2:	0207a623          	sw	zero,44(a5)
  write_head(dev); // clear the log
    80003ef6:	854a                	mv	a0,s2
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	d34080e7          	jalr	-716(ra) # 80003c2c <write_head>
}
    80003f00:	70a2                	ld	ra,40(sp)
    80003f02:	7402                	ld	s0,32(sp)
    80003f04:	64e2                	ld	s1,24(sp)
    80003f06:	6942                	ld	s2,16(sp)
    80003f08:	69a2                	ld	s3,8(sp)
    80003f0a:	6a02                	ld	s4,0(sp)
    80003f0c:	6145                	addi	sp,sp,48
    80003f0e:	8082                	ret

0000000080003f10 <begin_op>:
{
    80003f10:	7139                	addi	sp,sp,-64
    80003f12:	fc06                	sd	ra,56(sp)
    80003f14:	f822                	sd	s0,48(sp)
    80003f16:	f426                	sd	s1,40(sp)
    80003f18:	f04a                	sd	s2,32(sp)
    80003f1a:	ec4e                	sd	s3,24(sp)
    80003f1c:	e852                	sd	s4,16(sp)
    80003f1e:	e456                	sd	s5,8(sp)
    80003f20:	0080                	addi	s0,sp,64
    80003f22:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    80003f24:	0a800913          	li	s2,168
    80003f28:	032507b3          	mul	a5,a0,s2
    80003f2c:	0001e917          	auipc	s2,0x1e
    80003f30:	a6c90913          	addi	s2,s2,-1428 # 80021998 <log>
    80003f34:	993e                	add	s2,s2,a5
    80003f36:	854a                	mv	a0,s2
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	b9e080e7          	jalr	-1122(ra) # 80000ad6 <acquire>
    if(log[dev].committing){
    80003f40:	0001e997          	auipc	s3,0x1e
    80003f44:	a5898993          	addi	s3,s3,-1448 # 80021998 <log>
    80003f48:	84ca                	mv	s1,s2
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f4a:	4a79                	li	s4,30
    80003f4c:	a039                	j	80003f5a <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    80003f4e:	85ca                	mv	a1,s2
    80003f50:	854e                	mv	a0,s3
    80003f52:	ffffe097          	auipc	ra,0xffffe
    80003f56:	0fa080e7          	jalr	250(ra) # 8000204c <sleep>
    if(log[dev].committing){
    80003f5a:	50dc                	lw	a5,36(s1)
    80003f5c:	fbed                	bnez	a5,80003f4e <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003f5e:	509c                	lw	a5,32(s1)
    80003f60:	0017871b          	addiw	a4,a5,1
    80003f64:	0007069b          	sext.w	a3,a4
    80003f68:	0027179b          	slliw	a5,a4,0x2
    80003f6c:	9fb9                	addw	a5,a5,a4
    80003f6e:	0017979b          	slliw	a5,a5,0x1
    80003f72:	54d8                	lw	a4,44(s1)
    80003f74:	9fb9                	addw	a5,a5,a4
    80003f76:	00fa5963          	bge	s4,a5,80003f88 <begin_op+0x78>
      sleep(&log, &log[dev].lock);
    80003f7a:	85ca                	mv	a1,s2
    80003f7c:	854e                	mv	a0,s3
    80003f7e:	ffffe097          	auipc	ra,0xffffe
    80003f82:	0ce080e7          	jalr	206(ra) # 8000204c <sleep>
    80003f86:	bfd1                	j	80003f5a <begin_op+0x4a>
      log[dev].outstanding += 1;
    80003f88:	0a800513          	li	a0,168
    80003f8c:	02aa8ab3          	mul	s5,s5,a0
    80003f90:	0001e797          	auipc	a5,0x1e
    80003f94:	a0878793          	addi	a5,a5,-1528 # 80021998 <log>
    80003f98:	9abe                	add	s5,s5,a5
    80003f9a:	02daa023          	sw	a3,32(s5)
      release(&log[dev].lock);
    80003f9e:	854a                	mv	a0,s2
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	b9e080e7          	jalr	-1122(ra) # 80000b3e <release>
}
    80003fa8:	70e2                	ld	ra,56(sp)
    80003faa:	7442                	ld	s0,48(sp)
    80003fac:	74a2                	ld	s1,40(sp)
    80003fae:	7902                	ld	s2,32(sp)
    80003fb0:	69e2                	ld	s3,24(sp)
    80003fb2:	6a42                	ld	s4,16(sp)
    80003fb4:	6aa2                	ld	s5,8(sp)
    80003fb6:	6121                	addi	sp,sp,64
    80003fb8:	8082                	ret

0000000080003fba <end_op>:
{
    80003fba:	7179                	addi	sp,sp,-48
    80003fbc:	f406                	sd	ra,40(sp)
    80003fbe:	f022                	sd	s0,32(sp)
    80003fc0:	ec26                	sd	s1,24(sp)
    80003fc2:	e84a                	sd	s2,16(sp)
    80003fc4:	e44e                	sd	s3,8(sp)
    80003fc6:	1800                	addi	s0,sp,48
    80003fc8:	892a                	mv	s2,a0
  acquire(&log[dev].lock);
    80003fca:	0a800493          	li	s1,168
    80003fce:	029507b3          	mul	a5,a0,s1
    80003fd2:	0001e497          	auipc	s1,0x1e
    80003fd6:	9c648493          	addi	s1,s1,-1594 # 80021998 <log>
    80003fda:	94be                	add	s1,s1,a5
    80003fdc:	8526                	mv	a0,s1
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	af8080e7          	jalr	-1288(ra) # 80000ad6 <acquire>
  log[dev].outstanding -= 1;
    80003fe6:	509c                	lw	a5,32(s1)
    80003fe8:	37fd                	addiw	a5,a5,-1
    80003fea:	0007871b          	sext.w	a4,a5
    80003fee:	d09c                	sw	a5,32(s1)
  if(log[dev].committing)
    80003ff0:	50dc                	lw	a5,36(s1)
    80003ff2:	e3ad                	bnez	a5,80004054 <end_op+0x9a>
  if(log[dev].outstanding == 0){
    80003ff4:	eb25                	bnez	a4,80004064 <end_op+0xaa>
    log[dev].committing = 1;
    80003ff6:	0a800993          	li	s3,168
    80003ffa:	033907b3          	mul	a5,s2,s3
    80003ffe:	0001e997          	auipc	s3,0x1e
    80004002:	99a98993          	addi	s3,s3,-1638 # 80021998 <log>
    80004006:	99be                	add	s3,s3,a5
    80004008:	4785                	li	a5,1
    8000400a:	02f9a223          	sw	a5,36(s3)
  release(&log[dev].lock);
    8000400e:	8526                	mv	a0,s1
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	b2e080e7          	jalr	-1234(ra) # 80000b3e <release>

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    80004018:	02c9a783          	lw	a5,44(s3)
    8000401c:	06f04863          	bgtz	a5,8000408c <end_op+0xd2>
    acquire(&log[dev].lock);
    80004020:	8526                	mv	a0,s1
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	ab4080e7          	jalr	-1356(ra) # 80000ad6 <acquire>
    log[dev].committing = 0;
    8000402a:	0001e517          	auipc	a0,0x1e
    8000402e:	96e50513          	addi	a0,a0,-1682 # 80021998 <log>
    80004032:	0a800793          	li	a5,168
    80004036:	02f90933          	mul	s2,s2,a5
    8000403a:	992a                	add	s2,s2,a0
    8000403c:	02092223          	sw	zero,36(s2)
    wakeup(&log);
    80004040:	ffffe097          	auipc	ra,0xffffe
    80004044:	18c080e7          	jalr	396(ra) # 800021cc <wakeup>
    release(&log[dev].lock);
    80004048:	8526                	mv	a0,s1
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	af4080e7          	jalr	-1292(ra) # 80000b3e <release>
}
    80004052:	a035                	j	8000407e <end_op+0xc4>
    panic("log[dev].committing");
    80004054:	00003517          	auipc	a0,0x3
    80004058:	59c50513          	addi	a0,a0,1436 # 800075f0 <userret+0x560>
    8000405c:	ffffc097          	auipc	ra,0xffffc
    80004060:	4ec080e7          	jalr	1260(ra) # 80000548 <panic>
    wakeup(&log);
    80004064:	0001e517          	auipc	a0,0x1e
    80004068:	93450513          	addi	a0,a0,-1740 # 80021998 <log>
    8000406c:	ffffe097          	auipc	ra,0xffffe
    80004070:	160080e7          	jalr	352(ra) # 800021cc <wakeup>
  release(&log[dev].lock);
    80004074:	8526                	mv	a0,s1
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	ac8080e7          	jalr	-1336(ra) # 80000b3e <release>
}
    8000407e:	70a2                	ld	ra,40(sp)
    80004080:	7402                	ld	s0,32(sp)
    80004082:	64e2                	ld	s1,24(sp)
    80004084:	6942                	ld	s2,16(sp)
    80004086:	69a2                	ld	s3,8(sp)
    80004088:	6145                	addi	sp,sp,48
    8000408a:	8082                	ret
    write_log(dev);     // Write modified blocks from cache to log
    8000408c:	854a                	mv	a0,s2
    8000408e:	00000097          	auipc	ra,0x0
    80004092:	c28080e7          	jalr	-984(ra) # 80003cb6 <write_log>
    write_head(dev);    // Write header to disk -- the real commit
    80004096:	854a                	mv	a0,s2
    80004098:	00000097          	auipc	ra,0x0
    8000409c:	b94080e7          	jalr	-1132(ra) # 80003c2c <write_head>
    install_trans(dev); // Now install writes to home locations
    800040a0:	854a                	mv	a0,s2
    800040a2:	00000097          	auipc	ra,0x0
    800040a6:	cd6080e7          	jalr	-810(ra) # 80003d78 <install_trans>
    log[dev].lh.n = 0;
    800040aa:	0a800793          	li	a5,168
    800040ae:	02f90733          	mul	a4,s2,a5
    800040b2:	0001e797          	auipc	a5,0x1e
    800040b6:	8e678793          	addi	a5,a5,-1818 # 80021998 <log>
    800040ba:	97ba                	add	a5,a5,a4
    800040bc:	0207a623          	sw	zero,44(a5)
    write_head(dev);    // Erase the transaction from the log
    800040c0:	854a                	mv	a0,s2
    800040c2:	00000097          	auipc	ra,0x0
    800040c6:	b6a080e7          	jalr	-1174(ra) # 80003c2c <write_head>
    800040ca:	bf99                	j	80004020 <end_op+0x66>

00000000800040cc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800040cc:	7179                	addi	sp,sp,-48
    800040ce:	f406                	sd	ra,40(sp)
    800040d0:	f022                	sd	s0,32(sp)
    800040d2:	ec26                	sd	s1,24(sp)
    800040d4:	e84a                	sd	s2,16(sp)
    800040d6:	e44e                	sd	s3,8(sp)
    800040d8:	e052                	sd	s4,0(sp)
    800040da:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    800040dc:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    800040e0:	0a800793          	li	a5,168
    800040e4:	02f90733          	mul	a4,s2,a5
    800040e8:	0001e797          	auipc	a5,0x1e
    800040ec:	8b078793          	addi	a5,a5,-1872 # 80021998 <log>
    800040f0:	97ba                	add	a5,a5,a4
    800040f2:	57d4                	lw	a3,44(a5)
    800040f4:	47f5                	li	a5,29
    800040f6:	0ad7cc63          	blt	a5,a3,800041ae <log_write+0xe2>
    800040fa:	89aa                	mv	s3,a0
    800040fc:	0001e797          	auipc	a5,0x1e
    80004100:	89c78793          	addi	a5,a5,-1892 # 80021998 <log>
    80004104:	97ba                	add	a5,a5,a4
    80004106:	4fdc                	lw	a5,28(a5)
    80004108:	37fd                	addiw	a5,a5,-1
    8000410a:	0af6d263          	bge	a3,a5,800041ae <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    8000410e:	0a800793          	li	a5,168
    80004112:	02f90733          	mul	a4,s2,a5
    80004116:	0001e797          	auipc	a5,0x1e
    8000411a:	88278793          	addi	a5,a5,-1918 # 80021998 <log>
    8000411e:	97ba                	add	a5,a5,a4
    80004120:	539c                	lw	a5,32(a5)
    80004122:	08f05e63          	blez	a5,800041be <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    80004126:	0a800793          	li	a5,168
    8000412a:	02f904b3          	mul	s1,s2,a5
    8000412e:	0001ea17          	auipc	s4,0x1e
    80004132:	86aa0a13          	addi	s4,s4,-1942 # 80021998 <log>
    80004136:	9a26                	add	s4,s4,s1
    80004138:	8552                	mv	a0,s4
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	99c080e7          	jalr	-1636(ra) # 80000ad6 <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004142:	02ca2603          	lw	a2,44(s4)
    80004146:	08c05463          	blez	a2,800041ce <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    8000414a:	00c9a583          	lw	a1,12(s3)
    8000414e:	0001e797          	auipc	a5,0x1e
    80004152:	87a78793          	addi	a5,a5,-1926 # 800219c8 <log+0x30>
    80004156:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    80004158:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    8000415a:	4394                	lw	a3,0(a5)
    8000415c:	06b68a63          	beq	a3,a1,800041d0 <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004160:	2705                	addiw	a4,a4,1
    80004162:	0791                	addi	a5,a5,4
    80004164:	fec71be3          	bne	a4,a2,8000415a <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    80004168:	02a00793          	li	a5,42
    8000416c:	02f907b3          	mul	a5,s2,a5
    80004170:	97b2                	add	a5,a5,a2
    80004172:	07a1                	addi	a5,a5,8
    80004174:	078a                	slli	a5,a5,0x2
    80004176:	0001e717          	auipc	a4,0x1e
    8000417a:	82270713          	addi	a4,a4,-2014 # 80021998 <log>
    8000417e:	97ba                	add	a5,a5,a4
    80004180:	00c9a703          	lw	a4,12(s3)
    80004184:	cb98                	sw	a4,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    80004186:	854e                	mv	a0,s3
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	ca8080e7          	jalr	-856(ra) # 80002e30 <bpin>
    log[dev].lh.n++;
    80004190:	0a800793          	li	a5,168
    80004194:	02f90933          	mul	s2,s2,a5
    80004198:	0001e797          	auipc	a5,0x1e
    8000419c:	80078793          	addi	a5,a5,-2048 # 80021998 <log>
    800041a0:	993e                	add	s2,s2,a5
    800041a2:	02c92783          	lw	a5,44(s2)
    800041a6:	2785                	addiw	a5,a5,1
    800041a8:	02f92623          	sw	a5,44(s2)
    800041ac:	a099                	j	800041f2 <log_write+0x126>
    panic("too big a transaction");
    800041ae:	00003517          	auipc	a0,0x3
    800041b2:	45a50513          	addi	a0,a0,1114 # 80007608 <userret+0x578>
    800041b6:	ffffc097          	auipc	ra,0xffffc
    800041ba:	392080e7          	jalr	914(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    800041be:	00003517          	auipc	a0,0x3
    800041c2:	46250513          	addi	a0,a0,1122 # 80007620 <userret+0x590>
    800041c6:	ffffc097          	auipc	ra,0xffffc
    800041ca:	382080e7          	jalr	898(ra) # 80000548 <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    800041ce:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    800041d0:	02a00793          	li	a5,42
    800041d4:	02f907b3          	mul	a5,s2,a5
    800041d8:	97ba                	add	a5,a5,a4
    800041da:	07a1                	addi	a5,a5,8
    800041dc:	078a                	slli	a5,a5,0x2
    800041de:	0001d697          	auipc	a3,0x1d
    800041e2:	7ba68693          	addi	a3,a3,1978 # 80021998 <log>
    800041e6:	97b6                	add	a5,a5,a3
    800041e8:	00c9a683          	lw	a3,12(s3)
    800041ec:	cb94                	sw	a3,16(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    800041ee:	f8e60ce3          	beq	a2,a4,80004186 <log_write+0xba>
  }
  release(&log[dev].lock);
    800041f2:	8552                	mv	a0,s4
    800041f4:	ffffd097          	auipc	ra,0xffffd
    800041f8:	94a080e7          	jalr	-1718(ra) # 80000b3e <release>
}
    800041fc:	70a2                	ld	ra,40(sp)
    800041fe:	7402                	ld	s0,32(sp)
    80004200:	64e2                	ld	s1,24(sp)
    80004202:	6942                	ld	s2,16(sp)
    80004204:	69a2                	ld	s3,8(sp)
    80004206:	6a02                	ld	s4,0(sp)
    80004208:	6145                	addi	sp,sp,48
    8000420a:	8082                	ret

000000008000420c <crash_op>:

// crash before commit or after commit
void
crash_op(int dev, int docommit)
{
    8000420c:	7179                	addi	sp,sp,-48
    8000420e:	f406                	sd	ra,40(sp)
    80004210:	f022                	sd	s0,32(sp)
    80004212:	ec26                	sd	s1,24(sp)
    80004214:	e84a                	sd	s2,16(sp)
    80004216:	e44e                	sd	s3,8(sp)
    80004218:	1800                	addi	s0,sp,48
    8000421a:	84aa                	mv	s1,a0
    8000421c:	89ae                	mv	s3,a1
  int do_commit = 0;
    
  acquire(&log[dev].lock);
    8000421e:	0a800913          	li	s2,168
    80004222:	032507b3          	mul	a5,a0,s2
    80004226:	0001d917          	auipc	s2,0x1d
    8000422a:	77290913          	addi	s2,s2,1906 # 80021998 <log>
    8000422e:	993e                	add	s2,s2,a5
    80004230:	854a                	mv	a0,s2
    80004232:	ffffd097          	auipc	ra,0xffffd
    80004236:	8a4080e7          	jalr	-1884(ra) # 80000ad6 <acquire>

  if (dev < 0 || dev >= NDISK)
    8000423a:	0004871b          	sext.w	a4,s1
    8000423e:	4785                	li	a5,1
    80004240:	0ae7e063          	bltu	a5,a4,800042e0 <crash_op+0xd4>
    panic("end_op: invalid disk");
  if(log[dev].outstanding == 0)
    80004244:	0a800793          	li	a5,168
    80004248:	02f48733          	mul	a4,s1,a5
    8000424c:	0001d797          	auipc	a5,0x1d
    80004250:	74c78793          	addi	a5,a5,1868 # 80021998 <log>
    80004254:	97ba                	add	a5,a5,a4
    80004256:	539c                	lw	a5,32(a5)
    80004258:	cfc1                	beqz	a5,800042f0 <crash_op+0xe4>
    panic("end_op: already closed");
  log[dev].outstanding -= 1;
    8000425a:	37fd                	addiw	a5,a5,-1
    8000425c:	0007861b          	sext.w	a2,a5
    80004260:	0a800713          	li	a4,168
    80004264:	02e486b3          	mul	a3,s1,a4
    80004268:	0001d717          	auipc	a4,0x1d
    8000426c:	73070713          	addi	a4,a4,1840 # 80021998 <log>
    80004270:	9736                	add	a4,a4,a3
    80004272:	d31c                	sw	a5,32(a4)
  if(log[dev].committing)
    80004274:	535c                	lw	a5,36(a4)
    80004276:	e7c9                	bnez	a5,80004300 <crash_op+0xf4>
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    80004278:	ee41                	bnez	a2,80004310 <crash_op+0x104>
    do_commit = 1;
    log[dev].committing = 1;
    8000427a:	0a800793          	li	a5,168
    8000427e:	02f48733          	mul	a4,s1,a5
    80004282:	0001d797          	auipc	a5,0x1d
    80004286:	71678793          	addi	a5,a5,1814 # 80021998 <log>
    8000428a:	97ba                	add	a5,a5,a4
    8000428c:	4705                	li	a4,1
    8000428e:	d3d8                	sw	a4,36(a5)
  }
  
  release(&log[dev].lock);
    80004290:	854a                	mv	a0,s2
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	8ac080e7          	jalr	-1876(ra) # 80000b3e <release>

  if(docommit & do_commit){
    8000429a:	0019f993          	andi	s3,s3,1
    8000429e:	06098e63          	beqz	s3,8000431a <crash_op+0x10e>
    printf("crash_op: commit\n");
    800042a2:	00003517          	auipc	a0,0x3
    800042a6:	3ce50513          	addi	a0,a0,974 # 80007670 <userret+0x5e0>
    800042aa:	ffffc097          	auipc	ra,0xffffc
    800042ae:	2e8080e7          	jalr	744(ra) # 80000592 <printf>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.

    if (log[dev].lh.n > 0) {
    800042b2:	0a800793          	li	a5,168
    800042b6:	02f48733          	mul	a4,s1,a5
    800042ba:	0001d797          	auipc	a5,0x1d
    800042be:	6de78793          	addi	a5,a5,1758 # 80021998 <log>
    800042c2:	97ba                	add	a5,a5,a4
    800042c4:	57dc                	lw	a5,44(a5)
    800042c6:	04f05a63          	blez	a5,8000431a <crash_op+0x10e>
      write_log(dev);     // Write modified blocks from cache to log
    800042ca:	8526                	mv	a0,s1
    800042cc:	00000097          	auipc	ra,0x0
    800042d0:	9ea080e7          	jalr	-1558(ra) # 80003cb6 <write_log>
      write_head(dev);    // Write header to disk -- the real commit
    800042d4:	8526                	mv	a0,s1
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	956080e7          	jalr	-1706(ra) # 80003c2c <write_head>
    800042de:	a835                	j	8000431a <crash_op+0x10e>
    panic("end_op: invalid disk");
    800042e0:	00003517          	auipc	a0,0x3
    800042e4:	36050513          	addi	a0,a0,864 # 80007640 <userret+0x5b0>
    800042e8:	ffffc097          	auipc	ra,0xffffc
    800042ec:	260080e7          	jalr	608(ra) # 80000548 <panic>
    panic("end_op: already closed");
    800042f0:	00003517          	auipc	a0,0x3
    800042f4:	36850513          	addi	a0,a0,872 # 80007658 <userret+0x5c8>
    800042f8:	ffffc097          	auipc	ra,0xffffc
    800042fc:	250080e7          	jalr	592(ra) # 80000548 <panic>
    panic("log[dev].committing");
    80004300:	00003517          	auipc	a0,0x3
    80004304:	2f050513          	addi	a0,a0,752 # 800075f0 <userret+0x560>
    80004308:	ffffc097          	auipc	ra,0xffffc
    8000430c:	240080e7          	jalr	576(ra) # 80000548 <panic>
  release(&log[dev].lock);
    80004310:	854a                	mv	a0,s2
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	82c080e7          	jalr	-2004(ra) # 80000b3e <release>
    }
  }
  panic("crashed file system; please restart xv6 and run crashtest\n");
    8000431a:	00003517          	auipc	a0,0x3
    8000431e:	36e50513          	addi	a0,a0,878 # 80007688 <userret+0x5f8>
    80004322:	ffffc097          	auipc	ra,0xffffc
    80004326:	226080e7          	jalr	550(ra) # 80000548 <panic>

000000008000432a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000432a:	1101                	addi	sp,sp,-32
    8000432c:	ec06                	sd	ra,24(sp)
    8000432e:	e822                	sd	s0,16(sp)
    80004330:	e426                	sd	s1,8(sp)
    80004332:	e04a                	sd	s2,0(sp)
    80004334:	1000                	addi	s0,sp,32
    80004336:	84aa                	mv	s1,a0
    80004338:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000433a:	00003597          	auipc	a1,0x3
    8000433e:	38e58593          	addi	a1,a1,910 # 800076c8 <userret+0x638>
    80004342:	0521                	addi	a0,a0,8
    80004344:	ffffc097          	auipc	ra,0xffffc
    80004348:	684080e7          	jalr	1668(ra) # 800009c8 <initlock>
  lk->name = name;
    8000434c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004350:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004354:	0204a423          	sw	zero,40(s1)
}
    80004358:	60e2                	ld	ra,24(sp)
    8000435a:	6442                	ld	s0,16(sp)
    8000435c:	64a2                	ld	s1,8(sp)
    8000435e:	6902                	ld	s2,0(sp)
    80004360:	6105                	addi	sp,sp,32
    80004362:	8082                	ret

0000000080004364 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004364:	1101                	addi	sp,sp,-32
    80004366:	ec06                	sd	ra,24(sp)
    80004368:	e822                	sd	s0,16(sp)
    8000436a:	e426                	sd	s1,8(sp)
    8000436c:	e04a                	sd	s2,0(sp)
    8000436e:	1000                	addi	s0,sp,32
    80004370:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004372:	00850913          	addi	s2,a0,8
    80004376:	854a                	mv	a0,s2
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	75e080e7          	jalr	1886(ra) # 80000ad6 <acquire>
  while (lk->locked) {
    80004380:	409c                	lw	a5,0(s1)
    80004382:	cb89                	beqz	a5,80004394 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004384:	85ca                	mv	a1,s2
    80004386:	8526                	mv	a0,s1
    80004388:	ffffe097          	auipc	ra,0xffffe
    8000438c:	cc4080e7          	jalr	-828(ra) # 8000204c <sleep>
  while (lk->locked) {
    80004390:	409c                	lw	a5,0(s1)
    80004392:	fbed                	bnez	a5,80004384 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004394:	4785                	li	a5,1
    80004396:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004398:	ffffd097          	auipc	ra,0xffffd
    8000439c:	49e080e7          	jalr	1182(ra) # 80001836 <myproc>
    800043a0:	5d1c                	lw	a5,56(a0)
    800043a2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043a4:	854a                	mv	a0,s2
    800043a6:	ffffc097          	auipc	ra,0xffffc
    800043aa:	798080e7          	jalr	1944(ra) # 80000b3e <release>
}
    800043ae:	60e2                	ld	ra,24(sp)
    800043b0:	6442                	ld	s0,16(sp)
    800043b2:	64a2                	ld	s1,8(sp)
    800043b4:	6902                	ld	s2,0(sp)
    800043b6:	6105                	addi	sp,sp,32
    800043b8:	8082                	ret

00000000800043ba <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043ba:	1101                	addi	sp,sp,-32
    800043bc:	ec06                	sd	ra,24(sp)
    800043be:	e822                	sd	s0,16(sp)
    800043c0:	e426                	sd	s1,8(sp)
    800043c2:	e04a                	sd	s2,0(sp)
    800043c4:	1000                	addi	s0,sp,32
    800043c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043c8:	00850913          	addi	s2,a0,8
    800043cc:	854a                	mv	a0,s2
    800043ce:	ffffc097          	auipc	ra,0xffffc
    800043d2:	708080e7          	jalr	1800(ra) # 80000ad6 <acquire>
  lk->locked = 0;
    800043d6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043da:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800043de:	8526                	mv	a0,s1
    800043e0:	ffffe097          	auipc	ra,0xffffe
    800043e4:	dec080e7          	jalr	-532(ra) # 800021cc <wakeup>
  release(&lk->lk);
    800043e8:	854a                	mv	a0,s2
    800043ea:	ffffc097          	auipc	ra,0xffffc
    800043ee:	754080e7          	jalr	1876(ra) # 80000b3e <release>
}
    800043f2:	60e2                	ld	ra,24(sp)
    800043f4:	6442                	ld	s0,16(sp)
    800043f6:	64a2                	ld	s1,8(sp)
    800043f8:	6902                	ld	s2,0(sp)
    800043fa:	6105                	addi	sp,sp,32
    800043fc:	8082                	ret

00000000800043fe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043fe:	7179                	addi	sp,sp,-48
    80004400:	f406                	sd	ra,40(sp)
    80004402:	f022                	sd	s0,32(sp)
    80004404:	ec26                	sd	s1,24(sp)
    80004406:	e84a                	sd	s2,16(sp)
    80004408:	e44e                	sd	s3,8(sp)
    8000440a:	1800                	addi	s0,sp,48
    8000440c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000440e:	00850913          	addi	s2,a0,8
    80004412:	854a                	mv	a0,s2
    80004414:	ffffc097          	auipc	ra,0xffffc
    80004418:	6c2080e7          	jalr	1730(ra) # 80000ad6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000441c:	409c                	lw	a5,0(s1)
    8000441e:	ef99                	bnez	a5,8000443c <holdingsleep+0x3e>
    80004420:	4481                	li	s1,0
  release(&lk->lk);
    80004422:	854a                	mv	a0,s2
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	71a080e7          	jalr	1818(ra) # 80000b3e <release>
  return r;
}
    8000442c:	8526                	mv	a0,s1
    8000442e:	70a2                	ld	ra,40(sp)
    80004430:	7402                	ld	s0,32(sp)
    80004432:	64e2                	ld	s1,24(sp)
    80004434:	6942                	ld	s2,16(sp)
    80004436:	69a2                	ld	s3,8(sp)
    80004438:	6145                	addi	sp,sp,48
    8000443a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000443c:	0284a983          	lw	s3,40(s1)
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	3f6080e7          	jalr	1014(ra) # 80001836 <myproc>
    80004448:	5d04                	lw	s1,56(a0)
    8000444a:	413484b3          	sub	s1,s1,s3
    8000444e:	0014b493          	seqz	s1,s1
    80004452:	bfc1                	j	80004422 <holdingsleep+0x24>

0000000080004454 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004454:	1141                	addi	sp,sp,-16
    80004456:	e406                	sd	ra,8(sp)
    80004458:	e022                	sd	s0,0(sp)
    8000445a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000445c:	00003597          	auipc	a1,0x3
    80004460:	27c58593          	addi	a1,a1,636 # 800076d8 <userret+0x648>
    80004464:	0001d517          	auipc	a0,0x1d
    80004468:	72450513          	addi	a0,a0,1828 # 80021b88 <ftable>
    8000446c:	ffffc097          	auipc	ra,0xffffc
    80004470:	55c080e7          	jalr	1372(ra) # 800009c8 <initlock>
}
    80004474:	60a2                	ld	ra,8(sp)
    80004476:	6402                	ld	s0,0(sp)
    80004478:	0141                	addi	sp,sp,16
    8000447a:	8082                	ret

000000008000447c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000447c:	1101                	addi	sp,sp,-32
    8000447e:	ec06                	sd	ra,24(sp)
    80004480:	e822                	sd	s0,16(sp)
    80004482:	e426                	sd	s1,8(sp)
    80004484:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004486:	0001d517          	auipc	a0,0x1d
    8000448a:	70250513          	addi	a0,a0,1794 # 80021b88 <ftable>
    8000448e:	ffffc097          	auipc	ra,0xffffc
    80004492:	648080e7          	jalr	1608(ra) # 80000ad6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004496:	0001d497          	auipc	s1,0x1d
    8000449a:	70a48493          	addi	s1,s1,1802 # 80021ba0 <ftable+0x18>
    8000449e:	0001e717          	auipc	a4,0x1e
    800044a2:	6a270713          	addi	a4,a4,1698 # 80022b40 <ftable+0xfb8>
    if(f->ref == 0){
    800044a6:	40dc                	lw	a5,4(s1)
    800044a8:	cf99                	beqz	a5,800044c6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044aa:	02848493          	addi	s1,s1,40
    800044ae:	fee49ce3          	bne	s1,a4,800044a6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800044b2:	0001d517          	auipc	a0,0x1d
    800044b6:	6d650513          	addi	a0,a0,1750 # 80021b88 <ftable>
    800044ba:	ffffc097          	auipc	ra,0xffffc
    800044be:	684080e7          	jalr	1668(ra) # 80000b3e <release>
  return 0;
    800044c2:	4481                	li	s1,0
    800044c4:	a819                	j	800044da <filealloc+0x5e>
      f->ref = 1;
    800044c6:	4785                	li	a5,1
    800044c8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800044ca:	0001d517          	auipc	a0,0x1d
    800044ce:	6be50513          	addi	a0,a0,1726 # 80021b88 <ftable>
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	66c080e7          	jalr	1644(ra) # 80000b3e <release>
}
    800044da:	8526                	mv	a0,s1
    800044dc:	60e2                	ld	ra,24(sp)
    800044de:	6442                	ld	s0,16(sp)
    800044e0:	64a2                	ld	s1,8(sp)
    800044e2:	6105                	addi	sp,sp,32
    800044e4:	8082                	ret

00000000800044e6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800044e6:	1101                	addi	sp,sp,-32
    800044e8:	ec06                	sd	ra,24(sp)
    800044ea:	e822                	sd	s0,16(sp)
    800044ec:	e426                	sd	s1,8(sp)
    800044ee:	1000                	addi	s0,sp,32
    800044f0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800044f2:	0001d517          	auipc	a0,0x1d
    800044f6:	69650513          	addi	a0,a0,1686 # 80021b88 <ftable>
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	5dc080e7          	jalr	1500(ra) # 80000ad6 <acquire>
  if(f->ref < 1)
    80004502:	40dc                	lw	a5,4(s1)
    80004504:	02f05263          	blez	a5,80004528 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004508:	2785                	addiw	a5,a5,1
    8000450a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000450c:	0001d517          	auipc	a0,0x1d
    80004510:	67c50513          	addi	a0,a0,1660 # 80021b88 <ftable>
    80004514:	ffffc097          	auipc	ra,0xffffc
    80004518:	62a080e7          	jalr	1578(ra) # 80000b3e <release>
  return f;
}
    8000451c:	8526                	mv	a0,s1
    8000451e:	60e2                	ld	ra,24(sp)
    80004520:	6442                	ld	s0,16(sp)
    80004522:	64a2                	ld	s1,8(sp)
    80004524:	6105                	addi	sp,sp,32
    80004526:	8082                	ret
    panic("filedup");
    80004528:	00003517          	auipc	a0,0x3
    8000452c:	1b850513          	addi	a0,a0,440 # 800076e0 <userret+0x650>
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	018080e7          	jalr	24(ra) # 80000548 <panic>

0000000080004538 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004538:	7139                	addi	sp,sp,-64
    8000453a:	fc06                	sd	ra,56(sp)
    8000453c:	f822                	sd	s0,48(sp)
    8000453e:	f426                	sd	s1,40(sp)
    80004540:	f04a                	sd	s2,32(sp)
    80004542:	ec4e                	sd	s3,24(sp)
    80004544:	e852                	sd	s4,16(sp)
    80004546:	e456                	sd	s5,8(sp)
    80004548:	0080                	addi	s0,sp,64
    8000454a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000454c:	0001d517          	auipc	a0,0x1d
    80004550:	63c50513          	addi	a0,a0,1596 # 80021b88 <ftable>
    80004554:	ffffc097          	auipc	ra,0xffffc
    80004558:	582080e7          	jalr	1410(ra) # 80000ad6 <acquire>
  if(f->ref < 1)
    8000455c:	40dc                	lw	a5,4(s1)
    8000455e:	06f05563          	blez	a5,800045c8 <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    80004562:	37fd                	addiw	a5,a5,-1
    80004564:	0007871b          	sext.w	a4,a5
    80004568:	c0dc                	sw	a5,4(s1)
    8000456a:	06e04763          	bgtz	a4,800045d8 <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000456e:	0004a903          	lw	s2,0(s1)
    80004572:	0094ca83          	lbu	s5,9(s1)
    80004576:	0104ba03          	ld	s4,16(s1)
    8000457a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000457e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004582:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004586:	0001d517          	auipc	a0,0x1d
    8000458a:	60250513          	addi	a0,a0,1538 # 80021b88 <ftable>
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	5b0080e7          	jalr	1456(ra) # 80000b3e <release>

  if(ff.type == FD_PIPE){
    80004596:	4785                	li	a5,1
    80004598:	06f90163          	beq	s2,a5,800045fa <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000459c:	3979                	addiw	s2,s2,-2
    8000459e:	4785                	li	a5,1
    800045a0:	0527e463          	bltu	a5,s2,800045e8 <fileclose+0xb0>
    begin_op(ff.ip->dev);
    800045a4:	0009a503          	lw	a0,0(s3)
    800045a8:	00000097          	auipc	ra,0x0
    800045ac:	968080e7          	jalr	-1688(ra) # 80003f10 <begin_op>
    iput(ff.ip);
    800045b0:	854e                	mv	a0,s3
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	fc2080e7          	jalr	-62(ra) # 80003574 <iput>
    end_op(ff.ip->dev);
    800045ba:	0009a503          	lw	a0,0(s3)
    800045be:	00000097          	auipc	ra,0x0
    800045c2:	9fc080e7          	jalr	-1540(ra) # 80003fba <end_op>
    800045c6:	a00d                	j	800045e8 <fileclose+0xb0>
    panic("fileclose");
    800045c8:	00003517          	auipc	a0,0x3
    800045cc:	12050513          	addi	a0,a0,288 # 800076e8 <userret+0x658>
    800045d0:	ffffc097          	auipc	ra,0xffffc
    800045d4:	f78080e7          	jalr	-136(ra) # 80000548 <panic>
    release(&ftable.lock);
    800045d8:	0001d517          	auipc	a0,0x1d
    800045dc:	5b050513          	addi	a0,a0,1456 # 80021b88 <ftable>
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	55e080e7          	jalr	1374(ra) # 80000b3e <release>
  }
}
    800045e8:	70e2                	ld	ra,56(sp)
    800045ea:	7442                	ld	s0,48(sp)
    800045ec:	74a2                	ld	s1,40(sp)
    800045ee:	7902                	ld	s2,32(sp)
    800045f0:	69e2                	ld	s3,24(sp)
    800045f2:	6a42                	ld	s4,16(sp)
    800045f4:	6aa2                	ld	s5,8(sp)
    800045f6:	6121                	addi	sp,sp,64
    800045f8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800045fa:	85d6                	mv	a1,s5
    800045fc:	8552                	mv	a0,s4
    800045fe:	00000097          	auipc	ra,0x0
    80004602:	348080e7          	jalr	840(ra) # 80004946 <pipeclose>
    80004606:	b7cd                	j	800045e8 <fileclose+0xb0>

0000000080004608 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004608:	715d                	addi	sp,sp,-80
    8000460a:	e486                	sd	ra,72(sp)
    8000460c:	e0a2                	sd	s0,64(sp)
    8000460e:	fc26                	sd	s1,56(sp)
    80004610:	f84a                	sd	s2,48(sp)
    80004612:	f44e                	sd	s3,40(sp)
    80004614:	0880                	addi	s0,sp,80
    80004616:	84aa                	mv	s1,a0
    80004618:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000461a:	ffffd097          	auipc	ra,0xffffd
    8000461e:	21c080e7          	jalr	540(ra) # 80001836 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004622:	409c                	lw	a5,0(s1)
    80004624:	37f9                	addiw	a5,a5,-2
    80004626:	4705                	li	a4,1
    80004628:	04f76763          	bltu	a4,a5,80004676 <filestat+0x6e>
    8000462c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000462e:	6c88                	ld	a0,24(s1)
    80004630:	fffff097          	auipc	ra,0xfffff
    80004634:	e36080e7          	jalr	-458(ra) # 80003466 <ilock>
    stati(f->ip, &st);
    80004638:	fb840593          	addi	a1,s0,-72
    8000463c:	6c88                	ld	a0,24(s1)
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	08e080e7          	jalr	142(ra) # 800036cc <stati>
    iunlock(f->ip);
    80004646:	6c88                	ld	a0,24(s1)
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	ee0080e7          	jalr	-288(ra) # 80003528 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004650:	46e1                	li	a3,24
    80004652:	fb840613          	addi	a2,s0,-72
    80004656:	85ce                	mv	a1,s3
    80004658:	05093503          	ld	a0,80(s2)
    8000465c:	ffffd097          	auipc	ra,0xffffd
    80004660:	efe080e7          	jalr	-258(ra) # 8000155a <copyout>
    80004664:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004668:	60a6                	ld	ra,72(sp)
    8000466a:	6406                	ld	s0,64(sp)
    8000466c:	74e2                	ld	s1,56(sp)
    8000466e:	7942                	ld	s2,48(sp)
    80004670:	79a2                	ld	s3,40(sp)
    80004672:	6161                	addi	sp,sp,80
    80004674:	8082                	ret
  return -1;
    80004676:	557d                	li	a0,-1
    80004678:	bfc5                	j	80004668 <filestat+0x60>

000000008000467a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000467a:	7179                	addi	sp,sp,-48
    8000467c:	f406                	sd	ra,40(sp)
    8000467e:	f022                	sd	s0,32(sp)
    80004680:	ec26                	sd	s1,24(sp)
    80004682:	e84a                	sd	s2,16(sp)
    80004684:	e44e                	sd	s3,8(sp)
    80004686:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004688:	00854783          	lbu	a5,8(a0)
    8000468c:	cfc1                	beqz	a5,80004724 <fileread+0xaa>
    8000468e:	84aa                	mv	s1,a0
    80004690:	89ae                	mv	s3,a1
    80004692:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004694:	411c                	lw	a5,0(a0)
    80004696:	4705                	li	a4,1
    80004698:	04e78963          	beq	a5,a4,800046ea <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000469c:	470d                	li	a4,3
    8000469e:	04e78d63          	beq	a5,a4,800046f8 <fileread+0x7e>
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800046a2:	4709                	li	a4,2
    800046a4:	06e79863          	bne	a5,a4,80004714 <fileread+0x9a>
    ilock(f->ip);
    800046a8:	6d08                	ld	a0,24(a0)
    800046aa:	fffff097          	auipc	ra,0xfffff
    800046ae:	dbc080e7          	jalr	-580(ra) # 80003466 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800046b2:	874a                	mv	a4,s2
    800046b4:	5094                	lw	a3,32(s1)
    800046b6:	864e                	mv	a2,s3
    800046b8:	4585                	li	a1,1
    800046ba:	6c88                	ld	a0,24(s1)
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	03a080e7          	jalr	58(ra) # 800036f6 <readi>
    800046c4:	892a                	mv	s2,a0
    800046c6:	00a05563          	blez	a0,800046d0 <fileread+0x56>
      f->off += r;
    800046ca:	509c                	lw	a5,32(s1)
    800046cc:	9fa9                	addw	a5,a5,a0
    800046ce:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800046d0:	6c88                	ld	a0,24(s1)
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	e56080e7          	jalr	-426(ra) # 80003528 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800046da:	854a                	mv	a0,s2
    800046dc:	70a2                	ld	ra,40(sp)
    800046de:	7402                	ld	s0,32(sp)
    800046e0:	64e2                	ld	s1,24(sp)
    800046e2:	6942                	ld	s2,16(sp)
    800046e4:	69a2                	ld	s3,8(sp)
    800046e6:	6145                	addi	sp,sp,48
    800046e8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800046ea:	6908                	ld	a0,16(a0)
    800046ec:	00000097          	auipc	ra,0x0
    800046f0:	3d8080e7          	jalr	984(ra) # 80004ac4 <piperead>
    800046f4:	892a                	mv	s2,a0
    800046f6:	b7d5                	j	800046da <fileread+0x60>
    r = devsw[f->major].read(1, addr, n);
    800046f8:	02451783          	lh	a5,36(a0)
    800046fc:	00479713          	slli	a4,a5,0x4
    80004700:	0001d797          	auipc	a5,0x1d
    80004704:	3e878793          	addi	a5,a5,1000 # 80021ae8 <devsw>
    80004708:	97ba                	add	a5,a5,a4
    8000470a:	639c                	ld	a5,0(a5)
    8000470c:	4505                	li	a0,1
    8000470e:	9782                	jalr	a5
    80004710:	892a                	mv	s2,a0
    80004712:	b7e1                	j	800046da <fileread+0x60>
    panic("fileread");
    80004714:	00003517          	auipc	a0,0x3
    80004718:	fe450513          	addi	a0,a0,-28 # 800076f8 <userret+0x668>
    8000471c:	ffffc097          	auipc	ra,0xffffc
    80004720:	e2c080e7          	jalr	-468(ra) # 80000548 <panic>
    return -1;
    80004724:	597d                	li	s2,-1
    80004726:	bf55                	j	800046da <fileread+0x60>

0000000080004728 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004728:	00954783          	lbu	a5,9(a0)
    8000472c:	12078e63          	beqz	a5,80004868 <filewrite+0x140>
{
    80004730:	715d                	addi	sp,sp,-80
    80004732:	e486                	sd	ra,72(sp)
    80004734:	e0a2                	sd	s0,64(sp)
    80004736:	fc26                	sd	s1,56(sp)
    80004738:	f84a                	sd	s2,48(sp)
    8000473a:	f44e                	sd	s3,40(sp)
    8000473c:	f052                	sd	s4,32(sp)
    8000473e:	ec56                	sd	s5,24(sp)
    80004740:	e85a                	sd	s6,16(sp)
    80004742:	e45e                	sd	s7,8(sp)
    80004744:	e062                	sd	s8,0(sp)
    80004746:	0880                	addi	s0,sp,80
    80004748:	84aa                	mv	s1,a0
    8000474a:	8aae                	mv	s5,a1
    8000474c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000474e:	411c                	lw	a5,0(a0)
    80004750:	4705                	li	a4,1
    80004752:	02e78263          	beq	a5,a4,80004776 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004756:	470d                	li	a4,3
    80004758:	02e78563          	beq	a5,a4,80004782 <filewrite+0x5a>
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000475c:	4709                	li	a4,2
    8000475e:	0ee79d63          	bne	a5,a4,80004858 <filewrite+0x130>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004762:	0ec05763          	blez	a2,80004850 <filewrite+0x128>
    int i = 0;
    80004766:	4981                	li	s3,0
    80004768:	6b05                	lui	s6,0x1
    8000476a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000476e:	6b85                	lui	s7,0x1
    80004770:	c00b8b9b          	addiw	s7,s7,-1024
    80004774:	a051                	j	800047f8 <filewrite+0xd0>
    ret = pipewrite(f->pipe, addr, n);
    80004776:	6908                	ld	a0,16(a0)
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	23e080e7          	jalr	574(ra) # 800049b6 <pipewrite>
    80004780:	a065                	j	80004828 <filewrite+0x100>
    ret = devsw[f->major].write(1, addr, n);
    80004782:	02451783          	lh	a5,36(a0)
    80004786:	00479713          	slli	a4,a5,0x4
    8000478a:	0001d797          	auipc	a5,0x1d
    8000478e:	35e78793          	addi	a5,a5,862 # 80021ae8 <devsw>
    80004792:	97ba                	add	a5,a5,a4
    80004794:	679c                	ld	a5,8(a5)
    80004796:	4505                	li	a0,1
    80004798:	9782                	jalr	a5
    8000479a:	a079                	j	80004828 <filewrite+0x100>
    8000479c:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    800047a0:	6c9c                	ld	a5,24(s1)
    800047a2:	4388                	lw	a0,0(a5)
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	76c080e7          	jalr	1900(ra) # 80003f10 <begin_op>
      ilock(f->ip);
    800047ac:	6c88                	ld	a0,24(s1)
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	cb8080e7          	jalr	-840(ra) # 80003466 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800047b6:	8762                	mv	a4,s8
    800047b8:	5094                	lw	a3,32(s1)
    800047ba:	01598633          	add	a2,s3,s5
    800047be:	4585                	li	a1,1
    800047c0:	6c88                	ld	a0,24(s1)
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	028080e7          	jalr	40(ra) # 800037ea <writei>
    800047ca:	892a                	mv	s2,a0
    800047cc:	02a05e63          	blez	a0,80004808 <filewrite+0xe0>
        f->off += r;
    800047d0:	509c                	lw	a5,32(s1)
    800047d2:	9fa9                	addw	a5,a5,a0
    800047d4:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    800047d6:	6c88                	ld	a0,24(s1)
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	d50080e7          	jalr	-688(ra) # 80003528 <iunlock>
      end_op(f->ip->dev);
    800047e0:	6c9c                	ld	a5,24(s1)
    800047e2:	4388                	lw	a0,0(a5)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	7d6080e7          	jalr	2006(ra) # 80003fba <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800047ec:	052c1a63          	bne	s8,s2,80004840 <filewrite+0x118>
        panic("short filewrite");
      i += r;
    800047f0:	013909bb          	addw	s3,s2,s3
    while(i < n){
    800047f4:	0349d763          	bge	s3,s4,80004822 <filewrite+0xfa>
      int n1 = n - i;
    800047f8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800047fc:	893e                	mv	s2,a5
    800047fe:	2781                	sext.w	a5,a5
    80004800:	f8fb5ee3          	bge	s6,a5,8000479c <filewrite+0x74>
    80004804:	895e                	mv	s2,s7
    80004806:	bf59                	j	8000479c <filewrite+0x74>
      iunlock(f->ip);
    80004808:	6c88                	ld	a0,24(s1)
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	d1e080e7          	jalr	-738(ra) # 80003528 <iunlock>
      end_op(f->ip->dev);
    80004812:	6c9c                	ld	a5,24(s1)
    80004814:	4388                	lw	a0,0(a5)
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	7a4080e7          	jalr	1956(ra) # 80003fba <end_op>
      if(r < 0)
    8000481e:	fc0957e3          	bgez	s2,800047ec <filewrite+0xc4>
    }
    ret = (i == n ? n : -1);
    80004822:	8552                	mv	a0,s4
    80004824:	033a1863          	bne	s4,s3,80004854 <filewrite+0x12c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004828:	60a6                	ld	ra,72(sp)
    8000482a:	6406                	ld	s0,64(sp)
    8000482c:	74e2                	ld	s1,56(sp)
    8000482e:	7942                	ld	s2,48(sp)
    80004830:	79a2                	ld	s3,40(sp)
    80004832:	7a02                	ld	s4,32(sp)
    80004834:	6ae2                	ld	s5,24(sp)
    80004836:	6b42                	ld	s6,16(sp)
    80004838:	6ba2                	ld	s7,8(sp)
    8000483a:	6c02                	ld	s8,0(sp)
    8000483c:	6161                	addi	sp,sp,80
    8000483e:	8082                	ret
        panic("short filewrite");
    80004840:	00003517          	auipc	a0,0x3
    80004844:	ec850513          	addi	a0,a0,-312 # 80007708 <userret+0x678>
    80004848:	ffffc097          	auipc	ra,0xffffc
    8000484c:	d00080e7          	jalr	-768(ra) # 80000548 <panic>
    int i = 0;
    80004850:	4981                	li	s3,0
    80004852:	bfc1                	j	80004822 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80004854:	557d                	li	a0,-1
    80004856:	bfc9                	j	80004828 <filewrite+0x100>
    panic("filewrite");
    80004858:	00003517          	auipc	a0,0x3
    8000485c:	ec050513          	addi	a0,a0,-320 # 80007718 <userret+0x688>
    80004860:	ffffc097          	auipc	ra,0xffffc
    80004864:	ce8080e7          	jalr	-792(ra) # 80000548 <panic>
    return -1;
    80004868:	557d                	li	a0,-1
}
    8000486a:	8082                	ret

000000008000486c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000486c:	7179                	addi	sp,sp,-48
    8000486e:	f406                	sd	ra,40(sp)
    80004870:	f022                	sd	s0,32(sp)
    80004872:	ec26                	sd	s1,24(sp)
    80004874:	e84a                	sd	s2,16(sp)
    80004876:	e44e                	sd	s3,8(sp)
    80004878:	e052                	sd	s4,0(sp)
    8000487a:	1800                	addi	s0,sp,48
    8000487c:	84aa                	mv	s1,a0
    8000487e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004880:	0005b023          	sd	zero,0(a1)
    80004884:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	bf4080e7          	jalr	-1036(ra) # 8000447c <filealloc>
    80004890:	e088                	sd	a0,0(s1)
    80004892:	c551                	beqz	a0,8000491e <pipealloc+0xb2>
    80004894:	00000097          	auipc	ra,0x0
    80004898:	be8080e7          	jalr	-1048(ra) # 8000447c <filealloc>
    8000489c:	00aa3023          	sd	a0,0(s4)
    800048a0:	c92d                	beqz	a0,80004912 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800048a2:	ffffc097          	auipc	ra,0xffffc
    800048a6:	0c6080e7          	jalr	198(ra) # 80000968 <kalloc>
    800048aa:	892a                	mv	s2,a0
    800048ac:	c125                	beqz	a0,8000490c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800048ae:	4985                	li	s3,1
    800048b0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800048b4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800048b8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800048bc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800048c0:	00003597          	auipc	a1,0x3
    800048c4:	e6858593          	addi	a1,a1,-408 # 80007728 <userret+0x698>
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	100080e7          	jalr	256(ra) # 800009c8 <initlock>
  (*f0)->type = FD_PIPE;
    800048d0:	609c                	ld	a5,0(s1)
    800048d2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800048d6:	609c                	ld	a5,0(s1)
    800048d8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800048dc:	609c                	ld	a5,0(s1)
    800048de:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800048e2:	609c                	ld	a5,0(s1)
    800048e4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800048e8:	000a3783          	ld	a5,0(s4)
    800048ec:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800048f0:	000a3783          	ld	a5,0(s4)
    800048f4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800048f8:	000a3783          	ld	a5,0(s4)
    800048fc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004900:	000a3783          	ld	a5,0(s4)
    80004904:	0127b823          	sd	s2,16(a5)
  return 0;
    80004908:	4501                	li	a0,0
    8000490a:	a025                	j	80004932 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000490c:	6088                	ld	a0,0(s1)
    8000490e:	e501                	bnez	a0,80004916 <pipealloc+0xaa>
    80004910:	a039                	j	8000491e <pipealloc+0xb2>
    80004912:	6088                	ld	a0,0(s1)
    80004914:	c51d                	beqz	a0,80004942 <pipealloc+0xd6>
    fileclose(*f0);
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	c22080e7          	jalr	-990(ra) # 80004538 <fileclose>
  if(*f1)
    8000491e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004922:	557d                	li	a0,-1
  if(*f1)
    80004924:	c799                	beqz	a5,80004932 <pipealloc+0xc6>
    fileclose(*f1);
    80004926:	853e                	mv	a0,a5
    80004928:	00000097          	auipc	ra,0x0
    8000492c:	c10080e7          	jalr	-1008(ra) # 80004538 <fileclose>
  return -1;
    80004930:	557d                	li	a0,-1
}
    80004932:	70a2                	ld	ra,40(sp)
    80004934:	7402                	ld	s0,32(sp)
    80004936:	64e2                	ld	s1,24(sp)
    80004938:	6942                	ld	s2,16(sp)
    8000493a:	69a2                	ld	s3,8(sp)
    8000493c:	6a02                	ld	s4,0(sp)
    8000493e:	6145                	addi	sp,sp,48
    80004940:	8082                	ret
  return -1;
    80004942:	557d                	li	a0,-1
    80004944:	b7fd                	j	80004932 <pipealloc+0xc6>

0000000080004946 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004946:	1101                	addi	sp,sp,-32
    80004948:	ec06                	sd	ra,24(sp)
    8000494a:	e822                	sd	s0,16(sp)
    8000494c:	e426                	sd	s1,8(sp)
    8000494e:	e04a                	sd	s2,0(sp)
    80004950:	1000                	addi	s0,sp,32
    80004952:	84aa                	mv	s1,a0
    80004954:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004956:	ffffc097          	auipc	ra,0xffffc
    8000495a:	180080e7          	jalr	384(ra) # 80000ad6 <acquire>
  if(writable){
    8000495e:	02090d63          	beqz	s2,80004998 <pipeclose+0x52>
    pi->writeopen = 0;
    80004962:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004966:	21848513          	addi	a0,s1,536
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	862080e7          	jalr	-1950(ra) # 800021cc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004972:	2204b783          	ld	a5,544(s1)
    80004976:	eb95                	bnez	a5,800049aa <pipeclose+0x64>
    release(&pi->lock);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffc097          	auipc	ra,0xffffc
    8000497e:	1c4080e7          	jalr	452(ra) # 80000b3e <release>
    kfree((char*)pi);
    80004982:	8526                	mv	a0,s1
    80004984:	ffffc097          	auipc	ra,0xffffc
    80004988:	ed0080e7          	jalr	-304(ra) # 80000854 <kfree>
  } else
    release(&pi->lock);
}
    8000498c:	60e2                	ld	ra,24(sp)
    8000498e:	6442                	ld	s0,16(sp)
    80004990:	64a2                	ld	s1,8(sp)
    80004992:	6902                	ld	s2,0(sp)
    80004994:	6105                	addi	sp,sp,32
    80004996:	8082                	ret
    pi->readopen = 0;
    80004998:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000499c:	21c48513          	addi	a0,s1,540
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	82c080e7          	jalr	-2004(ra) # 800021cc <wakeup>
    800049a8:	b7e9                	j	80004972 <pipeclose+0x2c>
    release(&pi->lock);
    800049aa:	8526                	mv	a0,s1
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	192080e7          	jalr	402(ra) # 80000b3e <release>
}
    800049b4:	bfe1                	j	8000498c <pipeclose+0x46>

00000000800049b6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800049b6:	711d                	addi	sp,sp,-96
    800049b8:	ec86                	sd	ra,88(sp)
    800049ba:	e8a2                	sd	s0,80(sp)
    800049bc:	e4a6                	sd	s1,72(sp)
    800049be:	e0ca                	sd	s2,64(sp)
    800049c0:	fc4e                	sd	s3,56(sp)
    800049c2:	f852                	sd	s4,48(sp)
    800049c4:	f456                	sd	s5,40(sp)
    800049c6:	f05a                	sd	s6,32(sp)
    800049c8:	ec5e                	sd	s7,24(sp)
    800049ca:	e862                	sd	s8,16(sp)
    800049cc:	1080                	addi	s0,sp,96
    800049ce:	84aa                	mv	s1,a0
    800049d0:	8aae                	mv	s5,a1
    800049d2:	8a32                	mv	s4,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    800049d4:	ffffd097          	auipc	ra,0xffffd
    800049d8:	e62080e7          	jalr	-414(ra) # 80001836 <myproc>
    800049dc:	8baa                	mv	s7,a0

  acquire(&pi->lock);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffc097          	auipc	ra,0xffffc
    800049e4:	0f6080e7          	jalr	246(ra) # 80000ad6 <acquire>
  for(i = 0; i < n; i++){
    800049e8:	09405f63          	blez	s4,80004a86 <pipewrite+0xd0>
    800049ec:	fffa0b1b          	addiw	s6,s4,-1
    800049f0:	1b02                	slli	s6,s6,0x20
    800049f2:	020b5b13          	srli	s6,s6,0x20
    800049f6:	001a8793          	addi	a5,s5,1
    800049fa:	9b3e                	add	s6,s6,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    800049fc:	21848993          	addi	s3,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a00:	21c48913          	addi	s2,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a04:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a06:	2184a783          	lw	a5,536(s1)
    80004a0a:	21c4a703          	lw	a4,540(s1)
    80004a0e:	2007879b          	addiw	a5,a5,512
    80004a12:	02f71e63          	bne	a4,a5,80004a4e <pipewrite+0x98>
      if(pi->readopen == 0 || myproc()->killed){
    80004a16:	2204a783          	lw	a5,544(s1)
    80004a1a:	c3d9                	beqz	a5,80004aa0 <pipewrite+0xea>
    80004a1c:	ffffd097          	auipc	ra,0xffffd
    80004a20:	e1a080e7          	jalr	-486(ra) # 80001836 <myproc>
    80004a24:	591c                	lw	a5,48(a0)
    80004a26:	efad                	bnez	a5,80004aa0 <pipewrite+0xea>
      wakeup(&pi->nread);
    80004a28:	854e                	mv	a0,s3
    80004a2a:	ffffd097          	auipc	ra,0xffffd
    80004a2e:	7a2080e7          	jalr	1954(ra) # 800021cc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004a32:	85a6                	mv	a1,s1
    80004a34:	854a                	mv	a0,s2
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	616080e7          	jalr	1558(ra) # 8000204c <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a3e:	2184a783          	lw	a5,536(s1)
    80004a42:	21c4a703          	lw	a4,540(s1)
    80004a46:	2007879b          	addiw	a5,a5,512
    80004a4a:	fcf706e3          	beq	a4,a5,80004a16 <pipewrite+0x60>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a4e:	4685                	li	a3,1
    80004a50:	8656                	mv	a2,s5
    80004a52:	faf40593          	addi	a1,s0,-81
    80004a56:	050bb503          	ld	a0,80(s7) # 1050 <_entry-0x7fffefb0>
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	b92080e7          	jalr	-1134(ra) # 800015ec <copyin>
    80004a62:	03850263          	beq	a0,s8,80004a86 <pipewrite+0xd0>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004a66:	21c4a783          	lw	a5,540(s1)
    80004a6a:	0017871b          	addiw	a4,a5,1
    80004a6e:	20e4ae23          	sw	a4,540(s1)
    80004a72:	1ff7f793          	andi	a5,a5,511
    80004a76:	97a6                	add	a5,a5,s1
    80004a78:	faf44703          	lbu	a4,-81(s0)
    80004a7c:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004a80:	0a85                	addi	s5,s5,1
    80004a82:	f96a92e3          	bne	s5,s6,80004a06 <pipewrite+0x50>
  }
  wakeup(&pi->nread);
    80004a86:	21848513          	addi	a0,s1,536
    80004a8a:	ffffd097          	auipc	ra,0xffffd
    80004a8e:	742080e7          	jalr	1858(ra) # 800021cc <wakeup>
  release(&pi->lock);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffc097          	auipc	ra,0xffffc
    80004a98:	0aa080e7          	jalr	170(ra) # 80000b3e <release>
  return n;
    80004a9c:	8552                	mv	a0,s4
    80004a9e:	a039                	j	80004aac <pipewrite+0xf6>
        release(&pi->lock);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffc097          	auipc	ra,0xffffc
    80004aa6:	09c080e7          	jalr	156(ra) # 80000b3e <release>
        return -1;
    80004aaa:	557d                	li	a0,-1
}
    80004aac:	60e6                	ld	ra,88(sp)
    80004aae:	6446                	ld	s0,80(sp)
    80004ab0:	64a6                	ld	s1,72(sp)
    80004ab2:	6906                	ld	s2,64(sp)
    80004ab4:	79e2                	ld	s3,56(sp)
    80004ab6:	7a42                	ld	s4,48(sp)
    80004ab8:	7aa2                	ld	s5,40(sp)
    80004aba:	7b02                	ld	s6,32(sp)
    80004abc:	6be2                	ld	s7,24(sp)
    80004abe:	6c42                	ld	s8,16(sp)
    80004ac0:	6125                	addi	sp,sp,96
    80004ac2:	8082                	ret

0000000080004ac4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ac4:	715d                	addi	sp,sp,-80
    80004ac6:	e486                	sd	ra,72(sp)
    80004ac8:	e0a2                	sd	s0,64(sp)
    80004aca:	fc26                	sd	s1,56(sp)
    80004acc:	f84a                	sd	s2,48(sp)
    80004ace:	f44e                	sd	s3,40(sp)
    80004ad0:	f052                	sd	s4,32(sp)
    80004ad2:	ec56                	sd	s5,24(sp)
    80004ad4:	e85a                	sd	s6,16(sp)
    80004ad6:	0880                	addi	s0,sp,80
    80004ad8:	84aa                	mv	s1,a0
    80004ada:	892e                	mv	s2,a1
    80004adc:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	d58080e7          	jalr	-680(ra) # 80001836 <myproc>
    80004ae6:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffc097          	auipc	ra,0xffffc
    80004aee:	fec080e7          	jalr	-20(ra) # 80000ad6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004af2:	2184a703          	lw	a4,536(s1)
    80004af6:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004afa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004afe:	02f71763          	bne	a4,a5,80004b2c <piperead+0x68>
    80004b02:	2244a783          	lw	a5,548(s1)
    80004b06:	c39d                	beqz	a5,80004b2c <piperead+0x68>
    if(myproc()->killed){
    80004b08:	ffffd097          	auipc	ra,0xffffd
    80004b0c:	d2e080e7          	jalr	-722(ra) # 80001836 <myproc>
    80004b10:	591c                	lw	a5,48(a0)
    80004b12:	ebc1                	bnez	a5,80004ba2 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b14:	85a6                	mv	a1,s1
    80004b16:	854e                	mv	a0,s3
    80004b18:	ffffd097          	auipc	ra,0xffffd
    80004b1c:	534080e7          	jalr	1332(ra) # 8000204c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b20:	2184a703          	lw	a4,536(s1)
    80004b24:	21c4a783          	lw	a5,540(s1)
    80004b28:	fcf70de3          	beq	a4,a5,80004b02 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b2c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b2e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b30:	05405363          	blez	s4,80004b76 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004b34:	2184a783          	lw	a5,536(s1)
    80004b38:	21c4a703          	lw	a4,540(s1)
    80004b3c:	02f70d63          	beq	a4,a5,80004b76 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b40:	0017871b          	addiw	a4,a5,1
    80004b44:	20e4ac23          	sw	a4,536(s1)
    80004b48:	1ff7f793          	andi	a5,a5,511
    80004b4c:	97a6                	add	a5,a5,s1
    80004b4e:	0187c783          	lbu	a5,24(a5)
    80004b52:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b56:	4685                	li	a3,1
    80004b58:	fbf40613          	addi	a2,s0,-65
    80004b5c:	85ca                	mv	a1,s2
    80004b5e:	050ab503          	ld	a0,80(s5)
    80004b62:	ffffd097          	auipc	ra,0xffffd
    80004b66:	9f8080e7          	jalr	-1544(ra) # 8000155a <copyout>
    80004b6a:	01650663          	beq	a0,s6,80004b76 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b6e:	2985                	addiw	s3,s3,1
    80004b70:	0905                	addi	s2,s2,1
    80004b72:	fd3a11e3          	bne	s4,s3,80004b34 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004b76:	21c48513          	addi	a0,s1,540
    80004b7a:	ffffd097          	auipc	ra,0xffffd
    80004b7e:	652080e7          	jalr	1618(ra) # 800021cc <wakeup>
  release(&pi->lock);
    80004b82:	8526                	mv	a0,s1
    80004b84:	ffffc097          	auipc	ra,0xffffc
    80004b88:	fba080e7          	jalr	-70(ra) # 80000b3e <release>
  return i;
}
    80004b8c:	854e                	mv	a0,s3
    80004b8e:	60a6                	ld	ra,72(sp)
    80004b90:	6406                	ld	s0,64(sp)
    80004b92:	74e2                	ld	s1,56(sp)
    80004b94:	7942                	ld	s2,48(sp)
    80004b96:	79a2                	ld	s3,40(sp)
    80004b98:	7a02                	ld	s4,32(sp)
    80004b9a:	6ae2                	ld	s5,24(sp)
    80004b9c:	6b42                	ld	s6,16(sp)
    80004b9e:	6161                	addi	sp,sp,80
    80004ba0:	8082                	ret
      release(&pi->lock);
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffc097          	auipc	ra,0xffffc
    80004ba8:	f9a080e7          	jalr	-102(ra) # 80000b3e <release>
      return -1;
    80004bac:	59fd                	li	s3,-1
    80004bae:	bff9                	j	80004b8c <piperead+0xc8>

0000000080004bb0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004bb0:	de010113          	addi	sp,sp,-544
    80004bb4:	20113c23          	sd	ra,536(sp)
    80004bb8:	20813823          	sd	s0,528(sp)
    80004bbc:	20913423          	sd	s1,520(sp)
    80004bc0:	21213023          	sd	s2,512(sp)
    80004bc4:	ffce                	sd	s3,504(sp)
    80004bc6:	fbd2                	sd	s4,496(sp)
    80004bc8:	f7d6                	sd	s5,488(sp)
    80004bca:	f3da                	sd	s6,480(sp)
    80004bcc:	efde                	sd	s7,472(sp)
    80004bce:	ebe2                	sd	s8,464(sp)
    80004bd0:	e7e6                	sd	s9,456(sp)
    80004bd2:	e3ea                	sd	s10,448(sp)
    80004bd4:	ff6e                	sd	s11,440(sp)
    80004bd6:	1400                	addi	s0,sp,544
    80004bd8:	892a                	mv	s2,a0
    80004bda:	dea43423          	sd	a0,-536(s0)
    80004bde:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004be2:	ffffd097          	auipc	ra,0xffffd
    80004be6:	c54080e7          	jalr	-940(ra) # 80001836 <myproc>
    80004bea:	84aa                	mv	s1,a0

  begin_op(ROOTDEV);
    80004bec:	4501                	li	a0,0
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	322080e7          	jalr	802(ra) # 80003f10 <begin_op>

  if((ip = namei(path)) == 0){
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	ffa080e7          	jalr	-6(ra) # 80003bf2 <namei>
    80004c00:	cd25                	beqz	a0,80004c78 <exec+0xc8>
    80004c02:	8aaa                	mv	s5,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	862080e7          	jalr	-1950(ra) # 80003466 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c0c:	04000713          	li	a4,64
    80004c10:	4681                	li	a3,0
    80004c12:	e4840613          	addi	a2,s0,-440
    80004c16:	4581                	li	a1,0
    80004c18:	8556                	mv	a0,s5
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	adc080e7          	jalr	-1316(ra) # 800036f6 <readi>
    80004c22:	04000793          	li	a5,64
    80004c26:	00f51a63          	bne	a0,a5,80004c3a <exec+0x8a>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c2a:	e4842703          	lw	a4,-440(s0)
    80004c2e:	464c47b7          	lui	a5,0x464c4
    80004c32:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c36:	04f70863          	beq	a4,a5,80004c86 <exec+0xd6>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c3a:	8556                	mv	a0,s5
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	a68080e7          	jalr	-1432(ra) # 800036a4 <iunlockput>
    end_op(ROOTDEV);
    80004c44:	4501                	li	a0,0
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	374080e7          	jalr	884(ra) # 80003fba <end_op>
  }
  return -1;
    80004c4e:	557d                	li	a0,-1
}
    80004c50:	21813083          	ld	ra,536(sp)
    80004c54:	21013403          	ld	s0,528(sp)
    80004c58:	20813483          	ld	s1,520(sp)
    80004c5c:	20013903          	ld	s2,512(sp)
    80004c60:	79fe                	ld	s3,504(sp)
    80004c62:	7a5e                	ld	s4,496(sp)
    80004c64:	7abe                	ld	s5,488(sp)
    80004c66:	7b1e                	ld	s6,480(sp)
    80004c68:	6bfe                	ld	s7,472(sp)
    80004c6a:	6c5e                	ld	s8,464(sp)
    80004c6c:	6cbe                	ld	s9,456(sp)
    80004c6e:	6d1e                	ld	s10,448(sp)
    80004c70:	7dfa                	ld	s11,440(sp)
    80004c72:	22010113          	addi	sp,sp,544
    80004c76:	8082                	ret
    end_op(ROOTDEV);
    80004c78:	4501                	li	a0,0
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	340080e7          	jalr	832(ra) # 80003fba <end_op>
    return -1;
    80004c82:	557d                	li	a0,-1
    80004c84:	b7f1                	j	80004c50 <exec+0xa0>
  if((pagetable = proc_pagetable(p)) == 0)
    80004c86:	8526                	mv	a0,s1
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	c72080e7          	jalr	-910(ra) # 800018fa <proc_pagetable>
    80004c90:	8b2a                	mv	s6,a0
    80004c92:	d545                	beqz	a0,80004c3a <exec+0x8a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c94:	e6842783          	lw	a5,-408(s0)
    80004c98:	e8045703          	lhu	a4,-384(s0)
    80004c9c:	10070263          	beqz	a4,80004da0 <exec+0x1f0>
  sz = 0;
    80004ca0:	de043c23          	sd	zero,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ca4:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004ca8:	6a05                	lui	s4,0x1
    80004caa:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004cae:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004cb2:	6d85                	lui	s11,0x1
    80004cb4:	7d7d                	lui	s10,0xfffff
    80004cb6:	a88d                	j	80004d28 <exec+0x178>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004cb8:	00003517          	auipc	a0,0x3
    80004cbc:	a7850513          	addi	a0,a0,-1416 # 80007730 <userret+0x6a0>
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	888080e7          	jalr	-1912(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004cc8:	874a                	mv	a4,s2
    80004cca:	009c86bb          	addw	a3,s9,s1
    80004cce:	4581                	li	a1,0
    80004cd0:	8556                	mv	a0,s5
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	a24080e7          	jalr	-1500(ra) # 800036f6 <readi>
    80004cda:	2501                	sext.w	a0,a0
    80004cdc:	10a91863          	bne	s2,a0,80004dec <exec+0x23c>
  for(i = 0; i < sz; i += PGSIZE){
    80004ce0:	009d84bb          	addw	s1,s11,s1
    80004ce4:	013d09bb          	addw	s3,s10,s3
    80004ce8:	0374f263          	bgeu	s1,s7,80004d0c <exec+0x15c>
    pa = walkaddr(pagetable, va + i);
    80004cec:	02049593          	slli	a1,s1,0x20
    80004cf0:	9181                	srli	a1,a1,0x20
    80004cf2:	95e2                	add	a1,a1,s8
    80004cf4:	855a                	mv	a0,s6
    80004cf6:	ffffc097          	auipc	ra,0xffffc
    80004cfa:	29e080e7          	jalr	670(ra) # 80000f94 <walkaddr>
    80004cfe:	862a                	mv	a2,a0
    if(pa == 0)
    80004d00:	dd45                	beqz	a0,80004cb8 <exec+0x108>
      n = PGSIZE;
    80004d02:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d04:	fd49f2e3          	bgeu	s3,s4,80004cc8 <exec+0x118>
      n = sz - i;
    80004d08:	894e                	mv	s2,s3
    80004d0a:	bf7d                	j	80004cc8 <exec+0x118>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d0c:	e0843783          	ld	a5,-504(s0)
    80004d10:	0017869b          	addiw	a3,a5,1
    80004d14:	e0d43423          	sd	a3,-504(s0)
    80004d18:	e0043783          	ld	a5,-512(s0)
    80004d1c:	0387879b          	addiw	a5,a5,56
    80004d20:	e8045703          	lhu	a4,-384(s0)
    80004d24:	08e6d063          	bge	a3,a4,80004da4 <exec+0x1f4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004d28:	2781                	sext.w	a5,a5
    80004d2a:	e0f43023          	sd	a5,-512(s0)
    80004d2e:	03800713          	li	a4,56
    80004d32:	86be                	mv	a3,a5
    80004d34:	e1040613          	addi	a2,s0,-496
    80004d38:	4581                	li	a1,0
    80004d3a:	8556                	mv	a0,s5
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	9ba080e7          	jalr	-1606(ra) # 800036f6 <readi>
    80004d44:	03800793          	li	a5,56
    80004d48:	0af51263          	bne	a0,a5,80004dec <exec+0x23c>
    if(ph.type != ELF_PROG_LOAD)
    80004d4c:	e1042783          	lw	a5,-496(s0)
    80004d50:	4705                	li	a4,1
    80004d52:	fae79de3          	bne	a5,a4,80004d0c <exec+0x15c>
    if(ph.memsz < ph.filesz)
    80004d56:	e3843603          	ld	a2,-456(s0)
    80004d5a:	e3043783          	ld	a5,-464(s0)
    80004d5e:	08f66763          	bltu	a2,a5,80004dec <exec+0x23c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004d62:	e2043783          	ld	a5,-480(s0)
    80004d66:	963e                	add	a2,a2,a5
    80004d68:	08f66263          	bltu	a2,a5,80004dec <exec+0x23c>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004d6c:	df843583          	ld	a1,-520(s0)
    80004d70:	855a                	mv	a0,s6
    80004d72:	ffffc097          	auipc	ra,0xffffc
    80004d76:	60e080e7          	jalr	1550(ra) # 80001380 <uvmalloc>
    80004d7a:	dea43c23          	sd	a0,-520(s0)
    80004d7e:	c53d                	beqz	a0,80004dec <exec+0x23c>
    if(ph.vaddr % PGSIZE != 0)
    80004d80:	e2043c03          	ld	s8,-480(s0)
    80004d84:	de043783          	ld	a5,-544(s0)
    80004d88:	00fc77b3          	and	a5,s8,a5
    80004d8c:	e3a5                	bnez	a5,80004dec <exec+0x23c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004d8e:	e1842c83          	lw	s9,-488(s0)
    80004d92:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004d96:	f60b8be3          	beqz	s7,80004d0c <exec+0x15c>
    80004d9a:	89de                	mv	s3,s7
    80004d9c:	4481                	li	s1,0
    80004d9e:	b7b9                	j	80004cec <exec+0x13c>
  sz = 0;
    80004da0:	de043c23          	sd	zero,-520(s0)
  iunlockput(ip);
    80004da4:	8556                	mv	a0,s5
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	8fe080e7          	jalr	-1794(ra) # 800036a4 <iunlockput>
  end_op(ROOTDEV);
    80004dae:	4501                	li	a0,0
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	20a080e7          	jalr	522(ra) # 80003fba <end_op>
  p = myproc();
    80004db8:	ffffd097          	auipc	ra,0xffffd
    80004dbc:	a7e080e7          	jalr	-1410(ra) # 80001836 <myproc>
    80004dc0:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dc2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004dc6:	6585                	lui	a1,0x1
    80004dc8:	15fd                	addi	a1,a1,-1
    80004dca:	df843783          	ld	a5,-520(s0)
    80004dce:	95be                	add	a1,a1,a5
    80004dd0:	77fd                	lui	a5,0xfffff
    80004dd2:	8dfd                	and	a1,a1,a5
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dd4:	6609                	lui	a2,0x2
    80004dd6:	962e                	add	a2,a2,a1
    80004dd8:	855a                	mv	a0,s6
    80004dda:	ffffc097          	auipc	ra,0xffffc
    80004dde:	5a6080e7          	jalr	1446(ra) # 80001380 <uvmalloc>
    80004de2:	892a                	mv	s2,a0
    80004de4:	dea43c23          	sd	a0,-520(s0)
  ip = 0;
    80004de8:	4a81                	li	s5,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dea:	ed01                	bnez	a0,80004e02 <exec+0x252>
    proc_freepagetable(pagetable, sz);
    80004dec:	df843583          	ld	a1,-520(s0)
    80004df0:	855a                	mv	a0,s6
    80004df2:	ffffd097          	auipc	ra,0xffffd
    80004df6:	c08080e7          	jalr	-1016(ra) # 800019fa <proc_freepagetable>
  if(ip){
    80004dfa:	e40a90e3          	bnez	s5,80004c3a <exec+0x8a>
  return -1;
    80004dfe:	557d                	li	a0,-1
    80004e00:	bd81                	j	80004c50 <exec+0xa0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e02:	75f9                	lui	a1,0xffffe
    80004e04:	95aa                	add	a1,a1,a0
    80004e06:	855a                	mv	a0,s6
    80004e08:	ffffc097          	auipc	ra,0xffffc
    80004e0c:	720080e7          	jalr	1824(ra) # 80001528 <uvmclear>
  stackbase = sp - PGSIZE;
    80004e10:	7c7d                	lui	s8,0xfffff
    80004e12:	9c4a                	add	s8,s8,s2
  for(argc = 0; argv[argc]; argc++) {
    80004e14:	df043783          	ld	a5,-528(s0)
    80004e18:	6388                	ld	a0,0(a5)
    80004e1a:	c52d                	beqz	a0,80004e84 <exec+0x2d4>
    80004e1c:	e8840993          	addi	s3,s0,-376
    80004e20:	f8840a93          	addi	s5,s0,-120
    80004e24:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e26:	ffffc097          	auipc	ra,0xffffc
    80004e2a:	ef8080e7          	jalr	-264(ra) # 80000d1e <strlen>
    80004e2e:	0015079b          	addiw	a5,a0,1
    80004e32:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e36:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004e3a:	0f896b63          	bltu	s2,s8,80004f30 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e3e:	df043d03          	ld	s10,-528(s0)
    80004e42:	000d3a03          	ld	s4,0(s10) # fffffffffffff000 <end+0xffffffff7ffd5fbc>
    80004e46:	8552                	mv	a0,s4
    80004e48:	ffffc097          	auipc	ra,0xffffc
    80004e4c:	ed6080e7          	jalr	-298(ra) # 80000d1e <strlen>
    80004e50:	0015069b          	addiw	a3,a0,1
    80004e54:	8652                	mv	a2,s4
    80004e56:	85ca                	mv	a1,s2
    80004e58:	855a                	mv	a0,s6
    80004e5a:	ffffc097          	auipc	ra,0xffffc
    80004e5e:	700080e7          	jalr	1792(ra) # 8000155a <copyout>
    80004e62:	0c054963          	bltz	a0,80004f34 <exec+0x384>
    ustack[argc] = sp;
    80004e66:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e6a:	0485                	addi	s1,s1,1
    80004e6c:	008d0793          	addi	a5,s10,8
    80004e70:	def43823          	sd	a5,-528(s0)
    80004e74:	008d3503          	ld	a0,8(s10)
    80004e78:	c909                	beqz	a0,80004e8a <exec+0x2da>
    if(argc >= MAXARG)
    80004e7a:	09a1                	addi	s3,s3,8
    80004e7c:	fb3a95e3          	bne	s5,s3,80004e26 <exec+0x276>
  ip = 0;
    80004e80:	4a81                	li	s5,0
    80004e82:	b7ad                	j	80004dec <exec+0x23c>
  sp = sz;
    80004e84:	df843903          	ld	s2,-520(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004e88:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e8a:	00349793          	slli	a5,s1,0x3
    80004e8e:	f9040713          	addi	a4,s0,-112
    80004e92:	97ba                	add	a5,a5,a4
    80004e94:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd5eb4>
  sp -= (argc+1) * sizeof(uint64);
    80004e98:	00148693          	addi	a3,s1,1
    80004e9c:	068e                	slli	a3,a3,0x3
    80004e9e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ea2:	ff097913          	andi	s2,s2,-16
  ip = 0;
    80004ea6:	4a81                	li	s5,0
  if(sp < stackbase)
    80004ea8:	f58962e3          	bltu	s2,s8,80004dec <exec+0x23c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004eac:	e8840613          	addi	a2,s0,-376
    80004eb0:	85ca                	mv	a1,s2
    80004eb2:	855a                	mv	a0,s6
    80004eb4:	ffffc097          	auipc	ra,0xffffc
    80004eb8:	6a6080e7          	jalr	1702(ra) # 8000155a <copyout>
    80004ebc:	06054e63          	bltz	a0,80004f38 <exec+0x388>
  p->tf->a1 = sp;
    80004ec0:	058bb783          	ld	a5,88(s7)
    80004ec4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ec8:	de843783          	ld	a5,-536(s0)
    80004ecc:	0007c703          	lbu	a4,0(a5)
    80004ed0:	cf11                	beqz	a4,80004eec <exec+0x33c>
    80004ed2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004ed4:	02f00693          	li	a3,47
    80004ed8:	a039                	j	80004ee6 <exec+0x336>
      last = s+1;
    80004eda:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004ede:	0785                	addi	a5,a5,1
    80004ee0:	fff7c703          	lbu	a4,-1(a5)
    80004ee4:	c701                	beqz	a4,80004eec <exec+0x33c>
    if(*s == '/')
    80004ee6:	fed71ce3          	bne	a4,a3,80004ede <exec+0x32e>
    80004eea:	bfc5                	j	80004eda <exec+0x32a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004eec:	4641                	li	a2,16
    80004eee:	de843583          	ld	a1,-536(s0)
    80004ef2:	158b8513          	addi	a0,s7,344
    80004ef6:	ffffc097          	auipc	ra,0xffffc
    80004efa:	df6080e7          	jalr	-522(ra) # 80000cec <safestrcpy>
  oldpagetable = p->pagetable;
    80004efe:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004f02:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004f06:	df843783          	ld	a5,-520(s0)
    80004f0a:	04fbb423          	sd	a5,72(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004f0e:	058bb783          	ld	a5,88(s7)
    80004f12:	e6043703          	ld	a4,-416(s0)
    80004f16:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004f18:	058bb783          	ld	a5,88(s7)
    80004f1c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f20:	85e6                	mv	a1,s9
    80004f22:	ffffd097          	auipc	ra,0xffffd
    80004f26:	ad8080e7          	jalr	-1320(ra) # 800019fa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f2a:	0004851b          	sext.w	a0,s1
    80004f2e:	b30d                	j	80004c50 <exec+0xa0>
  ip = 0;
    80004f30:	4a81                	li	s5,0
    80004f32:	bd6d                	j	80004dec <exec+0x23c>
    80004f34:	4a81                	li	s5,0
    80004f36:	bd5d                	j	80004dec <exec+0x23c>
    80004f38:	4a81                	li	s5,0
    80004f3a:	bd4d                	j	80004dec <exec+0x23c>

0000000080004f3c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f3c:	7179                	addi	sp,sp,-48
    80004f3e:	f406                	sd	ra,40(sp)
    80004f40:	f022                	sd	s0,32(sp)
    80004f42:	ec26                	sd	s1,24(sp)
    80004f44:	e84a                	sd	s2,16(sp)
    80004f46:	1800                	addi	s0,sp,48
    80004f48:	892e                	mv	s2,a1
    80004f4a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004f4c:	fdc40593          	addi	a1,s0,-36
    80004f50:	ffffe097          	auipc	ra,0xffffe
    80004f54:	9a0080e7          	jalr	-1632(ra) # 800028f0 <argint>
    80004f58:	04054063          	bltz	a0,80004f98 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004f5c:	fdc42703          	lw	a4,-36(s0)
    80004f60:	47bd                	li	a5,15
    80004f62:	02e7ed63          	bltu	a5,a4,80004f9c <argfd+0x60>
    80004f66:	ffffd097          	auipc	ra,0xffffd
    80004f6a:	8d0080e7          	jalr	-1840(ra) # 80001836 <myproc>
    80004f6e:	fdc42703          	lw	a4,-36(s0)
    80004f72:	01a70793          	addi	a5,a4,26
    80004f76:	078e                	slli	a5,a5,0x3
    80004f78:	953e                	add	a0,a0,a5
    80004f7a:	611c                	ld	a5,0(a0)
    80004f7c:	c395                	beqz	a5,80004fa0 <argfd+0x64>
    return -1;
  if(pfd)
    80004f7e:	00090463          	beqz	s2,80004f86 <argfd+0x4a>
    *pfd = fd;
    80004f82:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f86:	4501                	li	a0,0
  if(pf)
    80004f88:	c091                	beqz	s1,80004f8c <argfd+0x50>
    *pf = f;
    80004f8a:	e09c                	sd	a5,0(s1)
}
    80004f8c:	70a2                	ld	ra,40(sp)
    80004f8e:	7402                	ld	s0,32(sp)
    80004f90:	64e2                	ld	s1,24(sp)
    80004f92:	6942                	ld	s2,16(sp)
    80004f94:	6145                	addi	sp,sp,48
    80004f96:	8082                	ret
    return -1;
    80004f98:	557d                	li	a0,-1
    80004f9a:	bfcd                	j	80004f8c <argfd+0x50>
    return -1;
    80004f9c:	557d                	li	a0,-1
    80004f9e:	b7fd                	j	80004f8c <argfd+0x50>
    80004fa0:	557d                	li	a0,-1
    80004fa2:	b7ed                	j	80004f8c <argfd+0x50>

0000000080004fa4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004fa4:	1101                	addi	sp,sp,-32
    80004fa6:	ec06                	sd	ra,24(sp)
    80004fa8:	e822                	sd	s0,16(sp)
    80004faa:	e426                	sd	s1,8(sp)
    80004fac:	1000                	addi	s0,sp,32
    80004fae:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	886080e7          	jalr	-1914(ra) # 80001836 <myproc>
    80004fb8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004fba:	0d050793          	addi	a5,a0,208
    80004fbe:	4501                	li	a0,0
    80004fc0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004fc2:	6398                	ld	a4,0(a5)
    80004fc4:	cb19                	beqz	a4,80004fda <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004fc6:	2505                	addiw	a0,a0,1
    80004fc8:	07a1                	addi	a5,a5,8
    80004fca:	fed51ce3          	bne	a0,a3,80004fc2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004fce:	557d                	li	a0,-1
}
    80004fd0:	60e2                	ld	ra,24(sp)
    80004fd2:	6442                	ld	s0,16(sp)
    80004fd4:	64a2                	ld	s1,8(sp)
    80004fd6:	6105                	addi	sp,sp,32
    80004fd8:	8082                	ret
      p->ofile[fd] = f;
    80004fda:	01a50793          	addi	a5,a0,26
    80004fde:	078e                	slli	a5,a5,0x3
    80004fe0:	963e                	add	a2,a2,a5
    80004fe2:	e204                	sd	s1,0(a2)
      return fd;
    80004fe4:	b7f5                	j	80004fd0 <fdalloc+0x2c>

0000000080004fe6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004fe6:	715d                	addi	sp,sp,-80
    80004fe8:	e486                	sd	ra,72(sp)
    80004fea:	e0a2                	sd	s0,64(sp)
    80004fec:	fc26                	sd	s1,56(sp)
    80004fee:	f84a                	sd	s2,48(sp)
    80004ff0:	f44e                	sd	s3,40(sp)
    80004ff2:	f052                	sd	s4,32(sp)
    80004ff4:	ec56                	sd	s5,24(sp)
    80004ff6:	0880                	addi	s0,sp,80
    80004ff8:	89ae                	mv	s3,a1
    80004ffa:	8ab2                	mv	s5,a2
    80004ffc:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ffe:	fb040593          	addi	a1,s0,-80
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	c0e080e7          	jalr	-1010(ra) # 80003c10 <nameiparent>
    8000500a:	892a                	mv	s2,a0
    8000500c:	12050e63          	beqz	a0,80005148 <create+0x162>
    return 0;

  ilock(dp);
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	456080e7          	jalr	1110(ra) # 80003466 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005018:	4601                	li	a2,0
    8000501a:	fb040593          	addi	a1,s0,-80
    8000501e:	854a                	mv	a0,s2
    80005020:	fffff097          	auipc	ra,0xfffff
    80005024:	900080e7          	jalr	-1792(ra) # 80003920 <dirlookup>
    80005028:	84aa                	mv	s1,a0
    8000502a:	c921                	beqz	a0,8000507a <create+0x94>
    iunlockput(dp);
    8000502c:	854a                	mv	a0,s2
    8000502e:	ffffe097          	auipc	ra,0xffffe
    80005032:	676080e7          	jalr	1654(ra) # 800036a4 <iunlockput>
    ilock(ip);
    80005036:	8526                	mv	a0,s1
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	42e080e7          	jalr	1070(ra) # 80003466 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005040:	2981                	sext.w	s3,s3
    80005042:	4789                	li	a5,2
    80005044:	02f99463          	bne	s3,a5,8000506c <create+0x86>
    80005048:	0444d783          	lhu	a5,68(s1)
    8000504c:	37f9                	addiw	a5,a5,-2
    8000504e:	17c2                	slli	a5,a5,0x30
    80005050:	93c1                	srli	a5,a5,0x30
    80005052:	4705                	li	a4,1
    80005054:	00f76c63          	bltu	a4,a5,8000506c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005058:	8526                	mv	a0,s1
    8000505a:	60a6                	ld	ra,72(sp)
    8000505c:	6406                	ld	s0,64(sp)
    8000505e:	74e2                	ld	s1,56(sp)
    80005060:	7942                	ld	s2,48(sp)
    80005062:	79a2                	ld	s3,40(sp)
    80005064:	7a02                	ld	s4,32(sp)
    80005066:	6ae2                	ld	s5,24(sp)
    80005068:	6161                	addi	sp,sp,80
    8000506a:	8082                	ret
    iunlockput(ip);
    8000506c:	8526                	mv	a0,s1
    8000506e:	ffffe097          	auipc	ra,0xffffe
    80005072:	636080e7          	jalr	1590(ra) # 800036a4 <iunlockput>
    return 0;
    80005076:	4481                	li	s1,0
    80005078:	b7c5                	j	80005058 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000507a:	85ce                	mv	a1,s3
    8000507c:	00092503          	lw	a0,0(s2)
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	24e080e7          	jalr	590(ra) # 800032ce <ialloc>
    80005088:	84aa                	mv	s1,a0
    8000508a:	c521                	beqz	a0,800050d2 <create+0xec>
  ilock(ip);
    8000508c:	ffffe097          	auipc	ra,0xffffe
    80005090:	3da080e7          	jalr	986(ra) # 80003466 <ilock>
  ip->major = major;
    80005094:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005098:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000509c:	4a05                	li	s4,1
    8000509e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800050a2:	8526                	mv	a0,s1
    800050a4:	ffffe097          	auipc	ra,0xffffe
    800050a8:	2f8080e7          	jalr	760(ra) # 8000339c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800050ac:	2981                	sext.w	s3,s3
    800050ae:	03498a63          	beq	s3,s4,800050e2 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800050b2:	40d0                	lw	a2,4(s1)
    800050b4:	fb040593          	addi	a1,s0,-80
    800050b8:	854a                	mv	a0,s2
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	a76080e7          	jalr	-1418(ra) # 80003b30 <dirlink>
    800050c2:	06054b63          	bltz	a0,80005138 <create+0x152>
  iunlockput(dp);
    800050c6:	854a                	mv	a0,s2
    800050c8:	ffffe097          	auipc	ra,0xffffe
    800050cc:	5dc080e7          	jalr	1500(ra) # 800036a4 <iunlockput>
  return ip;
    800050d0:	b761                	j	80005058 <create+0x72>
    panic("create: ialloc");
    800050d2:	00002517          	auipc	a0,0x2
    800050d6:	67e50513          	addi	a0,a0,1662 # 80007750 <userret+0x6c0>
    800050da:	ffffb097          	auipc	ra,0xffffb
    800050de:	46e080e7          	jalr	1134(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    800050e2:	04a95783          	lhu	a5,74(s2)
    800050e6:	2785                	addiw	a5,a5,1
    800050e8:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800050ec:	854a                	mv	a0,s2
    800050ee:	ffffe097          	auipc	ra,0xffffe
    800050f2:	2ae080e7          	jalr	686(ra) # 8000339c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800050f6:	40d0                	lw	a2,4(s1)
    800050f8:	00002597          	auipc	a1,0x2
    800050fc:	66858593          	addi	a1,a1,1640 # 80007760 <userret+0x6d0>
    80005100:	8526                	mv	a0,s1
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	a2e080e7          	jalr	-1490(ra) # 80003b30 <dirlink>
    8000510a:	00054f63          	bltz	a0,80005128 <create+0x142>
    8000510e:	00492603          	lw	a2,4(s2)
    80005112:	00002597          	auipc	a1,0x2
    80005116:	65658593          	addi	a1,a1,1622 # 80007768 <userret+0x6d8>
    8000511a:	8526                	mv	a0,s1
    8000511c:	fffff097          	auipc	ra,0xfffff
    80005120:	a14080e7          	jalr	-1516(ra) # 80003b30 <dirlink>
    80005124:	f80557e3          	bgez	a0,800050b2 <create+0xcc>
      panic("create dots");
    80005128:	00002517          	auipc	a0,0x2
    8000512c:	64850513          	addi	a0,a0,1608 # 80007770 <userret+0x6e0>
    80005130:	ffffb097          	auipc	ra,0xffffb
    80005134:	418080e7          	jalr	1048(ra) # 80000548 <panic>
    panic("create: dirlink");
    80005138:	00002517          	auipc	a0,0x2
    8000513c:	64850513          	addi	a0,a0,1608 # 80007780 <userret+0x6f0>
    80005140:	ffffb097          	auipc	ra,0xffffb
    80005144:	408080e7          	jalr	1032(ra) # 80000548 <panic>
    return 0;
    80005148:	84aa                	mv	s1,a0
    8000514a:	b739                	j	80005058 <create+0x72>

000000008000514c <sys_dup>:
{
    8000514c:	7179                	addi	sp,sp,-48
    8000514e:	f406                	sd	ra,40(sp)
    80005150:	f022                	sd	s0,32(sp)
    80005152:	ec26                	sd	s1,24(sp)
    80005154:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005156:	fd840613          	addi	a2,s0,-40
    8000515a:	4581                	li	a1,0
    8000515c:	4501                	li	a0,0
    8000515e:	00000097          	auipc	ra,0x0
    80005162:	dde080e7          	jalr	-546(ra) # 80004f3c <argfd>
    return -1;
    80005166:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005168:	02054363          	bltz	a0,8000518e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000516c:	fd843503          	ld	a0,-40(s0)
    80005170:	00000097          	auipc	ra,0x0
    80005174:	e34080e7          	jalr	-460(ra) # 80004fa4 <fdalloc>
    80005178:	84aa                	mv	s1,a0
    return -1;
    8000517a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000517c:	00054963          	bltz	a0,8000518e <sys_dup+0x42>
  filedup(f);
    80005180:	fd843503          	ld	a0,-40(s0)
    80005184:	fffff097          	auipc	ra,0xfffff
    80005188:	362080e7          	jalr	866(ra) # 800044e6 <filedup>
  return fd;
    8000518c:	87a6                	mv	a5,s1
}
    8000518e:	853e                	mv	a0,a5
    80005190:	70a2                	ld	ra,40(sp)
    80005192:	7402                	ld	s0,32(sp)
    80005194:	64e2                	ld	s1,24(sp)
    80005196:	6145                	addi	sp,sp,48
    80005198:	8082                	ret

000000008000519a <sys_read>:
{
    8000519a:	7179                	addi	sp,sp,-48
    8000519c:	f406                	sd	ra,40(sp)
    8000519e:	f022                	sd	s0,32(sp)
    800051a0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051a2:	fe840613          	addi	a2,s0,-24
    800051a6:	4581                	li	a1,0
    800051a8:	4501                	li	a0,0
    800051aa:	00000097          	auipc	ra,0x0
    800051ae:	d92080e7          	jalr	-622(ra) # 80004f3c <argfd>
    return -1;
    800051b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051b4:	04054163          	bltz	a0,800051f6 <sys_read+0x5c>
    800051b8:	fe440593          	addi	a1,s0,-28
    800051bc:	4509                	li	a0,2
    800051be:	ffffd097          	auipc	ra,0xffffd
    800051c2:	732080e7          	jalr	1842(ra) # 800028f0 <argint>
    return -1;
    800051c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051c8:	02054763          	bltz	a0,800051f6 <sys_read+0x5c>
    800051cc:	fd840593          	addi	a1,s0,-40
    800051d0:	4505                	li	a0,1
    800051d2:	ffffd097          	auipc	ra,0xffffd
    800051d6:	740080e7          	jalr	1856(ra) # 80002912 <argaddr>
    return -1;
    800051da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051dc:	00054d63          	bltz	a0,800051f6 <sys_read+0x5c>
  return fileread(f, p, n);
    800051e0:	fe442603          	lw	a2,-28(s0)
    800051e4:	fd843583          	ld	a1,-40(s0)
    800051e8:	fe843503          	ld	a0,-24(s0)
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	48e080e7          	jalr	1166(ra) # 8000467a <fileread>
    800051f4:	87aa                	mv	a5,a0
}
    800051f6:	853e                	mv	a0,a5
    800051f8:	70a2                	ld	ra,40(sp)
    800051fa:	7402                	ld	s0,32(sp)
    800051fc:	6145                	addi	sp,sp,48
    800051fe:	8082                	ret

0000000080005200 <sys_write>:
{
    80005200:	7179                	addi	sp,sp,-48
    80005202:	f406                	sd	ra,40(sp)
    80005204:	f022                	sd	s0,32(sp)
    80005206:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005208:	fe840613          	addi	a2,s0,-24
    8000520c:	4581                	li	a1,0
    8000520e:	4501                	li	a0,0
    80005210:	00000097          	auipc	ra,0x0
    80005214:	d2c080e7          	jalr	-724(ra) # 80004f3c <argfd>
    return -1;
    80005218:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000521a:	04054163          	bltz	a0,8000525c <sys_write+0x5c>
    8000521e:	fe440593          	addi	a1,s0,-28
    80005222:	4509                	li	a0,2
    80005224:	ffffd097          	auipc	ra,0xffffd
    80005228:	6cc080e7          	jalr	1740(ra) # 800028f0 <argint>
    return -1;
    8000522c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000522e:	02054763          	bltz	a0,8000525c <sys_write+0x5c>
    80005232:	fd840593          	addi	a1,s0,-40
    80005236:	4505                	li	a0,1
    80005238:	ffffd097          	auipc	ra,0xffffd
    8000523c:	6da080e7          	jalr	1754(ra) # 80002912 <argaddr>
    return -1;
    80005240:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005242:	00054d63          	bltz	a0,8000525c <sys_write+0x5c>
  return filewrite(f, p, n);
    80005246:	fe442603          	lw	a2,-28(s0)
    8000524a:	fd843583          	ld	a1,-40(s0)
    8000524e:	fe843503          	ld	a0,-24(s0)
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	4d6080e7          	jalr	1238(ra) # 80004728 <filewrite>
    8000525a:	87aa                	mv	a5,a0
}
    8000525c:	853e                	mv	a0,a5
    8000525e:	70a2                	ld	ra,40(sp)
    80005260:	7402                	ld	s0,32(sp)
    80005262:	6145                	addi	sp,sp,48
    80005264:	8082                	ret

0000000080005266 <sys_close>:
{
    80005266:	1101                	addi	sp,sp,-32
    80005268:	ec06                	sd	ra,24(sp)
    8000526a:	e822                	sd	s0,16(sp)
    8000526c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000526e:	fe040613          	addi	a2,s0,-32
    80005272:	fec40593          	addi	a1,s0,-20
    80005276:	4501                	li	a0,0
    80005278:	00000097          	auipc	ra,0x0
    8000527c:	cc4080e7          	jalr	-828(ra) # 80004f3c <argfd>
    return -1;
    80005280:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005282:	02054463          	bltz	a0,800052aa <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005286:	ffffc097          	auipc	ra,0xffffc
    8000528a:	5b0080e7          	jalr	1456(ra) # 80001836 <myproc>
    8000528e:	fec42783          	lw	a5,-20(s0)
    80005292:	07e9                	addi	a5,a5,26
    80005294:	078e                	slli	a5,a5,0x3
    80005296:	97aa                	add	a5,a5,a0
    80005298:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000529c:	fe043503          	ld	a0,-32(s0)
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	298080e7          	jalr	664(ra) # 80004538 <fileclose>
  return 0;
    800052a8:	4781                	li	a5,0
}
    800052aa:	853e                	mv	a0,a5
    800052ac:	60e2                	ld	ra,24(sp)
    800052ae:	6442                	ld	s0,16(sp)
    800052b0:	6105                	addi	sp,sp,32
    800052b2:	8082                	ret

00000000800052b4 <sys_fstat>:
{
    800052b4:	1101                	addi	sp,sp,-32
    800052b6:	ec06                	sd	ra,24(sp)
    800052b8:	e822                	sd	s0,16(sp)
    800052ba:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052bc:	fe840613          	addi	a2,s0,-24
    800052c0:	4581                	li	a1,0
    800052c2:	4501                	li	a0,0
    800052c4:	00000097          	auipc	ra,0x0
    800052c8:	c78080e7          	jalr	-904(ra) # 80004f3c <argfd>
    return -1;
    800052cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052ce:	02054563          	bltz	a0,800052f8 <sys_fstat+0x44>
    800052d2:	fe040593          	addi	a1,s0,-32
    800052d6:	4505                	li	a0,1
    800052d8:	ffffd097          	auipc	ra,0xffffd
    800052dc:	63a080e7          	jalr	1594(ra) # 80002912 <argaddr>
    return -1;
    800052e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052e2:	00054b63          	bltz	a0,800052f8 <sys_fstat+0x44>
  return filestat(f, st);
    800052e6:	fe043583          	ld	a1,-32(s0)
    800052ea:	fe843503          	ld	a0,-24(s0)
    800052ee:	fffff097          	auipc	ra,0xfffff
    800052f2:	31a080e7          	jalr	794(ra) # 80004608 <filestat>
    800052f6:	87aa                	mv	a5,a0
}
    800052f8:	853e                	mv	a0,a5
    800052fa:	60e2                	ld	ra,24(sp)
    800052fc:	6442                	ld	s0,16(sp)
    800052fe:	6105                	addi	sp,sp,32
    80005300:	8082                	ret

0000000080005302 <sys_link>:
{
    80005302:	7169                	addi	sp,sp,-304
    80005304:	f606                	sd	ra,296(sp)
    80005306:	f222                	sd	s0,288(sp)
    80005308:	ee26                	sd	s1,280(sp)
    8000530a:	ea4a                	sd	s2,272(sp)
    8000530c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000530e:	08000613          	li	a2,128
    80005312:	ed040593          	addi	a1,s0,-304
    80005316:	4501                	li	a0,0
    80005318:	ffffd097          	auipc	ra,0xffffd
    8000531c:	61c080e7          	jalr	1564(ra) # 80002934 <argstr>
    return -1;
    80005320:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005322:	12054363          	bltz	a0,80005448 <sys_link+0x146>
    80005326:	08000613          	li	a2,128
    8000532a:	f5040593          	addi	a1,s0,-176
    8000532e:	4505                	li	a0,1
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	604080e7          	jalr	1540(ra) # 80002934 <argstr>
    return -1;
    80005338:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000533a:	10054763          	bltz	a0,80005448 <sys_link+0x146>
  begin_op(ROOTDEV);
    8000533e:	4501                	li	a0,0
    80005340:	fffff097          	auipc	ra,0xfffff
    80005344:	bd0080e7          	jalr	-1072(ra) # 80003f10 <begin_op>
  if((ip = namei(old)) == 0){
    80005348:	ed040513          	addi	a0,s0,-304
    8000534c:	fffff097          	auipc	ra,0xfffff
    80005350:	8a6080e7          	jalr	-1882(ra) # 80003bf2 <namei>
    80005354:	84aa                	mv	s1,a0
    80005356:	c559                	beqz	a0,800053e4 <sys_link+0xe2>
  ilock(ip);
    80005358:	ffffe097          	auipc	ra,0xffffe
    8000535c:	10e080e7          	jalr	270(ra) # 80003466 <ilock>
  if(ip->type == T_DIR){
    80005360:	04449703          	lh	a4,68(s1)
    80005364:	4785                	li	a5,1
    80005366:	08f70663          	beq	a4,a5,800053f2 <sys_link+0xf0>
  ip->nlink++;
    8000536a:	04a4d783          	lhu	a5,74(s1)
    8000536e:	2785                	addiw	a5,a5,1
    80005370:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005374:	8526                	mv	a0,s1
    80005376:	ffffe097          	auipc	ra,0xffffe
    8000537a:	026080e7          	jalr	38(ra) # 8000339c <iupdate>
  iunlock(ip);
    8000537e:	8526                	mv	a0,s1
    80005380:	ffffe097          	auipc	ra,0xffffe
    80005384:	1a8080e7          	jalr	424(ra) # 80003528 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005388:	fd040593          	addi	a1,s0,-48
    8000538c:	f5040513          	addi	a0,s0,-176
    80005390:	fffff097          	auipc	ra,0xfffff
    80005394:	880080e7          	jalr	-1920(ra) # 80003c10 <nameiparent>
    80005398:	892a                	mv	s2,a0
    8000539a:	cd2d                	beqz	a0,80005414 <sys_link+0x112>
  ilock(dp);
    8000539c:	ffffe097          	auipc	ra,0xffffe
    800053a0:	0ca080e7          	jalr	202(ra) # 80003466 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800053a4:	00092703          	lw	a4,0(s2)
    800053a8:	409c                	lw	a5,0(s1)
    800053aa:	06f71063          	bne	a4,a5,8000540a <sys_link+0x108>
    800053ae:	40d0                	lw	a2,4(s1)
    800053b0:	fd040593          	addi	a1,s0,-48
    800053b4:	854a                	mv	a0,s2
    800053b6:	ffffe097          	auipc	ra,0xffffe
    800053ba:	77a080e7          	jalr	1914(ra) # 80003b30 <dirlink>
    800053be:	04054663          	bltz	a0,8000540a <sys_link+0x108>
  iunlockput(dp);
    800053c2:	854a                	mv	a0,s2
    800053c4:	ffffe097          	auipc	ra,0xffffe
    800053c8:	2e0080e7          	jalr	736(ra) # 800036a4 <iunlockput>
  iput(ip);
    800053cc:	8526                	mv	a0,s1
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	1a6080e7          	jalr	422(ra) # 80003574 <iput>
  end_op(ROOTDEV);
    800053d6:	4501                	li	a0,0
    800053d8:	fffff097          	auipc	ra,0xfffff
    800053dc:	be2080e7          	jalr	-1054(ra) # 80003fba <end_op>
  return 0;
    800053e0:	4781                	li	a5,0
    800053e2:	a09d                	j	80005448 <sys_link+0x146>
    end_op(ROOTDEV);
    800053e4:	4501                	li	a0,0
    800053e6:	fffff097          	auipc	ra,0xfffff
    800053ea:	bd4080e7          	jalr	-1068(ra) # 80003fba <end_op>
    return -1;
    800053ee:	57fd                	li	a5,-1
    800053f0:	a8a1                	j	80005448 <sys_link+0x146>
    iunlockput(ip);
    800053f2:	8526                	mv	a0,s1
    800053f4:	ffffe097          	auipc	ra,0xffffe
    800053f8:	2b0080e7          	jalr	688(ra) # 800036a4 <iunlockput>
    end_op(ROOTDEV);
    800053fc:	4501                	li	a0,0
    800053fe:	fffff097          	auipc	ra,0xfffff
    80005402:	bbc080e7          	jalr	-1092(ra) # 80003fba <end_op>
    return -1;
    80005406:	57fd                	li	a5,-1
    80005408:	a081                	j	80005448 <sys_link+0x146>
    iunlockput(dp);
    8000540a:	854a                	mv	a0,s2
    8000540c:	ffffe097          	auipc	ra,0xffffe
    80005410:	298080e7          	jalr	664(ra) # 800036a4 <iunlockput>
  ilock(ip);
    80005414:	8526                	mv	a0,s1
    80005416:	ffffe097          	auipc	ra,0xffffe
    8000541a:	050080e7          	jalr	80(ra) # 80003466 <ilock>
  ip->nlink--;
    8000541e:	04a4d783          	lhu	a5,74(s1)
    80005422:	37fd                	addiw	a5,a5,-1
    80005424:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005428:	8526                	mv	a0,s1
    8000542a:	ffffe097          	auipc	ra,0xffffe
    8000542e:	f72080e7          	jalr	-142(ra) # 8000339c <iupdate>
  iunlockput(ip);
    80005432:	8526                	mv	a0,s1
    80005434:	ffffe097          	auipc	ra,0xffffe
    80005438:	270080e7          	jalr	624(ra) # 800036a4 <iunlockput>
  end_op(ROOTDEV);
    8000543c:	4501                	li	a0,0
    8000543e:	fffff097          	auipc	ra,0xfffff
    80005442:	b7c080e7          	jalr	-1156(ra) # 80003fba <end_op>
  return -1;
    80005446:	57fd                	li	a5,-1
}
    80005448:	853e                	mv	a0,a5
    8000544a:	70b2                	ld	ra,296(sp)
    8000544c:	7412                	ld	s0,288(sp)
    8000544e:	64f2                	ld	s1,280(sp)
    80005450:	6952                	ld	s2,272(sp)
    80005452:	6155                	addi	sp,sp,304
    80005454:	8082                	ret

0000000080005456 <sys_unlink>:
{
    80005456:	7151                	addi	sp,sp,-240
    80005458:	f586                	sd	ra,232(sp)
    8000545a:	f1a2                	sd	s0,224(sp)
    8000545c:	eda6                	sd	s1,216(sp)
    8000545e:	e9ca                	sd	s2,208(sp)
    80005460:	e5ce                	sd	s3,200(sp)
    80005462:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005464:	08000613          	li	a2,128
    80005468:	f3040593          	addi	a1,s0,-208
    8000546c:	4501                	li	a0,0
    8000546e:	ffffd097          	auipc	ra,0xffffd
    80005472:	4c6080e7          	jalr	1222(ra) # 80002934 <argstr>
    80005476:	18054463          	bltz	a0,800055fe <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    8000547a:	4501                	li	a0,0
    8000547c:	fffff097          	auipc	ra,0xfffff
    80005480:	a94080e7          	jalr	-1388(ra) # 80003f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005484:	fb040593          	addi	a1,s0,-80
    80005488:	f3040513          	addi	a0,s0,-208
    8000548c:	ffffe097          	auipc	ra,0xffffe
    80005490:	784080e7          	jalr	1924(ra) # 80003c10 <nameiparent>
    80005494:	84aa                	mv	s1,a0
    80005496:	cd61                	beqz	a0,8000556e <sys_unlink+0x118>
  ilock(dp);
    80005498:	ffffe097          	auipc	ra,0xffffe
    8000549c:	fce080e7          	jalr	-50(ra) # 80003466 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800054a0:	00002597          	auipc	a1,0x2
    800054a4:	2c058593          	addi	a1,a1,704 # 80007760 <userret+0x6d0>
    800054a8:	fb040513          	addi	a0,s0,-80
    800054ac:	ffffe097          	auipc	ra,0xffffe
    800054b0:	45a080e7          	jalr	1114(ra) # 80003906 <namecmp>
    800054b4:	14050c63          	beqz	a0,8000560c <sys_unlink+0x1b6>
    800054b8:	00002597          	auipc	a1,0x2
    800054bc:	2b058593          	addi	a1,a1,688 # 80007768 <userret+0x6d8>
    800054c0:	fb040513          	addi	a0,s0,-80
    800054c4:	ffffe097          	auipc	ra,0xffffe
    800054c8:	442080e7          	jalr	1090(ra) # 80003906 <namecmp>
    800054cc:	14050063          	beqz	a0,8000560c <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800054d0:	f2c40613          	addi	a2,s0,-212
    800054d4:	fb040593          	addi	a1,s0,-80
    800054d8:	8526                	mv	a0,s1
    800054da:	ffffe097          	auipc	ra,0xffffe
    800054de:	446080e7          	jalr	1094(ra) # 80003920 <dirlookup>
    800054e2:	892a                	mv	s2,a0
    800054e4:	12050463          	beqz	a0,8000560c <sys_unlink+0x1b6>
  ilock(ip);
    800054e8:	ffffe097          	auipc	ra,0xffffe
    800054ec:	f7e080e7          	jalr	-130(ra) # 80003466 <ilock>
  if(ip->nlink < 1)
    800054f0:	04a91783          	lh	a5,74(s2)
    800054f4:	08f05463          	blez	a5,8000557c <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800054f8:	04491703          	lh	a4,68(s2)
    800054fc:	4785                	li	a5,1
    800054fe:	08f70763          	beq	a4,a5,8000558c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005502:	4641                	li	a2,16
    80005504:	4581                	li	a1,0
    80005506:	fc040513          	addi	a0,s0,-64
    8000550a:	ffffb097          	auipc	ra,0xffffb
    8000550e:	690080e7          	jalr	1680(ra) # 80000b9a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005512:	4741                	li	a4,16
    80005514:	f2c42683          	lw	a3,-212(s0)
    80005518:	fc040613          	addi	a2,s0,-64
    8000551c:	4581                	li	a1,0
    8000551e:	8526                	mv	a0,s1
    80005520:	ffffe097          	auipc	ra,0xffffe
    80005524:	2ca080e7          	jalr	714(ra) # 800037ea <writei>
    80005528:	47c1                	li	a5,16
    8000552a:	0af51763          	bne	a0,a5,800055d8 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    8000552e:	04491703          	lh	a4,68(s2)
    80005532:	4785                	li	a5,1
    80005534:	0af70a63          	beq	a4,a5,800055e8 <sys_unlink+0x192>
  iunlockput(dp);
    80005538:	8526                	mv	a0,s1
    8000553a:	ffffe097          	auipc	ra,0xffffe
    8000553e:	16a080e7          	jalr	362(ra) # 800036a4 <iunlockput>
  ip->nlink--;
    80005542:	04a95783          	lhu	a5,74(s2)
    80005546:	37fd                	addiw	a5,a5,-1
    80005548:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000554c:	854a                	mv	a0,s2
    8000554e:	ffffe097          	auipc	ra,0xffffe
    80005552:	e4e080e7          	jalr	-434(ra) # 8000339c <iupdate>
  iunlockput(ip);
    80005556:	854a                	mv	a0,s2
    80005558:	ffffe097          	auipc	ra,0xffffe
    8000555c:	14c080e7          	jalr	332(ra) # 800036a4 <iunlockput>
  end_op(ROOTDEV);
    80005560:	4501                	li	a0,0
    80005562:	fffff097          	auipc	ra,0xfffff
    80005566:	a58080e7          	jalr	-1448(ra) # 80003fba <end_op>
  return 0;
    8000556a:	4501                	li	a0,0
    8000556c:	a85d                	j	80005622 <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    8000556e:	4501                	li	a0,0
    80005570:	fffff097          	auipc	ra,0xfffff
    80005574:	a4a080e7          	jalr	-1462(ra) # 80003fba <end_op>
    return -1;
    80005578:	557d                	li	a0,-1
    8000557a:	a065                	j	80005622 <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    8000557c:	00002517          	auipc	a0,0x2
    80005580:	21450513          	addi	a0,a0,532 # 80007790 <userret+0x700>
    80005584:	ffffb097          	auipc	ra,0xffffb
    80005588:	fc4080e7          	jalr	-60(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000558c:	04c92703          	lw	a4,76(s2)
    80005590:	02000793          	li	a5,32
    80005594:	f6e7f7e3          	bgeu	a5,a4,80005502 <sys_unlink+0xac>
    80005598:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000559c:	4741                	li	a4,16
    8000559e:	86ce                	mv	a3,s3
    800055a0:	f1840613          	addi	a2,s0,-232
    800055a4:	4581                	li	a1,0
    800055a6:	854a                	mv	a0,s2
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	14e080e7          	jalr	334(ra) # 800036f6 <readi>
    800055b0:	47c1                	li	a5,16
    800055b2:	00f51b63          	bne	a0,a5,800055c8 <sys_unlink+0x172>
    if(de.inum != 0)
    800055b6:	f1845783          	lhu	a5,-232(s0)
    800055ba:	e7a1                	bnez	a5,80005602 <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055bc:	29c1                	addiw	s3,s3,16
    800055be:	04c92783          	lw	a5,76(s2)
    800055c2:	fcf9ede3          	bltu	s3,a5,8000559c <sys_unlink+0x146>
    800055c6:	bf35                	j	80005502 <sys_unlink+0xac>
      panic("isdirempty: readi");
    800055c8:	00002517          	auipc	a0,0x2
    800055cc:	1e050513          	addi	a0,a0,480 # 800077a8 <userret+0x718>
    800055d0:	ffffb097          	auipc	ra,0xffffb
    800055d4:	f78080e7          	jalr	-136(ra) # 80000548 <panic>
    panic("unlink: writei");
    800055d8:	00002517          	auipc	a0,0x2
    800055dc:	1e850513          	addi	a0,a0,488 # 800077c0 <userret+0x730>
    800055e0:	ffffb097          	auipc	ra,0xffffb
    800055e4:	f68080e7          	jalr	-152(ra) # 80000548 <panic>
    dp->nlink--;
    800055e8:	04a4d783          	lhu	a5,74(s1)
    800055ec:	37fd                	addiw	a5,a5,-1
    800055ee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800055f2:	8526                	mv	a0,s1
    800055f4:	ffffe097          	auipc	ra,0xffffe
    800055f8:	da8080e7          	jalr	-600(ra) # 8000339c <iupdate>
    800055fc:	bf35                	j	80005538 <sys_unlink+0xe2>
    return -1;
    800055fe:	557d                	li	a0,-1
    80005600:	a00d                	j	80005622 <sys_unlink+0x1cc>
    iunlockput(ip);
    80005602:	854a                	mv	a0,s2
    80005604:	ffffe097          	auipc	ra,0xffffe
    80005608:	0a0080e7          	jalr	160(ra) # 800036a4 <iunlockput>
  iunlockput(dp);
    8000560c:	8526                	mv	a0,s1
    8000560e:	ffffe097          	auipc	ra,0xffffe
    80005612:	096080e7          	jalr	150(ra) # 800036a4 <iunlockput>
  end_op(ROOTDEV);
    80005616:	4501                	li	a0,0
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	9a2080e7          	jalr	-1630(ra) # 80003fba <end_op>
  return -1;
    80005620:	557d                	li	a0,-1
}
    80005622:	70ae                	ld	ra,232(sp)
    80005624:	740e                	ld	s0,224(sp)
    80005626:	64ee                	ld	s1,216(sp)
    80005628:	694e                	ld	s2,208(sp)
    8000562a:	69ae                	ld	s3,200(sp)
    8000562c:	616d                	addi	sp,sp,240
    8000562e:	8082                	ret

0000000080005630 <sys_open>:

uint64
sys_open(void)
{
    80005630:	7131                	addi	sp,sp,-192
    80005632:	fd06                	sd	ra,184(sp)
    80005634:	f922                	sd	s0,176(sp)
    80005636:	f526                	sd	s1,168(sp)
    80005638:	f14a                	sd	s2,160(sp)
    8000563a:	ed4e                	sd	s3,152(sp)
    8000563c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000563e:	08000613          	li	a2,128
    80005642:	f5040593          	addi	a1,s0,-176
    80005646:	4501                	li	a0,0
    80005648:	ffffd097          	auipc	ra,0xffffd
    8000564c:	2ec080e7          	jalr	748(ra) # 80002934 <argstr>
    return -1;
    80005650:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005652:	0a054963          	bltz	a0,80005704 <sys_open+0xd4>
    80005656:	f4c40593          	addi	a1,s0,-180
    8000565a:	4505                	li	a0,1
    8000565c:	ffffd097          	auipc	ra,0xffffd
    80005660:	294080e7          	jalr	660(ra) # 800028f0 <argint>
    80005664:	0a054063          	bltz	a0,80005704 <sys_open+0xd4>

  begin_op(ROOTDEV);
    80005668:	4501                	li	a0,0
    8000566a:	fffff097          	auipc	ra,0xfffff
    8000566e:	8a6080e7          	jalr	-1882(ra) # 80003f10 <begin_op>

  if(omode & O_CREATE){
    80005672:	f4c42783          	lw	a5,-180(s0)
    80005676:	2007f793          	andi	a5,a5,512
    8000567a:	c3dd                	beqz	a5,80005720 <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    8000567c:	4681                	li	a3,0
    8000567e:	4601                	li	a2,0
    80005680:	4589                	li	a1,2
    80005682:	f5040513          	addi	a0,s0,-176
    80005686:	00000097          	auipc	ra,0x0
    8000568a:	960080e7          	jalr	-1696(ra) # 80004fe6 <create>
    8000568e:	892a                	mv	s2,a0
    if(ip == 0){
    80005690:	c151                	beqz	a0,80005714 <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005692:	04491703          	lh	a4,68(s2)
    80005696:	478d                	li	a5,3
    80005698:	00f71763          	bne	a4,a5,800056a6 <sys_open+0x76>
    8000569c:	04695703          	lhu	a4,70(s2)
    800056a0:	47a5                	li	a5,9
    800056a2:	0ce7e663          	bltu	a5,a4,8000576e <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056a6:	fffff097          	auipc	ra,0xfffff
    800056aa:	dd6080e7          	jalr	-554(ra) # 8000447c <filealloc>
    800056ae:	89aa                	mv	s3,a0
    800056b0:	c57d                	beqz	a0,8000579e <sys_open+0x16e>
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	8f2080e7          	jalr	-1806(ra) # 80004fa4 <fdalloc>
    800056ba:	84aa                	mv	s1,a0
    800056bc:	0c054c63          	bltz	a0,80005794 <sys_open+0x164>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    800056c0:	04491703          	lh	a4,68(s2)
    800056c4:	478d                	li	a5,3
    800056c6:	0cf70063          	beq	a4,a5,80005786 <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800056ca:	4789                	li	a5,2
    800056cc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800056d0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800056d4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800056d8:	f4c42783          	lw	a5,-180(s0)
    800056dc:	0017c713          	xori	a4,a5,1
    800056e0:	8b05                	andi	a4,a4,1
    800056e2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800056e6:	8b8d                	andi	a5,a5,3
    800056e8:	00f037b3          	snez	a5,a5
    800056ec:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800056f0:	854a                	mv	a0,s2
    800056f2:	ffffe097          	auipc	ra,0xffffe
    800056f6:	e36080e7          	jalr	-458(ra) # 80003528 <iunlock>
  end_op(ROOTDEV);
    800056fa:	4501                	li	a0,0
    800056fc:	fffff097          	auipc	ra,0xfffff
    80005700:	8be080e7          	jalr	-1858(ra) # 80003fba <end_op>

  return fd;
}
    80005704:	8526                	mv	a0,s1
    80005706:	70ea                	ld	ra,184(sp)
    80005708:	744a                	ld	s0,176(sp)
    8000570a:	74aa                	ld	s1,168(sp)
    8000570c:	790a                	ld	s2,160(sp)
    8000570e:	69ea                	ld	s3,152(sp)
    80005710:	6129                	addi	sp,sp,192
    80005712:	8082                	ret
      end_op(ROOTDEV);
    80005714:	4501                	li	a0,0
    80005716:	fffff097          	auipc	ra,0xfffff
    8000571a:	8a4080e7          	jalr	-1884(ra) # 80003fba <end_op>
      return -1;
    8000571e:	b7dd                	j	80005704 <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    80005720:	f5040513          	addi	a0,s0,-176
    80005724:	ffffe097          	auipc	ra,0xffffe
    80005728:	4ce080e7          	jalr	1230(ra) # 80003bf2 <namei>
    8000572c:	892a                	mv	s2,a0
    8000572e:	c90d                	beqz	a0,80005760 <sys_open+0x130>
    ilock(ip);
    80005730:	ffffe097          	auipc	ra,0xffffe
    80005734:	d36080e7          	jalr	-714(ra) # 80003466 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005738:	04491703          	lh	a4,68(s2)
    8000573c:	4785                	li	a5,1
    8000573e:	f4f71ae3          	bne	a4,a5,80005692 <sys_open+0x62>
    80005742:	f4c42783          	lw	a5,-180(s0)
    80005746:	d3a5                	beqz	a5,800056a6 <sys_open+0x76>
      iunlockput(ip);
    80005748:	854a                	mv	a0,s2
    8000574a:	ffffe097          	auipc	ra,0xffffe
    8000574e:	f5a080e7          	jalr	-166(ra) # 800036a4 <iunlockput>
      end_op(ROOTDEV);
    80005752:	4501                	li	a0,0
    80005754:	fffff097          	auipc	ra,0xfffff
    80005758:	866080e7          	jalr	-1946(ra) # 80003fba <end_op>
      return -1;
    8000575c:	54fd                	li	s1,-1
    8000575e:	b75d                	j	80005704 <sys_open+0xd4>
      end_op(ROOTDEV);
    80005760:	4501                	li	a0,0
    80005762:	fffff097          	auipc	ra,0xfffff
    80005766:	858080e7          	jalr	-1960(ra) # 80003fba <end_op>
      return -1;
    8000576a:	54fd                	li	s1,-1
    8000576c:	bf61                	j	80005704 <sys_open+0xd4>
    iunlockput(ip);
    8000576e:	854a                	mv	a0,s2
    80005770:	ffffe097          	auipc	ra,0xffffe
    80005774:	f34080e7          	jalr	-204(ra) # 800036a4 <iunlockput>
    end_op(ROOTDEV);
    80005778:	4501                	li	a0,0
    8000577a:	fffff097          	auipc	ra,0xfffff
    8000577e:	840080e7          	jalr	-1984(ra) # 80003fba <end_op>
    return -1;
    80005782:	54fd                	li	s1,-1
    80005784:	b741                	j	80005704 <sys_open+0xd4>
    f->type = FD_DEVICE;
    80005786:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000578a:	04691783          	lh	a5,70(s2)
    8000578e:	02f99223          	sh	a5,36(s3)
    80005792:	b789                	j	800056d4 <sys_open+0xa4>
      fileclose(f);
    80005794:	854e                	mv	a0,s3
    80005796:	fffff097          	auipc	ra,0xfffff
    8000579a:	da2080e7          	jalr	-606(ra) # 80004538 <fileclose>
    iunlockput(ip);
    8000579e:	854a                	mv	a0,s2
    800057a0:	ffffe097          	auipc	ra,0xffffe
    800057a4:	f04080e7          	jalr	-252(ra) # 800036a4 <iunlockput>
    end_op(ROOTDEV);
    800057a8:	4501                	li	a0,0
    800057aa:	fffff097          	auipc	ra,0xfffff
    800057ae:	810080e7          	jalr	-2032(ra) # 80003fba <end_op>
    return -1;
    800057b2:	54fd                	li	s1,-1
    800057b4:	bf81                	j	80005704 <sys_open+0xd4>

00000000800057b6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800057b6:	7175                	addi	sp,sp,-144
    800057b8:	e506                	sd	ra,136(sp)
    800057ba:	e122                	sd	s0,128(sp)
    800057bc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    800057be:	4501                	li	a0,0
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	750080e7          	jalr	1872(ra) # 80003f10 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800057c8:	08000613          	li	a2,128
    800057cc:	f7040593          	addi	a1,s0,-144
    800057d0:	4501                	li	a0,0
    800057d2:	ffffd097          	auipc	ra,0xffffd
    800057d6:	162080e7          	jalr	354(ra) # 80002934 <argstr>
    800057da:	02054a63          	bltz	a0,8000580e <sys_mkdir+0x58>
    800057de:	4681                	li	a3,0
    800057e0:	4601                	li	a2,0
    800057e2:	4585                	li	a1,1
    800057e4:	f7040513          	addi	a0,s0,-144
    800057e8:	fffff097          	auipc	ra,0xfffff
    800057ec:	7fe080e7          	jalr	2046(ra) # 80004fe6 <create>
    800057f0:	cd19                	beqz	a0,8000580e <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    800057f2:	ffffe097          	auipc	ra,0xffffe
    800057f6:	eb2080e7          	jalr	-334(ra) # 800036a4 <iunlockput>
  end_op(ROOTDEV);
    800057fa:	4501                	li	a0,0
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	7be080e7          	jalr	1982(ra) # 80003fba <end_op>
  return 0;
    80005804:	4501                	li	a0,0
}
    80005806:	60aa                	ld	ra,136(sp)
    80005808:	640a                	ld	s0,128(sp)
    8000580a:	6149                	addi	sp,sp,144
    8000580c:	8082                	ret
    end_op(ROOTDEV);
    8000580e:	4501                	li	a0,0
    80005810:	ffffe097          	auipc	ra,0xffffe
    80005814:	7aa080e7          	jalr	1962(ra) # 80003fba <end_op>
    return -1;
    80005818:	557d                	li	a0,-1
    8000581a:	b7f5                	j	80005806 <sys_mkdir+0x50>

000000008000581c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000581c:	7135                	addi	sp,sp,-160
    8000581e:	ed06                	sd	ra,152(sp)
    80005820:	e922                	sd	s0,144(sp)
    80005822:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    80005824:	4501                	li	a0,0
    80005826:	ffffe097          	auipc	ra,0xffffe
    8000582a:	6ea080e7          	jalr	1770(ra) # 80003f10 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000582e:	08000613          	li	a2,128
    80005832:	f7040593          	addi	a1,s0,-144
    80005836:	4501                	li	a0,0
    80005838:	ffffd097          	auipc	ra,0xffffd
    8000583c:	0fc080e7          	jalr	252(ra) # 80002934 <argstr>
    80005840:	04054b63          	bltz	a0,80005896 <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    80005844:	f6c40593          	addi	a1,s0,-148
    80005848:	4505                	li	a0,1
    8000584a:	ffffd097          	auipc	ra,0xffffd
    8000584e:	0a6080e7          	jalr	166(ra) # 800028f0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005852:	04054263          	bltz	a0,80005896 <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    80005856:	f6840593          	addi	a1,s0,-152
    8000585a:	4509                	li	a0,2
    8000585c:	ffffd097          	auipc	ra,0xffffd
    80005860:	094080e7          	jalr	148(ra) # 800028f0 <argint>
     argint(1, &major) < 0 ||
    80005864:	02054963          	bltz	a0,80005896 <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005868:	f6841683          	lh	a3,-152(s0)
    8000586c:	f6c41603          	lh	a2,-148(s0)
    80005870:	458d                	li	a1,3
    80005872:	f7040513          	addi	a0,s0,-144
    80005876:	fffff097          	auipc	ra,0xfffff
    8000587a:	770080e7          	jalr	1904(ra) # 80004fe6 <create>
     argint(2, &minor) < 0 ||
    8000587e:	cd01                	beqz	a0,80005896 <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005880:	ffffe097          	auipc	ra,0xffffe
    80005884:	e24080e7          	jalr	-476(ra) # 800036a4 <iunlockput>
  end_op(ROOTDEV);
    80005888:	4501                	li	a0,0
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	730080e7          	jalr	1840(ra) # 80003fba <end_op>
  return 0;
    80005892:	4501                	li	a0,0
    80005894:	a039                	j	800058a2 <sys_mknod+0x86>
    end_op(ROOTDEV);
    80005896:	4501                	li	a0,0
    80005898:	ffffe097          	auipc	ra,0xffffe
    8000589c:	722080e7          	jalr	1826(ra) # 80003fba <end_op>
    return -1;
    800058a0:	557d                	li	a0,-1
}
    800058a2:	60ea                	ld	ra,152(sp)
    800058a4:	644a                	ld	s0,144(sp)
    800058a6:	610d                	addi	sp,sp,160
    800058a8:	8082                	ret

00000000800058aa <sys_chdir>:

uint64
sys_chdir(void)
{
    800058aa:	7135                	addi	sp,sp,-160
    800058ac:	ed06                	sd	ra,152(sp)
    800058ae:	e922                	sd	s0,144(sp)
    800058b0:	e526                	sd	s1,136(sp)
    800058b2:	e14a                	sd	s2,128(sp)
    800058b4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058b6:	ffffc097          	auipc	ra,0xffffc
    800058ba:	f80080e7          	jalr	-128(ra) # 80001836 <myproc>
    800058be:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    800058c0:	4501                	li	a0,0
    800058c2:	ffffe097          	auipc	ra,0xffffe
    800058c6:	64e080e7          	jalr	1614(ra) # 80003f10 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800058ca:	08000613          	li	a2,128
    800058ce:	f6040593          	addi	a1,s0,-160
    800058d2:	4501                	li	a0,0
    800058d4:	ffffd097          	auipc	ra,0xffffd
    800058d8:	060080e7          	jalr	96(ra) # 80002934 <argstr>
    800058dc:	04054c63          	bltz	a0,80005934 <sys_chdir+0x8a>
    800058e0:	f6040513          	addi	a0,s0,-160
    800058e4:	ffffe097          	auipc	ra,0xffffe
    800058e8:	30e080e7          	jalr	782(ra) # 80003bf2 <namei>
    800058ec:	84aa                	mv	s1,a0
    800058ee:	c139                	beqz	a0,80005934 <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    800058f0:	ffffe097          	auipc	ra,0xffffe
    800058f4:	b76080e7          	jalr	-1162(ra) # 80003466 <ilock>
  if(ip->type != T_DIR){
    800058f8:	04449703          	lh	a4,68(s1)
    800058fc:	4785                	li	a5,1
    800058fe:	04f71263          	bne	a4,a5,80005942 <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    80005902:	8526                	mv	a0,s1
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	c24080e7          	jalr	-988(ra) # 80003528 <iunlock>
  iput(p->cwd);
    8000590c:	15093503          	ld	a0,336(s2)
    80005910:	ffffe097          	auipc	ra,0xffffe
    80005914:	c64080e7          	jalr	-924(ra) # 80003574 <iput>
  end_op(ROOTDEV);
    80005918:	4501                	li	a0,0
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	6a0080e7          	jalr	1696(ra) # 80003fba <end_op>
  p->cwd = ip;
    80005922:	14993823          	sd	s1,336(s2)
  return 0;
    80005926:	4501                	li	a0,0
}
    80005928:	60ea                	ld	ra,152(sp)
    8000592a:	644a                	ld	s0,144(sp)
    8000592c:	64aa                	ld	s1,136(sp)
    8000592e:	690a                	ld	s2,128(sp)
    80005930:	610d                	addi	sp,sp,160
    80005932:	8082                	ret
    end_op(ROOTDEV);
    80005934:	4501                	li	a0,0
    80005936:	ffffe097          	auipc	ra,0xffffe
    8000593a:	684080e7          	jalr	1668(ra) # 80003fba <end_op>
    return -1;
    8000593e:	557d                	li	a0,-1
    80005940:	b7e5                	j	80005928 <sys_chdir+0x7e>
    iunlockput(ip);
    80005942:	8526                	mv	a0,s1
    80005944:	ffffe097          	auipc	ra,0xffffe
    80005948:	d60080e7          	jalr	-672(ra) # 800036a4 <iunlockput>
    end_op(ROOTDEV);
    8000594c:	4501                	li	a0,0
    8000594e:	ffffe097          	auipc	ra,0xffffe
    80005952:	66c080e7          	jalr	1644(ra) # 80003fba <end_op>
    return -1;
    80005956:	557d                	li	a0,-1
    80005958:	bfc1                	j	80005928 <sys_chdir+0x7e>

000000008000595a <sys_exec>:

uint64
sys_exec(void)
{
    8000595a:	7145                	addi	sp,sp,-464
    8000595c:	e786                	sd	ra,456(sp)
    8000595e:	e3a2                	sd	s0,448(sp)
    80005960:	ff26                	sd	s1,440(sp)
    80005962:	fb4a                	sd	s2,432(sp)
    80005964:	f74e                	sd	s3,424(sp)
    80005966:	f352                	sd	s4,416(sp)
    80005968:	ef56                	sd	s5,408(sp)
    8000596a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000596c:	08000613          	li	a2,128
    80005970:	f4040593          	addi	a1,s0,-192
    80005974:	4501                	li	a0,0
    80005976:	ffffd097          	auipc	ra,0xffffd
    8000597a:	fbe080e7          	jalr	-66(ra) # 80002934 <argstr>
    8000597e:	0c054863          	bltz	a0,80005a4e <sys_exec+0xf4>
    80005982:	e3840593          	addi	a1,s0,-456
    80005986:	4505                	li	a0,1
    80005988:	ffffd097          	auipc	ra,0xffffd
    8000598c:	f8a080e7          	jalr	-118(ra) # 80002912 <argaddr>
    80005990:	0c054963          	bltz	a0,80005a62 <sys_exec+0x108>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005994:	10000613          	li	a2,256
    80005998:	4581                	li	a1,0
    8000599a:	e4040513          	addi	a0,s0,-448
    8000599e:	ffffb097          	auipc	ra,0xffffb
    800059a2:	1fc080e7          	jalr	508(ra) # 80000b9a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800059a6:	e4040993          	addi	s3,s0,-448
  memset(argv, 0, sizeof(argv));
    800059aa:	894e                	mv	s2,s3
    800059ac:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    800059ae:	02000a13          	li	s4,32
    800059b2:	00048a9b          	sext.w	s5,s1
      return -1;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800059b6:	00349793          	slli	a5,s1,0x3
    800059ba:	e3040593          	addi	a1,s0,-464
    800059be:	e3843503          	ld	a0,-456(s0)
    800059c2:	953e                	add	a0,a0,a5
    800059c4:	ffffd097          	auipc	ra,0xffffd
    800059c8:	e92080e7          	jalr	-366(ra) # 80002856 <fetchaddr>
    800059cc:	08054d63          	bltz	a0,80005a66 <sys_exec+0x10c>
      return -1;
    }
    if(uarg == 0){
    800059d0:	e3043783          	ld	a5,-464(s0)
    800059d4:	cb85                	beqz	a5,80005a04 <sys_exec+0xaa>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800059d6:	ffffb097          	auipc	ra,0xffffb
    800059da:	f92080e7          	jalr	-110(ra) # 80000968 <kalloc>
    800059de:	85aa                	mv	a1,a0
    800059e0:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    800059e4:	cd29                	beqz	a0,80005a3e <sys_exec+0xe4>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    800059e6:	6605                	lui	a2,0x1
    800059e8:	e3043503          	ld	a0,-464(s0)
    800059ec:	ffffd097          	auipc	ra,0xffffd
    800059f0:	ebc080e7          	jalr	-324(ra) # 800028a8 <fetchstr>
    800059f4:	06054b63          	bltz	a0,80005a6a <sys_exec+0x110>
    if(i >= NELEM(argv)){
    800059f8:	0485                	addi	s1,s1,1
    800059fa:	0921                	addi	s2,s2,8
    800059fc:	fb449be3          	bne	s1,s4,800059b2 <sys_exec+0x58>
      return -1;
    80005a00:	557d                	li	a0,-1
    80005a02:	a0b9                	j	80005a50 <sys_exec+0xf6>
      argv[i] = 0;
    80005a04:	0a8e                	slli	s5,s5,0x3
    80005a06:	fc040793          	addi	a5,s0,-64
    80005a0a:	9abe                	add	s5,s5,a5
    80005a0c:	e80ab023          	sd	zero,-384(s5)
      return -1;
    }
  }

  int ret = exec(path, argv);
    80005a10:	e4040593          	addi	a1,s0,-448
    80005a14:	f4040513          	addi	a0,s0,-192
    80005a18:	fffff097          	auipc	ra,0xfffff
    80005a1c:	198080e7          	jalr	408(ra) # 80004bb0 <exec>
    80005a20:	84aa                	mv	s1,a0

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a22:	10098913          	addi	s2,s3,256
    80005a26:	0009b503          	ld	a0,0(s3)
    80005a2a:	c901                	beqz	a0,80005a3a <sys_exec+0xe0>
    kfree(argv[i]);
    80005a2c:	ffffb097          	auipc	ra,0xffffb
    80005a30:	e28080e7          	jalr	-472(ra) # 80000854 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a34:	09a1                	addi	s3,s3,8
    80005a36:	ff2998e3          	bne	s3,s2,80005a26 <sys_exec+0xcc>

  return ret;
    80005a3a:	8526                	mv	a0,s1
    80005a3c:	a811                	j	80005a50 <sys_exec+0xf6>
      panic("sys_exec kalloc");
    80005a3e:	00002517          	auipc	a0,0x2
    80005a42:	d9250513          	addi	a0,a0,-622 # 800077d0 <userret+0x740>
    80005a46:	ffffb097          	auipc	ra,0xffffb
    80005a4a:	b02080e7          	jalr	-1278(ra) # 80000548 <panic>
    return -1;
    80005a4e:	557d                	li	a0,-1
}
    80005a50:	60be                	ld	ra,456(sp)
    80005a52:	641e                	ld	s0,448(sp)
    80005a54:	74fa                	ld	s1,440(sp)
    80005a56:	795a                	ld	s2,432(sp)
    80005a58:	79ba                	ld	s3,424(sp)
    80005a5a:	7a1a                	ld	s4,416(sp)
    80005a5c:	6afa                	ld	s5,408(sp)
    80005a5e:	6179                	addi	sp,sp,464
    80005a60:	8082                	ret
    return -1;
    80005a62:	557d                	li	a0,-1
    80005a64:	b7f5                	j	80005a50 <sys_exec+0xf6>
      return -1;
    80005a66:	557d                	li	a0,-1
    80005a68:	b7e5                	j	80005a50 <sys_exec+0xf6>
      return -1;
    80005a6a:	557d                	li	a0,-1
    80005a6c:	b7d5                	j	80005a50 <sys_exec+0xf6>

0000000080005a6e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005a6e:	7139                	addi	sp,sp,-64
    80005a70:	fc06                	sd	ra,56(sp)
    80005a72:	f822                	sd	s0,48(sp)
    80005a74:	f426                	sd	s1,40(sp)
    80005a76:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005a78:	ffffc097          	auipc	ra,0xffffc
    80005a7c:	dbe080e7          	jalr	-578(ra) # 80001836 <myproc>
    80005a80:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005a82:	fd840593          	addi	a1,s0,-40
    80005a86:	4501                	li	a0,0
    80005a88:	ffffd097          	auipc	ra,0xffffd
    80005a8c:	e8a080e7          	jalr	-374(ra) # 80002912 <argaddr>
    return -1;
    80005a90:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005a92:	0e054063          	bltz	a0,80005b72 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a96:	fc840593          	addi	a1,s0,-56
    80005a9a:	fd040513          	addi	a0,s0,-48
    80005a9e:	fffff097          	auipc	ra,0xfffff
    80005aa2:	dce080e7          	jalr	-562(ra) # 8000486c <pipealloc>
    return -1;
    80005aa6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005aa8:	0c054563          	bltz	a0,80005b72 <sys_pipe+0x104>
  fd0 = -1;
    80005aac:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ab0:	fd043503          	ld	a0,-48(s0)
    80005ab4:	fffff097          	auipc	ra,0xfffff
    80005ab8:	4f0080e7          	jalr	1264(ra) # 80004fa4 <fdalloc>
    80005abc:	fca42223          	sw	a0,-60(s0)
    80005ac0:	08054c63          	bltz	a0,80005b58 <sys_pipe+0xea>
    80005ac4:	fc843503          	ld	a0,-56(s0)
    80005ac8:	fffff097          	auipc	ra,0xfffff
    80005acc:	4dc080e7          	jalr	1244(ra) # 80004fa4 <fdalloc>
    80005ad0:	fca42023          	sw	a0,-64(s0)
    80005ad4:	06054863          	bltz	a0,80005b44 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ad8:	4691                	li	a3,4
    80005ada:	fc440613          	addi	a2,s0,-60
    80005ade:	fd843583          	ld	a1,-40(s0)
    80005ae2:	68a8                	ld	a0,80(s1)
    80005ae4:	ffffc097          	auipc	ra,0xffffc
    80005ae8:	a76080e7          	jalr	-1418(ra) # 8000155a <copyout>
    80005aec:	02054063          	bltz	a0,80005b0c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005af0:	4691                	li	a3,4
    80005af2:	fc040613          	addi	a2,s0,-64
    80005af6:	fd843583          	ld	a1,-40(s0)
    80005afa:	0591                	addi	a1,a1,4
    80005afc:	68a8                	ld	a0,80(s1)
    80005afe:	ffffc097          	auipc	ra,0xffffc
    80005b02:	a5c080e7          	jalr	-1444(ra) # 8000155a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b06:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b08:	06055563          	bgez	a0,80005b72 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b0c:	fc442783          	lw	a5,-60(s0)
    80005b10:	07e9                	addi	a5,a5,26
    80005b12:	078e                	slli	a5,a5,0x3
    80005b14:	97a6                	add	a5,a5,s1
    80005b16:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b1a:	fc042503          	lw	a0,-64(s0)
    80005b1e:	0569                	addi	a0,a0,26
    80005b20:	050e                	slli	a0,a0,0x3
    80005b22:	9526                	add	a0,a0,s1
    80005b24:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b28:	fd043503          	ld	a0,-48(s0)
    80005b2c:	fffff097          	auipc	ra,0xfffff
    80005b30:	a0c080e7          	jalr	-1524(ra) # 80004538 <fileclose>
    fileclose(wf);
    80005b34:	fc843503          	ld	a0,-56(s0)
    80005b38:	fffff097          	auipc	ra,0xfffff
    80005b3c:	a00080e7          	jalr	-1536(ra) # 80004538 <fileclose>
    return -1;
    80005b40:	57fd                	li	a5,-1
    80005b42:	a805                	j	80005b72 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005b44:	fc442783          	lw	a5,-60(s0)
    80005b48:	0007c863          	bltz	a5,80005b58 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005b4c:	01a78513          	addi	a0,a5,26
    80005b50:	050e                	slli	a0,a0,0x3
    80005b52:	9526                	add	a0,a0,s1
    80005b54:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b58:	fd043503          	ld	a0,-48(s0)
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	9dc080e7          	jalr	-1572(ra) # 80004538 <fileclose>
    fileclose(wf);
    80005b64:	fc843503          	ld	a0,-56(s0)
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	9d0080e7          	jalr	-1584(ra) # 80004538 <fileclose>
    return -1;
    80005b70:	57fd                	li	a5,-1
}
    80005b72:	853e                	mv	a0,a5
    80005b74:	70e2                	ld	ra,56(sp)
    80005b76:	7442                	ld	s0,48(sp)
    80005b78:	74a2                	ld	s1,40(sp)
    80005b7a:	6121                	addi	sp,sp,64
    80005b7c:	8082                	ret

0000000080005b7e <sys_crash>:

// system call to test crashes
uint64
sys_crash(void)
{
    80005b7e:	7171                	addi	sp,sp,-176
    80005b80:	f506                	sd	ra,168(sp)
    80005b82:	f122                	sd	s0,160(sp)
    80005b84:	ed26                	sd	s1,152(sp)
    80005b86:	1900                	addi	s0,sp,176
  char path[MAXPATH];
  struct inode *ip;
  int crash;
  
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b88:	08000613          	li	a2,128
    80005b8c:	f6040593          	addi	a1,s0,-160
    80005b90:	4501                	li	a0,0
    80005b92:	ffffd097          	auipc	ra,0xffffd
    80005b96:	da2080e7          	jalr	-606(ra) # 80002934 <argstr>
    return -1;
    80005b9a:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005b9c:	04054363          	bltz	a0,80005be2 <sys_crash+0x64>
    80005ba0:	f5c40593          	addi	a1,s0,-164
    80005ba4:	4505                	li	a0,1
    80005ba6:	ffffd097          	auipc	ra,0xffffd
    80005baa:	d4a080e7          	jalr	-694(ra) # 800028f0 <argint>
    return -1;
    80005bae:	57fd                	li	a5,-1
  if(argstr(0, path, MAXPATH) < 0 || argint(1, &crash) < 0)
    80005bb0:	02054963          	bltz	a0,80005be2 <sys_crash+0x64>
  ip = create(path, T_FILE, 0, 0);
    80005bb4:	4681                	li	a3,0
    80005bb6:	4601                	li	a2,0
    80005bb8:	4589                	li	a1,2
    80005bba:	f6040513          	addi	a0,s0,-160
    80005bbe:	fffff097          	auipc	ra,0xfffff
    80005bc2:	428080e7          	jalr	1064(ra) # 80004fe6 <create>
    80005bc6:	84aa                	mv	s1,a0
  if(ip == 0){
    80005bc8:	c11d                	beqz	a0,80005bee <sys_crash+0x70>
    return -1;
  }
  iunlockput(ip);
    80005bca:	ffffe097          	auipc	ra,0xffffe
    80005bce:	ada080e7          	jalr	-1318(ra) # 800036a4 <iunlockput>
  crash_op(ip->dev, crash);
    80005bd2:	f5c42583          	lw	a1,-164(s0)
    80005bd6:	4088                	lw	a0,0(s1)
    80005bd8:	ffffe097          	auipc	ra,0xffffe
    80005bdc:	634080e7          	jalr	1588(ra) # 8000420c <crash_op>
  return 0;
    80005be0:	4781                	li	a5,0
}
    80005be2:	853e                	mv	a0,a5
    80005be4:	70aa                	ld	ra,168(sp)
    80005be6:	740a                	ld	s0,160(sp)
    80005be8:	64ea                	ld	s1,152(sp)
    80005bea:	614d                	addi	sp,sp,176
    80005bec:	8082                	ret
    return -1;
    80005bee:	57fd                	li	a5,-1
    80005bf0:	bfcd                	j	80005be2 <sys_crash+0x64>
	...

0000000080005c00 <kernelvec>:
    80005c00:	7111                	addi	sp,sp,-256
    80005c02:	e006                	sd	ra,0(sp)
    80005c04:	e40a                	sd	sp,8(sp)
    80005c06:	e80e                	sd	gp,16(sp)
    80005c08:	ec12                	sd	tp,24(sp)
    80005c0a:	f016                	sd	t0,32(sp)
    80005c0c:	f41a                	sd	t1,40(sp)
    80005c0e:	f81e                	sd	t2,48(sp)
    80005c10:	fc22                	sd	s0,56(sp)
    80005c12:	e0a6                	sd	s1,64(sp)
    80005c14:	e4aa                	sd	a0,72(sp)
    80005c16:	e8ae                	sd	a1,80(sp)
    80005c18:	ecb2                	sd	a2,88(sp)
    80005c1a:	f0b6                	sd	a3,96(sp)
    80005c1c:	f4ba                	sd	a4,104(sp)
    80005c1e:	f8be                	sd	a5,112(sp)
    80005c20:	fcc2                	sd	a6,120(sp)
    80005c22:	e146                	sd	a7,128(sp)
    80005c24:	e54a                	sd	s2,136(sp)
    80005c26:	e94e                	sd	s3,144(sp)
    80005c28:	ed52                	sd	s4,152(sp)
    80005c2a:	f156                	sd	s5,160(sp)
    80005c2c:	f55a                	sd	s6,168(sp)
    80005c2e:	f95e                	sd	s7,176(sp)
    80005c30:	fd62                	sd	s8,184(sp)
    80005c32:	e1e6                	sd	s9,192(sp)
    80005c34:	e5ea                	sd	s10,200(sp)
    80005c36:	e9ee                	sd	s11,208(sp)
    80005c38:	edf2                	sd	t3,216(sp)
    80005c3a:	f1f6                	sd	t4,224(sp)
    80005c3c:	f5fa                	sd	t5,232(sp)
    80005c3e:	f9fe                	sd	t6,240(sp)
    80005c40:	ae3fc0ef          	jal	ra,80002722 <kerneltrap>
    80005c44:	6082                	ld	ra,0(sp)
    80005c46:	6122                	ld	sp,8(sp)
    80005c48:	61c2                	ld	gp,16(sp)
    80005c4a:	7282                	ld	t0,32(sp)
    80005c4c:	7322                	ld	t1,40(sp)
    80005c4e:	73c2                	ld	t2,48(sp)
    80005c50:	7462                	ld	s0,56(sp)
    80005c52:	6486                	ld	s1,64(sp)
    80005c54:	6526                	ld	a0,72(sp)
    80005c56:	65c6                	ld	a1,80(sp)
    80005c58:	6666                	ld	a2,88(sp)
    80005c5a:	7686                	ld	a3,96(sp)
    80005c5c:	7726                	ld	a4,104(sp)
    80005c5e:	77c6                	ld	a5,112(sp)
    80005c60:	7866                	ld	a6,120(sp)
    80005c62:	688a                	ld	a7,128(sp)
    80005c64:	692a                	ld	s2,136(sp)
    80005c66:	69ca                	ld	s3,144(sp)
    80005c68:	6a6a                	ld	s4,152(sp)
    80005c6a:	7a8a                	ld	s5,160(sp)
    80005c6c:	7b2a                	ld	s6,168(sp)
    80005c6e:	7bca                	ld	s7,176(sp)
    80005c70:	7c6a                	ld	s8,184(sp)
    80005c72:	6c8e                	ld	s9,192(sp)
    80005c74:	6d2e                	ld	s10,200(sp)
    80005c76:	6dce                	ld	s11,208(sp)
    80005c78:	6e6e                	ld	t3,216(sp)
    80005c7a:	7e8e                	ld	t4,224(sp)
    80005c7c:	7f2e                	ld	t5,232(sp)
    80005c7e:	7fce                	ld	t6,240(sp)
    80005c80:	6111                	addi	sp,sp,256
    80005c82:	10200073          	sret
    80005c86:	00000013          	nop
    80005c8a:	00000013          	nop
    80005c8e:	0001                	nop

0000000080005c90 <timervec>:
    80005c90:	34051573          	csrrw	a0,mscratch,a0
    80005c94:	e10c                	sd	a1,0(a0)
    80005c96:	e510                	sd	a2,8(a0)
    80005c98:	e914                	sd	a3,16(a0)
    80005c9a:	710c                	ld	a1,32(a0)
    80005c9c:	7510                	ld	a2,40(a0)
    80005c9e:	6194                	ld	a3,0(a1)
    80005ca0:	96b2                	add	a3,a3,a2
    80005ca2:	e194                	sd	a3,0(a1)
    80005ca4:	4589                	li	a1,2
    80005ca6:	14459073          	csrw	sip,a1
    80005caa:	6914                	ld	a3,16(a0)
    80005cac:	6510                	ld	a2,8(a0)
    80005cae:	610c                	ld	a1,0(a0)
    80005cb0:	34051573          	csrrw	a0,mscratch,a0
    80005cb4:	30200073          	mret
	...

0000000080005cba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005cba:	1141                	addi	sp,sp,-16
    80005cbc:	e422                	sd	s0,8(sp)
    80005cbe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005cc0:	0c0007b7          	lui	a5,0xc000
    80005cc4:	4705                	li	a4,1
    80005cc6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005cc8:	c3d8                	sw	a4,4(a5)
}
    80005cca:	6422                	ld	s0,8(sp)
    80005ccc:	0141                	addi	sp,sp,16
    80005cce:	8082                	ret

0000000080005cd0 <plicinithart>:

void
plicinithart(void)
{
    80005cd0:	1141                	addi	sp,sp,-16
    80005cd2:	e406                	sd	ra,8(sp)
    80005cd4:	e022                	sd	s0,0(sp)
    80005cd6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cd8:	ffffc097          	auipc	ra,0xffffc
    80005cdc:	b32080e7          	jalr	-1230(ra) # 8000180a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005ce0:	0085171b          	slliw	a4,a0,0x8
    80005ce4:	0c0027b7          	lui	a5,0xc002
    80005ce8:	97ba                	add	a5,a5,a4
    80005cea:	40200713          	li	a4,1026
    80005cee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005cf2:	00d5151b          	slliw	a0,a0,0xd
    80005cf6:	0c2017b7          	lui	a5,0xc201
    80005cfa:	953e                	add	a0,a0,a5
    80005cfc:	00052023          	sw	zero,0(a0)
}
    80005d00:	60a2                	ld	ra,8(sp)
    80005d02:	6402                	ld	s0,0(sp)
    80005d04:	0141                	addi	sp,sp,16
    80005d06:	8082                	ret

0000000080005d08 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005d08:	1141                	addi	sp,sp,-16
    80005d0a:	e422                	sd	s0,8(sp)
    80005d0c:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    80005d0e:	0c0017b7          	lui	a5,0xc001
    80005d12:	6388                	ld	a0,0(a5)
    80005d14:	6422                	ld	s0,8(sp)
    80005d16:	0141                	addi	sp,sp,16
    80005d18:	8082                	ret

0000000080005d1a <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d1a:	1141                	addi	sp,sp,-16
    80005d1c:	e406                	sd	ra,8(sp)
    80005d1e:	e022                	sd	s0,0(sp)
    80005d20:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d22:	ffffc097          	auipc	ra,0xffffc
    80005d26:	ae8080e7          	jalr	-1304(ra) # 8000180a <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d2a:	00d5179b          	slliw	a5,a0,0xd
    80005d2e:	0c201537          	lui	a0,0xc201
    80005d32:	953e                	add	a0,a0,a5
  return irq;
}
    80005d34:	4148                	lw	a0,4(a0)
    80005d36:	60a2                	ld	ra,8(sp)
    80005d38:	6402                	ld	s0,0(sp)
    80005d3a:	0141                	addi	sp,sp,16
    80005d3c:	8082                	ret

0000000080005d3e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d3e:	1101                	addi	sp,sp,-32
    80005d40:	ec06                	sd	ra,24(sp)
    80005d42:	e822                	sd	s0,16(sp)
    80005d44:	e426                	sd	s1,8(sp)
    80005d46:	1000                	addi	s0,sp,32
    80005d48:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d4a:	ffffc097          	auipc	ra,0xffffc
    80005d4e:	ac0080e7          	jalr	-1344(ra) # 8000180a <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d52:	00d5151b          	slliw	a0,a0,0xd
    80005d56:	0c2017b7          	lui	a5,0xc201
    80005d5a:	97aa                	add	a5,a5,a0
    80005d5c:	c3c4                	sw	s1,4(a5)
}
    80005d5e:	60e2                	ld	ra,24(sp)
    80005d60:	6442                	ld	s0,16(sp)
    80005d62:	64a2                	ld	s1,8(sp)
    80005d64:	6105                	addi	sp,sp,32
    80005d66:	8082                	ret

0000000080005d68 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005d68:	1141                	addi	sp,sp,-16
    80005d6a:	e406                	sd	ra,8(sp)
    80005d6c:	e022                	sd	s0,0(sp)
    80005d6e:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d70:	479d                	li	a5,7
    80005d72:	06b7c963          	blt	a5,a1,80005de4 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005d76:	00151793          	slli	a5,a0,0x1
    80005d7a:	97aa                	add	a5,a5,a0
    80005d7c:	00c79713          	slli	a4,a5,0xc
    80005d80:	0001d797          	auipc	a5,0x1d
    80005d84:	28078793          	addi	a5,a5,640 # 80023000 <disk>
    80005d88:	97ba                	add	a5,a5,a4
    80005d8a:	97ae                	add	a5,a5,a1
    80005d8c:	6709                	lui	a4,0x2
    80005d8e:	97ba                	add	a5,a5,a4
    80005d90:	0187c783          	lbu	a5,24(a5)
    80005d94:	e3a5                	bnez	a5,80005df4 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80005d96:	0001d817          	auipc	a6,0x1d
    80005d9a:	26a80813          	addi	a6,a6,618 # 80023000 <disk>
    80005d9e:	00151693          	slli	a3,a0,0x1
    80005da2:	00a68733          	add	a4,a3,a0
    80005da6:	0732                	slli	a4,a4,0xc
    80005da8:	00e807b3          	add	a5,a6,a4
    80005dac:	6709                	lui	a4,0x2
    80005dae:	00f70633          	add	a2,a4,a5
    80005db2:	6210                	ld	a2,0(a2)
    80005db4:	00459893          	slli	a7,a1,0x4
    80005db8:	9646                	add	a2,a2,a7
    80005dba:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    80005dbe:	97ae                	add	a5,a5,a1
    80005dc0:	97ba                	add	a5,a5,a4
    80005dc2:	4605                	li	a2,1
    80005dc4:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80005dc8:	96aa                	add	a3,a3,a0
    80005dca:	06b2                	slli	a3,a3,0xc
    80005dcc:	0761                	addi	a4,a4,24
    80005dce:	96ba                	add	a3,a3,a4
    80005dd0:	00d80533          	add	a0,a6,a3
    80005dd4:	ffffc097          	auipc	ra,0xffffc
    80005dd8:	3f8080e7          	jalr	1016(ra) # 800021cc <wakeup>
}
    80005ddc:	60a2                	ld	ra,8(sp)
    80005dde:	6402                	ld	s0,0(sp)
    80005de0:	0141                	addi	sp,sp,16
    80005de2:	8082                	ret
    panic("virtio_disk_intr 1");
    80005de4:	00002517          	auipc	a0,0x2
    80005de8:	9fc50513          	addi	a0,a0,-1540 # 800077e0 <userret+0x750>
    80005dec:	ffffa097          	auipc	ra,0xffffa
    80005df0:	75c080e7          	jalr	1884(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80005df4:	00002517          	auipc	a0,0x2
    80005df8:	a0450513          	addi	a0,a0,-1532 # 800077f8 <userret+0x768>
    80005dfc:	ffffa097          	auipc	ra,0xffffa
    80005e00:	74c080e7          	jalr	1868(ra) # 80000548 <panic>

0000000080005e04 <virtio_disk_init>:
  __sync_synchronize();
    80005e04:	0ff0000f          	fence
  if(disk[n].init)
    80005e08:	00151793          	slli	a5,a0,0x1
    80005e0c:	97aa                	add	a5,a5,a0
    80005e0e:	07b2                	slli	a5,a5,0xc
    80005e10:	0001d717          	auipc	a4,0x1d
    80005e14:	1f070713          	addi	a4,a4,496 # 80023000 <disk>
    80005e18:	973e                	add	a4,a4,a5
    80005e1a:	6789                	lui	a5,0x2
    80005e1c:	97ba                	add	a5,a5,a4
    80005e1e:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80005e22:	c391                	beqz	a5,80005e26 <virtio_disk_init+0x22>
    80005e24:	8082                	ret
{
    80005e26:	7139                	addi	sp,sp,-64
    80005e28:	fc06                	sd	ra,56(sp)
    80005e2a:	f822                	sd	s0,48(sp)
    80005e2c:	f426                	sd	s1,40(sp)
    80005e2e:	f04a                	sd	s2,32(sp)
    80005e30:	ec4e                	sd	s3,24(sp)
    80005e32:	e852                	sd	s4,16(sp)
    80005e34:	e456                	sd	s5,8(sp)
    80005e36:	0080                	addi	s0,sp,64
    80005e38:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    80005e3a:	85aa                	mv	a1,a0
    80005e3c:	00002517          	auipc	a0,0x2
    80005e40:	9d450513          	addi	a0,a0,-1580 # 80007810 <userret+0x780>
    80005e44:	ffffa097          	auipc	ra,0xffffa
    80005e48:	74e080e7          	jalr	1870(ra) # 80000592 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    80005e4c:	00149993          	slli	s3,s1,0x1
    80005e50:	99a6                	add	s3,s3,s1
    80005e52:	09b2                	slli	s3,s3,0xc
    80005e54:	6789                	lui	a5,0x2
    80005e56:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    80005e5a:	97ce                	add	a5,a5,s3
    80005e5c:	00002597          	auipc	a1,0x2
    80005e60:	9cc58593          	addi	a1,a1,-1588 # 80007828 <userret+0x798>
    80005e64:	0001d517          	auipc	a0,0x1d
    80005e68:	19c50513          	addi	a0,a0,412 # 80023000 <disk>
    80005e6c:	953e                	add	a0,a0,a5
    80005e6e:	ffffb097          	auipc	ra,0xffffb
    80005e72:	b5a080e7          	jalr	-1190(ra) # 800009c8 <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e76:	0014891b          	addiw	s2,s1,1
    80005e7a:	00c9191b          	slliw	s2,s2,0xc
    80005e7e:	100007b7          	lui	a5,0x10000
    80005e82:	97ca                	add	a5,a5,s2
    80005e84:	4398                	lw	a4,0(a5)
    80005e86:	2701                	sext.w	a4,a4
    80005e88:	747277b7          	lui	a5,0x74727
    80005e8c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e90:	12f71663          	bne	a4,a5,80005fbc <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005e94:	100007b7          	lui	a5,0x10000
    80005e98:	0791                	addi	a5,a5,4
    80005e9a:	97ca                	add	a5,a5,s2
    80005e9c:	439c                	lw	a5,0(a5)
    80005e9e:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ea0:	4705                	li	a4,1
    80005ea2:	10e79d63          	bne	a5,a4,80005fbc <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ea6:	100007b7          	lui	a5,0x10000
    80005eaa:	07a1                	addi	a5,a5,8
    80005eac:	97ca                	add	a5,a5,s2
    80005eae:	439c                	lw	a5,0(a5)
    80005eb0:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80005eb2:	4709                	li	a4,2
    80005eb4:	10e79463          	bne	a5,a4,80005fbc <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005eb8:	100007b7          	lui	a5,0x10000
    80005ebc:	07b1                	addi	a5,a5,12
    80005ebe:	97ca                	add	a5,a5,s2
    80005ec0:	4398                	lw	a4,0(a5)
    80005ec2:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ec4:	554d47b7          	lui	a5,0x554d4
    80005ec8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005ecc:	0ef71863          	bne	a4,a5,80005fbc <virtio_disk_init+0x1b8>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ed0:	100007b7          	lui	a5,0x10000
    80005ed4:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80005ed8:	96ca                	add	a3,a3,s2
    80005eda:	4705                	li	a4,1
    80005edc:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005ede:	470d                	li	a4,3
    80005ee0:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80005ee2:	01078713          	addi	a4,a5,16
    80005ee6:	974a                	add	a4,a4,s2
    80005ee8:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005eea:	02078613          	addi	a2,a5,32
    80005eee:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005ef0:	c7ffe737          	lui	a4,0xc7ffe
    80005ef4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd571b>
    80005ef8:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005efa:	2701                	sext.w	a4,a4
    80005efc:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005efe:	472d                	li	a4,11
    80005f00:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80005f02:	473d                	li	a4,15
    80005f04:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005f06:	02878713          	addi	a4,a5,40
    80005f0a:	974a                	add	a4,a4,s2
    80005f0c:	6685                	lui	a3,0x1
    80005f0e:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f10:	03078713          	addi	a4,a5,48
    80005f14:	974a                	add	a4,a4,s2
    80005f16:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005f1a:	03478793          	addi	a5,a5,52
    80005f1e:	97ca                	add	a5,a5,s2
    80005f20:	439c                	lw	a5,0(a5)
    80005f22:	2781                	sext.w	a5,a5
  if(max == 0)
    80005f24:	c7c5                	beqz	a5,80005fcc <virtio_disk_init+0x1c8>
  if(max < NUM)
    80005f26:	471d                	li	a4,7
    80005f28:	0af77a63          	bgeu	a4,a5,80005fdc <virtio_disk_init+0x1d8>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f2c:	10000ab7          	lui	s5,0x10000
    80005f30:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    80005f34:	97ca                	add	a5,a5,s2
    80005f36:	4721                	li	a4,8
    80005f38:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    80005f3a:	0001da17          	auipc	s4,0x1d
    80005f3e:	0c6a0a13          	addi	s4,s4,198 # 80023000 <disk>
    80005f42:	99d2                	add	s3,s3,s4
    80005f44:	6609                	lui	a2,0x2
    80005f46:	4581                	li	a1,0
    80005f48:	854e                	mv	a0,s3
    80005f4a:	ffffb097          	auipc	ra,0xffffb
    80005f4e:	c50080e7          	jalr	-944(ra) # 80000b9a <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    80005f52:	040a8a93          	addi	s5,s5,64
    80005f56:	9956                	add	s2,s2,s5
    80005f58:	00c9d793          	srli	a5,s3,0xc
    80005f5c:	2781                	sext.w	a5,a5
    80005f5e:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    80005f62:	00149693          	slli	a3,s1,0x1
    80005f66:	009687b3          	add	a5,a3,s1
    80005f6a:	07b2                	slli	a5,a5,0xc
    80005f6c:	97d2                	add	a5,a5,s4
    80005f6e:	6609                	lui	a2,0x2
    80005f70:	97b2                	add	a5,a5,a2
    80005f72:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    80005f76:	08098713          	addi	a4,s3,128
    80005f7a:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    80005f7c:	6705                	lui	a4,0x1
    80005f7e:	99ba                	add	s3,s3,a4
    80005f80:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    80005f84:	4705                	li	a4,1
    80005f86:	00e78c23          	sb	a4,24(a5)
    80005f8a:	00e78ca3          	sb	a4,25(a5)
    80005f8e:	00e78d23          	sb	a4,26(a5)
    80005f92:	00e78da3          	sb	a4,27(a5)
    80005f96:	00e78e23          	sb	a4,28(a5)
    80005f9a:	00e78ea3          	sb	a4,29(a5)
    80005f9e:	00e78f23          	sb	a4,30(a5)
    80005fa2:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80005fa6:	0ae7a423          	sw	a4,168(a5)
}
    80005faa:	70e2                	ld	ra,56(sp)
    80005fac:	7442                	ld	s0,48(sp)
    80005fae:	74a2                	ld	s1,40(sp)
    80005fb0:	7902                	ld	s2,32(sp)
    80005fb2:	69e2                	ld	s3,24(sp)
    80005fb4:	6a42                	ld	s4,16(sp)
    80005fb6:	6aa2                	ld	s5,8(sp)
    80005fb8:	6121                	addi	sp,sp,64
    80005fba:	8082                	ret
    panic("could not find virtio disk");
    80005fbc:	00002517          	auipc	a0,0x2
    80005fc0:	87c50513          	addi	a0,a0,-1924 # 80007838 <userret+0x7a8>
    80005fc4:	ffffa097          	auipc	ra,0xffffa
    80005fc8:	584080e7          	jalr	1412(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    80005fcc:	00002517          	auipc	a0,0x2
    80005fd0:	88c50513          	addi	a0,a0,-1908 # 80007858 <userret+0x7c8>
    80005fd4:	ffffa097          	auipc	ra,0xffffa
    80005fd8:	574080e7          	jalr	1396(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    80005fdc:	00002517          	auipc	a0,0x2
    80005fe0:	89c50513          	addi	a0,a0,-1892 # 80007878 <userret+0x7e8>
    80005fe4:	ffffa097          	auipc	ra,0xffffa
    80005fe8:	564080e7          	jalr	1380(ra) # 80000548 <panic>

0000000080005fec <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    80005fec:	7135                	addi	sp,sp,-160
    80005fee:	ed06                	sd	ra,152(sp)
    80005ff0:	e922                	sd	s0,144(sp)
    80005ff2:	e526                	sd	s1,136(sp)
    80005ff4:	e14a                	sd	s2,128(sp)
    80005ff6:	fcce                	sd	s3,120(sp)
    80005ff8:	f8d2                	sd	s4,112(sp)
    80005ffa:	f4d6                	sd	s5,104(sp)
    80005ffc:	f0da                	sd	s6,96(sp)
    80005ffe:	ecde                	sd	s7,88(sp)
    80006000:	e8e2                	sd	s8,80(sp)
    80006002:	e4e6                	sd	s9,72(sp)
    80006004:	e0ea                	sd	s10,64(sp)
    80006006:	fc6e                	sd	s11,56(sp)
    80006008:	1100                	addi	s0,sp,160
    8000600a:	8aaa                	mv	s5,a0
    8000600c:	8c2e                	mv	s8,a1
    8000600e:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    80006010:	45dc                	lw	a5,12(a1)
    80006012:	0017979b          	slliw	a5,a5,0x1
    80006016:	1782                	slli	a5,a5,0x20
    80006018:	9381                	srli	a5,a5,0x20
    8000601a:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    8000601e:	00151493          	slli	s1,a0,0x1
    80006022:	94aa                	add	s1,s1,a0
    80006024:	04b2                	slli	s1,s1,0xc
    80006026:	6909                	lui	s2,0x2
    80006028:	0b090c93          	addi	s9,s2,176 # 20b0 <_entry-0x7fffdf50>
    8000602c:	9ca6                	add	s9,s9,s1
    8000602e:	0001d997          	auipc	s3,0x1d
    80006032:	fd298993          	addi	s3,s3,-46 # 80023000 <disk>
    80006036:	9cce                	add	s9,s9,s3
    80006038:	8566                	mv	a0,s9
    8000603a:	ffffb097          	auipc	ra,0xffffb
    8000603e:	a9c080e7          	jalr	-1380(ra) # 80000ad6 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80006042:	0961                	addi	s2,s2,24
    80006044:	94ca                	add	s1,s1,s2
    80006046:	99a6                	add	s3,s3,s1
  for(int i = 0; i < 3; i++){
    80006048:	4a01                	li	s4,0
  for(int i = 0; i < NUM; i++){
    8000604a:	44a1                	li	s1,8
      disk[n].free[i] = 0;
    8000604c:	001a9793          	slli	a5,s5,0x1
    80006050:	97d6                	add	a5,a5,s5
    80006052:	07b2                	slli	a5,a5,0xc
    80006054:	0001db97          	auipc	s7,0x1d
    80006058:	facb8b93          	addi	s7,s7,-84 # 80023000 <disk>
    8000605c:	9bbe                	add	s7,s7,a5
    8000605e:	a8a9                	j	800060b8 <virtio_disk_rw+0xcc>
    80006060:	00fb8733          	add	a4,s7,a5
    80006064:	9742                	add	a4,a4,a6
    80006066:	00070c23          	sb	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    idx[i] = alloc_desc(n);
    8000606a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000606c:	0207c263          	bltz	a5,80006090 <virtio_disk_rw+0xa4>
  for(int i = 0; i < 3; i++){
    80006070:	2905                	addiw	s2,s2,1
    80006072:	0611                	addi	a2,a2,4
    80006074:	1ca90463          	beq	s2,a0,8000623c <virtio_disk_rw+0x250>
    idx[i] = alloc_desc(n);
    80006078:	85b2                	mv	a1,a2
    8000607a:	874e                	mv	a4,s3
  for(int i = 0; i < NUM; i++){
    8000607c:	87d2                	mv	a5,s4
    if(disk[n].free[i]){
    8000607e:	00074683          	lbu	a3,0(a4)
    80006082:	fef9                	bnez	a3,80006060 <virtio_disk_rw+0x74>
  for(int i = 0; i < NUM; i++){
    80006084:	2785                	addiw	a5,a5,1
    80006086:	0705                	addi	a4,a4,1
    80006088:	fe979be3          	bne	a5,s1,8000607e <virtio_disk_rw+0x92>
    idx[i] = alloc_desc(n);
    8000608c:	57fd                	li	a5,-1
    8000608e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006090:	01205e63          	blez	s2,800060ac <virtio_disk_rw+0xc0>
    80006094:	8d52                	mv	s10,s4
        free_desc(n, idx[j]);
    80006096:	000b2583          	lw	a1,0(s6)
    8000609a:	8556                	mv	a0,s5
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	ccc080e7          	jalr	-820(ra) # 80005d68 <free_desc>
      for(int j = 0; j < i; j++)
    800060a4:	2d05                	addiw	s10,s10,1
    800060a6:	0b11                	addi	s6,s6,4
    800060a8:	ffa917e3          	bne	s2,s10,80006096 <virtio_disk_rw+0xaa>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    800060ac:	85e6                	mv	a1,s9
    800060ae:	854e                	mv	a0,s3
    800060b0:	ffffc097          	auipc	ra,0xffffc
    800060b4:	f9c080e7          	jalr	-100(ra) # 8000204c <sleep>
  for(int i = 0; i < 3; i++){
    800060b8:	f8040b13          	addi	s6,s0,-128
{
    800060bc:	865a                	mv	a2,s6
  for(int i = 0; i < 3; i++){
    800060be:	8952                	mv	s2,s4
      disk[n].free[i] = 0;
    800060c0:	6809                	lui	a6,0x2
  for(int i = 0; i < 3; i++){
    800060c2:	450d                	li	a0,3
    800060c4:	bf55                	j	80006078 <virtio_disk_rw+0x8c>
  disk[n].desc[idx[0]].next = idx[1];

  disk[n].desc[idx[1]].addr = (uint64) b->data;
  disk[n].desc[idx[1]].len = BSIZE;
  if(write)
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    800060c6:	001a9793          	slli	a5,s5,0x1
    800060ca:	97d6                	add	a5,a5,s5
    800060cc:	07b2                	slli	a5,a5,0xc
    800060ce:	0001d717          	auipc	a4,0x1d
    800060d2:	f3270713          	addi	a4,a4,-206 # 80023000 <disk>
    800060d6:	973e                	add	a4,a4,a5
    800060d8:	6789                	lui	a5,0x2
    800060da:	97ba                	add	a5,a5,a4
    800060dc:	639c                	ld	a5,0(a5)
    800060de:	97b6                	add	a5,a5,a3
    800060e0:	00079623          	sh	zero,12(a5) # 200c <_entry-0x7fffdff4>
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060e4:	0001d517          	auipc	a0,0x1d
    800060e8:	f1c50513          	addi	a0,a0,-228 # 80023000 <disk>
    800060ec:	001a9793          	slli	a5,s5,0x1
    800060f0:	01578733          	add	a4,a5,s5
    800060f4:	0732                	slli	a4,a4,0xc
    800060f6:	972a                	add	a4,a4,a0
    800060f8:	6609                	lui	a2,0x2
    800060fa:	9732                	add	a4,a4,a2
    800060fc:	6310                	ld	a2,0(a4)
    800060fe:	9636                	add	a2,a2,a3
    80006100:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006104:	0015e593          	ori	a1,a1,1
    80006108:	00b61623          	sh	a1,12(a2)
  disk[n].desc[idx[1]].next = idx[2];
    8000610c:	f8842603          	lw	a2,-120(s0)
    80006110:	630c                	ld	a1,0(a4)
    80006112:	96ae                	add	a3,a3,a1
    80006114:	00c69723          	sh	a2,14(a3) # 100e <_entry-0x7fffeff2>

  disk[n].info[idx[0]].status = 0;
    80006118:	97d6                	add	a5,a5,s5
    8000611a:	07a2                	slli	a5,a5,0x8
    8000611c:	97a6                	add	a5,a5,s1
    8000611e:	20078793          	addi	a5,a5,512
    80006122:	0792                	slli	a5,a5,0x4
    80006124:	97aa                	add	a5,a5,a0
    80006126:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    8000612a:	00461693          	slli	a3,a2,0x4
    8000612e:	00073803          	ld	a6,0(a4)
    80006132:	9836                	add	a6,a6,a3
    80006134:	20348613          	addi	a2,s1,515
    80006138:	001a9593          	slli	a1,s5,0x1
    8000613c:	95d6                	add	a1,a1,s5
    8000613e:	05a2                	slli	a1,a1,0x8
    80006140:	962e                	add	a2,a2,a1
    80006142:	0612                	slli	a2,a2,0x4
    80006144:	962a                	add	a2,a2,a0
    80006146:	00c83023          	sd	a2,0(a6) # 2000 <_entry-0x7fffe000>
  disk[n].desc[idx[2]].len = 1;
    8000614a:	630c                	ld	a1,0(a4)
    8000614c:	95b6                	add	a1,a1,a3
    8000614e:	4605                	li	a2,1
    80006150:	c590                	sw	a2,8(a1)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006152:	630c                	ld	a1,0(a4)
    80006154:	95b6                	add	a1,a1,a3
    80006156:	4509                	li	a0,2
    80006158:	00a59623          	sh	a0,12(a1)
  disk[n].desc[idx[2]].next = 0;
    8000615c:	630c                	ld	a1,0(a4)
    8000615e:	96ae                	add	a3,a3,a1
    80006160:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006164:	00cc2223          	sw	a2,4(s8) # fffffffffffff004 <end+0xffffffff7ffd5fc0>
  disk[n].info[idx[0]].b = b;
    80006168:	0387b423          	sd	s8,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    8000616c:	6714                	ld	a3,8(a4)
    8000616e:	0026d783          	lhu	a5,2(a3)
    80006172:	8b9d                	andi	a5,a5,7
    80006174:	0789                	addi	a5,a5,2
    80006176:	0786                	slli	a5,a5,0x1
    80006178:	97b6                	add	a5,a5,a3
    8000617a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000617e:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    80006182:	6718                	ld	a4,8(a4)
    80006184:	00275783          	lhu	a5,2(a4)
    80006188:	2785                	addiw	a5,a5,1
    8000618a:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000618e:	001a879b          	addiw	a5,s5,1
    80006192:	00c7979b          	slliw	a5,a5,0xc
    80006196:	10000737          	lui	a4,0x10000
    8000619a:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    8000619e:	97ba                	add	a5,a5,a4
    800061a0:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800061a4:	004c2783          	lw	a5,4(s8)
    800061a8:	00c79d63          	bne	a5,a2,800061c2 <virtio_disk_rw+0x1d6>
    800061ac:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    800061ae:	85e6                	mv	a1,s9
    800061b0:	8562                	mv	a0,s8
    800061b2:	ffffc097          	auipc	ra,0xffffc
    800061b6:	e9a080e7          	jalr	-358(ra) # 8000204c <sleep>
  while(b->disk == 1) {
    800061ba:	004c2783          	lw	a5,4(s8)
    800061be:	fe9788e3          	beq	a5,s1,800061ae <virtio_disk_rw+0x1c2>
  }

  disk[n].info[idx[0]].b = 0;
    800061c2:	f8042483          	lw	s1,-128(s0)
    800061c6:	001a9793          	slli	a5,s5,0x1
    800061ca:	97d6                	add	a5,a5,s5
    800061cc:	07a2                	slli	a5,a5,0x8
    800061ce:	97a6                	add	a5,a5,s1
    800061d0:	20078793          	addi	a5,a5,512
    800061d4:	0792                	slli	a5,a5,0x4
    800061d6:	0001d717          	auipc	a4,0x1d
    800061da:	e2a70713          	addi	a4,a4,-470 # 80023000 <disk>
    800061de:	97ba                	add	a5,a5,a4
    800061e0:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    800061e4:	001a9793          	slli	a5,s5,0x1
    800061e8:	97d6                	add	a5,a5,s5
    800061ea:	07b2                	slli	a5,a5,0xc
    800061ec:	97ba                	add	a5,a5,a4
    800061ee:	6909                	lui	s2,0x2
    800061f0:	993e                	add	s2,s2,a5
    800061f2:	a019                	j	800061f8 <virtio_disk_rw+0x20c>
      i = disk[n].desc[i].next;
    800061f4:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    800061f8:	85a6                	mv	a1,s1
    800061fa:	8556                	mv	a0,s5
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	b6c080e7          	jalr	-1172(ra) # 80005d68 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006204:	0492                	slli	s1,s1,0x4
    80006206:	00093783          	ld	a5,0(s2) # 2000 <_entry-0x7fffe000>
    8000620a:	94be                	add	s1,s1,a5
    8000620c:	00c4d783          	lhu	a5,12(s1)
    80006210:	8b85                	andi	a5,a5,1
    80006212:	f3ed                	bnez	a5,800061f4 <virtio_disk_rw+0x208>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    80006214:	8566                	mv	a0,s9
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	928080e7          	jalr	-1752(ra) # 80000b3e <release>
}
    8000621e:	60ea                	ld	ra,152(sp)
    80006220:	644a                	ld	s0,144(sp)
    80006222:	64aa                	ld	s1,136(sp)
    80006224:	690a                	ld	s2,128(sp)
    80006226:	79e6                	ld	s3,120(sp)
    80006228:	7a46                	ld	s4,112(sp)
    8000622a:	7aa6                	ld	s5,104(sp)
    8000622c:	7b06                	ld	s6,96(sp)
    8000622e:	6be6                	ld	s7,88(sp)
    80006230:	6c46                	ld	s8,80(sp)
    80006232:	6ca6                	ld	s9,72(sp)
    80006234:	6d06                	ld	s10,64(sp)
    80006236:	7de2                	ld	s11,56(sp)
    80006238:	610d                	addi	sp,sp,160
    8000623a:	8082                	ret
  if(write)
    8000623c:	01b037b3          	snez	a5,s11
    80006240:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    80006244:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006248:	f6843783          	ld	a5,-152(s0)
    8000624c:	f6f43c23          	sd	a5,-136(s0)
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006250:	f8042483          	lw	s1,-128(s0)
    80006254:	00449993          	slli	s3,s1,0x4
    80006258:	001a9793          	slli	a5,s5,0x1
    8000625c:	97d6                	add	a5,a5,s5
    8000625e:	07b2                	slli	a5,a5,0xc
    80006260:	0001d917          	auipc	s2,0x1d
    80006264:	da090913          	addi	s2,s2,-608 # 80023000 <disk>
    80006268:	97ca                	add	a5,a5,s2
    8000626a:	6909                	lui	s2,0x2
    8000626c:	993e                	add	s2,s2,a5
    8000626e:	00093a03          	ld	s4,0(s2) # 2000 <_entry-0x7fffe000>
    80006272:	9a4e                	add	s4,s4,s3
    80006274:	f7040513          	addi	a0,s0,-144
    80006278:	ffffb097          	auipc	ra,0xffffb
    8000627c:	d52080e7          	jalr	-686(ra) # 80000fca <kvmpa>
    80006280:	00aa3023          	sd	a0,0(s4)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    80006284:	00093783          	ld	a5,0(s2)
    80006288:	97ce                	add	a5,a5,s3
    8000628a:	4741                	li	a4,16
    8000628c:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000628e:	00093783          	ld	a5,0(s2)
    80006292:	97ce                	add	a5,a5,s3
    80006294:	4705                	li	a4,1
    80006296:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    8000629a:	f8442683          	lw	a3,-124(s0)
    8000629e:	00093783          	ld	a5,0(s2)
    800062a2:	99be                	add	s3,s3,a5
    800062a4:	00d99723          	sh	a3,14(s3)
  disk[n].desc[idx[1]].addr = (uint64) b->data;
    800062a8:	0692                	slli	a3,a3,0x4
    800062aa:	00093783          	ld	a5,0(s2)
    800062ae:	97b6                	add	a5,a5,a3
    800062b0:	060c0713          	addi	a4,s8,96
    800062b4:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    800062b6:	00093783          	ld	a5,0(s2)
    800062ba:	97b6                	add	a5,a5,a3
    800062bc:	40000713          	li	a4,1024
    800062c0:	c798                	sw	a4,8(a5)
  if(write)
    800062c2:	e00d92e3          	bnez	s11,800060c6 <virtio_disk_rw+0xda>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800062c6:	001a9793          	slli	a5,s5,0x1
    800062ca:	97d6                	add	a5,a5,s5
    800062cc:	07b2                	slli	a5,a5,0xc
    800062ce:	0001d717          	auipc	a4,0x1d
    800062d2:	d3270713          	addi	a4,a4,-718 # 80023000 <disk>
    800062d6:	973e                	add	a4,a4,a5
    800062d8:	6789                	lui	a5,0x2
    800062da:	97ba                	add	a5,a5,a4
    800062dc:	639c                	ld	a5,0(a5)
    800062de:	97b6                	add	a5,a5,a3
    800062e0:	4709                	li	a4,2
    800062e2:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    800062e6:	bbfd                	j	800060e4 <virtio_disk_rw+0xf8>

00000000800062e8 <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    800062e8:	7139                	addi	sp,sp,-64
    800062ea:	fc06                	sd	ra,56(sp)
    800062ec:	f822                	sd	s0,48(sp)
    800062ee:	f426                	sd	s1,40(sp)
    800062f0:	f04a                	sd	s2,32(sp)
    800062f2:	ec4e                	sd	s3,24(sp)
    800062f4:	e852                	sd	s4,16(sp)
    800062f6:	e456                	sd	s5,8(sp)
    800062f8:	0080                	addi	s0,sp,64
    800062fa:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    800062fc:	00151913          	slli	s2,a0,0x1
    80006300:	00a90a33          	add	s4,s2,a0
    80006304:	0a32                	slli	s4,s4,0xc
    80006306:	6989                	lui	s3,0x2
    80006308:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    8000630c:	9a3e                	add	s4,s4,a5
    8000630e:	0001da97          	auipc	s5,0x1d
    80006312:	cf2a8a93          	addi	s5,s5,-782 # 80023000 <disk>
    80006316:	9a56                	add	s4,s4,s5
    80006318:	8552                	mv	a0,s4
    8000631a:	ffffa097          	auipc	ra,0xffffa
    8000631e:	7bc080e7          	jalr	1980(ra) # 80000ad6 <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    80006322:	9926                	add	s2,s2,s1
    80006324:	0932                	slli	s2,s2,0xc
    80006326:	9956                	add	s2,s2,s5
    80006328:	99ca                	add	s3,s3,s2
    8000632a:	0209d783          	lhu	a5,32(s3)
    8000632e:	0109b703          	ld	a4,16(s3)
    80006332:	00275683          	lhu	a3,2(a4)
    80006336:	8ebd                	xor	a3,a3,a5
    80006338:	8a9d                	andi	a3,a3,7
    8000633a:	c2a5                	beqz	a3,8000639a <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    8000633c:	8956                	mv	s2,s5
    8000633e:	00149693          	slli	a3,s1,0x1
    80006342:	96a6                	add	a3,a3,s1
    80006344:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006348:	06b2                	slli	a3,a3,0xc
    8000634a:	96d6                	add	a3,a3,s5
    8000634c:	6489                	lui	s1,0x2
    8000634e:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    80006350:	078e                	slli	a5,a5,0x3
    80006352:	97ba                	add	a5,a5,a4
    80006354:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    80006356:	00f98733          	add	a4,s3,a5
    8000635a:	20070713          	addi	a4,a4,512
    8000635e:	0712                	slli	a4,a4,0x4
    80006360:	974a                	add	a4,a4,s2
    80006362:	03074703          	lbu	a4,48(a4)
    80006366:	eb21                	bnez	a4,800063b6 <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    80006368:	97ce                	add	a5,a5,s3
    8000636a:	20078793          	addi	a5,a5,512
    8000636e:	0792                	slli	a5,a5,0x4
    80006370:	97ca                	add	a5,a5,s2
    80006372:	7798                	ld	a4,40(a5)
    80006374:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    80006378:	7788                	ld	a0,40(a5)
    8000637a:	ffffc097          	auipc	ra,0xffffc
    8000637e:	e52080e7          	jalr	-430(ra) # 800021cc <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006382:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    80006386:	2785                	addiw	a5,a5,1
    80006388:	8b9d                	andi	a5,a5,7
    8000638a:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    8000638e:	6898                	ld	a4,16(s1)
    80006390:	00275683          	lhu	a3,2(a4)
    80006394:	8a9d                	andi	a3,a3,7
    80006396:	faf69de3          	bne	a3,a5,80006350 <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    8000639a:	8552                	mv	a0,s4
    8000639c:	ffffa097          	auipc	ra,0xffffa
    800063a0:	7a2080e7          	jalr	1954(ra) # 80000b3e <release>
}
    800063a4:	70e2                	ld	ra,56(sp)
    800063a6:	7442                	ld	s0,48(sp)
    800063a8:	74a2                	ld	s1,40(sp)
    800063aa:	7902                	ld	s2,32(sp)
    800063ac:	69e2                	ld	s3,24(sp)
    800063ae:	6a42                	ld	s4,16(sp)
    800063b0:	6aa2                	ld	s5,8(sp)
    800063b2:	6121                	addi	sp,sp,64
    800063b4:	8082                	ret
      panic("virtio_disk_intr status");
    800063b6:	00001517          	auipc	a0,0x1
    800063ba:	4e250513          	addi	a0,a0,1250 # 80007898 <userret+0x808>
    800063be:	ffffa097          	auipc	ra,0xffffa
    800063c2:	18a080e7          	jalr	394(ra) # 80000548 <panic>

00000000800063c6 <bit_isset>:
static Sz_info *bd_sizes;
static void *bd_base;   // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    800063c6:	1141                	addi	sp,sp,-16
    800063c8:	e422                	sd	s0,8(sp)
    800063ca:	0800                	addi	s0,sp,16
  char b = array[index/8];
  char m = (1 << (index % 8));
    800063cc:	41f5d79b          	sraiw	a5,a1,0x1f
    800063d0:	01d7d79b          	srliw	a5,a5,0x1d
    800063d4:	9dbd                	addw	a1,a1,a5
    800063d6:	0075f713          	andi	a4,a1,7
    800063da:	9f1d                	subw	a4,a4,a5
    800063dc:	4785                	li	a5,1
    800063de:	00e797bb          	sllw	a5,a5,a4
    800063e2:	0ff7f793          	andi	a5,a5,255
  char b = array[index/8];
    800063e6:	4035d59b          	sraiw	a1,a1,0x3
    800063ea:	95aa                	add	a1,a1,a0
  return (b & m) == m;
    800063ec:	0005c503          	lbu	a0,0(a1)
    800063f0:	8d7d                	and	a0,a0,a5
    800063f2:	8d1d                	sub	a0,a0,a5
}
    800063f4:	00153513          	seqz	a0,a0
    800063f8:	6422                	ld	s0,8(sp)
    800063fa:	0141                	addi	sp,sp,16
    800063fc:	8082                	ret

00000000800063fe <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    800063fe:	1141                	addi	sp,sp,-16
    80006400:	e422                	sd	s0,8(sp)
    80006402:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006404:	41f5d79b          	sraiw	a5,a1,0x1f
    80006408:	01d7d79b          	srliw	a5,a5,0x1d
    8000640c:	9dbd                	addw	a1,a1,a5
    8000640e:	4035d71b          	sraiw	a4,a1,0x3
    80006412:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    80006414:	899d                	andi	a1,a1,7
    80006416:	9d9d                	subw	a1,a1,a5
    80006418:	4785                	li	a5,1
    8000641a:	00b795bb          	sllw	a1,a5,a1
  array[index/8] = (b | m);
    8000641e:	00054783          	lbu	a5,0(a0)
    80006422:	8ddd                	or	a1,a1,a5
    80006424:	00b50023          	sb	a1,0(a0)
}
    80006428:	6422                	ld	s0,8(sp)
    8000642a:	0141                	addi	sp,sp,16
    8000642c:	8082                	ret

000000008000642e <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    8000642e:	1141                	addi	sp,sp,-16
    80006430:	e422                	sd	s0,8(sp)
    80006432:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006434:	41f5d79b          	sraiw	a5,a1,0x1f
    80006438:	01d7d79b          	srliw	a5,a5,0x1d
    8000643c:	9dbd                	addw	a1,a1,a5
    8000643e:	4035d71b          	sraiw	a4,a1,0x3
    80006442:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    80006444:	899d                	andi	a1,a1,7
    80006446:	9d9d                	subw	a1,a1,a5
    80006448:	4785                	li	a5,1
    8000644a:	00b795bb          	sllw	a1,a5,a1
  array[index/8] = (b & ~m);
    8000644e:	fff5c593          	not	a1,a1
    80006452:	00054783          	lbu	a5,0(a0)
    80006456:	8dfd                	and	a1,a1,a5
    80006458:	00b50023          	sb	a1,0(a0)
}
    8000645c:	6422                	ld	s0,8(sp)
    8000645e:	0141                	addi	sp,sp,16
    80006460:	8082                	ret

0000000080006462 <bd_print>:

void
bd_print() {
    80006462:	7159                	addi	sp,sp,-112
    80006464:	f486                	sd	ra,104(sp)
    80006466:	f0a2                	sd	s0,96(sp)
    80006468:	eca6                	sd	s1,88(sp)
    8000646a:	e8ca                	sd	s2,80(sp)
    8000646c:	e4ce                	sd	s3,72(sp)
    8000646e:	e0d2                	sd	s4,64(sp)
    80006470:	fc56                	sd	s5,56(sp)
    80006472:	f85a                	sd	s6,48(sp)
    80006474:	f45e                	sd	s7,40(sp)
    80006476:	f062                	sd	s8,32(sp)
    80006478:	ec66                	sd	s9,24(sp)
    8000647a:	e86a                	sd	s10,16(sp)
    8000647c:	e46e                	sd	s11,8(sp)
    8000647e:	1880                	addi	s0,sp,112
    80006480:	4b01                	li	s6,0
  for (int k = 0; k < nsizes; k++) {
    80006482:	4a81                	li	s5,0
    printf("size %d (%d):", k, BLK_SIZE(k));
    80006484:	4dc1                	li	s11,16
    80006486:	00001d17          	auipc	s10,0x1
    8000648a:	42ad0d13          	addi	s10,s10,1066 # 800078b0 <userret+0x820>
    lst_print(&bd_sizes[k].free);
    printf("  alloc:");
    for (int b = 0; b < NBLK(k); b++) {
    8000648e:	4c91                	li	s9,4
    80006490:	4c05                	li	s8,1
     printf(" %d", bit_isset(bd_sizes[k].alloc, b));
    }
    printf("\n");
    80006492:	00001b97          	auipc	s7,0x1
    80006496:	d1eb8b93          	addi	s7,s7,-738 # 800071b0 <userret+0x120>
     printf(" %d", bit_isset(bd_sizes[k].alloc, b));
    8000649a:	00001a17          	auipc	s4,0x1
    8000649e:	436a0a13          	addi	s4,s4,1078 # 800078d0 <userret+0x840>
    800064a2:	a0a9                	j	800064ec <bd_print+0x8a>
    if(k > 0) {
      printf("  split:");
    800064a4:	00001517          	auipc	a0,0x1
    800064a8:	43450513          	addi	a0,a0,1076 # 800078d8 <userret+0x848>
    800064ac:	ffffa097          	auipc	ra,0xffffa
    800064b0:	0e6080e7          	jalr	230(ra) # 80000592 <printf>
    800064b4:	4481                	li	s1,0
      for (int b = 0; b < NBLK(k); b++) {
        printf(" %d", bit_isset(bd_sizes[k].split, b));
    800064b6:	85a6                	mv	a1,s1
    800064b8:	0189b503          	ld	a0,24(s3)
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	f0a080e7          	jalr	-246(ra) # 800063c6 <bit_isset>
    800064c4:	85aa                	mv	a1,a0
    800064c6:	8552                	mv	a0,s4
    800064c8:	ffffa097          	auipc	ra,0xffffa
    800064cc:	0ca080e7          	jalr	202(ra) # 80000592 <printf>
      for (int b = 0; b < NBLK(k); b++) {
    800064d0:	2485                	addiw	s1,s1,1
    800064d2:	fe9912e3          	bne	s2,s1,800064b6 <bd_print+0x54>
      }
      printf("\n");
    800064d6:	855e                	mv	a0,s7
    800064d8:	ffffa097          	auipc	ra,0xffffa
    800064dc:	0ba080e7          	jalr	186(ra) # 80000592 <printf>
  for (int k = 0; k < nsizes; k++) {
    800064e0:	2a85                	addiw	s5,s5,1
    800064e2:	020b0b13          	addi	s6,s6,32
    800064e6:	4795                	li	a5,5
    800064e8:	08fa8763          	beq	s5,a5,80006576 <bd_print+0x114>
    printf("size %d (%d):", k, BLK_SIZE(k));
    800064ec:	015d9633          	sll	a2,s11,s5
    800064f0:	85d6                	mv	a1,s5
    800064f2:	856a                	mv	a0,s10
    800064f4:	ffffa097          	auipc	ra,0xffffa
    800064f8:	09e080e7          	jalr	158(ra) # 80000592 <printf>
    lst_print(&bd_sizes[k].free);
    800064fc:	89da                	mv	s3,s6
    800064fe:	855a                	mv	a0,s6
    80006500:	00000097          	auipc	ra,0x0
    80006504:	44c080e7          	jalr	1100(ra) # 8000694c <lst_print>
    printf("  alloc:");
    80006508:	00001517          	auipc	a0,0x1
    8000650c:	3b850513          	addi	a0,a0,952 # 800078c0 <userret+0x830>
    80006510:	ffffa097          	auipc	ra,0xffffa
    80006514:	082080e7          	jalr	130(ra) # 80000592 <printf>
    for (int b = 0; b < NBLK(k); b++) {
    80006518:	415c893b          	subw	s2,s9,s5
    8000651c:	012c193b          	sllw	s2,s8,s2
    80006520:	03205b63          	blez	s2,80006556 <bd_print+0xf4>
    80006524:	4481                	li	s1,0
     printf(" %d", bit_isset(bd_sizes[k].alloc, b));
    80006526:	85a6                	mv	a1,s1
    80006528:	0109b503          	ld	a0,16(s3)
    8000652c:	00000097          	auipc	ra,0x0
    80006530:	e9a080e7          	jalr	-358(ra) # 800063c6 <bit_isset>
    80006534:	85aa                	mv	a1,a0
    80006536:	8552                	mv	a0,s4
    80006538:	ffffa097          	auipc	ra,0xffffa
    8000653c:	05a080e7          	jalr	90(ra) # 80000592 <printf>
    for (int b = 0; b < NBLK(k); b++) {
    80006540:	2485                	addiw	s1,s1,1
    80006542:	fe9912e3          	bne	s2,s1,80006526 <bd_print+0xc4>
    printf("\n");
    80006546:	855e                	mv	a0,s7
    80006548:	ffffa097          	auipc	ra,0xffffa
    8000654c:	04a080e7          	jalr	74(ra) # 80000592 <printf>
    if(k > 0) {
    80006550:	f95058e3          	blez	s5,800064e0 <bd_print+0x7e>
    80006554:	bf81                	j	800064a4 <bd_print+0x42>
    printf("\n");
    80006556:	855e                	mv	a0,s7
    80006558:	ffffa097          	auipc	ra,0xffffa
    8000655c:	03a080e7          	jalr	58(ra) # 80000592 <printf>
    if(k > 0) {
    80006560:	f95050e3          	blez	s5,800064e0 <bd_print+0x7e>
      printf("  split:");
    80006564:	00001517          	auipc	a0,0x1
    80006568:	37450513          	addi	a0,a0,884 # 800078d8 <userret+0x848>
    8000656c:	ffffa097          	auipc	ra,0xffffa
    80006570:	026080e7          	jalr	38(ra) # 80000592 <printf>
      for (int b = 0; b < NBLK(k); b++) {
    80006574:	b78d                	j	800064d6 <bd_print+0x74>
    }
  }
}
    80006576:	70a6                	ld	ra,104(sp)
    80006578:	7406                	ld	s0,96(sp)
    8000657a:	64e6                	ld	s1,88(sp)
    8000657c:	6946                	ld	s2,80(sp)
    8000657e:	69a6                	ld	s3,72(sp)
    80006580:	6a06                	ld	s4,64(sp)
    80006582:	7ae2                	ld	s5,56(sp)
    80006584:	7b42                	ld	s6,48(sp)
    80006586:	7ba2                	ld	s7,40(sp)
    80006588:	7c02                	ld	s8,32(sp)
    8000658a:	6ce2                	ld	s9,24(sp)
    8000658c:	6d42                	ld	s10,16(sp)
    8000658e:	6da2                	ld	s11,8(sp)
    80006590:	6165                	addi	sp,sp,112
    80006592:	8082                	ret

0000000080006594 <firstk>:

// What is the first k such that 2^k >= n?
int
firstk(uint64 n) {
    80006594:	1141                	addi	sp,sp,-16
    80006596:	e422                	sd	s0,8(sp)
    80006598:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    8000659a:	47c1                	li	a5,16
    8000659c:	00a7fb63          	bgeu	a5,a0,800065b2 <firstk+0x1e>
    800065a0:	872a                	mv	a4,a0
  int k = 0;
    800065a2:	4501                	li	a0,0
    k++;
    800065a4:	2505                	addiw	a0,a0,1
    size *= 2;
    800065a6:	0786                	slli	a5,a5,0x1
  while (size < n) {
    800065a8:	fee7eee3          	bltu	a5,a4,800065a4 <firstk+0x10>
  }
  return k;
}
    800065ac:	6422                	ld	s0,8(sp)
    800065ae:	0141                	addi	sp,sp,16
    800065b0:	8082                	ret
  int k = 0;
    800065b2:	4501                	li	a0,0
    800065b4:	bfe5                	j	800065ac <firstk+0x18>

00000000800065b6 <blk_index>:

// Compute the block index for address p at size k
int
blk_index(int k, char *p) {
    800065b6:	1141                	addi	sp,sp,-16
    800065b8:	e422                	sd	s0,8(sp)
    800065ba:	0800                	addi	s0,sp,16
  int n = p - (char *) bd_base;
  return n / BLK_SIZE(k);
    800065bc:	2581                	sext.w	a1,a1
    800065be:	47c1                	li	a5,16
    800065c0:	00a797b3          	sll	a5,a5,a0
    800065c4:	02f5c5b3          	div	a1,a1,a5
}
    800065c8:	0005851b          	sext.w	a0,a1
    800065cc:	6422                	ld	s0,8(sp)
    800065ce:	0141                	addi	sp,sp,16
    800065d0:	8082                	ret

00000000800065d2 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    800065d2:	1141                	addi	sp,sp,-16
    800065d4:	e422                	sd	s0,8(sp)
    800065d6:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    800065d8:	47c1                	li	a5,16
    800065da:	00a79533          	sll	a0,a5,a0
  return (char *) bd_base + n;
}
    800065de:	02b5053b          	mulw	a0,a0,a1
    800065e2:	6422                	ld	s0,8(sp)
    800065e4:	0141                	addi	sp,sp,16
    800065e6:	8082                	ret

00000000800065e8 <bd_malloc>:

void *
bd_malloc(uint64 nbytes)
{
    800065e8:	715d                	addi	sp,sp,-80
    800065ea:	e486                	sd	ra,72(sp)
    800065ec:	e0a2                	sd	s0,64(sp)
    800065ee:	fc26                	sd	s1,56(sp)
    800065f0:	f84a                	sd	s2,48(sp)
    800065f2:	f44e                	sd	s3,40(sp)
    800065f4:	f052                	sd	s4,32(sp)
    800065f6:	ec56                	sd	s5,24(sp)
    800065f8:	e85a                	sd	s6,16(sp)
    800065fa:	e45e                	sd	s7,8(sp)
    800065fc:	e062                	sd	s8,0(sp)
    800065fe:	0880                	addi	s0,sp,80
    80006600:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    80006602:	00023517          	auipc	a0,0x23
    80006606:	9fe50513          	addi	a0,a0,-1538 # 80029000 <lock>
    8000660a:	ffffa097          	auipc	ra,0xffffa
    8000660e:	4cc080e7          	jalr	1228(ra) # 80000ad6 <acquire>
  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    80006612:	8526                	mv	a0,s1
    80006614:	00000097          	auipc	ra,0x0
    80006618:	f80080e7          	jalr	-128(ra) # 80006594 <firstk>
  for (k = fk; k < nsizes; k++) {
    8000661c:	4791                	li	a5,4
    8000661e:	02a7c263          	blt	a5,a0,80006642 <bd_malloc+0x5a>
    80006622:	8b2a                	mv	s6,a0
    80006624:	00551913          	slli	s2,a0,0x5
    80006628:	84aa                	mv	s1,a0
    8000662a:	4995                	li	s3,5
    if(!lst_empty(&bd_sizes[k].free))
    8000662c:	854a                	mv	a0,s2
    8000662e:	00000097          	auipc	ra,0x0
    80006632:	2a4080e7          	jalr	676(ra) # 800068d2 <lst_empty>
    80006636:	c105                	beqz	a0,80006656 <bd_malloc+0x6e>
  for (k = fk; k < nsizes; k++) {
    80006638:	2485                	addiw	s1,s1,1
    8000663a:	02090913          	addi	s2,s2,32
    8000663e:	ff3497e3          	bne	s1,s3,8000662c <bd_malloc+0x44>
      break;
  }
  if(k >= nsizes) { // No free blocks?
    release(&lock);
    80006642:	00023517          	auipc	a0,0x23
    80006646:	9be50513          	addi	a0,a0,-1602 # 80029000 <lock>
    8000664a:	ffffa097          	auipc	ra,0xffffa
    8000664e:	4f4080e7          	jalr	1268(ra) # 80000b3e <release>
    return 0;
    80006652:	4c01                	li	s8,0
    80006654:	a849                	j	800066e6 <bd_malloc+0xfe>
  if(k >= nsizes) { // No free blocks?
    80006656:	4791                	li	a5,4
    80006658:	fe97c5e3          	blt	a5,s1,80006642 <bd_malloc+0x5a>
  }

  // Found one; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    8000665c:	00549913          	slli	s2,s1,0x5
    80006660:	854a                	mv	a0,s2
    80006662:	00000097          	auipc	ra,0x0
    80006666:	29c080e7          	jalr	668(ra) # 800068fe <lst_pop>
    8000666a:	8c2a                	mv	s8,a0
  return n / BLK_SIZE(k);
    8000666c:	00050a1b          	sext.w	s4,a0
    80006670:	45c1                	li	a1,16
    80006672:	009595b3          	sll	a1,a1,s1
    80006676:	02ba45b3          	div	a1,s4,a1
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    8000667a:	2581                	sext.w	a1,a1
    8000667c:	01093503          	ld	a0,16(s2)
    80006680:	00000097          	auipc	ra,0x0
    80006684:	d7e080e7          	jalr	-642(ra) # 800063fe <bit_set>
  for(; k > fk; k--) {
    80006688:	049b5763          	bge	s6,s1,800066d6 <bd_malloc+0xee>
    8000668c:	1901                	addi	s2,s2,-32
    char *q = p + BLK_SIZE(k-1);
    8000668e:	4ac1                	li	s5,16
    80006690:	85a6                	mv	a1,s1
    80006692:	34fd                	addiw	s1,s1,-1
    80006694:	009a99b3          	sll	s3,s5,s1
    80006698:	013c0bb3          	add	s7,s8,s3
  return n / BLK_SIZE(k);
    8000669c:	00ba95b3          	sll	a1,s5,a1
    800066a0:	02ba45b3          	div	a1,s4,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    800066a4:	2581                	sext.w	a1,a1
    800066a6:	03893503          	ld	a0,56(s2)
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	d54080e7          	jalr	-684(ra) # 800063fe <bit_set>
  return n / BLK_SIZE(k);
    800066b2:	033a45b3          	div	a1,s4,s3
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    800066b6:	2581                	sext.w	a1,a1
    800066b8:	01093503          	ld	a0,16(s2)
    800066bc:	00000097          	auipc	ra,0x0
    800066c0:	d42080e7          	jalr	-702(ra) # 800063fe <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    800066c4:	85de                	mv	a1,s7
    800066c6:	854a                	mv	a0,s2
    800066c8:	00000097          	auipc	ra,0x0
    800066cc:	26c080e7          	jalr	620(ra) # 80006934 <lst_push>
  for(; k > fk; k--) {
    800066d0:	1901                	addi	s2,s2,-32
    800066d2:	fb649fe3          	bne	s1,s6,80006690 <bd_malloc+0xa8>
  }
  //printf("malloc: %p size class %d\n", p, fk);
  release(&lock);
    800066d6:	00023517          	auipc	a0,0x23
    800066da:	92a50513          	addi	a0,a0,-1750 # 80029000 <lock>
    800066de:	ffffa097          	auipc	ra,0xffffa
    800066e2:	460080e7          	jalr	1120(ra) # 80000b3e <release>
  return p;
}
    800066e6:	8562                	mv	a0,s8
    800066e8:	60a6                	ld	ra,72(sp)
    800066ea:	6406                	ld	s0,64(sp)
    800066ec:	74e2                	ld	s1,56(sp)
    800066ee:	7942                	ld	s2,48(sp)
    800066f0:	79a2                	ld	s3,40(sp)
    800066f2:	7a02                	ld	s4,32(sp)
    800066f4:	6ae2                	ld	s5,24(sp)
    800066f6:	6b42                	ld	s6,16(sp)
    800066f8:	6ba2                	ld	s7,8(sp)
    800066fa:	6c02                	ld	s8,0(sp)
    800066fc:	6161                	addi	sp,sp,80
    800066fe:	8082                	ret

0000000080006700 <size>:

// Find the size of the block that p points to.
int
size(char *p) {
    80006700:	7139                	addi	sp,sp,-64
    80006702:	fc06                	sd	ra,56(sp)
    80006704:	f822                	sd	s0,48(sp)
    80006706:	f426                	sd	s1,40(sp)
    80006708:	f04a                	sd	s2,32(sp)
    8000670a:	ec4e                	sd	s3,24(sp)
    8000670c:	e852                	sd	s4,16(sp)
    8000670e:	e456                	sd	s5,8(sp)
    80006710:	e05a                	sd	s6,0(sp)
    80006712:	0080                	addi	s0,sp,64
    80006714:	02000913          	li	s2,32
  for (int k = 0; k < nsizes; k++) {
    80006718:	4481                	li	s1,0
  return n / BLK_SIZE(k);
    8000671a:	0005099b          	sext.w	s3,a0
    8000671e:	4a41                	li	s4,16
  for (int k = 0; k < nsizes; k++) {
    80006720:	4a95                	li	s5,5
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006722:	8b26                	mv	s6,s1
    80006724:	2485                	addiw	s1,s1,1
  return n / BLK_SIZE(k);
    80006726:	009a15b3          	sll	a1,s4,s1
    8000672a:	02b9c5b3          	div	a1,s3,a1
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    8000672e:	2581                	sext.w	a1,a1
    80006730:	01893503          	ld	a0,24(s2)
    80006734:	00000097          	auipc	ra,0x0
    80006738:	c92080e7          	jalr	-878(ra) # 800063c6 <bit_isset>
    8000673c:	ed19                	bnez	a0,8000675a <size+0x5a>
  for (int k = 0; k < nsizes; k++) {
    8000673e:	02090913          	addi	s2,s2,32
    80006742:	ff5490e3          	bne	s1,s5,80006722 <size+0x22>
      return k;
    }
  }
  return 0;
}
    80006746:	70e2                	ld	ra,56(sp)
    80006748:	7442                	ld	s0,48(sp)
    8000674a:	74a2                	ld	s1,40(sp)
    8000674c:	7902                	ld	s2,32(sp)
    8000674e:	69e2                	ld	s3,24(sp)
    80006750:	6a42                	ld	s4,16(sp)
    80006752:	6aa2                	ld	s5,8(sp)
    80006754:	6b02                	ld	s6,0(sp)
    80006756:	6121                	addi	sp,sp,64
    80006758:	8082                	ret
    8000675a:	855a                	mv	a0,s6
    8000675c:	b7ed                	j	80006746 <size+0x46>

000000008000675e <bd_free>:

void
bd_free(void *p) {
    8000675e:	715d                	addi	sp,sp,-80
    80006760:	e486                	sd	ra,72(sp)
    80006762:	e0a2                	sd	s0,64(sp)
    80006764:	fc26                	sd	s1,56(sp)
    80006766:	f84a                	sd	s2,48(sp)
    80006768:	f44e                	sd	s3,40(sp)
    8000676a:	f052                	sd	s4,32(sp)
    8000676c:	ec56                	sd	s5,24(sp)
    8000676e:	e85a                	sd	s6,16(sp)
    80006770:	e45e                	sd	s7,8(sp)
    80006772:	e062                	sd	s8,0(sp)
    80006774:	0880                	addi	s0,sp,80
    80006776:	89aa                	mv	s3,a0
  void *q;
  int k;

  acquire(&lock);
    80006778:	00023517          	auipc	a0,0x23
    8000677c:	88850513          	addi	a0,a0,-1912 # 80029000 <lock>
    80006780:	ffffa097          	auipc	ra,0xffffa
    80006784:	356080e7          	jalr	854(ra) # 80000ad6 <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    80006788:	854e                	mv	a0,s3
    8000678a:	00000097          	auipc	ra,0x0
    8000678e:	f76080e7          	jalr	-138(ra) # 80006700 <size>
    80006792:	84aa                	mv	s1,a0
    80006794:	478d                	li	a5,3
    80006796:	08a7c663          	blt	a5,a0,80006822 <bd_free+0xc4>
    8000679a:	00150913          	addi	s2,a0,1
    8000679e:	0916                	slli	s2,s2,0x5
  return n / BLK_SIZE(k);
    800067a0:	4a41                	li	s4,16
  for (k = size(p); k < MAXSIZE; k++) {
    800067a2:	4a91                	li	s5,4
    800067a4:	a035                	j	800067d0 <bd_free+0x72>
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    800067a6:	fff58c1b          	addiw	s8,a1,-1
    800067aa:	a83d                	j	800067e8 <bd_free+0x8a>
    q = addr(k, buddy);
    lst_remove(q);
    if(buddy % 2 == 0) {
      p = q;
    }
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800067ac:	2485                	addiw	s1,s1,1
  return n / BLK_SIZE(k);
    800067ae:	0009859b          	sext.w	a1,s3
    800067b2:	009a17b3          	sll	a5,s4,s1
    800067b6:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    800067ba:	2581                	sext.w	a1,a1
    800067bc:	01893503          	ld	a0,24(s2)
    800067c0:	00000097          	auipc	ra,0x0
    800067c4:	c6e080e7          	jalr	-914(ra) # 8000642e <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    800067c8:	02090913          	addi	s2,s2,32
    800067cc:	05548b63          	beq	s1,s5,80006822 <bd_free+0xc4>
  return n / BLK_SIZE(k);
    800067d0:	009a1b33          	sll	s6,s4,s1
    800067d4:	0009879b          	sext.w	a5,s3
    800067d8:	0367c7b3          	div	a5,a5,s6
    800067dc:	0007859b          	sext.w	a1,a5
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    800067e0:	8b85                	andi	a5,a5,1
    800067e2:	f3f1                	bnez	a5,800067a6 <bd_free+0x48>
    800067e4:	00158c1b          	addiw	s8,a1,1
    bit_clear(bd_sizes[k].alloc, bi);
    800067e8:	ff093503          	ld	a0,-16(s2)
    800067ec:	00000097          	auipc	ra,0x0
    800067f0:	c42080e7          	jalr	-958(ra) # 8000642e <bit_clear>
    if (bit_isset(bd_sizes[k].alloc, buddy)) {
    800067f4:	85e2                	mv	a1,s8
    800067f6:	ff093503          	ld	a0,-16(s2)
    800067fa:	00000097          	auipc	ra,0x0
    800067fe:	bcc080e7          	jalr	-1076(ra) # 800063c6 <bit_isset>
    80006802:	e105                	bnez	a0,80006822 <bd_free+0xc4>
  int n = bi * BLK_SIZE(k);
    80006804:	000c0b9b          	sext.w	s7,s8
  return (char *) bd_base + n;
    80006808:	038b0b3b          	mulw	s6,s6,s8
    lst_remove(q);
    8000680c:	855a                	mv	a0,s6
    8000680e:	00000097          	auipc	ra,0x0
    80006812:	0da080e7          	jalr	218(ra) # 800068e8 <lst_remove>
    if(buddy % 2 == 0) {
    80006816:	001bfb93          	andi	s7,s7,1
    8000681a:	f80b99e3          	bnez	s7,800067ac <bd_free+0x4e>
      p = q;
    8000681e:	89da                	mv	s3,s6
    80006820:	b771                	j	800067ac <bd_free+0x4e>
  }
  //printf("free %p @ %d\n", p, k);
  lst_push(&bd_sizes[k].free, p);
    80006822:	85ce                	mv	a1,s3
    80006824:	00549513          	slli	a0,s1,0x5
    80006828:	00000097          	auipc	ra,0x0
    8000682c:	10c080e7          	jalr	268(ra) # 80006934 <lst_push>
  release(&lock);
    80006830:	00022517          	auipc	a0,0x22
    80006834:	7d050513          	addi	a0,a0,2000 # 80029000 <lock>
    80006838:	ffffa097          	auipc	ra,0xffffa
    8000683c:	306080e7          	jalr	774(ra) # 80000b3e <release>
}
    80006840:	60a6                	ld	ra,72(sp)
    80006842:	6406                	ld	s0,64(sp)
    80006844:	74e2                	ld	s1,56(sp)
    80006846:	7942                	ld	s2,48(sp)
    80006848:	79a2                	ld	s3,40(sp)
    8000684a:	7a02                	ld	s4,32(sp)
    8000684c:	6ae2                	ld	s5,24(sp)
    8000684e:	6b42                	ld	s6,16(sp)
    80006850:	6ba2                	ld	s7,8(sp)
    80006852:	6c02                	ld	s8,0(sp)
    80006854:	6161                	addi	sp,sp,80
    80006856:	8082                	ret

0000000080006858 <blk_index_next>:

int
blk_index_next(int k, char *p) {
    80006858:	1141                	addi	sp,sp,-16
    8000685a:	e422                	sd	s0,8(sp)
    8000685c:	0800                	addi	s0,sp,16
  int n = (p - (char *) bd_base) / BLK_SIZE(k);
    8000685e:	47c1                	li	a5,16
    80006860:	00a797b3          	sll	a5,a5,a0
    80006864:	02f5c533          	div	a0,a1,a5
    80006868:	2501                	sext.w	a0,a0
  if((p - (char*) bd_base) % BLK_SIZE(k) != 0)
    8000686a:	02f5e5b3          	rem	a1,a1,a5
    8000686e:	c191                	beqz	a1,80006872 <blk_index_next+0x1a>
      n++;
    80006870:	2505                	addiw	a0,a0,1
  return n ;
}
    80006872:	6422                	ld	s0,8(sp)
    80006874:	0141                	addi	sp,sp,16
    80006876:	8082                	ret

0000000080006878 <log2>:

int
log2(uint64 n) {
    80006878:	1141                	addi	sp,sp,-16
    8000687a:	e422                	sd	s0,8(sp)
    8000687c:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    8000687e:	4705                	li	a4,1
    80006880:	00a77b63          	bgeu	a4,a0,80006896 <log2+0x1e>
    80006884:	87aa                	mv	a5,a0
  int k = 0;
    80006886:	4501                	li	a0,0
    k++;
    80006888:	2505                	addiw	a0,a0,1
    n = n >> 1;
    8000688a:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    8000688c:	fef76ee3          	bltu	a4,a5,80006888 <log2+0x10>
  }
  return k;
}
    80006890:	6422                	ld	s0,8(sp)
    80006892:	0141                	addi	sp,sp,16
    80006894:	8082                	ret
  int k = 0;
    80006896:	4501                	li	a0,0
    80006898:	bfe5                	j	80006890 <log2+0x18>

000000008000689a <bd_init>:

// The buddy allocator manages the memory from base till end.
void
bd_init(void *base, void *end) {
    8000689a:	1141                	addi	sp,sp,-16
    8000689c:	e406                	sd	ra,8(sp)
    8000689e:	e022                	sd	s0,0(sp)
    800068a0:	0800                	addi	s0,sp,16

  initlock(&lock, "buddy");
    800068a2:	00001597          	auipc	a1,0x1
    800068a6:	04658593          	addi	a1,a1,70 # 800078e8 <userret+0x858>
    800068aa:	00022517          	auipc	a0,0x22
    800068ae:	75650513          	addi	a0,a0,1878 # 80029000 <lock>
    800068b2:	ffffa097          	auipc	ra,0xffffa
    800068b6:	116080e7          	jalr	278(ra) # 800009c8 <initlock>

  // YOUR CODE HERE TO INITIALIZE THE BUDDY ALLOCATOR.  FEEL FREE TO
  // BORROW CODE FROM bd_init() in the lecture notes.

  return;
}
    800068ba:	60a2                	ld	ra,8(sp)
    800068bc:	6402                	ld	s0,0(sp)
    800068be:	0141                	addi	sp,sp,16
    800068c0:	8082                	ret

00000000800068c2 <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    800068c2:	1141                	addi	sp,sp,-16
    800068c4:	e422                	sd	s0,8(sp)
    800068c6:	0800                	addi	s0,sp,16
  lst->next = lst;
    800068c8:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    800068ca:	e508                	sd	a0,8(a0)
}
    800068cc:	6422                	ld	s0,8(sp)
    800068ce:	0141                	addi	sp,sp,16
    800068d0:	8082                	ret

00000000800068d2 <lst_empty>:

int
lst_empty(struct list *lst) {
    800068d2:	1141                	addi	sp,sp,-16
    800068d4:	e422                	sd	s0,8(sp)
    800068d6:	0800                	addi	s0,sp,16
  return lst->next == lst;
    800068d8:	611c                	ld	a5,0(a0)
    800068da:	40a78533          	sub	a0,a5,a0
}
    800068de:	00153513          	seqz	a0,a0
    800068e2:	6422                	ld	s0,8(sp)
    800068e4:	0141                	addi	sp,sp,16
    800068e6:	8082                	ret

00000000800068e8 <lst_remove>:

void
lst_remove(struct list *e) {
    800068e8:	1141                	addi	sp,sp,-16
    800068ea:	e422                	sd	s0,8(sp)
    800068ec:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    800068ee:	6518                	ld	a4,8(a0)
    800068f0:	611c                	ld	a5,0(a0)
    800068f2:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    800068f4:	6518                	ld	a4,8(a0)
    800068f6:	e798                	sd	a4,8(a5)
}
    800068f8:	6422                	ld	s0,8(sp)
    800068fa:	0141                	addi	sp,sp,16
    800068fc:	8082                	ret

00000000800068fe <lst_pop>:

void*
lst_pop(struct list *lst) {
    800068fe:	1101                	addi	sp,sp,-32
    80006900:	ec06                	sd	ra,24(sp)
    80006902:	e822                	sd	s0,16(sp)
    80006904:	e426                	sd	s1,8(sp)
    80006906:	1000                	addi	s0,sp,32
  if(lst->next == lst)
    80006908:	6104                	ld	s1,0(a0)
    8000690a:	00a48d63          	beq	s1,a0,80006924 <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
  lst_remove(p);
    8000690e:	8526                	mv	a0,s1
    80006910:	00000097          	auipc	ra,0x0
    80006914:	fd8080e7          	jalr	-40(ra) # 800068e8 <lst_remove>
  return (void *)p;
}
    80006918:	8526                	mv	a0,s1
    8000691a:	60e2                	ld	ra,24(sp)
    8000691c:	6442                	ld	s0,16(sp)
    8000691e:	64a2                	ld	s1,8(sp)
    80006920:	6105                	addi	sp,sp,32
    80006922:	8082                	ret
    panic("lst_pop");
    80006924:	00001517          	auipc	a0,0x1
    80006928:	fcc50513          	addi	a0,a0,-52 # 800078f0 <userret+0x860>
    8000692c:	ffffa097          	auipc	ra,0xffffa
    80006930:	c1c080e7          	jalr	-996(ra) # 80000548 <panic>

0000000080006934 <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    80006934:	1141                	addi	sp,sp,-16
    80006936:	e422                	sd	s0,8(sp)
    80006938:	0800                	addi	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    8000693a:	611c                	ld	a5,0(a0)
    8000693c:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    8000693e:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    80006940:	611c                	ld	a5,0(a0)
    80006942:	e78c                	sd	a1,8(a5)
  lst->next = e;
    80006944:	e10c                	sd	a1,0(a0)
}
    80006946:	6422                	ld	s0,8(sp)
    80006948:	0141                	addi	sp,sp,16
    8000694a:	8082                	ret

000000008000694c <lst_print>:

void
lst_print(struct list *lst)
{
    8000694c:	7179                	addi	sp,sp,-48
    8000694e:	f406                	sd	ra,40(sp)
    80006950:	f022                	sd	s0,32(sp)
    80006952:	ec26                	sd	s1,24(sp)
    80006954:	e84a                	sd	s2,16(sp)
    80006956:	e44e                	sd	s3,8(sp)
    80006958:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    8000695a:	6104                	ld	s1,0(a0)
    8000695c:	02950063          	beq	a0,s1,8000697c <lst_print+0x30>
    80006960:	892a                	mv	s2,a0
    printf(" %p", p);
    80006962:	00001997          	auipc	s3,0x1
    80006966:	f9698993          	addi	s3,s3,-106 # 800078f8 <userret+0x868>
    8000696a:	85a6                	mv	a1,s1
    8000696c:	854e                	mv	a0,s3
    8000696e:	ffffa097          	auipc	ra,0xffffa
    80006972:	c24080e7          	jalr	-988(ra) # 80000592 <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80006976:	6084                	ld	s1,0(s1)
    80006978:	fe9919e3          	bne	s2,s1,8000696a <lst_print+0x1e>
  }
  printf("\n");
    8000697c:	00001517          	auipc	a0,0x1
    80006980:	83450513          	addi	a0,a0,-1996 # 800071b0 <userret+0x120>
    80006984:	ffffa097          	auipc	ra,0xffffa
    80006988:	c0e080e7          	jalr	-1010(ra) # 80000592 <printf>
}
    8000698c:	70a2                	ld	ra,40(sp)
    8000698e:	7402                	ld	s0,32(sp)
    80006990:	64e2                	ld	s1,24(sp)
    80006992:	6942                	ld	s2,16(sp)
    80006994:	69a2                	ld	s3,8(sp)
    80006996:	6145                	addi	sp,sp,48
    80006998:	8082                	ret
	...

0000000080007000 <trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
