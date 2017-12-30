---
title: "let,const和块级作用域"
date: 2017-12-30T17:05:58+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

### var
var变量的作用域时整个function中

``` js
function fn(){
    for(var i = 1;i<4;i++){}
    //3
    console.log(i);  
}
```

非严格模式下，js引擎在查找var变量时，若依次查找到最顶层作用域也没有查找到该变量，则会在最顶层作用域中声明该变量

``` js
function fn(){
    a = 4;
}
// 4;
console.log(a);  
```

### let
let变量声明方式在es6中添加，用于创建与c#等语言类似的区块变量。所以，let声明的变量只在当前的"{}"内可访问

``` js
{
    var b =1;
    let a =1;
}
 //1
console.log(b);
//Reference Error
console.log(a); 
```
var声明的变量有变量提升现象，let声明的变量不会有变量提升

``` js
{
    a = 4; //Reference Error
    let a;
    b = 5; // ok
    var b;
}
```
let和const声明的变量会绑定到该区域，会完全隔绝外部同名变量

``` js
var a = 4;
{
    //Reference Error
    a = 10;  
    let a;
}
```
不允许重复声明

``` js
{
    var a =3;
    //Syntax Error
    let a =1; 
}
```

### const
const用于声明常量，常量所直接引用的内存地址不可在变
const常量和let变量的特性基本一直，同样只在当前的{}内有效，也不会有变量提升,不允许重复声明，隔绝外部同名变量

``` js
const a = 1;
//Syntax Error
a =3; 
```

const常量引用对象时，对象的内存地址不变，但可以修改对象的属性。所以，const常量引用对象时，具有一定的可变性

 ``` js
const dog= {
    name:"tom"
}
dog.name = "jack";
//jack
console.log(dog.name); 
```
### 块级作用域
let和const定义的变量均只能在当前所在的'{}'中有效，通过使用let和const变量可实现js块级作用域,外部作用域无法访问内部块作用域内的let和const变量

``` js
for(var i=0;i<10;i++){}
i; //10;
for(let j=0;j<10;j++){}
//ReferenceError
j; 
```
内部块级作用域能访问和覆盖外部作用域变量

``` js  
function fn(){
    var a = 4;
    if(true){
        let a = 10;
        //10
        console.log(a); 
    }
}
```
