/**************************************
udp_ser.c: the source file of the server in udp transmission
**************************************/
#include "headsock.h"

void str_ser4(int sockfd);                                                           // transmitting and receiving function

int main(void)
{
	int sockfd, con_fd, ret;
	struct sockaddr_in my_addr;
	struct sockaddr_in their_addr;
	int sin_size;

//	char *buf;
	pid_t pid;

	if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {			//create socket
		printf("error in socket");
		exit(1);
	}

	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(MYUDP_PORT);
	my_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(my_addr.sin_zero), 8);
	ret = bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)); 
	if (ret<0) {           //bind socket
		printf("error in binding");
		exit(1);
	}
	printf("start receiving\n");
	
	while(1) {
		printf("waiting for data\n");
		str_ser4(sockfd);
		}
	close(sockfd);
	exit(0);
}

void str_ser4(int sockfd)
{
	char buf[BUFSIZE];
	FILE *fp;
	char recvs[DATALEN];
	struct ack_so ack;
	int end, n = 0;
	long lseek=0;
	int result;
	end = 0;
	struct sockaddr_in addr;
	int addrlen;
	addrlen=sizeof(struct sockaddr_in);
	while(!end)
	{
		n= recvfrom(sockfd, &recvs,DATALEN, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n==-1)                                   //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else
		{
			printf("This is ok for receiving short packet from client\n");
			printf("sockfd: %d\n",sockfd);
		}
		if (recvs[n-1] == '\0')									//if it is the end of the file
		{
			end = 1;
			n --;
		}
		memcpy((buf+lseek), recvs, n);
		lseek += n;
		
		int ack_fd;
		ack_fd=socket(AF_INET, SOCK_DGRAM, 0);
		ack.num = 1;
		ack.len = 0;
		result = sendto(ack_fd, &ack, 2 ,0,(struct sockaddr *)&addr, addrlen);
		if (result ==-1)
		{
				printf("send error!");								//send the ack
				exit(1);
		}
		else
		{
			printf("This is ok for sending ack\n");
			printf("sending ack result: %d\n",result);
			printf("ack_fd: %d \n",ack_fd);
		}
		//close(ack_fd);
	}
	if ((fp = fopen ("myTCPreceive.txt","wt")) == NULL)
	{
		printf("File doesn't exit\n");
		exit(0);
	}
	fwrite (buf , 1 , lseek , fp);					//write data into file
	fclose(fp);
	printf("a file has been successfully received!\nthe total data received is %d bytes\n", (int)lseek);	

}
