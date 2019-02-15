#
# Expected Result: r1 = 5 & r2 = 10
#

        .globl _start;
# To set the ELF entry point	
_start:                                                                 
        add    $r1  = $r0 , 5;
        add    $r2  = $r1 , 5;
        add    $r3  = $r2 , 5;
	add    $r4  = $r3 , 5;	
	

