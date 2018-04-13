!SLIDE subsectionnonum
# ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Transports


!SLIDE
# Transport Alternatives

There are a few alternatives for Carbon Relay and/or Carbon Aggregator.

They are written in other languages than Python and aim to be faster. Also they provide more features.

~~~SECTION:handouts~~~
****

Overview: http://graphite.readthedocs.io/en/latest/tools.html#forwarding

~~~ENDSECTION~~~


!SLIDE
# carbon-c-relay

* Written in C
* Cleansing of received metrics
* Support for multiple clusters
* Lots of relay methods available
 * forward (all destinations)
 * any_of (one destination)
 * failover (usually first destination)
 * carbon_ch (distribute metrics)
* Rewrite rules
* Aggregation functionality
* Plaintext input

~~~SECTION:handouts~~~
****

Project: https://github.com/grobian/carbon-c-relay

~~~ENDSECTION~~~


!SLIDE
# carbon-relay-ng

* Written in Go
* Validation on all incoming metrics
* Adjust the routing table in runtime
* Web and telnet interface
* Advanced routing functions (i.e. queue data to disk)
 * sendAllMatch (all destinations)
 * sendFirstMatch (first destination)
 * consistentHashing (distribute metrics)
* Rewrite rules
* Aggregation functionality
* Plaintext, pickle and AMQP input
* Plaintext, pickle, metrics 2.0 and kafka output

~~~SECTION:handouts~~~
****

Project: https://github.com/graphite-ng/carbon-relay-ng

~~~ENDSECTION~~~


!SLIDE
# graphite-relay

* Written with Netty
* Different backend strategies
* Overflow handler
* Plaintext input
* No active development since 2012

~~~SECTION:handouts~~~
****

Project: https://github.com/markchadwick/graphite-relay

~~~ENDSECTION~~~
