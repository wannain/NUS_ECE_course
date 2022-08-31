# JellyFish network in AWS

This Project is about how to build a suitable network system infrastructure for research experimentation, especially applying for the MPTCP protocol.

## Main performance indicators between Jellyfish and Fat-tree

The fat-tree network is a universal network for provably efficient communication. In order to prove the communication efficiency of our JellyFish network, we realize the comparison between them in some main performance indicators.

#### Path lengths

Analyze the path-length distribution. In this step, we fetch the server nodes from the generated graph, permute all possible server pairs to find their shortest path length and record the number of server pairs that fit in the targeted path length. The result is shown as follows . It shows the comparison of path length distribution between 686-server Jellyfish and same-equipment fat-tree topology. The X-axis represents the length of the shortest path between two server nodes, ranging from 2 to 6, while the Y-axis shows the number of server pairs that fit the path length over all pairs.

![Path_lengths_comparisions](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842742.png)

Conclusions: In Jellyfish, most source-destination pairings can be reached in less than six hops, whereas this is only true for 7.5% of fat-tree source-destination pairs.

#### Bisection Bandwidth

The worst-case bandwidth spanning any two equally-sized network divisions is known as bisection bandwidth, which is a popular way to estimate network capacity. It shows the normalized full bisection bandwidth of two network topologies with different switch number and per-switch port number. The X-axis is the number of servers in thousands, while the Y-axis is the normalized bisection bandwidth.

![Bisection_Bandwidth](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842756.png)

Conclusions: Jellyfish can support a great number of servers at same level of bisection bandwidth. We even can notice that Jellyfish can approach twice the fat-tree's bisection bandwidth because of its great increase in ports.

#### Equipment Cost

How to maximise the throughput and balance equipment cost is the key question to design a future network infrasture for our research experiment. So we compares the cost of building a full bisection-bandwidth network between the two topologies. The X-axis represents the number of servers in thousands, while the Y-axis is the total number of ports in thousands, which simply equals the number of switches (in thousands) times the degree of each switch.

![Equipment Cost](https://raw.githubusercontent.com/wannain/image/main/2022/08/upgit_20220830_1661842771.png)

Conclusions: For JellyFish, in expection, half of its swicth-switch links cross any given bisection of the switches, which is twice that of the fat-tree assuming they are built with the same number of switches and servers. 

### MPTCP configurations

We tried to configure MPTCP directly on the AWS server but failed. The instance always crashes when it is switched from the original kernel to the compiled MPTCP kernel. Having no idea about what's going on, we tried another workaround method, through which it is possible to get the package from repo release without local compilation. 

## Contributions in this research experience

Here are the key points about my controbutions in this research experience. 

- Based on the structural characteristics of the Jellyfish network, I designed a server network future construction solution for the campus data center of NUS Computing Department.
- I have completed the simulation of the network structure of the order of k=12 on AWS, that is, the network service of instant communication with 686 servers, to achieve high robustness
- Implemented the kernel compilation of MPTCP protocol on Ubuntu servers, which makes communication efficiency in this network much higher than the single TCP protocal.

