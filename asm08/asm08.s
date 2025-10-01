section .bss
buf: resb 32

section .data
nl:  db 10

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

itoa:
    mov rdi, buf+31
    mov byte [rdi], 0
    test rax, rax
    jnz .l
    dec rdi
    mov byte [rdi], '0'
    mov rsi, rdi
    mov rdx, 1
    ret
.l:
    mov rcx, 10
    mov rbx, rdi
.loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .loop
    mov rsi, rdi
    mov rdx, rbx
    sub rdx, rdi
    ret

_start:
    mov rax, [rsp]
    cmp rax, 2
    jb  .e1

    mov rsi, [rsp+16]
    call atoi
    mov rbx, rax
    cmp rbx, 1
    jle .zero

    mov rax, rbx
    dec rax
    imul rax, rbx
    shr rax, 1
    jmp .out

.zero:
    xor rax, rax

.out:
    call itoa
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
