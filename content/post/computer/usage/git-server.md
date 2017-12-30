---
title: "git-server搭建"
date: 2017-12-30T16:12:42+08:00
tags: ["computer", "usage"]
---
linux环境下搭建git server
<!--more-->

## 搭建gitserver
正常使用git时通常都需要有一个git远程仓库，用于代码的合并和管理。现在已经有商用方案，比如国外的github,国内的coding等。将重要的代码托管到其他公司的服务器上，均会有可能的安全隐患，如果有可能可以用自己内部搭建git服务。搭建git服务并不需要另外安装其他东西，只需要确保机器上安装有git即可。

### 建立远程仓库
在client端，如果要建立一个本地仓库，只需要键入如下命令即可

``` bash
$mkdir project.git
$cd project.git
$git init
```

建立可供其他人提交的远程仓库时，只需要在此基础上添加一个--bare参数即可。该命令会在所在目录内创建一个可以供他人使用的远程仓库，整个远程仓库的操作到此结束。(就会这么简单)

``` bash
$git init --bare
```

如果对于gitserver要求比较高，还可以使用集成的软件来进行管理，比如gitlab，gitosis等

## 使用git服务
上面在其他机器上建立了git远程仓库，接下来在client机器上使用git服务。

### 连接远程仓库
远程仓库通常使用ssh的方式连接，连接的url遵循这样的规则:**username@hostname:filepath**

+ username@hostname：与ssh连接地址一致
+ filepath：git远程仓库的所在文件位置，比如/home/test/git/test.git

``` bash
$git clone git@192.168.0.1:/home/test/git/project.git
```

上面这种方式每次连接都需要输入git服务所在机器的用户名和密码，而且多人使用时还可能需要配置多个账号。所以用秘钥的方式进行ssh连接是比较好的方式，比如将每个需要连接的用户的公钥部署到远程机器上。

## 基于git server的博客
github有一个page服务，通过一个包含静态页面的repository来托管一个静态页面。下面自行实现这样一个功能，本网站也是才用这种方式处理。

### 准备工作
首先，需要购买需要的东西-vps,域名，dns解析，以及开启http服务器。这些自行查看其他教程。完成的标准是能通过域名访问到vps上的http服务器。
其次，静态博客框架自行选择(本人选择的hexo)，生成所需要的静态页面。接下来开始处理本地静态页面到vps上http服务器的部署问题。

### 开始工作
首先，在vps建立一个用户保存静态页面的repository。

``` bash
$mkdir git/blog.git
$cd git/blog.git
$git init --bare
```

建立好repository后，将本地的静态页面push到这个repository中。接下来直接repository的目录托管到http服务器上就可以了吗？答案是不行，push到git repository中的数据都会转换，从目录内是看不到原始数据的。

> blog.git

> <cite>-- branches</cite>

> <cite>-- config</cite>

> <cite>-- hooks</cite>

那么就需要在vps上再建立一个git client将repository中的数据拿出来，然后再部署到http服务器上(通过软链接的方式)。现在就完成了整个部署过程，可以通过域名正常访问到部署上去的静态页面了。

``` bash
$mkdir git/blog
$cd git/blog
$git clone git/blog.git git/blog
```

### 改进
经过上面的操作后，虽然完成了部署操作。但是有一个问题，每次本地push后还需要连接到vps上手动把repository中把数据拿出来。下面借助git的hooks实现自动从repository拿数据的操作。
在repository目录内的hooks目录内包含可以定义许多的钩子脚本，在repository的某些操作后执行某些钩子脚本，比如接受到push数据后会执行名为post-receive的脚本。这样就可以把从repository中拿数据的操作定义到post-receive脚本内。

``` bash
blogTemp=~/git/blog
blogPath=~/git/blog.git

rm -rf ${blogTemp}
mkdir ${blogTemp}
git clone ${blogPath} ${blogTemp}
```
