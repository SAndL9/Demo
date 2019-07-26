//
//  ViewController.h
//  JXTutorialSimpleRateView
//
//  Created by 汪骏祥 on 9/17/15.
//  Copyright (c) 2015 junxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface ViewController : UIViewController <RateViewDelegate>

@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end

