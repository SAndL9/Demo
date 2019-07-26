//
//  McView.h
//  QLink
//
//  Created by SANSAN on 14-9-24.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol McViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface McView : UIView

@property(nonatomic,assign) id<McViewDelegate>delegate;

@property(nonatomic,strong) IBOutlet OrderButton *btnMc1;
@property(nonatomic,strong) IBOutlet OrderButton *btnMc2;
@property(nonatomic,strong) IBOutlet OrderButton *btnMc3;
@property(nonatomic,strong) IBOutlet OrderButton *btnMc4;

- (IBAction)btnPressed:(OrderButton *)sender;

@end
