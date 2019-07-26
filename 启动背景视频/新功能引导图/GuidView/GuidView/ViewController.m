//
//  ViewController.m
//  GuidView
//
//  Created by lanouhn on 15/11/24.
//  Copyright (c) 2015年 jingwei. All rights reserved.
//

#import "ViewController.h"
#import "GuideView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()
@property (nonatomic, strong) GuideView *markView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"meizi.jpg"]];
    _markView = [[GuideView alloc]initWithFrame:imageView.bounds];
    _markView.model = GuideViewCleanModeOval;
    _markView.markText = @"欢迎使用...";
    [imageView addSubview:_markView];
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSArray *rectArray = @[
                       [NSValue valueWithCGRect:CGRectMake(20,20,20,20)],
                       [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 20, 100, 50)],
                       [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH - 60, 42, 50, 70)],
                       [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH/2-150, SCREEN_HEIGHT/2 - 20, 1, 0)]
                       ];
    NSArray *messageArray = @[
      @"这是《简书》",
      @"点这里撰写文章",
      @"搜索文章",
      @"这会是Strong"
      ];
    [_markView setMessageArray:messageArray rectArray:rectArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
