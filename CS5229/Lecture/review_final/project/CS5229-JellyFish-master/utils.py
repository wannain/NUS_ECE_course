from collections import defaultdict
import networkx as nx
import matplotlib.pyplot as plt
import random
from math import log, log1p, sqrt

from networkx.classes import graph

def draw_topo_graph(topo_graph, outfile):
    """
    Uses matplotlib to draw the topology graph to the outfile. Uses different
    colors for the nodes if nodes have the attribute 'type' set to either
    'switch' or 'host'.
    
    Parameters
    ----------
    topo_graph: fnss.DatacenterTopology or networkx.Graph
      Input topology graph. Should be an object of type networkx.Graph OR fnss.DatacenterTopology
    outfile: string
      Path along with filename and extension to output the topology graph drawing
      
    Returns
    -------
    outfile: jpg, png, svg or pdf file depending on the file extension
      Draws the graph to the outfile.
    """

    switch_color = '#800000'
    host_color = '#808080'

    color_map = []
    for node,attributes in topo_graph.nodes.data():
        node_type = attributes.get('type')
        if node_type == 'switch':
            color_map.append(switch_color)
        elif node_type == 'host':
            color_map.append(host_color)

    if (len(color_map) > 0):
        nx.draw(topo_graph, node_color = color_map)   
    else:
        nx.draw(topo_graph)
    
    plt.savefig(outfile)

def generate_random_pair(n):
    seq = random.shuffle(range(n))
    mid = int(len(seq)/2)
    return (seq[:mid], seq[mid:2*mid])


def path_length_distrib_analysis(G, start_nodes, end_nodes):
    counter_dict = defaultdict(int)
    for start in start_nodes:
        for end in end_nodes:
            if start != end:
                length = nx.shortest_path_length(start, end)
                counter_dict[length] += 1
    total = sum(counter_dict.values())
    counter_dict = { key: float(value) / float(total) for key, value in counter_dict.items() }
    return counter_dict

def maximum_flow_bandwidth(G: nx.Graph, start_nodes, end_nodes, capacity="weights"):
    H = nx.Graph(G)
    H.add_node("source")
    for node in start_nodes:
        H.add_edge("source", node)
    H.add_node("sink")
    for node in end_nodes:
        H.add_edge(node, "sink")
    result = nx.maximum_flow_value(H, "source", "sink")
    return result

def lower_bound_bandwidth(num_of_switch, num_of_port):
    # TODO: calculate lower bound of Bollobas
    N = num_of_switch
    r = num_of_port
    return N*(r/4 - sqrt(r*log(r))/2)
    # return G.number_of_nodes() / 2

def bisection_bandwidth_analysis(num_of_port, topology="jellyfish"):
    num_of_switch = num_of_port ** 2 * 5 / 4
    if topology == "fat_tree":
        return num_of_port ** 3 / 8
    elif topology == "jellyfish":
        bb = lower_bound_bandwidth(num_of_switch, num_of_port)
        lo = 0.2
        hi = 1.8
        lo_n_srv = int(bb / lo)
        hi_n_srv = int(bb / hi)
        n_srv = range(lo_n_srv, hi_n_srv, (hi_n_srv-lo_n_srv) // 20)
        norm_bb = [ bb / num for num in n_srv ]
        return (n_srv, norm_bb)
    else:
        raise NotImplementedError

def normalized_capacity(G, start_nodes, end_nodes, capacity="weights"):
    real_bw = maximum_flow_bandwidth(G, start_nodes, end_nodes, capacity=capacity)
    # TODO: strictly this should be sum of degrees of nodes
    idea_bw = min(len(start_nodes), len(end_nodes))
    return float(real_bw) / idea_bw

def check_full_capacity(G, server_nodes, capacity="weights", sampling=3):
    for _ in range(sampling):
        rdn_idx_pair = generate_random_pair(len(server_nodes))
        svr_pair = ( [server_nodes[idx] for idx in rdn_idx_pair[0]], [server_nodes[idx] for idx in rdn_idx_pair[1]] )
        cap = normalized_capacity(G, svr_pair[0], svr_pair[1], capacity=capacity)
        if cap < 1:
            return False
    return True

def max_server_support_search(graph_builder, capacity="weights", sampling=3, search_start=2):
    hi = int(search_start)
    while True:
        G = graph_builder(hi)
        server_nodes = [ node for node in G if G.node[node]['type'] == 'server' ]
        full_capacity = check_full_capacity(G, server_nodes, capacity=capacity, sampling=sampling)
        if not full_capacity: # TODO: add a maximum tolerance?
            break
        hi *= 2
    lo = hi // 2
    while hi - lo > 1:
        mid = (lo + hi)//2
        G = graph_builder(mid)
        server_nodes = [ node for node in G if G.node[node]['type'] == 'server' ]
        full_capacity = check_full_capacity(G, server_nodes, capacity=capacity, sampling=sampling)
        if full_capacity: # TODO: add a maximum tolerance?
            lo = mid
        else:
            hi = mid
    return lo
    
def equipment_cost_analysis(graph_builder, num_of_port, capacity="weights", topology="jellyfish"):
    num_of_switch = num_of_port ** 2 * 5 / 4
    if topology == "fat_tree":
        return num_of_port * num_of_port
    elif topology == "jellyfish":
        n_rack = range(0, 20000, 1000)
        n_srv = [ max_server_support_search(lambda x: graph_builder(num_racks=x), capacity=capacity) for x in n_rack ]
        n_port = [ x*num_of_port for x in n_rack ]
        return (n_srv, n_port)
    else:
        raise NotImplementedError

def _k_shortest_path_diversity(G, start_node, end_node, k=8, policy="MPTCP"):
    if policy == "MPTCP":
        paths = nx.shortest_simple_paths(G, start_node, end_node)
    elif policy == "ECMP":
        paths = nx.all_shortest_paths(G, start_node, end_node)
    else:
        raise NotImplementedError        
    cnt = k
    for path in paths:
        for i in range(len(path)-1):
            G[path[i]][path[i+1]]["diversity"] += 1
        cnt -= 1
        if cnt == 0:
            break

def path_diversity(graph_builder, k=8, policy="MPTCP"):
    G = graph_builder()
    nx.set_edge_attributes(G, 0, "diversity")
    server_nodes = [ node for node in G if G.node[node]['type'] == 'server' ]
    rdn_idx_pair = generate_random_pair(len(server_nodes))
    svr_pairs = [ (server_nodes[src], server_nodes[dst]) for src, dst in rdn_idx_pair ]
    for src, dst in svr_pairs:
        _k_shortest_path_diversity(G, src, dst, k=k, policy=policy)
    diversity_list = [ G[src][dst]["diversity"] for src, dst in G.edges ]
    diversity_list = diversity_list + diversity_list # two directions per link
    diversity_list.sort()
    return diversity_list



if __name__ == "__main__":
    pass