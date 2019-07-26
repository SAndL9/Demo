//
//  StarView.m
//  EvaluationStar
//
//  Created by 赵贺 on 15/11/26.
//  Copyright © 2015年 赵贺. All rights reserved.
//

#import "StarView.h"

#define imageW  self.bounds.size.width/10

@interface StarView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;


@end
@implementation StarView


- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star{
    
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty];
        self.starForegroundView = [self buidlStarViewWithImageName:Star];
        [self addSubview:self.starBackgroundView];
        
        self.userInteractionEnabled = YES;
        
        /**点击手势*/
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        /**滑动手势*/
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:panGR];
        
        
        
    }
    return self;
    
}


- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    
    
    for (int j = 0; j < 5; j ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(2*j*imageW, 0, imageW, imageW);
        [view addSubview:imageView];
    }
    
    return view;
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint point =[tapGR locationInView:self];
    if (point.x<0) {
        point.x = 0;
    }
    
    int X = (int) point.x/(2*imageW);
    
    self.starForegroundView.frame = CGRectMake(0, 0, (X)*2*imageW, imageW);
    [self addSubview:self.starForegroundView];
    
    
}
@end
