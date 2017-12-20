!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Graphite Components


!SLIDE smbullets
# Components of Graphite

Graphite is a scalable system which provides realtime graphing. Graphite was originally developed by Chris Davis from orbitz.com, where it was used to visualize business-critical data. Graphite is not a single application, it consists of multiple components which together provide a fully functional performance monitoring solution.

Parts of Graphite:

* Carbon
 * Cache
 * Aggregator
 * Relay
* Graphite Web
* Whisper

~~~SECTION:handouts~~~
****
Graphite was published in 2008 under the "Apache 2.0" license.
~~~ENDSECTION~~~


!SLIDE smbullets
# Carbon Cache

* Accepts metrics over TCP or UDP
* Various protocols
 * Plaintext
 * Python pickle
 * AMQP
* Caches metrics
* Provides query port (in-memory metrics)
* Writes data to disk

Carbon Cache accepts metrics and provides a mechanism to cache those for a defined amount of time. It uses the underlying Whisper libraries to store permanently to disk. In a growing environment with more I/O a single carbon-cache process may not be enough. To scale you can simply spawn multiple Carbon Caches.


!SLIDE smbullets noprint
# Carbon Aggregator

* In front of Carbon Cache
* Buffers metrics
* Aggregation of metrics by rules
* Reduce I/O by aggregating data

Carbon Aggregator sits in front of Carbon Cache and receives metrics. The function of this daemon is to aggregate the data it receives and forwards it to Carbon Cache for permanent storage. For instance it can sum statistics of multiple servers into one metric.

<center><img src="./_images/graphite-cache-aggregator.png"/></center>


!SLIDE smbullets printonly
# Carbon Aggregator

* In front of Carbon Cache
* Buffers metrics
* Aggregation of metrics by rules
* Reduce I/O by aggregating data

Carbon Aggregator sits in front of Carbon Cache and receives metrics. The function of this daemon is to aggregate the data it receives and forwards it to Carbon Cache for permanent storage. For instance it can sum statistics of multiple servers into one metric.

<center><img src="./_images/graphite-cache-aggregator.png" style="width:460px"/></center>


!SLIDE smbullets noprint
# Carbon Relay

* Forward incoming metrics to another Carbon daemon
* Replicate metrics to one or more destinations
* Sharding
* Forward based on consistent hash (default) or
* Rule based routing

Carbon Relay is a kind of "loadbalancer" for Carbon Cache and/or Aggregator. It can forward metrics based on consistent hashes or with defined regex rules.

<center><img src="./_images/graphite-cache-aggregator-relay.png"/></center>


!SLIDE smbullets printonly
# Carbon Relay

* Forward incoming metrics to another Carbon daemon
* Replicate metrics to one or more destinations
* Sharding
* Forward based on consistent hash (default) or
* Rule based routing

Carbon Relay is a kind of "loadbalancer" for Carbon Cache and/or Aggregator. It can forward metrics based on consistent hashes or with defined regex rules.

<center><img src="./_images/graphite-cache-aggregator-relay.png" style="width:460px"/></center>


!SLIDE smbullets
# Graphite Web

* Webinterface (Django)
* Render graphs
* Save graphs in dashboards
* Share graphs

Graphite Web is the visualizing component. To create graphics, it obtains the data simultaneously from the related Whisper files and the Carbon Cache. Graphite Web combines data points from both sources and returns a single image. By doing this it ensures that data always can be shown in real time, even if some data points are not written yet into Whisper files and therefore written on the hard drive.
