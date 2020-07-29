# OpenStack Installation Guide

## Initial Setup
[SSH Configuration](https://github.com/kukkalli/OpenStack/blob/master/initial-setup/ssh.md#setup-ssh-keys)

## Environment Setup
[Host Networking](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/host-networking.md#host-networking)


### OpenStack packages
#### Enable the repository for Ubuntu Cloud Archive
```
# add-apt-repository cloud-archive:train
```

#### Finalize the installation
```
# apt update && apt dist-upgrade
```


#### Install the OpenStack client
```
# apt install python3-openstackclient
```

