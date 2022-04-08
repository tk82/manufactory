while [ 1 ]; 
do
    # /dev/zero 是一个输入设备，你可你用它来初始化文件。该设备无穷尽地提供0；bs=1M 每次读写 1M 数据（读、写入缓冲区的字节数），相当于 ibs=1M 和 obs=1M。
    # 因为/dev/zero 是一个伪设备，它只产生空字符流，对它不会产生IO，所以，IO都会集中在 of文件中，of 文件只用于写，所以这个命令相当于测试磁盘的 写能力
    # 直到写满 /dev/sdx 磁盘的容量才停止。
    dd if=/dev/zero of=/dev/$1 bs=1M oflag=direct
done

