#!/bin/bash
/opt/rocm/bin/rocm-smi -d 0 --setfan 250
/opt/rocm/bin/rocm-smi -d 1 --setfan 250
/opt/rocm/bin/rocm-smi -d 2 --setfan 250
/opt/rocm/bin/rocm-smi -d 3 --setfan 250
/opt/rocm/bin/rocm-smi -d 4 --setfan 250
/opt/rocm/bin/rocm-smi -d 5 --setfan 250
echo 'vm.nr_hugepages=128' >> /etc/sysctl.conf
sysctl -p
echo '* soft memlock 262144' >> /etc/security/limits.conf
echo '* hard memlock 262144' >> /etc/security/limits.conf
for i in 0 1 2 3 4 5; do
eval "sudo echo "manual" > /sys/class/drm/card$i/device/power_dpm_force_performance_level"
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

