//
//  SCCategoryDetail.h
//  SCGoJD
//
//  Created by mac on 15/9/24.
//  Copyright (c) 2015年 mac. All rights reserved.
//  详细分类（二三级分类）

#import <Foundation/Foundation.h>

#import "SCCategory.h"

@interface SCCategoryDetail : NSObject
/**
 *  头标题
 */
@property (nonatomic, strong) SCCategory *headerCategory;
/**
 *  第三级分类(SCCategory)
 */
@property (nonatomic, strong) NSArray *categories;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com