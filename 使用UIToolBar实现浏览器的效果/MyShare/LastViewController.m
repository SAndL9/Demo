//
//  LastViewController.m
//  MyShare
//
//  Created by lanouhn on 15/5/10.
//  Copyright (c) 2015年 赵鹏飞. All rights reserved.
//

#import "LastViewController.h"
#import "HZActivityIndicatorView.h"
#import "HZActivityIndicatorSubclassExample.h"

@interface LastViewController ()

@end

@implementation LastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的百度";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismis)];
    // Do any additional setup after loading the view from its nib.
    HZActivityIndicatorView *activityIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(165, 250, 0, 0)];
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
    [self performSelector:@selector(push) withObject:nil afterDelay:2.0f];
}

- (void)push {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baidu.com"]]];
    [self.view addSubview:webView];
}

- (void)dismis {
    [self dismissViewControllerAnimated:YES completion:nil];
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
