//
//  SdView.h
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SdViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface SdView : UIView

@property(nonatomic,assign) id<SdViewDelegate>delegate;

@property(nonatomic,strong) IBOutlet OrderButton *btnTopLeft;
@property(nonatomic,strong) IBOutlet OrderButton *btnTopMiddle;
@property(nonatomic,strong) IBOutlet OrderButton *btnTopRight;
@property(nonatomic,strong) IBOutlet OrderButton *btnBottomLeft;
@property(nonatomic,strong) IBOutlet OrderButton *btnBottomRight;

- (IBAction)btnPressed:(OrderButton *)sender;

@end
