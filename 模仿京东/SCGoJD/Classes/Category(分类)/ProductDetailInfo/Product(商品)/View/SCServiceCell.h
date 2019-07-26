//
//  SCServiceCell.h
//  SCGoJD
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 mac. All rights reserved.
//  显示当前所选商品服务信息的cell

#import <UIKit/UIKit.h>
#import "SCCommonCell.h"

@interface SCServiceCell : SCCommonCell

/**
 *  商品的详细信息模型
 */
@property (nonatomic, strong) SCProductInfo *productInfo;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com