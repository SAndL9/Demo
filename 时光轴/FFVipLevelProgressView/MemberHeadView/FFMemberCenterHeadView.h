//
//  FFMemberCenterHeadView.h
//  FFVipLevelProgressView
//
//  Created by Mr.Yao on 16/10/13.
//  Copyright © 2016年 狗民网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMemberCenterHeadView : UIView

/**
 * maxLevel 最高的等级 例如15  userLevel用户当前等级  userIntegral 用户积分 userlevelIntegral 用户当前等级积分 nextLevelIntegral 下个等级积分
 */
- (void)startIntegralAnimationWithMaxLevel:(NSInteger)maxLevel UserIntegral:(float)userIntegral UserLevel:(NSInteger)userLevel UserlevelIntegral:(float)userlevelIntegral nextLevelIntegral:(float)nextLevelIntegral userNickName:(NSString *)nickname ActiveSize:(CGSize)activeSize NormalSize:(CGSize)normalSize;

@end
