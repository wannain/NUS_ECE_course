from mininet.topo import Topo
from mininet.net import Mininet
from mininet.node import CPULimitedHost
from mininet.link import TCLink
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel
from mininet.node import OVSController
from mininet.cli import CLI
from mininet.node import Controller, OVSSwitch, RemoteController
import subprocess
import os
from functools import partial


myBandwidth = 10
myDelay = '100ms'
myQueueSize = 1000
myLossPercentage = 0


class LineTopo( Topo ):
    "2 Switches connected to 2 hosts in a line topo."
    def build(self):
        print "*** Creating switches"
        s1 = self.addSwitch('S1')
        s2 = self.addSwitch('S2')
        print "*** Creating hosts"
        h1 = self.addHost('h1', mac='00:00:00:00:00:01');
        h2 = self.addHost('h2', mac='00:00:00:00:00:02');

        print "*** Creating links"
        self.addLink(s1, h1)
        self.addLink(s2, h2)
        self.addLink(s1,s2, bw=myBandwidth, delay=myDelay, 
            loss=myLossPercentage, max_queue_size=myQueueSize, use_htb=True)


def LineNet():
    topo = LineTopo()

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
    # Setup Queues in the switches
    LineNet()
