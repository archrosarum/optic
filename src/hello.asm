section .bss
    ; A massive 64KB output buffer to hold thousands of updates at once
    BUFFER_SIZE equ 65536
    buffer resb BUFFER_SIZE

section .text
global _start

_start:
    mov r12, 0              ; R12 = Our running counter variable

.outer_loop:
    lea rdi, [buffer]       ; RDI points to the beginning of our 64KB RAM buffer

.fill_buffer:
    inc r12                 ; 1. Increment the counter

    ; 2. Fast Inline Number-to-ASCII Conversion
    mov rax, r12            
    mov rsi, 10
    lea rbx, [rdi + 10]     ; Temp pointer for right-to-left layout inside the local slot
    
.convert:
    xor rdx, rdx
    div rsi
    add dl, '0'
    dec rbx
    mov [rbx], dl
    test rax, rax
    jnz .convert

    ; Pad left side with spaces so it cleanly overwrites previous digits
.pad:
    cmp rbx, rdi
    je .done_pad
    dec rbx
    mov byte [rbx], 32      ; 32 = Space character
    jmp .pad

.done_pad:
    ; 3. Append Carriage Return (\r) to overwrite the line, instead of a newline (\n)
    mov byte [rdi + 10], 13 ; 13 = \r
    add rdi, 11             ; Advance our main buffer pointer forward 11 bytes

    ; Check if our 64KB buffer is getting full
    lea rcx, [buffer + BUFFER_SIZE - 32]
    cmp rdi, rcx
    jl .fill_buffer         ; If there's still plenty of space, keep filling RAM instantly

    ; 4. Flush to Screen: Execute ONE single system call for the entire batch
    mov rdx, rdi
    sub rdx, buffer         ; Calculate exact number of bytes written to buffer
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, buffer         ; Address of our massive buffer
    syscall                 ; Blast thousands of iterations to the terminal at once

    jmp .outer_loop         ; Repeat the process forever
