---
title: "Base64编码"
date: 2017-12-30T16:23:49+08:00
tags: ["computer", "info"]
---
探究Base64编码
<!--more-->

### 了解Base64
Base64编码可以将任意二进制数据转换成由Base64字符组成的字符串。相比较ASCII字符编码的8位编码，Base64采用6位编码。ASCII可容纳字符数量位2<sup>8</sup>=256个，Base64只可容纳字符数量位2<sup>6</sup>=64个。这64个字符包含有a-z,A-Z,0-9以及符号+和/，具体映射表如下

|数值|字符|数值|字符|数值|字符|数值|字符|
|---|---|---|---|---|---|---|---|
|0|A|16|Q|32|g|48|w|
|1|B|17|R|33|h|49|x|
|2|C|18|S|34|i|50|y|
|3|D|19|T|35|j|51|z|
|4|E|20|U|36|k|52|0|
|5|F|21|V|37|l|53|1|
|6|G|22|W|38|m|54|2|
|7|H|23|X|39|n|55|3|
|8|I|24|Y|40|o|56|4|
|9|J|25|Z|41|p|57|5|
|10|K|26|a|42|q|58|6|
|11|L|27|b|43|r|59|7|
|12|M|28|c|44|s|60|8|
|13|N|29|d|45|t|61|9|
|14|O|30|e|46|u|62|+|
|15|P|31|f|47|v|63|/|

计算机的内存中一个字节包含有8位，一个“Man”字符串会占据3个字节的内存空间，在ACSII编码下的二进制数据如下

![](/assets/img/computer/base6401.png)

如果将上面字符的二进制位使用base64进行编码，则需要从起始位置开始，每6位作为一个字符单元进行编码。

![](/assets/img/computer/base6402.png)

上面的"Man"字符串一共时占据3个字节共24位。采用ACSII和Base64编码时，在长度上都刚刚好，不会有多也不会有少。这是一种长度刚刚好的情况，很多情况下这种长度并不是刚刚好匹配的。例如一个"A"字符只包含8位，在使用Base64编码时如果采用一个编码单元的话，则会丢失掉两位的数据。如果采用两个或者三个编码单元的话，都不符合物理内存的长度定义(12位/16位长度都不能刚好确认字节数)，则至少需要采用四个编码单元。多出来的编码单元都需要使用0进行补码。

![](/assets/img/computer/base6403.png)

Base64在解析补码的编程单元时，会使用"="来表示。

![](/assets/img/computer/base6404.png)

### 使用Base64
上面的例子中是使用Base64编码格式重新编码ACSII字符串的字节数据，这种使用方式会白白增加内存体积，所以意义不大。Base64适用的是对真正的二进制数据进行编码，例如http协议下对图片等二进制数据进行编码后进行传输。

``` java
File file = new File("/home/eric/test.png");
InputStream inputStream = new FileInputStream(file);
BufferedInputStream bufferedInputStream = new BufferedInputStream(inputStream);
byte[] date = new byte[1024];
int lenght = 0;
ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
while ((lenght = bufferedInputStream.read(date)) != -1) {
    byteArrayOutputStream.write(date, 0, lenght);
}
byte[] result = byteArrayOutputStream.toByteArray();
String encode = Base64.getEncoder().encodeToString(result);
```

### 注意点
下面使用上面的"Man"作为例子来解析Base64编码过程中的一个有意思的点。看下面的例子中先获取"Man"字符的ACSII编码二进制数据，然后获取Base64编码下的二进制数据。

``` java
String man = "Man";
byte[] manByte = man.getBytes(); // {77，97，110} 对应ACSII下的M,a,n字符
byte[] manBase64Byte = Base64.getEncoder().encode(manByte); // {84,87,70,117}
String manBase64Str = Base64.getEncoder().encodeToString(manByte);
```

从结果上看Base64编码的二进制数据很奇怪，按照上面的规则来说，正常的补码并不是这样的结果。比如'M'字符的ACSII编码的二进制数据是01001101(即十进制77),Base64编码下取前六位再补码后应该是00010011(即十进制19)，但是这里的结果是84。

这里不只是单纯的Base64的转码。为了显示Base64字符，在编码成Base64后会再将每个Base64字符再编码成该字符在ACSII下的编码。在反编译回来时，也是先确认ACSII编码下映射的字符，然后根据该字符确认Base64下编码值。