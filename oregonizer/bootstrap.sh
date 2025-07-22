#!/bin/bash
yum update
yum install -y squid
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
sed -i 's/3128/23/g' /etc/squid/squid.conf
sed -i '/machines/a acl home src ${home_ip}' /etc/squid/squid.conf
sed -i '/CLIENTS/a http_access allow home' /etc/squid/squid.conf
service squid start
