---
title: "类加载-(1)类加载器"
date: 2017-12-30T16:43:16+08:00
tags: ["computer", "java"]
---
探究Java的类加载器
<!--more-->

一般来说，Java虚拟机使用Java类的方式如下：Java源程序（.java文件）在经过Java编译器编译之后就被转换成Java字节代码（.class文件）。类加载器负责读取Java字节代码，并转换成java.lang.Class类的一个实例。每个这样的实例用来表示一个Java类。通过此实例的newInstance()方法就可以创建出该类的一个对象。类加载器（class loader）用来加载 Java 类到 Java 虚拟机中。

### 类加载器组织结构
Java 中的类加载器大致可以分成两类，一类是系统提供的，另外一类则是由 Java 应用开发人员编写的。系统提供的类加载器主要有下面三个

+ 引导类加载器（bootstrap class loader）：它用来加载 Java 的核心库，是用原生代码来实现的，并不继承自 java.lang.ClassLoader。
+ 扩展类加载器（extensions class loader）：它用来加载 Java 的扩展库。Java 虚拟机的实现会提供一个扩展库目录。该类加载器在此目录里面查找并加载 Java 类。
+ 系统类加载器（system class loader）：它根据 Java 应用的类路径（CLASSPATH）来加载 Java 类。一般来说，Java 应用的类都是由它来完成加载的。可以通过 ClassLoader.getSystemClassLoader()来获取它。

除了系统提供的类加载器以外，开发人员可以通过继承 java.lang.ClassLoader类的方式实现自己的类加载器，以满足一些特殊的需求

### 类加载器的代理机制
类加载器之间存在这一种上下层关系，这种关系不是通过继承体系来实现的，是通过简单的组合实现的。下层的类加载器可以通过getParent()来获取到其相邻上层的类加载器引用。层次顺序从上到下依次是引导类加载器->扩展类加载器->系统类加载器->自定义加载器。

![](/assets/img/java/javase/classload01.png)

基于这种层次性的类加载器，在Java程序启动时各个类加载器会先加载使用到的类。当程序运行时，需要使用到新类则需要使用类加载器加载新类。那到底该使用哪个加载器执行加载呢？
整个加载过程是这样的，当前加载器会通过getParent()获取上层加载器，先尝试上层加载器是否能加载需求的类，而上层的加载器又会尝试其上层的加载器是否能加载需求的类。依次类推，最终会先使用bootstrap classloader检查,如果有则执行加载操作，反之则会使用extensions classloader检查。以这种机制依次调用下层的classloader检查，如果最后没有classloader能查找到需求的类的字节码，则抛出ClassNotFoundException。

### 代理机制带来的安全
这种机制保证了jdk以及classpath设置的字节码不受恶意替换。比如在程序中添加一个自定义的java.lang.String类，通过在该类内植入各种恶意操作来达到蓄意破坏的目的。在这种机制的保护下，无论程序内怎么使用java.lang.String都会使用bootstrap classloader在jdk中加载的java.lang.String。

``` java
public class String{
    public String() {
        System.out.println("other string");
    }
    public static void main(String[] args) {
        String string = new String(); // nothing
    }
}
```

除了保护系统级别的类加载器所加载的class不受恶意替换外，还保护系统级的类加载器所加载的类所在的包。比如在外部声明一个java.lang的包，再在该包内声明一个类，将这个类伪装成jdk提供的一个类。这样的操作也会被jvm所察觉。在加载过程中，如果在自定义的加载器内加载系统提供的类加载器已经加载过的包则会抛出异常。也就是说像java.lang这里在bootstrap classloader中加载过的包，在下层的类加载器中都不允许再加载了，即使是在bootstrap中没有找到需要的类。

``` java
package java.lang;
public class Str{
    public Str() {
        System.out.println("str class");
    }
    public static void main(String[] args) {
        Str str = new Str();
    }
}
```
``` bash
// throw exception
Exception in thread "main" java.lang.SecurityException: Prohibited package name: java.lang
```

### 类加载的时机
在Java程序运行时，只有在使用类的静态成员或者实例成员时才会加载类。在下面两种情况下并不会加载类

+ 使用static final的类成员，这种成员实际上是编译时常量。
+ 创建类的Class实例时也不会加载类

``` java
public class Test {
    public static final int num = 3;
    static {
        System.out.print("test load");
    }
}
// use
Class test = Test.class; 
int num = Test.num;
```