## Install and configure Compute node

### Configure networking options:
- Networking Option 1: Provider networks
### Install and configure
- Install the packages:
```
# apt install neutron-openvswitch-agent
```

- Edit the ```/etc/neutron/neutron.conf``` file and complete the following actions:
```bash
[DEFAULT]
auth_strategy = keystone
core_plugin = ml2
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
global_physnet_mtu = 9000
transport_url = rabbit://openstack:tuckn2020@controller

[agent]
root_helper = "sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf"

[cors]
[database]
connection = mysql+pymysql://neutron:tuckn2020@controller/neutron

[ironic]
[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
project_name = service
username = neutron
password = tuckn2020

[nova]
auth_url = http://controller:5000
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
os@compute01:~$ openstack extension list --network
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
$ openstack network agent list

```example output:```
os@compute01:~$ openstack network agent list
+--------------------------------------+--------------------+--------------------------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host                           | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+--------------------------------+-------------------+-------+-------+---------------------------+
| 107fee0e-d7d3-48e7-ad22-a3274c6d7de8 | Metadata agent     | controller                     | None              | XXX   | UP    | neutron-metadata-agent    |
| 5f6ccd5b-5416-46f7-9e61-b70029df0e13 | Open vSwitch agent | controller                     | None              | XXX   | UP    | neutron-openvswitch-agent |
| 61b9e129-0da4-44a8-8bdf-6a157325edb2 | DHCP agent         | controller.etit.tu-chemnitz.de | nova              | :-)   | UP    | neutron-dhcp-agent        |
| 80f0759e-47e3-4d93-a5f2-1c9f43fc20e0 | Metering agent     | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-metering-agent    |
| 984916b0-d178-4d37-b439-048e9ac87b2e | Open vSwitch agent | compute01.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-openvswitch-agent |
| cc18b3eb-c420-45e4-87f8-a62c96fc1c92 | Open vSwitch agent | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-openvswitch-agent |
| d4ca5f8a-57c1-43e8-b57f-301d6c30f6c1 | Open vSwitch agent | compute02.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-openvswitch-agent |
| d7e7e15c-f688-4e30-a5e6-9982689db0b5 | DHCP agent         | controller                     | nova              | XXX   | UP    | neutron-dhcp-agent        |
| e8c62400-4dee-4f9f-bb0b-9188d3b3d667 | Metadata agent     | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-metadata-agent    |
| f879412f-0566-44ee-9d50-9115f3ce0726 | Metering agent     | controller                     | None              | XXX   | UP    | neutron-metering-agent    |
+--------------------------------------+--------------------+--------------------------------+-------------------+-------+-------+---------------------------+
```

### Create initial networks
```
$ openstack network create --share --provider-physical-network winlab31 --provider-network-type flat WinLab31

```example output:```
native@stable-control-01:~$ openstack network create --share --provider-physical-network winlab31 --provider-network-type flat WinLab31
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                     | Value                                                                                                                                                  |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up            | UP                                                                                                                                                     |
| availability_zone_hints   |                                                                                                                                                        |
| availability_zones        |                                                                                                                                                        |
| created_at                | 2020-08-17T13:43:05Z                                                                                                                                   |
| description               |                                                                                                                                                        |
| dns_domain                | None                                                                                                                                                   |
| id                        | a2a6b774-88ef-477f-bd14-23e6ba73deef                                                                                                                   |
| ipv4_address_scope        | None                                                                                                                                                   |
| ipv6_address_scope        | None                                                                                                                                                   |
| is_default                | None                                                                                                                                                   |
| is_vlan_transparent       | None                                                                                                                                                   |
| location                  | cloud='', project.domain_id=, project.domain_name='Stable', project.id='301ec83caf7343f1bd1639a932efbdcb', project.name='admin', region_name='', zone= |
| mtu                       | 9000                                                                                                                                                   |
| name                      | WinLab31                                                                                                                                               |
| port_security_enabled     | True                                                                                                                                                   |
| project_id                | 301ec83caf7343f1bd1639a932efbdcb                                                                                                                       |
| provider:network_type     | flat                                                                                                                                                   |
| provider:physical_network | winlab31                                                                                                                                               |
| provider:segmentation_id  | None                                                                                                                                                   |
| qos_policy_id             | None                                                                                                                                                   |
| revision_number           | 1                                                                                                                                                      |
| router:external           | Internal                                                                                                                                               |
| segments                  | None                                                                                                                                                   |
| shared                    | True                                                                                                                                                   |
| status                    | ACTIVE                                                                                                                                                 |
| subnets                   |                                                                                                                                                        |
| tags                      |                                                                                                                                                        |
| updated_at                | 2020-08-17T13:43:05Z                                                                                                                                   |
+---------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+
```

### Create a IPv4 subnet on the provider network.

```
$ openstack subnet create --subnet-range 10.31.0.0/16 --gateway 10.31.0.1 --network WinLab31 --allocation-pool start=10.31.4.0,end=10.31.4.255 --dns-nameserver 8.8.4.4 WinLab31-Subnet-v4

```example output:```
native@stable-control-01:~$ openstack subnet create --subnet-range 10.31.0.0/16 --gateway 10.31.0.1 --network WinLab31 --allocation-pool start=10.31.4.0,end=10.31.4.255 --dns-nameserver 8.8.4.4 WinLab31-Subnet-v4
+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field             | Value                                                                                                                                                  |
+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+
| allocation_pools  | 10.31.4.0-10.31.4.255                                                                                                                                  |
| cidr              | 10.31.0.0/16                                                                                                                                           |
| created_at        | 2020-08-17T13:51:52Z                                                                                                                                   |
| description       |                                                                                                                                                        |
| dns_nameservers   | 8.8.4.4                                                                                                                                                |
| enable_dhcp       | True                                                                                                                                                   |
| gateway_ip        | 10.31.0.1                                                                                                                                              |
| host_routes       |                                                                                                                                                        |
| id                | 80c5646e-e585-4c58-8624-e7834d354e19                                                                                                                   |
| ip_version        | 4                                                                                                                                                      |
| ipv6_address_mode | None                                                                                                                                                   |
| ipv6_ra_mode      | None                                                                                                                                                   |
| location          | cloud='', project.domain_id=, project.domain_name='Stable', project.id='301ec83caf7343f1bd1639a932efbdcb', project.name='admin', region_name='', zone= |
| name              | WinLab31-Subnet-v4                                                                                                                                     |
| network_id        | a2a6b774-88ef-477f-bd14-23e6ba73deef                                                                                                                   |
| prefix_length     | None                                                                                                                                                   |
| project_id        | 301ec83caf7343f1bd1639a932efbdcb                                                                                                                       |
| revision_number   | 0                                                                                                                                                      |
| segment_id        | None                                                                                                                                                   |
| service_types     |                                                                                                                                                        |
| subnetpool_id     | None                                                                                                                                                   |
| tags              |                                                                                                                                                        |
| updated_at        | 2020-08-17T13:51:52Z                                                                                                                                   |
+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+
```

### Verify network operation
- On each compute node, verify creation of the qdhcp namespace.
```
# ip netns

```example output:```
root@stable-compute-04:~# ip netns
qdhcp-a2a6b774-88ef-477f-bd14-23e6ba73deef (id: 0)
```
- Create the appropriate security group rules to allow ping and SSH access instances using the network.
```
$ openstack security group rule create --proto icmp default
```
[Previous](../controller/neutron.md#install-and-configure-controller-node)
[Neutron Home](../neutron.md#neutron-networking-service)
[Next](../controller/horizon.md#openstack-dashboard-horizon)