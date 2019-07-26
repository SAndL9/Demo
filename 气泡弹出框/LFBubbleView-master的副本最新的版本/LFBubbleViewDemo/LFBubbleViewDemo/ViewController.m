//
//  ViewController.m
//  LFTipsViewDemo
//
//  Created by 张林峰 on 16/6/22.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "ViewController.h"
#import "LFBubbleView.h"
#import "SAViewController.h"
@interface ViewController ()

@property (nonatomic, strong) LFBubbleView *bubbleView;
@property (strong, nonatomic) IBOutlet UIView *viewTarget;

@property (nonatomic, strong) UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_bubbleView hideMenu];
}


- (IBAction)up:(id)sender {
    
//     if (_bubbleView.state == MenuShow) return;
    
    NSString *strTip = @"可设置边框线，三角大小，三角位置，圆角大小，背景色什么都不设置的气泡什么都不设置的气泡什么都不设置的气泡什么都不设置的气泡什么都不设置的气泡什么都不设置的气泡4都不5设置6的气";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 250, 160)];
    _bubbleView.direction = LFTriangleDirection_Up;
    _bubbleView.lbTitle.text = strTip;
    //往右面偏移多少的三角
//    _bubbleView.triangleXY = 90;

    [self.view addSubview:_bubbleView];
    [_bubbleView showInPoint:CGPointMake(CGRectGetMaxX(_viewTarget.frame) - _viewTarget.bounds.size.width / 2.0 , CGRectGetMaxY(_viewTarget.frame))];

    
}
- (IBAction)down:(id)sender {
//    NSString *strTip = @"什么";
    [_bubbleView removeFromSuperview];
    _redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 120)];
    [_bubbleView.contentView addSubview:_redView];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
//    _bubbleView.lbTitle.text = strTip;
    [self.view addSubview:_bubbleView];
    
    _bubbleView.dismissAfterSecond = 5;
    [_bubbleView showInPoint:CGPointMake(CGRectGetMaxX(_viewTarget.frame) - _viewTarget.bounds.size.width / 2.0 ,CGRectGetMinY(_viewTarget.frame))];
}

- (IBAction)left:(id)sender {
    NSString *strTip = @"三角三角距三角距上3上3330";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 120, 160)];
    _bubbleView.direction = LFTriangleDirection_Left;
    _bubbleView.lbTitle.text = strTip;
    //从上往下偏移20
//    _bubbleView.triangleXY = 20;
    [self.view addSubview:_bubbleView];
//    [self.view convertPoint:<#(CGPoint)#> toView:<#(nullable UIView *)#>]
    [_bubbleView showInPoint:CGPointMake(CGRectGetMaxX(_viewTarget.frame),CGRectGetMaxY(_viewTarget.frame) - _viewTarget.bounds.size.height / 2.0)];

}
- (IBAction)right:(id)sender {
//    NSString *strTip = @"三角在三角在三角在三角在三角在三角在三角在三角在三角在三角在";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 100, 160)];
    _bubbleView.direction = LFTriangleDirection_Right;
//    _bubbleView.lbTitle.text = strTip;

    _redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 120)];
    [_bubbleView.contentView addSubview:_redView];
    
    
    [self.view addSubview:_bubbleView];
    [_bubbleView showInPoint:CGPointMake(CGRectGetMinX(_viewTarget.frame) , CGRectGetMaxY(_viewTarget.frame) - _viewTarget.bounds.size.height / 2.0)];
    
    
    
}

@end
