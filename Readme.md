# JMP
---

Reads bytes from stdin and executes the bytes.

## Build: X64/AMD64

```bash
nasm -f elf64 x64/jmp.asm -o jmp.o &&
ld.gold jmp.o -o jmp;chmod a+x ./jmp &&
rm jmp.o
```
## Build: AARCH64

```bash
as -o jmp.o aarch64/jmp.asm &&
ld -o jmp ./jmp.o &&
rm jmp.o
```
## Testing

### Infinite loop: X64

```bash
echo 9090e9f9ffffff | xxd -ps -r > 2
./jmp < 2
```

### Infinite loop: AARCH64

```bash
echo 00000014 | xxd -ps -r > 2
./jmp < 2
```

### Very large shell code with infinite loop: X64

```bash
python -c 'print("90"*5000000,"9090e9f9ffffff")' > stress
cat stress | xxd -ps -r > strss
./jmp < strss
```
