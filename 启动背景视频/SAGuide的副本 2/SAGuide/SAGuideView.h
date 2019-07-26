//
//  SAGuideView.h
//  SAGuide
//
//  Created by 李磊 on 26/7/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAGuideViewProtocolDelegate <NSObject>

//- (UIImage *)saGuideViewDataSource:(NSArray <UIImage *> *)dataSource 

@end



@interface SAGuideView : UIView





/**
 在蒙版上显示弹出框

 */
//- (void)showIconImgArray:(NSArray <UIImage *> *)arrayImage;



- (void)showIconImgArray:(NSArray <UIImage *> *)arrayImage andViewArray:(NSArray <UIView *> *)viewArray;

@end
