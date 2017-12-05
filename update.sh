#!/bin/bash
set -e

specify () {
    echo 'Usage: ./update.sh num_of_threads'
    echo 'Please specify the number of threads which will be used for compiling llvm and clang.'
    exit
}

give_info () {
    GREEN='\x1B[0;32m'
    NC='\x1B[0m'
    printf "${GREEN}$1${NC}\n"
}

newline () {
    n=$1
    while ! [ $n -eq 0 ]
    do
        echo
        n=$((n - 1))
    done
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

give_info "Updating repos"

set -x
cd emscripten/next/ && git pull && cd ../..
cd clang/fastcomp/src && git pull && cd tools/clang && git pull &&  cd ../../../../..
{ set +x; } 2>/dev/null

newline 1
give_info "Build changes if necessary"

set -x
cd clang/fastcomp/build_next/ && cmake ../src -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_EXAMPLES=OFF -DCLANG_INCLUDE_TESTS=OFF -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly && make -j"$threads"
cd ../../../emscripten/optimizer/ && cmake ../next/tools/optimizer && make -j"$threads"
{ set +x; } 2>/dev/null

newline 2
give_info "Update of emsdk-next ok !"
