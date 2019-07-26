//
//  UIScrollView+LargeArea.h
//  UIScrollview左右滑动
//
//  Created by naiveBoy on 2017/1/16.
//  Copyright © 2017年 liuweipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LargeArea)
- (void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
@end
