// tinygo build -target wasm -o fib_go.wasm -wasm-abi generic fib.go
package main

func main() {
} // for tinygo

//go:export fib
func fib(n int) int {
	if (n < 2) {
	  return n
	}
	return fib(n - 1) + fib(n - 2)
}
