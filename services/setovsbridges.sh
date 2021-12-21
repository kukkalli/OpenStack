#!/bin/bash
# create a file /etc/setovs/setovsbridges.sh with the below contents:

# Modify the IP address and bridges as per the need
ip addr add 10.11.0.21/16 dev brtuc11
ip link set brtuc11 up

ip addr add 10.10.0.21/16 dev brmgmt
ip link set brmgmt up

# modify the subnet as per the network
ip r add default via 10.10.0.1

# Add google (8.8.8.8 or 8.8.4.4) or some other nameserver (1.1.1.1)
echo 'nameserver 8.8.8.8' > /etc/resolv.conf


exit
