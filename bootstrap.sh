#!/bin/sh

specify () {
    echo 'Usage: ./bootstrap.sh num_of_threads'
    echo 'Please specify the number of threads which will be used for compiling llvm and clang.'
    exit
}

threads=1

if [ "$1" != "" ]
then
    if [[ "$1" =~ ^([1-9][0-9]*|[0]+[1-9][0-9]*)$ ]]
    then
        threads="$1"
    else
        specify
    fi
else
    specify
fi

echo 'Start by cloning latest commit from "next-merge" branches'

clone_next="git clone -b next-merge --depth 1"

set -x

$clone_next https://github.com/kripken/emscripten
$clone_next https://github.com/kripken/emscripten-fastcomp clang/fastcomp/src
$clone_next https://github.com/kripken/emscripten-fastcomp-clang clang/fastcomp/src/tools/clang

set +x
build_next="clang/fastcomp/build_next"

mkdir $build_next && cd $build_next

set -v
cmake ../src -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_EXAMPLES=OFF -DCLANG_INCLUDE_TESTS=OFF -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly
set +v

echo "Go drink some coffee...."

if [ "$threads" -gt 1 ]
then
    echo "Using $threads threads to make this a little bit faster"
fi
set -v

make -j"$threads"
