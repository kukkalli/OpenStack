## SQL Database
### Install the packages
```
# apt-get install software-properties-common
# apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
# add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror2.hs-esslingen.de/mariadb/repo/10.4/ubuntu bionic main'
# apt update
# apt install mariadb-server python3-pymysql

```Copy below```
apt-get install software-properties-common
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror2.hs-esslingen.de/mariadb/repo/10.4/ubuntu bionic main'
apt update
apt install mariadb-server python3-pymysql
```

Create and edit the ```/etc/mysql/mariadb.conf.d/99-openstack.cnf``` file and complete the following actions

- Create a ```[mysqld]``` section, and set the bind-address key to the management IP address of the controller node to enable access by other nodes via the management network. Set additional keys to enable useful options and the UTF-8 character set:

```bash
[mysqld]
bind-address = 10.10.0.21

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```

### Finalize installation
Restart the database service:
```
# service mysql restart
```
Secure the database service by running the ```mysql_secure_installation``` script
```
# mysql_secure_installation
```

[Previous](packages.md#openstack-packages)
[Home](../README.md#environment-setup)
[Next](rabbitmq.md#message-queue)