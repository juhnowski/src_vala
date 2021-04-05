#include <stdlib.h>
#include<string.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include<unistd.h>

char Names[2][50][100];

char *zStrrep(char *str, char x, char y){
    char *tmp=str;
	while(*tmp){
        if(*tmp == x)
           	*tmp++ = y; /* assign first, then incement */
        else
            *tmp++;
	}
	*tmp='\0';
	return str;
}
int main(int argc, char * argv[])
{ 	
	FILE *cfg=fopen("mbdisp.cfg","r");
	char cfg_ptr[255],message[]="This is mbgui";
	//char *cfg_tmp;
	int i; 
	if (cfg == NULL) printf("Can't open file mbdisp.cfg");
	else{
		while(1)
		{
			//Read string
			puts("fgets");
			fgets(cfg_ptr,100, cfg);
			if ( feof (cfg) != 0)
		    	{  
			
		    	printf ("Чтение файла закончено\n");
					puts("Send failed");

				fclose(cfg);puts("Close file(mbdisp)");
				break;
		   	}
			printf("i:%d\n",i);
			char *cfg_tmp = strtok(cfg_ptr, " \n");
			cfg_tmp = strtok(NULL, " \n");
			strcpy(Names[0][0],cfg_tmp);
			cfg_tmp = strtok(NULL, " \n");
			strcpy(Names[1][0],cfg_tmp);
			printf("before:%s\n",cfg_ptr);
			printf("1 N[0][0]=%s N[0][1]=%s\n",Names[0][0],Names[1][0]);
			memset(cfg_ptr,'\0',sizeof(cfg_ptr));
			printf("after:%s\n",cfg_ptr);
			/*for(int i=0;i<255;i++)
				cfg_ptr[i] = '\0';*/
			printf("2 N[0][0]=%s N[0][1]=%s\n",Names[0][0],Names[1][0]);
			i++;
		}
		puts("Enter message:");
		char *pch,*tmp, tmp_msg[strlen(message)];
		int err;
		zStrrep(message,'!',' ');
		strcpy(tmp_msg,message);
		printf("tmp: %s\n",tmp_msg);
		tmp = strtok(message, " \n");
		while(tmp!=NULL)
		{
			printf("message: %s\n",message);
			for(int i=0;i<50;i++){
				printf("Message:%s Names[0][%d] = %s\n",tmp,i,Names[0][i]);
				if(!strcmp(tmp,Names[0][i]))
				{
					strcpy(message,tmp_msg);
					strncpy(tmp,Names[1][i],strlen(Names[1][i]));
					printf("Execute: %s\n",message);
					//err = system(message);
					if(err>0) puts("[NotOK]");
					return 0;
				}
			}
			tmp = strtok(NULL, " \n");
		}
		printf("Execute: %s\n",message);
		err = system(message);
		printf("%d\n",err);
		if(err>0) puts("[NotOK]");
	}
	return 0;
}
