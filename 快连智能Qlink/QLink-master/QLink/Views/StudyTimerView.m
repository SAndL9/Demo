//
//  StudyTimerView.m
//  QLink
//
//  Created by 尤日华 on 14-10-13.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "StudyTimerView.h"

@implementation StudyTimerView
{
    NSTimer *timer_;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)startTimer
{
    _lTimer.text = @"30";
    self.pTime = 30;
    timer_ = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    self.pTime --;
    if (self.pTime <= 0) {
        [timer_ invalidate];
        [self btnDone];
        return;
    }
    
    _lTimer.text = [NSString stringWithFormat:@"%d",self.pTime];
}

-(IBAction)btnDone
{
    if (self.delegate) {
        [timer_ invalidate];
        [self.delegate done];
    }
}

@end
