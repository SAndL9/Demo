//
//  FFUserLevelView.m
//  FFVipLevelProgressView
//
//  Created by Mr.Yao on 16/10/21.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "FFUserLevelView.h"

#import "UIView+Extension.h"

#import <HexColors/HexColors.h>

#import <SDWebImage/UIImageView+WebCache.h>

@implementation FFUserLevelView

#pragma mark - init 

+(FFUserLevelView *)showLevelInfoWithLevel:(NSInteger)level IsUserLevel:(BOOL)isUserLevel Frame:(CGRect)frame avator:(NSString *)avator{
    FFUserLevelView * levelView = [[FFUserLevelView alloc]initWithFrame:frame];
    levelView.levelNum = level;
    levelView.avator = avator;
    levelView.isUserLevel = isUserLevel;
    return levelView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - layout subViews


-(void)setupViews{
    [self addSubview:self.normalView];
    [self addSubview:self.activeView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_normalView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_normalView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_normalView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_normalView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_activeView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_activeView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_activeView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_activeView)]];
    
    //-------
    [self.normalView addSubview:self.backGroundImageView];
    
    [self.backGroundImageView addSubview:self.levelLabel];
    
    [self.normalView addConstraint:[NSLayoutConstraint constraintWithItem:_backGroundImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.normalView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.normalView addConstraint:[NSLayoutConstraint constraintWithItem:_backGroundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.normalView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    

    [self.normalView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_backGroundImageView(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
    
    [self.normalView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backGroundImageView(==36)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
    
    [self.backGroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.levelLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backGroundImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.backGroundImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.levelLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backGroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    
    //--------
    
    [self.activeView addSubview:self.avatorImageView];
    [self.activeView addSubview:self.avatorContentImageView];
    [self.activeView addSubview:self.userLevel];
    
    self.avatorContentImageView.frame = CGRectMake(12, - 71, 70, 70);
   self.avatorContentImageView.hidden = YES;

    [self.activeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatorImageView(==72)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatorImageView)]];
    [self.activeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_avatorImageView(==72)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatorImageView)]];
    
    [self.activeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12.5-[_avatorImageView]-0@700-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatorImageView)]];
    
    [self.activeView addConstraint:[NSLayoutConstraint constraintWithItem:_avatorImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.activeView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    
    
    [self.activeView addConstraint:[NSLayoutConstraint constraintWithItem:_userLevel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.activeView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.activeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_userLevel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userLevel)]];
    
    [self.activeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_userLevel(==25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userLevel)]];
    
    [self.activeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_userLevel(==25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userLevel)]];
}

#pragma mark - Private Methods

-(void)setIsUserLevel:(BOOL)isUserLevel{
    _isUserLevel = isUserLevel;
    if (isUserLevel) {
        self.userLevel.text = [NSString stringWithFormat:@"V%ld",self.levelNum];
        [self.avatorContentImageView sd_setImageWithURL:[NSURL URLWithString:self.avator] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        [self bringSubviewToFront:self.activeView];
        self.activeView.hidden = NO;
        self.normalView.hidden = YES;
    }else{
        self.levelLabel.attributedText = [self handleStringWithLevelNumber:self.levelNum];
        [self bringSubviewToFront:self.normalView];
        self.activeView.hidden = YES;
        self.normalView.hidden = NO;
    }
}

+ (void)showAnimationsWithView:(FFUserLevelView *)view withDuration:(float)duration{
    [UIView animateWithDuration:duration animations:^{
        view.avatorContentImageView.center = view.avatorImageView.center;
        view.avatorContentImageView.hidden = NO;;
    }];
}

- (NSAttributedString *)handleStringWithLevelNumber:(NSInteger)levelNumber {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"V%ld", (long)levelNumber]];
    NSRange rangge1 = [[text string] rangeOfString:[NSString stringWithFormat:@"%ld", levelNumber ?: 0]];
    [text addAttribute:NSForegroundColorAttributeName value:[HXColor hx_colorWithHexString:@"c13e44"] range:rangge1];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:rangge1];
    
    NSRange range2 = [[text string] rangeOfString:@"V"];
    [text addAttribute:NSForegroundColorAttributeName value:[HXColor hx_colorWithHexString:@"c13e44"] range:range2];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:range2];
    return text;
}


#pragma mark - Getters & Setters

-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _levelLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}

- (UIView *)normalView{
    if (!_normalView) {
        _normalView = [[UIView alloc]initWithFrame:CGRectZero];
        _normalView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _normalView;
}

- (UIView *)activeView{
    if (!_activeView) {
        _activeView = [[UIView alloc]initWithFrame:CGRectZero];
        _activeView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _activeView;
}

- (UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView =[[UIImageView alloc]initWithFrame:CGRectZero];
        _backGroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _backGroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backGroundImageView.clipsToBounds = YES;
        _backGroundImageView.image = [UIImage imageNamed:@"member_level_bg"];
        
    }
    return _backGroundImageView;
}

-(UIImageView *)avatorImageView{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _avatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatorImageView.backgroundColor =  [HXColor hx_colorWithHexString:@"c13e44"];
        _avatorImageView.clipsToBounds = YES;
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 72 / 2;
    }
    return _avatorImageView;
}

-(UIImageView *)avatorContentImageView{
    if (!_avatorContentImageView) {
        _avatorContentImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _avatorContentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatorContentImageView.clipsToBounds = YES;
        _avatorContentImageView.layer.borderWidth = 2;
        _avatorContentImageView.layer.masksToBounds = YES;
        _avatorContentImageView.layer.cornerRadius = 70 / 2;
        _avatorContentImageView.layer.borderColor = [HXColor hx_colorWithHexString:@"c13e44"].CGColor;
    }
    return _avatorContentImageView;
}

- (UILabel *)userLevel{
    if (!_userLevel) {
        _userLevel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        _userLevel.translatesAutoresizingMaskIntoConstraints = NO;
        _userLevel.layer.borderColor = [UIColor whiteColor].CGColor;
        _userLevel.layer.borderWidth = 1;
        _userLevel.backgroundColor = [HXColor hx_colorWithHexString:@"ffd438"];
        _userLevel.layer.masksToBounds = YES;
        _userLevel.textAlignment = NSTextAlignmentCenter;
        _userLevel.font = [UIFont systemFontOfSize:13];
        _userLevel.textColor = [UIColor whiteColor];
        _userLevel.layer.cornerRadius = 25 / 2;
    }
    return _userLevel;
}

@end
