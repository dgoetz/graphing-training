!SLIDE
# collectd

* Collects data
* Variety of ways to store data
 * RRD
 * OpenTSDB
 * HTTP
 * Redis
 * Graphite (InfluxDB)
 * ...
* Wide choice of plugins
 * CPU, Memory, Load, Network, ...
 * MySQL, PostgreSQL, Apache, Bind, ...
 * cURL, Exec, Perl, Python, Java, ...

~~~SECTION:handouts~~~
****

Project: https://collectd.org<br/>
Docs: https://collectd.org/documentation.shtml

~~~ENDSECTION~~~


!SLIDE small
# collectd

collectd is a daemon that runs on your server and collects periodically performance data about several parts of the system. One of many plugins is "write_graphite" which lets you send those collected data to a Graphite server. 

collectd provides a lot of plugins by default. Each plugin serves a specific set of data and mostly can be configured to fit your needs. Some plugins differ from others, for example there are plugins which are just for forwarding the statistics to receivers like Graphite. There are also plugins which enable you to write your own plugins in languages like Perl, Python or Java.

With the included SNMP support collectd stays not limited to the host it's running. You can get performance counters of the network activity from switches, routers or other devices that are capable of SNMP.

~~~SECTION:handouts~~~
****

Website: https://collectd.org

~~~ENDSECTION~~~


!SLIDE small
# collectd Installation

collectd can be installed via packages. You should take care that you install a version >= 5.0, because the Graphite plugin in earlier versions had to be configured in a different way than it is described here.

    @@@Sh
    # yum -y install collectd

After the installation you should edit **/etc/collectd.conf**. It should include the following content:

    @@@Sh
    Hostname            "graphing1"
    FQDNLookup          false # default: true
    Interval            10
    MaxReadInterval     86400
    Timeout             2
    ReadThreads         5
    WriteThreads        5
    Include             "/etc/collectd.d"

Start collectd with systemd:

    @@@Sh
    # systemctl enable collectd.service --now

**Note:** collectd is already pre-installed on "graphing1.localdomain".


!SLIDE
# collectd Plugins

Plugins are enabled with the phrase `LoadPlugin <plugin>`. You can find a list of all collectd plugins here: https://collectd.org/wiki/index.php/Table_of_Plugins. 
This page also includes the documentation of each plugin.

By creating config files inside **/etc/colletcd.d/** the configuration of plugins will be way more tidy than configuring them all in one single file.


!SLIDE
# collectd DF Plugin

This example shows the content of the "DF" plugin, all other plugins are configured in the same manner.

File: **/etc/collectd.d/df.conf**

    @@@Sh
    LoadPlugin df
    
    <Plugin df>
      FSType "rootfs"
      FSType "xfs"
      IgnoreSelected false
      ReportByDevice false
      ReportInodes true
      ValuesAbsolute true
      ValuesPercentage false
    </Plugin>

The configuration of plugins is in many cases optional. In some cases it's sufficient to just load the plugin without any configuration. Examples for this are "CPU", "Load" or "Memory".


!SLIDE small
# Storage Schema for collectd

To store the data correctly, you need to configure a proper Carbon storage schema for data coming from collectd. The frequency which is configured here must be the same as configured in **collectd.conf**.

File: **/opt/graphite/conf/storage-schemas.conf**

    @@@Sh
    [...]

    [collectd]
    pattern = ^collectd\.
    retentions = 10s:5d

    [...]

When `LOG_CREATES` in **carbon.conf** is set to `True`, you can follow the logging of Carbon Cache in **/var/log/carbon/creates.log** to track if your Whisper files are being generated with the correct storage schema.

    @@@Sh
    new metric collectd.graphing1.interface-enp0s3.\
      if_dropped.tx matched schema collectd
    new metric collectd.graphing1.interface-enp0s3.\
      if_dropped.tx matched schema default


!SLIDE small
# collectd Graphite Plugin

Sending the collected data to Graphite is not more than enabling and configuring the appropriate plugin.

File: **/etc/collectd.d/write_graphite.conf**

    @@@Sh
    LoadPlugin write_graphite
     
    <Plugin write_graphite>
      <Node "graphing1">
        Host "localhost"
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


!SLIDE small
# Restart collectd Daemon

After configuration changes collectd needs to be restarted:

    @@@Sh
    # systemctl restart collectd.service
