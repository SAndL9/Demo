//
//  LineView.h
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/15.
//  Copyright © 2017年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

/**
 线条效果
 
 @param frame frame
 @param type 1-往左跑   2-往右跑
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
