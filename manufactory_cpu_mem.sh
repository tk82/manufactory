#!/bin/sh

# 这里保存在后台
source ./function.sh

touch ./startrun

#gpu_num=`lspci | grep NVIDIA | wc -l`
#if [ $gpu_num -ne 0 ];then
#    pass_put "=============================================="
#    pass_put "  GPU Driver Install Test                      "
#    pass_put "=============================================="
#    if [ $(cmd_is_exist nvidia-smi) -eq 0 ]; then
#        item_put "GPU Driver" 18
#        echo "Not install"
#        item_put "GPU Driver" 18
#        install_put "Now begin install GPU Driver, please wait......"
#        chmod a+x /root/pkg/gpu_burn-0.7/NVIDIA-Linux-x86_64-418.56.run
#        /root/pkg/gpu_burn-0.7/NVIDIA-Linux-x86_64-418.56.run
#    else
#        item_put "GPU Driver" 18
#        pass_put "OK"
#    fi
#fi
# 加载 ipmi 工具到内核中
sh ./ipmi_module.sh
# 创建 CPU(s) 个 yes线程，占用全部的CPU资源
sh ./yes.sh

#pass_put "=============================================="
#pass_put "  MEM Read Test                               "
#pass_put "=============================================="
sh ./mem.sh &   # & 放在启动参数后面表示设置此进程为后台进程，这里将 sh mem.sh 设置为 后台进程，可以通过 ps -ef | grep mem.sh 查看
sleep 10
sh ./read.sh
sh ./write.sh

#if [ $gpu_num -ne 0 ];then
#    pass_put "=============================================="
#    pass_put "  GPU Presure Test                            "
#    pass_put "=============================================="
#    /root/pkg/gpu_burn-0.7/gpupresure.sh 
#fi

sleep 10
#pass_put "=============================================="
#pass_put "  Net Presure Test                            "
#pass_put "=============================================="

#/root/pkg/netpresure.sh &
sh ./t.sh
