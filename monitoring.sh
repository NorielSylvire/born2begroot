#!/bin/bash

# Memory variables
USEDMEM=$(free --mega | awk '$1=="Mem" {print $3}')
TOTMEM=$(free --mega | awk '$1=="Mem" {print $2}')
PERCMEM=$(free --mega | awk '$1=="Mem" {printf("(%.2f%%)\n", $3/$2*100)}')
# Disk variables
USEDDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{used_disk += $3} END {print used_disk}')
TOTDSK=$(df -m | grep "/dev" --exclude=/boot | awk '{total_disk += $2} END {printf ("%.0fGb\n"), total_disk/1024}')


echo "#Architecture: $(uname -a)"

echo "#CPU physical : $(grep cores /proc/cpuinfo | awk 'NR==1' | cut --delimiter=' ' -f 3)"

echo "#vCPU : $(grep processor /proc/cpuinfo | wc -l)"

echo "#Memory Usage: $USEDMEM/$TOTMEM $PERCMEM"

echo "#Disk Usage: $USEDDSK/$TOTDSK "

