#!/bin/bash
. /root/functions.sh  --source-only

cd /var/lib/apacheds-2.0.0-M21/default || exit
rm -rf *
cd / || exit
tar xvf /backup/backup.tar

/etc/init.d/apacheds-2.0.0-M21-default start
/etc/init.d/xinetd restart

sleep 30
RUNNING=`/etc/init.d/apacheds-2.0.0-M21-default status | grep not`
if [ -n "${RUNNING}" ]; then
 /etc/init.d/apacheds-2.0.0-M21-default restart
 sleep 30
fi

check_login

check_partition


if [ -n "${PARTITION}" ]; then
    echo Partition already present
else
    echo Error Partition not present exiting
    exit -1
fi

enable_replication
setup_replication

nohup /root/replica_check.sh 0<&- &> /tmp/replica_check.log &


/etc/init.d/apacheds-2.0.0-M21-default stop
/etc/init.d/apacheds-2.0.0-M21-default console
