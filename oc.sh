#!/bin/sh

oc project $1

# usage: /oc.sh <project_name> <dumper|wdqs-jnl|wdqs-run|all> <now>

if [[ "$3" == 'now' ]];
    then
        case $2 in
            dumper)
                /oc_cron.sh dumper;;
            wdqs-jnl)
                /oc_cron.sh wdqs-jnl;;
            wdqs-restart)
                /oc_cron.sh wdqs-restart;;
            wdqs-run)
                /oc_cron.sh wdqs-run;;
            all)
                /oc_cron.sh dumper
                /oc_cron.sh wdqs-jnl
                /oc_cron.sh wdqs-restart
                sleep 30
                /oc_cron.sh wdqs-run;;
        esac
    else
        echo "3    0       *       *       *       /oc_cron.sh dumper" >> /var/spool/cron/crontabs/root
        echo "4    0       *       *       *       /oc_cron.sh wdqs-jnl" >> /var/spool/cron/crontabs/root
        echo "5    0       *       *       *       /oc_cron.sh wdqs-restart" >> /var/spool/cron/crontabs/root
        echo "6    0       *       *       *       /oc_cron.sh wdqs-run" >> /var/spool/cron/crontabs/root
fi
