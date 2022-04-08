#!/bin/bash
targetIP=$1

#echo -e "\033[32m ======================================BMC Network ping test=================================== \033[0m"
#BMCIP=`ipmitool lan print |grep "IP Add" |grep -v Source |awk '{print $4}'`
#echo "BMC IP address is $BMCIP"
#if [ ${BMCIP:0:3} != 0 ]
#then
#    ping $BMCIP &
#    sleep 4
#    pingpid=`ps -aux |grep ping |grep -v grep |grep -v vi |grep -v pingtest |awk '{print $2}'`
#    kill -9 $pingpid
#else
#    echo "please check BMC Network"
#fi

echo -e "====================================== ping test ==================================="
#for i in `ifconfig |grep "en.*mtu" |awk '{print $1}' |sed 's/://'`;
#do
#	echo -e "\033[32m ============ \033[0m" 
#	echo -e "\033[32m   $i \033[0m" 
#	echo -e "\033[32m ============ \033[0m" 
#	ping -I $port_name $targetIP -c 5
	ping $targetIP -c 5
#	pingpid=`ps -aux |grep ping |grep -v grep |grep -v vi |grep -v pingtest |awk '{print $2}'`
#	kill -9 $pingpid
#done
