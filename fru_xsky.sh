#!/bin/bash

#write product name
product_Model=$1
#read -p  "enter the product name: "  pro_name
echo "usage: ./fru_xsky.sh  \"$product_Model G2\""

# !:取反， -n：对 $1 参数判断是否不为空（不为空为真）；形成了 双重否定，建议替换为：-z: 对 $1 参数判断是否为空（为空为真）
if [ ! -n "$1" ]
then
  echo "please enter the product name:"
  exit
else
  echo $1
  pro_name=$1
# 对于白牌机，这两个参数不能显示为 XSKY。
  if [[ $product_Model =~ white_card ]];then
    Board_Mfg=`ipmitool fru | grep "Board Mfg" | grep -v "Date" | awk -F":" '{print $2}'`
    Product_Manufacturer_1=`ipmitool fru | grep "Product Manufacturer" | awk -F":" '{print $2}'`
    Product_Manufacturer_2=`dmidecode -t 1 | grep "Manufacturer" | awk '{print $2}'`

    if [ $Board_Mfg == "XSKY" -o $Product_Manufacturer_1 == "XSKY" ];then
      ipmitool  fru edit 0 field b 0 "    "    # 显示为空:4个空格
      ipmitool  fru edit 0 field b 1 "    "
      ipmitool  fru edit 0 field b 2 "    "
    fi
    if [ $Product_Manufacturer_2 == "XSKY" ];then
      ipmitool  fru edit 0 field p 0 "    "
      ipmitool  fru edit 0 field p 1 "    "
    fi
  else
# 暂时发现只有这几个能修改
    ipmitool  fru edit 0 field b 0 "XSKY"
    ipmitool  fru edit 0 field b 1 "T1DM-E2"
    ipmitool  fru edit 0 field b 2 "0000000000000000000000000"
    ipmitool  fru edit 0 field p 0 "XSKY"
    ipmitool  fru edit 0 field p 1 "$pro_name"
  fi
fi
