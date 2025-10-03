; asm18 — UDP client with timeout (connect + recv timeout)
; OK case: prints  message: "Hello, client!"
; Timeout: prints Timeout: no response from server  and exit 1

%define AF_INET          2
%define SOCK_DGRAM       2
%define SOL_SOCKET       1
%define SO_RCVTIMEO      20

%define SYS_socket       41
%define SYS_connect      42
%define SYS_sendto       44           ; send uses same nr with NULL addr
%define SYS_recvfrom     45
%define SYS_setsockopt   54
%define SYS_write        1
%define SYS_close        3
%define SYS_exit         60

section .bss
buf:    resb 1024

section .data
; sockaddr_in (network byte order in memory)
dest:   dw AF_INET
        dw 0x9210              ; htons(4242) -> bytes 10 92
        dd 0x0100007F          ; 127.0.0.1 -> bytes 7F 00 00 01
        dq 0

tv:     dq 2                   ; tv_sec
        dq 0                   ; tv_usec

pfx:    db 'message: "'
pfxlen  equ $-pfx
suf:    db '"',10
suflen  equ $-suf

tout:   db "Timeout: no response from server",10
toutlen equ $-tout

msg:    db "ping",10
msglen  equ $-msg

section .text
global _start

_start:
    ; s = socket(AF_INET, SOCK_DGRAM, 0)
    mov     rax, SYS_socket
    mov     rdi, AF_INET
    mov     rsi, SOCK_DGRAM
    xor     rdx, rdx
    syscall
    test    rax, rax
    js      .timeout
    mov     r12, rax

    ; setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, &tv, 16)
    mov     rax, SYS_setsockopt
    mov     rdi, r12
    mov     rsi, SOL_SOCKET
    mov     rdx, SO_RCVTIMEO
    lea     r10, [rel tv]
    mov     r8, 16
    syscall

    ; connect(s, &dest, 16) — set default peer for replies
    mov     rax, SYS_connect
    mov     rdi, r12
    lea     rsi, [rel dest]
    mov     rdx, 16
    syscall
    test    rax, rax
    js      .timeout

    ; send(s, "ping\n", len, 0)
    mov     rax, SYS_sendto
    mov     rdi, r12
    lea     rsi, [rel msg]
    mov     rdx, msglen
    xor     r10, r10           ; flags = 0
    xor     r8,  r8            ; addr = NULL (since connected)
    xor     r9,  r9            ; addrlen = 0
    syscall
    test    rax, rax
    js      .timeout

    ; n = recv(s, buf, 1024, 0)
    mov     rax, SYS_recvfrom
    mov     rdi, r12
    lea     rsi, [rel buf]
    mov     rdx, 1024
    xor     r10, r10           ; flags = 0
    xor     r8,  r8            ; src = NULL
    xor     r9,  r9            ; srclen = 0
    syscall
    cmp     rax, 0
    jle     .timeout
    mov     r13, rax

    ; write(1, 'message: "', pfxlen)
    mov     rax, SYS_write
    mov     rdi, 1
    lea     rsi, [rel pfx]
    mov     rdx, pfxlen
    syscall

    ; write(1, buf, n)
    mov     rax, SYS_write
    mov     rdi, 1
    lea     rsi, [rel buf]
    mov     rdx, r13
    syscall

    ; write(1, '"\n', 2)
    mov     rax, SYS_write
    mov     rdi, 1
    lea     rsi, [rel suf]
    mov     rdx, suflen
    syscall

    ; close + exit(0)
    mov     rax, SYS_close
    mov     rdi, r12
    syscall
    mov     rax, SYS_exit
    xor     rdi, rdi
    syscall

.timeout:
    ; best-effort close
    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    mov     rax, SYS_write
    mov     rdi, 1
    lea     rsi, [rel tout]
    mov     rdx, toutlen
    syscall

    mov     rax, SYS_exit
    mov     rdi, 1
    syscall
