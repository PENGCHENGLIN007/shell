#!/usr/bin/env bash




USAGE="Usage: nfs.sh (status|version|install|start|stop)"

ARG=$1


if [[ $ARG != "status" ]] && [[ $ARG != "version" ]] && [[ $ARG != "install" ]] && [[ $ARG != "start" ]] && [[ $ARG != "stop" ]]; then
  echo $USAGE
  exit 1
fi

if [[ $ARG == "status" ]]; then
    #result is active|unknown|inactive
    echo `systemctl is-active iptables`
    exit 0
fi

if [[ $ARG == "version" ]]; then
    #nfs-utils-1.3.0-0.66.el7_8.x86_64
    echo `rpm -qa |grep iptables-services`
    exit 0
fi


if [[ $ARG == "install" ]]; then

    #判断是否安装了iptables

    if [[ `systemctl is-active iptables` -eq 'inactive' ]];then
        echo "iptables has already installed!!!"
        echo "start iptables server"
        systemctl enable iptables.service
        systemctl start iptables.service
        exit 0
    fi

    if [[ `systemctl is-active iptables` -eq 'active' ]];then
        echo "iptables has already installed!!!"
        exit 0
    fi

    #安装所有rpm
    rpm -Uvh *.rpm --nodeps --force

    #开机启动
    echo "start iptables server after the computer start up"
    systemctl enable iptables.service

    #启动服务
    echo "start iptables server"
    systemctl start iptables.service

    #测试服务是否启动
    systemctl status iptables.service

    echo "install and start iptables server successfully!"

fi


if [[ $ARG == "start" ]]; then
    systemctl start iptables.service
fi

if [[ $ARG == "stop" ]]; then
    systemctl stop iptables.service
fi




