#!/bin/bash
set -x

if [ "$1" == "" ] ; then
    echo "Missing input file"
fi

PATH="$PATH:/c/msys64/mingw64/bin"

CXX=x86_64-w64-mingw32-g++.exe

if [ -f output/a.exe ] ; then
    rm output/a.exe
fi

if [ ! -d output/cgen ] ; then
    mkdir output/cgen
fi

if [ -f output/cgen/_test.cpp ] ; then
    rm output/cgen/_test.cpp
fi

output/Main.exe $1 > output/cgen/_test.cpp

# Compile the C file to an executable
$CXX -I. output/cgen/_test.cpp -o output/cgen/a.exe -lstdc++
if [ "$?" != "0" ] ; then
    exit 1
fi

ls -al output/cgen/a.exe
output/cgen/a.exe
echo "$?"
