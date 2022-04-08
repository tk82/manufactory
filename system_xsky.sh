#!/bin/bash
chmod +x nvmcheck64e
chmod +x arcconf
chmod +x sas3ircu
chmod +x spsInfoLinux64

echo -e "======================================================================="
echo -e "BIOS与BMC相关信息："
echo -e "\tBIOS Infomation"
echo -e "\t\tBIOS"`dmidecode -t 0 |grep -A 3 "BIOS Info" | grep "Version"` | sed "s/\:/ \t\:/g"
echo -e "\t\t"`dmidecode -t 0 |grep -A 3 "BIOS Info" | grep "Date"` | sed "s/ Release/Release/g" | sed "s/\:/ \t\:/g"
#	echo -e "BIOS DMI Board Serial\t: `dmidecode -t 2 | grep Serial |awk '{print $3}'`"
echo -e "\tBIOS DMI Serial Number\t: `dmidecode -t 1 | grep Serial |awk '{print $3}'`"
echo -e "\tBIOS DMI Product Name\t: `dmidecode -t 1 | grep Product |awk '{print $3}'`"
echo
./spsInfoLinux64 |grep "FW version" | sed "s/SPS Image/\tME/g" | sed "s/\:/ \t\t\: /g"
echo
echo -e "\tBMC `ipmitool mc info | grep "Firmware Revision" `.`ipmitool mc info | grep -A1 'Aux' | grep 0x | sed 's/.*0x//'`"
echo -e "\t\t"`ipmitool fru print 0 | grep "Board Serial"` | sed "s/\:/ \t\:/g"
#	echo -e "\t"`ipmitool fru print 0 | grep "Product Serial"` | sed "s/\:/ \t\:/g"
#	echo -e "\t"`ipmitool fru print 0 | grep "Product Name"` | sed "s/\:/ \t\:/g"
echo -e "\t\t"`ipmitool fru print 0 | grep "Board Mfg" |grep -v "Date"` | sed "s/\:/ \t\:/g"
echo -e "\t\t"`ipmitool fru print 0 | grep "Board Product"` | sed "s/\:/\t\:/g"
echo -e "\t\t"`ipmitool fru print 0 | grep "Product Manu"`    # white_card can't display XSKY
echo
# 发送 RAW IPMI 请求和打印响应
ipmitool raw 0x06 0x52 0x05 0xe0 0 0 8 >/dev/null
cpldversion=`ipmitool raw 0x06 0x52 0x05 0xae 1 0x10 |sed 's/ //'`
printf "\tMotherboard CPLD Version: REV 1.%02d\n" $[0x$cpldversion - 1]
ipmitool raw 0x06 0x52 0x05 0xe0 0 0 1 >/dev/null
ipmitool raw 0x06 0x52 0x05 0xe0 0 0 1 >/dev/null
cpldversion=`ipmitool raw 0x06 0x52 0x05 0xae 1 0x10 |sed 's/ //'`
printf "\tBackplane CPLD Version \t: REV 1.%02d\n" $[0x$cpldversion - 1]
ipmitool raw 0x06 0x52 0x05 0xe0 0 0 1 >/dev/null

#######expander#########
for i in `sg_map -i |grep SXP |awk '{print $1}'`;
do 
    sg_map -i |grep $i |awk '{$1="Expander Version:";print}';
    echo "SAS address : `sg_ses -p 0x16 $i |grep "16 00 00 08"|awk '{for(i=6;i<14;i++)printf $i}'`";
done

echo
echo -e -n "\tchassis\t\t\t: "
for i in `ipmitool raw 0x0e 0x52 0x0b 0xa8 0x10 0x00 0x10`
do
    echo -e -n "\x$i"   # -n：不输出尾部的换行符；十六进制：\x， HH：2个数字
done
echo
####ME check####
#me_status=`./spsInfoLinux64 |grep  -i current |awk '{print $4}'`
#if [ "$me_status" == "Normal" ]
#then
#    echo -e "\033[32mcheck ME PASS \033[0m"
#else
#    echo -e "\033[31mcheck ME FAILED \033[0m"
#fi
#
echo -e "========================================================================"
echo -e "CPU信息："
dmidecode -t 4 |grep "Version" |sed 's/Version/CPU/'
echo
echo -e "========================================================================"
echo -e "内存信息："
echo -e "\tMemory quantity: `dmidecode -t 17 |grep -ic "asset tag.*CPU*"`"
dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range > c
dmidecode | grep -A16 "Memory Device" | grep 'Speed' > b
dmidecode -t memory | grep -i manufacture > d
dmidecode -t memory | grep -i serial > e
dmidecode -t 17 | grep -i "asset tag" > f
echo -e "\b"`paste f d e b c | grep -v "No Module Installed"` | sed "s/_AssetTag//g" | sed "s/Asset/\n\tAsset/g"
echo
echo -e "========================================================================"
echo -e "存储资源信息："
echo -e "\tLSI SAS CARD \t:"
for j in `./sas3ircu list |grep 3008 |awk '{print $1}'`
	do
		echo -e "\t\t$j    LSI3008   `./sas3ircu $j display|grep -i 'Firmware version'|sed 's/ //g'`    `./sas3ircu $j display |grep -A 1 Enclosure.*1 |grep -i logical|sed 's/ //g'` "
	done

echo -e "\tLSI raid CARD \t:"
raidnum=`/opt/MegaRAID/storcli/storcli64 show |grep -i "number of controllers" |sed 's/Number of Controllers = //'`
for((i=0;i<$raidnum;i++));
	do
		echo -e "\t\t$i    LSI9361   `/opt/MegaRAID/storcli/storcli64 /c0 show all |grep -i 'Firmware version'|sed 's/ //g'`    `/opt/MegaRAID/storcli/storcli64 /c0 show all |grep -i "sas Address"|sed 's/ //g'` "
	done
echo -e "\tPMC SAS CARD \t:"
./arcconf list |grep -iE "smart|Optimal" >h
# 创建一个文件 j
>j
pmcnum=`./arcconf list |grep -iE "smart|Optimal" |wc -l`
for((i=1;i<=$pmcnum;i++));
do
  ./arcconf getconfig $i ad|grep -i firmware |sed 's/ //g'>> j
done
# paste 指令会把每个文件以列对列的方式，一列列地加以合并
echo -e "\b\t"`paste  h j`

echo -e "\tSSD&HDD TOTAL QUANTITY :"
echo -e "\t\tSSD QUANTITY \t:"`sg_map -i | grep -i -E "intel|micron" | wc -l`
echo -e "\b"`sg_map -i | grep  -i -E "intel|micron"` | sed "s/\/dev\/sg/\n\t\t\t\/dev\/sg/g"
echo -e "\t\tHDD QUANTITY \t:"`sg_map -i | grep -i -v -E "intel|micron|B0" | wc -l`
echo -e "\b \t\t\t"`sg_map -i | grep -i -v -E "intel|micron|B0"` | sed "s/\/dev\/sg/\n\t\t\t\/dev\/sg/g"
echo -e "\tExpander info \t:"
echo -e "\b"`sg_map -i |grep -i "B0"` | sed "s/\/dev\/sg/\n\t\t\/dev\/sg/g"
#add capacity display
#lsblk -d
##ADD DISK INFO##
echo -e "\tHDD&SSD capacity and link speed \t:"
disk_check()
{
  # sda sdb sdc ..........
	all_disk=`lsblk -n -d|grep -i sd|sort|awk '{print $1}'`
	for disk  in  ${all_disk}
		do
		  # cut -d '[' -f2: 以 '[' 为分割符，打印第二个字段
			dev_cap=`smartctl -a /dev/${disk}| grep "User Capacity" |cut -d  '['  -f2|cut -d  ']'  -f1`
			dev_speed=`smartctl -a /dev/${disk}|grep "SATA Version is"|awk -F "," '{print $2}'|cut -d  '('  -f2|cut -d  ')'  -f1`
			echo -e "\t\t${disk} Capacity \t: $dev_cap , \t link speed : $dev_speed " 
		done
}

disk_check

echo -e "\tM.2 & NVME \t:"
echo -e "\t\t"`nvme list |grep dev`
#echo "SATA DVD:"
#if [ `lsblk |grep sr |wc -l` -eq 0 ]
#then
#    echo "NO DVD"
#else
#    mount /dev/`lsblk |grep sr |awk '{print $1}'` /mnt > /dev/null
#    if [ `ls /mnt |grep CentOS_BuildTag |wc -l` -eq 1 ]
#    then
#        echo -e "/dev/`lsblk |grep sr |awk '{print $1}'` \033[32m PASS \033[0m"
#    else
#        echo -e "/dev/`lsblk |grep sr |awk '{print $1}'` \033[31m FAILED \033[0m"
#    fi
#    umount /mnt
#fi
echo

#echo -e "========================================================================"
#echo -ne "TCM module \t:"
#sh ./tcmtest.sh

#echo -e "========================================================================"
#echo -e "Beep test \t:"
#ipmitool raw 0x0e 0x55 0x2e 0x01 0x01 >/dev/null
#sleep 3s
#ipmitool raw 0x0e 0x55 0x2e 0x01 0x00 >/dev/null
#read -p "Beep test end,please check,if ok press enter"

#add bmc sensor health 

echo -e "========================================================================"
echo -e "BMC sersor health \t:"
# 此命令将在 BMC 中查询 传感器数据记录 （Sensor Data Record） 存储库信息。
ipmitool sdr  |grep -i -E "nc|cr|nr"
if (($? == 1));then 
	echo -e "\tBMC SERSOR STATUS IS OK."
else 
	echo -e "\tplease check the sensor!"
	ipmitool sdr |grep -i E "nc|cr|nr"
fi

echo -e "========================================================================"
echo -e "Mac address \t:"
echo -e "\tBMC dedicate \t:"`ipmitool raw 0x0e 0x52 0x0b 0xa8 0x06 0x00 0x00|sed 's/ //g'`
echo -e "\tBMC NCSI \t:"`ipmitool raw 0x0e 0x52 0x0b 0xa8 0x06 0x00 0x08|sed 's/ //g'`
echo -e "\tOS network device info as below \t:"
./nvmcheck64e /devices  | grep 8086
## add net linspeed check##
net_check()
{
  # enp59s0f0 enp59s0f1 enp94s0f0 enp94s0f1 .........
	dev_list=`ls /etc/sysconfig/network-scripts/ |grep -i enp |awk -F "-" '{ print $2 }' | sort | uniq`
#	echo $dev_list
	for  dev in $dev_list;do
#		echo $dev
		drv=`ethtool -i $dev |grep -i driver |awk -F ":" '{print $2}'`
#		echo $drv
		if [[ "${drv}"  =~ "igb" ]];then
			echo -e "\t\t$dev \tis  1000M network interface , current  link status : `ethtool   ${dev}|grep -i speed `"
		elif [[ "${drv}" =~ "ixgbe" ]];then
			echo -e "\t\t$dev \tis 10000M network interface , current  link status : `ethtool  ${dev}|grep -i speed` "
		elif [[ "${drv}" =~ "ice" ]];then
			echo -e "\t\t$dev \tis 25000M network interface ,current  link status : `ethtool  ${dev}|grep -i speed`"
		else
			echo -e "$dev is not intel network interface ,OOPS  "
		fi
	done
}

echo -e "\tCheck network device link status \t:"
net_check 
rm -rf a b c d e  h j f

#add fc device check 
echo  "=========================fc device info =========================="
if [[ `lspci | grep -i  "Fibre" | wc -l` -eq 0 ]];then
	echo "NO FC Cards."
else
	./new-fc-info.sh 
fi
