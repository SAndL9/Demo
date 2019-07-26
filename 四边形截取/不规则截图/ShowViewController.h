//
//  ShowViewController.h
//  不规则截图
//
//  Created by macbook on 16/8/2.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : UIViewController

/** image */
@property (strong, nonatomic) UIImage *image;
- (void)setImage:(UIImage *)image withPoints:(NSArray *)array;
@end
