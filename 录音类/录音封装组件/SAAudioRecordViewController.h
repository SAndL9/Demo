//
//  SAAudioRecordViewController.h
//  SAComponentKitDemo
//
//  Created by 李磊 on 20/7/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SAAudioRecordViewControllerDelegate;

@protocol SAAudioInfoProtocol <NSObject>

/**
 用于给外界返回录音的信息
 
 @return 录音的path
 */
- (NSURL *)audioFileURL;

/**
 用于给外界返回录音的信息
 
 @return 录音的时间
 */
- (NSString *)audioTimeInterval;

@end


@interface SAAudioRecordViewController : UIViewController


/**  */
@property (nonatomic, weak) id<SAAudioRecordViewControllerDelegate> delegate;

/**
 设置录音的最大时间
 
 @param timeInterval 单位s,
 */
- (void)setMaxTimeInterval:(NSTimeInterval)timeInterval;

@end

@protocol SAAudioRecordViewControllerDelegate <NSObject>

- (void)audioRecordViewController:(SAAudioRecordViewController *)audioRecordViewController didFinishRecord:(id<SAAudioInfoProtocol>)audioInfo;

@end
