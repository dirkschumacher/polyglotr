
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Use C, Rust and Assemblyscript in an R pacakge

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `polyglotr` is just to show how you can use three different
languages through WebAssembly in an R package using
[wasmr](https://github.com/dirkschumacher/wasmr).

## Example

``` r
library(polyglotr)
```

To be fair, the assemblyscript wasm is 6kb.

``` r
bench::mark(
  fib_c(20),
  fib_rust(20),
  fib_assemblyscript(20)
)
#> # A tibble: 3 x 6
#>   expression                  min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>             <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 fib_c(20)                1.25ms   1.45ms     533.   850.03KB     2.04
#> 2 fib_rust(20)             1.18ms   1.45ms     512.    18.11KB     2.04
#> 3 fib_assemblyscript(20)   11.9ms  15.13ms      56.2    4.33MB     2.08
```
