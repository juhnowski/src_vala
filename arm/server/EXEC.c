#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char *argv[]) {
	
	int result = 0;
	int i;
	char* command = malloc(strlen(*argv)+1);
	printf("(EXEC)Param:%s\n",argv[1]);
	for (i = 0; i< argc-1; i++){
		argv[i] = argv[i+1];
		if (i == 0) {
			strcpy(command,argv[i]);
		}	else {
			strcat(command," ");
			strcat(command, argv[i]);
		}
	}
	strcat(command, "&");
	for(i = 0;i<strlen(command)+1;i++)
		command[i]=argv[1][i];
	printf("(EXEC)Command: %s\n",command);
	result = system(command);
	//result = exec_prog(argv);

  return(result);
} 

/*
int exec_prog(char **argv)
{
    pid_t   my_pid;
    int     status, timeout;

    if (0 == (my_pid = fork())) {
            if (-1 == execve(argv[0], (char **)argv , NULL)) {
                    perror("child process execve failed [%m]");
                    return -1;
            }
    }

#ifdef WAIT_FOR_COMPLETION
    timeout = 1000;

    while (0 == waitpid(my_pid , &status , WNOHANG)) {
            if ( --timeout < 0 ) {
                    perror("timeout");
                    return -1;
            }
            sleep(1);
    }

    printf("%s WEXITSTATUS %d WIFEXITED %d [status %d]\n",
            argv[0], WEXITSTATUS(status), WIFEXITED(status), status);

    if (1 != WIFEXITED(status) || 0 != WEXITSTATUS(status)) {
            perror("%s failed, halt system");
            return -1;
    }

#endif
    return 0;
}
*/

