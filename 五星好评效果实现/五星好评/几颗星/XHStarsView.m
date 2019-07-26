//
//  XHStarsView.m
//  五星好评
//
//  Created by 邢行 on 15/10/15.
//  Copyright (c) 2015年 XingHang. All rights reserved.
//

#import "XHStarsView.h"

@implementation XHStarsView

-(void)createStarsWithCount:(NSInteger)acount{

    if (acount !=0) {
        
        for (int i = 0; i <acount; i++) {
            
            UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            float leftMargin = 5.f;
            float width = 50;
            starBtn.frame = CGRectMake(leftMargin*i+width*i, 0, width, width);
            [starBtn setImage:[UIImage imageNamed:@"starwhite"] forState:UIControlStateNormal];
            starBtn.tag = 100 + i;
            [starBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:starBtn];
            
            [self.btnsArr addObject:starBtn];
            
        }
        
    }else{
    
        NSLog(@"不会创建stars");
        
    }
}


-(void)clickAction:(UIButton *)sender{

    NSLog(@"clickAction");
    [self.starsDeledate starsClickWithSender:sender];
    
    
}


-(NSMutableArray *)btnsArr{

    if (!_btnsArr) {
        _btnsArr = [[NSMutableArray alloc] init];
    }
    return _btnsArr;
    
}

@end
