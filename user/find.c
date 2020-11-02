#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

//将找到的路径中的文件名提取出来

char* find_filename(char *file_path) {
	static char buffer[512];
	char *p;
	for (p = file_path + strlen(file_path); p >= file_path && *p != '/'; p--);
	p++;
	memcpy(buffer, p, strlen(p) + 1);
	return buffer;
}

//比对文件名

void cmp_name(char *file_name, char *find_name) {
	if (strcmp(find_filename(file_name), find_name) == 0) {
		printf("%s\n", file_name);
	}
}

void find(char *path, char *find_name) {
	int file_d; //文件句柄
	struct stat file_s; //文件属性
	char buffer[512]; //查询文件目录延伸
	char *p; //暂存指针
	struct dirent file_dir_entry; //文件目录系统
	file_d = open(path, O_RDONLY); //打开文件
	fstat(file_d, &file_s);//查看文件属性
	switch (file_s.type) {
	case T_FILE:
		cmp_name(path, find_name);
		break;
	case T_DIR:
		strcpy(buffer, path);
		p = buffer + strlen(buffer);
		*(p++) = '/';
		while (read(file_d, &file_dir_entry, sizeof(file_dir_entry)) == sizeof(file_dir_entry)) {
			if (file_dir_entry.inum == 0 || file_dir_entry.inum == 1 || strcmp(file_dir_entry.name, ".") == 0 || strcmp(file_dir_entry.name, "..") == 0)
				continue;
			memcpy(p, file_dir_entry.name, sizeof(file_dir_entry.name));
			p[strlen(file_dir_entry.name)] = '\0';
			find(buffer, find_name);
		}
		break;
	}
	close(file_d);
}

void main(int argc, char *argv[]) {
	if (argc < 3) {
		printf("arg error:wrong argument\n");
		exit(-1);
	}
	find(argv[1], argv[2]);
	exit(0);
}