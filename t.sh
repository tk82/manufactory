#!/bin/bash
# 读取配置文件，获取测试时间，默认 24H
s=`cat config.cfg | grep -a "CPU及内存老化测试时间" | awk '{print $4}'`
# 给定一个文件名，最下面那里重定向到 该文件，相当于创建了该文件
file_name="./check_result.txt"

# 2022-03-17 15:29:22
date1=`date +"%Y-%m-%d %H:%M:%S"`
# 1647502238：从 1970年1月1日00:00:00 以来到现在的总秒数
start_s=`date -d "$date1" +%s`

# 看不懂作用是啥
while ((t<s))
do
    date2=`date +"%Y-%m-%d %H:%M:%S"`
    end_s=`date -d "$date2" +%s`
    t=$((end_s-start_s))
    echo $t
    run_h=$((t/3600))
    run_m=$((t%3600/60))
    run_s=$((t%3600%60))
    echo "$run_h:$run_m:$run_s $date2"
    echo "$run_h:$run_m:$run_s $date2" >> time
    sleep 1
done
sh ./over.sh

# dmesg命令用于打印Linux系统开机启动信息
rst=`dmesg | grep error | wc -l`
if [ $rst -eq 0 ];then
	# echo -e "\033[42m 【通过】CPU及内存测试通过。\t\t\t\t\t\t \033[0m" >> $file_name
	echo -e "\033[42m [ Pass ] CPU and memory test passed.\t\t\t\t\t\t \033[0m" >> $file_name
elif [ $rst -gt 0 ];then
	# echo -e "\033[41m 【失败】CPU及内存测试不通过。\t\t\\tt\t\t\t \033[0m" >> $file_name
	echo -e "\033[41m [ Fail ] CPU and memory test failed.\t\t\\tt\t\t\t \033[0m" >> $file_name
fi
