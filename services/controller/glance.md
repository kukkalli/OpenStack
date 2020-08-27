## Glance (Image Service)

### Install and configure

#### Prerequisite
- Create the database
  ```
  # mysql
  ```

  - Create the ```glance``` database:
  ```
  MariaDB [(none)]> CREATE DATABASE glance;
  
  e.g.
  CREATE DATABASE glance;
  ```

  - Grant proper access to the ```glance``` database:
  ```
  MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
  MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
  
  e.g.
  GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'tuckn2020';
  GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'tuckn2020';
  ```
  - Exit the database access client.

- Source the admin credentials to gain access to admin-only CLI commands:
```
$ . admin-openrc
```

- Create the service credentials:
  - Create the ```glance``` user:
```
os@controller:~$ openstack user create --domain tuc --password-prompt glance
User Password: tuckn2020
Repeat User Password: tuckn2020
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | tuc                              |
| enabled             | True                             |
| id                  | f77cf2e7adc149abada278d738b352f6 |
| name                | glance                           |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```
  - Add the ```admin``` role to the ```glance``` user and ```service``` project:
```
$ openstack role add --project service --user glance admin
```
  - Create the ```glance``` service entity:
```
os@controller:~$ openstack service create --name glance --description "OpenStack Image Service" image
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Image Service          |
| enabled     | True                             |
| id          | f7b4e16b0b204066b85597911faba353 |
| name        | glance                           |
| type        | image                            |
+-------------+----------------------------------+
```
- Create the Image service API endpoints:
```
$ openstack endpoint create --region RegionOne image public http://controller:9292
$ openstack endpoint create --region RegionOne image internal http://controller:9292
$ openstack endpoint create --region RegionOne image admin http://controller:9292

e.g.
openstack endpoint create --region TUCKN image public http://10.10.0.21:9292
openstack endpoint create --region TUCKN image internal http://10.10.0.21:9292
openstack endpoint create --region TUCKN image admin http://10.10.0.21:9292

output:
os@controller:~$ openstack endpoint create --region TUCKN image public http://10.10.0.21:9292
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 0c9d728c51f54a75922b42541946c9d0 |
| interface    | public                           |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | f7b4e16b0b204066b85597911faba353 |
| service_name | glance                           |
| service_type | image                            |
| url          | http://10.10.0.21:9292           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN image internal http://10.10.0.21:9292
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | a3d99092664149d39142c56f42133983 |
| interface    | internal                         |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | f7b4e16b0b204066b85597911faba353 |
| service_name | glance                           |
| service_type | image                            |
| url          | http://10.10.0.21:9292           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN image admin http://10.10.0.21:9292
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 413a30b80c8040c988f5937381aa741a |
| interface    | admin                            |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | f7b4e16b0b204066b85597911faba353 |
| service_name | glance                           |
| service_type | image                            |
| url          | http://10.10.0.21:9292           |
+--------------+----------------------------------+
```

#### Install and configure components
- Install the packages:
```
# apt install glance
```
- Edit the ```/etc/glance/glance-api.conf``` file and complete the following actions:
  - In the ```[database]``` section, configure database access:
```bash
[database]
# ...
connection = mysql+pymysql://glance:tuckn2020@10.10.0.21/glance
```
- In the ```[keystone_authtoken]``` and ```[paste_deploy]``` sections, configure Identity service access:
```bash
[keystone_authtoken]
# ...
www_authenticate_uri = http://10.10.0.21:5000
auth_url = http://10.10.0.21:5000
memcached_servers = 10.10.0.21:11211
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
project_name = service
username = glance
password = tuckn2020
  
[paste_deploy]
# ...
flavor = keystone
  
[glance_store]
# ...
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```
- Populate the Image service database:
```
# su -s /bin/sh -c "glance-manage db_sync" glance
```

### Finalize installation
Restart the Image services:
```
# service glance-api restart
```

### Verify operation
- Source the admin credentials to gain access to admin-only CLI commands:
```
$ . admin-openrc
```

- Download the source image:
```
$ wget http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img 
```

- Upload the image to the Image service using the QCOW2 disk format, bare container format, and public visibility so all projects can access it:
```
$ openstack image create --file cirros-0.5.1-x86_64-disk.img --disk-format qcow2 --container-format bare --public cirros-0.5.1-x86_64

os@controller:~$ openstack image create --file cirros-0.5.1-x86_64-disk.img --disk-format qcow2 --container-format bare --public cirros-0.5.1-x86_64
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                                                                                      |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| checksum         | 1d3062cd89af34e419f7100277f38b2b                                                                                                                                                           |
| container_format | bare                                                                                                                                                                                       |
| created_at       | 2020-08-24T17:22:01Z                                                                                                                                                                       |
| disk_format      | qcow2                                                                                                                                                                                      |
| file             | /v2/images/1211d636-99bc-40f6-a139-58a7502b30e9/file                                                                                                                                       |
| id               | 1211d636-99bc-40f6-a139-58a7502b30e9                                                                                                                                                       |
| min_disk         | 0                                                                                                                                                                                          |
| min_ram          | 0                                                                                                                                                                                          |
| name             | cirros-0.5.1-x86_64                                                                                                                                                                        |
| owner            | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                                                           |
| properties       | os_hash_algo='sha512', os_hash_value='553d220ed58cfee7dafe003c446a9f197ab5edf8ffc09396c74187cf83873c877e7ae041cb80f3b91489acf687183adcd689b53b38e3ddd22e627e7f98a09c46', os_hidden='False' |
| protected        | False                                                                                                                                                                                      |
| schema           | /v2/schemas/image                                                                                                                                                                          |
| size             | 16338944                                                                                                                                                                                   |
| status           | active                                                                                                                                                                                     |
| tags             |                                                                                                                                                                                            |
| updated_at       | 2020-08-24T17:22:01Z                                                                                                                                                                       |
| virtual_size     | None                                                                                                                                                                                       |
| visibility       | public                                                                                                                                                                                     |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

$ openstack image create --file bionic-server-cloudimg-amd64.img --disk-format qcow2 --container-format bare --public bionic-server-cloudimg-amd64

os@controller:~$ openstack image create --file bionic-server-cloudimg-amd64.img --disk-format qcow2 --container-format bare --public bionic-server-cloudimg-amd64
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                                                                                      |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| checksum         | 6d31f6620503216667ada0fc55efc3e0                                                                                                                                                           |
| container_format | bare                                                                                                                                                                                       |
| created_at       | 2020-08-25T12:30:37Z                                                                                                                                                                       |
| disk_format      | qcow2                                                                                                                                                                                      |
| file             | /v2/images/6d6c390c-24e5-49d0-99f8-21ac568af45d/file                                                                                                                                       |
| id               | 6d6c390c-24e5-49d0-99f8-21ac568af45d                                                                                                                                                       |
| min_disk         | 0                                                                                                                                                                                          |
| min_ram          | 0                                                                                                                                                                                          |
| name             | bionic-server-cloudimg-amd64                                                                                                                                                               |
| owner            | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                                                           |
| properties       | os_hash_algo='sha512', os_hash_value='d8b615ef336d470cb240b09c35fc362de36aa1bceb61120ab3b5434c2ecd63454bec58490dc56ddec55932bd8afbbdca1712f3bbd94a12a16585c3a2b0bc07ec', os_hidden='False' |
| protected        | False                                                                                                                                                                                      |
| schema           | /v2/schemas/image                                                                                                                                                                          |
| size             | 357302272                                                                                                                                                                                  |
| status           | active                                                                                                                                                                                     |
| tags             |                                                                                                                                                                                            |
| updated_at       | 2020-08-25T12:30:38Z                                                                                                                                                                       |
| virtual_size     | None                                                                                                                                                                                       |
| visibility       | public                                                                                                                                                                                     |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

$ openstack image create --file focal-server-cloudimg-amd64.img --disk-format qcow2 --container-format bare --public focal-server-cloudimg-amd64

os@controller:~$ openstack image create --file focal-server-cloudimg-amd64.img --disk-format qcow2 --container-format bare --public focal-server-cloudimg-amd64
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                                                                                      |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| checksum         | fb7c01af21cfe0263b08e637db3effc1                                                                                                                                                           |
| container_format | bare                                                                                                                                                                                       |
| created_at       | 2020-08-25T12:04:47Z                                                                                                                                                                       |
| disk_format      | qcow2                                                                                                                                                                                      |
| file             | /v2/images/0af72659-a5c0-40a3-8b55-0b398e6b94f2/file                                                                                                                                       |
| id               | 0af72659-a5c0-40a3-8b55-0b398e6b94f2                                                                                                                                                       |
| min_disk         | 0                                                                                                                                                                                          |
| min_ram          | 0                                                                                                                                                                                          |
| name             | focal-server-cloudimg-amd64                                                                                                                                                                |
| owner            | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                                                           |
| properties       | os_hash_algo='sha512', os_hash_value='a6c617f3e3d285ab1ae16d8725e9a38bfcfdb21ae28114c78bca5e7e2db96aa97889d965ebfd23aa48c22d533fe1f3e3c5271d5fee246e1cfb0390ca3443101f', os_hidden='False' |
| protected        | False                                                                                                                                                                                      |
| schema           | /v2/schemas/image                                                                                                                                                                          |
| size             | 544539136                                                                                                                                                                                  |
| status           | active                                                                                                                                                                                     |
| tags             |                                                                                                                                                                                            |
| updated_at       | 2020-08-25T12:04:50Z                                                                                                                                                                       |
| virtual_size     | None                                                                                                                                                                                       |
| visibility       | public                                                                                                                                                                                     |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

- Confirm upload of the image and validate attributes:
```
$ openstack image list

os@controller:~$ openstack image list
+--------------------------------------+------------------------------+--------+
| ID                                   | Name                         | Status |
+--------------------------------------+------------------------------+--------+
| 982e4322-d3b8-4b20-96e9-71d4b7870a6b | bionic-server-cloudimg-amd64 | active |
| 1211d636-99bc-40f6-a139-58a7502b30e9 | cirros-0.5.1-x86_64          | active |
| 0af72659-a5c0-40a3-8b55-0b398e6b94f2 | focal-server-cloudimg-amd64  | active |
+--------------------------------------+------------------------------+--------+
```


[Previous](keystone.md#keystone-identity-service)
[Home](../../README.md#install-openstack-services)
[Next](placement.md#placement-service)