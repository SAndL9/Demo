//
//  ViewController.m
//  SAGuide
//
//  Created by 李磊 on 26/7/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "ViewController.h"
#import "SAGuideView.h"
@interface ViewController ()


/**  */
@property (nonatomic, strong) SAGuideView * v;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _v  = [[SAGuideView alloc]init];
    [_v showIconImg:[UIImage imageNamed:@"2222.png"]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}






@end
