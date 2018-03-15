---
title: "为什么合集"
date: 2018-03-15T22:36:49+08:00
tags: ["computer", "java"]
---
各种语法规则的解释
<!--more-->

## 返回值不能重载

java的方法重载只会依据参数列表，当参数类型，参数序列，参数数量不一致时都可实现重载。

``` java
public class Test {

    public void f1(int a){}
    public void f1(String s){}
}
```

作为方法组成部分的返回值不能作为重载依据，原因在于函数调用时是可以丢弃掉方法返回值的。如果是这种情况，编译器就不能判断到底该绑定到哪个方法了。

``` java
public class Test {

    public void f1(String a){}
    public String f1(String a){}

    public static void main(String[] args) {
        new Test().f1("str");
    }
}
```

## 成员变量自动初始化，局部变量需要手动初始化
在类型实例化的时候，jvm会为成员变量赋值默认值。而在方法调用时，方法内的局部变量需要手动初始化后才能使用。如果成员变量需要手动初始化后才能使用，那么类型的声明者无论声明什么值都不能适用在各种情况下创建的实例。最终还是需要对成员重新赋值。所以赋予一个初始的默认值时最合理的。

``` java
public class Test {
    int name = "tom";
    
    public static void main(String[] args) {
        Test t1 = new Test();
        Test t2 = new Test();
        t1.name = "naturn";
        t2.name = "display";
    }
}
```

在函数执行时，函数内定义的局部变量肯定有它预期的初始值。如果jvm为其初始化默认值，而不是在编译时提示出来的话。可能会掩盖掉程序员由于疏忽导致没有为局部变量设置预期的初始值，这样会增加程序的bug。

