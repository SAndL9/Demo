//
//  RootViewController.m
//  CALayer切换动画
//
//  Created by 徐赢 on 13-7-5.
//  Copyright (c) 2013年 徐赢. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"
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

// 设定动画类型
// kCATransitionFade 淡化
// kCATransitionPush 推挤
// kCATransitionReveal 揭开
// kCATransitionMoveIn 覆盖

// @"cube" 立方体
// @"suckEffect" 吸收
// @"oglFlip" 翻转
// @"rippleEffect" 波纹
// @"pageCurl" 翻页
// @"pageUnCurl" 反翻页
// @"cameraIrisHollowOpen" 镜头开
// @"cameraIrisHollowClose" 镜头关
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.aLayer = [CALayer layer];
    self.aLayer.frame = CGRectMake(20, 20, 280, 300);
    self.aLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:self.aLayer];
    
    self.bLayer = [CALayer layer];
    self.bLayer.frame = CGRectMake(40, 40, 40, 40);
    self.bLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.aLayer addSublayer:self.bLayer];
    
    
    self.cLayer = [CALayer layer];
    self.cLayer.frame = CGRectMake(80, 80, 40, 40);
    self.cLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 300, 100, 44);
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)tapButton
{
    CATransition * transition = [CATransition animation];
    transition.duration = 3;
    transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
   /*
    
    //修改layer的子视图，或本身的一些属性
    [self.bLayer removeFromSuperlayer];
    [self.aLayer addSublayer:self.cLayer];
    self.aLayer.backgroundColor = [UIColor orangeColor].CGColor;
    
    
    [self.aLayer addAnimation:transition forKey:nil];
    */
    SecondViewController * sec = [[SecondViewController alloc]init];
    
    [self.navigationController pushViewController:sec animated:NO];
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
