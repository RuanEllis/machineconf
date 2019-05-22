#!/bin/bash

export `/opt/dell/srvadmin/sbin/racadm get System.CustomAsset.1.Value | tail -n2 | head -n1`

machinetype=$(/opt/dell/srvadmin/sbin/racadm get System.ChassisInfo)

echo $machinetype | grep -q C6400
MACHINECHECK=$?

grep -q 'BIOSCONFIG' /proc/cmdline
CMDLINECHECK=$?

if [[ $CMDLINECHECK -eq 0 ]] && [[ "$Value" != 'true' ]] && [[ $MACHINECHECK -eq 0 ]]
then
   sleep 20
   echo "Detected a C6400 series machine - Now configuring BIOS, machine will reboot shortly" | wall
   wget -O /root/c6420_config.xml http://10.150.0.10/repo/machineconf/dell/c6420/c6420_config.xml
   /opt/dell/srvadmin/sbin/racadm set -f /root/c6420_config.xml -t xml
   sed -i '/c6420/d' /var/spool/cron/root
else
   sleep 20
   echo "System already configured or machine type is not a Dell C6400 - abandoning." | wall
   sed -i '/c6420/d' /var/spool/cron/root
   sleep 2
fi
