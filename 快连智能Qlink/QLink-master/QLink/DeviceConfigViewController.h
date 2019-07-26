//
//  DeviceConfigViewController.h
//  QLink
//
//  Created by 尤日华 on 14-10-3.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionNullClass.h"
#import "BaseViewController.h"

@interface DeviceConfigViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ActionNullClassDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbDevice;

@end
