#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
RISCVDIR="$DIR/.."

RED='\033[0;91m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
NC='\033[0m'

rm -f $DIR/tests.xml

pass=0
fail=0
XML=""

function green {
    (( pass += 1 ))
    printf "$1: ${GREEN}$2${NC}\n"
    XML+="    <testcase name=\"$1\"/>\n"
}

function yellow {
    (( fail += 1 ))
    printf "$1: ${YELLOW}$2${NC}\n"
    XML+="    <testcase name=\"$1\">\n      <error message=\"$2\">$2</error>\n    </testcase>\n"
}

function red {
    (( fail += 1 ))
    printf "$1: ${RED}$2${NC}\n"
    XML+="    <testcase name=\"$1\">\n      <error message=\"$2\">$2</error>\n    </testcase>\n"
}

function finish_suite {
    printf "$1: Passed ${pass} out of $(( pass + fail ))\n\n"
    XML="  <testsuite name=\"$1\" tests=\"$(( pass + fail ))\" failures=\"${fail}\" timestamp=\"$(date)\">\n$XML  </testsuite>\n"
    printf "$XML" >> $DIR/tests.xml
    XML=""
    pass=0
    fail=0
}

SAILLIBDIR="$DIR/../../lib/"

printf "<testsuites>\n" >> $DIR/tests.xml

cd $RISCVDIR

printf "Building RISCV specification...\n"

if make ocaml_emulator/riscv_ocaml_sim ;
then
    green "Building RISCV specification" "ok"
else
    red "Building RISCV specification" "fail"
fi

for test in $DIR/riscv-tests/*.elf; do
    if $RISCVDIR/ocaml_emulator/riscv_ocaml_sim "$test" >"${test/.elf/.out}" 2>&1 && grep -q SUCCESS "${test/.elf/.out}"
    then
       green "$(basename $test)" "ok"
    else
       red "$(basename $test)" "fail"
    fi
done

finish_suite "RISCV OCaml tests"

if make c_emulator/riscv_sim;
then
    green "Building RISCV specification to C" "ok"
else
    red "Building RISCV specification to C" "fail"
fi

for test in $DIR/riscv-tests/*.elf; do
    if timeout 5 $RISCVDIR/c_emulator/riscv_sim -p $test > ${test%.elf}.cout 2>&1 && grep -q SUCCESS ${test%.elf}.cout
    then
	green "$(basename $test)" "ok"
    else
	red "$(basename $test)" "fail"
    fi
done

finish_suite "RISCV C tests"

printf "</testsuites>\n" >> $DIR/tests.xml

