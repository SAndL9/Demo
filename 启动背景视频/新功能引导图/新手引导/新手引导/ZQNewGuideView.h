//
//  ZQNewGuideView.h
//  新手引导
//
//  Created by zhang on 16/5/21.
//  Copyright © 2016年 zqdreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedShowRectBlock)();

@interface ZQNewGuideView : UIView

/***  透明区域frame*/
@property (assign, nonatomic) CGRect showRect;

/***  描述文本图片*/
@property (strong, nonatomic) UIImage *textImage;

/***  描述文本图片的frame*/
@property (assign, nonatomic) CGRect textImageFrame;

/***  点击透明区域的处理*/
@property (copy, nonatomic) ClickedShowRectBlock clickedShowRectBlock;

@end
