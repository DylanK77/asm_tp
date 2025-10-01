section .bss
buf:    resb 64

section .data
nl:     db 10

section .text
global _start

atoi:
    xor     rax, rax
    xor     rcx, rcx
    mov     dl, [rsi]
    cmp     dl, '-'
    jne     .chk_plus
    inc     rsi
    mov     cl, 1
    jmp     .loop
.chk_plus:
    cmp     dl, '+'
    jne     .loop
    inc     rsi
.loop:
    mov     dl, [rsi]
    cmp     dl, 0
    je      .done
    cmp     dl, '0'
    jb      .done
    cmp     dl, '9'
    ja      .done
    imul    rax, rax, 10
    movzx   rdx, dl
    sub     rdx, '0'
    add     rax, rdx
    inc     rsi
    jmp     .loop
.done:
    test    rcx, rcx
    jz      .ret
    neg     rax
.ret:
    ret

itoa:
    mov     r8,  rax
    lea     r9,  [buf+64]
    mov     r10, r9
    xor     r11d, r11d
    test    r8, r8
    jge     .pos
    neg     r8
    mov     r11d, 1
.pos:
    test    r8, r8
    jnz     .conv
    dec     r9
    mov     byte [r9], '0'
    jmp     .maybe_sign
.conv:
    mov     rax, r8
.next:
    xor     rdx, rdx
    mov     rcx, 10
    div     rcx
    add     dl, '0'
    dec     r9
    mov     [r9], dl
    test    rax, rax
    jnz     .next
.maybe_sign:
    test    r11d, r11d
    jz      .done
    dec     r9
    mov     byte [r9], '-'
.done:
    mov     rsi, r9
    mov     rdx, r10
    sub     rdx, r9
    ret

_start:
    mov     rax, [rsp]
    cmp     rax, 4
    jl      .e1

    mov     rsi, [rsp+16]
    call    atoi
    mov     r12, rax

    mov     rsi, [rsp+24]
    call    atoi
    cmp     rax, r12
    cmovg   r12, rax

    mov     rsi, [rsp+32]
    call    atoi
    cmp     rax, r12
    cmovg   r12, rax

    mov     rax, r12
    call    itoa

    mov     rax, 1
    mov     rdi, 1
    syscall

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, nl
    mov     rdx, 1
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

.e1:
    mov     rax, 60
    mov     rdi, 1
    syscall
