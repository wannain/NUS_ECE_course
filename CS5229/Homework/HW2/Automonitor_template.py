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

    def rest_call(self, data, action, switch,statType):
        path = '/wm/core/switch/'+switch+"/"+statType+"/json"
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