.PHONY: all clean

%.bin: %.elf 	#riscv32-unknown-elf-objcopy -j .text -O binary $< $@
	../objcopy.sh -O binary -j .init -j .text $< instruction_mem.bin
	../objcopy.sh -O binary -j .rodata -j .data -j .sdata -j sbss $< data_mem.bin

OBJECTS := start.o

all: gauss.elf gauss.bin

gauss.elf: $(OBJECTS)
	../gcc.sh -o gauss.elf -march=rv32i -nostartfiles -Wl,-m,elf32lriscv --specs=nosys.specs -Wl,--no-relax -Wl,--gc-sections -Wl,-Tlinker_script.ld -Wl,--Map,gauss.map $(OBJECTS)
	../size.sh gauss.elf

clean:
	-$(RM) $(OBJECTS)
	-$(RM) gauss.elf gauss.map data_mem.bin instruction_mem.bin

start.o: start.S
	../gcc.sh -c -o $@ -march=rv32i -Wall -O0 -fomit-frame-pointer -ffreestanding -fno-builtin -I./..  -std=gnu99 -Wall -Werror=implicit-function-declaration -ffunction-sections -fdata-sections $<
