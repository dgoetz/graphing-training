!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Stacks


!SLIDE
# Zipper

* Written in Go
* Originally developed at booking.com
* Can query store servers in parallel
* Can "zip" the data
* Consists of:
 * carbonzipper
 * carbonapi
 * carbonserver (since December 2016 part of go-carbon)
 * carbonsearch

~~~SECTION:handouts~~~
****

carbonzipper: https://github.com/go-graphite/carbonzipper<br/>
carbonapi: https://github.com/go-graphite/carbonapi<br/>
carbonserver: https://github.com/grobian/carbonserver<br/>
carbonsearcht: https://github.com/kanatohodets/carbonsearch

~~~ENDSECTION~~~


!SLIDE
# Zipper Stack Architecture

Example architecture of the Zipper Stack:

<center><img src="./_images/zipperstack.png"/></center>


!SLIDE
# ClickHouse

*ClickHouse* is an Open Source column-oriented database management system developed from Yandex that allows generating analytical data reports in real time.

*carbon-clickhouse* is a metrics receiver that uses ClickHouse as storage. The connection from Graphite-Web to the cluster backend *graphite-clickhouse* including ClickHouse support is configured with `CLUSTER_SERVERS` in **local_settings.py**.

~~~SECTION:handouts~~~
****

Carbon Support: https://github.com/lomik/carbon-clickhouse<br/>
Cluster Backend: https://github.com/lomik/graphite-clickhouse

~~~ENDSECTION~~~


!SLIDE noprint
# ClickHouse Architecture

Work scheme for Graphite with ClickHouse support:

<center><img src="./_images/clickhouse.png" style="width:493px;height:500px;"/></center>

**Note:*** The gray components are optional or alternative.


!SLIDE printonly
# ClickHouse Architecture

Work scheme for Graphite with ClickHouse support:

<center><img src="./_images/clickhouse.png" style="width:420px;height:426px;"/></center>

**Note:** The gray components are optional or alternative.
