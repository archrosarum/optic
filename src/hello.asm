section .data
    ; Our string layout: 13 characters + a newline character (10)
    msg db "Hello, World!", 10    
    ; Calculate length of the string dynamically
    len equ $ - msg                

section .text
    global _start

_start:
    ; 1. sys_write(stdout, msg, len)
    mov eax, 4      ; System call number for 32-bit sys_write
    mov ebx, 1      ; 1st arg (EBX): File descriptor 1 is stdout
    mov ecx, msg    ; 2nd arg (ECX): Pointer to our text string
    mov edx, len    ; 3rd arg (EDX): Length of the string (14 bytes)
    int 0x80        ; Trigger the Linux kernel handler interrupt

    ; 2. sys_exit(0)
    mov eax, 1      ; System call number for 32-bit sys_exit
    mov ebx, 0      ; 1st arg (EBX): Return exit code 0 (success)
    int 0x80        ; Trigger the Linux kernel handler interrupt

