#!/bin/sh
set -e

specify () {
    echo 'Usage: ./bootstrap.sh num_of_threads'
    echo 'Please specify the number of threads which will be used for compiling llvm and clang.'
    exit
}

newline () {
    n=$1
    while ! [ $n -eq 0 ]
    do
        echo
        n=$((n - 1))
    done
}

give_info () {
    GREEN='\x1B[0;32m'
    NC='\x1B[0m'
    printf "${GREEN}$1${NC}\n"
}

if [ -f "$HOME/.emscripten" ]
then
    echo 'It seems that you already have an emscripten config file'
    echo 'Please backup and/or delete your ~/.emscripten file first'
    exit
fi

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

give_info 'Start by cloning latest commit from "next-merge" branches'

newline 1

clone_next="git clone -b next-merge --depth 2"

set -x
$clone_next https://github.com/kripken/emscripten emscripten/next
$clone_next https://github.com/kripken/emscripten-fastcomp clang/fastcomp/src
$clone_next https://github.com/kripken/emscripten-fastcomp-clang clang/fastcomp/src/tools/clang
{ set +x; } 2>/dev/null

build_next="clang/fastcomp/build_next"
mkdir -p $build_next && cd $build_next

newline 2
give_info "Ok, let's configure the building of LLVM and Clang"
newline 1

set -v
cmake ../src -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;JSBackend" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DCLANG_INCLUDE_EXAMPLES=OFF -DCLANG_INCLUDE_TESTS=OFF -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly
set +v

newline 2
give_info "Go drink some coffee or do something else, I'm building all of this...."

if [ "$threads" -gt 1 ]
then
    give_info "Using $threads threads to make this a little bit faster"
fi

newline 1

set -x
make -j"$threads"
{ set +x; } 2>/dev/null

opt='../../../emscripten/optimizer'
mkdir -p "$opt" && cd "$opt"

newline 4
give_info "You're back ? I'm building Emscripten optimizer. Don't worry, this time it won't be long."
newline 1

set -x
cmake ../next/tools/optimizer -DCMAKE_BUILD_TYPE=Release
make -j"$threads"
{ set +x; } 2>/dev/null

cd ../..

newline 2
give_info "Done. Yep. No problem !"
newline 1
give_info "Try running emcc for the first time"
emscripten/next/emcc --help
give_info "Now, you juste have to change the path of LLVM_ROOT and add EMSCRIPTEN_NATIVE_OPTIMIZER variables in ~/.emscripten with the following values :"
newline 1
give_info "LLVM_ROOT='$(pwd)/clang/fastcomp/build_next/bin'"
give_info "EMSCRIPTEN_NATIVE_OPTIMIZER='$(pwd)/emscripten/optimizer'"
newline 1
give_info "You can also add Emscripten tools in your path"
give_info 'PATH=$PATH:'"$(pwd)"'/emscripten/next'
newline 1
give_info 'And optionally LLVM binaries and tools'
give_info 'PATH=$PATH:'"$(pwd)"'/clang/fastcomp/build_next/bin'
newline 2
give_info "The first time you'll run emcc, it will take some time (~30s/1min) before compiling your file(s), building libc and other libraries, to link it with your current and incoming binaries."
newline 1
give_info "Now, enjoy !"
newline 1
echo "Some infos about your new shiny LLVM :"
clang/fastcomp/build_next/bin/llc --version
