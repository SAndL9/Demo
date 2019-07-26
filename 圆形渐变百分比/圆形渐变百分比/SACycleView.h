//
//  SACycleView.h
//  圆形渐变百分比
//
//  Created by 李磊 on 22/3/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACycleView : UIView

/**中间label*/
@property (nonatomic , strong)UILabel *progressLabel;

/**progress*/
@property (nonatomic , assign)CGFloat progress;

@end
