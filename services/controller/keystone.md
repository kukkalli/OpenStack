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

The updated ```keystone.conf``` file can be found at: [keystone.conf](keystone.conf)

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
keystone-manage bootstrap --bootstrap-password tuckn2020 --bootstrap-admin-url http://10.10.0.21:5000/v3/ --bootstrap-internal-url http://10.10.0.21:5000/v3/ --bootstrap-public-url http://10.10.0.21:5000/v3/ --bootstrap-region-id TUCKN
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
export OS_AUTH_URL=http://10.10.0.21:5000/v3
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
export OS_AUTH_URL=http://10.10.0.21:5000/v3
export OS_IDENTITY_API_VERSION=3
```

### Create a domain, projects, users, and roles
- This guide uses a service project that contains a unique user for each service that you add to your environment. Create the service project:
```
os@controller:~$ openstack project create --domain tuc --description "Service Project" service
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Service Project                  |
| domain_id   | tuc                              |
| enabled     | True                             |
| id          | 6b1a95ba051547a29b385b9b12262806 |
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
os@controller:~$ openstack --os-auth-url http://10.10.0.21:5000/v3 --os-project-domain-name TUC --os-user-domain-name TUC --os-project-name admin --os-username admin token issue
Password:
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2020-08-24T18:01:34+0000                                                                                                                                                                |
| id         | gAAAAABfQ_JuVn0nMtNeXXNbdDOEdO7DpcJ4ztHvZlYnT4FLpCoXyQV2AQWFVMvhe9cx_o5f-oOTurCf_VE5rELoQCswuT10EJruAceF4n9ATnDrPh2DQIVFOqg0ieC5LPH6Ygp2CympVdv_93gfjMim9jCUjUsKrEXu8IeJb9DosinTuY4dpHg |
| project_id | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                                                        |
| user_id    | c349d1ffd3b74fe68d1aa49d71cfce1b                                                                                                                                                        |
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
export OS_AUTH_URL=http://10.10.0.21:5000/v3
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
os@controller:~$ openstack token issue
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2020-08-24T18:02:49+0000                                                                                                                                                                |
| id         | gAAAAABfQ_K59saD1KSqEBKaQMwmF1X7UrIkr_rBmM8zoMGOr9XhG98YNRU5ETSG9zLltWDOZRfvxB_YqQ5sqL5Odok-BIk5HgYvWBXvwSKJtaKDfVp6EQMsR_dsOsljYU-_DXjtyywHhF4zW4ZppjRCNVe368Es3ZuzcYIBc96oSI9BdZluKIk |
| project_id | 6b5e1b91ce6d40a082004e7b60b614c4                                                                                                                                                        |
| user_id    | c349d1ffd3b74fe68d1aa49d71cfce1b                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```


[Previous](../../environment-setup/etcd.md#etcd)
[Home](../../README.md#install-openstack-services)
[Next](glance.md#glance-image-service)