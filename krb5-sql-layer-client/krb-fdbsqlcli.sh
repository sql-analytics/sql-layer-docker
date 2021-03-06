#!/bin/bash

sed -i -e "s/kdc.docker.local/$KDC_PORT_88_UDP_ADDR/g" /etc/krb5.conf

sed -e "s/sql\$/sql krbsql.docker.local/g" /etc/hosts >/tmp/hosts
cp /tmp/hosts /etc/hosts

kinit $KRB_USER

args_file=$(mktemp)
echo -h krbsql.docker.local -u $KRB_USER $FDBSQLCLI_ARGS >$args_file
xargs -a $args_file fdbsqlcli
