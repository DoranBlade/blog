---
title: "尾调用"
date: 2018-04-26T12:13:40+08:00
draft: false
---

### 什么是尾调用

+ 调用栈的推入

程序从入口函数运行开始，会在当前线程的调用栈上推入入口函数的栈帧。栈帧内保存当前函数的变量信息。入口函数内调用其他函数时，会在调用栈上推入调用函数的栈帧。如果调用函数内还调用其他函数，则又会推入新函数的栈帧。处理器都是执行栈顶的栈帧所对应的函数代码。



+ 调用栈的出栈

当栈顶的函数执行完成后，该栈帧会出栈。处理器转到新的栈顶栈帧中继续执行。

``` js
function main() {
    let res = operator(2, 2);
    return res;
}
function operator(a, b) {
    let res = add(a, b);
    return res;
}
function add(a, b) {
    return a  + b;
}
```

+ 尾调用
当某个函数最后return的是一个函数的执行结果，则这个函数时尾调用。比如上面的例子改为如下

``` js
function main() {
    return operator(2, 2);
}
function operator(a, b) {
    return add(a, b);
}
function add(a, b) {
    return a  + b;
}
```

### 尾调用优化
但函数执行到尾调用部分时，当前函数的栈帧已经没有任何的用处了。部分语言则对尾调用进行优化，在尾调用时会将当前的栈帧替换成将要调用函数的栈帧，这样可以减少一个栈帧的创建，推入以及出栈操作。

有一种情况例外，如果新调用函数是闭包的情况，则不能进行尾调用优化。因为当前栈帧内的变量对于新函数还有用，清掉会影响新函数的调用。

``` js
function main() {
    let a, b = 2, 2;
    return function(a, b){
        return a + b;
    }
}
```
