SAIL_SEQ_INST  = patmos.sail 
SAIL_RMEM_INST = patmos.sail 

SAIL_SEQ_INST_SRCS  = patmos_insts_begin.sail $(SAIL_SEQ_INST) patmos_insts_end.sail
SAIL_RMEM_INST_SRCS = patmos_insts_begin.sail $(SAIL_RMEM_INST) patmos_insts_end.sail

# non-instruction sources
SAIL_OTHER_SRCS = prelude.sail patmos_types.sail patmos_sys.sail patmos_platform.sail patmos_mem.sail 

SAIL_SRCS      = $(addprefix model/,$(SAIL_OTHER_SRCS) $(SAIL_SEQ_INST_SRCS)  patmos_step.sail patmos_analysis.sail)

PLATFORM_OCAML_SRCS = $(addprefix ocaml_emulator/,platform.ml platform_impl.ml patmos_ocaml_sim.ml)

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

#Coq BBV library hopefully checked out in directory above us
BBV_DIR?=../bbv

C_WARNINGS ?=
#-Wall -Wextra -Wno-unused-label -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-unused-function
C_INCS = $(addprefix c_emulator/,patmos_prelude.h patmos_platform_impl.h patmos_platform.h)
C_SRCS = $(addprefix c_emulator/,patmos_prelude.c patmos_platform_impl.c patmos_platform.c)

C_FLAGS = -I $(SAIL_LIB_DIR) -I c_emulator
C_LIBS  = -lgmp -lz

ifneq (,$(COVERAGE))
C_FLAGS += --coverage -O1
SAIL_FLAGS += -Oconstant_fold
else
C_FLAGS += -O2
endif

all: ocaml_emulator/patmos_ocaml_sim c_emulator/patmos_sim patmos_isa 

.PHONY: all patmos_isa

check: $(SAIL_SRCS) model/main.sail Makefile
	$(SAIL) $(SAIL_FLAGS) $(SAIL_SRCS) model/main.sail

interpret: $(SAIL_SRCS) model/main.sail
	$(SAIL) -i $(SAIL_FLAGS) $(SAIL_SRCS) model/main.sail

cgen: $(SAIL_SRCS) model/main.sail
	$(SAIL) -cgen $(SAIL_FLAGS) $(SAIL_SRCS) model/main.sail

generated_definitions/ocaml/patmos.ml: $(SAIL_SRCS) Makefile
	mkdir -p generated_definitions/ocaml
	$(SAIL) $(SAIL_FLAGS) -ocaml -ocaml-nobuild -ocaml_build_dir generated_definitions/ocaml -o patmos $(SAIL_SRCS)

ocaml_emulator/_sbuild/patmos_ocaml_sim.native: generated_definitions/ocaml/patmos.ml ocaml_emulator/_tags $(PLATFORM_OCAML_SRCS) Makefile
	mkdir -p ocaml_emulator/_sbuild
	cp ocaml_emulator/_tags $(PLATFORM_OCAML_SRCS) generated_definitions/ocaml/*.ml ocaml_emulator/_sbuild
	cd ocaml_emulator/_sbuild && ocamlbuild -use-ocamlfind patmos_ocaml_sim.native

ocaml_emulator/_sbuild/coverage.native: generated_definitions/ocaml/patmos.ml ocaml_emulator/_tags.bisect $(PLATFORM_OCAML_SRCS) Makefile
	mkdir -p ocaml_emulator/_sbuild
	cp $(PLATFORM_OCAML_SRCS) generated_definitions/ocaml/*.ml ocaml_emulator/_sbuild
	cp ocaml_emulator/_tags.bisect ocaml_emulator/_sbuild/_tags
	cd ocaml_emulator/_sbuild && ocamlbuild -use-ocamlfind patmos_ocaml_sim.native && cp -L patmos_ocaml_sim.native coverage.native

ocaml_emulator/patmos_ocaml_sim: ocaml_emulator/_sbuild/patmos_ocaml_sim.native
	rm -f $@ && ln -s _sbuild/patmos_ocaml_sim.native $@

ocaml_emulator/coverage: ocaml_emulator/_sbuild/coverage.native
	rm -f ocaml_emulator/patmos_ocaml_sim && ln -s ocaml_emulator/_sbuild/coverage.native ocaml_emulator/patmos_ocaml_sim # since the test scripts runs this file
	rm -rf bisect*.out bisect ocaml_emulator/coverage
	./test/run_tests.sh # this will generate bisect*.out files in this directory
	mkdir ocaml_emulator/bisect && mv bisect*.out bisect/
	mkdir ocaml_emulator/coverage && bisect-ppx-report -html ocaml_emulator/coverage/ -I ocaml_emulator/_sbuild/ bisect/bisect*.out

gcovr:
	gcovr -r . --html --html-detail -o index.html

generated_definitions/ocaml/patmos_duopod_ocaml: model/prelude.sail model/patmos_duopod.sail
	mkdir -p generated_definitions/ocaml
	$(SAIL) $(SAIL_FLAGS) -ocaml -ocaml_build_dir generated_definitions/ocaml -o patmos_duopod_ocaml $^

ocaml_emulator/tracecmp: ocaml_emulator/tracecmp.ml
	ocamlfind ocamlopt -annot -linkpkg -package unix $^ -o $@

generated_definitions/c/patmos.c: $(SAIL_SRCS) model/main.sail Makefile
	mkdir -p generated_definitions/c
	$(SAIL) $(SAIL_FLAGS) -O -memo_z3 -c -c_include patmos_prelude.h -c_include patmos_platform.h $(SAIL_SRCS) model/main.sail 1> $@

c_emulator/patmos_c: generated_definitions/c/patmos.c $(C_INCS) $(C_SRCS) Makefile
	gcc $(C_WARNINGS) $(C_FLAGS) $< $(C_SRCS) $(SAIL_LIB_DIR)/*.c -lgmp -lz -I $(SAIL_LIB_DIR) -o $@

generated_definitions/c/patmos_model.c: $(SAIL_SRCS) model/main.sail Makefile
	mkdir -p generated_definitions/c
	$(SAIL) $(SAIL_FLAGS) -O -memo_z3 -c -c_include patmos_prelude.h -c_include patmos_platform.h -c_no_main $(SAIL_SRCS) model/main.sail 1> $@

c_emulator/patmos_sim: generated_definitions/c/patmos_model.c c_emulator/patmos_sim.c $(C_INCS) $(C_SRCS) $(CPP_SRCS) Makefile
	gcc -g $(C_WARNINGS) $(C_FLAGS) $< c_emulator/patmos_sim.c $(C_SRCS) $(SAIL_LIB_DIR)/*.c $(C_LIBS) -o $@

latex: $(SAIL_SRCS) Makefile
	mkdir -p generated_definitions/latex
	$(SAIL) -latex -latex_prefix sail -o generated_definitions/latex $(SAIL_SRCS)
clean:
	-rm -rf generated_definitions/ocaml/* generated_definitions/c/*
	-rm -rf ocaml_emulator/_sbuild ocaml_emulator/_build ocaml_emulator/patmos_ocaml_sim ocaml_emulator/tracecmp
	ocamlbuild -clean

PATMOS?=../patmos
ASMPATH?=$(PATMOS)/asm
APP?=basic

assemble:
	paasm $(ASMPATH)/$(APP).s $(APP).bin

