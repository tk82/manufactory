#sleep 259200
# 杀死指定名字的所有进程，类似于 killall
pkill -f  yes
pkill -f mem.sh
pkill -f stream.o
pkill -f netpresure.sh
#pkill gpupresure.sh
sh ./kill.sh
#mv run.sh run.sh
