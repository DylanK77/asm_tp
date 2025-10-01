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

    mov     rcx, rax
    dec     rcx
    mov     rbx, buf
    add     rbx, rcx
    mov     rdx, rcx
.rev:
    mov     al, [rbx]
    cmp     al, 10
    je      .skip
    mov     rsi, rsp
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, rbx
    mov     rdx, 1
    syscall
.skip:
    dec     rbx
    dec     rcx
    jns     .rev

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, nl
    mov     rdx, 1
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall
