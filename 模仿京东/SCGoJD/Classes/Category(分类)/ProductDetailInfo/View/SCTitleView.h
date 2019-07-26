//
//  SCTitleView.h
//  SCGoJD
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 mac. All rights reserved.
//  导航条上的按钮

#import <UIKit/UIKit.h>
@class SCTitleView;

@protocol SCTitleViewDelegate <NSObject>

@optional

- (void)titleView:(SCTitleView *)titleView didClickButtonAtIndex:(NSUInteger)index;

@end

@interface SCTitleView : UIView

@property (nonatomic, weak) id <SCTitleViewDelegate> delegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com