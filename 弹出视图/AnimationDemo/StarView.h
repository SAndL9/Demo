//
//  StarView.h
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/14.
//  Copyright © 2017年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView


/**
 星星和圆圈的缩放动画

 @param frame frame
 @param type 1-星星   2-圆圈
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
@end
