section .bss
buf:    resb 1024

section .data
nl:     db 10

section .text
global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf
    mov     rdx, 1024
    syscall                    

    mov     r8, rax
    test    r8, r8
    jz      .done
    dec     r8 

.rev:
    cmp     byte [buf+r8], 10
    je      .next

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [buf+r8]
    mov     rdx, 1
    syscall

.next:
    dec     r8
    jns     .rev

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, nl
    mov     rdx, 1
    syscall

.done:
    mov     rax, 60
    xor     rdi, rdi
    syscall
