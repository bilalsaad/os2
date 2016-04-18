
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc d0 d6 10 80       	mov    $0x8010d6d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 29 37 10 80       	mov    $0x80103729,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 24 92 10 	movl   $0x80109224,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 e0 d6 10 80 	movl   $0x8010d6e0,(%esp)
80100049:	e8 36 5b 00 00       	call   80105b84 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 f0 15 11 80 e4 	movl   $0x801115e4,0x801115f0
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 f4 15 11 80 e4 	movl   $0x801115e4,0x801115f4
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 14 d7 10 80 	movl   $0x8010d714,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 f4 15 11 80    	mov    0x801115f4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c e4 15 11 80 	movl   $0x801115e4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 f4 15 11 80       	mov    0x801115f4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 f4 15 11 80       	mov    %eax,0x801115f4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 e4 15 11 80 	cmpl   $0x801115e4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 e0 d6 10 80 	movl   $0x8010d6e0,(%esp)
801000bd:	e8 e3 5a 00 00       	call   80105ba5 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 f4 15 11 80       	mov    0x801115f4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 e0 d6 10 80 	movl   $0x8010d6e0,(%esp)
80100104:	e8 fe 5a 00 00       	call   80105c07 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 e0 d6 10 	movl   $0x8010d6e0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 b5 4f 00 00       	call   801050d9 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 e4 15 11 80 	cmpl   $0x801115e4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 f0 15 11 80       	mov    0x801115f0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 e0 d6 10 80 	movl   $0x8010d6e0,(%esp)
8010017c:	e8 86 5a 00 00       	call   80105c07 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 e4 15 11 80 	cmpl   $0x801115e4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 2b 92 10 80 	movl   $0x8010922b,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 db 25 00 00       	call   801027b3 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 3c 92 10 80 	movl   $0x8010923c,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 9e 25 00 00       	call   801027b3 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 43 92 10 80 	movl   $0x80109243,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 e0 d6 10 80 	movl   $0x8010d6e0,(%esp)
8010023c:	e8 64 59 00 00       	call   80105ba5 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 f4 15 11 80    	mov    0x801115f4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c e4 15 11 80 	movl   $0x801115e4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 f4 15 11 80       	mov    0x801115f4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 f4 15 11 80       	mov    %eax,0x801115f4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 7a 50 00 00       	call   8010531c <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 e0 d6 10 80 	movl   $0x8010d6e0,(%esp)
801002a9:	e8 59 59 00 00       	call   80105c07 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c6 03 00 00       	call   80100755 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801003bb:	e8 e5 57 00 00       	call   80105ba5 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 4a 92 10 80 	movl   $0x8010924a,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5f 03 00 00       	call   80100755 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 53 92 10 80 	movl   $0x80109253,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 89 02 00 00       	call   80100755 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 6d 02 00 00       	call   80100755 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5f 02 00 00       	call   80100755 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 54 02 00 00       	call   80100755 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100533:	e8 cf 56 00 00       	call   80105c07 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 74 c6 10 80 00 	movl   $0x0,0x8010c674
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 5a 92 10 80 	movl   $0x8010925a,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 69 92 10 80 	movl   $0x80109269,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  procdump();
80100582:	e8 3c 4e 00 00       	call   801053c3 <procdump>
  getcallerpcs(&s, pcs);
80100587:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010058a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010058e:	8d 45 08             	lea    0x8(%ebp),%eax
80100591:	89 04 24             	mov    %eax,(%esp)
80100594:	e8 bd 56 00 00       	call   80105c56 <getcallerpcs>
  for(i=0; i<10; i++)
80100599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005a0:	eb 1b                	jmp    801005bd <panic+0x83>
    cprintf(" %p", pcs[i]);
801005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a5:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ad:	c7 04 24 6b 92 10 80 	movl   $0x8010926b,(%esp)
801005b4:	e8 e7 fd ff ff       	call   801003a0 <cprintf>
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  procdump();
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bd:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005c1:	7e df                	jle    801005a2 <panic+0x68>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005c3:	c7 05 20 c6 10 80 01 	movl   $0x1,0x8010c620
801005ca:	00 00 00 
  for(;;)
    ;
801005cd:	eb fe                	jmp    801005cd <panic+0x93>

801005cf <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005cf:	55                   	push   %ebp
801005d0:	89 e5                	mov    %esp,%ebp
801005d2:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d5:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005dc:	00 
801005dd:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005e4:	e8 e4 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e9:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005f0:	e8 bb fc ff ff       	call   801002b0 <inb>
801005f5:	0f b6 c0             	movzbl %al,%eax
801005f8:	c1 e0 08             	shl    $0x8,%eax
801005fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005fe:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100605:	00 
80100606:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010060d:	e8 bb fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
80100612:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100619:	e8 92 fc ff ff       	call   801002b0 <inb>
8010061e:	0f b6 c0             	movzbl %al,%eax
80100621:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100624:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100628:	75 30                	jne    8010065a <cgaputc+0x8b>
    pos += 80 - pos%80;
8010062a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010062d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100632:	89 c8                	mov    %ecx,%eax
80100634:	f7 ea                	imul   %edx
80100636:	c1 fa 05             	sar    $0x5,%edx
80100639:	89 c8                	mov    %ecx,%eax
8010063b:	c1 f8 1f             	sar    $0x1f,%eax
8010063e:	29 c2                	sub    %eax,%edx
80100640:	89 d0                	mov    %edx,%eax
80100642:	c1 e0 02             	shl    $0x2,%eax
80100645:	01 d0                	add    %edx,%eax
80100647:	c1 e0 04             	shl    $0x4,%eax
8010064a:	29 c1                	sub    %eax,%ecx
8010064c:	89 ca                	mov    %ecx,%edx
8010064e:	b8 50 00 00 00       	mov    $0x50,%eax
80100653:	29 d0                	sub    %edx,%eax
80100655:	01 45 f4             	add    %eax,-0xc(%ebp)
80100658:	eb 35                	jmp    8010068f <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010065a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100661:	75 0c                	jne    8010066f <cgaputc+0xa0>
    if(pos > 0) --pos;
80100663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100667:	7e 26                	jle    8010068f <cgaputc+0xc0>
80100669:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010066d:	eb 20                	jmp    8010068f <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066f:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100678:	8d 50 01             	lea    0x1(%eax),%edx
8010067b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010067e:	01 c0                	add    %eax,%eax
80100680:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80100683:	8b 45 08             	mov    0x8(%ebp),%eax
80100686:	0f b6 c0             	movzbl %al,%eax
80100689:	80 cc 07             	or     $0x7,%ah
8010068c:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068f:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100696:	7e 53                	jle    801006eb <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100698:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010069d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006a3:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a8:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006af:	00 
801006b0:	89 54 24 04          	mov    %edx,0x4(%esp)
801006b4:	89 04 24             	mov    %eax,(%esp)
801006b7:	e8 0c 58 00 00       	call   80105ec8 <memmove>
    pos -= 80;
801006bc:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c0:	b8 80 07 00 00       	mov    $0x780,%eax
801006c5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c8:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006cb:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d3:	01 c9                	add    %ecx,%ecx
801006d5:	01 c8                	add    %ecx,%eax
801006d7:	89 54 24 08          	mov    %edx,0x8(%esp)
801006db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006e2:	00 
801006e3:	89 04 24             	mov    %eax,(%esp)
801006e6:	e8 0e 57 00 00       	call   80105df9 <memset>
  }
  
  outb(CRTPORT, 14);
801006eb:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006f2:	00 
801006f3:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006fa:	e8 ce fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100702:	c1 f8 08             	sar    $0x8,%eax
80100705:	0f b6 c0             	movzbl %al,%eax
80100708:	89 44 24 04          	mov    %eax,0x4(%esp)
8010070c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100713:	e8 b5 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100718:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071f:	00 
80100720:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100727:	e8 a1 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
8010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072f:	0f b6 c0             	movzbl %al,%eax
80100732:	89 44 24 04          	mov    %eax,0x4(%esp)
80100736:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010073d:	e8 8b fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
80100742:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100747:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010074a:	01 d2                	add    %edx,%edx
8010074c:	01 d0                	add    %edx,%eax
8010074e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100753:	c9                   	leave  
80100754:	c3                   	ret    

80100755 <consputc>:

void
consputc(int c)
{
80100755:	55                   	push   %ebp
80100756:	89 e5                	mov    %esp,%ebp
80100758:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010075b:	a1 20 c6 10 80       	mov    0x8010c620,%eax
80100760:	85 c0                	test   %eax,%eax
80100762:	74 07                	je     8010076b <consputc+0x16>
    cli();
80100764:	e8 82 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100769:	eb fe                	jmp    80100769 <consputc+0x14>
  }

  if(c == BACKSPACE){
8010076b:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100772:	75 26                	jne    8010079a <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100774:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010077b:	e8 e6 70 00 00       	call   80107866 <uartputc>
80100780:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100787:	e8 da 70 00 00       	call   80107866 <uartputc>
8010078c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100793:	e8 ce 70 00 00       	call   80107866 <uartputc>
80100798:	eb 0b                	jmp    801007a5 <consputc+0x50>
  } else
    uartputc(c);
8010079a:	8b 45 08             	mov    0x8(%ebp),%eax
8010079d:	89 04 24             	mov    %eax,(%esp)
801007a0:	e8 c1 70 00 00       	call   80107866 <uartputc>
  cgaputc(c);
801007a5:	8b 45 08             	mov    0x8(%ebp),%eax
801007a8:	89 04 24             	mov    %eax,(%esp)
801007ab:	e8 1f fe ff ff       	call   801005cf <cgaputc>
}
801007b0:	c9                   	leave  
801007b1:	c3                   	ret    

801007b2 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b2:	55                   	push   %ebp
801007b3:	89 e5                	mov    %esp,%ebp
801007b5:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b8:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
801007bf:	e8 e1 53 00 00       	call   80105ba5 <acquire>
  while((c = getc()) >= 0){
801007c4:	e9 37 01 00 00       	jmp    80100900 <consoleintr+0x14e>
    switch(c){
801007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	74 1e                	je     801007ef <consoleintr+0x3d>
801007d1:	83 f8 10             	cmp    $0x10,%eax
801007d4:	7f 0a                	jg     801007e0 <consoleintr+0x2e>
801007d6:	83 f8 08             	cmp    $0x8,%eax
801007d9:	74 64                	je     8010083f <consoleintr+0x8d>
801007db:	e9 91 00 00 00       	jmp    80100871 <consoleintr+0xbf>
801007e0:	83 f8 15             	cmp    $0x15,%eax
801007e3:	74 2f                	je     80100814 <consoleintr+0x62>
801007e5:	83 f8 7f             	cmp    $0x7f,%eax
801007e8:	74 55                	je     8010083f <consoleintr+0x8d>
801007ea:	e9 82 00 00 00       	jmp    80100871 <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ef:	e8 cf 4b 00 00       	call   801053c3 <procdump>
      break;
801007f4:	e9 07 01 00 00       	jmp    80100900 <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f9:	a1 bc 18 11 80       	mov    0x801118bc,%eax
801007fe:	83 e8 01             	sub    $0x1,%eax
80100801:	a3 bc 18 11 80       	mov    %eax,0x801118bc
        consputc(BACKSPACE);
80100806:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010080d:	e8 43 ff ff ff       	call   80100755 <consputc>
80100812:	eb 01                	jmp    80100815 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100814:	90                   	nop
80100815:	8b 15 bc 18 11 80    	mov    0x801118bc,%edx
8010081b:	a1 b8 18 11 80       	mov    0x801118b8,%eax
80100820:	39 c2                	cmp    %eax,%edx
80100822:	74 16                	je     8010083a <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100824:	a1 bc 18 11 80       	mov    0x801118bc,%eax
80100829:	83 e8 01             	sub    $0x1,%eax
8010082c:	83 e0 7f             	and    $0x7f,%eax
8010082f:	0f b6 80 34 18 11 80 	movzbl -0x7feee7cc(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100836:	3c 0a                	cmp    $0xa,%al
80100838:	75 bf                	jne    801007f9 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010083a:	e9 c1 00 00 00       	jmp    80100900 <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083f:	8b 15 bc 18 11 80    	mov    0x801118bc,%edx
80100845:	a1 b8 18 11 80       	mov    0x801118b8,%eax
8010084a:	39 c2                	cmp    %eax,%edx
8010084c:	74 1e                	je     8010086c <consoleintr+0xba>
        input.e--;
8010084e:	a1 bc 18 11 80       	mov    0x801118bc,%eax
80100853:	83 e8 01             	sub    $0x1,%eax
80100856:	a3 bc 18 11 80       	mov    %eax,0x801118bc
        consputc(BACKSPACE);
8010085b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100862:	e8 ee fe ff ff       	call   80100755 <consputc>
      }
      break;
80100867:	e9 94 00 00 00       	jmp    80100900 <consoleintr+0x14e>
8010086c:	e9 8f 00 00 00       	jmp    80100900 <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100875:	0f 84 84 00 00 00    	je     801008ff <consoleintr+0x14d>
8010087b:	8b 15 bc 18 11 80    	mov    0x801118bc,%edx
80100881:	a1 b4 18 11 80       	mov    0x801118b4,%eax
80100886:	29 c2                	sub    %eax,%edx
80100888:	89 d0                	mov    %edx,%eax
8010088a:	83 f8 7f             	cmp    $0x7f,%eax
8010088d:	77 70                	ja     801008ff <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088f:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80100893:	74 05                	je     8010089a <consoleintr+0xe8>
80100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100898:	eb 05                	jmp    8010089f <consoleintr+0xed>
8010089a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a2:	a1 bc 18 11 80       	mov    0x801118bc,%eax
801008a7:	8d 50 01             	lea    0x1(%eax),%edx
801008aa:	89 15 bc 18 11 80    	mov    %edx,0x801118bc
801008b0:	83 e0 7f             	and    $0x7f,%eax
801008b3:	89 c2                	mov    %eax,%edx
801008b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b8:	88 82 34 18 11 80    	mov    %al,-0x7feee7cc(%edx)
        consputc(c);
801008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c1:	89 04 24             	mov    %eax,(%esp)
801008c4:	e8 8c fe ff ff       	call   80100755 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c9:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008cd:	74 18                	je     801008e7 <consoleintr+0x135>
801008cf:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008d3:	74 12                	je     801008e7 <consoleintr+0x135>
801008d5:	a1 bc 18 11 80       	mov    0x801118bc,%eax
801008da:	8b 15 b4 18 11 80    	mov    0x801118b4,%edx
801008e0:	83 ea 80             	sub    $0xffffff80,%edx
801008e3:	39 d0                	cmp    %edx,%eax
801008e5:	75 18                	jne    801008ff <consoleintr+0x14d>
          input.w = input.e;
801008e7:	a1 bc 18 11 80       	mov    0x801118bc,%eax
801008ec:	a3 b8 18 11 80       	mov    %eax,0x801118b8
          wakeup(&input.r);
801008f1:	c7 04 24 b4 18 11 80 	movl   $0x801118b4,(%esp)
801008f8:	e8 1f 4a 00 00       	call   8010531c <wakeup>
        }
      }
      break;
801008fd:	eb 00                	jmp    801008ff <consoleintr+0x14d>
801008ff:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100900:	8b 45 08             	mov    0x8(%ebp),%eax
80100903:	ff d0                	call   *%eax
80100905:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010090c:	0f 89 b7 fe ff ff    	jns    801007c9 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100912:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80100919:	e8 e9 52 00 00       	call   80105c07 <release>
}
8010091e:	c9                   	leave  
8010091f:	c3                   	ret    

80100920 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100926:	8b 45 08             	mov    0x8(%ebp),%eax
80100929:	89 04 24             	mov    %eax,(%esp)
8010092c:	e8 8a 10 00 00       	call   801019bb <iunlock>
  target = n;
80100931:	8b 45 10             	mov    0x10(%ebp),%eax
80100934:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100937:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
8010093e:	e8 62 52 00 00       	call   80105ba5 <acquire>
  while(n > 0){
80100943:	e9 aa 00 00 00       	jmp    801009f2 <consoleread+0xd2>
    while(input.r == input.w){
80100948:	eb 42                	jmp    8010098c <consoleread+0x6c>
      if(proc->killed){
8010094a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100950:	8b 40 24             	mov    0x24(%eax),%eax
80100953:	85 c0                	test   %eax,%eax
80100955:	74 21                	je     80100978 <consoleread+0x58>
        release(&input.lock);
80100957:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
8010095e:	e8 a4 52 00 00       	call   80105c07 <release>
        ilock(ip);
80100963:	8b 45 08             	mov    0x8(%ebp),%eax
80100966:	89 04 24             	mov    %eax,(%esp)
80100969:	e8 ff 0e 00 00       	call   8010186d <ilock>
        return -1;
8010096e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100973:	e9 a5 00 00 00       	jmp    80100a1d <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100978:	c7 44 24 04 00 18 11 	movl   $0x80111800,0x4(%esp)
8010097f:	80 
80100980:	c7 04 24 b4 18 11 80 	movl   $0x801118b4,(%esp)
80100987:	e8 4d 47 00 00       	call   801050d9 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010098c:	8b 15 b4 18 11 80    	mov    0x801118b4,%edx
80100992:	a1 b8 18 11 80       	mov    0x801118b8,%eax
80100997:	39 c2                	cmp    %eax,%edx
80100999:	74 af                	je     8010094a <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010099b:	a1 b4 18 11 80       	mov    0x801118b4,%eax
801009a0:	8d 50 01             	lea    0x1(%eax),%edx
801009a3:	89 15 b4 18 11 80    	mov    %edx,0x801118b4
801009a9:	83 e0 7f             	and    $0x7f,%eax
801009ac:	0f b6 80 34 18 11 80 	movzbl -0x7feee7cc(%eax),%eax
801009b3:	0f be c0             	movsbl %al,%eax
801009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009bd:	75 19                	jne    801009d8 <consoleread+0xb8>
      if(n < target){
801009bf:	8b 45 10             	mov    0x10(%ebp),%eax
801009c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c5:	73 0f                	jae    801009d6 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c7:	a1 b4 18 11 80       	mov    0x801118b4,%eax
801009cc:	83 e8 01             	sub    $0x1,%eax
801009cf:	a3 b4 18 11 80       	mov    %eax,0x801118b4
      }
      break;
801009d4:	eb 26                	jmp    801009fc <consoleread+0xdc>
801009d6:	eb 24                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
801009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801009db:	8d 50 01             	lea    0x1(%eax),%edx
801009de:	89 55 0c             	mov    %edx,0xc(%ebp)
801009e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009e4:	88 10                	mov    %dl,(%eax)
    --n;
801009e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009ea:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009ee:	75 02                	jne    801009f2 <consoleread+0xd2>
      break;
801009f0:	eb 0a                	jmp    801009fc <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f6:	0f 8f 4c ff ff ff    	jg     80100948 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009fc:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80100a03:	e8 ff 51 00 00       	call   80105c07 <release>
  ilock(ip);
80100a08:	8b 45 08             	mov    0x8(%ebp),%eax
80100a0b:	89 04 24             	mov    %eax,(%esp)
80100a0e:	e8 5a 0e 00 00       	call   8010186d <ilock>

  return target - n;
80100a13:	8b 45 10             	mov    0x10(%ebp),%eax
80100a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a19:	29 c2                	sub    %eax,%edx
80100a1b:	89 d0                	mov    %edx,%eax
}
80100a1d:	c9                   	leave  
80100a1e:	c3                   	ret    

80100a1f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1f:	55                   	push   %ebp
80100a20:	89 e5                	mov    %esp,%ebp
80100a22:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a25:	8b 45 08             	mov    0x8(%ebp),%eax
80100a28:	89 04 24             	mov    %eax,(%esp)
80100a2b:	e8 8b 0f 00 00       	call   801019bb <iunlock>
  acquire(&cons.lock);
80100a30:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100a37:	e8 69 51 00 00       	call   80105ba5 <acquire>
  for(i = 0; i < n; i++)
80100a3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a43:	eb 1d                	jmp    80100a62 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a48:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a4b:	01 d0                	add    %edx,%eax
80100a4d:	0f b6 00             	movzbl (%eax),%eax
80100a50:	0f be c0             	movsbl %al,%eax
80100a53:	0f b6 c0             	movzbl %al,%eax
80100a56:	89 04 24             	mov    %eax,(%esp)
80100a59:	e8 f7 fc ff ff       	call   80100755 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a5e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a65:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a68:	7c db                	jl     80100a45 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a6a:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100a71:	e8 91 51 00 00       	call   80105c07 <release>
  ilock(ip);
80100a76:	8b 45 08             	mov    0x8(%ebp),%eax
80100a79:	89 04 24             	mov    %eax,(%esp)
80100a7c:	e8 ec 0d 00 00       	call   8010186d <ilock>

  return n;
80100a81:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a84:	c9                   	leave  
80100a85:	c3                   	ret    

80100a86 <consoleinit>:

void
consoleinit(void)
{
80100a86:	55                   	push   %ebp
80100a87:	89 e5                	mov    %esp,%ebp
80100a89:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a8c:	c7 44 24 04 6f 92 10 	movl   $0x8010926f,0x4(%esp)
80100a93:	80 
80100a94:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100a9b:	e8 e4 50 00 00       	call   80105b84 <initlock>
  initlock(&input.lock, "input");
80100aa0:	c7 44 24 04 77 92 10 	movl   $0x80109277,0x4(%esp)
80100aa7:	80 
80100aa8:	c7 04 24 00 18 11 80 	movl   $0x80111800,(%esp)
80100aaf:	e8 d0 50 00 00       	call   80105b84 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab4:	c7 05 6c 22 11 80 1f 	movl   $0x80100a1f,0x8011226c
80100abb:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100abe:	c7 05 68 22 11 80 20 	movl   $0x80100920,0x80112268
80100ac5:	09 10 80 
  cons.locking = 1;
80100ac8:	c7 05 74 c6 10 80 01 	movl   $0x1,0x8010c674
80100acf:	00 00 00 

  picenable(IRQ_KBD);
80100ad2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad9:	e8 e8 32 00 00       	call   80103dc6 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ade:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae5:	00 
80100ae6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aed:	e8 7d 1e 00 00       	call   8010296f <ioapicenable>
}
80100af2:	c9                   	leave  
80100af3:	c3                   	ret    

80100af4 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af4:	55                   	push   %ebp
80100af5:	89 e5                	mov    %esp,%ebp
80100af7:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100afd:	e8 20 29 00 00       	call   80103422 <begin_op>
  if((ip = namei(path)) == 0){
80100b02:	8b 45 08             	mov    0x8(%ebp),%eax
80100b05:	89 04 24             	mov    %eax,(%esp)
80100b08:	e8 0b 19 00 00       	call   80102418 <namei>
80100b0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b10:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b14:	75 0f                	jne    80100b25 <exec+0x31>
    end_op();
80100b16:	e8 8b 29 00 00       	call   801034a6 <end_op>
    return -1;
80100b1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b20:	e9 f5 03 00 00       	jmp    80100f1a <exec+0x426>
  }
  ilock(ip);
80100b25:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b28:	89 04 24             	mov    %eax,(%esp)
80100b2b:	e8 3d 0d 00 00       	call   8010186d <ilock>
  pgdir = 0;
80100b30:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b37:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3e:	00 
80100b3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b46:	00 
80100b47:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b51:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b54:	89 04 24             	mov    %eax,(%esp)
80100b57:	e8 1e 12 00 00       	call   80101d7a <readi>
80100b5c:	83 f8 33             	cmp    $0x33,%eax
80100b5f:	77 05                	ja     80100b66 <exec+0x72>
    goto bad;
80100b61:	e9 88 03 00 00       	jmp    80100eee <exec+0x3fa>
  if(elf.magic != ELF_MAGIC)
80100b66:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b6c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b71:	74 05                	je     80100b78 <exec+0x84>
    goto bad;
80100b73:	e9 76 03 00 00       	jmp    80100eee <exec+0x3fa>

  if((pgdir = setupkvm()) == 0)
80100b78:	e8 3a 7e 00 00       	call   801089b7 <setupkvm>
80100b7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b80:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b84:	75 05                	jne    80100b8b <exec+0x97>
    goto bad;
80100b86:	e9 63 03 00 00       	jmp    80100eee <exec+0x3fa>

  // Load program into memory.
  sz = 0;
80100b8b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b92:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b99:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba2:	e9 cb 00 00 00       	jmp    80100c72 <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100baa:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb1:	00 
80100bb2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb6:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bc3:	89 04 24             	mov    %eax,(%esp)
80100bc6:	e8 af 11 00 00       	call   80101d7a <readi>
80100bcb:	83 f8 20             	cmp    $0x20,%eax
80100bce:	74 05                	je     80100bd5 <exec+0xe1>
      goto bad;
80100bd0:	e9 19 03 00 00       	jmp    80100eee <exec+0x3fa>
    if(ph.type != ELF_PROG_LOAD)
80100bd5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bdb:	83 f8 01             	cmp    $0x1,%eax
80100bde:	74 05                	je     80100be5 <exec+0xf1>
      continue;
80100be0:	e9 80 00 00 00       	jmp    80100c65 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be5:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100beb:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bf1:	39 c2                	cmp    %eax,%edx
80100bf3:	73 05                	jae    80100bfa <exec+0x106>
      goto bad;
80100bf5:	e9 f4 02 00 00       	jmp    80100eee <exec+0x3fa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bfa:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c00:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c06:	01 d0                	add    %edx,%eax
80100c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 67 81 00 00       	call   80108d85 <allocuvm>
80100c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c25:	75 05                	jne    80100c2c <exec+0x138>
      goto bad;
80100c27:	e9 c2 02 00 00       	jmp    80100eee <exec+0x3fa>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c2c:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c38:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c42:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c46:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c49:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c54:	89 04 24             	mov    %eax,(%esp)
80100c57:	e8 3e 80 00 00       	call   80108c9a <loaduvm>
80100c5c:	85 c0                	test   %eax,%eax
80100c5e:	79 05                	jns    80100c65 <exec+0x171>
      goto bad;
80100c60:	e9 89 02 00 00       	jmp    80100eee <exec+0x3fa>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c65:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c6c:	83 c0 20             	add    $0x20,%eax
80100c6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c72:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c79:	0f b7 c0             	movzwl %ax,%eax
80100c7c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7f:	0f 8f 22 ff ff ff    	jg     80100ba7 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c85:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c88:	89 04 24             	mov    %eax,(%esp)
80100c8b:	e8 61 0e 00 00       	call   80101af1 <iunlockput>
  end_op();
80100c90:	e8 11 28 00 00       	call   801034a6 <end_op>
  ip = 0;
80100c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9f:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100caf:	05 00 20 00 00       	add    $0x2000,%eax
80100cb4:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc2:	89 04 24             	mov    %eax,(%esp)
80100cc5:	e8 bb 80 00 00       	call   80108d85 <allocuvm>
80100cca:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ccd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cd1:	75 05                	jne    80100cd8 <exec+0x1e4>
    goto bad;
80100cd3:	e9 16 02 00 00       	jmp    80100eee <exec+0x3fa>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cdb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce7:	89 04 24             	mov    %eax,(%esp)
80100cea:	e8 c6 82 00 00       	call   80108fb5 <clearpteu>
  sp = sz;
80100cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf2:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cfc:	e9 9a 00 00 00       	jmp    80100d9b <exec+0x2a7>
    if(argc >= MAXARG)
80100d01:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d05:	76 05                	jbe    80100d0c <exec+0x218>
      goto bad;
80100d07:	e9 e2 01 00 00       	jmp    80100eee <exec+0x3fa>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d16:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d19:	01 d0                	add    %edx,%eax
80100d1b:	8b 00                	mov    (%eax),%eax
80100d1d:	89 04 24             	mov    %eax,(%esp)
80100d20:	e8 3e 53 00 00       	call   80106063 <strlen>
80100d25:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d28:	29 c2                	sub    %eax,%edx
80100d2a:	89 d0                	mov    %edx,%eax
80100d2c:	83 e8 01             	sub    $0x1,%eax
80100d2f:	83 e0 fc             	and    $0xfffffffc,%eax
80100d32:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d42:	01 d0                	add    %edx,%eax
80100d44:	8b 00                	mov    (%eax),%eax
80100d46:	89 04 24             	mov    %eax,(%esp)
80100d49:	e8 15 53 00 00       	call   80106063 <strlen>
80100d4e:	83 c0 01             	add    $0x1,%eax
80100d51:	89 c2                	mov    %eax,%edx
80100d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d56:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d60:	01 c8                	add    %ecx,%eax
80100d62:	8b 00                	mov    (%eax),%eax
80100d64:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d68:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d76:	89 04 24             	mov    %eax,(%esp)
80100d79:	e8 fc 83 00 00       	call   8010917a <copyout>
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	79 05                	jns    80100d87 <exec+0x293>
      goto bad;
80100d82:	e9 67 01 00 00       	jmp    80100eee <exec+0x3fa>
    ustack[3+argc] = sp;
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 50 03             	lea    0x3(%eax),%edx
80100d8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d90:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d97:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da8:	01 d0                	add    %edx,%eax
80100daa:	8b 00                	mov    (%eax),%eax
80100dac:	85 c0                	test   %eax,%eax
80100dae:	0f 85 4d ff ff ff    	jne    80100d01 <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db7:	83 c0 03             	add    $0x3,%eax
80100dba:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dc1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dcc:	ff ff ff 
  ustack[1] = argc;
80100dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ddb:	83 c0 01             	add    $0x1,%eax
80100dde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de8:	29 d0                	sub    %edx,%eax
80100dea:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df3:	83 c0 04             	add    $0x4,%eax
80100df6:	c1 e0 02             	shl    $0x2,%eax
80100df9:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dff:	83 c0 04             	add    $0x4,%eax
80100e02:	c1 e0 02             	shl    $0x2,%eax
80100e05:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e09:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0f:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e1d:	89 04 24             	mov    %eax,(%esp)
80100e20:	e8 55 83 00 00       	call   8010917a <copyout>
80100e25:	85 c0                	test   %eax,%eax
80100e27:	79 05                	jns    80100e2e <exec+0x33a>
    goto bad;
80100e29:	e9 c0 00 00 00       	jmp    80100eee <exec+0x3fa>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e3a:	eb 17                	jmp    80100e53 <exec+0x35f>
    if(*s == '/')
80100e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3f:	0f b6 00             	movzbl (%eax),%eax
80100e42:	3c 2f                	cmp    $0x2f,%al
80100e44:	75 09                	jne    80100e4f <exec+0x35b>
      last = s+1;
80100e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e49:	83 c0 01             	add    $0x1,%eax
80100e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e56:	0f b6 00             	movzbl (%eax),%eax
80100e59:	84 c0                	test   %al,%al
80100e5b:	75 df                	jne    80100e3c <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e63:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e66:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e6d:	00 
80100e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e71:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e75:	89 14 24             	mov    %edx,(%esp)
80100e78:	e8 9c 51 00 00       	call   80106019 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e83:	8b 40 04             	mov    0x4(%eax),%eax
80100e86:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e92:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e9e:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ea0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea6:	8b 40 18             	mov    0x18(%eax),%eax
80100ea9:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eaf:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb8:	8b 40 18             	mov    0x18(%eax),%eax
80100ebb:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ebe:	89 50 44             	mov    %edx,0x44(%eax)
  // CODE FOR SIGNALS - the exec call should reset the handler to be default -1
  proc->sig_handler = DEFAULT_HANDLER;
80100ec1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec7:	c7 40 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%eax)
  switchuvm(proc);
80100ece:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed4:	89 04 24             	mov    %eax,(%esp)
80100ed7:	e8 cc 7b 00 00       	call   80108aa8 <switchuvm>
  freevm(oldpgdir);
80100edc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100edf:	89 04 24             	mov    %eax,(%esp)
80100ee2:	e8 34 80 00 00       	call   80108f1b <freevm>
  return 0;
80100ee7:	b8 00 00 00 00       	mov    $0x0,%eax
80100eec:	eb 2c                	jmp    80100f1a <exec+0x426>

 bad:
  if(pgdir)
80100eee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ef2:	74 0b                	je     80100eff <exec+0x40b>
    freevm(pgdir);
80100ef4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ef7:	89 04 24             	mov    %eax,(%esp)
80100efa:	e8 1c 80 00 00       	call   80108f1b <freevm>
  if(ip){
80100eff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f03:	74 10                	je     80100f15 <exec+0x421>
    iunlockput(ip);
80100f05:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f08:	89 04 24             	mov    %eax,(%esp)
80100f0b:	e8 e1 0b 00 00       	call   80101af1 <iunlockput>
    end_op();
80100f10:	e8 91 25 00 00       	call   801034a6 <end_op>
  }
  return -1;
80100f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f1a:	c9                   	leave  
80100f1b:	c3                   	ret    

80100f1c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f1c:	55                   	push   %ebp
80100f1d:	89 e5                	mov    %esp,%ebp
80100f1f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f22:	c7 44 24 04 7d 92 10 	movl   $0x8010927d,0x4(%esp)
80100f29:	80 
80100f2a:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100f31:	e8 4e 4c 00 00       	call   80105b84 <initlock>
}
80100f36:	c9                   	leave  
80100f37:	c3                   	ret    

80100f38 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f38:	55                   	push   %ebp
80100f39:	89 e5                	mov    %esp,%ebp
80100f3b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f3e:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100f45:	e8 5b 4c 00 00       	call   80105ba5 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f4a:	c7 45 f4 f4 18 11 80 	movl   $0x801118f4,-0xc(%ebp)
80100f51:	eb 29                	jmp    80100f7c <filealloc+0x44>
    if(f->ref == 0){
80100f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f56:	8b 40 04             	mov    0x4(%eax),%eax
80100f59:	85 c0                	test   %eax,%eax
80100f5b:	75 1b                	jne    80100f78 <filealloc+0x40>
      f->ref = 1;
80100f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f60:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f67:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100f6e:	e8 94 4c 00 00       	call   80105c07 <release>
      return f;
80100f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f76:	eb 1e                	jmp    80100f96 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f78:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f7c:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
80100f83:	72 ce                	jb     80100f53 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f85:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100f8c:	e8 76 4c 00 00       	call   80105c07 <release>
  return 0;
80100f91:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f96:	c9                   	leave  
80100f97:	c3                   	ret    

80100f98 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f98:	55                   	push   %ebp
80100f99:	89 e5                	mov    %esp,%ebp
80100f9b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f9e:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100fa5:	e8 fb 4b 00 00       	call   80105ba5 <acquire>
  if(f->ref < 1)
80100faa:	8b 45 08             	mov    0x8(%ebp),%eax
80100fad:	8b 40 04             	mov    0x4(%eax),%eax
80100fb0:	85 c0                	test   %eax,%eax
80100fb2:	7f 0c                	jg     80100fc0 <filedup+0x28>
    panic("filedup");
80100fb4:	c7 04 24 84 92 10 80 	movl   $0x80109284,(%esp)
80100fbb:	e8 7a f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc3:	8b 40 04             	mov    0x4(%eax),%eax
80100fc6:	8d 50 01             	lea    0x1(%eax),%edx
80100fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fcc:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fcf:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100fd6:	e8 2c 4c 00 00       	call   80105c07 <release>
  return f;
80100fdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fde:	c9                   	leave  
80100fdf:	c3                   	ret    

80100fe0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fe6:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80100fed:	e8 b3 4b 00 00       	call   80105ba5 <acquire>
  if(f->ref < 1)
80100ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff5:	8b 40 04             	mov    0x4(%eax),%eax
80100ff8:	85 c0                	test   %eax,%eax
80100ffa:	7f 0c                	jg     80101008 <fileclose+0x28>
    panic("fileclose");
80100ffc:	c7 04 24 8c 92 10 80 	movl   $0x8010928c,(%esp)
80101003:	e8 32 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101008:	8b 45 08             	mov    0x8(%ebp),%eax
8010100b:	8b 40 04             	mov    0x4(%eax),%eax
8010100e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101011:	8b 45 08             	mov    0x8(%ebp),%eax
80101014:	89 50 04             	mov    %edx,0x4(%eax)
80101017:	8b 45 08             	mov    0x8(%ebp),%eax
8010101a:	8b 40 04             	mov    0x4(%eax),%eax
8010101d:	85 c0                	test   %eax,%eax
8010101f:	7e 11                	jle    80101032 <fileclose+0x52>
    release(&ftable.lock);
80101021:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80101028:	e8 da 4b 00 00       	call   80105c07 <release>
8010102d:	e9 82 00 00 00       	jmp    801010b4 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101032:	8b 45 08             	mov    0x8(%ebp),%eax
80101035:	8b 10                	mov    (%eax),%edx
80101037:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010103a:	8b 50 04             	mov    0x4(%eax),%edx
8010103d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101040:	8b 50 08             	mov    0x8(%eax),%edx
80101043:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101046:	8b 50 0c             	mov    0xc(%eax),%edx
80101049:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010104c:	8b 50 10             	mov    0x10(%eax),%edx
8010104f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101052:	8b 40 14             	mov    0x14(%eax),%eax
80101055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101058:	8b 45 08             	mov    0x8(%ebp),%eax
8010105b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101062:	8b 45 08             	mov    0x8(%ebp),%eax
80101065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010106b:	c7 04 24 c0 18 11 80 	movl   $0x801118c0,(%esp)
80101072:	e8 90 4b 00 00       	call   80105c07 <release>
  
  if(ff.type == FD_PIPE)
80101077:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107a:	83 f8 01             	cmp    $0x1,%eax
8010107d:	75 18                	jne    80101097 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010107f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101083:	0f be d0             	movsbl %al,%edx
80101086:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101089:	89 54 24 04          	mov    %edx,0x4(%esp)
8010108d:	89 04 24             	mov    %eax,(%esp)
80101090:	e8 e1 2f 00 00       	call   80104076 <pipeclose>
80101095:	eb 1d                	jmp    801010b4 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101097:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109a:	83 f8 02             	cmp    $0x2,%eax
8010109d:	75 15                	jne    801010b4 <fileclose+0xd4>
    begin_op();
8010109f:	e8 7e 23 00 00       	call   80103422 <begin_op>
    iput(ff.ip);
801010a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010a7:	89 04 24             	mov    %eax,(%esp)
801010aa:	e8 71 09 00 00       	call   80101a20 <iput>
    end_op();
801010af:	e8 f2 23 00 00       	call   801034a6 <end_op>
  }
}
801010b4:	c9                   	leave  
801010b5:	c3                   	ret    

801010b6 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010b6:	55                   	push   %ebp
801010b7:	89 e5                	mov    %esp,%ebp
801010b9:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010bc:	8b 45 08             	mov    0x8(%ebp),%eax
801010bf:	8b 00                	mov    (%eax),%eax
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	75 38                	jne    801010fe <filestat+0x48>
    ilock(f->ip);
801010c6:	8b 45 08             	mov    0x8(%ebp),%eax
801010c9:	8b 40 10             	mov    0x10(%eax),%eax
801010cc:	89 04 24             	mov    %eax,(%esp)
801010cf:	e8 99 07 00 00       	call   8010186d <ilock>
    stati(f->ip, st);
801010d4:	8b 45 08             	mov    0x8(%ebp),%eax
801010d7:	8b 40 10             	mov    0x10(%eax),%eax
801010da:	8b 55 0c             	mov    0xc(%ebp),%edx
801010dd:	89 54 24 04          	mov    %edx,0x4(%esp)
801010e1:	89 04 24             	mov    %eax,(%esp)
801010e4:	e8 4c 0c 00 00       	call   80101d35 <stati>
    iunlock(f->ip);
801010e9:	8b 45 08             	mov    0x8(%ebp),%eax
801010ec:	8b 40 10             	mov    0x10(%eax),%eax
801010ef:	89 04 24             	mov    %eax,(%esp)
801010f2:	e8 c4 08 00 00       	call   801019bb <iunlock>
    return 0;
801010f7:	b8 00 00 00 00       	mov    $0x0,%eax
801010fc:	eb 05                	jmp    80101103 <filestat+0x4d>
  }
  return -1;
801010fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101103:	c9                   	leave  
80101104:	c3                   	ret    

80101105 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101105:	55                   	push   %ebp
80101106:	89 e5                	mov    %esp,%ebp
80101108:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010110b:	8b 45 08             	mov    0x8(%ebp),%eax
8010110e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101112:	84 c0                	test   %al,%al
80101114:	75 0a                	jne    80101120 <fileread+0x1b>
    return -1;
80101116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010111b:	e9 9f 00 00 00       	jmp    801011bf <fileread+0xba>
  if(f->type == FD_PIPE)
80101120:	8b 45 08             	mov    0x8(%ebp),%eax
80101123:	8b 00                	mov    (%eax),%eax
80101125:	83 f8 01             	cmp    $0x1,%eax
80101128:	75 1e                	jne    80101148 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010112a:	8b 45 08             	mov    0x8(%ebp),%eax
8010112d:	8b 40 0c             	mov    0xc(%eax),%eax
80101130:	8b 55 10             	mov    0x10(%ebp),%edx
80101133:	89 54 24 08          	mov    %edx,0x8(%esp)
80101137:	8b 55 0c             	mov    0xc(%ebp),%edx
8010113a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010113e:	89 04 24             	mov    %eax,(%esp)
80101141:	e8 b1 30 00 00       	call   801041f7 <piperead>
80101146:	eb 77                	jmp    801011bf <fileread+0xba>
  if(f->type == FD_INODE){
80101148:	8b 45 08             	mov    0x8(%ebp),%eax
8010114b:	8b 00                	mov    (%eax),%eax
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	75 61                	jne    801011b3 <fileread+0xae>
    ilock(f->ip);
80101152:	8b 45 08             	mov    0x8(%ebp),%eax
80101155:	8b 40 10             	mov    0x10(%eax),%eax
80101158:	89 04 24             	mov    %eax,(%esp)
8010115b:	e8 0d 07 00 00       	call   8010186d <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101160:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	8b 50 14             	mov    0x14(%eax),%edx
80101169:	8b 45 08             	mov    0x8(%ebp),%eax
8010116c:	8b 40 10             	mov    0x10(%eax),%eax
8010116f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101173:	89 54 24 08          	mov    %edx,0x8(%esp)
80101177:	8b 55 0c             	mov    0xc(%ebp),%edx
8010117a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010117e:	89 04 24             	mov    %eax,(%esp)
80101181:	e8 f4 0b 00 00       	call   80101d7a <readi>
80101186:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101189:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010118d:	7e 11                	jle    801011a0 <fileread+0x9b>
      f->off += r;
8010118f:	8b 45 08             	mov    0x8(%ebp),%eax
80101192:	8b 50 14             	mov    0x14(%eax),%edx
80101195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101198:	01 c2                	add    %eax,%edx
8010119a:	8b 45 08             	mov    0x8(%ebp),%eax
8010119d:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 40 10             	mov    0x10(%eax),%eax
801011a6:	89 04 24             	mov    %eax,(%esp)
801011a9:	e8 0d 08 00 00       	call   801019bb <iunlock>
    return r;
801011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011b1:	eb 0c                	jmp    801011bf <fileread+0xba>
  }
  panic("fileread");
801011b3:	c7 04 24 96 92 10 80 	movl   $0x80109296,(%esp)
801011ba:	e8 7b f3 ff ff       	call   8010053a <panic>
}
801011bf:	c9                   	leave  
801011c0:	c3                   	ret    

801011c1 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c1:	55                   	push   %ebp
801011c2:	89 e5                	mov    %esp,%ebp
801011c4:	53                   	push   %ebx
801011c5:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011cf:	84 c0                	test   %al,%al
801011d1:	75 0a                	jne    801011dd <filewrite+0x1c>
    return -1;
801011d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d8:	e9 20 01 00 00       	jmp    801012fd <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 00                	mov    (%eax),%eax
801011e2:	83 f8 01             	cmp    $0x1,%eax
801011e5:	75 21                	jne    80101208 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 40 0c             	mov    0xc(%eax),%eax
801011ed:	8b 55 10             	mov    0x10(%ebp),%edx
801011f0:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801011f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801011fb:	89 04 24             	mov    %eax,(%esp)
801011fe:	e8 05 2f 00 00       	call   80104108 <pipewrite>
80101203:	e9 f5 00 00 00       	jmp    801012fd <filewrite+0x13c>
  if(f->type == FD_INODE){
80101208:	8b 45 08             	mov    0x8(%ebp),%eax
8010120b:	8b 00                	mov    (%eax),%eax
8010120d:	83 f8 02             	cmp    $0x2,%eax
80101210:	0f 85 db 00 00 00    	jne    801012f1 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101216:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010121d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101224:	e9 a8 00 00 00       	jmp    801012d1 <filewrite+0x110>
      int n1 = n - i;
80101229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010122c:	8b 55 10             	mov    0x10(%ebp),%edx
8010122f:	29 c2                	sub    %eax,%edx
80101231:	89 d0                	mov    %edx,%eax
80101233:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101236:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101239:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010123c:	7e 06                	jle    80101244 <filewrite+0x83>
        n1 = max;
8010123e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101241:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101244:	e8 d9 21 00 00       	call   80103422 <begin_op>
      ilock(f->ip);
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 40 10             	mov    0x10(%eax),%eax
8010124f:	89 04 24             	mov    %eax,(%esp)
80101252:	e8 16 06 00 00       	call   8010186d <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101257:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010125a:	8b 45 08             	mov    0x8(%ebp),%eax
8010125d:	8b 50 14             	mov    0x14(%eax),%edx
80101260:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101263:	8b 45 0c             	mov    0xc(%ebp),%eax
80101266:	01 c3                	add    %eax,%ebx
80101268:	8b 45 08             	mov    0x8(%ebp),%eax
8010126b:	8b 40 10             	mov    0x10(%eax),%eax
8010126e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101272:	89 54 24 08          	mov    %edx,0x8(%esp)
80101276:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010127a:	89 04 24             	mov    %eax,(%esp)
8010127d:	e8 5c 0c 00 00       	call   80101ede <writei>
80101282:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101285:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101289:	7e 11                	jle    8010129c <filewrite+0xdb>
        f->off += r;
8010128b:	8b 45 08             	mov    0x8(%ebp),%eax
8010128e:	8b 50 14             	mov    0x14(%eax),%edx
80101291:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101294:	01 c2                	add    %eax,%edx
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010129c:	8b 45 08             	mov    0x8(%ebp),%eax
8010129f:	8b 40 10             	mov    0x10(%eax),%eax
801012a2:	89 04 24             	mov    %eax,(%esp)
801012a5:	e8 11 07 00 00       	call   801019bb <iunlock>
      end_op();
801012aa:	e8 f7 21 00 00       	call   801034a6 <end_op>

      if(r < 0)
801012af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012b3:	79 02                	jns    801012b7 <filewrite+0xf6>
        break;
801012b5:	eb 26                	jmp    801012dd <filewrite+0x11c>
      if(r != n1)
801012b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012bd:	74 0c                	je     801012cb <filewrite+0x10a>
        panic("short filewrite");
801012bf:	c7 04 24 9f 92 10 80 	movl   $0x8010929f,(%esp)
801012c6:	e8 6f f2 ff ff       	call   8010053a <panic>
      i += r;
801012cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ce:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d7:	0f 8c 4c ff ff ff    	jl     80101229 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e0:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e3:	75 05                	jne    801012ea <filewrite+0x129>
801012e5:	8b 45 10             	mov    0x10(%ebp),%eax
801012e8:	eb 05                	jmp    801012ef <filewrite+0x12e>
801012ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ef:	eb 0c                	jmp    801012fd <filewrite+0x13c>
  }
  panic("filewrite");
801012f1:	c7 04 24 af 92 10 80 	movl   $0x801092af,(%esp)
801012f8:	e8 3d f2 ff ff       	call   8010053a <panic>
}
801012fd:	83 c4 24             	add    $0x24,%esp
80101300:	5b                   	pop    %ebx
80101301:	5d                   	pop    %ebp
80101302:	c3                   	ret    

80101303 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101303:	55                   	push   %ebp
80101304:	89 e5                	mov    %esp,%ebp
80101306:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101309:	8b 45 08             	mov    0x8(%ebp),%eax
8010130c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101313:	00 
80101314:	89 04 24             	mov    %eax,(%esp)
80101317:	e8 8a ee ff ff       	call   801001a6 <bread>
8010131c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010131f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101322:	83 c0 18             	add    $0x18,%eax
80101325:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010132c:	00 
8010132d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101331:	8b 45 0c             	mov    0xc(%ebp),%eax
80101334:	89 04 24             	mov    %eax,(%esp)
80101337:	e8 8c 4b 00 00       	call   80105ec8 <memmove>
  brelse(bp);
8010133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133f:	89 04 24             	mov    %eax,(%esp)
80101342:	e8 d0 ee ff ff       	call   80100217 <brelse>
}
80101347:	c9                   	leave  
80101348:	c3                   	ret    

80101349 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101349:	55                   	push   %ebp
8010134a:	89 e5                	mov    %esp,%ebp
8010134c:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010134f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101352:	8b 45 08             	mov    0x8(%ebp),%eax
80101355:	89 54 24 04          	mov    %edx,0x4(%esp)
80101359:	89 04 24             	mov    %eax,(%esp)
8010135c:	e8 45 ee ff ff       	call   801001a6 <bread>
80101361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101367:	83 c0 18             	add    $0x18,%eax
8010136a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101371:	00 
80101372:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101379:	00 
8010137a:	89 04 24             	mov    %eax,(%esp)
8010137d:	e8 77 4a 00 00       	call   80105df9 <memset>
  log_write(bp);
80101382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101385:	89 04 24             	mov    %eax,(%esp)
80101388:	e8 a0 22 00 00       	call   8010362d <log_write>
  brelse(bp);
8010138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101390:	89 04 24             	mov    %eax,(%esp)
80101393:	e8 7f ee ff ff       	call   80100217 <brelse>
}
80101398:	c9                   	leave  
80101399:	c3                   	ret    

8010139a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010139a:	55                   	push   %ebp
8010139b:	89 e5                	mov    %esp,%ebp
8010139d:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013a7:	8b 45 08             	mov    0x8(%ebp),%eax
801013aa:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801013b1:	89 04 24             	mov    %eax,(%esp)
801013b4:	e8 4a ff ff ff       	call   80101303 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013c0:	e9 07 01 00 00       	jmp    801014cc <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c8:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013ce:	85 c0                	test   %eax,%eax
801013d0:	0f 48 c2             	cmovs  %edx,%eax
801013d3:	c1 f8 0c             	sar    $0xc,%eax
801013d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013d9:	c1 ea 03             	shr    $0x3,%edx
801013dc:	01 d0                	add    %edx,%eax
801013de:	83 c0 03             	add    $0x3,%eax
801013e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e5:	8b 45 08             	mov    0x8(%ebp),%eax
801013e8:	89 04 24             	mov    %eax,(%esp)
801013eb:	e8 b6 ed ff ff       	call   801001a6 <bread>
801013f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013fa:	e9 9d 00 00 00       	jmp    8010149c <balloc+0x102>
      m = 1 << (bi % 8);
801013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101402:	99                   	cltd   
80101403:	c1 ea 1d             	shr    $0x1d,%edx
80101406:	01 d0                	add    %edx,%eax
80101408:	83 e0 07             	and    $0x7,%eax
8010140b:	29 d0                	sub    %edx,%eax
8010140d:	ba 01 00 00 00       	mov    $0x1,%edx
80101412:	89 c1                	mov    %eax,%ecx
80101414:	d3 e2                	shl    %cl,%edx
80101416:	89 d0                	mov    %edx,%eax
80101418:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010141b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010141e:	8d 50 07             	lea    0x7(%eax),%edx
80101421:	85 c0                	test   %eax,%eax
80101423:	0f 48 c2             	cmovs  %edx,%eax
80101426:	c1 f8 03             	sar    $0x3,%eax
80101429:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010142c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101431:	0f b6 c0             	movzbl %al,%eax
80101434:	23 45 e8             	and    -0x18(%ebp),%eax
80101437:	85 c0                	test   %eax,%eax
80101439:	75 5d                	jne    80101498 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143e:	8d 50 07             	lea    0x7(%eax),%edx
80101441:	85 c0                	test   %eax,%eax
80101443:	0f 48 c2             	cmovs  %edx,%eax
80101446:	c1 f8 03             	sar    $0x3,%eax
80101449:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101451:	89 d1                	mov    %edx,%ecx
80101453:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101456:	09 ca                	or     %ecx,%edx
80101458:	89 d1                	mov    %edx,%ecx
8010145a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101461:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101464:	89 04 24             	mov    %eax,(%esp)
80101467:	e8 c1 21 00 00       	call   8010362d <log_write>
        brelse(bp);
8010146c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010146f:	89 04 24             	mov    %eax,(%esp)
80101472:	e8 a0 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010147a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010147d:	01 c2                	add    %eax,%edx
8010147f:	8b 45 08             	mov    0x8(%ebp),%eax
80101482:	89 54 24 04          	mov    %edx,0x4(%esp)
80101486:	89 04 24             	mov    %eax,(%esp)
80101489:	e8 bb fe ff ff       	call   80101349 <bzero>
        return b + bi;
8010148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101491:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101494:	01 d0                	add    %edx,%eax
80101496:	eb 4e                	jmp    801014e6 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101498:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010149c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014a3:	7f 15                	jg     801014ba <balloc+0x120>
801014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ab:	01 d0                	add    %edx,%eax
801014ad:	89 c2                	mov    %eax,%edx
801014af:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014b2:	39 c2                	cmp    %eax,%edx
801014b4:	0f 82 45 ff ff ff    	jb     801013ff <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014bd:	89 04 24             	mov    %eax,(%esp)
801014c0:	e8 52 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014c5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014d2:	39 c2                	cmp    %eax,%edx
801014d4:	0f 82 eb fe ff ff    	jb     801013c5 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014da:	c7 04 24 b9 92 10 80 	movl   $0x801092b9,(%esp)
801014e1:	e8 54 f0 ff ff       	call   8010053a <panic>
}
801014e6:	c9                   	leave  
801014e7:	c3                   	ret    

801014e8 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014e8:	55                   	push   %ebp
801014e9:	89 e5                	mov    %esp,%ebp
801014eb:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014ee:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f5:	8b 45 08             	mov    0x8(%ebp),%eax
801014f8:	89 04 24             	mov    %eax,(%esp)
801014fb:	e8 03 fe ff ff       	call   80101303 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	c1 e8 0c             	shr    $0xc,%eax
80101506:	89 c2                	mov    %eax,%edx
80101508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010150b:	c1 e8 03             	shr    $0x3,%eax
8010150e:	01 d0                	add    %edx,%eax
80101510:	8d 50 03             	lea    0x3(%eax),%edx
80101513:	8b 45 08             	mov    0x8(%ebp),%eax
80101516:	89 54 24 04          	mov    %edx,0x4(%esp)
8010151a:	89 04 24             	mov    %eax,(%esp)
8010151d:	e8 84 ec ff ff       	call   801001a6 <bread>
80101522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101525:	8b 45 0c             	mov    0xc(%ebp),%eax
80101528:	25 ff 0f 00 00       	and    $0xfff,%eax
8010152d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101533:	99                   	cltd   
80101534:	c1 ea 1d             	shr    $0x1d,%edx
80101537:	01 d0                	add    %edx,%eax
80101539:	83 e0 07             	and    $0x7,%eax
8010153c:	29 d0                	sub    %edx,%eax
8010153e:	ba 01 00 00 00       	mov    $0x1,%edx
80101543:	89 c1                	mov    %eax,%ecx
80101545:	d3 e2                	shl    %cl,%edx
80101547:	89 d0                	mov    %edx,%eax
80101549:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154f:	8d 50 07             	lea    0x7(%eax),%edx
80101552:	85 c0                	test   %eax,%eax
80101554:	0f 48 c2             	cmovs  %edx,%eax
80101557:	c1 f8 03             	sar    $0x3,%eax
8010155a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155d:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101562:	0f b6 c0             	movzbl %al,%eax
80101565:	23 45 ec             	and    -0x14(%ebp),%eax
80101568:	85 c0                	test   %eax,%eax
8010156a:	75 0c                	jne    80101578 <bfree+0x90>
    panic("freeing free block");
8010156c:	c7 04 24 cf 92 10 80 	movl   $0x801092cf,(%esp)
80101573:	e8 c2 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101578:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157b:	8d 50 07             	lea    0x7(%eax),%edx
8010157e:	85 c0                	test   %eax,%eax
80101580:	0f 48 c2             	cmovs  %edx,%eax
80101583:	c1 f8 03             	sar    $0x3,%eax
80101586:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101589:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010158e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101591:	f7 d1                	not    %ecx
80101593:	21 ca                	and    %ecx,%edx
80101595:	89 d1                	mov    %edx,%ecx
80101597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159a:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a1:	89 04 24             	mov    %eax,(%esp)
801015a4:	e8 84 20 00 00       	call   8010362d <log_write>
  brelse(bp);
801015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ac:	89 04 24             	mov    %eax,(%esp)
801015af:	e8 63 ec ff ff       	call   80100217 <brelse>
}
801015b4:	c9                   	leave  
801015b5:	c3                   	ret    

801015b6 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b6:	55                   	push   %ebp
801015b7:	89 e5                	mov    %esp,%ebp
801015b9:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015bc:	c7 44 24 04 e2 92 10 	movl   $0x801092e2,0x4(%esp)
801015c3:	80 
801015c4:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
801015cb:	e8 b4 45 00 00       	call   80105b84 <initlock>
}
801015d0:	c9                   	leave  
801015d1:	c3                   	ret    

801015d2 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015d2:	55                   	push   %ebp
801015d3:	89 e5                	mov    %esp,%ebp
801015d5:	83 ec 38             	sub    $0x38,%esp
801015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801015db:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015df:	8b 45 08             	mov    0x8(%ebp),%eax
801015e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e9:	89 04 24             	mov    %eax,(%esp)
801015ec:	e8 12 fd ff ff       	call   80101303 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015f1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015f8:	e9 98 00 00 00       	jmp    80101695 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101600:	c1 e8 03             	shr    $0x3,%eax
80101603:	83 c0 02             	add    $0x2,%eax
80101606:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160a:	8b 45 08             	mov    0x8(%ebp),%eax
8010160d:	89 04 24             	mov    %eax,(%esp)
80101610:	e8 91 eb ff ff       	call   801001a6 <bread>
80101615:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101618:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010161b:	8d 50 18             	lea    0x18(%eax),%edx
8010161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101621:	83 e0 07             	and    $0x7,%eax
80101624:	c1 e0 06             	shl    $0x6,%eax
80101627:	01 d0                	add    %edx,%eax
80101629:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162f:	0f b7 00             	movzwl (%eax),%eax
80101632:	66 85 c0             	test   %ax,%ax
80101635:	75 4f                	jne    80101686 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101637:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163e:	00 
8010163f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101646:	00 
80101647:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010164a:	89 04 24             	mov    %eax,(%esp)
8010164d:	e8 a7 47 00 00       	call   80105df9 <memset>
      dip->type = type;
80101652:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101655:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101659:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165f:	89 04 24             	mov    %eax,(%esp)
80101662:	e8 c6 1f 00 00       	call   8010362d <log_write>
      brelse(bp);
80101667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166a:	89 04 24             	mov    %eax,(%esp)
8010166d:	e8 a5 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101675:	89 44 24 04          	mov    %eax,0x4(%esp)
80101679:	8b 45 08             	mov    0x8(%ebp),%eax
8010167c:	89 04 24             	mov    %eax,(%esp)
8010167f:	e8 e5 00 00 00       	call   80101769 <iget>
80101684:	eb 29                	jmp    801016af <ialloc+0xdd>
    }
    brelse(bp);
80101686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101689:	89 04 24             	mov    %eax,(%esp)
8010168c:	e8 86 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101691:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101695:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010169b:	39 c2                	cmp    %eax,%edx
8010169d:	0f 82 5a ff ff ff    	jb     801015fd <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016a3:	c7 04 24 e9 92 10 80 	movl   $0x801092e9,(%esp)
801016aa:	e8 8b ee ff ff       	call   8010053a <panic>
}
801016af:	c9                   	leave  
801016b0:	c3                   	ret    

801016b1 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016b1:	55                   	push   %ebp
801016b2:	89 e5                	mov    %esp,%ebp
801016b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ba:	8b 40 04             	mov    0x4(%eax),%eax
801016bd:	c1 e8 03             	shr    $0x3,%eax
801016c0:	8d 50 02             	lea    0x2(%eax),%edx
801016c3:	8b 45 08             	mov    0x8(%ebp),%eax
801016c6:	8b 00                	mov    (%eax),%eax
801016c8:	89 54 24 04          	mov    %edx,0x4(%esp)
801016cc:	89 04 24             	mov    %eax,(%esp)
801016cf:	e8 d2 ea ff ff       	call   801001a6 <bread>
801016d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016da:	8d 50 18             	lea    0x18(%eax),%edx
801016dd:	8b 45 08             	mov    0x8(%ebp),%eax
801016e0:	8b 40 04             	mov    0x4(%eax),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	01 d0                	add    %edx,%eax
801016eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016ee:	8b 45 08             	mov    0x8(%ebp),%eax
801016f1:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f8:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016fb:	8b 45 08             	mov    0x8(%ebp),%eax
801016fe:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101702:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101705:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101709:	8b 45 08             	mov    0x8(%ebp),%eax
8010170c:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101713:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101717:	8b 45 08             	mov    0x8(%ebp),%eax
8010171a:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101721:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101725:	8b 45 08             	mov    0x8(%ebp),%eax
80101728:	8b 50 18             	mov    0x18(%eax),%edx
8010172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101731:	8b 45 08             	mov    0x8(%ebp),%eax
80101734:	8d 50 1c             	lea    0x1c(%eax),%edx
80101737:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173a:	83 c0 0c             	add    $0xc,%eax
8010173d:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101744:	00 
80101745:	89 54 24 04          	mov    %edx,0x4(%esp)
80101749:	89 04 24             	mov    %eax,(%esp)
8010174c:	e8 77 47 00 00       	call   80105ec8 <memmove>
  log_write(bp);
80101751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101754:	89 04 24             	mov    %eax,(%esp)
80101757:	e8 d1 1e 00 00       	call   8010362d <log_write>
  brelse(bp);
8010175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175f:	89 04 24             	mov    %eax,(%esp)
80101762:	e8 b0 ea ff ff       	call   80100217 <brelse>
}
80101767:	c9                   	leave  
80101768:	c3                   	ret    

80101769 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101769:	55                   	push   %ebp
8010176a:	89 e5                	mov    %esp,%ebp
8010176c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010176f:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101776:	e8 2a 44 00 00       	call   80105ba5 <acquire>

  // Is the inode already cached?
  empty = 0;
8010177b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101782:	c7 45 f4 f4 22 11 80 	movl   $0x801122f4,-0xc(%ebp)
80101789:	eb 59                	jmp    801017e4 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178e:	8b 40 08             	mov    0x8(%eax),%eax
80101791:	85 c0                	test   %eax,%eax
80101793:	7e 35                	jle    801017ca <iget+0x61>
80101795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101798:	8b 00                	mov    (%eax),%eax
8010179a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010179d:	75 2b                	jne    801017ca <iget+0x61>
8010179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a2:	8b 40 04             	mov    0x4(%eax),%eax
801017a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a8:	75 20                	jne    801017ca <iget+0x61>
      ip->ref++;
801017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ad:	8b 40 08             	mov    0x8(%eax),%eax
801017b0:	8d 50 01             	lea    0x1(%eax),%edx
801017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b6:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017b9:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
801017c0:	e8 42 44 00 00       	call   80105c07 <release>
      return ip;
801017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c8:	eb 6f                	jmp    80101839 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ce:	75 10                	jne    801017e0 <iget+0x77>
801017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d3:	8b 40 08             	mov    0x8(%eax),%eax
801017d6:	85 c0                	test   %eax,%eax
801017d8:	75 06                	jne    801017e0 <iget+0x77>
      empty = ip;
801017da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017e0:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017e4:	81 7d f4 94 32 11 80 	cmpl   $0x80113294,-0xc(%ebp)
801017eb:	72 9e                	jb     8010178b <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017f1:	75 0c                	jne    801017ff <iget+0x96>
    panic("iget: no inodes");
801017f3:	c7 04 24 fb 92 10 80 	movl   $0x801092fb,(%esp)
801017fa:	e8 3b ed ff ff       	call   8010053a <panic>

  ip = empty;
801017ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101808:	8b 55 08             	mov    0x8(%ebp),%edx
8010180b:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101810:	8b 55 0c             	mov    0xc(%ebp),%edx
80101813:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101819:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101823:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010182a:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101831:	e8 d1 43 00 00       	call   80105c07 <release>

  return ip;
80101836:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101839:	c9                   	leave  
8010183a:	c3                   	ret    

8010183b <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010183b:	55                   	push   %ebp
8010183c:	89 e5                	mov    %esp,%ebp
8010183e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101841:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101848:	e8 58 43 00 00       	call   80105ba5 <acquire>
  ip->ref++;
8010184d:	8b 45 08             	mov    0x8(%ebp),%eax
80101850:	8b 40 08             	mov    0x8(%eax),%eax
80101853:	8d 50 01             	lea    0x1(%eax),%edx
80101856:	8b 45 08             	mov    0x8(%ebp),%eax
80101859:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010185c:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101863:	e8 9f 43 00 00       	call   80105c07 <release>
  return ip;
80101868:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010186b:	c9                   	leave  
8010186c:	c3                   	ret    

8010186d <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010186d:	55                   	push   %ebp
8010186e:	89 e5                	mov    %esp,%ebp
80101870:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101873:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101877:	74 0a                	je     80101883 <ilock+0x16>
80101879:	8b 45 08             	mov    0x8(%ebp),%eax
8010187c:	8b 40 08             	mov    0x8(%eax),%eax
8010187f:	85 c0                	test   %eax,%eax
80101881:	7f 0c                	jg     8010188f <ilock+0x22>
    panic("ilock");
80101883:	c7 04 24 0b 93 10 80 	movl   $0x8010930b,(%esp)
8010188a:	e8 ab ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010188f:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101896:	e8 0a 43 00 00       	call   80105ba5 <acquire>
  while(ip->flags & I_BUSY)
8010189b:	eb 13                	jmp    801018b0 <ilock+0x43>
    sleep(ip, &icache.lock);
8010189d:	c7 44 24 04 c0 22 11 	movl   $0x801122c0,0x4(%esp)
801018a4:	80 
801018a5:	8b 45 08             	mov    0x8(%ebp),%eax
801018a8:	89 04 24             	mov    %eax,(%esp)
801018ab:	e8 29 38 00 00       	call   801050d9 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018b0:	8b 45 08             	mov    0x8(%ebp),%eax
801018b3:	8b 40 0c             	mov    0xc(%eax),%eax
801018b6:	83 e0 01             	and    $0x1,%eax
801018b9:	85 c0                	test   %eax,%eax
801018bb:	75 e0                	jne    8010189d <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018bd:	8b 45 08             	mov    0x8(%ebp),%eax
801018c0:	8b 40 0c             	mov    0xc(%eax),%eax
801018c3:	83 c8 01             	or     $0x1,%eax
801018c6:	89 c2                	mov    %eax,%edx
801018c8:	8b 45 08             	mov    0x8(%ebp),%eax
801018cb:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018ce:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
801018d5:	e8 2d 43 00 00       	call   80105c07 <release>

  if(!(ip->flags & I_VALID)){
801018da:	8b 45 08             	mov    0x8(%ebp),%eax
801018dd:	8b 40 0c             	mov    0xc(%eax),%eax
801018e0:	83 e0 02             	and    $0x2,%eax
801018e3:	85 c0                	test   %eax,%eax
801018e5:	0f 85 ce 00 00 00    	jne    801019b9 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018eb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ee:	8b 40 04             	mov    0x4(%eax),%eax
801018f1:	c1 e8 03             	shr    $0x3,%eax
801018f4:	8d 50 02             	lea    0x2(%eax),%edx
801018f7:	8b 45 08             	mov    0x8(%ebp),%eax
801018fa:	8b 00                	mov    (%eax),%eax
801018fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101900:	89 04 24             	mov    %eax,(%esp)
80101903:	e8 9e e8 ff ff       	call   801001a6 <bread>
80101908:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190e:	8d 50 18             	lea    0x18(%eax),%edx
80101911:	8b 45 08             	mov    0x8(%ebp),%eax
80101914:	8b 40 04             	mov    0x4(%eax),%eax
80101917:	83 e0 07             	and    $0x7,%eax
8010191a:	c1 e0 06             	shl    $0x6,%eax
8010191d:	01 d0                	add    %edx,%eax
8010191f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101922:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101925:	0f b7 10             	movzwl (%eax),%edx
80101928:	8b 45 08             	mov    0x8(%ebp),%eax
8010192b:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010192f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101932:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101936:	8b 45 08             	mov    0x8(%ebp),%eax
80101939:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101940:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101944:	8b 45 08             	mov    0x8(%ebp),%eax
80101947:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194e:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101952:	8b 45 08             	mov    0x8(%ebp),%eax
80101955:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195c:	8b 50 08             	mov    0x8(%eax),%edx
8010195f:	8b 45 08             	mov    0x8(%ebp),%eax
80101962:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101968:	8d 50 0c             	lea    0xc(%eax),%edx
8010196b:	8b 45 08             	mov    0x8(%ebp),%eax
8010196e:	83 c0 1c             	add    $0x1c,%eax
80101971:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101978:	00 
80101979:	89 54 24 04          	mov    %edx,0x4(%esp)
8010197d:	89 04 24             	mov    %eax,(%esp)
80101980:	e8 43 45 00 00       	call   80105ec8 <memmove>
    brelse(bp);
80101985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101988:	89 04 24             	mov    %eax,(%esp)
8010198b:	e8 87 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101990:	8b 45 08             	mov    0x8(%ebp),%eax
80101993:	8b 40 0c             	mov    0xc(%eax),%eax
80101996:	83 c8 02             	or     $0x2,%eax
80101999:	89 c2                	mov    %eax,%edx
8010199b:	8b 45 08             	mov    0x8(%ebp),%eax
8010199e:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019a1:	8b 45 08             	mov    0x8(%ebp),%eax
801019a4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019a8:	66 85 c0             	test   %ax,%ax
801019ab:	75 0c                	jne    801019b9 <ilock+0x14c>
      panic("ilock: no type");
801019ad:	c7 04 24 11 93 10 80 	movl   $0x80109311,(%esp)
801019b4:	e8 81 eb ff ff       	call   8010053a <panic>
  }
}
801019b9:	c9                   	leave  
801019ba:	c3                   	ret    

801019bb <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019bb:	55                   	push   %ebp
801019bc:	89 e5                	mov    %esp,%ebp
801019be:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c5:	74 17                	je     801019de <iunlock+0x23>
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	8b 40 0c             	mov    0xc(%eax),%eax
801019cd:	83 e0 01             	and    $0x1,%eax
801019d0:	85 c0                	test   %eax,%eax
801019d2:	74 0a                	je     801019de <iunlock+0x23>
801019d4:	8b 45 08             	mov    0x8(%ebp),%eax
801019d7:	8b 40 08             	mov    0x8(%eax),%eax
801019da:	85 c0                	test   %eax,%eax
801019dc:	7f 0c                	jg     801019ea <iunlock+0x2f>
    panic("iunlock");
801019de:	c7 04 24 20 93 10 80 	movl   $0x80109320,(%esp)
801019e5:	e8 50 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019ea:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
801019f1:	e8 af 41 00 00       	call   80105ba5 <acquire>
  ip->flags &= ~I_BUSY;
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	8b 40 0c             	mov    0xc(%eax),%eax
801019fc:	83 e0 fe             	and    $0xfffffffe,%eax
801019ff:	89 c2                	mov    %eax,%edx
80101a01:	8b 45 08             	mov    0x8(%ebp),%eax
80101a04:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	89 04 24             	mov    %eax,(%esp)
80101a0d:	e8 0a 39 00 00       	call   8010531c <wakeup>
  release(&icache.lock);
80101a12:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101a19:	e8 e9 41 00 00       	call   80105c07 <release>
}
80101a1e:	c9                   	leave  
80101a1f:	c3                   	ret    

80101a20 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a26:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101a2d:	e8 73 41 00 00       	call   80105ba5 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a32:	8b 45 08             	mov    0x8(%ebp),%eax
80101a35:	8b 40 08             	mov    0x8(%eax),%eax
80101a38:	83 f8 01             	cmp    $0x1,%eax
80101a3b:	0f 85 93 00 00 00    	jne    80101ad4 <iput+0xb4>
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	8b 40 0c             	mov    0xc(%eax),%eax
80101a47:	83 e0 02             	and    $0x2,%eax
80101a4a:	85 c0                	test   %eax,%eax
80101a4c:	0f 84 82 00 00 00    	je     80101ad4 <iput+0xb4>
80101a52:	8b 45 08             	mov    0x8(%ebp),%eax
80101a55:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a59:	66 85 c0             	test   %ax,%ax
80101a5c:	75 76                	jne    80101ad4 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a61:	8b 40 0c             	mov    0xc(%eax),%eax
80101a64:	83 e0 01             	and    $0x1,%eax
80101a67:	85 c0                	test   %eax,%eax
80101a69:	74 0c                	je     80101a77 <iput+0x57>
      panic("iput busy");
80101a6b:	c7 04 24 28 93 10 80 	movl   $0x80109328,(%esp)
80101a72:	e8 c3 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a77:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a7d:	83 c8 01             	or     $0x1,%eax
80101a80:	89 c2                	mov    %eax,%edx
80101a82:	8b 45 08             	mov    0x8(%ebp),%eax
80101a85:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a88:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101a8f:	e8 73 41 00 00       	call   80105c07 <release>
    itrunc(ip);
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	89 04 24             	mov    %eax,(%esp)
80101a9a:	e8 7d 01 00 00       	call   80101c1c <itrunc>
    ip->type = 0;
80101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa2:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	89 04 24             	mov    %eax,(%esp)
80101aae:	e8 fe fb ff ff       	call   801016b1 <iupdate>
    acquire(&icache.lock);
80101ab3:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101aba:	e8 e6 40 00 00       	call   80105ba5 <acquire>
    ip->flags = 0;
80101abf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	89 04 24             	mov    %eax,(%esp)
80101acf:	e8 48 38 00 00       	call   8010531c <wakeup>
  }
  ip->ref--;
80101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad7:	8b 40 08             	mov    0x8(%eax),%eax
80101ada:	8d 50 ff             	lea    -0x1(%eax),%edx
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae3:	c7 04 24 c0 22 11 80 	movl   $0x801122c0,(%esp)
80101aea:	e8 18 41 00 00       	call   80105c07 <release>
}
80101aef:	c9                   	leave  
80101af0:	c3                   	ret    

80101af1 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101af1:	55                   	push   %ebp
80101af2:	89 e5                	mov    %esp,%ebp
80101af4:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101af7:	8b 45 08             	mov    0x8(%ebp),%eax
80101afa:	89 04 24             	mov    %eax,(%esp)
80101afd:	e8 b9 fe ff ff       	call   801019bb <iunlock>
  iput(ip);
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	89 04 24             	mov    %eax,(%esp)
80101b08:	e8 13 ff ff ff       	call   80101a20 <iput>
}
80101b0d:	c9                   	leave  
80101b0e:	c3                   	ret    

80101b0f <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b0f:	55                   	push   %ebp
80101b10:	89 e5                	mov    %esp,%ebp
80101b12:	53                   	push   %ebx
80101b13:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b16:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b1a:	77 3e                	ja     80101b5a <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b22:	83 c2 04             	add    $0x4,%edx
80101b25:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b30:	75 20                	jne    80101b52 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b32:	8b 45 08             	mov    0x8(%ebp),%eax
80101b35:	8b 00                	mov    (%eax),%eax
80101b37:	89 04 24             	mov    %eax,(%esp)
80101b3a:	e8 5b f8 ff ff       	call   8010139a <balloc>
80101b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b48:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b4e:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b55:	e9 bc 00 00 00       	jmp    80101c16 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b5a:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b5e:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b62:	0f 87 a2 00 00 00    	ja     80101c0a <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b68:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b75:	75 19                	jne    80101b90 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b77:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7a:	8b 00                	mov    (%eax),%eax
80101b7c:	89 04 24             	mov    %eax,(%esp)
80101b7f:	e8 16 f8 ff ff       	call   8010139a <balloc>
80101b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b8d:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	8b 00                	mov    (%eax),%eax
80101b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b98:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b9c:	89 04 24             	mov    %eax,(%esp)
80101b9f:	e8 02 e6 ff ff       	call   801001a6 <bread>
80101ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101baa:	83 c0 18             	add    $0x18,%eax
80101bad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bbd:	01 d0                	add    %edx,%eax
80101bbf:	8b 00                	mov    (%eax),%eax
80101bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc8:	75 30                	jne    80101bfa <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bca:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bd7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bda:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdd:	8b 00                	mov    (%eax),%eax
80101bdf:	89 04 24             	mov    %eax,(%esp)
80101be2:	e8 b3 f7 ff ff       	call   8010139a <balloc>
80101be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bed:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf2:	89 04 24             	mov    %eax,(%esp)
80101bf5:	e8 33 1a 00 00       	call   8010362d <log_write>
    }
    brelse(bp);
80101bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfd:	89 04 24             	mov    %eax,(%esp)
80101c00:	e8 12 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c08:	eb 0c                	jmp    80101c16 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c0a:	c7 04 24 32 93 10 80 	movl   $0x80109332,(%esp)
80101c11:	e8 24 e9 ff ff       	call   8010053a <panic>
}
80101c16:	83 c4 24             	add    $0x24,%esp
80101c19:	5b                   	pop    %ebx
80101c1a:	5d                   	pop    %ebp
80101c1b:	c3                   	ret    

80101c1c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c1c:	55                   	push   %ebp
80101c1d:	89 e5                	mov    %esp,%ebp
80101c1f:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c29:	eb 44                	jmp    80101c6f <itrunc+0x53>
    if(ip->addrs[i]){
80101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c31:	83 c2 04             	add    $0x4,%edx
80101c34:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c38:	85 c0                	test   %eax,%eax
80101c3a:	74 2f                	je     80101c6b <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c42:	83 c2 04             	add    $0x4,%edx
80101c45:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 00                	mov    (%eax),%eax
80101c4e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c52:	89 04 24             	mov    %eax,(%esp)
80101c55:	e8 8e f8 ff ff       	call   801014e8 <bfree>
      ip->addrs[i] = 0;
80101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c60:	83 c2 04             	add    $0x4,%edx
80101c63:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c6a:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c6f:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c73:	7e b6                	jle    80101c2b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c75:	8b 45 08             	mov    0x8(%ebp),%eax
80101c78:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c7b:	85 c0                	test   %eax,%eax
80101c7d:	0f 84 9b 00 00 00    	je     80101d1e <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c83:	8b 45 08             	mov    0x8(%ebp),%eax
80101c86:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 00                	mov    (%eax),%eax
80101c8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c92:	89 04 24             	mov    %eax,(%esp)
80101c95:	e8 0c e5 ff ff       	call   801001a6 <bread>
80101c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ca0:	83 c0 18             	add    $0x18,%eax
80101ca3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ca6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cad:	eb 3b                	jmp    80101cea <itrunc+0xce>
      if(a[j])
80101caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cbc:	01 d0                	add    %edx,%eax
80101cbe:	8b 00                	mov    (%eax),%eax
80101cc0:	85 c0                	test   %eax,%eax
80101cc2:	74 22                	je     80101ce6 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cd1:	01 d0                	add    %edx,%eax
80101cd3:	8b 10                	mov    (%eax),%edx
80101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd8:	8b 00                	mov    (%eax),%eax
80101cda:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cde:	89 04 24             	mov    %eax,(%esp)
80101ce1:	e8 02 f8 ff ff       	call   801014e8 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ce6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ced:	83 f8 7f             	cmp    $0x7f,%eax
80101cf0:	76 bd                	jbe    80101caf <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf5:	89 04 24             	mov    %eax,(%esp)
80101cf8:	e8 1a e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d03:	8b 45 08             	mov    0x8(%ebp),%eax
80101d06:	8b 00                	mov    (%eax),%eax
80101d08:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d0c:	89 04 24             	mov    %eax,(%esp)
80101d0f:	e8 d4 f7 ff ff       	call   801014e8 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d14:	8b 45 08             	mov    0x8(%ebp),%eax
80101d17:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d21:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d28:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2b:	89 04 24             	mov    %eax,(%esp)
80101d2e:	e8 7e f9 ff ff       	call   801016b1 <iupdate>
}
80101d33:	c9                   	leave  
80101d34:	c3                   	ret    

80101d35 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d35:	55                   	push   %ebp
80101d36:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d38:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3b:	8b 00                	mov    (%eax),%eax
80101d3d:	89 c2                	mov    %eax,%edx
80101d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d42:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d45:	8b 45 08             	mov    0x8(%ebp),%eax
80101d48:	8b 50 04             	mov    0x4(%eax),%edx
80101d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4e:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d51:	8b 45 08             	mov    0x8(%ebp),%eax
80101d54:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5b:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d68:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 50 18             	mov    0x18(%eax),%edx
80101d72:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d75:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d78:	5d                   	pop    %ebp
80101d79:	c3                   	ret    

80101d7a <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d7a:	55                   	push   %ebp
80101d7b:	89 e5                	mov    %esp,%ebp
80101d7d:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d87:	66 83 f8 03          	cmp    $0x3,%ax
80101d8b:	75 60                	jne    80101ded <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d94:	66 85 c0             	test   %ax,%ax
80101d97:	78 20                	js     80101db9 <readi+0x3f>
80101d99:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101da0:	66 83 f8 09          	cmp    $0x9,%ax
80101da4:	7f 13                	jg     80101db9 <readi+0x3f>
80101da6:	8b 45 08             	mov    0x8(%ebp),%eax
80101da9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dad:	98                   	cwtl   
80101dae:	8b 04 c5 60 22 11 80 	mov    -0x7feedda0(,%eax,8),%eax
80101db5:	85 c0                	test   %eax,%eax
80101db7:	75 0a                	jne    80101dc3 <readi+0x49>
      return -1;
80101db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dbe:	e9 19 01 00 00       	jmp    80101edc <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dca:	98                   	cwtl   
80101dcb:	8b 04 c5 60 22 11 80 	mov    -0x7feedda0(,%eax,8),%eax
80101dd2:	8b 55 14             	mov    0x14(%ebp),%edx
80101dd5:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ddc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101de0:	8b 55 08             	mov    0x8(%ebp),%edx
80101de3:	89 14 24             	mov    %edx,(%esp)
80101de6:	ff d0                	call   *%eax
80101de8:	e9 ef 00 00 00       	jmp    80101edc <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101ded:	8b 45 08             	mov    0x8(%ebp),%eax
80101df0:	8b 40 18             	mov    0x18(%eax),%eax
80101df3:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df6:	72 0d                	jb     80101e05 <readi+0x8b>
80101df8:	8b 45 14             	mov    0x14(%ebp),%eax
80101dfb:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfe:	01 d0                	add    %edx,%eax
80101e00:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e03:	73 0a                	jae    80101e0f <readi+0x95>
    return -1;
80101e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e0a:	e9 cd 00 00 00       	jmp    80101edc <readi+0x162>
  if(off + n > ip->size)
80101e0f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e12:	8b 55 10             	mov    0x10(%ebp),%edx
80101e15:	01 c2                	add    %eax,%edx
80101e17:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1a:	8b 40 18             	mov    0x18(%eax),%eax
80101e1d:	39 c2                	cmp    %eax,%edx
80101e1f:	76 0c                	jbe    80101e2d <readi+0xb3>
    n = ip->size - off;
80101e21:	8b 45 08             	mov    0x8(%ebp),%eax
80101e24:	8b 40 18             	mov    0x18(%eax),%eax
80101e27:	2b 45 10             	sub    0x10(%ebp),%eax
80101e2a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e34:	e9 94 00 00 00       	jmp    80101ecd <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e39:	8b 45 10             	mov    0x10(%ebp),%eax
80101e3c:	c1 e8 09             	shr    $0x9,%eax
80101e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e43:	8b 45 08             	mov    0x8(%ebp),%eax
80101e46:	89 04 24             	mov    %eax,(%esp)
80101e49:	e8 c1 fc ff ff       	call   80101b0f <bmap>
80101e4e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e51:	8b 12                	mov    (%edx),%edx
80101e53:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e57:	89 14 24             	mov    %edx,(%esp)
80101e5a:	e8 47 e3 ff ff       	call   801001a6 <bread>
80101e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
80101e65:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e6a:	89 c2                	mov    %eax,%edx
80101e6c:	b8 00 02 00 00       	mov    $0x200,%eax
80101e71:	29 d0                	sub    %edx,%eax
80101e73:	89 c2                	mov    %eax,%edx
80101e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e78:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e7b:	29 c1                	sub    %eax,%ecx
80101e7d:	89 c8                	mov    %ecx,%eax
80101e7f:	39 c2                	cmp    %eax,%edx
80101e81:	0f 46 c2             	cmovbe %edx,%eax
80101e84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e87:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e8f:	8d 50 10             	lea    0x10(%eax),%edx
80101e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e95:	01 d0                	add    %edx,%eax
80101e97:	8d 50 08             	lea    0x8(%eax),%edx
80101e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9d:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ea1:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea8:	89 04 24             	mov    %eax,(%esp)
80101eab:	e8 18 40 00 00       	call   80105ec8 <memmove>
    brelse(bp);
80101eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb3:	89 04 24             	mov    %eax,(%esp)
80101eb6:	e8 5c e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ebe:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec4:	01 45 10             	add    %eax,0x10(%ebp)
80101ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eca:	01 45 0c             	add    %eax,0xc(%ebp)
80101ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ed0:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ed3:	0f 82 60 ff ff ff    	jb     80101e39 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ed9:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101edc:	c9                   	leave  
80101edd:	c3                   	ret    

80101ede <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ede:	55                   	push   %ebp
80101edf:	89 e5                	mov    %esp,%ebp
80101ee1:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101eeb:	66 83 f8 03          	cmp    $0x3,%ax
80101eef:	75 60                	jne    80101f51 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef8:	66 85 c0             	test   %ax,%ax
80101efb:	78 20                	js     80101f1d <writei+0x3f>
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	7f 13                	jg     80101f1d <writei+0x3f>
80101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f11:	98                   	cwtl   
80101f12:	8b 04 c5 64 22 11 80 	mov    -0x7feedd9c(,%eax,8),%eax
80101f19:	85 c0                	test   %eax,%eax
80101f1b:	75 0a                	jne    80101f27 <writei+0x49>
      return -1;
80101f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f22:	e9 44 01 00 00       	jmp    8010206b <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2e:	98                   	cwtl   
80101f2f:	8b 04 c5 64 22 11 80 	mov    -0x7feedd9c(,%eax,8),%eax
80101f36:	8b 55 14             	mov    0x14(%ebp),%edx
80101f39:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f40:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f44:	8b 55 08             	mov    0x8(%ebp),%edx
80101f47:	89 14 24             	mov    %edx,(%esp)
80101f4a:	ff d0                	call   *%eax
80101f4c:	e9 1a 01 00 00       	jmp    8010206b <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f51:	8b 45 08             	mov    0x8(%ebp),%eax
80101f54:	8b 40 18             	mov    0x18(%eax),%eax
80101f57:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f5a:	72 0d                	jb     80101f69 <writei+0x8b>
80101f5c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f62:	01 d0                	add    %edx,%eax
80101f64:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f67:	73 0a                	jae    80101f73 <writei+0x95>
    return -1;
80101f69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6e:	e9 f8 00 00 00       	jmp    8010206b <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f73:	8b 45 14             	mov    0x14(%ebp),%eax
80101f76:	8b 55 10             	mov    0x10(%ebp),%edx
80101f79:	01 d0                	add    %edx,%eax
80101f7b:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f80:	76 0a                	jbe    80101f8c <writei+0xae>
    return -1;
80101f82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f87:	e9 df 00 00 00       	jmp    8010206b <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f93:	e9 9f 00 00 00       	jmp    80102037 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f98:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9b:	c1 e8 09             	shr    $0x9,%eax
80101f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa5:	89 04 24             	mov    %eax,(%esp)
80101fa8:	e8 62 fb ff ff       	call   80101b0f <bmap>
80101fad:	8b 55 08             	mov    0x8(%ebp),%edx
80101fb0:	8b 12                	mov    (%edx),%edx
80101fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb6:	89 14 24             	mov    %edx,(%esp)
80101fb9:	e8 e8 e1 ff ff       	call   801001a6 <bread>
80101fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc1:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc4:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc9:	89 c2                	mov    %eax,%edx
80101fcb:	b8 00 02 00 00       	mov    $0x200,%eax
80101fd0:	29 d0                	sub    %edx,%eax
80101fd2:	89 c2                	mov    %eax,%edx
80101fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fda:	29 c1                	sub    %eax,%ecx
80101fdc:	89 c8                	mov    %ecx,%eax
80101fde:	39 c2                	cmp    %eax,%edx
80101fe0:	0f 46 c2             	cmovbe %edx,%eax
80101fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fee:	8d 50 10             	lea    0x10(%eax),%edx
80101ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff4:	01 d0                	add    %edx,%eax
80101ff6:	8d 50 08             	lea    0x8(%eax),%edx
80101ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
80102000:	8b 45 0c             	mov    0xc(%ebp),%eax
80102003:	89 44 24 04          	mov    %eax,0x4(%esp)
80102007:	89 14 24             	mov    %edx,(%esp)
8010200a:	e8 b9 3e 00 00       	call   80105ec8 <memmove>
    log_write(bp);
8010200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102012:	89 04 24             	mov    %eax,(%esp)
80102015:	e8 13 16 00 00       	call   8010362d <log_write>
    brelse(bp);
8010201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010201d:	89 04 24             	mov    %eax,(%esp)
80102020:	e8 f2 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102025:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102028:	01 45 f4             	add    %eax,-0xc(%ebp)
8010202b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202e:	01 45 10             	add    %eax,0x10(%ebp)
80102031:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102034:	01 45 0c             	add    %eax,0xc(%ebp)
80102037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010203a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010203d:	0f 82 55 ff ff ff    	jb     80101f98 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102043:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102047:	74 1f                	je     80102068 <writei+0x18a>
80102049:	8b 45 08             	mov    0x8(%ebp),%eax
8010204c:	8b 40 18             	mov    0x18(%eax),%eax
8010204f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102052:	73 14                	jae    80102068 <writei+0x18a>
    ip->size = off;
80102054:	8b 45 08             	mov    0x8(%ebp),%eax
80102057:	8b 55 10             	mov    0x10(%ebp),%edx
8010205a:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010205d:	8b 45 08             	mov    0x8(%ebp),%eax
80102060:	89 04 24             	mov    %eax,(%esp)
80102063:	e8 49 f6 ff ff       	call   801016b1 <iupdate>
  }
  return n;
80102068:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010206b:	c9                   	leave  
8010206c:	c3                   	ret    

8010206d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010206d:	55                   	push   %ebp
8010206e:	89 e5                	mov    %esp,%ebp
80102070:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102073:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010207a:	00 
8010207b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102082:	8b 45 08             	mov    0x8(%ebp),%eax
80102085:	89 04 24             	mov    %eax,(%esp)
80102088:	e8 de 3e 00 00       	call   80105f6b <strncmp>
}
8010208d:	c9                   	leave  
8010208e:	c3                   	ret    

8010208f <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010208f:	55                   	push   %ebp
80102090:	89 e5                	mov    %esp,%ebp
80102092:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102095:	8b 45 08             	mov    0x8(%ebp),%eax
80102098:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010209c:	66 83 f8 01          	cmp    $0x1,%ax
801020a0:	74 0c                	je     801020ae <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020a2:	c7 04 24 45 93 10 80 	movl   $0x80109345,(%esp)
801020a9:	e8 8c e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020b5:	e9 88 00 00 00       	jmp    80102142 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ba:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020c1:	00 
801020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c5:	89 44 24 08          	mov    %eax,0x8(%esp)
801020c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801020d0:	8b 45 08             	mov    0x8(%ebp),%eax
801020d3:	89 04 24             	mov    %eax,(%esp)
801020d6:	e8 9f fc ff ff       	call   80101d7a <readi>
801020db:	83 f8 10             	cmp    $0x10,%eax
801020de:	74 0c                	je     801020ec <dirlookup+0x5d>
      panic("dirlink read");
801020e0:	c7 04 24 57 93 10 80 	movl   $0x80109357,(%esp)
801020e7:	e8 4e e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020ec:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020f0:	66 85 c0             	test   %ax,%ax
801020f3:	75 02                	jne    801020f7 <dirlookup+0x68>
      continue;
801020f5:	eb 47                	jmp    8010213e <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020fa:	83 c0 02             	add    $0x2,%eax
801020fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102101:	8b 45 0c             	mov    0xc(%ebp),%eax
80102104:	89 04 24             	mov    %eax,(%esp)
80102107:	e8 61 ff ff ff       	call   8010206d <namecmp>
8010210c:	85 c0                	test   %eax,%eax
8010210e:	75 2e                	jne    8010213e <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102114:	74 08                	je     8010211e <dirlookup+0x8f>
        *poff = off;
80102116:	8b 45 10             	mov    0x10(%ebp),%eax
80102119:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010211c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010211e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102122:	0f b7 c0             	movzwl %ax,%eax
80102125:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8b 00                	mov    (%eax),%eax
8010212d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102130:	89 54 24 04          	mov    %edx,0x4(%esp)
80102134:	89 04 24             	mov    %eax,(%esp)
80102137:	e8 2d f6 ff ff       	call   80101769 <iget>
8010213c:	eb 18                	jmp    80102156 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010213e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102142:	8b 45 08             	mov    0x8(%ebp),%eax
80102145:	8b 40 18             	mov    0x18(%eax),%eax
80102148:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010214b:	0f 87 69 ff ff ff    	ja     801020ba <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102151:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102156:	c9                   	leave  
80102157:	c3                   	ret    

80102158 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102158:	55                   	push   %ebp
80102159:	89 e5                	mov    %esp,%ebp
8010215b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010215e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102165:	00 
80102166:	8b 45 0c             	mov    0xc(%ebp),%eax
80102169:	89 44 24 04          	mov    %eax,0x4(%esp)
8010216d:	8b 45 08             	mov    0x8(%ebp),%eax
80102170:	89 04 24             	mov    %eax,(%esp)
80102173:	e8 17 ff ff ff       	call   8010208f <dirlookup>
80102178:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010217b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010217f:	74 15                	je     80102196 <dirlink+0x3e>
    iput(ip);
80102181:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102184:	89 04 24             	mov    %eax,(%esp)
80102187:	e8 94 f8 ff ff       	call   80101a20 <iput>
    return -1;
8010218c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102191:	e9 b7 00 00 00       	jmp    8010224d <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010219d:	eb 46                	jmp    801021e5 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021a2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021a9:	00 
801021aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801021ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b5:	8b 45 08             	mov    0x8(%ebp),%eax
801021b8:	89 04 24             	mov    %eax,(%esp)
801021bb:	e8 ba fb ff ff       	call   80101d7a <readi>
801021c0:	83 f8 10             	cmp    $0x10,%eax
801021c3:	74 0c                	je     801021d1 <dirlink+0x79>
      panic("dirlink read");
801021c5:	c7 04 24 57 93 10 80 	movl   $0x80109357,(%esp)
801021cc:	e8 69 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021d1:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d5:	66 85 c0             	test   %ax,%ax
801021d8:	75 02                	jne    801021dc <dirlink+0x84>
      break;
801021da:	eb 16                	jmp    801021f2 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021df:	83 c0 10             	add    $0x10,%eax
801021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021e8:	8b 45 08             	mov    0x8(%ebp),%eax
801021eb:	8b 40 18             	mov    0x18(%eax),%eax
801021ee:	39 c2                	cmp    %eax,%edx
801021f0:	72 ad                	jb     8010219f <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021f2:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021f9:	00 
801021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801021fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102201:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102204:	83 c0 02             	add    $0x2,%eax
80102207:	89 04 24             	mov    %eax,(%esp)
8010220a:	e8 b2 3d 00 00       	call   80105fc1 <strncpy>
  de.inum = inum;
8010220f:	8b 45 10             	mov    0x10(%ebp),%eax
80102212:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102219:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102220:	00 
80102221:	89 44 24 08          	mov    %eax,0x8(%esp)
80102225:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102228:	89 44 24 04          	mov    %eax,0x4(%esp)
8010222c:	8b 45 08             	mov    0x8(%ebp),%eax
8010222f:	89 04 24             	mov    %eax,(%esp)
80102232:	e8 a7 fc ff ff       	call   80101ede <writei>
80102237:	83 f8 10             	cmp    $0x10,%eax
8010223a:	74 0c                	je     80102248 <dirlink+0xf0>
    panic("dirlink");
8010223c:	c7 04 24 64 93 10 80 	movl   $0x80109364,(%esp)
80102243:	e8 f2 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102248:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010224d:	c9                   	leave  
8010224e:	c3                   	ret    

8010224f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010224f:	55                   	push   %ebp
80102250:	89 e5                	mov    %esp,%ebp
80102252:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102255:	eb 04                	jmp    8010225b <skipelem+0xc>
    path++;
80102257:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010225b:	8b 45 08             	mov    0x8(%ebp),%eax
8010225e:	0f b6 00             	movzbl (%eax),%eax
80102261:	3c 2f                	cmp    $0x2f,%al
80102263:	74 f2                	je     80102257 <skipelem+0x8>
    path++;
  if(*path == 0)
80102265:	8b 45 08             	mov    0x8(%ebp),%eax
80102268:	0f b6 00             	movzbl (%eax),%eax
8010226b:	84 c0                	test   %al,%al
8010226d:	75 0a                	jne    80102279 <skipelem+0x2a>
    return 0;
8010226f:	b8 00 00 00 00       	mov    $0x0,%eax
80102274:	e9 86 00 00 00       	jmp    801022ff <skipelem+0xb0>
  s = path;
80102279:	8b 45 08             	mov    0x8(%ebp),%eax
8010227c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010227f:	eb 04                	jmp    80102285 <skipelem+0x36>
    path++;
80102281:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102285:	8b 45 08             	mov    0x8(%ebp),%eax
80102288:	0f b6 00             	movzbl (%eax),%eax
8010228b:	3c 2f                	cmp    $0x2f,%al
8010228d:	74 0a                	je     80102299 <skipelem+0x4a>
8010228f:	8b 45 08             	mov    0x8(%ebp),%eax
80102292:	0f b6 00             	movzbl (%eax),%eax
80102295:	84 c0                	test   %al,%al
80102297:	75 e8                	jne    80102281 <skipelem+0x32>
    path++;
  len = path - s;
80102299:	8b 55 08             	mov    0x8(%ebp),%edx
8010229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229f:	29 c2                	sub    %eax,%edx
801022a1:	89 d0                	mov    %edx,%eax
801022a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022a6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022aa:	7e 1c                	jle    801022c8 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022ac:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022b3:	00 
801022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801022bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801022be:	89 04 24             	mov    %eax,(%esp)
801022c1:	e8 02 3c 00 00       	call   80105ec8 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022c6:	eb 2a                	jmp    801022f2 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801022d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d9:	89 04 24             	mov    %eax,(%esp)
801022dc:	e8 e7 3b 00 00       	call   80105ec8 <memmove>
    name[len] = 0;
801022e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e7:	01 d0                	add    %edx,%eax
801022e9:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022ec:	eb 04                	jmp    801022f2 <skipelem+0xa3>
    path++;
801022ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	0f b6 00             	movzbl (%eax),%eax
801022f8:	3c 2f                	cmp    $0x2f,%al
801022fa:	74 f2                	je     801022ee <skipelem+0x9f>
    path++;
  return path;
801022fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ff:	c9                   	leave  
80102300:	c3                   	ret    

80102301 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102301:	55                   	push   %ebp
80102302:	89 e5                	mov    %esp,%ebp
80102304:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102307:	8b 45 08             	mov    0x8(%ebp),%eax
8010230a:	0f b6 00             	movzbl (%eax),%eax
8010230d:	3c 2f                	cmp    $0x2f,%al
8010230f:	75 1c                	jne    8010232d <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102318:	00 
80102319:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102320:	e8 44 f4 ff ff       	call   80101769 <iget>
80102325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102328:	e9 af 00 00 00       	jmp    801023dc <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010232d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102333:	8b 40 68             	mov    0x68(%eax),%eax
80102336:	89 04 24             	mov    %eax,(%esp)
80102339:	e8 fd f4 ff ff       	call   8010183b <idup>
8010233e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102341:	e9 96 00 00 00       	jmp    801023dc <namex+0xdb>
    ilock(ip);
80102346:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102349:	89 04 24             	mov    %eax,(%esp)
8010234c:	e8 1c f5 ff ff       	call   8010186d <ilock>
    if(ip->type != T_DIR){
80102351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102354:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102358:	66 83 f8 01          	cmp    $0x1,%ax
8010235c:	74 15                	je     80102373 <namex+0x72>
      iunlockput(ip);
8010235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102361:	89 04 24             	mov    %eax,(%esp)
80102364:	e8 88 f7 ff ff       	call   80101af1 <iunlockput>
      return 0;
80102369:	b8 00 00 00 00       	mov    $0x0,%eax
8010236e:	e9 a3 00 00 00       	jmp    80102416 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102373:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102377:	74 1d                	je     80102396 <namex+0x95>
80102379:	8b 45 08             	mov    0x8(%ebp),%eax
8010237c:	0f b6 00             	movzbl (%eax),%eax
8010237f:	84 c0                	test   %al,%al
80102381:	75 13                	jne    80102396 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102386:	89 04 24             	mov    %eax,(%esp)
80102389:	e8 2d f6 ff ff       	call   801019bb <iunlock>
      return ip;
8010238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102391:	e9 80 00 00 00       	jmp    80102416 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102396:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010239d:	00 
8010239e:	8b 45 10             	mov    0x10(%ebp),%eax
801023a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a8:	89 04 24             	mov    %eax,(%esp)
801023ab:	e8 df fc ff ff       	call   8010208f <dirlookup>
801023b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023b7:	75 12                	jne    801023cb <namex+0xca>
      iunlockput(ip);
801023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bc:	89 04 24             	mov    %eax,(%esp)
801023bf:	e8 2d f7 ff ff       	call   80101af1 <iunlockput>
      return 0;
801023c4:	b8 00 00 00 00       	mov    $0x0,%eax
801023c9:	eb 4b                	jmp    80102416 <namex+0x115>
    }
    iunlockput(ip);
801023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ce:	89 04 24             	mov    %eax,(%esp)
801023d1:	e8 1b f7 ff ff       	call   80101af1 <iunlockput>
    ip = next;
801023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023dc:	8b 45 10             	mov    0x10(%ebp),%eax
801023df:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e3:	8b 45 08             	mov    0x8(%ebp),%eax
801023e6:	89 04 24             	mov    %eax,(%esp)
801023e9:	e8 61 fe ff ff       	call   8010224f <skipelem>
801023ee:	89 45 08             	mov    %eax,0x8(%ebp)
801023f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023f5:	0f 85 4b ff ff ff    	jne    80102346 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023ff:	74 12                	je     80102413 <namex+0x112>
    iput(ip);
80102401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102404:	89 04 24             	mov    %eax,(%esp)
80102407:	e8 14 f6 ff ff       	call   80101a20 <iput>
    return 0;
8010240c:	b8 00 00 00 00       	mov    $0x0,%eax
80102411:	eb 03                	jmp    80102416 <namex+0x115>
  }
  return ip;
80102413:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102416:	c9                   	leave  
80102417:	c3                   	ret    

80102418 <namei>:

struct inode*
namei(char *path)
{
80102418:	55                   	push   %ebp
80102419:	89 e5                	mov    %esp,%ebp
8010241b:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010241e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102421:	89 44 24 08          	mov    %eax,0x8(%esp)
80102425:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010242c:	00 
8010242d:	8b 45 08             	mov    0x8(%ebp),%eax
80102430:	89 04 24             	mov    %eax,(%esp)
80102433:	e8 c9 fe ff ff       	call   80102301 <namex>
}
80102438:	c9                   	leave  
80102439:	c3                   	ret    

8010243a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010243a:	55                   	push   %ebp
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102440:	8b 45 0c             	mov    0xc(%ebp),%eax
80102443:	89 44 24 08          	mov    %eax,0x8(%esp)
80102447:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010244e:	00 
8010244f:	8b 45 08             	mov    0x8(%ebp),%eax
80102452:	89 04 24             	mov    %eax,(%esp)
80102455:	e8 a7 fe ff ff       	call   80102301 <namex>
}
8010245a:	c9                   	leave  
8010245b:	c3                   	ret    

8010245c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010245c:	55                   	push   %ebp
8010245d:	89 e5                	mov    %esp,%ebp
8010245f:	83 ec 14             	sub    $0x14,%esp
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102469:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010246d:	89 c2                	mov    %eax,%edx
8010246f:	ec                   	in     (%dx),%al
80102470:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102473:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102477:	c9                   	leave  
80102478:	c3                   	ret    

80102479 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102479:	55                   	push   %ebp
8010247a:	89 e5                	mov    %esp,%ebp
8010247c:	57                   	push   %edi
8010247d:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247e:	8b 55 08             	mov    0x8(%ebp),%edx
80102481:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102484:	8b 45 10             	mov    0x10(%ebp),%eax
80102487:	89 cb                	mov    %ecx,%ebx
80102489:	89 df                	mov    %ebx,%edi
8010248b:	89 c1                	mov    %eax,%ecx
8010248d:	fc                   	cld    
8010248e:	f3 6d                	rep insl (%dx),%es:(%edi)
80102490:	89 c8                	mov    %ecx,%eax
80102492:	89 fb                	mov    %edi,%ebx
80102494:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102497:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010249a:	5b                   	pop    %ebx
8010249b:	5f                   	pop    %edi
8010249c:	5d                   	pop    %ebp
8010249d:	c3                   	ret    

8010249e <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249e:	55                   	push   %ebp
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	83 ec 08             	sub    $0x8,%esp
801024a4:	8b 55 08             	mov    0x8(%ebp),%edx
801024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801024aa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024ae:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024b9:	ee                   	out    %al,(%dx)
}
801024ba:	c9                   	leave  
801024bb:	c3                   	ret    

801024bc <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024bc:	55                   	push   %ebp
801024bd:	89 e5                	mov    %esp,%ebp
801024bf:	56                   	push   %esi
801024c0:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024c1:	8b 55 08             	mov    0x8(%ebp),%edx
801024c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c7:	8b 45 10             	mov    0x10(%ebp),%eax
801024ca:	89 cb                	mov    %ecx,%ebx
801024cc:	89 de                	mov    %ebx,%esi
801024ce:	89 c1                	mov    %eax,%ecx
801024d0:	fc                   	cld    
801024d1:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024d3:	89 c8                	mov    %ecx,%eax
801024d5:	89 f3                	mov    %esi,%ebx
801024d7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024da:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024dd:	5b                   	pop    %ebx
801024de:	5e                   	pop    %esi
801024df:	5d                   	pop    %ebp
801024e0:	c3                   	ret    

801024e1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024e1:	55                   	push   %ebp
801024e2:	89 e5                	mov    %esp,%ebp
801024e4:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e7:	90                   	nop
801024e8:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024ef:	e8 68 ff ff ff       	call   8010245c <inb>
801024f4:	0f b6 c0             	movzbl %al,%eax
801024f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fd:	25 c0 00 00 00       	and    $0xc0,%eax
80102502:	83 f8 40             	cmp    $0x40,%eax
80102505:	75 e1                	jne    801024e8 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010250b:	74 11                	je     8010251e <idewait+0x3d>
8010250d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102510:	83 e0 21             	and    $0x21,%eax
80102513:	85 c0                	test   %eax,%eax
80102515:	74 07                	je     8010251e <idewait+0x3d>
    return -1;
80102517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010251c:	eb 05                	jmp    80102523 <idewait+0x42>
  return 0;
8010251e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102523:	c9                   	leave  
80102524:	c3                   	ret    

80102525 <ideinit>:

void
ideinit(void)
{
80102525:	55                   	push   %ebp
80102526:	89 e5                	mov    %esp,%ebp
80102528:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010252b:	c7 44 24 04 6c 93 10 	movl   $0x8010936c,0x4(%esp)
80102532:	80 
80102533:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010253a:	e8 45 36 00 00       	call   80105b84 <initlock>
  picenable(IRQ_IDE);
8010253f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102546:	e8 7b 18 00 00       	call   80103dc6 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254b:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80102550:	83 e8 01             	sub    $0x1,%eax
80102553:	89 44 24 04          	mov    %eax,0x4(%esp)
80102557:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255e:	e8 0c 04 00 00       	call   8010296f <ioapicenable>
  idewait(0);
80102563:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010256a:	e8 72 ff ff ff       	call   801024e1 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010256f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102576:	00 
80102577:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257e:	e8 1b ff ff ff       	call   8010249e <outb>
  for(i=0; i<1000; i++){
80102583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010258a:	eb 20                	jmp    801025ac <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010258c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102593:	e8 c4 fe ff ff       	call   8010245c <inb>
80102598:	84 c0                	test   %al,%al
8010259a:	74 0c                	je     801025a8 <ideinit+0x83>
      havedisk1 = 1;
8010259c:	c7 05 b8 c6 10 80 01 	movl   $0x1,0x8010c6b8
801025a3:	00 00 00 
      break;
801025a6:	eb 0d                	jmp    801025b5 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ac:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025b3:	7e d7                	jle    8010258c <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b5:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025bc:	00 
801025bd:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c4:	e8 d5 fe ff ff       	call   8010249e <outb>
}
801025c9:	c9                   	leave  
801025ca:	c3                   	ret    

801025cb <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025cb:	55                   	push   %ebp
801025cc:	89 e5                	mov    %esp,%ebp
801025ce:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d5:	75 0c                	jne    801025e3 <idestart+0x18>
    panic("idestart");
801025d7:	c7 04 24 70 93 10 80 	movl   $0x80109370,(%esp)
801025de:	e8 57 df ff ff       	call   8010053a <panic>

  idewait(0);
801025e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025ea:	e8 f2 fe ff ff       	call   801024e1 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f6:	00 
801025f7:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025fe:	e8 9b fe ff ff       	call   8010249e <outb>
  outb(0x1f2, 1);  // number of sectors
80102603:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010260a:	00 
8010260b:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102612:	e8 87 fe ff ff       	call   8010249e <outb>
  outb(0x1f3, b->sector & 0xff);
80102617:	8b 45 08             	mov    0x8(%ebp),%eax
8010261a:	8b 40 08             	mov    0x8(%eax),%eax
8010261d:	0f b6 c0             	movzbl %al,%eax
80102620:	89 44 24 04          	mov    %eax,0x4(%esp)
80102624:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010262b:	e8 6e fe ff ff       	call   8010249e <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102630:	8b 45 08             	mov    0x8(%ebp),%eax
80102633:	8b 40 08             	mov    0x8(%eax),%eax
80102636:	c1 e8 08             	shr    $0x8,%eax
80102639:	0f b6 c0             	movzbl %al,%eax
8010263c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102640:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102647:	e8 52 fe ff ff       	call   8010249e <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010264c:	8b 45 08             	mov    0x8(%ebp),%eax
8010264f:	8b 40 08             	mov    0x8(%eax),%eax
80102652:	c1 e8 10             	shr    $0x10,%eax
80102655:	0f b6 c0             	movzbl %al,%eax
80102658:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265c:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102663:	e8 36 fe ff ff       	call   8010249e <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102668:	8b 45 08             	mov    0x8(%ebp),%eax
8010266b:	8b 40 04             	mov    0x4(%eax),%eax
8010266e:	83 e0 01             	and    $0x1,%eax
80102671:	c1 e0 04             	shl    $0x4,%eax
80102674:	89 c2                	mov    %eax,%edx
80102676:	8b 45 08             	mov    0x8(%ebp),%eax
80102679:	8b 40 08             	mov    0x8(%eax),%eax
8010267c:	c1 e8 18             	shr    $0x18,%eax
8010267f:	83 e0 0f             	and    $0xf,%eax
80102682:	09 d0                	or     %edx,%eax
80102684:	83 c8 e0             	or     $0xffffffe0,%eax
80102687:	0f b6 c0             	movzbl %al,%eax
8010268a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102695:	e8 04 fe ff ff       	call   8010249e <outb>
  if(b->flags & B_DIRTY){
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
8010269d:	8b 00                	mov    (%eax),%eax
8010269f:	83 e0 04             	and    $0x4,%eax
801026a2:	85 c0                	test   %eax,%eax
801026a4:	74 34                	je     801026da <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a6:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ad:	00 
801026ae:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b5:	e8 e4 fd ff ff       	call   8010249e <outb>
    outsl(0x1f0, b->data, 512/4);
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
801026bd:	83 c0 18             	add    $0x18,%eax
801026c0:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c7:	00 
801026c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cc:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026d3:	e8 e4 fd ff ff       	call   801024bc <outsl>
801026d8:	eb 14                	jmp    801026ee <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026da:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026e1:	00 
801026e2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026e9:	e8 b0 fd ff ff       	call   8010249e <outb>
  }
}
801026ee:	c9                   	leave  
801026ef:	c3                   	ret    

801026f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f6:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801026fd:	e8 a3 34 00 00       	call   80105ba5 <acquire>
  if((b = idequeue) == 0){
80102702:	a1 b4 c6 10 80       	mov    0x8010c6b4,%eax
80102707:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270e:	75 11                	jne    80102721 <ideintr+0x31>
    release(&idelock);
80102710:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80102717:	e8 eb 34 00 00       	call   80105c07 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271c:	e9 90 00 00 00       	jmp    801027b1 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102724:	8b 40 14             	mov    0x14(%eax),%eax
80102727:	a3 b4 c6 10 80       	mov    %eax,0x8010c6b4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272f:	8b 00                	mov    (%eax),%eax
80102731:	83 e0 04             	and    $0x4,%eax
80102734:	85 c0                	test   %eax,%eax
80102736:	75 2e                	jne    80102766 <ideintr+0x76>
80102738:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010273f:	e8 9d fd ff ff       	call   801024e1 <idewait>
80102744:	85 c0                	test   %eax,%eax
80102746:	78 1e                	js     80102766 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274b:	83 c0 18             	add    $0x18,%eax
8010274e:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102755:	00 
80102756:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275a:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102761:	e8 13 fd ff ff       	call   80102479 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102769:	8b 00                	mov    (%eax),%eax
8010276b:	83 c8 02             	or     $0x2,%eax
8010276e:	89 c2                	mov    %eax,%edx
80102770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102773:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102778:	8b 00                	mov    (%eax),%eax
8010277a:	83 e0 fb             	and    $0xfffffffb,%eax
8010277d:	89 c2                	mov    %eax,%edx
8010277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102782:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102787:	89 04 24             	mov    %eax,(%esp)
8010278a:	e8 8d 2b 00 00       	call   8010531c <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010278f:	a1 b4 c6 10 80       	mov    0x8010c6b4,%eax
80102794:	85 c0                	test   %eax,%eax
80102796:	74 0d                	je     801027a5 <ideintr+0xb5>
    idestart(idequeue);
80102798:	a1 b4 c6 10 80       	mov    0x8010c6b4,%eax
8010279d:	89 04 24             	mov    %eax,(%esp)
801027a0:	e8 26 fe ff ff       	call   801025cb <idestart>

  release(&idelock);
801027a5:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801027ac:	e8 56 34 00 00       	call   80105c07 <release>
}
801027b1:	c9                   	leave  
801027b2:	c3                   	ret    

801027b3 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b3:	55                   	push   %ebp
801027b4:	89 e5                	mov    %esp,%ebp
801027b6:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027b9:	8b 45 08             	mov    0x8(%ebp),%eax
801027bc:	8b 00                	mov    (%eax),%eax
801027be:	83 e0 01             	and    $0x1,%eax
801027c1:	85 c0                	test   %eax,%eax
801027c3:	75 0c                	jne    801027d1 <iderw+0x1e>
    panic("iderw: buf not busy");
801027c5:	c7 04 24 79 93 10 80 	movl   $0x80109379,(%esp)
801027cc:	e8 69 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d1:	8b 45 08             	mov    0x8(%ebp),%eax
801027d4:	8b 00                	mov    (%eax),%eax
801027d6:	83 e0 06             	and    $0x6,%eax
801027d9:	83 f8 02             	cmp    $0x2,%eax
801027dc:	75 0c                	jne    801027ea <iderw+0x37>
    panic("iderw: nothing to do");
801027de:	c7 04 24 8d 93 10 80 	movl   $0x8010938d,(%esp)
801027e5:	e8 50 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027ea:	8b 45 08             	mov    0x8(%ebp),%eax
801027ed:	8b 40 04             	mov    0x4(%eax),%eax
801027f0:	85 c0                	test   %eax,%eax
801027f2:	74 15                	je     80102809 <iderw+0x56>
801027f4:	a1 b8 c6 10 80       	mov    0x8010c6b8,%eax
801027f9:	85 c0                	test   %eax,%eax
801027fb:	75 0c                	jne    80102809 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fd:	c7 04 24 a2 93 10 80 	movl   $0x801093a2,(%esp)
80102804:	e8 31 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102809:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80102810:	e8 90 33 00 00       	call   80105ba5 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102815:	8b 45 08             	mov    0x8(%ebp),%eax
80102818:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010281f:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80102826:	eb 0b                	jmp    80102833 <iderw+0x80>
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	8b 00                	mov    (%eax),%eax
8010282d:	83 c0 14             	add    $0x14,%eax
80102830:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	8b 00                	mov    (%eax),%eax
80102838:	85 c0                	test   %eax,%eax
8010283a:	75 ec                	jne    80102828 <iderw+0x75>
    ;
  *pp = b;
8010283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283f:	8b 55 08             	mov    0x8(%ebp),%edx
80102842:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102844:	a1 b4 c6 10 80       	mov    0x8010c6b4,%eax
80102849:	3b 45 08             	cmp    0x8(%ebp),%eax
8010284c:	75 0d                	jne    8010285b <iderw+0xa8>
    idestart(b);
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	89 04 24             	mov    %eax,(%esp)
80102854:	e8 72 fd ff ff       	call   801025cb <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102859:	eb 15                	jmp    80102870 <iderw+0xbd>
8010285b:	eb 13                	jmp    80102870 <iderw+0xbd>
    sleep(b, &idelock);
8010285d:	c7 44 24 04 80 c6 10 	movl   $0x8010c680,0x4(%esp)
80102864:	80 
80102865:	8b 45 08             	mov    0x8(%ebp),%eax
80102868:	89 04 24             	mov    %eax,(%esp)
8010286b:	e8 69 28 00 00       	call   801050d9 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102870:	8b 45 08             	mov    0x8(%ebp),%eax
80102873:	8b 00                	mov    (%eax),%eax
80102875:	83 e0 06             	and    $0x6,%eax
80102878:	83 f8 02             	cmp    $0x2,%eax
8010287b:	75 e0                	jne    8010285d <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010287d:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80102884:	e8 7e 33 00 00       	call   80105c07 <release>
}
80102889:	c9                   	leave  
8010288a:	c3                   	ret    

8010288b <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010288b:	55                   	push   %ebp
8010288c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010288e:	a1 94 32 11 80       	mov    0x80113294,%eax
80102893:	8b 55 08             	mov    0x8(%ebp),%edx
80102896:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102898:	a1 94 32 11 80       	mov    0x80113294,%eax
8010289d:	8b 40 10             	mov    0x10(%eax),%eax
}
801028a0:	5d                   	pop    %ebp
801028a1:	c3                   	ret    

801028a2 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028a2:	55                   	push   %ebp
801028a3:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028a5:	a1 94 32 11 80       	mov    0x80113294,%eax
801028aa:	8b 55 08             	mov    0x8(%ebp),%edx
801028ad:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028af:	a1 94 32 11 80       	mov    0x80113294,%eax
801028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801028b7:	89 50 10             	mov    %edx,0x10(%eax)
}
801028ba:	5d                   	pop    %ebp
801028bb:	c3                   	ret    

801028bc <ioapicinit>:

void
ioapicinit(void)
{
801028bc:	55                   	push   %ebp
801028bd:	89 e5                	mov    %esp,%ebp
801028bf:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028c2:	a1 c4 33 11 80       	mov    0x801133c4,%eax
801028c7:	85 c0                	test   %eax,%eax
801028c9:	75 05                	jne    801028d0 <ioapicinit+0x14>
    return;
801028cb:	e9 9d 00 00 00       	jmp    8010296d <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d0:	c7 05 94 32 11 80 00 	movl   $0xfec00000,0x80113294
801028d7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028e1:	e8 a5 ff ff ff       	call   8010288b <ioapicread>
801028e6:	c1 e8 10             	shr    $0x10,%eax
801028e9:	25 ff 00 00 00       	and    $0xff,%eax
801028ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028f8:	e8 8e ff ff ff       	call   8010288b <ioapicread>
801028fd:	c1 e8 18             	shr    $0x18,%eax
80102900:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102903:	0f b6 05 c0 33 11 80 	movzbl 0x801133c0,%eax
8010290a:	0f b6 c0             	movzbl %al,%eax
8010290d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102910:	74 0c                	je     8010291e <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102912:	c7 04 24 c0 93 10 80 	movl   $0x801093c0,(%esp)
80102919:	e8 82 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010291e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102925:	eb 3e                	jmp    80102965 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292a:	83 c0 20             	add    $0x20,%eax
8010292d:	0d 00 00 01 00       	or     $0x10000,%eax
80102932:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102935:	83 c2 08             	add    $0x8,%edx
80102938:	01 d2                	add    %edx,%edx
8010293a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010293e:	89 14 24             	mov    %edx,(%esp)
80102941:	e8 5c ff ff ff       	call   801028a2 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102949:	83 c0 08             	add    $0x8,%eax
8010294c:	01 c0                	add    %eax,%eax
8010294e:	83 c0 01             	add    $0x1,%eax
80102951:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102958:	00 
80102959:	89 04 24             	mov    %eax,(%esp)
8010295c:	e8 41 ff ff ff       	call   801028a2 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102961:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102968:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010296b:	7e ba                	jle    80102927 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010296d:	c9                   	leave  
8010296e:	c3                   	ret    

8010296f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010296f:	55                   	push   %ebp
80102970:	89 e5                	mov    %esp,%ebp
80102972:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102975:	a1 c4 33 11 80       	mov    0x801133c4,%eax
8010297a:	85 c0                	test   %eax,%eax
8010297c:	75 02                	jne    80102980 <ioapicenable+0x11>
    return;
8010297e:	eb 37                	jmp    801029b7 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102980:	8b 45 08             	mov    0x8(%ebp),%eax
80102983:	83 c0 20             	add    $0x20,%eax
80102986:	8b 55 08             	mov    0x8(%ebp),%edx
80102989:	83 c2 08             	add    $0x8,%edx
8010298c:	01 d2                	add    %edx,%edx
8010298e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102992:	89 14 24             	mov    %edx,(%esp)
80102995:	e8 08 ff ff ff       	call   801028a2 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010299d:	c1 e0 18             	shl    $0x18,%eax
801029a0:	8b 55 08             	mov    0x8(%ebp),%edx
801029a3:	83 c2 08             	add    $0x8,%edx
801029a6:	01 d2                	add    %edx,%edx
801029a8:	83 c2 01             	add    $0x1,%edx
801029ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801029af:	89 14 24             	mov    %edx,(%esp)
801029b2:	e8 eb fe ff ff       	call   801028a2 <ioapicwrite>
}
801029b7:	c9                   	leave  
801029b8:	c3                   	ret    

801029b9 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029b9:	55                   	push   %ebp
801029ba:	89 e5                	mov    %esp,%ebp
801029bc:	8b 45 08             	mov    0x8(%ebp),%eax
801029bf:	05 00 00 00 80       	add    $0x80000000,%eax
801029c4:	5d                   	pop    %ebp
801029c5:	c3                   	ret    

801029c6 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029c6:	55                   	push   %ebp
801029c7:	89 e5                	mov    %esp,%ebp
801029c9:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029cc:	c7 44 24 04 f2 93 10 	movl   $0x801093f2,0x4(%esp)
801029d3:	80 
801029d4:	c7 04 24 a0 32 11 80 	movl   $0x801132a0,(%esp)
801029db:	e8 a4 31 00 00       	call   80105b84 <initlock>
  kmem.use_lock = 0;
801029e0:	c7 05 d4 32 11 80 00 	movl   $0x0,0x801132d4
801029e7:	00 00 00 
  freerange(vstart, vend);
801029ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f1:	8b 45 08             	mov    0x8(%ebp),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 26 00 00 00       	call   80102a22 <freerange>
}
801029fc:	c9                   	leave  
801029fd:	c3                   	ret    

801029fe <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029fe:	55                   	push   %ebp
801029ff:	89 e5                	mov    %esp,%ebp
80102a01:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0e:	89 04 24             	mov    %eax,(%esp)
80102a11:	e8 0c 00 00 00       	call   80102a22 <freerange>
  kmem.use_lock = 1;
80102a16:	c7 05 d4 32 11 80 01 	movl   $0x1,0x801132d4
80102a1d:	00 00 00 
}
80102a20:	c9                   	leave  
80102a21:	c3                   	ret    

80102a22 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a22:	55                   	push   %ebp
80102a23:	89 e5                	mov    %esp,%ebp
80102a25:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a28:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a38:	eb 12                	jmp    80102a4c <freerange+0x2a>
    kfree(p);
80102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3d:	89 04 24             	mov    %eax,(%esp)
80102a40:	e8 16 00 00 00       	call   80102a5b <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a45:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4f:	05 00 10 00 00       	add    $0x1000,%eax
80102a54:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a57:	76 e1                	jbe    80102a3a <freerange+0x18>
    kfree(p);
}
80102a59:	c9                   	leave  
80102a5a:	c3                   	ret    

80102a5b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a5b:	55                   	push   %ebp
80102a5c:	89 e5                	mov    %esp,%ebp
80102a5e:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a61:	8b 45 08             	mov    0x8(%ebp),%eax
80102a64:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a69:	85 c0                	test   %eax,%eax
80102a6b:	75 1b                	jne    80102a88 <kfree+0x2d>
80102a6d:	81 7d 08 7c a0 11 80 	cmpl   $0x8011a07c,0x8(%ebp)
80102a74:	72 12                	jb     80102a88 <kfree+0x2d>
80102a76:	8b 45 08             	mov    0x8(%ebp),%eax
80102a79:	89 04 24             	mov    %eax,(%esp)
80102a7c:	e8 38 ff ff ff       	call   801029b9 <v2p>
80102a81:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a86:	76 0c                	jbe    80102a94 <kfree+0x39>
    panic("kfree");
80102a88:	c7 04 24 f7 93 10 80 	movl   $0x801093f7,(%esp)
80102a8f:	e8 a6 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a94:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a9b:	00 
80102a9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aa3:	00 
80102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa7:	89 04 24             	mov    %eax,(%esp)
80102aaa:	e8 4a 33 00 00       	call   80105df9 <memset>

  if(kmem.use_lock)
80102aaf:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102ab4:	85 c0                	test   %eax,%eax
80102ab6:	74 0c                	je     80102ac4 <kfree+0x69>
    acquire(&kmem.lock);
80102ab8:	c7 04 24 a0 32 11 80 	movl   $0x801132a0,(%esp)
80102abf:	e8 e1 30 00 00       	call   80105ba5 <acquire>
  r = (struct run*)v;
80102ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102aca:	8b 15 d8 32 11 80    	mov    0x801132d8,%edx
80102ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad3:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad8:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  if(kmem.use_lock)
80102add:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102ae2:	85 c0                	test   %eax,%eax
80102ae4:	74 0c                	je     80102af2 <kfree+0x97>
    release(&kmem.lock);
80102ae6:	c7 04 24 a0 32 11 80 	movl   $0x801132a0,(%esp)
80102aed:	e8 15 31 00 00       	call   80105c07 <release>
}
80102af2:	c9                   	leave  
80102af3:	c3                   	ret    

80102af4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102af4:	55                   	push   %ebp
80102af5:	89 e5                	mov    %esp,%ebp
80102af7:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102afa:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102aff:	85 c0                	test   %eax,%eax
80102b01:	74 0c                	je     80102b0f <kalloc+0x1b>
    acquire(&kmem.lock);
80102b03:	c7 04 24 a0 32 11 80 	movl   $0x801132a0,(%esp)
80102b0a:	e8 96 30 00 00       	call   80105ba5 <acquire>
  r = kmem.freelist;
80102b0f:	a1 d8 32 11 80       	mov    0x801132d8,%eax
80102b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b1b:	74 0a                	je     80102b27 <kalloc+0x33>
    kmem.freelist = r->next;
80102b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b20:	8b 00                	mov    (%eax),%eax
80102b22:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  if(kmem.use_lock)
80102b27:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80102b2c:	85 c0                	test   %eax,%eax
80102b2e:	74 0c                	je     80102b3c <kalloc+0x48>
    release(&kmem.lock);
80102b30:	c7 04 24 a0 32 11 80 	movl   $0x801132a0,(%esp)
80102b37:	e8 cb 30 00 00       	call   80105c07 <release>
  return (char*)r;
80102b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b3f:	c9                   	leave  
80102b40:	c3                   	ret    

80102b41 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b41:	55                   	push   %ebp
80102b42:	89 e5                	mov    %esp,%ebp
80102b44:	83 ec 14             	sub    $0x14,%esp
80102b47:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b52:	89 c2                	mov    %eax,%edx
80102b54:	ec                   	in     (%dx),%al
80102b55:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b58:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b5c:	c9                   	leave  
80102b5d:	c3                   	ret    

80102b5e <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b5e:	55                   	push   %ebp
80102b5f:	89 e5                	mov    %esp,%ebp
80102b61:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b64:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b6b:	e8 d1 ff ff ff       	call   80102b41 <inb>
80102b70:	0f b6 c0             	movzbl %al,%eax
80102b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b79:	83 e0 01             	and    $0x1,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	75 0a                	jne    80102b8a <kbdgetc+0x2c>
    return -1;
80102b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b85:	e9 25 01 00 00       	jmp    80102caf <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b8a:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b91:	e8 ab ff ff ff       	call   80102b41 <inb>
80102b96:	0f b6 c0             	movzbl %al,%eax
80102b99:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b9c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ba3:	75 17                	jne    80102bbc <kbdgetc+0x5e>
    shift |= E0ESC;
80102ba5:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102baa:	83 c8 40             	or     $0x40,%eax
80102bad:	a3 bc c6 10 80       	mov    %eax,0x8010c6bc
    return 0;
80102bb2:	b8 00 00 00 00       	mov    $0x0,%eax
80102bb7:	e9 f3 00 00 00       	jmp    80102caf <kbdgetc+0x151>
  } else if(data & 0x80){
80102bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bbf:	25 80 00 00 00       	and    $0x80,%eax
80102bc4:	85 c0                	test   %eax,%eax
80102bc6:	74 45                	je     80102c0d <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bc8:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102bcd:	83 e0 40             	and    $0x40,%eax
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	75 08                	jne    80102bdc <kbdgetc+0x7e>
80102bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd7:	83 e0 7f             	and    $0x7f,%eax
80102bda:	eb 03                	jmp    80102bdf <kbdgetc+0x81>
80102bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102be5:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102bea:	0f b6 00             	movzbl (%eax),%eax
80102bed:	83 c8 40             	or     $0x40,%eax
80102bf0:	0f b6 c0             	movzbl %al,%eax
80102bf3:	f7 d0                	not    %eax
80102bf5:	89 c2                	mov    %eax,%edx
80102bf7:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102bfc:	21 d0                	and    %edx,%eax
80102bfe:	a3 bc c6 10 80       	mov    %eax,0x8010c6bc
    return 0;
80102c03:	b8 00 00 00 00       	mov    $0x0,%eax
80102c08:	e9 a2 00 00 00       	jmp    80102caf <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c0d:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102c12:	83 e0 40             	and    $0x40,%eax
80102c15:	85 c0                	test   %eax,%eax
80102c17:	74 14                	je     80102c2d <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c19:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c20:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102c25:	83 e0 bf             	and    $0xffffffbf,%eax
80102c28:	a3 bc c6 10 80       	mov    %eax,0x8010c6bc
  }

  shift |= shiftcode[data];
80102c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c30:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c35:	0f b6 00             	movzbl (%eax),%eax
80102c38:	0f b6 d0             	movzbl %al,%edx
80102c3b:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102c40:	09 d0                	or     %edx,%eax
80102c42:	a3 bc c6 10 80       	mov    %eax,0x8010c6bc
  shift ^= togglecode[data];
80102c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4a:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c4f:	0f b6 00             	movzbl (%eax),%eax
80102c52:	0f b6 d0             	movzbl %al,%edx
80102c55:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102c5a:	31 d0                	xor    %edx,%eax
80102c5c:	a3 bc c6 10 80       	mov    %eax,0x8010c6bc
  c = charcode[shift & (CTL | SHIFT)][data];
80102c61:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102c66:	83 e0 03             	and    $0x3,%eax
80102c69:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c73:	01 d0                	add    %edx,%eax
80102c75:	0f b6 00             	movzbl (%eax),%eax
80102c78:	0f b6 c0             	movzbl %al,%eax
80102c7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c7e:	a1 bc c6 10 80       	mov    0x8010c6bc,%eax
80102c83:	83 e0 08             	and    $0x8,%eax
80102c86:	85 c0                	test   %eax,%eax
80102c88:	74 22                	je     80102cac <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c8a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c8e:	76 0c                	jbe    80102c9c <kbdgetc+0x13e>
80102c90:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c94:	77 06                	ja     80102c9c <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c96:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c9a:	eb 10                	jmp    80102cac <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c9c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ca0:	76 0a                	jbe    80102cac <kbdgetc+0x14e>
80102ca2:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ca6:	77 04                	ja     80102cac <kbdgetc+0x14e>
      c += 'a' - 'A';
80102ca8:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102caf:	c9                   	leave  
80102cb0:	c3                   	ret    

80102cb1 <kbdintr>:

void
kbdintr(void)
{
80102cb1:	55                   	push   %ebp
80102cb2:	89 e5                	mov    %esp,%ebp
80102cb4:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cb7:	c7 04 24 5e 2b 10 80 	movl   $0x80102b5e,(%esp)
80102cbe:	e8 ef da ff ff       	call   801007b2 <consoleintr>
}
80102cc3:	c9                   	leave  
80102cc4:	c3                   	ret    

80102cc5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cc5:	55                   	push   %ebp
80102cc6:	89 e5                	mov    %esp,%ebp
80102cc8:	83 ec 14             	sub    $0x14,%esp
80102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80102cce:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cd6:	89 c2                	mov    %eax,%edx
80102cd8:	ec                   	in     (%dx),%al
80102cd9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cdc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ce0:	c9                   	leave  
80102ce1:	c3                   	ret    

80102ce2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ce2:	55                   	push   %ebp
80102ce3:	89 e5                	mov    %esp,%ebp
80102ce5:	83 ec 08             	sub    $0x8,%esp
80102ce8:	8b 55 08             	mov    0x8(%ebp),%edx
80102ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cee:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cf2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cf9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cfd:	ee                   	out    %al,(%dx)
}
80102cfe:	c9                   	leave  
80102cff:	c3                   	ret    

80102d00 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d06:	9c                   	pushf  
80102d07:	58                   	pop    %eax
80102d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d0e:	c9                   	leave  
80102d0f:	c3                   	ret    

80102d10 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d13:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102d18:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1b:	c1 e2 02             	shl    $0x2,%edx
80102d1e:	01 c2                	add    %eax,%edx
80102d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d23:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d25:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102d2a:	83 c0 20             	add    $0x20,%eax
80102d2d:	8b 00                	mov    (%eax),%eax
}
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    

80102d31 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d31:	55                   	push   %ebp
80102d32:	89 e5                	mov    %esp,%ebp
80102d34:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d37:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102d3c:	85 c0                	test   %eax,%eax
80102d3e:	75 05                	jne    80102d45 <lapicinit+0x14>
    return;
80102d40:	e9 43 01 00 00       	jmp    80102e88 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d45:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d4c:	00 
80102d4d:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d54:	e8 b7 ff ff ff       	call   80102d10 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d59:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d60:	00 
80102d61:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d68:	e8 a3 ff ff ff       	call   80102d10 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d6d:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d74:	00 
80102d75:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d7c:	e8 8f ff ff ff       	call   80102d10 <lapicw>
  lapicw(TICR, 10000000); 
80102d81:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d88:	00 
80102d89:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d90:	e8 7b ff ff ff       	call   80102d10 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d95:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9c:	00 
80102d9d:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102da4:	e8 67 ff ff ff       	call   80102d10 <lapicw>
  lapicw(LINT1, MASKED);
80102da9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102db0:	00 
80102db1:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102db8:	e8 53 ff ff ff       	call   80102d10 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dbd:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102dc2:	83 c0 30             	add    $0x30,%eax
80102dc5:	8b 00                	mov    (%eax),%eax
80102dc7:	c1 e8 10             	shr    $0x10,%eax
80102dca:	0f b6 c0             	movzbl %al,%eax
80102dcd:	83 f8 03             	cmp    $0x3,%eax
80102dd0:	76 14                	jbe    80102de6 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102dd2:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd9:	00 
80102dda:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102de1:	e8 2a ff ff ff       	call   80102d10 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102de6:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ded:	00 
80102dee:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102df5:	e8 16 ff ff ff       	call   80102d10 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e09:	e8 02 ff ff ff       	call   80102d10 <lapicw>
  lapicw(ESR, 0);
80102e0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e1d:	e8 ee fe ff ff       	call   80102d10 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e31:	e8 da fe ff ff       	call   80102d10 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e45:	e8 c6 fe ff ff       	call   80102d10 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e4a:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e51:	00 
80102e52:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e59:	e8 b2 fe ff ff       	call   80102d10 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e5e:	90                   	nop
80102e5f:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102e64:	05 00 03 00 00       	add    $0x300,%eax
80102e69:	8b 00                	mov    (%eax),%eax
80102e6b:	25 00 10 00 00       	and    $0x1000,%eax
80102e70:	85 c0                	test   %eax,%eax
80102e72:	75 eb                	jne    80102e5f <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7b:	00 
80102e7c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e83:	e8 88 fe ff ff       	call   80102d10 <lapicw>
}
80102e88:	c9                   	leave  
80102e89:	c3                   	ret    

80102e8a <cpunum>:

int
cpunum(void)
{
80102e8a:	55                   	push   %ebp
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e90:	e8 6b fe ff ff       	call   80102d00 <readeflags>
80102e95:	25 00 02 00 00       	and    $0x200,%eax
80102e9a:	85 c0                	test   %eax,%eax
80102e9c:	74 25                	je     80102ec3 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e9e:	a1 c0 c6 10 80       	mov    0x8010c6c0,%eax
80102ea3:	8d 50 01             	lea    0x1(%eax),%edx
80102ea6:	89 15 c0 c6 10 80    	mov    %edx,0x8010c6c0
80102eac:	85 c0                	test   %eax,%eax
80102eae:	75 13                	jne    80102ec3 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eb0:	8b 45 04             	mov    0x4(%ebp),%eax
80102eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb7:	c7 04 24 00 94 10 80 	movl   $0x80109400,(%esp)
80102ebe:	e8 dd d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ec3:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102ec8:	85 c0                	test   %eax,%eax
80102eca:	74 0f                	je     80102edb <cpunum+0x51>
    return lapic[ID]>>24;
80102ecc:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102ed1:	83 c0 20             	add    $0x20,%eax
80102ed4:	8b 00                	mov    (%eax),%eax
80102ed6:	c1 e8 18             	shr    $0x18,%eax
80102ed9:	eb 05                	jmp    80102ee0 <cpunum+0x56>
  return 0;
80102edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ee0:	c9                   	leave  
80102ee1:	c3                   	ret    

80102ee2 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee2:	55                   	push   %ebp
80102ee3:	89 e5                	mov    %esp,%ebp
80102ee5:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ee8:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80102eed:	85 c0                	test   %eax,%eax
80102eef:	74 14                	je     80102f05 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ef1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef8:	00 
80102ef9:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f00:	e8 0b fe ff ff       	call   80102d10 <lapicw>
}
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    

80102f07 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f07:	55                   	push   %ebp
80102f08:	89 e5                	mov    %esp,%ebp
}
80102f0a:	5d                   	pop    %ebp
80102f0b:	c3                   	ret    

80102f0c <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f0c:	55                   	push   %ebp
80102f0d:	89 e5                	mov    %esp,%ebp
80102f0f:	83 ec 1c             	sub    $0x1c,%esp
80102f12:	8b 45 08             	mov    0x8(%ebp),%eax
80102f15:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f18:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f1f:	00 
80102f20:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f27:	e8 b6 fd ff ff       	call   80102ce2 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f2c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f33:	00 
80102f34:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f3b:	e8 a2 fd ff ff       	call   80102ce2 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f40:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f4a:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f52:	8d 50 02             	lea    0x2(%eax),%edx
80102f55:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f58:	c1 e8 04             	shr    $0x4,%eax
80102f5b:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f5e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f62:	c1 e0 18             	shl    $0x18,%eax
80102f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f69:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f70:	e8 9b fd ff ff       	call   80102d10 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f75:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f7c:	00 
80102f7d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f84:	e8 87 fd ff ff       	call   80102d10 <lapicw>
  microdelay(200);
80102f89:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f90:	e8 72 ff ff ff       	call   80102f07 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f95:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f9c:	00 
80102f9d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa4:	e8 67 fd ff ff       	call   80102d10 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fa9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fb0:	e8 52 ff ff ff       	call   80102f07 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fbc:	eb 40                	jmp    80102ffe <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fbe:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc2:	c1 e0 18             	shl    $0x18,%eax
80102fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fc9:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fd0:	e8 3b fd ff ff       	call   80102d10 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd8:	c1 e8 0c             	shr    $0xc,%eax
80102fdb:	80 cc 06             	or     $0x6,%ah
80102fde:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe2:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fe9:	e8 22 fd ff ff       	call   80102d10 <lapicw>
    microdelay(200);
80102fee:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ff5:	e8 0d ff ff ff       	call   80102f07 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ffa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102ffe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103002:	7e ba                	jle    80102fbe <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103004:	c9                   	leave  
80103005:	c3                   	ret    

80103006 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103006:	55                   	push   %ebp
80103007:	89 e5                	mov    %esp,%ebp
80103009:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010300c:	8b 45 08             	mov    0x8(%ebp),%eax
8010300f:	0f b6 c0             	movzbl %al,%eax
80103012:	89 44 24 04          	mov    %eax,0x4(%esp)
80103016:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010301d:	e8 c0 fc ff ff       	call   80102ce2 <outb>
  microdelay(200);
80103022:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103029:	e8 d9 fe ff ff       	call   80102f07 <microdelay>

  return inb(CMOS_RETURN);
8010302e:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103035:	e8 8b fc ff ff       	call   80102cc5 <inb>
8010303a:	0f b6 c0             	movzbl %al,%eax
}
8010303d:	c9                   	leave  
8010303e:	c3                   	ret    

8010303f <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010303f:	55                   	push   %ebp
80103040:	89 e5                	mov    %esp,%ebp
80103042:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103045:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010304c:	e8 b5 ff ff ff       	call   80103006 <cmos_read>
80103051:	8b 55 08             	mov    0x8(%ebp),%edx
80103054:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103056:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010305d:	e8 a4 ff ff ff       	call   80103006 <cmos_read>
80103062:	8b 55 08             	mov    0x8(%ebp),%edx
80103065:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103068:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010306f:	e8 92 ff ff ff       	call   80103006 <cmos_read>
80103074:	8b 55 08             	mov    0x8(%ebp),%edx
80103077:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010307a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103081:	e8 80 ff ff ff       	call   80103006 <cmos_read>
80103086:	8b 55 08             	mov    0x8(%ebp),%edx
80103089:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010308c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103093:	e8 6e ff ff ff       	call   80103006 <cmos_read>
80103098:	8b 55 08             	mov    0x8(%ebp),%edx
8010309b:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010309e:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030a5:	e8 5c ff ff ff       	call   80103006 <cmos_read>
801030aa:	8b 55 08             	mov    0x8(%ebp),%edx
801030ad:	89 42 14             	mov    %eax,0x14(%edx)
}
801030b0:	c9                   	leave  
801030b1:	c3                   	ret    

801030b2 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030b2:	55                   	push   %ebp
801030b3:	89 e5                	mov    %esp,%ebp
801030b5:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030b8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030bf:	e8 42 ff ff ff       	call   80103006 <cmos_read>
801030c4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030ca:	83 e0 04             	and    $0x4,%eax
801030cd:	85 c0                	test   %eax,%eax
801030cf:	0f 94 c0             	sete   %al
801030d2:	0f b6 c0             	movzbl %al,%eax
801030d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801030d8:	8d 45 d8             	lea    -0x28(%ebp),%eax
801030db:	89 04 24             	mov    %eax,(%esp)
801030de:	e8 5c ff ff ff       	call   8010303f <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801030e3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801030ea:	e8 17 ff ff ff       	call   80103006 <cmos_read>
801030ef:	25 80 00 00 00       	and    $0x80,%eax
801030f4:	85 c0                	test   %eax,%eax
801030f6:	74 02                	je     801030fa <cmostime+0x48>
        continue;
801030f8:	eb 36                	jmp    80103130 <cmostime+0x7e>
    fill_rtcdate(&t2);
801030fa:	8d 45 c0             	lea    -0x40(%ebp),%eax
801030fd:	89 04 24             	mov    %eax,(%esp)
80103100:	e8 3a ff ff ff       	call   8010303f <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103105:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010310c:	00 
8010310d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103110:	89 44 24 04          	mov    %eax,0x4(%esp)
80103114:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103117:	89 04 24             	mov    %eax,(%esp)
8010311a:	e8 51 2d 00 00       	call   80105e70 <memcmp>
8010311f:	85 c0                	test   %eax,%eax
80103121:	75 0d                	jne    80103130 <cmostime+0x7e>
      break;
80103123:	90                   	nop
  }

  // convert
  if (bcd) {
80103124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103128:	0f 84 ac 00 00 00    	je     801031da <cmostime+0x128>
8010312e:	eb 02                	jmp    80103132 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103130:	eb a6                	jmp    801030d8 <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103135:	c1 e8 04             	shr    $0x4,%eax
80103138:	89 c2                	mov    %eax,%edx
8010313a:	89 d0                	mov    %edx,%eax
8010313c:	c1 e0 02             	shl    $0x2,%eax
8010313f:	01 d0                	add    %edx,%eax
80103141:	01 c0                	add    %eax,%eax
80103143:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103146:	83 e2 0f             	and    $0xf,%edx
80103149:	01 d0                	add    %edx,%eax
8010314b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010314e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103151:	c1 e8 04             	shr    $0x4,%eax
80103154:	89 c2                	mov    %eax,%edx
80103156:	89 d0                	mov    %edx,%eax
80103158:	c1 e0 02             	shl    $0x2,%eax
8010315b:	01 d0                	add    %edx,%eax
8010315d:	01 c0                	add    %eax,%eax
8010315f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103162:	83 e2 0f             	and    $0xf,%edx
80103165:	01 d0                	add    %edx,%eax
80103167:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010316a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010316d:	c1 e8 04             	shr    $0x4,%eax
80103170:	89 c2                	mov    %eax,%edx
80103172:	89 d0                	mov    %edx,%eax
80103174:	c1 e0 02             	shl    $0x2,%eax
80103177:	01 d0                	add    %edx,%eax
80103179:	01 c0                	add    %eax,%eax
8010317b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010317e:	83 e2 0f             	and    $0xf,%edx
80103181:	01 d0                	add    %edx,%eax
80103183:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103189:	c1 e8 04             	shr    $0x4,%eax
8010318c:	89 c2                	mov    %eax,%edx
8010318e:	89 d0                	mov    %edx,%eax
80103190:	c1 e0 02             	shl    $0x2,%eax
80103193:	01 d0                	add    %edx,%eax
80103195:	01 c0                	add    %eax,%eax
80103197:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010319a:	83 e2 0f             	and    $0xf,%edx
8010319d:	01 d0                	add    %edx,%eax
8010319f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031a5:	c1 e8 04             	shr    $0x4,%eax
801031a8:	89 c2                	mov    %eax,%edx
801031aa:	89 d0                	mov    %edx,%eax
801031ac:	c1 e0 02             	shl    $0x2,%eax
801031af:	01 d0                	add    %edx,%eax
801031b1:	01 c0                	add    %eax,%eax
801031b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031b6:	83 e2 0f             	and    $0xf,%edx
801031b9:	01 d0                	add    %edx,%eax
801031bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c1:	c1 e8 04             	shr    $0x4,%eax
801031c4:	89 c2                	mov    %eax,%edx
801031c6:	89 d0                	mov    %edx,%eax
801031c8:	c1 e0 02             	shl    $0x2,%eax
801031cb:	01 d0                	add    %edx,%eax
801031cd:	01 c0                	add    %eax,%eax
801031cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031d2:	83 e2 0f             	and    $0xf,%edx
801031d5:	01 d0                	add    %edx,%eax
801031d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801031da:	8b 45 08             	mov    0x8(%ebp),%eax
801031dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031e0:	89 10                	mov    %edx,(%eax)
801031e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031e5:	89 50 04             	mov    %edx,0x4(%eax)
801031e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031eb:	89 50 08             	mov    %edx,0x8(%eax)
801031ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031f1:	89 50 0c             	mov    %edx,0xc(%eax)
801031f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031f7:	89 50 10             	mov    %edx,0x10(%eax)
801031fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031fd:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103200:	8b 45 08             	mov    0x8(%ebp),%eax
80103203:	8b 40 14             	mov    0x14(%eax),%eax
80103206:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010320c:	8b 45 08             	mov    0x8(%ebp),%eax
8010320f:	89 50 14             	mov    %edx,0x14(%eax)
}
80103212:	c9                   	leave  
80103213:	c3                   	ret    

80103214 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010321a:	c7 44 24 04 2c 94 10 	movl   $0x8010942c,0x4(%esp)
80103221:	80 
80103222:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103229:	e8 56 29 00 00       	call   80105b84 <initlock>
  readsb(ROOTDEV, &sb);
8010322e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103231:	89 44 24 04          	mov    %eax,0x4(%esp)
80103235:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010323c:	e8 c2 e0 ff ff       	call   80101303 <readsb>
  log.start = sb.size - sb.nlog;
80103241:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103247:	29 c2                	sub    %eax,%edx
80103249:	89 d0                	mov    %edx,%eax
8010324b:	a3 14 33 11 80       	mov    %eax,0x80113314
  log.size = sb.nlog;
80103250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103253:	a3 18 33 11 80       	mov    %eax,0x80113318
  log.dev = ROOTDEV;
80103258:	c7 05 24 33 11 80 01 	movl   $0x1,0x80113324
8010325f:	00 00 00 
  recover_from_log();
80103262:	e8 9a 01 00 00       	call   80103401 <recover_from_log>
}
80103267:	c9                   	leave  
80103268:	c3                   	ret    

80103269 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103269:	55                   	push   %ebp
8010326a:	89 e5                	mov    %esp,%ebp
8010326c:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010326f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103276:	e9 8c 00 00 00       	jmp    80103307 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010327b:	8b 15 14 33 11 80    	mov    0x80113314,%edx
80103281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103284:	01 d0                	add    %edx,%eax
80103286:	83 c0 01             	add    $0x1,%eax
80103289:	89 c2                	mov    %eax,%edx
8010328b:	a1 24 33 11 80       	mov    0x80113324,%eax
80103290:	89 54 24 04          	mov    %edx,0x4(%esp)
80103294:	89 04 24             	mov    %eax,(%esp)
80103297:	e8 0a cf ff ff       	call   801001a6 <bread>
8010329c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032a2:	83 c0 10             	add    $0x10,%eax
801032a5:	8b 04 85 ec 32 11 80 	mov    -0x7feecd14(,%eax,4),%eax
801032ac:	89 c2                	mov    %eax,%edx
801032ae:	a1 24 33 11 80       	mov    0x80113324,%eax
801032b3:	89 54 24 04          	mov    %edx,0x4(%esp)
801032b7:	89 04 24             	mov    %eax,(%esp)
801032ba:	e8 e7 ce ff ff       	call   801001a6 <bread>
801032bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032c5:	8d 50 18             	lea    0x18(%eax),%edx
801032c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032cb:	83 c0 18             	add    $0x18,%eax
801032ce:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801032d5:	00 
801032d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801032da:	89 04 24             	mov    %eax,(%esp)
801032dd:	e8 e6 2b 00 00       	call   80105ec8 <memmove>
    bwrite(dbuf);  // write dst to disk
801032e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032e5:	89 04 24             	mov    %eax,(%esp)
801032e8:	e8 f0 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f0:	89 04 24             	mov    %eax,(%esp)
801032f3:	e8 1f cf ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032fb:	89 04 24             	mov    %eax,(%esp)
801032fe:	e8 14 cf ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103303:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103307:	a1 28 33 11 80       	mov    0x80113328,%eax
8010330c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010330f:	0f 8f 66 ff ff ff    	jg     8010327b <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103315:	c9                   	leave  
80103316:	c3                   	ret    

80103317 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103317:	55                   	push   %ebp
80103318:	89 e5                	mov    %esp,%ebp
8010331a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010331d:	a1 14 33 11 80       	mov    0x80113314,%eax
80103322:	89 c2                	mov    %eax,%edx
80103324:	a1 24 33 11 80       	mov    0x80113324,%eax
80103329:	89 54 24 04          	mov    %edx,0x4(%esp)
8010332d:	89 04 24             	mov    %eax,(%esp)
80103330:	e8 71 ce ff ff       	call   801001a6 <bread>
80103335:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333b:	83 c0 18             	add    $0x18,%eax
8010333e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103341:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103344:	8b 00                	mov    (%eax),%eax
80103346:	a3 28 33 11 80       	mov    %eax,0x80113328
  for (i = 0; i < log.lh.n; i++) {
8010334b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103352:	eb 1b                	jmp    8010336f <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103354:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103357:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010335a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103361:	83 c2 10             	add    $0x10,%edx
80103364:	89 04 95 ec 32 11 80 	mov    %eax,-0x7feecd14(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010336b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010336f:	a1 28 33 11 80       	mov    0x80113328,%eax
80103374:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103377:	7f db                	jg     80103354 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103379:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010337c:	89 04 24             	mov    %eax,(%esp)
8010337f:	e8 93 ce ff ff       	call   80100217 <brelse>
}
80103384:	c9                   	leave  
80103385:	c3                   	ret    

80103386 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103386:	55                   	push   %ebp
80103387:	89 e5                	mov    %esp,%ebp
80103389:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010338c:	a1 14 33 11 80       	mov    0x80113314,%eax
80103391:	89 c2                	mov    %eax,%edx
80103393:	a1 24 33 11 80       	mov    0x80113324,%eax
80103398:	89 54 24 04          	mov    %edx,0x4(%esp)
8010339c:	89 04 24             	mov    %eax,(%esp)
8010339f:	e8 02 ce ff ff       	call   801001a6 <bread>
801033a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033aa:	83 c0 18             	add    $0x18,%eax
801033ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033b0:	8b 15 28 33 11 80    	mov    0x80113328,%edx
801033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033b9:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033c2:	eb 1b                	jmp    801033df <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033c7:	83 c0 10             	add    $0x10,%eax
801033ca:	8b 0c 85 ec 32 11 80 	mov    -0x7feecd14(,%eax,4),%ecx
801033d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033d7:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801033db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033df:	a1 28 33 11 80       	mov    0x80113328,%eax
801033e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033e7:	7f db                	jg     801033c4 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801033e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ec:	89 04 24             	mov    %eax,(%esp)
801033ef:	e8 e9 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
801033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f7:	89 04 24             	mov    %eax,(%esp)
801033fa:	e8 18 ce ff ff       	call   80100217 <brelse>
}
801033ff:	c9                   	leave  
80103400:	c3                   	ret    

80103401 <recover_from_log>:

static void
recover_from_log(void)
{
80103401:	55                   	push   %ebp
80103402:	89 e5                	mov    %esp,%ebp
80103404:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103407:	e8 0b ff ff ff       	call   80103317 <read_head>
  install_trans(); // if committed, copy from log to disk
8010340c:	e8 58 fe ff ff       	call   80103269 <install_trans>
  log.lh.n = 0;
80103411:	c7 05 28 33 11 80 00 	movl   $0x0,0x80113328
80103418:	00 00 00 
  write_head(); // clear the log
8010341b:	e8 66 ff ff ff       	call   80103386 <write_head>
}
80103420:	c9                   	leave  
80103421:	c3                   	ret    

80103422 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103422:	55                   	push   %ebp
80103423:	89 e5                	mov    %esp,%ebp
80103425:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103428:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
8010342f:	e8 71 27 00 00       	call   80105ba5 <acquire>
  while(1){
    if(log.committing){
80103434:	a1 20 33 11 80       	mov    0x80113320,%eax
80103439:	85 c0                	test   %eax,%eax
8010343b:	74 16                	je     80103453 <begin_op+0x31>
      sleep(&log, &log.lock);
8010343d:	c7 44 24 04 e0 32 11 	movl   $0x801132e0,0x4(%esp)
80103444:	80 
80103445:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
8010344c:	e8 88 1c 00 00       	call   801050d9 <sleep>
80103451:	eb 4f                	jmp    801034a2 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103453:	8b 0d 28 33 11 80    	mov    0x80113328,%ecx
80103459:	a1 1c 33 11 80       	mov    0x8011331c,%eax
8010345e:	8d 50 01             	lea    0x1(%eax),%edx
80103461:	89 d0                	mov    %edx,%eax
80103463:	c1 e0 02             	shl    $0x2,%eax
80103466:	01 d0                	add    %edx,%eax
80103468:	01 c0                	add    %eax,%eax
8010346a:	01 c8                	add    %ecx,%eax
8010346c:	83 f8 1e             	cmp    $0x1e,%eax
8010346f:	7e 16                	jle    80103487 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103471:	c7 44 24 04 e0 32 11 	movl   $0x801132e0,0x4(%esp)
80103478:	80 
80103479:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103480:	e8 54 1c 00 00       	call   801050d9 <sleep>
80103485:	eb 1b                	jmp    801034a2 <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103487:	a1 1c 33 11 80       	mov    0x8011331c,%eax
8010348c:	83 c0 01             	add    $0x1,%eax
8010348f:	a3 1c 33 11 80       	mov    %eax,0x8011331c
      release(&log.lock);
80103494:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
8010349b:	e8 67 27 00 00       	call   80105c07 <release>
      break;
801034a0:	eb 02                	jmp    801034a4 <begin_op+0x82>
    }
  }
801034a2:	eb 90                	jmp    80103434 <begin_op+0x12>
}
801034a4:	c9                   	leave  
801034a5:	c3                   	ret    

801034a6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034a6:	55                   	push   %ebp
801034a7:	89 e5                	mov    %esp,%ebp
801034a9:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034b3:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
801034ba:	e8 e6 26 00 00       	call   80105ba5 <acquire>
  log.outstanding -= 1;
801034bf:	a1 1c 33 11 80       	mov    0x8011331c,%eax
801034c4:	83 e8 01             	sub    $0x1,%eax
801034c7:	a3 1c 33 11 80       	mov    %eax,0x8011331c
  if(log.committing)
801034cc:	a1 20 33 11 80       	mov    0x80113320,%eax
801034d1:	85 c0                	test   %eax,%eax
801034d3:	74 0c                	je     801034e1 <end_op+0x3b>
    panic("log.committing");
801034d5:	c7 04 24 30 94 10 80 	movl   $0x80109430,(%esp)
801034dc:	e8 59 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
801034e1:	a1 1c 33 11 80       	mov    0x8011331c,%eax
801034e6:	85 c0                	test   %eax,%eax
801034e8:	75 13                	jne    801034fd <end_op+0x57>
    do_commit = 1;
801034ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801034f1:	c7 05 20 33 11 80 01 	movl   $0x1,0x80113320
801034f8:	00 00 00 
801034fb:	eb 0c                	jmp    80103509 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801034fd:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103504:	e8 13 1e 00 00       	call   8010531c <wakeup>
  }
  release(&log.lock);
80103509:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103510:	e8 f2 26 00 00       	call   80105c07 <release>

  if(do_commit){
80103515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103519:	74 33                	je     8010354e <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010351b:	e8 de 00 00 00       	call   801035fe <commit>
    acquire(&log.lock);
80103520:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103527:	e8 79 26 00 00       	call   80105ba5 <acquire>
    log.committing = 0;
8010352c:	c7 05 20 33 11 80 00 	movl   $0x0,0x80113320
80103533:	00 00 00 
    wakeup(&log);
80103536:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
8010353d:	e8 da 1d 00 00       	call   8010531c <wakeup>
    release(&log.lock);
80103542:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103549:	e8 b9 26 00 00       	call   80105c07 <release>
  }
}
8010354e:	c9                   	leave  
8010354f:	c3                   	ret    

80103550 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010355d:	e9 8c 00 00 00       	jmp    801035ee <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103562:	8b 15 14 33 11 80    	mov    0x80113314,%edx
80103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010356b:	01 d0                	add    %edx,%eax
8010356d:	83 c0 01             	add    $0x1,%eax
80103570:	89 c2                	mov    %eax,%edx
80103572:	a1 24 33 11 80       	mov    0x80113324,%eax
80103577:	89 54 24 04          	mov    %edx,0x4(%esp)
8010357b:	89 04 24             	mov    %eax,(%esp)
8010357e:	e8 23 cc ff ff       	call   801001a6 <bread>
80103583:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103589:	83 c0 10             	add    $0x10,%eax
8010358c:	8b 04 85 ec 32 11 80 	mov    -0x7feecd14(,%eax,4),%eax
80103593:	89 c2                	mov    %eax,%edx
80103595:	a1 24 33 11 80       	mov    0x80113324,%eax
8010359a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010359e:	89 04 24             	mov    %eax,(%esp)
801035a1:	e8 00 cc ff ff       	call   801001a6 <bread>
801035a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ac:	8d 50 18             	lea    0x18(%eax),%edx
801035af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b2:	83 c0 18             	add    $0x18,%eax
801035b5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035bc:	00 
801035bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801035c1:	89 04 24             	mov    %eax,(%esp)
801035c4:	e8 ff 28 00 00       	call   80105ec8 <memmove>
    bwrite(to);  // write the log
801035c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035cc:	89 04 24             	mov    %eax,(%esp)
801035cf:	e8 09 cc ff ff       	call   801001dd <bwrite>
    brelse(from); 
801035d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d7:	89 04 24             	mov    %eax,(%esp)
801035da:	e8 38 cc ff ff       	call   80100217 <brelse>
    brelse(to);
801035df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e2:	89 04 24             	mov    %eax,(%esp)
801035e5:	e8 2d cc ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035ee:	a1 28 33 11 80       	mov    0x80113328,%eax
801035f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035f6:	0f 8f 66 ff ff ff    	jg     80103562 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801035fc:	c9                   	leave  
801035fd:	c3                   	ret    

801035fe <commit>:

static void
commit()
{
801035fe:	55                   	push   %ebp
801035ff:	89 e5                	mov    %esp,%ebp
80103601:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103604:	a1 28 33 11 80       	mov    0x80113328,%eax
80103609:	85 c0                	test   %eax,%eax
8010360b:	7e 1e                	jle    8010362b <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010360d:	e8 3e ff ff ff       	call   80103550 <write_log>
    write_head();    // Write header to disk -- the real commit
80103612:	e8 6f fd ff ff       	call   80103386 <write_head>
    install_trans(); // Now install writes to home locations
80103617:	e8 4d fc ff ff       	call   80103269 <install_trans>
    log.lh.n = 0; 
8010361c:	c7 05 28 33 11 80 00 	movl   $0x0,0x80113328
80103623:	00 00 00 
    write_head();    // Erase the transaction from the log
80103626:	e8 5b fd ff ff       	call   80103386 <write_head>
  }
}
8010362b:	c9                   	leave  
8010362c:	c3                   	ret    

8010362d <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010362d:	55                   	push   %ebp
8010362e:	89 e5                	mov    %esp,%ebp
80103630:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103633:	a1 28 33 11 80       	mov    0x80113328,%eax
80103638:	83 f8 1d             	cmp    $0x1d,%eax
8010363b:	7f 12                	jg     8010364f <log_write+0x22>
8010363d:	a1 28 33 11 80       	mov    0x80113328,%eax
80103642:	8b 15 18 33 11 80    	mov    0x80113318,%edx
80103648:	83 ea 01             	sub    $0x1,%edx
8010364b:	39 d0                	cmp    %edx,%eax
8010364d:	7c 0c                	jl     8010365b <log_write+0x2e>
    panic("too big a transaction");
8010364f:	c7 04 24 3f 94 10 80 	movl   $0x8010943f,(%esp)
80103656:	e8 df ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010365b:	a1 1c 33 11 80       	mov    0x8011331c,%eax
80103660:	85 c0                	test   %eax,%eax
80103662:	7f 0c                	jg     80103670 <log_write+0x43>
    panic("log_write outside of trans");
80103664:	c7 04 24 55 94 10 80 	movl   $0x80109455,(%esp)
8010366b:	e8 ca ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103670:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
80103677:	e8 29 25 00 00       	call   80105ba5 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010367c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103683:	eb 1f                	jmp    801036a4 <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
80103685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103688:	83 c0 10             	add    $0x10,%eax
8010368b:	8b 04 85 ec 32 11 80 	mov    -0x7feecd14(,%eax,4),%eax
80103692:	89 c2                	mov    %eax,%edx
80103694:	8b 45 08             	mov    0x8(%ebp),%eax
80103697:	8b 40 08             	mov    0x8(%eax),%eax
8010369a:	39 c2                	cmp    %eax,%edx
8010369c:	75 02                	jne    801036a0 <log_write+0x73>
      break;
8010369e:	eb 0e                	jmp    801036ae <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801036a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036a4:	a1 28 33 11 80       	mov    0x80113328,%eax
801036a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036ac:	7f d7                	jg     80103685 <log_write+0x58>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036ae:	8b 45 08             	mov    0x8(%ebp),%eax
801036b1:	8b 40 08             	mov    0x8(%eax),%eax
801036b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036b7:	83 c2 10             	add    $0x10,%edx
801036ba:	89 04 95 ec 32 11 80 	mov    %eax,-0x7feecd14(,%edx,4)
  if (i == log.lh.n)
801036c1:	a1 28 33 11 80       	mov    0x80113328,%eax
801036c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036c9:	75 0d                	jne    801036d8 <log_write+0xab>
    log.lh.n++;
801036cb:	a1 28 33 11 80       	mov    0x80113328,%eax
801036d0:	83 c0 01             	add    $0x1,%eax
801036d3:	a3 28 33 11 80       	mov    %eax,0x80113328
  b->flags |= B_DIRTY; // prevent eviction
801036d8:	8b 45 08             	mov    0x8(%ebp),%eax
801036db:	8b 00                	mov    (%eax),%eax
801036dd:	83 c8 04             	or     $0x4,%eax
801036e0:	89 c2                	mov    %eax,%edx
801036e2:	8b 45 08             	mov    0x8(%ebp),%eax
801036e5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801036e7:	c7 04 24 e0 32 11 80 	movl   $0x801132e0,(%esp)
801036ee:	e8 14 25 00 00       	call   80105c07 <release>
}
801036f3:	c9                   	leave  
801036f4:	c3                   	ret    

801036f5 <v2p>:
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	8b 45 08             	mov    0x8(%ebp),%eax
801036fb:	05 00 00 00 80       	add    $0x80000000,%eax
80103700:	5d                   	pop    %ebp
80103701:	c3                   	ret    

80103702 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103702:	55                   	push   %ebp
80103703:	89 e5                	mov    %esp,%ebp
80103705:	8b 45 08             	mov    0x8(%ebp),%eax
80103708:	05 00 00 00 80       	add    $0x80000000,%eax
8010370d:	5d                   	pop    %ebp
8010370e:	c3                   	ret    

8010370f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010370f:	55                   	push   %ebp
80103710:	89 e5                	mov    %esp,%ebp
80103712:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103715:	8b 55 08             	mov    0x8(%ebp),%edx
80103718:	8b 45 0c             	mov    0xc(%ebp),%eax
8010371b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010371e:	f0 87 02             	lock xchg %eax,(%edx)
80103721:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103724:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103727:	c9                   	leave  
80103728:	c3                   	ret    

80103729 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103729:	55                   	push   %ebp
8010372a:	89 e5                	mov    %esp,%ebp
8010372c:	83 e4 f0             	and    $0xfffffff0,%esp
8010372f:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103732:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103739:	80 
8010373a:	c7 04 24 7c a0 11 80 	movl   $0x8011a07c,(%esp)
80103741:	e8 80 f2 ff ff       	call   801029c6 <kinit1>
  kvmalloc();      // kernel page table
80103746:	e8 29 53 00 00       	call   80108a74 <kvmalloc>
  mpinit();        // collect info about this machine
8010374b:	e8 46 04 00 00       	call   80103b96 <mpinit>
  lapicinit();
80103750:	e8 dc f5 ff ff       	call   80102d31 <lapicinit>
  seginit();       // set up segments
80103755:	e8 ad 4c 00 00       	call   80108407 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010375a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103760:	0f b6 00             	movzbl (%eax),%eax
80103763:	0f b6 c0             	movzbl %al,%eax
80103766:	89 44 24 04          	mov    %eax,0x4(%esp)
8010376a:	c7 04 24 70 94 10 80 	movl   $0x80109470,(%esp)
80103771:	e8 2a cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
80103776:	e8 79 06 00 00       	call   80103df4 <picinit>
  ioapicinit();    // another interrupt controller
8010377b:	e8 3c f1 ff ff       	call   801028bc <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103780:	e8 01 d3 ff ff       	call   80100a86 <consoleinit>
  uartinit();      // serial port
80103785:	e8 cc 3f 00 00       	call   80107756 <uartinit>
  pinit();         // process table
8010378a:	e8 94 0b 00 00       	call   80104323 <pinit>
  tvinit();        // trap vectors
8010378f:	e8 74 3b 00 00       	call   80107308 <tvinit>
  binit();         // buffer cache
80103794:	e8 9b c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103799:	e8 7e d7 ff ff       	call   80100f1c <fileinit>
  iinit();         // inode cache
8010379e:	e8 13 de ff ff       	call   801015b6 <iinit>
  ideinit();       // disk
801037a3:	e8 7d ed ff ff       	call   80102525 <ideinit>
  if(!ismp)
801037a8:	a1 c4 33 11 80       	mov    0x801133c4,%eax
801037ad:	85 c0                	test   %eax,%eax
801037af:	75 05                	jne    801037b6 <main+0x8d>
    timerinit();   // uniprocessor timer
801037b1:	e8 8e 3a 00 00       	call   80107244 <timerinit>
  startothers();   // start other processors
801037b6:	e8 7f 00 00 00       	call   8010383a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037bb:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037c2:	8e 
801037c3:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037ca:	e8 2f f2 ff ff       	call   801029fe <kinit2>
  userinit();      // first user process
801037cf:	e8 d5 0c 00 00       	call   801044a9 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801037d4:	e8 1a 00 00 00       	call   801037f3 <mpmain>

801037d9 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037d9:	55                   	push   %ebp
801037da:	89 e5                	mov    %esp,%ebp
801037dc:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801037df:	e8 a7 52 00 00       	call   80108a8b <switchkvm>
  seginit();
801037e4:	e8 1e 4c 00 00       	call   80108407 <seginit>
  lapicinit();
801037e9:	e8 43 f5 ff ff       	call   80102d31 <lapicinit>
  mpmain();
801037ee:	e8 00 00 00 00       	call   801037f3 <mpmain>

801037f3 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037f3:	55                   	push   %ebp
801037f4:	89 e5                	mov    %esp,%ebp
801037f6:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801037f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037ff:	0f b6 00             	movzbl (%eax),%eax
80103802:	0f b6 c0             	movzbl %al,%eax
80103805:	89 44 24 04          	mov    %eax,0x4(%esp)
80103809:	c7 04 24 87 94 10 80 	movl   $0x80109487,(%esp)
80103810:	e8 8b cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103815:	e8 62 3c 00 00       	call   8010747c <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010381a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103820:	05 a8 00 00 00       	add    $0xa8,%eax
80103825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010382c:	00 
8010382d:	89 04 24             	mov    %eax,(%esp)
80103830:	e8 da fe ff ff       	call   8010370f <xchg>
  scheduler();     // start running processes
80103835:	e8 6c 15 00 00       	call   80104da6 <scheduler>

8010383a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010383a:	55                   	push   %ebp
8010383b:	89 e5                	mov    %esp,%ebp
8010383d:	53                   	push   %ebx
8010383e:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103841:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103848:	e8 b5 fe ff ff       	call   80103702 <p2v>
8010384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103850:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103855:	89 44 24 08          	mov    %eax,0x8(%esp)
80103859:	c7 44 24 04 8c c5 10 	movl   $0x8010c58c,0x4(%esp)
80103860:	80 
80103861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103864:	89 04 24             	mov    %eax,(%esp)
80103867:	e8 5c 26 00 00       	call   80105ec8 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010386c:	c7 45 f4 e0 33 11 80 	movl   $0x801133e0,-0xc(%ebp)
80103873:	e9 85 00 00 00       	jmp    801038fd <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103878:	e8 0d f6 ff ff       	call   80102e8a <cpunum>
8010387d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103883:	05 e0 33 11 80       	add    $0x801133e0,%eax
80103888:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010388b:	75 02                	jne    8010388f <startothers+0x55>
      continue;
8010388d:	eb 67                	jmp    801038f6 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010388f:	e8 60 f2 ff ff       	call   80102af4 <kalloc>
80103894:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389a:	83 e8 04             	sub    $0x4,%eax
8010389d:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038a0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038a6:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ab:	83 e8 08             	sub    $0x8,%eax
801038ae:	c7 00 d9 37 10 80    	movl   $0x801037d9,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801038b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b7:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038ba:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
801038c1:	e8 2f fe ff ff       	call   801036f5 <v2p>
801038c6:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038cb:	89 04 24             	mov    %eax,(%esp)
801038ce:	e8 22 fe ff ff       	call   801036f5 <v2p>
801038d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038d6:	0f b6 12             	movzbl (%edx),%edx
801038d9:	0f b6 d2             	movzbl %dl,%edx
801038dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801038e0:	89 14 24             	mov    %edx,(%esp)
801038e3:	e8 24 f6 ff ff       	call   80102f0c <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038e8:	90                   	nop
801038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ec:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 f3                	je     801038e9 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801038f6:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801038fd:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80103902:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103908:	05 e0 33 11 80       	add    $0x801133e0,%eax
8010390d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103910:	0f 87 62 ff ff ff    	ja     80103878 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103916:	83 c4 24             	add    $0x24,%esp
80103919:	5b                   	pop    %ebx
8010391a:	5d                   	pop    %ebp
8010391b:	c3                   	ret    

8010391c <p2v>:
8010391c:	55                   	push   %ebp
8010391d:	89 e5                	mov    %esp,%ebp
8010391f:	8b 45 08             	mov    0x8(%ebp),%eax
80103922:	05 00 00 00 80       	add    $0x80000000,%eax
80103927:	5d                   	pop    %ebp
80103928:	c3                   	ret    

80103929 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103929:	55                   	push   %ebp
8010392a:	89 e5                	mov    %esp,%ebp
8010392c:	83 ec 14             	sub    $0x14,%esp
8010392f:	8b 45 08             	mov    0x8(%ebp),%eax
80103932:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103936:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010393a:	89 c2                	mov    %eax,%edx
8010393c:	ec                   	in     (%dx),%al
8010393d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103940:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103944:	c9                   	leave  
80103945:	c3                   	ret    

80103946 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103946:	55                   	push   %ebp
80103947:	89 e5                	mov    %esp,%ebp
80103949:	83 ec 08             	sub    $0x8,%esp
8010394c:	8b 55 08             	mov    0x8(%ebp),%edx
8010394f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103952:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103956:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103959:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010395d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103961:	ee                   	out    %al,(%dx)
}
80103962:	c9                   	leave  
80103963:	c3                   	ret    

80103964 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103967:	a1 c4 c6 10 80       	mov    0x8010c6c4,%eax
8010396c:	89 c2                	mov    %eax,%edx
8010396e:	b8 e0 33 11 80       	mov    $0x801133e0,%eax
80103973:	29 c2                	sub    %eax,%edx
80103975:	89 d0                	mov    %edx,%eax
80103977:	c1 f8 02             	sar    $0x2,%eax
8010397a:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103980:	5d                   	pop    %ebp
80103981:	c3                   	ret    

80103982 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103982:	55                   	push   %ebp
80103983:	89 e5                	mov    %esp,%ebp
80103985:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103988:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010398f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103996:	eb 15                	jmp    801039ad <sum+0x2b>
    sum += addr[i];
80103998:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010399b:	8b 45 08             	mov    0x8(%ebp),%eax
8010399e:	01 d0                	add    %edx,%eax
801039a0:	0f b6 00             	movzbl (%eax),%eax
801039a3:	0f b6 c0             	movzbl %al,%eax
801039a6:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801039a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801039ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039b3:	7c e3                	jl     80103998 <sum+0x16>
    sum += addr[i];
  return sum;
801039b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039b8:	c9                   	leave  
801039b9:	c3                   	ret    

801039ba <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039ba:	55                   	push   %ebp
801039bb:	89 e5                	mov    %esp,%ebp
801039bd:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039c0:	8b 45 08             	mov    0x8(%ebp),%eax
801039c3:	89 04 24             	mov    %eax,(%esp)
801039c6:	e8 51 ff ff ff       	call   8010391c <p2v>
801039cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801039d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d4:	01 d0                	add    %edx,%eax
801039d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039df:	eb 3f                	jmp    80103a20 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039e1:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039e8:	00 
801039e9:	c7 44 24 04 98 94 10 	movl   $0x80109498,0x4(%esp)
801039f0:	80 
801039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f4:	89 04 24             	mov    %eax,(%esp)
801039f7:	e8 74 24 00 00       	call   80105e70 <memcmp>
801039fc:	85 c0                	test   %eax,%eax
801039fe:	75 1c                	jne    80103a1c <mpsearch1+0x62>
80103a00:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a07:	00 
80103a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a0b:	89 04 24             	mov    %eax,(%esp)
80103a0e:	e8 6f ff ff ff       	call   80103982 <sum>
80103a13:	84 c0                	test   %al,%al
80103a15:	75 05                	jne    80103a1c <mpsearch1+0x62>
      return (struct mp*)p;
80103a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1a:	eb 11                	jmp    80103a2d <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a1c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a26:	72 b9                	jb     801039e1 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a2d:	c9                   	leave  
80103a2e:	c3                   	ret    

80103a2f <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a2f:	55                   	push   %ebp
80103a30:	89 e5                	mov    %esp,%ebp
80103a32:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a35:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a3f:	83 c0 0f             	add    $0xf,%eax
80103a42:	0f b6 00             	movzbl (%eax),%eax
80103a45:	0f b6 c0             	movzbl %al,%eax
80103a48:	c1 e0 08             	shl    $0x8,%eax
80103a4b:	89 c2                	mov    %eax,%edx
80103a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a50:	83 c0 0e             	add    $0xe,%eax
80103a53:	0f b6 00             	movzbl (%eax),%eax
80103a56:	0f b6 c0             	movzbl %al,%eax
80103a59:	09 d0                	or     %edx,%eax
80103a5b:	c1 e0 04             	shl    $0x4,%eax
80103a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a65:	74 21                	je     80103a88 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a67:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a6e:	00 
80103a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a72:	89 04 24             	mov    %eax,(%esp)
80103a75:	e8 40 ff ff ff       	call   801039ba <mpsearch1>
80103a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a81:	74 50                	je     80103ad3 <mpsearch+0xa4>
      return mp;
80103a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a86:	eb 5f                	jmp    80103ae7 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8b:	83 c0 14             	add    $0x14,%eax
80103a8e:	0f b6 00             	movzbl (%eax),%eax
80103a91:	0f b6 c0             	movzbl %al,%eax
80103a94:	c1 e0 08             	shl    $0x8,%eax
80103a97:	89 c2                	mov    %eax,%edx
80103a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9c:	83 c0 13             	add    $0x13,%eax
80103a9f:	0f b6 00             	movzbl (%eax),%eax
80103aa2:	0f b6 c0             	movzbl %al,%eax
80103aa5:	09 d0                	or     %edx,%eax
80103aa7:	c1 e0 0a             	shl    $0xa,%eax
80103aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab0:	2d 00 04 00 00       	sub    $0x400,%eax
80103ab5:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103abc:	00 
80103abd:	89 04 24             	mov    %eax,(%esp)
80103ac0:	e8 f5 fe ff ff       	call   801039ba <mpsearch1>
80103ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103acc:	74 05                	je     80103ad3 <mpsearch+0xa4>
      return mp;
80103ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ad1:	eb 14                	jmp    80103ae7 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ad3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ada:	00 
80103adb:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103ae2:	e8 d3 fe ff ff       	call   801039ba <mpsearch1>
}
80103ae7:	c9                   	leave  
80103ae8:	c3                   	ret    

80103ae9 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ae9:	55                   	push   %ebp
80103aea:	89 e5                	mov    %esp,%ebp
80103aec:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103aef:	e8 3b ff ff ff       	call   80103a2f <mpsearch>
80103af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103afb:	74 0a                	je     80103b07 <mpconfig+0x1e>
80103afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b00:	8b 40 04             	mov    0x4(%eax),%eax
80103b03:	85 c0                	test   %eax,%eax
80103b05:	75 0a                	jne    80103b11 <mpconfig+0x28>
    return 0;
80103b07:	b8 00 00 00 00       	mov    $0x0,%eax
80103b0c:	e9 83 00 00 00       	jmp    80103b94 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b14:	8b 40 04             	mov    0x4(%eax),%eax
80103b17:	89 04 24             	mov    %eax,(%esp)
80103b1a:	e8 fd fd ff ff       	call   8010391c <p2v>
80103b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b22:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b29:	00 
80103b2a:	c7 44 24 04 9d 94 10 	movl   $0x8010949d,0x4(%esp)
80103b31:	80 
80103b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b35:	89 04 24             	mov    %eax,(%esp)
80103b38:	e8 33 23 00 00       	call   80105e70 <memcmp>
80103b3d:	85 c0                	test   %eax,%eax
80103b3f:	74 07                	je     80103b48 <mpconfig+0x5f>
    return 0;
80103b41:	b8 00 00 00 00       	mov    $0x0,%eax
80103b46:	eb 4c                	jmp    80103b94 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b4b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b4f:	3c 01                	cmp    $0x1,%al
80103b51:	74 12                	je     80103b65 <mpconfig+0x7c>
80103b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b56:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b5a:	3c 04                	cmp    $0x4,%al
80103b5c:	74 07                	je     80103b65 <mpconfig+0x7c>
    return 0;
80103b5e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b63:	eb 2f                	jmp    80103b94 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b68:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b6c:	0f b7 c0             	movzwl %ax,%eax
80103b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b76:	89 04 24             	mov    %eax,(%esp)
80103b79:	e8 04 fe ff ff       	call   80103982 <sum>
80103b7e:	84 c0                	test   %al,%al
80103b80:	74 07                	je     80103b89 <mpconfig+0xa0>
    return 0;
80103b82:	b8 00 00 00 00       	mov    $0x0,%eax
80103b87:	eb 0b                	jmp    80103b94 <mpconfig+0xab>
  *pmp = mp;
80103b89:	8b 45 08             	mov    0x8(%ebp),%eax
80103b8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b8f:	89 10                	mov    %edx,(%eax)
  return conf;
80103b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b94:	c9                   	leave  
80103b95:	c3                   	ret    

80103b96 <mpinit>:

void
mpinit(void)
{
80103b96:	55                   	push   %ebp
80103b97:	89 e5                	mov    %esp,%ebp
80103b99:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103b9c:	c7 05 c4 c6 10 80 e0 	movl   $0x801133e0,0x8010c6c4
80103ba3:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ba6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ba9:	89 04 24             	mov    %eax,(%esp)
80103bac:	e8 38 ff ff ff       	call   80103ae9 <mpconfig>
80103bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bb8:	75 05                	jne    80103bbf <mpinit+0x29>
    return;
80103bba:	e9 9c 01 00 00       	jmp    80103d5b <mpinit+0x1c5>
  ismp = 1;
80103bbf:	c7 05 c4 33 11 80 01 	movl   $0x1,0x801133c4
80103bc6:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcc:	8b 40 24             	mov    0x24(%eax),%eax
80103bcf:	a3 dc 32 11 80       	mov    %eax,0x801132dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd7:	83 c0 2c             	add    $0x2c,%eax
80103bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103be4:	0f b7 d0             	movzwl %ax,%edx
80103be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bea:	01 d0                	add    %edx,%eax
80103bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bef:	e9 f4 00 00 00       	jmp    80103ce8 <mpinit+0x152>
    switch(*p){
80103bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf7:	0f b6 00             	movzbl (%eax),%eax
80103bfa:	0f b6 c0             	movzbl %al,%eax
80103bfd:	83 f8 04             	cmp    $0x4,%eax
80103c00:	0f 87 bf 00 00 00    	ja     80103cc5 <mpinit+0x12f>
80103c06:	8b 04 85 e0 94 10 80 	mov    -0x7fef6b20(,%eax,4),%eax
80103c0d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c12:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c15:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c18:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c1c:	0f b6 d0             	movzbl %al,%edx
80103c1f:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80103c24:	39 c2                	cmp    %eax,%edx
80103c26:	74 2d                	je     80103c55 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c2b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c2f:	0f b6 d0             	movzbl %al,%edx
80103c32:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80103c37:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c3f:	c7 04 24 a2 94 10 80 	movl   $0x801094a2,(%esp)
80103c46:	e8 55 c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c4b:	c7 05 c4 33 11 80 00 	movl   $0x0,0x801133c4
80103c52:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c58:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c5c:	0f b6 c0             	movzbl %al,%eax
80103c5f:	83 e0 02             	and    $0x2,%eax
80103c62:	85 c0                	test   %eax,%eax
80103c64:	74 15                	je     80103c7b <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c66:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80103c6b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c71:	05 e0 33 11 80       	add    $0x801133e0,%eax
80103c76:	a3 c4 c6 10 80       	mov    %eax,0x8010c6c4
      cpus[ncpu].id = ncpu;
80103c7b:	8b 15 c0 39 11 80    	mov    0x801139c0,%edx
80103c81:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80103c86:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103c8c:	81 c2 e0 33 11 80    	add    $0x801133e0,%edx
80103c92:	88 02                	mov    %al,(%edx)
      ncpu++;
80103c94:	a1 c0 39 11 80       	mov    0x801139c0,%eax
80103c99:	83 c0 01             	add    $0x1,%eax
80103c9c:	a3 c0 39 11 80       	mov    %eax,0x801139c0
      p += sizeof(struct mpproc);
80103ca1:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ca5:	eb 41                	jmp    80103ce8 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cb0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cb4:	a2 c0 33 11 80       	mov    %al,0x801133c0
      p += sizeof(struct mpioapic);
80103cb9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cbd:	eb 29                	jmp    80103ce8 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cbf:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cc3:	eb 23                	jmp    80103ce8 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc8:	0f b6 00             	movzbl (%eax),%eax
80103ccb:	0f b6 c0             	movzbl %al,%eax
80103cce:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cd2:	c7 04 24 c0 94 10 80 	movl   $0x801094c0,(%esp)
80103cd9:	e8 c2 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103cde:	c7 05 c4 33 11 80 00 	movl   $0x0,0x801133c4
80103ce5:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cee:	0f 82 00 ff ff ff    	jb     80103bf4 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103cf4:	a1 c4 33 11 80       	mov    0x801133c4,%eax
80103cf9:	85 c0                	test   %eax,%eax
80103cfb:	75 1d                	jne    80103d1a <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103cfd:	c7 05 c0 39 11 80 01 	movl   $0x1,0x801139c0
80103d04:	00 00 00 
    lapic = 0;
80103d07:	c7 05 dc 32 11 80 00 	movl   $0x0,0x801132dc
80103d0e:	00 00 00 
    ioapicid = 0;
80103d11:	c6 05 c0 33 11 80 00 	movb   $0x0,0x801133c0
    return;
80103d18:	eb 41                	jmp    80103d5b <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d1d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d21:	84 c0                	test   %al,%al
80103d23:	74 36                	je     80103d5b <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d25:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d2c:	00 
80103d2d:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d34:	e8 0d fc ff ff       	call   80103946 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d39:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d40:	e8 e4 fb ff ff       	call   80103929 <inb>
80103d45:	83 c8 01             	or     $0x1,%eax
80103d48:	0f b6 c0             	movzbl %al,%eax
80103d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d4f:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d56:	e8 eb fb ff ff       	call   80103946 <outb>
  }
}
80103d5b:	c9                   	leave  
80103d5c:	c3                   	ret    

80103d5d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d5d:	55                   	push   %ebp
80103d5e:	89 e5                	mov    %esp,%ebp
80103d60:	83 ec 08             	sub    $0x8,%esp
80103d63:	8b 55 08             	mov    0x8(%ebp),%edx
80103d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d69:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d6d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d70:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d74:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d78:	ee                   	out    %al,(%dx)
}
80103d79:	c9                   	leave  
80103d7a:	c3                   	ret    

80103d7b <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103d7b:	55                   	push   %ebp
80103d7c:	89 e5                	mov    %esp,%ebp
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	8b 45 08             	mov    0x8(%ebp),%eax
80103d84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103d88:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d8c:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103d92:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d96:	0f b6 c0             	movzbl %al,%eax
80103d99:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d9d:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103da4:	e8 b4 ff ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, mask >> 8);
80103da9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dad:	66 c1 e8 08          	shr    $0x8,%ax
80103db1:	0f b6 c0             	movzbl %al,%eax
80103db4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103db8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103dbf:	e8 99 ff ff ff       	call   80103d5d <outb>
}
80103dc4:	c9                   	leave  
80103dc5:	c3                   	ret    

80103dc6 <picenable>:

void
picenable(int irq)
{
80103dc6:	55                   	push   %ebp
80103dc7:	89 e5                	mov    %esp,%ebp
80103dc9:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcf:	ba 01 00 00 00       	mov    $0x1,%edx
80103dd4:	89 c1                	mov    %eax,%ecx
80103dd6:	d3 e2                	shl    %cl,%edx
80103dd8:	89 d0                	mov    %edx,%eax
80103dda:	f7 d0                	not    %eax
80103ddc:	89 c2                	mov    %eax,%edx
80103dde:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103de5:	21 d0                	and    %edx,%eax
80103de7:	0f b7 c0             	movzwl %ax,%eax
80103dea:	89 04 24             	mov    %eax,(%esp)
80103ded:	e8 89 ff ff ff       	call   80103d7b <picsetmask>
}
80103df2:	c9                   	leave  
80103df3:	c3                   	ret    

80103df4 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103dfa:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e01:	00 
80103e02:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e09:	e8 4f ff ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, 0xFF);
80103e0e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e15:	00 
80103e16:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e1d:	e8 3b ff ff ff       	call   80103d5d <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e22:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e29:	00 
80103e2a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e31:	e8 27 ff ff ff       	call   80103d5d <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e36:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e3d:	00 
80103e3e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e45:	e8 13 ff ff ff       	call   80103d5d <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e4a:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e51:	00 
80103e52:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e59:	e8 ff fe ff ff       	call   80103d5d <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e5e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e65:	00 
80103e66:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e6d:	e8 eb fe ff ff       	call   80103d5d <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103e72:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e79:	00 
80103e7a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103e81:	e8 d7 fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103e86:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103e8d:	00 
80103e8e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e95:	e8 c3 fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103e9a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ea1:	00 
80103ea2:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ea9:	e8 af fe ff ff       	call   80103d5d <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103eae:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103eb5:	00 
80103eb6:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ebd:	e8 9b fe ff ff       	call   80103d5d <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ec2:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ec9:	00 
80103eca:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ed1:	e8 87 fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ed6:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103edd:	00 
80103ede:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ee5:	e8 73 fe ff ff       	call   80103d5d <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103eea:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ef1:	00 
80103ef2:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ef9:	e8 5f fe ff ff       	call   80103d5d <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103efe:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f05:	00 
80103f06:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f0d:	e8 4b fe ff ff       	call   80103d5d <outb>

  if(irqmask != 0xFFFF)
80103f12:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f19:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f1d:	74 12                	je     80103f31 <picinit+0x13d>
    picsetmask(irqmask);
80103f1f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f26:	0f b7 c0             	movzwl %ax,%eax
80103f29:	89 04 24             	mov    %eax,(%esp)
80103f2c:	e8 4a fe ff ff       	call   80103d7b <picsetmask>
}
80103f31:	c9                   	leave  
80103f32:	c3                   	ret    

80103f33 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f33:	55                   	push   %ebp
80103f34:	89 e5                	mov    %esp,%ebp
80103f36:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f40:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f49:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f4c:	8b 10                	mov    (%eax),%edx
80103f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f51:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f53:	e8 e0 cf ff ff       	call   80100f38 <filealloc>
80103f58:	8b 55 08             	mov    0x8(%ebp),%edx
80103f5b:	89 02                	mov    %eax,(%edx)
80103f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f60:	8b 00                	mov    (%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	0f 84 c8 00 00 00    	je     80104032 <pipealloc+0xff>
80103f6a:	e8 c9 cf ff ff       	call   80100f38 <filealloc>
80103f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f72:	89 02                	mov    %eax,(%edx)
80103f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f77:	8b 00                	mov    (%eax),%eax
80103f79:	85 c0                	test   %eax,%eax
80103f7b:	0f 84 b1 00 00 00    	je     80104032 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f81:	e8 6e eb ff ff       	call   80102af4 <kalloc>
80103f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f8d:	75 05                	jne    80103f94 <pipealloc+0x61>
    goto bad;
80103f8f:	e9 9e 00 00 00       	jmp    80104032 <pipealloc+0xff>
  p->readopen = 1;
80103f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f97:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f9e:	00 00 00 
  p->writeopen = 1;
80103fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fab:	00 00 00 
  p->nwrite = 0;
80103fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fb8:	00 00 00 
  p->nread = 0;
80103fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fbe:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fc5:	00 00 00 
  initlock(&p->lock, "pipe");
80103fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcb:	c7 44 24 04 f4 94 10 	movl   $0x801094f4,0x4(%esp)
80103fd2:	80 
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 a9 1b 00 00       	call   80105b84 <initlock>
  (*f0)->type = FD_PIPE;
80103fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fde:	8b 00                	mov    (%eax),%eax
80103fe0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe9:	8b 00                	mov    (%eax),%eax
80103feb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103fef:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff2:	8b 00                	mov    (%eax),%eax
80103ff4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffb:	8b 00                	mov    (%eax),%eax
80103ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104000:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104003:	8b 45 0c             	mov    0xc(%ebp),%eax
80104006:	8b 00                	mov    (%eax),%eax
80104008:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010400e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104011:	8b 00                	mov    (%eax),%eax
80104013:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104017:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401a:	8b 00                	mov    (%eax),%eax
8010401c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104020:	8b 45 0c             	mov    0xc(%ebp),%eax
80104023:	8b 00                	mov    (%eax),%eax
80104025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104028:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010402b:	b8 00 00 00 00       	mov    $0x0,%eax
80104030:	eb 42                	jmp    80104074 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104036:	74 0b                	je     80104043 <pipealloc+0x110>
    kfree((char*)p);
80104038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403b:	89 04 24             	mov    %eax,(%esp)
8010403e:	e8 18 ea ff ff       	call   80102a5b <kfree>
  if(*f0)
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
80104046:	8b 00                	mov    (%eax),%eax
80104048:	85 c0                	test   %eax,%eax
8010404a:	74 0d                	je     80104059 <pipealloc+0x126>
    fileclose(*f0);
8010404c:	8b 45 08             	mov    0x8(%ebp),%eax
8010404f:	8b 00                	mov    (%eax),%eax
80104051:	89 04 24             	mov    %eax,(%esp)
80104054:	e8 87 cf ff ff       	call   80100fe0 <fileclose>
  if(*f1)
80104059:	8b 45 0c             	mov    0xc(%ebp),%eax
8010405c:	8b 00                	mov    (%eax),%eax
8010405e:	85 c0                	test   %eax,%eax
80104060:	74 0d                	je     8010406f <pipealloc+0x13c>
    fileclose(*f1);
80104062:	8b 45 0c             	mov    0xc(%ebp),%eax
80104065:	8b 00                	mov    (%eax),%eax
80104067:	89 04 24             	mov    %eax,(%esp)
8010406a:	e8 71 cf ff ff       	call   80100fe0 <fileclose>
  return -1;
8010406f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104074:	c9                   	leave  
80104075:	c3                   	ret    

80104076 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104076:	55                   	push   %ebp
80104077:	89 e5                	mov    %esp,%ebp
80104079:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010407c:	8b 45 08             	mov    0x8(%ebp),%eax
8010407f:	89 04 24             	mov    %eax,(%esp)
80104082:	e8 1e 1b 00 00       	call   80105ba5 <acquire>
  if(writable){
80104087:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010408b:	74 1f                	je     801040ac <pipeclose+0x36>
    p->writeopen = 0;
8010408d:	8b 45 08             	mov    0x8(%ebp),%eax
80104090:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104097:	00 00 00 
    wakeup(&p->nread);
8010409a:	8b 45 08             	mov    0x8(%ebp),%eax
8010409d:	05 34 02 00 00       	add    $0x234,%eax
801040a2:	89 04 24             	mov    %eax,(%esp)
801040a5:	e8 72 12 00 00       	call   8010531c <wakeup>
801040aa:	eb 1d                	jmp    801040c9 <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040ac:	8b 45 08             	mov    0x8(%ebp),%eax
801040af:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040b6:	00 00 00 
    wakeup(&p->nwrite);
801040b9:	8b 45 08             	mov    0x8(%ebp),%eax
801040bc:	05 38 02 00 00       	add    $0x238,%eax
801040c1:	89 04 24             	mov    %eax,(%esp)
801040c4:	e8 53 12 00 00       	call   8010531c <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040c9:	8b 45 08             	mov    0x8(%ebp),%eax
801040cc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040d2:	85 c0                	test   %eax,%eax
801040d4:	75 25                	jne    801040fb <pipeclose+0x85>
801040d6:	8b 45 08             	mov    0x8(%ebp),%eax
801040d9:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040df:	85 c0                	test   %eax,%eax
801040e1:	75 18                	jne    801040fb <pipeclose+0x85>
    release(&p->lock);
801040e3:	8b 45 08             	mov    0x8(%ebp),%eax
801040e6:	89 04 24             	mov    %eax,(%esp)
801040e9:	e8 19 1b 00 00       	call   80105c07 <release>
    kfree((char*)p);
801040ee:	8b 45 08             	mov    0x8(%ebp),%eax
801040f1:	89 04 24             	mov    %eax,(%esp)
801040f4:	e8 62 e9 ff ff       	call   80102a5b <kfree>
801040f9:	eb 0b                	jmp    80104106 <pipeclose+0x90>
  } else
    release(&p->lock);
801040fb:	8b 45 08             	mov    0x8(%ebp),%eax
801040fe:	89 04 24             	mov    %eax,(%esp)
80104101:	e8 01 1b 00 00       	call   80105c07 <release>
}
80104106:	c9                   	leave  
80104107:	c3                   	ret    

80104108 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104108:	55                   	push   %ebp
80104109:	89 e5                	mov    %esp,%ebp
8010410b:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
8010410e:	8b 45 08             	mov    0x8(%ebp),%eax
80104111:	89 04 24             	mov    %eax,(%esp)
80104114:	e8 8c 1a 00 00       	call   80105ba5 <acquire>
  for(i = 0; i < n; i++){
80104119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104120:	e9 a6 00 00 00       	jmp    801041cb <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104125:	eb 57                	jmp    8010417e <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80104127:	8b 45 08             	mov    0x8(%ebp),%eax
8010412a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104130:	85 c0                	test   %eax,%eax
80104132:	74 0d                	je     80104141 <pipewrite+0x39>
80104134:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010413a:	8b 40 24             	mov    0x24(%eax),%eax
8010413d:	85 c0                	test   %eax,%eax
8010413f:	74 15                	je     80104156 <pipewrite+0x4e>
        release(&p->lock);
80104141:	8b 45 08             	mov    0x8(%ebp),%eax
80104144:	89 04 24             	mov    %eax,(%esp)
80104147:	e8 bb 1a 00 00       	call   80105c07 <release>
        return -1;
8010414c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104151:	e9 9f 00 00 00       	jmp    801041f5 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80104156:	8b 45 08             	mov    0x8(%ebp),%eax
80104159:	05 34 02 00 00       	add    $0x234,%eax
8010415e:	89 04 24             	mov    %eax,(%esp)
80104161:	e8 b6 11 00 00       	call   8010531c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104166:	8b 45 08             	mov    0x8(%ebp),%eax
80104169:	8b 55 08             	mov    0x8(%ebp),%edx
8010416c:	81 c2 38 02 00 00    	add    $0x238,%edx
80104172:	89 44 24 04          	mov    %eax,0x4(%esp)
80104176:	89 14 24             	mov    %edx,(%esp)
80104179:	e8 5b 0f 00 00       	call   801050d9 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010417e:	8b 45 08             	mov    0x8(%ebp),%eax
80104181:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104187:	8b 45 08             	mov    0x8(%ebp),%eax
8010418a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104190:	05 00 02 00 00       	add    $0x200,%eax
80104195:	39 c2                	cmp    %eax,%edx
80104197:	74 8e                	je     80104127 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104199:	8b 45 08             	mov    0x8(%ebp),%eax
8010419c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041a2:	8d 48 01             	lea    0x1(%eax),%ecx
801041a5:	8b 55 08             	mov    0x8(%ebp),%edx
801041a8:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041ae:	25 ff 01 00 00       	and    $0x1ff,%eax
801041b3:	89 c1                	mov    %eax,%ecx
801041b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801041bb:	01 d0                	add    %edx,%eax
801041bd:	0f b6 10             	movzbl (%eax),%edx
801041c0:	8b 45 08             	mov    0x8(%ebp),%eax
801041c3:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ce:	3b 45 10             	cmp    0x10(%ebp),%eax
801041d1:	0f 8c 4e ff ff ff    	jl     80104125 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041d7:	8b 45 08             	mov    0x8(%ebp),%eax
801041da:	05 34 02 00 00       	add    $0x234,%eax
801041df:	89 04 24             	mov    %eax,(%esp)
801041e2:	e8 35 11 00 00       	call   8010531c <wakeup>
  release(&p->lock);
801041e7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ea:	89 04 24             	mov    %eax,(%esp)
801041ed:	e8 15 1a 00 00       	call   80105c07 <release>
  return n;
801041f2:	8b 45 10             	mov    0x10(%ebp),%eax
}
801041f5:	c9                   	leave  
801041f6:	c3                   	ret    

801041f7 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801041f7:	55                   	push   %ebp
801041f8:	89 e5                	mov    %esp,%ebp
801041fa:	53                   	push   %ebx
801041fb:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104201:	89 04 24             	mov    %eax,(%esp)
80104204:	e8 9c 19 00 00       	call   80105ba5 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104209:	eb 3a                	jmp    80104245 <piperead+0x4e>
    if(proc->killed){
8010420b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104211:	8b 40 24             	mov    0x24(%eax),%eax
80104214:	85 c0                	test   %eax,%eax
80104216:	74 15                	je     8010422d <piperead+0x36>
      release(&p->lock);
80104218:	8b 45 08             	mov    0x8(%ebp),%eax
8010421b:	89 04 24             	mov    %eax,(%esp)
8010421e:	e8 e4 19 00 00       	call   80105c07 <release>
      return -1;
80104223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104228:	e9 b5 00 00 00       	jmp    801042e2 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010422d:	8b 45 08             	mov    0x8(%ebp),%eax
80104230:	8b 55 08             	mov    0x8(%ebp),%edx
80104233:	81 c2 34 02 00 00    	add    $0x234,%edx
80104239:	89 44 24 04          	mov    %eax,0x4(%esp)
8010423d:	89 14 24             	mov    %edx,(%esp)
80104240:	e8 94 0e 00 00       	call   801050d9 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104245:	8b 45 08             	mov    0x8(%ebp),%eax
80104248:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010424e:	8b 45 08             	mov    0x8(%ebp),%eax
80104251:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104257:	39 c2                	cmp    %eax,%edx
80104259:	75 0d                	jne    80104268 <piperead+0x71>
8010425b:	8b 45 08             	mov    0x8(%ebp),%eax
8010425e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104264:	85 c0                	test   %eax,%eax
80104266:	75 a3                	jne    8010420b <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104268:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010426f:	eb 4b                	jmp    801042bc <piperead+0xc5>
    if(p->nread == p->nwrite)
80104271:	8b 45 08             	mov    0x8(%ebp),%eax
80104274:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010427a:	8b 45 08             	mov    0x8(%ebp),%eax
8010427d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104283:	39 c2                	cmp    %eax,%edx
80104285:	75 02                	jne    80104289 <piperead+0x92>
      break;
80104287:	eb 3b                	jmp    801042c4 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104289:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010428c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104292:	8b 45 08             	mov    0x8(%ebp),%eax
80104295:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010429b:	8d 48 01             	lea    0x1(%eax),%ecx
8010429e:	8b 55 08             	mov    0x8(%ebp),%edx
801042a1:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042a7:	25 ff 01 00 00       	and    $0x1ff,%eax
801042ac:	89 c2                	mov    %eax,%edx
801042ae:	8b 45 08             	mov    0x8(%ebp),%eax
801042b1:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042b6:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bf:	3b 45 10             	cmp    0x10(%ebp),%eax
801042c2:	7c ad                	jl     80104271 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042c4:	8b 45 08             	mov    0x8(%ebp),%eax
801042c7:	05 38 02 00 00       	add    $0x238,%eax
801042cc:	89 04 24             	mov    %eax,(%esp)
801042cf:	e8 48 10 00 00       	call   8010531c <wakeup>
  release(&p->lock);
801042d4:	8b 45 08             	mov    0x8(%ebp),%eax
801042d7:	89 04 24             	mov    %eax,(%esp)
801042da:	e8 28 19 00 00       	call   80105c07 <release>
  return i;
801042df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042e2:	83 c4 24             	add    $0x24,%esp
801042e5:	5b                   	pop    %ebx
801042e6:	5d                   	pop    %ebp
801042e7:	c3                   	ret    

801042e8 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801042e8:	55                   	push   %ebp
801042e9:	89 e5                	mov    %esp,%ebp
801042eb:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042ee:	9c                   	pushf  
801042ef:	58                   	pop    %eax
801042f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801042f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801042f6:	c9                   	leave  
801042f7:	c3                   	ret    

801042f8 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801042f8:	55                   	push   %ebp
801042f9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801042fb:	fb                   	sti    
}
801042fc:	5d                   	pop    %ebp
801042fd:	c3                   	ret    

801042fe <cas>:
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
}

static inline int cas(volatile int* addr, int expected, int newval) {
801042fe:	55                   	push   %ebp
801042ff:	89 e5                	mov    %esp,%ebp
80104301:	83 ec 10             	sub    $0x10,%esp
  int result = 0; 
80104304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  asm volatile("lock; cmpxchgl %1, %2; sete %%al;":/* assembly code template */  
8010430b:	8b 55 10             	mov    0x10(%ebp),%edx
8010430e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104311:	8b 45 0c             	mov    0xc(%ebp),%eax
80104314:	f0 0f b1 11          	lock cmpxchg %edx,(%ecx)
80104318:	0f 94 c0             	sete   %al
8010431b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "=a"(result) : /* output parameters */
               "r"(newval), "m"(*addr), "a"(expected) : /* input params */ 
               "cc", "memory");
  return result;
8010431e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104321:	c9                   	leave  
80104322:	c3                   	ret    

80104323 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104323:	55                   	push   %ebp
80104324:	89 e5                	mov    %esp,%ebp
  //panic("called pinit wtf \n");
 // initlock(&ptable.lock, "ptable");
}
80104326:	5d                   	pop    %ebp
80104327:	c3                   	ret    

80104328 <allocpid>:


int
allocpid(void) 
{
80104328:	55                   	push   %ebp
80104329:	89 e5                	mov    %esp,%ebp
8010432b:	83 ec 1c             	sub    $0x1c,%esp
  int pid;
  do {
    pid = nextpid;
8010432e:	a1 48 c0 10 80       	mov    0x8010c048,%eax
80104333:	89 45 fc             	mov    %eax,-0x4(%ebp)
  } while(!cas(&nextpid, pid, pid + 1));
80104336:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104339:	83 c0 01             	add    $0x1,%eax
8010433c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104340:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104343:	89 44 24 04          	mov    %eax,0x4(%esp)
80104347:	c7 04 24 48 c0 10 80 	movl   $0x8010c048,(%esp)
8010434e:	e8 ab ff ff ff       	call   801042fe <cas>
80104353:	85 c0                	test   %eax,%eax
80104355:	74 d7                	je     8010432e <allocpid+0x6>
  return pid+1;
80104357:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010435a:	83 c0 01             	add    $0x1,%eax
}
8010435d:	c9                   	leave  
8010435e:	c3                   	ret    

8010435f <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010435f:	55                   	push   %ebp
80104360:	89 e5                	mov    %esp,%ebp
80104362:	83 ec 28             	sub    $0x28,%esp
  char *sp;
  int expected;
  struct cstackframe* cstack_iter;
  
  do {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104365:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
8010436c:	eb 1a                	jmp    80104388 <allocproc+0x29>
      if(UNUSED == p->state) { // found an unused fellow.
8010436e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104371:	8b 40 0c             	mov    0xc(%eax),%eax
80104374:	85 c0                	test   %eax,%eax
80104376:	75 09                	jne    80104381 <allocproc+0x22>
        expected = UNUSED;
80104378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        break;
8010437f:	eb 10                	jmp    80104391 <allocproc+0x32>
  char *sp;
  int expected;
  struct cstackframe* cstack_iter;
  
  do {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104381:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
80104388:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
8010438f:	72 dd                	jb     8010436e <allocproc+0xf>
      if(UNUSED == p->state) { // found an unused fellow.
        expected = UNUSED;
        break;
      }
    if(NPROC + ptable.proc == p) {
80104391:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80104398:	75 0a                	jne    801043a4 <allocproc+0x45>
      return 0;
8010439a:	b8 00 00 00 00       	mov    $0x0,%eax
8010439f:	e9 03 01 00 00       	jmp    801044a7 <allocproc+0x148>
    }
  } while(!cas(&p->state, expected, EMBRYO));
801043a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a7:	8d 50 0c             	lea    0xc(%eax),%edx
801043aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801043b1:	00 
801043b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801043b9:	89 14 24             	mov    %edx,(%esp)
801043bc:	e8 3d ff ff ff       	call   801042fe <cas>
801043c1:	85 c0                	test   %eax,%eax
801043c3:	74 a0                	je     80104365 <allocproc+0x6>
  p->pid = allocpid();
801043c5:	e8 5e ff ff ff       	call   80104328 <allocpid>
801043ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043cd:	89 42 10             	mov    %eax,0x10(%edx)


  // SIGNALZ -- gettiing the cstack up and ready.
  p->in_handler = OUT_HANDLER;
801043d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d3:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
801043da:	00 00 00 
  p->sig_handler = DEFAULT_HANDLER; 
801043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e0:	c7 40 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%eax)
  p->cstack.head = EMPTY_STACK;
801043e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ea:	c7 80 48 01 00 00 00 	movl   $0x0,0x148(%eax)
801043f1:	00 00 00 
  cstack_iter = p->cstack.frames;
801043f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f7:	83 e8 80             	sub    $0xffffff80,%eax
801043fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  while(cstack_iter != p->cstack.frames + CSTACK_SIZE)
801043fd:	eb 10                	jmp    8010440f <allocproc+0xb0>
    (cstack_iter++)->used = CSTACKFRAME_UNUSED;
801043ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104402:	8d 50 14             	lea    0x14(%eax),%edx
80104405:	89 55 ec             	mov    %edx,-0x14(%ebp)
80104408:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  // SIGNALZ -- gettiing the cstack up and ready.
  p->in_handler = OUT_HANDLER;
  p->sig_handler = DEFAULT_HANDLER; 
  p->cstack.head = EMPTY_STACK;
  cstack_iter = p->cstack.frames;
  while(cstack_iter != p->cstack.frames + CSTACK_SIZE)
8010440f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104412:	05 48 01 00 00       	add    $0x148,%eax
80104417:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010441a:	75 e3                	jne    801043ff <allocproc+0xa0>
    (cstack_iter++)->used = CSTACKFRAME_UNUSED;

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010441c:	e8 d3 e6 ff ff       	call   80102af4 <kalloc>
80104421:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104424:	89 42 08             	mov    %eax,0x8(%edx)
80104427:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442a:	8b 40 08             	mov    0x8(%eax),%eax
8010442d:	85 c0                	test   %eax,%eax
8010442f:	75 11                	jne    80104442 <allocproc+0xe3>
    p->state = UNUSED;
80104431:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104434:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010443b:	b8 00 00 00 00       	mov    $0x0,%eax
80104440:	eb 65                	jmp    801044a7 <allocproc+0x148>
  }
  sp = p->kstack + KSTACKSIZE;
80104442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104445:	8b 40 08             	mov    0x8(%eax),%eax
80104448:	05 00 10 00 00       	add    $0x1000,%eax
8010444d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104450:	83 6d e8 4c          	subl   $0x4c,-0x18(%ebp)
  p->tf = (struct trapframe*)sp;
80104454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104457:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010445a:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010445d:	83 6d e8 04          	subl   $0x4,-0x18(%ebp)
  *(uint*)sp = (uint)trapret;
80104461:	ba b4 72 10 80       	mov    $0x801072b4,%edx
80104466:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104469:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010446b:	83 6d e8 14          	subl   $0x14,-0x18(%ebp)
  p->context = (struct context*)sp;
8010446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104472:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104475:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010447e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104485:	00 
80104486:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010448d:	00 
8010448e:	89 04 24             	mov    %eax,(%esp)
80104491:	e8 63 19 00 00       	call   80105df9 <memset>
  p->context->eip = (uint)forkret;
80104496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104499:	8b 40 1c             	mov    0x1c(%eax),%eax
8010449c:	ba b4 50 10 80       	mov    $0x801050b4,%edx
801044a1:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044a7:	c9                   	leave  
801044a8:	c3                   	ret    

801044a9 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044a9:	55                   	push   %ebp
801044aa:	89 e5                	mov    %esp,%ebp
801044ac:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801044af:	e8 ab fe ff ff       	call   8010435f <allocproc>
801044b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801044b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ba:	a3 c8 c6 10 80       	mov    %eax,0x8010c6c8
  if((p->pgdir = setupkvm()) == 0)
801044bf:	e8 f3 44 00 00       	call   801089b7 <setupkvm>
801044c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c7:	89 42 04             	mov    %eax,0x4(%edx)
801044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cd:	8b 40 04             	mov    0x4(%eax),%eax
801044d0:	85 c0                	test   %eax,%eax
801044d2:	75 0c                	jne    801044e0 <userinit+0x37>
    panic("userinit: out of memory?");
801044d4:	c7 04 24 56 95 10 80 	movl   $0x80109556,(%esp)
801044db:	e8 5a c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044e0:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e8:	8b 40 04             	mov    0x4(%eax),%eax
801044eb:	89 54 24 08          	mov    %edx,0x8(%esp)
801044ef:	c7 44 24 04 60 c5 10 	movl   $0x8010c560,0x4(%esp)
801044f6:	80 
801044f7:	89 04 24             	mov    %eax,(%esp)
801044fa:	e8 10 47 00 00       	call   80108c0f <inituvm>
  p->sz = PGSIZE;
801044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104502:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450b:	8b 40 18             	mov    0x18(%eax),%eax
8010450e:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104515:	00 
80104516:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010451d:	00 
8010451e:	89 04 24             	mov    %eax,(%esp)
80104521:	e8 d3 18 00 00       	call   80105df9 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104529:	8b 40 18             	mov    0x18(%eax),%eax
8010452c:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104535:	8b 40 18             	mov    0x18(%eax),%eax
80104538:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010453e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104541:	8b 40 18             	mov    0x18(%eax),%eax
80104544:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104547:	8b 52 18             	mov    0x18(%edx),%edx
8010454a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010454e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104552:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104555:	8b 40 18             	mov    0x18(%eax),%eax
80104558:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010455b:	8b 52 18             	mov    0x18(%edx),%edx
8010455e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104562:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104569:	8b 40 18             	mov    0x18(%eax),%eax
8010456c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104576:	8b 40 18             	mov    0x18(%eax),%eax
80104579:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104583:	8b 40 18             	mov    0x18(%eax),%eax
80104586:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010458d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104590:	83 c0 6c             	add    $0x6c,%eax
80104593:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010459a:	00 
8010459b:	c7 44 24 04 6f 95 10 	movl   $0x8010956f,0x4(%esp)
801045a2:	80 
801045a3:	89 04 24             	mov    %eax,(%esp)
801045a6:	e8 6e 1a 00 00       	call   80106019 <safestrcpy>
  p->cwd = namei("/");
801045ab:	c7 04 24 78 95 10 80 	movl   $0x80109578,(%esp)
801045b2:	e8 61 de ff ff       	call   80102418 <namei>
801045b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ba:	89 42 68             	mov    %eax,0x68(%edx)

  check_cas2(&p->state, EMBRYO, RUNNABLE);
801045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c0:	83 c0 0c             	add    $0xc,%eax
801045c3:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
801045ca:	00 
801045cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801045d2:	00 
801045d3:	89 04 24             	mov    %eax,(%esp)
801045d6:	e8 23 fd ff ff       	call   801042fe <cas>
801045db:	85 c0                	test   %eax,%eax
801045dd:	75 42                	jne    80104621 <userinit+0x178>
801045df:	e8 df 0d 00 00       	call   801053c3 <procdump>
801045e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ea:	8b 40 0c             	mov    0xc(%eax),%eax
801045ed:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
801045f4:	a1 24 c0 10 80       	mov    0x8010c024,%eax
801045f9:	c7 44 24 0c 99 00 00 	movl   $0x99,0xc(%esp)
80104600:	00 
80104601:	89 54 24 08          	mov    %edx,0x8(%esp)
80104605:	89 44 24 04          	mov    %eax,0x4(%esp)
80104609:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104610:	e8 8b bd ff ff       	call   801003a0 <cprintf>
80104615:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
8010461c:	e8 19 bf ff ff       	call   8010053a <panic>
  p->state = RUNNABLE;
80104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104624:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010462b:	c9                   	leave  
8010462c:	c3                   	ret    

8010462d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010462d:	55                   	push   %ebp
8010462e:	89 e5                	mov    %esp,%ebp
80104630:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104633:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104639:	8b 00                	mov    (%eax),%eax
8010463b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010463e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104642:	7e 34                	jle    80104678 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104644:	8b 55 08             	mov    0x8(%ebp),%edx
80104647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464a:	01 c2                	add    %eax,%edx
8010464c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104652:	8b 40 04             	mov    0x4(%eax),%eax
80104655:	89 54 24 08          	mov    %edx,0x8(%esp)
80104659:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010465c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104660:	89 04 24             	mov    %eax,(%esp)
80104663:	e8 1d 47 00 00       	call   80108d85 <allocuvm>
80104668:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010466b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010466f:	75 41                	jne    801046b2 <growproc+0x85>
      return -1;
80104671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104676:	eb 58                	jmp    801046d0 <growproc+0xa3>
  } else if(n < 0){
80104678:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010467c:	79 34                	jns    801046b2 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010467e:	8b 55 08             	mov    0x8(%ebp),%edx
80104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104684:	01 c2                	add    %eax,%edx
80104686:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468c:	8b 40 04             	mov    0x4(%eax),%eax
8010468f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104693:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104696:	89 54 24 04          	mov    %edx,0x4(%esp)
8010469a:	89 04 24             	mov    %eax,(%esp)
8010469d:	e8 bd 47 00 00       	call   80108e5f <deallocuvm>
801046a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046a9:	75 07                	jne    801046b2 <growproc+0x85>
      return -1;
801046ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b0:	eb 1e                	jmp    801046d0 <growproc+0xa3>
  }
  proc->sz = sz;
801046b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046bb:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c3:	89 04 24             	mov    %eax,(%esp)
801046c6:	e8 dd 43 00 00       	call   80108aa8 <switchuvm>
  return 0;
801046cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046d0:	c9                   	leave  
801046d1:	c3                   	ret    

801046d2 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046d2:	55                   	push   %ebp
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	57                   	push   %edi
801046d6:	56                   	push   %esi
801046d7:	53                   	push   %ebx
801046d8:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046db:	e8 7f fc ff ff       	call   8010435f <allocproc>
801046e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046e7:	75 0a                	jne    801046f3 <fork+0x21>
    return -1;
801046e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ee:	e9 ad 01 00 00       	jmp    801048a0 <fork+0x1ce>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f9:	8b 10                	mov    (%eax),%edx
801046fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104701:	8b 40 04             	mov    0x4(%eax),%eax
80104704:	89 54 24 04          	mov    %edx,0x4(%esp)
80104708:	89 04 24             	mov    %eax,(%esp)
8010470b:	e8 eb 48 00 00       	call   80108ffb <copyuvm>
80104710:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104713:	89 42 04             	mov    %eax,0x4(%edx)
80104716:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104719:	8b 40 04             	mov    0x4(%eax),%eax
8010471c:	85 c0                	test   %eax,%eax
8010471e:	75 2c                	jne    8010474c <fork+0x7a>
    kfree(np->kstack);
80104720:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104723:	8b 40 08             	mov    0x8(%eax),%eax
80104726:	89 04 24             	mov    %eax,(%esp)
80104729:	e8 2d e3 ff ff       	call   80102a5b <kfree>
    np->kstack = 0;
8010472e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104731:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104738:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104742:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104747:	e9 54 01 00 00       	jmp    801048a0 <fork+0x1ce>
  }
  np->sz = proc->sz;
8010474c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104752:	8b 10                	mov    (%eax),%edx
80104754:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104757:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104759:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104760:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104763:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104766:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104769:	8b 50 18             	mov    0x18(%eax),%edx
8010476c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104772:	8b 40 18             	mov    0x18(%eax),%eax
80104775:	89 c3                	mov    %eax,%ebx
80104777:	b8 13 00 00 00       	mov    $0x13,%eax
8010477c:	89 d7                	mov    %edx,%edi
8010477e:	89 de                	mov    %ebx,%esi
80104780:	89 c1                	mov    %eax,%ecx
80104782:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // CHANGE FOR SIGNAL --------------------------
  np->sig_handler = proc->sig_handler; // fork copies the parents sig handler
80104784:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478a:	8b 50 7c             	mov    0x7c(%eax),%edx
8010478d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104790:	89 50 7c             	mov    %edx,0x7c(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104793:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104796:	8b 40 18             	mov    0x18(%eax),%eax
80104799:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801047a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047a7:	eb 3d                	jmp    801047e6 <fork+0x114>
    if(proc->ofile[i])
801047a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b2:	83 c2 08             	add    $0x8,%edx
801047b5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047b9:	85 c0                	test   %eax,%eax
801047bb:	74 25                	je     801047e2 <fork+0x110>
      np->ofile[i] = filedup(proc->ofile[i]);
801047bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047c6:	83 c2 08             	add    $0x8,%edx
801047c9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047cd:	89 04 24             	mov    %eax,(%esp)
801047d0:	e8 c3 c7 ff ff       	call   80100f98 <filedup>
801047d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801047d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047db:	83 c1 08             	add    $0x8,%ecx
801047de:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  np->sig_handler = proc->sig_handler; // fork copies the parents sig handler

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047e2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047e6:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047ea:	7e bd                	jle    801047a9 <fork+0xd7>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f2:	8b 40 68             	mov    0x68(%eax),%eax
801047f5:	89 04 24             	mov    %eax,(%esp)
801047f8:	e8 3e d0 ff ff       	call   8010183b <idup>
801047fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104800:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104803:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104809:	8d 50 6c             	lea    0x6c(%eax),%edx
8010480c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010480f:	83 c0 6c             	add    $0x6c,%eax
80104812:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104819:	00 
8010481a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010481e:	89 04 24             	mov    %eax,(%esp)
80104821:	e8 f3 17 00 00       	call   80106019 <safestrcpy>
 
  pid = np->pid;
80104826:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104829:	8b 40 10             	mov    0x10(%eax),%eax
8010482c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
 // acquire(&ptable.lock);
  pushcli();
8010482f:	e8 c5 14 00 00       	call   80105cf9 <pushcli>
  check_cas2(&np->state, EMBRYO, RUNNABLE);
80104834:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104837:	83 c0 0c             	add    $0xc,%eax
8010483a:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
80104841:	00 
80104842:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104849:	00 
8010484a:	89 04 24             	mov    %eax,(%esp)
8010484d:	e8 ac fa ff ff       	call   801042fe <cas>
80104852:	85 c0                	test   %eax,%eax
80104854:	75 42                	jne    80104898 <fork+0x1c6>
80104856:	e8 68 0b 00 00       	call   801053c3 <procdump>
8010485b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104861:	8b 40 0c             	mov    0xc(%eax),%eax
80104864:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
8010486b:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80104870:	c7 44 24 0c da 00 00 	movl   $0xda,0xc(%esp)
80104877:	00 
80104878:	89 54 24 08          	mov    %edx,0x8(%esp)
8010487c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104880:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104887:	e8 14 bb ff ff       	call   801003a0 <cprintf>
8010488c:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80104893:	e8 a2 bc ff ff       	call   8010053a <panic>
  //np->state = RUNNABLE;
  popcli();
80104898:	e8 a0 14 00 00       	call   80105d3d <popcli>
 // release(&ptable.lock);
  
  return pid;
8010489d:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801048a0:	83 c4 2c             	add    $0x2c,%esp
801048a3:	5b                   	pop    %ebx
801048a4:	5e                   	pop    %esi
801048a5:	5f                   	pop    %edi
801048a6:	5d                   	pop    %ebp
801048a7:	c3                   	ret    

801048a8 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801048a8:	55                   	push   %ebp
801048a9:	89 e5                	mov    %esp,%ebp
801048ab:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801048ae:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048b5:	a1 c8 c6 10 80       	mov    0x8010c6c8,%eax
801048ba:	39 c2                	cmp    %eax,%edx
801048bc:	75 0c                	jne    801048ca <exit+0x22>
    panic("init exiting");
801048be:	c7 04 24 aa 95 10 80 	movl   $0x801095aa,(%esp)
801048c5:	e8 70 bc ff ff       	call   8010053a <panic>
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048d1:	eb 44                	jmp    80104917 <exit+0x6f>
    if(proc->ofile[fd]){
801048d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048dc:	83 c2 08             	add    $0x8,%edx
801048df:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048e3:	85 c0                	test   %eax,%eax
801048e5:	74 2c                	je     80104913 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801048e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048f0:	83 c2 08             	add    $0x8,%edx
801048f3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048f7:	89 04 24             	mov    %eax,(%esp)
801048fa:	e8 e1 c6 ff ff       	call   80100fe0 <fileclose>
      proc->ofile[fd] = 0;
801048ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104905:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104908:	83 c2 08             	add    $0x8,%edx
8010490b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104912:	00 
  int fd;

  if(proc == initproc)
    panic("init exiting");
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104913:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104917:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010491b:	7e b6                	jle    801048d3 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
8010491d:	e8 00 eb ff ff       	call   80103422 <begin_op>
  iput(proc->cwd);
80104922:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104928:	8b 40 68             	mov    0x68(%eax),%eax
8010492b:	89 04 24             	mov    %eax,(%esp)
8010492e:	e8 ed d0 ff ff       	call   80101a20 <iput>
  end_op();
80104933:	e8 6e eb ff ff       	call   801034a6 <end_op>
  proc->cwd = 0;
80104938:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493e:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  
  pushcli();
80104945:	e8 af 13 00 00       	call   80105cf9 <pushcli>
  //acquire(&ptable.lock);

  check_cas(RUNNING, NEG_ZOMBIE);
8010494a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104950:	83 c0 0c             	add    $0xc,%eax
80104953:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
8010495a:	00 
8010495b:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80104962:	00 
80104963:	89 04 24             	mov    %eax,(%esp)
80104966:	e8 93 f9 ff ff       	call   801042fe <cas>
8010496b:	85 c0                	test   %eax,%eax
8010496d:	75 42                	jne    801049b1 <exit+0x109>
8010496f:	e8 4f 0a 00 00       	call   801053c3 <procdump>
80104974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497a:	8b 40 0c             	mov    0xc(%eax),%eax
8010497d:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80104984:	a1 30 c0 10 80       	mov    0x8010c030,%eax
80104989:	c7 44 24 0c fd 00 00 	movl   $0xfd,0xc(%esp)
80104990:	00 
80104991:	89 54 24 08          	mov    %edx,0x8(%esp)
80104995:	89 44 24 04          	mov    %eax,0x4(%esp)
80104999:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
801049a0:	e8 fb b9 ff ff       	call   801003a0 <cprintf>
801049a5:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
801049ac:	e8 89 bb ff ff       	call   8010053a <panic>
  //proc->state = ZOMBIE;

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801049b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b7:	8b 40 14             	mov    0x14(%eax),%eax
801049ba:	89 04 24             	mov    %eax,(%esp)
801049bd:	e8 0b 08 00 00       	call   801051cd <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c2:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
801049c9:	eb 47                	jmp    80104a12 <exit+0x16a>
    if(p->parent == proc){
801049cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ce:	8b 50 14             	mov    0x14(%eax),%edx
801049d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d7:	39 c2                	cmp    %eax,%edx
801049d9:	75 30                	jne    80104a0b <exit+0x163>
      p->parent = initproc;
801049db:	8b 15 c8 c6 10 80    	mov    0x8010c6c8,%edx
801049e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e4:	89 50 14             	mov    %edx,0x14(%eax)
      while(p->state == NEG_ZOMBIE);
801049e7:	90                   	nop
801049e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049eb:	8b 40 0c             	mov    0xc(%eax),%eax
801049ee:	83 f8 06             	cmp    $0x6,%eax
801049f1:	74 f5                	je     801049e8 <exit+0x140>
      if(p->state == ZOMBIE /*|| p->state == NEG_ZOMBIE*/)
801049f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f6:	8b 40 0c             	mov    0xc(%eax),%eax
801049f9:	83 f8 05             	cmp    $0x5,%eax
801049fc:	75 0d                	jne    80104a0b <exit+0x163>
        wakeup1(initproc);
801049fe:	a1 c8 c6 10 80       	mov    0x8010c6c8,%eax
80104a03:	89 04 24             	mov    %eax,(%esp)
80104a06:	e8 c2 07 00 00       	call   801051cd <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a0b:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
80104a12:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80104a19:	72 b0                	jb     801049cb <exit+0x123>
    }
  }

  // Jump into the scheduler, never to return.
  
  sched_check;
80104a1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a21:	85 c0                	test   %eax,%eax
80104a23:	74 22                	je     80104a47 <exit+0x19f>
80104a25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2b:	8b 40 0c             	mov    0xc(%eax),%eax
80104a2e:	83 f8 04             	cmp    $0x4,%eax
80104a31:	75 14                	jne    80104a47 <exit+0x19f>
80104a33:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
80104a3a:	00 
80104a3b:	c7 04 24 b7 95 10 80 	movl   $0x801095b7,(%esp)
80104a42:	e8 59 b9 ff ff       	call   801003a0 <cprintf>
  sched();
80104a47:	e8 28 05 00 00       	call   80104f74 <sched>
  panic("zombie exit");
80104a4c:	c7 04 24 c4 95 10 80 	movl   $0x801095c4,(%esp)
80104a53:	e8 e2 ba ff ff       	call   8010053a <panic>

80104a58 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a58:	55                   	push   %ebp
80104a59:	89 e5                	mov    %esp,%ebp
80104a5b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  //acquire(&ptable.lock);
  pushcli();
80104a5e:	e8 96 12 00 00       	call   80105cf9 <pushcli>
  for(;;){
    proc->chan = (int)proc;
80104a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a69:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a70:	89 50 20             	mov    %edx,0x20(%eax)
    check_cas(RUNNING, NEG_SLEEPING);
80104a73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a79:	83 c0 0c             	add    $0xc,%eax
80104a7c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
80104a83:	00 
80104a84:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80104a8b:	00 
80104a8c:	89 04 24             	mov    %eax,(%esp)
80104a8f:	e8 6a f8 ff ff       	call   801042fe <cas>
80104a94:	85 c0                	test   %eax,%eax
80104a96:	75 42                	jne    80104ada <wait+0x82>
80104a98:	e8 26 09 00 00       	call   801053c3 <procdump>
80104a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa3:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa6:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80104aad:	a1 30 c0 10 80       	mov    0x8010c030,%eax
80104ab2:	c7 44 24 0c 1f 01 00 	movl   $0x11f,0xc(%esp)
80104ab9:	00 
80104aba:	89 54 24 08          	mov    %edx,0x8(%esp)
80104abe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac2:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104ac9:	e8 d2 b8 ff ff       	call   801003a0 <cprintf>
80104ace:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80104ad5:	e8 60 ba ff ff       	call   8010053a <panic>
    //proc->state = NEG_SLEEPING;    
    
    // Scan through table looking for zombie children.
    havekids = 0;
80104ada:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae1:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
80104ae8:	e9 52 01 00 00       	jmp    80104c3f <wait+0x1e7>
      if(p->parent != proc)
80104aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af0:	8b 50 14             	mov    0x14(%eax),%edx
80104af3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af9:	39 c2                	cmp    %eax,%edx
80104afb:	74 05                	je     80104b02 <wait+0xaa>
        continue;
80104afd:	e9 36 01 00 00       	jmp    80104c38 <wait+0x1e0>
      havekids = 1;
80104b02:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

      if(cas(&p->state, ZOMBIE, NEG_UNUSED)){
80104b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0c:	83 c0 0c             	add    $0xc,%eax
80104b0f:	c7 44 24 08 09 00 00 	movl   $0x9,0x8(%esp)
80104b16:	00 
80104b17:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
80104b1e:	00 
80104b1f:	89 04 24             	mov    %eax,(%esp)
80104b22:	e8 d7 f7 ff ff       	call   801042fe <cas>
80104b27:	85 c0                	test   %eax,%eax
80104b29:	0f 84 09 01 00 00    	je     80104c38 <wait+0x1e0>
        // Found one.
        pid = p->pid;
80104b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b32:	8b 40 10             	mov    0x10(%eax),%eax
80104b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
        p->pid = 0;
80104b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b45:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4f:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        proc->chan = 0;
80104b53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b59:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
        //proc->state = RUNNING;
        check_cas(NEG_SLEEPING, RUNNING);
80104b60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b66:	83 c0 0c             	add    $0xc,%eax
80104b69:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80104b70:	00 
80104b71:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
80104b78:	00 
80104b79:	89 04 24             	mov    %eax,(%esp)
80104b7c:	e8 7d f7 ff ff       	call   801042fe <cas>
80104b81:	85 c0                	test   %eax,%eax
80104b83:	75 42                	jne    80104bc7 <wait+0x16f>
80104b85:	e8 39 08 00 00       	call   801053c3 <procdump>
80104b8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b90:	8b 40 0c             	mov    0xc(%eax),%eax
80104b93:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80104b9a:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
80104b9f:	c7 44 24 0c 31 01 00 	movl   $0x131,0xc(%esp)
80104ba6:	00 
80104ba7:	89 54 24 08          	mov    %edx,0x8(%esp)
80104bab:	89 44 24 04          	mov    %eax,0x4(%esp)
80104baf:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104bb6:	e8 e5 b7 ff ff       	call   801003a0 <cprintf>
80104bbb:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80104bc2:	e8 73 b9 ff ff       	call   8010053a <panic>
        check_cas2(&p->state, NEG_UNUSED, UNUSED);
80104bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bca:	83 c0 0c             	add    $0xc,%eax
80104bcd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80104bd4:	00 
80104bd5:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
80104bdc:	00 
80104bdd:	89 04 24             	mov    %eax,(%esp)
80104be0:	e8 19 f7 ff ff       	call   801042fe <cas>
80104be5:	85 c0                	test   %eax,%eax
80104be7:	75 42                	jne    80104c2b <wait+0x1d3>
80104be9:	e8 d5 07 00 00       	call   801053c3 <procdump>
80104bee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf4:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf7:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80104bfe:	a1 44 c0 10 80       	mov    0x8010c044,%eax
80104c03:	c7 44 24 0c 32 01 00 	movl   $0x132,0xc(%esp)
80104c0a:	00 
80104c0b:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c13:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104c1a:	e8 81 b7 ff ff       	call   801003a0 <cprintf>
80104c1f:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80104c26:	e8 0f b9 ff ff       	call   8010053a <panic>
        //release(&ptable.lock);
        popcli();
80104c2b:	e8 0d 11 00 00       	call   80105d3d <popcli>
        return pid;
80104c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c33:	e9 ed 00 00 00       	jmp    80104d25 <wait+0x2cd>
    check_cas(RUNNING, NEG_SLEEPING);
    //proc->state = NEG_SLEEPING;    
    
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c38:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
80104c3f:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80104c46:	0f 82 a1 fe ff ff    	jb     80104aed <wait+0x95>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c50:	74 11                	je     80104c63 <wait+0x20b>
80104c52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c58:	8b 40 24             	mov    0x24(%eax),%eax
80104c5b:	85 c0                	test   %eax,%eax
80104c5d:	0f 84 8c 00 00 00    	je     80104cef <wait+0x297>
      cprintf("no kids \n");
80104c63:	c7 04 24 d0 95 10 80 	movl   $0x801095d0,(%esp)
80104c6a:	e8 31 b7 ff ff       	call   801003a0 <cprintf>
      proc->chan = 0;
80104c6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c75:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
      check_cas(NEG_SLEEPING, RUNNING);
80104c7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c82:	83 c0 0c             	add    $0xc,%eax
80104c85:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80104c8c:	00 
80104c8d:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
80104c94:	00 
80104c95:	89 04 24             	mov    %eax,(%esp)
80104c98:	e8 61 f6 ff ff       	call   801042fe <cas>
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	75 42                	jne    80104ce3 <wait+0x28b>
80104ca1:	e8 1d 07 00 00       	call   801053c3 <procdump>
80104ca6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cac:	8b 40 0c             	mov    0xc(%eax),%eax
80104caf:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80104cb6:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
80104cbb:	c7 44 24 0c 3d 01 00 	movl   $0x13d,0xc(%esp)
80104cc2:	00 
80104cc3:	89 54 24 08          	mov    %edx,0x8(%esp)
80104cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ccb:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104cd2:	e8 c9 b6 ff ff       	call   801003a0 <cprintf>
80104cd7:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80104cde:	e8 57 b8 ff ff       	call   8010053a <panic>
      //proc->state = RUNNING;      
      //release(&ptable.lock);
      popcli();
80104ce3:	e8 55 10 00 00       	call   80105d3d <popcli>
      return -1;
80104ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ced:	eb 36                	jmp    80104d25 <wait+0x2cd>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sched_check;
80104cef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	74 22                	je     80104d1b <wait+0x2c3>
80104cf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cff:	8b 40 0c             	mov    0xc(%eax),%eax
80104d02:	83 f8 04             	cmp    $0x4,%eax
80104d05:	75 14                	jne    80104d1b <wait+0x2c3>
80104d07:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
80104d0e:	00 
80104d0f:	c7 04 24 b7 95 10 80 	movl   $0x801095b7,(%esp)
80104d16:	e8 85 b6 ff ff       	call   801003a0 <cprintf>
    sched();
80104d1b:	e8 54 02 00 00       	call   80104f74 <sched>
  }
80104d20:	e9 3e fd ff ff       	jmp    80104a63 <wait+0xb>
}
80104d25:	c9                   	leave  
80104d26:	c3                   	ret    

80104d27 <freeproc>:

void 
freeproc(struct proc *p)
{
80104d27:	55                   	push   %ebp
80104d28:	89 e5                	mov    %esp,%ebp
80104d2a:	83 ec 18             	sub    $0x18,%esp
  if (!p ||
80104d2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104d31:	74 2b                	je     80104d5e <freeproc+0x37>
      (p->state != ZOMBIE && p->state != UNUSED &&
80104d33:	8b 45 08             	mov    0x8(%ebp),%eax
80104d36:	8b 40 0c             	mov    0xc(%eax),%eax
}

void 
freeproc(struct proc *p)
{
  if (!p ||
80104d39:	83 f8 05             	cmp    $0x5,%eax
80104d3c:	74 2c                	je     80104d6a <freeproc+0x43>
      (p->state != ZOMBIE && p->state != UNUSED &&
80104d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d41:	8b 40 0c             	mov    0xc(%eax),%eax
80104d44:	85 c0                	test   %eax,%eax
80104d46:	74 22                	je     80104d6a <freeproc+0x43>
       p->state != NEG_ZOMBIE && p->state != NEG_UNUSED))
80104d48:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4b:	8b 40 0c             	mov    0xc(%eax),%eax

void 
freeproc(struct proc *p)
{
  if (!p ||
      (p->state != ZOMBIE && p->state != UNUSED &&
80104d4e:	83 f8 06             	cmp    $0x6,%eax
80104d51:	74 17                	je     80104d6a <freeproc+0x43>
       p->state != NEG_ZOMBIE && p->state != NEG_UNUSED))
80104d53:	8b 45 08             	mov    0x8(%ebp),%eax
80104d56:	8b 40 0c             	mov    0xc(%eax),%eax
80104d59:	83 f8 09             	cmp    $0x9,%eax
80104d5c:	74 0c                	je     80104d6a <freeproc+0x43>
    panic("freeproc not zombie");
80104d5e:	c7 04 24 da 95 10 80 	movl   $0x801095da,(%esp)
80104d65:	e8 d0 b7 ff ff       	call   8010053a <panic>
  kfree(p->kstack);
80104d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6d:	8b 40 08             	mov    0x8(%eax),%eax
80104d70:	89 04 24             	mov    %eax,(%esp)
80104d73:	e8 e3 dc ff ff       	call   80102a5b <kfree>
  p->kstack = 0;
80104d78:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  freevm(p->pgdir);
80104d82:	8b 45 08             	mov    0x8(%ebp),%eax
80104d85:	8b 40 04             	mov    0x4(%eax),%eax
80104d88:	89 04 24             	mov    %eax,(%esp)
80104d8b:	e8 8b 41 00 00       	call   80108f1b <freevm>
  p->killed = 0;
80104d90:	8b 45 08             	mov    0x8(%ebp),%eax
80104d93:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
  p->chan = 0;
80104d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d9d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
}
80104da4:	c9                   	leave  
80104da5:	c3                   	ret    

80104da6 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104da6:	55                   	push   %ebp
80104da7:	89 e5                	mov    %esp,%ebp
80104da9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104dac:	e8 47 f5 ff ff       	call   801042f8 <sti>

    // Loop over process table looking for process to run.
    //acquire(&ptable.lock);
    pushcli();
80104db1:	e8 43 0f 00 00       	call   80105cf9 <pushcli>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104db6:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
80104dbd:	e9 9b 01 00 00       	jmp    80104f5d <scheduler+0x1b7>
      if(!cas(&p->state, RUNNABLE, NEG_RUNNABLE))
80104dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc5:	83 c0 0c             	add    $0xc,%eax
80104dc8:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80104dcf:	00 
80104dd0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80104dd7:	00 
80104dd8:	89 04 24             	mov    %eax,(%esp)
80104ddb:	e8 1e f5 ff ff       	call   801042fe <cas>
80104de0:	85 c0                	test   %eax,%eax
80104de2:	75 05                	jne    80104de9 <scheduler+0x43>
        continue;
80104de4:	e9 6d 01 00 00       	jmp    80104f56 <scheduler+0x1b0>

      // Should we handler signals here?
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dec:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df5:	89 04 24             	mov    %eax,(%esp)
80104df8:	e8 ab 3c 00 00       	call   80108aa8 <switchuvm>
      check_cas2(&p->state, NEG_RUNNABLE, RUNNING);
80104dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e00:	83 c0 0c             	add    $0xc,%eax
80104e03:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80104e0a:	00 
80104e0b:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
80104e12:	00 
80104e13:	89 04 24             	mov    %eax,(%esp)
80104e16:	e8 e3 f4 ff ff       	call   801042fe <cas>
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	75 42                	jne    80104e61 <scheduler+0xbb>
80104e1f:	e8 9f 05 00 00       	call   801053c3 <procdump>
80104e24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e2d:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80104e34:	a1 40 c0 10 80       	mov    0x8010c040,%eax
80104e39:	c7 44 24 0c 76 01 00 	movl   $0x176,0xc(%esp)
80104e40:	00 
80104e41:	89 54 24 08          	mov    %edx,0x8(%esp)
80104e45:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e49:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80104e50:	e8 4b b5 ff ff       	call   801003a0 <cprintf>
80104e55:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80104e5c:	e8 d9 b6 ff ff       	call   8010053a <panic>
      swtch(&cpu->scheduler, proc->context);
80104e61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e67:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e6a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104e71:	83 c2 04             	add    $0x4,%edx
80104e74:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e78:	89 14 24             	mov    %edx,(%esp)
80104e7b:	e8 0a 12 00 00       	call   8010608a <swtch>
      switchkvm();
80104e80:	e8 06 3c 00 00       	call   80108a8b <switchkvm>
      cas(&p->state, NEG_SLEEPING, SLEEPING);
80104e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e88:	83 c0 0c             	add    $0xc,%eax
80104e8b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
80104e92:	00 
80104e93:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
80104e9a:	00 
80104e9b:	89 04 24             	mov    %eax,(%esp)
80104e9e:	e8 5b f4 ff ff       	call   801042fe <cas>
      cas(&p->state, NEG_RUNNABLE, RUNNABLE);
80104ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea6:	83 c0 0c             	add    $0xc,%eax
80104ea9:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
80104eb0:	00 
80104eb1:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
80104eb8:	00 
80104eb9:	89 04 24             	mov    %eax,(%esp)
80104ebc:	e8 3d f4 ff ff       	call   801042fe <cas>
      cas(&p->state, NEG_UNUSED, UNUSED);
80104ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec4:	83 c0 0c             	add    $0xc,%eax
80104ec7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80104ece:	00 
80104ecf:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
80104ed6:	00 
80104ed7:	89 04 24             	mov    %eax,(%esp)
80104eda:	e8 1f f4 ff ff       	call   801042fe <cas>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104edf:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104ee6:	00 00 00 00 
      if(p->state == NEG_ZOMBIE) {
80104eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eed:	8b 40 0c             	mov    0xc(%eax),%eax
80104ef0:	83 f8 06             	cmp    $0x6,%eax
80104ef3:	75 41                	jne    80104f36 <scheduler+0x190>
          freeproc(p);
80104ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef8:	89 04 24             	mov    %eax,(%esp)
80104efb:	e8 27 fe ff ff       	call   80104d27 <freeproc>
          cas(&p->state, NEG_ZOMBIE, ZOMBIE);
80104f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f03:	83 c0 0c             	add    $0xc,%eax
80104f06:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
80104f0d:	00 
80104f0e:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80104f15:	00 
80104f16:	89 04 24             	mov    %eax,(%esp)
80104f19:	e8 e0 f3 ff ff       	call   801042fe <cas>
          if(p->parent)
80104f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f21:	8b 40 14             	mov    0x14(%eax),%eax
80104f24:	85 c0                	test   %eax,%eax
80104f26:	74 0e                	je     80104f36 <scheduler+0x190>
            wakeup1(p->parent);
80104f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2b:	8b 40 14             	mov    0x14(%eax),%eax
80104f2e:	89 04 24             	mov    %eax,(%esp)
80104f31:	e8 97 02 00 00       	call   801051cd <wakeup1>
      }

      if(p->state == NEG_UNUSED || p->state==UNUSED)
80104f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f39:	8b 40 0c             	mov    0xc(%eax),%eax
80104f3c:	83 f8 09             	cmp    $0x9,%eax
80104f3f:	74 0a                	je     80104f4b <scheduler+0x1a5>
80104f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f44:	8b 40 0c             	mov    0xc(%eax),%eax
80104f47:	85 c0                	test   %eax,%eax
80104f49:	75 0b                	jne    80104f56 <scheduler+0x1b0>
        freeproc(p);
80104f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f4e:	89 04 24             	mov    %eax,(%esp)
80104f51:	e8 d1 fd ff ff       	call   80104d27 <freeproc>
    sti();

    // Loop over process table looking for process to run.
    //acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f56:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
80104f5d:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80104f64:	0f 82 58 fe ff ff    	jb     80104dc2 <scheduler+0x1c>

      if(p->state == NEG_UNUSED || p->state==UNUSED)
        freeproc(p);
    }
    //release(&ptable.lock);
    popcli();
80104f6a:	e8 ce 0d 00 00       	call   80105d3d <popcli>

  }
80104f6f:	e9 38 fe ff ff       	jmp    80104dac <scheduler+0x6>

80104f74 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	83 ec 28             	sub    $0x28,%esp
  int intena;

//  if(!holding(&ptable.lock))
//    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80104f7a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f80:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f86:	83 f8 01             	cmp    $0x1,%eax
80104f89:	74 0c                	je     80104f97 <sched+0x23>
    panic("sched locks");
80104f8b:	c7 04 24 ee 95 10 80 	movl   $0x801095ee,(%esp)
80104f92:	e8 a3 b5 ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104f97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f9d:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa0:	83 f8 04             	cmp    $0x4,%eax
80104fa3:	75 0c                	jne    80104fb1 <sched+0x3d>
    panic("sched running");
80104fa5:	c7 04 24 fa 95 10 80 	movl   $0x801095fa,(%esp)
80104fac:	e8 89 b5 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104fb1:	e8 32 f3 ff ff       	call   801042e8 <readeflags>
80104fb6:	25 00 02 00 00       	and    $0x200,%eax
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	74 0c                	je     80104fcb <sched+0x57>
    panic("sched interruptible");
80104fbf:	c7 04 24 08 96 10 80 	movl   $0x80109608,(%esp)
80104fc6:	e8 6f b5 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104fcb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fd1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104fda:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fe0:	8b 40 04             	mov    0x4(%eax),%eax
80104fe3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104fea:	83 c2 1c             	add    $0x1c,%edx
80104fed:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ff1:	89 14 24             	mov    %edx,(%esp)
80104ff4:	e8 91 10 00 00       	call   8010608a <swtch>
  cpu->intena = intena;
80104ff9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105002:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105008:	c9                   	leave  
80105009:	c3                   	ret    

8010500a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010500a:	55                   	push   %ebp
8010500b:	89 e5                	mov    %esp,%ebp
8010500d:	83 ec 18             	sub    $0x18,%esp
  pushcli();
80105010:	e8 e4 0c 00 00       	call   80105cf9 <pushcli>
  //acquire(&ptable.lock);  //DOC: yieldlock
  //proc->state = RUNNABLE;
  check_cas(RUNNING, NEG_RUNNABLE);
80105015:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010501b:	83 c0 0c             	add    $0xc,%eax
8010501e:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105025:	00 
80105026:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
8010502d:	00 
8010502e:	89 04 24             	mov    %eax,(%esp)
80105031:	e8 c8 f2 ff ff       	call   801042fe <cas>
80105036:	85 c0                	test   %eax,%eax
80105038:	75 42                	jne    8010507c <yield+0x72>
8010503a:	e8 84 03 00 00       	call   801053c3 <procdump>
8010503f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105045:	8b 40 0c             	mov    0xc(%eax),%eax
80105048:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
8010504f:	a1 30 c0 10 80       	mov    0x8010c030,%eax
80105054:	c7 44 24 0c ab 01 00 	movl   $0x1ab,0xc(%esp)
8010505b:	00 
8010505c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105060:	89 44 24 04          	mov    %eax,0x4(%esp)
80105064:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
8010506b:	e8 30 b3 ff ff       	call   801003a0 <cprintf>
80105070:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80105077:	e8 be b4 ff ff       	call   8010053a <panic>

  sched_check;
8010507c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105082:	85 c0                	test   %eax,%eax
80105084:	74 22                	je     801050a8 <yield+0x9e>
80105086:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010508c:	8b 40 0c             	mov    0xc(%eax),%eax
8010508f:	83 f8 04             	cmp    $0x4,%eax
80105092:	75 14                	jne    801050a8 <yield+0x9e>
80105094:	c7 44 24 04 ad 01 00 	movl   $0x1ad,0x4(%esp)
8010509b:	00 
8010509c:	c7 04 24 b7 95 10 80 	movl   $0x801095b7,(%esp)
801050a3:	e8 f8 b2 ff ff       	call   801003a0 <cprintf>
  sched();
801050a8:	e8 c7 fe ff ff       	call   80104f74 <sched>
  popcli();
801050ad:	e8 8b 0c 00 00       	call   80105d3d <popcli>
  //release(&ptable.lock);
}
801050b2:	c9                   	leave  
801050b3:	c3                   	ret    

801050b4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  //release(&ptable.lock);
  popcli();
801050ba:	e8 7e 0c 00 00       	call   80105d3d <popcli>

  if (first) {
801050bf:	a1 4c c0 10 80       	mov    0x8010c04c,%eax
801050c4:	85 c0                	test   %eax,%eax
801050c6:	74 0f                	je     801050d7 <forkret+0x23>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801050c8:	c7 05 4c c0 10 80 00 	movl   $0x0,0x8010c04c
801050cf:	00 00 00 
    initlog();
801050d2:	e8 3d e1 ff ff       	call   80103214 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801050d7:	c9                   	leave  
801050d8:	c3                   	ret    

801050d9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801050d9:	55                   	push   %ebp
801050da:	89 e5                	mov    %esp,%ebp
801050dc:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801050df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050e5:	85 c0                	test   %eax,%eax
801050e7:	75 0c                	jne    801050f5 <sleep+0x1c>
    panic("sleep");
801050e9:	c7 04 24 1c 96 10 80 	movl   $0x8010961c,(%esp)
801050f0:	e8 45 b4 ff ff       	call   8010053a <panic>

  if(lk == 0)
801050f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050f9:	75 0c                	jne    80105107 <sleep+0x2e>
    panic("sleep without lk");
801050fb:	c7 04 24 22 96 10 80 	movl   $0x80109622,(%esp)
80105102:	e8 33 b4 ff ff       	call   8010053a <panic>

  // Go to sleep.
  if(!!!!!!!!!!0 && proc->name[2] == 'e' && proc->pid > 4  && proc->pid < 55) 
    cprintf("process w/ pid: %d going to sleep on %p \n", proc->pid,
        (uint) chan);
  pushcli();
80105107:	e8 ed 0b 00 00       	call   80105cf9 <pushcli>
  proc->chan = (int)chan;
8010510c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105112:	8b 55 08             	mov    0x8(%ebp),%edx
80105115:	89 50 20             	mov    %edx,0x20(%eax)
  check_cas(RUNNING, NEG_SLEEPING);
80105118:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010511e:	83 c0 0c             	add    $0xc,%eax
80105121:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
80105128:	00 
80105129:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80105130:	00 
80105131:	89 04 24             	mov    %eax,(%esp)
80105134:	e8 c5 f1 ff ff       	call   801042fe <cas>
80105139:	85 c0                	test   %eax,%eax
8010513b:	75 42                	jne    8010517f <sleep+0xa6>
8010513d:	e8 81 02 00 00       	call   801053c3 <procdump>
80105142:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105148:	8b 40 0c             	mov    0xc(%eax),%eax
8010514b:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80105152:	a1 30 c0 10 80       	mov    0x8010c030,%eax
80105157:	c7 44 24 0c d9 01 00 	movl   $0x1d9,0xc(%esp)
8010515e:	00 
8010515f:	89 54 24 08          	mov    %edx,0x8(%esp)
80105163:	89 44 24 04          	mov    %eax,0x4(%esp)
80105167:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
8010516e:	e8 2d b2 ff ff       	call   801003a0 <cprintf>
80105173:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
8010517a:	e8 bb b3 ff ff       	call   8010053a <panic>
//  if(lk != &ptable.lock){  //DOC: sleeplock0
//    acquire(&ptable.lock);  //DOC: sleeplock1
//    release(lk);
//  }

  release(lk);
8010517f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105182:	89 04 24             	mov    %eax,(%esp)
80105185:	e8 7d 0a 00 00       	call   80105c07 <release>

  sched_check;
8010518a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105190:	85 c0                	test   %eax,%eax
80105192:	74 22                	je     801051b6 <sleep+0xdd>
80105194:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010519a:	8b 40 0c             	mov    0xc(%eax),%eax
8010519d:	83 f8 04             	cmp    $0x4,%eax
801051a0:	75 14                	jne    801051b6 <sleep+0xdd>
801051a2:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
801051a9:	00 
801051aa:	c7 04 24 b7 95 10 80 	movl   $0x801095b7,(%esp)
801051b1:	e8 ea b1 ff ff       	call   801003a0 <cprintf>
  sched();
801051b6:	e8 b9 fd ff ff       	call   80104f74 <sched>
  
  popcli();
801051bb:	e8 7d 0b 00 00       	call   80105d3d <popcli>
  acquire(lk);
801051c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c3:	89 04 24             	mov    %eax,(%esp)
801051c6:	e8 da 09 00 00       	call   80105ba5 <acquire>
  // Reacquire original lock.
//  if(lk != &ptable.lock){  //DOC: sleeplock2
//    release(&ptable.lock);
//    acquire(lk);
//  }
}
801051cb:	c9                   	leave  
801051cc:	c3                   	ret    

801051cd <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801051cd:	55                   	push   %ebp
801051ce:	89 e5                	mov    %esp,%ebp
801051d0:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801051d3:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
801051da:	e9 2e 01 00 00       	jmp    8010530d <wakeup1+0x140>
    if(p->state != SLEEPING && p->chan == (int)chan) {
801051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e2:	8b 40 0c             	mov    0xc(%eax),%eax
801051e5:	83 f8 02             	cmp    $0x2,%eax
801051e8:	74 19                	je     80105203 <wakeup1+0x36>
801051ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ed:	8b 50 20             	mov    0x20(%eax),%edx
801051f0:	8b 45 08             	mov    0x8(%ebp),%eax
801051f3:	39 c2                	cmp    %eax,%edx
801051f5:	75 0c                	jne    80105203 <wakeup1+0x36>
      while(p->state != SLEEPING);
801051f7:	90                   	nop
801051f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051fb:	8b 40 0c             	mov    0xc(%eax),%eax
801051fe:	83 f8 02             	cmp    $0x2,%eax
80105201:	75 f5                	jne    801051f8 <wakeup1+0x2b>
    }
    if(p->chan == (int)chan && cas(&p->state, SLEEPING, NEG_RUNNABLE)){
80105203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105206:	8b 50 20             	mov    0x20(%eax),%edx
80105209:	8b 45 08             	mov    0x8(%ebp),%eax
8010520c:	39 c2                	cmp    %eax,%edx
8010520e:	0f 85 f2 00 00 00    	jne    80105306 <wakeup1+0x139>
80105214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105217:	83 c0 0c             	add    $0xc,%eax
8010521a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105221:	00 
80105222:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105229:	00 
8010522a:	89 04 24             	mov    %eax,(%esp)
8010522d:	e8 cc f0 ff ff       	call   801042fe <cas>
80105232:	85 c0                	test   %eax,%eax
80105234:	0f 84 cc 00 00 00    	je     80105306 <wakeup1+0x139>
      //check_cas2(&p->state, SLEEPING, RUNNABLE);
      //p->state = RUNNABLE;
        // Tidy up.
      check_cas2(&p->chan, (int) chan, 0);
8010523a:	8b 45 08             	mov    0x8(%ebp),%eax
8010523d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105240:	83 c2 20             	add    $0x20,%edx
80105243:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010524a:	00 
8010524b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524f:	89 14 24             	mov    %edx,(%esp)
80105252:	e8 a7 f0 ff ff       	call   801042fe <cas>
80105257:	85 c0                	test   %eax,%eax
80105259:	75 47                	jne    801052a2 <wakeup1+0xd5>
8010525b:	e8 63 01 00 00       	call   801053c3 <procdump>
80105260:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105266:	8b 40 0c             	mov    0xc(%eax),%eax
80105269:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80105270:	8b 45 08             	mov    0x8(%ebp),%eax
80105273:	8b 04 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%eax
8010527a:	c7 44 24 0c 04 02 00 	movl   $0x204,0xc(%esp)
80105281:	00 
80105282:	89 54 24 08          	mov    %edx,0x8(%esp)
80105286:	89 44 24 04          	mov    %eax,0x4(%esp)
8010528a:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80105291:	e8 0a b1 ff ff       	call   801003a0 <cprintf>
80105296:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
8010529d:	e8 98 b2 ff ff       	call   8010053a <panic>
      check_cas2(&p->state, NEG_RUNNABLE, RUNNABLE);
801052a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a5:	83 c0 0c             	add    $0xc,%eax
801052a8:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
801052af:	00 
801052b0:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
801052b7:	00 
801052b8:	89 04 24             	mov    %eax,(%esp)
801052bb:	e8 3e f0 ff ff       	call   801042fe <cas>
801052c0:	85 c0                	test   %eax,%eax
801052c2:	75 42                	jne    80105306 <wakeup1+0x139>
801052c4:	e8 fa 00 00 00       	call   801053c3 <procdump>
801052c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052cf:	8b 40 0c             	mov    0xc(%eax),%eax
801052d2:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
801052d9:	a1 40 c0 10 80       	mov    0x8010c040,%eax
801052de:	c7 44 24 0c 05 02 00 	movl   $0x205,0xc(%esp)
801052e5:	00 
801052e6:	89 54 24 08          	mov    %edx,0x8(%esp)
801052ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ee:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
801052f5:	e8 a6 b0 ff ff       	call   801003a0 <cprintf>
801052fa:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80105301:	e8 34 b2 ff ff       	call   8010053a <panic>
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105306:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
8010530d:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80105314:	0f 82 c5 fe ff ff    	jb     801051df <wakeup1+0x12>
        // Tidy up.
      check_cas2(&p->chan, (int) chan, 0);
      check_cas2(&p->state, NEG_RUNNABLE, RUNNABLE);
    }
  }
}
8010531a:	c9                   	leave  
8010531b:	c3                   	ret    

8010531c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010531c:	55                   	push   %ebp
8010531d:	89 e5                	mov    %esp,%ebp
8010531f:	83 ec 18             	sub    $0x18,%esp
  //acquire(&ptable.lock);
  pushcli();
80105322:	e8 d2 09 00 00       	call   80105cf9 <pushcli>
  wakeup1(chan);
80105327:	8b 45 08             	mov    0x8(%ebp),%eax
8010532a:	89 04 24             	mov    %eax,(%esp)
8010532d:	e8 9b fe ff ff       	call   801051cd <wakeup1>
  popcli();
80105332:	e8 06 0a 00 00       	call   80105d3d <popcli>
  //release(&ptable.lock);
}
80105337:	c9                   	leave  
80105338:	c3                   	ret    

80105339 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105339:	55                   	push   %ebp
8010533a:	89 e5                	mov    %esp,%ebp
8010533c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  //acquire(&ptable.lock);
  pushcli();
8010533f:	e8 b5 09 00 00       	call   80105cf9 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105344:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
8010534b:	eb 61                	jmp    801053ae <kill+0x75>
    if(p->pid == pid){
8010534d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105350:	8b 40 10             	mov    0x10(%eax),%eax
80105353:	3b 45 08             	cmp    0x8(%ebp),%eax
80105356:	75 4f                	jne    801053a7 <kill+0x6e>
      cas(&p->killed, 0, 1);
80105358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535b:	83 c0 24             	add    $0x24,%eax
8010535e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80105365:	00 
80105366:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010536d:	00 
8010536e:	89 04 24             	mov    %eax,(%esp)
80105371:	e8 88 ef ff ff       	call   801042fe <cas>
      // Wake process from sleep if necessary.
      while(p->state == NEG_SLEEPING);
80105376:	90                   	nop
80105377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537a:	8b 40 0c             	mov    0xc(%eax),%eax
8010537d:	83 f8 07             	cmp    $0x7,%eax
80105380:	74 f5                	je     80105377 <kill+0x3e>
      if(p->state == SLEEPING)
80105382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105385:	8b 40 0c             	mov    0xc(%eax),%eax
80105388:	83 f8 02             	cmp    $0x2,%eax
8010538b:	75 0e                	jne    8010539b <kill+0x62>
        wakeup1((void *)p->chan);
8010538d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105390:	8b 40 20             	mov    0x20(%eax),%eax
80105393:	89 04 24             	mov    %eax,(%esp)
80105396:	e8 32 fe ff ff       	call   801051cd <wakeup1>
      //release(&ptable.lock);
      popcli();
8010539b:	e8 9d 09 00 00       	call   80105d3d <popcli>
      return 0;
801053a0:	b8 00 00 00 00       	mov    $0x0,%eax
801053a5:	eb 1a                	jmp    801053c1 <kill+0x88>
kill(int pid)
{
  struct proc *p;
  //acquire(&ptable.lock);
  pushcli();
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053a7:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
801053ae:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
801053b5:	72 96                	jb     8010534d <kill+0x14>
      popcli();
      return 0;
    }
  }
  //release(&ptable.lock);
  popcli();
801053b7:	e8 81 09 00 00       	call   80105d3d <popcli>
  return -1;
801053bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c1:	c9                   	leave  
801053c2:	c3                   	ret    

801053c3 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801053c3:	55                   	push   %ebp
801053c4:	89 e5                	mov    %esp,%ebp
801053c6:	83 ec 48             	sub    $0x48,%esp
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053c9:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
801053d0:	eb 79                	jmp    8010544b <procdump+0x88>
    if(p->state == UNUSED)
801053d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d5:	8b 40 0c             	mov    0xc(%eax),%eax
801053d8:	85 c0                	test   %eax,%eax
801053da:	75 02                	jne    801053de <procdump+0x1b>
      continue;
801053dc:	eb 66                	jmp    80105444 <procdump+0x81>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801053de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e1:	8b 40 0c             	mov    0xc(%eax),%eax
801053e4:	85 c0                	test   %eax,%eax
801053e6:	78 2e                	js     80105416 <procdump+0x53>
801053e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053eb:	8b 40 0c             	mov    0xc(%eax),%eax
801053ee:	83 f8 09             	cmp    $0x9,%eax
801053f1:	77 23                	ja     80105416 <procdump+0x53>
801053f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f6:	8b 40 0c             	mov    0xc(%eax),%eax
801053f9:	8b 04 85 60 c0 10 80 	mov    -0x7fef3fa0(,%eax,4),%eax
80105400:	85 c0                	test   %eax,%eax
80105402:	74 12                	je     80105416 <procdump+0x53>
      state = states[p->state];
80105404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105407:	8b 40 0c             	mov    0xc(%eax),%eax
8010540a:	8b 04 85 60 c0 10 80 	mov    -0x7fef3fa0(,%eax,4),%eax
80105411:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105414:	eb 07                	jmp    8010541d <procdump+0x5a>
    else
      state = "???";
80105416:	c7 45 f0 33 96 10 80 	movl   $0x80109633,-0x10(%ebp)
    cprintf("[%d %s %s] \n  ", p->pid, state, p->name);
8010541d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105420:	8d 50 6c             	lea    0x6c(%eax),%edx
80105423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105426:	8b 40 10             	mov    0x10(%eax),%eax
80105429:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010542d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105430:	89 54 24 08          	mov    %edx,0x8(%esp)
80105434:	89 44 24 04          	mov    %eax,0x4(%esp)
80105438:	c7 04 24 37 96 10 80 	movl   $0x80109637,(%esp)
8010543f:	e8 5c af ff ff       	call   801003a0 <cprintf>
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105444:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)
8010544b:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80105452:	0f 82 7a ff ff ff    	jb     801053d2 <procdump+0xf>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
  }
}
80105458:	c9                   	leave  
80105459:	c3                   	ret    

8010545a <push>:

// Returns a vacant cstackframe from a given cstack - returns 0 if none are
// vacant;
struct cstackframe* get_stack_frame(struct cstack*);

int push(struct cstack *cstack, int sender_pid, int recepient_pid, int value) {
8010545a:	55                   	push   %ebp
8010545b:	89 e5                	mov    %esp,%ebp
8010545d:	83 ec 28             	sub    $0x28,%esp
  struct cstackframe* new_frame;

  // get an empty frame from the cstack -- if none are free return 0;
  new_frame = get_stack_frame(cstack);
80105460:	8b 45 08             	mov    0x8(%ebp),%eax
80105463:	89 04 24             	mov    %eax,(%esp)
80105466:	e8 b8 00 00 00       	call   80105523 <get_stack_frame>
8010546b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(new_frame == EMPTY_STACK)
8010546e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105472:	75 07                	jne    8010547b <push+0x21>
    return 0;
80105474:	b8 00 00 00 00       	mov    $0x0,%eax
80105479:	eb 54                	jmp    801054cf <push+0x75>
  
  // Fill in the new frame.
  new_frame->sender_pid = sender_pid;
8010547b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010547e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105481:	89 10                	mov    %edx,(%eax)
  new_frame->recepient_pid = recepient_pid;
80105483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105486:	8b 55 10             	mov    0x10(%ebp),%edx
80105489:	89 50 04             	mov    %edx,0x4(%eax)
  new_frame->value = value;
8010548c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010548f:	8b 55 14             	mov    0x14(%ebp),%edx
80105492:	89 50 08             	mov    %edx,0x8(%eax)
  
  // A CAS loop for adding the new frame to the head of the stack.
  // We make sure our new_frames next is the old head and that the head does 
  // change. 
  do {
    new_frame->next = cstack->head;
80105495:	8b 45 08             	mov    0x8(%ebp),%eax
80105498:	8b 90 c8 00 00 00    	mov    0xc8(%eax),%edx
8010549e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a1:	89 50 10             	mov    %edx,0x10(%eax)
  } while(!cas((int *)&cstack->head, (int) new_frame->next, (int) new_frame));
801054a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054aa:	8b 40 10             	mov    0x10(%eax),%eax
801054ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054b0:	81 c1 c8 00 00 00    	add    $0xc8,%ecx
801054b6:	89 54 24 08          	mov    %edx,0x8(%esp)
801054ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801054be:	89 0c 24             	mov    %ecx,(%esp)
801054c1:	e8 38 ee ff ff       	call   801042fe <cas>
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 cb                	je     80105495 <push+0x3b>
  return 1; // SUCCESS
801054ca:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054cf:	c9                   	leave  
801054d0:	c3                   	ret    

801054d1 <pop>:

struct cstackframe *pop(struct cstack *cstack) {
801054d1:	55                   	push   %ebp
801054d2:	89 e5                	mov    %esp,%ebp
801054d4:	83 ec 1c             	sub    $0x1c,%esp
  struct cstackframe* old;
  do {
    old = cstack->head;
801054d7:	8b 45 08             	mov    0x8(%ebp),%eax
801054da:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
801054e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(old == EMPTY_STACK){ // Empty stack.
801054e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801054e7:	75 07                	jne    801054f0 <pop+0x1f>
      return EMPTY_STACK;
801054e9:	b8 00 00 00 00       	mov    $0x0,%eax
801054ee:	eb 31                	jmp    80105521 <pop+0x50>
    }
  } while(!cas((int *) &cstack->head, (int) old, (int) (cstack->head->next)));
801054f0:	8b 45 08             	mov    0x8(%ebp),%eax
801054f3:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
801054f9:	8b 40 10             	mov    0x10(%eax),%eax
801054fc:	89 c2                	mov    %eax,%edx
801054fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105501:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105504:	81 c1 c8 00 00 00    	add    $0xc8,%ecx
8010550a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010550e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105512:	89 0c 24             	mov    %ecx,(%esp)
80105515:	e8 e4 ed ff ff       	call   801042fe <cas>
8010551a:	85 c0                	test   %eax,%eax
8010551c:	74 b9                	je     801054d7 <pop+0x6>
  return old; 
8010551e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105521:	c9                   	leave  
80105522:	c3                   	ret    

80105523 <get_stack_frame>:



struct cstackframe* get_stack_frame(struct cstack* cstack) {
80105523:	55                   	push   %ebp
80105524:	89 e5                	mov    %esp,%ebp
80105526:	83 ec 1c             	sub    $0x1c,%esp
  struct cstackframe* iter = cstack->frames;
80105529:	8b 45 08             	mov    0x8(%ebp),%eax
8010552c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  do{
    while(iter < cstack->frames + CSTACK_SIZE)
8010552f:	eb 0e                	jmp    8010553f <get_stack_frame+0x1c>
80105531:	eb 0c                	jmp    8010553f <get_stack_frame+0x1c>
      if(CSTACKFRAME_UNUSED == iter->used) { // found one!
80105533:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105536:	8b 40 0c             	mov    0xc(%eax),%eax
80105539:	85 c0                	test   %eax,%eax
8010553b:	75 02                	jne    8010553f <get_stack_frame+0x1c>
        break;
8010553d:	eb 0d                	jmp    8010554c <get_stack_frame+0x29>


struct cstackframe* get_stack_frame(struct cstack* cstack) {
  struct cstackframe* iter = cstack->frames;
  do{
    while(iter < cstack->frames + CSTACK_SIZE)
8010553f:	8b 45 08             	mov    0x8(%ebp),%eax
80105542:	05 c8 00 00 00       	add    $0xc8,%eax
80105547:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010554a:	77 e7                	ja     80105533 <get_stack_frame+0x10>
      if(CSTACKFRAME_UNUSED == iter->used) { // found one!
        break;
      }
    // out of while.
      if( CSTACK_SIZE + cstack->frames == iter) // none found
8010554c:	8b 45 08             	mov    0x8(%ebp),%eax
8010554f:	05 c8 00 00 00       	add    $0xc8,%eax
80105554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105557:	75 07                	jne    80105560 <get_stack_frame+0x3d>
        return EMPTY_STACK;
80105559:	b8 00 00 00 00       	mov    $0x0,%eax
8010555e:	eb 25                	jmp    80105585 <get_stack_frame+0x62>
  }while(!cas(&iter->used, CSTACKFRAME_UNUSED, CSTACKFRAME_USED));
80105560:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105563:	83 c0 0c             	add    $0xc,%eax
80105566:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010556d:	00 
8010556e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105575:	00 
80105576:	89 04 24             	mov    %eax,(%esp)
80105579:	e8 80 ed ff ff       	call   801042fe <cas>
8010557e:	85 c0                	test   %eax,%eax
80105580:	74 af                	je     80105531 <get_stack_frame+0xe>

  // we caught an unused stack frame!
  return iter;
80105582:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105585:	c9                   	leave  
80105586:	c3                   	ret    

80105587 <sigset>:

// SIGNAL SYSTEM CALLS HELPER FUNCTIONS.
// ******************************************** 

// sigset. Not sure what to return here.. Maybe int? or IDK
sig_handler sigset(sig_handler handler) {
80105587:	55                   	push   %ebp
80105588:	89 e5                	mov    %esp,%ebp
8010558a:	83 ec 10             	sub    $0x10,%esp
  // could there be a data race here? I don't think so. 
  sig_handler old = proc->sig_handler; 
8010558d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105593:	8b 40 7c             	mov    0x7c(%eax),%eax
80105596:	89 45 fc             	mov    %eax,-0x4(%ebp)
  proc->sig_handler = handler;
80105599:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010559f:	8b 55 08             	mov    0x8(%ebp),%edx
801055a2:	89 50 7c             	mov    %edx,0x7c(%eax)
  return old; 
801055a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055a8:	c9                   	leave  
801055a9:	c3                   	ret    

801055aa <sigsend>:

// Not sure if I need to synchronize anything here. 
int sigsend(int dest_pid, int value) {
801055aa:	55                   	push   %ebp
801055ab:	89 e5                	mov    %esp,%ebp
801055ad:	83 ec 28             	sub    $0x28,%esp
  struct proc* p = ptable.proc;
801055b0:	c7 45 f4 e0 39 11 80 	movl   $0x801139e0,-0xc(%ebp)
  int res = -1;
801055b7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  while(p < ptable.proc + NPROC) {
801055be:	eb 4f                	jmp    8010560f <sigsend+0x65>
    if(p->pid == dest_pid){  // Found it.
801055c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c3:	8b 40 10             	mov    0x10(%eax),%eax
801055c6:	3b 45 08             	cmp    0x8(%ebp),%eax
801055c9:	75 3d                	jne    80105608 <sigsend+0x5e>

     res = push(&p->cstack, proc->pid /* sender */, dest_pid, value);
801055cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d1:	8b 40 10             	mov    0x10(%eax),%eax
801055d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d7:	8d 8a 80 00 00 00    	lea    0x80(%edx),%ecx
801055dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801055e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
801055e4:	8b 55 08             	mov    0x8(%ebp),%edx
801055e7:	89 54 24 08          	mov    %edx,0x8(%esp)
801055eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ef:	89 0c 24             	mov    %ecx,(%esp)
801055f2:	e8 63 fe ff ff       	call   8010545a <push>
801055f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     wakeup(&p->cstack);
801055fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055fd:	83 e8 80             	sub    $0xffffff80,%eax
80105600:	89 04 24             	mov    %eax,(%esp)
80105603:	e8 14 fd ff ff       	call   8010531c <wakeup>
    }
    ++p;
80105608:	81 45 f4 78 01 00 00 	addl   $0x178,-0xc(%ebp)

// Not sure if I need to synchronize anything here. 
int sigsend(int dest_pid, int value) {
  struct proc* p = ptable.proc;
  int res = -1;
  while(p < ptable.proc + NPROC) {
8010560f:	81 7d f4 e0 97 11 80 	cmpl   $0x801197e0,-0xc(%ebp)
80105616:	72 a8                	jb     801055c0 <sigsend+0x16>
     wakeup(&p->cstack);
    }
    ++p;
  }
  // If no such process was found. Well we can always return -1;
  return res;
80105618:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010561b:	c9                   	leave  
8010561c:	c3                   	ret    

8010561d <sigpause>:

int sigpause() { 
8010561d:	55                   	push   %ebp
8010561e:	89 e5                	mov    %esp,%ebp
80105620:	83 ec 18             	sub    $0x18,%esp
  //acquire(&ptable.lock);
  pushcli();
80105623:	e8 d1 06 00 00       	call   80105cf9 <pushcli>
  for(;;) {
    //proc->state = NEG_SLEEPING;
    check_cas(RUNNING, NEG_SLEEPING);
80105628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562e:	83 c0 0c             	add    $0xc,%eax
80105631:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
80105638:	00 
80105639:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80105640:	00 
80105641:	89 04 24             	mov    %eax,(%esp)
80105644:	e8 b5 ec ff ff       	call   801042fe <cas>
80105649:	85 c0                	test   %eax,%eax
8010564b:	75 42                	jne    8010568f <sigpause+0x72>
8010564d:	e8 71 fd ff ff       	call   801053c3 <procdump>
80105652:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105658:	8b 40 0c             	mov    0xc(%eax),%eax
8010565b:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80105662:	a1 30 c0 10 80       	mov    0x8010c030,%eax
80105667:	c7 44 24 0c b0 02 00 	movl   $0x2b0,0xc(%esp)
8010566e:	00 
8010566f:	89 54 24 08          	mov    %edx,0x8(%esp)
80105673:	89 44 24 04          	mov    %eax,0x4(%esp)
80105677:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
8010567e:	e8 1d ad ff ff       	call   801003a0 <cprintf>
80105683:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
8010568a:	e8 ab ae ff ff       	call   8010053a <panic>
    proc->paused = 1;
8010568f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105695:	c7 80 74 01 00 00 01 	movl   $0x1,0x174(%eax)
8010569c:	00 00 00 
    proc->chan = (int) &proc->cstack;
8010569f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056ac:	83 ea 80             	sub    $0xffffff80,%edx
801056af:	89 50 20             	mov    %edx,0x20(%eax)

    if(proc->cstack.head != EMPTY_STACK) {
801056b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b8:	8b 80 48 01 00 00    	mov    0x148(%eax),%eax
801056be:	85 c0                	test   %eax,%eax
801056c0:	0f 84 90 00 00 00    	je     80105756 <sigpause+0x139>
      check_cas(NEG_SLEEPING, RUNNING);
801056c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056cc:	83 c0 0c             	add    $0xc,%eax
801056cf:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801056d6:	00 
801056d7:	c7 44 24 04 07 00 00 	movl   $0x7,0x4(%esp)
801056de:	00 
801056df:	89 04 24             	mov    %eax,(%esp)
801056e2:	e8 17 ec ff ff       	call   801042fe <cas>
801056e7:	85 c0                	test   %eax,%eax
801056e9:	75 42                	jne    8010572d <sigpause+0x110>
801056eb:	e8 d3 fc ff ff       	call   801053c3 <procdump>
801056f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f6:	8b 40 0c             	mov    0xc(%eax),%eax
801056f9:	8b 14 85 20 c0 10 80 	mov    -0x7fef3fe0(,%eax,4),%edx
80105700:	a1 3c c0 10 80       	mov    0x8010c03c,%eax
80105705:	c7 44 24 0c b5 02 00 	movl   $0x2b5,0xc(%esp)
8010570c:	00 
8010570d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105711:	89 44 24 04          	mov    %eax,0x4(%esp)
80105715:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
8010571c:	e8 7f ac ff ff       	call   801003a0 <cprintf>
80105721:	c7 04 24 9b 95 10 80 	movl   $0x8010959b,(%esp)
80105728:	e8 0d ae ff ff       	call   8010053a <panic>
      proc->paused = 0;
8010572d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105733:	c7 80 74 01 00 00 00 	movl   $0x0,0x174(%eax)
8010573a:	00 00 00 
      proc->chan = 0;
8010573d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105743:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
      //release(&ptable.lock);
      popcli();
8010574a:	e8 ee 05 00 00       	call   80105d3d <popcli>
      return 1;
8010574f:	b8 01 00 00 00       	mov    $0x1,%eax
80105754:	eb 36                	jmp    8010578c <sigpause+0x16f>
    }
    sched_check;
80105756:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010575c:	85 c0                	test   %eax,%eax
8010575e:	74 22                	je     80105782 <sigpause+0x165>
80105760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105766:	8b 40 0c             	mov    0xc(%eax),%eax
80105769:	83 f8 04             	cmp    $0x4,%eax
8010576c:	75 14                	jne    80105782 <sigpause+0x165>
8010576e:	c7 44 24 04 bc 02 00 	movl   $0x2bc,0x4(%esp)
80105775:	00 
80105776:	c7 04 24 b7 95 10 80 	movl   $0x801095b7,(%esp)
8010577d:	e8 1e ac ff ff       	call   801003a0 <cprintf>
    sched();
80105782:	e8 ed f7 ff ff       	call   80104f74 <sched>
  }
80105787:	e9 9c fe ff ff       	jmp    80105628 <sigpause+0xb>

  return 0;
}
8010578c:	c9                   	leave  
8010578d:	c3                   	ret    

8010578e <sigret>:

// Here we must restore the previous cpu state after the sig handler..
void sigret() {
8010578e:	55                   	push   %ebp
8010578f:	89 e5                	mov    %esp,%ebp
  // restore the backed up cpu_state.
  proc->tf->edi = proc->cpu_state.edi;
80105791:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105797:	8b 40 18             	mov    0x18(%eax),%eax
8010579a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801057a1:	8b 92 4c 01 00 00    	mov    0x14c(%edx),%edx
801057a7:	89 10                	mov    %edx,(%eax)
  proc->tf->esi = proc->cpu_state.esi;
801057a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057af:	8b 40 18             	mov    0x18(%eax),%eax
801057b2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801057b9:	8b 92 50 01 00 00    	mov    0x150(%edx),%edx
801057bf:	89 50 04             	mov    %edx,0x4(%eax)
  proc->tf->ebp = proc->cpu_state.ebp;
801057c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057c8:	8b 40 18             	mov    0x18(%eax),%eax
801057cb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801057d2:	8b 92 54 01 00 00    	mov    0x154(%edx),%edx
801057d8:	89 50 08             	mov    %edx,0x8(%eax)
  proc->tf->ebx = proc->cpu_state.ebx;
801057db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057e1:	8b 40 18             	mov    0x18(%eax),%eax
801057e4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801057eb:	8b 92 58 01 00 00    	mov    0x158(%edx),%edx
801057f1:	89 50 10             	mov    %edx,0x10(%eax)
  proc->tf->edx = proc->cpu_state.edx;
801057f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057fa:	8b 40 18             	mov    0x18(%eax),%eax
801057fd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105804:	8b 92 5c 01 00 00    	mov    0x15c(%edx),%edx
8010580a:	89 50 14             	mov    %edx,0x14(%eax)
  proc->tf->ecx = proc->cpu_state.ecx;
8010580d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105813:	8b 40 18             	mov    0x18(%eax),%eax
80105816:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010581d:	8b 92 60 01 00 00    	mov    0x160(%edx),%edx
80105823:	89 50 18             	mov    %edx,0x18(%eax)
  proc->tf->eax = proc->cpu_state.eax;
80105826:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582c:	8b 40 18             	mov    0x18(%eax),%eax
8010582f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105836:	8b 92 64 01 00 00    	mov    0x164(%edx),%edx
8010583c:	89 50 1c             	mov    %edx,0x1c(%eax)
  proc->tf->eip = proc->cpu_state.eip;
8010583f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105845:	8b 40 18             	mov    0x18(%eax),%eax
80105848:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010584f:	8b 92 68 01 00 00    	mov    0x168(%edx),%edx
80105855:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = proc->cpu_state.esp;
80105858:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010585e:	8b 40 18             	mov    0x18(%eax),%eax
80105861:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105868:	8b 92 6c 01 00 00    	mov    0x16c(%edx),%edx
8010586e:	89 50 44             	mov    %edx,0x44(%eax)
  proc->in_handler = OUT_HANDLER;
80105871:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105877:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
8010587e:	00 00 00 
}
80105881:	5d                   	pop    %ebp
80105882:	c3                   	ret    

80105883 <handle_signals>:
// should do something with pending signals!!! 
// The plan is to now - if proc = zero ret 0-- need to ask if this is possible
// else if the stack is empty or if that the sig handler is the default one.
// Just pop the stack and return 0.
// else <backup the user tf> and return the cstack frame to the assembly fellah
int handle_signals() {
80105883:	55                   	push   %ebp
80105884:	89 e5                	mov    %esp,%ebp
80105886:	83 ec 28             	sub    $0x28,%esp
  struct cstackframe* curr = 0;
80105889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  if(proc != 0 && ((proc->tf->cs & 3) == 3)) {
80105890:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105896:	85 c0                	test   %eax,%eax
80105898:	0f 84 a3 00 00 00    	je     80105941 <handle_signals+0xbe>
8010589e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058a4:	8b 40 18             	mov    0x18(%eax),%eax
801058a7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801058ab:	0f b7 c0             	movzwl %ax,%eax
801058ae:	83 e0 03             	and    $0x3,%eax
801058b1:	83 f8 03             	cmp    $0x3,%eax
801058b4:	0f 85 87 00 00 00    	jne    80105941 <handle_signals+0xbe>
    curr = (proc->in_handler == IN_HANDLER) ? EMPTY_STACK : pop(&proc->cstack);
801058ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c0:	8b 80 70 01 00 00    	mov    0x170(%eax),%eax
801058c6:	83 f8 01             	cmp    $0x1,%eax
801058c9:	74 13                	je     801058de <handle_signals+0x5b>
801058cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d1:	83 e8 80             	sub    $0xffffff80,%eax
801058d4:	89 04 24             	mov    %eax,(%esp)
801058d7:	e8 f5 fb ff ff       	call   801054d1 <pop>
801058dc:	eb 05                	jmp    801058e3 <handle_signals+0x60>
801058de:	b8 00 00 00 00       	mov    $0x0,%eax
801058e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(curr == EMPTY_STACK || proc->sig_handler == DEFAULT_HANDLER) {
801058e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058ea:	74 0e                	je     801058fa <handle_signals+0x77>
801058ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f2:	8b 40 7c             	mov    0x7c(%eax),%eax
801058f5:	83 f8 ff             	cmp    $0xffffffff,%eax
801058f8:	75 07                	jne    80105901 <handle_signals+0x7e>
      return 0;
801058fa:	b8 00 00 00 00       	mov    $0x0,%eax
801058ff:	eb 45                	jmp    80105946 <handle_signals+0xc3>
    }
    // else return curr - and do stuff in assembly?
    // backup part of tf?
    backup_proc_tf(proc); 
80105901:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105907:	89 04 24             	mov    %eax,(%esp)
8010590a:	e8 39 00 00 00       	call   80105948 <backup_proc_tf>
    edit_tf_for_sighandler(proc, curr->value, curr->sender_pid);
8010590f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105912:	8b 08                	mov    (%eax),%ecx
80105914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105917:	8b 50 08             	mov    0x8(%eax),%edx
8010591a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105920:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105924:	89 54 24 04          	mov    %edx,0x4(%esp)
80105928:	89 04 24             	mov    %eax,(%esp)
8010592b:	e8 ce 00 00 00       	call   801059fe <edit_tf_for_sighandler>
    // finished using the frame. free it.
    curr->used = CSTACKFRAME_UNUSED;
80105930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105933:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 1;
8010593a:	b8 01 00 00 00       	mov    $0x1,%eax
8010593f:	eb 05                	jmp    80105946 <handle_signals+0xc3>
  }
  return 0; // proc is 0 - not sure what to do here is this a data race?
80105941:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105946:	c9                   	leave  
80105947:	c3                   	ret    

80105948 <backup_proc_tf>:

void backup_proc_tf(struct proc* p) {
80105948:	55                   	push   %ebp
80105949:	89 e5                	mov    %esp,%ebp
  proc->in_handler = IN_HANDLER;
8010594b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105951:	c7 80 70 01 00 00 01 	movl   $0x1,0x170(%eax)
80105958:	00 00 00 
  p->cpu_state.edi = p->tf->edi;
8010595b:	8b 45 08             	mov    0x8(%ebp),%eax
8010595e:	8b 40 18             	mov    0x18(%eax),%eax
80105961:	8b 10                	mov    (%eax),%edx
80105963:	8b 45 08             	mov    0x8(%ebp),%eax
80105966:	89 90 4c 01 00 00    	mov    %edx,0x14c(%eax)
  p->cpu_state.esi = p->tf->esi;
8010596c:	8b 45 08             	mov    0x8(%ebp),%eax
8010596f:	8b 40 18             	mov    0x18(%eax),%eax
80105972:	8b 50 04             	mov    0x4(%eax),%edx
80105975:	8b 45 08             	mov    0x8(%ebp),%eax
80105978:	89 90 50 01 00 00    	mov    %edx,0x150(%eax)
  p->cpu_state.ebp = p->tf->ebp;
8010597e:	8b 45 08             	mov    0x8(%ebp),%eax
80105981:	8b 40 18             	mov    0x18(%eax),%eax
80105984:	8b 50 08             	mov    0x8(%eax),%edx
80105987:	8b 45 08             	mov    0x8(%ebp),%eax
8010598a:	89 90 54 01 00 00    	mov    %edx,0x154(%eax)
  p->cpu_state.ebx = p->tf->ebx;
80105990:	8b 45 08             	mov    0x8(%ebp),%eax
80105993:	8b 40 18             	mov    0x18(%eax),%eax
80105996:	8b 50 10             	mov    0x10(%eax),%edx
80105999:	8b 45 08             	mov    0x8(%ebp),%eax
8010599c:	89 90 58 01 00 00    	mov    %edx,0x158(%eax)
  p->cpu_state.edx = p->tf->edx;
801059a2:	8b 45 08             	mov    0x8(%ebp),%eax
801059a5:	8b 40 18             	mov    0x18(%eax),%eax
801059a8:	8b 50 14             	mov    0x14(%eax),%edx
801059ab:	8b 45 08             	mov    0x8(%ebp),%eax
801059ae:	89 90 5c 01 00 00    	mov    %edx,0x15c(%eax)
  p->cpu_state.ecx = p->tf->ecx;
801059b4:	8b 45 08             	mov    0x8(%ebp),%eax
801059b7:	8b 40 18             	mov    0x18(%eax),%eax
801059ba:	8b 50 18             	mov    0x18(%eax),%edx
801059bd:	8b 45 08             	mov    0x8(%ebp),%eax
801059c0:	89 90 60 01 00 00    	mov    %edx,0x160(%eax)
  p->cpu_state.eax = p->tf->eax;
801059c6:	8b 45 08             	mov    0x8(%ebp),%eax
801059c9:	8b 40 18             	mov    0x18(%eax),%eax
801059cc:	8b 50 1c             	mov    0x1c(%eax),%edx
801059cf:	8b 45 08             	mov    0x8(%ebp),%eax
801059d2:	89 90 64 01 00 00    	mov    %edx,0x164(%eax)
  p->cpu_state.eip = p->tf->eip;
801059d8:	8b 45 08             	mov    0x8(%ebp),%eax
801059db:	8b 40 18             	mov    0x18(%eax),%eax
801059de:	8b 50 38             	mov    0x38(%eax),%edx
801059e1:	8b 45 08             	mov    0x8(%ebp),%eax
801059e4:	89 90 68 01 00 00    	mov    %edx,0x168(%eax)
  p->cpu_state.esp = p->tf->esp;
801059ea:	8b 45 08             	mov    0x8(%ebp),%eax
801059ed:	8b 40 18             	mov    0x18(%eax),%eax
801059f0:	8b 50 44             	mov    0x44(%eax),%edx
801059f3:	8b 45 08             	mov    0x8(%ebp),%eax
801059f6:	89 90 6c 01 00 00    	mov    %edx,0x16c(%eax)
}
801059fc:	5d                   	pop    %ebp
801059fd:	c3                   	ret    

801059fe <edit_tf_for_sighandler>:

// This function gets the user-stack ready for invoking the signal handler.
// we need for the ret address for the injected code to be the old eip.
// we inject both the sigret code on the stack, its address on the stack as 
// the return address of the handler and the handler args.
void edit_tf_for_sighandler(struct proc* p, int value_arg, int pid_arg) {
801059fe:	55                   	push   %ebp
801059ff:	89 e5                	mov    %esp,%ebp
80105a01:	83 ec 28             	sub    $0x28,%esp
  uint injected_code_size;
  uint injected_code_address;
  uint old_eip = proc->tf->eip;
80105a04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a0a:	8b 40 18             	mov    0x18(%eax),%eax
80105a0d:	8b 40 38             	mov    0x38(%eax),%eax
80105a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  // we need edit the eip to be the address of the sighandler. 
  p->tf->eip = (uint) p->sig_handler;
80105a13:	8b 45 08             	mov    0x8(%ebp),%eax
80105a16:	8b 40 18             	mov    0x18(%eax),%eax
80105a19:	8b 55 08             	mov    0x8(%ebp),%edx
80105a1c:	8b 52 7c             	mov    0x7c(%edx),%edx
80105a1f:	89 50 38             	mov    %edx,0x38(%eax)

  // do I need to make room for the return address here? probably
  // We need to make room for the injected sigret code. fml. 
  injected_code_size = (&sigret_label_end - &sigret_label_start); 
80105a22:	ba ce 72 10 80       	mov    $0x801072ce,%edx
80105a27:	b8 c6 72 10 80       	mov    $0x801072c6,%eax
80105a2c:	29 c2                	sub    %eax,%edx
80105a2e:	89 d0                	mov    %edx,%eax
80105a30:	89 45 f4             	mov    %eax,-0xc(%ebp)

  proc->tf->esp -= 4; // room for the old eip.
80105a33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a39:	8b 40 18             	mov    0x18(%eax),%eax
80105a3c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105a43:	8b 52 18             	mov    0x18(%edx),%edx
80105a46:	8b 52 44             	mov    0x44(%edx),%edx
80105a49:	83 ea 04             	sub    $0x4,%edx
80105a4c:	89 50 44             	mov    %edx,0x44(%eax)
  memmove((void *) proc->tf->esp,
80105a4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a55:	8b 40 18             	mov    0x18(%eax),%eax
80105a58:	8b 40 44             	mov    0x44(%eax),%eax
80105a5b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105a62:	00 
80105a63:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105a66:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a6a:	89 04 24             	mov    %eax,(%esp)
80105a6d:	e8 56 04 00 00       	call   80105ec8 <memmove>
          (const void *) &old_eip,
          4);
  
  // Update the user-esp, make room for sigret code.
  p->tf->esp -= injected_code_size;
80105a72:	8b 45 08             	mov    0x8(%ebp),%eax
80105a75:	8b 40 18             	mov    0x18(%eax),%eax
80105a78:	8b 55 08             	mov    0x8(%ebp),%edx
80105a7b:	8b 52 18             	mov    0x18(%edx),%edx
80105a7e:	8b 52 44             	mov    0x44(%edx),%edx
80105a81:	2b 55 f4             	sub    -0xc(%ebp),%edx
80105a84:	89 50 44             	mov    %edx,0x44(%eax)
  injected_code_address = p->tf->esp;
80105a87:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8a:	8b 40 18             	mov    0x18(%eax),%eax
80105a8d:	8b 40 44             	mov    0x44(%eax),%eax
80105a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Move the code onto the stack. 
  memmove((void *) injected_code_address,
80105a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a99:	89 54 24 08          	mov    %edx,0x8(%esp)
80105a9d:	c7 44 24 04 c6 72 10 	movl   $0x801072c6,0x4(%esp)
80105aa4:	80 
80105aa5:	89 04 24             	mov    %eax,(%esp)
80105aa8:	e8 1b 04 00 00       	call   80105ec8 <memmove>
          (const void *) &sigret_label_start, 
          injected_code_size);
  
  p->tf->esp -= 4; // make room for second arg fml
80105aad:	8b 45 08             	mov    0x8(%ebp),%eax
80105ab0:	8b 40 18             	mov    0x18(%eax),%eax
80105ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80105ab6:	8b 52 18             	mov    0x18(%edx),%edx
80105ab9:	8b 52 44             	mov    0x44(%edx),%edx
80105abc:	83 ea 04             	sub    $0x4,%edx
80105abf:	89 50 44             	mov    %edx,0x44(%eax)
  memmove((void *) p->tf->esp,
80105ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac5:	8b 40 18             	mov    0x18(%eax),%eax
80105ac8:	8b 40 44             	mov    0x44(%eax),%eax
80105acb:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105ad2:	00 
80105ad3:	8d 55 0c             	lea    0xc(%ebp),%edx
80105ad6:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ada:	89 04 24             	mov    %eax,(%esp)
80105add:	e8 e6 03 00 00       	call   80105ec8 <memmove>
      (const void *) &value_arg,
      4);

  p->tf->esp -= 4; // make room for first arg fml
80105ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae5:	8b 40 18             	mov    0x18(%eax),%eax
80105ae8:	8b 55 08             	mov    0x8(%ebp),%edx
80105aeb:	8b 52 18             	mov    0x18(%edx),%edx
80105aee:	8b 52 44             	mov    0x44(%edx),%edx
80105af1:	83 ea 04             	sub    $0x4,%edx
80105af4:	89 50 44             	mov    %edx,0x44(%eax)
  memmove((void *) p->tf->esp,
80105af7:	8b 45 08             	mov    0x8(%ebp),%eax
80105afa:	8b 40 18             	mov    0x18(%eax),%eax
80105afd:	8b 40 44             	mov    0x44(%eax),%eax
80105b00:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105b07:	00 
80105b08:	8d 55 10             	lea    0x10(%ebp),%edx
80105b0b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b0f:	89 04 24             	mov    %eax,(%esp)
80105b12:	e8 b1 03 00 00       	call   80105ec8 <memmove>
      (const void *) &pid_arg,
      4);
  p->tf->esp -= 4; // make room for the return address
80105b17:	8b 45 08             	mov    0x8(%ebp),%eax
80105b1a:	8b 40 18             	mov    0x18(%eax),%eax
80105b1d:	8b 55 08             	mov    0x8(%ebp),%edx
80105b20:	8b 52 18             	mov    0x18(%edx),%edx
80105b23:	8b 52 44             	mov    0x44(%edx),%edx
80105b26:	83 ea 04             	sub    $0x4,%edx
80105b29:	89 50 44             	mov    %edx,0x44(%eax)
  memmove((void *) p->tf->esp,
80105b2c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b2f:	8b 40 18             	mov    0x18(%eax),%eax
80105b32:	8b 40 44             	mov    0x44(%eax),%eax
80105b35:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105b3c:	00 
80105b3d:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105b40:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b44:	89 04 24             	mov    %eax,(%esp)
80105b47:	e8 7c 03 00 00       	call   80105ec8 <memmove>
      (const void *) &injected_code_address,
      4);
}
80105b4c:	c9                   	leave  
80105b4d:	c3                   	ret    

80105b4e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105b4e:	55                   	push   %ebp
80105b4f:	89 e5                	mov    %esp,%ebp
80105b51:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105b54:	9c                   	pushf  
80105b55:	58                   	pop    %eax
80105b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105b5c:	c9                   	leave  
80105b5d:	c3                   	ret    

80105b5e <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105b5e:	55                   	push   %ebp
80105b5f:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105b61:	fa                   	cli    
}
80105b62:	5d                   	pop    %ebp
80105b63:	c3                   	ret    

80105b64 <sti>:

static inline void
sti(void)
{
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105b67:	fb                   	sti    
}
80105b68:	5d                   	pop    %ebp
80105b69:	c3                   	ret    

80105b6a <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105b6a:	55                   	push   %ebp
80105b6b:	89 e5                	mov    %esp,%ebp
80105b6d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105b70:	8b 55 08             	mov    0x8(%ebp),%edx
80105b73:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b76:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105b79:	f0 87 02             	lock xchg %eax,(%edx)
80105b7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105b82:	c9                   	leave  
80105b83:	c3                   	ret    

80105b84 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105b87:	8b 45 08             	mov    0x8(%ebp),%eax
80105b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b8d:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105b90:	8b 45 08             	mov    0x8(%ebp),%eax
80105b93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105b99:	8b 45 08             	mov    0x8(%ebp),%eax
80105b9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105ba3:	5d                   	pop    %ebp
80105ba4:	c3                   	ret    

80105ba5 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105ba5:	55                   	push   %ebp
80105ba6:	89 e5                	mov    %esp,%ebp
80105ba8:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105bab:	e8 49 01 00 00       	call   80105cf9 <pushcli>
  if(holding(lk))
80105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb3:	89 04 24             	mov    %eax,(%esp)
80105bb6:	e8 14 01 00 00       	call   80105ccf <holding>
80105bbb:	85 c0                	test   %eax,%eax
80105bbd:	74 0c                	je     80105bcb <acquire+0x26>
    panic("acquire");
80105bbf:	c7 04 24 46 96 10 80 	movl   $0x80109646,(%esp)
80105bc6:	e8 6f a9 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105bcb:	90                   	nop
80105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80105bcf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105bd6:	00 
80105bd7:	89 04 24             	mov    %eax,(%esp)
80105bda:	e8 8b ff ff ff       	call   80105b6a <xchg>
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	75 e9                	jne    80105bcc <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105be3:	8b 45 08             	mov    0x8(%ebp),%eax
80105be6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105bed:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf3:	83 c0 0c             	add    $0xc,%eax
80105bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bfa:	8d 45 08             	lea    0x8(%ebp),%eax
80105bfd:	89 04 24             	mov    %eax,(%esp)
80105c00:	e8 51 00 00 00       	call   80105c56 <getcallerpcs>
}
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    

80105c07 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105c07:	55                   	push   %ebp
80105c08:	89 e5                	mov    %esp,%ebp
80105c0a:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80105c10:	89 04 24             	mov    %eax,(%esp)
80105c13:	e8 b7 00 00 00       	call   80105ccf <holding>
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	75 0c                	jne    80105c28 <release+0x21>
    panic("release");
80105c1c:	c7 04 24 4e 96 10 80 	movl   $0x8010964e,(%esp)
80105c23:	e8 12 a9 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105c28:	8b 45 08             	mov    0x8(%ebp),%eax
80105c2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105c32:	8b 45 08             	mov    0x8(%ebp),%eax
80105c35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80105c3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c46:	00 
80105c47:	89 04 24             	mov    %eax,(%esp)
80105c4a:	e8 1b ff ff ff       	call   80105b6a <xchg>

  popcli();
80105c4f:	e8 e9 00 00 00       	call   80105d3d <popcli>
}
80105c54:	c9                   	leave  
80105c55:	c3                   	ret    

80105c56 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105c56:	55                   	push   %ebp
80105c57:	89 e5                	mov    %esp,%ebp
80105c59:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80105c5f:	83 e8 08             	sub    $0x8,%eax
80105c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105c65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105c6c:	eb 38                	jmp    80105ca6 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105c72:	74 38                	je     80105cac <getcallerpcs+0x56>
80105c74:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105c7b:	76 2f                	jbe    80105cac <getcallerpcs+0x56>
80105c7d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105c81:	74 29                	je     80105cac <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105c83:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105c86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c90:	01 c2                	add    %eax,%edx
80105c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c95:	8b 40 04             	mov    0x4(%eax),%eax
80105c98:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c9d:	8b 00                	mov    (%eax),%eax
80105c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105ca2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105ca6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105caa:	7e c2                	jle    80105c6e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105cac:	eb 19                	jmp    80105cc7 <getcallerpcs+0x71>
    pcs[i] = 0;
80105cae:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cbb:	01 d0                	add    %edx,%eax
80105cbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105cc3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105cc7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105ccb:	7e e1                	jle    80105cae <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105ccd:	c9                   	leave  
80105cce:	c3                   	ret    

80105ccf <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105ccf:	55                   	push   %ebp
80105cd0:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd5:	8b 00                	mov    (%eax),%eax
80105cd7:	85 c0                	test   %eax,%eax
80105cd9:	74 17                	je     80105cf2 <holding+0x23>
80105cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80105cde:	8b 50 08             	mov    0x8(%eax),%edx
80105ce1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105ce7:	39 c2                	cmp    %eax,%edx
80105ce9:	75 07                	jne    80105cf2 <holding+0x23>
80105ceb:	b8 01 00 00 00       	mov    $0x1,%eax
80105cf0:	eb 05                	jmp    80105cf7 <holding+0x28>
80105cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cf7:	5d                   	pop    %ebp
80105cf8:	c3                   	ret    

80105cf9 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105cf9:	55                   	push   %ebp
80105cfa:	89 e5                	mov    %esp,%ebp
80105cfc:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105cff:	e8 4a fe ff ff       	call   80105b4e <readeflags>
80105d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105d07:	e8 52 fe ff ff       	call   80105b5e <cli>
  if(cpu->ncli++ == 0)
80105d0c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105d13:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105d19:	8d 48 01             	lea    0x1(%eax),%ecx
80105d1c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105d22:	85 c0                	test   %eax,%eax
80105d24:	75 15                	jne    80105d3b <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105d26:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105d2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d2f:	81 e2 00 02 00 00    	and    $0x200,%edx
80105d35:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105d3b:	c9                   	leave  
80105d3c:	c3                   	ret    

80105d3d <popcli>:

void
popcli(void)
{
80105d3d:	55                   	push   %ebp
80105d3e:	89 e5                	mov    %esp,%ebp
80105d40:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105d43:	e8 06 fe ff ff       	call   80105b4e <readeflags>
80105d48:	25 00 02 00 00       	and    $0x200,%eax
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	74 0c                	je     80105d5d <popcli+0x20>
    panic("popcli - interruptible");
80105d51:	c7 04 24 56 96 10 80 	movl   $0x80109656,(%esp)
80105d58:	e8 dd a7 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105d5d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105d63:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105d69:	83 ea 01             	sub    $0x1,%edx
80105d6c:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105d72:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	79 0c                	jns    80105d88 <popcli+0x4b>
    panic("popcli");
80105d7c:	c7 04 24 6d 96 10 80 	movl   $0x8010966d,(%esp)
80105d83:	e8 b2 a7 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105d88:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105d8e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105d94:	85 c0                	test   %eax,%eax
80105d96:	75 15                	jne    80105dad <popcli+0x70>
80105d98:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105d9e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105da4:	85 c0                	test   %eax,%eax
80105da6:	74 05                	je     80105dad <popcli+0x70>
    sti();
80105da8:	e8 b7 fd ff ff       	call   80105b64 <sti>
}
80105dad:	c9                   	leave  
80105dae:	c3                   	ret    

80105daf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105daf:	55                   	push   %ebp
80105db0:	89 e5                	mov    %esp,%ebp
80105db2:	57                   	push   %edi
80105db3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105db4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105db7:	8b 55 10             	mov    0x10(%ebp),%edx
80105dba:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dbd:	89 cb                	mov    %ecx,%ebx
80105dbf:	89 df                	mov    %ebx,%edi
80105dc1:	89 d1                	mov    %edx,%ecx
80105dc3:	fc                   	cld    
80105dc4:	f3 aa                	rep stos %al,%es:(%edi)
80105dc6:	89 ca                	mov    %ecx,%edx
80105dc8:	89 fb                	mov    %edi,%ebx
80105dca:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105dcd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105dd0:	5b                   	pop    %ebx
80105dd1:	5f                   	pop    %edi
80105dd2:	5d                   	pop    %ebp
80105dd3:	c3                   	ret    

80105dd4 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	57                   	push   %edi
80105dd8:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105dd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105ddc:	8b 55 10             	mov    0x10(%ebp),%edx
80105ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105de2:	89 cb                	mov    %ecx,%ebx
80105de4:	89 df                	mov    %ebx,%edi
80105de6:	89 d1                	mov    %edx,%ecx
80105de8:	fc                   	cld    
80105de9:	f3 ab                	rep stos %eax,%es:(%edi)
80105deb:	89 ca                	mov    %ecx,%edx
80105ded:	89 fb                	mov    %edi,%ebx
80105def:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105df2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105df5:	5b                   	pop    %ebx
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    

80105df9 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105df9:	55                   	push   %ebp
80105dfa:	89 e5                	mov    %esp,%ebp
80105dfc:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105dff:	8b 45 08             	mov    0x8(%ebp),%eax
80105e02:	83 e0 03             	and    $0x3,%eax
80105e05:	85 c0                	test   %eax,%eax
80105e07:	75 49                	jne    80105e52 <memset+0x59>
80105e09:	8b 45 10             	mov    0x10(%ebp),%eax
80105e0c:	83 e0 03             	and    $0x3,%eax
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	75 3f                	jne    80105e52 <memset+0x59>
    c &= 0xFF;
80105e13:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105e1a:	8b 45 10             	mov    0x10(%ebp),%eax
80105e1d:	c1 e8 02             	shr    $0x2,%eax
80105e20:	89 c2                	mov    %eax,%edx
80105e22:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e25:	c1 e0 18             	shl    $0x18,%eax
80105e28:	89 c1                	mov    %eax,%ecx
80105e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e2d:	c1 e0 10             	shl    $0x10,%eax
80105e30:	09 c1                	or     %eax,%ecx
80105e32:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e35:	c1 e0 08             	shl    $0x8,%eax
80105e38:	09 c8                	or     %ecx,%eax
80105e3a:	0b 45 0c             	or     0xc(%ebp),%eax
80105e3d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e41:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e45:	8b 45 08             	mov    0x8(%ebp),%eax
80105e48:	89 04 24             	mov    %eax,(%esp)
80105e4b:	e8 84 ff ff ff       	call   80105dd4 <stosl>
80105e50:	eb 19                	jmp    80105e6b <memset+0x72>
  } else
    stosb(dst, c, n);
80105e52:	8b 45 10             	mov    0x10(%ebp),%eax
80105e55:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e59:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e60:	8b 45 08             	mov    0x8(%ebp),%eax
80105e63:	89 04 24             	mov    %eax,(%esp)
80105e66:	e8 44 ff ff ff       	call   80105daf <stosb>
  return dst;
80105e6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105e6e:	c9                   	leave  
80105e6f:	c3                   	ret    

80105e70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105e76:	8b 45 08             	mov    0x8(%ebp),%eax
80105e79:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105e82:	eb 30                	jmp    80105eb4 <memcmp+0x44>
    if(*s1 != *s2)
80105e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e87:	0f b6 10             	movzbl (%eax),%edx
80105e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105e8d:	0f b6 00             	movzbl (%eax),%eax
80105e90:	38 c2                	cmp    %al,%dl
80105e92:	74 18                	je     80105eac <memcmp+0x3c>
      return *s1 - *s2;
80105e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e97:	0f b6 00             	movzbl (%eax),%eax
80105e9a:	0f b6 d0             	movzbl %al,%edx
80105e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105ea0:	0f b6 00             	movzbl (%eax),%eax
80105ea3:	0f b6 c0             	movzbl %al,%eax
80105ea6:	29 c2                	sub    %eax,%edx
80105ea8:	89 d0                	mov    %edx,%eax
80105eaa:	eb 1a                	jmp    80105ec6 <memcmp+0x56>
    s1++, s2++;
80105eac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105eb0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105eb4:	8b 45 10             	mov    0x10(%ebp),%eax
80105eb7:	8d 50 ff             	lea    -0x1(%eax),%edx
80105eba:	89 55 10             	mov    %edx,0x10(%ebp)
80105ebd:	85 c0                	test   %eax,%eax
80105ebf:	75 c3                	jne    80105e84 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ec6:	c9                   	leave  
80105ec7:	c3                   	ret    

80105ec8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105ec8:	55                   	push   %ebp
80105ec9:	89 e5                	mov    %esp,%ebp
80105ecb:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ed7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105edd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105ee0:	73 3d                	jae    80105f1f <memmove+0x57>
80105ee2:	8b 45 10             	mov    0x10(%ebp),%eax
80105ee5:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ee8:	01 d0                	add    %edx,%eax
80105eea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105eed:	76 30                	jbe    80105f1f <memmove+0x57>
    s += n;
80105eef:	8b 45 10             	mov    0x10(%ebp),%eax
80105ef2:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105ef5:	8b 45 10             	mov    0x10(%ebp),%eax
80105ef8:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105efb:	eb 13                	jmp    80105f10 <memmove+0x48>
      *--d = *--s;
80105efd:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105f01:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f08:	0f b6 10             	movzbl (%eax),%edx
80105f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f0e:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105f10:	8b 45 10             	mov    0x10(%ebp),%eax
80105f13:	8d 50 ff             	lea    -0x1(%eax),%edx
80105f16:	89 55 10             	mov    %edx,0x10(%ebp)
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	75 e0                	jne    80105efd <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105f1d:	eb 26                	jmp    80105f45 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105f1f:	eb 17                	jmp    80105f38 <memmove+0x70>
      *d++ = *s++;
80105f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f24:	8d 50 01             	lea    0x1(%eax),%edx
80105f27:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105f2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
80105f30:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105f33:	0f b6 12             	movzbl (%edx),%edx
80105f36:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105f38:	8b 45 10             	mov    0x10(%ebp),%eax
80105f3b:	8d 50 ff             	lea    -0x1(%eax),%edx
80105f3e:	89 55 10             	mov    %edx,0x10(%ebp)
80105f41:	85 c0                	test   %eax,%eax
80105f43:	75 dc                	jne    80105f21 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105f45:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105f48:	c9                   	leave  
80105f49:	c3                   	ret    

80105f4a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105f4a:	55                   	push   %ebp
80105f4b:	89 e5                	mov    %esp,%ebp
80105f4d:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105f50:	8b 45 10             	mov    0x10(%ebp),%eax
80105f53:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f57:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80105f61:	89 04 24             	mov    %eax,(%esp)
80105f64:	e8 5f ff ff ff       	call   80105ec8 <memmove>
}
80105f69:	c9                   	leave  
80105f6a:	c3                   	ret    

80105f6b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105f6b:	55                   	push   %ebp
80105f6c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105f6e:	eb 0c                	jmp    80105f7c <strncmp+0x11>
    n--, p++, q++;
80105f70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105f74:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105f78:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105f7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105f80:	74 1a                	je     80105f9c <strncmp+0x31>
80105f82:	8b 45 08             	mov    0x8(%ebp),%eax
80105f85:	0f b6 00             	movzbl (%eax),%eax
80105f88:	84 c0                	test   %al,%al
80105f8a:	74 10                	je     80105f9c <strncmp+0x31>
80105f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80105f8f:	0f b6 10             	movzbl (%eax),%edx
80105f92:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f95:	0f b6 00             	movzbl (%eax),%eax
80105f98:	38 c2                	cmp    %al,%dl
80105f9a:	74 d4                	je     80105f70 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105f9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105fa0:	75 07                	jne    80105fa9 <strncmp+0x3e>
    return 0;
80105fa2:	b8 00 00 00 00       	mov    $0x0,%eax
80105fa7:	eb 16                	jmp    80105fbf <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80105fac:	0f b6 00             	movzbl (%eax),%eax
80105faf:	0f b6 d0             	movzbl %al,%edx
80105fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fb5:	0f b6 00             	movzbl (%eax),%eax
80105fb8:	0f b6 c0             	movzbl %al,%eax
80105fbb:	29 c2                	sub    %eax,%edx
80105fbd:	89 d0                	mov    %edx,%eax
}
80105fbf:	5d                   	pop    %ebp
80105fc0:	c3                   	ret    

80105fc1 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105fc1:	55                   	push   %ebp
80105fc2:	89 e5                	mov    %esp,%ebp
80105fc4:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80105fca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105fcd:	90                   	nop
80105fce:	8b 45 10             	mov    0x10(%ebp),%eax
80105fd1:	8d 50 ff             	lea    -0x1(%eax),%edx
80105fd4:	89 55 10             	mov    %edx,0x10(%ebp)
80105fd7:	85 c0                	test   %eax,%eax
80105fd9:	7e 1e                	jle    80105ff9 <strncpy+0x38>
80105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80105fde:	8d 50 01             	lea    0x1(%eax),%edx
80105fe1:	89 55 08             	mov    %edx,0x8(%ebp)
80105fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fe7:	8d 4a 01             	lea    0x1(%edx),%ecx
80105fea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105fed:	0f b6 12             	movzbl (%edx),%edx
80105ff0:	88 10                	mov    %dl,(%eax)
80105ff2:	0f b6 00             	movzbl (%eax),%eax
80105ff5:	84 c0                	test   %al,%al
80105ff7:	75 d5                	jne    80105fce <strncpy+0xd>
    ;
  while(n-- > 0)
80105ff9:	eb 0c                	jmp    80106007 <strncpy+0x46>
    *s++ = 0;
80105ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80105ffe:	8d 50 01             	lea    0x1(%eax),%edx
80106001:	89 55 08             	mov    %edx,0x8(%ebp)
80106004:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106007:	8b 45 10             	mov    0x10(%ebp),%eax
8010600a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010600d:	89 55 10             	mov    %edx,0x10(%ebp)
80106010:	85 c0                	test   %eax,%eax
80106012:	7f e7                	jg     80105ffb <strncpy+0x3a>
    *s++ = 0;
  return os;
80106014:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106017:	c9                   	leave  
80106018:	c3                   	ret    

80106019 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106019:	55                   	push   %ebp
8010601a:	89 e5                	mov    %esp,%ebp
8010601c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010601f:	8b 45 08             	mov    0x8(%ebp),%eax
80106022:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106025:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106029:	7f 05                	jg     80106030 <safestrcpy+0x17>
    return os;
8010602b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010602e:	eb 31                	jmp    80106061 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106030:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106038:	7e 1e                	jle    80106058 <safestrcpy+0x3f>
8010603a:	8b 45 08             	mov    0x8(%ebp),%eax
8010603d:	8d 50 01             	lea    0x1(%eax),%edx
80106040:	89 55 08             	mov    %edx,0x8(%ebp)
80106043:	8b 55 0c             	mov    0xc(%ebp),%edx
80106046:	8d 4a 01             	lea    0x1(%edx),%ecx
80106049:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010604c:	0f b6 12             	movzbl (%edx),%edx
8010604f:	88 10                	mov    %dl,(%eax)
80106051:	0f b6 00             	movzbl (%eax),%eax
80106054:	84 c0                	test   %al,%al
80106056:	75 d8                	jne    80106030 <safestrcpy+0x17>
    ;
  *s = 0;
80106058:	8b 45 08             	mov    0x8(%ebp),%eax
8010605b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010605e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106061:	c9                   	leave  
80106062:	c3                   	ret    

80106063 <strlen>:

int
strlen(const char *s)
{
80106063:	55                   	push   %ebp
80106064:	89 e5                	mov    %esp,%ebp
80106066:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106069:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106070:	eb 04                	jmp    80106076 <strlen+0x13>
80106072:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106076:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106079:	8b 45 08             	mov    0x8(%ebp),%eax
8010607c:	01 d0                	add    %edx,%eax
8010607e:	0f b6 00             	movzbl (%eax),%eax
80106081:	84 c0                	test   %al,%al
80106083:	75 ed                	jne    80106072 <strlen+0xf>
    ;
  return n;
80106085:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106088:	c9                   	leave  
80106089:	c3                   	ret    

8010608a <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010608a:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010608e:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106092:	55                   	push   %ebp
  pushl %ebx
80106093:	53                   	push   %ebx
  pushl %esi
80106094:	56                   	push   %esi
  pushl %edi
80106095:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106096:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106098:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010609a:	5f                   	pop    %edi
  popl %esi
8010609b:	5e                   	pop    %esi
  popl %ebx
8010609c:	5b                   	pop    %ebx
  popl %ebp
8010609d:	5d                   	pop    %ebp
  ret
8010609e:	c3                   	ret    

8010609f <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010609f:	55                   	push   %ebp
801060a0:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801060a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060a8:	8b 00                	mov    (%eax),%eax
801060aa:	3b 45 08             	cmp    0x8(%ebp),%eax
801060ad:	76 12                	jbe    801060c1 <fetchint+0x22>
801060af:	8b 45 08             	mov    0x8(%ebp),%eax
801060b2:	8d 50 04             	lea    0x4(%eax),%edx
801060b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060bb:	8b 00                	mov    (%eax),%eax
801060bd:	39 c2                	cmp    %eax,%edx
801060bf:	76 07                	jbe    801060c8 <fetchint+0x29>
    return -1;
801060c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c6:	eb 0f                	jmp    801060d7 <fetchint+0x38>
  *ip = *(int*)(addr);
801060c8:	8b 45 08             	mov    0x8(%ebp),%eax
801060cb:	8b 10                	mov    (%eax),%edx
801060cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801060d0:	89 10                	mov    %edx,(%eax)
  return 0;
801060d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060d7:	5d                   	pop    %ebp
801060d8:	c3                   	ret    

801060d9 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801060d9:	55                   	push   %ebp
801060da:	89 e5                	mov    %esp,%ebp
801060dc:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801060df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060e5:	8b 00                	mov    (%eax),%eax
801060e7:	3b 45 08             	cmp    0x8(%ebp),%eax
801060ea:	77 07                	ja     801060f3 <fetchstr+0x1a>
    return -1;
801060ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f1:	eb 46                	jmp    80106139 <fetchstr+0x60>
  *pp = (char*)addr;
801060f3:	8b 55 08             	mov    0x8(%ebp),%edx
801060f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801060f9:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801060fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106101:	8b 00                	mov    (%eax),%eax
80106103:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106106:	8b 45 0c             	mov    0xc(%ebp),%eax
80106109:	8b 00                	mov    (%eax),%eax
8010610b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010610e:	eb 1c                	jmp    8010612c <fetchstr+0x53>
    if(*s == 0)
80106110:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106113:	0f b6 00             	movzbl (%eax),%eax
80106116:	84 c0                	test   %al,%al
80106118:	75 0e                	jne    80106128 <fetchstr+0x4f>
      return s - *pp;
8010611a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010611d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106120:	8b 00                	mov    (%eax),%eax
80106122:	29 c2                	sub    %eax,%edx
80106124:	89 d0                	mov    %edx,%eax
80106126:	eb 11                	jmp    80106139 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106128:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010612c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010612f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106132:	72 dc                	jb     80106110 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106139:	c9                   	leave  
8010613a:	c3                   	ret    

8010613b <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010613b:	55                   	push   %ebp
8010613c:	89 e5                	mov    %esp,%ebp
8010613e:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106141:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106147:	8b 40 18             	mov    0x18(%eax),%eax
8010614a:	8b 50 44             	mov    0x44(%eax),%edx
8010614d:	8b 45 08             	mov    0x8(%ebp),%eax
80106150:	c1 e0 02             	shl    $0x2,%eax
80106153:	01 d0                	add    %edx,%eax
80106155:	8d 50 04             	lea    0x4(%eax),%edx
80106158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010615b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010615f:	89 14 24             	mov    %edx,(%esp)
80106162:	e8 38 ff ff ff       	call   8010609f <fetchint>
}
80106167:	c9                   	leave  
80106168:	c3                   	ret    

80106169 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106169:	55                   	push   %ebp
8010616a:	89 e5                	mov    %esp,%ebp
8010616c:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010616f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106172:	89 44 24 04          	mov    %eax,0x4(%esp)
80106176:	8b 45 08             	mov    0x8(%ebp),%eax
80106179:	89 04 24             	mov    %eax,(%esp)
8010617c:	e8 ba ff ff ff       	call   8010613b <argint>
80106181:	85 c0                	test   %eax,%eax
80106183:	79 07                	jns    8010618c <argptr+0x23>
    return -1;
80106185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010618a:	eb 3d                	jmp    801061c9 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010618c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010618f:	89 c2                	mov    %eax,%edx
80106191:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106197:	8b 00                	mov    (%eax),%eax
80106199:	39 c2                	cmp    %eax,%edx
8010619b:	73 16                	jae    801061b3 <argptr+0x4a>
8010619d:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061a0:	89 c2                	mov    %eax,%edx
801061a2:	8b 45 10             	mov    0x10(%ebp),%eax
801061a5:	01 c2                	add    %eax,%edx
801061a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061ad:	8b 00                	mov    (%eax),%eax
801061af:	39 c2                	cmp    %eax,%edx
801061b1:	76 07                	jbe    801061ba <argptr+0x51>
    return -1;
801061b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b8:	eb 0f                	jmp    801061c9 <argptr+0x60>
  *pp = (char*)i;
801061ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061bd:	89 c2                	mov    %eax,%edx
801061bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801061c2:	89 10                	mov    %edx,(%eax)
  return 0;
801061c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061c9:	c9                   	leave  
801061ca:	c3                   	ret    

801061cb <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801061cb:	55                   	push   %ebp
801061cc:	89 e5                	mov    %esp,%ebp
801061ce:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801061d1:	8d 45 fc             	lea    -0x4(%ebp),%eax
801061d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801061d8:	8b 45 08             	mov    0x8(%ebp),%eax
801061db:	89 04 24             	mov    %eax,(%esp)
801061de:	e8 58 ff ff ff       	call   8010613b <argint>
801061e3:	85 c0                	test   %eax,%eax
801061e5:	79 07                	jns    801061ee <argstr+0x23>
    return -1;
801061e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ec:	eb 12                	jmp    80106200 <argstr+0x35>
  return fetchstr(addr, pp);
801061ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801061f4:	89 54 24 04          	mov    %edx,0x4(%esp)
801061f8:	89 04 24             	mov    %eax,(%esp)
801061fb:	e8 d9 fe ff ff       	call   801060d9 <fetchstr>
}
80106200:	c9                   	leave  
80106201:	c3                   	ret    

80106202 <syscall>:
[SYS_sigpause] sys_sigpause,
};

void
syscall(void)
{
80106202:	55                   	push   %ebp
80106203:	89 e5                	mov    %esp,%ebp
80106205:	53                   	push   %ebx
80106206:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80106209:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010620f:	8b 40 18             	mov    0x18(%eax),%eax
80106212:	8b 40 1c             	mov    0x1c(%eax),%eax
80106215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010621c:	7e 30                	jle    8010624e <syscall+0x4c>
8010621e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106221:	83 f8 19             	cmp    $0x19,%eax
80106224:	77 28                	ja     8010624e <syscall+0x4c>
80106226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106229:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106230:	85 c0                	test   %eax,%eax
80106232:	74 1a                	je     8010624e <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106234:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010623a:	8b 58 18             	mov    0x18(%eax),%ebx
8010623d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106240:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
80106247:	ff d0                	call   *%eax
80106249:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010624c:	eb 3d                	jmp    8010628b <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010624e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106254:	8d 48 6c             	lea    0x6c(%eax),%ecx
80106257:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010625d:	8b 40 10             	mov    0x10(%eax),%eax
80106260:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106263:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106267:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010626b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010626f:	c7 04 24 74 96 10 80 	movl   $0x80109674,(%esp)
80106276:	e8 25 a1 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010627b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106281:	8b 40 18             	mov    0x18(%eax),%eax
80106284:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010628b:	83 c4 24             	add    $0x24,%esp
8010628e:	5b                   	pop    %ebx
8010628f:	5d                   	pop    %ebp
80106290:	c3                   	ret    

80106291 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106291:	55                   	push   %ebp
80106292:	89 e5                	mov    %esp,%ebp
80106294:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106297:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010629a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629e:	8b 45 08             	mov    0x8(%ebp),%eax
801062a1:	89 04 24             	mov    %eax,(%esp)
801062a4:	e8 92 fe ff ff       	call   8010613b <argint>
801062a9:	85 c0                	test   %eax,%eax
801062ab:	79 07                	jns    801062b4 <argfd+0x23>
    return -1;
801062ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b2:	eb 50                	jmp    80106304 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801062b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062b7:	85 c0                	test   %eax,%eax
801062b9:	78 21                	js     801062dc <argfd+0x4b>
801062bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062be:	83 f8 0f             	cmp    $0xf,%eax
801062c1:	7f 19                	jg     801062dc <argfd+0x4b>
801062c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062cc:	83 c2 08             	add    $0x8,%edx
801062cf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801062d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062da:	75 07                	jne    801062e3 <argfd+0x52>
    return -1;
801062dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e1:	eb 21                	jmp    80106304 <argfd+0x73>
  if(pfd)
801062e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801062e7:	74 08                	je     801062f1 <argfd+0x60>
    *pfd = fd;
801062e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801062ef:	89 10                	mov    %edx,(%eax)
  if(pf)
801062f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062f5:	74 08                	je     801062ff <argfd+0x6e>
    *pf = f;
801062f7:	8b 45 10             	mov    0x10(%ebp),%eax
801062fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062fd:	89 10                	mov    %edx,(%eax)
  return 0;
801062ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106304:	c9                   	leave  
80106305:	c3                   	ret    

80106306 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106306:	55                   	push   %ebp
80106307:	89 e5                	mov    %esp,%ebp
80106309:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010630c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106313:	eb 30                	jmp    80106345 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106315:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010631b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010631e:	83 c2 08             	add    $0x8,%edx
80106321:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106325:	85 c0                	test   %eax,%eax
80106327:	75 18                	jne    80106341 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106329:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010632f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106332:	8d 4a 08             	lea    0x8(%edx),%ecx
80106335:	8b 55 08             	mov    0x8(%ebp),%edx
80106338:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010633c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010633f:	eb 0f                	jmp    80106350 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106341:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106345:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106349:	7e ca                	jle    80106315 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010634b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106350:	c9                   	leave  
80106351:	c3                   	ret    

80106352 <sys_dup>:

int
sys_dup(void)
{
80106352:	55                   	push   %ebp
80106353:	89 e5                	mov    %esp,%ebp
80106355:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106358:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010635b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010635f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106366:	00 
80106367:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010636e:	e8 1e ff ff ff       	call   80106291 <argfd>
80106373:	85 c0                	test   %eax,%eax
80106375:	79 07                	jns    8010637e <sys_dup+0x2c>
    return -1;
80106377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637c:	eb 29                	jmp    801063a7 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010637e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106381:	89 04 24             	mov    %eax,(%esp)
80106384:	e8 7d ff ff ff       	call   80106306 <fdalloc>
80106389:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010638c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106390:	79 07                	jns    80106399 <sys_dup+0x47>
    return -1;
80106392:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106397:	eb 0e                	jmp    801063a7 <sys_dup+0x55>
  filedup(f);
80106399:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639c:	89 04 24             	mov    %eax,(%esp)
8010639f:	e8 f4 ab ff ff       	call   80100f98 <filedup>
  return fd;
801063a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801063a7:	c9                   	leave  
801063a8:	c3                   	ret    

801063a9 <sys_read>:

int
sys_read(void)
{
801063a9:	55                   	push   %ebp
801063aa:	89 e5                	mov    %esp,%ebp
801063ac:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801063af:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063b2:	89 44 24 08          	mov    %eax,0x8(%esp)
801063b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063bd:	00 
801063be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063c5:	e8 c7 fe ff ff       	call   80106291 <argfd>
801063ca:	85 c0                	test   %eax,%eax
801063cc:	78 35                	js     80106403 <sys_read+0x5a>
801063ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801063d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801063dc:	e8 5a fd ff ff       	call   8010613b <argint>
801063e1:	85 c0                	test   %eax,%eax
801063e3:	78 1e                	js     80106403 <sys_read+0x5a>
801063e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e8:	89 44 24 08          	mov    %eax,0x8(%esp)
801063ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801063f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801063fa:	e8 6a fd ff ff       	call   80106169 <argptr>
801063ff:	85 c0                	test   %eax,%eax
80106401:	79 07                	jns    8010640a <sys_read+0x61>
    return -1;
80106403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106408:	eb 19                	jmp    80106423 <sys_read+0x7a>
  return fileread(f, p, n);
8010640a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010640d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106413:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106417:	89 54 24 04          	mov    %edx,0x4(%esp)
8010641b:	89 04 24             	mov    %eax,(%esp)
8010641e:	e8 e2 ac ff ff       	call   80101105 <fileread>
}
80106423:	c9                   	leave  
80106424:	c3                   	ret    

80106425 <sys_write>:

int
sys_write(void)
{
80106425:	55                   	push   %ebp
80106426:	89 e5                	mov    %esp,%ebp
80106428:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010642b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010642e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106432:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106439:	00 
8010643a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106441:	e8 4b fe ff ff       	call   80106291 <argfd>
80106446:	85 c0                	test   %eax,%eax
80106448:	78 35                	js     8010647f <sys_write+0x5a>
8010644a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010644d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106451:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106458:	e8 de fc ff ff       	call   8010613b <argint>
8010645d:	85 c0                	test   %eax,%eax
8010645f:	78 1e                	js     8010647f <sys_write+0x5a>
80106461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106464:	89 44 24 08          	mov    %eax,0x8(%esp)
80106468:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010646b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010646f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106476:	e8 ee fc ff ff       	call   80106169 <argptr>
8010647b:	85 c0                	test   %eax,%eax
8010647d:	79 07                	jns    80106486 <sys_write+0x61>
    return -1;
8010647f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106484:	eb 19                	jmp    8010649f <sys_write+0x7a>
  return filewrite(f, p, n);
80106486:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106489:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010648c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106493:	89 54 24 04          	mov    %edx,0x4(%esp)
80106497:	89 04 24             	mov    %eax,(%esp)
8010649a:	e8 22 ad ff ff       	call   801011c1 <filewrite>
}
8010649f:	c9                   	leave  
801064a0:	c3                   	ret    

801064a1 <sys_close>:

int
sys_close(void)
{
801064a1:	55                   	push   %ebp
801064a2:	89 e5                	mov    %esp,%ebp
801064a4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801064a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801064ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801064b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064bc:	e8 d0 fd ff ff       	call   80106291 <argfd>
801064c1:	85 c0                	test   %eax,%eax
801064c3:	79 07                	jns    801064cc <sys_close+0x2b>
    return -1;
801064c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ca:	eb 24                	jmp    801064f0 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801064cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064d5:	83 c2 08             	add    $0x8,%edx
801064d8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064df:	00 
  fileclose(f);
801064e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064e3:	89 04 24             	mov    %eax,(%esp)
801064e6:	e8 f5 aa ff ff       	call   80100fe0 <fileclose>
  return 0;
801064eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064f0:	c9                   	leave  
801064f1:	c3                   	ret    

801064f2 <sys_fstat>:

int
sys_fstat(void)
{
801064f2:	55                   	push   %ebp
801064f3:	89 e5                	mov    %esp,%ebp
801064f5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801064f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801064ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106506:	00 
80106507:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010650e:	e8 7e fd ff ff       	call   80106291 <argfd>
80106513:	85 c0                	test   %eax,%eax
80106515:	78 1f                	js     80106536 <sys_fstat+0x44>
80106517:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010651e:	00 
8010651f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106522:	89 44 24 04          	mov    %eax,0x4(%esp)
80106526:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010652d:	e8 37 fc ff ff       	call   80106169 <argptr>
80106532:	85 c0                	test   %eax,%eax
80106534:	79 07                	jns    8010653d <sys_fstat+0x4b>
    return -1;
80106536:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010653b:	eb 12                	jmp    8010654f <sys_fstat+0x5d>
  return filestat(f, st);
8010653d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106543:	89 54 24 04          	mov    %edx,0x4(%esp)
80106547:	89 04 24             	mov    %eax,(%esp)
8010654a:	e8 67 ab ff ff       	call   801010b6 <filestat>
}
8010654f:	c9                   	leave  
80106550:	c3                   	ret    

80106551 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106551:	55                   	push   %ebp
80106552:	89 e5                	mov    %esp,%ebp
80106554:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106557:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010655a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010655e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106565:	e8 61 fc ff ff       	call   801061cb <argstr>
8010656a:	85 c0                	test   %eax,%eax
8010656c:	78 17                	js     80106585 <sys_link+0x34>
8010656e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106571:	89 44 24 04          	mov    %eax,0x4(%esp)
80106575:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010657c:	e8 4a fc ff ff       	call   801061cb <argstr>
80106581:	85 c0                	test   %eax,%eax
80106583:	79 0a                	jns    8010658f <sys_link+0x3e>
    return -1;
80106585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658a:	e9 42 01 00 00       	jmp    801066d1 <sys_link+0x180>

  begin_op();
8010658f:	e8 8e ce ff ff       	call   80103422 <begin_op>
  if((ip = namei(old)) == 0){
80106594:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106597:	89 04 24             	mov    %eax,(%esp)
8010659a:	e8 79 be ff ff       	call   80102418 <namei>
8010659f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065a6:	75 0f                	jne    801065b7 <sys_link+0x66>
    end_op();
801065a8:	e8 f9 ce ff ff       	call   801034a6 <end_op>
    return -1;
801065ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b2:	e9 1a 01 00 00       	jmp    801066d1 <sys_link+0x180>
  }

  ilock(ip);
801065b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ba:	89 04 24             	mov    %eax,(%esp)
801065bd:	e8 ab b2 ff ff       	call   8010186d <ilock>
  if(ip->type == T_DIR){
801065c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801065c9:	66 83 f8 01          	cmp    $0x1,%ax
801065cd:	75 1a                	jne    801065e9 <sys_link+0x98>
    iunlockput(ip);
801065cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d2:	89 04 24             	mov    %eax,(%esp)
801065d5:	e8 17 b5 ff ff       	call   80101af1 <iunlockput>
    end_op();
801065da:	e8 c7 ce ff ff       	call   801034a6 <end_op>
    return -1;
801065df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e4:	e9 e8 00 00 00       	jmp    801066d1 <sys_link+0x180>
  }

  ip->nlink++;
801065e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ec:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801065f0:	8d 50 01             	lea    0x1(%eax),%edx
801065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f6:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801065fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fd:	89 04 24             	mov    %eax,(%esp)
80106600:	e8 ac b0 ff ff       	call   801016b1 <iupdate>
  iunlock(ip);
80106605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106608:	89 04 24             	mov    %eax,(%esp)
8010660b:	e8 ab b3 ff ff       	call   801019bb <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106610:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106613:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106616:	89 54 24 04          	mov    %edx,0x4(%esp)
8010661a:	89 04 24             	mov    %eax,(%esp)
8010661d:	e8 18 be ff ff       	call   8010243a <nameiparent>
80106622:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106625:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106629:	75 02                	jne    8010662d <sys_link+0xdc>
    goto bad;
8010662b:	eb 68                	jmp    80106695 <sys_link+0x144>
  ilock(dp);
8010662d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106630:	89 04 24             	mov    %eax,(%esp)
80106633:	e8 35 b2 ff ff       	call   8010186d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106638:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010663b:	8b 10                	mov    (%eax),%edx
8010663d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106640:	8b 00                	mov    (%eax),%eax
80106642:	39 c2                	cmp    %eax,%edx
80106644:	75 20                	jne    80106666 <sys_link+0x115>
80106646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106649:	8b 40 04             	mov    0x4(%eax),%eax
8010664c:	89 44 24 08          	mov    %eax,0x8(%esp)
80106650:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106653:	89 44 24 04          	mov    %eax,0x4(%esp)
80106657:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010665a:	89 04 24             	mov    %eax,(%esp)
8010665d:	e8 f6 ba ff ff       	call   80102158 <dirlink>
80106662:	85 c0                	test   %eax,%eax
80106664:	79 0d                	jns    80106673 <sys_link+0x122>
    iunlockput(dp);
80106666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106669:	89 04 24             	mov    %eax,(%esp)
8010666c:	e8 80 b4 ff ff       	call   80101af1 <iunlockput>
    goto bad;
80106671:	eb 22                	jmp    80106695 <sys_link+0x144>
  }
  iunlockput(dp);
80106673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106676:	89 04 24             	mov    %eax,(%esp)
80106679:	e8 73 b4 ff ff       	call   80101af1 <iunlockput>
  iput(ip);
8010667e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106681:	89 04 24             	mov    %eax,(%esp)
80106684:	e8 97 b3 ff ff       	call   80101a20 <iput>

  end_op();
80106689:	e8 18 ce ff ff       	call   801034a6 <end_op>

  return 0;
8010668e:	b8 00 00 00 00       	mov    $0x0,%eax
80106693:	eb 3c                	jmp    801066d1 <sys_link+0x180>

bad:
  ilock(ip);
80106695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106698:	89 04 24             	mov    %eax,(%esp)
8010669b:	e8 cd b1 ff ff       	call   8010186d <ilock>
  ip->nlink--;
801066a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801066a7:	8d 50 ff             	lea    -0x1(%eax),%edx
801066aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ad:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801066b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b4:	89 04 24             	mov    %eax,(%esp)
801066b7:	e8 f5 af ff ff       	call   801016b1 <iupdate>
  iunlockput(ip);
801066bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066bf:	89 04 24             	mov    %eax,(%esp)
801066c2:	e8 2a b4 ff ff       	call   80101af1 <iunlockput>
  end_op();
801066c7:	e8 da cd ff ff       	call   801034a6 <end_op>
  return -1;
801066cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066d1:	c9                   	leave  
801066d2:	c3                   	ret    

801066d3 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801066d3:	55                   	push   %ebp
801066d4:	89 e5                	mov    %esp,%ebp
801066d6:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801066d9:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801066e0:	eb 4b                	jmp    8010672d <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801066e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e5:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801066ec:	00 
801066ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801066f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801066f8:	8b 45 08             	mov    0x8(%ebp),%eax
801066fb:	89 04 24             	mov    %eax,(%esp)
801066fe:	e8 77 b6 ff ff       	call   80101d7a <readi>
80106703:	83 f8 10             	cmp    $0x10,%eax
80106706:	74 0c                	je     80106714 <isdirempty+0x41>
      panic("isdirempty: readi");
80106708:	c7 04 24 90 96 10 80 	movl   $0x80109690,(%esp)
8010670f:	e8 26 9e ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80106714:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106718:	66 85 c0             	test   %ax,%ax
8010671b:	74 07                	je     80106724 <isdirempty+0x51>
      return 0;
8010671d:	b8 00 00 00 00       	mov    $0x0,%eax
80106722:	eb 1b                	jmp    8010673f <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106727:	83 c0 10             	add    $0x10,%eax
8010672a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010672d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106730:	8b 45 08             	mov    0x8(%ebp),%eax
80106733:	8b 40 18             	mov    0x18(%eax),%eax
80106736:	39 c2                	cmp    %eax,%edx
80106738:	72 a8                	jb     801066e2 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010673a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010673f:	c9                   	leave  
80106740:	c3                   	ret    

80106741 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106741:	55                   	push   %ebp
80106742:	89 e5                	mov    %esp,%ebp
80106744:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106747:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010674a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010674e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106755:	e8 71 fa ff ff       	call   801061cb <argstr>
8010675a:	85 c0                	test   %eax,%eax
8010675c:	79 0a                	jns    80106768 <sys_unlink+0x27>
    return -1;
8010675e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106763:	e9 af 01 00 00       	jmp    80106917 <sys_unlink+0x1d6>

  begin_op();
80106768:	e8 b5 cc ff ff       	call   80103422 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010676d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106770:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106773:	89 54 24 04          	mov    %edx,0x4(%esp)
80106777:	89 04 24             	mov    %eax,(%esp)
8010677a:	e8 bb bc ff ff       	call   8010243a <nameiparent>
8010677f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106786:	75 0f                	jne    80106797 <sys_unlink+0x56>
    end_op();
80106788:	e8 19 cd ff ff       	call   801034a6 <end_op>
    return -1;
8010678d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106792:	e9 80 01 00 00       	jmp    80106917 <sys_unlink+0x1d6>
  }

  ilock(dp);
80106797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679a:	89 04 24             	mov    %eax,(%esp)
8010679d:	e8 cb b0 ff ff       	call   8010186d <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801067a2:	c7 44 24 04 a2 96 10 	movl   $0x801096a2,0x4(%esp)
801067a9:	80 
801067aa:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801067ad:	89 04 24             	mov    %eax,(%esp)
801067b0:	e8 b8 b8 ff ff       	call   8010206d <namecmp>
801067b5:	85 c0                	test   %eax,%eax
801067b7:	0f 84 45 01 00 00    	je     80106902 <sys_unlink+0x1c1>
801067bd:	c7 44 24 04 a4 96 10 	movl   $0x801096a4,0x4(%esp)
801067c4:	80 
801067c5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801067c8:	89 04 24             	mov    %eax,(%esp)
801067cb:	e8 9d b8 ff ff       	call   8010206d <namecmp>
801067d0:	85 c0                	test   %eax,%eax
801067d2:	0f 84 2a 01 00 00    	je     80106902 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801067d8:	8d 45 c8             	lea    -0x38(%ebp),%eax
801067db:	89 44 24 08          	mov    %eax,0x8(%esp)
801067df:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801067e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801067e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e9:	89 04 24             	mov    %eax,(%esp)
801067ec:	e8 9e b8 ff ff       	call   8010208f <dirlookup>
801067f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067f8:	75 05                	jne    801067ff <sys_unlink+0xbe>
    goto bad;
801067fa:	e9 03 01 00 00       	jmp    80106902 <sys_unlink+0x1c1>
  ilock(ip);
801067ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106802:	89 04 24             	mov    %eax,(%esp)
80106805:	e8 63 b0 ff ff       	call   8010186d <ilock>

  if(ip->nlink < 1)
8010680a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010680d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106811:	66 85 c0             	test   %ax,%ax
80106814:	7f 0c                	jg     80106822 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80106816:	c7 04 24 a7 96 10 80 	movl   $0x801096a7,(%esp)
8010681d:	e8 18 9d ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106822:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106825:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106829:	66 83 f8 01          	cmp    $0x1,%ax
8010682d:	75 1f                	jne    8010684e <sys_unlink+0x10d>
8010682f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106832:	89 04 24             	mov    %eax,(%esp)
80106835:	e8 99 fe ff ff       	call   801066d3 <isdirempty>
8010683a:	85 c0                	test   %eax,%eax
8010683c:	75 10                	jne    8010684e <sys_unlink+0x10d>
    iunlockput(ip);
8010683e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106841:	89 04 24             	mov    %eax,(%esp)
80106844:	e8 a8 b2 ff ff       	call   80101af1 <iunlockput>
    goto bad;
80106849:	e9 b4 00 00 00       	jmp    80106902 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
8010684e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106855:	00 
80106856:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010685d:	00 
8010685e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106861:	89 04 24             	mov    %eax,(%esp)
80106864:	e8 90 f5 ff ff       	call   80105df9 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106869:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010686c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106873:	00 
80106874:	89 44 24 08          	mov    %eax,0x8(%esp)
80106878:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010687b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010687f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106882:	89 04 24             	mov    %eax,(%esp)
80106885:	e8 54 b6 ff ff       	call   80101ede <writei>
8010688a:	83 f8 10             	cmp    $0x10,%eax
8010688d:	74 0c                	je     8010689b <sys_unlink+0x15a>
    panic("unlink: writei");
8010688f:	c7 04 24 b9 96 10 80 	movl   $0x801096b9,(%esp)
80106896:	e8 9f 9c ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
8010689b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010689e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801068a2:	66 83 f8 01          	cmp    $0x1,%ax
801068a6:	75 1c                	jne    801068c4 <sys_unlink+0x183>
    dp->nlink--;
801068a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ab:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801068af:	8d 50 ff             	lea    -0x1(%eax),%edx
801068b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	89 04 24             	mov    %eax,(%esp)
801068bf:	e8 ed ad ff ff       	call   801016b1 <iupdate>
  }
  iunlockput(dp);
801068c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c7:	89 04 24             	mov    %eax,(%esp)
801068ca:	e8 22 b2 ff ff       	call   80101af1 <iunlockput>

  ip->nlink--;
801068cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068d2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801068d6:	8d 50 ff             	lea    -0x1(%eax),%edx
801068d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068dc:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801068e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068e3:	89 04 24             	mov    %eax,(%esp)
801068e6:	e8 c6 ad ff ff       	call   801016b1 <iupdate>
  iunlockput(ip);
801068eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068ee:	89 04 24             	mov    %eax,(%esp)
801068f1:	e8 fb b1 ff ff       	call   80101af1 <iunlockput>

  end_op();
801068f6:	e8 ab cb ff ff       	call   801034a6 <end_op>

  return 0;
801068fb:	b8 00 00 00 00       	mov    $0x0,%eax
80106900:	eb 15                	jmp    80106917 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80106902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106905:	89 04 24             	mov    %eax,(%esp)
80106908:	e8 e4 b1 ff ff       	call   80101af1 <iunlockput>
  end_op();
8010690d:	e8 94 cb ff ff       	call   801034a6 <end_op>
  return -1;
80106912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106917:	c9                   	leave  
80106918:	c3                   	ret    

80106919 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106919:	55                   	push   %ebp
8010691a:	89 e5                	mov    %esp,%ebp
8010691c:	83 ec 48             	sub    $0x48,%esp
8010691f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106922:	8b 55 10             	mov    0x10(%ebp),%edx
80106925:	8b 45 14             	mov    0x14(%ebp),%eax
80106928:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010692c:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106930:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106934:	8d 45 de             	lea    -0x22(%ebp),%eax
80106937:	89 44 24 04          	mov    %eax,0x4(%esp)
8010693b:	8b 45 08             	mov    0x8(%ebp),%eax
8010693e:	89 04 24             	mov    %eax,(%esp)
80106941:	e8 f4 ba ff ff       	call   8010243a <nameiparent>
80106946:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010694d:	75 0a                	jne    80106959 <create+0x40>
    return 0;
8010694f:	b8 00 00 00 00       	mov    $0x0,%eax
80106954:	e9 7e 01 00 00       	jmp    80106ad7 <create+0x1be>
  ilock(dp);
80106959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695c:	89 04 24             	mov    %eax,(%esp)
8010695f:	e8 09 af ff ff       	call   8010186d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106964:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106967:	89 44 24 08          	mov    %eax,0x8(%esp)
8010696b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010696e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106975:	89 04 24             	mov    %eax,(%esp)
80106978:	e8 12 b7 ff ff       	call   8010208f <dirlookup>
8010697d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106984:	74 47                	je     801069cd <create+0xb4>
    iunlockput(dp);
80106986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106989:	89 04 24             	mov    %eax,(%esp)
8010698c:	e8 60 b1 ff ff       	call   80101af1 <iunlockput>
    ilock(ip);
80106991:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106994:	89 04 24             	mov    %eax,(%esp)
80106997:	e8 d1 ae ff ff       	call   8010186d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010699c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801069a1:	75 15                	jne    801069b8 <create+0x9f>
801069a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069a6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801069aa:	66 83 f8 02          	cmp    $0x2,%ax
801069ae:	75 08                	jne    801069b8 <create+0x9f>
      return ip;
801069b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069b3:	e9 1f 01 00 00       	jmp    80106ad7 <create+0x1be>
    iunlockput(ip);
801069b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069bb:	89 04 24             	mov    %eax,(%esp)
801069be:	e8 2e b1 ff ff       	call   80101af1 <iunlockput>
    return 0;
801069c3:	b8 00 00 00 00       	mov    $0x0,%eax
801069c8:	e9 0a 01 00 00       	jmp    80106ad7 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801069cd:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801069d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d4:	8b 00                	mov    (%eax),%eax
801069d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801069da:	89 04 24             	mov    %eax,(%esp)
801069dd:	e8 f0 ab ff ff       	call   801015d2 <ialloc>
801069e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801069e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801069e9:	75 0c                	jne    801069f7 <create+0xde>
    panic("create: ialloc");
801069eb:	c7 04 24 c8 96 10 80 	movl   $0x801096c8,(%esp)
801069f2:	e8 43 9b ff ff       	call   8010053a <panic>

  ilock(ip);
801069f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069fa:	89 04 24             	mov    %eax,(%esp)
801069fd:	e8 6b ae ff ff       	call   8010186d <ilock>
  ip->major = major;
80106a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a05:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106a09:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a10:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106a14:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a1b:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a24:	89 04 24             	mov    %eax,(%esp)
80106a27:	e8 85 ac ff ff       	call   801016b1 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106a2c:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106a31:	75 6a                	jne    80106a9d <create+0x184>
    dp->nlink++;  // for ".."
80106a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a36:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106a3a:	8d 50 01             	lea    0x1(%eax),%edx
80106a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a40:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a47:	89 04 24             	mov    %eax,(%esp)
80106a4a:	e8 62 ac ff ff       	call   801016b1 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a52:	8b 40 04             	mov    0x4(%eax),%eax
80106a55:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a59:	c7 44 24 04 a2 96 10 	movl   $0x801096a2,0x4(%esp)
80106a60:	80 
80106a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a64:	89 04 24             	mov    %eax,(%esp)
80106a67:	e8 ec b6 ff ff       	call   80102158 <dirlink>
80106a6c:	85 c0                	test   %eax,%eax
80106a6e:	78 21                	js     80106a91 <create+0x178>
80106a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a73:	8b 40 04             	mov    0x4(%eax),%eax
80106a76:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a7a:	c7 44 24 04 a4 96 10 	movl   $0x801096a4,0x4(%esp)
80106a81:	80 
80106a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a85:	89 04 24             	mov    %eax,(%esp)
80106a88:	e8 cb b6 ff ff       	call   80102158 <dirlink>
80106a8d:	85 c0                	test   %eax,%eax
80106a8f:	79 0c                	jns    80106a9d <create+0x184>
      panic("create dots");
80106a91:	c7 04 24 d7 96 10 80 	movl   $0x801096d7,(%esp)
80106a98:	e8 9d 9a ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106aa0:	8b 40 04             	mov    0x4(%eax),%eax
80106aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
80106aa7:	8d 45 de             	lea    -0x22(%ebp),%eax
80106aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab1:	89 04 24             	mov    %eax,(%esp)
80106ab4:	e8 9f b6 ff ff       	call   80102158 <dirlink>
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	79 0c                	jns    80106ac9 <create+0x1b0>
    panic("create: dirlink");
80106abd:	c7 04 24 e3 96 10 80 	movl   $0x801096e3,(%esp)
80106ac4:	e8 71 9a ff ff       	call   8010053a <panic>

  iunlockput(dp);
80106ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106acc:	89 04 24             	mov    %eax,(%esp)
80106acf:	e8 1d b0 ff ff       	call   80101af1 <iunlockput>

  return ip;
80106ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106ad7:	c9                   	leave  
80106ad8:	c3                   	ret    

80106ad9 <sys_open>:

int
sys_open(void)
{
80106ad9:	55                   	push   %ebp
80106ada:	89 e5                	mov    %esp,%ebp
80106adc:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106adf:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ae6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106aed:	e8 d9 f6 ff ff       	call   801061cb <argstr>
80106af2:	85 c0                	test   %eax,%eax
80106af4:	78 17                	js     80106b0d <sys_open+0x34>
80106af6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106af9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106afd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b04:	e8 32 f6 ff ff       	call   8010613b <argint>
80106b09:	85 c0                	test   %eax,%eax
80106b0b:	79 0a                	jns    80106b17 <sys_open+0x3e>
    return -1;
80106b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b12:	e9 5c 01 00 00       	jmp    80106c73 <sys_open+0x19a>

  begin_op();
80106b17:	e8 06 c9 ff ff       	call   80103422 <begin_op>

  if(omode & O_CREATE){
80106b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b1f:	25 00 02 00 00       	and    $0x200,%eax
80106b24:	85 c0                	test   %eax,%eax
80106b26:	74 3b                	je     80106b63 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b2b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106b32:	00 
80106b33:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106b3a:	00 
80106b3b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106b42:	00 
80106b43:	89 04 24             	mov    %eax,(%esp)
80106b46:	e8 ce fd ff ff       	call   80106919 <create>
80106b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b52:	75 6b                	jne    80106bbf <sys_open+0xe6>
      end_op();
80106b54:	e8 4d c9 ff ff       	call   801034a6 <end_op>
      return -1;
80106b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b5e:	e9 10 01 00 00       	jmp    80106c73 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b66:	89 04 24             	mov    %eax,(%esp)
80106b69:	e8 aa b8 ff ff       	call   80102418 <namei>
80106b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b75:	75 0f                	jne    80106b86 <sys_open+0xad>
      end_op();
80106b77:	e8 2a c9 ff ff       	call   801034a6 <end_op>
      return -1;
80106b7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b81:	e9 ed 00 00 00       	jmp    80106c73 <sys_open+0x19a>
    }
    ilock(ip);
80106b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b89:	89 04 24             	mov    %eax,(%esp)
80106b8c:	e8 dc ac ff ff       	call   8010186d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b94:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b98:	66 83 f8 01          	cmp    $0x1,%ax
80106b9c:	75 21                	jne    80106bbf <sys_open+0xe6>
80106b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ba1:	85 c0                	test   %eax,%eax
80106ba3:	74 1a                	je     80106bbf <sys_open+0xe6>
      iunlockput(ip);
80106ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ba8:	89 04 24             	mov    %eax,(%esp)
80106bab:	e8 41 af ff ff       	call   80101af1 <iunlockput>
      end_op();
80106bb0:	e8 f1 c8 ff ff       	call   801034a6 <end_op>
      return -1;
80106bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bba:	e9 b4 00 00 00       	jmp    80106c73 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106bbf:	e8 74 a3 ff ff       	call   80100f38 <filealloc>
80106bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106bcb:	74 14                	je     80106be1 <sys_open+0x108>
80106bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bd0:	89 04 24             	mov    %eax,(%esp)
80106bd3:	e8 2e f7 ff ff       	call   80106306 <fdalloc>
80106bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106bdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106bdf:	79 28                	jns    80106c09 <sys_open+0x130>
    if(f)
80106be1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106be5:	74 0b                	je     80106bf2 <sys_open+0x119>
      fileclose(f);
80106be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bea:	89 04 24             	mov    %eax,(%esp)
80106bed:	e8 ee a3 ff ff       	call   80100fe0 <fileclose>
    iunlockput(ip);
80106bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf5:	89 04 24             	mov    %eax,(%esp)
80106bf8:	e8 f4 ae ff ff       	call   80101af1 <iunlockput>
    end_op();
80106bfd:	e8 a4 c8 ff ff       	call   801034a6 <end_op>
    return -1;
80106c02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c07:	eb 6a                	jmp    80106c73 <sys_open+0x19a>
  }
  iunlock(ip);
80106c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c0c:	89 04 24             	mov    %eax,(%esp)
80106c0f:	e8 a7 ad ff ff       	call   801019bb <iunlock>
  end_op();
80106c14:	e8 8d c8 ff ff       	call   801034a6 <end_op>

  f->type = FD_INODE;
80106c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c1c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c28:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c2e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c38:	83 e0 01             	and    $0x1,%eax
80106c3b:	85 c0                	test   %eax,%eax
80106c3d:	0f 94 c0             	sete   %al
80106c40:	89 c2                	mov    %eax,%edx
80106c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c45:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c4b:	83 e0 01             	and    $0x1,%eax
80106c4e:	85 c0                	test   %eax,%eax
80106c50:	75 0a                	jne    80106c5c <sys_open+0x183>
80106c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c55:	83 e0 02             	and    $0x2,%eax
80106c58:	85 c0                	test   %eax,%eax
80106c5a:	74 07                	je     80106c63 <sys_open+0x18a>
80106c5c:	b8 01 00 00 00       	mov    $0x1,%eax
80106c61:	eb 05                	jmp    80106c68 <sys_open+0x18f>
80106c63:	b8 00 00 00 00       	mov    $0x0,%eax
80106c68:	89 c2                	mov    %eax,%edx
80106c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c6d:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106c73:	c9                   	leave  
80106c74:	c3                   	ret    

80106c75 <sys_mkdir>:

int
sys_mkdir(void)
{
80106c75:	55                   	push   %ebp
80106c76:	89 e5                	mov    %esp,%ebp
80106c78:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106c7b:	e8 a2 c7 ff ff       	call   80103422 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c83:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c8e:	e8 38 f5 ff ff       	call   801061cb <argstr>
80106c93:	85 c0                	test   %eax,%eax
80106c95:	78 2c                	js     80106cc3 <sys_mkdir+0x4e>
80106c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c9a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106ca1:	00 
80106ca2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106ca9:	00 
80106caa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106cb1:	00 
80106cb2:	89 04 24             	mov    %eax,(%esp)
80106cb5:	e8 5f fc ff ff       	call   80106919 <create>
80106cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cc1:	75 0c                	jne    80106ccf <sys_mkdir+0x5a>
    end_op();
80106cc3:	e8 de c7 ff ff       	call   801034a6 <end_op>
    return -1;
80106cc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ccd:	eb 15                	jmp    80106ce4 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd2:	89 04 24             	mov    %eax,(%esp)
80106cd5:	e8 17 ae ff ff       	call   80101af1 <iunlockput>
  end_op();
80106cda:	e8 c7 c7 ff ff       	call   801034a6 <end_op>
  return 0;
80106cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ce4:	c9                   	leave  
80106ce5:	c3                   	ret    

80106ce6 <sys_mknod>:

int
sys_mknod(void)
{
80106ce6:	55                   	push   %ebp
80106ce7:	89 e5                	mov    %esp,%ebp
80106ce9:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106cec:	e8 31 c7 ff ff       	call   80103422 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106cf1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cff:	e8 c7 f4 ff ff       	call   801061cb <argstr>
80106d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106d0b:	78 5e                	js     80106d6b <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106d0d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106d10:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106d1b:	e8 1b f4 ff ff       	call   8010613b <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106d20:	85 c0                	test   %eax,%eax
80106d22:	78 47                	js     80106d6b <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106d24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106d27:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106d32:	e8 04 f4 ff ff       	call   8010613b <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106d37:	85 c0                	test   %eax,%eax
80106d39:	78 30                	js     80106d6b <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d3e:	0f bf c8             	movswl %ax,%ecx
80106d41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106d44:	0f bf d0             	movswl %ax,%edx
80106d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106d4a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106d4e:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d52:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106d59:	00 
80106d5a:	89 04 24             	mov    %eax,(%esp)
80106d5d:	e8 b7 fb ff ff       	call   80106919 <create>
80106d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d69:	75 0c                	jne    80106d77 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106d6b:	e8 36 c7 ff ff       	call   801034a6 <end_op>
    return -1;
80106d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d75:	eb 15                	jmp    80106d8c <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d7a:	89 04 24             	mov    %eax,(%esp)
80106d7d:	e8 6f ad ff ff       	call   80101af1 <iunlockput>
  end_op();
80106d82:	e8 1f c7 ff ff       	call   801034a6 <end_op>
  return 0;
80106d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d8c:	c9                   	leave  
80106d8d:	c3                   	ret    

80106d8e <sys_chdir>:

int
sys_chdir(void)
{
80106d8e:	55                   	push   %ebp
80106d8f:	89 e5                	mov    %esp,%ebp
80106d91:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106d94:	e8 89 c6 ff ff       	call   80103422 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106d99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106da7:	e8 1f f4 ff ff       	call   801061cb <argstr>
80106dac:	85 c0                	test   %eax,%eax
80106dae:	78 14                	js     80106dc4 <sys_chdir+0x36>
80106db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106db3:	89 04 24             	mov    %eax,(%esp)
80106db6:	e8 5d b6 ff ff       	call   80102418 <namei>
80106dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106dc2:	75 0c                	jne    80106dd0 <sys_chdir+0x42>
    end_op();
80106dc4:	e8 dd c6 ff ff       	call   801034a6 <end_op>
    return -1;
80106dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dce:	eb 61                	jmp    80106e31 <sys_chdir+0xa3>
  }
  ilock(ip);
80106dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dd3:	89 04 24             	mov    %eax,(%esp)
80106dd6:	e8 92 aa ff ff       	call   8010186d <ilock>
  if(ip->type != T_DIR){
80106ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dde:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106de2:	66 83 f8 01          	cmp    $0x1,%ax
80106de6:	74 17                	je     80106dff <sys_chdir+0x71>
    iunlockput(ip);
80106de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106deb:	89 04 24             	mov    %eax,(%esp)
80106dee:	e8 fe ac ff ff       	call   80101af1 <iunlockput>
    end_op();
80106df3:	e8 ae c6 ff ff       	call   801034a6 <end_op>
    return -1;
80106df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dfd:	eb 32                	jmp    80106e31 <sys_chdir+0xa3>
  }
  iunlock(ip);
80106dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e02:	89 04 24             	mov    %eax,(%esp)
80106e05:	e8 b1 ab ff ff       	call   801019bb <iunlock>
  iput(proc->cwd);
80106e0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e10:	8b 40 68             	mov    0x68(%eax),%eax
80106e13:	89 04 24             	mov    %eax,(%esp)
80106e16:	e8 05 ac ff ff       	call   80101a20 <iput>
  end_op();
80106e1b:	e8 86 c6 ff ff       	call   801034a6 <end_op>
  proc->cwd = ip;
80106e20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e29:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e31:	c9                   	leave  
80106e32:	c3                   	ret    

80106e33 <sys_exec>:

int
sys_exec(void)
{
80106e33:	55                   	push   %ebp
80106e34:	89 e5                	mov    %esp,%ebp
80106e36:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106e3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e4a:	e8 7c f3 ff ff       	call   801061cb <argstr>
80106e4f:	85 c0                	test   %eax,%eax
80106e51:	78 1a                	js     80106e6d <sys_exec+0x3a>
80106e53:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106e59:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106e64:	e8 d2 f2 ff ff       	call   8010613b <argint>
80106e69:	85 c0                	test   %eax,%eax
80106e6b:	79 0a                	jns    80106e77 <sys_exec+0x44>
    return -1;
80106e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e72:	e9 c8 00 00 00       	jmp    80106f3f <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106e77:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106e7e:	00 
80106e7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e86:	00 
80106e87:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106e8d:	89 04 24             	mov    %eax,(%esp)
80106e90:	e8 64 ef ff ff       	call   80105df9 <memset>
  for(i=0;; i++){
80106e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e9f:	83 f8 1f             	cmp    $0x1f,%eax
80106ea2:	76 0a                	jbe    80106eae <sys_exec+0x7b>
      return -1;
80106ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ea9:	e9 91 00 00 00       	jmp    80106f3f <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb1:	c1 e0 02             	shl    $0x2,%eax
80106eb4:	89 c2                	mov    %eax,%edx
80106eb6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106ebc:	01 c2                	add    %eax,%edx
80106ebe:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ec8:	89 14 24             	mov    %edx,(%esp)
80106ecb:	e8 cf f1 ff ff       	call   8010609f <fetchint>
80106ed0:	85 c0                	test   %eax,%eax
80106ed2:	79 07                	jns    80106edb <sys_exec+0xa8>
      return -1;
80106ed4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ed9:	eb 64                	jmp    80106f3f <sys_exec+0x10c>
    if(uarg == 0){
80106edb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106ee1:	85 c0                	test   %eax,%eax
80106ee3:	75 26                	jne    80106f0b <sys_exec+0xd8>
      argv[i] = 0;
80106ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee8:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106eef:	00 00 00 00 
      break;
80106ef3:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ef7:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106efd:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f01:	89 04 24             	mov    %eax,(%esp)
80106f04:	e8 eb 9b ff ff       	call   80100af4 <exec>
80106f09:	eb 34                	jmp    80106f3f <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106f0b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106f11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f14:	c1 e2 02             	shl    $0x2,%edx
80106f17:	01 c2                	add    %eax,%edx
80106f19:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106f1f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106f23:	89 04 24             	mov    %eax,(%esp)
80106f26:	e8 ae f1 ff ff       	call   801060d9 <fetchstr>
80106f2b:	85 c0                	test   %eax,%eax
80106f2d:	79 07                	jns    80106f36 <sys_exec+0x103>
      return -1;
80106f2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f34:	eb 09                	jmp    80106f3f <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106f36:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106f3a:	e9 5d ff ff ff       	jmp    80106e9c <sys_exec+0x69>
  return exec(path, argv);
}
80106f3f:	c9                   	leave  
80106f40:	c3                   	ret    

80106f41 <sys_pipe>:

int
sys_pipe(void)
{
80106f41:	55                   	push   %ebp
80106f42:	89 e5                	mov    %esp,%ebp
80106f44:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106f47:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106f4e:	00 
80106f4f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106f52:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f5d:	e8 07 f2 ff ff       	call   80106169 <argptr>
80106f62:	85 c0                	test   %eax,%eax
80106f64:	79 0a                	jns    80106f70 <sys_pipe+0x2f>
    return -1;
80106f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f6b:	e9 9b 00 00 00       	jmp    8010700b <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106f70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106f73:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f77:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106f7a:	89 04 24             	mov    %eax,(%esp)
80106f7d:	e8 b1 cf ff ff       	call   80103f33 <pipealloc>
80106f82:	85 c0                	test   %eax,%eax
80106f84:	79 07                	jns    80106f8d <sys_pipe+0x4c>
    return -1;
80106f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f8b:	eb 7e                	jmp    8010700b <sys_pipe+0xca>
  fd0 = -1;
80106f8d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106f97:	89 04 24             	mov    %eax,(%esp)
80106f9a:	e8 67 f3 ff ff       	call   80106306 <fdalloc>
80106f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fa6:	78 14                	js     80106fbc <sys_pipe+0x7b>
80106fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fab:	89 04 24             	mov    %eax,(%esp)
80106fae:	e8 53 f3 ff ff       	call   80106306 <fdalloc>
80106fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106fb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106fba:	79 37                	jns    80106ff3 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fc0:	78 14                	js     80106fd6 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106fc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106fcb:	83 c2 08             	add    $0x8,%edx
80106fce:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106fd5:	00 
    fileclose(rf);
80106fd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106fd9:	89 04 24             	mov    %eax,(%esp)
80106fdc:	e8 ff 9f ff ff       	call   80100fe0 <fileclose>
    fileclose(wf);
80106fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fe4:	89 04 24             	mov    %eax,(%esp)
80106fe7:	e8 f4 9f ff ff       	call   80100fe0 <fileclose>
    return -1;
80106fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff1:	eb 18                	jmp    8010700b <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ff9:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ffe:	8d 50 04             	lea    0x4(%eax),%edx
80107001:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107004:	89 02                	mov    %eax,(%edx)
  return 0;
80107006:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010700b:	c9                   	leave  
8010700c:	c3                   	ret    

8010700d <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010700d:	55                   	push   %ebp
8010700e:	89 e5                	mov    %esp,%ebp
80107010:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107013:	e8 ba d6 ff ff       	call   801046d2 <fork>
}
80107018:	c9                   	leave  
80107019:	c3                   	ret    

8010701a <sys_exit>:

int
sys_exit(void)
{
8010701a:	55                   	push   %ebp
8010701b:	89 e5                	mov    %esp,%ebp
8010701d:	83 ec 08             	sub    $0x8,%esp
  exit();
80107020:	e8 83 d8 ff ff       	call   801048a8 <exit>
  return 0;  // not reached
80107025:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010702a:	c9                   	leave  
8010702b:	c3                   	ret    

8010702c <sys_wait>:

int
sys_wait(void)
{
8010702c:	55                   	push   %ebp
8010702d:	89 e5                	mov    %esp,%ebp
8010702f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107032:	e8 21 da ff ff       	call   80104a58 <wait>
}
80107037:	c9                   	leave  
80107038:	c3                   	ret    

80107039 <sys_kill>:

int
sys_kill(void)
{
80107039:	55                   	push   %ebp
8010703a:	89 e5                	mov    %esp,%ebp
8010703c:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010703f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107042:	89 44 24 04          	mov    %eax,0x4(%esp)
80107046:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010704d:	e8 e9 f0 ff ff       	call   8010613b <argint>
80107052:	85 c0                	test   %eax,%eax
80107054:	79 07                	jns    8010705d <sys_kill+0x24>
    return -1;
80107056:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010705b:	eb 0b                	jmp    80107068 <sys_kill+0x2f>
  return kill(pid);
8010705d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107060:	89 04 24             	mov    %eax,(%esp)
80107063:	e8 d1 e2 ff ff       	call   80105339 <kill>
}
80107068:	c9                   	leave  
80107069:	c3                   	ret    

8010706a <sys_getpid>:

int
sys_getpid(void)
{
8010706a:	55                   	push   %ebp
8010706b:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010706d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107073:	8b 40 10             	mov    0x10(%eax),%eax
}
80107076:	5d                   	pop    %ebp
80107077:	c3                   	ret    

80107078 <sys_sbrk>:

int
sys_sbrk(void)
{
80107078:	55                   	push   %ebp
80107079:	89 e5                	mov    %esp,%ebp
8010707b:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010707e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107081:	89 44 24 04          	mov    %eax,0x4(%esp)
80107085:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010708c:	e8 aa f0 ff ff       	call   8010613b <argint>
80107091:	85 c0                	test   %eax,%eax
80107093:	79 07                	jns    8010709c <sys_sbrk+0x24>
    return -1;
80107095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010709a:	eb 24                	jmp    801070c0 <sys_sbrk+0x48>
  addr = proc->sz;
8010709c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070a2:	8b 00                	mov    (%eax),%eax
801070a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801070a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070aa:	89 04 24             	mov    %eax,(%esp)
801070ad:	e8 7b d5 ff ff       	call   8010462d <growproc>
801070b2:	85 c0                	test   %eax,%eax
801070b4:	79 07                	jns    801070bd <sys_sbrk+0x45>
    return -1;
801070b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070bb:	eb 03                	jmp    801070c0 <sys_sbrk+0x48>
  return addr;
801070bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801070c0:	c9                   	leave  
801070c1:	c3                   	ret    

801070c2 <sys_sleep>:

int
sys_sleep(void)
{
801070c2:	55                   	push   %ebp
801070c3:	89 e5                	mov    %esp,%ebp
801070c5:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801070c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801070cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801070d6:	e8 60 f0 ff ff       	call   8010613b <argint>
801070db:	85 c0                	test   %eax,%eax
801070dd:	79 07                	jns    801070e6 <sys_sleep+0x24>
    return -1;
801070df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e4:	eb 6c                	jmp    80107152 <sys_sleep+0x90>
  acquire(&tickslock);
801070e6:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
801070ed:	e8 b3 ea ff ff       	call   80105ba5 <acquire>
  ticks0 = ticks;
801070f2:	a1 20 a0 11 80       	mov    0x8011a020,%eax
801070f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801070fa:	eb 34                	jmp    80107130 <sys_sleep+0x6e>
    if(proc->killed){
801070fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107102:	8b 40 24             	mov    0x24(%eax),%eax
80107105:	85 c0                	test   %eax,%eax
80107107:	74 13                	je     8010711c <sys_sleep+0x5a>
      release(&tickslock);
80107109:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
80107110:	e8 f2 ea ff ff       	call   80105c07 <release>
      return -1;
80107115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010711a:	eb 36                	jmp    80107152 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010711c:	c7 44 24 04 e0 97 11 	movl   $0x801197e0,0x4(%esp)
80107123:	80 
80107124:	c7 04 24 20 a0 11 80 	movl   $0x8011a020,(%esp)
8010712b:	e8 a9 df ff ff       	call   801050d9 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107130:	a1 20 a0 11 80       	mov    0x8011a020,%eax
80107135:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107138:	89 c2                	mov    %eax,%edx
8010713a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010713d:	39 c2                	cmp    %eax,%edx
8010713f:	72 bb                	jb     801070fc <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80107141:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
80107148:	e8 ba ea ff ff       	call   80105c07 <release>
  return 0;
8010714d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107152:	c9                   	leave  
80107153:	c3                   	ret    

80107154 <sys_sigset>:

// SIGNAL SYSTEM CALLS
int 
sys_sigset(void)
{
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	83 ec 28             	sub    $0x28,%esp
  sig_handler handler;

  if(argptr(0, (char**) &handler, sizeof(handler)) < 0)
8010715a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80107161:	00 
80107162:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107165:	89 44 24 04          	mov    %eax,0x4(%esp)
80107169:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107170:	e8 f4 ef ff ff       	call   80106169 <argptr>
80107175:	85 c0                	test   %eax,%eax
80107177:	79 07                	jns    80107180 <sys_sigset+0x2c>
    return 0; // Error I suppose.
80107179:	b8 00 00 00 00       	mov    $0x0,%eax
8010717e:	eb 0b                	jmp    8010718b <sys_sigset+0x37>
  return (int) (sigset(handler));
80107180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107183:	89 04 24             	mov    %eax,(%esp)
80107186:	e8 fc e3 ff ff       	call   80105587 <sigset>
}
8010718b:	c9                   	leave  
8010718c:	c3                   	ret    

8010718d <sys_sigsend>:

int
sys_sigsend(void)
{ 
8010718d:	55                   	push   %ebp
8010718e:	89 e5                	mov    %esp,%ebp
80107190:	83 ec 28             	sub    $0x28,%esp
  int dest_pid, value;
  if(argint(0, &dest_pid) < 0 ||
80107193:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107196:	89 44 24 04          	mov    %eax,0x4(%esp)
8010719a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801071a1:	e8 95 ef ff ff       	call   8010613b <argint>
801071a6:	85 c0                	test   %eax,%eax
801071a8:	78 17                	js     801071c1 <sys_sigsend+0x34>
      argint(1, &value) < 0 )
801071aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801071b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801071b8:	e8 7e ef ff ff       	call   8010613b <argint>

int
sys_sigsend(void)
{ 
  int dest_pid, value;
  if(argint(0, &dest_pid) < 0 ||
801071bd:	85 c0                	test   %eax,%eax
801071bf:	79 07                	jns    801071c8 <sys_sigsend+0x3b>
      argint(1, &value) < 0 )
    return 0; // Error I suppose.
801071c1:	b8 00 00 00 00       	mov    $0x0,%eax
801071c6:	eb 12                	jmp    801071da <sys_sigsend+0x4d>

  return sigsend(dest_pid, value);
801071c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801071d2:	89 04 24             	mov    %eax,(%esp)
801071d5:	e8 d0 e3 ff ff       	call   801055aa <sigsend>
}
801071da:	c9                   	leave  
801071db:	c3                   	ret    

801071dc <sys_sigret>:

int 
sys_sigret(void)
{
801071dc:	55                   	push   %ebp
801071dd:	89 e5                	mov    %esp,%ebp
801071df:	83 ec 08             	sub    $0x8,%esp
  sigret();
801071e2:	e8 a7 e5 ff ff       	call   8010578e <sigret>
  return 0;
801071e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801071ec:	c9                   	leave  
801071ed:	c3                   	ret    

801071ee <sys_sigpause>:

int 
sys_sigpause(void)
{
801071ee:	55                   	push   %ebp
801071ef:	89 e5                	mov    %esp,%ebp
801071f1:	83 ec 08             	sub    $0x8,%esp
  return sigpause();
801071f4:	e8 24 e4 ff ff       	call   8010561d <sigpause>
}
801071f9:	c9                   	leave  
801071fa:	c3                   	ret    

801071fb <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801071fb:	55                   	push   %ebp
801071fc:	89 e5                	mov    %esp,%ebp
801071fe:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80107201:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
80107208:	e8 98 e9 ff ff       	call   80105ba5 <acquire>
  xticks = ticks;
8010720d:	a1 20 a0 11 80       	mov    0x8011a020,%eax
80107212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80107215:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
8010721c:	e8 e6 e9 ff ff       	call   80105c07 <release>
  return xticks;
80107221:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107224:	c9                   	leave  
80107225:	c3                   	ret    

80107226 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107226:	55                   	push   %ebp
80107227:	89 e5                	mov    %esp,%ebp
80107229:	83 ec 08             	sub    $0x8,%esp
8010722c:	8b 55 08             	mov    0x8(%ebp),%edx
8010722f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107232:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107236:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107239:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010723d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107241:	ee                   	out    %al,(%dx)
}
80107242:	c9                   	leave  
80107243:	c3                   	ret    

80107244 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010724a:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80107251:	00 
80107252:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80107259:	e8 c8 ff ff ff       	call   80107226 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010725e:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80107265:	00 
80107266:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010726d:	e8 b4 ff ff ff       	call   80107226 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80107272:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80107279:	00 
8010727a:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80107281:	e8 a0 ff ff ff       	call   80107226 <outb>
  picenable(IRQ_TIMER);
80107286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010728d:	e8 34 cb ff ff       	call   80103dc6 <picenable>
}
80107292:	c9                   	leave  
80107293:	c3                   	ret    

80107294 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107294:	1e                   	push   %ds
  pushl %es
80107295:	06                   	push   %es
  pushl %fs
80107296:	0f a0                	push   %fs
  pushl %gs
80107298:	0f a8                	push   %gs
  pushal
8010729a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010729b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010729f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801072a1:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801072a3:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801072a7:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801072a9:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801072ab:	54                   	push   %esp
  call trap
801072ac:	e8 e7 01 00 00       	call   80107498 <trap>
  addl $4, %esp
801072b1:	83 c4 04             	add    $0x4,%esp

801072b4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  # Maybe we can call a cool function here that checks the stuff?
  pushal # so we dont mess with the contents of the registers, bro. 
801072b4:	60                   	pusha  
  call handle_signals
801072b5:	e8 c9 e5 ff ff       	call   80105883 <handle_signals>
  popal
801072ba:	61                   	popa   
  popal
801072bb:	61                   	popa   
  popl %gs
801072bc:	0f a9                	pop    %gs
  popl %fs
801072be:	0f a1                	pop    %fs
  popl %es
801072c0:	07                   	pop    %es
  popl %ds
801072c1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801072c2:	83 c4 08             	add    $0x8,%esp
  iret
801072c5:	cf                   	iret   

801072c6 <sigret_label_start>:

.globl sigret_label_start
sigret_label_start:
  movl $SYS_sigret, %eax;
801072c6:	b8 18 00 00 00       	mov    $0x18,%eax
  int $T_SYSCALL;
801072cb:	cd 40                	int    $0x40
  ret;
801072cd:	c3                   	ret    

801072ce <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801072ce:	55                   	push   %ebp
801072cf:	89 e5                	mov    %esp,%ebp
801072d1:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801072d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801072d7:	83 e8 01             	sub    $0x1,%eax
801072da:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801072de:	8b 45 08             	mov    0x8(%ebp),%eax
801072e1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801072e5:	8b 45 08             	mov    0x8(%ebp),%eax
801072e8:	c1 e8 10             	shr    $0x10,%eax
801072eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801072ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801072f2:	0f 01 18             	lidtl  (%eax)
}
801072f5:	c9                   	leave  
801072f6:	c3                   	ret    

801072f7 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801072f7:	55                   	push   %ebp
801072f8:	89 e5                	mov    %esp,%ebp
801072fa:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801072fd:	0f 20 d0             	mov    %cr2,%eax
80107300:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107303:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107306:	c9                   	leave  
80107307:	c3                   	ret    

80107308 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107308:	55                   	push   %ebp
80107309:	89 e5                	mov    %esp,%ebp
8010730b:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010730e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107315:	e9 c3 00 00 00       	jmp    801073dd <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010731a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731d:	8b 04 85 08 c1 10 80 	mov    -0x7fef3ef8(,%eax,4),%eax
80107324:	89 c2                	mov    %eax,%edx
80107326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107329:	66 89 14 c5 20 98 11 	mov    %dx,-0x7fee67e0(,%eax,8)
80107330:	80 
80107331:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107334:	66 c7 04 c5 22 98 11 	movw   $0x8,-0x7fee67de(,%eax,8)
8010733b:	80 08 00 
8010733e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107341:	0f b6 14 c5 24 98 11 	movzbl -0x7fee67dc(,%eax,8),%edx
80107348:	80 
80107349:	83 e2 e0             	and    $0xffffffe0,%edx
8010734c:	88 14 c5 24 98 11 80 	mov    %dl,-0x7fee67dc(,%eax,8)
80107353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107356:	0f b6 14 c5 24 98 11 	movzbl -0x7fee67dc(,%eax,8),%edx
8010735d:	80 
8010735e:	83 e2 1f             	and    $0x1f,%edx
80107361:	88 14 c5 24 98 11 80 	mov    %dl,-0x7fee67dc(,%eax,8)
80107368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736b:	0f b6 14 c5 25 98 11 	movzbl -0x7fee67db(,%eax,8),%edx
80107372:	80 
80107373:	83 e2 f0             	and    $0xfffffff0,%edx
80107376:	83 ca 0e             	or     $0xe,%edx
80107379:	88 14 c5 25 98 11 80 	mov    %dl,-0x7fee67db(,%eax,8)
80107380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107383:	0f b6 14 c5 25 98 11 	movzbl -0x7fee67db(,%eax,8),%edx
8010738a:	80 
8010738b:	83 e2 ef             	and    $0xffffffef,%edx
8010738e:	88 14 c5 25 98 11 80 	mov    %dl,-0x7fee67db(,%eax,8)
80107395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107398:	0f b6 14 c5 25 98 11 	movzbl -0x7fee67db(,%eax,8),%edx
8010739f:	80 
801073a0:	83 e2 9f             	and    $0xffffff9f,%edx
801073a3:	88 14 c5 25 98 11 80 	mov    %dl,-0x7fee67db(,%eax,8)
801073aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ad:	0f b6 14 c5 25 98 11 	movzbl -0x7fee67db(,%eax,8),%edx
801073b4:	80 
801073b5:	83 ca 80             	or     $0xffffff80,%edx
801073b8:	88 14 c5 25 98 11 80 	mov    %dl,-0x7fee67db(,%eax,8)
801073bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c2:	8b 04 85 08 c1 10 80 	mov    -0x7fef3ef8(,%eax,4),%eax
801073c9:	c1 e8 10             	shr    $0x10,%eax
801073cc:	89 c2                	mov    %eax,%edx
801073ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d1:	66 89 14 c5 26 98 11 	mov    %dx,-0x7fee67da(,%eax,8)
801073d8:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801073d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801073dd:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801073e4:	0f 8e 30 ff ff ff    	jle    8010731a <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801073ea:	a1 08 c2 10 80       	mov    0x8010c208,%eax
801073ef:	66 a3 20 9a 11 80    	mov    %ax,0x80119a20
801073f5:	66 c7 05 22 9a 11 80 	movw   $0x8,0x80119a22
801073fc:	08 00 
801073fe:	0f b6 05 24 9a 11 80 	movzbl 0x80119a24,%eax
80107405:	83 e0 e0             	and    $0xffffffe0,%eax
80107408:	a2 24 9a 11 80       	mov    %al,0x80119a24
8010740d:	0f b6 05 24 9a 11 80 	movzbl 0x80119a24,%eax
80107414:	83 e0 1f             	and    $0x1f,%eax
80107417:	a2 24 9a 11 80       	mov    %al,0x80119a24
8010741c:	0f b6 05 25 9a 11 80 	movzbl 0x80119a25,%eax
80107423:	83 c8 0f             	or     $0xf,%eax
80107426:	a2 25 9a 11 80       	mov    %al,0x80119a25
8010742b:	0f b6 05 25 9a 11 80 	movzbl 0x80119a25,%eax
80107432:	83 e0 ef             	and    $0xffffffef,%eax
80107435:	a2 25 9a 11 80       	mov    %al,0x80119a25
8010743a:	0f b6 05 25 9a 11 80 	movzbl 0x80119a25,%eax
80107441:	83 c8 60             	or     $0x60,%eax
80107444:	a2 25 9a 11 80       	mov    %al,0x80119a25
80107449:	0f b6 05 25 9a 11 80 	movzbl 0x80119a25,%eax
80107450:	83 c8 80             	or     $0xffffff80,%eax
80107453:	a2 25 9a 11 80       	mov    %al,0x80119a25
80107458:	a1 08 c2 10 80       	mov    0x8010c208,%eax
8010745d:	c1 e8 10             	shr    $0x10,%eax
80107460:	66 a3 26 9a 11 80    	mov    %ax,0x80119a26
  
  initlock(&tickslock, "time");
80107466:	c7 44 24 04 f4 96 10 	movl   $0x801096f4,0x4(%esp)
8010746d:	80 
8010746e:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
80107475:	e8 0a e7 ff ff       	call   80105b84 <initlock>
}
8010747a:	c9                   	leave  
8010747b:	c3                   	ret    

8010747c <idtinit>:

void
idtinit(void)
{
8010747c:	55                   	push   %ebp
8010747d:	89 e5                	mov    %esp,%ebp
8010747f:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80107482:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80107489:	00 
8010748a:	c7 04 24 20 98 11 80 	movl   $0x80119820,(%esp)
80107491:	e8 38 fe ff ff       	call   801072ce <lidt>
}
80107496:	c9                   	leave  
80107497:	c3                   	ret    

80107498 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107498:	55                   	push   %ebp
80107499:	89 e5                	mov    %esp,%ebp
8010749b:	57                   	push   %edi
8010749c:	56                   	push   %esi
8010749d:	53                   	push   %ebx
8010749e:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801074a1:	8b 45 08             	mov    0x8(%ebp),%eax
801074a4:	8b 40 30             	mov    0x30(%eax),%eax
801074a7:	83 f8 40             	cmp    $0x40,%eax
801074aa:	75 3f                	jne    801074eb <trap+0x53>
    if(proc->killed){
801074ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074b2:	8b 40 24             	mov    0x24(%eax),%eax
801074b5:	85 c0                	test   %eax,%eax
801074b7:	74 05                	je     801074be <trap+0x26>
      exit();
801074b9:	e8 ea d3 ff ff       	call   801048a8 <exit>
    }
    proc->tf = tf;
801074be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074c4:	8b 55 08             	mov    0x8(%ebp),%edx
801074c7:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801074ca:	e8 33 ed ff ff       	call   80106202 <syscall>
    if(proc->killed)
801074cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074d5:	8b 40 24             	mov    0x24(%eax),%eax
801074d8:	85 c0                	test   %eax,%eax
801074da:	74 0a                	je     801074e6 <trap+0x4e>
      exit();
801074dc:	e8 c7 d3 ff ff       	call   801048a8 <exit>
    return;
801074e1:	e9 2d 02 00 00       	jmp    80107713 <trap+0x27b>
801074e6:	e9 28 02 00 00       	jmp    80107713 <trap+0x27b>
  }

  switch(tf->trapno){
801074eb:	8b 45 08             	mov    0x8(%ebp),%eax
801074ee:	8b 40 30             	mov    0x30(%eax),%eax
801074f1:	83 e8 20             	sub    $0x20,%eax
801074f4:	83 f8 1f             	cmp    $0x1f,%eax
801074f7:	0f 87 bc 00 00 00    	ja     801075b9 <trap+0x121>
801074fd:	8b 04 85 9c 97 10 80 	mov    -0x7fef6864(,%eax,4),%eax
80107504:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80107506:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010750c:	0f b6 00             	movzbl (%eax),%eax
8010750f:	84 c0                	test   %al,%al
80107511:	75 31                	jne    80107544 <trap+0xac>
      acquire(&tickslock);
80107513:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
8010751a:	e8 86 e6 ff ff       	call   80105ba5 <acquire>
      ticks++;
8010751f:	a1 20 a0 11 80       	mov    0x8011a020,%eax
80107524:	83 c0 01             	add    $0x1,%eax
80107527:	a3 20 a0 11 80       	mov    %eax,0x8011a020
      wakeup(&ticks);
8010752c:	c7 04 24 20 a0 11 80 	movl   $0x8011a020,(%esp)
80107533:	e8 e4 dd ff ff       	call   8010531c <wakeup>
      release(&tickslock);
80107538:	c7 04 24 e0 97 11 80 	movl   $0x801197e0,(%esp)
8010753f:	e8 c3 e6 ff ff       	call   80105c07 <release>
    }
    lapiceoi();
80107544:	e8 99 b9 ff ff       	call   80102ee2 <lapiceoi>
    break;
80107549:	e9 41 01 00 00       	jmp    8010768f <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010754e:	e8 9d b1 ff ff       	call   801026f0 <ideintr>
    lapiceoi();
80107553:	e8 8a b9 ff ff       	call   80102ee2 <lapiceoi>
    break;
80107558:	e9 32 01 00 00       	jmp    8010768f <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010755d:	e8 4f b7 ff ff       	call   80102cb1 <kbdintr>
    lapiceoi();
80107562:	e8 7b b9 ff ff       	call   80102ee2 <lapiceoi>
    break;
80107567:	e9 23 01 00 00       	jmp    8010768f <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010756c:	e8 97 03 00 00       	call   80107908 <uartintr>
    lapiceoi();
80107571:	e8 6c b9 ff ff       	call   80102ee2 <lapiceoi>
    break;
80107576:	e9 14 01 00 00       	jmp    8010768f <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010757b:	8b 45 08             	mov    0x8(%ebp),%eax
8010757e:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107581:	8b 45 08             	mov    0x8(%ebp),%eax
80107584:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107588:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010758b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107591:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107594:	0f b6 c0             	movzbl %al,%eax
80107597:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010759b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010759f:	89 44 24 04          	mov    %eax,0x4(%esp)
801075a3:	c7 04 24 fc 96 10 80 	movl   $0x801096fc,(%esp)
801075aa:	e8 f1 8d ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801075af:	e8 2e b9 ff ff       	call   80102ee2 <lapiceoi>
    break;
801075b4:	e9 d6 00 00 00       	jmp    8010768f <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801075b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801075bf:	85 c0                	test   %eax,%eax
801075c1:	74 11                	je     801075d4 <trap+0x13c>
801075c3:	8b 45 08             	mov    0x8(%ebp),%eax
801075c6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801075ca:	0f b7 c0             	movzwl %ax,%eax
801075cd:	83 e0 03             	and    $0x3,%eax
801075d0:	85 c0                	test   %eax,%eax
801075d2:	75 46                	jne    8010761a <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801075d4:	e8 1e fd ff ff       	call   801072f7 <rcr2>
801075d9:	8b 55 08             	mov    0x8(%ebp),%edx
801075dc:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801075df:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801075e6:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801075e9:	0f b6 ca             	movzbl %dl,%ecx
801075ec:	8b 55 08             	mov    0x8(%ebp),%edx
801075ef:	8b 52 30             	mov    0x30(%edx),%edx
801075f2:	89 44 24 10          	mov    %eax,0x10(%esp)
801075f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801075fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801075fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80107602:	c7 04 24 20 97 10 80 	movl   $0x80109720,(%esp)
80107609:	e8 92 8d ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010760e:	c7 04 24 52 97 10 80 	movl   $0x80109752,(%esp)
80107615:	e8 20 8f ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010761a:	e8 d8 fc ff ff       	call   801072f7 <rcr2>
8010761f:	89 c2                	mov    %eax,%edx
80107621:	8b 45 08             	mov    0x8(%ebp),%eax
80107624:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107627:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010762d:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107630:	0f b6 f0             	movzbl %al,%esi
80107633:	8b 45 08             	mov    0x8(%ebp),%eax
80107636:	8b 58 34             	mov    0x34(%eax),%ebx
80107639:	8b 45 08             	mov    0x8(%ebp),%eax
8010763c:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010763f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107645:	83 c0 6c             	add    $0x6c,%eax
80107648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010764b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107651:	8b 40 10             	mov    0x10(%eax),%eax
80107654:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107658:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010765c:	89 74 24 14          	mov    %esi,0x14(%esp)
80107660:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107664:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010766b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010766f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107673:	c7 04 24 58 97 10 80 	movl   $0x80109758,(%esp)
8010767a:	e8 21 8d ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010767f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107685:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010768c:	eb 01                	jmp    8010768f <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010768e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010768f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107695:	85 c0                	test   %eax,%eax
80107697:	74 24                	je     801076bd <trap+0x225>
80107699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010769f:	8b 40 24             	mov    0x24(%eax),%eax
801076a2:	85 c0                	test   %eax,%eax
801076a4:	74 17                	je     801076bd <trap+0x225>
801076a6:	8b 45 08             	mov    0x8(%ebp),%eax
801076a9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801076ad:	0f b7 c0             	movzwl %ax,%eax
801076b0:	83 e0 03             	and    $0x3,%eax
801076b3:	83 f8 03             	cmp    $0x3,%eax
801076b6:	75 05                	jne    801076bd <trap+0x225>
    exit();
801076b8:	e8 eb d1 ff ff       	call   801048a8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801076bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076c3:	85 c0                	test   %eax,%eax
801076c5:	74 1e                	je     801076e5 <trap+0x24d>
801076c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076cd:	8b 40 0c             	mov    0xc(%eax),%eax
801076d0:	83 f8 04             	cmp    $0x4,%eax
801076d3:	75 10                	jne    801076e5 <trap+0x24d>
801076d5:	8b 45 08             	mov    0x8(%ebp),%eax
801076d8:	8b 40 30             	mov    0x30(%eax),%eax
801076db:	83 f8 20             	cmp    $0x20,%eax
801076de:	75 05                	jne    801076e5 <trap+0x24d>
    yield();
801076e0:	e8 25 d9 ff ff       	call   8010500a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801076e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076eb:	85 c0                	test   %eax,%eax
801076ed:	74 24                	je     80107713 <trap+0x27b>
801076ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076f5:	8b 40 24             	mov    0x24(%eax),%eax
801076f8:	85 c0                	test   %eax,%eax
801076fa:	74 17                	je     80107713 <trap+0x27b>
801076fc:	8b 45 08             	mov    0x8(%ebp),%eax
801076ff:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107703:	0f b7 c0             	movzwl %ax,%eax
80107706:	83 e0 03             	and    $0x3,%eax
80107709:	83 f8 03             	cmp    $0x3,%eax
8010770c:	75 05                	jne    80107713 <trap+0x27b>
    exit();
8010770e:	e8 95 d1 ff ff       	call   801048a8 <exit>
}
80107713:	83 c4 3c             	add    $0x3c,%esp
80107716:	5b                   	pop    %ebx
80107717:	5e                   	pop    %esi
80107718:	5f                   	pop    %edi
80107719:	5d                   	pop    %ebp
8010771a:	c3                   	ret    

8010771b <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010771b:	55                   	push   %ebp
8010771c:	89 e5                	mov    %esp,%ebp
8010771e:	83 ec 14             	sub    $0x14,%esp
80107721:	8b 45 08             	mov    0x8(%ebp),%eax
80107724:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107728:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010772c:	89 c2                	mov    %eax,%edx
8010772e:	ec                   	in     (%dx),%al
8010772f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107732:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107736:	c9                   	leave  
80107737:	c3                   	ret    

80107738 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107738:	55                   	push   %ebp
80107739:	89 e5                	mov    %esp,%ebp
8010773b:	83 ec 08             	sub    $0x8,%esp
8010773e:	8b 55 08             	mov    0x8(%ebp),%edx
80107741:	8b 45 0c             	mov    0xc(%ebp),%eax
80107744:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107748:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010774b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010774f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107753:	ee                   	out    %al,(%dx)
}
80107754:	c9                   	leave  
80107755:	c3                   	ret    

80107756 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107756:	55                   	push   %ebp
80107757:	89 e5                	mov    %esp,%ebp
80107759:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010775c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107763:	00 
80107764:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010776b:	e8 c8 ff ff ff       	call   80107738 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107770:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107777:	00 
80107778:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010777f:	e8 b4 ff ff ff       	call   80107738 <outb>
  outb(COM1+0, 115200/9600);
80107784:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010778b:	00 
8010778c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107793:	e8 a0 ff ff ff       	call   80107738 <outb>
  outb(COM1+1, 0);
80107798:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010779f:	00 
801077a0:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801077a7:	e8 8c ff ff ff       	call   80107738 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801077ac:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801077b3:	00 
801077b4:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801077bb:	e8 78 ff ff ff       	call   80107738 <outb>
  outb(COM1+4, 0);
801077c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801077c7:	00 
801077c8:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801077cf:	e8 64 ff ff ff       	call   80107738 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801077d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801077db:	00 
801077dc:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801077e3:	e8 50 ff ff ff       	call   80107738 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801077e8:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801077ef:	e8 27 ff ff ff       	call   8010771b <inb>
801077f4:	3c ff                	cmp    $0xff,%al
801077f6:	75 02                	jne    801077fa <uartinit+0xa4>
    return;
801077f8:	eb 6a                	jmp    80107864 <uartinit+0x10e>
  uart = 1;
801077fa:	c7 05 cc c6 10 80 01 	movl   $0x1,0x8010c6cc
80107801:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107804:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010780b:	e8 0b ff ff ff       	call   8010771b <inb>
  inb(COM1+0);
80107810:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107817:	e8 ff fe ff ff       	call   8010771b <inb>
  picenable(IRQ_COM1);
8010781c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107823:	e8 9e c5 ff ff       	call   80103dc6 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107828:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010782f:	00 
80107830:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107837:	e8 33 b1 ff ff       	call   8010296f <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010783c:	c7 45 f4 1c 98 10 80 	movl   $0x8010981c,-0xc(%ebp)
80107843:	eb 15                	jmp    8010785a <uartinit+0x104>
    uartputc(*p);
80107845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107848:	0f b6 00             	movzbl (%eax),%eax
8010784b:	0f be c0             	movsbl %al,%eax
8010784e:	89 04 24             	mov    %eax,(%esp)
80107851:	e8 10 00 00 00       	call   80107866 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107856:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010785a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785d:	0f b6 00             	movzbl (%eax),%eax
80107860:	84 c0                	test   %al,%al
80107862:	75 e1                	jne    80107845 <uartinit+0xef>
    uartputc(*p);
}
80107864:	c9                   	leave  
80107865:	c3                   	ret    

80107866 <uartputc>:

void
uartputc(int c)
{
80107866:	55                   	push   %ebp
80107867:	89 e5                	mov    %esp,%ebp
80107869:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010786c:	a1 cc c6 10 80       	mov    0x8010c6cc,%eax
80107871:	85 c0                	test   %eax,%eax
80107873:	75 02                	jne    80107877 <uartputc+0x11>
    return;
80107875:	eb 4b                	jmp    801078c2 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107877:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010787e:	eb 10                	jmp    80107890 <uartputc+0x2a>
    microdelay(10);
80107880:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107887:	e8 7b b6 ff ff       	call   80102f07 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010788c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107890:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107894:	7f 16                	jg     801078ac <uartputc+0x46>
80107896:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010789d:	e8 79 fe ff ff       	call   8010771b <inb>
801078a2:	0f b6 c0             	movzbl %al,%eax
801078a5:	83 e0 20             	and    $0x20,%eax
801078a8:	85 c0                	test   %eax,%eax
801078aa:	74 d4                	je     80107880 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801078ac:	8b 45 08             	mov    0x8(%ebp),%eax
801078af:	0f b6 c0             	movzbl %al,%eax
801078b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801078b6:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801078bd:	e8 76 fe ff ff       	call   80107738 <outb>
}
801078c2:	c9                   	leave  
801078c3:	c3                   	ret    

801078c4 <uartgetc>:

static int
uartgetc(void)
{
801078c4:	55                   	push   %ebp
801078c5:	89 e5                	mov    %esp,%ebp
801078c7:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801078ca:	a1 cc c6 10 80       	mov    0x8010c6cc,%eax
801078cf:	85 c0                	test   %eax,%eax
801078d1:	75 07                	jne    801078da <uartgetc+0x16>
    return -1;
801078d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078d8:	eb 2c                	jmp    80107906 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801078da:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801078e1:	e8 35 fe ff ff       	call   8010771b <inb>
801078e6:	0f b6 c0             	movzbl %al,%eax
801078e9:	83 e0 01             	and    $0x1,%eax
801078ec:	85 c0                	test   %eax,%eax
801078ee:	75 07                	jne    801078f7 <uartgetc+0x33>
    return -1;
801078f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078f5:	eb 0f                	jmp    80107906 <uartgetc+0x42>
  return inb(COM1+0);
801078f7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801078fe:	e8 18 fe ff ff       	call   8010771b <inb>
80107903:	0f b6 c0             	movzbl %al,%eax
}
80107906:	c9                   	leave  
80107907:	c3                   	ret    

80107908 <uartintr>:

void
uartintr(void)
{
80107908:	55                   	push   %ebp
80107909:	89 e5                	mov    %esp,%ebp
8010790b:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010790e:	c7 04 24 c4 78 10 80 	movl   $0x801078c4,(%esp)
80107915:	e8 98 8e ff ff       	call   801007b2 <consoleintr>
}
8010791a:	c9                   	leave  
8010791b:	c3                   	ret    

8010791c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $0
8010791e:	6a 00                	push   $0x0
  jmp alltraps
80107920:	e9 6f f9 ff ff       	jmp    80107294 <alltraps>

80107925 <vector1>:
.globl vector1
vector1:
  pushl $0
80107925:	6a 00                	push   $0x0
  pushl $1
80107927:	6a 01                	push   $0x1
  jmp alltraps
80107929:	e9 66 f9 ff ff       	jmp    80107294 <alltraps>

8010792e <vector2>:
.globl vector2
vector2:
  pushl $0
8010792e:	6a 00                	push   $0x0
  pushl $2
80107930:	6a 02                	push   $0x2
  jmp alltraps
80107932:	e9 5d f9 ff ff       	jmp    80107294 <alltraps>

80107937 <vector3>:
.globl vector3
vector3:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $3
80107939:	6a 03                	push   $0x3
  jmp alltraps
8010793b:	e9 54 f9 ff ff       	jmp    80107294 <alltraps>

80107940 <vector4>:
.globl vector4
vector4:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $4
80107942:	6a 04                	push   $0x4
  jmp alltraps
80107944:	e9 4b f9 ff ff       	jmp    80107294 <alltraps>

80107949 <vector5>:
.globl vector5
vector5:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $5
8010794b:	6a 05                	push   $0x5
  jmp alltraps
8010794d:	e9 42 f9 ff ff       	jmp    80107294 <alltraps>

80107952 <vector6>:
.globl vector6
vector6:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $6
80107954:	6a 06                	push   $0x6
  jmp alltraps
80107956:	e9 39 f9 ff ff       	jmp    80107294 <alltraps>

8010795b <vector7>:
.globl vector7
vector7:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $7
8010795d:	6a 07                	push   $0x7
  jmp alltraps
8010795f:	e9 30 f9 ff ff       	jmp    80107294 <alltraps>

80107964 <vector8>:
.globl vector8
vector8:
  pushl $8
80107964:	6a 08                	push   $0x8
  jmp alltraps
80107966:	e9 29 f9 ff ff       	jmp    80107294 <alltraps>

8010796b <vector9>:
.globl vector9
vector9:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $9
8010796d:	6a 09                	push   $0x9
  jmp alltraps
8010796f:	e9 20 f9 ff ff       	jmp    80107294 <alltraps>

80107974 <vector10>:
.globl vector10
vector10:
  pushl $10
80107974:	6a 0a                	push   $0xa
  jmp alltraps
80107976:	e9 19 f9 ff ff       	jmp    80107294 <alltraps>

8010797b <vector11>:
.globl vector11
vector11:
  pushl $11
8010797b:	6a 0b                	push   $0xb
  jmp alltraps
8010797d:	e9 12 f9 ff ff       	jmp    80107294 <alltraps>

80107982 <vector12>:
.globl vector12
vector12:
  pushl $12
80107982:	6a 0c                	push   $0xc
  jmp alltraps
80107984:	e9 0b f9 ff ff       	jmp    80107294 <alltraps>

80107989 <vector13>:
.globl vector13
vector13:
  pushl $13
80107989:	6a 0d                	push   $0xd
  jmp alltraps
8010798b:	e9 04 f9 ff ff       	jmp    80107294 <alltraps>

80107990 <vector14>:
.globl vector14
vector14:
  pushl $14
80107990:	6a 0e                	push   $0xe
  jmp alltraps
80107992:	e9 fd f8 ff ff       	jmp    80107294 <alltraps>

80107997 <vector15>:
.globl vector15
vector15:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $15
80107999:	6a 0f                	push   $0xf
  jmp alltraps
8010799b:	e9 f4 f8 ff ff       	jmp    80107294 <alltraps>

801079a0 <vector16>:
.globl vector16
vector16:
  pushl $0
801079a0:	6a 00                	push   $0x0
  pushl $16
801079a2:	6a 10                	push   $0x10
  jmp alltraps
801079a4:	e9 eb f8 ff ff       	jmp    80107294 <alltraps>

801079a9 <vector17>:
.globl vector17
vector17:
  pushl $17
801079a9:	6a 11                	push   $0x11
  jmp alltraps
801079ab:	e9 e4 f8 ff ff       	jmp    80107294 <alltraps>

801079b0 <vector18>:
.globl vector18
vector18:
  pushl $0
801079b0:	6a 00                	push   $0x0
  pushl $18
801079b2:	6a 12                	push   $0x12
  jmp alltraps
801079b4:	e9 db f8 ff ff       	jmp    80107294 <alltraps>

801079b9 <vector19>:
.globl vector19
vector19:
  pushl $0
801079b9:	6a 00                	push   $0x0
  pushl $19
801079bb:	6a 13                	push   $0x13
  jmp alltraps
801079bd:	e9 d2 f8 ff ff       	jmp    80107294 <alltraps>

801079c2 <vector20>:
.globl vector20
vector20:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $20
801079c4:	6a 14                	push   $0x14
  jmp alltraps
801079c6:	e9 c9 f8 ff ff       	jmp    80107294 <alltraps>

801079cb <vector21>:
.globl vector21
vector21:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $21
801079cd:	6a 15                	push   $0x15
  jmp alltraps
801079cf:	e9 c0 f8 ff ff       	jmp    80107294 <alltraps>

801079d4 <vector22>:
.globl vector22
vector22:
  pushl $0
801079d4:	6a 00                	push   $0x0
  pushl $22
801079d6:	6a 16                	push   $0x16
  jmp alltraps
801079d8:	e9 b7 f8 ff ff       	jmp    80107294 <alltraps>

801079dd <vector23>:
.globl vector23
vector23:
  pushl $0
801079dd:	6a 00                	push   $0x0
  pushl $23
801079df:	6a 17                	push   $0x17
  jmp alltraps
801079e1:	e9 ae f8 ff ff       	jmp    80107294 <alltraps>

801079e6 <vector24>:
.globl vector24
vector24:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $24
801079e8:	6a 18                	push   $0x18
  jmp alltraps
801079ea:	e9 a5 f8 ff ff       	jmp    80107294 <alltraps>

801079ef <vector25>:
.globl vector25
vector25:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $25
801079f1:	6a 19                	push   $0x19
  jmp alltraps
801079f3:	e9 9c f8 ff ff       	jmp    80107294 <alltraps>

801079f8 <vector26>:
.globl vector26
vector26:
  pushl $0
801079f8:	6a 00                	push   $0x0
  pushl $26
801079fa:	6a 1a                	push   $0x1a
  jmp alltraps
801079fc:	e9 93 f8 ff ff       	jmp    80107294 <alltraps>

80107a01 <vector27>:
.globl vector27
vector27:
  pushl $0
80107a01:	6a 00                	push   $0x0
  pushl $27
80107a03:	6a 1b                	push   $0x1b
  jmp alltraps
80107a05:	e9 8a f8 ff ff       	jmp    80107294 <alltraps>

80107a0a <vector28>:
.globl vector28
vector28:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $28
80107a0c:	6a 1c                	push   $0x1c
  jmp alltraps
80107a0e:	e9 81 f8 ff ff       	jmp    80107294 <alltraps>

80107a13 <vector29>:
.globl vector29
vector29:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $29
80107a15:	6a 1d                	push   $0x1d
  jmp alltraps
80107a17:	e9 78 f8 ff ff       	jmp    80107294 <alltraps>

80107a1c <vector30>:
.globl vector30
vector30:
  pushl $0
80107a1c:	6a 00                	push   $0x0
  pushl $30
80107a1e:	6a 1e                	push   $0x1e
  jmp alltraps
80107a20:	e9 6f f8 ff ff       	jmp    80107294 <alltraps>

80107a25 <vector31>:
.globl vector31
vector31:
  pushl $0
80107a25:	6a 00                	push   $0x0
  pushl $31
80107a27:	6a 1f                	push   $0x1f
  jmp alltraps
80107a29:	e9 66 f8 ff ff       	jmp    80107294 <alltraps>

80107a2e <vector32>:
.globl vector32
vector32:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $32
80107a30:	6a 20                	push   $0x20
  jmp alltraps
80107a32:	e9 5d f8 ff ff       	jmp    80107294 <alltraps>

80107a37 <vector33>:
.globl vector33
vector33:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $33
80107a39:	6a 21                	push   $0x21
  jmp alltraps
80107a3b:	e9 54 f8 ff ff       	jmp    80107294 <alltraps>

80107a40 <vector34>:
.globl vector34
vector34:
  pushl $0
80107a40:	6a 00                	push   $0x0
  pushl $34
80107a42:	6a 22                	push   $0x22
  jmp alltraps
80107a44:	e9 4b f8 ff ff       	jmp    80107294 <alltraps>

80107a49 <vector35>:
.globl vector35
vector35:
  pushl $0
80107a49:	6a 00                	push   $0x0
  pushl $35
80107a4b:	6a 23                	push   $0x23
  jmp alltraps
80107a4d:	e9 42 f8 ff ff       	jmp    80107294 <alltraps>

80107a52 <vector36>:
.globl vector36
vector36:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $36
80107a54:	6a 24                	push   $0x24
  jmp alltraps
80107a56:	e9 39 f8 ff ff       	jmp    80107294 <alltraps>

80107a5b <vector37>:
.globl vector37
vector37:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $37
80107a5d:	6a 25                	push   $0x25
  jmp alltraps
80107a5f:	e9 30 f8 ff ff       	jmp    80107294 <alltraps>

80107a64 <vector38>:
.globl vector38
vector38:
  pushl $0
80107a64:	6a 00                	push   $0x0
  pushl $38
80107a66:	6a 26                	push   $0x26
  jmp alltraps
80107a68:	e9 27 f8 ff ff       	jmp    80107294 <alltraps>

80107a6d <vector39>:
.globl vector39
vector39:
  pushl $0
80107a6d:	6a 00                	push   $0x0
  pushl $39
80107a6f:	6a 27                	push   $0x27
  jmp alltraps
80107a71:	e9 1e f8 ff ff       	jmp    80107294 <alltraps>

80107a76 <vector40>:
.globl vector40
vector40:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $40
80107a78:	6a 28                	push   $0x28
  jmp alltraps
80107a7a:	e9 15 f8 ff ff       	jmp    80107294 <alltraps>

80107a7f <vector41>:
.globl vector41
vector41:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $41
80107a81:	6a 29                	push   $0x29
  jmp alltraps
80107a83:	e9 0c f8 ff ff       	jmp    80107294 <alltraps>

80107a88 <vector42>:
.globl vector42
vector42:
  pushl $0
80107a88:	6a 00                	push   $0x0
  pushl $42
80107a8a:	6a 2a                	push   $0x2a
  jmp alltraps
80107a8c:	e9 03 f8 ff ff       	jmp    80107294 <alltraps>

80107a91 <vector43>:
.globl vector43
vector43:
  pushl $0
80107a91:	6a 00                	push   $0x0
  pushl $43
80107a93:	6a 2b                	push   $0x2b
  jmp alltraps
80107a95:	e9 fa f7 ff ff       	jmp    80107294 <alltraps>

80107a9a <vector44>:
.globl vector44
vector44:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $44
80107a9c:	6a 2c                	push   $0x2c
  jmp alltraps
80107a9e:	e9 f1 f7 ff ff       	jmp    80107294 <alltraps>

80107aa3 <vector45>:
.globl vector45
vector45:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $45
80107aa5:	6a 2d                	push   $0x2d
  jmp alltraps
80107aa7:	e9 e8 f7 ff ff       	jmp    80107294 <alltraps>

80107aac <vector46>:
.globl vector46
vector46:
  pushl $0
80107aac:	6a 00                	push   $0x0
  pushl $46
80107aae:	6a 2e                	push   $0x2e
  jmp alltraps
80107ab0:	e9 df f7 ff ff       	jmp    80107294 <alltraps>

80107ab5 <vector47>:
.globl vector47
vector47:
  pushl $0
80107ab5:	6a 00                	push   $0x0
  pushl $47
80107ab7:	6a 2f                	push   $0x2f
  jmp alltraps
80107ab9:	e9 d6 f7 ff ff       	jmp    80107294 <alltraps>

80107abe <vector48>:
.globl vector48
vector48:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $48
80107ac0:	6a 30                	push   $0x30
  jmp alltraps
80107ac2:	e9 cd f7 ff ff       	jmp    80107294 <alltraps>

80107ac7 <vector49>:
.globl vector49
vector49:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $49
80107ac9:	6a 31                	push   $0x31
  jmp alltraps
80107acb:	e9 c4 f7 ff ff       	jmp    80107294 <alltraps>

80107ad0 <vector50>:
.globl vector50
vector50:
  pushl $0
80107ad0:	6a 00                	push   $0x0
  pushl $50
80107ad2:	6a 32                	push   $0x32
  jmp alltraps
80107ad4:	e9 bb f7 ff ff       	jmp    80107294 <alltraps>

80107ad9 <vector51>:
.globl vector51
vector51:
  pushl $0
80107ad9:	6a 00                	push   $0x0
  pushl $51
80107adb:	6a 33                	push   $0x33
  jmp alltraps
80107add:	e9 b2 f7 ff ff       	jmp    80107294 <alltraps>

80107ae2 <vector52>:
.globl vector52
vector52:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $52
80107ae4:	6a 34                	push   $0x34
  jmp alltraps
80107ae6:	e9 a9 f7 ff ff       	jmp    80107294 <alltraps>

80107aeb <vector53>:
.globl vector53
vector53:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $53
80107aed:	6a 35                	push   $0x35
  jmp alltraps
80107aef:	e9 a0 f7 ff ff       	jmp    80107294 <alltraps>

80107af4 <vector54>:
.globl vector54
vector54:
  pushl $0
80107af4:	6a 00                	push   $0x0
  pushl $54
80107af6:	6a 36                	push   $0x36
  jmp alltraps
80107af8:	e9 97 f7 ff ff       	jmp    80107294 <alltraps>

80107afd <vector55>:
.globl vector55
vector55:
  pushl $0
80107afd:	6a 00                	push   $0x0
  pushl $55
80107aff:	6a 37                	push   $0x37
  jmp alltraps
80107b01:	e9 8e f7 ff ff       	jmp    80107294 <alltraps>

80107b06 <vector56>:
.globl vector56
vector56:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $56
80107b08:	6a 38                	push   $0x38
  jmp alltraps
80107b0a:	e9 85 f7 ff ff       	jmp    80107294 <alltraps>

80107b0f <vector57>:
.globl vector57
vector57:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $57
80107b11:	6a 39                	push   $0x39
  jmp alltraps
80107b13:	e9 7c f7 ff ff       	jmp    80107294 <alltraps>

80107b18 <vector58>:
.globl vector58
vector58:
  pushl $0
80107b18:	6a 00                	push   $0x0
  pushl $58
80107b1a:	6a 3a                	push   $0x3a
  jmp alltraps
80107b1c:	e9 73 f7 ff ff       	jmp    80107294 <alltraps>

80107b21 <vector59>:
.globl vector59
vector59:
  pushl $0
80107b21:	6a 00                	push   $0x0
  pushl $59
80107b23:	6a 3b                	push   $0x3b
  jmp alltraps
80107b25:	e9 6a f7 ff ff       	jmp    80107294 <alltraps>

80107b2a <vector60>:
.globl vector60
vector60:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $60
80107b2c:	6a 3c                	push   $0x3c
  jmp alltraps
80107b2e:	e9 61 f7 ff ff       	jmp    80107294 <alltraps>

80107b33 <vector61>:
.globl vector61
vector61:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $61
80107b35:	6a 3d                	push   $0x3d
  jmp alltraps
80107b37:	e9 58 f7 ff ff       	jmp    80107294 <alltraps>

80107b3c <vector62>:
.globl vector62
vector62:
  pushl $0
80107b3c:	6a 00                	push   $0x0
  pushl $62
80107b3e:	6a 3e                	push   $0x3e
  jmp alltraps
80107b40:	e9 4f f7 ff ff       	jmp    80107294 <alltraps>

80107b45 <vector63>:
.globl vector63
vector63:
  pushl $0
80107b45:	6a 00                	push   $0x0
  pushl $63
80107b47:	6a 3f                	push   $0x3f
  jmp alltraps
80107b49:	e9 46 f7 ff ff       	jmp    80107294 <alltraps>

80107b4e <vector64>:
.globl vector64
vector64:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $64
80107b50:	6a 40                	push   $0x40
  jmp alltraps
80107b52:	e9 3d f7 ff ff       	jmp    80107294 <alltraps>

80107b57 <vector65>:
.globl vector65
vector65:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $65
80107b59:	6a 41                	push   $0x41
  jmp alltraps
80107b5b:	e9 34 f7 ff ff       	jmp    80107294 <alltraps>

80107b60 <vector66>:
.globl vector66
vector66:
  pushl $0
80107b60:	6a 00                	push   $0x0
  pushl $66
80107b62:	6a 42                	push   $0x42
  jmp alltraps
80107b64:	e9 2b f7 ff ff       	jmp    80107294 <alltraps>

80107b69 <vector67>:
.globl vector67
vector67:
  pushl $0
80107b69:	6a 00                	push   $0x0
  pushl $67
80107b6b:	6a 43                	push   $0x43
  jmp alltraps
80107b6d:	e9 22 f7 ff ff       	jmp    80107294 <alltraps>

80107b72 <vector68>:
.globl vector68
vector68:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $68
80107b74:	6a 44                	push   $0x44
  jmp alltraps
80107b76:	e9 19 f7 ff ff       	jmp    80107294 <alltraps>

80107b7b <vector69>:
.globl vector69
vector69:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $69
80107b7d:	6a 45                	push   $0x45
  jmp alltraps
80107b7f:	e9 10 f7 ff ff       	jmp    80107294 <alltraps>

80107b84 <vector70>:
.globl vector70
vector70:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $70
80107b86:	6a 46                	push   $0x46
  jmp alltraps
80107b88:	e9 07 f7 ff ff       	jmp    80107294 <alltraps>

80107b8d <vector71>:
.globl vector71
vector71:
  pushl $0
80107b8d:	6a 00                	push   $0x0
  pushl $71
80107b8f:	6a 47                	push   $0x47
  jmp alltraps
80107b91:	e9 fe f6 ff ff       	jmp    80107294 <alltraps>

80107b96 <vector72>:
.globl vector72
vector72:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $72
80107b98:	6a 48                	push   $0x48
  jmp alltraps
80107b9a:	e9 f5 f6 ff ff       	jmp    80107294 <alltraps>

80107b9f <vector73>:
.globl vector73
vector73:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $73
80107ba1:	6a 49                	push   $0x49
  jmp alltraps
80107ba3:	e9 ec f6 ff ff       	jmp    80107294 <alltraps>

80107ba8 <vector74>:
.globl vector74
vector74:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $74
80107baa:	6a 4a                	push   $0x4a
  jmp alltraps
80107bac:	e9 e3 f6 ff ff       	jmp    80107294 <alltraps>

80107bb1 <vector75>:
.globl vector75
vector75:
  pushl $0
80107bb1:	6a 00                	push   $0x0
  pushl $75
80107bb3:	6a 4b                	push   $0x4b
  jmp alltraps
80107bb5:	e9 da f6 ff ff       	jmp    80107294 <alltraps>

80107bba <vector76>:
.globl vector76
vector76:
  pushl $0
80107bba:	6a 00                	push   $0x0
  pushl $76
80107bbc:	6a 4c                	push   $0x4c
  jmp alltraps
80107bbe:	e9 d1 f6 ff ff       	jmp    80107294 <alltraps>

80107bc3 <vector77>:
.globl vector77
vector77:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $77
80107bc5:	6a 4d                	push   $0x4d
  jmp alltraps
80107bc7:	e9 c8 f6 ff ff       	jmp    80107294 <alltraps>

80107bcc <vector78>:
.globl vector78
vector78:
  pushl $0
80107bcc:	6a 00                	push   $0x0
  pushl $78
80107bce:	6a 4e                	push   $0x4e
  jmp alltraps
80107bd0:	e9 bf f6 ff ff       	jmp    80107294 <alltraps>

80107bd5 <vector79>:
.globl vector79
vector79:
  pushl $0
80107bd5:	6a 00                	push   $0x0
  pushl $79
80107bd7:	6a 4f                	push   $0x4f
  jmp alltraps
80107bd9:	e9 b6 f6 ff ff       	jmp    80107294 <alltraps>

80107bde <vector80>:
.globl vector80
vector80:
  pushl $0
80107bde:	6a 00                	push   $0x0
  pushl $80
80107be0:	6a 50                	push   $0x50
  jmp alltraps
80107be2:	e9 ad f6 ff ff       	jmp    80107294 <alltraps>

80107be7 <vector81>:
.globl vector81
vector81:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $81
80107be9:	6a 51                	push   $0x51
  jmp alltraps
80107beb:	e9 a4 f6 ff ff       	jmp    80107294 <alltraps>

80107bf0 <vector82>:
.globl vector82
vector82:
  pushl $0
80107bf0:	6a 00                	push   $0x0
  pushl $82
80107bf2:	6a 52                	push   $0x52
  jmp alltraps
80107bf4:	e9 9b f6 ff ff       	jmp    80107294 <alltraps>

80107bf9 <vector83>:
.globl vector83
vector83:
  pushl $0
80107bf9:	6a 00                	push   $0x0
  pushl $83
80107bfb:	6a 53                	push   $0x53
  jmp alltraps
80107bfd:	e9 92 f6 ff ff       	jmp    80107294 <alltraps>

80107c02 <vector84>:
.globl vector84
vector84:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $84
80107c04:	6a 54                	push   $0x54
  jmp alltraps
80107c06:	e9 89 f6 ff ff       	jmp    80107294 <alltraps>

80107c0b <vector85>:
.globl vector85
vector85:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $85
80107c0d:	6a 55                	push   $0x55
  jmp alltraps
80107c0f:	e9 80 f6 ff ff       	jmp    80107294 <alltraps>

80107c14 <vector86>:
.globl vector86
vector86:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $86
80107c16:	6a 56                	push   $0x56
  jmp alltraps
80107c18:	e9 77 f6 ff ff       	jmp    80107294 <alltraps>

80107c1d <vector87>:
.globl vector87
vector87:
  pushl $0
80107c1d:	6a 00                	push   $0x0
  pushl $87
80107c1f:	6a 57                	push   $0x57
  jmp alltraps
80107c21:	e9 6e f6 ff ff       	jmp    80107294 <alltraps>

80107c26 <vector88>:
.globl vector88
vector88:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $88
80107c28:	6a 58                	push   $0x58
  jmp alltraps
80107c2a:	e9 65 f6 ff ff       	jmp    80107294 <alltraps>

80107c2f <vector89>:
.globl vector89
vector89:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $89
80107c31:	6a 59                	push   $0x59
  jmp alltraps
80107c33:	e9 5c f6 ff ff       	jmp    80107294 <alltraps>

80107c38 <vector90>:
.globl vector90
vector90:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $90
80107c3a:	6a 5a                	push   $0x5a
  jmp alltraps
80107c3c:	e9 53 f6 ff ff       	jmp    80107294 <alltraps>

80107c41 <vector91>:
.globl vector91
vector91:
  pushl $0
80107c41:	6a 00                	push   $0x0
  pushl $91
80107c43:	6a 5b                	push   $0x5b
  jmp alltraps
80107c45:	e9 4a f6 ff ff       	jmp    80107294 <alltraps>

80107c4a <vector92>:
.globl vector92
vector92:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $92
80107c4c:	6a 5c                	push   $0x5c
  jmp alltraps
80107c4e:	e9 41 f6 ff ff       	jmp    80107294 <alltraps>

80107c53 <vector93>:
.globl vector93
vector93:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $93
80107c55:	6a 5d                	push   $0x5d
  jmp alltraps
80107c57:	e9 38 f6 ff ff       	jmp    80107294 <alltraps>

80107c5c <vector94>:
.globl vector94
vector94:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $94
80107c5e:	6a 5e                	push   $0x5e
  jmp alltraps
80107c60:	e9 2f f6 ff ff       	jmp    80107294 <alltraps>

80107c65 <vector95>:
.globl vector95
vector95:
  pushl $0
80107c65:	6a 00                	push   $0x0
  pushl $95
80107c67:	6a 5f                	push   $0x5f
  jmp alltraps
80107c69:	e9 26 f6 ff ff       	jmp    80107294 <alltraps>

80107c6e <vector96>:
.globl vector96
vector96:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $96
80107c70:	6a 60                	push   $0x60
  jmp alltraps
80107c72:	e9 1d f6 ff ff       	jmp    80107294 <alltraps>

80107c77 <vector97>:
.globl vector97
vector97:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $97
80107c79:	6a 61                	push   $0x61
  jmp alltraps
80107c7b:	e9 14 f6 ff ff       	jmp    80107294 <alltraps>

80107c80 <vector98>:
.globl vector98
vector98:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $98
80107c82:	6a 62                	push   $0x62
  jmp alltraps
80107c84:	e9 0b f6 ff ff       	jmp    80107294 <alltraps>

80107c89 <vector99>:
.globl vector99
vector99:
  pushl $0
80107c89:	6a 00                	push   $0x0
  pushl $99
80107c8b:	6a 63                	push   $0x63
  jmp alltraps
80107c8d:	e9 02 f6 ff ff       	jmp    80107294 <alltraps>

80107c92 <vector100>:
.globl vector100
vector100:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $100
80107c94:	6a 64                	push   $0x64
  jmp alltraps
80107c96:	e9 f9 f5 ff ff       	jmp    80107294 <alltraps>

80107c9b <vector101>:
.globl vector101
vector101:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $101
80107c9d:	6a 65                	push   $0x65
  jmp alltraps
80107c9f:	e9 f0 f5 ff ff       	jmp    80107294 <alltraps>

80107ca4 <vector102>:
.globl vector102
vector102:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $102
80107ca6:	6a 66                	push   $0x66
  jmp alltraps
80107ca8:	e9 e7 f5 ff ff       	jmp    80107294 <alltraps>

80107cad <vector103>:
.globl vector103
vector103:
  pushl $0
80107cad:	6a 00                	push   $0x0
  pushl $103
80107caf:	6a 67                	push   $0x67
  jmp alltraps
80107cb1:	e9 de f5 ff ff       	jmp    80107294 <alltraps>

80107cb6 <vector104>:
.globl vector104
vector104:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $104
80107cb8:	6a 68                	push   $0x68
  jmp alltraps
80107cba:	e9 d5 f5 ff ff       	jmp    80107294 <alltraps>

80107cbf <vector105>:
.globl vector105
vector105:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $105
80107cc1:	6a 69                	push   $0x69
  jmp alltraps
80107cc3:	e9 cc f5 ff ff       	jmp    80107294 <alltraps>

80107cc8 <vector106>:
.globl vector106
vector106:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $106
80107cca:	6a 6a                	push   $0x6a
  jmp alltraps
80107ccc:	e9 c3 f5 ff ff       	jmp    80107294 <alltraps>

80107cd1 <vector107>:
.globl vector107
vector107:
  pushl $0
80107cd1:	6a 00                	push   $0x0
  pushl $107
80107cd3:	6a 6b                	push   $0x6b
  jmp alltraps
80107cd5:	e9 ba f5 ff ff       	jmp    80107294 <alltraps>

80107cda <vector108>:
.globl vector108
vector108:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $108
80107cdc:	6a 6c                	push   $0x6c
  jmp alltraps
80107cde:	e9 b1 f5 ff ff       	jmp    80107294 <alltraps>

80107ce3 <vector109>:
.globl vector109
vector109:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $109
80107ce5:	6a 6d                	push   $0x6d
  jmp alltraps
80107ce7:	e9 a8 f5 ff ff       	jmp    80107294 <alltraps>

80107cec <vector110>:
.globl vector110
vector110:
  pushl $0
80107cec:	6a 00                	push   $0x0
  pushl $110
80107cee:	6a 6e                	push   $0x6e
  jmp alltraps
80107cf0:	e9 9f f5 ff ff       	jmp    80107294 <alltraps>

80107cf5 <vector111>:
.globl vector111
vector111:
  pushl $0
80107cf5:	6a 00                	push   $0x0
  pushl $111
80107cf7:	6a 6f                	push   $0x6f
  jmp alltraps
80107cf9:	e9 96 f5 ff ff       	jmp    80107294 <alltraps>

80107cfe <vector112>:
.globl vector112
vector112:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $112
80107d00:	6a 70                	push   $0x70
  jmp alltraps
80107d02:	e9 8d f5 ff ff       	jmp    80107294 <alltraps>

80107d07 <vector113>:
.globl vector113
vector113:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $113
80107d09:	6a 71                	push   $0x71
  jmp alltraps
80107d0b:	e9 84 f5 ff ff       	jmp    80107294 <alltraps>

80107d10 <vector114>:
.globl vector114
vector114:
  pushl $0
80107d10:	6a 00                	push   $0x0
  pushl $114
80107d12:	6a 72                	push   $0x72
  jmp alltraps
80107d14:	e9 7b f5 ff ff       	jmp    80107294 <alltraps>

80107d19 <vector115>:
.globl vector115
vector115:
  pushl $0
80107d19:	6a 00                	push   $0x0
  pushl $115
80107d1b:	6a 73                	push   $0x73
  jmp alltraps
80107d1d:	e9 72 f5 ff ff       	jmp    80107294 <alltraps>

80107d22 <vector116>:
.globl vector116
vector116:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $116
80107d24:	6a 74                	push   $0x74
  jmp alltraps
80107d26:	e9 69 f5 ff ff       	jmp    80107294 <alltraps>

80107d2b <vector117>:
.globl vector117
vector117:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $117
80107d2d:	6a 75                	push   $0x75
  jmp alltraps
80107d2f:	e9 60 f5 ff ff       	jmp    80107294 <alltraps>

80107d34 <vector118>:
.globl vector118
vector118:
  pushl $0
80107d34:	6a 00                	push   $0x0
  pushl $118
80107d36:	6a 76                	push   $0x76
  jmp alltraps
80107d38:	e9 57 f5 ff ff       	jmp    80107294 <alltraps>

80107d3d <vector119>:
.globl vector119
vector119:
  pushl $0
80107d3d:	6a 00                	push   $0x0
  pushl $119
80107d3f:	6a 77                	push   $0x77
  jmp alltraps
80107d41:	e9 4e f5 ff ff       	jmp    80107294 <alltraps>

80107d46 <vector120>:
.globl vector120
vector120:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $120
80107d48:	6a 78                	push   $0x78
  jmp alltraps
80107d4a:	e9 45 f5 ff ff       	jmp    80107294 <alltraps>

80107d4f <vector121>:
.globl vector121
vector121:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $121
80107d51:	6a 79                	push   $0x79
  jmp alltraps
80107d53:	e9 3c f5 ff ff       	jmp    80107294 <alltraps>

80107d58 <vector122>:
.globl vector122
vector122:
  pushl $0
80107d58:	6a 00                	push   $0x0
  pushl $122
80107d5a:	6a 7a                	push   $0x7a
  jmp alltraps
80107d5c:	e9 33 f5 ff ff       	jmp    80107294 <alltraps>

80107d61 <vector123>:
.globl vector123
vector123:
  pushl $0
80107d61:	6a 00                	push   $0x0
  pushl $123
80107d63:	6a 7b                	push   $0x7b
  jmp alltraps
80107d65:	e9 2a f5 ff ff       	jmp    80107294 <alltraps>

80107d6a <vector124>:
.globl vector124
vector124:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $124
80107d6c:	6a 7c                	push   $0x7c
  jmp alltraps
80107d6e:	e9 21 f5 ff ff       	jmp    80107294 <alltraps>

80107d73 <vector125>:
.globl vector125
vector125:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $125
80107d75:	6a 7d                	push   $0x7d
  jmp alltraps
80107d77:	e9 18 f5 ff ff       	jmp    80107294 <alltraps>

80107d7c <vector126>:
.globl vector126
vector126:
  pushl $0
80107d7c:	6a 00                	push   $0x0
  pushl $126
80107d7e:	6a 7e                	push   $0x7e
  jmp alltraps
80107d80:	e9 0f f5 ff ff       	jmp    80107294 <alltraps>

80107d85 <vector127>:
.globl vector127
vector127:
  pushl $0
80107d85:	6a 00                	push   $0x0
  pushl $127
80107d87:	6a 7f                	push   $0x7f
  jmp alltraps
80107d89:	e9 06 f5 ff ff       	jmp    80107294 <alltraps>

80107d8e <vector128>:
.globl vector128
vector128:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $128
80107d90:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107d95:	e9 fa f4 ff ff       	jmp    80107294 <alltraps>

80107d9a <vector129>:
.globl vector129
vector129:
  pushl $0
80107d9a:	6a 00                	push   $0x0
  pushl $129
80107d9c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107da1:	e9 ee f4 ff ff       	jmp    80107294 <alltraps>

80107da6 <vector130>:
.globl vector130
vector130:
  pushl $0
80107da6:	6a 00                	push   $0x0
  pushl $130
80107da8:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107dad:	e9 e2 f4 ff ff       	jmp    80107294 <alltraps>

80107db2 <vector131>:
.globl vector131
vector131:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $131
80107db4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107db9:	e9 d6 f4 ff ff       	jmp    80107294 <alltraps>

80107dbe <vector132>:
.globl vector132
vector132:
  pushl $0
80107dbe:	6a 00                	push   $0x0
  pushl $132
80107dc0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107dc5:	e9 ca f4 ff ff       	jmp    80107294 <alltraps>

80107dca <vector133>:
.globl vector133
vector133:
  pushl $0
80107dca:	6a 00                	push   $0x0
  pushl $133
80107dcc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107dd1:	e9 be f4 ff ff       	jmp    80107294 <alltraps>

80107dd6 <vector134>:
.globl vector134
vector134:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $134
80107dd8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107ddd:	e9 b2 f4 ff ff       	jmp    80107294 <alltraps>

80107de2 <vector135>:
.globl vector135
vector135:
  pushl $0
80107de2:	6a 00                	push   $0x0
  pushl $135
80107de4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107de9:	e9 a6 f4 ff ff       	jmp    80107294 <alltraps>

80107dee <vector136>:
.globl vector136
vector136:
  pushl $0
80107dee:	6a 00                	push   $0x0
  pushl $136
80107df0:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107df5:	e9 9a f4 ff ff       	jmp    80107294 <alltraps>

80107dfa <vector137>:
.globl vector137
vector137:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $137
80107dfc:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107e01:	e9 8e f4 ff ff       	jmp    80107294 <alltraps>

80107e06 <vector138>:
.globl vector138
vector138:
  pushl $0
80107e06:	6a 00                	push   $0x0
  pushl $138
80107e08:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107e0d:	e9 82 f4 ff ff       	jmp    80107294 <alltraps>

80107e12 <vector139>:
.globl vector139
vector139:
  pushl $0
80107e12:	6a 00                	push   $0x0
  pushl $139
80107e14:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107e19:	e9 76 f4 ff ff       	jmp    80107294 <alltraps>

80107e1e <vector140>:
.globl vector140
vector140:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $140
80107e20:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107e25:	e9 6a f4 ff ff       	jmp    80107294 <alltraps>

80107e2a <vector141>:
.globl vector141
vector141:
  pushl $0
80107e2a:	6a 00                	push   $0x0
  pushl $141
80107e2c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107e31:	e9 5e f4 ff ff       	jmp    80107294 <alltraps>

80107e36 <vector142>:
.globl vector142
vector142:
  pushl $0
80107e36:	6a 00                	push   $0x0
  pushl $142
80107e38:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107e3d:	e9 52 f4 ff ff       	jmp    80107294 <alltraps>

80107e42 <vector143>:
.globl vector143
vector143:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $143
80107e44:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107e49:	e9 46 f4 ff ff       	jmp    80107294 <alltraps>

80107e4e <vector144>:
.globl vector144
vector144:
  pushl $0
80107e4e:	6a 00                	push   $0x0
  pushl $144
80107e50:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107e55:	e9 3a f4 ff ff       	jmp    80107294 <alltraps>

80107e5a <vector145>:
.globl vector145
vector145:
  pushl $0
80107e5a:	6a 00                	push   $0x0
  pushl $145
80107e5c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107e61:	e9 2e f4 ff ff       	jmp    80107294 <alltraps>

80107e66 <vector146>:
.globl vector146
vector146:
  pushl $0
80107e66:	6a 00                	push   $0x0
  pushl $146
80107e68:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107e6d:	e9 22 f4 ff ff       	jmp    80107294 <alltraps>

80107e72 <vector147>:
.globl vector147
vector147:
  pushl $0
80107e72:	6a 00                	push   $0x0
  pushl $147
80107e74:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107e79:	e9 16 f4 ff ff       	jmp    80107294 <alltraps>

80107e7e <vector148>:
.globl vector148
vector148:
  pushl $0
80107e7e:	6a 00                	push   $0x0
  pushl $148
80107e80:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107e85:	e9 0a f4 ff ff       	jmp    80107294 <alltraps>

80107e8a <vector149>:
.globl vector149
vector149:
  pushl $0
80107e8a:	6a 00                	push   $0x0
  pushl $149
80107e8c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107e91:	e9 fe f3 ff ff       	jmp    80107294 <alltraps>

80107e96 <vector150>:
.globl vector150
vector150:
  pushl $0
80107e96:	6a 00                	push   $0x0
  pushl $150
80107e98:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107e9d:	e9 f2 f3 ff ff       	jmp    80107294 <alltraps>

80107ea2 <vector151>:
.globl vector151
vector151:
  pushl $0
80107ea2:	6a 00                	push   $0x0
  pushl $151
80107ea4:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107ea9:	e9 e6 f3 ff ff       	jmp    80107294 <alltraps>

80107eae <vector152>:
.globl vector152
vector152:
  pushl $0
80107eae:	6a 00                	push   $0x0
  pushl $152
80107eb0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107eb5:	e9 da f3 ff ff       	jmp    80107294 <alltraps>

80107eba <vector153>:
.globl vector153
vector153:
  pushl $0
80107eba:	6a 00                	push   $0x0
  pushl $153
80107ebc:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107ec1:	e9 ce f3 ff ff       	jmp    80107294 <alltraps>

80107ec6 <vector154>:
.globl vector154
vector154:
  pushl $0
80107ec6:	6a 00                	push   $0x0
  pushl $154
80107ec8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107ecd:	e9 c2 f3 ff ff       	jmp    80107294 <alltraps>

80107ed2 <vector155>:
.globl vector155
vector155:
  pushl $0
80107ed2:	6a 00                	push   $0x0
  pushl $155
80107ed4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107ed9:	e9 b6 f3 ff ff       	jmp    80107294 <alltraps>

80107ede <vector156>:
.globl vector156
vector156:
  pushl $0
80107ede:	6a 00                	push   $0x0
  pushl $156
80107ee0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107ee5:	e9 aa f3 ff ff       	jmp    80107294 <alltraps>

80107eea <vector157>:
.globl vector157
vector157:
  pushl $0
80107eea:	6a 00                	push   $0x0
  pushl $157
80107eec:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107ef1:	e9 9e f3 ff ff       	jmp    80107294 <alltraps>

80107ef6 <vector158>:
.globl vector158
vector158:
  pushl $0
80107ef6:	6a 00                	push   $0x0
  pushl $158
80107ef8:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107efd:	e9 92 f3 ff ff       	jmp    80107294 <alltraps>

80107f02 <vector159>:
.globl vector159
vector159:
  pushl $0
80107f02:	6a 00                	push   $0x0
  pushl $159
80107f04:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107f09:	e9 86 f3 ff ff       	jmp    80107294 <alltraps>

80107f0e <vector160>:
.globl vector160
vector160:
  pushl $0
80107f0e:	6a 00                	push   $0x0
  pushl $160
80107f10:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107f15:	e9 7a f3 ff ff       	jmp    80107294 <alltraps>

80107f1a <vector161>:
.globl vector161
vector161:
  pushl $0
80107f1a:	6a 00                	push   $0x0
  pushl $161
80107f1c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107f21:	e9 6e f3 ff ff       	jmp    80107294 <alltraps>

80107f26 <vector162>:
.globl vector162
vector162:
  pushl $0
80107f26:	6a 00                	push   $0x0
  pushl $162
80107f28:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107f2d:	e9 62 f3 ff ff       	jmp    80107294 <alltraps>

80107f32 <vector163>:
.globl vector163
vector163:
  pushl $0
80107f32:	6a 00                	push   $0x0
  pushl $163
80107f34:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107f39:	e9 56 f3 ff ff       	jmp    80107294 <alltraps>

80107f3e <vector164>:
.globl vector164
vector164:
  pushl $0
80107f3e:	6a 00                	push   $0x0
  pushl $164
80107f40:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107f45:	e9 4a f3 ff ff       	jmp    80107294 <alltraps>

80107f4a <vector165>:
.globl vector165
vector165:
  pushl $0
80107f4a:	6a 00                	push   $0x0
  pushl $165
80107f4c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107f51:	e9 3e f3 ff ff       	jmp    80107294 <alltraps>

80107f56 <vector166>:
.globl vector166
vector166:
  pushl $0
80107f56:	6a 00                	push   $0x0
  pushl $166
80107f58:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107f5d:	e9 32 f3 ff ff       	jmp    80107294 <alltraps>

80107f62 <vector167>:
.globl vector167
vector167:
  pushl $0
80107f62:	6a 00                	push   $0x0
  pushl $167
80107f64:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107f69:	e9 26 f3 ff ff       	jmp    80107294 <alltraps>

80107f6e <vector168>:
.globl vector168
vector168:
  pushl $0
80107f6e:	6a 00                	push   $0x0
  pushl $168
80107f70:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107f75:	e9 1a f3 ff ff       	jmp    80107294 <alltraps>

80107f7a <vector169>:
.globl vector169
vector169:
  pushl $0
80107f7a:	6a 00                	push   $0x0
  pushl $169
80107f7c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107f81:	e9 0e f3 ff ff       	jmp    80107294 <alltraps>

80107f86 <vector170>:
.globl vector170
vector170:
  pushl $0
80107f86:	6a 00                	push   $0x0
  pushl $170
80107f88:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107f8d:	e9 02 f3 ff ff       	jmp    80107294 <alltraps>

80107f92 <vector171>:
.globl vector171
vector171:
  pushl $0
80107f92:	6a 00                	push   $0x0
  pushl $171
80107f94:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107f99:	e9 f6 f2 ff ff       	jmp    80107294 <alltraps>

80107f9e <vector172>:
.globl vector172
vector172:
  pushl $0
80107f9e:	6a 00                	push   $0x0
  pushl $172
80107fa0:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107fa5:	e9 ea f2 ff ff       	jmp    80107294 <alltraps>

80107faa <vector173>:
.globl vector173
vector173:
  pushl $0
80107faa:	6a 00                	push   $0x0
  pushl $173
80107fac:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107fb1:	e9 de f2 ff ff       	jmp    80107294 <alltraps>

80107fb6 <vector174>:
.globl vector174
vector174:
  pushl $0
80107fb6:	6a 00                	push   $0x0
  pushl $174
80107fb8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107fbd:	e9 d2 f2 ff ff       	jmp    80107294 <alltraps>

80107fc2 <vector175>:
.globl vector175
vector175:
  pushl $0
80107fc2:	6a 00                	push   $0x0
  pushl $175
80107fc4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107fc9:	e9 c6 f2 ff ff       	jmp    80107294 <alltraps>

80107fce <vector176>:
.globl vector176
vector176:
  pushl $0
80107fce:	6a 00                	push   $0x0
  pushl $176
80107fd0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107fd5:	e9 ba f2 ff ff       	jmp    80107294 <alltraps>

80107fda <vector177>:
.globl vector177
vector177:
  pushl $0
80107fda:	6a 00                	push   $0x0
  pushl $177
80107fdc:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107fe1:	e9 ae f2 ff ff       	jmp    80107294 <alltraps>

80107fe6 <vector178>:
.globl vector178
vector178:
  pushl $0
80107fe6:	6a 00                	push   $0x0
  pushl $178
80107fe8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107fed:	e9 a2 f2 ff ff       	jmp    80107294 <alltraps>

80107ff2 <vector179>:
.globl vector179
vector179:
  pushl $0
80107ff2:	6a 00                	push   $0x0
  pushl $179
80107ff4:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107ff9:	e9 96 f2 ff ff       	jmp    80107294 <alltraps>

80107ffe <vector180>:
.globl vector180
vector180:
  pushl $0
80107ffe:	6a 00                	push   $0x0
  pushl $180
80108000:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108005:	e9 8a f2 ff ff       	jmp    80107294 <alltraps>

8010800a <vector181>:
.globl vector181
vector181:
  pushl $0
8010800a:	6a 00                	push   $0x0
  pushl $181
8010800c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108011:	e9 7e f2 ff ff       	jmp    80107294 <alltraps>

80108016 <vector182>:
.globl vector182
vector182:
  pushl $0
80108016:	6a 00                	push   $0x0
  pushl $182
80108018:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010801d:	e9 72 f2 ff ff       	jmp    80107294 <alltraps>

80108022 <vector183>:
.globl vector183
vector183:
  pushl $0
80108022:	6a 00                	push   $0x0
  pushl $183
80108024:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108029:	e9 66 f2 ff ff       	jmp    80107294 <alltraps>

8010802e <vector184>:
.globl vector184
vector184:
  pushl $0
8010802e:	6a 00                	push   $0x0
  pushl $184
80108030:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108035:	e9 5a f2 ff ff       	jmp    80107294 <alltraps>

8010803a <vector185>:
.globl vector185
vector185:
  pushl $0
8010803a:	6a 00                	push   $0x0
  pushl $185
8010803c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108041:	e9 4e f2 ff ff       	jmp    80107294 <alltraps>

80108046 <vector186>:
.globl vector186
vector186:
  pushl $0
80108046:	6a 00                	push   $0x0
  pushl $186
80108048:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010804d:	e9 42 f2 ff ff       	jmp    80107294 <alltraps>

80108052 <vector187>:
.globl vector187
vector187:
  pushl $0
80108052:	6a 00                	push   $0x0
  pushl $187
80108054:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108059:	e9 36 f2 ff ff       	jmp    80107294 <alltraps>

8010805e <vector188>:
.globl vector188
vector188:
  pushl $0
8010805e:	6a 00                	push   $0x0
  pushl $188
80108060:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108065:	e9 2a f2 ff ff       	jmp    80107294 <alltraps>

8010806a <vector189>:
.globl vector189
vector189:
  pushl $0
8010806a:	6a 00                	push   $0x0
  pushl $189
8010806c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108071:	e9 1e f2 ff ff       	jmp    80107294 <alltraps>

80108076 <vector190>:
.globl vector190
vector190:
  pushl $0
80108076:	6a 00                	push   $0x0
  pushl $190
80108078:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010807d:	e9 12 f2 ff ff       	jmp    80107294 <alltraps>

80108082 <vector191>:
.globl vector191
vector191:
  pushl $0
80108082:	6a 00                	push   $0x0
  pushl $191
80108084:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108089:	e9 06 f2 ff ff       	jmp    80107294 <alltraps>

8010808e <vector192>:
.globl vector192
vector192:
  pushl $0
8010808e:	6a 00                	push   $0x0
  pushl $192
80108090:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108095:	e9 fa f1 ff ff       	jmp    80107294 <alltraps>

8010809a <vector193>:
.globl vector193
vector193:
  pushl $0
8010809a:	6a 00                	push   $0x0
  pushl $193
8010809c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801080a1:	e9 ee f1 ff ff       	jmp    80107294 <alltraps>

801080a6 <vector194>:
.globl vector194
vector194:
  pushl $0
801080a6:	6a 00                	push   $0x0
  pushl $194
801080a8:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801080ad:	e9 e2 f1 ff ff       	jmp    80107294 <alltraps>

801080b2 <vector195>:
.globl vector195
vector195:
  pushl $0
801080b2:	6a 00                	push   $0x0
  pushl $195
801080b4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801080b9:	e9 d6 f1 ff ff       	jmp    80107294 <alltraps>

801080be <vector196>:
.globl vector196
vector196:
  pushl $0
801080be:	6a 00                	push   $0x0
  pushl $196
801080c0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801080c5:	e9 ca f1 ff ff       	jmp    80107294 <alltraps>

801080ca <vector197>:
.globl vector197
vector197:
  pushl $0
801080ca:	6a 00                	push   $0x0
  pushl $197
801080cc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801080d1:	e9 be f1 ff ff       	jmp    80107294 <alltraps>

801080d6 <vector198>:
.globl vector198
vector198:
  pushl $0
801080d6:	6a 00                	push   $0x0
  pushl $198
801080d8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801080dd:	e9 b2 f1 ff ff       	jmp    80107294 <alltraps>

801080e2 <vector199>:
.globl vector199
vector199:
  pushl $0
801080e2:	6a 00                	push   $0x0
  pushl $199
801080e4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801080e9:	e9 a6 f1 ff ff       	jmp    80107294 <alltraps>

801080ee <vector200>:
.globl vector200
vector200:
  pushl $0
801080ee:	6a 00                	push   $0x0
  pushl $200
801080f0:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801080f5:	e9 9a f1 ff ff       	jmp    80107294 <alltraps>

801080fa <vector201>:
.globl vector201
vector201:
  pushl $0
801080fa:	6a 00                	push   $0x0
  pushl $201
801080fc:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108101:	e9 8e f1 ff ff       	jmp    80107294 <alltraps>

80108106 <vector202>:
.globl vector202
vector202:
  pushl $0
80108106:	6a 00                	push   $0x0
  pushl $202
80108108:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010810d:	e9 82 f1 ff ff       	jmp    80107294 <alltraps>

80108112 <vector203>:
.globl vector203
vector203:
  pushl $0
80108112:	6a 00                	push   $0x0
  pushl $203
80108114:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108119:	e9 76 f1 ff ff       	jmp    80107294 <alltraps>

8010811e <vector204>:
.globl vector204
vector204:
  pushl $0
8010811e:	6a 00                	push   $0x0
  pushl $204
80108120:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108125:	e9 6a f1 ff ff       	jmp    80107294 <alltraps>

8010812a <vector205>:
.globl vector205
vector205:
  pushl $0
8010812a:	6a 00                	push   $0x0
  pushl $205
8010812c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108131:	e9 5e f1 ff ff       	jmp    80107294 <alltraps>

80108136 <vector206>:
.globl vector206
vector206:
  pushl $0
80108136:	6a 00                	push   $0x0
  pushl $206
80108138:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010813d:	e9 52 f1 ff ff       	jmp    80107294 <alltraps>

80108142 <vector207>:
.globl vector207
vector207:
  pushl $0
80108142:	6a 00                	push   $0x0
  pushl $207
80108144:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108149:	e9 46 f1 ff ff       	jmp    80107294 <alltraps>

8010814e <vector208>:
.globl vector208
vector208:
  pushl $0
8010814e:	6a 00                	push   $0x0
  pushl $208
80108150:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108155:	e9 3a f1 ff ff       	jmp    80107294 <alltraps>

8010815a <vector209>:
.globl vector209
vector209:
  pushl $0
8010815a:	6a 00                	push   $0x0
  pushl $209
8010815c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108161:	e9 2e f1 ff ff       	jmp    80107294 <alltraps>

80108166 <vector210>:
.globl vector210
vector210:
  pushl $0
80108166:	6a 00                	push   $0x0
  pushl $210
80108168:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010816d:	e9 22 f1 ff ff       	jmp    80107294 <alltraps>

80108172 <vector211>:
.globl vector211
vector211:
  pushl $0
80108172:	6a 00                	push   $0x0
  pushl $211
80108174:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108179:	e9 16 f1 ff ff       	jmp    80107294 <alltraps>

8010817e <vector212>:
.globl vector212
vector212:
  pushl $0
8010817e:	6a 00                	push   $0x0
  pushl $212
80108180:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108185:	e9 0a f1 ff ff       	jmp    80107294 <alltraps>

8010818a <vector213>:
.globl vector213
vector213:
  pushl $0
8010818a:	6a 00                	push   $0x0
  pushl $213
8010818c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108191:	e9 fe f0 ff ff       	jmp    80107294 <alltraps>

80108196 <vector214>:
.globl vector214
vector214:
  pushl $0
80108196:	6a 00                	push   $0x0
  pushl $214
80108198:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010819d:	e9 f2 f0 ff ff       	jmp    80107294 <alltraps>

801081a2 <vector215>:
.globl vector215
vector215:
  pushl $0
801081a2:	6a 00                	push   $0x0
  pushl $215
801081a4:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801081a9:	e9 e6 f0 ff ff       	jmp    80107294 <alltraps>

801081ae <vector216>:
.globl vector216
vector216:
  pushl $0
801081ae:	6a 00                	push   $0x0
  pushl $216
801081b0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801081b5:	e9 da f0 ff ff       	jmp    80107294 <alltraps>

801081ba <vector217>:
.globl vector217
vector217:
  pushl $0
801081ba:	6a 00                	push   $0x0
  pushl $217
801081bc:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801081c1:	e9 ce f0 ff ff       	jmp    80107294 <alltraps>

801081c6 <vector218>:
.globl vector218
vector218:
  pushl $0
801081c6:	6a 00                	push   $0x0
  pushl $218
801081c8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801081cd:	e9 c2 f0 ff ff       	jmp    80107294 <alltraps>

801081d2 <vector219>:
.globl vector219
vector219:
  pushl $0
801081d2:	6a 00                	push   $0x0
  pushl $219
801081d4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801081d9:	e9 b6 f0 ff ff       	jmp    80107294 <alltraps>

801081de <vector220>:
.globl vector220
vector220:
  pushl $0
801081de:	6a 00                	push   $0x0
  pushl $220
801081e0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801081e5:	e9 aa f0 ff ff       	jmp    80107294 <alltraps>

801081ea <vector221>:
.globl vector221
vector221:
  pushl $0
801081ea:	6a 00                	push   $0x0
  pushl $221
801081ec:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801081f1:	e9 9e f0 ff ff       	jmp    80107294 <alltraps>

801081f6 <vector222>:
.globl vector222
vector222:
  pushl $0
801081f6:	6a 00                	push   $0x0
  pushl $222
801081f8:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801081fd:	e9 92 f0 ff ff       	jmp    80107294 <alltraps>

80108202 <vector223>:
.globl vector223
vector223:
  pushl $0
80108202:	6a 00                	push   $0x0
  pushl $223
80108204:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108209:	e9 86 f0 ff ff       	jmp    80107294 <alltraps>

8010820e <vector224>:
.globl vector224
vector224:
  pushl $0
8010820e:	6a 00                	push   $0x0
  pushl $224
80108210:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108215:	e9 7a f0 ff ff       	jmp    80107294 <alltraps>

8010821a <vector225>:
.globl vector225
vector225:
  pushl $0
8010821a:	6a 00                	push   $0x0
  pushl $225
8010821c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108221:	e9 6e f0 ff ff       	jmp    80107294 <alltraps>

80108226 <vector226>:
.globl vector226
vector226:
  pushl $0
80108226:	6a 00                	push   $0x0
  pushl $226
80108228:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010822d:	e9 62 f0 ff ff       	jmp    80107294 <alltraps>

80108232 <vector227>:
.globl vector227
vector227:
  pushl $0
80108232:	6a 00                	push   $0x0
  pushl $227
80108234:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108239:	e9 56 f0 ff ff       	jmp    80107294 <alltraps>

8010823e <vector228>:
.globl vector228
vector228:
  pushl $0
8010823e:	6a 00                	push   $0x0
  pushl $228
80108240:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108245:	e9 4a f0 ff ff       	jmp    80107294 <alltraps>

8010824a <vector229>:
.globl vector229
vector229:
  pushl $0
8010824a:	6a 00                	push   $0x0
  pushl $229
8010824c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108251:	e9 3e f0 ff ff       	jmp    80107294 <alltraps>

80108256 <vector230>:
.globl vector230
vector230:
  pushl $0
80108256:	6a 00                	push   $0x0
  pushl $230
80108258:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010825d:	e9 32 f0 ff ff       	jmp    80107294 <alltraps>

80108262 <vector231>:
.globl vector231
vector231:
  pushl $0
80108262:	6a 00                	push   $0x0
  pushl $231
80108264:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108269:	e9 26 f0 ff ff       	jmp    80107294 <alltraps>

8010826e <vector232>:
.globl vector232
vector232:
  pushl $0
8010826e:	6a 00                	push   $0x0
  pushl $232
80108270:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108275:	e9 1a f0 ff ff       	jmp    80107294 <alltraps>

8010827a <vector233>:
.globl vector233
vector233:
  pushl $0
8010827a:	6a 00                	push   $0x0
  pushl $233
8010827c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108281:	e9 0e f0 ff ff       	jmp    80107294 <alltraps>

80108286 <vector234>:
.globl vector234
vector234:
  pushl $0
80108286:	6a 00                	push   $0x0
  pushl $234
80108288:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010828d:	e9 02 f0 ff ff       	jmp    80107294 <alltraps>

80108292 <vector235>:
.globl vector235
vector235:
  pushl $0
80108292:	6a 00                	push   $0x0
  pushl $235
80108294:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108299:	e9 f6 ef ff ff       	jmp    80107294 <alltraps>

8010829e <vector236>:
.globl vector236
vector236:
  pushl $0
8010829e:	6a 00                	push   $0x0
  pushl $236
801082a0:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801082a5:	e9 ea ef ff ff       	jmp    80107294 <alltraps>

801082aa <vector237>:
.globl vector237
vector237:
  pushl $0
801082aa:	6a 00                	push   $0x0
  pushl $237
801082ac:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801082b1:	e9 de ef ff ff       	jmp    80107294 <alltraps>

801082b6 <vector238>:
.globl vector238
vector238:
  pushl $0
801082b6:	6a 00                	push   $0x0
  pushl $238
801082b8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801082bd:	e9 d2 ef ff ff       	jmp    80107294 <alltraps>

801082c2 <vector239>:
.globl vector239
vector239:
  pushl $0
801082c2:	6a 00                	push   $0x0
  pushl $239
801082c4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801082c9:	e9 c6 ef ff ff       	jmp    80107294 <alltraps>

801082ce <vector240>:
.globl vector240
vector240:
  pushl $0
801082ce:	6a 00                	push   $0x0
  pushl $240
801082d0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801082d5:	e9 ba ef ff ff       	jmp    80107294 <alltraps>

801082da <vector241>:
.globl vector241
vector241:
  pushl $0
801082da:	6a 00                	push   $0x0
  pushl $241
801082dc:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801082e1:	e9 ae ef ff ff       	jmp    80107294 <alltraps>

801082e6 <vector242>:
.globl vector242
vector242:
  pushl $0
801082e6:	6a 00                	push   $0x0
  pushl $242
801082e8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801082ed:	e9 a2 ef ff ff       	jmp    80107294 <alltraps>

801082f2 <vector243>:
.globl vector243
vector243:
  pushl $0
801082f2:	6a 00                	push   $0x0
  pushl $243
801082f4:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801082f9:	e9 96 ef ff ff       	jmp    80107294 <alltraps>

801082fe <vector244>:
.globl vector244
vector244:
  pushl $0
801082fe:	6a 00                	push   $0x0
  pushl $244
80108300:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108305:	e9 8a ef ff ff       	jmp    80107294 <alltraps>

8010830a <vector245>:
.globl vector245
vector245:
  pushl $0
8010830a:	6a 00                	push   $0x0
  pushl $245
8010830c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108311:	e9 7e ef ff ff       	jmp    80107294 <alltraps>

80108316 <vector246>:
.globl vector246
vector246:
  pushl $0
80108316:	6a 00                	push   $0x0
  pushl $246
80108318:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010831d:	e9 72 ef ff ff       	jmp    80107294 <alltraps>

80108322 <vector247>:
.globl vector247
vector247:
  pushl $0
80108322:	6a 00                	push   $0x0
  pushl $247
80108324:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108329:	e9 66 ef ff ff       	jmp    80107294 <alltraps>

8010832e <vector248>:
.globl vector248
vector248:
  pushl $0
8010832e:	6a 00                	push   $0x0
  pushl $248
80108330:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108335:	e9 5a ef ff ff       	jmp    80107294 <alltraps>

8010833a <vector249>:
.globl vector249
vector249:
  pushl $0
8010833a:	6a 00                	push   $0x0
  pushl $249
8010833c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108341:	e9 4e ef ff ff       	jmp    80107294 <alltraps>

80108346 <vector250>:
.globl vector250
vector250:
  pushl $0
80108346:	6a 00                	push   $0x0
  pushl $250
80108348:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010834d:	e9 42 ef ff ff       	jmp    80107294 <alltraps>

80108352 <vector251>:
.globl vector251
vector251:
  pushl $0
80108352:	6a 00                	push   $0x0
  pushl $251
80108354:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108359:	e9 36 ef ff ff       	jmp    80107294 <alltraps>

8010835e <vector252>:
.globl vector252
vector252:
  pushl $0
8010835e:	6a 00                	push   $0x0
  pushl $252
80108360:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108365:	e9 2a ef ff ff       	jmp    80107294 <alltraps>

8010836a <vector253>:
.globl vector253
vector253:
  pushl $0
8010836a:	6a 00                	push   $0x0
  pushl $253
8010836c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108371:	e9 1e ef ff ff       	jmp    80107294 <alltraps>

80108376 <vector254>:
.globl vector254
vector254:
  pushl $0
80108376:	6a 00                	push   $0x0
  pushl $254
80108378:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010837d:	e9 12 ef ff ff       	jmp    80107294 <alltraps>

80108382 <vector255>:
.globl vector255
vector255:
  pushl $0
80108382:	6a 00                	push   $0x0
  pushl $255
80108384:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108389:	e9 06 ef ff ff       	jmp    80107294 <alltraps>

8010838e <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010838e:	55                   	push   %ebp
8010838f:	89 e5                	mov    %esp,%ebp
80108391:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108394:	8b 45 0c             	mov    0xc(%ebp),%eax
80108397:	83 e8 01             	sub    $0x1,%eax
8010839a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010839e:	8b 45 08             	mov    0x8(%ebp),%eax
801083a1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801083a5:	8b 45 08             	mov    0x8(%ebp),%eax
801083a8:	c1 e8 10             	shr    $0x10,%eax
801083ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801083af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801083b2:	0f 01 10             	lgdtl  (%eax)
}
801083b5:	c9                   	leave  
801083b6:	c3                   	ret    

801083b7 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801083b7:	55                   	push   %ebp
801083b8:	89 e5                	mov    %esp,%ebp
801083ba:	83 ec 04             	sub    $0x4,%esp
801083bd:	8b 45 08             	mov    0x8(%ebp),%eax
801083c0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801083c4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801083c8:	0f 00 d8             	ltr    %ax
}
801083cb:	c9                   	leave  
801083cc:	c3                   	ret    

801083cd <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801083cd:	55                   	push   %ebp
801083ce:	89 e5                	mov    %esp,%ebp
801083d0:	83 ec 04             	sub    $0x4,%esp
801083d3:	8b 45 08             	mov    0x8(%ebp),%eax
801083d6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801083da:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801083de:	8e e8                	mov    %eax,%gs
}
801083e0:	c9                   	leave  
801083e1:	c3                   	ret    

801083e2 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801083e2:	55                   	push   %ebp
801083e3:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801083e5:	8b 45 08             	mov    0x8(%ebp),%eax
801083e8:	0f 22 d8             	mov    %eax,%cr3
}
801083eb:	5d                   	pop    %ebp
801083ec:	c3                   	ret    

801083ed <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801083ed:	55                   	push   %ebp
801083ee:	89 e5                	mov    %esp,%ebp
801083f0:	8b 45 08             	mov    0x8(%ebp),%eax
801083f3:	05 00 00 00 80       	add    $0x80000000,%eax
801083f8:	5d                   	pop    %ebp
801083f9:	c3                   	ret    

801083fa <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801083fa:	55                   	push   %ebp
801083fb:	89 e5                	mov    %esp,%ebp
801083fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108400:	05 00 00 00 80       	add    $0x80000000,%eax
80108405:	5d                   	pop    %ebp
80108406:	c3                   	ret    

80108407 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108407:	55                   	push   %ebp
80108408:	89 e5                	mov    %esp,%ebp
8010840a:	53                   	push   %ebx
8010840b:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010840e:	e8 77 aa ff ff       	call   80102e8a <cpunum>
80108413:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108419:	05 e0 33 11 80       	add    $0x801133e0,%eax
8010841e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108424:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010842a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842d:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108436:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010843a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108441:	83 e2 f0             	and    $0xfffffff0,%edx
80108444:	83 ca 0a             	or     $0xa,%edx
80108447:	88 50 7d             	mov    %dl,0x7d(%eax)
8010844a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108451:	83 ca 10             	or     $0x10,%edx
80108454:	88 50 7d             	mov    %dl,0x7d(%eax)
80108457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010845e:	83 e2 9f             	and    $0xffffff9f,%edx
80108461:	88 50 7d             	mov    %dl,0x7d(%eax)
80108464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108467:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010846b:	83 ca 80             	or     $0xffffff80,%edx
8010846e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108474:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108478:	83 ca 0f             	or     $0xf,%edx
8010847b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010847e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108481:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108485:	83 e2 ef             	and    $0xffffffef,%edx
80108488:	88 50 7e             	mov    %dl,0x7e(%eax)
8010848b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108492:	83 e2 df             	and    $0xffffffdf,%edx
80108495:	88 50 7e             	mov    %dl,0x7e(%eax)
80108498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010849b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010849f:	83 ca 40             	or     $0x40,%edx
801084a2:	88 50 7e             	mov    %dl,0x7e(%eax)
801084a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801084ac:	83 ca 80             	or     $0xffffff80,%edx
801084af:	88 50 7e             	mov    %dl,0x7e(%eax)
801084b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b5:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801084b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bc:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801084c3:	ff ff 
801084c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c8:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801084cf:	00 00 
801084d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d4:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801084db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084de:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801084e5:	83 e2 f0             	and    $0xfffffff0,%edx
801084e8:	83 ca 02             	or     $0x2,%edx
801084eb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801084f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801084fb:	83 ca 10             	or     $0x10,%edx
801084fe:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108507:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010850e:	83 e2 9f             	and    $0xffffff9f,%edx
80108511:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108521:	83 ca 80             	or     $0xffffff80,%edx
80108524:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010852a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010852d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108534:	83 ca 0f             	or     $0xf,%edx
80108537:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010853d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108540:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108547:	83 e2 ef             	and    $0xffffffef,%edx
8010854a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108553:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010855a:	83 e2 df             	and    $0xffffffdf,%edx
8010855d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108566:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010856d:	83 ca 40             	or     $0x40,%edx
80108570:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108579:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108580:	83 ca 80             	or     $0xffffff80,%edx
80108583:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010858c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108596:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010859d:	ff ff 
8010859f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a2:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801085a9:	00 00 
801085ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ae:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801085b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085bf:	83 e2 f0             	and    $0xfffffff0,%edx
801085c2:	83 ca 0a             	or     $0xa,%edx
801085c5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801085cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ce:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085d5:	83 ca 10             	or     $0x10,%edx
801085d8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801085de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085e8:	83 ca 60             	or     $0x60,%edx
801085eb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801085f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801085fb:	83 ca 80             	or     $0xffffff80,%edx
801085fe:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108607:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010860e:	83 ca 0f             	or     $0xf,%edx
80108611:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010861a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108621:	83 e2 ef             	and    $0xffffffef,%edx
80108624:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010862a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010862d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108634:	83 e2 df             	and    $0xffffffdf,%edx
80108637:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010863d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108640:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108647:	83 ca 40             	or     $0x40,%edx
8010864a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108653:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010865a:	83 ca 80             	or     $0xffffff80,%edx
8010865d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108666:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010866d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108670:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108677:	ff ff 
80108679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108683:	00 00 
80108685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108688:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010868f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108692:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108699:	83 e2 f0             	and    $0xfffffff0,%edx
8010869c:	83 ca 02             	or     $0x2,%edx
8010869f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801086a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086a8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801086af:	83 ca 10             	or     $0x10,%edx
801086b2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801086b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086bb:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801086c2:	83 ca 60             	or     $0x60,%edx
801086c5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801086cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ce:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801086d5:	83 ca 80             	or     $0xffffff80,%edx
801086d8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801086de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801086e8:	83 ca 0f             	or     $0xf,%edx
801086eb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801086f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801086fb:	83 e2 ef             	and    $0xffffffef,%edx
801086fe:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108707:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010870e:	83 e2 df             	and    $0xffffffdf,%edx
80108711:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010871a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108721:	83 ca 40             	or     $0x40,%edx
80108724:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010872a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010872d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108734:	83 ca 80             	or     $0xffffff80,%edx
80108737:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010873d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108740:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874a:	05 b4 00 00 00       	add    $0xb4,%eax
8010874f:	89 c3                	mov    %eax,%ebx
80108751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108754:	05 b4 00 00 00       	add    $0xb4,%eax
80108759:	c1 e8 10             	shr    $0x10,%eax
8010875c:	89 c1                	mov    %eax,%ecx
8010875e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108761:	05 b4 00 00 00       	add    $0xb4,%eax
80108766:	c1 e8 18             	shr    $0x18,%eax
80108769:	89 c2                	mov    %eax,%edx
8010876b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876e:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108775:	00 00 
80108777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010877a:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108784:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010878a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010878d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108794:	83 e1 f0             	and    $0xfffffff0,%ecx
80108797:	83 c9 02             	or     $0x2,%ecx
8010879a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801087a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801087aa:	83 c9 10             	or     $0x10,%ecx
801087ad:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801087b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b6:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801087bd:	83 e1 9f             	and    $0xffffff9f,%ecx
801087c0:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801087c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087c9:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801087d0:	83 c9 80             	or     $0xffffff80,%ecx
801087d3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801087d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087dc:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801087e3:	83 e1 f0             	and    $0xfffffff0,%ecx
801087e6:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801087ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ef:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801087f6:	83 e1 ef             	and    $0xffffffef,%ecx
801087f9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801087ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108802:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108809:	83 e1 df             	and    $0xffffffdf,%ecx
8010880c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108815:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010881c:	83 c9 40             	or     $0x40,%ecx
8010881f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108828:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010882f:	83 c9 80             	or     $0xffffff80,%ecx
80108832:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010883b:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108844:	83 c0 70             	add    $0x70,%eax
80108847:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
8010884e:	00 
8010884f:	89 04 24             	mov    %eax,(%esp)
80108852:	e8 37 fb ff ff       	call   8010838e <lgdt>
  loadgs(SEG_KCPU << 3);
80108857:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010885e:	e8 6a fb ff ff       	call   801083cd <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108866:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010886c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108873:	00 00 00 00 
}
80108877:	83 c4 24             	add    $0x24,%esp
8010887a:	5b                   	pop    %ebx
8010887b:	5d                   	pop    %ebp
8010887c:	c3                   	ret    

8010887d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010887d:	55                   	push   %ebp
8010887e:	89 e5                	mov    %esp,%ebp
80108880:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108883:	8b 45 0c             	mov    0xc(%ebp),%eax
80108886:	c1 e8 16             	shr    $0x16,%eax
80108889:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108890:	8b 45 08             	mov    0x8(%ebp),%eax
80108893:	01 d0                	add    %edx,%eax
80108895:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108898:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010889b:	8b 00                	mov    (%eax),%eax
8010889d:	83 e0 01             	and    $0x1,%eax
801088a0:	85 c0                	test   %eax,%eax
801088a2:	74 17                	je     801088bb <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801088a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088a7:	8b 00                	mov    (%eax),%eax
801088a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088ae:	89 04 24             	mov    %eax,(%esp)
801088b1:	e8 44 fb ff ff       	call   801083fa <p2v>
801088b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801088b9:	eb 4b                	jmp    80108906 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801088bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801088bf:	74 0e                	je     801088cf <walkpgdir+0x52>
801088c1:	e8 2e a2 ff ff       	call   80102af4 <kalloc>
801088c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801088c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801088cd:	75 07                	jne    801088d6 <walkpgdir+0x59>
      return 0;
801088cf:	b8 00 00 00 00       	mov    $0x0,%eax
801088d4:	eb 47                	jmp    8010891d <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801088d6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088dd:	00 
801088de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801088e5:	00 
801088e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e9:	89 04 24             	mov    %eax,(%esp)
801088ec:	e8 08 d5 ff ff       	call   80105df9 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801088f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088f4:	89 04 24             	mov    %eax,(%esp)
801088f7:	e8 f1 fa ff ff       	call   801083ed <v2p>
801088fc:	83 c8 07             	or     $0x7,%eax
801088ff:	89 c2                	mov    %eax,%edx
80108901:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108904:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108906:	8b 45 0c             	mov    0xc(%ebp),%eax
80108909:	c1 e8 0c             	shr    $0xc,%eax
8010890c:	25 ff 03 00 00       	and    $0x3ff,%eax
80108911:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891b:	01 d0                	add    %edx,%eax
}
8010891d:	c9                   	leave  
8010891e:	c3                   	ret    

8010891f <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010891f:	55                   	push   %ebp
80108920:	89 e5                	mov    %esp,%ebp
80108922:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108925:	8b 45 0c             	mov    0xc(%ebp),%eax
80108928:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010892d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108930:	8b 55 0c             	mov    0xc(%ebp),%edx
80108933:	8b 45 10             	mov    0x10(%ebp),%eax
80108936:	01 d0                	add    %edx,%eax
80108938:	83 e8 01             	sub    $0x1,%eax
8010893b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108940:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108943:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010894a:	00 
8010894b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010894e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108952:	8b 45 08             	mov    0x8(%ebp),%eax
80108955:	89 04 24             	mov    %eax,(%esp)
80108958:	e8 20 ff ff ff       	call   8010887d <walkpgdir>
8010895d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108964:	75 07                	jne    8010896d <mappages+0x4e>
      return -1;
80108966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010896b:	eb 48                	jmp    801089b5 <mappages+0x96>
    if(*pte & PTE_P)
8010896d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108970:	8b 00                	mov    (%eax),%eax
80108972:	83 e0 01             	and    $0x1,%eax
80108975:	85 c0                	test   %eax,%eax
80108977:	74 0c                	je     80108985 <mappages+0x66>
      panic("remap");
80108979:	c7 04 24 24 98 10 80 	movl   $0x80109824,(%esp)
80108980:	e8 b5 7b ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80108985:	8b 45 18             	mov    0x18(%ebp),%eax
80108988:	0b 45 14             	or     0x14(%ebp),%eax
8010898b:	83 c8 01             	or     $0x1,%eax
8010898e:	89 c2                	mov    %eax,%edx
80108990:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108993:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108998:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010899b:	75 08                	jne    801089a5 <mappages+0x86>
      break;
8010899d:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010899e:	b8 00 00 00 00       	mov    $0x0,%eax
801089a3:	eb 10                	jmp    801089b5 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801089a5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801089ac:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801089b3:	eb 8e                	jmp    80108943 <mappages+0x24>
  return 0;
}
801089b5:	c9                   	leave  
801089b6:	c3                   	ret    

801089b7 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801089b7:	55                   	push   %ebp
801089b8:	89 e5                	mov    %esp,%ebp
801089ba:	53                   	push   %ebx
801089bb:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801089be:	e8 31 a1 ff ff       	call   80102af4 <kalloc>
801089c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801089c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089ca:	75 0a                	jne    801089d6 <setupkvm+0x1f>
    return 0;
801089cc:	b8 00 00 00 00       	mov    $0x0,%eax
801089d1:	e9 98 00 00 00       	jmp    80108a6e <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801089d6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801089dd:	00 
801089de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801089e5:	00 
801089e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e9:	89 04 24             	mov    %eax,(%esp)
801089ec:	e8 08 d4 ff ff       	call   80105df9 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801089f1:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801089f8:	e8 fd f9 ff ff       	call   801083fa <p2v>
801089fd:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108a02:	76 0c                	jbe    80108a10 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108a04:	c7 04 24 2a 98 10 80 	movl   $0x8010982a,(%esp)
80108a0b:	e8 2a 7b ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108a10:	c7 45 f4 20 c5 10 80 	movl   $0x8010c520,-0xc(%ebp)
80108a17:	eb 49                	jmp    80108a62 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1c:	8b 48 0c             	mov    0xc(%eax),%ecx
80108a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a22:	8b 50 04             	mov    0x4(%eax),%edx
80108a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a28:	8b 58 08             	mov    0x8(%eax),%ebx
80108a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a2e:	8b 40 04             	mov    0x4(%eax),%eax
80108a31:	29 c3                	sub    %eax,%ebx
80108a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a36:	8b 00                	mov    (%eax),%eax
80108a38:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108a3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108a40:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108a44:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a4b:	89 04 24             	mov    %eax,(%esp)
80108a4e:	e8 cc fe ff ff       	call   8010891f <mappages>
80108a53:	85 c0                	test   %eax,%eax
80108a55:	79 07                	jns    80108a5e <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108a57:	b8 00 00 00 00       	mov    $0x0,%eax
80108a5c:	eb 10                	jmp    80108a6e <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108a5e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108a62:	81 7d f4 60 c5 10 80 	cmpl   $0x8010c560,-0xc(%ebp)
80108a69:	72 ae                	jb     80108a19 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108a6e:	83 c4 34             	add    $0x34,%esp
80108a71:	5b                   	pop    %ebx
80108a72:	5d                   	pop    %ebp
80108a73:	c3                   	ret    

80108a74 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108a74:	55                   	push   %ebp
80108a75:	89 e5                	mov    %esp,%ebp
80108a77:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108a7a:	e8 38 ff ff ff       	call   801089b7 <setupkvm>
80108a7f:	a3 78 a0 11 80       	mov    %eax,0x8011a078
  switchkvm();
80108a84:	e8 02 00 00 00       	call   80108a8b <switchkvm>
}
80108a89:	c9                   	leave  
80108a8a:	c3                   	ret    

80108a8b <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108a8b:	55                   	push   %ebp
80108a8c:	89 e5                	mov    %esp,%ebp
80108a8e:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108a91:	a1 78 a0 11 80       	mov    0x8011a078,%eax
80108a96:	89 04 24             	mov    %eax,(%esp)
80108a99:	e8 4f f9 ff ff       	call   801083ed <v2p>
80108a9e:	89 04 24             	mov    %eax,(%esp)
80108aa1:	e8 3c f9 ff ff       	call   801083e2 <lcr3>
}
80108aa6:	c9                   	leave  
80108aa7:	c3                   	ret    

80108aa8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108aa8:	55                   	push   %ebp
80108aa9:	89 e5                	mov    %esp,%ebp
80108aab:	53                   	push   %ebx
80108aac:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108aaf:	e8 45 d2 ff ff       	call   80105cf9 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108ab4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108aba:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108ac1:	83 c2 08             	add    $0x8,%edx
80108ac4:	89 d3                	mov    %edx,%ebx
80108ac6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108acd:	83 c2 08             	add    $0x8,%edx
80108ad0:	c1 ea 10             	shr    $0x10,%edx
80108ad3:	89 d1                	mov    %edx,%ecx
80108ad5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108adc:	83 c2 08             	add    $0x8,%edx
80108adf:	c1 ea 18             	shr    $0x18,%edx
80108ae2:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108ae9:	67 00 
80108aeb:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108af2:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108af8:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108aff:	83 e1 f0             	and    $0xfffffff0,%ecx
80108b02:	83 c9 09             	or     $0x9,%ecx
80108b05:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108b0b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108b12:	83 c9 10             	or     $0x10,%ecx
80108b15:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108b1b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108b22:	83 e1 9f             	and    $0xffffff9f,%ecx
80108b25:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108b2b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108b32:	83 c9 80             	or     $0xffffff80,%ecx
80108b35:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108b3b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108b42:	83 e1 f0             	and    $0xfffffff0,%ecx
80108b45:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108b4b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108b52:	83 e1 ef             	and    $0xffffffef,%ecx
80108b55:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108b5b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108b62:	83 e1 df             	and    $0xffffffdf,%ecx
80108b65:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108b6b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108b72:	83 c9 40             	or     $0x40,%ecx
80108b75:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108b7b:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108b82:	83 e1 7f             	and    $0x7f,%ecx
80108b85:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108b8b:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108b91:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108b97:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108b9e:	83 e2 ef             	and    $0xffffffef,%edx
80108ba1:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108ba7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108bad:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108bb3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108bb9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108bc0:	8b 52 08             	mov    0x8(%edx),%edx
80108bc3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108bc9:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108bcc:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108bd3:	e8 df f7 ff ff       	call   801083b7 <ltr>
  if(p->pgdir == 0)
80108bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80108bdb:	8b 40 04             	mov    0x4(%eax),%eax
80108bde:	85 c0                	test   %eax,%eax
80108be0:	75 0c                	jne    80108bee <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80108be2:	c7 04 24 3b 98 10 80 	movl   $0x8010983b,(%esp)
80108be9:	e8 4c 79 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108bee:	8b 45 08             	mov    0x8(%ebp),%eax
80108bf1:	8b 40 04             	mov    0x4(%eax),%eax
80108bf4:	89 04 24             	mov    %eax,(%esp)
80108bf7:	e8 f1 f7 ff ff       	call   801083ed <v2p>
80108bfc:	89 04 24             	mov    %eax,(%esp)
80108bff:	e8 de f7 ff ff       	call   801083e2 <lcr3>
  popcli();
80108c04:	e8 34 d1 ff ff       	call   80105d3d <popcli>
}
80108c09:	83 c4 14             	add    $0x14,%esp
80108c0c:	5b                   	pop    %ebx
80108c0d:	5d                   	pop    %ebp
80108c0e:	c3                   	ret    

80108c0f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108c0f:	55                   	push   %ebp
80108c10:	89 e5                	mov    %esp,%ebp
80108c12:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108c15:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108c1c:	76 0c                	jbe    80108c2a <inituvm+0x1b>
    panic("inituvm: more than a page");
80108c1e:	c7 04 24 4f 98 10 80 	movl   $0x8010984f,(%esp)
80108c25:	e8 10 79 ff ff       	call   8010053a <panic>
  mem = kalloc();
80108c2a:	e8 c5 9e ff ff       	call   80102af4 <kalloc>
80108c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108c32:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c39:	00 
80108c3a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108c41:	00 
80108c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c45:	89 04 24             	mov    %eax,(%esp)
80108c48:	e8 ac d1 ff ff       	call   80105df9 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c50:	89 04 24             	mov    %eax,(%esp)
80108c53:	e8 95 f7 ff ff       	call   801083ed <v2p>
80108c58:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108c5f:	00 
80108c60:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c6b:	00 
80108c6c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108c73:	00 
80108c74:	8b 45 08             	mov    0x8(%ebp),%eax
80108c77:	89 04 24             	mov    %eax,(%esp)
80108c7a:	e8 a0 fc ff ff       	call   8010891f <mappages>
  memmove(mem, init, sz);
80108c7f:	8b 45 10             	mov    0x10(%ebp),%eax
80108c82:	89 44 24 08          	mov    %eax,0x8(%esp)
80108c86:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c89:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c90:	89 04 24             	mov    %eax,(%esp)
80108c93:	e8 30 d2 ff ff       	call   80105ec8 <memmove>
}
80108c98:	c9                   	leave  
80108c99:	c3                   	ret    

80108c9a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108c9a:	55                   	push   %ebp
80108c9b:	89 e5                	mov    %esp,%ebp
80108c9d:	53                   	push   %ebx
80108c9e:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ca4:	25 ff 0f 00 00       	and    $0xfff,%eax
80108ca9:	85 c0                	test   %eax,%eax
80108cab:	74 0c                	je     80108cb9 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108cad:	c7 04 24 6c 98 10 80 	movl   $0x8010986c,(%esp)
80108cb4:	e8 81 78 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108cb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108cc0:	e9 a9 00 00 00       	jmp    80108d6e <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80108ccb:	01 d0                	add    %edx,%eax
80108ccd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108cd4:	00 
80108cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80108cdc:	89 04 24             	mov    %eax,(%esp)
80108cdf:	e8 99 fb ff ff       	call   8010887d <walkpgdir>
80108ce4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108ce7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ceb:	75 0c                	jne    80108cf9 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108ced:	c7 04 24 8f 98 10 80 	movl   $0x8010988f,(%esp)
80108cf4:	e8 41 78 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cfc:	8b 00                	mov    (%eax),%eax
80108cfe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d03:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d09:	8b 55 18             	mov    0x18(%ebp),%edx
80108d0c:	29 c2                	sub    %eax,%edx
80108d0e:	89 d0                	mov    %edx,%eax
80108d10:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108d15:	77 0f                	ja     80108d26 <loaduvm+0x8c>
      n = sz - i;
80108d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1a:	8b 55 18             	mov    0x18(%ebp),%edx
80108d1d:	29 c2                	sub    %eax,%edx
80108d1f:	89 d0                	mov    %edx,%eax
80108d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108d24:	eb 07                	jmp    80108d2d <loaduvm+0x93>
    else
      n = PGSIZE;
80108d26:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d30:	8b 55 14             	mov    0x14(%ebp),%edx
80108d33:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d39:	89 04 24             	mov    %eax,(%esp)
80108d3c:	e8 b9 f6 ff ff       	call   801083fa <p2v>
80108d41:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108d44:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108d48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d50:	8b 45 10             	mov    0x10(%ebp),%eax
80108d53:	89 04 24             	mov    %eax,(%esp)
80108d56:	e8 1f 90 ff ff       	call   80101d7a <readi>
80108d5b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108d5e:	74 07                	je     80108d67 <loaduvm+0xcd>
      return -1;
80108d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d65:	eb 18                	jmp    80108d7f <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108d67:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d71:	3b 45 18             	cmp    0x18(%ebp),%eax
80108d74:	0f 82 4b ff ff ff    	jb     80108cc5 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d7f:	83 c4 24             	add    $0x24,%esp
80108d82:	5b                   	pop    %ebx
80108d83:	5d                   	pop    %ebp
80108d84:	c3                   	ret    

80108d85 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108d85:	55                   	push   %ebp
80108d86:	89 e5                	mov    %esp,%ebp
80108d88:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108d8b:	8b 45 10             	mov    0x10(%ebp),%eax
80108d8e:	85 c0                	test   %eax,%eax
80108d90:	79 0a                	jns    80108d9c <allocuvm+0x17>
    return 0;
80108d92:	b8 00 00 00 00       	mov    $0x0,%eax
80108d97:	e9 c1 00 00 00       	jmp    80108e5d <allocuvm+0xd8>
  if(newsz < oldsz)
80108d9c:	8b 45 10             	mov    0x10(%ebp),%eax
80108d9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108da2:	73 08                	jae    80108dac <allocuvm+0x27>
    return oldsz;
80108da4:	8b 45 0c             	mov    0xc(%ebp),%eax
80108da7:	e9 b1 00 00 00       	jmp    80108e5d <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80108daf:	05 ff 0f 00 00       	add    $0xfff,%eax
80108db4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108dbc:	e9 8d 00 00 00       	jmp    80108e4e <allocuvm+0xc9>
    mem = kalloc();
80108dc1:	e8 2e 9d ff ff       	call   80102af4 <kalloc>
80108dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108dc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108dcd:	75 2c                	jne    80108dfb <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108dcf:	c7 04 24 ad 98 10 80 	movl   $0x801098ad,(%esp)
80108dd6:	e8 c5 75 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dde:	89 44 24 08          	mov    %eax,0x8(%esp)
80108de2:	8b 45 10             	mov    0x10(%ebp),%eax
80108de5:	89 44 24 04          	mov    %eax,0x4(%esp)
80108de9:	8b 45 08             	mov    0x8(%ebp),%eax
80108dec:	89 04 24             	mov    %eax,(%esp)
80108def:	e8 6b 00 00 00       	call   80108e5f <deallocuvm>
      return 0;
80108df4:	b8 00 00 00 00       	mov    $0x0,%eax
80108df9:	eb 62                	jmp    80108e5d <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108dfb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108e02:	00 
80108e03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108e0a:	00 
80108e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e0e:	89 04 24             	mov    %eax,(%esp)
80108e11:	e8 e3 cf ff ff       	call   80105df9 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e19:	89 04 24             	mov    %eax,(%esp)
80108e1c:	e8 cc f5 ff ff       	call   801083ed <v2p>
80108e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108e24:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108e2b:	00 
80108e2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108e30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108e37:	00 
80108e38:	89 54 24 04          	mov    %edx,0x4(%esp)
80108e3c:	8b 45 08             	mov    0x8(%ebp),%eax
80108e3f:	89 04 24             	mov    %eax,(%esp)
80108e42:	e8 d8 fa ff ff       	call   8010891f <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108e47:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e51:	3b 45 10             	cmp    0x10(%ebp),%eax
80108e54:	0f 82 67 ff ff ff    	jb     80108dc1 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108e5a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108e5d:	c9                   	leave  
80108e5e:	c3                   	ret    

80108e5f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108e5f:	55                   	push   %ebp
80108e60:	89 e5                	mov    %esp,%ebp
80108e62:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108e65:	8b 45 10             	mov    0x10(%ebp),%eax
80108e68:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108e6b:	72 08                	jb     80108e75 <deallocuvm+0x16>
    return oldsz;
80108e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e70:	e9 a4 00 00 00       	jmp    80108f19 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108e75:	8b 45 10             	mov    0x10(%ebp),%eax
80108e78:	05 ff 0f 00 00       	add    $0xfff,%eax
80108e7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108e85:	e9 80 00 00 00       	jmp    80108f0a <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e8d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108e94:	00 
80108e95:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e99:	8b 45 08             	mov    0x8(%ebp),%eax
80108e9c:	89 04 24             	mov    %eax,(%esp)
80108e9f:	e8 d9 f9 ff ff       	call   8010887d <walkpgdir>
80108ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108ea7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108eab:	75 09                	jne    80108eb6 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108ead:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108eb4:	eb 4d                	jmp    80108f03 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108eb9:	8b 00                	mov    (%eax),%eax
80108ebb:	83 e0 01             	and    $0x1,%eax
80108ebe:	85 c0                	test   %eax,%eax
80108ec0:	74 41                	je     80108f03 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ec5:	8b 00                	mov    (%eax),%eax
80108ec7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108ecf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ed3:	75 0c                	jne    80108ee1 <deallocuvm+0x82>
        panic("kfree");
80108ed5:	c7 04 24 c5 98 10 80 	movl   $0x801098c5,(%esp)
80108edc:	e8 59 76 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ee4:	89 04 24             	mov    %eax,(%esp)
80108ee7:	e8 0e f5 ff ff       	call   801083fa <p2v>
80108eec:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ef2:	89 04 24             	mov    %eax,(%esp)
80108ef5:	e8 61 9b ff ff       	call   80102a5b <kfree>
      *pte = 0;
80108efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108f03:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f0d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108f10:	0f 82 74 ff ff ff    	jb     80108e8a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108f16:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108f19:	c9                   	leave  
80108f1a:	c3                   	ret    

80108f1b <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108f1b:	55                   	push   %ebp
80108f1c:	89 e5                	mov    %esp,%ebp
80108f1e:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108f21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108f25:	75 0c                	jne    80108f33 <freevm+0x18>
    panic("freevm: no pgdir");
80108f27:	c7 04 24 cb 98 10 80 	movl   $0x801098cb,(%esp)
80108f2e:	e8 07 76 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108f33:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108f3a:	00 
80108f3b:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108f42:	80 
80108f43:	8b 45 08             	mov    0x8(%ebp),%eax
80108f46:	89 04 24             	mov    %eax,(%esp)
80108f49:	e8 11 ff ff ff       	call   80108e5f <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108f55:	eb 48                	jmp    80108f9f <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108f61:	8b 45 08             	mov    0x8(%ebp),%eax
80108f64:	01 d0                	add    %edx,%eax
80108f66:	8b 00                	mov    (%eax),%eax
80108f68:	83 e0 01             	and    $0x1,%eax
80108f6b:	85 c0                	test   %eax,%eax
80108f6d:	74 2c                	je     80108f9b <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108f79:	8b 45 08             	mov    0x8(%ebp),%eax
80108f7c:	01 d0                	add    %edx,%eax
80108f7e:	8b 00                	mov    (%eax),%eax
80108f80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f85:	89 04 24             	mov    %eax,(%esp)
80108f88:	e8 6d f4 ff ff       	call   801083fa <p2v>
80108f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f93:	89 04 24             	mov    %eax,(%esp)
80108f96:	e8 c0 9a ff ff       	call   80102a5b <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108f9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108f9f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108fa6:	76 af                	jbe    80108f57 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80108fab:	89 04 24             	mov    %eax,(%esp)
80108fae:	e8 a8 9a ff ff       	call   80102a5b <kfree>
}
80108fb3:	c9                   	leave  
80108fb4:	c3                   	ret    

80108fb5 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108fb5:	55                   	push   %ebp
80108fb6:	89 e5                	mov    %esp,%ebp
80108fb8:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108fbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108fc2:	00 
80108fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80108fca:	8b 45 08             	mov    0x8(%ebp),%eax
80108fcd:	89 04 24             	mov    %eax,(%esp)
80108fd0:	e8 a8 f8 ff ff       	call   8010887d <walkpgdir>
80108fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108fd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108fdc:	75 0c                	jne    80108fea <clearpteu+0x35>
    panic("clearpteu");
80108fde:	c7 04 24 dc 98 10 80 	movl   $0x801098dc,(%esp)
80108fe5:	e8 50 75 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fed:	8b 00                	mov    (%eax),%eax
80108fef:	83 e0 fb             	and    $0xfffffffb,%eax
80108ff2:	89 c2                	mov    %eax,%edx
80108ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff7:	89 10                	mov    %edx,(%eax)
}
80108ff9:	c9                   	leave  
80108ffa:	c3                   	ret    

80108ffb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108ffb:	55                   	push   %ebp
80108ffc:	89 e5                	mov    %esp,%ebp
80108ffe:	53                   	push   %ebx
80108fff:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109002:	e8 b0 f9 ff ff       	call   801089b7 <setupkvm>
80109007:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010900a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010900e:	75 0a                	jne    8010901a <copyuvm+0x1f>
    return 0;
80109010:	b8 00 00 00 00       	mov    $0x0,%eax
80109015:	e9 fd 00 00 00       	jmp    80109117 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
8010901a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109021:	e9 d0 00 00 00       	jmp    801090f6 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109029:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80109030:	00 
80109031:	89 44 24 04          	mov    %eax,0x4(%esp)
80109035:	8b 45 08             	mov    0x8(%ebp),%eax
80109038:	89 04 24             	mov    %eax,(%esp)
8010903b:	e8 3d f8 ff ff       	call   8010887d <walkpgdir>
80109040:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109043:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109047:	75 0c                	jne    80109055 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80109049:	c7 04 24 e6 98 10 80 	movl   $0x801098e6,(%esp)
80109050:	e8 e5 74 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80109055:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109058:	8b 00                	mov    (%eax),%eax
8010905a:	83 e0 01             	and    $0x1,%eax
8010905d:	85 c0                	test   %eax,%eax
8010905f:	75 0c                	jne    8010906d <copyuvm+0x72>
      panic("copyuvm: page not present");
80109061:	c7 04 24 00 99 10 80 	movl   $0x80109900,(%esp)
80109068:	e8 cd 74 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
8010906d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109070:	8b 00                	mov    (%eax),%eax
80109072:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109077:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010907a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010907d:	8b 00                	mov    (%eax),%eax
8010907f:	25 ff 0f 00 00       	and    $0xfff,%eax
80109084:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109087:	e8 68 9a ff ff       	call   80102af4 <kalloc>
8010908c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010908f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109093:	75 02                	jne    80109097 <copyuvm+0x9c>
      goto bad;
80109095:	eb 70                	jmp    80109107 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109097:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010909a:	89 04 24             	mov    %eax,(%esp)
8010909d:	e8 58 f3 ff ff       	call   801083fa <p2v>
801090a2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801090a9:	00 
801090aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801090ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090b1:	89 04 24             	mov    %eax,(%esp)
801090b4:	e8 0f ce ff ff       	call   80105ec8 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801090b9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801090bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801090bf:	89 04 24             	mov    %eax,(%esp)
801090c2:	e8 26 f3 ff ff       	call   801083ed <v2p>
801090c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801090ca:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801090ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
801090d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801090d9:	00 
801090da:	89 54 24 04          	mov    %edx,0x4(%esp)
801090de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090e1:	89 04 24             	mov    %eax,(%esp)
801090e4:	e8 36 f8 ff ff       	call   8010891f <mappages>
801090e9:	85 c0                	test   %eax,%eax
801090eb:	79 02                	jns    801090ef <copyuvm+0xf4>
      goto bad;
801090ed:	eb 18                	jmp    80109107 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801090ef:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801090f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801090fc:	0f 82 24 ff ff ff    	jb     80109026 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109102:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109105:	eb 10                	jmp    80109117 <copyuvm+0x11c>

bad:
  freevm(d);
80109107:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010910a:	89 04 24             	mov    %eax,(%esp)
8010910d:	e8 09 fe ff ff       	call   80108f1b <freevm>
  return 0;
80109112:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109117:	83 c4 44             	add    $0x44,%esp
8010911a:	5b                   	pop    %ebx
8010911b:	5d                   	pop    %ebp
8010911c:	c3                   	ret    

8010911d <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010911d:	55                   	push   %ebp
8010911e:	89 e5                	mov    %esp,%ebp
80109120:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109123:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010912a:	00 
8010912b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010912e:	89 44 24 04          	mov    %eax,0x4(%esp)
80109132:	8b 45 08             	mov    0x8(%ebp),%eax
80109135:	89 04 24             	mov    %eax,(%esp)
80109138:	e8 40 f7 ff ff       	call   8010887d <walkpgdir>
8010913d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109143:	8b 00                	mov    (%eax),%eax
80109145:	83 e0 01             	and    $0x1,%eax
80109148:	85 c0                	test   %eax,%eax
8010914a:	75 07                	jne    80109153 <uva2ka+0x36>
    return 0;
8010914c:	b8 00 00 00 00       	mov    $0x0,%eax
80109151:	eb 25                	jmp    80109178 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80109153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109156:	8b 00                	mov    (%eax),%eax
80109158:	83 e0 04             	and    $0x4,%eax
8010915b:	85 c0                	test   %eax,%eax
8010915d:	75 07                	jne    80109166 <uva2ka+0x49>
    return 0;
8010915f:	b8 00 00 00 00       	mov    $0x0,%eax
80109164:	eb 12                	jmp    80109178 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80109166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109169:	8b 00                	mov    (%eax),%eax
8010916b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109170:	89 04 24             	mov    %eax,(%esp)
80109173:	e8 82 f2 ff ff       	call   801083fa <p2v>
}
80109178:	c9                   	leave  
80109179:	c3                   	ret    

8010917a <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010917a:	55                   	push   %ebp
8010917b:	89 e5                	mov    %esp,%ebp
8010917d:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109180:	8b 45 10             	mov    0x10(%ebp),%eax
80109183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109186:	e9 87 00 00 00       	jmp    80109212 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010918b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010918e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109193:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109196:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109199:	89 44 24 04          	mov    %eax,0x4(%esp)
8010919d:	8b 45 08             	mov    0x8(%ebp),%eax
801091a0:	89 04 24             	mov    %eax,(%esp)
801091a3:	e8 75 ff ff ff       	call   8010911d <uva2ka>
801091a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801091ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801091af:	75 07                	jne    801091b8 <copyout+0x3e>
      return -1;
801091b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801091b6:	eb 69                	jmp    80109221 <copyout+0xa7>
    n = PGSIZE - (va - va0);
801091b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801091bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801091be:	29 c2                	sub    %eax,%edx
801091c0:	89 d0                	mov    %edx,%eax
801091c2:	05 00 10 00 00       	add    $0x1000,%eax
801091c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801091ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091cd:	3b 45 14             	cmp    0x14(%ebp),%eax
801091d0:	76 06                	jbe    801091d8 <copyout+0x5e>
      n = len;
801091d2:	8b 45 14             	mov    0x14(%ebp),%eax
801091d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801091d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091db:	8b 55 0c             	mov    0xc(%ebp),%edx
801091de:	29 c2                	sub    %eax,%edx
801091e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801091e3:	01 c2                	add    %eax,%edx
801091e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091e8:	89 44 24 08          	mov    %eax,0x8(%esp)
801091ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801091f3:	89 14 24             	mov    %edx,(%esp)
801091f6:	e8 cd cc ff ff       	call   80105ec8 <memmove>
    len -= n;
801091fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091fe:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109201:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109204:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109207:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010920a:	05 00 10 00 00       	add    $0x1000,%eax
8010920f:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109212:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109216:	0f 85 6f ff ff ff    	jne    8010918b <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010921c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109221:	c9                   	leave  
80109222:	c3                   	ret    
