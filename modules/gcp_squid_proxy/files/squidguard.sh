#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# Install steps here: https://dsi.ut-capitole.fr/cours/TP_squid.pdf
# Install squidguard
apt-get install -y squidguard

# Download squidguard database
rm -rf /var/tmp/blacklist* >/dev/null 2>&1
wget -q ftp://ftp.univ-tlse1.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz -O /var/tmp/blacklists.tar.gz
if [ -f /var/tmp/blacklists.tar.gz ]; then
        tar xf /var/tmp/blacklists.tar.gz -C cd /var/lib/squidguard/db
fi

# Redirect squid requests to squidGuard
cat << 'EOF' > /etc/squid/conf.d/squidguard.conf
url_rewrite_program /usr/bin/squidGuard
EOF

# Configure squidGuard
cat << 'EOF' > /etc/squidGuard/squidGuard.conf
#/etc/squidguard/squidGuard.conf
#
# CONFIG FILE FOR SQUIDGUARD
#
# Caution: do NOT use comments inside { }
#

dbhome /var/lib/squidguard/db
logdir /var/log/squidguard

src lan {
    ip 192.168.0.0/16 172.16.0.0/12 10.0.0.0/8 127.0.0.0/8
}

dest adult {
    domainlist        blacklists/porn/domains
    urllist           blacklists/porn/urls
    expressionlist    blacklists/porn/expressions
    redirect          307:https://lite.qwant.com/?
}

acl {
  lan {
        pass !adult all
        redirect 307:https://lite.qwant.com/?
  }
  default {
        pass none
        redirect 307:https://lite.qwant.com/?
  }
}
EOF