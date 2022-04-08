while [ 1 ];
do
    # dd 命令用于读取、转换并输出数据。输入设备是：块设备，输出到“黑洞”：/dev/null，bs=1M 每次读写 1M 数据（读、写入缓冲区的字节数），相当于 ibs=1M 和 obs=1M。
    # 因为/dev/sda 是一个块设备（硬盘），对它的读取会产生IO，/dev/null是伪设备，相当于黑洞，of 到该设备不会产生IO，所以，这个命令的IO只发生在/dev/sda上，也相当于测试磁盘的 读能力。
    # 直到 读完 /dev/sdx 中的数据，才停止。
    dd if=/dev/$1 of=/dev/null bs=1M iflag=direct
done


