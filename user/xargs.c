#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
	int i = 0;
	int j = 0;
	int k = 0;
	int m = 0;
	int n = 0;
	char cmd_stream[32];
	char buffer[32];
	char *p = buffer;
	char *real_argument[32];
	//��ȡxargsָ��֮��Ĳ���
	for (i = 1, j = 0; i < argc; i++, j++) {
		real_argument[j] = argv[i];
	}
	//��ȡ��ǰָ����
	while ((k = read(0, cmd_stream, sizeof(cmd_stream))) > 0) {
		for (m = 0; m < k; m++) {
			//ָ���������ո�
			if (cmd_stream[m] == ' ') {
				buffer[n] = '\0';
				real_argument[j] = p;
				n++; j++;
				p = &buffer[n];
			}
			//ָ������������
			else if (cmd_stream[m] == '\n') {
				buffer[n] = '\0';
				n = 0;
				real_argument[j] = p;
				j++;
				p = buffer;
				real_argument[j] = 0;
				j = argc - 1;
				if (fork() == 0) {
					exec(argv[1], real_argument);
				}
				wait(0);
			}
			else {
				buffer[n] = cmd_stream[m];
				n++;
			}
		}
	}
	exit(0);
}