section .bss
    ; Reserve a 16-byte block of memory in RAM to hold whatever the user types
    user_input resb 16

section .data
    prompt db "Type something: ", 0

section .text
global _start

_start:
    ; 1. PRINT THE PROMPT
    mov rax, 1              ; sys_write system call
    mov rdi, 1              ; stdout (terminal screen)
    mov rsi, prompt         ; pointer to text
    mov rdx, 16             ; length of prompt string
    syscall

    ; =========================================================================
    ; 2. GET USER INPUT (The Core Request)
    ; =========================================================================
    mov rax, 0              ; Call number 0 is 'sys_read'
    mov rdi, 0              ; File descriptor 0 is 'stdin' (keyboard input)
    mov rsi, user_input     ; Where in RAM to store the user's keystrokes
    mov rdx, 16             ; Maximum number of bytes/characters to read
    syscall                 ; Pause and wait for the user to hit Enter

    ; =========================================================================
    ; 3. ECHO IT BACK TO PROVE IT WORKED
    ; =========================================================================
    mov rax, 1              ; sys_write system call
    mov rdi, 1              ; stdout
    mov rsi, user_input     ; Print the data now sitting inside our buffer
    mov rdx, 16             ; Print up to 16 bytes
    syscall

    ; 4. EXIT PROGRAM GRACEFULLY
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; exit code 0
    syscall
