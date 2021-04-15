#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

ZBX_ETC="/etc/zabbix"
ZBX_CONF_AGENT="${ZBX_ETC}/zabbix_agentd.conf"
ZBX_CONF_AGENT_D="${ZBX_ETC}/zabbix_agentd.conf.d"
SRC_DIR="/usr/local/src"
SUDOERS_ETC="/etc/sudoers.d/ft-fail2ban"

$S_LOG -d $S_NAME "Start $S_NAME $*"

#############################
#############################
## SETUP SUDOER FILES
#############################
#############################

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="
$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==== SUDOERS CONFIGURATION ===="
$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

echo "Defaults:zabbix !requiretty" | sudo EDITOR='tee' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:${S_DIR_PATH}/deploy-update.sh" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:/usr/bin/fail2ban-client status" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:/usr/bin/fail2ban-client status *" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null

cat $SUDOERS_ETC | $S_LOG -d "$S_NAME" -d "$SUDOERS_ETC" -i 

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="
$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

#############################
#############################
## INSTALL ZABBIX FILES 
#############################
#############################

$S_DIR_PATH/ft-util/ft_util_file-deploy "$S_DIR/zbx.conf/ft-fail2ban.conf" "${ZBX_CONF_AGENT_D}/ft-fail2ban.conf"

#############################
#############################
## RESTART ZABBIX LATER
#############################
#############################

echo "service zabbix-agent restart" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"
