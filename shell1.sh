#!/bin/bash

echo Hello World

## Multi Line Output

echo Hai
echo Bye

# Single echo command but multi line output
# Syntax: echo -e "Line1\nLine2"

echo -e "Hai1\nBye1"

# \n is used to print a new line

# Some times we need colors to be printed with the text.

## Following are the colors that are supported

#   Color               Code
# -------------------------------------
#   Red                   31
#   Green                 32
#   Yellow                33
#   Blue                  34
#   Magenta               35
#   Cyan                  36

# Syntax: echo -e "\e[COLmMESSAGE"

echo -e "\e[32mWelcome to DevOps Training\e[0m"
echo "Good Evening"

# Disable Color Code    - 0

