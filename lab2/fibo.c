#include <stdio.h>

int fibonacci(int n){
    if (n < 2) return n; // base case: fibonacci(0) = 0, fibonacci(1) = 1
    return fibonacci(n-1) + fibonacci(n-2); // recursive case: fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)
}

int main(){
    int n = 44;
    int fibo44 = fibonacci(n);
    printf("Fibonacci(n) = %d\n", fibo44);
    return 0;
}