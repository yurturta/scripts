#!/usr/bin/env bash
# File: myfunc.sh

function plier {
	local pl=1
	for element in $@
	do
		let pl=pl*element
	done
	echo $pl
}

function isiteven {
local var=$(expr $1 % 2)
if [[ $var -eq 0 ]]
then echo 1
else echo 0
fi
}

#function nevens {
#
#local record=0
#for element in $@
#do
#	if [[ $(expr $element % 2) -eq 0 ]]
#	then let record=record+1
#	fi
#done
#echo $record
#}

function nevens {

local record=0
for element in $@
do
	if [[ $(isiteven $element) -eq 1 ]]
	then let record=record+1
	fi
done
echo $record
}

function howodd {

local record=0
local number=0
for element in $@
do
	let number=number+1
	if [[ $(isiteven $element) -eq 0 ]]
	then let record=record+1
	fi
done
echo $(expr $record \* 100 / $number)
}

function fibo {

local n=$1
local result=(0)
if (( n <= 1 ))
	then let result=(0)
elif (( n == 2 ))
	then result+=1
else
	result+=$(fibo $((n - 1)))
fi

echo ${result[*]}
}

#! /bin/bash
memo=(0 1)
fib() {
        >&2 printf %s "fib($1) memo=(${memo[*]}) => "
        local n="$1"
        if [ "${memo[n]+x}" ]; then
                >&2 echo lookup
                return
        fi
        >&2 echo compute
        fib "$((n-1))"
        fib "$((n-2))"
        ((memo[n]=memo[n-1]+memo[n-2]))
}
fib "$1"
echo "${memo[$1]}"

