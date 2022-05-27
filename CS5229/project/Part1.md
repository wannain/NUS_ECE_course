Q1

current high-bandwidth data center network proposals allow incremental growth？

Jellyfish also allows construction of arbitrary-size networks, unlike topologies discussed above which limit the network to very coarse design points dictated by their structure.

In addition, Jellyfish has lower mean path length,and is resilient to failures and miswirings.

Q2

High performance computing literature has also studied carefully-structured expander graphs [27].
However, none of these architectures address the incremental expansion problem.

Further, in SWDC, the use of a regular lattice underlying the topology creates familiar problems with incremental expansion.

Scafida has marginally worse bisection bandwidth and diameter than a fat-tree, while Jellyfish improves on fat-trees on both metrics.

Q3

Key idea of Jellyfish:

- The Jellyfish approach is to construct a random graph at the top-of-rack(ToR) Switch layer.

Intuition: 

- The intuition for the latter property is simple: lacking structure, the RRG’s network capacity becomes “fluid”, easily wiring up any number of switches, heterogeneous degree distributions, and newly added switches with a few random link swaps.

- that is, the average path length. Therefore, assuming that the routing protocol is able to utilize the network’s full capacity, low average path length allows us to support more flows
  at high throughput.

Q4

(i) Servers: 30(10-1)                 Switches: 30*1

(ii)Servers: 30(10-4)                 Switches: 30*4

Q5

Bisection bandwidth, a common measure of network capacity, is the worst-case bandwidth spanning any two equal-size partitions of a network. Here, we compute the fat-tree’s bisection
bandwidth directly from its parameters; for Jellyfish, we model the network as a RRG and apply a lower bound of Bollob´as [8]. We normalize bisection bandwidth by dividing it by the total line-rate bandwidth of the servers in one partition.

Q6 

4^3/4 servers

(4/2)^2+4*(4/2+4/2) switches



M number of switches, N number of ToR switches, M-N number of other switches

(M-N)*k=N(k-r) 



Q7

Q8

Q9

Q10



