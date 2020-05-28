!SLIDE
# Overview of Grafana

Grafana is a tool which allows us to query, visualize, centralize and alert data
from multiple remote datasources.

Grafana is distributeable and multi-tenancy capable so views can be restricted on
organizations and users.

It provides a set of visualizations and can be extended via community driven plugins.

More information on the documentation.
`http://docs.grafana.org/`

~~~SECTION:handouts~~~
****

Project: http://grafana.org<br/>
Docs: http://docs.grafana.org

~~~ENDSECTION~~~

!SLIDE
# Grafana 7

Grafana v7.0 was released on 18th March 2020 and includes a lot of new features:

* New panel editor
* New tracing UI Explore
* Transformations
* New table panel
* New plugins platform
* Support for Cloudwatch
* PhantomJS removed
* Time zone support

~~~SECTION:handouts~~~
****

Release: https://grafana.com/blog/2020/05/18/grafana-v7.0-released-new-plugin-architecture-visualizations-transformations-native-trace-support-and-more/<br/>
What's New: https://grafana.com/docs/grafana/latest/guides/whats-new-in-v7-0/

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
# Grafana Installation

To use server side image rendering we need additional packages.
The feature is **optional** but is handy when sharing visualizations in alerts.

    @@@Sh
    # yum install fontconfig freetype* urw-fonts


!SLIDE smbullets
# Grafana Installation

Standard installation provides:

* `/usr/sbin/grafana-server` - binary
* `/etc/init.d/grafana-server` - init.d script
* `/etc/sysconfig/grafana-server` - defaults file
* `/etc/grafana/grafana.ini` - configuration file
* `grafana-server.service` - service unit (if systemd is available)
* `/var/log/grafana/grafana.log` - standard log
* `/var/lib/grafana/grafana.db` - default sqlite3 database

!SLIDE
# Grafana Installation

Start and enable the Grafana server:

    @@@Sh
    # systemctl start grafana-server.service
    # systemctl enable grafana-server.service


!SLIDE noprint
# Grafana Installation

After installing and starting Grafana is accessible over the HTTP port `3000`.

    @@@Sh
    Default admin credentials are:
    User: admin
    Password: admin

<center><img src="./_images/grafana_intro_login.png"/></center>

~~~SECTION:notes~~~

Hint: Use `grafana-cli admin reset-admin-password <newpass>` to reset admin credentials.

~~~ENDSECTION~~~

!SLIDE printonly
# Grafana Installation

After installing and starting Grafana is accessible over the HTTP port `3000`.

    @@@Sh
    Default admin credentials are:
    User: admin
    Password: admin

<center><img src="./_images/grafana_intro_login.png" style="width:450px"/></center>

Hint: Use `grafana-cli admin reset-admin-password <newpass>` to reset admin credentials.

!SLIDE
# Upgrading

Before upgrading consider a database backup. The important configuration is stored in the database backend. At the standard installation it's a sqlite3 file located at `/var/lib/grafana/grafana.db`.

If other backends are used, dump the database and if something goes wrong you can revert the update or downgrade Grafana with ease.

`http://docs.grafana.org/installation/upgrading/`
