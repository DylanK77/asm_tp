section .bss
buf: resb 64

section .data
digits: db "0123456789ABCDEF"
nl: db 10

section .text
global _start

atoi:
    xor rax, rax
.a:
    mov bl, [rsi]
    cmp bl, 0
    je  .d
    cmp bl, '0'
    jb  .d
    cmp bl, '9'
    ja  .d
    imul rax, rax, 10
    movzx rdx, bl
    sub rdx, '0'
    add rax, rdx
    inc rsi
    jmp .a
.d:
    ret

to_base:
    mov rcx, rbx
    mov rdi, buf+63
    mov byte [rdi], 0
    test rax, rax
    jnz .loop
    dec rdi
    mov byte [rdi], '0'
    mov rsi, rdi
    mov rdx, 1
    ret
.loop:
    xor rdx, rdx
    div rcx
    mov bl, [digits+rdx]
    dec rdi
    mov [rdi], bl
    test rax, rax
    jnz .loop
    mov rsi, rdi
    mov rdx, buf+64
    sub rdx, rdi
    dec rdx
    ret

_start:
    mov rax, [rsp]
    cmp rax, 2
    jl  .e1

    mov rsi, [rsp+16]
    mov rbx, 16
    mov al, [rsi]
    cmp al, '-'
    jne .normal
    cmp byte [rsi+1], 'b'
    jne .normal
    mov rbx, 2
    mov rsi, [rsp+24]
.normal:
    call atoi
    call to_base

    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.e1:
    mov rax, 60
    mov rdi, 1
    syscall
