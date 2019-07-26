//
//  HKPerson.m
//  001--runtime初体验
//
//  Created by H on 16/5/22.
//  Copyright © 2016年 TanZhou. All rights reserved.
//

#import "HKPerson.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface HKPerson ()<NSCoding>
@property(nonatomic,strong)UIImage * image;

@end

@implementation HKPerson

- (void)encodeWithCoder:(NSCoder *)coder
{
    //归档
    unsigned int count = 0;//属性个数!!!
    Ivar * ivars = class_copyIvarList( [self class], &count);

    for (int i = 0; i < count; i ++) {
    Ivar ivar = ivars[i];
    const char * name = ivar_getName(ivar);
    NSString * ocName = [NSString stringWithUTF8String:name];
        [coder encodeObject:[self valueForKey:ocName] forKey:ocName];
    }
    //在C语言里面一旦用到了 creat new copy 就需要释放
    free(ivars);
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        //解档
        unsigned int count = 0;//属性个数!!!
        Ivar * ivars = class_copyIvarList( [self class], &count);
        
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString * ocName = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:ocName];
            [self setValue:value forKey:ocName];
        
        }
        
        free(ivars);
    }
    return self;
}


    
    
@end

