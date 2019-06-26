#!/usr/bin/env bash
if [[ $# -ne 2 ]]; then
    echo "Usage: build PM1a_CNT_BLK IOPL\n\tPM1a_CNT_BLK\tIO address of the PM1a register\n\tIOPL\t IOPL to set"
fi;

nasm po.asm -DPM1a_CNT_BLK=$1 -DIOPL=$2 -felf64 -o po.o
ld po.o -o po

#./po should not return if all went ok, if it returns (and the if below evaluates) then it can return 0 if
#setting the IOPL was successful and the power off didn't fault, 139 if a #GP fault was raised or 10 or 15 
#if setting the IOPL failed (and no power off was attempted)
./po
res=$?

if [[ $res -eq 0 ]]; then
  echo "Power off failed on this system";
elif [[ $res -eq 139 ]]; then
  echo "Operation crashed, insufficient privileges";
elif [[ $res -eq 15 ]]; then
  echo "Cannot set IOPL as non root"
else
  echo "IOPL not valid"
fi;

