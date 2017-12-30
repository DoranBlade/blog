---
title: "理解this关键字"
date: 2017-12-30T17:11:37+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

## this
### this的误区

this关键字不指代函数本身

``` js
function fn(){
    console.log(this.a);
}
fn.a = 12;
// undefined
fn();
```

this关键字不指代函数作用域

``` js
function fn(){
    var a = 12;
    console.log(this.a);
}
// undefined
fn(); 
```

### 调用栈和调用位置

函数的调用位置是指函数被执行的位置
调用栈是指为了到达当前调用位置，需要调用所有方法

``` js
function one(){
    // 调用栈：one
    // 调用位置：global
    two();
}
function two(){
    // 调用栈：one->two
    // 调用位置：one函数中
    three();
}
function three(){
    // 调用栈：one->two->three
    // 调用位置：two函数中
}
one();
```

## this的绑定
函数中this关键字，需要在运行时根据调用位置来决定绑定到哪个上下文对象中，通常情况下会有如下几种绑定方式

### 默认绑定
在非严格模式下，函数在全局作用域里执行，函数内的this会默认绑定到global对象上

``` js
var a = 2;
function fn(){
    console.log(this.a);
}
// 输出2
fn();  
```

### 隐式绑定
当函数设置成其他对象的属性时，该函数内的this会绑定到该上下文对象上

``` js
function fn(){
    console.log(this.a);
}
var obj ={
    a:10,
    fn:fn
}
 // 输出10
obj.fn();
```

隐式绑定的函数只有调用位置在该上下文对象内时，才能完成绑定动作。倘若把该函数的调用位置修改到上下文对象之外，则this的绑定就不再是该上下文对象

``` js
var obj ={
    a:10,
    fn:fn
}
var fnCopy = obj.fn;
// 输出undefined
fnCopy(); 
```

### 显示绑定
通过Function.prototype.call()/apply()，可显示将函数暂时绑定指定上下文对象上执行

``` js
function fn(){
    console.log(this.a);
}
var obj ={
    a:10
}
// 输出10
fn.call(obj); 
```

因为显示绑定是一种临时性的绑定，同隐式绑定一样，同样会有绑定丢失的问题。
但是可以通过建立一个函数来维持这样持续绑定关系

``` js
function bindFn(){
    fn.call(obj);
}
//  永远输出obj的a属性值
bindFn(); 
```

### new绑定
JavaScript中new关键字是调用构造函数创建对象时使用的，在创建过程中会有如下步骤：

+ 创建一个新的空对象
+ 对这个空对象执行原型连接(默认连接到object.prototype)
+ 将构造函数绑定这个新建的对象上
+ 返回这个新建立的对象

所以，new绑定是将函数的this绑定一个新对象上执行

``` js
function Dog(name){
    this.name = name;
}
let dog = new Dog("Tom");
// tom
dog.name; 
```

所以，构造函数所起到的就是初始化器的作用。同样我们也可以使用构造函数来初始化已经存在的对象

``` js
var obj = {
    getName:function(){
        console.log(this.name);
    }
}
Dog.call(obj,"Tom");
// 输出"Tom"
obj.getName(); 
```

### 绑定的优先级

这四种绑定中，new>显示绑定>隐式绑定>默认绑定
