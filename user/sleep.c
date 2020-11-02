#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
	//字符参数转换成整型
	int sleep_time = atoi(argv[1]);
	//如果指令格式输入错误
	//进行提示
	if (argc != 2) {
		printf("error:argument error.require 1\n");
		exit(1);
	}
	printf("success:sleep for %d\n", sleep_time);
	sleep(sleep_time);
	exit(0);
}