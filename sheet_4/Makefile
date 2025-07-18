BUILD=build
BIN=bin
CC=ghdl
CPP_CC=clang++
CPP_FLAGS=-O3 -Wall -Wextra -pedantic-errors -Werror -std=c++20
LIB=work
SRC=src
TB=testbench
COMMON_FLAGS=--std=08 --work=$(LIB) --workdir=$(BUILD)
AFLAGS=-a $(COMMON_FLAGS)
EFLAGS=-e $(COMMON_FLAGS)
MK=Makefile
HDL_COMMON_DEPS=$(MK)

UNAME_S=$(shell uname -s)
ifeq ($(UNAME_S),Linux)
	SED_BAK=
else
	SED_BAK='.bak'
endif


SCRIPTS=scripts
TOC=chapter_list.txt
TEMPLATES=templates
INPUT=input
SLIDES=slides
SHEETS=exercises
DUE_DATES=$(SHEETS)/due_dates.txt
COMMON_DEPS=$(INPUT)/colors.tex $(INPUT)/commands.tex $(MK)
SLIDE_STYLE=$(INPUT)/slide_style.tex
SLIDE_DEPS=$(TEMPLATES)/slides.tex $(SLIDE_STYLE) $(COMMON_DEPS) $(TOC)
FIGURE_DEPS=$(COMMON_DEPS) \
            $(INPUT)/tikz_style.tex \
            $(INPUT)/tikz-shape-papersheet.tex \
			$(INPUT)/tikzlibraryholger.hates.code.tex \
			$(INPUT)/helpers.tex



define BUILD_SHEET
	$(eval FN := $(subst /,, $(notdir $1)))
	$(eval SHEETNUM := $(shell echo $(FN) | cut -d '.' -f 1))
	$(eval SHEET_FN := sheet_$(SHEETNUM)$3.tex)
	$(eval SHEET_PATH := $(BUILD)/$(SHEET_FN))
	$(eval DUE := $(shell sed '$(SHEETNUM)q;d' $(DUE_DATES)))
	cp $(TEMPLATES)/sheet.tex $(SHEET_PATH)
	sed -i $(SED_BAK) 's/SHEET_REPLACE/$(SHEETNUM)/g' $(SHEET_PATH)
	sed -i $(SED_BAK) 's/ANSWER_REPLACE/$2/g' $(SHEET_PATH)
	sed -i $(SED_BAK) 's/DUE_REPLACE/$(DUE)/g' $(SHEET_PATH)
	$(SCRIPTS)/build.py $(BUILD)/$(SHEET_FN)
endef


define BUILD_VHDL_STAMP
	$(CC) $(AFLAGS) $1 && touch $2
endef


define BUILD_VHDL_TB
	$(eval FN := $(notdir $1))
	$(eval BN := $(basename $(FN)))
	$(CC) $(EFLAGS) -o $2 $(BN)
endef


all: \
		sheets \
		testbenches \
		$(BIN)/gen_tests


testbenches: \
		$(BUILD)/tb_mux1 \
		$(BUILD)/tb_alu_bit_functions_pkg \
		$(BUILD)/tb_bit_full_add_pkg \
		$(BUILD)/tb_alu \
		$(BUILD)/tb_register_file \
		$(BUILD)/tb_program_counter \
		$(BUILD)/tb_immediate_ext
		$(BUILD)/tb_cpu


sheets: \
		$(BUILD)/sheet_1.pdf \
		$(BUILD)/sheet_2.pdf \
		$(BUILD)/sheet_3.pdf \
		$(BUILD)/sheet_4.pdf


.SECONDARY:
$(BUILD)/%.pdf: \
		figures/%.tex \
		$(TEMPLATES)/figure.tex $(FIGURE_DEPS)
	$(eval NAME := $(notdir $<))
	$(eval TMP  := $(BUILD)/$(NAME))
	cp $(TEMPLATES)/figure.tex $(TMP)
	sed -i $(SED_BAK) 's/REPLACE/$(subst /,\/,$<)/g' $(TMP)
	pdflatex -halt-on-error -output-directory=$(subst /,,$(dir $@)) $(TMP)



.SECONDEXPANSION:
$(BUILD)/sheet_%.pdf: \
		$(SHEETS)/%.tex $(TEMPLATES)/sheet.tex $(COMMON_DEPS) \
		$(SHEETS)/submission_%.tex \
        $(DUE_DATES) \
        $$(shell $(SCRIPTS)/deps.py $(SHEETS)/%.tex) \
        $$(shell $(SCRIPTS)/deps.py $(SHEETS)/submission_%.tex) \
        $$(shell $(SCRIPTS)/deps.py $(TEMPLATES)/sheet.tex)
	$(call BUILD_SHEET,$<,\\noprintanswers,)



$(BUILD)/cpu_constants_pkg.stamp: \
		$(SRC)/cpu_constants_pkg.vhd \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/mux1.stamp: \
		$(SRC)/mux1.vhd \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_bit_full_add_pkg: \
		$(BUILD)/tb_bit_full_add_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)



$(BUILD)/alu.stamp: \
		$(SRC)/alu.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_alu.stamp: \
		$(TB)/tb_alu.vhd \
		$(BUILD)/alu.stamp \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_alu: \
		$(BUILD)/tb_alu.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)


$(BUILD)/tb_mux1.stamp:   \
		$(TB)/tb_mux1.vhd  \
		$(BUILD)/mux1.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_mux1: \
		$(BUILD)/tb_mux1.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)


$(BUILD)/program_counter.stamp: \
		$(SRC)/program_counter.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_program_counter.stamp: \
		$(TB)/tb_program_counter.vhd \
		$(BUILD)/program_counter.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_program_counter: \
		$(BUILD)/tb_program_counter.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)


$(BUILD)/immediate_ext.stamp: \
		$(SRC)/immediate_ext.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_immediate_ext.stamp: \
		$(TB)/tb_immediate_ext.vhd \
		$(BUILD)/immediate_ext.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_immediate_ext: \
		$(BUILD)/tb_immediate_ext.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)



$(BUILD)/register_file.stamp: \
		$(SRC)/register_file.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_register_file.stamp: \
		$(TB)/tb_register_file.vhd \
		$(BUILD)/register_file.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_register_file: \
		$(BUILD)/tb_register_file.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)


$(BUILD)/d_memory.stamp: \
		$(SRC)/d_memory.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)

$(BUILD)/i_memory.stamp: \
		$(SRC)/i_memory.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)

$(BUILD)/control_unit.stamp: \
		$(SRC)/control_unit.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)

$(BUILD)/branch_comparator.stamp: \
		$(SRC)/branch_comparator.vhd \
		$(BUILD)/cpu_constants_pkg.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)
	
$(BUILD)/cpu.stamp: \
		$(SRC)/cpu.vhd \
		$(BUILD)/program_counter.stamp \
		$(BUILD)/i_memory.stamp \
		$(BUILD)/d_memory.stamp \
		$(BUILD)/branch_comparator.stamp \
		$(BUILD)/control_unit.stamp \
		$(BUILD)/register_file.stamp \
		$(BUILD)/alu.stamp \
		$(BUILD)/immediate_ext.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_cpu.stamp: \
		$(TB)/tb_cpu.vhd \
		$(BUILD)/cpu.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_STAMP,$<,$@)


$(BUILD)/tb_cpu: \
		$(BUILD)/tb_cpu.stamp \
		$(HDL_COMMON_DEPS)
	$(call BUILD_VHDL_TB,$<,$@)


$(BIN)/gen_tests: \
		gen_src/gen_tests.cpp \
		$(MK)
	$(CPP_CC) -o $@ $< $(CPP_FLAGS)
	strip $@


.PHONY: clean
clean:
	@rm -f $(BUILD)/*.o
	@rm -f $(BUILD)/tb_*
	@rm -f $(BUILD)/*.cf
	@rm -f $(BUILD)/*.stamp
	@rm -rf $(BUILD)/debug
	@rm -rf $(BUILD)/release
	@rm -f $(BUILD)/*.aux
	@rm -f $(BUILD)/*.fls
	@rm -f $(BUILD)/*.log
	@rm -f $(BUILD)/*.pdf
	@rm -f $(BUILD)/*.tex
	@rm -f $(BIN)/gen_tests
	@rm -f stimuli.txt
	@find . -name stimuli.txt -delete
	@rm -f *.vcd
	@make -C rv32i_sw/hello clean
	@rm -f *.bin
	@rm -f input_data
