//
//  JCCXManager.h
//  YHB_Prj
//
//  Created by  striveliu on 15/8/31.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JCCXModeList;
@interface JCCXManager : NSObject
- (void)appGetProductStaySrl:(int)aStatus finishBlock:(void(^)(JCCXModeList *list))aFinishBlock;
- (void)setCurrentVipid:(NSString *)aVipId;
- (void)setStartTime:(NSString *)aStartTime;
- (void)setEndTime:(NSString *)aEndTime;
@end
