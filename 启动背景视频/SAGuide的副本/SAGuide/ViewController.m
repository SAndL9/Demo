//
//  ViewController.m
//  SAGuide
//
//  Created by 李磊 on 26/7/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "ViewController.h"
#import "SAGuideView.h"
@interface ViewController ()


/**  */
@property (nonatomic, strong) SAGuideView * v;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _v  = [[SAGuideView alloc]init];
    
    NSArray *array = [NSArray arrayWithObjects:
                    [UIImage imageNamed:@"novice_ boot_one.png"],[UIImage imageNamed:@"novice_ boot_two.png"],[UIImage imageNamed:@"novice_ boot_three.png"],[UIImage imageNamed:@"novice_ boot_four.png"], nil];
    
    [_v showIconImgArray:array];

}

- (void)viewDidLoad {
    [super viewDidLoad];
        
}






@end
