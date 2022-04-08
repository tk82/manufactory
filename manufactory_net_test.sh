#! /bin/sh

model=$1
N=$2

# 7200s
GE10_25_net_test_time=`cat config.cfg | grep -a "GE10_25_and_above_Ethernet_port_test_time" | awk '{print $4}'`
# 600s
GE_net_test_time=`cat config.cfg | grep -a "GE_Ethernet_port_test_time" | awk '{print $4}'`

serverIP_11=`cat config.cfg | grep -aw "serverIP_11" | awk '{print $4}'`
serverIP_12=`cat config.cfg | grep -aw "serverIP_12" | awk '{print $4}'`
serverIP_13=`cat config.cfg | grep -aw "serverIP_13" | awk '{print $4}'`
serverIP_14=`cat config.cfg | grep -aw "serverIP_14" | awk '{print $4}'`
serverIP_15=`cat config.cfg | grep -aw "serverIP_15" | awk '{print $4}'`
serverIP_16=`cat config.cfg | grep -aw "serverIP_16" | awk '{print $4}'`
serverIP_17=`cat config.cfg | grep -aw "serverIP_17" | awk '{print $4}'`
serverIP_18=`cat config.cfg | grep -aw "serverIP_18" | awk '{print $4}'`
serverIP_19=`cat config.cfg | grep -aw "serverIP_19" | awk '{print $4}'`
serverIP_110=`cat config.cfg | grep -aw "serverIP_110" | awk '{print $4}'`

serverIP_21=`cat config.cfg | grep -aw "serverIP_21" | awk '{print $4}'`
serverIP_22=`cat config.cfg | grep -aw "serverIP_22" | awk '{print $4}'`
serverIP_23=`cat config.cfg | grep -aw "serverIP_23" | awk '{print $4}'`
serverIP_24=`cat config.cfg | grep -aw "serverIP_24" | awk '{print $4}'`
serverIP_25=`cat config.cfg | grep -aw "serverIP_25" | awk '{print $4}'`
serverIP_26=`cat config.cfg | grep -aw "serverIP_26" | awk '{print $4}'`
serverIP_27=`cat config.cfg | grep -aw "serverIP_27" | awk '{print $4}'`
serverIP_28=`cat config.cfg | grep -aw "serverIP_28" | awk '{print $4}'`
serverIP_29=`cat config.cfg | grep -aw "serverIP_29" | awk '{print $4}'`
serverIP_210=`cat config.cfg | grep -aw "serverIP_210" | awk '{print $4}'`

serverIP_31=`cat config.cfg | grep -aw "serverIP_31" | awk '{print $4}'`
serverIP_32=`cat config.cfg | grep -aw "serverIP_32" | awk '{print $4}'`
serverIP_33=`cat config.cfg | grep -aw "serverIP_33" | awk '{print $4}'`
serverIP_34=`cat config.cfg | grep -aw "serverIP_34" | awk '{print $4}'`
serverIP_35=`cat config.cfg | grep -aw "serverIP_35" | awk '{print $4}'`
serverIP_36=`cat config.cfg | grep -aw "serverIP_36" | awk '{print $4}'`
serverIP_37=`cat config.cfg | grep -aw "serverIP_37" | awk '{print $4}'`
serverIP_38=`cat config.cfg | grep -aw "serverIP_38" | awk '{print $4}'`
serverIP_39=`cat config.cfg | grep -aw "serverIP_39" | awk '{print $4}'`
serverIP_310=`cat config.cfg | grep -aw "serverIP_310" | awk '{print $4}'`

serverIP_41=`cat config.cfg | grep -aw "serverIP_41" | awk '{print $4}'`
serverIP_42=`cat config.cfg | grep -aw "serverIP_42" | awk '{print $4}'`
serverIP_43=`cat config.cfg | grep -aw "serverIP_43" | awk '{print $4}'`
serverIP_44=`cat config.cfg | grep -aw "serverIP_44" | awk '{print $4}'`
serverIP_45=`cat config.cfg | grep -aw "serverIP_45" | awk '{print $4}'`
serverIP_46=`cat config.cfg | grep -aw "serverIP_46" | awk '{print $4}'`
serverIP_47=`cat config.cfg | grep -aw "serverIP_47" | awk '{print $4}'`
serverIP_48=`cat config.cfg | grep -aw "serverIP_48" | awk '{print $4}'`
serverIP_49=`cat config.cfg | grep -aw "serverIP_49" | awk '{print $4}'`
serverIP_410=`cat config.cfg | grep -aw "serverIP_410" | awk '{print $4}'`
NETMASK=`cat config.cfg | grep -a "NETMASK" | awk '{print $4}'`
#serverIP_11="192.168.1.11"
#serverIP_12="192.168.2.11"
#serverIP_13="192.168.3.11"
#serverIP_14="192.168.4.11"
#serverIP_15="192.168.5.11"
#serverIP_16="192.168.6.11"
#serverIP_17="192.168.7.11"
#serverIP_18="192.168.8.11"
#serverIP_19="192.168.9.11"
#serverIP_110="192.168.10.11"

#serverIP_21="192.168.1.12"
#serverIP_22="192.168.2.12"
#serverIP_23="192.168.3.12"
#serverIP_24="192.168.4.12"
#serverIP_25="192.168.5.12"
#serverIP_26="192.168.6.12"
#serverIP_27="192.168.7.12"
#serverIP_28="192.168.8.12"
#serverIP_29="192.168.9.12"
#serverIP_210="192.168.10.12"

#serverIP_31="192.168.1.13"
#serverIP_32="192.168.2.13"
#serverIP_33="192.168.3.13"
#serverIP_34="192.168.4.13"
#serverIP_35="192.168.5.13"
#serverIP_36="192.168.6.13"
#serverIP_37="192.168.7.13"
#serverIP_38="192.168.8.13"
#serverIP_39="192.168.9.13"
#serverIP_310="192.168.10.13"

#serverIP_41="192.168.1.14"
#serverIP_42="192.168.2.14"
#serverIP_43="192.168.3.14"
#serverIP_44="192.168.4.14"
#serverIP_45="192.168.5.14"
#serverIP_46="192.168.6.14"
#serverIP_47="192.168.7.14"
#serverIP_48="192.168.8.14"
#serverIP_49="192.168.9.14"
#serverIP_410="192.168.10.14"
#NETMASK="NETMASK="255.255.255.0"

modify_type()
{
	portIP=$1
	port_name=`ifconfig | grep -B2 "$portIP" | grep en[ps] | awk '{print $1}' |sed "s/://g"`
	port_speed=`ethtool $port_name | grep "Speed:" | awk '{print $2}'`
	if [ "$port_speed" == "1000Mb/s" ];then
		TYPE=1
	elif [ "$port_speed" == "10000Mb/s" -o "$port_speed" == "25000Mb/s" ];then
		TYPE=2
	else
		TYPE=0
	fi
	echo $TYPE
}

config_IP()
{
	id=$((N%4))
	if [ $id -eq 1 ];then
		host=1
	elif [ $id -eq 2 ];then
		host=2
	elif [ $id -eq 3 ];then
		host=3
	elif [ $id -eq 0 ];then
		host=4
	fi
:<< EOF
	port_list_1=`lshw -c network -businfo |grep I350 | awk '{print $2}'`
	port_list_1_Num=`lshw -c network -businfo |grep I350 | awk '{print $2}' | wc -l`
# 这里需要完善，否则可能匹配到其他文件中（这个参数：port_list_2 这里没有用到）
# port_list_2=`lshw -c network -businfo |grep -Ev "I350|Virtual|Description|=" | sort | uniq | awk '{print $2}'`
#	port_list_2=`lshw -c network -businfo |grep -Ev "I350|Virtual|Description|=" | grep -i "[0-9]\  en" | sort | uniq | awk '{print $2}'`
	file_name="/etc/sysconfig/network-scripts/ifcfg-`echo $port_list_1 | awk '{print $1}'`"

	ip_name=`echo -e "serverIP_"$host"1"`
	ip_name=$ip_name
	eval ip_name=\$$ip_name
	echo -e "IPADDR=`echo $ip_name`" >> $file_name
  echo -e "NETMASK=$NETMASK" >> $file_name

	ifdown ifcfg-`echo $port_list_1 | awk '{print $1}'`
	ifup ifcfg-`echo $port_list_1 | awk '{print $1}'`

	sleep 3
	ifconfig `echo $port_list_1 | awk '{print $1}'` `echo $ip_name`
EOF
	port_list_2=`lshw -c network -businfo |grep -Ev "I350|Virtual|Description|=|enp94" | sort | uniq | awk '{print $2}' | grep -v "network"`
	port_list_2_Num=`lshw -c network -businfo |grep -Ev "I350|Virtual|Description|=|enp94" | sort | uniq | awk '{print $2}' | grep -v "network" | wc -l`
	for((j=0;j<port_list_2_Num;j++));do
		file_name="/etc/sysconfig/network-scripts/ifcfg-`echo $port_list_2 | awk '{print $'"$((j+1))"'}'`"

		ip_name=`echo -e "serverIP_$host$((j+5))"`
		ip_name=$ip_name
		eval ip_name=\$$ip_name
		echo -e "IPADDR=`echo $ip_name`" >> $file_name
    echo -e "NETMASK=$NETMASK" >> $file_name
		ifdown `echo $port_list_2 | awk '{print $'"$((j+1))"'}'`
		ifup `echo $port_list_2 | awk '{print $'"$((j+1))"'}'`

		sleep 3
		#ifconfig `echo $port_list_2 | awk '{print $'"$((j+1))"'}'` `echo $ip_name`
	done
	echo "============" >> ./manufactory_net_test.txt
	ifconfig | grep -B1 inet | grep -Ev "inet6|lo:|inet 127.0.0.1|--" >> ./manufactory_net_test.txt
}

net_init()
{
	rm -f ./manufactory_net_test.txt
	sh network_bak.sh > ./manufactory_net_test.txt
	config_IP
}

net_test_XE2100G2()
{
	id=$((N % 4))
	killTime=2
	case $id in
	1)
#		netserver
#		sleep 10
    sh ./pingtest.sh $serverIP_21 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_11`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE10_25_net_test_time} $portTYPE
    fi

		sh ./pingtest.sh $serverIP_26 >> ./manufactory_net_test.txt
		portTYPE=`modify_type $serverIP_16`
		if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_26 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_26 ${GE10_25_net_test_time} $portTYPE
    fi
#		kill -9 `ps -aux | grep netserver | grep -v color | awk '{print $2}'`
#		netserver

		sh ./pingtest.sh $serverIP_28 >> ./manufactory_net_test.txt
		portTYPE=`modify_type $serverIP_18`
		if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_28 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_28 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
  2)
#		netserver
#		sleep 10
    sh ./pingtest.sh $serverIP_11 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_21`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_11 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_11 ${GE10_25_net_test_time} $portTYPE
    fi

		sh ./pingtest.sh $serverIP_15 >> ./manufactory_net_test.txt
		portTYPE=`modify_type $serverIP_25`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_15 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_15 ${GE10_25_net_test_time} $portTYPE
    fi
#		kill -9 `ps -aux | grep netserver | grep -v color | awk '{print $2}'`
#		netserver

		sh ./pingtest.sh $serverIP_17 >> ./manufactory_net_test.txt
		portTYPE=`modify_type $serverIP_27`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_17 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_17 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
  3)
    sh ./pingtest.sh $serverIP_41 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_31`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_41 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_41 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_46 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_36`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_46 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_46 ${GE10_25_net_test_time} $portTYPE
    fi

		sh ./pingtest.sh $serverIP_48 >> ./manufactory_net_test.txt
		portTYPE=`modify_type $serverIP_38`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_48 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_48 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
  0)
    sh ./pingtest.sh $serverIP_31 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_41`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_31 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_31 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_35 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_45`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_35 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_35 ${GE10_25_net_test_time} $portTYPE
    fi

		sh ./pingtest.sh $serverIP_37 >> ./manufactory_net_test.txt
		portTYPE=`modify_type $serverIP_47`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_37 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_37 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
	esac
}

net_test_XE3100G2()
{
	id=$((N % 4))
	killTime=3
	case $id in
	1)
#		netserver
#		sleep 10
    sh ./pingtest.sh $serverIP_21 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_11`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_26 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_16`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_26 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_26 ${GE10_25_net_test_time} $portTYPE
    fi
#		kill -9 `ps -aux | grep netserver | grep -v color | awk '{print $2}'`
#		netserver
	sh ./pingtest.sh $serverIP_28 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_18`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_28 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_28 ${GE10_25_net_test_time} $portTYPE
    fi
#		kill -9 `ps -aux | grep netserver | grep -v color | awk '{print $2}'`
#		netserver

	sh ./pingtest.sh $serverIP_210 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_110`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_210 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_210 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
	2)
#		netserver
#		sleep 10
    sh ./pingtest.sh $serverIP_11 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_21`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_11 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_11 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_15 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_25`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_15 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_15 ${GE10_25_net_test_time} $portTYPE
    fi
#		kill -9 `ps -aux | grep netserver | grep -v color | awk '{print $2}'`
#		netserver

	sh ./pingtest.sh $serverIP_17 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_27`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_17 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_17 ${GE10_25_net_test_time} $portTYPE
    fi
#		kill -9 `ps -aux | grep netserver | grep -v color | awk '{print $2}'`
#		netserver

	sh ./pingtest.sh $serverIP_19 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_29`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_19 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_19 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
  3)
    sh ./pingtest.sh $serverIP_41 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_31`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_41 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_41 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_46 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_36`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_46 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_46 ${GE10_25_net_test_time} $portTYPE
    fi

	sh ./pingtest.sh $serverIP_48 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_38`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_48 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_48 ${GE10_25_net_test_time} $portTYPE
    fi

	sh ./pingtest.sh $serverIP_410 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_310`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_410 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_410 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
  0)
    sh ./pingtest.sh $serverIP_31 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_41`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_31 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_31 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_35 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_45`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_35 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_35 ${GE10_25_net_test_time} $portTYPE
    fi

	sh ./pingtest.sh $serverIP_37 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_47`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_37 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_37 ${GE10_25_net_test_time} $portTYPE
    fi

	sh ./pingtest.sh $serverIP_39 >> ./manufactory_net_test.txt
	portTYPE=`modify_type $serverIP_49`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_39 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_39 ${GE10_25_net_test_time} $portTYPE
    fi
		exit;;
	esac
}
# 这里没有调用这个函数，先注释掉。
#check_result()
#{
#	sync
#	while [ 1 ];do
#		query=`ls ./manufactory_net_test.txt | wc -l`
#    echo $query
#		if [ $query -eq 1 ];then
#			rst=`cat ./manufactory_net_test.txt | grep -E "ERROR|FAILED" | wc -l`
#      echo $rst
#			if [ $rst -eq 0 ];then
#				echo -e "\033[42m 【通过】全部以太网端口性能测试通过。\t\t\t\t\t \033[0m"
#			elif [ $rst -gt 0 ];then
#				echo -e "\033[41m 【失败】部分以太网端口性能测试不通过。 \t\t\t\t \033[0m"
#			fi
#			break
#		elif [ $query -eq 0 ];then
#			sleep 3
#		fi
#	done
#}

net_init
# XE2120G2 XE2130G2 统称为：XE2100G2（两者的差别好像是多一张网卡的区别）
if [ "$model" == "XE2100G2" ];then
	net_test_XE2100G2 $N
# XE3150G2 XE3150G2 XE3180G2 统称为：XE3100G2（两者的差别好像是多一张网卡的区别）
elif [ "$model" == "XE3100G2" ];then
	net_test_XE3100G2 $N
# X3000 系列 未确定
elif [ "$model" == "X3000" ];then
	net_test_XE3100G2 $N
# 白牌机 系列 未确定
elif [ "$model" == "white_card" ];then
	net_test_XE3100G2 $N
fi
sh network_restore.sh >> ./manufactory_net_test.txt
