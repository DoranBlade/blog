---
title: "进程管理"
date: 2017-12-30T15:19:36+08:00
tags: ["computer", "linux"]
---
Linux下的进程管理
<!--more-->

## 软件的启动
Linux中软件的启动全是通过命令启动，启动的方式又如下两种
+ 通过路径确定命令的位置后调用
+ 在$PATH目录中寻找命令然后启动

### 路径启动
通过路径启动软件的根本原因是需要确定命令所在的位置，可以是相对路径也可以是绝对路径。确定了命令的路径即可调用该命令。

``` shell
$./startup.sh  // 相对路径
$/home/soft/tomcat/bin/startup.sh  //绝对路径
```

一般情况下使用源码包安装的软件会通过这种方式启动。

### 全局启动
全局启动相对与使用路径启动的难点在于确定命令的所在位置，Linux在查找全局命令时会去$PATH环境变量内所定义的目录内查找，如果查找到则执行该命令，否则抛出command not found。
一般情况下使用rpm方式安装的软件，会自动在全局命令目录内添加软件的启动命令，这样就可以在全局范围内启动软件了。
如果使用源码包安装的软件需要通过全局启动的话，只需要将软件的启动命令添加到全局命令目录内即可。添加命令最简单的方式是创建启动命令的软链接。

``` shell
$ sudo ln -s /home/soft/tomcat/bin/startup.sh /usr/bin/startup
```