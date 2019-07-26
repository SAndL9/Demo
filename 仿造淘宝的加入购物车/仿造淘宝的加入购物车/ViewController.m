//
//  ViewController.m
//  仿造淘宝的加入购物车
//
//  Created by zhou on 16/8/8.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *choseView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *bgView = [[UIView alloc]init];
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    UIButton *btn_add= [UIButton buttonWithType:UIButtonTypeCustom];
    btn_add.frame = CGRectMake(100, 80,200, 50);
    [btn_add setTitleColor:[UIColor whiteColor] forState:0];
    btn_add.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn_add setTitle:@"加入购物车" forState:0];
    btn_add.backgroundColor = [UIColor redColor];
    btn_add.layer.cornerRadius = 4;
    btn_add.layer.borderColor = [UIColor clearColor].CGColor;
    btn_add.layer.borderWidth = 1;
    [btn_add.layer setMasksToBounds:YES];
    [btn_add addTarget:self action:@selector(btnselete:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn_add];
    
    UIView *choseView = [[UIView alloc] init];
    self.choseView = choseView;
    choseView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    choseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:choseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.choseView addGestureRecognizer:tap];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    whiteView.backgroundColor = [UIColor whiteColor];
    [choseView addSubview:whiteView];
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, -20, 100, 100);
    imageView.image = [UIImage imageNamed:@"1"];
    imageView.layer.cornerRadius = 5;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 5;
    [whiteView addSubview:imageView];
    
}
/**
 *  加入购物车
 */
- (void)btnselete:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        self.bgView.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        self.choseView.center = self.view.center;
        
    }];
    
}


- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.choseView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        
        self.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        self.bgView.center = self.view.center;
        
    }];
}

@end
