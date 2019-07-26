//
//  UIViewController+swizzling.m
//  显示输入数字和英文
//
//  Created by 李磊 on 8/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "UIViewController+swizzling.h"
#import <objc/runtime.h>
@implementation UIViewController (swizzling)

+ (void)load{
    //方法的交换保证只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取viewController的selcttor
        SEL systemSel = @selector(viewWillAppear:);
        //自己写的 要交换的方法
        SEL swizzSel = @selector(swiz_viewWillAppear:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //首先动态添加方法 实现是被交换的方法 返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod),method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功 说明类中不存在这个方法的实现
            //将被交换方法的实现替换到 这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            //可以实现两个方法的交换
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
        
        
    });
}

- (void)swiz_viewWillAppear:(BOOL)animated{
    //实现自己的方法
    [self swiz_viewWillAppear:animated];
 
}


@end
