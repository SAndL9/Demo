//
//  OrderButton.h
//  QLink
//
//  Created by SANSAN on 14-9-25.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface OrderButton : UIButton

@property(nonatomic,strong) Order *orderObj;

//转型
+(OrderButton *)ModelClassForString:(NSString *)type
                         andSubType:(NSString *)subType;

@end
