#!/bin/sh

model="$1"
N=$2

mkdir_Path()
{
  Date=`date +%F`
  SN=`ipmitool fru print 0 |grep "Product Serial" | awk '{print $4}'`
  rm -rf /root/*$SN*
  Path=`echo "/root/""$Date"_"$SN"`
  mkdir -p $Path
}

test_CPU_MEM()
{
  echo "Start to run CPU_MEM test"
  sh ./manufactory_cpu_mem.sh
}
test_System_Info()
{
  echo "Start to run system Info test"
  sh ./fru_xsky.sh $model >> $Path/fru_result.txt
  sh ./manufactory_sysinfo.sh $model >> check_result.txt
  cp ./systemInto.txt $Path
}
test_Network()
{
  product_model=$1
  netserver
  echo "Start to run network test"
  sh ./manufactory_net_test.sh $product_model $N
  sh ./manufactory_net_check.sh >> check_result.txt
:<< aa
  port_list_1=`lshw -c network -businfo | grep I350 | awk '{print $2}'`
  ifconfig `$port_list_1 | awk '{print $2}'` `echo -e "192.168.0.$N"`
aa
  cp ./manufactory_net_test.txt $Path
}
test_Dist()
{
  echo "Start to run disk test"
  sh ./manufactory_disk_test.sh >> check_result.txt
  cp ./result $Path/manufactory_disk_test.txt
  cp ./check_result.txt $Path
}
tar_File()
{
  echo "Tar the result"
  cd /root
  tar czf $Path.tgz "$Date"_"$SN"/*
  mkdir -p /root/tmp_checkResult
  rm -rf /root/manufactory
  mv $Path/* /root/tmp_checkResult/
  rmdir $Path
  cat /root/tmp_checkResult/check_result.txt
}

product_XE2100_3100G2_X3000_White_Card()
{
  echo "Start to run CPU_MEM test"
  sh ./manufactory_cpu_mem.sh

  echo "Start to run System Info test"
  sh ./fru_xsky.sh $model >> $Path/fru_result.txt
  sh ./manufactory_sysinfo.sh $model >> check_result.txt
  cp ./systemInto.txt $Path

  netserver
  echo "Start to run Network test"
  sh ./manufactory_net_test.sh $1 $N    # 就是这里不一样 XE2100G2
  sh ./manufactory_net_check.sh >> check_result.txt
:<< bb
  port_list_1=`lshw -c network -businfo | grep I350 | awk '{print $2}'`
  ifconfig `$port_list_1 | awk '{print $2}'` `echo -e "192.168.0.$N"`
bb
  cp ./manufactory_net_test.txt $Path

  echo "Start to run Disk test"
  sh ./manufactory_disk_test.sh >> check_result.txt
  cp ./result $Path/manufactory_disk_test.txt
  cp ./check_result.txt $Path

  echo "Tar the result"
  cd /root
  tar czf $Path.tgz "$Date"_"$SN"/*
  mkdir -p /root/tmp_checkResult
#  rm -rf /root/manufactory
  mv $Path/* /root/tmp_checkResult/
  rmdir $Path
  cat /root/tmp_checkResult/check_result.txt
}

# 读取 参数 来执行所希望的 测试项
# h or help : 列出当前所支持的测试项
# all or A          : 所有 测试
# system_info or S  : 系统 测试
# cpu or C          : CPU 测试
# network or N      : 网络 测试
# disk or D         : 磁盘 测试
# quit or Q         : 退出 测试
read_argument()
{
  product_model=$1
  while [ 1 ];do
      read -p "input a argument(input 'h' or 'help' View supported parameters): " tmp
      case $tmp in
          all | A)
              product_XE2100_3100G2_X3000_White_Card $product_model
              exit 1
              ;;
          system_info | S)
              test_System_Info
              exit 1
              ;;
          cpu | C)
              test_CPU_MEM
              exit 1
              ;;
          network | N)
              test_Network $product_model
              exit 1
              ;;
          disk | D)
              test_Dist
              exit 1
              ;;
          quit | Q)
              exit 1
              ;;
          h | help)
              echo -e "supported parameters list:"
              echo -e "  all or A           : all test"
              echo -e "  system_info or S   : System_info test"
              echo -e "  cpu or C           : CPU test"
              echo -e "  network or N       : Network test"
              echo -e "  disk or D          : Disk test"
              echo -e "  quit or Q          : Quit test"
              ;;
          *)
              echo -e "\ninput argument is Error!!! please input again!!!\n"
              ;;
      esac
  done
}

# Begin Test!!!
if [ "$model" == "" -o "$N" == "" ];then
#	echo "脚本执行时必须输入两个参数：设备型号、设备编号。"   # 可能会出现乱码
	echo "Two parameters must be entered when the script is executed: device model, device number。"
#	echo "命令示例：sh manufactory.sh XE2120G2 1"    # 可能会出现乱码
	echo "Command example: sh manufactory.sh XE2120G2 1"
else
	if [ $N -lt 21 ];then
		#sh ./manufactory_install.sh >> intall_log.txt
		rm -rf /root/tmp_checkResult
		rm -f check_result.txt
    mkdir_Path
		#[ -n "$Path" ] && mv intall_log.txt $Path
:<< cc
		port_list_1=`lshw -c network -businfo |grep I350 | awk '{print $2}'`
		file_name="/etc/sysconfig/network-scripts/ifcfg-`echo $port_list_1 | awk '{print $2}'`"
		echo -e "IPADDR=\"192.168.0."$N"\"" >> $file_name
		echo -e "NETMASK=\"255.255.255.0\"" >> $file_name

		ifdown `echo $port_list_1 | awk '{print $2}'`
		ifup `echo $port_list_1 | awk '{print $2}'`
cc
		if [ "$model" == "XE2120G2" -o "$model" == "XE2130G2" ];then
      read_argument XE2100G2
		elif [ "$model" == "XE3150G2" -o "$model" == "XE3160G2" -o "$model" == "XE3180G2" ];then
      read_argument XE3100G2
# X3000 系列 未确定
    elif [ "$model" == "X3000" ];then
      read_argument X3000
# 白牌机 系列 未确定
    elif [ "$model" == "white_card" ];then
      read_argument white_card
		else
			echo "设备型号必须是如下五个型号之一: XE2120G2，XE2130G2, XE3150G2, XE3160G2, XE3180G2，X3000，white_card。"
		fi
	elif [ $N -ge 21 ];then
		echo "设备编号必须小于21，即同时厂验证的设备不能多于20台。"
	fi
fi
