//
//  LightBcView.m
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LightBcView.h"
#import "MySlider+touch.h"

@implementation LightBcView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [_btnBr setThumbImage:[UIImage imageNamed:@"light_roundButton.png"] forState:UIControlStateNormal];
    [_btnCo setThumbImage:[UIImage imageNamed:@"light_roundButton.png"] forState:UIControlStateNormal];
    [_btnCo setMaximumTrackTintColor:[UIColor clearColor]];
    [_btnBr setMaximumTrackTintColor:[UIColor clearColor]];
    
    [_btnCo addTapGestureWithTarget:self action:@selector(coValueChange)];
    [_btnBr addTapGestureWithTarget:self action:@selector(brValueChange)];
}

-(void)coValueChange
{
    [self coSliderValueChanged:_btnCo];
}

-(void)brValueChange
{
    [self brSliderValueChanged:_btnBr];
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

-(IBAction)coSliderValueChanged:(UISlider *)slider
{
    OrderButton *orderBtn = [OrderButton buttonWithType:UIButtonTypeCustom];
    
    float value = slider.value;
    if (0.1 > value > 0) {
        slider.value = 0;
        for (Order *orderObj in _coOrderArr) {
            if ([orderObj.SubType isEqualToString:@"sun"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.3 > value >= 0.1) {
        slider.value = 0.2;
        for (Order *orderObj in _coOrderArr) {
            if ([orderObj.SubType isEqualToString:@"red"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if(0.5 > value >= 0.3) {
        slider.value = 0.4;
        for (Order *orderObj in _coOrderArr) {
            if ([orderObj.SubType isEqualToString:@"yelow"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.7 > value >= 0.5) {
        slider.value = 0.6;
        for (Order *orderObj in _coOrderArr) {
            if ([orderObj.SubType isEqualToString:@"green"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (0.9 > value >= 0.7) {
        slider.value = 0.8;
        for (Order *orderObj in _coOrderArr) {
            if ([orderObj.SubType isEqualToString:@"blue"]) {
                orderBtn.orderObj = orderObj;
                break;
            }
        }
    } else if (1 >= value >= 0.9)
    {
        slider.value = 1;
        for (Order *orderObj in _coOrderArr) {
            if ([orderObj.SubType isEqualToString:@"write"]) {
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
