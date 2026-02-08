# Fail2Ban template for Zabbix

Zabbix template and helper scripts to discover Fail2Ban jails and collect service/jail metrics.

## Features

- Automatic discovery of jails
- Monitor Fail2Ban service status
- Monitor jail status and counters
- Graphs for jail activity

## Deploy Commands

Everything is executed by only a few basic deploy scripts. 

```bash
cd /usr/local/src
git clone https://github.com/Futur-Tech/futur-tech-zabbix-fail2ban.git
cd futur-tech-zabbix-fail2ban

./deploy.sh 
# Main deploy script

./deploy-update.sh -b main
# This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.
```

Finally import the template YAML in Zabbix Server and attach it to your host.

## Security note

Compared to the parent repository, this fork uses a sudoers entry to allow the `zabbix` user to run the specific Fail2Ban command. This avoids changing group ownership or file permissions on Fail2Ban data.

## Credits

Original repository: https://github.com/hermanekt/zabbix-fail2ban-discovery-
