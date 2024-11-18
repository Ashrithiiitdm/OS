
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 67 11 80       	mov    $0x801167d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
80100049:	83 ec 0c             	sub    $0xc,%esp
8010004c:	68 a0 78 10 80       	push   $0x801078a0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 d5 49 00 00       	call   80104a30 <initlock>
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
80100092:	68 a7 78 10 80       	push   $0x801078a7
80100097:	50                   	push   %eax
80100098:	e8 63 48 00 00       	call   80104900 <initsleeplock>
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 17 4b 00 00       	call   80104c00 <acquire>
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 39 4a 00 00       	call   80104ba0 <release>
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 47 00 00       	call   80104940 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 78 10 80       	push   $0x801078ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 1d 48 00 00       	call   801049e0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 78 10 80       	push   $0x801078bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 47 00 00       	call   801049e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 47 00 00       	call   801049a0 <releasesleep>
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 e0 49 00 00       	call   80104c00 <acquire>
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100223:	83 c4 10             	add    $0x10,%esp
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
8010026c:	e9 2f 49 00 00       	jmp    80104ba0 <release>
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 78 10 80       	push   $0x801078c6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028f:	ff 75 08             	push   0x8(%ebp)
80100292:	89 df                	mov    %ebx,%edi
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 5b 49 00 00       	call   80104c00 <acquire>
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 be 3d 00 00       	call   80104090 <sleep>
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
801002e2:	e8 a9 36 00 00       	call   80103990 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 a5 48 00 00       	call   80104ba0 <release>
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
80100304:	83 c4 10             	add    $0x10,%esp
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
80100332:	83 c6 01             	add    $0x1,%esi
80100335:	83 eb 01             	sub    $0x1,%ebx
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 4f 48 00 00       	call   80104ba0 <release>
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100362:	29 d8                	sub    %ebx,%eax
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
80100388:	fa                   	cli    
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 78 10 80       	push   $0x801078cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
801003b5:	c7 04 24 ad 7e 10 80 	movl   $0x80107ead,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 46 00 00       	call   80104a50 <getcallerpcs>
801003cd:	83 c4 10             	add    $0x10,%esp
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
801003d5:	83 c3 04             	add    $0x4,%ebx
801003d8:	68 e1 78 10 80       	push   $0x801078e1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 5f 00 00       	call   801063b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
80100437:	0f b6 c8             	movzbl %al,%ecx
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
80100487:	89 f0                	mov    %esi,%eax
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
80100493:	0f b6 fc             	movzbl %ah,%edi
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 a6 5e 00 00       	call   801063b0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 5e 00 00       	call   801063b0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 5e 00 00       	call   801063b0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100530:	83 ec 04             	sub    $0x4,%esp
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 0a 48 00 00       	call   80104d60 <memmove>
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 55 47 00 00       	call   80104cc0 <memset>
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 78 10 80       	push   $0x801078e5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
80100599:	ff 75 08             	push   0x8(%ebp)
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 50 46 00 00       	call   80104c00 <acquire>
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801005c3:	0f b6 03             	movzbl (%ebx),%eax
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
801005ca:	fa                   	cli    
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 b7 45 00 00       	call   80104ba0 <release>
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 10 79 10 80 	movzbl -0x7fef86f0(%edx),%edx
8010063d:	89 c1                	mov    %eax,%ecx
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100654:	89 de                	mov    %ebx,%esi
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
801006c4:	0f b6 06             	movzbl (%esi),%eax
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
80100787:	83 c3 01             	add    $0x1,%ebx
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 13 44 00 00       	call   80104c00 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
80100838:	bf f8 78 10 80       	mov    $0x801078f8,%edi
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 40 43 00 00       	call   80104ba0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 78 10 80       	push   $0x801078ff
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
80100885:	31 f6                	xor    %esi,%esi
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 68 43 00 00       	call   80104c00 <acquire>
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 cb 41 00 00       	call   80104ba0 <release>
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
80100a0e:	e9 1d 38 00 00       	jmp    80104230 <procdump>
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a37:	83 ec 0c             	sub    $0xc,%esp
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 07 37 00 00       	call   80104150 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
80100a66:	68 08 79 10 80       	push   $0x80107908
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 bb 3f 00 00       	call   80104a30 <initlock>
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
80100abc:	e8 cf 2e 00 00       	call   80103990 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
80100b34:	e8 07 6a 00 00       	call   80107540 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 b8 67 00 00       	call   80107360 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 92 66 00 00       	call   80107270 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 a0 68 00 00       	call   801074c0 <freevm>
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 f9 66 00 00       	call   80107360 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c7d:	89 f3                	mov    %esi,%ebx
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
80100c81:	31 ff                	xor    %edi,%edi
80100c83:	e8 58 69 00 00       	call   801075e0 <clearpteu>
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
80100cba:	83 c7 01             	add    $0x1,%edi
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 e8 41 00 00       	call   80104ec0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cde:	83 eb 01             	sub    $0x1,%ebx
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
80100ce7:	e8 d4 41 00 00       	call   80104ec0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 6a 00 00       	call   801077b0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 aa 67 00 00       	call   801074c0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
80100d3d:	29 c1                	sub    %eax,%ecx
80100d3f:	83 c0 0c             	add    $0xc,%eax
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
80100d48:	29 c3                	sub    %eax,%ebx
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
80100d63:	e8 48 6a 00 00       	call   801077b0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
80100d85:	0f b6 01             	movzbl (%ecx),%eax
80100d88:	0f 44 d1             	cmove  %ecx,%edx
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 da 40 00 00       	call   80104e80 <safestrcpy>
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
80100db1:	89 30                	mov    %esi,(%eax)
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 0e 63 00 00       	call   801070e0 <switchuvm>
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 e6 66 00 00       	call   801074c0 <freevm>
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 21 79 10 80       	push   $0x80107921
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
80100e16:	68 2d 79 10 80       	push   $0x8010792d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 0b 3c 00 00       	call   80104a30 <initlock>
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
80100e39:	83 ec 10             	sub    $0x10,%esp
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 ba 3d 00 00       	call   80104c00 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
80100e62:	83 ec 0c             	sub    $0xc,%esp
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 2a 3d 00 00       	call   80104ba0 <release>
80100e76:	89 d8                	mov    %ebx,%eax
80100e78:	83 c4 10             	add    $0x10,%esp
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
80100e80:	83 ec 0c             	sub    $0xc,%esp
80100e83:	31 db                	xor    %ebx,%ebx
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 11 3d 00 00       	call   80104ba0 <release>
80100e8f:	89 d8                	mov    %ebx,%eax
80100e91:	83 c4 10             	add    $0x10,%esp
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 4c 3d 00 00       	call   80104c00 <acquire>
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
80100ebe:	83 c0 01             	add    $0x1,%eax
80100ec1:	83 ec 0c             	sub    $0xc,%esp
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 cf 3c 00 00       	call   80104ba0 <release>
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 34 79 10 80       	push   $0x80107934
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 fa 3c 00 00       	call   80104c00 <acquire>
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f20:	83 ec 0c             	sub    $0xc,%esp
80100f23:	8b 3b                	mov    (%ebx),%edi
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100f3c:	e8 5f 3c 00 00       	call   80104ba0 <release>
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
80100f6e:	e9 2d 3c 00 00       	jmp    80104ba0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
80100f88:	83 c4 10             	add    $0x10,%esp
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 3c 79 10 80       	push   $0x8010793c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
80101065:	01 43 14             	add    %eax,0x14(%ebx)
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 46 79 10 80       	push   $0x80107946
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010e9:	31 f6                	xor    %esi,%esi
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
80101118:	01 fe                	add    %edi,%esi
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 4f 79 10 80       	push   $0x8010794f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 55 79 10 80       	push   $0x80107955
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
801011de:	89 d9                	mov    %ebx,%ecx
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
801011e6:	89 c6                	mov    %eax,%esi
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f6:	d3 e0                	shl    %cl,%eax
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
80101201:	f7 d0                	not    %eax
80101203:	83 ec 0c             	sub    $0xc,%esp
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 5f 79 10 80       	push   $0x8010795f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 72 79 10 80       	push   $0x80107972
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801012f3:	83 ec 0c             	sub    $0xc,%esp
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
80101315:	83 c4 0c             	add    $0xc,%esp
80101318:	89 c3                	mov    %eax,%ebx
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 96 39 00 00       	call   80104cc0 <memset>
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
80101357:	31 f6                	xor    %esi,%esi
80101359:	53                   	push   %ebx
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 91 38 00 00       	call   80104c00 <acquire>
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
801013bc:	83 ec 0c             	sub    $0xc,%esp
801013bf:	89 3e                	mov    %edi,(%esi)
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 c4 37 00 00       	call   80104ba0 <release>
801013dc:	83 c4 10             	add    $0x10,%esp
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
801013f5:	83 ec 0c             	sub    $0xc,%esp
801013f8:	83 c0 01             	add    $0x1,%eax
801013fb:	89 de                	mov    %ebx,%esi
801013fd:	68 60 09 11 80       	push   $0x80110960
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
80101405:	e8 96 37 00 00       	call   80104ba0 <release>
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 88 79 10 80       	push   $0x80107988
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
8010148c:	89 c2                	mov    %eax,%edx
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 98 79 10 80       	push   $0x80107998
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
80101535:	83 c4 0c             	add    $0xc,%esp
80101538:	89 c3                	mov    %eax,%ebx
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 1a 38 00 00       	call   80104d60 <memmove>
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
8010156c:	68 ab 79 10 80       	push   $0x801079ab
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 b5 34 00 00       	call   80104a30 <initlock>
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 b2 79 10 80       	push   $0x801079b2
80101588:	53                   	push   %ebx
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010158f:	e8 6c 33 00 00       	call   80104900 <initsleeplock>
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	83 c4 0c             	add    $0xc,%esp
801015af:	89 c3                	mov    %eax,%ebx
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 9f 37 00 00       	call   80104d60 <memmove>
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 18 7a 10 80       	push   $0x80107a18
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
80101640:	83 ec 0c             	sub    $0xc,%esp
80101643:	83 c7 01             	add    $0x1,%edi
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	89 c3                	mov    %eax,%ebx
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 2d 36 00 00       	call   80104cc0 <memset>
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
801016ad:	83 c4 10             	add    $0x10,%esp
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b3:	89 fa                	mov    %edi,%edx
801016b5:	5b                   	pop    %ebx
801016b6:	89 f0                	mov    %esi,%eax
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 b8 79 10 80       	push   $0x801079b8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
801016db:	83 c3 5c             	add    $0x5c,%ebx
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
801016f7:	83 c4 0c             	add    $0xc,%esp
801016fa:	89 c6                	mov    %eax,%esi
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101709:	66 89 10             	mov    %dx,(%eax)
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
80101710:	83 c0 0c             	add    $0xc,%eax
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 2a 36 00 00       	call   80104d60 <memmove>
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 9c 34 00 00       	call   80104c00 <acquire>
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 2c 34 00 00       	call   80104ba0 <release>
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 99 31 00 00       	call   80104940 <acquiresleep>
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
801017d7:	83 c4 0c             	add    $0xc,%esp
801017da:	89 c6                	mov    %eax,%esi
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
801017e9:	0f b7 10             	movzwl (%eax),%edx
801017ec:	83 c0 0c             	add    $0xc,%eax
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 43 35 00 00       	call   80104d60 <memmove>
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 d0 79 10 80       	push   $0x801079d0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ca 79 10 80       	push   $0x801079ca
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 68 31 00 00       	call   801049e0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
8010188f:	e9 0c 31 00 00       	jmp    801049a0 <releasesleep>
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 df 79 10 80       	push   $0x801079df
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 7b 30 00 00       	call   80104940 <acquiresleep>
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 c1 30 00 00       	call   801049a0 <releasesleep>
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 15 33 00 00       	call   80104c00 <acquire>
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
80101900:	e9 9b 32 00 00       	jmp    80104ba0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 eb 32 00 00       	call   80104c00 <acquire>
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 7c 32 00 00       	call   80104ba0 <release>
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
8010196d:	83 ec 0c             	sub    $0xc,%esp
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 b8 2f 00 00       	call   801049e0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 61 2f 00 00       	call   801049a0 <releasesleep>
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 df 79 10 80       	push   $0x801079df
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b12:	89 c2                	mov    %eax,%edx
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b20:	29 c1                	sub    %eax,%ecx
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 24 32 00 00       	call   80104d60 <memmove>
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
80101b7f:	ff e0                	jmp    *%eax
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
80101c15:	89 c7                	mov    %eax,%edi
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
80101c2d:	01 de                	add    %ebx,%esi
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 28 31 00 00       	call   80104d60 <memmove>
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c9b:	83 ec 0c             	sub    $0xc,%esp
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 fd 30 00 00       	call   80104dd0 <strncmp>
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 9e 30 00 00       	call   80104dd0 <strncmp>
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d44:	31 c0                	xor    %eax,%eax
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 f9 79 10 80       	push   $0x801079f9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 e7 79 10 80       	push   $0x801079e7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
80101daa:	e8 e1 1b 00 00       	call   80103990 <myproc>
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 41 2e 00 00       	call   80104c00 <acquire>
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 d1 2d 00 00       	call   80104ba0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dd8:	83 c3 01             	add    $0x1,%ebx
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80101e04:	83 c7 01             	add    $0x1,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
80101e22:	89 fb                	mov    %edi,%ebx
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 34 2f 00 00       	call   80104d60 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e38:	83 c3 01             	add    $0x1,%ebx
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 4f 2b 00 00       	call   801049e0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 ed 2a 00 00       	call   801049a0 <releasesleep>
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
80101ed6:	89 fb                	mov    %edi,%ebx
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 80 2e 00 00       	call   80104d60 <memmove>
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 b0 2a 00 00       	call   801049e0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 51 2a 00 00       	call   801049a0 <releasesleep>
80101f4f:	89 34 24             	mov    %esi,(%esp)
80101f52:	31 f6                	xor    %esi,%esi
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 6e 2a 00 00       	call   801049e0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 4b 2a 00 00       	call   801049e0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 f4 29 00 00       	call   801049a0 <releasesleep>
80101fac:	83 c4 10             	add    $0x10,%esp
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
80101fbd:	31 f6                	xor    %esi,%esi
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 df 79 10 80       	push   $0x801079df
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 de 2d 00 00       	call   80104e20 <strncpy>
80102042:	6a 10                	push   $0x10
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
8010205b:	31 c0                	xor    %eax,%eax
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 08 7a 10 80       	push   $0x80107a08
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 3e 81 10 80       	push   $0x8010813e
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:
801020a0:	55                   	push   %ebp
801020a1:	31 d2                	xor    %edx,%edx
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:
801020c0:	55                   	push   %ebp
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
801020c6:	89 e5                	mov    %esp,%ebp
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
801020ce:	5d                   	pop    %ebp
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 74 7a 10 80       	push   $0x80107a74
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 6b 7a 10 80       	push   $0x80107a6b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
801021c6:	68 86 7a 10 80       	push   $0x80107a86
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 5b 28 00 00       	call   80104a30 <initlock>
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
801021e7:	83 c4 10             	add    $0x10,%esp
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 ad 29 00 00       	call   80104c00 <acquire>
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010229f:	8b 33                	mov    (%ebx),%esi
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
801022ac:	53                   	push   %ebx
801022ad:	e8 9e 1e 00 00       	call   80104150 <wakeup>
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 d0 28 00 00       	call   80104ba0 <release>
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 ed 26 00 00       	call   801049e0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 d3 28 00 00       	call   80104c00 <acquire>
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
8010234c:	89 1a                	mov    %ebx,(%edx)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 22 1d 00 00       	call   80104090 <sleep>
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
80102386:	e9 15 28 00 00       	jmp    80104ba0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 b5 7a 10 80       	push   $0x80107ab5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 a0 7a 10 80       	push   $0x80107aa0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 8a 7a 10 80       	push   $0x80107a8a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
801023d0:	55                   	push   %ebp
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
80102410:	c1 e8 18             	shr    $0x18,%eax
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 d4 7a 10 80       	push   $0x80107ad4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102440:	89 11                	mov    %edx,(%ecx)
80102442:	89 c3                	mov    %eax,%ebx
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010244a:	83 c0 01             	add    $0x1,%eax
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
80102459:	83 c2 02             	add    $0x2,%edx
8010245c:	89 19                	mov    %ebx,(%ecx)
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:
80102480:	55                   	push   %ebp
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
80102493:	89 01                	mov    %eax,(%ecx)
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010249b:	83 c0 01             	add    $0x1,%eax
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801024a4:	89 01                	mov    %eax,(%ecx)
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
801024ab:	c1 e2 18             	shl    $0x18,%edx
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 67 11 80    	cmp    $0x801167d0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 c9 27 00 00       	call   80104cc0 <memset>
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 d3 26 00 00       	call   80104c00 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
80102543:	e9 58 26 00 00       	jmp    80104ba0 <release>
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 06 7b 10 80       	push   $0x80107b06
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 0c 7b 10 80       	push   $0x80107b0c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 06 24 00 00       	call   80104a30 <initlock>
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 48 25 00 00       	call   80104c00 <acquire>
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 ba 24 00 00       	call   80104ba0 <release>
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026e9:	83 c4 10             	add    $0x10,%esp
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
8010270e:	0f b6 c8             	movzbl %al,%ecx
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
80102722:	83 c8 80             	or     $0xffffff80,%eax
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
80102728:	0f b6 c8             	movzbl %al,%ecx
8010272b:	0f b6 91 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%edx
80102732:	0f b6 81 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%eax
80102739:	09 da                	or     %ebx,%edx
8010273b:	31 c2                	xor    %eax,%edx
8010273d:	89 d0                	mov    %edx,%eax
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
80102745:	83 e0 03             	and    $0x3,%eax
80102748:	83 e2 08             	and    $0x8,%edx
8010274b:	8b 04 85 20 7b 10 80 	mov    -0x7fef84e0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
80102760:	83 e8 20             	sub    $0x20,%eax
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
80102770:	83 cb 40             	or     $0x40,%ebx
80102773:	31 c0                	xor    %eax,%eax
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
80102788:	0f b6 81 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
801027a1:	31 c0                	xor    %eax,%eax
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
80102807:	8b 50 20             	mov    0x20(%eax),%edx
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
80102814:	8b 50 20             	mov    0x20(%eax),%edx
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
80102821:	8b 50 20             	mov    0x20(%eax),%edx
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
80102848:	8b 50 20             	mov    0x20(%eax),%edx
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
80102863:	8b 50 20             	mov    0x20(%eax),%edx
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
80102870:	8b 50 20             	mov    0x20(%eax),%edx
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
80102897:	8b 50 20             	mov    0x20(%eax),%edx
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
801028da:	8b 50 20             	mov    0x20(%eax),%edx
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
80102900:	31 c0                	xor    %eax,%eax
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
80102923:	8b 40 20             	mov    0x20(%eax),%eax
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:
80102940:	55                   	push   %ebp
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
80102960:	31 c0                	xor    %eax,%eax
80102962:	c1 e3 18             	shl    $0x18,%ebx
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
8010296b:	89 c8                	mov    %ecx,%eax
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
80102970:	89 da                	mov    %ebx,%edx
80102972:	c1 e8 04             	shr    $0x4,%eax
80102975:	80 cd 06             	or     $0x6,%ch
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801029be:	8b 50 20             	mov    0x20(%eax),%edx
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
801029ea:	83 e0 04             	and    $0x4,%eax
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
80102ae7:	83 ec 04             	sub    $0x4,%esp
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 14 22 00 00       	call   80104d10 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
80102bd2:	31 ff                	xor    %edi,%edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
80102c0a:	83 c7 01             	add    $0x1,%edi
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
80102c12:	83 c4 0c             	add    $0xc,%esp
80102c15:	89 c3                	mov    %eax,%ebx
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 37 21 00 00       	call   80104d60 <memmove>
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
80102c78:	83 c4 10             	add    $0x10,%esp
80102c7b:	89 c3                	mov    %eax,%ebx
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cca:	68 40 7d 10 80       	push   $0x80107d40
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 57 1d 00 00       	call   80104a30 <initlock>
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ce8:	59                   	pop    %ecx
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
80102d05:	83 c4 10             	add    $0x10,%esp
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 90 1e 00 00       	call   80104c00 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 06 13 00 00       	call   80104090 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
80102daf:	83 ec 0c             	sub    $0xc,%esp
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 df 1d 00 00       	call   80104ba0 <release>
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 1d 1e 00 00       	call   80104c00 <acquire>
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 7f 1d 00 00       	call   80104ba0 <release>
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 c5 1d 00 00       	call   80104c00 <acquire>
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
80102e4c:	e8 ff 12 00 00       	call   80104150 <wakeup>
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 43 1d 00 00       	call   80104ba0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
80102e9a:	83 c3 01             	add    $0x1,%ebx
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
80102ea2:	83 c4 0c             	add    $0xc,%esp
80102ea5:	89 c7                	mov    %eax,%edi
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 a7 1e 00 00       	call   80104d60 <memmove>
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 43 12 00 00       	call   80104150 <wakeup>
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 87 1c 00 00       	call   80104ba0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 44 7d 10 80       	push   $0x80107d44
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 85 1c 00 00       	call   80104c00 <acquire>
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
80102fb4:	c9                   	leave  
80102fb5:	e9 e6 1b 00 00       	jmp    80104ba0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 53 7d 10 80       	push   $0x80107d53
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 69 7d 10 80       	push   $0x80107d69
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
80103007:	e8 64 09 00 00       	call   80103970 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 5d 09 00 00       	call   80103970 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 84 7d 10 80       	push   $0x80107d84
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
80103022:	e8 99 2f 00 00       	call   80105fc0 <idtinit>
80103027:	e8 e4 08 00 00       	call   80103910 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
8010303a:	e8 11 0c 00 00       	call   80103c50 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
80103046:	e8 85 40 00 00       	call   801070d0 <switchkvm>
8010304b:	e8 f0 3f 00 00       	call   80107040 <seginit>
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 d0 67 11 80       	push   $0x801167d0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
80103081:	e8 3a 45 00 00       	call   801075c0 <kvmalloc>
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
80103090:	e8 ab 3f 00 00       	call   80107040 <seginit>
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
801030a4:	e8 27 32 00 00       	call   801062d0 <uartinit>
801030a9:	e8 42 08 00 00       	call   801038f0 <pinit>
801030ae:	e8 8d 2e 00 00       	call   80105f40 <tvinit>
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 87 1c 00 00       	call   80104d60 <memmove>
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
80103119:	e8 f2 07 00 00       	call   80103910 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
80103127:	83 ec 08             	sub    $0x8,%esp
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
80103182:	e8 39 08 00 00       	call   801039c0 <userinit>
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
8010319b:	53                   	push   %ebx
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
8010319f:	83 ec 0c             	sub    $0xc,%esp
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 98 7d 10 80       	push   $0x80107d98
801031c3:	56                   	push   %esi
801031c4:	e8 47 1b 00 00       	call   80104d10 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
801031db:	83 c2 01             	add    $0x1,%edx
801031de:	01 c8                	add    %ecx,%eax
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	31 f6                	xor    %esi,%esi
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
8010326b:	83 ec 04             	sub    $0x4,%esp
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103274:	6a 04                	push   $0x4
80103276:	68 9d 7d 10 80       	push   $0x80107d9d
8010327b:	50                   	push   %eax
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010327f:	e8 8c 1a 00 00       	call   80104d10 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032bf:	83 c0 01             	add    $0x1,%eax
801032c2:	01 ca                	add    %ecx,%edx
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
8010330a:	83 c0 08             	add    $0x8,%eax
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
80103333:	83 c8 01             	or     $0x1,%eax
80103336:	ee                   	out    %al,(%dx)
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103354:	83 c0 08             	add    $0x8,%eax
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
80103384:	83 c0 14             	add    $0x14,%eax
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 a2 7d 10 80       	push   $0x80107da2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 98 7d 10 80       	push   $0x80107d98
801033c7:	53                   	push   %ebx
801033c8:	e8 43 19 00 00       	call   80104d10 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
801033e3:	83 c2 01             	add    $0x1,%edx
801033e6:	01 c8                	add    %ecx,%eax
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 bc 7d 10 80       	push   $0x80107dbc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
80103482:	83 ec 08             	sub    $0x8,%esp
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
801034a3:	68 db 7d 10 80       	push   $0x80107ddb
801034a8:	50                   	push   %eax
801034a9:	e8 82 15 00 00       	call   80104a30 <initlock>
801034ae:	8b 03                	mov    (%ebx),%eax
801034b0:	83 c4 10             	add    $0x10,%esp
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e6:	31 c0                	xor    %eax,%eax
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 bc 16 00 00       	call   80104c00 <acquire>
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
8010355e:	50                   	push   %eax
8010355f:	e8 ec 0b 00 00       	call   80104150 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
80103584:	e9 17 16 00 00       	jmp    80104ba0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 07 16 00 00       	call   80104ba0 <release>
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
801035c3:	50                   	push   %eax
801035c4:	e8 87 0b 00 00       	call   80104150 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035dc:	53                   	push   %ebx
801035dd:	e8 1e 16 00 00       	call   80104c00 <acquire>
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103628:	e8 63 03 00 00       	call   80103990 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 13 0b 00 00       	call   80104150 <wakeup>
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 4a 0a 00 00       	call   80104090 <sleep>
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 2f 15 00 00       	call   80104ba0 <release>
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 91 0a 00 00       	call   80104150 <wakeup>
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 d9 14 00 00       	call   80104ba0 <release>
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 15 15 00 00       	call   80104c00 <acquire>
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
80103700:	e8 8b 02 00 00       	call   80103990 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 76 09 00 00       	call   80104090 <sleep>
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 d5 09 00 00       	call   80104150 <wakeup>
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 1d 14 00 00       	call   80104ba0 <release>
80103783:	83 c4 10             	add    $0x10,%esp
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103798:	56                   	push   %esi
80103799:	e8 02 14 00 00       	call   80104ba0 <release>
8010379e:	83 c4 10             	add    $0x10,%esp
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
    char *sp;

    acquire(&ptable.lock);

    // Loop to find an UNUSED process slot.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801037b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
801037bc:	68 20 2d 11 80       	push   $0x80112d20
801037c1:	e8 3a 14 00 00       	call   80104c00 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801037d0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801037d6:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801037dc:	0f 84 8e 00 00 00    	je     80103870 <allocproc+0xc0>
        if (p->state == UNUSED) {
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    p->priority = 10; //this is the default priority for every process 

    release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
            p->waiting_for = -1;
801037f1:	c7 43 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%ebx)
    p->state = EMBRYO;
801037f8:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
801037ff:	89 43 10             	mov    %eax,0x10(%ebx)
80103802:	8d 50 01             	lea    0x1(%eax),%edx
    p->priority = 10; //this is the default priority for every process 
80103805:	c7 83 84 00 00 00 0a 	movl   $0xa,0x84(%ebx)
8010380c:	00 00 00 
    release(&ptable.lock);
8010380f:	68 20 2d 11 80       	push   $0x80112d20
    p->pid = nextpid++;
80103814:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
8010381a:	e8 81 13 00 00       	call   80104ba0 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
8010381f:	e8 5c ee ff ff       	call   80102680 <kalloc>
80103824:	83 c4 10             	add    $0x10,%esp
80103827:	89 43 08             	mov    %eax,0x8(%ebx)
8010382a:	85 c0                	test   %eax,%eax
8010382c:	74 5b                	je     80103889 <allocproc+0xd9>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
8010382e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
80103834:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103837:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
8010383c:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
8010383f:	c7 40 14 2d 5f 10 80 	movl   $0x80105f2d,0x14(%eax)
    p->context = (struct context*)sp;
80103846:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103849:	6a 14                	push   $0x14
8010384b:	6a 00                	push   $0x0
8010384d:	50                   	push   %eax
8010384e:	e8 6d 14 00 00       	call   80104cc0 <memset>
    p->context->eip = (uint)forkret;
80103853:	8b 43 1c             	mov    0x1c(%ebx),%eax

    return p;
80103856:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103859:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
80103860:	89 d8                	mov    %ebx,%eax
80103862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103865:	c9                   	leave  
80103866:	c3                   	ret    
80103867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103873:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103875:	68 20 2d 11 80       	push   $0x80112d20
8010387a:	e8 21 13 00 00       	call   80104ba0 <release>
}
8010387f:	89 d8                	mov    %ebx,%eax
    return 0;
80103881:	83 c4 10             	add    $0x10,%esp
}
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
        p->state = UNUSED;
80103889:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103890:	31 db                	xor    %ebx,%ebx
}
80103892:	89 d8                	mov    %ebx,%eax
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038a6:	68 20 2d 11 80       	push   $0x80112d20
801038ab:	e8 f0 12 00 00       	call   80104ba0 <release>

  if (first) {
801038b0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	75 04                	jne    801038c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038bc:	c9                   	leave  
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax
    first = 0;
801038c0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038c7:	00 00 00 
    iinit(ROOTDEV);
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	6a 01                	push   $0x1
801038cf:	e8 8c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038db:	e8 e0 f3 ff ff       	call   80102cc0 <initlog>
}
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    
801038e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 e0 7d 10 80       	push   $0x80107de0
801038fb:	68 20 2d 11 80       	push   $0x80112d20
80103900:	e8 2b 11 00 00       	call   80104a30 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf  
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 46                	jne    80103962 <mycpu+0x52>
  apicid = lapicid();
8010391c:	e8 cf ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 2a                	jle    80103955 <mycpu+0x45>
8010392b:	31 d2                	xor    %edx,%edx
8010392d:	eb 08                	jmp    80103937 <mycpu+0x27>
8010392f:	90                   	nop
80103930:	83 c2 01             	add    $0x1,%edx
80103933:	39 f2                	cmp    %esi,%edx
80103935:	74 1e                	je     80103955 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103937:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010393d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103944:	39 c3                	cmp    %eax,%ebx
80103946:	75 e8                	jne    80103930 <mycpu+0x20>
}
80103948:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010394b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103951:	5b                   	pop    %ebx
80103952:	5e                   	pop    %esi
80103953:	5d                   	pop    %ebp
80103954:	c3                   	ret    
  panic("unknown apicid\n");
80103955:	83 ec 0c             	sub    $0xc,%esp
80103958:	68 e7 7d 10 80       	push   $0x80107de7
8010395d:	e8 1e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 20 7f 10 80       	push   $0x80107f20
8010396a:	e8 11 ca ff ff       	call   80100380 <panic>
8010396f:	90                   	nop

80103970 <cpuid>:
cpuid() {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103976:	e8 95 ff ff ff       	call   80103910 <mycpu>
}
8010397b:	c9                   	leave  
  return mycpu()-cpus;
8010397c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103981:	c1 f8 04             	sar    $0x4,%eax
80103984:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010398a:	c3                   	ret    
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <myproc>:
myproc(void) {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103997:	e8 14 11 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
8010399c:	e8 6f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a7:	e8 54 11 00 00       	call   80104b00 <popcli>
}
801039ac:	89 d8                	mov    %ebx,%eax
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave  
801039b2:	c3                   	ret    
801039b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <userinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039c7:	e8 e4 fd ff ff       	call   801037b0 <allocproc>
801039cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ce:	a3 54 4f 11 80       	mov    %eax,0x80114f54
  if((p->pgdir = setupkvm()) == 0)
801039d3:	e8 68 3b 00 00       	call   80107540 <setupkvm>
801039d8:	89 43 04             	mov    %eax,0x4(%ebx)
801039db:	85 c0                	test   %eax,%eax
801039dd:	0f 84 bd 00 00 00    	je     80103aa0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e3:	83 ec 04             	sub    $0x4,%esp
801039e6:	68 2c 00 00 00       	push   $0x2c
801039eb:	68 60 b4 10 80       	push   $0x8010b460
801039f0:	50                   	push   %eax
801039f1:	e8 fa 37 00 00       	call   801071f0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ff:	6a 4c                	push   $0x4c
80103a01:	6a 00                	push   $0x0
80103a03:	ff 73 18             	push   0x18(%ebx)
80103a06:	e8 b5 12 00 00       	call   80104cc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a31:	8b 43 18             	mov    0x18(%ebx),%eax
80103a34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a50:	8b 43 18             	mov    0x18(%ebx),%eax
80103a53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a5d:	6a 10                	push   $0x10
80103a5f:	68 10 7e 10 80       	push   $0x80107e10
80103a64:	50                   	push   %eax
80103a65:	e8 16 14 00 00       	call   80104e80 <safestrcpy>
  p->cwd = namei("/");
80103a6a:	c7 04 24 19 7e 10 80 	movl   $0x80107e19,(%esp)
80103a71:	e8 2a e6 ff ff       	call   801020a0 <namei>
80103a76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a80:	e8 7b 11 00 00       	call   80104c00 <acquire>
  p->state = RUNNABLE;
80103a85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a93:	e8 08 11 00 00       	call   80104ba0 <release>
}
80103a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 f7 7d 10 80       	push   $0x80107df7
80103aa8:	e8 d3 c8 ff ff       	call   80100380 <panic>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <growproc>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ab8:	e8 f3 0f 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103abd:	e8 4e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac8:	e8 33 10 00 00       	call   80104b00 <popcli>
  sz = curproc->sz;
80103acd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103acf:	85 f6                	test   %esi,%esi
80103ad1:	7f 1d                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad3:	75 3b                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ad8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ada:	53                   	push   %ebx
80103adb:	e8 00 36 00 00       	call   801070e0 <switchuvm>
  return 0;
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	31 c0                	xor    %eax,%eax
}
80103ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 61 38 00 00       	call   80107360 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 cf                	jne    80103ad5 <growproc+0x25>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb d8                	jmp    80103ae5 <growproc+0x35>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 71 39 00 00       	call   80107490 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 af                	jne    80103ad5 <growproc+0x25>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b39:	e8 72 0f 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103b3e:	e8 cd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b49:	e8 b2 0f 00 00       	call   80104b00 <popcli>
  if((np = allocproc()) == 0){
80103b4e:	e8 5d fc ff ff       	call   801037b0 <allocproc>
80103b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b56:	85 c0                	test   %eax,%eax
80103b58:	0f 84 b7 00 00 00    	je     80103c15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	ff 33                	push   (%ebx)
80103b63:	89 c7                	mov    %eax,%edi
80103b65:	ff 73 04             	push   0x4(%ebx)
80103b68:	e8 c3 3a 00 00       	call   80107630 <copyuvm>
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	89 47 04             	mov    %eax,0x4(%edi)
80103b73:	85 c0                	test   %eax,%eax
80103b75:	0f 84 a1 00 00 00    	je     80103c1c <fork+0xec>
  np->sz = curproc->sz;
80103b7b:	8b 03                	mov    (%ebx),%eax
80103b7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b85:	89 c8                	mov    %ecx,%eax
80103b87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b96:	8b 40 18             	mov    0x18(%eax),%eax
80103b99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 ef d2 ff ff       	call   80100ea0 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 7f db ff ff       	call   80101750 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 9a 12 00 00       	call   80104e80 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf0:	e8 0b 10 00 00       	call   80104c00 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c03:	e8 98 0f 00 00       	call   80104ba0 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
    return -1;
80103c15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c1a:	eb ef                	jmp    80103c0b <fork+0xdb>
    kfree(np->kstack);
80103c1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	ff 73 08             	push   0x8(%ebx)
80103c25:	e8 96 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c40:	eb c9                	jmp    80103c0b <fork+0xdb>
80103c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c59:	e8 b2 fc ff ff       	call   80103910 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103c6a:	8d 70 04             	lea    0x4(%eax),%esi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    high_p = 0;
80103c74:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103c76:	68 20 2d 11 80       	push   $0x80112d20
80103c7b:	e8 80 0f 00 00       	call   80104c00 <acquire>
80103c80:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c83:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c88:	eb 21                	jmp    80103cab <scheduler+0x5b>
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(high_p == 0 || p->priority > high_p->priority){
80103c90:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
80103c96:	39 90 84 00 00 00    	cmp    %edx,0x84(%eax)
80103c9c:	0f 4f f8             	cmovg  %eax,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c9f:	05 88 00 00 00       	add    $0x88,%eax
80103ca4:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103ca9:	74 1d                	je     80103cc8 <scheduler+0x78>
      if(p->state != RUNNABLE)
80103cab:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103caf:	75 ee                	jne    80103c9f <scheduler+0x4f>
      if(high_p == 0 || p->priority > high_p->priority){
80103cb1:	85 ff                	test   %edi,%edi
80103cb3:	75 db                	jne    80103c90 <scheduler+0x40>
80103cb5:	89 c7                	mov    %eax,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb7:	05 88 00 00 00       	add    $0x88,%eax
80103cbc:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103cc1:	75 e8                	jne    80103cab <scheduler+0x5b>
80103cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc7:	90                   	nop
    if(high_p!=0){
80103cc8:	85 ff                	test   %edi,%edi
80103cca:	74 33                	je     80103cff <scheduler+0xaf>
      switchuvm(high_p);
80103ccc:	83 ec 0c             	sub    $0xc,%esp
      c->proc = high_p;
80103ccf:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(high_p);
80103cd5:	57                   	push   %edi
80103cd6:	e8 05 34 00 00       	call   801070e0 <switchuvm>
      high_p->state = RUNNING;
80103cdb:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), high_p->context);
80103ce2:	58                   	pop    %eax
80103ce3:	5a                   	pop    %edx
80103ce4:	ff 77 1c             	push   0x1c(%edi)
80103ce7:	56                   	push   %esi
80103ce8:	e8 ee 11 00 00       	call   80104edb <swtch>
      switchkvm();
80103ced:	e8 de 33 00 00       	call   801070d0 <switchkvm>
      c->proc = 0;
80103cf2:	83 c4 10             	add    $0x10,%esp
80103cf5:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103cfc:	00 00 00 
    release(&ptable.lock);
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	68 20 2d 11 80       	push   $0x80112d20
80103d07:	e8 94 0e 00 00       	call   80104ba0 <release>
    sti();
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	e9 5c ff ff ff       	jmp    80103c70 <scheduler+0x20>
80103d14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop

80103d20 <sched>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  pushcli();
80103d25:	e8 86 0d 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103d2a:	e8 e1 fb ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103d2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d35:	e8 c6 0d 00 00       	call   80104b00 <popcli>
  if(!holding(&ptable.lock))
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 20 2d 11 80       	push   $0x80112d20
80103d42:	e8 19 0e 00 00       	call   80104b60 <holding>
80103d47:	83 c4 10             	add    $0x10,%esp
80103d4a:	85 c0                	test   %eax,%eax
80103d4c:	74 4f                	je     80103d9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d4e:	e8 bd fb ff ff       	call   80103910 <mycpu>
80103d53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5a:	75 68                	jne    80103dc4 <sched+0xa4>
  if(p->state == RUNNING)
80103d5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d60:	74 55                	je     80103db7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d62:	9c                   	pushf  
80103d63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d64:	f6 c4 02             	test   $0x2,%ah
80103d67:	75 41                	jne    80103daa <sched+0x8a>
  intena = mycpu()->intena;
80103d69:	e8 a2 fb ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d77:	e8 94 fb ff ff       	call   80103910 <mycpu>
80103d7c:	83 ec 08             	sub    $0x8,%esp
80103d7f:	ff 70 04             	push   0x4(%eax)
80103d82:	53                   	push   %ebx
80103d83:	e8 53 11 00 00       	call   80104edb <swtch>
  mycpu()->intena = intena;
80103d88:	e8 83 fb ff ff       	call   80103910 <mycpu>
}
80103d8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret    
    panic("sched ptable.lock");
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	68 1b 7e 10 80       	push   $0x80107e1b
80103da5:	e8 d6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 47 7e 10 80       	push   $0x80107e47
80103db2:	e8 c9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	68 39 7e 10 80       	push   $0x80107e39
80103dbf:	e8 bc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	68 2d 7e 10 80       	push   $0x80107e2d
80103dcc:	e8 af c5 ff ff       	call   80100380 <panic>
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop

80103de0 <exit>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103de9:	e8 a2 fb ff ff       	call   80103990 <myproc>
  if(curproc == initproc)
80103dee:	39 05 54 4f 11 80    	cmp    %eax,0x80114f54
80103df4:	0f 84 07 01 00 00    	je     80103f01 <exit+0x121>
80103dfa:	89 c3                	mov    %eax,%ebx
80103dfc:	8d 70 28             	lea    0x28(%eax),%esi
80103dff:	8d 78 68             	lea    0x68(%eax),%edi
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e08:	8b 06                	mov    (%esi),%eax
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	74 12                	je     80103e20 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	50                   	push   %eax
80103e12:	e8 d9 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103e17:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e1d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e20:	83 c6 04             	add    $0x4,%esi
80103e23:	39 f7                	cmp    %esi,%edi
80103e25:	75 e1                	jne    80103e08 <exit+0x28>
  begin_op();
80103e27:	e8 34 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	ff 73 68             	push   0x68(%ebx)
80103e32:	e8 79 da ff ff       	call   801018b0 <iput>
  end_op();
80103e37:	e8 94 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103e3c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e43:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e4a:	e8 b1 0d 00 00       	call   80104c00 <acquire>
  wakeup1(curproc->parent);
80103e4f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e52:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e55:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5a:	eb 10                	jmp    80103e6c <exit+0x8c>
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e60:	05 88 00 00 00       	add    $0x88,%eax
80103e65:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103e6a:	74 1e                	je     80103e8a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103e6c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e70:	75 ee                	jne    80103e60 <exit+0x80>
80103e72:	3b 50 20             	cmp    0x20(%eax),%edx
80103e75:	75 e9                	jne    80103e60 <exit+0x80>
      p->state = RUNNABLE;
80103e77:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7e:	05 88 00 00 00       	add    $0x88,%eax
80103e83:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103e88:	75 e2                	jne    80103e6c <exit+0x8c>
      p->parent = initproc;
80103e8a:	8b 0d 54 4f 11 80    	mov    0x80114f54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e90:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e95:	eb 17                	jmp    80103eae <exit+0xce>
80103e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9e:	66 90                	xchg   %ax,%ax
80103ea0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103ea6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103eac:	74 3a                	je     80103ee8 <exit+0x108>
    if(p->parent == curproc){
80103eae:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103eb1:	75 ed                	jne    80103ea0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103eb3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eb7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eba:	75 e4                	jne    80103ea0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ec1:	eb 11                	jmp    80103ed4 <exit+0xf4>
80103ec3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec7:	90                   	nop
80103ec8:	05 88 00 00 00       	add    $0x88,%eax
80103ecd:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103ed2:	74 cc                	je     80103ea0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103ed4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed8:	75 ee                	jne    80103ec8 <exit+0xe8>
80103eda:	3b 48 20             	cmp    0x20(%eax),%ecx
80103edd:	75 e9                	jne    80103ec8 <exit+0xe8>
      p->state = RUNNABLE;
80103edf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ee6:	eb e0                	jmp    80103ec8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103ee8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103eef:	e8 2c fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 68 7e 10 80       	push   $0x80107e68
80103efc:	e8 7f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f01:	83 ec 0c             	sub    $0xc,%esp
80103f04:	68 5b 7e 10 80       	push   $0x80107e5b
80103f09:	e8 72 c4 ff ff       	call   80100380 <panic>
80103f0e:	66 90                	xchg   %ax,%ax

80103f10 <wait>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  pushcli();
80103f15:	e8 96 0b 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103f1a:	e8 f1 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f25:	e8 d6 0b 00 00       	call   80104b00 <popcli>
  acquire(&ptable.lock);
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 20 2d 11 80       	push   $0x80112d20
80103f32:	e8 c9 0c 00 00       	call   80104c00 <acquire>
80103f37:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f3a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f41:	eb 13                	jmp    80103f56 <wait+0x46>
80103f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f47:	90                   	nop
80103f48:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103f4e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103f54:	74 1e                	je     80103f74 <wait+0x64>
      if(p->parent != curproc)
80103f56:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f59:	75 ed                	jne    80103f48 <wait+0x38>
      if(p->state == ZOMBIE){
80103f5b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f5f:	74 5f                	je     80103fc0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f61:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80103f67:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103f72:	75 e2                	jne    80103f56 <wait+0x46>
    if(!havekids || curproc->killed){
80103f74:	85 c0                	test   %eax,%eax
80103f76:	0f 84 9a 00 00 00    	je     80104016 <wait+0x106>
80103f7c:	8b 46 24             	mov    0x24(%esi),%eax
80103f7f:	85 c0                	test   %eax,%eax
80103f81:	0f 85 8f 00 00 00    	jne    80104016 <wait+0x106>
  pushcli();
80103f87:	e8 24 0b 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103f8c:	e8 7f f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f97:	e8 64 0b 00 00       	call   80104b00 <popcli>
  if(p == 0)
80103f9c:	85 db                	test   %ebx,%ebx
80103f9e:	0f 84 89 00 00 00    	je     8010402d <wait+0x11d>
  p->chan = chan;
80103fa4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fa7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fae:	e8 6d fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80103fb3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fba:	e9 7b ff ff ff       	jmp    80103f3a <wait+0x2a>
80103fbf:	90                   	nop
        kfree(p->kstack);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fc3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fc6:	ff 73 08             	push   0x8(%ebx)
80103fc9:	e8 f2 e4 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80103fce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fd5:	5a                   	pop    %edx
80103fd6:	ff 73 04             	push   0x4(%ebx)
80103fd9:	e8 e2 34 00 00       	call   801074c0 <freevm>
        p->pid = 0;
80103fde:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fe5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ff0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ff7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ffe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104005:	e8 96 0b 00 00       	call   80104ba0 <release>
        return pid;
8010400a:	83 c4 10             	add    $0x10,%esp
}
8010400d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104010:	89 f0                	mov    %esi,%eax
80104012:	5b                   	pop    %ebx
80104013:	5e                   	pop    %esi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
      release(&ptable.lock);
80104016:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104019:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010401e:	68 20 2d 11 80       	push   $0x80112d20
80104023:	e8 78 0b 00 00       	call   80104ba0 <release>
      return -1;
80104028:	83 c4 10             	add    $0x10,%esp
8010402b:	eb e0                	jmp    8010400d <wait+0xfd>
    panic("sleep");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 74 7e 10 80       	push   $0x80107e74
80104035:	e8 46 c3 ff ff       	call   80100380 <panic>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <yield>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104047:	68 20 2d 11 80       	push   $0x80112d20
8010404c:	e8 af 0b 00 00       	call   80104c00 <acquire>
  pushcli();
80104051:	e8 5a 0a 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104056:	e8 b5 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 9a 0a 00 00       	call   80104b00 <popcli>
  myproc()->state = RUNNABLE;
80104066:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010406d:	e8 ae fc ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80104072:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104079:	e8 22 0b 00 00       	call   80104ba0 <release>
}
8010407e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104081:	83 c4 10             	add    $0x10,%esp
80104084:	c9                   	leave  
80104085:	c3                   	ret    
80104086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408d:	8d 76 00             	lea    0x0(%esi),%esi

80104090 <sleep>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	8b 7d 08             	mov    0x8(%ebp),%edi
8010409c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010409f:	e8 0c 0a 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
801040a4:	e8 67 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801040a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040af:	e8 4c 0a 00 00       	call   80104b00 <popcli>
  if(p == 0)
801040b4:	85 db                	test   %ebx,%ebx
801040b6:	0f 84 87 00 00 00    	je     80104143 <sleep+0xb3>
  if(lk == 0)
801040bc:	85 f6                	test   %esi,%esi
801040be:	74 76                	je     80104136 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040c0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801040c6:	74 50                	je     80104118 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 20 2d 11 80       	push   $0x80112d20
801040d0:	e8 2b 0b 00 00       	call   80104c00 <acquire>
    release(lk);
801040d5:	89 34 24             	mov    %esi,(%esp)
801040d8:	e8 c3 0a 00 00       	call   80104ba0 <release>
  p->chan = chan;
801040dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e7:	e8 34 fc ff ff       	call   80103d20 <sched>
  p->chan = 0;
801040ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040f3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040fa:	e8 a1 0a 00 00       	call   80104ba0 <release>
    acquire(lk);
801040ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104102:	83 c4 10             	add    $0x10,%esp
}
80104105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5f                   	pop    %edi
8010410b:	5d                   	pop    %ebp
    acquire(lk);
8010410c:	e9 ef 0a 00 00       	jmp    80104c00 <acquire>
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104118:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010411b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104122:	e8 f9 fb ff ff       	call   80103d20 <sched>
  p->chan = 0;
80104127:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5f                   	pop    %edi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    
    panic("sleep without lk");
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 7a 7e 10 80       	push   $0x80107e7a
8010413e:	e8 3d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 74 7e 10 80       	push   $0x80107e74
8010414b:	e8 30 c2 ff ff       	call   80100380 <panic>

80104150 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010415a:	68 20 2d 11 80       	push   $0x80112d20
8010415f:	e8 9c 0a 00 00       	call   80104c00 <acquire>
80104164:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104167:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010416c:	eb 0e                	jmp    8010417c <wakeup+0x2c>
8010416e:	66 90                	xchg   %ax,%ax
80104170:	05 88 00 00 00       	add    $0x88,%eax
80104175:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010417a:	74 1e                	je     8010419a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010417c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104180:	75 ee                	jne    80104170 <wakeup+0x20>
80104182:	3b 58 20             	cmp    0x20(%eax),%ebx
80104185:	75 e9                	jne    80104170 <wakeup+0x20>
      p->state = RUNNABLE;
80104187:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010418e:	05 88 00 00 00       	add    $0x88,%eax
80104193:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104198:	75 e2                	jne    8010417c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010419a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a4:	c9                   	leave  
  release(&ptable.lock);
801041a5:	e9 f6 09 00 00       	jmp    80104ba0 <release>
801041aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ba:	68 20 2d 11 80       	push   $0x80112d20
801041bf:	e8 3c 0a 00 00       	call   80104c00 <acquire>
801041c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041cc:	eb 0e                	jmp    801041dc <kill+0x2c>
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	05 88 00 00 00       	add    $0x88,%eax
801041d5:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801041da:	74 34                	je     80104210 <kill+0x60>
    if(p->pid == pid){
801041dc:	39 58 10             	cmp    %ebx,0x10(%eax)
801041df:	75 ef                	jne    801041d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041e1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041ec:	75 07                	jne    801041f5 <kill+0x45>
        p->state = RUNNABLE;
801041ee:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041f5:	83 ec 0c             	sub    $0xc,%esp
801041f8:	68 20 2d 11 80       	push   $0x80112d20
801041fd:	e8 9e 09 00 00       	call   80104ba0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	31 c0                	xor    %eax,%eax
}
8010420a:	c9                   	leave  
8010420b:	c3                   	ret    
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 20 2d 11 80       	push   $0x80112d20
80104218:	e8 83 09 00 00       	call   80104ba0 <release>
}
8010421d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104220:	83 c4 10             	add    $0x10,%esp
80104223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104238:	53                   	push   %ebx
80104239:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010423e:	83 ec 3c             	sub    $0x3c,%esp
80104241:	eb 27                	jmp    8010426a <procdump+0x3a>
80104243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104247:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 ad 7e 10 80       	push   $0x80107ead
80104250:	e8 4b c4 ff ff       	call   801006a0 <cprintf>
80104255:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104258:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010425e:	81 fb c0 4f 11 80    	cmp    $0x80114fc0,%ebx
80104264:	0f 84 7e 00 00 00    	je     801042e8 <procdump+0xb8>
    if(p->state == UNUSED)
8010426a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010426d:	85 c0                	test   %eax,%eax
8010426f:	74 e7                	je     80104258 <procdump+0x28>
      state = "???";
80104271:	ba 8b 7e 10 80       	mov    $0x80107e8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104276:	83 f8 05             	cmp    $0x5,%eax
80104279:	77 11                	ja     8010428c <procdump+0x5c>
8010427b:	8b 14 85 18 80 10 80 	mov    -0x7fef7fe8(,%eax,4),%edx
      state = "???";
80104282:	b8 8b 7e 10 80       	mov    $0x80107e8b,%eax
80104287:	85 d2                	test   %edx,%edx
80104289:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010428c:	53                   	push   %ebx
8010428d:	52                   	push   %edx
8010428e:	ff 73 a4             	push   -0x5c(%ebx)
80104291:	68 8f 7e 10 80       	push   $0x80107e8f
80104296:	e8 05 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010429b:	83 c4 10             	add    $0x10,%esp
8010429e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042a2:	75 a4                	jne    80104248 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042a4:	83 ec 08             	sub    $0x8,%esp
801042a7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042ad:	50                   	push   %eax
801042ae:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042b1:	8b 40 0c             	mov    0xc(%eax),%eax
801042b4:	83 c0 08             	add    $0x8,%eax
801042b7:	50                   	push   %eax
801042b8:	e8 93 07 00 00       	call   80104a50 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042bd:	83 c4 10             	add    $0x10,%esp
801042c0:	8b 17                	mov    (%edi),%edx
801042c2:	85 d2                	test   %edx,%edx
801042c4:	74 82                	je     80104248 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042cc:	52                   	push   %edx
801042cd:	68 e1 78 10 80       	push   $0x801078e1
801042d2:	e8 c9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	39 fe                	cmp    %edi,%esi
801042dc:	75 e2                	jne    801042c0 <procdump+0x90>
801042de:	e9 65 ff ff ff       	jmp    80104248 <procdump+0x18>
801042e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e7:	90                   	nop
  }
}
801042e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042eb:	5b                   	pop    %ebx
801042ec:	5e                   	pop    %esi
801042ed:	5f                   	pop    %edi
801042ee:	5d                   	pop    %ebp
801042ef:	c3                   	ret    

801042f0 <cps>:

//current process status
int
cps()
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
  asm volatile("sti");
801042f5:	fb                   	sti    
	
	// Enable interrupts on this processor.
	sti();
	
	  // Loop over process table looking for process with pid.
	acquire(&ptable.lock);
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801042fe:	be c0 4f 11 80       	mov    $0x80114fc0,%esi
80104303:	68 20 2d 11 80       	push   $0x80112d20
80104308:	e8 f3 08 00 00       	call   80104c00 <acquire>
	cprintf("name \t pid \t state \t \n");
8010430d:	c7 04 24 98 7e 10 80 	movl   $0x80107e98,(%esp)
80104314:	e8 87 c3 ff ff       	call   801006a0 <cprintf>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104319:	83 c4 10             	add    $0x10,%esp
8010431c:	eb 16                	jmp    80104334 <cps+0x44>
8010431e:	66 90                	xchg   %ax,%ax
	    if (p->state == SLEEPING)
	      cprintf("%s \t %d \t SLEEPING \t \n ", p->name, p->pid);
	    else if (p->state == RUNNING)
80104320:	83 f8 04             	cmp    $0x4,%eax
80104323:	74 53                	je     80104378 <cps+0x88>
	      cprintf("%s \t %d \t RUNNING \t \n ", p->name, p->pid);
	    else if (p->state == RUNNABLE)
80104325:	83 f8 03             	cmp    $0x3,%eax
80104328:	74 66                	je     80104390 <cps+0xa0>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010432a:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104330:	39 de                	cmp    %ebx,%esi
80104332:	74 26                	je     8010435a <cps+0x6a>
	    if (p->state == SLEEPING)
80104334:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104337:	83 f8 02             	cmp    $0x2,%eax
8010433a:	75 e4                	jne    80104320 <cps+0x30>
	      cprintf("%s \t %d \t SLEEPING \t \n ", p->name, p->pid);
8010433c:	83 ec 04             	sub    $0x4,%esp
8010433f:	ff 73 a4             	push   -0x5c(%ebx)
80104342:	53                   	push   %ebx
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104343:	81 c3 88 00 00 00    	add    $0x88,%ebx
	      cprintf("%s \t %d \t SLEEPING \t \n ", p->name, p->pid);
80104349:	68 af 7e 10 80       	push   $0x80107eaf
8010434e:	e8 4d c3 ff ff       	call   801006a0 <cprintf>
80104353:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104356:	39 de                	cmp    %ebx,%esi
80104358:	75 da                	jne    80104334 <cps+0x44>
	      cprintf("%s \t %d \t RUNNABLE \t \n ", p->name, p->pid);
	}
	
	release(&ptable.lock);
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 20 2d 11 80       	push   $0x80112d20
80104362:	e8 39 08 00 00       	call   80104ba0 <release>
	
	return 22;
}
80104367:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010436a:	b8 16 00 00 00       	mov    $0x16,%eax
8010436f:	5b                   	pop    %ebx
80104370:	5e                   	pop    %esi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104377:	90                   	nop
	      cprintf("%s \t %d \t RUNNING \t \n ", p->name, p->pid);
80104378:	83 ec 04             	sub    $0x4,%esp
8010437b:	ff 73 a4             	push   -0x5c(%ebx)
8010437e:	53                   	push   %ebx
8010437f:	68 c7 7e 10 80       	push   $0x80107ec7
80104384:	e8 17 c3 ff ff       	call   801006a0 <cprintf>
80104389:	83 c4 10             	add    $0x10,%esp
8010438c:	eb 9c                	jmp    8010432a <cps+0x3a>
8010438e:	66 90                	xchg   %ax,%ax
	      cprintf("%s \t %d \t RUNNABLE \t \n ", p->name, p->pid);
80104390:	83 ec 04             	sub    $0x4,%esp
80104393:	ff 73 a4             	push   -0x5c(%ebx)
80104396:	53                   	push   %ebx
80104397:	68 de 7e 10 80       	push   $0x80107ede
8010439c:	e8 ff c2 ff ff       	call   801006a0 <cprintf>
801043a1:	83 c4 10             	add    $0x10,%esp
801043a4:	eb 84                	jmp    8010432a <cps+0x3a>
801043a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <get_process_type>:

int get_process_type(void){
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  struct proc *p;

  //Get the pid (given as argument) from argint.
  if(argint(0, &pid) < 0){
801043b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801043b9:	50                   	push   %eax
801043ba:	6a 00                	push   $0x0
801043bc:	e8 bf 0b 00 00       	call   80104f80 <argint>
801043c1:	83 c4 10             	add    $0x10,%esp
801043c4:	85 c0                	test   %eax,%eax
801043c6:	0f 88 b2 00 00 00    	js     8010447e <get_process_type+0xce>
    return -1;
  }

  if(pid == 1){
801043cc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    //init process
    return 3;
801043d0:	b8 03 00 00 00       	mov    $0x3,%eax
  if(pid == 1){
801043d5:	74 5a                	je     80104431 <get_process_type+0x81>
  }

  //Acquire the lock for synchronization.
  acquire(&ptable.lock);
801043d7:	83 ec 0c             	sub    $0xc,%esp
801043da:	68 20 2d 11 80       	push   $0x80112d20
801043df:	e8 1c 08 00 00       	call   80104c00 <acquire>

  //Going throught the process table for finding the process with the given pid.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801043e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043e7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ea:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043ef:	eb 13                	jmp    80104404 <get_process_type+0x54>
801043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f8:	05 88 00 00 00       	add    $0x88,%eax
801043fd:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104402:	74 4c                	je     80104450 <get_process_type+0xa0>
    if(p->pid == pid){
80104404:	39 50 10             	cmp    %edx,0x10(%eax)
80104407:	75 ef                	jne    801043f8 <get_process_type+0x48>

      //Checking whether the process is a zombie process or not.
      if(p->state == ZOMBIE){
80104409:	83 78 0c 05          	cmpl   $0x5,0xc(%eax)
8010440d:	74 58                	je     80104467 <get_process_type+0xb7>
        release(&ptable.lock);
        return 1;
      }

      //Checking whether the process is orphan or not.
      else if(p->parent && p->parent->pid == 1 && p->state != ZOMBIE){
8010440f:	8b 40 14             	mov    0x14(%eax),%eax
80104412:	85 c0                	test   %eax,%eax
80104414:	74 06                	je     8010441c <get_process_type+0x6c>
80104416:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
8010441a:	74 1c                	je     80104438 <get_process_type+0x88>
      }

      else{
        //cprintf("Process type: %s\n", p->state);
        //Else it is a normal process.
        release(&ptable.lock);
8010441c:	83 ec 0c             	sub    $0xc,%esp
8010441f:	68 20 2d 11 80       	push   $0x80112d20
80104424:	e8 77 07 00 00       	call   80104ba0 <release>
        return 2;
80104429:	83 c4 10             	add    $0x10,%esp
8010442c:	b8 02 00 00 00       	mov    $0x2,%eax

  //If no such process exists return -1
  release(&ptable.lock);
  return -1;

}
80104431:	c9                   	leave  
80104432:	c3                   	ret    
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
        release(&ptable.lock);
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	68 20 2d 11 80       	push   $0x80112d20
80104440:	e8 5b 07 00 00       	call   80104ba0 <release>
        return 0;
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	31 c0                	xor    %eax,%eax
}
8010444a:	c9                   	leave  
8010444b:	c3                   	ret    
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	68 20 2d 11 80       	push   $0x80112d20
80104458:	e8 43 07 00 00       	call   80104ba0 <release>
  return -1;
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104465:	c9                   	leave  
80104466:	c3                   	ret    
        release(&ptable.lock);
80104467:	83 ec 0c             	sub    $0xc,%esp
8010446a:	68 20 2d 11 80       	push   $0x80112d20
8010446f:	e8 2c 07 00 00       	call   80104ba0 <release>
        return 1;
80104474:	83 c4 10             	add    $0x10,%esp
80104477:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010447c:	c9                   	leave  
8010447d:	c3                   	ret    
8010447e:	c9                   	leave  
    return -1;
8010447f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104484:	c3                   	ret    
80104485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <wait_pid>:

int wait_pid(void){
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80104498:	e8 13 06 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
8010449d:	e8 6e f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801044a2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044a8:	e8 53 06 00 00       	call   80104b00 <popcli>
  int pid;
  struct proc *p;
  struct proc *currproc = myproc();
  
  if (argint(0, &pid) < 0) {
801044ad:	83 ec 08             	sub    $0x8,%esp
801044b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801044b3:	50                   	push   %eax
801044b4:	6a 00                	push   $0x0
801044b6:	e8 c5 0a 00 00       	call   80104f80 <argint>
801044bb:	83 c4 10             	add    $0x10,%esp
801044be:	85 c0                	test   %eax,%eax
801044c0:	0f 88 30 01 00 00    	js     801045f6 <wait_pid+0x166>
      return -1;
  }
  
  acquire(&ptable.lock);
801044c6:	83 ec 0c             	sub    $0xc,%esp
801044c9:	68 20 2d 11 80       	push   $0x80112d20
801044ce:	e8 2d 07 00 00       	call   80104c00 <acquire>
  cprintf("wait_pid: Acquired ptable.lock for pid %d\n", pid);
801044d3:	5b                   	pop    %ebx
801044d4:	58                   	pop    %eax
801044d5:	ff 75 f4             	push   -0xc(%ebp)
801044d8:	68 48 7f 10 80       	push   $0x80107f48
801044dd:	e8 be c1 ff ff       	call   801006a0 <cprintf>
  
  // Find process with the specified PID
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if (p->pid == pid) {
801044e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044e8:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044ed:	eb 11                	jmp    80104500 <wait_pid+0x70>
801044ef:	90                   	nop
801044f0:	05 88 00 00 00       	add    $0x88,%eax
801044f5:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801044fa:	0f 84 d0 00 00 00    	je     801045d0 <wait_pid+0x140>
      if (p->pid == pid) {
80104500:	39 50 10             	cmp    %edx,0x10(%eax)
80104503:	75 eb                	jne    801044f0 <wait_pid+0x60>
          break;
      }
  }
  
  // Validate target process
  if (p >= &ptable.proc[NPROC] || p == currproc || p->state == UNUSED) {
80104505:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
8010450a:	0f 83 c0 00 00 00    	jae    801045d0 <wait_pid+0x140>
80104510:	39 c6                	cmp    %eax,%esi
80104512:	0f 84 b8 00 00 00    	je     801045d0 <wait_pid+0x140>
80104518:	8b 48 0c             	mov    0xc(%eax),%ecx
8010451b:	85 c9                	test   %ecx,%ecx
8010451d:	0f 84 ad 00 00 00    	je     801045d0 <wait_pid+0x140>
  }
  
  // Parent process is waiting for the child
  currproc->waiting_for = pid;
  currproc->wait_state = 1;
  cprintf("wait_pid: Process %d waiting for pid %d\n", currproc->pid, pid);
80104523:	83 ec 04             	sub    $0x4,%esp
  currproc->waiting_for = pid;
80104526:	89 56 7c             	mov    %edx,0x7c(%esi)
  currproc->wait_state = 1;
80104529:	c7 86 80 00 00 00 01 	movl   $0x1,0x80(%esi)
80104530:	00 00 00 
  cprintf("wait_pid: Process %d waiting for pid %d\n", currproc->pid, pid);
80104533:	52                   	push   %edx
80104534:	ff 76 10             	push   0x10(%esi)
80104537:	68 9c 7f 10 80       	push   $0x80107f9c
8010453c:	e8 5f c1 ff ff       	call   801006a0 <cprintf>
  
  // Sleep until the target process finishes or is unwaited
  while (currproc->wait_state == 1) {
80104541:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104547:	83 c4 10             	add    $0x10,%esp
8010454a:	83 f8 01             	cmp    $0x1,%eax
8010454d:	75 52                	jne    801045a1 <wait_pid+0x111>
8010454f:	90                   	nop
      cprintf("wait_pid: Process %d is sleeping\n", currproc->pid);
80104550:	83 ec 08             	sub    $0x8,%esp
80104553:	ff 76 10             	push   0x10(%esi)
80104556:	68 c8 7f 10 80       	push   $0x80107fc8
8010455b:	e8 40 c1 ff ff       	call   801006a0 <cprintf>
  pushcli();
80104560:	e8 4b 05 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104565:	e8 a6 f3 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010456a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104570:	e8 8b 05 00 00       	call   80104b00 <popcli>
  if(p == 0)
80104575:	83 c4 10             	add    $0x10,%esp
80104578:	85 db                	test   %ebx,%ebx
8010457a:	0f 84 b4 00 00 00    	je     80104634 <wait_pid+0x1a4>
  p->chan = chan;
80104580:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104583:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010458a:	e8 91 f7 ff ff       	call   80103d20 <sched>
  p->chan = 0;
8010458f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  while (currproc->wait_state == 1) {
80104596:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010459c:	83 f8 01             	cmp    $0x1,%eax
8010459f:	74 af                	je     80104550 <wait_pid+0xc0>
      sleep(currproc, &ptable.lock);
  }
  
  // Check if the wait was interrupted
  if (currproc->wait_state == 2) {
801045a1:	83 f8 02             	cmp    $0x2,%eax
801045a4:	74 57                	je     801045fd <wait_pid+0x16d>
      return -1;
  }
  
  currproc->waiting_for = -1;
  currproc->wait_state = 0;
  release(&ptable.lock);
801045a6:	83 ec 0c             	sub    $0xc,%esp
  currproc->waiting_for = -1;
801045a9:	c7 46 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%esi)
  currproc->wait_state = 0;
801045b0:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
801045b7:	00 00 00 
  release(&ptable.lock);
801045ba:	68 20 2d 11 80       	push   $0x80112d20
801045bf:	e8 dc 05 00 00       	call   80104ba0 <release>
  return 0;
801045c4:	83 c4 10             	add    $0x10,%esp
801045c7:	31 c0                	xor    %eax,%eax
}
801045c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045cc:	5b                   	pop    %ebx
801045cd:	5e                   	pop    %esi
801045ce:	5d                   	pop    %ebp
801045cf:	c3                   	ret    
      release(&ptable.lock);
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	68 20 2d 11 80       	push   $0x80112d20
801045d8:	e8 c3 05 00 00       	call   80104ba0 <release>
      cprintf("wait_pid: Invalid target process %d\n", pid);
801045dd:	58                   	pop    %eax
801045de:	5a                   	pop    %edx
801045df:	ff 75 f4             	push   -0xc(%ebp)
801045e2:	68 74 7f 10 80       	push   $0x80107f74
801045e7:	e8 b4 c0 ff ff       	call   801006a0 <cprintf>
      return -1;
801045ec:	83 c4 10             	add    $0x10,%esp
801045ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f4:	eb d3                	jmp    801045c9 <wait_pid+0x139>
      return -1;
801045f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fb:	eb cc                	jmp    801045c9 <wait_pid+0x139>
      cprintf("wait_pid: Wait interrupted for process %d\n", currproc->pid);
801045fd:	83 ec 08             	sub    $0x8,%esp
80104600:	ff 76 10             	push   0x10(%esi)
80104603:	68 ec 7f 10 80       	push   $0x80107fec
80104608:	e8 93 c0 ff ff       	call   801006a0 <cprintf>
      currproc->waiting_for = -1;
8010460d:	c7 46 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%esi)
      currproc->wait_state = 0;
80104614:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010461b:	00 00 00 
      release(&ptable.lock);
8010461e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104625:	e8 76 05 00 00       	call   80104ba0 <release>
      return -1;
8010462a:	83 c4 10             	add    $0x10,%esp
8010462d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104632:	eb 95                	jmp    801045c9 <wait_pid+0x139>
    panic("sleep");
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	68 74 7e 10 80       	push   $0x80107e74
8010463c:	e8 3f bd ff ff       	call   80100380 <panic>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop

80104650 <unwait_pid>:

int unwait_pid(void){
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  //struct proc *curr = myproc();

  int woke = 0;

  //Getting pid for the system call from arguments.
  if(argint(0, &pid) <  0){
80104655:	8d 45 f4             	lea    -0xc(%ebp),%eax
int unwait_pid(void){
80104658:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &pid) <  0){
8010465b:	50                   	push   %eax
8010465c:	6a 00                	push   $0x0
8010465e:	e8 1d 09 00 00       	call   80104f80 <argint>
80104663:	83 c4 10             	add    $0x10,%esp
80104666:	85 c0                	test   %eax,%eax
80104668:	0f 88 d8 00 00 00    	js     80104746 <unwait_pid+0xf6>
    return -1;
  }

  //Acquiring lock for accessing the ptable.
  acquire(&ptable.lock);
8010466e:	83 ec 0c             	sub    $0xc,%esp
  int woke = 0;
80104671:	31 f6                	xor    %esi,%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104673:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80104678:	68 20 2d 11 80       	push   $0x80112d20
8010467d:	e8 7e 05 00 00       	call   80104c00 <acquire>
80104682:	83 c4 10             	add    $0x10,%esp
80104685:	eb 1b                	jmp    801046a2 <unwait_pid+0x52>
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104690:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104696:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010469c:	0f 84 8b 00 00 00    	je     8010472d <unwait_pid+0xdd>
    if(p->state == SLEEPING && p->waiting_for == pid){
801046a2:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801046a6:	75 e8                	jne    80104690 <unwait_pid+0x40>
801046a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ab:	39 43 7c             	cmp    %eax,0x7c(%ebx)
801046ae:	75 e0                	jne    80104690 <unwait_pid+0x40>
  acquire(&ptable.lock);
801046b0:	83 ec 0c             	sub    $0xc,%esp

      //Reset the waiting state.
      p->wait_state = 0;
      p->waiting_for = -1;
801046b3:	c7 43 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%ebx)
  acquire(&ptable.lock);
801046ba:	68 20 2d 11 80       	push   $0x80112d20
      p->wait_state = 0;
801046bf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801046c6:	00 00 00 
  acquire(&ptable.lock);
801046c9:	e8 32 05 00 00       	call   80104c00 <acquire>
801046ce:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046d1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801046d6:	eb 14                	jmp    801046ec <unwait_pid+0x9c>
801046d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop
801046e0:	05 88 00 00 00       	add    $0x88,%eax
801046e5:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801046ea:	74 24                	je     80104710 <unwait_pid+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801046ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046f0:	75 ee                	jne    801046e0 <unwait_pid+0x90>
801046f2:	39 58 20             	cmp    %ebx,0x20(%eax)
801046f5:	75 e9                	jne    801046e0 <unwait_pid+0x90>
      p->state = RUNNABLE;
801046f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046fe:	05 88 00 00 00       	add    $0x88,%eax
80104703:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104708:	75 e2                	jne    801046ec <unwait_pid+0x9c>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104710:	83 ec 0c             	sub    $0xc,%esp
      
      //Waking up the sleeping process.
      wakeup(p);
      woke++;
80104713:	83 c6 01             	add    $0x1,%esi
  release(&ptable.lock);
80104716:	68 20 2d 11 80       	push   $0x80112d20
8010471b:	e8 80 04 00 00       	call   80104ba0 <release>

      if(pid != -1){
80104720:	83 c4 10             	add    $0x10,%esp
80104723:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
80104727:	0f 84 63 ff ff ff    	je     80104690 <unwait_pid+0x40>
        break;
      }
    }
  }
  release(&ptable.lock);
8010472d:	83 ec 0c             	sub    $0xc,%esp
80104730:	68 20 2d 11 80       	push   $0x80112d20
80104735:	e8 66 04 00 00       	call   80104ba0 <release>

  return woke;
8010473a:	83 c4 10             	add    $0x10,%esp

}
8010473d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104740:	89 f0                	mov    %esi,%eax
80104742:	5b                   	pop    %ebx
80104743:	5e                   	pop    %esi
80104744:	5d                   	pop    %ebp
80104745:	c3                   	ret    
    return -1;
80104746:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010474b:	eb f0                	jmp    8010473d <unwait_pid+0xed>
8010474d:	8d 76 00             	lea    0x0(%esi),%esi

80104750 <mem_usage>:

int mem_usage(void){
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
  int pid;
  int size = 0;
  int found = 0;

  //Get the pid (given as argument) from argint.
  if(argint(0, &pid) < 0){
80104754:	8d 45 f4             	lea    -0xc(%ebp),%eax
int mem_usage(void){
80104757:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &pid) < 0){
8010475a:	50                   	push   %eax
8010475b:	6a 00                	push   $0x0
8010475d:	e8 1e 08 00 00       	call   80104f80 <argint>
80104762:	83 c4 10             	add    $0x10,%esp
80104765:	85 c0                	test   %eax,%eax
80104767:	78 6b                	js     801047d4 <mem_usage+0x84>
    return -1;
  }

  //Acquire the lock for synchronization.
  acquire(&ptable.lock);
80104769:	83 ec 0c             	sub    $0xc,%esp
8010476c:	68 20 2d 11 80       	push   $0x80112d20
80104771:	e8 8a 04 00 00       	call   80104c00 <acquire>

  //Going throught the process table for finding the process with the given pid.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80104776:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104779:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010477c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104781:	eb 11                	jmp    80104794 <mem_usage+0x44>
80104783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104787:	90                   	nop
80104788:	05 88 00 00 00       	add    $0x88,%eax
8010478d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104792:	74 24                	je     801047b8 <mem_usage+0x68>
    if(p->pid == pid){
80104794:	39 50 10             	cmp    %edx,0x10(%eax)
80104797:	75 ef                	jne    80104788 <mem_usage+0x38>

    }
  }

  //If not found return -1;
  release(&ptable.lock);
80104799:	83 ec 0c             	sub    $0xc,%esp
      size = p->sz;
8010479c:	8b 18                	mov    (%eax),%ebx
  release(&ptable.lock);
8010479e:	68 20 2d 11 80       	push   $0x80112d20
801047a3:	e8 f8 03 00 00       	call   80104ba0 <release>
801047a8:	83 c4 10             	add    $0x10,%esp
  if(!found){
    return -1;
  }
  
  return size;
}
801047ab:	89 d8                	mov    %ebx,%eax
801047ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b0:	c9                   	leave  
801047b1:	c3                   	ret    
801047b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801047b8:	83 ec 0c             	sub    $0xc,%esp
    return -1;
801047bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&ptable.lock);
801047c0:	68 20 2d 11 80       	push   $0x80112d20
801047c5:	e8 d6 03 00 00       	call   80104ba0 <release>
}
801047ca:	89 d8                	mov    %ebx,%eax
    return -1;
801047cc:	83 c4 10             	add    $0x10,%esp
}
801047cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d2:	c9                   	leave  
801047d3:	c3                   	ret    
    return -1;
801047d4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047d9:	eb d0                	jmp    801047ab <mem_usage+0x5b>
801047db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <get_priority>:

int get_priority(void){
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
  int pid;
  int priority = -1;
  if(argint(0, &pid) < 0){
801047e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int get_priority(void){
801047e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &pid) < 0){
801047ea:	50                   	push   %eax
801047eb:	6a 00                	push   $0x0
801047ed:	e8 8e 07 00 00       	call   80104f80 <argint>
801047f2:	83 c4 10             	add    $0x10,%esp
801047f5:	85 c0                	test   %eax,%eax
801047f7:	78 52                	js     8010484b <get_priority+0x6b>
    return -1;
  }

  struct proc *p;

  acquire(&ptable.lock);
801047f9:	83 ec 0c             	sub    $0xc,%esp
801047fc:	68 20 2d 11 80       	push   $0x80112d20
80104801:	e8 fa 03 00 00       	call   80104c00 <acquire>

  //loop through the list of processes and find the process with the given pid
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80104806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104809:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
8010480c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104811:	eb 11                	jmp    80104824 <get_priority+0x44>
80104813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104817:	90                   	nop
80104818:	05 88 00 00 00       	add    $0x88,%eax
8010481d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104822:	74 34                	je     80104858 <get_priority+0x78>
    if(p->pid == pid){
80104824:	39 50 10             	cmp    %edx,0x10(%eax)
80104827:	75 ef                	jne    80104818 <get_priority+0x38>
      priority =  p->priority;
      break;
    }
  }

  release(&ptable.lock);
80104829:	83 ec 0c             	sub    $0xc,%esp
      priority =  p->priority;
8010482c:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  release(&ptable.lock);
80104832:	68 20 2d 11 80       	push   $0x80112d20
80104837:	e8 64 03 00 00       	call   80104ba0 <release>

  if(priority==-1){
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	83 fb ff             	cmp    $0xffffffff,%ebx
80104842:	74 24                	je     80104868 <get_priority+0x88>
    return -2; // pid not found
  }

  return priority;  
}
80104844:	89 d8                	mov    %ebx,%eax
80104846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104849:	c9                   	leave  
8010484a:	c3                   	ret    
    return -1;
8010484b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104850:	eb f2                	jmp    80104844 <get_priority+0x64>
80104852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 20 2d 11 80       	push   $0x80112d20
80104860:	e8 3b 03 00 00       	call   80104ba0 <release>
80104865:	83 c4 10             	add    $0x10,%esp
    return -2; // pid not found
80104868:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
8010486d:	eb d5                	jmp    80104844 <get_priority+0x64>
8010486f:	90                   	nop

80104870 <set_priority>:

int set_priority(void){
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
    int pid, priority;
    int setPrior = -1; 
    if(argint(0, &pid) || argint(1, &priority)){
80104874:	8d 45 f0             	lea    -0x10(%ebp),%eax
int set_priority(void){
80104877:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &pid) || argint(1, &priority)){
8010487a:	50                   	push   %eax
8010487b:	6a 00                	push   $0x0
8010487d:	e8 fe 06 00 00       	call   80104f80 <argint>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	85 c0                	test   %eax,%eax
80104887:	75 67                	jne    801048f0 <set_priority+0x80>
80104889:	83 ec 08             	sub    $0x8,%esp
8010488c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010488f:	50                   	push   %eax
80104890:	6a 01                	push   $0x1
80104892:	e8 e9 06 00 00       	call   80104f80 <argint>
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	85 c0                	test   %eax,%eax
8010489c:	75 52                	jne    801048f0 <set_priority+0x80>
      return -1;
    }

    acquire(&ptable.lock);
8010489e:	83 ec 0c             	sub    $0xc,%esp
    int setPrior = -1; 
801048a1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    acquire(&ptable.lock);
801048a6:	68 20 2d 11 80       	push   $0x80112d20
801048ab:	e8 50 03 00 00       	call   80104c00 <acquire>

    struct proc *p;

    for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
      if(p->pid==pid){
801048b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
        p->priority = priority;
801048b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801048b6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
801048b9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801048be:	66 90                	xchg   %ax,%ax
      if(p->pid==pid){
801048c0:	39 50 10             	cmp    %edx,0x10(%eax)
801048c3:	75 08                	jne    801048cd <set_priority+0x5d>
        p->priority = priority;
801048c5:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
        setPrior = 0;
801048cb:	31 db                	xor    %ebx,%ebx
    for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
801048cd:	05 88 00 00 00       	add    $0x88,%eax
801048d2:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801048d7:	75 e7                	jne    801048c0 <set_priority+0x50>
      }
    }

    release(&ptable.lock);
801048d9:	83 ec 0c             	sub    $0xc,%esp
801048dc:	68 20 2d 11 80       	push   $0x80112d20
801048e1:	e8 ba 02 00 00       	call   80104ba0 <release>

    return setPrior; //-1 for failure and 0 for success
801048e6:	83 c4 10             	add    $0x10,%esp
801048e9:	89 d8                	mov    %ebx,%eax
801048eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048ee:	c9                   	leave  
801048ef:	c3                   	ret    
      return -1;
801048f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801048f5:	eb f2                	jmp    801048e9 <set_priority+0x79>
801048f7:	66 90                	xchg   %ax,%ax
801048f9:	66 90                	xchg   %ax,%ax
801048fb:	66 90                	xchg   %ax,%ax
801048fd:	66 90                	xchg   %ax,%ax
801048ff:	90                   	nop

80104900 <initsleeplock>:
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010490a:	68 30 80 10 80       	push   $0x80108030
8010490f:	8d 43 04             	lea    0x4(%ebx),%eax
80104912:	50                   	push   %eax
80104913:	e8 18 01 00 00       	call   80104a30 <initlock>
80104918:	8b 45 0c             	mov    0xc(%ebp),%eax
8010491b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104921:	83 c4 10             	add    $0x10,%esp
80104924:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
8010492b:	89 43 38             	mov    %eax,0x38(%ebx)
8010492e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104931:	c9                   	leave  
80104932:	c3                   	ret    
80104933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104940 <acquiresleep>:
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104948:	8d 73 04             	lea    0x4(%ebx),%esi
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	56                   	push   %esi
8010494f:	e8 ac 02 00 00       	call   80104c00 <acquire>
80104954:	8b 13                	mov    (%ebx),%edx
80104956:	83 c4 10             	add    $0x10,%esp
80104959:	85 d2                	test   %edx,%edx
8010495b:	74 16                	je     80104973 <acquiresleep+0x33>
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	83 ec 08             	sub    $0x8,%esp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	e8 26 f7 ff ff       	call   80104090 <sleep>
8010496a:	8b 03                	mov    (%ebx),%eax
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	85 c0                	test   %eax,%eax
80104971:	75 ed                	jne    80104960 <acquiresleep+0x20>
80104973:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
80104979:	e8 12 f0 ff ff       	call   80103990 <myproc>
8010497e:	8b 40 10             	mov    0x10(%eax),%eax
80104981:	89 43 3c             	mov    %eax,0x3c(%ebx)
80104984:	89 75 08             	mov    %esi,0x8(%ebp)
80104987:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010498a:	5b                   	pop    %ebx
8010498b:	5e                   	pop    %esi
8010498c:	5d                   	pop    %ebp
8010498d:	e9 0e 02 00 00       	jmp    80104ba0 <release>
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049a0 <releasesleep>:
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049a8:	8d 73 04             	lea    0x4(%ebx),%esi
801049ab:	83 ec 0c             	sub    $0xc,%esp
801049ae:	56                   	push   %esi
801049af:	e8 4c 02 00 00       	call   80104c00 <acquire>
801049b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801049ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
801049c1:	89 1c 24             	mov    %ebx,(%esp)
801049c4:	e8 87 f7 ff ff       	call   80104150 <wakeup>
801049c9:	89 75 08             	mov    %esi,0x8(%ebp)
801049cc:	83 c4 10             	add    $0x10,%esp
801049cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d2:	5b                   	pop    %ebx
801049d3:	5e                   	pop    %esi
801049d4:	5d                   	pop    %ebp
801049d5:	e9 c6 01 00 00       	jmp    80104ba0 <release>
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <holdingsleep>:
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	31 ff                	xor    %edi,%edi
801049e6:	56                   	push   %esi
801049e7:	53                   	push   %ebx
801049e8:	83 ec 18             	sub    $0x18,%esp
801049eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049ee:	8d 73 04             	lea    0x4(%ebx),%esi
801049f1:	56                   	push   %esi
801049f2:	e8 09 02 00 00       	call   80104c00 <acquire>
801049f7:	8b 03                	mov    (%ebx),%eax
801049f9:	83 c4 10             	add    $0x10,%esp
801049fc:	85 c0                	test   %eax,%eax
801049fe:	75 18                	jne    80104a18 <holdingsleep+0x38>
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	56                   	push   %esi
80104a04:	e8 97 01 00 00       	call   80104ba0 <release>
80104a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a0c:	89 f8                	mov    %edi,%eax
80104a0e:	5b                   	pop    %ebx
80104a0f:	5e                   	pop    %esi
80104a10:	5f                   	pop    %edi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a17:	90                   	nop
80104a18:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a1b:	e8 70 ef ff ff       	call   80103990 <myproc>
80104a20:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a23:	0f 94 c0             	sete   %al
80104a26:	0f b6 c0             	movzbl %al,%eax
80104a29:	89 c7                	mov    %eax,%edi
80104a2b:	eb d3                	jmp    80104a00 <holdingsleep+0x20>
80104a2d:	66 90                	xchg   %ax,%ax
80104a2f:	90                   	nop

80104a30 <initlock>:
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	8b 45 08             	mov    0x8(%ebp),%eax
80104a36:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a3f:	89 50 04             	mov    %edx,0x4(%eax)
80104a42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a4f:	90                   	nop

80104a50 <getcallerpcs>:
80104a50:	55                   	push   %ebp
80104a51:	31 d2                	xor    %edx,%edx
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	53                   	push   %ebx
80104a56:	8b 45 08             	mov    0x8(%ebp),%eax
80104a59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a5c:	83 e8 08             	sub    $0x8,%eax
80104a5f:	90                   	nop
80104a60:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a6c:	77 1a                	ja     80104a88 <getcallerpcs+0x38>
80104a6e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a71:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
80104a74:	83 c2 01             	add    $0x1,%edx
80104a77:	8b 00                	mov    (%eax),%eax
80104a79:	83 fa 0a             	cmp    $0xa,%edx
80104a7c:	75 e2                	jne    80104a60 <getcallerpcs+0x10>
80104a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a81:	c9                   	leave  
80104a82:	c3                   	ret    
80104a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a87:	90                   	nop
80104a88:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a8b:	8d 51 28             	lea    0x28(%ecx),%edx
80104a8e:	66 90                	xchg   %ax,%ax
80104a90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a96:	83 c0 04             	add    $0x4,%eax
80104a99:	39 d0                	cmp    %edx,%eax
80104a9b:	75 f3                	jne    80104a90 <getcallerpcs+0x40>
80104a9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa0:	c9                   	leave  
80104aa1:	c3                   	ret    
80104aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <pushcli>:
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 04             	sub    $0x4,%esp
80104ab7:	9c                   	pushf  
80104ab8:	5b                   	pop    %ebx
80104ab9:	fa                   	cli    
80104aba:	e8 51 ee ff ff       	call   80103910 <mycpu>
80104abf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ac5:	85 c0                	test   %eax,%eax
80104ac7:	74 17                	je     80104ae0 <pushcli+0x30>
80104ac9:	e8 42 ee ff ff       	call   80103910 <mycpu>
80104ace:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad8:	c9                   	leave  
80104ad9:	c3                   	ret    
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ae0:	e8 2b ee ff ff       	call   80103910 <mycpu>
80104ae5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aeb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104af1:	eb d6                	jmp    80104ac9 <pushcli+0x19>
80104af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b00 <popcli>:
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	83 ec 08             	sub    $0x8,%esp
80104b06:	9c                   	pushf  
80104b07:	58                   	pop    %eax
80104b08:	f6 c4 02             	test   $0x2,%ah
80104b0b:	75 35                	jne    80104b42 <popcli+0x42>
80104b0d:	e8 fe ed ff ff       	call   80103910 <mycpu>
80104b12:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b19:	78 34                	js     80104b4f <popcli+0x4f>
80104b1b:	e8 f0 ed ff ff       	call   80103910 <mycpu>
80104b20:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b26:	85 d2                	test   %edx,%edx
80104b28:	74 06                	je     80104b30 <popcli+0x30>
80104b2a:	c9                   	leave  
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b30:	e8 db ed ff ff       	call   80103910 <mycpu>
80104b35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	74 eb                	je     80104b2a <popcli+0x2a>
80104b3f:	fb                   	sti    
80104b40:	c9                   	leave  
80104b41:	c3                   	ret    
80104b42:	83 ec 0c             	sub    $0xc,%esp
80104b45:	68 3b 80 10 80       	push   $0x8010803b
80104b4a:	e8 31 b8 ff ff       	call   80100380 <panic>
80104b4f:	83 ec 0c             	sub    $0xc,%esp
80104b52:	68 52 80 10 80       	push   $0x80108052
80104b57:	e8 24 b8 ff ff       	call   80100380 <panic>
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <holding>:
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 75 08             	mov    0x8(%ebp),%esi
80104b68:	31 db                	xor    %ebx,%ebx
80104b6a:	e8 41 ff ff ff       	call   80104ab0 <pushcli>
80104b6f:	8b 06                	mov    (%esi),%eax
80104b71:	85 c0                	test   %eax,%eax
80104b73:	75 0b                	jne    80104b80 <holding+0x20>
80104b75:	e8 86 ff ff ff       	call   80104b00 <popcli>
80104b7a:	89 d8                	mov    %ebx,%eax
80104b7c:	5b                   	pop    %ebx
80104b7d:	5e                   	pop    %esi
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret    
80104b80:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b83:	e8 88 ed ff ff       	call   80103910 <mycpu>
80104b88:	39 c3                	cmp    %eax,%ebx
80104b8a:	0f 94 c3             	sete   %bl
80104b8d:	e8 6e ff ff ff       	call   80104b00 <popcli>
80104b92:	0f b6 db             	movzbl %bl,%ebx
80104b95:	89 d8                	mov    %ebx,%eax
80104b97:	5b                   	pop    %ebx
80104b98:	5e                   	pop    %esi
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop

80104ba0 <release>:
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ba8:	e8 03 ff ff ff       	call   80104ab0 <pushcli>
80104bad:	8b 03                	mov    (%ebx),%eax
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	75 15                	jne    80104bc8 <release+0x28>
80104bb3:	e8 48 ff ff ff       	call   80104b00 <popcli>
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	68 59 80 10 80       	push   $0x80108059
80104bc0:	e8 bb b7 ff ff       	call   80100380 <panic>
80104bc5:	8d 76 00             	lea    0x0(%esi),%esi
80104bc8:	8b 73 08             	mov    0x8(%ebx),%esi
80104bcb:	e8 40 ed ff ff       	call   80103910 <mycpu>
80104bd0:	39 c6                	cmp    %eax,%esi
80104bd2:	75 df                	jne    80104bb3 <release+0x13>
80104bd4:	e8 27 ff ff ff       	call   80104b00 <popcli>
80104bd9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104be0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104be7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104bec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104bf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf5:	5b                   	pop    %ebx
80104bf6:	5e                   	pop    %esi
80104bf7:	5d                   	pop    %ebp
80104bf8:	e9 03 ff ff ff       	jmp    80104b00 <popcli>
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <acquire>:
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	e8 a4 fe ff ff       	call   80104ab0 <pushcli>
80104c0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c0f:	e8 9c fe ff ff       	call   80104ab0 <pushcli>
80104c14:	8b 03                	mov    (%ebx),%eax
80104c16:	85 c0                	test   %eax,%eax
80104c18:	75 7e                	jne    80104c98 <acquire+0x98>
80104c1a:	e8 e1 fe ff ff       	call   80104b00 <popcli>
80104c1f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c28:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2b:	89 c8                	mov    %ecx,%eax
80104c2d:	f0 87 02             	lock xchg %eax,(%edx)
80104c30:	85 c0                	test   %eax,%eax
80104c32:	75 f4                	jne    80104c28 <acquire+0x28>
80104c34:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c3c:	e8 cf ec ff ff       	call   80103910 <mycpu>
80104c41:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c44:	89 ea                	mov    %ebp,%edx
80104c46:	89 43 08             	mov    %eax,0x8(%ebx)
80104c49:	31 c0                	xor    %eax,%eax
80104c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop
80104c50:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c56:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c5c:	77 1a                	ja     80104c78 <acquire+0x78>
80104c5e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c61:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
80104c65:	83 c0 01             	add    $0x1,%eax
80104c68:	8b 12                	mov    (%edx),%edx
80104c6a:	83 f8 0a             	cmp    $0xa,%eax
80104c6d:	75 e1                	jne    80104c50 <acquire+0x50>
80104c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c72:	c9                   	leave  
80104c73:	c3                   	ret    
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c78:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104c7c:	8d 51 34             	lea    0x34(%ecx),%edx
80104c7f:	90                   	nop
80104c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c86:	83 c0 04             	add    $0x4,%eax
80104c89:	39 c2                	cmp    %eax,%edx
80104c8b:	75 f3                	jne    80104c80 <acquire+0x80>
80104c8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c90:	c9                   	leave  
80104c91:	c3                   	ret    
80104c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c98:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104c9b:	e8 70 ec ff ff       	call   80103910 <mycpu>
80104ca0:	39 c3                	cmp    %eax,%ebx
80104ca2:	0f 85 72 ff ff ff    	jne    80104c1a <acquire+0x1a>
80104ca8:	e8 53 fe ff ff       	call   80104b00 <popcli>
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	68 61 80 10 80       	push   $0x80108061
80104cb5:	e8 c6 b6 ff ff       	call   80100380 <panic>
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cca:	53                   	push   %ebx
80104ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104cce:	89 d7                	mov    %edx,%edi
80104cd0:	09 cf                	or     %ecx,%edi
80104cd2:	83 e7 03             	and    $0x3,%edi
80104cd5:	75 29                	jne    80104d00 <memset+0x40>
    c &= 0xFF;
80104cd7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cda:	c1 e0 18             	shl    $0x18,%eax
80104cdd:	89 fb                	mov    %edi,%ebx
80104cdf:	c1 e9 02             	shr    $0x2,%ecx
80104ce2:	c1 e3 10             	shl    $0x10,%ebx
80104ce5:	09 d8                	or     %ebx,%eax
80104ce7:	09 f8                	or     %edi,%eax
80104ce9:	c1 e7 08             	shl    $0x8,%edi
80104cec:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cee:	89 d7                	mov    %edx,%edi
80104cf0:	fc                   	cld    
80104cf1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104cf3:	5b                   	pop    %ebx
80104cf4:	89 d0                	mov    %edx,%eax
80104cf6:	5f                   	pop    %edi
80104cf7:	5d                   	pop    %ebp
80104cf8:	c3                   	ret    
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d00:	89 d7                	mov    %edx,%edi
80104d02:	fc                   	cld    
80104d03:	f3 aa                	rep stos %al,%es:(%edi)
80104d05:	5b                   	pop    %ebx
80104d06:	89 d0                	mov    %edx,%eax
80104d08:	5f                   	pop    %edi
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	8b 75 10             	mov    0x10(%ebp),%esi
80104d17:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1a:	53                   	push   %ebx
80104d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d1e:	85 f6                	test   %esi,%esi
80104d20:	74 2e                	je     80104d50 <memcmp+0x40>
80104d22:	01 c6                	add    %eax,%esi
80104d24:	eb 14                	jmp    80104d3a <memcmp+0x2a>
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d36:	39 f0                	cmp    %esi,%eax
80104d38:	74 16                	je     80104d50 <memcmp+0x40>
    if(*s1 != *s2)
80104d3a:	0f b6 0a             	movzbl (%edx),%ecx
80104d3d:	0f b6 18             	movzbl (%eax),%ebx
80104d40:	38 d9                	cmp    %bl,%cl
80104d42:	74 ec                	je     80104d30 <memcmp+0x20>
      return *s1 - *s2;
80104d44:	0f b6 c1             	movzbl %cl,%eax
80104d47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d49:	5b                   	pop    %ebx
80104d4a:	5e                   	pop    %esi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
80104d50:	5b                   	pop    %ebx
  return 0;
80104d51:	31 c0                	xor    %eax,%eax
}
80104d53:	5e                   	pop    %esi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	8b 55 08             	mov    0x8(%ebp),%edx
80104d67:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d6a:	56                   	push   %esi
80104d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d6e:	39 d6                	cmp    %edx,%esi
80104d70:	73 26                	jae    80104d98 <memmove+0x38>
80104d72:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d75:	39 fa                	cmp    %edi,%edx
80104d77:	73 1f                	jae    80104d98 <memmove+0x38>
80104d79:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d7c:	85 c9                	test   %ecx,%ecx
80104d7e:	74 0c                	je     80104d8c <memmove+0x2c>
      *--d = *--s;
80104d80:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d84:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d87:	83 e8 01             	sub    $0x1,%eax
80104d8a:	73 f4                	jae    80104d80 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d8c:	5e                   	pop    %esi
80104d8d:	89 d0                	mov    %edx,%eax
80104d8f:	5f                   	pop    %edi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104d98:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104d9b:	89 d7                	mov    %edx,%edi
80104d9d:	85 c9                	test   %ecx,%ecx
80104d9f:	74 eb                	je     80104d8c <memmove+0x2c>
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104da8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104da9:	39 c6                	cmp    %eax,%esi
80104dab:	75 fb                	jne    80104da8 <memmove+0x48>
}
80104dad:	5e                   	pop    %esi
80104dae:	89 d0                	mov    %edx,%eax
80104db0:	5f                   	pop    %edi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104dc0:	eb 9e                	jmp    80104d60 <memmove>
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	8b 75 10             	mov    0x10(%ebp),%esi
80104dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dda:	53                   	push   %ebx
80104ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104dde:	85 f6                	test   %esi,%esi
80104de0:	74 2e                	je     80104e10 <strncmp+0x40>
80104de2:	01 d6                	add    %edx,%esi
80104de4:	eb 18                	jmp    80104dfe <strncmp+0x2e>
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
80104df0:	38 d8                	cmp    %bl,%al
80104df2:	75 14                	jne    80104e08 <strncmp+0x38>
    n--, p++, q++;
80104df4:	83 c2 01             	add    $0x1,%edx
80104df7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dfa:	39 f2                	cmp    %esi,%edx
80104dfc:	74 12                	je     80104e10 <strncmp+0x40>
80104dfe:	0f b6 01             	movzbl (%ecx),%eax
80104e01:	0f b6 1a             	movzbl (%edx),%ebx
80104e04:	84 c0                	test   %al,%al
80104e06:	75 e8                	jne    80104df0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e08:	29 d8                	sub    %ebx,%eax
}
80104e0a:	5b                   	pop    %ebx
80104e0b:	5e                   	pop    %esi
80104e0c:	5d                   	pop    %ebp
80104e0d:	c3                   	ret    
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	5b                   	pop    %ebx
    return 0;
80104e11:	31 c0                	xor    %eax,%eax
}
80104e13:	5e                   	pop    %esi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	8b 75 08             	mov    0x8(%ebp),%esi
80104e28:	53                   	push   %ebx
80104e29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e2c:	89 f0                	mov    %esi,%eax
80104e2e:	eb 15                	jmp    80104e45 <strncpy+0x25>
80104e30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e34:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e37:	83 c0 01             	add    $0x1,%eax
80104e3a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104e3e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104e41:	84 d2                	test   %dl,%dl
80104e43:	74 09                	je     80104e4e <strncpy+0x2e>
80104e45:	89 cb                	mov    %ecx,%ebx
80104e47:	83 e9 01             	sub    $0x1,%ecx
80104e4a:	85 db                	test   %ebx,%ebx
80104e4c:	7f e2                	jg     80104e30 <strncpy+0x10>
    ;
  while(n-- > 0)
80104e4e:	89 c2                	mov    %eax,%edx
80104e50:	85 c9                	test   %ecx,%ecx
80104e52:	7e 17                	jle    80104e6b <strncpy+0x4b>
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e58:	83 c2 01             	add    $0x1,%edx
80104e5b:	89 c1                	mov    %eax,%ecx
80104e5d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104e61:	29 d1                	sub    %edx,%ecx
80104e63:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104e67:	85 c9                	test   %ecx,%ecx
80104e69:	7f ed                	jg     80104e58 <strncpy+0x38>
  return os;
}
80104e6b:	5b                   	pop    %ebx
80104e6c:	89 f0                	mov    %esi,%eax
80104e6e:	5e                   	pop    %esi
80104e6f:	5f                   	pop    %edi
80104e70:	5d                   	pop    %ebp
80104e71:	c3                   	ret    
80104e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	8b 55 10             	mov    0x10(%ebp),%edx
80104e87:	8b 75 08             	mov    0x8(%ebp),%esi
80104e8a:	53                   	push   %ebx
80104e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e8e:	85 d2                	test   %edx,%edx
80104e90:	7e 25                	jle    80104eb7 <safestrcpy+0x37>
80104e92:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104e96:	89 f2                	mov    %esi,%edx
80104e98:	eb 16                	jmp    80104eb0 <safestrcpy+0x30>
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ea0:	0f b6 08             	movzbl (%eax),%ecx
80104ea3:	83 c0 01             	add    $0x1,%eax
80104ea6:	83 c2 01             	add    $0x1,%edx
80104ea9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104eac:	84 c9                	test   %cl,%cl
80104eae:	74 04                	je     80104eb4 <safestrcpy+0x34>
80104eb0:	39 d8                	cmp    %ebx,%eax
80104eb2:	75 ec                	jne    80104ea0 <safestrcpy+0x20>
    ;
  *s = 0;
80104eb4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104eb7:	89 f0                	mov    %esi,%eax
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <strlen>:

int
strlen(const char *s)
{
80104ec0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ec8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ecb:	74 0c                	je     80104ed9 <strlen+0x19>
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	83 c0 01             	add    $0x1,%eax
80104ed3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ed7:	75 f7                	jne    80104ed0 <strlen+0x10>
    ;
  return n;
}
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    

80104edb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104edb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104edf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ee3:	55                   	push   %ebp
  pushl %ebx
80104ee4:	53                   	push   %ebx
  pushl %esi
80104ee5:	56                   	push   %esi
  pushl %edi
80104ee6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ee7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ee9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104eeb:	5f                   	pop    %edi
  popl %esi
80104eec:	5e                   	pop    %esi
  popl %ebx
80104eed:	5b                   	pop    %ebx
  popl %ebp
80104eee:	5d                   	pop    %ebp
  ret
80104eef:	c3                   	ret    

80104ef0 <fetchint>:
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
80104ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104efa:	e8 91 ea ff ff       	call   80103990 <myproc>
80104eff:	8b 00                	mov    (%eax),%eax
80104f01:	39 d8                	cmp    %ebx,%eax
80104f03:	76 1b                	jbe    80104f20 <fetchint+0x30>
80104f05:	8d 53 04             	lea    0x4(%ebx),%edx
80104f08:	39 d0                	cmp    %edx,%eax
80104f0a:	72 14                	jb     80104f20 <fetchint+0x30>
80104f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f0f:	8b 13                	mov    (%ebx),%edx
80104f11:	89 10                	mov    %edx,(%eax)
80104f13:	31 c0                	xor    %eax,%eax
80104f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f18:	c9                   	leave  
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f25:	eb ee                	jmp    80104f15 <fetchint+0x25>
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <fetchstr>:
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f3a:	e8 51 ea ff ff       	call   80103990 <myproc>
80104f3f:	39 18                	cmp    %ebx,(%eax)
80104f41:	76 2d                	jbe    80104f70 <fetchstr+0x40>
80104f43:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f46:	89 1a                	mov    %ebx,(%edx)
80104f48:	8b 10                	mov    (%eax),%edx
80104f4a:	39 d3                	cmp    %edx,%ebx
80104f4c:	73 22                	jae    80104f70 <fetchstr+0x40>
80104f4e:	89 d8                	mov    %ebx,%eax
80104f50:	eb 0d                	jmp    80104f5f <fetchstr+0x2f>
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f58:	83 c0 01             	add    $0x1,%eax
80104f5b:	39 c2                	cmp    %eax,%edx
80104f5d:	76 11                	jbe    80104f70 <fetchstr+0x40>
80104f5f:	80 38 00             	cmpb   $0x0,(%eax)
80104f62:	75 f4                	jne    80104f58 <fetchstr+0x28>
80104f64:	29 d8                	sub    %ebx,%eax
80104f66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
80104f70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f78:	c9                   	leave  
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f80 <argint>:
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	e8 06 ea ff ff       	call   80103990 <myproc>
80104f8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f8d:	8b 40 18             	mov    0x18(%eax),%eax
80104f90:	8b 40 44             	mov    0x44(%eax),%eax
80104f93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104f96:	e8 f5 e9 ff ff       	call   80103990 <myproc>
80104f9b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f9e:	8b 00                	mov    (%eax),%eax
80104fa0:	39 c6                	cmp    %eax,%esi
80104fa2:	73 1c                	jae    80104fc0 <argint+0x40>
80104fa4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fa7:	39 d0                	cmp    %edx,%eax
80104fa9:	72 15                	jb     80104fc0 <argint+0x40>
80104fab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fae:	8b 53 04             	mov    0x4(%ebx),%edx
80104fb1:	89 10                	mov    %edx,(%eax)
80104fb3:	31 c0                	xor    %eax,%eax
80104fb5:	5b                   	pop    %ebx
80104fb6:	5e                   	pop    %esi
80104fb7:	5d                   	pop    %ebp
80104fb8:	c3                   	ret    
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb ee                	jmp    80104fb5 <argint+0x35>
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <argptr>:
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	56                   	push   %esi
80104fd5:	53                   	push   %ebx
80104fd6:	83 ec 0c             	sub    $0xc,%esp
80104fd9:	e8 b2 e9 ff ff       	call   80103990 <myproc>
80104fde:	89 c6                	mov    %eax,%esi
80104fe0:	e8 ab e9 ff ff       	call   80103990 <myproc>
80104fe5:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe8:	8b 40 18             	mov    0x18(%eax),%eax
80104feb:	8b 40 44             	mov    0x44(%eax),%eax
80104fee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104ff1:	e8 9a e9 ff ff       	call   80103990 <myproc>
80104ff6:	8d 7b 04             	lea    0x4(%ebx),%edi
80104ff9:	8b 00                	mov    (%eax),%eax
80104ffb:	39 c7                	cmp    %eax,%edi
80104ffd:	73 31                	jae    80105030 <argptr+0x60>
80104fff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105002:	39 c8                	cmp    %ecx,%eax
80105004:	72 2a                	jb     80105030 <argptr+0x60>
80105006:	8b 55 10             	mov    0x10(%ebp),%edx
80105009:	8b 43 04             	mov    0x4(%ebx),%eax
8010500c:	85 d2                	test   %edx,%edx
8010500e:	78 20                	js     80105030 <argptr+0x60>
80105010:	8b 16                	mov    (%esi),%edx
80105012:	39 c2                	cmp    %eax,%edx
80105014:	76 1a                	jbe    80105030 <argptr+0x60>
80105016:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105019:	01 c3                	add    %eax,%ebx
8010501b:	39 da                	cmp    %ebx,%edx
8010501d:	72 11                	jb     80105030 <argptr+0x60>
8010501f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105022:	89 02                	mov    %eax,(%edx)
80105024:	31 c0                	xor    %eax,%eax
80105026:	83 c4 0c             	add    $0xc,%esp
80105029:	5b                   	pop    %ebx
8010502a:	5e                   	pop    %esi
8010502b:	5f                   	pop    %edi
8010502c:	5d                   	pop    %ebp
8010502d:	c3                   	ret    
8010502e:	66 90                	xchg   %ax,%ax
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105035:	eb ef                	jmp    80105026 <argptr+0x56>
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <argstr>:
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
80105045:	e8 46 e9 ff ff       	call   80103990 <myproc>
8010504a:	8b 55 08             	mov    0x8(%ebp),%edx
8010504d:	8b 40 18             	mov    0x18(%eax),%eax
80105050:	8b 40 44             	mov    0x44(%eax),%eax
80105053:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80105056:	e8 35 e9 ff ff       	call   80103990 <myproc>
8010505b:	8d 73 04             	lea    0x4(%ebx),%esi
8010505e:	8b 00                	mov    (%eax),%eax
80105060:	39 c6                	cmp    %eax,%esi
80105062:	73 44                	jae    801050a8 <argstr+0x68>
80105064:	8d 53 08             	lea    0x8(%ebx),%edx
80105067:	39 d0                	cmp    %edx,%eax
80105069:	72 3d                	jb     801050a8 <argstr+0x68>
8010506b:	8b 5b 04             	mov    0x4(%ebx),%ebx
8010506e:	e8 1d e9 ff ff       	call   80103990 <myproc>
80105073:	3b 18                	cmp    (%eax),%ebx
80105075:	73 31                	jae    801050a8 <argstr+0x68>
80105077:	8b 55 0c             	mov    0xc(%ebp),%edx
8010507a:	89 1a                	mov    %ebx,(%edx)
8010507c:	8b 10                	mov    (%eax),%edx
8010507e:	39 d3                	cmp    %edx,%ebx
80105080:	73 26                	jae    801050a8 <argstr+0x68>
80105082:	89 d8                	mov    %ebx,%eax
80105084:	eb 11                	jmp    80105097 <argstr+0x57>
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
80105090:	83 c0 01             	add    $0x1,%eax
80105093:	39 c2                	cmp    %eax,%edx
80105095:	76 11                	jbe    801050a8 <argstr+0x68>
80105097:	80 38 00             	cmpb   $0x0,(%eax)
8010509a:	75 f4                	jne    80105090 <argstr+0x50>
8010509c:	29 d8                	sub    %ebx,%eax
8010509e:	5b                   	pop    %ebx
8010509f:	5e                   	pop    %esi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret    
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050a8:	5b                   	pop    %ebx
801050a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ae:	5e                   	pop    %esi
801050af:	5d                   	pop    %ebp
801050b0:	c3                   	ret    
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop

801050c0 <syscall>:
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 04             	sub    $0x4,%esp
801050c7:	83 05 08 b0 10 80 01 	addl   $0x1,0x8010b008
801050ce:	e8 bd e8 ff ff       	call   80103990 <myproc>
801050d3:	89 c3                	mov    %eax,%ebx
801050d5:	8b 40 18             	mov    0x18(%eax),%eax
801050d8:	8b 40 1c             	mov    0x1c(%eax),%eax
801050db:	8d 50 ff             	lea    -0x1(%eax),%edx
801050de:	83 fa 1c             	cmp    $0x1c,%edx
801050e1:	77 1d                	ja     80105100 <syscall+0x40>
801050e3:	8b 14 85 a0 80 10 80 	mov    -0x7fef7f60(,%eax,4),%edx
801050ea:	85 d2                	test   %edx,%edx
801050ec:	74 12                	je     80105100 <syscall+0x40>
801050ee:	ff d2                	call   *%edx
801050f0:	89 c2                	mov    %eax,%edx
801050f2:	8b 43 18             	mov    0x18(%ebx),%eax
801050f5:	89 50 1c             	mov    %edx,0x1c(%eax)
801050f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
80105100:	50                   	push   %eax
80105101:	8d 43 6c             	lea    0x6c(%ebx),%eax
80105104:	50                   	push   %eax
80105105:	ff 73 10             	push   0x10(%ebx)
80105108:	68 69 80 10 80       	push   $0x80108069
8010510d:	e8 8e b5 ff ff       	call   801006a0 <cprintf>
80105112:	8b 43 18             	mov    0x18(%ebx),%eax
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010511f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105122:	c9                   	leave  
80105123:	c3                   	ret    
80105124:	66 90                	xchg   %ax,%ax
80105126:	66 90                	xchg   %ax,%ax
80105128:	66 90                	xchg   %ax,%ax
8010512a:	66 90                	xchg   %ax,%ax
8010512c:	66 90                	xchg   %ax,%ax
8010512e:	66 90                	xchg   %ax,%ax

80105130 <create>:
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	8d 7d da             	lea    -0x26(%ebp),%edi
80105138:	53                   	push   %ebx
80105139:	83 ec 34             	sub    $0x34,%esp
8010513c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010513f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105142:	57                   	push   %edi
80105143:	50                   	push   %eax
80105144:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105147:	89 4d cc             	mov    %ecx,-0x34(%ebp)
8010514a:	e8 71 cf ff ff       	call   801020c0 <nameiparent>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 84 46 01 00 00    	je     801052a0 <create+0x170>
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	89 c3                	mov    %eax,%ebx
8010515f:	50                   	push   %eax
80105160:	e8 1b c6 ff ff       	call   80101780 <ilock>
80105165:	83 c4 0c             	add    $0xc,%esp
80105168:	6a 00                	push   $0x0
8010516a:	57                   	push   %edi
8010516b:	53                   	push   %ebx
8010516c:	e8 6f cb ff ff       	call   80101ce0 <dirlookup>
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	89 c6                	mov    %eax,%esi
80105176:	85 c0                	test   %eax,%eax
80105178:	74 56                	je     801051d0 <create+0xa0>
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	53                   	push   %ebx
8010517e:	e8 8d c8 ff ff       	call   80101a10 <iunlockput>
80105183:	89 34 24             	mov    %esi,(%esp)
80105186:	e8 f5 c5 ff ff       	call   80101780 <ilock>
8010518b:	83 c4 10             	add    $0x10,%esp
8010518e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105193:	75 1b                	jne    801051b0 <create+0x80>
80105195:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010519a:	75 14                	jne    801051b0 <create+0x80>
8010519c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519f:	89 f0                	mov    %esi,%eax
801051a1:	5b                   	pop    %ebx
801051a2:	5e                   	pop    %esi
801051a3:	5f                   	pop    %edi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	56                   	push   %esi
801051b4:	31 f6                	xor    %esi,%esi
801051b6:	e8 55 c8 ff ff       	call   80101a10 <iunlockput>
801051bb:	83 c4 10             	add    $0x10,%esp
801051be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c1:	89 f0                	mov    %esi,%eax
801051c3:	5b                   	pop    %ebx
801051c4:	5e                   	pop    %esi
801051c5:	5f                   	pop    %edi
801051c6:	5d                   	pop    %ebp
801051c7:	c3                   	ret    
801051c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
801051d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	50                   	push   %eax
801051d8:	ff 33                	push   (%ebx)
801051da:	e8 31 c4 ff ff       	call   80101610 <ialloc>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	89 c6                	mov    %eax,%esi
801051e4:	85 c0                	test   %eax,%eax
801051e6:	0f 84 cd 00 00 00    	je     801052b9 <create+0x189>
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	50                   	push   %eax
801051f0:	e8 8b c5 ff ff       	call   80101780 <ilock>
801051f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051f9:	66 89 46 52          	mov    %ax,0x52(%esi)
801051fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105201:	66 89 46 54          	mov    %ax,0x54(%esi)
80105205:	b8 01 00 00 00       	mov    $0x1,%eax
8010520a:	66 89 46 56          	mov    %ax,0x56(%esi)
8010520e:	89 34 24             	mov    %esi,(%esp)
80105211:	e8 ba c4 ff ff       	call   801016d0 <iupdate>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010521e:	74 30                	je     80105250 <create+0x120>
80105220:	83 ec 04             	sub    $0x4,%esp
80105223:	ff 76 04             	push   0x4(%esi)
80105226:	57                   	push   %edi
80105227:	53                   	push   %ebx
80105228:	e8 b3 cd ff ff       	call   80101fe0 <dirlink>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	78 78                	js     801052ac <create+0x17c>
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	53                   	push   %ebx
80105238:	e8 d3 c7 ff ff       	call   80101a10 <iunlockput>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105243:	89 f0                	mov    %esi,%eax
80105245:	5b                   	pop    %ebx
80105246:	5e                   	pop    %esi
80105247:	5f                   	pop    %edi
80105248:	5d                   	pop    %ebp
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80105258:	53                   	push   %ebx
80105259:	e8 72 c4 ff ff       	call   801016d0 <iupdate>
8010525e:	83 c4 0c             	add    $0xc,%esp
80105261:	ff 76 04             	push   0x4(%esi)
80105264:	68 34 81 10 80       	push   $0x80108134
80105269:	56                   	push   %esi
8010526a:	e8 71 cd ff ff       	call   80101fe0 <dirlink>
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	85 c0                	test   %eax,%eax
80105274:	78 18                	js     8010528e <create+0x15e>
80105276:	83 ec 04             	sub    $0x4,%esp
80105279:	ff 73 04             	push   0x4(%ebx)
8010527c:	68 33 81 10 80       	push   $0x80108133
80105281:	56                   	push   %esi
80105282:	e8 59 cd ff ff       	call   80101fe0 <dirlink>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	85 c0                	test   %eax,%eax
8010528c:	79 92                	jns    80105220 <create+0xf0>
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	68 27 81 10 80       	push   $0x80108127
80105296:	e8 e5 b0 ff ff       	call   80100380 <panic>
8010529b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop
801052a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a3:	31 f6                	xor    %esi,%esi
801052a5:	5b                   	pop    %ebx
801052a6:	89 f0                	mov    %esi,%eax
801052a8:	5e                   	pop    %esi
801052a9:	5f                   	pop    %edi
801052aa:	5d                   	pop    %ebp
801052ab:	c3                   	ret    
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	68 36 81 10 80       	push   $0x80108136
801052b4:	e8 c7 b0 ff ff       	call   80100380 <panic>
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	68 18 81 10 80       	push   $0x80108118
801052c1:	e8 ba b0 ff ff       	call   80100380 <panic>
801052c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cd:	8d 76 00             	lea    0x0(%esi),%esi

801052d0 <sys_dup>:
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d8:	83 ec 18             	sub    $0x18,%esp
801052db:	50                   	push   %eax
801052dc:	6a 00                	push   $0x0
801052de:	e8 9d fc ff ff       	call   80104f80 <argint>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	78 36                	js     80105320 <sys_dup+0x50>
801052ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052ee:	77 30                	ja     80105320 <sys_dup+0x50>
801052f0:	e8 9b e6 ff ff       	call   80103990 <myproc>
801052f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801052fc:	85 f6                	test   %esi,%esi
801052fe:	74 20                	je     80105320 <sys_dup+0x50>
80105300:	e8 8b e6 ff ff       	call   80103990 <myproc>
80105305:	31 db                	xor    %ebx,%ebx
80105307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530e:	66 90                	xchg   %ax,%ax
80105310:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105314:	85 d2                	test   %edx,%edx
80105316:	74 18                	je     80105330 <sys_dup+0x60>
80105318:	83 c3 01             	add    $0x1,%ebx
8010531b:	83 fb 10             	cmp    $0x10,%ebx
8010531e:	75 f0                	jne    80105310 <sys_dup+0x40>
80105320:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105323:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105328:	89 d8                	mov    %ebx,%eax
8010532a:	5b                   	pop    %ebx
8010532b:	5e                   	pop    %esi
8010532c:	5d                   	pop    %ebp
8010532d:	c3                   	ret    
8010532e:	66 90                	xchg   %ax,%ax
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
80105337:	56                   	push   %esi
80105338:	e8 63 bb ff ff       	call   80100ea0 <filedup>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105343:	89 d8                	mov    %ebx,%eax
80105345:	5b                   	pop    %ebx
80105346:	5e                   	pop    %esi
80105347:	5d                   	pop    %ebp
80105348:	c3                   	ret    
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105350 <sys_read>:
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80105358:	83 ec 18             	sub    $0x18,%esp
8010535b:	53                   	push   %ebx
8010535c:	6a 00                	push   $0x0
8010535e:	e8 1d fc ff ff       	call   80104f80 <argint>
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	78 5e                	js     801053c8 <sys_read+0x78>
8010536a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010536e:	77 58                	ja     801053c8 <sys_read+0x78>
80105370:	e8 1b e6 ff ff       	call   80103990 <myproc>
80105375:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105378:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010537c:	85 f6                	test   %esi,%esi
8010537e:	74 48                	je     801053c8 <sys_read+0x78>
80105380:	83 ec 08             	sub    $0x8,%esp
80105383:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105386:	50                   	push   %eax
80105387:	6a 02                	push   $0x2
80105389:	e8 f2 fb ff ff       	call   80104f80 <argint>
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	85 c0                	test   %eax,%eax
80105393:	78 33                	js     801053c8 <sys_read+0x78>
80105395:	83 ec 04             	sub    $0x4,%esp
80105398:	ff 75 f0             	push   -0x10(%ebp)
8010539b:	53                   	push   %ebx
8010539c:	6a 01                	push   $0x1
8010539e:	e8 2d fc ff ff       	call   80104fd0 <argptr>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 1e                	js     801053c8 <sys_read+0x78>
801053aa:	83 ec 04             	sub    $0x4,%esp
801053ad:	ff 75 f0             	push   -0x10(%ebp)
801053b0:	ff 75 f4             	push   -0xc(%ebp)
801053b3:	56                   	push   %esi
801053b4:	e8 67 bc ff ff       	call   80101020 <fileread>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053bf:	5b                   	pop    %ebx
801053c0:	5e                   	pop    %esi
801053c1:	5d                   	pop    %ebp
801053c2:	c3                   	ret    
801053c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053c7:	90                   	nop
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cd:	eb ed                	jmp    801053bc <sys_read+0x6c>
801053cf:	90                   	nop

801053d0 <sys_write>:
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	53                   	push   %ebx
801053d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801053d8:	83 ec 18             	sub    $0x18,%esp
801053db:	53                   	push   %ebx
801053dc:	6a 00                	push   $0x0
801053de:	e8 9d fb ff ff       	call   80104f80 <argint>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 5e                	js     80105448 <sys_write+0x78>
801053ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053ee:	77 58                	ja     80105448 <sys_write+0x78>
801053f0:	e8 9b e5 ff ff       	call   80103990 <myproc>
801053f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053fc:	85 f6                	test   %esi,%esi
801053fe:	74 48                	je     80105448 <sys_write+0x78>
80105400:	83 ec 08             	sub    $0x8,%esp
80105403:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105406:	50                   	push   %eax
80105407:	6a 02                	push   $0x2
80105409:	e8 72 fb ff ff       	call   80104f80 <argint>
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	85 c0                	test   %eax,%eax
80105413:	78 33                	js     80105448 <sys_write+0x78>
80105415:	83 ec 04             	sub    $0x4,%esp
80105418:	ff 75 f0             	push   -0x10(%ebp)
8010541b:	53                   	push   %ebx
8010541c:	6a 01                	push   $0x1
8010541e:	e8 ad fb ff ff       	call   80104fd0 <argptr>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	78 1e                	js     80105448 <sys_write+0x78>
8010542a:	83 ec 04             	sub    $0x4,%esp
8010542d:	ff 75 f0             	push   -0x10(%ebp)
80105430:	ff 75 f4             	push   -0xc(%ebp)
80105433:	56                   	push   %esi
80105434:	e8 77 bc ff ff       	call   801010b0 <filewrite>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010543f:	5b                   	pop    %ebx
80105440:	5e                   	pop    %esi
80105441:	5d                   	pop    %ebp
80105442:	c3                   	ret    
80105443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105447:	90                   	nop
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544d:	eb ed                	jmp    8010543c <sys_write+0x6c>
8010544f:	90                   	nop

80105450 <sys_close>:
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	56                   	push   %esi
80105454:	53                   	push   %ebx
80105455:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105458:	83 ec 18             	sub    $0x18,%esp
8010545b:	50                   	push   %eax
8010545c:	6a 00                	push   $0x0
8010545e:	e8 1d fb ff ff       	call   80104f80 <argint>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 3e                	js     801054a8 <sys_close+0x58>
8010546a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010546e:	77 38                	ja     801054a8 <sys_close+0x58>
80105470:	e8 1b e5 ff ff       	call   80103990 <myproc>
80105475:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105478:	8d 5a 08             	lea    0x8(%edx),%ebx
8010547b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010547f:	85 f6                	test   %esi,%esi
80105481:	74 25                	je     801054a8 <sys_close+0x58>
80105483:	e8 08 e5 ff ff       	call   80103990 <myproc>
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105492:	00 
80105493:	56                   	push   %esi
80105494:	e8 57 ba ff ff       	call   80100ef0 <fileclose>
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	31 c0                	xor    %eax,%eax
8010549e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a1:	5b                   	pop    %ebx
801054a2:	5e                   	pop    %esi
801054a3:	5d                   	pop    %ebp
801054a4:	c3                   	ret    
801054a5:	8d 76 00             	lea    0x0(%esi),%esi
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	eb ef                	jmp    8010549e <sys_close+0x4e>
801054af:	90                   	nop

801054b0 <sys_fstat>:
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
801054b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801054b8:	83 ec 18             	sub    $0x18,%esp
801054bb:	53                   	push   %ebx
801054bc:	6a 00                	push   $0x0
801054be:	e8 bd fa ff ff       	call   80104f80 <argint>
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 46                	js     80105510 <sys_fstat+0x60>
801054ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ce:	77 40                	ja     80105510 <sys_fstat+0x60>
801054d0:	e8 bb e4 ff ff       	call   80103990 <myproc>
801054d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801054dc:	85 f6                	test   %esi,%esi
801054de:	74 30                	je     80105510 <sys_fstat+0x60>
801054e0:	83 ec 04             	sub    $0x4,%esp
801054e3:	6a 14                	push   $0x14
801054e5:	53                   	push   %ebx
801054e6:	6a 01                	push   $0x1
801054e8:	e8 e3 fa ff ff       	call   80104fd0 <argptr>
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 1c                	js     80105510 <sys_fstat+0x60>
801054f4:	83 ec 08             	sub    $0x8,%esp
801054f7:	ff 75 f4             	push   -0xc(%ebp)
801054fa:	56                   	push   %esi
801054fb:	e8 d0 ba ff ff       	call   80100fd0 <filestat>
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105506:	5b                   	pop    %ebx
80105507:	5e                   	pop    %esi
80105508:	5d                   	pop    %ebp
80105509:	c3                   	ret    
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105515:	eb ec                	jmp    80105503 <sys_fstat+0x53>
80105517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551e:	66 90                	xchg   %ax,%ax

80105520 <sys_link>:
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
80105525:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105528:	53                   	push   %ebx
80105529:	83 ec 34             	sub    $0x34,%esp
8010552c:	50                   	push   %eax
8010552d:	6a 00                	push   $0x0
8010552f:	e8 0c fb ff ff       	call   80105040 <argstr>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	0f 88 fb 00 00 00    	js     8010563a <sys_link+0x11a>
8010553f:	83 ec 08             	sub    $0x8,%esp
80105542:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105545:	50                   	push   %eax
80105546:	6a 01                	push   $0x1
80105548:	e8 f3 fa ff ff       	call   80105040 <argstr>
8010554d:	83 c4 10             	add    $0x10,%esp
80105550:	85 c0                	test   %eax,%eax
80105552:	0f 88 e2 00 00 00    	js     8010563a <sys_link+0x11a>
80105558:	e8 03 d8 ff ff       	call   80102d60 <begin_op>
8010555d:	83 ec 0c             	sub    $0xc,%esp
80105560:	ff 75 d4             	push   -0x2c(%ebp)
80105563:	e8 38 cb ff ff       	call   801020a0 <namei>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	89 c3                	mov    %eax,%ebx
8010556d:	85 c0                	test   %eax,%eax
8010556f:	0f 84 e4 00 00 00    	je     80105659 <sys_link+0x139>
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	50                   	push   %eax
80105579:	e8 02 c2 ff ff       	call   80101780 <ilock>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105586:	0f 84 b5 00 00 00    	je     80105641 <sys_link+0x121>
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80105594:	8d 7d da             	lea    -0x26(%ebp),%edi
80105597:	53                   	push   %ebx
80105598:	e8 33 c1 ff ff       	call   801016d0 <iupdate>
8010559d:	89 1c 24             	mov    %ebx,(%esp)
801055a0:	e8 bb c2 ff ff       	call   80101860 <iunlock>
801055a5:	58                   	pop    %eax
801055a6:	5a                   	pop    %edx
801055a7:	57                   	push   %edi
801055a8:	ff 75 d0             	push   -0x30(%ebp)
801055ab:	e8 10 cb ff ff       	call   801020c0 <nameiparent>
801055b0:	83 c4 10             	add    $0x10,%esp
801055b3:	89 c6                	mov    %eax,%esi
801055b5:	85 c0                	test   %eax,%eax
801055b7:	74 5b                	je     80105614 <sys_link+0xf4>
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	50                   	push   %eax
801055bd:	e8 be c1 ff ff       	call   80101780 <ilock>
801055c2:	8b 03                	mov    (%ebx),%eax
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	39 06                	cmp    %eax,(%esi)
801055c9:	75 3d                	jne    80105608 <sys_link+0xe8>
801055cb:	83 ec 04             	sub    $0x4,%esp
801055ce:	ff 73 04             	push   0x4(%ebx)
801055d1:	57                   	push   %edi
801055d2:	56                   	push   %esi
801055d3:	e8 08 ca ff ff       	call   80101fe0 <dirlink>
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	85 c0                	test   %eax,%eax
801055dd:	78 29                	js     80105608 <sys_link+0xe8>
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	56                   	push   %esi
801055e3:	e8 28 c4 ff ff       	call   80101a10 <iunlockput>
801055e8:	89 1c 24             	mov    %ebx,(%esp)
801055eb:	e8 c0 c2 ff ff       	call   801018b0 <iput>
801055f0:	e8 db d7 ff ff       	call   80102dd0 <end_op>
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	31 c0                	xor    %eax,%eax
801055fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055fd:	5b                   	pop    %ebx
801055fe:	5e                   	pop    %esi
801055ff:	5f                   	pop    %edi
80105600:	5d                   	pop    %ebp
80105601:	c3                   	ret    
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	56                   	push   %esi
8010560c:	e8 ff c3 ff ff       	call   80101a10 <iunlockput>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	83 ec 0c             	sub    $0xc,%esp
80105617:	53                   	push   %ebx
80105618:	e8 63 c1 ff ff       	call   80101780 <ilock>
8010561d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80105622:	89 1c 24             	mov    %ebx,(%esp)
80105625:	e8 a6 c0 ff ff       	call   801016d0 <iupdate>
8010562a:	89 1c 24             	mov    %ebx,(%esp)
8010562d:	e8 de c3 ff ff       	call   80101a10 <iunlockput>
80105632:	e8 99 d7 ff ff       	call   80102dd0 <end_op>
80105637:	83 c4 10             	add    $0x10,%esp
8010563a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563f:	eb b9                	jmp    801055fa <sys_link+0xda>
80105641:	83 ec 0c             	sub    $0xc,%esp
80105644:	53                   	push   %ebx
80105645:	e8 c6 c3 ff ff       	call   80101a10 <iunlockput>
8010564a:	e8 81 d7 ff ff       	call   80102dd0 <end_op>
8010564f:	83 c4 10             	add    $0x10,%esp
80105652:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105657:	eb a1                	jmp    801055fa <sys_link+0xda>
80105659:	e8 72 d7 ff ff       	call   80102dd0 <end_op>
8010565e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105663:	eb 95                	jmp    801055fa <sys_link+0xda>
80105665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_unlink>:
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
80105675:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105678:	53                   	push   %ebx
80105679:	83 ec 54             	sub    $0x54,%esp
8010567c:	50                   	push   %eax
8010567d:	6a 00                	push   $0x0
8010567f:	e8 bc f9 ff ff       	call   80105040 <argstr>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	85 c0                	test   %eax,%eax
80105689:	0f 88 7a 01 00 00    	js     80105809 <sys_unlink+0x199>
8010568f:	e8 cc d6 ff ff       	call   80102d60 <begin_op>
80105694:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105697:	83 ec 08             	sub    $0x8,%esp
8010569a:	53                   	push   %ebx
8010569b:	ff 75 c0             	push   -0x40(%ebp)
8010569e:	e8 1d ca ff ff       	call   801020c0 <nameiparent>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056a9:	85 c0                	test   %eax,%eax
801056ab:	0f 84 62 01 00 00    	je     80105813 <sys_unlink+0x1a3>
801056b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	57                   	push   %edi
801056b8:	e8 c3 c0 ff ff       	call   80101780 <ilock>
801056bd:	58                   	pop    %eax
801056be:	5a                   	pop    %edx
801056bf:	68 34 81 10 80       	push   $0x80108134
801056c4:	53                   	push   %ebx
801056c5:	e8 f6 c5 ff ff       	call   80101cc0 <namecmp>
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	85 c0                	test   %eax,%eax
801056cf:	0f 84 fb 00 00 00    	je     801057d0 <sys_unlink+0x160>
801056d5:	83 ec 08             	sub    $0x8,%esp
801056d8:	68 33 81 10 80       	push   $0x80108133
801056dd:	53                   	push   %ebx
801056de:	e8 dd c5 ff ff       	call   80101cc0 <namecmp>
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	0f 84 e2 00 00 00    	je     801057d0 <sys_unlink+0x160>
801056ee:	83 ec 04             	sub    $0x4,%esp
801056f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056f4:	50                   	push   %eax
801056f5:	53                   	push   %ebx
801056f6:	57                   	push   %edi
801056f7:	e8 e4 c5 ff ff       	call   80101ce0 <dirlookup>
801056fc:	83 c4 10             	add    $0x10,%esp
801056ff:	89 c3                	mov    %eax,%ebx
80105701:	85 c0                	test   %eax,%eax
80105703:	0f 84 c7 00 00 00    	je     801057d0 <sys_unlink+0x160>
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	50                   	push   %eax
8010570d:	e8 6e c0 ff ff       	call   80101780 <ilock>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010571a:	0f 8e 1c 01 00 00    	jle    8010583c <sys_unlink+0x1cc>
80105720:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105725:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105728:	74 66                	je     80105790 <sys_unlink+0x120>
8010572a:	83 ec 04             	sub    $0x4,%esp
8010572d:	6a 10                	push   $0x10
8010572f:	6a 00                	push   $0x0
80105731:	57                   	push   %edi
80105732:	e8 89 f5 ff ff       	call   80104cc0 <memset>
80105737:	6a 10                	push   $0x10
80105739:	ff 75 c4             	push   -0x3c(%ebp)
8010573c:	57                   	push   %edi
8010573d:	ff 75 b4             	push   -0x4c(%ebp)
80105740:	e8 4b c4 ff ff       	call   80101b90 <writei>
80105745:	83 c4 20             	add    $0x20,%esp
80105748:	83 f8 10             	cmp    $0x10,%eax
8010574b:	0f 85 de 00 00 00    	jne    8010582f <sys_unlink+0x1bf>
80105751:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105756:	0f 84 94 00 00 00    	je     801057f0 <sys_unlink+0x180>
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	ff 75 b4             	push   -0x4c(%ebp)
80105762:	e8 a9 c2 ff ff       	call   80101a10 <iunlockput>
80105767:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
8010576c:	89 1c 24             	mov    %ebx,(%esp)
8010576f:	e8 5c bf ff ff       	call   801016d0 <iupdate>
80105774:	89 1c 24             	mov    %ebx,(%esp)
80105777:	e8 94 c2 ff ff       	call   80101a10 <iunlockput>
8010577c:	e8 4f d6 ff ff       	call   80102dd0 <end_op>
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	31 c0                	xor    %eax,%eax
80105786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105789:	5b                   	pop    %ebx
8010578a:	5e                   	pop    %esi
8010578b:	5f                   	pop    %edi
8010578c:	5d                   	pop    %ebp
8010578d:	c3                   	ret    
8010578e:	66 90                	xchg   %ax,%ax
80105790:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105794:	76 94                	jbe    8010572a <sys_unlink+0xba>
80105796:	be 20 00 00 00       	mov    $0x20,%esi
8010579b:	eb 0b                	jmp    801057a8 <sys_unlink+0x138>
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
801057a0:	83 c6 10             	add    $0x10,%esi
801057a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801057a6:	73 82                	jae    8010572a <sys_unlink+0xba>
801057a8:	6a 10                	push   $0x10
801057aa:	56                   	push   %esi
801057ab:	57                   	push   %edi
801057ac:	53                   	push   %ebx
801057ad:	e8 de c2 ff ff       	call   80101a90 <readi>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	83 f8 10             	cmp    $0x10,%eax
801057b8:	75 68                	jne    80105822 <sys_unlink+0x1b2>
801057ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057bf:	74 df                	je     801057a0 <sys_unlink+0x130>
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	53                   	push   %ebx
801057c5:	e8 46 c2 ff ff       	call   80101a10 <iunlockput>
801057ca:	83 c4 10             	add    $0x10,%esp
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	ff 75 b4             	push   -0x4c(%ebp)
801057d6:	e8 35 c2 ff ff       	call   80101a10 <iunlockput>
801057db:	e8 f0 d5 ff ff       	call   80102dd0 <end_op>
801057e0:	83 c4 10             	add    $0x10,%esp
801057e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e8:	eb 9c                	jmp    80105786 <sys_unlink+0x116>
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801057f3:	83 ec 0c             	sub    $0xc,%esp
801057f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
801057fb:	50                   	push   %eax
801057fc:	e8 cf be ff ff       	call   801016d0 <iupdate>
80105801:	83 c4 10             	add    $0x10,%esp
80105804:	e9 53 ff ff ff       	jmp    8010575c <sys_unlink+0xec>
80105809:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580e:	e9 73 ff ff ff       	jmp    80105786 <sys_unlink+0x116>
80105813:	e8 b8 d5 ff ff       	call   80102dd0 <end_op>
80105818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581d:	e9 64 ff ff ff       	jmp    80105786 <sys_unlink+0x116>
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	68 58 81 10 80       	push   $0x80108158
8010582a:	e8 51 ab ff ff       	call   80100380 <panic>
8010582f:	83 ec 0c             	sub    $0xc,%esp
80105832:	68 6a 81 10 80       	push   $0x8010816a
80105837:	e8 44 ab ff ff       	call   80100380 <panic>
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	68 46 81 10 80       	push   $0x80108146
80105844:	e8 37 ab ff ff       	call   80100380 <panic>
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_open>:
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
80105855:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105858:	53                   	push   %ebx
80105859:	83 ec 24             	sub    $0x24,%esp
8010585c:	50                   	push   %eax
8010585d:	6a 00                	push   $0x0
8010585f:	e8 dc f7 ff ff       	call   80105040 <argstr>
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	85 c0                	test   %eax,%eax
80105869:	0f 88 8e 00 00 00    	js     801058fd <sys_open+0xad>
8010586f:	83 ec 08             	sub    $0x8,%esp
80105872:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105875:	50                   	push   %eax
80105876:	6a 01                	push   $0x1
80105878:	e8 03 f7 ff ff       	call   80104f80 <argint>
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	85 c0                	test   %eax,%eax
80105882:	78 79                	js     801058fd <sys_open+0xad>
80105884:	e8 d7 d4 ff ff       	call   80102d60 <begin_op>
80105889:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010588d:	75 79                	jne    80105908 <sys_open+0xb8>
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	ff 75 e0             	push   -0x20(%ebp)
80105895:	e8 06 c8 ff ff       	call   801020a0 <namei>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	89 c6                	mov    %eax,%esi
8010589f:	85 c0                	test   %eax,%eax
801058a1:	0f 84 7e 00 00 00    	je     80105925 <sys_open+0xd5>
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	50                   	push   %eax
801058ab:	e8 d0 be ff ff       	call   80101780 <ilock>
801058b0:	83 c4 10             	add    $0x10,%esp
801058b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058b8:	0f 84 c2 00 00 00    	je     80105980 <sys_open+0x130>
801058be:	e8 6d b5 ff ff       	call   80100e30 <filealloc>
801058c3:	89 c7                	mov    %eax,%edi
801058c5:	85 c0                	test   %eax,%eax
801058c7:	74 23                	je     801058ec <sys_open+0x9c>
801058c9:	e8 c2 e0 ff ff       	call   80103990 <myproc>
801058ce:	31 db                	xor    %ebx,%ebx
801058d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058d4:	85 d2                	test   %edx,%edx
801058d6:	74 60                	je     80105938 <sys_open+0xe8>
801058d8:	83 c3 01             	add    $0x1,%ebx
801058db:	83 fb 10             	cmp    $0x10,%ebx
801058de:	75 f0                	jne    801058d0 <sys_open+0x80>
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	57                   	push   %edi
801058e4:	e8 07 b6 ff ff       	call   80100ef0 <fileclose>
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	83 ec 0c             	sub    $0xc,%esp
801058ef:	56                   	push   %esi
801058f0:	e8 1b c1 ff ff       	call   80101a10 <iunlockput>
801058f5:	e8 d6 d4 ff ff       	call   80102dd0 <end_op>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105902:	eb 6d                	jmp    80105971 <sys_open+0x121>
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010590e:	31 c9                	xor    %ecx,%ecx
80105910:	ba 02 00 00 00       	mov    $0x2,%edx
80105915:	6a 00                	push   $0x0
80105917:	e8 14 f8 ff ff       	call   80105130 <create>
8010591c:	83 c4 10             	add    $0x10,%esp
8010591f:	89 c6                	mov    %eax,%esi
80105921:	85 c0                	test   %eax,%eax
80105923:	75 99                	jne    801058be <sys_open+0x6e>
80105925:	e8 a6 d4 ff ff       	call   80102dd0 <end_op>
8010592a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010592f:	eb 40                	jmp    80105971 <sys_open+0x121>
80105931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
8010593f:	56                   	push   %esi
80105940:	e8 1b bf ff ff       	call   80101860 <iunlock>
80105945:	e8 86 d4 ff ff       	call   80102dd0 <end_op>
8010594a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
80105950:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	89 77 10             	mov    %esi,0x10(%edi)
80105959:	89 d0                	mov    %edx,%eax
8010595b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
80105962:	f7 d0                	not    %eax
80105964:	83 e0 01             	and    $0x1,%eax
80105967:	83 e2 03             	and    $0x3,%edx
8010596a:	88 47 08             	mov    %al,0x8(%edi)
8010596d:	0f 95 47 09          	setne  0x9(%edi)
80105971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105974:	89 d8                	mov    %ebx,%eax
80105976:	5b                   	pop    %ebx
80105977:	5e                   	pop    %esi
80105978:	5f                   	pop    %edi
80105979:	5d                   	pop    %ebp
8010597a:	c3                   	ret    
8010597b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop
80105980:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105983:	85 c9                	test   %ecx,%ecx
80105985:	0f 84 33 ff ff ff    	je     801058be <sys_open+0x6e>
8010598b:	e9 5c ff ff ff       	jmp    801058ec <sys_open+0x9c>

80105990 <sys_mkdir>:
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 18             	sub    $0x18,%esp
80105996:	e8 c5 d3 ff ff       	call   80102d60 <begin_op>
8010599b:	83 ec 08             	sub    $0x8,%esp
8010599e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a1:	50                   	push   %eax
801059a2:	6a 00                	push   $0x0
801059a4:	e8 97 f6 ff ff       	call   80105040 <argstr>
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	85 c0                	test   %eax,%eax
801059ae:	78 30                	js     801059e0 <sys_mkdir+0x50>
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b6:	31 c9                	xor    %ecx,%ecx
801059b8:	ba 01 00 00 00       	mov    $0x1,%edx
801059bd:	6a 00                	push   $0x0
801059bf:	e8 6c f7 ff ff       	call   80105130 <create>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	85 c0                	test   %eax,%eax
801059c9:	74 15                	je     801059e0 <sys_mkdir+0x50>
801059cb:	83 ec 0c             	sub    $0xc,%esp
801059ce:	50                   	push   %eax
801059cf:	e8 3c c0 ff ff       	call   80101a10 <iunlockput>
801059d4:	e8 f7 d3 ff ff       	call   80102dd0 <end_op>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	31 c0                	xor    %eax,%eax
801059de:	c9                   	leave  
801059df:	c3                   	ret    
801059e0:	e8 eb d3 ff ff       	call   80102dd0 <end_op>
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ea:	c9                   	leave  
801059eb:	c3                   	ret    
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_mknod>:
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
801059f6:	e8 65 d3 ff ff       	call   80102d60 <begin_op>
801059fb:	83 ec 08             	sub    $0x8,%esp
801059fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	e8 37 f6 ff ff       	call   80105040 <argstr>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	78 60                	js     80105a70 <sys_mknod+0x80>
80105a10:	83 ec 08             	sub    $0x8,%esp
80105a13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a16:	50                   	push   %eax
80105a17:	6a 01                	push   $0x1
80105a19:	e8 62 f5 ff ff       	call   80104f80 <argint>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	85 c0                	test   %eax,%eax
80105a23:	78 4b                	js     80105a70 <sys_mknod+0x80>
80105a25:	83 ec 08             	sub    $0x8,%esp
80105a28:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a2b:	50                   	push   %eax
80105a2c:	6a 02                	push   $0x2
80105a2e:	e8 4d f5 ff ff       	call   80104f80 <argint>
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 c0                	test   %eax,%eax
80105a38:	78 36                	js     80105a70 <sys_mknod+0x80>
80105a3a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a3e:	83 ec 0c             	sub    $0xc,%esp
80105a41:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a45:	ba 03 00 00 00       	mov    $0x3,%edx
80105a4a:	50                   	push   %eax
80105a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a4e:	e8 dd f6 ff ff       	call   80105130 <create>
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	85 c0                	test   %eax,%eax
80105a58:	74 16                	je     80105a70 <sys_mknod+0x80>
80105a5a:	83 ec 0c             	sub    $0xc,%esp
80105a5d:	50                   	push   %eax
80105a5e:	e8 ad bf ff ff       	call   80101a10 <iunlockput>
80105a63:	e8 68 d3 ff ff       	call   80102dd0 <end_op>
80105a68:	83 c4 10             	add    $0x10,%esp
80105a6b:	31 c0                	xor    %eax,%eax
80105a6d:	c9                   	leave  
80105a6e:	c3                   	ret    
80105a6f:	90                   	nop
80105a70:	e8 5b d3 ff ff       	call   80102dd0 <end_op>
80105a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7a:	c9                   	leave  
80105a7b:	c3                   	ret    
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_chdir>:
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	56                   	push   %esi
80105a84:	53                   	push   %ebx
80105a85:	83 ec 10             	sub    $0x10,%esp
80105a88:	e8 03 df ff ff       	call   80103990 <myproc>
80105a8d:	89 c6                	mov    %eax,%esi
80105a8f:	e8 cc d2 ff ff       	call   80102d60 <begin_op>
80105a94:	83 ec 08             	sub    $0x8,%esp
80105a97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 9e f5 ff ff       	call   80105040 <argstr>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	78 77                	js     80105b20 <sys_chdir+0xa0>
80105aa9:	83 ec 0c             	sub    $0xc,%esp
80105aac:	ff 75 f4             	push   -0xc(%ebp)
80105aaf:	e8 ec c5 ff ff       	call   801020a0 <namei>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	89 c3                	mov    %eax,%ebx
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	74 63                	je     80105b20 <sys_chdir+0xa0>
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	50                   	push   %eax
80105ac1:	e8 ba bc ff ff       	call   80101780 <ilock>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ace:	75 30                	jne    80105b00 <sys_chdir+0x80>
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	53                   	push   %ebx
80105ad4:	e8 87 bd ff ff       	call   80101860 <iunlock>
80105ad9:	58                   	pop    %eax
80105ada:	ff 76 68             	push   0x68(%esi)
80105add:	e8 ce bd ff ff       	call   801018b0 <iput>
80105ae2:	e8 e9 d2 ff ff       	call   80102dd0 <end_op>
80105ae7:	89 5e 68             	mov    %ebx,0x68(%esi)
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	31 c0                	xor    %eax,%eax
80105aef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105af2:	5b                   	pop    %ebx
80105af3:	5e                   	pop    %esi
80105af4:	5d                   	pop    %ebp
80105af5:	c3                   	ret    
80105af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afd:	8d 76 00             	lea    0x0(%esi),%esi
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 07 bf ff ff       	call   80101a10 <iunlockput>
80105b09:	e8 c2 d2 ff ff       	call   80102dd0 <end_op>
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b16:	eb d7                	jmp    80105aef <sys_chdir+0x6f>
80105b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
80105b20:	e8 ab d2 ff ff       	call   80102dd0 <end_op>
80105b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2a:	eb c3                	jmp    80105aef <sys_chdir+0x6f>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_exec>:
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
80105b35:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105b3b:	53                   	push   %ebx
80105b3c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
80105b42:	50                   	push   %eax
80105b43:	6a 00                	push   $0x0
80105b45:	e8 f6 f4 ff ff       	call   80105040 <argstr>
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	0f 88 87 00 00 00    	js     80105bdc <sys_exec+0xac>
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b5e:	50                   	push   %eax
80105b5f:	6a 01                	push   $0x1
80105b61:	e8 1a f4 ff ff       	call   80104f80 <argint>
80105b66:	83 c4 10             	add    $0x10,%esp
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	78 6f                	js     80105bdc <sys_exec+0xac>
80105b6d:	83 ec 04             	sub    $0x4,%esp
80105b70:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105b76:	31 db                	xor    %ebx,%ebx
80105b78:	68 80 00 00 00       	push   $0x80
80105b7d:	6a 00                	push   $0x0
80105b7f:	56                   	push   %esi
80105b80:	e8 3b f1 ff ff       	call   80104cc0 <memset>
80105b85:	83 c4 10             	add    $0x10,%esp
80105b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
80105b90:	83 ec 08             	sub    $0x8,%esp
80105b93:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105b99:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105ba0:	50                   	push   %eax
80105ba1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ba7:	01 f8                	add    %edi,%eax
80105ba9:	50                   	push   %eax
80105baa:	e8 41 f3 ff ff       	call   80104ef0 <fetchint>
80105baf:	83 c4 10             	add    $0x10,%esp
80105bb2:	85 c0                	test   %eax,%eax
80105bb4:	78 26                	js     80105bdc <sys_exec+0xac>
80105bb6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bbc:	85 c0                	test   %eax,%eax
80105bbe:	74 30                	je     80105bf0 <sys_exec+0xc0>
80105bc0:	83 ec 08             	sub    $0x8,%esp
80105bc3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105bc6:	52                   	push   %edx
80105bc7:	50                   	push   %eax
80105bc8:	e8 63 f3 ff ff       	call   80104f30 <fetchstr>
80105bcd:	83 c4 10             	add    $0x10,%esp
80105bd0:	85 c0                	test   %eax,%eax
80105bd2:	78 08                	js     80105bdc <sys_exec+0xac>
80105bd4:	83 c3 01             	add    $0x1,%ebx
80105bd7:	83 fb 20             	cmp    $0x20,%ebx
80105bda:	75 b4                	jne    80105b90 <sys_exec+0x60>
80105bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be4:	5b                   	pop    %ebx
80105be5:	5e                   	pop    %esi
80105be6:	5f                   	pop    %edi
80105be7:	5d                   	pop    %ebp
80105be8:	c3                   	ret    
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bf0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bf7:	00 00 00 00 
80105bfb:	83 ec 08             	sub    $0x8,%esp
80105bfe:	56                   	push   %esi
80105bff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c05:	e8 a6 ae ff ff       	call   80100ab0 <exec>
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c10:	5b                   	pop    %ebx
80105c11:	5e                   	pop    %esi
80105c12:	5f                   	pop    %edi
80105c13:	5d                   	pop    %ebp
80105c14:	c3                   	ret    
80105c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c20 <sys_pipe>:
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	57                   	push   %edi
80105c24:	56                   	push   %esi
80105c25:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c28:	53                   	push   %ebx
80105c29:	83 ec 20             	sub    $0x20,%esp
80105c2c:	6a 08                	push   $0x8
80105c2e:	50                   	push   %eax
80105c2f:	6a 00                	push   $0x0
80105c31:	e8 9a f3 ff ff       	call   80104fd0 <argptr>
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	78 4a                	js     80105c87 <sys_pipe+0x67>
80105c3d:	83 ec 08             	sub    $0x8,%esp
80105c40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c43:	50                   	push   %eax
80105c44:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c47:	50                   	push   %eax
80105c48:	e8 e3 d7 ff ff       	call   80103430 <pipealloc>
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	85 c0                	test   %eax,%eax
80105c52:	78 33                	js     80105c87 <sys_pipe+0x67>
80105c54:	8b 7d e0             	mov    -0x20(%ebp),%edi
80105c57:	31 db                	xor    %ebx,%ebx
80105c59:	e8 32 dd ff ff       	call   80103990 <myproc>
80105c5e:	66 90                	xchg   %ax,%ax
80105c60:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c64:	85 f6                	test   %esi,%esi
80105c66:	74 28                	je     80105c90 <sys_pipe+0x70>
80105c68:	83 c3 01             	add    $0x1,%ebx
80105c6b:	83 fb 10             	cmp    $0x10,%ebx
80105c6e:	75 f0                	jne    80105c60 <sys_pipe+0x40>
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	ff 75 e0             	push   -0x20(%ebp)
80105c76:	e8 75 b2 ff ff       	call   80100ef0 <fileclose>
80105c7b:	58                   	pop    %eax
80105c7c:	ff 75 e4             	push   -0x1c(%ebp)
80105c7f:	e8 6c b2 ff ff       	call   80100ef0 <fileclose>
80105c84:	83 c4 10             	add    $0x10,%esp
80105c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8c:	eb 53                	jmp    80105ce1 <sys_pipe+0xc1>
80105c8e:	66 90                	xchg   %ax,%ax
80105c90:	8d 73 08             	lea    0x8(%ebx),%esi
80105c93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
80105c97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105c9a:	e8 f1 dc ff ff       	call   80103990 <myproc>
80105c9f:	31 d2                	xor    %edx,%edx
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ca8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cac:	85 c9                	test   %ecx,%ecx
80105cae:	74 20                	je     80105cd0 <sys_pipe+0xb0>
80105cb0:	83 c2 01             	add    $0x1,%edx
80105cb3:	83 fa 10             	cmp    $0x10,%edx
80105cb6:	75 f0                	jne    80105ca8 <sys_pipe+0x88>
80105cb8:	e8 d3 dc ff ff       	call   80103990 <myproc>
80105cbd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105cc4:	00 
80105cc5:	eb a9                	jmp    80105c70 <sys_pipe+0x50>
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax
80105cd0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
80105cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cd7:	89 18                	mov    %ebx,(%eax)
80105cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cdc:	89 50 04             	mov    %edx,0x4(%eax)
80105cdf:	31 c0                	xor    %eax,%eax
80105ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce4:	5b                   	pop    %ebx
80105ce5:	5e                   	pop    %esi
80105ce6:	5f                   	pop    %edi
80105ce7:	5d                   	pop    %ebp
80105ce8:	c3                   	ret    
80105ce9:	66 90                	xchg   %ax,%ax
80105ceb:	66 90                	xchg   %ax,%ax
80105ced:	66 90                	xchg   %ax,%ax
80105cef:	90                   	nop

80105cf0 <sys_fork>:
80105cf0:	e9 3b de ff ff       	jmp    80103b30 <fork>
80105cf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_exit>:
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 08             	sub    $0x8,%esp
80105d06:	e8 d5 e0 ff ff       	call   80103de0 <exit>
80105d0b:	31 c0                	xor    %eax,%eax
80105d0d:	c9                   	leave  
80105d0e:	c3                   	ret    
80105d0f:	90                   	nop

80105d10 <sys_wait>:
80105d10:	e9 fb e1 ff ff       	jmp    80103f10 <wait>
80105d15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_kill>:
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 20             	sub    $0x20,%esp
80105d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 4f f2 ff ff       	call   80104f80 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 18                	js     80105d50 <sys_kill+0x30>
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 f4             	push   -0xc(%ebp)
80105d3e:	e8 6d e4 ff ff       	call   801041b0 <kill>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	c9                   	leave  
80105d47:	c3                   	ret    
80105d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4f:	90                   	nop
80105d50:	c9                   	leave  
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	c3                   	ret    
80105d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <sys_getpid>:
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 08             	sub    $0x8,%esp
80105d66:	e8 25 dc ff ff       	call   80103990 <myproc>
80105d6b:	8b 40 10             	mov    0x10(%eax),%eax
80105d6e:	c9                   	leave  
80105d6f:	c3                   	ret    

80105d70 <sys_sbrk>:
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
80105d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d77:	83 ec 1c             	sub    $0x1c,%esp
80105d7a:	50                   	push   %eax
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 fe f1 ff ff       	call   80104f80 <argint>
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	85 c0                	test   %eax,%eax
80105d87:	78 27                	js     80105db0 <sys_sbrk+0x40>
80105d89:	e8 02 dc ff ff       	call   80103990 <myproc>
80105d8e:	83 ec 0c             	sub    $0xc,%esp
80105d91:	8b 18                	mov    (%eax),%ebx
80105d93:	ff 75 f4             	push   -0xc(%ebp)
80105d96:	e8 15 dd ff ff       	call   80103ab0 <growproc>
80105d9b:	83 c4 10             	add    $0x10,%esp
80105d9e:	85 c0                	test   %eax,%eax
80105da0:	78 0e                	js     80105db0 <sys_sbrk+0x40>
80105da2:	89 d8                	mov    %ebx,%eax
80105da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da7:	c9                   	leave  
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105db0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105db5:	eb eb                	jmp    80105da2 <sys_sbrk+0x32>
80105db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <sys_sleep>:
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 ae f1 ff ff       	call   80104f80 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 88 8a 00 00 00    	js     80105e67 <sys_sleep+0xa7>
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 80 4f 11 80       	push   $0x80114f80
80105de5:	e8 16 ee ff ff       	call   80104c00 <acquire>
80105dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ded:	8b 1d 60 4f 11 80    	mov    0x80114f60,%ebx
80105df3:	83 c4 10             	add    $0x10,%esp
80105df6:	85 d2                	test   %edx,%edx
80105df8:	75 27                	jne    80105e21 <sys_sleep+0x61>
80105dfa:	eb 54                	jmp    80105e50 <sys_sleep+0x90>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	68 80 4f 11 80       	push   $0x80114f80
80105e08:	68 60 4f 11 80       	push   $0x80114f60
80105e0d:	e8 7e e2 ff ff       	call   80104090 <sleep>
80105e12:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	29 d8                	sub    %ebx,%eax
80105e1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e1f:	73 2f                	jae    80105e50 <sys_sleep+0x90>
80105e21:	e8 6a db ff ff       	call   80103990 <myproc>
80105e26:	8b 40 24             	mov    0x24(%eax),%eax
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	74 d3                	je     80105e00 <sys_sleep+0x40>
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 80 4f 11 80       	push   $0x80114f80
80105e35:	e8 66 ed ff ff       	call   80104ba0 <release>
80105e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4e:	66 90                	xchg   %ax,%ax
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 80 4f 11 80       	push   $0x80114f80
80105e58:	e8 43 ed ff ff       	call   80104ba0 <release>
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	31 c0                	xor    %eax,%eax
80105e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e65:	c9                   	leave  
80105e66:	c3                   	ret    
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	eb f4                	jmp    80105e62 <sys_sleep+0xa2>
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_uptime>:
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	53                   	push   %ebx
80105e74:	83 ec 10             	sub    $0x10,%esp
80105e77:	68 80 4f 11 80       	push   $0x80114f80
80105e7c:	e8 7f ed ff ff       	call   80104c00 <acquire>
80105e81:	8b 1d 60 4f 11 80    	mov    0x80114f60,%ebx
80105e87:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105e8e:	e8 0d ed ff ff       	call   80104ba0 <release>
80105e93:	89 d8                	mov    %ebx,%eax
80105e95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e98:	c9                   	leave  
80105e99:	c3                   	ret    
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ea0 <sys_cps>:
80105ea0:	e9 4b e4 ff ff       	jmp    801042f0 <cps>
80105ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_calls>:
80105eb0:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80105eb5:	83 f8 ff             	cmp    $0xffffffff,%eax
80105eb8:	74 03                	je     80105ebd <sys_calls+0xd>
80105eba:	83 c0 01             	add    $0x1,%eax
80105ebd:	c3                   	ret    
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_get_process_type>:
80105ec0:	e9 eb e4 ff ff       	jmp    801043b0 <get_process_type>
80105ec5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <sys_wait_pid>:
80105ed0:	e9 bb e5 ff ff       	jmp    80104490 <wait_pid>
80105ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_unwait_pid>:
80105ee0:	e9 6b e7 ff ff       	jmp    80104650 <unwait_pid>
80105ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_mem_usage>:
80105ef0:	e9 5b e8 ff ff       	jmp    80104750 <mem_usage>
80105ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_get_priority>:
80105f00:	e9 db e8 ff ff       	jmp    801047e0 <get_priority>
80105f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_set_priority>:
80105f10:	e9 5b e9 ff ff       	jmp    80104870 <set_priority>

80105f15 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f15:	1e                   	push   %ds
  pushl %es
80105f16:	06                   	push   %es
  pushl %fs
80105f17:	0f a0                	push   %fs
  pushl %gs
80105f19:	0f a8                	push   %gs
  pushal
80105f1b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f1c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f20:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f22:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f24:	54                   	push   %esp
  call trap
80105f25:	e8 c6 00 00 00       	call   80105ff0 <trap>
  addl $4, %esp
80105f2a:	83 c4 04             	add    $0x4,%esp

80105f2d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f2d:	61                   	popa   
  popl %gs
80105f2e:	0f a9                	pop    %gs
  popl %fs
80105f30:	0f a1                	pop    %fs
  popl %es
80105f32:	07                   	pop    %es
  popl %ds
80105f33:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f34:	83 c4 08             	add    $0x8,%esp
  iret
80105f37:	cf                   	iret   
80105f38:	66 90                	xchg   %ax,%ax
80105f3a:	66 90                	xchg   %ax,%ax
80105f3c:	66 90                	xchg   %ax,%ax
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <tvinit>:
80105f40:	55                   	push   %ebp
80105f41:	31 c0                	xor    %eax,%eax
80105f43:	89 e5                	mov    %esp,%ebp
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
80105f50:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105f57:	c7 04 c5 c2 4f 11 80 	movl   $0x8e000008,-0x7feeb03e(,%eax,8)
80105f5e:	08 00 00 8e 
80105f62:	66 89 14 c5 c0 4f 11 	mov    %dx,-0x7feeb040(,%eax,8)
80105f69:	80 
80105f6a:	c1 ea 10             	shr    $0x10,%edx
80105f6d:	66 89 14 c5 c6 4f 11 	mov    %dx,-0x7feeb03a(,%eax,8)
80105f74:	80 
80105f75:	83 c0 01             	add    $0x1,%eax
80105f78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f7d:	75 d1                	jne    80105f50 <tvinit+0x10>
80105f7f:	83 ec 08             	sub    $0x8,%esp
80105f82:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80105f87:	c7 05 c2 51 11 80 08 	movl   $0xef000008,0x801151c2
80105f8e:	00 00 ef 
80105f91:	68 79 81 10 80       	push   $0x80108179
80105f96:	68 80 4f 11 80       	push   $0x80114f80
80105f9b:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
80105fa1:	c1 e8 10             	shr    $0x10,%eax
80105fa4:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6
80105faa:	e8 81 ea ff ff       	call   80104a30 <initlock>
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	c9                   	leave  
80105fb3:	c3                   	ret    
80105fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop

80105fc0 <idtinit>:
80105fc0:	55                   	push   %ebp
80105fc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fc6:	89 e5                	mov    %esp,%ebp
80105fc8:	83 ec 10             	sub    $0x10,%esp
80105fcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80105fcf:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
80105fd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105fd8:	c1 e8 10             	shr    $0x10,%eax
80105fdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80105fdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fe2:	0f 01 18             	lidtl  (%eax)
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <trap>:
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	53                   	push   %ebx
80105ff6:	83 ec 1c             	sub    $0x1c,%esp
80105ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105ffc:	8b 43 30             	mov    0x30(%ebx),%eax
80105fff:	83 f8 40             	cmp    $0x40,%eax
80106002:	0f 84 68 01 00 00    	je     80106170 <trap+0x180>
80106008:	83 e8 20             	sub    $0x20,%eax
8010600b:	83 f8 1f             	cmp    $0x1f,%eax
8010600e:	0f 87 8c 00 00 00    	ja     801060a0 <trap+0xb0>
80106014:	ff 24 85 20 82 10 80 	jmp    *-0x7fef7de0(,%eax,4)
8010601b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010601f:	90                   	nop
80106020:	e8 1b c2 ff ff       	call   80102240 <ideintr>
80106025:	e8 e6 c8 ff ff       	call   80102910 <lapiceoi>
8010602a:	e8 61 d9 ff ff       	call   80103990 <myproc>
8010602f:	85 c0                	test   %eax,%eax
80106031:	74 1d                	je     80106050 <trap+0x60>
80106033:	e8 58 d9 ff ff       	call   80103990 <myproc>
80106038:	8b 50 24             	mov    0x24(%eax),%edx
8010603b:	85 d2                	test   %edx,%edx
8010603d:	74 11                	je     80106050 <trap+0x60>
8010603f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106043:	83 e0 03             	and    $0x3,%eax
80106046:	66 83 f8 03          	cmp    $0x3,%ax
8010604a:	0f 84 d0 01 00 00    	je     80106220 <trap+0x230>
80106050:	e8 3b d9 ff ff       	call   80103990 <myproc>
80106055:	85 c0                	test   %eax,%eax
80106057:	74 0f                	je     80106068 <trap+0x78>
80106059:	e8 32 d9 ff ff       	call   80103990 <myproc>
8010605e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106062:	0f 84 b8 00 00 00    	je     80106120 <trap+0x130>
80106068:	e8 23 d9 ff ff       	call   80103990 <myproc>
8010606d:	85 c0                	test   %eax,%eax
8010606f:	74 1d                	je     8010608e <trap+0x9e>
80106071:	e8 1a d9 ff ff       	call   80103990 <myproc>
80106076:	8b 40 24             	mov    0x24(%eax),%eax
80106079:	85 c0                	test   %eax,%eax
8010607b:	74 11                	je     8010608e <trap+0x9e>
8010607d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106081:	83 e0 03             	and    $0x3,%eax
80106084:	66 83 f8 03          	cmp    $0x3,%ax
80106088:	0f 84 0f 01 00 00    	je     8010619d <trap+0x1ad>
8010608e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106091:	5b                   	pop    %ebx
80106092:	5e                   	pop    %esi
80106093:	5f                   	pop    %edi
80106094:	5d                   	pop    %ebp
80106095:	c3                   	ret    
80106096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
801060a0:	e8 eb d8 ff ff       	call   80103990 <myproc>
801060a5:	8b 7b 38             	mov    0x38(%ebx),%edi
801060a8:	85 c0                	test   %eax,%eax
801060aa:	0f 84 c2 01 00 00    	je     80106272 <trap+0x282>
801060b0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060b4:	0f 84 b8 01 00 00    	je     80106272 <trap+0x282>
801060ba:	0f 20 d1             	mov    %cr2,%ecx
801060bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801060c0:	e8 ab d8 ff ff       	call   80103970 <cpuid>
801060c5:	8b 73 30             	mov    0x30(%ebx),%esi
801060c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060cb:	8b 43 34             	mov    0x34(%ebx),%eax
801060ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060d1:	e8 ba d8 ff ff       	call   80103990 <myproc>
801060d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060d9:	e8 b2 d8 ff ff       	call   80103990 <myproc>
801060de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060e4:	51                   	push   %ecx
801060e5:	57                   	push   %edi
801060e6:	52                   	push   %edx
801060e7:	ff 75 e4             	push   -0x1c(%ebp)
801060ea:	56                   	push   %esi
801060eb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060ee:	83 c6 6c             	add    $0x6c,%esi
801060f1:	56                   	push   %esi
801060f2:	ff 70 10             	push   0x10(%eax)
801060f5:	68 dc 81 10 80       	push   $0x801081dc
801060fa:	e8 a1 a5 ff ff       	call   801006a0 <cprintf>
801060ff:	83 c4 20             	add    $0x20,%esp
80106102:	e8 89 d8 ff ff       	call   80103990 <myproc>
80106107:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010610e:	e8 7d d8 ff ff       	call   80103990 <myproc>
80106113:	85 c0                	test   %eax,%eax
80106115:	0f 85 18 ff ff ff    	jne    80106033 <trap+0x43>
8010611b:	e9 30 ff ff ff       	jmp    80106050 <trap+0x60>
80106120:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106124:	0f 85 3e ff ff ff    	jne    80106068 <trap+0x78>
8010612a:	e8 11 df ff ff       	call   80104040 <yield>
8010612f:	e9 34 ff ff ff       	jmp    80106068 <trap+0x78>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106138:	8b 7b 38             	mov    0x38(%ebx),%edi
8010613b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010613f:	e8 2c d8 ff ff       	call   80103970 <cpuid>
80106144:	57                   	push   %edi
80106145:	56                   	push   %esi
80106146:	50                   	push   %eax
80106147:	68 84 81 10 80       	push   $0x80108184
8010614c:	e8 4f a5 ff ff       	call   801006a0 <cprintf>
80106151:	e8 ba c7 ff ff       	call   80102910 <lapiceoi>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	e8 32 d8 ff ff       	call   80103990 <myproc>
8010615e:	85 c0                	test   %eax,%eax
80106160:	0f 85 cd fe ff ff    	jne    80106033 <trap+0x43>
80106166:	e9 e5 fe ff ff       	jmp    80106050 <trap+0x60>
8010616b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop
80106170:	e8 1b d8 ff ff       	call   80103990 <myproc>
80106175:	8b 70 24             	mov    0x24(%eax),%esi
80106178:	85 f6                	test   %esi,%esi
8010617a:	0f 85 e8 00 00 00    	jne    80106268 <trap+0x278>
80106180:	e8 0b d8 ff ff       	call   80103990 <myproc>
80106185:	89 58 18             	mov    %ebx,0x18(%eax)
80106188:	e8 33 ef ff ff       	call   801050c0 <syscall>
8010618d:	e8 fe d7 ff ff       	call   80103990 <myproc>
80106192:	8b 48 24             	mov    0x24(%eax),%ecx
80106195:	85 c9                	test   %ecx,%ecx
80106197:	0f 84 f1 fe ff ff    	je     8010608e <trap+0x9e>
8010619d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a0:	5b                   	pop    %ebx
801061a1:	5e                   	pop    %esi
801061a2:	5f                   	pop    %edi
801061a3:	5d                   	pop    %ebp
801061a4:	e9 37 dc ff ff       	jmp    80103de0 <exit>
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061b0:	e8 5b 02 00 00       	call   80106410 <uartintr>
801061b5:	e8 56 c7 ff ff       	call   80102910 <lapiceoi>
801061ba:	e8 d1 d7 ff ff       	call   80103990 <myproc>
801061bf:	85 c0                	test   %eax,%eax
801061c1:	0f 85 6c fe ff ff    	jne    80106033 <trap+0x43>
801061c7:	e9 84 fe ff ff       	jmp    80106050 <trap+0x60>
801061cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061d0:	e8 fb c5 ff ff       	call   801027d0 <kbdintr>
801061d5:	e8 36 c7 ff ff       	call   80102910 <lapiceoi>
801061da:	e8 b1 d7 ff ff       	call   80103990 <myproc>
801061df:	85 c0                	test   %eax,%eax
801061e1:	0f 85 4c fe ff ff    	jne    80106033 <trap+0x43>
801061e7:	e9 64 fe ff ff       	jmp    80106050 <trap+0x60>
801061ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061f0:	e8 7b d7 ff ff       	call   80103970 <cpuid>
801061f5:	85 c0                	test   %eax,%eax
801061f7:	74 37                	je     80106230 <trap+0x240>
801061f9:	e8 92 d7 ff ff       	call   80103990 <myproc>
801061fe:	85 c0                	test   %eax,%eax
80106200:	0f 84 1f fe ff ff    	je     80106025 <trap+0x35>
80106206:	e8 85 d7 ff ff       	call   80103990 <myproc>
8010620b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010620f:	0f 85 10 fe ff ff    	jne    80106025 <trap+0x35>
80106215:	e8 26 de ff ff       	call   80104040 <yield>
8010621a:	e9 06 fe ff ff       	jmp    80106025 <trap+0x35>
8010621f:	90                   	nop
80106220:	e8 bb db ff ff       	call   80103de0 <exit>
80106225:	e9 26 fe ff ff       	jmp    80106050 <trap+0x60>
8010622a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106230:	83 ec 0c             	sub    $0xc,%esp
80106233:	68 80 4f 11 80       	push   $0x80114f80
80106238:	e8 c3 e9 ff ff       	call   80104c00 <acquire>
8010623d:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80106244:	83 05 60 4f 11 80 01 	addl   $0x1,0x80114f60
8010624b:	e8 00 df ff ff       	call   80104150 <wakeup>
80106250:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80106257:	e8 44 e9 ff ff       	call   80104ba0 <release>
8010625c:	83 c4 10             	add    $0x10,%esp
8010625f:	eb 98                	jmp    801061f9 <trap+0x209>
80106261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106268:	e8 73 db ff ff       	call   80103de0 <exit>
8010626d:	e9 0e ff ff ff       	jmp    80106180 <trap+0x190>
80106272:	0f 20 d6             	mov    %cr2,%esi
80106275:	e8 f6 d6 ff ff       	call   80103970 <cpuid>
8010627a:	83 ec 0c             	sub    $0xc,%esp
8010627d:	56                   	push   %esi
8010627e:	57                   	push   %edi
8010627f:	50                   	push   %eax
80106280:	ff 73 30             	push   0x30(%ebx)
80106283:	68 a8 81 10 80       	push   $0x801081a8
80106288:	e8 13 a4 ff ff       	call   801006a0 <cprintf>
8010628d:	83 c4 14             	add    $0x14,%esp
80106290:	68 7e 81 10 80       	push   $0x8010817e
80106295:	e8 e6 a0 ff ff       	call   80100380 <panic>
8010629a:	66 90                	xchg   %ax,%ax
8010629c:	66 90                	xchg   %ax,%ax
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <uartgetc>:
801062a0:	a1 c0 57 11 80       	mov    0x801157c0,%eax
801062a5:	85 c0                	test   %eax,%eax
801062a7:	74 17                	je     801062c0 <uartgetc+0x20>
801062a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062ae:	ec                   	in     (%dx),%al
801062af:	a8 01                	test   $0x1,%al
801062b1:	74 0d                	je     801062c0 <uartgetc+0x20>
801062b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062b8:	ec                   	in     (%dx),%al
801062b9:	0f b6 c0             	movzbl %al,%eax
801062bc:	c3                   	ret    
801062bd:	8d 76 00             	lea    0x0(%esi),%esi
801062c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c5:	c3                   	ret    
801062c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cd:	8d 76 00             	lea    0x0(%esi),%esi

801062d0 <uartinit>:
801062d0:	55                   	push   %ebp
801062d1:	31 c9                	xor    %ecx,%ecx
801062d3:	89 c8                	mov    %ecx,%eax
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	57                   	push   %edi
801062d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801062dd:	56                   	push   %esi
801062de:	89 fa                	mov    %edi,%edx
801062e0:	53                   	push   %ebx
801062e1:	83 ec 1c             	sub    $0x1c,%esp
801062e4:	ee                   	out    %al,(%dx)
801062e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801062ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062ef:	89 f2                	mov    %esi,%edx
801062f1:	ee                   	out    %al,(%dx)
801062f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fc:	ee                   	out    %al,(%dx)
801062fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106302:	89 c8                	mov    %ecx,%eax
80106304:	89 da                	mov    %ebx,%edx
80106306:	ee                   	out    %al,(%dx)
80106307:	b8 03 00 00 00       	mov    $0x3,%eax
8010630c:	89 f2                	mov    %esi,%edx
8010630e:	ee                   	out    %al,(%dx)
8010630f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106314:	89 c8                	mov    %ecx,%eax
80106316:	ee                   	out    %al,(%dx)
80106317:	b8 01 00 00 00       	mov    $0x1,%eax
8010631c:	89 da                	mov    %ebx,%edx
8010631e:	ee                   	out    %al,(%dx)
8010631f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106324:	ec                   	in     (%dx),%al
80106325:	3c ff                	cmp    $0xff,%al
80106327:	74 78                	je     801063a1 <uartinit+0xd1>
80106329:	c7 05 c0 57 11 80 01 	movl   $0x1,0x801157c0
80106330:	00 00 00 
80106333:	89 fa                	mov    %edi,%edx
80106335:	ec                   	in     (%dx),%al
80106336:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010633b:	ec                   	in     (%dx),%al
8010633c:	83 ec 08             	sub    $0x8,%esp
8010633f:	bf a0 82 10 80       	mov    $0x801082a0,%edi
80106344:	be fd 03 00 00       	mov    $0x3fd,%esi
80106349:	6a 00                	push   $0x0
8010634b:	6a 04                	push   $0x4
8010634d:	e8 2e c1 ff ff       	call   80102480 <ioapicenable>
80106352:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80106356:	83 c4 10             	add    $0x10,%esp
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106360:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80106365:	bb 80 00 00 00       	mov    $0x80,%ebx
8010636a:	85 c0                	test   %eax,%eax
8010636c:	75 14                	jne    80106382 <uartinit+0xb2>
8010636e:	eb 23                	jmp    80106393 <uartinit+0xc3>
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	6a 0a                	push   $0xa
80106375:	e8 b6 c5 ff ff       	call   80102930 <microdelay>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	83 eb 01             	sub    $0x1,%ebx
80106380:	74 07                	je     80106389 <uartinit+0xb9>
80106382:	89 f2                	mov    %esi,%edx
80106384:	ec                   	in     (%dx),%al
80106385:	a8 20                	test   $0x20,%al
80106387:	74 e7                	je     80106370 <uartinit+0xa0>
80106389:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010638d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106392:	ee                   	out    %al,(%dx)
80106393:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106397:	83 c7 01             	add    $0x1,%edi
8010639a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010639d:	84 c0                	test   %al,%al
8010639f:	75 bf                	jne    80106360 <uartinit+0x90>
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
801063a8:	c3                   	ret    
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063b0 <uartputc>:
801063b0:	a1 c0 57 11 80       	mov    0x801157c0,%eax
801063b5:	85 c0                	test   %eax,%eax
801063b7:	74 47                	je     80106400 <uartputc+0x50>
801063b9:	55                   	push   %ebp
801063ba:	89 e5                	mov    %esp,%ebp
801063bc:	56                   	push   %esi
801063bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063c2:	53                   	push   %ebx
801063c3:	bb 80 00 00 00       	mov    $0x80,%ebx
801063c8:	eb 18                	jmp    801063e2 <uartputc+0x32>
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	6a 0a                	push   $0xa
801063d5:	e8 56 c5 ff ff       	call   80102930 <microdelay>
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	83 eb 01             	sub    $0x1,%ebx
801063e0:	74 07                	je     801063e9 <uartputc+0x39>
801063e2:	89 f2                	mov    %esi,%edx
801063e4:	ec                   	in     (%dx),%al
801063e5:	a8 20                	test   $0x20,%al
801063e7:	74 e7                	je     801063d0 <uartputc+0x20>
801063e9:	8b 45 08             	mov    0x8(%ebp),%eax
801063ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063f1:	ee                   	out    %al,(%dx)
801063f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063f5:	5b                   	pop    %ebx
801063f6:	5e                   	pop    %esi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106400:	c3                   	ret    
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640f:	90                   	nop

80106410 <uartintr>:
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 14             	sub    $0x14,%esp
80106416:	68 a0 62 10 80       	push   $0x801062a0
8010641b:	e8 60 a4 ff ff       	call   80100880 <consoleintr>
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	c9                   	leave  
80106424:	c3                   	ret    

80106425 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $0
80106427:	6a 00                	push   $0x0
  jmp alltraps
80106429:	e9 e7 fa ff ff       	jmp    80105f15 <alltraps>

8010642e <vector1>:
.globl vector1
vector1:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $1
80106430:	6a 01                	push   $0x1
  jmp alltraps
80106432:	e9 de fa ff ff       	jmp    80105f15 <alltraps>

80106437 <vector2>:
.globl vector2
vector2:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $2
80106439:	6a 02                	push   $0x2
  jmp alltraps
8010643b:	e9 d5 fa ff ff       	jmp    80105f15 <alltraps>

80106440 <vector3>:
.globl vector3
vector3:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $3
80106442:	6a 03                	push   $0x3
  jmp alltraps
80106444:	e9 cc fa ff ff       	jmp    80105f15 <alltraps>

80106449 <vector4>:
.globl vector4
vector4:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $4
8010644b:	6a 04                	push   $0x4
  jmp alltraps
8010644d:	e9 c3 fa ff ff       	jmp    80105f15 <alltraps>

80106452 <vector5>:
.globl vector5
vector5:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $5
80106454:	6a 05                	push   $0x5
  jmp alltraps
80106456:	e9 ba fa ff ff       	jmp    80105f15 <alltraps>

8010645b <vector6>:
.globl vector6
vector6:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $6
8010645d:	6a 06                	push   $0x6
  jmp alltraps
8010645f:	e9 b1 fa ff ff       	jmp    80105f15 <alltraps>

80106464 <vector7>:
.globl vector7
vector7:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $7
80106466:	6a 07                	push   $0x7
  jmp alltraps
80106468:	e9 a8 fa ff ff       	jmp    80105f15 <alltraps>

8010646d <vector8>:
.globl vector8
vector8:
  pushl $8
8010646d:	6a 08                	push   $0x8
  jmp alltraps
8010646f:	e9 a1 fa ff ff       	jmp    80105f15 <alltraps>

80106474 <vector9>:
.globl vector9
vector9:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $9
80106476:	6a 09                	push   $0x9
  jmp alltraps
80106478:	e9 98 fa ff ff       	jmp    80105f15 <alltraps>

8010647d <vector10>:
.globl vector10
vector10:
  pushl $10
8010647d:	6a 0a                	push   $0xa
  jmp alltraps
8010647f:	e9 91 fa ff ff       	jmp    80105f15 <alltraps>

80106484 <vector11>:
.globl vector11
vector11:
  pushl $11
80106484:	6a 0b                	push   $0xb
  jmp alltraps
80106486:	e9 8a fa ff ff       	jmp    80105f15 <alltraps>

8010648b <vector12>:
.globl vector12
vector12:
  pushl $12
8010648b:	6a 0c                	push   $0xc
  jmp alltraps
8010648d:	e9 83 fa ff ff       	jmp    80105f15 <alltraps>

80106492 <vector13>:
.globl vector13
vector13:
  pushl $13
80106492:	6a 0d                	push   $0xd
  jmp alltraps
80106494:	e9 7c fa ff ff       	jmp    80105f15 <alltraps>

80106499 <vector14>:
.globl vector14
vector14:
  pushl $14
80106499:	6a 0e                	push   $0xe
  jmp alltraps
8010649b:	e9 75 fa ff ff       	jmp    80105f15 <alltraps>

801064a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $15
801064a2:	6a 0f                	push   $0xf
  jmp alltraps
801064a4:	e9 6c fa ff ff       	jmp    80105f15 <alltraps>

801064a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $16
801064ab:	6a 10                	push   $0x10
  jmp alltraps
801064ad:	e9 63 fa ff ff       	jmp    80105f15 <alltraps>

801064b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b2:	6a 11                	push   $0x11
  jmp alltraps
801064b4:	e9 5c fa ff ff       	jmp    80105f15 <alltraps>

801064b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $18
801064bb:	6a 12                	push   $0x12
  jmp alltraps
801064bd:	e9 53 fa ff ff       	jmp    80105f15 <alltraps>

801064c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $19
801064c4:	6a 13                	push   $0x13
  jmp alltraps
801064c6:	e9 4a fa ff ff       	jmp    80105f15 <alltraps>

801064cb <vector20>:
.globl vector20
vector20:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $20
801064cd:	6a 14                	push   $0x14
  jmp alltraps
801064cf:	e9 41 fa ff ff       	jmp    80105f15 <alltraps>

801064d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $21
801064d6:	6a 15                	push   $0x15
  jmp alltraps
801064d8:	e9 38 fa ff ff       	jmp    80105f15 <alltraps>

801064dd <vector22>:
.globl vector22
vector22:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $22
801064df:	6a 16                	push   $0x16
  jmp alltraps
801064e1:	e9 2f fa ff ff       	jmp    80105f15 <alltraps>

801064e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $23
801064e8:	6a 17                	push   $0x17
  jmp alltraps
801064ea:	e9 26 fa ff ff       	jmp    80105f15 <alltraps>

801064ef <vector24>:
.globl vector24
vector24:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $24
801064f1:	6a 18                	push   $0x18
  jmp alltraps
801064f3:	e9 1d fa ff ff       	jmp    80105f15 <alltraps>

801064f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $25
801064fa:	6a 19                	push   $0x19
  jmp alltraps
801064fc:	e9 14 fa ff ff       	jmp    80105f15 <alltraps>

80106501 <vector26>:
.globl vector26
vector26:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $26
80106503:	6a 1a                	push   $0x1a
  jmp alltraps
80106505:	e9 0b fa ff ff       	jmp    80105f15 <alltraps>

8010650a <vector27>:
.globl vector27
vector27:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $27
8010650c:	6a 1b                	push   $0x1b
  jmp alltraps
8010650e:	e9 02 fa ff ff       	jmp    80105f15 <alltraps>

80106513 <vector28>:
.globl vector28
vector28:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $28
80106515:	6a 1c                	push   $0x1c
  jmp alltraps
80106517:	e9 f9 f9 ff ff       	jmp    80105f15 <alltraps>

8010651c <vector29>:
.globl vector29
vector29:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $29
8010651e:	6a 1d                	push   $0x1d
  jmp alltraps
80106520:	e9 f0 f9 ff ff       	jmp    80105f15 <alltraps>

80106525 <vector30>:
.globl vector30
vector30:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $30
80106527:	6a 1e                	push   $0x1e
  jmp alltraps
80106529:	e9 e7 f9 ff ff       	jmp    80105f15 <alltraps>

8010652e <vector31>:
.globl vector31
vector31:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $31
80106530:	6a 1f                	push   $0x1f
  jmp alltraps
80106532:	e9 de f9 ff ff       	jmp    80105f15 <alltraps>

80106537 <vector32>:
.globl vector32
vector32:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $32
80106539:	6a 20                	push   $0x20
  jmp alltraps
8010653b:	e9 d5 f9 ff ff       	jmp    80105f15 <alltraps>

80106540 <vector33>:
.globl vector33
vector33:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $33
80106542:	6a 21                	push   $0x21
  jmp alltraps
80106544:	e9 cc f9 ff ff       	jmp    80105f15 <alltraps>

80106549 <vector34>:
.globl vector34
vector34:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $34
8010654b:	6a 22                	push   $0x22
  jmp alltraps
8010654d:	e9 c3 f9 ff ff       	jmp    80105f15 <alltraps>

80106552 <vector35>:
.globl vector35
vector35:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $35
80106554:	6a 23                	push   $0x23
  jmp alltraps
80106556:	e9 ba f9 ff ff       	jmp    80105f15 <alltraps>

8010655b <vector36>:
.globl vector36
vector36:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $36
8010655d:	6a 24                	push   $0x24
  jmp alltraps
8010655f:	e9 b1 f9 ff ff       	jmp    80105f15 <alltraps>

80106564 <vector37>:
.globl vector37
vector37:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $37
80106566:	6a 25                	push   $0x25
  jmp alltraps
80106568:	e9 a8 f9 ff ff       	jmp    80105f15 <alltraps>

8010656d <vector38>:
.globl vector38
vector38:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $38
8010656f:	6a 26                	push   $0x26
  jmp alltraps
80106571:	e9 9f f9 ff ff       	jmp    80105f15 <alltraps>

80106576 <vector39>:
.globl vector39
vector39:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $39
80106578:	6a 27                	push   $0x27
  jmp alltraps
8010657a:	e9 96 f9 ff ff       	jmp    80105f15 <alltraps>

8010657f <vector40>:
.globl vector40
vector40:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $40
80106581:	6a 28                	push   $0x28
  jmp alltraps
80106583:	e9 8d f9 ff ff       	jmp    80105f15 <alltraps>

80106588 <vector41>:
.globl vector41
vector41:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $41
8010658a:	6a 29                	push   $0x29
  jmp alltraps
8010658c:	e9 84 f9 ff ff       	jmp    80105f15 <alltraps>

80106591 <vector42>:
.globl vector42
vector42:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $42
80106593:	6a 2a                	push   $0x2a
  jmp alltraps
80106595:	e9 7b f9 ff ff       	jmp    80105f15 <alltraps>

8010659a <vector43>:
.globl vector43
vector43:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $43
8010659c:	6a 2b                	push   $0x2b
  jmp alltraps
8010659e:	e9 72 f9 ff ff       	jmp    80105f15 <alltraps>

801065a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $44
801065a5:	6a 2c                	push   $0x2c
  jmp alltraps
801065a7:	e9 69 f9 ff ff       	jmp    80105f15 <alltraps>

801065ac <vector45>:
.globl vector45
vector45:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $45
801065ae:	6a 2d                	push   $0x2d
  jmp alltraps
801065b0:	e9 60 f9 ff ff       	jmp    80105f15 <alltraps>

801065b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $46
801065b7:	6a 2e                	push   $0x2e
  jmp alltraps
801065b9:	e9 57 f9 ff ff       	jmp    80105f15 <alltraps>

801065be <vector47>:
.globl vector47
vector47:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $47
801065c0:	6a 2f                	push   $0x2f
  jmp alltraps
801065c2:	e9 4e f9 ff ff       	jmp    80105f15 <alltraps>

801065c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $48
801065c9:	6a 30                	push   $0x30
  jmp alltraps
801065cb:	e9 45 f9 ff ff       	jmp    80105f15 <alltraps>

801065d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $49
801065d2:	6a 31                	push   $0x31
  jmp alltraps
801065d4:	e9 3c f9 ff ff       	jmp    80105f15 <alltraps>

801065d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $50
801065db:	6a 32                	push   $0x32
  jmp alltraps
801065dd:	e9 33 f9 ff ff       	jmp    80105f15 <alltraps>

801065e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $51
801065e4:	6a 33                	push   $0x33
  jmp alltraps
801065e6:	e9 2a f9 ff ff       	jmp    80105f15 <alltraps>

801065eb <vector52>:
.globl vector52
vector52:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $52
801065ed:	6a 34                	push   $0x34
  jmp alltraps
801065ef:	e9 21 f9 ff ff       	jmp    80105f15 <alltraps>

801065f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $53
801065f6:	6a 35                	push   $0x35
  jmp alltraps
801065f8:	e9 18 f9 ff ff       	jmp    80105f15 <alltraps>

801065fd <vector54>:
.globl vector54
vector54:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $54
801065ff:	6a 36                	push   $0x36
  jmp alltraps
80106601:	e9 0f f9 ff ff       	jmp    80105f15 <alltraps>

80106606 <vector55>:
.globl vector55
vector55:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $55
80106608:	6a 37                	push   $0x37
  jmp alltraps
8010660a:	e9 06 f9 ff ff       	jmp    80105f15 <alltraps>

8010660f <vector56>:
.globl vector56
vector56:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $56
80106611:	6a 38                	push   $0x38
  jmp alltraps
80106613:	e9 fd f8 ff ff       	jmp    80105f15 <alltraps>

80106618 <vector57>:
.globl vector57
vector57:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $57
8010661a:	6a 39                	push   $0x39
  jmp alltraps
8010661c:	e9 f4 f8 ff ff       	jmp    80105f15 <alltraps>

80106621 <vector58>:
.globl vector58
vector58:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $58
80106623:	6a 3a                	push   $0x3a
  jmp alltraps
80106625:	e9 eb f8 ff ff       	jmp    80105f15 <alltraps>

8010662a <vector59>:
.globl vector59
vector59:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $59
8010662c:	6a 3b                	push   $0x3b
  jmp alltraps
8010662e:	e9 e2 f8 ff ff       	jmp    80105f15 <alltraps>

80106633 <vector60>:
.globl vector60
vector60:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $60
80106635:	6a 3c                	push   $0x3c
  jmp alltraps
80106637:	e9 d9 f8 ff ff       	jmp    80105f15 <alltraps>

8010663c <vector61>:
.globl vector61
vector61:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $61
8010663e:	6a 3d                	push   $0x3d
  jmp alltraps
80106640:	e9 d0 f8 ff ff       	jmp    80105f15 <alltraps>

80106645 <vector62>:
.globl vector62
vector62:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $62
80106647:	6a 3e                	push   $0x3e
  jmp alltraps
80106649:	e9 c7 f8 ff ff       	jmp    80105f15 <alltraps>

8010664e <vector63>:
.globl vector63
vector63:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $63
80106650:	6a 3f                	push   $0x3f
  jmp alltraps
80106652:	e9 be f8 ff ff       	jmp    80105f15 <alltraps>

80106657 <vector64>:
.globl vector64
vector64:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $64
80106659:	6a 40                	push   $0x40
  jmp alltraps
8010665b:	e9 b5 f8 ff ff       	jmp    80105f15 <alltraps>

80106660 <vector65>:
.globl vector65
vector65:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $65
80106662:	6a 41                	push   $0x41
  jmp alltraps
80106664:	e9 ac f8 ff ff       	jmp    80105f15 <alltraps>

80106669 <vector66>:
.globl vector66
vector66:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $66
8010666b:	6a 42                	push   $0x42
  jmp alltraps
8010666d:	e9 a3 f8 ff ff       	jmp    80105f15 <alltraps>

80106672 <vector67>:
.globl vector67
vector67:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $67
80106674:	6a 43                	push   $0x43
  jmp alltraps
80106676:	e9 9a f8 ff ff       	jmp    80105f15 <alltraps>

8010667b <vector68>:
.globl vector68
vector68:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $68
8010667d:	6a 44                	push   $0x44
  jmp alltraps
8010667f:	e9 91 f8 ff ff       	jmp    80105f15 <alltraps>

80106684 <vector69>:
.globl vector69
vector69:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $69
80106686:	6a 45                	push   $0x45
  jmp alltraps
80106688:	e9 88 f8 ff ff       	jmp    80105f15 <alltraps>

8010668d <vector70>:
.globl vector70
vector70:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $70
8010668f:	6a 46                	push   $0x46
  jmp alltraps
80106691:	e9 7f f8 ff ff       	jmp    80105f15 <alltraps>

80106696 <vector71>:
.globl vector71
vector71:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $71
80106698:	6a 47                	push   $0x47
  jmp alltraps
8010669a:	e9 76 f8 ff ff       	jmp    80105f15 <alltraps>

8010669f <vector72>:
.globl vector72
vector72:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $72
801066a1:	6a 48                	push   $0x48
  jmp alltraps
801066a3:	e9 6d f8 ff ff       	jmp    80105f15 <alltraps>

801066a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $73
801066aa:	6a 49                	push   $0x49
  jmp alltraps
801066ac:	e9 64 f8 ff ff       	jmp    80105f15 <alltraps>

801066b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $74
801066b3:	6a 4a                	push   $0x4a
  jmp alltraps
801066b5:	e9 5b f8 ff ff       	jmp    80105f15 <alltraps>

801066ba <vector75>:
.globl vector75
vector75:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $75
801066bc:	6a 4b                	push   $0x4b
  jmp alltraps
801066be:	e9 52 f8 ff ff       	jmp    80105f15 <alltraps>

801066c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $76
801066c5:	6a 4c                	push   $0x4c
  jmp alltraps
801066c7:	e9 49 f8 ff ff       	jmp    80105f15 <alltraps>

801066cc <vector77>:
.globl vector77
vector77:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $77
801066ce:	6a 4d                	push   $0x4d
  jmp alltraps
801066d0:	e9 40 f8 ff ff       	jmp    80105f15 <alltraps>

801066d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $78
801066d7:	6a 4e                	push   $0x4e
  jmp alltraps
801066d9:	e9 37 f8 ff ff       	jmp    80105f15 <alltraps>

801066de <vector79>:
.globl vector79
vector79:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $79
801066e0:	6a 4f                	push   $0x4f
  jmp alltraps
801066e2:	e9 2e f8 ff ff       	jmp    80105f15 <alltraps>

801066e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $80
801066e9:	6a 50                	push   $0x50
  jmp alltraps
801066eb:	e9 25 f8 ff ff       	jmp    80105f15 <alltraps>

801066f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $81
801066f2:	6a 51                	push   $0x51
  jmp alltraps
801066f4:	e9 1c f8 ff ff       	jmp    80105f15 <alltraps>

801066f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $82
801066fb:	6a 52                	push   $0x52
  jmp alltraps
801066fd:	e9 13 f8 ff ff       	jmp    80105f15 <alltraps>

80106702 <vector83>:
.globl vector83
vector83:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $83
80106704:	6a 53                	push   $0x53
  jmp alltraps
80106706:	e9 0a f8 ff ff       	jmp    80105f15 <alltraps>

8010670b <vector84>:
.globl vector84
vector84:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $84
8010670d:	6a 54                	push   $0x54
  jmp alltraps
8010670f:	e9 01 f8 ff ff       	jmp    80105f15 <alltraps>

80106714 <vector85>:
.globl vector85
vector85:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $85
80106716:	6a 55                	push   $0x55
  jmp alltraps
80106718:	e9 f8 f7 ff ff       	jmp    80105f15 <alltraps>

8010671d <vector86>:
.globl vector86
vector86:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $86
8010671f:	6a 56                	push   $0x56
  jmp alltraps
80106721:	e9 ef f7 ff ff       	jmp    80105f15 <alltraps>

80106726 <vector87>:
.globl vector87
vector87:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $87
80106728:	6a 57                	push   $0x57
  jmp alltraps
8010672a:	e9 e6 f7 ff ff       	jmp    80105f15 <alltraps>

8010672f <vector88>:
.globl vector88
vector88:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $88
80106731:	6a 58                	push   $0x58
  jmp alltraps
80106733:	e9 dd f7 ff ff       	jmp    80105f15 <alltraps>

80106738 <vector89>:
.globl vector89
vector89:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $89
8010673a:	6a 59                	push   $0x59
  jmp alltraps
8010673c:	e9 d4 f7 ff ff       	jmp    80105f15 <alltraps>

80106741 <vector90>:
.globl vector90
vector90:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $90
80106743:	6a 5a                	push   $0x5a
  jmp alltraps
80106745:	e9 cb f7 ff ff       	jmp    80105f15 <alltraps>

8010674a <vector91>:
.globl vector91
vector91:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $91
8010674c:	6a 5b                	push   $0x5b
  jmp alltraps
8010674e:	e9 c2 f7 ff ff       	jmp    80105f15 <alltraps>

80106753 <vector92>:
.globl vector92
vector92:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $92
80106755:	6a 5c                	push   $0x5c
  jmp alltraps
80106757:	e9 b9 f7 ff ff       	jmp    80105f15 <alltraps>

8010675c <vector93>:
.globl vector93
vector93:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $93
8010675e:	6a 5d                	push   $0x5d
  jmp alltraps
80106760:	e9 b0 f7 ff ff       	jmp    80105f15 <alltraps>

80106765 <vector94>:
.globl vector94
vector94:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $94
80106767:	6a 5e                	push   $0x5e
  jmp alltraps
80106769:	e9 a7 f7 ff ff       	jmp    80105f15 <alltraps>

8010676e <vector95>:
.globl vector95
vector95:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $95
80106770:	6a 5f                	push   $0x5f
  jmp alltraps
80106772:	e9 9e f7 ff ff       	jmp    80105f15 <alltraps>

80106777 <vector96>:
.globl vector96
vector96:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $96
80106779:	6a 60                	push   $0x60
  jmp alltraps
8010677b:	e9 95 f7 ff ff       	jmp    80105f15 <alltraps>

80106780 <vector97>:
.globl vector97
vector97:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $97
80106782:	6a 61                	push   $0x61
  jmp alltraps
80106784:	e9 8c f7 ff ff       	jmp    80105f15 <alltraps>

80106789 <vector98>:
.globl vector98
vector98:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $98
8010678b:	6a 62                	push   $0x62
  jmp alltraps
8010678d:	e9 83 f7 ff ff       	jmp    80105f15 <alltraps>

80106792 <vector99>:
.globl vector99
vector99:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $99
80106794:	6a 63                	push   $0x63
  jmp alltraps
80106796:	e9 7a f7 ff ff       	jmp    80105f15 <alltraps>

8010679b <vector100>:
.globl vector100
vector100:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $100
8010679d:	6a 64                	push   $0x64
  jmp alltraps
8010679f:	e9 71 f7 ff ff       	jmp    80105f15 <alltraps>

801067a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $101
801067a6:	6a 65                	push   $0x65
  jmp alltraps
801067a8:	e9 68 f7 ff ff       	jmp    80105f15 <alltraps>

801067ad <vector102>:
.globl vector102
vector102:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $102
801067af:	6a 66                	push   $0x66
  jmp alltraps
801067b1:	e9 5f f7 ff ff       	jmp    80105f15 <alltraps>

801067b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $103
801067b8:	6a 67                	push   $0x67
  jmp alltraps
801067ba:	e9 56 f7 ff ff       	jmp    80105f15 <alltraps>

801067bf <vector104>:
.globl vector104
vector104:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $104
801067c1:	6a 68                	push   $0x68
  jmp alltraps
801067c3:	e9 4d f7 ff ff       	jmp    80105f15 <alltraps>

801067c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $105
801067ca:	6a 69                	push   $0x69
  jmp alltraps
801067cc:	e9 44 f7 ff ff       	jmp    80105f15 <alltraps>

801067d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $106
801067d3:	6a 6a                	push   $0x6a
  jmp alltraps
801067d5:	e9 3b f7 ff ff       	jmp    80105f15 <alltraps>

801067da <vector107>:
.globl vector107
vector107:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $107
801067dc:	6a 6b                	push   $0x6b
  jmp alltraps
801067de:	e9 32 f7 ff ff       	jmp    80105f15 <alltraps>

801067e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $108
801067e5:	6a 6c                	push   $0x6c
  jmp alltraps
801067e7:	e9 29 f7 ff ff       	jmp    80105f15 <alltraps>

801067ec <vector109>:
.globl vector109
vector109:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $109
801067ee:	6a 6d                	push   $0x6d
  jmp alltraps
801067f0:	e9 20 f7 ff ff       	jmp    80105f15 <alltraps>

801067f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $110
801067f7:	6a 6e                	push   $0x6e
  jmp alltraps
801067f9:	e9 17 f7 ff ff       	jmp    80105f15 <alltraps>

801067fe <vector111>:
.globl vector111
vector111:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $111
80106800:	6a 6f                	push   $0x6f
  jmp alltraps
80106802:	e9 0e f7 ff ff       	jmp    80105f15 <alltraps>

80106807 <vector112>:
.globl vector112
vector112:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $112
80106809:	6a 70                	push   $0x70
  jmp alltraps
8010680b:	e9 05 f7 ff ff       	jmp    80105f15 <alltraps>

80106810 <vector113>:
.globl vector113
vector113:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $113
80106812:	6a 71                	push   $0x71
  jmp alltraps
80106814:	e9 fc f6 ff ff       	jmp    80105f15 <alltraps>

80106819 <vector114>:
.globl vector114
vector114:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $114
8010681b:	6a 72                	push   $0x72
  jmp alltraps
8010681d:	e9 f3 f6 ff ff       	jmp    80105f15 <alltraps>

80106822 <vector115>:
.globl vector115
vector115:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $115
80106824:	6a 73                	push   $0x73
  jmp alltraps
80106826:	e9 ea f6 ff ff       	jmp    80105f15 <alltraps>

8010682b <vector116>:
.globl vector116
vector116:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $116
8010682d:	6a 74                	push   $0x74
  jmp alltraps
8010682f:	e9 e1 f6 ff ff       	jmp    80105f15 <alltraps>

80106834 <vector117>:
.globl vector117
vector117:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $117
80106836:	6a 75                	push   $0x75
  jmp alltraps
80106838:	e9 d8 f6 ff ff       	jmp    80105f15 <alltraps>

8010683d <vector118>:
.globl vector118
vector118:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $118
8010683f:	6a 76                	push   $0x76
  jmp alltraps
80106841:	e9 cf f6 ff ff       	jmp    80105f15 <alltraps>

80106846 <vector119>:
.globl vector119
vector119:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $119
80106848:	6a 77                	push   $0x77
  jmp alltraps
8010684a:	e9 c6 f6 ff ff       	jmp    80105f15 <alltraps>

8010684f <vector120>:
.globl vector120
vector120:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $120
80106851:	6a 78                	push   $0x78
  jmp alltraps
80106853:	e9 bd f6 ff ff       	jmp    80105f15 <alltraps>

80106858 <vector121>:
.globl vector121
vector121:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $121
8010685a:	6a 79                	push   $0x79
  jmp alltraps
8010685c:	e9 b4 f6 ff ff       	jmp    80105f15 <alltraps>

80106861 <vector122>:
.globl vector122
vector122:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $122
80106863:	6a 7a                	push   $0x7a
  jmp alltraps
80106865:	e9 ab f6 ff ff       	jmp    80105f15 <alltraps>

8010686a <vector123>:
.globl vector123
vector123:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $123
8010686c:	6a 7b                	push   $0x7b
  jmp alltraps
8010686e:	e9 a2 f6 ff ff       	jmp    80105f15 <alltraps>

80106873 <vector124>:
.globl vector124
vector124:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $124
80106875:	6a 7c                	push   $0x7c
  jmp alltraps
80106877:	e9 99 f6 ff ff       	jmp    80105f15 <alltraps>

8010687c <vector125>:
.globl vector125
vector125:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $125
8010687e:	6a 7d                	push   $0x7d
  jmp alltraps
80106880:	e9 90 f6 ff ff       	jmp    80105f15 <alltraps>

80106885 <vector126>:
.globl vector126
vector126:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $126
80106887:	6a 7e                	push   $0x7e
  jmp alltraps
80106889:	e9 87 f6 ff ff       	jmp    80105f15 <alltraps>

8010688e <vector127>:
.globl vector127
vector127:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $127
80106890:	6a 7f                	push   $0x7f
  jmp alltraps
80106892:	e9 7e f6 ff ff       	jmp    80105f15 <alltraps>

80106897 <vector128>:
.globl vector128
vector128:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $128
80106899:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010689e:	e9 72 f6 ff ff       	jmp    80105f15 <alltraps>

801068a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $129
801068a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068aa:	e9 66 f6 ff ff       	jmp    80105f15 <alltraps>

801068af <vector130>:
.globl vector130
vector130:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $130
801068b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068b6:	e9 5a f6 ff ff       	jmp    80105f15 <alltraps>

801068bb <vector131>:
.globl vector131
vector131:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $131
801068bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c2:	e9 4e f6 ff ff       	jmp    80105f15 <alltraps>

801068c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $132
801068c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068ce:	e9 42 f6 ff ff       	jmp    80105f15 <alltraps>

801068d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $133
801068d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068da:	e9 36 f6 ff ff       	jmp    80105f15 <alltraps>

801068df <vector134>:
.globl vector134
vector134:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $134
801068e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068e6:	e9 2a f6 ff ff       	jmp    80105f15 <alltraps>

801068eb <vector135>:
.globl vector135
vector135:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $135
801068ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f2:	e9 1e f6 ff ff       	jmp    80105f15 <alltraps>

801068f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $136
801068f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068fe:	e9 12 f6 ff ff       	jmp    80105f15 <alltraps>

80106903 <vector137>:
.globl vector137
vector137:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $137
80106905:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010690a:	e9 06 f6 ff ff       	jmp    80105f15 <alltraps>

8010690f <vector138>:
.globl vector138
vector138:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $138
80106911:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106916:	e9 fa f5 ff ff       	jmp    80105f15 <alltraps>

8010691b <vector139>:
.globl vector139
vector139:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $139
8010691d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106922:	e9 ee f5 ff ff       	jmp    80105f15 <alltraps>

80106927 <vector140>:
.globl vector140
vector140:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $140
80106929:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010692e:	e9 e2 f5 ff ff       	jmp    80105f15 <alltraps>

80106933 <vector141>:
.globl vector141
vector141:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $141
80106935:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010693a:	e9 d6 f5 ff ff       	jmp    80105f15 <alltraps>

8010693f <vector142>:
.globl vector142
vector142:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $142
80106941:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106946:	e9 ca f5 ff ff       	jmp    80105f15 <alltraps>

8010694b <vector143>:
.globl vector143
vector143:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $143
8010694d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106952:	e9 be f5 ff ff       	jmp    80105f15 <alltraps>

80106957 <vector144>:
.globl vector144
vector144:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $144
80106959:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010695e:	e9 b2 f5 ff ff       	jmp    80105f15 <alltraps>

80106963 <vector145>:
.globl vector145
vector145:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $145
80106965:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010696a:	e9 a6 f5 ff ff       	jmp    80105f15 <alltraps>

8010696f <vector146>:
.globl vector146
vector146:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $146
80106971:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106976:	e9 9a f5 ff ff       	jmp    80105f15 <alltraps>

8010697b <vector147>:
.globl vector147
vector147:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $147
8010697d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106982:	e9 8e f5 ff ff       	jmp    80105f15 <alltraps>

80106987 <vector148>:
.globl vector148
vector148:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $148
80106989:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010698e:	e9 82 f5 ff ff       	jmp    80105f15 <alltraps>

80106993 <vector149>:
.globl vector149
vector149:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $149
80106995:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010699a:	e9 76 f5 ff ff       	jmp    80105f15 <alltraps>

8010699f <vector150>:
.globl vector150
vector150:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $150
801069a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069a6:	e9 6a f5 ff ff       	jmp    80105f15 <alltraps>

801069ab <vector151>:
.globl vector151
vector151:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $151
801069ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b2:	e9 5e f5 ff ff       	jmp    80105f15 <alltraps>

801069b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $152
801069b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069be:	e9 52 f5 ff ff       	jmp    80105f15 <alltraps>

801069c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $153
801069c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ca:	e9 46 f5 ff ff       	jmp    80105f15 <alltraps>

801069cf <vector154>:
.globl vector154
vector154:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $154
801069d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069d6:	e9 3a f5 ff ff       	jmp    80105f15 <alltraps>

801069db <vector155>:
.globl vector155
vector155:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $155
801069dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e2:	e9 2e f5 ff ff       	jmp    80105f15 <alltraps>

801069e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $156
801069e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ee:	e9 22 f5 ff ff       	jmp    80105f15 <alltraps>

801069f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $157
801069f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069fa:	e9 16 f5 ff ff       	jmp    80105f15 <alltraps>

801069ff <vector158>:
.globl vector158
vector158:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $158
80106a01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a06:	e9 0a f5 ff ff       	jmp    80105f15 <alltraps>

80106a0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $159
80106a0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a12:	e9 fe f4 ff ff       	jmp    80105f15 <alltraps>

80106a17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $160
80106a19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a1e:	e9 f2 f4 ff ff       	jmp    80105f15 <alltraps>

80106a23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $161
80106a25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a2a:	e9 e6 f4 ff ff       	jmp    80105f15 <alltraps>

80106a2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $162
80106a31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a36:	e9 da f4 ff ff       	jmp    80105f15 <alltraps>

80106a3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $163
80106a3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a42:	e9 ce f4 ff ff       	jmp    80105f15 <alltraps>

80106a47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $164
80106a49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a4e:	e9 c2 f4 ff ff       	jmp    80105f15 <alltraps>

80106a53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $165
80106a55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a5a:	e9 b6 f4 ff ff       	jmp    80105f15 <alltraps>

80106a5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $166
80106a61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a66:	e9 aa f4 ff ff       	jmp    80105f15 <alltraps>

80106a6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $167
80106a6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a72:	e9 9e f4 ff ff       	jmp    80105f15 <alltraps>

80106a77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $168
80106a79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a7e:	e9 92 f4 ff ff       	jmp    80105f15 <alltraps>

80106a83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $169
80106a85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a8a:	e9 86 f4 ff ff       	jmp    80105f15 <alltraps>

80106a8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $170
80106a91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a96:	e9 7a f4 ff ff       	jmp    80105f15 <alltraps>

80106a9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $171
80106a9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa2:	e9 6e f4 ff ff       	jmp    80105f15 <alltraps>

80106aa7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $172
80106aa9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106aae:	e9 62 f4 ff ff       	jmp    80105f15 <alltraps>

80106ab3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $173
80106ab5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aba:	e9 56 f4 ff ff       	jmp    80105f15 <alltraps>

80106abf <vector174>:
.globl vector174
vector174:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $174
80106ac1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ac6:	e9 4a f4 ff ff       	jmp    80105f15 <alltraps>

80106acb <vector175>:
.globl vector175
vector175:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $175
80106acd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad2:	e9 3e f4 ff ff       	jmp    80105f15 <alltraps>

80106ad7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $176
80106ad9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ade:	e9 32 f4 ff ff       	jmp    80105f15 <alltraps>

80106ae3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $177
80106ae5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aea:	e9 26 f4 ff ff       	jmp    80105f15 <alltraps>

80106aef <vector178>:
.globl vector178
vector178:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $178
80106af1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106af6:	e9 1a f4 ff ff       	jmp    80105f15 <alltraps>

80106afb <vector179>:
.globl vector179
vector179:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $179
80106afd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b02:	e9 0e f4 ff ff       	jmp    80105f15 <alltraps>

80106b07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $180
80106b09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b0e:	e9 02 f4 ff ff       	jmp    80105f15 <alltraps>

80106b13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $181
80106b15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b1a:	e9 f6 f3 ff ff       	jmp    80105f15 <alltraps>

80106b1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $182
80106b21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b26:	e9 ea f3 ff ff       	jmp    80105f15 <alltraps>

80106b2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $183
80106b2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b32:	e9 de f3 ff ff       	jmp    80105f15 <alltraps>

80106b37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $184
80106b39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b3e:	e9 d2 f3 ff ff       	jmp    80105f15 <alltraps>

80106b43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $185
80106b45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b4a:	e9 c6 f3 ff ff       	jmp    80105f15 <alltraps>

80106b4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $186
80106b51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b56:	e9 ba f3 ff ff       	jmp    80105f15 <alltraps>

80106b5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $187
80106b5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b62:	e9 ae f3 ff ff       	jmp    80105f15 <alltraps>

80106b67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $188
80106b69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b6e:	e9 a2 f3 ff ff       	jmp    80105f15 <alltraps>

80106b73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $189
80106b75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b7a:	e9 96 f3 ff ff       	jmp    80105f15 <alltraps>

80106b7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $190
80106b81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b86:	e9 8a f3 ff ff       	jmp    80105f15 <alltraps>

80106b8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $191
80106b8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b92:	e9 7e f3 ff ff       	jmp    80105f15 <alltraps>

80106b97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $192
80106b99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b9e:	e9 72 f3 ff ff       	jmp    80105f15 <alltraps>

80106ba3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $193
80106ba5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106baa:	e9 66 f3 ff ff       	jmp    80105f15 <alltraps>

80106baf <vector194>:
.globl vector194
vector194:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $194
80106bb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bb6:	e9 5a f3 ff ff       	jmp    80105f15 <alltraps>

80106bbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $195
80106bbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc2:	e9 4e f3 ff ff       	jmp    80105f15 <alltraps>

80106bc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $196
80106bc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bce:	e9 42 f3 ff ff       	jmp    80105f15 <alltraps>

80106bd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $197
80106bd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bda:	e9 36 f3 ff ff       	jmp    80105f15 <alltraps>

80106bdf <vector198>:
.globl vector198
vector198:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $198
80106be1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106be6:	e9 2a f3 ff ff       	jmp    80105f15 <alltraps>

80106beb <vector199>:
.globl vector199
vector199:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $199
80106bed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf2:	e9 1e f3 ff ff       	jmp    80105f15 <alltraps>

80106bf7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $200
80106bf9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bfe:	e9 12 f3 ff ff       	jmp    80105f15 <alltraps>

80106c03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $201
80106c05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c0a:	e9 06 f3 ff ff       	jmp    80105f15 <alltraps>

80106c0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $202
80106c11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c16:	e9 fa f2 ff ff       	jmp    80105f15 <alltraps>

80106c1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $203
80106c1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c22:	e9 ee f2 ff ff       	jmp    80105f15 <alltraps>

80106c27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $204
80106c29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c2e:	e9 e2 f2 ff ff       	jmp    80105f15 <alltraps>

80106c33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $205
80106c35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c3a:	e9 d6 f2 ff ff       	jmp    80105f15 <alltraps>

80106c3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $206
80106c41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c46:	e9 ca f2 ff ff       	jmp    80105f15 <alltraps>

80106c4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $207
80106c4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c52:	e9 be f2 ff ff       	jmp    80105f15 <alltraps>

80106c57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $208
80106c59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c5e:	e9 b2 f2 ff ff       	jmp    80105f15 <alltraps>

80106c63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $209
80106c65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c6a:	e9 a6 f2 ff ff       	jmp    80105f15 <alltraps>

80106c6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $210
80106c71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c76:	e9 9a f2 ff ff       	jmp    80105f15 <alltraps>

80106c7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $211
80106c7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c82:	e9 8e f2 ff ff       	jmp    80105f15 <alltraps>

80106c87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $212
80106c89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c8e:	e9 82 f2 ff ff       	jmp    80105f15 <alltraps>

80106c93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $213
80106c95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c9a:	e9 76 f2 ff ff       	jmp    80105f15 <alltraps>

80106c9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $214
80106ca1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ca6:	e9 6a f2 ff ff       	jmp    80105f15 <alltraps>

80106cab <vector215>:
.globl vector215
vector215:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $215
80106cad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb2:	e9 5e f2 ff ff       	jmp    80105f15 <alltraps>

80106cb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $216
80106cb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cbe:	e9 52 f2 ff ff       	jmp    80105f15 <alltraps>

80106cc3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $217
80106cc5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cca:	e9 46 f2 ff ff       	jmp    80105f15 <alltraps>

80106ccf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $218
80106cd1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cd6:	e9 3a f2 ff ff       	jmp    80105f15 <alltraps>

80106cdb <vector219>:
.globl vector219
vector219:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $219
80106cdd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce2:	e9 2e f2 ff ff       	jmp    80105f15 <alltraps>

80106ce7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $220
80106ce9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cee:	e9 22 f2 ff ff       	jmp    80105f15 <alltraps>

80106cf3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $221
80106cf5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cfa:	e9 16 f2 ff ff       	jmp    80105f15 <alltraps>

80106cff <vector222>:
.globl vector222
vector222:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $222
80106d01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d06:	e9 0a f2 ff ff       	jmp    80105f15 <alltraps>

80106d0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $223
80106d0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d12:	e9 fe f1 ff ff       	jmp    80105f15 <alltraps>

80106d17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $224
80106d19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d1e:	e9 f2 f1 ff ff       	jmp    80105f15 <alltraps>

80106d23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $225
80106d25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d2a:	e9 e6 f1 ff ff       	jmp    80105f15 <alltraps>

80106d2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $226
80106d31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d36:	e9 da f1 ff ff       	jmp    80105f15 <alltraps>

80106d3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $227
80106d3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d42:	e9 ce f1 ff ff       	jmp    80105f15 <alltraps>

80106d47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $228
80106d49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d4e:	e9 c2 f1 ff ff       	jmp    80105f15 <alltraps>

80106d53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $229
80106d55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d5a:	e9 b6 f1 ff ff       	jmp    80105f15 <alltraps>

80106d5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $230
80106d61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d66:	e9 aa f1 ff ff       	jmp    80105f15 <alltraps>

80106d6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $231
80106d6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d72:	e9 9e f1 ff ff       	jmp    80105f15 <alltraps>

80106d77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $232
80106d79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d7e:	e9 92 f1 ff ff       	jmp    80105f15 <alltraps>

80106d83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $233
80106d85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d8a:	e9 86 f1 ff ff       	jmp    80105f15 <alltraps>

80106d8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $234
80106d91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d96:	e9 7a f1 ff ff       	jmp    80105f15 <alltraps>

80106d9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $235
80106d9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da2:	e9 6e f1 ff ff       	jmp    80105f15 <alltraps>

80106da7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $236
80106da9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dae:	e9 62 f1 ff ff       	jmp    80105f15 <alltraps>

80106db3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $237
80106db5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dba:	e9 56 f1 ff ff       	jmp    80105f15 <alltraps>

80106dbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $238
80106dc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dc6:	e9 4a f1 ff ff       	jmp    80105f15 <alltraps>

80106dcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $239
80106dcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd2:	e9 3e f1 ff ff       	jmp    80105f15 <alltraps>

80106dd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $240
80106dd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dde:	e9 32 f1 ff ff       	jmp    80105f15 <alltraps>

80106de3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $241
80106de5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dea:	e9 26 f1 ff ff       	jmp    80105f15 <alltraps>

80106def <vector242>:
.globl vector242
vector242:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $242
80106df1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106df6:	e9 1a f1 ff ff       	jmp    80105f15 <alltraps>

80106dfb <vector243>:
.globl vector243
vector243:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $243
80106dfd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e02:	e9 0e f1 ff ff       	jmp    80105f15 <alltraps>

80106e07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $244
80106e09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e0e:	e9 02 f1 ff ff       	jmp    80105f15 <alltraps>

80106e13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $245
80106e15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e1a:	e9 f6 f0 ff ff       	jmp    80105f15 <alltraps>

80106e1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $246
80106e21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e26:	e9 ea f0 ff ff       	jmp    80105f15 <alltraps>

80106e2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $247
80106e2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e32:	e9 de f0 ff ff       	jmp    80105f15 <alltraps>

80106e37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $248
80106e39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e3e:	e9 d2 f0 ff ff       	jmp    80105f15 <alltraps>

80106e43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $249
80106e45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e4a:	e9 c6 f0 ff ff       	jmp    80105f15 <alltraps>

80106e4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $250
80106e51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e56:	e9 ba f0 ff ff       	jmp    80105f15 <alltraps>

80106e5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $251
80106e5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e62:	e9 ae f0 ff ff       	jmp    80105f15 <alltraps>

80106e67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $252
80106e69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e6e:	e9 a2 f0 ff ff       	jmp    80105f15 <alltraps>

80106e73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $253
80106e75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e7a:	e9 96 f0 ff ff       	jmp    80105f15 <alltraps>

80106e7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $254
80106e81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e86:	e9 8a f0 ff ff       	jmp    80105f15 <alltraps>

80106e8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $255
80106e8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e92:	e9 7e f0 ff ff       	jmp    80105f15 <alltraps>
80106e97:	66 90                	xchg   %ax,%ax
80106e99:	66 90                	xchg   %ax,%ax
80106e9b:	66 90                	xchg   %ax,%ax
80106e9d:	66 90                	xchg   %ax,%ax
80106e9f:	90                   	nop

80106ea0 <deallocuvm.part.0>:
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106eac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106eb2:	83 ec 1c             	sub    $0x1c,%esp
80106eb5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106eb8:	39 d3                	cmp    %edx,%ebx
80106eba:	73 49                	jae    80106f05 <deallocuvm.part.0+0x65>
80106ebc:	89 c7                	mov    %eax,%edi
80106ebe:	eb 0c                	jmp    80106ecc <deallocuvm.part.0+0x2c>
80106ec0:	83 c0 01             	add    $0x1,%eax
80106ec3:	c1 e0 16             	shl    $0x16,%eax
80106ec6:	89 c3                	mov    %eax,%ebx
80106ec8:	39 da                	cmp    %ebx,%edx
80106eca:	76 39                	jbe    80106f05 <deallocuvm.part.0+0x65>
80106ecc:	89 d8                	mov    %ebx,%eax
80106ece:	c1 e8 16             	shr    $0x16,%eax
80106ed1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106ed4:	f6 c1 01             	test   $0x1,%cl
80106ed7:	74 e7                	je     80106ec0 <deallocuvm.part.0+0x20>
80106ed9:	89 de                	mov    %ebx,%esi
80106edb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106ee1:	c1 ee 0a             	shr    $0xa,%esi
80106ee4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106eea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
80106ef1:	85 f6                	test   %esi,%esi
80106ef3:	74 cb                	je     80106ec0 <deallocuvm.part.0+0x20>
80106ef5:	8b 06                	mov    (%esi),%eax
80106ef7:	a8 01                	test   $0x1,%al
80106ef9:	75 15                	jne    80106f10 <deallocuvm.part.0+0x70>
80106efb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f01:	39 da                	cmp    %ebx,%edx
80106f03:	77 c7                	ja     80106ecc <deallocuvm.part.0+0x2c>
80106f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f0b:	5b                   	pop    %ebx
80106f0c:	5e                   	pop    %esi
80106f0d:	5f                   	pop    %edi
80106f0e:	5d                   	pop    %ebp
80106f0f:	c3                   	ret    
80106f10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f15:	74 25                	je     80106f3c <deallocuvm.part.0+0x9c>
80106f17:	83 ec 0c             	sub    $0xc,%esp
80106f1a:	05 00 00 00 80       	add    $0x80000000,%eax
80106f1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f28:	50                   	push   %eax
80106f29:	e8 92 b5 ff ff       	call   801024c0 <kfree>
80106f2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106f34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f37:	83 c4 10             	add    $0x10,%esp
80106f3a:	eb 8c                	jmp    80106ec8 <deallocuvm.part.0+0x28>
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	68 06 7b 10 80       	push   $0x80107b06
80106f44:	e8 37 94 ff ff       	call   80100380 <panic>
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <mappages>:
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	89 d3                	mov    %edx,%ebx
80106f58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106f5e:	83 ec 1c             	sub    $0x1c,%esp
80106f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f70:	8b 45 08             	mov    0x8(%ebp),%eax
80106f73:	29 d8                	sub    %ebx,%eax
80106f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f78:	eb 3d                	jmp    80106fb7 <mappages+0x67>
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f80:	89 da                	mov    %ebx,%edx
80106f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f87:	c1 ea 0a             	shr    $0xa,%edx
80106f8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
80106f97:	85 c0                	test   %eax,%eax
80106f99:	74 75                	je     80107010 <mappages+0xc0>
80106f9b:	f6 00 01             	testb  $0x1,(%eax)
80106f9e:	0f 85 86 00 00 00    	jne    8010702a <mappages+0xda>
80106fa4:	0b 75 0c             	or     0xc(%ebp),%esi
80106fa7:	83 ce 01             	or     $0x1,%esi
80106faa:	89 30                	mov    %esi,(%eax)
80106fac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106faf:	74 6f                	je     80107020 <mappages+0xd0>
80106fb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fbd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106fc0:	89 d8                	mov    %ebx,%eax
80106fc2:	c1 e8 16             	shr    $0x16,%eax
80106fc5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
80106fc8:	8b 07                	mov    (%edi),%eax
80106fca:	a8 01                	test   $0x1,%al
80106fcc:	75 b2                	jne    80106f80 <mappages+0x30>
80106fce:	e8 ad b6 ff ff       	call   80102680 <kalloc>
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	74 39                	je     80107010 <mappages+0xc0>
80106fd7:	83 ec 04             	sub    $0x4,%esp
80106fda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106fdd:	68 00 10 00 00       	push   $0x1000
80106fe2:	6a 00                	push   $0x0
80106fe4:	50                   	push   %eax
80106fe5:	e8 d6 dc ff ff       	call   80104cc0 <memset>
80106fea:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106fed:	83 c4 10             	add    $0x10,%esp
80106ff0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ff6:	83 c8 07             	or     $0x7,%eax
80106ff9:	89 07                	mov    %eax,(%edi)
80106ffb:	89 d8                	mov    %ebx,%eax
80106ffd:	c1 e8 0a             	shr    $0xa,%eax
80107000:	25 fc 0f 00 00       	and    $0xffc,%eax
80107005:	01 d0                	add    %edx,%eax
80107007:	eb 92                	jmp    80106f9b <mappages+0x4b>
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107018:	5b                   	pop    %ebx
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret    
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107023:	31 c0                	xor    %eax,%eax
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret    
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 a8 82 10 80       	push   $0x801082a8
80107032:	e8 49 93 ff ff       	call   80100380 <panic>
80107037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703e:	66 90                	xchg   %ax,%ax

80107040 <seginit>:
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 18             	sub    $0x18,%esp
80107046:	e8 25 c9 ff ff       	call   80103970 <cpuid>
8010704b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107050:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107056:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010705a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107061:	ff 00 00 
80107064:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010706b:	9a cf 00 
8010706e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107075:	ff 00 00 
80107078:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010707f:	92 cf 00 
80107082:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107089:	ff 00 00 
8010708c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107093:	fa cf 00 
80107096:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010709d:	ff 00 00 
801070a0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801070a7:	f2 cf 00 
801070aa:	05 10 28 11 80       	add    $0x80112810,%eax
801070af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
801070b3:	c1 e8 10             	shr    $0x10,%eax
801070b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
801070ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070bd:	0f 01 10             	lgdtl  (%eax)
801070c0:	c9                   	leave  
801070c1:	c3                   	ret    
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <switchkvm>:
801070d0:	a1 c4 57 11 80       	mov    0x801157c4,%eax
801070d5:	05 00 00 00 80       	add    $0x80000000,%eax
801070da:	0f 22 d8             	mov    %eax,%cr3
801070dd:	c3                   	ret    
801070de:	66 90                	xchg   %ax,%ax

801070e0 <switchuvm>:
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 08             	mov    0x8(%ebp),%esi
801070ec:	85 f6                	test   %esi,%esi
801070ee:	0f 84 cb 00 00 00    	je     801071bf <switchuvm+0xdf>
801070f4:	8b 46 08             	mov    0x8(%esi),%eax
801070f7:	85 c0                	test   %eax,%eax
801070f9:	0f 84 da 00 00 00    	je     801071d9 <switchuvm+0xf9>
801070ff:	8b 46 04             	mov    0x4(%esi),%eax
80107102:	85 c0                	test   %eax,%eax
80107104:	0f 84 c2 00 00 00    	je     801071cc <switchuvm+0xec>
8010710a:	e8 a1 d9 ff ff       	call   80104ab0 <pushcli>
8010710f:	e8 fc c7 ff ff       	call   80103910 <mycpu>
80107114:	89 c3                	mov    %eax,%ebx
80107116:	e8 f5 c7 ff ff       	call   80103910 <mycpu>
8010711b:	89 c7                	mov    %eax,%edi
8010711d:	e8 ee c7 ff ff       	call   80103910 <mycpu>
80107122:	83 c7 08             	add    $0x8,%edi
80107125:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107128:	e8 e3 c7 ff ff       	call   80103910 <mycpu>
8010712d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107130:	ba 67 00 00 00       	mov    $0x67,%edx
80107135:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010713c:	83 c0 08             	add    $0x8,%eax
8010713f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107146:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010714b:	83 c1 08             	add    $0x8,%ecx
8010714e:	c1 e8 18             	shr    $0x18,%eax
80107151:	c1 e9 10             	shr    $0x10,%ecx
80107154:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010715a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107160:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107165:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
8010716c:	bb 10 00 00 00       	mov    $0x10,%ebx
80107171:	e8 9a c7 ff ff       	call   80103910 <mycpu>
80107176:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
8010717d:	e8 8e c7 ff ff       	call   80103910 <mycpu>
80107182:	66 89 58 10          	mov    %bx,0x10(%eax)
80107186:	8b 5e 08             	mov    0x8(%esi),%ebx
80107189:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010718f:	e8 7c c7 ff ff       	call   80103910 <mycpu>
80107194:	89 58 0c             	mov    %ebx,0xc(%eax)
80107197:	e8 74 c7 ff ff       	call   80103910 <mycpu>
8010719c:	66 89 78 6e          	mov    %di,0x6e(%eax)
801071a0:	b8 28 00 00 00       	mov    $0x28,%eax
801071a5:	0f 00 d8             	ltr    %ax
801071a8:	8b 46 04             	mov    0x4(%esi),%eax
801071ab:	05 00 00 00 80       	add    $0x80000000,%eax
801071b0:	0f 22 d8             	mov    %eax,%cr3
801071b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b6:	5b                   	pop    %ebx
801071b7:	5e                   	pop    %esi
801071b8:	5f                   	pop    %edi
801071b9:	5d                   	pop    %ebp
801071ba:	e9 41 d9 ff ff       	jmp    80104b00 <popcli>
801071bf:	83 ec 0c             	sub    $0xc,%esp
801071c2:	68 ae 82 10 80       	push   $0x801082ae
801071c7:	e8 b4 91 ff ff       	call   80100380 <panic>
801071cc:	83 ec 0c             	sub    $0xc,%esp
801071cf:	68 d9 82 10 80       	push   $0x801082d9
801071d4:	e8 a7 91 ff ff       	call   80100380 <panic>
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 c4 82 10 80       	push   $0x801082c4
801071e1:	e8 9a 91 ff ff       	call   80100380 <panic>
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <inituvm>:
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801071fc:	8b 75 10             	mov    0x10(%ebp),%esi
801071ff:	8b 7d 08             	mov    0x8(%ebp),%edi
80107202:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107205:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010720b:	77 4b                	ja     80107258 <inituvm+0x68>
8010720d:	e8 6e b4 ff ff       	call   80102680 <kalloc>
80107212:	83 ec 04             	sub    $0x4,%esp
80107215:	68 00 10 00 00       	push   $0x1000
8010721a:	89 c3                	mov    %eax,%ebx
8010721c:	6a 00                	push   $0x0
8010721e:	50                   	push   %eax
8010721f:	e8 9c da ff ff       	call   80104cc0 <memset>
80107224:	58                   	pop    %eax
80107225:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010722b:	5a                   	pop    %edx
8010722c:	6a 06                	push   $0x6
8010722e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107233:	31 d2                	xor    %edx,%edx
80107235:	50                   	push   %eax
80107236:	89 f8                	mov    %edi,%eax
80107238:	e8 13 fd ff ff       	call   80106f50 <mappages>
8010723d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107240:	89 75 10             	mov    %esi,0x10(%ebp)
80107243:	83 c4 10             	add    $0x10,%esp
80107246:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107249:	89 45 0c             	mov    %eax,0xc(%ebp)
8010724c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724f:	5b                   	pop    %ebx
80107250:	5e                   	pop    %esi
80107251:	5f                   	pop    %edi
80107252:	5d                   	pop    %ebp
80107253:	e9 08 db ff ff       	jmp    80104d60 <memmove>
80107258:	83 ec 0c             	sub    $0xc,%esp
8010725b:	68 ed 82 10 80       	push   $0x801082ed
80107260:	e8 1b 91 ff ff       	call   80100380 <panic>
80107265:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107270 <loaduvm>:
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 1c             	sub    $0x1c,%esp
80107279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010727c:	8b 75 18             	mov    0x18(%ebp),%esi
8010727f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107284:	0f 85 bb 00 00 00    	jne    80107345 <loaduvm+0xd5>
8010728a:	01 f0                	add    %esi,%eax
8010728c:	89 f3                	mov    %esi,%ebx
8010728e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107291:	8b 45 14             	mov    0x14(%ebp),%eax
80107294:	01 f0                	add    %esi,%eax
80107296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107299:	85 f6                	test   %esi,%esi
8010729b:	0f 84 87 00 00 00    	je     80107328 <loaduvm+0xb8>
801072a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801072ae:	29 d8                	sub    %ebx,%eax
801072b0:	89 c2                	mov    %eax,%edx
801072b2:	c1 ea 16             	shr    $0x16,%edx
801072b5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801072b8:	f6 c2 01             	test   $0x1,%dl
801072bb:	75 13                	jne    801072d0 <loaduvm+0x60>
801072bd:	83 ec 0c             	sub    $0xc,%esp
801072c0:	68 07 83 10 80       	push   $0x80108307
801072c5:	e8 b6 90 ff ff       	call   80100380 <panic>
801072ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072d0:	c1 e8 0a             	shr    $0xa,%eax
801072d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801072d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
801072e5:	85 c0                	test   %eax,%eax
801072e7:	74 d4                	je     801072bd <loaduvm+0x4d>
801072e9:	8b 00                	mov    (%eax),%eax
801072eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801072ee:	bf 00 10 00 00       	mov    $0x1000,%edi
801072f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072f8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801072fe:	0f 46 fb             	cmovbe %ebx,%edi
80107301:	29 d9                	sub    %ebx,%ecx
80107303:	05 00 00 00 80       	add    $0x80000000,%eax
80107308:	57                   	push   %edi
80107309:	51                   	push   %ecx
8010730a:	50                   	push   %eax
8010730b:	ff 75 10             	push   0x10(%ebp)
8010730e:	e8 7d a7 ff ff       	call   80101a90 <readi>
80107313:	83 c4 10             	add    $0x10,%esp
80107316:	39 f8                	cmp    %edi,%eax
80107318:	75 1e                	jne    80107338 <loaduvm+0xc8>
8010731a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107320:	89 f0                	mov    %esi,%eax
80107322:	29 d8                	sub    %ebx,%eax
80107324:	39 c6                	cmp    %eax,%esi
80107326:	77 80                	ja     801072a8 <loaduvm+0x38>
80107328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010732b:	31 c0                	xor    %eax,%eax
8010732d:	5b                   	pop    %ebx
8010732e:	5e                   	pop    %esi
8010732f:	5f                   	pop    %edi
80107330:	5d                   	pop    %ebp
80107331:	c3                   	ret    
80107332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107338:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010733b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107340:	5b                   	pop    %ebx
80107341:	5e                   	pop    %esi
80107342:	5f                   	pop    %edi
80107343:	5d                   	pop    %ebp
80107344:	c3                   	ret    
80107345:	83 ec 0c             	sub    $0xc,%esp
80107348:	68 a8 83 10 80       	push   $0x801083a8
8010734d:	e8 2e 90 ff ff       	call   80100380 <panic>
80107352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107360 <allocuvm>:
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 45 10             	mov    0x10(%ebp),%eax
8010736c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010736f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107372:	85 c0                	test   %eax,%eax
80107374:	0f 88 b6 00 00 00    	js     80107430 <allocuvm+0xd0>
8010737a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010737d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107380:	0f 82 9a 00 00 00    	jb     80107420 <allocuvm+0xc0>
80107386:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010738c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107392:	39 75 10             	cmp    %esi,0x10(%ebp)
80107395:	77 44                	ja     801073db <allocuvm+0x7b>
80107397:	e9 87 00 00 00       	jmp    80107423 <allocuvm+0xc3>
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073a0:	83 ec 04             	sub    $0x4,%esp
801073a3:	68 00 10 00 00       	push   $0x1000
801073a8:	6a 00                	push   $0x0
801073aa:	50                   	push   %eax
801073ab:	e8 10 d9 ff ff       	call   80104cc0 <memset>
801073b0:	58                   	pop    %eax
801073b1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073b7:	5a                   	pop    %edx
801073b8:	6a 06                	push   $0x6
801073ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073bf:	89 f2                	mov    %esi,%edx
801073c1:	50                   	push   %eax
801073c2:	89 f8                	mov    %edi,%eax
801073c4:	e8 87 fb ff ff       	call   80106f50 <mappages>
801073c9:	83 c4 10             	add    $0x10,%esp
801073cc:	85 c0                	test   %eax,%eax
801073ce:	78 78                	js     80107448 <allocuvm+0xe8>
801073d0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073d6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073d9:	76 48                	jbe    80107423 <allocuvm+0xc3>
801073db:	e8 a0 b2 ff ff       	call   80102680 <kalloc>
801073e0:	89 c3                	mov    %eax,%ebx
801073e2:	85 c0                	test   %eax,%eax
801073e4:	75 ba                	jne    801073a0 <allocuvm+0x40>
801073e6:	83 ec 0c             	sub    $0xc,%esp
801073e9:	68 25 83 10 80       	push   $0x80108325
801073ee:	e8 ad 92 ff ff       	call   801006a0 <cprintf>
801073f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f6:	83 c4 10             	add    $0x10,%esp
801073f9:	39 45 10             	cmp    %eax,0x10(%ebp)
801073fc:	74 32                	je     80107430 <allocuvm+0xd0>
801073fe:	8b 55 10             	mov    0x10(%ebp),%edx
80107401:	89 c1                	mov    %eax,%ecx
80107403:	89 f8                	mov    %edi,%eax
80107405:	e8 96 fa ff ff       	call   80106ea0 <deallocuvm.part.0>
8010740a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107417:	5b                   	pop    %ebx
80107418:	5e                   	pop    %esi
80107419:	5f                   	pop    %edi
8010741a:	5d                   	pop    %ebp
8010741b:	c3                   	ret    
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107429:	5b                   	pop    %ebx
8010742a:	5e                   	pop    %esi
8010742b:	5f                   	pop    %edi
8010742c:	5d                   	pop    %ebp
8010742d:	c3                   	ret    
8010742e:	66 90                	xchg   %ax,%ax
80107430:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010743a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010743d:	5b                   	pop    %ebx
8010743e:	5e                   	pop    %esi
8010743f:	5f                   	pop    %edi
80107440:	5d                   	pop    %ebp
80107441:	c3                   	ret    
80107442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107448:	83 ec 0c             	sub    $0xc,%esp
8010744b:	68 3d 83 10 80       	push   $0x8010833d
80107450:	e8 4b 92 ff ff       	call   801006a0 <cprintf>
80107455:	8b 45 0c             	mov    0xc(%ebp),%eax
80107458:	83 c4 10             	add    $0x10,%esp
8010745b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010745e:	74 0c                	je     8010746c <allocuvm+0x10c>
80107460:	8b 55 10             	mov    0x10(%ebp),%edx
80107463:	89 c1                	mov    %eax,%ecx
80107465:	89 f8                	mov    %edi,%eax
80107467:	e8 34 fa ff ff       	call   80106ea0 <deallocuvm.part.0>
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	53                   	push   %ebx
80107470:	e8 4b b0 ff ff       	call   801024c0 <kfree>
80107475:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010747c:	83 c4 10             	add    $0x10,%esp
8010747f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107482:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107485:	5b                   	pop    %ebx
80107486:	5e                   	pop    %esi
80107487:	5f                   	pop    %edi
80107488:	5d                   	pop    %ebp
80107489:	c3                   	ret    
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <deallocuvm>:
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	8b 55 0c             	mov    0xc(%ebp),%edx
80107496:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107499:	8b 45 08             	mov    0x8(%ebp),%eax
8010749c:	39 d1                	cmp    %edx,%ecx
8010749e:	73 10                	jae    801074b0 <deallocuvm+0x20>
801074a0:	5d                   	pop    %ebp
801074a1:	e9 fa f9 ff ff       	jmp    80106ea0 <deallocuvm.part.0>
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi
801074b0:	89 d0                	mov    %edx,%eax
801074b2:	5d                   	pop    %ebp
801074b3:	c3                   	ret    
801074b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop

801074c0 <freevm>:
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 0c             	sub    $0xc,%esp
801074c9:	8b 75 08             	mov    0x8(%ebp),%esi
801074cc:	85 f6                	test   %esi,%esi
801074ce:	74 59                	je     80107529 <freevm+0x69>
801074d0:	31 c9                	xor    %ecx,%ecx
801074d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074d7:	89 f0                	mov    %esi,%eax
801074d9:	89 f3                	mov    %esi,%ebx
801074db:	e8 c0 f9 ff ff       	call   80106ea0 <deallocuvm.part.0>
801074e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074e6:	eb 0f                	jmp    801074f7 <freevm+0x37>
801074e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop
801074f0:	83 c3 04             	add    $0x4,%ebx
801074f3:	39 df                	cmp    %ebx,%edi
801074f5:	74 23                	je     8010751a <freevm+0x5a>
801074f7:	8b 03                	mov    (%ebx),%eax
801074f9:	a8 01                	test   $0x1,%al
801074fb:	74 f3                	je     801074f0 <freevm+0x30>
801074fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107502:	83 ec 0c             	sub    $0xc,%esp
80107505:	83 c3 04             	add    $0x4,%ebx
80107508:	05 00 00 00 80       	add    $0x80000000,%eax
8010750d:	50                   	push   %eax
8010750e:	e8 ad af ff ff       	call   801024c0 <kfree>
80107513:	83 c4 10             	add    $0x10,%esp
80107516:	39 df                	cmp    %ebx,%edi
80107518:	75 dd                	jne    801074f7 <freevm+0x37>
8010751a:	89 75 08             	mov    %esi,0x8(%ebp)
8010751d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107520:	5b                   	pop    %ebx
80107521:	5e                   	pop    %esi
80107522:	5f                   	pop    %edi
80107523:	5d                   	pop    %ebp
80107524:	e9 97 af ff ff       	jmp    801024c0 <kfree>
80107529:	83 ec 0c             	sub    $0xc,%esp
8010752c:	68 59 83 10 80       	push   $0x80108359
80107531:	e8 4a 8e ff ff       	call   80100380 <panic>
80107536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753d:	8d 76 00             	lea    0x0(%esi),%esi

80107540 <setupkvm>:
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	56                   	push   %esi
80107544:	53                   	push   %ebx
80107545:	e8 36 b1 ff ff       	call   80102680 <kalloc>
8010754a:	89 c6                	mov    %eax,%esi
8010754c:	85 c0                	test   %eax,%eax
8010754e:	74 42                	je     80107592 <setupkvm+0x52>
80107550:	83 ec 04             	sub    $0x4,%esp
80107553:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
80107558:	68 00 10 00 00       	push   $0x1000
8010755d:	6a 00                	push   $0x0
8010755f:	50                   	push   %eax
80107560:	e8 5b d7 ff ff       	call   80104cc0 <memset>
80107565:	83 c4 10             	add    $0x10,%esp
80107568:	8b 43 04             	mov    0x4(%ebx),%eax
8010756b:	83 ec 08             	sub    $0x8,%esp
8010756e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107571:	ff 73 0c             	push   0xc(%ebx)
80107574:	8b 13                	mov    (%ebx),%edx
80107576:	50                   	push   %eax
80107577:	29 c1                	sub    %eax,%ecx
80107579:	89 f0                	mov    %esi,%eax
8010757b:	e8 d0 f9 ff ff       	call   80106f50 <mappages>
80107580:	83 c4 10             	add    $0x10,%esp
80107583:	85 c0                	test   %eax,%eax
80107585:	78 19                	js     801075a0 <setupkvm+0x60>
80107587:	83 c3 10             	add    $0x10,%ebx
8010758a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107590:	75 d6                	jne    80107568 <setupkvm+0x28>
80107592:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107595:	89 f0                	mov    %esi,%eax
80107597:	5b                   	pop    %ebx
80107598:	5e                   	pop    %esi
80107599:	5d                   	pop    %ebp
8010759a:	c3                   	ret    
8010759b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010759f:	90                   	nop
801075a0:	83 ec 0c             	sub    $0xc,%esp
801075a3:	56                   	push   %esi
801075a4:	31 f6                	xor    %esi,%esi
801075a6:	e8 15 ff ff ff       	call   801074c0 <freevm>
801075ab:	83 c4 10             	add    $0x10,%esp
801075ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075b1:	89 f0                	mov    %esi,%eax
801075b3:	5b                   	pop    %ebx
801075b4:	5e                   	pop    %esi
801075b5:	5d                   	pop    %ebp
801075b6:	c3                   	ret    
801075b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075be:	66 90                	xchg   %ax,%ax

801075c0 <kvmalloc>:
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 08             	sub    $0x8,%esp
801075c6:	e8 75 ff ff ff       	call   80107540 <setupkvm>
801075cb:	a3 c4 57 11 80       	mov    %eax,0x801157c4
801075d0:	05 00 00 00 80       	add    $0x80000000,%eax
801075d5:	0f 22 d8             	mov    %eax,%cr3
801075d8:	c9                   	leave  
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <clearpteu>:
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 08             	sub    $0x8,%esp
801075e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e9:	8b 55 08             	mov    0x8(%ebp),%edx
801075ec:	89 c1                	mov    %eax,%ecx
801075ee:	c1 e9 16             	shr    $0x16,%ecx
801075f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075f4:	f6 c2 01             	test   $0x1,%dl
801075f7:	75 17                	jne    80107610 <clearpteu+0x30>
801075f9:	83 ec 0c             	sub    $0xc,%esp
801075fc:	68 6a 83 10 80       	push   $0x8010836a
80107601:	e8 7a 8d ff ff       	call   80100380 <panic>
80107606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
80107610:	c1 e8 0a             	shr    $0xa,%eax
80107613:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107619:	25 fc 0f 00 00       	and    $0xffc,%eax
8010761e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
80107625:	85 c0                	test   %eax,%eax
80107627:	74 d0                	je     801075f9 <clearpteu+0x19>
80107629:	83 20 fb             	andl   $0xfffffffb,(%eax)
8010762c:	c9                   	leave  
8010762d:	c3                   	ret    
8010762e:	66 90                	xchg   %ax,%ax

80107630 <copyuvm>:
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 1c             	sub    $0x1c,%esp
80107639:	e8 02 ff ff ff       	call   80107540 <setupkvm>
8010763e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107641:	85 c0                	test   %eax,%eax
80107643:	0f 84 bd 00 00 00    	je     80107706 <copyuvm+0xd6>
80107649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010764c:	85 c9                	test   %ecx,%ecx
8010764e:	0f 84 b2 00 00 00    	je     80107706 <copyuvm+0xd6>
80107654:	31 f6                	xor    %esi,%esi
80107656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765d:	8d 76 00             	lea    0x0(%esi),%esi
80107660:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107663:	89 f0                	mov    %esi,%eax
80107665:	c1 e8 16             	shr    $0x16,%eax
80107668:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010766b:	a8 01                	test   $0x1,%al
8010766d:	75 11                	jne    80107680 <copyuvm+0x50>
8010766f:	83 ec 0c             	sub    $0xc,%esp
80107672:	68 74 83 10 80       	push   $0x80108374
80107677:	e8 04 8d ff ff       	call   80100380 <panic>
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107680:	89 f2                	mov    %esi,%edx
80107682:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107687:	c1 ea 0a             	shr    $0xa,%edx
8010768a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107690:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
80107697:	85 c0                	test   %eax,%eax
80107699:	74 d4                	je     8010766f <copyuvm+0x3f>
8010769b:	8b 00                	mov    (%eax),%eax
8010769d:	a8 01                	test   $0x1,%al
8010769f:	0f 84 9f 00 00 00    	je     80107744 <copyuvm+0x114>
801076a5:	89 c7                	mov    %eax,%edi
801076a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801076ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801076b5:	e8 c6 af ff ff       	call   80102680 <kalloc>
801076ba:	89 c3                	mov    %eax,%ebx
801076bc:	85 c0                	test   %eax,%eax
801076be:	74 64                	je     80107724 <copyuvm+0xf4>
801076c0:	83 ec 04             	sub    $0x4,%esp
801076c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076c9:	68 00 10 00 00       	push   $0x1000
801076ce:	57                   	push   %edi
801076cf:	50                   	push   %eax
801076d0:	e8 8b d6 ff ff       	call   80104d60 <memmove>
801076d5:	58                   	pop    %eax
801076d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076dc:	5a                   	pop    %edx
801076dd:	ff 75 e4             	push   -0x1c(%ebp)
801076e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076e5:	89 f2                	mov    %esi,%edx
801076e7:	50                   	push   %eax
801076e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076eb:	e8 60 f8 ff ff       	call   80106f50 <mappages>
801076f0:	83 c4 10             	add    $0x10,%esp
801076f3:	85 c0                	test   %eax,%eax
801076f5:	78 21                	js     80107718 <copyuvm+0xe8>
801076f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107700:	0f 87 5a ff ff ff    	ja     80107660 <copyuvm+0x30>
80107706:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010770c:	5b                   	pop    %ebx
8010770d:	5e                   	pop    %esi
8010770e:	5f                   	pop    %edi
8010770f:	5d                   	pop    %ebp
80107710:	c3                   	ret    
80107711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107718:	83 ec 0c             	sub    $0xc,%esp
8010771b:	53                   	push   %ebx
8010771c:	e8 9f ad ff ff       	call   801024c0 <kfree>
80107721:	83 c4 10             	add    $0x10,%esp
80107724:	83 ec 0c             	sub    $0xc,%esp
80107727:	ff 75 e0             	push   -0x20(%ebp)
8010772a:	e8 91 fd ff ff       	call   801074c0 <freevm>
8010772f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107736:	83 c4 10             	add    $0x10,%esp
80107739:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010773c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773f:	5b                   	pop    %ebx
80107740:	5e                   	pop    %esi
80107741:	5f                   	pop    %edi
80107742:	5d                   	pop    %ebp
80107743:	c3                   	ret    
80107744:	83 ec 0c             	sub    $0xc,%esp
80107747:	68 8e 83 10 80       	push   $0x8010838e
8010774c:	e8 2f 8c ff ff       	call   80100380 <panic>
80107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775f:	90                   	nop

80107760 <uva2ka>:
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	8b 45 0c             	mov    0xc(%ebp),%eax
80107766:	8b 55 08             	mov    0x8(%ebp),%edx
80107769:	89 c1                	mov    %eax,%ecx
8010776b:	c1 e9 16             	shr    $0x16,%ecx
8010776e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107771:	f6 c2 01             	test   $0x1,%dl
80107774:	0f 84 00 01 00 00    	je     8010787a <uva2ka.cold>
8010777a:	c1 e8 0c             	shr    $0xc,%eax
8010777d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107783:	5d                   	pop    %ebp
80107784:	25 ff 03 00 00       	and    $0x3ff,%eax
80107789:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
80107790:	89 c2                	mov    %eax,%edx
80107792:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107797:	83 e2 05             	and    $0x5,%edx
8010779a:	05 00 00 00 80       	add    $0x80000000,%eax
8010779f:	83 fa 05             	cmp    $0x5,%edx
801077a2:	ba 00 00 00 00       	mov    $0x0,%edx
801077a7:	0f 45 c2             	cmovne %edx,%eax
801077aa:	c3                   	ret    
801077ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077af:	90                   	nop

801077b0 <copyout>:
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 0c             	sub    $0xc,%esp
801077b9:	8b 75 14             	mov    0x14(%ebp),%esi
801077bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801077bf:	8b 55 10             	mov    0x10(%ebp),%edx
801077c2:	85 f6                	test   %esi,%esi
801077c4:	75 51                	jne    80107817 <copyout+0x67>
801077c6:	e9 a5 00 00 00       	jmp    80107870 <copyout+0xc0>
801077cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077cf:	90                   	nop
801077d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
801077dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801077e2:	74 75                	je     80107859 <copyout+0xa9>
801077e4:	89 fb                	mov    %edi,%ebx
801077e6:	89 55 10             	mov    %edx,0x10(%ebp)
801077e9:	29 c3                	sub    %eax,%ebx
801077eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077f1:	39 f3                	cmp    %esi,%ebx
801077f3:	0f 47 de             	cmova  %esi,%ebx
801077f6:	29 f8                	sub    %edi,%eax
801077f8:	83 ec 04             	sub    $0x4,%esp
801077fb:	01 c1                	add    %eax,%ecx
801077fd:	53                   	push   %ebx
801077fe:	52                   	push   %edx
801077ff:	51                   	push   %ecx
80107800:	e8 5b d5 ff ff       	call   80104d60 <memmove>
80107805:	8b 55 10             	mov    0x10(%ebp),%edx
80107808:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
8010780e:	83 c4 10             	add    $0x10,%esp
80107811:	01 da                	add    %ebx,%edx
80107813:	29 de                	sub    %ebx,%esi
80107815:	74 59                	je     80107870 <copyout+0xc0>
80107817:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010781a:	89 c1                	mov    %eax,%ecx
8010781c:	89 c7                	mov    %eax,%edi
8010781e:	c1 e9 16             	shr    $0x16,%ecx
80107821:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107827:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010782a:	f6 c1 01             	test   $0x1,%cl
8010782d:	0f 84 4e 00 00 00    	je     80107881 <copyout.cold>
80107833:	89 fb                	mov    %edi,%ebx
80107835:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
8010783b:	c1 eb 0c             	shr    $0xc,%ebx
8010783e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80107844:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
8010784b:	89 d9                	mov    %ebx,%ecx
8010784d:	83 e1 05             	and    $0x5,%ecx
80107850:	83 f9 05             	cmp    $0x5,%ecx
80107853:	0f 84 77 ff ff ff    	je     801077d0 <copyout+0x20>
80107859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010785c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107861:	5b                   	pop    %ebx
80107862:	5e                   	pop    %esi
80107863:	5f                   	pop    %edi
80107864:	5d                   	pop    %ebp
80107865:	c3                   	ret    
80107866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786d:	8d 76 00             	lea    0x0(%esi),%esi
80107870:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107873:	31 c0                	xor    %eax,%eax
80107875:	5b                   	pop    %ebx
80107876:	5e                   	pop    %esi
80107877:	5f                   	pop    %edi
80107878:	5d                   	pop    %ebp
80107879:	c3                   	ret    

8010787a <uva2ka.cold>:
8010787a:	a1 00 00 00 00       	mov    0x0,%eax
8010787f:	0f 0b                	ud2    

80107881 <copyout.cold>:
80107881:	a1 00 00 00 00       	mov    0x0,%eax
80107886:	0f 0b                	ud2    
