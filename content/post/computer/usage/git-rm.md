---
title: "git-撤销操作"
date: 2017-12-30T16:16:48+08:00
tags: ["computer", "usage"]
---
使用git撤销操作
<!--more-->

## 从workspace撤销
在当前版本下进行一些修改后，如果没有添加进index库中则可以使用checkout filename来恢复到版本库状态

``` bash
$git checkout --a.txt
```

如果需要整个workspace撤销的话，则可借助stash库。先将所有操作添加进stash库，然后clear掉整个stash库。

``` bash
$git stash
$git stash clear
```

## 从index撤销
如果将不需要的操作添加进了index库，需要将其从index库中撤销的话，第一种方式是使用rm命令

``` bash
$git add b.txt
$git rm --cached b.txt
```

第二种是使用reset HEAD

``` bash
$git add b.txt
# 撤销出index
$git resset HEAD b.txt
```

## 从local repository撤销
从local repository中撤销的话有两种实现，第一种是重新提交一个版本进行覆盖。

``` bash
$git commit -m"覆盖" --amend
```

另外一种需要使用分支的回退功能，将分支回退到上一个版本号。

``` bash
$git reset --hard fe2fdijfiejf3212
```

在分支线上其实并不能将版本从分支中移除，回退后分支的最末端其实还是那个想要被撤销的版本号。之所以能实现撤销版本号的功能，是因为下次提交时会在分支线上分叉，形成另外一个末端。
![](/assets/img/tool/git/02.png)