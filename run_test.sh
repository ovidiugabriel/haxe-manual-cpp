#!/bin/bash
set -x

if [ "$1" == "" ] ; then
    echo "Missing input file"
fi

PATH="$PATH:/c/msys64/mingw64/bin"

CC=x86_64-w64-mingw32-gcc.exe

if [ -f output/a.exe ] ; then
    rm output/a.exe
fi
output/Main.exe $1 > output/_test.c

# Compile the C file to an executable
$CC -x c output/_test.c -o output/a.exe
echo "$?"

ls -al output/a.exe
output/a.exe
echo "$?"
