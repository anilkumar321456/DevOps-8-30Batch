#!/bin/bash


for fruit in banana orange apple ; do
  echo Fruit Name = $fruit
  sleep 1
done

echo "enter the value you want to print"
read s
while [ $s -gt 0 ]; do
  echo value I = $s
  s=$(($s-1))
done
