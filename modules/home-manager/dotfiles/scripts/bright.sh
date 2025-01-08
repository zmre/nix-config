#!/bin/sh

echo "Input brightness on 1-100 scale and this will change all monitors"
echo "eg, $0 50"
echo "for half brightness on all screens"
echo "If you don't specify, it goes full brightness"

if [[ -z "$1" ]]; then
  INT=100
else
  INT="$1"
fi

FRAC=$(echo "scale=1; $INT/100" |bc)


brightness "$FRAC" >& /dev/null
ddcctl -d 1 -b "$INT" >& /dev/null
