---
title: "加载和初始化"
date: 2018-03-17T22:33:04+08:00
tags: ["computer", "java"]
---

<!--more-->

## 加载
Java的类都是封装在一个独立的文件类，Java程序在启动之后，并不会马上加载所有的类型。在程序运行到需要某个类型的时候才会由jvm动态加载。加载类型的时机有多个，比如创建该类型的实例，调用该类型的静态域，反射类型等。可以理解为代码中出现了某个类型，而程序运行到这里时就会去加载。

## 初始化
类型加载过程中，会对类型的静态域做初始化。这个初始化只会在类型加载时触发一次。整个程序的运行周期内，一个类型也只会加载一次，所以在程序运行周期内静态域只会初始化一次。

初始化类型的静态域后，就可以使用类型创建实例了。实例的初始化过程是先声明变量，如果在声明时有指定初始值则赋予该初始值。随后进入构造器内进行构造器内的初始化操作。

``` java
public class Person {
    public static String TAG = "person"; // 1 初始化TAG变量到jvm的静态域
    public String name = "default"; // 2 初始化name成员变量
    public Person(String name) {
        this.name = name; // 3 构造器内初始化
    }
}
public class Run {
    public static void main(String[] args) {
        System.out.println(Person.TAG); // 开始加载Person.class
        Person person = new Person();
    }
}
```

如果类型还有父类，则需要先初始化父类。在程序运行时需要加载子类类型，首先回去加载父类类型并初始化父类的静态域，然后才会加载子类并初始化子类的静态域。在使用子类类型创建实例的时候，需要先使用父类类型创建一个父类实例，并对父类实例做初始化处理。然后才会创建子类实例，对子类实例做初始化处理。

``` java
public class Person {
    public static String TAG = "person"; // 1 初始化父类静态域
    public String name = "default"; // 3 父类成员变量初始化
    public Person(String name) {
        this.name = name; // 4 父类构造器初始化
    }
}
public class Study extends Person {
    public static String TAG = "study"; // 2 初始化子类静态域
    public String school = "default"; // 5 子类成员初始化
    public Study(String school) {
        this.school = school; // 6 子类构造器初始化
    }
}
```


