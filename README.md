
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Use C, Rust and Assemblyscript in an R pacakge

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

Each of the following functions calls a bundled binary `wasm` file
`inst` directory that was compiled from the respective language. The
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
fib_r(20)
#> [1] 6765
```

To be fair, the assemblyscript wasm is 6kb.

``` r
bench::mark(
  fib_c(20),
  fib_rust(20),
  fib_assemblyscript(20),
  fib_r(20)
)
#> # A tibble: 4 x 6
#>   expression                  min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>             <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 fib_c(20)                1.34ms    2.1ms     284.     11.9KB     2.15
#> 2 fib_rust(20)             1.31ms   1.67ms     439.     11.8KB     2.04
#> 3 fib_assemblyscript(20)   13.1ms  16.42ms      53.9    16.5KB     2.07
#> 4 fib_r(20)               14.14ms  17.31ms      54.7        0B    23.0
```
