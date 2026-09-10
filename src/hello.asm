section .data
    ; Buffer to hold our text output string:
    ; 10 bytes for up to a 10-digit number, 1 byte for Carriage Return (\r), 1 byte for Newline (\n)
    ; We initialize it to spaces (32)
    buffer times 12 db 32  

section .text
global _start

_start:
    mov r12, 0              ; Use R12 as our running counter variable

.loop:
    inc r12                 ; 1. Increment our counter by 1
    
    ; 2. Convert the number in R12 into ASCII characters inside our buffer
    mov rax, r12            ; Copy number to RAX for division
    lea rdi, [buffer + 9]   ; Start filling buffer from right-to-left (before control chars)
    
.convert_loop:
    xor rdx, rdx            ; Clear RDX before division
    mov rsi, 10             ; Base 10
    div rsi                 ; RAX = quotient, RDX = remainder (the digit)
    add dl, '0'             ; Convert raw digit to ASCII (e.g., 5 -> '5')
    mov [rdi], dl           ; Store ASCII char in buffer
    dec rdi                 ; Move buffer pointer left for next digit
    test rax, rax           ; Check if quotient is 0
    jnz .convert_loop       ; If not 0, loop to extract next digit

    ; 3. Add a Carriage Return (\r) at the end of the text to reset the cursor position
    mov byte [buffer + 10], 13  ; 13 is ASCII for Carriage Return (\r)
    mov byte [buffer + 11], 10  ; Optional: Adding line feed just for output buffering alignment

    ; 4. Make a Linux System Call to print the buffer to the terminal
    mov rax, 1              ; sys_write system call number
    mov rdi, 1              ; File descriptor 1 (stdout / standard output)
    mov rsi, buffer         ; Pointer to our text buffer
    mov rdx, 12             ; Number of bytes to print
    syscall                 ; Execute the print command

    ; 5. Slow down the loop slightly so human eyes can see it (Optional)
    ; Remove these lines if you want it to run at absolute maximum hardware speed!
    mov rcx, 5000000        ; Loop counter for a small delay
.delay:
    dec rcx
    jnz .delay

    jmp .loop               ; Jump back and repeat forever
