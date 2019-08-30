// used webassembly.studio to compile
#![feature(proc_macro, wasm_custom_section, wasm_import_module)]
extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn fib(n: i32) -> i32 {
  return if (n < 2) {
    n
  } else {
    fib(n - 1) + fib(n - 2)
  };
}
