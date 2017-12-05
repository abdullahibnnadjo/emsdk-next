# emsdk-next
Super easy utility for installing a most up-to-date (and lightest) Emscripten dev environnement

Beyond the `sdk-incoming-64bit` version you can install with the classic [emsdk](https://github.com/juj/emsdk), those simple scripts let you benefit of the latest advances from the [Emscripten project](https://kripken.github.io/emscripten-site/) (incoming branch), like :
- LLVM 4
- [Up-to-date](http://webassembly.org/roadmap/) working [WebAssembly](http://webassembly.org) backend for LLVM ([See details here](https://github.com/WebAssembly/binaryen#cc-source--webassembly-llvm-backend--s2wasm--webassembly) and [here](https://github.com/kripken/emscripten/wiki/New-WebAssembly-Backend)), avoiding [this issue](https://github.com/WebAssembly/binaryen/issues/825)

Also, installing the Emscripten incoming SDK, the classic way, takes time and a lot of space on disk because of cloning full LLVM, Clang and Emscripten repos.
Those tools try to avoid that by fetching only the latest commits, and not downloading [Node.js](https://nodejs.org/en/) again, which you may already have.

Be sure to have the [platform-specific requirements](https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html#platform-specific-notes), and run `./bootstrap.sh`

Use `./update.sh` to pull latest changes from the Emscripten/LLVM/Clang repos and build if necessary

A full installation takes typically about 45mins with 10Mb/s bandwith and a 4 threads 1.3GHz CPU, and 1.4GB on disk after building.

Tested on macOS Sierra and Fedora 27, and it may works in Windows with a *nix like environnement ([MinGW/MSYS](http://www.mingw.org/) ([2](http://www.msys2.org/)) or [Cygwin](https://www.cygwin.com/))
