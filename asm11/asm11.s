section .bss
buf:    resb 1024
out:    resb 32

section .data
nl:     db 10

section .text
global _start

itoa:
    mov     rdi, out+31
    mov     byte [rdi], 0
    test    rax, rax
    jnz     .loop
    dec     rdi
    mov     byte [rdi], '0'
    mov     rsi, rdi
    mov     rdx, 1
    ret
.loop:
    mov     rcx, 10
.next:
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    dec     rdi
    mov     [rdi], dl
    test    rax, rax
    jnz     .next
    mov     rsi, rdi
    mov     rdx, out+32
    sub     rdx, rdi
    dec     rdx
    ret

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf
    mov     rdx, 1024
    syscall

    xor     rbx, rbx
    xor     rcx, rcx
.count:
    cmp     rcx, rax
    jae     .done
    mov     dl, [buf+rcx]
    cmp     dl, 10
    je      .done
    cmp     dl, 'a'
    je      .inc
    cmp     dl, 'e'
    je      .inc
    cmp     dl, 'i'
    je      .inc
    cmp     dl, 'o'
    je      .inc
    cmp     dl, 'u'
    je      .inc
    cmp     dl, 'A'
    je      .inc
    cmp     dl, 'E'
    je      .inc
    cmp     dl, 'I'
    je      .inc
    cmp     dl, 'O'
    je      .inc
    cmp     dl, 'U'
    je      .inc
    jmp     .next
.inc:
    inc     rbx
.next:
    inc     rcx
    jmp     .count

.done:
    mov     rax, rbx
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
