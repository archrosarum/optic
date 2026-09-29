.section __TEXT,__cstring
message:
    .asciz "this is the loader"

.section __TEXT,__text
.globl _main
.p2align 2

_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    adrp x0, message@PAGE
    add  x0, x0, message@PAGEOFF
    bl _puts

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret