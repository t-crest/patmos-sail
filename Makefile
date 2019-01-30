SAIL_INST_SRCS = patmos_insts_begin.sail patmos.sail patmos_insts_end.sail

# non-instruction sources
SAIL_OTHER_SRCS = prelude.sail patmos_types.sail 

SAIL_SRCS      = $(addprefix model/,$(SAIL_OTHER_SRCS) $(SAIL_INST_SRCS))

#Attempt to work with either sail from opam or built from repo in SAIL_DIR
ifneq ($(SAIL_DIR),)
# Use sail repo in SAIL_DIR
SAIL:=$(SAIL_DIR)/sail
export SAIL_DIR
else
# Use sail from opam package
SAIL_DIR=$(shell opam config var sail:share)
SAIL:=sail
endif
SAIL_LIB_DIR:=$(SAIL_DIR)/lib
SAIL_SRC_DIR:=$(SAIL_DIR)/src

ifneq (,$(COVERAGE))
SAIL_FLAGS += -Oconstant_fold
endif

all: check

.PHONY: all patmos_isa

check: $(SAIL_SRCS) model/main.sail Makefile
	$(SAIL) $(SAIL_FLAGS) $(SAIL_SRCS) model/main.sail

interpret: $(SAIL_SRCS) model/main.sail
	$(SAIL) -i $(SAIL_FLAGS) $(SAIL_SRCS) model/main.sail


latex: $(SAIL_SRCS) Makefile
	mkdir -p generated_definitions/latex
	$(SAIL) -latex -latex_prefix sail -o generated_definitions/latex $(SAIL_SRCS)

clean:
	-rm -rf generated_definitions/latex/*

PATMOS?=../patmos
ASMPATH?=$(PATMOS)/asm
APP?=basic

assemble:
	paasm $(ASMPATH)/$(APP).s $(APP).bin

