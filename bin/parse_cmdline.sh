#!/bin/bash

CONTROLLERIP=10.150.0.10

grep -q 'BIOSCONFIG' /proc/cmdline
CMDLINECHECK=$?
if [[ $CMDLINECHECK == 0 ]]
then
   grep -q 'C6420' /proc/cmdline
   CMDLINECHECK=$?
   if [[ $CMDLINECHECK == 0 ]]
   then
      wget -O /root/c6420_configure_me.sh http://${CONTROLLERIP}/repo/machineconf/dell/c6420/c6420_configure_me.sh
      chmod +x /root/c6420_configure_me.sh
      line="* * * * * /root/c6420_configure_me.sh"
      (crontab -u root -l; echo "$line" ) | crontab -u root -
   fi
   grep -q 'C4140' /proc/cmdline
   CMDLINECHECK=$?
   if [[ $CMDLINECHECK == 0 ]]
   then
      wget -O /root/c4140_configure_me.sh http://${CONTROLLERIP}/repo/machineconf/dell/c4140/c4140_configure_me.sh
      chmod +x /root/c4140_configure_me.sh
      line="* * * * * /root/c4140_configure_me.sh"
      (crontab -u root -l; echo "$line" ) | crontab -u root -
   fi
fi

