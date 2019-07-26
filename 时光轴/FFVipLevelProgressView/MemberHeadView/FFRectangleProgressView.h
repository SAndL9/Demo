//
//  FFHeadProgressView.h
//  LosAngeles
//
//  Created by Mr.Yao on 16/4/26.
//  Copyright © 2016年 狗民网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFRectangleProgressViewDelegate <NSObject>

- (void)progressWidthChangedWithWidth:(float)width;

- (void)animationFinish;

@end

@interface FFRectangleProgressView : UIView
/**
 *  进度条高度  height: 5~100
 */
@property (nonatomic) CGFloat progressHeight;

/**
 *  进度值  maxValue:  <= YSProgressView.width
 */
@property (nonatomic) CGFloat progressValue;

/**
 *   动态进度条颜色  Dynamic progress
 */
@property (nonatomic, strong) UIColor *trackTintColor;
/**
 *  静态背景颜色    static progress
 */
@property (nonatomic, strong) UIColor *progressTintColor;

/**
 * 进度条宽度改变代理
 */
@property (nonatomic, weak) id<FFRectangleProgressViewDelegate>delegate;

/**
 * 动画执行时间
 */
@property (nonatomic, assign) float durationValue;

@end
