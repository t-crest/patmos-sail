UCLID = uclid

DIR ?= riscs
# Possible rules for run-specific: patmos, pret
# Possible rules for run-sic: sic (this model is intermediate: specific for test and param but not for conditions and properties)
# Possible rules for inorder: inorder-nostalling-onmiss, inorder-stalling-before-onmiss, inorder-stalling-whole-onmiss
RULES ?= inorder
APP ?= test-check
PROPERTY ?= default

.PHONY: parse run-specific run-generic

parse:
	$(UCLID) src/$(DIR)/common.ucl src/$(DIR)/$(RULES).ucl test/$(APP).ucl

run-specific:
	$(UCLID) src/$(DIR)/common.ucl src/$(DIR)/$(RULES).ucl test/$(RULES)/test.ucl test/$(RULES)/param-$(APP).ucl test/$(RULES)/conditions-$(APP).ucl test/$(RULES)/property-$(PROPERTY).ucl

run-sic:
	$(UCLID) src/$(DIR)/common.ucl src/$(DIR)/sic.ucl test/sic/test.ucl test/sic/param-$(APP).ucl test/inorder/conditions-$(APP).ucl test/inorder/property-$(PROPERTY).ucl

run-inorder:
	$(UCLID) src/$(DIR)/common.ucl src/$(DIR)/$(RULES).ucl test/inorder/test.ucl test/inorder/param-$(APP).ucl test/inorder/conditions-$(APP).ucl test/inorder/property-$(PROPERTY).ucl
