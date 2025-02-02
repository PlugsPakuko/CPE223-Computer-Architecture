#include <stdio.h>

int fibonacci(int n){
    if (n < 2) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

int main(){
    int fibo44 = fibonacci(44);
    printf("Fibonacci(44th) = %d\n", fibo44);
    return 0;
}