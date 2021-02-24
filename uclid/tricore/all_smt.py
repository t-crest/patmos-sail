# coding: utf8
from z3 import *
import re, time, csv, os.path

'''
	This script checks whether an SMT problem as an input SMT-lib file is satisfiable and enumerates its solutions using the solver z3.
'''

def tricore_init():
	global decls, state0_terms, depth_bound, states_terms, mode, type_delay
	mode = 'tricore'
	# Parsing strings/files for addional assertions needs redeclaration of the terms
	"""
	# whole
	type_delay = '_tuple_1'
	type_stages = '_tuple_0'
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
	"""
	"""
	# waw_reduc_code_spec before
	type_delay = '_tuple_6'
	type_stages = '_tuple_5'
	decls = '''(declare-datatypes ((_tuple_6 0)) (((_tuple_6 (I_pipe Int) (LS_pipe Int)))))
(declare-datatypes ((_tuple_1 0)) (((_tuple_1 (I_pipe Bool) (LS_pipe Bool)))))
(declare-datatypes ((_tuple_0 0)) (((_tuple_0 (pbus_i _tuple_1) (pbus_j _tuple_1) (dbus_i Bool) (dbus_j Bool)))))
(declare-datatypes ((_enum_0 0)) (((load_op) (store_op) (mac_op) (nop) (other_op))))
(declare-datatypes ((_tuple_2 0)) (((_tuple_2 (I_instr _enum_0) (LS_instr _enum_0)))))
(declare-datatypes ((_tuple_3 0)) (((_tuple_3 (IF_lat Int) (ID_lat Int) (EX_lat Int) (EX2_lat Int) (WB_lat Int) (ST_lat Int)))))
(declare-datatypes ((_enum_1 0)) (((pre) (IF) (ID) (EX) (EX2) (WB) (ST) (post))))
(declare-datatypes ((_tuple_7 0)) (((_tuple_7 (ii Bool) (ij Bool) (ji Bool) (jj Bool)))))
(declare-datatypes ((_tuple_5 0)) (((_tuple_5 (I_pipe _enum_1) (LS_pipe _enum_1)))))
(declare-datatypes ((_tuple_4 0)) (((_tuple_4 (I_pipe _tuple_3) (LS_pipe _tuple_3)))))
(declare-fun initial_58___ucld_162_ops_j_var () _tuple_2)
(declare-fun initial_93___ucld_167_bus_var () _tuple_0)
(declare-fun initial_38___ucld_164_latencies_j_var () _tuple_4)
(declare-fun initial_52___ucld_163_latencies_i_var () _tuple_4)
(declare-fun initial_64___ucld_168_full_SB_i_var () Bool)
(declare-fun initial_40___ucld_161_ops_i_var () _tuple_2)
(declare-fun initial_56___ucld_148___ucld_113___ucld_74_previous_latencies_var_var_var
             ()
             _tuple_6)
(declare-fun initial_11___ucld_165_stages_i_var () _tuple_5)
(declare-fun initial_71___ucld_166_stage_j_var () _enum_1)
(declare-fun initial_92___ucld_134___ucld_109___ucld_73_current_latencies_var_var_var
             ()
             _tuple_6)
(declare-fun initial_67___ucld_170_mem_dep_var () Bool)
(declare-fun initial_72___ucld_171_waw_var () _tuple_7)
(declare-fun initial_44___ucld_141___ucld_110___ucld_71_current_stages_var_var_var
             ()
             _tuple_5)
(declare-fun initial_122___ucld_169_full_SB_j_var () Bool)'''
	"""
	# waw_reduc before
	type_delay = '_tuple_6'
	type_stages = '_tuple_0'
	decls = '''(declare-datatypes ((_tuple_6 0)) (((_tuple_6 (I_pipe Int) (LS_pipe Int)))))
(declare-datatypes ((_enum_0 0)) (((pre) (IF) (ID) (EX) (EX2) (WB) (ST) (post))))
(declare-datatypes ((_tuple_0 0)) (((_tuple_0 (I_pipe _enum_0) (LS_pipe _enum_0)))))
(declare-datatypes ((_enum_1 0)) (((load_op) (store_op) (mac_op) (nop) (other_op))))
(declare-datatypes ((_tuple_3 0)) (((_tuple_3 (I_instr _enum_1) (LS_instr _enum_1)))))
(declare-datatypes ((_tuple_2 0)) (((_tuple_2 (I_pipe Bool) (LS_pipe Bool)))))
(declare-datatypes ((_tuple_7 0)) (((_tuple_7 (ii Bool) (ij Bool) (ji Bool) (jj Bool)))))
(declare-datatypes ((_tuple_4 0)) (((_tuple_4 (IF_lat Int) (ID_lat Int) (EX_lat Int) (EX2_lat Int) (WB_lat Int) (ST_lat Int)))))
(declare-datatypes ((_tuple_5 0)) (((_tuple_5 (I_pipe _tuple_4) (LS_pipe _tuple_4)))))
(declare-datatypes ((_tuple_1 0)) (((_tuple_1 (pbus_i _tuple_2) (pbus_j _tuple_2) (dbus_i Bool) (dbus_j Bool)))))
(declare-fun initial_58___ucld_162_ops_j_var () _tuple_3)
(declare-fun initial_93___ucld_167_bus_var () _tuple_1)
(declare-fun initial_38___ucld_164_latencies_j_var () _tuple_5)
(declare-fun initial_52___ucld_163_latencies_i_var () _tuple_5)
(declare-fun initial_64___ucld_168_full_SB_i_var () Bool)
(declare-fun initial_40___ucld_161_ops_i_var () _tuple_3)
(declare-fun initial_56___ucld_148___ucld_113___ucld_74_previous_latencies_var_var_var
             ()
             _tuple_6)
(declare-fun initial_11___ucld_165_stages_i_var () _tuple_0)
(declare-fun initial_71___ucld_166_stage_j_var () _enum_0)
(declare-fun initial_92___ucld_134___ucld_109___ucld_73_current_latencies_var_var_var
             ()
             _tuple_6)
(declare-fun initial_67___ucld_170_mem_dep_var () Bool)
(declare-fun initial_72___ucld_171_waw_var () _tuple_7)
(declare-fun initial_44___ucld_141___ucld_110___ucld_71_current_stages_var_var_var
             ()
             _tuple_0)
(declare-fun initial_122___ucld_169_full_SB_j_var () Bool)
'''
	
	# Set of (tagged) constants used as main terms
	'''
	# whole
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
	'''
	# before
	state0_terms = {"latencies_i": "initial_52___ucld_163_latencies_i_var",
	"stages_i": "initial_11___ucld_165_stages_i_var",
	"ops_j": "initial_58___ucld_162_ops_j_var",
	"stage_j": "initial_71___ucld_166_stage_j_var",
	"latencies_j": "initial_38___ucld_164_latencies_j_var",
	"bus": "initial_93___ucld_167_bus_var",
	"waw": "initial_72___ucld_171_waw_var",
	"full_SB_j": "initial_122___ucld_169_full_SB_j_var",
	"ops_i": "initial_40___ucld_161_ops_i_var",
	"mem_dep": "initial_67___ucld_170_mem_dep_var",
	"full_SB_i": "initial_64___ucld_168_full_SB_i_var"}
	
	# To get full counter-examples and explore depths (might require changing bounds)
	#depth_bound = 42 # code_spec
	depth_bound = 53
	states_terms = list()
	for i in range(1, depth_bound+1):
		'''
		# whole
		states_terms.append({"previous_stages": "state_"+str(i)+"___ucld_138___ucld_104___ucld_73_previous_stages_var_var_var",
		"previous_stalled": "state_"+str(i)+"___ucld_133___ucld_106___ucld_81_previous_stalled_var_var_var",
		"current_lat": "state_"+str(i)+"___ucld_154___ucld_110___ucld_74_current_latencies_var_var_var",
		"previous_lat": "state_"+str(i)+"___ucld_144___ucld_114___ucld_75_previous_latencies_var_var_var",
		"previous_delays": "state_"+str(i)+"___ucld_136___ucld_107___ucld_77_previous_delays_var_var_var",
		"current_stages": "state_"+str(i)+"___ucld_140___ucld_111___ucld_72_current_stages_var_var_var",
		"current_progress": "state_"+str(i)+"___ucld_152___ucld_116___ucld_78_current_progress_var_var_var",
		"current_stalled": "state_"+str(i)+"___ucld_141___ucld_112___ucld_80_current_stalled_var_var_var",
		"current_delays": "state_"+str(i)+"___ucld_130___ucld_100___ucld_76_current_delays_var_var_var",
		"previous_progress": "state_"+str(i)+"___ucld_153___ucld_120___ucld_79_previous_progress_var_var_var"})
		'''
		# before
		states_terms.append({"previous_stages": "state_"+str(i)+"___ucld_124___ucld_103___ucld_72_previous_stages_var_var_var",
		"previous_stalled": "state_"+str(i)+"___ucld_126___ucld_105___ucld_80_previous_stalled_var_var_var",
		"current_lat": "state_"+str(i)+"___ucld_134___ucld_109___ucld_73_current_latencies_var_var_var",
		"previous_lat": "state_"+str(i)+"___ucld_148___ucld_113___ucld_74_previous_latencies_var_var_var",
		"previous_delays": "state_"+str(i)+"___ucld_128___ucld_106___ucld_76_previous_delays_var_var_var",
		"current_stages": "state_"+str(i)+"___ucld_141___ucld_110___ucld_71_current_stages_var_var_var",
		"current_progress": "state_"+str(i)+"___ucld_143___ucld_115___ucld_77_current_progress_var_var_var",
		"current_stalled": "state_"+str(i)+"___ucld_153___ucld_111___ucld_79_current_stalled_var_var_var",
		"current_delays": "state_"+str(i)+"___ucld_123___ucld_99___ucld_75_current_delays_var_var_var",
		"previous_progress": "state_"+str(i)+"___ucld_130___ucld_119___ucld_78_previous_progress_var_var_var"})
		
		decls += '\n(declare-fun '+states_terms[i-1]['previous_stages']+' () '+type_stages+')\n(declare-fun '+states_terms[i-1]['current_stages']+' () '+type_stages+')\n(declare-fun '+states_terms[i-1]['previous_delays']+' () '+type_delay+')'


def inorder_init():
	global decls, state0_terms, depth_bound, states_terms, mode
	mode = 'in'
	decls = '''(declare-datatypes ((_enum_0 0)) (((nop) (load_op) (store_op) (branch_op) (other_op))))
(declare-datatypes ((_enum_1 0)) (((pre) (IF) (ID) (EX) (MEM) (ST) (WB) (post))))
(declare-datatypes ((_tuple_0 0)) (((_tuple_0 (fetch Int) (id Int) (ex Int) (mem Int) (wb Int)))))
(declare-fun initial_43___ucld_80_latencies_i_var () _tuple_0)
(declare-fun initial_24___ucld_78_op_i_var () _enum_0)
(declare-fun initial_37___ucld_59___ucld_54___ucld_33_previous_latency_var_var_var
             ()
             Int)
(declare-fun initial_35___ucld_82_stage_i_var () _enum_1)
(declare-fun initial_48___ucld_81_latencies_j_var () _tuple_0)
(declare-fun initial_20___ucld_79_op_j_var () _enum_0)
(declare-fun initial_63___ucld_61___ucld_57___ucld_32_previous_stage_var_var_var
             ()
             _enum_1)'''
	
	state0_terms = {"latencies_i": "initial_43___ucld_80_latencies_i_var",
"stage_i": "initial_35___ucld_82_stage_i_var",
"op_j": "initial_20___ucld_79_op_j_var",
"latencies_j": "initial_48___ucld_81_latencies_j_var",
"op_i": "initial_24___ucld_78_op_i_var"}
	
	depth_bound = 33
	states_terms = list()
	for i in range(1, depth_bound+1):
		states_terms.append({"previous_stage": "state_"+str(i)+"___ucld_61___ucld_57___ucld_32_previous_stage_var_var_var",
		"current_lat": "state_"+str(i)+"___ucld_65___ucld_53___ucld_37_current_latency_var_var_var",
		"previous_lat": "state_"+str(i)+"___ucld_59___ucld_54___ucld_33_previous_latency_var_var_var",
		"previous_delay": "state_"+str(i)+"___ucld_64___ucld_46___ucld_34_previous_delay_var_var_var",
		"current_stage": "state_"+str(i)+"___ucld_68___ucld_47___ucld_36_current_stage_var_var_var",
		"current_progress": "state_"+str(i)+"___ucld_67___ucld_52___ucld_39_current_progress_var_var_var",
		"current_delay": "state_"+str(i)+"___ucld_71___ucld_45___ucld_38_current_delay_var_var_var",
		"previous_progress": "state_"+str(i)+"___ucld_63___ucld_56___ucld_35_previous_progress_var_var_var"})



def eval_model(m, term):
	''' Get a satisfying interpretation for term from the model m without Z3 Python objects '''
	for e in m.decls():
		if e.name() == term:
			#print(m.get_interp(e).sort())
			return m.get_interp(e)
	exit('Failed to find expr: '+term+' in model.')
	
def delay_info(m):
	''' Returns the part of the model corresponding to the state at the depth where the delay first occurs '''
	for i in range(depth_bound):
		if (mode == 'tricore' and re.search(r'\(.*1.*\)', str(eval_model(m, states_terms[i]['previous_delays']))) != None) or (mode == 'in' and str(eval_model(m, states_terms[i]['previous_delay'])).find('1') != -1):
			return (i+1, [str(eval_model(m, term)) for term in states_terms[i].values()])
	exit('Failed to find a depth with not-null delays.')
	
def format_value(v):
	''' Convert Python's value format into SMT-lib's '''
	return re.sub(r'_tuple_(\d+)\(', r'(_tuple_\1 ', str(v).replace('True', 'true').replace('False', 'false').replace(',', ''))
	
def block_term(s, m, t):
	''' Add a not=term constraint to the solver '''
	constraints = parse_smt2_string(decls+"\n(assert (not (= "+t+" "+format_value(eval_model(m, t))+")))")
	s.add(constraints)
	#s.add(t != eval_model(m, t))
	
def block_terms(s, m, t):
	''' Add not /\= constraint to the solver '''
	constr_str = decls+"\n(assert (not"
	for term in range(len(t)-1):
		constr_str += " (and (= "+t[term][1]+" "+format_value(eval_model(m, t[term][1]))+")"
	constr_str += " (= "+t[len(t)-1][1]+" "+format_value(eval_model(m, t[len(t)-1][1]))+")"
	for i in range(len(t)):
		constr_str += ')'
	constr_str += ')'
	constraints = parse_smt2_string(constr_str)
	s.add(constraints)
	
def fix_term(s, m, t):
	''' Add a =term constraint to the solver '''
	constraints = parse_smt2_string(decls+"\n(assert (= "+t+" "+format_value(eval_model(m, t))+"))")
	s.add(constraints)
	#s.add(t == eval_model(m, t))


def all_smt(s, terms, w, block_final):
	global iteration, n_sol
	while sat == s.check():
		m = s.model()
		print("** iteration "+str(iteration))
		iteration += 1
		if 'time' in s.statistics().keys():
			time_check = str(s.statistics().get_key_value('time'))
			print("\t\ttime: "+time_check)
		else:
			time_check = ''
		init_values = []
		for e in state0_terms.items():
			v = str(eval_model(m, e[1])).replace('\n', '').replace('     ', '')
			init_values.append(v)
			print("\t\t"+e[0]+"="+v)
		info = delay_info(m)
		w.writerow((init_values+[time_check]+[info[0]]+info[1]))
		
		if not block_final:
			block_terms(s, m, terms)
		else:
			bound = info[0]-1
			constr_str = decls+'\n(assert'# (or (not (and (= '+state0_terms['ops_i']+' '+format_value(eval_model(m, state0_terms['ops_i']))+') (= '+state0_terms['ops_j']+' '+format_value(eval_model(m, state0_terms['ops_j']))+')))'
			
			for i in range(depth_bound):
				if i < depth_bound-1:
					constr_str += '\n(and '
				constr_str += '(or (= '+states_terms[i]['previous_delays']+' ('+type_delay+' 0 0)) (not (and (= '+states_terms[i]['current_stages']+' '+format_value(eval_model(m, states_terms[bound]['current_stages']))+') (= '+states_terms[i]['previous_stages']+' '+format_value(eval_model(m, states_terms[bound]['previous_stages']))+'))))'
				#constr_str += '(or (= '+states_terms[i]['previous_delays']+' (_tuple_1 0 0)) (not (and (= '+states_terms[i]['current_stages']+' '+format_value(eval_model(m, states_terms[bound]['current_stages']))+') (and (= '+states_terms[i]['previous_stages']+' '+format_value(eval_model(m, states_terms[bound]['previous_stages']))+') (and (= '+state0_terms['ops_j']+' '+format_value(eval_model(m, state0_terms['ops_j']))+') (= '+state0_terms['ops_i']+' '+format_value(eval_model(m, state0_terms['ops_i']))+'))))))'
				#constr_str += '(not (and (= '+states_terms[i]['current_stages']+' '+format_value(eval_model(m, states_terms[bound]['current_stages']))+') (= '+states_terms[i]['previous_stages']+' '+format_value(eval_model(m, states_terms[bound]['previous_stages']))+')))'
			for i in range(depth_bound):
				constr_str += ')'
			
			constraints = parse_smt2_string(constr_str)
			s.add(constraints)
	n_sol = iteration


def approx_smt(s, initial_terms, w):
	''' Start the solution enumeration '''
	def approx_smt_rec(terms, w):
		''' Split the state space into disjoint models and check for solutions '''
		global iteration, n_sol
		print("** iteration "+str(iteration))
		iteration += 1
		
		if sat == s.check():
			m = s.model()
			n_sol += 1
			if 'time' in s.statistics().keys():
				time_check = str(s.statistics().get_key_value('time'))
				print("\t\ttime: "+time_check)
			else:
				time_check = ''
			init_values = []
			for e in state0_terms.items():
				v = str(eval_model(m, e[1])).replace('\n', '').replace('     ', '')
				init_values.append(v)
				print("\t\t"+e[0]+"="+v)
			info = delay_info(m)
			w.writerow((init_values+[time_check]+[info[0]]+info[1]))
			yield m
			
			for i in range(len(terms)):
				block_str = terms[i][0]+" ≠ "+str(eval_model(m, terms[i][1])).replace('\n', '').replace('     ', '')
				fix_strs = []
				print("\n** Blocking new term: "+block_str)
				print("** Fixing new term(s):" if i > 0 else "** Fixing new terms: None")
				
				s.push()
				''' Accumulate (and then remove) assertions freezing the first constants and forcing the i-th to vary wrt to the previous set of assertions '''
				block_term(s, m, terms[i][1])
				for j in range(i):
					fix_strs.append(terms[j][0]+" = "+str(eval_model(m, terms[j][1])).replace('\n', '').replace('     ', ''))
					fix_term(s, m, terms[j][1])
				if (len(fix_strs)): print(fix_strs)
					
				for m in approx_smt_rec(terms[i+1:], w):
					yield m
				#s.push()	
				#for m in approx_smt_rec(terms, w):
				#	yield m
				#s.pop()
				
				s.pop()
				#print("(* Forgetting: "+block_str)
				#if (len(fix_strs)): print(fix_strs)
				#print("*)")		
		else:
			print("\t\tunsat")
	
	for m in approx_smt_rec(initial_terms, w):
		yield m


if len(sys.argv) < 3 or sys.argv[2] not in ('approx', 'all_actual', 'all'):
	exit("Wrong usage: $ python all_smt.py filename 'approx'|'all'|'all_actual'")
	#a = raw_input("\nDo you want to execute: $ python all_smt.py smt_prop_together/smtLogwaw_reduc_code_spec-property_no_timing_anomaly:safety-vbmc-0170.smt now? [y/n] ")
	#if a == 'y':
		#filename = "smt_prop_together/smtLogwaw_reduc_code_spec-property_no_timing_anomaly:safety-vbmc-0170.smt"
	#else:
		#exit()
else:
	if not os.path.isfile(sys.argv[1]):
		exit("No such file.")
	else:
		filename = sys.argv[1]
		method = sys.argv[2]
	
print("Solving file: "+filename+" with method: "+method)
s = Solver()
constraints = parse_smt2_file(filename, sorts={}, decls={})
s.add(constraints)
#s.from_file(filename)
#print(s.units().sexpr())

tricore_init()
#inorder_init()

iteration = 0
n_sol = 0
output = filename.replace('.smt', '-'+method+'.csv')

with open(output, "wb") as f:
	writer = csv.writer(f)
	writer.writerow(state0_terms.keys()+['time']+['depth']+states_terms[0].keys())
	start_time = time.time()
	
	if method == 'all_actual':
		all_smt(s, state0_terms.items(), writer, block_final=True)
	elif method == 'all':
		all_smt(s, state0_terms.items(), writer, block_final=False)
	elif method == 'approx':
		for m in approx_smt(s, state0_terms.items(), writer): continue
	
	time_str = "Total time (s): "+str(time.time()-start_time)
	sol_str = str(n_sol)+" solutions found."
	print(sol_str)
	print(time_str)
	print("Saved in: "+output)
	writer.writerow("")
	writer.writerow([str(iteration)+" calls to z3."])
	writer.writerow([sol_str])
	writer.writerow([time_str])

