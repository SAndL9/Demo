//
//  ViewController.m
//  不规则截图
//
//  Created by macbook on 16/8/1.
//  Copyright © 2016年 macbook. All rights reserved.
//

//#define Width CGRectGetWidth([UIScreen mainScreen].bounds)
//#define Height CGRectGetHeight([UIScreen mainScreen].bounds)
#import "ViewController.h"

@interface ViewController ()
/** imageView */
@property (strong, nonatomic) UIImageView *imageView;
/** view1 */
@property (strong, nonatomic) UIImageView *view1;
/** view2 */
@property (strong, nonatomic) UIImageView *view2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 300, 200)];
    [self.imageView setImage:[UIImage imageNamed:@"01"]];
    
    UIImage *image1 = [self createImage1];
    self.view1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 230, 300, 200)];
    [self.view1 setImage:image1];
    
    UIImage *image2 = [self createImage2];
    self.view2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 440, 300, 200)];
    [self.view2 setImage:image2];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.view1];
    [self.view addSubview:self.view2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIImage *)createImage1 {
    UIGraphicsBeginImageContext(CGSizeMake(300, 200));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, 10, 10);
    CGContextAddLineToPoint(ctx, 200, 50);
    CGContextAddLineToPoint(ctx, 280, 150);
    CGContextAddLineToPoint(ctx, 20, 180);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextFillPath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
//    CGContextClosePath(ctx);
    return image;
}

- (UIImage *)createImage2 {
    UIGraphicsBeginImageContext(CGSizeMake(300, 200));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, 10, 10);
    CGContextAddLineToPoint(ctx, 200, 50);
    CGContextAddLineToPoint(ctx, 280, 150);
    CGContextAddLineToPoint(ctx, 20, 180);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    [[UIImage imageNamed:@"01"]drawInRect:CGRectMake(0, 0, 300, 200)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
