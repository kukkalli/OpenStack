## Memcached

### Install and configure components
- Install the packages

```
# apt install memcached python3-memcache
```

- Edit the ```/etc/memcached.conf``` file and configure the service to use the management IP address of the controller node.
```bash
-l 10.10.0.21
```

### Finalize installation
- Restart the Memcached service
```
# service memcached restart
```

[Previous](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/rabbitmq.md#message-queue)
[Home](https://github.com/kukkalli/OpenStack#environment-setup)
[Next](https://github.com/kukkalli/OpenStack/blob/master/environment-setup/etcd.md#etcd)