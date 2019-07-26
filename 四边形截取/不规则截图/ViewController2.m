//
//  ViewController2.m
//  不规则截图
//
//  Created by macbook on 16/8/1.
//  Copyright © 2016年 macbook. All rights reserved.
//

#define SCREEN [UIScreen mainScreen].bounds

#import "ViewController2.h"
#import "SnipViewController.h"
#import "MaskView.h"

@interface ViewController2 ()
/** imageView */
@property (strong, nonatomic) UIImageView *imageView;
/** mView */
@property (strong, nonatomic) MaskView *mView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加imageView 就是那张照片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(SCREEN), CGRectGetHeight(SCREEN)*0.38)];
    imageView.image = [UIImage imageNamed:@"01"];
    self.imageView = imageView;
    
    
    //这个是截图用的视图 是自定义的 添加到上面的imageView里面 大小一样
    MaskView *mView = [[MaskView alloc] initWithFrame:imageView.frame];
    self.mView = mView;
    
    [self.view addSubview:imageView];
    [self.view addSubview:mView];
    
    
    //添加截图按钮  绑定的方法在下面
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(50, 500, CGRectGetWidth(SCREEN)-100, 50)];
    [btn addTarget:self action:@selector(snip:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"截图" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    [self.view addSubview:btn];
    
}


- (void) :(UIButton *)button {
    
    //下面这个方法是自定义视图MaskView里面的实例方法 作用是返回当前的截图
    UIImage *image = [self.mView getSnipImageWithImage:self.imageView.image];
    
    //初始化SnipViewController 下面的初始化方法相当于重写了init方法 在里面直接把截图传递进去 没什么特别的内容
    SnipViewController *controlller = [[SnipViewController alloc] initWithImage:image];
    
    //模态切换
    [self presentViewController:controlller animated:YES completion:^{
        
    }];
}


@end
