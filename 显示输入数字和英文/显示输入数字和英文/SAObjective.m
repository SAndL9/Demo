//
//  SAObjective.m
//  显示输入数字和英文
//
//  Created by 李磊 on 8/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SAObjective.h"
#import <objc/runtime.h>
@implementation SAObjective


+ (void)load{
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0 ; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property-------->%@",[NSString stringWithUTF8String:propertyName]);
    }
    
}
@end
