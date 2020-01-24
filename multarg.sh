#!/usr/bin/env bash
# File: multargs.sh

#echo "Script arguments: $@"
#echo "First arg: $1. Second arg: $2."
#echo "Number of arguments: $#"
r1=$1
r2=$#

expr $1 \* $#

