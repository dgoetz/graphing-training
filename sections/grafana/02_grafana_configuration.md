!SLIDE subsection
# ~~~SECTION:MAJOR~~~ Grafana Configuration


!SLIDE
# Configuration Files

Grafanas configuration files can be found at **/etc/grafana**.

* `/etc/grafana/grafana.ini`  // Main configuration file
* `/etc/grafana/provisioning` // Folder for provisioning files
* `/etc/grafana/ldap.toml`    // Ldap configuration file

!SLIDE small
# Configuration Files

The main configuration file is written in **INI** syntax and consists of multiple
sections.

### Sections
  * **[paths]**
    * Configration of data and log directories
  * **[server]**
    * Configuration of server related parameters as protocol and SSL
  * **[database]**
    * Configuration of external databases
  * **[session]**
    * Configuration of session handling
  * **[dataproxy]**
    * Enable or disable proxy logging
  * **[analytics]**
    * Send analytics to grafana
  * **[security]**
    * Security parameters
  * **[snapshots]**
    * Snapshot sharing options
  * **[auth]**
    * Authentications options
  * **[dashboards]**
  * **[users]**

!SLIDE

## Grafana Service

Grafana provides a all-in-one package and comes with a own binary which serves
its own webserver and database backend.

    @@@Sh
    $ systemctl status|start|stop|restart grafana-server.service


!SLIDE
## Configuration Backend

While a standard installation comes with a simple **sqlite** database backend to store configuration such as users, groups, dashboards and web sessions.

Grafana can also use MySQL and Postgresql as configuration backend, which is recommended when the application runs in High-Availability.

Default is a Sqlite Database:

    @@@Sh
    /var/lib/grafana/grafana.db

!SLIDE
## Configuration Backend

Grafana does all database migration while starting up, to change the database backend edit the database type, credentials and restart Grafana.

    @@@Sh
    $ vim /etc/grafana/grafana.ini
    [database]
    type = mysql
    host = 127.0.0.1:3306
    name = grafana
    user = root
    password = grafana123

    $ mysql -e "create database grafana;"

    $ systemctl restart grafana-server

    $ less /var/log/grafana.log
    lvl=info msg="Connecting to DB" logger=sqlstore dbtype=mysql
    lvl=info msg="Starting DB migration" logger=migrator
    lvl=info msg="Executing migration" logger=migrator id="create migration_log table"
    lvl=info msg="Executing migration" logger=migrator id="create user table"
