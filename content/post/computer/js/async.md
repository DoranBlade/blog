---
title: "JavaScript的异步编程"
date: 2017-12-30T17:00:25+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

## JavaScript的异步问题
### 异步操作
JavaScript的I/O和数据访问等操作均是异步操作，代码执行到异步代码位置时不会等待操作结果的返回，而是继续执行下面的代码。而在c#,java等语言中，此类操作采用同步的方式，代码执行到异步代码位置时需要等待操作结果的返回才会继续执行下面的代码。

``` javascript
// javascript
$.ajax({...}) // 执行一个异步操作,不等待(阻塞)
var a = b;
// c#
FileStream file = new FileStream("E:\\test.txt", FileMode.Open);
byte[] result = file.Read(); // 执行一个异步操作，等待(阻塞)
result.toString();
```

JavaScript通过回调函数接受和处理异步操作的操作结果

``` javascript
$.ajax({
    type:"GET",
    url:"",
    success:function(date){
        // do something
    },
    error:function(err){
        // catch error
    }
})
```

### 回调金字塔问题

一个异步操作依赖上一个异步操作的操作结果时，就需要在回调函数中进行再进行一个异步操作

``` javascript
$.ajax({
    type:"GET",
    url:"",
    success:function(data){
        $.ajax({
            type:"POST",
            url:"",
            data:data,
            success:function(data){}
        })
    }
})
```

当异步操作依赖过多就需要多层次的去嵌套，就会形成回调金字塔的问题(嵌套太多)，十分影响代码的可读性

``` javascript
$.ajax({
    type:"GET",
    url:"",
    success:function(data){
        $.ajax({
            type:"GET",
            url:"",
            success:function(data){
                $.ajax({
                    type:"GET",
                    url:"",
                    success:function(data){
                        // ...
                    }
                })
            }
        })
    }
})
```
## 解决方案

### Promise
Promise是始于es6规范，Promise对象有三种状态:Pending(进行中...),Resolve(已完成),Reject(已失败)。Promise对象在创建后处于Pending状态，在后续代码执行中可修改为Resolve和Reject状态，状态一旦修改就不可再改变。

``` javascript
var comdition = true;
let promise = new Promise(function(resolve,reject){
    comdition?resolve("success"):reject("fail");
})
```
在改变状态的时候，可同时附加数据在Promise对象上，Promise.prototype.then()可根据Promise的状态调用对应的处理方法,在promise状态为resolve时调用第一个函数，promise状态为reject时调用第二个函数

``` javascript
promise.then(function(value){
    //resolve;
},function(reject){
    //reject;
})
```

可通过在异步操作的回调函数中改变Promise的状态来完成异步操作

``` javascript
let promise = new Promise(function(resolve,reject){
    $.ajax({
        type:"GET",
        url:"",
        success:function(data){
            resolve(date); //改变promise状态并附加操作结果
        },
        error:function(err){
            reject(err); // 操作错误时改为reject状态并附加异常信息
        }
    })
})
promise.then(function(data){
    // 异步操作正常时调用
},function(err){
    // 异步操作错误调用
})
```

当异步操作具有依赖关系时，可在then的回调函数中将异步操作包装在另外一个promise对象中返回

``` javascript
let promise = new Promise(function(resolve,reject){
    $.ajax({
        type:"GET",
        url:"",
        success:function(data){
            resolve(date); //改变promise状态并附加操作结果
        },
        error:function(err){
            reject(err); // 操作错误时改为reject状态并附加异常信息
        }
    })
})
promise.then(function(data){
    return new Promise(function(resolve,reject){
        $.ajax({
            type:"post",
            url:"",
            data:data
            success:function(data){
                revolse(data);
            },
            error:function(err){
                reject(err);
            }
        })
    })
},function(err){
    // 异步操作错误调用
}).then(function(data){
    // 处理第二个异步操作
},function(err){
    // 处理第二个异步操作的异常
})
```
promise对象时JavaScript其他解决异步操作的基础，使用promise对象可见回调的嵌套由横向发展变为纵向发展

### generator
generator可以看成是一个封装成多个步骤的遍历器,每个yield语句看成是一个步骤的结束。当代码执行到yield语句处时，函数停止运行将控制权移交到generator函数的当前执行对象上。
generator函数的执行对象执行generator函数对象的next()时，线程再次进行generator函数内，开始下一个步骤。

``` javascript
function* hello(){
    yield "hello";
    yield "world";
    return "end";
}
var test = hello();
//从函数开始执行到第一个yield语句
test.next(); 
//从第一个yield语句到第二个yield语句
test.next(); 
//从第二个yield语句执行到return
test.next(); 
```
yield语句可以向外部返回数据，next()方法会向上一个yield语句传递值

``` javascript
function* Test(){
    var a = yield 3;
    var b = a+3;
    yield b;
}
var test = Test();
//result1=3;
var result1 = test.next(); 
//b = result1+3,result2 = b
var result2 = test.next(result1); 
```

通过generator进行异步操作时，在异步操作的回调函数中将异步结果通过generator对象的next()方法传递到接下来的异步操作中,这种方式的缺点在于generator的next()是完全耦合的

``` javascript
//异步操作
function getNode(path){
    var url = "http://192.168.0.104:8080/"+path;
    $http.get(url).success(function(data){
        it.next(data); // 预先使用后续定义的generator对象，耦合比较高
    })
}
function* generatorTest(){
    //使用上一个异步操作的结果作为下一个异步操作的参数
    var result1 = yield $scope.getNode("first");
    var result2 = yield $scope.getNode(result1);
    var result3 = yield $scope.getNode(result2);
}
var it = generatorTest();
```

使用Promise对象将异步操作移交到generator函数外部执行，异步操作执行完成后将结果移交到generator函数内

 ``` javascript
function getNode(path){
    var url = "http://192.168.0.104:8080/"+path;
    return new Promise(function(resolve,reject){
    $http.get(url).success(function(data){
        return resolve(data);
    })
    })
}
function* generator(){
    var result1 = yield $scope.getNode("first");
    var result2 = yield $scope.getNode(result1);
    var result3 = yield $scope.getNode(result2);
    console.log(result3);
}
//执行
var ge = generator();
ge.next().then(function(value){
    ge.next(value)
}).then(function(value){
    ge.next(value)
}).then(function(value){
    ge.next(value);
})
```

+ co模块实现了generator函数的自动化执行

``` javascript
var co = require("co");
//co模块执行完成后返回一个promise对象，可使用也可不使用
co(generator).then(function(){
    console.log("执行完毕")
})
```

generator/promise的方式基本解决回调金字塔问题，只是需要手动完成generator函数的yield/next切换，但配合co模块可完美解决回调问题。

### Async/await
鉴于es6中generator/promise配合解决回调问题时，还需要在写法和工具上有所准备。es7草案中添加了async/await方案，虽然还未成为标准，但借助babel,typescript等工具能将其编译成generator/promise模式使用。
async/awai也是基于promise/generator/co,只是由es7原生支持。
async写法上与c#等语言的同步方式基本一致，代码运行到await语句时会等待操作结果返回后再执行下面的语句

``` javascript
async function as(){
    var result1 = await $scope.getNode("first");
    var result2 = await $scope.getNode(result1);
    return result1;
}
```

异步操作使用promise的方式，正常时为resolve状态，错误时为reject状态。await语句只能返回resovle状态下的promise对象数据

``` javascript
function get(url){
    return new Promise(function(resolve,reject){
        $.ajax({
            type:"POST",
            url:url,
            success:function(){
                reject(err); //同样设置为reject状态
            },
            error:function(err){
                reject(err);
            }
        })
    })
}
async function run(url){
    // result无法接受到reject状态下的promise数据
    var result = await get(url); 
}
```

reject状态下的promise对象数据，需要使用try...catch...的方式进行捕捉

``` javascript
async function run(url){
    try{
        var result = await get(url);
    }catch(err){
        // 处理reject状态的数据
    }
}
```
