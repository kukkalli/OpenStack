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

[Previous](ntp.md#network-time-protocol-ntp)
[Home](../README.md#environment-setup)
[Next](sql.md#sql-database)