//
//  PlView.h
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlViewDelegate <NSObject>

-(void)orderDelegatePressed:(OrderButton *)sender;

@end

@interface PlView : UIView

@property(nonatomic,assign) id<PlViewDelegate>delegate;

@property(nonatomic,strong) IBOutlet OrderButton *btnLeftTop;
@property(nonatomic,strong) IBOutlet OrderButton *btnRightTop;
@property(nonatomic,strong) IBOutlet OrderButton *btnLeftMiddle;
@property(nonatomic,strong) IBOutlet OrderButton *btnMiddle;
@property(nonatomic,strong) IBOutlet OrderButton *btnRightMiddle;
@property(nonatomic,strong) IBOutlet OrderButton *btnLeftBottom;
@property(nonatomic,strong) IBOutlet OrderButton *btnRightBottom;

- (IBAction)btnPressed:(OrderButton *)sender;


@end
