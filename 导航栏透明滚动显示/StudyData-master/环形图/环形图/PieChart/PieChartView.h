//
//  PieChartView.h
//  环形图
//
//  Created by 舒通 on 2017/4/7.
//  Copyright © 2017年 shutong. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PieChartView : UIView

/**
 环形图的中心点
 */
@property (nonatomic, assign) CGPoint pieCenter;

/**
 半径
 */
@property (nonatomic, assign) CGFloat redius;
/**
 环形的宽度
 */
@property (nonatomic, assign) CGFloat strokeLineWith;

/**
 环状图的背景颜色
 */
@property (nonatomic, strong) UIColor *pieBackGroundColor;

/**
 环形图进度的颜色
 */
@property (nonatomic, strong) UIColor *pieColor;

/**
 进度
 */
@property (nonatomic, assign) CGFloat progress;

/**
 环形颜色代表名称
 */
@property (nonatomic, strong) NSArray *markName;

/**
 更新进度

 @param progress 进度
 */
- (void)upLoadPieChartWithProgress:(CGFloat)progress;
@end
