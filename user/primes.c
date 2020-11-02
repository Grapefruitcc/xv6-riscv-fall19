#include "kernel/types.h"
#include "user/user.h"


//�ݹ麯���������
//@input:�������������
//@number:���еĳ���
void primes_check(int *input, int number) {
	//�ݹ��յ㣺ֻʣһ��number
	if (number == 1) {
		printf("prime %d\n", *input);
		return;
	}
	//�����ܵ�
	int p[2];
	int i = 0;
	int j = 0;
	pipe(p);
	//���е�һλ��һ��������
	int prime = *input;
	//��ܵ��в��϶���temp
	int temp;
	int buffer[1];
	printf("prime %d\n", prime);
	//�����ӽ���
	if (fork() == 0) {
		//��ܵ���д�Ѿ����˵���
		for (i = 0; i < number; i++) {
			temp = *(input + i);
			if (temp % prime != 0) {
				write(p[1], &temp, sizeof(int));
			}
		}
		exit(0);
	}
	//�رչܵ�д
	close(p[1]);
	//�����ܵ��������������һ�ι���
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