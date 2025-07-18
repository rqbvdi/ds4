CC=../gcc.sh
SIZE=../size.sh
OBJCOPY=../objcopy.sh

.PHONY: all clean


%.bin: %.elf
	$(OBJCOPY) -O binary -j .init -j .text $< instruction_mem.bin
	$(OBJCOPY) -O binary -j .rodata -j .data -j .sdata -j sbss $< data_mem.bin

OBJECTS := main.o start.o printf.o

all: test_printf.elf test_printf.bin

test_printf.elf: $(OBJECTS)
	$(CC) -o test_printf.elf -v -march=rv32i -nostartfiles -Tlinker_script.ld -Wl,--Map,test_printf.map $(OBJECTS)
	$(SIZE) test_printf.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) test_printf.elf r.bin test_printf.map instruction_mem.bin data_mem.bin


main.o: main_rv32.c
	$(CC) -c -o $@ -march=rv32i -Wall -O0  -ffreestanding -fno-builtin -std=gnu99 -Wall -Werror=implicit-function-declaration  $<
printf.o: printf.c printf.h
	$(CC) -c -o $@ -march=rv32i -Wall -O0  -ffreestanding -fno-builtin -std=gnu99 -Wall -Werror=implicit-function-declaration  $<
start.o: start.S
	$(CC) -c -o $@ -march=rv32i -Wall -O0  -ffreestanding -fno-builtin -std=gnu99 -Wall -Werror=implicit-function-declaration $<
