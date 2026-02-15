section .data
  buffer_size dq 10485760 ; Fixed buffer size for now
section .text
  global _start

_start:
  xor rdi, rdi ; address
  xor r9, r9
  mov rsi, [buffer_size] ; buffer size, see .data
  mov rdx, 7 ; protection == rwx
  mov r10, 0x22 ; flags
  mov r8, -1 ; fd
  mov rax, 9 ; mmap
  syscall

  cmp rax, -1 ; mmap failed
  je err

  mov rbp, rax ; save allocated memory addr to rbp
  mov rsi, rbp ; buffer to read into
  xor rax, rax ; read() == 0
  mov rdi, 0   ; read from stdin == 0
  mov rdx, [buffer_size] ; read up to buffer_size
  syscall
  cmp rax, 0
  jle err      ; if read bytes < 1 == exit with err

  jmp rbp      ; jmp to read data

  mov rax, 60  ; exit()
  xor rdi, rdi ; exit code == 0
  syscall

err:
  mov rax, 60
  mov rdi, -1 ; exit code = -1 when there is an err
  syscall
