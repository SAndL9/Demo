//
//  LoginViewController.h
//  QLink
//
//  Created by 尤日华 on 14-9-17.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionNullClass.h"
#import "SetupIpViewController.h"

@interface LoginViewController : SetupIpViewController<UITextFieldDelegate>

@property(nonatomic,strong) IBOutlet UITextField *tfKey;
@property(nonatomic,strong) IBOutlet UITextField *tfName;
@property(nonatomic,strong) IBOutlet UITextField *tfPassword;
@property(nonatomic,strong) IBOutlet UIButton *btnRemeber;
@property (weak, nonatomic) IBOutlet UILabel *lblCompany;

-(IBAction)btnLogin;
-(IBAction)btnRemeberPressed:(UIButton *)sender;
- (IBAction)btnRegister:(id)sender;

@end
