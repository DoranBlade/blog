---
title: "Ssl"
date: 2017-12-30T16:34:16+08:00
tags: ["computer", "info"]
---
探究ssl
<!--more-->

## ssl原理
采用ssl证书加密的http访问时，会有如下两个阶段

+ 连接阶段：client端和server端确认加密方法以及加密密钥
+ 传输阶段：两端开始传送数据
在连接阶段按步骤可分为四个阶段

### 第一阶段
这个阶段client端发送如下信息给server

+ 支持的协议版本，如tls 1.0
+ 随机字符串
+ 支持的加密方法
![](/assets/img/tool/http/002.png)

### 第二阶段
这个阶段server端会回应如下信息给client

+ 确认支持阶段一的信息，如协议版本，加密方法等
+ 返回一个server端生成的随机字符串
+ 返回server端的ssl证书
![](/assets/img/tool/http/003.png)

### 第三个阶段
client端在收到server端的证书后，先解析证书上的公钥，然后使用此公钥加密生成一个随机字符串，然后返回如下信息给server端

+ 使用证书公钥加密的随机字符串
+ 以后通信改用加密方式的编码通知
+ 握手阶段结束的通知
![](/assets/img/tool/http/004.png)

client端除了发送上述信息外，还会使用前面两个阶段以及这个阶段中的三个字符串，生成一个会话密钥，此次与该server的通信均使用该会话密钥进行加密

### 第四个阶段
server端在收到第三阶段中client段传输过来的加密密钥后，也会使用上面阶段的三个字符串生成一个会话密钥。至此client端和server端都生成了同一份会话密钥，但并没有传输过，所有后续采用该会话密钥加密的报文均是安全的。
这个阶段server端还会发送如下确认信息给client端，之后连接阶段结束，client端会使用会话密码对报文进行加密传输到server端。

![](/assets/img/tool/http/005.png)

## ssl证书
生成ssl证书需要借助openssl toolkit。该工具包的bin目录内包含有openssl.exe用户处理下面要使用到的指令

### 生成私钥
使用genrsa指令生成私钥，包含如下一些参数

+ des3:生成私钥的算法
+ 私钥长度：如1024,2048等，长度越长使用时客户端和服务端消耗的时间越长
+ 输出文件名：如server.key

``` bash
genrsa -des3 -out server.key 1024;
```

在生成私钥文件的过程中，需要填写一个加密密码。这个加密密码在服务器上部署时需要填写验证。下面指令可以去除这个加密密码

``` bash
rsa -in server.key -out server.key;
```

### 生成csr申请文件
csr证书申请文件也适用req指令，需要输入私钥文件作为参数

``` bash
req -new -key server.key -out server.csr;
```

输入指令后，需要设定一些签署的信息，包含有国家，地区，组织等，最重要的是commonname，该项需要正确输入该证书所适用的域名。
![](/assets/img/tool/http/001.png)

### 生成CA签署文件
上面生成的csr申请文件需要有机构签署后才能生效，这个签署动作可以交由第三方的ssl证书服务商，也可以自己生成签署文件进行签署。这两者的区别在于第三方ssl证书服务商是可信任的，而自己签署的是不可信任的，在使用时浏览器会进行警告。
生成一个CA签署文件需要使用req指令，包含如下参数

+ 证书的格式，如：x509
+ 私钥文件，如：server.key
+ 有效期限,如：days 3650(十年)

``` bash
req -new -x509 -key server.key -out ca.crt -days 3650
```

同生成csr文件一样，指令输入后也需要输入一些签署信息。

### 生成证书
自己生成的证书需要csr文件，CA文件，server.key，参数如下

+ 证书格式：x509
+ 有效期限: -days 3650
+ 三个文件
+ 序列号：-CAcreateserial如果没有序列号文件，则自己生成一个序列号

``` bash
x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey server.key -CAcreateserial -out server.crt
```

最后生成server.crt文件，加上上面生成的server.key文件组成了ssl需要的证书和私钥。如果还需要将x509格式的证书转换成pkcs12等格式的证书话，可使用下面的指令进行转换

``` bash
openssl pkcs12 -export -inkey server.key -in server.crt -out server.pfx
```