---
title: "作用域"
date: 2017-12-30T17:08:35+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

## js的编译和执行

### js编译执行
js的整个编译执行过程由下面三个部分去实现

+ 引擎：负责整个JavaScript程序的调度，如调用编辑器生成机器码以及执行机器码
+ 编译器：负责源代码的语法分析和代码生成
+ 作用域：负责收集和维护所有声明的标识符

### js的编译过程
JavaScript相对c#等半编译语言在执行过程中存在着一些差异，c#、java等语言在均会先预编译成中间码，然后又虚拟机解析中间码，编译和执行时两个独立的部分。
JavaScript则是编译完成后立即就执行了，编译优化的空间比较小。JavaScript的编译过程包含如下三个阶段：

 + 词法分析：将代码字符串分解成有意义的词法单元
 + 语法分析：将词法单元流转换成一个语法结构的树
 + 代码生成：将语法树转换成可执行代码
 ![](/img/js/es/010.png)

### 变量声明和赋值
JavaScript的变量声明和赋值分别在编译阶段和执行阶段中进行。
在编译阶段编译器先在本作用域中查找是否存在该变量，若有则不做处理，没有则在该作用域中声明该变量
对于赋值部分，编译器会教其编译成机器码，在运行期间由引擎执行

![](/assets/img/js/es/011.png)

引擎在执行赋值操作时，先在作用域链内查找变量，若存在则对其赋值。倘若没有找到该变量则抛出异常

![](/assets/img/js/es/012.png)

### 提升
鉴于js的编译和执行原理，声明变量和赋值分为了两个阶段，编译阶段在作用域内声明变量，执行阶段为变量赋值。所以不论定义位置如何，所有变量的声明总是先于所有变量的赋值

![](/assets/img/js/es/013.png)

JavaScript中函数的编译和执行是一个特殊的情况，函数在编译阶段就会全部编译完，不需要再在运行时去赋值，所以函数会整体提升

``` js
fn(); // 输出'fn'
function fn(){
    console.log("fn");
}
```

使用函数表达式定义函数时，其编译和执行状况就和变量时一致的了。
这种方式定义的函数只会提升声明部分,在赋值前使用该变量时，因为尚不确定该变量是函数类型，所以会抛出异常

``` js
fn(); // fn is not a function
let fn = function(){
    console.log("fn");
}
// 等价于
let fn;
fn(); // 此时fn不能确定是function类型
fn = function(){
    console.log("fn");
}
```

### 引擎查找变量的方式
对于变量在运行时会有两种作用，一种是查找然后取出变量的值，此类操作一般没有操作符或者在操作符右边，称之为"RHS"操作

![](/assets/img/js/es/014.png)

变量的另一种作用是查找然后对去赋值，此类操作一般出现在操作符左边，称之为"LHS"操作

![](/assets/img/js/es/015.png)

## 理解作用域

### 词法作用域

编译器在编译阶段，按照代码书写的结构生成词法阶段的作用域。
每个函数均会生成一个词法作用域,函数内的成员外层作用域无法访问。
对象并不会有词法作用域，因为对象并不用于执行逻辑代码

``` js
var a = 3;
function fn(){
    var b = a;
}
// reference error;
b; 
```

函数有嵌套时，词法作用域也会一次嵌套，形成一个作用域链
![](/assets/img/js/es/016.png)

在引擎执行代码期间，无论是LHS操作还是RHS操作，在查找变量时会检索整个作用域链。从当前作用域开始，依次向上层作用域，直至最顶层的作用域，检索过程中如果查找到该变量则停止向上检索。

``` js
var a = 4;
function fn(){
    var a = 10;
    console.log(a);
}
// 输出10
fn(); 
```

### 作用域闭包

当JavaScript的作用域内嵌套一个作用域，则嵌套的这个内部作用域就被封闭在该作用域中，外部无法进行访问。
闭包指的就是被封闭在一个作用域中的一个作用域。
下面的例子中一个函数内嵌套了一个函数，被嵌套的函数被封闭在外出函数中，外部无法访问。

``` js
function outer(){
    function inner(){}
}
// reference error
inner(); 
```

但是上面的inner函数并不是真正意义上的闭包，只是创建了一个正常的作用域链
闭包还需要一个特性，才能使其具有价值,那就是可以在该闭包所在作用域之外运行。

``` js
function outer(){
    function inner(){}
    return inner;
}

let inner = outer();
// 被封闭的作用域，在其他作用域中运行，形成闭包
inner(); 
```

闭包的真正定义是，被封闭在一个作用域的作用域，可以在其所在作用域之外运行。
闭包的意义在于可以为一个作用域提供一个外部的访问接口

``` js
function outer(){
    var name = "cc";
    function getName(){
        return name;
    }
    return getName;
}
let getName = outer();
// 输出cc
getName(); 
```

闭包的会一直保持着对闭包所在作用域的访问权限，也会阻止垃圾回收器回收其所在作用域的回收。
下面的例子中，当delay函数执行完成后，垃圾回收器应该会对其进行回收操作。但是当setTimeout()函数过1000ms再调用其闭包时，delay仍未被回收。
这里也提现了闭包的一个副作用，如果处理不当，可能会造成垃圾回收不了，内存增加的现象。

``` js
function delay(mess){
    setTimeout(function(){
        console.log(mess);
    },1000);
}
delay("haha");
// 等价于
function delay(mess){
    function temp(){
        console.log(mess);
    }
    return temp;
}
setTimeout(delay(),1000);
```

JavaScript中闭包的使用场景十分多，使用的也十分频繁。一般将一个函数作为参数传递时，均是闭包的表现，比如JavaScript中大量使用回调函数

``` js
$.ajax({
    type:"GET",
    success:function(data){
        // do something
    }
})
```

来分析下下面的代码

``` js
function print(){
    for(var i = 0; i < 5; i++){
        setTimeout(function(){
            console.log(i);
        },1000);
    }
}
// 输出 5,5,5,5,5
print(); 
```

上面的代码其实等价于下面的代码，print()函数内部的循环其实是创建了5个闭包，每个闭包都访问print()函数作用域内的变量i

``` js
function print(){
    var i = 5;
    function temp1(){
        console.log(i);
    }
    function temp2(){}
    ...
    function temp5(){}
    return {
        temp1:temp1,
        temp2:temp2,
        ...
        temp5:temp5;
    }
}
let temp = print();
setTimeout(temp.temp1,1000);
...
setTimeout(temp.temp5,1000);
```

上面例子无形中创建了一个模块，这也是闭包最重要的作用，JavaScript的模块就是基于闭包。
下面稍作修改使其更像一个模块

``` js
function Tool(){
    function add(a,b){
        return a + b;
    }
    return {
        Add:add
    }
}
let tool = Tool();
// 输出5
console.log(tool.Add(2,3)); 
```
