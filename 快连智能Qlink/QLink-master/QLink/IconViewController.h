//
//  IconViewController.h
//  QLink
//
//  Created by 尤日华 on 14-9-22.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IconViewControllerDelegate <NSObject>

-(void)refreshTable:(NSString *)pType;

@end

@interface IconViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSString *pDeviceId;
@property(nonatomic,strong) NSString *pType;

@property(nonatomic,strong) IBOutlet UITableView *tbIcon;
@property(nonatomic,assign) id<IconViewControllerDelegate>delegate;

-(IBAction)btnConfirmPressed:(id)sender;
-(IBAction)btnCanclePressed:(id)sender;

@end
