#!/bin/bash

if [ "$1" == "" ] ; then
    echo "Missing input file"
fi

PATH="$PATH:/c/msys64/mingw64/bin"

CXX=x86_64-w64-mingw32-g++.exe

OUTPUT=output/cgen/a.exe
OUT_DIR=$(dirname $OUTPUT)
CPPFILE=$OUT_DIR/_test.cpp

set -x
if [ -f $OUTPUT ] ; then
    rm $OUTPUT
fi

if [ ! -d $OUTDIR ] ; then
    mkdir -p $OUTDIR
fi

if [ -e $CPPFILE ] ; then
    rm $CPPFILE
fi

# first validate the input

TEST_DIR=$(dirname $1)
pushd $TEST_DIR/..

filename=$(basename $1)
CLASSNAME="${filename%.*}"

haxe -main testpkg.$CLASSNAME

popd

hl output/Main.hl $1 $CPPFILE
if [ ! -e $CPPFILE ] ; then
    exit 1
fi
ls -al $CPPFILE

# Compile the C file to an executable
$CXX -I. $CPPFILE -o $OUTPUT -lstdc++
if [ "$?" != "0" ] ; then
    exit 1
fi

ls -al $OUTPUT
$OUTPUT
echo "$?"
