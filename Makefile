
PATMOS?=../patmos
ASMPATH?=$(PATMOS)/asm
APP?=basic

assemble:
	paasm $(ASMPATH)/$(APP).s $(APP).bin

