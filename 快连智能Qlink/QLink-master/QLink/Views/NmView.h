//
//  NmView.h
//  QLink
//
//  Created by SANSAN on 14-9-24.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NmViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface NmView : UIView

@property(nonatomic,assign) id<NmViewDelegate>delegate;

- (IBAction)btnPressed:(OrderButton *)sender;

@end
