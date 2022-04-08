#!/bin/sh
model="$1"
echo "enter network config file dir "
rm -f  /etc/sysconfig/network-scripts/ifcfg-*
echo "recover network configs"
mv /etc/sysconfig/network-scripts/bak/ifcfg-*  /etc/sysconfig/network-scripts/
rmdir /etc/sysconfig/network-scripts/bak

port_list=`lshw -c network -businfo |grep -Ev "Virtual|Description|=" | sort | uniq | awk '{print $2}' | grep -v "network"`
port_list_Num=`lshw -c network -businfo |grep -Ev "Virtual|Description|=" | sort | uniq | awk '{print $2}' | grep -v "network" | wc -l`
for((j=0;j<port_list_Num;j++));do
#  echo `echo $port_list | awk '{print $'"$((j+1))"'}'`
#	 ifdown `echo $port_list | awk '{print $'"$((j+1))"'}'`
#	 ifup `echo $port_list | awk '{print $'"$((j+1))"'}'`
# 上面 3句用下面 4句来代替
  port_list_now=`echo $port_list | awk '{print $'"$((j+1))"'}'`
  echo ${port_list_now}  文件中没有看到输出
  ifdown ${port_list_now}
  ifup ${port_list_now}
done
if [ "$model" == "XE2100G2" ];then
	ifdown bond1
	ifup bond1
elif [ "$model" == "XE3100G2" ];then
	ifdown bond1
	ifdown bond2
	ifup bond1
	ifup bond2
# X3000 系列 未确定
elif [ "$model" == "X3000" ];then
	ifdown bond1
	ifdown bond2
	ifup bond1
	ifup bond2
# 白牌机 系列 未确定
elif [ "$model" == "white_card" ];then
	ifdown bond1
	ifdown bond2
	ifup bond1
	ifup bond2
fi
