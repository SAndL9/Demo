//
//  ViewController.m
//  EMPasswordIInputViewDemo
//
//  Created by Eric MiAo on 2017/6/1.
//  Copyright © 2017年 Eric MiAo. All rights reserved.
//

#import "ViewController.h"
#import "EMPasswordInputView.h"

@interface ViewController ()<EMPasswordInputViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    EMPasswordInputView *empView = [EMPasswordInputView inputViewWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 250) / 2.0, 160, 250, 58) numberOfCount:4 widthOfLine:40 intervalOfLine:30];
    empView.delegate = self;
    empView.contentAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:27]};
    empView.lineHeight = 2;
    empView.wordsLineOffset = 7;
    empView.passwordKeyboardType = UIKeyboardTypeNumberPad;
//    empView.passwordType = EMPasswordTypeDefault;
    empView.passwordType = EMPasswordTypeCustom;
    empView.customPasswordStr = @"🐒";
    [self.view addSubview:empView];
    NSLog(@"%f  %f",empView.widthOfLine,empView.intervalOfLine);
    
}

- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView finishInput:(NSString *)contentStr {
    NSLog(@"1.%@ -----是最后调用",contentStr);
    
}

- (void)EM_passwordInputView:(EMPasswordInputView *)passwordView edittingPassword:(NSString *)contentStr inputStr:(NSString *)inputStr {
    NSLog(@"2.%@,%@",contentStr,inputStr);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    NSLog(@"touch");
}



@end
