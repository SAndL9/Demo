//
//  ViewController.m
//  轮播左右间距UIScrollerView实现
//
//  Created by 李磊 on 24/3/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "ViewController.h"
#import "RollView.h"
@interface ViewController ()<RollViewDelegate>

@property (nonatomic, strong) RollView *rollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatPicRollView];
}

-(void)creatPicRollView{
    
    
    
    self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150) withDistanceForScroll:12.0f withGap:8.0f];
    
    /** 全屏宽滑动 视图之间间隙,  将 Distance 设置为 -12.0f */
    // self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150) withDistanceForScroll: -12.0f withGap:8.0f];
    // self.rollView.backgroundColor = [UIColor blackColor];
    
    self.rollView.delegate = self;
    
    [self.view addSubview:self.rollView];
    
    
    NSArray *arr = @[@"1.jpg",
                     @"2.jpg",
                     @"3.jpg",
                     @"4.jpg",
                     @"5.jpg",
                     @"6.jpg",
                     @"7.jpg",
                     ];
    
    [self.rollView rollView:arr];
}

#pragma mark - 滚动视图协议
-(void)didSelectPicWithIndexPath:(NSInteger)index{
    
    if (index != -1) {
        
        NSLog(@"%ld", (long)index);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
