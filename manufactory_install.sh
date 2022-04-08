#/bin/sh
#install some tools
echo "install storcli ,ipmitool ,nvme-cli"
rpm -ivh nvme-cli-0.7-1.el7.x86_64.rpm
rpm -ivh storcli-1.21.06-1.noarch.rpm
rpm -ivh OpenIPMI-modalias-2.0.23-2.el7.x86_64.rpm
rpm -ivh OpenIPMI-libs-2.0.23-2.el7.x86_64.rpm
rpm -ivh ipmitool-1.8.18-7.el7.x86_64.rpm
rpm -ivh netperf-2.7.0-1.el7.lux.x86_64.rpm

sh ./ipmi_module.sh
