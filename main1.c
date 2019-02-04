#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<unistd.h>
#include<pthread.h>

#include "common.h"
#include "timer.h"

#define STR_LEN 1000

typedef struct{
  int fd;
  double idx;
} RequestInfo; // To store the parsed client message

int runServer(int N, char * ip, int port);
void *dealWithArray(void *args);

char **theArray;
pthread_rwlock_t lock;
double *latencies;


void *dealWithArray(void *args)
{
    RequestInfo *info =  (RequestInfo *) args;
    int clientFileDescriptor = info->fd;
    int idx = info->idx;
    char str[COM_BUFF_SIZE];
    char dst[COM_BUFF_SIZE];
    ClientRequest rqst;
    double start, finished;

    free(info);

    read(clientFileDescriptor,str,COM_BUFF_SIZE);
    GET_TIME(start);
    ParseMsg(str, &rqst);

    switch (rqst.is_read) {
      case 0:
      pthread_rwlock_wrlock(&lock);
      setContent(rqst.msg, rqst.pos, theArray);
      pthread_rwlock_unlock(&lock);
      getContent(dst, rqst.pos, theArray);

      GET_TIME(finished);
      write(clientFileDescriptor,dst,COM_BUFF_SIZE);
      break;

      case 1:
        pthread_rwlock_rdlock(&lock);
        getContent(dst, rqst.pos, theArray);
        pthread_rwlock_unlock(&lock);

        GET_TIME(finished);
        write(clientFileDescriptor,dst,COM_BUFF_SIZE);
      break;

      default:
      printf("\n\n\nuh oh dude\n\n\n\n");
      close(clientFileDescriptor);
      return NULL;
      break;
    }
    latencies[idx] = finished - start;

    close(clientFileDescriptor);
    return NULL;
}

int runServer(int N, char * ip, int port) {
  struct sockaddr_in sock_var;
  int serverFileDescriptor=socket(AF_INET,SOCK_STREAM,0);
  int clientFileDescriptor;
  int i;
  RequestInfo* info;
  pthread_t t[COM_NUM_REQUEST];

  sock_var.sin_addr.s_addr=inet_addr(ip);
  sock_var.sin_port=port;
  sock_var.sin_family=AF_INET;
  if(bind(serverFileDescriptor,(struct sockaddr*)&sock_var,sizeof(sock_var))>=0)
  {
    printf("socket has been created\n");
    listen(serverFileDescriptor,2000);
    while(1)
    {
      for(i=0;i<COM_NUM_REQUEST;i++)      //can support 20 clients at a time
      {
        info = (RequestInfo*) malloc(sizeof(RequestInfo));
        clientFileDescriptor=accept(serverFileDescriptor,NULL,NULL);
        info->fd = clientFileDescriptor;
        info->idx = i;

        pthread_create(&t[i],NULL,dealWithArray,(void *) info);
      }
      for(i=0;i<COM_NUM_REQUEST;i++)      //can support COM_NUM_REQUEST clients at a time
      {
        pthread_join(t[i],NULL);
      }
      saveTimes(latencies,COM_NUM_REQUEST);
    }
    close(serverFileDescriptor);
  }
  else{
      printf("socket creation failed\n");
  }
  return 0;
}


int main(int argc, char* argv[])
{
  int N, i;
  char * server_ip;
  int server_port;


  if (argc != 4) {
    printf("Usage: server <size_of_array> <server_ip> <server_port>\n");
    return(1);
  }

  N = atoi(argv[1]);
  server_ip = argv[2];
  server_port = atoi(argv[3]);

  theArray = (char**) malloc(N * sizeof(char*));
  latencies = (double*) malloc(COM_NUM_REQUEST * sizeof(double));

  // Allocate the array with initial strings
  for (i = 0; i < N; i ++){
    theArray[i] = (char*) malloc(STR_LEN * sizeof(char));
    sprintf(theArray[i], "theArray[%d]: initial value", i);
    // printf("%s\n\n", theArray[i]);
  }

  // initialize each lock
  pthread_rwlock_init(&lock, NULL);


  // main function
  if (runServer(N, server_ip, server_port) != 0) {
    printf("Server error\n");
    return(1);
  }

  // Free up the global array
  for (i=0; i<N; ++i){
    free(theArray[i]);
  }
  free(theArray);

  // Get rid of all the locks
  pthread_rwlock_destroy(&lock);

  free(latencies);

  return(0);
}
