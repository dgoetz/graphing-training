!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ StatsD

!SLIDE small smbullets
# StatsD

StatsD acts like a front-end proxy to Graphite. The major task of StatsD is to listen for metrics and periodically flush results to Graphite. Values of metrics that are being sent to StatsD may change during the time between receivement and forward to Graphite.

* Implementations in other languages
 * Python, C, Go, Ruby, Perl, Clojure

## Key concept:
* Buckets
 * This represents one metric.
* Values
 * The value of a metric. This may change during the duration of the metric in StatsD.
* Flush
 * Writing collected data to a backend.


~~~SECTION:handouts~~~

****

Project: https://github.com/etsy/statsd

~~~ENDSECTION~~~


!SLIDE noprint
# StatsD and Graphite

<center><img src="./_images/statsd-graphite.png"/></center>


!SLIDE printonly
# StatsD and Graphite

<center><img src="./_images/statsd-graphite.png" style="width:95%"/></center>


!SLIDE small
# StatsD Installation

StatsD requires NodeJS to run, this requirement is automatically fullfilled during the package installation:

    @@@Sh
    # yum install statsd


!SLIDE small
# Configuration

For a simple environment you need only a small piece of configuration. For everything else default settings are sufficient.

Make sure that `/etc/statsd/config.js` contains the following content:

    @@@Ruby
    {
      graphitePort: 2003
    , graphiteHost: "localhost"
    , port: 8125
    , backends: [ "./backends/graphite" ]
    , graphite: {
        legacyNamespace: false
      }
    }

To see all available settings, take a look into `exampleConfig.js`.

Run StatsD:

    @@@Sh
    # systemctl start statsd.service


!SLIDE small
# Metric Types (1/3)

StatsD supports multiple types of metrics. Depending on the metric type datapoints a different aggregation method is applied.

## Counting
A simple counter that adds a value to a bucket. On each flush interval the bucket gets written to Graphite and reset to 0.

    @@@Sh
    gitcommits:1|c

## Timing
The timing type comes in when measuring how long something took. For timers StatsD calculates automatically percentiles, average, standard deviation, sum, lower and upper bounds for each flush interval.

    @@@Sh
    request:480|ms


!SLIDE small
# Metric Types (2/3)

## Gauge
Arbitrary values that describe the current state of something. Gauge values are recorded as they are. By default, if a gauge metric does not change, StatsD will send the last value again to Graphite. This behaviour can be changed in the configuration. Gauge values can be increased or decreased instead of setting fixed values.

    @@@Sh
    processes:250|g
    processes:-20|g
    processes:+10|g

## Sets

When defining a set, StatsD counts all occurances of unique values between flush times. For example one could count the number of unique users logged in.

    @@@Sh
    userid:200|s


!SLIDE small
# Metric Types (3/3)

## Multi-Metric Packets

Multiple metrics can be sent to StatsD at once by seperating them with a newline. The size of one packet should not exceed the payload limit of your networks MTU.

    @@@Sh
    gitcommits:1|c\nprocesses:250|g\nresponse:200|s


!SLIDE small
# Storage Schema

The default flush interval of StatsD is 10 seconds. A proper storage schema needs to be created to handle this.

Edit `/opt/graphite/conf/storage-schemas.conf`

    @@@Ruby
    [statsd]
    pattern = ^stats
    retentions = 10s:1d,1m:7d


!SLIDE small
# Storage Aggregation

Since StatsD supports several aggregation methods those need to be handled by Graphite too.

Add the following to `/opt/graphite/conf/storage-aggregation.conf`. Keep in mind that patterns are applied from top to bottom and first match wins. You should keep the following rules above other rules.

    @@@Ruby
    [min_statsd]
    pattern = \.lower$
    xFilesFactor = 0.1
    aggregationMethod = min

    [max_statsd]
    pattern = \.upper(_\d+)?$
    xFilesFactor = 0.1
    aggregationMethod = max

    [sum_statsd]
    pattern = \.sum$
    xFilesFactor = 0
    aggregationMethod = sum

    [count_legacy]
    pattern = ^stats_counts.*
    xFilesFactor = 0
    aggregationMethod = sum


!SLIDE small
# Feed in your data

Everything should be ready now to accept your data. Before starting you should clear Whisper files that may have been created automatically with wrong storage schemas.

    @@@Sh
    # rm -rf /opt/graphite/storage/whisper/stats*

Feeding data through StatsD to Graphite as simple as writing directly to Graphite.

    @@@Sh
    # echo "mycounter:5|c" | nc -u -w1 localhost 8125
    
    # echo "mygauge:230|g" | nc -u -w1 localhost 8125

By repeating the counter within the flush interval will increase the resulting counter. The gauge value will be forwarded as is.


!SLIDE small
# Admin Interface

StatsD brings a simple TCP interface. It can be used to monitor a running StatsD server.

To interact with it, at first connect

    @@@Sh
    # nc localhost 8126

Available commands:

Command     | Description
----------- | -------------------------------------------
stats       | Some stats about the running server.
counters    | A dump of all the current counters.
gauges      | A dump of all the current gauges.
timers      | A dump of the current timers.
delcounters | Delete a counter or folder of counters.
delgauges   | Delete a gauge or folder of gauges.
deltimers   | Delete a timer or folder of timers.
health      | A way to set the health status of statsd.


!SLIDE small
# Client Libraries

For all common programing languages libraries exist that enable you to talk to StatsD and send datapoints. In addition, some applications support StatsD natively or with a plugin.

&nbsp;      | &nbsp;
----------- | --------------
Node        | Java
Python      | Ruby 
Perl        | PHP
Clojure     | Io
C           | CPP
.NET        | Go
Apache      | Varnish
PowerShell  | Browser
Objective-C | ActionScript
Wordpress   | Drupal
Haskell     |


!SLIDE small
# Logstash

Like for Graphite, Logstash brings a built-in output plugin also for StatsD. Here is an example on how to use it for Apache logs we covered in the Logstash section.

File: `/etc/logstash/conf.d/filter.conf`

    @@@Ruby
    output {
      statsd {
        host => "127.0.0.1"
        port => 8125
        increment  => ["apache.response.%{response}"]
        count => { "apache.bytes" => "%{bytes}" }
      } 
    }

Restart Logstash:

    @@@Sh
    # service logstash restart


!SLIDE small
# Third Party Backends

Beside the default Graphite backend, there are also several other backends which are not maintained by the StatsD project.

&nbsp;          | &nbsp;
--------------- | --------------
amqp            | librato
atsd            | mongo
aws-cloudwatch  | monitis
node-bell       | netuitive
couchdb         | **opentsdb**
datadog         | socket.io
elasticsearch   | stackdriver
ganglia         | statsd
hosted graphite | statsd http
**influxdb**    | statsd aggregation
instrumental    | warp10
jut             | zabbix
leftronic       |

~~~SECTION:handouts~~~

****

Links to all backends: https://github.com/etsy/statsd/blob/master/docs/backend.md

~~~ENDSECTION~~~
