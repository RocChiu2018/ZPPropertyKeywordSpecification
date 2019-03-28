//
//  ZPPerson.h
//  strong和weak的区别
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPDog;

@interface ZPPerson : NSObject

//要用strong关键字来修饰对象属性。
@property (nonatomic, strong) ZPDog *dog;

@end
