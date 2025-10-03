section .bss
buf:    resb 5

section .text
global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jl      exit1

    mov     rsi, [rsp+16]       ; argv[1]

    mov     rax, 2              ; sys_open
    mov     rdi, rsi
    mov     rsi, 0              ; O_RDONLY
    syscall
    cmp     rax, 0
    js      exit1
    mov     rdi, rax            ; fd

    mov     rax, 0              ; sys_read
    mov     rsi, buf
    mov     rdx, 5
    syscall

    mov     rax, 3              ; sys_close
    mov     rdi, rdi
    syscall

    ; check ELF header: 7F 45 4C 46 02
    mov     al, [buf]
    cmp     al, 0x7F
    jne     exit1
    mov     al, [buf+1]
    cmp     al, 'E'
    jne     exit1
    mov     al, [buf+2]
    cmp     al, 'L'
    jne     exit1
    mov     al, [buf+3]
    cmp     al, 'F'
    jne     exit1
    mov     al, [buf+4]
    cmp     al, 2
    jne     exit1

exit0:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit1:
    mov     rax, 60
    mov     rdi, 1
    syscall
