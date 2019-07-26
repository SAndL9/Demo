//
//  SCImageScrollBaseCell.h
//  SCGoJD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//  滚动图片的基类collectionViewCell

#import <UIKit/UIKit.h>

@interface SCImageScrollBaseCell : UICollectionViewCell

/**
 *  滚动图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  图片链接URL
 */
@property (nonatomic, strong) NSURL *imagePath;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com