//
//  RenameView.m
//  QLink
//
//  Created by SANSAN on 14-9-23.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "RenameView.h"
#import "DataUtil.h"

@implementation RenameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)btnCanclePressed
{
    if (self.delegate) {
        [self.delegate handleCanclePressed];
    }
}

-(IBAction)btnConfirm
{
    if ([DataUtil checkNullOrEmpty:_tfContent.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您还没有输入名称." delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.delegate) {
        if (_lTitle) {//照明重命名
            [self.delegate handleConfirmPressed:_pDeviceId andNewName:_tfContent.text andLabel:_lTitle];
        }else{
            [self.delegate handleConfirmPressed:_pDeviceId andNewName:_tfContent.text andType:_pType];
        }
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"登录页_输入框02.png"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"登录页_输入框01.png"];
}

#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tfContent resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
