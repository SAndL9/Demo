//
//  RegisterViewController.h
//  QLink
//
//  Created by 尤日华 on 15-1-7.
//  Copyright (c) 2015年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain) LoginViewController *loginVC;

@end
