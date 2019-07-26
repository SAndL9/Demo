//
//  SAGuideView.m
//  SAGuide
//
//  Created by 李磊 on 26/7/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SAGuideView.h"

@interface SAGuideView ()

/**  */
@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, assign) NSInteger currentIndex;


/**  */
@property (nonatomic, strong) NSArray *array;

@end

@implementation SAGuideView


- (void)showIconImgArray:(NSArray <UIImage *> *)arrayImage{
    self.currentIndex = 1;
    _array = arrayImage;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [window bringSubviewToFront:self];

    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.center = window.center;
//    self.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:33.0/255.0 blue:34.0/255.0 alpha:0.97];

   
    _iconImgView = [[UIImageView alloc]init];
    _iconImgView.userInteractionEnabled = YES;
    _iconImgView.image = arrayImage.firstObject;
    _iconImgView.frame = self.bounds;
    [self addSubview:_iconImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressTapAction)];
    
    [self addGestureRecognizer:tap];
    
}


- (void)pressTapAction{
    
    self.currentIndex++;
    NSLog(@"currentIndex---%ld",(long)self.currentIndex);
    if (self.currentIndex <= _array.count) {
        _iconImgView.image = _array[_currentIndex - 1];
    }else{
       [self removeFromSuperview];
    }
    
    
}





@end
