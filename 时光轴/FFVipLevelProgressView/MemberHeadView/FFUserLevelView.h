//
//  FFUserLevelView.h
//  FFVipLevelProgressView
//
//  Created by Mr.Yao on 16/10/13.
//  Copyright © 2016年 狗民网. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FFUserLevelView : UIView

@property (nonatomic, assign) NSInteger levelNum;

@property (nonatomic, strong) NSString * avator;

@property (nonatomic,strong) UIView * activeView;

@property (nonatomic, strong) UIView * normalView;

@property (nonatomic, strong) UIImageView * backGroundImageView;
@property (nonatomic, strong) UILabel * levelLabel;

@property (nonatomic, strong) UIImageView * avatorImageView;
@property (nonatomic, strong) UIImageView * avatorContentImageView;
@property (nonatomic, strong) UILabel * userLevel;

@property (nonatomic, assign) BOOL isUserLevel;

+ (FFUserLevelView *)showLevelInfoWithLevel:(NSInteger)level IsUserLevel:(BOOL)isUserLevel Frame:(CGRect)frame avator:(NSString *)avator;

+ (void)showAnimationsWithView:(FFUserLevelView *)view withDuration:(float)duration;

@end
