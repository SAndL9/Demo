//
//  RootViewController.m
//  MyShare
//
//  Created by lanouhn on 15/5/10.
//  Copyright (c) 2015年 赵鹏飞. All rights reserved.
//

#import "RootViewController.h"
#import "HZActivityIndicatorView.h"
#import "HZActivityIndicatorSubclassExample.h"
#import "LastViewController.h"


@interface RootViewController () {
    HZActivityIndicatorView *activityIndicator;
}



@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor yellowColor];
    
    //UIToolBar继承于UIView
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50)];
    
    //设置渲染色
    toolBar.tintColor = [UIColor blueColor];
    
    //设置背景色
    toolBar.barTintColor = [UIColor colorWithRed:0.132 green:1.000 blue:0.195 alpha:1.000];
    
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 25, 10, 50, 30);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"百度" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:button];
    
    [self.view addSubview:toolBar];
    
}

- (void)change {
    NSLog(@"123");
    activityIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(165, 250, 0, 0)];
    activityIndicator.backgroundColor = self.view.backgroundColor;
    activityIndicator.opaque = YES;
    activityIndicator.steps = 8;
    activityIndicator.finSize = CGSizeMake(17, 10);
    activityIndicator.indicatorRadius = 20;
    activityIndicator.stepDuration = 0.150;
    activityIndicator.color = [UIColor colorWithRed:85.0/255.0 green:0.0 blue:0.0 alpha:1.000];
    activityIndicator.cornerRadii = CGSizeMake(0, 0);
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    [self performSelector:@selector(push) withObject:nil afterDelay:1.0f];
}

- (void)push {
    LastViewController *lastVC = [LastViewController new];
    UINavigationController *lastNavC = [[UINavigationController alloc] initWithRootViewController:lastVC];
    [self presentViewController:lastNavC animated:YES completion:nil];
    [activityIndicator removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
