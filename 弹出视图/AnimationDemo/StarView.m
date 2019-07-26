//
//  StarView.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/14.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "StarView.h"

@interface StarView ()
// 1-星星   2-圆圈
@property (nonatomic, assign) NSInteger type;
@end

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self createAnimationLayer];
    }
    return self;
}

- (void)createAnimationLayer
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:self.type == 1 ? @"Slice_0_180" : @"Slice_0_168"];
    [self addSubview:imageView];
    
    // 放大缩小
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.6;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = [NSNumber numberWithFloat:0.1];
    animation.toValue = [NSNumber numberWithFloat:1];
    [imageView.layer addAnimation:animation forKey:nil];

    
    
    // 透明度
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation1.fromValue = [NSNumber numberWithFloat:1.];
//    animation1.toValue = [NSNumber numberWithFloat:0.1];

    // 动画数组
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = @[animation,animation1];
//    group.repeatCount = HUGE_VALF;
//    group.autoreverses = YES;
//    group.fillMode = kCAFillModeForwards;
//    group.duration = 1.;
//    [imageView.layer addAnimation:group forKey:nil];
}
@end
