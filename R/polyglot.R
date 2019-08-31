#' Fibonacci number in C
#' @param n an integer >= 1
#' @export
fib_c <- function(n) {
  make_fib_fun("fib_c.wasm")(n)
}

#' Fibonacci number in Assemblyscript
#' @param n an integer >= 1
#' @export
fib_assemblyscript <- function(n) {
  make_fib_fun("fib_asc.wasm")(n)
}

#' Fibonacci number in Rust
#' @param n an integer >= 1
#' @export
fib_rust <- function(n) {
  make_fib_fun("fib_rust.wasm")(n)
}

#' Fibonacci number in go
#' @param n an integer >= 1
#' @export
fib_go <- function(n) {
  imports <- list(
    env = list(
      io_get_stdout = wasmr::typed_function(
        function() {
          0
        },
        param_types = character(),
        return_type = "I32"
      ),
      resource_write = wasmr::typed_function(
        function(a, b, c) {
          0
        },
        param_types = c("I32", "I32", "I32"),
        return_type = "I32"
      )
    )
  )
  make_fib_fun("fib_go.wasm", imports)(n)
}

make_fib_fun <- function(wasm_file_name, imports = list()) {
  wasm_path <- system.file("wasm", wasm_file_name, package = "polyglotr")
  instance <- wasmr::instantiate(wasm_path, imports)
  instance$exports$fib
}
