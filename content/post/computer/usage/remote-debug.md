---
title: "Tomcat的远程调试"
date: 2017-12-30T15:50:40+08:00
tags: ["computer", "usage"]
---
结合idea使用Tomcat的远程调试功能
<!--more-->

## 准备工作
开始之前，需要准备一个可供调试的web项目部署到非本机的Tomcat中运行。
首先，创建一个十分简单的web项目。该项目基于spring，除了基本的spring配置之外，只包含有一个controller可供调试

``` java
@Controller
public class HomeCtrl {
    @RequestMapping(value = "home", method = GET)
    public String home() {
        int a = 123;
        return "home";
    }
}
```

然后将该项目打包后

``` bash
$mvn package #生成remote.war
```

接下来部署到远端的Tomcat内，部署时一切按照Tomcat默认的方式进行，webapps内的目录结构如下

> webapps

>  -- docs

>  -- manager

>  -- remote.war #打包后的项目

到此准备工作就完成了。

## 配置调试
如果要实现远程调试，需要适当的配置远端的Tomcat服务器，以及本机调试的ide。这里使用idea，eclipse的配置大致相同。

### 配置Tomcat
Tomcat的远程调试功能是借助JPDA(Java Platform Debugger Architecture)实现的，在开启Tomcat服务时，只需要开启该功能即可。要开启该功能，需要实用bin/catalina.sh脚本进行启动，而不是实用平常的startup.sh脚本。下面实例中启动了一个调试端口默认为8000的Tomcat实例,通过该端口就可以进行远程调试了。

``` bash
$ cd ${TOMCAT_HOME}/bin/catalina.sh jpda start
```

JPDA还可以配置三个参数，分别都有如下作用
> JPDA_TRANSPORT：指定传输协议

> JPDA_ADDRESS：指定调试端口

> JPDA_SUSPEND：是否在JVM启动后就立即挂起

如何配置这三个参数呢？通过查看catalina.sh脚本可以发现，启动时会查找这三个变量。如果有则直接使用这三个变量的值来指定，如果没有则使用默认值来指定。

``` bash
$ vi catalina.sh

if [ "$1" = "jpda" ] ; then
  if [ -z "$JPDA_TRANSPORT" ]; then
    JPDA_TRANSPORT="dt_socket"
  fi
  if [ -z "$JPDA_ADDRESS" ]; then
    JPDA_ADDRESS="8000"
  fi
  if [ -z "$JPDA_SUSPEND" ]; then
    JPDA_SUSPEND="n"
  fi
  if [ -z "$JPDA_OPTS" ]; then
    JPDA_OPTS="-agentlib:jdwp=transport=$JPDA_TRANSPORT,address=$JPDA_ADDRESS,server=y,suspend=$JPDA_SUSPEND"
  fi
  CATALINA_OPTS="$JPDA_OPTS $CATALINA_OPTS"
  shift
fi
```

所以，如果要配置这三个值十分简单，可以配置环境变量，也可以在文件内配置局部变量。

``` bash
$ vi catalina.sh

# 添加这三个变量
JPDA_TRANSPORT=dt_socket
JPDA_ADDRESS=8001
JPAD_SUSPEND=n
```

### 配置ide
本地ide配置时，首先选择建立一个remote调试
![](/assets/img/use/remote01.png)

然后填写调试参数，包含有该remote调试实例的名称，地址信息，要调试的项目
![](/assets/img/use/remote02.png)

完成后以debug模式开启该调试实例，开启后如出现如下提示则表示调试链接已经建好了。

``` bash
Connected to the target VM, address: '192.168.99.202:8000', transport: 'socket'
```

## 备注说明
### 使用调试
调试时在本地项目的代码上打上断点，如果远程的Tomcat实例运行到断点位置时，则会挂起JVM。本地ida上也会同时进入debug状态。

### 关于端口
远端Tomcat在开启JPDA时会有两个端口，第一个是http服务端口，另一个是调试端口。这里不能混淆。比如上面例子中，http服务端口是8080,而调试端口则是8000

### 流程示意图

![](/assets/img/use/remote03.png)
