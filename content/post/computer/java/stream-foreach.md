---
title: "stream必须引用final变量猜想"
date: 2018-01-04T23:05:58+08:00
tags: ["computer", "java"]
---

...
<!--more-->

在使用Java8提供的stream时，如果在处理流程中使用了上层作用域内的变量，则该变量在处理流程中不能进行修改。意味着在stream处理流程的各个作用域中，引用的变量都是等价于常量。

下面例子中，在forEach流程中引用了所在作用域的temp变量。如果试图对其进行修改，则无法通过编译。

``` java
String temp = "";
List<User> users = new ArrayList<>();
users.stream().forEach(user -> {
    if (user.getId().equals(temp)) {
        temp += "*";
    }
});
```

stream相对于传统的遍历处理，提供了并发支持。Java中的并发都是基于线程来实现。在stream处理流程中应该是通过多个线程来加速流程处理，这个时候如果修改每个线程中都引用的公共变量则肯定会导致数据错乱。

如果Java在stream中提供对这种公共变量修改的支持，则肯定需要引入锁等操作，那么stream()就会有性能上的问题。

