//
//  SwView1.m
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SwView1.h"

@implementation SwView1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//设置长按事件
-(void)setLongPressEvent
{
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 1.0;//表示最短长按的时间
    //将长按手势添加到需要实现长按操作的视图里
    [self addGestureRecognizer:longPress];
}

- (IBAction)btnPressed:(OrderButton *)sender {
    NSLog(@"=====%@",sender.orderObj.OrderName);
    if (self.delegate) {
        [self.delegate orderDelegatePressed:sender];
    }
}

//长按事件的实现方法
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [self.delegate handleLongPressed:_pDeviceId andDeviceName:_pDeviceName andLabel:_plTitle];
        
        NSLog(@"deviceId=%@",_pDeviceId);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
