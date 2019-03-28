//
//  ZPDog.h
//  strong和weak的区别
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPerson;

@interface ZPDog : NSObject

@property (nonatomic, assign) int age;
@property (nonatomic, assign) double money;
@property (nonatomic, copy) NSString *name;

@end
