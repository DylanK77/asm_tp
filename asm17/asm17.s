section .bss
buf:    resb 4096

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
    cmp     dl, 10
    je      .done
    cmp     dl, '0'
    jb      .done
    cmp     dl, '9'
    ja      .done
    imul    rax, rax, 10
    movzx   r8, dl
    sub     r8, '0'
    add     rax, r8
    inc     rsi
    jmp     .loop
.done:
    test    rcx, rcx
    jz      .ret
    neg     rax
.ret:
    ret

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jb      .shift_zero
    mov     rsi, [rsp+16]
    call    atoi
    mov     r12d, eax
    jmp     .norm
.shift_zero:
    xor     r12d, r12d

.norm:
    mov     eax, r12d
    cdq
    mov     ebx, 26
    idiv    ebx
    mov     r12d, edx
    test    r12d, r12d
    jge     .okrem
    add     r12d, 26
.okrem:

    mov     rax, 0
    xor     rdi, rdi
    mov     rsi, buf
    mov     rdx, 4096
    syscall
    mov     r13, rax

    xor     rcx, rcx
.loop:
    cmp     rcx, r13
    jae     .out

    movzx   edx, byte [buf+rcx]
    cmp     dl, 10
    je      .store

    cmp     dl, 'a'
    jb      .upper
    cmp     dl, 'z'
    ja      .store
    sub     edx, 'a'
    add     edx, r12d
    cmp     edx, 26
    jb      .low_ok
    sub     edx, 26
.low_ok:
    add     edx, 'a'
    jmp     .store

.upper:
    cmp     dl, 'A'
    jb      .store
    cmp     dl, 'Z'
    ja      .store
    sub     edx, 'A'
    add     edx, r12d
    cmp     edx, 26
    jb      .up_ok
    sub     edx, 26
.up_ok:
    add     edx, 'A'

.store:
    mov     byte [buf+rcx], dl
    inc     rcx
    jmp     .loop

.out:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buf
    mov     rdx, r13
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall
