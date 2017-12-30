---
title: "java多态实现的关键-动态绑定"
date: 2017-12-30T16:53:19+08:00
tags: ["computer", "java"]
---
...
<!--more-->

### 绑定
程序中方法作为一个代码块，主要处理逻辑实现。对于变量每个实例都有不同的状态，每个实例所包含的变量都是独立存在的。而对于方法则不是，相同类型的实例所调用的方法都是一样的，所以方法在内存中只需要保存一份就可以了。

在代码运行时，实例仅仅包含其内部的成员变量，并不包含有方法相关的信息。那使用该实例去调用在类型中定义的方法时又是如何操作的呢？答案是绑定，在某个阶段会将实例与相关的方法建立连接。

![](/assets/img/java/javase/method-binding/001.png)

#### 绑定方式
如果是面向过程编程的语言，则会使用前期绑定。在代码编译过程中就建立实例与方法的连接。另外一种则是后期绑定，需要在程序的运行时才建立实例与方法的连接。Java除了static和final之外的方法，默认都是采用后期绑定的方式连接方法。

![](/assets/img/java/javase/method-binding/002.png)

### 绑定实现动态
下面代码是一个实现多态的简单例子

``` java
public class Animal{
    public void print(){
        System.out.println("Animal");
    };
}
public class Cat extends Animal{
    public void print() {
        System.out.println("cat");
    }
}
public class Dog extends Animal{
    public void print() {
        System.out.println("dog");
    }
}
// use
Animal animal1 = new Cat();
Animal animal2 = new Dog();
animal1.print(); // cat
animal2.print();  // dog
```

如果是前期绑定策略的话，则在编译时animal1和animal2实例都会连接到Animal类定义的print()方法上。则在运行时都会调用Animal类中定义的print()方法。
如果是像Java这样采用后期绑定策略的话，则在运行时jvm通过检测animal1和animal2所引用的实例，通过一定的方法判定具体类型后，再将实例连接到在具体类型中所声明的方法。这样就实现了多态。

![](/assets/img/java/javase/method-binding/003.png)