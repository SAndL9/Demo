//
//  UIBarButtonItem+SCBarButtonItem.h
//  SCGoJD
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//  快速创建UIBarButtonItem

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SCBarButtonItem)

/**
 *  快速创建一个UIBarButtonItem对象
 *
 *  @param backgroundImage  背景图片
 *  @param highlightedImage 高亮图片
 *  @param target           动作目标
 *  @param action           动作
 *  @param controlEvents    事件类型
 *
 *  @return 一个UIBarButtonItem对象
 */
+ (instancetype)barButtonItemWithBackgroundImage:(UIImage *)backgroundImage
                                highlightedImage:(UIImage *)highlightedImage
                                          target:(id)target
                                          action:(SEL)action
                                forControlEvents:(UIControlEvents)controlEvents;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com