---
title: "git-文件系统"
date: 2017-12-30T16:18:49+08:00
tags: ["computer", "usage"]
---
探究git的文件系统
<!--more-->

## 文件系统的组成
git文件系统由五个部分组成，每个部分代表着一个区域，各自保存着各个阶段的文件。

![](/assets/img/tool/git/01.png)

### workspace
我们在一个目录内使用git init新建一个git仓库，这个目录就作为workspace。我们所进行的文件操作均是在workspace中进行，完成后再提交到其他区域中。

SVN版本库都是基于文件系统，在使用SVN时提交的文件在SVN所管理的版本库内都是可以直接查看的。相比较而言git在这方面就会存在较大差异。我们新建一个git仓库时，会在目录内建立一个.git目录。像stash,index,local repository都会在该目录内，统一由git进行管理。存储在这些仓库中的文件都是经过git处理了的，并不能给用户直接使用。个人觉得git的workspace的另外一个意义是取出版本库中经过处理了的文件，这样用户才能使用。

### stash
stash库主要作为一个临时仓库使用，存入该仓库的文件操作并不纳入版本控制内。比如在当前版本上，你做出一个操作后，此时你需要切换到其他分支上去。这种情况下你有两种选择，一种是将操作commit到local repository中形成版本号。如果这次操作还不适合形成一个版本号，则可以使用第二种方式，即添加到stash库内。

将操作添加到stash后，workspace(项目目录)内文件保持与当前版本库一致。如果有需要再将stash库内操作取出时，这些操作都会应用到workspace文件内。例如下面有个文件，对其进行修改。

``` bash
$vi a.txt
# 之前文本
aaaaa
# 添加新文本
add some word
```

下面将修改操作添加到stash库，文本会保持之前状态。

``` bash
$git stash
$vi a.txt
# 之前文本
aaaaa
```

最后把修改操作从stash库中取出后，操作结果会应用到对应文件上。

``` bash
$git stash pop
$vi a.txt
# 之前文本
aaaaa
# 添加新文本
add some word
```

### index
index仓库暂时缓存workspace中的文件操作，在一个合适的时机统一将文件操作commit到local repository中形成版本号。

``` bash
$git add a.txt
```

### local repository
local repository内保存着的是本地形成版本号的所有文件操作，这也是git相较于svn先进的地方。使用svn时如果需要形成版本必须是commit到svn服务器上，而git则可以直接在本地形成版本，等到可以连接git服务器时再一起commit上去

``` bash
$git commit -m"add a.txt"
```

### remote repository
remote repository就是svn的服务器。代码的统一管理，统一分发
