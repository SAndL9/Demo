//
//  SCCategory.m
//  SCGoJD
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SCCategory.h"

@implementation SCCategory

// 解决属性名与服务器参数key不一致的问题
+ (NSDictionary *)replacedKeyFromPropertyName {
    
    // key是属性名, value是参数名
    return @{@"detail_description" : @"description"};
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com