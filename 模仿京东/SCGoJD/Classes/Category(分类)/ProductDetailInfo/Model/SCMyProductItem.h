//
//  SCMyProductItem.h
//  SCGoJD
//
//  Created by mac on 15/9/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//  反映顾客与商品关系的数据模型

#import <Foundation/Foundation.h>

@interface SCMyProductItem : NSObject

/**
 *  是否收藏该商品
 */
@property (nonatomic, copy, getter=isFocused) NSString *focused;
/**
 *  购物车商品总数
 */
@property (nonatomic, assign) NSString *productCount;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com