---
title: "类型系统的单根结构"
date: 2018-03-13T09:46:06+08:00
tags: ["computer", "java"]
---

...
<!--more-->

Java的类型系统中，所有类型都有一个根类-Object。该类的存在有三个方面的意义。

第一个意义是为所有类型添加基础的接口，这样可以减少很多基础功能的编写量。常用的接口如equal(), toString()。

``` java
public class Test {
    public static void main(String[] args) {
        Object object = new Object();
        object.toString();
        Integer integer = 10;
        integer.toString();
    }
}
```

第二个为所有的类型实现一个最基础的通信方式。任何类型都可以向上转型到Object类型上。

``` java
public class Test {
    public static void main(String[] args) {
        Integer integer = 10;
        String res = convert(integer);
    }

    private String convert(Object obj) {
        return obj.toString();
    }
}
```

第三个作用是第一个作用的一种延伸，Java的类型实例的创建和销毁都是完全托管的。在基类上实现了实例的创建和销毁接口后，jvm可以用一种通用的方式处理所有对象的管理。

``` java

public class Test {
    public static void main(String[] args) {
        Integer integer = 10;
        integer.finalize();
    }
}
```
