/*
    C socket server example, handles multiple clients using threads
*/
 
#include<stdio.h>
#include<string.h>    //strlen
#include<stdlib.h>    //strlen
#include<sys/socket.h>
#include<arpa/inet.h> //inet_addr
#include<unistd.h>    //write
#include<pthread.h> //for threading , link with lpthread
 
//the thread function
void *connection_handler(void *);
char Names[2][50][255];
int curr_name = 0;

int main(int argc , char *argv[])
{
    int socket_desc , client_sock , c , *new_sock;
    struct sockaddr_in server , client;
     
    //Create socket
    socket_desc = socket(AF_INET , SOCK_STREAM , 0);
    if (socket_desc == -1)
    {
        printf("Could not create socket");
    }
    puts("Socket created");
     
    //Prepare the sockaddr_in structure
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons( 8888 );
     
    //Bind
    if( bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0)
    {
        //print the error message
        perror("bind failed. Error");
        return 1;
    }
    puts("bind done");
     
    //Listen
    listen(socket_desc , 3);    
     
    //Accept and incoming connection
    puts("Waiting for incoming connections...");
    c = sizeof(struct sockaddr_in);
    while( (client_sock = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c)) )
    {
        puts("Connection accepted");
         
        pthread_t sniffer_thread;
        new_sock = malloc(1);
        *new_sock = client_sock;
         
        if( pthread_create( &sniffer_thread , NULL ,  connection_handler , (void*) new_sock) < 0)
        {
            perror("could not create thread");
            return 1;
        }
         
        //Now join the thread , so that we dont terminate before the thread
        //pthread_join( sniffer_thread , NULL);
        puts("Handler assigned");
    }
     
    if (client_sock < 0)
    {
        perror("accept failed");
        return 1;
    }
     
    return 0;
}
 
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

void *exec_system(char *message){
	char *pch,*tmp, tmp_msg[strlen(message)];
	int err;
	zStrrep(message,'!',' ');
	strcpy(tmp_msg,message);
	tmp = strtok(message, " \n");
	while(tmp!=NULL)
	{
		for(int i=0;i<50;i++){
			printf("Message:%s Names[0][%d] = %s\n",tmp,i,Names[0][i]);
			if(!strcmp(tmp,Names[0][i]))
			{
				strcpy(message,"echo Gohome");
				system(message);
				strcpy(message,tmp_msg);
				strncpy(tmp,Names[1][i],strlen(Names[1][i]));
				memset(tmp_msg,'\0',strlen(tmp_msg));
				strcpy(tmp_msg,message);
				printf("Execute: %s\n",tmp_msg);
				err = system(tmp_msg);
				printf("Error: %d\n",err);
				if(err>0) puts("[NotOK]");
				return NULL;
			}
		}
		tmp = strtok(NULL, " \n");
	}
	strcpy(message,tmp_msg);
	printf(">%s not registered\n",message);
	printf("Execute: %s\n",message);
	err = system(zStrrep(message,'!',' '));
	printf("Error: %d\n",err);
	if(err>0) puts("[NotOK]");
}

/*
 * This will handle connection for each client
 * */
void *connection_handler(void *socket_desc)
{
    //Get the socket descriptor
    int sock = *(int*)socket_desc;
    int read_size;
    char *message , client_message[2000], *tmp_ptr;
	int conf=0;
    
    //Send status to the client
    message = "Connecteds\n";
    write(sock , message , strlen(message));
    //Receive a message from client
    while( (read_size = recv(sock , client_message , 2000 , 0)) > 0 )
    {
		//Configuration or no
		printf("(server)client massage: %s\n",&client_message);
		printf("conf:%d\n",conf);
		if(strstr(client_message,"Configuration\n"))
		{
			if( send(sock , "Configuration[OK]\n" , strlen("Configuration[OK]\n") , 0) < 0)
    		{
    			puts("(mbdisp)Send failed");
    		} 
			conf = 1;
			continue;
		}
		if(strstr(client_message,"ConfigurationEND\n"))
		{
			puts("(server)ConfigurationEND\n");
			conf = 0;
			continue;			
		}
		if(!strcmp(client_message,"exit"))
		{
			puts("Client disconnected");
			fflush(stdout);
			break;
		}
		if(conf == 0){
			exec_system(client_message);
			printf("(server)%s\n",client_message);
			message = "[Ok]\n";
			strcat(client_message,message);
			write(sock , client_message , strlen(message)+strlen(client_message));
			message = '\0';
			memset(client_message,'\0',strlen(client_message));
			/*for(int i=0;i<2000;i++)
				client_message[i] = '\0';*/
		}
		else{
			if( send(sock , "Configurating[OK]\n" , strlen("Configurating[OK]\n") , 0) < 0)
    		{
    			puts("(mbdisp)Send failed");
    		}
			puts("(server)Configurating\n");
			tmp_ptr = strtok(client_message, " \n");
			printf("(server)1:%s\n",tmp_ptr);
			if(strstr(tmp_ptr,"register"))
			{
				//Write register app to Names[][]
				tmp_ptr = strtok(NULL, " \n");
				strcpy(Names[0][curr_name],tmp_ptr);
				tmp_ptr = strtok(NULL, " \n");
				strcpy(Names[1][curr_name],tmp_ptr);			
				printf("1(server)N[0][0]=%s N[0][1]=%s\n",Names[0][0],Names[1][0]);
				curr_name++;
				memset(client_message,'\0',strlen(client_message));
				/*for(int i=0;i<2000;i++)
					client_message[i] = '\0';*/
				printf("2(server)N[0][0]=%s N[0][1]=%s\n",Names[0][0],Names[1][0]);
			}	
		}
		printf("3(server)N[0][0]=%s N[0][1]=%s\n",Names[0][0],Names[1][0]);
		for(int i=0;i<2000;i++)
					client_message[i] = '\0';
    }
     
    if(read_size == 0)
    {
        puts("Client disconnected");
        fflush(stdout);
    }
    else if(read_size == -1)
    {
        perror("recv failed");
    }
         
    //Free the socket pointer
    free(socket_desc);
     
    return 0;
}
