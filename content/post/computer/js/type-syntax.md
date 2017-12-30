---
title: "类型系统和语法"
date: 2017-12-30T17:13:53+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

## 类型

### 内置的基本类型
JavaScript中一共包含有七种类型，见如下

+ null：空值
+ undefined：未赋予值
+ string：字符串
+ boolean：布尔
+ number：数值
+ object：对象
+ symbol：符号

#### type检查类型
通过**typeof**关键字检查值的数据类型，除了null之外，其余数据类型均返回相匹配的字符串

``` js
let nullVar = null;
let undefinedVar = undefined;
let numberVar = 12;
let str = "abc";
let bool = true;
let obj = {name:"tom"};
// js
console.log(typeof nullVar); // null
console.log(typeof undefinedVar); // object
console.log(typeof numberVar); // number
console.log(typeof str); // string
console.log(typeof bool); // boolean
// object
console.log(typeof obj); 

```
javascript的变量并不包含类型信，变量所保存的值可以随意变动。判定JavaScript变量的类型实际上是判定该变量所包含的值。

``` js
let obj = {name:"tom"};
obj = 3;
typeof obj; // number
// number
typeof 3; 
```

使用typeof判定undefined值的类型会返回"object",这是JavaScript实现体(浏览器)的一个bug,我们可以使用下面符合条件来判定null

``` js
let v = null;
if(!v && typeof v === "object"){}
```

#### undefined和undeclare
未赋值的变量，使用typeof关键字判定类型时，会返回undefined

``` js
var long;
// undefined;
typeof long; 
```

undefined类型值很容易误导为未定义，是来源于浏览器对于未定义的变量做类型判定时会返回undefined。这是浏览器解析时的一个报错不准确导致的。

``` js
// typeof 判定
// undefined -> undeclare
typeof test; 
```

全局作用域内的undeclare类型变量，判定其是否存在时，不能依赖JavaScript的自动类型转换，会抛出异常。我们可以使用typeof来做安全保护。

``` js
if(test){} // 抛出异常
if(typeof test !=="undefined"){
    // do something;
}
```

其他对象内的undeclare变量，可以借助JavaScript的自动类型转换，也可以使用typeof。

``` js
var obj = {};
if(obj.name){
    // do something;
}
if(typeof obj.name !=="undefined"){
    // do something
}
```

### 其他类型
数组，字符串等在JavaScript中均属于object类型

#### 数组
js中的数组有几个不太一样的特性
首先是稀疏数组，数组元素的索引并不是严格递增的，索引间的数字可以跳跃，跳跃的索引也会计入length属性

``` js
var arr = [];
arr[0] = 1;
arr[10] = 10;
arr.length = 11;
arr[2] = undefined;
```

第二个特性是数组除了可以使用数字作为索引外，还可以使用字符串作为索引。字符串索引如果不能自动转换为数组索引的，该元素不会计入length中。

``` js
var arr = [];
arr["test"] = 12;
arr["12"] = 12;
arr.length = 13;
```

从遍历上看，稀疏数组不能遍历到跳跃的索引元素，而使用字符索引的元素也可以遍历

``` js
var array = []
array[1] = 1;
array[10] = 10;
// 1,10
for(let index in array){
    console.log(array[index]);
}

var arr = [];
arr[12] = 12;
arr["test"] = "test";
for(let index in arr){
    console.log(arr[index]);
}
```

#### 字符串
字符串可以看成是字符数组，我们可以使用一些数组原型对象上的方法来操作字符串

``` js
var str = "abcd";
// dest = "a-b-c-d"
let dest = Array.prototype.join.call(str,"-"); 
```

字符串是不可变的，任何字符串的改变都是在字符串的副本上操作的

``` js
var arr = ["f","o","o"];
var str = "foo";
arr[1] = "t";
str[1] = "t";
console.log(arr);
console.log(str);
```

#### 值类型和引用类型
JavaScript也和c#等语言一样，按其数据类型分为值类型和引用类型。
值类型包含js的null、undefined、字符串、数字、布尔、symbol,值类型数据在传递时传递的是其副本

``` js
var a = 12;
var b = a;
a = 10;
b; // 12
// 10
a; 
```

引用类型传递其引用地址

``` js
var obj1 = {
    name:"tom"
}
var obj2 = obj1;
obj1.name = "jack";
obj1.name; // jack
// jack
obj2.name; 
```

## 原生函数
各种数据类型都有一个对应的原生函数可以构建数据
![](/../img/js/es/017.png)

### 使用原生函数
原生函数与构造函数类型，通过new关键字调用，生成包含基本类型数据的封装对象。

``` js
var str = new String("abc");
```

使用原生函数创建的对象均是object对象

``` js
// object;
typeof str; 
```

所有使用typeof返回"object"的对象，其内部均有一个[[class]]属性，保存一个相对应其原生函数的值。可以使用instanceof来判定

``` js
// true;
str instanceof String; 
```

### 拆箱和装箱
js中封装对象和基础类型之间可以手动进行转换

``` js
var str = "abc";
// 装箱
var Str = new String(str);
// 拆箱
var dest = Str.valueOf();
```

一般情况下，我们并不需要手动进行转换，浏览器会自动进行转换

``` js
var num = 12;
let result1 = num.toString(); // 自动装箱
var Num = new Number(12);
//自动拆箱
let result2 = num+Num; 
```

绝大部分情况下，我们并不需要使用原生函数创建对象，一是不简洁，二是影响性能(浏览器已经对使用字面量的方式进行了优化)。

### 原生函数的原型对象
基础类型的对象并没有与其相关的辅助方法，如string.slice()。基础类型的对象要使用这些辅助方法需要进行装箱操作

``` js
var str = "abc";
// 3
str.length(); 
```

所以，我们可以在原生函数会的原型对象添加方法，这样基础类型的对象和原生函数创建的对象均可以调用

``` js
String.prototype.toArray = function(){
    var ele = this;
    var arr = [];
    if(ele.length>0){
        for(let index in ele){
            arr.push(ele[index]);
        }
    }
    return arr;
}
var str = new String("ab");
let arr = str.toArray();
```
