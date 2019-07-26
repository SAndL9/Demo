//
//  HsView.h
//  QLink
//
//  Created by SANSAN on 14-9-24.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HsViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface HsView : UIView

@property(nonatomic,assign) id<HsViewDelegate>delegate;

- (IBAction)btnPressed:(OrderButton *)sender;

@end
