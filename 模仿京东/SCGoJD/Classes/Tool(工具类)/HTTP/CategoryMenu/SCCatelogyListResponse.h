//
//  SCCatelogyListResponse.h
//  SCGoJD
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//  返回的最高级分类信息

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface SCCatelogyListResponse : NSObject <MJKeyValue>
/**
 *  最高级分类列表(category)
 */
@property (nonatomic, strong) NSArray *catelogyList;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com