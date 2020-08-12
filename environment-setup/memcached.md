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

[Previous](rabbitmq.md#message-queue)
[Home](../README.md#environment-setup)
[Next](etcd.md#etcd)