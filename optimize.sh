#!/bin/bash
page_size=`getconf PAGE_SIZE`
phys_pages=`getconf _PHYS_PAGES`
cat >>/etc/sysctl.d/99_parity.conf <<\EOF
vm.swappiness=1 # 1 for vps 
vm.vfs_cache_pressure=1000
vm.dirty_background_ratio = 10
vm.dirty_ratio = 10
vm.laptop_mode = 5
# network settings
net.core.netdev_max_backlog = 10000
net.core.somaxconn=65535
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_max_tw_buckets = 720000
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_probes = 7
net.ipv4.tcp_keepalive_intvl = 30
net.core.wmem_max = 33554432
net.core.rmem_max = 33554432
net.core.rmem_default = 8388608
net.core.wmem_default = 4194394
net.ipv4.tcp_rmem = 4096 8388608 16777216
net.ipv4.tcp_wmem = 4096 4194394 16777216
#system and memory settings
kernel.shmmax = $((smhall * page_size))
kernel.shmall = $((phys_pages / 2))
EOF
cat <<\EOF >> /etc/security/limits.conf
* hard nofile 1048576
* soft nofile 1048576
EOF
sysctl -p
sync
echo 3 > /proc/sys/vm/drop_caches
