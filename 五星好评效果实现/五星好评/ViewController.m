//
//  ViewController.m
//  五星好评
//
//  Created by 邢行 on 15/10/15.
//  Copyright (c) 2015年 XingHang. All rights reserved.
//

#import "ViewController.h"
#import "XHStarsView.h"

@interface ViewController ()<starsDeledate>
{
    XHStarsView *stars;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    stars= [[XHStarsView alloc] init];
    [stars createStarsWithCount:5];
    stars.frame = CGRectMake(10, 20, self.view.frame.size.width-20, 50);
    stars.starsDeledate = self;
    [self.view addSubview:stars];
    
    NSLog(@"stars.btnsArr.count:%ld",stars.btnsArr.count);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)starsClickWithSender:(UIButton *)sender{

    NSLog(@"starsClick");
    NSInteger index = sender.tag -100;
    
    NSLog(@"index%ld",index);
    
    for (int i = 0; i < stars.btnsArr.count; i++) {
        
        UIButton *btn = stars.btnsArr[i];

        if (i <= index) {
         
            [UIView animateWithDuration:0.5 animations:^{
                
                [btn setImage:[UIImage imageNamed:@"staryellow"] forState:UIControlStateNormal];

            }];
            

        }else{
        
            [UIView animateWithDuration:0.5 animations:^{
                
                [btn setImage:[UIImage imageNamed:@"starwhite"] forState:UIControlStateNormal];
                
            }];
        }
    }
}








@end
