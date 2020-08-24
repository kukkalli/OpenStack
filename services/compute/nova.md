## Install and configure compute node
### Install and configure components

- Install the packages
```
# apt install nova-compute
```

- Edit the ```/etc/nova/nova.conf``` file and complete the following actions:
```bash
[DEFAULT]
#log_dir = /var/log/nova
lock_path = /var/lock/nova
state_path = /var/lib/nova

allow_resize_to_same_host = true
compute_monitors = cpu.virt_driver
reserved_host_cpus = 2
cpu_allocation_ratio = 1
ram_allocation_ratio = 1
disk_allocation_ratio = 1
initial_cpu_allocation_ratio = 1.0
initial_ram_allocation_ratio = 1.0
initial_disk_allocation_ratio = 1.0
instances_path = $state_path/instances
live_migration_retry_count = 30
resume_guests_state_on_host_boot = true
max_concurrent_builds = 10
max_concurrent_live_migrations = 1
reboot_timeout = 15
shutdown_timeout = 60
migrate_max_retries = -1
my_ip = 10.10.0.31
host = compute01.etit.tu-chemnitz.de
use_neutron = true
firewall_driver = nova.virt.firewall.NoopFirewallDriver
transport_url = rabbit://openstack:tuckn2020@controller

[api]
auth_strategy = keystone

[api_database]
#connection = sqlite:////var/lib/nova/nova_api.sqlite

[barbican]
[cache]
[cells]
enable = False

[cinder]
[compute]
#
# Defines which physical CPUs (pCPUs) will be used for best-effort guest vCPU
# resources.
#
# Currently only used by libvirt driver to place guest emulator threads when
# the flavor extra spec is set to ``hw:emulator_threads_policy=share``.
#
# For example::
#
#     cpu_shared_set = "4-12,^8,15"
#  (string value)
#cpu_shared_set = <None>

live_migration_wait_for_vif_plug = true

[conductor]
[console]
[consoleauth]
[cors]
[database]
#connection = sqlite:////var/lib/nova/nova.sqlite

[devices]
[ephemeral_storage_encryption]
[filter_scheduler]
[glance]
api_servers = http://10.10.0.21:9292

[guestfs]
[healthcheck]
[hyperv]
[ironic]
[key_manager]
[keystone]
[keystone_authtoken]
www_authenticate_uri = http://10.10.0.21:5000/
auth_url = http://10.10.0.21:5000/
memcached_servers = 10.10.0.21:11211
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
project_name = service
username = nova
password = tuckn2020

[libvirt]
virt_type = kvm
live_migration_tunnelled = true
live_migration_downtime = 500
live_migration_downtime_steps = 10
live_migration_downtime_delay = 75
live_migration_completion_timeout = 1200
live_migration_timeout_action = force_complete
live_migration_permit_auto_converge = true
live_migration_with_native_tls = false

[metrics]
[mks]
[neutron]
url = http://10.10.0.21:9696
auth_url = http://10.10.0.21:5000
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
region_name = TUCKN
project_name = service
username = neutron
password = tuckn2020

[notifications]
[osapi_v21]
[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[pci]
[placement]
#os_region_name = openstack
region_name = TUCKN
project_domain_name = TUC
project_name = service
auth_type = password
user_domain_name = TUC
auth_url = http://10.10.0.21:5000/v3
username = placement
password = tuckn2020

[placement_database]
[powervm]
[privsep]
[profiler]
[quota]
[rdp]
[remote_debug]
[scheduler]
[serial_console]
[service_user]
[spice]
[upgrade_levels]
[vault]
[vendordata_dynamic_auth]
[vmware]
[vnc]
enabled = true
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://10.10.0.21:6080/vnc_auto.html

[workarounds]
[wsgi]
[xenserver]
[xvp]
[zvm]

```

The updated ```nova.conf``` file can be found at: [nova.conf](nova.conf)

- Restart the Compute service:
```
# service nova-compute restart
```

### Add the compute node to the cell database
```
$ . admin-openrc
$ openstack compute service list --service nova-compute

```example output```
os@controller:~$ openstack compute service list --service nova-compute
+----+--------------+-------------------------------+------+---------+-------+----------------------------+
| ID | Binary       | Host                          | Zone | Status  | State | Updated At                 |
+----+--------------+-------------------------------+------+---------+-------+----------------------------+
| 10 | nova-compute | compute01.etit.tu-chemnitz.de | nova | enabled | up    | 2020-08-24T18:13:49.000000 |
| 11 | nova-compute | compute02.etit.tu-chemnitz.de | nova | enabled | up    | 2020-08-24T18:13:51.000000 |
+----+--------------+-------------------------------+------+---------+-------+----------------------------+
```

- Discover compute hosts:
```
# su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

```example output:```
root@controller:~# su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
Found 2 cell mappings.
Skipping cell0 since it does not contain hosts.
Getting computes from cell 'cell1': b90569c8-96ac-4b2a-8c04-8d50adfe4465
Checking host mapping for compute host 'compute01.etit.tu-chemnitz.de': b755b8b1-363f-40dc-ba6e-8b55dd3a4767
Creating host mapping for compute host 'compute01.etit.tu-chemnitz.de': b755b8b1-363f-40dc-ba6e-8b55dd3a4767
Checking host mapping for compute host 'compute02.etit.tu-chemnitz.de': 97582edb-4ab7-4190-ab14-243349e43c67
Creating host mapping for compute host 'compute02.etit.tu-chemnitz.de': 97582edb-4ab7-4190-ab14-243349e43c67
Found 2 unmapped computes in cell: b90569c8-96ac-4b2a-8c04-8d50adfe4465
```

### Verify operation

- Source the ```admin``` credentials
```
$ . admin-openrc
```
- List service components to verify successful launch and registration of each process:
```
$ openstack compute service list

```example output:```
os@controller:~$ openstack compute service list
+----+----------------+--------------------------------+----------+---------+-------+----------------------------+
| ID | Binary         | Host                           | Zone     | Status  | State | Updated At                 |
+----+----------------+--------------------------------+----------+---------+-------+----------------------------+
|  7 | nova-conductor | controller.etit.tu-chemnitz.de | internal | enabled | up    | 2020-08-24T18:14:49.000000 |
|  8 | nova-scheduler | controller.etit.tu-chemnitz.de | internal | enabled | up    | 2020-08-24T18:14:49.000000 |
| 10 | nova-compute   | compute01.etit.tu-chemnitz.de  | nova     | enabled | up    | 2020-08-24T18:14:49.000000 |
| 11 | nova-compute   | compute02.etit.tu-chemnitz.de  | nova     | enabled | up    | 2020-08-24T18:14:51.000000 |
+----+----------------+--------------------------------+----------+---------+-------+----------------------------+
```
- List API endpoints in the Identity service to verify connectivity with the Identity service:
```
$ openstack catalog list

```example output:```
os@controller:~$ openstack catalog list
+-----------+-----------+-----------------------------------------+
| Name      | Type      | Endpoints                               |
+-----------+-----------+-----------------------------------------+
| nova      | compute   | TUCKN                                   |
|           |           |   internal: http://10.10.0.21:8774/v2.1 |
|           |           | TUCKN                                   |
|           |           |   public: http://10.10.0.21:8774/v2.1   |
|           |           | TUCKN                                   |
|           |           |   admin: http://10.10.0.21:8774/v2.1    |
|           |           |                                         |
| placement | placement | TUCKN                                   |
|           |           |   public: http://10.10.0.21:8778        |
|           |           | TUCKN                                   |
|           |           |   admin: http://10.10.0.21:8778         |
|           |           | TUCKN                                   |
|           |           |   internal: http://10.10.0.21:8778      |
|           |           |                                         |
| keystone  | identity  | TUCKN                                   |
|           |           |   public: http://10.10.0.21:5000/v3/    |
|           |           | TUCKN                                   |
|           |           |   admin: http://10.10.0.21:5000/v3/     |
|           |           | TUCKN                                   |
|           |           |   internal: http://10.10.0.21:5000/v3/  |
|           |           |                                         |
| glance    | image     | TUCKN                                   |
|           |           |   public: http://10.10.0.21:9292        |
|           |           | TUCKN                                   |
|           |           |   admin: http://10.10.0.21:9292         |
|           |           | TUCKN                                   |
|           |           |   internal: http://10.10.0.21:9292      |
|           |           |                                         |
+-----------+-----------+-----------------------------------------+
```
- List images in the Image service to verify connectivity with the Image service:
```
$ openstack image list

```example output:```
os@controller:~$ openstack image list
+--------------------------------------+---------------------+--------+
| ID                                   | Name                | Status |
+--------------------------------------+---------------------+--------+
| 1211d636-99bc-40f6-a139-58a7502b30e9 | cirros-0.5.1-x86_64 | active |
+--------------------------------------+---------------------+--------+
```

- Check the cells and placement API are working successfully and that other necessary prerequisites are in place:
```
# nova-status upgrade check

```example output:```
root@controller:~# nova-status upgrade check
+--------------------------------+
| Upgrade Check Results          |
+--------------------------------+
| Check: Cells v2                |
| Result: Success                |
| Details: None                  |
+--------------------------------+
| Check: Placement API           |
| Result: Success                |
| Details: None                  |
+--------------------------------+
| Check: Ironic Flavor Migration |
| Result: Success                |
| Details: None                  |
+--------------------------------+
| Check: Cinder API              |
| Result: Success                |
| Details: None                  |
+--------------------------------+
```

[Previous](../controller/nova.md#install-and-configure-controller-node)
[Nova Home](../nova.md#nova-compute-service)
[Next](../neutron.md#neutron-networking-service)