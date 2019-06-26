# Canonical models of some predictable pipelines

This repository contains a set of
[UCLID5](https://github.com/uclid-org/uclid) models of 3 predictable
pipelines (SIC, Patmos and PRET), 1 commerical pipeline (K1) and a
classical in-order pipeline.

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
|     +---- riscv	 // RISC-like pipeline models (SIC, PRET, Patmos, in-order)
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

Running models
--------------


