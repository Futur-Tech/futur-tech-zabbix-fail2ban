# Fail2Ban template for Zabbix
## Features

- Automatic discovery of jails
- Monitor service status
- Monitor jails
- Jails graph

## Installation

    cd /usr/local/src
    git clone https://github.com/Futur-Tech/futur-tech-zabbix-fail2ban
    cd futur-tech-zabbix-fail2ban ; ./deploy.sh

## deploy-update.sh
  
    ./deploy-update.sh -b main
    
This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.

## Note

The main difference with the parent repo is that I took a different approach on security. Instead of adding group and changing permissions on files I added a sudoers file to allow zabbix user to sudo the specific fail2ban command.

## Credits

Original repository: (https://github.com/hermanekt/zabbix-fail2ban-discovery-)
