#!/bin/bash

case $1 in
	"no-stalling")
		echo "no-stalling-onmiss"
        sed -n 2,3p test/tricore/param-notiming-anomaly-nostalling.ucl
		time uclid src/tricore/common.ucl src/tricore/tricore-nostalling-onmiss.ucl test/tricore/test.ucl test/tricore/param-notiming-anomaly-nostalling.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly.ucl -no-version-check
		;;
		
	"stalling-before")
		echo "stalling-before-onmiss"
        sed -n 2,3p test/tricore/param-notiming-anomaly-stalling-before.ucl
		time uclid src/tricore/common.ucl src/tricore/tricore-stalling-before-onmiss.ucl test/tricore/test.ucl test/tricore/param-notiming-anomaly-stalling-before.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly-stalling-before.ucl -no-version-check
		;;
		
 	"stalling-whole")
		echo "stalling-whole-onmiss"
        sed -n 2,3p test/tricore/param-notiming-anomaly-stalling-whole.ucl
		time uclid src/tricore/common.ucl src/tricore/tricore-stalling-whole-onmiss.ucl test/tricore/test.ucl test/tricore/param-notiming-anomaly-stalling-whole.ucl test/tricore/conditions-notiming-anomaly.ucl test/tricore/property-notiming-anomaly-stalling-whole.ucl -no-version-check
		;;

	*)
		echo "Wrong usage. On-miss stalling policy argument must be: 'no-stalling', 'stalling-before' or 'stalling-whole'."
		;;
esac
