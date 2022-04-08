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

function is_ssd()
{
    local ret
# 如果返回 0，表示 SSD；如果返回 1，表示 HDD
    ret=`cat /sys/block/$1/queue/rotational`
    if [ $ret -eq 0 ];then
        return 1
    else
        return 0
    fi
}

diskname=`ls /sys/block/ |grep -E "df|sd|nvme"`
for i in $diskname
do
    is_sysdisk $i
    ret1=$?
    is_ssd $i
    ret2=$?
    ret=`expr $ret1 + $ret2`
# 如果 ret 结果为 0，表示 HDD；如果为 1，表示 SSD。
    if [ $ret -gt 0 ];then
        continue
    else
# 除 系统盘、SSD 盘以外的 HDD 盘进行测试
        sh ddw.sh $i>&/dev/null &	
    fi
done
