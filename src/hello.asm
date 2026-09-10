section .text
global _start

_start:
    mov eax, 0          ; Initialize our number to 0

.loop:
    inc eax             ; Add 1 to the number in EAX
    jmp .loop           ; Jump back to the '.loop' label forever
