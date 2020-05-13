#!/bin/zsh

case $1 in
	"no-stalling")
		echo "no-stalling-onmiss"
		a="time uclid src/tricore/common.ucl"
        case $2 in
            "basic")
                sed -n 7,12p test/tricore/param-notiming-anomaly-nostalling-1.ucl
                a="$a test/tricore/param-notiming-anomaly-nostalling-1.ucl src/tricore/tricore-nostalling-onmiss.ucl"
                ;;
            
            "reduction")
                sed -n 7,12p test/tricore/param-notiming-anomaly-nostalling-2.ucl
                a="$a test/tricore/param-notiming-anomaly-nostalling-2.ucl src/tricore/tricore-nostalling-onmiss-reduction.ucl"
                ;;
                
            "more-reduction")
                sed -n 7,12p test/tricore/param-notiming-anomaly-nostalling-3.ucl
                a="$a test/tricore/param-notiming-anomaly-nostalling-3.ucl src/tricore/tricore-nostalling-onmiss-reduction.ucl"
                ;;
                
            "hazard")
                sed -n 7,12p test/tricore/param-notiming-anomaly-nostalling-4.ucl
                a="$a test/tricore/param-notiming-anomaly-nostalling-4.ucl src/tricore/tricore-nostalling-onmiss.ucl"
                ;;
            
            "hazard-reduction")
                sed -n 7,12p test/tricore/param-notiming-anomaly-nostalling-5.ucl
                a="$a test/tricore/param-notiming-anomaly-nostalling-5.ucl src/tricore/tricore-nostalling-onmiss-reduction.ucl"
                ;;
                
            "SB")
                sed -n 7,12p test/tricore/param-notiming-anomaly-nostalling-6.ucl
                a="$a test/tricore/param-notiming-anomaly-nostalling-6.ucl src/tricore/tricore-nostalling-onmiss-reduction-SB.ucl"
                ;;
            
            *)
                echo "Wrong usage: verification context argument."
                ;;
        esac
        a="$a test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly.ucl -no-version-check"
        echo $a
        eval $a
		;;
		
	"stalling-before")
		echo "stalling-before-onmiss"
        sed -n 7,12p test/tricore/param-notiming-anomaly-stalling-before.ucl
		time uclid test/tricore/param-notiming-anomaly-stalling-before.ucl src/tricore/common.ucl src/tricore/tricore-stalling-before-onmiss.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly-stalling-before.ucl -no-version-check
		;;
		
 	"stalling-whole")
		echo "stalling-whole-onmiss"
        sed -n 7,12p test/tricore/param-notiming-anomaly-stalling-whole.ucl
		time uclid test/tricore/param-notiming-anomaly-stalling-whole.ucl src/tricore/common.ucl src/tricore/tricore-stalling-whole-onmiss.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly-stalling-whole.ucl -no-version-check
		;;

	*)
		echo "Wrong usage. On-miss stalling policy argument must be: 'no-stalling', 'stalling-before' or 'stalling-whole'."
		;;
esac
