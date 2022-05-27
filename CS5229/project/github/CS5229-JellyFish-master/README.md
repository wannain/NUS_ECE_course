# CS5229-JellyFish

This is a repository for team project of course CS5229.

## Part 2: Numerical Reproduction

### Topology construction

1. Reproduce Figure 1(a)(Fat-tree with 16 servers and 20 4-port switches).
2. Implement `build_jellyfish_graph`.
3. Reproduce Figure 1(b)(Jellyfish with 16 servers and 20 4-port switches).

### Topology Analysis

Bisection Bandwidth(BB): a lower bound of Bollobas is used to approximate BB of a Jellyfish graph. For both Fat-tree and Jellyfish, BB is normalized by dividing it by sum of bandwidth of servers in one partition.

Support servers at full capacity / full BB: Given number of servers, a Jellyfish topology supports full capacity for all flows when tested by 3 randomly sampled permutation traffic matrices.

1. Reproduce Figure 1(c)
    Length distribution of shortest paths between servers in 686-server Fat-tree and Jellyfish.
2. Reproduce Figure 2(a)
    Normalized Bisection Bandwidth w.r.t. Number of Servers for different config of Fat-tree and Jellyfish.
    N for number of switches; k for number of ports on one switch.
    The following values of (N, k) are tested: (2880, 48); (1280, 32); (720, 24).
3. Reproduce Figure 2(b).
    Number of ports w.r.t. Number of Servers for different config of Fat-tree and Jellyfish.
    The topology is expected to support servers at full capacity.
    The following values of port count per switch are tested: 24, 32, 48, 64.

4. Reproduce Figure 9.

