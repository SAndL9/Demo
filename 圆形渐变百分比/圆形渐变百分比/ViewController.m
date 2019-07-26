//
//  ViewController.m
//  圆形渐变百分比
//
//  Created by 李磊 on 22/3/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "ViewController.h"
#import "SACycleView.h"
@interface ViewController ()

@property (nonatomic, strong) SACycleView *cycleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
}

- (void)createUI {
    [self.view addSubview:self.cycleView];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(self.cycleView.frame.origin.x - 20, self.cycleView.frame.origin.y + self.cycleView.frame.size.height + 50, self.cycleView.frame.size.width + 40, 20)];
    [self.view addSubview:slider];
    
    //添加方法
    [slider addTarget:self action:@selector(sliderChangeMethod:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderChangeMethod:(UISlider *)sender {
    self.cycleView.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", sender.value*100];
    self.cycleView.progress = sender.value;
}

#pragma mark ----------- 懒加载 -----------

- (SACycleView *)cycleView {
    if (_cycleView == nil) {
        _cycleView = [[SACycleView alloc]initWithFrame:CGRectMake(90, 100, 200, 200)];
        _cycleView.backgroundColor = [UIColor whiteColor];
    }
    return _cycleView;
}



@end
