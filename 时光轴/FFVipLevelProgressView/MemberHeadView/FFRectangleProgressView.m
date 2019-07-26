//
//  FFHeadProgressView.m
//  LosAngeles
//
//  Created by Mr.Yao on 16/10/21.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "FFRectangleProgressView.h"

@interface FFRectangleProgressView ()

/**
 *  进度条 progressView
 */
@property (nonatomic, strong) UIView *progressView;

@property (strong, nonatomic) NSTimer *countdownTimer;

/**
 *  progressView Rect
 */
@property (nonatomic) CGRect rect_progressView;

/**
 *  限制高度大小
 *
 *  @param rect self.height
 */
- (void)_setHeightRestrictionOfFrame:(CGFloat)height;

@end

@implementation FFRectangleProgressView

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor colorWithRed:0.973 green:0.745 blue:0.306 alpha:1.000];
        [self addSubview:self.progressView];
    }
    return _progressView;
}

#pragma mark -  initWithFrame

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:0.937 green:0.958 blue:1.000 alpha:1.000];

        [self _setHeightRestrictionOfFrame:frame.size.height];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.937 green:0.958 blue:1.000 alpha:1.000];
        [self _setHeightRestrictionOfFrame:11];
    }
    return self;
}

#pragma mark - Privite Method
- (void)_setHeightRestrictionOfFrame:(CGFloat)height {
    CGRect rect = self.frame;

    _progressHeight = MIN(height, 100.0);
    _progressHeight = MAX(_progressHeight, 5.0);

    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, _progressHeight);

    self.rect_progressView = CGRectZero;
    _rect_progressView.size.height = _progressHeight;
    self.progressView.frame = self.rect_progressView;

    self.layer.cornerRadius = self.progressView.layer.cornerRadius = _progressHeight / 2.0;

    [self createTime];

}

- (void)createTime{
    [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];
}

- (void) listenProgressWidthChanged{
    CGRect rect = [[self.progressView.layer presentationLayer ]frame];
    
    if ([self.delegate respondsToSelector:@selector(progressWidthChangedWithWidth:)]) {
        [self.delegate progressWidthChangedWithWidth:rect.size.width];
    }
}

- (NSTimer *)countdownTimer{
    if (!_countdownTimer) {
         _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(listenProgressWidthChanged) userInfo:nil repeats:YES];
    }
    return _countdownTimer;
}

#pragma mark - Setter

- (void)setProgressHeight:(CGFloat)progressHeight {
    [self _setHeightRestrictionOfFrame:progressHeight];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;

    self.backgroundColor = _progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;

    self.progressView.backgroundColor = _trackTintColor;
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;

    _rect_progressView.size.width = _progressValue;
    
    [UIView animateWithDuration:self.durationValue
                     animations:^{
                       self.progressView.frame = _rect_progressView;
                     }completion:^(BOOL finished) {
                         [self.countdownTimer invalidate];
                         if ([self.delegate respondsToSelector:@selector(animationFinish)]) {
                             [self.delegate animationFinish];
                         }
                    }];
}

- (float)durationValue{
    if (!_durationValue) {
        CGFloat maxValue = self.bounds.size.width;
        _durationValue = (_progressValue / 2.0) / maxValue + .5;
    }
    return _durationValue;
}

@end
