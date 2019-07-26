//
//  RainbowView.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/15.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "RainbowView.h"

@interface RainbowView ()
// 1-男   2-女
@property (nonatomic, assign) NSInteger type;
@end

@implementation RainbowView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        [self createContent];
    }
    return self;
}

- (void)createContent
{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height/2)];
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:_type == 1 ? @"彩虹 男版" : @"彩虹 女版"];
    [backView addSubview:imageView];
    
    CGFloat W = imageView.bounds.size.height;

    // 遮盖视图动画
    UIView *markView = [[UIView alloc] initWithFrame:imageView.bounds];
    [imageView addSubview:markView];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.315*W;
    
    // 贝塞尔二次曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.15*W, W + 5)];
    [path addQuadCurveToPoint:CGPointMake(W + 5, 0.15*W) controlPoint:CGPointMake(0.28*W, 0.28*W)];
    layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:nil];

    
    [markView.layer addSublayer:layer];
    
    
    // 方式一:旋转
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.fromValue = 0;
//    animation.toValue = [NSNumber numberWithFloat:M_PI_2];
//    animation.repeatCount = 1;
//    animation.duration = 0.3;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.layer addAnimation:animation forKey:nil];
//    });
}

@end
