---
title: "java多态实现的关键-动态绑定"
date: 2017-12-30T16:53:19+08:00
tags: ["computer", "java"]
---
...
<!--more-->

## 方法的初始化
jvm加载类型后，会将方法代码保存起来，然后将类型与方法关联在一起。在运行时类型的实例调用方法时，会找到与该类型所关联的方法代码块，然后运行该方法代码块。
![](/assets/img/java/img010.png)

## 分析多态
下面是一段关于多态的代码，声明了父类Animal和子类Cat，Dog。这三个类型在加载后都关联了各自的print方法，各自的实例调用print方法时都会找到关联的方法代码块，然后运行


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

上面代码的运行结果符合多态的定义，但是还是有疑问。Animal类型的变量调用的应该是与Animal类型关联的print()。为何调用的却是与Cat，Dog类型关联的print。这得从句柄调用方法的绑定方式上看。

+ 第一种绑定方式是前期绑定，在程序编译时根据变量的类型绑定了执行的方法
![](/assets/img/java/img011.png)

+ 第二种绑定方式是后期绑定，在程序运行时根据变量所指向的对象的实际类型，绑定对象类型关联的方法。
![](/assets/img/java/img012.png)

对于属性的访问java采用的是前期绑定，只会访问变量类型上关联的属性。
![](/assets/img/java/img013.png)