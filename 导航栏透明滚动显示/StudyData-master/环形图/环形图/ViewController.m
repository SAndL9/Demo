//
//  ViewController.m
//  环形图
//
//  Created by 舒通 on 2017/4/7.
//  Copyright © 2017年 shutong. All rights reserved.
//

#import "ViewController.h"
#import "PieChartView.h"

@interface ViewController ()

@property (nonatomic, strong) PieChartView *pie;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pie = [[PieChartView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.pie.markName = @[@"商城总订单量",@"此商品订单量"];
    [self.view addSubview:self.pie];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    int x = arc4random() % 100;
    [self.pie upLoadPieChartWithProgress:x * 0.01];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
