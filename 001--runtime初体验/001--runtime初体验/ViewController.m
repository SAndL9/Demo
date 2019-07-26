//
//  ViewController.m
//  001--runtime初体验
//
//  Created by H on 16/5/22.
//  Copyright © 2016年 TanZhou. All rights reserved.
//
/*  runtime官方文档字面翻译: iOS中的黑魔法!!
 runtime(运行时) : 底层C语言的库.包含了很多C语言API
 概念: OC在运行的过程中,都会被编译器编译成 runtime运行时C语言..
 
 有什么用: runtime属于OC的底层实现,可以进行一些非常底层的操作(OC无法实现)
        1.利用runtime,在程序运行的过程中,动态创建一个类!
        2.利用runtime,在程序运行的过程中,动态的为某个类添加属性\方法,修改属性\方法
        3.遍历一个类的所有成员变量
 
 怎么用:
        头文件:    <objc/runtime>
                        class_copyIvarList  拷贝成员列表!!
                        class_getName  通过类获得(C语言字符)名称
                  <objc/message>
                        objc_msgSend
                        objc_msgSendSuper
     
        两个常识:
            |--   Method   成员方法(函数)
            |--   Ivar     成员属性(变量)
 
 
 应用场景: 归档!
        KVO 底层实现原理: 利用runtime运行时
            利用runtime在运行的时候动态添加创建一个对象 NSKVONotifing_XX类 类名  重写SetAge方法
        [self willChangeValueForKey:@"age"];
        [self didChangeValueForKey:@"age"];
 
 
 Runloop:
 */

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    unsigned int count = 0;//属性个数!!!
//    unsigned int * cut = &count;
    Ivar * ivars = class_copyIvarList( NSClassFromString(@"HKPerson"), &count);
    Ivar ivar = ivars[0];
    const char * name = ivar_getName(ivar);
    NSString * ocName = [NSString stringWithUTF8String:name];
    NSLog(@"%@",ocName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
