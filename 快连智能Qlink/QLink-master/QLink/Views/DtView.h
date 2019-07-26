//
//  DtView.h
//  QLink
//
//  Created by SANSAN on 14-9-24.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DtViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface DtView : UIView

@property(nonatomic,assign) id<DtViewDelegate>delegate;

@property(nonatomic,strong) IBOutlet OrderButton *btnAr_ad;//音量＋
@property(nonatomic,strong) IBOutlet OrderButton *btnAr_rd;//音量－

@property(nonatomic,strong) IBOutlet OrderButton *btnDt_up;//上
@property(nonatomic,strong) IBOutlet OrderButton *btnDt_down;//下
@property(nonatomic,strong) IBOutlet OrderButton *btnDt_left;//左
@property(nonatomic,strong) IBOutlet OrderButton *btnDt_right;//右
@property(nonatomic,strong) IBOutlet OrderButton *btnDt_ok;//ok

@property(nonatomic,strong) IBOutlet OrderButton *btnPd_ad;//频道＋
@property(nonatomic,strong) IBOutlet OrderButton *btnPd_rd;//频道－


- (IBAction)btnPressed:(OrderButton *)sender;

@end
