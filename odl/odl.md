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
featuresBoot = 661cff14-76f4-4222-add7-5eba0313755f,,odl-restconf-all,odl-netconf-topology,odl-mdsal-all,odl-mdsal-apidocs
#,odl-openflowplugin-app-southbound-cli,odl-openflowjava-protocol,odl-openflowplugin-flow-services,odl-openflowplugin-southbound,odl-openflowplugin-app-forwardingrules-manager,features-openflowplugin-extension,odl-openflowplugin-app-notifications,odl-openflowplugin-app-topology,odl-openflowplugin-app-topology-lldp-discovery,odl-openflowplugin-app-forwardingrules-sync,odl-openflowplugin-flow-services-rest,features-openflowplugin,odl-openflowplugin-app-topology-manager,odl-mdsal-model-odl-l2-types
```

[previous](java.md)
[Home](../opendaylight.md)