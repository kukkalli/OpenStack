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
  $ openstack user create --domain tuc --password-prompt glance
  User Password:
  Repeat User Password:
  +---------------------+----------------------------------+
  | Field               | Value                            |
  +---------------------+----------------------------------+
  | domain_id           | tuc                              |
  | enabled             | True                             |
  | id                  | afb42f41b46b451e930046edfa716b81 |
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
  $ openstack service create --name glance --description "OpenStack Image Service" image
  +-------------+----------------------------------+
  | Field       | Value                            |
  +-------------+----------------------------------+
  | description | OpenStack Image Service          |
  | enabled     | True                             |
  | id          | e2bdd4a15c804fbdbd8c8b601286f926 |
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
openstack endpoint create --region TUCKN image public http://controller:9292
openstack endpoint create --region TUCKN image internal http://controller:9292
openstack endpoint create --region TUCKN image admin http://controller:9292

output:
os@controller:~$ openstack endpoint create --region TUCKN image public http://controller:9292
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | f9234d8b4bf740c0b4c156f274a64ff8 |
| interface    | public                           |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | e2bdd4a15c804fbdbd8c8b601286f926 |
| service_name | glance                           |
| service_type | image                            |
| url          | http://controller:9292           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN image internal http://controller:9292
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 4cf3506363954a4680c81a83e0cdcd06 |
| interface    | internal                         |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | e2bdd4a15c804fbdbd8c8b601286f926 |
| service_name | glance                           |
| service_type | image                            |
| url          | http://controller:9292           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN image admin http://controller:9292
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 45bf1bc39d6a459b8ce83f4fea6d49a8 |
| interface    | admin                            |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | e2bdd4a15c804fbdbd8c8b601286f926 |
| service_name | glance                           |
| service_type | image                            |
| url          | http://controller:9292           |
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
  connection = mysql+pymysql://glance:tuckn2020@controller/glance
  ```
  - In the ```[keystone_authtoken]``` and ```[paste_deploy]``` sections, configure Identity service access:
  ```bash
  [keystone_authtoken]
  # ...
  www_authenticate_uri = http://controller:5000
  auth_url = http://controller:5000
  memcached_servers = controller:11211
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
$ glance image-create --name "cirros" --file cirros-0.5.1-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public

os@controller:~$ glance image-create --name "cirros-0.5.1-x86_64" --file cirros-0.5.1-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public
+------------------+----------------------------------------------------------------------------------+
| Property         | Value                                                                            |
+------------------+----------------------------------------------------------------------------------+
| checksum         | 1d3062cd89af34e419f7100277f38b2b                                                 |
| container_format | bare                                                                             |
| created_at       | 2020-07-30T09:54:37Z                                                             |
| disk_format      | qcow2                                                                            |
| id               | dd072d40-6881-40ba-a9ef-dc01882ca753                                             |
| min_disk         | 0                                                                                |
| min_ram          | 0                                                                                |
| name             | cirros-0.5.1-x86_64                                                              |
| os_hash_algo     | sha512                                                                           |
| os_hash_value    | 553d220ed58cfee7dafe003c446a9f197ab5edf8ffc09396c74187cf83873c877e7ae041cb80f3b9 |
|                  | 1489acf687183adcd689b53b38e3ddd22e627e7f98a09c46                                 |
| os_hidden        | False                                                                            |
| owner            | 8980116a238643deaa65db860bfeabf7                                                 |
| protected        | False                                                                            |
| size             | 16338944                                                                         |
| status           | active                                                                           |
| tags             | []                                                                               |
| updated_at       | 2020-07-30T09:54:37Z                                                             |
| virtual_size     | Not available                                                                    |
| visibility       | public                                                                           |
+------------------+----------------------------------------------------------------------------------+
```

- Confirm upload of the image and validate attributes:
```
$ glance image-list

os@controller:~$ glance image-list
+--------------------------------------+---------------------+
| ID                                   | Name                |
+--------------------------------------+---------------------+
| dd072d40-6881-40ba-a9ef-dc01882ca753 | cirros-0.5.1-x86_64 |
+--------------------------------------+---------------------+
```


[Previous](keystone.md#keystone-identity-service)
[Home](../../README.md#install-openstack-services)
[Next](placement.md#placement-service)