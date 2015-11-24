#!/bin/bash

# Load the assertions library
. ./lib/assert.sh

SOURCEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
PACKAGENAME=$(basename ${SOURCEDIR} | sed 's/check_mk-\(.\{1,10\}\).*/\1/')
TESTID=$(printf "%05d" $( shuf -i 00000-99999 -n1 ))
SITENAME="${PACKAGENAME}_${TESTID}"
OMDLOG=$(mktemp /tmp/cmk_test_omd.log.XXXXXXXX)

function set_up {
   omd sites | grep ${SITENAME} > /dev/null
   RC=${?}
   if [ ${RC} -gt 0 ]; then
       omd create ${SITENAME}
   fi
   omd start ${SITENAME} || (echo "Impossibile avviare sito di test: ${SITENAME}"; exit 255;)
}

function tear_down {
   /usr/bin/expect <<EOD
       spawn /usr/bin/omd rm --kill ${SITENAME}
       expect "NO): "
       send -- "yes\n"
       expect eof
EOD
}


set_up >> ${OMDLOG} 2>&1

echo "All Set UP.. starting tests"

assert "echo testing" "testing"
assert_end "basic"

tear_down >> ${OMDLOG} 2>&1

rm ${OMDLOG}
