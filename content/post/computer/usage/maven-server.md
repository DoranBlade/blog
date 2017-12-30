---
title: "maven server搭建"
date: 2017-12-30T16:05:05+08:00
tags: ["computer", "usage"]
---
Linux下搭建maven私服
<!--more-->

## 搭建准备
[Nexus Repository OSS](https://www.sonatype.com/download-oss-sonatype)是一个免费的Repository管理工具，可以管理npm,maven,Bower,PyPL等各种Repository。现在有两个版本2.x和3.x，这两个版本所支持的Repository也不相同，应该根据自己需要搭建的Repository来选择版本。这里需要搭建的maven所以只能选择2.x版本。
安装该工具十分简单，download后解压即可。解压后包含有两个目录

+ nexus-xxx目录是我们需要操作的目录，包含有Nexus的启动脚本，依赖jar等
+ sonatype-work目录为Nexus的配置文件，仓库文件等不需要我们去操作的文件。

工具的启动脚本为nexus-xxx/bin/nexus,如下可启动该工具

``` bash
$cd nexus-xxx/bin
$./nexus start
```

启动后可通过http://localhost:8081/nexus 访问管理工具。

## 使用工具
连接nexus服务后，首先进行登录操作(默认账号密码为admin/admin123)。之后进行Repository操作

![](/assets/img/use/maven01.png)

### 建立仓库

仓库分为如下几种类型

> hosted：本地建立的仓库

> proxy：代理其他maven仓库

> group：组合其他仓库，到这个仓库搜索组件时会到其包含的其他仓库中查找。

所以，仓库的组成上应该是一个或者多个proxy连接其他的maven仓库，比如aliyun,或者maven默认的中央仓库。一个Snapshots的hosted仓库保存Snapshots版本的maven组件，一个Releases的hosted仓库保存Releases版本的组件。最后将这些仓库包含到一个public的group仓库中

![](/assets/img/use/maven02.png)

### 使用仓库
建立好仓库后，每个仓库都会有一个url地址，通过这个url client端就可以从该仓库中下载所需要的组件了。按照上面建立仓库的架构，client端使用public这个仓库就可以即可。下面设置client的maven配置文件

``` xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" >
  <!-- ... -->
  <mirrors>
     <mirror>
       <id>nexus-local</id>
       <mirrorOf>*</mirrorOf>
       <name>Nexus local</name>
       <url>http://192.168.99.202:8081/nexus/content/groups/public/</url>
    </mirror>
</settings>
```

发布maven构件到仓库有两种方式，一种是在浏览器端通过管理工具手动上传到指定的仓库中，另外一种是通过mvn命令自动发布。通过管理工具上传到仓库比较适合那些在中央仓库中找不到的第三方jar包，都是图形操作，这里不在描述。通过mvn命令发布需要配置两个地方，首先是maven项目内的pom文件内添加远程仓库信息

``` xml
<project>
  <distributionManagement>
      <repository>
          <id>nexus-releases</id>
          <name>Nexus Releases Repository</name>
          <url>http://192.168.99.202:8081/nexus/content/repositories/releases/</url>
      </repository>
      <snapshotRepository>
          <id>nexus-snapshots</id>
          <name>Nexus Snapshots Repository</name>
          <url>http://192.168.99.202:8081/nexus/content/repositories/snapshots/</url>
      </snapshotRepository>
  </distributionManagement>
</project>
```

远程仓库对于匿名用户都是只读的，所以还需配置远程仓库具备写权限的账户。该配置通过maven的全局配置文件来实现，在文件内添加与pom中远程仓库想对应的账户信息

``` xml
<servers>
  <server>
    <id>nexus-releases</id>
    <username>admin</username>
    <password>admin123</password>
  </server>
  <server>
    <id>nexus-snapshots</id>
    <username>admin</username>
    <password>admin123</password>
  </server>
</servers>
```

配置好后就可以通过mvn命令发布了,之后就可以通过管理工具在对应的仓库中查看到发布的构件了。

``` bash
$mvn clean deploy
```

有一个地方需要说明，项目内的pom内通过version坐标来确定项目现在的版本状态，含有SNAPSHOT字样则为测试版本，含有RELEASES字样则为正式版本。相对应的maven也会以此选择是发布到snapshots仓库还是releases仓库。

