#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_func"
source "$(dirname "$0")/ft-util/ft_util_inc_var"
source "$(dirname "$0")/ft-util/ft_util_sudoersd"

app_name="ft-fail2ban"

# Checking which Zabbix Agent is detected and adjust include directory
$(which zabbix_agent2 >/dev/null) && zbx_conf_agent_d="/etc/zabbix/zabbix_agent2.d"
$(which zabbix_agentd >/dev/null) && zbx_conf_agent_d="/etc/zabbix/zabbix_agentd.conf.d"
if [ ! -d "${zbx_conf_agent_d}" ]; then
  $S_LOG -s crit -d $S_NAME "${zbx_conf_agent_d} Zabbix Include directory not found"
  exit 10
fi

$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"

echo "
  SETUP SUDOER FILES
------------------------------------------"

# Setup sudoers file for Zabbix
bak_if_exist "/etc/sudoers.d/${app_name}"
sudoersd_reset_file $app_name zabbix
sudoersd_addto_file $app_name zabbix "${S_DIR_PATH}/deploy-update.sh"
sudoersd_addto_file $app_name zabbix "$(type -p fail2ban-client) status"
sudoersd_addto_file $app_name zabbix "$(type -p fail2ban-client) status ^[-a-zA-Z0-9_]+$"
show_bak_diff_rm "/etc/sudoers.d/${app_name}"

echo "
  INSTALL ZABBIX FILES
------------------------------------------"

$S_DIR_PATH/ft-util/ft_util_file-deploy "$S_DIR/etc.zabbix/${app_name}.conf" "${zbx_conf_agent_d}/${app_name}.conf"

echo "
  RESTART ZABBIX LATER
------------------------------------------"

echo "systemctl restart zabbix-agent*" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"
