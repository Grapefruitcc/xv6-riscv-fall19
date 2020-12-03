// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "defs.h"

#define NCPU 8 //Actually 3

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct kmem {
  struct spinlock lock;
  struct run *freelist;
};

//New struct kmems[]
struct kmem kmems[NCPU];
//End

/* old kinit()
void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}
*/

//My kinit
void
kinit(){
	int i = 0;
	for (i = 0; i < NCPU; i++) {
		initlock(&kmems[i].lock, "kmem");
	}
	freerange(end, (void*)PHYSTOP);
}
//My kinit end

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)

/* old kfree
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
*/
void
kfree(void *pa)
{
	struct run *r;
	push_off();
	int id = cpuid();
	pop_off();

	if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
		panic("kfree");

	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);

	r = (struct run*)pa;

	acquire(&kmems[id].lock);
	r->next = kmems[id].freelist;
	kmems[id].freelist = r;
	release(&kmems[id].lock);
}
//My kfree
//My kfree end

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.

/* old kalloc()
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
*/

//My kalloc
void *
kalloc(void)
{
	struct run *r;
	push_off();
	int id = cpuid();
	pop_off();
	int i = 0;

	acquire(&kmems[id].lock);
	r = kmems[id].freelist;
	if (r)
		kmems[id].freelist = r->next;
	release(&kmems[id].lock);

	if (!r) {
		for (i = 0; i < NCPU; i++) {
			acquire(&kmems[i].lock);
			r = kmems[i].freelist;
			if (r)
				kmems[i].freelist = r->next;
			release(&kmems[i].lock);
			if (r)
				break;
		}
	}

	if (r)
		memset((char*)r, 5, PGSIZE); // fill with junk
	return (void*)r;
}
//My kalloc end
