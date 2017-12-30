---
title: "字符串的拼接"
date: 2017-12-30T16:55:32+08:00
tags: ["computer", "java"]
---
...
<!--more-->

## 重载操作符和StringBuilder
在Java中String是不可变的，表面上对String修改操作都能正常进行，实际上都是新生成了String对象来替代。对字符经常会进行拼接操作，一般情况下两种方式。第一种是使用Java提供的重载操作符"+",第二种是使用StringBuilder/StringBuffer。

``` java
String a = "hello";
String b = "world";
String c = a + b;
String d = new StringBuilder().append(a).append(b).toString();
```

从语言层面上看，使用重载操作符进行操作简洁，可读性也好。使用StringBuilder进行操作的话，需要键入更多的内容。人肯定是喜欢使用重载字符串这种方式，不然Java官方也不会特意提供这仅有的两个重载操作符。存在即合理，下面来分析分析两者在性能上的区别。

## 重载操作符的实现
两个操作符"+"和"+="在进行字符拼接的时候，在内部其实都是要使用StringBuilder这个对象进行包装处理的。比如"a + b"这种操作，实际上是通过一个临时的StringBuilder对象逐个执行append操作

``` java
String a = "hello";
String b = "world";
a + b;
// 等价于
new StringBuilder().append(a).append(b);
```

最后表达式需要进行求值的时候，StringBuilder对象再通过toString()返回结果。

``` java
String c = a + b;
// 等价于
String b = new StringBuilder().append(a).append(b).toString;
```

这样看，其实使用操作符和使用StringBuilder是没有什么差别的，内部实现都是一致的。那么就可以都这样吗？

## 重载操作符不适应的情况
``` java
public String implicit(String[] strs) {
    String result = "";
    for(int i = 0; i < strs.length; i++) {
        result += strs[i];
    }
    return result;
}
```

``` java
public String explicit(String[] strs) {
    StringBuilder result = "";
    for(int i = 0; i < strs.length; i++) {
        result.append(strs[i]);
    }
    return result;
}
```

上面两段实例中，第一段使用重载操作符来实现拼接，第二段使用StringBuilder实现拼接。第一段每次循环时都需要创建一个StringBuilder对象，求值后使用toString返回结果，最后再销毁该对象。相比较第二段而言就会有更多的性能消耗

## 结论
如果只是一次的拼接求值，用重载操作符和StringBuilder没有什么差异。如果是多次的拼接求值，则使用StringBuilder对象更好。
