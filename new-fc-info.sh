#!/bin/sh



function qlogic_pre_test()
{
    if [ `lsmod | grep "qla2xxx" | wc -l` -eq 0 ];then
        echo "Without qla2xxx module."
        exit 1
    fi
    qaucli -h 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ];then
        if [ `find / -name QConvergeConsoleCLI-2.3.00-05.x86_64.rpm | wc -l` -eq 0 ];then
            echo "Can't find qaucli package."
            exit 3
        fi
        qau_pack=`find / -name QConvergeConsoleCLI-2.3.00-05.x86_64.rpm | head -1`
        rpm -i ${qau_pack}
    fi
}
function get_qlogic_info()
{
    cmd="cat /sys/class/fc_host/$1/"
    echo -n "============================$1 Info==================================================="
    if [ `echo $1 | wc -c` -eq 5 ];then
        echo "="
    else
        echo ""
    fi
    echo "${hba}"
    echo "Port Name                      : `${cmd}port_name | sed -e s/0x// -e 's/../&:/g' -e s/:$//`"
    echo "Port State                     : `${cmd}port_state`"
    echo "Speed                          : `${cmd}speed`"
    echo "Supported speeds               : `${cmd}supported_speeds`"
    echo "=========================================================================================="   
}
function get_emulex_info()
{
    cmd="cat /sys/class/fc_host/$1/"
    echo -n "============================$1 Info==================================================="
    if [ `echo $1 | wc -c` -eq 5 ];then
        echo "="
    else
        echo ""
    fi
    echo "HBA Model                      : `${cmd}symbolic_name | awk '{print $2}'`"
    echo "Port Name                      : `${cmd}port_name | sed -e s/0x// -e 's/../&:/g' -e s/:$//`"
    echo "Port State                     : `${cmd}port_state`"
    echo "Speed                          : `${cmd}speed`"
    echo "Supported speeds               : `${cmd}supported_speeds`"
    echo "=========================================================================================="
}

qlogic_num=`lspci | grep "Fibre" | grep "QLogic" | wc -l`
emulex_num=`lspci | grep "Fibre" | grep "Emulex" | wc -l`
if [ ${qlogic_num} -eq 0 -a ${emulex_num} -eq 0 ];then
    echo "Can't find FC cards."
    exit 1
fi
if [ ${qlogic_num} -gt 0 ];then
    qlogic_pre_test   
    hba=`qaucli -i | grep "HBA" | head -3 | tail -2`
fi

hosts=`ls /sys/class/fc_host/`
for i in ${hosts}
do
    flag=`cat /sys/class/fc_host/${i}/symbolic_name | awk '{print $1}'`
	echo $i
   echo $flag 
	if [[ ${flag} == "Emulex" ]];then
        get_emulex_info ${i}
#	echo 3
    elif [[ ${flag} =~ "QLE" ]];then
        get_qlogic_info ${i}
#	echo 2
    fi
done

