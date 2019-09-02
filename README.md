
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
  Recall(n - 1) + Recall(n - 2)
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
probably emit very similiar `wasm` code. Also each function call reads
the `wasm` file from disk and instantiates it.

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
#> 1 fib_c(20)                69.5µs   73.1µs   10876.     2.49KB     2.03
#> 2 fib_rust(20)             69.2µs   70.6µs   12072.     2.49KB     2.01
#> 3 fib_assemblyscript(20)   69.2µs   70.5µs   12993.     2.49KB     2.02
#> 4 fib_go(20)               69.6µs   71.1µs   12831.     2.49KB     2.01
#> 5 fib_r(20)                13.5ms   14.5ms      62.9        0B    25.7 
#> 6 fib_rcpp(20)             42.1µs   42.7µs   22034.     8.72KB     0
```
