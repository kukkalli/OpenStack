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
| 68e4f58f-c36f-4101-8565-e69dfbca40ab | Open vSwitch agent | compute01.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-openvswitch-agent |
| 1c1197b9-a7fd-4a98-8cf3-fbd30b034e16 | Open vSwitch agent | compute02.etit.tu-chemnitz.de  | None              | :-)   | UP    | neutron-openvswitch-agent |
| c101161d-0e7c-498e-86e3-f46c50e963ee | DHCP agent         | controller.etit.tu-chemnitz.de | nova              | :-)   | UP    | neutron-dhcp-agent        |
| 00b6c399-9ec9-4325-a27b-47dfaf939736 | L3 agent           | controller.etit.tu-chemnitz.de | nova              | :-)   | UP    | neutron-l3-agent          |
| 06e80c97-7556-473f-9438-47274db774a4 | Metadata agent     | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-metadata-agent    |
| 3eb5fec7-b7c0-4652-9149-ab6a45ad8c96 | Metering agent     | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-metering-agent    |
| 890fbf39-f4cb-4d0c-ae27-8ef02c080453 | Open vSwitch agent | controller.etit.tu-chemnitz.de | None              | :-)   | UP    | neutron-openvswitch-agent |
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
| created_at                | 2020-08-25T09:27:00Z                                                                                                                                |
| description               |                                                                                                                                                     |
| dns_domain                | None                                                                                                                                                |
| id                        | 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4                                                                                                                |
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
| updated_at                | 2020-08-25T09:27:00Z                                                                                                                                |
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
| created_at        | 2020-08-25T09:36:47Z                                                                                                                                |
| description       |                                                                                                                                                     |
| dns_nameservers   | 1.1.1.1, 8.8.8.8                                                                                                                                    |
| enable_dhcp       | True                                                                                                                                                |
| gateway_ip        | 10.11.0.1                                                                                                                                           |
| host_routes       |                                                                                                                                                     |
| id                | 9ccc4b0b-42e6-4d2d-946e-c58490c508a6                                                                                                                |
| ip_version        | 4                                                                                                                                                   |
| ipv6_address_mode | None                                                                                                                                                |
| ipv6_ra_mode      | None                                                                                                                                                |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | TUC-Subnet-v4                                                                                                                                       |
| network_id        | 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4                                                                                                                |
| prefix_length     | None                                                                                                                                                |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| revision_number   | 0                                                                                                                                                   |
| segment_id        | None                                                                                                                                                |
| service_types     |                                                                                                                                                     |
| subnetpool_id     | None                                                                                                                                                |
| tags              |                                                                                                                                                     |
| updated_at        | 2020-08-25T09:36:47Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
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
| created_at        | 2020-08-25T09:53:41Z                                                                                                                                |
| description       |                                                                                                                                                     |
| dns_nameservers   | 2001:4860:4860::8844                                                                                                                                |
| enable_dhcp       | True                                                                                                                                                |
| gateway_ip        | fe80::1                                                                                                                                             |
| host_routes       |                                                                                                                                                     |
| id                | c495e909-6a5e-4b02-88d4-76293336a3c2                                                                                                                |
| ip_version        | 6                                                                                                                                                   |
| ipv6_address_mode | slaac                                                                                                                                               |
| ipv6_ra_mode      | slaac                                                                                                                                               |
| location          | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| name              | TUC-Subnet-v6                                                                                                                                       |
| network_id        | 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4                                                                                                                |
| prefix_length     | None                                                                                                                                                |
| project_id        | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| revision_number   | 0                                                                                                                                                   |
| segment_id        | None                                                                                                                                                |
| service_types     |                                                                                                                                                     |
| subnetpool_id     | None                                                                                                                                                |
| tags              |                                                                                                                                                     |
| updated_at        | 2020-08-25T09:53:41Z                                                                                                                                |
+-------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```

### Verify network operation
- On each compute node, verify creation of the qdhcp namespace.
```
# ip netns

```example output:```
root@controller:~# ip netns
qdhcp-08102d9b-8bc5-43ae-bd35-7624ac2cb6e4 (id: 0)
```

- Create the appropriate security group rules to allow ping and SSH access instances using the network.
```
$ openstack security group rule create --proto icmp default
```

- Show all networks
```
os@controller:~$ openstack network list
+--------------------------------------+---------------+----------------------------------------------------------------------------+
| ID                                   | Name          | Subnets                                                                    |
+--------------------------------------+---------------+----------------------------------------------------------------------------+
| 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4 | TUC11-Network | 9ccc4b0b-42e6-4d2d-946e-c58490c508a6, c495e909-6a5e-4b02-88d4-76293336a3c2 |
+--------------------------------------+---------------+----------------------------------------------------------------------------+
```

- Show all subnets
```
os@controller:~$ openstack subnet list
+--------------------------------------+---------------+--------------------------------------+--------------+
| ID                                   | Name          | Network                              | Subnet       |
+--------------------------------------+---------------+--------------------------------------+--------------+
| 9ccc4b0b-42e6-4d2d-946e-c58490c508a6 | TUC-Subnet-v4 | 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4 | 10.11.0.0/16 |
| c495e909-6a5e-4b02-88d4-76293336a3c2 | TUC-Subnet-v6 | 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4 | fe80::/64    |
+--------------------------------------+---------------+--------------------------------------+--------------+
```

- Show all ports
```
os@controller:~$ openstack port list
+--------------------------------------+-----------+-------------------+------------------------------------------------------------------------------------------+--------+
| ID                                   | Name      | MAC Address       | Fixed IP Addresses                                                                       | Status |
+--------------------------------------+-----------+-------------------+------------------------------------------------------------------------------------------+--------+
| b6e54f50-a9f8-403b-a774-6b5f804cd773 | DHCP-Port | fa:16:3e:2c:d8:d7 | ip_address='10.11.1.0', subnet_id='9ccc4b0b-42e6-4d2d-946e-c58490c508a6'                 | ACTIVE |
|                                      |           |                   | ip_address='fe80::f816:3eff:fe2c:d8d7', subnet_id='c495e909-6a5e-4b02-88d4-76293336a3c2' |        |
+--------------------------------------+-----------+-------------------+------------------------------------------------------------------------------------------+--------+
```

- Ping IPv6 address on the DHCP port
```
ping6 -I brtuc11 fe80::f816:3eff:fe2c:d8d7
```

- DHCP Port details
```
os@controller:~$ openstack port show b6e54f50-a9f8-403b-a774-6b5f804cd773
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                   | Value                                                                                                                                               |
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up          | UP                                                                                                                                                  |
| allowed_address_pairs   |                                                                                                                                                     |
| binding_host_id         | controller.etit.tu-chemnitz.de                                                                                                                      |
| binding_profile         |                                                                                                                                                     |
| binding_vif_details     | bridge_name='br-int', connectivity='l2', datapath_type='system', ovs_hybrid_plug='True', port_filter='True'                                         |
| binding_vif_type        | ovs                                                                                                                                                 |
| binding_vnic_type       | normal                                                                                                                                              |
| created_at              | 2020-08-25T09:36:47Z                                                                                                                                |
| data_plane_status       | None                                                                                                                                                |
| description             |                                                                                                                                                     |
| device_id               | dhcpd3377d3c-a0d1-5d71-9947-f17125c357bb-08102d9b-8bc5-43ae-bd35-7624ac2cb6e4                                                                       |
| device_owner            | network:dhcp                                                                                                                                        |
| dns_assignment          | None                                                                                                                                                |
| dns_domain              | None                                                                                                                                                |
| dns_name                | None                                                                                                                                                |
| extra_dhcp_opts         |                                                                                                                                                     |
| fixed_ips               | ip_address='10.11.1.0', subnet_id='9ccc4b0b-42e6-4d2d-946e-c58490c508a6'                                                                            |
|                         | ip_address='fe80::f816:3eff:fe2c:d8d7', subnet_id='c495e909-6a5e-4b02-88d4-76293336a3c2'                                                            |
| id                      | b6e54f50-a9f8-403b-a774-6b5f804cd773                                                                                                                |
| location                | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone= |
| mac_address             | fa:16:3e:2c:d8:d7                                                                                                                                   |
| name                    | DHCP-Port                                                                                                                                           |
| network_id              | 08102d9b-8bc5-43ae-bd35-7624ac2cb6e4                                                                                                                |
| port_security_enabled   | False                                                                                                                                               |
| project_id              | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                    |
| propagate_uplink_status | None                                                                                                                                                |
| qos_policy_id           | None                                                                                                                                                |
| resource_request        | None                                                                                                                                                |
| revision_number         | 6                                                                                                                                                   |
| security_group_ids      |                                                                                                                                                     |
| status                  | ACTIVE                                                                                                                                              |
| tags                    |                                                                                                                                                     |
| trunk_details           | None                                                                                                                                                |
| updated_at              | 2020-08-25T09:53:41Z                                                                                                                                |
+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
```


[Previous](../controller/neutron.md#install-and-configure-controller-node)
[Neutron Home](../neutron.md#neutron-networking-service)
[Next](../controller/horizon.md#openstack-dashboard-horizon)