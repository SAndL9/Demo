//
//  MaskView.h
//  不规则截图
//
//  Created by macbook on 16/8/2.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    下面的类是我自己定义的。主要是用来表示四个点的坐标，因为CGPoint是结构体，无法添加到NSArray里面，所以自定义类之后可以直接添加了
    主要也就是x，y两个属性，表示位置
 */

@interface TPoint: NSObject
/** x */
@property (assign, nonatomic) CGFloat x;
/** y */
@property (assign, nonatomic) CGFloat y;
//初始化方法 直接传入x，y
- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y;
//相当于x，y的设置或更新方法，只不过传入的是CGPoint结构体
- (void)setPoint:(CGPoint)point;
//获取x，y。方法中用了CGPointMake(x,y)进行结构转换
- (CGPoint)getPoint;


/**
 
    这个方法的作用比较大，因为手势判断的时候触摸点位置不好判断。
    有一个方法是CGRectContainsPoint(rect, point)，就是用来判断这个point点的位置是不是在rect里面 
 
 
 */
- (CGRect)getRect;
@end




@interface MaskView : UIView
- (NSArray *)getPoints;
- (UIImage *)getSnipImageWithImage:(UIImage *)image;
@end
