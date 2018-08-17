!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Cache


!SLIDE
# Carbon Cache Limitations

* Cache is not able to keep up with incoming datapoints
* Incoming datapoints are dropped or in waiting line
* System runs out of memory when `MAX_CACHE_SIZE` is set to high


!SLIDE
# Optimize Cache (1/2)

* Adjust `MAX_CREATES_PER_MINUTE` (Defaults to `50`)
* Adjust `MAX_CACHE_SIZE` (Defaults to `inf`)
* Adjust `CACHE_WRITE_STRATEGY` (Defaults to `sorted`)
 * `max` reduces random I/O
 * `naive` only with fast I/O and limited CPU resources
* Set `WHISPER_AUTOFLUSH` when writing to slow disks (Defaults to `False`)
* Set `WHISPER_SPARSE_CREATE` for faster creates (Defaults to `False`)
* Set `WHISPER_LOCK_WRITES` when multiple Carbon Caches write to the same files (Defaults to `False`)


!SLIDE
# Optimize Cache (2/2)

* Increase page cache (disk cache) for less read iops
* Spawn Cache on same system (vertical scaling)
* Distribute Cache over more systems (horizontal scaling)
* Replace slow disks with faster ones (SSD's) for better write iops
* Replace with alternative Cache (*go-carbon*)
