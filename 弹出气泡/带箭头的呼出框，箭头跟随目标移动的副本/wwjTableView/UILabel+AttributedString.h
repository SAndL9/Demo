//
//  UILabel+AttributedString.h
//  My Tool
//
//  Created by 吴伟军 on 16/7/4.
//  Copyright © 2016年 吴伟军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AttributedString)
/**
 *  时间text
 */
@property (nonatomic) CGFloat timeText;

/**
 *  竖排显示label
 */
@property (nonatomic) NSString *verticalText;

/**
 *  创建一个左边有图片的label
 *
 *  @param image 图片
 *  @param title 标题
 */
- (void)setLabelTextWithLeftImage:(UIImage *)image andTitle:(NSString *)title;
- (void)setLabelTextWithRightImage:(UIImage *)image andTitle:(NSString *)title;

/**
 *  更改label指定位置的字符串的颜色和字号
 *
 *  @param string    字符串text
 *  @param color     字体颜色
 *  @param font      字号大小
 *  @param theRange  指定位置
 *  @param theLength 指定长度
 */
- (void)setTypewithString:(NSString *)string withColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor withFont:(UIFont *)font withRangeIndex:(NSInteger)theRange withLenth:(NSInteger)theLength;

@end
