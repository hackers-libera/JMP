.global _start
.text
_start:
  eor x0, x0, x0
  ldr x1, =0xA000000 // hard-coded buffer sizer for now
  mov x2, #0x7
  mov x3, #0x22
  mov x4, #-1
  mov x8, #0xde
  svc #0x1

  cmp x0, #-1 // mmap failed?
  b.eq err

  mov x20, x0
  mov x1, x0
  eor x0, x0, x0 // stdin = 0
  ldr x2, =0xA000000
  mov x8, #0x3f
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
