#!/bin/sh
echo "enter  network config file dir "
cd  /etc/sysconfig/network-scripts/

echo "creat bak dir and copy file"
rm -rf ./bak
mkdir bak
cp ifcfg-* ./bak/

echo "del bond file ,modify dev config file "
rm -f ifcfg-bond*

file_list=`ls |grep  -i ifcfg-en`
for  file in $file_list
do 
	sed -i '/MASTER/d' $file 
	sed -i '/SLAVE/d' $file 
done

cd /root/manufactory
