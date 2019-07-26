//
//  UIScrollView+LargeArea.m
//  UIScrollview左右滑动
//
//  Created by naiveBoy on 2017/1/16.
//  Copyright © 2017年 liuweipeng. All rights reserved.
//

#import "UIScrollView+LargeArea.h"
#import <objc/runtime.h>
static NSString *const topNameKey = @"topNameKey";
static NSString *const leftNameKey = @"leftNameKey";
static NSString *const bottomNameKey = @"bottomNameKey";
static NSString *const rightNameKey = @"rightNameKey";
static NSString *const nextResponser = @"nextResponser";

@implementation UIScrollView (LargeArea)

- (void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}
//优于pointInside:withEvent方法
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        
        return [super hitTest:point withEvent:event];
    }
    UIView *nextView = objc_getAssociatedObject(self, &nextResponser);
    if (nextView) {
        return CGRectContainsPoint(rect, point) ? self : nextView;
    } else {
        return CGRectContainsPoint(rect, point) ? self : nil;
    }
}


@end
