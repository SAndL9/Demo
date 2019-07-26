//
//  FireworkView.h
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/14.
//  Copyright © 2017年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FireworkView : UIView


/**
 烟花效果

 @param frame frame
 @param type 1-粗线   2-细线  3-右上角三条线
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
