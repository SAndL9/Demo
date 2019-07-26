//
//  BottomView.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/15.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()
// 1-男版   2-女版
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIView *moveView;
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        [self createContent];
    }
    return self;
}

- (void)createContent
{
    
    
}



@end
