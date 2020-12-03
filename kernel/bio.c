// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKETS 13

/* old bcache
struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  struct buf head;
} bcache;
*/

struct {
	struct spinlock lock[NBUCKETS];
	struct buf buf[NBUF];

	// Linked list of all buffers, through prev/next.
	// head.next is most recently used.
	struct buf hashbucket[NBUCKETS]; //head
} bcache;

/* old binit()
void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
	b->next = bcache.head.next;
	b->prev = &bcache.head;
	initsleeplock(&b->lock, "buffer");
	bcache.head.next->prev = b;
	bcache.head.next = b;
  }
}
*/

void
binit(void)
{
	struct buf *b;

	for (int i = 0; i < NBUCKETS; i++) {
		initlock(&bcache.lock[i], "bcache");
		bcache.hashbucket[i].prev = &bcache.hashbucket[i];
		bcache.hashbucket[i].next = &bcache.hashbucket[i];
	}

	// Create linked list of buffers
	
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
		b->next = bcache.hashbucket[0].next;
		b->prev = &bcache.hashbucket[0];
		initsleeplock(&b->lock, "buffer");
		bcache.hashbucket[0].next->prev = b;
		bcache.hashbucket[0].next = b;
	}
}


// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.

/* old 
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached; recycle an unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
}
*/

static struct buf*
bget(uint dev, uint blockno)
{
	struct buf *b;
	int hashno = blockno % NBUCKETS;
	int next_hashno = (blockno + 1) % NBUCKETS;

	acquire(&bcache.lock[hashno]);

	// Is the block already cached?
	for (b = bcache.hashbucket[hashno].next; b != &bcache.hashbucket[hashno]; b = b->next) {
		if (b->dev == dev && b->blockno == blockno) {
			b->refcnt++;
			release(&bcache.lock[hashno]);
			acquiresleep(&b->lock);
			return b;
		}
	}

	//这个bucket中没找到，就去下个bucket找
	//直到找完整个bucket（一个轮回）
	for (; next_hashno != hashno; release(&bcache.lock[next_hashno]), next_hashno = (next_hashno + 1) % NBUCKETS) {
		acquire(&bcache.lock[next_hashno]);
		for (b = bcache.hashbucket[next_hashno].next; b != &bcache.hashbucket[next_hashno]; b = b->next) {
			if (b->refcnt == 0) {
				b->dev = dev;
				b->blockno = blockno;
				b->valid = 0;
				b->refcnt = 1;
				b->next->prev = b->prev;
				b->prev->next = b->next;
				release(&bcache.lock[next_hashno]);
				b->next = bcache.hashbucket[hashno].next;
				b->prev = &bcache.hashbucket[hashno];
				bcache.hashbucket[hashno].next->prev = b;
				bcache.hashbucket[hashno].next = b;
				release(&bcache.lock[hashno]);
				acquiresleep(&b->lock);
				return b;
			}
		}
	}
	panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
}

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int hashno = (b->blockno) % NBUCKETS;

  acquire(&bcache.lock[hashno]);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.hashbucket[hashno].next;
    b->prev = &bcache.hashbucket[hashno];
    bcache.hashbucket[hashno].next->prev = b;
    bcache.hashbucket[hashno].next = b;
  }
  
  release(&bcache.lock[hashno]);
}

void
bpin(struct buf *b) {

  int hashno = (b->blockno) % NBUCKETS;

  acquire(&bcache.lock[hashno]);
  b->refcnt++;
  release(&bcache.lock[hashno]);
}

void
bunpin(struct buf *b) {

  int hashno = (b->blockno) % NBUCKETS;

  acquire(&bcache.lock[hashno]);
  b->refcnt--;
  release(&bcache.lock[hashno]);
}


