#!/bin/sh
# pktgen.conf -- Sample configuration for send on two devices on a UP system

#modprobe pktgen

if ! [ -x eeupdate64e ]
then
    echo "eeupdate64e does not exit or has no permission"
    exit 1
fi

if [[ `lsmod | grep pktgen` == "" ]];then
   modprobe pktgen
fi

function pgset()
{
	local result
    
  echo $1 > "$PGDEV"

  result=`cat $PGDEV | fgrep "Result: OK:"`
  if [ "$result" = "" ]; then
      cat $PGDEV | fgrep Result:
  fi
}

function pg()
{
	echo inject > $PGDEV
	cat $PGDEV
}

function addDevToThread()
{
	PGDEV=/proc/net/pktgen/kpktgend_$2
#	echo "Removing all devices"
	pgset "rem_device_all"
#	echo "Adding eth1"
	pgset "add_device $1"
}

function devCongifure()
{
	CLONE_SKB="clone_skb 1000000"
	PKT_SIZE="pkt_size 2044"
	COUNT="count 0"
	DELAY="delay 0"
}

function setDevDst()
{
	PGDEV=/proc/net/pktgen/$1
#	echo "Configuring $PGDEV"
	pgset "$COUNT"
	pgset "$CLONE_SKB"
	pgset "$PKT_SIZE"
	pgset "$DELAY"
#	pgset "dst $2"
	pgset "src_mac $2"
	pgset "dst_mac $3"
}

intel_num=`./eeupdate64e  |grep -E "82599|X71|XL7|X520|XXV710|I350" |wc -l`
if [ ${intel_num} -eq 0 ];then
		echo "Not found Ethernet controller."
		exit 1
fi

echo "Found net device: "
kn=0
# Test Intel device.
if [ ${intel_num} -gt 0 ];then
		for((i=0;i<$intel_num;i+=2))
		do
		    nic=`./eeupdate64e |grep -E "82599|X71|XL7|X520|XXV710|I350" |sed -n $((i+1))p |awk '{print $1}'`
		    mac1=`./eeupdate64e  /nic=$nic /mac_dump |grep MAC |awk '{print $6}' |sed 's/\./ /'`
		    mac1n="${mac1:0:2}:${mac1:2:2}:${mac1:4:2}:${mac1:6:2}:${mac1:8:2}:${mac1:10:2}"
		    net_device1=`ip addr |grep -iB 1 $mac1n |grep -iv $mac1n |awk '{print $2}' |sed 's/://'`
		        
		    mac2=`./eeupdate64e  /nic=$((nic+1)) /mac_dump |grep MAC |awk '{print $6}' |sed 's/\./ /'`
		    mac2n="${mac2:0:2}:${mac2:2:2}:${mac2:4:2}:${mac2:6:2}:${mac2:8:2}:${mac2:10:2}"
		    net_device2=`ip addr |grep -iB 1 $mac2n |grep -iv $mac2n |awk '{print $2}' |sed 's/://'`
		    echo "==================================="
		    echo "net_dev:  $net_device1"
		    echo "src_mac:  $mac1n"
		    echo "dst_mac:  $mac2n"
		 		echo "==================================="
		    echo "net_dev:  $net_device2"
		    echo "src_mac:  $mac2n"
		    echo "dst_mac:  $mac1n"
		 		echo "==================================="
		    addDevToThread "$net_device1" $kn 
		    kn=$((kn+1))
		    addDevToThread "$net_device2" $kn 
		    
		    devCongifure 
		    
		    setDevDst "$net_device1" $mac1n $mac2n
		    setDevDst "$net_device2" $mac2n $mac1n
		    
		    PGDEV=/proc/net/pktgen/pgctrl
			    
		    kn=$((kn+1))
		done
fi


echo "Netpresure test run."
pgset "start"


