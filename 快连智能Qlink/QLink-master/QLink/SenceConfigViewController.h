//
//  SenceConfigViewController.h
//  QLink
//
//  Created by 尤日华 on 14-10-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SenceConfigTableViewCell.h"
#import "RenameView.h"
#import "BaseViewController.h"

@protocol SenceConfigViewControllerDelegate <NSObject>

//-(void)refreshSenceTab;
-(void)goOnChoose;

@end

@interface SenceConfigViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,RenameViewDelegate,SenceConfigCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableData *responseData_;
}

@property(nonatomic,strong) IBOutlet UITableView *tbOrder;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewNum;
@property (strong, nonatomic) IBOutlet UIView *viewPicker;

@property(nonatomic,assign) id<SenceConfigViewControllerDelegate>delegate;


- (IBAction)btnSaveSence;
- (IBAction)btnContinue;
- (IBAction)btnCancle;

- (IBAction)btnPickerViewCancle;
- (IBAction)btnPickerViewConfirm;

@end
