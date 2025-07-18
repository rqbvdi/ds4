.section .init
.global _start
_start:
	lui x2, 0x3FF
	jal main

    // send the TERMINATE signal to the testbench
    li a4, -1
    add a5, x0, x0
    lui a5, 0x5
    sb a4, 0(a5)

    // print a linebreak
    li a4, 0x0A
    add a5, x0, x0
    lui a5, 0x5
    sb a4, 0(a5)