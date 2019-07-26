//
//  BaseViewController.m
//  QLink
//
//  Created by 尤日华 on 14-10-12.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "BaseViewController.h"
#import "NSString+NSStringHexToBytes.h"
#import "NSData+NSDataBytesToHex.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "NetworkUtil.h"
#import "XMLDictionary.h"
#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIAlertView+MKBlockAdditions.h"

#define READ_TIMEOUT 15.0

@interface BaseViewController ()
{
    //场景，设备参数
    NSString *sendContent_;
    
    //中控参数&紧急模式
    NSMutableArray *cmdReadArr_;
    NSMutableArray *cmdOperArr_;
    double progressValue_;
    double avgValue_;//进度条的加量
    
    NSDictionary *sendCmdDic_;//当前发送的对象,用于中控参数
    Sence *sendSenceObj_;//紧急模式下发送的场景对象
    Order *sendDeviceObj_;//紧急模式下发送设备对象
    Control *zkConfig_;
    BOOL isSendZKFailAndSendLast_;
}
@end

@implementation BaseViewController

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
}

-(void)load_typeSocket:(SocketType)socket andOrderObj:(Order *)order
{
    switch (socket) {
        case SocketTypeWriteZk://写入中控
        {
            self.socketType = SocketTypeWriteZk;
            [self initRequestWriteZK];
            break;
        }
        default:
        {
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1012);
            NSString *so = [DataUtil getGlobalModel];
            if ([so isEqualToString:Model_ZKIp]) {
                self.socketType = SocketTypeNormal;
                [self sendNormalIpSocketOrder:order.OrderCmd];
            } else if ([so isEqualToString:Model_ZKDOMAIN]){
                self.socketType = SocketTypeNormal;
                [self sendNormalDomainSocketOrder:order.OrderCmd];
            }
            else if([so isEqualToString:Model_JJ]) { //紧急模式
                self.socketType = SocketTypeEmergency;

                dispatch_queue_t queue = dispatch_queue_create("name", NULL);
                //创建一个子线程
                dispatch_async(queue, ^{
                    [self initEmergencySocketOrder:order];
                });
            } else if ([so isEqualToString:Model_Study])
            {
                self.socketType = SocketTypeStudy;
                [self initStudySocketOrder:order.StudyCmd andAddress:order.Address];
            }
            break;
        }
    }
}

#pragma mark -
#pragma mark 写入中控

-(void)initRequestWriteZK
{
    self.iTimeoutCount = 1;
    isSendZKFailAndSendLast_ = NO;
    
    [SVProgressHUD showWithStatus:@"请稍后" maskType:SVProgressHUDMaskTypeClear];
    
    NSURL *url = [NSURL URLWithString:[[NetworkUtil getAction:ACTIONSETUPZK] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak __typeof(self)weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strXML = operation.responseString;
        NSRange range = [strXML rangeOfString:@"error"];
        if (range.location != NSNotFound)
        {
            NSArray *errorArr = [strXML componentsSeparatedByString:@":"];
            if (errorArr.count > 1) {
                [SVProgressHUD showErrorWithStatus:errorArr[1]];
                return;
            }
        }
        
//        if ([strXML containsString:@"error"]) {
//            NSArray *errorArr = [strXML componentsSeparatedByString:@":"];
//            if (errorArr.count > 1) {
//                [SVProgressHUD showErrorWithStatus:errorArr[1]];
//                return;
//            }
//        }
        
        strXML = [strXML stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"utf-8\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,40)];
        NSData *newData = [strXML dataUsingEncoding:NSUTF8StringEncoding];
        
        //设置发送host
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:newData];
        NSDictionary *info = [dict objectForKey:@"info"];
        zkConfig_ = [[Control alloc] init];
        zkConfig_.Ip = [info objectForKey:@"_ip"];
        zkConfig_.SendType = [info objectForKey:@"_tu"];
        zkConfig_.Port = [info objectForKey:@"_port"];
        
        //拼接队列
        cmdReadArr_ = [NSMutableArray arrayWithArray:[DataUtil changeDicToArray:[info objectForKey:@"tecom"]]];
        cmdOperArr_ = [NSMutableArray arrayWithArray:cmdReadArr_];
        NSInteger iCount = [cmdReadArr_ count];
        if ([cmdOperArr_ count] == 0) {
            [SVProgressHUD dismiss];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"没有定义中控命令." delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        NSString *strInfo = [NSString stringWithFormat:@"写入中控[0/%ld]",[cmdReadArr_ count]];
        
        [SVProgressHUD showProgress:0 status:strInfo maskType:SVProgressHUDMaskTypeClear];
        
        progressValue_ = 0;
        avgValue_ = (double)1/iCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf firstSendZkSocketOrder];
        });
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [SVProgressHUD dismiss];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

//第一次发送中控命令
-(void)firstSendZkSocketOrder
{
    sendCmdDic_ = [cmdOperArr_ objectAtIndex:0];
    sendContent_ = [sendCmdDic_ objectForKey:@"_sdcmd"];
    
    if ([[zkConfig_.SendType lowercaseString] isEqualToString:@"tcp"]) {
        [self initTcp:zkConfig_.Ip andPort:zkConfig_.Port];
    }
    else{
        [self initUdp:zkConfig_.Ip andPort:zkConfig_.Port];
    }
}

//循环发送调用方法
-(void)sendZkSocketOrder
{
    sendCmdDic_ = [cmdOperArr_ objectAtIndex:0];
    sendContent_ = [sendCmdDic_ objectForKey:@"_sdcmd"];
    
    NSData *data = [sendContent_ hexToBytes];
    [asyncSocket_ writeData:data withTimeout:-1 tag:-1];
}

#pragma mark -
#pragma mark 正常模式发送场景，设备socket，也就是购买中控，全局发送Domain

-(void)sendNormalIpSocketOrder:(NSString *)cmd
{
    sendContent_ = cmd;
    
    Control *controlObj = [SQLiteUtil getControlObj];
    
    if ([[controlObj.SendType lowercaseString] isEqualToString:@"tcp"]) {
        [self initTcp:controlObj.Ip andPort:controlObj.Port];
    }
    else{
        [self initUdp:controlObj.Ip andPort:controlObj.Port];
    }
}

-(void)sendNormalDomainSocketOrder:(NSString *)cmd
{
    sendContent_ = cmd;
    
    Control *controlObj = [SQLiteUtil getControlObj];
    
    if ([[controlObj.SendType lowercaseString] isEqualToString:@"tcp"]) {
        [self initTcp:controlObj.Domain andPort:controlObj.Port];
    }
    else{
        [self initUdp:controlObj.Domain andPort:controlObj.Port];
    }
}

#pragma mark -
#pragma mark 紧急模式发送场景，设备socket

-(void)initEmergencySocketOrder:(Order *)order
{
    if (self.isSence) {
        self.iTimeoutCount = 1;
        
        //拼接队列
        cmdReadArr_ = [NSMutableArray arrayWithArray:[SQLiteUtil getOrderBySenceId:order.senceId]];
        cmdOperArr_ = [NSMutableArray arrayWithArray:cmdReadArr_];
        
        [self sendEmergencySocketOrder];
    } else {
        sendDeviceObj_ = order;
        sendContent_ = order.OrderCmd;
        sendContent_ = [sendContent_ substringFromIndex:4];
        
        NSArray *addArr = [order.Address componentsSeparatedByString:@":"];
        NSString *type = addArr[0];
        NSString *ip = addArr[1];
        NSString *port = addArr[2];
        if ([[type lowercaseString] isEqualToString:@"tcp"]) {
            [self initTcp:ip andPort:port];
        } else {
            [self initUdp:ip andPort:port];
        }
    }
}


-(void)sendEmergencySocketOrder
{
    NSArray *addArr = nil;
    if (self.isSence) {
        sendSenceObj_ = [cmdOperArr_ objectAtIndex:0];
        sendContent_ = sendSenceObj_.OrderCmd;
        sendContent_ = [sendContent_ substringFromIndex:4];
        addArr = [sendSenceObj_.Address componentsSeparatedByString:@":"];
    } else {
       addArr = [sendDeviceObj_.Address componentsSeparatedByString:@":"];
    }
    NSString *type = addArr[0];
    NSString *ip = addArr[1];
    NSString *port = addArr[2];
    if ([[type lowercaseString] isEqualToString:@"tcp"]) {
        [self initTcp:ip andPort:port];
    }
    else{
        [self initUdp:ip andPort:port];
    }
}

#pragma mark -
#pragma mark 设备学习模式

-(void)initStudySocketOrder:(NSString *)cmd andAddress:(NSString *)address
{
    sendContent_ = cmd;
    
    NSArray *addArr = [address componentsSeparatedByString:@":"];
    NSString *type = addArr[0];
    NSString *ip = addArr[1];
    NSString *port = addArr[2];
    
    if ([[type lowercaseString] isEqualToString:@"tcp"]) {
        [self initTcp:ip andPort:port];
    } else {
        [self initUdp:ip andPort:port];
    }
}

#pragma mark -
#pragma mark 发送方法（UDP／TCP）

-(void)initUdp:(NSString *)host
       andPort:(NSString *)port
{
    /**************创建连接**************/
    
    NSError *error = nil;
    if (udpSocket_ != nil) {
        [udpSocket_ close];
        udpSocket_ = nil;
    }
    
    udpSocket_ = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    if (port != nil && ![udpSocket_ bindToPort:[port integerValue] error:&error])
    {
        NSLog(@"Error binding: %@", error);
        return;
    }

    //接收数据API
	if (![udpSocket_ beginReceiving:&error])
	{
		NSLog(@"Error receiving: %@", error);
		return;
	}
    
	NSLog(@"udp连接成功");
    
    /**************发送数据**************/
    
    NSData *data = [sendContent_ hexToBytes];
    [udpSocket_ sendData: data toHost: host port: [port integerValue] withTimeout:-1 tag: -1];
}

-(void)initTcp:(NSString *)host
       andPort:(NSString *)port
{
    /**************创建连接**************/
    
    asyncSocket_ = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![asyncSocket_ connectToHost:host onPort:[port integerValue] withTimeout:1 error:&error])
    {
        NSLog(@"Error connecting");
        return;
    }
}

#pragma mark -
#pragma mark UDP 响应方法

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	switch (self.socketType) {
        case SocketTypeWriteZk:
        {
            
            break;
        }
        case SocketTypeNormal:
        {

            break;
        }
        case SocketTypeEmergency:
        {
            if (self.isSence) {
                float haomiao = [sendSenceObj_.Timer intValue] * 0.05;
                [NSThread sleepForTimeInterval:haomiao];
                [cmdOperArr_ removeObjectAtIndex:0];
                //发送完成
                if ([cmdOperArr_ count] == 0) {
                    return;
                }
                self.iTimeoutCount = 1;
                [self sendEmergencySocketOrder];
            }
            break;
        }
        default:
            break;
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    switch (self.socketType) {
        case SocketTypeWriteZk:
        {
            break;
        }
        case SocketTypeNormal:
        {
            break;
        }
        case SocketTypeEmergency:
        {
            if (NumberOfTimeout > [self iTimeoutCount]) {
                [self setITimeoutCount:[self iTimeoutCount] + 1];
                sleep(1);
                [self sendEmergencySocketOrder];
            } else if ([self iTimeoutCount] >= NumberOfTimeout) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"紧急模式发送失败." delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                [alert show];
                
                [SVProgressHUD dismiss];
            }
            
            break;
        }
        default:
            break;
    }
}

//接收UDP数据
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
//	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	if (msg)
//	{
//		NSLog(@"RECV: %@", msg);
//	}
//	else
//	{
//		NSString *host = nil;
//		uint16_t port = 0;
//		[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
//		
//		NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
//	}
}


#pragma mark -
#pragma mark TCP 响应方法

//当成功连接上，delegate 的 socket:didConnectToHost:port: 方法会被调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝\n");
    NSLog(@"连接成功\n");
	NSLog(@"已连接到 －－ socket:%p didConnectToHost:%@ port:%hu \n", sock, host, port);
    
    NSData *data = [sendContent_ hexToBytes];
    
    [asyncSocket_ writeData:data withTimeout:-1 tag:-1];//发送数据;  withTimeout:超时时间，设置为－1代表永不超时;  tag:区别该次读取与其他读取的标志,通常我们在设计视图上的控件时也会有这样的一个属性就是tag;
}

//未成功连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        switch (self.socketType) {
            case SocketTypeWriteZk:
            {
                if (NumberOfTimeout > [self iTimeoutCount]) {
                    [self setITimeoutCount:[self iTimeoutCount] + 1];
                    sleep(1);
                    [self firstSendZkSocketOrder];
                } else if ([self iTimeoutCount] >= NumberOfTimeout) {
                    [UIAlertView alertViewWithTitle:@"温馨提示"
                                            message:@"写入中控失败,请重试."
                                  cancelButtonTitle:@"关闭"
                                  otherButtonTitles:@[@"重试"]
                                          onDismiss:^(int index){
                                              [self sendZkTryAgain];
                    }onCancel:^{
                        [self sendZkLastOrder];
                    }];
                    
                    [SVProgressHUD dismiss];
                }
                
                break;
            }
            case SocketTypeNormal:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"连接服务器失败."
                                                               delegate:nil
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SocketTypeEmergency:
            {
                if (NumberOfTimeout > self.iTimeoutCount) {
                    [self setITimeoutCount:[self iTimeoutCount] + 1]; 
                    sleep(1);
                    [self sendEmergencySocketOrder];
                } else if ([self iTimeoutCount] >= NumberOfTimeout) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                    message:@"紧急模式发送失败." delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    [SVProgressHUD dismiss];
                }
                
                break;
            }
            default:
                break;
        }
        
        NSLog(@"连接失败\n");
        NSLog(@"错误信息 －－ socketDidDisconnect:%p withError: %@", sock, err);
    }else {
        NSLog(@"断开连接\n");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    switch (self.socketType) {
        case SocketTypeWriteZk:
        {
            [sock readDataWithTimeout:3 tag:-1];
            break;
        }
        case SocketTypeNormal:
        {
            [self disConnectionTCP];
            break;
        }
        case SocketTypeEmergency:
        {
            [self disConnectionTCP];
            
            if (self.isSence) {
                float haomiao = [sendSenceObj_.Timer intValue] * 0.05;
                [NSThread sleepForTimeInterval:haomiao];
                [cmdOperArr_ removeObjectAtIndex:0];
                if ([cmdOperArr_ count] == 0) {
                    return;
                }
                self.iTimeoutCount = 1;
                [self sendEmergencySocketOrder];
            }
            break;
        }
        default:
            break;
    }
}

//接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    switch (self.socketType) {
        case SocketTypeWriteZk:
        {
            NSData *bkcCmd = [[sendCmdDic_ objectForKey:@"_bkcmd"] hexToBytes];
            NSData *top3Cmd = [bkcCmd subdataWithRange:NSMakeRange(0, 3)];
            NSData *readTop3 = [data subdataWithRange:NSMakeRange(0, 3)];
            
            if ([top3Cmd isEqualToData: readTop3])
            {
                [cmdOperArr_ removeObject:sendCmdDic_];
                
                if (!isSendZKFailAndSendLast_) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progressValue_ += avgValue_;
                        NSString *strInfo = [NSString stringWithFormat:@"写入中控[%d/%d]",([cmdReadArr_ count]-[cmdOperArr_ count]),[cmdReadArr_ count]];
                        
                        [SVProgressHUD showProgress:progressValue_ status:strInfo maskType:SVProgressHUDMaskTypeClear];
                    });
                }
                
                
                //发送完成，关闭连接
                if ([cmdOperArr_ count] == 0) {
                    if (!isSendZKFailAndSendLast_) {
                        NSString *sUrl = [NetworkUtil getAction:ACTIONSETUPZKOK];
                        NSURL *url = [NSURL URLWithString:sUrl];
//                        NSURLRequest *request = [NSURLRequest requestWithURL:url];
                        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                        
                        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                         {
                             NSString *strResult = operation.responseString;
                             NSRange range = [strResult rangeOfString:@"error"];
                             if (range.location != NSNotFound)
                             {
                                 NSArray *errorArr = [strResult componentsSeparatedByString:@":"];
                                 if (errorArr.count > 1) {
                                     [SVProgressHUD showErrorWithStatus:errorArr[1]];
                                     return;
                                 }
                             }
//                             if ([strResult containsString:@"error"]) {
//                                 NSArray *errorArr = [strResult componentsSeparatedByString:@":"];
//                                 if (errorArr.count > 1) {
//                                     [SVProgressHUD showErrorWithStatus:errorArr[1]];
//                                     return;
//                                 }
//                             }
                             
                             switch (self.zkOperType) {
                                 case ZkOperSence:
                                 {
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设置场景成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                     [alert show];
                                     
                                     //页面跳转
                                     NSArray * viewcontrollers = self.navigationController.viewControllers;
                                     int idxInStack = 0;
                                     for (int i=0; i<[viewcontrollers count]; i++) {
                                         if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                                             idxInStack = i;
                                             break;
                                         }
                                     }
                                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
                                     break;
                                 }
                                 case ZkOperDevice:
                                 {
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设置设备成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                     [alert show];
                                     
                                     //页面跳转
                                     NSArray * viewcontrollers = self.navigationController.viewControllers;
                                     int idxInStack = 0;
                                     for (int i=0; i<[viewcontrollers count]; i++) {
                                         if ([[viewcontrollers objectAtIndex:i] isMemberOfClass:[MainViewController class]]) {
                                             idxInStack = i;
                                             break;
                                         }
                                     }
                                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idxInStack]animated:YES];
                                     break;
                                 }
                                 case ZkOperNormal:
                                 {
                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                         message:@"写入中控成功."
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"确定"
                                                                               otherButtonTitles:nil, nil];
                                     [alertView show];
                                     break;
                                 }
                                 default:
                                     break;
                             }
                             
                             
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                 message:@"写入失败." delegate:nil
                                                                       cancelButtonTitle:@"关闭"
                                                                       otherButtonTitles:nil, nil];
                             [alertView show];
                         }];
                        
                        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                        [queue addOperation:operation];
                    }
                    
                    [self disConnectionTCP];
//                    [progressView_ removeFromSuperview];
                    [SVProgressHUD dismiss];
                    
                    return;
                }
                
                self.iTimeoutCount = 1;
                [self sendZkSocketOrder];
            }
            else
            {
                if (NumberOfTimeout > [self iTimeoutCount]) {
                    [self setITimeoutCount:[self iTimeoutCount] + 1];
                    [self sendZkSocketOrder];
                } else if ([self iTimeoutCount] >= NumberOfTimeout) {
                    [UIAlertView alertViewWithTitle:@"温馨提示"
                                            message:@"写入中控失败,请重试."
                                  cancelButtonTitle:@"关闭"
                                  otherButtonTitles:@[@"重试"]
                                          onDismiss:^(int index){
                                              [self sendZkTryAgain];
                                          }onCancel:^{
                                              [self sendZkLastOrder];
                                          }];
                    
                    [SVProgressHUD dismiss];
                }
            }
            
            break;
        }
        case SocketTypeNormal:
        {
            break;
        }
        case SocketTypeEmergency:
        {
            
            break;
        }
        default:
            break;
    }
}

//#pragma mark -
//#pragma mark UIAlertViewDelegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 999) {
//        if (buttonIndex == 0) {//关闭
//            isSendZKFailAndSendLast_ = YES;
//            sendCmdDic_ = [cmdOperArr_ lastObject];
//            [cmdOperArr_ removeAllObjects];
//            [cmdOperArr_ addObject:sendCmdDic_];
//            [self sendZkSocketOrder];
//        } else if (buttonIndex == 1) {//重试
//            [SVProgressHUD showProgress:0 status:@"写入中控" maskType:SVProgressHUDMaskTypeClear];
//            
//            isSendZKFailAndSendLast_ = NO;
//            cmdOperArr_ = [NSMutableArray arrayWithArray:cmdReadArr_];
//            self.iTimeoutCount = 1;
//            [self firstSendZkSocketOrder];
//        }
//    }
//}

#pragma mark -
#pragma mark Custom Methods

-(void)sendZkLastOrder
{
    isSendZKFailAndSendLast_ = YES;
    sendCmdDic_ = [cmdOperArr_ lastObject];
    [cmdOperArr_ removeAllObjects];
    [cmdOperArr_ addObject:sendCmdDic_];
    [self sendZkSocketOrder];
}

-(void)sendZkTryAgain
{
    [SVProgressHUD showProgress:0 status:@"写入中控" maskType:SVProgressHUDMaskTypeClear];
    
    isSendZKFailAndSendLast_ = NO;
    cmdOperArr_ = [NSMutableArray arrayWithArray:cmdReadArr_];
    self.iTimeoutCount = 1;
    [self firstSendZkSocketOrder];
}

//断开释放一个连接实例
-(void)disConnectionTCP
{
    [asyncSocket_ disconnect];
}

-(void)disConnectionUDP
{
    [udpSocket_ setDelegate:nil delegateQueue:NULL];
    [udpSocket_ close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (udpSocket_ != nil) {
        [udpSocket_ close];
        udpSocket_ = nil;
    }
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
