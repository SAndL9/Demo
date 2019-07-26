//
//  FireworkView.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/14.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "FireworkView.h"

@interface FireworkView ()
// 1-粗线   2-细线  3-右上角三条线
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint centerPoint;
@end

@implementation FireworkView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.radius = MIN(frame.size.height, frame.size.width)/2;
        self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        [self createShapeLayer];
    }
    return self;
}

- (void)createShapeLayer
{
    CGFloat minRadius = 0.3 * self.radius;
    NSArray *formArrayX = @[@(self.centerPoint.x),
                            @(self.centerPoint.x + sin(M_PI / 180 * 45)*minRadius),
                            @(self.centerPoint.x + minRadius),
                            @(self.centerPoint.x + sin(M_PI / 180 * 45)*minRadius),
                            @(self.centerPoint.x),
                            @(self.centerPoint.x - sin(M_PI / 180 * 45)*minRadius),
                            @(self.centerPoint.x - minRadius),
                            @(self.centerPoint.x - sin(M_PI / 180 * 45)*minRadius)];
    NSArray *formArrayY = @[@(self.centerPoint.y - minRadius),
                            @(self.centerPoint.y - sin(M_PI / 180 * 45)*minRadius),
                            @(self.centerPoint.y),
                            @(self.centerPoint.y + sin(M_PI / 180 * 45)*minRadius),
                            @(self.centerPoint.y + minRadius),
                            @(self.centerPoint.y + sin(M_PI / 180 * 45)*minRadius),
                            @(self.centerPoint.y),
                            @(self.centerPoint.y - sin(M_PI / 180 * 45)*minRadius)];

    NSArray *toArrayX = @[@(self.centerPoint.x),
                        @(self.centerPoint.x + sin(M_PI / 180 * 45)*self.radius),
                        @(self.centerPoint.x + self.radius),
                        @(self.centerPoint.x + sin(M_PI / 180 * 45)*self.radius),
                        @(self.centerPoint.x),
                        @(self.centerPoint.x - sin(M_PI / 180 * 45)*self.radius),
                        @(self.centerPoint.x - self.radius),
                        @(self.centerPoint.x - sin(M_PI / 180 * 45)*self.radius)];
    NSArray *toArrayY = @[@(self.centerPoint.y - self.radius),
                        @(self.centerPoint.y - sin(M_PI / 180 * 45)*self.radius),
                        @(self.centerPoint.y),
                        @(self.centerPoint.y + sin(M_PI / 180 * 45)*self.radius),
                        @(self.centerPoint.y + self.radius),
                        @(self.centerPoint.y + sin(M_PI / 180 * 45)*self.radius),
                        @(self.centerPoint.y),
                        @(self.centerPoint.y - sin(M_PI / 180 * 45)*self.radius)];
    NSInteger count = self.type == 3 ? 3 :toArrayY.count;
    for (int i = 0; i < count; i++)
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake([formArrayX[i] floatValue], [formArrayY[i] floatValue])];
        [path addLineToPoint:CGPointMake([toArrayX[i] floatValue], [toArrayY[i] floatValue])];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = self.type == 2 ? 1 : 2;
        layer.lineCap = kCALineCapRound;
        layer.strokeColor = [UIColor colorWithRed:0.33f green:0.13f blue:0.41f alpha:1.00f].CGColor;
        layer.path = path.CGPath;
        
        
        CAKeyframeAnimation *keyA = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        keyA.keyTimes = @[@0, @0.3, @1];
        keyA.values = @[@0, @0, @1];
        
        
        CAKeyframeAnimation *keyB = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        keyB.keyTimes = @[@0,@0.7,@1];
        keyB.values = @[@0,@0,@1];
        
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 1;
        group.autoreverses = NO;
        group.repeatCount = HUGE_VALF;
        group.fillMode = kCAFillModeForwards;
        group.animations = @[keyA,keyB];
        
        [layer addAnimation:group forKey:nil];
        [self.layer addSublayer:layer];
    }
}

@end
