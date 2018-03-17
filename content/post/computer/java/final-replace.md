---
title: "Final变量机制"
date: 2018-03-17T11:34:55+08:00
tags: ["computer", "java"]
---

<!--more-->
## 基本类型
final标记的基本类型变量在初始化之后就不可再修改变量的值。final基本类型变量的有两种初始化方式

+ 第一种是赋予可在编译器确认的具体值
+ 第二种是在运行时计算获得

第一种方式创建的变量，编译器会在编译时就计算结果，减少程序在运行时的计算量。

``` java
// source
public class Test {
   public static final int num = 10 + 10;
}
// 反编译
public class Test {
    public static final int num = 20;
}
```

除了计算值之外，编译器还会将程序中所有使用该变量的位置都替换成该变量的计算结果。在运行时免去的变量的调用，而是直接使用计算结果的字面值。

``` java
// source
public class Test {
   public static final int num = 10 + 10;
      public static void main(String[] args) {
       System.out.println(num);
   }
}
// 反编译
public class Test {
    public static final int num = 20;
        public static void main(String[] args) {
        System.out.println(20);
    }
}
```

第二种方式创建的变量，在编译时无法做优化，不能计算结果，不能做替换动作。

``` java
public class Test {
   public static final int random = (int)(Math.random()*20);
      public static void main(String[] args) {
       System.out.println(random);
   }
}
public class Test {
   public static final int random = (int)(Math.random() * 20.0D);
      public static void main(String[] args) {
       System.out.println(random);
   }
}
```

## 引用类型
final标记的引用类型在运行时不能修改变量所引用的地址，但是引用地址所存储的引用类型实例是可变的，所以还是具有可变性。

``` java
public class Test {
      public static void main(String[] args) {
            final Person person = new Person();
            person.setName("tim");
            person.setName("tom");
   }
}
```

## 替换魔法值
代码重构中，魔法值问题是需要去重构的。对于魔法值有两种方式的统一管理。
第一种是使用Enum，将有限的魔法值定义到Enum中，使用Enum的值来替换魔法值
第二种是使用常量, 使用常量定义魔法值，然后使用常量替换魔法值

使用Enum的方式时，每个魔法值都会在运行时生成一个Enum实例，这种方式的性能损耗相较大

``` java
public enum SeasonEnum {
    SPRING("spring"),
    SUMMER("summer");

    private String name;
    private SeasonEnum(String name) {
        this.name = name;
    }
    public String toString() {
        return this.name;
    }
}
public class Test {
    public void done(String season) {
       if (SeasonEnum.SPRING.toString().equals(season)) {
           // do something
       }
    }
}
```

使用常量方式时，常量值只存在代码层，在运行时并不需要有实例参与，所以性能上没有损耗。

``` java
public interface Season {
    String SPRING = "spring";
    String SUMMER = "summer";
}
public class Test {
   public void done2(String season) {
       if (Season.SPRING.equals(season)) {
           // do something
       }
   }
}
```
