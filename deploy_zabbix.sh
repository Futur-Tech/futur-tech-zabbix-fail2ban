#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SCRIPTNAME="$0"
ARGS="$@"

BRANCH="master"

echo "hello"

self_update() {
    cd $SCRIPTPATH

    git config core.filemode false

    [ -n $(git diff --name-only origin/$BRANCH | grep $SCRIPTNAME) ] && {
        echo "Found a new version of me, updating myself..."
        git pull --force
        git checkout $BRANCH
        git pull --force
        echo "Running the new version..."
        exec "$SCRIPTNAME" "$@"

        # Now exit this old instance
        exit 1
    }
    echo "Already the latest version."
}

main() {
    SOURCE_DIR=$(dirname $0)
    ZABBIX_DIR=/etc/zabbix

    cp -rv ${SOURCE_DIR}/custix/fail2ban.conf   ${ZABBIX_DIR}/zabbix_agentd.d/fail2ban.conf

    systemctl restart zabbix-agent.service
}

self_update
main
