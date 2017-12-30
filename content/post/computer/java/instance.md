---
title: "Java的instanceOf与isInstance()"
date: 2017-12-30T16:48:40+08:00
tags: ["computer", "java"]
---
...
<!--more-->

### 使用
在运行时做类型向上转换时，jvm不需要检查实例的具体类型。但是做类型向下转换时则需要检查实例的具体类型，确保实例是需要转换的类型，如果不是则会抛出异常。这种情况下最好的处理方式是在强制转换之前先手动进行类型检查，常用的有instanceOf关键字。instanceOf关键字之后跟随需要检查的类型关键字。

``` java
public interface Animal(){}
public class Test implements Animal {
    public void test{
        Animal animal = new Test();
        if (animal instanceOf Test) {
            Test test = (Test)animal;
        }
    }
}
```

除了使用instanceOf关键字外，还可以使用Class实例的instanceOf来检查实例的类型。这种方式更加利于编程处理，instanceOf受限于关键字，必须在语句中固定具体的类型关键字。

``` java
public void test(){
    Animal animal = new Test();
    Class<?> test = Test.class;
    if (test.isInstance(animal)) {
        Test test = (Test)animal;
    }
}
```

### 区别
上面两种方式都可以在运行时检查实例的类型，功能上两者是一致的。但是在使用也有着差别，关键字instanceOf需要在语句中固定类型关键字。这种特性在类型确定且检查数量不大的情况下使用十分方便。如果检查数量大或者类型不确定时则不好处理了。

``` java
public interface Animal{}
public interface Dog extends Animal{}
public interface Cat extends Animal{}
...

public class Test{
    public void test() {
        List<Animal> animals = new ArrayList<>();
        ...
        for (Animal animal : animals) {
            if (animal instanceOf Animal) {
                // do something
            }
            if (animal instanceOf Dog) {}
            if (animal instanceOf Cat) {}
            // other type
        }
    }
}
```

相对应的isInstance()方法使用的Class实例，Class实例作为一种编程元素而非关键字，从编程角度上看就有更多的适用性。isInstance可以理解为一种动态的instanceOf。

``` java
public void test(List<Animal> animals) {
    List<Class<? extends Animal>> animalClasses = new ArrayList<>();
    for (Animal animal : animals) {
        for (Class<? extends Animal> classes : animalClassess) {
            if (classes.isInstance(animal)) {
                // do something
            }
        }
    }
}
```
