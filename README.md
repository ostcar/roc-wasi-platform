# Roc WASM Platform

roc wasi platform can be used by [roc](https://www.roc-lang.org/) to build wasi
modules.

```bash
cd examples/helloworld
roc build --target wasm32
wasmtime helloworld.wasm
```

## File example

```sh
$ roc build --target=wasm32 examples/file.roc
🔨 Rebuilding platform...
0 errors and 0 warnings found in 227 ms while successfully building:

    examples/file.wasm

$ wasmtime --dir=examples/ examples/file.wasm
SUCCESS opened crash.roc

$ wasmtime --dir=. examples/file.wasm
ERROR unable to file
```