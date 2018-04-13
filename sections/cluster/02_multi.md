!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Multi-Node Cluster


!SLIDE noprint
# Graphite Multi-Node Cluster

<center><img src="./_images/graphite-big-cluster.png" style="width:55%"/></center>


!SLIDE printonly
# Graphite Multi-Node Cluster

<center><img src="./_images/graphite-big-cluster.png" style="width:460px"/></center>


!SLIDE small
# Multiple Graphite-Web Instances

For failover purposes of Graphite-Web we have to edit `CLUSTER_SERVERS`.

File: **/opt/graphite/webapp/graphite/local_settings.py**

    @@@Sh
    CLUSTER_SERVERS = ["192.168.56.101", "192.168.56.102"]

And reload Apache:

    @@@Sh
    # systemctl reload httpd.service


!SLIDE small
# Multiple Whisper Directories

It's possible to use different storage directories for each Carbon Cache. We have to adjust the configuration in **/opt/graphite/conf/carbon.conf**:

    @@@Sh
    [cache]
    LOCAL_DATA_DIR = /opt/graphite/storage/whisper1/

    [cache:b]
    LOCAL_DATA_DIR = /opt/graphite/storage/whisper2/

And to restart the Cache daemons:

    @@@Sh
    # systemctl restart carbon-cache-a.service
    # systemctl restart carbon-cache-b.service


!SLIDE small
# Multiple Whisper Directories with Graphite-Web

The configuration for Graphite-Web has to be changed in order to support different storage directories.

File: **/opt/graphite/webapp/graphite/local_settings.py**

    @@@Sh
    STANDARD_DIRS = [ "/opt/graphite/storage/whisper1", \
      "/opt/graphite/storage/whisper2" ]

Aftwards Apache requires a reload:

    @@@Sh
    # systemctl reload httpd.service


!SLIDE small
# Graphite Multi-Node Cluster with collectd

The *write_graphite* plugin of collectd is able to put metrics to all relays, but we have to edit the configuration for that and to restart collectd afterwards.

File: **/etc/collectd.d/write_graphite.conf**

    @@@Sh
    <Plugin write_graphite>
      <Node "graphing1">
        ...
      </Node>
      <Node "graphing2">
        Host "192.168.56.102"
        Port "2003"
        Protocol "tcp"
        ReconnectInterval 0
        LogSendErrors true
        Prefix "collectd."
        Postfix ""
        StoreRates true
        AlwaysAppendDS false
        EscapeCharacter "_"
        SeparateInstances false
        PreserveSeparator false
        DropDuplicateFields false
      </Node>
    </Plugin>
