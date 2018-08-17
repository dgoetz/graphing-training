!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Considerations


!SLIDE
# Setup

* Use fast disks (SSD's) and as many CPU cores as possible
* Use toolstack that fits to the environment
* Prefer Pickle protocol over Plaintext
* Care about Storage Schemas and Retentions
* Always keep scaling in mind
* Benchmark the whole installation
* Tune the installation
* Benchmark the whole installation again
* Know the limits of the installation


!SLIDE
# Operating

* Keep an eye of internal statistics (Monitoring!)
 * Queues
 * Caches
* Keep an eye of system statistics (Monitoring!)
 * IO reads and writes (iostat, iotop, collectl, dstat, sar, ...)
 * CPU utilization (top/htop, iostat, collectl, dstat, sar, ...)
 * Memory usage (top/htop, collectl, dstat, sar, ...)
 * Network performance (iperf, iftop, tcpdump, nload, dstat, sar, ...)
 * Disk usage (df, ...)


!SLIDE
# Maintenance

* Think about backups (Validation!)
* Think about disaster recovery (Tests!)
* Consider updates
* Cleanup orphaned or corrupt Whisper files
* Validate Storage Schemas and Retentions 
* Resize Whisper files

~~~SECTION:handouts~~~
****

Example command to cleanup orphaned Whisper files:

    @@@Sh
    # find /opt/graphite/storage/whisper/ -type f \
    -name *.wsp -mtime +60 -delete

~~~ENDSECTION~~~
