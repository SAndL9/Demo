//
//  RootViewController.m
//  图层CALayer
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //视图图层
    //UIView，显示东西，东西其实是Layer（图层显示）
    //当创建view的时候，view本身由创建了一个layer
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    aView.backgroundColor = [UIColor redColor];
    [self.view addSubview:aView];
    
    CALayer * layer = aView.layer;
    //圆角
    layer.cornerRadius = 10;
    //加阴影
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(5, 5);
    
    //加边框
    layer.borderColor = [UIColor purpleColor].CGColor;
    layer.borderWidth = 2;
    
    
    CALayer * aLayer = [CALayer layer];
    aLayer.frame = CGRectMake(10, 10, 30, 30);
    aLayer.backgroundColor = [UIColor blueColor].CGColor;
    [layer addSublayer:aLayer];
    
    
   CGColorRef color_ref = layer.backgroundColor;
    UIColor * color = [UIColor colorWithCGColor:color_ref];
    
    NSLog(@"red = %@",[UIColor redColor]);
    NSLog(@"col = %@",color);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
