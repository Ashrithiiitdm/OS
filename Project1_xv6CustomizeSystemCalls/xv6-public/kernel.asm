
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc d0 67 11 80       	mov    $0x801167d0,%esp
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 78 10 80       	push   $0x801078e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 4a 00 00       	call   80104a80 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 78 10 80       	push   $0x801078e7
80100097:	50                   	push   %eax
80100098:	e8 b3 48 00 00       	call   80104950 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 67 4b 00 00       	call   80104c50 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 89 4a 00 00       	call   80104bf0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 48 00 00       	call   80104990 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 78 10 80       	push   $0x801078ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 48 00 00       	call   80104a30 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 78 10 80       	push   $0x801078ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 48 00 00       	call   80104a30 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 47 00 00       	call   801049f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 30 4a 00 00       	call   80104c50 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 7f 49 00 00       	jmp    80104bf0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 79 10 80       	push   $0x80107906
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 ab 49 00 00       	call   80104c50 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 be 3d 00 00       	call   80104090 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 36 00 00       	call   80103990 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 f5 48 00 00       	call   80104bf0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 9f 48 00 00       	call   80104bf0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 79 10 80       	push   $0x8010790d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 ed 7e 10 80 	movl   $0x80107eed,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 46 00 00       	call   80104aa0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 79 10 80       	push   $0x80107921
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 e1 5f 00 00       	call   80106400 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
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
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 f6 5e 00 00       	call   80106400 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ea 5e 00 00       	call   80106400 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 de 5e 00 00       	call   80106400 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 5a 48 00 00       	call   80104db0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 a5 47 00 00       	call   80104d10 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 79 10 80       	push   $0x80107925
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 a0 46 00 00       	call   80104c50 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 07 46 00 00       	call   80104bf0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 50 79 10 80 	movzbl -0x7fef86b0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 63 44 00 00       	call   80104c50 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
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
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 79 10 80       	mov    $0x80107938,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 90 43 00 00       	call   80104bf0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 79 10 80       	push   $0x8010793f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 b8 43 00 00       	call   80104c50 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
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
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 1b 42 00 00       	call   80104bf0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 1d 38 00 00       	jmp    80104230 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 07 37 00 00       	call   80104150 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 79 10 80       	push   $0x80107948
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 0b 40 00 00       	call   80104a80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
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
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 cf 2e 00 00       	call   80103990 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 57 6a 00 00       	call   80107590 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 08 68 00 00       	call   801073b0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 e2 66 00 00       	call   801072c0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 f0 68 00 00       	call   80107510 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 49 67 00 00       	call   801073b0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 a8 69 00 00       	call   80107630 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
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
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 38 42 00 00       	call   80104f10 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 24 42 00 00       	call   80104f10 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 6b 00 00       	call   80107800 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 67 00 00       	call   80107510 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 98 6a 00 00       	call   80107800 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 2a 41 00 00       	call   80104ed0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 5e 63 00 00       	call   80107130 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 36 67 00 00       	call   80107510 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 79 10 80       	push   $0x80107961
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 6d 79 10 80       	push   $0x8010796d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 5b 3c 00 00       	call   80104a80 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 0a 3e 00 00       	call   80104c50 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 7a 3d 00 00       	call   80104bf0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 61 3d 00 00       	call   80104bf0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 9c 3d 00 00       	call   80104c50 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 1f 3d 00 00       	call   80104bf0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 79 10 80       	push   $0x80107974
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 4a 3d 00 00       	call   80104c50 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 af 3c 00 00       	call   80104bf0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 7d 3c 00 00       	jmp    80104bf0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 7c 79 10 80       	push   $0x8010797c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 86 79 10 80       	push   $0x80107986
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
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
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
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
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 8f 79 10 80       	push   $0x8010798f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 95 79 10 80       	push   $0x80107995
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 9f 79 10 80       	push   $0x8010799f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
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
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 b2 79 10 80       	push   $0x801079b2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 e6 39 00 00       	call   80104d10 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
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
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 e1 38 00 00       	call   80104c50 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 14 38 00 00       	call   80104bf0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 e6 37 00 00       	call   80104bf0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 c8 79 10 80       	push   $0x801079c8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 d8 79 10 80       	push   $0x801079d8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 6a 38 00 00       	call   80104db0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 eb 79 10 80       	push   $0x801079eb
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 05 35 00 00       	call   80104a80 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 f2 79 10 80       	push   $0x801079f2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 bc 33 00 00       	call   80104950 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 ef 37 00 00       	call   80104db0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 58 7a 10 80       	push   $0x80107a58
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 7d 36 00 00       	call   80104d10 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 f8 79 10 80       	push   $0x801079f8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 7a 36 00 00       	call   80104db0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 ec 34 00 00       	call   80104c50 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 7c 34 00 00       	call   80104bf0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 e9 31 00 00       	call   80104990 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 93 35 00 00       	call   80104db0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 10 7a 10 80       	push   $0x80107a10
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 0a 7a 10 80       	push   $0x80107a0a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 b8 31 00 00       	call   80104a30 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 5c 31 00 00       	jmp    801049f0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 1f 7a 10 80       	push   $0x80107a1f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 cb 30 00 00       	call   80104990 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 11 31 00 00       	call   801049f0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 65 33 00 00       	call   80104c50 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 eb 32 00 00       	jmp    80104bf0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 3b 33 00 00       	call   80104c50 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 cc 32 00 00       	call   80104bf0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 08 30 00 00       	call   80104a30 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 b1 2f 00 00       	call   801049f0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 1f 7a 10 80       	push   $0x80107a1f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
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
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
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
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 74 32 00 00       	call   80104db0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 78 31 00 00       	call   80104db0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 4d 31 00 00       	call   80104e20 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 ee 30 00 00       	call   80104e20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 39 7a 10 80       	push   $0x80107a39
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 27 7a 10 80       	push   $0x80107a27
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 e1 1b 00 00       	call   80103990 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 91 2e 00 00       	call   80104c50 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 21 2e 00 00       	call   80104bf0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 84 2f 00 00       	call   80104db0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 9f 2b 00 00       	call   80104a30 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 3d 2b 00 00       	call   801049f0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 d0 2e 00 00       	call   80104db0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 00 2b 00 00       	call   80104a30 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 a1 2a 00 00       	call   801049f0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 be 2a 00 00       	call   80104a30 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 9b 2a 00 00       	call   80104a30 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 44 2a 00 00       	call   801049f0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 1f 7a 10 80       	push   $0x80107a1f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
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
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 2e 2e 00 00       	call   80104e70 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 48 7a 10 80       	push   $0x80107a48
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 de 81 10 80       	push   $0x801081de
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
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

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
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
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 b4 7a 10 80       	push   $0x80107ab4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 ab 7a 10 80       	push   $0x80107aab
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 c6 7a 10 80       	push   $0x80107ac6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 ab 28 00 00       	call   80104a80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 fd 29 00 00       	call   80104c50 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 9e 1e 00 00       	call   80104150 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 20 29 00 00       	call   80104bf0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 3d 27 00 00       	call   80104a30 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 23 29 00 00       	call   80104c50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 22 1d 00 00       	call   80104090 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 65 28 00 00       	jmp    80104bf0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 f5 7a 10 80       	push   $0x80107af5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 e0 7a 10 80       	push   $0x80107ae0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ca 7a 10 80       	push   $0x80107aca
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 14 7b 10 80       	push   $0x80107b14
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
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
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 67 11 80    	cmp    $0x801167d0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 19 28 00 00       	call   80104d10 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 23 27 00 00       	call   80104c50 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 a8 26 00 00       	jmp    80104bf0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 46 7b 10 80       	push   $0x80107b46
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 4c 7b 10 80       	push   $0x80107b4c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 56 24 00 00       	call   80104a80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 98 25 00 00       	call   80104c50 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 0a 25 00 00       	call   80104bf0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 80 7b 10 80 	movzbl -0x7fef8480(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
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
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
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
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
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
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 64 22 00 00       	call   80104d60 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
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
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
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
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 87 21 00 00       	call   80104db0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
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
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 80 7d 10 80       	push   $0x80107d80
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 a7 1d 00 00       	call   80104a80 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 e0 1e 00 00       	call   80104c50 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 06 13 00 00       	call   80104090 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 2f 1e 00 00       	call   80104bf0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 6d 1e 00 00       	call   80104c50 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 cf 1d 00 00       	call   80104bf0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 15 1e 00 00       	call   80104c50 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 ff 12 00 00       	call   80104150 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 93 1d 00 00       	call   80104bf0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 f7 1e 00 00       	call   80104db0 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 43 12 00 00       	call   80104150 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 d7 1c 00 00       	call   80104bf0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 84 7d 10 80       	push   $0x80107d84
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 d5 1c 00 00       	call   80104c50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 36 1c 00 00       	jmp    80104bf0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 93 7d 10 80       	push   $0x80107d93
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 a9 7d 10 80       	push   $0x80107da9
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 64 09 00 00       	call   80103970 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 5d 09 00 00       	call   80103970 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 c4 7d 10 80       	push   $0x80107dc4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 e9 2f 00 00       	call   80106010 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 e4 08 00 00       	call   80103910 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 11 0c 00 00       	call   80103c50 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 d5 40 00 00       	call   80107120 <switchkvm>
  seginit();
8010304b:	e8 40 40 00 00       	call   80107090 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 d0 67 11 80       	push   $0x801167d0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 8a 45 00 00       	call   80107610 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 fb 3f 00 00       	call   80107090 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 77 32 00 00       	call   80106320 <uartinit>
  pinit();         // process table
801030a9:	e8 42 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 dd 2e 00 00       	call   80105f90 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 d7 1c 00 00       	call   80104db0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
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
    if(c == mycpu())  // We've started already.
80103119:	e8 f2 07 00 00       	call   80103910 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 39 08 00 00       	call   801039c0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 d8 7d 10 80       	push   $0x80107dd8
801031c3:	56                   	push   %esi
801031c4:	e8 97 1b 00 00       	call   80104d60 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
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
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 dd 7d 10 80       	push   $0x80107ddd
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 dc 1a 00 00       	call   80104d60 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 e2 7d 10 80       	push   $0x80107de2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 d8 7d 10 80       	push   $0x80107dd8
801033c7:	53                   	push   %ebx
801033c8:	e8 93 19 00 00       	call   80104d60 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 fc 7d 10 80       	push   $0x80107dfc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 1b 7e 10 80       	push   $0x80107e1b
801034a8:	50                   	push   %eax
801034a9:	e8 d2 15 00 00       	call   80104a80 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 0c 17 00 00       	call   80104c50 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 ec 0b 00 00       	call   80104150 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 67 16 00 00       	jmp    80104bf0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 57 16 00 00       	call   80104bf0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 87 0b 00 00       	call   80104150 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 6e 16 00 00       	call   80104c50 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 63 03 00 00       	call   80103990 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 13 0b 00 00       	call   80104150 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 4a 0a 00 00       	call   80104090 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 7f 15 00 00       	call   80104bf0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 91 0a 00 00       	call   80104150 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 29 15 00 00       	call   80104bf0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 65 15 00 00       	call   80104c50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 8b 02 00 00       	call   80103990 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 76 09 00 00       	call   80104090 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 d5 09 00 00       	call   80104150 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 6d 14 00 00       	call   80104bf0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 52 14 00 00       	call   80104bf0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
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
801037c1:	e8 8a 14 00 00       	call   80104c50 <acquire>
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
8010381a:	e8 d1 13 00 00       	call   80104bf0 <release>

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
8010383f:	c7 40 14 7d 5f 10 80 	movl   $0x80105f7d,0x14(%eax)
    p->context = (struct context*)sp;
80103846:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103849:	6a 14                	push   $0x14
8010384b:	6a 00                	push   $0x0
8010384d:	50                   	push   %eax
8010384e:	e8 bd 14 00 00       	call   80104d10 <memset>
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
8010387a:	e8 71 13 00 00       	call   80104bf0 <release>
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
801038ab:	e8 40 13 00 00       	call   80104bf0 <release>

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
801038f6:	68 20 7e 10 80       	push   $0x80107e20
801038fb:	68 20 2d 11 80       	push   $0x80112d20
80103900:	e8 7b 11 00 00       	call   80104a80 <initlock>
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
80103958:	68 27 7e 10 80       	push   $0x80107e27
8010395d:	e8 1e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 60 7f 10 80       	push   $0x80107f60
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
80103997:	e8 64 11 00 00       	call   80104b00 <pushcli>
  c = mycpu();
8010399c:	e8 6f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a7:	e8 a4 11 00 00       	call   80104b50 <popcli>
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
801039d3:	e8 b8 3b 00 00       	call   80107590 <setupkvm>
801039d8:	89 43 04             	mov    %eax,0x4(%ebx)
801039db:	85 c0                	test   %eax,%eax
801039dd:	0f 84 bd 00 00 00    	je     80103aa0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e3:	83 ec 04             	sub    $0x4,%esp
801039e6:	68 2c 00 00 00       	push   $0x2c
801039eb:	68 60 b4 10 80       	push   $0x8010b460
801039f0:	50                   	push   %eax
801039f1:	e8 4a 38 00 00       	call   80107240 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ff:	6a 4c                	push   $0x4c
80103a01:	6a 00                	push   $0x0
80103a03:	ff 73 18             	push   0x18(%ebx)
80103a06:	e8 05 13 00 00       	call   80104d10 <memset>
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
80103a5f:	68 50 7e 10 80       	push   $0x80107e50
80103a64:	50                   	push   %eax
80103a65:	e8 66 14 00 00       	call   80104ed0 <safestrcpy>
  p->cwd = namei("/");
80103a6a:	c7 04 24 59 7e 10 80 	movl   $0x80107e59,(%esp)
80103a71:	e8 2a e6 ff ff       	call   801020a0 <namei>
80103a76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a80:	e8 cb 11 00 00       	call   80104c50 <acquire>
  p->state = RUNNABLE;
80103a85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a93:	e8 58 11 00 00       	call   80104bf0 <release>
}
80103a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 37 7e 10 80       	push   $0x80107e37
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
80103ab8:	e8 43 10 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80103abd:	e8 4e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac8:	e8 83 10 00 00       	call   80104b50 <popcli>
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
80103adb:	e8 50 36 00 00       	call   80107130 <switchuvm>
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
80103afa:	e8 b1 38 00 00       	call   801073b0 <allocuvm>
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
80103b1a:	e8 c1 39 00 00       	call   801074e0 <deallocuvm>
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
80103b39:	e8 c2 0f 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80103b3e:	e8 cd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b49:	e8 02 10 00 00       	call   80104b50 <popcli>
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
80103b68:	e8 13 3b 00 00       	call   80107680 <copyuvm>
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
80103be1:	e8 ea 12 00 00       	call   80104ed0 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf0:	e8 5b 10 00 00       	call   80104c50 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c03:	e8 e8 0f 00 00       	call   80104bf0 <release>
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
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    high_p = 0;
80103c74:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103c76:	68 20 2d 11 80       	push   $0x80112d20
80103c7b:	e8 d0 0f 00 00       	call   80104c50 <acquire>
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
80103cd6:	e8 55 34 00 00       	call   80107130 <switchuvm>
      high_p->state = RUNNING;
80103cdb:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), high_p->context);
80103ce2:	58                   	pop    %eax
80103ce3:	5a                   	pop    %edx
80103ce4:	ff 77 1c             	push   0x1c(%edi)
80103ce7:	56                   	push   %esi
80103ce8:	e8 3e 12 00 00       	call   80104f2b <swtch>
      switchkvm();
80103ced:	e8 2e 34 00 00       	call   80107120 <switchkvm>
      c->proc = 0;
80103cf2:	83 c4 10             	add    $0x10,%esp
80103cf5:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103cfc:	00 00 00 
    release(&ptable.lock);
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	68 20 2d 11 80       	push   $0x80112d20
80103d07:	e8 e4 0e 00 00       	call   80104bf0 <release>
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
80103d25:	e8 d6 0d 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80103d2a:	e8 e1 fb ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103d2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d35:	e8 16 0e 00 00       	call   80104b50 <popcli>
  if(!holding(&ptable.lock))
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 20 2d 11 80       	push   $0x80112d20
80103d42:	e8 69 0e 00 00       	call   80104bb0 <holding>
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
80103d83:	e8 a3 11 00 00       	call   80104f2b <swtch>
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
80103da0:	68 5b 7e 10 80       	push   $0x80107e5b
80103da5:	e8 d6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 87 7e 10 80       	push   $0x80107e87
80103db2:	e8 c9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	68 79 7e 10 80       	push   $0x80107e79
80103dbf:	e8 bc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	68 6d 7e 10 80       	push   $0x80107e6d
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
80103e4a:	e8 01 0e 00 00       	call   80104c50 <acquire>
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
80103ef7:	68 a8 7e 10 80       	push   $0x80107ea8
80103efc:	e8 7f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f01:	83 ec 0c             	sub    $0xc,%esp
80103f04:	68 9b 7e 10 80       	push   $0x80107e9b
80103f09:	e8 72 c4 ff ff       	call   80100380 <panic>
80103f0e:	66 90                	xchg   %ax,%ax

80103f10 <wait>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  pushcli();
80103f15:	e8 e6 0b 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80103f1a:	e8 f1 f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f25:	e8 26 0c 00 00       	call   80104b50 <popcli>
  acquire(&ptable.lock);
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 20 2d 11 80       	push   $0x80112d20
80103f32:	e8 19 0d 00 00       	call   80104c50 <acquire>
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
80103f87:	e8 74 0b 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80103f8c:	e8 7f f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f97:	e8 b4 0b 00 00       	call   80104b50 <popcli>
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
80103fd9:	e8 32 35 00 00       	call   80107510 <freevm>
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
80104005:	e8 e6 0b 00 00       	call   80104bf0 <release>
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
80104023:	e8 c8 0b 00 00       	call   80104bf0 <release>
      return -1;
80104028:	83 c4 10             	add    $0x10,%esp
8010402b:	eb e0                	jmp    8010400d <wait+0xfd>
    panic("sleep");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 b4 7e 10 80       	push   $0x80107eb4
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
8010404c:	e8 ff 0b 00 00       	call   80104c50 <acquire>
  pushcli();
80104051:	e8 aa 0a 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80104056:	e8 b5 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 ea 0a 00 00       	call   80104b50 <popcli>
  myproc()->state = RUNNABLE;
80104066:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010406d:	e8 ae fc ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80104072:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104079:	e8 72 0b 00 00       	call   80104bf0 <release>
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
8010409f:	e8 5c 0a 00 00       	call   80104b00 <pushcli>
  c = mycpu();
801040a4:	e8 67 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801040a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040af:	e8 9c 0a 00 00       	call   80104b50 <popcli>
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
801040d0:	e8 7b 0b 00 00       	call   80104c50 <acquire>
    release(lk);
801040d5:	89 34 24             	mov    %esi,(%esp)
801040d8:	e8 13 0b 00 00       	call   80104bf0 <release>
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
801040fa:	e8 f1 0a 00 00       	call   80104bf0 <release>
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
8010410c:	e9 3f 0b 00 00       	jmp    80104c50 <acquire>
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
80104139:	68 ba 7e 10 80       	push   $0x80107eba
8010413e:	e8 3d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 b4 7e 10 80       	push   $0x80107eb4
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
8010415f:	e8 ec 0a 00 00       	call   80104c50 <acquire>
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
801041a5:	e9 46 0a 00 00       	jmp    80104bf0 <release>
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
801041bf:	e8 8c 0a 00 00       	call   80104c50 <acquire>
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
801041fd:	e8 ee 09 00 00       	call   80104bf0 <release>
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
80104218:	e8 d3 09 00 00       	call   80104bf0 <release>
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
8010424b:	68 ed 7e 10 80       	push   $0x80107eed
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
80104271:	ba cb 7e 10 80       	mov    $0x80107ecb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104276:	83 f8 05             	cmp    $0x5,%eax
80104279:	77 11                	ja     8010428c <procdump+0x5c>
8010427b:	8b 14 85 d0 80 10 80 	mov    -0x7fef7f30(,%eax,4),%edx
      state = "???";
80104282:	b8 cb 7e 10 80       	mov    $0x80107ecb,%eax
80104287:	85 d2                	test   %edx,%edx
80104289:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010428c:	53                   	push   %ebx
8010428d:	52                   	push   %edx
8010428e:	ff 73 a4             	push   -0x5c(%ebx)
80104291:	68 cf 7e 10 80       	push   $0x80107ecf
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
801042b8:	e8 e3 07 00 00       	call   80104aa0 <getcallerpcs>
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
801042cd:	68 21 79 10 80       	push   $0x80107921
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
80104308:	e8 43 09 00 00       	call   80104c50 <acquire>
	cprintf("name \t pid \t state \t \n");
8010430d:	c7 04 24 d8 7e 10 80 	movl   $0x80107ed8,(%esp)
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
80104349:	68 ef 7e 10 80       	push   $0x80107eef
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
80104362:	e8 89 08 00 00       	call   80104bf0 <release>
	
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
8010437f:	68 07 7f 10 80       	push   $0x80107f07
80104384:	e8 17 c3 ff ff       	call   801006a0 <cprintf>
80104389:	83 c4 10             	add    $0x10,%esp
8010438c:	eb 9c                	jmp    8010432a <cps+0x3a>
8010438e:	66 90                	xchg   %ax,%ax
	      cprintf("%s \t %d \t RUNNABLE \t \n ", p->name, p->pid);
80104390:	83 ec 04             	sub    $0x4,%esp
80104393:	ff 73 a4             	push   -0x5c(%ebx)
80104396:	53                   	push   %ebx
80104397:	68 1e 7f 10 80       	push   $0x80107f1e
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
801043bc:	e8 0f 0c 00 00       	call   80104fd0 <argint>
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
801043df:	e8 6c 08 00 00       	call   80104c50 <acquire>

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
80104424:	e8 c7 07 00 00       	call   80104bf0 <release>
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
80104440:	e8 ab 07 00 00       	call   80104bf0 <release>
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
80104458:	e8 93 07 00 00       	call   80104bf0 <release>
  return -1;
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104465:	c9                   	leave  
80104466:	c3                   	ret    
        release(&ptable.lock);
80104467:	83 ec 0c             	sub    $0xc,%esp
8010446a:	68 20 2d 11 80       	push   $0x80112d20
8010446f:	e8 7c 07 00 00       	call   80104bf0 <release>
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
80104498:	e8 63 06 00 00       	call   80104b00 <pushcli>
  c = mycpu();
8010449d:	e8 6e f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801044a2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044a8:	e8 a3 06 00 00       	call   80104b50 <popcli>
  int pid;
  struct proc *p;
  struct proc *currproc = myproc();
  
  if (argint(0, &pid) < 0) {
801044ad:	83 ec 08             	sub    $0x8,%esp
801044b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801044b3:	50                   	push   %eax
801044b4:	6a 00                	push   $0x0
801044b6:	e8 15 0b 00 00       	call   80104fd0 <argint>
801044bb:	83 c4 10             	add    $0x10,%esp
801044be:	85 c0                	test   %eax,%eax
801044c0:	0f 88 30 01 00 00    	js     801045f6 <wait_pid+0x166>
      return -1;
  }
  
  acquire(&ptable.lock);
801044c6:	83 ec 0c             	sub    $0xc,%esp
801044c9:	68 20 2d 11 80       	push   $0x80112d20
801044ce:	e8 7d 07 00 00       	call   80104c50 <acquire>
  cprintf("wait_pid: Acquired ptable.lock for pid %d\n", pid);
801044d3:	5b                   	pop    %ebx
801044d4:	58                   	pop    %eax
801044d5:	ff 75 f4             	push   -0xc(%ebp)
801044d8:	68 88 7f 10 80       	push   $0x80107f88
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
80104537:	68 dc 7f 10 80       	push   $0x80107fdc
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
80104556:	68 08 80 10 80       	push   $0x80108008
8010455b:	e8 40 c1 ff ff       	call   801006a0 <cprintf>
  pushcli();
80104560:	e8 9b 05 00 00       	call   80104b00 <pushcli>
  c = mycpu();
80104565:	e8 a6 f3 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010456a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104570:	e8 db 05 00 00       	call   80104b50 <popcli>
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
801045bf:	e8 2c 06 00 00       	call   80104bf0 <release>
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
801045d8:	e8 13 06 00 00       	call   80104bf0 <release>
      cprintf("wait_pid: Invalid target process %d\n", pid);
801045dd:	58                   	pop    %eax
801045de:	5a                   	pop    %edx
801045df:	ff 75 f4             	push   -0xc(%ebp)
801045e2:	68 b4 7f 10 80       	push   $0x80107fb4
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
80104603:	68 2c 80 10 80       	push   $0x8010802c
80104608:	e8 93 c0 ff ff       	call   801006a0 <cprintf>
      currproc->waiting_for = -1;
8010460d:	c7 46 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%esi)
      currproc->wait_state = 0;
80104614:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010461b:	00 00 00 
      release(&ptable.lock);
8010461e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104625:	e8 c6 05 00 00       	call   80104bf0 <release>
      return -1;
8010462a:	83 c4 10             	add    $0x10,%esp
8010462d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104632:	eb 95                	jmp    801045c9 <wait_pid+0x139>
    panic("sleep");
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	68 b4 7e 10 80       	push   $0x80107eb4
8010463c:	e8 3f bd ff ff       	call   80100380 <panic>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop

80104650 <unwait_pid>:

int unwait_pid(void){
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	53                   	push   %ebx
80104656:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104659:	e8 a2 04 00 00       	call   80104b00 <pushcli>
  c = mycpu();
8010465e:	e8 ad f2 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104663:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104669:	e8 e2 04 00 00       	call   80104b50 <popcli>
  int pid;
  struct proc *p;
  struct proc *currproc = myproc();
  int woken = 0;
  
  if (argint(0, &pid) < 0) {
8010466e:	83 ec 08             	sub    $0x8,%esp
80104671:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104674:	50                   	push   %eax
80104675:	6a 00                	push   $0x0
80104677:	e8 54 09 00 00       	call   80104fd0 <argint>
8010467c:	83 c4 10             	add    $0x10,%esp
8010467f:	85 c0                	test   %eax,%eax
80104681:	0f 88 0c 01 00 00    	js     80104793 <unwait_pid+0x143>
      return -1;
  }
  
  acquire(&ptable.lock);
80104687:	83 ec 0c             	sub    $0xc,%esp
  int woken = 0;
8010468a:	31 f6                	xor    %esi,%esi
  cprintf("unwait_pid: Process %d releasing waiters\n", currproc->pid);
  
  // Wake up the processes waiting for the current process (currproc)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010468c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80104691:	68 20 2d 11 80       	push   $0x80112d20
80104696:	e8 b5 05 00 00       	call   80104c50 <acquire>
  cprintf("unwait_pid: Process %d releasing waiters\n", currproc->pid);
8010469b:	58                   	pop    %eax
8010469c:	5a                   	pop    %edx
8010469d:	ff 77 10             	push   0x10(%edi)
801046a0:	68 58 80 10 80       	push   $0x80108058
801046a5:	e8 f6 bf ff ff       	call   801006a0 <cprintf>
801046aa:	83 c4 10             	add    $0x10,%esp
801046ad:	eb 13                	jmp    801046c2 <unwait_pid+0x72>
801046af:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046b0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801046b6:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801046bc:	0f 84 aa 00 00 00    	je     8010476c <unwait_pid+0x11c>
      //cprintf("unwait_pid: Checking process %d, waiting_for: %d, currproc pid: %d\n", 
        //      p->pid, p->waiting_for, currproc->pid);
      
      if (p->state == SLEEPING && 
801046c2:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801046c6:	75 e8                	jne    801046b0 <unwait_pid+0x60>
801046c8:	8b 47 10             	mov    0x10(%edi),%eax
801046cb:	39 43 7c             	cmp    %eax,0x7c(%ebx)
801046ce:	75 e0                	jne    801046b0 <unwait_pid+0x60>
          p->waiting_for == currproc->pid && 
          (pid == -1 || p->pid == pid)) {
801046d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
          p->waiting_for == currproc->pid && 
801046d3:	83 f8 ff             	cmp    $0xffffffff,%eax
801046d6:	74 05                	je     801046dd <unwait_pid+0x8d>
          (pid == -1 || p->pid == pid)) {
801046d8:	3b 43 10             	cmp    0x10(%ebx),%eax
801046db:	75 d3                	jne    801046b0 <unwait_pid+0x60>
  acquire(&ptable.lock);
801046dd:	83 ec 0c             	sub    $0xc,%esp
          
          p->wait_state = 0;
          p->waiting_for = -1;
801046e0:	c7 43 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%ebx)
  acquire(&ptable.lock);
801046e7:	68 20 2d 11 80       	push   $0x80112d20
          p->wait_state = 0;
801046ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801046f3:	00 00 00 
  acquire(&ptable.lock);
801046f6:	e8 55 05 00 00       	call   80104c50 <acquire>
801046fb:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046fe:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104703:	eb 0f                	jmp    80104714 <unwait_pid+0xc4>
80104705:	8d 76 00             	lea    0x0(%esi),%esi
80104708:	05 88 00 00 00       	add    $0x88,%eax
8010470d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104712:	74 24                	je     80104738 <unwait_pid+0xe8>
    if(p->state == SLEEPING && p->chan == chan)
80104714:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104718:	75 ee                	jne    80104708 <unwait_pid+0xb8>
8010471a:	39 58 20             	cmp    %ebx,0x20(%eax)
8010471d:	75 e9                	jne    80104708 <unwait_pid+0xb8>
      p->state = RUNNABLE;
8010471f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104726:	05 88 00 00 00       	add    $0x88,%eax
8010472b:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104730:	75 e2                	jne    80104714 <unwait_pid+0xc4>
80104732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104738:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010473b:	81 c3 88 00 00 00    	add    $0x88,%ebx
          wakeup(p);  // Wake up the parent process
          woken++;
80104741:	83 c6 01             	add    $0x1,%esi
  release(&ptable.lock);
80104744:	68 20 2d 11 80       	push   $0x80112d20
80104749:	e8 a2 04 00 00       	call   80104bf0 <release>
          cprintf("unwait_pid: Woke up process %d\n", p->pid);
8010474e:	59                   	pop    %ecx
8010474f:	58                   	pop    %eax
80104750:	ff 73 88             	push   -0x78(%ebx)
80104753:	68 84 80 10 80       	push   $0x80108084
80104758:	e8 43 bf ff ff       	call   801006a0 <cprintf>
8010475d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104760:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80104766:	0f 85 56 ff ff ff    	jne    801046c2 <unwait_pid+0x72>
      }
  }
  
  release(&ptable.lock);
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	68 20 2d 11 80       	push   $0x80112d20
80104774:	e8 77 04 00 00       	call   80104bf0 <release>
  cprintf("unwait_pid: Released %d waiting processes\n", woken);
80104779:	58                   	pop    %eax
8010477a:	5a                   	pop    %edx
8010477b:	56                   	push   %esi
8010477c:	68 a4 80 10 80       	push   $0x801080a4
80104781:	e8 1a bf ff ff       	call   801006a0 <cprintf>
  return woken;
80104786:	83 c4 10             	add    $0x10,%esp
}
80104789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010478c:	89 f0                	mov    %esi,%eax
8010478e:	5b                   	pop    %ebx
8010478f:	5e                   	pop    %esi
80104790:	5f                   	pop    %edi
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
      return -1;
80104793:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104798:	eb ef                	jmp    80104789 <unwait_pid+0x139>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <mem_usage>:

int mem_usage(void){
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
  int pid;
  int size = 0;
  int found = 0;

  //Get the pid (given as argument) from argint.
  if(argint(0, &pid) < 0){
801047a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int mem_usage(void){
801047a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &pid) < 0){
801047aa:	50                   	push   %eax
801047ab:	6a 00                	push   $0x0
801047ad:	e8 1e 08 00 00       	call   80104fd0 <argint>
801047b2:	83 c4 10             	add    $0x10,%esp
801047b5:	85 c0                	test   %eax,%eax
801047b7:	78 6b                	js     80104824 <mem_usage+0x84>
    return -1;
  }

  //Acquire the lock for synchronization.
  acquire(&ptable.lock);
801047b9:	83 ec 0c             	sub    $0xc,%esp
801047bc:	68 20 2d 11 80       	push   $0x80112d20
801047c1:	e8 8a 04 00 00       	call   80104c50 <acquire>

  //Going throught the process table for finding the process with the given pid.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801047c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047c9:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047cc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801047d1:	eb 11                	jmp    801047e4 <mem_usage+0x44>
801047d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d7:	90                   	nop
801047d8:	05 88 00 00 00       	add    $0x88,%eax
801047dd:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801047e2:	74 24                	je     80104808 <mem_usage+0x68>
    if(p->pid == pid){
801047e4:	39 50 10             	cmp    %edx,0x10(%eax)
801047e7:	75 ef                	jne    801047d8 <mem_usage+0x38>

    }
  }

  //If not found return -1;
  release(&ptable.lock);
801047e9:	83 ec 0c             	sub    $0xc,%esp
      size = p->sz;
801047ec:	8b 18                	mov    (%eax),%ebx
  release(&ptable.lock);
801047ee:	68 20 2d 11 80       	push   $0x80112d20
801047f3:	e8 f8 03 00 00       	call   80104bf0 <release>
801047f8:	83 c4 10             	add    $0x10,%esp
  if(!found){
    return -1;
  }
  
  return size;
}
801047fb:	89 d8                	mov    %ebx,%eax
801047fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104800:	c9                   	leave  
80104801:	c3                   	ret    
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104808:	83 ec 0c             	sub    $0xc,%esp
    return -1;
8010480b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&ptable.lock);
80104810:	68 20 2d 11 80       	push   $0x80112d20
80104815:	e8 d6 03 00 00       	call   80104bf0 <release>
}
8010481a:	89 d8                	mov    %ebx,%eax
    return -1;
8010481c:	83 c4 10             	add    $0x10,%esp
}
8010481f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104822:	c9                   	leave  
80104823:	c3                   	ret    
    return -1;
80104824:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104829:	eb d0                	jmp    801047fb <mem_usage+0x5b>
8010482b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop

80104830 <get_priority>:

int get_priority(void){
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
  int pid;
  int priority = -1;
  if(argint(0, &pid) < 0){
80104834:	8d 45 f4             	lea    -0xc(%ebp),%eax
int get_priority(void){
80104837:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &pid) < 0){
8010483a:	50                   	push   %eax
8010483b:	6a 00                	push   $0x0
8010483d:	e8 8e 07 00 00       	call   80104fd0 <argint>
80104842:	83 c4 10             	add    $0x10,%esp
80104845:	85 c0                	test   %eax,%eax
80104847:	78 52                	js     8010489b <get_priority+0x6b>
    return -1;
  }

  struct proc *p;

  acquire(&ptable.lock);
80104849:	83 ec 0c             	sub    $0xc,%esp
8010484c:	68 20 2d 11 80       	push   $0x80112d20
80104851:	e8 fa 03 00 00       	call   80104c50 <acquire>

  //loop through the list of processes and find the process with the given pid
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80104856:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104859:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
8010485c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104861:	eb 11                	jmp    80104874 <get_priority+0x44>
80104863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104867:	90                   	nop
80104868:	05 88 00 00 00       	add    $0x88,%eax
8010486d:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104872:	74 34                	je     801048a8 <get_priority+0x78>
    if(p->pid == pid){
80104874:	39 50 10             	cmp    %edx,0x10(%eax)
80104877:	75 ef                	jne    80104868 <get_priority+0x38>
      priority =  p->priority;
      break;
    }
  }

  release(&ptable.lock);
80104879:	83 ec 0c             	sub    $0xc,%esp
      priority =  p->priority;
8010487c:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  release(&ptable.lock);
80104882:	68 20 2d 11 80       	push   $0x80112d20
80104887:	e8 64 03 00 00       	call   80104bf0 <release>

  if(priority==-1){
8010488c:	83 c4 10             	add    $0x10,%esp
8010488f:	83 fb ff             	cmp    $0xffffffff,%ebx
80104892:	74 24                	je     801048b8 <get_priority+0x88>
    return -2; // pid not found
  }

  return priority;  
}
80104894:	89 d8                	mov    %ebx,%eax
80104896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104899:	c9                   	leave  
8010489a:	c3                   	ret    
    return -1;
8010489b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801048a0:	eb f2                	jmp    80104894 <get_priority+0x64>
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 20 2d 11 80       	push   $0x80112d20
801048b0:	e8 3b 03 00 00       	call   80104bf0 <release>
801048b5:	83 c4 10             	add    $0x10,%esp
    return -2; // pid not found
801048b8:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
801048bd:	eb d5                	jmp    80104894 <get_priority+0x64>
801048bf:	90                   	nop

801048c0 <set_priority>:

int set_priority(void){
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
    int pid, priority;
    int setPrior = -1; 
    if(argint(0, &pid) || argint(1, &priority)){
801048c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
int set_priority(void){
801048c7:	83 ec 1c             	sub    $0x1c,%esp
    if(argint(0, &pid) || argint(1, &priority)){
801048ca:	50                   	push   %eax
801048cb:	6a 00                	push   $0x0
801048cd:	e8 fe 06 00 00       	call   80104fd0 <argint>
801048d2:	83 c4 10             	add    $0x10,%esp
801048d5:	85 c0                	test   %eax,%eax
801048d7:	75 67                	jne    80104940 <set_priority+0x80>
801048d9:	83 ec 08             	sub    $0x8,%esp
801048dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048df:	50                   	push   %eax
801048e0:	6a 01                	push   $0x1
801048e2:	e8 e9 06 00 00       	call   80104fd0 <argint>
801048e7:	83 c4 10             	add    $0x10,%esp
801048ea:	85 c0                	test   %eax,%eax
801048ec:	75 52                	jne    80104940 <set_priority+0x80>
      return -1;
    }

    acquire(&ptable.lock);
801048ee:	83 ec 0c             	sub    $0xc,%esp
    int setPrior = -1; 
801048f1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    acquire(&ptable.lock);
801048f6:	68 20 2d 11 80       	push   $0x80112d20
801048fb:	e8 50 03 00 00       	call   80104c50 <acquire>

    struct proc *p;

    for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
      if(p->pid==pid){
80104900:	8b 55 f0             	mov    -0x10(%ebp),%edx
        p->priority = priority;
80104903:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104906:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104909:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010490e:	66 90                	xchg   %ax,%ax
      if(p->pid==pid){
80104910:	39 50 10             	cmp    %edx,0x10(%eax)
80104913:	75 08                	jne    8010491d <set_priority+0x5d>
        p->priority = priority;
80104915:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
        setPrior = 0;
8010491b:	31 db                	xor    %ebx,%ebx
    for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
8010491d:	05 88 00 00 00       	add    $0x88,%eax
80104922:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80104927:	75 e7                	jne    80104910 <set_priority+0x50>
      }
    }

    release(&ptable.lock);
80104929:	83 ec 0c             	sub    $0xc,%esp
8010492c:	68 20 2d 11 80       	push   $0x80112d20
80104931:	e8 ba 02 00 00       	call   80104bf0 <release>

    return setPrior; //-1 for failure and 0 for success
80104936:	83 c4 10             	add    $0x10,%esp
80104939:	89 d8                	mov    %ebx,%eax
8010493b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010493e:	c9                   	leave  
8010493f:	c3                   	ret    
      return -1;
80104940:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104945:	eb f2                	jmp    80104939 <set_priority+0x79>
80104947:	66 90                	xchg   %ax,%ax
80104949:	66 90                	xchg   %ax,%ax
8010494b:	66 90                	xchg   %ax,%ax
8010494d:	66 90                	xchg   %ax,%ax
8010494f:	90                   	nop

80104950 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 0c             	sub    $0xc,%esp
80104957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010495a:	68 e8 80 10 80       	push   $0x801080e8
8010495f:	8d 43 04             	lea    0x4(%ebx),%eax
80104962:	50                   	push   %eax
80104963:	e8 18 01 00 00       	call   80104a80 <initlock>
  lk->name = name;
80104968:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010496b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104971:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104974:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010497b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010497e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104981:	c9                   	leave  
80104982:	c3                   	ret    
80104983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104998:	8d 73 04             	lea    0x4(%ebx),%esi
8010499b:	83 ec 0c             	sub    $0xc,%esp
8010499e:	56                   	push   %esi
8010499f:	e8 ac 02 00 00       	call   80104c50 <acquire>
  while (lk->locked) {
801049a4:	8b 13                	mov    (%ebx),%edx
801049a6:	83 c4 10             	add    $0x10,%esp
801049a9:	85 d2                	test   %edx,%edx
801049ab:	74 16                	je     801049c3 <acquiresleep+0x33>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049b0:	83 ec 08             	sub    $0x8,%esp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	e8 d6 f6 ff ff       	call   80104090 <sleep>
  while (lk->locked) {
801049ba:	8b 03                	mov    (%ebx),%eax
801049bc:	83 c4 10             	add    $0x10,%esp
801049bf:	85 c0                	test   %eax,%eax
801049c1:	75 ed                	jne    801049b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049c9:	e8 c2 ef ff ff       	call   80103990 <myproc>
801049ce:	8b 40 10             	mov    0x10(%eax),%eax
801049d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
  release(&lk->lk);
801049dd:	e9 0e 02 00 00       	jmp    80104bf0 <release>
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049f8:	8d 73 04             	lea    0x4(%ebx),%esi
801049fb:	83 ec 0c             	sub    $0xc,%esp
801049fe:	56                   	push   %esi
801049ff:	e8 4c 02 00 00       	call   80104c50 <acquire>
  lk->locked = 0;
80104a04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a0a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a11:	89 1c 24             	mov    %ebx,(%esp)
80104a14:	e8 37 f7 ff ff       	call   80104150 <wakeup>
  release(&lk->lk);
80104a19:	89 75 08             	mov    %esi,0x8(%ebp)
80104a1c:	83 c4 10             	add    $0x10,%esp
}
80104a1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a22:	5b                   	pop    %ebx
80104a23:	5e                   	pop    %esi
80104a24:	5d                   	pop    %ebp
  release(&lk->lk);
80104a25:	e9 c6 01 00 00       	jmp    80104bf0 <release>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	31 ff                	xor    %edi,%edi
80104a36:	56                   	push   %esi
80104a37:	53                   	push   %ebx
80104a38:	83 ec 18             	sub    $0x18,%esp
80104a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a3e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a41:	56                   	push   %esi
80104a42:	e8 09 02 00 00       	call   80104c50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a47:	8b 03                	mov    (%ebx),%eax
80104a49:	83 c4 10             	add    $0x10,%esp
80104a4c:	85 c0                	test   %eax,%eax
80104a4e:	75 18                	jne    80104a68 <holdingsleep+0x38>
  release(&lk->lk);
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	56                   	push   %esi
80104a54:	e8 97 01 00 00       	call   80104bf0 <release>
  return r;
}
80104a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a5c:	89 f8                	mov    %edi,%eax
80104a5e:	5b                   	pop    %ebx
80104a5f:	5e                   	pop    %esi
80104a60:	5f                   	pop    %edi
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    
80104a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a67:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104a68:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a6b:	e8 20 ef ff ff       	call   80103990 <myproc>
80104a70:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a73:	0f 94 c0             	sete   %al
80104a76:	0f b6 c0             	movzbl %al,%eax
80104a79:	89 c7                	mov    %eax,%edi
80104a7b:	eb d3                	jmp    80104a50 <holdingsleep+0x20>
80104a7d:	66 90                	xchg   %ax,%ax
80104a7f:	90                   	nop

80104a80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop

80104aa0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104aa0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aa1:	31 d2                	xor    %edx,%edx
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104aa6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104aac:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104aaf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ab0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ab6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104abc:	77 1a                	ja     80104ad8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104abe:	8b 58 04             	mov    0x4(%eax),%ebx
80104ac1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ac4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ac7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ac9:	83 fa 0a             	cmp    $0xa,%edx
80104acc:	75 e2                	jne    80104ab0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad1:	c9                   	leave  
80104ad2:	c3                   	ret    
80104ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ad7:	90                   	nop
  for(; i < 10; i++)
80104ad8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104adb:	8d 51 28             	lea    0x28(%ecx),%edx
80104ade:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ae6:	83 c0 04             	add    $0x4,%eax
80104ae9:	39 d0                	cmp    %edx,%eax
80104aeb:	75 f3                	jne    80104ae0 <getcallerpcs+0x40>
}
80104aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af0:	c9                   	leave  
80104af1:	c3                   	ret    
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b07:	9c                   	pushf  
80104b08:	5b                   	pop    %ebx
  asm volatile("cli");
80104b09:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b0a:	e8 01 ee ff ff       	call   80103910 <mycpu>
80104b0f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b15:	85 c0                	test   %eax,%eax
80104b17:	74 17                	je     80104b30 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b19:	e8 f2 ed ff ff       	call   80103910 <mycpu>
80104b1e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b28:	c9                   	leave  
80104b29:	c3                   	ret    
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104b30:	e8 db ed ff ff       	call   80103910 <mycpu>
80104b35:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b3b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b41:	eb d6                	jmp    80104b19 <pushcli+0x19>
80104b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <popcli>:

void
popcli(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b56:	9c                   	pushf  
80104b57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b58:	f6 c4 02             	test   $0x2,%ah
80104b5b:	75 35                	jne    80104b92 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b5d:	e8 ae ed ff ff       	call   80103910 <mycpu>
80104b62:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b69:	78 34                	js     80104b9f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b6b:	e8 a0 ed ff ff       	call   80103910 <mycpu>
80104b70:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b76:	85 d2                	test   %edx,%edx
80104b78:	74 06                	je     80104b80 <popcli+0x30>
    sti();
}
80104b7a:	c9                   	leave  
80104b7b:	c3                   	ret    
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b80:	e8 8b ed ff ff       	call   80103910 <mycpu>
80104b85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	74 eb                	je     80104b7a <popcli+0x2a>
  asm volatile("sti");
80104b8f:	fb                   	sti    
}
80104b90:	c9                   	leave  
80104b91:	c3                   	ret    
    panic("popcli - interruptible");
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	68 f3 80 10 80       	push   $0x801080f3
80104b9a:	e8 e1 b7 ff ff       	call   80100380 <panic>
    panic("popcli");
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 0a 81 10 80       	push   $0x8010810a
80104ba7:	e8 d4 b7 ff ff       	call   80100380 <panic>
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <holding>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	8b 75 08             	mov    0x8(%ebp),%esi
80104bb8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bba:	e8 41 ff ff ff       	call   80104b00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bbf:	8b 06                	mov    (%esi),%eax
80104bc1:	85 c0                	test   %eax,%eax
80104bc3:	75 0b                	jne    80104bd0 <holding+0x20>
  popcli();
80104bc5:	e8 86 ff ff ff       	call   80104b50 <popcli>
}
80104bca:	89 d8                	mov    %ebx,%eax
80104bcc:	5b                   	pop    %ebx
80104bcd:	5e                   	pop    %esi
80104bce:	5d                   	pop    %ebp
80104bcf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104bd0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bd3:	e8 38 ed ff ff       	call   80103910 <mycpu>
80104bd8:	39 c3                	cmp    %eax,%ebx
80104bda:	0f 94 c3             	sete   %bl
  popcli();
80104bdd:	e8 6e ff ff ff       	call   80104b50 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104be2:	0f b6 db             	movzbl %bl,%ebx
}
80104be5:	89 d8                	mov    %ebx,%eax
80104be7:	5b                   	pop    %ebx
80104be8:	5e                   	pop    %esi
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bef:	90                   	nop

80104bf0 <release>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104bf8:	e8 03 ff ff ff       	call   80104b00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bfd:	8b 03                	mov    (%ebx),%eax
80104bff:	85 c0                	test   %eax,%eax
80104c01:	75 15                	jne    80104c18 <release+0x28>
  popcli();
80104c03:	e8 48 ff ff ff       	call   80104b50 <popcli>
    panic("release");
80104c08:	83 ec 0c             	sub    $0xc,%esp
80104c0b:	68 11 81 10 80       	push   $0x80108111
80104c10:	e8 6b b7 ff ff       	call   80100380 <panic>
80104c15:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c18:	8b 73 08             	mov    0x8(%ebx),%esi
80104c1b:	e8 f0 ec ff ff       	call   80103910 <mycpu>
80104c20:	39 c6                	cmp    %eax,%esi
80104c22:	75 df                	jne    80104c03 <release+0x13>
  popcli();
80104c24:	e8 27 ff ff ff       	call   80104b50 <popcli>
  lk->pcs[0] = 0;
80104c29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c30:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c37:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c3c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5d                   	pop    %ebp
  popcli();
80104c48:	e9 03 ff ff ff       	jmp    80104b50 <popcli>
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

80104c50 <acquire>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c57:	e8 a4 fe ff ff       	call   80104b00 <pushcli>
  if(holding(lk))
80104c5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104c5f:	e8 9c fe ff ff       	call   80104b00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c64:	8b 03                	mov    (%ebx),%eax
80104c66:	85 c0                	test   %eax,%eax
80104c68:	75 7e                	jne    80104ce8 <acquire+0x98>
  popcli();
80104c6a:	e8 e1 fe ff ff       	call   80104b50 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104c6f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104c78:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7b:	89 c8                	mov    %ecx,%eax
80104c7d:	f0 87 02             	lock xchg %eax,(%edx)
80104c80:	85 c0                	test   %eax,%eax
80104c82:	75 f4                	jne    80104c78 <acquire+0x28>
  __sync_synchronize();
80104c84:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c8c:	e8 7f ec ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c94:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104c96:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104c99:	31 c0                	xor    %eax,%eax
80104c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104ca6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cac:	77 1a                	ja     80104cc8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104cae:	8b 5a 04             	mov    0x4(%edx),%ebx
80104cb1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104cb5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104cb8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104cba:	83 f8 0a             	cmp    $0xa,%eax
80104cbd:	75 e1                	jne    80104ca0 <acquire+0x50>
}
80104cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc2:	c9                   	leave  
80104cc3:	c3                   	ret    
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104cc8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104ccc:	8d 51 34             	lea    0x34(%ecx),%edx
80104ccf:	90                   	nop
    pcs[i] = 0;
80104cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cd6:	83 c0 04             	add    $0x4,%eax
80104cd9:	39 c2                	cmp    %eax,%edx
80104cdb:	75 f3                	jne    80104cd0 <acquire+0x80>
}
80104cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce0:	c9                   	leave  
80104ce1:	c3                   	ret    
80104ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ce8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104ceb:	e8 20 ec ff ff       	call   80103910 <mycpu>
80104cf0:	39 c3                	cmp    %eax,%ebx
80104cf2:	0f 85 72 ff ff ff    	jne    80104c6a <acquire+0x1a>
  popcli();
80104cf8:	e8 53 fe ff ff       	call   80104b50 <popcli>
    panic("acquire");
80104cfd:	83 ec 0c             	sub    $0xc,%esp
80104d00:	68 19 81 10 80       	push   $0x80108119
80104d05:	e8 76 b6 ff ff       	call   80100380 <panic>
80104d0a:	66 90                	xchg   %ax,%ax
80104d0c:	66 90                	xchg   %ax,%ax
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <memset>:
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	8b 55 08             	mov    0x8(%ebp),%edx
80104d17:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d1a:	53                   	push   %ebx
80104d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1e:	89 d7                	mov    %edx,%edi
80104d20:	09 cf                	or     %ecx,%edi
80104d22:	83 e7 03             	and    $0x3,%edi
80104d25:	75 29                	jne    80104d50 <memset+0x40>
80104d27:	0f b6 f8             	movzbl %al,%edi
80104d2a:	c1 e0 18             	shl    $0x18,%eax
80104d2d:	89 fb                	mov    %edi,%ebx
80104d2f:	c1 e9 02             	shr    $0x2,%ecx
80104d32:	c1 e3 10             	shl    $0x10,%ebx
80104d35:	09 d8                	or     %ebx,%eax
80104d37:	09 f8                	or     %edi,%eax
80104d39:	c1 e7 08             	shl    $0x8,%edi
80104d3c:	09 f8                	or     %edi,%eax
80104d3e:	89 d7                	mov    %edx,%edi
80104d40:	fc                   	cld    
80104d41:	f3 ab                	rep stos %eax,%es:(%edi)
80104d43:	5b                   	pop    %ebx
80104d44:	89 d0                	mov    %edx,%eax
80104d46:	5f                   	pop    %edi
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret    
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d50:	89 d7                	mov    %edx,%edi
80104d52:	fc                   	cld    
80104d53:	f3 aa                	rep stos %al,%es:(%edi)
80104d55:	5b                   	pop    %ebx
80104d56:	89 d0                	mov    %edx,%eax
80104d58:	5f                   	pop    %edi
80104d59:	5d                   	pop    %ebp
80104d5a:	c3                   	ret    
80104d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <memcmp>:
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	8b 75 10             	mov    0x10(%ebp),%esi
80104d67:	8b 55 08             	mov    0x8(%ebp),%edx
80104d6a:	53                   	push   %ebx
80104d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d6e:	85 f6                	test   %esi,%esi
80104d70:	74 2e                	je     80104da0 <memcmp+0x40>
80104d72:	01 c6                	add    %eax,%esi
80104d74:	eb 14                	jmp    80104d8a <memcmp+0x2a>
80104d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	83 c0 01             	add    $0x1,%eax
80104d83:	83 c2 01             	add    $0x1,%edx
80104d86:	39 f0                	cmp    %esi,%eax
80104d88:	74 16                	je     80104da0 <memcmp+0x40>
80104d8a:	0f b6 0a             	movzbl (%edx),%ecx
80104d8d:	0f b6 18             	movzbl (%eax),%ebx
80104d90:	38 d9                	cmp    %bl,%cl
80104d92:	74 ec                	je     80104d80 <memcmp+0x20>
80104d94:	0f b6 c1             	movzbl %cl,%eax
80104d97:	29 d8                	sub    %ebx,%eax
80104d99:	5b                   	pop    %ebx
80104d9a:	5e                   	pop    %esi
80104d9b:	5d                   	pop    %ebp
80104d9c:	c3                   	ret    
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
80104da0:	5b                   	pop    %ebx
80104da1:	31 c0                	xor    %eax,%eax
80104da3:	5e                   	pop    %esi
80104da4:	5d                   	pop    %ebp
80104da5:	c3                   	ret    
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi

80104db0 <memmove>:
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	8b 55 08             	mov    0x8(%ebp),%edx
80104db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dba:	56                   	push   %esi
80104dbb:	8b 75 0c             	mov    0xc(%ebp),%esi
80104dbe:	39 d6                	cmp    %edx,%esi
80104dc0:	73 26                	jae    80104de8 <memmove+0x38>
80104dc2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104dc5:	39 fa                	cmp    %edi,%edx
80104dc7:	73 1f                	jae    80104de8 <memmove+0x38>
80104dc9:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104dcc:	85 c9                	test   %ecx,%ecx
80104dce:	74 0c                	je     80104ddc <memmove+0x2c>
80104dd0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104dd4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104dd7:	83 e8 01             	sub    $0x1,%eax
80104dda:	73 f4                	jae    80104dd0 <memmove+0x20>
80104ddc:	5e                   	pop    %esi
80104ddd:	89 d0                	mov    %edx,%eax
80104ddf:	5f                   	pop    %edi
80104de0:	5d                   	pop    %ebp
80104de1:	c3                   	ret    
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104de8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104deb:	89 d7                	mov    %edx,%edi
80104ded:	85 c9                	test   %ecx,%ecx
80104def:	74 eb                	je     80104ddc <memmove+0x2c>
80104df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104df9:	39 c6                	cmp    %eax,%esi
80104dfb:	75 fb                	jne    80104df8 <memmove+0x48>
80104dfd:	5e                   	pop    %esi
80104dfe:	89 d0                	mov    %edx,%eax
80104e00:	5f                   	pop    %edi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e10 <memcpy>:
80104e10:	eb 9e                	jmp    80104db0 <memmove>
80104e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e20 <strncmp>:
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	8b 75 10             	mov    0x10(%ebp),%esi
80104e27:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e2a:	53                   	push   %ebx
80104e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e2e:	85 f6                	test   %esi,%esi
80104e30:	74 2e                	je     80104e60 <strncmp+0x40>
80104e32:	01 d6                	add    %edx,%esi
80104e34:	eb 18                	jmp    80104e4e <strncmp+0x2e>
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
80104e40:	38 d8                	cmp    %bl,%al
80104e42:	75 14                	jne    80104e58 <strncmp+0x38>
80104e44:	83 c2 01             	add    $0x1,%edx
80104e47:	83 c1 01             	add    $0x1,%ecx
80104e4a:	39 f2                	cmp    %esi,%edx
80104e4c:	74 12                	je     80104e60 <strncmp+0x40>
80104e4e:	0f b6 01             	movzbl (%ecx),%eax
80104e51:	0f b6 1a             	movzbl (%edx),%ebx
80104e54:	84 c0                	test   %al,%al
80104e56:	75 e8                	jne    80104e40 <strncmp+0x20>
80104e58:	29 d8                	sub    %ebx,%eax
80104e5a:	5b                   	pop    %ebx
80104e5b:	5e                   	pop    %esi
80104e5c:	5d                   	pop    %ebp
80104e5d:	c3                   	ret    
80104e5e:	66 90                	xchg   %ax,%ax
80104e60:	5b                   	pop    %ebx
80104e61:	31 c0                	xor    %eax,%eax
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi

80104e70 <strncpy>:
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	8b 75 08             	mov    0x8(%ebp),%esi
80104e78:	53                   	push   %ebx
80104e79:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e7c:	89 f0                	mov    %esi,%eax
80104e7e:	eb 15                	jmp    80104e95 <strncpy+0x25>
80104e80:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e84:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e87:	83 c0 01             	add    $0x1,%eax
80104e8a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104e8e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104e91:	84 d2                	test   %dl,%dl
80104e93:	74 09                	je     80104e9e <strncpy+0x2e>
80104e95:	89 cb                	mov    %ecx,%ebx
80104e97:	83 e9 01             	sub    $0x1,%ecx
80104e9a:	85 db                	test   %ebx,%ebx
80104e9c:	7f e2                	jg     80104e80 <strncpy+0x10>
80104e9e:	89 c2                	mov    %eax,%edx
80104ea0:	85 c9                	test   %ecx,%ecx
80104ea2:	7e 17                	jle    80104ebb <strncpy+0x4b>
80104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	83 c2 01             	add    $0x1,%edx
80104eab:	89 c1                	mov    %eax,%ecx
80104ead:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104eb1:	29 d1                	sub    %edx,%ecx
80104eb3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104eb7:	85 c9                	test   %ecx,%ecx
80104eb9:	7f ed                	jg     80104ea8 <strncpy+0x38>
80104ebb:	5b                   	pop    %ebx
80104ebc:	89 f0                	mov    %esi,%eax
80104ebe:	5e                   	pop    %esi
80104ebf:	5f                   	pop    %edi
80104ec0:	5d                   	pop    %ebp
80104ec1:	c3                   	ret    
80104ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <safestrcpy>:
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ed7:	8b 75 08             	mov    0x8(%ebp),%esi
80104eda:	53                   	push   %ebx
80104edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ede:	85 d2                	test   %edx,%edx
80104ee0:	7e 25                	jle    80104f07 <safestrcpy+0x37>
80104ee2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ee6:	89 f2                	mov    %esi,%edx
80104ee8:	eb 16                	jmp    80104f00 <safestrcpy+0x30>
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ef0:	0f b6 08             	movzbl (%eax),%ecx
80104ef3:	83 c0 01             	add    $0x1,%eax
80104ef6:	83 c2 01             	add    $0x1,%edx
80104ef9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104efc:	84 c9                	test   %cl,%cl
80104efe:	74 04                	je     80104f04 <safestrcpy+0x34>
80104f00:	39 d8                	cmp    %ebx,%eax
80104f02:	75 ec                	jne    80104ef0 <safestrcpy+0x20>
80104f04:	c6 02 00             	movb   $0x0,(%edx)
80104f07:	89 f0                	mov    %esi,%eax
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi

80104f10 <strlen>:
80104f10:	55                   	push   %ebp
80104f11:	31 c0                	xor    %eax,%eax
80104f13:	89 e5                	mov    %esp,%ebp
80104f15:	8b 55 08             	mov    0x8(%ebp),%edx
80104f18:	80 3a 00             	cmpb   $0x0,(%edx)
80104f1b:	74 0c                	je     80104f29 <strlen+0x19>
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi
80104f20:	83 c0 01             	add    $0x1,%eax
80104f23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f27:	75 f7                	jne    80104f20 <strlen+0x10>
80104f29:	5d                   	pop    %ebp
80104f2a:	c3                   	ret    

80104f2b <swtch>:
80104f2b:	8b 44 24 04          	mov    0x4(%esp),%eax
80104f2f:	8b 54 24 08          	mov    0x8(%esp),%edx
80104f33:	55                   	push   %ebp
80104f34:	53                   	push   %ebx
80104f35:	56                   	push   %esi
80104f36:	57                   	push   %edi
80104f37:	89 20                	mov    %esp,(%eax)
80104f39:	89 d4                	mov    %edx,%esp
80104f3b:	5f                   	pop    %edi
80104f3c:	5e                   	pop    %esi
80104f3d:	5b                   	pop    %ebx
80104f3e:	5d                   	pop    %ebp
80104f3f:	c3                   	ret    

80104f40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 04             	sub    $0x4,%esp
80104f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f4a:	e8 41 ea ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f4f:	8b 00                	mov    (%eax),%eax
80104f51:	39 d8                	cmp    %ebx,%eax
80104f53:	76 1b                	jbe    80104f70 <fetchint+0x30>
80104f55:	8d 53 04             	lea    0x4(%ebx),%edx
80104f58:	39 d0                	cmp    %edx,%eax
80104f5a:	72 14                	jb     80104f70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f5f:	8b 13                	mov    (%ebx),%edx
80104f61:	89 10                	mov    %edx,(%eax)
  return 0;
80104f63:	31 c0                	xor    %eax,%eax
}
80104f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f68:	c9                   	leave  
80104f69:	c3                   	ret    
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f75:	eb ee                	jmp    80104f65 <fetchint+0x25>
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	53                   	push   %ebx
80104f84:	83 ec 04             	sub    $0x4,%esp
80104f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f8a:	e8 01 ea ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz)
80104f8f:	39 18                	cmp    %ebx,(%eax)
80104f91:	76 2d                	jbe    80104fc0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104f93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f9a:	39 d3                	cmp    %edx,%ebx
80104f9c:	73 22                	jae    80104fc0 <fetchstr+0x40>
80104f9e:	89 d8                	mov    %ebx,%eax
80104fa0:	eb 0d                	jmp    80104faf <fetchstr+0x2f>
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fa8:	83 c0 01             	add    $0x1,%eax
80104fab:	39 c2                	cmp    %eax,%edx
80104fad:	76 11                	jbe    80104fc0 <fetchstr+0x40>
    if(*s == 0)
80104faf:	80 38 00             	cmpb   $0x0,(%eax)
80104fb2:	75 f4                	jne    80104fa8 <fetchstr+0x28>
      return s - *pp;
80104fb4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104fb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb9:	c9                   	leave  
80104fba:	c3                   	ret    
80104fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fbf:	90                   	nop
80104fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104fc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc8:	c9                   	leave  
80104fc9:	c3                   	ret    
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd5:	e8 b6 e9 ff ff       	call   80103990 <myproc>
80104fda:	8b 55 08             	mov    0x8(%ebp),%edx
80104fdd:	8b 40 18             	mov    0x18(%eax),%eax
80104fe0:	8b 40 44             	mov    0x44(%eax),%eax
80104fe3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fe6:	e8 a5 e9 ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104feb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fee:	8b 00                	mov    (%eax),%eax
80104ff0:	39 c6                	cmp    %eax,%esi
80104ff2:	73 1c                	jae    80105010 <argint+0x40>
80104ff4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ff7:	39 d0                	cmp    %edx,%eax
80104ff9:	72 15                	jb     80105010 <argint+0x40>
  *ip = *(int*)(addr);
80104ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ffe:	8b 53 04             	mov    0x4(%ebx),%edx
80105001:	89 10                	mov    %edx,(%eax)
  return 0;
80105003:	31 c0                	xor    %eax,%eax
}
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105015:	eb ee                	jmp    80105005 <argint+0x35>
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax

80105020 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
80105026:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105029:	e8 62 e9 ff ff       	call   80103990 <myproc>
8010502e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105030:	e8 5b e9 ff ff       	call   80103990 <myproc>
80105035:	8b 55 08             	mov    0x8(%ebp),%edx
80105038:	8b 40 18             	mov    0x18(%eax),%eax
8010503b:	8b 40 44             	mov    0x44(%eax),%eax
8010503e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105041:	e8 4a e9 ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105046:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105049:	8b 00                	mov    (%eax),%eax
8010504b:	39 c7                	cmp    %eax,%edi
8010504d:	73 31                	jae    80105080 <argptr+0x60>
8010504f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105052:	39 c8                	cmp    %ecx,%eax
80105054:	72 2a                	jb     80105080 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105056:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105059:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010505c:	85 d2                	test   %edx,%edx
8010505e:	78 20                	js     80105080 <argptr+0x60>
80105060:	8b 16                	mov    (%esi),%edx
80105062:	39 c2                	cmp    %eax,%edx
80105064:	76 1a                	jbe    80105080 <argptr+0x60>
80105066:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105069:	01 c3                	add    %eax,%ebx
8010506b:	39 da                	cmp    %ebx,%edx
8010506d:	72 11                	jb     80105080 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010506f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105072:	89 02                	mov    %eax,(%edx)
  return 0;
80105074:	31 c0                	xor    %eax,%eax
}
80105076:	83 c4 0c             	add    $0xc,%esp
80105079:	5b                   	pop    %ebx
8010507a:	5e                   	pop    %esi
8010507b:	5f                   	pop    %edi
8010507c:	5d                   	pop    %ebp
8010507d:	c3                   	ret    
8010507e:	66 90                	xchg   %ax,%ax
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105085:	eb ef                	jmp    80105076 <argptr+0x56>
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax

80105090 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105095:	e8 f6 e8 ff ff       	call   80103990 <myproc>
8010509a:	8b 55 08             	mov    0x8(%ebp),%edx
8010509d:	8b 40 18             	mov    0x18(%eax),%eax
801050a0:	8b 40 44             	mov    0x44(%eax),%eax
801050a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050a6:	e8 e5 e8 ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ae:	8b 00                	mov    (%eax),%eax
801050b0:	39 c6                	cmp    %eax,%esi
801050b2:	73 44                	jae    801050f8 <argstr+0x68>
801050b4:	8d 53 08             	lea    0x8(%ebx),%edx
801050b7:	39 d0                	cmp    %edx,%eax
801050b9:	72 3d                	jb     801050f8 <argstr+0x68>
  *ip = *(int*)(addr);
801050bb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801050be:	e8 cd e8 ff ff       	call   80103990 <myproc>
  if(addr >= curproc->sz)
801050c3:	3b 18                	cmp    (%eax),%ebx
801050c5:	73 31                	jae    801050f8 <argstr+0x68>
  *pp = (char*)addr;
801050c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050cc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050ce:	39 d3                	cmp    %edx,%ebx
801050d0:	73 26                	jae    801050f8 <argstr+0x68>
801050d2:	89 d8                	mov    %ebx,%eax
801050d4:	eb 11                	jmp    801050e7 <argstr+0x57>
801050d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
801050e0:	83 c0 01             	add    $0x1,%eax
801050e3:	39 c2                	cmp    %eax,%edx
801050e5:	76 11                	jbe    801050f8 <argstr+0x68>
    if(*s == 0)
801050e7:	80 38 00             	cmpb   $0x0,(%eax)
801050ea:	75 f4                	jne    801050e0 <argstr+0x50>
      return s - *pp;
801050ec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801050ee:	5b                   	pop    %ebx
801050ef:	5e                   	pop    %esi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050f8:	5b                   	pop    %ebx
    return -1;
801050f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050fe:	5e                   	pop    %esi
801050ff:	5d                   	pop    %ebp
80105100:	c3                   	ret    
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510f:	90                   	nop

80105110 <syscall>:
[SYS_set_priority] sys_set_priority
};

void
syscall(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 04             	sub    $0x4,%esp
  total_calls++;
80105117:	83 05 08 b0 10 80 01 	addl   $0x1,0x8010b008
  int num;
  struct proc *curproc = myproc();
8010511e:	e8 6d e8 ff ff       	call   80103990 <myproc>
80105123:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105125:	8b 40 18             	mov    0x18(%eax),%eax
80105128:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010512b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010512e:	83 fa 1c             	cmp    $0x1c,%edx
80105131:	77 1d                	ja     80105150 <syscall+0x40>
80105133:	8b 14 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%edx
8010513a:	85 d2                	test   %edx,%edx
8010513c:	74 12                	je     80105150 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010513e:	ff d2                	call   *%edx
80105140:	89 c2                	mov    %eax,%edx
80105142:	8b 43 18             	mov    0x18(%ebx),%eax
80105145:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010514b:	c9                   	leave  
8010514c:	c3                   	ret    
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105150:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105151:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105154:	50                   	push   %eax
80105155:	ff 73 10             	push   0x10(%ebx)
80105158:	68 21 81 10 80       	push   $0x80108121
8010515d:	e8 3e b5 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105162:	8b 43 18             	mov    0x18(%ebx),%eax
80105165:	83 c4 10             	add    $0x10,%esp
80105168:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010516f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105172:	c9                   	leave  
80105173:	c3                   	ret    
80105174:	66 90                	xchg   %ax,%ax
80105176:	66 90                	xchg   %ax,%ax
80105178:	66 90                	xchg   %ax,%ax
8010517a:	66 90                	xchg   %ax,%ax
8010517c:	66 90                	xchg   %ax,%ax
8010517e:	66 90                	xchg   %ax,%ax

80105180 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105185:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105188:	53                   	push   %ebx
80105189:	83 ec 34             	sub    $0x34,%esp
8010518c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010518f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105192:	57                   	push   %edi
80105193:	50                   	push   %eax
{
80105194:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105197:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010519a:	e8 21 cf ff ff       	call   801020c0 <nameiparent>
8010519f:	83 c4 10             	add    $0x10,%esp
801051a2:	85 c0                	test   %eax,%eax
801051a4:	0f 84 46 01 00 00    	je     801052f0 <create+0x170>
    return 0;
  ilock(dp);
801051aa:	83 ec 0c             	sub    $0xc,%esp
801051ad:	89 c3                	mov    %eax,%ebx
801051af:	50                   	push   %eax
801051b0:	e8 cb c5 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051b5:	83 c4 0c             	add    $0xc,%esp
801051b8:	6a 00                	push   $0x0
801051ba:	57                   	push   %edi
801051bb:	53                   	push   %ebx
801051bc:	e8 1f cb ff ff       	call   80101ce0 <dirlookup>
801051c1:	83 c4 10             	add    $0x10,%esp
801051c4:	89 c6                	mov    %eax,%esi
801051c6:	85 c0                	test   %eax,%eax
801051c8:	74 56                	je     80105220 <create+0xa0>
    iunlockput(dp);
801051ca:	83 ec 0c             	sub    $0xc,%esp
801051cd:	53                   	push   %ebx
801051ce:	e8 3d c8 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801051d3:	89 34 24             	mov    %esi,(%esp)
801051d6:	e8 a5 c5 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051db:	83 c4 10             	add    $0x10,%esp
801051de:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051e3:	75 1b                	jne    80105200 <create+0x80>
801051e5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801051ea:	75 14                	jne    80105200 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ef:	89 f0                	mov    %esi,%eax
801051f1:	5b                   	pop    %ebx
801051f2:	5e                   	pop    %esi
801051f3:	5f                   	pop    %edi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret    
801051f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	56                   	push   %esi
    return 0;
80105204:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105206:	e8 05 c8 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010520b:	83 c4 10             	add    $0x10,%esp
}
8010520e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105211:	89 f0                	mov    %esi,%eax
80105213:	5b                   	pop    %ebx
80105214:	5e                   	pop    %esi
80105215:	5f                   	pop    %edi
80105216:	5d                   	pop    %ebp
80105217:	c3                   	ret    
80105218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105220:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105224:	83 ec 08             	sub    $0x8,%esp
80105227:	50                   	push   %eax
80105228:	ff 33                	push   (%ebx)
8010522a:	e8 e1 c3 ff ff       	call   80101610 <ialloc>
8010522f:	83 c4 10             	add    $0x10,%esp
80105232:	89 c6                	mov    %eax,%esi
80105234:	85 c0                	test   %eax,%eax
80105236:	0f 84 cd 00 00 00    	je     80105309 <create+0x189>
  ilock(ip);
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	50                   	push   %eax
80105240:	e8 3b c5 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105245:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105249:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010524d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105251:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105255:	b8 01 00 00 00       	mov    $0x1,%eax
8010525a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010525e:	89 34 24             	mov    %esi,(%esp)
80105261:	e8 6a c4 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105266:	83 c4 10             	add    $0x10,%esp
80105269:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010526e:	74 30                	je     801052a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105270:	83 ec 04             	sub    $0x4,%esp
80105273:	ff 76 04             	push   0x4(%esi)
80105276:	57                   	push   %edi
80105277:	53                   	push   %ebx
80105278:	e8 63 cd ff ff       	call   80101fe0 <dirlink>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	78 78                	js     801052fc <create+0x17c>
  iunlockput(dp);
80105284:	83 ec 0c             	sub    $0xc,%esp
80105287:	53                   	push   %ebx
80105288:	e8 83 c7 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010528d:	83 c4 10             	add    $0x10,%esp
}
80105290:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105293:	89 f0                	mov    %esi,%eax
80105295:	5b                   	pop    %ebx
80105296:	5e                   	pop    %esi
80105297:	5f                   	pop    %edi
80105298:	5d                   	pop    %ebp
80105299:	c3                   	ret    
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801052a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052a8:	53                   	push   %ebx
801052a9:	e8 22 c4 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052ae:	83 c4 0c             	add    $0xc,%esp
801052b1:	ff 76 04             	push   0x4(%esi)
801052b4:	68 d4 81 10 80       	push   $0x801081d4
801052b9:	56                   	push   %esi
801052ba:	e8 21 cd ff ff       	call   80101fe0 <dirlink>
801052bf:	83 c4 10             	add    $0x10,%esp
801052c2:	85 c0                	test   %eax,%eax
801052c4:	78 18                	js     801052de <create+0x15e>
801052c6:	83 ec 04             	sub    $0x4,%esp
801052c9:	ff 73 04             	push   0x4(%ebx)
801052cc:	68 d3 81 10 80       	push   $0x801081d3
801052d1:	56                   	push   %esi
801052d2:	e8 09 cd ff ff       	call   80101fe0 <dirlink>
801052d7:	83 c4 10             	add    $0x10,%esp
801052da:	85 c0                	test   %eax,%eax
801052dc:	79 92                	jns    80105270 <create+0xf0>
      panic("create dots");
801052de:	83 ec 0c             	sub    $0xc,%esp
801052e1:	68 c7 81 10 80       	push   $0x801081c7
801052e6:	e8 95 b0 ff ff       	call   80100380 <panic>
801052eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052ef:	90                   	nop
}
801052f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801052f3:	31 f6                	xor    %esi,%esi
}
801052f5:	5b                   	pop    %ebx
801052f6:	89 f0                	mov    %esi,%eax
801052f8:	5e                   	pop    %esi
801052f9:	5f                   	pop    %edi
801052fa:	5d                   	pop    %ebp
801052fb:	c3                   	ret    
    panic("create: dirlink");
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	68 d6 81 10 80       	push   $0x801081d6
80105304:	e8 77 b0 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	68 b8 81 10 80       	push   $0x801081b8
80105311:	e8 6a b0 ff ff       	call   80100380 <panic>
80105316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531d:	8d 76 00             	lea    0x0(%esi),%esi

80105320 <sys_dup>:
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105325:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105328:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010532b:	50                   	push   %eax
8010532c:	6a 00                	push   $0x0
8010532e:	e8 9d fc ff ff       	call   80104fd0 <argint>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 36                	js     80105370 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010533a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010533e:	77 30                	ja     80105370 <sys_dup+0x50>
80105340:	e8 4b e6 ff ff       	call   80103990 <myproc>
80105345:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105348:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010534c:	85 f6                	test   %esi,%esi
8010534e:	74 20                	je     80105370 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105350:	e8 3b e6 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105355:	31 db                	xor    %ebx,%ebx
80105357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105360:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105364:	85 d2                	test   %edx,%edx
80105366:	74 18                	je     80105380 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105368:	83 c3 01             	add    $0x1,%ebx
8010536b:	83 fb 10             	cmp    $0x10,%ebx
8010536e:	75 f0                	jne    80105360 <sys_dup+0x40>
}
80105370:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105373:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105378:	89 d8                	mov    %ebx,%eax
8010537a:	5b                   	pop    %ebx
8010537b:	5e                   	pop    %esi
8010537c:	5d                   	pop    %ebp
8010537d:	c3                   	ret    
8010537e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105380:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105383:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105387:	56                   	push   %esi
80105388:	e8 13 bb ff ff       	call   80100ea0 <filedup>
  return fd;
8010538d:	83 c4 10             	add    $0x10,%esp
}
80105390:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105393:	89 d8                	mov    %ebx,%eax
80105395:	5b                   	pop    %ebx
80105396:	5e                   	pop    %esi
80105397:	5d                   	pop    %ebp
80105398:	c3                   	ret    
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_read>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	56                   	push   %esi
801053a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053ab:	53                   	push   %ebx
801053ac:	6a 00                	push   $0x0
801053ae:	e8 1d fc ff ff       	call   80104fd0 <argint>
801053b3:	83 c4 10             	add    $0x10,%esp
801053b6:	85 c0                	test   %eax,%eax
801053b8:	78 5e                	js     80105418 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053be:	77 58                	ja     80105418 <sys_read+0x78>
801053c0:	e8 cb e5 ff ff       	call   80103990 <myproc>
801053c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053cc:	85 f6                	test   %esi,%esi
801053ce:	74 48                	je     80105418 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053d0:	83 ec 08             	sub    $0x8,%esp
801053d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d6:	50                   	push   %eax
801053d7:	6a 02                	push   $0x2
801053d9:	e8 f2 fb ff ff       	call   80104fd0 <argint>
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 33                	js     80105418 <sys_read+0x78>
801053e5:	83 ec 04             	sub    $0x4,%esp
801053e8:	ff 75 f0             	push   -0x10(%ebp)
801053eb:	53                   	push   %ebx
801053ec:	6a 01                	push   $0x1
801053ee:	e8 2d fc ff ff       	call   80105020 <argptr>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 1e                	js     80105418 <sys_read+0x78>
  return fileread(f, p, n);
801053fa:	83 ec 04             	sub    $0x4,%esp
801053fd:	ff 75 f0             	push   -0x10(%ebp)
80105400:	ff 75 f4             	push   -0xc(%ebp)
80105403:	56                   	push   %esi
80105404:	e8 17 bc ff ff       	call   80101020 <fileread>
80105409:	83 c4 10             	add    $0x10,%esp
}
8010540c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010540f:	5b                   	pop    %ebx
80105410:	5e                   	pop    %esi
80105411:	5d                   	pop    %ebp
80105412:	c3                   	ret    
80105413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105417:	90                   	nop
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb ed                	jmp    8010540c <sys_read+0x6c>
8010541f:	90                   	nop

80105420 <sys_write>:
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105425:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105428:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010542b:	53                   	push   %ebx
8010542c:	6a 00                	push   $0x0
8010542e:	e8 9d fb ff ff       	call   80104fd0 <argint>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 5e                	js     80105498 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010543a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010543e:	77 58                	ja     80105498 <sys_write+0x78>
80105440:	e8 4b e5 ff ff       	call   80103990 <myproc>
80105445:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105448:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010544c:	85 f6                	test   %esi,%esi
8010544e:	74 48                	je     80105498 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105450:	83 ec 08             	sub    $0x8,%esp
80105453:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105456:	50                   	push   %eax
80105457:	6a 02                	push   $0x2
80105459:	e8 72 fb ff ff       	call   80104fd0 <argint>
8010545e:	83 c4 10             	add    $0x10,%esp
80105461:	85 c0                	test   %eax,%eax
80105463:	78 33                	js     80105498 <sys_write+0x78>
80105465:	83 ec 04             	sub    $0x4,%esp
80105468:	ff 75 f0             	push   -0x10(%ebp)
8010546b:	53                   	push   %ebx
8010546c:	6a 01                	push   $0x1
8010546e:	e8 ad fb ff ff       	call   80105020 <argptr>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 1e                	js     80105498 <sys_write+0x78>
  return filewrite(f, p, n);
8010547a:	83 ec 04             	sub    $0x4,%esp
8010547d:	ff 75 f0             	push   -0x10(%ebp)
80105480:	ff 75 f4             	push   -0xc(%ebp)
80105483:	56                   	push   %esi
80105484:	e8 27 bc ff ff       	call   801010b0 <filewrite>
80105489:	83 c4 10             	add    $0x10,%esp
}
8010548c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010548f:	5b                   	pop    %ebx
80105490:	5e                   	pop    %esi
80105491:	5d                   	pop    %ebp
80105492:	c3                   	ret    
80105493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105497:	90                   	nop
    return -1;
80105498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549d:	eb ed                	jmp    8010548c <sys_write+0x6c>
8010549f:	90                   	nop

801054a0 <sys_close>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054ab:	50                   	push   %eax
801054ac:	6a 00                	push   $0x0
801054ae:	e8 1d fb ff ff       	call   80104fd0 <argint>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 3e                	js     801054f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054be:	77 38                	ja     801054f8 <sys_close+0x58>
801054c0:	e8 cb e4 ff ff       	call   80103990 <myproc>
801054c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801054cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801054cf:	85 f6                	test   %esi,%esi
801054d1:	74 25                	je     801054f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801054d3:	e8 b8 e4 ff ff       	call   80103990 <myproc>
  fileclose(f);
801054d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801054e2:	00 
  fileclose(f);
801054e3:	56                   	push   %esi
801054e4:	e8 07 ba ff ff       	call   80100ef0 <fileclose>
  return 0;
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	31 c0                	xor    %eax,%eax
}
801054ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f1:	5b                   	pop    %ebx
801054f2:	5e                   	pop    %esi
801054f3:	5d                   	pop    %ebp
801054f4:	c3                   	ret    
801054f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fd:	eb ef                	jmp    801054ee <sys_close+0x4e>
801054ff:	90                   	nop

80105500 <sys_fstat>:
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105505:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105508:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010550b:	53                   	push   %ebx
8010550c:	6a 00                	push   $0x0
8010550e:	e8 bd fa ff ff       	call   80104fd0 <argint>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 46                	js     80105560 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010551a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010551e:	77 40                	ja     80105560 <sys_fstat+0x60>
80105520:	e8 6b e4 ff ff       	call   80103990 <myproc>
80105525:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105528:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010552c:	85 f6                	test   %esi,%esi
8010552e:	74 30                	je     80105560 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105530:	83 ec 04             	sub    $0x4,%esp
80105533:	6a 14                	push   $0x14
80105535:	53                   	push   %ebx
80105536:	6a 01                	push   $0x1
80105538:	e8 e3 fa ff ff       	call   80105020 <argptr>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 1c                	js     80105560 <sys_fstat+0x60>
  return filestat(f, st);
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	ff 75 f4             	push   -0xc(%ebp)
8010554a:	56                   	push   %esi
8010554b:	e8 80 ba ff ff       	call   80100fd0 <filestat>
80105550:	83 c4 10             	add    $0x10,%esp
}
80105553:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105556:	5b                   	pop    %ebx
80105557:	5e                   	pop    %esi
80105558:	5d                   	pop    %ebp
80105559:	c3                   	ret    
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	eb ec                	jmp    80105553 <sys_fstat+0x53>
80105567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_link>:
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105575:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105578:	53                   	push   %ebx
80105579:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010557c:	50                   	push   %eax
8010557d:	6a 00                	push   $0x0
8010557f:	e8 0c fb ff ff       	call   80105090 <argstr>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	85 c0                	test   %eax,%eax
80105589:	0f 88 fb 00 00 00    	js     8010568a <sys_link+0x11a>
8010558f:	83 ec 08             	sub    $0x8,%esp
80105592:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105595:	50                   	push   %eax
80105596:	6a 01                	push   $0x1
80105598:	e8 f3 fa ff ff       	call   80105090 <argstr>
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	85 c0                	test   %eax,%eax
801055a2:	0f 88 e2 00 00 00    	js     8010568a <sys_link+0x11a>
  begin_op();
801055a8:	e8 b3 d7 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	ff 75 d4             	push   -0x2c(%ebp)
801055b3:	e8 e8 ca ff ff       	call   801020a0 <namei>
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	89 c3                	mov    %eax,%ebx
801055bd:	85 c0                	test   %eax,%eax
801055bf:	0f 84 e4 00 00 00    	je     801056a9 <sys_link+0x139>
  ilock(ip);
801055c5:	83 ec 0c             	sub    $0xc,%esp
801055c8:	50                   	push   %eax
801055c9:	e8 b2 c1 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d6:	0f 84 b5 00 00 00    	je     80105691 <sys_link+0x121>
  iupdate(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801055e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055e7:	53                   	push   %ebx
801055e8:	e8 e3 c0 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801055ed:	89 1c 24             	mov    %ebx,(%esp)
801055f0:	e8 6b c2 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055f5:	58                   	pop    %eax
801055f6:	5a                   	pop    %edx
801055f7:	57                   	push   %edi
801055f8:	ff 75 d0             	push   -0x30(%ebp)
801055fb:	e8 c0 ca ff ff       	call   801020c0 <nameiparent>
80105600:	83 c4 10             	add    $0x10,%esp
80105603:	89 c6                	mov    %eax,%esi
80105605:	85 c0                	test   %eax,%eax
80105607:	74 5b                	je     80105664 <sys_link+0xf4>
  ilock(dp);
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	50                   	push   %eax
8010560d:	e8 6e c1 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105612:	8b 03                	mov    (%ebx),%eax
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	39 06                	cmp    %eax,(%esi)
80105619:	75 3d                	jne    80105658 <sys_link+0xe8>
8010561b:	83 ec 04             	sub    $0x4,%esp
8010561e:	ff 73 04             	push   0x4(%ebx)
80105621:	57                   	push   %edi
80105622:	56                   	push   %esi
80105623:	e8 b8 c9 ff ff       	call   80101fe0 <dirlink>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	85 c0                	test   %eax,%eax
8010562d:	78 29                	js     80105658 <sys_link+0xe8>
  iunlockput(dp);
8010562f:	83 ec 0c             	sub    $0xc,%esp
80105632:	56                   	push   %esi
80105633:	e8 d8 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105638:	89 1c 24             	mov    %ebx,(%esp)
8010563b:	e8 70 c2 ff ff       	call   801018b0 <iput>
  end_op();
80105640:	e8 8b d7 ff ff       	call   80102dd0 <end_op>
  return 0;
80105645:	83 c4 10             	add    $0x10,%esp
80105648:	31 c0                	xor    %eax,%eax
}
8010564a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010564d:	5b                   	pop    %ebx
8010564e:	5e                   	pop    %esi
8010564f:	5f                   	pop    %edi
80105650:	5d                   	pop    %ebp
80105651:	c3                   	ret    
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	56                   	push   %esi
8010565c:	e8 af c3 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105661:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	53                   	push   %ebx
80105668:	e8 13 c1 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010566d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105672:	89 1c 24             	mov    %ebx,(%esp)
80105675:	e8 56 c0 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010567a:	89 1c 24             	mov    %ebx,(%esp)
8010567d:	e8 8e c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105682:	e8 49 d7 ff ff       	call   80102dd0 <end_op>
  return -1;
80105687:	83 c4 10             	add    $0x10,%esp
8010568a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568f:	eb b9                	jmp    8010564a <sys_link+0xda>
    iunlockput(ip);
80105691:	83 ec 0c             	sub    $0xc,%esp
80105694:	53                   	push   %ebx
80105695:	e8 76 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010569a:	e8 31 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a7:	eb a1                	jmp    8010564a <sys_link+0xda>
    end_op();
801056a9:	e8 22 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
801056ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b3:	eb 95                	jmp    8010564a <sys_link+0xda>
801056b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_unlink>:
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801056c5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056c8:	53                   	push   %ebx
801056c9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801056cc:	50                   	push   %eax
801056cd:	6a 00                	push   $0x0
801056cf:	e8 bc f9 ff ff       	call   80105090 <argstr>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	0f 88 7a 01 00 00    	js     80105859 <sys_unlink+0x199>
  begin_op();
801056df:	e8 7c d6 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056e4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801056e7:	83 ec 08             	sub    $0x8,%esp
801056ea:	53                   	push   %ebx
801056eb:	ff 75 c0             	push   -0x40(%ebp)
801056ee:	e8 cd c9 ff ff       	call   801020c0 <nameiparent>
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056f9:	85 c0                	test   %eax,%eax
801056fb:	0f 84 62 01 00 00    	je     80105863 <sys_unlink+0x1a3>
  ilock(dp);
80105701:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	57                   	push   %edi
80105708:	e8 73 c0 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010570d:	58                   	pop    %eax
8010570e:	5a                   	pop    %edx
8010570f:	68 d4 81 10 80       	push   $0x801081d4
80105714:	53                   	push   %ebx
80105715:	e8 a6 c5 ff ff       	call   80101cc0 <namecmp>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 84 fb 00 00 00    	je     80105820 <sys_unlink+0x160>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	68 d3 81 10 80       	push   $0x801081d3
8010572d:	53                   	push   %ebx
8010572e:	e8 8d c5 ff ff       	call   80101cc0 <namecmp>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	0f 84 e2 00 00 00    	je     80105820 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010573e:	83 ec 04             	sub    $0x4,%esp
80105741:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105744:	50                   	push   %eax
80105745:	53                   	push   %ebx
80105746:	57                   	push   %edi
80105747:	e8 94 c5 ff ff       	call   80101ce0 <dirlookup>
8010574c:	83 c4 10             	add    $0x10,%esp
8010574f:	89 c3                	mov    %eax,%ebx
80105751:	85 c0                	test   %eax,%eax
80105753:	0f 84 c7 00 00 00    	je     80105820 <sys_unlink+0x160>
  ilock(ip);
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	50                   	push   %eax
8010575d:	e8 1e c0 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010576a:	0f 8e 1c 01 00 00    	jle    8010588c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105770:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105775:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105778:	74 66                	je     801057e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010577a:	83 ec 04             	sub    $0x4,%esp
8010577d:	6a 10                	push   $0x10
8010577f:	6a 00                	push   $0x0
80105781:	57                   	push   %edi
80105782:	e8 89 f5 ff ff       	call   80104d10 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105787:	6a 10                	push   $0x10
80105789:	ff 75 c4             	push   -0x3c(%ebp)
8010578c:	57                   	push   %edi
8010578d:	ff 75 b4             	push   -0x4c(%ebp)
80105790:	e8 fb c3 ff ff       	call   80101b90 <writei>
80105795:	83 c4 20             	add    $0x20,%esp
80105798:	83 f8 10             	cmp    $0x10,%eax
8010579b:	0f 85 de 00 00 00    	jne    8010587f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801057a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057a6:	0f 84 94 00 00 00    	je     80105840 <sys_unlink+0x180>
  iunlockput(dp);
801057ac:	83 ec 0c             	sub    $0xc,%esp
801057af:	ff 75 b4             	push   -0x4c(%ebp)
801057b2:	e8 59 c2 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801057b7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057bc:	89 1c 24             	mov    %ebx,(%esp)
801057bf:	e8 0c bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801057c4:	89 1c 24             	mov    %ebx,(%esp)
801057c7:	e8 44 c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057cc:	e8 ff d5 ff ff       	call   80102dd0 <end_op>
  return 0;
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	31 c0                	xor    %eax,%eax
}
801057d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d9:	5b                   	pop    %ebx
801057da:	5e                   	pop    %esi
801057db:	5f                   	pop    %edi
801057dc:	5d                   	pop    %ebp
801057dd:	c3                   	ret    
801057de:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057e4:	76 94                	jbe    8010577a <sys_unlink+0xba>
801057e6:	be 20 00 00 00       	mov    $0x20,%esi
801057eb:	eb 0b                	jmp    801057f8 <sys_unlink+0x138>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
801057f0:	83 c6 10             	add    $0x10,%esi
801057f3:	3b 73 58             	cmp    0x58(%ebx),%esi
801057f6:	73 82                	jae    8010577a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057f8:	6a 10                	push   $0x10
801057fa:	56                   	push   %esi
801057fb:	57                   	push   %edi
801057fc:	53                   	push   %ebx
801057fd:	e8 8e c2 ff ff       	call   80101a90 <readi>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	83 f8 10             	cmp    $0x10,%eax
80105808:	75 68                	jne    80105872 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010580a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010580f:	74 df                	je     801057f0 <sys_unlink+0x130>
    iunlockput(ip);
80105811:	83 ec 0c             	sub    $0xc,%esp
80105814:	53                   	push   %ebx
80105815:	e8 f6 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	ff 75 b4             	push   -0x4c(%ebp)
80105826:	e8 e5 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010582b:	e8 a0 d5 ff ff       	call   80102dd0 <end_op>
  return -1;
80105830:	83 c4 10             	add    $0x10,%esp
80105833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105838:	eb 9c                	jmp    801057d6 <sys_unlink+0x116>
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105840:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105843:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105846:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010584b:	50                   	push   %eax
8010584c:	e8 7f be ff ff       	call   801016d0 <iupdate>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	e9 53 ff ff ff       	jmp    801057ac <sys_unlink+0xec>
    return -1;
80105859:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585e:	e9 73 ff ff ff       	jmp    801057d6 <sys_unlink+0x116>
    end_op();
80105863:	e8 68 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
80105868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586d:	e9 64 ff ff ff       	jmp    801057d6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105872:	83 ec 0c             	sub    $0xc,%esp
80105875:	68 f8 81 10 80       	push   $0x801081f8
8010587a:	e8 01 ab ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010587f:	83 ec 0c             	sub    $0xc,%esp
80105882:	68 0a 82 10 80       	push   $0x8010820a
80105887:	e8 f4 aa ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010588c:	83 ec 0c             	sub    $0xc,%esp
8010588f:	68 e6 81 10 80       	push   $0x801081e6
80105894:	e8 e7 aa ff ff       	call   80100380 <panic>
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_open>:

int
sys_open(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058a8:	53                   	push   %ebx
801058a9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058ac:	50                   	push   %eax
801058ad:	6a 00                	push   $0x0
801058af:	e8 dc f7 ff ff       	call   80105090 <argstr>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	0f 88 8e 00 00 00    	js     8010594d <sys_open+0xad>
801058bf:	83 ec 08             	sub    $0x8,%esp
801058c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058c5:	50                   	push   %eax
801058c6:	6a 01                	push   $0x1
801058c8:	e8 03 f7 ff ff       	call   80104fd0 <argint>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 79                	js     8010594d <sys_open+0xad>
    return -1;

  begin_op();
801058d4:	e8 87 d4 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
801058d9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058dd:	75 79                	jne    80105958 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058df:	83 ec 0c             	sub    $0xc,%esp
801058e2:	ff 75 e0             	push   -0x20(%ebp)
801058e5:	e8 b6 c7 ff ff       	call   801020a0 <namei>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	89 c6                	mov    %eax,%esi
801058ef:	85 c0                	test   %eax,%eax
801058f1:	0f 84 7e 00 00 00    	je     80105975 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	50                   	push   %eax
801058fb:	e8 80 be ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105908:	0f 84 c2 00 00 00    	je     801059d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010590e:	e8 1d b5 ff ff       	call   80100e30 <filealloc>
80105913:	89 c7                	mov    %eax,%edi
80105915:	85 c0                	test   %eax,%eax
80105917:	74 23                	je     8010593c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105919:	e8 72 e0 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105920:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105924:	85 d2                	test   %edx,%edx
80105926:	74 60                	je     80105988 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105928:	83 c3 01             	add    $0x1,%ebx
8010592b:	83 fb 10             	cmp    $0x10,%ebx
8010592e:	75 f0                	jne    80105920 <sys_open+0x80>
    if(f)
      fileclose(f);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	57                   	push   %edi
80105934:	e8 b7 b5 ff ff       	call   80100ef0 <fileclose>
80105939:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	56                   	push   %esi
80105940:	e8 cb c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105945:	e8 86 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105952:	eb 6d                	jmp    801059c1 <sys_open+0x121>
80105954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010595e:	31 c9                	xor    %ecx,%ecx
80105960:	ba 02 00 00 00       	mov    $0x2,%edx
80105965:	6a 00                	push   $0x0
80105967:	e8 14 f8 ff ff       	call   80105180 <create>
    if(ip == 0){
8010596c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010596f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105971:	85 c0                	test   %eax,%eax
80105973:	75 99                	jne    8010590e <sys_open+0x6e>
      end_op();
80105975:	e8 56 d4 ff ff       	call   80102dd0 <end_op>
      return -1;
8010597a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010597f:	eb 40                	jmp    801059c1 <sys_open+0x121>
80105981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105988:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010598b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010598f:	56                   	push   %esi
80105990:	e8 cb be ff ff       	call   80101860 <iunlock>
  end_op();
80105995:	e8 36 d4 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010599a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059b2:	f7 d0                	not    %eax
801059b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c4:	89 d8                	mov    %ebx,%eax
801059c6:	5b                   	pop    %ebx
801059c7:	5e                   	pop    %esi
801059c8:	5f                   	pop    %edi
801059c9:	5d                   	pop    %ebp
801059ca:	c3                   	ret    
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801059d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059d3:	85 c9                	test   %ecx,%ecx
801059d5:	0f 84 33 ff ff ff    	je     8010590e <sys_open+0x6e>
801059db:	e9 5c ff ff ff       	jmp    8010593c <sys_open+0x9c>

801059e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059e6:	e8 75 d3 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059eb:	83 ec 08             	sub    $0x8,%esp
801059ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f1:	50                   	push   %eax
801059f2:	6a 00                	push   $0x0
801059f4:	e8 97 f6 ff ff       	call   80105090 <argstr>
801059f9:	83 c4 10             	add    $0x10,%esp
801059fc:	85 c0                	test   %eax,%eax
801059fe:	78 30                	js     80105a30 <sys_mkdir+0x50>
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a06:	31 c9                	xor    %ecx,%ecx
80105a08:	ba 01 00 00 00       	mov    $0x1,%edx
80105a0d:	6a 00                	push   $0x0
80105a0f:	e8 6c f7 ff ff       	call   80105180 <create>
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	85 c0                	test   %eax,%eax
80105a19:	74 15                	je     80105a30 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a1b:	83 ec 0c             	sub    $0xc,%esp
80105a1e:	50                   	push   %eax
80105a1f:	e8 ec bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a24:	e8 a7 d3 ff ff       	call   80102dd0 <end_op>
  return 0;
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	31 c0                	xor    %eax,%eax
}
80105a2e:	c9                   	leave  
80105a2f:	c3                   	ret    
    end_op();
80105a30:	e8 9b d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_mknod>:

int
sys_mknod(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a46:	e8 15 d3 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a4b:	83 ec 08             	sub    $0x8,%esp
80105a4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a51:	50                   	push   %eax
80105a52:	6a 00                	push   $0x0
80105a54:	e8 37 f6 ff ff       	call   80105090 <argstr>
80105a59:	83 c4 10             	add    $0x10,%esp
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	78 60                	js     80105ac0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a66:	50                   	push   %eax
80105a67:	6a 01                	push   $0x1
80105a69:	e8 62 f5 ff ff       	call   80104fd0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	85 c0                	test   %eax,%eax
80105a73:	78 4b                	js     80105ac0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a75:	83 ec 08             	sub    $0x8,%esp
80105a78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a7b:	50                   	push   %eax
80105a7c:	6a 02                	push   $0x2
80105a7e:	e8 4d f5 ff ff       	call   80104fd0 <argint>
     argint(1, &major) < 0 ||
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	78 36                	js     80105ac0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a8a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a8e:	83 ec 0c             	sub    $0xc,%esp
80105a91:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a95:	ba 03 00 00 00       	mov    $0x3,%edx
80105a9a:	50                   	push   %eax
80105a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a9e:	e8 dd f6 ff ff       	call   80105180 <create>
     argint(2, &minor) < 0 ||
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 c0                	test   %eax,%eax
80105aa8:	74 16                	je     80105ac0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105aaa:	83 ec 0c             	sub    $0xc,%esp
80105aad:	50                   	push   %eax
80105aae:	e8 5d bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ab3:	e8 18 d3 ff ff       	call   80102dd0 <end_op>
  return 0;
80105ab8:	83 c4 10             	add    $0x10,%esp
80105abb:	31 c0                	xor    %eax,%eax
}
80105abd:	c9                   	leave  
80105abe:	c3                   	ret    
80105abf:	90                   	nop
    end_op();
80105ac0:	e8 0b d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aca:	c9                   	leave  
80105acb:	c3                   	ret    
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_chdir>:

int
sys_chdir(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	56                   	push   %esi
80105ad4:	53                   	push   %ebx
80105ad5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ad8:	e8 b3 de ff ff       	call   80103990 <myproc>
80105add:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105adf:	e8 7c d2 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ae4:	83 ec 08             	sub    $0x8,%esp
80105ae7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aea:	50                   	push   %eax
80105aeb:	6a 00                	push   $0x0
80105aed:	e8 9e f5 ff ff       	call   80105090 <argstr>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	78 77                	js     80105b70 <sys_chdir+0xa0>
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	ff 75 f4             	push   -0xc(%ebp)
80105aff:	e8 9c c5 ff ff       	call   801020a0 <namei>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	89 c3                	mov    %eax,%ebx
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	74 63                	je     80105b70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	50                   	push   %eax
80105b11:	e8 6a bc ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b1e:	75 30                	jne    80105b50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	53                   	push   %ebx
80105b24:	e8 37 bd ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105b29:	58                   	pop    %eax
80105b2a:	ff 76 68             	push   0x68(%esi)
80105b2d:	e8 7e bd ff ff       	call   801018b0 <iput>
  end_op();
80105b32:	e8 99 d2 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105b37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	31 c0                	xor    %eax,%eax
}
80105b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b42:	5b                   	pop    %ebx
80105b43:	5e                   	pop    %esi
80105b44:	5d                   	pop    %ebp
80105b45:	c3                   	ret    
80105b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	53                   	push   %ebx
80105b54:	e8 b7 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b59:	e8 72 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b66:	eb d7                	jmp    80105b3f <sys_chdir+0x6f>
80105b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
    end_op();
80105b70:	e8 5b d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7a:	eb c3                	jmp    80105b3f <sys_chdir+0x6f>
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_exec>:

int
sys_exec(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b85:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b8b:	53                   	push   %ebx
80105b8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b92:	50                   	push   %eax
80105b93:	6a 00                	push   $0x0
80105b95:	e8 f6 f4 ff ff       	call   80105090 <argstr>
80105b9a:	83 c4 10             	add    $0x10,%esp
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	0f 88 87 00 00 00    	js     80105c2c <sys_exec+0xac>
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bae:	50                   	push   %eax
80105baf:	6a 01                	push   $0x1
80105bb1:	e8 1a f4 ff ff       	call   80104fd0 <argint>
80105bb6:	83 c4 10             	add    $0x10,%esp
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	78 6f                	js     80105c2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bbd:	83 ec 04             	sub    $0x4,%esp
80105bc0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105bc6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bc8:	68 80 00 00 00       	push   $0x80
80105bcd:	6a 00                	push   $0x0
80105bcf:	56                   	push   %esi
80105bd0:	e8 3b f1 ff ff       	call   80104d10 <memset>
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105be0:	83 ec 08             	sub    $0x8,%esp
80105be3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105be9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105bf0:	50                   	push   %eax
80105bf1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf7:	01 f8                	add    %edi,%eax
80105bf9:	50                   	push   %eax
80105bfa:	e8 41 f3 ff ff       	call   80104f40 <fetchint>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	85 c0                	test   %eax,%eax
80105c04:	78 26                	js     80105c2c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105c06:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c0c:	85 c0                	test   %eax,%eax
80105c0e:	74 30                	je     80105c40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c10:	83 ec 08             	sub    $0x8,%esp
80105c13:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c16:	52                   	push   %edx
80105c17:	50                   	push   %eax
80105c18:	e8 63 f3 ff ff       	call   80104f80 <fetchstr>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	85 c0                	test   %eax,%eax
80105c22:	78 08                	js     80105c2c <sys_exec+0xac>
  for(i=0;; i++){
80105c24:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c27:	83 fb 20             	cmp    $0x20,%ebx
80105c2a:	75 b4                	jne    80105be0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c34:	5b                   	pop    %ebx
80105c35:	5e                   	pop    %esi
80105c36:	5f                   	pop    %edi
80105c37:	5d                   	pop    %ebp
80105c38:	c3                   	ret    
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105c40:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c47:	00 00 00 00 
  return exec(path, argv);
80105c4b:	83 ec 08             	sub    $0x8,%esp
80105c4e:	56                   	push   %esi
80105c4f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c55:	e8 56 ae ff ff       	call   80100ab0 <exec>
80105c5a:	83 c4 10             	add    $0x10,%esp
}
80105c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c60:	5b                   	pop    %ebx
80105c61:	5e                   	pop    %esi
80105c62:	5f                   	pop    %edi
80105c63:	5d                   	pop    %ebp
80105c64:	c3                   	ret    
80105c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_pipe>:

int
sys_pipe(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c75:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c78:	53                   	push   %ebx
80105c79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c7c:	6a 08                	push   $0x8
80105c7e:	50                   	push   %eax
80105c7f:	6a 00                	push   $0x0
80105c81:	e8 9a f3 ff ff       	call   80105020 <argptr>
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	78 4a                	js     80105cd7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c8d:	83 ec 08             	sub    $0x8,%esp
80105c90:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c93:	50                   	push   %eax
80105c94:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c97:	50                   	push   %eax
80105c98:	e8 93 d7 ff ff       	call   80103430 <pipealloc>
80105c9d:	83 c4 10             	add    $0x10,%esp
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	78 33                	js     80105cd7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ca4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ca7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ca9:	e8 e2 dc ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105cb0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cb4:	85 f6                	test   %esi,%esi
80105cb6:	74 28                	je     80105ce0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105cb8:	83 c3 01             	add    $0x1,%ebx
80105cbb:	83 fb 10             	cmp    $0x10,%ebx
80105cbe:	75 f0                	jne    80105cb0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	ff 75 e0             	push   -0x20(%ebp)
80105cc6:	e8 25 b2 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105ccb:	58                   	pop    %eax
80105ccc:	ff 75 e4             	push   -0x1c(%ebp)
80105ccf:	e8 1c b2 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105cd4:	83 c4 10             	add    $0x10,%esp
80105cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdc:	eb 53                	jmp    80105d31 <sys_pipe+0xc1>
80105cde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ce0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ce3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ce7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cea:	e8 a1 dc ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cef:	31 d2                	xor    %edx,%edx
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105cf8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cfc:	85 c9                	test   %ecx,%ecx
80105cfe:	74 20                	je     80105d20 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105d00:	83 c2 01             	add    $0x1,%edx
80105d03:	83 fa 10             	cmp    $0x10,%edx
80105d06:	75 f0                	jne    80105cf8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105d08:	e8 83 dc ff ff       	call   80103990 <myproc>
80105d0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d14:	00 
80105d15:	eb a9                	jmp    80105cc0 <sys_pipe+0x50>
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d2f:	31 c0                	xor    %eax,%eax
}
80105d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	66 90                	xchg   %ax,%ax
80105d3b:	66 90                	xchg   %ax,%ax
80105d3d:	66 90                	xchg   %ax,%ax
80105d3f:	90                   	nop

80105d40 <sys_fork>:
int total_calls = -1;

int
sys_fork(void)
{
  return fork();
80105d40:	e9 eb dd ff ff       	jmp    80103b30 <fork>
80105d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exit>:
}

int
sys_exit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d56:	e8 85 e0 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
80105d5b:	31 c0                	xor    %eax,%eax
80105d5d:	c9                   	leave  
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105d60:	e9 ab e1 ff ff       	jmp    80103f10 <wait>
80105d65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_kill>:
}

int
sys_kill(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 4f f2 ff ff       	call   80104fd0 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 18                	js     80105da0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	push   -0xc(%ebp)
80105d8e:	e8 1d e4 ff ff       	call   801041b0 <kill>
80105d93:	83 c4 10             	add    $0x10,%esp
}
80105d96:	c9                   	leave  
80105d97:	c3                   	ret    
80105d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop
80105da0:	c9                   	leave  
    return -1;
80105da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da6:	c3                   	ret    
80105da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <sys_getpid>:

int
sys_getpid(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105db6:	e8 d5 db ff ff       	call   80103990 <myproc>
80105dbb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dbe:	c9                   	leave  
80105dbf:	c3                   	ret    

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 fe f1 ff ff       	call   80104fd0 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	78 27                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dd9:	e8 b2 db ff ff       	call   80103990 <myproc>
  if(growproc(n) < 0)
80105dde:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105de1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105de3:	ff 75 f4             	push   -0xc(%ebp)
80105de6:	e8 c5 dc ff ff       	call   80103ab0 <growproc>
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	85 c0                	test   %eax,%eax
80105df0:	78 0e                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105df2:	89 d8                	mov    %ebx,%eax
80105df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e05:	eb eb                	jmp    80105df2 <sys_sbrk+0x32>
80105e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <sys_sleep>:

int
sys_sleep(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e1a:	50                   	push   %eax
80105e1b:	6a 00                	push   $0x0
80105e1d:	e8 ae f1 ff ff       	call   80104fd0 <argint>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	0f 88 8a 00 00 00    	js     80105eb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 80 4f 11 80       	push   $0x80114f80
80105e35:	e8 16 ee ff ff       	call   80104c50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e3d:	8b 1d 60 4f 11 80    	mov    0x80114f60,%ebx
  while(ticks - ticks0 < n){
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 d2                	test   %edx,%edx
80105e48:	75 27                	jne    80105e71 <sys_sleep+0x61>
80105e4a:	eb 54                	jmp    80105ea0 <sys_sleep+0x90>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	68 80 4f 11 80       	push   $0x80114f80
80105e58:	68 60 4f 11 80       	push   $0x80114f60
80105e5d:	e8 2e e2 ff ff       	call   80104090 <sleep>
  while(ticks - ticks0 < n){
80105e62:	a1 60 4f 11 80       	mov    0x80114f60,%eax
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	29 d8                	sub    %ebx,%eax
80105e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e6f:	73 2f                	jae    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e71:	e8 1a db ff ff       	call   80103990 <myproc>
80105e76:	8b 40 24             	mov    0x24(%eax),%eax
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 d3                	je     80105e50 <sys_sleep+0x40>
      release(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 80 4f 11 80       	push   $0x80114f80
80105e85:	e8 66 ed ff ff       	call   80104bf0 <release>
  }
  release(&tickslock);
  return 0;
}
80105e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 80 4f 11 80       	push   $0x80114f80
80105ea8:	e8 43 ed ff ff       	call   80104bf0 <release>
  return 0;
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	31 c0                	xor    %eax,%eax
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	eb f4                	jmp    80105eb2 <sys_sleep+0xa2>
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	53                   	push   %ebx
80105ec4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ec7:	68 80 4f 11 80       	push   $0x80114f80
80105ecc:	e8 7f ed ff ff       	call   80104c50 <acquire>
  xticks = ticks;
80105ed1:	8b 1d 60 4f 11 80    	mov    0x80114f60,%ebx
  release(&tickslock);
80105ed7:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105ede:	e8 0d ed ff ff       	call   80104bf0 <release>
  return xticks;
}
80105ee3:	89 d8                	mov    %ebx,%eax
80105ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee8:	c9                   	leave  
80105ee9:	c3                   	ret    
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ef0 <sys_cps>:

int sys_cps(void){
	return cps();
80105ef0:	e9 fb e3 ff ff       	jmp    801042f0 <cps>
80105ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_calls>:
}

int sys_calls(void){
  if(total_calls == -1){
80105f00:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80105f05:	83 f8 ff             	cmp    $0xffffffff,%eax
80105f08:	74 03                	je     80105f0d <sys_calls+0xd>
    return total_calls;
  }
  else{
    return total_calls + 1;
80105f0a:	83 c0 01             	add    $0x1,%eax
  }
}
80105f0d:	c3                   	ret    
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_get_process_type>:

int sys_get_process_type(void){
  return get_process_type();
80105f10:	e9 9b e4 ff ff       	jmp    801043b0 <get_process_type>
80105f15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_wait_pid>:
}

int sys_wait_pid(void){
  return wait_pid();
80105f20:	e9 6b e5 ff ff       	jmp    80104490 <wait_pid>
80105f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_unwait_pid>:
}

int sys_unwait_pid(void){
  return unwait_pid();
80105f30:	e9 1b e7 ff ff       	jmp    80104650 <unwait_pid>
80105f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f40 <sys_mem_usage>:
}

int sys_mem_usage(void){
  return mem_usage();
80105f40:	e9 5b e8 ff ff       	jmp    801047a0 <mem_usage>
80105f45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f50 <sys_get_priority>:
}

int sys_get_priority(void){
  return get_priority();
80105f50:	e9 db e8 ff ff       	jmp    80104830 <get_priority>
80105f55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_set_priority>:
}

int sys_set_priority(void){
  return set_priority();
80105f60:	e9 5b e9 ff ff       	jmp    801048c0 <set_priority>

80105f65 <alltraps>:
80105f65:	1e                   	push   %ds
80105f66:	06                   	push   %es
80105f67:	0f a0                	push   %fs
80105f69:	0f a8                	push   %gs
80105f6b:	60                   	pusha  
80105f6c:	66 b8 10 00          	mov    $0x10,%ax
80105f70:	8e d8                	mov    %eax,%ds
80105f72:	8e c0                	mov    %eax,%es
80105f74:	54                   	push   %esp
80105f75:	e8 c6 00 00 00       	call   80106040 <trap>
80105f7a:	83 c4 04             	add    $0x4,%esp

80105f7d <trapret>:
80105f7d:	61                   	popa   
80105f7e:	0f a9                	pop    %gs
80105f80:	0f a1                	pop    %fs
80105f82:	07                   	pop    %es
80105f83:	1f                   	pop    %ds
80105f84:	83 c4 08             	add    $0x8,%esp
80105f87:	cf                   	iret   
80105f88:	66 90                	xchg   %ax,%ax
80105f8a:	66 90                	xchg   %ax,%ax
80105f8c:	66 90                	xchg   %ax,%ax
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f91:	31 c0                	xor    %eax,%eax
{
80105f93:	89 e5                	mov    %esp,%ebp
80105f95:	83 ec 08             	sub    $0x8,%esp
80105f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fa0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105fa7:	c7 04 c5 c2 4f 11 80 	movl   $0x8e000008,-0x7feeb03e(,%eax,8)
80105fae:	08 00 00 8e 
80105fb2:	66 89 14 c5 c0 4f 11 	mov    %dx,-0x7feeb040(,%eax,8)
80105fb9:	80 
80105fba:	c1 ea 10             	shr    $0x10,%edx
80105fbd:	66 89 14 c5 c6 4f 11 	mov    %dx,-0x7feeb03a(,%eax,8)
80105fc4:	80 
  for(i = 0; i < 256; i++)
80105fc5:	83 c0 01             	add    $0x1,%eax
80105fc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fcd:	75 d1                	jne    80105fa0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105fcf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fd2:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80105fd7:	c7 05 c2 51 11 80 08 	movl   $0xef000008,0x801151c2
80105fde:	00 00 ef 
  initlock(&tickslock, "time");
80105fe1:	68 19 82 10 80       	push   $0x80108219
80105fe6:	68 80 4f 11 80       	push   $0x80114f80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105feb:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
80105ff1:	c1 e8 10             	shr    $0x10,%eax
80105ff4:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6
  initlock(&tickslock, "time");
80105ffa:	e8 81 ea ff ff       	call   80104a80 <initlock>
}
80105fff:	83 c4 10             	add    $0x10,%esp
80106002:	c9                   	leave  
80106003:	c3                   	ret    
80106004:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop

80106010 <idtinit>:

void
idtinit(void)
{
80106010:	55                   	push   %ebp
  pd[0] = size-1;
80106011:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106016:	89 e5                	mov    %esp,%ebp
80106018:	83 ec 10             	sub    $0x10,%esp
8010601b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010601f:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
80106024:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106028:	c1 e8 10             	shr    $0x10,%eax
8010602b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010602f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106032:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax

80106040 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	57                   	push   %edi
80106044:	56                   	push   %esi
80106045:	53                   	push   %ebx
80106046:	83 ec 1c             	sub    $0x1c,%esp
80106049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010604c:	8b 43 30             	mov    0x30(%ebx),%eax
8010604f:	83 f8 40             	cmp    $0x40,%eax
80106052:	0f 84 68 01 00 00    	je     801061c0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106058:	83 e8 20             	sub    $0x20,%eax
8010605b:	83 f8 1f             	cmp    $0x1f,%eax
8010605e:	0f 87 8c 00 00 00    	ja     801060f0 <trap+0xb0>
80106064:	ff 24 85 c0 82 10 80 	jmp    *-0x7fef7d40(,%eax,4)
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop
    }

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106070:	e8 cb c1 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106075:	e8 96 c8 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010607a:	e8 11 d9 ff ff       	call   80103990 <myproc>
8010607f:	85 c0                	test   %eax,%eax
80106081:	74 1d                	je     801060a0 <trap+0x60>
80106083:	e8 08 d9 ff ff       	call   80103990 <myproc>
80106088:	8b 50 24             	mov    0x24(%eax),%edx
8010608b:	85 d2                	test   %edx,%edx
8010608d:	74 11                	je     801060a0 <trap+0x60>
8010608f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106093:	83 e0 03             	and    $0x3,%eax
80106096:	66 83 f8 03          	cmp    $0x3,%ax
8010609a:	0f 84 d0 01 00 00    	je     80106270 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060a0:	e8 eb d8 ff ff       	call   80103990 <myproc>
801060a5:	85 c0                	test   %eax,%eax
801060a7:	74 0f                	je     801060b8 <trap+0x78>
801060a9:	e8 e2 d8 ff ff       	call   80103990 <myproc>
801060ae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801060b2:	0f 84 b8 00 00 00    	je     80106170 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060b8:	e8 d3 d8 ff ff       	call   80103990 <myproc>
801060bd:	85 c0                	test   %eax,%eax
801060bf:	74 1d                	je     801060de <trap+0x9e>
801060c1:	e8 ca d8 ff ff       	call   80103990 <myproc>
801060c6:	8b 40 24             	mov    0x24(%eax),%eax
801060c9:	85 c0                	test   %eax,%eax
801060cb:	74 11                	je     801060de <trap+0x9e>
801060cd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060d1:	83 e0 03             	and    $0x3,%eax
801060d4:	66 83 f8 03          	cmp    $0x3,%ax
801060d8:	0f 84 0f 01 00 00    	je     801061ed <trap+0x1ad>
    exit();
}
801060de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e1:	5b                   	pop    %ebx
801060e2:	5e                   	pop    %esi
801060e3:	5f                   	pop    %edi
801060e4:	5d                   	pop    %ebp
801060e5:	c3                   	ret    
801060e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801060f0:	e8 9b d8 ff ff       	call   80103990 <myproc>
801060f5:	8b 7b 38             	mov    0x38(%ebx),%edi
801060f8:	85 c0                	test   %eax,%eax
801060fa:	0f 84 c2 01 00 00    	je     801062c2 <trap+0x282>
80106100:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106104:	0f 84 b8 01 00 00    	je     801062c2 <trap+0x282>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010610a:	0f 20 d1             	mov    %cr2,%ecx
8010610d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106110:	e8 5b d8 ff ff       	call   80103970 <cpuid>
80106115:	8b 73 30             	mov    0x30(%ebx),%esi
80106118:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010611b:	8b 43 34             	mov    0x34(%ebx),%eax
8010611e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106121:	e8 6a d8 ff ff       	call   80103990 <myproc>
80106126:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106129:	e8 62 d8 ff ff       	call   80103990 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010612e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106131:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106134:	51                   	push   %ecx
80106135:	57                   	push   %edi
80106136:	52                   	push   %edx
80106137:	ff 75 e4             	push   -0x1c(%ebp)
8010613a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010613b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010613e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106141:	56                   	push   %esi
80106142:	ff 70 10             	push   0x10(%eax)
80106145:	68 7c 82 10 80       	push   $0x8010827c
8010614a:	e8 51 a5 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010614f:	83 c4 20             	add    $0x20,%esp
80106152:	e8 39 d8 ff ff       	call   80103990 <myproc>
80106157:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010615e:	e8 2d d8 ff ff       	call   80103990 <myproc>
80106163:	85 c0                	test   %eax,%eax
80106165:	0f 85 18 ff ff ff    	jne    80106083 <trap+0x43>
8010616b:	e9 30 ff ff ff       	jmp    801060a0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106170:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106174:	0f 85 3e ff ff ff    	jne    801060b8 <trap+0x78>
    yield();
8010617a:	e8 c1 de ff ff       	call   80104040 <yield>
8010617f:	e9 34 ff ff ff       	jmp    801060b8 <trap+0x78>
80106184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106188:	8b 7b 38             	mov    0x38(%ebx),%edi
8010618b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010618f:	e8 dc d7 ff ff       	call   80103970 <cpuid>
80106194:	57                   	push   %edi
80106195:	56                   	push   %esi
80106196:	50                   	push   %eax
80106197:	68 24 82 10 80       	push   $0x80108224
8010619c:	e8 ff a4 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801061a1:	e8 6a c7 ff ff       	call   80102910 <lapiceoi>
    break;
801061a6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061a9:	e8 e2 d7 ff ff       	call   80103990 <myproc>
801061ae:	85 c0                	test   %eax,%eax
801061b0:	0f 85 cd fe ff ff    	jne    80106083 <trap+0x43>
801061b6:	e9 e5 fe ff ff       	jmp    801060a0 <trap+0x60>
801061bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061bf:	90                   	nop
    if(myproc()->killed)
801061c0:	e8 cb d7 ff ff       	call   80103990 <myproc>
801061c5:	8b 70 24             	mov    0x24(%eax),%esi
801061c8:	85 f6                	test   %esi,%esi
801061ca:	0f 85 e8 00 00 00    	jne    801062b8 <trap+0x278>
    myproc()->tf = tf;
801061d0:	e8 bb d7 ff ff       	call   80103990 <myproc>
801061d5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801061d8:	e8 33 ef ff ff       	call   80105110 <syscall>
    if(myproc()->killed)
801061dd:	e8 ae d7 ff ff       	call   80103990 <myproc>
801061e2:	8b 48 24             	mov    0x24(%eax),%ecx
801061e5:	85 c9                	test   %ecx,%ecx
801061e7:	0f 84 f1 fe ff ff    	je     801060de <trap+0x9e>
}
801061ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f0:	5b                   	pop    %ebx
801061f1:	5e                   	pop    %esi
801061f2:	5f                   	pop    %edi
801061f3:	5d                   	pop    %ebp
      exit();
801061f4:	e9 e7 db ff ff       	jmp    80103de0 <exit>
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106200:	e8 5b 02 00 00       	call   80106460 <uartintr>
    lapiceoi();
80106205:	e8 06 c7 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010620a:	e8 81 d7 ff ff       	call   80103990 <myproc>
8010620f:	85 c0                	test   %eax,%eax
80106211:	0f 85 6c fe ff ff    	jne    80106083 <trap+0x43>
80106217:	e9 84 fe ff ff       	jmp    801060a0 <trap+0x60>
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106220:	e8 ab c5 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106225:	e8 e6 c6 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010622a:	e8 61 d7 ff ff       	call   80103990 <myproc>
8010622f:	85 c0                	test   %eax,%eax
80106231:	0f 85 4c fe ff ff    	jne    80106083 <trap+0x43>
80106237:	e9 64 fe ff ff       	jmp    801060a0 <trap+0x60>
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106240:	e8 2b d7 ff ff       	call   80103970 <cpuid>
80106245:	85 c0                	test   %eax,%eax
80106247:	74 37                	je     80106280 <trap+0x240>
    if(myproc()!=0 && myproc()->state == RUNNING){
80106249:	e8 42 d7 ff ff       	call   80103990 <myproc>
8010624e:	85 c0                	test   %eax,%eax
80106250:	0f 84 1f fe ff ff    	je     80106075 <trap+0x35>
80106256:	e8 35 d7 ff ff       	call   80103990 <myproc>
8010625b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010625f:	0f 85 10 fe ff ff    	jne    80106075 <trap+0x35>
      yield();
80106265:	e8 d6 dd ff ff       	call   80104040 <yield>
    lapiceoi();
8010626a:	e9 06 fe ff ff       	jmp    80106075 <trap+0x35>
8010626f:	90                   	nop
    exit();
80106270:	e8 6b db ff ff       	call   80103de0 <exit>
80106275:	e9 26 fe ff ff       	jmp    801060a0 <trap+0x60>
8010627a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106280:	83 ec 0c             	sub    $0xc,%esp
80106283:	68 80 4f 11 80       	push   $0x80114f80
80106288:	e8 c3 e9 ff ff       	call   80104c50 <acquire>
      wakeup(&ticks);
8010628d:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
      ticks++;
80106294:	83 05 60 4f 11 80 01 	addl   $0x1,0x80114f60
      wakeup(&ticks);
8010629b:	e8 b0 de ff ff       	call   80104150 <wakeup>
      release(&tickslock);
801062a0:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801062a7:	e8 44 e9 ff ff       	call   80104bf0 <release>
801062ac:	83 c4 10             	add    $0x10,%esp
801062af:	eb 98                	jmp    80106249 <trap+0x209>
801062b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      exit();
801062b8:	e8 23 db ff ff       	call   80103de0 <exit>
801062bd:	e9 0e ff ff ff       	jmp    801061d0 <trap+0x190>
801062c2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062c5:	e8 a6 d6 ff ff       	call   80103970 <cpuid>
801062ca:	83 ec 0c             	sub    $0xc,%esp
801062cd:	56                   	push   %esi
801062ce:	57                   	push   %edi
801062cf:	50                   	push   %eax
801062d0:	ff 73 30             	push   0x30(%ebx)
801062d3:	68 48 82 10 80       	push   $0x80108248
801062d8:	e8 c3 a3 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801062dd:	83 c4 14             	add    $0x14,%esp
801062e0:	68 1e 82 10 80       	push   $0x8010821e
801062e5:	e8 96 a0 ff ff       	call   80100380 <panic>
801062ea:	66 90                	xchg   %ax,%ax
801062ec:	66 90                	xchg   %ax,%ax
801062ee:	66 90                	xchg   %ax,%ax

801062f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062f0:	a1 c0 57 11 80       	mov    0x801157c0,%eax
801062f5:	85 c0                	test   %eax,%eax
801062f7:	74 17                	je     80106310 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062f9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062fe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062ff:	a8 01                	test   $0x1,%al
80106301:	74 0d                	je     80106310 <uartgetc+0x20>
80106303:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106308:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106309:	0f b6 c0             	movzbl %al,%eax
8010630c:	c3                   	ret    
8010630d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106315:	c3                   	ret    
80106316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631d:	8d 76 00             	lea    0x0(%esi),%esi

80106320 <uartinit>:
{
80106320:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106321:	31 c9                	xor    %ecx,%ecx
80106323:	89 c8                	mov    %ecx,%eax
80106325:	89 e5                	mov    %esp,%ebp
80106327:	57                   	push   %edi
80106328:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010632d:	56                   	push   %esi
8010632e:	89 fa                	mov    %edi,%edx
80106330:	53                   	push   %ebx
80106331:	83 ec 1c             	sub    $0x1c,%esp
80106334:	ee                   	out    %al,(%dx)
80106335:	be fb 03 00 00       	mov    $0x3fb,%esi
8010633a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010633f:	89 f2                	mov    %esi,%edx
80106341:	ee                   	out    %al,(%dx)
80106342:	b8 0c 00 00 00       	mov    $0xc,%eax
80106347:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634c:	ee                   	out    %al,(%dx)
8010634d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106352:	89 c8                	mov    %ecx,%eax
80106354:	89 da                	mov    %ebx,%edx
80106356:	ee                   	out    %al,(%dx)
80106357:	b8 03 00 00 00       	mov    $0x3,%eax
8010635c:	89 f2                	mov    %esi,%edx
8010635e:	ee                   	out    %al,(%dx)
8010635f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106364:	89 c8                	mov    %ecx,%eax
80106366:	ee                   	out    %al,(%dx)
80106367:	b8 01 00 00 00       	mov    $0x1,%eax
8010636c:	89 da                	mov    %ebx,%edx
8010636e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010636f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106374:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106375:	3c ff                	cmp    $0xff,%al
80106377:	74 78                	je     801063f1 <uartinit+0xd1>
  uart = 1;
80106379:	c7 05 c0 57 11 80 01 	movl   $0x1,0x801157c0
80106380:	00 00 00 
80106383:	89 fa                	mov    %edi,%edx
80106385:	ec                   	in     (%dx),%al
80106386:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010638b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010638c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010638f:	bf 40 83 10 80       	mov    $0x80108340,%edi
80106394:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106399:	6a 00                	push   $0x0
8010639b:	6a 04                	push   $0x4
8010639d:	e8 de c0 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801063a2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801063a6:	83 c4 10             	add    $0x10,%esp
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801063b0:	a1 c0 57 11 80       	mov    0x801157c0,%eax
801063b5:	bb 80 00 00 00       	mov    $0x80,%ebx
801063ba:	85 c0                	test   %eax,%eax
801063bc:	75 14                	jne    801063d2 <uartinit+0xb2>
801063be:	eb 23                	jmp    801063e3 <uartinit+0xc3>
    microdelay(10);
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	6a 0a                	push   $0xa
801063c5:	e8 66 c5 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063ca:	83 c4 10             	add    $0x10,%esp
801063cd:	83 eb 01             	sub    $0x1,%ebx
801063d0:	74 07                	je     801063d9 <uartinit+0xb9>
801063d2:	89 f2                	mov    %esi,%edx
801063d4:	ec                   	in     (%dx),%al
801063d5:	a8 20                	test   $0x20,%al
801063d7:	74 e7                	je     801063c0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063d9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801063dd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063e2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801063e3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801063e7:	83 c7 01             	add    $0x1,%edi
801063ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801063ed:	84 c0                	test   %al,%al
801063ef:	75 bf                	jne    801063b0 <uartinit+0x90>
}
801063f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f4:	5b                   	pop    %ebx
801063f5:	5e                   	pop    %esi
801063f6:	5f                   	pop    %edi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106400 <uartputc>:
  if(!uart)
80106400:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80106405:	85 c0                	test   %eax,%eax
80106407:	74 47                	je     80106450 <uartputc+0x50>
{
80106409:	55                   	push   %ebp
8010640a:	89 e5                	mov    %esp,%ebp
8010640c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010640d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106412:	53                   	push   %ebx
80106413:	bb 80 00 00 00       	mov    $0x80,%ebx
80106418:	eb 18                	jmp    80106432 <uartputc+0x32>
8010641a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106420:	83 ec 0c             	sub    $0xc,%esp
80106423:	6a 0a                	push   $0xa
80106425:	e8 06 c5 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	83 eb 01             	sub    $0x1,%ebx
80106430:	74 07                	je     80106439 <uartputc+0x39>
80106432:	89 f2                	mov    %esi,%edx
80106434:	ec                   	in     (%dx),%al
80106435:	a8 20                	test   $0x20,%al
80106437:	74 e7                	je     80106420 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106439:	8b 45 08             	mov    0x8(%ebp),%eax
8010643c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106441:	ee                   	out    %al,(%dx)
}
80106442:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106445:	5b                   	pop    %ebx
80106446:	5e                   	pop    %esi
80106447:	5d                   	pop    %ebp
80106448:	c3                   	ret    
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106450:	c3                   	ret    
80106451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010645f:	90                   	nop

80106460 <uartintr>:

void
uartintr(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106466:	68 f0 62 10 80       	push   $0x801062f0
8010646b:	e8 10 a4 ff ff       	call   80100880 <consoleintr>
}
80106470:	83 c4 10             	add    $0x10,%esp
80106473:	c9                   	leave  
80106474:	c3                   	ret    

80106475 <vector0>:
80106475:	6a 00                	push   $0x0
80106477:	6a 00                	push   $0x0
80106479:	e9 e7 fa ff ff       	jmp    80105f65 <alltraps>

8010647e <vector1>:
8010647e:	6a 00                	push   $0x0
80106480:	6a 01                	push   $0x1
80106482:	e9 de fa ff ff       	jmp    80105f65 <alltraps>

80106487 <vector2>:
80106487:	6a 00                	push   $0x0
80106489:	6a 02                	push   $0x2
8010648b:	e9 d5 fa ff ff       	jmp    80105f65 <alltraps>

80106490 <vector3>:
80106490:	6a 00                	push   $0x0
80106492:	6a 03                	push   $0x3
80106494:	e9 cc fa ff ff       	jmp    80105f65 <alltraps>

80106499 <vector4>:
80106499:	6a 00                	push   $0x0
8010649b:	6a 04                	push   $0x4
8010649d:	e9 c3 fa ff ff       	jmp    80105f65 <alltraps>

801064a2 <vector5>:
801064a2:	6a 00                	push   $0x0
801064a4:	6a 05                	push   $0x5
801064a6:	e9 ba fa ff ff       	jmp    80105f65 <alltraps>

801064ab <vector6>:
801064ab:	6a 00                	push   $0x0
801064ad:	6a 06                	push   $0x6
801064af:	e9 b1 fa ff ff       	jmp    80105f65 <alltraps>

801064b4 <vector7>:
801064b4:	6a 00                	push   $0x0
801064b6:	6a 07                	push   $0x7
801064b8:	e9 a8 fa ff ff       	jmp    80105f65 <alltraps>

801064bd <vector8>:
801064bd:	6a 08                	push   $0x8
801064bf:	e9 a1 fa ff ff       	jmp    80105f65 <alltraps>

801064c4 <vector9>:
801064c4:	6a 00                	push   $0x0
801064c6:	6a 09                	push   $0x9
801064c8:	e9 98 fa ff ff       	jmp    80105f65 <alltraps>

801064cd <vector10>:
801064cd:	6a 0a                	push   $0xa
801064cf:	e9 91 fa ff ff       	jmp    80105f65 <alltraps>

801064d4 <vector11>:
801064d4:	6a 0b                	push   $0xb
801064d6:	e9 8a fa ff ff       	jmp    80105f65 <alltraps>

801064db <vector12>:
801064db:	6a 0c                	push   $0xc
801064dd:	e9 83 fa ff ff       	jmp    80105f65 <alltraps>

801064e2 <vector13>:
801064e2:	6a 0d                	push   $0xd
801064e4:	e9 7c fa ff ff       	jmp    80105f65 <alltraps>

801064e9 <vector14>:
801064e9:	6a 0e                	push   $0xe
801064eb:	e9 75 fa ff ff       	jmp    80105f65 <alltraps>

801064f0 <vector15>:
801064f0:	6a 00                	push   $0x0
801064f2:	6a 0f                	push   $0xf
801064f4:	e9 6c fa ff ff       	jmp    80105f65 <alltraps>

801064f9 <vector16>:
801064f9:	6a 00                	push   $0x0
801064fb:	6a 10                	push   $0x10
801064fd:	e9 63 fa ff ff       	jmp    80105f65 <alltraps>

80106502 <vector17>:
80106502:	6a 11                	push   $0x11
80106504:	e9 5c fa ff ff       	jmp    80105f65 <alltraps>

80106509 <vector18>:
80106509:	6a 00                	push   $0x0
8010650b:	6a 12                	push   $0x12
8010650d:	e9 53 fa ff ff       	jmp    80105f65 <alltraps>

80106512 <vector19>:
80106512:	6a 00                	push   $0x0
80106514:	6a 13                	push   $0x13
80106516:	e9 4a fa ff ff       	jmp    80105f65 <alltraps>

8010651b <vector20>:
8010651b:	6a 00                	push   $0x0
8010651d:	6a 14                	push   $0x14
8010651f:	e9 41 fa ff ff       	jmp    80105f65 <alltraps>

80106524 <vector21>:
80106524:	6a 00                	push   $0x0
80106526:	6a 15                	push   $0x15
80106528:	e9 38 fa ff ff       	jmp    80105f65 <alltraps>

8010652d <vector22>:
8010652d:	6a 00                	push   $0x0
8010652f:	6a 16                	push   $0x16
80106531:	e9 2f fa ff ff       	jmp    80105f65 <alltraps>

80106536 <vector23>:
80106536:	6a 00                	push   $0x0
80106538:	6a 17                	push   $0x17
8010653a:	e9 26 fa ff ff       	jmp    80105f65 <alltraps>

8010653f <vector24>:
8010653f:	6a 00                	push   $0x0
80106541:	6a 18                	push   $0x18
80106543:	e9 1d fa ff ff       	jmp    80105f65 <alltraps>

80106548 <vector25>:
80106548:	6a 00                	push   $0x0
8010654a:	6a 19                	push   $0x19
8010654c:	e9 14 fa ff ff       	jmp    80105f65 <alltraps>

80106551 <vector26>:
80106551:	6a 00                	push   $0x0
80106553:	6a 1a                	push   $0x1a
80106555:	e9 0b fa ff ff       	jmp    80105f65 <alltraps>

8010655a <vector27>:
8010655a:	6a 00                	push   $0x0
8010655c:	6a 1b                	push   $0x1b
8010655e:	e9 02 fa ff ff       	jmp    80105f65 <alltraps>

80106563 <vector28>:
80106563:	6a 00                	push   $0x0
80106565:	6a 1c                	push   $0x1c
80106567:	e9 f9 f9 ff ff       	jmp    80105f65 <alltraps>

8010656c <vector29>:
8010656c:	6a 00                	push   $0x0
8010656e:	6a 1d                	push   $0x1d
80106570:	e9 f0 f9 ff ff       	jmp    80105f65 <alltraps>

80106575 <vector30>:
80106575:	6a 00                	push   $0x0
80106577:	6a 1e                	push   $0x1e
80106579:	e9 e7 f9 ff ff       	jmp    80105f65 <alltraps>

8010657e <vector31>:
8010657e:	6a 00                	push   $0x0
80106580:	6a 1f                	push   $0x1f
80106582:	e9 de f9 ff ff       	jmp    80105f65 <alltraps>

80106587 <vector32>:
80106587:	6a 00                	push   $0x0
80106589:	6a 20                	push   $0x20
8010658b:	e9 d5 f9 ff ff       	jmp    80105f65 <alltraps>

80106590 <vector33>:
80106590:	6a 00                	push   $0x0
80106592:	6a 21                	push   $0x21
80106594:	e9 cc f9 ff ff       	jmp    80105f65 <alltraps>

80106599 <vector34>:
80106599:	6a 00                	push   $0x0
8010659b:	6a 22                	push   $0x22
8010659d:	e9 c3 f9 ff ff       	jmp    80105f65 <alltraps>

801065a2 <vector35>:
801065a2:	6a 00                	push   $0x0
801065a4:	6a 23                	push   $0x23
801065a6:	e9 ba f9 ff ff       	jmp    80105f65 <alltraps>

801065ab <vector36>:
801065ab:	6a 00                	push   $0x0
801065ad:	6a 24                	push   $0x24
801065af:	e9 b1 f9 ff ff       	jmp    80105f65 <alltraps>

801065b4 <vector37>:
801065b4:	6a 00                	push   $0x0
801065b6:	6a 25                	push   $0x25
801065b8:	e9 a8 f9 ff ff       	jmp    80105f65 <alltraps>

801065bd <vector38>:
801065bd:	6a 00                	push   $0x0
801065bf:	6a 26                	push   $0x26
801065c1:	e9 9f f9 ff ff       	jmp    80105f65 <alltraps>

801065c6 <vector39>:
801065c6:	6a 00                	push   $0x0
801065c8:	6a 27                	push   $0x27
801065ca:	e9 96 f9 ff ff       	jmp    80105f65 <alltraps>

801065cf <vector40>:
801065cf:	6a 00                	push   $0x0
801065d1:	6a 28                	push   $0x28
801065d3:	e9 8d f9 ff ff       	jmp    80105f65 <alltraps>

801065d8 <vector41>:
801065d8:	6a 00                	push   $0x0
801065da:	6a 29                	push   $0x29
801065dc:	e9 84 f9 ff ff       	jmp    80105f65 <alltraps>

801065e1 <vector42>:
801065e1:	6a 00                	push   $0x0
801065e3:	6a 2a                	push   $0x2a
801065e5:	e9 7b f9 ff ff       	jmp    80105f65 <alltraps>

801065ea <vector43>:
801065ea:	6a 00                	push   $0x0
801065ec:	6a 2b                	push   $0x2b
801065ee:	e9 72 f9 ff ff       	jmp    80105f65 <alltraps>

801065f3 <vector44>:
801065f3:	6a 00                	push   $0x0
801065f5:	6a 2c                	push   $0x2c
801065f7:	e9 69 f9 ff ff       	jmp    80105f65 <alltraps>

801065fc <vector45>:
801065fc:	6a 00                	push   $0x0
801065fe:	6a 2d                	push   $0x2d
80106600:	e9 60 f9 ff ff       	jmp    80105f65 <alltraps>

80106605 <vector46>:
80106605:	6a 00                	push   $0x0
80106607:	6a 2e                	push   $0x2e
80106609:	e9 57 f9 ff ff       	jmp    80105f65 <alltraps>

8010660e <vector47>:
8010660e:	6a 00                	push   $0x0
80106610:	6a 2f                	push   $0x2f
80106612:	e9 4e f9 ff ff       	jmp    80105f65 <alltraps>

80106617 <vector48>:
80106617:	6a 00                	push   $0x0
80106619:	6a 30                	push   $0x30
8010661b:	e9 45 f9 ff ff       	jmp    80105f65 <alltraps>

80106620 <vector49>:
80106620:	6a 00                	push   $0x0
80106622:	6a 31                	push   $0x31
80106624:	e9 3c f9 ff ff       	jmp    80105f65 <alltraps>

80106629 <vector50>:
80106629:	6a 00                	push   $0x0
8010662b:	6a 32                	push   $0x32
8010662d:	e9 33 f9 ff ff       	jmp    80105f65 <alltraps>

80106632 <vector51>:
80106632:	6a 00                	push   $0x0
80106634:	6a 33                	push   $0x33
80106636:	e9 2a f9 ff ff       	jmp    80105f65 <alltraps>

8010663b <vector52>:
8010663b:	6a 00                	push   $0x0
8010663d:	6a 34                	push   $0x34
8010663f:	e9 21 f9 ff ff       	jmp    80105f65 <alltraps>

80106644 <vector53>:
80106644:	6a 00                	push   $0x0
80106646:	6a 35                	push   $0x35
80106648:	e9 18 f9 ff ff       	jmp    80105f65 <alltraps>

8010664d <vector54>:
8010664d:	6a 00                	push   $0x0
8010664f:	6a 36                	push   $0x36
80106651:	e9 0f f9 ff ff       	jmp    80105f65 <alltraps>

80106656 <vector55>:
80106656:	6a 00                	push   $0x0
80106658:	6a 37                	push   $0x37
8010665a:	e9 06 f9 ff ff       	jmp    80105f65 <alltraps>

8010665f <vector56>:
8010665f:	6a 00                	push   $0x0
80106661:	6a 38                	push   $0x38
80106663:	e9 fd f8 ff ff       	jmp    80105f65 <alltraps>

80106668 <vector57>:
80106668:	6a 00                	push   $0x0
8010666a:	6a 39                	push   $0x39
8010666c:	e9 f4 f8 ff ff       	jmp    80105f65 <alltraps>

80106671 <vector58>:
80106671:	6a 00                	push   $0x0
80106673:	6a 3a                	push   $0x3a
80106675:	e9 eb f8 ff ff       	jmp    80105f65 <alltraps>

8010667a <vector59>:
8010667a:	6a 00                	push   $0x0
8010667c:	6a 3b                	push   $0x3b
8010667e:	e9 e2 f8 ff ff       	jmp    80105f65 <alltraps>

80106683 <vector60>:
80106683:	6a 00                	push   $0x0
80106685:	6a 3c                	push   $0x3c
80106687:	e9 d9 f8 ff ff       	jmp    80105f65 <alltraps>

8010668c <vector61>:
8010668c:	6a 00                	push   $0x0
8010668e:	6a 3d                	push   $0x3d
80106690:	e9 d0 f8 ff ff       	jmp    80105f65 <alltraps>

80106695 <vector62>:
80106695:	6a 00                	push   $0x0
80106697:	6a 3e                	push   $0x3e
80106699:	e9 c7 f8 ff ff       	jmp    80105f65 <alltraps>

8010669e <vector63>:
8010669e:	6a 00                	push   $0x0
801066a0:	6a 3f                	push   $0x3f
801066a2:	e9 be f8 ff ff       	jmp    80105f65 <alltraps>

801066a7 <vector64>:
801066a7:	6a 00                	push   $0x0
801066a9:	6a 40                	push   $0x40
801066ab:	e9 b5 f8 ff ff       	jmp    80105f65 <alltraps>

801066b0 <vector65>:
801066b0:	6a 00                	push   $0x0
801066b2:	6a 41                	push   $0x41
801066b4:	e9 ac f8 ff ff       	jmp    80105f65 <alltraps>

801066b9 <vector66>:
801066b9:	6a 00                	push   $0x0
801066bb:	6a 42                	push   $0x42
801066bd:	e9 a3 f8 ff ff       	jmp    80105f65 <alltraps>

801066c2 <vector67>:
801066c2:	6a 00                	push   $0x0
801066c4:	6a 43                	push   $0x43
801066c6:	e9 9a f8 ff ff       	jmp    80105f65 <alltraps>

801066cb <vector68>:
801066cb:	6a 00                	push   $0x0
801066cd:	6a 44                	push   $0x44
801066cf:	e9 91 f8 ff ff       	jmp    80105f65 <alltraps>

801066d4 <vector69>:
801066d4:	6a 00                	push   $0x0
801066d6:	6a 45                	push   $0x45
801066d8:	e9 88 f8 ff ff       	jmp    80105f65 <alltraps>

801066dd <vector70>:
801066dd:	6a 00                	push   $0x0
801066df:	6a 46                	push   $0x46
801066e1:	e9 7f f8 ff ff       	jmp    80105f65 <alltraps>

801066e6 <vector71>:
801066e6:	6a 00                	push   $0x0
801066e8:	6a 47                	push   $0x47
801066ea:	e9 76 f8 ff ff       	jmp    80105f65 <alltraps>

801066ef <vector72>:
801066ef:	6a 00                	push   $0x0
801066f1:	6a 48                	push   $0x48
801066f3:	e9 6d f8 ff ff       	jmp    80105f65 <alltraps>

801066f8 <vector73>:
801066f8:	6a 00                	push   $0x0
801066fa:	6a 49                	push   $0x49
801066fc:	e9 64 f8 ff ff       	jmp    80105f65 <alltraps>

80106701 <vector74>:
80106701:	6a 00                	push   $0x0
80106703:	6a 4a                	push   $0x4a
80106705:	e9 5b f8 ff ff       	jmp    80105f65 <alltraps>

8010670a <vector75>:
8010670a:	6a 00                	push   $0x0
8010670c:	6a 4b                	push   $0x4b
8010670e:	e9 52 f8 ff ff       	jmp    80105f65 <alltraps>

80106713 <vector76>:
80106713:	6a 00                	push   $0x0
80106715:	6a 4c                	push   $0x4c
80106717:	e9 49 f8 ff ff       	jmp    80105f65 <alltraps>

8010671c <vector77>:
8010671c:	6a 00                	push   $0x0
8010671e:	6a 4d                	push   $0x4d
80106720:	e9 40 f8 ff ff       	jmp    80105f65 <alltraps>

80106725 <vector78>:
80106725:	6a 00                	push   $0x0
80106727:	6a 4e                	push   $0x4e
80106729:	e9 37 f8 ff ff       	jmp    80105f65 <alltraps>

8010672e <vector79>:
8010672e:	6a 00                	push   $0x0
80106730:	6a 4f                	push   $0x4f
80106732:	e9 2e f8 ff ff       	jmp    80105f65 <alltraps>

80106737 <vector80>:
80106737:	6a 00                	push   $0x0
80106739:	6a 50                	push   $0x50
8010673b:	e9 25 f8 ff ff       	jmp    80105f65 <alltraps>

80106740 <vector81>:
80106740:	6a 00                	push   $0x0
80106742:	6a 51                	push   $0x51
80106744:	e9 1c f8 ff ff       	jmp    80105f65 <alltraps>

80106749 <vector82>:
80106749:	6a 00                	push   $0x0
8010674b:	6a 52                	push   $0x52
8010674d:	e9 13 f8 ff ff       	jmp    80105f65 <alltraps>

80106752 <vector83>:
80106752:	6a 00                	push   $0x0
80106754:	6a 53                	push   $0x53
80106756:	e9 0a f8 ff ff       	jmp    80105f65 <alltraps>

8010675b <vector84>:
8010675b:	6a 00                	push   $0x0
8010675d:	6a 54                	push   $0x54
8010675f:	e9 01 f8 ff ff       	jmp    80105f65 <alltraps>

80106764 <vector85>:
80106764:	6a 00                	push   $0x0
80106766:	6a 55                	push   $0x55
80106768:	e9 f8 f7 ff ff       	jmp    80105f65 <alltraps>

8010676d <vector86>:
8010676d:	6a 00                	push   $0x0
8010676f:	6a 56                	push   $0x56
80106771:	e9 ef f7 ff ff       	jmp    80105f65 <alltraps>

80106776 <vector87>:
80106776:	6a 00                	push   $0x0
80106778:	6a 57                	push   $0x57
8010677a:	e9 e6 f7 ff ff       	jmp    80105f65 <alltraps>

8010677f <vector88>:
8010677f:	6a 00                	push   $0x0
80106781:	6a 58                	push   $0x58
80106783:	e9 dd f7 ff ff       	jmp    80105f65 <alltraps>

80106788 <vector89>:
80106788:	6a 00                	push   $0x0
8010678a:	6a 59                	push   $0x59
8010678c:	e9 d4 f7 ff ff       	jmp    80105f65 <alltraps>

80106791 <vector90>:
80106791:	6a 00                	push   $0x0
80106793:	6a 5a                	push   $0x5a
80106795:	e9 cb f7 ff ff       	jmp    80105f65 <alltraps>

8010679a <vector91>:
8010679a:	6a 00                	push   $0x0
8010679c:	6a 5b                	push   $0x5b
8010679e:	e9 c2 f7 ff ff       	jmp    80105f65 <alltraps>

801067a3 <vector92>:
801067a3:	6a 00                	push   $0x0
801067a5:	6a 5c                	push   $0x5c
801067a7:	e9 b9 f7 ff ff       	jmp    80105f65 <alltraps>

801067ac <vector93>:
801067ac:	6a 00                	push   $0x0
801067ae:	6a 5d                	push   $0x5d
801067b0:	e9 b0 f7 ff ff       	jmp    80105f65 <alltraps>

801067b5 <vector94>:
801067b5:	6a 00                	push   $0x0
801067b7:	6a 5e                	push   $0x5e
801067b9:	e9 a7 f7 ff ff       	jmp    80105f65 <alltraps>

801067be <vector95>:
801067be:	6a 00                	push   $0x0
801067c0:	6a 5f                	push   $0x5f
801067c2:	e9 9e f7 ff ff       	jmp    80105f65 <alltraps>

801067c7 <vector96>:
801067c7:	6a 00                	push   $0x0
801067c9:	6a 60                	push   $0x60
801067cb:	e9 95 f7 ff ff       	jmp    80105f65 <alltraps>

801067d0 <vector97>:
801067d0:	6a 00                	push   $0x0
801067d2:	6a 61                	push   $0x61
801067d4:	e9 8c f7 ff ff       	jmp    80105f65 <alltraps>

801067d9 <vector98>:
801067d9:	6a 00                	push   $0x0
801067db:	6a 62                	push   $0x62
801067dd:	e9 83 f7 ff ff       	jmp    80105f65 <alltraps>

801067e2 <vector99>:
801067e2:	6a 00                	push   $0x0
801067e4:	6a 63                	push   $0x63
801067e6:	e9 7a f7 ff ff       	jmp    80105f65 <alltraps>

801067eb <vector100>:
801067eb:	6a 00                	push   $0x0
801067ed:	6a 64                	push   $0x64
801067ef:	e9 71 f7 ff ff       	jmp    80105f65 <alltraps>

801067f4 <vector101>:
801067f4:	6a 00                	push   $0x0
801067f6:	6a 65                	push   $0x65
801067f8:	e9 68 f7 ff ff       	jmp    80105f65 <alltraps>

801067fd <vector102>:
801067fd:	6a 00                	push   $0x0
801067ff:	6a 66                	push   $0x66
80106801:	e9 5f f7 ff ff       	jmp    80105f65 <alltraps>

80106806 <vector103>:
80106806:	6a 00                	push   $0x0
80106808:	6a 67                	push   $0x67
8010680a:	e9 56 f7 ff ff       	jmp    80105f65 <alltraps>

8010680f <vector104>:
8010680f:	6a 00                	push   $0x0
80106811:	6a 68                	push   $0x68
80106813:	e9 4d f7 ff ff       	jmp    80105f65 <alltraps>

80106818 <vector105>:
80106818:	6a 00                	push   $0x0
8010681a:	6a 69                	push   $0x69
8010681c:	e9 44 f7 ff ff       	jmp    80105f65 <alltraps>

80106821 <vector106>:
80106821:	6a 00                	push   $0x0
80106823:	6a 6a                	push   $0x6a
80106825:	e9 3b f7 ff ff       	jmp    80105f65 <alltraps>

8010682a <vector107>:
8010682a:	6a 00                	push   $0x0
8010682c:	6a 6b                	push   $0x6b
8010682e:	e9 32 f7 ff ff       	jmp    80105f65 <alltraps>

80106833 <vector108>:
80106833:	6a 00                	push   $0x0
80106835:	6a 6c                	push   $0x6c
80106837:	e9 29 f7 ff ff       	jmp    80105f65 <alltraps>

8010683c <vector109>:
8010683c:	6a 00                	push   $0x0
8010683e:	6a 6d                	push   $0x6d
80106840:	e9 20 f7 ff ff       	jmp    80105f65 <alltraps>

80106845 <vector110>:
80106845:	6a 00                	push   $0x0
80106847:	6a 6e                	push   $0x6e
80106849:	e9 17 f7 ff ff       	jmp    80105f65 <alltraps>

8010684e <vector111>:
8010684e:	6a 00                	push   $0x0
80106850:	6a 6f                	push   $0x6f
80106852:	e9 0e f7 ff ff       	jmp    80105f65 <alltraps>

80106857 <vector112>:
80106857:	6a 00                	push   $0x0
80106859:	6a 70                	push   $0x70
8010685b:	e9 05 f7 ff ff       	jmp    80105f65 <alltraps>

80106860 <vector113>:
80106860:	6a 00                	push   $0x0
80106862:	6a 71                	push   $0x71
80106864:	e9 fc f6 ff ff       	jmp    80105f65 <alltraps>

80106869 <vector114>:
80106869:	6a 00                	push   $0x0
8010686b:	6a 72                	push   $0x72
8010686d:	e9 f3 f6 ff ff       	jmp    80105f65 <alltraps>

80106872 <vector115>:
80106872:	6a 00                	push   $0x0
80106874:	6a 73                	push   $0x73
80106876:	e9 ea f6 ff ff       	jmp    80105f65 <alltraps>

8010687b <vector116>:
8010687b:	6a 00                	push   $0x0
8010687d:	6a 74                	push   $0x74
8010687f:	e9 e1 f6 ff ff       	jmp    80105f65 <alltraps>

80106884 <vector117>:
80106884:	6a 00                	push   $0x0
80106886:	6a 75                	push   $0x75
80106888:	e9 d8 f6 ff ff       	jmp    80105f65 <alltraps>

8010688d <vector118>:
8010688d:	6a 00                	push   $0x0
8010688f:	6a 76                	push   $0x76
80106891:	e9 cf f6 ff ff       	jmp    80105f65 <alltraps>

80106896 <vector119>:
80106896:	6a 00                	push   $0x0
80106898:	6a 77                	push   $0x77
8010689a:	e9 c6 f6 ff ff       	jmp    80105f65 <alltraps>

8010689f <vector120>:
8010689f:	6a 00                	push   $0x0
801068a1:	6a 78                	push   $0x78
801068a3:	e9 bd f6 ff ff       	jmp    80105f65 <alltraps>

801068a8 <vector121>:
801068a8:	6a 00                	push   $0x0
801068aa:	6a 79                	push   $0x79
801068ac:	e9 b4 f6 ff ff       	jmp    80105f65 <alltraps>

801068b1 <vector122>:
801068b1:	6a 00                	push   $0x0
801068b3:	6a 7a                	push   $0x7a
801068b5:	e9 ab f6 ff ff       	jmp    80105f65 <alltraps>

801068ba <vector123>:
801068ba:	6a 00                	push   $0x0
801068bc:	6a 7b                	push   $0x7b
801068be:	e9 a2 f6 ff ff       	jmp    80105f65 <alltraps>

801068c3 <vector124>:
801068c3:	6a 00                	push   $0x0
801068c5:	6a 7c                	push   $0x7c
801068c7:	e9 99 f6 ff ff       	jmp    80105f65 <alltraps>

801068cc <vector125>:
801068cc:	6a 00                	push   $0x0
801068ce:	6a 7d                	push   $0x7d
801068d0:	e9 90 f6 ff ff       	jmp    80105f65 <alltraps>

801068d5 <vector126>:
801068d5:	6a 00                	push   $0x0
801068d7:	6a 7e                	push   $0x7e
801068d9:	e9 87 f6 ff ff       	jmp    80105f65 <alltraps>

801068de <vector127>:
801068de:	6a 00                	push   $0x0
801068e0:	6a 7f                	push   $0x7f
801068e2:	e9 7e f6 ff ff       	jmp    80105f65 <alltraps>

801068e7 <vector128>:
801068e7:	6a 00                	push   $0x0
801068e9:	68 80 00 00 00       	push   $0x80
801068ee:	e9 72 f6 ff ff       	jmp    80105f65 <alltraps>

801068f3 <vector129>:
801068f3:	6a 00                	push   $0x0
801068f5:	68 81 00 00 00       	push   $0x81
801068fa:	e9 66 f6 ff ff       	jmp    80105f65 <alltraps>

801068ff <vector130>:
801068ff:	6a 00                	push   $0x0
80106901:	68 82 00 00 00       	push   $0x82
80106906:	e9 5a f6 ff ff       	jmp    80105f65 <alltraps>

8010690b <vector131>:
8010690b:	6a 00                	push   $0x0
8010690d:	68 83 00 00 00       	push   $0x83
80106912:	e9 4e f6 ff ff       	jmp    80105f65 <alltraps>

80106917 <vector132>:
80106917:	6a 00                	push   $0x0
80106919:	68 84 00 00 00       	push   $0x84
8010691e:	e9 42 f6 ff ff       	jmp    80105f65 <alltraps>

80106923 <vector133>:
80106923:	6a 00                	push   $0x0
80106925:	68 85 00 00 00       	push   $0x85
8010692a:	e9 36 f6 ff ff       	jmp    80105f65 <alltraps>

8010692f <vector134>:
8010692f:	6a 00                	push   $0x0
80106931:	68 86 00 00 00       	push   $0x86
80106936:	e9 2a f6 ff ff       	jmp    80105f65 <alltraps>

8010693b <vector135>:
8010693b:	6a 00                	push   $0x0
8010693d:	68 87 00 00 00       	push   $0x87
80106942:	e9 1e f6 ff ff       	jmp    80105f65 <alltraps>

80106947 <vector136>:
80106947:	6a 00                	push   $0x0
80106949:	68 88 00 00 00       	push   $0x88
8010694e:	e9 12 f6 ff ff       	jmp    80105f65 <alltraps>

80106953 <vector137>:
80106953:	6a 00                	push   $0x0
80106955:	68 89 00 00 00       	push   $0x89
8010695a:	e9 06 f6 ff ff       	jmp    80105f65 <alltraps>

8010695f <vector138>:
8010695f:	6a 00                	push   $0x0
80106961:	68 8a 00 00 00       	push   $0x8a
80106966:	e9 fa f5 ff ff       	jmp    80105f65 <alltraps>

8010696b <vector139>:
8010696b:	6a 00                	push   $0x0
8010696d:	68 8b 00 00 00       	push   $0x8b
80106972:	e9 ee f5 ff ff       	jmp    80105f65 <alltraps>

80106977 <vector140>:
80106977:	6a 00                	push   $0x0
80106979:	68 8c 00 00 00       	push   $0x8c
8010697e:	e9 e2 f5 ff ff       	jmp    80105f65 <alltraps>

80106983 <vector141>:
80106983:	6a 00                	push   $0x0
80106985:	68 8d 00 00 00       	push   $0x8d
8010698a:	e9 d6 f5 ff ff       	jmp    80105f65 <alltraps>

8010698f <vector142>:
8010698f:	6a 00                	push   $0x0
80106991:	68 8e 00 00 00       	push   $0x8e
80106996:	e9 ca f5 ff ff       	jmp    80105f65 <alltraps>

8010699b <vector143>:
8010699b:	6a 00                	push   $0x0
8010699d:	68 8f 00 00 00       	push   $0x8f
801069a2:	e9 be f5 ff ff       	jmp    80105f65 <alltraps>

801069a7 <vector144>:
801069a7:	6a 00                	push   $0x0
801069a9:	68 90 00 00 00       	push   $0x90
801069ae:	e9 b2 f5 ff ff       	jmp    80105f65 <alltraps>

801069b3 <vector145>:
801069b3:	6a 00                	push   $0x0
801069b5:	68 91 00 00 00       	push   $0x91
801069ba:	e9 a6 f5 ff ff       	jmp    80105f65 <alltraps>

801069bf <vector146>:
801069bf:	6a 00                	push   $0x0
801069c1:	68 92 00 00 00       	push   $0x92
801069c6:	e9 9a f5 ff ff       	jmp    80105f65 <alltraps>

801069cb <vector147>:
801069cb:	6a 00                	push   $0x0
801069cd:	68 93 00 00 00       	push   $0x93
801069d2:	e9 8e f5 ff ff       	jmp    80105f65 <alltraps>

801069d7 <vector148>:
801069d7:	6a 00                	push   $0x0
801069d9:	68 94 00 00 00       	push   $0x94
801069de:	e9 82 f5 ff ff       	jmp    80105f65 <alltraps>

801069e3 <vector149>:
801069e3:	6a 00                	push   $0x0
801069e5:	68 95 00 00 00       	push   $0x95
801069ea:	e9 76 f5 ff ff       	jmp    80105f65 <alltraps>

801069ef <vector150>:
801069ef:	6a 00                	push   $0x0
801069f1:	68 96 00 00 00       	push   $0x96
801069f6:	e9 6a f5 ff ff       	jmp    80105f65 <alltraps>

801069fb <vector151>:
801069fb:	6a 00                	push   $0x0
801069fd:	68 97 00 00 00       	push   $0x97
80106a02:	e9 5e f5 ff ff       	jmp    80105f65 <alltraps>

80106a07 <vector152>:
80106a07:	6a 00                	push   $0x0
80106a09:	68 98 00 00 00       	push   $0x98
80106a0e:	e9 52 f5 ff ff       	jmp    80105f65 <alltraps>

80106a13 <vector153>:
80106a13:	6a 00                	push   $0x0
80106a15:	68 99 00 00 00       	push   $0x99
80106a1a:	e9 46 f5 ff ff       	jmp    80105f65 <alltraps>

80106a1f <vector154>:
80106a1f:	6a 00                	push   $0x0
80106a21:	68 9a 00 00 00       	push   $0x9a
80106a26:	e9 3a f5 ff ff       	jmp    80105f65 <alltraps>

80106a2b <vector155>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	68 9b 00 00 00       	push   $0x9b
80106a32:	e9 2e f5 ff ff       	jmp    80105f65 <alltraps>

80106a37 <vector156>:
80106a37:	6a 00                	push   $0x0
80106a39:	68 9c 00 00 00       	push   $0x9c
80106a3e:	e9 22 f5 ff ff       	jmp    80105f65 <alltraps>

80106a43 <vector157>:
80106a43:	6a 00                	push   $0x0
80106a45:	68 9d 00 00 00       	push   $0x9d
80106a4a:	e9 16 f5 ff ff       	jmp    80105f65 <alltraps>

80106a4f <vector158>:
80106a4f:	6a 00                	push   $0x0
80106a51:	68 9e 00 00 00       	push   $0x9e
80106a56:	e9 0a f5 ff ff       	jmp    80105f65 <alltraps>

80106a5b <vector159>:
80106a5b:	6a 00                	push   $0x0
80106a5d:	68 9f 00 00 00       	push   $0x9f
80106a62:	e9 fe f4 ff ff       	jmp    80105f65 <alltraps>

80106a67 <vector160>:
80106a67:	6a 00                	push   $0x0
80106a69:	68 a0 00 00 00       	push   $0xa0
80106a6e:	e9 f2 f4 ff ff       	jmp    80105f65 <alltraps>

80106a73 <vector161>:
80106a73:	6a 00                	push   $0x0
80106a75:	68 a1 00 00 00       	push   $0xa1
80106a7a:	e9 e6 f4 ff ff       	jmp    80105f65 <alltraps>

80106a7f <vector162>:
80106a7f:	6a 00                	push   $0x0
80106a81:	68 a2 00 00 00       	push   $0xa2
80106a86:	e9 da f4 ff ff       	jmp    80105f65 <alltraps>

80106a8b <vector163>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	68 a3 00 00 00       	push   $0xa3
80106a92:	e9 ce f4 ff ff       	jmp    80105f65 <alltraps>

80106a97 <vector164>:
80106a97:	6a 00                	push   $0x0
80106a99:	68 a4 00 00 00       	push   $0xa4
80106a9e:	e9 c2 f4 ff ff       	jmp    80105f65 <alltraps>

80106aa3 <vector165>:
80106aa3:	6a 00                	push   $0x0
80106aa5:	68 a5 00 00 00       	push   $0xa5
80106aaa:	e9 b6 f4 ff ff       	jmp    80105f65 <alltraps>

80106aaf <vector166>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	68 a6 00 00 00       	push   $0xa6
80106ab6:	e9 aa f4 ff ff       	jmp    80105f65 <alltraps>

80106abb <vector167>:
80106abb:	6a 00                	push   $0x0
80106abd:	68 a7 00 00 00       	push   $0xa7
80106ac2:	e9 9e f4 ff ff       	jmp    80105f65 <alltraps>

80106ac7 <vector168>:
80106ac7:	6a 00                	push   $0x0
80106ac9:	68 a8 00 00 00       	push   $0xa8
80106ace:	e9 92 f4 ff ff       	jmp    80105f65 <alltraps>

80106ad3 <vector169>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	68 a9 00 00 00       	push   $0xa9
80106ada:	e9 86 f4 ff ff       	jmp    80105f65 <alltraps>

80106adf <vector170>:
80106adf:	6a 00                	push   $0x0
80106ae1:	68 aa 00 00 00       	push   $0xaa
80106ae6:	e9 7a f4 ff ff       	jmp    80105f65 <alltraps>

80106aeb <vector171>:
80106aeb:	6a 00                	push   $0x0
80106aed:	68 ab 00 00 00       	push   $0xab
80106af2:	e9 6e f4 ff ff       	jmp    80105f65 <alltraps>

80106af7 <vector172>:
80106af7:	6a 00                	push   $0x0
80106af9:	68 ac 00 00 00       	push   $0xac
80106afe:	e9 62 f4 ff ff       	jmp    80105f65 <alltraps>

80106b03 <vector173>:
80106b03:	6a 00                	push   $0x0
80106b05:	68 ad 00 00 00       	push   $0xad
80106b0a:	e9 56 f4 ff ff       	jmp    80105f65 <alltraps>

80106b0f <vector174>:
80106b0f:	6a 00                	push   $0x0
80106b11:	68 ae 00 00 00       	push   $0xae
80106b16:	e9 4a f4 ff ff       	jmp    80105f65 <alltraps>

80106b1b <vector175>:
80106b1b:	6a 00                	push   $0x0
80106b1d:	68 af 00 00 00       	push   $0xaf
80106b22:	e9 3e f4 ff ff       	jmp    80105f65 <alltraps>

80106b27 <vector176>:
80106b27:	6a 00                	push   $0x0
80106b29:	68 b0 00 00 00       	push   $0xb0
80106b2e:	e9 32 f4 ff ff       	jmp    80105f65 <alltraps>

80106b33 <vector177>:
80106b33:	6a 00                	push   $0x0
80106b35:	68 b1 00 00 00       	push   $0xb1
80106b3a:	e9 26 f4 ff ff       	jmp    80105f65 <alltraps>

80106b3f <vector178>:
80106b3f:	6a 00                	push   $0x0
80106b41:	68 b2 00 00 00       	push   $0xb2
80106b46:	e9 1a f4 ff ff       	jmp    80105f65 <alltraps>

80106b4b <vector179>:
80106b4b:	6a 00                	push   $0x0
80106b4d:	68 b3 00 00 00       	push   $0xb3
80106b52:	e9 0e f4 ff ff       	jmp    80105f65 <alltraps>

80106b57 <vector180>:
80106b57:	6a 00                	push   $0x0
80106b59:	68 b4 00 00 00       	push   $0xb4
80106b5e:	e9 02 f4 ff ff       	jmp    80105f65 <alltraps>

80106b63 <vector181>:
80106b63:	6a 00                	push   $0x0
80106b65:	68 b5 00 00 00       	push   $0xb5
80106b6a:	e9 f6 f3 ff ff       	jmp    80105f65 <alltraps>

80106b6f <vector182>:
80106b6f:	6a 00                	push   $0x0
80106b71:	68 b6 00 00 00       	push   $0xb6
80106b76:	e9 ea f3 ff ff       	jmp    80105f65 <alltraps>

80106b7b <vector183>:
80106b7b:	6a 00                	push   $0x0
80106b7d:	68 b7 00 00 00       	push   $0xb7
80106b82:	e9 de f3 ff ff       	jmp    80105f65 <alltraps>

80106b87 <vector184>:
80106b87:	6a 00                	push   $0x0
80106b89:	68 b8 00 00 00       	push   $0xb8
80106b8e:	e9 d2 f3 ff ff       	jmp    80105f65 <alltraps>

80106b93 <vector185>:
80106b93:	6a 00                	push   $0x0
80106b95:	68 b9 00 00 00       	push   $0xb9
80106b9a:	e9 c6 f3 ff ff       	jmp    80105f65 <alltraps>

80106b9f <vector186>:
80106b9f:	6a 00                	push   $0x0
80106ba1:	68 ba 00 00 00       	push   $0xba
80106ba6:	e9 ba f3 ff ff       	jmp    80105f65 <alltraps>

80106bab <vector187>:
80106bab:	6a 00                	push   $0x0
80106bad:	68 bb 00 00 00       	push   $0xbb
80106bb2:	e9 ae f3 ff ff       	jmp    80105f65 <alltraps>

80106bb7 <vector188>:
80106bb7:	6a 00                	push   $0x0
80106bb9:	68 bc 00 00 00       	push   $0xbc
80106bbe:	e9 a2 f3 ff ff       	jmp    80105f65 <alltraps>

80106bc3 <vector189>:
80106bc3:	6a 00                	push   $0x0
80106bc5:	68 bd 00 00 00       	push   $0xbd
80106bca:	e9 96 f3 ff ff       	jmp    80105f65 <alltraps>

80106bcf <vector190>:
80106bcf:	6a 00                	push   $0x0
80106bd1:	68 be 00 00 00       	push   $0xbe
80106bd6:	e9 8a f3 ff ff       	jmp    80105f65 <alltraps>

80106bdb <vector191>:
80106bdb:	6a 00                	push   $0x0
80106bdd:	68 bf 00 00 00       	push   $0xbf
80106be2:	e9 7e f3 ff ff       	jmp    80105f65 <alltraps>

80106be7 <vector192>:
80106be7:	6a 00                	push   $0x0
80106be9:	68 c0 00 00 00       	push   $0xc0
80106bee:	e9 72 f3 ff ff       	jmp    80105f65 <alltraps>

80106bf3 <vector193>:
80106bf3:	6a 00                	push   $0x0
80106bf5:	68 c1 00 00 00       	push   $0xc1
80106bfa:	e9 66 f3 ff ff       	jmp    80105f65 <alltraps>

80106bff <vector194>:
80106bff:	6a 00                	push   $0x0
80106c01:	68 c2 00 00 00       	push   $0xc2
80106c06:	e9 5a f3 ff ff       	jmp    80105f65 <alltraps>

80106c0b <vector195>:
80106c0b:	6a 00                	push   $0x0
80106c0d:	68 c3 00 00 00       	push   $0xc3
80106c12:	e9 4e f3 ff ff       	jmp    80105f65 <alltraps>

80106c17 <vector196>:
80106c17:	6a 00                	push   $0x0
80106c19:	68 c4 00 00 00       	push   $0xc4
80106c1e:	e9 42 f3 ff ff       	jmp    80105f65 <alltraps>

80106c23 <vector197>:
80106c23:	6a 00                	push   $0x0
80106c25:	68 c5 00 00 00       	push   $0xc5
80106c2a:	e9 36 f3 ff ff       	jmp    80105f65 <alltraps>

80106c2f <vector198>:
80106c2f:	6a 00                	push   $0x0
80106c31:	68 c6 00 00 00       	push   $0xc6
80106c36:	e9 2a f3 ff ff       	jmp    80105f65 <alltraps>

80106c3b <vector199>:
80106c3b:	6a 00                	push   $0x0
80106c3d:	68 c7 00 00 00       	push   $0xc7
80106c42:	e9 1e f3 ff ff       	jmp    80105f65 <alltraps>

80106c47 <vector200>:
80106c47:	6a 00                	push   $0x0
80106c49:	68 c8 00 00 00       	push   $0xc8
80106c4e:	e9 12 f3 ff ff       	jmp    80105f65 <alltraps>

80106c53 <vector201>:
80106c53:	6a 00                	push   $0x0
80106c55:	68 c9 00 00 00       	push   $0xc9
80106c5a:	e9 06 f3 ff ff       	jmp    80105f65 <alltraps>

80106c5f <vector202>:
80106c5f:	6a 00                	push   $0x0
80106c61:	68 ca 00 00 00       	push   $0xca
80106c66:	e9 fa f2 ff ff       	jmp    80105f65 <alltraps>

80106c6b <vector203>:
80106c6b:	6a 00                	push   $0x0
80106c6d:	68 cb 00 00 00       	push   $0xcb
80106c72:	e9 ee f2 ff ff       	jmp    80105f65 <alltraps>

80106c77 <vector204>:
80106c77:	6a 00                	push   $0x0
80106c79:	68 cc 00 00 00       	push   $0xcc
80106c7e:	e9 e2 f2 ff ff       	jmp    80105f65 <alltraps>

80106c83 <vector205>:
80106c83:	6a 00                	push   $0x0
80106c85:	68 cd 00 00 00       	push   $0xcd
80106c8a:	e9 d6 f2 ff ff       	jmp    80105f65 <alltraps>

80106c8f <vector206>:
80106c8f:	6a 00                	push   $0x0
80106c91:	68 ce 00 00 00       	push   $0xce
80106c96:	e9 ca f2 ff ff       	jmp    80105f65 <alltraps>

80106c9b <vector207>:
80106c9b:	6a 00                	push   $0x0
80106c9d:	68 cf 00 00 00       	push   $0xcf
80106ca2:	e9 be f2 ff ff       	jmp    80105f65 <alltraps>

80106ca7 <vector208>:
80106ca7:	6a 00                	push   $0x0
80106ca9:	68 d0 00 00 00       	push   $0xd0
80106cae:	e9 b2 f2 ff ff       	jmp    80105f65 <alltraps>

80106cb3 <vector209>:
80106cb3:	6a 00                	push   $0x0
80106cb5:	68 d1 00 00 00       	push   $0xd1
80106cba:	e9 a6 f2 ff ff       	jmp    80105f65 <alltraps>

80106cbf <vector210>:
80106cbf:	6a 00                	push   $0x0
80106cc1:	68 d2 00 00 00       	push   $0xd2
80106cc6:	e9 9a f2 ff ff       	jmp    80105f65 <alltraps>

80106ccb <vector211>:
80106ccb:	6a 00                	push   $0x0
80106ccd:	68 d3 00 00 00       	push   $0xd3
80106cd2:	e9 8e f2 ff ff       	jmp    80105f65 <alltraps>

80106cd7 <vector212>:
80106cd7:	6a 00                	push   $0x0
80106cd9:	68 d4 00 00 00       	push   $0xd4
80106cde:	e9 82 f2 ff ff       	jmp    80105f65 <alltraps>

80106ce3 <vector213>:
80106ce3:	6a 00                	push   $0x0
80106ce5:	68 d5 00 00 00       	push   $0xd5
80106cea:	e9 76 f2 ff ff       	jmp    80105f65 <alltraps>

80106cef <vector214>:
80106cef:	6a 00                	push   $0x0
80106cf1:	68 d6 00 00 00       	push   $0xd6
80106cf6:	e9 6a f2 ff ff       	jmp    80105f65 <alltraps>

80106cfb <vector215>:
80106cfb:	6a 00                	push   $0x0
80106cfd:	68 d7 00 00 00       	push   $0xd7
80106d02:	e9 5e f2 ff ff       	jmp    80105f65 <alltraps>

80106d07 <vector216>:
80106d07:	6a 00                	push   $0x0
80106d09:	68 d8 00 00 00       	push   $0xd8
80106d0e:	e9 52 f2 ff ff       	jmp    80105f65 <alltraps>

80106d13 <vector217>:
80106d13:	6a 00                	push   $0x0
80106d15:	68 d9 00 00 00       	push   $0xd9
80106d1a:	e9 46 f2 ff ff       	jmp    80105f65 <alltraps>

80106d1f <vector218>:
80106d1f:	6a 00                	push   $0x0
80106d21:	68 da 00 00 00       	push   $0xda
80106d26:	e9 3a f2 ff ff       	jmp    80105f65 <alltraps>

80106d2b <vector219>:
80106d2b:	6a 00                	push   $0x0
80106d2d:	68 db 00 00 00       	push   $0xdb
80106d32:	e9 2e f2 ff ff       	jmp    80105f65 <alltraps>

80106d37 <vector220>:
80106d37:	6a 00                	push   $0x0
80106d39:	68 dc 00 00 00       	push   $0xdc
80106d3e:	e9 22 f2 ff ff       	jmp    80105f65 <alltraps>

80106d43 <vector221>:
80106d43:	6a 00                	push   $0x0
80106d45:	68 dd 00 00 00       	push   $0xdd
80106d4a:	e9 16 f2 ff ff       	jmp    80105f65 <alltraps>

80106d4f <vector222>:
80106d4f:	6a 00                	push   $0x0
80106d51:	68 de 00 00 00       	push   $0xde
80106d56:	e9 0a f2 ff ff       	jmp    80105f65 <alltraps>

80106d5b <vector223>:
80106d5b:	6a 00                	push   $0x0
80106d5d:	68 df 00 00 00       	push   $0xdf
80106d62:	e9 fe f1 ff ff       	jmp    80105f65 <alltraps>

80106d67 <vector224>:
80106d67:	6a 00                	push   $0x0
80106d69:	68 e0 00 00 00       	push   $0xe0
80106d6e:	e9 f2 f1 ff ff       	jmp    80105f65 <alltraps>

80106d73 <vector225>:
80106d73:	6a 00                	push   $0x0
80106d75:	68 e1 00 00 00       	push   $0xe1
80106d7a:	e9 e6 f1 ff ff       	jmp    80105f65 <alltraps>

80106d7f <vector226>:
80106d7f:	6a 00                	push   $0x0
80106d81:	68 e2 00 00 00       	push   $0xe2
80106d86:	e9 da f1 ff ff       	jmp    80105f65 <alltraps>

80106d8b <vector227>:
80106d8b:	6a 00                	push   $0x0
80106d8d:	68 e3 00 00 00       	push   $0xe3
80106d92:	e9 ce f1 ff ff       	jmp    80105f65 <alltraps>

80106d97 <vector228>:
80106d97:	6a 00                	push   $0x0
80106d99:	68 e4 00 00 00       	push   $0xe4
80106d9e:	e9 c2 f1 ff ff       	jmp    80105f65 <alltraps>

80106da3 <vector229>:
80106da3:	6a 00                	push   $0x0
80106da5:	68 e5 00 00 00       	push   $0xe5
80106daa:	e9 b6 f1 ff ff       	jmp    80105f65 <alltraps>

80106daf <vector230>:
80106daf:	6a 00                	push   $0x0
80106db1:	68 e6 00 00 00       	push   $0xe6
80106db6:	e9 aa f1 ff ff       	jmp    80105f65 <alltraps>

80106dbb <vector231>:
80106dbb:	6a 00                	push   $0x0
80106dbd:	68 e7 00 00 00       	push   $0xe7
80106dc2:	e9 9e f1 ff ff       	jmp    80105f65 <alltraps>

80106dc7 <vector232>:
80106dc7:	6a 00                	push   $0x0
80106dc9:	68 e8 00 00 00       	push   $0xe8
80106dce:	e9 92 f1 ff ff       	jmp    80105f65 <alltraps>

80106dd3 <vector233>:
80106dd3:	6a 00                	push   $0x0
80106dd5:	68 e9 00 00 00       	push   $0xe9
80106dda:	e9 86 f1 ff ff       	jmp    80105f65 <alltraps>

80106ddf <vector234>:
80106ddf:	6a 00                	push   $0x0
80106de1:	68 ea 00 00 00       	push   $0xea
80106de6:	e9 7a f1 ff ff       	jmp    80105f65 <alltraps>

80106deb <vector235>:
80106deb:	6a 00                	push   $0x0
80106ded:	68 eb 00 00 00       	push   $0xeb
80106df2:	e9 6e f1 ff ff       	jmp    80105f65 <alltraps>

80106df7 <vector236>:
80106df7:	6a 00                	push   $0x0
80106df9:	68 ec 00 00 00       	push   $0xec
80106dfe:	e9 62 f1 ff ff       	jmp    80105f65 <alltraps>

80106e03 <vector237>:
80106e03:	6a 00                	push   $0x0
80106e05:	68 ed 00 00 00       	push   $0xed
80106e0a:	e9 56 f1 ff ff       	jmp    80105f65 <alltraps>

80106e0f <vector238>:
80106e0f:	6a 00                	push   $0x0
80106e11:	68 ee 00 00 00       	push   $0xee
80106e16:	e9 4a f1 ff ff       	jmp    80105f65 <alltraps>

80106e1b <vector239>:
80106e1b:	6a 00                	push   $0x0
80106e1d:	68 ef 00 00 00       	push   $0xef
80106e22:	e9 3e f1 ff ff       	jmp    80105f65 <alltraps>

80106e27 <vector240>:
80106e27:	6a 00                	push   $0x0
80106e29:	68 f0 00 00 00       	push   $0xf0
80106e2e:	e9 32 f1 ff ff       	jmp    80105f65 <alltraps>

80106e33 <vector241>:
80106e33:	6a 00                	push   $0x0
80106e35:	68 f1 00 00 00       	push   $0xf1
80106e3a:	e9 26 f1 ff ff       	jmp    80105f65 <alltraps>

80106e3f <vector242>:
80106e3f:	6a 00                	push   $0x0
80106e41:	68 f2 00 00 00       	push   $0xf2
80106e46:	e9 1a f1 ff ff       	jmp    80105f65 <alltraps>

80106e4b <vector243>:
80106e4b:	6a 00                	push   $0x0
80106e4d:	68 f3 00 00 00       	push   $0xf3
80106e52:	e9 0e f1 ff ff       	jmp    80105f65 <alltraps>

80106e57 <vector244>:
80106e57:	6a 00                	push   $0x0
80106e59:	68 f4 00 00 00       	push   $0xf4
80106e5e:	e9 02 f1 ff ff       	jmp    80105f65 <alltraps>

80106e63 <vector245>:
80106e63:	6a 00                	push   $0x0
80106e65:	68 f5 00 00 00       	push   $0xf5
80106e6a:	e9 f6 f0 ff ff       	jmp    80105f65 <alltraps>

80106e6f <vector246>:
80106e6f:	6a 00                	push   $0x0
80106e71:	68 f6 00 00 00       	push   $0xf6
80106e76:	e9 ea f0 ff ff       	jmp    80105f65 <alltraps>

80106e7b <vector247>:
80106e7b:	6a 00                	push   $0x0
80106e7d:	68 f7 00 00 00       	push   $0xf7
80106e82:	e9 de f0 ff ff       	jmp    80105f65 <alltraps>

80106e87 <vector248>:
80106e87:	6a 00                	push   $0x0
80106e89:	68 f8 00 00 00       	push   $0xf8
80106e8e:	e9 d2 f0 ff ff       	jmp    80105f65 <alltraps>

80106e93 <vector249>:
80106e93:	6a 00                	push   $0x0
80106e95:	68 f9 00 00 00       	push   $0xf9
80106e9a:	e9 c6 f0 ff ff       	jmp    80105f65 <alltraps>

80106e9f <vector250>:
80106e9f:	6a 00                	push   $0x0
80106ea1:	68 fa 00 00 00       	push   $0xfa
80106ea6:	e9 ba f0 ff ff       	jmp    80105f65 <alltraps>

80106eab <vector251>:
80106eab:	6a 00                	push   $0x0
80106ead:	68 fb 00 00 00       	push   $0xfb
80106eb2:	e9 ae f0 ff ff       	jmp    80105f65 <alltraps>

80106eb7 <vector252>:
80106eb7:	6a 00                	push   $0x0
80106eb9:	68 fc 00 00 00       	push   $0xfc
80106ebe:	e9 a2 f0 ff ff       	jmp    80105f65 <alltraps>

80106ec3 <vector253>:
80106ec3:	6a 00                	push   $0x0
80106ec5:	68 fd 00 00 00       	push   $0xfd
80106eca:	e9 96 f0 ff ff       	jmp    80105f65 <alltraps>

80106ecf <vector254>:
80106ecf:	6a 00                	push   $0x0
80106ed1:	68 fe 00 00 00       	push   $0xfe
80106ed6:	e9 8a f0 ff ff       	jmp    80105f65 <alltraps>

80106edb <vector255>:
80106edb:	6a 00                	push   $0x0
80106edd:	68 ff 00 00 00       	push   $0xff
80106ee2:	e9 7e f0 ff ff       	jmp    80105f65 <alltraps>
80106ee7:	66 90                	xchg   %ax,%ax
80106ee9:	66 90                	xchg   %ax,%ax
80106eeb:	66 90                	xchg   %ax,%ax
80106eed:	66 90                	xchg   %ax,%ax
80106eef:	90                   	nop

80106ef0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ef6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106efc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f02:	83 ec 1c             	sub    $0x1c,%esp
80106f05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f08:	39 d3                	cmp    %edx,%ebx
80106f0a:	73 49                	jae    80106f55 <deallocuvm.part.0+0x65>
80106f0c:	89 c7                	mov    %eax,%edi
80106f0e:	eb 0c                	jmp    80106f1c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f10:	83 c0 01             	add    $0x1,%eax
80106f13:	c1 e0 16             	shl    $0x16,%eax
80106f16:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f18:	39 da                	cmp    %ebx,%edx
80106f1a:	76 39                	jbe    80106f55 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106f1c:	89 d8                	mov    %ebx,%eax
80106f1e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106f21:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106f24:	f6 c1 01             	test   $0x1,%cl
80106f27:	74 e7                	je     80106f10 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106f29:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106f31:	c1 ee 0a             	shr    $0xa,%esi
80106f34:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106f3a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106f41:	85 f6                	test   %esi,%esi
80106f43:	74 cb                	je     80106f10 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106f45:	8b 06                	mov    (%esi),%eax
80106f47:	a8 01                	test   $0x1,%al
80106f49:	75 15                	jne    80106f60 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106f4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f51:	39 da                	cmp    %ebx,%edx
80106f53:	77 c7                	ja     80106f1c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106f55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5b:	5b                   	pop    %ebx
80106f5c:	5e                   	pop    %esi
80106f5d:	5f                   	pop    %edi
80106f5e:	5d                   	pop    %ebp
80106f5f:	c3                   	ret    
      if(pa == 0)
80106f60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f65:	74 25                	je     80106f8c <deallocuvm.part.0+0x9c>
      kfree(v);
80106f67:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f6a:	05 00 00 00 80       	add    $0x80000000,%eax
80106f6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106f78:	50                   	push   %eax
80106f79:	e8 42 b5 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106f7e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106f84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f87:	83 c4 10             	add    $0x10,%esp
80106f8a:	eb 8c                	jmp    80106f18 <deallocuvm.part.0+0x28>
        panic("kfree");
80106f8c:	83 ec 0c             	sub    $0xc,%esp
80106f8f:	68 46 7b 10 80       	push   $0x80107b46
80106f94:	e8 e7 93 ff ff       	call   80100380 <panic>
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <mappages>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106fa6:	89 d3                	mov    %edx,%ebx
80106fa8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106fae:	83 ec 1c             	sub    $0x1c,%esp
80106fb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106fb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106fb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc3:	29 d8                	sub    %ebx,%eax
80106fc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fc8:	eb 3d                	jmp    80107007 <mappages+0x67>
80106fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fd0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106fd7:	c1 ea 0a             	shr    $0xa,%edx
80106fda:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fe0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fe7:	85 c0                	test   %eax,%eax
80106fe9:	74 75                	je     80107060 <mappages+0xc0>
    if(*pte & PTE_P)
80106feb:	f6 00 01             	testb  $0x1,(%eax)
80106fee:	0f 85 86 00 00 00    	jne    8010707a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ff4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ff7:	83 ce 01             	or     $0x1,%esi
80106ffa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ffc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106fff:	74 6f                	je     80107070 <mappages+0xd0>
    a += PGSIZE;
80107001:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107007:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010700a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010700d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107010:	89 d8                	mov    %ebx,%eax
80107012:	c1 e8 16             	shr    $0x16,%eax
80107015:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107018:	8b 07                	mov    (%edi),%eax
8010701a:	a8 01                	test   $0x1,%al
8010701c:	75 b2                	jne    80106fd0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010701e:	e8 5d b6 ff ff       	call   80102680 <kalloc>
80107023:	85 c0                	test   %eax,%eax
80107025:	74 39                	je     80107060 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107027:	83 ec 04             	sub    $0x4,%esp
8010702a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010702d:	68 00 10 00 00       	push   $0x1000
80107032:	6a 00                	push   $0x0
80107034:	50                   	push   %eax
80107035:	e8 d6 dc ff ff       	call   80104d10 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010703a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010703d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107040:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107046:	83 c8 07             	or     $0x7,%eax
80107049:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010704b:	89 d8                	mov    %ebx,%eax
8010704d:	c1 e8 0a             	shr    $0xa,%eax
80107050:	25 fc 0f 00 00       	and    $0xffc,%eax
80107055:	01 d0                	add    %edx,%eax
80107057:	eb 92                	jmp    80106feb <mappages+0x4b>
80107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107060:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107068:	5b                   	pop    %ebx
80107069:	5e                   	pop    %esi
8010706a:	5f                   	pop    %edi
8010706b:	5d                   	pop    %ebp
8010706c:	c3                   	ret    
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
      panic("remap");
8010707a:	83 ec 0c             	sub    $0xc,%esp
8010707d:	68 48 83 10 80       	push   $0x80108348
80107082:	e8 f9 92 ff ff       	call   80100380 <panic>
80107087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708e:	66 90                	xchg   %ax,%ax

80107090 <seginit>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107096:	e8 d5 c8 ff ff       	call   80103970 <cpuid>
  pd[0] = size-1;
8010709b:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070a0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070aa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
801070b1:	ff 00 00 
801070b4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
801070bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070be:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801070c5:	ff 00 00 
801070c8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801070cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070d2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801070d9:	ff 00 00 
801070dc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801070e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070e6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801070ed:	ff 00 00 
801070f0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801070f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070fa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801070ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107103:	c1 e8 10             	shr    $0x10,%eax
80107106:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010710a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010710d:	0f 01 10             	lgdtl  (%eax)
}
80107110:	c9                   	leave  
80107111:	c3                   	ret    
80107112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107120 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107120:	a1 c4 57 11 80       	mov    0x801157c4,%eax
80107125:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010712a:	0f 22 d8             	mov    %eax,%cr3
}
8010712d:	c3                   	ret    
8010712e:	66 90                	xchg   %ax,%ax

80107130 <switchuvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 1c             	sub    $0x1c,%esp
80107139:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010713c:	85 f6                	test   %esi,%esi
8010713e:	0f 84 cb 00 00 00    	je     8010720f <switchuvm+0xdf>
  if(p->kstack == 0)
80107144:	8b 46 08             	mov    0x8(%esi),%eax
80107147:	85 c0                	test   %eax,%eax
80107149:	0f 84 da 00 00 00    	je     80107229 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010714f:	8b 46 04             	mov    0x4(%esi),%eax
80107152:	85 c0                	test   %eax,%eax
80107154:	0f 84 c2 00 00 00    	je     8010721c <switchuvm+0xec>
  pushcli();
8010715a:	e8 a1 d9 ff ff       	call   80104b00 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010715f:	e8 ac c7 ff ff       	call   80103910 <mycpu>
80107164:	89 c3                	mov    %eax,%ebx
80107166:	e8 a5 c7 ff ff       	call   80103910 <mycpu>
8010716b:	89 c7                	mov    %eax,%edi
8010716d:	e8 9e c7 ff ff       	call   80103910 <mycpu>
80107172:	83 c7 08             	add    $0x8,%edi
80107175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107178:	e8 93 c7 ff ff       	call   80103910 <mycpu>
8010717d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107180:	ba 67 00 00 00       	mov    $0x67,%edx
80107185:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010718c:	83 c0 08             	add    $0x8,%eax
8010718f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107196:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010719b:	83 c1 08             	add    $0x8,%ecx
8010719e:	c1 e8 18             	shr    $0x18,%eax
801071a1:	c1 e9 10             	shr    $0x10,%ecx
801071a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801071aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801071b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801071c1:	e8 4a c7 ff ff       	call   80103910 <mycpu>
801071c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071cd:	e8 3e c7 ff ff       	call   80103910 <mycpu>
801071d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801071d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071df:	e8 2c c7 ff ff       	call   80103910 <mycpu>
801071e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071e7:	e8 24 c7 ff ff       	call   80103910 <mycpu>
801071ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071f0:	b8 28 00 00 00       	mov    $0x28,%eax
801071f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071f8:	8b 46 04             	mov    0x4(%esi),%eax
801071fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107200:	0f 22 d8             	mov    %eax,%cr3
}
80107203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107206:	5b                   	pop    %ebx
80107207:	5e                   	pop    %esi
80107208:	5f                   	pop    %edi
80107209:	5d                   	pop    %ebp
  popcli();
8010720a:	e9 41 d9 ff ff       	jmp    80104b50 <popcli>
    panic("switchuvm: no process");
8010720f:	83 ec 0c             	sub    $0xc,%esp
80107212:	68 4e 83 10 80       	push   $0x8010834e
80107217:	e8 64 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010721c:	83 ec 0c             	sub    $0xc,%esp
8010721f:	68 79 83 10 80       	push   $0x80108379
80107224:	e8 57 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107229:	83 ec 0c             	sub    $0xc,%esp
8010722c:	68 64 83 10 80       	push   $0x80108364
80107231:	e8 4a 91 ff ff       	call   80100380 <panic>
80107236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723d:	8d 76 00             	lea    0x0(%esi),%esi

80107240 <inituvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 1c             	sub    $0x1c,%esp
80107249:	8b 45 0c             	mov    0xc(%ebp),%eax
8010724c:	8b 75 10             	mov    0x10(%ebp),%esi
8010724f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107252:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107255:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010725b:	77 4b                	ja     801072a8 <inituvm+0x68>
  mem = kalloc();
8010725d:	e8 1e b4 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107262:	83 ec 04             	sub    $0x4,%esp
80107265:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010726a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010726c:	6a 00                	push   $0x0
8010726e:	50                   	push   %eax
8010726f:	e8 9c da ff ff       	call   80104d10 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107274:	58                   	pop    %eax
80107275:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010727b:	5a                   	pop    %edx
8010727c:	6a 06                	push   $0x6
8010727e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107283:	31 d2                	xor    %edx,%edx
80107285:	50                   	push   %eax
80107286:	89 f8                	mov    %edi,%eax
80107288:	e8 13 fd ff ff       	call   80106fa0 <mappages>
  memmove(mem, init, sz);
8010728d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107290:	89 75 10             	mov    %esi,0x10(%ebp)
80107293:	83 c4 10             	add    $0x10,%esp
80107296:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107299:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010729c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010729f:	5b                   	pop    %ebx
801072a0:	5e                   	pop    %esi
801072a1:	5f                   	pop    %edi
801072a2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072a3:	e9 08 db ff ff       	jmp    80104db0 <memmove>
    panic("inituvm: more than a page");
801072a8:	83 ec 0c             	sub    $0xc,%esp
801072ab:	68 8d 83 10 80       	push   $0x8010838d
801072b0:	e8 cb 90 ff ff       	call   80100380 <panic>
801072b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072c0 <loaduvm>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
801072c6:	83 ec 1c             	sub    $0x1c,%esp
801072c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801072cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801072cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801072d4:	0f 85 bb 00 00 00    	jne    80107395 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801072da:	01 f0                	add    %esi,%eax
801072dc:	89 f3                	mov    %esi,%ebx
801072de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072e1:	8b 45 14             	mov    0x14(%ebp),%eax
801072e4:	01 f0                	add    %esi,%eax
801072e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801072e9:	85 f6                	test   %esi,%esi
801072eb:	0f 84 87 00 00 00    	je     80107378 <loaduvm+0xb8>
801072f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801072f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801072fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801072fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107300:	89 c2                	mov    %eax,%edx
80107302:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107305:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107308:	f6 c2 01             	test   $0x1,%dl
8010730b:	75 13                	jne    80107320 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010730d:	83 ec 0c             	sub    $0xc,%esp
80107310:	68 a7 83 10 80       	push   $0x801083a7
80107315:	e8 66 90 ff ff       	call   80100380 <panic>
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107320:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107323:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107329:	25 fc 0f 00 00       	and    $0xffc,%eax
8010732e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107335:	85 c0                	test   %eax,%eax
80107337:	74 d4                	je     8010730d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107339:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010733b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010733e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107343:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107348:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010734e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107351:	29 d9                	sub    %ebx,%ecx
80107353:	05 00 00 00 80       	add    $0x80000000,%eax
80107358:	57                   	push   %edi
80107359:	51                   	push   %ecx
8010735a:	50                   	push   %eax
8010735b:	ff 75 10             	push   0x10(%ebp)
8010735e:	e8 2d a7 ff ff       	call   80101a90 <readi>
80107363:	83 c4 10             	add    $0x10,%esp
80107366:	39 f8                	cmp    %edi,%eax
80107368:	75 1e                	jne    80107388 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010736a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107370:	89 f0                	mov    %esi,%eax
80107372:	29 d8                	sub    %ebx,%eax
80107374:	39 c6                	cmp    %eax,%esi
80107376:	77 80                	ja     801072f8 <loaduvm+0x38>
}
80107378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010737b:	31 c0                	xor    %eax,%eax
}
8010737d:	5b                   	pop    %ebx
8010737e:	5e                   	pop    %esi
8010737f:	5f                   	pop    %edi
80107380:	5d                   	pop    %ebp
80107381:	c3                   	ret    
80107382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107388:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010738b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107390:	5b                   	pop    %ebx
80107391:	5e                   	pop    %esi
80107392:	5f                   	pop    %edi
80107393:	5d                   	pop    %ebp
80107394:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107395:	83 ec 0c             	sub    $0xc,%esp
80107398:	68 48 84 10 80       	push   $0x80108448
8010739d:	e8 de 8f ff ff       	call   80100380 <panic>
801073a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073b0 <allocuvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073b9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801073bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801073bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073c2:	85 c0                	test   %eax,%eax
801073c4:	0f 88 b6 00 00 00    	js     80107480 <allocuvm+0xd0>
  if(newsz < oldsz)
801073ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801073cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801073d0:	0f 82 9a 00 00 00    	jb     80107470 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801073d6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801073dc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801073e2:	39 75 10             	cmp    %esi,0x10(%ebp)
801073e5:	77 44                	ja     8010742b <allocuvm+0x7b>
801073e7:	e9 87 00 00 00       	jmp    80107473 <allocuvm+0xc3>
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801073f0:	83 ec 04             	sub    $0x4,%esp
801073f3:	68 00 10 00 00       	push   $0x1000
801073f8:	6a 00                	push   $0x0
801073fa:	50                   	push   %eax
801073fb:	e8 10 d9 ff ff       	call   80104d10 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107400:	58                   	pop    %eax
80107401:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107407:	5a                   	pop    %edx
80107408:	6a 06                	push   $0x6
8010740a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010740f:	89 f2                	mov    %esi,%edx
80107411:	50                   	push   %eax
80107412:	89 f8                	mov    %edi,%eax
80107414:	e8 87 fb ff ff       	call   80106fa0 <mappages>
80107419:	83 c4 10             	add    $0x10,%esp
8010741c:	85 c0                	test   %eax,%eax
8010741e:	78 78                	js     80107498 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107420:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107426:	39 75 10             	cmp    %esi,0x10(%ebp)
80107429:	76 48                	jbe    80107473 <allocuvm+0xc3>
    mem = kalloc();
8010742b:	e8 50 b2 ff ff       	call   80102680 <kalloc>
80107430:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107432:	85 c0                	test   %eax,%eax
80107434:	75 ba                	jne    801073f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107436:	83 ec 0c             	sub    $0xc,%esp
80107439:	68 c5 83 10 80       	push   $0x801083c5
8010743e:	e8 5d 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107443:	8b 45 0c             	mov    0xc(%ebp),%eax
80107446:	83 c4 10             	add    $0x10,%esp
80107449:	39 45 10             	cmp    %eax,0x10(%ebp)
8010744c:	74 32                	je     80107480 <allocuvm+0xd0>
8010744e:	8b 55 10             	mov    0x10(%ebp),%edx
80107451:	89 c1                	mov    %eax,%ecx
80107453:	89 f8                	mov    %edi,%eax
80107455:	e8 96 fa ff ff       	call   80106ef0 <deallocuvm.part.0>
      return 0;
8010745a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107464:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107467:	5b                   	pop    %ebx
80107468:	5e                   	pop    %esi
80107469:	5f                   	pop    %edi
8010746a:	5d                   	pop    %ebp
8010746b:	c3                   	ret    
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107479:	5b                   	pop    %ebx
8010747a:	5e                   	pop    %esi
8010747b:	5f                   	pop    %edi
8010747c:	5d                   	pop    %ebp
8010747d:	c3                   	ret    
8010747e:	66 90                	xchg   %ax,%ax
    return 0;
80107480:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010748a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010748d:	5b                   	pop    %ebx
8010748e:	5e                   	pop    %esi
8010748f:	5f                   	pop    %edi
80107490:	5d                   	pop    %ebp
80107491:	c3                   	ret    
80107492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	68 dd 83 10 80       	push   $0x801083dd
801074a0:	e8 fb 91 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801074a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074a8:	83 c4 10             	add    $0x10,%esp
801074ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ae:	74 0c                	je     801074bc <allocuvm+0x10c>
801074b0:	8b 55 10             	mov    0x10(%ebp),%edx
801074b3:	89 c1                	mov    %eax,%ecx
801074b5:	89 f8                	mov    %edi,%eax
801074b7:	e8 34 fa ff ff       	call   80106ef0 <deallocuvm.part.0>
      kfree(mem);
801074bc:	83 ec 0c             	sub    $0xc,%esp
801074bf:	53                   	push   %ebx
801074c0:	e8 fb af ff ff       	call   801024c0 <kfree>
      return 0;
801074c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801074cc:	83 c4 10             	add    $0x10,%esp
}
801074cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d5:	5b                   	pop    %ebx
801074d6:	5e                   	pop    %esi
801074d7:	5f                   	pop    %edi
801074d8:	5d                   	pop    %ebp
801074d9:	c3                   	ret    
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074e0 <deallocuvm>:
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801074e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801074e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801074ec:	39 d1                	cmp    %edx,%ecx
801074ee:	73 10                	jae    80107500 <deallocuvm+0x20>
}
801074f0:	5d                   	pop    %ebp
801074f1:	e9 fa f9 ff ff       	jmp    80106ef0 <deallocuvm.part.0>
801074f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074fd:	8d 76 00             	lea    0x0(%esi),%esi
80107500:	89 d0                	mov    %edx,%eax
80107502:	5d                   	pop    %ebp
80107503:	c3                   	ret    
80107504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010750f:	90                   	nop

80107510 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
80107516:	83 ec 0c             	sub    $0xc,%esp
80107519:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010751c:	85 f6                	test   %esi,%esi
8010751e:	74 59                	je     80107579 <freevm+0x69>
  if(newsz >= oldsz)
80107520:	31 c9                	xor    %ecx,%ecx
80107522:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107527:	89 f0                	mov    %esi,%eax
80107529:	89 f3                	mov    %esi,%ebx
8010752b:	e8 c0 f9 ff ff       	call   80106ef0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107530:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107536:	eb 0f                	jmp    80107547 <freevm+0x37>
80107538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753f:	90                   	nop
80107540:	83 c3 04             	add    $0x4,%ebx
80107543:	39 df                	cmp    %ebx,%edi
80107545:	74 23                	je     8010756a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107547:	8b 03                	mov    (%ebx),%eax
80107549:	a8 01                	test   $0x1,%al
8010754b:	74 f3                	je     80107540 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010754d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107552:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107555:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107558:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010755d:	50                   	push   %eax
8010755e:	e8 5d af ff ff       	call   801024c0 <kfree>
80107563:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107566:	39 df                	cmp    %ebx,%edi
80107568:	75 dd                	jne    80107547 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010756a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010756d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107570:	5b                   	pop    %ebx
80107571:	5e                   	pop    %esi
80107572:	5f                   	pop    %edi
80107573:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107574:	e9 47 af ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107579:	83 ec 0c             	sub    $0xc,%esp
8010757c:	68 f9 83 10 80       	push   $0x801083f9
80107581:	e8 fa 8d ff ff       	call   80100380 <panic>
80107586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758d:	8d 76 00             	lea    0x0(%esi),%esi

80107590 <setupkvm>:
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	56                   	push   %esi
80107594:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107595:	e8 e6 b0 ff ff       	call   80102680 <kalloc>
8010759a:	89 c6                	mov    %eax,%esi
8010759c:	85 c0                	test   %eax,%eax
8010759e:	74 42                	je     801075e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801075a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075a8:	68 00 10 00 00       	push   $0x1000
801075ad:	6a 00                	push   $0x0
801075af:	50                   	push   %eax
801075b0:	e8 5b d7 ff ff       	call   80104d10 <memset>
801075b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075bb:	83 ec 08             	sub    $0x8,%esp
801075be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075c1:	ff 73 0c             	push   0xc(%ebx)
801075c4:	8b 13                	mov    (%ebx),%edx
801075c6:	50                   	push   %eax
801075c7:	29 c1                	sub    %eax,%ecx
801075c9:	89 f0                	mov    %esi,%eax
801075cb:	e8 d0 f9 ff ff       	call   80106fa0 <mappages>
801075d0:	83 c4 10             	add    $0x10,%esp
801075d3:	85 c0                	test   %eax,%eax
801075d5:	78 19                	js     801075f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075d7:	83 c3 10             	add    $0x10,%ebx
801075da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801075e0:	75 d6                	jne    801075b8 <setupkvm+0x28>
}
801075e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075e5:	89 f0                	mov    %esi,%eax
801075e7:	5b                   	pop    %ebx
801075e8:	5e                   	pop    %esi
801075e9:	5d                   	pop    %ebp
801075ea:	c3                   	ret    
801075eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075ef:	90                   	nop
      freevm(pgdir);
801075f0:	83 ec 0c             	sub    $0xc,%esp
801075f3:	56                   	push   %esi
      return 0;
801075f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801075f6:	e8 15 ff ff ff       	call   80107510 <freevm>
      return 0;
801075fb:	83 c4 10             	add    $0x10,%esp
}
801075fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107601:	89 f0                	mov    %esi,%eax
80107603:	5b                   	pop    %ebx
80107604:	5e                   	pop    %esi
80107605:	5d                   	pop    %ebp
80107606:	c3                   	ret    
80107607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760e:	66 90                	xchg   %ax,%ax

80107610 <kvmalloc>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107616:	e8 75 ff ff ff       	call   80107590 <setupkvm>
8010761b:	a3 c4 57 11 80       	mov    %eax,0x801157c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107620:	05 00 00 00 80       	add    $0x80000000,%eax
80107625:	0f 22 d8             	mov    %eax,%cr3
}
80107628:	c9                   	leave  
80107629:	c3                   	ret    
8010762a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107630 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	83 ec 08             	sub    $0x8,%esp
80107636:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107639:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010763c:	89 c1                	mov    %eax,%ecx
8010763e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107641:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107644:	f6 c2 01             	test   $0x1,%dl
80107647:	75 17                	jne    80107660 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107649:	83 ec 0c             	sub    $0xc,%esp
8010764c:	68 0a 84 10 80       	push   $0x8010840a
80107651:	e8 2a 8d ff ff       	call   80100380 <panic>
80107656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107660:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107663:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107669:	25 fc 0f 00 00       	and    $0xffc,%eax
8010766e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107675:	85 c0                	test   %eax,%eax
80107677:	74 d0                	je     80107649 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107679:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010767c:	c9                   	leave  
8010767d:	c3                   	ret    
8010767e:	66 90                	xchg   %ax,%ax

80107680 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	57                   	push   %edi
80107684:	56                   	push   %esi
80107685:	53                   	push   %ebx
80107686:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107689:	e8 02 ff ff ff       	call   80107590 <setupkvm>
8010768e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107691:	85 c0                	test   %eax,%eax
80107693:	0f 84 bd 00 00 00    	je     80107756 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010769c:	85 c9                	test   %ecx,%ecx
8010769e:	0f 84 b2 00 00 00    	je     80107756 <copyuvm+0xd6>
801076a4:	31 f6                	xor    %esi,%esi
801076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801076b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801076b3:	89 f0                	mov    %esi,%eax
801076b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801076b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801076bb:	a8 01                	test   $0x1,%al
801076bd:	75 11                	jne    801076d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076bf:	83 ec 0c             	sub    $0xc,%esp
801076c2:	68 14 84 10 80       	push   $0x80108414
801076c7:	e8 b4 8c ff ff       	call   80100380 <panic>
801076cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801076d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076d7:	c1 ea 0a             	shr    $0xa,%edx
801076da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801076e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076e7:	85 c0                	test   %eax,%eax
801076e9:	74 d4                	je     801076bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801076eb:	8b 00                	mov    (%eax),%eax
801076ed:	a8 01                	test   $0x1,%al
801076ef:	0f 84 9f 00 00 00    	je     80107794 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801076fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801076ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107705:	e8 76 af ff ff       	call   80102680 <kalloc>
8010770a:	89 c3                	mov    %eax,%ebx
8010770c:	85 c0                	test   %eax,%eax
8010770e:	74 64                	je     80107774 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107710:	83 ec 04             	sub    $0x4,%esp
80107713:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107719:	68 00 10 00 00       	push   $0x1000
8010771e:	57                   	push   %edi
8010771f:	50                   	push   %eax
80107720:	e8 8b d6 ff ff       	call   80104db0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107725:	58                   	pop    %eax
80107726:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010772c:	5a                   	pop    %edx
8010772d:	ff 75 e4             	push   -0x1c(%ebp)
80107730:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107735:	89 f2                	mov    %esi,%edx
80107737:	50                   	push   %eax
80107738:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010773b:	e8 60 f8 ff ff       	call   80106fa0 <mappages>
80107740:	83 c4 10             	add    $0x10,%esp
80107743:	85 c0                	test   %eax,%eax
80107745:	78 21                	js     80107768 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107747:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010774d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107750:	0f 87 5a ff ff ff    	ja     801076b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107756:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010775c:	5b                   	pop    %ebx
8010775d:	5e                   	pop    %esi
8010775e:	5f                   	pop    %edi
8010775f:	5d                   	pop    %ebp
80107760:	c3                   	ret    
80107761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107768:	83 ec 0c             	sub    $0xc,%esp
8010776b:	53                   	push   %ebx
8010776c:	e8 4f ad ff ff       	call   801024c0 <kfree>
      goto bad;
80107771:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107774:	83 ec 0c             	sub    $0xc,%esp
80107777:	ff 75 e0             	push   -0x20(%ebp)
8010777a:	e8 91 fd ff ff       	call   80107510 <freevm>
  return 0;
8010777f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107786:	83 c4 10             	add    $0x10,%esp
}
80107789:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010778c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778f:	5b                   	pop    %ebx
80107790:	5e                   	pop    %esi
80107791:	5f                   	pop    %edi
80107792:	5d                   	pop    %ebp
80107793:	c3                   	ret    
      panic("copyuvm: page not present");
80107794:	83 ec 0c             	sub    $0xc,%esp
80107797:	68 2e 84 10 80       	push   $0x8010842e
8010779c:	e8 df 8b ff ff       	call   80100380 <panic>
801077a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077af:	90                   	nop

801077b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801077b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801077b9:	89 c1                	mov    %eax,%ecx
801077bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801077be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801077c1:	f6 c2 01             	test   $0x1,%dl
801077c4:	0f 84 00 01 00 00    	je     801078ca <uva2ka.cold>
  return &pgtab[PTX(va)];
801077ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801077d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801077d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801077d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801077e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801077e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077ea:	05 00 00 00 80       	add    $0x80000000,%eax
801077ef:	83 fa 05             	cmp    $0x5,%edx
801077f2:	ba 00 00 00 00       	mov    $0x0,%edx
801077f7:	0f 45 c2             	cmovne %edx,%eax
}
801077fa:	c3                   	ret    
801077fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop

80107800 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	83 ec 0c             	sub    $0xc,%esp
80107809:	8b 75 14             	mov    0x14(%ebp),%esi
8010780c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010780f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107812:	85 f6                	test   %esi,%esi
80107814:	75 51                	jne    80107867 <copyout+0x67>
80107816:	e9 a5 00 00 00       	jmp    801078c0 <copyout+0xc0>
8010781b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010781f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107820:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107826:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010782c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107832:	74 75                	je     801078a9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107834:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107836:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107839:	29 c3                	sub    %eax,%ebx
8010783b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107841:	39 f3                	cmp    %esi,%ebx
80107843:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107846:	29 f8                	sub    %edi,%eax
80107848:	83 ec 04             	sub    $0x4,%esp
8010784b:	01 c1                	add    %eax,%ecx
8010784d:	53                   	push   %ebx
8010784e:	52                   	push   %edx
8010784f:	51                   	push   %ecx
80107850:	e8 5b d5 ff ff       	call   80104db0 <memmove>
    len -= n;
    buf += n;
80107855:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107858:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010785e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107861:	01 da                	add    %ebx,%edx
  while(len > 0){
80107863:	29 de                	sub    %ebx,%esi
80107865:	74 59                	je     801078c0 <copyout+0xc0>
  if(*pde & PTE_P){
80107867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010786a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010786c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010786e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107871:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107877:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010787a:	f6 c1 01             	test   $0x1,%cl
8010787d:	0f 84 4e 00 00 00    	je     801078d1 <copyout.cold>
  return &pgtab[PTX(va)];
80107883:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107885:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010788b:	c1 eb 0c             	shr    $0xc,%ebx
8010788e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107894:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010789b:	89 d9                	mov    %ebx,%ecx
8010789d:	83 e1 05             	and    $0x5,%ecx
801078a0:	83 f9 05             	cmp    $0x5,%ecx
801078a3:	0f 84 77 ff ff ff    	je     80107820 <copyout+0x20>
  }
  return 0;
}
801078a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078b1:	5b                   	pop    %ebx
801078b2:	5e                   	pop    %esi
801078b3:	5f                   	pop    %edi
801078b4:	5d                   	pop    %ebp
801078b5:	c3                   	ret    
801078b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078bd:	8d 76 00             	lea    0x0(%esi),%esi
801078c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078c3:	31 c0                	xor    %eax,%eax
}
801078c5:	5b                   	pop    %ebx
801078c6:	5e                   	pop    %esi
801078c7:	5f                   	pop    %edi
801078c8:	5d                   	pop    %ebp
801078c9:	c3                   	ret    

801078ca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801078ca:	a1 00 00 00 00       	mov    0x0,%eax
801078cf:	0f 0b                	ud2    

801078d1 <copyout.cold>:
801078d1:	a1 00 00 00 00       	mov    0x0,%eax
801078d6:	0f 0b                	ud2    
