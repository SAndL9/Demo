//
//  ZQNewGuideView.m
//  新手引导
//
//  Created by zhang on 16/5/21.
//  Copyright © 2016年 zqdreamer. All rights reserved.
//

#import "ZQNewGuideView.h"

@interface ZQNewGuideView ()
/***  引导背景蒙层的颜色，默认为 [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.68]*/
@property (strong, nonatomic) UIColor *guideColor;

@property (strong, nonatomic) UIButton *showRectButton;
@property (strong, nonatomic) UIImageView *textImageView;
@end

@implementation ZQNewGuideView

#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showRect = self.bounds;
        self.guideColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.68];
      
        self.showRectButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.showRectButton.backgroundColor = [UIColor clearColor];
        [self.showRectButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.showRectButton];
        
        self.textImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.textImageView];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)]];
    }
    return self;
}


#pragma mark - override
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, self.bounds);
    

    UIBezierPath *fullPath  = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *showPath  = [UIBezierPath bezierPathWithRect:self.showRect];
    
    
    CGContextAddPath(context, fullPath.CGPath);
    CGContextAddPath(context, showPath.CGPath);
    
    CGContextSetFillColorWithColor(context, self.guideColor.CGColor);
    
    CGContextEOFillPath(context);
    
    self.showRectButton.frame = self.showRect;
    self.textImageView.frame = self.textImageFrame;
}


#pragma mark - event & response
- (void)clickBtn:(UIButton *)btn
{
    if (self.superview != nil) {
        self.showRectButton.frame = CGRectZero;
        self.textImageView.frame = CGRectZero;
        [self removeFromSuperview];
    }
    self.clickedShowRectBlock == nil ? :self.clickedShowRectBlock();
}

- (void)tapBgView:(UITapGestureRecognizer *)gesture
{
    [self removeFromSuperview];
}



#pragma mark - getter & setter
-(void)setShowRect:(CGRect)showRect
{
    _showRect = showRect;
    [self setNeedsDisplay];
}

- (void)setTextImage:(UIImage *)textImage
{
    _textImage = textImage;
    self.textImageView.image = textImage;
    [self setNeedsDisplay];
}


@end
