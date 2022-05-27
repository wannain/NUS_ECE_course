#include "headsock.h"

// transmitting and receiving function
void str_ser(int sockfd, struct sockaddr *addr, int addrlen);             

int main(void)
{
	int sockfd, ret;
	struct sockaddr_in my_addr;

	//create socket
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);          
	if (sockfd<0)
	{
		printf("error in socket!");
		exit(1);
	}
	
	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(MYUDP_PORT);
	my_addr.sin_addr.s_addr = INADDR_ANY;//inet_addr("172.0.0.1");
	bzero(&(my_addr.sin_zero), 8);
	//bind socket
	ret = bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr));                
	if (ret<0) {
		printf("error in binding");
		exit(1);
	}
	
	printf("waiting for data\n");
	//receive packet and response
	str_ser(sockfd, (struct sockaddr *)&my_addr, sizeof(struct sockaddr_in));                
  
	close(sockfd);
	exit(0);
}

void str_ser(int sockfd, struct sockaddr *addr, int addrlen)
{
	char buf[BUFSIZE];
	FILE *fp;
	char recvs[DATALEN];
	struct ack_so ack;
	int end = 0, n = 0;
	long lseek=0;
	double randomnum = 0.0;

	while(!end) {
		printf("===========\n");

		// error simulation
        randomnum = (double) rand() / (RAND_MAX);
        printf("random number is %f \n", randomnum);
        if(randomnum < ERROR_PROB) {
            // damaged packet
            printf("[server] damaged packet\n");
			// send NACK 
			ack.num = -1;
			ack.len = 0;
			if ((n = sendto(sockfd, &ack, 2, 0, addr, addrlen))==-1) {
				printf("send error!");								
				exit(1);
			}
			printf("[server] sent an NACK\n");
        }else {
			// complete packet
			if ((n= recvfrom(sockfd, &recvs, DATALEN, 0, addr, (socklen_t *)&addrlen))==-1) {
				printf("error when receiving\n");
				exit(1);
			}
			printf("[server] received a packet\n");
			
			//end of the file
			if (recvs[n-1] == '\0')	{
				end = 1;
				n --;
			}

			// process the received packet
			memcpy((buf+lseek), recvs, n);
			printf("%d bytes of data received: %s\n", n, recvs);
			lseek += n;

			// send ack 
			ack.num = 1;
			ack.len = 0;
			if ((n = sendto(sockfd, &ack, 2, 0, addr, addrlen))==-1) {
				printf("send error!");								
				exit(1);
			}
			printf("[server] sent an ack\n");
		}

		printf("the end: %d\n", end);
	}
  
	if ((fp = fopen ("myUDPreceive.txt","wt")) == NULL)
	{
		printf("File doesn't exist\n");
		exit(0);
	}
	fwrite (buf , 1 , lseek , fp);					//write data into file
	fclose(fp);
	printf("a file has been successfully received!\nthe total data received is %d bytes\n", (int)lseek);
}