#!/bin/bash
# Monitor TCP traffic on eth0 interface

INTERFACE="eth0"
LOGFILE="/app/logs/traffic_monitor.log"

tcpdump -i $INTERFACE tcp > $LOGFILE &
echo "Monitoring started on interface $INTERFACE, logging to $LOGFILE"
