//
//  NetworkUtil.m
//  QLink
//
//  Created by 尤日华 on 14-9-19.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "NetworkUtil.h"
#import "DataUtil.h"

@implementation NetworkUtil

//获取基础 Url
+(NSString *)getBaseUrl
{
    Member *member = [Member getMember];
    
    return [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@",member.uName,member.uPwd,member.uKey];
}

//获取 Action = login Url
+(NSString *)getActionLogin:(NSString *)uName
                    andUPwd:(NSString *)uPwd
                    andUKey:(NSString *)uKey
{
    return [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@&action=login",uName,uPwd,uKey];
}

//注册
+(NSString *)getRegisterUrl:(NSString *)uName
                     andPwd:(NSString *)uPwd
                   andICode:(NSString *)icode
{
    return [NSString stringWithFormat:@"http://qlink.cc/zq/reg.asp?usname=%@&psword=%@&icode=%@",uName,uPwd,icode];
}

//获取 Action URL
+(NSString *)getAction:(NSString *)action
{
    return [NSString stringWithFormat:@"%@&action=%@",[self getBaseUrl],action];
}

//获取设置ip地址
+(NSString *)getSetUpIp:(NSString *)uName andPwd:(NSString *)uPwd andKey:(NSString *)uKey
{
    return [NSString stringWithFormat:@"http://qlink.cc/zq/lookmobile.asp?uname=%@&upsd=%@&passkey=%@&action=%@",uName,uPwd,uKey,ACTIONSETUPIP];
}

//修改场景名称URL
+(NSString *)getChangeSenceName:(NSString *)newName andSenceId:(NSString *)senceId
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=2&classname=macro&Id=%@&ChangVar=%@",[self getBaseUrl],senceId,newName];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

+(NSString *)handleIpRequest
{
    NSString *wifiIp = [DataUtil localWiFiIPAddress];
    wifiIp = [NSString stringWithFormat:@"TCP:%@:1234",wifiIp];
    
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=3&ChangVar=%@",[self getBaseUrl],wifiIp];
    return sUrl;
}

//修改设备名称URL
+(NSString *)getChangeDeviceName:(NSString *)newName andDeviceId:(NSString *)deviceId
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=savekfchang&dx=1&Id=%@&ChangVar=%@",[self getBaseUrl],deviceId,newName];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

//编辑场景
+(NSString *)getEditSence:(NSString *)senceId andSenceName:(NSString *)senceName andCmd:(NSString *)cmds andTime:(NSString *)times
{
    NSString *sUrl = [NSString stringWithFormat:@"%@&action=macro&macroid=%@&macroname=%@&mcmd=%@&mtime=%@",[self getBaseUrl],senceId,senceName,cmds,times];
    sUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return sUrl;
}

//删除场景
+(NSString *)getDelSence:(NSString *)senceId
{
    return [NSString stringWithFormat:@"%@&action=savekfchang&dx=4&classname=macro&Id=%@",[self getBaseUrl],senceId];
}

//删除设备
+(NSString *)getDelDevice:(NSString *)deviceId
{
    return [NSString stringWithFormat:@"%@&action=savekfchang&dx=4&Id=%@",[self getBaseUrl],deviceId];
}

@end
