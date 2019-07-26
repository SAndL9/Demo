//
//  HBK_ShoppingCartCell.h
//  HBK_ShoppingCart
//
//  Created by 黄冰珂 on 2017/11/23.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBK_ShoppingCartModel.h"
@interface HBK_ShoppingCartCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;





/**
 选中
 */
@property (nonatomic, copy) void (^ClickRowBlock)(BOOL isClick);




@property (nonatomic, strong) HBK_GoodsModel *goodsModel;



@end
