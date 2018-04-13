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
yum -y install vim-enhanced epel-release nmap-ncat tree rsync

# Graphite
yum -y install python2-pip gcc
yum -y install python-devel cairo-devel libffi-devel

pip install carbon==1.1.2
pip install whisper==1.1.2

ln -s /opt/graphite/lib/carbon-1.1.2-py2.7.egg-info/ /usr/lib/python2.7/site-packages/
cp /usr/local/src/carbon/carbon.conf /opt/graphite/conf/carbon.conf
cp /usr/local/src/carbon/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
cp /opt/graphite/conf/aggregation-rules.conf.example /opt/graphite/conf/aggregation-rules.conf

cp /usr/local/src/carbon/carbon-cache-a.service /etc/systemd/system/carbon-cache-a.service
cp /usr/local/src/carbon/carbon-cache-b.service /etc/systemd/system/carbon-cache-b.service
cp /usr/local/src/carbon/carbon-aggregator.service /etc/systemd/system/carbon-aggregator.service
cp /usr/local/src/carbon/carbon-relay.service /etc/systemd/system/carbon-relay.service
systemctl daemon-reload

systemctl start carbon-cache-a.service
systemctl enable carbon-cache-a.service
systemctl start carbon-cache-b.service
systemctl enable carbon-cache-b.service
systemctl start carbon-aggregator.service
systemctl enable carbon-aggregator.service
systemctl start carbon-relay.service
systemctl enable carbon-relay.service

# Graphite-Web
yum -y install python-scandir mod_wsgi
yum -y install dejavu-sans-fonts dejavu-serif-fonts

pip install graphite-web==1.1.2

ln -s /opt/graphite/webapp/graphite_web-1.1.2-py2.7.egg-info/ /usr/lib/python2.7/site-packages/

cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
cp /usr/local/src/graphite-web/graphite-web.conf /etc/httpd/conf.d/graphite-web.conf
cp /usr/local/src/graphite-web/local_settings.py /opt/graphite/webapp/graphite/local_settings.py

PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
PYTHONPATH=/opt/graphite/webapp django-admin.py collectstatic --noinput --settings=graphite.settings

chown apache:root /opt/graphite/storage
chown apache:apache /opt/graphite/storage/graphite.db
chown -Rf apache:root /opt/graphite/storage/log

systemctl start httpd.service
systemctl enable httpd.service

# Shutdown
shutdown -h now
