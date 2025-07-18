.section .init
.global _start
_start:
    // load first byte from data memory
    lw x10, 0(x0)
    andi x10, x10, 0xF
    // Task: compute the sum of all integers between 0 and the number
    // in register x10 and place it into register x10 when finished.

    // puts your code below this line, do not modify code above
    // put your code above this line, do not modify code below

    // print "----> "
    add a5, x0, x0
    lui a5, 0x5
    li a4, 0x2D
    sb a4, 0(a5)
    li a4, 0x00
    sb a4, 0(a5)
    li a4, 0x2D
    sb a4, 0(a5)
    li a4, 0x00
    sb a4, 0(a5)
    li a4, 0x2D
    sb a4, 0(a5)
    li a4, 0x00
    sb a4, 0(a5)
    li a4, 0x2D
    sb a4, 0(a5)
    li a4, 0x00
    sb a4, 0(a5)
    li a4, 0x3E
    sb a4, 0(a5)
    li a4, 0x20
    sb a4, 0(a5)

    // print register x10 as hex
    add x11, x10, x0
    addi x12, x0, 0x20
    addi x16, x10, 0
    addi x17, x0, 0
    li x17, 0x00F
    addi x18, x0, 0
printloop:
    addi x12, x12, -4
    srl x16, x10, x12
    andi x11, x16, 0x00F
    xor x13, x13, x13
    li x13, 0x0
    beq x11, x13, print_0
    li x13, 0x1
    beq x11, x13, print_1
    li x13, 0x2
    beq x11, x13, print_2
    li x13, 0x3
    beq x11, x13, print_3
    li x13, 0x4
    beq x11, x13, print_4
    li x13, 0x5
    beq x11, x13, print_5
    li x13, 0x6
    beq x11, x13, print_6
    li x13, 0x7
    beq x11, x13, print_7
    li x13, 0x8
    beq x11, x13, print_8
    li x13, 0x9
    beq x11, x13, print_9
    li x13, 0xA
    beq x11, x13, print_A
    li x13, 0xB
    beq x11, x13, print_B
    li x13, 0xC
    beq x11, x13, print_C
    li x13, 0xD
    beq x11, x13, print_D
    li x13, 0xE
    beq x11, x13, print_E
    li x13, 0xF
    beq x11, x13, print_F
    j tail
print_0:
    li x14, 0x30
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_1:
    li x14, 0x31
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_2:
    li x14, 0x32
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_3:
    li x14, 0x33
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_4:
    li x14, 0x34
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_5:
    li x14, 0x35
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_6:
    li x14, 0x36
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_7:
    li x14, 0x37
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_8:
    li x14, 0x38
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_9:
    li x14, 0x39
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_A:
    li x14, 0x41
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_B:
    li x14, 0x42
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_C:
    li x14, 0x43
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_D:
    li x14, 0x44
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_E:
    li x14, 0x45
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
print_F:
    li x14, 0x46
    lui a5, 0x5
    sb x14, 0(a5)
    j tail
tail:
    bgt x12, x0, printloop

    // print a linebreak
    li a4, 0x0A
    add a5, x0, x0
    lui a5, 0x5
    sb a4, 0(a5)

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
