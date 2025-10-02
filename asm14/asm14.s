section .data
msg:    db "Hello Universe!", 10
len:    equ $ - msg

section .text
global _start

_start:
    mov     rax, [rsp]          ; argc
    cmp     rax, 2
    jl      exit1

    mov     rsi, [rsp+16]       ; argv[1] = filename
    mov     rax, 2              ; sys_open
    mov     rdi, rsi
    mov     rsi, 577            ; O_CREAT|O_WRONLY|O_TRUNC = 0x241
    mov     rdx, 0644
    syscall                     ; rax = fd

    mov     rdi, rax
    mov     rax, 1              ; sys_write
    mov     rsi, msg
    mov     rdx, len
    syscall

    mov     rax, 3              ; sys_close
    syscall

exit0:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit1:
    mov     rax, 60
    mov     rdi, 1
    syscall
