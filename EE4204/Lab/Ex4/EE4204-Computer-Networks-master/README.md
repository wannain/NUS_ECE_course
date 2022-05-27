# EE4204-Computer-Networks

## Tasks
1. Ex1
<br/> TCP and UDP transmission of short messages

2. Ex2
<br/> TCP socket for sending an entire large file.

3. Ex3
<br/> TCP socket for sending a large file in short data units without waiting for ACK for every data unit.

4. Ex4
<br/> UDP socket for sending a large file in short data units. And implement ARQ with stop-and-wait for error simulation.

## Running code
1. compile C code
```
gcc -g -Wall -o udp_client_assignment udp_client_assignment.c
gcc -g -Wall -o udp_server_assignment udp_server_assignment.c
```
2. start the server and client
```
./udp_server_assignment start receiving
./udp_client_assignment 127.0.0.1
```
3. check received file
```
diff myfile.txt myUDPreceive.txt
```

## Problem
1. memory leak `corrupted size vs prev_size`
run the scripts using 

```
valgrind --track-origins=yes ./udp_server_assignment start receiving
valgrind --leak-check=full ./udp_client_assignment 127.0.0.1
```

## Reference 
https://stackoverflow.com/questions/45488328/udp-packet-loss-simulation-probability

https://www.cs.rpi.edu/~moorthy/Courses/os98/Pgms/socket.html