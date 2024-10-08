#!/bin/bash
set -x

export HXCPP_MINGW=1
export MINGW_ROOT=/c/msys64/mingw64

haxe build.hxml
