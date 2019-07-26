//
//  ViewController.m
//  新手引导
//
//  Created by zhang on 16/5/21.
//  Copyright © 2016年 zqdreamer. All rights reserved.
//

#import "ViewController.h"
#import "ZQNewGuideView.h"
#import "SecondViewController.h"

@interface ViewController ()
@property (strong, nonatomic) ZQNewGuideView *guideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"FirstController";
    self.view.backgroundColor = [UIColor redColor];
    
    self.guideView.showRect = CGRectMake(0, 80, self.view.bounds.size.width, 50);
    self.guideView.textImage = [UIImage imageNamed:@"guide1"];
    self.guideView.textImageFrame = CGRectMake(20, CGRectGetMaxY(self.guideView.showRect) + 5, self.guideView.textImage.size.width, self.guideView.textImage.size.height);
    
    __weak typeof(self) weakSelf = self;
    self.guideView.clickedShowRectBlock = ^{
        SecondViewController *secondViewCtrl = [[SecondViewController alloc] init];
        [weakSelf.navigationController pushViewController:secondViewCtrl animated:YES];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
}

#pragma mark - getter & setter

- (ZQNewGuideView *)guideView
{
    if (_guideView == nil) {
        _guideView = [[ZQNewGuideView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    }
    return _guideView;
}
@end
