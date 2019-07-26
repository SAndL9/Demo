//
//  SPManager.h
//  YHB_Prj
//
//  Created by Johnny's on 15/9/11.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPManager : NSObject

- (void)saveOrUpdateDict:(NSDictionary *)aDict finishBlock:(void (^)(NSString *))FBlock;

@end

@interface JHLSManager : NSObject

- (void)appGetProductStockDetail:(NSString *)aProductId finishBlock:(void (^)(NSArray *))FBlock isRefresh:(BOOL)aBool;

@end

@interface XSLSManager : NSObject

- (void)getSaleHisByProductIdApp:(NSString *)aProductId finishBlock:(void (^)(NSArray *))FBlock isRefresh:(BOOL)aBool;

@end