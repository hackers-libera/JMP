.global _start
.text
_start:
  mov x28, sp // save sp for argc/argv lookup
  eor x0, x0, x0
  ldr x1, =0xA000000
  mov x2, #0x7
  mov x3, #0x22
  mov x4, #-1
  mov x8, #0xde
  svc #0x1

  cmp x0, #-1 // mmap failed?
  b.eq err

  mov x20, x0 // save mmap'ed addr
  eor x26, x26, x26 // stdin = 0 by default

  ldr x18, [x28] // argc
  cmp x18, 1
  b.le call_read // argc < 2, just use stdin

  call_openat:
  mov x3, 4 // O_RDONLY
  eor x2, x2, x2 // no flags
  ldr x1, [x28,#16] // argv[1]
  mov x0, #-0x64 // AT_FDCWD
  mov x8, #0x38  // openat()
  svc #1

  cmp x0, #-1
  b.le err
  mov x26, x0 // opened fd

  call_read:
  mov x0, x26
  mov x1, x20
  ldr x2, =0xA000000
  mov x8, #0x3f // read
  svc #0x1

  cmp x0, 1
  b.le err
  
  blr x20

  eor x0, x0, x0
  mov x8, #0x5e
  svc #0x1

err:
  mov x0, #-1
  mov x8, #0x5e
  svc 0x1
