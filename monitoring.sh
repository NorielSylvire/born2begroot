#!/bin/bash

# Memory variables
USEDMEM=$(free --mega | awk '$1=="Mem:" {print $3}')
TOTMEM=$(free --mega | awk '$1=="Mem:" {print $2}')
PERCMEM=$(free --mega | awk '$1=="Mem:" {printf("(%.2f%%)\n", $3/$2*100)}')
# Disk variables
USEDDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{used_disk += $3} END {print used_disk}')
TOTDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{total_disk += $2} END {printf ("%.1fGb\n"), total_disk/1024}')
PERCDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{used_disk += $3} {total_disk += $2} END {printf ("(%d%%)\n"), used_disk/total_disk*100}')

# CPU variables
CPULD=$(vmstat 1 3 | tail -1 | awk '{printf ("%.1f%%"), 100-$15}')

echo "#Architecture: $(uname -a)"

echo "#CPU physical : $(grep "physical id" /proc/cpuinfo | wc -l)"

echo "#vCPU : $(grep processor /proc/cpuinfo | wc -l)"

echo "#Memory Usage: $USEDMEM/${TOTMEM}MB $PERCMEM"

echo "#Disk Usage: $USEDDSK/$TOTDSK $PERCDSK"

echo "#CPU load: $CPULD"

echo "#Last boot: $(who -b | awk '$1=="system" {print $3 " " $4}')"

if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then
  echo "#LVM use: yes"
else
  echo "#LVM use: no"
fi

echo "#TCP Connections : $(ss -t -a | grep ESTAB | wc -l) ESTABLISHED"

echo "#User log: $(users | wc -w)"

echo "#Network: IP $(hostname -I) ($(ip link | grep "link/ether" | awk '{print $2}'))"

echo "#Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l)"

