//
//  SABubbleView.h
//  SAKitDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  三角的方向 */
typedef enum :NSInteger{
    SATriangleDicrectionUp,       // 向上，默认
    SATriangleDicrectionLeft,     // 向左
    SATriangleDicrectionDown,     // 向下
    SATriangleDicrectionRight     // 向右
} SATriangleDicrection;

/** 气泡的样式 */
typedef enum :NSInteger{
    SABubbleTypeNormal, //全部都是文字,默认
    SABubbleTypeButton, //button
    SABubbleTypeView //view
} SABubbleViewType;

@interface SABubbleView : UIView

/** 实际界面的View */
@property (nonatomic, strong) UIView *realView;

/** 文字显示的Lab */
@property (nonatomic, strong) UILabel *textLabel;

/** 三角的方向,默认SATriangleDicrectionUp  */
@property (nonatomic, assign) SATriangleDicrection triangleDicrection;

/** 类型选择,默认SABubbleTypeNormal */
@property (nonatomic, assign) SABubbleViewType bubbleViewType;

/** 三角位置的比例,默认0.5 */
@property (nonatomic, assign) CGFloat triangleSeatScale;

/** 三角形坐标 */
@property (nonatomic, assign) CGPoint trianglePoint;

/** 暂定数据源 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
/**
 构造方法

 @param point 三角形坐标的点
 @param size 大小的描述
 @return 弹出气泡
 */
- (instancetype)initWithTrianglePoint:(CGPoint)point size:(CGSize)size;


/**
 在蒙版上显示弹出框

 @param maskSuperView 蒙版父视图
 */
- (void)show:(UIView *)maskSuperView;


/**
 弹框消失
 */
- (void)dismiss;

@end
