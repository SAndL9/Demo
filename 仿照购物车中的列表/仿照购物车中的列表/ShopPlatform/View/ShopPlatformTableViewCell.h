//
//  ShopPlatformTableViewCell.h
//  电商
//
//  Created by zhou on 16/8/9.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopPlatformModel;
@class ShopPlatformTableViewCell;

@protocol shopPlatformTableViewCellDelegate <NSObject>

@optional
/**
 *  选中商品的代理方法
 */
- (void)shopPlatformTableViewCell:(ShopPlatformTableViewCell *)cell andTag:(NSInteger)tag;
/**
 *  当输入数量的时候，从一个numberTextfield跳到另一个numberTextfield的时候，要计算被选中的商品的价格的总数
 */
- (void)textfieldTextdidChangeTableViewCell:(ShopPlatformTableViewCell *)cell andTextField:(UITextField *)textfield andIdexpath:(NSIndexPath *)indexpath;
/**
 *  当弹出键盘的时候，告诉是哪个textfield的控件弹出的键盘，来计算这个textfield所在的cell的位置，来判断在弹出键盘的时候是否需要移动tableview
 */
- (void)textfieldBeginEditingTableViewCell:(ShopPlatformTableViewCell *)cell andTextfieldTag:(NSInteger)tag;

@end

@interface ShopPlatformTableViewCell : UITableViewCell
/** cell的位置 */
@property (nonatomic, strong) NSIndexPath *indexpath;
/** 每行cell的数据 */
@property (nonatomic, strong) ShopPlatformModel *data;
/** 代理 */
@property (nonatomic,weak) id<shopPlatformTableViewCellDelegate> delegate;

@end
