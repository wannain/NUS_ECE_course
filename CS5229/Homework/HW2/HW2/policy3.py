#!/usr/bin/python

import httplib
import json
import time
import automonitor

class StaticFlowPusher(object):
    def __init__(self, server):
        self.server = server

    def get(self, data):
        ret = self.rest_call({}, 'GET')
        return json.loads(ret[2])

    def set(self, data):
        ret = self.rest_call(data, 'POST')
        return ret[0] == 200

    def remove(self, objtype, data):
        ret = self.rest_call(data, 'DELETE')
        return ret[0] == 200

    def rest_call(self, data, action):
        path = '/wm/staticflowpusher/json'
        headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            }
        body = json.dumps(data)
        conn = httplib.HTTPConnection(self.server, 8080)
        conn.request(action, path, body, headers)
        response = conn.getresponse()
        ret = (response.status, response.reason, response.read())
        #print ret
        conn.close()
        return ret
        


class flowAdder(object):
    def __init__(self):
        self.switchArray = []
    
    def initSwitchArray(self,switchMonArray):
        self.switchArray = switchMonArray
    
    def set(self,myflow):
        pusher.set(myflow)

        ind = int(myflow['switch'][-1])-1
        # print(ind)
        priority = int(myflow["priority"])
        outport = myflow["actions"][-1]

        ipKey = myflow["ipv4_src"]+"+"+myflow["ipv4_dst"]

        self.switchArray[ind].addFlowStat(outport,ipKey,priority)

adder = flowAdder()
pusher = StaticFlowPusher('127.0.0.1')

# Below 6 flows are for setting up the dymamic forwarding for the path H1-S1-S2-S3>H3 & vice-versa
# Define Dynamic flow for Switch S1 for packet forwarding b/w H1 and H3
    # S1: H1-H3
S1Dynamicflow1_H1toH3 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh3dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.3","active":"true","actions":"output=2"}
    # S1: H3-H1
S1Dynamicflow2_H3toH1 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h3toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.3",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define Dynamic flow for Switch S2 for packet forwarding b/w H1 and H3
    # S2: H1-H3
S2Dynamicflow1_H1toH3 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h1toh3dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.3","active":"true","actions":"output=3"}
    # S2: H3-H1
S2Dynamicflow2_H3toH1 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h3toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.3",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=2"}
    # Define Dynamic flow for Switch S3 for packet forwarding b/w H1 and H3
    # S3: H1-H3
S3Dynamicflow1_H1toH3 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh3dynamic","cookie":"0",
                        "priority":"2","in_port":"5","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.3","active":"true","actions":"output=1"}
    # S3: H3-H1
S3Dynamicflow2_H3toH1 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h3toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.3",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=5"}
                        
                        
                        
                        
                        
# Below 6 flows are for setting up the dymamic forwarding for the path H1-S1-S2-S3->H4 & vice-versa
# Define Dynamic flow for Switch S1 for packet forwarding b/w H1 and H4
    # S1: H1-H4
S1Dynamicflow1_H1toH4 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh4dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}
    # S1: H4-H1
S1Dynamicflow2_H4toH1 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h4toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define Dynamic flow for Switch S2 for packet forwarding b/w H1 and H4
    # S2: H1-H4
S2Dynamicflow1_H1toH4 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h1toh4dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.4","active":"true","actions":"output=3"}
    # S2: H4-H1
S2Dynamicflow2_H4toH1 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h4toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.4",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=2"}
    # Define Dynamic flow for Switch S3 for packet forwarding b/w H1 and H4
    # S3: H1-H4
S3Dynamicflow1_H1toH4 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh4dynamic","cookie":"0",
                        "priority":"2","in_port":"5","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}
    # S3: H4-H1
S3Dynamicflow2_H4toH1 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h4toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=5"}
                        
                        
                        
                        
                        
# Below 6 flows are for setting up the dymamic forwarding for the path H1-S1-S2-S3->H5 & vice-versa
# Define Dynamic flow for Switch S1 for packet forwarding b/w H1 and H5
    # S1: H1-H5
S1Dynamicflow1_H1toH5 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh5dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.5","active":"true","actions":"output=2"}
    # S1: H5-H1
S1Dynamicflow2_H5toH1 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h5toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.5",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define Dynamic flow for Switch S2 for packet forwarding b/w H1 and H5
    # S2: H1-H5
S2Dynamicflow1_H1toH5 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h1toh5dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}
    # S2: H5-H1
S2Dynamicflow2_H5toH1 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h5toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=2"}
    # Define Dynamic flow for Switch S3 for packet forwarding b/w H1 and H5
    # S3: H1-H5
S3Dynamicflow1_H1toH5 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh5dynamic","cookie":"0",
                        "priority":"2","in_port":"5","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}
    # S3: H5-H1
S3Dynamicflow2_H5toH1 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h5toh1dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=5"}
                        
                        
                        
# Below 6 flows are for setting up the dymamic forwarding for the path H2-S2-S1-S3>H3 & vice-versa
    # Define Dynamic flow for Switch S2 for packet forwarding b/w H2 and H3
    # S2: H2-H3
S2Dynamicflow1_H2toH3 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh3dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.3","active":"true","actions":"output=2"}
    # S2: H3-H2
S2Dynamicflow2_H3toH2 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h3toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.3",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Define Dynamic flow for Switch S1 for packet forwarding b/w H2 and H3
    # S1: H2-H3
S1Dynamicflow1_H2toH3 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h2toh3dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.3","active":"true","actions":"output=3"}
    # S1: H3-H2
S1Dynamicflow2_H3toH2 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h3toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.3",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=2"}
    # Define Dynamic flow for Switch S3 for packet forwarding b/w H2 and H3
    # S3: H2-H3
S3Dynamicflow1_H2toH3 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h2toh3dynamic","cookie":"0",
                        "priority":"2","in_port":"4","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.3","active":"true","actions":"output=1"}
    # S3: H3-H2
S3Dynamicflow2_H3toH2 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h3toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.3",
                        "ipv4_dst":"10.0.0.1","active":"true","actions":"output=4"}
                        
                        
                        
                        
                        
# Below 6 flows are for setting up the dymamic forwarding for the path H2-S2-S1-S3->H4 & vice-versa
    # Define Dynamic flow for Switch S2 for packet forwarding b/w H2 and H4
    # S2: H2-H4
S2Dynamicflow1_H2toH4 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh4dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}
    # S2: H4-H2
S2Dynamicflow2_H4toH2 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h4toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Define Dynamic flow for Switch S1 for packet forwarding b/w H2 and H4
    # S1: H2-H4
S1Dynamicflow1_H2toH4 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h2toh4dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.4","active":"true","actions":"output=3"}
    # S1: H4-H2
S1Dynamicflow2_H4toH2 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h4toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.4",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=2"}

    # Define Dynamic flow for Switch S3 for packet forwarding b/w H2 and H4
    # S3: H2-H4
S3Dynamicflow1_H2toH4 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h2toh4dynamic","cookie":"0",
                        "priority":"2","in_port":"4","eth_type":"0x800","ipv4_src":"10.0.0.1",
                        "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}
    # S3: H4-H2
S3Dynamicflow2_H4toH2 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h4toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=4"}
                        
                        
                        
                        
                        
# Below 6 flows are for setting up the dymamic forwarding for the path H2-S2-S1-S3->H5 & vice-versa
    # Define Dynamic flow for Switch S2 for packet forwarding b/w H2 and H5
    # S2: H2-H5
S2Dynamicflow1_H2toH5 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh5dynamic","cookie":"0",
                        "priority":"2","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.5","active":"true","actions":"output=2"}
    # S2: H5-H2
S2Dynamicflow2_H5toH2 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h5toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Define Dynamic flow for Switch S1 for packet forwarding b/w H2 and H5
    # S1: H2-H5
S1Dynamicflow1_H2toH5 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h2toh5dynamic","cookie":"0",
                        "priority":"2","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}
    # S1: H5-H2
S1Dynamicflow2_H5toH2 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h5toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=2"}
    # Define Dynamic flow for Switch S1 for packet forwarding b/w H2 and H5
    # S3: H2-H5
S3Dynamicflow1_H2toH5 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h2toh5dynamic","cookie":"0",
                        "priority":"2","in_port":"4","eth_type":"0x800","ipv4_src":"10.0.0.2",
                        "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}
    # S3: H5-H2
S3Dynamicflow2_H5toH2 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h5toh2dynamic","cookie":"0",
                        "priority":"2","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                        "ipv4_dst":"10.0.0.2","active":"true","actions":"output=4"}
                        
                        
def set_H1toH3_dynamic()
    # Set a dynamic flow (H1-S1-S2-S3-H3)
    pusher.set(S1Dynamicflow1_H1toH3)
    pusher.set(S1Dynamicflow2_H3toH1)
    pusher.set(S2Dynamicflow1_H1toH3)
    pusher.set(S2Dynamicflow2_H3toH1)
    pusher.set(S3Dynamicflow1_H1toH3)
    pusher.set(S3Dynamicflow2_H3toH1)
    
def remove_H1toH3_dynamic()
    # Remove this dynamic flow (H1-S1-S2-S3-H3)
    pusher.remove(0,S1Dynamicflow1_H1toH3)
    pusher.remove(0,S1Dynamicflow2_H3toH1)
    pusher.remove(0,S2Dynamicflow1_H1toH3)
    pusher.remove(0,S2Dynamicflow2_H3toH1)
    pusher.remove(0,S3Dynamicflow1_H1toH3)
    pusher.remove(0,S3Dynamicflow2_H3toH1)
    
def set_H1toH4_dynamic()
    # Set a dynamic flow (H1-S1-S2-S3-H4)
    pusher.set(S1Dynamicflow1_H1toH4)
    pusher.set(S1Dynamicflow2_H4toH1)
    pusher.set(S2Dynamicflow1_H1toH4)
    pusher.set(S2Dynamicflow2_H4toH1)
    pusher.set(S3Dynamicflow1_H1toH4)
    pusher.set(S3Dynamicflow2_H4toH1)
    
def remove_H1toH4_dynamic()
    # Remove this dynamic flow (H1-S1-S2-S3-H4)
    pusher.remove(0,S1Dynamicflow1_H1toH4)
    pusher.remove(0,S1Dynamicflow2_H4toH1)
    pusher.remove(0,S2Dynamicflow1_H1toH4)
    pusher.remove(0,S2Dynamicflow2_H4toH1)
    pusher.remove(0,S3Dynamicflow1_H1toH4)
    pusher.remove(0,S3Dynamicflow2_H4toH1)
    
def set_H1toH5_dynamic()
    # Set a dynamic flow (H1-S1-S2-S3-H5)
    pusher.set(S1Dynamicflow1_H1toH5)
    pusher.set(S1Dynamicflow2_H5toH1)
    pusher.set(S2Dynamicflow1_H1toH5)
    pusher.set(S2Dynamicflow2_H5toH1)
    pusher.set(S3Dynamicflow1_H1toH5)
    pusher.set(S3Dynamicflow2_H5toH1)
    
def remove_H1toH5_dynamic()
    # Remove this dynamic flow (H1-S1-S2-S3-H5)
    pusher.remove(0,S1Dynamicflow1_H1toH5)
    pusher.remove(0,S1Dynamicflow2_H5toH1)
    pusher.remove(0,S2Dynamicflow1_H1toH5)
    pusher.remove(0,S2Dynamicflow2_H5toH1)
    pusher.remove(0,S3Dynamicflow1_H1toH5)
    pusher.remove(0,S3Dynamicflow2_H5toH1)
def set_H2toH3_dynamic()
    # Set a dynamic flow (H2-S1-S2-S3-H3)
    pusher.set(S1Dynamicflow1_H2toH3)
    pusher.set(S1Dynamicflow2_H3toH2)
    pusher.set(S2Dynamicflow1_H2toH3)
    pusher.set(S2Dynamicflow2_H3toH2)
    pusher.set(S3Dynamicflow1_H2toH3)
    pusher.set(S3Dynamicflow2_H3toH2)
    
def remove_H2toH3_dynamic()
    # Remove this dynamic flow (H2-S1-S2-S3-H3)
    pusher.remove(0,S1Dynamicflow1_H2toH3)
    pusher.remove(0,S1Dynamicflow2_H3toH2)
    pusher.remove(0,S2Dynamicflow1_H2toH3)
    pusher.remove(0,S2Dynamicflow2_H3toH2)
    pusher.remove(0,S3Dynamicflow1_H2toH3)
    pusher.remove(0,S3Dynamicflow2_H3toH2)
    
def set_H2toH4_dynamic()
    # Set a dynamic flow (H2-S1-S2-S3-H4)
    pusher.set(S1Dynamicflow1_H2toH4)
    pusher.set(S1Dynamicflow2_H4toH2)
    pusher.set(S2Dynamicflow1_H2toH4)
    pusher.set(S2Dynamicflow2_H4toH2)
    pusher.set(S3Dynamicflow1_H2toH4)
    pusher.set(S3Dynamicflow2_H4toH2)
    
def remove_H2toH4_dynamic()
    # Remove this dynamic flow (H2-S1-S2-S3-H4)
    pusher.remove(0,S1Dynamicflow1_H2toH4)
    pusher.remove(0,S1Dynamicflow2_H4toH2)
    pusher.remove(0,S2Dynamicflow1_H2toH4)
    pusher.remove(0,S2Dynamicflow2_H4toH2)
    pusher.remove(0,S3Dynamicflow1_H2toH4)
    pusher.remove(0,S3Dynamicflow2_H4toH2)
    
def set_H2toH5_dynamic()
    # Set a dynamic flow (H2-S1-S2-S3-H5)
    pusher.set(S1Dynamicflow1_H2toH5)
    pusher.set(S1Dynamicflow2_H5toH2)
    pusher.set(S2Dynamicflow1_H2toH5)
    pusher.set(S2Dynamicflow2_H5toH2)
    pusher.set(S3Dynamicflow1_H2toH5)
    pusher.set(S3Dynamicflow2_H5toH2)
    
def remove_H2toH5_dynamic()
    # Remove this dynamic flow (H2-S1-S2-S3-H5)
    pusher.remove(0,S1Dynamicflow1_H2toH5)
    pusher.remove(0,S1Dynamicflow2_H5toH2)
    pusher.remove(0,S2Dynamicflow1_H2toH5)
    pusher.remove(0,S2Dynamicflow2_H5toH2)
    pusher.remove(0,S3Dynamicflow1_H2toH5)
    pusher.remove(0,S3Dynamicflow2_H5toH2)

def staticForwarding():
    # Below 4 flows are for setting up the static forwarding for the path H1->S1->S2->H2 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h1 and h2
    S1Staticflow1 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh2","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=2"}
    S1Staticflow2 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h2toh1","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define static flow for Switch S2 for packet forwarding b/w h1 and h2
    S2Staticflow1 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh1","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=2"}
    S2Staticflow2 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h1toh2","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}

    # Below 4 flows are for setting up the static forwarding for the path H1->S1->S3->H3 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h1 and h3
    S1Staticflow3 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh3","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.3","active":"true","actions":"output=3"}
    S1Staticflow4 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h3toh1","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.3",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define static flow for Switch S3 for packet forwarding b/w h1 and h3
    S3Staticflow1 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h3toh1","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.3",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=4"}
    S3Staticflow2 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh3","cookie":"0",
                    "priority":"1","in_port":"4","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.3","active":"true","actions":"output=1"}

    # Below 4 flows are for setting up the static forwarding for the path H2->S2->S3->H3 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h2 and h3
    S2Staticflow3 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh3","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.3","active":"true","actions":"output=3"}
    S2Staticflow4 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h3toh2","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.3",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Define static flow for Switch S3 for packet forwarding b/w h2 and h3
    S3Staticflow3 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h3toh2","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.3",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=5"}
    S3Staticflow4 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h2toh3","cookie":"0",
                    "priority":"1","in_port":"5","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.3","active":"true","actions":"output=1"}

    # Below 4 flows are for setting up the static forwarding for the path H1->S1->S3->H4 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h1 and h4
    S1Staticflow5 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh4","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.4","active":"true","actions":"output=3"}
    S1Staticflow6 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h4toh1","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.4",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define static flow for Switch S3 for packet forwarding b/w h1 and h4
    S3Staticflow5 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h4toh1","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=4"}
    S3Staticflow6 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh4","cookie":"0",
                    "priority":"1","in_port":"4","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}

    # Below 4 flows are for setting up the static forwarding for the path H2->S2->S3->H4 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h2 and h4
    S2Staticflow5 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh4","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.4","active":"true","actions":"output=3"}
    S2Staticflow6 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h4toh2","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.4",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Define static flow for Switch S3 for packet forwarding b/w h2 and h4
    S3Staticflow7 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h4toh2","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=5"}
    S3Staticflow8 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h2toh4","cookie":"0",
                    "priority":"1","in_port":"5","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}

    # Below 4 flows are for setting up the static forwarding for the path H1->S1->S3->H5 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h1 and h5
    S1Staticflow7 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh5","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}
    S1Staticflow8 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h5toh1","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Define static flow for Switch S3 for packet forwarding b/w h1 and h5
    S3Staticflow9 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h5toh1","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=4"}
    S3Staticflow10 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh5","cookie":"0",
                    "priority":"1","in_port":"4","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}

    # Below 4 flows are for setting up the static forwarding for the path H2->S2->S3->H5 & vice-versa
    # Define static flow for Switch S1 for packet forwarding b/w h2 and h5
    S2Staticflow7 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h2toh5","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}
    S2Staticflow8 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h5toh2","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Define static flow for Switch S3 for packet forwarding b/w h2 and h5
    S3Staticflow11 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h5toh2","cookie":"0",
                    "priority":"1","in_port":"3","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=5"}
    S3Staticflow12 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h2toh5","cookie":"0",
                    "priority":"1","in_port":"5","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=3"}

    #Now, Insert the flows to the switches
    pusher.set(S1Staticflow1)
    pusher.set(S1Staticflow2)
    pusher.set(S1Staticflow3)
    pusher.set(S1Staticflow4)
    pusher.set(S1Staticflow5)
    pusher.set(S1Staticflow6)
    pusher.set(S1Staticflow7)
    pusher.set(S1Staticflow8)

    pusher.set(S2Staticflow1)
    pusher.set(S2Staticflow2)
    pusher.set(S2Staticflow3)
    pusher.set(S2Staticflow4)
    pusher.set(S2Staticflow5)
    pusher.set(S2Staticflow6)
    pusher.set(S2Staticflow7)
    pusher.set(S2Staticflow8)

    pusher.set(S3Staticflow1)
    pusher.set(S3Staticflow2)
    pusher.set(S3Staticflow3)
    pusher.set(S3Staticflow4)
    pusher.set(S3Staticflow5)
    pusher.set(S3Staticflow6)
    pusher.set(S3Staticflow7)
    pusher.set(S3Staticflow8)
    pusher.set(S3Staticflow9)
    pusher.set(S3Staticflow10)
    pusher.set(S3Staticflow11)
    pusher.set(S3Staticflow12)

if __name__ =='__main__':
    staticForwarding()
    while True:
        print('LU between S1 and S3:'+str(automonitor.get_S1S3_monitor()[0]) + '; Drop rate between S1 and S3:'+ str(automonitor.get_S1S3_monitor()[1])
        print('LU between S1 and S2:'+str(automonitor.get_S1S2_monitor()[0]) + '; Drop rate between S1 and S2:'+ str(automonitor.get_S1S2_monitor()[1])
        if automonitor.get_S1S3_monitor()[1] > 0.05:
            print('We need change this static route with a dynamic route\n')
            set_H2toH5_dynamic()
            time.sleep(2)
        elif automonitor.get_S1S3_monitor()[0] < 0.3 and automonitor.get_S1S3_monitor()[1] <=0.05:
            Print('Static routing strategy is well, so there is no need to keep a dynamic route\n')
            remove_H2toH5_dynamic()
        time.sleep(1)