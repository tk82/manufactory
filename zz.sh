#! /bin/bash

host=1
port_list_all=`lshw -c network -businfo |grep I350 | awk '{print $2}'`
port_list_total=`echo $port_list_all | wc -w`
echo $port_list_total
for((port_num = 2; port_num <= port_list_total; port_num++))
do
        file_name="/etc/sysconfig/network-scripts/ifcfg-`echo $port_list_all | awk '{print $'"$port_num"'}'`"
        ip_name=`echo -e "serverIP_"$host"$port_num"`
        ip_name=$ip_name
        eval ip_name=\$$ip_name
        echo -e "IPADDR=`echo $ip_name`" >> $file_name
        echo -e "NETMASK=$NETMASK" >> $file_name
	echo $file_name
done
