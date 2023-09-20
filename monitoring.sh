#!/bin/bash

echo "#Architecture: $(uname -a)"

echo "#CPU physical : $(cat /proc/cpuinfo | grep cores | awk 'NR==1' | cut --delimiter=' ' -f 3)"
