#!/bin/bash
apt-get update
apt-get -y install squid
curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/squid-conf" -H "Metadata-Flavor: Google" -o squid.conf
mv /etc/squid/squid.conf /etc/squid/squid.conf.old
mv ./squid.conf /etc/squid/
# Route inbound traffic into squid
%{ for port in safe_ports ~}
%{ for addr in trusted_cidr_ranges ~}
iptables -t nat -I PREROUTING 1 -s ${addr} -p tcp --dport ${port} -j REDIRECT --to-port 3128
%{ endfor ~}
%{ endfor ~}

systemctl enable squid
systemctl restart squid
ufw allow 3128/tcp
systemctl status squid