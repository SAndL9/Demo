//
//  ViewController.m
//  dealTime
//
//  Created by xiaohuihui on 2016/12/5.
//  Copyright © 2016年 30-陈辉华. All rights reserved.
//

#import "ViewController.h"
#import "NSDate+Category.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //http://www.jianshu.com/p/e42431045177
    [self demo1];
}

- (void)demo1 {
    NSString *timeString = @"Mon Dec 05 11:56:38 +0800 2016";
    NSDate *timeDate = [NSDate timeStringToDate:timeString];
    NSLog(@"--%@",timeDate);
    
    NSDate *date = [NSDate date];
    NSLog(@"多久了----%@",[date dateToRequiredString]);
    
    NSString *requiredString = [timeDate dateToRequiredString];
    NSLog(@"--%@",requiredString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
