---
title: "git-提交和拉取"
date: 2017-12-30T16:20:32+08:00
tags: ["computer", "usage"]
---
使用git pull和push操作
<!--more-->

## 提交流程
以git的仓库为单位的话，git的提交流程大致如下
![](/assets/img/tool/git/03.png)

### workspace与stash
workspace存储到stash中可使用如下命令

``` bash
$git stash save "message"
```

从stash中恢复可使用如下命令

``` bash
$git stash pop
```

### workspace到index
workspace提交到index可使用如下命令

``` bash
# 提交单个文件
$git add a.txt
# 提交所有文件
$git add -A
```

### index到local repository
index提交local repository可使用如下命令

``` bash
# 新提交一个版本号
$git commit -m"commit message"
# 覆盖生成一个版本号
$git commit -m"commit message" --amend
```

### local repository到remote repository
local repository到remote repository可使用如下命令

``` bash
# 添加远程库
$git remote add origin [remote repository url]
# 提交到origin远程库的master分支
$git push origin master
```

## 拉取流程

### 从remote repository
在本地还没对应的git仓库时，最好的方式是使用clone命令。该命令会同时在本地新建git仓库和拉取远程仓库的文件

``` bash
$git clone https://url
```

在本地已有对应git仓库的情况下，使用fetch命令会使local repository与remote repository同步。而pull则先执行local repository与remote repository同步,然后执行local repository和work space同步

``` bash
$git fetch origin master
$git pull origin master
```

### 从local repository
从local repository拉取数据是比较少见的情况，因为local repository的数据本来就是从workspace中提交上去的。只有两种情况会有需要从local repository中拉取数据，一种是使用fetch从remote repository中拉取了数据，另外一种是需要撤销workspace。

``` bash
$git reset --hard fe2fdijfiejf3212
```
