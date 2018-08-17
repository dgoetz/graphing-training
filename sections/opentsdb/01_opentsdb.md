!SLIDE
# OpenTSDB

* Time series database
* Scalable
* Distributed
* HTTP API
* No rendering of data
* No collection of data
* Based on HBase
* Language: Java

~~~SECTION:handouts~~~
****

Project: http://opentsdb.net<br/>
Docs: http://opentsdb.net/docs/build/html

~~~ENDSECTION~~~


!SLIDE
# OpenTSDB

OpenTSDB is a time series database based on Apaches HBase. With this underlying technology it is possible to distribute and scale data across a big amount of servers.

* Time Series Daemon (TSD)
 * One or multiple daemons that talk to HBase
 * TSDs are independent from each other
* HTTP API
 * User do not need to talk to HBase
* Telnet interface
* Simple built-in GUI
* Commandline Tools

~~~SECTION:handouts~~~
****

Project: http://opentsdb.net<br>
Docs: http://opentsdb.net/docs/build/html<br>
HBase: http://hbase.apache.org

~~~ENDSECTION~~~


!SLIDE noprint
# OpenTSDB Concept

<center><img src="./_images/opentsdb-concept.png"/></center>


!SLIDE printonly
# OpenTSDB Concept

<center><img src="./_images/opentsdb-concept.png" style="width:460px"/></center>


!SLIDE
# OpenTSDB Metrics

OpenTSDB uses some kind of Graphites metric path combined with tags to identify datapoints:

    @@@Sh
    <metric> <timestamp> <value> <tagk1=tagv1 ... tagkN=tagvN>
    sys.cpu.user 1356998400 42.5 host=webserver01 cpu=0


!SLIDE
# OpenTSDB Collectors

To collect data several clients are available:

* TCollector<br/>
http://opentsdb.net/docs/build/html/user_guide/utilities/tcollector.html
* SCollector (API v2)<br/>
http://bosun.org/scollector/
* collectd<br/>
https://github.com/auxesis/collectd-opentsdb
* Icinga 2<br/>
https://www.icinga.com


!SLIDE
# OpenTSDB Client Libraries

For communication with OpenTSDB multiple client libraries exist. Some of them can just pull data where other may read and write metrics.

* R (read) 
* Erlang (write)
* Ruby (read/write)
* Go (read/write) 
* Python (write)
* vert.x (write)


!SLIDE
# OpenTSDB Frontends

Beside the simple built-in GUI there are some other webinterfaces for OpenTSDB dashboards:

* Grafana<br/>
http://grafana.org

* TSDash<br/>
https://github.com/facebookarchive/tsdash

* OpenTSDB Dashboard<br/>
https://github.com/turn/opentsdb-dashboard

* Status Wolf<br/>
https://github.com/box/StatusWolf

* Metrilyx<br/>
https://github.com/Ticketmaster/metrilyx-2.0
