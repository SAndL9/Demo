//
//  SABubbleView.h
//  LFBubbleViewDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SATriangleDirection) {
    SATriangleDirection_Down, //气泡在下面
    SATriangleDirection_Left,//在左面
    SATriangleDirection_Right,//在右面
    SATriangleDirection_Up//在上面
};

typedef enum {
    MenuDismiss,      // 消失
    MenuShow,        // 显示
    
} MenuState;

@interface SABubbleView : UIView

/**  菜单的显示状态 */
@property (nonatomic, assign) MenuState state;

//容器，可放自定义视图，默认装文字
@property (nonatomic, strong) UIView *contentView;

//提示文字
@property (nonatomic, strong) UILabel *lbTitle;

//三角方向，默认朝下
@property (nonatomic) SATriangleDirection direction;

//hideAfterSecond秒后自动消失，不设置则不自动消失
@property (nonatomic, assign) CGFloat dismissAfterSecond;



/**
 *  显示
 *
 *  @param point 三角顶端位置
 */
- (void)showInPoint:(CGPoint)point;

/** 隐藏menu */
- (void)hideMenu;

@end
