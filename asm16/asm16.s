; asm16.s — Patch "1337" -> "H4CK" in a given file
; Usage:
;   ./asm16 asm01
;   ./asm01   # should now print H4CK

section .bss
buf:    resb 65536             ; 64 KiB buffer (suffisant pour asm01)

section .data
pat:    db "1337"
repl:   db "H4CK"

section .text
global _start

_start:
    mov     rax, [rsp]         ; argc
    cmp     rax, 2
    jl      exit1

    mov     rax, 257           ; SYS_openat
    mov     rdi, -100          ; AT_FDCWD
    mov     rsi, [rsp+16]      ; pathname
    mov     rdx, 2             ; O_RDWR
    xor     r10, r10
    syscall
    test    rax, rax
    js      exit1
    mov     r12, rax           ; fd

    mov     rax, 8             ; SYS_lseek
    mov     rdi, r12
    xor     rsi, rsi           ; offset = 0
    mov     rdx, 2             ; SEEK_END
    syscall
    test    rax, rax
    jle     close_and_exit1
    mov     r13, rax           ; r13 = file size

    mov     rbx, 65536
    cmp     r13, rbx
    jbe     .size_ok
    mov     r13, rbx
.size_ok:

    mov     rax, 8
    mov     rdi, r12
    xor     rsi, rsi
    xor     rdx, rdx           ; SEEK_SET
    syscall

    mov     rax, 0             ; SYS_read
    mov     rdi, r12
    mov     rsi, buf
    mov     rdx, r13
    syscall
    cmp     rax, 4
    jl      close_and_exit1
    mov     r14, rax           ; bytes read

    mov     rbx, 0
    mov     r15, r14
    sub     r15, 4             ; last start index to check

.scan:
    cmp     rbx, r15
    jg      close_and_exit1

    mov     eax, dword [buf+rbx]
    cmp     eax, dword [pat]
    je      .found
    inc     rbx
    jmp     .scan

.found:
    mov     rax, 8             ; lseek
    mov     rdi, r12
    mov     rsi, rbx
    xor     rdx, rdx
    syscall

    mov     rax, 1             ; write
    mov     rdi, r12
    mov     rsi, repl
    mov     rdx, 4
    syscall
    test    rax, rax
    js      close_and_exit1

    mov     rax, 3             ; close
    mov     rdi, r12
    syscall
    mov     rax, 60
    xor     rdi, rdi
    syscall

close_and_exit1:
    mov     rax, 3
    mov     rdi, r12
    syscall
exit1:
    mov     rax, 60
    mov     rdi, 1
    syscall
