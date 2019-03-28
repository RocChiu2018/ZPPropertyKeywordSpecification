//
//  ZPCat.m
//  strong和weak的区别
//
//  Created by 赵鹏 on 2019/2/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZPCat.h"

@interface ZPCat () <NSCopying>

@end

@implementation ZPCat

/**
 copy方法内部会调用这个方法，所以必须要实现这个方法；
 方法中的参数zone代表内存空间；
 方法中的self代表调用copy方法的对象。
 */
- (id)copyWithZone:(NSZone *)zone
{
    ZPCat *cat = [[ZPCat allocWithZone:zone] init];
    cat.age = self.age;
    cat.money = self.money;
    
    return cat;
}

-(void)setName:(NSString *)name
{
    NSLog(@"%@", name);
    
    /**
     使用copy关键字修饰name对象属性的时候会运行这句代码；
     传过来的name参数是一个可变字符串对象，当它调用copy方法的时候是深复制，把复制出来的新对象赋给"_name"成员变量。这个时候_name成员变量和视图控制器类中的mulStr对象是两个不同的对象，并且有两个不同的强指针指着，改变其中的任意对象不会影响另一个对象。
     */
    _name = [name copy];
    
    /**
     使用strong关键字修饰name对象属性的时候会运行这句代码；
     传过来的name参数是一个指针变量，它的实际内容是在视图控制器中的jack字符串对象所对应的那块内存区域的地址，然后把这个地址值赋给了"_name"成员变量，这样的话"_name"成员变量（指针变量）和视图控制器中的mulStr指针变量都用强指针指着jack字符串对象所对应的那块内存区域。改变"_name"和mulStr其中的某一个都会影响到另外一个，因为它俩指向的是同一块内存区域。
     */
//    _name = name;
    
    /**
     总结：NSString类型的对象属性为什么要用copy而不用strong关键字来进行修饰呢？因为要用strong关键字来修饰的话，在赋值的时候就类似于浅复制，会造成多个指针指向同一块内存区域（NSString对象），那样的话只要改变其中的一个另外几个就都跟着变了。如果要用copy关键字修饰的话，在赋值的时候就类似于深复制，会创建一个新的字符串对象并且有一个新的指针指着它，那样的话改变其中的一个不会影响另外的几个。
     */
}

@end
