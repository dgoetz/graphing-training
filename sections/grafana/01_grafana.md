!SLIDE
# Overview of Grafana

Grafana is an Open Source webinterface that lets you visualize data from a lot of different data sources. Currently offical supported data sources are Graphite, Elasticsearch, CloudWatch, InfluxDB, OpenTSDB, Prometheus, MySQL and Postgres.

Since version 2.0 Grafana ships with its own backend server and since 3.0 additional data sources can be installed as plugins and mixed in the same chart. A core feature introduced with Grafana 4.0 was alerting.

* Visualize graphs
* Create dashboards
* Share
* Annotations
* Templates
* Multiple backends
* Alerts

~~~SECTION:handouts~~~
****

Project: http://grafana.org<br/>
Docs: http://docs.grafana.org

~~~ENDSECTION~~~


!SLIDE
# Grafana 5

Grafana v5.0 was released on March 1st 2018 and includes a lot of new features:

* New dashboard layout engine
* UI improvements in look and function
* New light theme
* Dashboard folders
* Permissions
* Group users into teams and use them for permissions
* Setup data sources and dashboards via config files
* Persistent dashboard url's
* Graphite Tags
* Integrated function docs

~~~SECTION:handouts~~~
****

Release: https://grafana.com/blog/2018/03/01/grafana-v5.0-released/<br/>
What's New: http://docs.grafana.org/guides/whats-new-in-v5/

~~~ENDSECTION~~~


!SLIDE small
# Grafana Installation

On RPM-based Linux systems like CentOS, Grafana can be installed via source, YUM repository or using YUM directly.

File: **/etc/yum.repos.d/grafana.repo**

    @@@Sh
    [grafana]
    name=grafana
    baseurl=https://packagecloud.io/grafana/stable/el/7/\
      $basearch
    repo_gpgcheck=1
    enabled=1
    gpgcheck=1
    gpgkey=https://packagecloud.io/gpg.key \
      https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
    sslverify=1
    sslcacert=/etc/pki/tls/certs/ca-bundle.crt

Install Grafana:

    @@@Sh
    # yum -y install grafana

**Note:** Grafana is already pre-installed on "graphing1.localdomain".


!SLIDE
# Grafana Server

Start and enable the Grafana server:

    @@@Sh
    # systemctl start grafana-server.service
    # systemctl enable grafana-server.service

After that Grafana should be accessible via HTTP on port 3000 and the administrative user **admin** with password **admin**.

Basic settings like the used database, authentication or logging settings can be changed in **/etc/grafana/grafana.ini**. Grafana is even capable of sending its internal metrics to Graphite.


!SLIDE noprint
# Grafana Graphite Data Source

The first step after installation is to add the Graphite data source:

<center><img src="./_images/grafana-graphite-datasource.png" style="width:400px;height:500px;"/></center>


!SLIDE printonly
# Grafana Graphite Data Source

The first step after installation is to add the Graphite data source:

<center><img src="./_images/grafana-graphite-datasource.png" style="width:320px;height:400px;"/></center>


!SLIDE noprint
# Grafana Dashboards

You can either create dashboards by yourself or import them from https://grafana.com/dashboards.<br/>
A good start with Graphite as backend is a dashboard called "Graphite Server (Carbon Metrics)" with ID "947".

<center><img src="./_images/grafana-graphite-dashboard.png" style="width:800px;height:424px;"/></center>


!SLIDE printonly
# Grafana Dashboards

You can either create dashboards by yourself or import them from https://grafana.com/dashboards.<br/>
A good start with Graphite as backend is a dashboard called "Graphite Server (Carbon Metrics)" with ID "947".

<center><img src="./_images/grafana-graphite-dashboard.png" style="width:460px;height:244px;"/></center>


!SLIDE
# Custom Grafana Dashboards

To build your own dashboards with Grafana you should start with the "Getting started" chapter of the official documentation, available at http://docs.grafana.org/guides/getting_started/.

There's also a video with a 10min beginners guide from the main developer of Grafana, Torkel Ödegaard, and many other assistances available.
