//
//  RootViewController.m
//  VIew动画
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
//UIView的动画
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 320, 400)];
    tempView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:tempView];
    
    self.aView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    self.aView.backgroundColor = [UIColor redColor];
    [tempView addSubview:self.aView];
    
    self.bView = [[UIView alloc]initWithFrame:CGRectMake(200, 200, 50, 50)];
    self.bView.backgroundColor = [UIColor orangeColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 400, 100, 44);
    [button addTarget:self action:@selector(tapButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)tapButton1
{
    //让self.view做一个动画，在动画过程中，将aView移出，同时将bView添加到self.view上
    
    //动画默认加在fromView的父view身上
    //fromView就是想要移出的view
    //toView就是想要添加的view
    [UIView transitionFromView:self.aView toView:self.bView duration:3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        //完成时的回调
    }];
    
}
-(void)tapButton
{
    //让aView改变frame做动画
    

    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //动画终点
        self.aView.backgroundColor = [UIColor blueColor];
       // self.aView.alpha = 0;
       // self.aView.center = CGPointMake(300, 300);
    } completion:^(BOOL finished) {
        //当动画结束的时候，回调此block
        NSLog(@"finished = %d",finished);
        //创建一个动画，用来修改center
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //动画终点
            self.aView.center = CGPointMake(300, 300);
        } completion:^(BOOL finished) {
            //完成是回调
            //创建一个改变透明度的动画
        }];
    }];

    
    
   // self.aView.frame = CGRectMake(200, 200, 100, 100);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
