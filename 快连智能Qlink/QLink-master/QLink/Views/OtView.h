//
//  OtView.h
//  QLink
//
//  Created by SANSAN on 14-9-24.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderButton.h"

@protocol OtViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface OtView : UIView

@property(nonatomic,assign) id<OtViewDelegate>delegate;

@property(nonatomic,strong) IBOutlet OrderButton *btnLeft;
@property(nonatomic,strong) IBOutlet OrderButton *btnRight;

- (IBAction)btnPressed:(OrderButton *)sender;

@end
