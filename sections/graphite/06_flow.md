!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Data Flow


!SLIDE smbullets small
# Receive Data

To receive metrics, Graphite provides by default two interfaces. On Port 2003 Carbon  is listening with a plain text protocol, on port 2004 with the so-called "Pickle protocol".

While the plain text protocol is pretty simple "**\<metric.path>.\<value>.\<timestamp>**", the Pickle protocol is more complex and looks more like a multidimensional array. The advantage of the plain text protocol is its simplicity, the Pickle protocol instead is more efficient. In addition, multiple metrics can be transferred in a bulk.

    @@@Sh
    # echo "localhost.tmp.files `ls /tmp | wc -l` `date +%s`"
    localhost.tmp.files 9 1522237082

    # echo "localhost.tmp.files `ls /tmp | wc -l` `date +%s`" | nc localhost 2003

Tags must be appended to the metrics path with semicolon: "**;\<tag-key>=\<tag-value>**"

    @@@Sh
    # echo "localhost.tmp.files;os=linux;dist=centos `ls /tmp | wc -l` `date +%s`"
    localhost.tmp.files;os=linux;dist=centos 9 1522237082


!SLIDE smbullets
# Carbon Cache Datapoint Flow

* Datapoint arrives at Carbon Cache
* According to its metric a queue is created
  * If the queue already exists, datapoint is added to it
  * One queue represents one metric path, hence one Whisper file
* A writer thread periodically writes down all the datapoints
  * There are 4 different algorithms for writing down datapoints
  * All datapoints of one queue are written at once to the corresponding Whisper file: update_many()


!SLIDE small
# Carbon Cache Write Algorithms (1/2)

The thread that writes metrics to disk can use on of the following strategies determining the order in which metrics are removed from cache and flushed to disk. This setting can be adjusted in **carbon.conf** with `CACHE_WRITE_STRATEGY` in the `[cache]` section.

Algorithm  | Description
---------- | -------------
**sorted** (default) | All metrics in the cache will be counted and an ordered list of them will be sorted according to the number of datapoints in the cache at the moment of the list's creation. Metrics will then be flushed from the cache to disk in that order.
**timesorted** | All metrics in the list will be looked at and sorted according to the timestamp of there datapoints. The metric that were the least recently written will be written first. This is an hybrid strategy between max and sorted which is particularly adapted to sets of metrics with non-uniform resolutions.
**max**    | The writer thread will always pop and flush the metric from cache that has the most datapoints. This will give a strong flush preference to frequently updated metrics and will also reduce random file-io. Infrequently updated metrics may only ever be persisted to disk at daemon shutdown if there are a large number of metrics which receive very frequent updates OR if disk i/o is very slow.


!SLIDE small
# Carbon Cache Write Algorithms (2/2)

Algorithm  | Description
---------- | -------------
**naive**  | Metrics will be flushed from the cache to disk in an unordered fashion. This strategy may be desirable in situations where the storage for whisper files is solid state, CPU resources are very limited or deference to the OS's i/o scheduler is expected to compensate for the random write pattern.


!SLIDE smbullets small
# Internal Statistics (1/2)

Metric                 | Meaning
---------------------- | -------------
**activeConnections**  | Number of active connections. (>=1.0.0)
**avgUpdateTime**      | The average amount of time spent per Whisper update operation.
**blacklistMatches**   | Number of blacklist matches.
**cache.bulk_queries** | Number of bulk queries to the carbon-cache instance.
**cache.overflow**     | Number of datapoints received while the cache was full.
**cache.queries**      | Number of all cache queries received by the cache from the webapp.
**cache.queues**       | Number of metric keys (metric name) in the cache at the time of recording.
**cache.size**         | Number of metric datapoints in the cache at the time of recording.
**committedPoints**    | Number of metric datapoints flushed to disk.
**cpuUsage**           | CPU usage of the carbon-cache instance.
**creates**            | Number of Whisper files successfully created.


!SLIDE smbullets small
# Internal Statistics (2/2)

Metric                 | Meaning
---------------------- | -------------
**droppedCreates**     | Number of failed Whisper create operations. (>=1.0.0)
**errors**             | Number of failed Whisper update operations.
**memUsage**           | Memory usage of the carbon-cache daemon.
**metricsReceived**    | Number of datapoints received by the carbon-cache listener.
**pointsPerUpdate**    | Average number of datapoints written per Whisper update operation. The higher the value, the more effective the cache is performing at batch writes (fewer I/O operations).
**updateOperations**   | Number of successful Whisper update operations.
**whitelistRejects**   | Number of whitelist rejects.
