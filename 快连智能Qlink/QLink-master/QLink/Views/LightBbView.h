//
//  LightBbView.h
//  QLink
//
//  Created by SANSAN on 14-9-28.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LightBbViewDelegate <NSObject>

@optional
-(void)handleLongPressed:(NSString *)deviceId andDeviceName:(NSString *)deviceName andLabel:(UILabel *)lTitle;
-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface LightBbView : UIView

@property(nonatomic,assign) id<LightBbViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *vSw;
@property(nonatomic,strong) IBOutlet UILabel *lTitle;
@property(nonatomic,strong) IBOutlet OrderButton *btnOn;
@property(nonatomic,strong) IBOutlet OrderButton *btnOff;
@property(nonatomic,strong) IBOutlet OrderButton *btnUp;
@property(nonatomic,strong) IBOutlet OrderButton *btnDown;
@property(nonatomic,strong) IBOutlet OrderButton *btnFK1;
@property(nonatomic,strong) IBOutlet OrderButton *btnFK2;
@property(nonatomic,strong) IBOutlet OrderButton *btnFK3;
@property(nonatomic,strong) IBOutlet OrderButton *btnFK4;
@property(nonatomic,strong) IBOutlet OrderButton *btnFK5;
@property(nonatomic,strong) IBOutlet OrderButton *btnFK6;

@property(nonatomic,strong) NSString *pDeviceId;
@property(nonatomic,strong) NSString *pDeviceName;
@property(nonatomic,strong) UILabel *plTitle;//用于重命名

- (IBAction)btnPressed:(OrderButton *)sender;
- (IBAction)btnLightPressed:(OrderButton *)sender;
-(IBAction)btnColorPressed:(OrderButton *)sender;

//设置长按事件
-(void)setLongPressEvent;

@end
