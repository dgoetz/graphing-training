!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Advanced Components


!SLIDE noprint
# Carbon Relay

* Forward incoming metrics to another Carbon daemon
* Replicate metrics to one or more destinations
* Sharding
* Forward based on consistent hash (default) or
* Rule based routing

Carbon Relay is a kind of "loadbalancer" for Carbon Cache and/or Aggregator. It can forward metrics based on consistent hashes or with defined regex rules.

<center><img src="./_images/graphite-cache-aggregator-relay.png"/></center>


!SLIDE printonly
# Carbon Relay

* Forward incoming metrics to another Carbon daemon
* Replicate metrics to one or more destinations
* Sharding
* Forward based on consistent hash (default) or
* Rule based routing

Carbon Relay is a kind of "loadbalancer" for Carbon Cache and/or Aggregator. It can forward metrics based on consistent hashes or with defined regex rules.

<center><img src="./_images/graphite-cache-aggregator-relay.png" style="width:460px"/></center>


!SLIDE noprint
# Carbon Aggregator

* In front of Carbon Cache
* Buffers metrics
* Aggregation of metrics by rules
* Reduce I/O by aggregating data

Carbon Aggregator sits in front of Carbon Cache and receives metrics. The function of this daemon is to aggregate the data it receives and forwards it to Carbon Cache for permanent storage. For instance it can sum statistics of multiple servers into one metric.

<center><img src="./_images/graphite-cache-aggregator.png"/></center>


!SLIDE printonly
# Carbon Aggregator

* In front of Carbon Cache
* Buffers metrics
* Aggregation of metrics by rules
* Reduce I/O by aggregating data

Carbon Aggregator sits in front of Carbon Cache and receives metrics. The function of this daemon is to aggregate the data it receives and forwards it to Carbon Cache for permanent storage. For instance it can sum statistics of multiple servers into one metric.

<center><img src="./_images/graphite-cache-aggregator.png" style="width:460px"/></center>
