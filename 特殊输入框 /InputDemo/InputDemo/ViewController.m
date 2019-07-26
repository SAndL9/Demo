//
//  ViewController.m
//  InputDemo
//
//  Created by tianlei on 2017/3/24.
//  Copyright © 2017年 QF-001. All rights reserved.
//

#import "ViewController.h"
#import "InputView.h"

@interface ViewController ()

@property (nonatomic, strong) InputView *inputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inputView = [[InputView alloc] init];
    [self.view addSubview:_inputView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    NSLog( @"%@", _inputView.text );
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
