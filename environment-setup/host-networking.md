## Host networking
### Configure network interfaces
#### For persistence in netplan configuration, disable cloud config.
##### Create the file /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

```bash
network: {config: disabled}
```

#### Create or Edit the /etc/netplan/50-cloud-init.yaml file accordingly.
```bash
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}

network:
    version: 2
    ethernets:
        tuc11:
            match:
                macaddress: b4:96:91:29:16:f2
            set-name: tuc11
            mtu: 9000
            addresses:
            - 10.11.0.21/16

        mgmt:
            match:
                macaddress: d0:94:66:6e:29:b9
            set-name: mgmt
            mtu: 9000
            addresses:
            - 10.10.0.21/16
            gateway4: 10.10.0.1
            nameservers:
                addresses:
                - 8.8.8.8
                - 1.1.1.1
```

#### Set the configuration using netplan
```
# netplan apply
```

### Configure name resolution
Edit the /etc/hosts file to contain the following on all the nodes
```bash
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

10.10.0.10      sdnc

10.10.0.11      switch01
10.10.0.12      switch02
10.10.0.13      switch03
10.10.0.14      switch04

10.10.0.21      controller
10.10.0.31      compute01
10.10.0.32      compute02
```

