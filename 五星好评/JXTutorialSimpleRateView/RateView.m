//
//  RateView.m
//  JXTutorialSimpleRateView
//
//  Created by 汪骏祥 on 9/17/15.
//  Copyright (c) 2015 junxiang. All rights reserved.
//

#import "RateView.h"

@implementation RateView

- (void)baseInit {  // 变量初始化
    editable = NO;
    midMargin = 5;
    leftMargin = 0;
    minImageSize = CGSizeMake(5, 5);
    _notSelectedImage = nil;
    _selectedImage = nil;
    _imageViews = [[NSMutableArray alloc] init];
    _rating = 0;
    _maxRating = 5;
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)refresh {   // 刷新点赞图片显示
    for (int i=0; i<_imageViews.count; i++) {
        UIImageView *imageView = [_imageViews objectAtIndex:i];
        if (_rating >= i+1) {
            imageView.image = _selectedImage;
        }else {
            imageView.image = _notSelectedImage;
        }
    }
}

- (void)layoutSubviews { // 点赞图片的布局设置
    [super layoutSubviews];
    
    if (_notSelectedImage == nil || _imageViews.count == 0) {
        return ;
    }
    
    float desiredImageWidth = (self.frame.size.width - (leftMargin*2) - (midMargin*_imageViews.count)) / _imageViews.count;
    float imageWidth = MAX(minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(minImageSize.height, self.frame.size.height);
    
    for (int i=0; i<_imageViews.count; i++) {
        UIImageView *imageView = [_imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(leftMargin + i*(midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
    }
}

- (void)updateImageViews { // 更新点赞图片显示数目
    // 移除旧的图片
    for (int i=0; i<_imageViews.count; i++) {
        UIImageView *imageView = (UIImageView *) [_imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [_imageViews removeAllObjects];
    
    // 添加新的图片
    for (int i=0; i<_maxRating; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageViews addObject:imageView];
        [self addSubview:imageView];
    }
}

- (void)setEditable: (bool) editabl andNotSelectedImage: (UIImage *) notSelectedImag andSelectedImage: (UIImage *) selectedImag andRating: (int) ratin andMaxRating: (int) maxRatin andDelegate:(id<RateViewDelegate>)delegat{
    editable = editabl;
    _notSelectedImage = notSelectedImag;
    _selectedImage = selectedImag;
    _rating = ratin;
    self.maxRating = maxRatin;
    _delegate = delegat;
}

- (void)setMaxRating:(int)maxRating { // 设置最大值的时候更新点赞图片数量、布局以及它们的显示。
    _maxRating = maxRating;
    [self updateImageViews];
    [self setNeedsLayout];
    [self refresh];
}

- (void)setRating: (int)rating {
    _rating = rating;
    [self refresh];
}

- (void)setNotSelectedImage:(UIImage *)notSelectedImage {
    _notSelectedImage = notSelectedImage;
    [self refresh];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    [self refresh];
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    if (!editable) {
        return ;
    }
    int newRating = 0;
    for (int i=(int)_imageViews.count-1; i>=0; --i) {
        UIImageView *imageView = [_imageViews objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x) {
            newRating = i+1;
            break;
        }
    }
    self.rating = newRating;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate ratingDidChange:_rating];
}


@end
