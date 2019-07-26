//
//  RootViewController.m
//  仿射变换
//
//  Created by 徐赢 on 13-7-4.
//  Copyright (c) 2013年 徐赢. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    CGPoint point = CGPointMake(10, 10);
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(20, 0);
    
    CGPoint point1 = CGPointApplyAffineTransform(point, t);
    NSLog(@"point1 = %@",NSStringFromCGPoint(point1));
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.aView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    self.aView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.aView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 400, 100, 44);
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)tapButton
{
    
    //仿射 CGAffineTransform
    [UIView animateWithDuration:3 animations:^{
        //仿射--平移
        
        //创建一个仿射矩阵
        //新点的位置，比原来点的位置，向右100个单位
        CGAffineTransform t_translation = CGAffineTransformMakeTranslation(100, 100);
        
        
        
       // self.aView.transform =t_translation;
        
        //仿射--旋转(整数为顺时针,为弧度)
        CGAffineTransform t_Rotation = CGAffineTransformMakeRotation(3.14/4);
        
//        CGAffineTransform t3 = CGAffineTransformTranslate(t_Rotation, 100, 100);
        self.aView.transform = t_Rotation;
        
        
        //仿射--缩放
        CGAffineTransform t_Scale = CGAffineTransformMakeScale(2, 0.5);
       // self.aView.transform = t_Scale;
        
        
        //缩放的同时进行平移
        CGAffineTransform t1 = CGAffineTransformConcat(t_Scale, t_translation);
//        t1 = CGAffineTransformConcat(t1, t_Rotation);
        self.aView.transform = t1;
        
        

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
