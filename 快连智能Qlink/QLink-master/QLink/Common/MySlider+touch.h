//
//  MySlider+touch.h
//  QLink
//
//  Created by 尤日华 on 14-12-11.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "MySlider.h"

@interface MySlider (touch)
// 单击手势
- (void)addTapGestureWithTarget: (id)target
                         action: (SEL)action;
@end
