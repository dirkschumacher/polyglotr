// used webassembly.studio for compilation
__attribute__((visibility("default")))
int fib(int n) {
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2);
}
