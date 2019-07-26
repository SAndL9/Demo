//
//  SecondViewController.m
//  CALayer切换动画
//
//  Created by 徐赢 on 13-7-5.
//  Copyright (c) 2013年 徐赢. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

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
    
    self.view.backgroundColor = [UIColor greenColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 200, 100, 44);
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)tapButton
{
    CATransition * trans = [CATransition animation];
    trans.duration = 3;
    trans.type = @"cube";
    trans.subtype = kCATransitionFromLeft;
    
    
    
    [self.navigationController.view.layer addAnimation:trans forKey:nil];

    [self.navigationController popViewControllerAnimated:NO];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
