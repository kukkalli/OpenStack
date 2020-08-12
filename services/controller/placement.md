## Placement Service

### Install and configure Placement
#### Prerequisites
##### Create Database
- Login into SQL
```
# mysql
```

- Create the placement database:
```
MariaDB [(none)]> CREATE DATABASE placement;
```

- Grant proper access to the database:
```
MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY 'PLACEMENT_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY 'PLACEMENT_DBPASS';

e.g.
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY 'tuckn2020';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY 'tuckn2020';
```
- Exit the database access client.

#### Configure User and Endpoints
- Source the admin credentials
```
$ . admin-openrc
```

- Create a Placement service user using your chosen PLACEMENT_PASS:
```
$ openstack user create --domain default --password-prompt placement

e.g.
openstack user create --domain tuc --password-prompt placement

os@controller:~$ openstack user create --domain tuc --password-prompt placement
User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | tuc                              |
| enabled             | True                             |
| id                  | dbed7c5ab7d04b70961a06a81c81ae2a |
| name                | placement                        |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

- Add the Placement user to the ```service``` project with the ```admin``` role:
```
$ openstack role add --project service --user placement admin
```

- Create the Placement API entry in the ```service``` catalog:
```
$ openstack service create --name placement --description "Placement Service API" placement

os@controller:~$ openstack service create --name placement --description "Placement Service API" placement
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Placement Service API            |
| enabled     | True                             |
| id          | fe7fb0c8102845c4824d46ae7f092807 |
| name        | placement                        |
| type        | placement                        |
+-------------+----------------------------------+
```

- Create the Placement API service endpoints:
```
$ openstack endpoint create --region RegionOne placement public http://controller:8778
$ openstack endpoint create --region RegionOne placement internal http://controller:8778
$ openstack endpoint create --region RegionOne placement admin http://controller:8778

e.g.
openstack endpoint create --region TUCKN placement public http://controller:8778
openstack endpoint create --region TUCKN placement internal http://controller:8778
openstack endpoint create --region TUCKN placement admin http://controller:8778


os@controller:~$ openstack endpoint create --region TUCKN placement public http://controller:8778
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | e345bbe786f54d729e8cbe89900e3688 |
| interface    | public                           |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | fe7fb0c8102845c4824d46ae7f092807 |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN placement internal http://controller:8778
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 51c151069ba645cba5a7c57ba86e606b |
| interface    | internal                         |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | fe7fb0c8102845c4824d46ae7f092807 |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+
os@controller:~$ openstack endpoint create --region TUCKN placement admin http://controller:8778
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | d6e1b20402234b7ca6211f1343c6a590 |
| interface    | admin                            |
| region       | TUCKN                            |
| region_id    | TUCKN                            |
| service_id   | fe7fb0c8102845c4824d46ae7f092807 |
| service_name | placement                        |
| service_type | placement                        |
| url          | http://controller:8778           |
+--------------+----------------------------------+
```

### Install and configure components
- Install the packages:
```
# apt install placement-api
```
- Edit the ```/etc/placement/placement.conf``` file and complete the following actions:
```
[placement_database]
# ...
connection = mysql+pymysql://placement:tuckn2020@controller/placement

[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = TUC
user_domain_name = TUC
project_name = service
username = placement
password = tuckn2020
```
- Populate the ```placement``` database:
```
# su -s /bin/sh -c "placement-manage db sync" placement
```

- Reload the web server to adjust to get new configuration settings for placement.
```
# service apache2 restart
```

### Verify Installation

- Perform status checks to make sure everything is in order:
```
# placement-status upgrade check

root@controller:~# placement-status upgrade check
+----------------------------------+
| Upgrade Check Results            |
+----------------------------------+
| Check: Missing Root Provider IDs |
| Result: Success                  |
| Details: None                    |
+----------------------------------+
| Check: Incomplete Consumers      |
| Result: Success                  |
| Details: None                    |
+----------------------------------+
```


[Previous](glance.md#glance-image-service)
[Home](../../README.md#install-openstack-services)
[Next](../nova.md#nova-compute-service)