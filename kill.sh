#!/bin/bash
ps -ef |grep -E "dd|yes" |grep -iv "grep" |awk '{print $2}' > ./kill_list
for i in `cat ./kill_list`
do
	kill -9 $i
done
pkill dd
rm -rf ./kill_list
