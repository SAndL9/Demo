//
//  ViewController.m
//  引导页面
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 cheniue. All rights reserved.
//

#import "ViewController.h"
#import "GuideView.h"
@interface ViewController ()
{
    GuideView *markView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"meizi.jpg"]];
    markView = [[GuideView alloc]initWithFrame:imageView.bounds];
    markView.fullShow = YES;
    markView.model = GuideViewCleanModeRoundRect;
    markView.showRect = CGRectMake(210, 380, 120, 80);
    [imageView addSubview:markView];
    [self.view addSubview:imageView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:markView.superview];
    markView.showRect = CGRectMake(point.x-markView.showRect.size.width/2.0f, point.y-markView.showRect.size.height/2.0f, markView.showRect.size.width, markView.showRect.size.height);
    markView.markText = NSStringFromCGPoint(point);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
