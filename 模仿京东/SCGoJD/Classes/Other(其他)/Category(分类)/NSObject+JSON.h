//
//  NSObject+JSON.h
//  SCGoJD
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//  字典或对象转成JSON字符串数据

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

/**
 *  字典或对象转成JSON字符串数据
 */
@property (nonatomic, copy, readonly) NSString *JSONString;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com