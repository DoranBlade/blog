---
title: "idea与maven的编译和打包"
date: 2017-12-30T16:09:44+08:00
tags: ["computer", "usage"]
---
idea环境下maven项目的打包
<!--more-->


## 编译检查
java web项目开发中大都会引入第三方jar包，在管理这些jar上依开发流程大致分为三个部分。

第一个部分是ide的检查(均已intellij idea为例)，在idea上开发项目的过程中，idea会帮助检查整个项目中类库的使用情况，然后检查该工程已添加的jar依赖上是否能找到所需的类库。如果找不到则会提示出来，同样也不会让你运行项目。通过idea添加jar有两种方式

+ 一种是添加本地已经存在的jar，意思是告知idea这些jar包会在这个工程中使用到，请查找类库的时候一并查找这些jar包。
+ 另外一种通过maven等添加的jar包。
这两种方式添加的jar依赖在开发过程中的检查阶段并不会有差异，主要影响到打包阶段，这个后面再说。

在第一种添加本地jar的方法中也存在几种不一样的添加方法。

+ 第一种是在module中添加依赖，这样这个依赖就属于这个module(idea中module等价于一个项目，project等价于一个工程，project层次高于module)。
+ 第二种是在project的libraries中添加依赖，这种依赖是可以在该project内的所有module上使用
+ 第三种是在global libraries上添加依赖，顾名思义这种依赖项是可以在不同的project上使用。也就是全局性的jar libraries。

idea的工程目录内会有一个project-name.iml文件，该文件内记录这该工程jar包依赖项的详细信息。例如level就记录在该依赖的级别，属于module还是project。type标示着是module-library还是library(project)，或者global-library。

``` xml
<!-- project libraries -->
<orderEntry type="library" name="BASE64Decoder-1.0.0" level="project" />
<!-- module libraries -->
<orderEntry type="module-library">
    <library>
        <CLASSES>
            <root url="jar://$MODULE_DIR$/../parent/icar/target/icar/WEB-INF/lib/annotations-java5-15.0.jar!/" />
        </CLASSES>
    <JAVADOC />
    <SOURCES />
    </library>
</orderEntry>
```

这三种不同的依赖，有一种类似作用域链的机制，底层的依赖默认自动会集成上层的所有依赖项。这种机制可以让我们在jar包的适当的做一些分离，以减少一些工作量。比如模块内通用的包分离到project层级上。

再来说说通过maven方式导入jar依赖，这种方式是最简单的。maven导入的jar同样适用与第一种方式中的三种层次，默认情况下maven导入的jar都是属于project层次的。

``` xml
<orderEntry type="library" name="Maven: Mysql:mysql-connector-java:5.1.30" level="project" />
```

## 打包
无论是手动导入本地jar，还是适用maven自动导入jar，在导入后在编译检查阶段都不会有什么差异，真正会影响的是打包阶段。现在比较常见的两种打包方式一种是使用idea进行打包，另外一种是适用maven进行打包。这两种打包方式也同样存在一些差异。

在idea的默认设置中，maven添加的依赖会在打包时自动打包到web项目的lib目录内。而适用本地导入的jar包则默认不打包进lib，多数人(我见过的)采用的处理方式是在源码的WEB-INF/lib中添加一份这个jar，以弥补项目部署时jar的缺失。其实大可不必如此，只需要设置在打包时将本地导入的jar包导入lib目录即可，这样本地jar就跟maven导入的jar在打包阶段保持一致了。
![](/assets/img/use/idea01.png)

在工程目录的.idea/artifacts/目录的对应artifact项上，记录在该artifact的打包项。新添加的jar打包项会有如下节点记录

``` xml
<element id="library" level="project" name="Maven: org.apache.httpcomponents:httpmime:4.5.3" />
<element id="library" level="project" name="BASE64Decoder-1.0.0" />
```

使用maven打包的话，正常添加的依赖项都会打包到lib目录内，而一些本地的jar则需要添加对应的本地依赖项。另外在idea中添加的如web容器等运行时jar，也需要另外在maven中进行配置。

``` xml
<dependency>
    <groupId>aopalliance-1.0</groupId>
    <artifactId>aopalliance</artifactId>
    <scope>system</scope>
    <systemPath>/home/eric/aopalliance-1.0.jar</systemPath>
</dependency>
```

另外还有一点需要提及，在检查阶段是需要引入web容器这些运行时已经提供了的jar。这种情况下可以可以通过idea引入，也可以通过maven引入。这两种方式有一个细节需要留意，在maven中配置的运行时jar，idea是可以归其所用的，因为idea会导入所有的maven配置。在idea中配置的这些本地jar或者运行时jar，maven是不能使用的，需要另行配置。所以最优的方式是，都统一在maven中进行配置，这样无论是在idea中还是在maven中都是可以使用的。

