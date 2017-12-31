---
title: "变量和指针"
date: 2017-12-30T23:30:03+08:00
tags: ["computer", "c++"]
---

探究java/js,c++/go语言间的变量差异
<!--more-->

## 变量
在c++中声明一个变量,先需要在内存中找到合适大小的内存区域用于存放变量数据,并通过变量名来访问这些数据.下面声明了一个age变量,对于该变量的访问都需要通过该变量来进行

``` c++
int main() {
    int age = 12;
    age = 20;
    cout << age << "\n";
}
```

这种对于变量的处理方式,在java/js/golang等语言中大致都一致.以下面Java为例(可以看出c++和Java很多语法有很多的相似)

``` java
public static void main(String[] args) {
    int age  = 12;
    age = 20;
    System.out.print(age);
}
```

 在变量的使用上,c++和Java等语言都采用值传递的方式传递变量.Java/js等在变量上根据其在内存中存储的结构,区分变量为值类型变量和引用类型变量.下面以c++的struct和Java的类来做比较.
 先看看c++的例子,下面例子中作为复合类型的struct变量,传递给变量时传递的使其所有数据的副本.

 ``` c++
struct Dog {
    string name;
    int age;
};
int main() 
{
    Dog a = {"tom", 12};
    Dog b = a;
    a.age = 20;
    // b.age = 12
    cout << b.age << "\n";
}
```

Java的例子中,作为复合类型的class变量,传递给变量时传递的时其对数据的引用地址

``` java
public class Dog {
    String name;
    int age;

    public static void main(String[] args) {
        Dog a = new Dog();
        a.name = "tom";
        a.age = 12;
        Dog b = a;
        a.age = 20;
        // b.age = 20;
        System.out.print(b.age);
    }
}
```

## 指针
在c++,golang等编译时语言中, 开放了对于指针的权限.

+ ?栈变量
+ 堆变量
+ 变量和指针的变换

## 其他语言比较
+ 通过变量传递描述差异
+ 通过函数传参描述实际使用
+ 总结变量和指针这两种结构的优劣
