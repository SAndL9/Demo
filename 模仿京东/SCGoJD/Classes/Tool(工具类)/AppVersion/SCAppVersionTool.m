//
//  SCAppVersionTool.m
//  SCGoJD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SCAppVersionTool.h"

#define SCVersionKey @"AppVersion"

@implementation SCAppVersionTool

// 获取保存的上一个版本信息
+ (NSString *)savedAppVersion {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:SCVersionKey];
}

// 保存新版本信息（偏好设置）
+ (void)saveNewAppVersion:(NSString *)version {
    
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:SCVersionKey];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com