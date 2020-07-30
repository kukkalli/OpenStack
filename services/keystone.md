## Keystone (Identity Service)
### Install and configure
#### Prerequisites
- Use the database access client to connect to the database server as the ```root``` user:

```
# mysql
```

- Create the ```keystone``` database:
```
MariaDB [(none)]> CREATE DATABASE keystone;

e.g.
CREATE DATABASE keystone;
```

- Grant proper access to the ```keystone``` database:
```
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';

e.g.
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'tuckn2020';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'tuckn2020';
```

- Exit the database access client.

#### Install and configure components
- Run the following command to install the packages
```
# apt install keystone
```

- Edit the ```/etc/keystone/keystone.conf``` file and complete the following actions
  - In the ```[database]``` section, configure database access
  ```bash
  [database]
  # ...
  connection = mysql+pymysql://keystone:tuckn2020@controller/keystone
  ```
  - In the ```[identity]``` section, configure ```default_domain_id```:
  ```bash
  [identity]
  default_domain_id = tuc
  ```
  - In the ```[token]``` section, configure the Fernet token provider:
  ```bash
  [token]
  # ...
  provider = fernet
  ```

The updated ```keystone.conf``` file can be found at: [keystone.conf](https://github.com/kukkalli/OpenStack/blob/master/services/keystone.conf)

- Populate the Identity service database:
```
# su -s /bin/sh -c "keystone-manage db_sync" keystone
```

- Initialize Fernet key repositories:
```
# keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
# keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

## copy commands
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

- Bootstrap the Identity service:
```
# keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

e.g.
keystone-manage bootstrap --bootstrap-password tuckn2020 --bootstrap-admin-url http://controller:5000/v3/ --bootstrap-internal-url http://controller:5000/v3/ --bootstrap-public-url http://controller:5000/v3/ --bootstrap-region-id TUCKN
```

#### Configure the Apache HTTP server
- Edit the ```/etc/apache2/apache2.conf``` file and configure the ```ServerName``` option to reference the controller node:
```bash
ServerName controller
```

#### Finalize the installation
- Restart the Apache service:
```
# service apache2 restart
```

- Configure the administrative account by setting the proper environmental variables:
```
$ export OS_USERNAME=admin
$ export OS_PASSWORD=ADMIN_PASS
$ export OS_PROJECT_NAME=admin
$ export OS_USER_DOMAIN_NAME=Default
$ export OS_PROJECT_DOMAIN_NAME=Default
$ export OS_AUTH_URL=http://controller:5000/v3
$ export OS_IDENTITY_API_VERSION=3

e.g.
export OS_USERNAME=admin
export OS_PASSWORD=tuckn2020
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
```

- Change Domain name to ```TUC```:
```
openstack domain set --name TUC --description "The TU-Chemnitz Domain" tuc
```

- Update environmental variables:
```
export OS_USERNAME=admin
export OS_PASSWORD=tuckn2020
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=TUC
export OS_PROJECT_DOMAIN_NAME=TUC
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
```

### Create a domain, projects, users, and roles
- This guide uses a service project that contains a unique user for each service that you add to your environment. Create the service project:
```
$ openstack project create --domain tuc --description "Service Project" service
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Service Project                  |
| domain_id   | tuc                              |
| enabled     | True                             |
| id          | b72c5c7076b942308017bdbc4c84d583 |
| is_domain   | False                            |
| name        | service                          |
| options     | {}                               |
| parent_id   | tuc                              |
| tags        | []                               |
+-------------+----------------------------------+
```

### Verify operation
- Unset the temporary ```OS_AUTH_URL``` and ```OS_PASSWORD``` environment variable:
```
$ unset OS_AUTH_URL OS_PASSWORD
```

- As the admin user, request an authentication token:

```
$ openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name TUC --os-user-domain-name TUC --os-project-name admin --os-username admin token issue
Password:
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2020-07-29T16:45:10+0000                                                                                                                                                                |
| id         | gAAAAABfIZmGpsn--18Yuvk0JCC64JQOTL1Mrjw8RmkANV_3MDt7SGtOGMjLATpnhe0VCndSyTeV8VfKL_4zxLgBy6WPFGlpAxPMliRW5ALn6h8apGAc_omoHk3RRUGApt0O6XrHOlTzPIAeYJFjAF1dZ35PQFSsnb77cNLRX2ortkPmbD2uea8 |
| project_id | 8980116a238643deaa65db860bfeabf7                                                                                                                                                        |
| user_id    | 4b6fd7b359b64da68048873da01eb0d0                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

###  Create OpenStack client environment scripts

- Create and edit the ```admin-openrc``` file and add the following content:
```
export OS_PROJECT_DOMAIN_NAME=TUC
export OS_USER_DOMAIN_NAME=TUC
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=tuckn2020
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```

#### Using the scripts
- Load the ```admin-openrc``` file
```
$ . admin-openrc
```

- Request an authentication token:
```
$ openstack token issue
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2020-07-29T16:47:35+0000                                                                                                                                                                |
| id         | gAAAAABfIZoXdl93LlBUntrgz_APKB6L-1axRNlFDmx6wmz9awjm9iMMKuV6Nk8fq2UN-ZeDRAikxTz6qh8LWhtunvuaDqjJHpz5qFJ_JfMGaYAZ18tytLAQfl0-dRkggj2K8fqTcKhjMiFPGbYaEPxsY95PuOW_9DC79By0Ug-Fk8GPJqcP4TM |
| project_id | 8980116a238643deaa65db860bfeabf7                                                                                                                                                        |
| user_id    | 4b6fd7b359b64da68048873da01eb0d0                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```


[Previous](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/etcd.md#etcd)
[Home](https://github.com/kukkalli/OpenStack#install-openstack-services)
[Next](https://github.com/kukkalli/OpenStack/blob/master/services/glance.md#glance-image-service)

