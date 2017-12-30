---
title: "作用域"
date: 2017-12-30T16:54:32+08:00
tags: ["computer", "java"]
---
...
<!--more-->

Java中scope是以花括号作为分界点，一个花括号内作为一个作用域。作用域内的变量不能在作用域外部使用，也不会影响到外部作用域的变量。

``` java
public class Scope{
    public void mehtods() {
        for (int i = 0; i < 5; i++) {
            System.out.println(i); // print 0,1,2,3,4
        }
        for (int i = 0; i< 5; i++) {
            System.out.println(i); // print 0,1,2,3,4
        }
    }
}
```

在一个作用域包含另外一个作用域时，就会形成一个作用域链。子作用域拥有访问父作用域的权限，而父作用域没有访问子作用域的权限。

``` java
public class Scope{
    public void mehtods() {
        for (int i = 0; i < 5; i++) {
            System.out.println(i); // print 0,1,2,3,4
            for (int j = 0; j < 5; j++) {
                System.out.println(j); /// print 0,1,2,3,4
                System.out.println(i); // print 0*5,1*5,2*5,3*5,4*5
            }
        }
    }
}
```

在js中搜索变量是依照作用域进行搜索，先搜索当前作用域是否存在，如果存在则使用。否则在父作用域中搜索，依次搜索到global作用域。Java与js存在一些差别，Java不能在当前作用域中声明上层作用域已经声明过的变量。

``` java
public class Scope{
    public void mehtods() {
        for (int i = 0; i < 5; i++) {
            System.out.println(i); // print 0,1,2,3,4
            for (int i = 0; i < 5; i++) {} // i already defined in scope
        }
    }
}
```

除了在对象内部形成的作用域链外，在对象于对象之间还可以形成作用域链。在类内部声明的内部类，内部类实例的作用域链上层是与其关联的宿主类实例的作用域。内部类实例可通过作用域链访问宿主类实例的成员，Java中使用闭包均是通过内部类这种方式所实现。

``` java
public class Host {
    private String host;
    public Host() {
        this.host = "host";
    }
    public class Sub{
        public void print() {
            System.out.println(host);
        }
    }
}
```

另外，通过继承机制形成的父类子类关系，子类实例能访问到父类实例public和product两种权限下的成员。这种关系看似是形成了一种作用域链，其实并不是。子类实例都会有一个与之关联的父类实例，子类能获取父类成员也是通过父类实例去调用的。这也解释了子类只能访问父类两种权限下的成员，而不是private权限下的成员。

``` java
// 父类
public class Car{
    private String name;
    public Car(String name) {
        this.name = name;
    }
}
// 子类
public class Taxi{
    public String company;
    public Taxi(String name, String company) {
        super(name);
        this.company = company;
    }
}
// 调用
Taxi taxi = new Taxi("car", "didi");
taxi.name; // error
```
