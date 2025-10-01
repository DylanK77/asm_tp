section .bss
    buf resb 32

section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 3
    jb _fail

    mov rsi, [rsp+16]
    call atoi
    mov rbx, rax

    mov rsi, [rsp+24]
    call atoi
    add rax, rbx

    mov rsi, [rsp+32]
    call atoi
    cmp rax, rbx
    jne _fail

    mov rax, 60
    xor rdi, rdi
    syscall

_fail:
    mov rax, 60
    mov rdi, 1
    syscall

atoi:
    xor rax, rax
.next:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    cmp bl, '0'
    jb .done
    cmp bl, '9'
    ja .done
    imul rax, rax, 10
    sub bl, '0'
    add rax, rbx
    mov rbx, rax
    mov rax, rbx
    inc rsi
    jmp .next
.done:
    ret
