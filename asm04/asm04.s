section .bss
    buf resb 32

section .text
global _start

_start:
    ; read(0, buf, 32)
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 32
    syscall

    test rax, rax
    jz  _odd                ; rien lu 

    ; trouver le dernier chiffre avant '\n' 
    lea rsi, [buf + rax - 1]
.find_digit:
    cmp rsi, buf
    jb  _odd                ; pas de chiffre trouvé 
    mov al, [rsi]
    cmp al, '0'
    jb  .prev
    cmp al, '9'
    ja  .prev


    sub al, '0'
    and al, 1
    jz  _even
    jmp _odd

.prev:
    dec rsi
    jmp .find_digit

_even:
    mov rax, 60
    xor rdi, rdi
    syscall

_odd:
    mov rax, 60
    mov rdi, 1
    syscall
