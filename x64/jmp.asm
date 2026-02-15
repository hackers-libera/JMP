section .data
  buffer_size dq 10485760 ; Fixed buffer size for now
section .text
  global _start

_start:
  mov rbx, rsp ; save argc/argv ptr
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

  xor rdi, rdi   ; read from stdin == 0
  mov rbp, rax ; save allocated memory addr to rbp

  cmp byte [rbx], 2
  jl call_read ; argc < 2, just use stdin

  call_open:
  mov rdx, 4 ; O_RDONLY
  xor rsi, rsi ; no flags
  mov rdi, [rbx+16] ; argv[1]
  mov rax, 2 ; open()
  syscall

  cmp rax, -1
  jle err
  mov rdi, rax ; opened fd

  call_read:
  mov rsi, rbp ; buffer to read into
  xor rax, rax ; read() == 0
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
