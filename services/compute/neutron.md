## Install and configure Compute node

### Configure networking options:
- Networking Option 1: Provider networks
### Install and configure
- Install the packages:
```
# apt install neutron-openvswitch-agent neutron-dhcp-agent neutron-metadata-agent
```

- Edit the ```/etc/neutron/neutron.conf``` file and complete the following actions:
```bash
[DEFAULT]
auth_strategy = keystone
core_plugin = ml2
service_plugins = router,metering
allow_overlapping_ips = true
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
global_physnet_mtu = 9000
dhcp_agents_per_network = 2
transport_url = rabbit://openstack:tuckn2020@10.10.0.21

[agent]
root_helper = "sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf"

[cors]
[database]
connection = mysql+pymysql://neutron:tuckn2020@10.10.0.21/neutron

[ironic]
[keystone_authtoken]
www_authenticate_uri = http://10.10.0.21:5000
auth_url = http://10.10.0.21:5000
memcached_servers = 10.10.0.21:11211
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
project_name = service
username = neutron
password = tuckn2020

[nova]
auth_url = http://10.10.0.21:5000
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
region_name = TUCKN
project_name = service
username = nova
password = tuckn2020

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[privsep]
[quotas]
[ssl]
```
The updated ```neutron.conf``` file can be found at: [neutron.conf](neutron.conf)

### Configure the OpenVswitch bridge agent
- Edit the ```/etc/neutron/plugins/ml2/openvswitch_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
[agent]
tunnel_types = vxlan
veth_mtu = 9000
l2_population = True

[network_log]
[ovs]
local_ip = 10.10.0.31
bridge_mappings = tuc11:brtuc11

[securitygroup]
firewall_driver = iptables_hybrid
enable_security_group = true

[xenapi]
```
The updated ```openvswitch_agent.ini``` file can be found at: [openvswitch_agent.ini](openvswitch_agent.ini)

### Configure the DHCP agent
- Edit the ```/etc/neutron/dhcp_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
interface_driver = openvswitch
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True

[agent]
[ovs]
```
The updated ```dhcp_agent.ini``` file can be found at: [dhcp_agent.ini](dhcp_agent.ini)

### Configure the matadata agent
- Edit the ```/etc/neutron/metadata_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
nova_metadata_host = 10.10.0.21
metadata_proxy_shared_secret = tuckn2020

[agent]
[cache]```
The updated ```metadata_agent.ini``` file can be found at: [metadata_agent.ini](metadata_agent.ini)

### Restart services

```
# service neutron-openvswitch-agent restart
```

### Verify Networking
- Source the ```admin``` credentials
```
$ . admin-openrc
```
- List loaded extensions to verify successful launch of the neutron-server process:
```
$ openstack extension list --network

```example output:```
os@controller:~$ openstack extension list --network
+----------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Name                                                                                                                                                           | Alias                                 | Description                                                                                                                                              |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Address scope                                                                                                                                                  | address-scope                         | Address scopes extension.                                                                                                                                |
| Enforce Router's Admin State Down Before Update Extension                                                                                                      | router-admin-state-down-before-update | Ensure that the admin state of a router is down (admin_state_up=False) before updating the distributed attribute                                         |
| agent                                                                                                                                                          | agent                                 | The agent management extension.                                                                                                                          |
| Agent's Resource View Synced to Placement                                                                                                                      | agent-resources-synced                | Stores success/failure of last sync to Placement                                                                                                         |
| Allowed Address Pairs                                                                                                                                          | allowed-address-pairs                 | Provides allowed address pairs                                                                                                                           |
| Auto Allocated Topology Services                                                                                                                               | auto-allocated-topology               | Auto Allocated Topology Services.                                                                                                                        |
| Availability Zone                                                                                                                                              | availability_zone                     | The availability zone extension.                                                                                                                         |
| Availability Zone Filter Extension                                                                                                                             | availability_zone_filter              | Add filter parameters to AvailabilityZone resource                                                                                                       |
| Default Subnetpools                                                                                                                                            | default-subnetpools                   | Provides ability to mark and use a subnetpool as the default.                                                                                            |
| DHCP Agent Scheduler                                                                                                                                           | dhcp_agent_scheduler                  | Schedule networks among dhcp agents                                                                                                                      |
| Distributed Virtual Router                                                                                                                                     | dvr                                   | Enables configuration of Distributed Virtual Routers.                                                                                                    |
| Empty String Filtering Extension                                                                                                                               | empty-string-filtering                | Allow filtering by attributes with empty string value                                                                                                    |
| Neutron external network                                                                                                                                       | external-net                          | Adds external network attribute to network resource.                                                                                                     |
| Neutron Extra DHCP options                                                                                                                                     | extra_dhcp_opt                        | Extra options configuration for DHCP. For example PXE boot options to DHCP clients can be specified (e.g. tftp-server, server-ip-address, bootfile-name) |
| Neutron Extra Route                                                                                                                                            | extraroute                            | Extra routes configuration for L3 router                                                                                                                 |
| Atomically add/remove extra routes                                                                                                                             | extraroute-atomic                     | Edit extra routes of a router on server side by atomically adding/removing extra routes                                                                  |
| Filter parameters validation                                                                                                                                   | filter-validation                     | Provides validation on filter parameters.                                                                                                                |
| Floating IP Port Details Extension                                                                                                                             | fip-port-details                      | Add port_details attribute to Floating IP resource                                                                                                       |
| Neutron Service Flavors                                                                                                                                        | flavors                               | Flavor specification for Neutron advanced services.                                                                                                      |
| Floating IP Pools Extension                                                                                                                                    | floatingip-pools                      | Provides a floating IP pools API.                                                                                                                        |
| IP address substring filtering                                                                                                                                 | ip-substring-filtering                | Provides IP address substring filtering when listing ports                                                                                               |
| Neutron L3 Router                                                                                                                                              | router                                | Router abstraction for basic L3 forwarding between L2 Neutron networks and access to external networks via a NAT gateway.                                |
| Neutron L3 Configurable external gateway mode                                                                                                                  | ext-gw-mode                           | Extension of the router abstraction for specifying whether SNAT should occur on the external gateway                                                     |
| HA Router extension                                                                                                                                            | l3-ha                                 | Adds HA capability to routers.                                                                                                                           |
| Router Flavor Extension                                                                                                                                        | l3-flavors                            | Flavor support for routers.                                                                                                                              |
| Prevent L3 router ports IP address change extension                                                                                                            | l3-port-ip-change-not-allowed         | Prevent change of IP address for some L3 router ports                                                                                                    |
| L3 Agent Scheduler                                                                                                                                             | l3_agent_scheduler                    | Schedule routers among l3 agents                                                                                                                         |
| Neutron Metering                                                                                                                                               | metering                              | Neutron Metering extension.                                                                                                                              |
| Multi Provider Network                                                                                                                                         | multi-provider                        | Expose mapping of virtual networks to multiple physical networks                                                                                         |
| Network MTU                                                                                                                                                    | net-mtu                               | Provides MTU attribute for a network resource.                                                                                                           |
| Network MTU (writable)                                                                                                                                         | net-mtu-writable                      | Provides a writable MTU attribute for a network resource.                                                                                                |
| Network Availability Zone                                                                                                                                      | network_availability_zone             | Availability zone support for network.                                                                                                                   |
| Network IP Availability                                                                                                                                        | network-ip-availability               | Provides IP availability data for each network and subnet.                                                                                               |
| Pagination support                                                                                                                                             | pagination                            | Extension that indicates that pagination is enabled.                                                                                                     |
| Neutron Port MAC address regenerate                                                                                                                            | port-mac-address-regenerate           | Network port MAC address regenerate                                                                                                                      |
| Port Binding                                                                                                                                                   | binding                               | Expose port bindings of a virtual port to external application                                                                                           |
| Port Bindings Extended                                                                                                                                         | binding-extended                      | Expose port bindings of a virtual port to external application                                                                                           |
| Port Security                                                                                                                                                  | port-security                         | Provides port security                                                                                                                                   |
| project_id field enabled                                                                                                                                       | project-id                            | Extension that indicates that project_id field is enabled.                                                                                               |
| Provider Network                                                                                                                                               | provider                              | Expose mapping of virtual networks to physical networks                                                                                                  |
| Quota management support                                                                                                                                       | quotas                                | Expose functions for quotas management per tenant                                                                                                        |
| Quota details management support                                                                                                                               | quota_details                         | Expose functions for quotas usage statistics per project                                                                                                 |
| RBAC Policies                                                                                                                                                  | rbac-policies                         | Allows creation and modification of policies that control tenant access to resources.                                                                    |
| Add security_group type to network RBAC                                                                                                                        | rbac-security-groups                  | Add security_group type to network RBAC                                                                                                                  |
| If-Match constraints based on revision_number                                                                                                                  | revision-if-match                     | Extension indicating that If-Match based on revision_number is supported.                                                                                |
| Resource revision numbers                                                                                                                                      | standard-attr-revisions               | This extension will display the revision number of neutron resources.                                                                                    |
| Router Availability Zone                                                                                                                                       | router_availability_zone              | Availability zone support for router.                                                                                                                    |
| Port filtering on security groups                                                                                                                              | port-security-groups-filtering        | Provides security groups filtering when listing ports                                                                                                    |
| security-group                                                                                                                                                 | security-group                        | The security groups extension.                                                                                                                           |
| Neutron Service Type Management                                                                                                                                | service-type                          | API for retrieving service providers for Neutron advanced services                                                                                       |
| Sorting support                                                                                                                                                | sorting                               | Extension that indicates that sorting is enabled.                                                                                                        |
| standard-attr-description                                                                                                                                      | standard-attr-description             | Extension to add descriptions to standard attributes                                                                                                     |
| Subnet Onboard                                                                                                                                                 | subnet_onboard                        | Provides support for onboarding subnets into subnet pools                                                                                                |
| Subnet service types                                                                                                                                           | subnet-service-types                  | Provides ability to set the subnet service_types field                                                                                                   |
| Subnet Allocation                                                                                                                                              | subnet_allocation                     | Enables allocation of subnets from a subnet pool                                                                                                         |
| Subnet Pool Prefix Operations                                                                                                                                  | subnetpool-prefix-ops                 | Provides support for adjusting the prefix list of subnet pools                                                                                           |
| Tag support for resources with standard attribute: port, subnet, subnetpool, network, router, floatingip, policy, security_group, trunk, network_segment_range | standard-attr-tag                     | Enables to set tag on resources with standard attribute.                                                                                                 |
| Resource timestamps                                                                                                                                            | standard-attr-timestamp               | Adds created_at and updated_at fields to all Neutron resources that have Neutron standard attributes.                                                    |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
```
- List service components to verify successful launch and registration of each process:
```
$ openstack network agent list --sort-column Host --sort-column Binary

```example output:```
os@controller:~$ openstack network agent list --sort-column Host --sort-column Binary
+--------------------------------------+--------------------+--------------------------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host                           | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+--------------------------------+-------------------+-------+-------+---------------------------+
| da4e6fff-ac13-4dc0-a1a4-3b9c39c1f625 | DHCP agent         | compute01.etit.tu-chemnitz.de  | nova              | :-)   | UP    | neutron-dhcp-agent        |
| 055bd332-c5ea-4a5c-8e75-fe11a6d65425 | Metadata agent     | compute01.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-metadata-agent    |
| 11690603-1c1c-4b0e-8767-5ded9223dbc8 | Open vSwitch agent | compute01.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-openvswitch-agent |
| 74dcb9f8-1854-4ee5-ac0b-c3cac0a9e12a | DHCP agent         | compute02.etit.tu-chemnitz.de  | nova              | :-)   | UP    | neutron-dhcp-agent        |
| cde690aa-452e-452e-a046-1541db0b701f | Metadata agent     | compute02.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-metadata-agent    |
| f9b98a4f-e336-446e-af77-525a628f0791 | Open vSwitch agent | compute02.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-openvswitch-agent |
| 56b8d46e-c2b4-4bd6-9403-d639e3f47b21 | L3 agent           | controller.etit.tu-chemnitz.de | nova              | :-)   | UP    | neutron-l3-agent          |
| 2adc0853-bd0a-4457-a8bd-57129a84f5c7 | Metadata agent     | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-metadata-agent    |
| ba922131-8d42-4b8a-a654-7e34311dee5c | Open vSwitch agent | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-openvswitch-agent |
+--------------------------------------+--------------------+--------------------------------+-------------------+-------+-------+---------------------------+
```

### Create initial networks
```
$ openstack network create --share --provider-physical-network tuc11 --provider-network-type flat "TUC11-Network"

```example output:```
os@controller:~$ openstack network create --share --provider-physical-network tuc11 --provider-network-type flat "TUC11-Network"
+---------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                     | Value                                                                                                                                               |
+---------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up            | UP                                                                                                                                                  |
| availability_zone_hints   |                                                                                                                                                     |
| availability_zones        |                                                                                                                                                     |
| created_at                | 2020-11-30T08:56:38Z                                                                                                                                |
| description               |                                                                                                                                                     |
| dns_domain                | None                                                                                                                                                |
| id                        | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                                                                |
| ipv4_address_scope        | None                                                                                                                                                |
| ipv6_address_scope        | None                                                                                                                                                |
| is_default                | False                                                                                                                                               |
| is_vlan_transparent       | None                                                                                                                                                |
| location                  | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| mtu                       | 9000                                                                                                                                                |
| name                      | TUC11-Network                                                                                                                                       |
| port_security_enabled     | True                                                                                                                                                |
| project_id                | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| provider:network_type     | flat                                                                                                                                                |
| provider:physical_network | tuc11                                                                                                                                               |
| provider:segmentation_id  | None                                                                                                                                                |
| qos_policy_id             | None                                                                                                                                                |
| revision_number           | 1                                                                                                                                                   |
| router:external           | Internal                                                                                                                                            |
| segments                  | None                                                                                                                                                |
| shared                    | True                                                                                                                                                |
| status                    | ACTIVE                                                                                                                                              |
| subnets                   |                                                                                                                                                     |
| tags                      |                                                                                                                                                     |
| updated_at                | 2020-11-30T08:56:39Z                                                                                                                                |
+---------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```

### Create a IPv4 subnet on the provider network.

```
$ openstack subnet create --subnet-range 10.11.1.0/16 --gateway 10.11.0.1 --network TUC11-Network --allocation-pool start=10.11.1.0,end=10.11.2.255 --dns-nameserver 1.1.1.1 --dns-nameserver 8.8.8.8 TUC-Subnet-v4

```example output:```
os@controller:~$ openstack subnet create --subnet-range 10.11.1.0/16 --gateway 10.11.0.1 --network TUC11-Network --allocation-pool start=10.11.1.0,end=10.11.2.255 --dns-nameserver 1.1.1.1 --dns-nameserver 8.8.8.8 TUC-Subnet-v4
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| allocation_pools  | 10.11.1.0-10.11.2.255                                                                                                                               |
| cidr              | 10.11.0.0/16                                                                                                                                        |
| created_at        | 2020-11-30T08:57:48Z                                                                                                                                |
| description       |                                                                                                                                                     |
| dns_nameservers   | 1.1.1.1, 8.8.8.8                                                                                                                                    |
| enable_dhcp       | True                                                                                                                                                |
| gateway_ip        | 10.11.0.1                                                                                                                                           |
| host_routes       |                                                                                                                                                     |
| id                | fd23cb2b-24b2-442e-91e4-ffc3ff4e4208                                                                                                                |
| ip_version        | 4                                                                                                                                                   |
| ipv6_address_mode | None                                                                                                                                                |
| ipv6_ra_mode      | None                                                                                                                                                |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | TUC-Subnet-v4                                                                                                                                       |
| network_id        | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                                                                |
| prefix_length     | None                                                                                                                                                |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| revision_number   | 0                                                                                                                                                   |
| segment_id        | None                                                                                                                                                |
| service_types     |                                                                                                                                                     |
| subnetpool_id     | None                                                                                                                                                |
| tags              |                                                                                                                                                     |
| updated_at        | 2020-11-30T08:57:48Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```

#### Check the IPv4 HA-DHCP ports on provider network.
```
os@controller:~$ openstack port list
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------+--------+
| ID                                   | Name | MAC Address       | Fixed IP Addresses                                                       | Status |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------+--------+
| 1d22605f-3354-48ed-9e2c-8e71804a7a94 |      | fa:16:3e:c3:3d:66 | ip_address='10.11.1.1', subnet_id='fd23cb2b-24b2-442e-91e4-ffc3ff4e4208' | ACTIVE |
| 2b21b9e0-554e-42c5-ab83-729533e462a4 |      | fa:16:3e:73:02:7e | ip_address='10.11.1.0', subnet_id='fd23cb2b-24b2-442e-91e4-ffc3ff4e4208' | ACTIVE |
+--------------------------------------+------+-------------------+--------------------------------------------------------------------------+--------+
```

#### Verify network operation
- On each compute node, verify creation of the qdhcp namespace.
```
# ip netns

```example output:```
# On compute01
root@compute01:~# ip netns
qdhcp-9e373e2c-0372-4a06-81a1-bc1cb4c62b85 (id: 0)

root@compute01:~# ip netns exec qdhcp-9e373e2c-0372-4a06-81a1-bc1cb4c62b85 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
17: tap2b21b9e0-55: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether fa:16:3e:73:02:7e brd ff:ff:ff:ff:ff:ff
    inet 169.254.169.254/16 brd 169.254.255.255 scope global tap2b21b9e0-55
       valid_lft forever preferred_lft forever
    inet 10.11.1.0/16 brd 10.11.255.255 scope global tap2b21b9e0-55
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fe73:27e/64 scope link
       valid_lft forever preferred_lft forever

# On compute02
root@compute02:~# ip netns
qdhcp-9e373e2c-0372-4a06-81a1-bc1cb4c62b85 (id: 0)

root@compute02:~# ip netns exec qdhcp-9e373e2c-0372-4a06-81a1-bc1cb4c62b85 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
14: tap1d22605f-33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether fa:16:3e:c3:3d:66 brd ff:ff:ff:ff:ff:ff
    inet 169.254.169.254/16 brd 169.254.255.255 scope global tap1d22605f-33
       valid_lft forever preferred_lft forever
    inet 10.11.1.1/16 brd 10.11.255.255 scope global tap1d22605f-33
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fec3:3d66/64 scope link
       valid_lft forever preferred_lft forever       
```

### Create a IPv6 subnet on the provider network.

```
$ openstack subnet create --subnet-range fe80::/64 --ip-version 6 --ipv6-ra-mode slaac --ipv6-address-mode slaac --network TUC11-Network --dns-nameserver 2001:4860:4860::8844 TUC-Subnet-v6

```example output:```
os@controller:~$ openstack subnet create --subnet-range fe80::/64 --ip-version 6 --ipv6-ra-mode slaac --ipv6-address-mode slaac --network TUC11-Network --dns-nameserver 2001:4860:4860::8844 TUC-Subnet-v6
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| allocation_pools  | fe80::2-fe80::ffff:ffff:ffff:ffff                                                                                                                   |
| cidr              | fe80::/64                                                                                                                                           |
| created_at        | 2020-11-30T09:09:52Z                                                                                                                                |
| description       |                                                                                                                                                     |
| dns_nameservers   | 2001:4860:4860::8844                                                                                                                                |
| enable_dhcp       | True                                                                                                                                                |
| gateway_ip        | fe80::1                                                                                                                                             |
| host_routes       |                                                                                                                                                     |
| id                | d0858e4f-0747-42ce-bf85-41271c01c6ef                                                                                                                |
| ip_version        | 6                                                                                                                                                   |
| ipv6_address_mode | slaac                                                                                                                                               |
| ipv6_ra_mode      | slaac                                                                                                                                               |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | TUC-Subnet-v6                                                                                                                                       |
| network_id        | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                                                                |
| prefix_length     | None                                                                                                                                                |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| revision_number   | 0                                                                                                                                                   |
| segment_id        | None                                                                                                                                                |
| service_types     |                                                                                                                                                     |
| subnetpool_id     | None                                                                                                                                                |
| tags              |                                                                                                                                                     |
| updated_at        | 2020-11-30T09:09:52Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```


- Create the appropriate security group rules to allow ping and SSH access instances using the network.
```
$ openstack security group rule create --proto icmp default

```example output:```
os@controller:~$ openstack security group rule create --proto icmp default
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| created_at        | 2020-11-30T09:11:37Z                                                                                                                                |
| description       |                                                                                                                                                     |
| direction         | ingress                                                                                                                                             |
| ether_type        | IPv4                                                                                                                                                |
| id                | 29d7dad4-3c9c-4de5-b90b-b5b6d7ce4594                                                                                                                |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | None                                                                                                                                                |
| port_range_max    | None                                                                                                                                                |
| port_range_min    | None                                                                                                                                                |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| protocol          | icmp                                                                                                                                                |
| remote_group_id   | None                                                                                                                                                |
| remote_ip_prefix  | 0.0.0.0/0                                                                                                                                           |
| revision_number   | 0                                                                                                                                                   |
| security_group_id | ef249e36-3cf8-4ca5-a6ea-45107f4d5491                                                                                                                |
| tags              | []                                                                                                                                                  |
| updated_at        | 2020-11-30T09:11:37Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+


$ openstack security group rule create --ethertype IPv6 --proto ipv6-icmp default

```example output:```
os@controller:~$ openstack security group rule create --ethertype IPv6 --proto ipv6-icmp default
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| created_at        | 2020-11-30T10:06:35Z                                                                                                                                |
| description       |                                                                                                                                                     |
| direction         | ingress                                                                                                                                             |
| ether_type        | IPv6                                                                                                                                                |
| id                | c4bab75a-c046-4286-aa63-a54d2a6ffdc6                                                                                                                |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | None                                                                                                                                                |
| port_range_max    | None                                                                                                                                                |
| port_range_min    | None                                                                                                                                                |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| protocol          | ipv6-icmp                                                                                                                                           |
| remote_group_id   | None                                                                                                                                                |
| remote_ip_prefix  | ::/0                                                                                                                                                |
| revision_number   | 0                                                                                                                                                   |
| security_group_id | ef249e36-3cf8-4ca5-a6ea-45107f4d5491                                                                                                                |
| tags              | []                                                                                                                                                  |
| updated_at        | 2020-11-30T10:06:35Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+


$ openstack security group rule create --proto tcp --dst-port 22 default

```example output:```
os@controller:~$ openstack security group rule create --proto tcp --dst-port 22 default
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| created_at        | 2020-11-30T10:04:11Z                                                                                                                                |
| description       |                                                                                                                                                     |
| direction         | ingress                                                                                                                                             |
| ether_type        | IPv4                                                                                                                                                |
| id                | f96bccf5-640f-40a2-944d-472e90a4ed80                                                                                                                |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | None                                                                                                                                                |
| port_range_max    | 22                                                                                                                                                  |
| port_range_min    | 22                                                                                                                                                  |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| protocol          | tcp                                                                                                                                                 |
| remote_group_id   | None                                                                                                                                                |
| remote_ip_prefix  | 0.0.0.0/0                                                                                                                                           |
| revision_number   | 0                                                                                                                                                   |
| security_group_id | ef249e36-3cf8-4ca5-a6ea-45107f4d5491                                                                                                                |
| tags              | []                                                                                                                                                  |
| updated_at        | 2020-11-30T10:04:11Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+


$ openstack security group rule create --ethertype IPv6 --proto tcp --dst-port 22 default

```example output:```
os@controller:~$ openstack security group rule create --ethertype IPv6 --proto tcp --dst-port 22 default
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                               |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| created_at        | 2020-11-30T10:07:34Z                                                                                                                                |
| description       |                                                                                                                                                     |
| direction         | ingress                                                                                                                                             |
| ether_type        | IPv6                                                                                                                                                |
| id                | 2d2f8a1c-c323-4ede-a5db-bf592af5258e                                                                                                                |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | None                                                                                                                                                |
| port_range_max    | 22                                                                                                                                                  |
| port_range_min    | 22                                                                                                                                                  |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| protocol          | tcp                                                                                                                                                 |
| remote_group_id   | None                                                                                                                                                |
| remote_ip_prefix  | ::/0                                                                                                                                                |
| revision_number   | 0                                                                                                                                                   |
| security_group_id | ef249e36-3cf8-4ca5-a6ea-45107f4d5491                                                                                                                |
| tags              | []                                                                                                                                                  |
| updated_at        | 2020-11-30T10:07:34Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```

- Show all networks
```
os@controller:~$ openstack network list
+--------------------------------------+---------------+----------------------------------------------------------------------------+
| ID                                   | Name          | Subnets                                                                    |
+--------------------------------------+---------------+----------------------------------------------------------------------------+
| 9e373e2c-0372-4a06-81a1-bc1cb4c62b85 | TUC11-Network | d0858e4f-0747-42ce-bf85-41271c01c6ef, fd23cb2b-24b2-442e-91e4-ffc3ff4e4208 |
+--------------------------------------+---------------+----------------------------------------------------------------------------+
```

- Show all subnets
```
os@controller:~$ openstack subnet list
+--------------------------------------+---------------+--------------------------------------+--------------+
| ID                                   | Name          | Network                              | Subnet       |
+--------------------------------------+---------------+--------------------------------------+--------------+
| d0858e4f-0747-42ce-bf85-41271c01c6ef | TUC-Subnet-v6 | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85 | fe80::/64    |
| fd23cb2b-24b2-442e-91e4-ffc3ff4e4208 | TUC-Subnet-v4 | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85 | 10.11.0.0/16 |
+--------------------------------------+---------------+--------------------------------------+--------------+
```

- Show all ports
```
os@controller:~$ openstack port list
+--------------------------------------+------+-------------------+------------------------------------------------------------------------------------------+--------+
| ID                                   | Name | MAC Address       | Fixed IP Addresses                                                                       | Status |
+--------------------------------------+------+-------------------+------------------------------------------------------------------------------------------+--------+
| 1d22605f-3354-48ed-9e2c-8e71804a7a94 |      | fa:16:3e:c3:3d:66 | ip_address='10.11.1.1', subnet_id='fd23cb2b-24b2-442e-91e4-ffc3ff4e4208'                 | ACTIVE |
|                                      |      |                   | ip_address='fe80::f816:3eff:fec3:3d66', subnet_id='d0858e4f-0747-42ce-bf85-41271c01c6ef' |        |
| 2b21b9e0-554e-42c5-ab83-729533e462a4 |      | fa:16:3e:73:02:7e | ip_address='10.11.1.0', subnet_id='fd23cb2b-24b2-442e-91e4-ffc3ff4e4208'                 | ACTIVE |
|                                      |      |                   | ip_address='fe80::f816:3eff:fe73:27e', subnet_id='d0858e4f-0747-42ce-bf85-41271c01c6ef'  |        |
+--------------------------------------+------+-------------------+------------------------------------------------------------------------------------------+--------+
```

- Ping IPv6 address on the DHCP port
```
ping6 -I brtuc11 fe80::f816:3eff:fe2c:d8d7
```

- DHCP Port details
```
os@controller:~$ openstack port show 2b21b9e0-554e-42c5-ab83-729533e462a4
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                   | Value                                                                                                                                               |
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up          | UP                                                                                                                                                  |
| allowed_address_pairs   |                                                                                                                                                     |
| binding_host_id         | compute01.etit.tu-chemnitz.de                                                                                                                       |
| binding_profile         |                                                                                                                                                     |
| binding_vif_details     | bridge_name='br-int', connectivity='l2', datapath_type='system', ovs_hybrid_plug='True', port_filter='True'                                         |
| binding_vif_type        | ovs                                                                                                                                                 |
| binding_vnic_type       | normal                                                                                                                                              |
| created_at              | 2020-11-30T08:57:49Z                                                                                                                                |
| data_plane_status       | None                                                                                                                                                |
| description             |                                                                                                                                                     |
| device_id               | dhcpc3be5b02-3df7-5fc8-9b4e-c2f0ced985e0-9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                       |
| device_owner            | network:dhcp                                                                                                                                        |
| dns_assignment          | None                                                                                                                                                |
| dns_domain              | None                                                                                                                                                |
| dns_name                | None                                                                                                                                                |
| extra_dhcp_opts         |                                                                                                                                                     |
| fixed_ips               | ip_address='10.11.1.0', subnet_id='fd23cb2b-24b2-442e-91e4-ffc3ff4e4208'                                                                            |
|                         | ip_address='fe80::f816:3eff:fe73:27e', subnet_id='d0858e4f-0747-42ce-bf85-41271c01c6ef'                                                             |
| id                      | 2b21b9e0-554e-42c5-ab83-729533e462a4                                                                                                                |
| location                | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| mac_address             | fa:16:3e:73:02:7e                                                                                                                                   |
| name                    |                                                                                                                                                     |
| network_id              | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                                                                |
| port_security_enabled   | False                                                                                                                                               |
| project_id              | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| propagate_uplink_status | None                                                                                                                                                |
| qos_policy_id           | None                                                                                                                                                |
| resource_request        | None                                                                                                                                                |
| revision_number         | 5                                                                                                                                                   |
| security_group_ids      |                                                                                                                                                     |
| status                  | ACTIVE                                                                                                                                              |
| tags                    |                                                                                                                                                     |
| trunk_details           | None                                                                                                                                                |
| updated_at              | 2020-11-30T09:09:53Z                                                                                                                                |
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+

os@controller:~$ openstack port show 1d22605f-3354-48ed-9e2c-8e71804a7a94
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                   | Value                                                                                                                                               |
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up          | UP                                                                                                                                                  |
| allowed_address_pairs   |                                                                                                                                                     |
| binding_host_id         | compute02.etit.tu-chemnitz.de                                                                                                                       |
| binding_profile         |                                                                                                                                                     |
| binding_vif_details     | bridge_name='br-int', connectivity='l2', datapath_type='system', ovs_hybrid_plug='True', port_filter='True'                                         |
| binding_vif_type        | ovs                                                                                                                                                 |
| binding_vnic_type       | normal                                                                                                                                              |
| created_at              | 2020-11-30T08:57:50Z                                                                                                                                |
| data_plane_status       | None                                                                                                                                                |
| description             |                                                                                                                                                     |
| device_id               | dhcp951fa4a9-9a76-58f0-8e6f-ae48cfb159a2-9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                       |
| device_owner            | network:dhcp                                                                                                                                        |
| dns_assignment          | None                                                                                                                                                |
| dns_domain              | None                                                                                                                                                |
| dns_name                | None                                                                                                                                                |
| extra_dhcp_opts         |                                                                                                                                                     |
| fixed_ips               | ip_address='10.11.1.1', subnet_id='fd23cb2b-24b2-442e-91e4-ffc3ff4e4208'                                                                            |
|                         | ip_address='fe80::f816:3eff:fec3:3d66', subnet_id='d0858e4f-0747-42ce-bf85-41271c01c6ef'                                                            |
| id                      | 1d22605f-3354-48ed-9e2c-8e71804a7a94                                                                                                                |
| location                | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| mac_address             | fa:16:3e:c3:3d:66                                                                                                                                   |
| name                    |                                                                                                                                                     |
| network_id              | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85                                                                                                                |
| port_security_enabled   | False                                                                                                                                               |
| project_id              | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| propagate_uplink_status | None                                                                                                                                                |
| qos_policy_id           | None                                                                                                                                                |
| resource_request        | None                                                                                                                                                |
| revision_number         | 5                                                                                                                                                   |
| security_group_ids      |                                                                                                                                                     |
| status                  | ACTIVE                                                                                                                                              |
| tags                    |                                                                                                                                                     |
| trunk_details           | None                                                                                                                                                |
| updated_at              | 2020-11-30T09:09:53Z                                                                                                                                |
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```


[Previous](../controller/neutron.md#install-and-configure-controller-node)
[Neutron Home](../neutron.md#neutron-networking-service)
[Next](../controller/horizon.md#openstack-dashboard-horizon)