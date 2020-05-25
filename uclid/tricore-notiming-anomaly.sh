#!/bin/zsh

a="time uclid src/tricore/common.ucl"

case $1 in
	"basic")
        sed -n 6p test/tricore/param-basic.ucl
        sed -n 9,11p test/tricore/param-basic.ucl
        a="$a src/tricore/tricore.ucl test/tricore/param-basic.ucl"
    ;;

    "reduc")
        sed -n 6p test/tricore/param-reduc.ucl
        sed -n 9,11p test/tricore/param-reduc.ucl
        a="$a src/tricore/tricore.ucl test/tricore/param-reduc.ucl"
    ;;
    
    "reduc-hazards")
        sed -n 6p test/tricore/param-reduc-hazards.ucl
        sed -n 9,11p test/tricore/param-reduc-hazards.ucl
        a="$a src/tricore/tricore.ucl test/tricore/param-reduc-hazards.ucl"
    ;;
    
    "reduc-hazards-SB")
        sed -n 6p test/tricore/param-reduc-hazards-SB.ucl
        sed -n 9,11p test/tricore/param-reduc-hazards-SB.ucl
        a="$a src/tricore/tricore-SB.ucl test/tricore/param-reduc-hazards-SB.ucl"
    ;;
    
    *)
        echo "Wrong usage."
        exit
    ;;
esac

a="$a test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly.ucl -no-version-check"
echo $a
eval $a
