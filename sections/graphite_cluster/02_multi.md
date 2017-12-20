!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Multi-Node Cluster


!SLIDE noprint
# Graphite Multi-Node Cluster

<center><img src="./_images/graphite-big-cluster.png" style="width:55%"/></center>


!SLIDE printonly
# Graphite Multi-Node Cluster

<center><img src="./_images/graphite-big-cluster.png" style="width:460px"/></center>


!SLIDE small
# Graphite Cluster - Multiple Graphite Web Instances

For failover purposes of Graphite Web we have to edit `/opt/graphite/webapp/graphite/local_settings.py`:

    @@@Sh
    CLUSTER_SERVERS = ["192.168.56.101", "192.168.56.102"]

And reload Apache:

    @@@Sh
    # systemctl reload httpd.service


!SLIDE small
# Graphite Cluster - Multiple Whisper Directories

It's possible to use different storage directories for each Carbon Cache. We have to adjust the configuration in `/opt/graphite/conf/carbon.conf` and to restart the Cache daemons.

    @@@Sh
    [cache]
    LOCAL_DATA_DIR = /opt/graphite/storage/whisper1/

    # /opt/graphite/bin/carbon-cache.py --instance=a stop
    # /opt/graphite/bin/carbon-cache.py --instance=a start
    Starting carbon-cache (instance a)

    [cache:b]
    LOCAL_DATA_DIR = /opt/graphite/storage/whisper2/

    # /opt/graphite/bin/carbon-cache.py --instance=b stop
    # /opt/graphite/bin/carbon-cache.py --instance=b start
    Starting carbon-cache (instance b)

And also the configuration for Graphite Web in `/opt/graphite/webapp/graphite/local_settings.py` and reload Apache:

    @@@Sh
    STANDARD_DIRS = [ "/opt/graphite/storage/whisper1", \
    "/opt/graphite/storage/whisper2" ]

    # systemctl reload httpd.service


!SLIDE small
# Graphite Multi-Node Cluster with collectd

The `write_graphite` plugin of collectd is able to put metrics to all relays, but we have to edit the configuration for that and to restart collectd afterwards.

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
        StoreRates true
        AlwaysAppendDS false
        EscapeCharacter "_"
        SeparateInstances true
        PreserveSeparator false
        DropDuplicateFields false
      </Node>
    </Plugin>
