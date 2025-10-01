section .bss
buf:    resb 32

section .data
nl:     db 10

section .text
global _start

atoi:
    xor     rax, rax
    mov     r9d, +1
    mov     bl, [rsi]
    cmp     bl, '-'
    jne     .check_plus
    mov     r9d, -1
    inc     rsi
    jmp     .parse
.check_plus:
    cmp     bl, '+'
    jne     .parse
    inc     rsi
.parse:
    mov     bl, [rsi]
    cmp     bl, 0
    je      .end
    cmp     bl, '0'
    jb      .end
    cmp     bl, '9'
    ja      .end
    imul    rax, rax, 10
    movzx   rdx, bl
    sub     rdx, '0'
    add     rax, rdx
    inc     rsi
    jmp     .parse
.end:
    cmp     r9d, -1
    jne     .ret
    neg     rax
.ret:
    ret

itoa:
    mov     rbx, 10
    mov     rcx, 0
    mov     rdi, buf+31
    mov     byte [rdi], 0
    test    rax, rax
    jnz     .check_neg
    dec     rdi
    mov     byte [rdi], '0'
    mov     rcx, 1
    mov     rsi, rdi
    ret
.check_neg:
    mov     r8b, 0
    test    rax, rax
    jge     .conv
    neg     rax
    mov     r8b, 1
.conv:
    xor     rdx, rdx
    div     rbx
    add     dl, '0'
    dec     rdi
    mov     [rdi], dl
    inc     rcx
    test    rax, rax
    jnz     .conv
    cmp     r8b, 1
    jne     .finish
    dec     rdi
    mov     byte [rdi], '-'
    inc     rcx
.finish:
    mov     rsi, rdi
    ret

_start:
    mov     rax, [rsp]
    cmp     rax, 3
    jl      exit1

    mov     rsi, [rsp+16]
    call    atoi
    mov     r8, rax

    mov     rsi, [rsp+24]
    call    atoi
    add     rax, r8

    call    itoa
    mov     rax, 1
    mov     rdi, 1
    mov     rdx, rcx
    syscall

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, nl
    mov     rdx, 1
    syscall

exit0:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit1:
    mov     rax, 60
    mov     rdi, 1
    syscall
