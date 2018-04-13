!SLIDE subsectionnonum
# ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Storage Backends


!SLIDE
# Whisper Alternatives

* File Based
 * Ceres
 * Round-Robin Database
 * Go Whisper
* Based on LevelDB
 * InfluxDB (already seen)
* Based on HBase
 * OpenTSDB (already seen)
* Based on Cassandra
 * Cyanite
 * KairosDB
 * BigGraphite

~~~SECTION:handouts~~~
****

Overview: http://graphite.readthedocs.io/en/latest/tools.html#storage-backend-alternates

~~~ENDSECTION~~~


!SLIDE
# Ceres

*Ceres* is an alternative time-series database to Whisper. It is intended to replace Whisper as the default storage for Graphite.

* Not fixed-sized
* Calculate timestamps instead of storing them for each datapoint
* Store datapoints of one metric across multiple servers

Unfortunately *Ceres* is not intended to be used in production yet. *Ceres* is not actively maintained, so there is no roadmap if and when a final release will happen.

~~~SECTION:handouts~~~
****

Project: https://github.com/graphite-project/ceres

~~~ENDSECTION~~~


!SLIDE
# Round-Robin Database

*Round-Robin Database* (RRD) is well-known by many Open Source tools like Cacti, MRTG, Munin or PNP4Nagios. Usually they use RRDtool to store their data into RRD-files.

Graphite-Web has included support for RRD since the very beginning. It is a fixed-size database, similar in design and purpose to Whisper.

Differences compared to Whisper are:

* Can not take updates to a time-slot prior to its most recent update
* RRD was not designed with irregular updates in mind
* Updates are staged first for aggregation and written later
* More disk space efficient than Whisper
* Little bit faster than Whisper due to the fact it's written in C

~~~SECTION:handouts~~~
****

Project: https://oss.oetiker.ch/rrdtool/

~~~ENDSECTION~~~


!SLIDE
# Go Whisper

*Go Whisper* is a Go implementation of Whisper. To create a new Whisper database you must define it's retention level(s), aggregation method and the xFilesFactor.

* Not thread safe on concurrent writes
* Still in development

~~~SECTION:handouts~~~
****

Project: https://github.com/lomik/go-whisper

~~~ENDSECTION~~~


!SLIDE
# Cyanite

*Cyanite* is an Apache Cassandra based time-series database designed to be API-compatible with the Graphite eco-system and easy to scale.

*Graphite-Cyanite* is the so called storage finder and the component between the Cyanite backend and the Graphite Render API. It prefers the *Graphite-API* to Graphite-Web.

~~~SECTION:handouts~~~
****

Project: https://github.com/pyr/cyanite<br/>
Documentation: http://cyanite.io<br/>
Storage Finder: https://github.com/brutasse/graphite-cyanite

~~~ENDSECTION~~~


!SLIDE
# KairosDB

*KairosDB* is a TSDB similar to OpenTSDB but built on top of Cassandra.

*cairos-carbon* is a re-implementation of Carbon in Java and feeds KairosDB with support for the plaintext protocol.

A storage finder for Graphite-Web called *graphite-kairosdb* is provided from *raintank*.

~~~SECTION:handouts~~~
****

Project: https://kairosdb.github.io<br/>
Carbon Support: https://github.com/kairosdb/kairos-carbon<br/>
Storage Finder: https://github.com/raintank/graphite-kairosdb

~~~ENDSECTION~~~


!SLIDE
# BigGraphite

*BigGraphite* is a storage layer for timeseries data. It integrates with Graphite as a plugin and was developed at Criteo.

The only supported database backend by now is Apache Cassandra.

~~~SECTION:handouts~~~
****

Project: https://github.com/criteo/biggraphite<br/>
Announcement: https://github.com/criteo/biggraphite/wiki/BigGraphite-Announcement<br/>
Storage Finder: https://github.com/criteo/biggraphite/blob/master/biggraphite/plugins/graphite.py

~~~ENDSECTION~~~
