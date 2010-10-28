public class PrimeFibonacci {

public static void main(String[] args) {
PrimeFib(40,227000);
}

public static void PrimeFib(int n,int min) {

int[] primeFibs = new int[n];
int primeindex = 0;
System.out.println("");

for(int i = 0; i < n; i++) {
int fib = Fibo(i);
if(isPrime(fib) && fib>min) {
primeFibs[primeindex] = fib;
primeindex++;
}
}

System.out.println("");
System.out.println("Prime Fibonacci number greater than minimum:");
for(int i = 0; i < primeindex; i++)
System.out.println(primeFibs[i]);
break;
}

public static boolean isPrime(int n) {
if(n < 2) return false;
if(n == 2) return true;
if(n%2 == 0) return false;
int sqrt = (int)Math.sqrt((double)n);
for(int p = 3; p <= sqrt; p += 2) {
if(n%p == 0) return false;
}
return true;
}

private static int Fibo(int n) {
if(n <= 1) return 1;
else return ( Fibo(n-1) + Fibo(n-2) );
}

}