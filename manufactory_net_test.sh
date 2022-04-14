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
	id=$((N % 2))
	if [ $id -eq 1 ];then
		host=1
	elif [ $id -eq 0 ];then
		host=2
	fi

	# 配置 板载 网卡网口
        port_list_all=`lshw -c network -businfo |grep I350 | awk '{print $2}'`
        port_list_total=`echo $port_list_all | wc -w`
        for((port_num = 2; port_num <= port_list_total; port_num++))
	do
                file_name="/etc/sysconfig/network-scripts/ifcfg-`echo $port_list_all | awk '{print $'"$port_num"'}'`"
                ip_name=`echo -e "serverIP_"$host"$port_num"`
                ip_name=$ip_name
                eval ip_name=\$$ip_name
                echo -e "IPADDR=`echo $ip_name`" >> $file_name
                echo -e "NETMASK=$NETMASK" >> $file_name

                ifdown ifcfg-`echo $port_list_all | awk '{print $'"$port_num"'}'`
                ifup ifcfg-`echo $port_list_all | awk '{print $'"$port_num"'}'`

                sleep 3
                ifconfig `echo $port_list_all | awk '{print $'"$port_num"'}'` `echo $ip_name`
        done

:<< EOF
	port_list_1=`lshw -c network -businfo |grep I350 | awk '{print $2}'`
	port_list_1_Num=`lshw -c network -businfo |grep I350 | awk '{print $2}' | wc -l`

#	这里没有用到 该参数
#	port_list_2=`lshw -c network -businfo |grep -Ev "I350|Virtual|Description|=" | sort | uniq | awk '{print $2}'`

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
	for((j = 0; j < port_list_2_Num; j++))
	do
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
    id=$((N % 2))
    killTime=3
    case $id in
    1)

    sh ./pingtest.sh $serverIP_21 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_11`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_23 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_13`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_23 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_23 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_25 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_15`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_25 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_25 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_27 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_17`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_27 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_27 ${GE10_25_net_test_time} $portTYPE
    fi

    exit;;

    0)

    sh ./pingtest.sh $serverIP_12 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_21`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_12 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_12 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_14 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_24`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_14 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_14 ${GE10_25_net_test_time} $portTYPE
    fi

        sh ./pingtest.sh $serverIP_16 >> ./manufactory_net_test.txt
        portTYPE=`modify_type $serverIP_26`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_16 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_16 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_18 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_28`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_18 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_18 ${GE10_25_net_test_time} $portTYPE
    fi

    exit;;

    esac	
}

net_test_XE3100G2()
{
    id=$((N % 2))
    killTime=3

    case $id in
    1)

    sh ./pingtest.sh $serverIP_21 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_11`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_21 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_23 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_13`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_23 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_23 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_25 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_15`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_25 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_25 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_27 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_17`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_27 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_27 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_29 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_19`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_29 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_29 ${GE10_25_net_test_time} $portTYPE
    fi

    exit;;

    0)

    sh ./pingtest.sh $serverIP_12 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_21`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_12 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_12 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_14 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_24`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_14 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_14 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_16 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_26`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_16 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_16 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_18 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_28`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_18 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_18 ${GE10_25_net_test_time} $portTYPE
    fi

    sh ./pingtest.sh $serverIP_110 >> ./manufactory_net_test.txt
    portTYPE=`modify_type $serverIP_210`
    if [ $portTYPE -eq 1 ];then
      sh ./manufactory_net.sh $serverIP_110 ${GE_net_test_time} $portTYPE
    elif [ $portTYPE -eq 2 ];then
      sh ./manufactory_net.sh $serverIP_110 ${GE10_25_net_test_time} $portTYPE
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
