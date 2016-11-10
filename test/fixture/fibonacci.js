
module.exports = function fibonacci(n) {
  // Initialize array!
  const fib = [];

  fib[0] = 0;
  fib[1] = 1;
  for (let i = 2; i <= n; i++) {
    // Next fibonacci number = previous + one before previous
    // Translated to JavaScript:
    fib[i] = fib[i - 2] + fib[i - 1];
  }
  return fib[n];
};
