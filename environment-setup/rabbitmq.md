## Message Queue
### Install and configure components
#### Install the package:
```
# apt install rabbitmq-server
```

#### Add the ```openstack``` user:
```
# rabbitmqctl add_user openstack RABBIT_PASS

e.g.
# rabbitmqctl add_user openstack tuckn2020
Creating user "openstack"
```
Replace RABBIT_PASS with a suitable password.
#### Permit configuration, write, and read access for the ```openstack``` user:
```
# rabbitmqctl set_permissions openstack ".*" ".*" ".*"
Setting permissions for user "openstack" in vhost "/"
```

[Previous](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/sql.md#sql-database)
[Home](https://github.com/kukkalli/OpenStack#environment-setup)
[Next](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/sql.md#sql-database)