//
//  FFMemberCenterHeadView.m
//  FFVipLevelProgressView
//
//  Created by Mr.Yao on 16/10/21.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "FFMemberCenterHeadView.h"

#import "FFRectangleProgressView.h"
#import "FFUserLevelView.h"
#import "FFLntegralView.h"
#import "UIView+Extension.h"

#import <HexColors/HexColors.h>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

static float padding = 70;

@interface FFMemberCenterHeadView ()

@property (nonatomic ,assign) NSInteger userLevel;

@end

@interface FFMemberCenterHeadView ()<UIScrollViewDelegate,FFRectangleProgressViewDelegate>


@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIImageView * backGroundImageView;

@property (nonatomic, strong) FFUserLevelView *activeView;

@property (nonatomic, strong) FFRectangleProgressView * progressViews;

@property (nonatomic, strong) FFLntegralView *lntegraView;

@property (nonatomic, strong) UILabel * toastLabel;

@property (nonatomic, strong) UILabel *nickName;

@property (nonatomic, assign) BOOL isShowAnimations;

@property (nonatomic, assign) float userIntegral;

@property (nonatomic, assign) CGSize normalSize;

@property (nonatomic, assign) CGSize activeSize;

@end

@implementation FFMemberCenterHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Private Methods

-(void)startIntegralAnimationWithMaxLevel:(NSInteger)maxLevel UserIntegral:(float)userIntegral UserLevel:(NSInteger)userLevel UserlevelIntegral:(float)userlevelIntegral nextLevelIntegral:(float)nextLevelIntegral userNickName:(NSString *)nickname ActiveSize:(CGSize)activeSize NormalSize:(CGSize)normalSize{
    self.userLevel = userLevel;
    self.normalSize = normalSize;
    self.activeSize = activeSize;
    
    //关闭交互 避免误操作
    self.userInteractionEnabled = NO;
    
    UIView *previousItemView = nil;

    for (NSInteger i = 1; i <= maxLevel ; i ++) {
        FFUserLevelView * levelView = nil;
        BOOL isUserLevel = (i == userLevel)? YES :NO;
        if (previousItemView) {
           levelView  = [FFUserLevelView showLevelInfoWithLevel:i IsUserLevel:isUserLevel Frame: isUserLevel ? CGRectMake(padding + previousItemView.x + previousItemView.width, 0, activeSize.width, activeSize.height) : CGRectMake(padding +  previousItemView.x + previousItemView.width, 0, normalSize.width, normalSize.height) avator:@"http://c1.cdn.goumin.com/cms/video_activity/day_161013/20161013_0ccd5cb.jpg"];
        }else{
            levelView = [FFUserLevelView showLevelInfoWithLevel:i IsUserLevel:isUserLevel Frame: isUserLevel ? CGRectMake(padding *(i) + previousItemView.x + previousItemView.width, 0, activeSize.width, activeSize.height) : CGRectMake(padding *(i) +  previousItemView.x + previousItemView.width, 0, normalSize.width, normalSize.height) avator:@"http://c1.cdn.goumin.com/cms/video_activity/day_161013/20161013_0ccd5cb.jpg"];
        }
        
        levelView.centerY = self.scrollView.centerY;
        previousItemView  =levelView;
        [self.scrollView addSubview:levelView];
        
        if (!isUserLevel) {
            UILabel * introduceLabel =  [[UILabel alloc]initWithFrame:CGRectMake( 0, 0 , 80, 20)];
            introduceLabel.y = levelView.bottom + 2;
            introduceLabel.centerX = levelView.centerX;
            introduceLabel.text = @"用户等级";
            introduceLabel.textColor = [HXColor hx_colorWithHexString:@"c03e43"];
            introduceLabel.textAlignment = NSTextAlignmentCenter;
            introduceLabel.font = [UIFont systemFontOfSize:12];
            [self.scrollView addSubview:introduceLabel];
        }
        
        //将当前等级View存一下  动画展示需要
        if (isUserLevel) {
            self.activeView = levelView;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake((maxLevel- 2 + 1) * padding + 2 * padding + (maxLevel-1) * normalSize.width + activeSize.width , 0);
    
    self.progressViews.width = self.scrollView.contentSize.width;
    self.progressViews.centerY = self.scrollView.centerY;
    self.progressViews.height = 5;
    
    self.progressViews.durationValue = 10;
    
    float scale = ((userIntegral - userlevelIntegral)/(nextLevelIntegral- userlevelIntegral));
    
    if(isnan(scale)){ //除数为0 Nan保护
        scale = 0.0;
    }
    self.progressViews.progressValue = (userLevel - 2 + 1) * padding + padding + (userLevel - 1) * normalSize.width + activeSize.width + scale * padding ;
    
    self.toastLabel.centerX = (userLevel - 2 + 1) * padding + padding + (userLevel - 1) * normalSize.width + activeSize.width + padding / 2;
    
    self.toastLabel.text = [NSString stringWithFormat:@"距下一等级还差%ld分",(NSInteger)(nextLevelIntegral - userIntegral)];
    
    self.toastLabel.y = - 30;
    
    self.userIntegral = userIntegral;
    self.nickName.text = nickname;
    
    //延时1秒 动画完全展示
    [self performSelector:@selector(lntegraViewStartAnimation) withObject:self afterDelay:1.0];
}


- (void)lntegraViewStartAnimation{
    [self.lntegraView startAnimationWithNumber:self.userIntegral];

}

#pragma mark - LDRectangleProgressViewDelegate

-(void)progressWidthChangedWithWidth:(float)width{
    if (width > kScreenWidth) {
        [UIView animateWithDuration:0.5 animations:^{
            if (!(width - kScreenWidth / 2 > self.scrollView.contentSize.width)) {
                [self.scrollView setContentOffset:CGPointMake(width - kScreenWidth / 2 -padding - self.normalSize.width, 0)];
            }
        }];
    }
    
    NSInteger animationWidth = ((self.userLevel - 2 + 1) * padding + padding + (self.userLevel - 1) * self.normalSize.width) + self.activeSize.width;
    
    if (self.activeView && animationWidth > (NSInteger)width && animationWidth - self.activeSize.width < (NSInteger)width  && self.isShowAnimations) {
        self.isShowAnimations = NO;
        [FFUserLevelView showAnimationsWithView:self.activeView withDuration:0.3];
    }
}

-(void)animationFinish{
    //动画执行完成 开启交互
    self.userInteractionEnabled = YES;

    [UIView animateWithDuration:0.3 animations:^{
        self.toastLabel.bottom = self.progressViews.bottom - 5 - 2;
    }];
        
    //runloop 监听失效  动画完毕后检查是否完成  没完成  再次执行动画
    if (self.activeView.avatorContentImageView.center.y != self.activeView.avatorImageView.center.y) {
        [FFUserLevelView showAnimationsWithView:self.activeView withDuration:0.1];
        self.isShowAnimations = NO;
    }
}

#pragma mark - layout subView

- (void)setupViews{
    [self addSubview:self.backGroundImageView];
    
    
    [self addSubview:self.lntegraView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backGroundImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backGroundImageView(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_lntegraView(>=60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lntegraView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lntegraView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lntegraView]-14-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lntegraView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lntegraView(==14)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lntegraView)]];
    
    
    [self addSubview:self.scrollView];
    self.backgroundColor = [HXColor hx_colorWithHexString:@"ff5a60"];
    [self.scrollView addSubview:self.progressViews];
    [self.scrollView addSubview:self.toastLabel];

    [self addSubview:self.nickName];
    self.nickName.centerX = self.scrollView.centerX;
}

#pragma mark - Getters & Setters


- (UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _backGroundImageView.translatesAutoresizingMaskIntoConstraints  =NO;
        _backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backGroundImageView.clipsToBounds = YES;
        _backGroundImageView.image = [UIImage imageNamed:@"member_head_bg"];
    }
    return _backGroundImageView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator= NO;
    }
    return _scrollView;
}

- (BOOL)isShowAnimations{
    if (!_isShowAnimations) {
        _isShowAnimations = YES;
    }
    return _isShowAnimations;
}

- (UILabel *)nickName{
    if (!_nickName) {
        _nickName = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth, 20)];
        _nickName.textColor = [HXColor hx_colorWithHexString:@"ffffff"];
        _nickName.textAlignment = NSTextAlignmentCenter;
        _nickName.font = [UIFont systemFontOfSize:13];
    }
    return _nickName;
}

-(UILabel *)toastLabel{
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 30)];
        _toastLabel.textColor = [HXColor hx_colorWithHexString:@"a82431"];
        _toastLabel.numberOfLines = 2;
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.font = [UIFont systemFontOfSize:11];
    }
    return _toastLabel;
}

- (FFLntegralView *)lntegraView{
    if (!_lntegraView) {
        _lntegraView = [[FFLntegralView alloc]initWithFrame:CGRectZero];
        _lntegraView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _lntegraView;
}

- (FFRectangleProgressView *)progressViews{
    if (!_progressViews) {
        _progressViews = [[FFRectangleProgressView alloc]initWithFrame:CGRectZero];
        _progressViews.translatesAutoresizingMaskIntoConstraints = NO;
        _progressViews.delegate =self;
        _progressViews.trackTintColor = [HXColor hx_colorWithHexString:@"ffd234"];
        _progressViews.progressTintColor = [HXColor hx_colorWithHexString:@"c03d43"];
    }
    return _progressViews;
}

@end
