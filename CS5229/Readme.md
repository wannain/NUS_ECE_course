# JellyFish network in AWS

This Project is about how to build a suitable network system infrastructure for research experimentation, especially applying for the MPTCP protocol.

Here are the key points about my controbutions in this research experience. 

- Based on the structural characteristics of the Jellyfish network, I designed a server network future construction solution for the campus data center of NUS Computing Department.
- I have completed the simulation of the network structure of the order of k=12 on AWS, that is, the network service of instant communication with 686 servers, to achieve high robustness
- Implemented the kernel compilation of MPTCP protocol on Ubuntu servers, which makes communication efficiency in this network much higher than the single TCP protocal.

## Path lengths

It shows the comparison of path length distribution between 686-server Jellyfish and same-equipment fat-tree topology. The X-axis represents the length of the shortest path between two server nodes, ranging from 2 to 6, while the Y-axis shows the number of server pairs that fit the path length over all pairs.

![1c_numeric](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2cdf2969-b005-4c5a-a520-ba1474246b12/1c_numeric.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220830%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220830T062114Z&X-Amz-Expires=86400&X-Amz-Signature=6c9ac27437f414d0102b0343a31b03045a8007dfea1fa714edc2e6d92152139f&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"1c_numeric.png"&x-id=GetObject)