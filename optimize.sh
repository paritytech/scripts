#!/bin/bash
echo 'vm.swappiness=1' >> /etc/sysctl.conf#1 for vps 
echo 'vm.vfs_cache_pressure=1000' >> /etc/sysctl.conf
echo 'vm.dirty_background_ratio = 10' >> /etc/sysctl.conf
echo 'vm.dirty_ratio = 10' >> /etc/sysctl.conf
echo 'vm.laptop_mode = 5' >> /etc/sysctl.conf
sudo sync
#network settings
echo 3 > /proc/sys/vm/drop_caches
echo 'net.core.netdev_max_backlog = 10000' >> /etc/sysctl.conf
echo 'net.core.somaxconn=65535' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_syncookies=1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_max_syn_backlog = 262144' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_max_tw_buckets = 720000' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_tw_recycle = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_timestamps = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_tw_reuse = 1' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_fin_timeout = 30' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_time = 1800' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_probes = 7' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_intvl = 30' >> /etc/sysctl.conf
echo 'net.core.wmem_max = 33554432' >> /etc/sysctl.conf
echo 'net.core.rmem_max = 33554432' >> /etc/sysctl.conf
echo 'net.core.rmem_default = 8388608' >> /etc/sysctl.conf
echo 'net.core.wmem_default = 4194394' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_rmem = 4096 8388608 16777216' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_wmem = 4096 4194394 16777216' >> /etc/sysctl.conf
#system and memory settings
page_size=`getconf PAGE_SIZE`
phys_pages=`getconf _PHYS_PAGES`
shmall=`expr $phys_pages / 2`
shmmax=`expr $shmall \* $page_size`
echo kernel.shmmax = $shmmax >> /etc/sysctl.conf
echo kernel.shmall = $shmall >> /etc/sysctl.conf
sysctl -p
