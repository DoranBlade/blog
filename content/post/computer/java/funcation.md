---
title: "java的函数式编程"
date: 2017-12-30T16:46:24+08:00
tags: ["computer", "java"]
---
探究Java8对函数式编程的支持
<!--more-->

## 实现函数式编程
### 匿名内部类
在Java8之前最接近接近函数式编程的是匿名内部类，其具体的使用场景是将一个匿名内部类实例作为实参传入方法内或者赋值给一个变量。在只使用一次的情况下，匿名内部类有着不需要定义成类的优势。

``` java
// interface
public interface Compute {
    double compute(double a, double b);
}
// 匿名内部类
Compute compute = new Compute() {
    @Override
    public double compute(double a, double b) {
        return a + b;
    }
};
```

但是匿名内部类相较于动态语言而言，在使用时又稍显繁琐。下面列出JavaScript中function作为实参的例子，相比较而言匿名内部类有用的部分只有方法体实现部分，但是需要书写包括接口，方法名等语句。

``` javascript
compute(function(a, b) {
    return a + b;
})
```

### lambda
为此Java8中添加了lambda来优化这个问题，lambda在c#是很早就已经存在的特性，Java对其支持的较晚。一个完成的lambda表达式包含有三个部分:方法参数，箭头符号，方法体。lambda表达式的具体规则都是语法层面上的东西，这里不做具体分析。下面列出一个lambda的例子，相比较匿名内部类要精简了很多。

``` java
Compute compute = (a, b) -> {
    return a + b;
};
```

lambda与匿名内部类类似，都是适用于一次性的逻辑定义。对于需要重复利用的逻辑定义，还可以使用java8中新添加的方法引用。

### 方法引用
方法引用的实质是使用现有类中已定义的方法作为该次逻辑的定义，在内部处理上不知道是否和lambda表达式一致。在感官上lambda和方法引用是一致的，都是为接口方法提供逻辑实现。方法引用的主体可以是类也可以是类的实例。

``` java
// 定义逻辑体
public class Math {
    public static double plus(double a, double b) {
        return a + b;
    }
    public double minus(double a, double b) {
        return a - b;
    }
}
// 方法引用
Compute compute1 = Math :: plus;
Compute compute2 = new Math() :: minus;
```

如果跟上面一样，方法并不需要关联到类上。仅仅需要找一个载体，则可以在接口中添加静态方法。

``` java
public interface Math {
    static double plus(double a, double b){}
}
```

lambda和方法引用相较于匿名内部类还有一个显著的特点：类型推导，Java会根据实际使用推导传入数据类型。这样可以在lambda中不需要显示定义变量类型，在方法应用时则可以实现多态性。

``` java
public interface Math {
    static double plus(double a, double b){}
    static int plus(int a, int b){}
}

Compute compute1 = Math :: plus;
```

### @FunctionInterface
上面的接口只有一个需要实现的方法，所以在使用lambda和方法引用的时候很容易就能确认到是实现了那个方法。如果一个接口中存在多个需要实现的方法，那么在使用lambda和方法引用时就无法精准的定位到实现的方法。而且lambda和方法应用也不支持同时实现多个方法。在Java8中新添加了@FunctionInterface注解，这个注解的作用是限制一个接口只能有一个待实现的方法，多个或者没有都不行。使用该注解可保证这个接口是可以使用lambda或者方法应用来实现的实例的

``` java
@FunctionalInterface
public interface Compute {
    double compute(double a, double b);
}
```

通过@FunctionInterface，lambda,方法引用这三个Java8中提供的新事物，可以在定义和使用时很方便的实现函数式编程。

## 总结
### 差异性
Java中方法并不是一个可以独立存在的组件，即使是像Runnable接口这样只包含一个方法，该接口的存在也只是为了这个方法。这个方法还是需要依托在这个接口上，这是Java相比较真正的函数式编程的一点局限性。

### 闭包
与内部类一样，lambda或者方法引用可以很方便的实现闭包。

``` java
public class ComputeFactory {
    private double start = 10.00;
    Compute generate(String computeName) {
        if (computeName.equals("plus")) {
            return ((a, b) -> a + b + start);
        } else if (computeName.equals("minus")) {
            return ((a, b) -> a - b + start);
        } else {
            return (((a, b) -> start));
        }
    }
}
```

