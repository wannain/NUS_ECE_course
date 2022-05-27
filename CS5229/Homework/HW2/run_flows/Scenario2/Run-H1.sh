#!/bin/bash
iperf3 -c 10.0.0.3 -t 300 &
iperf3 -c 10.0.0.4 -b 45M -t 300 -u &
iperf3 -c 10.0.0.5 -b 45M -t 300 -u