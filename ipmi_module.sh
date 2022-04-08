#! /bin/bash

#Load ipmitool module
modprobe ipmi_watchdog
modprobe ipmi_poweroff
modprobe ipmi_devintf
modprobe ipmi_si
modprobe ipmi_msghandler


