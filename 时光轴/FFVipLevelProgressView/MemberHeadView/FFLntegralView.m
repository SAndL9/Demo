//
//  FFLntegralView.m
//  FFVipLevelProgressView
//
//  Created by Mr.Yao on 16/10/21.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "FFLntegralView.h"
#import "FFNumberScrollView.h"

#import <HexColors/HexColors.h>

@interface FFLntegralView()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * integralImageView;

@property (nonatomic, strong) FFNumberScrollView * numberView;

@end

@implementation FFLntegralView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.integralImageView];
    [self addSubview:self.numberView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_numberView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_numberView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_integralImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-10]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_integralImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_integralImageView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_titleLabel]-2-[_integralImageView]-6-[_numberView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_integralImageView,_titleLabel,_numberView)]];
}

- (void)startAnimationWithNumber:(NSInteger)number{
    [self.numberView setValue:[NSNumber numberWithInteger:number]];
    [self.numberView startAnimation];
}

-(UIImageView *)integralImageView{
    if (!_integralImageView) {
        _integralImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _integralImageView.translatesAutoresizingMaskIntoConstraints =  NO;
        _integralImageView.contentMode = UIViewContentModeScaleAspectFill;
        _integralImageView.clipsToBounds  =YES;
        _integralImageView.backgroundColor = [UIColor clearColor];
        _integralImageView.image = [UIImage imageNamed:@"member_integral"];
    }
    return _integralImageView;
}

- (FFNumberScrollView *)numberView{
    if (!_numberView) {
        _numberView = [[FFNumberScrollView alloc]initWithFrame:CGRectMake(0, 0, 200, 14)];
        _numberView.translatesAutoresizingMaskIntoConstraints = NO;
        _numberView.textColor = [HXColor hx_colorWithHexString:@"ffd439"];
        _numberView.font = [UIFont fontWithName:@"Helvetica-Roman" size:15];
        _numberView.minLength = 1;
    }
    return _numberView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"积分";
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

@end
