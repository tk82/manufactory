#!/bin/bash

function is_sysdisk()
{
    local ret
# 如果匹配到其中的 其中一个字段，就表示该 磁盘是 系统盘
    ret=`lsblk /dev/$1 | grep -E 'root|swap|home|/boot/efi' | wc -l`
    if [ $ret -ge 1 ];then
        return 1
    else
        return 0
    fi
}
# sda  sdb  sdc  sdd  sde  sdf  sdg  sdh  sdi  sdj  sdk  sdl  sdm
diskname=`ls /sys/block/ |grep -E "df|sd|nvme"`
for i in $diskname
do
    is_sysdisk $i
    ret=$?
# 系统盘不进行测试，continue
    if [ $ret -gt 0 ];then
        continue
    else
# 除系统盘以外的 SSD、HDD 盘进行测试
        sh ddr.sh $i >&/dev/null &	
    fi
done
