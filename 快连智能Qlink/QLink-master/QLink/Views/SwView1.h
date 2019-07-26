//
//  SwView1.h
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderButton.h"

@protocol Sw1Delegate <NSObject>

@optional

-(void)handleLongPressed:(NSString *)deviceId andDeviceName:(NSString *)deviceName andLabel:(UILabel *)lTitle;

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface SwView1 : UIView

@property(nonatomic,assign) id<Sw1Delegate>delegate;
@property(nonatomic,strong) NSString *pDeviceId;
@property(nonatomic,strong) NSString *pDeviceName;
@property(nonatomic,strong) UILabel *plTitle;//用于重命名

//light
@property(nonatomic,strong) IBOutlet UILabel *lTitle1;
@property(nonatomic,strong) IBOutlet OrderButton *btnOn1;
@property(nonatomic,strong) IBOutlet OrderButton *btnOff1;

//light_1 翻转
@property (strong, nonatomic) IBOutlet UILabel *lTitle2;
@property(nonatomic,strong) IBOutlet OrderButton *btnOn2;
@property(nonatomic,strong) IBOutlet OrderButton *btnOff2;

//light_check 点动
@property (strong, nonatomic) IBOutlet UILabel *lTitle3;
@property(nonatomic,strong) IBOutlet OrderButton *btnOn3;
@property(nonatomic,strong) IBOutlet OrderButton *btnOff3;

//设置长按事件
-(void)setLongPressEvent;

- (IBAction)btnPressed:(OrderButton *)sender;

@end
