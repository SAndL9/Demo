//
//  SenceConfigTableViewCell.h
//  QLink
//
//  Created by 尤日华 on 14-10-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@protocol SenceConfigCellDelegate <NSObject>

-(void)setOrderArrNewValue:(NSString *)orderId andNewNum:(NSString *)newNum;
-(void)handleShowDDL:(UIButton *)sender andObj:(Sence *)obj;
-(void)handleLongPressed:(Sence *)obj;

@end

@interface SenceConfigTableViewCell : UITableViewCell

@property(nonatomic,assign) id<SenceConfigCellDelegate>delegate;

@property(nonatomic,strong) Sence *pSenceObj;
@property (strong, nonatomic) IBOutlet UIImageView *ivIcon;
@property (strong, nonatomic) IBOutlet UILabel *lDeviceName;
@property (strong, nonatomic) IBOutlet UILabel *lOrderName;
@property (strong, nonatomic) IBOutlet UIButton *btnNum;
@property (weak, nonatomic) IBOutlet UILabel *lblNo;

- (IBAction)btnJian;
- (IBAction)btnJia;
- (IBAction)btnNumberPressed:(UIButton *)sender;

-(void)setIcon:(NSString *)icon
 andDeviceName:(NSString *)deviceName
  andOrderName:(NSString *)orderName
       andTime:(NSString *)timer;

@end
