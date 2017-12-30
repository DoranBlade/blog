---
title: "Java的可变长度的参数"
date: 2017-12-30T16:51:03+08:00
tags: ["computer", "java"]
---
...
<!--more-->

java处理可变长度的参数有两种方式，第一种是使用数组，另外一种则是使用Javase5提供的可变长度参数。这种新添加的语法规则如下，在数据类型之后使用"..."标示，这样编译器在编译时则会将之当做一个可变长度的参数来处理。在方法被调用时，会将还未进行匹配的所有实参打包成一个数组传递给该可变长度的参数。方法内部则可以将之视为一个数据所使用。

``` java
public class Test{
    public void methods(String... args){
        int length = args.length;
        for (String str : args) {
            System.out.println(str);
        }
    }
    public void run(){
        methods("one", "two", "three");
    }
}
```

javase 5提供的这种可变长度数组在使用时有一定的限制,编译器在处理时将实参一一匹配给形参，匹配到可变长度的形参时则会将剩余的所有实参打包成一个数组传递给该可变长度的形参。如果可变长度形参之后还有其他形参则会永远都得不到实参的传入，所以Java在语法进一步做了规定:可变长度的参数必须时方法的最后一个形参。

``` java
public class Test{
    public void methods(String first, String... args) {
        // do something
    }
}
```

如果使用数组的方式实现可变长度的参数，则可以精准的控制实参的传递。个人觉得javase5所提供的可变长度参数仅仅是一种语法糖，带来的便利仅仅只是封装了将实参包装成数组这么一个步骤,牺牲的却是在语言上的灵活性，不是很具有性价比的操作。

``` java
public class Test{
    public void methods(String first, String[] args, String second){
        // do something
    }
}
```

