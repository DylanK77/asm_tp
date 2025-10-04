; Count vowels (ASCII + common accented) from stdin, print number, exit 0.
; Handles long inputs by reading in chunks.

section .bss
buf:    resb 4096
out:    resb 32

section .data
nl:     db 10

section .text
global _start

; --- u64 itoa (rax -> rsi,rdx=len) ---
itoa:
    mov     rdi, out+31
    mov     byte [rdi], 0
    test    rax, rax
    jnz     .loop
    dec     rdi
    mov     byte [rdi], '0'
    mov     rsi, rdi
    mov     rdx, 1
    ret
.loop:
    mov     rcx, 10
.next:
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    dec     rdi
    mov     [rdi], dl
    test    rax, rax
    jnz     .next
    mov     rsi, rdi
    mov     rdx, out+32
    sub     rdx, rdi
    dec     rdx
    ret

; --- main ---
_start:
    xor     rbx, rbx            ; total count
.read_more:
    mov     rax, 0
    xor     rdi, rdi
    mov     rsi, buf
    mov     rdx, 4096
    syscall                     ; rax = bytes read
    test    rax, rax
    jle     .print              ; 0 or error -> finish
    mov     rcx, 0              ; index

.process:
    cmp     rcx, rax
    jae     .read_more

    mov     dl, [buf+rcx]
    cmp     dl, 10
    je      .next                ; ignore newline

    ; ASCII vowels aeiouAEIOU and Yy
    cmp     dl, 'a'      ; a
    je      .inc
    cmp     dl, 'e'
    je      .inc
    cmp     dl, 'i'
    je      .inc
    cmp     dl, 'o'
    je      .inc
    cmp     dl, 'u'
    je      .inc
    cmp     dl, 'A'
    je      .inc
    cmp     dl, 'E'
    je      .inc
    cmp     dl, 'I'
    je      .inc
    cmp     dl, 'O'
    je      .inc
    cmp     dl, 'U'
    je      .inc
    cmp     dl, 'y'
    je      .inc
    cmp     dl, 'Y'
    je      .inc

    ; UTF-8 accented vowels (common French set) starting with 0xC3
    cmp     dl, 0xC3
    jne     .next

    ; ensure we have a following byte
    mov     r8, rcx
    inc     r8
    cmp     r8, rax
    jae     .next

    mov     dl, [buf+rcx+1]

    ; Lowercase: à â ä æ è é ê ë î ï ô ö ù û ü ÿ
    ; Bytes: A0 A2 A4 A6 A8 A9 AA AB AE AF B4 B6 B9 BA BB BC BF
    cmp     dl, 0xA0
    je      .inc_skip
    cmp     dl, 0xA2
    je      .inc_skip
    cmp     dl, 0xA4
    je      .inc_skip
    cmp     dl, 0xA6
    je      .inc_skip
    cmp     dl, 0xA8
    je      .inc_skip
    cmp     dl, 0xA9
    je      .inc_skip
    cmp     dl, 0xAA
    je      .inc_skip
    cmp     dl, 0xAB
    je      .inc_skip
    cmp     dl, 0xAE
    je      .inc_skip
    cmp     dl, 0xAF
    je      .inc_skip
    cmp     dl, 0xB4
    je      .inc_skip
    cmp     dl, 0xB6
    je      .inc_skip
    cmp     dl, 0xB9
    je      .inc_skip
    cmp     dl, 0xBA
    je      .inc_skip
    cmp     dl, 0xBB
    je      .inc_skip
    cmp     dl, 0xBC
    je      .inc_skip
    cmp     dl, 0xBF
    je      .inc_skip

    ; Uppercase: À Â Ä Æ È É Ê Ë Î Ï Ô Ö Ù Û Ü Ÿ
    ; Bytes: 80 82 84 86 88 89 8A 8B 8E 8F 94 96 99 9A 9B 9C 9F
    cmp     dl, 0x80
    je      .inc_skip
    cmp     dl, 0x82
    je      .inc_skip
    cmp     dl, 0x84
    je      .inc_skip
    cmp     dl, 0x86
    je      .inc_skip
    cmp     dl, 0x88
    je      .inc_skip
    cmp     dl, 0x89
    je      .inc_skip
    cmp     dl, 0x8A
    je      .inc_skip
    cmp     dl, 0x8B
    je      .inc_skip
    cmp     dl, 0x8E
    je      .inc_skip
    cmp     dl, 0x8F
    je      .inc_skip
    cmp     dl, 0x94
    je      .inc_skip
    cmp     dl, 0x96
    je      .inc_skip
    cmp     dl, 0x99
    je      .inc_skip
    cmp     dl, 0x9A
    je      .inc_skip
    cmp     dl, 0x9B
    je      .inc_skip
    cmp     dl, 0x9C
    je      .inc_skip
    cmp     dl, 0x9F
    je      .inc_skip

    jmp     .next

.inc:
    inc     rbx
    jmp     .next

.inc_skip:                      ; count and skip the second UTF-8 byte
    inc     rbx
    inc     rcx
    jmp     .next

.next:
    inc     rcx
    jmp     .process

.print:
    mov     rax, rbx
    call    itoa
    mov     rax, 1
    mov     rdi, 1
    syscall
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, nl
    mov     rdx, 1
    syscall
    mov     rax, 60
    xor     rdi, rdi
    syscall
