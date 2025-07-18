#!/bin/bash
CC=riscv32-unknown-elf-objcopy
${CC} $@ || ${CC} $@