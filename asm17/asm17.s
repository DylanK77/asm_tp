; asm17.s — Caesar cipher
; Usage: echo "hello" | ./asm17 3

section .bss
buf:    resb 4096

section .text
global _start

; atoi simple
atoi:
    xor     rax, rax
.loop:
    mov     bl, [rsi]
    cmp     bl, 0
    je      .done
    cmp     bl, 10
    je      .done
    cmp     bl, '0'
    jb      .done
    cmp     bl, '9'
    ja      .done
    imul    rax, rax, 10
    sub     bl, '0'
    add     rax, rbx
    inc     rsi
    jmp     .loop
.done:
    ret

_start:
    mov     rax, [rsp]      ; argc
    cmp     rax, 2
    jl      exit1

    mov     rsi, [rsp+16]   ; argv[1] = shift
    call    atoi
    mov     r12, rax        ; shift value

    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf
    mov     rdx, 4096
    syscall
    mov     r13, rax        ; nbytes

    xor     rcx, rcx
.enc_loop:
    cmp     rcx, r13
    jae     .done_enc

    mov     al, [buf+rcx]
    cmp     al, 10
    je      .store

    ; lowercase only a-z
    cmp     al, 'a'
    jb      .store
    cmp     al, 'z'
    ja      .store

    sub     al, 'a'
    add     al, r12b
    mov     bl, 26
    div     bl              ; al=quotient, ah=remainder
    mov     al, ah
    add     al, 'a'

.store:
    mov     [buf+rcx], al
    inc     rcx
    jmp     .enc_loop

.done_enc:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buf
    mov     rdx, r13
    syscall

exit0:
    mov     rax, 60
    xor     rdi, rdi
    syscall

exit1:
    mov     rax, 60
    mov     rdi, 1
    syscall
