section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jb _fail
    mov rsi, [rsp+16]
    xor rcx, rcx
.len:
    cmp byte [rsi+rcx], 0
    je .w
    inc rcx
    jmp .len
.w:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
_fail:
    mov rax, 60
    mov rdi, 1
    syscall
