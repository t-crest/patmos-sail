#!/bin/zsh

a="time uclid src/tricore/common.ucl"

case $1 in
    "pipeline_reduc" | "pipeline_general_reduc" | "reduc_memdep" | "dual_pipeline_memdep" | "waw" | "waw_reduc" | "waw_reduc_noSB" | "waw_noSB")
        sed -n 9p test/tricore/param-$1.ucl
        sed -n 12,17p test/tricore/param-$1.ucl
        a="$a src/tricore/tricore-SB.ucl test/tricore/param-$1.ucl test/tricore/test.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly.ucl -no-version-check"
        echo $a
        eval $a
    ;;
    
    *)
        echo "Wrong usage."
        exit
    ;;
esac
