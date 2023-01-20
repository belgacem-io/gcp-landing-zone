#!/bin/bash
apt-get update
apt-get -y install squid
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/squid-conf" -H "Metadata-Flavor: Google" -o squid.conf
mv /etc/squid/squid.conf /etc/squid/squid.conf.old
mv ./squid.conf /etc/squid/
# Route inbound traffic into squid
%{ for addr in trusted_cidr_ranges ~}
iptables -t nat -I PREROUTING 1 -s ${addr} -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -I PREROUTING 1 -s ${addr} -p tcp --dport 443 -j REDIRECT --to-port 3128
iptables -t nat -I PREROUTING 1 -s ${addr} -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -I PREROUTING 1 -s ${addr} -p tcp --dport 443 -j REDIRECT --to-port 3128
%{ endfor ~}
systemctl enable squid
systemctl restart squid
ufw allow 3128/tcp
systemctl status squid