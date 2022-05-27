#include "headsock.h"
#include <arpa/inet.h>

// Function Prototypes
void sendtosocket(int sockfd, struct sockaddr *addr, socklen_t addrlen); // Send data to socket address addr through socket sockfd
void tv_sub(struct  timeval *out, struct timeval *in); // Calculate the time interval between out and in
void wait_ack(int sockfd, struct sockaddr *addr, socklen_t addrlen); // Block until acknowledge is received

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Please provide an IP_addr. Example: ./server.out 127.0.0.1\n");
        printf("'localhost' does not work, use 127.0.0.1 instead of 'localhost'\n");
        exit(1);
    }
    char *IP_addr = argv[1];

    // Setup server socket address
    struct sockaddr_in server_addr_in;
    server_addr_in.sin_family = AF_INET;
    server_addr_in.sin_port = htons(MYUDP_PORT); // htons() converts port number to big endian form
    server_addr_in.sin_addr.s_addr = inet_addr(IP_addr); // inet_addr converts IP_addr string to big endian form
    memset(&(server_addr_in.sin_zero), 0, sizeof(server_addr_in.sin_zero));
    // Typecast internet socket address (struct sockaddr_in) to generic socket address (struct sockaddr)
    struct sockaddr *server_addr = (struct sockaddr *)&server_addr_in;
    socklen_t server_addrlen = sizeof(struct sockaddr);

    // Create UDP socket
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) { printf("error creating socket"); exit(1); }

    // Send file data to socket
    sendtosocket(sockfd, server_addr, server_addrlen);
    close(sockfd);
}

void sendtosocket(int sockfd, struct sockaddr *server_addr, socklen_t server_addrlen) {
    //--------------------------------------------//
    // buffer used to contain the outgoing packet //
    //--------------------------------------------//
    char packet[DATAUNIT];

    // Open file for reading
    char filename[] = "myfile.txt";
    FILE* fp = fopen(filename, "rt");
    if (fp == NULL) { printf("File %s doesn't exist\n", filename); exit(1); }

    // Get the total filesize
    fseek(fp, 0, SEEK_END); long filesize = ftell(fp); rewind(fp);
    printf("The file length is %d bytes\n", (int)filesize);

    //----------------------------------------//
    // buffer used to contain the entire file //
    //----------------------------------------//
    char filebuffer[filesize];

    // Copy the file contents into filebuffer
    fread(filebuffer, 1, filesize, fp);
    filebuffer[filesize]=0x4; // Append the filebuffer contents with the End of Transmission ASCII character 0x4
    filesize+=1; // Increase filesize by 1 byte because of the addition of the EOT ASCII character 0x4
    fclose(fp);

    // Tell server how big the file is and wait for server acknowledgement
    sendto(sockfd, &filesize, sizeof(filesize), 0, server_addr, server_addrlen);
    wait_ack(sockfd, server_addr, server_addrlen);

    // Get start time
    struct timeval timeSend;
    gettimeofday(&timeSend, NULL);

    long fileoffset = 0; // Tracks how many bytes have been sent so far
    int dum = 1; // data unit multiple, alternates between 1,2,3,4
    //---------------------------------------------------------------------------------//
    // Keep sending data until number of bytes sent is no longer smaller than filesize //
    //---------------------------------------------------------------------------------//
    while (fileoffset < filesize) {
        // Depending on dum, send packets of DATAUNIT size 1, 2, 3 or 4 times before waiting for an ACK
        for (int i=0; i<dum; i++) {
            int packetsize = (DATAUNIT < filesize - fileoffset) ? DATAUNIT : filesize - fileoffset; // packetsize should never be bigger than what's left to send
            memcpy(packet, (filebuffer + fileoffset), packetsize); // Copy the next section of the filebuffer into the packet
            fileoffset += packetsize; // Update fileoffset
            int n = sendto(sockfd, &packet, packetsize, 0, server_addr, server_addrlen); // Send packet data into socket
            if (n < 0) {
                printf("error in sending packet\n");
                exit(1);
            }
            printf("packet of size %d sent\n", n);
        }
        wait_ack(sockfd, server_addr, server_addrlen);
        dum = (++dum % 5 == 0) ? 1 : dum % 5;
    }

    // Get end time
    struct timeval timeRcv;
    gettimeofday(&timeRcv, NULL);

    // Calculate difference between start and end time and print transfer rate
    tv_sub(&timeRcv, &timeSend);
    float time = (timeRcv.tv_sec)*1000.0 + (timeRcv.tv_usec)/1000.0;
    printf("DATAUNIT %d bytes | %ld bytes sent over %.3fms | %.3f Mbytes/s\n", DATAUNIT, fileoffset, time, fileoffset/time/1000);
}

void tv_sub(struct  timeval *out, struct timeval *in) {
    if ((out->tv_usec -= in->tv_usec) <0) {
        --out ->tv_sec;
        out ->tv_usec += 1000000;
    }
    out->tv_sec -= in->tv_sec;
}

void wait_ack(int sockfd, struct sockaddr *addr, socklen_t addrlen) {
    int ack_received = 0;
    int ACKNOWLEDGE = 0;
    while (!ack_received) {
        if (recvfrom(sockfd, &ACKNOWLEDGE, sizeof(ACKNOWLEDGE), 0, addr, &addrlen) >= 0) {
            if (ACKNOWLEDGE == 1) {
                ack_received = 1;
                printf("ACKNOWLEDGE received\n");
            } else {
                printf("ACKNOWLEDGE received but value was not 1\n");
                exit(1);
            }
        } else {
            printf("error when waiting for acknowledge\n");
            exit(1);
        }
    }
}
