#!/usr/bin/env bash

#判断是否传入了参数
if [ $# -ne 1 ];
then
    echo "Usage: sh nfs-sharedir.sh  [PATH]"
    exit
fi

#获取共享目录
SHARED_PATH=$1
EXPORTS="/etc/exports"

#判断目录是否存在
if [ ! -d $SHARED_PATH ];
then
#不存在则创建目录
    mkdir -p $SHARED_PATH
#目录创建失败，则退出
        if [ $? -ne 0 ]; then
            echo "mkdir failed :$SHARED_PATH"
            exit
        fi
fi

#修改目录权限
chmod 777 $SHARED_PATH

if [ $? -ne 0 ]; then
            echo "chmod failed :$SHARED_PATH"
            exit
fi

#判断文件是否存在/etc/exports
if [ ! -f "$EXPORTS" ]; then
    echo "$SHARED_PATH *(rw,sync)" > $EXPORTS
else
    if  [ `grep -c $SHARED_PATH $EXPORTS` -eq '0' ]; then
        echo "$SHARED_PATH *(rw,sync)" >> $EXPORTS
    fi

fi

#更新exports文件
exportfs -arv