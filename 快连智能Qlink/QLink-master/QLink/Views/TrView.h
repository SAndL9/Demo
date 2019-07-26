//
//  TrView.h
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface TrView : UIView

@property(nonatomic,assign) id<TrViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet OrderButton *btnSheng;
@property (strong, nonatomic) IBOutlet OrderButton *btnJiang;



- (IBAction)btnPressed:(OrderButton *)sender;

@end
