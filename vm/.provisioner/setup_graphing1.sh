#!/bin/bash

# Timezone
timedatectl set-timezone Europe/Berlin

# Users
userdel -r vagrant
useradd -c "NETWAYS Training" -p `openssl passwd -1 netways` training

if [ -f /etc/sudoers.d/vagrant ]; then
  rm /etc/sudoers.d/vagrant
fi

echo "%training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/training

echo -e 'Username: training' >> /etc/issue
echo -e 'Password: netways' >> /etc/issue
echo -e '' >> /etc/issue

# DNS
echo -e '' >> /etc/hosts
echo -e '192.168.56.101 \t graphing1.localdomain graphing1 graphite' >> /etc/hosts
echo -e '192.168.56.102 \t graphing2.localdomain graphing2' >> /etc/hosts

# Base
yum -y install yum-plugin-fastestmirror deltarpm vim-enhanced epel-release nmap-ncat tree rsync git mailx
yum -y update

# Graphite
yum -y install python2-pip gcc
yum -y install python-devel cairo-devel libffi-devel

install -m 0644 -o root -g root /usr/local/src/carbon/carbon-cache-a.service /etc/systemd/system/carbon-cache-a.service
install -m 0644 -o root -g root /usr/local/src/carbon/carbon-cache-b.service /etc/systemd/system/carbon-cache-b.service
install -m 0644 -o root -g root /usr/local/src/carbon/carbon-relay.service /etc/systemd/system/carbon-relay.service
install -m 0644 -o root -g root /usr/local/src/carbon/carbon-aggregator.service /etc/systemd/system/carbon-aggregator.service
systemctl daemon-reload

# Graphite-Web
yum -y install python-scandir mod_wsgi
yum -y install dejavu-sans-fonts dejavu-serif-fonts
yum -y install MySQL-python

# collectd
yum -y install collectd
systemctl stop collectd.service
systemctl disable collectd.service

install -m 0644 -o root -g root /usr/local/src/collectd/df.conf /etc/collectd.d/df.conf
install -m 0644 -o root -g root /usr/local/src/collectd/network.conf /etc/collectd.d/network.conf
install -m 0644 -o root -g root /usr/local/src/collectd/write_graphite.conf /etc/collectd.d/write_graphite.conf

# Grafana
install -m 0644 -o root -g root /usr/local/src/grafana/grafana.repo /etc/yum.repos.d/grafana.repo
rpm --import https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
yum -y install grafana
systemctl stop grafana-server.service
systemctl disable grafana-server.service

# StatsD
yum -y install statsd
systemctl stop statsd.service
systemctl disable statsd.service

# InfluxDB
install -m 0644 -o root -g root /usr/local/src/influxdb/influxdb.repo /etc/yum.repos.d/influxdb.repo
yum -y install influxdb chronograf telegraf
systemctl stop influxdb.service
systemctl disable influxdb.service
systemctl stop chronograf.service
systemctl disable chronograf.service
systemctl stop telegraf.service
systemctl disable telegraf.service

# Icinga 2
yum -y install mariadb-server
systemctl start mariadb.service
systemctl enable mariadb.service
echo -e "\n\nnetways\nnetways\n\n\nn\n\n " | mysql_secure_installation 2>/dev/null
mysql -u root -pnetways -e "CREATE DATABASE icinga;"
mysql -u root -pnetways -e "GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga';"

rpm --import https://packages.icinga.com/icinga.key
yum -y install https://packages.icinga.com/epel/icinga-rpm-release-7-latest.noarch.rpm
yum -y install icinga2 icinga2-ido-mysql nagios-plugins-all
mysql -u root -pnetways icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql
systemctl start icinga2.service
systemctl enable icinga2.service

icinga2 pki new-ca
install -m 0644 -o icinga -g icinga /var/lib/icinga2/ca/ca.crt /var/lib/icinga2/certs/
icinga2 pki new-cert --cn graphing1.localdomain --key /var/lib/icinga2/certs/graphing1.localdomain.key --csr /var/lib/icinga2/certificate-requests/graphing1.localdomain.csr
icinga2 pki sign-csr --csr /var/lib/icinga2/certificate-requests/graphing1.localdomain.csr --cert /var/lib/icinga2/certs/graphing1.localdomain.crt
icinga2 feature enable api

echo 'include_recursive "training"' >> /etc/icinga2/icinga2.conf

install -m 0750 -o icinga -g icinga -d /etc/icinga2/training
install -m 0640 -o icinga -g icinga /usr/local/src/icinga/api.conf /etc/icinga2/training/
install -m 0640 -o icinga -g icinga /usr/local/src/icinga/hosts.conf /etc/icinga2/training/
install -m 0640 -o icinga -g icinga /usr/local/src/icinga/notifications.conf /etc/icinga2/training/
install -m 0640 -o icinga -g icinga /usr/local/src/icinga/services.conf /etc/icinga2/training/
install -m 0640 -o icinga -g icinga /usr/local/src/icinga/templates.conf /etc/icinga2/training/
install -m 0640 -o icinga -g icinga /usr/local/src/icinga/users.conf /etc/icinga2/training/
systemctl restart icinga2.service

# Icinga Web 2
yum -y install centos-release-scl
yum -y install icingaweb2 icingacli
yum -y install sclo-php71-php-pecl-imagick

install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/authentication.ini /etc/icingaweb2/authentication.ini
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/config.ini /etc/icingaweb2/config.ini
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/groups.ini /etc/icingaweb2/groups.ini
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/resources.ini /etc/icingaweb2/resources.ini
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/roles.ini /etc/icingaweb2/roles.ini

sudo -u apache icingacli module enable monitoring

install -m 0770 -o root -g icingaweb2 -d /etc/icingaweb2/modules/monitoring
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/modules/monitoring/backends.ini /etc/icingaweb2/modules/monitoring/backends.ini
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/modules/monitoring/commandtransports.ini /etc/icingaweb2/modules/monitoring/commandtransports.ini
install -m 0660 -o apache -g icingaweb2 /usr/local/src/icingaweb2/modules/monitoring/config.ini /etc/icingaweb2/modules/monitoring/config.ini

mysql -u root -pnetways -e "CREATE DATABASE icingaweb2;"
mysql -u root -pnetways -e "GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icingaweb2.* TO 'icingaweb2'@'localhost' IDENTIFIED BY 'icingaweb2';"
mysql -u root -pnetways -e "GRANT SELECT ON icinga.* TO 'icingaweb2'@'localhost';"

mysql -u root -pnetways icingaweb2 < /usr/share/doc/icingaweb2/schema/mysql.schema.sql
mysql -u root -pnetways icingaweb2 -e "INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('icingaadmin', 1, '\$2y\$10\$X1vz9OKE7Le/DQPWFxnkUuz3r17ZoHiQka4olknd.v14ABaoMVvWC');"

echo "date.timezone = 'Europe/Berlin'" >> /etc/opt/rh/rh-php71/php.ini
systemctl start rh-php71-php-fpm.service
systemctl enable rh-php71-php-fpm.service
systemctl start httpd.service
systemctl enable httpd.service

# check_graphite
git clone https://github.com/obfuscurity/nagios-scripts.git /usr/local/src/nagios-scripts
install -m 0755 -o root -g root /usr/local/src/nagios-scripts/check_graphite /usr/lib64/nagios/plugins/
yum -y install rubygem-rest-client

# Elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
install -m 0644 -o root -g root /usr/local/src/elastic/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
yum -y install java-1.8.0-openjdk elasticsearch
systemctl start elasticsearch.service
systemctl disable elasticsearch.service

# Kibana
install -m 0644 -o root -g root /usr/local/src/elastic/kibana.repo /etc/yum.repos.d/kibana.repo
yum -y install kibana
echo 'server.host: "0.0.0.0"' >> /etc/kibana/kibana.yml
systemctl start kibana.service
systemctl disable kibana.service

# Icingabeat
yum -y install https://github.com/Icinga/icingabeat/releases/download/v6.1.1/icingabeat-6.1.1.x86_64.rpm
icingabeat setup
systemctl disable icingabeat
