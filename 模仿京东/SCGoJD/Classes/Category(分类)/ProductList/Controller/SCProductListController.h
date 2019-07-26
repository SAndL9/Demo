//
//  SCProductListController.h
//  SCGoJD
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 mac. All rights reserved.
//  商品列表

#import <UIKit/UIKit.h>

@interface SCProductListController : UITableViewController
/**
 *  创建并返回一个SCProductListController对象,需要传入catelogyId参数进行数据请求
 *
 *  @param catelogyId 商品类别编号cid
 *
 *  @return 一个SCProductListController对象
 */
- (instancetype)initWithCatelogyId:(NSString *)catelogyId;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com