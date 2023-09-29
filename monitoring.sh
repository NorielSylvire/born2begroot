#!/bin/bash

# Architecture
ARCH=$(uname -a)

# CPU
PCPU=$(grep "physical id" /proc/cpuinfo | wc -l)
VCPU=$(grep processor /proc/cpuinfo | wc -l)
CPUL=$(vmstat 1 3 | tail -1 | awk '{printf ("%.1f%%"), 100-$15}')

# Memory variables
USDMEM=$(free --mega | awk '$1=="Mem:" {print $3}')
TOTMEM=$(free --mega | awk '$1=="Mem:" {print $2}')
PRCMEM=$(free --mega | awk '$1=="Mem:" {printf("(%.2f%%)\n", $3/$2*100)}')
# Disk variables
USDDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{used_disk += $3} END {print used_disk}')
TOTDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{total_disk += $2} END {printf ("%.1fGb\n"), total_disk/1024}')
PRCDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{used_disk += $3} {total_disk += $2} END {printf ("(%d%%)\n"), used_disk/total_disk*100}')

# Last boot
LB=$(who -b | awk '$1=="system" {print $3 " " $4}')

if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then
  LVMU="yes"
else
  LVMU="no"
fi


# Network
TCPC=$(ss -t -a | grep ESTAB | wc -l)
IPV4=$(hostname -I)
MACA=$(ip link | grep "link/ether" | awk '{print $2}')

# Users
USRS=$(users | wc -w)

# Commands
CMDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "  #Architecture: $ARCH
        #CPU physical : $PCPU
        #vCPU : $VCPU
        #Memory Usage: $USDMEM/${TOTMEM}MB $PRCMEM
        #Disk Usage: $USDDSK/$TOTDSK $PRCDSK
        #CPU load: $CPUL
        #Last boot: $LB
        #LVM use: $LVMU
        #TCP Connections : $TCPC ESTABLISHED
        #User log: $USRS
        #Network: IP $IPV4 ($MACA)
        #Sudo : $CMDS"

