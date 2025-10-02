section .bss
buf:    resb 1024

section .text
global _start

_start:
    mov     rax, 0
    xor     rdi, rdi
    mov     rsi, buf
    mov     rdx, 1024
    syscall 

    mov     rcx, rax
    test    rcx, rcx
    jz      .ok
    dec     rcx
    cmp     byte [buf+rcx], 10
    jne     .set_ptrs
    test    rcx, rcx
    jz      .ok
    dec     rcx
.set_ptrs:
    lea     rdi, [buf]
    lea     rbx, [buf+rcx]
.loop:
    cmp     rdi, rbx
    jae     .ok
    mov     al, [rdi]
    mov     dl, [rbx]
    cmp     al, dl
    jne     .fail
    inc     rdi
    dec     rbx
    jmp     .loop

.ok:
    mov     rax, 60
    xor     rdi, rdi
    syscall

.fail:
    mov     rax, 60
    mov     rdi, 1
    syscall
