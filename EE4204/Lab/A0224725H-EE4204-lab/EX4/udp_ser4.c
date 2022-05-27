/**************************************
udp_ser.c: the source file of the server in udp transmission
**************************************/
#include "headsock.h"

int str_ser4(int server_socket);                                                           // transmitting and receiving function

void tv_sub(struct  timeval *out, struct timeval *in);	    //calcu the time interval between out and in

int main(void)
{
	int server_socket, con_fd, ret;
	struct sockaddr_in my_addr;
	struct sockaddr_in their_addr;
	int sin_size;
	int end_result=0;

//	char *buf;
	pid_t pid;

	if ((server_socket = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {			//create socket
		printf("error in socket");
		exit(1);
	}

	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(MYUDP_PORT);
	my_addr.sin_addr.s_addr = INADDR_ANY;
	bzero(&(my_addr.sin_zero), 8);
	ret = bind(server_socket, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)); 
	if (ret<0) {           //bind socket
		printf("error in binding");
		exit(1);
	}
	printf("start receiving\n");
	
	while(1)
	{	  
		end_result=str_ser4(server_socket);  //receive packet and response
		if (end_result==1)
		{
			break;
			printf("end_receive_and_response");
		}
	}
	close(server_socket);
	exit(0);
}

int str_ser4(int server_socket)
{
	char buf[BUFSIZE];
	FILE *fp;
	char recvs[DATALEN];
	struct ack_so ack;
	int end, n1,n2,n3 = 0;  //receiving short unit packet result
	long lseek=0;
	long len;
	float time_result=0.0;   //running time
	float rt;    //Throughput
	int result1,result2,result3;  //Sending ACK result
	end = 0;
	struct sockaddr_in addr;
	float time_inv = 0.0;
	struct timeval sendt, recvt;
	int addrlen;
	addrlen=sizeof(struct sockaddr_in);
	//gettimeofday(&sendt, NULL);	//get the current time
	while(!end)
	{
		if (time_inv==0.0)
		{
			gettimeofday(&sendt, NULL);	//get the current time
		}
		//receiving one unit
		int short_packet_length;
		short_packet_length=DATALEN;
		n1= recvfrom(server_socket, &recvs,short_packet_length, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n1==-1)     //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else if(n1==0)
		{
			break;
		}
		else
		{
			printf("receiving 1_1 short packet from client\n");
			//printf("sockfd: %d\n",server_socket);
			//printf("recvfrom result: n: %d\n ", n1);
		}
		if (recvs[n1-1] == '\0')									//if it is the end of the file
		{
			end = 1;
			printf("In the end, only receive: %d bytes\n",n1);
			n1 --;
			memcpy((buf+lseek), recvs, n1);
			lseek += n1;
			break;
		}
		memcpy((buf+lseek), recvs, n1);
		lseek += n1;
		ack.num = 1;
		ack.len = 0;
		result1 = sendto(server_socket, &ack, 2 ,0,(struct sockaddr *)&addr, addrlen);
		if (result1 ==-1)
		{
			printf("send ack error!");//sending the ack is error
			exit(1);
		}
		else
		{
			//printf("This is ok for sending ack\n");
			//printf("sending ack result: %d\n",result);
			//printf("ack_socket: %d \n",server_socket);
		}
		
		
		//receiving two unit
		n1= recvfrom(server_socket, &recvs,short_packet_length, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n1==-1)                 //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else if(n1==0)
		{
			break;
		}
		else
		{
			printf("receiving 2_1 short packet from client\n");
			//printf("sockfd: %d\n",server_socket);
			//printf("recvfrom result: n: %d\n ", n1);
		}
		if (recvs[n1-1] == '\0')//if it is the end of the file
		{
			end = 1;
			printf("In the end, only receive: %d bytes\n",n1);
			n1 --;
			memcpy((buf+lseek), recvs, n1);
			lseek += n1;
			break;
		}
		memcpy((buf+lseek), recvs, n1);
		lseek += n1;
		n2= recvfrom(server_socket, &recvs,short_packet_length, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n2==-1)         //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else if(n2==0)
		{
			break;
		}
		else
		{
			printf("receiving 2_2 short packet from client\n");
			//printf("sockfd: %d\n",server_socket);
			//printf("recvfrom result: n: %d\n ", n1);
		}
		if (recvs[n2-1] == '\0')									//if it is the end of the file
		{
			end = 1;
			printf("In the end, only receive: %d bytes\n",n2);
			n2 --;
			memcpy((buf+lseek), recvs, n2);
			lseek += n2;
			break;
		}
		memcpy((buf+lseek), recvs, n2);
		lseek += n2;
		ack.num = 1;
		ack.len = 0;
		result1 = sendto(server_socket, &ack, 2 ,0,(struct sockaddr *)&addr, addrlen);
		if (result1 ==-1)
		{
			printf("send ack error!");//sending the ack is error
			exit(1);
		}
		else
		{
			//printf("This is ok for sending ack\n");
			//printf("sending ack result: %d\n",result);
			//printf("ack_socket: %d \n",server_socket);
		}

		//receiving three unit
		n1= recvfrom(server_socket, &recvs,short_packet_length, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n1==-1)           //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else if(n1==0)
		{
			break;
		}
		else
		{
			printf("receiving 3_1 short packet from client\n");
			//printf("sockfd: %d\n",server_socket);
			//printf("recvfrom result: n: %d\n ", n1);
		}
		if (recvs[n1-1] == '\0')									//if it is the end of the file
		{
			end = 1;
			printf("In the end, only receive: %d bytes\n",n1);
			n1 --;
			memcpy((buf+lseek), recvs, n1);
			lseek += n1;
			break;
		}
		memcpy((buf+lseek), recvs, n1);
		lseek += n1;
		
		n2= recvfrom(server_socket, &recvs,short_packet_length, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n2==-1)                     //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else if(n2==0)
		{
			break;
		}
		else
		{
			printf("receiving 3_2 short packet from client\n");
			//printf("sockfd: %d\n",server_socket);
			//printf("recvfrom result: n: %d\n ", n1);
		}
		if (recvs[n2-1] == '\0')//if it is the end of the file
		{
			end = 1;
			printf("In the end, only receive: %d bytes\n",n2);
			n2 --;
			memcpy((buf+lseek), recvs, n2);
			lseek += n2;
			break;
		}
		memcpy((buf+lseek), recvs, n2);
		lseek += n2;
			
		n3= recvfrom(server_socket, &recvs,short_packet_length, 0, (struct sockaddr *)&addr, &addrlen);	
		if (n3==-1)                 //receive the packet
		{
			printf("error when receiving\n");
			exit(1);
		}
		else if(n3==0)
		{
			break;
		}
		else
		{
			printf("receiving 3_3 short packet from client\n");
			//printf("sockfd: %d\n",server_socket);
			//printf("recvfrom result: n: %d\n ", n1);
		}
		if (recvs[n3-1] == '\0')									//if it is the end of the file
		{
			end = 1;
			printf("In the end, only receive: %d bytes\n",n3);
			n3 --;
			memcpy((buf+lseek), recvs, n3);
			lseek += n3;
			break;
		}
		memcpy((buf+lseek), recvs, n3);
		lseek += n3;
		ack.num = 1;
		ack.len = 0;
		result1 = sendto(server_socket, &ack, 2 ,0,(struct sockaddr *)&addr, addrlen);
		if (result1 ==-1)
		{
			printf("send ack error!");//sending the ack is error
			exit(1);
		}
		else
		{
			//printf("This is ok for sending ack\n");
			//printf("sending ack result: %d\n",result);
			//printf("ack_socket: %d \n",server_socket);
		}



	}

	if ((fp = fopen ("myUDPreceive.txt","wt")) == NULL)
	{
		printf("File doesn't exit\n");
		exit(0);
	}
	else
	{
		printf("this is ok for opening myUDPrecieve file\n");
	}
	int write_result;
	write_result=fwrite (buf , lseek , 1 , fp);
	printf("write %ld bytes\n ",lseek);					//write data into file
	fclose(fp);
	printf("a file has been successfully received!\nthe total data received is %d bytes\n", (int)lseek);	
	gettimeofday(&recvt, NULL);
	tv_sub(&recvt, &sendt);   // get the whole trans time
	time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
	time_result=time_inv;
	rt = ((int)lseek/(float)time_result);//caculate the average throughput rate
	printf("Time(ms) : %.3f, Data sent(byte): %d\nThroughput: %f (Kbytes/s)\n", time_result, (int)lseek, rt);
	return end;

}

void tv_sub(struct  timeval *out, struct timeval *in)
{
	if ((out->tv_usec -= in->tv_usec) <0)
	{
		--out ->tv_sec;
		out ->tv_usec += 1000000;
	}
	out->tv_sec -= in->tv_sec;
}
