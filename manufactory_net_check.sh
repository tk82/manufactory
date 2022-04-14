#!/bin/sh
:<< EOF
check_result()
{
	sync
	while [ 1 ];do
		query=`ls ./manufactory_net_test.txt | wc -l`
		if [ $query -eq 1 ];then
			rst=`cat ./manufactory_net_test.txt | grep "Net Test Result" | awk -F":" '{print $2}'`
			if [[ $rst == "PASS" ]];then
#				echo -e "\033[42m 【通过】全部以太网端口性能测试通过。\t\t\t\t \033[0m"
				echo -e "\033[42m [ Pass ] All Ethernet port performance tests passed.\t\t\t\t \033[0m"
			elif [[ $rst == "FAILED" ]];then
#				echo -e "\033[41m 【失败】部分以太网端口性能测试不通过。\t\t\t\t \033[0m"
				echo -e "\033[41m [Failed] Some Ethernet ports fail the performance test.\t\t\t\t \033[0m"
			fi
			break
		elif [ $query -eq 0 ];then
			sleep 3
		fi
	done
}
EOF

check_reslut_GE()
{
	sync
	while [ 1 ];do
		# 判断文件是否存在，不存在则成功；存在再判断失败的次数，失败的次数等于0，则成功；否则失败
		file_exit=`[[ -e ./GE_netperf_net_test.txt ]] && echo 1 || echo 0`
                if [ $file_exit -eq 0 ];then
                        echo -e "\033[42m [ Pass ] GE Ethernet port performance tests passed.\t\t\t\t \033[0m"
			break
                elif [[ $file_exit -eq 1 ]];then
			fail_total=0

                        line_count=`wc -l < ./GE_netperf_net_test.txt`
                        for((i = 4; i <= line_count; i+=4))
                        do
                                for((j = 3 + i - 4; j < i; j++))
                                do
                                        fail_count=`sed -n ''"$j"'p' ./GE_netperf_net_test.txt | awk '{print $2}'`
                                        let "fail_total+=fail_count"
                                done
                        done
                fi
		if [[ $fail_total -eq 0 ]];then
                        echo -e "\033[42m [ Pass ] GE Ethernet port performance tests passed.\t\t\t\t \033[0m"
                        break
                else
                        echo -e "\033[41m [Failed] Some GE Ethernet ports fail the performance test.\t\t\t\t \033[0m"
                        break
                fi
	done
}

check_reslut_GE_10()
{
	sync
	while [ 1 ];do
		# 判断文件是否存在，不存在则成功；存在再判断失败的次数，失败的次数小于预期，则成功；否则失败
                file_exit=`[[ -e ./GE_10_netperf_net_test.txt ]] && echo 1 || echo 0`
		if [ $file_exit -eq 0 ];then
                        echo -e "\033[42m [ Pass ] 10 GE Ethernet port performance tests passed.\t\t\t\t \033[0m"
			break
                elif [[ $file_exit -eq 1 ]];then
			fail_total=0

			line_count=`wc -l < ./GE_10_netperf_net_test.txt`
			for((i = 4; i <= line_count; i+=4))
			do
        			for((j = 2 + i - 4; j < i; j++))
        			do
                			total=`sed -n ''"$j"'p' ./GE_10_netperf_net_test.txt | awk '{print $2}'`
                			let "j+=1"
                			fail_count=`sed -n ''"$j"'p' ./GE_10_netperf_net_test.txt | awk '{print $2}'`
                			if [ $((fail_count * 200)) -le $total ];then
                        			continue
                			else
                        			let "fail_total+=1"
                			fi
        			done
			done
                fi
		if [[ $fail_total -eq 0 ]];then
			echo -e "\033[42m [ Pass ] 10 GE Ethernet port performance tests passed.\t\t\t\t \033[0m"
			break
		else
			echo -e "\033[41m [Failed] Some 10 GE Ethernet ports fail the performance test.\t\t\t\t \033[0m"
			break
		fi
	done
}

# rm -rf netperf_net_test.txt
# check_result

check_reslut_GE
check_reslut_GE_10
