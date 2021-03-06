// asc fib.ts -b fib.wasm -O3 --runtime none
export function fib(n: i32): i32 {
  if (n < 2) {
    return n;
  }
  return fib(n - 1) + fib(n - 2);
}
