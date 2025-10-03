section .data
msg:    db "Hello Universe!", 10
len:    equ $ - msg

section .text
global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jl      exit1

    mov     rsi, [rsp+16]       ; filename*

    ; openat(AT_FDCWD, filename, O_CREAT|O_WRONLY|O_TRUNC, 0644)
    mov     rax, 257            ; sys_openat
    mov     rdi, -100           ; AT_FDCWD
    ; rsi already filename
    mov     rdx, 577            ; O_CREAT|O_WRONLY|O_TRUNC
    mov     r10, 420            ; 0644 in decimal
    syscall                     ; rax = fd

    mov     rdi, rax
    mov     rax, 1              ; write(fd, msg, len)
    mov     rsi, msg
    mov     rdx, len
    syscall

    mov     rax, 3              ; close(fd)
    syscall

    mov     rax, 60             ; exit(0)
    xor     rdi, rdi
    syscall

exit1:
    mov     rax, 60             ; exit(1)
    mov     rdi, 1
    syscall
