
long long int mul(long long int a, long long int b);
long long int main(void);

long long int _start(void){
	main();
	for(;;);
}

long long int mul(long long int a, long long int b){
	long long unsigned int res = 0;
	for (long long unsigned int i = 0; i < b; i+=1){
		res += a;
	}
	return res;
}

long long int main(void){
	long long int a = 6;
	long long int b = 5;
	long long int c = mul(a,b);
	return c;
}

long long int __muldi3(long long int a, long long int b){
	long long unsigned int res = 0;
	for (long long unsigned int i = 0; i < b; i+=1){
		res += a;
	}
	return res;
}