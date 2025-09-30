section .data
    msg db "1337", 10
    len equ $ - msg

section .text
global _start

_start:
    mov rax, 1        ; sys_write
    mov rdi, 1        ; stdout
    mov rsi, msg      ; addr
    mov rdx, len      ; len
    syscall

    mov rax, 60       ; sys_exit
    mov rdi, 0
    syscall
