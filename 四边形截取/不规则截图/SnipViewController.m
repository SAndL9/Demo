//
//  SnipViewController.m
//  不规则截图
//
//  Created by macbook on 16/8/2.
//  Copyright © 2016年 macbook. All rights reserved.
//

#define SCREEN [UIScreen mainScreen].bounds

#import "SnipViewController.h"
#import "MaskView.h"
@interface SnipViewController ()
/** imageView */
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation SnipViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(SCREEN), CGRectGetHeight(SCREEN)*0.38)];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.image = self.image;
    
//    self.imageView.image = [self createImage];
    
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
