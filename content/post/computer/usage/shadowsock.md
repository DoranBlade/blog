---
title: "shadowsocks"
date: 2017-12-30T15:37:52+08:00
tags: ["computer", "usage"]
---

shadowsocks服务端和客户端搭建
<!--more-->

## server端
### shadowsocks项目
[shadowsocks](https://github.com/shadowsocks)项目是一个开源的项目，托管在github上。该项目使用python进行开发，通过该项目还fork出了其他版本。下面列出比较常用的版本

+ [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev):该项目使用c语言编写，性能上最好。比较适合路由器等性能比较弱的硬体上安装。
+ [shadowsocks-go](https://github.com/shadowsocks/shadowsocks-go):这个项目使用go语言编写，性能上也比较好，使用起来也特别方便。本指南就是基于该版本
+ [shadowsocks-rss](https://github.com/breakwa11/shadowsocks-rss):这个版本相对于shadownsocks添加了混淆功能，有利也有弊。

### 安装和配置shadownsocks-go
shadownsocks-go除了提供源码供自己编译外，作者还提供了编译好的二进制包，下载即用(推荐)。包解压后只有一个shadownsocks-server文件，可直接执行该文件开启shadownsocks服务。

shadownsocks-go有两种方式进行配置，一种是使用命令行参数，另外一种是使用配置文件。如下就是直接使用命令行参数

+ -p:指定服务端口
+ -k:指定链接密码
+ -m:指定加密方式
+ -c:指定配置文件,默认时config.json文件
+ -t:超时时间

``` bash
shadowsocks-server -p server_port -k password
    -m aes-128-cfb -c config.json
    -t timeout
```

命令行参数的方式不利于重用，每次开启都需要重复输入信息。所以使用配置文件的方式进行配置。shadownsocks-go默认使用config.json文件，目录内新建该文件

``` bash
$ touch config.json
$ vi config.json
```

该文件内键入如下内容，server_port:可供client连接的端口,local_port:供本地http服务连接的端口
``` json
{
    "server":"127.0.0.1",
    "server_port":8388,
    "local_port":1080,
    "password":"barfoo!",
    "method": "aes-128-cfb-auth",
    "timeout":600
}
```

然后就可以直接运行shadownsocks-server开启服务了

``` bash
$./shadownsocks-server > log &
```

如果需要开启多个用户，则改用下面配置

``` json
{
    "port_password": {
    	"8387": "password",
    	"8388": "password"
    },
    "method": "aes-128-cfb",
    "timeout": 600
}
```

## client端
在每个平台上都有对应的图形化client端，pc/移动端。下面以windows端为例。
[shadowsocks-windows](https://github.com/shadowsocks/shadowsocks-windows)是一个绿色软件，解压即可使用。其主要有下面几个配置

+ 开启系统代理,这个直接在软件上勾选即可
+ 配置服务器连接信息，需要包含如下信息

> 服务器ip地址和端口

>  连接密码

> 加密方式
![](/img/use/shadowsocks01.png)

+ 选择代理模式,pac/全局

> 全局模式下，所有socks和http连接均会走代理通道

> pac模式下，只有list上的连接才会走代理通道，其余连接直连

> pac的list使用软件提供的GFWList从线上获取别人已经整理好的list([GFWList](https://github.com/gfwlist/gfwlist)是一个整理被墙的域名)，对于list外还需要走代理通道的域名可以添加到用户规则的文件中。

+ 配置文件

> gui-config.json

> pac.txt  //gfwlist的list

> user-rule.txt  //用户规则文件

除此之外，还可以在本机上再开一个http端口，供走http协议的连接从代理通道走(当然也可以给其他设备进行连接)。比如为npm设置代理

``` bash
http-proxy=http://192.168.99.200:1080
https-proxy=http://192.168.99.200:1080
```

## 开启加速
市面上的提速方案包含有[kcptun](https://github.com/shadowsocks/kcptun),速锐,bbr等。其中kcptun是双边加速方案，需要server端和client端均做加速处理，比较繁琐。单边加速方案中速锐时以多重发包的方式来提速，bbr则是从tcp算法上来提速。速锐重量有害，bbr轻量无害。所以下面以bbr方案为准。

开启bbr首先需要确保linux内核为4.9+,先检查内核版本

```bash
$uname -r
```

在/etc/sysctl.conf文件中添加下面字段

```bash
$vi /etc/sysctl.conf

net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```

使配置生效

```bash
$sysctl --system
```

查看是否设置成功

``` bash
$sysctl net.ipv4.tcp_available_congestion_control
$sysctl net.ipv4.tcp_congestion_control
```

最后查看bbr是否开启,如果有看到bbr字样的进程则表示已开启

``` bash
$lsmod | grep bbr
```
