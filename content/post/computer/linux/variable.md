---
title: "变量"
date: 2017-12-30T15:34:53+08:00
tags: ["computer", "linux"]
---

linux系统中的shell变量
<!--more-->

今天在Java中使用到System.getenv()获取系统的环境变量来拼接静态资源的路径，这样在可以根据不同的运行环境在不需要修改代码的情况下生成不同的静态资源路径。开发机的环境变量是设置在~/.bashrc文件内的，在使用idea调试时发现怎么也获取不到对应的环境变量，但可以获取同样在~/.bashrc文件中设置的JAVA_HOME环境变量。同样将项目打包部署到tomcat容器内通过tomcat来运行时又没有问题。

初步分析可能是idea在调试项目时使用的root身份，获取不到设置在具体用户上的环境变量。最后将环境变量转移到全局上后，在idea中调试时也能正常获取到对应的环境变量了。

以此为背景好好整理下linux变量相关的知识

## shell的变量
在使用shell时可以定义变量，定义时以name=value语法。

``` bash
# terminal--
$ name=tom
# sh file--
#!/bin/bash
name=tom
```

变量定义好了后，可以通过$name或者${name}读取变量的值

``` bash
# terminal--
$ name=tom
$echo ${name} // tom
# sh file--
#!/bin/bash
name=tom
echo ${name}  // tom
```

## shell的环境变量
上面定义的shell变量都只能在当前shell中使用，在其他的shell中并不能使用。如果要在其他的shell下都能使用，则需要将变量设置成环境变量。环境变量的定义和使用跟普通的shell一样，只需要使用export将其导出即可。

``` bash
$touch var.sh
$vim var.sh
# var.sh中键入
#!/bin/bash
export name=tom
：wq

$source var.sh
$echo $name
```

在开发时编程语言或者工具会需要设定某个环境变量，也是采用这种方式设置环境变量。比如jdk的JAVA_HOME,tomcat的CATALINA_HOME

``` bash
$vim ~/.bashrc

...
export JAVA_HOME=/usr/local/lib/jdk
export CATALINA_HOME/usr/local/apache-tomcat
```

## 不同位置的环境变量
Linux中的环境变量有三种不同的作用域，每个作用域内定义的环境变量适用的范围不一样。

### 全局环境变量
这种作用域内定义的环境变量可以在系统内的任意shell中使用，通过/etc/profile文件内定义。系统在启动时会自动运行/etc/profile文件，可以在该文件内直接定义环境变量(最好不要这么做)。

``` bash
$sudo vim /etc/profile
...
export name=tom
```

除此之外，查看/etc/profile文件会发现，运行该文件时会自动遍历/etc/profile.d目录内的所有.sh脚本。我们可以在该目录内新建脚本，通过自定义的脚本来添加环境变量。

``` bash
$sudo touch /etc/profile.d/env.sh
$sudo vim /etc/profile.d/env.sh
#!/bin/bash
export name=tom
```

### 用户环境变量
具体用户内定义的环境变量只能具体登录下的shell内使用，通过用户的~/.profile文件内定义。当用户登录后，就会执行用户目录内的.profile文件。理论上可以直接在该文件内定义环境变量。

``` bash
$vim ~/.profile
...
export name=tom
```

同/etc/profile一样，同样不建议直接在该文件内直接修改。查看该文件，会发现该文件会调用用户目录内的一个.bashrc文件。

``` bash
$vim ~/.profile
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
```
那么，我们可以在该文件内定义环境变量。也可以模仿/etc/profile去遍历一个目录内的.sh文件。

``` bash
$vim ~/.bashrc
# 直接定义
export name=tom
# 遍历目录
if [ -d "$HOME/init.d" ]; then
    for i in $HOME/init.d/*.sh
    do
        . $i
    done
fi
```

### 临时环境变量
在某一个shell内定义的环境变量只能在当前shell内使用，在其他shell内都不能使用。这种方式是最没有使用价值的。

``` bash
$export name=tom
```


