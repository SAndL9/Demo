//
//  ShowViewController.m
//  不规则截图
//
//  Created by macbook on 16/8/2.
//  Copyright © 2016年 macbook. All rights reserved.
//
#define SCREEN [UIScreen mainScreen].bounds

#import "ShowViewController.h"
#import "MaskView.h"

@interface ShowViewController ()
/** imageView */
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(SCREEN), CGRectGetHeight(SCREEN)*0.38)];
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

- (void)setImage:(UIImage *)image {
    [self setImage:image withPoints:nil];
}

- (void)setImage:(UIImage *)image withPoints:(NSArray *)array {
    if (array) {
        self.image = [self createImageWithImage:image andPoints:array];
    }
    else {
        self.image = image;
    }
    self.imageView.image = self.image;
}

- (UIImage *)createImageWithImage:(UIImage *)image andPoints:(NSArray *)array{
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    [array enumerateObjectsUsingBlock:^(TPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[array objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        }
        else {
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }];
    
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImage;
}

@end
