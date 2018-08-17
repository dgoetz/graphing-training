!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Benchmarking


!SLIDE
# Haggar - Carbon Load Generation Tool

Installation and run on CentOS:

    @@@Sh
    # yum -y install golang
    # go get github.com/gorsuch/haggar

    # /root/go/bin/haggar -agents=5 -metrics=10 \
    -carbon="127.0.0.1:2003"

    2018/03/01 11:15:28 master: pid 12863
    2018/03/01 11:15:28 agent 0: launched
    2018/03/01 11:15:38 agent 0: flushed 10 metrics
    2018/03/01 11:15:40 agent 1: launched
    2018/03/01 11:15:42 agent 2: launched
    2018/03/01 11:15:48 agent 0: flushed 10 metrics
    2018/03/01 11:15:50 agent 1: flushed 10 metrics
    2018/03/01 11:15:52 agent 2: flushed 10 metrics
    2018/03/01 11:15:58 agent 0: flushed 10 metrics
    2018/03/01 11:15:58 agent 3: launched
    2018/03/01 11:16:00 agent 1: flushed 10 metrics
    2018/03/01 11:16:00 agent 4: launched
    2018/03/01 11:16:02 agent 2: flushed 10 metrics
    ...

~~~SECTION:handouts~~~

****

Project: https://github.com/gorsuch/haggar

~~~ENDSECTION~~~


!SLIDE
# bonnie++ - File System Benchmark

Benchmark file system performance:

* Data read and write speed
* Number of seeks that can be performed per second
* Number of file metadata operations that can be performed per second

<center><img src="./_images/bonnie.png" style="width:90%"/></center>

~~~SECTION:handouts~~~

****

Project: https://www.coker.com.au/bonnie++/

~~~ENDSECTION~~~
