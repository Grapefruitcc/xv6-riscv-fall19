#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define MAXARGS 10
#define MAXWORD 30
#define MAXLINE 100


int getcmd(char *buf, int nbuf) //获取指令
{
	fprintf(2, "@ ");
	memset(buf, 0, nbuf);
	gets(buf, nbuf);
	if (buf[0] == 0) // EOF
		return -1;
	return 0;
}


char whitespace[] = " \t\r\n\v";
char args[MAXARGS][MAXWORD];

void parsecmd(char *cmd, char *argv[], int *argc) {
	for (int i = 0; i < MAXARGS; i++) {
		argv[i] = &args[i][0];
	}
	int i = 0; int j = 0; 
	for (i = 0; cmd[i] != '\n' && cmd[i] != '\0'; i++) {
		//跳过空格找到word
		while (strchr(whitespace, cmd[i])) {
			i++;
		}
		//把word存入argv
		argv[j++] = cmd + i;
		//跳过word找到下一个空格
		while (strchr(whitespace, cmd[i]) == 0) {
			i++;
		}
		cmd[i] = '\0';
	}
	argv[j] = 0;
	*argc = j;
}

void parsepipe(char *argv[], int argc);
void runcmd(char *argv[], int argc) {
	int i = 0;
	//pipe
	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "|")) {
			parsepipe(argv, argc);
		}
	}
	//redir
	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], ">")) {
			close(1);
			open(argv[i + 1], O_CREATE | O_WRONLY);
			argv[i] = 0;
		}
		if (!strcmp(argv[i], "<")) {
			close(0);
			open(argv[i + 1], O_RDONLY);
			argv[i] = 0;
		}
	}
	exec(argv[0], argv);
}
//parsepipe参考user/sh.c runcmd中的case PIPE
void parsepipe(char *argv[], int argc) {
	int i = 0;
	int p[2];
	pipe(p);
	for (i = 0; i < argc; i++) {
		if (!strcmp(argv[i], "|")) {
			argv[i] = 0;
			break;
		}
	}
	if (fork() == 0) {
		close(1);
		dup(p[1]);
		close(p[0]);
		close(p[1]);
		runcmd(argv, i);
	}
	else {
		close(0);
		dup(p[0]);
		close(p[0]);
		close(p[1]);
		runcmd(argv + i + 1, argc - i - 1);
	}
	close(p[0]);
	close(p[1]);
	wait(0);
}

//main函数来自user/sh.c
int main(void){ 
	static char buf[MAXLINE];

	// Read and run input commands.
	while (getcmd(buf, sizeof(buf)) >= 0) {
		if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
			// Chdir must be called by the parent, not the child.
			buf[strlen(buf) - 1] = 0;  // chop \n
			if (chdir(buf + 3) < 0) {
				fprintf(2, "cannot cd %s\n", buf + 3);
			}
			continue;
		}
		if (fork() == 0) {
			char *argv[MAXARGS];
			int argc = -1;
			parsecmd(buf, argv, &argc);
			runcmd(argv, argc);
		}	
		wait(0);
	}
	exit(0);
}