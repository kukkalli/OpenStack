## OpenDaylight Fluorine

### Download OpenDaylight package
```
$ wget https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/karaf/0.9.3/karaf-0.9.3.tar.gz
```
Note: wget should be installed

### Unpack the tar
```
$ tar xfvz karaf-0.9.3.tar.gz
```

### Verify Karaf is functional and clean all pre-installed features
```
sdn@sdnc:~$ cd karaf-0.9.3/bin/
sdn@sdnc:~/karaf-0.9.3/bin$ ./status
/home/sdn/karaf-0.9.3/data/port shutdown port file doesn't exist. The container is not running.
sdn@sdnc:~/karaf-0.9.3/bin$ ./karaf clean
Apache Karaf starting up. Press Enter to open the shell now...
100% [========================================================================]

Karaf started in 0s. Bundle stats: 10 active, 10 total

    ________                       ________                .__  .__       .__     __
    \_____  \ ______   ____   ____ \______ \ _____  ___.__.|  | |__| ____ |  |___/  |_
     /   |   \\____ \_/ __ \ /    \ |    |  \\__  \<   |  ||  | |  |/ ___\|  |  \   __\
    /    |    \  |_> >  ___/|   |  \|    `   \/ __ \\___  ||  |_|  / /_/  >   Y  \  |
    \_______  /   __/ \___  >___|  /_______  (____  / ____||____/__\___  /|___|  /__|
            \/|__|        \/     \/        \/     \/\/            /_____/      \/


Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit '<ctrl-d>' or type 'system:shutdown' or 'logout' to shutdown OpenDaylight.

opendaylight-user@root>feature:list -i
Name                                 │ Version │ Required │ State   │ Repository                           │ Description
─────────────────────────────────────┼─────────┼──────────┼─────────┼──────────────────────────────────────┼──────────────────────────────────────────────────
aries-proxy                          │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Aries Proxy
aries-blueprint                      │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Aries Blueprint
feature                              │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Features Support
shell                                │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Karaf Shell
shell-compat                         │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Karaf Shell Compatibility
deployer                             │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Karaf Deployer
bundle                               │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide Bundle support
config                               │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide OSGi ConfigAdmin support
diagnostic                           │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide Diagnostic support
instance                             │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide Instance support
jaas                                 │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide JAAS support
log                                  │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide Log support
package                              │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Package commands and mbeans
service                              │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide Service support
system                               │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide System support
kar                                  │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide KAR (KARaf archive) support
ssh                                  │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide a SSHd server on Karaf
management                           │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Provide a JMX MBeanServer and a set of MBeans in
wrap                                 │ 0.0.0   │          │ Started │ standard-4.1.7                       │ Wrap URL handler
standard                             │ 4.1.7   │          │ Started │ standard-4.1.7                       │ Wrap feature describing all features part of a st
661cff14-76f4-4222-add7-5eba0313755f │ 0.0.0   │ x        │ Started │ edab05e8-21ee-472b-8152-d2b65259d98f │
opendaylight-user@root>
```
#### Logout
```
opendaylight-user@root>logout
sdn@sdnc:~/karaf-0.9.3/bin$
```

### Configure the features during boot
```
sdn@sdnc:~$ cd karaf-0.9.3/etc/
sdn@sdnc:~/karaf-0.9.3/etc$ nano org.apache.karaf.features.cfg
```
#### Edit the featuresBoot parameter by appending the additional boot values
```bash
featuresBoot = 661cff14-76f4-4222-add7-5eba0313755f,odl-restconf-all,odl-netconf-topology,odl-mdsal-all,odl-mdsal-apidocs,odl-openflowplugin-app-southbound-cli,odl-openflowplugin-flow-services,odl-openflowplugin-app-notifications,odl-openflowplugin-app-topology,odl-openflowplugin-app-topology-lldp-discovery,odl-openflowplugin-app-forwardingrules-sync,odl-openflowplugin-flow-services-rest,features-openflowplugin,odl-openflowplugin-app-topology-manager,odl-mdsal-model-odl-l2-types,odl-neutron-model,features-neutron-service,odl-neutron-service,odl-neutron-spi,odl-lispflowmapping-neutron,odl-neutron-northbound-api,odl-neutron-hostconfig-vpp


feature:install 661cff14-76f4-4222-add7-5eba0313755f odl-restconf-all odl-netconf-topology odl-mdsal-all odl-mdsal-apidocs odl-openflowplugin-app-southbound-cli odl-openflowplugin-flow-services odl-openflowplugin-app-notifications odl-openflowplugin-app-topology odl-openflowplugin-app-topology-lldp-discovery odl-openflowplugin-app-forwardingrules-sync odl-openflowplugin-flow-services-rest features-openflowplugin odl-openflowplugin-app-topology-manager odl-mdsal-model-odl-l2-types odl-neutron-model features-neutron-service odl-neutron-service odl-neutron-spi odl-lispflowmapping-neutron odl-neutron-northbound-api odl-neutron-hostconfig-vpp
```

#### Install Networking ODL package
```
pip3 install networking-odl

or

apt install python3-networking-odl
```

Edit `/etc/neutron/plugins/ml2# nano ml2_conf_odl.ini`
```
[DEFAULT]

[ml2_odl]

#
# From ml2_odl
#

# HTTP URL of OpenDaylight REST interface. (string value)
#url = <None>
url = http://10.10.0.10:8181/controller/nb/v2/neutron

# HTTP username for authentication. (string value)
#username = <None>
username = admin

# HTTP password for authentication. (string value)
#password = <None>
password = admin

# HTTP timeout in seconds. (integer value)
#timeout = 10

# Tomcat session timeout in minutes. (integer value)
#session_timeout = 30

# Sync thread timeout in seconds. (integer value)
#sync_timeout = 10

# Number of times to retry a row before failing. (integer value)
#retry_count = 5

# Journal maintenance operations interval in seconds. (integer value)
#maintenance_interval = 300

# Time to keep completed rows (in seconds).
# For performance reasons it's not recommended to change this from the default
# value (0) which indicates completed rows aren't kept.
# This value will be checked every maintenance_interval by the cleanup
# thread. To keep completed rows indefinitely, set the value to -1
# (integer value)
#completed_rows_retention = 0

# Test without real ODL. (boolean value)
#enable_lightweight_testing = false

# Name of the controller to be used for port binding. (string value)
#port_binding_controller = pseudo-agentdb-binding
port_binding_controller = pseudo-agentdb-binding

# Time in seconds to wait before a processing row is
# marked back to pending. (integer value)
#processing_timeout = 100

# Path for ODL host configuration REST interface (string value)
#odl_hostconf_uri = /restconf/operational/neutron:neutron/hostconfigs

# Poll interval in seconds for getting ODL hostconfig (integer value)
#restconf_poll_interval = 30

# Enable websocket for pseudo-agent-port-binding. (boolean value)
#enable_websocket_pseudo_agentdb = false

# Wait this many seconds before retrying the odl features fetch
# (integer value)
#odl_features_retry_interval = 5

# A list of features supported by ODL (list value)
#odl_features = <None>

# Enables the networking-odl driver to supply special neutron ports of
# "dhcp" type to OpenDaylight Controller for its use in providing DHCP
# Service. (boolean value)
#enable_dhcp_service = false

```

```
os@controller:~$ curl -u admin:admin http://10.10.0.10:8181/controller/nb/v2/neutron/networks
* Rebuilt URL to: admin:admin/
* Port number ended with 'a'
* Closing connection -1
curl: (3) Port number ended with 'a'
*   Trying 10.10.0.10...
* TCP_NODELAY set
* Connected to 10.10.0.10 (10.10.0.10) port 8181 (#0)
> GET /controller/nb/v2/neutron/networks HTTP/1.1
> Host: 10.10.0.10:8181
> User-Agent: curl/7.58.0
> Accept: */*
>
< HTTP/1.1 401 Unauthorized
< Cache-Control: must-revalidate,no-cache,no-store
< Content-Type: text/html;charset=iso-8859-1
< Content-Length: 271
<
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
<title>Error 401 Unauthorized</title>
</head>
<body><h2>HTTP ERROR 401</h2>
<p>Problem accessing /controller/nb/v2/neutron/networks. Reason:
<pre>    Unauthorized</pre></p>
</body>
</html>
* Connection #0 to host 10.10.0.10 left intact
os@controller:~$
```


```
feature:install odl-netvirt-openstack odl-dlux-core odl-mdsal-apidocs
```


```
curl -s -u admin:admin -X GET http://10.10.0.10:8181/restconf/operational/neutron:neutron/hostconfigs/ | python3 -m json.tool
```

[Home](../opendaylight.md)