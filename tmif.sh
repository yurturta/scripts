#!/usr/bin/env bash
# File: tmif.sh

var=$(date)
#echo $var

if [[ $var =~ ^Fri ]]
then echo "Thank Moses it's Friday"
elif [[ $var =~ ^Wed ]]
then echo "Thank Moses it's Wednesday"
fi

