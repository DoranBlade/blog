---
title: "annotation的值"
date: 2017-12-30T16:39:33+08:00
tags: ["computer", "java"]
---
探究annotation的值
<!--more-->

annotation可以接受基本数据类型，String和Enum。在使用annotation时，必须指定能在编译时就能确定的值。

``` java
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Description{
    String desc() default "";
    int companyId() default 0;
}
// use
public class Test{
    @Description(desc="test", companyId=1)
    public void test(){}
}
```

在取值不固定的时候只能在使用时再指定，但很多时候取值其实是固定的，例如上面的companyId字段。在这种情况下最简单的方式是使用Enum来定义每种的可选值，就可以在使用时限定取值范围。这样有利于后续的重构和减少取值不当的错误。

``` java
public enum CompanyId(){
    YG(1),YA(2);
    private int id;
    private CompanyId(int id) {
        this.id = id;
    }
}
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Description{
    String desc() default "";
    CompanyId companyId() default CompanyId.YG;
}
// use
public class Test{
    @Description(desc="test", companyId=CompanyId.YA)
    public void test(){}
}
```

除了Enum之外，要限定取值范围还可以使用静态常量来实现。有一个小问题需要留意，仅仅使用static关键字修饰的静态变量是不能直接复制给annotation字段的。原因在于annotation的值需要在编译时就完全确定，而static修饰的变量需要在运行时使用到该类才会有类加载器进行加载，这个值就需要在运行时才能确定。话说回来，只有使用static final修饰的变量才会在编译时由其值所替代，才是在编译时就能确定的值。

``` java
public class CompanyId{
    public static final int YG = 1;
    public static final int YA = 2;
}
// use
public class Test{
    @Description(desc="test", companyId=CompanyId.YA)
    public void test(){}
}
```