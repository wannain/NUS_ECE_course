# JellyFish network in AWS

This Project is about how to build a suitable network system infrastructure for research experimentation, especially applying for the MPTCP protocol.

Here are the key points about my controbutions in this research experience. 

- Based on the structural characteristics of the Jellyfish network, I designed a server network future construction solution for the campus data center of NUS Computing Department.
- I have completed the simulation of the network structure of the order of k=12 on AWS, that is, the network service of instant communication with 686 servers, to achieve high robustness
- Implemented the kernel compilation of MPTCP protocol on Ubuntu servers, which makes communication efficiency in this network much higher than the single TCP protocal.

## Main performance indicators between Jellyfish and Fat-tree

We all know the fat tree network is a universal network for provably efficient communication. In order to prove the communication efficiency of our JellyFish network, we realize the comparison in some main performance indicators.

### Path lengths

It shows the comparison of path length distribution between 686-server Jellyfish and same-equipment fat-tree topology. The X-axis represents the length of the shortest path between two server nodes, ranging from 2 to 6, while the Y-axis shows the number of server pairs that fit the path length over all pairs.

![](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842742.png)

![](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842756.png)

![](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842771.png)

![](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842812.png)