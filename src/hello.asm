section .data
    ; Formatting strings for the final metrics output
    fmt_cycles db "Total CPU Clock Cycles: ", 0
    fmt_per_it db "Cycles per Increment  : ", 0
    newline    db 10, 0

section .bss
    ; Output string conversion buffer
    str_buf resb 32

section .text
global _start

_start:
    ; =========================================================================
    ; 1. START BENCHMARK: Read Time-Stamp Counter
    ; =========================================================================
    cpuid                   ; CPUID serializes execution so no instructions float past this boundary
    rdtsc                   ; Reads time-stamp counter into EDX:EAX
    shl rdx, 32
    or rax, rdx
    mov r14, rax            ; R14 = Starting CPU cycle count

    ; =========================================================================
    ; 2. THE WORK: Execute 100 Million Increments inside RAM (No IO bottlenecks)
    ; =========================================================================
    mov r12, 0              ; Our running counter variable
    mov rcx, 100000000      ; Set loop iteration count to 100,000,000

.work_loop:
    inc r12                 ; Increment our target number
    dec rcx                 ; Decrement our loop tracking condition
    jnz .work_loop          ; Loop until RCX hit 0

    ; =========================================================================
    ; 3. END BENCHMARK: Read Time-Stamp Counter Again
    ; =========================================================================
    cpuid                   ; Serialize execution again
    rdtsc                   ; Reads ending time-stamp counter into EDX:EAX
    shl rdx, 32
    or rax, rdx
    mov r15, rax            ; R15 = Ending CPU cycle count

    ; Calculate Total Cycles: R15 - R14
    sub r15, r14            ; R15 now holds the total elapsed clock cycles

    ; Calculate Cycles Per Iteration: Total / 100,000,000
    ; (We scale by 100 first to compute a clean two-digit decimal value)
    mov rax, r15
    imul rax, 100           ; Multiply by 100 for decimal precision
    mov rsi, 100000000
    xor rdx, rdx
    div rsi                 ; RAX = Quotient (Cycles per loop * 100)
    mov r13, rax            ; Store result in R13

    ; =========================================================================
    ; 4. PRINT BENCHMARK RESULTS
    ; =========================================================================
    ; Print "Total CPU Clock Cycles: "
    mov rsi, fmt_cycles
    call _print_string
    ; Convert and print total cycles (R15)
    mov rax, r15
    call _print_number
    mov rsi, newline
    call _print_string

    ; Print "Cycles per Increment  : "
    mov rsi, fmt_per_it
    call _print_string
    ; Convert and print fractional cycles per iteration (R13)
    ; Break R13 into whole number and decimal portions
    mov rax, r13
    mov rsi, 100
    xor rdx, rdx
    div rsi                 ; RAX = Whole, RDX = Fraction
    mov rbx, rdx            ; Save fraction in RBX
    call _print_number      ; Print whole number part
    
    ; Print decimal point '.'
    push rbx
    mov byte [str_buf], '.'
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, str_buf
    mov rdx, 1
    syscall
    pop rbx

    mov rax, rbx            ; Print fractional part
    call _print_number
    mov rsi, newline
    call _print_string

    ; Exit program gracefully via system call
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; Exit code 0
    syscall

; -----------------------------------------------------------------------------
; HELPER UTILITY SUBROUTINES (ASCII Text Renderers)
; -----------------------------------------------------------------------------
_print_string:
    ; Measures a null-terminated string at RSI and executes sys_write
    push rsi
    xor rdx, rdx
.len_loop:
    cmp byte [rsi + rdx], 0
    je .done_len
    inc rdx
    jmp .len_loop
.done_len:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    pop rsi                 ; Restore string pointer
    syscall
    ret

_print_number:
    ; Converts number in RAX to ASCII and writes it to stdout
    lea rdi, [str_buf + 30]
    mov byte [rdi], 0       ; Null terminator
    mov rsi, 10
.conv:
    xor rdx, rdx
    div rsi
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .conv
    mov rsi, rdi
    call _print_string
    ret
