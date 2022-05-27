#!/usr/bin/python
"""
Topology of Organization with 3 switches:
- S1 connected to h1 (external traffic, Internet)
- S2 connected to h2 (internal traffic, NUSnet)
- S3 connected to h3, h4, and h5 (Internal hosts)

Controller is configured to run on Localhost with tcp port:5229
"""

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import CPULimitedHost
from mininet.link import TCLink
from mininet.util import dumpNodeConnections, custom, waitListening, decode
from mininet.log import setLogLevel, info
from mininet.node import OVSController
from mininet.cli import CLI
from mininet.node import Controller, OVSSwitch, RemoteController
import subprocess
from time import sleep
import os
from functools import partial

myBandwidth = 100
myDelay = '10ms'
myQueueSize = 1000
myLossPercentage = 0

class CustomTopo( Topo ):
    "CustomTopo as per Fig.1 of hw-2"
    
    def build(self):

        print "*** Creating switches"
        s1 = self.addSwitch( 'S1' )
        s2 = self.addSwitch( 'S2' )
        s3 = self.addSwitch( 'S3' )
    
        print "*** Creating hosts"
        h1 = self.addHost('h1');
        h2 = self.addHost('h2');
        h3 = self.addHost('h3');
        h4 = self.addHost('h4');
        h5 = self.addHost('h5');
    
        print "*** Creating links"
        self.addLink(s1, h1)
        self.addLink(s2, h2)
        self.addLink(s3, h3)
        self.addLink(s3, h4)
        self.addLink(s3, h5)
    
        self.addLink(s1,s2, bw=myBandwidth, delay=myDelay, 
            loss=myLossPercentage, max_queue_size=myQueueSize, use_htb=True)
        self.addLink(s1,s3, bw=myBandwidth, delay=myDelay, 
            loss=myLossPercentage, max_queue_size=myQueueSize, use_htb=True)
        self.addLink(s2,s3, bw=myBandwidth, delay=myDelay, 
            loss=myLossPercentage, max_queue_size=myQueueSize, use_htb=True)

def CustomNet():
    topo = CustomTopo()

    net = Mininet( topo=topo, host=CPULimitedHost, 
        link=TCLink, controller=None, switch=partial(OVSSwitch,protocols='OpenFlow13'))

    print "*** Adding controller. Make sure you run the controller at port 5229!!"
    net.addController( 'c0', controller=RemoteController, ip='127.0.0.1', port=5229 )
    
    print "*** Starting network"
    net.start()

    print "*** Running CLI"
    CLI( net )

    print "*** Stopping network"
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )  # for CLI output
    CustomNet()