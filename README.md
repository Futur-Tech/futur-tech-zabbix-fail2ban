# Fail2Ban template for Zabbix
## Features

- Automatic discovery of jails
- Monitor service status
- Monitor jails
- Jails graph

## Installation

    cd /usr/local/src
    git clone https://github.com/GuillaumeHullin/futur-tech-zabbix-fail2ban
    cd futur-tech-zabbix-fail2ban ; ./deploy.sh

## Update

    /usr/local/src/futur-tech-zabbix-fail2ban/deploy-update.sh -b main

## Note

The main difference with the parent repo is that I took a different approach on security. Instead of adding group and changing permissions on files I added a sudoers file to allow zabbix user to sudo the specific fail2ban command.

## Credits

Original repository: (https://github.com/hermanekt/zabbix-fail2ban-discovery-)