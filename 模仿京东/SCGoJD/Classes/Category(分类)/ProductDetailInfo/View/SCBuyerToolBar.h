//
//  SCBuyerToolBar.h
//  SCGoJD
//
//  Created by mac on 15/9/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//  用户购买收藏的工具栏

#import <UIKit/UIKit.h>

@class SCBuyerToolBar;
@class SCMyProductItem;

@protocol SCBuyerToolBarDelegate <NSObject>

@optional

- (void)toolBar:(SCBuyerToolBar *)toolBar didClickButtonAtIndex:(NSUInteger)index;

@end

@interface SCBuyerToolBar : UIView

@property (nonatomic, weak) id <SCBuyerToolBarDelegate> delegate;
/**
 *   反映顾客与商品关系的数据模型
 */
@property (nonatomic, strong) SCMyProductItem *item;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com