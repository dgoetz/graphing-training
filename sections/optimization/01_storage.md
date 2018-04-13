!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Storage

!SLIDE smbullets
# Whisper Limitations

* Performance is slower than RRD, since Whisper is written in Python
* Whisper is disk space inefficient
* Updates end up involving a lot of IO calls


!SLIDE smbullets
# Optimize Storage

* Reduce incoming datapoints
* Use blacklisting
* Better aggregation
* Reduce retention times
* Less retentions
* Keep a lower granularity
* Optimize Cache
* Replace with alternative Storage
