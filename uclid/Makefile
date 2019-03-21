UCLID = uclid

RULES ?= sic
APP ?= test-main

.PHONY: test parse

parse:
	$(UCLID) src/isa.ucl src/instruction.ucl src/$(RULES).ucl test/$(APP).ucl

test:
	$(UCLID) src/isa.ucl src/instruction.ucl src/$(RULES).ucl test/test-$(RULES).ucl test/conditions-$(APP).ucl test/param-$(RULES)-$(APP).ucl test/test-properties.ucl > output/$(RULES)-$(APP).log

tests:
	make test APP=check-branching 
	make test APP=check-mem 
	make test APP=check-data_dependency 
	make test APP=check-nready_pre 
	make test APP=check-nready_mem 
	make test APP=check-timing_anomaly 

test-sic-all:
	make tests RULES=sic

test-inorder-all:
	make tests RULES=inorder

test-all:
	make test-sic-all
	make test-inorder-all
