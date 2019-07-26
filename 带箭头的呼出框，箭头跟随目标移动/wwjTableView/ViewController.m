//
//  ViewController.m
//  wwjTableView
//
//  Created by 吴伟军 on 16/7/7.
//  Copyright © 2016年 wuwj. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+AttributedString.h"
#import "ArrowAngleView.h"
@interface ViewController ()<ArrowAngleViewDelegate,UIGestureRecognizerDelegate>{
    ArrowAngleView *arrowView;
    NSArray *dataArray;
    UILabel *titleLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"];
    titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 150, 20))];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self titleLabel:titleLabel title:@"title1"];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(150, 300, 100, 30);
    [button setTitle:@"点击变换title" forState:(UIControlStateNormal)];
    button.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissArrowView)];
    tap.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button2.frame = CGRectMake(50, 100, 100, 30);
    [button2 setTitle:@"点击变换title" forState:(UIControlStateNormal)];
    button2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *button3 = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button3.frame = CGRectMake(250, 100, 100, 30);
    [button3 setTitle:@"点击变换title" forState:(UIControlStateNormal)];
    button3.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)click:(UIButton *)button{
    [arrowView removeFromSuperview];
    NSLog(@"%f",button.frame.origin.x);
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowView = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 300))];
    arrowView.delegate = self;
    arrowView.targetRect = button.frame;
    arrowView.dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self.view addSubview:arrowView];
}

- (void)dismissArrowView{
    [arrowView removeFromSuperview];
}

- (void)titleLabel:(UILabel *)Label title:(NSString *)title{
    [Label setLabelTextWithRightImage:[UIImage imageNamed:@"Image_arrow"] andTitle:title];
}

- (void)didSelectedWithIndexPath:(NSInteger)indexpath{
    [self titleLabel:titleLabel title:dataArray[indexpath]];
}

//解决触摸事件和点击cell的事件冲突的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


//- (void)addOtherViewWithOriginY:(CGFloat)originY{
//    UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, originY, CGRectGetWidth(arrowView.frame), CGRectGetHeight(arrowView.frame) - originY))];
//    tableView.backgroundColor = arrowView.backgroundColor;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //[arrowView addSubview:tableView];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return dataArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.textLabel.text = dataArray[indexPath.row];
//    cell.backgroundColor = [UIColor cyanColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self titleLabel:titleLabel title:dataArray[indexPath.row]];
//    [arrowView removeFromSuperview];
//}
//


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
