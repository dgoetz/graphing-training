!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Graphite Installation

!SLIDE smbullets
# Training VMs

* Virtual Box
* Host-only network (192.168.56.x)
* `graphing1` is the primary training VM
* `graphing2` is used for Cluster setup

  Instance       | IP                    | Login
  ---------------|-----------------------|---------------------------
  graphing1      | 192.168.56.101        | training/netways (sudo su)
  graphing2      | 192.168.56.102        | training/netways (sudo su)

~~~SECTION:handouts~~~

****

VirtualBox user manual: https://www.virtualbox.org/manual/UserManual.html

~~~ENDSECTION~~~


!SLIDE smbullets
# Base Linux Installation

* CentOS 7
* `Systemd` as init system
* `Firewalld` (Stopped)
* `SELinux` (Permissive)
* EPEL repository for additional packages


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
# Puppet Installation

* Configuration management solution
* Supports multiple operating systems
 * RedHat, CentOS, Debian, Ubuntu, SLES, Scientific Linux, Oracle Linux, ...
* Covers all common Graphite options
* Fully automated installation of all components
* Optional: Installation of webserver

Puppet module: https://forge.puppetlabs.com/dwerder/graphite

~~~SECTION:notes~~~
Installing Graphite on Windows is unsuported and definitely not suggested!
~~~ENDSECTION~~~


!SLIDE smbullets small
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


!SLIDE smbullets small
# Prerequisites

To prepare the Graphite installation we need to install some required packages first:

    @@@Sh
    # yum install python2-pip gcc
    # yum install python-devel cairo-devel libffi-devel

Required packages for Graphite Web:

    @@@Sh
    # yum install python-scandir
    # yum install mod_wsgi

An exported shell variable will simplify the navigation when copying or moving files around:

    @@@Sh
    # export GRAPHITE=/opt/graphite


!SLIDE smbullets
# Installation

After all requirements are fulfilled, the installation of the Graphite components is pretty simple.

    @@@Sh
    # pip install carbon==1.0.1
    # pip install whisper==1.0.1
    # pip install graphite-web==1.0.1


!SLIDE smbullets small
# Python packages

Due to a bug in Carbon and Graphite Web >= 1.0.0 Python packages are not stored correctly, so we create symlinks as workaround:

    @@@Sh
    # ln -s $GRAPHITE/lib/carbon-1.0.1-py2.7.egg-info/ \
    /usr/lib/python2.7/site-packages/
    # ln -s $GRAPHITE/webapp/graphite_web-1.0.1-py.2.7.egg-info/ \
    /usr/lib/python2.7/site-packages/

Finally `pip` should list the installed Graphite packages:

    @@@Sh
    # pip list
    ...
    carbon (1.0.1)
    graphite-web (1.0.1)
    whisper (1.0.1)


!SLIDE small smbullets
# Configuration - Carbon Cache

All variations of the Carbon daemon (Cache, Aggregator and Relay) require some basic configuration. The PyPI packages provide for each configuration file at least one example. To be able to start Carbon Cache we need to copy at least two config files.

    @@@Sh
    # cp $GRAPHITE/conf/carbon.conf.example \
    $GRAPHITE/conf/carbon.conf

`carbon.conf` includes the basic configuration for all Carbon daemons (Cache, Aggregator and Relay). Options like IP's and ports to bind and some other settings are located here.

    @@@Sh
    # cp $GRAPHITE/conf/storage-schemas.conf.example \
    $GRAPHITE/conf/storage-schemas.conf

`storage-schemas.conf` includes configuration about the storage retention of metrics. More details about this will follow.


!SLIDE small
# Start - Carbon Cache

It's time to start the Carbon Cache daemon for the first time:

    @@@Sh
    # $GRAPHITE/bin/carbon-cache.py status
    carbon-cache (instance a) is not running

    # $GRAPHITE/bin/carbon-cache.py start
    Starting carbon-cache (instance a)

    # $GRAPHITE/bin/carbon-cache.py status
    carbon-cache (instance a) is running with pid 2344

**Note:** With this method Carbon Cache daemon will not be started after a reboot of the system.


!SLIDE smbullets smaller
# Systemd Service Unit

File: `/etc/systemd/system/carbon-cache.service`

    @@@Sh
    [Unit]
    Description=Graphite Carbon Cache
    After=network.target

    [Service]
    Type=forking
    StandardOutput=syslog
    StandardError=syslog
    ExecStart=/opt/graphite/bin/carbon-cache.py --config=/opt/graphite/conf/carbon.conf \
      --pidfile=/var/run/carbon-cache.pid --logdir=/var/log/carbon/ start
    ExecReload=/bin/kill -USR1 $MAINPID
    PIDFile=/var/run/carbon-cache.pid

    [Install]
    WantedBy=multi-user.target

Start Carbon Cache daemon with systemd:

    @@@Sh
    # $GRAPHITE/bin/carbon-cache.py stop

    # systemctl start carbon-cache.service
    # systemctl enable carbon-cache.service


!SLIDE small smbullets
# Configuration - Graphite Web

Graphite Web needs some more configuration. In addition to a working Apache 2 virtual host, the WSGI script and a basic configuration is required.

    @@@Sh
    # cp $GRAPHITE/examples/example-graphite-vhost.conf \
    /etc/httpd/conf.d/graphite-web.conf

    # cp $GRAPHITE/conf/graphite.wsgi.example \
    $GRAPHITE/conf/graphite.wsgi


!SLIDE smbullets small
# Configuration - Graphite Web

`local_settings.py` includes all configuration for the webapp. Here you can enable a memcache daemon and configure multiple Carbon Cache backends. For now we only need to set a secret key which is needed for the database initialization and adjust the time zone.

    @@@Sh
    # cp $GRAPHITE/webapp/graphite/local_settings.py.example \
    $GRAPHITE/webapp/graphite/local_settings.py

File: `/opt/graphite/webapp/graphite/local_settings.py`

    @@@Sh
    SECRET_KEY = 'random-string'

    TIME_ZONE = 'Europe/Berlin'


!SLIDE smbullets small
# Initalization - Graphite Web

We will use a SQLite database which needs to be initialized first:

    @@@Sh
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py \
    migrate --settings=graphite.settings --run-syncdb

And also the static files:

    @@@Sh
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py \
    collectstatic --noinput --settings=graphite.settings

The initialization of the DB also creates a user. This user can later be used to login to Graphite Web and store graphs and dashboards. 

<br/><br/>
Django's command-line utility also provides subcommands to `check` and `test` the installed components.

    @@@Sh
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py check \
    --settings=graphite.settings
    # PYTHONPATH=$GRAPHITE/webapp django-admin.py test \
    --settings=graphite.settings


!SLIDE smbullets small
# Permissions - Graphite Web

The SQLite database and the webapp logs are located in the storage directory, therefore we change the owner to `apache`.

    @@@Sh
    # chown apache:root $GRAPHITE/storage
    # chown apache:apache $GRAPHITE/storage/graphite.db

It's also important to change the permissions for the log directory, otherwise you will get the error: `"populate() isn't reentrant"`.

    @@@Sh
    # chown -Rf apache:root $GRAPHITE/storage/log


!SLIDE smbullets small
# Apache - Graphite Web

The default HTTP name for Graphite Web is `graphite` and configured in `graphite-web.conf`. In order to access Graphite Web we have to set permissions to the static directory.

File: `/etc/httpd/conf.d/graphite-web.conf`

    @@@Sh
    <Directory /opt/graphite/static>
        Require all granted
    </Directory>

Finally we can start the Apache webserver:

    @@@Sh
    # systemctl start httpd.service
    # systemctl enable httpd.service


!SLIDE smbullets
# Verification

To prove if everything worked open your browser with the default URL of Graphite Web: http://graphite

However it's **always** recommended to **have a look at the logs**!

* Graphite Web: `/opt/graphite/storage/log/webapp/`
* Carbon Cache: `/var/log/carbon/`
* Apache: `/var/log/httpd/`


!SLIDE smbullets smaller
# Package Installation Overview

Graphite 0.9.16 on CentOS 7:

    @@@Sh
    # yum install python-carbon python-whisper graphite-web
    # systemctl enable carbon-cache.service --now

File: `/etc/graphite-web/local_settings.py`

    SECRET_KEY = 'random-key'
    TIME_ZONE = 'Europe/Berlin'

    # python /usr/lib/python2.7/site-packages/graphite/manage.py syncdb

File: `/etc/httpd/conf.d/graphite-web.conf`

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

Graphite Web URL: http://graphite-web<br/>
Configs: `/etc/carbon/` and `/etc/graphite-web/`<br/>
Logs: `/var/log/carbon/` and `/var/log/httpd/`
