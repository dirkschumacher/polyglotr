#' Fibonacci number in C
#' @param n an integer >= 1
#' @export
fib_c <- function(n) {
  check_input(n)
  make_fib_fun("fib_c.wasm")(n)
}

#' Fibonacci number in Assemblyscript
#' @param n an integer >= 1
#' @export
fib_assemblyscript <- function(n) {
  wasm_path <- system.file("wasm", "fib_asc.wasm", package = "polyglotr")
  imports <- list(
    env = list(
      abort = wasmr::typed_function(
        function(a, b, c, d) {
          0
        },
        param_types = c("I32", "I32", "I32", "I32"),
        return_type = character()
      )
    )
  )
  instance <- wasmr::instantiate(wasm_path, imports)
  instance$exports$fib(n)
}

#' Fibonacci number in Rust
#' @param n an integer >= 1
#' @export
fib_rust <- function(n) {
  check_input(n)
  make_fib_fun("fib_rust.wasm")(n)
}

make_fib_fun <- function(wasm_file_name) {
  wasm_path <- system.file("wasm", wasm_file_name, package = "polyglotr")
  instance <- wasmr::instantiate(wasm_path)
  instance$exports$fib
}

check_input <- function(n) {
  stopifnot(
    length(n) == 1,
    is.numeric(n),
    n >= 1
  )
}
