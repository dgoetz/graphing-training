!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Icingabeat


!SLIDE small noprint
# Icingabeat

Icingabeat is an Elastic Beat that fetches data from the Icinga 2 API and sends it either directly to Elasticsearch or Logstash. There are also example dashboards for Kibana available.

<center><img src="./_images/icingabeat-checkresults-dashboard.png" style="width:800px;height:459px;"/></center>

**Note:** Icingabeat, Elasticsearch and Kibana are already pre-installed on "graphing1.localdomain".


!SLIDE small printonly
# Icingabeat

Icingabeat is an Elastic Beat that fetches data from the Icinga 2 API and sends it either directly to Elasticsearch or Logstash. There are also example dashboards for Kibana available.

<center><img src="./_images/icingabeat-checkresults-dashboard.png" style="width:460px;height:264px;"/></center>

**Note:** Icingabeat, Elasticsearch and Kibana are already pre-installed on "graphing1.localdomain".

~~~SECTION:handouts~~~

****

Project: https://github.com/Icinga/icingabeat

~~~ENDSECTION~~~


!SLIDE
# Event Streams

Icingabeat is pre-configured by default to receive check results (CheckResult) and state changes (StateChange) from Icinga's event stream and send them periodically (every 10s) to Elasticsearch.

Notifications, acknowledgements, comments and downtimes are also available as event streams. We add notifications (Notification) as event stream in our training environment and we have to turn off ssl verification:

File: **/etc/icingabeat/icingabeat.yml**

    @@@Sh
    ...

    ssl.verify: false

    eventstream.types:
     - CheckResult
     - StateChange
     - Notification

    ...


!SLIDE
# Start Elasticsearch and Icingabeat

Finally we can start Elasticsearch and Icingabeat:

    @@@Sh
    # systemd start elasticsearch.service
    # systemd start icingabeat.service

**Note:** If you're interested you can also start Kibana, it will be available at: http://192.168.56.101:5601

    @@@Sh
    # systemd start kibana.service


!SLIDE noprint
# Grafana Elasticsearch Data Source

Add the Elasticsearch data source with the Icingabeat index "**[icingabeat-*]**" to Grafana:

<center><img src="./_images/grafana-elasticsearch-datasource.png" style="width:610px;height:245px;"/></center>


!SLIDE printonly
# Grafana Elasticsearch Data Source

Add the Elasticsearch data source with the Icingabeat index "**[icingabeat-*]**" to Grafana:

<center><img src="./_images/grafana-elasticsearch-datasource.png" style="width:460px;height:185px;"/></center>


!SLIDE noprint
# Notification Annotations

Create a new graph with **icinga2.training_localdomain.services.random.
random.metadata.state** metrics from Graphite and annotation settings from Elasticsearch:

<center><img src="./_images/grafana-annotations.png" style="width:800px;height:266px;"/></center>


!SLIDE printonly
# Notification Annotations

Create a new graph with **icinga2.training_localdomain.services.random.
random.metadata.state** metrics from Graphite and annotation settings from Elasticsearch:

<center><img src="./_images/grafana-annotations.png" style="width:460px;height:153px;"/></center>


!SLIDE noprint
# Graph with Annotations

The graph should look similar like this one:

<center><img src="./_images/grafana-graph-with-annotations.png" style="width:800px;height:226px;"/></center>


!SLIDE printonly
# Graph with Annotations

The graph should look similar like this one:

<center><img src="./_images/grafana-graph-with-annotations.png" style="width:460;height:130px;"/></center>
