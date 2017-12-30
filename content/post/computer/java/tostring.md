---
title: "toString的无限递归"
date: 2017-12-30T16:59:09+08:00
tags: ["computer", "java"]
---
...
<!--more-->

## 问题描述
在Java编程思想的字符串篇章里面，看到一个有点意思的问题。下面这段代码中有一个普通的Test类，该类包含一个toString()方法。如果调用这个toString()会输出什么结果呢？如果调用则会抛出"java.lang.StackOverflowError"异常。

``` java
public class Test{
    private String info;
    public String toString() {
        return "test - " + this;
    }
}
```

## 问题解析
造成上面问题的根本原因是"+"操作符。作为唯二的两个重载操作符，如果使用该操作符连接字符和任意类型实例则会将实例先转换成字符。上面的操作过程等价于下面代码

``` java
return new StringBuilder().append("test - ").append(this).toString();
```

在执行append(this)时，该方法会调用实例的toString()。这样就会形成无限递归。

``` java
// StringBuilder.append(Object obj)
public AbstractStringBuilder append(Object obj) {
    return append(String.valueOf(obj));
}
// String.valueOf(Object obj)
public static String valueOf(Object obj) {
    return (obj == null) ? "null" : obj.toString();
}
```
