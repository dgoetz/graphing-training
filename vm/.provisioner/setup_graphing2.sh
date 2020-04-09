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
yum -y install yum-plugin-fastestmirror deltarpm yum-utils vim-enhanced epel-release nmap-ncat tree rsync
yum -y update

# Graphite
yum -y install python3 python3-devel gcc

cd /opt/
python3 -m venv graphite
source graphite/bin/activate

pip install --upgrade pip setuptools
pip install whisper==1.1.7
pip install Django==2.1
pip install carbon==1.1.7

mv /opt/graphite/lib/python3.6/site-packages/carbon/ /opt/graphite/lib/
mv /opt/graphite/lib/python3.6/site-packages/carbon-1.1.7-py3.6.egg-info/ /opt/graphite/lib/
mv /opt/graphite/lib/python3.6/site-packages/twisted/ /opt/graphite/lib/
ln -s /opt/graphite/lib/carbon-1.1.7-py3.6.egg-info/ /opt/graphite/lib/python3.6/site-packages/

install -m 0644 -o root -g root /usr/local/src/carbon/carbon.conf /opt/graphite/conf/carbon.conf
install -m 0644 -o root -g root /usr/local/src/carbon/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
install -m 0644 -o root -g root /opt/graphite/conf/aggregation-rules.conf.example /opt/graphite/conf/aggregation-rules.conf

install -m 0644 -o root -g root /usr/local/src/carbon/carbon-cache-a.service /etc/systemd/system/carbon-cache-a.service
install -m 0644 -o root -g root /usr/local/src/carbon/carbon-cache-b.service /etc/systemd/system/carbon-cache-b.service
install -m 0644 -o root -g root /usr/local/src/carbon/carbon-aggregator.service /etc/systemd/system/carbon-aggregator.service
install -m 0644 -o root -g root /usr/local/src/carbon/carbon-relay.service /etc/systemd/system/carbon-relay.service
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
yum -y install httpd httpd-devel
yum -y install dejavu-sans-fonts dejavu-serif-fonts
yum -y install cairo-devel libffi-devel

pip install graphite-web==1.1.7
pip install mod-wsgi
mod_wsgi-express install-module > /etc/httpd/conf.modules.d/02-wsgi.conf

mv /opt/graphite/lib/python3.6/site-packages/graphite/ /opt/graphite/webapp/
mv /opt/graphite/lib/python3.6/site-packages/graphite_web-1.1.7-py3.6.egg-info/ /opt/graphite/webapp/
ln -s /opt/graphite/webapp/graphite_web-1.1.7-py3.6.egg-info/ /opt/graphite/lib/python3.6/site-packages/

install -m 0755 -o root -g root /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
install -m 0644 -o root -g root /usr/local/src/graphite-web/graphite-web.conf /etc/httpd/conf.d/graphite-web.conf
install -m 0644 -o root -g root /usr/local/src/graphite-web/local_settings.py /opt/graphite/webapp/graphite/local_settings.py

PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
PYTHONPATH=/opt/graphite/webapp django-admin.py collectstatic --noinput --settings=graphite.settings
deactivate

chown apache:root /opt/graphite/storage
chown apache:apache /opt/graphite/storage/graphite.db
chown -Rf apache:root /opt/graphite/storage/log

systemctl start httpd.service
systemctl enable httpd.service

# Clean old kernels
package-cleanup -y --oldkernels --count=2
