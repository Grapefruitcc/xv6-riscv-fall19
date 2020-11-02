#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
	//�ַ�����ת��������
	int sleep_time = atoi(argv[1]);
	//���ָ���ʽ�������
	//������ʾ
	if (argc != 2) {
		printf("error:argument error.require 1\n");
		exit(1);
	}
	printf("success:sleep for %d\n", sleep_time);
	sleep(sleep_time);
	exit(0);
}