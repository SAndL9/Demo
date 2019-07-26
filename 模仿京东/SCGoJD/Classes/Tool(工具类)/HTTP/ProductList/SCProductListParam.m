//
//  SCProductListParam.m
//  SCGoJD
//
//  Created by mac on 15/9/26.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "SCProductListParam.h"

#define SCClient        @"apple"
#define SCPageSize      @"30"

@implementation SCProductListParam

- (void)setPage:(NSString *)page {
    
    _page = page;
    
    // 设置其他默认属性
    _pageSize = SCPageSize;
    _client = SCClient;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com