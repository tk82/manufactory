#!/bin/bash

a=`cat /proc/cpuinfo |grep processor |wc -l`
# 生成 $a 个yes进程，相当于占用全部的CPU资源（CPU(s)）
i=0
while [ "$i" -lt "$a" ]
do
	yes>/dev/null &
	i=$(($i+1))
done

#for ((i=0; i < a; i++))
#do
#	yes>/dev/null &
#done

