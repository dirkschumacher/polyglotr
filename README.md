
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Use C, Rust, Go and Assemblyscript in an R package through WebAssembly

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `polyglotr` is just to show how you can use three different
languages through WebAssembly in an R package using
[wasmr](https://github.com/dirkschumacher/wasmr). All of this is very
experimental.

## Example

``` r
library(polyglotr)
```

The package exposes an inefficient, recursive fibonacci algorithm
written in languages that can compile to WebAssembly.

``` r
fib_r <- function(n) {
  if (n < 2) return(n)
  fib_r(n - 1) + fib_r(n - 2)
}
```

As a comparison we also add an `rcpp` version. In particular it shows
what the overhead of opening the `wasm` file and calling it currently
is.

``` r
Rcpp::cppFunction("
int fib_rcpp(int n) {
  if (n < 2) return n;
  return fib_rcpp(n - 1) + fib_rcpp(n - 2);
}
")
```

Each of the following functions calls a bundled binary `wasm` file in
the `inst` directory that was compiled from the respective language. The
binary file is distributed with the package, but not necessarily the
source files. The user does not need to compile anything (apart from the
`wasmr` package).

``` r
fib_c(20)
#> [1] 6765
fib_rust(20)
#> [1] 6765
fib_assemblyscript(20)
#> [1] 6765
fib_go(20)
#> [1] 6765
fib_r(20)
#> [1] 6765
fib_rcpp(20)
#> [1] 6765
```

The benchmark is not meant to compare different compilers, just to give
a rough feeling about timing. In fact most of the compilers will
probably emit very similiar `wasm` code. The `wasm` module is read and
instantiated upon package load.

I also used `tinygo` to compile the go code which adds some interface
code resulting in a 4kb file. There might be flags to further optimize
the generated code.

``` r
bench::mark(
  fib_c(20),
  fib_rust(20),
  fib_assemblyscript(20),
  fib_go(20),
  fib_r(20),
  fib_rcpp(20)
)
#> # A tibble: 6 x 6
#>   expression                  min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>             <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 fib_c(20)               69.58µs  73.33µs     9768.    2.49KB     2.01
#> 2 fib_rust(20)            68.99µs  70.73µs    12450.    2.49KB     4.10
#> 3 fib_assemblyscript(20)  69.09µs  70.82µs    11648.    2.49KB     2.02
#> 4 fib_go(20)               69.5µs  70.89µs    12155.    2.49KB     2.02
#> 5 fib_r(20)                8.06ms   8.82ms      106.        0B    24.4 
#> 6 fib_rcpp(20)            42.08µs  43.19µs    21261.    8.72KB     0
```
