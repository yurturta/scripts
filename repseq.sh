#!/usr/bin/env bash
# File: repseq.sh

sequence=$(eval echo {$1..$2})

for i in $sequence
do
  compute=$(echo "$i % $3" | bc)
  echo "$compute compute"
  result="$result $compute"
  echo "$result result" 
done

echo $result

