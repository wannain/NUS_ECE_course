#include "headsock.h"

// Function Protoypes
void readfromsocket(int sockfd); // Receive data from socket sockfd
void send_ack(int sockfd, struct sockaddr *client_addr, socklen_t client_addrlen, long fileoffset); // Block until acknowledge is sent

int main(int argc, char *argv[]) {
    // Setup server socket address
    struct sockaddr_in server_addr_in;
    server_addr_in.sin_family = AF_INET;
    server_addr_in.sin_port = htons(MYUDP_PORT); // htons() converts port number to big endian
    server_addr_in.sin_addr.s_addr = INADDR_ANY; // INADDR_ANY=0, 0 means receive data from any IP address
    memset(&(server_addr_in.sin_zero), 0, sizeof(server_addr_in.sin_zero));
    // Typecast internet socket address (struct sockaddr_in) to generic socket address (struct sockaddr)
    struct sockaddr *server_addr = (struct sockaddr *)&server_addr_in;
    socklen_t server_addrlen = sizeof(struct sockaddr);

    // Create UDP socket
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) { printf("error creating socket"); exit(1); }

    // Bind socket address to socket (server only, client don't need)
    if (bind(sockfd, server_addr, server_addrlen) == -1) { printf("error in binding"); exit(1); }

    // Read file data from socket
    while (1) {
        printf("Ready to receive data\n");
        readfromsocket(sockfd);
    }
    close(sockfd);

    // Compare myfile.txt and myUDPreceive.txt
    printf("Differences between myfile.txt and myUDPreceive.txt:\n");
    char * const args[]={"diff", "myfile.txt", "myUDPreceive.txt"}; 
    execv("/usr/bin/diff", args);
}

void readfromsocket(int sockfd) {
    //---------------------------------------------//
    // buffer used to contain the incoming packet. //
    //---------------------------------------------//
    char packet[DATAUNIT];

    // Create empty struct to contain client address
    // It will be filled in by recvfrom()
    struct sockaddr client_addr;
    socklen_t client_addrlen = sizeof(struct sockaddr);

    // Get filesize from client
    long filesize;
    int n = recvfrom(sockfd, &filesize, sizeof(filesize), 0, &client_addr, &client_addrlen);
    if (n < 0) { printf("error in receiving packet\n"); exit(1); }
    send_ack(sockfd, &client_addr, client_addrlen, 0); // Acknowledge that filesize has been received
    printf("Client says the file is %ld bytes big. DATAUNIT %d bytes\n", filesize-1, DATAUNIT);

    //----------------------------------------//
    // buffer used to contain the entire file //
    //----------------------------------------//
    char filebuffer[filesize];

    int dum = 1; // data unit multiple
    long fileoffset = 0; // Tracks how many bytes have been received so far
    char packetlastbyte; // Tracks the last byte of the latest packet received
    //-----------------------------------------------------------------------------------------------------------//
    // Keep reading from socket until the last byte of the latest packet is an End of Transmission character 0x4 //
    //-----------------------------------------------------------------------------------------------------------//
    do {
        // Depending on dum, read packets of DATAUNIT size 1, 2, 3 times before sending an ACK
        for (int i=0; i<dum; i++) {
            // Read incoming packet (recvfrom will block until data is received)
            int bytesreceived = recvfrom(sockfd, &packet, DATAUNIT, 0, &client_addr, &client_addrlen);
            if (bytesreceived < 0) {
                printf("error in receiving packet\n");
                exit(1);
            }

            // Append packet data to filebuffer
            memcpy((filebuffer + fileoffset), packet, bytesreceived);
            fileoffset += bytesreceived;
            if ((packetlastbyte = packet[bytesreceived-1]) == 0x4) break;
        }

        // Acknowledge that packet has been received
        send_ack(sockfd, &client_addr, client_addrlen, fileoffset);
        dum = (++dum % 5 == 0) ? 1 : dum % 5;
    } while (packetlastbyte != 0x4);
    fileoffset-=1; // Disregard the last byte of filebuffer because it is the End of Transmission character 0x4

    // Open file for writing
    char filename[] = "myUDPreceive.txt";
    FILE* fp = fopen(filename, "wt");
    if (fp == NULL) { printf("File %s doesn't exist\n", filename); exit(1); }

    // Copy the filebuffer contents into file
    fwrite(filebuffer, 1, fileoffset, fp);
    fclose(fp);
    printf("File data received successfully, %d bytes written\n", (int)fileoffset);
}

void send_ack(int sockfd, struct sockaddr *addr, socklen_t addrlen, long fileoffset) {
    const int ACKNOWLEDGE = 1;
    int ack_sent = 0;
    int ack_thresh = 10;
    while (!ack_sent) {
        if (sendto(sockfd, &ACKNOWLEDGE, sizeof(ACKNOWLEDGE), 0, addr, addrlen) >= 0) {
            ack_sent = 1;
        } else {
            if (ack_thresh-- <= 0) {
                printf("(%ld) emergency breakout of ack error loop\n", fileoffset * DATAUNIT);
                exit(1);
            } else printf("error sending ack, trying again..\n");
        }
    }
}
