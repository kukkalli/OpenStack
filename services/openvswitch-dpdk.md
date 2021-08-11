## Install OpenVswitch-DPDK

### Install package
```
# apt install openvswitch-switch-dpdk
# ovs-vsctl set Open_vSwitch . "other_config:dpdk-init=true"

```run on core 0 only```
# ovs-vsctl set Open_vSwitch . "other_config:dpdk-lcore-mask=0x1"
```Allocate 2G huge pages (not Numa node aware)```
# ovs-vsctl set Open_vSwitch . "other_config:dpdk-alloc-mem=2048"
```limit to one whitelisted device```
# ovs-vsctl set Open_vSwitch . "other_config:dpdk-extra=--pci-whitelist=0000:04:00.0"
# service openvswitch-switch restart

```For copying```
apt install openvswitch-switch-dpdk -y

```For copying```
ovs-vsctl set Open_vSwitch . "other_config:dpdk-init=true"
ovs-vsctl set Open_vSwitch . "other_config:dpdk-lcore-mask=0x1"
ovs-vsctl set Open_vSwitch . "other_config:dpdk-alloc-mem=2048"
ovs-vsctl set Open_vSwitch . "other_config:dpdk-extra=--pci-whitelist=0000:04:00.0"
service openvswitch-switch restart
```

#### Verify installation
```
# ovs-vsctl get Open_vSwitch . "other_config"

```example output```
root@controller:~# ovs-vsctl get Open_vSwitch . "other_config"
{dpdk-alloc-mem="2048", dpdk-extra="--pci-whitelist=0000:04:00.0", dpdk-init="true", dpdk-lcore-mask="0x1"}
```

### Configure OvS interfaces bridges
All commands to be executed with sudo
```
```Create bridge and bind port```
ovs-vsctl add-br brtuc11
ovs-vsctl add-port brtuc11 tuc11

ovs-vsctl add-br brmgmt
ovs-vsctl add-port brmgmt mgmt

```IP Address reassignment on controller```
ip addr flush dev tuc11
ip addr add 10.11.0.21/16 dev brtuc11
ip link set brtuc11 up

ip addr flush dev mgmt
ip addr add 10.10.0.21/16 dev brmgmt
ip link set brmgmt up

```IP Address reassignment on compute01```
ip addr flush dev tuc11
ip addr add 10.11.0.31/16 dev brtuc11
ip link set brtuc11 up

ip addr flush dev mgmt
ip addr add 10.10.0.31/16 dev brmgmt
ip link set brmgmt up

```IP Address reassignment on compute02```
ip addr flush dev tuc11
ip addr add 10.11.0.32/16 dev brtuc11
ip link set brtuc11 up

ip addr flush dev mgmt
ip addr add 10.10.0.32/16 dev brmgmt
ip link set brmgmt up

```

### Verify OvS setup

```
# ovs-vsctl show

```example output```
root@controller:~# ovs-vsctl show
282fa74d-64de-447f-bcf5-89f459dc0c41
    Bridge "brtuc11"
        Port "brtuc11"
            Interface "brtuc11"
                type: internal
        Port "tuc11"
            Interface "tuc11"
    ovs_version: "2.12.0"

# networkctl list

```example output```
root@controller:~# networkctl list
IDX LINK             TYPE               OPERATIONAL SETUP
  1 lo               loopback           carrier     unmanaged
  2 eno1             ether              off         unmanaged
  3 eno2             ether              off         unmanaged
  4 mgmt             ether              routable    configured
  5 eno4             ether              off         unmanaged
  6 enp5s0f0         ether              off         unmanaged
  7 tuc11            ether              carrier     configured
 10 ovs-system       ether              off         unmanaged
 11 brtuc11          ether              routable    unmanaged

9 links listed.
```


[Neutron Home](neutron.md#neutron-networking-service)
[Next](controller/neutron.md#install-and-configure-controller-node)