//
//  ViewController.m
//  JLSlideModel
//
//  Created by job on 17/1/9.
//  Copyright © 2017年 job. All rights reserved.
//

#import "ViewController.h"
#import "JLSliderView.h"
@interface ViewController ()
@property (strong, nonatomic)JLSliderView *sliderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sliderView = [[JLSliderView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 60) ];
    self.sliderView.sliderType = JLSliderTypeCenter;
    [self.view addSubview:self.sliderView];
    JLSliderView  *sliderView2 = [[JLSliderView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width,100) ];
    sliderView2.sliderType = JLSliderTypeBottom;
    [self.view addSubview:sliderView2];
} 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
