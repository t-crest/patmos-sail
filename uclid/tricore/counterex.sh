#!/bin/bash

# add value printing for each SMT file
for i in $(ls smtLogwaw_reduc_code_spec-property_no_timing_anomaly:safety-vbmc-*); do
	sed 's/(get-info :all-statistics)//' $i > iter0-$i
	# prerequisite and initial values
	printf "\n(set-option :produce-models true)
(get-value (initial_28___ucld_164_latencies_i_var
initial_29___ucld_166_stages_i_var
initial_81___ucld_163_ops_j_var
initial_66___ucld_167_stage_j_var
initial_13___ucld_165_latencies_j_var
initial_99___ucld_168_bus_var
initial_7___ucld_172_waw_var
initial_100___ucld_170_full_SB_j_var
initial_18___ucld_162_ops_i_var
initial_101___ucld_171_mem_dep_var
initial_50___ucld_169_full_SB_i_var))" >> iter0-$i

	# detailed trace (values up to depth=bound)
	for j in {1..42}; do
		printf "\n(get-value (state_${j}___ucld_138___ucld_104___ucld_73_previous_stages_var_var_var
state_${j}___ucld_133___ucld_106___ucld_81_previous_stalled_var_var_var
state_${j}___ucld_154___ucld_110___ucld_74_current_latencies_var_var_var
state_${j}___ucld_144___ucld_114___ucld_75_previous_latencies_var_var_var
state_${j}___ucld_136___ucld_107___ucld_77_previous_delays_var_var_var
state_${j}___ucld_140___ucld_111___ucld_72_current_stages_var_var_var
state_${j}___ucld_152___ucld_116___ucld_78_current_progress_var_var_var
state_${j}___ucld_141___ucld_112___ucld_80_current_stalled_var_var_var
state_${j}___ucld_130___ucld_100___ucld_76_current_delays_var_var_var
state_${j}___ucld_153___ucld_120___ucld_79_previous_progress_var_var_var))" >> iter0-$i
	done
	
	printf "\n\n(get-info :all-statistics)\n" >> iter0-$i
done


# choose a start file (a certain depth)
basename='smtLogwaw_reduc_code_spec-property_no_timing_anomaly:safety-vbmc-0170.smt'

# solve it
# do while sat, eliminate the counter-example juste found (duplicate the file with an additional assertion as the disjunction of the negations of the initial values just found)
iter=0

while [ true ]; do
	printf "\n\n** iteration $iter **\n"
	filename="iter$iter-$basename"
	sol=$(time z3 $filename)
	echo "$sol"
	echo "$sol" > "cex-iter$iter-$basename"
	res=$(echo "$sol" | head -1)

	if [ "$res" == "sat" ]
	then
		line=2
		a="(assert (or (not (= $(echo "$sol" | sed -n ${line}p | sed 's/^((//'))"
		for ((j = $((line+1)); j <= $((line+9)); j++)); do
			a+="
(or (not (= $(echo "$sol" | sed -n ${j}p | sed 's/^ (//'))"
		done
		((line+=10))
		a+="
(not (= $(echo "$sol" | sed -n ${line}p | sed 's/^ (//'))))))))))))"
		
		((iter++))
		filename2="iter$iter-$basename"
		awk -v repl="\n$a\n\n\n(check-sat)" '{ gsub(/\(check-sat\)/,repl,$0); print $0 }' $filename > $filename2
	else
		break
	fi
done
