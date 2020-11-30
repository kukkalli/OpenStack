## OpenStack Dashboard (Horizon)

### Install and configure components

```
# apt install openstack-dashboard
```

- Edit the ```/etc/openstack-dashboard/local_settings.py``` file and complete the following actions:
```python
ALLOWED_HOSTS = ['*']

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'controller:11211',
    }
}
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

OPENSTACK_HOST = "10.10.0.21"
OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST

OPENSTACK_NEUTRON_NETWORK = {
    'enable_auto_allocated_network': False,
    'enable_distributed_router': False,
    'enable_fip_topology_check': False,
    'enable_ha_router': True,
    'enable_ipv6': True,
    # TODO(amotoki): Drop OPENSTACK_NEUTRON_NETWORK completely from here.
    # enable_quotas has the different default value here.
    'enable_quotas': True,
    'enable_rbac_policy': True,
    'enable_router': True,

    'default_dns_nameservers': [],
    'supported_provider_types': ['*'],
    'segmentation_id_range': {},
    'extra_provider_types': {},
    'supported_vnic_types': ['*'],
    'physical_networks': ['tuc11'],

    'enable_lb': True,
    'enable_firewall': True,
    'enable_vpn': False,
}

TIME_ZONE = "UTC"

AVAILABLE_THEMES = [
    ('default', 'Default', 'themes/default'),
#    ('material', 'Material', 'themes/material'),
]

DEFAULT_THEME = 'default'

OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 3,
}

OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_KEYSTONE_DOMAIN_DROPDOWN = True

OPENSTACK_KEYSTONE_DOMAIN_CHOICES = (
  ('TUC', 'TUC'),
)

OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "TUC"

OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"

SHOW_OPENRC_FILE = True

SHOW_OPENRC_FILE = True

OPENSTACK_KEYSTONE_BACKEND = {
    'name': 'native',
    'can_edit_user': True,
    'can_edit_group': True,
    'can_edit_project': True,
    'can_edit_domain': True,
    'can_edit_role': True,
}

IMAGE_CUSTOM_PROPERTY_TITLES = {
    "architecture": _("Architecture"),
    "kernel_id": _("Kernel ID"),
    "ramdisk_id": _("Ramdisk ID"),
    "image_state": _("Euca2ools state"),
    "project_id": _("Project ID"),
    "image_type": _("Image Type"),
}


API_RESULT_LIMIT = 1000
API_RESULT_PAGE_SIZE = 20

SWIFT_FILE_TRANSFER_CHUNK_SIZE = 512 * 1024

INSTANCE_LOG_LENGTH = 35

DROPDOWN_MAX_ITEMS = 30

ALLOWED_PRIVATE_SUBNET_CIDR = {'ipv4': [], 'ipv6': []}

```
The updated ```local_settings.py``` file can be found at: [local_settings.py](local_settings.py)

### Finalize installation

```
# systemctl reload apache2.service
```

### Login using URL
```
http://10.10.0.21/horizon
```

### Credentials for login
```
Domain  : TUC
Username: admin
Password: tuckn2020
```

[Neutron Home](../neutron.md#neutron-networking-service)
[Home](../../README.md#install-openstack-services)
[Next](../create-vm.md#create-vms-on-cli)