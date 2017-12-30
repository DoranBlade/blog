---
title: "es6的模块"
date: 2017-12-30T17:07:26+08:00
tags: ["computer", "javascript"]
---
...
<!--more-->

## 社区模块方案
es6之前，JavaScript并没有模块体系，社区制定了一些模块加载方案，最主要的有CommonJS和AMD两种
CommonJS模块是同步加载，适合于node.js应用在服务器端，AMD模块是异步加载，模块加载完成后通过在回调函数内调用模块来完成业务需求，AMD模块适合于浏览器端。

### AMD模块方案
AMD模块使用define()定义，第一个参数为依赖项，第二个参数为模块执行函数，通过执行该函数返回模块需要向外部导出的部分。

``` js
// Tool.js
define([],function(){
    return function add(a,b){
        return a+b;
    }
})
```

导入AMD格式模块需要借助requirejs等库，使用requirejs库的requirejs()进行加载，该方法同样可以传入两个参数，第一个是依赖项，第二个是一个函数，该函数在模块加载完成后执行该方法

``` js
// main.js
require.config({
    // 配置模块的路径
    paths: {
        "Tool": "Tool",
    }
});
// 加载并使用该模块
requirejs(["Tool"],function(Tool){
    console.log(Tool.add(2,2));
})
```

### CommonJS模块方案
CommonJS模块规范中通过将需要导出的部分附件到exports对象上导出

``` js
// Tool.js
function add(a,b){
    return a+b;
}
pi = 3.14;
exports.add = add;
exports.pi = pi;
```

加载CommonJS模块时，使用require(url)方法加载，该方法放回一个对象，即模块中的exports对象，通过该对象我们就可以使用模块中导出的部分

``` js
// test.js
let Tool = require("Tool");
Tool.add(3+4); //输出7
```

## ES6的module
ES6原生提供了对模块的支持，export关键字用于导出模块中需要导出的部分，import关键字用于导入模块。


### export
export可以出现在模块内顶层作用域的任何位置，可以单独导出每个需要导出的部分，也可以将需要导出的部分用"{}"包裹

``` js
// Tool.js
export function add(a,b){
    return a+b;
}
export let pi = 3.14;

//也可以这样定义
function add(a,b){};
let pi = 3.14;
export {add,pi}
```

可以使用"as"关键字对要导出的部分进行重命名

``` js
export {add as Add,pi as Pi}
```

**export default** 以上定义中，如果要使用模块导出的部分，必须要知道导出部分的名称。我们可以在定义模块时，定义一个默认输出部分，在使用模块时可直接使用模块对象就会执行默认的输出部分。

``` js
export default function(a,b){
    return a+b;
}

//使用
import Tool from "./Tool";
//输出2
Tool(1,1); 
```

### import
通过import {} from <moduleName>导入模块，大括号内使用变量一一对应模块导出的变量

``` js
import {add,pi} from "./Tool";
add(2,3); // 输出5
// 输出3.14
pi; 
```

也可以通过"*"加载整个模块对象

``` js
import * as Tool from "./Tool";
```

## 社区模块方案和es6模块的差异
社区模块方案在模块加载后，会复制模块的导出成员，实际操作的是复制品而不是模块本身。
es6模块是对模块对象的引用，实际操作的也是模块本身

### 社区模块
因为社区模块是值赋值，在使用社区模块时，实际上无法修改模块本身
``` js
// Tool.js
let pi = 3.14;
function setPi(pi){
    pi = pi;
}
exports.setPi = setPi;
exports.pi = pi;

// test.js
let Tool = require("./Tool");
Tool.pi; // 输出3.14
Tool.setPi(2.00);
// 输出3.14
Tool.pi;  
```

### es6模块
es6模块属于对模块对象的引用，可以对模块本身进行修改

``` js
// Tool.js
export let pi = 3.14;
export function setPi(pi){
    pi = pi;
}

// test.js
let Tool = require("./Tool");
console.log(Tool.pi); // 3.14
Tool.setPi(2.00);
// 2
console.log(Tool.pi); 
```
