//
//  XHStarsView.h
//  五星好评
//
//  Created by 邢行 on 15/10/15.
//  Copyright (c) 2015年 XingHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  starsDeledate <NSObject>
@optional
-(void)starsClickWithSender:(UIButton *)sender;

@end

@interface XHStarsView : UIView
@property (nonatomic,assign) id<starsDeledate> starsDeledate;

@property (nonatomic,assign) NSInteger starCount;
@property (nonatomic,strong) NSMutableArray *btnsArr;

-(void)createStarsWithCount:(NSInteger )acount;


@end

