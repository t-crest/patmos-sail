#!/bin/zsh

a="time uclid src/tricore/common.ucl"

case $1 in
	"basic" | "pipeline_reduc" | "general_reduc" | "hazards" | "hazards_noSB" | "hazards_noSB_reduc" | "hazards_all_reduc")
        sed -n 8p test/tricore/param-$1.ucl
        sed -n 11,15p test/tricore/param-$1.ucl
        a="$a src/tricore/tricore-SB.ucl test/tricore/param-$1.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly.ucl -no-version-check"
        echo $a
        eval $a
    ;;
    
    *)
        echo "Wrong usage."
        exit
    ;;
esac
