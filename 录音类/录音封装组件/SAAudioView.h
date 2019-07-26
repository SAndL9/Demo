//
//  SAAudioView.h
//  SAComponentKitDemo
//
//  Created by 李磊 on 20/7/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAAudioRecordViewController.h"

@protocol SAAudioViewDelegate;
@interface SAAudioView : UIView

/**
 初始化方法
 
 @param viewController 指定控制器
 @return return value description
 */
- (instancetype)initWithFromViewController:(UIViewController *)viewController;

@property (nonatomic, weak) id<SAAudioViewDelegate>delegate;


/**
 最大录音时间
 
 @param timeInterval  <外界不传入 直接写0s 就OK ,默认180s> 单位是 '秒‘
 
 */
- (void)setMaxTimeInterval:(NSTimeInterval)timeInterval;

@end

@protocol SAAudioViewDelegate <NSObject>

@optional


/**
 向外界返回的数据
 
 @param audioView 录音的view
 @param mediaInfo 返回录音的数据,<时间 + 文件路径>
 */
- (void)audioView:(SAAudioView *)audioView didFinishRecord:(id<SAAudioInfoProtocol>)mediaInfo;
@end
