//
//  RateView.h
//  JXTutorialSimpleRateView
//
//  Created by 汪骏祥 on 9/17/15.
//  Copyright (c) 2015 junxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RateView;

@protocol RateViewDelegate

// 用于在评分改变是，更新显示的分数
- (void)ratingDidChange:(int) rating;

@end

@interface RateView : UIView{
    bool editable; // 评分是否可以更改
    int midMargin; // 点赞图片的间距
    int leftMargin; // 整个评分区域的左右间距
    CGSize minImageSize;    // 图片最小尺寸
}

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong) NSMutableArray *imageViews; // 点赞图片的数组
@property (assign, nonatomic) int maxRating; // 最大显示的点赞图片数量
@property (assign, nonatomic) int rating;
@property (assign) id<RateViewDelegate> delegate;

- (void)setEditable: (bool) editabl andNotSelectedImage: (UIImage *) notSelectedImag andSelectedImage: (UIImage *) selectedImag andRating: (int) ratin andMaxRating: (int) maxRatin andDelegate: (id<RateViewDelegate>) delegat;

@end
