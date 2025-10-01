section .bss
    buf resb 32

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 32
    syscall

    mov rsi, buf
    xor rax, rax
    xor r8d, r8d        ; saw_digit
    xor r9d, r9d        ; bad

.parse:
    mov bl, [rsi]
    cmp bl, 10
    je  .after
    cmp bl, 0
    je  .after
    cmp bl, '0'
    jb  .badch
    cmp bl, '9'
    ja  .badch
    imul rax, rax, 10
    movzx rdx, bl
    sub rdx, '0'
    add rax, rdx
    inc rsi
    mov r8d, 1
    jmp .parse

.badch:
    mov r9d, 1
.after:
    test r8d, r8d
    jz  _invalid
    test r9d, r9d
    jnz _invalid

    mov rbx, rax
    cmp rbx, 2
    jl  _notprime

    mov rcx, 2
.loop:
    mov rax, rbx
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz  .checkeq
    inc rcx
    mov rax, rcx
    imul rax, rax
    cmp rax, rbx
    jbe .loop
    jmp _prime

.checkeq:
    cmp rcx, rbx
    je  _prime
    jmp _notprime

_prime:
    mov rax, 60
    xor rdi, rdi
    syscall

_notprime:
    mov rax, 60
    mov rdi, 1
    syscall

_invalid:
    mov rax, 60
    mov rdi, 2
    syscall
