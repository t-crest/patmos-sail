UCLID = uclid

PIPELINE_RULES ?= sic
TEST_APP ?= test-main

.PHONY: test parse

parse:
	$(UCLID) src/isa.ucl src/instruction.ucl src/$(PIPELINE_RULES).ucl test/$(TEST_APP).ucl

test:
	$(UCLID) src/isa.ucl src/instruction.ucl src/$(PIPELINE_RULES).ucl test/$(TEST_APP).ucl > output/$(TEST_APP).log

test-sic-all:
	make test TEST_APP=test-sic-stall-branch
	make test TEST_APP=test-sic-stall-mem
	make test TEST_APP=test-sic-stall-data_dependency
	make test TEST_APP=test-sic-check-nready_pre
	make test TEST_APP=test-sic-check-nready_mem
	make test TEST_APP=test-sic-check-timing_anomaly
