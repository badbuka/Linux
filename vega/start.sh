#!/bin/bash
#This file was created by den
#The last modyfy on 09/07/2018
#This script is created for: vega voltage control in kernel 4.17+ with ROCm or
#18.20 driver. The followed settings are needed for proper work:
#echo 'vm.nr_hugepages=128' >> /etc/sysctl.conf
#sysctl -p
#echo '* soft memlock 262144' >> /etc/security/limits.conf
#echo '* hard memlock 262144' >> /etc/security/limits.conf
#You also need to specify the number of vegas in system... Todo...
for i in 0 1 2 3 4 5; do
eval "sudo echo "manual" > /sys/class/drm/card$i/device/power_dpm_force_performance_level"
eval "sudo /opt/rocm/bin/rocm-smi -d $i --setfan 250"
eval "sudo echo "s 0 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 1 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 2 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 3 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 4 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 5 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 6 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "s 7 950 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "sudo echo "m 3 800 850" > /sys/class/drm/card$i/device/pp_od_clk_voltage"
eval "echo "c"> /sys/class/drm/card$i/device/pp_od_clk_voltage"
done
exit 0

