import httplib
import json
import time


class flowStat(object):
    def __init__(self, server):
        self.server = server

    def get(self, switch):
        ret = self.rest_call({}, 'GET', switch)
        return json.loads(ret[2])

    def rest_call(self, data, action, switch):
        path = '/wm/core/switch/'+switch+"/flow/json"
        headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            }
        body = json.dumps(data)
        conn = httplib.HTTPConnection(self.server, 8080)
        #print path
        conn.request(action, path, body, headers)
        response = conn.getresponse()
        ret = (response.status, response.reason, response.read())
        conn.close()
        return ret

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

pusher = StaticFlowPusher('127.0.0.1')
flowget = flowStat('127.0.0.1')

# optional helper function for Rule #3
def Rule3Helper():
# Use this function to predict whether all the traffic have transfered 100MB
    cmd = "ovs-vsctl show"
    p = os.popen(cmd).read()
    if n_bytes> 104857600:
        return False
    else:
        return True

# To insert the policies for Rule #1
def Rule1():
    # Restrict all traffic between h3 and h6 to 1 Mbps
    H3S3_flow = {'switch': "00:00:00:00:00:00:00:03", "name": "H3S3", "cookie": "0","priority": "32767", "in_port": "3", "eth_type": "0x800","ipv4_src": "10.0.0.3","ipv4_dst": "10.0.0.6", "active": "true", "actions":"output=1, set_queue=1"}
    S3H3_flow = {'switch': "00:00:00:00:00:00:00:03", "name": "S3H3", "cookie": "0","priority": "32767", "in_port": "1", "eth_type": "0x800","ipv4_src": "10.0.0.6","ipv4_dst": "10.0.0.3", "active": "true", "actions":"output=3, set_queue=1"}
    H6S2_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "H6S2", "cookie": "0","priority": "32767", "in_port": "5", "eth_type": "0x800","ipv4_src": "10.0.0.6","ipv4_dst": "10.0.0.3", "active": "true", "actions":"output=1, set_queue=1"}
    S2H6_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "S2H6", "cookie": "0","priority": "32767", "in_port": "1", "eth_type": "0x800","ipv4_src": "10.0.0.3","ipv4_dst": "10.0.0.6", "active": "true", "actions":"output=5, set_queue=1"}
    pusher.set(H3S3_flow)
    pusher.set(S3H3_flow)
    pusher.set(H6S2_flow)
    pusher.set(S2H6_flow)



# To insert the policies for Rule #2
def Rule2():        
# Block all traffic using destination UDP ports from 1000-1100 (ends inclusive) between h2 and h4
    H2S1_flow = {'switch': "00:00:00:00:00:00:00:01", "name": "H2S1", "cookie": "0","priority": "32767", "in_port": "4", "eth_type": "0x800","ipv4_src": "10.0.0.2","ipv4_dst": "10.0.0.4", "active": "true", "actions":"output=1000:1101"}
    S1H2_flow = {'switch': "00:00:00:00:00:00:00:01", "name": "S1H2", "cookie": "0","priority": "32767", "in_port": "1", "eth_type": "0x800","ipv4_src": "10.0.0.4","ipv4_dst": "10.0.0.2", "active": "true", "actions":"output=1000:1101"}
    H4S2_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "H4S2", "cookie": "0","priority": "32767", "in_port": "3", "eth_type": "0x800","ipv4_src": "10.0.0.4","ipv4_dst": "10.0.0.2", "active": "true", "actions":"output=1000:1101"}
    S2H4_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "S2H4", "cookie": "0","priority": "32767", "in_port": "1", "eth_type": "0x800","ipv4_src": "10.0.0.2","ipv4_dst": "10.0.0.4", "active": "true", "actions":"output=1000:1101"}
    pusher.set(H2S1_flow)
    pusher.set(S1H2_flow)
    pusher.set(H4S2_flow)
    pusher.set(S2H4_flow)



# To insert the policies for Rule #3
def Rule3():
    #Allow only 100 MB to transfer between h1 and h5.
    start=time.time()
    while(Rule3Helper):
        H1S1_flow = {'switch': "00:00:00:00:00:00:00:01", "name": "H1S1", "cookie": "0","priority": "32767", "in_port": "3", "eth_type": "0x800","ipv4_src": "10.0.0.1","ipv4_dst": "10.0.0.5", "active": "true", "actions":"output=2"}
        S1H1_flow = {'switch': "00:00:00:00:00:00:00:01", "name": "S1H1", "cookie": "0","priority": "32767", "in_port": "2", "eth_type": "0x800","ipv4_src": "10.0.0.5","ipv4_dst": "10.0.0.1", "active": "true", "actions":"output=3"}
        H5S2_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "H5S2", "cookie": "0","priority": "32767", "in_port": "4", "eth_type": "0x800","ipv4_src": "10.0.0.5","ipv4_dst": "10.0.0.1", "active": "true", "actions":"output=2"}
        S2H5_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "S2H5", "cookie": "0","priority": "32767", "in_port": "2", "eth_type": "0x800","ipv4_src": "10.0.0.1","ipv4_dst": "10.0.0.5", "active": "true", "actions":"output=4"}
        pusher.set(H1S1_flow)
        pusher.set(S1H1_flow)
        pusher.set(H5S2_flow)
        pusher.set(S2H5_flow)
        end=time.time()
        time_count=end-start
        if time>100:
        	break
    
    H1S1_new_flow = {'switch': "00:00:00:00:00:00:00:01", "name": "H1S1", "cookie": "0","priority": "32767", "in_port": "3", "eth_type": "0x800","ipv4_src": "10.0.0.1","ipv4_dst": "10.0.0.5", "active": "true"}
    S1H1_new_flow = {'switch': "00:00:00:00:00:00:00:01", "name": "S1H1", "cookie": "0","priority": "32767", "in_port": "2", "eth_type": "0x800","ipv4_src": "10.0.0.5","ipv4_dst": "10.0.0.1", "active": "true"}
    H5S2_new_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "H5S2", "cookie": "0","priority": "32767", "in_port": "4", "eth_type": "0x800","ipv4_src": "10.0.0.5","ipv4_dst": "10.0.0.1", "active": "true"}
    S2H5_new_flow = {'switch': "00:00:00:00:00:00:00:02", "name": "S2H5", "cookie": "0","priority": "32767", "in_port": "2", "eth_type": "0x800","ipv4_src": "10.0.0.1","ipv4_dst": "10.0.0.5", "active": "true"}
    pusher.set(H1S1_new_flow)
    pusher.set(S1H1_new_flow)
    pusher.set(H5S2_new_flow)
    pusher.set(S2H5_new_flow)


def staticForwarding():
    # The lines below set a static route for the flow between h3 and h6. Note
    # that since traffci travels both ways, you will need to set 2 forwarding 
    # rules on each switch on the path.

    # Path between h3 and h6
    # Routes on Switch S3:
    S3Staticflow1 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h3toh6","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.3",
                    "ipv4_dst":"10.0.0.6","active":"true","actions":"output=2"}
    S3Staticflow2 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h6toh3","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.6",
                    "ipv4_dst":"10.0.0.3","active":"true","actions":"output=1"}
    # Routes on Switch S2:
    S2Staticflow1 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h3toh6","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.3",
                    "ipv4_dst":"10.0.0.6","active":"true","actions":"output=2"}
    S2Staticflow2 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h6toh3","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.6",
                    "ipv4_dst":"10.0.0.3","active":"true","actions":"output=1"}

    #Now, Insert the flows to the switches
    pusher.set(S3Staticflow1)
    pusher.set(S3Staticflow2)
    pusher.set(S2Staticflow1)
    pusher.set(S2Staticflow2)

    	# Path between h1 and h5
    # Routes on Switch S1:
    S1Staticflow3 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h1toh5","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=2"}
    S1Staticflow4 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h5toh1","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Routes on Switch S3:
    S3Staticflow3 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h1toh5","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=2"}
    S3Staticflow4 = {'switch':"00:00:00:00:00:00:00:03","name":"S3h5toh1","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    # Routes on Switch S2:
    S2Staticflow3 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h1toh5","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.1",
                    "ipv4_dst":"10.0.0.5","active":"true","actions":"output=2"}
    S2Staticflow4 = {'switch':"00:00:00:00:00:00:00:02","name":"S2h6toh3","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.5",
                    "ipv4_dst":"10.0.0.1","active":"true","actions":"output=1"}
    #Now, Insert the flows to the switches
    pusher.set(S1Staticflow3)
    pusher.set(S1Staticflow4)
    pusher.set(S3Staticflow3)
    pusher.set(S3Staticflow4)
    pusher.set(S2Staticflow3)
    pusher.set(S2Staticflow4)
    
    
    
    # Path between h2 and h4
    # Routes on Switch S1:
    S1Staticflow5 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h2toh4","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}
    S1Staticflow6 = {'switch':"00:00:00:00:00:00:00:01","name":"S1h4toh2","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}
    # Routes on Switch S2:
    S2Staticflow5 = {'switch':"00:00:00:00:00:00:00:02","name":"S1h2toh4","cookie":"0",
                    "priority":"1","in_port":"1","eth_type":"0x800","ipv4_src":"10.0.0.2",
                    "ipv4_dst":"10.0.0.4","active":"true","actions":"output=2"}
    S2Staticflow6 = {'switch':"00:00:00:00:00:00:00:02","name":"S1h4toh2","cookie":"0",
                    "priority":"1","in_port":"2","eth_type":"0x800","ipv4_src":"10.0.0.4",
                    "ipv4_dst":"10.0.0.2","active":"true","actions":"output=1"}

    #Now, Insert the flows to the switches
    pusher.set(S1Staticflow5)
    pusher.set(S1Staticflow6)
    pusher.set(S2Staticflow5)
    pusher.set(S2Staticflow6)


if __name__ =='__main__':
    staticForwarding()
    Rule1()
    Rule2()
    Rule3()
    pass