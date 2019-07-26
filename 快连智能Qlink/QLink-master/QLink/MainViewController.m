//
//  MainViewController.m
//  QLink
//
//  Created by 尤日华 on 14-9-17.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "MainViewController.h"
#import "ILBarButtonItem.h"
#import "REMenuItem.h"
#import "KxMenu.h"
#import "MyAlertView.h"
#import "NetworkUtil.h"
#import "RemoteViewController.h"
#import "LightViewController.h"
#import "DeviceConfigViewController.h"
#import "AboutViewController.h"
#import "SenceConfigViewController.h"
#import "SVProgressHUD.h"
#import "UIAlertView+MKBlockAdditions.h"

#define kImageWidth  106 //UITableViewCell里面图片的宽度
#define kImageHeight  106 //UITableViewCell里面图片的高度

@interface MainViewController ()
{
    NSMutableArray *senceArr_;
    NSMutableArray *deviceArr_;
    NSArray *roomArr_;
    
    NSInteger senceCount_;
    NSInteger deviceCount_;
    
    NSInteger senceRowCount_;
    NSInteger deviceRowCount_;
    
    RenameView *renameView_;
    
    int svHeight_;
    
    NSMutableArray *iconArr_;
}
@end

@implementation MainViewController

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
    
    [self initIconArr];
    
    [self initData];
    
    [self initNavigation];
    
    [self initControl];
    
    [self registerNotification];
    
    [self initLoginZK];
}

#pragma mark -
#pragma mark 初始化方法

-(void)initIconArr
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iConPlist" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    iconArr_ = [NSMutableArray array];
    [iconArr_ addObjectsFromArray:[dataDic objectForKey:@"Sence"]];
    [iconArr_ addObjectsFromArray:[dataDic objectForKey:@"Device"]];
    [iconArr_ addObject:@"SANSAN_DEVICE_ADD"];
    [iconArr_ addObject:@"SANSAN_MACRO_ADD"];
}

//设置导航
-(void)initNavigation
{
    [self.navigationController.navigationBar setHidden:NO];
    
    UIButton *btnDDL = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDDL.frame = CGRectMake(0, 0, 135, 38);
    btnDDL.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    [btnDDL setBackgroundImage:[UIImage imageNamed:@"首页_ddl.png"] forState:UIControlStateNormal];
    NSString *roomName = @"none";
    if ([roomArr_ count] > 0) {
        Room *obj = [roomArr_ objectAtIndex:0];
        roomName = obj.RoomName;
    }
    [btnDDL setTitle:roomName forState:UIControlStateNormal];
    [btnDDL addTarget:self action:@selector(showCenterMenu) forControlEvents:UIControlEventTouchUpInside];
    
    //将横向列表添加到导航栏
    self.navigationItem.titleView = btnDDL;
    
    self.navigationItem.hidesBackButton = YES;
    
    ILBarButtonItem *rightBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"首页_三横.png"]
                        selectedImage:[UIImage imageNamed:@"首页_三横.png"]
                               target:self
                               action:@selector(showRightMenu)];
    
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)initLoginZK
{
    if ([DataUtil isWifiNewWork]) {
        Config *configObj = [Config getConfig];
        if (!configObj.isWriteCenterControl && configObj.isSetSign && configObj.isSetIp && configObj.isBuyCenterControl)
        {
            [UIAlertView alertViewWithTitle:@"温馨提示"
                                    message:@"执行中控操作,是否继续?"
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@[@"继续"]
                                  onDismiss:^(int index){
                                      self.zkOperType = ZkOperNormal;
                                      [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
                                  }onCancel:nil];
        }
    }
}

//添加左侧add菜单
-(void)setAddSenceModelNavigation
{
    ILBarButtonItem *senceModel =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"sence_cancle.png"]
                        selectedImage:[UIImage imageNamed:@"sence_cancle.png"]
                               target:self
                               action:@selector(btnCancleSenceModel)];
    
    self.navigationItem.leftBarButtonItem = senceModel;
    
    [self setAddSenceModelRightNavEnabledFalse];
}

//设置scrollview不能滚动，且右上角菜单隐藏
-(void)setAddSenceModelRightNavEnabledFalse
{
    self.btnSceneControl.enabled = false;
    self.svBig.scrollEnabled = false;
    self.navigationItem.rightBarButtonItem = nil;
}

//设置scrollview能滚动，且右上角菜单显示
-(void)setAddSenceModelRightNavEnabledYES
{
    self.btnSceneControl.selected = YES;
    self.btnDeviceControl.selected = NO;
    self.btnSceneControl.enabled = YES;
    self.svBig.scrollEnabled = YES;
    ILBarButtonItem *rightBtn =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"首页_三横.png"]
                        selectedImage:[UIImage imageNamed:@"首页_三横.png"]
                               target:self
                               action:@selector(showRightMenu)];
    
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}


//设置控件
-(void)initControl
{
    self.navigationItem.titleView.hidden = YES;
    
    _svBig.frame = CGRectMake(0, 29, 320, svHeight_);
    _svBig.contentSize = CGSizeMake(640, svHeight_);
    _svBig.delegate = self;
    
    _tvScene.delegate = self;
    _tvScene.dataSource = self;
    _tvDevice.delegate = self;
    _tvDevice.dataSource = self;
    
    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"RenameView" owner:self options:nil];
    renameView_ = [array1 objectAtIndex:0];
    renameView_.frame = CGRectMake(0, 0, 320, 320);
    renameView_.delegate = self;
    [renameView_.tfContent setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    renameView_.hidden = YES;
    [self.view addSubview:renameView_];
}

-(void)initSence
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    senceArr_ = [NSMutableArray arrayWithArray:[SQLiteUtil getSenceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId]];
    
    senceCount_ = [senceArr_ count];
    senceRowCount_ = senceCount_%3 == 0 ? senceCount_/3 : (senceCount_/3 + 1);
    
    [_tvScene reloadData];
}

-(void)initDevice:(BOOL)isAddSence
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    deviceArr_ = [NSMutableArray arrayWithArray:[SQLiteUtil getDeviceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId]];
    
    if (deviceArr_.count > 0 && isAddSence) {
        [deviceArr_ removeLastObject];
    }
    
    deviceCount_ = [deviceArr_ count];
    deviceRowCount_ = deviceCount_%3 == 0 ? deviceCount_/3 : (deviceCount_/3 + 1);
    
    [_tvDevice reloadData];
}

-(void)initData
{
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    
    senceArr_ = [NSMutableArray arrayWithArray:[SQLiteUtil getSenceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId]];
    senceCount_ = [senceArr_ count];
    senceRowCount_ = senceCount_%3 == 0 ? senceCount_/3 : (senceCount_/3 + 1);
    
    deviceArr_ = [NSMutableArray arrayWithArray:[SQLiteUtil getDeviceList:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId]];
    deviceCount_ = [deviceArr_ count];
    deviceRowCount_ = deviceCount_%3 == 0 ? deviceCount_/3 : (deviceCount_/3 + 1);
    
    roomArr_ = [SQLiteUtil getRoomList:obj.HouseId andLayerId:obj.LayerId];
    
    svHeight_ = [UIScreen mainScreen].applicationFrame.size.height - 44 - 29;
    
    //设置是否添加场景模式
    [DataUtil setGlobalIsAddSence:NO];
    [self setAddSenceModelRightNavEnabledYES];
    
    [self setZkConfig];
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshSenceTab) name:@"refreshSenceTab" object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshDeviceTab) name:@"refreshDeviceTab" object:nil];
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)btnScenePressed:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    sender.selected = YES;
    _btnDeviceControl.selected = NO;
    self.navigationItem.titleView.hidden = YES;
    
    CGRect rect = CGRectMake(0, 0,
                             320, svHeight_);
    [_svBig scrollRectToVisible:rect animated:NO];
}
-(IBAction)btnDevicePressed:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    sender.selected = YES;
    _btnSceneControl.selected = NO;
    self.navigationItem.titleView.hidden = NO;
    
    CGRect rect = CGRectMake(320, 0,
                             320, svHeight_);
    [_svBig scrollRectToVisible:rect animated:NO];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - 320 / 2) / 320) + 1;
    if (currentPage == 0) {
        _btnSceneControl.selected = YES;
        _btnDeviceControl.selected = NO;
        self.navigationItem.titleView.hidden = YES;
    }else{
        _btnSceneControl.selected = NO;
        _btnDeviceControl.selected = YES;
        self.navigationItem.titleView.hidden = NO;
    }
}

#pragma mark -
#pragma mark UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 101) {//场景
        return senceRowCount_;
    }else{//设备
        return deviceRowCount_;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    if (tableView.tag == 101) {//场景
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
        
        for (int i=0; i<3; i++) {
            NSInteger index = 3*indexPath.row+i;
            if (index >= senceCount_) {
                break;
            }
            Sence *obj = [senceArr_ objectAtIndex:index];
            //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
            iConView *iconView = [[iConView alloc] init];
            iconView.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
            iconView.center = CGPointMake(kImageWidth *(0.5 + i), kImageHeight * 0.5);
            iconView.delegate = self;
            
            NSString *icon = @"";
            if (obj.IconType) {
                icon = obj.IconType;
            }else{
                icon = obj.Type;
            }
            if (![iconArr_ containsObject:icon]) {
                icon = @"other";
            }
            [iconView setIcon:icon andTitle:obj.SenceName];
            [iconView setValue:[NSNumber numberWithInt:index] forKey:@"index"];
            [iconView setValue:obj.Type forKey:@"pType"];
            
            [cell.contentView addSubview:iconView];
        }
        return cell;
    }else{
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
        
        for (int i=0; i<3; i++) {
            int index = 3*indexPath.row+i;
            if (index >= deviceCount_) {
                break;
            }
            Device *obj = [deviceArr_ objectAtIndex:index];
            //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
            iConView *iconView = [[iConView alloc] init];
            iconView.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
            iconView.center = CGPointMake(kImageWidth *(0.5 + i), kImageHeight * 0.5);
            iconView.delegate = self;
            NSString *icon = @"";
            if (obj.IconType) {
                icon = obj.IconType;
            }else{
                icon = obj.Type;
            }
            if (![iconArr_ containsObject:icon]) {
                icon = @"other";
            }
            [iconView setIcon:icon andTitle:obj.DeviceName];
            [iconView setValue:[NSNumber numberWithInt:index] forKey:@"index"];
            [iconView setValue:obj.Type forKey:@"pType"];
            
            [cell.contentView addSubview:iconView];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark iConViewDelegate

-(void)handleLongPressed:(int)index andType:(NSString *)pType
{
    if ([pType isEqualToString:MACRO]) {//场景
        MyAlertView *alert = [[MyAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重命名",@"图标重置",@"删除",@"编辑", nil];
        alert.pIndex = index;
        alert.pType = pType;
        alert.tag = 101;
        [alert show];
    } else{
        MyAlertView *alert = [[MyAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"重命名",@"图标重置",@"删除", nil];
        alert.pIndex = index;
        alert.pType = pType;
        alert.tag = 101;
        [alert show];
    }
}

-(void)handleSingleTapPressed:(int)index andType:(NSString *)pType
{
    NSLog(@"单击====%d",index);
    
    if ([pType isEqualToString:MACRO]) {//场景
        Sence *obj = [senceArr_ objectAtIndex:index];
        Order *orderObj = [[Order alloc] init];
        orderObj.OrderCmd = obj.Macrocmd;
        orderObj.senceId = obj.SenceId;
        self.isSence = YES;
        [self load_typeSocket:999 andOrderObj:orderObj];
    } else if([pType isEqualToString:@"light"]){ // 照明
        LightViewController *lightVC = [[LightViewController alloc] init];
        [self.navigationController pushViewController:lightVC animated:YES];
    } else if([pType isEqualToString:SANSANADDDEVICE]){ // 添加设备
        DeviceConfigViewController *deviceConfigVC = [[DeviceConfigViewController alloc] init];
        [self.navigationController pushViewController:deviceConfigVC animated:YES];
    } else if([pType isEqualToString:SANSANADDMACRO]){ // 添加场景
        
        [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您已进入选择模式,所有按键失效,请选择您要构成场景的动作."
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        CGRect rect = CGRectMake(320, 0, 320, _svBig.frame.size.height);
        [_svBig scrollRectToVisible:rect animated:NO];
        
        [self initDevice:YES];
        
        [DataUtil setGlobalIsAddSence:YES];
        [self setAddSenceModelNavigation];
    } else { //设备
        Device *obj = [deviceArr_ objectAtIndex:index];
        
        RemoteViewController *remoteVC = [[RemoteViewController alloc] init];
        remoteVC.deviceId = obj.DeviceId;
        remoteVC.deviceName = obj.DeviceName;
        [self.navigationController pushViewController:remoteVC animated:YES];
    }
}

#pragma mark -
#pragma mark IconViewDelegate

-(void)refreshTable:(NSString *)pType
{
    if ([pType isEqualToString:MACRO]) {
        [self initSence];
    }else{
        [self initDevice:NO];
    }
}

#pragma mark -
#pragma mark RenameViewDelegate

//取消
-(void)handleCanclePressed
{
    [self hiddenRenameView];
}

//确定
-(void)handleConfirmPressed:(NSString *)deviceId
                 andNewName:(NSString *)newName
                    andType:(NSString *)pType
{
    NSString *sUrl = @"";
    
    if ([pType isEqualToString:MACRO]) {//场景
        sUrl = [NetworkUtil getChangeSenceName:newName andSenceId:deviceId];
    }else{//设备
        sUrl = [NetworkUtil getChangeDeviceName:newName andDeviceId:deviceId];
    }
    
    NSURL *url = [NSURL URLWithString:sUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
        
        if ([pType isEqualToString:MACRO]) {
            [SQLiteUtil renameSenceName:deviceId andNewName:newName];
            [self initSence];
        }else{
            [SQLiteUtil renameDeviceName:deviceId andNewName:newName];
            [self initDevice:NO];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"更新成功."
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        [self hiddenRenameView];
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"更新失败,请稍后再试."
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {//长按
        NSString *deviceId = @"";
        NSString *deviceType = @"";
        NSString *deviceName = @"";
        
        if ([alertView.pType isEqualToString:MACRO]) {
            Sence *obj = [senceArr_ objectAtIndex:alertView.pIndex];
            deviceId = obj.SenceId;
            deviceType = obj.Type;
            deviceName = obj.SenceName;
        }else{
            Device *obj = [deviceArr_ objectAtIndex:alertView.pIndex];
            deviceId = obj.DeviceId;
            deviceType = obj.Type;
            deviceName = obj.DeviceName;
        }
        
        switch (buttonIndex) {
            case 1://重命名
            {
                renameView_.hidden = NO;
                renameView_.tfContent.text = deviceName;
                renameView_.pDeviceId = deviceId;
                renameView_.pType = deviceType;
                break;
            }
            case 2://重置图标
            {
                IconViewController *iconVC = [[IconViewController alloc] init];
                iconVC.pDeviceId = deviceId;
                iconVC.pType = deviceType;
                iconVC.delegate = self;
                [self.navigationController pushViewController:iconVC animated:YES];
                
                break;
            }
            case 3://删除
            {
                MyAlertView *alert = [[MyAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"确定要删除吗?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                alert.tag = 102;
                alert.pType = deviceType;
                alert.pDeviceId = deviceId;
                [alert show];
                
                break;
            }
            case 4://编辑
            {
                [DataUtil setUpdateInsertSenceInfo:deviceId andSenceName:deviceName];
                
                SenceConfigViewController *configVC = [[SenceConfigViewController alloc] init];
                configVC.delegate = self;
                [self.navigationController pushViewController:configVC animated:YES];
                break;
            }
            default:
                break;
        }
    }else if(alertView.tag == 102){//删除
        if (buttonIndex == 0) {
            return;
        }
        
        NSString *sUrl = @"";
        if ([alertView.pType isEqualToString:MACRO]) {
            sUrl = [NetworkUtil getDelSence:alertView.pDeviceId];
        }else{
            sUrl = [NetworkUtil getDelDevice:alertView.pDeviceId];
        }
        
        NSURL *url = [NSURL URLWithString:sUrl];
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
            
            if ([alertView.pType isEqualToString:MACRO]) {
                [SQLiteUtil removeSence:alertView.pDeviceId];
                [self initSence];
            }else{
                [SQLiteUtil removeDevice:alertView.pDeviceId];
                [self initDevice:NO];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"删除成功."
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"删除失败.请稍后再试."
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark SenDelegate

-(void)refreshSenceTab
{
    [self btnCancleSenceModel];
    
    [self initSence];
}

-(void)goOnChoose
{
    [self initDevice:YES];
    
    [DataUtil setGlobalIsAddSence:YES];
    [self setAddSenceModelRightNavEnabledFalse];
    
    CGRect rect = CGRectMake(320, 0, 320, _svBig.frame.size.height);
    [_svBig scrollRectToVisible:rect animated:NO];
}

#pragma mark -
#pragma mark SimpDel

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        [DataUtil setGlobalModel:Model_ZKIp];
    } else {
        [DataUtil setGlobalModel:Model_ZKDOMAIN];
    }
}

#pragma mark -
#pragma mark Custom Methods

-(void)setZkConfig
{
    //设置当前模式
    Config *configObj = [Config getConfig];
    if (configObj.isBuyCenterControl) {//购买中控
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    [DataUtil setGlobalModel:Model_ZKDOMAIN];
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {   
                    Control *control = [SQLiteUtil getControlObj];
                    [SimplePingHelper ping:control.Ip
                                    target:self
                                       sel:@selector(pingResult:)];
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                        message:@"连接失败\n请确认网络是否连接." delegate:nil
                                                              cancelButtonTitle:@"关闭"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    break ;
                }
                default:
                    break;
            };
        }];
    
    } else {
        [DataUtil setGlobalModel:Model_JJ];
    }
}

-(void)refreshDeviceTab
{
    [self initDevice:NO];
}

//楼层菜单
- (void)showCenterMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    //房间下拉
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < [roomArr_ count]; i ++) {
        Room *obj = [roomArr_ objectAtIndex:i];
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:obj.RoomName
                                                    subtitle:@""
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self pushRoomItem:item];
                                                      }];
        
        item.tag = i;
        [items addObject:item];
    }
    
    _menu = [[REMenu alloc] initWithItems:items];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}

//配置菜单
-(void)showRightMenu
{
    [_menu close];
    
    if ([KxMenu isOpen]) {
        return [KxMenu dismissMenu];
    }
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    Config *configObj = [Config getConfig];
    if (configObj.isBuyCenterControl) {
        KxMenuItem *zhengchangItem = [KxMenuItem menuItem:@"正常模式"
                                                    image:nil
                                                   target:self
                                                   action:@selector(pushMenuItem:)];
        
        KxMenuItem *jinjiItem = [KxMenuItem menuItem:@"紧急模式"
                                               image:nil
                                              target:self
                                              action:@selector(pushMenuItem:)];
        
        NSString *model = [DataUtil getGlobalModel];
        
        if ([model isEqualToString:Model_ZKDOMAIN] || [model isEqualToString:Model_ZKIp]) {
            zhengchangItem = [KxMenuItem menuItem:@"正常模式"
                                            image:[UIImage imageNamed:@"success"]
                                           target:self
                                           action:@selector(pushMenuItem:)];
        } else if ([model isEqualToString:Model_JJ]) {
            jinjiItem = [KxMenuItem menuItem:@"紧急模式"
                                       image:[UIImage imageNamed:@"success"]
                                      target:self
                                      action:@selector(pushMenuItem:)];
        }
        
        menuItems = [NSMutableArray arrayWithObjects:zhengchangItem,
                     jinjiItem,
                     
                     [KxMenuItem menuItem:@"写入中控"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItem:)],
                     
                     [KxMenuItem menuItem:@"初始化"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItem:)],
                     
                     [KxMenuItem menuItem:@"关于"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItem:)], nil];
    } else {
        menuItems = [NSMutableArray arrayWithObjects:
                     [KxMenuItem menuItem:@"关于"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItem:)], nil];
    }
    
    
    
    CGRect rect = CGRectMake(215, -50, 100, 50);
    
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];
}

-(void)pushRoomItem:(REMenuItem *)item
{
    Room *obj = [roomArr_ objectAtIndex:item.tag];
    
    //设置导航标题
    UIButton *btnTitle = (UIButton *)[self.navigationItem titleView];
    
    if ([btnTitle.titleLabel.text isEqualToString:obj.RoomName]) {
        return;
    }
    
    [btnTitle setTitle:obj.RoomName forState:UIControlStateNormal];
    
    [DataUtil setGlobalAttrRoom:obj.RoomId];
    
    [self initSence];
    
    [self initDevice:NO];
}

//点击下拉事件
- (void)pushMenuItem:(KxMenuItem *)sender
{
    if ([sender.title isEqualToString:@"正常模式"]) {
        [SVProgressHUD showSuccessWithStatus:@"正常模式"];
        [self setZkConfig];
    } else if ([sender.title isEqualToString:@"紧急模式"])
    {
        [SVProgressHUD showSuccessWithStatus:@"紧急模式"];
        [DataUtil setGlobalModel:Model_JJ];
    } else if ([sender.title isEqualToString:@"写入中控"])
    {
        self.zkOperType = ZkOperNormal;
        [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
        
    } else if ([sender.title isEqualToString:@"初始化"])
    {
        
    } else if ([sender.title isEqualToString:@"关于"])
    {
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

//隐藏重命名浮层
-(void)hiddenRenameView
{
    renameView_.hidden = YES;
    [renameView_.tfContent resignFirstResponder];
}

//取消场景模式
-(void)btnCancleSenceModel
{
    [self initDevice:NO];
    
    [DataUtil setGlobalIsAddSence:NO];
    [self setAddSenceModelRightNavEnabledYES];
    
    [SQLiteUtil removeShoppingCar];
    self.navigationItem.leftBarButtonItem = nil;
    CGRect rect = CGRectMake(0, 0, 320, _svBig.frame.size.height);
    [_svBig scrollRectToVisible:rect animated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
