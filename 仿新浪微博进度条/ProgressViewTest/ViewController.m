//
//  ViewController.m
//  ProgressViewTest
//
//  Created by lihongfeng on 16/1/7.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "WLCircleProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) WLCircleProgressView *progressView1;
@property (nonatomic, strong) WLCircleProgressView *progressView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //************************************* 第一个进度圆环 ******************************************
    
    WLCircleProgressView *circleProgress1 = [WLCircleProgressView viewWithFrame:CGRectMake(80, 80, 100, 100)
                                                               circlesSize:CGRectMake(30, 5, 30, 5)];
    circleProgress1.layer.cornerRadius = 10;
    circleProgress1.progressValue = 0.2;
    [self.view addSubview:circleProgress1];
    self.progressView1 = circleProgress1;
    
    //************************************* 第一个进度圆环(仿新浪) ******************************************
    
    WLCircleProgressView *circleProgress2 = [WLCircleProgressView viewWithFrame:CGRectMake(80, 200, 100, 100)
                                                                   circlesSize:CGRectMake(34, 2, 30, 30)];
    circleProgress2.layer.cornerRadius = 10;
    
    //阴影
    circleProgress2.backgroundColor = [UIColor clearColor];
    circleProgress2.backCircle.shadowColor = [UIColor grayColor].CGColor;
    circleProgress2.backCircle.shadowRadius = 3;
    circleProgress2.backCircle.shadowOffset = CGSizeMake(0, 0);
    circleProgress2.backCircle.shadowOpacity = 1;
    circleProgress2.backCircle.fillColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.8].CGColor;
    circleProgress2.backCircle.strokeColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1].CGColor;
    
    circleProgress2.foreCircle.lineCap = @"butt";
    circleProgress2.foreCircle.strokeColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;;
    circleProgress2.progressValue = 0.2;
    
    [self.view addSubview:circleProgress2];
    self.progressView2 = circleProgress2;
    
    //************************************* slider ******************************************
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 350, 150, 100)];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 0.2;
    [slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

-(void)changeValue:(UISlider *)slider{
    self.progressView1.progressValue = slider.value;
    self.progressView2.progressValue = slider.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
