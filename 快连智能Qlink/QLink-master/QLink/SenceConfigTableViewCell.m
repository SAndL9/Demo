//
//  SenceConfigTableViewCell.m
//  QLink
//
//  Created by 尤日华 on 14-10-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SenceConfigTableViewCell.h"

@implementation SenceConfigTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIcon:(NSString *)icon
 andDeviceName:(NSString *)deviceName
  andOrderName:(NSString *)orderName
       andTime:(NSString *)timer
{   
    self.ivIcon.image = [UIImage imageNamed:icon];
    self.lDeviceName.text = deviceName;
    self.lOrderName.text = orderName;
    [self.btnNum setTitle:timer forState:UIControlStateNormal];
    
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 1.0;//表示最短长按的时间
    //将长按手势添加到需要实现长按操作的视图里
    [self addGestureRecognizer:longPress];
}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction)btnJian
{
    int iNum = [_btnNum.titleLabel.text intValue];
    if (iNum == 1) {
        return;
    }
    
    iNum --;
    NSString *num = [NSString stringWithFormat:@"%d",iNum];
    [_btnNum setTitle:num forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate setOrderArrNewValue:_pSenceObj.OrderId andNewNum:num];
    }
}

- (IBAction)btnJia
{
    int iNum = [_btnNum.titleLabel.text intValue];
    if (iNum >= 50) {
        return;
    }
    
    iNum ++;
    NSString *num = [NSString stringWithFormat:@"%d",iNum];
    [_btnNum setTitle:num forState:UIControlStateNormal];
    if (self.delegate) {
        [self.delegate setOrderArrNewValue:_pSenceObj.OrderId andNewNum:num];
    }
}

- (IBAction)btnNumberPressed:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate handleShowDDL:sender andObj:_pSenceObj];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 && buttonIndex == 1) {
        if (self.delegate) {
            [self.delegate handleLongPressed:_pSenceObj];
        }
    }
}

#pragma mark -
#pragma mark Custom Methods

//长按事件的实现方法
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"确定要删除该命令吗?"
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
    }
}

@end
