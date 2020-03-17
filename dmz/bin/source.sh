#!/bin/bash

trap 'rm output-$$' EXIT

USER=dmacias

# public ip of servers
AMER=$(grep AMER /etc/hosts | awk '{print $1}')
EMEA=$(grep EMEA /etc/hosts | awk '{print $1}')
APAC=$(grep APAC /etc/hosts | awk '{print $1}')
DEV=$(grep DEV /etc/hosts | awk '{print $1}')

# internal ip of servers
dsbamer=$(grep usdsb /etc/hosts | grep "10\." | awk '{print $1}')
dsbemea=$(grep nldsb /etc/hosts | grep "10\." | awk '{print $1}')
dsbapac=$(grep jpdsb /etc/hosts | grep "10\." | awk '{print $1}')

# inmon servers
inmonusa=$(grep inmonusa /etc/hosts | grep "10\." | grep 010 | awk '{print $1}')
inmonamer=$(grep inmonamer /etc/hosts | grep "10\." | awk '{print $1}')
inmonemea=$(grep inmonemea /etc/hosts | grep "10\." | awk '{print $1}')
inmonapac=$(grep inmonapac /etc/hosts | grep "10\." | awk '{print $1}')

# testing servers
archbox=$(grep arch$ /etc/hosts | grep "10\." | awk '{print $1}')
testing1=$(grep old-nld-dsb-lab /etc/hosts | grep "10\." | awk '{print $1}')
testing2=$(grep login.nwk /etc/hosts | grep "10\." | awk '{print $1}')
testing3=$(grep librenms-lab /etc/hosts | grep "10\." | awk '{print $1}')

# other resources
zabbix=$(grep zabbix.bet /etc/hosts | grep "10\." | awk '{print $1}')
racktables=$(grep racktables /etc/hosts | grep "10\." | awk '{print $1}')
intranet=$(grep intranet /etc/hosts | grep "10\." | awk '{print $1}')
#windowsbox=$(grep usrds006 /etc/hosts | grep "10\." | awk '{print $1}')
usrds006=$(grep usrds006 /etc/hosts | grep "10\." | awk '{print $1}')
windowsbox=$(grep windowsbox /etc/hosts | grep "10\." | awk '{print $1}')
mail=$(grep mail /etc/hosts | grep "10\." | awk '{print $1}')
redmine=$(grep redmine /etc/hosts | grep "10\." | awk '{print $1}')

# see all declared variables
declare > output-$$
#cat output-$$
# loop through all variables; troubleshooting
#for i in $(grep "=\$(" $0 | cut -d'=' -f1 | grep -v cut); do cat output-$$ | grep $i; done
