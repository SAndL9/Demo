//
//  EggsView.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/15.
//  Copyright © 2017年 PT. All rights reserved.
//  彩蛋

#import "EggsView.h"
#import "StarView.h"
#import "FireworkView.h"
#import "LineView.h"
#import "RainbowView.h"
#import "BottomView.h"

// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 屏幕宽度比例
#define kW_Scale (kScreenWidth/320.0)
// 屏幕高度比例
#define kH_Scale (kScreenHeight/568.0)


@interface EggsView ()
// 男 - 1    女 - 2
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGPoint leftPoint;
@property (nonatomic, assign) CGPoint rightPoint;
@property (nonatomic, strong) UIImageView *moveView;
// 彩蛋内容
@property (nonatomic, strong) UIScrollView *scrollViewContent;
// 领取之前的左移视图
@property (nonatomic, strong) LineView *leftMoveView;
// 背景图片
@property (nonatomic, strong) UIImageView *backImageView;
// 彩蛋图片
@property (nonatomic, strong) UIImageView *eggImageView;
@end

@implementation EggsView

- (UIImageView *)moveView
{
    if (!_moveView) {
        _moveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _moveView.center = _leftPoint;
        _moveView.image = [UIImage imageNamed:@"状态2"];
    }
    return _moveView;
}

+ (void)showEggsViewWithType:(NSInteger)type
{
    EggsView *backView = [[EggsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.alpha = 0;
    backView.type = type;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(cancleAction)]];
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    
    UIImageView *contentView = [backView createImageView];
    [backView addSubview:contentView];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.4;
    animation.keyTimes = @[@0,@0.7,@1];
    animation.values = @[@0,@1.2,@1];
    [contentView.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
       
        backView.alpha = 1;
    }];
}

- (void)cancleAction
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backImageView.transform = CGAffineTransformScale(self.backImageView.transform, 0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIImageView *)createImageView
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kW_Scale*320, kH_Scale*440)];
    backImageView.center = self.center;
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:_type == 1 ? @"男底" : @"女底"];
    _backImageView = backImageView;
    
    UIImageView *eggImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kW_Scale*95, kH_Scale*155)];
    eggImageView.center = CGPointMake(backImageView.center.x, kH_Scale*120);
    eggImageView.image = [UIImage imageNamed:_type == 1 ? @"领取前 男" : @"领取前 女"];
    [backImageView addSubview:eggImageView];
    _eggImageView = eggImageView;
    
    
    
    // 左移线条
    _leftMoveView = [[LineView alloc] initWithFrame:CGRectMake(40*kW_Scale, 220*kH_Scale, 260*kW_Scale, 20*kH_Scale) type:1];
    [backImageView addSubview:_leftMoveView];
    
    
    
    // 虚线和左右两个圆
    UIView *lineView = [self createDottedLine];
    lineView.center = CGPointMake(backImageView.center.x, 360*kH_Scale);
    [backImageView addSubview:lineView];

    
    // 按钮
    UIButton *button = [self createButtonWithType:_type];
    button.center = CGPointMake(backImageView.center.x, 400*kH_Scale);
    [backImageView addSubview:button];

    // 彩蛋内容
    _scrollViewContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 220*kW_Scale, 60*kH_Scale)];
    _scrollViewContent.center = CGPointMake(backImageView.center.x, 310*kH_Scale);
    [backImageView addSubview:_scrollViewContent];
    [self createLabelWithContent:@"赶紧领取您的彩蛋奖励吧"];

    return backImageView;
}

// 创建领取之后的视图
- (void)createReceiveAfterView
{
    [UIView animateWithDuration:0.2 animations:^{
        _leftMoveView.alpha = 0;
    }completion:^(BOOL finished) {
        [_leftMoveView removeFromSuperview];
    }];
    
    // 烟花
    FireworkView *fire_1 = [[FireworkView alloc] initWithFrame:CGRectMake(60*kW_Scale, 100*kH_Scale, 35*kW_Scale, 35*kW_Scale) type:1];
    [_backImageView addSubview:fire_1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FireworkView *fire_2 = [[FireworkView alloc] initWithFrame:CGRectMake(95*kW_Scale, 40*kH_Scale, 22*kW_Scale, 22*kW_Scale) type:2];
        [_backImageView addSubview:fire_2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FireworkView *fire_3 = [[FireworkView alloc] initWithFrame:CGRectMake(165*kW_Scale, 50*kH_Scale, 40*kW_Scale, 40*kW_Scale) type:3];
        [_backImageView addSubview:fire_3];
    });
    
    
    // 星星
    StarView *start_1 = [[StarView alloc] initWithFrame:CGRectMake(85*kW_Scale, 190*kH_Scale, 20*kW_Scale, 16*kW_Scale) type:1];
    [_backImageView addSubview:start_1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StarView *start_2 = [[StarView alloc] initWithFrame:CGRectMake(220*kW_Scale, 90*kH_Scale, 20*kW_Scale, 16*kW_Scale) type:1];
        [_backImageView addSubview:start_2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StarView *start_3 = [[StarView alloc] initWithFrame:CGRectMake(235*kW_Scale, 120*kH_Scale, 20*kW_Scale, 16*kW_Scale) type:1];
        [_backImageView addSubview:start_3];
    });
    
    
    // 圆圈
    StarView *round_1 = [[StarView alloc] initWithFrame:CGRectMake(60*kW_Scale, 165*kH_Scale, 10*kW_Scale, 10*kW_Scale) type:2];
    [_backImageView addSubview:round_1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StarView *round_2 = [[StarView alloc] initWithFrame:CGRectMake(95*kW_Scale, 155*kH_Scale, 10*kW_Scale, 10*kW_Scale) type:2];
        [_backImageView addSubview:round_2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StarView *round_3 = [[StarView alloc] initWithFrame:CGRectMake(230*kW_Scale, 145*kH_Scale, 15*kW_Scale, 14*kW_Scale) type:2];
        [_backImageView addSubview:round_3];
    });

    // 右移线条
    LineView *right = [[LineView alloc] initWithFrame:CGRectMake(40*kW_Scale, 250*kH_Scale, 260*kW_Scale, 20*kH_Scale) type:2];
    [_backImageView addSubview:right];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 彩虹
        RainbowView *rainbow = [[RainbowView alloc] initWithFrame:CGRectMake(0, 0, 240*kW_Scale, 240*kW_Scale) type:_type];
        rainbow.center = CGPointMake(_backImageView.bounds.size.width - 34*kW_Scale, 273*kH_Scale);
        [_backImageView addSubview:rainbow];
        [_backImageView bringSubviewToFront:_scrollViewContent];
    });

}

// 创建彩蛋内容
- (void)createLabelWithContent:(NSString *)content
{
    for (UIView *subView in _scrollViewContent.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat h = [content boundingRectWithSize:CGSizeMake(220*kW_Scale, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                      context:nil].size.height;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220*kW_Scale, h)];
    label.text = content;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [_scrollViewContent addSubview:label];
    
    if (h > _scrollViewContent.bounds.size.height) {
        _scrollViewContent.contentSize = CGSizeMake(220*kW_Scale, CGRectGetMaxY(label.frame));
    }else
    {
        label.center = CGPointMake(_scrollViewContent.bounds.size.width/2, _scrollViewContent.bounds.size.height/2);
    }
}


// 虚线和左右两个圆
- (UIView *)createDottedLine
{
    CGFloat bH = 20*kW_Scale;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130*kW_Scale, bH)];
    self.leftPoint = CGPointMake(10, bH/2);
    self.rightPoint = CGPointMake(backView.bounds.size.width - 10, bH/2);

    // 左侧圆圈
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    leftLayer.strokeColor = [UIColor whiteColor].CGColor;
    leftLayer.fillColor = [UIColor clearColor].CGColor;
    leftLayer.lineWidth = 2;
    
    UIBezierPath *leftParh = [UIBezierPath bezierPathWithArcCenter:_leftPoint radius:4 startAngle:0 endAngle:2*M_PI clockwise:YES];
    leftLayer.path = leftParh.CGPath;
    
    // 右侧圆圈
    CAShapeLayer *rightLayer = [CAShapeLayer layer];
    rightLayer.strokeColor = [UIColor whiteColor].CGColor;
    rightLayer.fillColor = [UIColor clearColor].CGColor;
    rightLayer.lineWidth = 2;
    
    UIBezierPath *rightParh = [UIBezierPath bezierPathWithArcCenter:_rightPoint radius:4 startAngle:0 endAngle:2*M_PI clockwise:YES];
    rightLayer.path = rightParh.CGPath;
    
    // 虚线
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.lineWidth = 0.6;
    [lineLayer setLineDashPattern:@[[NSNumber numberWithFloat:7],[NSNumber numberWithFloat:3]]];
    
    UIBezierPath *lineParh = [UIBezierPath bezierPath];
    [lineParh moveToPoint:CGPointMake(backView.bounds.size.height, backView.bounds.size.height/2)];
    [lineParh addLineToPoint:CGPointMake(backView.bounds.size.width - backView.bounds.size.height, backView.bounds.size.height/2)];
    lineLayer.path = lineParh.CGPath;
    
    [backView.layer addSublayer:leftLayer];
    [backView.layer addSublayer:rightLayer];
    [backView.layer addSublayer:lineLayer];
    
    // 可移动的视图
    [backView addSubview:self.moveView];
    
    return backView;
}

// 创建领取按钮
- (UIButton *)createButtonWithType:(NSInteger)type
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 120, 26);
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15;
    [button setTitle:@"领取" forState:UIControlStateNormal];
    if (_type == 1)
    {
        [button setTitleColor:[UIColor colorWithRed:0.38f green:0.75f blue:0.93f alpha:1.00f] forState:UIControlStateNormal];
    }else
    {
        [button setTitleColor:[UIColor colorWithRed:0.94f green:0.47f blue:0.46f alpha:1.00f] forState:UIControlStateNormal];
    }
    [button setImage:[UIImage imageNamed:type == 1 ? @"Path 7_1" : @"Path 7"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonTapAction:(UIButton *)send
{
    [UIView animateWithDuration:0.3 animations:^{
       
        _moveView.center = _rightPoint;
    }completion:^(BOOL finished) {
        send.selected = YES;
        [self createReceiveAfterView];
        [send setTitle:@"" forState:UIControlStateNormal];
        [self createLabelWithContent:@"恭喜您获得伍佰元红包 ^_^"];
    }];
}

@end
