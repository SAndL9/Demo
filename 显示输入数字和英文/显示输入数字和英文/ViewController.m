//
//  ViewController.m
//  显示输入数字和英文
//
//  Created by 李磊 on 7/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//


#import "ViewController.h"
#import "SAObjective.h"
#import <objc/runtime.h>

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

const NSString *ALPHANUM1 = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";


@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
       NSLog(@"这是我自己实现的方法了啊！！！");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.nameLabel];
//    SEL sel = @selector(viewWillAppear:);
//    SEL asel = NSSelectorFromString(@"viewWillAppear:");
//    SEL ssel = sel_registerName("viewWillAppear:");
//    NSLog(@"%p________%p_____%p",sel,asel,ssel);
    
    
    
    
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM ] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered ];
}



- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width- 40, 40)];
        _textField.delegate = self;
        _textField.placeholder = @"请输入你要搜索的商品";
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.backgroundColor = [UIColor redColor];
    }
    return _textField;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(60, 250, 200, 40)];
        _nameLabel.text = @"这是测试数据使用规则";
        [_nameLabel setTextColor:[UIColor yellowColor]];
    }
    return _nameLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
