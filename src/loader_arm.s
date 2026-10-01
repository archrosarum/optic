.section __TEXT,__cstring
scheduler_path: .asciz "./bin/scheduler"
block_start:    .asciz "9"
block_end:      .asciz "17"
task_duration:  .asciz "2"

.section __TEXT,__text
.globl _main
.p2align 2

_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #48             // argv: five 8-byte pointers + padding

    adrp x0, scheduler_path@PAGE
    add  x0, x0, scheduler_path@PAGEOFF
    str  x0, [sp, #0]           // argv[0]: program name

    adrp x2, block_start@PAGE
    add  x2, x2, block_start@PAGEOFF
    str  x2, [sp, #8]           // argv[1]: "9"

    adrp x2, block_end@PAGE
    add  x2, x2, block_end@PAGEOFF
    str  x2, [sp, #16]          // argv[2]: "17"

    adrp x2, task_duration@PAGE
    add  x2, x2, task_duration@PAGEOFF
    str  x2, [sp, #24]          // argv[3]: "2"

    str xzr, [sp, #32]          // argv[4]: NULL
    mov x1, sp                 // second argument: argv
    bl _execv                  // execv(path in x0, argv in x1)

    // Successful execv replaces this process and never returns.
    adrp x0, scheduler_path@PAGE
    add  x0, x0, scheduler_path@PAGEOFF
    bl _perror

    mov w0, #1
    add sp, sp, #48
    ldp x29, x30, [sp], #16
    ret