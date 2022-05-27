/*******************************
udp_client.c: the source file of the client in udp
********************************/

#include "headsock.h"

float str_cli4(FILE *fp, int client_socket,struct sockaddr *addr, int addrlen, long *len);                       //transmission function
void tv_sub(struct  timeval *out, struct timeval *in);	    //calcu the time interval between out and in

int main(int argc, char *argv[])
{
	int client_socket,ret;
	float ti, rt;
	long len;
	struct sockaddr_in ser_addr;
	char **pptr;
	struct hostent *sh;
	struct in_addr **addrs;
	FILE *fp;

	if (argc!= 2)
	{
		printf("parameters not match.");
		exit(0);
	}

	if ((sh=gethostbyname(argv[1]))==NULL) {             //get host's information
		printf("error when gethostbyname");
		exit(0);
	}

	client_socket = socket(AF_INET, SOCK_DGRAM, 0);             //create socket
	if (client_socket<0)
	{
		printf("error in socket");
		exit(1);
	}

	addrs = (struct in_addr **)sh->h_addr_list;
	printf("canonical name: %s\n", sh->h_name);
	for (pptr=sh->h_aliases; *pptr != NULL; pptr++)
		printf("the aliases name is: %s\n", *pptr);			//printf socket information
	switch(sh->h_addrtype)
	{
		case AF_INET:
			printf("AF_INET\n");
		break;
		default:
			printf("unknown addrtype\n");
		break;
	}

	ser_addr.sin_family = AF_INET;
	ser_addr.sin_port = htons(MYUDP_PORT);
	memcpy(&(ser_addr.sin_addr.s_addr), *addrs, sizeof(struct in_addr));
	bzero(&(ser_addr.sin_zero), 8);
	
	if((fp = fopen ("myfile.txt","r+t")) == NULL)
	{
		printf("File doesn't exit\n");
		exit(0);
	}

	ti=str_cli4(fp, client_socket, (struct sockaddr *)&ser_addr, sizeof(struct sockaddr_in), &len);   // receive and send
	rt = (len/(float)ti);                                         //caculate the average transmission rate
	printf("Time(ms) : %.3f, Data sent(byte): %d\nData rate: %f (Kbytes/s)\n", ti, (int)len, rt);

	close(client_socket);
	fclose(fp);
	exit(0);
}

float str_cli4(FILE *fp, int client_socket, struct sockaddr *addr, int addrlen, long *len)
{

	char *buf;
	long lsize, ci;
	char sends[DATALEN];
	struct ack_so ack;
	int n1,n2,n3, slen1,slen2,slen3;
	float time_inv = 0.0;
	struct timeval sendt, recvt;
	int result1,result2,result3;
	ci = 0;

	fseek (fp , 0 , SEEK_END);
	lsize = ftell (fp);
	rewind (fp);
	printf("The file length is %d bytes\n", (int)lsize);
	printf("the packet length is %d bytes\n",DATALEN);


// allocate memory to contain the whole file.
	buf = (char *) malloc (lsize);
	if (buf == NULL) exit (2);

  // copy the file into the buffer.
	fread (buf,1,lsize,fp);
	printf("lsize: is %ld \n",lsize);

  /*** the whole file is loaded in the buffer. ***/
	buf[lsize] ='\0';	//append the end byte
	gettimeofday(&sendt, NULL);	//get the current time
	while(ci<= lsize)
	{
		//sending one short unit
		int short_packet_length;
		short_packet_length=DATALEN;
		if ((lsize+1-ci) <= short_packet_length)
		{
			slen1 = lsize+1-ci;
			printf("This time, sending : %d bytes\n",slen1);
		}
		else 
		{
			slen1 = short_packet_length;
			printf("This time, sending : %d bytes\n",slen1);
		}
		memcpy(sends, (buf+ci), slen1);
		client_socket=socket(AF_INET, SOCK_DGRAM, 0);
		n1 = sendto(client_socket, &sends,slen1, 0, addr, addrlen); 
		if(n1 == -1) {
			printf("send error!");	//send the data
			exit(1);
		}
		else if(slen1<DATALEN)
		{
			ci += slen1;
			printf("Last packet is comming\n");
			gettimeofday(&recvt, NULL);
			*len=ci;                  //get current time
			tv_sub(&recvt, &sendt);   // get the whole trans time
			time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
			return(time_inv);
		}
		else
		{
			printf("This is ok for sending first short packet(first sending)\n");
			//printf("client_socket: %d \n",client_socket);
		}
		ci += slen1;
		result1= recvfrom(client_socket, &ack, 2, 0, addr, &addrlen);
		if (result1==-1)  //receive the ack
		{
			printf("error when receiving ack\n");
			exit(1);
		}
		else
		{
			printf("This is ok for receiving ack\n");
			printf("ACK result: %d \n",result1);
			printf("In this time, this ack socket(ack_socket):%d\n",client_socket);
		}
		if (ack.num != 1|| ack.len != 0)
			printf("error in transmission\n");




		//sending two short unit
		short_packet_length=DATALEN;
		if ((lsize+1-ci) <= short_packet_length)
		{
			slen1 = lsize+1-ci;
			printf("This time, sending : %d bytes\n",slen1);
		}
		else 
		{
			slen1 = short_packet_length;
			printf("This time, sending : %d bytes\n",slen1);
		}
		memcpy(sends, (buf+ci), slen1);
		client_socket=socket(AF_INET, SOCK_DGRAM, 0);
		n1 = sendto(client_socket, &sends,slen1, 0, addr, addrlen); 
		if(n1 == -1) {
			printf("send error!");	//send the data
			exit(1);
		}
		else if(slen1<DATALEN)
		{
			ci += slen1;
			printf("Last packet is comming\n");
			gettimeofday(&recvt, NULL);
			*len=ci;                  //get current time
			tv_sub(&recvt, &sendt);   // get the whole trans time
			time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
			return(time_inv);
		}
		else
		{
			printf("This is ok for send first short packet(for sesond sending)\n");
			//printf("client_socket: %d \n",client_socket);
		}
		ci += slen1;
		if ((lsize+1-ci) <= short_packet_length)
		{
			slen2 = lsize+1-ci;
			printf("This time, sending : %d bytes\n",slen2);
		}
		else 
		{
			slen2 = short_packet_length;
			printf("This time, sending : %d bytes\n",slen2);
		}

		memcpy(sends, (buf+ci), slen2);
		n2 = sendto(client_socket, &sends,slen2, 0, addr, addrlen); 
		if(n2 == -1) {
			printf("send error!");	//send the data
			exit(1);
		}
		else if(slen2<DATALEN)
		{
			ci += slen2;
			printf("Last packet is comming\n");
			gettimeofday(&recvt, NULL);
			*len=ci;                  //get current time
			tv_sub(&recvt, &sendt);   // get the whole trans time
			time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
			return(time_inv);
		}
		else
		{
			printf("This is ok for send second short packet(for sesond sending)\n");
			//printf("client_socket: %d \n",client_socket);
		}
		ci += slen2;
		result1= recvfrom(client_socket, &ack, 2, 0, addr, &addrlen);
		if (result1==-1)  //receive the ack
		{
			printf("error when receiving ack\n");
			exit(1);
		}
		else
		{
			printf("This is ok for receiving ack\n");
			printf("ACK result: %d \n",result1);
			printf("In this time, this ack socket(ack_socket):%d\n",client_socket);
		}
		if (ack.num != 1|| ack.len != 0)
			printf("error in transmission\n");



		//sending three short unit
		short_packet_length=DATALEN;
		if ((lsize+1-ci) <= short_packet_length)
		{
			slen1 = lsize+1-ci;
			printf("This time, sending : %d bytes\n",slen1);
		}
		else 
		{
			slen1 = short_packet_length;
			printf("This time, sending : %d bytes\n",slen1);
		}

		memcpy(sends, (buf+ci), slen1);
		client_socket=socket(AF_INET, SOCK_DGRAM, 0);
		n1 = sendto(client_socket, &sends,slen1, 0, addr, addrlen); 
		if(n1 == -1) {
			printf("send error!");	//send the data
			exit(1);
		}
		else if(slen1<DATALEN)
		{
			ci += slen1;
			printf("Last packet is comming\n");
			gettimeofday(&recvt, NULL);
			*len=ci;                  //get current time
			tv_sub(&recvt, &sendt);   // get the whole trans time
			time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
			return(time_inv);
		}
		else
		{
			printf("This is ok for sending first short packet(third sending)\n");
			//printf("client_socket: %d \n",client_socket);
		}
		ci += slen1;
		if ((lsize+1-ci) <= short_packet_length)
		{
			slen2 = lsize+1-ci;
			printf("This time, sending : %d bytes\n",slen2);
		}
		else 
		{
			slen2 = short_packet_length;
			printf("This time, sending : %d bytes\n",slen2);
		}
		memcpy(sends, (buf+ci), slen2);
		client_socket=socket(AF_INET, SOCK_DGRAM, 0);
		n2 = sendto(client_socket, &sends,slen2, 0, addr, addrlen); 
		if(n2 == -1) {
			printf("send error!");	//send the data
			exit(1);
		}
		else if(slen2<DATALEN)
		{
			ci += slen2;
			printf("Last packet is comming\n");
			gettimeofday(&recvt, NULL);
			*len=ci;                  //get current time
			tv_sub(&recvt, &sendt);   // get the whole trans time
			time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
			return(time_inv);
		}
		else
		{
			printf("This is ok for sending second short packet(third sending)\n");
			//printf("client_socket: %d \n",client_socket);
		}
		ci += slen2;
		if ((lsize+1-ci) <= short_packet_length)
		{
			slen3 = lsize+1-ci;
			printf("This time, sending : %d bytes\n",slen3);
		}
		else 
		{
			slen3 = short_packet_length;
			printf("This time, sending : %d bytes\n",slen3);
		}
		memcpy(sends, (buf+ci), slen3);
		n3 = sendto(client_socket, &sends,slen3, 0, addr, addrlen); 
		if(n3 == -1) {
			printf("send error!");	//send the data
			exit(1);
		}
		else if(slen3<DATALEN)
		{
			ci += slen3;
			printf("Last packet is comming\n");
			gettimeofday(&recvt, NULL);
			*len=ci;                  //get current time
			tv_sub(&recvt, &sendt);   // get the whole trans time
			time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
			return(time_inv);
		}
		else
		{
			printf("This is ok for sending third short packet(third sending)\n");
			//printf("client_socket: %d \n",client_socket);
		}
		ci += slen3;
		result1= recvfrom(client_socket, &ack, 2, 0, addr, &addrlen);
		if (result1==-1)  //receive the ack
		{
			printf("error when receiving ack\n");
			exit(1);
		}
		else
		{
			printf("This is ok for receiving ack\n");
			printf("ACK result: %d \n",result1);
			printf("In this time, this ack socket(ack_socket):%d\n",client_socket);
		}
		if (ack.num != 1|| ack.len != 0)
			printf("error in transmission\n");
			
	}
	gettimeofday(&recvt, NULL);
	*len=ci;                  //get current time
	tv_sub(&recvt, &sendt);   // get the whole trans time
	time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
	return(time_inv);
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
