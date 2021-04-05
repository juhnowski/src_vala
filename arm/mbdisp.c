#include<stdio.h>
#include<string.h>
#include<pthread.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/socket.h> 
#include<arpa/inet.h> 

pthread_t tid[2];
int ret1,ret2;
char start_server_command[30] = "./server/server";
int curr_app = 0;

void* doSomeThing(void *arg)
{
    unsigned long i = 0;
    pthread_t id = pthread_self();
	system(start_server_command);
    /*if(pthread_equal(id,tid[0]))
    {
        printf("\n Config thread processing done\n");
        ret1  = 100;
        pthread_exit(&ret1);
    }
    else
    {
        printf("\n Socket thread processing done\n");
		system(start_server_command);
        ret1  = 200;
        pthread_exit(&ret2);
    }*/
	pthread_exit(&ret1);
    return NULL;
}
void* Configuration(void *arg)
{
	int sock;
    struct sockaddr_in server;
    char message[2000] , server_reply[2000];
    FILE *cfg=fopen("mbdisp.cfg","r");
	char cfg_ptr[255];
	//char cfg_tmp[255]; 
	sleep(1);
    //Create socket
    sock = socket(AF_INET , SOCK_STREAM , 0);
    if (sock == -1)
    {
        printf("Could not create socket(mbdisp)");
    }
    puts("Socket(mbdisp) created");
     
    server.sin_addr.s_addr = inet_addr("127.0.0.1");
    server.sin_family = AF_INET;
    server.sin_port = htons( 8888 );
 
    //Connect to remote server
    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        perror("(mbdisp)connect failed. Error");
        return NULL;
    }
    //Receive status from the server 
    puts("Connected(mbdisp)\n");
	if( recv(sock , server_reply , 2000 , 0) < 0)
   	{
    		puts("recv failed(mbdisp)");
   	}
	printf("(mbdisp)1server reply:%s\n",&server_reply);
	//Status to server
	if( send(sock , "Configuration\n" , strlen("Configuration\n") , 0) < 0)
    {
    	puts("(mbdisp)Send failed");
    }
	if( recv(sock , server_reply , 2000 , 0) < 0)
   	{
    	puts("recv failed(mbdisp)");
   	}
	printf("(mbdisp)2server reply: %s\n",&server_reply);
	//Reading mbdisp.cfg
	if (cfg == NULL) printf("(mbdisp)Can't open file mbdisp.cfg");
	else{
		while(1)
		{
			//Read string
			puts("(mbdisp)fgets");
			fgets(cfg_ptr,100, cfg);
		    if ( feof (cfg) != 0)
		    {  
			
		    	printf ("(mbdisp)Чтение файла закончено\n");
				if( send(sock , "ConfigurationEND\n" , strlen("ConfigurationEND\n") , 0) < 0)
				{
					puts("(mbdisp)Send failed");
				}
				fclose(cfg);puts("(mbdisp)Close file");
				break;
		    }
			char *cfg_tmp = strtok(cfg_ptr, "\n\0");
			//cfg_ptr = cfg_tmp;
			
			strcat(cfg_tmp,"\n");
			//Send string to server
			if( send(sock , cfg_tmp , strlen(cfg_tmp) , 0) < 0)
			{
				puts("(mbdisp)Send failed");
			}
			if( recv(sock , server_reply , 2000 , 0) < 0)
   			{
    			puts("recv failed(mbdisp)");
   			}
			printf("(mbdisp)3server reply: %s\n",&server_reply);
			memset(cfg_tmp,'\0',sizeof(cfg_tmp));
			/*for(int i=0;i<255;i++)
				cfg_tmp[i] = '\0';*/
		}
	}
	sleep(1);
	while(1)
    {
        printf("Enter message : ");
        scanf("%s" , message);
	strcmp(message,"\n");
	//Receive a reply from the server

        //Send some data
        if( send(sock , message , strlen(message) , 0) < 0)
        {
            puts("Send failed");
            return NULL;
        }
        if( recv(sock , server_reply , 2000 , 0) < 0)
        {
            puts("recv failed");
            break;
        }
        puts("Server reply :");
        puts(server_reply);
    }
    send(sock , "exit\n" ,strlen("exit\n") , 0);
	close(sock);
	return NULL;
}
int main(void)
{
    int i = 0;  
    int err;
    int *ptr[2];
	//Создание потока с вызовом server
    err = pthread_create(&(tid[i]), NULL, &doSomeThing, NULL);
    if (err != 0)
        printf("\ncan't create thread :[%s]", strerror(err));
    else
        printf("\n Thread created successfully\n");
    i++;
	err = pthread_create(&(tid[i]), NULL, &Configuration, NULL);
    if (err != 0)
        printf("\ncan't create thread :[%s]", strerror(err));
    else
        printf("\n Thread created successfully\n");

    pthread_join(tid[0], (void**)&(ptr[0]));puts("thread one\n");
    pthread_join(tid[1], (void**)&(ptr[1]));puts("thread two\n");
    printf("return value from config thread is [%d]\n", *ptr[0]);
    printf("return value from server thread is [%d]\n", *ptr[1]);
    return 0;
}
