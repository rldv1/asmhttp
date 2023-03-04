section .data
    listen_sock dd 0
    conn_sock dd 0
    sa_in      sockaddr_in <AF_INET, htons(8080), 0, 0, 0, 0, 0>

section .text
    global _start

_start:
    mov eax, SYS_SOCKET
    mov ebx, AF_INET
    mov ecx, SOCK_STREAM
    int 0x80
    mov [listen_sock], eax

    ; 8080
    mov eax, SYS_BIND
    mov ebx, [listen_sock]
    mov ecx, sa_in
    mov edx, 16
    int 0x80
    ; listen
    mov eax, SYS_LISTEN
    mov ebx, [listen_sock]
    mov ecx, 1
    int 0x80

aclc:
    mov eax, SYS_ACCEPT
    mov ebx, [listen_sock]
    mov ecx, 0
    mov edx, 0
    mov esi, sa_in
    mov edi, 16
    int 0x80
    mov [conn_sock], eax

snrp:
    mov eax, SYS_WRITE
    mov ebx, [conn_sock]
    mov ecx, message
    mov edx, message_len
    int 0x80

clcn:
    mov eax, SYS_CLOSE
    mov ebx, [conn_sock]
    int 0x80

    ; (this server can accept only 1 connection!!1!1!!1)
    jmp aclc

section .data
    message db "HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\ngive star to project pls\r\n"
    message_len equ $ - message
