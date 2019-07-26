//
//  SCFocusTool.h
//  SCGoJD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//  存取收藏夹中商品信息的工具类

#import <Foundation/Foundation.h>
#import "SCProductInfo.h"

@interface SCFocusTool : NSObject

/**
 *  添加关注
 *
 *  @param productInfo  要保存到收藏夹中的商品信息
 */
+ (void)focusProduct:(SCProductInfo *)productInfo;
/**
 *  取消关注
 *
 *  @param skuId        要取消关注的商品编号
 *
 *  @return 更新后的收藏夹中的商品信息(SCProductInfo.keyValues)
 */
+ (NSMutableArray *)removeFocusedProductWithskuId:(NSString *)skuId;

/**
 *  读取收藏夹数据
 *
 *  @return 收藏夹中的商品信息(SCProductInfo.keyValues)
 */
+ (NSArray *)focuses;
/**
 *  判断是否已经关注了某件商品
 *
 *  @param skuId    要判断的商品编号
 *
 *  @return         是否已经关注了该商品
 */
+ (NSString *)hasFocusedProductWithSkuId:(NSString *)skuId;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com