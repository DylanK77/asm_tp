section .bss
    buf resb 3                 ; on lit jusqu'à "42\n"

section .data
    msg db "1337", 10
    mlen equ $ - msg

section .text
global _start

_start:
    ; read(0, buf, 3)
    mov rax, 0                 ; sys_read
    mov rdi, 0                 ; stdin
    mov rsi, buf
    mov rdx, 3
    syscall                    ; rax = nb d'octets lus

    ; au moins "42"
    cmp rax, 2
    jl  _fail

    ; buf[0] == '4' ?
    mov al, [buf]
    cmp al, '4'
    jne _fail

    ; buf[1] == '2' ?
    mov al, [buf+1]
    cmp al, '2'
    jne _fail

    ; si 3 octets lus, vérifier que le 3e est '\n'
    cmp rax, 2
    je  _ok
    mov al, [buf+2]
    cmp al, 10                 ; '\n'
    jne _fail

_ok:
    ; write(1, "1337\n", 5)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, mlen
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall

_fail:
    ; exit(1)
    mov rax, 60
    mov rdi, 1
    syscall
