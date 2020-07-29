## OpenStack packages
### Enable the repository for Ubuntu Cloud Archive
```
# add-apt-repository cloud-archive:train
```

### Finalize the installation
```
# apt update && apt dist-upgrade
```

### Install the OpenStack client
```
# apt install python3-openstackclient
```

[Previous](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/ntp.md#network-time-protocol-ntp)
[Home](https://github.com/kukkalli/OpenStack#environment-setup)
[Next](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/sql.md#sql-database)