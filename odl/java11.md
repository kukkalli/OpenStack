## JDK 11
### Install OpenJDK-11

```
# apt install openjdk-11-jdk openjdk-11-jre
```

### Configure Java path in Ubuntu
Edit the file /etc/profile and add the following lines
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
JRE_HOME=/usr/lib/jvm/java-11-openjdk-amd64/jre
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
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment (build 11.0.8+10-post-Ubuntu-0ubuntu118.04.1)
OpenJDK 64-Bit Server VM (build 11.0.8+10-post-Ubuntu-0ubuntu118.04.1, mixed mode, sharing)
```
[Previous](../opendaylight.md)
[Next](odl.md)