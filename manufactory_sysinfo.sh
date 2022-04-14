#!/bin/sh

# XE2100 XE3100 X3000 white_card
product_Model=$1

check_BIOS_VERSION()
{
	BiosVersion=`cat ./systemInto.txt | grep -a "BIOS Version" | awk '{print $4}'`
	BiosReleaseDate=`cat ./systemInto.txt | grep -a "Release Date" | awk '{print $4}'`

	XE_BIOS_Version=`cat config.cfg | grep -a "XE_BIOS_Version" | awk '{print $4}'`
	XE_Release_Date=`cat config.cfg | grep -a "XE_Release_Date" | awk '{print $4}'`

# XE 系列产品默认 BIOS version：XSKY57.18
	if [[ $product_Model =~ XE[0-9]{4} ]];then
    if [ "$BiosVersion" != "$XE_BIOS_Version" -o "$BiosReleaseDate" != "$XE_Release_Date" ];then
      echo -e "\033[41m [Failed] BIOS version needs to be upgraded!\t\t\t\t\t\t \033[0m"
    elif [ "$BiosVersion" == "$XE_BIOS_Version" -a "$BiosReleaseDate" == "$XE_Release_Date" ];then
      echo -e "\033[42m [ Pass ] The BIOS version is correct.\t\t\t\t\t\t\t \033[0m"
    fi
# X3000 系列暂时不确定版本
  elif [[ $product_Model =~ X[0-9]{3} ]];then
    if [ "$BiosVersion" != "XSKY57.18" -o "$BiosReleaseDate" != "09/15/2021" ];then
      echo -e "\033[41m [Failed] BIOS version needs to be upgraded!\t\t\t\t\t\t \033[0m"
    elif [ "$BiosVersion" == "XSKY57.18" -a "$BiosReleaseDate" == "09/15/2021" ];then
      echo -e "\033[42m [ Pass ] The BIOS version is correct.\t\t\t\t\t\t\t \033[0m"
    fi
# white_card 系列暂时不确定版本
  elif [[ $product_Model =~ white_card ]];then
    echo -e "\033[42m [ Pass ] Do not check the BIOS of the white machine.\t\t\t\t\t\t\t \033[0m"

:<<EOF
    if [ "$BiosVersion" != "XSKY57.18" -o "$BiosReleaseDate" != "09/15/2021" ];then
      echo -e "\033[41m [Failed] BIOS version needs to be upgraded!\t\t\t\t\t\t \033[0m"
    elif [ "$BiosVersion" == "XSKY57.18" -a "$BiosReleaseDate" == "09/15/2021" ];then
      echo -e "\033[42m [ Pass ] The BIOS version is correct.\t\t\t\t\t\t\t \033[0m"
    fi
EOF
  fi
}

check_BMC_VERSION()
{
	BmcVersion=`cat ./systemInto.txt | grep -a "BMC Firmware Revision" | awk '{print $5}'`
	XE_BMC_Firmware_Revision=`cat config.cfg | grep -a "XE_BMC_Firmware_Revision" | awk '{print $4}'`

# XE 系列产品默认 BMC version：1.14.18
	if [[ $product_Model =~ XE[0-9]{4} ]];then
    if [ "$BmcVersion" != "$XE_BMC_Firmware_Revision" ];then
      echo -e "\033[41m [Failed] BMC version needs to be upgraded!\t\t\t\t\t\t \033[0m"
    elif [ "$BmcVersion" == "$XE_BMC_Firmware_Revision" ];then
      echo -e "\033[42m [ Pass ] BMC version is correct.\t\t\t\t\t\t\t \033[0m"
    fi
# X3000 系列暂时不确定版本
  elif [[ $product_Model =~ X[0-9]{3} ]];then
    if [ "$BmcVersion" != "1.14.18" ];then
      echo -e "\033[41m [Failed] BMC version needs to be upgraded!\t\t\t\t\t\t \033[0m"
    elif [ "$BmcVersion" == "1.14.18" ];then
      echo -e "\033[42m [ Pass ] BMC version is correct.\t\t\t\t\t\t\t \033[0m"
    fi
# white_card 系列暂时不确定版本
  elif [[ $product_Model =~ white_card ]];then
    echo -e "\033[42m [ Pass ] Do not check the BMC of the white card machine.\t\t\t\t\t\t\t \033[0m"

:<<EOF
    if [ "$BmcVersion" != "1.14.18" ];then
      echo -e "\033[41m [Failed] BMC version needs to be upgraded!\t\t\t\t\t\t \033[0m"
    elif [ "$BmcVersion" == "1.14.18" ];then
      echo -e "\033[42m [ Pass ] BMC version is correct.\t\t\t\t\t\t\t \033[0m"
    fi
EOF
  fi
}

check_VENDOR_INFO()
{
	# BIOS DMI Product Name: dmidecode -t 1 | grep Product |awk '{print $3}'，这里无法修改。
	ProductName=`cat ./systemInto.txt | grep -a "BIOS DMI Product Name" | awk '{print $6}'`

	if [ "$ProductName" != "$product_Model" ];then
		echo -e "\033[41m [Failed] The product model check in the electronic label failed!\t\t\t\t\t \033[0m"
	elif [ "$ProductName" == "$product_Model" ];then
		echo -e "\033[42m [ Pass ] The product model in the electronic label has passed the inspection.\t\t\t\t\t \033[0m"
	fi

        # 厂商信息. ipmitool fru list | grep "Product Manufacturer"
	ProductManu=`cat ./systemInto.txt | grep -a  "Product Manufacturer" | awk '{print $4}'`
	# 厂商信息. 默认 XSKY
	XE_Manufacturer=`cat config.cfg | grep -a "XE_Manufacturer" | awk '{print $4}'`

# XE 系列产品默认 Manufacturer ：XSKY
	if [[ $product_Model =~ XE[0-9]{4} ]];then
    if [ "$ProductManu" != "$XE_Manufacturer" ];then
      echo -e "\033[41m [Failed] The manufacturer information check in the electronic label failed!\t\t\t\t \033[0m"
    elif  [ "$ProductManu" == "$XE_Manufacturer" ];then
      echo -e "\033[42m [ Pass ] The manufacturer information check in the electronic label pass!\t\t\t\t \033[0m"
    fi
  # X3000 系列暂时不确定版本
  elif [[ $product_Model =~ X[0-9]{3} ]];then
    if [ "$ProductManu" != "XSKY" ];then
      echo -e "\033[41m [Failed] The manufacturer information check in the electronic label failed!\t\t\t\t \033[0m"
    elif  [ "$ProductManu" == "XSKY" ];then
      echo -e "\033[42m [ Pass ] The manufacturer information check in the electronic label pass!\t\t\t\t \033[0m"
    fi
  # white_card 为空则 Pass
  elif [[ $product_Model =~ white_card ]];then
    echo -e "\033[42m [ Pass ] Do not check the electronic lable of the white card machine.\t\t\t\t \033[0m"

:<<EOF
    if [ "$ProductManu" != "" ];then
      echo -e "\033[41m [Failed] The manufacturer information check in the electronic label failed!\t\t\t\t \033[0m"
    elif  [ "$ProductManu" == "" ];then
      echo -e "\033[42m [ Pass ] The manufacturer information check in the electronic label pass!\t\t\t\t \033[0m"
    fi
EOF
  fi
}

check_Server_Conf()
{
#	检查设备CPU、内存、RAID卡、磁盘、IO插卡的配置数量
#	echo -e "\033[42m 【通过】未对设备CPU、内存、RAID卡、磁盘、IO插卡的配置数量进行检查。\t\t\t\t \033[0m"
	echo -e "\033[42m [ Pass ] The configuration quantity of CPU, memory, RAID card, disk, and IO card has not been checked.\t\t\t\t \033[0m"
}

check_Disk_Link_Status()
{
	# 若有多个磁盘组 raid，查询不到该磁盘的速率。
	diskNum=`sg_map -i | grep /dev/sd | wc -l`
	rst=`cat ./systemInto.txt | grep -a -A $diskNum "HDD&SSD capacity" | grep -v "HDD&SSD capacity" | awk '{print $11}' | grep -E -v "6|12" | wc -l`

	if [ $rst -eq 0 ];then
#		echo -e "\033[42m 【通过】磁盘连接速率检查通过。\t\t\t\t\t\t \033[0m"
		echo -e "\033[42m [ Pass ] Disk connection rate check passed.\t\t\t\t\t\t \033[0m"
	elif  [ $rst -gt 0 ];then
#		echo -e "\033[41m 【失败】部分或全部磁盘的连接速率不非标准速率！（6.0Gb/s或12.0Gb/s) \t \033[0m"
		echo -e "\033[41m [Failed] The connection rate of some or all disks is not non-standard rate!(6.0Gb/s or 12.0Gb/s) \t \033[0m"
	fi
}

check_Port_Speed()
{
#	以太网口速率检查
#	PortNum=`cat ./systemInto.txt | grep -a "8086" | wc -l`
	PortNum=`cat ./systemInto.txt | grep -a "network interface" | wc -l`
	rm -f PortLinkSpeed_*
	cat ./systemInto.txt | grep -a -A $PortNum "Check network device" | awk '{print $3}' | grep -v "device" > PortLinkSpeed_F
	cat ./systemInto.txt | grep -a -A $PortNum "Check network device" | grep -v "Check network device" | awk '{print $12}' | sed "s/b\/s//g" > PortLinkSpeed_C
	rst=`diff PortLinkSpeed_F PortLinkSpeed_C | wc -l`
	if [ $rst -eq 0 ];then
#		echo -e "\033[42m 【通过】以太网卡速率检查通过。\t\t\t\t \033[0m"
		echo -e "\033[42m [ Pass ] Ethernet card rate check passed.\t\t\t\t \033[0m"
	elif [ $rst -gt 0 ];then
#		echo -e "\033[41m 【失败】部分或全部以太网口未达到标准协商速率！\t\t\t\t \033[0m"
		echo -e "\033[41m [Failed] Some or all Ethernet ports do not reach the standard negotiation rate!\t\t\t\t \033[0m"
	fi

#	FC端口速率检查
}

rm -f systemInfo.txt
sh system_xsky.sh > ./systemInto.txt
sync
check_BIOS_VERSION $product_Model
check_BMC_VERSION $product_Model
check_VENDOR_INFO $product_Model
check_Server_Conf
check_Disk_Link_Status
check_Port_Speed
rm -f PortLinkSpeed_*
