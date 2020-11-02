#include "kernel/types.h"
#include "user/user.h"


//递归函数检测质数
//@input:传入的数的序列
//@number:序列的长度
void primes_check(int *input, int number) {
	//递归终点：只剩一个number
	if (number == 1) {
		printf("prime %d\n", *input);
		return;
	}
	//建立管道
	int p[2];
	int i = 0;
	int j = 0;
	pipe(p);
	//序列第一位数一定是质数
	int prime = *input;
	//向管道中不断读出temp
	int temp;
	int buffer[1];
	printf("prime %d\n", prime);
	//进入子进程
	if (fork() == 0) {
		//向管道里写已经过滤的数
		for (i = 0; i < number; i++) {
			temp = *(input + i);
			if (temp % prime != 0) {
				write(p[1], &temp, sizeof(int));
			}
		}
		exit(0);
	}
	//关闭管道写
	close(p[1]);
	//读出管道里的数并进行下一次过滤
	while (read(p[0], buffer, sizeof(int)) != 0) {
		temp = *buffer;
		*(input + j) = temp;
		j++;
	}
	close(p[0]);
	wait(0);
	primes_check(input, j);
}

int main() {
	int input[34];
	int i = 0;
	for (i = 0; i < 34; i++) {
		input[i] = i + 2;
	}
	primes_check(input, i);
	exit(0);
}