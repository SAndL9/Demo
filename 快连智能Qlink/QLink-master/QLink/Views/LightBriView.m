//
//  LightBriView.m
//  QLink
//
//  Created by SANSAN on 14-9-28.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LightBriView.h"
#import "MySlider+touch.h"

@implementation LightBriView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
    _sliderLight.continuous = NO;
    _sliderLight.frame = CGRectMake(100, 44, 206, 5);
    [_sliderLight setThumbImage:[UIImage imageNamed:@"light_roundButton.png"] forState:UIControlStateNormal];
    [_sliderLight setMaximumTrackTintColor:[UIColor clearColor]];
    [_sliderLight addTapGestureWithTarget:self action:@selector(valueChange)];
}

-(void)valueChange
{
    [self brSliderValueChanged:_sliderLight];
}

-(IBAction)brSliderValueChanged:(UISlider *)slider
{
    OrderButton *orderBtn = [OrderButton buttonWithType:UIButtonTypeCustom];
    
    float value = slider.value;
    if (0.08 > value > 0) {
        slider.value = 0.05;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b5"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.28 > value >= 0.08) {
        slider.value = 0.15;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b15"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if(0.42 > value >= 0.28) {
        slider.value = 0.35;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b35"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.55 > value >= 0.42) {
        slider.value = 0.5;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b50"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.65 > value >= 0.55) {
        slider.value = 0.6;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b60"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.75 > value >= 0.65) {
        slider.value = 0.7;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b70"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.85 > value >= 0.75) {
        slider.value = 0.8;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b80"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.95 > value >= 0.85) {
        slider.value = 0.9;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b90"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (value >= 0.95) {
        slider.value = 1;
        for (Order *orderObj in _brOrderArr) {
            if ([orderObj.SubType isEqualToString:@"b100"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    }
    
    if (self.delegate && orderBtn.orderObj) {
        [self.delegate orderDelegatePressed:orderBtn];
    }
}

- (IBAction)btnPressed:(OrderButton *)sender
{
    if (self.delegate) {
        [self.delegate orderDelegatePressed:sender];
    }
}

//设置长按事件
-(void)setLongPressEvent
{
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 1.0;//表示最短长按的时间
    //将长按手势添加到需要实现长按操作的视图里
    [self.vSw addGestureRecognizer:longPress];
}

//长按事件的实现方法
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [self.delegate handleLongPressed:_pDeviceId andDeviceName:_pDeviceName andLabel:_plTitle];
        
        NSLog(@"deviceId=%@",_pDeviceId);
    }
}

@end
