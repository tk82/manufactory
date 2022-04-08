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
      ipmitool  fru edit 0 field b 0 "white_card"    # 名字未定 Board Mfg
    fi
    if [ $Product_Manufacturer_2 == "XSKY" ];then
      ipmitool  fru edit 0 field p 0 "white_card"    # 名字未定 Product Manufacturer
    fi
  else
# 编辑 ID 为 0，p（P）开头的第一行字段的内容。Product Name : XE3100G2
    ipmitool  fru edit 0 field b 0 "XSKY"
    ipmitool  fru edit 0 field p 0 "XSKY"
    ipmitool  fru edit 0 field p 1 "$pro_name"
  fi
fi
:<< EOF
FRU Device Description : Builtin FRU Device (ID 0)
 Chassis Type          : Rack Mount Chassis
 Board Mfg Date        : Wed Jul 21 16:51:00 2021
 Board Mfg             : XSKY
 Board Product         : T1DM-E2
 Board Serial          : 22200147T-1ZCWDA00087012103290088
 Board Extra           : 0000000000000000000000000
 Product Manufacturer  : XSKY
 Product Name          : X3000
 Product Serial        : 80900008TWORK000485012108020002
 Product Asset Tag     : 0000000000000000000000000
EOF
