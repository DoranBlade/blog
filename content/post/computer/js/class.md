---
title: "es6 class"
date: 2017-12-30T17:04:47+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

### es6中的类

es5中一般借助构造函数和原型对象模拟类，实现方法如下:

``` js
// 构造器定义属性
function Dog(name,age){
    this.name = name;
    this.age = age;
}
// 原型对象定义方法
Dog.prototype.toString = function(){
    return `name:${this.name},age:${this.age}`;
}
```
es6中新添加了class来定义类，本质上class只是es5上模拟类的语法糖
使用class时，使用constructor()替代构造函数，用来定义类的属性。直接在类型定义中定义的方法，实际上也是在构造函数的原型对象上添加该方法

``` js
// 下面使用class定义的类等价于上面es5方法定义的类
class Dog{
    constructor(name,age){
        this.name = name;
        this.age = age;
    }
    toString() {
        return `name:${this.name},age:${this.age}`;
    }
}
```

class中可以使用static关键字定义静态方法，可直接使用类名访问。实质上静态方法就是在构造函数上添加了一个方法，如下面代码：

``` js
class Dog{
    constructor(name){
        this.name = name;
    }
    static print(){
        console.log("static print");
    }
}
Dog.print();
// 等价于
function Cat(name){
    this.name = name;
}
Cat.print = function(){
    console.log("static print");
}
Cat.print();
```

### 类的继承

在es6的类中实现继承时，需要使用"extends"关键字继承父类，在子类中使用super关键字来表示父类。
这种类继承的方式实际上就是es5中实现继承的语法糖(见面向对象章节)。

``` js
class Animal{
    constructor(type){
        this.type = type;
    }
    getType(){
        return this.type;
    }
}
class Dog extends Animal{
    constructor(type,name){
        super(type);
        this.name = name;
    }
    getName(){
        return this.name;
    }
}

var dog = new Dog("Dog","tom");
// "Dog"
dog.type; 
```

es6的类继承与es5中实现类继承，有一个轻微的差异。在子类的构造函数中必须要使用super调用父类构造函数，否则无法使用this关键字。
倘若子类没有定义构造函数，则系统会默认调用一次父类构造函数

``` js
class Dog extends Animal{
    constructor(type,name){
        // this is not defined
        this.name = name; 
        super(type);
    }
    getName(){
        return this.name;
    }
}
```
test
