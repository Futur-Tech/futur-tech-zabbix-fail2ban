#!/usr/bin/env bash
SOURCE_DIR=$(dirname $0)
ZABBIX_DIR=/etc/zabbix

cp -rv ${SOURCE_DIR}/custix/fail2ban.conf   ${ZABBIX_DIR}/zabbix_agentd.d/fail2ban.conf