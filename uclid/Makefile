UCLID = uclid

RULES ?= sic
APP ?= test-main
PROPERTY ?= default

.PHONY: test parse

parse:
	$(UCLID) src/isa.ucl src/instruction.ucl src/$(RULES).ucl test/$(APP).ucl

old_test: 
	$(UCLID) src/isa.ucl src/instruction.ucl src/sic.ucl test/test-sic-stall-branch.ucl
	$(UCLID) src/isa.ucl src/instruction.ucl src/sic.ucl test/test-sic-stall-mem.ucl
	$(UCLID) src/isa.ucl src/instruction.ucl src/sic.ucl test/test-sic-stall-data_dependency.ucl
	$(UCLID) src/isa.ucl src/instruction.ucl src/sic.ucl test/test-sic-stall-check-nready_pre.ucl
	$(UCLID) src/isa.ucl src/instruction.ucl src/sic.ucl test/test-sic-stall-check-nready_mem.ucl
	$(UCLID) src/isa.ucl src/instruction.ucl src/sic.ucl test/test-sic-stall-check-timing_anomaly.ucl

test:
	$(UCLID) src/isa.ucl src/instruction.ucl src/$(RULES).ucl test/test-$(RULES).ucl test/param-$(RULES)-$(APP).ucl test/conditions-$(APP).ucl test/property-$(PROPERTY).ucl > output/$(RULES)-$(APP).log

tests:
	make test APP=check-branching 
	make test APP=check-mem 
	make test APP=check-data_dependency 
	make test APP=check-nready_pre 
	make test APP=check-nready_mem 
	make test APP=check-timing_anomaly PROPERTY=notiming-anomaly-LTL

test-sic-all:
	make tests RULES=sic
	make test RULES=sic APP=notiming-anomaly PROPERTY=notiming-anomaly-LTL
	make test RULES=sic-simplified APP=notiming-anomaly PROPERTY=notiming-anomaly-LTL
	make test RULES=sic-simplified-delay APP=notiming-anomaly PROPERTY=notiming-anomaly-delays

test-inorder-all:
	make tests RULES=inorder
	make test RULES=inorder APP=notiming-anomaly PROPERTY=notiming-anomaly-LTL
	make test RULES=inorder-delay APP=notiming-anomaly PROPERTY=notiming-anomaly-delays

test-all:
	make test-sic-all
	make test-inorder-all
