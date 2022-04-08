#!/bin/sh
check_result()
{
	rst=`cat ./disk_stress_result.txt | grep -a "失败" | wc -l`
	if [ $rst -eq 0 ];then
#		echo -e "\033[42m 【通过】所有磁盘性能测试通过。\t\t\t\t \033[0m"
		echo -e "\033[42m [ Pass ] All disk performance tests passed.\t\t\t\t \033[0m"
	elif [ $rst -gt 0 ];then
#		echo -e "\033[41m 【失败】部分或全部磁盘性能测试数据异常！\t\t\t\t \033[0m"
		echo -e "\033[41m [ Failed ] Some or all disk performance test data is abnormal!\t\t\t\t \033[0m"
	fi
}

rm -rf result disk_stress_result.txt
sh ./disk_stress.sh > disk_stress_result.txt
check_result
