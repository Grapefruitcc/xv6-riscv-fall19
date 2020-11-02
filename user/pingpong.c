#include "kernel/types.h"
#include "user/user.h"

int main() {
	//父进程管道
	int parent_pipe[2];
	pipe(parent_pipe);
	//子进程管道
	int child_pipe[2];
	pipe(child_pipe);
	//字符序列
	char buffer[] = "ping";
	//序列长度
	int length = sizeof(buffer);
	//进入子进程
	if (fork() == 0) {
		//关掉父进程管道的写
		close(parent_pipe[1]);
		//关掉子进程管道的读
		close(child_pipe[0]);
		//子进程读
		//读失败
		if (read(parent_pipe[0], buffer, length) != length) {
			printf("error:child---read--->parent error\n");
			exit(1);
		}
		//读成功
		printf("child %d read:%s\n", getpid(), buffer);
		//"i"改成"o"
		buffer[1] = buffer[1] + 6;
		length = sizeof(buffer);
		//子进程写
		if (write(child_pipe[1], buffer, length) != length){
			printf("error:child---write--->parent error\n");
			exit(1);
		}
		//写成功
		printf("child %d write:%s\n", getpid(), buffer);
		printf("%d: received ping\n", getpid());
		exit(0);
	}
	//进入父进程
	close(parent_pipe[0]);
	close(child_pipe[1]);
	if (write(parent_pipe[1], buffer, length) != length) {
		printf("error:parent---write--->child error\n");
		exit(1);
	}
	printf("parent %d write:%s\n", getpid(), buffer);
	if (read(child_pipe[0], buffer, length) != length) {
		printf("error:parent---read--->child error\n");
		exit(1);
	}
	printf("parent %d read:%s\n", getpid(), buffer);
	printf("%d: received pong\n", getpid());
	exit(0);
}