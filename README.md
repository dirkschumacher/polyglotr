
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
#> 1 fib_c(20)                1.19ms   1.36ms     599.    12.21KB     4.15
#> 2 fib_rust(20)              1.2ms   1.35ms     604.    12.13KB     2.04
#> 3 fib_assemblyscript(20)   1.17ms    1.3ms     622.    11.38KB     4.20
#> 4 fib_go(20)               2.71ms   3.04ms     281.    15.71KB     2.08
#> 5 fib_r(20)               13.48ms  14.12ms      64.3        0B    33.8 
#> 6 fib_rcpp(20)            42.25µs  44.58µs   20531.     8.72KB     0
```
