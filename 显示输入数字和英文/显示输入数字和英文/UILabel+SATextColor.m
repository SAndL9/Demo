//
//  UILabel+SATextColor.m
//  显示输入数字和英文
//
//  Created by 李磊 on 8/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "UILabel+SATextColor.h"
#import <objc/runtime.h>
@implementation UILabel (SATextColor)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(setTextColor:));
    Method myimp = class_getInstanceMethod([self class], @selector(mySetTextColor:));
    method_exchangeImplementations(imp, myimp);
}

- (void)mySetTextColor:(UIColor *)color{
    
    
    
//    if (self) {
        [self mySetTextColor:[UIColor redColor]];
//    }
  
    
}
@end
