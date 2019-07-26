//
//  ShopPlatformTableViewCell.m
//  电商
//
//  Created by zhou on 16/8/9.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import "ShopPlatformTableViewCell.h"
#import "ShopPlatformModel.h"

@interface ShopPlatformTableViewCell ()<UITextFieldDelegate>
/** 是否选中这个商品 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/** 商品的图片 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
/** 商品的名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 商品的价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 商品的原价 */
@property (weak, nonatomic) IBOutlet UILabel *originalpricelabel;
/** 减数量 */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
/** 数量 */
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
/** 加数量 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
/** 原价格上的线 */
@property (nonatomic, strong) UIView *line;

@end

@implementation ShopPlatformTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //原价格上的线
    UIView *line = [[UIView alloc] init];
    self.line = line;
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    //是否选中商品的点击事件
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    UIBarButtonItem *itemdone = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    UIBarButtonItem *flx = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flx,itemdone];
    
    self.numberTextfield.inputAccessoryView = toolbar;
    
    //监听数量的变化(包括手动输入)
    [self.numberTextfield addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    //监听当鼠标从这一个numberTextfield到另一个numberTextfield的时候，判断一下输入的数量是否为>=1，如果不是默认为1
    [self.numberTextfield addTarget:self action:@selector(textdidChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    self.numberTextfield.delegate = self;
}
/**
 *  是否选中商品的点击事件
 */
- (void)selectClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(shopPlatformTableViewCell:andTag:)]) {
        [self.delegate shopPlatformTableViewCell:self andTag:sender.tag];
    }
}
/**
 *  退出键盘
 */
- (void)done
{
    [self endEditing:YES];
}
/**
 *  监听数量的变化(包括手动输入)
 */
- (void)textChange:(UITextField *)textfield
{
    
    NSInteger amount = textfield.text.integerValue;
    if (amount > 1) {
        [self.reduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.reduceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    //更新数据
    self.data.totalnumber = textfield.text.integerValue;
}
/**
 *  监听当鼠标从这一个numberTextfield到另一个numberTextfield的时候，判断一下输入的数量是否为>=1，如果不是默认为1
 */
- (void)textdidChange:(UITextField *)textfield
{
    if (textfield.text.integerValue < 1) {
        textfield.text = @"1";
    }
    
    //解决前面输入是0的问题
    textfield.text = [NSString stringWithFormat:@"%ld",textfield.text.integerValue];
    //更新一下数据中的数量
    self.data.totalnumber = textfield.text.integerValue;
    
    NSIndexPath *textfieldindexpath = [NSIndexPath indexPathForRow:self.numberTextfield.tag inSection:0];
    //告诉总价格的变化
    if ([self.delegate respondsToSelector:@selector(textfieldTextdidChangeTableViewCell:andTextField:andIdexpath:)]) {
        [self.delegate textfieldTextdidChangeTableViewCell:self andTextField:textfield andIdexpath:textfieldindexpath];
    }
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//- (void)textFieldDidBeginEditing:(UITextField *)textField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textfieldBeginEditingTableViewCell:andTextfieldTag:)]) {
        [self.delegate textfieldBeginEditingTableViewCell:self andTextfieldTag:textField.tag];
    }
    return YES;
}
/**
 *  给selectBtn，reduceBtn，addBtn的tag赋值
 */
- (void)setIndexpath:(NSIndexPath *)indexpath
{
    _indexpath = indexpath;
    self.selectBtn.tag = indexpath.row;
    self.reduceBtn.tag = indexpath.row;
    self.addBtn.tag = indexpath.row;
    self.numberTextfield.tag = indexpath.row;
    
//    NSLog(@"%ld",self.numberTextfield.tag);
    
}

- (void)setData:(ShopPlatformModel *)data
{
    _data = data;
    
    if (data.isSelect) {//选中商品
        [self.selectBtn setImage:[[UIImage imageNamed:@"yy_select_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{//没有选中商品
        [self.selectBtn setImage:[[UIImage imageNamed:@"yy_select_disabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
   
    
    //商品图片  这个图片要用  sdwebimage框架来做，不能够用下面的方式
    self.pictureImageView.image = [UIImage imageNamed:@"10ipwf_kqyucz2bkfbg26dwgfjeg5sckzsew_800x800.jpg_200x999"];
   
    
    
    //商品价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %ld",data.presentprice];
    //商品原价格
    self.originalpricelabel.text = [NSString stringWithFormat:@"%@",@"¥ 15"];
    [self.originalpricelabel sizeToFit];
    //商品原价格上的线
    self.line.center = self.originalpricelabel.center;
    self.line.bounds = CGRectMake(0, 0, self.originalpricelabel.bounds.size.width, 1);
    //每个商品的数量
    self.numberTextfield.text = [NSString stringWithFormat:@"%ld",data.totalnumber];
    if (data.totalnumber > 1) {
        [self.reduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.reduceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

@end
