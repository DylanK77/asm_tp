section .text
global _start

_start:
    cmp rdi, 2
    jl  _fail

    mov rbx, [rsi+8]
    mov al, [rbx]
    cmp al, '4'
    jne _fail
    mov al, [rbx+1]
    cmp al, '2'
    jne _fail
    mov al, [rbx+2]
    cmp al, 0
    jne _fail

_success:
    mov rax, 60
    xor rdi, rdi
    syscall

_fail:
    mov rax, 60
    mov rdi, 1
    syscall
