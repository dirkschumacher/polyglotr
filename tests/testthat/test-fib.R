test_that("c works", {
  expect_equal(fib_c(20), 6765)
})

test_that("rust works", {
  expect_equal(fib_rust(20), 6765)
})

test_that("asc works", {
  expect_equal(fib_assemblyscript(20), 6765)
})

test_that("go works", {
  expect_equal(fib_go(20), 6765)
})

