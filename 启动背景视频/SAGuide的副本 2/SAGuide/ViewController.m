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


/**  */
@property (nonatomic, strong) UIButton  *button;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _v  = [[SAGuideView alloc]init];
    
    NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"1111.png"],[UIImage imageNamed:@"1112.png"],[UIImage imageNamed:@"1113.png"], nil];
    
    NSMutableArray *viewarray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 3; i++) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(120, 290, 80, 40);
        [_button setTitle:@"播放" forState:0];
        _button.backgroundColor = [UIColor redColor];
        [self.view addSubview:_button];
        [viewarray addObject:_button];
    }
    NSLog(@"-----%@",viewarray);
    
    [_v  showIconImgArray:array andViewArray:viewarray ];

}

- (void)viewDidLoad {
    [super viewDidLoad];
   }






@end
