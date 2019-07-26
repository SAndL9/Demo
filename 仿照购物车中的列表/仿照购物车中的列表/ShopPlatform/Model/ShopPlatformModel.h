//
//  ShopPlatformModel.h
//  电商
//
//  Created by zhou on 16/8/9.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopPlatformModel : NSObject

/** 判断是否选中(YES为选中，NO为没有选中) */
@property (nonatomic,assign) BOOL isSelect;
/** 价格 */
@property (nonatomic,assign) NSInteger presentprice;
/** 数量 */
@property (nonatomic,assign) NSInteger totalnumber;

@end
