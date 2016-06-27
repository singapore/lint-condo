
module.exports = function fibonacci(n) {
  var fib = []; // Initialize array!

  fib[0] = 0;
  fib[1] = 1;
  for (var i = 2; i <= n; i++) {
    // Next fibonacci number = previous + one before previous
    // Translated to JavaScript:
    fib[i] = fib[i - 2] + fib[i - 1];
  }
  return fib[n];
};
