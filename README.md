# emsdk-next
Super easy utility for installing a most up-to-date (and lightest) Emscripten dev environnement

Beyond the `sdk-incoming-64bit` version you can install with the classic [emsdk](https://github.com/juj/emsdk), those simple scripts let you benefit of the latest advances from the [Emscripten project](https://kripken.github.io/emscripten-site/) (next-merge branch), like :
- LLVM 4.0 (rc1)
- Up-to-date working [WebAssembly](http://webassembly.org) backend for LLVM ([See details](https://github.com/WebAssembly/binaryen#cc-source--webassembly-llvm-backend--s2wasm--webassembly))

Also, installing the Emscripten incoming SDK, the classic way, takes time and a lot of space on disk because of cloning full LLVM, Clang and Emscripten repos.
Those tools try to avoid that by fetching only the latest commits.
