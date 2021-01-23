#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SOURCE_DIR=$(dirname $0)
ZABBIX_DIR=/etc/zabbix
SCRIPTNAME="$0"
ARGS="$@"

BRANCH="master"

self_update() {
    cd $SOURCE_DIR
    git checkout $BRANCH
    git fetch

    DIFF="$(git diff --name-only origin/$BRANCH)"
    [ -n "DIFF" ] || {
        echo "Found a new version of me, updating myself..."
        git pull --force
        echo "Running the new version..."
        exec "$SCRIPTNAME" "$@"

        # Now exit this old instance
        exit 1
    }
    echo "Already the latest version."
}

main() {

    cp -rv ${SOURCE_DIR}/fail2ban.conf ${ZABBIX_DIR}/zabbix_agentd.d/fail2ban.conf

    systemctl restart zabbix-agent.service
}

self_update
main
