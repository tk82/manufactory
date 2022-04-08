#! /usr/bin/bash

result_fail=0

line_count=`wc -l < zz.txt`
for((i = 4; i <= line_count; i+=4))
do
	for((j = 2 + i - 4; j < i; j++))
	do
		total=`sed -n ''"$j"'p' zz.txt | awk '{print $2}'`
		let "j+=1"
		fail_count=`sed -n ''"$j"'p' zz.txt | awk '{print $2}'`
		if [ $((fail_count * 200)) -le $total ];then
			break
		else
			let "result_fail+=1"
		fi
	done
done


