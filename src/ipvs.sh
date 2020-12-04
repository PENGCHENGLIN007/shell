#!/usr/bin/env bash


#0.判断是否安装，如果已经安装，退出

if [ `lsmod | grep -e ip_vs -e nf_conntrack_ipv4 | wc -l` -gt '5' ];then
    echo "ipvs is already instelled!"
    exit
fi


#1.开启内核参数
SYSCTL="/etc/sysctl.conf"
FIND_SYSCTL_STR1="net.ipv4.ip_forward"
FIND_SYSCTL_STR2="net.bridge.bridge-nf-call-iptables"
FIND_SYSCTL_STR3="net.bridge.bridge-nf-call-ip6tables"

SYSCTL_STR1="net.ipv4.ip_forward = 1"
SYSCTL_STR2="net.bridge.bridge-nf-call-iptables = 1"
SYSCTL_STR3="net.bridge.bridge-nf-call-ip6tables = 1"

if [ `grep -c "$FIND_SYSCTL_STR1" $SYSCTL` -eq '0' ];then
    echo "$SYSCTL_STR1" >> $SYSCTL
fi

if [ `grep -c "$FIND_SYSCTL_STR2" $SYSCTL` -eq '0' ];then
    echo "$SYSCTL_STR2" >> $SYSCTL
fi

if [ `grep -c "$FIND_SYSCTL_STR3" $SYSCTL` -eq '0' ];then
    echo "$SYSCTL_STR3" >> $SYSCTL
fi

sysctl -p

#2.开启ipvs支持

IPVS="/etc/sysconfig/modules/ipvs.modules"

FIND_IPVS_STR1="ip_vs"
FIND_IPVS_STR2="ip_vs_rr"
FIND_IPVS_STR3="ip_vs_wrr"
FIND_IPVS_STR4="ip_vs_sh"
FIND_IPVS_STR5="nf_conntrack_ipv4"

IPVS_STR1="modprobe -- ip_vs"
IPVS_STR2="modprobe -- ip_vs_rr"
IPVS_STR3="modprobe -- ip_vs_wrr"
IPVS_STR4="modprobe -- ip_vs_sh"
IPVS_STR5="modprobe -- nf_conntrack_ipv4"


if [ ! -f "$IPVS" ]; then
    echo "#!/bin/bash" > $IPVS
    echo "$IPVS_STR1" >> $IPVS
    echo "$IPVS_STR2" >> $IPVS
    echo "$IPVS_STR3" >> $IPVS
    echo "$IPVS_STR4" >> $IPVS
    echo "$IPVS_STR5" >> $IPVS
else
        if [ `grep -c "$FIND_IPVS_STR1" $IPVS` -eq '0' ];then
            echo "$IPVS_STR1" >> $IPVS
    fi

        if [ `grep -c "$FIND_IPVS_STR2" $IPVS` -eq '0' ];then
            echo "$IPVS_STR2" >> $IPVS
    fi

        if [ `grep -c "$FIND_IPVS_STR3" $IPVS` -eq '0' ];then
            echo "$IPVS_STR3" >> $IPVS
    fi

        if [ `grep -c "$FIND_IPVS_STR4" $IPVS` -eq '0' ];then
            echo "$IPVS_STR4" >> $IPVS
    fi

        if [ `grep -c "$FIND_IPVS_STR5" $IPVS` -eq '0' ];then
            echo "$IPVS_STR5" >> $IPVS
    fi
fi

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

