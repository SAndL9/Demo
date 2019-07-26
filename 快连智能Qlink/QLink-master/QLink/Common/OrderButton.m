//
//  OrderButton.m
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "OrderButton.h"

@implementation OrderButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(OrderButton *)ModelClassForString:(NSString *)type
                         andSubType:(NSString *)subType
{
    NSString *className = [NSString stringWithFormat:@"btn%@_%@",type,subType];
    
    id orderBtn = NSClassFromString(className);
    if (!orderBtn) {
        return nil;
    }
    return (OrderButton *)orderBtn;
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
