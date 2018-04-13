!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Forwarding


!SLIDE smbullets
# Carbon Relay Limitations

* Queue is growing continuously
* Incoming datapoints are dropped or in waiting line
* System runs out of memory when `MAX_QUEUE_SIZE` is set to high
* Only *consistent-hashing* or *regex based routing* supported
* No aggregation functionality


!SLIDE smbullets
# Optimize Relay

* Adjust `MAX_QUEUE_SIZE` (Defaults to `10000`)
* Set `USE_FLOW_CONTROL` (Defaults to `True`)
* Adjust `QUEUE_LOW_WATERMARK_PCT` (Defaults to `0.08`)
* Adjust `MAX_DATAPOINTS_PER_MESSAGE` (Defaults to `500`)
* Put Aggregator afterwards
* Optimize Cache or Aggregator aftwards
* Replace with alternative Relay


!SLIDE smbullets
# Carbon Aggregator Limitations

* Queue is growing continuously
* Incoming datapoints are dropped or in waiting line
* System runs out of memory when `MAX_QUEUE_SIZE` is set to high
* Only *consistent-hashing* supported


!SLIDE smbullets
# Optimize Aggregator

* Adjust `MAX_QUEUE_SIZE` (Defaults to `10000`)
* Set `USE_FLOW_CONTROL` (Defaults to `True`)
* Adjust `QUEUE_LOW_WATERMARK_PCT` (Defaults to `0.08`)
* Adjust `MAX_DATAPOINTS_PER_MESSAGE` (Defaults to `500`)
* Put Relay afterwards
* Optimize Cache or Relay afterwards
* Replace with alternative Aggregator
