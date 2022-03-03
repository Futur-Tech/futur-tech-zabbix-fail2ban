#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

SRC_DIR="/usr/local/src"
SUDOERS_ETC="/etc/sudoers.d/ft-fail2ban"

# Checking which Zabbix Agent is detected and adjust include directory
$(which zabbix_agent2 >/dev/null) && ZBX_CONF_AGENT_D="/etc/zabbix/zabbix_agent2.d"
$(which zabbix_agentd >/dev/null) && ZBX_CONF_AGENT_D="/etc/zabbix/zabbix_agentd.conf.d"
if [ ! -d "${ZBX_CONF_AGENT_D}" ] ; then $S_LOG -s crit -d $S_NAME "${ZBX_CONF_AGENT_D} Zabbix Include directory not found" ; exit 10 ; fi


$S_LOG -d $S_NAME "Start $S_NAME $*"

echo "
  SETUP SUDOER FILES
------------------------------------------"

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

echo "Defaults:zabbix !requiretty" | sudo EDITOR='tee' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:${S_DIR_PATH}/deploy-update.sh" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:/usr/bin/fail2ban-client status" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:/usr/bin/fail2ban-client status *" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null

cat $SUDOERS_ETC | $S_LOG -d "$S_NAME" -d "$SUDOERS_ETC" -i 

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="


echo "
  INSTALL ZABBIX FILES
------------------------------------------"

$S_DIR_PATH/ft-util/ft_util_file-deploy "$S_DIR/zbx.conf/ft-fail2ban.conf" "${ZBX_CONF_AGENT_D}/ft-fail2ban.conf"


echo "
  RESTART ZABBIX LATER
------------------------------------------"

echo "systemctl restart zabbix-agent*" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"
