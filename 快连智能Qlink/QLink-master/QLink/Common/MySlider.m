//
//  MySlider.m
//  QLink
//
//  Created by 尤日华 on 14-10-9.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "MySlider.h"

@implementation MySlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGRect t = [self trackRectForBounds: [self bounds]];
//    float v = [self minimumValue] + ([[touches anyObject] locationInView: self].x - t.origin.x - 4.0) * (([self maximumValue]-[self minimumValue]) / (t.size.width - 8.0));
//    [self setValue: v];
//    [super touchesBegan: touches withEvent: event];
//}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, 10, 185, 3);
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
