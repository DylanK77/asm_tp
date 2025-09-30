section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jb _fail
    mov rbx, [rsp+16]
    mov al, [rbx]
    cmp al, '4'
    jne _fail
    mov al, [rbx+1]
    cmp al, '2'
    jne _fail
    mov al, [rbx+2]
    test al, al
    jne _fail

_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

_fail:
    mov rax, 60
    mov rdi, 1
    syscall
