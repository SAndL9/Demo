//
//  IconViewController.m
//  QLink
//
//  Created by 尤日华 on 14-9-22.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "IconViewController.h"
#import "ILBarButtonItem.h"
#import "DataUtil.h"

#define kImageWidth  80 //UITableViewCell里面图片的宽度
#define kImageHeight 80 //UITableViewCell里面图片的高度

@interface IconViewController ()
{
    NSArray *iconArr_;
    int iconCount_;
    int iconRowCount_;
    
    UIButton *btnSel_;
}
@end

@implementation IconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initData];
    
    [self initControl];
}

#pragma mark -
#pragma mark 初始化方法

-(void)initControl
{
    _tbIcon.delegate = self;
    _tbIcon.dataSource = self;
}

//设置导航
-(void)initNavigation
{
    ILBarButtonItem *back =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"首页_返回.png"]
                        selectedImage:[UIImage imageNamed:@"首页_返回.png"]
                               target:self
                               action:@selector(btnBackPressed)];
    
    self.navigationItem.leftBarButtonItem = back;
    
    UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTitle.frame = CGRectMake(0, 0, 100, 20);
    [btnTitle setTitle:@"图标重置" forState:UIControlStateNormal];
    btnTitle.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    btnTitle.backgroundColor = [UIColor clearColor];
    
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = btnTitle;
}

-(void)initData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iConPlist" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
 
    if ([_pType isEqualToString:MACRO]) {//场景
        iconArr_ = [dataDic objectForKey:@"Sence"];
    } else{
        iconArr_ = [dataDic objectForKey:@"Device"];
    }
    
    iconCount_ = [iconArr_ count];
    
    iconRowCount_ = iconCount_%4 == 0 ? iconCount_/4 : (iconCount_/4+1);
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)btnConfirmPressed:(id)sender
{
    if (!btnSel_) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请选择要更新的图标."
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    BOOL bResult = [SQLiteUtil changeIcon:_pDeviceId andType:_pType andNewType:[iconArr_ objectAtIndex:btnSel_.tag]];
    if (bResult) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"图标设置成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        [self.delegate refreshTable:_pType];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"操作失败,请稍后再试."
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)btnCanclePressed:(id)sender
{
    [self btnBackPressed];
}

#pragma mark -
#pragma mark UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return iconRowCount_;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的3个图片按钮
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    for (int i=0; i<4; i++) {
        int index = 4*indexPath.row + i;
        if (index >= iconCount_) {
            break;
        }
        NSString *imgName = [NSString stringWithFormat:@"%@.png",[iconArr_ objectAtIndex:index]];
        NSString *imgSelName = [NSString stringWithFormat:@"%@_select.png",[iconArr_ objectAtIndex:index]];
        
        UIView *vCell = [[UIView alloc] init];
        vCell.frame = CGRectMake(0, 0, kImageWidth, kImageHeight);
        vCell.center = CGPointMake(kImageWidth *(0.5 + i), kImageHeight * 0.5);
        [cell.contentView addSubview:vCell];
        
        UIButton *btnIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        btnIcon.frame = CGRectMake(9, 9, 62, 62);
        [btnIcon setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [btnIcon setImage:[UIImage imageNamed:imgSelName] forState:UIControlStateSelected];
        [btnIcon addTarget:self action:@selector(btnIconPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnIcon.tag = index;
        [vCell addSubview:btnIcon];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Custom Methods

-(void)btnBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnIconPressed:(UIButton *)sender
{
    btnSel_.selected = NO;
    btnSel_ = sender;
    
    sender.selected = YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
