//
//  LightViewController.m
//  QLink
//
//  Created by SANSAN on 14-9-28.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "LightViewController.h"
#import "SenceConfigViewController.h"
#import "ILBarButtonItem.h"
#import "NetworkUtil.h"
#import "MyAlertView.h"

@interface LightViewController ()
{
    RenameView *renameView_;
    UIScrollView *svBg_;
}
@end

@implementation LightViewController

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
    
    [self initControl];
    
    [self initData];
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
    [btnTitle setTitle:@"照明" forState:UIControlStateNormal];
    btnTitle.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    btnTitle.backgroundColor = [UIColor clearColor];
    
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = btnTitle;
}

-(void)initControl
{
    //设置背景图
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"首页_bg.png"]];
    
    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"RenameView" owner:self options:nil];
    renameView_ = [array1 objectAtIndex:0];
    renameView_.frame = CGRectMake(0, 0, 320, 320);
    renameView_.delegate = self;
    [renameView_.tfContent setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    renameView_.hidden = YES;
    [self.view addSubview:renameView_];
    
    //UIScrollView
    int svHeight = [UIScreen mainScreen ].applicationFrame.size.height - 44;
    svBg_ = [[UIScrollView alloc] init];
    svBg_.frame = CGRectMake(0, 0, self.view.frame.size.width, svHeight);
    svBg_.backgroundColor = [UIColor clearColor];
    [self.view addSubview:svBg_];
}

-(void)initData
{
    for (UIView *view in svBg_.subviews) {
        [view removeFromSuperview];
    }
    
    int height = 0;
    
    //取type='light','light_1','light_check'的控件
    GlobalAttr *obj = [DataUtil shareInstanceToRoom];
    NSArray *deviceArr = [SQLiteUtil getLightDevice:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId];
    
    int iCount = [deviceArr count];
    int iRowCount = iCount%3 == 0 ? iCount/3 : (iCount/3 + 1);
    
    for (int row = 0; row < iRowCount; row++)
    {
        height += 10;
        
        for (int cell = 0; cell < 3; cell ++) {
            int index = 3 * row + cell;
            if (index >= iCount) {
                break;
            }
            
            Device *obj = [deviceArr objectAtIndex:index];
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"SwView1" owner:self options:nil];
            SwView1 *swView = nil;
            if ([obj.Type isEqualToString:@"light"]) {
                swView = [controlArr objectAtIndex:0];
                swView.lTitle1.text = obj.DeviceName;
                swView.plTitle = swView.lTitle1;
            } else if ([obj.Type isEqualToString:@"light_1"]) {//翻转
                swView = [controlArr objectAtIndex:1];
                swView.lTitle2.text = obj.DeviceName;
                swView.plTitle = swView.lTitle2;
            } else if ([obj.Type isEqualToString:@"light_check"]) {//点动
                swView = [controlArr objectAtIndex:2];
                swView.lTitle3.text = obj.DeviceName;
                swView.plTitle = swView.lTitle3;
            }
            swView.frame = CGRectMake(cell * 106, height, 106, 113);
            swView.pDeviceId = obj.DeviceId;
            swView.pDeviceName = obj.DeviceName;
            swView.delegate = self;
            [swView setLongPressEvent];
            [svBg_ addSubview:swView];
            
            NSArray *orderArr = [SQLiteUtil getOrderListByDeviceId:obj.DeviceId];
            
            if ([obj.Type isEqualToString:@"light"]) {
                for (Order *orderObj in orderArr) {
                    if ([orderObj.SubType isEqualToString:@"on"]) {
                        swView.btnOn1.orderObj = orderObj;
                    }else if ([orderObj.SubType isEqualToString:@"off"]){
                        swView.btnOff1.orderObj = orderObj;
                    }
                }
            } else if ([obj.Type isEqualToString:@"light_1"]) {//翻转
                for (Order *orderObj in orderArr) {
                    swView.btnOn2.orderObj = orderObj;
                    swView.btnOff2.orderObj = orderObj;
                }
            } else if ([obj.Type isEqualToString:@"light_check"]) {
                for (Order *orderObj in orderArr) {
                    swView.btnOn3.orderObj = orderObj;
                    swView.btnOff3.orderObj = orderObj;
                }
            }
        }
        
        height += 113;
    }
    
    //绘制type为其他照明类的控件
    NSArray *deviceOtherArr = [SQLiteUtil getLightComplexDevice:obj.HouseId andLayerId:obj.LayerId andRoomId:obj.RoomId];
    for (Device *deviceObj in deviceOtherArr) {
        
        height += 10;
        
        NSArray *orderArr = [SQLiteUtil getOrderListByDeviceId:deviceObj.DeviceId];
        
        if ([deviceObj.Type isEqualToString:@"light_bc"]) {//彩色可调照明
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"LightBcView" owner:self options:nil];
            LightBcView *bcView = [controlArr objectAtIndex:0];
            bcView.frame = CGRectMake(0, height, 320, 113);
            bcView.pDeviceId = deviceObj.DeviceId;
            bcView.pDeviceName = deviceObj.DeviceName;
            bcView.delegate = self;
            bcView.plTitle = bcView.lTitle;
            [bcView setLongPressEvent];
            bcView.lTitle.text = deviceObj.DeviceName;
            [svBg_ addSubview:bcView];
            
            NSMutableArray *brOrderArr = [NSMutableArray array];
            NSMutableArray *coOrderArr = [NSMutableArray array];
            
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"on"]) {
                    bcView.btnOn.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"off"]) {
                    bcView.btnOFF.orderObj = obj;
                } else if ([obj.Type isEqualToString:@"br"]) {
                    [brOrderArr addObject:obj];
                } else if ([obj.Type isEqualToString:@"co"]) {
                    [coOrderArr addObject:obj];
                }
            }
            
            bcView.brOrderArr = brOrderArr;
            bcView.coOrderArr = coOrderArr;
            
            height += 113;
            
        } else if ([deviceObj.Type isEqualToString:@"light_bb"]) {//灯光控制器
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"LightBbView" owner:self options:nil];
            LightBbView *bbView = [controlArr objectAtIndex:0];
            bbView.frame = CGRectMake(0, height, 320, 113);
            bbView.pDeviceId = deviceObj.DeviceId;
            bbView.pDeviceName = deviceObj.DeviceName;
            bbView.delegate = self;
            bbView.plTitle = bbView.lTitle;
            [bbView setLongPressEvent];
            bbView.lTitle.text = deviceObj.DeviceName;
            [svBg_ addSubview:bbView];
            
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"on"]) {
                    bbView.btnOn.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"off"]) {
                    bbView.btnOff.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"ad"]) {
                    bbView.btnUp.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"rd"]) {
                    bbView.btnDown.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"red"]) {
                    bbView.btnFK1.orderObj = obj;
                    [bbView.btnFK1 setTitle:obj.OrderName forState:UIControlStateNormal];
                } else if ([obj.SubType isEqualToString:@"green"]) {
                    bbView.btnFK2.orderObj = obj;
                    [bbView.btnFK2 setTitle:obj.OrderName forState:UIControlStateNormal];
                } else if ([obj.SubType isEqualToString:@"blue"]) {
                    bbView.btnFK3.orderObj = obj;
                    [bbView.btnFK3 setTitle:obj.OrderName forState:UIControlStateNormal];
                } else if ([obj.SubType isEqualToString:@"gb"]) {
                    bbView.btnFK4.orderObj = obj;
                    [bbView.btnFK4 setTitle:obj.OrderName forState:UIControlStateNormal];
                } else if ([obj.SubType isEqualToString:@"rb"]) {
                    bbView.btnFK5.orderObj = obj;
                    [bbView.btnFK5 setTitle:obj.OrderName forState:UIControlStateNormal];
                } else if ([obj.SubType isEqualToString:@"rg"]) {
                    bbView.btnFK6.orderObj = obj;
                    [bbView.btnFK6 setTitle:obj.OrderName forState:UIControlStateNormal];
                } 
            }
            
            height += 113;
            
        } else if ([deviceObj.Type isEqualToString:@"light_bri"]) {//亮度可调照明
            NSArray *controlArr = [[NSBundle mainBundle] loadNibNamed:@"LightBriView" owner:self options:nil];
            LightBriView *briView = [controlArr objectAtIndex:0];
            briView.frame = CGRectMake(0, height, 320, 113);
            briView.pDeviceId = deviceObj.DeviceId;
            briView.pDeviceName = deviceObj.DeviceName;
            briView.delegate = self;
            [briView setLongPressEvent];
            briView.lTitle.text = deviceObj.DeviceName;
            briView.plTitle = briView.lTitle;
            [svBg_ addSubview:briView];
            
            NSMutableArray *brOrderArr = [NSMutableArray array];
            
            for (Order *obj in orderArr) {
                if ([obj.SubType isEqualToString:@"on"]) {
                    briView.btnOn.orderObj = obj;
                } else if ([obj.SubType isEqualToString:@"off"]) {
                    briView.btnOff.orderObj = obj;
                } else if ([obj.Type isEqualToString:@"br"]) {
                    [brOrderArr addObject:obj];
                }
            }
            
            briView.brOrderArr = brOrderArr;
            
            height += 113;
        }
    }
    
    [svBg_ setContentSize:CGSizeMake(320, height +10)];
    
    //将重命名浮层放置到最顶层
    [self.view bringSubviewToFront:renameView_];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {//长按
        switch (buttonIndex) {
            case 1://重命名
            {
                renameView_.hidden = NO;
                renameView_.tfContent.text = alertView.pDeviceName;
                renameView_.pDeviceId = alertView.pDeviceId;
                renameView_.lTitle = alertView.plTitle;
                //    renameView_.pType = deviceType;//light也属于设备的一种，直接更新设备表即可
                break;
            }
            case 2://删除
            {
                MyAlertView *alert = [[MyAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"确定要删除吗?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                alert.tag = 102;
                alert.pDeviceId = alertView.pDeviceId;
                [alert show];
                
                break;
            }
            default:
                break;
        }
    } else if(alertView.tag == 102){//删除
        if (buttonIndex == 0) {
            return;
        }
        
        NSString *sUrl = [NetworkUtil getDelDevice:alertView.pDeviceId];
        
        NSURL *url = [NSURL URLWithString:sUrl];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
            
            [SQLiteUtil removeDevice:alertView.pDeviceId];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"删除成功."
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            [self initData];//刷新页面
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"删除失败.请稍后再试."
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    } else if ((alertView.tag == 103 && buttonIndex == 0) || (alertView.tag == 104 && buttonIndex == 1))
    {
        SenceConfigViewController *senceConfigVC = [[SenceConfigViewController alloc] init];
        [self.navigationController pushViewController:senceConfigVC animated:YES];
    }
}

#pragma mark -
#pragma mark Sw1Delegate,LightBcViewDelegate,LightBriViewDelegate,LightBbViewDelegate

-(void)handleLongPressed:(NSString *)deviceId andDeviceName:(NSString *)deviceName andLabel:(UILabel *)lTitle
{
    MyAlertView *alert = [[MyAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"重命名",@"删除", nil];
    alert.pDeviceId = deviceId;
    alert.pDeviceName = deviceName;
    alert.plTitle = lTitle;
    alert.tag = 101;
    [alert show];
}

-(void)orderDelegatePressed:(OrderButton *)sender
{
    if (!sender.orderObj) {
        return;
    }
    
    NSLog(@"====%@",sender.orderObj.OrderName);
    
    if ([DataUtil getGlobalIsAddSence]) {//添加场景模式
        if ([SQLiteUtil getShoppingCarCount] >= 40) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"最多添加40个命令,请删除后再添加."
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            alert.tag = 103;
            [alert show];
            return;
        }
        BOOL bResult = [SQLiteUtil addOrderToShoppingCar:sender.orderObj.OrderId andDeviceId:sender.orderObj.DeviceId];
        if (bResult) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"已成功添加命令,是否继续?"
                                                           delegate:self
                                                  cancelButtonTitle:@"继续"
                                                  otherButtonTitles:@"完成", nil];
            alert.tag = 104;
            [alert show];
        }
    } else {
        [self load_typeSocket:999 andOrderObj:sender.orderObj];
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
                    andLabel:(UILabel *)lTitle
{
    NSString *sUrl = [NetworkUtil getChangeDeviceName:newName andDeviceId:deviceId];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *sResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    if ([[sResult lowercaseString] isEqualToString:@"ok"]) {
        [SQLiteUtil renameDeviceName:deviceId andNewName:newName];
        lTitle.text = newName;
        [self hiddenRenameView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"修改成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"更新失败,请稍后再试."
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark -
#pragma mark Custom Methods

-(void)btnBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏重命名浮层
-(void)hiddenRenameView
{
    renameView_.hidden = YES;
    [renameView_.tfContent resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
