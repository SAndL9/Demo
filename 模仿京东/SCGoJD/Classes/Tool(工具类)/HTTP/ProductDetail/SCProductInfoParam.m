//
//  SCProductInfoParam.m
//  SCGoJD
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SCProductInfoParam.h"

#define SCIsLoadWareScore   @"true"
#define SCClient            @"apple"

@implementation SCProductInfoParam

- (void)setSkuId:(NSString *)skuId {
    
    _skuId = skuId;
    
    _isLoadWareScore = SCIsLoadWareScore;
    _client = SCClient;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com