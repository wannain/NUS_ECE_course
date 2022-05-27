/*
UDP socket for transferring big file in small data units
*/
#include "headsock.h"

//transmission function
float str_cli(FILE *fp, int sockfd, struct sockaddr *addr, int addrlen, long *len); 
//calculate the time interval between out and in
void tv_sub(struct  timeval *out, struct timeval *in);	    

int main(int argc, char **argv)
{
	int sockfd;
	float ti, rt, th;
	long len;
	struct sockaddr_in ser_addr;
	char ** pptr;
	struct hostent *sh;
	struct in_addr **addrs;
	FILE *fp;

	if (argc != 2) {
		printf("parameters not match");
	}

    //get host's information
	sh = gethostbyname(argv[1]);	                      
	if (sh == NULL) {
		printf("error when gethostby name");
		exit(0);
	}

    //print the remote host's information
    printf("canonical name: %s\n", sh->h_name);					
	for (pptr=sh->h_aliases; *pptr != NULL; pptr++){
        printf("the aliases name is: %s\n", *pptr);
    }
	switch(sh->h_addrtype) {
		case AF_INET:
			printf("AF_INET\n");
		break;
		default:
			printf("unknown addrtype\n");
		break;
	}

    //create the socket
    addrs = (struct in_addr **)sh->h_addr_list;
	sockfd = socket(AF_INET, SOCK_DGRAM, 0);            
	if (sockfd<0) {
		printf("error in socket");
		exit(1);
	}
  
	ser_addr.sin_family = AF_INET;                                                      
	ser_addr.sin_port = htons(MYUDP_PORT);
	memcpy(&(ser_addr.sin_addr.s_addr), *addrs, sizeof(struct in_addr));
	bzero(&(ser_addr.sin_zero), 8);
	
	if((fp = fopen ("myfile.txt","r+t")) == NULL) {
		printf("File doesn't exit\n");
		exit(0);
	}

    //perform the transmission and receiving
	ti = str_cli(fp, sockfd, (struct sockaddr *)&ser_addr, sizeof(struct sockaddr_in), &len);
	rt = (len/(float)ti);           //caculate the average transmission rate
    th = 8*rt/(float)1000;
	printf("Time(ms) : %.3f, Data sent(byte): %d\nData rate: %f (Kbytes/s), Throughput: %f (Mbps)\n", ti, (int)len, rt, th);

	close(sockfd);
	fclose(fp);
  
	exit(0);
}


float str_cli(FILE *fp, int sockfd, struct sockaddr *addr, int addrlen, long *len) {
	char *buf;
    //lsize: entire file size; ci: curr index of buf
	long lsize, ci = 0;   
	char sends[DATALEN];    
	struct ack_so ack;
    // slen: len of string to send
	int n, slen;  
	float time_inv = 0.0;
	struct timeval sendt, recvt;
    

	fseek (fp , 0 , SEEK_END);
	lsize = ftell (fp);
	rewind (fp);
    printf("The file length is %d bytes\n", (int)lsize);
	printf("the packet length is %d bytes\n",DATALEN);

    // allocate memory to contain the whole file.
	buf = (char *) malloc (lsize+1);
	if (buf == NULL) exit (2);

    // copy the file into the buffer.
	fread (buf,1,lsize,fp);

    /*** the whole file is loaded in the buffer. ***/
    //append the end byte (extra byte sent to server)
	buf[lsize] ='\0';		
    //get the current time				  
	gettimeofday(&sendt, NULL);		
	while(ci <= lsize) {
		printf("===========\n");

        if ((lsize+1-ci) <= DATALEN) {
            slen = lsize+1-ci;
        } else {
            slen = DATALEN;
        }
        
        printf("slen: %d\n", slen);

        memcpy(sends, (buf+ci), slen);
        
		//send the data
		n = sendto(sockfd, &sends, slen, 0, addr, addrlen);
		if(n == -1) {
			printf("send error!");								
			exit(1);
		}
		printf("[client]send a packet\n");
        
        //receive the ack
        if ((n = recvfrom(sockfd, &ack, 2, 0, addr, (socklen_t*)&addrlen))== -1) { 
			//no ack received
            printf("error when receiving ack\n");
            exit(1);
        }
		if (ack.num == 1 && ack.len == 0) {
			//ACK
			ci += slen;
			printf("[client]receive an ack\n");
		}else if (ack.num == -1 && ack.len == 0) {
			//NACK
			printf("[client]receive an NACK\n");
		} else {
			ci += slen;
		}
        
	}

    //get current time
    gettimeofday(&recvt, NULL);       
    *len= ci;    
    // get the whole trans time
    tv_sub(&recvt, &sendt);              
    time_inv += (recvt.tv_sec)*1000.0 + (recvt.tv_usec)/1000.0;
    return(time_inv);
}


void tv_sub(struct  timeval *out, struct timeval *in) {
	if ((out->tv_usec -= in->tv_usec) <0) {
		--out ->tv_sec;
		out ->tv_usec += 1000000;
	}
	out->tv_sec -= in->tv_sec;
}

