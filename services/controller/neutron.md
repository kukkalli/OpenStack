## Install and configure Controller node
### Prerequisites
#### Use the database access client to connect to the database server as the ```root``` user
```
# mysql
```
- Create the ```neutron``` database:
```
MariaDB [(none)]> CREATE DATABASE neutron;

e.g.
CREATE DATABASE neutron;
```
- Grant proper access to the ```neutron``` database:
```
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'NEUTRON_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'NEUTRON_DBPASS';

e.g.
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'tuckn2020';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'tuckn2020';
```
- Exit the database access client.

- Source the admin credentials to gain access to admin-only CLI commands:
```
$ . admin-openrc
```

#### Create the service credentials:
- Create the ```neutron``` user:
```
$ openstack user create --domain tuc --password-prompt neutron

os@controller:~$ openstack user create --domain tuc --password-prompt neutron
User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | tuc                              |
| enabled             | True                             |
| id                  | 7d0bd4d23abd4e2b947f43c0fa62fb81 |
| name                | neutron                          |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```
- Add the ```admin``` role to the ```neutron``` user:
```
$ openstack role add --project service --user neutron admin
```
- Create the ```neutron``` service entity:
```
$ openstack service create --name neutron --description "OpenStack Networking Service" network

os@controller:~$ openstack service create --name neutron --description "OpenStack Networking Service" network
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Networking Service     |
| enabled     | True                             |
| id          | c63a5507a9d549bc920a9d8def4b6d14 |
| name        | neutron                          |
| type        | network                          |
+-------------+----------------------------------+
```

- Create the Compute API service endpoints:
```
$ openstack endpoint create --region RegionOne network public http://controller:9696
$ openstack endpoint create --region RegionOne network internal http://controller:9696
$ openstack endpoint create --region RegionOne network admin http://controller:9696

e.g.
openstack endpoint create --region TUCKN network public http://controller:9696
openstack endpoint create --region TUCKN network internal http://controller:9696
openstack endpoint create --region TUCKN network admin http://controller:9696

output:
os@controller:~$ openstack endpoint create --region TUCKN network public http://controller:9696
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | f630b9bc6baf4f9fa95556c6df6e06d8 |
| interface    | public                           |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | c63a5507a9d549bc920a9d8def4b6d14 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://controller:9696           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN network internal http://controller:9696
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 2422cb7c3f864cb796403aab0efa7042 |
| interface    | internal                         |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | c63a5507a9d549bc920a9d8def4b6d14 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://controller:9696           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN network admin http://controller:9696
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 6de2d130b96f4fd4944c4c11d43098e4 |
| interface    | admin                            |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | c63a5507a9d549bc920a9d8def4b6d14 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://controller:9696           |
+--------------+----------------------------------+
```

### Configure networking options:
- Networking Option 2: Self-service networks
#### Install and configure
- Install the packages:
```
# apt install neutron-server neutron-plugin-ml2 neutron-openvswitch-agent neutron-l3-agent
```

- Edit the ```/etc/neutron/neutron.conf``` file and complete the following actions:
```bash
[DEFAULT]
auth_strategy = keystone
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
global_physnet_mtu = 9000
transport_url = rabbit://openstack:tuckn2020@controller

[agent]
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
The updated ```neutron.conf``` file can be found at: [neutron.conf](https://github.com/kukkalli/OpenStack/blob/master/services/controller/neutron.conf)

### Configure the Modular Layer 2 (ML2) plug-in
- Edit the ```/etc/neutron/plugins/ml2/ml2_conf.ini``` file and complete the following actions:
```bash
[DEFAULT]
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = openvswitch,l2population
extension_drivers = port_security,qos
physical_network_mtus = 9000

[ml2_type_flat]
flat_networks = tuc11

[ml2_type_geneve]
[ml2_type_gre]
[ml2_type_vlan]
[ml2_type_vxlan]
vni_ranges = 1:1000

[ovs_driver]
[securitygroup]
enable_ipset = true

[sriov_driver]
```
The updated ```ml2_conf.ini``` file can be found at: [ml2_conf.ini](https://github.com/kukkalli/OpenStack/blob/master/services/controller/ml2_conf.ini)

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
local_ip = 10.10.0.21
bridge_mappings = tuc11:brtuc11

[securitygroup]
firewall_driver = iptables_hybrid

[xenapi]
```
The updated ```openvswitch_agent.ini``` file can be found at: [openvswitch_agent.ini](https://github.com/kukkalli/OpenStack/blob/master/services/controller/openvswitch_agent.ini)

### Configure the layer-3 agent
- Edit the ```/etc/neutron/l3_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
interface_driver = openvswitch

[agent]
[network_log]
[ovs]
```
The updated ```l3_agent.ini``` file can be found at: [l3_agent.ini](l3_agent.ini)


neutron-dhcp-agent neutron-metadata-agent

[DEFAULT]
enable_isolated_metadata = True
interface_driver = openvswitch


[Previous](https://github.com/kukkalli/OpenStack/blob/master/services/openvswitch-dpdk.md#install-and-configure-openvswitch-dpdk)
[Neutron Home](https://github.com/kukkalli/OpenStack/blob/master/services/neutron.md#neutron-networking-service)
[Next](https://github.com/kukkalli/OpenStack/blob/master/services/neutron-compute.md#install-and-configure-compute-node)
