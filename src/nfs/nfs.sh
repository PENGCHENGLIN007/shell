#!/usr/bin/env bash



USAGE="Usage: nfs.sh (status|version|install|start|stop)"

ARG=$1

if [[ $ARG != "status" ]] && [[ $ARG != "version" ]] && [[ $ARG != "install" ]] && [[ $ARG != "start" ]] && [[ $ARG != "stop" ]]; then
  echo $USAGE
  exit 1
fi

if [[ $ARG == "status" ]]; then
    #result is active|unknown|inactive
    echo `systemctl is-active nfs-server`
    exit 0
fi

if [[ $ARG == "version" ]]; then
    #nfs-utils-1.3.0-0.66.el7_8.x86_64
    echo `rpm -qa |grep nfs-utils`
    exit 0
fi

if [[ $ARG == "install" ]]; then

    #判断是否已经安装，是则退出
    if [[ `systemctl is-active nfs-server` = 'active' &&  `systemctl is-active rpcbind.service` = 'active' ]];then
        echo "nfs is already installed!"
        exit 0
    fi

    if [[ `systemctl is-active nfs-server` = 'inactive' ||  `systemctl is-active rpcbind.service` = 'inactive' ]];then
        echo "start nfs server"
        systemctl start rpcbind.service
        systemctl start nfs-server.service
        exit 0
    fi

    #安装nfs，使用rpm包
    echo "installing nfs ..."
    rpm -Uvh *.rpm --nodeps --force

    #开机启动
    echo "start nfs server after the computer start up"
    systemctl enable rpcbind.service
    systemctl enable nfs-server.service

    #启动服务
    echo "start nfs server"
    systemctl start rpcbind.service
    systemctl start nfs-server.service

    #测试服务是否启动
    rpcinfo -p

    echo "install and start nfs server successfully!"
fi


if [[ $ARG == "start" ]]; then
    systemctl start rpcbind.service
    systemctl start nfs-server.service
fi

if [[ $ARG == "stop" ]]; then
    systemctl stop rpcbind.service
    systemctl stop nfs-server.service
fi