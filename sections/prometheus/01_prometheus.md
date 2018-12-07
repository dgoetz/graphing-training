!SLIDE
# Prometheus Overview

* Written in Go
* Developed by SoundClound in 2012
* Standalone Open Source project
* Maintained independently of any company
* Made for cloud purposes
* Combines monitoring, alerting and trending in one solution
* Multi-dimensional data model based on LevelDB
* Own query language (PromQL)
 * Expression browser for ad-hoc queries and debugging
 * Grafana or Console templates for graphs
* Pulling (scraping) of data with agents (so called exporters)
 * Official exporter for Graphite available

~~~SECTION:handouts~~~
****

Project: https://prometheus.io

~~~ENDSECTION~~~


!SLIDE noprint
# Prometheus Architecture

<center><img src="./_images/prometheus/prometheus_architecture.png" style="width:800px;height:553px;"/></center>


!SLIDE printonly
# Prometheus Architecture

<center><img src="./_images/prometheus/prometheus_architecture.png" style="width:460px;height:319px;"/></center>
