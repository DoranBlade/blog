---
title: "sudo下找不到命令"
date: 2017-12-30T15:33:09+08:00
tags: ["computer", "linux"]
---
linux下某些命令无法使用管理员权限执行的问题
<!--more-->

## 问题描述

最近使用nginx的过程中，有一个启动方面的小问题。在使用nginx源码编译安装完成后，手动为nginx的启动命令创建一个软链接到/usr/local/bin目录下。Linux的默认定义的环境变量中本身就包含有一些预定义的目录，比如/bin,/sbin,/usr/bin,/usr/local/bin等。正常情况下，在bash中应该可以直接使用命令，系统依次按目录查找应该是能查找到该命令的。

``` shell
$nginx #启动nginx
nginx: [alert] could not open error log file: 
   open() "/usr/local/nginx/logs/error.log" failed (13: Permission denied)
2017/03/30 14:12:54 [emerg] 48168#0: open() 
   "/usr/local/nginx/logs/access.log" failed (13: Permission denied)
```

从上面的反馈来看是因为权限问题无法使用某些文件，导致了启动错误。nginx正常情况下是需要通过root权限来启动的，因为需要启动80/443端口。下面使用sudo来临时获取root权限启动nginx命令

``` shell
$sudo nginx
nginx: Command not found
```

使用sudo获取临时权限时又找不到该命令了。那么切换到root账户下呢？下面使用命令操作

``` shell
$su root
password:
#切换成root账户后
$nginx
```

切换到root账户下后又能正常查找到命令了。上面因为权限导致的启动问题也解决了。

## 解决方法
造成这个问题的根本原因是不同环境下的环境变量设置问题。首先检查普通账号和root账户的环境变量

``` shell
#普通账号
$echo ${PATH}
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
:/usr/games:/usr/local/games:/snap/bin:(其他自定义path)
#root账号
$echo ${PATH}
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
:/usr/games:/usr/local/games:/snap/bin:
```

很明显两种环境下都包含有/usr/local/bin目录。sudo环境下暂不知怎么通过命令查询该环境下的变量，但是可通过/etc/sudoers文件查看，该文件上有如下一行标示该环境下的变量设置。通过修改该变量设置就解决上面的问题了。

``` shell
$sudo vi /etc/sudoers
Defaults        secure_path="/usr/sbin:/usr/bin:/sbin:/bin"
#修改为
Defaults        secure_path="/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin"
# 修改完成后，再执行
$sudo nginx
```

## 备注
各个linux发行版本之间存在着一些差异，比如centos下sudo内是不包含有/usr/local/bin目录，ubuntu下sodu包含有/usr/local/bin目录。