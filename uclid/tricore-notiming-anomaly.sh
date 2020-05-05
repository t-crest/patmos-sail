#!/bin/zsh

case $1 in
	"no-stalling")
		echo "no-stalling-onmiss"
		a="time uclid test/tricore/param-notiming-anomaly-nostalling"
        case $2 in
            "noreduction-nohazard")
                sed -n 6,11p test/tricore/param-notiming-anomaly-nostalling-2.ucl
                echo "no space reduction and no hazards"
                a="$a-2"
                ;;
            
            "reduction-nohazard")
                sed -n 6,11p test/tricore/param-notiming-anomaly-nostalling-1.ucl
                echo "space reduction and no hazards"
                a="$a-1"
                ;;
            
            "reduction-hazard")
                sed -n 6,11p test/tricore/param-notiming-anomaly-nostalling-3.ucl
                echo "space reduction and hazards (less restrictions)"
                a="$a-3"
                ;;
            
            "reduction-limited-hazard")
                sed -n 6,11p test/tricore/param-notiming-anomaly-nostalling-4.ucl
                echo "space reduction and hazards (with restrictions)"
                a="$a-4"
                ;;
            
            *)
                echo "Wrong usage. Verification context argument must be: 'noreduction-nohazard', 'reduction-nohazard', 'reduction-hazard' or 'reduction-limited-hazard'."
                ;;
        esac
        a="$a.ucl src/tricore/common.ucl src/tricore/tricore-nostalling-onmiss.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly.ucl -no-version-check"
        eval $a
		;;
		
	"stalling-before")
		echo "stalling-before-onmiss"
        sed -n 6,11p test/tricore/param-notiming-anomaly-stalling-before.ucl
		time uclid test/tricore/param-notiming-anomaly-stalling-before.ucl src/tricore/common.ucl src/tricore/tricore-stalling-before-onmiss.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly-stalling-before.ucl -no-version-check
		;;
		
 	"stalling-whole")
		echo "stalling-whole-onmiss"
        sed -n 6,11p test/tricore/param-notiming-anomaly-stalling-whole.ucl
		time uclid test/tricore/param-notiming-anomaly-stalling-whole.ucl src/tricore/common.ucl src/tricore/tricore-stalling-whole-onmiss.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly-stalling-whole.ucl -no-version-check
		;;

	*)
		echo "Wrong usage. On-miss stalling policy argument must be: 'no-stalling', 'stalling-before' or 'stalling-whole'."
		;;
esac
