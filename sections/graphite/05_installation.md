!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Graphite Installation


!SLIDE smbullets
# Installation methods

* Installation from source
* Installation from PyPI (Python Package Index) via pip
* Installation via binary packages
 * Most common operating systems
* Installation in isolated Python environment with Virtualenv
* Script based installation with Synthesize (Vagrant)
* Installation with configuration management tools
 * Puppet
 * Ansible
 * Chef
 * Salt


!SLIDE smbullets
# Installation via Puppet

* Configuration management solution
* Supports multiple operating systems
 * RedHat, CentOS, Debian, Ubuntu, SLES, Oracle Linux, ...
* Covers all common Graphite options
* Fully automated installation of all components
* Optional: Installation of webserver

Puppet module: https://forge.puppetlabs.com/dwerder/graphite


!SLIDE 
# PyPI vs. Binary Package Installation

PyPI:

* All versions and features available
* More installation and configuration effort
* More flexibility
* Harder to debug

Binary package:

* Availability depends on the operating system
* Older and more stable versions
* Easier to install

In this course we've decided to do the installation from PyPI via pip. So the attendees will get a better understanding of the Graphite components and how they work together.


!SLIDE
# Prerequisites

To prepare the Graphite installation we need to install some required packages first:

    @@@Sh
    # yum -y install python2-pip gcc
    # yum -y install python-devel cairo-devel libffi-devel

Required packages for Graphite-Web:

    @@@Sh
    # yum -y install python-scandir mod_wsgi
    # yum -y install dejavu-sans-fonts dejavu-serif-fonts

An exported shell variable will simplify the navigation when copying or moving files around:

    @@@Sh
    # export GRAPHITE=/opt/graphite

**Note:** All package requirements for Graphite and Graphite-Web are already pre-installed on "graphing1.localdomain".


!SLIDE
# Installation via PyPI

After all requirements are fulfilled, the installation of the Graphite components via PyPI is pretty simple:

    @@@Sh
    # pip install carbon==1.1.2
    # pip install whisper==1.1.2
    # pip install graphite-web==1.1.2


!SLIDE
# Python Packages

Due to a bug in Carbon and Graphite-Web >= 1.0.0 Python packages are not stored correctly, so we create symlinks as workaround:

    @@@Sh
    # ln -s $GRAPHITE/lib/carbon-1.1.2-py2.7\
    .egg-info/ /usr/lib/python2.7/site-packages/
    # ln -s $GRAPHITE/webapp/graphite_web-1.1.2-py2.7\
    .egg-info/ /usr/lib/python2.7/site-packages/

Finally `pip` should list the installed Graphite packages:

    @@@Sh
    # pip list
    ...
    carbon (1.1.2)
    graphite-web (1.1.2)
    whisper (1.1.2)


!SLIDE
# Carbon Cache Configuration

All variations of the Carbon daemon (Cache, Aggregator and Relay) require some basic configuration. The PyPI packages provide for each configuration file at least one example. To be able to start Carbon Cache we need to copy at least two config files.

    @@@Sh
    # cp $GRAPHITE/conf/carbon.conf.example \
    $GRAPHITE/conf/carbon.conf

**carbon.conf** includes the basic configuration for all Carbon daemons (Cache, Aggregator and Relay). Options like IP's and ports to bind and some other settings are located here.

    @@@Sh
    # cp $GRAPHITE/conf/storage-schemas.conf.example \
    $GRAPHITE/conf/storage-schemas.conf

**storage-schemas.conf** includes configuration about the storage retention of metrics. More details about this will follow.


!SLIDE
# Graphite Tags

Since 1.1.x Graphite supports storing data using tags to identify each series. Those tag informations are stored in the tag database (TagDB). It is enabled by default and uses the Graphite-Web database backend, but it can also be configured to use an external Redis server or a custom plugin.

We disable tag support right now by changing `ENABLE_TAGS` to `False`.

File: **/opt/graphite/conf/carbon.conf**

    @@@Sh
    ENABLE_TAGS = False

**Note:** When using tag support it is mandatory to set the correct `GRAPHITE_URL` for Graphite-Web. It is also recommended not to use the default SQLite backend of the Webapp.

~~~SECTION:handouts~~~
****

Graphite Tag Support: http://graphite.readthedocs.io/en/latest/tags.html

~~~ENDSECTION~~~


!SLIDE
# Carbon Cache Daemon

It's time to start the Carbon Cache daemon for the first time:

    @@@Sh
    # $GRAPHITE/bin/carbon-cache.py status
    carbon-cache (instance a) is not running

    # $GRAPHITE/bin/carbon-cache.py start
    Starting carbon-cache (instance a)

    # $GRAPHITE/bin/carbon-cache.py status
    carbon-cache (instance a) is running with pid 2344

**Note:** With this method Carbon Cache daemon will not be started after a reboot of the system.


!SLIDE
# Carbon Cache Service Unit

File: **/etc/systemd/system/carbon-cache-a.service**

    @@@Sh
    [Unit]
    Description=Graphite Carbon Cache (instance a)
    After=network.target

    [Service]
    Type=forking
    StandardOutput=syslog
    StandardError=syslog
    ExecStart=/opt/graphite/bin/carbon-cache.py \
      --instance=a \
      --config=/opt/graphite/conf/carbon.conf \
      --pidfile=/var/run/carbon-cache-a.pid \
      --logdir=/var/log/carbon/ start
    ExecReload=/bin/kill -USR1 $MAINPID
    PIDFile=/var/run/carbon-cache-a.pid

    [Install]
    WantedBy=multi-user.target


!SLIDE 
# Start Carbon Cache Daemon

Start Carbon Cache daemon with systemd:

    @@@Sh
    # $GRAPHITE/bin/carbon-cache.py stop

    # systemctl daemon-reload
    # systemctl start carbon-cache-a.service
    # systemctl enable carbon-cache-a.service


!SLIDE
# Graphite-Web Configuration

Graphite-Web needs some more configuration. In addition to a working Apache 2 virtual host, the WSGI script and a basic configuration is required.

    @@@Sh
    # cp $GRAPHITE/examples/example-graphite-vhost.conf \
    /etc/httpd/conf.d/graphite-web.conf

    # cp $GRAPHITE/conf/graphite.wsgi.example \
    $GRAPHITE/conf/graphite.wsgi


!SLIDE
# Graphite-Web Configuration

**local_settings.py** includes all configuration for the webapp. Here you can enable a memcache daemon and configure multiple Carbon Cache backends. For now we only need to set a secret key which is needed for the database initialization and adjust the time zone.

    @@@Sh
    # cp $GRAPHITE/webapp/graphite/local_settings.py.example \
    $GRAPHITE/webapp/graphite/local_settings.py

File: **/opt/graphite/webapp/graphite/local_settings.py**

    @@@Sh
    SECRET_KEY = 'random-string'

    TIME_ZONE = 'Europe/Berlin'


!SLIDE small
# Graphite-Web Database Initialization

We will use a SQLite database which needs to be initialized first:

    @@@Sh
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py \
    migrate --settings=graphite.settings --run-syncdb

And also the static files:

    @@@Sh
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py \
    collectstatic --noinput --settings=graphite.settings

The initialization of the DB also creates a user. This user can later be used to login to Graphite-Web and store graphs and dashboards. 

Django's command-line utility also provides subcommands to `check` and `test` the installed components:

    @@@Sh
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py check \
    --settings=graphite.settings
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py test \
    --settings=graphite.settings


!SLIDE
# Graphite-Web Permissions

The SQLite database and the webapp logs are located in the storage directory, therefore we change the owner to `apache`:

    @@@Sh
    # chown apache:root $GRAPHITE/storage
    # chown apache:apache $GRAPHITE/storage/graphite.db

It's also important to change the permissions for the log directory, otherwise you will get the error `"populate() isn't reentrant"` later:

    @@@Sh
    # chown -Rf apache:root $GRAPHITE/storage/log


!SLIDE
# Apache Configuration

The default HTTP name for Graphite-Web is `graphite` and configured in **graphite-web.conf**. In order to access Graphite-Web we have to set permissions to the static directory:

File: **/etc/httpd/conf.d/graphite-web.conf**

    @@@Sh
    <Directory /opt/graphite/static>
        Require all granted
    </Directory>

Finally we can start the Apache webserver:

    @@@Sh
    # systemctl start httpd.service
    # systemctl enable httpd.service


!SLIDE
# Installation Verification

To prove if everything worked open your browser with the default url of Graphite-Web: http://graphite

However it's **always** recommended to **have a look at the logs**!

* Graphite-Web: **/opt/graphite/storage/log/webapp/**
* Carbon Cache: **/var/log/carbon/**
* Apache: **/var/log/httpd/**
* Whisper Files: **/opt/graphite/storage/whisper/**


!SLIDE
# EPEL Package Installation (1/2)

Graphite 0.9.16 on CentOS 7:

    @@@Sh
    # yum -y install python-carbon python-whisper
    # yum -y install graphite-web
    # systemctl enable carbon-cache.service --now

File: **/etc/graphite-web/local_settings.py**

    @@@Sh
    SECRET_KEY = 'random-string'
    TIME_ZONE = 'Europe/Berlin'

    # python /usr/lib/python2.7/site-packages/graphite/manage.py syncdb


!SLIDE small
# EPEL Package Installation (2/2)

File: **/etc/httpd/conf.d/graphite-web.conf**

    @@@Sh
    <Directory "/usr/share/graphite">
      <IfModule mod_authz_core.c>
        # Apache 2.4
        # Require local
        Require all granted
      </IfModule>
      ...
    </Directory>


    # chown apache:apache /var/lib/graphite-web/graphite.db 
    # systemctl enable httpd.service --now

Graphite-Web: **http://graphite-web**

Config Files: **/etc/carbon/** and **/etc/graphite-web/**

Log Files: **/var/log/carbon/** and **/var/log/httpd/**

Whisper Files: **/var/lib/carbon/whisper/**
