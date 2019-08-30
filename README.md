
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
#> 1 fib_c(20)                1.33ms   1.56ms     476.     11.9KB     2.05
#> 2 fib_rust(20)             1.28ms   1.59ms     402.     11.8KB     2.01
#> 3 fib_assemblyscript(20)   22.4ms  32.35ms      29.4    16.5KB     0
```
