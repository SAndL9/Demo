//
//  UICollectionViewController+SCCurrentPage.m
//  SCGoJD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UICollectionViewController+SCCurrentPage.h"

@implementation UICollectionViewController (SCCurrentPage)

- (NSUInteger)setCurrentPageNumberWithLastPageNumber:(NSUInteger)pageNumber
                                          totalCount:(NSUInteger)count
                                              offset:(CGFloat)offset {
    
    NSUInteger currentPageNumber = pageNumber;

    for (NSUInteger i = 0; i < count; i++) {
        if (offset == self.view.frameWidth * i) {
            currentPageNumber = i;
        }
    }
    
    return currentPageNumber;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com