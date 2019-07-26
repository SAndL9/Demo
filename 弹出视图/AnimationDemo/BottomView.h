//
//  BottomView.h
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/15.
//  Copyright © 2017年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView

/**
 底部视图
 
 @param frame frame
 @param type 1-男版   2-女版
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
