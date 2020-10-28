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
User Password: tuckn2020
Repeat User Password: tuckn2020
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | tuc                              |
| enabled             | True                             |
| id                  | c5fb18bdca7e42eb9fe47ad2393a3e98 |
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
| id          | 169e27e7d5aa43c8a60cdaa0b7646ba6 |
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
openstack endpoint create --region TUCKN network public http://10.10.0.21:9696
openstack endpoint create --region TUCKN network internal http://10.10.0.21:9696
openstack endpoint create --region TUCKN network admin http://10.10.0.21:9696

output:
os@controller:~$ openstack endpoint create --region TUCKN network public http://10.10.0.21:9696
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 0a8913b19aaf4df8abf9335bc2da6be1 |
| interface    | public                           |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | 169e27e7d5aa43c8a60cdaa0b7646ba6 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://10.10.0.21:9696           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN network internal http://10.10.0.21:9696
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 32d6b23995fa4a94a19d1f1d75a6b5fd |
| interface    | internal                         |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | 169e27e7d5aa43c8a60cdaa0b7646ba6 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://10.10.0.21:9696           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN network admin http://10.10.0.21:9696
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 8e20e0e645664ef6ae36adc5fd28b20b |
| interface    | admin                            |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | 169e27e7d5aa43c8a60cdaa0b7646ba6 |
| service_name | neutron                          |
| service_type | network                          |
| url          | http://10.10.0.21:9696           |
+--------------+----------------------------------+
```

### Configure networking options:
- Networking Option 2: Self-service networks
#### Install and configure
- Install the packages:
```
# apt install neutron-server neutron-plugin-ml2 neutron-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent neutron-metering-agent


```

- Edit the ```/etc/neutron/neutron.conf``` file and complete the following actions:
```bash
[DEFAULT]
auth_strategy = keystone
core_plugin = ml2
service_plugins = odl-router_v2,metering
allow_overlapping_ips = true
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
global_physnet_mtu = 9000
dhcp_agents_per_network = 2
transport_url = rabbit://openstack:tuckn2020@10.10.0.21

[agent]
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
The updated ```neutron.conf``` file can be found at: [neutron.conf](https://github.com/kukkalli/OpenStack/blob/master/services/controller/neutron.conf)

### Configure the Modular Layer 2 (ML2) plug-in
- Edit the ```/etc/neutron/plugins/ml2/ml2_conf.ini``` file and complete the following actions:
```bash
[DEFAULT]
[ml2]
type_drivers = local,flat,vlan,vxlan
tenant_network_types = vxlan
# mechanism_drivers = openvswitch,l2population
mechanism_drivers = opendaylight_v2
extension_drivers = port_security,qos
# physical_network_mtus = 9000

[ml2_type_flat]
flat_networks = tuc11

[ml2_type_geneve]
[ml2_type_gre]
[ml2_type_vlan]
[ml2_type_vxlan]
vni_ranges = 1:1000

[ovs_driver]
[securitygroup]
# enable_security_group = true
enable_ipset = true

[sriov_driver]

[ml2_odl]
username = admin
password = admin
url = http://10.10.0.10:8181/controller/nb/v2/neutron
port_binding_controller = pseudo-agentdb-binding
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

### Configure the DHCP agent
- Edit the ```/etc/neutron/dhcp_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
interface_driver = openvswitch
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True

[agent]
[ovs]
ovsdb_connection = tcp:10.10.0.10:6640
```
The updated ```dhcp_agent.ini``` file can be found at: [dhcp_agent.ini](dhcp_agent.ini)

### Configure the metadata agent
- Edit the ```/etc/neutron/metadata_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
nova_metadata_host = 10.10.0.21
metadata_proxy_shared_secret = tuckn2020

[agent]
[cache]
```
The updated ```metadata_agent.ini``` file can be found at: [metadata_agent.ini](metadata_agent.ini)

### Configure metering agent
- Edit the ```/etc/neutron/metering_agent.ini``` file and complete the following actions:
```bash
[DEFAULT]
interface_driver = openvswitch
driver = iptables

[agent]
[ovs]
```
The updated ```metering_agent.ini``` file can be found at: [metering_agent.ini](metering_agent.ini)

### Finalize installation
- Populate the database:
```
# su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --config-file /etc/neutron/plugins/ml2/ml2_conf_odl.ini upgrade head" neutron
```

### Restart services

```
# service nova-api restart
# service neutron-server restart
# service neutron-openvswitch-agent restart
# service neutron-dhcp-agent restart
# service neutron-metadata-agent restart
# service neutron-l3-agent restart
# service neutron-metering-agent restart

```Copy below```
service nova-api restart
service neutron-server restart
service neutron-openvswitch-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart
```


[Previous](../openvswitch-dpdk.md#install-and-configure-openvswitch-dpdk)
[Neutron Home](../neutron.md#neutron-networking-service)
[Next](../compute/neutron.md#install-and-configure-compute-node)