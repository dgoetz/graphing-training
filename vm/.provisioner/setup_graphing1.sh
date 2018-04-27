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
yum -y install vim-enhanced epel-release nmap-ncat tree centos-release-scl rsync git mailx

# Graphite
yum -y install python2-pip gcc
yum -y install python-devel cairo-devel libffi-devel

cp /usr/local/src/carbon/carbon-cache-a.service /etc/systemd/system/carbon-cache-a.service
cp /usr/local/src/carbon/carbon-cache-b.service /etc/systemd/system/carbon-cache-b.service
cp /usr/local/src/carbon/carbon-relay.service /etc/systemd/system/carbon-relay.service
cp /usr/local/src/carbon/carbon-aggregator.service /etc/systemd/system/carbon-aggregator.service
systemctl daemon-reload

# Graphite-Web
yum -y install python-scandir mod_wsgi
yum -y install dejavu-sans-fonts dejavu-serif-fonts
yum -y install MySQL-python

# collectd
yum -y install collectd
systemctl stop collectd.service
systemctl disable collectd.service

cp /usr/local/src/collectd/df.conf /etc/collectd.d/df.conf
cp /usr/local/src/collectd/write_graphite.conf /etc/collectd.d/write_graphite.conf
cp /usr/local/src/collectd/network.conf /etc/collectd.d/network.conf

# Grafana
cp /usr/local/src/grafana/grafana.repo /etc/yum.repos.d/grafana.repo
rpm --import https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
yum -y install grafana
systemctl stop grafana-server.service
systemctl disable grafana-server.service

# StatsD
yum -y install statsd
systemctl stop statsd.service
systemctl disable statsd.service

# InfluxDB
cp /usr/local/src/influxdb/influxdb.repo /etc/yum.repos.d/influxdb.repo
yum -y install influxdb chronograf telegraf
systemctl stop influxdb.service
systemctl disable influxdb.service
systemctl stop chronograf.service
systemctl disable chronograf.service
systemctl stop telegraf.service
systemctl disable telegraf.service

# Icinga
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

yum -y install icingaweb2 icingacli
rsync -a --delete /usr/local/src/icingaweb2/etc/ /etc/icingaweb2/
ln -s /usr/share/icingaweb2/modules/monitoring /etc/icingaweb2/enabledModules/monitoring
chown -Rf apache:icingaweb2 /etc/icingaweb2
mysql -u root -pnetways < /usr/local/src/icingaweb2/icingaweb2.sql
mysql -u root -pnetways -e "GRANT USAGE ON *.* TO 'icingaweb2'@'localhost' IDENTIFIED BY 'icingaweb2';"
mysql -u root -pnetways -e "GRANT SELECT ON icinga.* TO 'icingaweb2'@'localhost';"
mysql -u root -pnetways -e "GRANT CREATE TEMPORARY TABLES, EXECUTE ON icingaweb2.* TO 'icingaweb2'@'localhost';"
mysql -u root -pnetways -e "GRANT SELECT, INSERT, UPDATE, DELETE ON icingaweb2.icingaweb_user TO 'icingaweb2'@'localhost';"
mysql -u root -pnetways -e "GRANT SELECT, INSERT, UPDATE, DELETE ON icingaweb2.icingaweb_group TO 'icingaweb2'@'localhost';"
mysql -u root -pnetways -e "GRANT SELECT, INSERT, UPDATE, DELETE ON icingaweb2.icingaweb_user_preference TO 'icingaweb2'@'localhost';"
mysql -u root -pnetways -e "GRANT SELECT, INSERT, UPDATE, DELETE ON icingaweb2.icingaweb_group_membership TO 'icingaweb2'@'localhost';"
echo "date.timezone = 'Europe/Berlin'" >> /etc/opt/rh/rh-php71/php.ini
systemctl start rh-php71-php-fpm.service
systemctl enable rh-php71-php-fpm.service
systemctl start httpd.service
systemctl enable httpd.service

icinga2 pki new-ca
cp /var/lib/icinga2/ca/ca.crt /var/lib/icinga2/certs/
icinga2 pki new-cert --cn graphing1.localdomain --key /var/lib/icinga2/certs/graphing1.localdomain.key --csr /var/lib/icinga2/certificate-requests/graphing1.localdomain.csr
icinga2 pki sign-csr --csr /var/lib/icinga2/certificate-requests/graphing1.localdomain.csr --cert /var/lib/icinga2/certs/graphing1.localdomain.crt
icinga2 feature enable api

echo 'include_recursive "training"' >> /etc/icinga2/icinga2.conf
mkdir /etc/icinga2/training
chmod 0750 /etc/icinga2/training
chown icinga:icinga /etc/icinga2/training
cp /usr/local/src/icinga/api.conf /etc/icinga2/training/
cp /usr/local/src/icinga/hosts.conf /etc/icinga2/training/
cp /usr/local/src/icinga/notifications.conf /etc/icinga2/training/
cp /usr/local/src/icinga/services.conf /etc/icinga2/training/
cp /usr/local/src/icinga/templates.conf /etc/icinga2/training/
cp /usr/local/src/icinga/users.conf /etc/icinga2/training/
systemctl restart icinga2.service

# check_graphite
git clone https://github.com/obfuscurity/nagios-scripts.git /usr/local/src/nagios-scripts
cp /usr/local/src/nagios-scripts/check_graphite /usr/lib64/nagios/plugins/
yum -y install rubygem-rest-client

# Elasticsearch
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cp /usr/local/src/elastic/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
yum -y install java-1.8.0-openjdk elasticsearch
systemctl start elasticsearch.service
systemctl disable elasticsearch.service

# Kibana
cp /usr/local/src/elastic/kibana.repo /etc/yum.repos.d/kibana.repo
yum -y install kibana
echo 'server.host: "0.0.0.0"' >> /etc/kibana/kibana.yml
systemctl start kibana.service
systemctl disable kibana.service

# Icingabeat
yum -y install https://github.com/Icinga/icingabeat/releases/download/v6.1.1/icingabeat-6.1.1.x86_64.rpm
icingabeat setup
systemctl disable icingabeat
