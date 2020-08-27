## JDK 8
### Install OpenJDK-8

```
# apt install openjdk-8-jdk openjdk-8-jre
```

### Configure Java path in Ubuntu
Edit the file /etc/profile and add the following lines
```bash
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
```

### To Switch Java versions from other versions
```
root@sdnc:~# update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      auto mode
  1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode

Press <enter> to keep the current choice[*], or type selection number: 2
update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java to provide /usr/bin/java (java) in manual mode
```
### To verify the current version
```
root@sdnc:~# java -version
openjdk version "1.8.0_265"
OpenJDK Runtime Environment (build 1.8.0_265-8u265-b01-0ubuntu2~18.04-b01)
OpenJDK 64-Bit Server VM (build 25.265-b01, mixed mode)
```
[Previous](../opendaylight.md)
[Next](odl.md)