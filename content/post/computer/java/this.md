---
title: "方法内的this"
date: 2017-12-30T16:57:29+08:00
tags: ["computer", "java"]
---
...
<!--more-->

### this的使用
在Java的方法中，可以通过this关键字引用到在运行时调用该方法的实际实例。在通过该实例就访问该实例的其他成员。

``` java
public class Test{
    private String tip;
    public void print() {
        System.out.println(this.tip);
    }
}
```

实际使用过程中，在调用实例内的其他成员时也可以选择不使用this调用。(在Java编程思想里面，作者建议采用这种方式调用实例内成员)

``` java
public class Test{
    private String tip;
    public void print() {
        System.out.println(tip);
    }
}
```

### this的实现
看完了上面关于this的使用，下面看看关于this的实现。在编译器将源码编译的过程中，其实做了一些内部操作。编译器会把所调用的实例对象作为方法的第一参数传入，然后通过this关键字引用这个传入的实例对象。这种机制类似于下面的这种伪代码

``` java
Test test = new Test();
Test.print(test)
```

在方法内部不使用this关键字来调用实例成员时，对于没有主调对象的变量或者方法应该是要做一些处理的(有主调对象的直接调用即可)。
如果是变量则应该会先检查方法内的作用域内是否有该变量，如果有则调用本作用域内的变量，没有则使用this作为主调对象。

``` java
public class Test{
    private String tip;
    public void print() {
        System.out.println(tip); // 使用域
    }
    public void print1() {
        String tip = ""; // 
        System.out.println(tip); // 使用局部变量,等价于this.tip
    }
}
```

如果是方法的话应该会直接使用this作为主调对象。

``` java
public class Test{
    private String tip;
    public void print() {
        empty(); // 等价 this.empty()
        System.out.println(tip); // 使用域
    }
    private void empty() {}
}
```

### static方法
static方法是绑定在Class对象上的，跟具体实例无关。static方法在调用的时候，编译器并不会将实例作为方法的第一参数传入。