#!/bin/bash

## Declare the function
function sample1() {
  echo a - $a
  echo Hello from Function1
  b=20
}

sample2() {
  echo Hello from Funtion2

  echo First Argument in Function = $1
  return 100
  c=45
}

## Access the function

c=40
a=10
sample1 22
sample2 200
echo Exit Status = $?
echo b - $b
echo c - $c


echo First Argument = $1
sample2 65 98

