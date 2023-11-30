# Roc WASM Platform

roc wasi platform can be used by [roc](https://www.roc-lang.org/) to build wasi
modules.

```bash
cd examples/helloworld
roc build --target wasm32
wasmtime helloworld.wasm
```
