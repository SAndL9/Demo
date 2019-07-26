//
//  ArrowAngleView.h
//  wwjTableView
//
//  Created by 吴伟军 on 16/7/7.
//  Copyright © 2016年 wuwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  目前只支持向上箭头，不过通过理解代码，其实很好写出四边的箭头，本人比较懒😄
 */

@protocol ArrowAngleViewDelegate <NSObject>

/**
 *  箭头框内tableview点击的cell下标
 *
 *  @param indexpath 下标
 */
- (void)didSelectedWithIndexPath:(NSInteger)indexpath;

@end

@interface ArrowAngleView : UIView
/**
 *  点击目标的frame，获取的目的为箭头跟随
 */
@property (assign, nonatomic) CGRect targetRect;
/**
 *  箭头框中tableview的数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArray;


@property (assign, nonatomic) id<ArrowAngleViewDelegate>delegate;

@end
