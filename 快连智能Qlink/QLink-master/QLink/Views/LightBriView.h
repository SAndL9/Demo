//
//  LightBriView.h
//  QLink
//
//  Created by SANSAN on 14-9-28.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySlider.h"

@protocol LightBriViewDelegate <NSObject>

@optional
-(void)handleLongPressed:(NSString *)deviceId andDeviceName:(NSString *)deviceName andLabel:(UILabel *)lTitle;
-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface LightBriView : UIView


@property (weak, nonatomic) IBOutlet UIView *vSw;
@property(nonatomic,assign) id<LightBriViewDelegate>delegate;
@property(nonatomic,strong) IBOutlet UILabel *lTitle;
@property(nonatomic,strong) IBOutlet OrderButton *btnOn;
@property(nonatomic,strong) IBOutlet OrderButton *btnOff;
@property (strong, nonatomic) IBOutlet MySlider *sliderLight;

@property(nonatomic,strong) NSArray *brOrderArr;
@property(nonatomic,strong) NSString *pDeviceId;
@property(nonatomic,strong) NSString *pDeviceName;
@property(nonatomic,strong) UILabel *plTitle;//用于重命名

- (IBAction)btnPressed:(OrderButton *)sender;

//设置长按事件
-(void)setLongPressEvent;

@end
