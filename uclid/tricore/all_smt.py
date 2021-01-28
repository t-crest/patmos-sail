# coding: utf8
from z3 import *
import re, time

'''
	This script checks whether an SMT problem as an input SMT-lib file is satisfiable and enumerates all its solutions using the solver z3.
'''

# Parsing strings/files for addional assertions needs redeclaration of the terms
decls = '''(declare-datatypes ((_enum_1 0)) (((load_op) (store_op) (mac_op) (nop) (other_op))))
(declare-datatypes ((_tuple_6 0)) (((_tuple_6 (I_instr _enum_1) (LS_instr _enum_1)))))
(declare-datatypes ((_tuple_5 0)) (((_tuple_5 (I_pipe Bool) (LS_pipe Bool)))))
(declare-datatypes ((_tuple_4 0)) (((_tuple_4 (pbus_i _tuple_5) (pbus_j _tuple_5) (dbus_i Bool) (dbus_j Bool)))))
(declare-datatypes ((_tuple_2 0)) (((_tuple_2 (IF_lat Int) (ID_lat Int) (EX_lat Int) (EX2_lat Int) (WB_lat Int) (ST_lat Int)))))
(declare-datatypes ((_tuple_3 0)) (((_tuple_3 (I_pipe _tuple_2) (LS_pipe _tuple_2)))))
(declare-datatypes ((_enum_0 0)) (((pre) (IF) (ID) (EX) (EX2) (WB) (ST) (post))))
(declare-datatypes ((_tuple_7 0)) (((_tuple_7 (ii Bool) (ij Bool) (ji Bool) (jj Bool)))))
(declare-datatypes ((_tuple_1 0)) (((_tuple_1 (I_pipe Int) (LS_pipe Int)))))
(declare-datatypes ((_tuple_0 0)) (((_tuple_0 (I_pipe _enum_0) (LS_pipe _enum_0)))))
(declare-fun initial_28___ucld_164_latencies_i_var () _tuple_3)
(declare-fun initial_110___ucld_144___ucld_114___ucld_75_previous_latencies_var_var_var
             ()
             _tuple_1)
(declare-fun initial_29___ucld_166_stages_i_var () _tuple_0)
(declare-fun initial_81___ucld_163_ops_j_var () _tuple_6)
(declare-fun initial_66___ucld_167_stage_j_var () _enum_0)
(declare-fun initial_13___ucld_165_latencies_j_var () _tuple_3)
(declare-fun initial_99___ucld_168_bus_var () _tuple_4)
(declare-fun initial_7___ucld_172_waw_var () _tuple_7)
(declare-fun initial_100___ucld_170_full_SB_j_var () Bool)
(declare-fun initial_18___ucld_162_ops_i_var () _tuple_6)
(declare-fun initial_101___ucld_171_mem_dep_var () Bool)
(declare-fun initial_50___ucld_169_full_SB_i_var () Bool)'''


def eval_model(m, term):
	''' Get a satisfying interpretation for term from the model m without Z3 Python objects '''
	for e in m.decls():
		if e.name() == term:
			#print(m.get_interp(e).sort())
			return m.get_interp(e)
	exit('Failed to find expr: '+term+' in model.') 

def all_smt(s, initial_terms):
	''' Start the solution enumeration '''
	def format_value(v):
		''' Convert Python's value format into SMT-lib's '''
		return re.sub(r'_tuple_(\d+)\(', r'(_tuple_\1 ', str(v).replace('True', 'true').replace('False', 'false').replace(',', ''))
		
	def block_term(s, m, t):
		''' Add a not=term constraint to the solver '''
		constraints = parse_smt2_string(decls+"\n(assert (not (= "+t+" "+format_value(eval_model(m, t))+")))")
		s.add(constraints)
		#s.add(t != eval_model(m, t))
		
	def fix_term(s, m, t):
		''' Add a =term constraint to the solver '''
		constraints = parse_smt2_string(decls+"\n(assert (= "+t+" "+format_value(eval_model(m, t))+"))")
		s.add(constraints)
		#s.add(t == eval_model(m, t))
		
	def all_smt_rec(terms):
		''' Split the state space into disjoint problems and solve them '''
		global iteration
		print("** iteration "+str(iteration))
		iteration += 1
		
		if sat == s.check():
			m = s.model()
			if 'time' in s.statistics().keys():
				print("\t\ttime: "+str(s.statistics().get_key_value('time')))
			for e in state0_terms.items():
				print("\t\t"+e[0]+"="+str(eval_model(m, e[1])))
			#for e in stateN_terms:
			#	print(e+"="+str(eval_model(m, e)))
			yield m
			
			for i in range(len(terms)):
				block_str = terms[i][0]+" ≠ "+str(eval_model(m, terms[i][1])).replace('\n', '')
				fix_strs = []
				print("\n** Blocking new term: "+block_str)
				print("** Fixing new term(s):" if i > 0 else "** Fixing new terms: None")
				
				s.push()
				''' Accumulate (and then remove) assertions freezing the first constants (up to i-1) and forcing the i-th to vary wrt to the previous set of assertions '''
				block_term(s, m, terms[i][1])
				for j in range(i):
					fix_strs.append(terms[j][0]+" = "+str(eval_model(m, terms[j][1])).replace('\n', ''))
					fix_term(s, m, terms[j][1])
				if (len(fix_strs)): print(fix_strs)
					
				for m in all_smt_rec(terms[i+1:]):
					yield m
				s.pop()
				
				print("(* Forgetting: "+block_str)
				if (len(fix_strs)): print(fix_strs)
				print("*)")
		else:
			print("\t\tunsat")
	
	for m in all_smt_rec(initial_terms):
		yield m


if len(sys.argv) < 2:
	a = raw_input("Wrong usage: $ python all_smt.py filename\nDo you want to execute: $ python all_smt.pysmt_prop_together/smtLogwaw_reduc_code_spec-property_no_timing_anomaly:safety-vbmc-0170.smt now? [y/n] ")
	if a == 'y':
		filename = "smt_prop_together/smtLogwaw_reduc_code_spec-property_no_timing_anomaly:safety-vbmc-0170.smt"
	else:
		exit()
else:
	filename = sys.argv[1]
	
print("Solving file: "+filename)
s = Solver()
constraints = parse_smt2_file(filename, sorts={}, decls={})
s.add(constraints)
#s.from_file(filename)
#print(s.units().sexpr())

# Set of (tagged) constants used as main terms (for space exploration)
state0_terms = {"latencies_i": "initial_28___ucld_164_latencies_i_var",
"stages_i": "initial_29___ucld_166_stages_i_var",
"ops_j": "initial_81___ucld_163_ops_j_var",
"stage_j": "initial_66___ucld_167_stage_j_var",
"latencies_j": "initial_13___ucld_165_latencies_j_var",
"bus": "initial_99___ucld_168_bus_var",
"waw": "initial_7___ucld_172_waw_var",
"full_SB_j": "initial_100___ucld_170_full_SB_j_var",
"ops_i": "initial_18___ucld_162_ops_i_var",
"mem_dep": "initial_101___ucld_171_mem_dep_var",
"full_SB_i": "initial_50___ucld_169_full_SB_i_var"}

# For detailed traces only (full counter-examples)
stateN_terms = list()
for i in range(1, 43):
	stateN_terms.append("state_"+str(i)+"___ucld_138___ucld_104___ucld_73_previous_stages_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_133___ucld_106___ucld_81_previous_stalled_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_154___ucld_110___ucld_74_current_latencies_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_144___ucld_114___ucld_75_previous_latencies_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_136___ucld_107___ucld_77_previous_delays_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_140___ucld_111___ucld_72_current_stages_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_152___ucld_116___ucld_78_current_progress_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_141___ucld_112___ucld_80_current_stalled_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_130___ucld_100___ucld_76_current_delays_var_var_var")
	stateN_terms.append("state_"+str(i)+"___ucld_153___ucld_120___ucld_79_previous_progress_var_var_var")

# Solve
start_time = time.time()
iteration = 0
for m in all_smt(s, state0_terms.items()): continue
print("Total time (s): "+str(time.time()-start_time))

