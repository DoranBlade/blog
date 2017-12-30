---
title: "Java Bean"
date: 2017-12-30T16:41:56+08:00
tags: ["computer", "java"]
---
....
<!--more-->

## JavaBean的概念
JavaBean实际是对oop思想中对于封装的一种延伸，首先需要明确的是Java类中字段和属性的的概念

### 字段和属性
字段是Java类中实际存在的东西，其作为类的一部分，在类的对象的内存空间中占据具体的位置。下面实际定义几个十分平常的字段

``` java
public Dog{
    String name;
    int age;
}
```

属性是一种概念性的东西。oop中字段需要经过封装，其封装时通用的方式是添加setXxx()和getXxx(),而这个Xxx就是一般概念上的属性名。
例如字段name经过封装后会有setName()和getName()，这个去除set/get后的名称Name就称之为属性

``` java
public Dog{
    private String name;
    public String getName(){
        return this.name;
    }
    public void setName(String name){
        this.name = name;
    }
}
```

### JavaBean的由来
JavaBean的出现是为了减少类的字段在使用时的耦合性，比如某一个库在第一版本定义一个length属性标示一个长度属性，代码如下

``` java
public class Dog{
    public Dog[] child;
    public int length = child.length;
}
```

当该库更新到第二版本时，作者处于其他考虑将该length属性改为了size属性来标示,原本的Length属性作为了其他用途。这个时候使用第一版本开发的库就会无法使用第二版本的库了。

``` java
public class Dog{
    public Dog[] child;
    public int size= child.length;
}
```

鉴于此才有了JavaBean的流行，JavaBean通过封装实现了类字段与使用者之间的解耦和，字段的变更可以通过封装器的调整，这样使用者就不会因为字段的变更而受到影响。

``` java
public class Dog{
    public Dog[] child;
    private int size = child.length;

    public int getLength(){
        return this.size;
    }
}
```

### bean规范
java bean规范分为四个部分

+ 字段必须使用private
+ 提供属性的setter和getter
+ 提供默认构造方法
+ 实现serializable接口

serializable接口是为了对象能够实现序列化，使用者可能需要序列化对象进行传递。

``` java
public class Cat implements Serializable{
    private String name;
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Cat() {
        super();
    }
}
```

## 操作JavaBean
操作JavaBean有多种方法，比如官方提供的内省，反射等。这里我会使用简单易用的第三方库BeanUtils来操作JavaBean

### 设置和读取属性
BeanUtils库中包含了多种转换工具，其中BeanUtils类可用于设置和读取属性

``` java
@Test
public void bean() throws Exception {
    DogBean dogBean = new DogBean();

    // 设置bean属性
    BeanUtils.setProperty(dogBean,"name","tom");
    BeanUtils.setProperty(dogBean,"age",2);

    // 获取bean属性
    String name = BeanUtils.getProperty(dogBean,"name");
    String age = BeanUtils.getProperty(dogBean,"age");

    // 断言
    Assert.assertEquals(name,"tom");
    Assert.assertEquals(age,"2");
}
```
