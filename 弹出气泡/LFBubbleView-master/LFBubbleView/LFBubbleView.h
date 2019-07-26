//
//  LFBubbleView.h
//  LFBubbleViewDemo
//
//  Created by 张林峰 on 16/6/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>


    


typedef NS_ENUM(NSInteger, LFTriangleDirection) {
    LFTriangleDirection_Down, //在下面
    LFTriangleDirection_Left,//在左面
    LFTriangleDirection_Right,//在右面
    LFTriangleDirection_Up//在上面
};

typedef enum {
    MenuDismiss,      // 消失
    MenuShow,        // 显示
    
} MenuState;

@interface LFBubbleView : UIView
/**
 *  菜单的显示状态
 */
@property (nonatomic, assign) MenuState state;


@property (nonatomic, strong) UIView *contentView;//容器，可放自定义视图，默认装文字

@property (nonatomic, strong) UILabel *lbTitle;//提示文字

@property (nonatomic) LFTriangleDirection direction;//三角方向，默认朝下

@property (nonatomic, assign) CGFloat dismissAfterSecond;//hideAfterSecond秒后自动消失，不设置则不自动消失

//优先使用triangleXY。如果triangleXY和triangleXYScale都不设置，则三角在中间
@property (nonatomic, assign) CGFloat triangleXY;//三角中心的x或y（三角朝上下代表x,三角朝左右代表y）
@property (nonatomic, assign) CGFloat triangleXYScale;//三角的中心x或y位置占边长的比例，如0.5代表在中间

/**
 *  显示
 *
 *  @param point 三角顶端位置
 */
- (void)showInPoint:(CGPoint)point;

/** 隐藏menu */
- (void)hideMenu;

@end
