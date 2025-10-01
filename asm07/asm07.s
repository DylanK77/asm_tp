section .bss
    buf resb 32

section .text
global _start

atoi:
    xor     rax, rax
.parse:
    mov     bl, [rsi]
    cmp     bl, 0
    je      .done
    cmp     bl, '0'
    jb      .done
    cmp     bl, '9'
    ja      .done
    imul    rax, rax, 10
    movzx   rdx, bl
    sub     rdx, '0'
    add     rax, rdx
    inc     rsi
    jmp     .parse
.done:
    ret

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf
    mov     rdx, 32
    syscall

    mov     rsi, buf
    call    atoi
    mov     rbx, rax

    cmp     rbx, 2
    jl      _notprime

    mov     rcx, 2
.loop:
    mov     rax, rbx
    xor     rdx, rdx
    div     rcx
    test    rdx, rdx
    jz      .check_equal
    inc     rcx
    mov     rax, rcx
    imul    rax, rax
    cmp     rax, rbx
    jbe     .loop
    jmp     _prime

.check_equal:
    cmp     rcx, rbx
    je      _prime
    jmp     _notprime

_prime:
    mov     rax, 60
    xor     rdi, rdi
    syscall

_notprime:
    mov     rax, 60
    mov     rdi, 1
    syscall
