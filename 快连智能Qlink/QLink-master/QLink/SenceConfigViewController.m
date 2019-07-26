//
//  SenceConfigViewController.m
//  QLink
//
//  Created by 尤日华 on 14-10-1.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "SenceConfigViewController.h"
#import "SenceConfigTableViewCell.h"
#import "MainViewController.h"
#import "ILBarButtonItem.h"
#import "DataUtil.h"
#import "NetworkUtil.h"
#import "MyURLConnection.h"
#import "SVProgressHUD.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface SenceConfigViewController ()
{
    NSMutableArray *senceConfigArr_;
    RenameView *renameView_;
    NSArray *pickerArray_;
    
    UIButton *btnNumSel_;//记录所选行的数字按钮
    Sence *objSel_;//记录所选行数字按钮对应的场景对象
    
    NSString *orderIds_;
    NSString *times_;
    
    NSString *pDeviceId_;
    NSString *pDeviceName_;
    NSMutableArray *iconArr_;
}

@end

@implementation SenceConfigViewController

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
    
    [self initNavigation];
    
    [self initControl];
    
    [self initData];
}

-(void)initIconArr
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iConPlist" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    iconArr_ = [NSMutableArray array];
    [iconArr_ addObjectsFromArray:[dataDic objectForKey:@"Sence"]];
    [iconArr_ addObjectsFromArray:[dataDic objectForKey:@"Device"]];
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
}

-(void)initControl
{
    _tbOrder.delegate = self;
    _tbOrder.dataSource = self;
    [_tbOrder setEditing:YES animated:YES];
    if ([_tbOrder respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbOrder setSeparatorInset:UIEdgeInsetsZero];
    }
    
    senceConfigArr_ = [NSMutableArray array];
    
    NSArray *array1 = [[NSBundle mainBundle] loadNibNamed:@"RenameView" owner:self options:nil];
    renameView_ = [array1 objectAtIndex:0];
    renameView_.frame = CGRectMake(0, 0, 320, 320);
    renameView_.delegate = self;
    [renameView_.tfContent setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    renameView_.hidden = YES;
    [self.view addSubview:renameView_];
    
    self.pickerViewNum.delegate = self;
    self.pickerViewNum.dataSource = self;
}

-(void)initData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    pDeviceId_ = [ud objectForKey:@"SenceId"];
    pDeviceName_ = [ud objectForKey:@"SenceName"];
    
    pickerArray_ = [NSArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50", nil];
    if (![DataUtil checkNullOrEmpty:pDeviceId_]) {
        [senceConfigArr_ addObjectsFromArray:[SQLiteUtil getOrderBySenceId:pDeviceId_]];
    }
    
     [senceConfigArr_ addObjectsFromArray:[SQLiteUtil getShoppingCarOrder]];
    
    [_tbOrder reloadData];
}

#pragma mark -
#pragma mark IBAction Methods

//保存场景
- (IBAction)btnSaveSence
{
    if ([senceConfigArr_ count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您还没有构建场景命令."
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    renameView_.hidden = NO;
    renameView_.tfContent.text = pDeviceName_;

    orderIds_ = @"";
    times_ = @"";
    
    for (int i = 0; i < [senceConfigArr_ count]; i++) {
        Sence *obj = [senceConfigArr_ objectAtIndex:i];
        
        NSLog(@"==%@==%@\n",obj.OrderName,obj.Timer);
        
        if ([DataUtil checkNullOrEmpty:orderIds_]) {
            orderIds_ = obj.OrderId;
        }else{
            orderIds_ = [NSString stringWithFormat:@"%@,%@",orderIds_,obj.OrderId];
        }
        if ([DataUtil checkNullOrEmpty:times_]) {
            times_ = obj.Timer;
        }else{
            times_ = [NSString stringWithFormat:@"%@,%@",times_,obj.Timer];
        }
    }
}

//#pragma mark -
//#pragma mark NSURLConnection 回调方法
//- (void)connection:(MyURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [responseData_ appendData:data];
//}
//-(void) connection:(MyURLConnection *)connection didFailWithError: (NSError *)error
//{
//    NSLog(@"====fail");
//    
//    [connection cancel];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"连接失败\n请确认网络是否连接." delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil, nil];
//    [alertView show];
//
//    [SVProgressHUD dismiss];
//}
//- (void)connectionDidFinishLoading: (MyURLConnection*)connection
//{
//    NSString *sResult = [[NSString alloc] initWithData:responseData_ encoding:NSUTF8StringEncoding];
//    
//    NSString *senceName = renameView_.tfContent.text;
//    NSString *ordercmd = [NSString stringWithFormat:@"%@|%@",orderIds_,times_];
//    
//    NSArray *arr = [sResult componentsSeparatedByString:@","];
//    if ([arr count] > 1) {//新增
//        if ([[[arr objectAtIndex:0] lowercaseString] isEqualToString:@"ok"]) {
//            Sence *obj = [[Sence alloc] init];
//            obj.SenceId = [arr objectAtIndex:1];
//            obj.SenceName = senceName;
//            obj.Macrocmd = [arr objectAtIndex:2];
//            obj.CmdList = ordercmd;
//            [SQLiteUtil insertSence:obj];
//            
//            //刷新数据库
//            [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSenceTab" object:nil];
//            
//            Config *configObj = [Config getConfig];
//            if (configObj.isBuyCenterControl) {
//                //写入中控
//                self.zkOperType = ZkOperSence;
//                [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
//            }else{
//                //页面跳转
//                NSArray * viewcontrollers = self.navigationController.viewControllers;
//                int idxInStack = 0;
//                for (int i=0; i<[viewcontrollers count]; i++) {
//                    if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
//                        idxInStack = i;
//                        break;
//                    }
//                }
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
//            }
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"添加场景失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } else { //编辑
//        if ([[[arr objectAtIndex:0] lowercaseString] isEqualToString:@"ok"]) {
//            
//            //更新数据库
//            [SQLiteUtil updateCmdListBySenceId:pDeviceId_ andSenceName:senceName andCmdList:ordercmd];
//            
//            [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSenceTab" object:nil];
//            
//            Config *configObj = [Config getConfig];
//            if (configObj.isBuyCenterControl) {
//                //写入中控
//                self.zkOperType = ZkOperSence;
//                [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
//            }else{
//                //页面跳转
//                NSArray * viewcontrollers = self.navigationController.viewControllers;
//                int idxInStack = 0;
//                for (int i=0; i<[viewcontrollers count]; i++) {
//                    if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
//                        idxInStack = i;
//                        break;
//                    }
//                }
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
//            }
//            
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"更新场景失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//    
//    
//    [self hiddenRenameView];
//    
//    [SVProgressHUD dismiss];
//}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction)btnContinue
{
    if (![DataUtil checkNullOrEmpty:pDeviceId_]) {//修改
        if (self.delegate) {
            [self.delegate goOnChoose];
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnCancle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"确定要取消本次操作吗?"
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 101;
    [alert show];
}

- (IBAction)btnPickerViewCancle
{
    self.viewPicker.hidden = YES;
    btnNumSel_ = nil;
    objSel_ = nil;
}

- (IBAction)btnPickerViewConfirm
{
    if (btnNumSel_) {
        NSInteger row =[self.pickerViewNum selectedRowInComponent:0];
        NSString *sNum = [pickerArray_ objectAtIndex:row];
        
        [btnNumSel_ setTitle:sNum forState:UIControlStateNormal];
        
        
        for (Sence *objSource in senceConfigArr_) {
            if ([objSource.OrderId isEqualToString:objSel_.OrderId]) {
                objSource.Timer = sNum;
                [SQLiteUtil updateShoppingCarTimer:objSource.OrderId andDeviceId:objSource.SenceId andTimer:sNum];
                break;
            }
        }
        
        [self btnPickerViewCancle];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [senceConfigArr_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CELL";
    SenceConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SenceConfigTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    
    Sence *obj = [senceConfigArr_ objectAtIndex:indexPath.row];
    NSString *type = obj.IconType;
    if ([DataUtil checkNullOrEmpty:type]) {
        type = obj.Type;
    }
    
    if (![iconArr_ containsObject:type]) {
        type = @"other";
    }
    //处理‘点动’和‘翻转’的图标
    if ([type isEqualToString:@"light_1"] || [type isEqualToString:@"light_check"] || [type isEqualToString:@"light_bri"]) {
        type = @"light";
    }
    
    [cell setIcon:type andDeviceName:obj.SenceName andOrderName:obj.OrderName andTime:obj.Timer];
    cell.pSenceObj = obj;
    cell.lblNo.text = [NSString stringWithFormat:@"%d.",indexPath.row+1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"from:%d to %d",sourceIndexPath.row,destinationIndexPath.row);
    
    //更新数据的顺序
    Sence *objToMove = [senceConfigArr_ objectAtIndex:sourceIndexPath.row];
    
    [senceConfigArr_ removeObjectAtIndex:sourceIndexPath.row];
    
    [senceConfigArr_ insertObject:objToMove atIndex:destinationIndexPath.row];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray_ count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray_ objectAtIndex:row];
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
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *sUrl = [NetworkUtil getEditSence:pDeviceId_ andSenceName:renameView_.tfContent.text andCmd:orderIds_ andTime:times_];
    
    NSURL *url = [NSURL URLWithString:sUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:50];

//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    define_weakself;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [DataUtil setGlobalIsAddSence:NO];
         
         NSString *sResult = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

         NSRange range = [sResult rangeOfString:@"error"];
         if (range.location != NSNotFound)
         {
             NSArray *errorArr = [sResult componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
                 return;
             }
         }
         
//         if ([sResult containsString:@"error"]) {
//             NSArray *errorArr = [sResult componentsSeparatedByString:@":"];
//             if (errorArr.count > 1) {
//                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
//                 return;
//             }
//         }
         
         NSString *ordercmd = [NSString stringWithFormat:@"%@|%@",orderIds_,times_];
         NSLog(@"%@-----%@",ordercmd,orderIds_);
         NSArray *arr = [sResult componentsSeparatedByString:@","];
         if ([arr count] > 1) {//新增
             if ([[[arr objectAtIndex:0] lowercaseString] isEqualToString:@"ok"]) {
                 Sence *obj = [[Sence alloc] init];
                 obj.SenceId = [arr objectAtIndex:1];
                 obj.SenceName = newName;
                 obj.Macrocmd = [arr objectAtIndex:2];
                 obj.CmdList = ordercmd;
                 [SQLiteUtil insertSence:obj];
                 
                 //刷新数据库
                 [SQLiteUtil removeShoppingCar];
                 [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSenceTab" object:nil];
                 
                 Config *configObj = [Config getConfig];
                 if (configObj.isBuyCenterControl) {
                     //写入中控
                     self.zkOperType = ZkOperSence;
                     [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
                 }else{
                     //页面跳转
                     NSArray * viewcontrollers = self.navigationController.viewControllers;
                     int idxInStack = 0;
                     for (int i=0; i<[viewcontrollers count]; i++) {
                         if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                             idxInStack = i;
                             break;
                         }
                     }
                     
                     [SVProgressHUD dismiss];
                     
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
                 }
             } else {
                 [SVProgressHUD showErrorWithStatus:@"添加场景失败"];
             }
         } else { //编辑
             if ([[[arr objectAtIndex:0] lowercaseString] isEqualToString:@"ok"]) {
                 
                 //更新数据库
                 [SQLiteUtil updateCmdListBySenceId:pDeviceId_ andSenceName:newName andCmdList:ordercmd];
                 
                 [SQLiteUtil removeShoppingCar];
                 [DataUtil setUpdateInsertSenceInfo:@"" andSenceName:@""];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSenceTab" object:nil];
                 
                 Config *configObj = [Config getConfig];
                 if (configObj.isBuyCenterControl) {
                     //写入中控
                     self.zkOperType = ZkOperSence;
                     [self load_typeSocket:SocketTypeWriteZk andOrderObj:nil];
                 }else{
                     //页面跳转
                     NSArray * viewcontrollers = self.navigationController.viewControllers;
                     int idxInStack = 0;
                     for (int i=0; i<[viewcontrollers count]; i++) {
                         if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                             idxInStack = i;
                             break;
                         }
                     }
                     [SVProgressHUD dismiss];
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
                 }
             } else {
                 [SVProgressHUD showErrorWithStatus:@"更新场景失败"];
             }
         }
 
         [self hiddenRenameView];
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                             message:@"连接失败\n请确认网络是否连接." delegate:nil
                                                   cancelButtonTitle:@"关闭"
                                                   otherButtonTitles:nil, nil];
         [alertView show];

     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
//    MyURLConnection *connection = [[MyURLConnection alloc]
//                                   initWithRequest:request
//                                   delegate:self];
//
//    if (connection) {
//        responseData_ = [NSMutableData new];
//    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 && buttonIndex == 1) {//确定，则删除数据库中所有命令
        BOOL bResult = [SQLiteUtil removeShoppingCar];
        if (bResult) {
            [DataUtil setGlobalIsAddSence:NO];//设置当前为非添加模式
            MainViewController *mainVC = [[MainViewController alloc] init];
            
            [self.navigationController pushViewController:mainVC animated:NO];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"操作失败,请稍后再试."
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark SenceConfigDelegate

-(void)handleShowDDL:(UIButton *)sender andObj:(Sence *)obj
{
    btnNumSel_ = sender;
    objSel_ = obj;
    self.viewPicker.hidden = NO;
}

-(void)setOrderArrNewValue:(NSString *)orderId andNewNum:(NSString *)newNum
{
    for (Sence *objSource in senceConfigArr_) {
        if ([objSource.OrderId isEqualToString:orderId]) {
            objSource.Timer = newNum;
            [SQLiteUtil updateShoppingCarTimer:objSource.OrderId andDeviceId:objSource.SenceId andTimer:newNum];
            break;
        }
    }
}

-(void)handleLongPressed:(Sence *)obj
{
    BOOL bResult = [SQLiteUtil removeShoppingCarByOrderId:obj.OrderId];
    if (bResult) {
        [senceConfigArr_ removeObject:obj];
        [_tbOrder reloadData];
    }
}

#pragma mark -
#pragma mark Custom Methods

//隐藏重命名浮层
-(void)hiddenRenameView
{
    renameView_.hidden = YES;
    [renameView_.tfContent resignFirstResponder];
}

-(void)btnBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
