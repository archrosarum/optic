section .bss
    ; A 24-byte buffer to hold our text output string:
    ; Up to 20 digits for the 64-bit cycle number, 1 byte for Carriage Return (\r), 
    ; 1 byte for Newline (\n), and a bit of padding.
    buffer resb 24

section .text
global _start

_start:
    ; Initialize the buffer with spaces so it clears old text cleanly
    mov rcx, 24
.clear_buf:
    mov byte [buffer + rcx - 1], 32 ; 32 = Space character
    loop .clear_buf

.loop:
    ; =========================================================================
    ; 1. READ THE REAL-TIME CPU HARDWARE CLOCK
    ; =========================================================================
    ; Note: We skip 'cpuid' here on purpose because we want maximum loop speed 
    ; and don't need microsecond-accurate serialization for a live display.
    rdtsc                   ; Reads time-stamp counter into EDX (high) and EAX (low)
    shl rdx, 32             ; Shift high 32 bits to the upper half of RDX
    or rax, rdx             ; Combine into RAX. RAX now holds the full 64-bit cycle count

    ; =========================================================================
    ; 2. CONVERT THE 64-BIT INTEGER TO ASCII TEXT (Right-to-Left)
    ; =========================================================================
    lea rdi, [buffer + 19]  ; Start filling buffer right before the control characters
    mov rsi, 10             ; Base 10 divisor

.convert:
    xor rdx, rdx            ; Clear RDX before division
    div rsi                 ; Divide RAX by 10. Quotient in RAX, Remainder in RDX
    add dl, '0'             ; Convert raw digit (0-9) to ASCII character ('0'-'9')
    mov [rdi], dl           ; Store character in our RAM buffer
    dec rdi                 ; Move buffer pointer one step to the left
    test rax, rax           ; Is the quotient 0?
    jnz .convert            ; If not 0, loop to pull the next digit

    ; Pad any remaining space on the left with blank spaces to clear old text
.pad:
    cmp rdi, buffer
    jl .done_pad
    mov byte [rdi], 32      ; 32 = Space character
    dec rdi
    jmp .pad

.done_pad:
    ; =========================================================================
    ; 3. APPEND CARRIAGE RETURN (\r) TO OVERWRITE THE SAME LINE
    ; =========================================================================
    mov byte [buffer + 20], 13  ; 13 = ASCII Carriage Return (\r)
    mov byte [buffer + 21], 10  ; 10 = ASCII Line Feed (\n) (Helps smooth output buffering)

    ; =========================================================================
    ; 4. PRINT THE MASSIVE NUMBER TO THE TERMINAL
    ; =========================================================================
    mov rax, 1              ; Linux sys_write system call
    mov rdi, 1              ; File descriptor 1 (stdout)
    mov rsi, buffer         ; Pointer to our text string
    mov rdx, 22             ; Number of bytes to write
    syscall                 ; Blast it to the screen

    ; =========================================================================
    ; 5. OPTIONAL SLOW DOWN
    ; =========================================================================
    ; Because the CPU ticks ~3,000,000,000+ times a second, printing every single
    ; cycle will completely freeze your terminal emulator. We put a small delay
    ; here so the screen can actually redraw.
    mov rcx, 2000000
.delay:
    dec rcx
    jnz .delay

    jmp .loop               ; Jump back and fetch the next real-time cycle count
