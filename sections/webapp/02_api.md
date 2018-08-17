!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Graphite-Web API


!SLIDE
# HTTP API

The interactive webinterface of Graphite-Web is called Composer. Aside to this Graphite-Web also has a HTTP API which consists of two parts:

* Render API
* Metrics API


!SLIDE
# Render API

The Render API can be used to retrieve and visualize datapoints. The API can be used to embed graphs in own applications or webinterfaces. Mostly the API is used by 3rd party dashboard tools like Grafana.

* Different formats:
 * png, raw, csv, json, svg, pdf, dygraph, rickshaw and pickle
* Paths with Wildcards
* Relative or absolute time periods
* Template function with variables
* Almost full functionality of Composer

Parameters: http://graphite.readthedocs.org/en/latest/render_api.html#graph-parameters


!SLIDE
# Render API - Sample 1

Create a simple graph of the load of one of your servers in the last hour. Output as PNG with the resolution of 800x600.

    @@@Sh
    http://graphite/render
    ?target=collectd.graphing1.load.load.*
    &from=-1h
    &width=800
    &height=600


!SLIDE
# Render API - Sample 2

Create a JSON output of the free diskspace from one of your servers. Output only the last 5 minutes.

    @@@Sh
    http://graphite/render
    ?target=collectd.graphing1.df-root.df_complex-free
    &from=-5min
    &format=json


!SLIDE
# Render API - Sample 3

Build an average of the CPUs system time from two of your servers. Add a title to the graph and change the background color. Set a minimum of 0 and create an alias for the legend called "CPU system".

    @@@Sh
    http://graphite/render
    ?target=
      alias
        (
          averageSeries
          (
            collectd.graphing[1-2].cpu-*.cpu-system
          ), 
        "CPU system"
        )
    &title=CPU of all servers
    &bgcolor=red
    &yMin=0


!SLIDE
# Metrics API 

Graphite-Web supports some functionality to browse through metrics.

Function                      | Description
----------------------------- | ------------
/metrics/index.json           | Walks the metrics tree and returns every metric found as a sorted JSON array.
/metrics/find?query=a.b.c.d   | Finds metrics under a given path.
/metrics/expand?query=a.b.c.d | Expands the given query with matching paths.

~~~SECTION:handouts~~~
****

Metrics API: http://graphite-api.readthedocs.io/en/latest/api.html#the-metrics-api

~~~ENDSECTION~~~
