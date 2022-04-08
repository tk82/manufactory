#!/bin/sh

function error_put()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m error_put() use error!!!\033[0m"
        exit 10
    fi
    echo -e "\033[5;31m$1\033[0m"
}

function pass_put()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m pass_put() use error!!!\033[0m"
        exit 10
    fi
    echo -e "\033[32m$1\033[0m"
}

function install_put()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m install_put() use error!!!\033[0m"
        exit 10
    fi
    echo -e "\033[33m$1\033[0m"
}

function item_put()
{
    if [ $# -ne 2 ];then
        echo -e "\033[31m item_put() use error!!!\033[0m"
        exit 10
    fi 
    len=`echo $1 | wc -c`
    sp_num=`expr $2 - $len`
    echo -n " $1"
    for (( i=1; i<=$sp_num; i++ ))
    do
        echo -n " "
    done
    echo -n ": "
}

function cmd_is_exist()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m cmd_is_exist() use error!!!\033[0m"
        exit 10
    fi
    $1 2>/dev/null 1>/dev/null
    if [ $? -eq 127 ];then
        echo 0
    else
        echo 1
    fi
}

function file_is_exist()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m file_is_exist() use error!!!\033[0m"
        exit 10
    fi
    if [ `find / -name $1 | wc -l` -eq 0 ];then
        echo 0
    else
        echo 1
    fi
}

function get_file()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m get_file() use error!!!\033[0m"
        exit 10
    fi
    echo `find / -name $1 | head -1`
}


function install_tool()
{
    if [ $# -ne 1 ];then
        echo -e "\033[31m install_tool() use error!!!\033[0m"
        exit 10
    fi
    yum install $1 -y 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ];then
        echo 0
    else
        echo 1
    fi
}

# usage: install_rpm_package rpm-build rpm-build-4.11.3-35.el7.x86_64 20
function install_rpm_package()
{
    if [ $# -ne 3 ];then
        echo -e "\033[31m install_rpm_package() use error!!!\033[0m"
        exit 10
    fi
    item_put $1 $3
    if [ `rpm -qa | grep $1 | wc -l` -eq 0 ];then
        if [ $(file_is_exist "${2}*.rpm") -eq 0 ];then
            echo "Can't find $1 package.Now try to auto install,please wait."
	    ret=$(install_tool $1)
	    if [ ${ret} -eq 0 ];then
	        item_put $1 $3
	        error_put "Auto install fail."
                echo -e "\033[31m Please download the package or use: yum install $1\033[0m"
                exit 2
            fi
            item_put $1 $3
            pass_put "OK"
        else
            pack_rpm=$(get_file $2)
            ret=$(install_tool $2)
            if [ ${ret} -eq 0 ];then
                echo "Install ${pack_rpm} package fail.Now try to auto install,please wait."
	        ret=$(install_tool $1)
	        if [ ${ret} -eq 0 ];then
                    item_put $1 $3
	            error_put "Auto install fail."
                    echo -e "\033[31m Please download the other package or use: yum install $1\033[0m"
                    exit 2
                fi
                item_put $1 $3
                pass_put "OK"
            else
                pass_put "OK"
            fi
        fi
    else
        pass_put "OK"
    fi
}
