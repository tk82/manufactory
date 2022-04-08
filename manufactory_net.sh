#!/bin/bash

serverIP=$1
testTime=$2
portType=$3
fail_count=0
pass_count=0

##判断 bw是否符合 Bandwidth
check_bw()
{
	net=$1
	bw_F=$2
#将端口带宽向下取整
	bw=`echo $bw_F | sed "s/\..*//g"`
	# 判断 万兆网卡端口 小于 9100的数据
  	echo $bw
	case $net in
	1)  # 千兆 930 * 1000,000 bps(比特每秒)
		if [ $bw -lt 930 ];then
			echo "[FAILED]"
		else 
			echo "[PASS]"
		fi
		exit;;
	2)  # 10GE 万兆 9300 * 1000,000 bps(比特每秒)
#		if [ $bw -lt 9300 ];then
		if [ $bw -lt 9100 ];then
			echo "[FAILED]"
		else
			echo "[PASS]"
		fi
		exit;;
	*)
		echo "[ERROR]"
		exit;;
	esac
}

count=$((testTime/10))

tmpfile=${serverIP}_tmp

# 远端IP、测试次数
if [ $portType -eq 2 ];then
	echo -e "servreIP: ${serverIP}\ntotal_count: ${count}" >> GE_10_netperf_net_test.txt
else
	echo -e "servreIP: ${serverIP}\ntotal_count: ${count}" >> GE_netperf_net_test.txt
fi

for((i=0;i<=$count;i++));do
	netperf -H $serverIP > ${tmpfile}
	if [ $i -eq 0 ];then
#		echo -e "========\t\t\t `cat ./${tmpfile} | sed -n "1p"`" >> ./manufactory_net_test.txt
#		echo -e "========\t\t\t `cat ./${tmpfile} | sed -n "2p"`" >> ./manufactory_net_test.txt
#		echo -e "========\t\t\t `cat ./${tmpfile} | sed -n "3p"`" >> ./manufactory_net_test.txt
#		echo -e "========\t\t\t `cat ./${tmpfile} | sed -n "4p"`" >> ./manufactory_net_test.txt
#		echo -e "========\t\t\t `cat ./${tmpfile} | sed -n "5p"`" >> ./manufactory_net_test.txt
#		echo -e "========\t\t\t `cat ./${tmpfile} | sed -n "6p"`" >> ./manufactory_net_test.txt
# 下面2句 替换上面注释掉的输出
    sed -i '1,6 s/^/========\t\t\t /g' ${tmpfile}
    cat ./$tmpfile | sed -n "1,6p" >> ./manufactory_net_test.txt
	fi
	bw=`cat ${tmpfile} | sed -n '7p' | awk '{print $5}'`

	bw_1=`echo $bw | sed "s/\..*//g"`
	if [ $portType -eq 2 ];then
            if [ $bw_1 -lt 9100 ];then
	        let fail_count+=1
	    fi
        elif [ $portType -eq 1 ];then
            if [ $bw_1 -lt 930 ];then
	        let fail_count+=1
	    fi
        fi

	echo -e `check_bw $portType $bw`"\t"`date +"%Y-%m-%d %H:%M:%S"`"\t" `cat ./${tmpfile} | sed -n "7p"` >> ./manufactory_net_test.txt
done

if [ $portType -eq 2 ];then
	echo -e "fail_count: $fail_count\n" >> GE_10_netperf_net_test.txt
else
	echo -e "fail_count: $fail_count\n" >> GE_netperf_net_test.txt
fi
