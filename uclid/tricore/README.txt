* src/ contains the UCLID5 specification of TriCore
* test/ contains all the auxiliary files, which fix the properties to verify, the constants and the initial conditions.
* all_smt.py implements the SMT-based heuristics.


The following commands enable to rerun all the experiments conducted for the FMICS 20 paper:
    Scalable Detection of Amplification TimingAnomalies for the Superscalar TriCoreArchitecture
and for the STTT paper:
    Formal Modeling and Verification for Amplification Timing Anomalies in the Superscalar TriCore Architecture

* Evaluations of various configurations (Table 6 in STTT):
$ ./tricore-notiming-anomaly.sh #cond ['smtLog'] ['before']
    'smtLog' produces the SMT files instead of calling the SMT solver
    'before' uses the stalling-before specific logic instead of whole

Verification					| #cond			| Depth	| Time
-----------------------------------------------------------------------------------------------------------------------------------------------------
~1 pipeline, SB					| pipeline_reduc	| 38	| 411,56s user 1,54s system 102% cpu 6:41,80 total
+ general reductions				| pipeline_general_reduc| 38	| 323,66s user 1,33s system 103% cpu 5:13,63 total
+ memdep					| reduc_memdep		| 38	| 333,35s user 1,34s system 103% cpu 5:23,17 total
2nd pipeline + general reductions + memdep	| dual_pipeline_memdep	| 53	| 30168,53s user 36,21s system 100% cpu 8:23:04,48 total
+ pipeline reductions + WAW hazards		| waw			| >53	| *26629,56s user 28,83s system 100% cpu 7:23:53,00 total (53) — (>54)
+ WAW reductions				| waw_reduc		| 53	| 24707,26s user 36,29s system 100% cpu 6:52:15,03 total
- SB						| waw_reduc_noSB	| 53	| 12711,24s user 73,43s system 97% cpu 3:38:37,54 total
- WAW reductions				| waw_noSB		| 53	| 13311,25s user 75,16s system 97% cpu 3:48:35,00 total
code-specific waw_reduc				| waw_reduc_code_spec	| 42	| 1734,55s user 4,00s system 100% cpu 28:48,99 total


* Evaluation of the SMT-based heuristics (Tables 9, 10 and 11 in STTT):
$ python all_smt.py smt_filename 'approx'|'all'|'all_actual'
    smt_filename is the file that contains the SMT problem (SMT-Lib format)
    'approx': broad-spectrum incremental exploration (Algo 2)
    'all_actual': delay-scenario exploration (Algo 3)
    'all': basic (Algo 1)
