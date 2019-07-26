//
//  SCNewFeatureCell.h
//  SCGoJD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCImageScrollBaseCell.h"

@interface SCNewFeatureCell : SCImageScrollBaseCell

/**
 *  获取当前页码和最后一页的页码
 *
 *  @param currentIndex 当前页
 *  @param lastIndex    最后一页
 */
- (void)setCurrentPageIndex:(NSInteger)currentIndex lastPageIndex:(NSInteger)lastIndex;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com