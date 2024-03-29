# Canonical models of some predictable pipelines

This repository contains a set of
[UCLID5](https://github.com/uclid-org/uclid) models of 3 predictable
pipelines (SIC, [Patmos](http://patmos.compute.dtu.dk/) and PRET), 1
commercial pipeline (K1) and a classical in-order pipeline.

A paper describing these models have been submitted

Directory Structure
-------------------


```
uclid
|
+---- src   
|     |
|     +---- old		 // Old versions of the pipeline models
|     +
|     +---- riscs // RISC-like pipeline models (SIC, PRET, Patmos, in-order)
|     +	    		 // Some models are available with different stalling logics
|     +---- k1
|
+---- test               // test files for setting the exploration strategy and
|     |		 	 // and specifying properties
|     +---- inorder		 
|     +---- patmos
|     +---- pret	 
|     +---- sic	
|     +---- k1
|     +---- old      
```

Description of each model
-------------------

In the src directory

- The list of available models are: inorder, patmos, pret (pret.ucl),
sic (sic.ucl) and k1 (k1.ucl).

- The inorder model can be used with 3 different stalling logic:
specific upstream (nostalling-onmiss.ucl), only upstream
(stalling-before-onmiss.ucl) and whole (stalling-whole-onmiss.ucl).

- The patmos model can be used with 2 different stalling logic: whole
stalling (patmos-singleissue-methodcache.ucl) and specific upstream
(patmos-singleissue-methodcache-nostalling-onmiss.ucl).

- Common.ucl describes common features to one or several pipelines

In the test directory

- For each model, there is a test.ucl that instantiates the pipeline

- condition-* describes several concrete test cases or abstract test
  cases using assume statements of UCLID5. The
  condition-notiming-anomaly.ucl implements the required strategy to
  check whether a downstream instruction can be blocked by an upstream
  instruction.

- param-* for setting BMC depths for the different available test cases.

- property-* the default properties being checked
  (property-default.ucl) to ensure that the developed models are
  correct and the specific property using the delay of the downstream
  instruction (property-notiming-anomaly.ucl). 

- test-check.ucl is used to verify that models in the src directory can
  be parsed by uclid

How to run some models 
-------------------

The following are examples of how to run models. Please modify to pick
the appropriate stalling logic and test case as needed.

In-order model:

```
uclid src/riscs/common.ucl src/riscs/inorder-nostalling-onmiss.ucl test/inorder/test.ucl test/inorder/param-notiming-anomaly.ucl test/inorder/conditions-notiming-anomaly.ucl test/inorder/property-notiming-anomaly.ucl
```

Patmos model:

```
uclid src/riscs/common.ucl src/riscs/patmos-singleissue-methodcache.ucl test/patmos/test.ucl test/patmos/param-notiming-anomaly.ucl test/patmos/conditions-notiming-anomaly.ucl test/patmos/property-notiming-anomaly.ucl
```

SIC model:

```
uclid src/riscs/common.ucl src/riscs/sic.ucl test/sic/test.ucl test/sic/param-notiming-anomaly.ucl test/inorder/conditions-notiming-anomaly.ucl test/inorder/property-notiming-anomaly.ucl
```

PRET model:

```
uclid src/riscs/common.ucl src/riscs/pret.ucl test/pret/test.ucl test/pret/param-notiming-anomaly.ucl test/pret/conditions.ucl test/inorder/property-notiming-anomaly.ucl
```

K1 model:

```
uclid src/k1/common.ucl src/k1/k1.ucl test/k1/test.ucl test/k1/param-default.ucl test/k1/conditions-notiming-anomaly.ucl test/k1/property-notiming-anomaly.ucl
```






