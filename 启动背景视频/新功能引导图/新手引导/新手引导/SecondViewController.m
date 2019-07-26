//
//  SecondViewController.m
//  新手引导
//
//  Created by zhang on 16/5/21.
//  Copyright © 2016年 zqdreamer. All rights reserved.
//

#import "SecondViewController.h"
#import "ZQNewGuideView.h"
#import "ThirdViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) ZQNewGuideView *guideView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor yellowColor];

    [self addFirstGuide];

}

#pragma mark - private

- (void)addFirstGuide
{
    self.guideView.showRect = CGRectMake(100, 200, 80, 80);
    self.guideView.textImage = [UIImage imageNamed:@"guide2"];
    self.guideView.textImageFrame = CGRectMake(CGRectGetMinX(self.guideView.showRect) + self.guideView.showRect.size.width / 2.0 - 10, CGRectGetMaxY(self.guideView.showRect) + 5, self.guideView.textImage.size.width,self.guideView.textImage.size.height);
    __weak typeof(self) weakSelf = self;
    self.guideView.clickedShowRectBlock = ^{
        [weakSelf addSecondGuide];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
}

- (void)addSecondGuide
{
    self.guideView.showRect = CGRectMake(200, 80, 100, 100);
    self.guideView.textImage = [UIImage imageNamed:@"guide3"];
    self.guideView.textImageFrame = CGRectMake(CGRectGetMidX(self.guideView.showRect) - self.guideView.textImage.size.width, CGRectGetMaxY(self.guideView.showRect) + 5, self.guideView.textImage.size.width, self.guideView.textImage.size.height);
    __weak typeof(self) weakSelf = self;
    self.guideView.clickedShowRectBlock = ^{
         ThirdViewController *thirdViewCtrl = [[ThirdViewController alloc] init];
        [weakSelf.navigationController pushViewController:thirdViewCtrl animated:YES];
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
