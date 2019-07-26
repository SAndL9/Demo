//
//  SCCategoryListToolBar.h
//  SCGoJD
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 mac. All rights reserved.
//  导航条下方的工具条

#import <UIKit/UIKit.h>

@class SCCategoryListToolBar;

@protocol SCCategoryListToolBarDelegate <NSObject>

@optional

- (void)categoryListToolBar:(SCCategoryListToolBar *)toolBar didClickButtonAtIndex:(NSUInteger)index;

@end

@interface SCCategoryListToolBar : UIImageView

@property (nonatomic, weak) id <SCCategoryListToolBarDelegate> delegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com