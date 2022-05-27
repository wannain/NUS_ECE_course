import httplib
import json


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

# To insert the policies for the traffic applicable to path between S1 and S2
def S1toS2():
    pass
# To insert the policies for the traffic applicable to path between S2 and S3
def S2toS3():        
    pass
# To insert the policies for the traffic applicable to path between S1 and S3
def S1toS3():
    pass


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


if __name__ =='__main__':
    staticForwarding()
    S1toS2()
    S2toS3()
    S1toS3()
    pass