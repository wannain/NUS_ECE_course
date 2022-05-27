#!/usr/bin/python

import httplib
import json
from time import sleep
import time

class flowStat(object):
    def __init__(self, server):
        self.server = server

    def get(self, switch,statType):
        ret,resTime = self.rest_call({}, 'GET', switch,statType)
        return json.loads(ret[2]),resTime
    
    def get_utilization(self, switch, port):
        ret,resTime = self.rest_call({}, 'GET', switch, port)
        return json.loads(ret[2]),resTime

    def get_S1S3LU(self):
        ret, _ = self.rest_call({}, 'GET', "00:00:00:00:00:00:00:01", "3")
        try:
            tx_throughput = json.loads(ret[2])[3]['bits-per-second-tx']
            percent = int(int(tx_throughput) / 1000000.0)
        except (KeyError, IndexError) as e:
            return -1
        return percent

    def get_S2S3LU(self):
        ret, _ = self.rest_call({}, 'GET', "00:00:00:00:00:00:00:02", "3")
        try:
            tx_throughput = json.loads(ret[2])[3]['bits-per-second-tx']
            percent = int(int(tx_throughput) / 1000000.0)
        except (KeyError, IndexError) as e:
            return -1
        return percent

    def get_S1S3Drops(self):
        ret, _ = self.rest_call({}, 'GET', "00:00:00:00:00:00:00:01", "3")
        switch_rec = json.loads(ret[2])
        try:
            rx_port1 = switch_rec[1]['bits-per-second-rx']
            tx_port3 = switch_rec[3]['bits-per-second-tx']
            rate = int((float(rx_port1) - float(tx_port3)) / float(rx_port1) * 100)
        except (KeyError, IndexError, ZeroDivisionError) as e:
            return -1
        return rate

    def get_S2S3Drops(self):
        ret, _ = self.rest_call({}, 'GET', "00:00:00:00:00:00:00:02", "3")
        switch_rec = json.loads(ret[2])
        try:
            rx_port1 = switch_rec[1]['bits-per-second-rx']
            tx_port3 = switch_rec[3]['bits-per-second-tx']
            rate = int((float(rx_port1) - float(tx_port3)) / float(rx_port1) * 100)
        except (KeyError, IndexError, ZeroDivisionError) as e:
            return -1
        return rate

    def get_H3BW(self):
        ret, _ = self.rest_call({}, 'GET', "00:00:00:00:00:00:00:03", "1")
        try:
            tx_throughput = json.loads(ret[2])[1]['bits-per-second-tx']
            h3_bandwidth = int(float(tx_throughput) / 1000000)
        except (KeyError, IndexError) as e:
            return -1
        return h3_bandwidth
    
    def rest_enable(self, data, action):
        path = '/wm/statistics/config/enable/json'
        headers = {
            'Content-type': 'text/plain',
            'Accept': 'application/json',
            }
        body = data
        conn = httplib.HTTPConnection(self.server, 8080)
        #print path
        conn.request(action, path, body, headers)
        response = conn.getresponse()
        ret = (response.status, response.reason, response.read())
        print(json.loads(ret[2]))
        conn.close()
        return
    
    def rest_call(self, data, action, switch,statType):
        path = '/wm/statistics/bandwidth/'+switch+"/"+statType+"/json"
        headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            }
        body = json.dumps(data)
        conn = httplib.HTTPConnection(self.server, 8080)
        #print path
        conn.request(action, path, body, headers)
        response = conn.getresponse()
        resTime = time.time()
        ret = (response.status, response.reason, response.read())
        conn.close()
        return ret,resTime

flowget = flowStat('127.0.0.1')
# curl http://127.0.0.1:8080/wm/statistics/config/enable/json -X POST -d ''

if __name__ == "__main__":
    flowget.rest_enable('', 'POST')
    while True:
        print(flowget.get("00:00:00:00:00:00:00:03", "1"))
        print(flowget.get_H3BW())