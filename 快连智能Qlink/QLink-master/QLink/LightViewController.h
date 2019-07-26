//
//  LightViewController.h
//  QLink
//
//  Created by SANSAN on 14-9-28.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwView1.h"
#import "RenameView.h"
#import "BaseViewController.h"
#import "LightBcView.h"
#import "LightBbView.h"
#import "LightBriView.h"

@interface LightViewController : BaseViewController<Sw1Delegate,RenameViewDelegate,LightBcViewDelegate,LightBbViewDelegate,LightBriViewDelegate>

@end
