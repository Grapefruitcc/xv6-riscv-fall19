#include "kernel/types.h"
#include "user/user.h"

int main() {
	//�����̹ܵ�
	int parent_pipe[2];
	pipe(parent_pipe);
	//�ӽ��̹ܵ�
	int child_pipe[2];
	pipe(child_pipe);
	//�ַ�����
	char buffer[] = "ping";
	//���г���
	int length = sizeof(buffer);
	//�����ӽ���
	if (fork() == 0) {
		//�ص������̹ܵ���д
		close(parent_pipe[1]);
		//�ص��ӽ��̹ܵ��Ķ�
		close(child_pipe[0]);
		//�ӽ��̶�
		//��ʧ��
		if (read(parent_pipe[0], buffer, length) != length) {
			printf("error:child---read--->parent error\n");
			exit(1);
		}
		//���ɹ�
		printf("child %d read:%s\n", getpid(), buffer);
		//"i"�ĳ�"o"
		buffer[1] = buffer[1] + 6;
		length = sizeof(buffer);
		//�ӽ���д
		if (write(child_pipe[1], buffer, length) != length){
			printf("error:child---write--->parent error\n");
			exit(1);
		}
		//д�ɹ�
		printf("child %d write:%s\n", getpid(), buffer);
		printf("%d: received ping\n", getpid());
		exit(0);
	}
	//���븸����
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