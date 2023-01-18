#!/bin/bash
apt-get update
apt-get -y install squid3
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/squid-conf" -H "Metadata-Flavor: Google" -o squid.conf
mv /etc/squid/squid.conf /etc/squid/squid.conf.old
mv ./squid.conf /etc/squid/
systemctl enable squid
systemctl restart squid
ufw allow 3128/tcp
systemctl status squid