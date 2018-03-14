---
title: "Memery"
date: 2018-03-14T18:36:01+08:00
tags: ["computer", "java"]
---

<!--more-->

## 内存分布
Java运行时的数据主要分布在五个位置

+ 寄存器：存储当前运行代码中的一些变量，如方法入参，方法返回值
+ 当前线程调用栈：存储当前线程的调用信息，每一个方法的调用都会在栈内生成一个栈帧，每个栈帧内保存该调用函数内的变量，程序计数器等
+ 堆：整个jvm内都只会存在一个内存堆，所有的线程都共用这个内存堆。所有对象的实例都会保存在这个堆中，实例在堆内都是以无序方式保存
+ 静态域：保存声明的所有静态数据
+ 常量池：保存声明的所有常量数据，字符串字面量和final的实例，该区域内的数据均为不可变

![](/assets/img/java/img006.png)

通过下面的简单代码，分析一下内存分布情况。

``` java
public class Test {

    public static void main(String[] args) {
        int a = 10;
        int b = 22;
        Test test = new Test();
        int res = test.add(a, b);
    }

    public int add(int a, int b) {
        int c = a + b;
        return c;
    }
}
```

例子中程序运行后会创建一个线程，线程首先执行main方法，这个时候应该在该调用栈中push进main函数的栈帧。然后依次执行接下来的三个声明语句，在main的栈帧内创建这三个变量。由于test是引用变量，该test变量指向在堆内存中创建的test实例。

![](/assets/img/java/img007.png)

继续执行test实例的add方法调用，在调用栈中push进add函数的栈帧。add函数内的入参a,b以及返回值都会保存到寄存器内(以c语言作为判断依据),所以add函数的栈帧内什么变量也不会创建。add函数执行完成后，add函数的执行结果保存到寄存器内。

![](/assets/img/java/img008.png)

然后add函数的栈帧出栈，继续回到main函数的栈帧中执行。接下来在main栈帧内创建res变量，然后将保存add函数执行结果的寄存器的值赋值给res变量。最后main函数也执行完成，main函数栈帧也出栈。

![](/assets/img/java/img009.png)

另外的静态域和常量池就比较明显了,执行如下代码会分别在静态域和常量池内分别创建month变量和city变量

``` java
public class Test {
    
    public static int month = 10;
    public String city = "sz";
}
```



