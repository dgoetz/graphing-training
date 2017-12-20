!SLIDE subsectionnonum
# ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Alternatives

!SLIDE smbullets
# Ceres

Ceres is an alternative time-series database to Whisper. It is intended to replace Whisper as the default storage for Graphite.

* Not fixed-sized
* Calculate timestamps instead of storing them for each datapoint
* Store datapoints of one metric accross multiple servers

Unfortunately Ceres is not intended to be used in production yet. There is no roadmap if and when a final release will happen.


!SLIDE
# Cyanite

Cyanite is an Apache Cassandra based time-series database designed to be API-compatible with the Graphite eco-system and easy to scale.

Graphite-Cyanite is the component between the Cyanite backend and Graphite. It requires access to the Graphite Render API.

~~~SECTION:handouts~~~

****

Cyanite project: https://github.com/pyr/cyanite

Graphite-Cyanite project: https://github.com/brutasse/graphite-cyanite

Documentation: http://cyanite.io

~~~ENDSECTION~~~

!SLIDE smbullets
# Carbon Relay Alternatives

There are a few alternatives for Carbon Relay, they are written in other languages than Python and aim to be faster. Also they provide more features:

* carbon-c-relay
* carbon-relay-ng
* graphite-relay


!SLIDE smbullets
# carbon-c-relay

* Written in C
* Cleansing of received metrics
* Support for multiple clusters
* Lots of relay methods available
* Rewrite rules
* Aggregation functionality
* Plaintext input

~~~SECTION:handouts~~~

****

carbon-c-relay project: https://github.com/grobian/carbon-c-relay

~~~ENDSECTION~~~


!SLIDE smbullets
# carbon-relay-ng

* Written in Go
* Validation on all incoming metrics
* Adjust the routing table in runtime
* Advanced routing functions (i.e. queue data to disk)
* Rewrite rules
* Aggregation functionality
* Plaintext, pickle and AMQP input
* Plaintext, pickle, metrics 2.0 and kafka output

~~~SECTION:handouts~~~

****

carbon-relay-ng project: https://github.com/graphite-ng/carbon-relay-ng

~~~ENDSECTION~~~


!SLIDE smbullets
# graphite-relay

* Written with Netty
* Different backend strategies
* Overflow handler
* Plaintext input

~~~SECTION:handouts~~~

****

graphite-relay project: https://github.com/markchadwick/graphite-relay

~~~ENDSECTION~~~
