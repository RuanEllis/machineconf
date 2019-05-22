#!/bin/bash


export `/opt/dell/srvadmin/sbin/racadm get System.CustomAsset.1.Value | tail -n2 | head -n1`

machinetype=$(/opt/dell/srvadmin/sbin/racadm get BIOS.SysInformation)

echo $machinetype | grep -q C4140
MACHINECHECK=$?

grep -q 'BIOSCONFIG' /proc/cmdline
CMDLINECHECK=$?

if [[ $CMDLINECHECK -eq 0 ]] && [[ "$Value" != 'true' ]] && [[ $MACHINECHECK -eq 0 ]]
then
   sleep 20
   echo "Detected a C4140 series machine - Now configuring BIOS, machine will reboot shortly" | wall
   wget -O /root/c4140_config.xml http://10.150.0.10/repo/machineconf/dell/c4140/c4140_config.xml
   /opt/dell/srvadmin/sbin/racadm set -f /root/c4140_config.xml -t xml
   sed -i '/c4140/d' /var/spool/cron/root
else
   sleep 20
   echo "System already configured or machine type is not a Dell C4140 - abandoning." | wall
   sed -i '/c4140/d' /var/spool/cron/root
   sleep 2
fi
