#!/bin/bash

tmplog=" "
hdd_w=`cat config.cfg | grep -a "HHD_Write" | awk '{print $4}'`
ssd_w=`cat config.cfg | grep -a "SSD_Write" | awk '{print $4}'`
ssd_r=`cat config.cfg | grep -a "SSD_Read" | awk '{print $4}'`

#smart_info()功能：用于收集smart信息，并记录到临时文件tmplog。
#提供1个参数 $1--disk , tmplog值改变，这个值会用到。

smart_info()
{
	disk=$1
	tmplog="`date +%s`"_${disk}_tmp

	dev_speed=`smartctl -a /dev/${disk}|grep "SATA Version is"|awk -F "," '{print $2}'|cut -d  '('  -f2|cut -d  ')'  -f1`
	dev_health=`smartctl -a /dev/${disk}|grep "overall-health" |awk -F ":" '{print $2}'`
	atr2=`smartctl -a /dev/${disk}|grep "Power_Cycle_Count " |awk '{print $10}'`
	atr5=`smartctl -a /dev/${disk}|grep "UDMA_CRC_Error_Count " |awk '{print $10}'`
	atr7=`smartctl -a /dev/${disk}|grep -i "timeout" |awk  '{print $10}'`
	echo ""SATA Version" : $dev_speed" >> ${tmplog}
	echo ""Smart-health status" : $dev_health" >> ${tmplog}
	echo ""Power_Cycle_Count" : $atr2"  >> ${tmplog}
	echo ""UDMA_CRC_Error_Count" : $atr5" >> ${tmplog}
	echo ""Command_Timeout" : $atr7" >> ${tmplog}
	echo ""
}
  
#check_smart 功能：用于检查smart信息变化。有变化返回回1 ，并打印前后的值 ，无变化，返回0 
# 使用check_smart disk ,需带入参数
##未使用，直接用diff 比较前后文件 简单。

#ssd_test:全盘写非系统盘，全盘读非系统盘，速率符合期待返回0 ，不符合返回1.
ssd_test_w()
{
	ssd=$1
	smart_info $1
	tmp1=$tmplog

#	dd if=/dev/zero of=/dev/${ssd} bs=1M  count=10 oflag=direct  2> ${ssd}_write_log
# 从 /dev/zero 读取数据输出到 /dev/${ssd} 中，每次IO大小为 1M，封装成 IO直接发到（写入）磁盘 /dev/${ssd}，不经过缓存，错误输出保存到 日志中
# 因为/dev/zero 是一个伪设备，它只产生空字符流，对它不会产生IO，所以，IO都会集中在 of文件中，of 文件只用于写，所以这个命令相当于测试磁盘的 写能力
	dd if=/dev/zero of=/dev/${ssd} bs=1M  oflag=direct  2> ${ssd}_write_log
# 这里的 result 文件最后会被重命名为 manufactory_disk_test.txt
	echo -e "$ssd write_1M_direct:\n" >> result
	cat ${ssd}_write_log >> result

	write_bw=`cat ${ssd}_write_log |grep  -i MB |awk  -F "," '{print $3}' |awk '{print $1}'`
	if [ $write_bw -lt $ssd_w ];then
		echo -e "【失败】${ssd} write bandwidth is ${write_bw} MB/s , 未达到预期 "   # 临时保存到 disk_stress_result.txt文件中
	else
		echo -e "【通过】${ssd} write bandwidth is ${write_bw} MB/s"
		rm -f ${ssd}_write_log
	fi

##测试后记录smart 关键信息并记录到文件
	smart_info $1
	tmp2=$tmplog
	diff $tmp1 $tmp2
	if [ $? == 0 ];then
		echo -e "【通过】$disk smartinfo not change"
		cat $tmp2  >> result
		rm -f *_${ssd}_tmp
	else
		echo -e "【失败】${ssd} smartinfo is changed ,check log"
	fi
}

###
ssd_test_r()
{
	ssd=$1
	smart_info $1
	tmp1=$tmplog

#	dd if=/dev/${ssd} of=/dev/null bs=1M count=10 iflag=direct  2> ${ssd}_read_log
# 从 /dev/${ssd} 读取数据输出到 黑洞/dev/null 中，每次IO大小为 1M，封装成 IO直接发到（读取）磁盘 /dev/${ssd}，不经过缓存，错误输出保存到 日志中
# 因为/dev/sda 是一个块设备（硬盘），对它的读取会产生IO，/dev/null是伪设备，相当于黑洞，of 到该设备不会产生IO，所以，这个命令的IO只发生在/dev/sda上，也相当于测试磁盘的 读能
	dd if=/dev/${ssd} of=/dev/null bs=1M iflag=direct  2> ${ssd}_read_log

	echo -e "$ssd read_1M_direct:\n" >> result
	cat ${ssd}_read_log >> result

	read_bw=`cat ${ssd}_read_log |grep  -i MB |awk  -F "," '{print $3}' |awk '{print $1}'`
	if [ $read_bw -lt $ssd_r ];then
		echo -e "【失败】${ssd} read bandwidth is ${read_bw} MB/s , 未达到预期 "   # 临时保存到 disk_stress_result.txt文件中
	else
		echo -e "【通过】${ssd} read bandwidth is ${read_bw} MB/s"
		rm -f ${ssd}_read_log
	fi

##测试后记录smart 关键信息并记录到文件        
	smart_info $1
	tmp2=$tmplog
	diff $tmp1 $tmp2
	if [ $? == 0 ];then
		echo -e "【通过】$ssd smartinfo not change"
		cat $tmp2  >> result
		rm -f *_${ssd}_tmp
	else
		echo -e "【失败】$ssd smartinfo is changed ,check log"
	fi
}

#hdd_test:dd写1T容量，速率符合期待返回0 ，不符合返回1.
hdd_test()
{
	hdd=$1
	smart_info $1
	tmp1=$tmplog

#	dd if=/dev/zero of=/dev/${hdd} bs=1M count=500 oflag=direct 2> ${hdd}_log
# 从 /dev/zero 读取数据输出到 /dev/${hdd} 中，每次IO大小为 1M，总共复制1000000个bs，封装成 IO直接发到（写入）磁盘 /dev/${hdd}，不经过缓存，错误输出保存到 日志中
	dd if=/dev/zero of=/dev/${hdd} bs=1M count=1000000 2> ${hdd}_log

	echo -e "$hdd write_1M_1000000:\n" >> result
	cat ${hdd}_log >> result

	write_bw=`cat ${hdd}_log |grep  -i MB |awk  -F "," '{print $3}' |awk '{print $1}'`
	if [ $write_bw ];then
		if [ $write_bw -lt $hdd_w ];then
			echo -e "【失败】${hdd} write bandwidth is ${write_bw} MB/s , 未达到预期 "
		else 
			echo -e "【通过】${hdd} write bandwidth is ${write_bw} MB/s"
			rm -f ${hdd}_log
		fi
	else
		echo -e "【失败】没有性能结果输出。"
	fi

##测试后记录smart 关键信息并记录到文件
	smart_info $1
	tmp2=$tmplog
	diff $tmp1 $tmp2
	if [ $? == 0 ];then
		echo -e "【通过】$disk smartinfo not change"
		cat $tmp2  >> result
		rm -f *_${hdd}_tmp
	else
		echo -e "【失败】$hdd smartinfo is changed ,check log"
	fi
}

### 测试：读硬盘--对非系统盘 测试--SSD_TEST_W SSD_TEST_R HDD_TEST  ,没理清，重复流程了。SAD

#whereis  /boot partition whereis os_disk
# -c ：以字符为单位进行分割。--sda 取第3-5个字符（cut 分割字符串时，下标起始位置为 1，不是 0）
os_disk=`lsblk |grep -i boot|awk '{print $1}'|cut -c 3-5`
# -d：不打印从属设备，比如：sda1、sda2....
all_disk=`lsblk -n -d|grep -i sd|sort|awk '{print $1}'`

####smart_info##########################

for disk  in  ${all_disk}
do
	if [ ${disk} == ${os_disk} ];then
		echo  "${disk} is  the os_disk  ,ignore test !"
	else
		smartctl -a /dev/${disk} |grep -i "Solid State Device" 1>& /dev/null 
		if [ $? == 0 ];then
			echo "$disk is SSD"
			ssd_test_w $disk
			ssd_test_r $disk
		else
			echo "$disk is HDD"
			hdd_test $disk
		fi
	fi	
done
