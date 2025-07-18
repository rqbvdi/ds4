#!/bin/bash
CC=riscv32-unknown-elf-size
${CC} $@ || ${CC} $@