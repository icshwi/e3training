#!/bin/bash



EXIST=1
NON_EXIST=0

function pushd { builtin pushd "$@" > /dev/null; }
function popd  { builtin popd  "$@" > /dev/null; }

## if [[ $(checkIfFile "${release_file}") -eq "$NON_EXIST" ]]; then
#   NON_EXIT
## fi

function checkIfFile
{
    local file=$1
    local result=""
    if [ ! -e "$file" ]; then
	result=$NON_EXIST
	# doesn't exist
    else
	result=$EXIST
	# exist
    fi
    echo "${result}"	 
};



declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_TOP="${SC_SCRIPT%/*}"

#  
#system "tr -cd 0-9 </dev/urandom | head -c 8 > $(TOP)/random_tmp"
#system "C=`cat $(TOP)/random_tmp` && /bin/sed -e "s:_random_:$C:g" < $(TOP)/random.in > $(TOP)/random.cmd"


# Keep ONE random number per a system
# after restarting IOC many times
# 
RANDOM_CMD=${SC_TOP}/random.cmd

if [[ $(checkIfFile "${RANDOM_CMD}") -eq "$NON_EXIST" ]]; then
    C=$(tr -cd 0-9 </dev/urandom | head -c 8)
    sed -e "s:_random_:$C:g" < ${SC_TOP}/random.in > ${RANDOM_CMD}
fi



