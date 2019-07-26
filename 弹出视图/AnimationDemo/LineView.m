//
//  LineView.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/15.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "LineView.h"

@interface LineView ()
// 1-往左跑   2-往右跑
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIImageView *imageView_1;
@property (nonatomic, strong) UIImageView *imageView_2;
@property (nonatomic, strong) UIImageView *imageView_3;
@property (nonatomic, assign) CGFloat width;
@end

@implementation LineView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.type = type;
        self.width = frame.size.width;
        self.clipsToBounds = YES;
        
        [self createContent];
    }
    return self;
}

- (void)createContent
{
    CGFloat H = self.frame.size.height;
    CGFloat W = 0.7 * _width;
    CGFloat lineH = 2;
    _imageView_1 = [self createImageViewWithFrame:CGRectMake(_width, 0, W, lineH)
                                        imageName:_type == 1 ? @"上1" : @"下1"];
    _imageView_2 = [self createImageViewWithFrame:CGRectMake(_width, 0.46*H, W, lineH)
                                        imageName:_type == 1 ? @"上2" : @"下2"];
    _imageView_3 = [self createImageViewWithFrame:CGRectMake(_width, H - lineH, W, lineH)
                                        imageName:_type == 1 ? @"上3" : @"下3"];
    [self addSubview:_imageView_1];
    [self addSubview:_imageView_2];
    [self addSubview:_imageView_3];
    
    if (self.type == 1)
    {
        [self leftMoveAnimation];
    }else
    {
        [self rightMoveAnimation];
    }
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

- (void)leftMoveAnimation
{
    CGFloat duration = 3;

    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation1.keyTimes = @[@0,
                            @0.15,
                            @0.17,
                            @0.19,
                            @0.3,
                            @0.5, @1];
    animation1.values = @[@(0),
                          @(-0.83*_width),
                          @(-0.82*_width),
                          @(-0.83*_width),
                          @(-0.83*_width),
                          @(-2*_width), @(-2*_width)];
    animation1.repeatCount = HUGE_VALF;
    animation1.autoreverses = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.duration = duration;
    [_imageView_1.layer addAnimation:animation1 forKey:nil];
    
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation2.keyTimes = @[@0,
                            @0.05,
                            @0.2,
                            @0.22,
                            @0.24,
                            @0.4,
                            @0.6, @1];
    animation2.values = @[@(0),
                          @(0),
                          @(-0.92*_width),
                          @(-0.91*_width),
                          @(-0.92*_width),
                          @(-0.92*_width),
                          @(-2*_width), @(-2*_width)];
    animation2.repeatCount = HUGE_VALF;
    animation2.autoreverses = NO;
    animation2.fillMode = kCAFillModeForwards;
    animation2.duration = duration;
    [_imageView_2.layer addAnimation:animation2 forKey:nil];
    
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation3.keyTimes = @[@0,
                            @0.1,
                            @0.25,
                            @0.27,
                            @0.29,
                            @0.5,
                            @0.7, @1];
    animation3.values = @[@(0),
                          @(0),
                          @(-0.8*_width),
                          @(-0.79*_width),
                          @(-0.8*_width),
                          @(-0.8*_width),
                          @(-2*_width), @(-2*_width)];
    animation3.repeatCount = HUGE_VALF;
    animation3.autoreverses = NO;
    animation3.fillMode = kCAFillModeForwards;
    animation3.duration = duration;
    [_imageView_3.layer addAnimation:animation3 forKey:nil];
}

- (void)rightMoveAnimation
{
    CGFloat duration = 1.6;
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation1.keyTimes = @[@0,
                            @0.5,
                            @0.52,
                            @0.54,
                            @1];
    animation1.values = @[@(-2*_width),
                          @(-0.85*_width),
                          @(-0.84*_width),
                          @(-0.85*_width),
                          @(-0.85*_width)];
    animation1.repeatCount = 1;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.duration = duration;
    [_imageView_1.layer addAnimation:animation1 forKey:nil];
    
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation2.keyTimes = @[@0,
                            @0.1,
                            @0.6,
                            @0.62,
                            @0.64,
                            @1];
    animation2.values = @[@(-2*_width),
                          @(-2*_width),
                          @(-0.91*_width),
                          @(-0.9*_width),
                          @(-0.91*_width),
                          @(-0.91*_width)];
    animation2.repeatCount = 1;
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    animation2.duration = duration;
    [_imageView_2.layer addAnimation:animation2 forKey:nil];
    
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation3.keyTimes = @[@0,
                            @0.2,
                            @0.72,
                            @0.74,
                            @0.76,
                            @1];
    animation3.values = @[@(-2*_width),
                          @(-2*_width),
                          @(-0.8*_width),
                          @(-0.79*_width),
                          @(-0.8*_width),
                          @(-0.8*_width)];
    animation3.repeatCount = 1;
    animation3.removedOnCompletion = NO;
    animation3.fillMode = kCAFillModeForwards;
    animation3.duration = duration;
    [_imageView_3.layer addAnimation:animation3 forKey:nil];
}


@end
