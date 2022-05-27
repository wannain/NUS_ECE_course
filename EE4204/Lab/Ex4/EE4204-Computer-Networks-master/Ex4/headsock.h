// headfile for UDP program
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <math.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/time.h>

#define NEWFILE (O_WRONLY|O_CREAT|O_TRUNC)
#define MYUDP_PORT 5350
#define BUFSIZE 60000              
// experiment variables
#define DATALEN 500
#define ERROR_PROB 0.1

struct pack_so			//data packet structure
{
uint32_t num;				// the sequence number
uint32_t len;					// the packet length
char data[DATALEN];	//the packet data
};

struct ack_so
{
uint8_t num;
uint8_t len;
};