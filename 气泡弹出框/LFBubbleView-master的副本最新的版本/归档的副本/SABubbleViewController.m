//
//  SABubbleViewController.m
//  SAKitDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import "SABubbleViewController.h"
#import "SABubbleView.h"
@interface SABubbleViewController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIButton *button3;



@end

@implementation SABubbleViewController

#pragma mark-
#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviewsContraints];
}

#pragma mark-
#pragma mark- Request


#pragma mark-
#pragma mark- SANetworkResponseProtocol

#pragma mark-
#pragma mark- SACardViewDataSource

#pragma mark-
#pragma mark- 代理类名 delegate

#pragma mark-
#pragma mark- Event response

- (void)pressButtonAction:(UIButton *)button{
    SABubbleView *bubleView = [[SABubbleView alloc]init];
    bubleView.trianglePoint = CGPointMake(button.frame.origin.x+ button.frame.size.width/2.0, button.frame.origin.y+button.frame.size.height);
    bubleView.bubbleViewType = SABubbleTypeView;
    bubleView.dataSourceArray = [NSMutableArray arrayWithObjects:@"选项1",@"选项2",@"选项3",@"选项4", nil];
    bubleView.triangleSeatScale = 0.5;
    [bubleView show:self.view];
}

- (void)pressButton2Action:(UIButton *)button{
    SABubbleView *bubbleView = [[SABubbleView alloc]init];
    bubbleView.textLabel.text = @"";
    bubbleView.trianglePoint = CGPointMake(button.frame.origin.x, button.frame.origin.y+button.frame.size.height/2.0);
    bubbleView.triangleSeatScale = 0.5;
    bubbleView.bubbleViewType = SABubbleTypeNormal;
    bubbleView.triangleDicrection = SATriangleDicrectionRight;
    [bubbleView show:self.view];
}

- (void)pressButton3Action:(UIButton *)button{
    SABubbleView *buView = [[SABubbleView alloc]init];
    buView.textLabel.text =  @"";
    buView.trianglePoint = CGPointMake(button.frame.origin.x+button.frame.size.width/2.0, button.frame.origin.y);
    buView.triangleSeatScale = 0.3;
    buView.triangleDicrection = SATriangleDicrectionDown;
    buView.bubbleViewType = SABubbleTypeButton;
    [buView show:self.view];

}

#pragma mark-
#pragma mark- Private Methods

#pragma mark-
#pragma mark- Getters && Setters

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(40, 150, 120, 40)];
        [_button setTitle:@"我是选项气泡" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(pressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)button2{
    if (!_button2) {
        _button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-110, 20, 100, 40.f)];
        [_button2 setTitle:@"默认弹出" forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(pressButton2Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton *)button3{
    if (!_button3) {
        _button3 = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 60, 100, 40.f)];
        [_button3 setTitle:@"我知道了弹出" forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(pressButton3Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}


#pragma mark-
#pragma mark- SetupConstraints
- (void)setupSubviewsContraints {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
