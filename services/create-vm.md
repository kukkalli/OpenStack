## Create VMs on CLI

### Prepare parameters to create VM
#### Load the credentials to connect to OpenStack
```
. admin-openrc
```

#### Create key-pair to login into VM
```
$ openstack keypair create [--public-key <file> | --private-key <file>] <name>

```example output```
os@controller:~$  openstack keypair create --public-key ~/.ssh/id_ecdsa.pub controller
+-------------+-------------------------------------------------+
| Field       | Value                                           |
+-------------+-------------------------------------------------+
| fingerprint | 20:48:1e:53:fe:27:c0:bc:6f:58:81:19:d3:40:47:a2 |
| name        | controller                                      |
| user_id     | c349d1ffd3b74fe68d1aa49d71cfce1b                |
+-------------+-------------------------------------------------+

os@compute01:~$ openstack keypair create --public-key ~/.ssh/id_ecdsa.pub compute01
+-------------+-------------------------------------------------+
| Field       | Value                                           |
+-------------+-------------------------------------------------+
| fingerprint | 39:1a:23:97:3d:74:e4:a8:2d:8a:f0:e8:ed:dd:47:03 |
| name        | compute01                                       |
| user_id     | c349d1ffd3b74fe68d1aa49d71cfce1b                |
+-------------+-------------------------------------------------+

os@compute02:~$ openstack keypair create --public-key ~/.ssh/id_ecdsa.pub compute02
+-------------+-------------------------------------------------+
| Field       | Value                                           |
+-------------+-------------------------------------------------+
| fingerprint | 69:f0:08:c9:9d:dc:74:8b:c4:6f:2c:84:05:30:1d:62 |
| name        | compute02                                       |
| user_id     | c349d1ffd3b74fe68d1aa49d71cfce1b                |
+-------------+-------------------------------------------------+
```

#### List all the key-pairs in OpenStack

```
$ openstack keypair list

```example output```
os@controller:~$ openstack keypair list
+---------------+-------------------------------------------------+
| Name          | Fingerprint                                     |
+---------------+-------------------------------------------------+
| compute01     | 39:1a:23:97:3d:74:e4:a8:2d:8a:f0:e8:ed:dd:47:03 |
| compute02     | 69:f0:08:c9:9d:dc:74:8b:c4:6f:2c:84:05:30:1d:62 |
| controller    | 20:48:1e:53:fe:27:c0:bc:6f:58:81:19:d3:40:47:a2 |
| os-controller | 20:48:1e:53:fe:27:c0:bc:6f:58:81:19:d3:40:47:a2 |
| tuckn2020     | 18:61:03:fe:f1:14:c1:33:58:31:4a:d6:92:7e:c6:53 |
+---------------+-------------------------------------------------+
```

#### Find list of networks to choose for the VM
```
$ openstack network list

```example output```
os@controller:~$ openstack network list
+--------------------------------------+---------------+----------------------------------------------------------------------------+
| ID                                   | Name          | Subnets                                                                    |
+--------------------------------------+---------------+----------------------------------------------------------------------------+
| 9e373e2c-0372-4a06-81a1-bc1cb4c62b85 | TUC11-Network | d0858e4f-0747-42ce-bf85-41271c01c6ef, fd23cb2b-24b2-442e-91e4-ffc3ff4e4208 |
+--------------------------------------+---------------+----------------------------------------------------------------------------+
```

#### Find list of subnets to choose for the VM
```
$ openstack subnet list

```example output```
os@controller:~$ openstack subnet list
+--------------------------------------+---------------+--------------------------------------+--------------+
| ID                                   | Name          | Network                              | Subnet       |
+--------------------------------------+---------------+--------------------------------------+--------------+
| d0858e4f-0747-42ce-bf85-41271c01c6ef | TUC-Subnet-v6 | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85 | fe80::/64    |
| fd23cb2b-24b2-442e-91e4-ffc3ff4e4208 | TUC-Subnet-v4 | 9e373e2c-0372-4a06-81a1-bc1cb4c62b85 | 10.11.0.0/16 |
+--------------------------------------+---------------+--------------------------------------+--------------
```

#### Find list of security groups to choose for the VM
```
$ openstack security group list

```example output```
os@controller:~$ openstack security group list
+--------------------------------------+---------+------------------------+----------------------------------+------+
| ID                                   | Name    | Description            | Project                          | Tags |
+--------------------------------------+---------+------------------------+----------------------------------+------+
| ef249e36-3cf8-4ca5-a6ea-45107f4d5491 | default | Default security group | 6b5e1b91ce6d40a082004e7b60b614c4 | []   |
+--------------------------------------+---------+------------------------+----------------------------------+------+

os@controller:~$ openstack security group show ef249e36-3cf8-4ca5-a6ea-45107f4d5491
+-----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field           | Value                                                                                                                                                                                                                                          |
+-----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| created_at      | 2020-11-30T08:56:38Z                                                                                                                                                                                                                           |
| description     | Default security group                                                                                                                                                                                                                         |
| id              | ef249e36-3cf8-4ca5-a6ea-45107f4d5491                                                                                                                                                                                                           |
| location        | cloud='', project.domain_id=, project.domain_name='TUC', project.id='6b5e1b91ce6d40a082004e7b60b614c4', project.name='admin', region_name='', zone=                                                                                            |
| name            | default                                                                                                                                                                                                                                        |
| project_id      | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                                                                                                               |
| revision_number | 5                                                                                                                                                                                                                                              |
| rules           | created_at='2020-11-30T09:11:37Z', direction='ingress', ethertype='IPv4', id='29d7dad4-3c9c-4de5-b90b-b5b6d7ce4594', protocol='icmp', remote_ip_prefix='0.0.0.0/0', updated_at='2020-11-30T09:11:37Z'                                          |
|                 | created_at='2020-11-30T10:07:34Z', direction='ingress', ethertype='IPv6', id='2d2f8a1c-c323-4ede-a5db-bf592af5258e', port_range_max='22', port_range_min='22', protocol='tcp', remote_ip_prefix='::/0', updated_at='2020-11-30T10:07:34Z'      |
|                 | created_at='2020-11-30T08:56:38Z', direction='ingress', ethertype='IPv4', id='612cc49a-821b-47d4-bc5a-23592c5e4184', remote_group_id='ef249e36-3cf8-4ca5-a6ea-45107f4d5491', updated_at='2020-11-30T08:56:38Z'                                 |
|                 | created_at='2020-11-30T08:56:38Z', direction='egress', ethertype='IPv4', id='6ece631b-d803-4922-bc64-2397ab9d993e', updated_at='2020-11-30T08:56:38Z'                                                                                          |
|                 | created_at='2020-11-30T08:56:38Z', direction='ingress', ethertype='IPv6', id='a6c6c298-f0ff-4565-bb78-6aa819fe7bf6', remote_group_id='ef249e36-3cf8-4ca5-a6ea-45107f4d5491', updated_at='2020-11-30T08:56:38Z'                                 |
|                 | created_at='2020-11-30T10:06:35Z', direction='ingress', ethertype='IPv6', id='c4bab75a-c046-4286-aa63-a54d2a6ffdc6', protocol='ipv6-icmp', remote_ip_prefix='::/0', updated_at='2020-11-30T10:06:35Z'                                          |
|                 | created_at='2020-11-30T10:04:11Z', direction='ingress', ethertype='IPv4', id='f96bccf5-640f-40a2-944d-472e90a4ed80', port_range_max='22', port_range_min='22', protocol='tcp', remote_ip_prefix='0.0.0.0/0', updated_at='2020-11-30T10:04:11Z' |
|                 | created_at='2020-11-30T08:56:38Z', direction='egress', ethertype='IPv6', id='f9783c0c-c568-4e83-b4df-23d082bdbbb0', updated_at='2020-11-30T08:56:38Z'                                                                                          |
| tags            | []                                                                                                                                                                                                                                             |
| updated_at      | 2020-11-30T10:07:34Z                                                                                                                                                                                                                           |
+-----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

#### Find list of images to choose for the VM
```
$ openstack image list

```example output```
os@controller:~$  openstack image list
+--------------------------------------+------------------------------+--------+
| ID                                   | Name                         | Status |
+--------------------------------------+------------------------------+--------+
| 4f610afa-8553-4fdf-8e20-0cca99e90190 | bionic-server-cloudimg-amd64 | active |
| 1211d636-99bc-40f6-a139-58a7502b30e9 | cirros-0.5.1-x86_64          | active |
| 0af72659-a5c0-40a3-8b55-0b398e6b94f2 | focal-server-cloudimg-amd64  | active |
+--------------------------------------+------------------------------+--------+
```


#### Find list of flavors to choose for the VM
```
$ openstack flavor list

```example output```
os@controller:~$ openstack flavor list
+----+-----------+-------+------+-----------+-------+-----------+
| ID | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
+----+-----------+-------+------+-----------+-------+-----------+
| 0  | m1.tiny   |   512 |    1 |         0 |     1 | True      |
| 1  | m2.small  |  2048 |   20 |         0 |     1 | True      |
| 2  | m3.medium |  4096 |   40 |         0 |     2 | True      |
| 3  | m4.large  |  8192 |   80 |         0 |     4 | True      |
| 4  | m5.xlarge | 16384 |  160 |         0 |     8 | True      |
+----+-----------+-------+------+-----------+-------+-----------+
```


#### Find all the compute hosts to place the VM

```
$ openstack host list

```example output```
os@controller:~$ openstack host list
+--------------------------------+-----------+----------+
| Host Name                      | Service   | Zone     |
+--------------------------------+-----------+----------+
| controller.etit.tu-chemnitz.de | conductor | internal |
| controller.etit.tu-chemnitz.de | scheduler | internal |
| compute01.etit.tu-chemnitz.de  | compute   | nova     |
| compute02.etit.tu-chemnitz.de  | compute   | nova     |
+--------------------------------+-----------+----------+
```

### Create VMs

#### Create VM with a given IP address
```
$ openstack server create --flavor <flavor-id> --image <image-id> --nic net-id=<network-id>,v4-fixed-ip=<IP-Address> --security-group <name or id> --key-name <key-pair name> <VM-name>

```example output```
os@controller:~$ openstack server create --flavor 2 --image 0af72659-a5c0-40a3-8b55-0b398e6b94f2 --nic net-id=9e373e2c-0372-4a06-81a1-bc1cb4c62b85,v4-fixed-ip=10.11.1.10 --security-group ef249e36-3cf8-4ca5-a6ea-45107f4d5491 --key-name compute02 test-hanif
+-------------------------------------+--------------------------------------------------------------------+
| Field                               | Value                                                              |
+-------------------------------------+--------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                             |
| OS-EXT-AZ:availability_zone         |                                                                    |
| OS-EXT-SRV-ATTR:host                | None                                                               |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                                               |
| OS-EXT-SRV-ATTR:instance_name       |                                                                    |
| OS-EXT-STS:power_state              | NOSTATE                                                            |
| OS-EXT-STS:task_state               | scheduling                                                         |
| OS-EXT-STS:vm_state                 | building                                                           |
| OS-SRV-USG:launched_at              | None                                                               |
| OS-SRV-USG:terminated_at            | None                                                               |
| accessIPv4                          |                                                                    |
| accessIPv6                          |                                                                    |
| addresses                           |                                                                    |
| adminPass                           | VTe9P6gaTF9C                                                       |
| config_drive                        |                                                                    |
| created                             | 2020-11-30T10:47:04Z                                               |
| flavor                              | m3.medium (2)                                                      |
| hostId                              |                                                                    |
| id                                  | 94df548c-46e8-49f5-b94a-ab2f9fd9ffcb                               |
| image                               | focal-server-cloudimg-amd64 (0af72659-a5c0-40a3-8b55-0b398e6b94f2) |
| key_name                            | compute02                                                          |
| name                                | test-hanif                                                         |
| progress                            | 0                                                                  |
| project_id                          | 6b5e1b91ce6d40a082004e7b60b614c4                                   |
| properties                          |                                                                    |
| security_groups                     | name='ef249e36-3cf8-4ca5-a6ea-45107f4d5491'                        |
| status                              | BUILD                                                              |
| updated                             | 2020-11-30T10:47:04Z                                               |
| user_id                             | c349d1ffd3b74fe68d1aa49d71cfce1b                                   |
| volumes_attached                    |                                                                    |
+-------------------------------------+--------------------------------------------------------------------+
```

##### Verify VM
$ openstack server show <server-id>

```
os@controller:~$ openstack server show 94df548c-46e8-49f5-b94a-ab2f9fd9ffcb
+-------------------------------------+--------------------------------------------------------------------+
| Field                               | Value                                                              |
+-------------------------------------+--------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                             |
| OS-EXT-AZ:availability_zone         | nova                                                               |
| OS-EXT-SRV-ATTR:host                | compute02.etit.tu-chemnitz.de                                      |
| OS-EXT-SRV-ATTR:hypervisor_hostname | compute02.etit.tu-chemnitz.de                                      |
| OS-EXT-SRV-ATTR:instance_name       | instance-0000000b                                                  |
| OS-EXT-STS:power_state              | Running                                                            |
| OS-EXT-STS:task_state               | None                                                               |
| OS-EXT-STS:vm_state                 | active                                                             |
| OS-SRV-USG:launched_at              | 2020-11-30T10:42:44.000000                                         |
| OS-SRV-USG:terminated_at            | None                                                               |
| accessIPv4                          |                                                                    |
| accessIPv6                          |                                                                    |
| addresses                           | TUC11-Network=10.11.1.10                                           |
| config_drive                        |                                                                    |
| created                             | 2020-11-30T10:42:35Z                                               |
| flavor                              | m3.medium (2)                                                      |
| hostId                              | a1d7160c0730dbdb14bb5209d47ad45cca0125a2485000362a9e46a3           |
| id                                  | 4a7ab484-e40e-4746-b2d5-392683f4c9f9                               |
| image                               | focal-server-cloudimg-amd64 (0af72659-a5c0-40a3-8b55-0b398e6b94f2) |
| key_name                            | None                                                               |
| name                                | test-hanif                                                         |
| progress                            | 0                                                                  |
| project_id                          | 6b5e1b91ce6d40a082004e7b60b614c4                                   |
| properties                          |                                                                    |
| security_groups                     | name='default'                                                     |
| status                              | ACTIVE                                                             |
| updated                             | 2020-11-30T10:42:44Z                                               |
| user_id                             | c349d1ffd3b74fe68d1aa49d71cfce1b                                   |
| volumes_attached                    |                                                                    |
+-------------------------------------+--------------------------------------------------------------------+
```

#### Create VM with a given IP address and place it on a specific host
```
$ openstack server create --flavor <flavor-id> --image <image-id> --nic net-id=<network-id>,v4-fixed-ip=<IP-Address> --security-group <name or id> --key-name <key-pair name> --host <hostname> <VM-name>

```example output```
os@controller:~$ openstack server create --flavor 2 --image 0af72659-a5c0-40a3-8b55-0b398e6b94f2 --nic net-id=9e373e2c-0372-4a06-81a1-bc1cb4c62b85,v4-fixed-ip=10.11.1.11 --security-group ef249e36-3cf8-4ca5-a6ea-45107f4d5491 --key-name compute01 --host compute01.etit.tu-chemnitz.de --wait ubuntu-20
os@compute01:~$ openstack server create --flavor 2 --image 0af72659-a5c0-40a3-8b55-0b398e6b94f2 --nic net-id=9e373e2c-0372-4a06-81a1-bc1cb4c62b85,v4-fixed-ip=10.11.1.11 --security-group ef249e36-3cf8-4ca5-a6ea-45107f4d5491 --key-name compute01 --host compute01.etit.tu-chemnitz.de --wait ubuntu-20

+-------------------------------------+-------------------------------------------------------------------------------------------+
| Field                               | Value                                                                                     |
+-------------------------------------+-------------------------------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                                                    |
| OS-EXT-AZ:availability_zone         | nova                                                                                      |
| OS-EXT-SRV-ATTR:host                | compute01.etit.tu-chemnitz.de                                                             |
| OS-EXT-SRV-ATTR:hostname            | ubuntu-20                                                                                 |
| OS-EXT-SRV-ATTR:hypervisor_hostname | compute01.etit.tu-chemnitz.de                                                             |
| OS-EXT-SRV-ATTR:instance_name       | instance-0000000d                                                                         |
| OS-EXT-SRV-ATTR:kernel_id           |                                                                                           |
| OS-EXT-SRV-ATTR:launch_index        | 0                                                                                         |
| OS-EXT-SRV-ATTR:ramdisk_id          |                                                                                           |
| OS-EXT-SRV-ATTR:reservation_id      | r-sw7scbgk                                                                                |
| OS-EXT-SRV-ATTR:root_device_name    | /dev/vda                                                                                  |
| OS-EXT-SRV-ATTR:user_data           | None                                                                                      |
| OS-EXT-STS:power_state              | Running                                                                                   |
| OS-EXT-STS:task_state               | None                                                                                      |
| OS-EXT-STS:vm_state                 | active                                                                                    |
| OS-SRV-USG:launched_at              | 2020-11-30T11:16:29.000000                                                                |
| OS-SRV-USG:terminated_at            | None                                                                                      |
| accessIPv4                          |                                                                                           |
| accessIPv6                          |                                                                                           |
| addresses                           | TUC11-Network=10.11.1.11                                                                  |
| adminPass                           | AcwP3MLeWDv3                                                                              |
| config_drive                        |                                                                                           |
| created                             | 2020-11-30T11:16:10Z                                                                      |
| description                         | None                                                                                      |
| flavor                              | disk='40', ephemeral='0', , original_name='m3.medium', ram='4096', swap='4096', vcpus='2' |
| hostId                              | 69919870d0c523312c4e3e5856278ff2ffef5e15c9b809a7c20bfa09                                  |
| host_status                         | UP                                                                                        |
| id                                  | 5a083897-933e-41be-8eaa-86a32532d365                                                      |
| image                               | focal-server-cloudimg-amd64 (0af72659-a5c0-40a3-8b55-0b398e6b94f2)                        |
| key_name                            | compute01                                                                                 |
| locked                              | False                                                                                     |
| locked_reason                       | None                                                                                      |
| name                                | ubuntu-20                                                                                 |
| progress                            | 0                                                                                         |
| project_id                          | 6b5e1b91ce6d40a082004e7b60b614c4                                                          |
| properties                          |                                                                                           |
| security_groups                     | name='default'                                                                            |
| server_groups                       | []                                                                                        |
| status                              | ACTIVE                                                                                    |
| tags                                | []                                                                                        |
| trusted_image_certificates          | None                                                                                      |
| updated                             | 2020-11-30T11:16:29Z                                                                      |
| user_id                             | c349d1ffd3b74fe68d1aa49d71cfce1b                                                          |
| volumes_attached                    |                                                                                           |
+-------------------------------------+-------------------------------------------------------------------------------------------+


os@compute01:~$ openstack server create --flavor 2 --image 0af72659-a5c0-40a3-8b55-0b398e6b94f2 --nic net-id=9e373e2c-0372-4a06-81a1-bc1cb4c62b85,v4-fixed-ip=10.11.1.12 --security-group ef249e36-3cf8-4ca5-a6ea-45107f4d5491 --key-name compute01 --host compute01.etit.tu-chemnitz.de mehrdad
+-------------------------------------+-------------------------------------------------------------------------------------------+
| Field                               | Value                                                                                     |
+-------------------------------------+-------------------------------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                                                    |
| OS-EXT-AZ:availability_zone         |                                                                                           |
| OS-EXT-SRV-ATTR:host                | None                                                                                      |
| OS-EXT-SRV-ATTR:hostname            | mehrdad                                                                                   |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                                                                      |
| OS-EXT-SRV-ATTR:instance_name       |                                                                                           |
| OS-EXT-SRV-ATTR:kernel_id           |                                                                                           |
| OS-EXT-SRV-ATTR:launch_index        | 0                                                                                         |
| OS-EXT-SRV-ATTR:ramdisk_id          |                                                                                           |
| OS-EXT-SRV-ATTR:reservation_id      | r-iqujge0d                                                                                |
| OS-EXT-SRV-ATTR:root_device_name    | None                                                                                      |
| OS-EXT-SRV-ATTR:user_data           | None                                                                                      |
| OS-EXT-STS:power_state              | NOSTATE                                                                                   |
| OS-EXT-STS:task_state               | scheduling                                                                                |
| OS-EXT-STS:vm_state                 | building                                                                                  |
| OS-SRV-USG:launched_at              | None                                                                                      |
| OS-SRV-USG:terminated_at            | None                                                                                      |
| accessIPv4                          |                                                                                           |
| accessIPv6                          |                                                                                           |
| addresses                           |                                                                                           |
| adminPass                           | LT9xkQF4HPBb                                                                              |
| config_drive                        |                                                                                           |
| created                             | 2020-11-30T11:25:56Z                                                                      |
| description                         | None                                                                                      |
| flavor                              | disk='40', ephemeral='0', , original_name='m3.medium', ram='4096', swap='4096', vcpus='2' |
| hostId                              |                                                                                           |
| host_status                         |                                                                                           |
| id                                  | ac37f85b-e921-45b9-afc3-9180ad1fd819                                                      |
| image                               | focal-server-cloudimg-amd64 (0af72659-a5c0-40a3-8b55-0b398e6b94f2)                        |
| key_name                            | compute01                                                                                 |
| locked                              | False                                                                                     |
| locked_reason                       | None                                                                                      |
| name                                | mehrdad                                                                                   |
| progress                            | 0                                                                                         |
| project_id                          | 6b5e1b91ce6d40a082004e7b60b614c4                                                          |
| properties                          |                                                                                           |
| security_groups                     | name='ef249e36-3cf8-4ca5-a6ea-45107f4d5491'                                               |
| server_groups                       | []                                                                                        |
| status                              | BUILD                                                                                     |
| tags                                | []                                                                                        |
| trusted_image_certificates          | None                                                                                      |
| updated                             | 2020-11-30T11:25:56Z                                                                      |
| user_id                             | c349d1ffd3b74fe68d1aa49d71cfce1b                                                          |
| volumes_attached                    |                                                                                           |
+-------------------------------------+-------------------------------------------------------------------------------------------+


os@compute01:~$ openstack server show ac37f85b-e921-45b9-afc3-9180ad1fd819
+-------------------------------------+-------------------------------------------------------------------------------------------+
| Field                               | Value                                                                                     |
+-------------------------------------+-------------------------------------------------------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                                                                    |
| OS-EXT-AZ:availability_zone         | nova                                                                                      |
| OS-EXT-SRV-ATTR:host                | compute01.etit.tu-chemnitz.de                                                             |
| OS-EXT-SRV-ATTR:hostname            | mehrdad                                                                                   |
| OS-EXT-SRV-ATTR:hypervisor_hostname | compute01.etit.tu-chemnitz.de                                                             |
| OS-EXT-SRV-ATTR:instance_name       | instance-0000000e                                                                         |
| OS-EXT-SRV-ATTR:kernel_id           |                                                                                           |
| OS-EXT-SRV-ATTR:launch_index        | 0                                                                                         |
| OS-EXT-SRV-ATTR:ramdisk_id          |                                                                                           |
| OS-EXT-SRV-ATTR:reservation_id      | r-iqujge0d                                                                                |
| OS-EXT-SRV-ATTR:root_device_name    | /dev/vda                                                                                  |
| OS-EXT-SRV-ATTR:user_data           | None                                                                                      |
| OS-EXT-STS:power_state              | Running                                                                                   |
| OS-EXT-STS:task_state               | None                                                                                      |
| OS-EXT-STS:vm_state                 | active                                                                                    |
| OS-SRV-USG:launched_at              | 2020-11-30T11:26:03.000000                                                                |
| OS-SRV-USG:terminated_at            | None                                                                                      |
| accessIPv4                          |                                                                                           |
| accessIPv6                          |                                                                                           |
| addresses                           | TUC11-Network=10.11.1.12                                                                  |
| config_drive                        |                                                                                           |
| created                             | 2020-11-30T11:25:56Z                                                                      |
| description                         | None                                                                                      |
| flavor                              | disk='40', ephemeral='0', , original_name='m3.medium', ram='4096', swap='4096', vcpus='2' |
| hostId                              | 69919870d0c523312c4e3e5856278ff2ffef5e15c9b809a7c20bfa09                                  |
| host_status                         | UP                                                                                        |
| id                                  | ac37f85b-e921-45b9-afc3-9180ad1fd819                                                      |
| image                               | focal-server-cloudimg-amd64 (0af72659-a5c0-40a3-8b55-0b398e6b94f2)                        |
| key_name                            | compute01                                                                                 |
| locked                              | False                                                                                     |
| locked_reason                       | None                                                                                      |
| name                                | mehrdad                                                                                   |
| progress                            | 0                                                                                         |
| project_id                          | 6b5e1b91ce6d40a082004e7b60b614c4                                                          |
| properties                          |                                                                                           |
| security_groups                     | name='default'                                                                            |
| server_groups                       | []                                                                                        |
| status                              | ACTIVE                                                                                    |
| tags                                | []                                                                                        |
| trusted_image_certificates          | None                                                                                      |
| updated                             | 2020-11-30T11:26:03Z                                                                      |
| user_id                             | c349d1ffd3b74fe68d1aa49d71cfce1b                                                          |
| volumes_attached                    |                                                                                           |
+-------------------------------------+-------------------------------------------------------------------------------------------+
```

#### List the VMs
```
$ openstack server list

```example output```
os@controller:~$ openstack server list
os@controller:~$ openstack server list
+--------------------------------------+------------+--------+--------------------------+-----------------------------+-----------+
| ID                                   | Name       | Status | Networks                 | Image                       | Flavor    |
+--------------------------------------+------------+--------+--------------------------+-----------------------------+-----------+
| ac37f85b-e921-45b9-afc3-9180ad1fd819 | mehrdad    | ACTIVE | TUC11-Network=10.11.1.12 | focal-server-cloudimg-amd64 | m3.medium |
| 5a083897-933e-41be-8eaa-86a32532d365 | ubuntu-20  | ACTIVE | TUC11-Network=10.11.1.11 | focal-server-cloudimg-amd64 | m3.medium |
| 94df548c-46e8-49f5-b94a-ab2f9fd9ffcb | test-hanif | ACTIVE | TUC11-Network=10.11.1.10 | focal-server-cloudimg-amd64 | m3.medium |
+--------------------------------------+------------+--------+--------------------------+-----------------------------+-----------+
```


[Previous](controller/horizon.md#openstack-dashboard-horizon)
[Home](../README.md#create-virtual-machines)
