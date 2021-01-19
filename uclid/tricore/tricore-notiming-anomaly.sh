#!/bin/bash

a="time uclid"
if [ "$2" == "smtLog" ]; then
	a="$a -g smtLog$1"
fi
a="$a src/common.ucl"

case $1 in
    "pipeline_reduc" | "pipeline_general_reduc" | "reduc_memdep" | "dual_pipeline_memdep" | "waw" | "waw_reduc" | "waw_reduc_noSB" | "waw_noSB" | "waw_reduc_code_spec")
        sed -n 10p test/param-$1.ucl
        sed -n 13,18p test/param-$1.ucl
        a="$a src/tricore-SB.ucl test/param-$1.ucl test/test.ucl test/conditions-notiming-anomaly.ucl test/property-notiming-anomaly.ucl -no-version-check"
        echo $a
        eval $a
    ;;
    
    *)
        echo "Wrong usage."
        exit
    ;;
esac
